import 'package:kernel/kernel.dart';

bool isHideClass(Class cls) {
  const cppClassNames = [
    "List",
    "ListBase",
    "Map",
    "MapBase",
    "Set",
    "SetBase",
    "Iterable",
    "Iterator",
    "StackTrace",
    "UnmodifiableMapView",
    "Random",
    "MapEntry"
  ];

  var libraryName = cls.enclosingLibrary.toStringInternal();
  if (libraryName.startsWith("vm") ||
      libraryName.startsWith("dart") ||
      libraryName.startsWith("library dart") ||
      libraryName.contains("cpp_collection") ||
      libraryName.contains("cpp_string")) {
    if (!cppClassNames.contains(cls.name)) {
      return true;
    }
  }
  return false;
}

void printTranslator(Component component) {
  printCppHeader();

  var classList = <Class>[];
  for (final library in component.libraries) {
    classList.addAll(library.classes);
  }
  for (final cls in classList) {
    if (isHideClass(cls)) {
      continue;
    }
    print("${getClassDeclareTypeName(cls)};");
  }

  var classMap = getClassList(classList);
  for (final cls in classList) {
    if (isHideClass(cls)) {
      continue;
    }
    print("//  " + cls.enclosingLibrary.toStringInternal());
    printClassDeclarationHeader(classMap, cls);
  }

  for (final cls in classList) {
    if (isHideClass(cls)) {
      continue;
    }
    print("//  " + cls.enclosingLibrary.toStringInternal());
    printClassDeclaration(classMap, cls);
  }
}

void printCppHeader() {
  print('''
#include <cstdio>
#include <cstdlib>
#include <sstream>
#include "src/core/func.h"
#include "src/core/num.h"
#include "src/core/string.h"
''');
}

String getClassDeclareTypeParameters(Class cls) {
  var typeParameters = cls.typeParameters.map((e) => "typename ${e.name}");
  var typeString = "";
  if (typeParameters.isNotEmpty) {
    typeString = "template<${typeParameters.join(",")}>";
  }
  return typeString;
}

String getClassDeclareTypeName(Class cls) {
  var typeString = getClassDeclareTypeParameters(cls);
  var className = getClassName(cls);
  return "$typeString class $className";
}

void printClassDeclarationHeader(Map<Class, List<ClassMember>> map, Class cls) {
  // Print class declaration with inheritance
  var typeClassName = getClassDeclareTypeName(cls);
  var superClassName = "";
  if (cls.supertype == null) {
    superClassName = typeClassName == "Object" ? "" : ": public Object";
  } else {
    var list = cls.supers.where((e) => !isHideClass(e.classNode));
    if (list.isEmpty) {
      superClassName = ": public Object";
    } else {
      superClassName =
          ": ${list.map((e) => "virtual public ${getVariableType(e.asInterfaceType)}").join(",")}";
    }
  }
  print("$typeClassName $superClassName {");
  print("public:");

  // // Print fields
  for (var field in cls!.fields) {
    var fieldString = getFieldDeclaration(field);
    print("${field.isStatic ? "static " : ""}$fieldString;");
  }

  var list = map[cls]!;
  for (var procedure in list) {
    if (procedure.member.enclosingClass == cls) {
      print(toString(procedure.member, true));
    }
  }

  var cppNewStr = '''
  static ${getClassDeclareType(cls)} cppNew();
''';
  print(cppNewStr);

  print("};");
}

void printClassDeclaration(Map<Class, List<ClassMember>> map, Class cls) {
  // Print class declaration with inheritance
  var list = map[cls];
  if (list?.isNotEmpty ?? false) {
    for (var procedure in list!) {
      if (procedure.member.enclosingClass == cls) {
        print(toString(procedure.member, false));
      }
    }
  }

  var typeString = getClassDeclareTypeParameters(cls);
  var className = getClassTypeName(cls);
  var classTypeName = getClassDeclareType(cls);

  var cppNewStr = '''
  $typeString static $classTypeName cppNew() {
        static void *functionPtrs[] = {
            ${list?.map((e) => "reinterpret_cast<void *>(&$className::${e.name})").join(",") ?? ""}
        };
        auto ptr = ($classTypeName)malloc(sizeof($className));
        ptr->vtab = functionPtrs;
        return ptr;
    }
''';
  print(cppNewStr);
}

class ClassMember {
  String name;
  int index;
  Member member;
  ClassMember(this.member, this.index) : name = getMemberName(member);
}

Map<Class, List<ClassMember>> getClassList(Iterable<Class> list) {
  var classMap = <Class, List<ClassMember>>{};
  for (var cls in list) {
    getClassMembersList(classMap, cls);
  }
  return classMap;
}

List<ClassMember> getClassMembersList(
    Map<Class, List<ClassMember>> map, Class cls) {
  if (map.containsKey(cls)) {
    return map[cls]!;
  }

  List<ClassMember> superList = [];
  if (cls.name == "Object") {
    for (var procedure in cls.procedures) {
      if (procedure.name.text == "toString") {
        replaceOrAddMembersList(superList, procedure);
      }
    }
  } else {
    if (cls.superclass != null) {
      superList = [...getClassMembersList(map, cls.superclass!)];
    }
    for (var constructor in cls.constructors) {
      replaceOrAddMembersList(superList, constructor);
    }
    for (var procedure in cls.procedures) {
      if (procedure.name.text != "_typeArguments") {
        replaceOrAddMembersList(superList, procedure);
      }
    }
  }
  map[cls] = superList;
  return superList;
}

void replaceOrAddMembersList(List<ClassMember> list, Member member) {
  var name = getMemberName(member);
  for (var i = 0; i < list.length; i++) {
    if (list[i].name == name) {
      list[i] = ClassMember(member, i);
      return;
    }
  }
  list.add(ClassMember(member, list.length));
}

final Map<String, String> typeNames = {
  "num": "Num",
  "int": "Int",
  "double": "Double",
  "bool": "Bool",
  "String": "String",
  "List": "List",
  "Map": "Map",
  "Set": "Set",
  "UnmodifiableMapView": "CppWasmMap"
};

final Map<String, String> specialNames = {
  // 算术运算符
  '+': 'cpp_add', // 加法
  '-': 'cpp_subtract', // 减法
  '*': 'cpp_multiply', // 乘法
  '/': 'cpp_divide', // 除法
  '~/': 'cpp_truncDiv', // 整除
  '%': 'cpp_modulo', // 取模
  'unary-': 'cpp_negation', // 一元减号(负号)
  '!': 'cpp_not', // !x

  // 增量运算符
  '++': 'cpp_increment', // 递增
  '--': 'cpp_decrement', // 递减

  // 位运算符
  '|': 'cpp_bitwiseOr', // 按位或
  '&': 'cpp_bitwiseAnd', // 按位与
  '^': 'cpp_bitwiseXor', // 按位异或
  '~': 'cpp_bitwiseNot', // 按位取反(一元)
  '<<': 'cpp_leftShift', // 左移
  '>>': 'cpp_rightShift', // 右移

  // 关系运算符
  '==': 'cpp_equals', // 相等
  '>': 'cpp_greaterThan', // 大于
  '<': 'cpp_lessThan', // 小于
  '>=': 'cpp_greaterThanOrEqual', // 大于等于
  '<=': 'cpp_lessThanOrEqual', // 小于等于

  // 索引运算符
  '[]': 'cpp_subscript', // 获取索引元素
  '[]=': 'cpp_subscriptAssign', // 设置索引元素

  //特殊函数名
  'union': "cpp_union"
};

bool isFinalClassType(String name) {
  const Set<String> classNames = {'Int', 'Double', 'Num', 'Bool', 'String'};
  return classNames.contains(name);
}

String getClassName(Class classInfo) {
  var name = classInfo.name.replaceAll("&", r"$");
  if (typeNames.containsKey(name)) {
    name = typeNames[name]!;
  }
  return name;
}

String getClassTypeName(Class classInfo) {
  var typeParametersStr = "";
  if (classInfo.typeParameters.isNotEmpty) {
    typeParametersStr =
        "<${classInfo.typeParameters.map((e) => "${e.name}").join(",")}>";
  }
  return "${getClassName(classInfo)}$typeParametersStr";
}

String getMemberName(Member member) {
  if (member is Constructor) {
    return "cppCtr_${member.name.text}";
  }

  var memberName = member.name.text;
  if (member is Procedure) {
    if (member.isGetter) {
      return "cppGet_${member.name.text}";
    } else if (member.isSetter) {
      return "cppSet_${member.name.text}";
    }
  }
  if (memberName.isEmpty) {
    return "cppEpt_";
  }

  return specialNames.containsKey(memberName)
      ? specialNames[memberName]!
      : memberName;
}

String getMemberInvokeName(Member member) {
  var className = getClassName(member.enclosingClass!);
  var memberName = getMemberName(member);
  // if (className == "Num" ||
  //     className == "Double" ||
  //     className == "Int" ||
  //     className == "Bool" ||
  //     className == "String") {
  //   return "Class_$className::$memberName";
  // }
  return "$className::$memberName";
}

//获取参数类型
String getVariableType(DartType type) {
  if (type is InterfaceType) {
    var typeParameters =
        type.typeArguments.map((e) => getVariableDeclareType(e));
    var name = getClassName(type.classNode);
    return name +
        (typeParameters.isNotEmpty ? "<${typeParameters.join(",")}>" : "");
  } else if (type is FunctionType) {
    var parameters = [
      getVariableType(type.returnType),
      ...type.positionalParameters
          .map((parameter) => getVariableDeclareType(parameter)),
      ...type.namedParameters
          .map((parameter) => getVariableDeclareType(parameter.type))
    ];
    return "Function";
    //return "Function<${parameters.join(", ")}>";
  } else if (type is DynamicType) {
    return "void*";
  } else if (type is FutureOrType) {
    return getVariableType(type.typeArgument);
  } else if (type is NeverType) {
    return "void";
  } else if (type is InvalidType) {
    return "void*";
  } else if (type is DynamicType) {
    return "void*";
  } else if (type is VoidType) {
    return "void";
  } else if (type is TypeParameterType) {
    return "Object*";
  } else if (type is NullType) {
    return "Object*";
  } else {
    return "void*";
  }
}

String getClassDeclareType(Class cls) {
  var className = getClassTypeName(cls);
  return "$className *";
}

String getVariableDeclareType(DartType type) {
  if (type is TypeParameterType) {
    var name = type.parameter.name ?? "void*";
    return name;
  }
  var typeStr = getVariableType(type);
  if (typeStr == "void") {
    return typeStr;
  }
  return (type.nullability == Nullability.nullable)
      ? "$typeStr *"
      : "$typeStr *";
}

String getFieldDeclaration(Field field) {
  return "${getVariableDeclareType(field.type)} ${field.name.text}";
}

String getVariableDeclaration(VariableDeclaration variableDeclaration) {
  return "${getVariableDeclareType(variableDeclaration.type)} ${variableDeclaration.name}";
}

String toString(TreeNode statement, bool isHeader) {
  if (statement is Constructor) {
    return (CppCodePrinter()
          ..isHeader = isHeader
          ..writeConstructorDeclaration(statement)
          ..writeNewline())
        .getText();
  } else if (statement is Procedure) {
    return (CppCodePrinter()
          ..isHeader = isHeader
          ..writeMemberFunctionDeclaration(statement)
          ..writeNewline())
        .getText();
  } else if (statement is Statement) {
    return (CppCodePrinter()
          ..isHeader = isHeader
          ..writeStatement(statement)
          ..writeNewline())
        .getText();
  } else if (statement is Expression) {
    return (CppCodePrinter()
          ..isHeader = isHeader
          ..writeExpression(statement))
        .getText();
  }
  return "void";
}

class CppCodePrinter {
  final Map<LabeledStatement, String> _labelNames = {};
  final Map<VariableDeclaration, String> _variableNames = {};
  final List<VariableDeclaration> _letNames = [];

  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;
  bool isHeader = false;

  String getText() {
    return _buffer.toString();
  }

  void write(String text) {
    _buffer.write(text);
  }

  void writeNewline() {
    _buffer.write('\n');
    _buffer.write('  ' * _indentLevel);
  }

  void indent() {
    _indentLevel++;
  }

  void unindent() {
    _indentLevel--;
  }

  String logicalExpressionOperatorToString(LogicalExpressionOperator operator) {
    return specialNames.containsKey(operator.name)
        ? specialNames[operator.name]!
        : operator.name;
  }

  String getVariableName(VariableDeclaration variable, {bool isLet = false}) {
    if (variable.name != null) {
      return variable.name == "this" ? "cppThis" : variable.name!;
    }

    if (_variableNames[variable] != null) {
      return _variableNames[variable]!;
    }
    var name = "cppLet_${_letNames.length}";
    _variableNames[variable] = name;
    // _variableNames[variable] =
    //     "std::any_cast<${getVariableDeclareType(variable.type)}>($name)";
    // return isLet ? name : _variableNames[variable]!;
    return name;
  }

  getTypeParametersDiff(Class cls, List<TypeParameter> typeParameters) {
    var nameSet = <String>{};
    for (var t in cls.typeParameters) {
      nameSet.add(t.name!);
    }

    var types = <String>[];
    for (var t in typeParameters) {
      if (!nameSet.contains(t.name!)) {
        types.add("typename ${t.name}");
      }
    }
    return types.isEmpty ? "" : "template<${types.join(",")}>";
  }

  void writeMemberFunctionDeclaration(Procedure procedure) {
    FunctionNode function = procedure.function;
    String name = getMemberName(procedure);
    String ownerClassType = getClassDeclareType(procedure.enclosingClass!);

    var typeStr = getTypeParametersDiff(
        procedure.enclosingClass!, function.typeParameters);
    if (isHeader) {
      write(
          "$typeStr static ${getVariableDeclareType(function.returnType)} $name");
      writeParametersList(function,
          ownerClassType: procedure.isStatic ? "" : ownerClassType);
      write(";");

      return;
    }

    var typeString = getClassDeclareTypeParameters(procedure.enclosingClass!);
    var className = getClassTypeName(procedure.enclosingClass!);
    write(
        "$typeStr $typeString ${getVariableDeclareType(function.returnType)} $className::$name");
    writeParametersList(function,
        ownerClassType: procedure.isStatic ? "" : ownerClassType);
    if (function.body is Block) {
      writeStatement(function.body!);
    } else {
      write("{");
      if (function.body != null) {
        writeStatement(function.body!);
      }
      write("}");
    }
  }

  void writeFunctionDeclaration(FunctionNode function) {
    write("[&]");
    writeParametersList(function);
    write(" -> ${getVariableDeclareType(function.returnType)}");
    if (function.body is Block) {
      writeStatement(function.body!);
    } else {
      write("{");
      if (function.body != null) {
        writeStatement(function.body!);
      }
      write("}");
    }
  }

  void writeConstructorDeclaration(Constructor constructor) {
    FunctionNode function = constructor.function;

    var typeStr = getTypeParametersDiff(
        constructor.enclosingClass, function.typeParameters);

    if (isHeader) {
      var classType = getClassDeclareType(constructor.enclosingClass);
      write("$typeStr static $classType ${getMemberName(constructor)}");
      writeParametersList(constructor.function, ownerClassType: classType);
      write(";");
      return;
    }

    var typeString = getClassDeclareTypeParameters(constructor.enclosingClass!);
    var className = getClassTypeName(constructor.enclosingClass!);
    var classType = getClassDeclareType(constructor.enclosingClass);
    write(
        "$typeStr $typeString $classType $className::${getMemberName(constructor)}");
    writeParametersList(constructor.function, ownerClassType: classType);
    write('{');
    indent();

    if (constructor.initializers.isNotEmpty) {
      for (var initializer in constructor.initializers) {
        if (initializer is FieldInitializer) {
          write('cppThis->${initializer.field.name.text} = ');
          writeExpression(initializer.value);
          write(';');
        }
      }
    }
    if (function.body != null) {
      if (function.body is Block) {
        var statement = function.body as Block;
        for (var stmt in statement.statements) {
          writeStatement(stmt);
        }
      } else {
        writeStatement(function.body!);
      }
    }
    writeNewline();
    write("return cppThis;");
    unindent();
    write('}');
  }

  void writeVariableDeclaration(VariableDeclaration variable) {
    write("${getVariableDeclareType(variable.type)} ");
    write(getVariableName(variable));
    if (variable.initializer != null) {
      write(' = ');
      writeExpression(variable.initializer!);
    }
  }

  void writeStatement(Statement statement) {
    writeNewline();
    if (statement is EmptyStatement) {
      write(' ');
    } else if (statement is Block) {
      write('{');
      indent();
      for (var stmt in statement.statements) {
        writeStatement(stmt);
      }
      unindent();
      writeNewline();
      write('}');
    } else if (statement is SwitchStatement) {
      write('switch (');
      writeExpression(statement.expression);
      write(') {');
      indent();
      for (var switchCase in statement.cases) {
        if (switchCase.isDefault) {
          write('default: {');
        } else {
          write('case ');
          writeExpression(switchCase.expressions.first);
          write(': {');
        }
        indent();
        if (switchCase.body is Block) {
          Block block = switchCase.body as Block;
          for (var stmt in block.statements) {
            writeStatement(stmt);
          }
        } else {
          writeStatement(switchCase.body);
        }
        unindent();
        write('}');
      }
      unindent();
      write('}');
    } else if (statement is LabeledStatement) {
      // Skip label for now
      writeStatement(statement.body);
    } else if (statement is ExpressionStatement) {
      writeExpression(statement.expression);
      write(';');
    } else if (statement is ReturnStatement) {
      write('return');
      if (statement.expression != null) {
        write(' ');
        writeExpression(statement.expression!);
      }
      write(';');
    } else if (statement is IfStatement) {
      write('if (');
      writeExpression(statement.condition);
      write(') ');
      writeStatement(statement.then);
      if (statement.otherwise != null) {
        write(' else ');
        writeStatement(statement.otherwise!);
      }
    } else if (statement is BreakStatement) {
      write('break');
      write(';');
    } else if (statement is ContinueSwitchStatement) {
      write('continue');
      write(';');
    } else if (statement is VariableDeclaration) {
      write('${getVariableDeclareType(statement.type)} ');
      write(getVariableName(statement));
      if (statement.initializer != null) {
        write(' = ');
        writeExpression(statement.initializer!);
      }
      write(';');
    } else if (statement is WhileStatement) {
      write('while (');
      writeExpression(statement.condition);
      write(') ');
      writeStatement(statement.body);
    } else if (statement is ForStatement) {
      write('for (');
      if (statement.variables.isNotEmpty) {
        for (var variable in statement.variables) {
          writeVariableDeclaration(variable);
          if (variable != statement.variables.last) {
            write(',');
          }
        }
      }
      write('; ');
      if (statement.condition != null) {
        writeExpression(statement.condition!);
      }
      write('; ');
      if (statement.updates.isNotEmpty) {
        for (var update in statement.updates) {
          writeExpression(update);
          if (update != statement.updates.last) {
            write(',');
          }
        }
      }
      write(') ');
      writeStatement(statement.body);
    } else if (statement is DoStatement) {
      write('do ');
      writeStatement(statement.body);
      write(' while (');
      writeExpression(statement.condition);
      write(');');
    } else if (statement is TryFinally) {
      write('try{ ');
      writeStatement(statement.body);
      write('}finally {');
      writeStatement(statement.finalizer);
      write('};');
    } else if (statement is AssertStatement) {
      write('print("assert");');
    } else if (statement is FunctionDeclaration) {
      write('${getVariableDeclareType(statement.variable.type)} ');
      write(getVariableName(statement.variable));
      write(' = ');
      writeFunctionDeclaration(statement.function);
      write(';');
    } else {
      print('Unhandled statement type: ${statement.runtimeType}');
    }
  }

  void writeExpression(Expression expression) {
    if (expression is ListLiteral) {
      var typeArgument = getVariableDeclareType(expression.typeArgument);
      var cppListType = "CppWasmList<$typeArgument>";
      write('$cppListType::cppCtr_fromCppWasmArray(');
      write('$cppListType::cppNew()');
      write(',');
      write('CppWasmArray<$typeArgument>::cppInitializer({');
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write('})');
      write(')');
    } else if (expression is MapLiteral) {
      var keyTypeArgument = getVariableDeclareType(expression.keyType);
      var valueTypeArgument = getVariableDeclareType(expression.keyType);
      var cppMapType = "CppWasmMap<$keyTypeArgument,$valueTypeArgument>";
      write('$cppMapType::cppCtr_fromCppWasmArray(');
      write('$cppMapType::cppNew()');
      write(',');
      write(
          'CppWasmArray<MapEntry<$keyTypeArgument,$valueTypeArgument>>::cppInitializer({');
      bool first = true;
      for (var entry in expression.entries) {
        if (!first) write(', ');
        first = false;
        write('MapEntry<<$keyTypeArgument,$valueTypeArgument>::cppNew(');
        writeExpression(entry.key);
        write(', ');
        writeExpression(entry.value);
        write(')');
      }
      write('}))');
    } else if (expression is SetLiteral) {
      var typeArgument = getVariableDeclareType(expression.typeArgument);
      var cppSetType = "CppWasmSet<$typeArgument>";
      write('$cppSetType::cppCtr_fromCppWasmArray(');
      write('$cppSetType::cppNew()');
      write(',');
      write('CppWasmArray<$typeArgument>::cppInitializer({');
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write('}))');
    } else if (expression is LocalFunctionInvocation) {
      writeStatement(expression.variable);
      writeArgumentsList(
          expression.localFunction.function, expression.arguments);
    } else if (expression is StaticGet) {
    } else if (expression is FunctionInvocation) {
      write(expression.name.text);
      //todo
      // writeArgumentsList(
      //     expression.functionType.function, expression.arguments);
    } else if (expression is ConstructorInvocation) {
      var classType = getVariableType(expression.constructedType);
      write("$classType::${getMemberName(expression.target)}");
      writeArgumentsList(expression.target.function, expression.arguments,
          prefixStr: "$classType::cppNew()");
    } else if (expression is ConstantExpression) {
      write(getConstant(expression.constant));
    } else if (expression is LogicalExpression) {
      writeExpression(expression.left);
      write(' ');
      write(logicalExpressionOperatorToString(expression.operatorEnum));
      write(' ');
      writeExpression(expression.right);
    } else if (expression is IntLiteral) {
      write("Int::cppNew(");
      write(expression.value.toString());
      write(")");
    } else if (expression is DoubleLiteral) {
      write("Double::cppNew(");
      write(expression.value.toString());
      write(")");
    } else if (expression is StringLiteral) {
      write("String::cppNew(");
      write('"${expression.value}"');
      write(',');
      write('sizeof("${expression.value}")');
      write(")");
    } else if (expression is BoolLiteral) {
      write("Bool::cppNew(");
      write(expression.value.toString());
      write(")");
    } else if (expression is NullLiteral) {
      write("nullptr");
    } else if (expression is VariableSet) {
      write(getVariableName(expression.variable));
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is VariableGet) {
      write(getVariableName(expression.variable));
    } else if (expression is ThisExpression) {
      write("cppThis");
    } else if (expression is InstanceGet) {
      if (expression.interfaceTarget is Procedure) {
        var procedure = expression.interfaceTarget as Procedure;
        write(getMemberInvokeName(procedure));
        write("(");
        writeExpression(expression.receiver);
        write(")");
      } else {
        writeExpression(expression.receiver);
        write("->");
        write(expression.name.text);
      }
    } else if (expression is InstanceSet) {
      writeExpression(expression.receiver);
      write("->");
      write(expression.name.text);
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is StaticInvocation) {
      write(expression.target.name.text);
      writeArgumentsList(expression.target.function, expression.arguments);
    } else if (expression is InstanceInvocation) {
      write(getMemberInvokeName(expression.interfaceTarget));
      writeArgumentsList(
          expression.interfaceTarget.function, expression.arguments,
          prefix: expression.receiver);
    } else if (expression is StaticGet) {
      write(expression.target.name.text);
    } else if (expression is StaticSet) {
      write(expression.target.name.text);
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is EqualsCall) {
      writeExpression(expression.left);
      write(" == ");
      writeExpression(expression.right);
    } else if (expression is AsExpression) {
      writeExpression(expression.operand);
      write(" as ");
      write(getVariableDeclareType(expression.type));
    } else if (expression is IsExpression) {
      writeExpression(expression.operand);
      write(" is ");
      write(getVariableDeclareType(expression.type));
    } else if (expression is ConditionalExpression) {
      write('(');
      writeExpression(expression.condition);
      write(') ? ');
      writeExpression(expression.then);
      write(' : ');
      writeExpression(expression.otherwise);
    } else if (expression is BlockExpression) {
      // write('[&]{');
      var statement = expression.body;
      for (var stmt in statement.statements) {
        writeStatement(stmt);
      }
      write('return ');
      writeExpression(expression.value);
      // write('}()');
    } else if (expression is Let) {
      write(
          '([](${getVariableDeclareType(expression.variable.type)} ${getVariableName(expression.variable)}){');
      var statement = expression.body;
      if (statement is BlockExpression) {
        for (var stmt in statement.body.statements) {
          writeStatement(stmt);
        }
        write("return ${getVariableName(expression.variable)};");
      } else {
        write('return ');
        writeExpression(statement);
        write(';');
      }
      write('}(');
      if (expression.variable.initializer == null) {
        write("null");
      } else {
        writeExpression(expression.variable.initializer!);
      }
      write('))');
    } else if (expression is FunctionExpression) {
      writeFunctionDeclaration(expression.function);
    } else if (expression is StringConcatenation) {
      for (int i = 0; i < expression.expressions.length - 1; i++) {
        write("String");
        write("::");
        write(specialNames["+"]!);
        write("(");
      }
      bool first = true;
      for (var exp in expression.expressions) {
        if (!first) write(" , ");
        first = false;
        writeExpression(exp);
      }
      for (int i = 0; i < expression.expressions.length - 1; i++) {
        write(")");
      }
    } else if (expression is Not) {
      write("Class_Bool");
      write("::");
      write(specialNames["!"]!);
      write("(");
      writeExpression(expression.operand);
      write(")");
    } else if (expression is Throw) {
      write("throw");
      write(" ");
      writeExpression(expression.expression);
    } else if (expression is EqualsNull) {
      writeExpression(expression.expression);
      write(".");
      write("isNull()");
    } else if (expression is NullCheck) {
      writeExpression(expression.operand);
    } else if (expression is SuperPropertyGet) {
      if (expression.interfaceTarget is Procedure) {
        var procedure = expression.interfaceTarget as Procedure;
        write(getMemberInvokeName(procedure));
        write("()");
      } else {
        write("cppThis");
        write("->");
        write(expression.name.text);
      }
    } else if (expression is SuperPropertySet) {
      if (expression.interfaceTarget is Procedure) {
        var procedure = expression.interfaceTarget as Procedure;
        write(getMemberInvokeName(procedure));
        write("(");
        writeExpression(expression.value);
        write(")");
      } else {
        write("cppThis");
        write("->");
        write(expression.name.text);
        write(" = ");
        writeExpression(expression.value);
      }
    } else if (expression is SuperMethodInvocation) {
      write(getMemberInvokeName(expression.interfaceTarget));
      writeArgumentsList(
          expression.interfaceTarget.function, expression.arguments,
          prefixStr: "cppThis");
    } else {
      // Handle other expression types
      print('Unhandled expression type: ${expression.runtimeType}');
    }
  }

  void writeParametersList(FunctionNode function,
      {String ownerClassType = ""}) {
    write('(');
    bool first = true;
    if (ownerClassType.isNotEmpty) {
      first = false;
      write("$ownerClassType cppThis");
    }
    var positionalParameters = function.positionalParameters;
    for (var i = 0; i < positionalParameters.length; i++) {
      if (!first) {
        write(", ");
      }
      first = false;
      var parameter = positionalParameters[i];
      write(getVariableDeclareType(parameter.type));
      write(" ");
      write(parameter.name!);
    }

    var namedArguments = function.namedParameters;
    for (var i = 0; i < namedArguments.length; i++) {
      if (!first) {
        write(", ");
      }
      first = false;
      var namedParameter = namedArguments[i];
      write(getVariableDeclareType(namedParameter.type));
      write(" ");
      write(namedParameter.name!);
    }
    write(')');
  }

  void writeArgumentsList(FunctionNode function, Arguments arguments,
      {Expression? prefix, String? prefixStr}) {
    bool first = true;
    write('(');
    if (prefixStr != null) {
      first = false;
      write(prefixStr);
    } else if (prefix != null) {
      first = false;
      writeExpression(prefix);
    }

    var positionalParameters = function.positionalParameters;
    for (var i = 0; i < positionalParameters.length; i++) {
      if (!first) {
        write(", ");
      }
      first = false;

      if (i < arguments.positional.length) {
        writeExpression(arguments.positional[i]);
      } else {
        if (positionalParameters[i].initializer != null) {
          writeExpression(positionalParameters[i].initializer!);
        } else {
          write("nullptr");
        }
      }
    }

    var namedArguments =
        Map.fromEntries(arguments.named.map((e) => MapEntry(e.name, e)));
    var namedParameters = function.namedParameters;
    for (var i = 0; i < namedParameters.length; i++) {
      if (!first) {
        write(", ");
      }
      first = false;
      var namedParameter = namedParameters[i];
      if (namedArguments.containsKey(namedParameter.name)) {
        writeExpression(namedArguments[namedParameter.name]!.value);
      } else {
        if (namedParameter.initializer != null) {
          writeExpression(namedParameter.initializer!);
        } else {
          write("nullptr");
        }
      }
    }

    write(')');
  }

  String getConstant(Constant c) {
    if (c is IntConstant) {
      return "Int::cppNew(${c.value})";
    } else if (c is DoubleConstant) {
      return "Double::cppNew(${c.value})";
    } else if (c is BoolConstant) {
      return "Bool::cppNew(${c.value})";
    } else if (c is StringConstant) {
      return 'String::cppNew("${c.value}",sizeof("${c.value}"))';
    }
    return "AA<" + c.toStringInternal() + ">AA";
  }
}

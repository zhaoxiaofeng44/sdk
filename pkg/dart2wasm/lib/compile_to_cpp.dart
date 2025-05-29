import 'dart:math';

import 'package:kernel/kernel.dart';

import 'class_info.dart';
import 'translator.dart';

void printTranslator(Translator translator) {
  printCppHeader();

  var classMap = getClassList(translator.classInfo.values);
  for (final classInfo in translator.classInfo.values) {
    if (classInfo.cls?.name.startsWith("Cy") ?? false) {
      printClassDeclaration(classMap, classInfo);
    }
  }
}

void printCppHeader() {
  print('''
#include <string>
#include <iostream>
#include <memory>
#include <vector>
#include <map>
#include <set>
''');
}

void printClassDeclaration(
    Map<Class, List<ClassMember>> map, ClassInfo classInfo) {
  // Print class header with template parameters if any
  var typeParameters =
      classInfo.cls?.typeParameters.map((e) => "typename ${e.name}");
  if (typeParameters?.isNotEmpty ?? false) {
    print("template<${typeParameters!.join(",")}>");
  }

  // Print class declaration with inheritance
  var className = classInfo.cls!.name.replaceAll("&", r"$");
  var superClassName = "";
  if (classInfo.cls!.supertype == null) {
    superClassName = className == "Object" ? "" : "Object";
  } else {
    superClassName = getVariableType(classInfo.cls!.supertype!.asInterfaceType);
  }
  print("class $className : public $superClassName {");
  print("public:");

  // // Print fields
  for (var field in classInfo.cls!.fields) {
    var fieldString = getFieldDeclaration(field);
    print("${field.isStatic ? "static " : ""}$fieldString;");
  }

  // Print constructors
  for (var constructor in classInfo.cls!.constructors) {
    print(toString(constructor));
  }

  // Print methods
  for (var procedure in classInfo.cls!.procedures) {
    if (procedure.name.text != "_typeArguments") {
      print(toString(procedure));
    }
  }

  var list = map[classInfo.cls]!;
  // for (var item in list) {
  //   print("index ${item.index}  =>  ${item.name}");
  // }

  // var templateStr =
  //     classInfo.cls?.typeParameters.map((e) => "${e.name}").join(",");
  // var cppClassName = "$className<$templateStr>";
  var cppNewStr = '''
  static AnyPtr<$className> cppNew() {
        static void *functionPtrs[] = {
            ${list.map((e) => "reinterpret_cast<void *>(&$className::${e.name})").join(",")}
        };
        auto ptr = ($className *)malloc(sizeof($className));
        ptr->vtab = functionPtrs;
        return AnyPtr<$className>(ptr);
    }
''';
  print(cppNewStr);

  print("};");
}

class ClassMember {
  String name;
  int index;
  Member member;
  ClassMember(this.member, this.index) : name = getMemberName(member);
}

Map<Class, List<ClassMember>> getClassList(Iterable<ClassInfo> list) {
  var classMap = <Class, List<ClassMember>>{};
  for (var classInfo in list) {
    getClassMembersList(classMap, classInfo.cls!);
  }
  return classMap;
}

List<ClassMember> getClassMembersList(
    Map<Class, List<ClassMember>> map, Class cls) {
  if (map.containsKey(cls)) {
    return map[cls]!;
  }
  List<ClassMember> superList = [];
  if (cls.superclass != null) {
    superList = [...getClassMembersList(map, cls.superclass!)];
  }
  for (var constructor in cls.constructors) {
    replaceOrAddMembersList(superList, constructor);
  }
  for (var procedure in cls.procedures) {
    replaceOrAddMembersList(superList, procedure);
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
  "List": "CppWasmList",
  "Map": "CppWasmMap",
  "Set": "CppWasmSet",
};

final Map<String, String> operatorNames = {
  // 算术运算符
  '+': 'add', // 加法
  '-': 'subtract', // 减法
  '*': 'multiply', // 乘法
  '/': 'divide', // 除法
  '~/': 'truncDiv', // 整除
  '%': 'modulo', // 取模
  'unary-': 'negation', // 一元减号(负号)
  '!': 'not', // !x

  // 增量运算符
  '++': 'increment', // 递增
  '--': 'decrement', // 递减

  // 位运算符
  '|': 'bitwiseOr', // 按位或
  '&': 'bitwiseAnd', // 按位与
  '^': 'bitwiseXor', // 按位异或
  '~': 'bitwiseNot', // 按位取反(一元)
  '<<': 'leftShift', // 左移
  '>>': 'rightShift', // 右移

  // 关系运算符
  '==': 'equals', // 相等
  '>': 'greaterThan', // 大于
  '<': 'lessThan', // 小于
  '>=': 'greaterThanOrEqual', // 大于等于
  '<=': 'lessThanOrEqual', // 小于等于

  // 索引运算符
  '[]': 'subscript', // 获取索引元素
  '[]=': 'subscriptAssign', // 设置索引元素
};

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
    } else if (member.kind == ProcedureKind.Operator) {
      if (operatorNames.containsKey(memberName)) {
        return "cppOpr_${operatorNames[memberName]}";
      }
    }
  }
  return memberName;
}

String getMemberInvokeName(Member member) {
  var className = getClassName(member.enclosingClass!);
  var memberName = getMemberName(member);

  return "Class_$className::$memberName";
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
    return "Function<${parameters.join(", ")}>";
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
  return "AnyPtr<$className>";
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
      ? "AnyPtr<$typeStr,true>"
      : "AnyPtr<$typeStr>";
}

String getFieldDeclaration(Field field) {
  return "${getVariableDeclareType(field.type)} ${field.name.text}";
}

String getVariableDeclaration(VariableDeclaration variableDeclaration) {
  return "${getVariableDeclareType(variableDeclaration.type)} ${variableDeclaration.name}";
}

String toString(TreeNode statement) {
  if (statement is Constructor) {
    return (CppCodePrinter()
          ..writeConstructorDeclaration(statement)
          ..writeNewline())
        .getText();
  } else if (statement is Procedure) {
    return (CppCodePrinter()
          ..writeMemberFunctionDeclaration(statement)
          ..writeNewline())
        .getText();
  } else if (statement is Statement) {
    return (CppCodePrinter()
          ..writeStatement(statement)
          ..writeNewline())
        .getText();
  } else if (statement is Expression) {
    return (CppCodePrinter()
          ..writeExpression(statement)
          ..writeNewline())
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
    return operatorNames[operator.name] ?? operator.name;
  }

  String getFunctionName(String name) {
    return name.replaceAll('.', '_');
  }

  String getMethodName(Member member) {
    return member.name.text;
  }

  String getVariableName(VariableDeclaration variable, {bool isLet = false}) {
    if (variable.name != null) {
      return variable.name == "this" ? "cppThis" : variable.name!;
    }
    if (_variableNames[variable] != null) {
      return _variableNames[variable]!;
    }
    var name = "cppLet_${_letNames.length}";
    _variableNames[variable] =
        "std::any_cast<${getVariableDeclareType(variable.type)}>($name)";
    return isLet ? name : _variableNames[variable]!;
  }

  void writeMemberFunctionDeclaration(Procedure procedure) {
    writeFunctionDeclaration(procedure.function, getMemberName(procedure),
        isStatic: procedure.isStatic,
        ownerClassType: getClassDeclareType(procedure.enclosingClass!));
  }

  void writeFunctionDeclaration(FunctionNode function, String name,
      {bool isStatic = false, String ownerClassType = ""}) {
    write("static ${getVariableDeclareType(function.returnType)} $name");
    writeParametersList(function, ownerClassType: ownerClassType);
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
    var classType = getClassDeclareType(constructor.enclosingClass);
    write("static $classType ${getMemberName(constructor)}");
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
    } else {
      print('Unhandled statement type: ${statement.runtimeType}');
    }
  }

  void writeExpression(Expression expression) {
    if (expression is ListLiteral) {
      var typeArgument = getVariableDeclareType(expression.typeArgument);
      var cppListType = "CppWasmList<$typeArgument>";
      write(
          '(($cppListType*)malloc(sizeof($cppListType)))->fromCppWasmArray(cppWasmArray<$typeArgument>({');
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write('}))');
    } else if (expression is MapLiteral) {
      var keyTypeArgument = getVariableDeclareType(expression.keyType);
      var valueTypeArgument = getVariableDeclareType(expression.keyType);
      var cppMapType = "CppWasmMap<$keyTypeArgument,$valueTypeArgument>";
      write(
          '(($cppMapType*)malloc(sizeof($cppMapType)))->fromCppWasmArray(cppWasmArray<MapEntry<<$keyTypeArgument,$valueTypeArgument>>({');
      bool first = true;
      for (var entry in expression.entries) {
        if (!first) write(', ');
        first = false;
        write('new MapEntry<<$keyTypeArgument,$valueTypeArgument>(');
        writeExpression(entry.key);
        write(', ');
        writeExpression(entry.value);
        write(')');
      }
      write('}))');
    } else if (expression is SetLiteral) {
      var typeArgument = getVariableDeclareType(expression.typeArgument);
      var cppSetType = "CppWasmList<$typeArgument>";
      write(
          '(($cppSetType*)malloc(sizeof($cppSetType)))->fromCppWasmArray(cppWasmArray<$typeArgument>({');
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
      write(getMemberInvokeName(expression.target));
      writeArgumentsList(expression.target.function, expression.arguments,
          prefixStr:
              "cppNew<${getClassTypeName(expression.target.enclosingClass)}>()");
    } else if (expression is ConstantExpression) {
      write(expression.constant.toStringInternal());
    } else if (expression is LogicalExpression) {
      writeExpression(expression.left);
      write(' ');
      write(logicalExpressionOperatorToString(expression.operatorEnum));
      write(' ');
      writeExpression(expression.right);
    } else if (expression is IntLiteral) {
      write(expression.value.toString());
    } else if (expression is DoubleLiteral) {
      write(expression.value.toString());
    } else if (expression is StringLiteral) {
      write('"${expression.value}"');
    } else if (expression is BoolLiteral) {
      write(expression.value.toString());
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
      writeExpression(expression.receiver);
      write(".");
      write(expression.name.text);
    } else if (expression is InstanceSet) {
      writeExpression(expression.receiver);
      write(".");
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
      write('[&]{');
      var statement = expression.body;
      for (var stmt in statement.statements) {
        writeStatement(stmt);
      }
      write('return ');
      writeExpression(expression.value);
      write('}()');
    } else if (expression is Let) {
      _letNames.add(expression.variable);
      write('(');
      write(getVariableName(expression.variable, isLet: true));
      if (expression.variable.initializer != null) {
        write(' = ');
        writeExpression(expression.variable.initializer!);
      }
      var statement = expression.body;
      expression.body.toStringInternal();
      if (statement is BlockExpression) {
        for (var stmt in statement.body.statements) {
          write(',');
          writeStatement(stmt);
        }
        write(')');
      } else {
        write(',');
        writeExpression(statement);
        write(')');
      }
      _letNames.remove(expression.variable);
      if (_letNames.isEmpty) {
        _labelNames.clear();
      }
    } else if (expression is FunctionExpression) {
      write('[](');
      bool first = true;
      for (var parameter in expression.function.positionalParameters) {
        if (!first) write(", ");
        first = false;
        write(getVariableDeclaration(parameter));
      }
      for (var parameter in expression.function.namedParameters) {
        if (!first) write(", ");
        first = false;
        write(getVariableDeclaration(parameter));
      }
      write(')');
      if (expression.function.body is Block) {
        writeStatement(expression.function.body!);
      } else {
        write('{');
        indent();
        writeStatement(expression.function.body!);
        unindent();
        write('}');
      }
    } else if (expression is StringConcatenation) {
      bool first = true;
      for (var exp in expression.expressions) {
        if (!first) write(" + ");
        first = false;
        writeExpression(exp);
      }
    } else if (expression is Not) {
      write("Class_Bool");
      write("::");
      write("cppOpr_${operatorNames["!"]}");
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
}

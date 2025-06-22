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

  if (cls.name == "CppArray") {
    return true;
  }
  return false;
}

void printTranslator(Component component) {
  var printer = CppCodePrinter();
  printer.translateComponent(component);
}

class ClassMember {
  String name;
  int index;
  Member member;
  ClassMember(this.member, this.index) : name = getMemberName(member);
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
  if (member.enclosingClass != null) {
    var className = getClassName(member.enclosingClass!);
    var memberName = getMemberName(member);
    return "$className::$memberName";
  }
  return getMemberName(member);
}

class CppCodePrinter {
  final Map<LabeledStatement, String> _labelNames = {};
  final Map<VariableDeclaration, String> _variableNames = {};
  final List<VariableDeclaration> _letNames = [];

  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;
  bool isHeader = false;

  // 主要翻译入口方法
  void translateComponent(Component component) {
    _printCppHeader();

    var classList = <Class>[];
    for (final library in component.libraries) {
      classList.addAll(library.classes);
    }

    // 打印前置声明
    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }
      print("${_getClassDeclareTypeName(cls)};");
    }

    var classMap = _getClassList(classList);

    // 打印类声明头部
    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }
      print("//  " + cls.enclosingLibrary.toStringInternal());
      _printClassDeclarationHeader(classMap, cls);
    }

    // 打印类实现
    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }
      print("//  " + cls.enclosingLibrary.toStringInternal());
      _printClassDeclaration(classMap, cls);
    }
  }

  // 打印C++头文件
  void _printCppHeader() {
    print('''
#include <cstdio>
#include <cstdlib>
#include <sstream>
#include "src/core/func.h"
#include "src/core/num.h"
#include "src/core/string.h"
''');
  }

  // 获取类声明类型参数
  String _getClassDeclareTypeParameters(Class cls) {
    var typeParameters = cls.typeParameters.map((e) => "typename ${e.name}");
    var typeString = "";
    if (typeParameters.isNotEmpty) {
      typeString = "template<${typeParameters.join(",")}>";
    }
    return typeString;
  }

  // 获取类声明类型名称
  String _getClassDeclareTypeName(Class cls) {
    var typeString = _getClassDeclareTypeParameters(cls);
    var className = getClassName(cls);
    return "$typeString class $className";
  }

  // 获取类声明类型
  String _getClassDeclareType(Class cls) {
    var className = getClassTypeName(cls);
    return "$className *";
  }

  // 打印类声明头部
  void _printClassDeclarationHeader(
      Map<Class, List<ClassMember>> map, Class cls) {
    // Print class declaration with inheritance
    var typeClassName = _getClassDeclareTypeName(cls);
    var superClassName = "";
    if (cls.supertype == null) {
      superClassName = typeClassName == "Object" ? "" : ": public Object";
    } else {
      var list = cls.supers.where((e) => !isHideClass(e.classNode));
      if (list.isEmpty) {
        superClassName = ": public Object";
      } else {
        superClassName =
            ": ${list.map((e) => "virtual public ${_getVariableType(e.asInterfaceType)}").join(",")}";
      }
    }
    print("$typeClassName $superClassName {");
    print("public:");

    // Print fields
    for (var field in cls!.fields) {
      var fieldString = _getFieldDeclaration(field);
      print("${field.isStatic ? "static " : ""}$fieldString;");
    }

    var list = map[cls]!;
    for (var procedure in list) {
      if (procedure.member.enclosingClass == cls) {
        print(_toString(procedure.member, true));
      }
    }

    var cppNewStr = '''
  static ${_getClassDeclareType(cls)} cppNew();
''';
    print(cppNewStr);

    print("};");
  }

  // 打印类声明实现
  void _printClassDeclaration(Map<Class, List<ClassMember>> map, Class cls) {
    // Print class declaration with inheritance
    var list = map[cls];
    if (list?.isNotEmpty ?? false) {
      for (var procedure in list!) {
        if (procedure.member.enclosingClass == cls) {
          print(_toString(procedure.member, false));
        }
      }
    }

    var typeString = _getClassDeclareTypeParameters(cls);
    var className = getClassTypeName(cls);
    var classTypeName = _getClassDeclareType(cls);

    var cppNewStr = '''
  $typeString $classTypeName $className::cppNew() {
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

  // 获取类成员列表
  Map<Class, List<ClassMember>> _getClassList(Iterable<Class> list) {
    var classMap = <Class, List<ClassMember>>{};
    for (var cls in list) {
      _getClassMembersList(classMap, cls);
    }
    return classMap;
  }

  List<ClassMember> _getClassMembersList(
      Map<Class, List<ClassMember>> map, Class cls) {
    if (map.containsKey(cls)) {
      return map[cls]!;
    }

    List<ClassMember> superList = [];
    if (cls.name == "Object") {
      for (var procedure in cls.procedures) {
        if (procedure.name.text == "toString") {
          _replaceOrAddMembersList(superList, procedure);
        }
      }
    } else {
      if (cls.superclass != null) {
        superList = [..._getClassMembersList(map, cls.superclass!)];
      }
      for (var constructor in cls.constructors) {
        _replaceOrAddMembersList(superList, constructor);
      }
      for (var procedure in cls.procedures) {
        if (procedure.name.text != "_typeArguments") {
          _replaceOrAddMembersList(superList, procedure);
        }
      }
    }
    map[cls] = superList;
    return superList;
  }

  void _replaceOrAddMembersList(List<ClassMember> list, Member member) {
    var name = getMemberName(member);
    for (var i = 0; i < list.length; i++) {
      if (list[i].name == name) {
        list[i] = ClassMember(member, i);
        return;
      }
    }
    list.add(ClassMember(member, list.length));
  }

  //获取参数类型
  String _getVariableType(DartType type) {
    if (type is InterfaceType) {
      var typeParameters =
          type.typeArguments.map((e) => _getVariableDeclareType(e));
      var name = getClassName(type.classNode);
      return name +
          (typeParameters.isNotEmpty ? "<${typeParameters.join(",")}>" : "");
    } else if (type is FunctionType) {
      var parameters = [
        _getVariableType(type.returnType),
        ...type.positionalParameters
            .map((parameter) => _getVariableDeclareType(parameter)),
        ...type.namedParameters
            .map((parameter) => _getVariableDeclareType(parameter.type))
      ];
      return "Function";
      //return "Function<${parameters.join(", ")}>";
    } else if (type is DynamicType) {
      return "void*";
    } else if (type is FutureOrType) {
      return _getVariableType(type.typeArgument);
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

  String _getVariableDeclareType(DartType type) {
    if (type is TypeParameterType) {
      var name = type.parameter.name ?? "void*";
      return name;
    }
    var typeStr = _getVariableType(type);
    if (typeStr == "void") {
      return typeStr;
    }
    return (type.nullability == Nullability.nullable)
        ? "$typeStr *"
        : "$typeStr *";
  }

  String _getFieldDeclaration(Field field) {
    return "${_getVariableDeclareType(field.type)} ${field.name.text}";
  }

  String _getVariableDeclaration(VariableDeclaration variableDeclaration) {
    return "${_getVariableDeclareType(variableDeclaration.type)} ${variableDeclaration.name}";
  }

  String _toString(TreeNode statement, bool isHeader) {
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
      if (variable.name == "this") {
        return "cppThis";
      }
      return variable.name!.replaceAll(":", "\$").replaceAll("-", "_");
    }

    if (_variableNames[variable] != null) {
      return _variableNames[variable]!;
    }
    var name = "cppLet_${_letNames.length}";
    _variableNames[variable] = name;
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

  getDeclareClassTypeParametersDiff(Class cls, List<DartType> typeParameters) {
    var name = getClassName(cls);
    var type = "";
    if (cls.typeParameters.isNotEmpty) {
      if (typeParameters.length < cls.typeParameters.length) {
        //throw "error";
        type = "<${cls.typeParameters.map((e) => e.name)}>";
      } else {
        type =
            "<${typeParameters.sublist(0, cls.typeParameters.length).map((e) => _getVariableDeclareType(e))}>";
      }
    }
    return "$name$type";
  }

  void writeMemberFunctionDeclaration(Procedure procedure) {
    FunctionNode function = procedure.function;
    String name = getMemberName(procedure);
    String ownerClassType = _getClassDeclareType(procedure.enclosingClass!);

    var typeStr = getTypeParametersDiff(
        procedure.enclosingClass!, function.typeParameters);
    if (isHeader) {
      write(
          "$typeStr static ${_getVariableDeclareType(function.returnType)} $name");
      writeParametersList(function,
          ownerClassType: procedure.isStatic ? "" : ownerClassType);
      write(";");

      return;
    }

    var typeString = _getClassDeclareTypeParameters(procedure.enclosingClass!);
    var className = getClassTypeName(procedure.enclosingClass!);
    write(
        "$typeStr $typeString ${_getVariableDeclareType(function.returnType)} $className::$name");
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
    write(" -> ${_getVariableDeclareType(function.returnType)}");
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
      var classType = _getClassDeclareType(constructor.enclosingClass);
      write("$typeStr static $classType ${getMemberName(constructor)}");
      writeParametersList(constructor.function, ownerClassType: classType);
      write(";");
      return;
    }

    var typeString =
        _getClassDeclareTypeParameters(constructor.enclosingClass!);
    var className = getClassTypeName(constructor.enclosingClass!);
    var classType = _getClassDeclareType(constructor.enclosingClass);
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
    write("${_getVariableDeclareType(variable.type)} ");
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
      write('${_getVariableDeclareType(statement.type)} ');
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
      write('${_getVariableDeclareType(statement.variable.type)} ');
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
      var typeArgument = _getVariableDeclareType(expression.typeArgument);
      write("CppNewList($typeArgument,");
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write(')');
    } else if (expression is SetLiteral) {
      var typeArgument = _getVariableDeclareType(expression.typeArgument);
      write("CppNewSet($typeArgument,");
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write(')');
    } else if (expression is MapLiteral) {
      var keyTypeArgument = _getVariableDeclareType(expression.keyType);
      var valueTypeArgument = _getVariableDeclareType(expression.valueType);
      write("CppNewMap($keyTypeArgument,$valueTypeArgument,");
      bool first = true;
      for (var entry in expression.entries) {
        if (!first) write(', ');
        first = false;
        write('CppNew(MapEntry<$keyTypeArgument,$valueTypeArgument>,cpp_Ctr_,');
        writeExpression(entry.key);
        write(', ');
        writeExpression(entry.value);
        write(')');
      }
      write(')');
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
      var classType = _getVariableType(expression.constructedType);
      write("$classType::${getMemberName(expression.target)}");
      if (classType == "List") {
        print("List");
      }

      writeArgumentsList(expression.target.function, expression.arguments,
          prefixStr: "$classType::cppNew()", skipType: true);
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
        // todo get instance
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
      if (expression.target.enclosingClass?.name == "_GrowableList") {
        var listType = _getVariableDeclareType(expression.arguments.types[0]);
        write("CppNewList($listType");
        for (var item in expression.arguments.positional) {
          write(",");
          writeExpression(item);
        }
        write(")");
      } else {
        if (expression.target.enclosingClass != null) {
          // var className = getClassName(expression.target.enclosingClass!);
          // var memberName = getMemberName(expression.target);
          // if (expression.arguments.types.isNotEmpty) {
          //   className +=
          //       "<${expression.arguments.types.map((e) => _getVariableDeclareType(e)).join(",")}>";
          // }
          // write("$className::$memberName");
          var classType = getDeclareClassTypeParametersDiff(
              expression.target.enclosingClass!, expression.arguments.types);
          var memberName = getMemberName(expression.target);
          write("$classType::$memberName");
          // if (className == "List") {
          //   print("List");
          // }
          writeArgumentsList(expression.target.function, expression.arguments,
              skipType: true);
          write(")");
        } else {
          write(getMemberInvokeName(expression.target));
          if (expression.target.enclosingClass?.name == "List") {
            print("List");
          }
          writeArgumentsList(expression.target.function, expression.arguments);
        }
      }
    } else if (expression is InstanceInvocation) {
      if (expression.receiver is InstanceGet) {
        var receiver = expression.receiver as InstanceGet;
        var classNameType =
            _getVariableType((receiver.interfaceTarget.getterType));
        var memberName = getMemberName(expression.interfaceTarget);
        write("$classNameType::$memberName");
      } else if (expression.receiver is VariableGet) {
        var receiver = expression.receiver as VariableGet;
        var classNameType = _getVariableType(receiver.variable.type);
        var memberName = getMemberName(expression.interfaceTarget);
        write("$classNameType::$memberName");
      } else if (expression.receiver is StaticGet) {
        var receiver = expression.receiver as StaticGet;
        var classNameType = _getVariableType(receiver.target.getterType);
        var memberName = getMemberName(expression.interfaceTarget);
        write("$classNameType::$memberName");
      } else if (expression.receiver is ConstructorInvocation) {
        var receiver = expression.receiver as ConstructorInvocation;
        var classNameType = _getVariableType(receiver.constructedType);
        var memberName = getMemberName(expression.interfaceTarget);
        write("$classNameType::$memberName");
      } else if (expression.receiver is ThisExpression) {
        var classNameType =
            _getVariableType(expression.interfaceTarget.getterType);
        var memberName = getMemberName(expression.interfaceTarget);
        write("$classNameType::$memberName");
      } else {
        // 对于其他类型的 receiver，我们尝试从 interfaceTarget 获取类型信息
        var classNameType =
            _getVariableType(expression.interfaceTarget.getterType);
        write(getMemberInvokeName(expression.interfaceTarget));
      }
      if (expression.interfaceTarget.enclosingClass?.name == "List") {
        print("List");
      }
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
      write(_getVariableDeclareType(expression.type));
    } else if (expression is IsExpression) {
      writeExpression(expression.operand);
      write(" is ");
      write(_getVariableDeclareType(expression.type));
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
          '([](${_getVariableDeclareType(expression.variable.type)} ${getVariableName(expression.variable)}){');
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
        write("cppToString(");
        writeExpression(exp);
        write(")");
        if (!first) write(")");
        first = false;
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
      write("(");
      writeExpression(expression.expression);
      write(" == ");
      write("nullptr");
      write(")");
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
      write(_getVariableDeclareType(parameter.type));
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
      write(_getVariableDeclareType(namedParameter.type));
      write(" ");
      write(namedParameter.name!);
    }
    write(')');
  }

  void writeArgumentsList(FunctionNode function, Arguments arguments,
      {Expression? prefix, String? prefixStr, bool skipType = false}) {
    if (!skipType && arguments.types.isNotEmpty) {
      write(
          "<${arguments.types.map((e) => _getVariableDeclareType(e)).join(",")}>");
    }
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

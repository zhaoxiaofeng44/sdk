import 'package:kernel/kernel.dart';

/// 闭包变量信息
class ClosureVariable {
  final VariableDeclaration variable;
  final String name;
  final DartType type;
  final bool isParameter;

  ClosureVariable(this.variable, this.name, this.type, this.isParameter);

  @override
  String toString() {
    return 'ClosureVariable(name: $name, type: $type, isParameter: $isParameter)';
  }
}

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
    "MapEntry",
    "ListIterator",
    "FollowedByIterable",
    "StringBuffer",
    "WhereTypeIterable",
    "MappedListIterable",
    "WhereIterable",
    "ExpandIterable",
    "SubListIterable",
    "SkipWhileIterable",
    "TakeWhileIterable",
    "checkNotNullable",
    "Sort",
    "Comparable",
    "ListMapView",
    "EfficientLengthIterable",
    "RangeError",
    "ReversedListIterable"
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
  "_Set": "CppSet",
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
    if (memberName.contains("<")) {
      memberName = "template $memberName";
    }
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
      return "FunctionApply<${_getVariableDeclareType(type.returnType)},${parameters.join(", ")}>";
      //return "Function";
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

  String logicalExpressionToString(LogicalExpressionOperator operator) {
    var opStr = logicalExpressionOperatorToString(operator);
    return specialNames.containsKey(opStr) ? specialNames[opStr]! : opStr;
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
      if (typeParameters.length <= cls.typeParameters.length) {
        //throw "error";
        type = "<${cls.typeParameters.map((e) => e.name).join(",")}>";
      } else {
        type =
            "<${typeParameters.sublist(0, cls.typeParameters.length).map((e) => _getVariableDeclareType(e)).join(",")}>";
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
        "$typeString $typeStr ${_getVariableDeclareType(function.returnType)} $className::$name");
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
    //write('// ${statement.runtimeType}\n');
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
      write('do {');
      write('auto switchValue = ');
      writeExpression(statement.expression);
      write(';');
      indent();
      for (var switchCase in statement.cases) {
        if (!switchCase.isDefault) {
          write('if(switchValue == ');
          writeExpression(switchCase.expressions.first);
          write(')');
        }
        write('{');
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
      write('} while(0);');
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
      write('{');
      indent();
      if (statement.variables.isNotEmpty) {
        for (var variable in statement.variables) {
          writeVariableDeclaration(variable);
          write(';');
        }
      }
      write('while (');
      if (statement.condition != null) {
        writeExpression(statement.condition!);
      } else {
        write('true');
      }
      write(')');
      write('{');
      indent();
      writeStatement(statement.body);
      if (statement.updates.isNotEmpty) {
        for (var update in statement.updates) {
          writeExpression(update);
          write(';');
        }
      }
      unindent();
      write('}');
      unindent();
      write('}');
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
    //write('// ${expression.runtimeType}\n');
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
      writeExpression(expression.receiver);
      if (expression.functionType != null) {
        writeArgumentsListByFunctionType(
            expression.functionType!, expression.arguments);
      } else {
        //todo
      }
    } else if (expression is ConstructorInvocation) {
      var classType = _getVariableType(expression.constructedType);
      var memberName = getMemberName(expression.target);
      if (memberName.contains("<")) {
        memberName = "template $memberName";
      }
      write("$classType::$memberName");
      writeArgumentsList(expression.target.function, expression.arguments,
          prefixStr: "$classType::cppNew()", skipType: true);
    } else if (expression is ConstantExpression) {
      write(getConstant(expression.constant));
    } else if (expression is LogicalExpression) {
      writeExpression(expression.left);
      write(' ');
      write(logicalExpressionToString(expression.operatorEnum));
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
        var classNameType =
            _getReceiverType(expression.receiver, expression.interfaceTarget);
        var memberName = getMemberName(procedure);
        if (memberName.contains("<")) {
          memberName = "template $memberName";
        }
        write("$classNameType::$memberName");
        write("(");
        writeExpression(expression.receiver);
        write(")");
      } else {
        writeExpression(expression.receiver);
        write("->");
        write(expression.name.text);
      }
    } else if (expression is InstanceSet) {
      if (expression.interfaceTarget is Procedure) {
        var procedure = expression.interfaceTarget as Procedure;
        var classNameType =
            _getReceiverType(expression.receiver, expression.interfaceTarget);
        var memberName = getMemberName(procedure);
        if (memberName.contains("<")) {
          memberName = "template $memberName";
        }
        write("$classNameType::$memberName");
        write("(");
        writeExpression(expression.receiver);
        write(", ");
        writeExpression(expression.value);
        write(")");
      } else {
        writeExpression(expression.receiver);
        write("->");
        write(expression.name.text);
        write(" = ");
        writeExpression(expression.value);
      }
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
          if (memberName.contains("<")) {
            memberName = "template $memberName";
          }
          write("$classType::$memberName");
          // if (className == "List") {
          //   print("List");
          // }
          writeArgumentsList(expression.target.function, expression.arguments,
              skipType: true);
        } else {
          write(getMemberInvokeName(expression.target));
          writeArgumentsList(expression.target.function, expression.arguments);
        }
      }
    } else if (expression is InstanceInvocation) {
      var classNameType =
          _getReceiverType(expression.receiver, expression.interfaceTarget);
      var memberName = getMemberName(expression.interfaceTarget);
      if (memberName.contains("<")) {
        memberName = "template $memberName";
      }
      write("$classNameType::$memberName");
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
      write("Object::cppOpr_equals(");
      writeExpression(expression.left);
      write(",");
      writeExpression(expression.right);
      write(")");
    } else if (expression is AsExpression) {
      write("reinterpret_cast<${_getVariableDeclareType(expression.type)}>(");
      writeExpression(expression.operand);
      write(")");
    } else if (expression is IsExpression) {
      write("reinterpret_cast<${_getVariableDeclareType(expression.type)}>(");
      writeExpression(expression.operand);
      write(") == nullptr");
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
      var varName = getVariableName(expression.variable);
      write(
          '([&](${_getVariableDeclareType(expression.variable.type)} ${varName}){');
      var statement = expression.body;
      if (statement is BlockExpression) {
        for (var stmt in statement.body.statements) {
          writeStatement(stmt);
        }
        write("return ${varName};");
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
      var functionTypeStr = _getVariableType(
          expression.function.computeFunctionType(Nullability.undetermined));
      var typeStr =
          functionTypeStr.replaceAll("FunctionApply", "ClosureWrapper");
      write('new $typeStr(');
      writeFunctionDeclaration(expression.function);
      write(')');
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
      write("Bool");
      write("::");
      write(specialNames["!"]!);
      write("(");
      writeExpression(expression.operand);
      write(")");
    } else if (expression is Throw) {
      // write("throw");
      // write(" cppToString(");
      // writeExpression(expression.expression);
      // write(")");
      write(
          "throw \"${expression.expression.toString().replaceAll("\"", "")}\"");
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

  void writeArgumentsListByFunctionType(
      FunctionType function, Arguments arguments,
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
        write("nullptr");
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
        write("nullptr");
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
    } else if (c is NullConstant) {
      return "nullptr";
    }
    return "AA<" + c.toStringInternal() + ">AA";
  }

  // 获取 receiver 的类型名称
  String _getReceiverType(Expression receiver, Member? interfaceTarget) {
    if (interfaceTarget?.enclosingClass?.typeParameters.isEmpty ?? false) {
      return getClassTypeName(interfaceTarget!.enclosingClass!);
    }
    if (receiver is InstanceGet) {
      return _getVariableType(receiver.interfaceTarget.getterType);
    } else if (receiver is VariableGet) {
      return _getVariableType(receiver.variable.type);
    } else if (receiver is StaticGet) {
      return _getVariableType(receiver.target.getterType);
    } else if (receiver is ConstructorInvocation) {
      return _getVariableType(receiver.constructedType);
    } else if (receiver is StaticInvocation) {
      return _getVariableType(receiver.target.function.returnType);
    } else if (receiver is InstanceInvocation) {
      return _getVariableType(receiver.functionType.returnType);
    }
    // else if (receiver is ThisExpression) {
    //   if (interfaceTarget?.enclosingClass != null) {
    //     return getClassTypeName(interfaceTarget!.enclosingClass!);
    //   }
    //   return "Object";
    // }
    else {
      if (interfaceTarget?.enclosingClass != null) {
        return getClassTypeName(interfaceTarget!.enclosingClass!);
      }
      if (interfaceTarget != null) {
        return _getVariableType(interfaceTarget.getterType);
      }
      return "Object";
    }
  }

  /// 分析 FunctionExpression 中引用的外部变量
  /// 返回在函数外部定义但在函数内部使用的变量列表
  List<ClosureVariable> findExternalVariables(
      FunctionExpression functionExpression) {
    var externalVars = <ClosureVariable>[];
    var localVars = <VariableDeclaration>{};

    // 收集函数参数（这些是局部变量）
    _collectFunctionParameters(functionExpression.function, localVars);

    // 遍历函数体，查找变量引用
    if (functionExpression.function.body != null) {
      _findVariableReferences(
          functionExpression.function.body!, localVars, externalVars);
    }

    return externalVars;
  }

  /// 收集函数的所有参数
  void _collectFunctionParameters(
      FunctionNode function, Set<VariableDeclaration> localVars) {
    // 位置参数
    for (var param in function.positionalParameters) {
      localVars.add(param);
    }

    // 命名参数
    for (var param in function.namedParameters) {
      localVars.add(param);
    }
  }

  /// 在语句中查找变量引用
  void _findVariableReferences(Statement statement,
      Set<VariableDeclaration> localVars, List<ClosureVariable> externalVars) {
    if (statement is Block) {
      for (var stmt in statement.statements) {
        _findVariableReferences(stmt, localVars, externalVars);
      }
    } else if (statement is VariableDeclaration) {
      // 这是一个局部变量定义，添加到局部变量集合
      localVars.add(statement);
      if (statement.initializer != null) {
        _findVariableReferencesInExpression(
            statement.initializer!, localVars, externalVars);
      }
    } else if (statement is ExpressionStatement) {
      _findVariableReferencesInExpression(
          statement.expression, localVars, externalVars);
    } else if (statement is ReturnStatement) {
      if (statement.expression != null) {
        _findVariableReferencesInExpression(
            statement.expression!, localVars, externalVars);
      }
    } else if (statement is IfStatement) {
      _findVariableReferencesInExpression(
          statement.condition, localVars, externalVars);
      _findVariableReferences(statement.then, localVars, externalVars);
      if (statement.otherwise != null) {
        _findVariableReferences(statement.otherwise!, localVars, externalVars);
      }
    } else if (statement is WhileStatement) {
      _findVariableReferencesInExpression(
          statement.condition, localVars, externalVars);
      _findVariableReferences(statement.body, localVars, externalVars);
    } else if (statement is ForStatement) {
      // 创建新的局部变量集合，包含 for 循环变量
      var forLocalVars = Set<VariableDeclaration>.from(localVars);
      for (var variable in statement.variables) {
        forLocalVars.add(variable);
        if (variable.initializer != null) {
          _findVariableReferencesInExpression(
              variable.initializer!, localVars, externalVars);
        }
      }

      if (statement.condition != null) {
        _findVariableReferencesInExpression(
            statement.condition!, forLocalVars, externalVars);
      }

      for (var update in statement.updates) {
        _findVariableReferencesInExpression(update, forLocalVars, externalVars);
      }

      _findVariableReferences(statement.body, forLocalVars, externalVars);
    } else if (statement is DoStatement) {
      _findVariableReferences(statement.body, localVars, externalVars);
      _findVariableReferencesInExpression(
          statement.condition, localVars, externalVars);
    } else if (statement is SwitchStatement) {
      _findVariableReferencesInExpression(
          statement.expression, localVars, externalVars);
      for (var switchCase in statement.cases) {
        for (var expr in switchCase.expressions) {
          _findVariableReferencesInExpression(expr, localVars, externalVars);
        }
        _findVariableReferences(switchCase.body, localVars, externalVars);
      }
    } else if (statement is TryFinally) {
      _findVariableReferences(statement.body, localVars, externalVars);
      _findVariableReferences(statement.finalizer, localVars, externalVars);
    } else if (statement is FunctionDeclaration) {
      // 函数声明创建一个新的局部变量
      localVars.add(statement.variable);
      // 分析函数体中的变量引用（递归处理嵌套函数）
      var nestedExternalVars = <ClosureVariable>[];
      var nestedLocalVars = Set<VariableDeclaration>.from(localVars);
      _collectFunctionParameters(statement.function, nestedLocalVars);
      if (statement.function.body != null) {
        _findVariableReferences(
            statement.function.body!, nestedLocalVars, nestedExternalVars);
      }
      // 将嵌套函数的外部变量添加到当前列表
      externalVars.addAll(nestedExternalVars);
    }
  }

  /// 在表达式中查找变量引用
  void _findVariableReferencesInExpression(Expression expression,
      Set<VariableDeclaration> localVars, List<ClosureVariable> externalVars) {
    if (expression is VariableGet) {
      // 检查这个变量是否是外部变量
      if (!localVars.contains(expression.variable)) {
        // 检查是否已经添加过这个变量
        var alreadyExists =
            externalVars.any((cv) => cv.variable == expression.variable);
        if (!alreadyExists) {
          var closureVar = ClosureVariable(
              expression.variable,
              expression.variable.name ?? 'unnamed',
              expression.variable.type,
              false // 不是参数，是外部定义的变量
              );
          externalVars.add(closureVar);
        }
      }
    } else if (expression is VariableSet) {
      // 变量赋值也是一种引用
      if (!localVars.contains(expression.variable)) {
        var alreadyExists =
            externalVars.any((cv) => cv.variable == expression.variable);
        if (!alreadyExists) {
          var closureVar = ClosureVariable(
              expression.variable,
              expression.variable.name ?? 'unnamed',
              expression.variable.type,
              false);
          externalVars.add(closureVar);
        }
      }
      // 分析赋值表达式
      _findVariableReferencesInExpression(
          expression.value, localVars, externalVars);
    } else if (expression is FunctionExpression) {
      // 递归处理嵌套的函数表达式
      var nestedExternalVars = findExternalVariables(expression);
      // 过滤掉在当前作用域中定义的变量
      for (var nestedVar in nestedExternalVars) {
        if (!localVars.contains(nestedVar.variable)) {
          var alreadyExists =
              externalVars.any((cv) => cv.variable == nestedVar.variable);
          if (!alreadyExists) {
            externalVars.add(nestedVar);
          }
        }
      }
    } else if (expression is ConditionalExpression) {
      _findVariableReferencesInExpression(
          expression.condition, localVars, externalVars);
      _findVariableReferencesInExpression(
          expression.then, localVars, externalVars);
      _findVariableReferencesInExpression(
          expression.otherwise, localVars, externalVars);
    } else if (expression is LogicalExpression) {
      _findVariableReferencesInExpression(
          expression.left, localVars, externalVars);
      _findVariableReferencesInExpression(
          expression.right, localVars, externalVars);
    } else if (expression is InstanceInvocation) {
      _findVariableReferencesInExpression(
          expression.receiver, localVars, externalVars);
      _findVariableReferencesInArguments(
          expression.arguments, localVars, externalVars);
    } else if (expression is StaticInvocation) {
      _findVariableReferencesInArguments(
          expression.arguments, localVars, externalVars);
    } else if (expression is ConstructorInvocation) {
      _findVariableReferencesInArguments(
          expression.arguments, localVars, externalVars);
    } else if (expression is InstanceGet) {
      _findVariableReferencesInExpression(
          expression.receiver, localVars, externalVars);
    } else if (expression is InstanceSet) {
      _findVariableReferencesInExpression(
          expression.receiver, localVars, externalVars);
      _findVariableReferencesInExpression(
          expression.value, localVars, externalVars);
    } else if (expression is ListLiteral) {
      for (var item in expression.expressions) {
        _findVariableReferencesInExpression(item, localVars, externalVars);
      }
    } else if (expression is SetLiteral) {
      for (var item in expression.expressions) {
        _findVariableReferencesInExpression(item, localVars, externalVars);
      }
    } else if (expression is MapLiteral) {
      for (var entry in expression.entries) {
        _findVariableReferencesInExpression(entry.key, localVars, externalVars);
        _findVariableReferencesInExpression(
            entry.value, localVars, externalVars);
      }
    } else if (expression is StringConcatenation) {
      for (var expr in expression.expressions) {
        _findVariableReferencesInExpression(expr, localVars, externalVars);
      }
    } else if (expression is AsExpression) {
      _findVariableReferencesInExpression(
          expression.operand, localVars, externalVars);
    } else if (expression is IsExpression) {
      _findVariableReferencesInExpression(
          expression.operand, localVars, externalVars);
    } else if (expression is Not) {
      _findVariableReferencesInExpression(
          expression.operand, localVars, externalVars);
    } else if (expression is NullCheck) {
      _findVariableReferencesInExpression(
          expression.operand, localVars, externalVars);
    } else if (expression is Throw) {
      _findVariableReferencesInExpression(
          expression.expression, localVars, externalVars);
    } else if (expression is Let) {
      // Let 表达式引入一个新的局部变量
      var letLocalVars = Set<VariableDeclaration>.from(localVars);
      letLocalVars.add(expression.variable);
      if (expression.variable.initializer != null) {
        _findVariableReferencesInExpression(
            expression.variable.initializer!, localVars, externalVars);
      }
      _findVariableReferencesInExpression(
          expression.body, letLocalVars, externalVars);
    } else if (expression is BlockExpression) {
      for (var stmt in expression.body.statements) {
        _findVariableReferences(stmt, localVars, externalVars);
      }
      _findVariableReferencesInExpression(
          expression.value, localVars, externalVars);
    }
    // 对于其他类型的表达式（如字面量），不包含变量引用，跳过
  }

  /// 在参数列表中查找变量引用
  void _findVariableReferencesInArguments(Arguments arguments,
      Set<VariableDeclaration> localVars, List<ClosureVariable> externalVars) {
    for (var arg in arguments.positional) {
      _findVariableReferencesInExpression(arg, localVars, externalVars);
    }
    for (var namedArg in arguments.named) {
      _findVariableReferencesInExpression(
          namedArg.value, localVars, externalVars);
    }
  }

  /// 根据指定的 TreeNode 查找其中的变量引用
  /// [node] - 要分析的树节点
  /// [localScope] - 当前作用域中的局部变量集合，如果为 null 则创建空集合
  /// 返回在该节点中引用的所有变量列表
  List<ClosureVariable> findVariableReferencesInNode(TreeNode node,
      [Set<VariableDeclaration>? localScope]) {
    var externalVars = <ClosureVariable>[];
    var localVars = localScope ?? <VariableDeclaration>{};

    if (node is Statement) {
      _findVariableReferences(node, localVars, externalVars);
    } else if (node is Expression) {
      _findVariableReferencesInExpression(node, localVars, externalVars);
    } else if (node is FunctionNode) {
      // 如果是函数节点，收集其参数作为局部变量
      _collectFunctionParameters(node, localVars);
      if (node.body != null) {
        _findVariableReferences(node.body!, localVars, externalVars);
      }
    } else if (node is Member) {
      // 处理成员节点（方法、字段等）
      if (node is Procedure && node.function.body != null) {
        var memberLocalVars = Set<VariableDeclaration>.from(localVars);
        _collectFunctionParameters(node.function, memberLocalVars);
        _findVariableReferences(
            node.function.body!, memberLocalVars, externalVars);
      } else if (node is Field && node.initializer != null) {
        _findVariableReferencesInExpression(
            node.initializer!, localVars, externalVars);
      }
    } else if (node is Class) {
      // 处理类节点，分析其所有成员
      for (var field in node.fields) {
        if (field.initializer != null) {
          _findVariableReferencesInExpression(
              field.initializer!, localVars, externalVars);
        }
      }
      for (var constructor in node.constructors) {
        var constructorLocalVars = Set<VariableDeclaration>.from(localVars);
        _collectFunctionParameters(constructor.function, constructorLocalVars);
        if (constructor.function.body != null) {
          _findVariableReferences(
              constructor.function.body!, constructorLocalVars, externalVars);
        }
      }
      for (var procedure in node.procedures) {
        if (procedure.function.body != null) {
          var procedureLocalVars = Set<VariableDeclaration>.from(localVars);
          _collectFunctionParameters(procedure.function, procedureLocalVars);
          _findVariableReferences(
              procedure.function.body!, procedureLocalVars, externalVars);
        }
      }
    } else if (node is Library) {
      // 处理库节点，分析所有顶级声明
      for (var field in node.fields) {
        if (field.initializer != null) {
          _findVariableReferencesInExpression(
              field.initializer!, localVars, externalVars);
        }
      }
      for (var procedure in node.procedures) {
        if (procedure.function.body != null) {
          var procedureLocalVars = Set<VariableDeclaration>.from(localVars);
          _collectFunctionParameters(procedure.function, procedureLocalVars);
          _findVariableReferences(
              procedure.function.body!, procedureLocalVars, externalVars);
        }
      }
      for (var cls in node.classes) {
        var classVars = findVariableReferencesInNode(cls, localVars);
        externalVars.addAll(classVars);
      }
    }

    return externalVars;
  }

  /// 查找特定变量在树节点中的所有引用位置
  /// [node] - 要搜索的树节点
  /// [targetVariable] - 目标变量
  /// 返回引用该变量的表达式列表
  List<Expression> findVariableUsages(
      TreeNode node, VariableDeclaration targetVariable) {
    var usages = <Expression>[];
    _findSpecificVariableUsages(node, targetVariable, usages);
    return usages;
  }

  /// 递归查找特定变量的使用位置
  void _findSpecificVariableUsages(TreeNode node,
      VariableDeclaration targetVariable, List<Expression> usages) {
    if (node is VariableGet && node.variable == targetVariable) {
      usages.add(node);
    } else if (node is VariableSet && node.variable == targetVariable) {
      usages.add(node);
      _findSpecificVariableUsages(node.value, targetVariable, usages);
    } else if (node is Statement) {
      _findVariableUsagesInStatement(node, targetVariable, usages);
    } else if (node is Expression) {
      _findVariableUsagesInExpression(node, targetVariable, usages);
    } else if (node is FunctionNode) {
      if (node.body != null) {
        _findSpecificVariableUsages(node.body!, targetVariable, usages);
      }
    } else if (node is Member) {
      if (node is Procedure && node.function.body != null) {
        _findSpecificVariableUsages(
            node.function.body!, targetVariable, usages);
      } else if (node is Field && node.initializer != null) {
        _findSpecificVariableUsages(node.initializer!, targetVariable, usages);
      }
    }
  }

  /// 在语句中查找特定变量的使用
  void _findVariableUsagesInStatement(Statement statement,
      VariableDeclaration targetVariable, List<Expression> usages) {
    if (statement is Block) {
      for (var stmt in statement.statements) {
        _findSpecificVariableUsages(stmt, targetVariable, usages);
      }
    } else if (statement is ExpressionStatement) {
      _findSpecificVariableUsages(statement.expression, targetVariable, usages);
    } else if (statement is ReturnStatement && statement.expression != null) {
      _findSpecificVariableUsages(
          statement.expression!, targetVariable, usages);
    } else if (statement is IfStatement) {
      _findSpecificVariableUsages(statement.condition, targetVariable, usages);
      _findSpecificVariableUsages(statement.then, targetVariable, usages);
      if (statement.otherwise != null) {
        _findSpecificVariableUsages(
            statement.otherwise!, targetVariable, usages);
      }
    } else if (statement is WhileStatement) {
      _findSpecificVariableUsages(statement.condition, targetVariable, usages);
      _findSpecificVariableUsages(statement.body, targetVariable, usages);
    } else if (statement is ForStatement) {
      for (var variable in statement.variables) {
        if (variable.initializer != null) {
          _findSpecificVariableUsages(
              variable.initializer!, targetVariable, usages);
        }
      }
      if (statement.condition != null) {
        _findSpecificVariableUsages(
            statement.condition!, targetVariable, usages);
      }
      for (var update in statement.updates) {
        _findSpecificVariableUsages(update, targetVariable, usages);
      }
      _findSpecificVariableUsages(statement.body, targetVariable, usages);
    }
    // 可以继续添加其他语句类型的处理
  }

  /// 在表达式中查找特定变量的使用
  void _findVariableUsagesInExpression(Expression expression,
      VariableDeclaration targetVariable, List<Expression> usages) {
    if (expression is ConditionalExpression) {
      _findSpecificVariableUsages(expression.condition, targetVariable, usages);
      _findSpecificVariableUsages(expression.then, targetVariable, usages);
      _findSpecificVariableUsages(expression.otherwise, targetVariable, usages);
    } else if (expression is LogicalExpression) {
      _findSpecificVariableUsages(expression.left, targetVariable, usages);
      _findSpecificVariableUsages(expression.right, targetVariable, usages);
    } else if (expression is InstanceInvocation) {
      _findSpecificVariableUsages(expression.receiver, targetVariable, usages);
      for (var arg in expression.arguments.positional) {
        _findSpecificVariableUsages(arg, targetVariable, usages);
      }
      for (var namedArg in expression.arguments.named) {
        _findSpecificVariableUsages(namedArg.value, targetVariable, usages);
      }
    } else if (expression is ListLiteral) {
      for (var item in expression.expressions) {
        _findSpecificVariableUsages(item, targetVariable, usages);
      }
    } else if (expression is Let) {
      if (expression.variable.initializer != null) {
        _findSpecificVariableUsages(
            expression.variable.initializer!, targetVariable, usages);
      }
      _findSpecificVariableUsages(expression.body, targetVariable, usages);
    }
    // 可以继续添加其他表达式类型的处理
  }
}

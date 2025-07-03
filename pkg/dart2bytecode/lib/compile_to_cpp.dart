import 'dart:io';

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

StringBuffer buffer = StringBuffer();
void print2String(String text) {
  buffer.write(text + "\n");
}

bool isHideClass(Class cls) {
  const cppClassNames = [
    "List",
    "Map",
    "Set",
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
    "EfficientLengthIterable",
    "TakeIterable",
    "RangeError",
    "ReversedListIterable",
    "EfficientLengthMappedIterable",
    "EfficientLengthFollowedByIterable",
    "HideEfficientLengthIterable"
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

String getClassName(Class classInfo) {
  var name = classInfo.name.replaceAll("&", r"$");
  if (typeNames.containsKey(name)) {
    name = typeNames[name]!;
  }
  return name;
}

String getClassTypeName(Class classInfo) {
  var typeParametersStr = "";
  // if (classInfo.typeParameters.isNotEmpty) {
  //   typeParametersStr =
  //       "<${classInfo.typeParameters.map((e) => "${e.name}").join(",")}>";
  // }
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
    // if (memberName.contains("<")) {
    //   memberName = "template $memberName";
    // }
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
      print2String("${_getClassDeclareTypeName(cls)};");
    }

    var classMap = _getClassList(classList);

    var classSet = <Class>{};
    // 打印类声明头部
    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }
      print2String("//  " + cls.enclosingLibrary.toStringInternal());
      _deepPrintClassDeclarationHeader(classSet, classMap, cls);
    }

    try {
      // 写入头文件
      final headerFile = File('./cpp/output.h');
      headerFile.writeAsStringSync(buffer.toString());
      print2String('成功生成头文件: ${headerFile.absolute.path}');
    } catch (e) {
      print2String('写入文件时发生错误: $e');
    }

    buffer.clear();

    print2String('#include "./output.h"');

    // 打印类实现
    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }

      print2String("//  " + cls.enclosingLibrary.toStringInternal());
      _printClassDeclaration(classMap, cls);
    }

    try {
      // 写入头文件
      final headerFile = File('./cpp/output.cpp');
      headerFile.writeAsStringSync(buffer.toString());
      print2String('成功生成头文件: ${headerFile.absolute.path}');
    } catch (e) {
      print2String('写入文件时发生错误: $e');
    }

    buffer.clear();
  }

  // 打印C++头文件
  void _printCppHeader() {
    print2String(r'''
#include <cstdio>
#include <cstdlib>
#include <sstream>
#include "./core/array.h"
#include "./core/func.h"
#include "./core/num.h"
#include "./core/string.h"

void print(Object* obj) {
  if (obj) {
    String* str = obj->toString();
    printf("%s", str->c_str());
    delete str;
  } else {
    printf("null");
  }
}

void print(String* str) {
  if (str) {
    printf("%s", str->c_str());
  } else {
    printf("null");
  }
}

void print(char* str) {
  if (str) {
    printf("%s", str);
  }
}

class Uint16List;

Int* _getSuggestCapacity(int length) {
  return Int::cppNew(length);
}

Int* _getSuggestCapacity(Int* length) {
  return length;
}

template <typename T>
Bool* checkNotNullable(T count, String* name) {
  if (count == nullptr) {
    throw "error";
  }
  return Bool::cppNew(true);
}
''');
  }

  // 获取类声明类型参数
  String _getClassDeclareTypeParameters(Class cls) {
    //var typeParameters = cls.typeParameters.map((e) => "typename ${e.name}");
    var typeString = "";
    // if (typeParameters.isNotEmpty) {
    //   typeString = "template<${typeParameters.join(",")}>";
    // }
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
    print2String("$typeClassName $superClassName {");
    print2String("public:");

    // Print fields
    for (var field in cls!.fields) {
      var fieldString = _getFieldDeclaration(field);
      print2String("${field.isStatic ? "static " : ""}$fieldString;");
    }

    var list = map[cls]!;
    for (var procedure in list) {
      if (procedure.member.enclosingClass == cls) {
        print2String(_toString(procedure.member, true));
      }
    }

    var cppNewStr = '''
  static ${_getClassDeclareType(cls)} cppNew();
''';
    print2String(cppNewStr);

    print2String("};");
  }

  void _deepPrintClassDeclarationHeader(
      Set<Class> visited, Map<Class, List<ClassMember>> map, Class cls) {
    if (cls.name == "Object") {
      return;
    }
    if (visited.contains(cls)) {
      return;
    }
    visited.add(cls);
    // Print class declaration with inheritance
    if (cls.superclass != null) {
      _deepPrintClassDeclarationHeader(visited, map, cls.superclass!);
    }

    if (cls.implementedTypes.isNotEmpty) {
      for (var interface in cls.implementedTypes) {
        _deepPrintClassDeclarationHeader(visited, map, interface.classNode);
      }
    }
    _printClassDeclarationHeader(map, cls);
  }

  // 打印类声明实现
  void _printClassDeclaration(Map<Class, List<ClassMember>> map, Class cls) {
    // Print class declaration with inheritance
    var list = map[cls];
    if (list?.isNotEmpty ?? false) {
      for (var procedure in list!) {
        if (procedure.member.enclosingClass == cls) {
          print2String(_toString(procedure.member, false));
        }
      }
    }

    var typeString = _getClassDeclareTypeParameters(cls);
    var className = getClassTypeName(cls);
    var classTypeName = _getClassDeclareType(cls);

//     var cppNewStr = '''
//   $typeString $classTypeName $className::cppNew() {
//         static void *functionPtrs[] = {
//             ${list?.map((e) => "reinterpret_cast<void *>(&$className::${e.name})").join(",") ?? ""}
//         };
//         auto ptr = ($classTypeName)malloc(sizeof($className));
//         ptr->vtab = functionPtrs;
//         return ptr;
//     }
// ''';

    var cppNewStr = '''
  $typeString $classTypeName $className::cppNew() {
        auto ptr = ($classTypeName)malloc(sizeof($className));
        return ptr;
    }
''';
    print2String(cppNewStr);
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

      for (var i = 0; i < cls.implementedTypes.length; i++) {
        var interface = cls.implementedTypes[i];
        for (var member in interface.classNode.procedures) {
          _replaceOrAddMembersList(superList, member);
        }
      }
    }
    map[cls] = superList;
    return superList;
  }

  bool isOverrideMember(Class cls, Member member) {
    if (member.enclosingClass == cls) {
      if (isOverrideMember(cls.superclass!, member)) {
        return true;
      }
      for (var i = 0; i < cls.implementedTypes.length; i++) {
        var interface = cls.implementedTypes[i];
        if (isOverrideMember(interface.classNode, member)) {
          return true;
        }
      }
      return false;
    }
    for (var procedure in cls.procedures) {
      if (procedure.name.text == member.name.text) {
        return true;
      }
    }
    return false;
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
      // var typeParameters =
      //     type.typeArguments.map((e) => _getVariableDeclareType(e));
      var name = getClassName(type.classNode);
      return name;
      // (typeParameters.isNotEmpty ? "<${typeParameters.join(",")}>" : "");
    } else if (type is FunctionType) {
      // var parameters = [
      //   _getVariableType(type.returnType),
      //   ...type.positionalParameters
      //       .map((parameter) => _getVariableDeclareType(parameter)),
      //   ...type.namedParameters
      //       .map((parameter) => _getVariableDeclareType(parameter.type))
      // ];
      //return "FunctionApply<${_getVariableDeclareType(type.returnType)},${parameters.join(", ")}>";
      return "Function";
    } else if (type is DynamicType) {
      return "void*";
    } else if (type is FutureOrType) {
      return _getVariableType(type.typeArgument);
    } else if (type is NeverType) {
      return "void";
    } else if (type is VoidType) {
      return "void";
    }
    // else if (type is InvalidType) {
    //   return "Object";
    // } else if (type is DynamicType) {
    //   return "Object";
    // } else if (type is TypeParameterType) {
    //   return "Object";
    // } else if (type is NullType) {
    //   return "Object";
    // }

    else {
      return "Object";
    }
  }

  void writeInstanceTypeBefore(DartType returnType, DartType type) {
    if (type is TypeParameterType) {
      return;
    }
    if (returnType is! TypeParameterType) {
      return;
    }

    var typeStr = _getVariableDeclareType(type);
    if (typeStr == "void" || typeStr == "Object*" || typeStr == "Object *") {
      return;
    }

    write('reinterpret_cast<${_getVariableDeclareType(type)}>(');
  }

  void writeInstanceTypeEnd(DartType returnType, DartType type) {
    if (type is TypeParameterType) {
      return;
    }
    if (returnType is! TypeParameterType) {
      return;
    }

    var typeStr = _getVariableDeclareType(type);
    if (typeStr == "void" || typeStr == "Object*" || typeStr == "Object *") {
      return;
    }

    write(')');
  }

  String _getVariableDeclareType(DartType type) {
    if (type is TypeParameterType) {
      // //todo
      // var name = type.parameter.name ?? "void*";
      // return name;
      return "Object *";
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

  bool isFinalClass(Class cls) {
    if (cls.name == "num" ||
        cls.name == "int" ||
        cls.name == "double" ||
        cls.name == "String" ||
        cls.name == "bool") {
      return true;
    }
    return false;
  }

  String getVariableName(VariableDeclaration variable, {bool isLet = false}) {
    if (variable.name != null) {
      if (variable.name == "this") {
        return "this";
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
    // for (var t in cls.typeParameters) {
    //   nameSet.add(t.name!);
    // }

    var types = <String>[];
    // for (var t in typeParameters) {
    //   if (!nameSet.contains(t.name!)) {
    //     types.add("typename ${t.name}");
    //   }
    // }
    return types.isEmpty ? "" : "template<${types.join(",")}>";
  }

  getDeclareClassTypeParametersDiff(Class cls, List<DartType> typeParameters) {
    var name = getClassName(cls);
    var type = "";
    // if (cls.typeParameters.isNotEmpty) {
    //   if (typeParameters.length <= cls.typeParameters.length) {
    //     //throw "error";
    //     type = "<${cls.typeParameters.map((e) => e.name).join(",")}>";
    //   } else {
    //     type =
    //         "<${typeParameters.sublist(0, cls.typeParameters.length).map((e) => _getVariableDeclareType(e)).join(",")}>";
    //   }
    // }
    return "$name$type";
  }

  void writeMemberFunctionDeclaration(Procedure procedure) {
    FunctionNode function = procedure.function;
    String name = getMemberName(procedure);
    String ownerClassType = _getClassDeclareType(procedure.enclosingClass!);

    var typeStr = getTypeParametersDiff(
        procedure.enclosingClass!, function.typeParameters);
    if (isHeader) {
      bool isOverride = isOverrideMember(procedure.enclosingClass!, procedure);
      write(
          "${procedure.isStatic ? "static" : "virtual"} ${_getVariableDeclareType(function.returnType)} $name");
      writeParametersList(function);

      if (procedure.isAbstract) {
        write(" = 0");
      } else {
        write("${(procedure.isStatic || !isOverride) ? "" : ""}");
      }
      write(";");
      return;
    }

    if (procedure.isAbstract) {
      return;
    }

    var typeString = _getClassDeclareTypeParameters(procedure.enclosingClass!);
    var className = getClassTypeName(procedure.enclosingClass!);
    write(
        "$typeString $typeStr ${_getVariableDeclareType(function.returnType)} $className::$name");
    writeParametersList(function);
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
      write("$typeStr $classType ${getMemberName(constructor)}");
      writeParametersList(constructor.function);
      write(";");
      return;
    }

    var typeString =
        _getClassDeclareTypeParameters(constructor.enclosingClass!);
    var className = getClassTypeName(constructor.enclosingClass!);
    var classType = _getClassDeclareType(constructor.enclosingClass);
    write(
        "$typeStr $typeString $classType $className::${getMemberName(constructor)}");
    writeParametersList(constructor.function);
    write('{');
    indent();

    if (constructor.initializers.isNotEmpty) {
      for (var initializer in constructor.initializers) {
        if (initializer is FieldInitializer) {
          write('this->${initializer.field.name.text} = ');
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
    write("return this;");
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
    // statement.sor
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
      write('(');
      writeExpression(statement.condition);
      write(')->getValue()');
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
      write('(');
      writeExpression(statement.condition);
      write(')->getValue()');
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
        write('(');
        writeExpression(statement.condition!);
        write(')->getValue()');
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
      write('(');
      writeExpression(statement.condition);
      write(')->getValue()');
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
      var typeList = [
        statement.function.returnType,
        ...statement.function.positionalParameters.map((e) => e.type)
      ];
      write(
          'new LambdaWrapper<${typeList.map((e) => _getVariableDeclareType(e)).join(",")}>(');
      writeFunctionDeclaration(statement.function);
      write(')');
      // writeFunctionDeclaration(statement.function);
      write(';');
    } else {
      print2String('Unhandled statement type: ${statement.runtimeType}');
    }
  }

  void writeExpression(Expression expression) {
    //write('// ${expression.runtimeType}\n');
    if (expression is ListLiteral) {
      var typeArgument = _getVariableDeclareType(expression.typeArgument);
      write("CppNewList(");
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write(')');
    } else if (expression is SetLiteral) {
      var typeArgument = _getVariableDeclareType(expression.typeArgument);
      write("CppNewSet(");
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
      write("CppNewMap(");
      bool first = true;
      for (var entry in expression.entries) {
        if (!first) write(', ');
        first = false;
        write('MapEntry::cppNew()->cpp_Ctr_(');
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
      if (expression.functionType != null) {
        // write(
        //     'reinterpret_cast<${_getVariableDeclareType(expression.functionType!.returnType)}>(');
        // writeExpression(expression.receiver);
        // writeArgumentsListByFunctionType(
        //     expression.functionType!, expression.arguments);
        // write(')');
        write('cppApply');
        var typeList = [
          expression.functionType!.returnType,
          ...expression.arguments.types
        ];
        write("<${typeList.map((e) => _getVariableDeclareType(e)).join(",")}>");
        writeArgumentsListByFunctionType(
            expression.functionType!, expression.arguments,
            skipType: true, prefix: expression.receiver);
      } else {
        //todo
      }
    } else if (expression is ConstructorInvocation) {
      var classType = _getVariableType(expression.constructedType);
      var memberName = getMemberName(expression.target);
      write("$classType::cppNew()->$memberName");
      writeArgumentsList(expression.target.function, expression.arguments,
          skipType: true);
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
      write(
          "reinterpret_cast<${_getVariableDeclareType(expression.variable.type)}>(");
      writeExpression(expression.value);
      write(")");
    } else if (expression is VariableGet) {
      write(getVariableName(expression.variable));
    } else if (expression is ThisExpression) {
      write("this");
    } else if (expression is InstanceGet) {
      if (expression.interfaceTarget is Procedure) {
        var procedure = expression.interfaceTarget as Procedure;
        var memberName = getMemberName(procedure);
        writeInstanceTypeBefore(
            (expression.interfaceTarget as Procedure).function.returnType,
            expression.resultType);
        writeExpression(expression.receiver);
        write("->");
        write("$memberName");
        write("(");
        write(")");
        writeInstanceTypeEnd(
            (expression.interfaceTarget as Procedure).function.returnType,
            expression.resultType);
      } else {
        writeExpression(expression.receiver);
        write("->");
        write(expression.name.text);
      }
    } else if (expression is InstanceSet) {
      if (expression.interfaceTarget is Procedure) {
        var procedure = expression.interfaceTarget as Procedure;
        var memberName = getMemberName(procedure);
        // if (isFinalClassType(expression.interfaceTarget.enclosingClass!)) {
        //   write(expression.interfaceTarget.enclosingClass!.name);
        //   write("::");
        //   write("$memberName");
        //   write("(");
        //   writeExpression(expression.value);
        //   write(")");
        // } else
        {
          writeExpression(expression.receiver);
          write("->");
          write("$memberName");
          write("(");
          writeExpression(expression.value);
          write(")");
        }
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
        write("CppNewList(");
        bool first = true;
        for (var item in expression.arguments.positional) {
          if (!first) write(",");
          first = false;
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
          //   print2String("List");
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
      writeInstanceTypeBefore(expression.interfaceTarget.function.returnType,
          expression.functionType.returnType);
      if (isFinalClass(expression.interfaceTarget.enclosingClass!)) {
        write(classNameType);
        write("::");
        write("$memberName");
        writeArgumentsList(
            expression.interfaceTarget.function, expression.arguments,
            prefix: expression.receiver);
      } else {
        writeExpression(expression.receiver);
        write("->");
        write("$memberName");
        writeArgumentsList(
            expression.interfaceTarget.function, expression.arguments);
      }
      writeInstanceTypeEnd(expression.interfaceTarget.function.returnType,
          expression.functionType.returnType);
    } else if (expression is StaticGet) {
      write(expression.target.name.text);
    } else if (expression is StaticSet) {
      write(expression.target.name.text);
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is EqualsCall) {
      write("Object::equals(");
      writeExpression(expression.left);
      write(",");
      writeExpression(expression.right);
      write(")");
    } else if (expression is AsExpression) {
      write("reinterpret_cast<${_getVariableDeclareType(expression.type)}>(");
      writeExpression(expression.operand);
      write(")");
    } else if (expression is IsExpression) {
      write(
          "Bool::cppNew(reinterpret_cast<${_getVariableDeclareType(expression.type)}>(");
      writeExpression(expression.operand);
      write(") == nullptr)");
    } else if (expression is ConditionalExpression) {
      write('(');
      writeExpression(expression.condition);
      write(')->getValue()');
      write('? ');
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
      // var functionTypeStr = _getVariableType(
      //     expression.function.computeFunctionType(Nullability.undetermined));
      // var typeStr =
      //     functionTypeStr.replaceAll("FunctionApply", "ClosureWrapper");

      var typeList = [
        expression.function.returnType,
        ...expression.function.positionalParameters.map((e) => e.type)
      ];
      write(
          'new LambdaWrapper<${typeList.map((e) => _getVariableDeclareType(e)).join(",")}>(');
      writeFunctionDeclaration(expression.function);
      write(')');
    } else if (expression is StringConcatenation) {
      {
        bool first = true;
        for (var exp in expression.expressions) {
          if (!first) {
            write('String::');
            write(specialNames["+"]!);
            write("(");
          }
          first = false;
        }
      }

      {
        bool first = true;
        for (var exp in expression.expressions) {
          if (!first) {
            write(",");
          }
          write("cppToString(");
          writeExpression(exp);
          write(")");
          if (!first) write(")");
          first = false;
        }
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
      write("Bool::cppNew(");
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
        write("this");
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
        write("this");
        write("->");
        write(expression.name.text);
        write(" = ");
        writeExpression(expression.value);
      }
    } else if (expression is SuperMethodInvocation) {
      write(getMemberInvokeName(expression.interfaceTarget));
      writeArgumentsList(
          expression.interfaceTarget.function, expression.arguments);
    } else {
      // Handle other expression types
      print2String('Unhandled expression type: ${expression.runtimeType}');
    }
  }

  void writeParametersList(FunctionNode function,
      {String ownerClassType = ""}) {
    write('(');
    bool first = true;
    if (ownerClassType.isNotEmpty) {
      first = false;
      write("$ownerClassType this");
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
    // if (!skipType && arguments.types.isNotEmpty) {
    //   write(
    //       "<${arguments.types.map((e) => _getVariableDeclareType(e)).join(",")}>");
    // }
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
}

import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

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

bool isHideClass(Class? cls) {
  if (cls == null) {
    return true;
  }

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
  '==': 'equals',
  '!=': 'notEquals',
  '+': 'add',
  '-': 'subtract',
  '*': 'multiply',
  '/': 'divide',
  '%': 'modulo',
  '<': 'lessThan',
  '<=': 'lessOrEqual',
  '>': 'greaterThan',
  '>=': 'greaterOrEqual',
  '[]': 'getIndex',
  '[]=': 'setIndex',
  '~': 'bitwiseNot',
  '&': 'bitwiseAnd',
  '|': 'bitwiseOr',
  '^': 'bitwiseXor',
  '<<': 'leftShift',
  '>>': 'rightShift',
  '>>>': 'unsignedRightShift',
  '~/': 'integerDivide',
  'unary-': 'negate',
};

final Map<String, String> operatorNames = {
  '==': 'equals',
  '!=': 'notEquals',
  '+': 'add',
  '-': 'subtract',
  '*': 'multiply',
  '/': 'divide',
  '%': 'modulo',
  '<': 'lessThan',
  '<=': 'lessOrEqual',
  '>': 'greaterThan',
  '>=': 'greaterOrEqual',
  '[]': 'getIndex',
  '[]=': 'setIndex',
  '~': 'bitwiseNot',
  '&': 'bitwiseAnd',
  '|': 'bitwiseOr',
  '^': 'bitwiseXor',
  '<<': 'leftShift',
  '>>': 'rightShift',
  '>>>': 'unsignedRightShift',
  '~/': 'integerDivide',
  'unary-': 'negate',
};

bool isFinalClassType(String name) {
  const Set<String> classNames = {'Int', 'Double', 'Num', 'Bool', 'String'};
  return classNames.contains(name);
}

String getClassName(Class classInfo) {
  var name = classInfo.name
      .replaceAll("&", "_")
      .replaceAll("<", "_")
      .replaceAll(">", "_")
      .replaceAll(".", "_")
      .replaceAll(" ", "_");
  if (typeNames.containsKey(name)) {
    name = typeNames[name]!;
  } else if (isHideClass(classInfo)) {
    name = "Object";
  }
  return name;
}

String getClassTypeName(Class classInfo) {
  // 去除泛型参数，直接返回类名
  return getClassName(classInfo);
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

    // 检查是否是Object类的方法，需要加前缀
    if (memberName == "toString") {
      return "Object_toString";
    }
  }

  if (memberName.isEmpty) {
    return "cppEpt_";
  }

  var finalName = specialNames.containsKey(memberName)
      ? specialNames[memberName]!
      : memberName;
  return finalName;
}

String getMemberInvokeName(Member member) {
  // 现在直接返回全局方法名，因为方法名已经包含了类名前缀
  return getMemberName(member);
}

class CppCodePrinter {
  final Set<String> _implementationClasses = {};
  final Map<LabeledStatement, String> _labelNames = {};
  final Map<VariableDeclaration, String> _variableNames = {};
  final List<VariableDeclaration> _letNames = [];

  final StringBuffer _headerBuffer = StringBuffer(); // output.h 内容
  final StringBuffer _sourceBuffer = StringBuffer(); // output.cpp 内容
  StringBuffer _buffer = StringBuffer(); // 当前工作缓冲区
  int _indentLevel = 0;
  bool isHeader = false;
  String? _thisContext; // 当前 this 指针上下文

  // 主要翻译入口方法
  void translateComponent(Component component) {
    var classList = <Class>[];
    for (final library in component.libraries) {
      classList.addAll(library.classes);
    }

    var classMap = _getClassList(classList);

    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }
      _implementationClasses
          .addAll(cls.implementedTypes.map((e) => getClassName(e.classNode)));
    }

    // 生成头文件内容
    _generateHeaderFile(classList, classMap);

    // 生成源文件内容
    _generateSourceFile(classList, classMap);

    // 输出到文件
    _writeToFiles();
  }

  // 生成头文件内容
  void _generateHeaderFile(
      List<Class> classList, Map<Class, List<ClassMember>> classMap) {
    _switchToHeaderBuffer();

    // 打印头文件头部
    _printHeaderFileHeader();

    // 打印前置声明
    write("\n// Forward Declarations\n// ===================\n\n");
    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }
      write("class ${getClassName(cls)};");
      writeNewline();
    }
    writeNewline();

    // 打印类定义
    write("\n// Class Definitions\n// ================\n\n");
    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }
      _printClassDefinition(cls, classMap);
    }
  }

  // 生成源文件内容
  void _generateSourceFile(
      List<Class> classList, Map<Class, List<ClassMember>> classMap) {
    _switchToSourceBuffer();

    // 打印源文件头部
    _printSourceFileHeader();

    // 打印类实现
    for (final cls in classList) {
      if (isHideClass(cls)) {
        continue;
      }

      write("// " + cls.enclosingLibrary.toStringInternal());
      writeNewline();
      _printClassImplementation(classMap, cls);
      writeNewline();
    }
  }

  // 打印头文件头部
  void _printHeaderFileHeader() {
    write('''#ifndef OUTPUT_H
#define OUTPUT_H

#include <cstdio>
#include <cstdlib>
#include <sstream>
#include <string>
#include "src/core/object.h"
#include "src/core/func.h"
#include "src/core/num.h"
#include "src/core/string.h"
#include "src/core/array.h"
#include "src/core/list.h"
#include "src/core/iterator.h"

''');
  }

  // 打印源文件头部
  void _printSourceFileHeader() {
    write('''#include "output.h"

''');
  }

  // 切换到头文件缓冲区
  void _switchToHeaderBuffer() {
    _buffer = _headerBuffer;
    _indentLevel = 0;
    isHeader = true;
  }

  // 切换到源文件缓冲区
  void _switchToSourceBuffer() {
    _buffer = _sourceBuffer;
    _indentLevel = 0;
    isHeader = false;
  }

  // 写入到文件
  void _writeToFiles() {
    // 完成头文件
    _switchToHeaderBuffer();
    write('\n#endif // OUTPUT_H\n');

    try {
      // 写入头文件
      final headerFile = File('./output.h');
      headerFile.writeAsStringSync(_headerBuffer.toString());
      print('成功生成头文件: ${headerFile.absolute.path}');

      // 写入源文件
      final sourceFile = File('./output.cpp');
      sourceFile.writeAsStringSync(_sourceBuffer.toString());
      print('成功生成源文件: ${sourceFile.absolute.path}');
    } catch (e) {
      print('写入文件时发生错误: $e');

      // 如果文件写入失败，回退到控制台输出
      print("\n=== output.h (文件写入失败，显示内容) ===");
      print(_headerBuffer.toString());

      print("\n=== output.cpp (文件写入失败，显示内容) ===");
      print(_sourceBuffer.toString());
    }
  }

  // 获取类声明类型参数（去除泛型支持）
  String _getClassDeclareTypeParameters(Class cls) {
    // 不再生成泛型模板参数
    return "";
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

  // 打印类声明头部（不再包含 cppNew 函数声明）
  void _printClassDeclarationHeader(
      Map<Class, List<ClassMember>> map, Class cls) {
    // 不再生成全局 cppNew 函数声明，因为它现在是类的静态方法
  }

  // 打印类声明实现（包含类定义和全局方法）
  void _printClassImplementation(Map<Class, List<ClassMember>> map, Class cls) {
    var className = getClassName(cls);
    var isAbstract = _isAbstractClass(cls);

   {
      // 生成成员函数实现
      var memberList = map[cls]!;
      for (var procedure in memberList) {
        if (procedure.member.enclosingClass == cls) {
          var methodName = getMemberName(procedure.member);
          var methodSignature =
              _generateMemberFunctionSignature(procedure.member);

          // 添加类作用域和noexcept修饰符
          write("$methodSignature noexcept {");
          writeNewline();
          indent();

          if (procedure.member is Constructor) {
            // 构造函数实现
            var constructor = procedure.member as Constructor;
            // 初始化字段
            for (var field in cls.fields) {
              if (!field.isStatic) {
                write("this->${field.name.text} = nullptr;");
                writeNewline();
              }
            }

            // 执行构造函数体
            write("// 执行构造函数体");
            writeNewline();
            if (constructor.function.body != null) {
              writeStatement(constructor.function.body!);
            }
            write("return this;");
          } else if (procedure.member is Procedure) {
            // 普通成员函数实现
            var func = procedure.member as Procedure;
            if (func.function.body != null) {
              // 设置this上下文
              var originalThis = _thisContext;
              _thisContext = "this";
              writeStatement(func.function.body!);
              _thisContext = originalThis;
            } else {
              // 如果没有方法体，生成默认返回值
              var returnType =
                  _getVariableDeclareType(func.function.returnType);
              if (returnType != "void") {
                write("return nullptr;");
              }
            }
          }

          unindent();
          write("}");
          writeNewline();
          writeNewline();
        }
      }

      // 生成静态 cppNew 方法实现
      write("${className}* ${className}::cppNew() noexcept {");
      writeNewline();
      indent();
      write("// 分配对象内存");
      writeNewline();
      write("auto ptr = new ${className}();");
      writeNewline();
      write("if (ptr == nullptr) return nullptr;");
      writeNewline();
      writeNewline();
      write("// 初始化所有字段为nullptr");
      writeNewline();
      for (var field in cls.fields) {
        write("ptr->${field.name.text} = nullptr;");
        writeNewline();
      }
      write("return ptr;");
      writeNewline();
      unindent();
      write("}");
      writeNewline();
      writeNewline();
    }
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

    List<ClassMember> memberList = [];

    // 只处理当前类自己定义的成员，不包含继承的成员
    for (var constructor in cls.constructors) {
      _replaceOrAddMembersList(memberList, constructor);
    }

    for (var procedure in cls.procedures) {
      if (procedure.name.text != "_typeArguments") {
        _replaceOrAddMembersList(memberList, procedure);
      }
    }

    // 对于Object类，添加toString方法
    if (cls.name == "Object") {
      for (var procedure in cls.procedures) {
        if (procedure.name.text == "toString") {
          _replaceOrAddMembersList(memberList, procedure);
        }
      }
    }

    map[cls] = memberList;
    return memberList;
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

  // 获取原始方法名（不带类名前缀）
  String _getOriginalMethodName(Member member) {
    if (member is Constructor) {
      // 构造方法只加 cppCtr_ 前缀，不加类名
      return "cppCtr_${member.name.text}";
    } else if (member is Procedure) {
      var baseName = member.name.text;

      // 检查是否是运算符方法
      if (operatorNames.containsKey(baseName)) {
        return "cpp_${operatorNames[baseName]}";
      }

      if (member.isGetter) {
        // getter 方法加 cppGet_ 前缀
        return "cppGet_$baseName";
      } else if (member.isSetter) {
        // setter 方法加 cppSet_ 前缀
        return "cppSet_$baseName";
      } else {
        // 所有普通方法都加 cpp_ 前缀
        return "cpp_$baseName";
      }
    } else {
      return member.name.text;
    }
  }

  bool _isOverloadedMethod(Procedure procedure) {
    if (procedure.enclosingClass == null) return false;

    // 检查同名方法数量
    var sameNameMethods = procedure.enclosingClass!.procedures
        .where((p) => p.name.text == procedure.name.text)
        .length;
    return sameNameMethods > 1;
  }

  // 生成成员函数签名
  String _generateMemberFunctionSignature(Member member,
      {bool isAbstract = false}) {
    var returnType = _getVariableDeclareType(member.function!.returnType);
    var className = getClassName(member.enclosingClass!);
    if (isAbstract) {
      className = "${className}Imp";
    }
    var methodName = getMemberName(member);

    if (member is Constructor) {
      var parameters = <String>[];
      for (var param in member.function.positionalParameters) {
        parameters.add("${_getVariableDeclareType(param.type)} ${param.name}");
      }
      return "${className}* ${className}::$methodName(${parameters.join(', ')})";
    } else if (member is Procedure) {
      var parameters = <String>[];
      for (var param in member.function.positionalParameters) {
        parameters.add("${_getVariableDeclareType(param.type)} ${param.name}");
      }
      return "$returnType ${className}::$methodName(${parameters.join(', ')})";
    }
    return "";
  }

  // 获取参数类型（去除泛型支持）
  String _getVariableType(DartType type) {
    if (type is InterfaceType) {
      // 去除泛型参数，直接返回类名
      var name = getClassName(type.classNode);
      return name;
    } else if (type is FunctionType) {
      // 函数类型简化为 Function
      return "Function";
    } else if (type is DynamicType) {
      return "Object"; // 改为Object而不是void*
    } else if (type is FutureOrType) {
      return _getVariableType(type.typeArgument);
    } else if (type is NeverType) {
      return "void";
    } else if (type is InvalidType) {
      return "Object"; // 改为Object而不是void*
    } else if (type is VoidType) {
      return "void";
    } else if (type is TypeParameterType) {
      return "Object"; // 泛型参数统一使用Object
    } else if (type is NullType) {
      return "Object";
    } else {
      return "Object"; // 默认使用Object而不是void*
    }
  }

  String _getVariableDeclareType(DartType type) {
    if (type is TypeParameterType) {
      // 泛型参数统一使用Object指针
      return "Object*";
    }
    var typeStr = _getVariableType(type);
    if (typeStr == "void") {
      return typeStr;
    }
    // 所有对象类型都使用指针
    return "$typeStr*";
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
    // 去除泛型模板参数支持
    return "";
  }

  getDeclareClassTypeParametersDiff(Class cls, List<DartType> typeParameters) {
    // 去除泛型支持，直接返回类名
    var name = getClassName(cls);
    return name;
  }

  void writeMemberFunctionDeclaration(Procedure procedure) {
    FunctionNode function = procedure.function;
    String name = getMemberName(procedure);
    String ownerClassType = _getClassDeclareType(procedure.enclosingClass!);

    if (isHeader) {
      write("${_getVariableDeclareType(function.returnType)} $name");
      writeParametersList(function,
          ownerClassType: procedure.isStatic ? "" : ownerClassType);
      write(";");
      return;
    }

    // 生成全局函数实现（去除类作用域和泛型）
    write("${_getVariableDeclareType(function.returnType)} $name");
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
    var classType = _getClassDeclareType(constructor.enclosingClass);
    String name = getMemberName(constructor);

    if (isHeader) {
      write("$classType $name");
      writeParametersList(constructor.function, ownerClassType: classType);
      write(";");
      return;
    }

    // 生成全局构造函数实现（去除类作用域和泛型）
    write("$classType $name");
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
      write(';');
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
          write('if(switchValue->value == ');
          if (switchCase.expressions.first is IntLiteral) {
            write(switchCase.expressions.first.toString());
          } else {
            writeExpression(switchCase.expressions.first);
            write('->value');
          }
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
      write('break;');
    } else if (statement is ContinueSwitchStatement) {
      write('continue;');
    } else if (statement is VariableDeclaration) {
      write('${_getVariableDeclareType(statement.type)} ');
      write(getVariableName(statement));
      if (statement.initializer != null) {
        write(' = ');
        writeExpression(statement.initializer!);
      } else {
        // 为未初始化的变量提供默认值
        var type = _getVariableType(statement.type);
        if (type == "Int") {
          write(' = Int::cppNew(0)');
        } else if (type == "String") {
          write(' = String::cppNew("")');
        } else if (type == "Bool") {
          write(' = Bool::cppNew(false)');
        } else if (type == "List") {
          write(' = CppList::cppNew()');
        } else {
          write(' = nullptr');
        }
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
      write(';'); // 添加默认的分号，避免语法错误
    }
  }

  void writeExpression(Expression expression) {
    if (expression == null) {
      write("nullptr");
      return;
    }

    if (expression is Let) {
      // 处理Let表达式
      writeVariableDeclaration(expression.variable);
      write("; ");
      writeExpression(expression.body);
    } else if (expression is EqualsCall) {
      // 处理EqualsCall表达式
      write("(");
      writeExpression(expression.left);
      write("->equals(");
      writeExpression(expression.right);
      write("))");
    } else if (expression is EqualsNull) {
      // 处理EqualsNull表达式
      write("(");
      writeExpression(expression.expression);
      write(" == nullptr)");
    } else if (expression is ConditionalExpression) {
      write("(");
      writeExpression(expression.condition);
      write(" ? ");
      writeExpression(expression.then);
      write(" : ");
      writeExpression(expression.otherwise);
      write(")");
    } else if (expression is IsExpression) {
      write("(");
      writeExpression(expression.operand);
      write(" != nullptr)");
    } else if (expression is AsExpression) {
      writeExpression(expression.operand);
    } else if (expression is InvalidExpression) {
      write("nullptr");
    } else if (expression is VariableGet) {
      write(getVariableName(expression.variable));
    } else if (expression is VariableSet) {
      write(getVariableName(expression.variable));
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is InstanceGet) {
      // 处理getter调用
      writeExpression(expression.receiver);
      write("->");
      if (expression.interfaceTarget is Procedure) {
        var procedure = expression.interfaceTarget as Procedure;
        var methodName = _getOriginalMethodName(procedure);
        if (procedure.isGetter) {
          write(methodName);
          write("()");
        } else {
          write(methodName);
        }
      } else {
        write(expression.name.text);
      }
    } else if (expression is InstanceSet) {
      // 处理setter调用
      writeExpression(expression.receiver);
      write("->");
      if (expression.interfaceTarget is Procedure) {
        var procedure = expression.interfaceTarget as Procedure;
        if (procedure.isSetter) {
          write(_getOriginalMethodName(procedure));
          write("(");
          writeExpression(expression.value);
          write(")");
        } else {
          write(expression.name.text);
          write(" = ");
          writeExpression(expression.value);
        }
      } else {
        write(expression.name.text);
        write(" = ");
        writeExpression(expression.value);
      }
    } else if (expression is StaticGet) {
      // 处理静态字段访问
      if (expression.target.enclosingClass != null) {
        var className = getClassName(expression.target.enclosingClass!);
        write("${className}::");
        write(_getOriginalMethodName(expression.target));
        if (expression.target is Procedure &&
            (expression.target as Procedure).isGetter) {
          write("()");
        }
      } else {
        write(_getOriginalMethodName(expression.target));
      }
    } else if (expression is StaticSet) {
      // 处理静态字段赋值
      if (expression.target.enclosingClass != null) {
        var className = getClassName(expression.target.enclosingClass!);
        write("${className}::");
        if (expression.target is Procedure &&
            (expression.target as Procedure).isSetter) {
          write(_getOriginalMethodName(expression.target));
          write("(");
          writeExpression(expression.value);
          write(")");
        } else {
          write(_getOriginalMethodName(expression.target));
          write(" = ");
          writeExpression(expression.value);
        }
      } else {
        write(_getOriginalMethodName(expression.target));
        write(" = ");
        writeExpression(expression.value);
      }
    } else if (expression is ConstructorInvocation) {
      // 处理构造函数调用
      var className = getClassName(expression.target.enclosingClass!);
      write("${className}::cppNew()->");
      // 只使用 cppCtr_ 前缀，不加类名
      write(_getOriginalMethodName(expression.target));
      writeArgumentsList(expression.arguments);
    } else if (expression is InstanceInvocation) {
      // 处理实例方法调用
      writeExpression(expression.receiver);
      write("->");
      write(_getOriginalMethodName(expression.interfaceTarget));
      writeArgumentsList(expression.arguments);
    } else if (expression is SuperMethodInvocation) {
      // 处理父类方法调用
      write("this->");
      write(_getOriginalMethodName(expression.interfaceTarget));
      writeArgumentsList(expression.arguments);
    } else if (expression is StaticInvocation) {
      // 处理静态方法调用
      if (expression.target.enclosingClass != null) {
        var className = getClassName(expression.target.enclosingClass!);
        write("${className}::");
      }
      write(_getOriginalMethodName(expression.target));
      writeArgumentsList(expression.arguments);
    } else if (expression is IntLiteral) {
      write("Int::cppNew(${expression.value})");
    } else if (expression is DoubleLiteral) {
      write("Double::cppNew(${expression.value})");
    } else if (expression is BoolLiteral) {
      write("Bool::cppNew(${expression.value})");
    } else if (expression is StringLiteral) {
      write(
          'String::cppNew("${expression.value}", ${expression.value.length})');
    } else if (expression is NullLiteral) {
      write("nullptr");
    } else if (expression is ListLiteral) {
      write("CppList::cppNew()");
    } else if (expression is MapLiteral) {
      write("CppMap::cppNew()");
    } else if (expression is SetLiteral) {
      write("CppSet::cppNew()");
    } else if (expression is Not) {
      write("!(");
      writeExpression(expression.operand);
      write(")");
    } else if (expression is LogicalExpression) {
      write("(");
      writeExpression(expression.left);
      write(" ");
      switch (expression.runtimeType.toString()) {
        case "LogicalAndExpression":
          write("&&");
          break;
        case "LogicalOrExpression":
          write("||");
          break;
        default:
          write("&&"); // 默认使用 AND
      }
      write(" ");
      writeExpression(expression.right);
      write(")");
    } else if (expression is StringConcatenation) {
      write("String::cppNew(");
      var first = true;
      for (var expr in expression.expressions) {
        if (!first) write(" + ");
        first = false;
        writeExpression(expr);
      }
      write(")");
    } else if (expression is ThisExpression) {
      write("this");
    } else if (expression is Throw) {
      write("throw std::runtime_error(\"Exception\")");
    } else if (expression is BlockExpression) {
      write("{");
      for (var stmt in expression.body.statements) {
        writeStatement(stmt);
      }
      write("}");
    } else if (expression is FunctionExpression) {
      writeFunctionDeclaration(expression.function);
    } else if (expression is FunctionInvocation) {
      // 处理函数调用
      if (expression.name != null) {
        write(expression.name!.text);
      } else {
        writeExpression(expression.receiver);
      }
      write("(");
      var first = true;
      for (var arg in expression.arguments.positional) {
        if (!first) write(", ");
        first = false;
        writeExpression(arg);
      }
      write(")");
    } else if (expression is NullCheck) {
      write("(");
      writeExpression(expression.operand);
      write(" != nullptr ? ");
      writeExpression(expression.operand);
      write(" : throw std::runtime_error(\"Null check failed\"))");
    } else if (expression is ConstantExpression) {
      // 处理常量表达式
      if (expression.constant is StringConstant) {
        var str = expression.constant as StringConstant;
        write('String::cppNew("${str.value}", ${str.value.length})');
      } else if (expression.constant is IntConstant) {
        var num = expression.constant as IntConstant;
        write("Int::cppNew(${num.value})");
      } else if (expression.constant is DoubleConstant) {
        var num = expression.constant as DoubleConstant;
        write("Double::cppNew(${num.value})");
      } else if (expression.constant is BoolConstant) {
        var bool = expression.constant as BoolConstant;
        write("Bool::cppNew(${bool.value})");
      } else if (expression.constant is NullConstant) {
        write("nullptr");
      } else if (expression.constant is StaticTearOffConstant) {
        // 处理静态方法引用
        var staticTearOff = expression.constant as StaticTearOffConstant;
        if (staticTearOff.target.enclosingClass != null) {
          var className = getClassName(staticTearOff.target.enclosingClass!);
          write("${className}::");
        }
        write(_getOriginalMethodName(staticTearOff.target));
      } else {
        print('Unhandled constant type: ${expression.constant.runtimeType}');
        write("nullptr");
      }
    } else if (expression is SuperPropertyGet) {
      // 处理父类属性访问
      write("this->");
      write(expression.name.text);
    } else if (expression is DynamicGet) {
      // 处理动态属性访问
      writeExpression(expression.receiver);
      write("->");
      write(expression.name.text);
    } else {
      print('Unhandled expression type: ${expression.runtimeType}');
      write("nullptr");
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

  void writeArgumentsList(Arguments arguments) {
    write("(");
    var first = true;
    for (var arg in arguments.positional) {
      if (!first) write(", ");
      first = false;
      writeExpression(arg);
    }
    write(")");
  }

  void writeArgumentsListByFunctionType(
      FunctionType function, Arguments arguments,
      {Expression? prefix, String? prefixStr, bool skipType = false}) {
    // 去除泛型模板参数支持
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
        // if (namedParameter.value.initializer != null) {
        //   writeExpression(namedParameter.initializer!);
        // } else {
        //   write("nullptr");
        // }
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
      writeArgumentsList(expression.arguments);
    } else {
      // Handle other expression types
      print('Unhandled expression type: ${expression.runtimeType}');
    }
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

  // 处理构造函数调用
  void _writeConstructorInvocation(ConstructorInvocation node) {
    var className = getClassTypeName(node.target.enclosingClass!);
    var constructorName = _getOriginalMethodName(node.target);

    // 先调用 cppNew 分配内存
    write("${className}::cppNew()->");

    // 然后调用构造函数
    write("$constructorName(");

    // 写入构造函数参数
    writeArgumentsList(node.arguments);

    write(")");
  }

  bool _isInterfaceClass(Class cls) {
    // 判断是否是接口类
    // const interfaceClasses = {
    //   'Iterator',
    //   'Iterable',
    //   'List',
    //   'Map',
    //   'Set',
    //   'MapEntry',
    //   'Comparable',
    //   'ListBase',
    //   'MapBase',
    //   'SetBase',
    //   'EfficientLengthIterable',
    //   'SubListIterable',
    //   'ListIterator',
    //   'MappedListIterable',
    //   'WhereIterable',
    //   'ExpandIterable',
    //   'TakeWhileIterable',
    //   'SkipWhileIterable',
    //   'FollowedByIterable',
    //   'WhereTypeIterable',
    //   'ListMapView',
    //   'ReversedListIterable',
    // };
    return (cls.constructors.isEmpty &&
        cls.fields.isEmpty &&
        cls.procedures.every((procedure) => procedure.isAbstract));
  }

  bool _isAbstractClass(Class cls) {
    // 判断是否是抽象类
    return cls.isAbstract &&
        !_isInterfaceClass(cls) &&
        cls.name != 'Object' &&
        !cls.name.startsWith('Cpp');
  }

  void _printClassDefinition(
      Class cls, Map<Class, List<ClassMember>> classMap) {
    var className = getClassName(cls);
    var isImplementationClass = _implementationClasses.contains(className);
    var isAbstract = _isAbstractClass(cls);

    // 生成实现类定义（class）
    var currentClassName = className;
    var superClassName = (isHideClass(cls.superclass!)
        ? 'Object'
        : getClassName(cls.superclass!));
    write("class ${currentClassName} : virtual public $superClassName {\n");
    write(" public:\n");

    // 添加字段声明
    if (cls.fields.isNotEmpty) {
      for (var field in cls.fields) {
        if (!field.isStatic) {
          var fieldType = _getVariableType(field.type);
          write("  $fieldType* ${field.name.text};\n");
        }
      }
      write("\n");
    }

    if (cls.constructors.isNotEmpty) {
      // 添加构造函数声明
      for (var constructor in cls.constructors) {
        var constructorName = getMemberName(constructor);
        var parameters = _generateParameterList(constructor.function);
        write(
            "  virtual ${currentClassName}* $constructorName($parameters) noexcept;\n");
      }
      write("\n");
    }

    // 生成方法声明 - 重写接口中的方法
    var memberList = classMap[cls]!;
    for (var member in memberList) {
      if (member.member is Procedure && member.member.enclosingClass == cls) {
        var procedure = member.member as Procedure;
        var returnType = _getVariableDeclareType(procedure.function.returnType);
        var methodName = getMemberName(procedure);
        var parameters = _generateParameterList(procedure.function);
        if (procedure.isAbstract) {
          write(
              "  virtual $returnType $methodName($parameters) noexcept = 0;\n");
        } else {
          write(
              "  virtual $returnType $methodName($parameters) noexcept override;\n");
        }
      }
    }

    // 添加静态工厂方法和析构函数
    write("  static ${currentClassName}* cppNew() noexcept;\n");
    write("  virtual ~${currentClassName}() noexcept = default;\n");

    write("};\n\n");
  }

  // 生成格式化的参数列表（长参数列表时每个参数独占一行）
  String _generateParameterListFormatted(FunctionNode function) {
    var parameters = <String>[];

    for (var param in function.positionalParameters) {
      var paramType = _getVariableType(param.type);
      parameters.add("      $paramType* ${param.name}");
    }

    for (var param in function.namedParameters) {
      var paramType = _getVariableType(param.type);
      parameters.add("      $paramType* ${param.name}");
    }

    return parameters.join(',\n');
  }

  void _writeParameterList(FunctionNode function) {
    write('(');
    bool first = true;
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

  String _generateParameterList(FunctionNode function) {
    var parameters = <String>[];

    for (var param in function.positionalParameters) {
      var paramType = _getVariableType(param.type);
      parameters.add("$paramType* ${param.name}");
    }

    for (var param in function.namedParameters) {
      var paramType = _getVariableType(param.type);
      parameters.add("$paramType* ${param.name}");
    }

    return parameters.join(', ');
  }
}

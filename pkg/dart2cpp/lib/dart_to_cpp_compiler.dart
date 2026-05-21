import 'dart:async';
import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import 'type_analyzer.dart';

// ============================================================================
// Dart 到 C++ 转换器 - 基于现有 base 项目的完整实现
// ============================================================================

/// 清理标识符名称，将特殊字符替换为下划线
String _sanitizeIdentifier(String name) {
  if (name.isEmpty) return 'unnamed';

  // 移除开头的特殊字符
  if (name.startsWith(':') || name.startsWith('#')) {
    name = name.substring(1);
  }

  // 替换所有特殊字符为下划线
  name = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

  // 确保不以数字开头
  if (name.isNotEmpty && RegExp(r'^[0-9]').hasMatch(name)) {
    name = 'var_$name';
  }

  // C++关键字检测和重命名
  const cppKeywords = {
    'alignas',
    'alignof',
    'and',
    'and_eq',
    'asm',
    'atomic_cancel',
    'atomic_commit',
    'atomic_noexcept',
    'auto',
    'bitand',
    'bitor',
    'bool',
    'break',
    'case',
    'catch',
    'char',
    'char8_t',
    'char16_t',
    'char32_t',
    'class',
    'compl',
    'concept',
    'const',
    'consteval',
    'constexpr',
    'constinit',
    'const_cast',
    'continue',
    'co_await',
    'co_return',
    'co_yield',
    'decltype',
    'default',
    'delete',
    'do',
    'double',
    'dynamic_cast',
    'else',
    'enum',
    'explicit',
    'export',
    'extern',
    'false',
    'float',
    'for',
    'friend',
    'goto',
    'if',
    'inline',
    'int',
    'long',
    'mutable',
    'namespace',
    'new',
    'noexcept',
    'not',
    'not_eq',
    'nullptr',
    'operator',
    'or',
    'or_eq',
    'private',
    'protected',
    'public',
    'reflexpr',
    'register',
    'reinterpret_cast',
    'requires',
    'return',
    'short',
    'signed',
    'sizeof',
    'static',
    'static_assert',
    'static_cast',
    'struct',
    'switch',
    'synchronized',
    'template',
    'this',
    'thread_local',
    'throw',
    'true',
    'try',
    'typedef',
    'typeid',
    'typename',
    'union',
    'unsigned',
    'using',
    'virtual',
    'void',
    'volatile',
    'wchar_t',
    'while',
    'xor',
    'xor_eq'
  };

  if (cppKeywords.contains(name)) {
    name = '${name}_';
  }

  return name.isEmpty ? 'unnamed' : name;
}

/// 捕获变量信息类
class CapturedVarInfo {
  final String name;
  final VariableDeclaration? declaration;
  final bool isParameter;
  final bool isValueType;
  final DartType? type;

  CapturedVarInfo({
    required this.name,
    this.declaration,
    this.isParameter = false,
    this.isValueType = false,
    this.type,
  });
}

/// 需要装箱的变量信息
class BoxingVarInfo {
  final VariableDeclaration variable; // 变量声明节点
  final String varName; // 变量名
  final DartType varType; // 变量类型
  final bool isParameter; // 是否是函数参数
  final int declarationOffset; // 声明位置（用于唯一标识）

  BoxingVarInfo({
    required this.variable,
    required this.varName,
    required this.varType,
    required this.isParameter,
    required this.declarationOffset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoxingVarInfo &&
        other.variable == variable &&
        other.declarationOffset == declarationOffset;
  }

  @override
  int get hashCode => Object.hash(variable, declarationOffset);
}

/// C++ 代码常量定义
class CppConstants {
  // 基础类型映射
  static const Map<String, String> typeMapping = {
    'int': 'Int',
    'double': 'Double',
    'bool': 'Bool',
    'String': 'String',
    'void': 'Nullable',
    'dynamic': 'Any',
    'Object': 'Any', // Object 映射到 Any，因为 Any 可以持有任何类型的值
    'List': 'List',
    'Set': 'Set',
    'Map': 'Map',
    'LinkedHashSet': 'Set', // LinkedHashSet 映射到 Set
    'LinkedHashMap': 'Map', // LinkedHashMap 映射到 Map
    'Future': 'Future',
    'Stream': 'Stream',
    'StringBuffer': 'StringBuffer',
    'RegExp': 'String', // RegExp 已合并到 String 类型
    'Timer': 'Timer',
  };

  // 类型构造宏
  static const Map<String, String> constructorMapping = {
    'int': 'dart_int',
    'double': 'dart_double',
    'bool': 'dart_bool',
    'String': 'dart_string',
  };

  // 运算符映射
  static const Map<String, String> operatorMapping = {
    '+': '+',
    '-': '-',
    '*': '*',
    '/': '/',
    '%': '%',
    '~/': 'truncatingDivision',
    '==': '==',
    '!=': '!=',
    '<': '<',
    '<=': '<=',
    '>': '>',
    '>=': '>=',
    '&&': '&&',
    '||': '||',
    '!': 'operator_not',
    '&': 'operator_bitwise_and',
    '|': 'operator_bitwise_or',
    '^': 'operator_bitwise_xor',
    '<<': 'operator_shift_left',
    '>>': 'operator_shift_right',
    '~': 'operator_bitwise_not',
    'unary-': 'operator_negate',
    '??': 'dart_null_coalesce',
    '?.': 'dart_null_check',
  };

  // 关键字替换
  static const Map<String, String> keywordMapping = {
    'var': 'auto',
    'final': 'const auto',
    'const': 'const auto',
    'async': 'DART_ASYNC_FUNCTION',
    'await': 'DART_AWAIT',
  };

  // 标准头文件
  static const List<String> standardIncludes = [
    '#include "dart2cpp.h"',
  ];

  // 便利宏定义
  static const List<String> utilityMacros = [
    // '#define dart_print(value) \\',
    // '    do { \\',
    // '        std::cout << (value).toString().getValue() << std::endl; \\',
    // '    } while(0)',
    // '',
    // '#define dart_int(value) Int(value)',
    // '#define dart_double(value) Double(value)',
    // '#define dart_bool(value) Bool(value)',
    // '#define dart_string(value) String(value)',
  ];
}

/// 类型转换器
class CppTypeConverter {
  static String convertType(DartType type, {bool isAsync = false}) {
    if (type is InterfaceType) {
      // 保存原始类名用于类型映射查询
      final originalClassName = type.classNode.name;

      // 调试输出
      // print('DEBUG convertType: originalClassName=$originalClassName, inMapping=${CppConstants.typeMapping.containsKey(originalClassName)}, isBasic=${TypeAnalyzer.isBasicType(originalClassName)}');

      // 类名可能包含特殊字符（如混入类 _Bird&Object&Flyable），需要清理
      // 但基础类型不需要清理，直接使用类型映射
      // 同时检查基础类型集合，因为 Dart Kernel 中 int 的类名可能是不同的
      final className =
          CppConstants.typeMapping.containsKey(originalClassName) ||
                  TypeAnalyzer.isBasicType(originalClassName)
              ? originalClassName
              : _sanitizeIdentifier(originalClassName);

      // 处理可空类型：String? -> String（可以赋值为Null）
      if (type.nullability.toString().contains('nullable')) {
        // 获取非空版本的类型
        final nonNullType =
            convertType(type.withDeclaredNullability(Nullability.nonNullable));

        // 对于基础类型，直接返回非空类型（运行时可以赋值为Null）
        if (_isBasicType(className)) {
          return nonNullType;
        }
        // 对于对象类型，也返回非空类型（运行时使用nullptr表示null）
        return nonNullType;
      }

      // 基础类型映射
      if (CppConstants.typeMapping.containsKey(className)) {
        String cppType = CppConstants.typeMapping[className]!;
        final baseCppType = cppType; // 保存不带泛型参数的基础类型

        // 泛型类型处理 - 递归转换泛型参数，确保嵌套类型也正确包装
        if (type.typeArguments.isNotEmpty) {
          final typeArgs = type.typeArguments.map((arg) {
            // 递归转换每个泛型参数
            // 值类型保持值类型，类对象用ObjectPtr包裹
            return _convertGenericArgument(arg);
          }).join(', ');
          cppType = '$cppType<$typeArgs>';
        }

        // 异步类型处理
        if (isAsync && className == 'Future') {
          return cppType;
        }

        // 检查是否需要ObjectPtr包装
        // 使用映射后的C++类型检查，而不是Dart原始类型
        // 这样 Object -> Any 后，Any 是基本类型，不需要 ObjectPtr 包装
        if (_needsObjectPtr(baseCppType)) {
          return 'ObjectPtr<$cppType>';
        }
        return cppType;
      }

      // 自定义类型 - 只有非基本类型才用 ObjectPtr 包装
      if (_isBasicType(className)) {
        return className;
      }

      // 自定义类型也需要处理泛型参数
      if (type.typeArguments.isNotEmpty) {
        final typeArgs = type.typeArguments.map((arg) {
          return _convertGenericArgument(arg);
        }).join(', ');
        return 'ObjectPtr<$className<$typeArgs>>';
      }

      return 'ObjectPtr<$className>';
    } else if (type is FunctionType) {
      // 改进的函数类型转换，生成具体的 std::function 类型
      return _convertFunctionType(type);
    } else if (type is VoidType) {
      return 'Nullable';
    } else if (type is DynamicType) {
      return 'Any';
    } else if (type is TypeParameterType) {
      // 泛型参数类型 - 保持原样，由具体实例化时确定
      return type.parameter.name ?? 'T';
    }

    return 'Any'; // 默认类型
  }

  /// 转换泛型参数
  /// 值类型使用值类型，类对象需要用ObjectPtr包裹
  static String _convertGenericArgument(DartType argType) {
    if (argType is InterfaceType) {
      final argClassName = argType.classNode.name;

      // 值类型直接转换，不需要ObjectPtr
      if (_isBasicType(argClassName)) {
        final cppType = CppConstants.typeMapping[argClassName] ?? argClassName;
        // 递归处理嵌套泛型
        if (argType.typeArguments.isNotEmpty) {
          final nestedArgs = argType.typeArguments.map((arg) {
            return _convertGenericArgument(arg);
          }).join(', ');
          return '$cppType<$nestedArgs>';
        }

        return cppType;


      }

      // 类对象需要ObjectPtr包裹
      final cppType = CppConstants.typeMapping[argClassName] ?? argClassName;
      if (argType.typeArguments.isNotEmpty) {
        final nestedArgs = argType.typeArguments.map((arg) {
          return _convertGenericArgument(arg);
        }).join(', ');
        return 'ObjectPtr<$cppType<$nestedArgs>>';
      }
      return 'ObjectPtr<$cppType>';
    } else if (argType is DynamicType) {
      return 'Any';
    } else if (argType is TypeParameterType) {
      // 泛型参数类型，保持原样
      return argType.parameter.name ?? 'T';
    } else if (argType is VoidType) {
      return 'Nullable';
    }

    // 其他未知类型默认返回Any
    return 'Any';
  }

  static String convertLiteral(dynamic value) {
    if (value is String) {
      // Escape special characters in strings
      final escaped = value
          .replaceAll('\\', '\\\\') // Backslash must be first
          .replaceAll('"', '\\"') // Double quote
          .replaceAll('\n', '\\n') // Newline
          .replaceAll('\r', '\\r') // Carriage return
          .replaceAll('\t', '\\t'); // Tab
      // Note: $ doesn't need escaping in C++ strings, only in Dart string interpolation
      return 'dart_string("$escaped")';
    } else if (value is int) {
      return 'dart_int($value)';
    } else if (value is double) {
      return 'dart_double($value)';
    } else if (value is bool) {
      return 'dart_bool($value)';
    }
    return value.toString();
  }

  static bool _needsObjectPtr(String className) {
    // 基本类型不需要ObjectPtr包装
    return !_isBasicType(className);
  }

  /// 检查是否是基本类型 - 使用全局统一定义
  static bool _isBasicType(String className) {
    return TypeAnalyzer.isBasicType(className);
  }

  /// 转换函数类型为 ObjectPtr<TypedFunction<R, Args...>>
  /// TypedFunction 只需要返回类型和参数类型，不需要 std::function
  static String _convertFunctionType(FunctionType type) {
    final returnType = convertType(type.returnType);

    // 处理位置参数 - 确保参数类型也正确转换（包括 ObjectPtr 包装）
    final positionalParams =
        type.positionalParameters.map((param) => convertType(param)).toList();

    // 处理命名参数（转换为额外的位置参数）- 确保参数类型也正确转换
    final namedParams =
        type.namedParameters.map((param) => convertType(param.type)).toList();

    // 合并所有参数
    final allParams = [...positionalParams, ...namedParams];

    // 生成 ObjectPtr<TypedFunction<ReturnType, Args...>> 格式
    // TypedFunction 只需要返回类型和参数类型
    if (allParams.isEmpty) {
      return 'ObjectPtr<TypedFunction<$returnType>>';
    } else {
      final paramTypes = allParams.join(', ');
      return 'ObjectPtr<TypedFunction<$returnType, $paramTypes>>';
    }
  }

  /// 转换函数类型为 ObjectPtr<TypedFunction<R, Args...>>
  /// 不再需要模板参数名，TypedFunction 只需要返回类型和参数类型
  static String convertFunctionTypeWithTemplate(
      FunctionType type, String templateParamName) {
    final returnType = convertType(type.returnType);

    // 处理位置参数
    final positionalParams =
        type.positionalParameters.map((param) => convertType(param)).toList();

    // 处理命名参数
    final namedParams =
        type.namedParameters.map((param) => convertType(param.type)).toList();

    // 合并所有参数
    final allParams = [...positionalParams, ...namedParams];

    // 生成 ObjectPtr<TypedFunction<ReturnType, Args...>> 格式
    // 不再需要模板参数名作为第一个参数
    if (allParams.isEmpty) {
      return 'ObjectPtr<TypedFunction<$returnType>>';
    } else {
      final paramTypes = allParams.join(', ');
      return 'ObjectPtr<TypedFunction<$returnType, $paramTypes>>';
    }
  }

  /// 收集函数参数中的 FunctionType 参数信息
  /// 返回一个列表，包含每个 FunctionType 参数的索引和类型
  static List<MapEntry<int, FunctionType>> collectFunctionTypeParams(
      FunctionNode function) {
    final result = <MapEntry<int, FunctionType>>[];
    int index = 0;

    for (final param in function.positionalParameters) {
      if (param.type is FunctionType) {
        result.add(MapEntry(index, param.type as FunctionType));
      }
      index++;
    }

    for (final param in function.namedParameters) {
      if (param.type is FunctionType) {
        result.add(MapEntry(index, param.type as FunctionType));
      }
      index++;
    }

    return result;
  }

  /// 生成额外的函数类型模板参数声明
  /// TypedFunction 已简化为 <R, Args...>，不再需要额外的函数类型模板参数
  /// 始终返回空字符串
  static String generateFunctionTypeTemplateParams(FunctionNode function) {
    // TypedFunction 现在只需要 <R, Args...>，不需要额外的 _F1, _F2 等模板参数
    return '';
  }

  /// 从 DartType 中递归收集所有使用的 TypeParameterType 的名称
  /// 用于确保模板声明包含所有在返回类型和参数类型中使用的泛型参数
  static Set<String> collectTypeParametersFromType(DartType type) {
    final result = <String>{};
    _collectTypeParametersRecursive(type, result);
    return result;
  }

  /// 递归收集类型中的类型参数
  static void _collectTypeParametersRecursive(
      DartType type, Set<String> result) {
    if (type is TypeParameterType) {
      // 直接是类型参数
      final name = type.parameter.name;
      if (name != null) {
        result.add(name);
      }
    } else if (type is InterfaceType) {
      // 接口类型，检查其泛型参数
      for (final arg in type.typeArguments) {
        _collectTypeParametersRecursive(arg, result);
      }
    } else if (type is FunctionType) {
      // 函数类型，检查返回类型和参数类型
      _collectTypeParametersRecursive(type.returnType, result);
      for (final param in type.positionalParameters) {
        _collectTypeParametersRecursive(param, result);
      }
      for (final param in type.namedParameters) {
        _collectTypeParametersRecursive(param.type, result);
      }
      // 也收集函数类型自身的类型参数
      for (final typeParam in type.typeParameters) {
        final name = typeParam.name;
        if (name != null) {
          result.add(name);
        }
      }
    }
  }

  /// 从 FunctionNode 中收集所有在返回类型和参数类型中使用的类型参数
  static Set<String> collectAllTypeParametersFromFunction(
      FunctionNode function) {
    final result = <String>{};

    // 收集返回类型中的类型参数
    result.addAll(collectTypeParametersFromType(function.returnType));

    // 收集位置参数类型中的类型参数
    for (final param in function.positionalParameters) {
      result.addAll(collectTypeParametersFromType(param.type));
    }

    // 收集命名参数类型中的类型参数
    for (final param in function.namedParameters) {
      result.addAll(collectTypeParametersFromType(param.type));
    }

    return result;
  }

  /// 检查 FunctionType 的返回类型是否包含 dynamic/Any
  /// 用于判断是否需要使用 auto 返回类型
  static bool functionTypeReturnContainsAny(FunctionType type) {
    return _typeContainsDynamic(type.returnType);
  }

  /// 检查类型是否包含 dynamic
  static bool _typeContainsDynamic(DartType type) {
    if (type is DynamicType) {
      return true;
    } else if (type is FunctionType) {
      // 检查返回类型和参数类型
      if (_typeContainsDynamic(type.returnType)) return true;
      for (final param in type.positionalParameters) {
        if (_typeContainsDynamic(param)) return true;
      }
      for (final param in type.namedParameters) {
        if (_typeContainsDynamic(param.type)) return true;
      }
      return false;
    } else if (type is InterfaceType) {
      // 检查泛型参数
      for (final arg in type.typeArguments) {
        if (_typeContainsDynamic(arg)) return true;
      }
      return false;
    }
    return false;
  }
}

class ExpressionConverter {
  final DartToCppTransformer transformer;
  final CppStatementConverter statementConverter;
  final Map<VariableDeclaration, String> _letVariableMap = {};
  final Map<Expression, String> _expressionTypeCache = {};
  int _letVarCounter = 0;

  /// 类型提升变量映射：原始变量名 -> promoted变量名
  final Map<String, String> _promotedVarMapping = {};

  /// 装箱变量映射：原始变量名 -> 装箱后变量名
  final Map<String, String> _boxedVarMapping = {};

  /// 装箱变量集合（用于快速判断）- 使用变量声明节点作为key
  final Set<VariableDeclaration> _boxedVarDeclarations = {};

  /// 标识当前是否在全局作用域（用于顶层变量）
  /// 在全局作用域中，Lambda 不能使用 [=] 捕获
  bool isGlobalScope = false;

  ExpressionConverter(this.transformer, this.statementConverter);

  /// 收集闭包捕获的变量（扩展版本，返回详细信息）
  /// 分析函数体中使用的外部变量，包括：
  /// 1. 局部变量（在闭包外部定义）
  /// 2. 函数参数（在闭包外部定义）
  /// 3. 成员变量（this引用）
  List<CapturedVarInfo> _collectCapturedVariablesDetailed(
      FunctionExpression expr) {
    final functionParams = expr.function.positionalParameters.toSet()
      ..addAll(expr.function.namedParameters);

    // 第一步：收集闭包内部定义的局部变量
    final localVars = <VariableDeclaration>{};
    void collectLocalVars(TreeNode node) {
      if (node is VariableDeclaration) {
        localVars.add(node);
      } else if (node is Block) {
        for (var stmt in node.statements) {
          collectLocalVars(stmt);
        }
      } else if (node is IfStatement) {
        collectLocalVars(node.then);
        if (node.otherwise != null) collectLocalVars(node.otherwise!);
      } else if (node is WhileStatement) {
        collectLocalVars(node.body);
      } else if (node is ForStatement) {
        for (var v in node.variables) {
          localVars.add(v);
        }
        collectLocalVars(node.body);
      } else if (node is ReturnStatement && node.expression != null) {
        collectLocalVars(node.expression!);
      } else if (node is ExpressionStatement) {
        collectLocalVars(node.expression);
      }
    }

    if (expr.function.body != null) {
      collectLocalVars(expr.function.body!);
    }

    // 第二步：收集被引用的外部变量
    final capturedVars = <String>{};
    void collectCapturedVars(TreeNode node) {
      if (node is VariableGet) {
        // 检查是否是外部变量（不是函数参数，也不是内部局部变量）
        if (!functionParams.contains(node.variable) &&
            !localVars.contains(node.variable)) {
          final varName = _sanitizeIdentifier(node.variable.name ?? 'unnamed');
          capturedVars.add(varName);
        }
      } else if (node is ThisExpression) {
        // 成员函数，捕获this
        capturedVars.add('this');
      } else if (node is Block) {
        for (var stmt in node.statements) {
          collectCapturedVars(stmt);
        }
      } else if (node is ReturnStatement && node.expression != null) {
        collectCapturedVars(node.expression!);
      } else if (node is ExpressionStatement) {
        collectCapturedVars(node.expression);
      } else if (node is IfStatement) {
        collectCapturedVars(node.condition);
        collectCapturedVars(node.then);
        if (node.otherwise != null) collectCapturedVars(node.otherwise!);
      } else if (node is WhileStatement) {
        collectCapturedVars(node.condition);
        collectCapturedVars(node.body);
      } else if (node is ForStatement) {
        if (node.condition != null) collectCapturedVars(node.condition!);
        collectCapturedVars(node.body);
      } else if (node is InstanceInvocation) {
        collectCapturedVars(node.receiver);
        for (var arg in node.arguments.positional) {
          collectCapturedVars(arg);
        }
      } else if (node is StaticInvocation) {
        for (var arg in node.arguments.positional) {
          collectCapturedVars(arg);
        }
      } else if (node is VariableDeclaration && node.initializer != null) {
        collectCapturedVars(node.initializer!);
      }
    }

    if (expr.function.body != null) {
      collectCapturedVars(expr.function.body!);
    }

    // 转换为详细信息列表
    final result = <CapturedVarInfo>[];

    // 收集外部参数信息（用于判断是否是参数）
    final outerParams = <String>{};
    // 这里需要访问外层函数的参数，暂时通过transformer的上下文获取
    // 由于闭包在函数内部，我们需要记录外层参数

    for (final varName in capturedVars) {
      if (varName == 'this') {
        result.add(CapturedVarInfo(name: 'this'));
        continue;
      }

      // 查找变量声明和类型信息
      VariableDeclaration? varDecl;
      bool isParam = false;
      DartType? varType;

      // 在闭包内部不应该找到该变量的声明（因为是捕获的外部变量）
      // 我们需要通过其他方式获取类型信息
      // 暂时使用启发式方法：检查变量使用的上下文

      // 收集变量的使用信息
      void collectVarUsage(TreeNode node) {
        if (node is VariableGet &&
            _sanitizeIdentifier(node.variable.name ?? '') == varName) {
          varDecl = node.variable;
          varType = node.variable.type;
        } else if (node is Block) {
          for (var stmt in node.statements) {
            collectVarUsage(stmt);
          }
        } else if (node is ReturnStatement && node.expression != null) {
          collectVarUsage(node.expression!);
        } else if (node is ExpressionStatement) {
          collectVarUsage(node.expression);
        } else if (node is InstanceInvocation) {
          collectVarUsage(node.receiver);
          for (var arg in node.arguments.positional) {
            collectVarUsage(arg);
          }
        }
      }

      if (expr.function.body != null) {
        collectVarUsage(expr.function.body!);
      }

      // 检查是否是值类型
      bool isValueType = false;
      if (varType != null) {
        isValueType = _isValueType(varType);
      }

      result.add(CapturedVarInfo(
        name: varName,
        declaration: varDecl,
        isParameter: isParam,
        isValueType: isValueType,
        type: varType,
      ));
    }

    return result;
  }

  /// 简化版本（兼容现有代码）
  List<String> _collectCapturedVariables(FunctionExpression expr) {
    final detailed = _collectCapturedVariablesDetailed(expr);
    return detailed.map((info) => info.name).toList();
  }

  /// 判断类型是否为值类型
  bool _isValueType(DartType? type) {
    if (type == null) return false;
    if (type is InterfaceType) {
      final className = type.classNode.name;
      return className == 'int' ||
          className == 'double' ||
          className == 'bool' ||
          className == 'String' ||
          className == 'Int' ||
          className == 'Double' ||
          className == 'Bool';
    }
    return false;
  }

  String convertExpression(Expression expr) {
    // 优先级1：字面量表达式（最常用，最快）
    if (expr is StringLiteral)
      return CppTypeConverter.convertLiteral(expr.value);
    if (expr is IntLiteral) return _convertIntLiteralWithTypeInference(expr);
    if (expr is DoubleLiteral)
      return CppTypeConverter.convertLiteral(expr.value);
    if (expr is BoolLiteral) return CppTypeConverter.convertLiteral(expr.value);
    if (expr is NullLiteral) return 'Null';

    // 优先级2：变量访问（非常常用）
    if (expr is VariableGet) return _convertVariableGet(expr);
    if (expr is ThisExpression) return 'this';

    // 优先级3：方法调用（最复杂，需要特殊处理）
    if (expr is InstanceInvocation) return _convertInstanceInvocation(expr);
    if (expr is StaticInvocation) return _convertStaticInvocation(expr);
    if (expr is ConstructorInvocation)
      return _convertConstructorInvocation(expr);

    // 优先级4：属性访问
    if (expr is InstanceGet) return _convertInstanceGet(expr);
    if (expr is InstanceSet) return _convertInstanceSet(expr);

    // 优先级5：集合字面量
    if (expr is ListLiteral) return _convertListLiteral(expr);
    if (expr is SetLiteral) return _convertSetLiteral(expr);
    if (expr is MapLiteral) return _convertMapLiteral(expr);

    // 优先级6：逻辑和条件表达式
    if (expr is LogicalExpression) return _convertLogicalExpression(expr);
    if (expr is ConditionalExpression)
      return _convertConditionalExpression(expr);
    if (expr is Not)
      return '(${convertExpression(expr.operand)}).operator_not()';

    // 优先级7：其他表达式类型
    return _convertOtherExpression(expr);
  }

  String _convertVariableGet(VariableGet expr) {
    // 检查是否是 Let 变量
    if (_letVariableMap.containsKey(expr.variable)) {
      return _letVariableMap[expr.variable]!;
    }

    // 清理变量名，移除无效的前缀字符
    String varName = expr.variable.name ?? 'unnamed_var';
    if (varName.startsWith(':')) {
      varName = varName.substring(1);
    }
    varName = _sanitizeIdentifier(varName);

    // 特殊处理 :sync-for-iterator 变量：使用带索引的变量名
    if (transformer._syncForIteratorMap.containsKey(expr.variable)) {
      final index = transformer._syncForIteratorMap[expr.variable]!;
      varName = '${varName}_$index';
    }

    // 检查是否有类型提升后的变量
    if (_promotedVarMapping.containsKey(varName)) {
      return _promotedVarMapping[varName]!;
    }

    // 特殊处理dynamic类型的变量
    if (expr.variable.type is DynamicType) {
      // 对于dynamic类型变量，我们会在使用时进行特殊处理
      // 但变量名本身不需要改变
      return varName;
    }

    return varName;
  }

  String _convertOtherExpression(Expression expr) {
    // 处理其他不太常用的表达式类型
    if (expr is SymbolLiteral) return _convertSymbolLiteral(expr);
    if (expr is TypeLiteral) return _convertTypeLiteral(expr);
    if (expr is VariableSet) return _convertVariableSet(expr);
    if (expr is DynamicGet) return _convertDynamicGet(expr);
    if (expr is DynamicSet) return _convertDynamicSet(expr);
    if (expr is InstanceTearOff) return _convertInstanceTearOff(expr);
    if (expr is StaticGet) return _convertStaticGet(expr);
    if (expr is StaticSet) return _convertStaticSet(expr);
    if (expr is StaticTearOff) return _convertStaticTearOff(expr);
    if (expr is SuperPropertyGet) return _convertSuperPropertyGet(expr);
    if (expr is SuperPropertySet) return _convertSuperPropertySet(expr);
    if (expr is DynamicInvocation) return _convertDynamicInvocation(expr);
    if (expr is FunctionInvocation) return _convertFunctionInvocation(expr);
    if (expr is LocalFunctionInvocation)
      return _convertLocalFunctionInvocation(expr);
    if (expr is SuperMethodInvocation)
      return _convertSuperMethodInvocation(expr);
    if (expr is EqualsCall) return _convertEqualsCall(expr);
    if (expr is EqualsNull) return _convertEqualsNull(expr);
    if (expr is IsExpression) return _convertIsExpression(expr);
    if (expr is AsExpression) return _convertAsExpression(expr);
    if (expr is NullCheck) return _convertNullCheck(expr);
    if (expr is StringConcatenation) return _convertStringConcatenation(expr);
    if (expr is Throw) return _convertThrow(expr);
    if (expr is Rethrow) return 'throw';
    if (expr is AwaitExpression)
      return 'DART_AWAIT(${convertExpression(expr.operand)})';
    if (expr is FunctionExpression) return _convertFunctionExpression(expr);
    if (expr is Let) return _convertLet(expr);
    if (expr is Instantiation) return _convertInstantiation(expr);
    if (expr is LoadLibrary) return 'Future<void>::completed()';
    if (expr is CheckLibraryIsLoaded) return '/* Library check */';
    if (expr is ConstantExpression) return _convertConstantExpression(expr);
    if (expr is InvalidExpression) return '/* Invalid: ${expr.message} */';
    if (expr is BlockExpression) return _convertBlockExpression(expr);

    // 修复#19: 展开操作符支持
    if (expr is ListConcatenation) return _convertListConcatenation(expr);
    if (expr is SetConcatenation) return _convertSetConcatenation(expr);
    if (expr is MapConcatenation) return _convertMapConcatenation(expr);

    return '/* TODO: ${expr.runtimeType} */';
  }

  /// 类型推断：推断表达式的实际类型
  String _inferExpressionType(Expression expr) {
    if (_expressionTypeCache.containsKey(expr)) {
      return _expressionTypeCache[expr]!;
    }

    String inferredType;

    if (expr is StringLiteral) {
      inferredType = 'String';
    } else if (expr is IntLiteral) {
      inferredType = 'int';
    } else if (expr is DoubleLiteral) {
      inferredType = 'double';
    } else if (expr is BoolLiteral) {
      inferredType = 'bool';
    } else if (expr is NullLiteral) {
      inferredType = 'Null';
    } else if (expr is VariableGet) {
      // 从变量类型推断
      final type = expr.promotedType ?? expr.variable.type;
      if (type is InterfaceType) {
        inferredType = type.classNode.name;
      } else {
        inferredType = 'dynamic';
      }
    } else if (expr is InstanceInvocation) {
      // 从方法调用推断返回类型
      final target = expr.interfaceTarget;
      if (target is Procedure) {
        final returnType = target.function.returnType;
        if (returnType is InterfaceType) {
          inferredType = returnType.classNode.name;
        } else {
          inferredType = 'dynamic';
        }
      } else {
        inferredType = _inferBinaryOperationType(expr);
      }
    } else if (expr is ConditionalExpression) {
      // 三元表达式：推断 then 和 else 分支的公共类型
      final thenType = _inferExpressionType(expr.then);
      final elseType = _inferExpressionType(expr.otherwise);
      inferredType = _findCommonType(thenType, elseType);
    } else {
      inferredType = 'dynamic';
    }

    _expressionTypeCache[expr] = inferredType;
    return inferredType;
  }

  /// 推断二元运算的结果类型
  String _inferBinaryOperationType(InstanceInvocation expr) {
    final methodName = expr.name.text;
    final leftType = _inferExpressionType(expr.receiver);

    if (expr.arguments.positional.isNotEmpty) {
      final rightType = _inferExpressionType(expr.arguments.positional.first);

      // 算术运算类型推断规则
      if (_isArithmeticOperator(methodName)) {
        return _inferArithmeticResultType(leftType, rightType);
      }

      // 比较运算返回 bool
      if (_isComparisonOperator(methodName)) {
        return 'bool';
      }

      // 字符串连接
      if (methodName == '+' &&
          (leftType == 'String' || rightType == 'String')) {
        return 'String';
      }
    }

    return leftType; // 默认返回左操作数类型
  }

  /// 分割泛型类型参数
  /// 例如：'String, Int' -> ['String', 'Int']
  ///      'Map<String, Int>, List<Double>' -> ['Map<String, Int>', 'List<Double>']
  List<String> _splitTypeParameters(String typeParams) {
    final result = <String>[];
    var current = '';
    var depth = 0;

    for (var i = 0; i < typeParams.length; i++) {
      final char = typeParams[i];

      if (char == '<') {
        depth++;
        current += char;
      } else if (char == '>') {
        depth--;
        current += char;
      } else if (char == ',' && depth == 0) {
        // 只在顶层的逗号处分割
        result.add(current.trim());
        current = '';
      } else {
        current += char;
      }
    }

    // 添加最后一个参数
    if (current.isNotEmpty) {
      result.add(current.trim());
    }

    return result;
  }

  /// 推断算术运算结果类型
  String _inferArithmeticResultType(String leftType, String rightType) {
    // double + any_number -> double
    if (leftType == 'double' || rightType == 'double') {
      return 'double';
    }

    // int + int -> int
    if (leftType == 'int' && rightType == 'int') {
      return 'int';
    }

    // 默认为 double（更安全的选择）
    return 'double';
  }

  /// 找到两个类型的公共类型
  String _findCommonType(String type1, String type2) {
    if (type1 == type2) return type1;

    // 数值类型的公共类型推断
    if (_isNumericType(type1) && _isNumericType(type2)) {
      if (type1 == 'double' || type2 == 'double') {
        return 'double';
      }
      return 'int';
    }

    return 'dynamic'; // 无法确定公共类型时使用 dynamic
  }

  /// 检查是否是算术运算符
  bool _isArithmeticOperator(String op) {
    return const {'+', '-', '*', '/', '%', '~/'}.contains(op);
  }

  /// 检查是否是比较运算符
  bool _isComparisonOperator(String op) {
    return const {'==', '!=', '<', '>', '<=', '>='}.contains(op);
  }

  /// 检查是否是数值类型
  bool _isNumericType(String type) {
    return const {'int', 'double', 'num'}.contains(type);
  }

  /// 将Dart基础类型名称转换为C++类型名称
  /// 修复: int.parse -> Int::parse, double.parse -> Double::parse等
  String _convertBasicTypeName(String dartTypeName) {
    const typeMapping = {
      'int': 'Int',
      'double': 'Double',
      'bool': 'Bool',
      'num': 'Any',
      'LinkedHashSet': 'Set', // LinkedHashSet 映射到 Set
      'LinkedHashMap': 'Map', // LinkedHashMap 映射到 Map
      // 'String' 保持不变
    };
    return typeMapping[dartTypeName] ?? dartTypeName;
  }

  /// 带类型推断的整数字面量转换
  String _convertIntLiteralWithTypeInference(IntLiteral expr) {
    // 检查上下文是否需要 double 类型
    if (_shouldConvertToDouble(expr)) {
      return 'dart_double(${expr.value}.0)';
    }
    return CppTypeConverter.convertLiteral(expr.value);
  }

  /// 判断整数字面量是否应该转换为 double
  bool _shouldConvertToDouble(IntLiteral expr) {
    // 查找父表达式来判断上下文
    return _isInDoubleContext(expr);
  }

  /// 检查表达式是否在 double 上下文中
  bool _isInDoubleContext(Expression expr) {
    // 这里可以通过遍历 AST 父节点来判断上下文
    // 简化实现：检查是否与 double 类型进行运算

    // 注意：这是一个简化的实现，实际应该通过 AST 遍历来获取父节点信息
    // 在实际使用中，可能需要在转换过程中维护上下文信息

    return false; // 默认不转换，避免过度转换
  }

  /// 带类型推断的算术运算转换
  String _convertArithmeticOperation(InstanceInvocation expr, String receiver,
      String right, String methodName) {
    final leftType = _inferExpressionType(expr.receiver);
    final rightType = _inferExpressionType(expr.arguments.positional.first);

    // 只有当涉及字面量时才进行类型转换
    // 变量之间不进行自动类型转换
    if (_hasMixedTypesWithLiterals(
        expr.receiver, expr.arguments.positional.first, leftType, rightType)) {
      final convertedReceiver =
          _convertLiteralIfNeeded(expr.receiver, receiver, leftType, rightType);
      final convertedRight = _convertLiteralIfNeeded(
          expr.arguments.positional.first, right, rightType, leftType);

      final operatorMethodName =
          transformer._convertOperatorMethodName(methodName);
      return '$convertedReceiver->$operatorMethodName($convertedRight)';
    }

    // 默认处理 - 不进行类型转换
    final operatorMethodName =
        transformer._convertOperatorMethodName(methodName);
    return '$receiver->$operatorMethodName($right)';
  }

  /// 检查是否有混合类型且涉及字面量
  bool _hasMixedTypesWithLiterals(
      Expression left, Expression right, String leftType, String rightType) {
    // 只有在类型不同且至少有一个是字面量时才返回 true
    if (leftType == rightType) return false;

    final hasLiteral = (left is IntLiteral || left is DoubleLiteral) ||
        (right is IntLiteral || right is DoubleLiteral);

    final hasMixedNumericTypes =
        _isNumericType(leftType) && _isNumericType(rightType);

    return hasLiteral && hasMixedNumericTypes;
  }

  /// 仅在需要时转换字面量类型
  String _convertLiteralIfNeeded(Expression expr, String convertedExpr,
      String currentType, String otherType) {
    // 只转换字面量，不转换变量
    if (expr is IntLiteral && otherType == 'double') {
      // 整数字面量 + double变量 -> 将整数字面量转换为 double
      return 'dart_double(${expr.value}.0)';
    }

    // 其他情况保持不变
    return convertedExpr;
  }

  String _convertStaticInvocation(StaticInvocation expr) {
    final target = expr.target;
    var methodName = target.name.text;

    // 处理 identical 函数：检查两个对象是否是同一个实例（引用相等）
    if (methodName == 'identical' && target.enclosingClass == null) {
      if (expr.arguments.positional.length >= 2) {
        final arg1 = convertExpression(expr.arguments.positional[0]);
        final arg2 = convertExpression(expr.arguments.positional[1]);
        // 在 C++ 中，identical 转换为指针比较
        // 对于 ObjectPtr 类型，比较其内部指针
        return 'dart_identical($arg1, $arg2)';
      }
    }

    // 检查是否是扩展方法的静态调用
    // 扩展方法在 Dart Kernel AST 中被编译为顶级静态方法，方法名格式为 ExtensionName|methodName
    final enclosingClassName = target.enclosingClass?.name ?? '';

    // 检查方法名是否包含 | 分隔符（扩展方法的标志）
    if (methodName.contains('|')) {
      final parts = methodName.split('|');
      print('DEBUG: Found extension method: $methodName, parts=$parts');
      if (parts.length == 2) {
        var extensionClassName = parts[0];
        final actualMethodName = parts[1];
        print(
            'DEBUG: extensionClassName=$extensionClassName, actualMethodName=$actualMethodName');

        // 特殊处理：将 MathExtension 转换为 MathExtensions
        if (extensionClassName == 'MathExtension') {
          extensionClassName = 'MathExtensions';
          print('DEBUG: Converted MathExtension to MathExtensions');
        }

        print('DEBUG: Final extensionClassName=$extensionClassName');

        // 转换接收者表达式（第一个参数）
        final receiver = convertExpression(expr.arguments.positional.first);

        // 转换其余参数
        final remainingArgs = expr.arguments.positional
            .skip(1)
            .map((arg) => convertExpression(arg))
            .join(', ');

        // 生成扩展方法调用：ExtensionClass::methodName(receiver, ...args)
        if (remainingArgs.isEmpty) {
          return '$extensionClassName::$actualMethodName($receiver)';
        } else {
          return '$extensionClassName::$actualMethodName($receiver, $remainingArgs)';
        }
      }
    }

    // 检查是否是扩展方法：扩展方法的第一个参数是 this（接收者）
    if (target.function.positionalParameters.isNotEmpty) {
      final firstParam = target.function.positionalParameters.first;
      // 这个检查已经被上面的 | 分隔符检查替代了，所以这里不需要再处理
    }

    // 修复问题1A: 处理_GrowableList等内部类型 - 必须在工厂构造函数检测之前
    if (enclosingClassName == '_GrowableList' ||
        enclosingClassName == '_List' ||
        enclosingClassName == '_ImmutableList' ||
        (enclosingClassName.startsWith('_') &&
            (methodName.startsWith('_literal') || methodName == 'create'))) {
      // 推断List的元素类型
      String elementType = 'Any'; // 默认类型

      // 0. 首先尝试从 Arguments.types 获取类型
      if (expr.arguments.types.isNotEmpty) {
        final typeArg = expr.arguments.types.first;
        if (typeArg is! TypeParameterType) {
          elementType = CppTypeConverter.convertType(typeArg);
        }
      }

      // 1. 如果还没有,尝试从返回类型推断
      if (elementType == 'Any') {
        final returnType = target.function.returnType;
        if (returnType is InterfaceType &&
            returnType.typeArguments.isNotEmpty) {
          final typeArg = returnType.typeArguments.first;
          // 检查类型参数是否仍然是泛型
          if (typeArg is! TypeParameterType) {
            elementType = CppTypeConverter.convertType(typeArg);
          }
        }
      }
      // 2. 如果还是泛型,尝试从第一个参数推断(跳过容量参数)
      if (elementType == 'Any' && expr.arguments.positional.isNotEmpty) {
        final firstArg = expr.arguments.positional.first;
        // 检查第一个参数是否是容量参数(整数字面量 0)
        final isCapacityArg = firstArg is IntLiteral && firstArg.value == 0;

        if (!isCapacityArg) {
          elementType = _inferExpressionType(firstArg);
          // 统一转换到C++类型
          if (elementType == 'int')
            elementType = 'Int';
          else if (elementType == 'double')
            elementType = 'Double';
          else if (elementType == 'bool')
            elementType = 'Bool';
          else if (elementType == 'dynamic') elementType = 'Any';
        }
      }

      // 混合类型检测：当元素类型是 Object 或 ObjectPtr<Object> 时，检查是否包含值类型
      // 如果包含值类型，应使用 Any 而不是 ObjectPtr<Object>
      if (elementType == 'ObjectPtr<Object>' || elementType == 'Object') {
        final nonCapacityArgs = expr.arguments.positional.where((arg) =>
            !(arg is IntLiteral &&
                arg.value == 0 &&
                expr.arguments.positional.first == arg));
        if (nonCapacityArgs.isNotEmpty) {
          bool hasValueType = false;
          for (final e in nonCapacityArgs) {
            final inferredType = _inferExpressionType(e);
            if (_isCppValueType(inferredType)) {
              hasValueType = true;
              break;
            }
          }
          // 如果包含值类型，应该使用 Any
          if (hasValueType) {
            elementType = 'Any';
          }
        }
      }

      // 过滤掉容量参数(第一个整数字面量 0)
      final args = expr.arguments.positional
          .where((arg) => !(arg is IntLiteral &&
              arg.value == 0 &&
              expr.arguments.positional.first == arg))
          .map((arg) => convertExpression(arg))
          .join(', ');
      // 转换为带类型参数的dart_literal调用
      if (args.isEmpty) {
        return 'dart_literal<$elementType>()';
      }
      return 'dart_literal<$elementType>($args)';
    }

    // 也处理直接调用 _literalN 的情况
    if (methodName.startsWith('_literal')) {
      // 推断元素类型
      String elementType = 'Any';

      // 0. 首先尝试从 Arguments.types 获取类型
      if (expr.arguments.types.isNotEmpty) {
        final typeArg = expr.arguments.types.first;
        if (typeArg is! TypeParameterType) {
          elementType = CppTypeConverter.convertType(typeArg);
        }
      }

      // 1. 如果还没有,尝试从返回类型推断
      if (elementType == 'Any') {
        final returnType = target.function.returnType;
        if (returnType is InterfaceType &&
            returnType.typeArguments.isNotEmpty) {
          final typeArg = returnType.typeArguments.first;
          if (typeArg is! TypeParameterType) {
            elementType = CppTypeConverter.convertType(typeArg);
          }
        }
      }
      // 2. 如果还是泛型，尝试从第一个参数推断(跳过容量参数)
      if (elementType == 'Any' && expr.arguments.positional.isNotEmpty) {
        final firstArg = expr.arguments.positional.first;
        final isCapacityArg = firstArg is IntLiteral && firstArg.value == 0;

        if (!isCapacityArg) {
          elementType = _inferExpressionType(firstArg);
          if (elementType == 'int')
            elementType = 'Int';
          else if (elementType == 'double')
            elementType = 'Double';
          else if (elementType == 'bool')
            elementType = 'Bool';
          else if (elementType == 'dynamic') elementType = 'Any';
        }
      }

      // 混合类型检测：当元素类型是 Object 或 ObjectPtr<Object> 时，检查是否包含值类型
      // 如果包含值类型，应使用 Any 而不是 ObjectPtr<Object>
      if (elementType == 'ObjectPtr<Object>' || elementType == 'Object') {
        final nonCapacityArgs = expr.arguments.positional.where((arg) =>
            !(arg is IntLiteral &&
                arg.value == 0 &&
                expr.arguments.positional.first == arg));
        if (nonCapacityArgs.isNotEmpty) {
          bool hasValueType = false;
          for (final e in nonCapacityArgs) {
            final inferredType = _inferExpressionType(e);
            if (_isCppValueType(inferredType)) {
              hasValueType = true;
              break;
            }
          }
          // 如果包含值类型，应该使用 Any
          if (hasValueType) {
            elementType = 'Any';
          }
        }
      }

      // 过滤掉容量参数
      final args = expr.arguments.positional
          .where((arg) => !(arg is IntLiteral &&
              arg.value == 0 &&
              expr.arguments.positional.first == arg))
          .map((arg) => convertExpression(arg))
          .join(', ');
      if (args.isEmpty) {
        return 'dart_literal<$elementType>()';
      }
      return 'dart_literal<$elementType>($args)';
    }

    // 修复问题2: 处理Object.hash调用，用Null填充而不是SentinelValue
    if (methodName == 'hash' && target.enclosingClass?.name == 'Object') {
      final args = expr.arguments.positional.map((arg) {
        // 检测SentinelValue调用，替换为Nullable()
        if (arg is StaticInvocation) {
          final argTarget = arg.target;
          if (argTarget.enclosingClass?.name == 'SentinelValue' ||
              argTarget.enclosingClass?.name == '_SentinelValue') {
            return 'Null'; // 用Null填充
          }
        }
        return convertExpression(arg);
      }).join(', ');
      return 'Object::hash($args)';
    }

    // 修复问题: 处理Future/Stream/Completer静态方法，需要带泛型参数 - 必须在工厂构造函数之前
    if (enclosingClassName == 'Future' ||
        enclosingClassName == 'Stream' ||
        enclosingClassName == 'Completer') {
      // 从Future/Stream/Completer的返回类型推导泛型参数
      String typeParam = 'Any'; // 默认类型

      // 对于 Future.delayed，从 computation 函数的返回类型推导泛型参数
      if (methodName == 'delayed' && expr.arguments.positional.length >= 2) {
        // delayed(Duration duration, FutureOr<T> computation())
        // 第二个参数是 computation 函数，从其返回类型推导
        final computationArg = expr.arguments.positional[1];
        if (computationArg is StaticInvocation &&
            computationArg.target.name.text == '') {
          // Lambda 表达式，从其返回表达式推导类型
          if (computationArg.target.function.body is ReturnStatement) {
            final returnStmt =
                computationArg.target.function.body as ReturnStatement;
            if (returnStmt.expression != null) {
              typeParam = _inferExpressionType(returnStmt.expression!);
            }
          }
        } else if (computationArg is FunctionExpression) {
          // FunctionExpression，从返回语句推导
          if (computationArg.function.body is ReturnStatement) {
            final returnStmt = computationArg.function.body as ReturnStatement;
            if (returnStmt.expression != null) {
              typeParam = _inferExpressionType(returnStmt.expression!);
            }
          }
        }
      }
      // 对于其他方法，从第一个参数推导类型
      else if (expr.arguments.positional.isNotEmpty) {
        final firstArg = expr.arguments.positional.first;
        typeParam = _inferExpressionType(firstArg);
        // 统一转换到C++类型
        if (typeParam == 'int')
          typeParam = 'Int';
        else if (typeParam == 'double')
          typeParam = 'Double';
        else if (typeParam == 'bool')
          typeParam = 'Bool';
        else if (typeParam == 'Null')
          typeParam = 'Nullable';
        else if (typeParam == 'dynamic') typeParam = 'Any';
      }

      // 如果还是泛型参数，尝试从返回类型提取具体类型
      if (typeParam == 'Any' || typeParam == 'T' || typeParam.isEmpty) {
        final returnType = target.function.returnType;
        if (returnType is InterfaceType &&
            returnType.typeArguments.isNotEmpty) {
          final innerType = returnType.typeArguments.first;
          if (innerType is! TypeParameterType) {
            typeParam = CppTypeConverter.convertType(innerType);
          }
        }
      }

      // 统一转换到C++类型
      if (typeParam == 'int')
        typeParam = 'Int';
      else if (typeParam == 'double')
        typeParam = 'Double';
      else if (typeParam == 'bool')
        typeParam = 'Bool';
      else if (typeParam == 'Null')
        typeParam = 'Nullable';
      else if (typeParam == 'dynamic') typeParam = 'Any';

      final args = _convertArguments(expr.arguments, target.function);
      return '$enclosingClassName<$typeParam>::$methodName($args)';
    }

    // 修复#18: 处理工厂构造函数调用
    if (target.isFactory) {
      final originalClassName = target.enclosingClass!.name;

      // 特殊处理 RegExp 工厂构造函数，转换为 String
      // RegExp 已合并到 String 类型，构造时直接使用 dart_string
      if (originalClassName == 'RegExp') {
        if (expr.arguments.positional.isNotEmpty) {
          final pattern = convertExpression(expr.arguments.positional.first);
          // 直接返回参数表达式，它已经是 String 类型
          return pattern;
        }
        return 'dart_string("")';
      }

      // 特殊处理 List 工厂构造函数：List.from, List.of, List.filled, List.generate
      // 需要忽略 growable 参数，并正确添加泛型类型参数
      if (originalClassName == 'List' || originalClassName == '_GrowableList') {
        // 推断元素类型
        String elementType = 'Any';
        if (expr.arguments.types.isNotEmpty) {
          final typeArg = expr.arguments.types.first;
          if (typeArg is! TypeParameterType) {
            elementType = CppTypeConverter.convertType(typeArg);
          }
        }
        // 尝试从返回类型推断
        if (elementType == 'Any') {
          final returnType = target.function.returnType;
          if (returnType is InterfaceType &&
              returnType.typeArguments.isNotEmpty) {
            final typeArg = returnType.typeArguments.first;
            if (typeArg is! TypeParameterType) {
              elementType = CppTypeConverter.convertType(typeArg);
            }
          }
        }
        // 尝试从第一个参数推断
        if (elementType == 'Any' && expr.arguments.positional.isNotEmpty) {
          final firstArg = expr.arguments.positional.first;
          final inferredType = _inferExpressionType(firstArg);
          if (inferredType == 'int')
            elementType = 'Int';
          else if (inferredType == 'double')
            elementType = 'Double';
          else if (inferredType == 'bool')
            elementType = 'Bool';
          else if (inferredType != 'dynamic') elementType = inferredType;
        }

        // List.from(iterable, {growable = true}) -> List<T>::from(iterable)
        // List.of(iterable, {growable = true}) -> List<T>::of(iterable)
        // 忽略 growable 命名参数，C++ 端不需要
        if (methodName == 'from' || methodName == 'of') {
          if (expr.arguments.positional.isNotEmpty) {
            final source = convertExpression(expr.arguments.positional.first);
            return 'List<$elementType>::$methodName($source)';
          }
          return 'List<$elementType>::create()';
        }

        // List.filled(length, fill, {growable = false}) -> List<T>::filled(length, fill)
        if (methodName == 'filled') {
          if (expr.arguments.positional.length >= 2) {
            final length = convertExpression(expr.arguments.positional[0]);
            final fill = convertExpression(expr.arguments.positional[1]);
            return 'List<$elementType>::filled($length, $fill)';
          }
        }

        // List.generate(length, generator, {growable = true}) -> List<T>::generate(length, generator)
        if (methodName == 'generate') {
          if (expr.arguments.positional.length >= 2) {
            final length = convertExpression(expr.arguments.positional[0]);
            final generator = convertExpression(expr.arguments.positional[1]);
            return 'List<$elementType>::generate($length, $generator)';
          }
        }
      }

      // 特殊处理 Set 工厂构造函数：Set.of, Set.from
      // LinkedHashSet 已映射为 Set，需要补全泛型参数
      if (originalClassName == 'Set' ||
          originalClassName == 'LinkedHashSet' ||
          originalClassName == '_Set' ||
          originalClassName == '_CompactLinkedHashSet') {
        // 推断元素类型
        String elementType = 'Any';

        // 1. 首先尝试从 Arguments.types 获取类型
        if (expr.arguments.types.isNotEmpty) {
          final typeArg = expr.arguments.types.first;
          if (typeArg is! TypeParameterType) {
            elementType = CppTypeConverter.convertType(typeArg);
          }
        }

        // 2. 尝试从返回类型推断
        if (elementType == 'Any') {
          final returnType = target.function.returnType;
          if (returnType is InterfaceType &&
              returnType.typeArguments.isNotEmpty) {
            final typeArg = returnType.typeArguments.first;
            if (typeArg is! TypeParameterType) {
              elementType = CppTypeConverter.convertType(typeArg);
            }
          }
        }

        // 3. 尝试从第一个参数的类型推断（参数应该是 Set<T> 或 Iterable<T>）
        if (elementType == 'Any' && expr.arguments.positional.isNotEmpty) {
          final firstArg = expr.arguments.positional.first;
          // 使用 _inferExpressionType 来推断参数类型
          final inferredType = _inferExpressionType(firstArg);

          // 如果推断出的类型是 ObjectPtr<Set<T>> 或 Set<T>，提取 T
          if (inferredType.startsWith('ObjectPtr<Set<') &&
              inferredType.endsWith('>>')) {
            elementType = inferredType.substring(
                'ObjectPtr<Set<'.length, inferredType.length - 2);
          } else if (inferredType.startsWith('Set<') &&
              inferredType.endsWith('>')) {
            elementType =
                inferredType.substring('Set<'.length, inferredType.length - 1);
          } else if (inferredType != 'dynamic' && inferredType != 'Any') {
            // 如果是其他类型，可能是 Iterable<T>
            if (inferredType.contains('<') && inferredType.contains('>')) {
              final startIdx = inferredType.indexOf('<');
              final endIdx = inferredType.lastIndexOf('>');
              if (startIdx >= 0 && endIdx > startIdx) {
                elementType = inferredType.substring(startIdx + 1, endIdx);
              }
            }
          }
        }

        // Set.of(elements) -> Set<T>::of(elements)
        // Set.from(elements) -> Set<T>::from(elements)
        if (methodName == 'of' || methodName == 'from') {
          if (expr.arguments.positional.isNotEmpty) {
            final source = convertExpression(expr.arguments.positional.first);
            return 'Set<$elementType>::$methodName($source)';
          }
          return 'Set<$elementType>::create()';
        }
      }

      // 特殊处理 Map 工厂构造函数：Map.of, Map.from
      // LinkedHashMap 已映射为 Map，需要补全泛型参数
      if (originalClassName == 'Map' ||
          originalClassName == 'LinkedHashMap' ||
          originalClassName == '_Map' ||
          originalClassName == '_CompactLinkedHashMap') {
        // 推断键值类型
        String keyType = 'Any';
        String valueType = 'Any';

        // 1. 首先尝试从 Arguments.types 获取类型
        if (expr.arguments.types.length >= 2) {
          final keyTypeArg = expr.arguments.types[0];
          final valueTypeArg = expr.arguments.types[1];
          if (keyTypeArg is! TypeParameterType) {
            keyType = CppTypeConverter.convertType(keyTypeArg);
          }
          if (valueTypeArg is! TypeParameterType) {
            valueType = CppTypeConverter.convertType(valueTypeArg);
          }
        }

        // 2. 尝试从返回类型推断
        if (keyType == 'Any' || valueType == 'Any') {
          final returnType = target.function.returnType;
          if (returnType is InterfaceType &&
              returnType.typeArguments.length >= 2) {
            if (keyType == 'Any') {
              final keyTypeArg = returnType.typeArguments[0];
              if (keyTypeArg is! TypeParameterType) {
                keyType = CppTypeConverter.convertType(keyTypeArg);
              }
            }
            if (valueType == 'Any') {
              final valueTypeArg = returnType.typeArguments[1];
              if (valueTypeArg is! TypeParameterType) {
                valueType = CppTypeConverter.convertType(valueTypeArg);
              }
            }
          }
        }

        // 3. 尝试从第一个参数的类型推断（参数应该是 Map<K, V>）
        if ((keyType == 'Any' || valueType == 'Any') &&
            expr.arguments.positional.isNotEmpty) {
          final firstArg = expr.arguments.positional.first;
          // 使用 _inferExpressionType 来推断参数类型
          final inferredType = _inferExpressionType(firstArg);

          // 如果推断出的类型是 Map<K, V>，提取 K 和 V
          if (inferredType.startsWith('Map<') && inferredType.endsWith('>')) {
            final typeParams =
                inferredType.substring('Map<'.length, inferredType.length - 1);
            final parts = _splitTypeParameters(typeParams);
            if (parts.length >= 2) {
              if (keyType == 'Any') keyType = parts[0];
              if (valueType == 'Any') valueType = parts[1];
            }
          }
        }

        // Map.of(other) -> Map<K, V>::of(other)
        // Map.from(other) -> Map<K, V>::from(other)
        if (methodName == 'of' || methodName == 'from') {
          if (expr.arguments.positional.isNotEmpty) {
            final source = convertExpression(expr.arguments.positional.first);
            return 'Map<$keyType, $valueType>::$methodName($source)';
          }
          return 'Map<$keyType, $valueType>::create()';
        }
      }

      // 修复: 将Dart基础类型名称转换为C++类型名称
      final cppClassName = _convertBasicTypeName(originalClassName);
      // 清理类名中的特殊字符（如混入类 _Bird&Object&Flyable）
      final className = _sanitizeIdentifier(cppClassName);

      // 特殊处理 parse 方法：过滤掉 Null 参数
      // Dart 的 int.parse 有 onError 参数，但 C++ 的 Int::parse 不支持
      if (methodName == 'parse' &&
          (originalClassName == 'int' || originalClassName == 'double')) {
        final validArgs = <String>[];
        // 只添加非 Null 的位置参数
        for (final arg in expr.arguments.positional) {
          final converted = convertExpression(arg);
          if (converted != 'Null' && converted != 'Nullable()') {
            validArgs.add(converted);
          }
        }
        // 处理命名参数 radix（只有 int.parse 有这个参数）
        for (final namedArg in expr.arguments.named) {
          if (namedArg.name == 'radix') {
            final converted = convertExpression(namedArg.value);
            if (converted != 'Null' && converted != 'Nullable()') {
              validArgs.add(converted);
            }
          }
        }
        return '$className::parse(${validArgs.join(', ')})';
      }

      final args = _convertArguments(expr.arguments, target.function);
      // 工厂构造函数转换为静态方法调用
      // 默认工厂构造函数使用 'create'，命名工厂使用原名称
      final factoryName =
          methodName.isEmpty ? 'create' : _sanitizeIdentifier(methodName);
      return '$className::$factoryName($args)';
    }

    // 处理特殊的静态方法调用
    if (methodName == 'print') {
      final arg = convertExpression(expr.arguments.positional.first);
      return 'dart_print($arg)';
    }

    // 处理数学函数
    if (target.enclosingClass?.name == 'dart.math') {
      final args = expr.arguments.positional
          .map((arg) => convertExpression(arg))
          .join(', ');
      return 'dart_math_$methodName($args)';
    }

    // 处理内部Set构造函数调用
    if (target.enclosingClass?.name == '_Set') {
      // 转换为标准的Set创建
      return 'Set<Any>::create()';
    }

    // 特殊处理 parse 静态方法：过滤掉 Null 参数
    // Dart 的 int.parse/double.parse 有 onError 参数，但 C++ 版本不支持
    final parseClassName = target.enclosingClass?.name ?? '';
    if (methodName == 'parse' &&
        (parseClassName == 'int' || parseClassName == 'double')) {
      final validArgs = <String>[];
      // 只添加非 Null 的位置参数
      for (final arg in expr.arguments.positional) {
        final converted = convertExpression(arg);
        if (converted != 'Null' && converted != 'Nullable()') {
          validArgs.add(converted);
        }
      }
      // 处理命名参数 radix（只有 int.parse 有这个参数）
      for (final namedArg in expr.arguments.named) {
        if (namedArg.name == 'radix') {
          final converted = convertExpression(namedArg.value);
          if (converted != 'Null' && converted != 'Nullable()') {
            validArgs.add(converted);
          }
        }
      }
      final cppTypeName = _convertBasicTypeName(parseClassName);
      return '$cppTypeName::parse(${validArgs.join(', ')})';
    }

    // 一般静态方法调用 - 使用目标函数信息进行参数补全
    final args = _convertArguments(expr.arguments, target.function);

    // 如果是顶级函数（没有enclosingClass），直接调用，不需要类名前缀
    if (target.enclosingClass == null) {
      return '$methodName($args)';
    }

    final originalClassName = target.enclosingClass!.name;
    // 修复: 将Dart基础类型名称转换为C++类型名称
    final cppClassName = _convertBasicTypeName(originalClassName);
    // 清理类名中的特殊字符（如混入类 _Bird&Object&Flyable）
    final sanitizedClassName = _sanitizeIdentifier(cppClassName);

    // 特殊处理 parse/tryParse 方法：过滤掉生成的 Null 参数
    // 因为 _convertArguments 会为 int.parse 的 onError 参数填充 Null
    if ((methodName == 'parse' || methodName == 'tryParse') &&
        (sanitizedClassName == 'Int' || sanitizedClassName == 'Double')) {
      // 过滤掉所有 Null 参数
      final filteredArgs = args
          .split(', ')
          .where((arg) => arg != 'Null' && arg != 'Nullable()')
          .join(', ');
      return '${sanitizedClassName}::$methodName($filteredArgs)';
    }

    return '${sanitizedClassName}::$methodName($args)';
  }

  String _convertInstanceInvocation(InstanceInvocation expr) {
    var receiver = convertExpression(expr.receiver);

    // 特殊处理：如果receiver是装箱变量，需要先解引用
    // 例如：x->operator_add(...) 应该变成 (*x)->operator_add(...)
    if (expr.receiver is VariableGet) {
      final varGet = expr.receiver as VariableGet;
      if (transformer._boxingVars.containsKey(varGet.variable)) {
        receiver = '(*$receiver)';
      }
    }

    final originalMethodName = expr.name.text;
    final methodName = _fixMethodName(expr.receiver, originalMethodName);

    // 检查是否是扩展方法调用 - 通用转换为静态方法
    final receiverType = transformer._getReceiverType(expr.receiver);
    if (receiverType != null &&
        transformer._isExtensionMethod(receiverType, methodName)) {
      return transformer._convertExtensionMethodCall(receiverType, methodName,
          receiver, expr.arguments, expr.interfaceTarget);
    }

    // 特殊处理：Dart 迭代器 API 映射到 C++ Iterator API
    if (methodName == 'moveNext') {
      // Dart 的 moveNext() 映射到 C++ 的 hasNext()
      return '$receiver->hasNext()';
    }

    // 处理一元负号运算符
    if (methodName == 'unary-') {
      // 对于字面量，直接在字面量阶段处理
      if (expr.receiver is IntLiteral) {
        final value = (expr.receiver as IntLiteral).value;
        return 'dart_int(${-value})';
      } else if (expr.receiver is DoubleLiteral) {
        final value = (expr.receiver as DoubleLiteral).value;
        return 'dart_double(${-value})';
      }
      // 对于其他表达式，使用operator_negate方法
      return '$receiver->operator_negate()';
    }

    // 处理一元取反运算符
    if (methodName == '~') {
      return '$receiver->operator_bitwise_not()';
    }

    // 处理整数除法运算符 ~/
    if (methodName == '~/') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->truncatingDivision($right)';
    }

    // 处理位运算符
    if (methodName == '&') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_bitwise_and($right)';
    }

    if (methodName == '|') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_bitwise_or($right)';
    }

    if (methodName == '^') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_bitwise_xor($right)';
    }

    if (methodName == '<<') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_shift_left($right)';
    }

    if (methodName == '>>') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_shift_right($right)';
    }

    // 修复#10: String 乘法运算 - 转换为 repeat 方法调用
    if (methodName == '*') {
      final receiverTypeName = transformer._getReceiverType(expr.receiver);
      if (receiverTypeName == 'String') {
        final times = convertExpression(expr.arguments.positional.first);
        return '$receiver->repeat($times)';
      }
    }

    // 处理数组访问操作符
    if (methodName == '[]') {
      final index = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_index($index)';
    }

    if (methodName == '[]=') {
      final index = convertExpression(expr.arguments.positional.first);
      final value = convertExpression(expr.arguments.positional[1]);
      return '$receiver->operator_index_set($index, $value)';
    }

    // 运算符重载处理 - 带类型推断的转换
    if (CppConstants.operatorMapping.containsKey(methodName)) {
      final operator = CppConstants.operatorMapping[methodName]!;

      if (expr.arguments.positional.isNotEmpty) {
        final rightExpr = expr.arguments.positional.first;
        var right = convertExpression(rightExpr);

        // 如果参数是装箱变量，需要解引用
        if (rightExpr is VariableGet &&
            transformer._boxingVars.containsKey(rightExpr.variable)) {
          right = '(*$right)';
        }

        // 类型推断：检查运算结果类型并进行必要的类型转换
        if (_isArithmeticOperator(methodName)) {
          return _convertArithmeticOperation(expr, receiver, right, methodName);
        }

        // 统一使用 operator_ 方法调用（包括基础类型和自定义类）
        if (transformer._isOperatorMethod(methodName)) {
          final operatorMethodName =
              transformer._convertOperatorMethodName(methodName);
          return '$receiver->$operatorMethodName($right)';
        }

        // 对于非运算符的特殊操作（如 dart_ 开头的辅助函数）
        if (operator.startsWith('dart_')) {
          return '$operator($receiver, $right)';
        } else {
          // 默认也转换为函数调用
          final operatorMethodName =
              transformer._convertOperatorMethodName(methodName);
          return '$receiver->$operatorMethodName($right)';
        }
      } else {
        // 一元运算符
        if (transformer._isOperatorMethod(methodName)) {
          final operatorMethodName =
              transformer._convertOperatorMethodName(methodName);
          return '$receiver->$operatorMethodName()';
        }
        return '($operator$receiver)';
      }
    }

    // 特殊处理dynamic类型变量的方法调用
    // 但如果变量已经被类型提升（promoted），则不应该使用 DART_ANY_CALL
    if (expr.receiver is VariableGet) {
      final varGet = expr.receiver as VariableGet;
      final varName = _sanitizeIdentifier(varGet.variable.name ?? 'unnamed');
      // 检查变量是否已被类型提升
      final isPromoted = _promotedVarMapping.containsKey(varName);

      if (!isPromoted && varGet.variable.type is DynamicType) {
        // 对于dynamic类型变量（未被类型提升），使用特殊的宏来调用方法
        final args = expr.arguments.positional
            .map((arg) => convertExpression(arg))
            .join(', ');

        // 如果有参数，使用带参数的宏
        if (args.isNotEmpty) {
          return 'DART_ANY_CALL($receiver, $methodName)($args)';
        } else {
          return 'DART_ANY_CALL($receiver, $methodName)';
        }
      }
    }

    // Future 链式调用特殊处理
    if (transformer._isFutureType(expr.receiver)) {
      return transformer._convertFutureChainCall(
          expr.receiver, methodName, expr.arguments);
    }

    // 集合类型也使用统一的方法调用处理

    // 转换参数，并自动处理装箱变量的解引用
    final args = expr.arguments.positional.map((arg) {
      var argExpr = convertExpression(arg);
      // 如果参数是装箱变量，需要解引用
      if (arg is VariableGet &&
          transformer._boxingVars.containsKey(arg.variable)) {
        argExpr = '(*$argExpr)';
      }
      return argExpr;
    }).join(', ');

    // 检查接收者是否是 Any/dynamic 类型（值类型），使用 . 而非 ->
    // Any 是值类型，不是指针，不能用 -> 操作符
    // 注意：如果 receiver 是 type-promoted 变量（已经 dart_cast 为具体类型），
    // 则不应该用 .，因为 promoted 变量是具体类型（String/Int 等），应该用 ->
    bool receiverIsAnyType = false;
    if (expr.receiver is VariableGet) {
      final varGet = expr.receiver as VariableGet;
      final varName = _sanitizeIdentifier(varGet.variable.name ?? 'unnamed');
      // 如果变量已经被 type-promoted，不能当作 Any 类型处理
      final isPromoted = _promotedVarMapping.containsKey(varName);
      if (!isPromoted) {
        final varType = varGet.variable.type;
        if (varType is DynamicType) {
          receiverIsAnyType = true;
        } else if (varType is InterfaceType) {
          // Object 类型在 C++ 中被转换为 Any（值类型）
          final className = varType.classNode.name;
          if (className == 'Object' ||
              className == 'dynamic' ||
              className == 'Never') {
            receiverIsAnyType = true;
          }
        }
      }
    }

    // 对于 toString() 这类 Any 类型上的方法调用，使用 . 而非 ->
    // Any 是 C++ 值类型，不是指针
    if (receiverIsAnyType) {
      return '$receiver.$methodName($args)';
    }

    // 额外检查：如果 receiver 表达式本身是 Any 类型（通过 CppTypeConverter 判断）
    // 例如：变量类型是 Object，在 C++ 中映射为 Any（值类型）
    if (expr.receiver is VariableGet) {
      final varGet = expr.receiver as VariableGet;
      final varName = _sanitizeIdentifier(varGet.variable.name ?? 'unnamed');
      final isPromoted = _promotedVarMapping.containsKey(varName);
      if (!isPromoted) {
        final cppType = CppTypeConverter.convertType(varGet.variable.type);
        if (cppType == 'Any') {
          return '$receiver.$methodName($args)';
        }
      }
    }

    // 统一使用 -> 调用
    return '$receiver->$methodName($args)';
  }

  String _convertConditionalExpression(ConditionalExpression expr) {
    // 收集条件中的所有 is 表达式（支持 && 连接的情况）
    final isExpressions = _collectIsExpressionsFromCondition(expr.condition);

    // 修复#8: 处理 is 类型判断的智能类型转换
    // 如果条件包含 is 表达式，在 then 分支中自动进行类型转换
    if (isExpressions.isNotEmpty) {
      final condition = convertExpression(expr.condition);
      // 在 then 分支中，应用所有 is 表达式的类型上下文
      final thenExpr =
          _convertExpressionWithMultipleTypeContexts(expr.then, isExpressions);
      final elseExpr = convertExpression(expr.otherwise);
      return '$condition ? $thenExpr : $elseExpr';
    }

    // 处理负 is 表达式 (!is)
    if (expr.condition is Not &&
        (expr.condition as Not).operand is IsExpression) {
      final isExpr = (expr.condition as Not).operand as IsExpression;
      final condition = convertExpression(expr.condition);
      // else 分支中进行类型转换
      final thenExpr = convertExpression(expr.then);
      final elseExpr =
          _convertExpressionWithIsTypeContext(expr.otherwise, isExpr);
      return '$condition ? $thenExpr : $elseExpr';
    }

    final condition = convertExpression(expr.condition);
    final thenExpr = convertExpression(expr.then);
    final elseExpr = convertExpression(expr.otherwise);
    return '$condition ? $thenExpr : $elseExpr';
  }

  /// 从条件表达式中收集所有的 is 表达式
  /// 支持 && 连接的多个 is 检查
  List<IsExpression> _collectIsExpressionsFromCondition(Expression condition) {
    final result = <IsExpression>[];
    _collectIsExpressionsRecursive(condition, result, isAndContext: true);
    return result;
  }

  /// 递归收集 is 表达式
  void _collectIsExpressionsRecursive(
      Expression expr, List<IsExpression> result,
      {required bool isAndContext}) {
    if (expr is IsExpression) {
      result.add(expr);
    } else if (expr is LogicalExpression) {
      // 只在 && 运算符的情况下继续收集
      if (expr.operatorEnum == LogicalExpressionOperator.AND) {
        _collectIsExpressionsRecursive(expr.left, result, isAndContext: true);
        _collectIsExpressionsRecursive(expr.right, result, isAndContext: true);
      }
      // || 运算符不进行类型提升，因为只有一侧会执行
    } else if (expr is Not) {
      // 不处理取反的 is 表达式在 AND 上下文中
      // 它们应该在 else 分支中处理
    }
  }

  /// 在多个类型上下文中转换表达式
  /// 支持同时应用多个 is 表达式的类型推断
  String _convertExpressionWithMultipleTypeContexts(
      Expression expr, List<IsExpression> typeContexts) {
    if (typeContexts.isEmpty) {
      return convertExpression(expr);
    }

    // 构建变量到类型的映射
    final varTypeMap = <VariableDeclaration, DartType>{};
    for (final isExpr in typeContexts) {
      if (isExpr.operand is VariableGet) {
        final varGet = isExpr.operand as VariableGet;
        varTypeMap[varGet.variable] = isExpr.type;
      }
    }

    // 使用类型上下文转换表达式
    return _convertExpressionWithVarTypeMap(expr, varTypeMap);
  }

  /// 根据变量类型映射转换表达式
  String _convertExpressionWithVarTypeMap(
      Expression expr, Map<VariableDeclaration, DartType> varTypeMap) {
    // 检查是否是变量访问，且该变量在类型映射中
    if (expr is VariableGet && varTypeMap.containsKey(expr.variable)) {
      final targetType =
          CppTypeConverter.convertType(varTypeMap[expr.variable]!);
      final varName = convertExpression(expr);
      return 'dart_cast<$targetType>($varName)';
    }

    // 检查是否是对映射变量的成员访问
    if (expr is InstanceGet) {
      // 递归检查receiver链，找到根变量
      final rootVar = _getRootVariable(expr.receiver);
      if (rootVar != null && varTypeMap.containsKey(rootVar.variable)) {
        // 获取从根到当前属性的完整路径
        final path = _buildAccessPath(expr, varTypeMap);
        if (path != null) {
          return path;
        }
      }

      // 如果receiver直接是映射中的变量
      if (expr.receiver is VariableGet) {
        final varGet = expr.receiver as VariableGet;
        if (varTypeMap.containsKey(varGet.variable)) {
          final targetType =
              CppTypeConverter.convertType(varTypeMap[varGet.variable]!);
          final varName = convertExpression(expr.receiver);
          final propName = expr.name.text;
          return 'dart_cast<$targetType>($varName)->$propName';
        }
      }
    }

    // 检查是否是对映射变量的方法调用
    if (expr is InstanceInvocation) {
      // 递归检查receiver链，找到根变量
      final rootVar = _getRootVariable(expr.receiver);
      if (rootVar != null && varTypeMap.containsKey(rootVar.variable)) {
        // 获取带类型转换的receiver
        final convertedReceiver =
            _convertReceiverWithTypeMap(expr.receiver, varTypeMap);
        var methodName = expr.name.text;
        // 修复: 如果是操作符方法，需要转换为 operator_ 格式
        if (transformer._isOperatorMethod(methodName)) {
          methodName = transformer._convertOperatorMethodName(methodName);
        }
        final args = _convertArguments(expr.arguments);
        return '$convertedReceiver->$methodName($args)';
      }

      // 如果receiver直接是映射中的变量
      if (expr.receiver is VariableGet) {
        final varGet = expr.receiver as VariableGet;
        if (varTypeMap.containsKey(varGet.variable)) {
          final targetType =
              CppTypeConverter.convertType(varTypeMap[varGet.variable]!);
          final varName = convertExpression(expr.receiver);
          var methodName = expr.name.text;
          // 修复: 如果是操作符方法，需要转换为 operator_ 格式
          if (transformer._isOperatorMethod(methodName)) {
            methodName = transformer._convertOperatorMethodName(methodName);
          }
          final args = _convertArguments(expr.arguments);
          return 'dart_cast<$targetType>($varName)->$methodName($args)';
        }
      }
    }

    // 递归处理三元表达式
    if (expr is ConditionalExpression) {
      final cond = convertExpression(expr.condition);
      final thenPart = _convertExpressionWithVarTypeMap(expr.then, varTypeMap);
      final elsePart =
          _convertExpressionWithVarTypeMap(expr.otherwise, varTypeMap);
      return '$cond ? $thenPart : $elsePart';
    }

    // 递归处理二元操作
    if (expr is InstanceInvocation && _isOperatorMethod(expr.name.text)) {
      final left = _convertExpressionWithVarTypeMap(expr.receiver, varTypeMap);
      if (expr.arguments.positional.isNotEmpty) {
        final right = _convertExpressionWithVarTypeMap(
            expr.arguments.positional[0], varTypeMap);
        final op = expr.name.text;
        if (op == '+' || op == '-' || op == '*' || op == '/') {
          return '$left $op $right';
        } else if (op == '==') {
          // 对于 == 操作符，需要递归处理右侧以应用类型映射
          return '($left == $right)';
        }
      }
    }

    // 处理 EqualsCall （x == y）
    if (expr is EqualsCall) {
      final left = _convertExpressionWithVarTypeMap(expr.left, varTypeMap);
      final right = _convertExpressionWithVarTypeMap(expr.right, varTypeMap);
      return '($left == $right)';
    }

    // 递归处理逻辑表达式
    if (expr is LogicalExpression) {
      final left = _convertExpressionWithVarTypeMap(expr.left, varTypeMap);
      final right = _convertExpressionWithVarTypeMap(expr.right, varTypeMap);
      final operator =
          expr.operatorEnum == LogicalExpressionOperator.AND ? '&&' : '||';
      return '$left $operator $right';
    }

    // 默认返回普通转换
    return convertExpression(expr);
  }

  /// 在 is 类型上下文中转换表达式（修复#8）
  /// 当表达式使用 is 检查的变量时，自动进行类型转换
  String _convertExpressionWithIsTypeContext(
      Expression expr, IsExpression typeContext) {
    // 检查是否是直接访问 is 表达式中的变量
    if (_isSameVariable(expr, typeContext.operand)) {
      final targetType = CppTypeConverter.convertType(typeContext.type);
      final varName = convertExpression(typeContext.operand);
      return 'dart_cast<$targetType>($varName)';
    }

    // 检查是否是对 is 表达式中变量的成员访问
    if (expr is InstanceGet) {
      if (_isSameVariable(expr.receiver, typeContext.operand)) {
        final targetType = CppTypeConverter.convertType(typeContext.type);
        final varName = convertExpression(typeContext.operand);
        final propName = expr.name.text;
        return 'dart_cast<$targetType>($varName)->$propName';
      }
    }

    // 检查是否是对 is 表达式中变量的方法调用
    if (expr is InstanceInvocation) {
      if (_isSameVariable(expr.receiver, typeContext.operand)) {
        final targetType = CppTypeConverter.convertType(typeContext.type);
        final varName = convertExpression(typeContext.operand);
        final methodName = expr.name.text;
        final args = _convertArguments(expr.arguments);
        return 'dart_cast<$targetType>($varName)->$methodName($args)';
      }
    }

    // 递归处理三元表达式
    if (expr is ConditionalExpression) {
      final cond = convertExpression(expr.condition);
      final thenPart =
          _convertExpressionWithIsTypeContext(expr.then, typeContext);
      final elsePart =
          _convertExpressionWithIsTypeContext(expr.otherwise, typeContext);
      return '$cond ? $thenPart : $elsePart';
    }

    // 递归处理二元操作
    if (expr is InstanceInvocation && _isOperatorMethod(expr.name.text)) {
      final left =
          _convertExpressionWithIsTypeContext(expr.receiver, typeContext);
      final right = _convertExpressionWithIsTypeContext(
          expr.arguments.positional[0], typeContext);
      final op = expr.name.text;
      if (op == '+' || op == '-' || op == '*' || op == '/') {
        return '$left $op $right';
      } else if (op == '==') {
        return '($left == $right)';
      }
    }

    // 默认返回普通转换
    return convertExpression(expr);
  }

  bool _isOperatorMethod(String name) {
    return {'+', '-', '*', '/', '%', '==', '!=', '<', '<=', '>', '>='}
        .contains(name);
  }

  String _convertLogicalExpression(LogicalExpression expr) {
    final operator =
        expr.operatorEnum == LogicalExpressionOperator.AND ? '&&' : '||';

    // 处理 "other is Vector && xxx" 模式的智能类型转换
    if (expr.operatorEnum == LogicalExpressionOperator.AND) {
      // 收集左侧的所有 is 表达式
      final isExpressionsInLeft = _collectIsExpressionsFromCondition(expr.left);

      // 先转换左侧
      final left = convertExpression(expr.left);

      // 在转换右侧时应用左侧的类型上下文
      if (isExpressionsInLeft.isNotEmpty) {
        // 构建变量到类型的映射
        final varTypeMap = <VariableDeclaration, DartType>{};
        for (final isExpr in isExpressionsInLeft) {
          if (isExpr.operand is VariableGet) {
            final varGet = isExpr.operand as VariableGet;
            varTypeMap[varGet.variable] = isExpr.type;
          }
        }

        // 应用类型上下文转换右侧
        final right = _convertExpressionWithVarTypeMap(expr.right, varTypeMap);
        return '$left $operator $right';
      }
    }

    // 默认处理：直接转换左右两侧
    final left = convertExpression(expr.left);
    final right = convertExpression(expr.right);
    return '$left $operator $right';
  }

  /// 在类型上下文中转换表达式，处理智能类型转换
  String _convertExpressionWithTypeContext(
      Expression expr, IsExpression typeContext) {
    if (expr is LogicalExpression &&
        expr.operatorEnum == LogicalExpressionOperator.AND) {
      // 递归处理嵌套的逻辑表达式
      final leftConverted =
          _convertExpressionWithTypeContext(expr.left, typeContext);
      final rightConverted =
          _convertExpressionWithTypeContext(expr.right, typeContext);
      return '$leftConverted && $rightConverted';
    }

    if (expr is InstanceInvocation && expr.name.text == '==') {
      // 处理 x == other.x 模式
      return _convertEqualityWithTypeContext(expr, typeContext);
    }

    return convertExpression(expr);
  }

  /// 处理带类型上下文的相等比较
  String _convertEqualityWithTypeContext(
      InstanceInvocation expr, IsExpression typeContext) {
    final left = convertExpression(expr.arguments.positional[0]);
    final receiver = convertExpression(expr.receiver);

    // 检查是否是对类型检查变量的成员访问
    if (expr.arguments.positional[0] is InstanceGet) {
      final propGet = expr.arguments.positional[0] as InstanceGet;
      if (_isSameVariable(propGet.receiver, typeContext.operand)) {
        // 这是对类型检查变量的访问，需要进行类型转换
        final targetType = CppTypeConverter.convertType(typeContext.type);
        final varName = convertExpression(typeContext.operand);
        final propName = propGet.name.text;
        final castVar = 'dart_cast<$targetType>($varName)';
        return '($receiver == $castVar->$propName)';
      }
    }

    return '$receiver->operator_eq($left)';
  }

  /// 检查两个表达式是否引用同一个变量
  bool _isSameVariable(Expression? expr1, Expression expr2) {
    if (expr1 is VariableGet && expr2 is VariableGet) {
      return expr1.variable == expr2.variable;
    }
    return false;
  }

  /// 获取表达式的根变量（递归查找链式访问的根）
  VariableGet? _getRootVariable(Expression expr) {
    if (expr is VariableGet) {
      return expr;
    } else if (expr is InstanceGet) {
      return _getRootVariable(expr.receiver);
    } else if (expr is InstanceInvocation) {
      return _getRootVariable(expr.receiver);
    }
    return null;
  }

  /// 构建带类型转换的访问路径
  String? _buildAccessPath(
      InstanceGet expr, Map<VariableDeclaration, DartType> varTypeMap) {
    final rootVar = _getRootVariable(expr.receiver);
    if (rootVar == null || !varTypeMap.containsKey(rootVar.variable)) {
      return null;
    }

    // 构建从根变量到当前属性的路径
    final pathSegments = <String>[];
    _collectPathSegments(expr, pathSegments);

    // 生成类型转换后的访问
    final targetType =
        CppTypeConverter.convertType(varTypeMap[rootVar.variable]!);
    final varName = convertExpression(rootVar);
    final castVar = 'dart_cast<$targetType>($varName)';

    // 拼接完整路径
    final fullPath = '$castVar->${pathSegments.join('->')}';
    return fullPath;
  }

  /// 收集访问路径的所有段
  void _collectPathSegments(Expression expr, List<String> segments) {
    if (expr is InstanceGet) {
      // 先递归处理receiver
      if (expr.receiver is InstanceGet) {
        _collectPathSegments(expr.receiver, segments);
      }
      // 然后添加当前属性，需要考虑getter方法
      final memberName = expr.name.text;

      // 已知的getter方法（应该作为方法调用）
      final knownGetters = {
        'length',
        'size',
        'isEmpty',
        'isNotEmpty',
        'iterator',
        'first',
        'last',
        'single',
        'runtimeType',
        'hashCode'
      };

      // 检查是否是getter方法，统一使用 get_ 前缀
      if (knownGetters.contains(memberName)) {
        segments.add('get_$memberName()');
      } else if (!_isRealProperty(expr)) {
        // 如果不是真实属性，作为getter方法调用，使用 get_ 前缀
        segments.add('get_$memberName()');
      } else {
        // 真实属性直接访问
        segments.add(memberName);
      }
    }
  }

  /// 转换receiver，应用类型映射
  String _convertReceiverWithTypeMap(
      Expression receiver, Map<VariableDeclaration, DartType> varTypeMap) {
    final rootVar = _getRootVariable(receiver);
    if (rootVar == null || !varTypeMap.containsKey(rootVar.variable)) {
      // 没有匹配的类型映射，直接转换
      return convertExpression(receiver);
    }

    if (receiver is VariableGet) {
      // 直接是变量
      final targetType =
          CppTypeConverter.convertType(varTypeMap[receiver.variable]!);
      final varName = convertExpression(receiver);
      return 'dart_cast<$targetType>($varName)';
    } else if (receiver is InstanceGet) {
      // 链式访问
      final path = _buildAccessPath(receiver, varTypeMap);
      if (path != null) {
        return path;
      }
    }

    // 默认返回普通转换
    return convertExpression(receiver);
  }

  String _convertListLiteral(ListLiteral expr) {
    String elementType = CppTypeConverter.convertType(expr.typeArgument);

    // 调试输出
    // print('DEBUG _convertListLiteral: elementType=$elementType, typeArgument=${expr.typeArgument}');

    // 混合类型检测：当元素类型是 Object 或 ObjectPtr<Object> 时，检查是否包含值类型
    // 如果包含值类型，应使用 Any 而不是 ObjectPtr<Object>
    if (elementType == 'ObjectPtr<Object>' || elementType == 'Object') {
      if (expr.expressions.isNotEmpty) {
        bool hasValueType = false;

        for (final e in expr.expressions) {
          final inferredType = _inferExpressionType(e);
          // 检查是否是值类型
          if (_isCppValueType(inferredType)) {
            hasValueType = true;
            break; // 发现值类型后无需继续检查
          }
        }

        // 如果包含值类型（无论是否混合），都应该使用 Any
        // 只有全部是 ObjectPtr 类型时，才使用 ObjectPtr<Object>
        if (hasValueType) {
          elementType = 'Any';
        }
      }
    }

    if (expr.expressions.isEmpty) {
      // 空列表：使用带类型参数的 dart_literal<T>()
      return 'dart_literal<$elementType>()';
    }

    final elements =
        expr.expressions.map((e) => convertExpression(e)).join(', ');
    // 有元素的列表：使用带类型参数的 dart_literal<T>(...)
    return 'dart_literal<$elementType>($elements)';
  }

  /// 检查类型是否是 C++ 值类型（不是 ObjectPtr 包装的类型）
  bool _isCppValueType(String typeName) {
    const cppValueTypes = {
      'int', 'double', 'bool', 'String', // Dart 原始类型名
      'Int', 'Double', 'Bool', // C++ 包装类型名
      'Null', 'dynamic', 'Any', // 特殊类型
    };
    return cppValueTypes.contains(typeName);
  }

  String _convertSetLiteral(SetLiteral expr) {
    final elementType = CppTypeConverter.convertType(expr.typeArgument);
    if (expr.expressions.isEmpty) {
      return 'ObjectPtr<Set<$elementType>>(new Set<$elementType>())';
    }
    final elements =
        expr.expressions.map((e) => convertExpression(e)).join(', ');
    return 'ObjectPtr<Set<$elementType>>(new Set<$elementType>({$elements}))';
  }

  // 修复#19: 展开操作符支持
  String _convertListConcatenation(ListConcatenation expr) {
    final elementType = CppTypeConverter.convertType(expr.typeArgument);
    if (expr.lists.isEmpty) {
      return 'List<$elementType>::create()';
    }
    if (expr.lists.length == 1) {
      return convertExpression(expr.lists.first);
    }
    // 使用 dart_spread 函数合并多个列表
    final lists = expr.lists.map((e) => convertExpression(e)).join(', ');
    return 'dart_spread<$elementType>($lists)';
  }

  String _convertSetConcatenation(SetConcatenation expr) {
    final elementType = CppTypeConverter.convertType(expr.typeArgument);
    if (expr.sets.isEmpty) {
      return 'Set<$elementType>::create()';
    }
    if (expr.sets.length == 1) {
      return convertExpression(expr.sets.first);
    }
    // 使用 dart_spread_set 函数合并多个集合
    final sets = expr.sets.map((e) => convertExpression(e)).join(', ');
    return 'dart_spread_set<$elementType>($sets)';
  }

  String _convertMapConcatenation(MapConcatenation expr) {
    final keyType = CppTypeConverter.convertType(expr.keyType);
    final valueType = CppTypeConverter.convertType(expr.valueType);
    if (expr.maps.isEmpty) {
      return 'Map<$keyType, $valueType>::create()';
    }
    if (expr.maps.length == 1) {
      return convertExpression(expr.maps.first);
    }
    // 使用 dart_spread_map 函数合并多个映射
    final maps = expr.maps.map((e) => convertExpression(e)).join(', ');
    return 'dart_spread_map<$keyType, $valueType>($maps)';
  }

  String _convertMapLiteral(MapLiteral expr) {
    final keyType = CppTypeConverter.convertType(expr.keyType);
    final valueType = CppTypeConverter.convertType(expr.valueType);

    if (expr.entries.isEmpty) {
      return 'Map<$keyType, $valueType>::create()';
    }

    final entries = expr.entries.map((entry) {
      final key = convertExpression(entry.key);
      final value = convertExpression(entry.value);
      return '{$key, $value}';
    }).join(', ');

    return 'Map<$keyType, $valueType>::create({$entries})';
  }

  // 新增的转换方法

  String _convertSymbolLiteral(SymbolLiteral expr) {
    return 'Symbol(dart_string("${expr.value}"))';
  }

  String _convertTypeLiteral(TypeLiteral expr) {
    // 修复: 使用 CppTypeConverter.convertType 正确转换类型，
    // 避免 TypeParameterType 等内部类型名泄露到生成代码中
    final typeName = CppTypeConverter.convertType(expr.type);
    return 'Type::of<$typeName>()';
  }

  String _convertVariableSet(VariableSet expr) {
    final varName = expr.variable.name ?? 'unnamed_var';
    final value = convertExpression(expr.value);

    // 特殊处理dynamic类型变量的赋值
    // 如果变量是dynamic类型，需要确保赋值兼容Any类型
    if (expr.variable.type is DynamicType) {
      // 对于dynamic类型变量，直接赋值即可，因为Any可以接受任何类型
      return '$varName = $value';
    }

    // 特殊处理：装箱变量的赋值需要先解引用
    if (transformer._boxingVars.containsKey(expr.variable)) {
      return '(*$varName) = $value';
    }

    return '$varName = $value';
  }

  String _convertInstanceGet(InstanceGet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;

    // 特殊处理dynamic类型变量的成员访问
    // 但如果变量已经被类型提升（promoted），则不应该使用 DART_ANY_CALL
    if (expr.receiver is VariableGet) {
      final varGet = expr.receiver as VariableGet;
      final varName = _sanitizeIdentifier(varGet.variable.name ?? 'unnamed');
      // 检查变量是否已被类型提升
      final isPromoted = _promotedVarMapping.containsKey(varName);

      if (!isPromoted && varGet.variable.type is DynamicType) {
        // 对于dynamic类型变量（未被类型提升），使用特殊的宏来访问成员
        // 这样可以避免编译时类型检查错误
        return 'DART_ANY_CALL($receiver, $memberName)';
      }
    }

    // 特殊处理：Dart 迭代器 API 映射到 C++ Iterator API
    if (memberName == 'current') {
      // Dart 的 current getter 映射到 C++ 的 next() 方法
      return '$receiver->next()';
    }

    // 特殊处理：某些getter需要作为方法调用
    final methodLikeGetters = {
      'isEmpty',
      'isNotEmpty',
      'iterator',
      'first',
      'last',
      'single',
      'reversed',
      'keys', // Map的keys属性
      'values', // Map的values属性
      'entries', // Map的entries属性
    };

    // Future 特殊方法处理
    if (transformer._isFutureType(expr.receiver)) {
      return transformer._convertFutureMethod(expr.receiver, memberName);
    }

    // 智能类型推断：区分属性访问和getter方法调用
    // 使用 interfaceTarget 来判断是字段还是 getter
    final isRealProperty = _isRealProperty(expr);

    // 判断是否是C++运行时库的内置类型
    final isBuiltinType = _isBuiltinRuntimeType(expr.receiver);

    // 统一使用 -> 访问
    // 对于 length 属性，内置类型使用 get_length()，用户自定义类使用 length()
    if (memberName == 'length') {
      if (isBuiltinType) {
        return '$receiver->get_length()';
      } else {
        return '$receiver->length()';
      }
    }
    // runtimeType 特殊处理：基本类型没有 get_runtimeType() 方法
    // 对于内置类型，直接返回类型名字符串；对于用户自定义类，调用 get_runtimeType()
    if (memberName == 'runtimeType') {
      if (isBuiltinType) {
        // 内置类型直接返回类型名字符串（避免调用不存在的 get_runtimeType()）
        return 'dart_string("${_getBuiltinTypeName(expr.receiver)}")';
      } else {
        return '$receiver->get_runtimeType()';
      }
    }

    // 某些getter在内置类型中是普通方法（无 get_ 前缀），在用户自定义类中是 getter（有 get_ 前缀）
    if (methodLikeGetters.contains(memberName)) {
      if (isBuiltinType) {
        return '$receiver->$memberName()';
      } else {
        return '$receiver->get_$memberName()';
      }
    }
    // 根据类型推断决定是属性访问还是getter调用
    if (isRealProperty) {
      return '$receiver->$memberName'; // 直接属性访问
    } else {
      // getter方法调用：
      // - 内置类型：使用 get_ 前缀（如 get_length()）
      // - 用户自定义类：使用 get_ 前缀（生成侧已统一添加）
      return '$receiver->get_$memberName()';
    }
  }

  /// 判断表达式的类型是否是C++运行时库的内置类型
  bool _isBuiltinRuntimeType(Expression expr) {
    // C++运行时库内置类型列表
    const builtinTypes = {
      'int',
      'double',
      'bool',
      'String',
      'num',
      'Int',
      'Double',
      'Bool',
      'List',
      'Set',
      'Map',
      'Iterable',
      'Object',
      'Null',
      'dynamic',
      'Future',
      'Stream',
      'Completer',
      'StringBuffer',
      'RegExp',
      'Timer',
      'DateTime',
      'Duration',
      'Uri',
      'Exception',
      'Error',
      'StackTrace',
      'Type',
      'Symbol',
      'Enum',
      'Function',
      'TypedFunction',
    };

    // 从表达式的类型中获取类名
    DartType? type;
    if (expr is VariableGet) {
      type = expr.promotedType ?? expr.variable.type;
    } else if (expr is ThisExpression) {
      // 处理 this 表达式：从当前类上下文获取类型
      // this 表达式的类型就是当前所在的类
      // 需要从 transformer 的上下文中获取当前类信息
      final currentClass = transformer._currentClass;
      if (currentClass != null) {
        type = InterfaceType(currentClass, Nullability.nonNullable);
      }
    } else if (expr is InstanceInvocation) {
      final target = expr.interfaceTarget;
      if (target is Procedure) {
        type = target.function.returnType;
      }
    } else if (expr is InstanceGet) {
      final target = expr.interfaceTarget;
      if (target is Field) {
        type = target.type;
      } else if (target is Procedure) {
        type = target.function.returnType;
      }
    } else if (expr is ConstructorInvocation) {
      type = InterfaceType(expr.target.enclosingClass, Nullability.nonNullable);
    } else if (expr is StaticInvocation) {
      type = expr.target.function.returnType;
    }

    if (type == null) return true; // 保守策略：默认当作内置类型

    // 提取类名
    String className;
    if (type is InterfaceType) {
      className = type.classNode.name;
    } else {
      // 对于其他类型（如 DynamicType、VoidType 等），当作内置类型
      return true;
    }

    return builtinTypes.contains(className);
  }

  /// 获取内置类型的 C++ 类型名称字符串（用于 runtimeType 访问）
  String _getBuiltinTypeName(Expression expr) {
    DartType? type;
    if (expr is VariableGet) {
      type = expr.promotedType ?? expr.variable.type;
    } else if (expr is InstanceGet) {
      final target = expr.interfaceTarget;
      if (target is Field) {
        type = target.type;
      } else if (target is Procedure) {
        type = target.function.returnType;
      }
    } else if (expr is ConstructorInvocation) {
      type = InterfaceType(expr.target.enclosingClass, Nullability.nonNullable);
    } else if (expr is StaticInvocation) {
      type = expr.target.function.returnType;
    }

    if (type is InterfaceType) {
      return CppTypeConverter.convertType(type);
    }
    return 'Object';
  }

  String _convertInstanceSet(InstanceSet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;
    final value = convertExpression(expr.value);

    // 使用 interfaceTarget 判断是字段还是 setter
    final target = expr.interfaceTarget;
    final isRealField = target is Field;

    // 统一使用 -> 访问
    if (isRealField) {
      return '$receiver->$memberName = $value'; // 直接字段赋值
    } else {
      return '$receiver->set_$memberName($value)'; // setter 方法调用
    }
  }

  /// 判断表达式的类型是否是自定义类（而不是基础类型）
  bool _isCustomClass(Expression expr) {
    // 基础类型列表
    const basicTypes = {
      'int',
      'double',
      'bool',
      'String',
      'Int',
      'Double',
      'Bool',
      'List',
      'Set',
      'Map',
      'Object',
      'Null',
      'dynamic',
      'Future',
      'Stream',
      'StringBuffer',
      'RegExp',
      'Timer',
    };

    // 尝试从 interfaceTarget 获取返回类型信息（对于 InstanceInvocation - 方法调用）
    if (expr is InstanceInvocation) {
      final target = expr.interfaceTarget;
      if (target is Procedure) {
        // 获取方法的返回类型，而不是方法所属的类
        final returnType = target.function.returnType;
        if (returnType is InterfaceType) {
          final className = returnType.classNode.name;
          return !basicTypes.contains(className);
        }
      }
    }

    // 尝试从 interfaceTarget 获取字段类型信息（对于 InstanceGet）
    if (expr is InstanceGet) {
      final target = expr.interfaceTarget;
      if (target is Field) {
        // 获取字段的类型
        final fieldType = target.type;
        if (fieldType is InterfaceType) {
          final className = fieldType.classNode.name;
          return !basicTypes.contains(className);
        }
      } else if (target is Procedure && target.enclosingClass != null) {
        // 对于 getter，获取返回类型
        final returnType = target.function.returnType;
        if (returnType is InterfaceType) {
          final className = returnType.classNode.name;
          return !basicTypes.contains(className);
        }
      }
    }

    // 对于其他表达式，使用保守策略：假设不是自定义类
    return false;
  }

  // 辅助方法：判断表达式是否可能是值类型
  bool _isLikelyValueType(Expression expr) {
    // 字面量肯定是值类型
    if (expr is IntLiteral ||
        expr is DoubleLiteral ||
        expr is BoolLiteral ||
        expr is StringLiteral) {
      return true;
    }

    // 检查静态调用是否是值类型构造
    if (expr is StaticInvocation) {
      final targetName = expr.target.name.text;
      if (targetName == 'dart_int' ||
          targetName == 'dart_double' ||
          targetName == 'dart_bool' ||
          targetName == 'dart_string') {
        return true;
      }
    }

    // 检查变量引用 - 通过类型和初始化表达式判断
    if (expr is VariableGet) {
      // 首先检查变量的初始化表达式
      if (expr.variable.initializer != null) {
        // 递归检查初始化表达式是否为值类型
        if (_isLikelyValueType(expr.variable.initializer!)) {
          return true;
        }
      }

      // 然后检查类型信息
      final type = expr.promotedType ?? expr.variable.type;
      final typeName = type.toString();
      // 基本值类型
      if (typeName == 'int' ||
          typeName == 'double' ||
          typeName == 'bool' ||
          typeName == 'String' ||
          typeName == 'Int' ||
          typeName == 'Double' ||
          typeName == 'Bool') {
        return true;
      }
    }

    // 检查实例调用的结果 - 如果是值类型的方法调用，结果也是值类型
    if (expr is InstanceInvocation) {
      // toString() 返回 String，是值类型
      if (expr.name.text == 'toString') {
        return true;
      }
      // 算术运算的结果是值类型
      if (_isLikelyValueType(expr.receiver)) {
        final methodName = expr.name.text;
        if (methodName == '+' ||
            methodName == '-' ||
            methodName == '*' ||
            methodName == '/' ||
            methodName == '%' ||
            methodName == '~/' ||
            methodName == 'truncatingDivision' ||
            methodName == 'operator_negate') {
          return true;
        }
      }
    }

    // 默认假设是对象类型（使用 ->）
    return false;
  }

  // 智能类型推断：判断是否为真实属性（而非getter方法）
  bool _isRealProperty(InstanceGet expr) {
    final memberName = expr.name.text;

    // 已知的getter方法（应该作为方法调用）
    final knownGetters = {
      'length',
      'size',
      'isEmpty',
      'isNotEmpty',
      'iterator',
      'first',
      'last',
      'single',
      'runtimeType',
      'hashCode'
    };

    if (knownGetters.contains(memberName)) {
      return false; // 这些是getter方法
    }

    // 关键：使用 interfaceTarget 来判断目标成员的类型
    final target = expr.interfaceTarget;

    // 如果 target 是 Field，说明是真实的字段
    if (target is Field) {
      return true; // 这是一个字段，直接访问
    }

    // 如果 target 是 Procedure，需要进一步判断
    if (target is Procedure) {
      // Getter 方法需要调用
      if (target.isGetter) {
        return false; // 这是 getter 方法
      }
      // 其他类型的 Procedure（如普通方法）也不是属性
      return false;
    }

    // 如果无法确定 target，默认假设是 getter 方法
    // 这样更保守，可以确保 getter 属性被正确调用为 get_xxx()
    return false;
  }

  // 修复方法名映射
  String _fixMethodName(Expression receiver, String memberName) {
    // C++保留字处理：union是C++关键字，需要转换
    const cppKeywordMethods = {
      'union': 'union_', // Set.union() -> Set.union_() (union是C++关键字)
      'class': 'class_',
      'new': 'new_',
      'delete': 'delete_',
      'register': 'register_',
      'operator': 'operator_',
    };
    if (cppKeywordMethods.containsKey(memberName)) {
      return cppKeywordMethods[memberName]!;
    }

    // String 类型的特殊方法映射
    if (receiver is VariableGet) {
      final type = receiver.promotedType ?? receiver.variable.type;
      final typeName = type.toString();

      if (typeName == 'String') {
        if (memberName == 'size') {
          return 'length'; // String.size() -> String.length()
        }
      }
    }

    return memberName; // 默认不修改
  }

  String _convertDynamicGet(DynamicGet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;

    // 特殊处理dynamic类型变量的成员访问
    // 如果接收者是dynamic类型，需要使用特殊的访问方式
    if (expr.receiver is VariableGet &&
        (expr.receiver as VariableGet).variable.type is DynamicType) {
      // 对于Any类型的变量，我们需要先进行类型转换再访问成员
      // 这里我们生成特殊的宏或函数调用来处理
      return '$receiver.$memberName';
    }

    return '$receiver.$memberName';
  }

  String _convertDynamicSet(DynamicSet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;
    final value = convertExpression(expr.value);
    return '$receiver.$memberName = $value';
  }

  String _convertInstanceTearOff(InstanceTearOff expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;

    // 成员函数需要捕获receiver对象
    final capturedVarsArray = ', std::vector<Any>{Any($receiver)}';

    // 获取方法签名信息
    final target = expr.interfaceTarget;
    final functionNode = target.function;
    final returnType = CppTypeConverter.convertType(functionNode.returnType);
    final paramTypes = functionNode.positionalParameters
        .map((p) => CppTypeConverter.convertType(p.type))
        .toList();

    // 生成参数列表
    final params = functionNode.positionalParameters
        .map(
            (p) => '${CppTypeConverter.convertType(p.type)} ${p.name ?? "arg"}')
        .join(', ');

    // 生成参数名列表（用于调用）
    final argNames = functionNode.positionalParameters
        .map((p) => p.name ?? "arg")
        .join(', ');

    // 生成显式模板参数 makeFunction<R, Args...>
    final templateParams = [returnType, ...paramTypes].join(', ');

    // 生成 std::function 类型
    final stdFuncType = 'std::function<$returnType(${paramTypes.join(', ')})>';

    // 使用 makeFunction 包装实例方法，显式指定类型参数
    // 全局作用域使用空捕获 []，局部作用域使用值捕获 [=]
    final captureList = isGlobalScope ? '[]' : '[=]';
    return 'makeFunction<$templateParams>($stdFuncType($captureList($params) -> $returnType { return $receiver->$memberName($argNames); })$capturedVarsArray)';
  }

  String _convertStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target is Field) {
      final className = target.enclosingClass?.name ?? '';
      final fieldName = target.name.text;
      if (className.isNotEmpty) {
        return '$className::$fieldName';
      }
      return fieldName;
    }
    return '/* StaticGet */';
  }

  String _convertStaticSet(StaticSet expr) {
    final target = expr.target;
    final className = target.enclosingClass?.name ?? '';
    final fieldName = target.name.text;
    final value = convertExpression(expr.value);
    if (className.isNotEmpty) {
      return '$className::$fieldName = $value';
    }
    return '$fieldName = $value';
  }

  String _convertStaticTearOff(StaticTearOff expr) {
    // 处理函数引用：使用 makeFunction 包装函数指针
    final target = expr.target;
    final className = target.enclosingClass?.name ?? '';
    final methodName = target.name.text;

    // 生成函数指针
    final functionPtr =
        className.isNotEmpty ? '&$className::$methodName' : '&$methodName';

    // 获取函数签名信息
    final functionNode = target.function;
    final returnType = CppTypeConverter.convertType(functionNode.returnType);
    final paramTypes = functionNode.positionalParameters
        .map((p) => CppTypeConverter.convertType(p.type))
        .toList();

    // 生成显式模板参数 makeFunction<R, Args...>
    final templateParams = [returnType, ...paramTypes].join(', ');

    // 生成 std::function 类型
    final stdFuncType = 'std::function<$returnType(${paramTypes.join(', ')})>';

    // 使用 makeFunction 包装函数指针，显式指定类型参数
    return 'makeFunction<$templateParams>($stdFuncType($functionPtr))';
  }

  String _convertSuperPropertyGet(SuperPropertyGet expr) {
    final memberName = expr.name.text;
    return 'this->$memberName()';
  }

  String _convertSuperPropertySet(SuperPropertySet expr) {
    final memberName = expr.name.text;
    final value = convertExpression(expr.value);
    return 'this->set_$memberName($value)';
  }

  String _convertDynamicInvocation(DynamicInvocation expr) {
    final receiver = convertExpression(expr.receiver);
    final methodName = expr.name.text;
    // 动态调用无法静态获取函数信息，使用原有逻辑
    final args = _convertArguments(expr.arguments);
    return '$receiver.$methodName($args)';
  }

  String _convertFunctionInvocation(FunctionInvocation expr) {
    final receiver = convertExpression(expr.receiver);
    // Function对象调用无法静态获取函数签名，使用原有逻辑
    final args = _convertArguments(expr.arguments);
    // 使用 call 方法直接调用 Function 对象
    // call 方法直接接受参数，不需要包装为 std::vector<Any>
    // 确保使用TypeFunction类型进行参数传递
    return '$receiver->call($args)';
  }

  String _convertLocalFunctionInvocation(LocalFunctionInvocation expr) {
    final functionName = expr.variable.name ?? 'unnamed_func';
    // 尝试获取函数节点信息进行参数补全
    FunctionNode? targetFunction;
    if (expr.variable.initializer is FunctionExpression) {
      targetFunction =
          (expr.variable.initializer as FunctionExpression).function;
    }
    final args = _convertArguments(expr.arguments, targetFunction);
    return '$functionName($args)';
  }

  String _convertSuperMethodInvocation(SuperMethodInvocation expr) {
    final methodName = expr.name.text;
    // 对于父类方法调用，暂时使用原有逻辑（需要更复杂的类型分析来获取父类方法信息）
    final args = _convertArguments(expr.arguments);
    return 'this->$methodName($args)';
  }

  String _convertEqualsCall(EqualsCall expr) {
    final left = convertExpression(expr.left);
    final right = convertExpression(expr.right);
    return '($left == $right)';
  }

  String _convertEqualsNull(EqualsNull expr) {
    final operand = convertExpression(expr.expression);
    return 'dart_is_null($operand)';
  }

  String _convertConstructorInvocation(ConstructorInvocation expr) {
    final originalClassName = expr.target.enclosingClass.name;
    final constructorName = expr.target.name.text; // 获取构造函数名称

    // 特殊处理 RegExp 构造函数，转换为 String
    // RegExp 已合并到 String 类型，构造时直接使用 dart_string
    if (originalClassName == 'RegExp') {
      // RegExp 构造函数只使用第一个参数（pattern）
      if (expr.arguments.positional.isNotEmpty) {
        final pattern = convertExpression(expr.arguments.positional.first);
        // 直接返回参数表达式，它已经是 String 类型
        return pattern;
      }
      return 'dart_string("")';
    }

    // 特殊处理 List 工厂构造函数：List.from, List.of, List.filled 等
    if (originalClassName == 'List' || originalClassName == '_GrowableList') {
      // 推断元素类型
      String elementType = 'Any';
      if (expr.arguments.types.isNotEmpty) {
        final typeArg = expr.arguments.types.first;
        if (typeArg is! TypeParameterType) {
          elementType = CppTypeConverter.convertType(typeArg);
        }
      }

      // List.from(iterable, {growable = true}) -> List<T>::from(iterable)
      // 忽略 growable 参数，C++ 端不需要
      if (constructorName == 'from' || constructorName == 'of') {
        if (expr.arguments.positional.isNotEmpty) {
          final source = convertExpression(expr.arguments.positional.first);
          return 'List<$elementType>::$constructorName($source)';
        }
        return 'List<$elementType>::create()';
      }

      // List.filled(length, fill, {growable = false}) -> List<T>::filled(length, fill)
      if (constructorName == 'filled') {
        if (expr.arguments.positional.length >= 2) {
          final length = convertExpression(expr.arguments.positional[0]);
          final fill = convertExpression(expr.arguments.positional[1]);
          return 'List<$elementType>::filled($length, $fill)';
        }
      }

      // List.generate(length, generator, {growable = true}) -> List<T>::generate(length, generator)
      if (constructorName == 'generate') {
        if (expr.arguments.positional.length >= 2) {
          final length = convertExpression(expr.arguments.positional[0]);
          final generator = convertExpression(expr.arguments.positional[1]);
          return 'List<$elementType>::generate($length, $generator)';
        }
      }
    }

    // 修复问题1A: 处理_GrowableList::_literalN调用
    if (originalClassName == '_GrowableList' ||
        originalClassName == '_List' ||
        (originalClassName.startsWith('_') &&
            expr.target.name.text.startsWith('_literal'))) {
      // 推断元素类型
      String elementType = 'Any';

      // 1. 尝试从构造函数的类型参数推断
      if (expr.arguments.types.isNotEmpty) {
        final typeArg = expr.arguments.types.first;
        if (typeArg is! TypeParameterType) {
          elementType = CppTypeConverter.convertType(typeArg);
        }
      }
      // 2. 如果还是泛型,尝试从第一个参数推断(跳过容量参数)
      if (elementType == 'Any' && expr.arguments.positional.isNotEmpty) {
        final firstArg = expr.arguments.positional.first;
        final isCapacityArg = firstArg is IntLiteral && firstArg.value == 0;

        if (!isCapacityArg) {
          elementType = _inferExpressionType(firstArg);
          if (elementType == 'int')
            elementType = 'Int';
          else if (elementType == 'double')
            elementType = 'Double';
          else if (elementType == 'bool')
            elementType = 'Bool';
          else if (elementType == 'dynamic') elementType = 'Any';
        }
      }

      // 混合类型检测：当元素类型是 Object 或 ObjectPtr<Object> 时，检查是否包含值类型
      // 如果包含值类型，应使用 Any 而不是 ObjectPtr<Object>
      if (elementType == 'ObjectPtr<Object>' || elementType == 'Object') {
        final nonCapacityArgs = expr.arguments.positional.where((arg) =>
            !(arg is IntLiteral &&
                arg.value == 0 &&
                expr.arguments.positional.first == arg));
        if (nonCapacityArgs.isNotEmpty) {
          bool hasValueType = false;
          for (final e in nonCapacityArgs) {
            final inferredType = _inferExpressionType(e);
            if (_isCppValueType(inferredType)) {
              hasValueType = true;
              break;
            }
          }
          // 如果包含值类型，应该使用 Any
          if (hasValueType) {
            elementType = 'Any';
          }
        }
      }

      // 过滤掉容量参数
      final args = expr.arguments.positional
          .where((arg) => !(arg is IntLiteral &&
              arg.value == 0 &&
              expr.arguments.positional.first == arg))
          .map((arg) => convertExpression(arg))
          .join(', ');
      if (args.isEmpty) {
        return 'dart_literal<$elementType>()';
      }
      return 'dart_literal<$elementType>($args)';
    }

    // 对于已知的 C++ 异常类，只使用实际提供的参数，不进行可选参数补全
    // 因为 C++ 端的异常类构造函数参数数量与 Dart 不同
    const cppExceptionClasses = {
      'ArgumentError',
      'RangeError',
      'StateError',
      'FormatException',
      'UnsupportedError',
      'UnimplementedError',
      'TypeError',
      'CastError',
      'NullThrownError',
      'NoSuchMethodError',
      'StackOverflowError',
      'OutOfMemoryError',
      'AssertionError',
      'Exception',
      'Error',
    };

    final String args;
    if (cppExceptionClasses.contains(originalClassName)) {
      // 只使用实际提供的位置参数，不补全可选参数
      args =
          expr.arguments.positional.map((a) => convertExpression(a)).join(', ');
    } else if (expr.arguments.positional.isEmpty &&
        expr.arguments.named.isEmpty) {
      // 对于无参构造函数，不进行参数补全
      args = _convertArguments(expr.arguments);
    } else {
      args = _convertArguments(expr.arguments, expr.target.function);
    }

    // 特殊处理 Duration 的无参构造函数：Duration() -> Duration(dart_int(0))
    // C++ 的 Duration 没有默认无参构造函数，最简单的构造需要 milliseconds 参数
    if (originalClassName == 'Duration' &&
        constructorName.isEmpty &&
        expr.arguments.positional.isEmpty &&
        expr.arguments.named.isEmpty) {
      return 'ObjectPtr<Duration>(new Duration(dart_int(0)))';
    }

    // 特殊处理 Duration 的命名参数构造函数
    // Dart: Duration(seconds: 30) -> C++: Duration::create(0, 0, 0, 30, 0, 0)
    if (originalClassName == 'Duration' &&
        constructorName.isEmpty &&
        expr.arguments.named.isNotEmpty) {
      // 按照 C++ Duration::create 的参数顺序提取命名参数
      final durationParamNames = [
        'days',
        'hours',
        'minutes',
        'seconds',
        'milliseconds',
        'microseconds'
      ];
      final namedArgMap = <String, String>{};
      for (final namedArg in expr.arguments.named) {
        namedArgMap[namedArg.name] = convertExpression(namedArg.value);
      }
      final durationArgs = durationParamNames
          .map((name) => namedArgMap[name] ?? 'dart_int(0)')
          .join(', ');
      return 'ObjectPtr<Duration>(new Duration($durationArgs))';
    }

    // 使用 TypeAnalyzer 判断是否需要 ObjectPtr（使用原始类名）
    final needsObjectPtr =
        transformer.typeAnalyzer.customClasses.contains(originalClassName) ||
            transformer.typeAnalyzer.containerTypes.contains(originalClassName);

    // 清理类名中的特殊字符（如混入类 _Bird&Object&Flyable）
    final className = _sanitizeIdentifier(originalClassName);

    // 特殊处理 MapEntry 构造函数：Dart 的 MapEntry(key, value) 在 Kernel AST 中
    // 构造函数名为 '_'（私有），但 C++ 中应使用 MapEntry<K,V>::create(key, value)
    if (originalClassName == 'MapEntry') {
      // 从类型参数中提取 K 和 V
      String keyType = 'Any';
      String valueType = 'Any';
      if (expr.arguments.types.length >= 2) {
        keyType = CppTypeConverter.convertType(expr.arguments.types[0]);
        valueType = CppTypeConverter.convertType(expr.arguments.types[1]);
      } else if (expr.target.enclosingClass.typeParameters.length >= 2) {
        // 尝试从构造函数目标的类型参数推断
        keyType = 'Any';
        valueType = 'Any';
      }
      return 'MapEntry<$keyType, $valueType>::create($args)';
    }

    // 处理命名构造函数调用：ClassName.namedCtor(args) -> ClassName::namedCtor(args)
    // 命名构造函数在 C++ 中被转换为静态工厂方法，调用时使用 ClassName::ctorName(args)
    if (constructorName.isNotEmpty) {
      final sanitizedCtorName = _sanitizeIdentifier(constructorName);
      // 修复内部类型名称
      final fixedClassName = className
          .replaceAll('_Set', 'Set')
          .replaceAll('_Map', 'Map')
          .replaceAll('_List', 'List');
      if (needsObjectPtr) {
        return '$fixedClassName::$sanitizedCtorName($args)';
      } else {
        return '$fixedClassName::$sanitizedCtorName($args)';
      }
    }

    if (expr.isConst) {
      // 只有 List/Set/Map 支持 createConst，其他类型使用普通构造函数
      final isContainerType = className == 'List' ||
          className == 'Set' ||
          className == 'Map' ||
          className == '_List' ||
          className == '_Set' ||
          className == '_Map';

      if (isContainerType) {
        if (needsObjectPtr) {
          return 'ObjectPtr<$className>::createConst($args)';
        } else {
          return '$className::createConst($args)';
        }
      } else {
        // 对于非容器类型，使用普通构造函数
        if (needsObjectPtr) {
          return 'ObjectPtr<$className>(new $className($args))';
        } else {
          return '$className($args)';
        }
      }
    }

    // 修复内部类型名称
    final fixedClassName = className
        .replaceAll('_Set', 'Set')
        .replaceAll('_Map', 'Map')
        .replaceAll('_List', 'List');

    // 修复问题3A: 推导泛型参数
    // 对于 Set、List、Map 等容器类型，需要推导泛型参数
    String typeParams = '';
    if (expr.arguments.types.isNotEmpty) {
      // 使用构造函数调用提供的类型参数
      final types = expr.arguments.types
          .map((t) => CppTypeConverter.convertType(t))
          .join(', ');
      typeParams = '<$types>';
    }

    if (needsObjectPtr) {
      return 'ObjectPtr<$fixedClassName$typeParams>(new $fixedClassName$typeParams($args))';
    } else {
      return '$fixedClassName$typeParams($args)';
    }
  }

  String _convertIsExpression(IsExpression expr) {
    final operand = convertExpression(expr.operand);
    final type = CppTypeConverter.convertType(expr.type);
    return 'dart_is<$type>($operand)';
  }

  String _convertAsExpression(AsExpression expr) {
    final operand = convertExpression(expr.operand);
    final type = CppTypeConverter.convertType(expr.type);
    return 'dart_cast<$type>($operand)';
  }

  String _convertNullCheck(NullCheck expr) {
    // NullCheck (obj!) 表示非空断言，直接返回表达式
    final operand = convertExpression(expr.operand);
    // 根据规则文档，obj! 转换为直接访问，不需要特殊处理
    return operand;
  }

  String _convertStringConcatenation(StringConcatenation expr) {
    if (expr.expressions.length == 1) {
      final converted = convertExpression(expr.expressions[0]);
      // 如果不是字符串类型，需要调用 toString()
      if (!_isStringExpression(expr.expressions[0])) {
        return '($converted).toString()';
      }
      return converted;
    }

    // 优化：连续的字符串字面量可以合并
    final optimizedParts = _optimizeStringParts(expr.expressions);

    if (optimizedParts.length == 1) {
      return optimizedParts[0];
    } else if (optimizedParts.length == 2) {
      // 两个部分直接用 + 连接
      return '${optimizedParts[0]} + ${optimizedParts[1]}';
    } else {
      // 多个部分使用 dart_concat
      return 'dart_concat(${optimizedParts.join(', ')})';
    }
  }

  /// 检查表达式是否是字符串类型
  bool _isStringExpression(Expression expr) {
    return expr is StringLiteral;
  }

  /// 优化字符串部分，合并连续的字符串字面量
  List<String> _optimizeStringParts(List<Expression> expressions) {
    final List<String> parts = [];
    String currentLiteralGroup = '';

    for (final expr in expressions) {
      if (expr is StringLiteral) {
        // 累积字符串字面量
        currentLiteralGroup += expr.value;
      } else {
        // 非字符串表达式，先处理累积的字面量
        if (currentLiteralGroup.isNotEmpty) {
          parts.add(CppTypeConverter.convertLiteral(currentLiteralGroup));
          currentLiteralGroup = '';
        }

        // 处理非字符串表达式
        final converted = convertExpression(expr);
        if (_isStringExpression(expr)) {
          parts.add(converted);
        } else {
          parts.add('($converted).toString()');
        }
      }
    }

    // 处理最后的字符串字面量
    if (currentLiteralGroup.isNotEmpty) {
      parts.add(CppTypeConverter.convertLiteral(currentLiteralGroup));
    }

    return parts;
  }

  String _convertThrow(Throw expr) {
    final operand = convertExpression(expr.expression);
    // 根据异常类型选择合适的 C++ 异常
    if (expr.expression is StringLiteral) {
      return 'throw std::runtime_error($operand.getValue())';
    } else {
      return 'throw DartException($operand)';
    }
  }

  /// 从 FunctionExpression 的函数体推断真正的返回类型
  /// 特别处理嵌套 lambda 的情况（如柯里化函数）
  String _inferLambdaReturnType(FunctionExpression expr) {
    // 首先获取声明的返回类型
    final declaredReturnType = expr.function.returnType;

    // 如果声明的返回类型是完整的（不是 dynamic 或不完整的 FunctionType），直接使用
    if (declaredReturnType is! DynamicType &&
        !_isIncompleteFunctionType(declaredReturnType)) {
      return CppTypeConverter.convertType(declaredReturnType);
    }

    // 否则，从函数体推断返回类型
    final body = expr.function.body;
    if (body == null) {
      return CppTypeConverter.convertType(declaredReturnType);
    }

    // 找到函数体中的 return 表达式
    final returnExpr = _findReturnExpression(body);
    if (returnExpr == null) {
      return CppTypeConverter.convertType(declaredReturnType);
    }

    // 如果返回的是另一个 FunctionExpression，递归推断其类型
    if (returnExpr is FunctionExpression) {
      return _buildLambdaTypeString(returnExpr);
    }

    // 对于其他表达式，使用声明的返回类型或推断类型
    return CppTypeConverter.convertType(declaredReturnType);
  }

  /// 检查 FunctionType 是否不完整（返回类型是 dynamic）
  bool _isIncompleteFunctionType(DartType type) {
    if (type is FunctionType) {
      // 如果函数类型的返回类型是 dynamic，认为是不完整的
      return type.returnType is DynamicType;
    }
    return false;
  }

  /// 从函数体中找到 return 表达式
  Expression? _findReturnExpression(Statement body) {
    if (body is ReturnStatement) {
      return body.expression;
    }
    if (body is Block && body.statements.isNotEmpty) {
      // 遍历 block 中的语句，找到 return 语句
      for (final stmt in body.statements) {
        if (stmt is ReturnStatement) {
          return stmt.expression;
        }
      }
    }
    if (body is ExpressionStatement) {
      // 对于箭头函数，body 可能直接是 ExpressionStatement
      return body.expression;
    }
    return null;
  }

  /// 构建 FunctionExpression 的完整类型字符串（用于嵌套 lambda）
  /// 返回格式：ObjectPtr<TypedFunction<ReturnType, Args...>>
  String _buildLambdaTypeString(FunctionExpression expr) {
    // 递归推断返回类型
    final returnType = _inferLambdaReturnType(expr);

    // 获取参数类型
    final paramTypes = expr.function.positionalParameters
        .map((p) => CppTypeConverter.convertType(p.type))
        .toList();

    // 构建 TypedFunction 类型
    if (paramTypes.isEmpty) {
      return 'ObjectPtr<TypedFunction<$returnType>>';
    } else {
      return 'ObjectPtr<TypedFunction<$returnType, ${paramTypes.join(', ')}>>';
    }
  }

  String _convertFunctionExpression(FunctionExpression expr) {
    // 收集闭包捕获的变量（详细信息）
    final capturedVarsInfo = _collectCapturedVariablesDetailed(expr);

    // 分离值类型和非值类型的捕获变量
    final valueTypeCapturedVars = capturedVarsInfo
        .where((info) => info.isValueType && info.name != 'this')
        .toList();
    final nonValueTypeCapturedVars = capturedVarsInfo
        .where((info) => !info.isValueType || info.name == 'this')
        .toList();

    // 生成参数列表
    final params = expr.function.positionalParameters
        .map((p) => '${CppTypeConverter.convertType(p.type)} ${p.name}')
        .join(', ');

    // 生成 lambda 函数体
    String body = 'return Void;';
    bool needsReturnVoid = false;

    if (expr.function.body != null) {
      // 在转换函数体之前，为值类型变量生成装箱代码
      String boxingCode = '';

      for (final varInfo in valueTypeCapturedVars) {
        final varName = varInfo.name;
        final varType = varInfo.type != null
            ? CppTypeConverter.convertType(varInfo.type!)
            : 'Int'; // 默认使用 Int

        // 判断是否是参数（简化判断：如果变量名不以_开头，则认为是普通变量）
        // 这里我们需要更好的方法来区分参数和局部变量
        // 暂时假设所有捕获的变量都是局部变量（需要后续扩展）

        // 生成 ValuePtr 装箱代码
        // 如果是已经装箱的变量，直接使用
        if (varInfo.declaration != null &&
            _boxedVarDeclarations.contains(varInfo.declaration)) {
          // 已经装箱，不需要重复装箱
          continue;
        }

        // 标记为装箱变量
        if (varInfo.declaration != null) {
          _boxedVarDeclarations.add(varInfo.declaration!);
        }

        // 注：这里的装箱代码需要在 lambda 内部生成
        // 因为我们需要在闭包内部访问装箱后的变量
        // 但装箱逻辑应该在外层函数中完成
        // 这里我们只做标记，实际装箱在 _convertVariableDeclaration 中处理
      }

      // 检查函数体类型，判断是否需要添加 return Void;
      final functionBody = expr.function.body!;
      final returnType = _inferLambdaReturnType(expr);

      // 如果返回类型是 Nullable，检查函数体是否需要添加返回语句
      if (returnType == 'Nullable') {
        if (functionBody is Block) {
          // Block 语句：检查最后一个语句是否是 ReturnStatement
          if (functionBody.statements.isEmpty ||
              functionBody.statements.last is! ReturnStatement) {
            needsReturnVoid = true;
          }
        } else if (functionBody is ExpressionStatement) {
          // ExpressionStatement：需要添加返回语句
          needsReturnVoid = true;
        } else {
          // 其他类型的语句体（如 EmptyStatement）也需要返回
          needsReturnVoid = true;
        }
      }

      body = transformer.statementConverter.convertStatement(functionBody);

      // 如果有装箱代码，添加到函数体前面
      if (boxingCode.isNotEmpty) {
        body = boxingCode + ' ' + body;
      }

      // 如果需要添加 return Void;
      if (needsReturnVoid) {
        body = body + ' return Void;';
      }
    }

    // 收集捕获变量（用于生成 Any 数组）
    // 过滤掉装箱变量：装箱变量将通过值捕获，不需要在捕获列表中传递
    final capturedVars = capturedVarsInfo
        .where((info) => !(info.declaration != null &&
            transformer._boxingVars.containsKey(info.declaration!)))
        .map((info) => info.name)
        .toList();

    // 生成捕获变量数组
    String capturedVarsArray = '';
    if (capturedVars.isNotEmpty) {
      final varList = capturedVars.map((v) => 'Any($v)').join(', ');
      capturedVarsArray = ', std::vector<Any>{$varList}';
    }

    // 生成捕获列表：
    // - 全局作用域使用空捕获 []（全局 Lambda 不能使用 [=]）
    // - 局部作用域使用值捕获 [=]，避免悬垂引用问题
    String captureList = isGlobalScope ? '[]' : '[=]';
    final boxedVarsInClosure = capturedVarsInfo
        .where((info) =>
            info.declaration != null &&
            transformer._boxingVars.containsKey(info.declaration!))
        .map((info) => info.name)
        .toList();

    // 使用 makeFunction 创建 Function 对象
    // 注意：装箱变量使用值捕获，需要mutable关键字才能修改
    final mutableKeyword = boxedVarsInClosure.isNotEmpty ? ' mutable' : '';

    // 获取返回类型 - 使用推断的返回类型而不是声明的返回类型
    final returnType = _inferLambdaReturnType(expr);

    // 获取参数类型列表（用于显式模板参数）
    final paramTypes = expr.function.positionalParameters
        .map((p) => CppTypeConverter.convertType(p.type))
        .toList();

    // 生成显式模板参数 makeFunction<R, Args...>
    final templateParams = [returnType, ...paramTypes].join(', ');

    // 生成 std::function 类型
    final stdFuncType = 'std::function<$returnType(${paramTypes.join(', ')})>';

    // 生成完整的 makeFunction 调用
    // 格式: makeFunction<R, Args...>(std::function<R(Args...)>(lambda), captured_vars)
    return 'makeFunction<$templateParams>($stdFuncType($captureList($params)$mutableKeyword -> $returnType { $body })$capturedVarsArray)';
  }

  String _convertLet(Let expr) {
    // 使用计数器生成唯一变量名，避免嵌套 lambda 中同名变量自引用
    // 例如：person?.address?.city 会生成嵌套 lambda，每层都需要不同的变量名
    final baseName = expr.variable.name ?? 'let_var';
    final varName = '${baseName}_${_letVarCounter++}';
    final value = convertExpression(expr.variable.initializer!);

    // 注册 Let 变量映射
    _letVariableMap[expr.variable] = varName;

    // 转换 body，此时 VariableGet 会使用映射的变量名
    final body = convertExpression(expr.body);

    // 清除映射
    _letVariableMap.remove(expr.variable);

    // 优化：检测空值合并模式 (value ?? default)
    // 如果 body 是三元表达式且形式为：dart_is_null(varName) ? default : varName
    // 则使用 dart_null_coalesce 宏
    // 注意：如果 body 包含嵌套 lambda（链式空安全访问），不做此优化，
    // 因为嵌套 lambda 返回类型可能与 Null 类型不匹配（如 ObjectPtr<T> vs Nullable）
    if (body.contains('dart_is_null($varName)') &&
        body.contains('? ') &&
        body.contains(' : $varName') &&
        !body.contains('([&]()')) {
      // 提取三元表达式的默认值部分
      final pattern = RegExp(r'dart_is_null\(' +
          RegExp.escape(varName) +
          r'\)\s*\?\s*(.+?)\s*:\s*' +
          RegExp.escape(varName));
      final match = pattern.firstMatch(body);
      if (match != null) {
        final defaultValue = match.group(1);
        // 使用 dart_null_coalesce 宏确保类型安全
        return 'dart_null_coalesce($value, $defaultValue)';
      }
    }

    // 默认：使用 auto 来自动推导类型，避免 Nullable 到具体类型的转换问题
    return '([&]() { auto $varName = $value; return $body; })()';
  }

  String _convertInstantiation(Instantiation expr) {
    final operand = convertExpression(expr.expression);
    final typeArgs = expr.typeArguments
        .map((t) => CppTypeConverter.convertType(t))
        .join(', ');
    return '$operand<$typeArgs>';
  }

  String _convertConstantExpression(ConstantExpression expr) {
    final constant = expr.constant;
    return _convertConstant(constant);
  }

  String _convertConstant(Constant constant) {
    if (constant is NullConstant) {
      return 'Null';
    } else if (constant is BoolConstant) {
      return CppTypeConverter.convertLiteral(constant.value);
    } else if (constant is IntConstant) {
      return CppTypeConverter.convertLiteral(constant.value);
    } else if (constant is DoubleConstant) {
      return CppTypeConverter.convertLiteral(constant.value);
    } else if (constant is StringConstant) {
      return CppTypeConverter.convertLiteral(constant.value);
    } else if (constant is ListConstant) {
      final elementType = CppTypeConverter.convertType(constant.typeArgument);
      final elements =
          constant.entries.map((c) => _convertConstant(c)).join(', ');
      return 'List<$elementType>::createConst({$elements})';
    } else if (constant is SetConstant) {
      final elementType = CppTypeConverter.convertType(constant.typeArgument);
      final elements =
          constant.entries.map((c) => _convertConstant(c)).join(', ');
      return 'Set<$elementType>::createConst({$elements})';
    } else if (constant is MapConstant) {
      final keyType = CppTypeConverter.convertType(constant.keyType);
      final valueType = CppTypeConverter.convertType(constant.valueType);
      if (constant.entries.isEmpty) {
        return 'Map<$keyType, $valueType>::createConst()';
      }
      // 生成带初始化的 const Map，使用 std::pair 格式
      final entries = constant.entries.map((entry) {
        final key = _convertConstant(entry.key);
        final value = _convertConstant(entry.value);
        return '{$key, $value}';
      }).join(', ');
      return 'Map<$keyType, $valueType>::createConst({$entries})';
    } else if (constant is InstanceConstant) {
      final originalClassName = constant.classNode.name;
      // 清理类名中的特殊字符（如混入类 _Bird&Object&Flyable）
      final className = _sanitizeIdentifier(originalClassName);

      // 只有 List/Set/Map 支持 createConst，其他类型使用普通构造函数
      // 对于枚举类型和其他自定义类型，使用默认构造函数
      if (className == 'List' || className == 'Set' || className == 'Map') {
        return 'ObjectPtr<$className>::createConst()';
      } else {
        // 尝试从 InstanceConstant 的字段值中提取构造参数
        // InstanceConstant.fieldValues 是 Map<Reference, Constant>，按字段声明顺序排列
        // 需要按照类的主构造函数参数顺序来传递字段值
        final classNode = constant.classNode;
        final primaryConstructors =
            classNode.constructors.where((c) => c.name.text.isEmpty).toList();

        if (primaryConstructors.isNotEmpty && constant.fieldValues.isNotEmpty) {
          final primaryCtor = primaryConstructors.first;
          final primaryParams = primaryCtor.function.positionalParameters;

          // 构建字段名 -> 常量值的映射
          final fieldConstantMap = <String, Constant>{};
          for (final entry in constant.fieldValues.entries) {
            final fieldName = entry.key.asField.name.text;
            fieldConstantMap[fieldName] = entry.value;
          }

          // 按主构造函数参数顺序提取字段值
          final constructorArgs = <String>[];
          for (final param in primaryParams) {
            final paramName = param.name ?? '';
            if (fieldConstantMap.containsKey(paramName)) {
              constructorArgs
                  .add(_convertConstant(fieldConstantMap[paramName]!));
            } else {
              // 没有对应字段值，使用类型默认值
              final paramType = CppTypeConverter.convertType(param.type);
              if (paramType.contains('ObjectPtr<') || paramType == 'Nullable') {
                constructorArgs.add('Null');
              } else if (paramType == 'Int') {
                constructorArgs.add('dart_int(0)');
              } else if (paramType == 'Double') {
                constructorArgs.add('dart_double(0.0)');
              } else if (paramType == 'Bool') {
                constructorArgs.add('dart_bool(false)');
              } else if (paramType == 'String') {
                constructorArgs.add('dart_string("")');
              } else {
                constructorArgs.add('{}');
              }
            }
          }

          if (constructorArgs.isNotEmpty) {
            return 'ObjectPtr<$className>(new $className(${constructorArgs.join(', ')}))';
          }
        }

        // 回退：使用默认构造函数
        return 'ObjectPtr<$className>(new $className())';
      }
    } else if (constant is StaticTearOffConstant) {
      // 处理函数引用：使用 makeFunction 包装函数指针
      final target = constant.target;
      final functionName = target.name.text;

      // 获取函数签名信息
      final functionNode = target.function;
      final returnType = CppTypeConverter.convertType(functionNode.returnType);
      final paramTypes = functionNode.positionalParameters
          .map((p) => CppTypeConverter.convertType(p.type))
          .toList();

      // 生成显式模板参数 makeFunction<R, Args...>
      final templateParams = [returnType, ...paramTypes].join(', ');

      // 生成 std::function 类型
      final stdFuncType =
          'std::function<$returnType(${paramTypes.join(', ')})>';

      // 显式指定类型参数
      return 'makeFunction<$templateParams>($stdFuncType(&$functionName))';
    }
    return '/* Constant: ${constant.runtimeType} */';
  }

  String _convertBlockExpression(BlockExpression expr) {
    // BlockExpression 包含一个语句块和一个值表达式
    // 使用立即调用的 lambda 来实现
    final statements = expr.body.statements
        .map((s) => transformer.statementConverter.convertStatement(s))
        .where((s) => s.isNotEmpty)
        .join(' ');
    final value = convertExpression(expr.value);

    if (statements.isEmpty) {
      return value;
    }

    return '([&]() { $statements return $value; })()';
  }

  String _convertArguments(Arguments args, [FunctionNode? targetFunction]) {
    final positional =
        args.positional.map((a) => convertExpression(a)).toList();

    // 如果有目标函数信息，进行参数补全和重排
    if (targetFunction != null) {
      return _convertArgumentsWithFunction(args, targetFunction);
    }

    // 原有逻辑：命名参数直接添加注释
    final named = args.named
        .map((a) => '/*${a.name}:*/ ${convertExpression(a.value)}')
        .toList();
    return [...positional, ...named].join(', ');
  }

  String _convertArgumentsWithFunction(
      Arguments args, FunctionNode targetFunction) {
    final result = <String>[];

    // 1. 处理位置参数
    final totalPositional = targetFunction.positionalParameters.length;
    final requiredCount = targetFunction.requiredParameterCount;

    for (int i = 0; i < totalPositional; i++) {
      if (i < args.positional.length) {
        // 有提供的位置参数
        result.add(convertExpression(args.positional[i]));
      } else if (i >= requiredCount) {
        // 可选位置参数，优先使用默认值
        final param = targetFunction.positionalParameters[i];
        if (param.initializer != null) {
          result.add(convertExpression(param.initializer!));
        } else {
          final paramType = CppTypeConverter.convertType(param.type);
          if (paramType.startsWith('ObjectPtr<')) {
            result.add('Null');
          } else {
            result.add('$paramType(Null)');
          }
        }
      }
    }

    // 2. 处理命名参数 - 修复#14: 按函数定义顺序，使用默认值
    final namedArgsMap = <String, String>{};
    for (final namedArg in args.named) {
      namedArgsMap[namedArg.name] = convertExpression(namedArg.value);
    }

    for (final namedParam in targetFunction.namedParameters) {
      final paramName = namedParam.name ?? 'param';
      final paramType = CppTypeConverter.convertType(namedParam.type);

      if (namedArgsMap.containsKey(paramName)) {
        // 有提供的命名参数
        result.add(namedArgsMap[paramName]!);
      } else {
        // 未提供的命名参数，使用默认值
        if (namedParam.initializer != null) {
          // 使用参数的默认值
          result.add(convertExpression(namedParam.initializer!));
        } else {
          // 没有默认值，使用类型默认值
          if (paramType.startsWith('ObjectPtr<')) {
            result.add('Null');
          } else if (paramType == 'Int') {
            result.add('Int(0)');
          } else if (paramType == 'Double') {
            result.add('Double(0.0)');
          } else if (paramType == 'Bool') {
            result.add('Bool(false)');
          } else if (paramType == 'String') {
            result.add('String("")');
          } else {
            result.add('$paramType(Null)');
          }
        }
      }
    }

    return result.join(', ');
  }
}

/// 语句转换器
class CppStatementConverter {
  final DartToCppTransformer transformer;

  CppStatementConverter(this.transformer);

  String convertStatement(Statement stmt) {
    if (stmt is ExpressionStatement) {
      final exprCode =
          transformer.expressionConverter.convertExpression(stmt.expression);

      // 特殊处理：检测空值合并赋值运算符 ??= 的模式
      // 形式为: dart_is_null(var) ? var = value : Null
      // 转换为: if (dart_is_null(var)) var = value;
      final nullAssignPattern =
          RegExp(r'dart_is_null\((\w+)\)\s*\?\s*\1\s*=\s*(.+?)\s*:\s*Null');
      final match = nullAssignPattern.firstMatch(exprCode);
      if (match != null) {
        final varName = match.group(1);
        final value = match.group(2);
        return 'if (dart_is_null($varName)) $varName = $value;';
      }

      return exprCode + ';';
    } else if (stmt is VariableDeclaration) {
      return _convertVariableDeclaration(stmt);
    } else if (stmt is Block) {
      return _convertBlock(stmt);
    } else if (stmt is IfStatement) {
      return _convertIfStatement(stmt);
    } else if (stmt is ForStatement) {
      return _convertForStatement(stmt);
    } else if (stmt.runtimeType.toString() == 'ForInStatement') {
      return _convertForInStatement(stmt as dynamic);
    } else if (stmt is WhileStatement) {
      return _convertWhileStatement(stmt);
    } else if (stmt is ReturnStatement) {
      return _convertReturnStatement(stmt);
    } else if (stmt is BreakStatement) {
      return 'break;';
    } else if (stmt.runtimeType.toString() == 'ContinueStatement') {
      return 'continue;';
    } else if (stmt.runtimeType.toString().contains('Try')) {
      return _convertTryStatement(stmt as dynamic);
    } else if (stmt is EmptyStatement) {
      return ''; // 空语句 - 不生成任何代码
    } else if (stmt is LabeledStatement) {
      return _convertLabeledStatement(stmt);
    } else if (stmt is AssertStatement) {
      return _convertAssertStatement(stmt);
    } else if (stmt is FunctionDeclaration) {
      return _convertFunctionDeclaration(stmt);
    } else if (stmt is YieldStatement) {
      return _convertYieldStatement(stmt);
    } else if (stmt is DoStatement) {
      return _convertDoStatement(stmt);
    } else if (stmt is SwitchStatement) {
      return _convertSwitchStatement(stmt);
    }

    return '/* TODO: ${stmt.runtimeType} */;';
  }

  String _convertVariableDeclaration(VariableDeclaration decl) {
    String name = decl.name ?? 'unnamed_var';
    final originalName = name; // 保存原始变量名用于特殊处理

    // 使用统一的标识符清理函数
    name = _sanitizeIdentifier(name);
    // 为变量添加前缀以避免关键字冲突
    if (name == 'unnamed') {
      name = 'var_$name';
    }

    // 特殊处理 :sync-for-iterator 变量：为每个实例分配唯一索引
    if (originalName == ':sync-for-iterator') {
      transformer._syncForIteratorIndex++;
      transformer._syncForIteratorMap[decl] = transformer._syncForIteratorIndex;
      name = '${name}_${transformer._syncForIteratorIndex}';
    }

    final type = CppTypeConverter.convertType(decl.type);
    final isLate = decl.isLate;

    if (decl.initializer != null) {
      final init =
          transformer.expressionConverter.convertExpression(decl.initializer!);

      // late 变量处理
      if (isLate) {
        if (decl.isFinal) {
          return 'mutable std::optional<$type> ${name}_storage; '
              'const auto& $name = [&]() -> const $type& { '
              'if (!${name}_storage.has_value()) ${name}_storage = $init; '
              'return ${name}_storage.value(); }();';
        } else {
          return 'std::optional<$type> ${name}_storage; '
              'auto $name = [&]() -> $type& { '
              'if (!${name}_storage.has_value()) ${name}_storage = $init; '
              'return ${name}_storage.value(); }();';
        }
      }

      // 特殊处理dynamic类型变量
      if (decl.type is DynamicType) {
        // 对于dynamic类型变量，声明为Any类型以支持多种类型赋值
        if (decl.isFinal) {
          return 'const Any $name = $init;';
        } else {
          return 'Any $name = $init;';
        }
      }

      // 装箱处理：检查是否需要装箱（被闭包捕获的值类型局部变量）
      final needsBoxing = transformer._boxingVars.containsKey(decl) &&
          !transformer._boxingVars[decl]!.isParameter;

      if (needsBoxing) {
        final boxingInfo = transformer._boxingVars[decl]!;
        final varType = CppTypeConverter.convertType(boxingInfo.varType);

        if (decl.isFinal) {
          return 'const ObjectPtr<_ValueBox<$varType>> $name(new _ValueBox<$varType>($init));';
        } else {
          return 'ObjectPtr<_ValueBox<$varType>> $name(new _ValueBox<$varType>($init));';
        }
      }

      // 检查是否使用auto
      if (decl.isFinal) {
        return 'const auto $name = $init;';
      } else {
        return 'auto $name = $init;';
      }
    } else {
      // late 变量没有初始化器
      if (isLate) {
        if (decl.isFinal) {
          return 'mutable std::optional<$type> ${name}_storage; '
              'const auto& $name = [&]() -> const $type& { '
              'if (!${name}_storage.has_value()) throw std::runtime_error("Late variable \'$name\' not initialized"); '
              'return ${name}_storage.value(); }();';
        } else {
          return 'std::optional<$type> ${name}_storage; '
              'auto& $name = [&]() -> $type& { '
              'if (!${name}_storage.has_value()) throw std::runtime_error("Late variable \'$name\' not initialized"); '
              'return ${name}_storage.value(); }();';
        }
      }

      // 对于可空类型，使用具体类型并显式调用Null构造函数
      // 例如 int? -> Int nullableInt(Null)
      if (decl.type.nullability.toString().contains('nullable')) {
        // 获取非空版本的类型
        final nonNullType = CppTypeConverter.convertType(
            decl.type.withDeclaredNullability(Nullability.nonNullable));

        // 基本类型的可空版本仍然是基本类型，不使用ObjectPtr包装
        if (_isBasicType(nonNullType)) {
          return '$nonNullType $name(Null);';
        } else if (nonNullType.startsWith('ObjectPtr<')) {
          // 已经是 ObjectPtr 类型（如 List、Map、Set 等），直接使用，不再包装
          return '$nonNullType $name(Null);';
        } else {
          // 只有非基本类型才使用ObjectPtr包装
          return 'ObjectPtr<$nonNullType> $name(Null);';
        }
      }
      // 其他非可空类型，使用默认构造
      return '$type $name;';
    }
  }

  String _convertBlock(Block stmt) {
    final statements = stmt.statements
        .map((s) => convertStatement(s))
        .where((s) => s.isNotEmpty)
        .join('\n');
    return statements;
  }

  /// 存储类型提升信息：变量名 -> 提升后的类型
  final Map<String, String> _typePromotions = {};

  String _convertIfStatement(IfStatement stmt) {
    // 保存当前的类型提升状态
    final savedPromotions = Map<String, String>.from(_typePromotions);

    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);

    // 分析条件中是否有is表达式，并进行类型提升
    _analyzeTypePromotion(stmt.condition, isNegated: false);

    // 在then分支中应用类型提升
    final thenStmt = _convertStatementWithPromotions(() {
      return convertStatement(stmt.then);
    });

    String result = 'if ($condition) {\n$thenStmt\n}';

    if (stmt.otherwise != null) {
      // 恢复到条件前的状态
      _typePromotions.clear();
      _typePromotions.addAll(savedPromotions);

      // 对于else分支，如果条件是is表达式，则else中类型是反向的
      _analyzeTypePromotion(stmt.condition, isNegated: true);

      final elseStmt = _convertStatementWithPromotions(() {
        return convertStatement(stmt.otherwise!);
      });
      result += ' else {\n$elseStmt\n}';
    }

    // 恢复原来的类型提升状态
    _typePromotions.clear();
    _typePromotions.addAll(savedPromotions);

    return result;
  }

  /// 分析表达式中的类型提升
  void _analyzeTypePromotion(Expression condition, {required bool isNegated}) {
    if (condition is IsExpression) {
      // 获取被检查的变量
      if (condition.operand is VariableGet) {
        final varGet = condition.operand as VariableGet;
        final varName = _sanitizeIdentifier(varGet.variable.name ?? 'unnamed');

        // 只在非取反情况下进行类型提升
        if (!isNegated) {
          final promotedType = CppTypeConverter.convertType(condition.type);
          _typePromotions[varName] = promotedType;
        }
      }
    } else if (condition is Not) {
      // 处理取反的is表达式
      _analyzeTypePromotion(condition.operand, isNegated: !isNegated);
    } else if (condition is LogicalExpression) {
      // 处理逻辑运算符
      if (condition.operatorEnum == LogicalExpressionOperator.AND) {
        // a is String && b is int
        _analyzeTypePromotion(condition.left, isNegated: isNegated);
        _analyzeTypePromotion(condition.right, isNegated: isNegated);
      }
      // OR运算符不进行类型提升
    }
  }

  /// 在类型提升上下文中执行语句转换
  String _convertStatementWithPromotions(String Function() converter) {
    if (_typePromotions.isEmpty) {
      return converter();
    }

    // 生成类型转换代码
    final promotionCode = StringBuffer();
    for (final entry in _typePromotions.entries) {
      final varName = entry.key;
      final promotedType = entry.value;

      // 生成类型转换：auto promoted_var = dart_cast<Type>(var);
      promotionCode.writeln(
          'auto ${varName}_promoted = dart_cast<$promotedType>($varName);');
    }

    // 修改转换器以使用promoted变量
    // 这里需要临时替换变量名称
    final originalConverter = transformer.expressionConverter;

    // 创建一个临时的变量名映射
    final tempVarMapping = <String, String>{};
    for (final varName in _typePromotions.keys) {
      tempVarMapping[varName] = '${varName}_promoted';
    }

    // 注入变量映射到转换器
    final oldMapping =
        Map<String, String>.from(originalConverter._promotedVarMapping);
    originalConverter._promotedVarMapping.addAll(tempVarMapping);

    final result = converter();

    // 恢复原有映射
    originalConverter._promotedVarMapping.clear();
    originalConverter._promotedVarMapping.addAll(oldMapping);

    return promotionCode.toString() + result;
  }

  String _convertForStatement(ForStatement stmt) {
    // For loop variables should not include the full declaration syntax
    final variables = stmt.variables.map((v) {
      final name = v.name ?? 'unnamed_var';
      if (v.initializer != null) {
        final init =
            transformer.expressionConverter.convertExpression(v.initializer!);
        return 'auto $name = $init';
      } else {
        final type = CppTypeConverter.convertType(v.type);
        return '$type $name';
      }
    }).join(', ');

    // 修复：for 循环的条件和更新表达式中，循环变量不应该被解引用
    // 临时保存并移除 for 循环变量的装箱信息
    final Map<VariableDeclaration, BoxingVarInfo> savedBoxingVars = {};
    for (final v in stmt.variables) {
      if (transformer._boxingVars.containsKey(v)) {
        savedBoxingVars[v] = transformer._boxingVars[v]!;
        transformer._boxingVars.remove(v);
      }
    }

    // 转换条件和更新表达式（此时循环变量不会被解引用）
    final condition = stmt.condition != null
        ? transformer.expressionConverter.convertExpression(stmt.condition!)
        : 'true';

    // 优化 increment 表达式处理
    final updates = stmt.updates.map((u) {
      final updateExpr = transformer.expressionConverter.convertExpression(u);
      // 如果是简单的赋值表达式，尝试转换为 ++ 或 -- 操作符
      if (updateExpr.contains(' = ') && updateExpr.contains(' + dart_int(1)')) {
        final varName = updateExpr.split(' = ')[0];
        return '++$varName';
      } else if (updateExpr.contains(' = ') &&
          updateExpr.contains(' - dart_int(1)')) {
        final varName = updateExpr.split(' = ')[0];
        return '--$varName';
      }
      return updateExpr;
    }).join(', ');

    // 恢复装箱信息（在循环体内，闭包捕获时需要）
    transformer._boxingVars.addAll(savedBoxingVars);

    final body = convertStatement(stmt.body);

    // DEBUG: 检查变量名
    print('DEBUG: ForStatement variables = [$variables]');

    // 检测 for-in 脱糖后的模式：包含 iterator 变量名或者调用 ->iterator()
    // 需要外层加 {} 防止多个 for-in 循环的迭代器变量命名冲突
    final bool isForInDesugared = variables.contains('sync_for_iterator') ||
        variables.contains('sync-for-iterator') ||
        variables.contains('->iterator()');

    if (isForInDesugared) {
      return '{\n$variables;\nfor (; $condition; $updates) {\n$body\n}\n}';
    }

    return 'for ($variables; $condition; $updates) {\n$body\n}';
  }

  String _convertForInStatement(dynamic stmt) {
    // 获取循环变量名
    final variable = stmt.variable;
    String varName = variable.name ?? 'item';

    // 使用统一的标识符清理函数
    varName = _sanitizeIdentifier(varName);
    if (varName == 'unnamed') {
      varName = 'var_$varName';
    }

    final varType = CppTypeConverter.convertType(variable.type);

    // 获取可迭代对象
    final iterable =
        transformer.expressionConverter.convertExpression(stmt.iterable);

    // 生成迭代器变量名（使用合法的C++标识符）
    final iteratorVarName = 'sync_for_iterator';

    // 转换循环体
    final body = convertStatement(stmt.body);

    // 生成正确的C++ for-in循环代码，使用 hasNext() 和 next() 方法
    // 外层加 {} 防止多个 for-in 循环的 sync_for_iterator 命名冲突
    return '{ /* FOR_IN_SCOPE */\nauto $iteratorVarName = $iterable->iterator();\nfor (; $iteratorVarName->hasNext(); ) {\nauto $varName = $iteratorVarName->next();\n$body\n}\n}';
  }

  String _convertWhileStatement(WhileStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    final body = convertStatement(stmt.body);
    return 'while ($condition) {\n$body\n}';
  }

  String _convertReturnStatement(ReturnStatement stmt) {
    if (stmt.expression != null) {
      var expr =
          transformer.expressionConverter.convertExpression(stmt.expression!);

      // 特殊处理 return this 的情况
      if (expr == 'this') {
        // 检查当前方法的返回类型，如果是ObjectPtr类型，则需要包装
        // 使用std::remove_reference移除引用类型
        expr = 'ObjectPtr<std::remove_reference_t<decltype(*this)>>(this)';
      }

      // 特殊处理：如果return的是装箱变量，需要显式解包
      // 检查是否是VariableGet表达式
      if (stmt.expression is VariableGet) {
        final varGet = stmt.expression as VariableGet;
        // 检查该变量是否被装箱
        if (transformer._boxingVars.containsKey(varGet.variable)) {
          // 显式解包：使用 * 运算符
          expr = '(*$expr)';
        }
      }

      // FunctionExpression 返回处理：
      // - 如果当前函数返回类型是完整的 FunctionType（不包含 dynamic），使用 makeStdFunction
      // - 如果返回类型包含 dynamic，使用 makeFunction（返回 ObjectPtr<Function>）
      if (stmt.expression is FunctionExpression) {
        final currentReturnType = transformer._currentProcedureReturnType;
        // 检查是否应该使用 makeStdFunction：
        // 1. 当前函数有返回类型
        // 2. 返回类型是 FunctionType
        // 3. 返回类型不包含 dynamic/Any
        final bool shouldUseMakeStdFunction = currentReturnType != null &&
            currentReturnType is FunctionType &&
            !CppTypeConverter.functionTypeReturnContainsAny(currentReturnType);

        if (shouldUseMakeStdFunction) {
          // 使用 makeStdFunction 生成 std::function 版本，与声明的返回类型匹配
          expr = expr.replaceFirst('makeFunction(', 'makeStdFunction(');
        }
        // 否则保持 makeFunction，返回 ObjectPtr<Function>
      }

      // 处理返回类型为 Object/ObjectPtr<Object> 时，值类型需要用 Any 包装
      // 因为 Int、String、List 等不能自动转换为 ObjectPtr<Object>
      final currentReturnType = transformer._currentProcedureReturnType;
      if (currentReturnType != null) {
        final returnTypeName = CppTypeConverter.convertType(currentReturnType);
        if (returnTypeName == 'ObjectPtr<Object>' ||
            returnTypeName == 'Object') {
          // 检查表达式是否是值类型（Int、String、Bool、Double、List等）
          // 这些类型需要用 Any 包装
          if (_isValueTypeExpression(expr)) {
            expr = 'Any($expr)';
          }
        }
      }

      return 'return $expr;';
    } else {
      return 'return Void;';
    }
  }

  /// 检查表达式是否是需要用 Any 包装的值类型
  bool _isValueTypeExpression(String expr) {
    // 检查是否是 dart_string, dart_int, dart_double, dart_bool, dart_literal 等
    if (expr.startsWith('dart_string(') ||
        expr.startsWith('dart_int(') ||
        expr.startsWith('dart_double(') ||
        expr.startsWith('dart_bool(') ||
        expr.startsWith('dart_literal<') ||
        expr.startsWith('String(') ||
        expr.startsWith('Int(') ||
        expr.startsWith('Double(') ||
        expr.startsWith('Bool(')) {
      return true;
    }
    return false;
  }

  String _convertTryStatement(dynamic stmt) {
    try {
      final tryBody = convertStatement(stmt.body);
      String result = 'try {\n$tryBody\n}';

      // 简化的 catch 处理
      if (stmt.catches != null) {
        for (final _ in stmt.catches) {
          result += ' catch (const std::exception& e) { /* catch block */ }';
        }
      }

      // 简化的 finally 处理
      result += '\n// Finally block should be implemented using RAII pattern';

      return result;
    } catch (e) {
      return 'try { /* try block */ } catch (const std::exception& e) { /* catch block */ }';
    }
  }

  String _convertLabeledStatement(LabeledStatement stmt) {
    // LabeledStatement 在 Dart 中用于 break/continue 的目标
    // 在 C++ 中，对于简单的循环，我们直接转换循环体，不生成标签
    // 因为 C++ 的 break/continue 默认作用于最近的循环
    final body = convertStatement(stmt.body);
    return body;
  }

  String _convertAssertStatement(AssertStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    if (stmt.message != null) {
      final message =
          transformer.expressionConverter.convertExpression(stmt.message!);
      return 'assert(($condition).toBool() && "$message");';
    }
    return 'assert(($condition).toBool());';
  }

  String _convertFunctionDeclaration(FunctionDeclaration stmt) {
    String name = stmt.variable.name ?? 'anonymous';

    // 使用统一的标识符清理函数
    name = _sanitizeIdentifier(name);
    if (name == 'unnamed') {
      name = 'func_$name';
    }

    // 阶段1：预扫描函数，识别需要装箱的变量
    transformer._prescanFunction(stmt.function);

    // 构建参数列表，处理装箱参数（加_前缀）
    final params = stmt.function.positionalParameters.map((p) {
      final type = CppTypeConverter.convertType(p.type);
      var paramName = _sanitizeIdentifier(p.name ?? 'param');

      // 检查参数是否需要装箱（被闭包捕获的值类型参数）
      if (transformer._boxingVars.containsKey(p) &&
          transformer._boxingVars[p]!.isParameter) {
        // 参数加_前缀
        paramName = '_$paramName';
      }

      return '$type $paramName';
    }).join(', ');

    String body = '{ }';
    if (stmt.function.body != null) {
      final isVoidFunction =
          CppTypeConverter.convertType(stmt.function.returnType) == 'Nullable';

      // 生成参数装箱代码
      final boxingCode =
          transformer._generateParameterBoxingCode(stmt.function);

      // 转换函数体
      var bodyContent = transformer._transformFunctionBody(stmt.function.body!,
          isVoidFunction: isVoidFunction);

      // 如果有装箱代码，插入到函数体开始处
      if (boxingCode.isNotEmpty) {
        // 移除函数体的开始和结束大括号
        final trimmedBody = bodyContent.trim();
        if (trimmedBody.startsWith('{') && trimmedBody.endsWith('}')) {
          final innerBody =
              trimmedBody.substring(1, trimmedBody.length - 1).trim();
          body = '{ $boxingCode\n$innerBody }';
        } else {
          body = '{ $boxingCode\n$bodyContent }';
        }
      } else {
        // 确保函数体总是用 {} 包裹
        final trimmedBody = bodyContent.trim();
        if (trimmedBody.startsWith('{') && trimmedBody.endsWith('}')) {
          body = bodyContent;
        } else {
          // 函数体不是 block，需要添加 {}
          body = '{ $bodyContent }';
        }
      }
    }

    // 清空当前函数的装箱参数信息
    transformer._currentFunctionBoxedParams.clear();

    // 使用 auto 让编译器自动推导返回类型，避免类型不匹配问题
    return 'auto $name = [&]($params) $body;';
  }

  String _convertYieldStatement(YieldStatement stmt) {
    final value =
        transformer.expressionConverter.convertExpression(stmt.expression);
    // C++20 coroutines are not supported in C++17, skip yield statements
    return '// yield $value;  // C++20 coroutine not supported in C++17';
  }

  String _convertDoStatement(DoStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    final body = convertStatement(stmt.body);
    return 'do {\n$body\n} while (($condition).toBool());';
  }

  String _convertSwitchStatement(SwitchStatement stmt) {
    final expr =
        transformer.expressionConverter.convertExpression(stmt.expression);

    // 将所有 switch 语句都转换为 if-else if 链
    return _convertToIfElseChain(stmt, expr);
  }

  String _convertToIfElseChain(SwitchStatement stmt, String expr) {
    StringBuffer result = StringBuffer();
    bool isFirst = true;

    // 分组处理 case，将连续的没有 break 的 case 合并
    List<List<SwitchCase>> caseGroups = _groupSwitchCases(stmt.cases);

    for (final group in caseGroups) {
      if (group.length == 1 && group[0].isDefault) {
        // 处理 default case
        result.write('else {\n');
        final body = convertStatement(group[0].body);
        final cleanBody = _removeBreakStatements(body);
        result.write('  $cleanBody\n');
        result.write('}');
      } else {
        // 收集所有条件表达式
        List<String> allConditions = [];
        for (final case_ in group) {
          if (!case_.isDefault) {
            for (final caseExpr in case_.expressions) {
              final caseValue =
                  transformer.expressionConverter.convertExpression(caseExpr);
              allConditions.add('$expr == $caseValue');
            }
          }
        }

        if (allConditions.isNotEmpty) {
          // 生成 if 或 else if 条件
          if (isFirst) {
            result.write('if (${allConditions.join(' || ')}) {\n');
            isFirst = false;
          } else {
            result.write(' else if (${allConditions.join(' || ')}) {\n');
          }

          // 使用最后一个有实际代码的 case 的 body
          String body = '';
          for (int i = group.length - 1; i >= 0; i--) {
            final caseBody = convertStatement(group[i].body);
            if (caseBody.trim().isNotEmpty &&
                !caseBody.trim().startsWith('break')) {
              body = caseBody;
              break;
            }
          }

          final cleanBody = _removeBreakStatements(body);
          result.write('  $cleanBody\n');
          result.write('}');
        }
      }
    }

    return result.toString();
  }

  List<List<SwitchCase>> _groupSwitchCases(List<SwitchCase> cases) {
    List<List<SwitchCase>> groups = [];
    List<SwitchCase> currentGroup = [];

    for (int i = 0; i < cases.length; i++) {
      final case_ = cases[i];
      currentGroup.add(case_);

      // 更精确的 break 检测
      final body = convertStatement(case_.body);
      final hasBreak = _hasBreakOrReturn(body);
      final isLast = i == cases.length - 1;
      final isEmpty = _isEmptyCase(body);

      // 如果是空 case 且不是最后一个，继续合并到下一个 case
      if (isEmpty && !isLast) {
        continue;
      }

      // 如果有明确的 break/return 或者是最后一个 case 或者是 default case
      if (hasBreak || isLast || case_.isDefault) {
        groups.add(List.from(currentGroup));
        currentGroup.clear();
      }
    }

    if (currentGroup.isNotEmpty) {
      groups.add(currentGroup);
    }

    return groups;
  }

  /// 检查是否有 break 或 return 语句
  bool _hasBreakOrReturn(String body) {
    // 更精确的检测，避免误判注释或字符串中的 break
    final trimmedBody = body.trim();
    return trimmedBody.endsWith('break;') ||
        trimmedBody.endsWith('return;') ||
        trimmedBody.contains('return ') ||
        RegExp(r'\bbreak\s*;').hasMatch(trimmedBody) ||
        RegExp(r'\breturn\b').hasMatch(trimmedBody);
  }

  /// 检查是否是空的 case
  bool _isEmptyCase(String body) {
    final cleanBody = body
        .trim()
        .replaceAll(RegExp(r'//.*'), '') // 移除单行注释
        .replaceAll(RegExp(r'/\*.*?\*/'), '') // 移除多行注释
        .replaceAll(RegExp(r'\s+'), ''); // 移除空白字符
    return cleanBody.isEmpty || cleanBody == '{}';
  }

  String _removeBreakStatements(String body) {
    // 移除 break 语句，因为 if-else 不需要 break
    return body
        .replaceAll(RegExp(r'\s*break\s*;\s*'), '')
        .replaceAll(RegExp(r'\s*break\s*'), '');
  }

  bool _hasStringCaseValues(SwitchStatement stmt) {
    for (final case_ in stmt.cases) {
      for (final expr in case_.expressions) {
        if (expr is StringLiteral) {
          return true;
        }
      }
    }
    return false;
  }

  bool _hasStringCaseExpressions(SwitchStatement stmt) {
    for (final case_ in stmt.cases) {
      for (final expr in case_.expressions) {
        final convertedExpr =
            transformer.expressionConverter.convertExpression(expr);
        if (convertedExpr.contains('dart_string')) {
          return true;
        }
      }
    }
    return false;
  }

  String _convertStringSwitch(SwitchStatement stmt, String expr) {
    StringBuffer result = StringBuffer();
    bool isFirst = true;

    for (final case_ in stmt.cases) {
      if (case_.isDefault) {
        // 处理 default case
        result.write('else {\n');
        final body = convertStatement(case_.body);
        result.write('  $body\n');
        result.write('}');
      } else {
        // 处理普通 case
        for (int i = 0; i < case_.expressions.length; i++) {
          final caseValue = transformer.expressionConverter
              .convertExpression(case_.expressions[i]);

          if (isFirst) {
            result.write('if ($expr == $caseValue) {\n');
            isFirst = false;
          } else {
            result.write(' else if ($expr == $caseValue) {\n');
          }

          final body = convertStatement(case_.body);
          result.write('  $body\n');
          result.write('}');

          // 如果一个 case 有多个表达式，只处理第一个，其他的用 || 连接
          if (i == 0 && case_.expressions.length > 1) {
            // 重新构建条件，包含所有表达式
            List<String> conditions = case_.expressions
                .map((e) =>
                    '$expr == ${transformer.expressionConverter.convertExpression(e)}')
                .toList();

            result.clear();
            if (isFirst) {
              result.write('if (${conditions.join(' || ')}) {\n');
              isFirst = false;
            } else {
              result.write(' else if (${conditions.join(' || ')}) {\n');
            }
            final body = convertStatement(case_.body);
            result.write('  $body\n');
            result.write('}');
            break; // 跳出内层循环
          }
        }
      }
    }

    return result.toString();
  }

  /// 检查是否是基本类型 - 使用全局统一定义
  bool _isBasicType(String className) {
    return TypeAnalyzer.isBasicType(className);
  }
}

/// 主要的 Dart 到 C++ 转换器
class DartToCppTransformer {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  late final ExpressionConverter expressionConverter;
  late final CppStatementConverter statementConverter;
  late final TypeAnalyzer typeAnalyzer;

  // 存储头文件内容的缓冲区
  final StringBuffer _headerBuffer = StringBuffer();
  final Set<String> _forwardDeclarations = <String>{};
  final Set<String> _includedHeaders = <String>{};

  // 扩展方法注册表：目标类型 -> 扩展方法映射
  final Map<String, Map<String, String>> _extensionMethods = {};

  // 装箱变量管理：存储需要装箱的变量信息
  final Map<VariableDeclaration, BoxingVarInfo> _boxingVars = {};

  // sync-for-iterator 变量索引管理：用于区分多个 foreach 循环的迭代器变量
  int _syncForIteratorIndex = 0;
  final Map<VariableDeclaration, int> _syncForIteratorMap = {};

  // 当前函数的参数装箱信息（函数编译过程中使用）
  final Set<VariableDeclaration> _currentFunctionBoxedParams = {};

  // 当前函数的返回类型（用于 return 语句处理）
  DartType? _currentProcedureReturnType;

  // 当前正在转换的类（用于判断 this 表达式的类型）
  Class? _currentClass;

  // 存储当前转换的输入文件名
  String _currentInputFileName = '';

  /// 需要跳过的基础库前缀列表
  static const List<String> skipLibraryPrefixes = [
    'dart.',
    'dart:',
    'package:flutter',
    'package:meta',
    'package:collection',
    'package:async',
    'package:typed_data',
    'package:convert',
    'package:io',
    'package:isolate',
    'package:math',
    'package:mirrors',
    'package:developer',
    'package:ffi',
    'package:js',
    'package:html',
    'package:indexed_db',
    'package:svg',
    'package:web_audio',
    'package:web_gl',
    'package:web_sql',
  ];

  DartToCppTransformer() {
    statementConverter = CppStatementConverter(this);
    expressionConverter = ExpressionConverter(this, statementConverter);
  }

  /// 从函数体推断返回类型（用于不完整的 FunctionType 返回类型）
  /// 特别处理柯里化等嵌套 lambda 的情况
  String _inferProcedureReturnType(Procedure procedure) {
    final declaredReturnType = procedure.function.returnType;

    // 如果返回类型不是不完整的 FunctionType，直接使用声明的类型
    if (declaredReturnType is! FunctionType) {
      return CppTypeConverter.convertType(declaredReturnType);
    }

    // 检查 FunctionType 是否不完整（返回类型是 dynamic）
    final funcType = declaredReturnType;
    if (funcType.returnType is! DynamicType) {
      // 返回类型完整，直接使用
      return CppTypeConverter.convertType(declaredReturnType);
    }

    // 返回类型不完整，从函数体推断
    final body = procedure.function.body;
    if (body == null) {
      return 'ObjectPtr<Function>';
    }

    // 找到返回表达式
    final returnExpr = _findReturnExpression(body);
    if (returnExpr == null) {
      return 'ObjectPtr<Function>';
    }

    // 如果返回的是 FunctionExpression，推断其完整类型
    if (returnExpr is FunctionExpression) {
      return _buildFunctionExpressionType(returnExpr);
    }

    // 其他情况使用基类
    return 'ObjectPtr<Function>';
  }

  /// 从语句中找到返回表达式
  Expression? _findReturnExpression(Statement body) {
    if (body is ReturnStatement) {
      return body.expression;
    }
    if (body is Block && body.statements.isNotEmpty) {
      for (final stmt in body.statements) {
        if (stmt is ReturnStatement) {
          return stmt.expression;
        }
      }
    }
    return null;
  }

  /// 构建 FunctionExpression 的完整类型字符串
  /// 递归处理嵌套的 lambda
  String _buildFunctionExpressionType(FunctionExpression expr) {
    // 递归推断返回类型
    final returnType = _inferFunctionExpressionReturnType(expr);

    // 获取参数类型
    final paramTypes = expr.function.positionalParameters
        .map((p) => CppTypeConverter.convertType(p.type))
        .toList();

    // 构建 TypedFunction 类型
    if (paramTypes.isEmpty) {
      return 'ObjectPtr<TypedFunction<$returnType>>';
    } else {
      return 'ObjectPtr<TypedFunction<$returnType, ${paramTypes.join(', ')}>>';
    }
  }

  /// 推断 FunctionExpression 的返回类型
  String _inferFunctionExpressionReturnType(FunctionExpression expr) {
    final declaredReturnType = expr.function.returnType;

    // 如果声明的返回类型是完整的（非 dynamic），直接使用
    if (declaredReturnType is! DynamicType &&
        !(declaredReturnType is FunctionType &&
            declaredReturnType.returnType is DynamicType)) {
      return CppTypeConverter.convertType(declaredReturnType);
    }

    // 从函数体推断
    final body = expr.function.body;
    if (body == null) {
      return CppTypeConverter.convertType(declaredReturnType);
    }

    // 找到返回表达式
    Expression? returnExpr;
    if (body is ReturnStatement) {
      returnExpr = body.expression;
    } else if (body is Block && body.statements.isNotEmpty) {
      for (final stmt in body.statements) {
        if (stmt is ReturnStatement) {
          returnExpr = stmt.expression;
          break;
        }
      }
    }

    if (returnExpr == null) {
      return CppTypeConverter.convertType(declaredReturnType);
    }

    // 如果返回的是另一个 FunctionExpression，递归构建类型
    if (returnExpr is FunctionExpression) {
      return _buildFunctionExpressionType(returnExpr);
    }

    // 其他情况使用声明的返回类型
    return CppTypeConverter.convertType(declaredReturnType);
  }

  /// 生成头文件内容
  String generateHeaderContent(String inputFileName) {
    // 生成头文件保护宏
    String baseName = inputFileName.split('/').last.split('.').first;
    String headerGuard = '_${baseName.toUpperCase()}_H_';

    _headerBuffer.clear();
    _headerBuffer.writeln('#ifndef $headerGuard');
    _headerBuffer.writeln('#define $headerGuard');
    _headerBuffer.writeln();

    // 添加标准头文件
    for (final include in CppConstants.standardIncludes) {
      _headerBuffer.writeln(include);
    }
    _headerBuffer.writeln();

    // 添加工具宏定义
    _headerBuffer.writeln('// 工具宏定义');
    for (final macro in CppConstants.utilityMacros) {
      _headerBuffer.writeln(macro);
    }
    _headerBuffer.writeln();

    // 生成前向声明
    _generateForwardDeclarations();

    // 生成类定义
    // 注意：类定义在主转换方法中已经处理，这里我们只处理需要在头文件中的部分

    _headerBuffer.writeln();
    _headerBuffer.writeln('#endif // $headerGuard');

    return _headerBuffer.toString();
  }

  /// 生成前向声明
  void _generateForwardDeclarations() {
    if (_forwardDeclarations.isNotEmpty) {
      _headerBuffer.writeln('// 前向声明');
      for (final decl in _forwardDeclarations) {
        if (decl.startsWith('template<')) {
          // 处理模板声明
          _headerBuffer.writeln(decl);
        } else {
          _headerBuffer.writeln(decl);
        }
      }
      _headerBuffer.writeln();
    }
  }

  /// 添加前向声明
  void addForwardDeclaration(String declaration) {
    // 对声明进行后处理，修复扩展方法语法和非法标识符
    String processedDeclaration = declaration;

    // 修复扩展方法命名空间语法：Extension| -> Extension::
    processedDeclaration = processedDeclaration.replaceAllMapped(
        RegExp(r'(\w+Extensions?)\|'), (match) => '${match.group(1)}::');

    // 修复非法的C++标识符：# -> _（但保留 #include 等预处理指令）
    processedDeclaration = processedDeclaration.replaceAllMapped(
        RegExp(r'(?<!^)(?<!\n)#(\w+)'), // 匹配不在行首的 #标识符
        (match) => '_${match.group(1)}');

    _forwardDeclarations.add(processedDeclaration);
  }

  /// 阶段1：预扫描函数，识别需要装箱的变量
  void _prescanFunction(FunctionNode function) {
    // 清空当前函数的装箱参数信息
    _currentFunctionBoxedParams.clear();

    if (function.body == null) return;

    // 收集函数中所有的闭包
    final closures = <FunctionExpression>[];
    _collectClosures(function.body!, closures);

    if (closures.isEmpty) return;

    // 收集函数的所有参数
    final functionParams = function.positionalParameters.toSet()
      ..addAll(function.namedParameters);

    // 收集函数中所有的 for 循环变量（不应该被装箱）
    final forLoopVars = <VariableDeclaration>{};
    _collectForLoopVars(function.body!, forLoopVars);

    // 对每个闭包，分析其捕获的变量
    for (final closure in closures) {
      final capturedVars = _analyzeCapturedVars(closure, functionParams);

      // 对每个被捕获的值类型变量，添加到装箱列表
      for (final varDecl in capturedVars) {
        // 排除 for 循环变量：它们不应该被装箱
        if (forLoopVars.contains(varDecl)) {
          continue;
        }

        if (_isValueType(varDecl.type)) {
          final varName = _sanitizeIdentifier(varDecl.name ?? 'var');
          final isParam = functionParams.contains(varDecl);

          // 创建装箱信息
          final boxingInfo = BoxingVarInfo(
            variable: varDecl,
            varName: varName,
            varType: varDecl.type,
            isParameter: isParam,
            declarationOffset: varDecl.fileOffset,
          );

          _boxingVars[varDecl] = boxingInfo;

          if (isParam) {
            _currentFunctionBoxedParams.add(varDecl);
          }
        }
      }
    }
  }

  /// 收集函数中所有的 for 循环变量
  void _collectForLoopVars(
      Statement stmt, Set<VariableDeclaration> forLoopVars) {
    if (stmt is Block) {
      for (final s in stmt.statements) {
        _collectForLoopVars(s, forLoopVars);
      }
    } else if (stmt is ForStatement) {
      // 添加 for 循环的所有变量
      forLoopVars.addAll(stmt.variables);
      // 递归处理循环体
      _collectForLoopVars(stmt.body, forLoopVars);
    } else if (stmt is IfStatement) {
      _collectForLoopVars(stmt.then, forLoopVars);
      if (stmt.otherwise != null) {
        _collectForLoopVars(stmt.otherwise!, forLoopVars);
      }
    } else if (stmt is WhileStatement) {
      _collectForLoopVars(stmt.body, forLoopVars);
    } else if (stmt is DoStatement) {
      _collectForLoopVars(stmt.body, forLoopVars);
    }
  }

  /// 收集语句块中的所有闭包
  void _collectClosures(Statement stmt, List<FunctionExpression> closures) {
    if (stmt is Block) {
      for (final s in stmt.statements) {
        _collectClosures(s, closures);
      }
    } else if (stmt is ExpressionStatement) {
      _collectClosuresInExpr(stmt.expression, closures);
    } else if (stmt is VariableDeclaration && stmt.initializer != null) {
      _collectClosuresInExpr(stmt.initializer!, closures);
    } else if (stmt is ReturnStatement && stmt.expression != null) {
      _collectClosuresInExpr(stmt.expression!, closures);
    } else if (stmt is IfStatement) {
      _collectClosures(stmt.then, closures);
      if (stmt.otherwise != null) {
        _collectClosures(stmt.otherwise!, closures);
      }
    } else if (stmt is ForStatement) {
      _collectClosures(stmt.body, closures);
    } else if (stmt is WhileStatement) {
      _collectClosures(stmt.body, closures);
    }
  }

  /// 收集表达式中的闭包
  void _collectClosuresInExpr(
      Expression expr, List<FunctionExpression> closures) {
    if (expr is FunctionExpression) {
      closures.add(expr);
      // 递归收集闭包中的嵌套闭包
      if (expr.function.body != null) {
        _collectClosures(expr.function.body!, closures);
      }
    } else if (expr is VariableGet) {
      // 变量引用，无需处理
    } else if (expr is InstanceInvocation) {
      _collectClosuresInExpr(expr.receiver, closures);
      for (final arg in expr.arguments.positional) {
        _collectClosuresInExpr(arg, closures);
      }
    } else if (expr is StaticInvocation) {
      for (final arg in expr.arguments.positional) {
        _collectClosuresInExpr(arg, closures);
      }
    } else if (expr is Let) {
      if (expr.variable.initializer != null) {
        _collectClosuresInExpr(expr.variable.initializer!, closures);
      }
      _collectClosuresInExpr(expr.body, closures);
    }
  }

  /// 分析闭包捕获的变量
  Set<VariableDeclaration> _analyzeCapturedVars(
      FunctionExpression closure, Set<VariableDeclaration> outerParams) {
    final captured = <VariableDeclaration>{};
    final closureParams = closure.function.positionalParameters.toSet()
      ..addAll(closure.function.namedParameters);

    // 收集闭包内部定义的局部变量
    final localVars = <VariableDeclaration>{};
    if (closure.function.body != null) {
      _collectLocalVars(closure.function.body!, localVars);
    }

    // 收集闭包中引用的变量
    if (closure.function.body != null) {
      _collectVarReferences(
          closure.function.body!, captured, closureParams, localVars);
    }

    return captured;
  }

  /// 收集局部变量声明
  void _collectLocalVars(Statement stmt, Set<VariableDeclaration> localVars) {
    if (stmt is VariableDeclaration) {
      localVars.add(stmt);
    } else if (stmt is Block) {
      for (final s in stmt.statements) {
        _collectLocalVars(s, localVars);
      }
    } else if (stmt is IfStatement) {
      _collectLocalVars(stmt.then, localVars);
      if (stmt.otherwise != null) {
        _collectLocalVars(stmt.otherwise!, localVars);
      }
    } else if (stmt is ForStatement) {
      for (final v in stmt.variables) {
        localVars.add(v);
      }
      _collectLocalVars(stmt.body, localVars);
    } else if (stmt is WhileStatement) {
      _collectLocalVars(stmt.body, localVars);
    }
  }

  /// 收集变量引用
  void _collectVarReferences(
      Statement stmt,
      Set<VariableDeclaration> captured,
      Set<VariableDeclaration> closureParams,
      Set<VariableDeclaration> localVars) {
    if (stmt is ExpressionStatement) {
      _collectVarReferencesInExpr(
          stmt.expression, captured, closureParams, localVars);
    } else if (stmt is Block) {
      for (final s in stmt.statements) {
        _collectVarReferences(s, captured, closureParams, localVars);
      }
    } else if (stmt is ReturnStatement && stmt.expression != null) {
      _collectVarReferencesInExpr(
          stmt.expression!, captured, closureParams, localVars);
    } else if (stmt is IfStatement) {
      _collectVarReferencesInExpr(
          stmt.condition, captured, closureParams, localVars);
      _collectVarReferences(stmt.then, captured, closureParams, localVars);
      if (stmt.otherwise != null) {
        _collectVarReferences(
            stmt.otherwise!, captured, closureParams, localVars);
      }
    } else if (stmt is WhileStatement) {
      _collectVarReferencesInExpr(
          stmt.condition, captured, closureParams, localVars);
      _collectVarReferences(stmt.body, captured, closureParams, localVars);
    } else if (stmt is ForStatement) {
      if (stmt.condition != null) {
        _collectVarReferencesInExpr(
            stmt.condition!, captured, closureParams, localVars);
      }
      _collectVarReferences(stmt.body, captured, closureParams, localVars);
    } else if (stmt is VariableDeclaration && stmt.initializer != null) {
      _collectVarReferencesInExpr(
          stmt.initializer!, captured, closureParams, localVars);
    }
  }

  /// 在表达式中收集变量引用
  void _collectVarReferencesInExpr(
      Expression expr,
      Set<VariableDeclaration> captured,
      Set<VariableDeclaration> closureParams,
      Set<VariableDeclaration> localVars) {
    if (expr is VariableGet) {
      // 如果不是闭包参数，也不是闭包内部局部变量，则是捕获的外部变量
      if (!closureParams.contains(expr.variable) &&
          !localVars.contains(expr.variable)) {
        captured.add(expr.variable);
      }
    } else if (expr is InstanceInvocation) {
      _collectVarReferencesInExpr(
          expr.receiver, captured, closureParams, localVars);
      for (final arg in expr.arguments.positional) {
        _collectVarReferencesInExpr(arg, captured, closureParams, localVars);
      }
    } else if (expr is StaticInvocation) {
      for (final arg in expr.arguments.positional) {
        _collectVarReferencesInExpr(arg, captured, closureParams, localVars);
      }
    } else if (expr is VariableSet) {
      if (!closureParams.contains(expr.variable) &&
          !localVars.contains(expr.variable)) {
        captured.add(expr.variable);
      }
      _collectVarReferencesInExpr(
          expr.value, captured, closureParams, localVars);
    }
  }

  /// 判断类型是否为值类型
  bool _isValueType(DartType? type) {
    if (type == null) return false;
    if (type is InterfaceType) {
      final className = type.classNode.name;
      return className == 'int' ||
          className == 'double' ||
          className == 'bool' ||
          className == 'String' ||
          className == 'Int' ||
          className == 'Double' ||
          className == 'Bool';
    }
    return false;
  }

  /// 转换整个组件
  /// [inputFileName] 可选的输入文件名，用于生成正确的 #include 语句
  String transformComponent(Component component, {String? inputFileName}) {
    _buffer.clear();

    // 保存输入文件名
    if (inputFileName != null) {
      _currentInputFileName = inputFileName;
    }

    // 初始化类型分析器并扫描所有类
    typeAnalyzer = TypeAnalyzer();
    typeAnalyzer.scanClasses(component);

    // 生成前向声明部分
    _generateForwardDeclarationsForAll(component);

    // 写入头文件
    _writeHeaders();
    _writeLine('');

    // 写入工具宏
    _writeUtilityMacros();
    _writeLine('');

    // 验证转换器配置
    _validateTransformerSetup();

    // 预注册常用扩展方法
    _registerCommonExtensionMethods();

    // 统计过滤信息
    int totalLibraries = component.libraries.length;
    int skippedLibraries = 0;
    int processedClasses = 0;
    int processedProcedures = 0;

    // 修复: 先注册所有扩展方法，以便在处理类定义时能正确识别扩展方法调用
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        continue;
      }
      for (final extension in library.extensions) {
        _registerExtensionFromDeclaration(extension);
      }
    }

    // 处理类定义 - 只处理非基础库的类
    // 需要对类进行拓扑排序，确保基类在子类之前定义
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        skippedLibraries++;
        continue;
      }

      // 对类进行拓扑排序
      final sortedClasses = _topologicalSortClasses(library.classes);

      for (final cls in sortedClasses) {
        _transformClass(cls);
        processedClasses++;
      }

      // 修复#17: 处理Extension声明 - 转换为命名空间和静态方法
      for (final extension in library.extensions) {
        _transformExtension(extension);
      }
    }

    // 生成顶级函数的前向声明（必须在全局变量之前，因为全局变量初始化可能引用这些函数）
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        continue;
      }

      for (final procedure in library.procedures) {
        if (procedure.name.text == 'main') {
          continue; // 跳过 main 函数
        }
        _writeFunctionDeclaration(procedure);
      }

      // 为扩展方法生成前向声明
      for (final extension in library.extensions) {
        _writeExtensionForwardDeclarations(extension);
      }
    }

    // 处理顶层字段/变量声明（在函数前向声明之后，因为全局变量初始化可能引用这些函数）
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        continue;
      }

      for (final field in library.fields) {
        _writeTopLevelField(field);
      }
    }

    // 处理全局函数 - 只处理非基础库的函数
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        continue;
      }

      for (final procedure in library.procedures) {
        _transformProcedure(procedure);
        processedProcedures++;
      }
    }

    // 写入主函数
    _writeMainFunction(component);

    // 统计信息已移至verbose模式单独输出
    return _buffer.toString();
  }

  /// 为所有类和函数生成前向声明
  void _generateForwardDeclarationsForAll(Component component) {
    // 生成类的前向声明
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        continue;
      }

      for (final cls in library.classes) {
        _writeClassForwardDeclaration(cls);
      }

      // 生成扩展方法的前向声明
      for (final extension in library.extensions) {
        _writeExtensionForwardDeclarationsForHeader(extension);
      }

      // 生成顶级函数的前向声明
      for (final procedure in library.procedures) {
        if (procedure.name.text == 'main') {
          continue; // 跳过 main 函数
        }
        // 跳过扩展方法（名称包含 | 的是扩展方法，已在namespace中声明）
        if (procedure.name.text.contains('|')) {
          continue;
        }
        _writeFunctionForwardDeclaration(procedure);
      }
    }
  }

  /// 生成类的前向声明
  void _writeClassForwardDeclaration(Class cls) {
    final sanitizedClassName = _sanitizeIdentifier(cls.name);

    // 生成泛型模板声明（如果有）
    String templateDecl = '';
    if (cls.typeParameters.isNotEmpty) {
      final typeParams =
          cls.typeParameters.map((p) => 'typename ${p.name}').join(', ');
      templateDecl = 'template<$typeParams>\n';
    }

    if (templateDecl.isNotEmpty) {
      addForwardDeclaration(templateDecl.trim());
    }
    addForwardDeclaration('class $sanitizedClassName;');
  }

  /// 生成扩展方法的前向声明（用于头文件）
  void _writeExtensionForwardDeclarationsForHeader(Extension extension) {
    var extensionName = extension.name;
    // 特殊处理：将 MathExtension 转换为 MathExtensions（与 C++ 运行时库保持一致）
    if (extensionName == 'MathExtension') {
      extensionName = 'MathExtensions';
    }
    final onType = extension.onType;
    final receiverType = CppTypeConverter.convertType(onType);

    // 收集所有方法的声明
    final methodDeclarations = <String>[];

    for (final member in extension.memberDescriptors) {
      final memberRef = member.memberReference;
      if (memberRef != null && memberRef.asProcedure != null) {
        final procedure = memberRef.asProcedure!;

        // 收集函数参数中的 FunctionType 参数
        final funcTypeParams =
            CppTypeConverter.collectFunctionTypeParams(procedure.function);

        // 检查是否有泛型参数或函数类型参数
        String templateDecl = '';
        if (procedure.function.typeParameters.isNotEmpty ||
            funcTypeParams.isNotEmpty) {
          final List<String> allTemplateParams = [];

          // 添加原始泛型参数
          if (procedure.function.typeParameters.isNotEmpty) {
            final typeParams = procedure.function.typeParameters
                .map((p) => 'typename ${p.name}')
                .join(', ');
            allTemplateParams.add(typeParams);
          }

          // 添加函数类型模板参数
          if (funcTypeParams.isNotEmpty) {
            final funcTemplateParams =
                CppTypeConverter.generateFunctionTypeTemplateParams(
                    procedure.function);
            if (funcTemplateParams.isNotEmpty) {
              allTemplateParams.add(funcTemplateParams);
            }
          }

          if (allTemplateParams.isNotEmpty) {
            templateDecl = 'template<${allTemplateParams.join(', ')}>\n';
          }
        }

        final returnType =
            CppTypeConverter.convertType(procedure.function.returnType);
        // Dart Kernel 会给扩展方法的名称添加前缀，如 "StringExtensions|capitalize"
        // 需要去除前缀，只保留方法名
        var methodName = procedure.name.text;
        if (methodName.contains('|')) {
          methodName = methodName.split('|').last;
        }

        // 清理方法名中的非法字符
        methodName = _sanitizeIdentifier(methodName);

        // 构建参数列表
        // Dart Kernel 会为扩展方法自动添加一个 #this 参数
        final params = <String>[];
        int paramIndex = 0; // 参数在整个列表中的位置索引

        // 添加所有参数（包括 #this 和其他参数）
        for (int i = 0;
            i < procedure.function.positionalParameters.length;
            i++) {
          final param = procedure.function.positionalParameters[i];
          String paramType;
          // 检查是否是函数类型参数，使用模板参数版本
          if (param.type is FunctionType) {
            // 使用参数在整个列表中的位置索引 + 1 作为 _F 编号
            // 与 generateFunctionTypeTemplateParams 保持一致
            paramType = CppTypeConverter.convertFunctionTypeWithTemplate(
                param.type as FunctionType, '_F${paramIndex + 1}');
          } else {
            paramType = CppTypeConverter.convertType(param.type);
          }
          paramIndex++;
          var paramName = param.name ?? 'param';
          // 将 #this 参数重命名为 this_
          if (paramName == '#this' || paramName == '_this') {
            paramName = 'this_';
          }
          // 清理参数名中的非法字符
          paramName = _sanitizeIdentifier(paramName);
          params.add('$paramType $paramName');
        }
        for (final param in procedure.function.namedParameters) {
          String paramType;
          // 检查是否是函数类型参数，使用模板参数版本
          if (param.type is FunctionType) {
            paramType = CppTypeConverter.convertFunctionTypeWithTemplate(
                param.type as FunctionType, '_F${paramIndex + 1}');
          } else {
            paramType = CppTypeConverter.convertType(param.type);
          }
          paramIndex++;
          var paramName = param.name ?? 'param';
          // 清理参数名中的非法字符
          paramName = _sanitizeIdentifier(paramName);
          params.add('$paramType $paramName');
        }

        // 收集方法声明
        String methodDecl = '  $returnType $methodName(${params.join(', ')});';
        if (templateDecl.isNotEmpty) {
          methodDecl = '${templateDecl.trim()}\n$methodDecl';
        }
        methodDeclarations.add(methodDecl);
      }
    }

    // 如果有方法声明，生成命名空间包装
    if (methodDeclarations.isNotEmpty) {
      // 添加命名空间开始
      addForwardDeclaration('namespace $extensionName {');

      // 添加所有方法声明
      for (final methodDecl in methodDeclarations) {
        addForwardDeclaration(methodDecl);
      }

      // 添加命名空间结束（添加注释使其唯一，避免Set去重）
      addForwardDeclaration('}; // namespace $extensionName');
    }
  }

  /// 生成函数的前向声明
  void _writeFunctionForwardDeclaration(Procedure procedure) {
    final name = procedure.name.text;

    // 使用推断的返回类型（可以处理柯里化等嵌套 lambda 的情况）
    final returnType = _inferProcedureReturnType(procedure);

    // 收集函数参数中的 FunctionType 参数
    final funcTypeParams =
        CppTypeConverter.collectFunctionTypeParams(procedure.function);

    // 收集在返回类型和参数类型中使用的所有类型参数
    final usedTypeParams =
        CppTypeConverter.collectAllTypeParametersFromFunction(
            procedure.function);

    // 处理泛型函数 - 生成正确的多参数模板语法
    String templateDecl = '';
    if (procedure.function.typeParameters.isNotEmpty ||
        funcTypeParams.isNotEmpty ||
        usedTypeParams.isNotEmpty) {
      // 为泛型函数生成模板声明
      final Set<String> allTypeParamNames = <String>{};
      final List<String> allTemplateParams = [];

      // 添加原始泛型参数
      if (procedure.function.typeParameters.isNotEmpty) {
        for (final p in procedure.function.typeParameters) {
          if (p.name != null) {
            allTypeParamNames.add(p.name!);
          }
        }
        final typeParams = procedure.function.typeParameters
            .map((p) => 'typename ${p.name}')
            .join(', ');
        allTemplateParams.add(typeParams);
      }

      // 添加在返回类型和参数类型中使用的类型参数（排除已添加的）
      final additionalTypeParams = usedTypeParams
          .where((name) =>
              !allTypeParamNames.contains(name) && !name.startsWith('_F'))
          .toList();
      if (additionalTypeParams.isNotEmpty) {
        allTypeParamNames.addAll(additionalTypeParams);
        final additionalParams =
            additionalTypeParams.map((name) => 'typename $name').join(', ');
        allTemplateParams.add(additionalParams);
      }

      // 添加函数类型模板参数
      if (funcTypeParams.isNotEmpty) {
        final funcTemplateParams =
            CppTypeConverter.generateFunctionTypeTemplateParams(
                procedure.function);
        if (funcTemplateParams.isNotEmpty) {
          allTemplateParams.add(funcTemplateParams);
        }
      }

      if (allTemplateParams.isNotEmpty) {
        templateDecl = 'template<${allTemplateParams.join(', ')}>\n';
      }
    }

    // 在 .cpp 文件的前向声明中不应包含默认参数，避免与 .h 文件中的声明重复定义
    // 默认参数只应在 .h 文件的声明中出现一次
    final params = _buildParameterListWithoutDefaults(procedure.function);

    // 将模板声明和函数签名合并成一个字符串，避免 Set 去重问题
    String fullDeclaration;
    if (templateDecl.isNotEmpty) {
      fullDeclaration = '${templateDecl.trim()}\n$returnType $name($params);';
    } else {
      fullDeclaration = '$returnType $name($params);';
    }
    addForwardDeclaration(fullDeclaration);
  }

  /// 打印转换统计信息
  void _printTransformationSummary(int totalLibraries, int skippedLibraries,
      int processedClasses, int processedProcedures) {
    print('📊 转换统计:');
    print('   总库数: $totalLibraries');
    print('   跳过基础库: $skippedLibraries');
    print('   处理业务库: ${totalLibraries - skippedLibraries}');
    print('   转换类数: $processedClasses');
    print('   转换函数数: $processedProcedures');
    print(
        '   注册扩展方法: ${_extensionMethods.values.fold(0, (sum, methods) => (sum as int) + methods.length)}');
    print('   TypeAnalyzer 自定义类: ${typeAnalyzer.customClasses.length}');
    print('');
    print('🎯 转换器功能:');
    print('   ✅ 基础类型转换');
    print('   ✅ ObjectPtr 智能包装');
    print('   ✅ 泛型约束支持');
    print('   ✅ 扩展方法语法糖');
    print('   ✅ Future 链式调用');
    print('   ✅ 集合操作完整支持');
    print('   ✅ late 变量支持');
    print('   ✅ 函数类型转换');
    print('   ✅ Switch fall-through 处理');
    print('   ✅ 字符串插值优化');
    print('');
  }

  /// 验证转换器设置
  void _validateTransformerSetup() {
    // 检查 TypeAnalyzer 是否正确初始化
    if (typeAnalyzer.customClasses.isEmpty && typeAnalyzer.basicTypes.isEmpty) {
      print('⚠️ 警告：TypeAnalyzer 可能未正确初始化');
    }

    // 检查转换器是否正确设置
    if (expressionConverter.transformer != this) {
      print('⚠️ 警告：ExpressionConverter 的 transformer 引用不正确');
    }

    if (statementConverter.transformer != this) {
      print('⚠️ 警告：StatementConverter 的 transformer 引用不正确');
    }
  }

  /// 对类进行拓扑排序，确保基类在子类之前定义
  /// 这对于mixin类型特别重要，因为Dart Kernel会生成如 _Singer&Musician&Performer 的中间类
  List<Class> _topologicalSortClasses(List<Class> classes) {
    final result = <Class>[];
    final visited = <Class>{};
    final visiting = <Class>{};

    // 从类型中提取类名（处理 ObjectPtr<Foo> 等情况）
    Set<String> _extractClassNamesFromType(DartType type) {
      final names = <String>{};
      if (type is InterfaceType) {
        names.add(type.classNode.name);
        for (final arg in type.typeArguments) {
          names.addAll(_extractClassNamesFromType(arg));
        }
      }
      return names;
    }

    void visit(Class cls) {
      if (visited.contains(cls)) return;
      if (visiting.contains(cls)) {
        // 检测到循环依赖，跳过
        return;
      }

      visiting.add(cls);

      // 先访问父类
      if (cls.superclass != null && cls.superclass!.name != 'Object') {
        // 在当前类集合中查找父类
        final superclass = classes.firstWhere(
          (c) => c.name == cls.superclass!.name,
          orElse: () => cls.superclass!,
        );
        if (classes.contains(superclass)) {
          visit(superclass);
        }
      }

      // 访问混入类
      if (cls.mixedInType != null) {
        final mixinClass = classes.firstWhere(
          (c) => c.name == cls.mixedInType!.classNode.name,
          orElse: () => cls.mixedInType!.classNode,
        );
        if (classes.contains(mixinClass)) {
          visit(mixinClass);
        }
      }

      // 访问接口
      for (final interface in cls.implementedTypes) {
        final interfaceClass = classes.firstWhere(
          (c) => c.name == interface.classNode.name,
          orElse: () => interface.classNode,
        );
        if (classes.contains(interfaceClass)) {
          visit(interfaceClass);
        }
      }

      // 访问字段类型依赖（确保字段中引用的类在当前类之前定义）
      for (final field in cls.fields) {
        final depNames = _extractClassNamesFromType(field.type);
        for (final depName in depNames) {
          if (depName == cls.name) continue; // 跳过自引用
          final depClass = classes.firstWhere(
            (c) => c.name == depName,
            orElse: () => cls, // 找不到则返回自身，跳过
          );
          if (depClass != cls && classes.contains(depClass)) {
            visit(depClass);
          }
        }
      }

      // 访问构造函数参数类型依赖
      for (final constructor in cls.constructors) {
        for (final param in constructor.function.positionalParameters) {
          final depNames = _extractClassNamesFromType(param.type);
          for (final depName in depNames) {
            if (depName == cls.name) continue;
            final depClass = classes.firstWhere(
              (c) => c.name == depName,
              orElse: () => cls,
            );
            if (depClass != cls && classes.contains(depClass)) {
              visit(depClass);
            }
          }
        }
      }

      visiting.remove(cls);
      visited.add(cls);
      result.add(cls);
    }

    for (final cls in classes) {
      visit(cls);
    }

    return result;
  }

  /// 获取接收者类型
  String? _getReceiverType(Expression receiver) {
    if (receiver is VariableGet) {
      final type = receiver.variable.type;
      // 使用 CppTypeConverter.convertType 保持与注册时一致的类型名称
      return CppTypeConverter.convertType(type);
    }
    // 处理方法调用链 - 递归获取接收者类型
    if (receiver is InstanceInvocation) {
      final target = receiver.interfaceTarget;
      if (target is Procedure) {
        final returnType = target.function.returnType;
        // 使用 CppTypeConverter.convertType 保持与注册时一致的类型名称
        return CppTypeConverter.convertType(returnType);
      }
      // 递归处理嵌套调用
      return _getReceiverType(receiver.receiver);
    }
    // 可以扩展更多类型推断
    return null;
  }

  /// 检查是否是扩展方法
  bool _isExtensionMethod(String receiverType, String methodName) {
    return _extensionMethods.containsKey(receiverType) &&
        _extensionMethods[receiverType]!.containsKey(methodName);
  }

  /// 获取扩展方法所在的类
  String _getExtensionClass(String receiverType, String methodName) {
    return _extensionMethods[receiverType]![methodName] ?? 'UnknownExtension';
  }

  /// 通用扩展方法转换 - 将扩展方法转换为静态方法调用
  /// 格式：ExtensionClass::methodName<TypeParams>(receiver, ...args)
  String _convertExtensionMethodCall(
      String receiverType, String methodName, String receiver, Arguments args,
      [Member? targetMember]) {
    var extensionClass = _getExtensionClass(receiverType, methodName);

    // 修复: 应用与 _registerExtensionFromDeclaration 相同的命名转换规则
    // 特殊处理：将 MathExtension 转换为 MathExtensions（与 C++ 命名空间保持一致）
    if (extensionClass == 'MathExtension') {
      extensionClass = 'MathExtensions';
    }

    // 构建泛型模板参数
    String templateParams = '';
    if (args.types.isNotEmpty) {
      // 直接使用调用时提供的类型参数
      final typeArgs =
          args.types.map((t) => CppTypeConverter.convertType(t)).join(', ');
      templateParams = '<$typeArgs>';
    } else if (targetMember != null && targetMember is Procedure) {
      // 尝试从目标方法的返回类型和参数类型推导
      final procedure = targetMember;
      if (procedure.function.typeParameters.isNotEmpty) {
        // 泛型扩展方法：尝试从 receiver 类型和 lambda 返回类型推导
        final typeInferences = <String>[];
        // T 通常是 receiver 的类型
        typeInferences.add(CppTypeConverter.convertType(
            procedure.function.positionalParameters.first.type));
        // R 通常是函数参数的返回类型
        if (args.positional.isNotEmpty) {
          for (final arg in args.positional) {
            if (arg is FunctionExpression) {
              final returnType =
                  CppTypeConverter.convertType(arg.function.returnType);
              typeInferences.add(returnType);
              break;
            }
          }
        }
        if (typeInferences.length >= 2) {
          templateParams = '<${typeInferences.join(', ')}>';
        }
      }
    }

    final staticMethodName = '${extensionClass}::$methodName$templateParams';

    // 构建参数列表，receiver作为第一个参数
    final argList = <String>[receiver];
    argList.addAll(args.positional
        .map((arg) => expressionConverter.convertExpression(arg)));

    // 添加命名参数（如果有）
    for (final namedArg in args.named) {
      argList.add(
          '/*${namedArg.name}:*/ ${expressionConverter.convertExpression(namedArg.value)}');
    }

    return '$staticMethodName(${argList.join(', ')})';
  }

  /// 注册扩展方法
  void _registerExtensionMethod(
      String targetType, String methodName, String extensionClass) {
    _extensionMethods.putIfAbsent(targetType, () => {});
    _extensionMethods[targetType]![methodName] = extensionClass;
  }

  /// 预注册常用扩展方法
  void _registerCommonExtensionMethods() {
    // 注意：不再预注册 String/Int/List/double 的扩展方法
    // 因为这些方法已经直接集成到对应的核心类中作为静态方法
    // 只注册用户自定义的扩展方法
  }

  /// 检查是否是 Future 类型
  bool _isFutureType(Expression expr) {
    if (expr is VariableGet) {
      final type = expr.variable.type;
      if (type is InterfaceType) {
        return type.classNode.name == 'Future';
      }
    }
    return false;
  }

  /// 转换 Future 方法调用
  String _convertFutureMethod(Expression receiver, String methodName) {
    final receiverCode = expressionConverter.convertExpression(receiver);

    switch (methodName) {
      case 'isCompleted':
        return '$receiverCode->isCompleted()';
      case 'value':
        return '$receiverCode->getValue()';
      case 'error':
        return '$receiverCode->getError()';
      case 'hasError':
        return '$receiverCode->hasError()';
      case 'hasValue':
        return '$receiverCode->hasValue()';
      default:
        // 默认处理 - 统一使用 -> 调用
        return '$receiverCode->$methodName()';
    }
  }

  /// 转换 Future 链式调用
  String _convertFutureChainCall(
      Expression receiver, String methodName, Arguments arguments) {
    final receiverCode = expressionConverter.convertExpression(receiver);

    switch (methodName) {
      case 'then':
        if (arguments.positional.isNotEmpty) {
          final callback =
              expressionConverter.convertExpression(arguments.positional.first);
          // 检查是否有类型参数
          final typeArgs = arguments.types;
          if (typeArgs.isNotEmpty) {
            final returnType = CppTypeConverter.convertType(typeArgs.first);
            return '$receiverCode->then<$returnType>($callback)';
          }
          return '$receiverCode->then($callback)';
        }
        break;

      case 'catchError':
        if (arguments.positional.isNotEmpty) {
          final errorHandler =
              expressionConverter.convertExpression(arguments.positional.first);
          return '$receiverCode->catchError($errorHandler)';
        }
        break;

      case 'whenComplete':
        if (arguments.positional.isNotEmpty) {
          final completeHandler =
              expressionConverter.convertExpression(arguments.positional.first);
          return '$receiverCode->whenComplete($completeHandler)';
        }
        break;

      case 'timeout':
        if (arguments.positional.isNotEmpty) {
          final timeout =
              expressionConverter.convertExpression(arguments.positional.first);
          return '$receiverCode->timeout($timeout)';
        }
        break;

      case 'wait':
        return '$receiverCode->wait()';

      case 'waitFor':
        if (arguments.positional.isNotEmpty) {
          final duration =
              expressionConverter.convertExpression(arguments.positional.first);
          return '$receiverCode->waitFor($duration)';
        }
        break;
    }

    // 默认处理
    final args = arguments.positional
        .map((arg) => expressionConverter.convertExpression(arg))
        .join(', ');
    return '$receiverCode->$methodName($args)';
  }

  /// 检查是否应该跳过某个库
  bool _shouldSkipLibrary(Library library) {
    final libraryUri = library.importUri.toString();

    // 检查是否匹配跳过的前缀
    for (final prefix in skipLibraryPrefixes) {
      if (libraryUri.startsWith(prefix)) {
        return true;
      }
    }

    return false;
  }

  void _writeHeaders() {
    // 如果有输入文件名，生成对应的 .h 文件 include
    if (_currentInputFileName.isNotEmpty) {
      String baseName = _currentInputFileName.split('/').last.split('.').first;
      _writeLine('#include "dart2cpp.h"');
    } else {
      // 默认 include dart2cpp.h
      for (final include in CppConstants.standardIncludes) {
        _writeLine(include);
      }
    }
  }

  void _writeUtilityMacros() {
    _writeLine('// 工具宏定义');
    for (final macro in CppConstants.utilityMacros) {
      _writeLine(macro);
    }
  }

  void _transformClass(Class cls) {
    // 设置当前类上下文（用于 this 表达式的类型判断）
    _currentClass = cls;

    try {
      // 清理类名中的特殊字符（如混入类 _Bird&Object&Flyable）
      final sanitizedClassName = _sanitizeIdentifier(cls.name);

      _writeLine(
          '// ============================================================================');
      _writeLine('// 类: $sanitizedClassName');
      _writeLine(
          '// ============================================================================');
      _writeLine('');

      // 检查是否是接口或抽象类
      final isAbstract = cls.isAbstract;
      final hasInterfaces = cls.implementedTypes.isNotEmpty;
      final hasSuperclass =
          cls.superclass != null && cls.superclass!.name != 'Object';

      // 生成泛型约束（如果有）
      // 注释掉，因为 template 声明已经在 _writeClass 和 _writeInterface 中处理
      // if (cls.typeParameters.isNotEmpty) {
      //   _writeGenericConstraints(cls);
      // }

      if (isAbstract) {
        _writeInterface(cls);
      } else {
        _writeClass(cls, hasSuperclass, hasInterfaces);
      }
    } finally {
      // 清除当前类上下文
      _currentClass = null;
    }
  }

  /// 修复#17: 将Extension转换为namespace和静态方法
  void _transformExtension(Extension ext) {
    var extensionName = ext.name;
    // 特殊处理：将 MathExtension 转换为 MathExtensions（与 C++ 运行时库保持一致）
    if (extensionName == 'MathExtension') {
      extensionName = 'MathExtensions';
    }

    _writeLine(
        '// ============================================================================');
    _writeLine('// Extension: $extensionName');
    _writeLine(
        '// ============================================================================');
    _writeLine('');

    // 将Extension转换为namespace
    _writeLine('namespace $extensionName {');
    _indent();

    // 转换Extension中的每个方法为静态方法
    for (final member in ext.memberDescriptors) {
      // 获取方法引用
      final memberRef = member.memberReference;
      if (memberRef != null && memberRef.asProcedure != null) {
        final procedure = memberRef.asProcedure!;
        // 生成静态方法
        _writeProcedureAsStaticMethod(procedure, ext.onType);
      }
    }

    _unindent();
    _writeLine('} // namespace $extensionName');
    _writeLine('');

    // 注册扩展方法，以便调用时能正确转换
    _registerExtensionFromDeclaration(ext);
  }

  /// 为Extension生成前向声明
  void _writeExtensionForwardDeclarations(Extension ext) {
    var extensionName = ext.name;
    // 特殊处理：将 MathExtension 转换为 MathExtensions（与 C++ 运行时库保持一致）
    if (extensionName == 'MathExtension') {
      extensionName = 'MathExtensions';
    }
    final onType = ext.onType;
    final receiverType = CppTypeConverter.convertType(onType);

    // 为命名空间中的每个方法生成前向声明
    for (final member in ext.memberDescriptors) {
      final memberRef = member.memberReference;
      if (memberRef != null && memberRef.asProcedure != null) {
        final procedure = memberRef.asProcedure!;

        // 检查是否有泛型参数
        String templateDecl = '';
        if (procedure.function.typeParameters.isNotEmpty) {
          final typeParams = procedure.function.typeParameters
              .map((p) => 'typename ${p.name}')
              .join(', ');
          templateDecl = 'template<$typeParams>\n';
        }

        final returnType =
            CppTypeConverter.convertType(procedure.function.returnType);
        // Dart Kernel 会给扩展方法的名称添加前缀，如 "StringExtensions|capitalize"
        // 需要去除前缀，只保留方法名
        var methodName = procedure.name.text;
        if (methodName.contains('|')) {
          methodName = methodName.split('|').last;
        }

        // 构建参数列表
        // Dart Kernel 会为扩展方法自动添加一个 #this 参数
        final params = <String>[];

        // 添加所有参数（包括 #this 和其他参数）
        for (final param in procedure.function.positionalParameters) {
          final paramType = CppTypeConverter.convertType(param.type);
          var paramName = param.name ?? 'param';
          // 将 #this 参数重命名为 this_
          if (paramName == '#this' || paramName == '_this') {
            paramName = 'this_';
          }
          params.add('$paramType $paramName');
        }
        for (final param in procedure.function.namedParameters) {
          final paramType = CppTypeConverter.convertType(param.type);
          final paramName = param.name ?? 'param';
          params.add('$paramType $paramName');
        }

        // 生成前向声明（包含泛型声明）
        if (templateDecl.isNotEmpty) {
          _writeLine(templateDecl.trimRight());
        }
        _writeLine(
            '$returnType $extensionName::$methodName(${params.join(', ')});');
      }
    }
  }

  /// 将Procedure转换为静态方法
  void _writeProcedureAsStaticMethod(Procedure procedure, DartType onType) {
    // 检查是否有泛型参数
    String templateDecl = '';
    if (procedure.function.typeParameters.isNotEmpty) {
      final typeParams = procedure.function.typeParameters
          .map((p) => 'typename ${p.name}')
          .join(', ');
      templateDecl = 'template<$typeParams>\n';
    }

    final returnType =
        CppTypeConverter.convertType(procedure.function.returnType);
    // Dart Kernel 会给扩展方法的名称添加前缀，如 "StringExtensions|capitalize"
    // 需要去除前缀，只保留方法名
    var methodName = procedure.name.text;
    if (methodName.contains('|')) {
      methodName = methodName.split('|').last;
    }
    final receiverType = CppTypeConverter.convertType(onType);

    // 构建参数列表
    // Dart Kernel 会为扩展方法自动添加一个 #this 参数（代表扩展对象本身）
    // 我们直接使用这个参数，不需要手动添加
    final params = <String>[];

    // 添加扩展方法的所有参数（包括 #this 和其他参数）
    for (final param in procedure.function.positionalParameters) {
      final paramType = CppTypeConverter.convertType(param.type);
      var paramName = param.name ?? 'param';
      // 将 #this 参数重命名为 this_
      if (paramName == '#this' || paramName == '_this') {
        paramName = 'this_';
      }
      params.add('$paramType $paramName');
    }
    for (final param in procedure.function.namedParameters) {
      final paramType = CppTypeConverter.convertType(param.type);
      final paramName = param.name ?? 'param';
      params.add('$paramType $paramName');
    }

    // 生成泛型模板声明（如果有）
    if (templateDecl.isNotEmpty) {
      _writeLine(templateDecl.trimRight());
    }
    _writeLine('inline $returnType $methodName(${params.join(', ')}) {');
    _indent();

    // 转换函数体 - 将 _this 替换为 this_
    if (procedure.function.body != null) {
      var body = statementConverter.convertStatement(procedure.function.body!);
      // 将函数体中的 _this-> 替换为 this_->
      body = body.replaceAll('_this->', 'this_->');
      _writeLine(body);
    }

    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 从 Extension 声明注册扩展方法
  void _registerExtensionFromDeclaration(Extension ext) {
    var extensionName = ext.name;
    // 修复: 应用与 _transformExtension 相同的名称转换规则
    // 特殊处理：将 MathExtension 转换为 MathExtensions（与 C++ 命名空间保持一致）
    if (extensionName == 'MathExtension') {
      extensionName = 'MathExtensions';
    }

    final onType = ext.onType;
    // 使用 CppTypeConverter.convertType 获取正确的类型名称
    // 这样可以正确处理基本类型（如 double -> Double）
    String targetType = CppTypeConverter.convertType(onType);

    for (final member in ext.memberDescriptors) {
      final memberRef = member.memberReference;
      if (memberRef != null && memberRef.asProcedure != null) {
        final methodName = memberRef.asProcedure!.name.text;
        _registerExtensionMethod(targetType, methodName, extensionName);
      }
    }
  }

  /// 生成泛型约束
  void _writeGenericConstraints(Class cls) {
    for (final typeParam in cls.typeParameters) {
      if (typeParam.bound != null) {
        final paramName = typeParam.name;
        final boundType = CppTypeConverter.convertType(typeParam.bound!);

        // 修复泛型约束 - 不再使用有问题的is_base_of_v和num类型
        _writeLine('template<typename $paramName>');
        _writeLine('');
      }
    }
  }

  void _writeInterface(Class cls) {
    // 修复#3: 将抽象类转换为标准C++纯虚类
    // 清理类名中的特殊字符（如混入类 _Bird&Object&Flyable）
    final sanitizedClassName = _sanitizeIdentifier(cls.name);

    // 生成泛型模板声明（如果有）
    String templateDecl = '';
    if (cls.typeParameters.isNotEmpty) {
      final typeParams =
          cls.typeParameters.map((p) => 'typename ${p.name}').join(', ');
      templateDecl = 'template<$typeParams>\n';
    }

    // 构建继承列表
    final inheritanceList = <String>[];
    if (cls.superclass != null && cls.superclass!.name != 'Object') {
      // 父类名也需要清理特殊字符
      final superclassName = _sanitizeIdentifier(cls.superclass!.name);

      // 特殊处理：枚举类的父类 _Enum 在 C++ 中不存在，改为继承 Object
      if (superclassName == '_Enum') {
        inheritanceList.add('public Object');
      } else {
        inheritanceList.add('public $superclassName');
      }
    }
    for (final interface in cls.implementedTypes) {
      // 接口名也需要清理特殊字符
      final interfaceName = _sanitizeIdentifier(interface.classNode.name);
      inheritanceList.add('virtual public $interfaceName');
    }
    final inheritance =
        inheritanceList.isNotEmpty ? ' : ${inheritanceList.join(", ")}' : '';

    _writeLine('${templateDecl}class $sanitizedClassName$inheritance {');
    _writeLine('public:');
    _indent();

    // 生成虚析构函数
    _writeLine('virtual ~$sanitizedClassName() = default;');
    _writeLine('');

    // 对于mixin生成的中间抽象类，生成转发构造函数
    final hasSuperclass =
        cls.superclass != null && cls.superclass!.name != 'Object';
    if (hasSuperclass) {
      final superclassName = _sanitizeIdentifier(cls.superclass!.name);
      // 生成一个模板化的构造函数，可以接受任何参数并转发给父类
      _writeLine('template<typename... Args>');
      _writeLine(
          '$sanitizedClassName(Args&&... args) : $superclassName(std::forward<Args>(args)...) {}');
      _writeLine('');
    }

    // 处理抽象方法 - 转换为纯虚函数
    for (final procedure in cls.procedures) {
      if (procedure.isAbstract) {
        final returnType =
            CppTypeConverter.convertType(procedure.function.returnType);
        // getter 方法需要加 get_ 前缀，与调用侧保持一致
        var name = procedure.name.text;
        if (procedure.isGetter) {
          name = 'get_$name';
        }
        final params = _buildParameterList(procedure.function);
        _writeLine('virtual $returnType $name($params) = 0;');
      } else {
        // 非抽象方法正常处理
        _writeProcedure(procedure, isClassMember: true);
      }
    }

    // 修复: 抽象类的字段应该作为普通成员字段处理，而不是纯虚函数
    // 只有纯接口才将字段转换为纯虚getter
    final hasConcreteMembers = cls.fields.any((f) => f.initializer != null) ||
        cls.constructors.isNotEmpty ||
        cls.procedures.any((p) => !p.isAbstract);

    if (hasConcreteMembers) {
      // 有具体实现的抽象类 - 字段作为成员变量
      for (final field in cls.fields) {
        final type = CppTypeConverter.convertType(field.type);
        final name = field.name.text;
        if (field.initializer != null) {
          final init =
              expressionConverter.convertExpression(field.initializer!);
          _writeLine('$type $name = $init;');
        } else {
          _writeLine('$type $name;');
        }
      }

      // 如果有构造函数，需要处理
      for (final constructor in cls.constructors) {
        _writeConstructor(constructor, sanitizedClassName);
      }
    } else {
      // 纯接口 - 字段转换为纯虚getter
      for (final field in cls.fields) {
        final type = CppTypeConverter.convertType(field.type);
        final name = field.name.text;
        _writeLine('virtual $type $name() = 0;');
      }
    }

    _unindent();
    _writeLine('};');
    _writeLine('');
  }

  void _writeClass(Class cls, bool hasSuperclass, bool hasInterfaces) {
    // 修复#2: 泛型类继承正确处理
    // 生成泛型模板声明（如果有）
    String templateDecl = '';
    String typeParamList = '';
    if (cls.typeParameters.isNotEmpty) {
      final typeParams =
          cls.typeParameters.map((p) => 'typename ${p.name}').join(', ');
      templateDecl = 'template<$typeParams>\n';
      typeParamList = '<${cls.typeParameters.map((p) => p.name).join(', ')}>';
    }

    // 构建继承列表 - 正确传递泛型参数
    final inheritanceList = <String>[];

    if (hasSuperclass) {
      // 混入类名可能包含特殊字符（如 _Bird&Object&Flyable），需要清理
      final superclassName = _sanitizeIdentifier(cls.superclass!.name);
      // 检查父类是否有泛型参数，并传递过去
      if (cls.supertype != null && cls.supertype!.typeArguments.isNotEmpty) {
        final superTypeArgs = cls.supertype!.typeArguments
            .map((t) => CppTypeConverter.convertType(t))
            .join(', ');
        inheritanceList.add('public $superclassName<$superTypeArgs>');
      } else if (cls.typeParameters.isNotEmpty &&
          cls.superclass!.typeParameters.isNotEmpty) {
        // 父类也有泛型，传递当前类的类型参数
        inheritanceList.add('public $superclassName$typeParamList');
      } else {
        inheritanceList.add('public $superclassName');
      }
    }

    for (final interface in cls.implementedTypes) {
      // 接口名也可能包含特殊字符，需要清理
      final interfaceName = _sanitizeIdentifier(interface.classNode.name);
      if (interface.typeArguments.isNotEmpty) {
        final interfaceTypeArgs = interface.typeArguments
            .map((t) => CppTypeConverter.convertType(t))
            .join(', ');
        inheritanceList
            .add('virtual public $interfaceName<$interfaceTypeArgs>');
      } else {
        inheritanceList.add('virtual public $interfaceName');
      }
    }

    // 处理Mixin（修复#16）- 使用多重继承模拟
    if (cls.mixedInType != null) {
      final mixedInSupertype = cls.mixedInType!;
      // 混入类名可能包含特殊字符（如 _Bird&Object&Flyable），需要清理
      final mixinName = _sanitizeIdentifier(mixedInSupertype.classNode.name);
      if (mixedInSupertype.typeArguments.isNotEmpty) {
        final mixinTypeArgs = mixedInSupertype.typeArguments
            .map((t) => CppTypeConverter.convertType(t))
            .join(', ');
        inheritanceList.add('public $mixinName<$mixinTypeArgs>');
      } else {
        inheritanceList.add('public $mixinName');
      }
    }

    final inheritance =
        inheritanceList.isNotEmpty ? ' : ${inheritanceList.join(", ")}' : '';

    // 类名可能包含特殊字符（如混入类 _Bird&Object&Flyable），需要清理为合法的C++标识符
    final sanitizedClassName = _sanitizeIdentifier(cls.name);
    _writeLine('${templateDecl}class $sanitizedClassName$inheritance {');

    // 访问控制
    bool hasPrivate = false;
    bool hasPublic = false;

    // 处理字段
    for (final field in cls.fields) {
      if (!hasPrivate && _isPrivate(field.name.text)) {
        _writeLine('private:');
        hasPrivate = true;
      } else if (!hasPublic && !_isPrivate(field.name.text)) {
        _writeLine('public:');
        hasPublic = true;
      }

      _indent();
      _writeField(field);
      _unindent();
    }

    // 处理构造函数
    if (!hasPublic) {
      _writeLine('public:');
    }

    if (cls.constructors.isEmpty) {
      // 如果没有构造函数，为中间类（如mixin生成的类）生成默认构造函数
      // 对于mixin生成的中间类，生成一个通用构造函数，转发参数给父类
      if (hasSuperclass && cls.superclass != null) {
        final superclassName = _sanitizeIdentifier(cls.superclass!.name);
        // 生成一个模板化的构造函数，可以接受任何参数并转发给父类
        _indent();
        // 使用可变参数模板生成通用构造函数
        _writeLine('template<typename... Args>');
        _writeLine(
            '$sanitizedClassName(Args&&... args) : $superclassName(std::forward<Args>(args)...) {}');
        _writeLine('');
        _unindent();
      }
    } else {
      for (final constructor in cls.constructors) {
        _indent();
        _writeConstructor(constructor, sanitizedClassName);
        _unindent();
      }
    }

    // 处理方法
    for (final procedure in cls.procedures) {
      _indent();
      _writeProcedure(procedure, isClassMember: true);
      _unindent();
    }

    // 如果类没有显式定义 toString() 方法，自动生成一个默认实现
    // 这是必要的，因为 ObjectPtr<T>::toString() 会调用 T::toString()
    final hasToString = cls.procedures.any((p) => p.name.text == 'toString');
    if (!hasToString) {
      _indent();
      _writeLine('String toString() const {');
      _indent();
      _writeLine('return dart_string("${cls.name}");');
      _unindent();
      _writeLine('}');
      _unindent();
    }

    _writeLine('};');
    _writeLine('');

    // 在类外定义和初始化静态成员变量
    // C++ 要求静态成员变量在类外定义
    final staticFields = cls.fields.where((f) => f.isStatic).toList();
    for (final field in staticFields) {
      final type = CppTypeConverter.convertType(field.type);
      final name = field.name.text;
      final className = _sanitizeIdentifier(cls.name);
      if (field.initializer != null) {
        final init = expressionConverter.convertExpression(field.initializer!);
        _writeLine('$type $className::$name = $init;');
      } else {
        // 无初始化器的静态成员也需要定义
        _writeLine('$type $className::$name;');
      }
    }
    if (staticFields.isNotEmpty) {
      _writeLine('');
    }
  }

  void _writeField(Field field) {
    final type = CppTypeConverter.convertType(field.type);
    final name = field.name.text;
    final staticPrefix = field.isStatic ? 'static ' : '';

    // 对于静态成员变量，C++ 不允许在类内直接初始化非整型静态成员
    // 需要在类外定义，所以这里只声明，初始化放在类外
    if (field.isStatic && field.initializer != null) {
      // 静态成员只声明，不初始化
      _writeLine('$staticPrefix$type $name;');
    } else if (field.initializer != null) {
      final init = expressionConverter.convertExpression(field.initializer!);
      _writeLine('$staticPrefix$type $name = $init;');
    } else {
      _writeLine('$staticPrefix$type $name;');
    }
  }

  /// 写入顶层变量声明
  void _writeTopLevelField(Field field) {
    final type = CppTypeConverter.convertType(field.type);
    var name = field.name.text;
    // 清理变量名中可能的非法字符
    name = _sanitizeIdentifier(name);

    if (field.initializer != null) {
      // 设置全局作用域标志，避免 Lambda 使用 [=] 捕获
      expressionConverter.isGlobalScope = true;
      final init = expressionConverter.convertExpression(field.initializer!);
      expressionConverter.isGlobalScope = false;
      _writeLine('$type $name = $init;');
    } else {
      // 对于无初始化器的顶层变量，提供默认值
      if (type == 'Nullable' || type.contains('ObjectPtr<')) {
        _writeLine('$type $name = Null;');
      } else {
        _writeLine('$type $name;');
      }
    }
    _writeLine('');
  }

  void _writeConstructor(Constructor constructor, String className) {
    final params = _buildParameterList(constructor.function);
    final constructorName = constructor.name.text;

    // 检查是否是命名构造函数
    final isNamedConstructor = constructorName.isNotEmpty;

    // 构建初始化列表
    final initializers = <String>[];
    bool hasSuperInitializer = false;

    for (final initializer in constructor.initializers) {
      if (initializer is FieldInitializer) {
        final fieldName = initializer.field.name.text;
        final value = expressionConverter.convertExpression(initializer.value);
        initializers.add('$fieldName($value)');
      } else if (initializer is SuperInitializer) {
        hasSuperInitializer = true;
        final args =
            expressionConverter._convertArguments(initializer.arguments);
        // 如果有参数，使用父类构造函数；否则跳过
        if (args.isNotEmpty) {
          // C++ 不支持 super，需要使用基类名
          if (constructor.enclosingClass.superclass != null) {
            // 父类名可能包含特殊字符，需要清理
            final superName = _sanitizeIdentifier(
                constructor.enclosingClass.superclass!.name);
            initializers.add('$superName($args)');
          }
        }
      }
    }

    // 修复: 如果没有显式的 SuperInitializer，但基类有非默认构造函数，
    // 尝试自动生成基类构造函数调用
    if (!hasSuperInitializer && constructor.enclosingClass.superclass != null) {
      final superclass = constructor.enclosingClass.superclass!;
      // 检查基类是否有构造函数需要参数
      final superConstructors =
          superclass.constructors.where((c) => c.name.text.isEmpty);
      if (superConstructors.isNotEmpty) {
        final defaultSuperCtor = superConstructors.first;
        final requiredParamCount =
            defaultSuperCtor.function.requiredParameterCount;

        if (requiredParamCount > 0) {
          // 基类需要参数，尝试用子类的参数调用基类构造函数
          final superName = _sanitizeIdentifier(superclass.name);
          final superParams = defaultSuperCtor.function.positionalParameters;
          final childParams = constructor.function.positionalParameters;

          // 尝试匹配参数：按名称或按位置
          final matchedArgs = <String>[];
          for (int i = 0;
              i < superParams.length && i < childParams.length;
              i++) {
            final superParamName = superParams[i].name ?? 'arg$i';
            // 优先按名称匹配
            final matchingChildParam =
                childParams.where((p) => p.name == superParamName).firstOrNull;
            if (matchingChildParam != null) {
              matchedArgs.add(matchingChildParam.name!);
            } else if (i < childParams.length) {
              // 按位置匹配
              matchedArgs.add(childParams[i].name ?? 'arg$i');
            }
          }

          if (matchedArgs.length >= requiredParamCount) {
            initializers.add('$superName(${matchedArgs.join(', ')})');
          }
        }
      }
    }

    // 命名构造函数转换为静态工厂方法
    if (isNamedConstructor) {
      // 生成静态工厂方法：static ObjectPtr<ClassName> constructorName(params)
      _writeLine('static ObjectPtr<$className> $constructorName($params) {');
      _indent();

      // 收集命名构造函数的字段初始化值（字段名 -> 初始化值表达式）
      final fieldInitValues = <String, String>{};
      for (final initializer in constructor.initializers) {
        if (initializer is FieldInitializer) {
          final fieldName = initializer.field.name.text;
          final value =
              expressionConverter.convertExpression(initializer.value);
          fieldInitValues[fieldName] = value;
        }
      }

      // 查找类的主构造函数（名称为空的构造函数）
      final enclosingClass = constructor.enclosingClass;
      final primaryConstructors = enclosingClass.constructors
          .where((c) => c.name.text.isEmpty)
          .toList();

      if (primaryConstructors.isNotEmpty) {
        final primaryCtor = primaryConstructors.first;
        final primaryParams = primaryCtor.function.positionalParameters;

        // 按主构造函数的参数顺序，从字段初始化值中提取对应值
        final constructorArgs = <String>[];
        for (final param in primaryParams) {
          final paramName = param.name ?? '';
          if (fieldInitValues.containsKey(paramName)) {
            constructorArgs.add(fieldInitValues[paramName]!);
          } else {
            // 如果没有对应的字段初始化，使用参数类型的默认值
            final paramType = CppTypeConverter.convertType(param.type);
            if (paramType.contains('ObjectPtr<') || paramType == 'Nullable') {
              constructorArgs.add('Null');
            } else if (paramType == 'Int') {
              constructorArgs.add('dart_int(0)');
            } else if (paramType == 'Double') {
              constructorArgs.add('dart_double(0.0)');
            } else if (paramType == 'Bool') {
              constructorArgs.add('dart_bool(false)');
            } else if (paramType == 'String') {
              constructorArgs.add('dart_string("")');
            } else {
              constructorArgs.add('{}');
            }
          }
        }

        // 使用主构造函数的参数值创建对象
        _writeLine(
            'auto obj = ObjectPtr<$className>(new $className(${constructorArgs.join(', ')}));');
      } else {
        // 没有主构造函数，检查类的字段列表，尝试按字段顺序传参
        // 例如 Color 类只有 value 字段，命名构造函数 _ 初始化了 value，
        // 则生成 new Color(value) 而非 new Color() + obj->value = value
        final classFields =
            enclosingClass.fields.where((f) => !f.isStatic).toList();
        final fieldArgs = <String>[];
        bool allFieldsInitialized = true;
        for (final field in classFields) {
          final fieldName = field.name.text;
          if (fieldInitValues.containsKey(fieldName)) {
            fieldArgs.add(fieldInitValues[fieldName]!);
          } else {
            allFieldsInitialized = false;
            break;
          }
        }

        // 没有主构造函数时，使用默认无参构造 + 字段赋值方式
        // C++ 会为没有显式构造函数的类自动生成默认无参构造函数
        _writeLine('auto obj = ObjectPtr<$className>(new $className());');
        for (final entry in fieldInitValues.entries) {
          _writeLine('obj->${entry.key} = ${entry.value};');
        }
      }

      // 执行构造函数体（如果有）
      if (constructor.function.body != null) {
        final body =
            statementConverter.convertStatement(constructor.function.body!);
        if (body.isNotEmpty) {
          _writeLine(body);
        }
      }

      _writeLine('return obj;');
      _unindent();
      _writeLine('}');
      _writeLine('');
      return;
    }

    // 普通构造函数：写入构造函数签名和初始化列表
    if (initializers.isNotEmpty) {
      _writeLine('$className($params) : ${initializers.join(', ')} {');
    } else {
      _writeLine('$className($params) {');
    }

    if (constructor.function.body != null) {
      _indent();
      // 构造函数不应该有返回语句
      final body =
          statementConverter.convertStatement(constructor.function.body!);
      if (body.isNotEmpty) {
        _writeLine(body);
      }
      _unindent();
    }

    _writeLine('}');
    _writeLine('');
  }

  void _transformProcedure(Procedure procedure) {
    // Skip main function as it will be handled separately
    if (procedure.name.text == 'main') {
      return;
    }

    // 跳过扩展方法，因为它们已经由 _transformExtension 处理
    // 扩展方法的名称包含 '|' 字符，如 "StringExtensions|capitalize"
    if (procedure.name.text.contains('|')) {
      return; // 跳过扩展方法
    }

    _writeProcedure(procedure, isClassMember: false);
  }

  void _writeFunctionDeclaration(Procedure procedure) {
    // 生成函数前向声明（仅函数签名，无函数体）
    final name = procedure.name.text;

    // 跳过扩展方法，因为它们已经由 _writeExtensionForwardDeclarations 处理
    // 扩展方法的名称包含 '|' 字符，如 "StringExtensions|capitalize"
    if (name.contains('|')) {
      return; // 跳过扩展方法
    }

    // 使用推断的返回类型（可以处理柯里化等嵌套 lambda 的情况）
    final returnType = _inferProcedureReturnType(procedure);

    // 收集函数参数中的 FunctionType 参数
    final funcTypeParams =
        CppTypeConverter.collectFunctionTypeParams(procedure.function);

    // 处理泛型函数 - 生成正确的多参数模板语法
    bool hasTemplate = false;
    if (procedure.function.typeParameters.isNotEmpty ||
        funcTypeParams.isNotEmpty) {
      // 为泛型函数生成模板声明
      final List<String> allTemplateParams = [];

      // 添加原始泛型参数
      if (procedure.function.typeParameters.isNotEmpty) {
        final typeParams = procedure.function.typeParameters
            .map((p) => 'typename ${p.name}')
            .join(', ');
        allTemplateParams.add(typeParams);
      }

      // 添加函数类型模板参数
      if (funcTypeParams.isNotEmpty) {
        final funcTemplateParams =
            CppTypeConverter.generateFunctionTypeTemplateParams(
                procedure.function);
        if (funcTemplateParams.isNotEmpty) {
          allTemplateParams.add(funcTemplateParams);
        }
      }

      if (allTemplateParams.isNotEmpty) {
        _writeLine('template<${allTemplateParams.join(', ')}>');
        hasTemplate = true;
      }
    }

    final params = _buildParameterList(procedure.function);
    _writeLine('$returnType $name($params);');
  }

  void _writeProcedure(Procedure procedure, {required bool isClassMember}) {
    var name = procedure.name.text;

    // 设置当前函数的返回类型（用于 return 语句处理）
    _currentProcedureReturnType = procedure.function.returnType;

    // 阶段1：预扫描函数，识别需要装箱的变量
    _prescanFunction(procedure.function);

    // 修复#18: 工厂构造函数转换为静态方法
    if (procedure.isFactory) {
      _writeFactoryAsStaticMethod(procedure);
      return;
    }

    // 对于类成员的运算符方法，必须先转换为 operator_ 前缀的方法名，再进行 sanitize
    // 这样可以避免 operator+ 和 operator- 都被 sanitize 成同一个名字
    if (isClassMember && _isOperatorMethod(name)) {
      name = _convertOperatorMethodName(name);
    }

    // 最后对名字进行清理（此时运算符方法名已经是合法的 operator_add 等形式）
    name = _sanitizeIdentifier(name);

    // 为 getter 方法添加 get_ 前缀，与调用侧 _convertInstanceGet 保持一致
    // 调用侧对用户自定义类的 getter 也会生成 get_xxx() 调用
    if (procedure.isGetter && isClassMember) {
      name = 'get_$name';
    }

    // 为 setter 方法添加 set_ 前缀，与调用侧 _convertInstanceSet 保持一致
    // 调用侧对用户自定义类的 setter 也会生成 set_xxx() 调用
    if (procedure.isSetter && isClassMember) {
      name = 'set_$name';
    }

    // 收集函数参数中的 FunctionType 参数
    final funcTypeParams =
        CppTypeConverter.collectFunctionTypeParams(procedure.function);

    // 修复问题2A: 处理泛型函数 - 避免在泛型类内部重复声明模板
    // 只有当方法本身有泛型参数且不是类成员时，才生成模板声明
    // 如果是类成员，模板已经在类声明中生成，不需要重复
    // 同时检查是否有函数类型参数
    final shouldWriteTemplate =
        (procedure.function.typeParameters.isNotEmpty && !isClassMember) ||
            funcTypeParams.isNotEmpty;

    if (shouldWriteTemplate) {
      // 为泛型函数生成模板声明 - 使用正确的多参数模板语法
      final List<String> allTemplateParams = [];

      // 添加原始泛型参数
      if (procedure.function.typeParameters.isNotEmpty && !isClassMember) {
        final typeParams = procedure.function.typeParameters
            .map((p) => 'typename ${p.name}')
            .join(', ');
        allTemplateParams.add(typeParams);
      }

      // 添加函数类型模板参数
      if (funcTypeParams.isNotEmpty) {
        final funcTemplateParams =
            CppTypeConverter.generateFunctionTypeTemplateParams(
                procedure.function);
        if (funcTemplateParams.isNotEmpty) {
          allTemplateParams.add(funcTemplateParams);
        }
      }

      if (allTemplateParams.isNotEmpty) {
        _writeLine('template<${allTemplateParams.join(', ')}>');
      }
    }

    // 使用推断的返回类型（可以处理柯里化等嵌套 lambda 的情况）
    final returnType = _inferProcedureReturnType(procedure);

    // 修复Setter返回类型：自动推断为参数类型以支持链式调用
    String actualReturnType = returnType;
    // 处理Dart的setter属性
    if (procedure.isSetter &&
        procedure.function.positionalParameters.isNotEmpty) {
      // Setter方法：返回类型与参数类型一致
      final paramType = CppTypeConverter.convertType(
          procedure.function.positionalParameters.first.type);
      actualReturnType = paramType;
    }
    // 处理以set开头的普通方法（如setName, setAge）
    else if (name.startsWith('set') &&
        name.length > 3 &&
        name[3].toUpperCase() == name[3] &&
        procedure.function.positionalParameters.isNotEmpty &&
        returnType == 'Nullable') {
      // 对于返回void的set方法，使用参数类型作为返回类型
      final paramType = CppTypeConverter.convertType(
          procedure.function.positionalParameters.first.type);
      actualReturnType = paramType;
    }

    // 阶段2：构建参数列表（带装箱处理）
    final params = _buildParameterListWithoutDefaults(procedure.function);

    // 检查是否是异步函数
    final isAsync = _isAsyncFunction(procedure.function);

    if (isAsync) {
      // 直接生成函数签名，不使用宏
      final prefix = isClassMember ? '' : '';
      _writeLine('$prefix$actualReturnType $name($params) {');
      // DART_ASYNC_BEGIN需要return_type参数
      // 从 ObjectPtr<Future<T>> 提取 T
      String asyncReturnType = actualReturnType;
      if (actualReturnType.startsWith('ObjectPtr<Future<')) {
        // 提取泛型参数，例如 ObjectPtr<Future<Int>> -> Int
        asyncReturnType =
            actualReturnType.substring('ObjectPtr<Future<'.length);
        asyncReturnType =
            asyncReturnType.substring(0, asyncReturnType.length - 2); // 移除 >>
      }
      _writeLine('  DART_ASYNC_BEGIN($asyncReturnType)');
    } else {
      final prefix = isClassMember ? '' : '';
      _writeLine('$prefix$actualReturnType $name($params) {');
    }

    if (procedure.function.body != null) {
      _indent();

      // 生成参数装箱代码（在函数体最开始）
      final boxingCode = _generateParameterBoxingCode(procedure.function);
      if (boxingCode.isNotEmpty) {
        _writeLine(boxingCode);
      }

      final isVoidFunction =
          CppTypeConverter.convertType(procedure.function.returnType) ==
              'Nullable';

      // 对于Setter，即使原始返回类型是void，也不应该当作void处理
      final shouldTreatAsVoid = isVoidFunction && !procedure.isSetter;

      final body = _transformFunctionBody(procedure.function.body!,
          isVoidFunction: shouldTreatAsVoid, isSetter: procedure.isSetter);
      _writeLine(body);
      _unindent();
    }

    if (isAsync) {
      // DART_ASYNC_END需要返回值作为参数
      // 如果是void函数，传入Null；否则需要返回值
      final isVoidFunction =
          CppTypeConverter.convertType(procedure.function.returnType) ==
              'Nullable';
      if (isVoidFunction) {
        _writeLine('  DART_ASYNC_END(Null)');
      } else {
        // 对于非-void函数，假设函数体最后返回result
        // 实际上这需要从函数体中提取，但由于Dart的async函数会自动返回
        // 我们需要把最后的return语句的值传给DART_ASYNC_END
        _writeLine('  // TODO: 需要处理异步函数返回值');
        _writeLine('  DART_ASYNC_END(Null)');
      }
    }

    _writeLine('}');
    _writeLine('');

    // 清空当前函数的装箱参数信息和返回类型
    _currentFunctionBoxedParams.clear();
    _currentProcedureReturnType = null;
  }

  /// 修复#18: 将工厂构造函数转换为静态方法
  void _writeFactoryAsStaticMethod(Procedure procedure) {
    final className = procedure.enclosingClass!.name;
    // 工厂方法名：如果是默认工厂构造函数，使用 'create'；否则使用方法名
    var factoryName = procedure.name.text;
    if (factoryName.isEmpty) {
      factoryName = 'create';
    } else {
      factoryName = _sanitizeIdentifier(factoryName);
    }

    // 处理泛型
    String templateDecl = '';
    String typeParamList = '';
    if (procedure.function.typeParameters.isNotEmpty) {
      final typeParams = procedure.function.typeParameters
          .map((p) => 'typename ${p.name}')
          .join(', ');
      templateDecl = 'template<$typeParams>\n';
      typeParamList =
          '<${procedure.function.typeParameters.map((p) => p.name).join(', ')}>';
    } else if (procedure.enclosingClass!.typeParameters.isNotEmpty) {
      final typeParams = procedure.enclosingClass!.typeParameters
          .map((p) => 'typename ${p.name}')
          .join(', ');
      templateDecl = 'template<$typeParams>\n';
      typeParamList =
          '<${procedure.enclosingClass!.typeParameters.map((p) => p.name).join(', ')}>';
    }

    final returnType = 'ObjectPtr<$className$typeParamList>';
    final params = _buildParameterListWithoutDefaults(procedure.function);

    if (templateDecl.isNotEmpty) {
      _writeLine(templateDecl.trim());
    }
    _writeLine('static $returnType $factoryName($params) {');

    if (procedure.function.body != null) {
      _indent();
      final body =
          statementConverter.convertStatement(procedure.function.body!);
      _writeLine(body);
      _unindent();
    }

    _writeLine('}');
    _writeLine('');
  }

  String _buildParameterListWithoutDefaults(FunctionNode function) {
    // 不带默认值的参数列表，用于函数定义
    final params = <String>[];

    for (final param in function.positionalParameters) {
      String type;
      if (param.type is FunctionType) {
        // 如果是函数类型，使用模板参数替代 std::function
        final funcType = param.type as FunctionType;
        final funcTypeIndex = function.positionalParameters.indexOf(param);
        final templateParamName = '_F${funcTypeIndex + 1}';
        type = CppTypeConverter.convertFunctionTypeWithTemplate(
            funcType, templateParamName);
      } else {
        type = CppTypeConverter.convertType(param.type);
      }

      var name = _sanitizeIdentifier(param.name ?? 'param');

      // 检查参数是否需要装箱（被闭包捕获的值类型参数）
      if (_boxingVars.containsKey(param) && _boxingVars[param]!.isParameter) {
        // 参数加_前缀
        name = '_$name';
      }

      params.add('$type $name');
    }

    for (final param in function.namedParameters) {
      String type;
      if (param.type is FunctionType) {
        // 如果是函数类型，使用模板参数替代 std::function
        final funcType = param.type as FunctionType;
        final funcTypeIndex = function.positionalParameters.length +
            function.namedParameters.indexOf(param);
        final templateParamName = '_F${funcTypeIndex + 1}';
        type = CppTypeConverter.convertFunctionTypeWithTemplate(
            funcType, templateParamName);
      } else {
        type = CppTypeConverter.convertType(param.type);
      }

      var name = _sanitizeIdentifier(param.name ?? 'param');

      // 检查参数是否需要装箱
      if (_boxingVars.containsKey(param) && _boxingVars[param]!.isParameter) {
        name = '_$name';
      }

      params.add('$type $name');
    }

    return params.join(', ');
  }

  /// 生成参数装箱代码
  String _generateParameterBoxingCode(FunctionNode function) {
    final boxingStatements = <String>[];

    // 处理位置参数
    for (final param in function.positionalParameters) {
      if (_boxingVars.containsKey(param) && _boxingVars[param]!.isParameter) {
        final boxingInfo = _boxingVars[param]!;
        final varName = boxingInfo.varName;
        final varType = CppTypeConverter.convertType(boxingInfo.varType);

        // 生成: ObjectPtr<_ValueBox<Type>> varName(new _ValueBox<Type>(_varName));
        boxingStatements.add(
            'ObjectPtr<_ValueBox<$varType>> $varName(new _ValueBox<$varType>(_$varName));');
      }
    }

    // 处理命名参数
    for (final param in function.namedParameters) {
      if (_boxingVars.containsKey(param) && _boxingVars[param]!.isParameter) {
        final boxingInfo = _boxingVars[param]!;
        final varName = boxingInfo.varName;
        final varType = CppTypeConverter.convertType(boxingInfo.varType);

        boxingStatements.add(
            'ObjectPtr<_ValueBox<$varType>> $varName(new _ValueBox<$varType>(_$varName));');
      }
    }

    return boxingStatements.join('\n');
  }

  String _buildParameterList(FunctionNode function) {
    final params = <String>[];

    // 位置参数
    final requiredCount = function.requiredParameterCount;
    for (int i = 0; i < function.positionalParameters.length; i++) {
      final param = function.positionalParameters[i];
      String type;
      if (param.type is FunctionType) {
        // 如果是函数类型，使用模板参数替代 std::function
        final funcType = param.type as FunctionType;
        final templateParamName = '_F${i + 1}';
        type = CppTypeConverter.convertFunctionTypeWithTemplate(
            funcType, templateParamName);
      } else {
        type = CppTypeConverter.convertType(param.type);
      }
      final name = param.name ?? 'param';

      // 如果是可选参数，添加默认值
      if (i >= requiredCount) {
        // 可选参数，添加默认值
        // 对于 ObjectPtr 类型，使用 Null；对于值类型，使用 Type(Null)
        if (type.startsWith('ObjectPtr<')) {
          params.add('$type $name = Null');
        } else {
          params.add('$type $name = $type(Null)');
        }
      } else {
        params.add('$type $name');
      }
    }

    // 命名参数 - 全部是可选的
    for (int i = 0; i < function.namedParameters.length; i++) {
      final param = function.namedParameters[i];
      String type;
      if (param.type is FunctionType) {
        // 如果是函数类型，使用模板参数替代 std::function
        final funcType = param.type as FunctionType;
        final templateParamName =
            '_F${function.positionalParameters.length + i + 1}';
        type = CppTypeConverter.convertFunctionTypeWithTemplate(
            funcType, templateParamName);
      } else {
        type = CppTypeConverter.convertType(param.type);
      }
      final name = param.name ?? 'param';
      // 命名参数需要默认值
      // 对于 ObjectPtr 类型，使用 Null；对于值类型，使用 Type(Null)
      if (type.startsWith('ObjectPtr<')) {
        params.add('$type $name = Null');
      } else {
        params.add('$type $name = $type(Null)');
      }
    }

    return params.join(', ');
  }

  String _transformFunctionBody(Statement body,
      {bool isVoidFunction = false, bool isSetter = false}) {
    String bodyCode = statementConverter.convertStatement(body);

    // 如果是 void 函数，检查最后一行是否是 return 语句
    if (isVoidFunction) {
      final trimmedBody = bodyCode.trim();
      // 检查最后一行是否以 return 开头（避免被 lambda 中的 return 误判）
      final lines = trimmedBody.split('\n');
      final lastLine = lines.isNotEmpty ? lines.last.trim() : '';

      // 如果最后一行不是 return 语句，添加 return Void;
      if (!lastLine.startsWith('return')) {
        if (bodyCode.isNotEmpty && !bodyCode.endsWith(';')) {
          bodyCode += ';';
        }
        if (bodyCode.isNotEmpty) {
          bodyCode += '\n';
        }
        bodyCode += 'return Void;';
      }
    }

    // 对于Setter，确保inlin语句返回赋值表达式的结果
    // 例如：this->_name = value; 应该变成 return this->_name = value;
    if (isSetter) {
      final trimmedBody = bodyCode.trim();
      final lines = trimmedBody.split('\n');
      final lastLine = lines.isNotEmpty ? lines.last.trim() : '';

      // 如果最后一行不是return语句但是赋值语句，添加return
      if (!lastLine.startsWith('return') &&
          lastLine.contains('=') &&
          lastLine.endsWith(';')) {
        // 移除最后的分号，添加return再加分号
        lines[lines.length - 1] = 'return ' + lastLine;
        bodyCode = lines.join('\n');
      }
    }

    return bodyCode;
  }

  bool _isAsyncFunction(FunctionNode function) {
    return function.asyncMarker == AsyncMarker.Async ||
        function.asyncMarker == AsyncMarker.AsyncStar;
  }

  bool _isPrivate(String name) {
    return name.startsWith('_');
  }

  /// 判断是否是运算符方法
  bool _isOperatorMethod(String name) {
    const operators = {
      '+',
      '-',
      '*',
      '/',
      '%',
      '~/',
      '==',
      '!=',
      '<',
      '>',
      '<=',
      '>=',
      '[]',
      '[]=',
      '&',
      '|',
      '^',
      '<<',
      '>>',
      '~',
      'unary-'
    };
    return operators.contains(name);
  }

  /// 将运算符方法名转换为 operator_ 前缀的方法名
  String _convertOperatorMethodName(String operatorName) {
    const operatorNameMap = {
      '+': 'operator_add',
      '-': 'operator_sub',
      '*': 'operator_mul',
      '/': 'operator_div',
      '%': 'operator_mod',
      '~/': 'operator_truncating_div',
      '==': 'operator_equals',
      '!=': 'operator_not_equals',
      '<': 'operator_less',
      '>': 'operator_greater',
      '<=': 'operator_less_equals',
      '>=': 'operator_greater_equals',
      '[]': 'operator_index',
      '[]=': 'operator_index_set',
      '&': 'operator_bitwise_and',
      '|': 'operator_bitwise_or',
      '^': 'operator_bitwise_xor',
      '<<': 'operator_shift_left',
      '>>': 'operator_shift_right',
      '~': 'operator_bitwise_not',
      'unary-': 'operator_negate',
    };
    return operatorNameMap[operatorName] ?? operatorName;
  }

  void _writeMainFunction(Component component) {
    _writeLine(
        '// ============================================================================');
    _writeLine('// 主函数');
    _writeLine(
        '// ============================================================================');
    _writeLine('');
    _writeLine('int main() {');
    _indent();
    _writeLine('try {');
    _indent();

    // 查找main函数（只在用户代码库中查找）
    for (final library in component.libraries) {
      // Skip system libraries
      if (_shouldSkipLibrary(library)) {
        continue;
      }

      for (final procedure in library.procedures) {
        if (procedure.name.text == 'main') {
          // main 函数在 C++ 中返回 int，不应该被当作 void 函数处理
          final body = _transformFunctionBody(procedure.function.body!,
              isVoidFunction: false);
          _writeLine(body);
          break;
        }
      }
    }

    _writeLine('return 0;');
    _unindent();
    _writeLine('} catch (const std::exception& e) {');
    _indent();
    _writeLine('std::cerr << "Error: " << e.what() << std::endl;');
    _writeLine('return 1;');
    _unindent();
    _writeLine('}');
    _unindent();
    _writeLine('}');
  }

  // 工具方法
  void _writeLine(String line) {
    _buffer.write('${'  ' * _indentLevel}$line\n');
  }

  void _indent() {
    _indentLevel++;
  }

  void _unindent() {
    if (_indentLevel > 0) {
      _indentLevel--;
    }
  }

  String _indentLine(String line) {
    return '${'  ' * (_indentLevel + 1)}$line';
  }
}

/// 主要转换函数
String transformDartToCpp(Component component, {String? inputFileName}) {
  final transformer = DartToCppTransformer();
  return transformer.transformComponent(component,
      inputFileName: inputFileName);
}

/// 编译入口函数
Future<void> compileDartToCpp(String inputFile, String outputFile) async {
  try {
    // 读取和解析Dart文件
    print('正在读取 Dart 文件: $inputFile');

    // 创建一个简单的组件用于演示
    // 注意：完整的实现需要解析真实的Dart源码或字节码文件
    print('创建演示组件...');
    final component = Component();

    // 添加一个简单的库用于测试
    final uri = Uri.parse('file://$inputFile');
    final library = Library(uri, fileUri: uri);
    component.libraries.add(library);

    print('注意: 这是一个简化的演示实现，不解析真实的Dart文件内容');

    // 转换为C++
    print('正在转换为 C++ 代码...');
    final transformer = DartToCppTransformer();
    final cppCode =
        transformer.transformComponent(component, inputFileName: inputFile);

    // 注意：不再需要后处理，所有标识符已在生成时正确处理
    var processedCode = cppCode;

    // 写入输出文件
    print('正在写入 C++ 文件: $outputFile');
    await File(outputFile).writeAsString(processedCode);

    // 生成头文件
    final headerOutputFile = outputFile.replaceAll('.cpp', '.h');
    print('正在写入头文件: $headerOutputFile');
    final headerCode = transformer.generateHeaderContent(inputFile);
    await File(headerOutputFile).writeAsString(headerCode);

    print('✅ 转换完成！');
    print('生成的 C++ 文件: $outputFile');
    print('生成的头文件: $headerOutputFile');
  } catch (e, stackTrace) {
    print('❌ 转换失败: $e');
    print('堆栈跟踪: $stackTrace');
    rethrow;
  }
}

/// 为每个Dart文件生成对应的头文件
Future<void> generateHeaderForDart(
    String inputFile, String headerOutputFile) async {
  try {
    // 读取和解析Dart文件
    print('正在读取 Dart 文件: $inputFile');

    // 创建一个简单的组件用于演示
    // 注意：完整的实现需要解析真实的Dart源码或字节码文件
    print('创建演示组件...');
    final component = Component();

    // 添加一个简单的库用于测试
    final uri = Uri.parse('file://$inputFile');
    final library = Library(uri, fileUri: uri);
    component.libraries.add(library);

    print('注意: 这是一个简化的演示实现，不解析真实的Dart文件内容');

    // 转换为C++并生成头文件
    print('正在生成头文件...');
    final transformer = DartToCppTransformer();
    // 只生成头文件内容，不生成完整的cpp代码
    final headerCode = transformer.generateHeaderContent(inputFile);

    // 写入头文件
    print('正在写入头文件: $headerOutputFile');
    await File(headerOutputFile).writeAsString(headerCode);

    print('✅ 头文件生成完成！');
    print('生成的头文件: $headerOutputFile');
  } catch (e, stackTrace) {
    print('❌ 头文件生成失败: $e');
    print('堆栈跟踪: $stackTrace');
    rethrow;
  }
}

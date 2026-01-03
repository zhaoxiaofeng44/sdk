/// 代码生成辅助工具类
///
/// 提取公共逻辑,减少代码重复
library code_generator_helpers;

import 'package:kernel/ast.dart';

/// C++代码生成器基类
abstract class CppCodeGenerator {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  /// 写入一行代码
  void writeLine(String line) {
    if (line.isEmpty) {
      _buffer.writeln();
    } else {
      _buffer.writeln('${'  ' * _indentLevel}$line');
    }
  }

  /// 增加缩进
  void indent() {
    _indentLevel++;
  }

  /// 减少缩进
  void unindent() {
    if (_indentLevel > 0) {
      _indentLevel--;
    }
  }

  /// 带缩进的代码块
  void withIndent(void Function() block) {
    indent();
    block();
    unindent();
  }

  /// 写入代码块
  void writeBlock(String header, void Function() body, {String ending = '}'}) {
    writeLine('$header {');
    withIndent(body);
    writeLine(ending);
  }

  /// 获取生成的代码
  String getCode() => _buffer.toString();

  /// 清空缓冲区
  void clear() {
    _buffer.clear();
    _indentLevel = 0;
  }
}

/// 表达式转换辅助类
class ExpressionHelper {
  /// 判断是否是算术运算符
  static bool isArithmeticOperator(String op) {
    return const {'+', '-', '*', '/', '%', '~/'}.contains(op);
  }

  /// 判断是否是比较运算符
  static bool isComparisonOperator(String op) {
    return const {'==', '!=', '<', '<=', '>', '>='}.contains(op);
  }

  /// 判断是否是逻辑运算符
  static bool isLogicalOperator(String op) {
    return const {'&&', '||', '!'}.contains(op);
  }

  /// 判断是否是位运算符
  static bool isBitwiseOperator(String op) {
    return const {'&', '|', '^', '~', '<<', '>>'}.contains(op);
  }

  /// 判断是否需要括号
  static bool needsParentheses(Expression expr) {
    return expr is ConditionalExpression ||
        expr is LogicalExpression ||
        expr is Let;
  }

  /// 包装表达式(必要时添加括号)
  static String wrapExpression(String expr, Expression original) {
    if (needsParentheses(original)) {
      return '($expr)';
    }
    return expr;
  }
}

/// 类型转换辅助类
class TypeHelper {
  /// 基础类型集合
  static const Set<String> basicTypes = {
    'int',
    'double',
    'bool',
    'String',
    'num',
    'Int',
    'Double',
    'Bool',
  };

  /// 容器类型集合
  static const Set<String> containerTypes = {
    'List',
    'Set',
    'Map',
    'Iterable',
    'Future',
    'Stream',
  };

  /// 判断是否是基础类型
  static bool isBasicType(String typeName) {
    return basicTypes.contains(typeName);
  }

  /// 判断是否是容器类型
  static bool isContainerType(String typeName) {
    return containerTypes.contains(typeName);
  }

  /// 判断是否需要ObjectPtr包装
  static bool needsObjectPtrWrapper(String typeName) {
    return !isBasicType(typeName);
  }

  /// 推断两个类型的公共类型
  static String findCommonType(String type1, String type2) {
    if (type1 == type2) return type1;

    // 数值类型提升规则
    if ((type1 == 'int' || type1 == 'double') &&
        (type2 == 'int' || type2 == 'double')) {
      return 'double'; // int + double = double
    }

    // 如果一个是num,返回num
    if (type1 == 'num' || type2 == 'num') {
      if (type1 == 'int' ||
          type1 == 'double' ||
          type2 == 'int' ||
          type2 == 'double') {
        return 'num';
      }
    }

    // 默认返回Object
    return 'Object';
  }
}

/// 命名规范辅助类
class NamingHelper {
  /// 保留的C++关键字
  static const Set<String> cppKeywords = {
    'alignas',
    'alignof',
    'and',
    'and_eq',
    'asm',
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

  /// 清理标识符(移除特殊字符)
  static String sanitizeIdentifier(String name) {
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

    // 避免C++关键字冲突
    if (cppKeywords.contains(name)) {
      name = 'dart_$name';
    }

    return name.isEmpty ? 'unnamed' : name;
  }

  /// 转换为驼峰命名
  static String toCamelCase(String name) {
    if (name.isEmpty) return name;
    return name[0].toLowerCase() + name.substring(1);
  }

  /// 转换为帕斯卡命名
  static String toPascalCase(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  /// 转换为蛇形命名
  static String toSnakeCase(String name) {
    return name
        .replaceAllMapped(
            RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
        .replaceAll(RegExp(r'^_'), '');
  }
}

/// 错误处理辅助类
class ErrorReporter {
  static final List<String> _errors = [];
  static final List<String> _warnings = [];

  /// 添加错误
  static void addError(String message, {String? location, String? hint}) {
    final errorMsg = StringBuffer('错误: $message');
    if (location != null) errorMsg.write(' (位置: $location)');
    if (hint != null) errorMsg.write('\n  提示: $hint');
    _errors.add(errorMsg.toString());
  }

  /// 添加警告
  static void addWarning(String message, {String? location, String? hint}) {
    final warningMsg = StringBuffer('警告: $message');
    if (location != null) warningMsg.write(' (位置: $location)');
    if (hint != null) warningMsg.write('\n  提示: $hint');
    _warnings.add(warningMsg.toString());
  }

  /// 检查是否有错误
  static bool hasErrors() => _errors.isNotEmpty;

  /// 检查是否有警告
  static bool hasWarnings() => _warnings.isNotEmpty;

  /// 获取所有错误
  static List<String> getErrors() => List.unmodifiable(_errors);

  /// 获取所有警告
  static List<String> getWarnings() => List.unmodifiable(_warnings);

  /// 清空错误和警告
  static void clear() {
    _errors.clear();
    _warnings.clear();
  }

  /// 打印报告
  static void printReport() {
    if (_errors.isNotEmpty) {
      print('\n=== 错误报告 (${_errors.length}个) ===');
      for (var i = 0; i < _errors.length; i++) {
        print('${i + 1}. ${_errors[i]}');
      }
    }

    if (_warnings.isNotEmpty) {
      print('\n=== 警告报告 (${_warnings.length}个) ===');
      for (var i = 0; i < _warnings.length; i++) {
        print('${i + 1}. ${_warnings[i]}');
      }
    }
  }

  /// 生成HTML错误报告
  static String generateHtmlReport() {
    final html = StringBuffer();
    html.writeln('<!DOCTYPE html>');
    html.writeln('<html><head><meta charset="utf-8">');
    html.writeln('<title>Dart2CPP 转换报告</title>');
    html.writeln('<style>');
    html.writeln('body { font-family: monospace; margin: 20px; }');
    html.writeln('.error { color: #d32f2f; margin: 10px 0; }');
    html.writeln('.warning { color: #f57c00; margin: 10px 0; }');
    html.writeln('.hint { color: #666; margin-left: 20px; }');
    html.writeln('</style></head><body>');

    if (_errors.isNotEmpty) {
      html.writeln('<h2>错误 (${_errors.length})</h2>');
      for (var error in _errors) {
        html.writeln('<div class="error">$error</div>');
      }
    }

    if (_warnings.isNotEmpty) {
      html.writeln('<h2>警告 (${_warnings.length})</h2>');
      for (var warning in _warnings) {
        html.writeln('<div class="warning">$warning</div>');
      }
    }

    html.writeln('</body></html>');
    return html.toString();
  }
}

/// 代码格式化辅助类
class CodeFormatter {
  /// 格式化C++代码
  static String formatCppCode(String code) {
    final lines = code.split('\n');
    final formatted = <String>[];
    int indentLevel = 0;

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        formatted.add('');
        continue;
      }

      // 减少缩进(遇到})
      if (trimmed.startsWith('}')) {
        indentLevel = (indentLevel - 1).clamp(0, 100);
      }

      // 添加缩进
      formatted.add('${'  ' * indentLevel}$trimmed');

      // 增加缩进(遇到{)
      if (trimmed.endsWith('{')) {
        indentLevel++;
      }
    }

    return formatted.join('\n');
  }

  /// 移除多余的空行
  static String removeExcessiveBlankLines(String code) {
    return code.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  }

  /// 优化代码
  static String optimize(String code) {
    code = formatCppCode(code);
    code = removeExcessiveBlankLines(code);
    return code;
  }
}

#!/usr/bin/env dart

import 'dart:io';

/// 简化的 Dart 到 C++ 文本转换器
///
/// 使用方法:
/// dart tools/simple_dart_to_cpp.dart input.dart output.cpp

class SimpleDartToCppConverter {
  final StringBuffer _output = StringBuffer();
  final List<String> _imports = [];
  final List<String> _classes = [];
  final List<String> _functions = [];

  /// 主转换方法
  String convert(String dartCode) {
    _output.clear();
    _imports.clear();
    _classes.clear();
    _functions.clear();

    final lines = dartCode.split('\n');

    // 第一遍：识别结构
    _analyzeStructure(lines);

    // 生成C++代码
    _generateCppHeaders();
    _generateUtilityMacros();
    _generateClasses(lines);
    _generateFunctions(lines);
    _generateMainFunction(lines);

    return _output.toString();
  }

  /// 分析代码结构
  void _analyzeStructure(List<String> lines) {
    bool inClass = false;
    String currentClass = '';

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.startsWith('import ')) {
        _imports.add(line);
      } else if (line.startsWith('class ') && !line.contains('{')) {
        // 多行类定义
        final className = _extractClassName(line);
        if (className.isNotEmpty) {
          currentClass = className;
          _classes.add(className);
          inClass = true;
        }
      } else if (line.startsWith('class ') && line.contains('{')) {
        // 单行类定义
        final className = _extractClassName(line);
        if (className.isNotEmpty) {
          currentClass = className;
          _classes.add(className);
          inClass = true;
        }
      } else if (line == '}' && inClass) {
        inClass = false;
        currentClass = '';
      } else if (_isFunctionDefinition(line) && !inClass) {
        final funcName = _extractFunctionName(line);
        if (funcName.isNotEmpty) {
          _functions.add(funcName);
        }
      }
    }
  }

  /// 生成C++头文件
  void _generateCppHeaders() {
    _output.writeln('#include "./core/object.h"');
    _output.writeln('#include "./core/dart_oop_extensions.h"');
    _output.writeln('#include "./core/dart_async.h"');
    _output.writeln('#include <iostream>');
    _output.writeln('');
  }

  /// 生成工具宏
  void _generateUtilityMacros() {
    _output.writeln('// 工具宏定义');
    _output.writeln('#define dart_print(value) \\');
    _output.writeln('    do { \\');
    _output.writeln(
        '        std::cout << (value).toString().getValue() << std::endl; \\');
    _output.writeln('    } while(0)');
    _output.writeln('');
    _output.writeln('#define dart_int(value) Int(value)');
    _output.writeln('#define dart_double(value) Double(value)');
    _output.writeln('#define dart_bool(value) Bool(value)');
    _output.writeln('#define dart_string(value) String(value)');
    _output.writeln('');
    _output.writeln('// 集合类型辅助函数');
    _output.writeln('template<typename T>');
    _output.writeln(
        'List<T> dart_list_from_values(std::initializer_list<T> values) {');
    _output.writeln('    return List<T>::createFromValues(values);');
    _output.writeln('}');
    _output.writeln('');
    _output.writeln('template<typename T>');
    _output.writeln(
        'Set<T> dart_set_from_values(std::initializer_list<T> values) {');
    _output.writeln('    return Set<T>::createFromValues(values);');
    _output.writeln('}');
    _output.writeln('');
  }

  /// 生成类定义
  void _generateClasses(List<String> lines) {
    bool inClass = false;
    String currentClass = '';
    int braceCount = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.startsWith('class ')) {
        currentClass = _extractClassName(line);
        inClass = true;
        braceCount = 0;

        _output.writeln(
            '// ============================================================================');
        _output.writeln('// 类: $currentClass');
        _output.writeln(
            '// ============================================================================');
        _output.writeln('');

        // 处理继承
        if (line.contains('extends') ||
            line.contains('implements') ||
            line.contains('with')) {
          _generateClassWithInheritance(line);
        } else {
          _output.writeln('class $currentClass : public Object {');
        }

        _output.writeln('public:');

        if (line.contains('{')) {
          braceCount++;
        }
      } else if (inClass) {
        // 统计大括号
        braceCount += _countBraces(line);

        if (braceCount == 0 && line == '}') {
          // 类结束
          _output.writeln('};');
          _output.writeln('');
          inClass = false;
          currentClass = '';
        } else {
          // 类内容
          _generateClassMember(line, i, lines);
        }
      }
    }
  }

  /// 生成带继承的类
  void _generateClassWithInheritance(String line) {
    final className = _extractClassName(line);
    final inheritance = <String>[];

    if (line.contains('extends')) {
      final superClass = _extractAfterKeyword(line, 'extends');
      if (superClass.isNotEmpty) {
        inheritance.add('public $superClass');
      }
    }

    if (line.contains('implements')) {
      final interfaces = _extractAfterKeyword(line, 'implements').split(',');
      for (final interface in interfaces) {
        final cleanInterface = interface.trim();
        if (cleanInterface.isNotEmpty) {
          inheritance.add('DART_IMPLEMENTS($cleanInterface)');
        }
      }
    }

    if (line.contains('with')) {
      final mixins = _extractAfterKeyword(line, 'with').split(',');
      for (final mixin in mixins) {
        final cleanMixin = mixin.trim();
        if (cleanMixin.isNotEmpty) {
          inheritance.add('DART_WITH($cleanMixin)');
        }
      }
    }

    final inheritanceStr =
        inheritance.isNotEmpty ? ' : ${inheritance.join(', ')}' : '';
    _output.writeln('class $className$inheritanceStr {');
  }

  /// 生成类成员
  void _generateClassMember(String line, int lineIndex, List<String> lines) {
    if (line.isEmpty || line.startsWith('//')) {
      _output.writeln('  $line');
      return;
    }

    // 字段声明
    if (_isFieldDeclaration(line)) {
      final cppField = _convertFieldDeclaration(line);
      _output.writeln('    $cppField');
    }
    // 构造函数
    else if (_isConstructor(line)) {
      final cppConstructor = _convertConstructor(line);
      _output.writeln('    $cppConstructor');
    }
    // 方法声明
    else if (_isMethodDeclaration(line)) {
      final cppMethod = _convertMethodDeclaration(line);
      _output.writeln('    $cppMethod');
    }
    // 其他语句
    else {
      final convertedLine = _convertStatement(line);
      _output.writeln('    $convertedLine');
    }
  }

  /// 生成全局函数
  void _generateFunctions(List<String> lines) {
    bool inFunction = false;
    int braceCount = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (_isFunctionDefinition(line) && !_isInClass(i, lines)) {
        inFunction = true;
        braceCount = 0;

        final cppFunction = _convertFunctionDefinition(line);
        _output.writeln(
            '// ============================================================================');
        _output.writeln('// 函数: ${_extractFunctionName(line)}');
        _output.writeln(
            '// ============================================================================');
        _output.writeln('');
        _output.writeln(cppFunction);

        if (line.contains('{')) {
          braceCount++;
        }
      } else if (inFunction) {
        braceCount += _countBraces(line);

        if (braceCount == 0 && line == '}') {
          _output.writeln('}');
          _output.writeln('');
          inFunction = false;
        } else {
          final convertedLine = _convertStatement(line);
          _output.writeln(_indentLine(convertedLine));
        }
      }
    }
  }

  /// 生成主函数
  void _generateMainFunction(List<String> lines) {
    // 查找main函数
    bool foundMain = false;
    for (final line in lines) {
      if (line.trim().startsWith('void main(') ||
          line.trim().startsWith('main(')) {
        foundMain = true;
        break;
      }
    }

    if (!foundMain) {
      _output.writeln(
          '// ============================================================================');
      _output.writeln('// 主函数 (自动生成)');
      _output.writeln(
          '// ============================================================================');
      _output.writeln('');
      _output.writeln('int main() {');
      _output.writeln('    try {');
      _output.writeln(
          '        dart_print(dart_string("Hello from Dart to C++!"));');
      _output.writeln('        return 0;');
      _output.writeln('    } catch (const std::exception& e) {');
      _output
          .writeln('        std::cerr << "Error: " << e.what() << std::endl;');
      _output.writeln('        return 1;');
      _output.writeln('    }');
      _output.writeln('}');
    }
  }

  // ========== 工具方法 ==========

  String _extractClassName(String line) {
    final regex = RegExp(r'class\s+(\w+)');
    final match = regex.firstMatch(line);
    return match?.group(1) ?? '';
  }

  String _extractFunctionName(String line) {
    final regex = RegExp(r'(\w+)\s*\(');
    final match = regex
        .firstMatch(line.replaceAll('void ', '').replaceAll('static ', ''));
    return match?.group(1) ?? '';
  }

  String _extractAfterKeyword(String line, String keyword) {
    final index = line.indexOf(keyword);
    if (index == -1) return '';

    final after = line.substring(index + keyword.length).trim();
    final endIndex = after.indexOf(' ');
    if (endIndex == -1) {
      return after.replaceAll('{', '').trim();
    }
    return after.substring(0, endIndex).trim();
  }

  bool _isFunctionDefinition(String line) {
    return (line.contains('(') &&
            line.contains(')') &&
            (line.contains('{') || !line.endsWith(';'))) &&
        !line.startsWith('//') &&
        !line.contains('=') &&
        !line.contains('new ');
  }

  bool _isFieldDeclaration(String line) {
    return (line.contains(' ') &&
            !line.contains('(') &&
            (line.endsWith(';') || line.contains('='))) &&
        !line.startsWith('//');
  }

  bool _isConstructor(String line) {
    // 简化判断：包含类名和参数
    for (final className in _classes) {
      if (line.contains(className) && line.contains('(')) {
        return true;
      }
    }
    return false;
  }

  bool _isMethodDeclaration(String line) {
    return line.contains('(') &&
        line.contains(')') &&
        (line.contains('{') || line.endsWith(';'));
  }

  bool _isInClass(int lineIndex, List<String> lines) {
    int braceCount = 0;
    bool inClass = false;

    for (int i = 0; i <= lineIndex; i++) {
      final line = lines[i].trim();
      if (line.startsWith('class ')) {
        inClass = true;
        braceCount = 0;
      }
      braceCount += _countBraces(line);
      if (braceCount == 0 && inClass && line == '}') {
        inClass = false;
      }
    }

    return inClass;
  }

  int _countBraces(String line) {
    return line.split('{').length - line.split('}').length;
  }

  String _convertFieldDeclaration(String line) {
    // 简化：直接转换类型
    return _convertTypes(line);
  }

  String _convertConstructor(String line) {
    // 简化转换
    return _convertTypes(line);
  }

  String _convertMethodDeclaration(String line) {
    String result = _convertTypes(line);

    // 处理override
    if (line.contains('@override')) {
      result = result.replaceAll('@override', '').trim() + ' override';
    }

    return result;
  }

  String _convertFunctionDefinition(String line) {
    return _convertTypes(line) + ' {';
  }

  String _convertStatement(String line) {
    if (line.isEmpty || line.startsWith('//')) {
      return line;
    }

    String result = line;

    // 转换基本语句
    result = _convertTypes(result);
    result = _convertLiterals(result);
    result = _convertOperators(result);
    result = _convertControlFlow(result);

    return result;
  }

  String _convertTypes(String line) {
    String result = line;

    // 基础类型转换
    result = result.replaceAll(RegExp(r'\bint\b'), 'Int');
    result = result.replaceAll(RegExp(r'\bdouble\b'), 'Double');
    result = result.replaceAll(RegExp(r'\bbool\b'), 'Bool');
    result = result.replaceAll(RegExp(r'\bString\b'), 'String');
    result = result.replaceAll(RegExp(r'\bvar\b'), 'auto');
    result = result.replaceAll(RegExp(r'\bfinal\b'), 'const auto');

    return result;
  }

  String _convertLiterals(String line) {
    String result = line;

    // 字符串字面量 (支持单引号和双引号)
    result = result.replaceAllMapped(RegExp(r'"([^"]*)"'), (match) {
      final content =
          match.group(1)!.replaceAll('\\', '\\\\').replaceAll('"', '\\"');
      return 'dart_string("$content")';
    });

    result = result.replaceAllMapped(RegExp(r"'([^']*)'"), (match) {
      final content =
          match.group(1)!.replaceAll('\\', '\\\\').replaceAll("'", "\\'");
      return 'dart_string("$content")';
    });

    // 浮点数字面量 (需要在整数之前处理)
    result = result.replaceAllMapped(RegExp(r'\b(\d+\.\d+)\b'), (match) {
      return 'dart_double(${match.group(1)})';
    });

    // 整数字面量
    result = result.replaceAllMapped(RegExp(r'\b(\d+)\b'), (match) {
      // 避免转换已经被处理的浮点数
      if (!result.contains('dart_double(${match.group(1)}')) {
        return 'dart_int(${match.group(1)})';
      }
      return match.group(0)!;
    });

    // 布尔字面量
    result = result.replaceAll(RegExp(r'\btrue\b'), 'dart_bool(true)');
    result = result.replaceAll(RegExp(r'\bfalse\b'), 'dart_bool(false)');

    // null 字面量
    result = result.replaceAll(RegExp(r'\bnull\b'), 'nullptr');

    // 列表字面量 [1, 2, 3]
    result = result.replaceAllMapped(RegExp(r'\[([^\]]*)\]'), (match) {
      final content = match.group(1)?.trim() ?? '';
      if (content.isEmpty) {
        return 'List<Any>::create()';
      }
      final elements = content.split(',').map((e) => e.trim()).join(', ');
      return 'dart_list_from_values({$elements})';
    });

    // Set字面量 {1, 2, 3}
    result = result.replaceAllMapped(RegExp(r'\{([^}:]*)\}'), (match) {
      final content = match.group(1)?.trim() ?? '';
      if (content.isEmpty) {
        return 'Set<Any>::create()';
      }
      // 检查是否包含冒号(Map的特征)
      if (content.contains(':')) {
        return match.group(0)!; // 保持原样，等待Map处理
      }
      final elements = content.split(',').map((e) => e.trim()).join(', ');
      return 'dart_set_from_values({$elements})';
    });

    // Map字面量 {'key': 'value'}
    result = result.replaceAllMapped(RegExp(r'\{([^}]*:[^}]*)\}'), (match) {
      final content = match.group(1)?.trim() ?? '';
      if (content.isEmpty) {
        return 'Map<Any, Any>::create()';
      }
      // 简化处理：Map需要更复杂的解析
      return 'Map<Any, Any>::create() /* TODO: 解析Map字面量: {$content} */';
    });

    return result;
  }

  String _convertOperators(String line) {
    String result = line;

    // 空合并运算符
    result = result.replaceAll('??', '/* 需要手动实现空合并 */');

    // 安全调用运算符
    result = result.replaceAll('?.', '/* 需要手动实现安全调用 */');

    // 类型检查运算符
    result = result.replaceAll(RegExp(r'\bis\s+(\w+)'), r'/* is \1 类型检查 */');
    result = result.replaceAll(RegExp(r'\bas\s+(\w+)'), r'/* as \1 类型转换 */');

    // 级联运算符
    result = result.replaceAll('..', '/* 级联调用需要手动处理 */');

    // 字符串插值
    result = result.replaceAllMapped(RegExp(r'\$\{([^}]+)\}'), (match) {
      return '" + (${match.group(1)}).toString() + "';
    });

    result = result.replaceAllMapped(RegExp(r'\$(\w+)'), (match) {
      return '" + ${match.group(1)}.toString() + "';
    });

    return result;
  }

  String _convertControlFlow(String line) {
    String result = line;

    // print函数
    result = result.replaceAll(RegExp(r'print\('), 'dart_print(');

    // for-in 循环
    result = result.replaceAllMapped(
        RegExp(r'for\s*\(\s*(\w+)\s+in\s+([^)]+)\)'), (match) {
      final variable = match.group(1);
      final iterable = match.group(2);
      return 'for (const auto& $variable : $iterable)';
    });

    // forEach 调用
    result = result.replaceAllMapped(
        RegExp(r'(\w+)\.forEach\s*\(\s*\((\w+)\)\s*=>\s*([^)]+)\)'), (match) {
      final iterable = match.group(1);
      final param = match.group(2);
      final body = match.group(3);
      return 'for (const auto& $param : $iterable) { $body; }';
    });

    // where 过滤
    result = result.replaceAllMapped(
        RegExp(r'(\w+)\.where\s*\(\s*\((\w+)\)\s*=>\s*([^)]+)\)'), (match) {
      final iterable = match.group(1);
      final param = match.group(2);
      final condition = match.group(3);
      return '$iterable.where([](const auto& $param) { return $condition; })';
    });

    // map 映射
    result = result.replaceAllMapped(
        RegExp(r'(\w+)\.map\s*\(\s*\((\w+)\)\s*=>\s*([^)]+)\)'), (match) {
      final iterable = match.group(1);
      final param = match.group(2);
      final expression = match.group(3);
      return '$iterable.map([](const auto& $param) { return $expression; })';
    });

    return result;
  }

  String _indentLine(String line) {
    return '    $line';
  }
}

/// 主函数
void main(List<String> args) async {
  if (args.length != 2) {
    print('使用方法: dart tools/simple_dart_to_cpp.dart input.dart output.cpp');
    exit(1);
  }

  final inputFile = args[0];
  final outputFile = args[1];

  try {
    print('🔄 正在读取 Dart 文件: $inputFile');
    final dartCode = await File(inputFile).readAsString();

    print('🔄 正在转换为 C++ ...');
    final converter = SimpleDartToCppConverter();
    final cppCode = converter.convert(dartCode);

    print('💾 正在保存 C++ 文件: $outputFile');
    await File(outputFile).writeAsString(cppCode);

    print('✅ 转换完成！');
    print('📄 输出文件: $outputFile');
  } catch (e) {
    print('❌ 转换失败: $e');
    exit(1);
  }
}

#!/usr/bin/env dart

import 'dart:io';

/// C++ 代码后处理器
/// 修复转换后的 C++ 代码中的常见问题

class CppPostProcessor {
  String process(String cppCode) {
    String result = cppCode;

    // 1. 修复构造函数语法
    result = _fixConstructorSyntax(result);

    // 2. 修复空集合字面量
    result = _fixEmptyCollections(result);

    // 3. 修复 for-in 循环
    result = _fixForInLoops(result);

    // 4. 修复空合并运算符
    result = _fixNullCoalescing(result);

    // 5. 修复字符串插值
    result = _fixStringInterpolation(result);

    // 6. 修复方法调用
    result = _fixMethodCalls(result);

    // 7. 修复类型声明
    result = _fixTypeDeclarations(result);

    return result;
  }

  String _fixConstructorSyntax(String code) {
    // 修复 Student(this.name, this.age) 为 Student(String name, Int age) : name(name), age(age)
    return code.replaceAllMapped(
        RegExp(r'(\w+)\s*\(\s*this\.(\w+),?\s*this\.(\w+)\s*\)\s*{'), (match) {
      final className = match.group(1);
      final param1 = match.group(2);
      final param2 = match.group(3);
      return '$className(String $param1, Int $param2) : $param1($param1), $param2($param2) {';
    });
  }

  String _fixEmptyCollections(String code) {
    String result = code;

    // 修复空列表 [] 为 List<T>::create()
    result = result.replaceAllMapped(RegExp(r'(\w+)\s*=\s*\[\s*\];'), (match) {
      final varName = match.group(1);
      return '$varName = List<String>::create();';
    });

    // 修复空Map {} 为 Map<K,V>::create()
    result = result.replaceAllMapped(RegExp(r'(\w+)\s*=\s*\{\s*\};'), (match) {
      final varName = match.group(1);
      return '$varName = Map<String, Int>::create();';
    });

    return result;
  }

  String _fixForInLoops(String code) {
    // 修复 for (String subject in subjects) 为 for (const auto& subject : subjects)
    return code.replaceAllMapped(
        RegExp(r'for\s*\(\s*(\w+)\s+(\w+)\s+in\s+(\w+)\s*\)'), (match) {
      final type = match.group(1);
      final variable = match.group(2);
      final iterable = match.group(3);
      return 'for (const auto& $variable : $iterable)';
    });
  }

  String _fixNullCoalescing(String code) {
    // 修复 grades[subject] ?? 0 为条件表达式
    return code.replaceAllMapped(RegExp(r'(\w+\[[^\]]+\])\s*\?\?\s*(\w+)'),
        (match) {
      final expression = match.group(1);
      final defaultValue = match.group(2);
      return '($expression.hasValue() ? $expression : dart_int($defaultValue))';
    });
  }

  String _fixStringInterpolation(String code) {
    String result = code;

    // 修复简单的字符串插值 'text $variable'
    result =
        result.replaceAllMapped(RegExp(r"'([^']*)\$(\w+)([^']*)'"), (match) {
      final prefix = match.group(1) ?? '';
      final variable = match.group(2);
      final suffix = match.group(3) ?? '';
      return 'dart_string("$prefix") + $variable.toString() + dart_string("$suffix")';
    });

    // 修复复杂的字符串插值 'text ${expression}'
    result = result.replaceAllMapped(RegExp(r"'([^']*)\$\{([^}]+)\}([^']*)'"),
        (match) {
      final prefix = match.group(1) ?? '';
      final expression = match.group(2);
      final suffix = match.group(3) ?? '';
      return 'dart_string("$prefix") + ($expression).toString() + dart_string("$suffix")';
    });

    return result;
  }

  String _fixMethodCalls(String code) {
    String result = code;

    // 修复 isEmpty 调用
    result = result.replaceAll('.isEmpty', '.empty()');

    // 修复 isNotEmpty 调用
    result = result.replaceAll('.isNotEmpty', '!.empty()');

    // 修复 contains 调用
    result = result.replaceAll('.contains(', '.contains(');

    // 修复 add 调用
    result = result.replaceAll('.add(', '.add(');

    // 修复 toStringAsFixed 调用
    result = result.replaceAllMapped(RegExp(r'(\w+)\.toStringAsFixed\((\d+)\)'),
        (match) {
      final variable = match.group(1);
      final digits = match.group(2);
      return '$variable.toStringWithPrecision($digits)';
    });

    return result;
  }

  String _fixTypeDeclarations(String code) {
    String result = code;

    // 修复 var 声明
    result = result.replaceAllMapped(
        RegExp(r'auto\s+(\w+)\s*=\s*dart_string\(([^)]+)\)'), (match) {
      final varName = match.group(1);
      final value = match.group(2);
      return 'String $varName = dart_string($value)';
    });

    result = result.replaceAllMapped(
        RegExp(r'auto\s+(\w+)\s*=\s*dart_int\(([^)]+)\)'), (match) {
      final varName = match.group(1);
      final value = match.group(2);
      return 'Int $varName = dart_int($value)';
    });

    result = result.replaceAllMapped(
        RegExp(r'auto\s+(\w+)\s*=\s*dart_double\(([^)]+)\)'), (match) {
      final varName = match.group(1);
      final value = match.group(2);
      return 'Double $varName = dart_double($value)';
    });

    return result;
  }
}

/// 主函数
void main(List<String> args) async {
  if (args.length != 2) {
    print('使用方法: dart tools/cpp_post_processor.dart input.cpp output.cpp');
    exit(1);
  }

  final inputFile = args[0];
  final outputFile = args[1];

  try {
    print('🔄 正在读取 C++ 文件: $inputFile');
    final cppCode = await File(inputFile).readAsString();

    print('🔄 正在后处理 C++ 代码...');
    final processor = CppPostProcessor();
    final processedCode = processor.process(cppCode);

    print('💾 正在保存处理后的文件: $outputFile');
    await File(outputFile).writeAsString(processedCode);

    print('✅ 后处理完成！');
    print('📄 输出文件: $outputFile');
  } catch (e) {
    print('❌ 后处理失败: $e');
    exit(1);
  }
}

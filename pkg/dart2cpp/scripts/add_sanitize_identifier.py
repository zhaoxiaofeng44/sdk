#!/usr/bin/env python3
"""
为 dart_to_cpp_compiler.dart 添加 _sanitizeIdentifier 支持
这个脚本会：
1. 在文件顶部添加 _sanitizeIdentifier 函数
2. 替换所有的 .name.text 为 _sanitizeIdentifier(xxx.name.text)
3. 替换所有的 param.name 为 _sanitizeIdentifier(param.name ?? '')
"""

import re
import sys

def add_sanitize_identifier(content):
    # 1. 在 imports 后添加 _sanitizeIdentifier 函数
    import_pattern = r"(import 'dart:math' as math;)"
    sanitize_func = r"""\1

/// 清理标识符名称，将特殊字符替换为下划线
/// 这对于扩展方法（如 Extension|method）和特殊参数名（如 #this）特别重要
String _sanitizeIdentifier(String name) {
  // 替换所有非字母数字下划线的字符为下划线
  return name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
}"""
    
    content = re.sub(import_pattern, sanitize_func, content)
    
    # 2. 替换 .name.text（但要小心不要破坏其他部分）
    # 匹配模式：单词.name.text，但不匹配已经被 _sanitizeIdentifier 包裹的
    content = re.sub(
        r'(?<!_sanitizeIdentifier\()(\w+)\.name\.text(?!\))',
        r'_sanitizeIdentifier(\1.name.text)',
        content
    )
    
    # 3. 替换 param.name（在参数相关的上下文中）
    # 这个比较复杂，我们只替换明显的情况
    content = re.sub(
        r'\bparam\.name\b(?!\s*\?\?)',
        r'_sanitizeIdentifier(param.name ?? "")',
        content
    )
    
    return content

def main():
    input_file = 'lib/dart_to_cpp_compiler.dart'
    output_file = 'lib/dart_to_cpp_compiler.dart'
    
    # 读取文件
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 处理
    new_content = add_sanitize_identifier(content)
    
    # 写回文件
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print("✅ Successfully added _sanitizeIdentifier support")
    print(f"Modified file: {output_file}")

if __name__ == '__main__':
    main()

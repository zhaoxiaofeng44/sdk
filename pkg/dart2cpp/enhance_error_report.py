#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
为错误分析报告添加代码片段
"""

import os
import re

WORKSPACE = "/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp"
REPORT_FILE = "SAMPLE_TESTS_ERROR_ANALYSIS.md"

def extract_error_line_number(error_msg):
    """从错误信息中提取行号"""
    match = re.search(r':(\d+):', error_msg)
    if match:
        return int(match.group(1))
    return None

def read_code_snippet(file_path, line_num, context_lines=5):
    """读取指定行附近的代码片段"""
    if not os.path.exists(file_path):
        return None
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        start = max(0, line_num - context_lines - 1)
        end = min(len(lines), line_num + context_lines)
        
        snippet_lines = []
        for i in range(start, end):
            line_marker = " ➤ " if i == line_num - 1 else "   "
            snippet_lines.append(f"{i+1:4d}{line_marker}{lines[i].rstrip()}")
        
        return '\n'.join(snippet_lines)
    except Exception as e:
        return f"读取失败: {str(e)}"

def find_related_dart_code(dart_file, cpp_file, cpp_error_line):
    """根据C++错误位置智能查找对应的Dart代码片段"""
    if not os.path.exists(dart_file) or not os.path.exists(cpp_file):
        return None, None
    
    try:
        # 读取C++文件，分析错误位置的上下文
        with open(cpp_file, 'r', encoding='utf-8') as f:
            cpp_lines = f.readlines()
        
        # 读取Dart文件
        with open(dart_file, 'r', encoding='utf-8') as f:
            dart_lines = f.readlines()
        
        # 从C++错误行向上查找函数名或关键信息
        error_context = find_error_context(cpp_lines, cpp_error_line)
        
        # 在Dart文件中查找对应的代码位置
        dart_line_num = find_dart_location(dart_lines, error_context)
        
        if dart_line_num:
            # 返回Dart代码的上下文
            dart_snippet = read_code_snippet_from_lines(dart_lines, dart_line_num, context_lines=8)
            return dart_snippet, dart_line_num
        else:
            # 如果找不到精确位置，返回文件开头部分
            dart_snippet = read_code_snippet_from_lines(dart_lines, 1, context_lines=15)
            return dart_snippet, None
    except Exception as e:
        return None, None

def find_error_context(cpp_lines, error_line):
    """从C++错误行提取上下文信息"""
    context = {
        'function_name': None,
        'class_name': None,
        'error_line_content': None
    }
    
    if error_line <= len(cpp_lines):
        context['error_line_content'] = cpp_lines[error_line - 1].strip()
    
    # 向上查找函数名
    for i in range(max(0, error_line - 20), error_line):
        line = cpp_lines[i].strip()
        # 查找函数定义
        if '(' in line and ')' in line and '{' not in line:
            # 提取函数名
            match = re.search(r'(\w+)\s*\(', line)
            if match:
                context['function_name'] = match.group(1)
                break
    
    return context

def find_dart_location(dart_lines, context):
    """在Dart文件中查找对应位置"""
    function_name = context['function_name']
    
    if function_name:
        # 查找同名函数定义
        for i, line in enumerate(dart_lines):
            # 区分大小写匹配，包括各种函数定义格式
            if function_name in line:
                # 检查是否是函数定义
                if ('void' in line or 'Future' in line or 'int' in line or 'String' in line or 'var' in line or 'class' in line) and '(' in line:
                    # 确保函数名在括号前
                    func_pattern = rf'\b{re.escape(function_name)}\s*\('
                    if re.search(func_pattern, line):
                        # 找到函数定义，向下查找函数体开头
                        for j in range(i, min(i + 5, len(dart_lines))):
                            if '{' in dart_lines[j] or 'print' in dart_lines[j] or 'var' in dart_lines[j] or 'List' in dart_lines[j]:
                                return j + 1
                        return i + 1
    
    # 如果找不到，返回main函数位置
    for i, line in enumerate(dart_lines):
        if 'void main' in line or 'main()' in line:
            return i + 1
    
    return None

def read_code_snippet_from_lines(lines, line_num, context_lines=5):
    """从代码行列表中读取指定行的上下文"""
    start = max(0, line_num - context_lines - 1)
    end = min(len(lines), line_num + context_lines)
    
    snippet_lines = []
    for i in range(start, end):
        line_marker = " ➤ " if i == line_num - 1 else "   "
        snippet_lines.append(f"{i+1:4d}{line_marker}{lines[i].rstrip()}")
    
    return '\n'.join(snippet_lines)

def enhance_report():
    """增强报告内容"""
    report_path = f"{WORKSPACE}/{REPORT_FILE}"
    
    if not os.path.exists(report_path):
        print(f"报告文件不存在: {report_path}")
        return
    
    with open(report_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 查找所有失败的测试用例
    pattern = r'### \d+\. `([^`]+)`\s+\*\*文件位置\*\*: `([^`]+)`\s+\*\*生成文件\*\*: `([^`]+)`\s+\*\*主要错误\*\*:\s+```([^`]+)```'
    
    matches = list(re.finditer(pattern, content, re.MULTILINE | re.DOTALL))
    
    print(f"找到 {len(matches)} 个失败的测试用例")
    
    enhanced_content = content
    offset = 0
    
    for match in matches:
        filename = match.group(1)
        dart_path = match.group(2)
        cpp_path = match.group(3)
        error_block = match.group(4)
        
        print(f"\n处理: {filename}")
        
        # 提取第一个错误的行号
        first_error_line = extract_error_line_number(error_block)
        
        # 构建代码片段部分
        code_section = "\n\n**📋 代码片段对比**:\n\n"
        
        # Dart代码片段
        full_dart_path = f"{WORKSPACE}/{dart_path}"
        full_cpp_path = f"{WORKSPACE}/{cpp_path}"
        dart_snippet, dart_line_num = find_related_dart_code(full_dart_path, full_cpp_path, first_error_line)
        
        if dart_snippet:
            code_section += "<details>\n<summary>📄 Dart源代码 (错误相关位置)</summary>\n\n"
            code_section += f"```dart\n{dart_snippet}\n```\n\n"
            if dart_line_num:
                code_section += f"**对应位置**: 第 {dart_line_num} 行附近\n\n"
            code_section += "</details>\n\n"
        
        # C++代码片段
        if first_error_line:
            cpp_snippet = read_code_snippet(full_cpp_path, first_error_line, context_lines=8)
            
            if cpp_snippet:
                code_section += "<details>\n<summary>⚠️ 生成的C++代码 (错误位置)</summary>\n\n"
                code_section += f"```cpp\n{cpp_snippet}\n```\n\n"
                code_section += f"**错误行**: 第 {first_error_line} 行 (标记为 ➤)\n\n"
                code_section += "</details>\n"
        
        # 在"错误类别"之前插入代码片段
        insert_pos = match.end() + offset
        # 查找下一个"**错误类别**"的位置
        next_category_match = re.search(r'\*\*错误类别\*\*:', enhanced_content[insert_pos:insert_pos+500])
        
        if next_category_match:
            actual_insert_pos = insert_pos + next_category_match.start()
            enhanced_content = enhanced_content[:actual_insert_pos] + code_section + enhanced_content[actual_insert_pos:]
            offset += len(code_section)
    
    # 写回文件
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(enhanced_content)
    
    print(f"\n✅ 报告已增强: {report_path}")

if __name__ == '__main__':
    os.chdir(WORKSPACE)
    enhance_report()

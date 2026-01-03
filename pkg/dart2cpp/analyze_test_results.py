#!/usr/bin/env python3
"""分析测试结果并生成错误报告"""

import json
import re
from collections import defaultdict

# 读取JSON结果
with open('sample_test_summary.json', 'r') as f:
    data = json.load(f)

test_results = data['test_results']
summary = data['summary']

# 分析结果
compilation_errors = defaultdict(list)
runtime_errors = []
success_cases = []

for result in test_results:
    filename = result['filename']
    
    if result['compilation'] == 'failed':
        error_msg = result.get('compilation_error', '')
        # 提取关键错误信息
        error_lines = error_msg.split('\n')
        key_errors = set()
        for line in error_lines:
            if 'error:' in line:
                # 提取error后面的内容
                match = re.search(r'error:\s*(.+)', line)
                if match:
                    key_errors.add(match.group(1).strip())
        
        for error in list(key_errors)[:3]:  # 只保留前3个不同的错误
            compilation_errors[error].append(filename)
    
    elif result['execution'] == 'failed':
        runtime_errors.append(filename)
    
    elif result['execution'] == 'success':
        success_cases.append(filename)

# 汇总错误类型
error_categories = {
    '未定义标识符(_GrowableList等)': [],
    'SentinelValue未定义': [],
    'DART_ASYNC_FUNCTION宏参数错误': [],
    '模板参数重复声明': [],
    '类型转换错误': [],
    'Setter返回类型错误': [],
    'Mixin继承语法错误': [],
    'Lambda表达式语法错误': [],
    '成员访问错误': [],
    '其他错误': []
}

for error, files in compilation_errors.items():
    error_lower = error.lower()
    if '_growablelist' in error_lower or 'undeclared identifier' in error_lower:
        error_categories['未定义标识符(_GrowableList等)'].extend(files)
    elif 'sentinelvalue' in error_lower:
        error_categories['SentinelValue未定义'].extend(files)
    elif 'dart_async_function' in error_lower or 'too many arguments' in error_lower and 'macro' in error_lower:
        error_categories['DART_ASYNC_FUNCTION宏参数错误'].extend(files)
    elif 'shadows template parameter' in error_lower or 'extraneous template' in error_lower:
        error_categories['模板参数重复声明'].extend(files)
    elif 'no viable conversion' in error_lower:
        error_categories['类型转换错误'].extend(files)
    elif 'return type' in error_lower and 'nullable' in error_lower:
        error_categories['Setter返回类型错误'].extend(files)
    elif 'base class' in error_lower or '&object&' in error_lower:
        error_categories['Mixin继承语法错误'].extend(files)
    elif 'expected body of lambda' in error_lower:
        error_categories['Lambda表达式语法错误'].extend(files)
    elif 'no member named' in error_lower:
        error_categories['成员访问错误'].extend(files)
    else:
        error_categories['其他错误'].extend(files)

# 去重
for key in error_categories:
    error_categories[key] = list(set(error_categories[key]))

print("=== 测试结果汇总 ===")
print(f"总文件数: {summary['total_files']}")
print(f"转换成功: {summary['conversion']['success']}")
print(f"转换失败: {summary['conversion']['failed']}")
print(f"编译成功: {summary['compilation']['success']}")
print(f"编译失败: {summary['compilation']['failed']}")
print(f"运行成功: {summary['execution']['success']}")
print(f"运行失败: {summary['execution']['failed']}")
print()

print("=== 成功的测试用例 ===")
for case in success_cases:
    print(f"✓ {case}")
print()

print("=== 运行失败的测试用例 ===")
for case in runtime_errors:
    print(f"✗ {case} (编译成功但运行超时)")
print()

print("=== 编译错误分类统计 ===")
for category, files in error_categories.items():
    if files:
        print(f"\n{category} ({len(files)}个文件):")
        for f in files[:5]:  # 只显示前5个
            print(f"  - {f}")
        if len(files) > 5:
            print(f"  ... 还有 {len(files)-5} 个文件")

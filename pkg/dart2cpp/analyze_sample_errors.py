#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
分析Sample测试用例的错误，生成可交互的Markdown报告
"""

import subprocess
import os
import re
from collections import defaultdict

WORKSPACE = "/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp"
OUTPUT_DIR = "sample/cpp_generated"

# 错误分类和解决方案
ERROR_PATTERNS = {
    "_GrowableList": {
        "category": "类型转换错误",
        "reason": "List字面量被转换为_GrowableList，但运行时库中不存在此类型",
        "solutions": [
            "修改编译器生成代码逻辑，将_GrowableList替换为List::create和add方法",
            "在C++运行时库中实现_GrowableList辅助类",
            "使用List<T>::_literal方法替代_GrowableList"
        ]
    },
    "no member named.*in 'Object'": {
        "category": "成员访问错误",
        "reason": "在基类Object上访问派生类的成员变量，类型转换不正确",
        "solutions": [
            "修复编译器的类型推导，确保正确使用派生类指针",
            "在比较或访问成员前添加类型转换",
            "使用ObjectPtr的模板特化正确处理成员访问"
        ]
    },
    "Comparable": {
        "category": "接口缺失错误",
        "reason": "Dart的Comparable接口在C++运行时库中未定义",
        "solutions": [
            "在C++运行时库中实现Comparable模板类",
            "移除Comparable接口的使用，改用运算符重载",
            "为需要比较的类手动实现compareTo方法"
        ]
    },
    "RegExp.*create.*5 arguments": {
        "category": "API参数不匹配",
        "reason": "RegExp::create方法调用时参数数量不匹配，生成代码传入5个参数但定义只支持最多4个",
        "solutions": [
            "修改编译器的RegExp转换逻辑，使用正确的参数数量",
            "扩展运行时库的RegExp::create方法支持5个参数",
            "使用命名参数的方式调用RegExp构造函数"
        ]
    },
    "redefinition of 'StringExtensions'": {
        "category": "扩展方法冲突",
        "reason": "扩展方法生成为namespace但与运行时库中的class重名",
        "solutions": [
            "修改编译器生成扩展方法为独立函数而非namespace",
            "重命名生成的扩展为UserStringExtensions避免冲突",
            "将扩展方法内联到使用位置"
        ]
    },
    "expected ';' after top level declarator.*\\|": {
        "category": "语法错误",
        "reason": "扩展方法名称生成包含|符号，这在C++中是非法的",
        "solutions": [
            "修改编译器将|替换为合法的分隔符如_",
            "使用下划线命名法生成扩展方法名",
            "采用模板特化方式实现扩展方法"
        ]
    },
    "Future.*is not a class": {
        "category": "静态方法调用错误",
        "reason": "Future的静态方法调用方式不正确，应该使用模板形式",
        "solutions": [
            "修改编译器生成Future::delayed为Future<T>::delayed",
            "使用makeFuture辅助函数替代静态方法",
            "调整运行时库的Future API设计"
        ]
    },
    "List.*is not a class, namespace": {
        "category": "静态方法调用错误",
        "reason": "List::from等静态方法调用不正确",
        "solutions": [
            "修改为List<T>::from调用形式",
            "使用List工厂函数替代静态方法",
            "实现List的辅助工厂方法"
        ]
    },
    "no member named 'message'": {
        "category": "异常类成员访问错误",
        "reason": "异常类的message成员应为message_（带下划线）",
        "solutions": [
            "修改编译器生成异常类时使用message_命名",
            "在运行时库中添加message()的getter方法",
            "统一异常类的成员命名规范"
        ]
    },
    "no matching constructor.*DatabaseException": {
        "category": "异常类继承构造错误",
        "reason": "Dart的异常继承构造方式与C++不同，需要显式定义构造函数",
        "solutions": [
            "为异常基类添加带参数的构造函数",
            "修改编译器生成异常类继承时正确调用基类构造",
            "使用初始化列表而非继承构造"
        ]
    },
    "DartException": {
        "category": "throw语句生成错误",
        "reason": "throw语句应该直接throw对象而非DartException包装",
        "solutions": [
            "修改编译器生成throw为直接抛出异常对象",
            "在运行时库中定义DartException包装类",
            "统一异常处理机制"
        ]
    },
    "unknown escape sequence.*\\\\\\$": {
        "category": "字符串转义错误",
        "reason": "字符串插值中的$符号被错误转义",
        "solutions": [
            "修改编译器的字符串插值处理，移除$的转义",
            "使用原始字符串字面量",
            "正确处理字符串模板中的特殊字符"
        ]
    },
    "no viable conversion.*String.*to.*ObjectPtr<Object>": {
        "category": "返回类型不匹配",
        "reason": "函数返回类型为ObjectPtr<Object>但返回了String值类型",
        "solutions": [
            "修改编译器推导返回类型为String而非ObjectPtr<Object>",
            "使用ValuePtr<String>包装返回值",
            "添加自动装箱机制将值类型转换为ObjectPtr"
        ]
    },
    "invalid target type.*for dynamic_cast": {
        "category": "类型转换错误",
        "reason": "dart_cast尝试将对象转换为值类型，但值类型不支持dynamic_cast",
        "solutions": [
            "修改dart_cast模板支持值类型转换",
            "使用dart_as进行值类型转换",
            "实现专门的值类型转换函数"
        ]
    },
    "not polymorphic": {
        "category": "类型检查错误",
        "reason": "dart_is对非多态类型执行dynamic_cast失败",
        "solutions": [
            "修改dart_is模板特化处理值类型",
            "为值类型实现独立的类型检查机制",
            "使用typeid替代dynamic_cast进行类型检查"
        ]
    },
    "Type.*of.*TypeParameterType": {
        "category": "泛型类型信息错误",
        "reason": "泛型参数类型信息生成错误，包含非法的语法",
        "solutions": [
            "修复编译器的泛型类型反射生成逻辑",
            "使用typeid或模板特化获取类型信息",
            "简化泛型toString的实现"
        ]
    },
    "member initializer.*does not name": {
        "category": "构造函数初始化错误",
        "reason": "泛型类继承时构造函数初始化列表语法错误",
        "solutions": [
            "修改为Box<T>(value)或使用模板基类别名",
            "调整编译器生成泛型继承的构造函数",
            "显式指定基类模板参数"
        ]
    },
    "use of class template.*requires template arguments": {
        "category": "泛型类型缺失",
        "reason": "泛型类使用时缺少模板参数",
        "solutions": [
            "修改编译器在使用泛型类时自动添加模板参数",
            "使用auto推导类型",
            "明确指定模板参数"
        ]
    },
    "union": {
        "category": "C++关键字冲突",
        "reason": "变量名union是C++关键字",
        "solutions": [
            "修改编译器将C++关键字自动重命名为union_等",
            "维护关键字黑名单进行自动转换",
            "使用sanitize机制处理标识符"
        ]
    }
}

def classify_error(error_msg):
    """对错误信息进行分类"""
    for pattern, info in ERROR_PATTERNS.items():
        if re.search(pattern, error_msg, re.IGNORECASE):
            return info
    return {
        "category": "未分类错误",
        "reason": "需要进一步分析",
        "solutions": [
            "查看生成的C++代码定位问题",
            "对比成功案例找出差异",
            "检查编译器转换逻辑"
        ]
    }

def compile_and_get_error(dart_file):
    """编译单个文件并获取错误信息"""
    filename = os.path.basename(dart_file).replace('.dart', '')
    cpp_file = f"{OUTPUT_DIR}/{filename}.cpp"
    
    if not os.path.exists(cpp_file):
        return None, "转换失败或文件不存在"
    
    compile_cmd = [
        'g++', '-std=c++17', '-I', 'cpp/core',
        cpp_file,
        'cpp/core/dart_object.cpp',
        'cpp/core/dart_string.cpp',
        '-o', f'{OUTPUT_DIR}/{filename}'
    ]
    
    result = subprocess.run(
        compile_cmd,
        capture_output=True,
        text=True,
        cwd=WORKSPACE
    )
    
    if result.returncode == 0:
        return None, None  # 编译成功
    
    return result.stderr, result.returncode

def extract_first_errors(error_output, max_errors=5):
    """提取前几个主要错误"""
    if not error_output:
        return []
    
    # 分割错误行
    error_lines = []
    for line in error_output.split('\n'):
        if ': error:' in line or ': fatal error:' in line:
            error_lines.append(line)
    
    return error_lines[:max_errors]

def analyze_all_tests():
    """分析所有测试用例"""
    dart_dir = f"{WORKSPACE}/sample/dart"
    dart_files = sorted([f for f in os.listdir(dart_dir) if f.endswith('.dart')])
    
    success_tests = []
    failed_tests = []
    
    for dart_file in dart_files:
        full_path = f"sample/dart/{dart_file}"
        error_output, return_code = compile_and_get_error(full_path)
        
        if error_output is None and return_code is None:
            success_tests.append(dart_file)
        else:
            failed_tests.append({
                'file': dart_file,
                'error_output': error_output or "编译失败但无错误输出",
                'return_code': return_code
            })
    
    return success_tests, failed_tests

def generate_markdown_report(success_tests, failed_tests):
    """生成Markdown报告"""
    md_lines = []
    
    # 标题和摘要
    md_lines.append("# Sample测试用例错误分析报告\n")
    md_lines.append(f"**生成时间**: {subprocess.run(['date'], capture_output=True, text=True).stdout.strip()}\n")
    md_lines.append("## 📊 测试摘要\n")
    total = len(success_tests) + len(failed_tests)
    md_lines.append(f"- **总测试数**: {total}")
    md_lines.append(f"- **✅ 成功**: {len(success_tests)} ({len(success_tests)*100//total}%)")
    md_lines.append(f"- **❌ 失败**: {len(failed_tests)} ({len(failed_tests)*100//total}%)\n")
    
    # 成功用例列表
    if success_tests:
        md_lines.append("## ✅ 编译成功的测试用例\n")
        for test in success_tests:
            md_lines.append(f"- `{test}`")
        md_lines.append("")
    
    # 失败用例详细分析
    if failed_tests:
        md_lines.append("## ❌ 编译失败的测试用例详细分析\n")
        
        # 按错误类型分组
        errors_by_category = defaultdict(list)
        
        for idx, test in enumerate(failed_tests, 1):
            md_lines.append(f"### {idx}. `{test['file']}`\n")
            md_lines.append(f"**文件位置**: `sample/dart/{test['file']}`  ")
            md_lines.append(f"**生成文件**: `sample/cpp_generated/{test['file'].replace('.dart', '.cpp')}`\n")
            
            # 提取主要错误
            main_errors = extract_first_errors(test['error_output'], max_errors=3)
            
            if main_errors:
                md_lines.append("**主要错误**:\n")
                for err in main_errors:
                    # 清理错误消息
                    err_clean = err.strip()
                    if len(err_clean) > 200:
                        err_clean = err_clean[:200] + "..."
                    md_lines.append(f"```\n{err_clean}\n```\n")
                
                # 分类第一个错误
                classification = classify_error(main_errors[0])
                errors_by_category[classification['category']].append(test['file'])
                
                md_lines.append(f"**错误类别**: {classification['category']}\n")
                md_lines.append(f"**问题原因**: {classification['reason']}\n")
                md_lines.append("**解决方案**:\n")
                
                for i, solution in enumerate(classification['solutions'], 1):
                    md_lines.append(f"- [ ] **方案{i}**: {solution}")
                
                md_lines.append("- [ ] **其他方案**: <请在此处输入其他解决方案或补充信息>\n")
            else:
                md_lines.append("**错误信息**: 无具体错误输出\n")
                md_lines.append("**解决方案**:")
                md_lines.append("- [ ] 检查转换过程是否成功")
                md_lines.append("- [ ] 查看详细的编译日志")
                md_lines.append("- [ ] **其他方案**: <请在此处输入>\n")
            
            md_lines.append("---\n")
        
        # 错误类型统计
        md_lines.append("## 📈 错误类型统计\n")
        for category, files in sorted(errors_by_category.items(), key=lambda x: len(x[1]), reverse=True):
            md_lines.append(f"### {category} ({len(files)}个)\n")
            for f in files:
                md_lines.append(f"- `{f}`")
            md_lines.append("")
    
    # 后续步骤
    md_lines.append("## 🔧 建议的修复优先级\n")
    md_lines.append("- [ ] **高优先级**: 修复`_GrowableList`相关错误 (影响最多测试)")
    md_lines.append("- [ ] **中优先级**: 修复静态方法调用错误 (Future/List相关)")
    md_lines.append("- [ ] **中优先级**: 修复类型转换和类型检查错误")
    md_lines.append("- [ ] **低优先级**: 修复扩展方法命名冲突")
    md_lines.append("- [ ] **低优先级**: 完善异常处理机制\n")
    
    md_lines.append("## 📝 备注\n")
    md_lines.append("- 可以直接在每个解决方案前勾选 `[x]` 表示已采纳")
    md_lines.append("- 在\"其他方案\"后的尖括号中输入自定义方案")
    md_lines.append("- 建议优先处理影响多个测试用例的共性问题\n")
    
    return '\n'.join(md_lines)

def main():
    print("开始分析sample测试用例...")
    os.chdir(WORKSPACE)
    
    success_tests, failed_tests = analyze_all_tests()
    
    print(f"分析完成: {len(success_tests)} 成功, {len(failed_tests)} 失败")
    
    report = generate_markdown_report(success_tests, failed_tests)
    
    output_file = f"{WORKSPACE}/SAMPLE_TESTS_ERROR_ANALYSIS.md"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"报告已生成: {output_file}")

if __name__ == '__main__':
    main()

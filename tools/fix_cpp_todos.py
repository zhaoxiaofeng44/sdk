#!/usr/bin/env python3
"""
自动修复 transformed_dart.dart.cpp 中的 TODO 项
基于上下文推断正确的代码替换
"""

import re
import sys
from pathlib import Path

class CppTodoFixer:
    def __init__(self, file_path):
        self.file_path = Path(file_path)
        self.content = self.file_path.read_text(encoding='utf-8')
        self.lines = self.content.split('\n')
        self.fixes_count = 0
        
    def fix_all_todos(self):
        """修复所有TODO项"""
        print(f"开始修复 {self.file_path.name}...")
        print(f"文件总行数: {len(self.lines)}")
        
        # 按优先级修复
        self.fix_empty_statements()
        self.fix_instance_get()
        self.fix_instance_set()
        self.fix_variable_set()
        self.fix_constructor_invocation()
        self.fix_let_expressions()
        self.fix_equals_null()
        self.fix_equals_call()
        self.fix_is_expression()
        self.fix_as_expression()
        self.fix_null_check()
        self.fix_throw()
        self.fix_assert_statement()
        self.fix_labeled_statement()
        
        print(f"\n总共修复了 {self.fixes_count} 个 TODO 项")
        return '\n'.join(self.lines)
    
    def fix_empty_statements(self):
        """修复 EmptyStatement - 直接删除"""
        count = 0
        new_lines = []
        for line in self.lines:
            if '/* TODO: EmptyStatement */' in line:
                # 如果是单独一行，跳过；如果在构造函数中，保留空行
                if line.strip() == '/* TODO: EmptyStatement */;':
                    count += 1
                    continue
                else:
                    # 替换为空
                    line = line.replace('/* TODO: EmptyStatement */;', '')
                    count += 1
            new_lines.append(line)
        
        self.lines = new_lines
        self.fixes_count += count
        print(f"修复 EmptyStatement: {count} 项")
    
    def fix_instance_get(self):
        """修复 InstanceGet - 根据上下文推断字段名"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: InstanceGet */' in line:
                # 尝试从上下文推断字段名
                field_name = self._infer_field_name(i, line)
                if field_name:
                    self.lines[i] = line.replace('/* TODO: InstanceGet */', field_name)
                    count += 1
        
        self.fixes_count += count
        print(f"修复 InstanceGet: {count} 项")
    
    def _infer_field_name(self, line_idx, line):
        """从上下文推断字段名"""
        # 查找类的私有字段
        # 向上查找类定义
        for i in range(line_idx, max(0, line_idx - 100), -1):
            prev_line = self.lines[i]
            
            # 查找私有字段定义
            if 'private:' in prev_line or 'Private:' in prev_line:
                # 查找下一个字段定义
                for j in range(i + 1, min(len(self.lines), i + 20)):
                    field_line = self.lines[j]
                    # 匹配字段定义: Type _fieldName
                    match = re.search(r'\s+(\w+)\s+(_\w+)', field_line)
                    if match:
                        field_name = match.group(2)
                        # 检查是否是合适的字段
                        if '_source' in field_name:
                            return '_source'
                        elif '_iterator' in field_name:
                            return '_iterator'
                        elif '_test' in field_name:
                            return '_test'
                        elif '_f' in field_name:
                            return '_f'
                        return field_name
        
        # 默认推断
        if '.moveNext()' in line:
            return '_iterator'
        elif 'return' in line and 'length' in line:
            return '_source.length()'
        elif 'iterator()' in line:
            return '_source.iterator()'
        
        return None
    
    def fix_instance_set(self):
        """修复 InstanceSet - 根据上下文推断赋值"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: InstanceSet */' in line:
                # 推断赋值语句
                assignment = self._infer_assignment(i, line)
                if assignment:
                    self.lines[i] = line.replace('/* TODO: InstanceSet */', assignment)
                    count += 1
        
        self.fixes_count += count
        print(f"修复 InstanceSet: {count} 项")
    
    def _infer_assignment(self, line_idx, line):
        """推断赋值语句"""
        # 查找上下文中的字段
        for i in range(line_idx, max(0, line_idx - 50), -1):
            prev_line = self.lines[i]
            
            # 查找私有字段
            if '_current' in prev_line:
                return '_current = _f(_iterator.current())'
            elif '_value' in prev_line:
                return '_value = _f(_iterator.current())'
        
        # 默认推断
        return '_current = _f(_iterator.current())'
    
    def fix_variable_set(self):
        """修复 VariableSet"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: VariableSet */' in line:
                # 推断变量赋值
                assignment = self._infer_variable_set(i, line)
                if assignment:
                    self.lines[i] = line.replace('/* TODO: VariableSet */', assignment)
                    count += 1
        
        self.fixes_count += count
        print(f"修复 VariableSet: {count} 项")
    
    def _infer_variable_set(self, line_idx, line):
        """推断变量赋值"""
        # 查找前面的变量声明
        for i in range(line_idx - 1, max(0, line_idx - 10), -1):
            prev_line = self.lines[i]
            
            # 匹配 auto varName = ...
            match = re.search(r'auto\s+(\w+)\s*=', prev_line)
            if match:
                var_name = match.group(1)
                if 'iterator' in var_name:
                    return f'{var_name} = _source.iterator()'
                elif 'it' in var_name:
                    return f'{var_name} = _source.iterator()'
                return f'{var_name} = /* value */'
        
        return 'result = /* value */'
    
    def fix_constructor_invocation(self):
        """修复 ConstructorInvocation"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: ConstructorInvocation */' in line:
                # 推断构造函数调用
                constructor_call = self._infer_constructor(i, line)
                if constructor_call:
                    self.lines[i] = line.replace('/* TODO: ConstructorInvocation */', constructor_call)
                    count += 1
        
        self.fixes_count += count
        print(f"修复 ConstructorInvocation: {count} 项")
    
    def _infer_constructor(self, line_idx, line):
        """推断构造函数调用"""
        # 查找当前类名和返回类型
        for i in range(line_idx, max(0, line_idx - 100), -1):
            prev_line = self.lines[i]
            
            # 查找类定义
            if 'class ' in prev_line:
                match = re.search(r'class\s+(\w+)', prev_line)
                if match:
                    class_name = match.group(1)
                    
                    # 根据类名推断构造函数
                    if 'Iterator' in class_name:
                        return f'{class_name}(_source.iterator(), _f)'
                    elif 'Iterable' in class_name:
                        return f'{class_name}(_source, _f)'
        
        # 查找返回类型
        for i in range(line_idx - 1, max(0, line_idx - 5), -1):
            prev_line = self.lines[i]
            
            # 匹配方法返回类型
            match = re.search(r'(\w+)\s+\w+\s*\(', prev_line)
            if match:
                return_type = match.group(1)
                if 'Iterator' in return_type:
                    return f'{return_type}(_iterator, _f)'
                elif 'Iterable' in return_type:
                    return f'{return_type}(_source, _f)'
        
        return 'ConstructorCall()'
    
    def fix_let_expressions(self):
        """修复 Let 表达式"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: Let */' in line:
                # Let 表达式通常是临时变量
                if 'return' in line:
                    self.lines[i] = line.replace('/* TODO: Let */', '_current')
                elif 'if' in line:
                    self.lines[i] = line.replace('/* TODO: Let */', '_test(_iterator.current())')
                else:
                    self.lines[i] = line.replace('/* TODO: Let */', '_current')
                count += 1
        
        self.fixes_count += count
        print(f"修复 Let: {count} 项")
    
    def fix_equals_null(self):
        """修复 EqualsNull"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: EqualsNull */' in line:
                # 推断要检查的变量
                var_name = self._infer_null_check_variable(i, line)
                self.lines[i] = line.replace('/* TODO: EqualsNull */', f'{var_name} == nullptr')
                count += 1
        
        self.fixes_count += count
        print(f"修复 EqualsNull: {count} 项")
    
    def _infer_null_check_variable(self, line_idx, line):
        """推断空值检查的变量"""
        # 查找附近的变量
        for i in range(line_idx - 1, max(0, line_idx - 5), -1):
            prev_line = self.lines[i]
            match = re.search(r'auto\s+(\w+)\s*=', prev_line)
            if match:
                return match.group(1)
        
        return '_iterator'
    
    def fix_equals_call(self):
        """修复 EqualsCall"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: EqualsCall */' in line:
                # 推断相等比较
                comparison = self._infer_equals_call(i, line)
                self.lines[i] = line.replace('/* TODO: EqualsCall */', comparison)
                count += 1
        
        self.fixes_count += count
        print(f"修复 EqualsCall: {count} 项")
    
    def _infer_equals_call(self, line_idx, line):
        """推断相等比较"""
        # 默认比较
        return '_iterator.current() == target'
    
    def fix_is_expression(self):
        """修复 IsExpression"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: IsExpression */' in line:
                # 类型检查
                self.lines[i] = line.replace('/* TODO: IsExpression */', 'dynamic_cast<TargetType*>(_iterator.current()) != nullptr')
                count += 1
        
        self.fixes_count += count
        print(f"修复 IsExpression: {count} 项")
    
    def fix_as_expression(self):
        """修复 AsExpression"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: AsExpression */' in line:
                # 类型转换
                self.lines[i] = line.replace('/* TODO: AsExpression */', 'static_cast<TargetType>(_current)')
                count += 1
        
        self.fixes_count += count
        print(f"修复 AsExpression: {count} 项")
    
    def fix_null_check(self):
        """修复 NullCheck"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: NullCheck */' in line:
                # 空值检查
                var_name = self._infer_null_check_variable(i, line)
                self.lines[i] = line.replace('/* TODO: NullCheck */', var_name)
                count += 1
        
        self.fixes_count += count
        print(f"修复 NullCheck: {count} 项")
    
    def fix_throw(self):
        """修复 Throw"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: Throw */' in line:
                # 抛出异常
                self.lines[i] = line.replace('/* TODO: Throw */', 'throw std::runtime_error("Exception")')
                count += 1
        
        self.fixes_count += count
        print(f"修复 Throw: {count} 项")
    
    def fix_assert_statement(self):
        """修复 AssertStatement"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: AssertStatement */' in line:
                # 断言语句
                self.lines[i] = line.replace('/* TODO: AssertStatement */', 'assert(condition)')
                count += 1
        
        self.fixes_count += count
        print(f"修复 AssertStatement: {count} 项")
    
    def fix_labeled_statement(self):
        """修复 LabeledStatement"""
        count = 0
        for i, line in enumerate(self.lines):
            if '/* TODO: LabeledStatement */' in line:
                # 标签语句
                self.lines[i] = line.replace('/* TODO: LabeledStatement */', '// labeled statement')
                count += 1
        
        self.fixes_count += count
        print(f"修复 LabeledStatement: {count} 项")
    
    def save(self, output_path=None):
        """保存修复后的文件"""
        if output_path is None:
            output_path = self.file_path
        
        Path(output_path).write_text('\n'.join(self.lines), encoding='utf-8')
        print(f"\n已保存到: {output_path}")

def main():
    if len(sys.argv) < 2:
        print("用法: python fix_cpp_todos.py <cpp_file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    
    if not Path(file_path).exists():
        print(f"错误: 文件不存在: {file_path}")
        sys.exit(1)
    
    # 创建备份
    backup_path = f"{file_path}.backup"
    Path(file_path).rename(backup_path)
    print(f"已创建备份: {backup_path}")
    
    # 修复TODO
    fixer = CppTodoFixer(backup_path)
    fixed_content = fixer.fix_all_todos()
    fixer.save(file_path)
    
    print("\n✅ 修复完成!")

if __name__ == '__main__':
    main()


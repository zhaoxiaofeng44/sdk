# Dart2CPP C++ 测试套件

这个目录包含了 Dart2CPP 项目的 C++ 测试用例，用于验证核心功能的正确性。

## 测试文件结构

```
cpp/test/
├── basic_types_test.cpp      # 基础数据类型测试
├── operators_test.cpp        # 运算符重载测试  
├── macros_test.cpp          # 宏和工具测试
├── comprehensive_test.cpp    # 综合测试
├── Makefile                 # 构建配置
├── run_tests.sh            # 测试运行脚本
└── README.md               # 本文档
```

## 测试内容覆盖

### 1. 基础数据类型测试 (basic_types_test.cpp)
- **Int 类型**: 构造、算术运算、比较运算、位运算、属性方法
- **Double 类型**: 构造、算术运算、比较运算、舍入方法
- **Bool 类型**: 构造、逻辑运算、比较运算
- **扩展操作符**: 自增自减、复合赋值操作符
- **异常处理**: 除零异常等边界情况

### 2. 运算符重载测试 (operators_test.cpp)
- **算术运算符**: +, -, *, /, %, 一元运算符
- **比较运算符**: ==, !=, <, >, <=, >=
- **逻辑运算符**: &&, ||, !
- **位运算符**: &, |, ^, ~, <<, >>, >>>
- **赋值运算符**: +=, -=, *=, /=, %=
- **自增自减**: ++, -- (前置和后置)
- **运算符优先级**: 复杂表达式计算
- **特殊运算符**: 整除、无符号右移

### 3. 宏和工具测试 (macros_test.cpp)
- **类型构造宏**: dart_int, dart_double, dart_bool, dart_string
- **集合创建宏**: dart_list_*, dart_set_*, dart_map_*
- **特殊运算宏**: INTEGER_DIVISION, UNSIGNED_SHIFT_RIGHT
- **调试工具宏**: dart_print, dart_assert
- **宏嵌套使用**: 复杂表达式中的宏组合
- **性能测试**: 大量宏使用的性能验证

### 4. 综合测试 (comprehensive_test.cpp)
- **复杂数学运算**: 多步骤计算、浮点精度
- **位运算应用**: 权限管理、加密模拟
- **类型转换**: 混合类型运算、转换链
- **算法实现**: GCD算法、斐波那契数列
- **错误处理**: 综合异常处理测试
- **性能测试**: 大量运算的压力测试
- **实际应用**: 计算器模拟、数据处理

## 快速开始

### 使用 Makefile

```bash
# 编译所有测试
make

# 运行所有测试
make test

# 运行单个测试
make test-basic          # 基础类型测试
make test-operators      # 运算符测试
make test-macros         # 宏测试
make test-comprehensive  # 综合测试

# 清理构建文件
make clean

# 重新构建
make rebuild

# 编译调试版本
make debug

# 编译发布版本
make release
```

### 使用测试脚本

```bash
# 运行所有测试
./run_tests.sh

# 只编译测试
./run_tests.sh -b

# 运行指定测试
./run_tests.sh -t basic_types_test

# 生成测试报告
./run_tests.sh -r

# 清理构建文件
./run_tests.sh -c

# 查看帮助
./run_tests.sh -h
```

## 编译要求

- **编译器**: g++ (支持 C++11)
- **构建工具**: make
- **编译标志**: -std=c++11 -Wall -Wextra -O2

## 测试框架

测试使用自定义的轻量级测试框架，包含以下宏：

- `TEST(name)`: 定义测试函数
- `ASSERT_EQ(expected, actual)`: 断言相等
- `ASSERT_TRUE(condition)`: 断言为真
- `ASSERT_FALSE(condition)`: 断言为假
- `ASSERT_NEAR(expected, actual, tolerance)`: 断言近似相等
- `RUN_TEST(name)`: 运行测试并输出结果

## 测试覆盖率

当前测试覆盖了以下核心功能：

✅ 基础数据类型 (Int, Double, Bool, String)  
✅ 所有运算符重载  
✅ 宏定义系统  
✅ 类型转换  
✅ 异常处理  
✅ 边界情况  
✅ 性能测试  
✅ 实际应用场景  

## 贡献指南

添加新测试时请遵循以下规范：

1. 使用描述性的测试名称
2. 每个测试函数专注于单一功能
3. 包含正常情况和边界情况
4. 添加适当的错误处理测试
5. 更新 Makefile 和测试脚本

## 故障排除

### 编译错误
- 确保安装了 g++ 编译器
- 检查 C++11 支持
- 验证头文件路径正确

### 运行时错误
- 检查核心库是否正确编译
- 验证测试数据的有效性
- 查看详细错误信息

### 性能问题
- 使用发布版本进行性能测试
- 检查是否有内存泄漏
- 分析算法复杂度

## 许可证

本测试套件遵循与主项目相同的许可证。

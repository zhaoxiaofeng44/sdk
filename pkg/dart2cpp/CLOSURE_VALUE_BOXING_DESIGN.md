# 闭包值类型自动装箱功能设计文档

## 需求概述

扩展和强化闭包捕获值类型参数的自动装箱逻辑：

1. **检测被闭包持有的值类型变量**
   - 检测范围：int, double, bool, String (及其对应的 Int, Double, Bool)
   - 检测位置：局部变量和函数参数

2. **装箱策略**
   - **临时变量**：修改类型声明为 `ValuePtr<T>`
   - **函数参数**：
     - 参数名加 `_` 前缀（如 `start` → `_start`）
     - 在函数开始处定义 `ValuePtr<T>` 包装变量（如 `ValuePtr<Int> start(_start);`）

3. **装箱变量标记**
   - 维护装箱变量集合，用于后续运算中的特殊处理
   - 装箱变量在运算时需要使用 `*` 解引用或 `->`访问

## 实现方案

### 1. 数据结构

```dart
// 捕获变量信息类（已实现）
class CapturedVarInfo {
  final String name;
  final VariableDeclaration? declaration;
  final bool isParameter;
  final bool isValueType;
  final DartType? type;
}

// ExpressionConverter 新增字段（已实现）
final Map<String, String> _boxedVarMapping = {};  // 原始名 -> 装箱后名
final Set<String> _boxedVars = {};                // 装箱变量集合
```

### 2. 核心流程

#### 阶段1: 检测闭包捕获的值类型变量
- 在 `_collectCapturedVariablesDetailed()` 中收集详细信息
- 区分参数和局部变量
- 识别值类型

#### 阶段2: 标记需要装箱的变量
- 在 `_convertFunctionExpression()` 中分析捕获变量
- 对值类型变量进行标记

#### 阶段3: 生成装箱代码
- **参数装箱**：在 `_buildParameterList()` 和函数体开始处理
  ```cpp
  // 参数声明：Int _start
  // 函数体开始：ValuePtr<Int> start(_start);
  ```
- **局部变量装箱**：在 `_convertVariableDeclaration()` 中处理
  ```cpp
  // 原始：auto x = dart_int(10);
  // 装箱：ValuePtr<Int> x(dart_int(10));
  ```

#### 阶段4: 变量引用处理
- 在 `_convertVariableGet()` 中检查是否是装箱变量
- 如果是装箱变量，在合适的上下文中使用
- 对于赋值操作，直接使用（ValuePtr 支持 operator=）
- 对于运算操作，需要解引用

## 实现步骤

### Step 1: 改进捕获变量检测（已完成）
- [x] 创建 `CapturedVarInfo` 类
- [x] 实现 `_collectCapturedVariablesDetailed()`
- [x] 实现 `_isValueType()` 类型判断

### Step 2: 参数装箱处理
- [ ] 在函数作用域中记录参数信息
- [ ] 修改 `_writeProcedure()` 生成参数装箱代码
- [ ] 更新参数名映射

### Step 3: 局部变量装箱处理
- [ ] 在 `_convertVariableDeclaration()` 中检查是否被闭包捕获
- [ ] 生成 `ValuePtr<T>` 类型声明

### Step 4: 变量访问适配
- [ ] 更新 `_convertVariableGet()` 处理装箱变量
- [ ] 更新 `_convertVariableSet()` 处理装箱变量赋值

### Step 5: 闭包生成适配
- [ ] 在 `_convertFunctionExpression()` 中处理装箱变量引用
- [ ] 确保捕获数组正确使用装箱变量

## 关键难点

1. **作用域追踪**
   - 需要在整个函数编译过程中追踪哪些变量被闭包捕获
   - 需要在变量声明时就知道它是否会被捕获

2. **参数重命名**
   - 参数加前缀后，所有引用都需要更新
   - 需要维护参数名映射表

3. **类型推导**
   - ValuePtr 的模板参数需要正确推导
   - 确保与原值类型兼容

4. **运算符重载**
   - ValuePtr 已实现 operator= 和隐式转换
   - 需要确保在正确的上下文中使用

## 示例转换

### 示例1: 基础局部变量装箱

**Dart 代码：**
```dart
void test() {
  int x = 10;
  var increment = () {
    x = x + 1;
  };
  increment();
}
```

**期望 C++ 代码：**
```cpp
Nullable test() {
  ValuePtr<Int> x(dart_int(10));  // 装箱声明
  auto increment = makeFunction([&]() { 
    x = (*x) + dart_int(1);  // 使用解引用
  }, std::vector<Any>{Any(x)});
  increment->call();
  return Void;
}
```

### 示例2: 参数装箱

**Dart 代码：**
```dart
Function makeCounter(int start) {
  return () {
    start = start + 1;
    return start;
  };
}
```

**期望 C++ 代码：**
```cpp
ObjectPtr<Function> makeCounter(Int _start) {  // 参数加前缀
  ValuePtr<Int> start(_start);  // 函数开始处装箱
  return makeFunction([&]() { 
    start = (*start) + dart_int(1);
    return *start;
  }, std::vector<Any>{Any(start)});
}
```

## 注意事项

1. **只装箱被闭包持有的值类型变量**
   - 不影响其他变量的处理
   - 保持现有逻辑的正确性

2. **装箱变量标记**
   - 使用 `_boxedVars` 集合快速判断
   - 使用 `_boxedVarMapping` 维护名称映射

3. **兼容性**
   - 确保不影响现有测试用例
   - 渐进式实现，每个阶段都可以编译通过

## 测试计划

1. 基础值类型装箱测试
2. 参数装箱测试
3. 局部变量装箱测试
4. 混合装箱测试
5. 嵌套闭包测试
6. 回归测试（确保现有功能不受影响）

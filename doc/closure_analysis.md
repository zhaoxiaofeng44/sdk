# 闭包变量分析功能

## 概述

本文档描述了在 `compile_to_cpp.dart` 中新增的闭包变量分析功能。该功能用于分析 `FunctionExpression` 中引用的外部变量，以及更通用的 TreeNode 变量查询功能，这对于生成正确的 C++ 闭包代码至关重要。

## 核心类和方法

### ClosureVariable 类

```dart
class ClosureVariable {
  final VariableDeclaration variable;  // 变量声明节点
  final String name;                   // 变量名称
  final DartType type;                 // 变量类型
  final bool isParameter;              // 是否为参数
}
```

用于封装闭包中捕获的外部变量信息。

### 主要分析方法

#### findExternalVariables
```dart
List<ClosureVariable> findExternalVariables(FunctionExpression functionExpression)
```

分析给定的 `FunctionExpression`，返回其中引用的所有外部变量列表。

#### findVariableReferencesInNode（新增）
```dart
List<ClosureVariable> findVariableReferencesInNode(TreeNode node, [Set<VariableDeclaration>? localScope])
```

**通用的 TreeNode 变量查询方法**，可以分析任意 TreeNode 中的变量引用：
- `node`: 要分析的树节点（可以是 Statement、Expression、FunctionNode、Member、Class、Library 等）
- `localScope`: 可选的局部作用域变量集合，如果不提供则创建空集合
- 返回该节点中引用的所有变量列表

#### findVariableUsages（新增）
```dart
List<Expression> findVariableUsages(TreeNode node, VariableDeclaration targetVariable)
```

**查找特定变量的所有使用位置**：
- `node`: 要搜索的树节点
- `targetVariable`: 目标变量
- 返回引用该变量的所有表达式列表

## 功能特性

### 1. 通用 TreeNode 支持（新增）
- **Statement 节点**: Block、VariableDeclaration、ExpressionStatement、ReturnStatement、控制流语句等
- **Expression 节点**: 所有表达式类型
- **FunctionNode**: 函数节点，自动处理参数作为局部变量
- **Member 节点**: Procedure、Field 等成员
- **Class 节点**: 分析类的所有成员（字段、构造函数、方法）
- **Library 节点**: 分析库的所有顶级声明

### 2. 变量作用域分析
- 正确区分局部变量和外部变量
- 处理函数参数作为局部变量
- 支持嵌套作用域（如 for 循环、Let 表达式）

### 3. 支持的语句类型
- `Block`: 块语句
- `VariableDeclaration`: 变量声明
- `ExpressionStatement`: 表达式语句
- `ReturnStatement`: 返回语句
- `IfStatement`: 条件语句
- `WhileStatement`: while 循环
- `ForStatement`: for 循环（包含循环变量作用域处理）
- `DoStatement`: do-while 循环
- `SwitchStatement`: switch 语句
- `TryFinally`: try-finally 语句
- `FunctionDeclaration`: 嵌套函数声明

### 4. 支持的表达式类型
- `VariableGet`: 变量读取
- `VariableSet`: 变量赋值
- `FunctionExpression`: 嵌套函数表达式
- `ConditionalExpression`: 三元运算符
- `LogicalExpression`: 逻辑运算
- `InstanceInvocation`: 实例方法调用
- `StaticInvocation`: 静态方法调用
- `ConstructorInvocation`: 构造函数调用
- `InstanceGet/Set`: 实例属性访问
- `ListLiteral/SetLiteral/MapLiteral`: 集合字面量
- `StringConcatenation`: 字符串连接
- `AsExpression/IsExpression`: 类型转换和检查
- `Let`: Let 表达式
- `BlockExpression`: 块表达式
- 其他常见表达式类型

### 5. 嵌套函数处理
- 递归分析嵌套的 `FunctionExpression`
- 正确处理多层嵌套的变量捕获
- 避免重复添加相同的变量

## 使用示例

### 基本用法
```dart
var printer = CppCodePrinter();

// 分析 FunctionExpression 中的外部变量
var externalVars = printer.findExternalVariables(functionExpression);
for (var closureVar in externalVars) {
  print('外部变量: ${closureVar.name}, 类型: ${closureVar.type}');
}
```

### 通用 TreeNode 分析（新增）
```dart
var printer = CppCodePrinter();

// 分析任意 TreeNode 中的变量引用
var references = printer.findVariableReferencesInNode(someTreeNode);
for (var ref in references) {
  print('变量引用: ${ref.name}, 类型: ${ref.type}');
}

// 分析带有局部作用域的节点
var localVars = <VariableDeclaration>{/* 局部变量 */};
var referencesWithScope = printer.findVariableReferencesInNode(someTreeNode, localVars);
```

### 查找特定变量的使用位置（新增）
```dart
var printer = CppCodePrinter();
var targetVariable = VariableDeclaration('myVar');

// 查找变量的所有使用位置
var usages = printer.findVariableUsages(someTreeNode, targetVariable);
for (var usage in usages) {
  print('变量使用位置: ${usage.runtimeType}');
}
```

### 分析不同类型的节点
```dart
var printer = CppCodePrinter();

// 分析类节点
if (node is Class) {
  var classVars = printer.findVariableReferencesInNode(node);
  print('类中的变量引用: ${classVars.length}');
}

// 分析方法节点
if (node is Procedure) {
  var methodVars = printer.findVariableReferencesInNode(node);
  print('方法中的变量引用: ${methodVars.length}');
}

// 分析库节点
if (node is Library) {
  var libraryVars = printer.findVariableReferencesInNode(node);
  print('库中的变量引用: ${libraryVars.length}');
}
```

## 实现细节

### 变量作用域管理
使用 `Set<VariableDeclaration>` 来跟踪当前作用域中的局部变量：
- 函数参数自动添加到局部变量集合
- 每个新的作用域（如 for 循环）创建新的局部变量集合
- 通过比较变量是否在局部变量集合中来判断是否为外部变量

### 重复检查
在添加外部变量时，检查是否已经存在相同的变量声明，避免重复添加。

### 递归处理
对于嵌套的函数表达式，递归调用分析方法，并将结果合并到当前结果中。

### TreeNode 类型分发（新增）
根据 TreeNode 的具体类型，调用相应的处理逻辑：
- 使用 `is` 操作符进行类型检查
- 为每种支持的节点类型提供专门的处理逻辑
- 支持扩展以添加新的节点类型

## 应用场景

1. **C++ 闭包生成**: 为生成正确的 C++ 闭包代码提供变量捕获信息
2. **内存管理**: 确定哪些变量需要在闭包中保持引用
3. **优化分析**: 识别不必要的变量捕获以进行优化
4. **调试信息**: 为调试器提供变量作用域信息
5. **代码分析**: 分析任意代码片段中的变量依赖关系（新增）
6. **重构工具**: 查找变量的所有使用位置以支持重构（新增）
7. **静态分析**: 进行更全面的代码静态分析（新增）

## 限制和注意事项

1. 目前主要针对常见的 TreeNode 类型，可能不覆盖所有边缘情况
2. 不处理 `this` 引用的特殊情况
3. 静态分析可能无法处理动态生成的变量引用
4. 需要完整的 Kernel AST 才能进行准确分析
5. 对于非常大的 TreeNode（如整个库），分析可能比较耗时

## 扩展性

该功能设计为可扩展的：
- 可以轻松添加对新 TreeNode 类型的支持
- 可以扩展 `ClosureVariable` 类以包含更多信息
- 可以添加更复杂的作用域分析逻辑
- 可以添加更多的查询方法以支持不同的使用场景（新增）
- 支持自定义的局部作用域定义（新增） 
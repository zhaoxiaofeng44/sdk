# 表达式转换功能文档

## 概述

本模块提供了将 Dart 内核 AST 表达式转换为可读的 Dart 代码的功能。主要目的是将复杂的 AST 结构转换为标准的 Dart 语法。

## 主要功能

### 1. 基本表达式转换

#### ThisExpression
- **输入**: `ThisExpression()`
- **输出**: `this` 或 `self`（取决于 replaceThis 参数）

#### VariableGet
- **输入**: `VariableGet(variable)`
- **输出**: 变量名（经过清理）

#### 字面量转换
- **StringLiteral**: `StringLiteral('Hello')` → `'Hello'`
- **IntLiteral**: `IntLiteral(42)` → `42`
- **BoolLiteral**: `BoolLiteral(true)` → `true`
- **NullLiteral**: `NullLiteral()` → `null`

### 2. 复杂表达式转换

#### 列表字面量
```dart
ListLiteral([
  IntLiteral(1),
  IntLiteral(2),
  IntLiteral(3),
])
```
转换为：
```dart
[1, 2, 3]
```

#### 映射字面量
```dart
MapLiteral([
  MapLiteralEntry(StringLiteral('key1'), IntLiteral(1)),
  MapLiteralEntry(StringLiteral('key2'), IntLiteral(2)),
])
```
转换为：
```dart
{'key1': 1, 'key2': 2}
```

#### 逻辑表达式
```dart
LogicalExpression(
  left: BoolLiteral(true),
  operator: LogicalExpressionOperator.AND,
  right: BoolLiteral(false),
)
```
转换为：
```dart
true && false
```

#### 条件表达式
```dart
ConditionalExpression(
  condition: BoolLiteral(true),
  then: IntLiteral(1),
  otherwise: IntLiteral(0),
)
```
转换为：
```dart
true ? 1 : 0
```

### 3. 方法调用转换

#### 实例方法调用
```dart
InstanceInvocation(
  receiver: ThisExpression(),
  name: Name('method'),
  arguments: Arguments(positional: [IntLiteral(1), IntLiteral(2)]),
)
```
转换为：
```dart
this.method(1, 2)
```

#### 静态方法调用
```dart
StaticInvocation(
  target: Procedure(name: Name('testMethod')),
  arguments: Arguments(positional: [IntLiteral(1), IntLiteral(2)]),
)
```
转换为：
```dart
testMethod(1, 2)
```

#### 构造函数调用
```dart
ConstructorInvocation(
  target: Constructor(name: Name('TestClass')),
  arguments: Arguments(positional: [IntLiteral(1), IntLiteral(2)]),
)
```
转换为：
```dart
new TestClass(1, 2)
```

### 4. 属性访问转换

#### 实例属性访问
```dart
InstanceGet(
  receiver: ThisExpression(),
  name: Name('property'),
)
```
转换为：
```dart
this.property
```

#### 动态属性访问
```dart
DynamicGet(
  receiver: VariableGet(variable),
  name: Name('property'),
)
```
转换为：
```dart
variable.property
```

### 5. 类型转换

#### 类型检查
```dart
IsExpression(
  operand: VariableGet(variable),
  type: InterfaceType(class),
)
```
转换为：
```dart
variable is String
```

#### 类型转换
```dart
AsExpression(
  operand: VariableGet(variable),
  type: InterfaceType(class),
)
```
转换为：
```dart
variable as String
```

### 6. 语句转换

#### 返回语句
```dart
ReturnStatement(expression: IntLiteral(42))
```
转换为：
```dart
return 42;
```

#### 表达式语句
```dart
ExpressionStatement(expression: IntLiteral(42))
```
转换为：
```dart
42;
```

#### 块语句
```dart
Block(statements: [
  ReturnStatement(expression: IntLiteral(1)),
  ReturnStatement(expression: IntLiteral(2)),
])
```
转换为：
```dart
{
  return 1;
  return 2;
}
```

#### If 语句
```dart
IfStatement(
  condition: BoolLiteral(true),
  then: ReturnStatement(expression: IntLiteral(1)),
  otherwise: ReturnStatement(expression: IntLiteral(2)),
)
```
转换为：
```dart
if (true) return 1; else return 2;
```

### 7. 变量名清理

系统会自动清理不合法的变量名：

- 空变量名 → `unnamed`
- 包含 `#` 的变量名 → 替换为 `_`
- 以数字开头的变量名 → 添加 `var_` 前缀
- 包含特殊字符的变量名 → 替换为 `_`

### 8. 类型转换

#### 基本类型
- `DynamicType()` → `dynamic`
- `VoidType()` → `void`
- `InvalidType()` → `dynamic`

#### 接口类型
```dart
InterfaceType(Class(name: 'String'))
```
转换为：
```dart
String
```

#### 泛型类型
```dart
InterfaceType(
  Class(name: 'List'),
  typeArguments: [InterfaceType(Class(name: 'String'))],
)
```
转换为：
```dart
List<String>
```

## 使用示例

```dart
// 创建转换器
final transformer = DartToDartTransformer();

// 转换组件
transformer.transformComponent(component);

// 获取生成的代码
final code = transformer.getGeneratedCode();
```

## 测试

运行测试以确保转换功能正常工作：

```bash
dart test test/expression_conversion_test.dart
```

## 注意事项

1. **this 替换**: 当 `replaceThis` 为 `true` 时，`this` 会被替换为 `self`
2. **变量名清理**: 所有变量名都会经过清理以确保合法性
3. **类型推断**: 系统会尝试推断和转换类型信息
4. **错误处理**: 对于未知的表达式类型，会返回原始的 `toString()` 结果

## 扩展性

系统设计为可扩展的，可以通过添加新的表达式类型处理来支持更多的 Dart 语法特性。 
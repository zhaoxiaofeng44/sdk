# 表达式转换状态报告

## 当前状态

### 已成功转换的表达式类型

1. **基本表达式**
   - ✅ `ThisExpression` → `this` 或 `self`
   - ✅ `VariableGet` → 变量名
   - ✅ `StringLiteral` → `'string'`
   - ✅ `IntLiteral` → `42`
   - ✅ `BoolLiteral` → `true`/`false`
   - ✅ `NullLiteral` → `null`

2. **复杂表达式**
   - ✅ `ListLiteral` → `[1, 2, 3]`
   - ✅ `MapLiteral` → `{'key': value}`
   - ✅ `LogicalExpression` → `true && false`
   - ✅ `ConditionalExpression` → `condition ? then : else`
   - ✅ `StringConcatenation` → `'a' + 'b'`

3. **方法调用**
   - ✅ `InstanceInvocation` → `receiver.method(args)`
   - ✅ `StaticInvocation` → `StaticMethod(args)`
   - ✅ `ConstructorInvocation` → `new Class(args)`

4. **属性访问**
   - ✅ `InstanceGet` → `receiver.property`
   - ✅ `DynamicGet` → `receiver.property`

5. **类型转换**
   - ✅ `AsExpression` → `value as Type`
   - ✅ `IsExpression` → `value is Type`

6. **语句**
   - ✅ `ReturnStatement` → `return value;`
   - ✅ `ExpressionStatement` → `expression;`
   - ✅ `Block` → `{ statements }`
   - ✅ `IfStatement` → `if (condition) then else`

### 需要进一步改进的表达式类型

1. **二元表达式** ❌
   - 当前问题：`i.<(self._length)` 应该转换为 `i < self._length`
   - 需要添加：`BinaryExpression` 处理

2. **索引表达式** ❌
   - 当前问题：`map.[]=(i, value)` 应该转换为 `map[i] = value`
   - 需要添加：`IndexExpression` 和 `IndexSet` 处理

3. **方法调用中的特殊语法** ❌
   - 当前问题：`i.{num.+}(1)` 应该转换为 `i + 1`
   - 需要添加：特殊方法调用的处理

4. **函数调用** ❌
   - 当前问题：`FunctionInvocation(test(...))` 应该转换为 `test(...)`
   - 需要添加：`FunctionInvocation` 处理

5. **变量赋值** ❌
   - 当前问题：`VariableSet(i = i.{num.+}(1))` 应该转换为 `i = i + 1`
   - 需要添加：`VariableSet` 处理

6. **特殊操作符** ❌
   - 当前问题：`EqualsCall(...)` 应该转换为 `==`
   - 需要添加：特殊操作符的处理

## 示例对比

### 当前输出 vs 期望输出

```dart
// 当前输出
for (int i = 0;; i.<(self._length); VariableSet(i = i.{num.+}(1))) {
  if (FunctionInvocation(test(CppApi.cppGetPointerArrayItem(this.{CppList._array}, i) as CppList.E%))) return true;;
}

// 期望输出
for (int i = 0; i < self._length; i = i + 1) {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return true;
}
```

```dart
// 当前输出
Map<int, dynamic> map = {};
for (int i = 0;; i.<(self._length); VariableSet(i = i.{num.+}(1))) {
  map.[]=(i, cppGetPointerArrayItem(self._array, i) as dynamic);
}

// 期望输出
Map<int, dynamic> map = {};
for (int i = 0; i < self._length; i = i + 1) {
  map[i] = cppGetPointerArrayItem(self._array, i) as dynamic;
}
```

## 需要添加的表达式类型处理

### 1. BinaryExpression
```dart
} else if (expression is BinaryExpression) {
  final left = _generateExpressionCode(expression.left, replaceThis: replaceThis);
  final operator = _getBinaryOperator(expression.operator);
  final right = _generateExpressionCode(expression.right, replaceThis: replaceThis);
  return '$left $operator $right';
```

### 2. IndexExpression
```dart
} else if (expression is IndexExpression) {
  final receiver = _generateExpressionCode(expression.receiver, replaceThis: replaceThis);
  final index = _generateExpressionCode(expression.index, replaceThis: replaceThis);
  return '$receiver[$index]';
```

### 3. IndexSet
```dart
} else if (expression is IndexSet) {
  final receiver = _generateExpressionCode(expression.receiver, replaceThis: replaceThis);
  final index = _generateExpressionCode(expression.index, replaceThis: replaceThis);
  final value = _generateExpressionCode(expression.value, replaceThis: replaceThis);
  return '$receiver[$index] = $value';
```

### 4. 特殊方法调用处理
需要识别并转换特殊的方法调用模式：
- `i.{num.+}(1)` → `i + 1`
- `i.{num.<}(length)` → `i < length`

### 5. FunctionInvocation
```dart
} else if (expression is FunctionInvocation) {
  final function = _generateExpressionCode(expression.function, replaceThis: replaceThis);
  final args = expression.arguments.map((e) => _generateExpressionCode(e, replaceThis: replaceThis)).join(', ');
  return '$function($args)';
```

### 6. VariableSet
```dart
} else if (expression is VariableSet) {
  final variable = _generateExpressionCode(expression.variable, replaceThis: replaceThis);
  final value = _generateExpressionCode(expression.value, replaceThis: replaceThis);
  return '$variable = $value';
```

## 优先级

1. **高优先级**：BinaryExpression, IndexExpression, IndexSet
   - 这些是最基本的表达式类型，影响代码的可读性

2. **中优先级**：FunctionInvocation, VariableSet
   - 这些影响代码的正确性

3. **低优先级**：特殊方法调用处理
   - 这些是语法糖，可以后续优化

## 测试建议

1. 创建包含各种表达式类型的测试用例
2. 验证转换后的代码语法正确性
3. 确保转换后的代码可以正常编译和运行

## 下一步行动

1. 添加缺失的表达式类型处理
2. 改进特殊语法模式的处理
3. 增加更多的测试用例
4. 优化代码生成的质量 
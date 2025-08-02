# 表达式转换分析报告

## 当前状态

### ✅ 已支持的表达式类型

1. **基本表达式**：
   - `ThisExpression` → `self`
   - `VariableGet` → `variable.name`
   - `VariableSet` → `variable.name = value`
   - `InstanceGet` → `self.property`
   - `InstanceSet` → `self.property = value`

2. **字面量表达式**：
   - `IntLiteral` → `value.toString()`
   - `DoubleLiteral` → `value.toString()`
   - `StringLiteral` → `"value"`
   - `BoolLiteral` → `value.toString()`
   - `NullLiteral` → `null`

3. **集合字面量**：
   - `ListLiteral` → `[elements]`
   - `MapLiteral` → `{entries}`
   - `SetLiteral` → `{elements}`

4. **运算符重载转换**：
   - `operator []` → `getElement(self, index)`
   - `operator []=` → `setElement(self, index, value)`
   - `operator +` → `add(self, other)`
   - `operator -` → `subtract(self, other)`
   - `operator *` → `multiply(self, other)`
   - `operator /` → `divide(self, other)`

5. **方法调用**：
   - `InstanceInvocation` → 转换为静态方法调用
   - `StaticInvocation` → 保持静态调用
   - `DynamicInvocation` → 转换为方法调用

6. **逻辑表达式**：
   - `LogicalExpression` → `left && right` 或 `left || right`

7. **条件表达式**：
   - `ConditionalExpression` → `condition ? then : otherwise`

8. **一元表达式**：
   - `Not` → `!operand`

9. **特殊表达式**：
   - `Let` → `let_expression` (占位符)
   - `FunctionInvocation` → `functionInvocation(args)` (占位符)
   - `AsExpression` → `operand as type`
   - `EqualsCall` → `left == right`

### ⚠️ 已知问题

1. **getter提取问题**：
   - 正则表达式提取getter时产生语法错误
   - 如：`get length = > _length;` 应该是 `int get length => _length;`

2. **未完全支持的表达式类型**：
   - `Let` 表达式：需要更复杂的转换逻辑
   - `FunctionInvocation`：需要更好的函数调用处理
   - 复杂的级联表达式
   - 索引表达式
   - 赋值表达式

3. **运算符转换不完整**：
   - 某些二元运算符转换需要改进
   - 一元运算符转换需要完善
   - 赋值运算符转换缺失

### 🔧 待改进项目

1. **增强表达式转换**：
   - 完善 `Let` 表达式的转换
   - 改进 `FunctionInvocation` 的处理
   - 添加更多表达式类型的支持

2. **修复getter提取**：
   - 改进正则表达式
   - 正确处理getter语法

3. **运算符转换完善**：
   - 添加更多运算符的支持
   - 改进运算符转换逻辑

4. **错误处理**：
   - 添加更好的错误处理机制
   - 提供更详细的错误信息

## 转换示例

### 输入代码
```dart
class TestClass {
  int _length = 0;
  
  int get length => _length;
  
  void add(dynamic value) {
    _length++;
  }
  
  dynamic operator [](int index) {
    return _array;
  }
  
  void operator []=(int index, dynamic value) {
    _array = value;
  }
}
```

### 输出代码
```dart
class TestClass {
  int _length = 0;
  int get length => _length;
  
  TestClass();
  
  static TestClass create() {
    final instance = TestClass();
    return instance;
  }
  
  static void add(TestClass self, dynamic value) {
    self._length++;
  }
  
  static dynamic getElement(TestClass self, int index) {
    return self._array;
  }
  
  static void setElement(TestClass self, int index, dynamic value) {
    self._array = value;
  }
}
```

## 下一步计划

1. **修复getter提取问题**：
   - 改进正则表达式匹配
   - 正确处理getter语法

2. **增强表达式支持**：
   - 添加更多表达式类型的转换
   - 完善复杂表达式的处理

3. **优化转换质量**：
   - 改进代码生成质量
   - 减少占位符的使用

4. **添加测试用例**：
   - 创建更多测试用例
   - 验证转换的正确性

## 总结

当前的表达式转换已经支持了大部分常见的表达式类型，能够正确转换基本的Dart代码。主要问题集中在getter提取和一些复杂表达式的处理上。通过继续改进这些方面，转换器将能够处理更复杂的Dart代码。 
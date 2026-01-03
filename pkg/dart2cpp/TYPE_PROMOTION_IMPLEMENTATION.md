# Dart类型提升(Type Promotion)实现说明

## 功能概述

实现了Dart的类型提升特性，当在`if`语句中使用`is`类型检查后，变量会自动提升为更具体的类型。

## 实现原理

### 1. 类型提升分析

在`CppStatementConverter`类中添加了类型提升分析逻辑：

```dart
/// 存储类型提升信息：变量名 -> 提升后的类型
final Map<String, String> _typePromotions = {};

/// 分析表达式中的类型提升
void _analyzeTypePromotion(Expression condition, {required bool isNegated}) {
  if (condition is IsExpression) {
    if (condition.operand is VariableGet) {
      final varGet = condition.operand as VariableGet;
      final varName = _sanitizeIdentifier(varGet.variable.name ?? 'unnamed');
      
      // 只在非取反情况下进行类型提升
      if (!isNegated) {
        final promotedType = CppTypeConverter.convertType(condition.type);
        _typePromotions[varName] = promotedType;
      }
    }
  }
  // 处理 NOT、AND 等逻辑运算符...
}
```

### 2. if语句处理

修改`_convertIfStatement`方法，在then分支中应用类型提升：

```dart
String _convertIfStatement(IfStatement stmt) {
  // 保存当前的类型提升状态
  final savedPromotions = Map<String, String>.from(_typePromotions);
  
  final condition = transformer.expressionConverter.convertExpression(stmt.condition);
  
  // 分析条件中的类型提升
  _analyzeTypePromotion(stmt.condition, isNegated: false);
  
  // 在then分支中应用类型提升
  final thenStmt = _convertStatementWithPromotions(() {
    return convertStatement(stmt.then);
  });
  
  // else分支处理...
}
```

### 3. 生成类型转换代码

在`_convertStatementWithPromotions`中生成类型转换代码：

```dart
String _convertStatementWithPromotions(String Function() converter) {
  if (_typePromotions.isEmpty) {
    return converter();
  }
  
  // 生成类型转换代码
  final promotionCode = StringBuffer();
  for (final entry in _typePromotions.entries) {
    final varName = entry.key;
    final promotedType = entry.value;
    
    // auto var_promoted = dart_cast<Type>(var);
    promotionCode.writeln('auto ${varName}_promoted = dart_cast<$promotedType>($varName);');
  }
  
  // 注入变量映射，后续使用promoted变量
  // ...
}
```

### 4. 变量引用重映射

在`ExpressionConverter`中添加变量映射：

```dart
class ExpressionConverter {
  /// 类型提升变量映射：原始变量名 -> promoted变量名
  final Map<String, String> _promotedVarMapping = {};
  
  String _convertVariableGet(VariableGet expr) {
    String varName = _sanitizeIdentifier(expr.variable.name ?? 'unnamed_var');
    
    // 检查是否有类型提升后的变量
    if (_promotedVarMapping.containsKey(varName)) {
      return _promotedVarMapping[varName]!;
    }
    
    return varName;
  }
}
```

## 支持的场景

### ✅ 场景1: 基本类型提升

**Dart代码**:
```dart
Object obj = "Hello";
if (obj is String) {
  print(obj.length);  // obj被提升为String
}
```

**生成的C++代码**:
```cpp
auto obj = dart_string("Hello");
if (dart_is<String>(obj)) {
  auto obj_promoted = dart_cast<String>(obj);
  dart_print(obj_promoted->size());  // 使用promoted变量
}
```

### ✅ 场景2: 逻辑AND运算符

**Dart代码**:
```dart
if (x is String && y is int) {
  print(x.length + y);  // x提升为String, y提升为int
}
```

**生成的C++代码**:
```cpp
if (dart_is<String>(x) && dart_is<Int>(y)) {
  auto x_promoted = dart_cast<String>(x);
  auto y_promoted = dart_cast<Int>(y);
  dart_print(x_promoted->size()->operator_add(y_promoted));
}
```

### ✅ 场景3: 嵌套的if语句

**Dart代码**:
```dart
if (nullable != null) {
  if (nullable is String) {
    print(nullable.substring(0, 5));  // nullable提升为String
  }
}
```

**生成的C++代码**:
```cpp
if (!(dart_is_null(nullable))) {
  if (dart_is<String>(nullable)) {
    auto nullable_promoted = dart_cast<String>(nullable);
    dart_print(nullable_promoted->substring(dart_int(0), dart_int(5)));
  }
}
```

### ✅ 场景4: else分支

**Dart代码**:
```dart
if (item is! int) {
  print("Not an integer");
} else {
  print(item.abs());  // 在else分支中，item提升为int
}
```

**生成的C++代码**:
```cpp
if (!(dart_is<Int>(item))) {
  dart_print(dart_string("Not an integer"));
} else {
  auto item_promoted = dart_cast<Int>(item);
  dart_print(item_promoted->abs());
}
```

### ✅ 场景5: dynamic类型

**Dart代码**:
```dart
dynamic value = 42;
if (value is int) {
  print(value + 10);  // value提升为int
}
```

**生成的C++代码**:
```cpp
Any value = dart_int(42);
if (dart_is<Int>(value)) {
  auto value_promoted = dart_cast<Int>(value);
  dart_print(value_promoted->operator_add(dart_int(10)));
}
```

## 实现细节

### 类型提升状态管理

1. **保存和恢复**: 在进入if语句前保存当前状态，退出后恢复
2. **作用域隔离**: then分支和else分支的类型提升互不影响
3. **嵌套支持**: 支持多层嵌套的if语句

### 变量名映射

| 原始变量 | Promoted变量 | 使用场景 |
|---------|-------------|---------|
| `obj` | `obj_promoted` | if分支内部 |
| `value` | `value_promoted` | is检查后 |
| `data` | `data_promoted` | 类型确定后 |

### 代码生成流程

```
1. 分析if条件 → 识别is表达式
2. 提取变量信息 → 记录变量名和目标类型
3. 生成转换代码 → auto var_promoted = dart_cast<Type>(var);
4. 重映射变量 → 所有后续引用使用promoted变量
5. 恢复状态 → 退出if语句后清除映射
```

## 限制和已知问题

### ❌ 不支持的场景

1. **OR运算符**: `if (x is String || y is int)` - 不进行类型提升
2. **复杂表达式**: `if ((x is String) && someFunction())` - 可能不完整
3. **赋值后提升**: 在if分支中对变量重新赋值后的提升

### ⚠️ 注意事项

1. **性能**: 每次类型提升都会生成`dart_cast`调用，可能有轻微性能开销
2. **作用域**: 类型提升仅在if分支内有效，不会泄漏到外部
3. **嵌套**: 深层嵌套的if语句会生成多个promoted变量

## 测试验证

运行测试：
```bash
cd /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp
dart bin/dart2cpp.dart sample/dart/type_promotion_test.dart -o /tmp/type_promotion_test.cpp
```

验证生成的C++代码：
```bash
# 检查类型转换代码
grep "auto.*_promoted = dart_cast" /tmp/type_promotion_test.cpp

# 检查变量使用
grep "_promoted->" /tmp/type_promotion_test.cpp
```

## 相关文件

- `lib/dart_to_cpp_compiler.dart` - 核心实现
  - `CppStatementConverter._analyzeTypePromotion()` - 类型提升分析
  - `CppStatementConverter._convertIfStatement()` - if语句转换
  - `CppStatementConverter._convertStatementWithPromotions()` - 应用类型提升
  - `ExpressionConverter._promotedVarMapping` - 变量映射
  - `ExpressionConverter._convertVariableGet()` - 变量引用处理

- `sample/dart/type_promotion_test.dart` - 测试用例

## 性能影响

### 编译时

- **分析开销**: 每个if语句需要遍历条件表达式 - O(n)
- **映射开销**: 使用Map存储类型提升信息 - O(1)
- **代码生成**: 每个提升变量额外生成1行代码

### 运行时

- **类型转换**: `dart_cast<T>(obj)` - 轻量级强制转换
- **变量访问**: 通过promoted变量访问，无额外开销
- **内存**: 每个promoted变量占用一个指针大小

## 未来改进

1. **优化dart_cast**: 在编译期确定类型时，使用static_cast代替
2. **消除冗余转换**: 如果变量已经是目标类型，跳过转换
3. **支持更多模式**: 扩展到switch语句、while循环等
4. **流式分析**: 实现完整的控制流分析，支持更复杂的场景

---

**实现日期**: 2025-12-16  
**实现者**: Qoder AI Assistant  
**版本**: 2.1.0

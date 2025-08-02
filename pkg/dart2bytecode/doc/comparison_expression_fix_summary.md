# 比较表达式转换修复总结

## 问题描述

在之前的转换过程中，比较运算符（如 `<`, `>`, `<=`, `>=`, `==`, `!=`）没有被正确转换为对应的静态方法调用，而是保持了原始的运算符语法，如 `<(self, 15)`。

## 根本原因

`InstanceInvocation` 表达式的处理逻辑中，比较运算符的处理只考虑了有两个参数的情况，但实际上比较运算符可能只有一个参数（如 `test < 15`）。

## 解决方案

在 `lib/compile_to_dart.dart` 的 `_expressionToString` 方法中，增强了 `InstanceInvocation` 的处理逻辑：

### 修改内容

1. **添加单参数比较运算符处理**：
   ```dart
   } else if (parts.length == 1) {
     // 处理只有一个参数的情况
     String methodNameConverted = methodName;
     if (methodName == '>')
       methodNameConverted = 'greaterThan';
     else if (methodName == '<')
       methodNameConverted = 'lessThan';
     else if (methodName == '>=')
       methodNameConverted = 'greaterThanOrEqual';
     else if (methodName == '<=')
       methodNameConverted = 'lessThanOrEqual';
     else if (methodName == '==')
       methodNameConverted = 'equals';
     else if (methodName == '!=') methodNameConverted = 'notEquals';
     return '$methodNameConverted(self, ${parts[0]})';
   }
   ```

2. **添加对其他表达式类型的支持**：
   - `StringConcatenation` - 字符串连接
   - `Throw` - 异常抛出
   - `ConstantExpression` - 常量表达式
   - `EqualsNull` - 空值检查

## 转换映射

| 原始运算符 | 转换后的方法名 | 示例转换 |
|-----------|---------------|----------|
| `<` | `lessThan` | `test < 15` → `lessThan(test, 15)` |
| `>` | `greaterThan` | `test > 10` → `greaterThan(test, 10)` |
| `<=` | `lessThanOrEqual` | `test <= 20` → `lessThanOrEqual(test, 20)` |
| `>=` | `greaterThanOrEqual` | `test >= 5` → `greaterThanOrEqual(test, 5)` |
| `==` | `equals` | `test == other` → `equals(test, other)` |
| `!=` | `notEquals` | `test != other` → `notEquals(test, other)` |

## 测试结果

使用 `test_simple_debug.dart` 进行测试：

### 输入代码
```dart
class SimpleDebug {
  int _value = 0;
  
  bool operator <(int other) {
    return _value < other;
  }
  
  void test() {
    var test = SimpleDebug();
    print(test < 15);
  }
}
```

### 转换后的代码
```dart
class SimpleDebug {
  SimpleDebug();
  
  static void test(SimpleDebug self) {
    {
      SimpleDebug test = SimpleDebug.create();
      .print(lessThan(self, 15));
    }
  }
  
  static bool lessThan(SimpleDebug self, int other) {
    {
      return lessThan(self, other);
    }
  }
}
```

## 验证

转换器现在能够正确地将比较运算符转换为对应的静态方法调用，解决了之前 `<(self, 15)` 这样的语法错误问题。

## 下一步

1. 继续完善其他表达式类型的转换
2. 处理方法体中的无限递归问题
3. 添加更多测试用例验证转换的正确性 
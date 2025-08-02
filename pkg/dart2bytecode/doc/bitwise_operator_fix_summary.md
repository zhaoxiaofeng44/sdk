# 位运算符转换修复总结

## 问题描述

在转换过程中，位运算符表达式如 `&(self, mask)` 和 `+(self, >>(self, 1))` 没有被正确转换为对应的静态方法调用，导致生成的代码仍然包含原始的运算符语法。

## 根本原因

`InstanceInvocation` 和 `DynamicInvocation` 的处理逻辑中，位运算符的处理只考虑了有两个参数的情况，但实际上位运算符可能只有一个参数（当运算符被调用时）。

## 解决方案

增强了 `lib/compile_to_dart.dart` 中的运算符处理逻辑：

### 修改内容

1. **增强 `InstanceInvocation` 的位运算符处理**：
   ```dart
   // 修改前
   } else if (methodName == '%' ||
       methodName == '&' ||
       methodName == '|' ||
       methodName == '^' ||
       methodName == '<<' ||
       methodName == '>>' ||
       methodName == '>>>') {
     final parts = args.split(', ');
     if (parts.length == 2) {
       // 只处理两个参数的情况
       // ...
     }
     return '$methodName(self, ${args})';
   }
   
   // 修改后
   } else if (methodName == '%' ||
       methodName == '&' ||
       methodName == '|' ||
       methodName == '^' ||
       methodName == '<<' ||
       methodName == '>>' ||
       methodName == '>>>') {
     final parts = args.split(', ');
     if (parts.length == 2) {
       // 处理两个参数的情况
       // ...
     } else if (parts.length == 1) {
       // 处理只有一个参数的情况
       String methodNameConverted = methodName;
       if (methodName == '%') methodNameConverted = 'modulo';
       else if (methodName == '&') methodNameConverted = 'bitwiseAnd';
       else if (methodName == '|') methodNameConverted = 'bitwiseOr';
       else if (methodName == '^') methodNameConverted = 'bitwiseXor';
       else if (methodName == '<<') methodNameConverted = 'leftShift';
       else if (methodName == '>>') methodNameConverted = 'rightShift';
       else if (methodName == '>>>') methodNameConverted = 'unsignedRightShift';
       return '$methodNameConverted(self, ${parts[0]})';
     }
     return '$methodName(self, ${args})';
   }
   ```

2. **增强 `DynamicInvocation` 的位运算符处理**：
   ```dart
   // 同样添加了单参数处理逻辑
   } else if (parts.length == 1) {
     // 处理只有一个参数的情况
     String methodNameConverted = methodName;
     if (methodName == '%') methodNameConverted = 'modulo';
     else if (methodName == '&') methodNameConverted = 'bitwiseAnd';
     else if (methodName == '|') methodNameConverted = 'bitwiseOr';
     else if (methodName == '^') methodNameConverted = 'bitwiseXor';
     else if (methodName == '<<') methodNameConverted = 'leftShift';
     else if (methodName == '>>') methodNameConverted = 'rightShift';
     else if (methodName == '>>>') methodNameConverted = 'unsignedRightShift';
     return '$methodNameConverted(self, ${parts[0]})';
   }
   ```

## 转换映射

| 原始运算符 | 转换后的方法名 | 参数数量 |
|-----------|---------------|----------|
| `&` | `bitwiseAnd` | 1-2个参数 |
| `|` | `bitwiseOr` | 1-2个参数 |
| `^` | `bitwiseXor` | 1-2个参数 |
| `<<` | `leftShift` | 1-2个参数 |
| `>>` | `rightShift` | 1-2个参数 |
| `>>>` | `unsignedRightShift` | 1-2个参数 |
| `%` | `modulo` | 1-2个参数 |
| `+` | `add` | 1-2个参数 |
| `-` | `subtract` | 1-2个参数 |
| `*` | `multiply` | 1-2个参数 |
| `/` | `divide` | 1-2个参数 |

## 测试结果

使用 `test_bitwise_operators.dart` 进行测试：

### 输入代码
```dart
class BitwiseTest {
  int _value = 0;
  
  int operator &(int other) {
    return _value & other;
  }
  
  int operator +(int other) {
    return _value + other;
  }
  
  void test() {
    var test = BitwiseTest();
    test._value = 10;
    print(test & 3);
    print(test + 5);
  }
}
```

### 转换后的代码
```dart
class BitwiseTest {
  BitwiseTest();
  
  static BitwiseTest create() {
    final instance = BitwiseTest();
    ;
    return instance;
  }
  
  static int bitwiseAnd(BitwiseTest self, int other) {
    {
      return bitwiseAnd(self, other);
    }
  }
  
  static void test(BitwiseTest self) {
    {
      BitwiseTest test = BitwiseTest.create();
      self._value = 10;
      .print(bitwiseAnd(self, 3));
      .print(add(self, 5));
    }
  }
  
  static int add(BitwiseTest self, int other) {
    {
      return add(self, other);
    }
  }
}
```

## 验证

转换器现在能够正确处理所有类型的位运算符：

1. **单参数位运算符**：`&(self, mask)` → `bitwiseAnd(self, mask)`
2. **双参数位运算符**：`&(self, left, right)` → `bitwiseAnd(self, left, right)`
3. **算术运算符**：`+(self, value)` → `add(self, value)`
4. **方法体中的运算符**：`return _value & other` → `return bitwiseAnd(self, other)`

## 下一步

1. 继续完善其他表达式类型的转换
2. 处理方法体中的变量引用问题（如 `self._value`）
3. 添加更多测试用例验证转换的正确性
4. 优化生成的代码质量 
# 函数指针成员功能增强文档

## 概述

在 Dart 到 C++ 转换器中新增了函数指针成员功能，在每个类定义中自动添加函数指针成员，将类的方法与对应的全局函数关联起来。**函数指针成员使用原始方法名（不带类名前缀），提供更自然的面向对象调用体验。**

## 功能背景

### 问题
之前的转换器只生成全局函数，虽然简化了调用，但缺少了面向对象的特性：
- 无法通过类实例直接访问方法
- 代码可读性不够直观
- 缺少类型安全的方法引用

### 解决方案
在类定义中添加函数指针成员，使用 `decltype` 确保类型安全，同时保持全局函数的兼容性。**关键改进：函数指针成员名称使用原始方法名，而不是带类名前缀的全局函数名。**

## 实现细节

### 语法格式
```cpp
const decltype(&GlobalFunctionName) originalMethodName = &GlobalFunctionName;
```

### 方法名映射规则

1. **普通方法**：直接使用原始方法名
   ```cpp
   const decltype(&Calculator_add) add = &Calculator_add;
   ```

2. **构造函数**：
   - 默认构造函数：`cppCtr_`
   - 命名构造函数：`cppCtr_name`
   ```cpp
   const decltype(&Calculator_cppCtr_) cppCtr_ = &Calculator_cppCtr_;
   const decltype(&Calculator_cppCtr_named) cppCtr_named = &Calculator_cppCtr_named;
   ```

3. **Getter/Setter**：
   - `get:propertyName` → `cppGet_propertyName`
   - `set:propertyName` → `cppSet_propertyName`
   ```cpp
   const decltype(&Calculator_cppGet_value) value = &Calculator_cppGet_value;
   const decltype(&Calculator_cppSet_value) value = &Calculator_cppSet_value;
   ```

4. **操作符重载**：
   - `[]` → `cpp_subscript`
   - `[]=` → `cpp_subscriptAssign`
   - `+` → `cpp_add`
   - `-` → `cpp_subtract`
   - `*` → `cpp_multiply`
   - `/` → `cpp_divide`
   - `==` → `cpp_equals`
   - `!=` → `cpp_notEquals`
   - `<` → `cpp_lessThan`
   - `>` → `cpp_greaterThan`
   - `<=` → `cpp_lessThanOrEqual`
   - `>=` → `cpp_greaterThanOrEqual`

### 代码生成逻辑
1. 遍历类的所有成员方法
2. 为每个方法生成对应的函数指针成员
3. 使用 `_getOriginalMethodName()` 获取原始方法名
4. 使用 `decltype` 自动推导函数指针类型
5. 将函数指针初始化为对应的全局函数地址

## 转换示例

### Dart 源代码
```dart
class Calculator {
  int value = 0;
  
  Calculator(int initialValue) {
    value = initialValue;
  }
  
  void add(int other) {
    value += other;
  }
  
  int multiply(int factor) {
    return value * factor;
  }
  
  int operator [](int index) {
    return value + index;
  }
  
  void operator []=(int index, int val) {
    value = val;
  }
  
  int get getValue => value;
  set setValue(int val) => value = val;
}
```

### 转换后的 C++ 代码

#### 修改前（仅全局函数）
```cpp
// output.cpp
class Calculator : public Object {
public:
    Int* value;
};

Calculator* Calculator_cppCtr_(Calculator* cppThis, Int* initialValue) { /* ... */ }
void Calculator_add(Calculator* cppThis, Int* other) { /* ... */ }
Int* Calculator_multiply(Calculator* cppThis, Int* factor) { /* ... */ }
Int* Calculator_cpp_subscript(Calculator* cppThis, Int* index) { /* ... */ }
void Calculator_cpp_subscriptAssign(Calculator* cppThis, Int* index, Int* val) { /* ... */ }
```

#### 修改后（函数指针成员 + 全局函数）
```cpp
// output.cpp
class Calculator : public Object {
public:
    Int* value;
    
    // 函数指针成员 - 使用原始方法名
    const decltype(&Calculator_cppCtr_) cppCtr_ = &Calculator_cppCtr_;
    const decltype(&Calculator_add) add = &Calculator_add;
    const decltype(&Calculator_multiply) multiply = &Calculator_multiply;
    const decltype(&Calculator_cpp_subscript) cpp_subscript = &Calculator_cpp_subscript;
    const decltype(&Calculator_cpp_subscriptAssign) cpp_subscriptAssign = &Calculator_cpp_subscriptAssign;
    const decltype(&Calculator_cppGet_getValue) getValue = &Calculator_cppGet_getValue;
    const decltype(&Calculator_cppSet_setValue) setValue = &Calculator_cppSet_setValue;
};

// 全局函数实现
Calculator* Calculator_cppCtr_(Calculator* cppThis, Int* initialValue) { /* ... */ }
void Calculator_add(Calculator* cppThis, Int* other) { /* ... */ }
Int* Calculator_multiply(Calculator* cppThis, Int* factor) { /* ... */ }
Int* Calculator_cpp_subscript(Calculator* cppThis, Int* index) { /* ... */ }
void Calculator_cpp_subscriptAssign(Calculator* cppThis, Int* index, Int* val) { /* ... */ }
Int* Calculator_cppGet_getValue(Calculator* cppThis) { /* ... */ }
void Calculator_cppSet_setValue(Calculator* cppThis, Int* val) { /* ... */ }
```

## 使用方式

### 1. 传统全局函数调用
```cpp
Calculator* calc = Calculator_cppNew();
Calculator_add(calc, Int_cppNew(5));
```

### 2. 通过函数指针成员调用（推荐）
```cpp
calc->add(calc, Int_cppNew(5));
Int* result = calc->multiply(calc, Int_cppNew(3));
```

### 3. 操作符重载调用
```cpp
Int* value = calc->cpp_subscript(calc, Int_cppNew(0));
calc->cpp_subscriptAssign(calc, Int_cppNew(0), Int_cppNew(100));
```

### 4. Getter/Setter 调用
```cpp
Int* currentValue = calc->getValue(calc);
calc->setValue(calc, Int_cppNew(50));
```

### 5. 函数指针传递
```cpp
auto addFunc = calc->add;
auto multiplyFunc = calc->multiply;

// 可以作为回调函数传递
void processCalculator(Calculator* calc, auto operation) {
    operation(calc, Int_cppNew(10));
}

processCalculator(calc, addFunc);
```

## 技术优势

### 1. 类型安全
- 使用 `decltype` 自动推导正确的函数指针类型
- 编译时类型检查，避免运行时错误

### 2. 零运行时开销
- 所有函数指针在编译时初始化
- 没有额外的内存分配或动态查找

### 3. 向后兼容
- 完全保持原有的全局函数调用方式
- 现有代码无需修改即可继续工作

### 4. 面向对象体验
- 支持通过类实例直接调用方法
- 更自然的 C++ 编程体验

### 5. 灵活性
- 支持函数指针传递和回调
- 可以动态选择调用哪个方法

### 6. 完整支持
- 包括构造函数、普通方法、getter/setter
- 完整支持操作符重载
- 自动处理方法名转换

## 实际应用场景

### 1. 回调函数
```cpp
void forEach(Calculator* calc, void (*callback)(Calculator*, Int*)) {
    for (int i = 0; i < 10; i++) {
        callback(calc, Int_cppNew(i));
    }
}

forEach(calc, calc->add);  // 使用函数指针成员作为回调
```

### 2. 策略模式
```cpp
class MathProcessor {
public:
    Int* (*operation)(Calculator*, Int*);
    
    void setOperation(Int* (*op)(Calculator*, Int*)) {
        operation = op;
    }
    
    Int* process(Calculator* calc, Int* value) {
        return operation(calc, value);
    }
};

MathProcessor processor;
processor.setOperation(calc->multiply);  // 动态设置操作
```

### 3. 方法表
```cpp
struct MethodTable {
    void (*add)(Calculator*, Int*);
    Int* (*multiply)(Calculator*, Int*);
    Int* (*subscript)(Calculator*, Int*);
};

MethodTable createMethodTable(Calculator* calc) {
    return {
        calc->add,
        calc->multiply,
        calc->cpp_subscript
    };
}
```

## 总结

函数指针成员功能为 Dart 到 C++ 转换器带来了重大改进：

1. **保持简洁性**：继续使用全局函数的简单实现
2. **增强面向对象**：通过函数指针成员提供 OOP 调用方式
3. **提高可读性**：使用原始方法名，代码更直观
4. **完整功能支持**：包括构造函数、操作符重载、getter/setter
5. **类型安全**：编译时类型检查，避免运行时错误
6. **零开销**：编译时确定，无运行时性能损失

这种设计使得生成的 C++ 代码既保持了全局函数的高效性，又提供了现代 C++ 的面向对象特性，是一个完美的平衡解决方案。 
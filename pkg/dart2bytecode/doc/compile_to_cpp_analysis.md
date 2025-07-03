# Dart 到 C++ 代码转换器语法转换关键信息分析

## 概述

`compile_to_cpp.dart` 是一个将 Dart 代码转换为 C++ 代码的编译器转换器。其核心设计思想是将 Dart 的面向对象特性转换为 C++ 的静态方法调用，从而实现跨语言代码转换。

## 核心转换策略

### 1. 成员方法转换为静态方法

**关键实现：`writeMemberFunctionDeclaration` 方法**

```dart
void writeMemberFunctionDeclaration(Procedure procedure) {
    // 生成静态方法声明
    write("$typeStr static ${_getVariableDeclareType(function.returnType)} $name");
    // 添加类实例作为第一个参数
    writeParametersList(function, ownerClassType: procedure.isStatic ? "" : ownerClassType);
}
```

**转换规则：**
- 所有实例方法都转换为静态方法
- 类实例 `this` 变为第一个参数 `cppThis`
- 方法调用格式：`ClassName::methodName(instance, ...args)`

### 2. 类型映射体系

**基础类型映射：**
```dart
final Map<String, String> typeNames = {
  "num": "Num",
  "int": "Int", 
  "double": "Double",
  "bool": "Bool",
  "String": "String",
  "List": "List",
  "Map": "Map",
  "Set": "Set",
  "_Set": "CppSet",
  "UnmodifiableMapView": "CppWasmMap"
};
```

**指针化处理：**
- 所有对象类型都转换为指针类型 `Type *`
- `void` 类型保持不变
- 支持泛型参数的模板化

### 3. 运算符重载转换

**特殊名称映射：**
```dart
final Map<String, String> specialNames = {
  '+': 'cpp_add',           // 加法
  '-': 'cpp_subtract',      // 减法  
  '*': 'cpp_multiply',      // 乘法
  '/': 'cpp_divide',        // 除法
  '==': 'cpp_equals',       // 相等比较
  '[]': 'cpp_subscript',    // 索引访问
  '[]=': 'cpp_subscriptAssign', // 索引赋值
  // ... 更多运算符
};
```

### 4. 构造函数转换

**转换策略：**
- 构造函数转换为静态工厂方法
- 返回类型为类指针 `ClassName *`
- 使用 `cppNew()` 分配内存
- 支持字段初始化器

```cpp
static ClassName* cppCtr_constructorName(ClassName* cppThis, ...args) {
    // 字段初始化
    cppThis->field = value;
    // 构造函数体
    return cppThis;
}
```

### 5. 方法调用转换

**实例方法调用：**
```dart
// Dart: instance.method(args)
// C++:  ClassName::method(instance, args)
```

**静态方法调用：**
```dart
// Dart: ClassName.staticMethod(args)  
// C++:  ClassName::staticMethod(args)
```

### 6. 字面量转换

**基础字面量：**
- `int` → `Int::cppNew(value)`
- `double` → `Double::cppNew(value)`
- `bool` → `Bool::cppNew(value)`
- `String` → `String::cppNew("value", sizeof("value"))`
- `null` → `nullptr`

**集合字面量：**
- `List` → `CppNewList(Type, elements...)`
- `Map` → `CppNewMap(KeyType, ValueType, entries...)`
- `Set` → `CppNewSet(Type, elements...)`

### 7. 控制流语句转换

**条件语句：**
- `if-else` 直接映射为 C++ 的 `if-else`
- 三元运算符保持不变

**循环语句：**
- `while` 循环直接映射
- `for` 循环转换为块结构包装的 `while` 循环
- `do-while` 保持不变

**Switch 语句：**
```cpp
do {
    auto switchValue = expression;
    if(switchValue == case1) { ... }
    if(switchValue == case2) { ... }
} while(0);
```

### 8. 闭包和函数对象

**Lambda 表达式：**
```cpp
[&](parameters) -> ReturnType { body }
```

**闭包变量捕获：**
- 自动分析外部变量引用
- 生成闭包变量信息
- 支持按引用捕获

### 9. 内存管理

**对象创建：**
```cpp
static ClassName* cppNew() {
    static void *functionPtrs[] = { /* 虚函数表 */ };
    auto ptr = (ClassName*)malloc(sizeof(ClassName));
    ptr->vtab = functionPtrs;
    return ptr;
}
```

**虚函数表：**
- 自动生成虚函数表
- 支持继承层次的方法重写
- 使用函数指针数组实现多态

### 10. 异常处理

**异常抛出：**
```cpp
// Dart: throw expression
// C++:  throw "error_message"
```

**Try-Finally：**
```cpp
try { 
    // try body
} finally {
    // finally body  
};
```

## 类声明结构转换

### 头文件声明
```cpp
template<typename T> class ClassName : virtual public SuperClass {
public:
    // 字段声明
    FieldType* fieldName;
    
    // 静态方法声明
    static ReturnType* methodName(ClassName* cppThis, ...args);
    
    // 工厂方法
    static ClassName* cppNew();
};
```

### 实现文件
```cpp
template<typename T> 
ReturnType* ClassName<T>::methodName(ClassName* cppThis, ...args) {
    // 方法实现
}

template<typename T>
ClassName<T>* ClassName<T>::cppNew() {
    // 对象创建实现
}
```

## 关键特性

1. **完全静态化**：所有方法调用都转换为静态方法调用
2. **指针化**：所有对象都使用指针管理
3. **模板支持**：完整支持泛型参数转换
4. **继承支持**：通过虚继承实现多重继承
5. **闭包分析**：自动分析和处理闭包变量
6. **运算符重载**：完整映射 Dart 运算符到 C++ 函数

## 转换流程

1. **分析阶段**：解析 Dart AST，收集类和成员信息
2. **前置声明**：生成所有类的前置声明
3. **头文件生成**：生成类声明和方法签名
4. **实现生成**：生成方法实现和虚函数表
5. **优化处理**：处理特殊情况和优化

这个转换器实现了从动态类型的 Dart 到静态类型的 C++ 的完整转换，保持了面向对象的语义同时适配了 C++ 的内存模型和调用约定。 
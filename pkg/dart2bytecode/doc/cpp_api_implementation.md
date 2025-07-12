# CppApi类实现文档

## 概述

`CppApi`类提供了一系列用于在C++环境中操作指针数组、字节数组和字符串的实用方法。该类主要用于支持从Dart编译到C++的代码中的基础数据操作。

## 类结构

```cpp
class CppApi {
public:
    // 指针数组操作
    static void** cppCreatePointerArray(Int* length);
    static Object* cppGetPointerArrayItem(void** array, Int* index);
    static void cppSetPointerArrayItem(void** array, Int* index, Object* value);
    
    // 字节数组操作
    static void** cppCreateByteArray(Int* length);
    static Int* cppGetByteArrayItem(void** array, Int* index);
    static void cppSetByteArrayItem(void** array, Int* index, Object* value);
    
    // 字符串操作
    static String* cppJoinListString(void** array, Int* length, String* separator);
    
    // 布尔值操作
    static bool cppBoolValue(Bool* value);
};
```

## 方法详解

### 指针数组操作

#### `cppCreatePointerArray(Int* length)`
- **功能**: 创建一个指定长度的指针数组
- **参数**: `length` - 数组长度
- **返回值**: `void**` - 指向新创建数组的指针，失败时返回NULL
- **说明**: 创建的数组所有元素初始化为NULL

#### `cppGetPointerArrayItem(void** array, Int* index)`
- **功能**: 获取指针数组中指定索引的元素
- **参数**: 
  - `array` - 指针数组
  - `index` - 数组索引
- **返回值**: `Object*` - 指定位置的对象，失败时返回NULL
- **说明**: 支持边界检查，负索引返回NULL

#### `cppSetPointerArrayItem(void** array, Int* index, Object* value)`
- **功能**: 设置指针数组中指定索引的元素
- **参数**: 
  - `array` - 指针数组
  - `index` - 数组索引
  - `value` - 要设置的对象
- **返回值**: 无
- **说明**: 支持边界检查，负索引不执行操作

### 字节数组操作

#### `cppCreateByteArray(Int* length)`
- **功能**: 创建一个指定长度的字节数组
- **参数**: `length` - 数组长度
- **返回值**: `void**` - 指向新创建数组的指针，失败时返回NULL
- **说明**: 实际上创建的是void*数组，用于存储Int*对象

#### `cppGetByteArrayItem(void** array, Int* index)`
- **功能**: 获取字节数组中指定索引的元素
- **参数**: 
  - `array` - 字节数组
  - `index` - 数组索引
- **返回值**: `Int*` - 指定位置的整数对象，失败时返回NULL

#### `cppSetByteArrayItem(void** array, Int* index, Object* value)`
- **功能**: 设置字节数组中指定索引的元素
- **参数**: 
  - `array` - 字节数组
  - `index` - 数组索引
  - `value` - 要设置的对象
- **返回值**: 无

### 字符串操作

#### `cppJoinListString(void** array, Int* length, String* separator)`
- **功能**: 将对象数组中的元素转换为字符串并用分隔符连接
- **参数**: 
  - `array` - 对象数组
  - `length` - 数组长度
  - `separator` - 分隔符字符串（可为NULL）
- **返回值**: `String*` - 连接后的字符串
- **说明**: 
  - 如果separator为NULL，直接连接不加分隔符
  - 使用Object::toString()方法获取每个对象的字符串表示
  - 空数组返回空字符串

### 布尔值操作

#### `cppBoolValue(Bool* value)`
- **功能**: 获取Bool对象的原始bool值
- **参数**: `value` - Bool对象指针
- **返回值**: `bool` - 原始布尔值，NULL时返回false
- **说明**: 提供从包装类型到原始类型的转换

## 使用示例

### 指针数组示例

```cpp
// 创建长度为3的指针数组
Int* length = Int::cppNew(3);
void** array = CppApi::cppCreatePointerArray(length);

// 设置数组元素
String* str1 = String::cppNew("Hello");
String* str2 = String::cppNew("World");
CppApi::cppSetPointerArrayItem(array, Int::cppNew(0), str1);
CppApi::cppSetPointerArrayItem(array, Int::cppNew(1), str2);

// 获取数组元素
Object* item0 = CppApi::cppGetPointerArrayItem(array, Int::cppNew(0));
Object* item1 = CppApi::cppGetPointerArrayItem(array, Int::cppNew(1));

// 清理内存
delete[] array;
```

### 字符串连接示例

```cpp
// 创建字符串数组
void** array = new void*[3];
array[0] = String::cppNew("Hello");
array[1] = String::cppNew("World");
array[2] = String::cppNew("Test");

// 使用逗号分隔符连接
String* separator = String::cppNew(",");
String* result = CppApi::cppJoinListString(array, Int::cppNew(3), separator);
// 结果: "Hello,World,Test"

// 无分隔符连接
String* result2 = CppApi::cppJoinListString(array, Int::cppNew(3), NULL);
// 结果: "HelloWorldTest"

delete[] array;
```

### 布尔值示例

```cpp
// 创建布尔对象
Bool* trueValue = Bool::cppNew(true);
Bool* falseValue = Bool::cppNew(false);

// 获取原始bool值
bool result1 = CppApi::cppBoolValue(trueValue);  // true
bool result2 = CppApi::cppBoolValue(falseValue); // false
bool result3 = CppApi::cppBoolValue(NULL);       // false
```

## 错误处理

- 所有方法都进行NULL指针检查
- 数组索引进行边界检查（负索引被视为无效）
- 对于创建操作，长度小于等于0时返回NULL
- 对于获取操作，无效参数时返回NULL
- 对于设置操作，无效参数时不执行任何操作

## 内存管理

- 调用者负责释放通过`cppCreatePointerArray`和`cppCreateByteArray`创建的数组
- 数组元素的内存管理由对象本身负责
- 字符串连接操作中的临时字符串会自动清理

## 依赖关系

- `Int`类：用于数组长度和索引
- `String`类：用于字符串操作
- `Object`类：基础对象类型
- `Bool`类：布尔值包装类型

## 测试

测试文件位于`test/api_test.cpp`，包含了所有方法的基本功能测试和边界条件测试。 
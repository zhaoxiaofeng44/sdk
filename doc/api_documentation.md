# API 文档

## 概述

本文档描述了 `api.h` 中定义的 C++ 和 Dart 互操作 API。这些 API 提供了在 Dart 和 C++ 之间传递数据、管理内存和处理异步操作的功能。

## 核心类

### CppUserData

`CppUserData` 是用于在 Dart 和 C++ 之间传递数据的容器类。

#### 构造函数

- `CppUserData()` - 创建空的用户数据对象
- `CppUserData.withLength(int length)` - 创建指定长度的用户数据对象
- `CppUserData.constant(List<dynamic> data)` - 创建常量用户数据对象

#### 属性

- `data: List<dynamic>` - 存储数据的列表

### CppAny

所有可装箱类型的基类。

#### 派生类

- `BoxInt` - 整数装箱类
- `BoxDouble` - 浮点数装箱类
- `BoxBool` - 布尔值装箱类
- `BoxString` - 字符串装箱类

## 指针数组操作

### native_cppCreatePointerArray

```dart
CppUserData native_cppCreatePointerArray(int length)
```

创建指定长度的指针数组。

**参数：**
- `length` - 数组长度

**返回：**
- 新创建的 `CppUserData` 对象

### native_cppGetPointerArrayLength

```dart
int native_cppGetPointerArrayLength(CppUserData array)
```

获取指针数组的长度。

**参数：**
- `array` - CppUserData 对象

**返回：**
- 数组长度

### native_cppGetPointerArrayItem

```dart
Object? native_cppGetPointerArrayItem(CppUserData array, int index)
```

获取指针数组中指定索引的元素。

**参数：**
- `array` - CppUserData 对象
- `index` - 索引位置

**返回：**
- 指定位置的元素

### native_cppSetPointerArrayItem

```dart
void native_cppSetPointerArrayItem(CppUserData array, int index, Object? value)
```

设置指针数组中指定索引的元素。

**参数：**
- `array` - CppUserData 对象
- `index` - 索引位置
- `value` - 要设置的值

## 字符串操作

### native_cppToString

```dart
CppUserData native_cppToString(Object? object)
```

将对象转换为字符串的字符代码数组。

**参数：**
- `object` - 要转换的对象

**返回：**
- 包含字符代码的 CppUserData

### native_cppCharCodes

```dart
CppUserData native_cppCharCodes(Object? value)
```

获取对象字符串表示的字符代码。

**参数：**
- `value` - 要转换的值

**返回：**
- 包含字符代码的 CppUserData

### native_cppFromCharCodes

```dart
String native_cppFromCharCodes(CppUserData charCodes)
```

从字符代码数组创建字符串。

**参数：**
- `charCodes` - 字符代码数组

**返回：**
- 创建的字符串

### native_cppStringLength

```dart
int native_cppStringLength(String str)
```

获取字符串长度。

**参数：**
- `str` - 字符串

**返回：**
- 字符串长度

## 数组操作

### native_cppCreateArray

```dart
CppUserData native_cppCreateArray(List<Object?> items)
```

从列表创建 CppUserData 数组。

**参数：**
- `items` - 初始元素列表

**返回：**
- 新创建的 CppUserData

### native_cppAddToArray

```dart
void native_cppAddToArray(CppUserData array, Object? item)
```

向数组添加元素。

**参数：**
- `array` - CppUserData 对象
- `item` - 要添加的元素

### native_cppRemoveFromArray

```dart
void native_cppRemoveFromArray(CppUserData array, int index)
```

从数组中删除指定索引的元素。

**参数：**
- `array` - CppUserData 对象
- `index` - 要删除的元素索引

### native_cppClearArray

```dart
void native_cppClearArray(CppUserData array)
```

清空数组中的所有元素。

**参数：**
- `array` - CppUserData 对象

### native_cppArrayConst

```dart
CppUserData native_cppArrayConst(int length, [Object? v1, ..., Object? v10])
```

创建最多包含10个元素的常量数组。

**参数：**
- `length` - 数组长度
- `v1-v10` - 可选元素（最多10个）

**返回：**
- 新创建的 CppUserData

## 装箱和拆箱

### native_cppBox

```dart
CppAny native_cppBox(Object? value)
```

将基本类型值装箱为 CppAny 对象。

**参数：**
- `value` - 要装箱的值（支持 int, double, bool, String）

**返回：**
- 装箱后的对象

**异常：**
- `ArgumentError` - 不支持的类型

### native_cppUnbox

```dart
T native_cppUnbox<T>(Object? value)
```

将装箱对象拆箱为原始类型。

**类型参数：**
- `T` - 目标类型

**参数：**
- `value` - 装箱的对象或原始值

**返回：**
- 拆箱后的值

## 异步任务

### native_cppCreateAsyncTask

```dart
CppUserData native_cppCreateAsyncTask()
```

创建异步任务对象。

**返回：**
- 新创建的异步任务

### native_cppAwaitAsyncTask

```dart
Future<void> native_cppAwaitAsyncTask(CppUserData taskData)
```

等待异步任务完成。

**参数：**
- `taskData` - 异步任务对象

**返回：**
- Future，在任务完成时完成

### native_cppGetAsyncTaskResult

```dart
Object? native_cppGetAsyncTaskResult(CppUserData taskData)
```

获取异步任务的结果。

**参数：**
- `taskData` - 异步任务对象

**返回：**
- 任务结果

### native_cppCompleteAsyncTask

```dart
void native_cppCompleteAsyncTask(CppUserData taskData, Object? result)
```

完成异步任务并设置结果。

**参数：**
- `taskData` - 异步任务对象
- `result` - 任务结果

### native_cppCompleteAsyncTaskWithError

```dart
void native_cppCompleteAsyncTaskWithError(CppUserData taskData, Object error, [StackTrace? stackTrace])
```

以错误状态完成异步任务。

**参数：**
- `taskData` - 异步任务对象
- `error` - 错误对象
- `stackTrace` - 可选的堆栈跟踪

### native_cppIsAsyncTaskDone

```dart
bool native_cppIsAsyncTaskDone(CppUserData taskData)
```

检查异步任务是否已完成。

**参数：**
- `taskData` - 异步任务对象

**返回：**
- 如果任务已完成返回 true，否则返回 false

## 类型检查

### native_cppIsNull

```dart
bool native_cppIsNull(Object? value)
```

检查值是否为 null。

### native_cppIsInt

```dart
bool native_cppIsInt(Object? value)
```

检查值是否为整数。

### native_cppIsDouble

```dart
bool native_cppIsDouble(Object? value)
```

检查值是否为浮点数。

### native_cppIsBool

```dart
bool native_cppIsBool(Object? value)
```

检查值是否为布尔值。

### native_cppIsString

```dart
bool native_cppIsString(Object? value)
```

检查值是否为字符串。

### native_cppIsList

```dart
bool native_cppIsList(Object? value)
```

检查值是否为列表。

### native_cppIsMap

```dart
bool native_cppIsMap(Object? value)
```

检查值是否为映射。

## 类型转换

### native_cppToInt

```dart
int native_cppToInt(Object? value)
```

将值转换为整数。

**参数：**
- `value` - 要转换的值

**返回：**
- 转换后的整数，转换失败返回 0

### native_cppToDouble

```dart
double native_cppToDouble(Object? value)
```

将值转换为浮点数。

**参数：**
- `value` - 要转换的值

**返回：**
- 转换后的浮点数，转换失败返回 0.0

### native_cppToBool

```dart
bool native_cppToBool(Object? value)
```

将值转换为布尔值。

**参数：**
- `value` - 要转换的值

**返回：**
- 转换后的布尔值

## 调试功能

### native_print

```dart
void native_print(Object? object)
```

打印对象到控制台。

**参数：**
- `object` - 要打印的对象

### native_getCurrentStackTrace

```dart
CppUserData native_getCurrentStackTrace()
```

获取当前堆栈跟踪。

**返回：**
- 包含堆栈跟踪字符串的 CppUserData

## 使用示例

### 基本使用

```dart
// 创建指针数组
var array = native_cppCreatePointerArray(3);
native_cppSetPointerArrayItem(array, 0, 'Hello');
native_cppSetPointerArrayItem(array, 1, 42);
native_cppSetPointerArrayItem(array, 2, true);

// 获取元素
print(native_cppGetPointerArrayItem(array, 0)); // Hello
print(native_cppGetPointerArrayItem(array, 1)); // 42
```

### 字符串操作

```dart
// 转换字符串
var charCodes = native_cppCharCodes('Hello World');
var str = native_cppFromCharCodes(charCodes);
print(str); // Hello World
```

### 装箱和拆箱

```dart
// 装箱
var boxed = native_cppBox(42);
print(boxed is BoxInt); // true

// 拆箱
var value = native_cppUnbox<int>(boxed);
print(value); // 42
```

### 异步操作

```dart
// 创建异步任务
var task = native_cppCreateAsyncTask();

// 在另一个线程完成任务
Future.delayed(Duration(seconds: 1), () {
  native_cppCompleteAsyncTask(task, 'Result');
});

// 等待任务完成
await native_cppAwaitAsyncTask(task);
var result = native_cppGetAsyncTaskResult(task);
print(result); // Result
```

### 类型检查和转换

```dart
// 类型检查
print(native_cppIsInt(42)); // true
print(native_cppIsString('hello')); // true

// 类型转换
print(native_cppToInt('42')); // 42
print(native_cppToDouble('3.14')); // 3.14
print(native_cppToBool('true')); // true
```

## 注意事项

1. 所有 native 函数都使用 `@pragma('cpp:native', 'CppApi')` 注解标记
2. CppUserData 对象可以存储任意 Dart 对象
3. 装箱操作会创建新的对象，注意内存使用
4. 异步任务需要手动完成，否则会一直等待
5. 类型转换失败时会返回默认值而不是抛出异常

## 版本历史

- v1.0 (2024) - 初始版本
  - 实现基本的指针数组操作
  - 实现字符串转换功能
  - 实现装箱/拆箱功能
  - 实现异步任务支持
  - 添加类型检查和转换函数

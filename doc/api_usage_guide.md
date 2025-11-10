# API 使用指南

## 简介

本指南介绍如何使用 `api.h` 中定义的 C++ 和 Dart 互操作 API。这些 API 旨在简化 Dart 和 C++ 之间的数据交换和操作。

## 快速开始

### 导入 API

```dart
import 'base/api.h';
import 'base/object.dart';
import 'base/box.dart';
```

### 创建和使用数据容器

```dart
// 创建空容器
var userData = CppUserData();

// 创建指定大小的容器
var array = CppUserData.withLength(10);

// 创建常量容器
var constData = CppUserData.constant([1, 2, 3, 4, 5]);
```

## 常见使用场景

### 场景1：数据传递

在 Dart 和 C++ 之间传递复杂数据结构：

```dart
// 创建数据数组
var data = native_cppCreatePointerArray(5);

// 存储不同类型的数据
native_cppSetPointerArrayItem(data, 0, 'Name');
native_cppSetPointerArrayItem(data, 1, 25);
native_cppSetPointerArrayItem(data, 2, 3.14);
native_cppSetPointerArrayItem(data, 3, true);
native_cppSetPointerArrayItem(data, 4, ['list', 'of', 'items']);

// 读取数据
var name = native_cppGetPointerArrayItem(data, 0) as String;
var age = native_cppGetPointerArrayItem(data, 1) as int;
var pi = native_cppGetPointerArrayItem(data, 2) as double;
var flag = native_cppGetPointerArrayItem(data, 3) as bool;
var list = native_cppGetPointerArrayItem(data, 4) as List;
```

### 场景2：字符串处理

处理字符串和字符代码：

```dart
// 字符串转字符代码
var message = 'Hello, World!';
var charCodes = native_cppCharCodes(message);
print('字符代码数量: ${charCodes.data.length}');

// 字符代码转字符串
var reconstructed = native_cppFromCharCodes(charCodes);
print('重建的字符串: $reconstructed');

// 获取字符串长度
var length = native_cppStringLength(message);
print('字符串长度: $length');
```

### 场景3：动态数组操作

动态添加和删除元素：

```dart
// 创建空数组
var dynamicArray = native_cppCreatePointerArray(0);

// 添加元素
native_cppAddToArray(dynamicArray, 'First');
native_cppAddToArray(dynamicArray, 'Second');
native_cppAddToArray(dynamicArray, 'Third');

print('数组长度: ${native_cppGetPointerArrayLength(dynamicArray)}');

// 删除元素
native_cppRemoveFromArray(dynamicArray, 1); // 删除 'Second'

// 清空数组
native_cppClearArray(dynamicArray);
```

### 场景4：类型安全装箱

使用装箱确保类型安全：

```dart
// 装箱基本类型
var boxedInt = native_cppBox(42);
var boxedDouble = native_cppBox(3.14159);
var boxedBool = native_cppBox(true);
var boxedString = native_cppBox('Hello');

// 存储到数组
var mixedArray = native_cppCreatePointerArray(4);
native_cppSetPointerArrayItem(mixedArray, 0, boxedInt);
native_cppSetPointerArrayItem(mixedArray, 1, boxedDouble);
native_cppSetPointerArrayItem(mixedArray, 2, boxedBool);
native_cppSetPointerArrayItem(mixedArray, 3, boxedString);

// 拆箱获取值
var intValue = native_cppUnbox<int>(
  native_cppGetPointerArrayItem(mixedArray, 0)
);
var doubleValue = native_cppUnbox<double>(
  native_cppGetPointerArrayItem(mixedArray, 1)
);
```

### 场景5：异步操作

处理异步任务：

```dart
Future<String> fetchData() async {
  // 创建异步任务
  var task = native_cppCreateAsyncTask();
  
  // 模拟异步操作（实际使用中可能是 C++ 回调）
  Future.delayed(Duration(seconds: 2), () {
    // 完成任务
    native_cppCompleteAsyncTask(task, 'Fetched Data');
  });
  
  // 检查任务状态
  print('任务是否完成: ${native_cppIsAsyncTaskDone(task)}');
  
  // 等待任务完成
  await native_cppAwaitAsyncTask(task);
  
  // 获取结果
  var result = native_cppGetAsyncTaskResult(task);
  return result as String;
}

// 使用
void main() async {
  var data = await fetchData();
  print('接收到数据: $data');
}
```

### 场景6：错误处理

处理异步任务中的错误：

```dart
Future<void> riskyOperation() async {
  var task = native_cppCreateAsyncTask();
  
  Future.delayed(Duration(seconds: 1), () {
    try {
      // 模拟可能失败的操作
      throw Exception('操作失败');
    } catch (e, stackTrace) {
      // 以错误状态完成任务
      native_cppCompleteAsyncTaskWithError(task, e, stackTrace);
    }
  });
  
  try {
    await native_cppAwaitAsyncTask(task);
  } catch (e) {
    print('捕获错误: $e');
    // 处理错误
  }
}
```

### 场景7：类型检查和转换

运行时类型检查和安全转换：

```dart
void processValue(Object? value) {
  // 类型检查
  if (native_cppIsNull(value)) {
    print('值为 null');
    return;
  }
  
  if (native_cppIsInt(value)) {
    print('整数值: $value');
  } else if (native_cppIsDouble(value)) {
    print('浮点值: $value');
  } else if (native_cppIsString(value)) {
    print('字符串值: $value');
  } else if (native_cppIsList(value)) {
    print('列表，长度: ${(value as List).length}');
  } else if (native_cppIsMap(value)) {
    print('映射，键数量: ${(value as Map).length}');
  }
  
  // 类型转换
  var asInt = native_cppToInt(value);
  var asDouble = native_cppToDouble(value);
  var asBool = native_cppToBool(value);
  
  print('转换为 int: $asInt');
  print('转换为 double: $asDouble');
  print('转换为 bool: $asBool');
}

// 使用
processValue(42);
processValue('123');
processValue([1, 2, 3]);
```

### 场景8：调试和诊断

使用调试工具：

```dart
void debugFunction() {
  // 打印调试信息
  native_print('开始处理...');
  
  try {
    // 执行操作
    var result = performComplexOperation();
    native_print('结果: $result');
  } catch (e) {
    // 打印错误和堆栈跟踪
    native_print('发生错误: $e');
    var stackTrace = native_getCurrentStackTrace();
    native_print('堆栈跟踪: ${native_cppFromCharCodes(stackTrace)}');
  }
}

dynamic performComplexOperation() {
  // 复杂操作
  return 'Success';
}
```

## 最佳实践

### 1. 内存管理

```dart
// 好的做法：及时清理不需要的数据
var tempArray = native_cppCreatePointerArray(1000);
// 使用数组...
native_cppClearArray(tempArray); // 清理

// 使用常量数据可以减少内存分配
var constData = CppUserData.constant([1, 2, 3]);
```

### 2. 类型安全

```dart
// 好的做法：使用装箱确保类型安全
var boxed = native_cppBox(42);
var unboxed = native_cppUnbox<int>(boxed);

// 避免：直接类型转换可能失败
// var value = someObject as int; // 可能抛出异常
```

### 3. 异步操作

```dart
// 好的做法：总是等待异步任务完成
var task = native_cppCreateAsyncTask();
// ... 设置任务 ...
await native_cppAwaitAsyncTask(task);
var result = native_cppGetAsyncTaskResult(task);

// 避免：不等待就获取结果
// var result = native_cppGetAsyncTaskResult(task); // 结果可能未准备好
```

### 4. 错误处理

```dart
// 好的做法：使用 try-catch 处理潜在错误
try {
  var task = native_cppCreateAsyncTask();
  await native_cppAwaitAsyncTask(task);
  var result = native_cppGetAsyncTaskResult(task);
} catch (e, stackTrace) {
  native_print('错误: $e');
  native_print('堆栈: $stackTrace');
}
```

### 5. 类型转换

```dart
// 好的做法：使用提供的转换函数
var safeInt = native_cppToInt(unknownValue); // 返回 0 如果失败

// 避免：直接解析可能失败
// var riskyInt = int.parse(unknownValue as String); // 可能抛出异常
```

## 性能提示

1. **使用常量构造函数**：对于不变的数据，使用 `CppUserData.constant()` 可以提高性能。

2. **批量操作**：尽量批量设置数组元素而不是逐个添加。

3. **避免不必要的装箱/拆箱**：只在需要类型安全时使用装箱。

4. **重用对象**：重用 `CppUserData` 对象而不是频繁创建新对象。

5. **清理资源**：及时清理不再使用的大型数组。

## 常见问题

### Q: 什么时候应该使用装箱？

A: 当你需要确保类型安全或需要在 C++ 端明确区分类型时使用装箱。

### Q: 如何判断异步任务是否完成？

A: 使用 `native_cppIsAsyncTaskDone()` 函数检查任务状态。

### Q: 可以在 CppUserData 中存储哪些类型？

A: 可以存储任何 Dart 对象，包括基本类型、集合和自定义对象。

### Q: 类型转换失败会怎样？

A: 类型转换函数会返回默认值（0, 0.0, false）而不是抛出异常。

### Q: 如何处理大量数据？

A: 使用指针数组或创建适当大小的 `CppUserData` 对象，避免频繁的动态添加操作。

## 故障排除

### 问题：数组索引越界

```dart
// 错误
var array = native_cppCreatePointerArray(3);
native_cppGetPointerArrayItem(array, 5); // 可能出错

// 解决方案：检查长度
var length = native_cppGetPointerArrayLength(array);
if (index < length) {
  var item = native_cppGetPointerArrayItem(array, index);
}
```

### 问题：异步任务永不完成

```dart
// 确保调用完成函数
var task = native_cppCreateAsyncTask();
// ... 某些操作 ...
native_cppCompleteAsyncTask(task, result); // 不要忘记这一步！
```

### 问题：类型转换错误

```dart
// 使用类型检查
var value = native_cppGetPointerArrayItem(array, 0);
if (native_cppIsInt(value)) {
  var intValue = value as int;
} else {
  var intValue = native_cppToInt(value); // 安全转换
}
```

## 更多资源

- [API 参考文档](api_documentation.md)
- [示例代码](../test_api/api_test.dart)
- [源代码](./core/api.h)

## 联系和支持

如有问题或建议，请联系开发团队。

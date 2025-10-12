# Dart-C++ 互操作 API

这是一个用于 Dart 和 C++ 之间数据交互的 API 模块。

## 文件结构

```
base/
├── api.h           # 主 API 文件（Dart 代码）
├── object.dart     # 基础对象类定义
├── box.dart        # 装箱类型定义
├── string.dart     # 字符串工具类
├── object.h        # C++ 对象定义
└── README.md       # 本文件
```

## 核心功能

### 1. 数据容器（CppUserData）
- 在 Dart 和 C++ 之间传递数据
- 支持动态大小和常量数据
- 可存储任意 Dart 对象

### 2. 指针数组操作
- 创建和管理指针数组
- 获取和设置数组元素
- 动态添加和删除元素

### 3. 字符串处理
- 字符串与字符代码转换
- 字符串长度计算
- 支持 Unicode

### 4. 类型装箱/拆箱
- 将基本类型装箱为对象
- 类型安全的拆箱操作
- 支持 int, double, bool, String

### 5. 异步任务
- 创建和管理异步任务
- 等待任务完成
- 获取任务结果
- 错误处理

### 6. 类型检查和转换
- 运行时类型检查
- 安全的类型转换
- 默认值处理

### 7. 调试工具
- 打印调试信息
- 获取堆栈跟踪

## 快速开始

```dart
import 'api.h';

void main() {
  // 创建数组
  var array = native_cppCreatePointerArray(3);
  
  // 设置元素
  native_cppSetPointerArrayItem(array, 0, 'Hello');
  native_cppSetPointerArrayItem(array, 1, 42);
  native_cppSetPointerArrayItem(array, 2, true);
  
  // 获取元素
  print(native_cppGetPointerArrayItem(array, 0)); // Hello
  print(native_cppGetPointerArrayItem(array, 1)); // 42
  print(native_cppGetPointerArrayItem(array, 2)); // true
}
```

## 文档

详细文档请参见：
- [API 参考文档](../../../doc/api_documentation.md)
- [使用指南](../../../doc/api_usage_guide.md)

## 测试

测试文件位于：
- [测试代码](../../../test_api/api_test.dart)

运行测试：
```bash
dart test_api/api_test.dart
```

## 注意事项

1. `api.h` 文件虽然扩展名是 `.h`，但内容是 Dart 代码
2. 所有 native 函数都使用 `@pragma('cpp:native', 'CppApi')` 标记
3. 异步任务必须手动完成，否则会一直等待
4. 类型转换失败时返回默认值而不抛出异常

## 版本

当前版本：1.0

## 许可证

遵循项目主许可证。

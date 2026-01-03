# 📋 错误分析报告预览示例

## 示例：`collections.dart` 失败用例分析

### 🔍 错误信息
```
sample/cpp_generated/collections.cpp:13:16: error: use of undeclared identifier '_GrowableList'
```

### 📋 代码片段对比

#### 📄 **Dart源代码** (原始意图)
```dart
void main() {
  print('🔥 集合操作测试开始');
  
  // 1. List 操作测试
  testLists();
  // ...
}

void testLists() {
  var numbers = [1, 2, 3, 4, 5];          // ← Dart List字面量
  var fruits = ["apple", "banana"];
  // ...
}
```

#### ⚠️ **生成的C++代码** (错误位置)
```cpp
Nullable testLists() {
  dart_print(dart_string("\n📌 测试 List 操作"));
  auto numbers = _GrowableList::_literal5(dart_int(1), ...);  // ← ❌ 错误: _GrowableList未定义
  auto fruits = _GrowableList::_literal3(...);
  // ...
}
```

### 🎯 问题分析

**错误类别**: 类型转换错误

**问题原因**: List字面量被转换为`_GrowableList`，但运行时库中不存在此类型

**对比发现**:
- Dart: `[1, 2, 3]` → 简洁的List字面量语法
- C++: `_GrowableList::_literal5(...)` → 编译器生成了不存在的类型

### 💡 解决方案

- [ ] **方案1**: 修改编译器生成代码逻辑，将_GrowableList替换为List::create和add方法
- [ ] **方案2**: 在C++运行时库中实现_GrowableList辅助类
- [ ] **方案3**: 使用List<T>::_literal方法替代_GrowableList
- [ ] **其他方案**: <请在此输入自定义方案>

---

## 📊 完整报告包含

✅ **全部27个失败用例**的详细分析，每个都包含：
- 错误信息
- Dart源代码片段 (可折叠)
- C++错误位置 (精确到行)
- 问题原因分析
- 多个解决方案选项

📁 **查看完整报告**: [SAMPLE_TESTS_ERROR_ANALYSIS.md](./SAMPLE_TESTS_ERROR_ANALYSIS.md)

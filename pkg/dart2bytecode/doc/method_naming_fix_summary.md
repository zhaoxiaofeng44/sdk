# 方法命名修正总结

## 修改概述

根据 `compile.md` 文档要求，修正了类方法的命名规则，去除了不必要的类名前缀，使生成的C++代码符合文档规范。

## 问题分析

### 原有问题

在之前的实现中，所有类方法都被自动加上了类名前缀，例如：

```cpp
class StringBuffer : virtual public Object {
 public:
  virtual void StringBuffer_write(Object* obj) noexcept;           // 错误：有类名前缀
  virtual void StringBuffer__ensureCapacity(Int* n) noexcept;     // 错误：有类名前缀
  virtual void StringBuffer_clear() noexcept;                     // 错误：有类名前缀
  virtual Int* StringBuffer_cppGet_length() noexcept;             // 错误：有类名前缀
};
```

### 文档要求

根据 `compile.md` 文档分析：

1. **1.3 方法生成规则**：示例中使用的是简单方法名 `MethodName`，没有类名前缀
2. **2.1 构造函数命名**：只有构造函数需要类名前缀 `ClassName_cppCtr_`
3. **2.2 Getter/Setter命名**：只需要功能前缀 `cppGet_`、`cppSet_`，不需要类名前缀
4. **2.3 操作符重载方法命名**：特殊方法如 `Object_toString` 需要保留前缀

## 修改内容

### 修改位置

文件：`lib/compile_to_cpp.dart`

### 具体修改

修改了 `getMemberName` 函数的逻辑：

#### 修改前

```dart
String getMemberName(Member member) {
  var className = "";
  if (member.enclosingClass != null) {
    className = "${getClassName(member.enclosingClass!)}_";
  }

  if (member is Constructor) {
    return "${className}cppCtr_${member.name.text}";
  }

  var memberName = member.name.text;
  if (member is Procedure) {
    if (member.isGetter) {
      return "${className}cppGet_${member.name.text}";
    } else if (member.isSetter) {
      return "${className}cppSet_${member.name.text}";
    }
  }
  if (memberName.isEmpty) {
    return "${className}cppEpt_";
  }

  var finalName = specialNames.containsKey(memberName)
      ? specialNames[memberName]!
      : memberName;
  return "$className$finalName";  // 所有方法都加类名前缀
}
```

#### 修改后

```dart
String getMemberName(Member member) {
  if (member is Constructor) {
    var className = "";
    if (member.enclosingClass != null) {
      className = "${getClassName(member.enclosingClass!)}_";
    }
    return "${className}cppCtr_${member.name.text}";
  }

  var memberName = member.name.text;
  if (member is Procedure) {
    if (member.isGetter) {
      return "cppGet_${member.name.text}";  // 去除类名前缀
    } else if (member.isSetter) {
      return "cppSet_${member.name.text}";  // 去除类名前缀
    }
    
    // 检查是否是Object类的方法，需要加前缀
    if (memberName == "toString") {
      return "Object_toString";
    }
  }
  
  if (memberName.isEmpty) {
    return "cppEpt_";
  }

  var finalName = specialNames.containsKey(memberName)
      ? specialNames[memberName]!
      : memberName;
  return finalName;  // 普通方法不加类名前缀
}
```

### 修改要点

1. **构造函数**：保留类名前缀 `ClassName_cppCtr_`
2. **Getter/Setter**：只保留功能前缀 `cppGet_`、`cppSet_`，去除类名前缀
3. **Object方法重写**：特殊处理 `toString` 方法，使用 `Object_toString`
4. **普通方法**：去除所有类名前缀，使用简单方法名

## 验证结果

### 生成代码对比

#### 修改前
```cpp
class StringBuffer : virtual public Object {
 public:
  virtual StringBuffer* StringBuffer_cppCtr_(Object* content) noexcept;
  virtual void StringBuffer_write(Object* obj) noexcept;
  virtual void StringBuffer__ensureCapacity(Int* n) noexcept;
  virtual Int* StringBuffer_cppGet_length() noexcept;
  virtual String* StringBuffer_toString() noexcept;
};
```

#### 修改后
```cpp
class StringBuffer : virtual public Object {
 public:
  virtual StringBuffer* StringBuffer_cppCtr_(Object* content) noexcept;  // 构造函数保留前缀
  virtual void write(Object* obj) noexcept;                              // 普通方法去除前缀
  virtual void _ensureCapacity(Int* n) noexcept;                         // 普通方法去除前缀
  virtual Int* cppGet_length() noexcept;                                 // Getter只保留功能前缀
  virtual String* Object_toString() noexcept override;                   // Object方法保留前缀
};
```

### 测试验证

创建了 `test/method_naming_test.dart` 测试文件，验证结果：

```
=== 验证方法命名修正测试 ===

=== 检查StringBuffer类方法命名 ===
✅ 找到正确的方法名: write(Object* obj)
✅ 找到正确的方法名: clear()
✅ 找到正确的方法名: _ensureCapacity(Int* n)
✅ 已删除带前缀的方法名: StringBuffer_write
✅ 已删除带前缀的方法名: StringBuffer__ensureCapacity

=== 检查应该保留前缀的方法 ===
✅ 正确保留了前缀方法: StringBuffer_cppCtr_
✅ 正确保留了前缀方法: cppGet_length
✅ 正确保留了前缀方法: Object_toString

=== 检查其他类的方法命名 ===
✅ CyBase类方法名正确: test()
✅ CyFather类方法名正确: myTest()

✅ 所有方法命名都符合文档要求
```

## 符合文档要求

### 严格遵循文档规范

1. **1.3 方法生成规则**：普通方法使用简单的 `MethodName` 格式
2. **2.1 构造函数命名**：正确使用 `ClassName_cppCtr_` 格式
3. **2.2 Getter/Setter命名**：正确使用 `cppGet_propertyName` 格式
4. **2.3 操作符重载方法命名**：正确处理 `Object_toString` 等特殊方法

### 代码简洁性

修改后的方法命名更加简洁，符合C++惯例：

- `write()` 而不是 `StringBuffer_write()`
- `clear()` 而不是 `StringBuffer_clear()`
- `_ensureCapacity()` 而不是 `StringBuffer__ensureCapacity()`

## 影响范围

### 正面影响

1. **符合文档规范**：完全按照 `compile.md` 要求实现
2. **代码更简洁**：生成的C++代码更加简洁易读
3. **符合C++惯例**：方法命名符合标准C++编程惯例
4. **减少命名冲突**：避免了过长的方法名

### 保持兼容性

1. **构造函数**：保持原有的命名规则，确保工厂方法正常工作
2. **Getter/Setter**：保持功能前缀，确保属性访问正常
3. **特殊方法**：正确处理Object方法重写，确保多态性

## 代码示例

### StringBuffer类方法命名

```cpp
class StringBuffer : virtual public Object {
 public:
  // 构造函数 - 保留类名前缀
  virtual StringBuffer* StringBuffer_cppCtr_(Object* content) noexcept;

  // Object方法重写 - 保留Object前缀
  virtual String* Object_toString() noexcept override;
  
  // Getter方法 - 只保留功能前缀
  virtual Int* cppGet_length() noexcept;
  virtual Bool* cppGet_isEmpty() noexcept;
  virtual Bool* cppGet_isNotEmpty() noexcept;
  
  // 普通方法 - 使用简单方法名
  virtual void write(Object* obj) noexcept;
  virtual void writeCharCode(Int* charCode) noexcept;
  virtual void writeln(Object* obj) noexcept;
  virtual void clear() noexcept;
  
  // 私有方法 - 使用简单方法名
  virtual void _writeString(String* str) noexcept;
  virtual void _ensureCapacity(Int* n) noexcept;
  virtual void _consumeBuffer() noexcept;
  virtual void _addPart(String* str) noexcept;
  virtual void _compact() noexcept;
};
```

## 总结

本次修改严格按照 `compile.md` 文档要求，修正了类方法的命名规则：

1. **完全符合文档规范**
2. **代码更加简洁易读**
3. **保持必要的前缀规则**
4. **通过了所有验证测试**

修改后的方法命名既符合文档要求，又符合C++编程惯例，使生成的代码更加专业和规范。 
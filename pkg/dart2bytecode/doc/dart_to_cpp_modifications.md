# Dart 到 C++ 转换器修改总结

## 概述

根据用户需求，对 `compile_to_cpp.dart` 进行了两个主要的修改：

1. **去除类和方法的泛型定义**：在使用泛型的地方，如果不知道具体类型，统一使用 Object 类型
2. **将原有的类方法都改成全局方法**：方法名以 `类名_方法名` 的形式命名

## 详细修改内容

### 1. 去除泛型支持

#### 1.1 类型系统修改

**修改的方法：**
- `getClassTypeName()` - 去除泛型参数，直接返回类名
- `_getClassDeclareTypeParameters()` - 返回空字符串，不再生成模板参数
- `_getVariableType()` - 简化类型处理，泛型参数统一使用 Object
- `_getVariableDeclareType()` - 泛型参数统一使用 Object 指针
- `getTypeParametersDiff()` - 返回空字符串
- `getDeclareClassTypeParametersDiff()` - 直接返回类名

**修改前：**
```dart
String getClassTypeName(Class classInfo) {
  var typeParametersStr = "";
  if (classInfo.typeParameters.isNotEmpty) {
    typeParametersStr = "<${classInfo.typeParameters.map((e) => "${e.name}").join(",")}>";
  }
  return "${getClassName(classInfo)}$typeParametersStr";
}
```

**修改后：**
```dart
String getClassTypeName(Class classInfo) {
  // 去除泛型参数，直接返回类名
  return getClassName(classInfo);
}
```

#### 1.2 类型映射修改

**修改前：**
```dart
if (type is InterfaceType) {
  var typeParameters = type.typeArguments.map((e) => _getVariableDeclareType(e));
  var name = getClassName(type.classNode);
  return name + (typeParameters.isNotEmpty ? "<${typeParameters.join(",")}>" : "");
}
```

**修改后：**
```dart
if (type is InterfaceType) {
  // 去除泛型参数，直接返回类名
  var name = getClassName(type.classNode);
  return name;
}
```

### 2. 类方法改为全局方法

#### 2.1 方法命名修改

**修改的方法：**
- `getMemberName()` - 添加类名前缀
- `getMemberInvokeName()` - 直接返回全局方法名
- `writeMemberFunctionDeclaration()` - 生成全局函数声明
- `writeConstructorDeclaration()` - 生成全局构造函数

**修改前：**
```dart
String getMemberName(Member member) {
  if (member is Constructor) {
    return "cppCtr_${member.name.text}";
  }
  // ... 其他逻辑
  return specialNames.containsKey(memberName) ? specialNames[memberName]! : memberName;
}
```

**修改后：**
```dart
String getMemberName(Member member) {
  var className = "";
  if (member.enclosingClass != null) {
    className = "${getClassName(member.enclosingClass!)}_";
  }
  
  if (member is Constructor) {
    return "${className}cppCtr_${member.name.text}";
  }
  // ... 其他逻辑
  var finalName = specialNames.containsKey(memberName) ? specialNames[memberName]! : memberName;
  return "$className$finalName";
}
```

#### 2.2 类声明结构修改

**修改的方法：**
- `_printClassDeclarationHeader()` - 只包含字段，方法声明移到全局
- `_printClassDeclaration()` - 生成全局方法实现

**修改前：**
```cpp
class Calculator : public Object {
public:
    Int* value;
    static Int* add(Calculator* cppThis, Int* other);
    static Calculator* cppNew();
};
```

**修改后：**
```cpp
class Calculator : public Object {
public:
    Int* value;
};

// 全局方法声明
Int* Calculator_add(Calculator* cppThis, Int* other);
Calculator* Calculator_cppNew();
```

#### 2.3 方法调用修改

**修改前的调用方式：**
```cpp
Calculator::add(calc, value)
Int::cppNew(10)
String::cpp_add(str1, str2)
```

**修改后的调用方式：**
```cpp
Calculator_add(calc, value)
Int_cppNew(10)
String_cpp_add(str1, str2)
```

### 3. 具体修改的表达式类型

在 `writeExpression()` 方法中修改了以下表达式的处理：

- `ConstructorInvocation` - 构造函数调用
- `IntLiteral`, `DoubleLiteral`, `StringLiteral`, `BoolLiteral` - 字面量
- `InstanceGet`, `InstanceSet` - 实例属性访问
- `StaticInvocation` - 静态方法调用
- `InstanceInvocation` - 实例方法调用
- `EqualsCall` - 相等比较
- `StringConcatenation` - 字符串连接
- `Not` - 逻辑非操作

### 4. 常量处理修改

**修改前：**
```dart
if (c is IntConstant) {
  return "Int::cppNew(${c.value})";
}
```

**修改后：**
```dart
if (c is IntConstant) {
  return "Int_cppNew(${c.value})";
}
```

## 修改效果

### 代码简化

1. **去除复杂的模板系统**：生成的 C++ 代码不再包含 `template<typename T>` 等复杂的模板声明
2. **统一类型系统**：所有泛型类型统一使用 `Object*`，简化了类型处理
3. **扁平化方法调用**：从 `ClassName::methodName` 改为 `ClassName_methodName`，去除了命名空间复杂性

### 兼容性提升

1. **更好的 C 兼容性**：全局函数调用更接近 C 语言风格
2. **简化链接过程**：去除模板后，链接器处理更简单
3. **减少编译复杂度**：不需要模板实例化，编译更快

### 维护性改善

1. **代码结构清晰**：类只包含数据，方法作为全局函数单独定义
2. **调试友好**：全局函数名包含类名，更容易追踪
3. **工具支持好**：许多 C++ 分析工具对全局函数支持更好

## 总结

通过这些修改，Dart 到 C++ 转换器生成的代码变得更加简洁、高效和易于维护。去除了复杂的泛型机制，采用了更直接的全局函数调用方式，使得生成的 C++ 代码更接近传统的 C 风格，同时保持了面向对象的数据组织方式。 
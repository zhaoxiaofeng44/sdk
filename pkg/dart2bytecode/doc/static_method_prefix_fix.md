# 静态方法调用前缀修复

## 问题描述

在转换后的代码中，静态方法调用、静态属性访问和factory方法调用中的类名没有应用文件前缀，导致类名冲突。

### 问题示例

```dart
// 类定义时正确添加了前缀
class $AA_CppApi {
  static void print(Object? object) {
    // 但静态方法调用时没有前缀
    CppApi.print(object);  // 应该是 $AA_CppApi.print(object)
  }
}

// Factory方法调用也没有前缀
return CppList<E>.from(elements, growable: growable);  // 应该是 $XX_CppList<E>.from(...)
```

## 修复内容

### 1. StaticInvocation 修复

修复了静态方法调用中的类名前缀：

```dart
// 修复前
String className = expression.target.enclosingClass?.name;

// 修复后
String originalClassName = expression.target.enclosingClass?.name;
String className = originalClassName != null ? 
    DartToDartTransformer._getGlobalPrefixedClassName(originalClassName) : null;
```

### 2. StaticGet 修复

修复了静态属性访问中的类名前缀：

```dart
// 修复前
return encl == null ? name : '${encl.name}.$name';

// 修复后
final originalClassName = encl?.name;
final className = originalClassName != null ? 
    DartToDartTransformer._getGlobalPrefixedClassName(originalClassName) : null;
return encl == null ? name : '$className.$name';
```

### 3. StaticSet 修复

修复了静态属性设置中的类名前缀：

```dart
// 修复前
return encl == null ? '$name = $value' : '${encl.name}.$name = $value';

// 修复后
final originalClassName = encl?.name;
final className = originalClassName != null ? 
    DartToDartTransformer._getGlobalPrefixedClassName(originalClassName) : null;
return encl == null ? '$name = $value' : '$className.$name = $value';
```

### 4. StaticTearOff 修复

修复了静态方法引用中的类名前缀：

```dart
// 修复前
return encl == null ? name : '${encl.name}.$name';

// 修复后
final originalClassName = encl?.name;
final className = originalClassName != null ? 
    DartToDartTransformer._getGlobalPrefixedClassName(originalClassName) : null;
return encl == null ? name : '$className.$name';
```

### 5. FactoryConstructorInvocation 修复

修复了factory方法调用中的类名前缀：

```dart
// 修复前
String className = expression.target.enclosingClass?.name ?? 'Unknown';

// 修复后
String originalClassName = expression.target.enclosingClass?.name ?? 'Unknown';
String className = DartToDartTransformer._getGlobalPrefixedClassName(originalClassName);
```

## 修复后的效果

修复后，所有涉及类名的地方都会正确应用文件前缀：

```dart
// 修复后的代码
class $AA_CppApi {
  static void print(Object? object) {
    $AA_CppApi.print(object);  // 正确的前缀
  }
}

// Factory方法调用也有正确的前缀
return $XX_CppList<E>.from(elements, growable: growable);
```

## 技术实现

### 全局类名前缀映射

为了在表达式生成代码中访问类名前缀映射，实现了全局映射机制：

```dart
/// 全局类名前缀映射（用于表达式生成）
static final Map<String, String> _globalClassNameToPrefixedName = {};

/// 设置全局类名前缀映射
void _setGlobalClassNameMapping() {
  _globalClassNameToPrefixedName.clear();
  _globalClassNameToPrefixedName.addAll(_classNameToPrefixedName);
}

/// 获取全局带前缀的类名
static String _getGlobalPrefixedClassName(String className) {
  return _globalClassNameToPrefixedName[className] ?? className;
}
```

### 转换流程

1. 在 `transformComponent` 中首先收集所有文件路径信息
2. 设置全局类名前缀映射
3. 在表达式生成时使用全局映射获取带前缀的类名

## 测试验证

修复后，所有静态方法调用、静态属性访问和factory方法调用都会正确使用带前缀的类名，避免了类名冲突问题。

# Receiver 类型处理改进

## 概述

本文档描述了对 `compile_to_cpp.dart` 中 receiver 类型处理的改进，主要涉及 `InstanceGet`、`InstanceSet` 和 `InstanceInvocation` 表达式的处理。

## 主要改进

### 1. 统一的 Receiver 类型识别函数

新增了 `_getReceiverType()` 函数，用于统一处理各种类型的 receiver：

```dart
String _getReceiverType(Expression receiver, Member? interfaceTarget)
```

该函数支持以下 receiver 类型：
- `InstanceGet`: 使用 `interfaceTarget.getterType`
- `VariableGet`: 使用 `variable.type`
- `StaticGet`: 使用 `target.getterType`
- `ConstructorInvocation`: 使用 `constructedType`
- `ThisExpression`: 使用 `interfaceTarget.getterType`
- `StaticInvocation`: 使用 `target.function.returnType`
- `InstanceInvocation`: 使用 `interfaceTarget.getterType`
- 其他类型: 默认使用 `interfaceTarget.getterType` 或返回 "Object"

### 2. InstanceGet 处理改进

对于 `InstanceGet` 表达式，现在能够：
- 正确识别 receiver 的类型
- 生成格式为 `ClassName::memberName(receiver)` 的 C++ 代码
- 支持属性访问和方法调用两种情况

### 3. InstanceSet 处理改进

对于 `InstanceSet` 表达式，现在能够：
- 正确识别 receiver 的类型
- 生成格式为 `ClassName::memberName(receiver, value)` 的 C++ 代码
- 支持属性设置和 setter 方法调用两种情况

### 4. InstanceInvocation 处理简化

原本复杂的 `InstanceInvocation` 处理逻辑被简化为：
- 使用统一的 `_getReceiverType()` 函数获取类型
- 生成一致的 C++ 代码格式

## 代码示例

### 修改前
```dart
// InstanceGet 处理
if (expression.interfaceTarget is Procedure) {
  var procedure = expression.interfaceTarget as Procedure;
  write(getMemberInvokeName(procedure));
  // ...
}
```

### 修改后
```dart
// InstanceGet 处理
if (expression.interfaceTarget is Procedure) {
  var procedure = expression.interfaceTarget as Procedure;
  var classNameType = _getReceiverType(expression.receiver, expression.interfaceTarget);
  var memberName = getMemberName(procedure);
  write("$classNameType::$memberName");
  // ...
}
```

## 优势

1. **代码复用**: 统一的类型识别逻辑减少了重复代码
2. **一致性**: 所有相关表达式使用相同的类型推断机制
3. **可维护性**: 集中管理类型识别逻辑，便于维护和扩展
4. **正确性**: 更准确地识别 receiver 类型，生成正确的 C++ 代码

## 测试

创建了 `receiver_type_test.dart` 测试文件，包含对各种 receiver 类型的测试用例。

## 未来扩展

可以进一步扩展 `_getReceiverType()` 函数以支持更多的 receiver 类型，如：
- `SuperPropertyGet`
- `SuperPropertySet`
- `SuperMethodInvocation`
- 其他复杂表达式类型 
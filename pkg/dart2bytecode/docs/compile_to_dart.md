# DartToDartTransformer 文档

## 概述
该类用于将Dart源代码转换为新的Dart类结构，支持字段、构造函数、方法等的转换。

## 转换规则
- 字段: final 非静态字段转换为late。
- 方法: 成员方法转换为静态方法，替换this为self。
- 检查: 生成后自动验证代码完整性。

## 用法
```dart
final transformer = DartToDartTransformer();
transformer.transformComponent(component);
``` 
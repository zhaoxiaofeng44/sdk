# 闭包函数外部变量装箱实现

## 概述

本文档描述了在Dart到Dart转换过程中，对闭包函数中引用外部变量的装箱实现方案。

## 装箱规则

根据用户需求，闭包函数中的外部变量装箱遵循以下规则：

1. **被装箱变量是函数参数**：将参数名前面加上`$_`前缀，然后在函数开头使用对应box类型定义和参数同名的变量
2. **被装箱变量是内部定义的**：在定义地方使用box替换原有定义
3. **识别使用被装箱的变量地方**：使用`box.value`来进行实际计算
4. **传给其他函数的参数**：应该传入`box.value`保障逻辑正确

## 需要装箱的类型

- `int` → `Box<Int>`
- `bool` → `Box<Bool>`
- `double` → `Box<Double>`
- `String` → `Box<String>`

## 实现方案

### 1. 闭包装箱信息类

```dart
class ClosureBoxingInfo {
  final Set<String> boxedVariables = {};
  final Map<String, String> variableToBoxType = {};
  final Set<String> functionParameters = {};
  
  void addBoxedVariable(String variableName, String boxType);
  void addFunctionParameter(String paramName);
  bool isBoxedVariable(String variableName);
  bool isFunctionParameter(String variableName);
  String getBoxType(String variableName);
}
```

### 2. 装箱检测和处理

#### 2.1 类型检测
```dart
bool _needsBoxing(DartType type) {
  if (type is InterfaceType) {
    final typeName = type.classNode.name;
    return _boxableTypes.contains(typeName);
  }
  return false;
}
```

#### 2.2 装箱类型映射
```dart
String _getBoxType(DartType type) {
  if (type is InterfaceType) {
    final typeName = type.classNode.name;
    switch (typeName) {
      case 'int': return 'Box<Int>';
      case 'bool': return 'Box<Bool>';
      case 'double': return 'Box<Double>';
      case 'String': return 'Box<String>';
      default: return 'Box<Object>';
    }
  }
  return 'Box<Object>';
}
```

### 3. 变量引用处理

#### 3.1 函数参数装箱
```dart
String _processFunctionParameter(String paramName, DartType paramType) {
  final closureInfo = _getCurrentClosureInfo();
  if (closureInfo != null && _needsBoxing(paramType)) {
    closureInfo.addFunctionParameter(paramName);
    return '$_$paramName';  // 添加前缀
  }
  return paramName;
}
```

#### 3.2 变量引用装箱
```dart
String _processClosureVariableReference(String variableName, DartType variableType) {
  final closureInfo = _getCurrentClosureInfo();
  if (closureInfo != null && _needsBoxing(variableType)) {
    closureInfo.addBoxedVariable(variableName, _getBoxType(variableType));
    
    if (closureInfo.isFunctionParameter(variableName)) {
      return '$_$variableName.value';  // 函数参数
    } else {
      return '$variableName.value';    // 内部变量
    }
  }
  return variableName;
}
```

### 4. 代码生成

#### 4.1 装箱代码生成
```dart
String _generateClosureBoxingCode(ClosureBoxingInfo closureInfo) {
  if (closureInfo.boxedVariables.isEmpty) return '';
  
  final buffer = StringBuffer();
  for (final variableName in closureInfo.boxedVariables) {
    final boxType = closureInfo.getBoxType(variableName);
    
    if (closureInfo.isFunctionParameter(variableName)) {
      // 函数参数：在函数开头定义同名变量
      buffer.writeln('$boxType $variableName = $_$variableName;');
    }
  }
  return buffer.toString();
}
```

#### 4.2 函数体修改
在生成函数体时，在开头插入装箱代码：

```dart
void _generateMemberMethod(Procedure procedure) {
  // ... 生成函数签名 ...
  
  _writeLine('$returnType $methodName($parameters) {');
  _indent();
  
  // 检查是否需要闭包装箱
  final closureInfo = _getCurrentClosureInfo();
  if (closureInfo != null && closureInfo.boxedVariables.isNotEmpty) {
    // 生成装箱代码
    final boxingCode = _generateClosureBoxingCode(closureInfo);
    if (boxingCode.isNotEmpty) {
      _writeLine(boxingCode);
    }
  }
  
  // ... 生成函数体 ...
  
  _unindent();
  _writeLine('}');
}
```

## 使用示例

### 输入代码
```dart
void example() {
  int counter = 0;
  String message = "Hello";
  
  void increment() {
    counter++;  // 引用外部变量
    print(message);  // 引用外部变量
  }
  
  increment();
}
```

### 转换后的代码
```dart
void example() {
  Box<Int> counter = Box(Int(0));
  Box<String> message = Box("Hello");
  
  void increment() {
    Box<Int> counter = $_counter;  // 函数开头定义
    Box<String> message = $_message;  // 函数开头定义
    
    counter.value = counter.value.add(Int(1));  // 使用.value
    print(message.value);  // 使用.value
  }
  
  increment();
}
```

## 实现状态

当前实现已完成：

1. ✅ 闭包装箱信息类定义
2. ✅ 类型检测和装箱类型映射
3. ✅ 变量引用处理逻辑
4. ✅ 装箱代码生成
5. ✅ 函数体修改逻辑

## 注意事项

1. **作用域管理**：需要正确管理闭包作用域的进入和退出
2. **变量追踪**：需要追踪当前作用域中的所有变量及其类型
3. **函数调用**：确保传递给其他函数的参数使用`.value`
4. **类型安全**：确保装箱和拆箱操作的类型安全

## 后续优化

1. **性能优化**：减少不必要的装箱操作
2. **错误处理**：添加更完善的错误检测和处理
3. **测试覆盖**：添加全面的测试用例
4. **文档完善**：补充更详细的使用说明

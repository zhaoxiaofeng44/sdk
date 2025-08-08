# Factory方法解析修复

## 问题描述

在 `compile_to_dart.dart` 中，factory方法没有被正确识别和解析。例如：

```dart
factory CppList.from(Iterable elements, {bool growable = true}) {
  // 方法体
}
```

这种factory方法在转换过程中被跳过，导致生成的代码中缺少factory方法。

## 修复内容

### 1. 添加Factory方法识别

在 `_generateMemberMethods` 方法中添加了对 `procedure.isFactory` 的检查：

```dart
} else if (procedure.isFactory) {
  // 生成factory方法
  _generateFactoryMethod(cls, procedure);
} else if (!procedure.isStatic) {
  // 其他方法处理...
}
```

### 2. 新增Factory方法生成函数

添加了 `_generateFactoryMethod` 方法来专门处理factory方法：

```dart
/// 生成factory方法
void _generateFactoryMethod(Class cls, Procedure procedure) {
  final returnType = _getDartType(procedure.function.returnType);
  final name = procedure.name.text;
  final parameters = _writeParametersToString(procedure.function);
  
  // 处理factory方法名
  String factoryName;
  if (name.isEmpty) {
    factoryName = cls.name;
  } else {
    factoryName = '${cls.name}.$name';
  }
  
  _writeLine('factory $factoryName($parameters) {');
  _indent();
  if (procedure.function.body != null) {
    final bodyStr =
        _writeTransformedStatementToString(procedure.function.body!);
    _writeLine(bodyStr);
  }
  _unindent();
  _writeLine('}');
  _writeLine('');
}
```

### 3. 修复参数处理

改进了命名参数的处理逻辑，确保factory方法的参数正确生成：

```dart
/// 生成参数列表字符串
String _writeParametersToString(FunctionNode function,
    {bool onlyFirst = false}) {
  // 处理位置参数
  final positionalParams = onlyFirst
      ? function.positionalParameters.take(1)
      : function.positionalParameters;
  final positionalStr =
      _writeParameterList(positionalParams.toList(), function: function);

  // 处理命名参数
  final namedParams = function.namedParameters;
  String namedStr = '';
  if (namedParams.isNotEmpty) {
    final namedParamList = namedParams.map((param) {
      final type = _getDartType(param.type);
      final name = _cleanVariableName(param.name!);
      String defaultValue = '';
      if (param.initializer != null) {
        defaultValue =
            ' = ${_generateExpressionCode(param.initializer!, replaceThis: false, asStatement: false)}';
      }
      return '$type $name$defaultValue';
    }).join(', ');
    namedStr = '{$namedParamList}';
  }

  // 组合参数列表
  String parameters = positionalStr;
  if (namedStr.isNotEmpty) {
    if (parameters.isNotEmpty) {
      parameters += ', $namedStr';
    } else {
      parameters = namedStr;
    }
  }

  return parameters;
}
```

### 4. 修复构造函数调用

修复了 `ConstructorInvocation` 和 `FactoryConstructorInvocation` 的处理，移除了不必要的 `new` 关键字：

```dart
// ConstructorInvocation
return '$className($allArgs)';

// FactoryConstructorInvocation  
return '$className($allArgs)';
```

### 5. 修复实例创建

修复了 `InstanceCreation` 的处理，使用正确的参数格式：

```dart
return '$className$typeArgs($fields)';
```

### 6. 修复构造函数调用

修复了 `ConstructorInvocation` 和 `FactoryConstructorInvocation` 的处理，确保命名构造函数正确生成：

```dart
/// 修复前
} else if (expression is ConstructorInvocation) {
  // ... 处理参数
  return '$className($allArgs)';  // 缺少构造函数名
}

/// 修复后
} else if (expression is ConstructorInvocation) {
  // ... 处理参数
  
  // 处理构造函数名
  String constructorName = '';
  if (expression.target.name.text.isNotEmpty) {
    constructorName = '.${expression.target.name.text}';
  }
  
  return '$className$constructorName($allArgs)';  // 正确包含构造函数名
}
```

这样修复后，`CppList.fromCppArray(array)` 这样的命名构造函数调用能够正确生成，而不是错误的 `CppList<E>(array)`。

## 测试验证

创建了测试文件来验证修复的正确性：

1. `tests/test_factory_methods.dart` - 验证factory方法识别和生成逻辑
2. `tests/test_constructor_invocation.dart` - 验证构造函数调用的正确生成

测试结果显示所有修复都正常工作。

## 修复效果

修复后，factory方法能够正确识别和转换：

```dart
// 原始代码
factory CppList.from(Iterable elements, {bool growable = true}) {
  var length = elements.length;
  var array = growable
      ? CppApi.cppCreatePointerArray(length)
      : CppApi.cppCreatePointerArray(_getSuggestCapacity(length));
  int i = 0;
  for (var element in elements) {
    CppApi.cppSetPointerArrayItem(array, i++, element);
  }
  return CppList.fromCppArray(array);
}

// 转换后的代码
factory CppList.from(Iterable elements, {bool growable = true}) {
  var length = elements.length;
  var array = growable
      ? CppApi.cppCreatePointerArray(length)
      : CppApi.cppCreatePointerArray(_getSuggestCapacity(length));
  int i = 0;
  for (var element in elements) {
    CppApi.cppSetPointerArrayItem(array, i++, element);
  }
  return CppList.fromCppArray(array);
}
```

### 构造函数调用修复

修复了 `ConstructorInvocation` 和 `FactoryConstructorInvocation` 的处理，确保命名构造函数正确生成：

```dart
// 修复前
return CppList<E>(array);  // 缺少构造函数名

// 修复后  
return CppList.fromCppArray(array);  // 正确包含构造函数名
```

## 注意事项

1. 修复过程中避免了使用字符串替换，而是通过正确识别AST节点类型来处理
2. 保持了原有的代码结构和逻辑
3. 确保factory方法的参数（包括命名参数和默认值）正确生成
4. 修复了构造函数调用的语法，移除了不必要的 `new` 关键字 
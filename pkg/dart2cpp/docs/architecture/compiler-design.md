# Dart 到 C++ 转换器设计

## 🎯 转换器架构

Dart2CPP 转换器基于 Dart Kernel AST 进行深度语义分析和代码生成，确保生成的 C++ 代码与原始 Dart 代码具有完全等价的运行时行为。

## 🔧 核心组件

### 1. 编译流程管理 (`dart2cpp.dart`)

**主要职责**: 统一的编译入口点和流程控制

```dart
// 主要流程
Future<int> runCompiler(ArgResults options) async {
  // 1. 参数解析和验证
  final String? platformKernel = options['platform'];
  final String? input = options.rest.singleOrNull;
  
  // 2. 构建编译器选项
  final CompilerOptions compilerOptions = CompilerOptions()
    ..sdkSummary = platformKernelUri
    ..packagesFileUri = packagesUri
    ..onDiagnostic = errorDetector
    ..target = createFrontEndTarget('vm');
  
  // 3. 编译为 Kernel AST
  final results = await compileToKernel(KernelCompilationArguments(
    source: mainUri,
    options: compilerOptions,
    requireMain: false,
    includePlatform: false));
  
  // 4. 转换为 C++
  await _transformToCpp(component, outputFileName);
}
```

### 2. 核心转换器 (`dart_to_cpp_compiler.dart`)

**DartToCppTransformer 类**:

```dart
class DartToCppTransformer {
  // 类型转换器
  final CppTypeConverter typeConverter;
  
  // 表达式转换器  
  final CppExpressionConverter expressionConverter;
  
  // 声明转换器
  final CppDeclarationConverter declarationConverter;
  
  // 主转换方法
  String transformComponent(Component component) {
    StringBuffer buffer = StringBuffer();
    
    // 添加头文件
    buffer.writeln('#include "dart2cpp.h"');
    buffer.writeln();
    
    // 转换所有库
    for (Library library in component.libraries) {
      if (!library.importUri.isScheme('dart')) {
        buffer.write(transformLibrary(library));
      }
    }
    
    return buffer.toString();
  }
}
```

### 3. 类型转换系统 (`CppTypeConverter`)

**类型映射策略**:

```dart
class CppTypeConverter {
  static const Map<String, String> typeMapping = {
    'int': 'Int',
    'double': 'Double', 
    'bool': 'Bool',
    'String': 'String',
    'void': 'Nullable',
    'dynamic': 'Any',
    'List': 'List',
    'Set': 'Set',
    'Map': 'Map',
  };
  
  static String convertType(DartType type, {bool isAsync = false}) {
    if (type is InterfaceType) {
      final className = type.classNode.name;
      
      // 基础类型映射
      if (typeMapping.containsKey(className)) {
        String cppType = typeMapping[className]!;
        
        // 处理泛型类型
        if (type.typeArguments.isNotEmpty) {
          final typeArgs = type.typeArguments
              .map((arg) => convertType(arg))
              .join(', ');
          cppType = '$cppType<$typeArgs>';
        }
        
        return cppType;
      }
      
      // 自定义类型
      return className;
    }
    
    return 'Any'; // 默认类型
  }
}
```

### 4. 表达式转换器 (`CppExpressionConverter`)

**表达式转换策略**:

```dart
class CppExpressionConverter {
  String convertExpression(Expression expr) {
    // 字面量表达式
    if (expr is StringLiteral) {
      return 'dart_string("${escapeString(expr.value)}")';
    } else if (expr is IntLiteral) {
      return 'dart_int(${expr.value})';
    } else if (expr is DoubleLiteral) {
      return 'dart_double(${expr.value})';
    } else if (expr is BoolLiteral) {
      return 'dart_bool(${expr.value})';
    }
    
    // 变量访问
    else if (expr is VariableGet) {
      return expr.variable.name ?? 'unnamed_var';
    }
    
    // 方法调用
    else if (expr is InstanceInvocation) {
      return convertInstanceInvocation(expr);
    }
    
    // 二元运算
    else if (expr is LogicalExpression) {
      return convertLogicalExpression(expr);
    }
    
    // ... 其他表达式类型
  }
}
```

## 🔄 转换规则详解

### 1. 变量声明转换

**Dart 代码**:
```dart
var x = 42;
final String name = "Alice";
const double pi = 3.14159;
int? nullable;
```

**转换后的 C++ 代码**:
```cpp
auto x = dart_int(42);
const auto name = dart_string("Alice");
const auto pi = dart_double(3.14159);
Int nullable; // 默认为 null
```

### 2. 函数声明转换

**Dart 代码**:
```dart
int add(int a, int b) {
  return a + b;
}

void greet(String name, [String? title]) {
  if (title != null) {
    print('Hello, $title $name!');
  } else {
    print('Hello, $name!');
  }
}
```

**转换后的 C++ 代码**:
```cpp
Int add(Int a, Int b) {
  return (a + b);
}

Nullable greet(String name, String title = Null) {
  if (!dart_is_null(title)) {
    dart_print(dart_concat(dart_string("Hello, "), title, 
                          dart_string(" "), name, dart_string("!")));
  } else {
    dart_print(dart_concat(dart_string("Hello, "), name, dart_string("!")));
  }
  return Void;
}
```

### 3. 类声明转换

**Dart 代码**:
```dart
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  void introduce() {
    print('I am $name, $age years old.');
  }
}
```

**转换后的 C++ 代码**:
```cpp
class Person : public Any {
public:
  String name;
  Int age;
  
  Person(String name, Int age) : name(name), age(age) {
    type_id = 6; // UserData
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("I am "), name, 
                          dart_string(", "), age, dart_string(" years old.")));
    return Void;
  }
};
```

### 4. 控制流转换

**if-else 语句**:
```dart
// Dart
if (score >= 90) {
  grade = 'A';
} else if (score >= 80) {
  grade = 'B';
} else {
  grade = 'C';
}
```

```cpp
// C++
if ((score >= dart_int(90))) {
  grade = dart_string("A");
} else {
  if ((score >= dart_int(80))) {
    grade = dart_string("B");
  } else {
    grade = dart_string("C");
  }
}
```

**for 循环**:
```dart
// Dart
for (int i = 0; i < 10; i++) {
  print(i);
}
```

```cpp
// C++
for (auto i = dart_int(0); (i < dart_int(10)); i = (i + dart_int(1))) {
  dart_print(i);
}
```

**for-in 循环**:
```dart
// Dart
for (String item in items) {
  print(item);
}
```

```cpp
// C++
for (auto sync_for_iterator = items->iterator(); sync_for_iterator->moveNext(); ) {
auto item = sync_for_iterator->current();
  dart_print(item);
}
```

### 5. 运算符转换

**算术运算符**:
```dart
// Dart
int result = a + b * c - d / e;
```

```cpp
// C++
auto result = ((a + (b * c)) - (d / e));
```

**比较运算符**:
```dart
// Dart
bool isEqual = (x == y);
bool isGreater = (x > y);
```

```cpp
// C++
auto isEqual = (x == y);
auto isGreater = (x > y);
```

**逻辑运算符**:
```dart
// Dart
bool result = (a && b) || (!c);
```

```cpp
// C++
auto result = ((a && b) || (!(c)));
```

### 6. 空安全转换

**空值检查操作符 `?.`**:
```dart
// Dart
String? result = obj?.method()?.property;
```

```cpp
// C++
auto result = dart_null_check(obj, 
                dart_null_check(obj->method(), 
                  obj->method()->property));
```

**空合并操作符 `??`**:
```dart
// Dart
String name = userName ?? 'Anonymous';
```

```cpp
// C++
auto name = dart_null_coalesce(userName, dart_string("Anonymous"));
```

## 🎯 高级特性转换

### 1. 泛型支持

**Dart 代码**:
```dart
List<int> numbers = [1, 2, 3];
Map<String, int> scores = {'Alice': 95, 'Bob': 87};
```

**转换后的 C++ 代码**:
```cpp
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto scores = Map<String, Int>::create();
scores->put(dart_string("Alice"), dart_int(95));
scores->put(dart_string("Bob"), dart_int(87));
```

### 2. 异步编程

**Dart 代码**:
```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Data loaded';
}
```

**转换后的 C++ 代码**:
```cpp
ObjectPtr<Future<String>> fetchData() {
  return Future<String>::delayed(
    Duration::seconds(1),
    []() { return dart_string("Data loaded"); }
  );
}
```

### 3. 高阶函数

**Dart 代码**:
```dart
List<int> doubled = numbers.map((n) => n * 2).toList();
List<int> evens = numbers.where((n) => n % 2 == 0).toList();
```

**转换后的 C++ 代码**:
```cpp
auto doubled = numbers->map([](Int n) { return (n * dart_int(2)); })->toList();
auto evens = numbers->where([](Int n) { 
  return ((n % dart_int(2)) == dart_int(0)); 
})->toList();
```

## 🔍 错误处理和诊断

### 1. 编译时错误检测

```dart
class ErrorDetector {
  bool hasCompilationErrors = false;
  
  void call(DiagnosticMessage message) {
    if (message.severity == Severity.error) {
      hasCompilationErrors = true;
      print('Error: ${message.plainTextFormatted.join('\n')}');
    }
  }
}
```

### 2. 转换错误处理

```dart
class ConversionException implements Exception {
  final String message;
  final String? context;
  
  ConversionException(this.message, [this.context]);
  
  @override
  String toString() {
    if (context != null) {
      return 'Conversion Error: $message\nContext: $context';
    }
    return 'Conversion Error: $message';
  }
}
```

## 📊 优化策略

### 1. 代码生成优化

- **常量折叠**: 编译时计算常量表达式
- **死代码消除**: 移除不可达代码
- **内联优化**: 内联简单函数调用

### 2. 内存优化

- **字符串池**: 复用相同字符串字面量
- **智能指针**: 自动内存管理
- **延迟初始化**: 按需创建对象

### 3. 性能优化

- **类型特化**: 为常用类型生成特化代码
- **循环优化**: 优化循环结构
- **缓存友好**: 优化数据访问模式

## 🧪 测试和验证

### 1. 单元测试

每个转换器组件都有对应的单元测试，确保转换的正确性：

```dart
test('convert int literal', () {
  final expr = IntLiteral(42);
  final result = converter.convertExpression(expr);
  expect(result, equals('dart_int(42)'));
});
```

### 2. 集成测试

通过完整的 Dart 程序验证转换器的整体功能：

```dart
test('convert complete program', () {
  final dartCode = '''
    void main() {
      print('Hello, World!');
    }
  ''';
  
  final cppCode = compiler.compile(dartCode);
  expect(cppCode, contains('dart_print(dart_string("Hello, World!"))'));
});
```

### 3. 行为一致性测试

确保转换后的 C++ 代码与原始 Dart 代码具有相同的运行时行为。

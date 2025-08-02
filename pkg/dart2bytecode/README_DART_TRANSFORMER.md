# Dart到Dart转换器

一个基于kernel AST的Dart源码转换器，能够将Dart代码转换为新的Dart类型结构。

## 功能特性

### ✅ 已实现功能

1. **成员方法静态化**
   - 将所有非静态成员方法转换为静态方法
   - 在方法签名中添加实例参数（如 `Person self`）
   - 将方法体内的 `this` 引用替换为 `self`

2. **构造方法拆分**
   - 将 `final` 字段转换为 `late` 字段
   - 创建无参构造方法
   - 将原构造逻辑转换为静态 `create` 方法
   - 支持命名构造方法的转换

3. **调用方式调整**
   - 对象创建：`Person("Alice", 25)` → `Person.create("Alice", 25)`
   - 方法调用：`person.sayHello()` → `Person.sayHello(person)`
   - 字段访问：`this.name` → `self.name`

## 转换示例

### 原始代码
```dart
class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
  
  void sayHello() {
    print('Hello, I am $name');
  }
  
  int getAge() {
    return age;
  }
}
```

### 转换后代码
```dart
class Person {
  late String name;
  late int age;
  
  Person();
  
  static Person create(String name, int age) {
    final instance = Person();
    instance.name = name;
    instance.age = age;
    return instance;
  }
  
  static void sayHello(Person self) {
    print('Hello, I am ${self.name}');
  }
  
  static int getAge(Person self) {
    return self.age;
  }
}
```

## 使用方法

### 命令行工具
```bash
# 显示演示
dart bin/dart2dart.dart demo

# 显示帮助
dart bin/dart2dart.dart help

# 转换文件（需要进一步实现）
dart bin/dart2dart.dart transform input.dart
```

### 编程接口
```dart
import 'package:your_package/compile_to_dart.dart';

void main() {
  Component component = getYourComponent();
  transformDartToDart(component);
}
```

## 项目结构

```
dart2bytecode/
├── lib/
│   └── compile_to_dart.dart          # 核心转换器
├── bin/
│   └── dart2dart.dart               # 命令行工具
├── test/
│   ├── simple_dart_transformer_demo.dart    # 简单演示
│   ├── dart_transformer_integration_test.dart # 集成测试
│   ├── transformer_test.dart         # 转换器测试
│   └── example.dart                  # 示例文件
├── doc/
│   ├── dart_transformer_documentation.md    # 详细文档
│   └── dart_transformer_summary.md          # 项目总结
└── README_DART_TRANSFORMER.md       # 本文件
```

## 核心组件

### DartToDartTransformer
主要的转换器类，负责：
- 收集类信息
- 生成转换后的代码
- 处理各种Dart语法结构

### ClassInfo
类信息收集器，包含：
- `lateFields`: 需要转换为late的字段
- `constructors`: 构造方法列表
- `staticMethods`: 需要转换为静态方法的成员方法

## 转换规则

### 1. 字段转换
- `final String name;` → `late String name;`

### 2. 构造方法转换
- `Person(this.name, this.age);` → 
  ```dart
  Person();
  static Person create(String name, int age) {
    final instance = Person();
    instance.name = name;
    instance.age = age;
    return instance;
  }
  ```

### 3. 方法转换
- `void sayHello() { ... }` → `static void sayHello(Person self) { ... }`

### 4. 调用转换
- `Person("Alice", 25)` → `Person.create("Alice", 25)`
- `person.sayHello()` → `Person.sayHello(person)`

## 测试

运行测试：
```bash
# 基本测试
dart test/transformer_test.dart

# 演示
dart test/simple_dart_transformer_demo.dart

# 集成测试
dart test/dart_transformer_integration_test.dart
```

## 技术特点

### 基于Kernel AST
- 使用Dart的kernel包进行AST操作
- 支持完整的Dart语法结构
- 可以处理复杂的代码转换

### 模块化设计
- 分离的代码生成逻辑
- 可扩展的转换规则
- 清晰的类结构

### 可扩展性
- 支持自定义转换规则
- 可以添加新的表达式类型处理
- 支持不同的输出格式

## 未来扩展

### 计划中的功能
1. **完整的文件解析** - 从Dart源码文件直接解析为Component
2. **泛型支持** - 处理泛型类和方法的转换
3. **继承关系** - 正确处理类的继承和接口实现
4. **更复杂的表达式** - 支持更多类型的表达式转换
5. **错误处理** - 添加更完善的错误处理和报告

### 可能的改进
1. **性能优化** - 优化大文件的转换性能
2. **配置选项** - 支持自定义转换规则
3. **IDE集成** - 提供IDE插件支持
4. **反向转换** - 支持从转换后代码恢复到原始代码

## 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 许可证

本项目采用MIT许可证。 
# Dart到Dart转换器文档

## 概述

这个转换器将Dart源码转换为新的Dart类型，主要实现以下功能：

1. **将类的成员方法全部转成静态方法**
2. **构造方法拆分成两步**：无参构造 + 静态初始化方法
3. **调整调用方法的地方**，让其正常

## 转换规则

### 1. 成员方法静态化

**原始代码：**
```dart
class Person {
  void sayHello() {
    print('Hello, I am $name');
  }
}
```

**转换后：**
```dart
class Person {
  static void sayHello(Person self) {
    print('Hello, I am ${self.name}');
  }
}
```

### 2. 构造方法拆分

**原始代码：**
```dart
class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
}
```

**转换后：**
```dart
class Person {
  late String name;
  late int age;
  
  Person(); // 无参构造
  
  static Person create(String name, int age) {
    final instance = Person();
    instance.name = name;
    instance.age = age;
    return instance;
  }
}
```

### 3. 调用方式调整

**原始调用：**
```dart
final person = Person("Alice", 25);
person.sayHello();
int age = person.getAge();
```

**转换后调用：**
```dart
final person = Person.create("Alice", 25);
Person.sayHello(person);
int age = Person.getAge(person);
```

## 实现细节

### 类信息收集

转换器会收集以下信息：
- `lateFields`: 需要转换为late的字段（原final字段）
- `constructors`: 构造方法列表
- `staticMethods`: 需要转换为静态方法的成员方法

### 代码生成

1. **生成late字段**：将所有final字段转换为late字段
2. **生成无参构造**：创建简单的无参构造方法
3. **生成静态create方法**：将原构造逻辑转换为静态方法
4. **生成静态成员方法**：将成员方法转换为静态方法，添加self参数

### 表达式转换

- `this` → `self`
- `this.field` → `self.field`
- `this.method()` → `self.method()`
- `new Class()` → `Class.create()`

## 使用方法

```dart
import 'package:your_package/compile_to_dart.dart';

void main() {
  // 假设你已经有了一个Component对象
  Component component = getYourComponent();
  
  // 执行转换
  transformDartToDart(component);
  
  // 转换后的代码会输出到 transformed_dart.dart 文件
}
```

## 注意事项

1. **系统类跳过**：转换器会跳过dart:开头的系统类
2. **私有成员跳过**：以_开头的私有成员会被跳过
3. **抽象方法处理**：抽象方法不会被转换
4. **工厂方法处理**：工厂方法保持原样

## 扩展功能

未来可以考虑添加的功能：
- 支持泛型类转换
- 支持继承关系处理
- 支持接口实现转换
- 支持更复杂的表达式转换 
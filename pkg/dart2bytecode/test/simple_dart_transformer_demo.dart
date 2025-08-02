import '../lib/compile_to_dart.dart';

/// 简单的Dart转换器演示
void main() {
  print('Dart转换器演示');
  print('这个转换器将实现以下功能：');
  print('1. 将类的成员方法全部转成静态方法');
  print('2. 构造方法拆分成两步：无参构造 + 静态初始化方法');
  print('3. 调整调用方法的地方，让其正常');
  print('');

  // 创建一个简单的示例
  demonstrateTransformation();
}

/// 演示转换过程
void demonstrateTransformation() {
  print('原始Dart代码示例：');
  print('''
class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
  
  void sayHello() {
    print('Hello, I am \$name');
  }
  
  int getAge() {
    return age;
  }
}
''');

  print('转换后的Dart代码：');
  print('''
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
    print('Hello, I am \${self.name}');
  }
  
  static int getAge(Person self) {
    return self.age;
  }
}
''');

  print('调用方式的变化：');
  print('原始调用：');
  print('  final person = Person("Alice", 25);');
  print('  person.sayHello();');
  print('  int age = person.getAge();');
  print('');
  print('转换后调用：');
  print('  final person = Person.create("Alice", 25);');
  print('  Person.sayHello(person);');
  print('  int age = Person.getAge(person);');
}

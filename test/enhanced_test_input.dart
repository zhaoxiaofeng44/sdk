// Enhanced Conversion Test Input
// 测试所有支持的特性

// ============================================================================
// 1. 简单类定义
// ============================================================================

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  String introduce() {
    return "I'm ${name}, ${age} years old";
  }
}

// ============================================================================
// 2. 继承
// ============================================================================

class Animal {
  String name;
  Animal(this.name);
  String makeSound() => "Some sound";
}

class Dog extends Animal {
  Dog(String name) : super(name);
  String makeSound() => "Woof!";
}

// ============================================================================
// 3. 基本类型和变量
// ============================================================================

void testBasicTypes() {
  var x = 5;
  int y = 10;
  double pi = 3.14;
  bool flag = true;
  String name = "Dart";

  var sum = x + y;
  var product = x * 2;
  var isPositive = x > 0;
}

// ============================================================================
// 4. 集合操作
// ============================================================================

void testCollections() {
  List<int> numbers = [1, 2, 3];
  numbers.add(4);

  Set<String> names = {};
  names.add("Alice");
  names.add("Bob");

  Map<String, int> ages = {};
  ages["Alice"] = 25;

  for (var num in numbers) {
    print(num);
  }
}

// ============================================================================
// 5. 控制流
// ============================================================================

void testControlFlow() {
  var x = 5;

  if (x > 0) {
    print("Positive");
  } else {
    print("Non-positive");
  }

  for (int i = 0; i < 10; i++) {
    print(i);
  }

  while (x > 0) {
    x = x - 1;
  }
}

// ============================================================================
// 6. 字符串插值
// ============================================================================

void testStringInterpolation() {
  var name = "Alice";
  var age = 25;

  var message = "Hello, ${name}!";
  var info = "Name: ${name}, Age: ${age}";
  var calculation = "Sum: ${5 + 3}";
}

// ============================================================================
// 7. 类型转换
// ============================================================================

void testTypeConversions() {
  int x = 42;
  String s = x.toString();

  String numStr = "123";
  int parsed = int.parse(numStr);

  double d = x.toDouble();
}

// ============================================================================
// 8. 对象创建（自定义类）
// ============================================================================

void testObjectCreation() {
  var person = Person("Alice", 25);
  print(person.introduce());

  var dog = Dog("Buddy");
  print(dog.makeSound());
}

// ============================================================================
// 9. 数学运算
// ============================================================================

void testMathOperations() {
  var a = 10;
  var b = 3;

  var division = a ~/ b; // 整除
  var modulo = a % b; // 取模
  var sum = a + b;
  var product = a * b;
}

// ============================================================================
// 主函数
// ============================================================================

void main() {
  testBasicTypes();
  testCollections();
  testControlFlow();
  testStringInterpolation();
  testTypeConversions();
  testObjectCreation();
  testMathOperations();

  print("All tests completed!");
}

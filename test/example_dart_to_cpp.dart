// ============================================================================
// Dart 到 C++ 转换示例文件
// 演示各种 Dart 语法特性的转换
// ============================================================================

/// 简单的数据类
class Person {
  String name;
  int age;
  bool isStudent;

  Person(this.name, this.age, this.isStudent);

  /// 获取信息的方法
  String getInfo() {
    return "Name: $name, Age: $age, Student: $isStudent";
  }

  /// 检查是否成年
  bool isAdult() {
    return age >= 18;
  }

  /// 静态方法
  static Person createStudent(String name, int age) {
    return Person(name, age, true);
  }
}

/// 抽象基类
abstract class Animal {
  String species;

  Animal(this.species);

  /// 抽象方法
  void makeSound();

  /// 具体方法
  String getSpecies() {
    return species;
  }
}

/// 具体实现类
class Dog extends Animal {
  String breed;

  Dog(String species, this.breed) : super(species);

  @override
  void makeSound() {
    print("Woof! Woof!");
  }

  String getBreed() {
    return breed;
  }
}

/// 混入示例
mixin Flyable {
  double altitude = 0.0;

  void fly(double height) {
    altitude = height;
    print("Flying at altitude: $height meters");
  }

  void land() {
    altitude = 0.0;
    print("Landing...");
  }
}

/// 使用混入的类
class Bird extends Animal with Flyable {
  Bird(String species) : super(species);

  @override
  void makeSound() {
    print("Tweet! Tweet!");
  }
}

/// 工具函数示例
int fibonacci(int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

/// 列表操作示例
List<int> processNumbers(List<int> numbers) {
  var result = <int>[];

  for (int num in numbers) {
    if (num % 2 == 0) {
      result.add(num * 2);
    }
  }

  return result;
}

/// 字符串操作示例
String formatMessage(String name, int count) {
  var message = "Hello, $name!";
  if (count > 1) {
    message += " You have $count messages.";
  } else if (count == 1) {
    message += " You have 1 message.";
  } else {
    message += " No messages.";
  }
  return message;
}

/// 异步函数示例
Future<String> fetchUserData(String userId) async {
  // 模拟网络延迟
  await Future.delayed(Duration(seconds: 1));
  return "User data for $userId";
}

/// 异步处理示例
Future<void> processUserData() async {
  try {
    var userData = await fetchUserData("12345");
    print("Received: $userData");
  } catch (e) {
    print("Error: $e");
  }
}

/// 泛型函数示例
T getFirst<T>(List<T> items) {
  if (items.isEmpty) {
    throw Exception("List is empty");
  }
  return items.first;
}

/// Map操作示例
Map<String, int> countWords(List<String> words) {
  var wordCount = <String, int>{};

  for (String word in words) {
    wordCount[word] = (wordCount[word] ?? 0) + 1;
  }

  return wordCount;
}

/// 主函数
void main() async {
  print("=== Dart 到 C++ 转换示例 ===");

  // 1. 基本类使用
  print("\n1. 基本类使用:");
  var person1 = Person("Alice", 25, false);
  var person2 = Person.createStudent("Bob", 20);

  print(person1.getInfo());
  print(person2.getInfo());
  print("Alice is adult: ${person1.isAdult()}");
  print("Bob is adult: ${person2.isAdult()}");

  // 2. 继承和多态
  print("\n2. 继承和多态:");
  var dog = Dog("Canine", "Golden Retriever");
  print("Dog species: ${dog.getSpecies()}");
  print("Dog breed: ${dog.getBreed()}");
  dog.makeSound();

  // 3. 混入使用
  print("\n3. 混入使用:");
  var bird = Bird("Sparrow");
  print("Bird species: ${bird.getSpecies()}");
  bird.makeSound();
  bird.fly(100.0);
  bird.land();

  // 4. 数学计算
  print("\n4. 数学计算:");
  print("Fibonacci(10) = ${fibonacci(10)}");

  // 5. 列表操作
  print("\n5. 列表操作:");
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var processed = processNumbers(numbers);
  print("Original: $numbers");
  print("Processed: $processed");

  // 6. 字符串操作
  print("\n6. 字符串操作:");
  print(formatMessage("Charlie", 0));
  print(formatMessage("David", 1));
  print(formatMessage("Eve", 5));

  // 7. 泛型使用
  print("\n7. 泛型使用:");
  var intList = [10, 20, 30];
  var stringList = ["apple", "banana", "cherry"];
  print("First int: ${getFirst(intList)}");
  print("First string: ${getFirst(stringList)}");

  // 8. Map操作
  print("\n8. Map操作:");
  var words = ["hello", "world", "hello", "dart", "world", "hello"];
  var wordCount = countWords(words);
  print("Word count: $wordCount");

  // 9. 异步操作
  print("\n9. 异步操作:");
  await processUserData();

  print("\n=== 示例完成 ===");
}


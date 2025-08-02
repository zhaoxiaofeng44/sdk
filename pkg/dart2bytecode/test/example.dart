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

  void setAge(int newAge) {
    // 注意：这里会有问题，因为age是final
    // 但在转换后的代码中，它会变成late，所以可以修改
  }
}

class Calculator {
  int add(int a, int b) {
    return a + b;
  }

  int subtract(int a, int b) {
    return a - b;
  }

  void printResult(int result) {
    print('Result: $result');
  }
}

void main() {
  final person = Person('Alice', 25);
  person.sayHello();

  final calc = Calculator();
  final sum = calc.add(5, 3);
  calc.printResult(sum);
}

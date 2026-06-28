// Simple example: Hello World with a class
class Greeter {
  final String name;

  Greeter(this.name);

  String greet() {
    return 'Hello, $name!';
  }

  void sayHello() {
    print(greet());
  }
}

void main() {
  final greeter = Greeter('World');
  greeter.sayHello();

  // Test with different names
  final names = ['Alice', 'Bob', 'Charlie'];
  for (final name in names) {
    final g = Greeter(name);
    g.sayHello();
  }
}

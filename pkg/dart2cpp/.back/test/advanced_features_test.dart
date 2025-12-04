/// Advanced Dart Features Test
///
/// Tests advanced Dart language features including generics,
/// closures, async/await, and more complex scenarios.

void main() {
  print('=== Advanced Dart Features Test ===\n');

  testGenerics();
  testClosures();
  testHigherOrderFunctions();
  testCascadeNotation();
  testEnums();
  testMixins();
  testFactoryConstructors();
  testOperatorOverloading();
  testGettersSetters();
  testStaticMembers();

  print('\n=== All Advanced Tests Completed ===');
}

// ============================================================================
// 1. Generics Tests
// ============================================================================

void testGenerics() {
  print('Test 1: Generics');

  // Generic class
  Box<int> intBox = Box<int>(42);
  Box<String> stringBox = Box<String>('Hello');
  Box<double> doubleBox = Box<double>(3.14);

  print('  Int Box: ${intBox.getValue()}');
  print('  String Box: ${stringBox.getValue()}');
  print('  Double Box: ${doubleBox.getValue()}');

  // Generic method
  List<int> intList = [1, 2, 3];
  swap(intList, 0, 2);
  print('  Swapped list: $intList');

  // Generic with constraints
  NumberBox<int> intNumBox = NumberBox<int>(10);
  NumberBox<double> doubleNumBox = NumberBox<double>(20.5);
  print('  Number boxes: ${intNumBox.getValue()}, ${doubleNumBox.getValue()}');

  // Generic collections
  Pair<String, int> pair = Pair<String, int>('age', 25);
  print('  Pair: ${pair.first}, ${pair.second}');

  // Generic cache
  Cache<String, int> cache = Cache<String, int>();
  cache.put('one', 1);
  cache.put('two', 2);
  print('  Cache get one: ${cache.get('one')}');
  print('  Cache get two: ${cache.get('two')}');

  print('  ✓ Generics test passed\n');
}

class Box<T> {
  T _value;

  Box(this._value);

  T getValue() => _value;
  void setValue(T value) => _value = value;
}

void swap<T>(List<T> list, int i, int j) {
  T temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

class NumberBox<T extends num> {
  T _value;

  NumberBox(this._value);

  T getValue() => _value;
  T add(T other) => (_value + other) as T;
}

class Pair<F, S> {
  F first;
  S second;

  Pair(this.first, this.second);
}

class Cache<K, V> {
  Map<K, V> _cache = {};

  void put(K key, V value) {
    _cache[key] = value;
  }

  V? get(K key) {
    return _cache[key];
  }

  bool containsKey(K key) {
    return _cache.containsKey(key);
  }

  void clear() {
    _cache.clear();
  }
}

// ============================================================================
// 2. Closures Tests
// ============================================================================

void testClosures() {
  print('Test 2: Closures');

  // Simple closure
  Function makeAdder(int addBy) {
    return (int i) => i + addBy;
  }

  var add2 = makeAdder(2);
  var add5 = makeAdder(5);

  print('  Add 2 to 10: ${add2(10)}');
  print('  Add 5 to 10: ${add5(10)}');

  // Counter closure
  Function makeCounter() {
    int count = 0;
    return () {
      count++;
      return count;
    };
  }

  var counter = makeCounter();
  print('  Counter: ${counter()}, ${counter()}, ${counter()}');

  // Closure with multiple variables
  Function makeMultiplier(int factor) {
    int callCount = 0;
    return (int value) {
      callCount++;
      print('    Called $callCount times');
      return value * factor;
    };
  }

  var triple = makeMultiplier(3);
  print('  Triple 5: ${triple(5)}');
  print('  Triple 7: ${triple(7)}');

  // Closure capturing loop variable
  List<Function> functions = [];
  for (int i = 0; i < 3; i++) {
    int captured = i;
    functions.add(() => captured);
  }

  print('  Captured values: ${functions[0]()}, ${functions[1]()}, ${functions[2]()}');

  print('  ✓ Closures test passed\n');
}

// ============================================================================
// 3. Higher-Order Functions Tests
// ============================================================================

void testHigherOrderFunctions() {
  print('Test 3: Higher-Order Functions');

  List<int> numbers = [1, 2, 3, 4, 5];

  // map
  List<int> doubled = numbers.map((n) => n * 2).toList();
  print('  Doubled: $doubled');

  // where (filter)
  List<int> evens = numbers.where((n) => n % 2 == 0).toList();
  print('  Evens: $evens');

  // reduce
  int sum = numbers.reduce((a, b) => a + b);
  print('  Sum: $sum');

  // fold
  int product = numbers.fold(1, (a, b) => a * b);
  print('  Product: $product');

  // any
  bool hasEven = numbers.any((n) => n % 2 == 0);
  print('  Has even: $hasEven');

  // every
  bool allPositive = numbers.every((n) => n > 0);
  print('  All positive: $allPositive');

  // forEach
  print('  ForEach:');
  numbers.forEach((n) => print('    Number: $n'));

  // Custom higher-order function
  int result = applyTwice(5, (x) => x * 2);
  print('  Apply twice (5 * 2 * 2): $result');

  // Function composition
  int Function(int) addOne = (x) => x + 1;
  int Function(int) multiplyByTwo = (x) => x * 2;
  int composed = multiplyByTwo(addOne(5));
  print('  Composed ((5 + 1) * 2): $composed');

  print('  ✓ Higher-order functions test passed\n');
}

int applyTwice(int value, int Function(int) func) {
  return func(func(value));
}

// ============================================================================
// 4. Cascade Notation Tests
// ============================================================================

void testCascadeNotation() {
  print('Test 4: Cascade Notation');

  // Basic cascade
  Person person = Person('Alice', 25)
    ..name = 'Alice Smith'
    ..age = 26;

  print('  Person: ${person.name}, ${person.age}');

  // Cascade with methods
  StringBuilder builder = StringBuilder()
    ..append('Hello')
    ..append(' ')
    ..append('World')
    ..append('!');

  print('  StringBuilder: ${builder.toString()}');

  // Nested cascade
  List<int> numbers = []
    ..add(1)
    ..add(2)
    ..add(3)
    ..addAll([4, 5]);

  print('  Numbers: $numbers');

  print('  ✓ Cascade notation test passed\n');
}

class StringBuilder {
  String _buffer = '';

  void append(String text) {
    _buffer += text;
  }

  @override
  String toString() {
    return _buffer;
  }
}

// ============================================================================
// 5. Enums Tests
// ============================================================================

void testEnums() {
  print('Test 5: Enums');

  // Basic enum
  Color red = Color.red;
  Color green = Color.green;
  Color blue = Color.blue;

  print('  Colors: ${red.name}, ${green.name}, ${blue.name}');

  // Enum in switch
  String colorName = getColorName(red);
  print('  Color name: $colorName');

  // Enum values
  print('  All colors:');
  for (Color color in Color.values) {
    print('    ${color.name}');
  }

  // Enum index
  print('  Red index: ${red.index}');
  print('  Green index: ${green.index}');

  // Status enum
  Status status = Status.pending;
  print('  Status: ${status.name}');

  status = Status.completed;
  print('  Updated status: ${status.name}');

  print('  ✓ Enums test passed\n');
}

enum Color { red, green, blue }

enum Status { pending, inProgress, completed, failed }

String getColorName(Color color) {
  switch (color) {
    case Color.red:
      return 'Red';
    case Color.green:
      return 'Green';
    case Color.blue:
      return 'Blue';
  }
}

// ============================================================================
// 6. Mixins Tests
// ============================================================================

void testMixins() {
  print('Test 6: Mixins');

  // Class with mixin
  Musician musician = Musician('John');
  musician.perform();
  musician.practice();

  Dancer dancer = Dancer('Jane');
  dancer.perform();
  dancer.practice();

  Performer performer = Performer('Bob');
  performer.perform();
  performer.practice();
  performer.dance();

  print('  ✓ Mixins test passed\n');
}

mixin Musical {
  void playInstrument() {
    print('    Playing instrument');
  }

  void practice() {
    print('    Practicing music');
  }
}

mixin Dancing {
  void dance() {
    print('    Dancing');
  }

  void practice() {
    print('    Practicing dance');
  }
}

class Artist {
  String name;

  Artist(this.name);

  void perform() {
    print('    $name is performing');
  }
}

class Musician extends Artist with Musical {
  Musician(String name) : super(name);
}

class Dancer extends Artist with Dancing {
  Dancer(String name) : super(name);
}

class Performer extends Artist with Musical, Dancing {
  Performer(String name) : super(name);

  @override
  void practice() {
    print('    Practicing both music and dance');
  }
}

// ============================================================================
// 7. Factory Constructors Tests
// ============================================================================

void testFactoryConstructors() {
  print('Test 7: Factory Constructors');

  // Singleton pattern
  Logger logger1 = Logger();
  Logger logger2 = Logger();
  print('  Same instance: ${identical(logger1, logger2)}');

  logger1.log('Test message');

  // Factory with different types
  Animal dog = Animal.dog('Buddy');
  Animal cat = Animal.cat('Whiskers');

  dog.makeSound();
  cat.makeSound();

  // Factory with caching
  Connection conn1 = Connection.getConnection('localhost');
  Connection conn2 = Connection.getConnection('localhost');
  Connection conn3 = Connection.getConnection('remotehost');

  print('  Same connection: ${identical(conn1, conn2)}');
  print('  Different connection: ${identical(conn1, conn3)}');

  print('  ✓ Factory constructors test passed\n');
}

class Logger {
  static Logger? _instance;

  Logger._internal();

  factory Logger() {
    _instance ??= Logger._internal();
    return _instance!;
  }

  void log(String message) {
    print('    Log: $message');
  }
}

class Animal {
  String name;
  String type;

  Animal._(this.name, this.type);

  factory Animal.dog(String name) {
    return Animal._(name, 'dog');
  }

  factory Animal.cat(String name) {
    return Animal._(name, 'cat');
  }

  void makeSound() {
    if (type == 'dog') {
      print('    $name barks');
    } else if (type == 'cat') {
      print('    $name meows');
    }
  }
}

class Connection {
  static Map<String, Connection> _cache = {};
  String host;

  Connection._(this.host);

  factory Connection.getConnection(String host) {
    if (!_cache.containsKey(host)) {
      _cache[host] = Connection._(host);
    }
    return _cache[host]!;
  }
}

// ============================================================================
// 8. Operator Overloading Tests
// ============================================================================

void testOperatorOverloading() {
  print('Test 8: Operator Overloading');

  // Vector addition
  Vector v1 = Vector(3, 4);
  Vector v2 = Vector(1, 2);
  Vector v3 = v1 + v2;

  print('  Vector addition: (${v3.x}, ${v3.y})');

  // Vector subtraction
  Vector v4 = v1 - v2;
  print('  Vector subtraction: (${v4.x}, ${v4.y})');

  // Vector scalar multiplication
  Vector v5 = v1 * 2;
  print('  Vector scalar multiplication: (${v5.x}, ${v5.y})');

  // Vector equality
  Vector v6 = Vector(3, 4);
  print('  Vector equality: ${v1 == v6}');

  // Complex number operations
  Complex c1 = Complex(3, 4);
  Complex c2 = Complex(1, 2);
  Complex c3 = c1 + c2;

  print('  Complex addition: ${c3.real} + ${c3.imaginary}i');

  print('  ✓ Operator overloading test passed\n');
}

class Vector {
  double x;
  double y;

  Vector(this.x, this.y);

  Vector operator +(Vector other) {
    return Vector(x + other.x, y + other.y);
  }

  Vector operator -(Vector other) {
    return Vector(x - other.x, y - other.y);
  }

  Vector operator *(double scalar) {
    return Vector(x * scalar, y * scalar);
  }

  @override
  bool operator ==(Object other) {
    if (other is! Vector) return false;
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Complex {
  double real;
  double imaginary;

  Complex(this.real, this.imaginary);

  Complex operator +(Complex other) {
    return Complex(real + other.real, imaginary + other.imaginary);
  }

  Complex operator -(Complex other) {
    return Complex(real - other.real, imaginary - other.imaginary);
  }
}

// ============================================================================
// 9. Getters and Setters Tests
// ============================================================================

void testGettersSetters() {
  print('Test 9: Getters and Setters');

  // Basic getter/setter
  Temperature temp = Temperature();
  temp.celsius = 25.0;
  print('  Celsius: ${temp.celsius}');
  print('  Fahrenheit: ${temp.fahrenheit}');
  print('  Kelvin: ${temp.kelvin}');

  temp.fahrenheit = 77.0;
  print('  After setting Fahrenheit to 77:');
  print('  Celsius: ${temp.celsius}');

  // Computed property
  Rectangle rect = Rectangle(10, 20);
  print('  Rectangle area: ${rect.area}');
  print('  Rectangle perimeter: ${rect.perimeter}');

  // Validation in setter
  BankAccount account = BankAccount();
  account.balance = 1000.0;
  print('  Balance: ${account.balance}');

  account.balance = -500.0; // Should not set negative
  print('  Balance after invalid set: ${account.balance}');

  print('  ✓ Getters and setters test passed\n');
}

class Temperature {
  double _celsius = 0.0;

  double get celsius => _celsius;

  set celsius(double value) {
    _celsius = value;
  }

  double get fahrenheit => _celsius * 9 / 5 + 32;

  set fahrenheit(double value) {
    _celsius = (value - 32) * 5 / 9;
  }

  double get kelvin => _celsius + 273.15;

  set kelvin(double value) {
    _celsius = value - 273.15;
  }
}

class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  double get area => width * height;
  double get perimeter => 2 * (width + height);
}

class BankAccount {
  double _balance = 0.0;

  double get balance => _balance;

  set balance(double value) {
    if (value >= 0) {
      _balance = value;
    } else {
      print('    Cannot set negative balance');
    }
  }
}

// ============================================================================
// 10. Static Members Tests
// ============================================================================

void testStaticMembers() {
  print('Test 10: Static Members');

  // Static variables
  print('  Initial counter: ${Counter.count}');

  Counter c1 = Counter();
  Counter c2 = Counter();
  Counter c3 = Counter();

  print('  After creating 3 counters: ${Counter.count}');

  // Static methods
  int sum = MathUtils.add(5, 3);
  int product = MathUtils.multiply(4, 7);
  double average = MathUtils.average([1, 2, 3, 4, 5]);

  print('  Math utils - Sum: $sum, Product: $product, Average: $average');

  // Static constants
  print('  PI: ${Constants.PI}');
  print('  E: ${Constants.E}');
  print('  MAX_INT: ${Constants.MAX_INT}');

  // Static factory
  Config config1 = Config.getInstance();
  Config config2 = Config.getInstance();
  print('  Same config instance: ${identical(config1, config2)}');

  print('  ✓ Static members test passed\n');
}

class Counter {
  static int count = 0;

  Counter() {
    count++;
  }
}

class MathUtils {
  static int add(int a, int b) {
    return a + b;
  }

  static int multiply(int a, int b) {
    return a * b;
  }

  static double average(List<int> numbers) {
    if (numbers.isEmpty) return 0.0;
    int sum = numbers.reduce((a, b) => a + b);
    return sum / numbers.length;
  }
}

class Constants {
  static const double PI = 3.14159265359;
  static const double E = 2.71828182846;
  static const int MAX_INT = 2147483647;
}

class Config {
  static Config? _instance;

  Config._();

  static Config getInstance() {
    _instance ??= Config._();
    return _instance!;
  }
}

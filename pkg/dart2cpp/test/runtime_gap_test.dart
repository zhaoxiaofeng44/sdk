// Test file for runtime gap analysis
// This file contains various Dart features to test if the restorer handles them

// 1. Spread operator in collections
void testSpread() {
  final list1 = [1, 2, 3];
  final list2 = [4, 5, 6];
  final combined = [...list1, ...list2];
  print(combined);

  final map1 = {'a': 1};
  final map2 = {'b': 2};
  final combinedMap = {...map1, ...map2};
  print(combinedMap);
}

// 2. Collection-if and collection-for
void testCollectionIfFor() {
  final includeExtra = true;
  final list = [
    1,
    if (includeExtra) 2,
    for (var i = 3; i <= 5; i++) i,
  ];
  print(list);
}

// 3. Cascade operator
class Person {
  String name = '';
  int age = 0;
  void greet() => print('Hello, $name');
}

void testCascade() {
  final p = Person()
    ..name = 'Alice'
    ..age = 30
    ..greet();
  print(p.name);
}

// 4. Null-aware operators
void testNullAware() {
  String? nullable;
  final result = nullable ?? 'default';
  print(result);

  final length = nullable?.length ?? 0;
  print(length);

  nullable ??= 'assigned';
  print(nullable);
}

// 5. Late variables
class LateTest {
  late String value;

  void init() {
    value = 'initialized';
  }

  String get() => value;
}

void testLate() {
  final t = LateTest();
  t.init();
  print(t.get());
}

// 6. Async with various return types
Future<int> asyncInt() async {
  await Future.delayed(Duration(milliseconds: 10));
  return 42;
}

Future<String> asyncString() async {
  await Future.delayed(Duration(milliseconds: 10));
  return 'hello';
}

Future<void> asyncVoid() async {
  await Future.delayed(Duration(milliseconds: 10));
  print('done');
}

void testAsync() {
  asyncInt().then(print);
  asyncString().then(print);
  asyncVoid();
}

// 7. Generators
Iterable<int> syncGen() sync* {
  yield 1;
  yield 2;
  yield 3;
}

Stream<int> asyncGen() async* {
  yield 1;
  yield 2;
  yield 3;
}

void testGenerators() {
  print(syncGen().toList());
  asyncGen().toList().then(print);
}

// 8. Enums with methods
enum Color {
  red,
  green,
  blue;

  String get name => toString().split('.').last;
  int get value => index;
}

void testEnum() {
  print(Color.red.name);
  print(Color.green.value);
}

// 9. Extension methods
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

void testExtension() {
  print('hello'.capitalize());
}

// 10. Records (Dart 3)
(String, int) getRecord() {
  return ('hello', 42);
}

({String name, int age}) getNamedRecord() {
  return (name: 'Alice', age: 30);
}

void testRecords() {
  final r1 = getRecord();
  print('${r1.$1}, ${r1.$2}');

  final r2 = getNamedRecord();
  print('${r2.name}, ${r2.age}');
}

// 11. Pattern matching (Dart 3)
void testPatternMatching() {
  final obj = [1, 2, 3];
  switch (obj) {
    case [1, 2, 3]:
      print('matched');
    default:
      print('not matched');
  }

  final (a, b) = (1, 2);
  print('$a, $b');
}

// 12. Sealed classes (Dart 3)
sealed class Shape {
  double area();
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  double area() => 3.14 * radius * radius;
}

class Square extends Shape {
  final double side;
  Square(this.side);

  @override
  double area() => side * side;
}

void testSealed() {
  final shapes = [Circle(5), Square(4)];
  for (final shape in shapes) {
    print(shape.area());
  }
}

// 13. Operator overloading
class Vector {
  final double x, y;
  Vector(this.x, this.y);

  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);
  Vector operator *(double scalar) => Vector(x * scalar, y * scalar);

  @override
  String toString() => '($x, $y)';
}

void testOperators() {
  final v1 = Vector(1, 2);
  final v2 = Vector(3, 4);
  print(v1 + v2);
  print(v1 * 2);
}

// 14. Static methods and fields
class Counter {
  static int count = 0;

  static void increment() {
    count++;
  }

  static int get value => count;
}

void testStatic() {
  Counter.increment();
  Counter.increment();
  print(Counter.value);
}

// 15. Abstract classes and interfaces
abstract class Animal {
  void speak();
}

class Dog implements Animal {
  @override
  void speak() => print('Woof!');
}

void testAbstract() {
  final Animal a = Dog();
  a.speak();
}

// 16. Mixins
mixin Flyable {
  void fly() => print('Flying!');
}

mixin Swimmable {
  void swim() => print('Swimming!');
}

class Duck with Flyable, Swimmable {
  void quack() => print('Quack!');
}

void testMixin() {
  final d = Duck();
  d.fly();
  d.swim();
  d.quack();
}

// 17. Generics with bounds
T max<T extends Comparable>(T a, T b) {
  return a.compareTo(b) > 0 ? a : b;
}

void testGenericBounds() {
  print(max(3, 5));
  print(max('apple', 'banana'));
}

// 18. Typedef
typedef IntPredicate = bool Function(int);

bool isEven(int n) => n % 2 == 0;

void testTypedef() {
  IntPredicate pred = isEven;
  print(pred(4));
}

// 19. Assert
void testAssert() {
  final x = 5;
  assert(x > 0, 'x must be positive');
  print('assert passed');
}

// 20. Labels and break/continue
void testLabels() {
  outer:
  for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 3; j++) {
      if (i == 1 && j == 1) break outer;
      print('$i, $j');
    }
  }
}

void main() {
  print('=== 1. Spread ===');
  testSpread();

  print('\n=== 2. Collection If/For ===');
  testCollectionIfFor();

  print('\n=== 3. Cascade ===');
  testCascade();

  print('\n=== 4. Null-aware ===');
  testNullAware();

  print('\n=== 5. Late ===');
  testLate();

  print('\n=== 6. Async ===');
  testAsync();

  print('\n=== 7. Generators ===');
  testGenerators();

  print('\n=== 8. Enum ===');
  testEnum();

  print('\n=== 9. Extension ===');
  testExtension();

  print('\n=== 10. Records ===');
  testRecords();

  print('\n=== 11. Pattern Matching ===');
  testPatternMatching();

  print('\n=== 12. Sealed Classes ===');
  testSealed();

  print('\n=== 13. Operators ===');
  testOperators();

  print('\n=== 14. Static ===');
  testStatic();

  print('\n=== 15. Abstract ===');
  testAbstract();

  print('\n=== 16. Mixin ===');
  testMixin();

  print('\n=== 17. Generic Bounds ===');
  testGenericBounds();

  print('\n=== 18. Typedef ===');
  testTypedef();

  print('\n=== 19. Assert ===');
  testAssert();

  print('\n=== 20. Labels ===');
  testLabels();

  print('\n=== All tests completed ===');
}

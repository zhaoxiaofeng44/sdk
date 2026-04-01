// ============================================================================
// 复杂测试用例：覆盖多种 Dart 语法节点
// 用于验证 dart_to_dart_restorer.dart 的还原正确性
// ============================================================================

// ---- 1. 抽象类 / 接口 ----
abstract class Shape {
  String get name;
  double area();
  double perimeter();

  @override
  String toString() => '${name}(area=${area().toStringAsFixed(2)})';
}

// ---- 2. 泛型类 + 继承 ----
class Pair<A, B> {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  Pair<B, A> swap() => Pair(second, first);

  @override
  String toString() => '($first, $second)';
}

// ---- 3. 具体类 + 命名构造函数 + getter/setter ----
class Circle extends Shape {
  double _radius;

  Circle(this._radius);

  Circle.unit() : _radius = 1.0;

  double get radius => _radius;
  set radius(double value) {
    if (value < 0) throw ArgumentError('Radius must be non-negative');
    _radius = value;
  }

  @override
  String get name => 'Circle';

  @override
  double area() => 3.14159265 * _radius * _radius;

  @override
  double perimeter() => 2 * 3.14159265 * _radius;
}

class Rectangle extends Shape {
  final double width;
  final double height;

  Rectangle(this.width, this.height);

  @override
  String get name => 'Rectangle';

  @override
  double area() => width * height;

  @override
  double perimeter() => 2 * (width + height);
}

// ---- 4. 枚举 ----
enum Direction { north, south, east, west }

// ---- 5. 扩展方法 ----
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isPalindrome {
    final reversed = split('').reversed.join();
    return this == reversed;
  }
}

extension ListExtensions<T> on List<T> {
  List<T> filterWhere(bool Function(T) predicate) {
    return where(predicate).toList();
  }
}

// ---- 6. 泛型函数 ----
T identity<T>(T value) => value;

List<T> repeat<T>(T item, int count) {
  return List.generate(count, (_) => item);
}

// ---- 7. 高阶函数 + 闭包 ----
Function makeAdder(int base) {
  return (int x) => base + x;
}

List<int> mapList(List<int> items, int Function(int) transform) {
  return items.map(transform).toList();
}

// ---- 8. 异步函数 ----
Future<String> fetchData(String url) async {
  await Future.delayed(Duration(milliseconds: 10));
  return 'data from $url';
}

Future<List<String>> fetchAll(List<String> urls) async {
  final results = <String>[];
  for (final url in urls) {
    final data = await fetchData(url);
    results.add(data);
  }
  return results;
}

// ---- 9. 可空类型 + 空安全 ----
String? findFirst(List<String> items, bool Function(String) predicate) {
  for (final item in items) {
    if (predicate(item)) return item;
  }
  return null;
}

int safeLength(String? text) => text?.length ?? 0;

// ---- 10. 主函数：综合测试 ----
void main() {
  print('=== 复杂语法节点还原测试 ===\n');

  // ---- 测试 1: 泛型类 ----
  print('--- 1. 泛型类 Pair ---');
  final pair = Pair<String, int>('hello', 42);
  final swapped = pair.swap();
  print('pair: $pair');
  print('swapped: $swapped');
  assert(pair.first == 'hello');
  assert(swapped.first == 42);

  // ---- 测试 2: 继承 + 多态 ----
  print('\n--- 2. 继承 + 多态 ---');
  final shapes = <Shape>[
    Circle(5.0),
    Rectangle(3.0, 4.0),
    Circle.unit(),
  ];
  for (final shape in shapes) {
    print('  $shape, perimeter=${shape.perimeter().toStringAsFixed(2)}');
  }

  // ---- 测试 3: getter/setter + 异常 ----
  print('\n--- 3. getter/setter + 异常 ---');
  final circle = Circle(3.0);
  circle.radius = 5.0;
  print('radius after set: ${circle.radius}');
  try {
    circle.radius = -1.0;
    print('ERROR: should have thrown');
  } on ArgumentError catch (e) {
    print('Caught expected error: $e');
  }

  // ---- 测试 4: 枚举 + switch ----
  print('\n--- 4. 枚举 + switch ---');
  final directions = [Direction.north, Direction.east, Direction.south];
  for (final dir in directions) {
    final label = switch (dir) {
      Direction.north => 'N',
      Direction.south => 'S',
      Direction.east  => 'E',
      Direction.west  => 'W',
    };
    print('  $dir -> $label');
  }

  // ---- 测试 5: 扩展方法 ----
  print('\n--- 5. 扩展方法 ---');
  final word = 'hello';
  print('capitalize: ${word.capitalize()}');
  print('isPalindrome("racecar"): ${'racecar'.isPalindrome}');
  print('isPalindrome("hello"): ${'hello'.isPalindrome}');

  final numbers = [1, 2, 3, 4, 5, 6];
  final evens = numbers.filterWhere((n) => n % 2 == 0);
  print('evens: $evens');

  // ---- 测试 6: 泛型函数 ----
  print('\n--- 6. 泛型函数 ---');
  print('identity<int>(99): ${identity<int>(99)}');
  print('repeat("x", 3): ${repeat("x", 3)}');

  // ---- 测试 7: 高阶函数 + 闭包 ----
  print('\n--- 7. 高阶函数 + 闭包 ---');
  final add10 = makeAdder(10);
  print('add10(5): ${add10(5)}');
  final doubled = mapList([1, 2, 3, 4], (x) => x * 2);
  print('doubled: $doubled');

  // 闭包捕获变量
  int counter = 0;
  final increment = () { counter++; return counter; };
  print('counter: ${increment()}, ${increment()}, ${increment()}');

  // ---- 测试 8: 可空类型 ----
  print('\n--- 8. 可空类型 ---');
  final items = ['apple', 'banana', 'cherry'];
  final found = findFirst(items, (s) => s.startsWith('b'));
  print('found: $found');
  final notFound = findFirst(items, (s) => s.startsWith('z'));
  print('notFound: $notFound');
  print('safeLength(null): ${safeLength(null)}');
  print('safeLength("dart"): ${safeLength("dart")}');

  // ---- 测试 9: 集合操作 ----
  print('\n--- 9. 集合操作 ---');
  final map = <String, int>{'a': 1, 'b': 2, 'c': 3};
  final filtered = Map.fromEntries(
    map.entries.where((e) => e.value > 1),
  );
  print('filtered map: $filtered');

  final set1 = {1, 2, 3, 4};
  final set2 = {3, 4, 5, 6};
  final intersection = set1.intersection(set2);
  print('intersection: $intersection');

  // ---- 测试 10: 字符串插值 + 多行 ----
  print('\n--- 10. 字符串插值 ---');
  final name = 'Dart';
  final version = 3;
  final greeting = 'Hello, $name ${version}!';
  final multiExpr = 'Sum: ${1 + 2 + 3}, Upper: ${name.toUpperCase()}';
  print(greeting);
  print(multiExpr);

  // ---- 测试 11: 条件表达式 + 类型检查 ----
  print('\n--- 11. 条件表达式 + 类型检查 ---');
  final dynamic value = 42;
  final typeLabel = value is int
      ? 'integer'
      : value is String
          ? 'string'
          : 'other';
  print('typeLabel: $typeLabel');

  // ---- 测试 12: for/while/do-while ----
  print('\n--- 12. 循环语句 ---');
  // for 循环
  var sum = 0;
  for (var i = 1; i <= 5; i++) {
    sum += i;
  }
  print('sum 1..5: $sum');

  // while 循环
  var product = 1;
  var n = 5;
  while (n > 0) {
    product *= n;
    n--;
  }
  print('5! = $product');

  // do-while
  var doCount = 0;
  do {
    doCount++;
  } while (doCount < 3);
  print('doCount: $doCount');

  // ---- 测试 13: try/catch/finally ----
  print('\n--- 13. try/catch/finally ---');
  String result = '';
  try {
    result = 'try';
    throw StateError('test error');
  } on StateError catch (e) {
    result += '+catch(${e.message})';
  } finally {
    result += '+finally';
  }
  print('result: $result');

  // ---- 测试 14: List/Map/Set 字面量 ----
  print('\n--- 14. 集合字面量 ---');
  const constList = [1, 2, 3];
  const constMap = {'key': 'value'};
  const constSet = {10, 20, 30};
  print('constList: $constList');
  print('constMap: $constMap');
  print('constSet: $constSet');

  print('\n=== 所有测试通过 ✅ ===');
}

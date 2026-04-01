T identity<T>(T value) {
return value;
}

List<T> repeat<T>(T item, int count) {
return List.generate(count, (int _) => item);
}

Function makeAdder(int base) {
return (int x) => (base + x);
}

List<int> mapList(List<int> items, int Function(int) transform) {
return items.map(transform).toList();
}

Future<String> fetchData(String url) async {
await Future.delayed(Duration(milliseconds: 10));
return 'data from $url';
}

Future<List<String>> fetchAll(List<String> urls) async {
final List<String> results = [];
for (final String url in urls) {
final String data = await fetchData(url);
results.add(data);
}
return results;
}

String? findFirst(List<String> items, bool Function(String) predicate) {
for (final String item in items) {
if (predicate(item)) {
return item;
}
}
return null;
}

int safeLength(String? text) {
return text?.length ?? 0;
}

void main() {
print('=== 复杂语法节点还原测试 ===\n');
print('--- 1. 泛型类 Pair ---');
final Pair<String, int> pair = Pair<String, int>('hello', 42);
final Pair<int, String> swapped = pair.swap();
print('pair: $pair');
print('swapped: $swapped');
assert((pair.first == 'hello'));
assert((swapped.first == 42));
print('\n--- 2. 继承 + 多态 ---');
final List<Shape> shapes = <Shape>[Circle(5.0), Rectangle(3.0, 4.0), Circle.unit()];
for (final Shape shape in shapes) {
print('  $shape, perimeter=${shape.perimeter().toStringAsFixed(2)}');
}
print('\n--- 3. getter/setter + 异常 ---');
final Circle circle = Circle(3.0);
circle.radius = 5.0;
print('radius after set: ${circle.radius}');
try {
circle.radius = (-1.0);
print('ERROR: should have thrown');
} on ArgumentError catch (e) {
print('Caught expected error: $e');
}
print('\n--- 4. 枚举 + switch ---');
final List<Direction> directions = <Direction>[Direction.north, Direction.east, Direction.south];
for (final Direction dir in directions) {
final String label = (() { String _blkVar0; switch (dir) {
  case Direction.north:
    _blkVar0 = 'N';
    break;
  case Direction.south:
    _blkVar0 = 'S';
    break;
  case Direction.east:
    _blkVar0 = 'E';
    break;
  case Direction.west:
    _blkVar0 = 'W';
    break;
} return _blkVar0; })();
print('  $dir -> $label');
}
print('\n--- 5. 扩展方法 ---');
final String word = 'hello';
print('capitalize: ${word.capitalize()}');
print('isPalindrome("racecar"): ${'racecar'.isPalindrome}');
print('isPalindrome("hello"): ${'hello'.isPalindrome}');
final List<int> numbers = <int>[1, 2, 3, 4, 5, 6];
final List<int> evens = numbers.filterWhere((int n) => ((n % 2) == 0));
print('evens: $evens');
print('\n--- 6. 泛型函数 ---');
print('identity<int>(99): ${identity(99)}');
print('repeat("x", 3): ${repeat('x', 3)}');
print('\n--- 7. 高阶函数 + 闭包 ---');
final Function add10 = makeAdder(10);
print('add10(5): ${add10(5)}');
final List<int> doubled = mapList(<int>[1, 2, 3, 4], (int x) => (x * 2));
print('doubled: $doubled');
int counter = 0;
final int Function() increment = () {
counter = (counter + 1);
return counter;
};
print('counter: ${increment()}, ${increment()}, ${increment()}');
print('\n--- 8. 可空类型 ---');
final List<String> items = <String>['apple', 'banana', 'cherry'];
final String? found = findFirst(items, (String s) => s.startsWith('b'));
print('found: $found');
final String? notFound = findFirst(items, (String s) => s.startsWith('z'));
print('notFound: $notFound');
print('safeLength(null): ${safeLength(null)}');
print('safeLength("dart"): ${safeLength('dart')}');
print('\n--- 9. 集合操作 ---');
final Map<String, int> map = <String, int>{'a': 1, 'b': 2, 'c': 3};
final Map<String, int> filtered = Map.fromEntries(map.entries.where((MapEntry<String, int> e) => (e.value > 1)));
print('filtered map: $filtered');
final Set<int> set1 = (() { final Set<int> _blkVar1 = {}; _blkVar1.add(1); _blkVar1.add(2); _blkVar1.add(3); _blkVar1.add(4); return _blkVar1; })();
final Set<int> set2 = (() { final Set<int> _blkVar2 = {}; _blkVar2.add(3); _blkVar2.add(4); _blkVar2.add(5); _blkVar2.add(6); return _blkVar2; })();
final Set<int> intersection = set1.intersection(set2);
print('intersection: $intersection');
print('\n--- 10. 字符串插值 ---');
final String name = 'Dart';
final int version = 3;
final String greeting = 'Hello, $name $version!';
final String multiExpr = 'Sum: ${((1 + 2) + 3)}, Upper: ${name.toUpperCase()}';
print(greeting);
print(multiExpr);
print('\n--- 11. 条件表达式 + 类型检查 ---');
final value = 42;
final String typeLabel = ((value is int) ? 'integer' : ((value is String) ? 'string' : 'other'));
print('typeLabel: $typeLabel');
print('\n--- 12. 循环语句 ---');
int sum = 0;
for (var i = 1; (i <= 5); i = (i + 1)) {
sum = (sum + i);
}
print('sum 1..5: $sum');
int product = 1;
int n = 5;
while ((n > 0)) {
product = (product * n);
n = (n - 1);
}
print('5! = $product');
int doCount = 0;
do {
doCount = (doCount + 1);
} while ((doCount < 3));
print('doCount: $doCount');
print('\n--- 13. try/catch/finally ---');
String result = '';
try {
result = 'try';
throw StateError('test error');
} on StateError catch (e) {
result = (result + '+catch(${e.message})');
} finally {
result = (result + '+finally');
}
print('result: $result');
print('\n--- 14. 集合字面量 ---');
print('constList: ${const <int>[1, 2, 3]}');
print('constMap: ${const <String, String>{'key': 'value'}}');
print('constSet: ${const <int>{10, 20, 30}}');
print('\n=== 所有测试通过 ✅ ===');
}

abstract class Shape {
  Shape() : super();
  
  String get name;
  
  double area();
  
  double perimeter();
  
  @override
  String toString() {
  return '${this.name}(area=${this.area().toStringAsFixed(2)})';
  }
  
}

class Pair<A, B> {
  final A first;
  final B second;
  
  const Pair(A first, B second) : first = first, second = second, super();
  
  Pair<B, A> swap() {
  return Pair<B, A>(this.second, this.first);
  }
  
  @override
  String toString() {
  return '(${this.first}, ${this.second})';
  }
  
}

class Circle extends Shape {
  double _radius;
  
  Circle(double _radius) : _radius = _radius, super();
  
  Circle.unit() : _radius = 1.0, super();
  
  double get radius {
  return this._radius;
  }
  
  set radius(double value) {
  if ((value < 0)) {
  throw ArgumentError('Radius must be non-negative');
  }
  this._radius = value;
  }
  
  @override
  String get name {
  return 'Circle';
  }
  
  @override
  double area() {
  return ((3.14159265 * this._radius) * this._radius);
  }
  
  @override
  double perimeter() {
  return ((2 * 3.14159265) * this._radius);
  }
  
}

class Rectangle extends Shape {
  final double width;
  final double height;
  
  Rectangle(double width, double height) : width = width, height = height, super();
  
  @override
  String get name {
  return 'Rectangle';
  }
  
  @override
  double area() {
  return (this.width * this.height);
  }
  
  @override
  double perimeter() {
  return (2 * (this.width + this.height));
  }
  
}

enum Direction {
  north,
  south,
  east,
  west
  ;
}

extension StringExtensions on String {
  String capitalize() {
  if (this.isEmpty) {
  return this;
  }
  return '${this[0].toUpperCase()}${this.substring(1)}';
  }
  
  bool get isPalindrome {
  final String reversed = this.split('').reversed.join();
  return (this == reversed);
  }
  
}

extension ListExtensions<T> on List<T> {
  List<T> filterWhere(bool Function(T) predicate) {
  return this.where(predicate).toList();
  }
  
}


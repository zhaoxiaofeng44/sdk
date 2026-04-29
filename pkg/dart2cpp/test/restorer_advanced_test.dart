// ============================================================================
// 高级语法还原测试用例
// 覆盖：嵌套闭包、递归数据结构、复杂泛型、多重嵌套控制流、
//       函数式编程组合、late/final 字段、复杂字符串操作、
//       类型推断、集合高阶链、函数返回函数、类内嵌套函数等
// ============================================================================

// ============================================================================
// 场景 1: 嵌套闭包 + 多层变量捕获
// ============================================================================
Function makeCounter({int start = 0, int step = 1}) {
  int current = start;
  return () {
    current += step;
    return current;
  };
}

Function makeAccumulator(int initial) {
  int total = initial;
  // 返回一个闭包，闭包内再创建闭包
  return (int amount) {
    total += amount;
    // 返回一个快照闭包，捕获当前 total
    final snapshot = total;
    return () => 'accumulated: $snapshot (current total: $total)';
  };
}

List<Function> makeClosureList(int count) {
  final closures = <Function>[];
  for (var i = 0; i < count; i++) {
    // 每次迭代 i 是不同的变量，闭包捕获不同的 i
    closures.add(() => 'closure_$i');
  }
  return closures;
}

// ============================================================================
// 场景 2: 递归数据结构 — 二叉树
// ============================================================================
class TreeNode<T> {
  final T value;
  final TreeNode<T>? left;
  final TreeNode<T>? right;

  TreeNode(this.value, [this.left, this.right]);

  // 前序遍历
  List<T> preorder() {
    final result = <T>[value];
    if (left != null) result.addAll(left!.preorder());
    if (right != null) result.addAll(right!.preorder());
    return result;
  }

  // 中序遍历
  List<T> inorder() {
    final result = <T>[];
    if (left != null) result.addAll(left!.inorder());
    result.add(value);
    if (right != null) result.addAll(right!.inorder());
    return result;
  }

  // 树的深度
  int get depth {
    final leftDepth = left?.depth ?? 0;
    final rightDepth = right?.depth ?? 0;
    return 1 + (leftDepth > rightDepth ? leftDepth : rightDepth);
  }

  // map: 将每个节点的值转换
  TreeNode<R> map<R>(R Function(T) transform) {
    return TreeNode<R>(
      transform(value),
      left?.map(transform),
      right?.map(transform),
    );
  }

  @override
  String toString() => 'TreeNode($value)';
}

// ============================================================================
// 场景 3: 递归数据结构 — 链表 + 迭代器协议
// ============================================================================
class LinkedNode<T> {
  final T data;
  LinkedNode<T>? next;

  LinkedNode(this.data, [this.next]);

  // 递归反转
  LinkedNode<T> reversed() {
    if (next == null) return LinkedNode(data);
    final rev = next!.reversed();
    // 找到 rev 的尾部并追加当前节点
    var tail = rev;
    while (tail.next != null) {
      tail = tail.next!;
    }
    tail.next = LinkedNode(data);
    return rev;
  }

  // 转为列表
  List<T> toList() {
    final result = <T>[data];
    var current = next;
    while (current != null) {
      result.add(current!.data);
      current = current!.next;
    }
    return result;
  }

  // 长度
  int get length {
    int count = 1;
    var current = next;
    while (current != null) {
      count++;
      current = current!.next;
    }
    return count;
  }

  @override
  String toString() => 'LinkedNode(${toList().join(' -> ')})';
}

// ============================================================================
// 场景 4: 复杂泛型 — 多类型参数 + 泛型方法 + 泛型约束
// ============================================================================
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isRight;

  Either.left(L value)
      : _left = value,
        _right = null,
        _isRight = false;

  Either.right(R value)
      : _left = null,
        _right = value,
        _isRight = true;

  bool get isLeft => !_isRight;
  bool get isRight => _isRight;

  L get leftValue {
    if (!isLeft) throw StateError('Not a left value');
    return _left as L;
  }

  R get rightValue {
    if (!isRight) throw StateError('Not a right value');
    return _right as R;
  }

  // fold: 统一处理两种情况
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (_isRight) return onRight(_right as R);
    return onLeft(_left as L);
  }

  // map: 仅变换 right 值
  Either<L, R2> mapRight<R2>(R2 Function(R) transform) {
    if (_isRight) return Either.right(transform(_right as R));
    return Either.left(_left as L);
  }

  // flatMap: 链式操作
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R) transform) {
    if (_isRight) return transform(_right as R);
    return Either.left(_left as L);
  }

  @override
  String toString() {
    if (_isRight) return 'Right($_right)';
    return 'Left($_left)';
  }
}

// ============================================================================
// 场景 5: 函数式编程 — 柯里化 + 组合 + 管道
// ============================================================================
typedef UnaryFunc<A, B> = B Function(A);

UnaryFunc<A, C> composeFunc<A, B, C>(
    UnaryFunc<B, C> funcBC, UnaryFunc<A, B> funcAB) {
  return (A a) => funcBC(funcAB(a));
}

// 柯里化：将二元函数转换为一元函数的链
UnaryFunc<A, UnaryFunc<B, C>> curry<A, B, C>(C Function(A, B) biFunc) {
  return (A a) => (B b) => biFunc(a, b);
}

// 管道：从左到右依次应用函数
T pipe<T>(T value, List<T Function(T)> transforms) {
  var result = value;
  for (final transform in transforms) {
    result = transform(result);
  }
  return result;
}

// 记忆化：缓存函数结果
UnaryFunc<A, B> memoize<A, B>(UnaryFunc<A, B> func) {
  final cache = <A, B>{};
  return (A arg) {
    if (cache.containsKey(arg)) return cache[arg] as B;
    final result = func(arg);
    cache[arg] = result;
    return result;
  };
}

// ============================================================================
// 场景 6: 多重嵌套控制流 + 复杂条件组合
// ============================================================================
String classifyNumber(int number) {
  String result = '';

  if (number < 0) {
    result = 'negative';
    if (number % 2 == 0) {
      result += '_even';
    } else {
      result += '_odd';
    }
    if (number < -100) {
      result += '_large';
    } else if (number < -10) {
      result += '_medium';
    } else {
      result += '_small';
    }
  } else if (number == 0) {
    result = 'zero';
  } else {
    result = 'positive';
    // 嵌套循环 + break/continue
    bool isPrime = number > 1;
    for (var i = 2; i * i <= number; i++) {
      if (number % i == 0) {
        isPrime = false;
        break;
      }
    }
    if (isPrime && number > 1) {
      result += '_prime';
    } else if (number > 1) {
      // 查找最小因子
      for (var i = 2; i <= number; i++) {
        if (number % i == 0) {
          result += '_composite(smallest_factor=$i)';
          break;
        }
      }
    }
  }

  return result;
}

// 嵌套 try-catch + 循环
List<int> parseNumbers(List<String> inputs) {
  final results = <int>[];
  for (var i = 0; i < inputs.length; i++) {
    try {
      final trimmed = inputs[i].trim();
      if (trimmed.isEmpty) continue;
      final value = int.parse(trimmed);
      if (value < 0) {
        throw ArgumentError('Negative value at index $i: $value');
      }
      results.add(value);
    } on FormatException {
      results.add(-1); // sentinel for parse failure
    } on ArgumentError catch (e) {
      results.add(-2); // sentinel for negative
    }
  }
  return results;
}

// ============================================================================
// 场景 7: 复杂的 mixin 组合 — 状态模式 + 策略模式
// ============================================================================
mixin Serializable {
  Map<String, dynamic> toMap();

  String serialize() {
    final map = toMap();
    final entries = map.entries.map((e) => '${e.key}=${e.value}').join(', ');
    return '{$entries}';
  }
}

mixin Validatable {
  List<String> validate();

  bool get isValid => validate().isEmpty;

  String get validationSummary {
    final errors = validate();
    if (errors.isEmpty) return 'valid';
    return 'invalid: ${errors.join("; ")}';
  }
}

mixin Copyable<T> {
  T copyWith();
}

class UserProfile with Serializable, Validatable {
  final String name;
  final String email;
  final int age;

  UserProfile(this.name, this.email, this.age);

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'age': age,
      };

  @override
  List<String> validate() {
    final errors = <String>[];
    if (name.isEmpty) errors.add('name is empty');
    if (!email.contains('@')) errors.add('invalid email');
    if (age < 0 || age > 150) errors.add('invalid age');
    return errors;
  }

  @override
  String toString() => 'UserProfile($name, $email, $age)';
}

// ============================================================================
// 场景 8: 复杂继承链 — 抽象方法 + 模板方法模式
// ============================================================================
abstract class DataTransformer<TInput, TOutput> {
  // 模板方法
  TOutput transform(TInput input) {
    final validated = preValidate(input);
    final processed = process(validated);
    return postProcess(processed);
  }

  TInput preValidate(TInput input) => input; // 可被子类覆盖
  TOutput process(TInput input); // 抽象方法
  TOutput postProcess(TOutput output) => output; // 可被子类覆盖
}

class StringToIntTransformer extends DataTransformer<String, int> {
  @override
  String preValidate(String input) => input.trim();

  @override
  int process(String input) => int.parse(input);
}

class IntToStringTransformer extends DataTransformer<int, String> {
  final String prefix;

  IntToStringTransformer([this.prefix = '']);

  @override
  String process(int input) => '$prefix${input.toString()}';

  @override
  String postProcess(String output) => output.toUpperCase();
}

// 组合两个转换器
class ChainedTransformer<A, B, C> extends DataTransformer<A, C> {
  final DataTransformer<A, B> first;
  final DataTransformer<B, C> second;

  ChainedTransformer(this.first, this.second);

  @override
  C process(A input) {
    final intermediate = first.transform(input);
    return second.transform(intermediate);
  }
}

// ============================================================================
// 场景 9: 静态方法 + 工厂模式 + 单例
// ============================================================================
class Registry {
  static final Registry _instance = Registry._internal();
  final Map<String, dynamic> _store = {};
  int _accessCount = 0;

  Registry._internal();

  factory Registry() => _instance;

  void register(String key, dynamic value) {
    _store[key] = value;
    _accessCount++;
  }

  dynamic lookup(String key) {
    _accessCount++;
    return _store[key];
  }

  bool contains(String key) => _store.containsKey(key);

  int get size => _store.length;
  int get accessCount => _accessCount;

  List<String> get keys => _store.keys.toList()..sort();

  void clear() {
    _store.clear();
    _accessCount = 0;
  }

  @override
  String toString() => 'Registry(size=$size, accesses=$accessCount)';
}

// ============================================================================
// 场景 10: 复杂的集合操作 + 链式调用
// ============================================================================
class DataProcessor {
  static List<Map<String, dynamic>> processRecords(
      List<Map<String, dynamic>> records) {
    return records
        .where((r) => r.containsKey('name') && r.containsKey('score'))
        .where((r) => (r['score'] as int) >= 0)
        .map((r) => {
              'name': (r['name'] as String).toUpperCase(),
              'score': r['score'] as int,
              'grade': _scoreToGrade(r['score'] as int),
              'passed': (r['score'] as int) >= 60,
            })
        .toList()
      ..sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
  }

  static String _scoreToGrade(int score) {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }

  static Map<String, List<Map<String, dynamic>>> groupByGrade(
      List<Map<String, dynamic>> records) {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final record in records) {
      final grade = record['grade'] as String;
      groups.putIfAbsent(grade, () => []);
      groups[grade]!.add(record);
    }
    return groups;
  }

  static Map<String, double> averageByGrade(
      List<Map<String, dynamic>> records) {
    final groups = groupByGrade(records);
    return groups.map((grade, items) {
      final total = items.fold<int>(0, (sum, r) => sum + (r['score'] as int));
      return MapEntry(grade, total / items.length);
    });
  }
}

// ============================================================================
// 场景 11: late 变量 + 惰性初始化 + 计算缓存
// ============================================================================
class ExpensiveComputation {
  final int seed;
  late final int computedValue = _computeExpensive();
  late String description;

  ExpensiveComputation(this.seed);

  int _computeExpensive() {
    // 模拟昂贵计算
    var result = seed;
    for (var i = 0; i < 10; i++) {
      result = (result * 31 + 17) % 1000;
    }
    return result;
  }

  void initialize(String desc) {
    description = desc;
  }

  @override
  String toString() => 'ExpensiveComputation(seed=$seed, computed=$computedValue)';
}

// ============================================================================
// 场景 12: 类内嵌套函数声明 + 局部函数递归
// ============================================================================
class MathUtils {
  static int fibonacci(int n) {
    // 局部函数：带记忆化的递归
    final memo = <int, int>{};
    int fib(int k) {
      if (k <= 1) return k;
      if (memo.containsKey(k)) return memo[k]!;
      final result = fib(k - 1) + fib(k - 2);
      memo[k] = result;
      return result;
    }

    return fib(n);
  }

  static List<int> primeFactors(int n) {
    final factors = <int>[];

    void extractFactor(int factor) {
      while (n % factor == 0) {
        factors.add(factor);
        n = n ~/ factor;
      }
    }

    extractFactor(2);
    for (var i = 3; i * i <= n; i += 2) {
      extractFactor(i);
    }
    if (n > 1) factors.add(n);
    return factors;
  }

  static int gcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  static int lcm(int a, int b) => (a * b) ~/ gcd(a, b);
}

// ============================================================================
// 场景 13: 泛型接口 + 多重 implements
// ============================================================================
abstract class Printable3 {
  String prettyPrint();
}

class Score implements Printable3 {
  final String subject;
  final int points;

  Score(this.subject, this.points);

  int compareTo2(Score other) => points.compareTo(other.points);

  bool isLessThan(Score other) => compareTo2(other) < 0;
  bool isGreaterThan(Score other) => compareTo2(other) > 0;

  @override
  String prettyPrint() => '[$subject: $points pts]';

  @override
  String toString() => 'Score($subject, $points)';
}

class WeightedScore extends Score {
  final double weight;

  WeightedScore(super.subject, super.points, this.weight);

  double get weightedPoints => points * weight;

  @override
  int compareTo2(Score other) {
    if (other is WeightedScore) {
      return weightedPoints.compareTo(other.weightedPoints);
    }
    return super.compareTo2(other);
  }

  @override
  String prettyPrint() =>
      '[$subject: $points pts × $weight = ${weightedPoints.toStringAsFixed(1)}]';

  @override
  String toString() => 'WeightedScore($subject, $points, w=$weight)';
}

// ============================================================================
// 场景 14: 复杂字符串操作 + 正则表达式
// ============================================================================
class TextProcessor {
  static String camelToSnake(String input) {
    final result = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (char == char.toUpperCase() && char != char.toLowerCase() && i > 0) {
        result.write('_');
      }
      result.write(char.toLowerCase());
    }
    return result.toString();
  }

  static String snakeToCamel(String input) {
    final parts = input.split('_');
    if (parts.isEmpty) return input;
    final first = parts[0];
    final rest = parts
        .skip(1)
        .map((p) => p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1)}')
        .join();
    return '$first$rest';
  }

  static Map<String, int> wordFrequency(String text) {
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z\s]'), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final freq = <String, int>{};
    for (final word in words) {
      freq[word] = (freq[word] ?? 0) + 1;
    }
    return freq;
  }

  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }
}

// ============================================================================
// 场景 15: 异步操作 + Future 链
// ============================================================================
Future<int> asyncAdd(int a, int b) async {
  await Future.delayed(Duration(milliseconds: 1));
  return a + b;
}

Future<String> asyncTransform(int value) async {
  final doubled = await asyncAdd(value, value);
  final tripled = await asyncAdd(doubled, value);
  return 'value=$value, doubled=$doubled, tripled=$tripled';
}

Future<List<int>> asyncSequence(int count) async {
  final results = <int>[];
  for (var i = 0; i < count; i++) {
    final value = await asyncAdd(i, i * i);
    results.add(value);
  }
  return results;
}

// ============================================================================
// 场景 16: 枚举 + switch 表达式 + 枚举方法
// ============================================================================
enum Season {
  spring,
  summer,
  autumn,
  winter;

  String get displayName {
    switch (this) {
      case Season.spring:
        return 'Spring';
      case Season.summer:
        return 'Summer';
      case Season.autumn:
        return 'Autumn';
      case Season.winter:
        return 'Winter';
    }
  }

  Season get next {
    switch (this) {
      case Season.spring:
        return Season.summer;
      case Season.summer:
        return Season.autumn;
      case Season.autumn:
        return Season.winter;
      case Season.winter:
        return Season.spring;
    }
  }

  bool get isWarm => this == Season.spring || this == Season.summer;
}

// ============================================================================
// 场景 17: 复杂的 Map 操作 + 嵌套数据结构
// ============================================================================
class JsonLikeProcessor {
  static dynamic deepMerge(Map<String, dynamic> base, Map<String, dynamic> overlay) {
    final result = Map<String, dynamic>.from(base);
    for (final key in overlay.keys) {
      if (result.containsKey(key) &&
          result[key] is Map<String, dynamic> &&
          overlay[key] is Map<String, dynamic>) {
        result[key] = deepMerge(
          result[key] as Map<String, dynamic>,
          overlay[key] as Map<String, dynamic>,
        );
      } else {
        result[key] = overlay[key];
      }
    }
    return result;
  }

  static List<String> flattenKeys(Map<String, dynamic> map, {String prefix = ''}) {
    final keys = <String>[];
    for (final entry in map.entries) {
      final fullKey = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
      if (entry.value is Map<String, dynamic>) {
        keys.addAll(flattenKeys(entry.value as Map<String, dynamic>, prefix: fullKey));
      } else {
        keys.add(fullKey);
      }
    }
    return keys..sort();
  }
}

// ============================================================================
// 场景 18: 扩展方法 — 多种类型 + 泛型扩展
// ============================================================================
extension IntMathExtension on int {
  bool get isPrime {
    if (this <= 1) return false;
    if (this <= 3) return true;
    if (this % 2 == 0 || this % 3 == 0) return false;
    for (var i = 5; i * i <= this; i += 6) {
      if (this % i == 0 || this % (i + 2) == 0) return false;
    }
    return true;
  }

  int get factorial {
    if (this < 0) throw ArgumentError('Factorial not defined for negative numbers');
    if (this <= 1) return 1;
    var result = 1;
    for (var i = 2; i <= this; i++) {
      result *= i;
    }
    return result;
  }

  List<int> get digits {
    if (this == 0) return [0];
    final result = <int>[];
    var n = this.abs();
    while (n > 0) {
      result.insert(0, n % 10);
      n ~/= 10;
    }
    return result;
  }
}

extension IterableStats<T extends num> on Iterable<T> {
  T get sum => reduce((a, b) => (a + b) as T);
  double get average => isEmpty ? 0.0 : sum / length;
  T get max => reduce((a, b) => a > b ? a : b);
  T get min => reduce((a, b) => a < b ? a : b);
}

// ============================================================================
// 场景 19: 复杂构造函数 — 命名构造 + 重定向 + 初始化列表
// ============================================================================
class Matrix2D {
  final List<List<double>> _data;
  final int rows;
  final int cols;

  Matrix2D(this._data)
      : rows = _data.length,
        cols = _data.isEmpty ? 0 : _data[0].length;

  Matrix2D.zeros(this.rows, this.cols)
      : _data = List.generate(rows, (_) => List.filled(cols, 0.0));

  Matrix2D.identity(int size)
      : rows = size,
        cols = size,
        _data = List.generate(
            size, (i) => List.generate(size, (j) => i == j ? 1.0 : 0.0));

  double get(int row, int col) => _data[row][col];

  Matrix2D operator +(Matrix2D other) {
    final result = Matrix2D.zeros(rows, cols);
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        result._data[i][j] = _data[i][j] + other._data[i][j];
      }
    }
    return result;
  }

  Matrix2D operator *(Matrix2D other) {
    final result = Matrix2D.zeros(rows, other.cols);
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < other.cols; j++) {
        var sum = 0.0;
        for (var k = 0; k < cols; k++) {
          sum += _data[i][k] * other._data[k][j];
        }
        result._data[i][j] = sum;
      }
    }
    return result;
  }

  double get trace {
    var sum = 0.0;
    final minDim = rows < cols ? rows : cols;
    for (var i = 0; i < minDim; i++) {
      sum += _data[i][i];
    }
    return sum;
  }

  @override
  String toString() {
    final rowStrings = _data
        .map((row) => row.map((v) => v.toStringAsFixed(1)).join(', '))
        .map((r) => '[$r]')
        .join(', ');
    return 'Matrix(${rows}x$cols: $rowStrings)';
  }
}

// ============================================================================
// 场景 20: 多重 mixin + 抽象类 + 泛型约束的综合体
// ============================================================================
abstract class Entity {
  String get entityId;
}

mixin Auditable on Entity {
  final List<String> _auditLog = [];

  void audit(String action) {
    _auditLog.add('[$entityId] $action');
  }

  List<String> get auditLog => List.unmodifiable(_auditLog);
}

mixin Cacheable on Entity {
  DateTime? _cachedAt;
  bool _isDirty = true;

  void markDirty() => _isDirty = true;
  void markCached() {
    _isDirty = false;
    _cachedAt = DateTime.now();
  }

  bool get isDirty => _isDirty;
  String get cacheStatus =>
      _isDirty ? 'dirty' : 'cached';
}

class Product extends Entity with Auditable, Cacheable {
  @override
  final String entityId;
  final String name;
  final double price;

  Product(this.entityId, this.name, this.price);

  @override
  String toString() =>
      'Product($entityId, $name, \$$price, $cacheStatus, audits=${_auditLog.length})';
}

// ============================================================================
// 主函数：综合测试
// ============================================================================
void main() async {
  print('=== 高级语法还原测试 ===\n');

  // ---- 场景 1: 嵌套闭包 ----
  print('--- 1. 嵌套闭包 ---');
  final counter = makeCounter(start: 5, step: 3);
  print('counter: ${counter()}, ${counter()}, ${counter()}');

  final acc = makeAccumulator(100);
  final snap1 = acc(10);
  final snap2 = acc(20);
  print('snap1: ${snap1()}');
  print('snap2: ${snap2()}');

  final closures = makeClosureList(4);
  for (final cl in closures) {
    print('  ${cl()}');
  }

  // ---- 场景 2: 二叉树 ----
  print('\n--- 2. 二叉树 ---');
  final tree = TreeNode<int>(
    1,
    TreeNode<int>(2, TreeNode<int>(4), TreeNode<int>(5)),
    TreeNode<int>(3, null, TreeNode<int>(6)),
  );
  print('preorder: ${tree.preorder()}');
  print('inorder: ${tree.inorder()}');
  print('depth: ${tree.depth}');
  final strTree = tree.map((v) => 'N$v');
  print('mapped preorder: ${strTree.preorder()}');

  // ---- 场景 3: 链表 ----
  print('\n--- 3. 链表 ---');
  final list = LinkedNode<int>(1, LinkedNode<int>(2, LinkedNode<int>(3, LinkedNode<int>(4))));
  print('list: $list');
  print('length: ${list.length}');
  final revList = list.reversed();
  print('reversed: $revList');

  // ---- 场景 4: Either ----
  print('\n--- 4. Either ---');
  final right = Either<String, int>.right(42);
  final left = Either<String, int>.left('error');
  print('right: $right');
  print('left: $left');
  print('right.fold: ${right.fold((l) => "L:$l", (r) => "R:$r")}');
  print('left.fold: ${left.fold((l) => "L:$l", (r) => "R:$r")}');
  final mapped = right.mapRight((v) => v * 2);
  print('mapped right: $mapped');
  final chained = right.flatMap((v) => v > 10 ? Either.right('big_$v') : Either.left('too small'));
  print('chained: $chained');

  // ---- 场景 5: 函数式编程 ----
  print('\n--- 5. 函数式编程 ---');
  final double2 = (int x) => x * 2;
  final addOne = (int x) => x + 1;
  final composed = composeFunc<int, int, int>(addOne, double2);
  print('compose(double, addOne)(5): ${composed(5)}');

  final curriedAdd = curry<int, int, int>((a, b) => a + b);
  final add10 = curriedAdd(10);
  print('curriedAdd(10)(5): ${add10(5)}');

  final piped = pipe<int>(3, [(x) => x * 2, (x) => x + 10, (x) => x * x]);
  print('pipe(3, [*2, +10, ^2]): $piped');

  final memoFib = memoize<int, int>((n) {
    if (n <= 1) return n;
    // 注意：这里的 memoize 不会递归记忆化，仅演示接口
    return n; // 简化
  });
  print('memoized(10): ${memoFib(10)}');
  print('memoized(10) again: ${memoFib(10)}');

  // ---- 场景 6: 多重嵌套控制流 ----
  print('\n--- 6. 多重嵌套控制流 ---');
  final testNumbers = [-150, -42, -3, 0, 1, 7, 12, 97];
  for (final n in testNumbers) {
    print('  $n → ${classifyNumber(n)}');
  }

  print('parseNumbers: ${parseNumbers(["10", "abc", " 42 ", "-5", "", "7"])}');

  // ---- 场景 7: mixin 组合 ----
  print('\n--- 7. mixin 组合 ---');
  final user1 = UserProfile('Alice', 'alice@example.com', 25);
  print('user1: $user1');
  print('serialize: ${user1.serialize()}');
  print('validation: ${user1.validationSummary}');
  final user2 = UserProfile('', 'invalid-email', -5);
  print('user2 validation: ${user2.validationSummary}');

  // ---- 场景 8: 模板方法模式 ----
  print('\n--- 8. 模板方法模式 ---');
  final strToInt = StringToIntTransformer();
  print('strToInt("  42  "): ${strToInt.transform("  42  ")}');
  final intToStr = IntToStringTransformer('NUM:');
  print('intToStr(123): ${intToStr.transform(123)}');
  final chained2 = ChainedTransformer<String, int, String>(strToInt, intToStr);
  print('chained(" 99 "): ${chained2.transform(" 99 ")}');

  // ---- 场景 9: 单例 + 工厂构造函数 ----
  print('\n--- 9. 单例 Registry ---');
  final reg1 = Registry();
  final reg2 = Registry();
  print('same instance: ${identical(reg1, reg2)}');
  reg1.register('name', 'Dart');
  reg1.register('version', 3);
  print('registry: $reg1');
  print('lookup name: ${reg2.lookup("name")}');
  print('keys: ${reg1.keys}');
  reg1.clear();

  // ---- 场景 10: 集合操作链 ----
  print('\n--- 10. 集合操作链 ---');
  final records = [
    {'name': 'Alice', 'score': 95},
    {'name': 'Bob', 'score': 72},
    {'name': 'Carol', 'score': 88},
    {'name': 'Dave', 'score': 45},
    {'name': 'Eve', 'score': 91},
    {'name': 'Frank', 'score': 63},
  ];
  final processed = DataProcessor.processRecords(records);
  for (final r in processed) {
    print('  ${r["name"]}: ${r["score"]} (${r["grade"]}, passed=${r["passed"]})');
  }
  final averages = DataProcessor.averageByGrade(processed);
  print('averages: $averages');

  // ---- 场景 11: late 变量 ----
  print('\n--- 11. late 变量 ---');
  final comp = ExpensiveComputation(42);
  print('comp: $comp');
  print('computedValue: ${comp.computedValue}');
  comp.initialize('test description');
  print('description: ${comp.description}');

  // ---- 场景 12: 局部函数 + 递归 ----
  print('\n--- 12. 局部函数 + 递归 ---');
  print('fibonacci(10): ${MathUtils.fibonacci(10)}');
  print('fibonacci(20): ${MathUtils.fibonacci(20)}');
  print('primeFactors(360): ${MathUtils.primeFactors(360)}');
  print('gcd(48, 18): ${MathUtils.gcd(48, 18)}');
  print('lcm(12, 18): ${MathUtils.lcm(12, 18)}');

  // ---- 场景 13: 多重 implements ----
  print('\n--- 13. 多重 implements ---');
  final scores = [
    Score('Math', 90),
    Score('English', 75),
    WeightedScore('Physics', 85, 1.5),
    WeightedScore('Art', 95, 0.5),
  ];
  for (final s in scores) {
    print('  ${s.prettyPrint()}');
  }
  final ws1 = scores[2] as WeightedScore;
  final ws2 = scores[3] as WeightedScore;
  print('physics > art (weighted): ${ws1.isGreaterThan(ws2)}');

  // ---- 场景 14: 字符串操作 ----
  print('\n--- 14. 字符串操作 ---');
  print('camelToSnake("helloWorldFoo"): ${TextProcessor.camelToSnake("helloWorldFoo")}');
  print('snakeToCamel("hello_world_foo"): ${TextProcessor.snakeToCamel("hello_world_foo")}');
  final freq = TextProcessor.wordFrequency('the quick brown fox jumps over the lazy fox');
  print('word frequency: $freq');
  print('truncate: ${TextProcessor.truncate("Hello, World! This is a long string.", 20)}');

  // ---- 场景 15: async 链 ----
  print('\n--- 15. async 链 ---');
  final asyncResult = await asyncTransform(5);
  print('asyncTransform(5): $asyncResult');
  final asyncSeq = await asyncSequence(5);
  print('asyncSequence(5): $asyncSeq');

  // ---- 场景 16: 增强枚举 ----
  print('\n--- 16. 增强枚举 ---');
  for (final s in Season.values) {
    print('  $s → ${s.displayName}, next=${s.next.displayName}, warm=${s.isWarm}');
  }

  // ---- 场景 17: 嵌套 Map 操作 ----
  print('\n--- 17. 嵌套 Map 操作 ---');
  final base = {
    'a': 1,
    'b': {'x': 10, 'y': 20},
    'c': 3,
  };
  final overlay = {
    'b': {'y': 99, 'z': 30},
    'd': 4,
  };
  final merged = JsonLikeProcessor.deepMerge(base, overlay);
  print('deepMerge: $merged');

  final nested = {
    'user': {
      'name': 'Alice',
      'address': {'city': 'NYC', 'zip': '10001'}
    },
    'role': 'admin',
  };
  print('flattenKeys: ${JsonLikeProcessor.flattenKeys(nested)}');

  // ---- 场景 18: 扩展方法 ----
  print('\n--- 18. 扩展方法 ---');
  print('7.isPrime: ${7.isPrime}');
  print('12.isPrime: ${12.isPrime}');
  print('5.factorial: ${5.factorial}');
  print('12345.digits: ${12345.digits}');
  final nums = [10, 20, 30, 40, 50];
  print('sum: ${nums.sum}, avg: ${nums.average}, max: ${nums.max}, min: ${nums.min}');

  // ---- 场景 19: Matrix2D ----
  print('\n--- 19. Matrix2D ---');
  final m1 = Matrix2D([
    [1.0, 2.0],
    [3.0, 4.0],
  ]);
  final m2 = Matrix2D.identity(2);
  print('m1: $m1');
  print('m2 (identity): $m2');
  print('m1 + m2: ${m1 + m2}');
  print('m1 * m2: ${m1 * m2}');
  print('m1 trace: ${m1.trace}');
  final m3 = Matrix2D.zeros(2, 3);
  print('zeros(2,3): $m3');

  // ---- 场景 20: 综合 mixin + 抽象类 ----
  print('\n--- 20. 综合 mixin + 抽象类 ---');
  final product = Product('P001', 'Widget', 9.99);
  product.audit('created');
  product.audit('priced');
  product.markCached();
  print('product: $product');
  print('auditLog: ${product.auditLog}');
  product.markDirty();
  print('after markDirty: ${product.cacheStatus}');

  print('\n=== 所有高级语法测试通过 ✅ ===');
}

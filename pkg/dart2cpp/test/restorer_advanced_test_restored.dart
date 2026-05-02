class VPtr {
  late Map<String, dynamic> vptr;
  @override
  String toString() {
    final fn = vptr['toString_'];
    if (fn != null) return (fn as Function)(this) as String;
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = vptr['operatorEq'];
    if (fn != null) return (fn as Function)(this, other) as bool;
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = vptr['get_hashCode'];
    if (fn != null) return (fn as Function)(this) as int;
    return super.hashCode;
  }
}

class IntBox {
  int value;
  IntBox(this.value);
}

class DoubleBox {
  double value;
  DoubleBox(this.value);
}

class StringBox {
  String value;
  StringBox(this.value);
}

class BoolBox {
  bool value;
  BoolBox(this.value);
}

class ObjectBox<T> {
  T value;
  ObjectBox(this.value);
}

typedef UnaryFunc<A, B> = B Function(A);

class TreeNodeValue<T> extends VPtr {
  late T value;
  late TreeNodeValue<T>? left;
  late TreeNodeValue<T>? right;
}

void TreeNode_new<T>(TreeNodeValue<T> this_, T value, [TreeNodeValue<T>? left = null, TreeNodeValue<T>? right = null]) {
  this_.vptr = {
    'preorder': (self) => TreeNode_preorder<T>(self),
    'inorder': (self) => TreeNode_inorder<T>(self),
    'get_depth': (self) => TreeNode_get_depth<T>(self),
    'map': (self, _a0) => TreeNode_map(self, _a0),
    'toString_': (self) => TreeNode_toString<T>(self),
  };
  this_.value = value;
  this_.left = left;
  this_.right = right;
}

List<T> TreeNode_preorder<T>(TreeNodeValue<T> this_) {
  final List<T> result = <T>[this_.value];
  if (!((this_.left == null)))   result.addAll((this_.left!.vptr['preorder'] as Function)(this_.left!));
  if (!((this_.right == null)))   result.addAll((this_.right!.vptr['preorder'] as Function)(this_.right!));
  return result;
}

List<T> TreeNode_inorder<T>(TreeNodeValue<T> this_) {
  final List<T> result = <T>[];
  if (!((this_.left == null)))   result.addAll((this_.left!.vptr['inorder'] as Function)(this_.left!));
  result.add(this_.value);
  if (!((this_.right == null)))   result.addAll((this_.right!.vptr['inorder'] as Function)(this_.right!));
  return result;
}

int TreeNode_get_depth<T>(TreeNodeValue<T> this_) {
  final int leftDepth = ((() { final _let1 = this_.left; return (_let1 == null) ? null : (_let1.vptr['get_depth'] as int Function(TreeNodeValue))(_let1); })() ?? 0);
  final int rightDepth = ((() { final _let3 = this_.right; return (_let3 == null) ? null : (_let3.vptr['get_depth'] as int Function(TreeNodeValue))(_let3); })() ?? 0);
  return (1 + ((leftDepth > rightDepth) ? leftDepth : rightDepth));
}

TreeNodeValue<R> TreeNode_map<T, R>(TreeNodeValue<T> this_, R Function(T) transform) {
  return (() { final _obj = TreeNodeValue<R>(); TreeNode_new(_obj, transform(this_.value), (() { final _let4 = this_.left; return (_let4 == null) ? null : TreeNode_map<T, R>(_let4, transform); })(), (() { final _let5 = this_.right; return (_let5 == null) ? null : TreeNode_map<T, R>(_let5, transform); })()); return _obj; })();
}

String TreeNode_toString<T>(TreeNodeValue<T> this_) {
  return 'TreeNode(${this_.value})';
}


class LinkedNodeValue<T> extends VPtr {
  late T data;
  late LinkedNodeValue<T>? next;
}

void LinkedNode_new<T>(LinkedNodeValue<T> this_, T data, [LinkedNodeValue<T>? next = null]) {
  this_.vptr = {
    'reversed': (self) => LinkedNode_reversed<T>(self),
    'toList': (self) => LinkedNode_toList<T>(self),
    'get_length': (self) => LinkedNode_get_length<T>(self),
    'toString_': (self) => LinkedNode_toString<T>(self),
  };
  this_.data = data;
  this_.next = next;
}

LinkedNodeValue<T> LinkedNode_reversed<T>(LinkedNodeValue<T> this_) {
  if ((this_.next == null))   return (() { final _obj = LinkedNodeValue<T>(); LinkedNode_new(_obj, this_.data); return _obj; })();
  final LinkedNodeValue<T> rev = (this_.next!.vptr['reversed'] as Function)(this_.next!);
  LinkedNodeValue<T> tail = rev;
  while (!((tail.next == null))) {
    tail = tail.next!;
  }
  tail.next = (() { final _obj = LinkedNodeValue<T>(); LinkedNode_new(_obj, this_.data); return _obj; })();
  return rev;
}

List<T> LinkedNode_toList<T>(LinkedNodeValue<T> this_) {
  final List<T> result = <T>[this_.data];
  LinkedNodeValue<T>? current = this_.next;
  while (!((current == null))) {
    result.add(current!.data);
    current = current!.next;
  }
  return result;
}

int LinkedNode_get_length<T>(LinkedNodeValue<T> this_) {
  int count = 1;
  LinkedNodeValue<T>? current = this_.next;
  while (!((current == null))) {
    count = (count + 1);
    current = current!.next;
  }
  return count;
}

String LinkedNode_toString<T>(LinkedNodeValue<T> this_) {
  return 'LinkedNode(${(this_.vptr['toList'] as Function)(this_).join(' -> ')})';
}


class EitherValue<L, R> extends VPtr {
  late L? _left;
  late R? _right;
  late bool _isRight;
}

void Either_new_left<L, R>(EitherValue<L, R> this_, L value) {
  this_.vptr = {
    'get_isLeft': (self) => Either_get_isLeft<L, R>(self),
    'get_isRight': (self) => Either_get_isRight<L, R>(self),
    'get_leftValue': (self) => Either_get_leftValue<L, R>(self),
    'get_rightValue': (self) => Either_get_rightValue<L, R>(self),
    'fold': (self, _a0, _a1) => Either_fold(self, _a0, _a1),
    'mapRight': (self, _a0) => Either_mapRight(self, _a0),
    'flatMap': (self, _a0) => Either_flatMap(self, _a0),
    'toString_': (self) => Either_toString<L, R>(self),
  };
  this_._left = value;
  this_._right = null;
  this_._isRight = false;
}

void Either_new_right<L, R>(EitherValue<L, R> this_, R value) {
  this_.vptr = {
    'get_isLeft': (self) => Either_get_isLeft<L, R>(self),
    'get_isRight': (self) => Either_get_isRight<L, R>(self),
    'get_leftValue': (self) => Either_get_leftValue<L, R>(self),
    'get_rightValue': (self) => Either_get_rightValue<L, R>(self),
    'fold': (self, _a0, _a1) => Either_fold(self, _a0, _a1),
    'mapRight': (self, _a0) => Either_mapRight(self, _a0),
    'flatMap': (self, _a0) => Either_flatMap(self, _a0),
    'toString_': (self) => Either_toString<L, R>(self),
  };
  this_._left = null;
  this_._right = value;
  this_._isRight = true;
}

bool Either_get_isLeft<L, R>(EitherValue<L, R> this_) {
  return !(this_._isRight);
}

bool Either_get_isRight<L, R>(EitherValue<L, R> this_) {
  return this_._isRight;
}

L Either_get_leftValue<L, R>(EitherValue<L, R> this_) {
  if (!((this_.vptr['get_isLeft'] as bool Function(EitherValue))(this_)))   throw StateError('Not a left value');
  return (this_._left as L);
}

R Either_get_rightValue<L, R>(EitherValue<L, R> this_) {
  if (!((this_.vptr['get_isRight'] as bool Function(EitherValue))(this_)))   throw StateError('Not a right value');
  return (this_._right as R);
}

T Either_fold<L, R, T>(EitherValue<L, R> this_, T Function(L) onLeft, T Function(R) onRight) {
  if (this_._isRight)   return onRight((this_._right as R));
  return onLeft((this_._left as L));
}

EitherValue<L, R2> Either_mapRight<L, R, R2>(EitherValue<L, R> this_, R2 Function(R) transform) {
  if (this_._isRight)   return (() { final _obj = EitherValue<L, R2>(); Either_new_right(_obj, transform((this_._right as R))); return _obj; })();
  return (() { final _obj = EitherValue<L, R2>(); Either_new_left(_obj, (this_._left as L)); return _obj; })();
}

EitherValue<L, R2> Either_flatMap<L, R, R2>(EitherValue<L, R> this_, EitherValue<L, R2> Function(R) transform) {
  if (this_._isRight)   return transform((this_._right as R));
  return (() { final _obj = EitherValue<L, R2>(); Either_new_left(_obj, (this_._left as L)); return _obj; })();
}

String Either_toString<L, R>(EitherValue<L, R> this_) {
  if (this_._isRight)   return 'Right(${this_._right})';
  return 'Left(${this_._left})';
}


// mixin Serializable → static functions for delegation
String Serializable_serialize(dynamic this_) {
  final Map<String, dynamic> map = (this_.vptr['toMap'] as Function)(this_);
  final String entries = map.entries.map((MapEntry<String, dynamic> e) => '${e.key}=${e.value}').join(', ');
  return '{${entries}}';
}


// mixin Validatable → static functions for delegation
bool Validatable_get_isValid(dynamic this_) {
  return (this_.vptr['validate'] as Function)(this_).isEmpty;
}

String Validatable_get_validationSummary(dynamic this_) {
  final List<String> errors = (this_.vptr['validate'] as Function)(this_);
  if (errors.isEmpty)   return 'valid';
  return 'invalid: ${errors.join('; ')}';
}


// mixin Copyable → static functions for delegation

class UserProfileValue extends UserProfile_Object_Serializable_ValidatableValue {
  late String name;
  late String email;
  late int age;
}

void UserProfile_new(UserProfileValue this_, String name, String email, int age) {
  this_.vptr = {
    'toMap': UserProfile_toMap,
    'serialize': UserProfile_serialize,
    'validate': UserProfile_validate,
    'get_isValid': UserProfile_get_isValid,
    'get_validationSummary': UserProfile_get_validationSummary,
    'toString_': UserProfile_toString,
  };
  this_.name = name;
  this_.email = email;
  this_.age = age;
}

Map<String, dynamic> UserProfile_toMap(UserProfileValue this_) {
  return <String, dynamic>{'name': this_.name, 'email': this_.email, 'age': this_.age};
}

List<String> UserProfile_validate(UserProfileValue this_) {
  final List<String> errors = <String>[];
  if (this_.name.isEmpty)   errors.add('name is empty');
  if (!(this_.email.contains('@')))   errors.add('invalid email');
  if (((this_.age < 0) || (this_.age > 150)))   errors.add('invalid age');
  return errors;
}

String UserProfile_toString(UserProfileValue this_) {
  return 'UserProfile(${this_.name}, ${this_.email}, ${this_.age})';
}

String UserProfile_serialize(UserProfileValue this_) {
  return Serializable_serialize(this_);
}

bool UserProfile_get_isValid(UserProfileValue this_) {
  return Validatable_get_isValid(this_);
}

String UserProfile_get_validationSummary(UserProfileValue this_) {
  return Validatable_get_validationSummary(this_);
}


class DataTransformerValue<TInput, TOutput> extends VPtr {
}

void DataTransformer_new<TInput, TOutput>(DataTransformerValue<TInput, TOutput> this_) {
  this_.vptr = {
    'transform': (self, _a0) => DataTransformer_transform<TInput, TOutput>(self, _a0),
    'preValidate': (self, _a0) => DataTransformer_preValidate<TInput, TOutput>(self, _a0),
    'process': (self, _a0) => DataTransformer_process<TInput, TOutput>(self, _a0),
    'postProcess': (self, _a0) => DataTransformer_postProcess<TInput, TOutput>(self, _a0),
  };
}

TOutput DataTransformer_transform<TInput, TOutput>(DataTransformerValue<TInput, TOutput> this_, TInput input) {
  final TInput validated = (this_.vptr['preValidate'] as Function)(this_, input);
  final TOutput processed = (this_.vptr['process'] as Function)(this_, validated);
  return (this_.vptr['postProcess'] as Function)(this_, processed);
}

TInput DataTransformer_preValidate<TInput, TOutput>(DataTransformerValue<TInput, TOutput> this_, TInput input) {
  return input;
}

TOutput DataTransformer_process<TInput, TOutput>(DataTransformerValue<TInput, TOutput> this_, TInput input) {
  throw UnimplementedError('DataTransformer.process is abstract');
}

TOutput DataTransformer_postProcess<TInput, TOutput>(DataTransformerValue<TInput, TOutput> this_, TOutput output) {
  return output;
}


class StringToIntTransformerValue extends DataTransformerValue<String, int> {
}

void StringToIntTransformer_new(StringToIntTransformerValue this_) {
  DataTransformer_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'transform': StringToIntTransformer_transform,
    'preValidate': StringToIntTransformer_preValidate,
    'process': StringToIntTransformer_process,
    'postProcess': StringToIntTransformer_postProcess,
  };
}

String StringToIntTransformer_preValidate(DataTransformerValue<String, int> this__, String input) {
  final this_ = this__ as StringToIntTransformerValue;
  return input.trim();
}

int StringToIntTransformer_process(DataTransformerValue<String, int> this__, String input) {
  final this_ = this__ as StringToIntTransformerValue;
  return int.parse(input);
}

int StringToIntTransformer_transform(StringToIntTransformerValue this_, String input) {
  return DataTransformer_transform<String, int>(this_, input);
}

int StringToIntTransformer_postProcess(StringToIntTransformerValue this_, int output) {
  return DataTransformer_postProcess<String, int>(this_, output);
}


class IntToStringTransformerValue extends DataTransformerValue<int, String> {
  late String prefix;
}

void IntToStringTransformer_new(IntToStringTransformerValue this_, [String prefix = '']) {
  DataTransformer_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'transform': IntToStringTransformer_transform,
    'preValidate': IntToStringTransformer_preValidate,
    'process': IntToStringTransformer_process,
    'postProcess': IntToStringTransformer_postProcess,
  };
  this_.prefix = prefix;
}

String IntToStringTransformer_process(DataTransformerValue<int, String> this__, int input) {
  final this_ = this__ as IntToStringTransformerValue;
  return '${this_.prefix}${input.toString()}';
}

String IntToStringTransformer_postProcess(DataTransformerValue<int, String> this__, String output) {
  final this_ = this__ as IntToStringTransformerValue;
  return output.toUpperCase();
}

String IntToStringTransformer_transform(IntToStringTransformerValue this_, int input) {
  return DataTransformer_transform<int, String>(this_, input);
}

int IntToStringTransformer_preValidate(IntToStringTransformerValue this_, int input) {
  return DataTransformer_preValidate<int, String>(this_, input);
}


class ChainedTransformerValue<A, B, C> extends DataTransformerValue<A, C> {
  late DataTransformerValue<A, B> first;
  late DataTransformerValue<B, C> second;
}

void ChainedTransformer_new<A, B, C>(ChainedTransformerValue<A, B, C> this_, DataTransformerValue<A, B> first, DataTransformerValue<B, C> second) {
  DataTransformer_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'transform': (self, _a0) => ChainedTransformer_transform<A, B, C>(self, _a0),
    'preValidate': (self, _a0) => ChainedTransformer_preValidate<A, B, C>(self, _a0),
    'process': (self, _a0) => ChainedTransformer_process<A, B, C>(self, _a0),
    'postProcess': (self, _a0) => ChainedTransformer_postProcess<A, B, C>(self, _a0),
  };
  this_.first = first;
  this_.second = second;
}

C ChainedTransformer_process<A, B, C>(DataTransformerValue<A, C> this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  final B intermediate = (this_.first.vptr['transform'] as Function)(this_.first, input);
  return (this_.second.vptr['transform'] as Function)(this_.second, intermediate);
}

C ChainedTransformer_transform<A, B, C>(ChainedTransformerValue<A, B, C> this_, A input) {
  return DataTransformer_transform<A, C>(this_, input);
}

A ChainedTransformer_preValidate<A, B, C>(ChainedTransformerValue<A, B, C> this_, A input) {
  return DataTransformer_preValidate<A, C>(this_, input);
}

C ChainedTransformer_postProcess<A, B, C>(ChainedTransformerValue<A, B, C> this_, C output) {
  return DataTransformer_postProcess<A, C>(this_, output);
}


class RegistryValue extends VPtr {
  late Map<String, dynamic> _store;
  late int _accessCount;
}

final RegistryValue Registry__instance = (() { final _obj = RegistryValue(); Registry_new__internal(_obj); return _obj; })();
void Registry_new__internal(RegistryValue this_) {
  this_.vptr = {
    'register': Registry_register,
    'lookup': Registry_lookup,
    'contains': Registry_contains,
    'get_size': Registry_get_size,
    'get_accessCount': Registry_get_accessCount,
    'get_keys': Registry_get_keys,
    'clear': Registry_clear,
    'toString_': Registry_toString,
  };
  this_._store = <String, dynamic>{};
  this_._accessCount = 0;
}

RegistryValue Registry_new() {
  return Registry__instance;
}

void Registry_register(RegistryValue this_, String key, dynamic value) {
  this_._store[key] = value;
  this_._accessCount = (this_._accessCount + 1);
}

dynamic Registry_lookup(RegistryValue this_, String key) {
  this_._accessCount = (this_._accessCount + 1);
  return this_._store[key];
}

bool Registry_contains(RegistryValue this_, String key) {
  return this_._store.containsKey(key);
}

int Registry_get_size(RegistryValue this_) {
  return this_._store.length;
}

int Registry_get_accessCount(RegistryValue this_) {
  return this_._accessCount;
}

List<String> Registry_get_keys(RegistryValue this_) {
  return (this_._store.keys.toList()..sort());
}

void Registry_clear(RegistryValue this_) {
  this_._store.clear();
  this_._accessCount = 0;
}

String Registry_toString(RegistryValue this_) {
  return 'Registry(size=${(this_.vptr['get_size'] as int Function(RegistryValue))(this_)}, accesses=${(this_.vptr['get_accessCount'] as int Function(RegistryValue))(this_)})';
}


class DataProcessorValue extends VPtr {
}

void DataProcessor_new(DataProcessorValue this_) {
  this_.vptr = {
  };
}

List<Map<String, dynamic>> DataProcessor_processRecords(List<Map<String, dynamic>> records) {
  return (records.where((Map<String, dynamic> r) => (r.containsKey('name') && r.containsKey('score'))).where((Map<String, dynamic> r) => ((r['score'] as int) >= 0)).map((Map<String, dynamic> r) => <String, Object>{'name': (r['name'] as String).toUpperCase(), 'score': (r['score'] as int), 'grade': DataProcessor__scoreToGrade((r['score'] as int)), 'passed': ((r['score'] as int) >= 60)}).toList()..sort((Map<String, Object> a, Map<String, Object> b) => (b['score'] as int).compareTo((a['score'] as int))));
}

String DataProcessor__scoreToGrade(int score) {
  if ((score >= 90))   return 'A';
  if ((score >= 80))   return 'B';
  if ((score >= 70))   return 'C';
  if ((score >= 60))   return 'D';
  return 'F';
}

Map<String, List<Map<String, dynamic>>> DataProcessor_groupByGrade(List<Map<String, dynamic>> records) {
  final Map<String, List<Map<String, dynamic>>> groups = <String, List<Map<String, dynamic>>>{};
  for (final record in records) {
    final String grade = (record['grade'] as String);
    groups.putIfAbsent(grade, () => <Map<String, dynamic>>[]);
    groups[grade]!.add(record);
  }
  return groups;
}

Map<String, double> DataProcessor_averageByGrade(List<Map<String, dynamic>> records) {
  final Map<String, List<Map<String, dynamic>>> groups = DataProcessor_groupByGrade(records);
  return groups.map((String grade, List<Map<String, dynamic>> items) {
    final int total = items.fold(0, (int sum, Map<String, dynamic> r) => (sum + (r['score'] as int)));
    return MapEntry(grade, (total / items.length));
  }
);
}


class ExpensiveComputationValue extends VPtr {
  late int seed;
  late int computedValue;
  late String description;
}

void ExpensiveComputation_new(ExpensiveComputationValue this_, int seed) {
  this_.vptr = {
    'initialize': ExpensiveComputation_initialize,
    'toString_': ExpensiveComputation_toString,
  };
  this_.seed = seed;
  this_.computedValue = ExpensiveComputation__computeExpensive(this_);
}

int ExpensiveComputation__computeExpensive(ExpensiveComputationValue this_) {
  int result = this_.seed;
  for (var i = 0; (i < 10); i = (i + 1)) {
    result = (((result * 31) + 17) % 1000);
  }
  return result;
}

void ExpensiveComputation_initialize(ExpensiveComputationValue this_, String desc) {
  this_.description = desc;
}

String ExpensiveComputation_toString(ExpensiveComputationValue this_) {
  return 'ExpensiveComputation(seed=${this_.seed}, computed=${this_.computedValue})';
}


class MathUtilsValue extends VPtr {
}

void MathUtils_new(MathUtilsValue this_) {
  this_.vptr = {
  };
}

int MathUtils_fibonacci(int n) {
  final Map<int, int> memo = <int, int>{};
  int fib(int k) {
    if ((k <= 1))     return k;
    if (memo.containsKey(k))     return memo[k]!;
    final int result = (fib((k - 1)) + fib((k - 2)));
    memo[k] = result;
    return result;
  }

  return fib(n);
}

List<int> MathUtils_primeFactors(int n) {
  final List<int> factors = <int>[];
  void extractFactor(int factor) {
    while (((n % factor) == 0)) {
      factors.add(factor);
      n = (n ~/ factor);
    }
  }

  extractFactor(2);
  for (var i = 3; ((i * i) <= n); i = (i + 2)) {
    extractFactor(i);
  }
  if ((n > 1))   factors.add(n);
  return factors;
}

int MathUtils_gcd(int a, int b) {
  while (!((b == 0))) {
    final int temp = b;
    b = (a % b);
    a = temp;
  }
  return a;
}

int MathUtils_lcm(int a, int b) {
  return ((a * b) ~/ MathUtils_gcd(a, b));
}


class Printable3Value extends VPtr {
}

void Printable3_new(Printable3Value this_) {
  this_.vptr = {
    'prettyPrint': Printable3_prettyPrint,
  };
}

String Printable3_prettyPrint(Printable3Value this_) {
  throw UnimplementedError('Printable3.prettyPrint is abstract');
}


class ScoreValue extends VPtr implements Printable3Value {
  late String subject;
  late int points;
}

void Score_new(ScoreValue this_, String subject, int points) {
  this_.vptr = {
    'prettyPrint': Score_prettyPrint,
    'compareTo2': Score_compareTo2,
    'isLessThan': Score_isLessThan,
    'isGreaterThan': Score_isGreaterThan,
    'toString_': Score_toString,
  };
  this_.subject = subject;
  this_.points = points;
}

int Score_compareTo2(ScoreValue this_, ScoreValue other) {
  return this_.points.compareTo(other.points);
}

bool Score_isLessThan(ScoreValue this_, ScoreValue other) {
  return ((this_.vptr['compareTo2'] as int Function(ScoreValue, ScoreValue))(this_, other) < 0);
}

bool Score_isGreaterThan(ScoreValue this_, ScoreValue other) {
  return ((this_.vptr['compareTo2'] as int Function(ScoreValue, ScoreValue))(this_, other) > 0);
}

String Score_prettyPrint(ScoreValue this_) {
  return '[${this_.subject}: ${this_.points} pts]';
}

String Score_toString(ScoreValue this_) {
  return 'Score(${this_.subject}, ${this_.points})';
}


class WeightedScoreValue extends ScoreValue {
  late double weight;
}

void WeightedScore_new(WeightedScoreValue this_, String subject, int points, double weight) {
  Score_new(this_, subject, points);
  this_.vptr = {
    ...this_.vptr,
    'prettyPrint': WeightedScore_prettyPrint,
    'compareTo2': WeightedScore_compareTo2,
    'isLessThan': WeightedScore_isLessThan,
    'isGreaterThan': WeightedScore_isGreaterThan,
    'toString_': WeightedScore_toString,
    'get_weightedPoints': WeightedScore_get_weightedPoints,
  };
  this_.weight = weight;
}

double WeightedScore_get_weightedPoints(WeightedScoreValue this_) {
  return (this_.points * this_.weight);
}

int WeightedScore_compareTo2(ScoreValue this__, ScoreValue other) {
  final this_ = this__ as WeightedScoreValue;
  if ((other is WeightedScoreValue)) {
    return (this_.vptr['get_weightedPoints'] as double Function(WeightedScoreValue))(this_).compareTo((other.vptr['get_weightedPoints'] as double Function(WeightedScoreValue))(other));
  }
  return Score_compareTo2(this_, other);
}

String WeightedScore_prettyPrint(WeightedScoreValue this_) {
  return '[${this_.subject}: ${this_.points} pts × ${this_.weight} = ${(this_.vptr['get_weightedPoints'] as double Function(WeightedScoreValue))(this_).toStringAsFixed(1)}]';
}

String WeightedScore_toString(ScoreValue this__) {
  final this_ = this__ as WeightedScoreValue;
  return 'WeightedScore(${this_.subject}, ${this_.points}, w=${this_.weight})';
}

bool WeightedScore_isLessThan(WeightedScoreValue this_, ScoreValue other) {
  return Score_isLessThan(this_, other);
}

bool WeightedScore_isGreaterThan(WeightedScoreValue this_, ScoreValue other) {
  return Score_isGreaterThan(this_, other);
}


class TextProcessorValue extends VPtr {
}

void TextProcessor_new(TextProcessorValue this_) {
  this_.vptr = {
  };
}

String TextProcessor_camelToSnake(String input) {
  final StringBuffer result = StringBuffer();
  for (var i = 0; (i < input.length); i = (i + 1)) {
    final String char = input[i];
    if ((((char == char.toUpperCase()) && !((char == char.toLowerCase()))) && (i > 0))) {
      result.write('_');
    }
    result.write(char.toLowerCase());
  }
  return result.toString();
}

String TextProcessor_snakeToCamel(String input) {
  final List<String> parts = input.split('_');
  if (parts.isEmpty)   return input;
  final String first = parts[0];
  final String rest = parts.skip(1).map((String p) => (p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1)}')).join();
  return '${first}${rest}';
}

Map<String, int> TextProcessor_wordFrequency(String text) {
  final List<String> words = text.toLowerCase().replaceAll(RegExp('[^a-z\\s]'), '').split(RegExp('\\s+')).where((String w) => w.isNotEmpty).toList();
  final Map<String, int> freq = <String, int>{};
  for (final word in words) {
    freq[word] = ((freq[word] ?? 0) + 1);
  }
  return freq;
}

String TextProcessor_truncate(String text, int maxLength, {String suffix = '...'}) {
  if ((text.length <= maxLength))   return text;
  return '${text.substring(0, (maxLength - suffix.length))}${suffix}';
}


enum Season {
  spring,
  summer,
  autumn,
  winter;
}

String Season_get_displayName(Season this_) {
  do {
    switch (this_) {
      case Season.spring:
{
          return 'Spring';
        }
      case Season.summer:
{
          return 'Summer';
        }
      case Season.autumn:
{
          return 'Autumn';
        }
      case Season.winter:
{
          return 'Winter';
        }
    }
  } while (false);
}

Season Season_get_next(Season this_) {
  do {
    switch (this_) {
      case Season.spring:
{
          return Season.summer;
        }
      case Season.summer:
{
          return Season.autumn;
        }
      case Season.autumn:
{
          return Season.winter;
        }
      case Season.winter:
{
          return Season.spring;
        }
    }
  } while (false);
}

bool Season_get_isWarm(Season this_) {
  return ((this_ == Season.spring) || (this_ == Season.summer));
}

class JsonLikeProcessorValue extends VPtr {
}

void JsonLikeProcessor_new(JsonLikeProcessorValue this_) {
  this_.vptr = {
  };
}

dynamic JsonLikeProcessor_deepMerge(Map<String, dynamic> base, Map<String, dynamic> overlay) {
  final Map<String, dynamic> result = Map.from(base);
  for (final key in overlay.keys) {
    if (((result.containsKey(key) && (result[key] is Map<String, dynamic>)) && (overlay[key] is Map<String, dynamic>))) {
      result[key] = JsonLikeProcessor_deepMerge((result[key] as Map<String, dynamic>), (overlay[key] as Map<String, dynamic>));
    }
 else {
      result[key] = overlay[key];
    }
  }
  return result;
}

List<String> JsonLikeProcessor_flattenKeys(Map<String, dynamic> map, {String prefix = ''}) {
  final List<String> keys = <String>[];
  for (final entry in map.entries) {
    final String fullKey = (prefix.isEmpty ? entry.key : '${prefix}.${entry.key}');
    if ((entry.value is Map<String, dynamic>)) {
      keys.addAll(JsonLikeProcessor_flattenKeys((entry.value as Map<String, dynamic>), prefix: fullKey));
    }
 else {
      keys.add(fullKey);
    }
  }
  return (keys..sort());
}


class Matrix2DValue extends VPtr {
  late List<List<double>> _data;
  late int rows;
  late int cols;
}

void Matrix2D_new(Matrix2DValue this_, List<List<double>> _data) {
  this_.vptr = {
    'get': Matrix2D_get,
    'operatorPlus': Matrix2D_operatorPlus,
    'operatorStar': Matrix2D_operatorStar,
    'get_trace': Matrix2D_get_trace,
    'toString_': Matrix2D_toString,
  };
  this_._data = _data;
  this_.rows = _data.length;
  this_.cols = (_data.isEmpty ? 0 : _data[0].length);
}

void Matrix2D_new_zeros(Matrix2DValue this_, int rows, int cols) {
  this_.vptr = {
    'get': Matrix2D_get,
    'operatorPlus': Matrix2D_operatorPlus,
    'operatorStar': Matrix2D_operatorStar,
    'get_trace': Matrix2D_get_trace,
    'toString_': Matrix2D_toString,
  };
  this_.rows = rows;
  this_.cols = cols;
  this_._data = List.generate(rows, ClosureEnv_anon_0(cols).call);
}

void Matrix2D_new_identity(Matrix2DValue this_, int size) {
  this_.vptr = {
    'get': Matrix2D_get,
    'operatorPlus': Matrix2D_operatorPlus,
    'operatorStar': Matrix2D_operatorStar,
    'get_trace': Matrix2D_get_trace,
    'toString_': Matrix2D_toString,
  };
  this_.rows = size;
  this_.cols = size;
  this_._data = List.generate(size, ClosureEnv_anon_1(size).call);
}

double Matrix2D_get(Matrix2DValue this_, int row, int col) {
  return this_._data[row][col];
}

Matrix2DValue Matrix2D_operatorPlus(Matrix2DValue this_, Matrix2DValue other) {
  final Matrix2DValue result = (() { final _obj = Matrix2DValue(); Matrix2D_new_zeros(_obj, this_.rows, this_.cols); return _obj; })();
  for (var i = 0; (i < this_.rows); i = (i + 1)) {
    for (var j = 0; (j < this_.cols); j = (j + 1)) {
      result._data[i][j] = (this_._data[i][j] + other._data[i][j]);
    }
  }
  return result;
}

Matrix2DValue Matrix2D_operatorStar(Matrix2DValue this_, Matrix2DValue other) {
  final Matrix2DValue result = (() { final _obj = Matrix2DValue(); Matrix2D_new_zeros(_obj, this_.rows, other.cols); return _obj; })();
  for (var i = 0; (i < this_.rows); i = (i + 1)) {
    for (var j = 0; (j < other.cols); j = (j + 1)) {
      double sum = 0.0;
      for (var k = 0; (k < this_.cols); k = (k + 1)) {
        sum = (sum + (this_._data[i][k] * other._data[k][j]));
      }
      result._data[i][j] = sum;
    }
  }
  return result;
}

double Matrix2D_get_trace(Matrix2DValue this_) {
  double sum = 0.0;
  final int minDim = ((this_.rows < this_.cols) ? this_.rows : this_.cols);
  for (var i = 0; (i < minDim); i = (i + 1)) {
    sum = (sum + this_._data[i][i]);
  }
  return sum;
}

String Matrix2D_toString(Matrix2DValue this_) {
  final String rowStrings = this_._data.map((List<double> row) => row.map((double v) => v.toStringAsFixed(1)).join(', ')).map((String r) => '[${r}]').join(', ');
  return 'Matrix(${this_.rows}x${this_.cols}: ${rowStrings})';
}


class EntityValue extends VPtr {
}

void Entity_new(EntityValue this_) {
  this_.vptr = {
    'get_entityId': Entity_get_entityId,
  };
}

String Entity_get_entityId(EntityValue this_) {
  throw UnimplementedError('Entity.entityId is abstract');
}


// mixin Auditable → static functions for delegation
void Auditable_audit(dynamic this_, String action) {
  this_._auditLog.add('[${(this_.vptr['get_entityId'] as Function)(this_)}] ${action}');
}

List<String> Auditable_get_auditLog(dynamic this_) {
  return List.unmodifiable(this_._auditLog);
}


// mixin Cacheable → static functions for delegation
void Cacheable_markDirty(dynamic this_) {
  this_._isDirty = true;
}

void Cacheable_markCached(dynamic this_) {
  this_._isDirty = false;
  this_._cachedAt = DateTime.now();
}

bool Cacheable_get_isDirty(dynamic this_) {
  return this_._isDirty;
}

String Cacheable_get_cacheStatus(dynamic this_) {
  return (this_._isDirty ? 'dirty' : 'cached');
}


class ProductValue extends Product_Entity_Auditable_CacheableValue {
  late String entityId;
  late String name;
  late double price;
}

void Product_new(ProductValue this_, String entityId, String name, double price) {
  Entity_new(this_);
  this_.vptr = {
    'get_entityId': Product_get_entityId,
    'audit': Product_audit,
    'get_auditLog': Product_get_auditLog,
    'markDirty': Product_markDirty,
    'markCached': Product_markCached,
    'get_isDirty': Product_get_isDirty,
    'get_cacheStatus': Product_get_cacheStatus,
    'toString_': Product_toString,
  };
  this_.entityId = entityId;
  this_.name = name;
  this_.price = price;
  this_._auditLog = <String>[];
  this_._cachedAt = null;
  this_._isDirty = true;
}

String Product_toString(ProductValue this_) {
  return 'Product(${this_.entityId}, ${this_.name}, \$${this_.price}, ${(this_.vptr['get_cacheStatus'] as String Function(ProductValue))(this_)}, audits=${this_._auditLog.length})';
}

String Product_get_entityId(ProductValue this_) {
  return (this_ as ProductValue).entityId;
}

void Product_audit(ProductValue this_, String action) {
  Auditable_audit(this_, action);
}

List<String> Product_get_auditLog(ProductValue this_) {
  return Auditable_get_auditLog(this_);
}

void Product_markDirty(ProductValue this_) {
  Cacheable_markDirty(this_);
}

void Product_markCached(ProductValue this_) {
  Cacheable_markCached(this_);
}

bool Product_get_isDirty(ProductValue this_) {
  return Cacheable_get_isDirty(this_);
}

String Product_get_cacheStatus(ProductValue this_) {
  return Cacheable_get_cacheStatus(this_);
}


class UserProfile_Object_SerializableValue extends VPtr {
}


class UserProfile_Object_Serializable_ValidatableValue extends UserProfile_Object_SerializableValue {
}


class Product_Entity_AuditableValue extends EntityValue {
  late List<String> _auditLog;
}


class Product_Entity_Auditable_CacheableValue extends Product_Entity_AuditableValue {
  late DateTime? _cachedAt;
  late bool _isDirty;
}


Function makeCounter({int start = 0, int step = 1}) {
  IntBox current = IntBox(start);
  return ClosureEnv_makeCounter_3(current, step).call;
}

Function makeAccumulator(int initial) {
  IntBox total = IntBox(initial);
  return ClosureEnv_makeAccumulator_4(total).call;
}

List<Function> makeClosureList(int count) {
  final List<Function> closures = <Function>[];
  for (var i = 0; (i < count); i = (i + 1)) {
    closures.add(ClosureEnv_makeClosureList_6(i).call);
  }
  return closures;
}

C Function(A) composeFunc<A, B, C>(C Function(B) funcBC_raw, B Function(A) funcAB_raw) {
  ObjectBox<C Function(B)> funcBC = ObjectBox<C Function(B)>(funcBC_raw);
  ObjectBox<B Function(A)> funcAB = ObjectBox<B Function(A)>(funcAB_raw);
  return ClosureEnv_composeFunc_7(funcBC, funcAB).call;
}

C Function(B) Function(A) curry<A, B, C>(C Function(A, B) biFunc_raw) {
  ObjectBox<C Function(A, B)> biFunc = ObjectBox<C Function(A, B)>(biFunc_raw);
  return ClosureEnv_curry_8(biFunc).call;
}

T pipe<T>(T value, List<T Function(T)> transforms) {
  T result = value;
  for (final transform in transforms) {
    result = transform(result);
  }
  return result;
}

B Function(A) memoize<A, B>(B Function(A) func_raw) {
  ObjectBox<B Function(A)> func = ObjectBox<B Function(A)>(func_raw);
  ObjectBox<Map<A, B>> cache = ObjectBox<Map<A, B>>(<A, B>{});
  return ClosureEnv_memoize_10(cache, func).call;
}

String classifyNumber(int number) {
  String result = '';
  if ((number < 0)) {
    result = 'negative';
    if (((number % 2) == 0)) {
      result = (result + '_even');
    }
 else {
      result = (result + '_odd');
    }
    if ((number < (-100))) {
      result = (result + '_large');
    }
 else     if ((number < (-10))) {
      result = (result + '_medium');
    }
 else {
      result = (result + '_small');
    }
  }
 else   if ((number == 0)) {
    result = 'zero';
  }
 else {
    result = 'positive';
    bool isPrime = (number > 1);
    do {
      for (var i = 2; ((i * i) <= number); i = (i + 1)) {
        if (((number % i) == 0)) {
          isPrime = false;
          break;
        }
      }
    } while (false);
    if ((isPrime && (number > 1))) {
      result = (result + '_prime');
    }
 else     if ((number > 1)) {
      do {
        for (var i = 2; (i <= number); i = (i + 1)) {
          if (((number % i) == 0)) {
            result = (result + '_composite(smallest_factor=${i})');
            break;
          }
        }
      } while (false);
    }
  }
  return result;
}

List<int> parseNumbers(List<String> inputs) {
  final List<int> results = <int>[];
  for (var i = 0; (i < inputs.length); i = (i + 1))   do {
{
      try {
        final String trimmed = inputs[i].trim();
        if (trimmed.isEmpty)         break;
        final int value = int.parse(trimmed);
        if ((value < 0)) {
          throw ArgumentError('Negative value at index ${i}: ${value}');
        }
        results.add(value);
      }
 on FormatException {
        results.add((-1));
      }
 on ArgumentError catch (e) {
        results.add((-2));
      }
    }
  } while (false);
  return results;
}

Future<int> asyncAdd(int a, int b) async {
  await Future.delayed(Duration(milliseconds: 1));
  return (a + b);
}

Future<String> asyncTransform(int value) async {
  final int doubled = await asyncAdd(value, value);
  final int tripled = await asyncAdd(doubled, value);
  return 'value=${value}, doubled=${doubled}, tripled=${tripled}';
}

Future<List<int>> asyncSequence(int count) async {
  final List<int> results = <int>[];
  for (var i = 0; (i < count); i = (i + 1)) {
    final int value = await asyncAdd(i, (i * i));
    results.add(value);
  }
  return results;
}

bool IntMathExtension_get_isPrime(final int this_) {
  if ((this_ <= 1))   return false;
  if ((this_ <= 3))   return true;
  if ((((this_ % 2) == 0) || ((this_ % 3) == 0)))   return false;
  for (var i = 5; ((i * i) <= this_); i = (i + 6)) {
    if ((((this_ % i) == 0) || ((this_ % (i + 2)) == 0)))     return false;
  }
  return true;
}

int IntMathExtension_get_factorial(final int this_) {
  if ((this_ < 0))   throw ArgumentError('Factorial not defined for negative numbers');
  if ((this_ <= 1))   return 1;
  int result = 1;
  for (var i = 2; (i <= this_); i = (i + 1)) {
    result = (result * i);
  }
  return result;
}

List<int> IntMathExtension_get_digits(final int this_) {
  if ((this_ == 0))   return <int>[0];
  final List<int> result = <int>[];
  int n = this_.abs();
  while ((n > 0)) {
    result.insert(0, (n % 10));
    n = (n ~/ 10);
  }
  return result;
}

T IterableStats_get_sum<T extends num>(final Iterable<T> this_) {
  return this_.reduce((T a, T b) => ((a + b) as T));
}

double IterableStats_get_average<T extends num>(final Iterable<T> this_) {
  return (this_.isEmpty ? 0.0 : (IterableStats_get_sum(this_) / this_.length));
}

T IterableStats_get_max<T extends num>(final Iterable<T> this_) {
  return this_.reduce((T a, T b) => ((a > b) ? a : b));
}

T IterableStats_get_min<T extends num>(final Iterable<T> this_) {
  return this_.reduce((T a, T b) => ((a < b) ? a : b));
}

void main() async {
  print('=== 高级语法还原测试 ===\n');
  print('--- 1. 嵌套闭包 ---');
  final Function counter = makeCounter(start: 5, step: 3);
  print('counter: ${counter()}, ${counter()}, ${counter()}');
  final Function acc = makeAccumulator(100);
  final dynamic snap1 = acc(10);
  final dynamic snap2 = acc(20);
  print('snap1: ${snap1.call()}');
  print('snap2: ${snap2.call()}');
  final List<Function> closures = makeClosureList(4);
  for (final cl in closures) {
    print('  ${cl()}');
  }
  print('\n--- 2. 二叉树 ---');
  final TreeNodeValue<int> tree = (() { final _obj = TreeNodeValue<int>(); TreeNode_new(_obj, 1, (() { final _obj = TreeNodeValue<int>(); TreeNode_new(_obj, 2, (() { final _obj = TreeNodeValue<int>(); TreeNode_new(_obj, 4); return _obj; })(), (() { final _obj = TreeNodeValue<int>(); TreeNode_new(_obj, 5); return _obj; })()); return _obj; })(), (() { final _obj = TreeNodeValue<int>(); TreeNode_new(_obj, 3, null, (() { final _obj = TreeNodeValue<int>(); TreeNode_new(_obj, 6); return _obj; })()); return _obj; })()); return _obj; })();
  print('preorder: ${(tree.vptr['preorder'] as Function)(tree)}');
  print('inorder: ${(tree.vptr['inorder'] as Function)(tree)}');
  print('depth: ${(tree.vptr['get_depth'] as int Function(TreeNodeValue))(tree)}');
  final TreeNodeValue<String> strTree = TreeNode_map<int, String>(tree, (int v) => 'N${v}');
  print('mapped preorder: ${(strTree.vptr['preorder'] as Function)(strTree)}');
  print('\n--- 3. 链表 ---');
  final LinkedNodeValue<int> list = (() { final _obj = LinkedNodeValue<int>(); LinkedNode_new(_obj, 1, (() { final _obj = LinkedNodeValue<int>(); LinkedNode_new(_obj, 2, (() { final _obj = LinkedNodeValue<int>(); LinkedNode_new(_obj, 3, (() { final _obj = LinkedNodeValue<int>(); LinkedNode_new(_obj, 4); return _obj; })()); return _obj; })()); return _obj; })()); return _obj; })();
  print('list: ${list}');
  print('length: ${(list.vptr['get_length'] as int Function(LinkedNodeValue))(list)}');
  final LinkedNodeValue<int> revList = (list.vptr['reversed'] as Function)(list);
  print('reversed: ${revList}');
  print('\n--- 4. Either ---');
  final EitherValue<String, int> right = (() { final _obj = EitherValue<String, int>(); Either_new_right(_obj, 42); return _obj; })();
  final EitherValue<String, int> left = (() { final _obj = EitherValue<String, int>(); Either_new_left(_obj, 'error'); return _obj; })();
  print('right: ${right}');
  print('left: ${left}');
  print('right.fold: ${Either_fold<String, int, String>(right, (String l) => 'L:${l}', (int r) => 'R:${r}')}');
  print('left.fold: ${Either_fold<String, int, String>(left, (String l) => 'L:${l}', (int r) => 'R:${r}')}');
  final EitherValue<String, int> mapped = Either_mapRight<String, int, int>(right, (int v) => (v * 2));
  print('mapped right: ${mapped}');
  final EitherValue<String, dynamic> chained = Either_flatMap<String, int, dynamic>(right, (int v) => ((v > 10) ? (() { final _obj = EitherValue<String, String>(); Either_new_right(_obj, 'big_${v}'); return _obj; })() : (() { final _obj = EitherValue<String, dynamic>(); Either_new_left(_obj, 'too small'); return _obj; })()));
  print('chained: ${chained}');
  print('\n--- 5. 函数式编程 ---');
  final int Function(int) double2 = (int x) => (x * 2);
  final int Function(int) addOne = (int x) => (x + 1);
  final int Function(int) composed = composeFunc(addOne, double2);
  print('compose(double, addOne)(5): ${composed(5)}');
  final int Function(int) Function(int) curriedAdd = curry((int a, int b) => (a + b));
  final int Function(int) add10 = curriedAdd(10);
  print('curriedAdd(10)(5): ${add10(5)}');
  final int piped = pipe(3, <int Function(int)>[(int x) => (x * 2), (int x) => (x + 10), (int x) => (x * x)]);
  print('pipe(3, [*2, +10, ^2]): ${piped}');
  final int Function(int) memoFib = memoize((int n) {
    if ((n <= 1))     return n;
    return n;
  }
);
  print('memoized(10): ${memoFib(10)}');
  print('memoized(10) again: ${memoFib(10)}');
  print('\n--- 6. 多重嵌套控制流 ---');
  final List<int> testNumbers = <int>[(-150), (-42), (-3), 0, 1, 7, 12, 97];
  for (final n in testNumbers) {
    print('  ${n} → ${classifyNumber(n)}');
  }
  print('parseNumbers: ${parseNumbers(<String>['10', 'abc', ' 42 ', '-5', '', '7'])}');
  print('\n--- 7. mixin 组合 ---');
  final UserProfileValue user1 = (() { final _obj = UserProfileValue(); UserProfile_new(_obj, 'Alice', 'alice@example.com', 25); return _obj; })();
  print('user1: ${user1}');
  print('serialize: ${(user1.vptr['serialize'] as Function)(user1)}');
  print('validation: ${(user1.vptr['get_validationSummary'] as String Function(UserProfileValue))(user1)}');
  final UserProfileValue user2 = (() { final _obj = UserProfileValue(); UserProfile_new(_obj, '', 'invalid-email', (-5)); return _obj; })();
  print('user2 validation: ${(user2.vptr['get_validationSummary'] as String Function(UserProfileValue))(user2)}');
  print('\n--- 8. 模板方法模式 ---');
  final StringToIntTransformerValue strToInt = (() { final _obj = StringToIntTransformerValue(); StringToIntTransformer_new(_obj); return _obj; })();
  print('strToInt("  42  "): ${(strToInt.vptr['transform'] as Function)(strToInt, '  42  ')}');
  final IntToStringTransformerValue intToStr = (() { final _obj = IntToStringTransformerValue(); IntToStringTransformer_new(_obj, 'NUM:'); return _obj; })();
  print('intToStr(123): ${(intToStr.vptr['transform'] as Function)(intToStr, 123)}');
  final ChainedTransformerValue<String, int, String> chained2 = (() { final _obj = ChainedTransformerValue<String, int, String>(); ChainedTransformer_new(_obj, strToInt, intToStr); return _obj; })();
  print('chained(" 99 "): ${(chained2.vptr['transform'] as Function)(chained2, ' 99 ')}');
  print('\n--- 9. 单例 Registry ---');
  final RegistryValue reg1 = Registry_new();
  final RegistryValue reg2 = Registry_new();
  print('same instance: ${identical(reg1, reg2)}');
  (reg1.vptr['register'] as void Function(RegistryValue, String, dynamic))(reg1, 'name', 'Dart');
  (reg1.vptr['register'] as void Function(RegistryValue, String, dynamic))(reg1, 'version', 3);
  print('registry: ${reg1}');
  print('lookup name: ${(reg2.vptr['lookup'] as dynamic Function(RegistryValue, String))(reg2, 'name')}');
  print('keys: ${(reg1.vptr['get_keys'] as List<String> Function(RegistryValue))(reg1)}');
  (reg1.vptr['clear'] as void Function(RegistryValue))(reg1);
  print('\n--- 10. 集合操作链 ---');
  final List<Map<String, Object>> records = <Map<String, Object>>[<String, Object>{'name': 'Alice', 'score': 95}, <String, Object>{'name': 'Bob', 'score': 72}, <String, Object>{'name': 'Carol', 'score': 88}, <String, Object>{'name': 'Dave', 'score': 45}, <String, Object>{'name': 'Eve', 'score': 91}, <String, Object>{'name': 'Frank', 'score': 63}];
  final List<Map<String, dynamic>> processed = DataProcessor_processRecords(records);
  for (final r in processed) {
    print('  ${r['name']}: ${r['score']} (${r['grade']}, passed=${r['passed']})');
  }
  final Map<String, double> averages = DataProcessor_averageByGrade(processed);
  print('averages: ${averages}');
  print('\n--- 11. late 变量 ---');
  final ExpensiveComputationValue comp = (() { final _obj = ExpensiveComputationValue(); ExpensiveComputation_new(_obj, 42); return _obj; })();
  print('comp: ${comp}');
  print('computedValue: ${comp.computedValue}');
  (comp.vptr['initialize'] as void Function(ExpensiveComputationValue, String))(comp, 'test description');
  print('description: ${comp.description}');
  print('\n--- 12. 局部函数 + 递归 ---');
  print('fibonacci(10): ${MathUtils_fibonacci(10)}');
  print('fibonacci(20): ${MathUtils_fibonacci(20)}');
  print('primeFactors(360): ${MathUtils_primeFactors(360)}');
  print('gcd(48, 18): ${MathUtils_gcd(48, 18)}');
  print('lcm(12, 18): ${MathUtils_lcm(12, 18)}');
  print('\n--- 13. 多重 implements ---');
  final List<ScoreValue> scores = <ScoreValue>[(() { final _obj = ScoreValue(); Score_new(_obj, 'Math', 90); return _obj; })(), (() { final _obj = ScoreValue(); Score_new(_obj, 'English', 75); return _obj; })(), (() { final _obj = WeightedScoreValue(); WeightedScore_new(_obj, 'Physics', 85, 1.5); return _obj; })(), (() { final _obj = WeightedScoreValue(); WeightedScore_new(_obj, 'Art', 95, 0.5); return _obj; })()];
  for (final s in scores) {
    print('  ${(s.vptr['prettyPrint'] as Function)(s)}');
  }
  final WeightedScoreValue ws1 = (scores[2] as WeightedScoreValue);
  final WeightedScoreValue ws2 = (scores[3] as WeightedScoreValue);
  print('physics > art (weighted): ${(ws1.vptr['isGreaterThan'] as Function)(ws1, ws2)}');
  print('\n--- 14. 字符串操作 ---');
  print('camelToSnake("helloWorldFoo"): ${TextProcessor_camelToSnake('helloWorldFoo')}');
  print('snakeToCamel("hello_world_foo"): ${TextProcessor_snakeToCamel('hello_world_foo')}');
  final Map<String, int> freq = TextProcessor_wordFrequency('the quick brown fox jumps over the lazy fox');
  print('word frequency: ${freq}');
  print('truncate: ${TextProcessor_truncate('Hello, World! This is a long string.', 20)}');
  print('\n--- 15. async 链 ---');
  final String asyncResult = await asyncTransform(5);
  print('asyncTransform(5): ${asyncResult}');
  final List<int> asyncSeq = await asyncSequence(5);
  print('asyncSequence(5): ${asyncSeq}');
  print('\n--- 16. 增强枚举 ---');
  for (final s in const [Season.spring, Season.summer, Season.autumn, Season.winter]) {
    print('  ${s} → ${Season_get_displayName(s)}, next=${Season_get_displayName(Season_get_next(s))}, warm=${Season_get_isWarm(s)}');
  }
  print('\n--- 17. 嵌套 Map 操作 ---');
  final Map<String, Object> base = <String, Object>{'a': 1, 'b': <String, int>{'x': 10, 'y': 20}, 'c': 3};
  final Map<String, Object> overlay = <String, Object>{'b': <String, int>{'y': 99, 'z': 30}, 'd': 4};
  final dynamic merged = JsonLikeProcessor_deepMerge(base, overlay);
  print('deepMerge: ${merged}');
  final Map<String, Object> nested = <String, Object>{'user': <String, Object>{'name': 'Alice', 'address': <String, String>{'city': 'NYC', 'zip': '10001'}}, 'role': 'admin'};
  print('flattenKeys: ${JsonLikeProcessor_flattenKeys(nested)}');
  print('\n--- 18. 扩展方法 ---');
  print('7.isPrime: ${IntMathExtension_get_isPrime(7)}');
  print('12.isPrime: ${IntMathExtension_get_isPrime(12)}');
  print('5.factorial: ${IntMathExtension_get_factorial(5)}');
  print('12345.digits: ${IntMathExtension_get_digits(12345)}');
  final List<int> nums = <int>[10, 20, 30, 40, 50];
  print('sum: ${IterableStats_get_sum(nums)}, avg: ${IterableStats_get_average(nums)}, max: ${IterableStats_get_max(nums)}, min: ${IterableStats_get_min(nums)}');
  print('\n--- 19. Matrix2D ---');
  final Matrix2DValue m1 = (() { final _obj = Matrix2DValue(); Matrix2D_new(_obj, <List<double>>[<double>[1.0, 2.0], <double>[3.0, 4.0]]); return _obj; })();
  final Matrix2DValue m2 = (() { final _obj = Matrix2DValue(); Matrix2D_new_identity(_obj, 2); return _obj; })();
  print('m1: ${m1}');
  print('m2 (identity): ${m2}');
  print('m1 + m2: ${(m1.vptr['operatorPlus'] as Matrix2DValue Function(Matrix2DValue, Matrix2DValue))(m1, m2)}');
  print('m1 * m2: ${(m1.vptr['operatorStar'] as Matrix2DValue Function(Matrix2DValue, Matrix2DValue))(m1, m2)}');
  print('m1 trace: ${(m1.vptr['get_trace'] as double Function(Matrix2DValue))(m1)}');
  final Matrix2DValue m3 = (() { final _obj = Matrix2DValue(); Matrix2D_new_zeros(_obj, 2, 3); return _obj; })();
  print('zeros(2,3): ${m3}');
  print('\n--- 20. 综合 mixin + 抽象类 ---');
  final ProductValue product = (() { final _obj = ProductValue(); Product_new(_obj, 'P001', 'Widget', 9.99); return _obj; })();
  (product.vptr['audit'] as Function)(product, 'created');
  (product.vptr['audit'] as Function)(product, 'priced');
  (product.vptr['markCached'] as Function)(product);
  print('product: ${product}');
  print('auditLog: ${(product.vptr['get_auditLog'] as List<String> Function(ProductValue))(product)}');
  (product.vptr['markDirty'] as Function)(product);
  print('after markDirty: ${(product.vptr['get_cacheStatus'] as String Function(ProductValue))(product)}');
  print('\n=== 所有高级语法测试通过 ✅ ===');
}

class ClosureEnv_anon_0 {
  int cols;
  ClosureEnv_anon_0(this.cols);
  List<double> call(int _) => ClosureEnv_anon_0_call(this, _);
}
List<double> ClosureEnv_anon_0_call(ClosureEnv_anon_0 env, int _) {
  return List.filled(env.cols, 0.0);
}

class ClosureEnv_ClosureEnv_anon_1_2 {
  IntBox i;
  ClosureEnv_ClosureEnv_anon_1_2(this.i);
  double call(int j) => ClosureEnv_ClosureEnv_anon_1_2_call(this, j);
}
double ClosureEnv_ClosureEnv_anon_1_2_call(ClosureEnv_ClosureEnv_anon_1_2 env, int j) {
  return ((env.i.value == j) ? 1.0 : 0.0);
}

class ClosureEnv_anon_1 {
  int size;
  ClosureEnv_anon_1(this.size);
  List<double> call(int i_raw) => ClosureEnv_anon_1_call(this, i_raw);
}
List<double> ClosureEnv_anon_1_call(ClosureEnv_anon_1 env, int i_raw) {
  IntBox i = IntBox(i_raw);
  return List.generate(env.size, ClosureEnv_ClosureEnv_anon_1_2(i).call);
}

class ClosureEnv_makeCounter_3 {
  IntBox current;
  int step;
  ClosureEnv_makeCounter_3(this.current, this.step);
  int call() => ClosureEnv_makeCounter_3_call(this);
}
int ClosureEnv_makeCounter_3_call(ClosureEnv_makeCounter_3 env) {
    env.current.value = (env.current.value + env.step);
    return env.current.value;
  }

class ClosureEnv_ClosureEnv_makeAccumulator_4_5 {
  IntBox snapshot;
  IntBox total;
  ClosureEnv_ClosureEnv_makeAccumulator_4_5(this.snapshot, this.total);
  String call() => ClosureEnv_ClosureEnv_makeAccumulator_4_5_call(this);
}
String ClosureEnv_ClosureEnv_makeAccumulator_4_5_call(ClosureEnv_ClosureEnv_makeAccumulator_4_5 env) {
  return 'accumulated: ${env.snapshot.value} (current total: ${env.total.value})';
}

class ClosureEnv_makeAccumulator_4 {
  IntBox total;
  ClosureEnv_makeAccumulator_4(this.total);
  String Function() call(int amount) => ClosureEnv_makeAccumulator_4_call(this, amount);
}
String Function() ClosureEnv_makeAccumulator_4_call(ClosureEnv_makeAccumulator_4 env, int amount) {
    env.total.value = (env.total.value + amount);
    IntBox snapshot = IntBox(env.total.value);
    return ClosureEnv_ClosureEnv_makeAccumulator_4_5(snapshot, env.total).call;
  }

class ClosureEnv_makeClosureList_6 {
  int i;
  ClosureEnv_makeClosureList_6(this.i);
  String call() => ClosureEnv_makeClosureList_6_call(this);
}
String ClosureEnv_makeClosureList_6_call(ClosureEnv_makeClosureList_6 env) {
  return 'closure_${env.i}';
}

class ClosureEnv_composeFunc_7<C, B, A> {
  ObjectBox<C Function(B)> funcBC;
  ObjectBox<B Function(A)> funcAB;
  ClosureEnv_composeFunc_7(this.funcBC, this.funcAB);
  C call(A a) => ClosureEnv_composeFunc_7_call<C, B, A>(this, a);
}
C ClosureEnv_composeFunc_7_call<C, B, A>(ClosureEnv_composeFunc_7<C, B, A> env, A a) {
  return env.funcBC.value(env.funcAB.value(a));
}

class ClosureEnv_ClosureEnv_curry_8_9<C, A, B> {
  ObjectBox<C Function(A, B)> biFunc;
  ObjectBox<A> a;
  ClosureEnv_ClosureEnv_curry_8_9(this.biFunc, this.a);
  C call(B b) => ClosureEnv_ClosureEnv_curry_8_9_call<C, A, B>(this, b);
}
C ClosureEnv_ClosureEnv_curry_8_9_call<C, A, B>(ClosureEnv_ClosureEnv_curry_8_9<C, A, B> env, B b) {
  return env.biFunc.value(env.a.value, b);
}

class ClosureEnv_curry_8<C, A, B> {
  ObjectBox<C Function(A, B)> biFunc;
  ClosureEnv_curry_8(this.biFunc);
  C Function(B) call(A a_raw) => ClosureEnv_curry_8_call<C, A, B>(this, a_raw);
}
C Function(B) ClosureEnv_curry_8_call<C, A, B>(ClosureEnv_curry_8<C, A, B> env, A a_raw) {
  ObjectBox<A> a = ObjectBox<A>(a_raw);
  return ClosureEnv_ClosureEnv_curry_8_9(env.biFunc, a).call;
}

class ClosureEnv_memoize_10<A, B> {
  ObjectBox<Map<A, B>> cache;
  ObjectBox<B Function(A)> func;
  ClosureEnv_memoize_10(this.cache, this.func);
  B call(A arg) => ClosureEnv_memoize_10_call<A, B>(this, arg);
}
B ClosureEnv_memoize_10_call<A, B>(ClosureEnv_memoize_10<A, B> env, A arg) {
    if (env.cache.value.containsKey(arg))     return (env.cache.value[arg] as B);
    final B result = env.func.value(arg);
    env.cache.value[arg] = result;
    return result;
  }


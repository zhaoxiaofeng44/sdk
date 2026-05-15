import 'package:dart2cpp/restorer/runtime_classes.dart';

typedef UnaryFunc<A, B> = B Function(A);

class TreeNodeValue<T> extends VPtr {
  late T value;
  late TreeNodeValue<T>? left;
  late TreeNodeValue<T>? right;
}

TreeNodeValue<T> TreeNode_new<T>(dynamic this__, T value, [TreeNodeValue<T>? left = null, TreeNodeValue<T>? right = null]) {
  final this_ = this__ as TreeNodeValue<T>;
  this_.vptr['preorder'] = TreeNode_preorder<T>;
  this_.vptr['inorder'] = TreeNode_inorder<T>;
  this_.vptr['get_depth'] = TreeNode_get_depth<T>;
  this_.vptr['map_String'] = TreeNode_map<T, String>;
  this_.vptr['toString'] = TreeNode_toString<T>;
  this_.value = value;
  this_.left = left;
  this_.right = right;
  return this_;
}

List<T> TreeNode_preorder<T>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final List<T> result = <T>[this_.value];
  if (!((this_.left == null)))   result.addAll((this_.left!.vptr['preorder'] as List<T> Function(dynamic))(this_.left!));
  if (!((this_.right == null)))   result.addAll((this_.right!.vptr['preorder'] as List<T> Function(dynamic))(this_.right!));
  return result;
}

List<T> TreeNode_inorder<T>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final List<T> result = <T>[];
  if (!((this_.left == null)))   result.addAll((this_.left!.vptr['inorder'] as List<T> Function(dynamic))(this_.left!));
  result.add(this_.value);
  if (!((this_.right == null)))   result.addAll((this_.right!.vptr['inorder'] as List<T> Function(dynamic))(this_.right!));
  return result;
}

int TreeNode_get_depth<T>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final int leftDepth = ((() { final _let1 = this_.left; return (_let1 == null) ? null : (_let1.vptr['get_depth'] as int Function(dynamic))(_let1); })() ?? 0);
  final int rightDepth = ((() { final _let3 = this_.right; return (_let3 == null) ? null : (_let3.vptr['get_depth'] as int Function(dynamic))(_let3); })() ?? 0);
  return (1 + ((leftDepth > rightDepth) ? leftDepth : rightDepth));
}

TreeNodeValue<R> TreeNode_map<T, R>(dynamic this__, R Function(T) transform) {
  final this_ = this__ as TreeNodeValue<T>;
  return TreeNode_new<R>(TreeNodeValue<R>(), transform(this_.value), (() { final _let4 = this_.left; return (_let4 == null) ? null : TreeNode_map<T, R>(_let4, transform); })(), (() { final _let5 = this_.right; return (_let5 == null) ? null : TreeNode_map<T, R>(_let5, transform); })());
}

String TreeNode_toString<T>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  return 'TreeNode(${this_.value})';
}


class LinkedNodeValue<T> extends VPtr {
  late T data;
  late LinkedNodeValue<T>? next;
}

LinkedNodeValue<T> LinkedNode_new<T>(dynamic this__, T data, [LinkedNodeValue<T>? next = null]) {
  final this_ = this__ as LinkedNodeValue<T>;
  this_.vptr['reversed'] = LinkedNode_reversed<T>;
  this_.vptr['toList'] = LinkedNode_toList<T>;
  this_.vptr['get_length'] = LinkedNode_get_length<T>;
  this_.vptr['toString'] = LinkedNode_toString<T>;
  this_.data = data;
  this_.next = next;
  return this_;
}

LinkedNodeValue<T> LinkedNode_reversed<T>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  if ((this_.next == null))   return LinkedNode_new<T>(LinkedNodeValue<T>(), this_.data);
  final LinkedNodeValue<T> rev = (this_.next!.vptr['reversed'] as LinkedNodeValue<T> Function(dynamic))(this_.next!);
  LinkedNodeValue<T> tail = rev;
  while (!((tail.next == null))) {
    tail = tail.next!;
  }
  tail.next = LinkedNode_new<T>(LinkedNodeValue<T>(), this_.data);
  return rev;
}

List<T> LinkedNode_toList<T>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  final List<T> result = <T>[this_.data];
  LinkedNodeValue<T>? current = this_.next;
  while (!((current == null))) {
    result.add(current!.data);
    current = current!.next;
  }
  return result;
}

int LinkedNode_get_length<T>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  int count = 1;
  LinkedNodeValue<T>? current = this_.next;
  while (!((current == null))) {
    count = (count + 1);
    current = current!.next;
  }
  return count;
}

String LinkedNode_toString<T>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  return 'LinkedNode(${(this_.vptr['toList'] as List<T> Function(dynamic))(this_).join(' -> ')})';
}


class EitherValue<L, R> extends VPtr {
  late L? _left;
  late R? _right;
  late bool _isRight;
}

EitherValue<L, R> Either_new_left<L, R>(dynamic this__, L value) {
  final this_ = this__ as EitherValue<L, R>;
  this_.vptr['get_isLeft'] = Either_get_isLeft<L, R>;
  this_.vptr['get_isRight'] = Either_get_isRight<L, R>;
  this_.vptr['get_leftValue'] = Either_get_leftValue<L, R>;
  this_.vptr['get_rightValue'] = Either_get_rightValue<L, R>;
  this_.vptr['fold_String'] = Either_fold<L, R, String>;
  this_.vptr['mapRight_int'] = Either_mapRight<L, R, int>;
  this_.vptr['flatMap_dynamic'] = Either_flatMap<L, R, dynamic>;
  this_.vptr['toString'] = Either_toString<L, R>;
  this_._left = value;
  this_._right = null;
  this_._isRight = false;
  return this_;
}

EitherValue<L, R> Either_new_right<L, R>(dynamic this__, R value) {
  final this_ = this__ as EitherValue<L, R>;
  this_.vptr['get_isLeft'] = Either_get_isLeft<L, R>;
  this_.vptr['get_isRight'] = Either_get_isRight<L, R>;
  this_.vptr['get_leftValue'] = Either_get_leftValue<L, R>;
  this_.vptr['get_rightValue'] = Either_get_rightValue<L, R>;
  this_.vptr['fold_String'] = Either_fold<L, R, String>;
  this_.vptr['mapRight_int'] = Either_mapRight<L, R, int>;
  this_.vptr['flatMap_dynamic'] = Either_flatMap<L, R, dynamic>;
  this_.vptr['toString'] = Either_toString<L, R>;
  this_._left = null;
  this_._right = value;
  this_._isRight = true;
  return this_;
}

bool Either_get_isLeft<L, R>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  return !(this_._isRight);
}

bool Either_get_isRight<L, R>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  return this_._isRight;
}

L Either_get_leftValue<L, R>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (!((this_.vptr['get_isLeft'] as bool Function(dynamic))(this_)))   throw StateError('Not a left value');
  return (this_._left as L);
}

R Either_get_rightValue<L, R>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (!((this_.vptr['get_isRight'] as bool Function(dynamic))(this_)))   throw StateError('Not a right value');
  return (this_._right as R);
}

T Either_fold<L, R, T>(dynamic this__, T Function(L) onLeft, T Function(R) onRight) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return onRight((this_._right as R));
  return onLeft((this_._left as L));
}

EitherValue<L, R2> Either_mapRight<L, R, R2>(dynamic this__, R2 Function(R) transform) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return Either_new_right<L, R2>(EitherValue<L, R2>(), transform((this_._right as R)));
  return Either_new_left<L, R2>(EitherValue<L, R2>(), (this_._left as L));
}

EitherValue<L, R2> Either_flatMap<L, R, R2>(dynamic this__, EitherValue<L, R2> Function(R) transform) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return transform((this_._right as R));
  return Either_new_left<L, R2>(EitherValue<L, R2>(), (this_._left as L));
}

String Either_toString<L, R>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return 'Right(${this_._right})';
  return 'Left(${this_._left})';
}


// mixin Serializable → static functions for delegation
String Serializable_serialize(dynamic this__) {
  final this_ = this__;
  final Map<String, dynamic> map = (this_.vptr['toMap'] as Map<String, dynamic> Function(dynamic))(this_);
  final String entries = map.entries.map((MapEntry<String, dynamic> e) => '${e.key}=${e.value}').join(', ');
  return '{${entries}}';
}


// mixin Validatable → static functions for delegation
bool Validatable_get_isValid(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['validate'] as List<String> Function(dynamic))(this_).isEmpty;
}

String Validatable_get_validationSummary(dynamic this__) {
  final this_ = this__;
  final List<String> errors = (this_.vptr['validate'] as List<String> Function(dynamic))(this_);
  if (errors.isEmpty)   return 'valid';
  return 'invalid: ${errors.join('; ')}';
}


// mixin Copyable → static functions for delegation

class UserProfileValue extends UserProfile_Object_Serializable_ValidatableValue {
  late String name;
  late String email;
  late int age;
}

UserProfileValue UserProfile_new(dynamic this__, String name, String email, int age) {
  final this_ = this__ as UserProfileValue;
  UserProfile_Object_Serializable_Validatable_init(this_);
  this_.vptr['toMap'] = UserProfile_toMap;
  this_.vptr['serialize'] = UserProfile_serialize;
  this_.vptr['validate'] = UserProfile_validate;
  this_.vptr['get_isValid'] = UserProfile_get_isValid;
  this_.vptr['get_validationSummary'] = UserProfile_get_validationSummary;
  this_.vptr['toString'] = UserProfile_toString;
  this_.name = name;
  this_.email = email;
  this_.age = age;
  return this_;
}

Map<String, dynamic> UserProfile_toMap(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  return <String, dynamic>{'name': this_.name, 'email': this_.email, 'age': this_.age};
}

List<String> UserProfile_validate(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  final List<String> errors = <String>[];
  if (this_.name.isEmpty)   errors.add('name is empty');
  if (!(this_.email.contains('@')))   errors.add('invalid email');
  if (((this_.age < 0) || (this_.age > 150)))   errors.add('invalid age');
  return errors;
}

String UserProfile_toString(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  return 'UserProfile(${this_.name}, ${this_.email}, ${this_.age})';
}

String UserProfile_serialize(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  return Serializable_serialize(this_);
}

bool UserProfile_get_isValid(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  return Validatable_get_isValid(this_);
}

String UserProfile_get_validationSummary(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  return Validatable_get_validationSummary(this_);
}


class DataTransformerValue<TInput, TOutput> extends VPtr {
}

DataTransformerValue<TInput, TOutput> DataTransformer_new<TInput, TOutput>(dynamic this__) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  this_.vptr['transform'] = DataTransformer_transform<TInput, TOutput>;
  this_.vptr['preValidate'] = DataTransformer_preValidate<TInput, TOutput>;
  this_.vptr['process'] = DataTransformer_process<TInput, TOutput>;
  this_.vptr['postProcess'] = DataTransformer_postProcess<TInput, TOutput>;
  return this_;
}

TOutput DataTransformer_transform<TInput, TOutput>(dynamic this__, TInput input) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  final TInput validated = (this_.vptr['preValidate'] as TInput Function(dynamic, TInput))(this_, input);
  final TOutput processed = (this_.vptr['process'] as TOutput Function(dynamic, TInput))(this_, validated);
  return (this_.vptr['postProcess'] as TOutput Function(dynamic, TOutput))(this_, processed);
}

TInput DataTransformer_preValidate<TInput, TOutput>(dynamic this__, TInput input) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return input;
}

TOutput DataTransformer_process<TInput, TOutput>(dynamic this_, TInput input) {
  throw UnimplementedError('DataTransformer.process is abstract');
}

TOutput DataTransformer_postProcess<TInput, TOutput>(dynamic this__, TOutput output) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return output;
}


class StringToIntTransformerValue extends DataTransformerValue<String, int> {
}

StringToIntTransformerValue StringToIntTransformer_new(dynamic this__) {
  final this_ = this__ as StringToIntTransformerValue;
  DataTransformer_new(this_);
  this_.vptr['transform'] = StringToIntTransformer_transform;
  this_.vptr['preValidate'] = StringToIntTransformer_preValidate;
  this_.vptr['process'] = StringToIntTransformer_process;
  this_.vptr['postProcess'] = StringToIntTransformer_postProcess;
  return this_;
}

String StringToIntTransformer_preValidate(dynamic this__, String input) {
  final this_ = this__ as StringToIntTransformerValue;
  return input.trim();
}

int StringToIntTransformer_process(dynamic this__, String input) {
  final this_ = this__ as StringToIntTransformerValue;
  return int.parse(input);
}

int StringToIntTransformer_transform(dynamic this__, String input) {
  final this_ = this__ as StringToIntTransformerValue;
  return DataTransformer_transform<String, int>(this_, input);
}

int StringToIntTransformer_postProcess(dynamic this__, int output) {
  final this_ = this__ as StringToIntTransformerValue;
  return DataTransformer_postProcess<String, int>(this_, output);
}


class IntToStringTransformerValue extends DataTransformerValue<int, String> {
  late String prefix;
}

IntToStringTransformerValue IntToStringTransformer_new(dynamic this__, [String prefix = '']) {
  final this_ = this__ as IntToStringTransformerValue;
  DataTransformer_new(this_);
  this_.vptr['transform'] = IntToStringTransformer_transform;
  this_.vptr['preValidate'] = IntToStringTransformer_preValidate;
  this_.vptr['process'] = IntToStringTransformer_process;
  this_.vptr['postProcess'] = IntToStringTransformer_postProcess;
  this_.prefix = prefix;
  return this_;
}

String IntToStringTransformer_process(dynamic this__, int input) {
  final this_ = this__ as IntToStringTransformerValue;
  return '${this_.prefix}${input.toString()}';
}

String IntToStringTransformer_postProcess(dynamic this__, String output) {
  final this_ = this__ as IntToStringTransformerValue;
  return output.toUpperCase();
}

String IntToStringTransformer_transform(dynamic this__, int input) {
  final this_ = this__ as IntToStringTransformerValue;
  return DataTransformer_transform<int, String>(this_, input);
}

int IntToStringTransformer_preValidate(dynamic this__, int input) {
  final this_ = this__ as IntToStringTransformerValue;
  return DataTransformer_preValidate<int, String>(this_, input);
}


class ChainedTransformerValue<A, B, C> extends DataTransformerValue<A, C> {
  late DataTransformerValue<A, B> first;
  late DataTransformerValue<B, C> second;
}

ChainedTransformerValue<A, B, C> ChainedTransformer_new<A, B, C>(dynamic this__, DataTransformerValue<A, B> first, DataTransformerValue<B, C> second) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  DataTransformer_new(this_);
  this_.vptr['transform'] = ChainedTransformer_transform<A, B, C>;
  this_.vptr['preValidate'] = ChainedTransformer_preValidate<A, B, C>;
  this_.vptr['process'] = ChainedTransformer_process<A, B, C>;
  this_.vptr['postProcess'] = ChainedTransformer_postProcess<A, B, C>;
  this_.first = first;
  this_.second = second;
  return this_;
}

C ChainedTransformer_process<A, B, C>(dynamic this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  final B intermediate = (this_.first.vptr['transform'] as B Function(dynamic, A))(this_.first, input);
  return (this_.second.vptr['transform'] as C Function(dynamic, B))(this_.second, intermediate);
}

C ChainedTransformer_transform<A, B, C>(dynamic this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  return DataTransformer_transform<A, C>(this_, input);
}

A ChainedTransformer_preValidate<A, B, C>(dynamic this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  return DataTransformer_preValidate<A, C>(this_, input);
}

C ChainedTransformer_postProcess<A, B, C>(dynamic this__, C output) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  return DataTransformer_postProcess<A, C>(this_, output);
}


class RegistryValue extends VPtr {
  late Map<String, dynamic> _store;
  late int _accessCount;
}

final RegistryValue Registry__instance = Registry_new__internal(RegistryValue());
RegistryValue Registry_new__internal(dynamic this__) {
  final this_ = this__ as RegistryValue;
  this_.vptr['register'] = Registry_register;
  this_.vptr['lookup'] = Registry_lookup;
  this_.vptr['contains'] = Registry_contains;
  this_.vptr['get_size'] = Registry_get_size;
  this_.vptr['get_accessCount'] = Registry_get_accessCount;
  this_.vptr['get_keys'] = Registry_get_keys;
  this_.vptr['clear'] = Registry_clear;
  this_.vptr['toString'] = Registry_toString;
  this_._store = <String, dynamic>{};
  this_._accessCount = 0;
  return this_;
}

RegistryValue Registry_new() {
  return Registry__instance;
}

void Registry_register(dynamic this__, String key, dynamic value) {
  final this_ = this__ as RegistryValue;
  this_._store[key] = value;
  this_._accessCount = (this_._accessCount + 1);
}

dynamic Registry_lookup(dynamic this__, String key) {
  final this_ = this__ as RegistryValue;
  this_._accessCount = (this_._accessCount + 1);
  return this_._store[key];
}

bool Registry_contains(dynamic this__, String key) {
  final this_ = this__ as RegistryValue;
  return this_._store.containsKey(key);
}

int Registry_get_size(dynamic this__) {
  final this_ = this__ as RegistryValue;
  return this_._store.length;
}

int Registry_get_accessCount(dynamic this__) {
  final this_ = this__ as RegistryValue;
  return this_._accessCount;
}

List<String> Registry_get_keys(dynamic this__) {
  final this_ = this__ as RegistryValue;
  return (this_._store.keys.toList()..sort());
}

void Registry_clear(dynamic this__) {
  final this_ = this__ as RegistryValue;
  this_._store.clear();
  this_._accessCount = 0;
}

String Registry_toString(dynamic this__) {
  final this_ = this__ as RegistryValue;
  return 'Registry(size=${(this_.vptr['get_size'] as int Function(dynamic))(this_)}, accesses=${(this_.vptr['get_accessCount'] as int Function(dynamic))(this_)})';
}


class DataProcessorValue extends VPtr {
}

DataProcessorValue DataProcessor_new(dynamic this__) {
  final this_ = this__ as DataProcessorValue;
  return this_;
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

ExpensiveComputationValue ExpensiveComputation_new(dynamic this__, int seed) {
  final this_ = this__ as ExpensiveComputationValue;
  this_.vptr['initialize'] = ExpensiveComputation_initialize;
  this_.vptr['toString'] = ExpensiveComputation_toString;
  this_.seed = seed;
  this_.computedValue = ExpensiveComputation__computeExpensive(this_);
  return this_;
}

int ExpensiveComputation__computeExpensive(dynamic this__) {
  final this_ = this__ as ExpensiveComputationValue;
  int result = this_.seed;
  for (var i = 0; (i < 10); i = (i + 1)) {
    result = (((result * 31) + 17) % 1000);
  }
  return result;
}

void ExpensiveComputation_initialize(dynamic this__, String desc) {
  final this_ = this__ as ExpensiveComputationValue;
  this_.description = desc;
}

String ExpensiveComputation_toString(dynamic this__) {
  final this_ = this__ as ExpensiveComputationValue;
  return 'ExpensiveComputation(seed=${this_.seed}, computed=${this_.computedValue})';
}


class MathUtilsValue extends VPtr {
}

MathUtilsValue MathUtils_new(dynamic this__) {
  final this_ = this__ as MathUtilsValue;
  return this_;
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

Printable3Value Printable3_new(dynamic this__) {
  final this_ = this__ as Printable3Value;
  this_.vptr['prettyPrint'] = Printable3_prettyPrint;
  return this_;
}

String Printable3_prettyPrint(dynamic this_) {
  throw UnimplementedError('Printable3.prettyPrint is abstract');
}


class ScoreValue extends VPtr implements Printable3Value {
  late String subject;
  late int points;
}

ScoreValue Score_new(dynamic this__, String subject, int points) {
  final this_ = this__ as ScoreValue;
  this_.vptr['prettyPrint'] = Score_prettyPrint;
  this_.vptr['compareTo2'] = Score_compareTo2;
  this_.vptr['isLessThan'] = Score_isLessThan;
  this_.vptr['isGreaterThan'] = Score_isGreaterThan;
  this_.vptr['toString'] = Score_toString;
  this_.subject = subject;
  this_.points = points;
  return this_;
}

int Score_compareTo2(dynamic this__, ScoreValue other) {
  final this_ = this__ as ScoreValue;
  return this_.points.compareTo(other.points);
}

bool Score_isLessThan(dynamic this__, ScoreValue other) {
  final this_ = this__ as ScoreValue;
  return ((this_.vptr['compareTo2'] as int Function(dynamic, ScoreValue))(this_, other) < 0);
}

bool Score_isGreaterThan(dynamic this__, ScoreValue other) {
  final this_ = this__ as ScoreValue;
  return ((this_.vptr['compareTo2'] as int Function(dynamic, ScoreValue))(this_, other) > 0);
}

String Score_prettyPrint(dynamic this__) {
  final this_ = this__ as ScoreValue;
  return '[${this_.subject}: ${this_.points} pts]';
}

String Score_toString(dynamic this__) {
  final this_ = this__ as ScoreValue;
  return 'Score(${this_.subject}, ${this_.points})';
}


class WeightedScoreValue extends ScoreValue {
  late double weight;
}

WeightedScoreValue WeightedScore_new(dynamic this__, String subject, int points, double weight) {
  final this_ = this__ as WeightedScoreValue;
  Score_new(this_, subject, points);
  this_.vptr['prettyPrint'] = WeightedScore_prettyPrint;
  this_.vptr['compareTo2'] = WeightedScore_compareTo2;
  this_.vptr['isLessThan'] = WeightedScore_isLessThan;
  this_.vptr['isGreaterThan'] = WeightedScore_isGreaterThan;
  this_.vptr['toString'] = WeightedScore_toString;
  this_.vptr['get_weightedPoints'] = WeightedScore_get_weightedPoints;
  this_.weight = weight;
  return this_;
}

double WeightedScore_get_weightedPoints(dynamic this__) {
  final this_ = this__ as WeightedScoreValue;
  return (this_.points * this_.weight);
}

int WeightedScore_compareTo2(dynamic this__, ScoreValue other) {
  final this_ = this__ as WeightedScoreValue;
  if ((other is WeightedScoreValue)) {
    return (this_.vptr['get_weightedPoints'] as double Function(dynamic))(this_).compareTo((other.vptr['get_weightedPoints'] as double Function(dynamic))(other));
  }
  return Score_compareTo2(this_, other);
}

String WeightedScore_prettyPrint(dynamic this__) {
  final this_ = this__ as WeightedScoreValue;
  return '[${this_.subject}: ${this_.points} pts × ${this_.weight} = ${(this_.vptr['get_weightedPoints'] as double Function(dynamic))(this_).toStringAsFixed(1)}]';
}

String WeightedScore_toString(dynamic this__) {
  final this_ = this__ as WeightedScoreValue;
  return 'WeightedScore(${this_.subject}, ${this_.points}, w=${this_.weight})';
}

bool WeightedScore_isLessThan(dynamic this__, ScoreValue other) {
  final this_ = this__ as WeightedScoreValue;
  return Score_isLessThan(this_, other);
}

bool WeightedScore_isGreaterThan(dynamic this__, ScoreValue other) {
  final this_ = this__ as WeightedScoreValue;
  return Score_isGreaterThan(this_, other);
}


class TextProcessorValue extends VPtr {
}

TextProcessorValue TextProcessor_new(dynamic this__) {
  final this_ = this__ as TextProcessorValue;
  return this_;
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

JsonLikeProcessorValue JsonLikeProcessor_new(dynamic this__) {
  final this_ = this__ as JsonLikeProcessorValue;
  return this_;
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

Matrix2DValue Matrix2D_new(dynamic this__, List<List<double>> _data) {
  final this_ = this__ as Matrix2DValue;
  this_.vptr['get'] = Matrix2D_get;
  this_.vptr['operatorPlus'] = Matrix2D_operatorPlus;
  this_.vptr['operatorStar'] = Matrix2D_operatorStar;
  this_.vptr['get_trace'] = Matrix2D_get_trace;
  this_.vptr['toString'] = Matrix2D_toString;
  this_._data = _data;
  this_.rows = _data.length;
  this_.cols = (_data.isEmpty ? 0 : _data[0].length);
  return this_;
}

Matrix2DValue Matrix2D_new_zeros(dynamic this__, int rows, int cols) {
  final this_ = this__ as Matrix2DValue;
  this_.vptr['get'] = Matrix2D_get;
  this_.vptr['operatorPlus'] = Matrix2D_operatorPlus;
  this_.vptr['operatorStar'] = Matrix2D_operatorStar;
  this_.vptr['get_trace'] = Matrix2D_get_trace;
  this_.vptr['toString'] = Matrix2D_toString;
  this_.rows = rows;
  this_.cols = cols;
  this_._data = List.generate(rows, ClosureEnv_anon_0(cols).call);
  return this_;
}

Matrix2DValue Matrix2D_new_identity(dynamic this__, int size) {
  final this_ = this__ as Matrix2DValue;
  this_.vptr['get'] = Matrix2D_get;
  this_.vptr['operatorPlus'] = Matrix2D_operatorPlus;
  this_.vptr['operatorStar'] = Matrix2D_operatorStar;
  this_.vptr['get_trace'] = Matrix2D_get_trace;
  this_.vptr['toString'] = Matrix2D_toString;
  this_.rows = size;
  this_.cols = size;
  this_._data = List.generate(size, ClosureEnv_anon_1(size).call);
  return this_;
}

double Matrix2D_get(dynamic this__, int row, int col) {
  final this_ = this__ as Matrix2DValue;
  return this_._data[row][col];
}

Matrix2DValue Matrix2D_operatorPlus(dynamic this__, Matrix2DValue other) {
  final this_ = this__ as Matrix2DValue;
  final Matrix2DValue result = Matrix2D_new_zeros(Matrix2DValue(), this_.rows, this_.cols);
  for (var i = 0; (i < this_.rows); i = (i + 1)) {
    for (var j = 0; (j < this_.cols); j = (j + 1)) {
      result._data[i][j] = (this_._data[i][j] + other._data[i][j]);
    }
  }
  return result;
}

Matrix2DValue Matrix2D_operatorStar(dynamic this__, Matrix2DValue other) {
  final this_ = this__ as Matrix2DValue;
  final Matrix2DValue result = Matrix2D_new_zeros(Matrix2DValue(), this_.rows, other.cols);
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

double Matrix2D_get_trace(dynamic this__) {
  final this_ = this__ as Matrix2DValue;
  double sum = 0.0;
  final int minDim = ((this_.rows < this_.cols) ? this_.rows : this_.cols);
  for (var i = 0; (i < minDim); i = (i + 1)) {
    sum = (sum + this_._data[i][i]);
  }
  return sum;
}

String Matrix2D_toString(dynamic this__) {
  final this_ = this__ as Matrix2DValue;
  final String rowStrings = this_._data.map((List<double> row) => row.map((double v) => v.toStringAsFixed(1)).join(', ')).map((String r) => '[${r}]').join(', ');
  return 'Matrix(${this_.rows}x${this_.cols}: ${rowStrings})';
}


class EntityValue extends VPtr {
}

EntityValue Entity_new(dynamic this__) {
  final this_ = this__ as EntityValue;
  this_.vptr['get_entityId'] = Entity_get_entityId;
  return this_;
}

String Entity_get_entityId(dynamic this_) {
  throw UnimplementedError('Entity.entityId is abstract');
}


// mixin Auditable → static functions for delegation
void Auditable_audit(dynamic this__, String action) {
  final this_ = this__;
  this_._auditLog.add('[${(this_.vptr['get_entityId'] as String Function(dynamic))(this_)}] ${action}');
}

List<String> Auditable_get_auditLog(dynamic this__) {
  final this_ = this__;
  return List.unmodifiable(this_._auditLog);
}


// mixin Cacheable → static functions for delegation
void Cacheable_markDirty(dynamic this__) {
  final this_ = this__;
  this_._isDirty = true;
}

void Cacheable_markCached(dynamic this__) {
  final this_ = this__;
  this_._isDirty = false;
  this_._cachedAt = DateTime.now();
}

bool Cacheable_get_isDirty(dynamic this__) {
  final this_ = this__;
  return this_._isDirty;
}

String Cacheable_get_cacheStatus(dynamic this__) {
  final this_ = this__;
  return (this_._isDirty ? 'dirty' : 'cached');
}


class ProductValue extends Product_Entity_Auditable_CacheableValue {
  late String entityId;
  late String name;
  late double price;
}

ProductValue Product_new(dynamic this__, String entityId, String name, double price) {
  final this_ = this__ as ProductValue;
  Entity_new(this_);
  Product_Entity_Auditable_Cacheable_init(this_);
  this_.vptr['get_entityId'] = Product_get_entityId;
  this_.vptr['audit'] = Product_audit;
  this_.vptr['get_auditLog'] = Product_get_auditLog;
  this_.vptr['markDirty'] = Product_markDirty;
  this_.vptr['markCached'] = Product_markCached;
  this_.vptr['get_isDirty'] = Product_get_isDirty;
  this_.vptr['get_cacheStatus'] = Product_get_cacheStatus;
  this_.vptr['toString'] = Product_toString;
  this_.entityId = entityId;
  this_.name = name;
  this_.price = price;
  this_._auditLog = <String>[];
  this_._cachedAt = null;
  this_._isDirty = true;
  return this_;
}

String Product_toString(dynamic this__) {
  final this_ = this__ as ProductValue;
  return 'Product(${this_.entityId}, ${this_.name}, \$${this_.price}, ${(this_.vptr['get_cacheStatus'] as String Function(dynamic))(this_)}, audits=${this_._auditLog.length})';
}

String Product_get_entityId(dynamic this__) {
  final this_ = this__ as ProductValue;
  return this_.entityId;
}

void Product_audit(dynamic this__, String action) {
  final this_ = this__ as ProductValue;
  Auditable_audit(this_, action);
}

List<String> Product_get_auditLog(dynamic this__) {
  final this_ = this__ as ProductValue;
  return Auditable_get_auditLog(this_);
}

void Product_markDirty(dynamic this__) {
  final this_ = this__ as ProductValue;
  Cacheable_markDirty(this_);
}

void Product_markCached(dynamic this__) {
  final this_ = this__ as ProductValue;
  Cacheable_markCached(this_);
}

bool Product_get_isDirty(dynamic this__) {
  final this_ = this__ as ProductValue;
  return Cacheable_get_isDirty(this_);
}

String Product_get_cacheStatus(dynamic this__) {
  final this_ = this__ as ProductValue;
  return Cacheable_get_cacheStatus(this_);
}


class UserProfile_Object_SerializableValue extends VPtr {
}

void UserProfile_Object_Serializable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['serialize'] = Serializable_serialize;
}


class UserProfile_Object_Serializable_ValidatableValue extends UserProfile_Object_SerializableValue {
}

void UserProfile_Object_Serializable_Validatable_init(dynamic this__) {
  UserProfile_Object_Serializable_init(this__);
  final this_ = this__;
  this_.vptr['get_isValid'] = Validatable_get_isValid;
  this_.vptr['get_validationSummary'] = Validatable_get_validationSummary;
}


class Product_Entity_AuditableValue extends EntityValue {
  late List<String> _auditLog;
}

void Product_Entity_Auditable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['audit'] = Auditable_audit;
  this_.vptr['get_auditLog'] = Auditable_get_auditLog;
}


class Product_Entity_Auditable_CacheableValue extends Product_Entity_AuditableValue {
  late DateTime? _cachedAt;
  late bool _isDirty;
}

void Product_Entity_Auditable_Cacheable_init(dynamic this__) {
  Product_Entity_Auditable_init(this__);
  final this_ = this__;
  this_.vptr['markDirty'] = Cacheable_markDirty;
  this_.vptr['markCached'] = Cacheable_markCached;
  this_.vptr['get_isDirty'] = Cacheable_get_isDirty;
  this_.vptr['get_cacheStatus'] = Cacheable_get_cacheStatus;
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

C Function(A) composeFunc<A, B, C>(C Function(B) funcBC, B Function(A) funcAB) {
  return ClosureEnv_composeFunc_7(funcBC, funcAB).call;
}

C Function(B) Function(A) curry<A, B, C>(C Function(A, B) biFunc) {
  return ClosureEnv_curry_8(biFunc).call;
}

T pipe<T>(T value, List<T Function(T)> transforms) {
  T result = value;
  for (final transform in transforms) {
    result = transform(result);
  }
  return result;
}

B Function(A) memoize<A, B>(B Function(A) func) {
  final Map<A, B> cache = <A, B>{};
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
  final TreeNodeValue<int> tree = TreeNode_new<int>(TreeNodeValue<int>(), 1, TreeNode_new<int>(TreeNodeValue<int>(), 2, TreeNode_new<int>(TreeNodeValue<int>(), 4), TreeNode_new<int>(TreeNodeValue<int>(), 5)), TreeNode_new<int>(TreeNodeValue<int>(), 3, null, TreeNode_new<int>(TreeNodeValue<int>(), 6)));
  print('preorder: ${(tree.vptr['preorder'] as List<int> Function(dynamic))(tree)}');
  print('inorder: ${(tree.vptr['inorder'] as List<int> Function(dynamic))(tree)}');
  print('depth: ${(tree.vptr['get_depth'] as int Function(dynamic))(tree)}');
  final TreeNodeValue<String> strTree = (tree.vptr['map_String'] as TreeNodeValue<String> Function(dynamic, String Function(int)))(tree, (int v) => 'N${v}');
  print('mapped preorder: ${(strTree.vptr['preorder'] as List<String> Function(dynamic))(strTree)}');
  print('\n--- 3. 链表 ---');
  final LinkedNodeValue<int> list = LinkedNode_new<int>(LinkedNodeValue<int>(), 1, LinkedNode_new<int>(LinkedNodeValue<int>(), 2, LinkedNode_new<int>(LinkedNodeValue<int>(), 3, LinkedNode_new<int>(LinkedNodeValue<int>(), 4))));
  print('list: ${list}');
  print('length: ${(list.vptr['get_length'] as int Function(dynamic))(list)}');
  final LinkedNodeValue<int> revList = (list.vptr['reversed'] as LinkedNodeValue<int> Function(dynamic))(list);
  print('reversed: ${revList}');
  print('\n--- 4. Either ---');
  final EitherValue<String, int> right = Either_new_right<String, int>(EitherValue<String, int>(), 42);
  final EitherValue<String, int> left = Either_new_left<String, int>(EitherValue<String, int>(), 'error');
  print('right: ${right}');
  print('left: ${left}');
  print('right.fold: ${(right.vptr['fold_String'] as String Function(dynamic, String Function(String), String Function(int)))(right, (String l) => 'L:${l}', (int r) => 'R:${r}')}');
  print('left.fold: ${(left.vptr['fold_String'] as String Function(dynamic, String Function(String), String Function(int)))(left, (String l) => 'L:${l}', (int r) => 'R:${r}')}');
  final EitherValue<String, int> mapped = (right.vptr['mapRight_int'] as EitherValue<String, int> Function(dynamic, int Function(int)))(right, (int v) => (v * 2));
  print('mapped right: ${mapped}');
  final EitherValue<String, dynamic> chained = (right.vptr['flatMap_dynamic'] as EitherValue<String, dynamic> Function(dynamic, EitherValue<String, dynamic> Function(int)))(right, (int v) => ((v > 10) ? Either_new_right<String, String>(EitherValue<String, String>(), 'big_${v}') : Either_new_left<String, dynamic>(EitherValue<String, dynamic>(), 'too small')));
  print('chained: ${chained}');
  print('\n--- 5. 函数式编程 ---');
  final int Function(int) double2 = (int x) => (x * 2);
  final int Function(int) addOne = (int x) => (x + 1);
  final int Function(int) composed = composeFunc<int, int, int>(addOne, double2);
  print('compose(double, addOne)(5): ${composed(5)}');
  final int Function(int) Function(int) curriedAdd = curry<int, int, int>((int a, int b) => (a + b));
  final int Function(int) add10 = curriedAdd(10);
  print('curriedAdd(10)(5): ${add10(5)}');
  final int piped = pipe<int>(3, <int Function(int)>[(int x) => (x * 2), (int x) => (x + 10), (int x) => (x * x)]);
  print('pipe(3, [*2, +10, ^2]): ${piped}');
  final int Function(int) memoFib = memoize<int, int>((int n) {
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
  final UserProfileValue user1 = UserProfile_new(UserProfileValue(), 'Alice', 'alice@example.com', 25);
  print('user1: ${user1}');
  print('serialize: ${(user1.vptr['serialize'] as String Function(dynamic))(user1)}');
  print('validation: ${(user1.vptr['get_validationSummary'] as String Function(dynamic))(user1)}');
  final UserProfileValue user2 = UserProfile_new(UserProfileValue(), '', 'invalid-email', (-5));
  print('user2 validation: ${(user2.vptr['get_validationSummary'] as String Function(dynamic))(user2)}');
  print('\n--- 8. 模板方法模式 ---');
  final StringToIntTransformerValue strToInt = StringToIntTransformer_new(StringToIntTransformerValue());
  print('strToInt("  42  "): ${(strToInt.vptr['transform'] as int Function(dynamic, String))(strToInt, '  42  ')}');
  final IntToStringTransformerValue intToStr = IntToStringTransformer_new(IntToStringTransformerValue(), 'NUM:');
  print('intToStr(123): ${(intToStr.vptr['transform'] as String Function(dynamic, int))(intToStr, 123)}');
  final ChainedTransformerValue<String, int, String> chained2 = ChainedTransformer_new<String, int, String>(ChainedTransformerValue<String, int, String>(), strToInt, intToStr);
  print('chained(" 99 "): ${(chained2.vptr['transform'] as String Function(dynamic, String))(chained2, ' 99 ')}');
  print('\n--- 9. 单例 Registry ---');
  final RegistryValue reg1 = Registry_new();
  final RegistryValue reg2 = Registry_new();
  print('same instance: ${identical(reg1, reg2)}');
  (reg1.vptr['register'] as void Function(dynamic, String, dynamic))(reg1, 'name', 'Dart');
  (reg1.vptr['register'] as void Function(dynamic, String, dynamic))(reg1, 'version', 3);
  print('registry: ${reg1}');
  print('lookup name: ${(reg2.vptr['lookup'] as dynamic Function(dynamic, String))(reg2, 'name')}');
  print('keys: ${(reg1.vptr['get_keys'] as List<String> Function(dynamic))(reg1)}');
  (reg1.vptr['clear'] as void Function(dynamic))(reg1);
  print('\n--- 10. 集合操作链 ---');
  final List<Map<String, Object>> records = <Map<String, Object>>[<String, Object>{'name': 'Alice', 'score': 95}, <String, Object>{'name': 'Bob', 'score': 72}, <String, Object>{'name': 'Carol', 'score': 88}, <String, Object>{'name': 'Dave', 'score': 45}, <String, Object>{'name': 'Eve', 'score': 91}, <String, Object>{'name': 'Frank', 'score': 63}];
  final List<Map<String, dynamic>> processed = DataProcessor_processRecords(records);
  for (final r in processed) {
    print('  ${r['name']}: ${r['score']} (${r['grade']}, passed=${r['passed']})');
  }
  final Map<String, double> averages = DataProcessor_averageByGrade(processed);
  print('averages: ${averages}');
  print('\n--- 11. late 变量 ---');
  final ExpensiveComputationValue comp = ExpensiveComputation_new(ExpensiveComputationValue(), 42);
  print('comp: ${comp}');
  print('computedValue: ${comp.computedValue}');
  (comp.vptr['initialize'] as void Function(dynamic, String))(comp, 'test description');
  print('description: ${comp.description}');
  print('\n--- 12. 局部函数 + 递归 ---');
  print('fibonacci(10): ${MathUtils_fibonacci(10)}');
  print('fibonacci(20): ${MathUtils_fibonacci(20)}');
  print('primeFactors(360): ${MathUtils_primeFactors(360)}');
  print('gcd(48, 18): ${MathUtils_gcd(48, 18)}');
  print('lcm(12, 18): ${MathUtils_lcm(12, 18)}');
  print('\n--- 13. 多重 implements ---');
  final List<ScoreValue> scores = <ScoreValue>[Score_new(ScoreValue(), 'Math', 90), Score_new(ScoreValue(), 'English', 75), WeightedScore_new(WeightedScoreValue(), 'Physics', 85, 1.5), WeightedScore_new(WeightedScoreValue(), 'Art', 95, 0.5)];
  for (final s in scores) {
    print('  ${(s.vptr['prettyPrint'] as String Function(dynamic))(s)}');
  }
  final WeightedScoreValue ws1 = (scores[2] as WeightedScoreValue);
  final WeightedScoreValue ws2 = (scores[3] as WeightedScoreValue);
  print('physics > art (weighted): ${(ws1.vptr['isGreaterThan'] as bool Function(dynamic, ScoreValue))(ws1, ws2)}');
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
  final Matrix2DValue m1 = Matrix2D_new(Matrix2DValue(), <List<double>>[<double>[1.0, 2.0], <double>[3.0, 4.0]]);
  final Matrix2DValue m2 = Matrix2D_new_identity(Matrix2DValue(), 2);
  print('m1: ${m1}');
  print('m2 (identity): ${m2}');
  print('m1 + m2: ${(m1.vptr['operatorPlus'] as Matrix2DValue Function(dynamic, Matrix2DValue))(m1, m2)}');
  print('m1 * m2: ${(m1.vptr['operatorStar'] as Matrix2DValue Function(dynamic, Matrix2DValue))(m1, m2)}');
  print('m1 trace: ${(m1.vptr['get_trace'] as double Function(dynamic))(m1)}');
  final Matrix2DValue m3 = Matrix2D_new_zeros(Matrix2DValue(), 2, 3);
  print('zeros(2,3): ${m3}');
  print('\n--- 20. 综合 mixin + 抽象类 ---');
  final ProductValue product = Product_new(ProductValue(), 'P001', 'Widget', 9.99);
  (product.vptr['audit'] as void Function(dynamic, String))(product, 'created');
  (product.vptr['audit'] as void Function(dynamic, String))(product, 'priced');
  (product.vptr['markCached'] as void Function(dynamic))(product);
  print('product: ${product}');
  print('auditLog: ${(product.vptr['get_auditLog'] as List<String> Function(dynamic))(product)}');
  (product.vptr['markDirty'] as void Function(dynamic))(product);
  print('after markDirty: ${(product.vptr['get_cacheStatus'] as String Function(dynamic))(product)}');
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
  C Function(B) funcBC;
  B Function(A) funcAB;
  ClosureEnv_composeFunc_7(this.funcBC, this.funcAB);
  C call(A a) => ClosureEnv_composeFunc_7_call<C, B, A>(this, a);
}
C ClosureEnv_composeFunc_7_call<C, B, A>(ClosureEnv_composeFunc_7<C, B, A> env, A a) {
  return env.funcBC(env.funcAB(a));
}

class ClosureEnv_ClosureEnv_curry_8_9<C, A, B> {
  C Function(A, B) biFunc;
  ObjectBox<A> a;
  ClosureEnv_ClosureEnv_curry_8_9(this.biFunc, this.a);
  C call(B b) => ClosureEnv_ClosureEnv_curry_8_9_call<C, A, B>(this, b);
}
C ClosureEnv_ClosureEnv_curry_8_9_call<C, A, B>(ClosureEnv_ClosureEnv_curry_8_9<C, A, B> env, B b) {
  return env.biFunc(env.a.value, b);
}

class ClosureEnv_curry_8<C, A, B> {
  C Function(A, B) biFunc;
  ClosureEnv_curry_8(this.biFunc);
  C Function(B) call(A a_raw) => ClosureEnv_curry_8_call<C, A, B>(this, a_raw);
}
C Function(B) ClosureEnv_curry_8_call<C, A, B>(ClosureEnv_curry_8<C, A, B> env, A a_raw) {
  ObjectBox<A> a = ObjectBox<A>(a_raw);
  return ClosureEnv_ClosureEnv_curry_8_9(env.biFunc, a).call;
}

class ClosureEnv_memoize_10<A, B> {
  Map<A, B> cache;
  B Function(A) func;
  ClosureEnv_memoize_10(this.cache, this.func);
  B call(A arg) => ClosureEnv_memoize_10_call<A, B>(this, arg);
}
B ClosureEnv_memoize_10_call<A, B>(ClosureEnv_memoize_10<A, B> env, A arg) {
    if (env.cache.containsKey(arg))     return (env.cache[arg] as B);
    final B result = env.func(arg);
    env.cache[arg] = result;
    return result;
  }


import 'package:dart2cpp/restorer/runtime_classes.dart';

typedef UnaryFunc<A, B> = TypeFunction1<B, A>;

class TreeNodeValue<T> extends VPtr {
  late T value;
  late TreeNodeValue<T>? left;
  late TreeNodeValue<T>? right;
  TreeNodeValue() {
    vptr['preorder'] = _TearOff_TreeNode_preorder<T>();
    vptr['inorder'] = _TearOff_TreeNode_inorder<T>();
    vptr['get_depth'] = _TearOff_TreeNode_get_depth<T>();
    vptr['toString'] = _TearOff_TreeNode_toString<T>();
  }
}

TreeNodeValue<T> TreeNode_new<T>(dynamic this__, T value, [TreeNodeValue<T>? left = null, TreeNodeValue<T>? right = null]) {
  final this_ = this__ as TreeNodeValue<T>;
  this_.vptr['map_String'] = _TearOff_TreeNode_map_String<T>();
  this_.value = value;
  this_.left = left;
  this_.right = right;
  return this_;
}

StaticList<T> TreeNode_preorder<T>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final StaticList<T> result = StaticList<T>.of([this_.value]);
  if (!((this_.left == null)))   result.addAll((this_.left!.vptr['preorder'] as TypeFunction1<StaticList<T>, dynamic>)(this_.left!));
  if (!((this_.right == null)))   result.addAll((this_.right!.vptr['preorder'] as TypeFunction1<StaticList<T>, dynamic>)(this_.right!));
  return result;
}

StaticList<T> TreeNode_inorder<T>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final StaticList<T> result = StaticList<T>();
  if (!((this_.left == null)))   result.addAll((this_.left!.vptr['inorder'] as TypeFunction1<StaticList<T>, dynamic>)(this_.left!));
  result.add(this_.value);
  if (!((this_.right == null)))   result.addAll((this_.right!.vptr['inorder'] as TypeFunction1<StaticList<T>, dynamic>)(this_.right!));
  return result;
}

int TreeNode_get_depth<T>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final int leftDepth = ((() { final _let1 = this_.left; return (_let1 == null) ? null : (_let1.vptr['get_depth'] as TypeFunction1<int, dynamic>)(_let1); })() ?? 0);
  final int rightDepth = ((() { final _let3 = this_.right; return (_let3 == null) ? null : (_let3.vptr['get_depth'] as TypeFunction1<int, dynamic>)(_let3); })() ?? 0);
  return (1 + ((leftDepth > rightDepth) ? leftDepth : rightDepth));
}

TreeNodeValue<R> TreeNode_map<T, R>(dynamic this__, TypeFunction1<R, T> transform) {
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
  LinkedNodeValue() {
    vptr['reversed'] = _TearOff_LinkedNode_reversed<T>();
    vptr['toList'] = _TearOff_LinkedNode_toList<T>();
    vptr['get_length'] = _TearOff_LinkedNode_get_length<T>();
    vptr['toString'] = _TearOff_LinkedNode_toString<T>();
  }
}

LinkedNodeValue<T> LinkedNode_new<T>(dynamic this__, T data, [LinkedNodeValue<T>? next = null]) {
  final this_ = this__ as LinkedNodeValue<T>;
  this_.data = data;
  this_.next = next;
  return this_;
}

LinkedNodeValue<T> LinkedNode_reversed<T>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  if ((this_.next == null))   return LinkedNode_new<T>(LinkedNodeValue<T>(), this_.data);
  final LinkedNodeValue<T> rev = (this_.next!.vptr['reversed'] as TypeFunction1<LinkedNodeValue<T>, dynamic>)(this_.next!);
  LinkedNodeValue<T> tail = rev;
  while (!((tail.next == null))) {
    tail = tail.next!;
  }
  tail.next = LinkedNode_new<T>(LinkedNodeValue<T>(), this_.data);
  return rev;
}

StaticList<T> LinkedNode_toList<T>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  final StaticList<T> result = StaticList<T>.of([this_.data]);
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
  return 'LinkedNode(${(this_.vptr['toList'] as TypeFunction1<StaticList<T>, dynamic>)(this_).join(' -> ')})';
}


class EitherValue<L, R> extends VPtr {
  late L? _left;
  late R? _right;
  late bool _isRight;
  EitherValue() {
    vptr['get_isLeft'] = _TearOff_Either_get_isLeft<L, R>();
    vptr['get_isRight'] = _TearOff_Either_get_isRight<L, R>();
    vptr['get_leftValue'] = _TearOff_Either_get_leftValue<L, R>();
    vptr['get_rightValue'] = _TearOff_Either_get_rightValue<L, R>();
    vptr['toString'] = _TearOff_Either_toString<L, R>();
  }
}

EitherValue<L, R> Either_new_left<L, R>(dynamic this__, L value) {
  final this_ = this__ as EitherValue<L, R>;
  this_.vptr['fold_String'] = _TearOff_Either_fold_String<L, R>();
  this_.vptr['mapRight_int'] = _TearOff_Either_mapRight_int<L, R>();
  this_.vptr['flatMap_dynamic'] = _TearOff_Either_flatMap_dynamic<L, R>();
  this_._left = value;
  this_._right = null;
  this_._isRight = false;
  return this_;
}

EitherValue<L, R> Either_new_right<L, R>(dynamic this__, R value) {
  final this_ = this__ as EitherValue<L, R>;
  this_.vptr['fold_String'] = _TearOff_Either_fold_String<L, R>();
  this_.vptr['mapRight_int'] = _TearOff_Either_mapRight_int<L, R>();
  this_.vptr['flatMap_dynamic'] = _TearOff_Either_flatMap_dynamic<L, R>();
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
  if (!((this_.vptr['get_isLeft'] as TypeFunction1<bool, dynamic>)(this_)))   throw StateError('Not a left value');
  return (this_._left as L);
}

R Either_get_rightValue<L, R>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (!((this_.vptr['get_isRight'] as TypeFunction1<bool, dynamic>)(this_)))   throw StateError('Not a right value');
  return (this_._right as R);
}

T Either_fold<L, R, T>(dynamic this__, TypeFunction1<T, L> onLeft, TypeFunction1<T, R> onRight) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return onRight((this_._right as R));
  return onLeft((this_._left as L));
}

EitherValue<L, R2> Either_mapRight<L, R, R2>(dynamic this__, TypeFunction1<R2, R> transform) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return Either_new_right<L, R2>(EitherValue<L, R2>(), transform((this_._right as R)));
  return Either_new_left<L, R2>(EitherValue<L, R2>(), (this_._left as L));
}

EitherValue<L, R2> Either_flatMap<L, R, R2>(dynamic this__, TypeFunction1<EitherValue<L, R2>, R> transform) {
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
  final StaticMap<String, dynamic> map = StaticMap<String, dynamic>.of((this_.vptr['toMap'] as TypeFunction1<StaticMap<String, dynamic>, dynamic>)(this_));
  final String entries = map.entries.map(ClosureEnv_anon_0()).join(', ');
  return '{${entries}}';
}


// mixin Validatable → static functions for delegation
bool Validatable_get_isValid(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['validate'] as TypeFunction1<StaticList<String>, dynamic>)(this_).isEmpty;
}

String Validatable_get_validationSummary(dynamic this__) {
  final this_ = this__;
  final StaticList<String> errors = StaticList<String>.of((this_.vptr['validate'] as TypeFunction1<StaticList<String>, dynamic>)(this_));
  if (errors.isEmpty)   return 'valid';
  return 'invalid: ${errors.join('; ')}';
}


// mixin Copyable → static functions for delegation

class UserProfileValue extends UserProfile_Object_Serializable_ValidatableValue {
  late String name;
  late String email;
  late int age;
  UserProfileValue() {
    vptr['toMap'] = const _TearOff_UserProfile_toMap();
    vptr['serialize'] = const _TearOff_UserProfile_serialize();
    vptr['validate'] = const _TearOff_UserProfile_validate();
    vptr['get_isValid'] = const _TearOff_UserProfile_get_isValid();
    vptr['get_validationSummary'] = const _TearOff_UserProfile_get_validationSummary();
    vptr['toString'] = const _TearOff_UserProfile_toString();
  }
}

UserProfileValue UserProfile_new(dynamic this__, String name, String email, int age) {
  final this_ = this__ as UserProfileValue;
  this_.name = name;
  this_.email = email;
  this_.age = age;
  return this_;
}

StaticMap<String, dynamic> UserProfile_toMap(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  return StaticMap<String, dynamic>.of({'name': this_.name, 'email': this_.email, 'age': this_.age});
}

StaticList<String> UserProfile_validate(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  final StaticList<String> errors = StaticList<String>();
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
  DataTransformerValue() {
    vptr['transform'] = _TearOff_DataTransformer_transform<TInput, TOutput>();
    vptr['preValidate'] = _TearOff_DataTransformer_preValidate<TInput, TOutput>();
    vptr['process'] = _TearOff_DataTransformer_process<TInput, TOutput>();
    vptr['postProcess'] = _TearOff_DataTransformer_postProcess<TInput, TOutput>();
  }
}

DataTransformerValue<TInput, TOutput> DataTransformer_new<TInput, TOutput>(dynamic this__) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return this_;
}

TOutput DataTransformer_transform<TInput, TOutput>(dynamic this__, TInput input) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  final TInput validated = (this_.vptr['preValidate'] as TypeFunction2<TInput, dynamic, TInput>)(this_, input);
  final TOutput processed = (this_.vptr['process'] as TypeFunction2<TOutput, dynamic, TInput>)(this_, validated);
  return (this_.vptr['postProcess'] as TypeFunction2<TOutput, dynamic, TOutput>)(this_, processed);
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
  StringToIntTransformerValue() {
    vptr['transform'] = const _TearOff_StringToIntTransformer_transform();
    vptr['preValidate'] = const _TearOff_StringToIntTransformer_preValidate();
    vptr['process'] = const _TearOff_StringToIntTransformer_process();
    vptr['postProcess'] = const _TearOff_StringToIntTransformer_postProcess();
  }
}

StringToIntTransformerValue StringToIntTransformer_new(dynamic this__) {
  final this_ = this__ as StringToIntTransformerValue;
  DataTransformer_new<String, int>(this_);
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
  IntToStringTransformerValue() {
    vptr['transform'] = const _TearOff_IntToStringTransformer_transform();
    vptr['preValidate'] = const _TearOff_IntToStringTransformer_preValidate();
    vptr['process'] = const _TearOff_IntToStringTransformer_process();
    vptr['postProcess'] = const _TearOff_IntToStringTransformer_postProcess();
  }
}

IntToStringTransformerValue IntToStringTransformer_new(dynamic this__, [String prefix = '']) {
  final this_ = this__ as IntToStringTransformerValue;
  DataTransformer_new<int, String>(this_);
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
  ChainedTransformerValue() {
    vptr['transform'] = _TearOff_ChainedTransformer_transform<A, B, C>();
    vptr['preValidate'] = _TearOff_ChainedTransformer_preValidate<A, B, C>();
    vptr['process'] = _TearOff_ChainedTransformer_process<A, B, C>();
    vptr['postProcess'] = _TearOff_ChainedTransformer_postProcess<A, B, C>();
  }
}

ChainedTransformerValue<A, B, C> ChainedTransformer_new<A, B, C>(dynamic this__, DataTransformerValue<A, B> first, DataTransformerValue<B, C> second) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  DataTransformer_new<A, C>(this_);
  this_.first = first;
  this_.second = second;
  return this_;
}

C ChainedTransformer_process<A, B, C>(dynamic this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  final B intermediate = (this_.first.vptr['transform'] as TypeFunction2<B, dynamic, A>)(this_.first, input);
  return (this_.second.vptr['transform'] as TypeFunction2<C, dynamic, B>)(this_.second, intermediate);
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
  late StaticMap<String, dynamic> _store;
  late int _accessCount;
  RegistryValue() {
    vptr['register'] = const _TearOff_Registry_register();
    vptr['lookup'] = const _TearOff_Registry_lookup();
    vptr['contains'] = const _TearOff_Registry_contains();
    vptr['get_size'] = const _TearOff_Registry_get_size();
    vptr['get_accessCount'] = const _TearOff_Registry_get_accessCount();
    vptr['get_keys'] = const _TearOff_Registry_get_keys();
    vptr['clear'] = const _TearOff_Registry_clear();
    vptr['toString'] = const _TearOff_Registry_toString();
  }
}

final RegistryValue Registry__instance = Registry_new__internal(RegistryValue());
RegistryValue Registry_new__internal(dynamic this__) {
  final this_ = this__ as RegistryValue;
  this_._store = StaticMap<String, dynamic>.of({});
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

StaticList<String> Registry_get_keys(dynamic this__) {
  final this_ = this__ as RegistryValue;
  return (StaticList.of(this_._store.keys.toList())..sort());
}

void Registry_clear(dynamic this__) {
  final this_ = this__ as RegistryValue;
  this_._store.clear();
  this_._accessCount = 0;
}

String Registry_toString(dynamic this__) {
  final this_ = this__ as RegistryValue;
  return 'Registry(size=${(this_.vptr['get_size'] as TypeFunction1<int, dynamic>)(this_)}, accesses=${(this_.vptr['get_accessCount'] as TypeFunction1<int, dynamic>)(this_)})';
}


class DataProcessorValue extends VPtr {
}

DataProcessorValue DataProcessor_new(dynamic this__) {
  final this_ = this__ as DataProcessorValue;
  return this_;
}

StaticList<StaticMap<String, dynamic>> DataProcessor_processRecords(StaticList<StaticMap<String, dynamic>> records) {
  return (StaticList.of(records.where(ClosureEnv_anon_2()).where(ClosureEnv_anon_3()).map(ClosureEnv_anon_4()).toList())..sort(ClosureEnv_anon_1()));
}

String DataProcessor__scoreToGrade(int score) {
  if ((score >= 90))   return 'A';
  if ((score >= 80))   return 'B';
  if ((score >= 70))   return 'C';
  if ((score >= 60))   return 'D';
  return 'F';
}

StaticMap<String, StaticList<StaticMap<String, dynamic>>> DataProcessor_groupByGrade(StaticList<StaticMap<String, dynamic>> records) {
  final StaticMap<String, StaticList<StaticMap<String, dynamic>>> groups = StaticMap<String, StaticList<StaticMap<String, dynamic>>>.of({});
{
    Iterator<StaticMap<String, dynamic>> sync_for_iterator = records.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final StaticMap<String, dynamic> record = StaticMap<String, dynamic>.of(sync_for_iterator.current);
{
        final String grade = (record['grade'] as String);
        groups.putIfAbsent(grade, ClosureEnv_anon_5());
        groups[grade]!.add(record);
      }
    }
  }
  return groups;
}

StaticMap<String, double> DataProcessor_averageByGrade(StaticList<StaticMap<String, dynamic>> records) {
  final StaticMap<String, StaticList<StaticMap<String, dynamic>>> groups = StaticMap<String, StaticList<StaticMap<String, dynamic>>>.of(DataProcessor_groupByGrade(records));
  return groups.map(ClosureEnv_anon_6());
}


class ExpensiveComputationValue extends VPtr {
  late int seed;
  late int computedValue;
  late String description;
  ExpensiveComputationValue() {
    vptr['initialize'] = const _TearOff_ExpensiveComputation_initialize();
    vptr['toString'] = const _TearOff_ExpensiveComputation_toString();
  }
}

ExpensiveComputationValue ExpensiveComputation_new(dynamic this__, int seed) {
  final this_ = this__ as ExpensiveComputationValue;
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
  final StaticMap<int, int> memo = StaticMap<int, int>.of({});
  int fib(int k) {
    if ((k <= 1))     return k;
    if (memo.containsKey(k))     return memo[k]!;
    final int result = (fib((k - 1)) + fib((k - 2)));
    memo[k] = result;
    return result;
  }

  return fib(n);
}

StaticList<int> MathUtils_primeFactors(int n) {
  final StaticList<int> factors = StaticList<int>();
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
  Printable3Value() {
    vptr['prettyPrint'] = const _TearOff_Printable3_prettyPrint();
  }
}

Printable3Value Printable3_new(dynamic this__) {
  final this_ = this__ as Printable3Value;
  return this_;
}

String Printable3_prettyPrint(dynamic this_) {
  throw UnimplementedError('Printable3.prettyPrint is abstract');
}


class ScoreValue extends VPtr implements Printable3Value {
  late String subject;
  late int points;
  ScoreValue() {
    vptr['prettyPrint'] = const _TearOff_Score_prettyPrint();
    vptr['compareTo2'] = const _TearOff_Score_compareTo2();
    vptr['isLessThan'] = const _TearOff_Score_isLessThan();
    vptr['isGreaterThan'] = const _TearOff_Score_isGreaterThan();
    vptr['toString'] = const _TearOff_Score_toString();
  }
}

ScoreValue Score_new(dynamic this__, String subject, int points) {
  final this_ = this__ as ScoreValue;
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
  return ((this_.vptr['compareTo2'] as TypeFunction2<int, dynamic, ScoreValue>)(this_, other) < 0);
}

bool Score_isGreaterThan(dynamic this__, ScoreValue other) {
  final this_ = this__ as ScoreValue;
  return ((this_.vptr['compareTo2'] as TypeFunction2<int, dynamic, ScoreValue>)(this_, other) > 0);
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
  WeightedScoreValue() {
    vptr['prettyPrint'] = const _TearOff_WeightedScore_prettyPrint();
    vptr['compareTo2'] = const _TearOff_WeightedScore_compareTo2();
    vptr['isLessThan'] = const _TearOff_WeightedScore_isLessThan();
    vptr['isGreaterThan'] = const _TearOff_WeightedScore_isGreaterThan();
    vptr['toString'] = const _TearOff_WeightedScore_toString();
    vptr['get_weightedPoints'] = const _TearOff_WeightedScore_get_weightedPoints();
  }
}

WeightedScoreValue WeightedScore_new(dynamic this__, String subject, int points, double weight) {
  final this_ = this__ as WeightedScoreValue;
  Score_new(this_, subject, points);
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
    return (this_.vptr['get_weightedPoints'] as TypeFunction1<double, dynamic>)(this_).compareTo((other.vptr['get_weightedPoints'] as TypeFunction1<double, dynamic>)(other));
  }
  return Score_compareTo2(this_, other);
}

String WeightedScore_prettyPrint(dynamic this__) {
  final this_ = this__ as WeightedScoreValue;
  return '[${this_.subject}: ${this_.points} pts × ${this_.weight} = ${(this_.vptr['get_weightedPoints'] as TypeFunction1<double, dynamic>)(this_).toStringAsFixed(1)}]';
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
  final StaticList<String> parts = StaticList<String>.of(input.split('_'));
  if (parts.isEmpty)   return input;
  final String first = parts[0];
  final String rest = parts.skip(1).map(ClosureEnv_anon_8()).join();
  return '${first}${rest}';
}

StaticMap<String, int> TextProcessor_wordFrequency(String text) {
  final StaticList<String> words = StaticList.of(text.toLowerCase().replaceAll(RegExp('[^a-z\\s]'), '').split(RegExp('\\s+')).where(ClosureEnv_anon_9()).toList());
  final StaticMap<String, int> freq = StaticMap<String, int>.of({});
{
    Iterator<String> sync_for_iterator = words.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final String word = sync_for_iterator.current;
{
        freq[word] = ((freq[word] ?? 0) + 1);
      }
    }
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

dynamic JsonLikeProcessor_deepMerge(StaticMap<String, dynamic> base, StaticMap<String, dynamic> overlay) {
  final StaticMap<String, dynamic> result = StaticMap<String, dynamic>.from(base);
{
    Iterator<String> sync_for_iterator = overlay.keys.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final String key = sync_for_iterator.current;
{
        if (((result.containsKey(key) && (result[key] is StaticMap<String, dynamic>)) && (overlay[key] is StaticMap<String, dynamic>))) {
          result[key] = JsonLikeProcessor_deepMerge((result[key] as StaticMap<String, dynamic>), (overlay[key] as StaticMap<String, dynamic>));
        }
 else {
          result[key] = overlay[key];
        }
      }
    }
  }
  return result;
}

StaticList<String> JsonLikeProcessor_flattenKeys(StaticMap<String, dynamic> map, {String prefix = ''}) {
  final StaticList<String> keys = StaticList<String>();
{
    Iterator<MapEntry<String, dynamic>> sync_for_iterator = map.entries.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final MapEntry<String, dynamic> entry = sync_for_iterator.current;
{
        final String fullKey = (prefix.isEmpty ? entry.key : '${prefix}.${entry.key}');
        if ((entry.value is StaticMap<String, dynamic>)) {
          keys.addAll(JsonLikeProcessor_flattenKeys((entry.value as StaticMap<String, dynamic>), prefix: fullKey));
        }
 else {
          keys.add(fullKey);
        }
      }
    }
  }
  return (keys..sort());
}


class Matrix2DValue extends VPtr {
  late StaticList<StaticList<double>> _data;
  late int rows;
  late int cols;
  Matrix2DValue() {
    vptr['get'] = const _TearOff_Matrix2D_get();
    vptr['operatorPlus'] = const _TearOff_Matrix2D_operatorPlus();
    vptr['operatorStar'] = const _TearOff_Matrix2D_operatorStar();
    vptr['get_trace'] = const _TearOff_Matrix2D_get_trace();
    vptr['toString'] = const _TearOff_Matrix2D_toString();
  }
}

Matrix2DValue Matrix2D_new(dynamic this__, StaticList<StaticList<double>> _data) {
  final this_ = this__ as Matrix2DValue;
  this_._data = _data;
  this_.rows = _data.length;
  this_.cols = (_data.isEmpty ? 0 : _data[0].length);
  return this_;
}

Matrix2DValue Matrix2D_new_zeros(dynamic this__, int rows, int cols) {
  final this_ = this__ as Matrix2DValue;
  this_.rows = rows;
  this_.cols = cols;
  this_._data = StaticList<StaticList<double>>.generate(rows, ClosureEnv_anon_10(cols));
  return this_;
}

Matrix2DValue Matrix2D_new_identity(dynamic this__, int size) {
  final this_ = this__ as Matrix2DValue;
  this_.rows = size;
  this_.cols = size;
  this_._data = StaticList<StaticList<double>>.generate(size, ClosureEnv_anon_11(size));
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
  final String rowStrings = this_._data.map(ClosureEnv_anon_13()).map(ClosureEnv_anon_15()).join(', ');
  return 'Matrix(${this_.rows}x${this_.cols}: ${rowStrings})';
}


class EntityValue extends VPtr {
  EntityValue() {
    vptr['get_entityId'] = const _TearOff_Entity_get_entityId();
  }
}

EntityValue Entity_new(dynamic this__) {
  final this_ = this__ as EntityValue;
  return this_;
}

String Entity_get_entityId(dynamic this_) {
  throw UnimplementedError('Entity.entityId is abstract');
}


// mixin Auditable → static functions for delegation
void Auditable_audit(dynamic this__, String action) {
  final this_ = this__;
  this_._auditLog.add('[${(this_.vptr['get_entityId'] as TypeFunction1<String, dynamic>)(this_)}] ${action}');
}

StaticList<String> Auditable_get_auditLog(dynamic this__) {
  final this_ = this__;
  return StaticList<String>.unmodifiable(this_._auditLog);
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
  ProductValue() {
    vptr['get_entityId'] = const _TearOff_Product_get_entityId();
    vptr['audit'] = const _TearOff_Product_audit();
    vptr['get_auditLog'] = const _TearOff_Product_get_auditLog();
    vptr['markDirty'] = const _TearOff_Product_markDirty();
    vptr['markCached'] = const _TearOff_Product_markCached();
    vptr['get_isDirty'] = const _TearOff_Product_get_isDirty();
    vptr['get_cacheStatus'] = const _TearOff_Product_get_cacheStatus();
    vptr['toString'] = const _TearOff_Product_toString();
  }
}

ProductValue Product_new(dynamic this__, String entityId, String name, double price) {
  final this_ = this__ as ProductValue;
  Entity_new(this_);
  this_.entityId = entityId;
  this_.name = name;
  this_.price = price;
  this_._auditLog = StaticList<String>();
  this_._cachedAt = null;
  this_._isDirty = true;
  return this_;
}

String Product_toString(dynamic this__) {
  final this_ = this__ as ProductValue;
  return 'Product(${this_.entityId}, ${this_.name}, \$${this_.price}, ${(this_.vptr['get_cacheStatus'] as TypeFunction1<String, dynamic>)(this_)}, audits=${this_._auditLog.length})';
}

String Product_get_entityId(dynamic this__) {
  final this_ = this__ as ProductValue;
  return this_.entityId;
}

void Product_audit(dynamic this__, String action) {
  final this_ = this__ as ProductValue;
  Auditable_audit(this_, action);
}

StaticList<String> Product_get_auditLog(dynamic this__) {
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


class UserProfile_Object_Serializable_ValidatableValue extends UserProfile_Object_SerializableValue {
}


class Product_Entity_AuditableValue extends EntityValue {
  late StaticList<String> _auditLog;
}


class Product_Entity_Auditable_CacheableValue extends Product_Entity_AuditableValue {
  late DateTime? _cachedAt;
  late bool _isDirty;
}


dynamic makeCounter({int start = 0, int step = 1}) {
  IntBox current = IntBox(start);
  return ClosureEnv_makeCounter_16(current, step);
}

dynamic makeAccumulator(int initial) {
  IntBox total = IntBox(initial);
  return ClosureEnv_makeAccumulator_17(total);
}

StaticList<dynamic> makeClosureList(int count) {
  final StaticList<dynamic> closures = StaticList<dynamic>();
  for (var i = 0; (i < count); i = (i + 1)) {
    closures.add(ClosureEnv_makeClosureList_19(i));
  }
  return closures;
}

TypeFunction1<C, A> composeFunc<A, B, C>(TypeFunction1<C, B> funcBC, TypeFunction1<B, A> funcAB) {
  return ClosureEnv_composeFunc_20<C, B, A>(funcBC, funcAB);
}

TypeFunction1<TypeFunction1<C, B>, A> curry<A, B, C>(TypeFunction2<C, A, B> biFunc) {
  return ClosureEnv_curry_21<C, A, B>(biFunc);
}

T pipe<T>(T value, StaticList<TypeFunction1<T, T>> transforms) {
  T result = value;
{
    Iterator<TypeFunction1<T, T>> sync_for_iterator = transforms.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final TypeFunction1<T, T> transform = sync_for_iterator.current;
{
        result = transform(result);
      }
    }
  }
  return result;
}

TypeFunction1<B, A> memoize<A, B>(TypeFunction1<B, A> func) {
  final StaticMap<A, B> cache = StaticMap<A, B>.of({});
  return ClosureEnv_memoize_23<A, B>(cache, func);
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

StaticList<int> parseNumbers(StaticList<String> inputs) {
  final StaticList<int> results = StaticList<int>();
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

Promise<int> asyncAdd(int a, int b) {
  final env = ClosureEnv_asyncAdd_24(a, b);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> asyncTransform(int value) {
  final env = ClosureEnv_asyncTransform_25(value);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<StaticList<int>> asyncSequence(int count) {
  final env = ClosureEnv_asyncSequence_26(count);
  env._promise.setStartCallback(env.call);
  return env._promise;
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

StaticList<int> IntMathExtension_get_digits(final int this_) {
  if ((this_ == 0))   return StaticList<int>.of([0]);
  final StaticList<int> result = StaticList<int>();
  int n = this_.abs();
  while ((n > 0)) {
    result.insert(0, (n % 10));
    n = (n ~/ 10);
  }
  return result;
}

T IterableStats_get_sum<T extends num>(final Iterable<T> this_) {
  return this_.reduce(ClosureEnv_IterableStats_get_sum_27<T>());
}

double IterableStats_get_average<T extends num>(final Iterable<T> this_) {
  return (this_.isEmpty ? 0.0 : (IterableStats_get_sum(this_) / this_.length));
}

T IterableStats_get_max<T extends num>(final Iterable<T> this_) {
  return this_.reduce(ClosureEnv_IterableStats_get_max_28<T>());
}

T IterableStats_get_min<T extends num>(final Iterable<T> this_) {
  return this_.reduce(ClosureEnv_IterableStats_get_min_29<T>());
}

void main() {
  print('=== 高级语法还原测试 ===\n');
  print('--- 1. 嵌套闭包 ---');
  final dynamic counter = makeCounter(start: 5, step: 3);
  print('counter: ${counter()}, ${counter()}, ${counter()}');
  final dynamic acc = makeAccumulator(100);
  final dynamic snap1 = acc(10);
  final dynamic snap2 = acc(20);
  print('snap1: ${snap1.call()}');
  print('snap2: ${snap2.call()}');
  final StaticList<dynamic> closures = StaticList<dynamic>.of(makeClosureList(4));
{
    Iterator<dynamic> sync_for_iterator = closures.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final dynamic cl = sync_for_iterator.current;
{
        print('  ${cl()}');
      }
    }
  }
  print('\n--- 2. 二叉树 ---');
  final TreeNodeValue<int> tree = TreeNode_new<int>(TreeNodeValue<int>(), 1, TreeNode_new<int>(TreeNodeValue<int>(), 2, TreeNode_new<int>(TreeNodeValue<int>(), 4), TreeNode_new<int>(TreeNodeValue<int>(), 5)), TreeNode_new<int>(TreeNodeValue<int>(), 3, null, TreeNode_new<int>(TreeNodeValue<int>(), 6)));
  print('preorder: ${(tree.vptr['preorder'] as TypeFunction1<StaticList<int>, dynamic>)(tree)}');
  print('inorder: ${(tree.vptr['inorder'] as TypeFunction1<StaticList<int>, dynamic>)(tree)}');
  print('depth: ${(tree.vptr['get_depth'] as TypeFunction1<int, dynamic>)(tree)}');
  final TreeNodeValue<String> strTree = (tree.vptr['map_String'] as TypeFunction2<TreeNodeValue<String>, dynamic, TypeFunction1<String, int>>)(tree, ClosureEnv_main_31());
  print('mapped preorder: ${(strTree.vptr['preorder'] as TypeFunction1<StaticList<String>, dynamic>)(strTree)}');
  print('\n--- 3. 链表 ---');
  final LinkedNodeValue<int> list = LinkedNode_new<int>(LinkedNodeValue<int>(), 1, LinkedNode_new<int>(LinkedNodeValue<int>(), 2, LinkedNode_new<int>(LinkedNodeValue<int>(), 3, LinkedNode_new<int>(LinkedNodeValue<int>(), 4))));
  print('list: ${list}');
  print('length: ${(list.vptr['get_length'] as TypeFunction1<int, dynamic>)(list)}');
  final LinkedNodeValue<int> revList = (list.vptr['reversed'] as TypeFunction1<LinkedNodeValue<int>, dynamic>)(list);
  print('reversed: ${revList}');
  print('\n--- 4. Either ---');
  final EitherValue<String, int> right = Either_new_right<String, int>(EitherValue<String, int>(), 42);
  final EitherValue<String, int> left = Either_new_left<String, int>(EitherValue<String, int>(), 'error');
  print('right: ${right}');
  print('left: ${left}');
  print('right.fold: ${(right.vptr['fold_String'] as TypeFunction3<String, dynamic, TypeFunction1<String, String>, TypeFunction1<String, int>>)(right, ClosureEnv_main_34(), ClosureEnv_main_35())}');
  print('left.fold: ${(left.vptr['fold_String'] as TypeFunction3<String, dynamic, TypeFunction1<String, String>, TypeFunction1<String, int>>)(left, ClosureEnv_main_38(), ClosureEnv_main_39())}');
  final EitherValue<String, int> mapped = (right.vptr['mapRight_int'] as TypeFunction2<EitherValue<String, int>, dynamic, TypeFunction1<int, int>>)(right, ClosureEnv_main_41());
  print('mapped right: ${mapped}');
  final EitherValue<String, dynamic> chained = (right.vptr['flatMap_dynamic'] as TypeFunction2<EitherValue<String, dynamic>, dynamic, TypeFunction1<EitherValue<String, dynamic>, int>>)(right, ClosureEnv_main_43());
  print('chained: ${chained}');
  print('\n--- 5. 函数式编程 ---');
  final TypeFunction1<int, int> double2 = ClosureEnv_main_44();
  final TypeFunction1<int, int> addOne = ClosureEnv_main_45();
  final TypeFunction1<int, int> composed = composeFunc<int, int, int>(addOne, double2);
  print('compose(double, addOne)(5): ${composed(5)}');
  final TypeFunction1<TypeFunction1<int, int>, int> curriedAdd = curry<int, int, int>(ClosureEnv_main_46());
  final TypeFunction1<int, int> add10 = curriedAdd(10);
  print('curriedAdd(10)(5): ${add10(5)}');
  final int piped = pipe<int>(3, StaticList<TypeFunction1<int, int>>.of([ClosureEnv_main_50(), ClosureEnv_main_51(), ClosureEnv_main_52()]));
  print('pipe(3, [*2, +10, ^2]): ${piped}');
  final TypeFunction1<int, int> memoFib = memoize<int, int>(ClosureEnv_main_53());
  print('memoized(10): ${memoFib(10)}');
  print('memoized(10) again: ${memoFib(10)}');
  print('\n--- 6. 多重嵌套控制流 ---');
  final StaticList<int> testNumbers = StaticList<int>.of([(-150), (-42), (-3), 0, 1, 7, 12, 97]);
{
    Iterator<int> sync_for_iterator = testNumbers.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final int n = sync_for_iterator.current;
{
        print('  ${n} → ${classifyNumber(n)}');
      }
    }
  }
  print('parseNumbers: ${parseNumbers(StaticList<String>.of(['10', 'abc', ' 42 ', '-5', '', '7']))}');
  print('\n--- 7. mixin 组合 ---');
  final UserProfileValue user1 = UserProfile_new(UserProfileValue(), 'Alice', 'alice@example.com', 25);
  print('user1: ${user1}');
  print('serialize: ${(user1.vptr['serialize'] as TypeFunction1<String, dynamic>)(user1)}');
  print('validation: ${(user1.vptr['get_validationSummary'] as TypeFunction1<String, dynamic>)(user1)}');
  final UserProfileValue user2 = UserProfile_new(UserProfileValue(), '', 'invalid-email', (-5));
  print('user2 validation: ${(user2.vptr['get_validationSummary'] as TypeFunction1<String, dynamic>)(user2)}');
  print('\n--- 8. 模板方法模式 ---');
  final StringToIntTransformerValue strToInt = StringToIntTransformer_new(StringToIntTransformerValue());
  print('strToInt("  42  "): ${(strToInt.vptr['transform'] as TypeFunction2<int, dynamic, String>)(strToInt, '  42  ')}');
  final IntToStringTransformerValue intToStr = IntToStringTransformer_new(IntToStringTransformerValue(), 'NUM:');
  print('intToStr(123): ${(intToStr.vptr['transform'] as TypeFunction2<String, dynamic, int>)(intToStr, 123)}');
  final ChainedTransformerValue<String, int, String> chained2 = ChainedTransformer_new<String, int, String>(ChainedTransformerValue<String, int, String>(), strToInt, intToStr);
  print('chained(" 99 "): ${(chained2.vptr['transform'] as TypeFunction2<String, dynamic, String>)(chained2, ' 99 ')}');
  print('\n--- 9. 单例 Registry ---');
  final RegistryValue reg1 = Registry_new();
  final RegistryValue reg2 = Registry_new();
  print('same instance: ${identical(reg1, reg2)}');
  (reg1.vptr['register'] as TypeFunction3<void, dynamic, String, dynamic>)(reg1, 'name', 'Dart');
  (reg1.vptr['register'] as TypeFunction3<void, dynamic, String, dynamic>)(reg1, 'version', 3);
  print('registry: ${reg1}');
  print('lookup name: ${(reg2.vptr['lookup'] as TypeFunction2<dynamic, dynamic, String>)(reg2, 'name')}');
  print('keys: ${(reg1.vptr['get_keys'] as TypeFunction1<StaticList<String>, dynamic>)(reg1)}');
  (reg1.vptr['clear'] as TypeFunction1<void, dynamic>)(reg1);
  print('\n--- 10. 集合操作链 ---');
  final StaticList<StaticMap<String, Object>> records = StaticList<StaticMap<String, Object>>.of([StaticMap<String, Object>.of({'name': 'Alice', 'score': 95}), StaticMap<String, Object>.of({'name': 'Bob', 'score': 72}), StaticMap<String, Object>.of({'name': 'Carol', 'score': 88}), StaticMap<String, Object>.of({'name': 'Dave', 'score': 45}), StaticMap<String, Object>.of({'name': 'Eve', 'score': 91}), StaticMap<String, Object>.of({'name': 'Frank', 'score': 63})]);
  final StaticList<StaticMap<String, dynamic>> processed = StaticList<StaticMap<String, dynamic>>.of(DataProcessor_processRecords(records));
{
    Iterator<StaticMap<String, dynamic>> sync_for_iterator = processed.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final StaticMap<String, dynamic> r = StaticMap<String, dynamic>.of(sync_for_iterator.current);
{
        print('  ${r['name']}: ${r['score']} (${r['grade']}, passed=${r['passed']})');
      }
    }
  }
  final StaticMap<String, double> averages = StaticMap<String, double>.of(DataProcessor_averageByGrade(processed));
  print('averages: ${averages}');
  print('\n--- 11. late 变量 ---');
  final ExpensiveComputationValue comp = ExpensiveComputation_new(ExpensiveComputationValue(), 42);
  print('comp: ${comp}');
  print('computedValue: ${comp.computedValue}');
  (comp.vptr['initialize'] as TypeFunction2<void, dynamic, String>)(comp, 'test description');
  print('description: ${comp.description}');
  print('\n--- 12. 局部函数 + 递归 ---');
  print('fibonacci(10): ${MathUtils_fibonacci(10)}');
  print('fibonacci(20): ${MathUtils_fibonacci(20)}');
  print('primeFactors(360): ${MathUtils_primeFactors(360)}');
  print('gcd(48, 18): ${MathUtils_gcd(48, 18)}');
  print('lcm(12, 18): ${MathUtils_lcm(12, 18)}');
  print('\n--- 13. 多重 implements ---');
  final StaticList<ScoreValue> scores = StaticList<ScoreValue>.of([Score_new(ScoreValue(), 'Math', 90), Score_new(ScoreValue(), 'English', 75), WeightedScore_new(WeightedScoreValue(), 'Physics', 85, 1.5), WeightedScore_new(WeightedScoreValue(), 'Art', 95, 0.5)]);
{
    Iterator<ScoreValue> sync_for_iterator = scores.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final ScoreValue s = sync_for_iterator.current;
{
        print('  ${(s.vptr['prettyPrint'] as TypeFunction1<String, dynamic>)(s)}');
      }
    }
  }
  final WeightedScoreValue ws1 = (scores[2] as WeightedScoreValue);
  final WeightedScoreValue ws2 = (scores[3] as WeightedScoreValue);
  print('physics > art (weighted): ${(ws1.vptr['isGreaterThan'] as TypeFunction2<bool, dynamic, ScoreValue>)(ws1, ws2)}');
  print('\n--- 14. 字符串操作 ---');
  print('camelToSnake("helloWorldFoo"): ${TextProcessor_camelToSnake('helloWorldFoo')}');
  print('snakeToCamel("hello_world_foo"): ${TextProcessor_snakeToCamel('hello_world_foo')}');
  final StaticMap<String, int> freq = StaticMap<String, int>.of(TextProcessor_wordFrequency('the quick brown fox jumps over the lazy fox'));
  print('word frequency: ${freq}');
  print('truncate: ${TextProcessor_truncate('Hello, World! This is a long string.', 20)}');
  print('\n--- 15. async 链 ---');
  final String asyncResult = smAwait(asyncTransform(5));
  print('asyncTransform(5): ${asyncResult}');
  final StaticList<int> asyncSeq = StaticList<int>.of(smAwait(asyncSequence(5)));
  print('asyncSequence(5): ${asyncSeq}');
  print('\n--- 16. 增强枚举 ---');
{
    Iterator<Season> sync_for_iterator = const [Season.spring, Season.summer, Season.autumn, Season.winter].iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final Season s = sync_for_iterator.current;
{
        print('  ${s} → ${Season_get_displayName(s)}, next=${Season_get_displayName(Season_get_next(s))}, warm=${Season_get_isWarm(s)}');
      }
    }
  }
  print('\n--- 17. 嵌套 Map 操作 ---');
  final StaticMap<String, Object> base = StaticMap<String, Object>.of({'a': 1, 'b': StaticMap<String, int>.of({'x': 10, 'y': 20}), 'c': 3});
  final StaticMap<String, Object> overlay = StaticMap<String, Object>.of({'b': StaticMap<String, int>.of({'y': 99, 'z': 30}), 'd': 4});
  final dynamic merged = JsonLikeProcessor_deepMerge(base, overlay);
  print('deepMerge: ${merged}');
  final StaticMap<String, Object> nested = StaticMap<String, Object>.of({'user': StaticMap<String, Object>.of({'name': 'Alice', 'address': StaticMap<String, String>.of({'city': 'NYC', 'zip': '10001'})}), 'role': 'admin'});
  print('flattenKeys: ${JsonLikeProcessor_flattenKeys(nested)}');
  print('\n--- 18. 扩展方法 ---');
  print('7.isPrime: ${IntMathExtension_get_isPrime(7)}');
  print('12.isPrime: ${IntMathExtension_get_isPrime(12)}');
  print('5.factorial: ${IntMathExtension_get_factorial(5)}');
  print('12345.digits: ${IntMathExtension_get_digits(12345)}');
  final StaticList<int> nums = StaticList<int>.of([10, 20, 30, 40, 50]);
  print('sum: ${IterableStats_get_sum(nums)}, avg: ${IterableStats_get_average(nums)}, max: ${IterableStats_get_max(nums)}, min: ${IterableStats_get_min(nums)}');
  print('\n--- 19. Matrix2D ---');
  final Matrix2DValue m1 = Matrix2D_new(Matrix2DValue(), StaticList<StaticList<double>>.of([StaticList<double>.of([1.0, 2.0]), StaticList<double>.of([3.0, 4.0])]));
  final Matrix2DValue m2 = Matrix2D_new_identity(Matrix2DValue(), 2);
  print('m1: ${m1}');
  print('m2 (identity): ${m2}');
  print('m1 + m2: ${(m1.vptr['operatorPlus'] as TypeFunction2<Matrix2DValue, dynamic, Matrix2DValue>)(m1, m2)}');
  print('m1 * m2: ${(m1.vptr['operatorStar'] as TypeFunction2<Matrix2DValue, dynamic, Matrix2DValue>)(m1, m2)}');
  print('m1 trace: ${(m1.vptr['get_trace'] as TypeFunction1<double, dynamic>)(m1)}');
  final Matrix2DValue m3 = Matrix2D_new_zeros(Matrix2DValue(), 2, 3);
  print('zeros(2,3): ${m3}');
  print('\n--- 20. 综合 mixin + 抽象类 ---');
  final ProductValue product = Product_new(ProductValue(), 'P001', 'Widget', 9.99);
  (product.vptr['audit'] as TypeFunction2<void, dynamic, String>)(product, 'created');
  (product.vptr['audit'] as TypeFunction2<void, dynamic, String>)(product, 'priced');
  (product.vptr['markCached'] as TypeFunction1<void, dynamic>)(product);
  print('product: ${product}');
  print('auditLog: ${(product.vptr['get_auditLog'] as TypeFunction1<StaticList<String>, dynamic>)(product)}');
  (product.vptr['markDirty'] as TypeFunction1<void, dynamic>)(product);
  print('after markDirty: ${(product.vptr['get_cacheStatus'] as TypeFunction1<String, dynamic>)(product)}');
  print('\n=== 所有高级语法测试通过 ✅ ===');
}

class _TearOff_TreeNode_preorder<T> extends TypeFunction1<StaticList<T>, dynamic> {
  _TearOff_TreeNode_preorder();
  @override
  StaticList<T> call(dynamic this_) => TreeNode_preorder<T>(this_);
}
class _TearOff_TreeNode_inorder<T> extends TypeFunction1<StaticList<T>, dynamic> {
  _TearOff_TreeNode_inorder();
  @override
  StaticList<T> call(dynamic this_) => TreeNode_inorder<T>(this_);
}
class _TearOff_TreeNode_get_depth<T> extends TypeFunction1<int, dynamic> {
  _TearOff_TreeNode_get_depth();
  @override
  int call(dynamic this_) => TreeNode_get_depth<T>(this_);
}
class _TearOff_TreeNode_toString<T> extends TypeFunction1<String, dynamic> {
  _TearOff_TreeNode_toString();
  @override
  String call(dynamic this_) => TreeNode_toString<T>(this_);
}
class _TearOff_TreeNode_map_String<T> extends TypeFunction2<TreeNodeValue<String>, dynamic, TypeFunction1<String, T>> {
  _TearOff_TreeNode_map_String();
  @override
  TreeNodeValue<String> call(dynamic this_, TypeFunction1<String, T> transform) => TreeNode_map<T, String>(this_, transform);
}
class _TearOff_LinkedNode_reversed<T> extends TypeFunction1<LinkedNodeValue<T>, dynamic> {
  _TearOff_LinkedNode_reversed();
  @override
  LinkedNodeValue<T> call(dynamic this_) => LinkedNode_reversed<T>(this_);
}
class _TearOff_LinkedNode_toList<T> extends TypeFunction1<StaticList<T>, dynamic> {
  _TearOff_LinkedNode_toList();
  @override
  StaticList<T> call(dynamic this_) => LinkedNode_toList<T>(this_);
}
class _TearOff_LinkedNode_get_length<T> extends TypeFunction1<int, dynamic> {
  _TearOff_LinkedNode_get_length();
  @override
  int call(dynamic this_) => LinkedNode_get_length<T>(this_);
}
class _TearOff_LinkedNode_toString<T> extends TypeFunction1<String, dynamic> {
  _TearOff_LinkedNode_toString();
  @override
  String call(dynamic this_) => LinkedNode_toString<T>(this_);
}
class _TearOff_Either_get_isLeft<L, R> extends TypeFunction1<bool, dynamic> {
  _TearOff_Either_get_isLeft();
  @override
  bool call(dynamic this_) => Either_get_isLeft<L, R>(this_);
}
class _TearOff_Either_get_isRight<L, R> extends TypeFunction1<bool, dynamic> {
  _TearOff_Either_get_isRight();
  @override
  bool call(dynamic this_) => Either_get_isRight<L, R>(this_);
}
class _TearOff_Either_get_leftValue<L, R> extends TypeFunction1<L, dynamic> {
  _TearOff_Either_get_leftValue();
  @override
  L call(dynamic this_) => Either_get_leftValue<L, R>(this_);
}
class _TearOff_Either_get_rightValue<L, R> extends TypeFunction1<R, dynamic> {
  _TearOff_Either_get_rightValue();
  @override
  R call(dynamic this_) => Either_get_rightValue<L, R>(this_);
}
class _TearOff_Either_toString<L, R> extends TypeFunction1<String, dynamic> {
  _TearOff_Either_toString();
  @override
  String call(dynamic this_) => Either_toString<L, R>(this_);
}
class _TearOff_Either_fold_String<L, R> extends TypeFunction3<String, dynamic, TypeFunction1<String, L>, TypeFunction1<String, R>> {
  _TearOff_Either_fold_String();
  @override
  String call(dynamic this_, TypeFunction1<String, L> onLeft, TypeFunction1<String, R> onRight) => Either_fold<L, R, String>(this_, onLeft, onRight);
}
class _TearOff_Either_mapRight_int<L, R> extends TypeFunction2<EitherValue<L, int>, dynamic, TypeFunction1<int, R>> {
  _TearOff_Either_mapRight_int();
  @override
  EitherValue<L, int> call(dynamic this_, TypeFunction1<int, R> transform) => Either_mapRight<L, R, int>(this_, transform);
}
class _TearOff_Either_flatMap_dynamic<L, R> extends TypeFunction2<EitherValue<L, dynamic>, dynamic, TypeFunction1<EitherValue<L, dynamic>, R>> {
  _TearOff_Either_flatMap_dynamic();
  @override
  EitherValue<L, dynamic> call(dynamic this_, TypeFunction1<EitherValue<L, dynamic>, R> transform) => Either_flatMap<L, R, dynamic>(this_, transform);
}
class ClosureEnv_anon_0 extends TypeFunction1<String, MapEntry<String, dynamic>> {
  ClosureEnv_anon_0();
  @override
  String call(MapEntry<String, dynamic> e) => ClosureEnv_anon_0_call(this, e);
}
String ClosureEnv_anon_0_call(ClosureEnv_anon_0 env, MapEntry<String, dynamic> e) {
  return '${e.key}=${e.value}';
}

class _TearOff_UserProfile_toMap extends TypeFunction1<StaticMap<String, dynamic>, dynamic> {
  const _TearOff_UserProfile_toMap();
  @override
  StaticMap<String, dynamic> call(dynamic this_) => UserProfile_toMap(this_);
}
class _TearOff_UserProfile_serialize extends TypeFunction1<String, dynamic> {
  const _TearOff_UserProfile_serialize();
  @override
  String call(dynamic this_) => UserProfile_serialize(this_);
}
class _TearOff_UserProfile_validate extends TypeFunction1<StaticList<String>, dynamic> {
  const _TearOff_UserProfile_validate();
  @override
  StaticList<String> call(dynamic this_) => UserProfile_validate(this_);
}
class _TearOff_UserProfile_get_isValid extends TypeFunction1<bool, dynamic> {
  const _TearOff_UserProfile_get_isValid();
  @override
  bool call(dynamic this_) => UserProfile_get_isValid(this_);
}
class _TearOff_UserProfile_get_validationSummary extends TypeFunction1<String, dynamic> {
  const _TearOff_UserProfile_get_validationSummary();
  @override
  String call(dynamic this_) => UserProfile_get_validationSummary(this_);
}
class _TearOff_UserProfile_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_UserProfile_toString();
  @override
  String call(dynamic this_) => UserProfile_toString(this_);
}
class _TearOff_DataTransformer_transform<TInput, TOutput> extends TypeFunction2<TOutput, dynamic, TInput> {
  _TearOff_DataTransformer_transform();
  @override
  TOutput call(dynamic this_, TInput input) => DataTransformer_transform<TInput, TOutput>(this_, input);
}
class _TearOff_DataTransformer_preValidate<TInput, TOutput> extends TypeFunction2<TInput, dynamic, TInput> {
  _TearOff_DataTransformer_preValidate();
  @override
  TInput call(dynamic this_, TInput input) => DataTransformer_preValidate<TInput, TOutput>(this_, input);
}
class _TearOff_DataTransformer_process<TInput, TOutput> extends TypeFunction2<TOutput, dynamic, TInput> {
  _TearOff_DataTransformer_process();
  @override
  TOutput call(dynamic this_, TInput input) => DataTransformer_process<TInput, TOutput>(this_, input);
}
class _TearOff_DataTransformer_postProcess<TInput, TOutput> extends TypeFunction2<TOutput, dynamic, TOutput> {
  _TearOff_DataTransformer_postProcess();
  @override
  TOutput call(dynamic this_, TOutput output) => DataTransformer_postProcess<TInput, TOutput>(this_, output);
}
class _TearOff_StringToIntTransformer_transform extends TypeFunction2<int, dynamic, String> {
  const _TearOff_StringToIntTransformer_transform();
  @override
  int call(dynamic this_, String input) => StringToIntTransformer_transform(this_, input);
}
class _TearOff_StringToIntTransformer_preValidate extends TypeFunction2<String, dynamic, String> {
  const _TearOff_StringToIntTransformer_preValidate();
  @override
  String call(dynamic this_, String input) => StringToIntTransformer_preValidate(this_, input);
}
class _TearOff_StringToIntTransformer_process extends TypeFunction2<int, dynamic, String> {
  const _TearOff_StringToIntTransformer_process();
  @override
  int call(dynamic this_, String input) => StringToIntTransformer_process(this_, input);
}
class _TearOff_StringToIntTransformer_postProcess extends TypeFunction2<int, dynamic, int> {
  const _TearOff_StringToIntTransformer_postProcess();
  @override
  int call(dynamic this_, int output) => StringToIntTransformer_postProcess(this_, output);
}
class _TearOff_IntToStringTransformer_transform extends TypeFunction2<String, dynamic, int> {
  const _TearOff_IntToStringTransformer_transform();
  @override
  String call(dynamic this_, int input) => IntToStringTransformer_transform(this_, input);
}
class _TearOff_IntToStringTransformer_preValidate extends TypeFunction2<int, dynamic, int> {
  const _TearOff_IntToStringTransformer_preValidate();
  @override
  int call(dynamic this_, int input) => IntToStringTransformer_preValidate(this_, input);
}
class _TearOff_IntToStringTransformer_process extends TypeFunction2<String, dynamic, int> {
  const _TearOff_IntToStringTransformer_process();
  @override
  String call(dynamic this_, int input) => IntToStringTransformer_process(this_, input);
}
class _TearOff_IntToStringTransformer_postProcess extends TypeFunction2<String, dynamic, String> {
  const _TearOff_IntToStringTransformer_postProcess();
  @override
  String call(dynamic this_, String output) => IntToStringTransformer_postProcess(this_, output);
}
class _TearOff_ChainedTransformer_transform<A, B, C> extends TypeFunction2<C, dynamic, A> {
  _TearOff_ChainedTransformer_transform();
  @override
  C call(dynamic this_, A input) => ChainedTransformer_transform<A, B, C>(this_, input);
}
class _TearOff_ChainedTransformer_preValidate<A, B, C> extends TypeFunction2<A, dynamic, A> {
  _TearOff_ChainedTransformer_preValidate();
  @override
  A call(dynamic this_, A input) => ChainedTransformer_preValidate<A, B, C>(this_, input);
}
class _TearOff_ChainedTransformer_process<A, B, C> extends TypeFunction2<C, dynamic, A> {
  _TearOff_ChainedTransformer_process();
  @override
  C call(dynamic this_, A input) => ChainedTransformer_process<A, B, C>(this_, input);
}
class _TearOff_ChainedTransformer_postProcess<A, B, C> extends TypeFunction2<C, dynamic, C> {
  _TearOff_ChainedTransformer_postProcess();
  @override
  C call(dynamic this_, C output) => ChainedTransformer_postProcess<A, B, C>(this_, output);
}
class _TearOff_Registry_register extends TypeFunction3<void, dynamic, String, dynamic> {
  const _TearOff_Registry_register();
  @override
  void call(dynamic this_, String key, dynamic value) => Registry_register(this_, key, value);
}
class _TearOff_Registry_lookup extends TypeFunction2<dynamic, dynamic, String> {
  const _TearOff_Registry_lookup();
  @override
  dynamic call(dynamic this_, String key) => Registry_lookup(this_, key);
}
class _TearOff_Registry_contains extends TypeFunction2<bool, dynamic, String> {
  const _TearOff_Registry_contains();
  @override
  bool call(dynamic this_, String key) => Registry_contains(this_, key);
}
class _TearOff_Registry_get_size extends TypeFunction1<int, dynamic> {
  const _TearOff_Registry_get_size();
  @override
  int call(dynamic this_) => Registry_get_size(this_);
}
class _TearOff_Registry_get_accessCount extends TypeFunction1<int, dynamic> {
  const _TearOff_Registry_get_accessCount();
  @override
  int call(dynamic this_) => Registry_get_accessCount(this_);
}
class _TearOff_Registry_get_keys extends TypeFunction1<StaticList<String>, dynamic> {
  const _TearOff_Registry_get_keys();
  @override
  StaticList<String> call(dynamic this_) => Registry_get_keys(this_);
}
class _TearOff_Registry_clear extends TypeFunction1<void, dynamic> {
  const _TearOff_Registry_clear();
  @override
  void call(dynamic this_) => Registry_clear(this_);
}
class _TearOff_Registry_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Registry_toString();
  @override
  String call(dynamic this_) => Registry_toString(this_);
}
class ClosureEnv_anon_1 extends TypeFunction2<int, StaticMap<String, dynamic>, StaticMap<String, dynamic>> {
  ClosureEnv_anon_1();
  @override
  int call(StaticMap<String, dynamic> a, StaticMap<String, dynamic> b) => ClosureEnv_anon_1_call(this, a, b);
}
int ClosureEnv_anon_1_call(ClosureEnv_anon_1 env, StaticMap<String, dynamic> a, StaticMap<String, dynamic> b) {
  return (b['score'] as int).compareTo((a['score'] as int));
}

class ClosureEnv_anon_2 extends TypeFunction1<bool, StaticMap<String, dynamic>> {
  ClosureEnv_anon_2();
  @override
  bool call(StaticMap<String, dynamic> r) => ClosureEnv_anon_2_call(this, r);
}
bool ClosureEnv_anon_2_call(ClosureEnv_anon_2 env, StaticMap<String, dynamic> r) {
  return (r.containsKey('name') && r.containsKey('score'));
}

class ClosureEnv_anon_3 extends TypeFunction1<bool, StaticMap<String, dynamic>> {
  ClosureEnv_anon_3();
  @override
  bool call(StaticMap<String, dynamic> r) => ClosureEnv_anon_3_call(this, r);
}
bool ClosureEnv_anon_3_call(ClosureEnv_anon_3 env, StaticMap<String, dynamic> r) {
  return ((r['score'] as int) >= 0);
}

class ClosureEnv_anon_4 extends TypeFunction1<StaticMap<String, Object>, StaticMap<String, dynamic>> {
  ClosureEnv_anon_4();
  @override
  StaticMap<String, Object> call(StaticMap<String, dynamic> r) => ClosureEnv_anon_4_call(this, r);
}
StaticMap<String, Object> ClosureEnv_anon_4_call(ClosureEnv_anon_4 env, StaticMap<String, dynamic> r) {
  return StaticMap<String, Object>.of({'name': (r['name'] as String).toUpperCase(), 'score': (r['score'] as int), 'grade': DataProcessor__scoreToGrade((r['score'] as int)), 'passed': ((r['score'] as int) >= 60)});
}

class ClosureEnv_anon_5 extends TypeFunction0<StaticList<StaticMap<String, dynamic>>> {
  ClosureEnv_anon_5();
  @override
  StaticList<StaticMap<String, dynamic>> call() => ClosureEnv_anon_5_call(this);
}
StaticList<StaticMap<String, dynamic>> ClosureEnv_anon_5_call(ClosureEnv_anon_5 env) {
  return StaticList<StaticMap<String, dynamic>>();
}

class ClosureEnv_ClosureEnv_anon_6_7 extends TypeFunction2<int, int, StaticMap<String, dynamic>> {
  ClosureEnv_ClosureEnv_anon_6_7();
  @override
  int call(int sum, StaticMap<String, dynamic> r) => ClosureEnv_ClosureEnv_anon_6_7_call(this, sum, r);
}
int ClosureEnv_ClosureEnv_anon_6_7_call(ClosureEnv_ClosureEnv_anon_6_7 env, int sum, StaticMap<String, dynamic> r) {
  return (sum + (r['score'] as int));
}

class ClosureEnv_anon_6 extends TypeFunction2<MapEntry<String, double>, String, StaticList<StaticMap<String, dynamic>>> {
  ClosureEnv_anon_6();
  @override
  MapEntry<String, double> call(String grade, StaticList<StaticMap<String, dynamic>> items) => ClosureEnv_anon_6_call(this, grade, items);
}
MapEntry<String, double> ClosureEnv_anon_6_call(ClosureEnv_anon_6 env, String grade, StaticList<StaticMap<String, dynamic>> items) {
    final int total = items.fold(0, ClosureEnv_ClosureEnv_anon_6_7());
    return MapEntry(grade, (total / items.length));
  }

class _TearOff_ExpensiveComputation_initialize extends TypeFunction2<void, dynamic, String> {
  const _TearOff_ExpensiveComputation_initialize();
  @override
  void call(dynamic this_, String desc) => ExpensiveComputation_initialize(this_, desc);
}
class _TearOff_ExpensiveComputation_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_ExpensiveComputation_toString();
  @override
  String call(dynamic this_) => ExpensiveComputation_toString(this_);
}
class _TearOff_Printable3_prettyPrint extends TypeFunction1<String, dynamic> {
  const _TearOff_Printable3_prettyPrint();
  @override
  String call(dynamic this_) => Printable3_prettyPrint(this_);
}
class _TearOff_Score_prettyPrint extends TypeFunction1<String, dynamic> {
  const _TearOff_Score_prettyPrint();
  @override
  String call(dynamic this_) => Score_prettyPrint(this_);
}
class _TearOff_Score_compareTo2 extends TypeFunction2<int, dynamic, ScoreValue> {
  const _TearOff_Score_compareTo2();
  @override
  int call(dynamic this_, ScoreValue other) => Score_compareTo2(this_, other);
}
class _TearOff_Score_isLessThan extends TypeFunction2<bool, dynamic, ScoreValue> {
  const _TearOff_Score_isLessThan();
  @override
  bool call(dynamic this_, ScoreValue other) => Score_isLessThan(this_, other);
}
class _TearOff_Score_isGreaterThan extends TypeFunction2<bool, dynamic, ScoreValue> {
  const _TearOff_Score_isGreaterThan();
  @override
  bool call(dynamic this_, ScoreValue other) => Score_isGreaterThan(this_, other);
}
class _TearOff_Score_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Score_toString();
  @override
  String call(dynamic this_) => Score_toString(this_);
}
class _TearOff_WeightedScore_prettyPrint extends TypeFunction1<String, dynamic> {
  const _TearOff_WeightedScore_prettyPrint();
  @override
  String call(dynamic this_) => WeightedScore_prettyPrint(this_);
}
class _TearOff_WeightedScore_compareTo2 extends TypeFunction2<int, dynamic, ScoreValue> {
  const _TearOff_WeightedScore_compareTo2();
  @override
  int call(dynamic this_, ScoreValue other) => WeightedScore_compareTo2(this_, other);
}
class _TearOff_WeightedScore_isLessThan extends TypeFunction2<bool, dynamic, ScoreValue> {
  const _TearOff_WeightedScore_isLessThan();
  @override
  bool call(dynamic this_, ScoreValue other) => WeightedScore_isLessThan(this_, other);
}
class _TearOff_WeightedScore_isGreaterThan extends TypeFunction2<bool, dynamic, ScoreValue> {
  const _TearOff_WeightedScore_isGreaterThan();
  @override
  bool call(dynamic this_, ScoreValue other) => WeightedScore_isGreaterThan(this_, other);
}
class _TearOff_WeightedScore_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_WeightedScore_toString();
  @override
  String call(dynamic this_) => WeightedScore_toString(this_);
}
class _TearOff_WeightedScore_get_weightedPoints extends TypeFunction1<double, dynamic> {
  const _TearOff_WeightedScore_get_weightedPoints();
  @override
  double call(dynamic this_) => WeightedScore_get_weightedPoints(this_);
}
class ClosureEnv_anon_8 extends TypeFunction1<String, String> {
  ClosureEnv_anon_8();
  @override
  String call(String p) => ClosureEnv_anon_8_call(this, p);
}
String ClosureEnv_anon_8_call(ClosureEnv_anon_8 env, String p) {
  return (p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1)}');
}

class ClosureEnv_anon_9 extends TypeFunction1<bool, String> {
  ClosureEnv_anon_9();
  @override
  bool call(String w) => ClosureEnv_anon_9_call(this, w);
}
bool ClosureEnv_anon_9_call(ClosureEnv_anon_9 env, String w) {
  return w.isNotEmpty;
}

class _TearOff_Matrix2D_get extends TypeFunction3<double, dynamic, int, int> {
  const _TearOff_Matrix2D_get();
  @override
  double call(dynamic this_, int row, int col) => Matrix2D_get(this_, row, col);
}
class _TearOff_Matrix2D_operatorPlus extends TypeFunction2<Matrix2DValue, dynamic, Matrix2DValue> {
  const _TearOff_Matrix2D_operatorPlus();
  @override
  Matrix2DValue call(dynamic this_, Matrix2DValue other) => Matrix2D_operatorPlus(this_, other);
}
class _TearOff_Matrix2D_operatorStar extends TypeFunction2<Matrix2DValue, dynamic, Matrix2DValue> {
  const _TearOff_Matrix2D_operatorStar();
  @override
  Matrix2DValue call(dynamic this_, Matrix2DValue other) => Matrix2D_operatorStar(this_, other);
}
class _TearOff_Matrix2D_get_trace extends TypeFunction1<double, dynamic> {
  const _TearOff_Matrix2D_get_trace();
  @override
  double call(dynamic this_) => Matrix2D_get_trace(this_);
}
class _TearOff_Matrix2D_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Matrix2D_toString();
  @override
  String call(dynamic this_) => Matrix2D_toString(this_);
}
class ClosureEnv_anon_10 extends TypeFunction1<StaticList<double>, int> {
  int cols;
  ClosureEnv_anon_10(this.cols);
  @override
  StaticList<double> call(int _) => ClosureEnv_anon_10_call(this, _);
}
StaticList<double> ClosureEnv_anon_10_call(ClosureEnv_anon_10 env, int _) {
  return StaticList<double>.filled(env.cols, 0.0);
}

class ClosureEnv_ClosureEnv_anon_11_12 extends TypeFunction1<double, int> {
  IntBox i;
  ClosureEnv_ClosureEnv_anon_11_12(this.i);
  @override
  double call(int j) => ClosureEnv_ClosureEnv_anon_11_12_call(this, j);
}
double ClosureEnv_ClosureEnv_anon_11_12_call(ClosureEnv_ClosureEnv_anon_11_12 env, int j) {
  return ((env.i.value == j) ? 1.0 : 0.0);
}

class ClosureEnv_anon_11 extends TypeFunction1<StaticList<double>, int> {
  int size;
  ClosureEnv_anon_11(this.size);
  @override
  StaticList<double> call(int i_raw) => ClosureEnv_anon_11_call(this, i_raw);
}
StaticList<double> ClosureEnv_anon_11_call(ClosureEnv_anon_11 env, int i_raw) {
  IntBox i = IntBox(i_raw);
  return StaticList<double>.generate(env.size, ClosureEnv_ClosureEnv_anon_11_12(i));
}

class ClosureEnv_ClosureEnv_anon_13_14 extends TypeFunction1<String, double> {
  ClosureEnv_ClosureEnv_anon_13_14();
  @override
  String call(double v) => ClosureEnv_ClosureEnv_anon_13_14_call(this, v);
}
String ClosureEnv_ClosureEnv_anon_13_14_call(ClosureEnv_ClosureEnv_anon_13_14 env, double v) {
  return v.toStringAsFixed(1);
}

class ClosureEnv_anon_13 extends TypeFunction1<String, StaticList<double>> {
  ClosureEnv_anon_13();
  @override
  String call(StaticList<double> row) => ClosureEnv_anon_13_call(this, row);
}
String ClosureEnv_anon_13_call(ClosureEnv_anon_13 env, StaticList<double> row) {
  return row.map(ClosureEnv_ClosureEnv_anon_13_14()).join(', ');
}

class ClosureEnv_anon_15 extends TypeFunction1<String, String> {
  ClosureEnv_anon_15();
  @override
  String call(String r) => ClosureEnv_anon_15_call(this, r);
}
String ClosureEnv_anon_15_call(ClosureEnv_anon_15 env, String r) {
  return '[${r}]';
}

class _TearOff_Entity_get_entityId extends TypeFunction1<String, dynamic> {
  const _TearOff_Entity_get_entityId();
  @override
  String call(dynamic this_) => Entity_get_entityId(this_);
}
class _TearOff_Product_get_entityId extends TypeFunction1<String, dynamic> {
  const _TearOff_Product_get_entityId();
  @override
  String call(dynamic this_) => Product_get_entityId(this_);
}
class _TearOff_Product_audit extends TypeFunction2<void, dynamic, String> {
  const _TearOff_Product_audit();
  @override
  void call(dynamic this_, String action) => Product_audit(this_, action);
}
class _TearOff_Product_get_auditLog extends TypeFunction1<StaticList<String>, dynamic> {
  const _TearOff_Product_get_auditLog();
  @override
  StaticList<String> call(dynamic this_) => Product_get_auditLog(this_);
}
class _TearOff_Product_markDirty extends TypeFunction1<void, dynamic> {
  const _TearOff_Product_markDirty();
  @override
  void call(dynamic this_) => Product_markDirty(this_);
}
class _TearOff_Product_markCached extends TypeFunction1<void, dynamic> {
  const _TearOff_Product_markCached();
  @override
  void call(dynamic this_) => Product_markCached(this_);
}
class _TearOff_Product_get_isDirty extends TypeFunction1<bool, dynamic> {
  const _TearOff_Product_get_isDirty();
  @override
  bool call(dynamic this_) => Product_get_isDirty(this_);
}
class _TearOff_Product_get_cacheStatus extends TypeFunction1<String, dynamic> {
  const _TearOff_Product_get_cacheStatus();
  @override
  String call(dynamic this_) => Product_get_cacheStatus(this_);
}
class _TearOff_Product_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Product_toString();
  @override
  String call(dynamic this_) => Product_toString(this_);
}
class ClosureEnv_makeCounter_16 extends TypeFunction0<int> {
  IntBox current;
  int step;
  ClosureEnv_makeCounter_16(this.current, this.step);
  @override
  int call() => ClosureEnv_makeCounter_16_call(this);
}
int ClosureEnv_makeCounter_16_call(ClosureEnv_makeCounter_16 env) {
    env.current.value = (env.current.value + env.step);
    return env.current.value;
  }

class ClosureEnv_ClosureEnv_makeAccumulator_17_18 extends TypeFunction0<String> {
  IntBox snapshot;
  IntBox total;
  ClosureEnv_ClosureEnv_makeAccumulator_17_18(this.snapshot, this.total);
  @override
  String call() => ClosureEnv_ClosureEnv_makeAccumulator_17_18_call(this);
}
String ClosureEnv_ClosureEnv_makeAccumulator_17_18_call(ClosureEnv_ClosureEnv_makeAccumulator_17_18 env) {
  return 'accumulated: ${env.snapshot.value} (current total: ${env.total.value})';
}

class ClosureEnv_makeAccumulator_17 extends TypeFunction1<TypeFunction0<String>, int> {
  IntBox total;
  ClosureEnv_makeAccumulator_17(this.total);
  @override
  TypeFunction0<String> call(int amount) => ClosureEnv_makeAccumulator_17_call(this, amount);
}
TypeFunction0<String> ClosureEnv_makeAccumulator_17_call(ClosureEnv_makeAccumulator_17 env, int amount) {
    env.total.value = (env.total.value + amount);
    IntBox snapshot = IntBox(env.total.value);
    return ClosureEnv_ClosureEnv_makeAccumulator_17_18(snapshot, env.total);
  }

class ClosureEnv_makeClosureList_19 extends TypeFunction0<String> {
  int i;
  ClosureEnv_makeClosureList_19(this.i);
  @override
  String call() => ClosureEnv_makeClosureList_19_call(this);
}
String ClosureEnv_makeClosureList_19_call(ClosureEnv_makeClosureList_19 env) {
  return 'closure_${env.i}';
}

class ClosureEnv_composeFunc_20<C, B, A> extends TypeFunction1<C, A> {
  TypeFunction1<C, B> funcBC;
  TypeFunction1<B, A> funcAB;
  ClosureEnv_composeFunc_20(this.funcBC, this.funcAB);
  @override
  C call(A a) => ClosureEnv_composeFunc_20_call<C, B, A>(this, a);
}
C ClosureEnv_composeFunc_20_call<C, B, A>(ClosureEnv_composeFunc_20<C, B, A> env, A a) {
  return env.funcBC(env.funcAB(a));
}

class ClosureEnv_ClosureEnv_curry_21_22<C, A, B> extends TypeFunction1<C, B> {
  TypeFunction2<C, A, B> biFunc;
  ObjectBox<A> a;
  ClosureEnv_ClosureEnv_curry_21_22(this.biFunc, this.a);
  @override
  C call(B b) => ClosureEnv_ClosureEnv_curry_21_22_call<C, A, B>(this, b);
}
C ClosureEnv_ClosureEnv_curry_21_22_call<C, A, B>(ClosureEnv_ClosureEnv_curry_21_22<C, A, B> env, B b) {
  return env.biFunc(env.a.value, b);
}

class ClosureEnv_curry_21<C, A, B> extends TypeFunction1<TypeFunction1<C, B>, A> {
  TypeFunction2<C, A, B> biFunc;
  ClosureEnv_curry_21(this.biFunc);
  @override
  TypeFunction1<C, B> call(A a_raw) => ClosureEnv_curry_21_call<C, A, B>(this, a_raw);
}
TypeFunction1<C, B> ClosureEnv_curry_21_call<C, A, B>(ClosureEnv_curry_21<C, A, B> env, A a_raw) {
  ObjectBox<A> a = ObjectBox<A>(a_raw);
  return ClosureEnv_ClosureEnv_curry_21_22<C, A, B>(env.biFunc, a);
}

class ClosureEnv_memoize_23<A, B> extends TypeFunction1<B, A> {
  StaticMap<A, B> cache;
  TypeFunction1<B, A> func;
  ClosureEnv_memoize_23(this.cache, this.func);
  @override
  B call(A arg) => ClosureEnv_memoize_23_call<A, B>(this, arg);
}
B ClosureEnv_memoize_23_call<A, B>(ClosureEnv_memoize_23<A, B> env, A arg) {
    if (env.cache.containsKey(arg))     return (env.cache[arg] as B);
    final B result = env.func(arg);
    env.cache[arg] = result;
    return result;
  }

class ClosureEnv_asyncAdd_24 {
  IntBox a;
  IntBox b;
  Promise<int> _promise;
  ClosureEnv_asyncAdd_24(int a, int b) : _promise = Promise<int>(), a = IntBox(a), b = IntBox(b);
  void call() => ClosureEnv_asyncAdd_24_call(this);
}
void ClosureEnv_asyncAdd_24_call(ClosureEnv_asyncAdd_24 env) {
  smAwait(promiseDelayed<dynamic>(Duration(milliseconds: 1)));
  env._promise.complete((env.a.value + env.b.value));
  return;
}
class ClosureEnv_asyncTransform_25 {
  IntBox value;
  Promise<String> _promise;
  ClosureEnv_asyncTransform_25(int value) : _promise = Promise<String>(), value = IntBox(value);
  void call() => ClosureEnv_asyncTransform_25_call(this);
}
void ClosureEnv_asyncTransform_25_call(ClosureEnv_asyncTransform_25 env) {
  final int doubled = smAwait(asyncAdd(env.value.value, env.value.value));
  final int tripled = smAwait(asyncAdd(doubled, env.value.value));
  env._promise.complete('value=${env.value.value}, doubled=${doubled}, tripled=${tripled}');
  return;
}
class ClosureEnv_asyncSequence_26 {
  IntBox count;
  Promise<StaticList<int>> _promise;
  ClosureEnv_asyncSequence_26(int count) : _promise = Promise<StaticList<int>>(), count = IntBox(count);
  void call() => ClosureEnv_asyncSequence_26_call(this);
}
void ClosureEnv_asyncSequence_26_call(ClosureEnv_asyncSequence_26 env) {
  final StaticList<int> results = StaticList<int>();
  for (var i = 0; (i < env.count.value); i = (i + 1)) {
    final int value = smAwait(asyncAdd(i, (i * i)));
    results.add(value);
  }
  env._promise.complete(results);
  return;
}
class ClosureEnv_IterableStats_get_sum_27<T extends num> extends TypeFunction2<T, T, T> {
  ClosureEnv_IterableStats_get_sum_27();
  @override
  T call(T a, T b) => ClosureEnv_IterableStats_get_sum_27_call<T>(this, a, b);
}
T ClosureEnv_IterableStats_get_sum_27_call<T extends num>(ClosureEnv_IterableStats_get_sum_27<T> env, T a, T b) {
  return ((a + b) as T);
}

class ClosureEnv_IterableStats_get_max_28<T extends num> extends TypeFunction2<T, T, T> {
  ClosureEnv_IterableStats_get_max_28();
  @override
  T call(T a, T b) => ClosureEnv_IterableStats_get_max_28_call<T>(this, a, b);
}
T ClosureEnv_IterableStats_get_max_28_call<T extends num>(ClosureEnv_IterableStats_get_max_28<T> env, T a, T b) {
  return ((a > b) ? a : b);
}

class ClosureEnv_IterableStats_get_min_29<T extends num> extends TypeFunction2<T, T, T> {
  ClosureEnv_IterableStats_get_min_29();
  @override
  T call(T a, T b) => ClosureEnv_IterableStats_get_min_29_call<T>(this, a, b);
}
T ClosureEnv_IterableStats_get_min_29_call<T extends num>(ClosureEnv_IterableStats_get_min_29<T> env, T a, T b) {
  return ((a < b) ? a : b);
}

class ClosureEnv_main_30 extends TypeFunction1<String, int> {
  ClosureEnv_main_30();
  @override
  String call(int v) => ClosureEnv_main_30_call(this, v);
}
String ClosureEnv_main_30_call(ClosureEnv_main_30 env, int v) {
  return 'N${v}';
}

class ClosureEnv_main_31 extends TypeFunction1<String, int> {
  ClosureEnv_main_31();
  @override
  String call(int v) => ClosureEnv_main_31_call(this, v);
}
String ClosureEnv_main_31_call(ClosureEnv_main_31 env, int v) {
  return 'N${v}';
}

class ClosureEnv_main_32 extends TypeFunction1<String, String> {
  ClosureEnv_main_32();
  @override
  String call(String l) => ClosureEnv_main_32_call(this, l);
}
String ClosureEnv_main_32_call(ClosureEnv_main_32 env, String l) {
  return 'L:${l}';
}

class ClosureEnv_main_33 extends TypeFunction1<String, int> {
  ClosureEnv_main_33();
  @override
  String call(int r) => ClosureEnv_main_33_call(this, r);
}
String ClosureEnv_main_33_call(ClosureEnv_main_33 env, int r) {
  return 'R:${r}';
}

class ClosureEnv_main_34 extends TypeFunction1<String, String> {
  ClosureEnv_main_34();
  @override
  String call(String l) => ClosureEnv_main_34_call(this, l);
}
String ClosureEnv_main_34_call(ClosureEnv_main_34 env, String l) {
  return 'L:${l}';
}

class ClosureEnv_main_35 extends TypeFunction1<String, int> {
  ClosureEnv_main_35();
  @override
  String call(int r) => ClosureEnv_main_35_call(this, r);
}
String ClosureEnv_main_35_call(ClosureEnv_main_35 env, int r) {
  return 'R:${r}';
}

class ClosureEnv_main_36 extends TypeFunction1<String, String> {
  ClosureEnv_main_36();
  @override
  String call(String l) => ClosureEnv_main_36_call(this, l);
}
String ClosureEnv_main_36_call(ClosureEnv_main_36 env, String l) {
  return 'L:${l}';
}

class ClosureEnv_main_37 extends TypeFunction1<String, int> {
  ClosureEnv_main_37();
  @override
  String call(int r) => ClosureEnv_main_37_call(this, r);
}
String ClosureEnv_main_37_call(ClosureEnv_main_37 env, int r) {
  return 'R:${r}';
}

class ClosureEnv_main_38 extends TypeFunction1<String, String> {
  ClosureEnv_main_38();
  @override
  String call(String l) => ClosureEnv_main_38_call(this, l);
}
String ClosureEnv_main_38_call(ClosureEnv_main_38 env, String l) {
  return 'L:${l}';
}

class ClosureEnv_main_39 extends TypeFunction1<String, int> {
  ClosureEnv_main_39();
  @override
  String call(int r) => ClosureEnv_main_39_call(this, r);
}
String ClosureEnv_main_39_call(ClosureEnv_main_39 env, int r) {
  return 'R:${r}';
}

class ClosureEnv_main_40 extends TypeFunction1<int, int> {
  ClosureEnv_main_40();
  @override
  int call(int v) => ClosureEnv_main_40_call(this, v);
}
int ClosureEnv_main_40_call(ClosureEnv_main_40 env, int v) {
  return (v * 2);
}

class ClosureEnv_main_41 extends TypeFunction1<int, int> {
  ClosureEnv_main_41();
  @override
  int call(int v) => ClosureEnv_main_41_call(this, v);
}
int ClosureEnv_main_41_call(ClosureEnv_main_41 env, int v) {
  return (v * 2);
}

class ClosureEnv_main_42 extends TypeFunction1<EitherValue<String, dynamic>, int> {
  ClosureEnv_main_42();
  @override
  EitherValue<String, dynamic> call(int v) => ClosureEnv_main_42_call(this, v);
}
EitherValue<String, dynamic> ClosureEnv_main_42_call(ClosureEnv_main_42 env, int v) {
  return ((v > 10) ? Either_new_right<String, String>(EitherValue<String, String>(), 'big_${v}') : Either_new_left<String, dynamic>(EitherValue<String, dynamic>(), 'too small'));
}

class ClosureEnv_main_43 extends TypeFunction1<EitherValue<String, dynamic>, int> {
  ClosureEnv_main_43();
  @override
  EitherValue<String, dynamic> call(int v) => ClosureEnv_main_43_call(this, v);
}
EitherValue<String, dynamic> ClosureEnv_main_43_call(ClosureEnv_main_43 env, int v) {
  return ((v > 10) ? Either_new_right<String, String>(EitherValue<String, String>(), 'big_${v}') : Either_new_left<String, dynamic>(EitherValue<String, dynamic>(), 'too small'));
}

class ClosureEnv_main_44 extends TypeFunction1<int, int> {
  ClosureEnv_main_44();
  @override
  int call(int x) => ClosureEnv_main_44_call(this, x);
}
int ClosureEnv_main_44_call(ClosureEnv_main_44 env, int x) {
  return (x * 2);
}

class ClosureEnv_main_45 extends TypeFunction1<int, int> {
  ClosureEnv_main_45();
  @override
  int call(int x) => ClosureEnv_main_45_call(this, x);
}
int ClosureEnv_main_45_call(ClosureEnv_main_45 env, int x) {
  return (x + 1);
}

class ClosureEnv_main_46 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_46();
  @override
  int call(int a, int b) => ClosureEnv_main_46_call(this, a, b);
}
int ClosureEnv_main_46_call(ClosureEnv_main_46 env, int a, int b) {
  return (a + b);
}

class ClosureEnv_main_47 extends TypeFunction1<int, int> {
  ClosureEnv_main_47();
  @override
  int call(int x) => ClosureEnv_main_47_call(this, x);
}
int ClosureEnv_main_47_call(ClosureEnv_main_47 env, int x) {
  return (x * 2);
}

class ClosureEnv_main_48 extends TypeFunction1<int, int> {
  ClosureEnv_main_48();
  @override
  int call(int x) => ClosureEnv_main_48_call(this, x);
}
int ClosureEnv_main_48_call(ClosureEnv_main_48 env, int x) {
  return (x + 10);
}

class ClosureEnv_main_49 extends TypeFunction1<int, int> {
  ClosureEnv_main_49();
  @override
  int call(int x) => ClosureEnv_main_49_call(this, x);
}
int ClosureEnv_main_49_call(ClosureEnv_main_49 env, int x) {
  return (x * x);
}

class ClosureEnv_main_50 extends TypeFunction1<int, int> {
  ClosureEnv_main_50();
  @override
  int call(int x) => ClosureEnv_main_50_call(this, x);
}
int ClosureEnv_main_50_call(ClosureEnv_main_50 env, int x) {
  return (x * 2);
}

class ClosureEnv_main_51 extends TypeFunction1<int, int> {
  ClosureEnv_main_51();
  @override
  int call(int x) => ClosureEnv_main_51_call(this, x);
}
int ClosureEnv_main_51_call(ClosureEnv_main_51 env, int x) {
  return (x + 10);
}

class ClosureEnv_main_52 extends TypeFunction1<int, int> {
  ClosureEnv_main_52();
  @override
  int call(int x) => ClosureEnv_main_52_call(this, x);
}
int ClosureEnv_main_52_call(ClosureEnv_main_52 env, int x) {
  return (x * x);
}

class ClosureEnv_main_53 extends TypeFunction1<int, int> {
  ClosureEnv_main_53();
  @override
  int call(int n) => ClosureEnv_main_53_call(this, n);
}
int ClosureEnv_main_53_call(ClosureEnv_main_53 env, int n) {
    if ((n <= 1))     return n;
    return n;
  }


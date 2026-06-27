import 'package:dart2cpp/restorer/runtime_classes.dart';

typedef UnaryFunc<A extends dynamic, B extends dynamic> = TypeFunction1<B, A>;

String Serializable_serialize(dynamic this__) {
  final this_ = this__ as dynamic;
  StaticMap<String, dynamic> map = (this_.vptr['toMap'] as Function)(this_);
  String entries = StaticList<String>.of(map.entries.map(ClosureEnv_global_0_new(GC.allocateLocal(ClosureEnv_global_0())))).join(', ');
  return '{${entries}}';
}

bool Validatable_get_isValid(dynamic this__) {
  final this_ = this__ as dynamic;
  return (this_.vptr['validate'] as Function)(this_).isEmpty;
}

String Validatable_get_validationSummary(dynamic this__) {
  final this_ = this__ as dynamic;
  StaticList<String> errors = (this_.vptr['validate'] as Function)(this_);
  if (errors.isEmpty) {
    return 'valid';
  }
  return 'invalid: ${errors.join('; ')}';
}

void Auditable_audit(dynamic this__, String action) {
  final this_ = this__ as dynamic;
  this_._auditLog.add('[${(this_.vptr['get_entityId'] as Function)(this_)}] ${action}');
}

StaticList<String> Auditable_get_auditLog(dynamic this__) {
  final this_ = this__ as dynamic;
  return StaticList<String>.unmodifiable(this_._auditLog);
}

void Cacheable_markDirty(dynamic this__) {
  final this_ = this__ as dynamic;
  this_._isDirty = true;
  return;
}

void Cacheable_markCached(dynamic this__) {
  final this_ = this__ as dynamic;
  this_._isDirty = false;
  this_._cachedAt = StaticDateTime.now();
}

bool Cacheable_get_isDirty(dynamic this__) {
  final this_ = this__ as dynamic;
  return this_._isDirty;
}

String Cacheable_get_cacheStatus(dynamic this__) {
  final this_ = this__ as dynamic;
  return (this_._isDirty ? 'dirty' : 'cached');
}

class TreeNodeValue<T extends dynamic> extends VPtr {
  late T value;
  late TreeNodeValue<T>? left;
  late TreeNodeValue<T>? right;

  TreeNodeValue() {
    vptr['preorder'] = TreeNode_preorder<T>;
    vptr['inorder'] = TreeNode_inorder<T>;
    vptr['get_depth'] = TreeNode_get_depth<T>;
    vptr['map'] = TreeNode_map<T, dynamic>;
    vptr['map_String'] = TreeNode_map<T, String>;
    vptr['toString'] = TreeNode_toString<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

TreeNodeValue<T> TreeNode_new<T extends dynamic>(dynamic this__, T value, [TreeNodeValue<T>? left = null, TreeNodeValue<T>? right = null]) {
  final this_ = this__ as TreeNodeValue<T>;
  this_.value = value;
  this_.left = left;
  this_.right = right;
  return this_;
}

StaticList<T> TreeNode_preorder<T extends dynamic>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  StaticList<T> result = StaticList<T>.of([this_.value]);
  if (!(this_.left == null)) {
    result.addAll((this_.left!.vptr['preorder'] as Function)(this_.left!));
  }
  if (!(this_.right == null)) {
    result.addAll((this_.right!.vptr['preorder'] as Function)(this_.right!));
  }
  return result;
}

StaticList<T> TreeNode_inorder<T extends dynamic>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  StaticList<T> result = StaticList<T>.of([]);
  if (!(this_.left == null)) {
    result.addAll((this_.left!.vptr['inorder'] as Function)(this_.left!));
  }
  result.add(this_.value);
  if (!(this_.right == null)) {
    result.addAll((this_.right!.vptr['inorder'] as Function)(this_.right!));
  }
  return result;
}

int TreeNode_get_depth<T extends dynamic>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  int leftDepth = (() { final _unnamed1 = (() { final _unnamed2 = this_.left; return ((_unnamed2 == null) ? null : (_unnamed2.vptr['get_depth'] as Function)(_unnamed2)); })(); return ((_unnamed1 == null) ? 0 : _unnamed1); })();
  int rightDepth = (() { final _unnamed3 = (() { final _unnamed4 = this_.right; return ((_unnamed4 == null) ? null : (_unnamed4.vptr['get_depth'] as Function)(_unnamed4)); })(); return ((_unnamed3 == null) ? 0 : _unnamed3); })();
  return (1 + ((leftDepth > rightDepth) ? leftDepth : rightDepth));
}

TreeNodeValue<R> TreeNode_map<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as TreeNodeValue<T>;
  return TreeNode_new<R>(TreeNodeValue<R>(), transform(this_.value), (() { final _unnamed5 = this_.left; return ((_unnamed5 == null) ? null : TreeNode_map<T, R>(_unnamed5, transform)); })(), (() { final _unnamed6 = this_.right; return ((_unnamed6 == null) ? null : TreeNode_map<T, R>(_unnamed6, transform)); })());
}

String TreeNode_toString<T extends dynamic>(dynamic this__) {
  final this_ = this__ as TreeNodeValue<T>;
  return 'TreeNode(${this_.value})';
}

class LinkedNodeValue<T extends dynamic> extends VPtr {
  late T data;
  late LinkedNodeValue<T>? next;

  LinkedNodeValue() {
    vptr['reversed'] = LinkedNode_reversed<T>;
    vptr['toList'] = LinkedNode_toList<T>;
    vptr['get_length'] = LinkedNode_get_length<T>;
    vptr['toString'] = LinkedNode_toString<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

LinkedNodeValue<T> LinkedNode_new<T extends dynamic>(dynamic this__, T data, [LinkedNodeValue<T>? next = null]) {
  final this_ = this__ as LinkedNodeValue<T>;
  this_.data = data;
  this_.next = next;
  return this_;
}

LinkedNodeValue<T> LinkedNode_reversed<T extends dynamic>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  if ((this_.next == null)) {
    return LinkedNode_new<T>(LinkedNodeValue<T>(), this_.data);
  }
  LinkedNodeValue<T> rev = (this_.next!.vptr['reversed'] as Function)(this_.next!);
  LinkedNodeValue<T> tail = rev;
  while (!(tail.next == null)) {
    tail = tail.next!;
  }
  tail.next = LinkedNode_new<T>(LinkedNodeValue<T>(), this_.data);
  return rev;
}

StaticList<T> LinkedNode_toList<T extends dynamic>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  StaticList<T> result = StaticList<T>.of([this_.data]);
  LinkedNodeValue<T>? current = this_.next;
  while (!(current == null)) {
    result.add(current!.data);
    current = current!.next;
  }
  return result;
}

int LinkedNode_get_length<T extends dynamic>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  int count = 1;
  LinkedNodeValue<T>? current = this_.next;
  while (!(current == null)) {
    count = (count + 1);
    current = current!.next;
  }
  return count;
}

String LinkedNode_toString<T extends dynamic>(dynamic this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  return 'LinkedNode(${(this_.vptr['toList'] as Function)(this_).join(' -> ')})';
}

class EitherValue<L extends dynamic, R extends dynamic> extends VPtr {
  late L? _left;
  late R? _right;
  late bool _isRight;

  EitherValue() {
    vptr['get_isLeft'] = Either_get_isLeft;
    vptr['get_isRight'] = Either_get_isRight;
    vptr['get_leftValue'] = Either_get_leftValue<L, R>;
    vptr['get_rightValue'] = Either_get_rightValue<L, R>;
    vptr['fold'] = Either_fold<L, R, dynamic>;
    vptr['fold_String'] = Either_fold<L, R, String>;
    vptr['mapRight'] = Either_mapRight<L, R, dynamic>;
    vptr['mapRight_int'] = Either_mapRight<L, R, int>;
    vptr['flatMap'] = Either_flatMap<L, R, dynamic>;
    vptr['flatMap_dynamic'] = Either_flatMap<L, R, dynamic>;
    vptr['toString'] = Either_toString<L, R>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

EitherValue<L, R> Either_new_left<L extends dynamic, R extends dynamic>(dynamic this__, L value) {
  final this_ = this__ as EitherValue<L, R>;
  this_._left = value;
  this_._right = null;
  this_._isRight = false;
  return this_;
}

EitherValue<L, R> Either_new_right<L extends dynamic, R extends dynamic>(dynamic this__, R value) {
  final this_ = this__ as EitherValue<L, R>;
  this_._left = null;
  this_._right = value;
  this_._isRight = true;
  return this_;
}

bool Either_get_isLeft<L extends dynamic, R extends dynamic>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  return !this_._isRight;
}

bool Either_get_isRight<L extends dynamic, R extends dynamic>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  return this_._isRight;
}

L Either_get_leftValue<L extends dynamic, R extends dynamic>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (!(this_.vptr['get_isLeft'] as Function)(this_)) {
    throw DartStateError('Not a left value');
  }
  return (this_._left as L);
}

R Either_get_rightValue<L extends dynamic, R extends dynamic>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (!(this_.vptr['get_isRight'] as Function)(this_)) {
    throw DartStateError('Not a right value');
  }
  return (this_._right as R);
}

T Either_fold<L extends dynamic, R extends dynamic, T extends dynamic>(dynamic this__, TypeFunction1<T, L> onLeft, TypeFunction1<T, R> onRight) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight) {
    return onRight((this_._right as R));
  }
  return onLeft((this_._left as L));
}

EitherValue<L, R2> Either_mapRight<L extends dynamic, R extends dynamic, R2 extends dynamic>(dynamic this__, TypeFunction1<R2, R> transform) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight) {
    return Either_new_right<L, R2>(EitherValue<L, R2>(), transform((this_._right as R)));
  }
  return Either_new_left<L, R2>(EitherValue<L, R2>(), (this_._left as L));
}

EitherValue<L, R2> Either_flatMap<L extends dynamic, R extends dynamic, R2 extends dynamic>(dynamic this__, TypeFunction1<EitherValue<L, R2>, R> transform) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight) {
    return transform((this_._right as R));
  }
  return Either_new_left<L, R2>(EitherValue<L, R2>(), (this_._left as L));
}

String Either_toString<L extends dynamic, R extends dynamic>(dynamic this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight) {
    return 'Right(${this_._right})';
  }
  return 'Left(${this_._left})';
}

class UserProfileValue extends UserProfile_Object_Serializable_ValidatableValue {
  late String name;
  late String email;
  late int age;

  UserProfileValue() {
    vptr['toMap'] = UserProfile_toMap;
    vptr['serialize'] = UserProfile_Object_Serializable_serialize;
    vptr['validate'] = UserProfile_validate;
    vptr['get_isValid'] = UserProfile_Object_Serializable_Validatable_get_isValid;
    vptr['get_validationSummary'] = UserProfile_Object_Serializable_Validatable_get_validationSummary;
    vptr['toString'] = UserProfile_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

UserProfileValue UserProfile_new(dynamic this__, String name, String email, int age) {
  final this_ = this__ as UserProfileValue;
  UserProfile_Object_Serializable_Validatable_new(this_);
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
  StaticList<String> errors = StaticList<String>.of([]);
  if (this_.name.isEmpty) {
    errors.add('name is empty');
  }
  if (!this_.email.contains('@')) {
    errors.add('invalid email');
  }
  if ((this_.age < 0) || (this_.age > 150)) {
    errors.add('invalid age');
  }
  return errors;
}

String UserProfile_toString(dynamic this__) {
  final this_ = this__ as UserProfileValue;
  return 'UserProfile(${this_.name}, ${this_.email}, ${this_.age})';
}

String UserProfile_serialize(dynamic this__) => UserProfile_Object_Serializable_serialize(this__);

bool UserProfile_get_isValid(dynamic this__) => UserProfile_Object_Serializable_Validatable_get_isValid(this__);

String UserProfile_get_validationSummary(dynamic this__) => UserProfile_Object_Serializable_Validatable_get_validationSummary(this__);

class DataTransformerValue<TInput extends dynamic, TOutput extends dynamic> extends VPtr {

  DataTransformerValue() {
    vptr['transform'] = DataTransformer_transform<TInput, TOutput>;
    vptr['preValidate'] = DataTransformer_preValidate<TInput, TOutput>;
    vptr['process'] = DataTransformer_process<TInput, TOutput>;
    vptr['postProcess'] = DataTransformer_postProcess<TInput, TOutput>;
  }
}

DataTransformerValue<TInput, TOutput> DataTransformer_new<TInput extends dynamic, TOutput extends dynamic>(dynamic this__) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return this_;
}

TOutput DataTransformer_transform<TInput extends dynamic, TOutput extends dynamic>(dynamic this__, TInput input) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  TInput validated = (this_.vptr['preValidate'] as Function)(this_, input);
  TOutput processed = (this_.vptr['process'] as Function)(this_, validated);
  return (this_.vptr['postProcess'] as Function)(this_, processed);
}

TInput DataTransformer_preValidate<TInput extends dynamic, TOutput extends dynamic>(dynamic this__, TInput input) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return input;
}

TOutput DataTransformer_process<TInput extends dynamic, TOutput extends dynamic>(dynamic this__) {
  throw UnimplementedError('DataTransformer_process is abstract');
}

TOutput DataTransformer_postProcess<TInput extends dynamic, TOutput extends dynamic>(dynamic this__, TOutput output) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return output;
}

class StringToIntTransformerValue extends DataTransformerValue<String, int> {

  StringToIntTransformerValue() {
    vptr['preValidate'] = StringToIntTransformer_preValidate;
    vptr['process'] = StringToIntTransformer_process;
  }
}

StringToIntTransformerValue StringToIntTransformer_new(dynamic this__) {
  final this_ = this__ as StringToIntTransformerValue;
  DataTransformer_new(this_);
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

int StringToIntTransformer_transform(dynamic this__, String input) => DataTransformer_transform<String, int>(this__, input);

int StringToIntTransformer_postProcess(dynamic this__, int output) => DataTransformer_postProcess<String, int>(this__, output);

class IntToStringTransformerValue extends DataTransformerValue<int, String> {
  late String prefix;

  IntToStringTransformerValue() {
    vptr['process'] = IntToStringTransformer_process;
    vptr['postProcess'] = IntToStringTransformer_postProcess;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

IntToStringTransformerValue IntToStringTransformer_new(dynamic this__, [String prefix = '']) {
  final this_ = this__ as IntToStringTransformerValue;
  DataTransformer_new(this_);
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

String IntToStringTransformer_transform(dynamic this__, int input) => DataTransformer_transform<int, String>(this__, input);

int IntToStringTransformer_preValidate(dynamic this__, int input) => DataTransformer_preValidate<int, String>(this__, input);

class ChainedTransformerValue<A extends dynamic, B extends dynamic, C extends dynamic> extends DataTransformerValue<A, C> {
  late DataTransformerValue<A, B> first;
  late DataTransformerValue<B, C> second;

  ChainedTransformerValue() {
    vptr['process'] = ChainedTransformer_process<A, B, C>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    first?.gcMark(flag);
    second?.gcMark(flag);
  }
}

ChainedTransformerValue<A, B, C> ChainedTransformer_new<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__, DataTransformerValue<A, B> first, DataTransformerValue<B, C> second) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  DataTransformer_new(this_);
  this_.first = first;
  this_.second = second;
  return this_;
}

C ChainedTransformer_process<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  B intermediate = (this_.first.vptr['transform'] as Function)(this_.first, input);
  return (this_.second.vptr['transform'] as Function)(this_.second, intermediate);
}

C ChainedTransformer_transform<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__, A input) => DataTransformer_transform<A, C>(this__, input);

A ChainedTransformer_preValidate<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__, A input) => DataTransformer_preValidate<A, C>(this__, input);

C ChainedTransformer_postProcess<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__, C output) => DataTransformer_postProcess<A, C>(this__, output);

class RegistryValue extends VPtr {
  late StaticMap<String, dynamic> _store = StaticMap<String, dynamic>.of({});
  late int _accessCount = 0;

  RegistryValue() {
    vptr['register'] = Registry_register;
    vptr['lookup'] = Registry_lookup;
    vptr['contains'] = Registry_contains;
    vptr['get_size'] = Registry_get_size;
    vptr['get_accessCount'] = Registry_get_accessCount;
    vptr['get_keys'] = Registry_get_keys;
    vptr['clear'] = Registry_clear;
    vptr['toString'] = Registry_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _store?.gcMark(flag);
  }
}

RegistryValue Registry__instance = Registry_new__internal(RegistryValue());

RegistryValue Registry_new__internal(dynamic this__) {
  final this_ = this__ as RegistryValue;
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
  return (() { final _unnamed7 = StaticList<String>.of(this_._store.keys.toList()); return (() { _unnamed7.sort();
return _unnamed7; })(); })();
}

void Registry_clear(dynamic this__) {
  final this_ = this__ as RegistryValue;
  this_._store.clear();
  this_._accessCount = 0;
}

String Registry_toString(dynamic this__) {
  final this_ = this__ as RegistryValue;
  return 'Registry(size=${(this_.vptr['get_size'] as Function)(this_)}, accesses=${(this_.vptr['get_accessCount'] as Function)(this_)})';
}

class DataProcessorValue extends VPtr {

  DataProcessorValue() {
  }
}

DataProcessorValue DataProcessor_new(dynamic this__) {
  final this_ = this__ as DataProcessorValue;
  return this_;
}

StaticList<StaticMap<String, dynamic>> DataProcessor_processRecords(StaticList<StaticMap<String, dynamic>> records) {
  return (() { final _unnamed8 = StaticList<StaticMap<String, dynamic>>.of(StaticList<StaticMap<String, dynamic>>.of(StaticList<StaticMap<String, dynamic>>.of(StaticList<StaticMap<String, dynamic>>.of(records.where(ClosureEnv_global_1_new(GC.allocateLocal(ClosureEnv_global_1())))).where(ClosureEnv_global_2_new(GC.allocateLocal(ClosureEnv_global_2())))).map(ClosureEnv_global_3_new(GC.allocateLocal(ClosureEnv_global_3())))).toList()); return (() { _unnamed8.sort(ClosureEnv_global_4_new(GC.allocateLocal(ClosureEnv_global_4())));
return _unnamed8; })(); })();
}

String DataProcessor__scoreToGrade(int score) {
  if ((score >= 90)) {
    return 'A';
  }
  if ((score >= 80)) {
    return 'B';
  }
  if ((score >= 70)) {
    return 'C';
  }
  if ((score >= 60)) {
    return 'D';
  }
  return 'F';
}

StaticMap<String, StaticList<StaticMap<String, dynamic>>> DataProcessor_groupByGrade(StaticList<StaticMap<String, dynamic>> records) {
  StaticMap<String, StaticList<StaticMap<String, dynamic>>> groups = StaticMap<String, StaticList<StaticMap<String, dynamic>>>.of({});
  for (final record in records) {
    String grade = (record['grade'] as String);
    groups.putIfAbsent(grade, ClosureEnv_global_5_new(GC.allocateLocal(ClosureEnv_global_5())));
    groups[grade]!.add(record);
  }
  return groups;
}

StaticMap<String, double> DataProcessor_averageByGrade(StaticList<StaticMap<String, dynamic>> records) {
  StaticMap<String, StaticList<StaticMap<String, dynamic>>> groups = DataProcessor_groupByGrade(records);
  return StaticMap<String, double>.of(groups.map(ClosureEnv_global_6_new(GC.allocateLocal(ClosureEnv_global_6()))));
}

class ExpensiveComputationValue extends VPtr {
  late int seed;
  late int computedValue;
  late String description;

  ExpensiveComputationValue() {
    vptr['initialize'] = ExpensiveComputation_initialize;
    vptr['toString'] = ExpensiveComputation_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
  for (int i = 0; (i < 10); i = (i + 1)) {
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

  MathUtilsValue() {
  }
}

MathUtilsValue MathUtils_new(dynamic this__) {
  final this_ = this__ as MathUtilsValue;
  return this_;
}

int MathUtils_fibonacci(int n) {
  StaticMap<int, int> memo = StaticMap<int, int>.of({});
  int fib(int k) {
    if ((k <= 1)) {
      return k;
    }
    if (memo.containsKey(k)) {
      return memo[k]!;
    }
    int result = (fib((k - 1)) + fib((k - 2)));
    memo[k] = result;
    return result;
  }
  return fib(n);
}

StaticList<int> MathUtils_primeFactors(int n) {
  StaticList<int> factors = StaticList<int>.of([]);
  void extractFactor(int factor) {
    while (((n % factor) == 0)) {
      factors.add(factor);
      n = (n ~/ factor);
    }
  }
  extractFactor(2);
  for (int i = 3; ((i * i) <= n); i = (i + 2)) {
    extractFactor(i);
  }
  if ((n > 1)) {
    factors.add(n);
  }
  return factors;
}

int MathUtils_gcd(int a, int b) {
  while (!(b == 0)) {
    int temp = b;
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
    vptr['prettyPrint'] = Printable3_prettyPrint;
  }
}

Printable3Value Printable3_new(dynamic this__) {
  final this_ = this__ as Printable3Value;
  return this_;
}

String Printable3_prettyPrint(dynamic this__) {
  throw UnimplementedError('Printable3_prettyPrint is abstract');
}

class ScoreValue extends VPtr implements Printable3Value {
  late String subject;
  late int points;

  ScoreValue() {
    vptr['prettyPrint'] = Score_prettyPrint;
    vptr['compareTo2'] = Score_compareTo2;
    vptr['isLessThan'] = Score_isLessThan;
    vptr['isGreaterThan'] = Score_isGreaterThan;
    vptr['toString'] = Score_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
  return ((this_.vptr['compareTo2'] as Function)(this_, other) < 0);
}

bool Score_isGreaterThan(dynamic this__, ScoreValue other) {
  final this_ = this__ as ScoreValue;
  return ((this_.vptr['compareTo2'] as Function)(this_, other) > 0);
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
    vptr['prettyPrint'] = WeightedScore_prettyPrint;
    vptr['compareTo2'] = WeightedScore_compareTo2;
    vptr['toString'] = WeightedScore_toString;
    vptr['get_weightedPoints'] = WeightedScore_get_weightedPoints;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
  if (other is WeightedScoreValue) {
    return (this_.vptr['get_weightedPoints'] as Function)(this_).compareTo((other.vptr['get_weightedPoints'] as Function)(other));
  }
  return Score_compareTo2(this_, other);
}

String WeightedScore_prettyPrint(dynamic this__) {
  final this_ = this__ as WeightedScoreValue;
  return '[${this_.subject}: ${this_.points} pts × ${this_.weight} = ${dart_str_toStringAsFixed((this_.vptr['get_weightedPoints'] as Function)(this_), 1)}]';
}

String WeightedScore_toString(dynamic this__) {
  final this_ = this__ as WeightedScoreValue;
  return 'WeightedScore(${this_.subject}, ${this_.points}, w=${this_.weight})';
}

bool WeightedScore_isLessThan(dynamic this__, ScoreValue other) => Score_isLessThan(this__, other);

bool WeightedScore_isGreaterThan(dynamic this__, ScoreValue other) => Score_isGreaterThan(this__, other);

class TextProcessorValue extends VPtr {

  TextProcessorValue() {
  }
}

TextProcessorValue TextProcessor_new(dynamic this__) {
  final this_ = this__ as TextProcessorValue;
  return this_;
}

String TextProcessor_camelToSnake(String input) {
  StaticStringBuffer result = StaticStringBuffer();
  for (int i = 0; (i < input.length); i = (i + 1)) {
    String char = input[i];
    if ((char == char.toUpperCase()) && !(char == char.toLowerCase()) && (i > 0)) {
      result.write('_');
    }
    result.write(char.toLowerCase());
  }
  return result.toString();
}

String TextProcessor_snakeToCamel(String input) {
  StaticList<String> parts = StaticList<String>.of(input.split('_'));
  if (parts.isEmpty) {
    return input;
  }
  String first = parts[0];
  String rest = StaticList<String>.of(StaticList<String>.of(parts.skip(1)).map(ClosureEnv_global_8_new(GC.allocateLocal(ClosureEnv_global_8())))).join();
  return '${first}${rest}';
}

StaticMap<String, int> TextProcessor_wordFrequency(String text) {
  StaticList<String> words = StaticList<String>.of(StaticList<String>.of(StaticList<String>.of(text.toLowerCase().replaceAll(StaticRegExp('[^a-z\\s]'), '').split(StaticRegExp('\\s+'))).where(ClosureEnv_global_9_new(GC.allocateLocal(ClosureEnv_global_9())))).toList());
  StaticMap<String, int> freq = StaticMap<String, int>.of({});
  for (final word in words) {
    freq[word] = ((() { final _unnamed9 = freq[word]; return ((_unnamed9 == null) ? 0 : _unnamed9); })() + 1);
  }
  return freq;
}

String TextProcessor_truncate(String text, int maxLength, {String suffix = '...'}) {
  if ((text.length <= maxLength)) {
    return text;
  }
  return '${text.substring(0, (maxLength - suffix.length))}${suffix}';
}

enum Season {
  spring,
  summer,
  autumn,
  winter;
}

String Season_get_displayName(dynamic this__) {
  final this_ = this__ as Season;
  do {
    switch (this_) {
      case Season.spring:
        return 'Spring';
      case Season.summer:
        return 'Summer';
      case Season.autumn:
        return 'Autumn';
      case Season.winter:
        return 'Winter';
    }
  } while (false);
}

Season Season_get_next(dynamic this__) {
  final this_ = this__ as Season;
  do {
    switch (this_) {
      case Season.spring:
        return Season.summer;
      case Season.summer:
        return Season.autumn;
      case Season.autumn:
        return Season.winter;
      case Season.winter:
        return Season.spring;
    }
  } while (false);
}

bool Season_get_isWarm(dynamic this__) {
  final this_ = this__ as Season;
  return (this_ == Season.spring) || (this_ == Season.summer);
}

class JsonLikeProcessorValue extends VPtr {

  JsonLikeProcessorValue() {
  }
}

JsonLikeProcessorValue JsonLikeProcessor_new(dynamic this__) {
  final this_ = this__ as JsonLikeProcessorValue;
  return this_;
}

dynamic JsonLikeProcessor_deepMerge(StaticMap<String, dynamic> base, StaticMap<String, dynamic> overlay) {
  StaticMap<String, dynamic> result = StaticMap.from(base);
  for (final key in overlay.keys) {
    if (result.containsKey(key) && result[key] is StaticMap<String, dynamic> && overlay[key] is StaticMap<String, dynamic>) {
      result[key] = JsonLikeProcessor_deepMerge((result[key] as StaticMap<String, dynamic>), (overlay[key] as StaticMap<String, dynamic>));
    } else {
      result[key] = overlay[key];
    }
  }
  return result;
}

StaticList<String> JsonLikeProcessor_flattenKeys(StaticMap<String, dynamic> map, {String prefix = ''}) {
  StaticList<String> keys = StaticList<String>.of([]);
  for (final entry in map.entries) {
    String fullKey = (prefix.isEmpty ? entry.key : '${prefix}.${entry.key}');
    if (entry.value is StaticMap<String, dynamic>) {
      keys.addAll(JsonLikeProcessor_flattenKeys((entry.value as StaticMap<String, dynamic>)));
    } else {
      keys.add(fullKey);
    }
  }
  return (() { final _unnamed10 = keys; return (() { _unnamed10.sort();
return _unnamed10; })(); })();
}

class Matrix2DValue extends VPtr {
  late StaticList<StaticList<double>> _data;
  late int rows;
  late int cols;

  Matrix2DValue() {
    vptr['get'] = Matrix2D_get;
    vptr['operatorPlus'] = Matrix2D_operatorPlus;
    vptr['operatorStar'] = Matrix2D_operatorStar;
    vptr['get_trace'] = Matrix2D_get_trace;
    vptr['toString'] = Matrix2D_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _data?.gcMark(flag);
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
  this_._data = StaticList<StaticList<double>>.generate(rows, ClosureEnv_global_10_new(GC.allocateLocal(ClosureEnv_global_10()), cols));
  return this_;
}

Matrix2DValue Matrix2D_new_identity(dynamic this__, int size) {
  final this_ = this__ as Matrix2DValue;
  this_.rows = size;
  this_.cols = size;
  this_._data = StaticList<StaticList<double>>.generate(size, ClosureEnv_global_11_new(GC.allocateLocal(ClosureEnv_global_11()), size));
  return this_;
}

double Matrix2D_get(dynamic this__, int row, int col) {
  final this_ = this__ as Matrix2DValue;
  return this_._data[row][col];
}

Matrix2DValue Matrix2D_operatorPlus(dynamic this__, Matrix2DValue other) {
  final this_ = this__ as Matrix2DValue;
  Matrix2DValue result = Matrix2D_new_zeros(Matrix2DValue(), this_.rows, this_.cols);
  for (int i = 0; (i < this_.rows); i = (i + 1)) {
    for (int j = 0; (j < this_.cols); j = (j + 1)) {
      result._data[i][j] = (this_._data[i][j] + other._data[i][j]);
    }
  }
  return result;
}

Matrix2DValue Matrix2D_operatorStar(dynamic this__, Matrix2DValue other) {
  final this_ = this__ as Matrix2DValue;
  Matrix2DValue result = Matrix2D_new_zeros(Matrix2DValue(), this_.rows, other.cols);
  for (int i = 0; (i < this_.rows); i = (i + 1)) {
    for (int j = 0; (j < other.cols); j = (j + 1)) {
      double sum = 0.0;
      for (int k = 0; (k < this_.cols); k = (k + 1)) {
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
  int minDim = ((this_.rows < this_.cols) ? this_.rows : this_.cols);
  for (int i = 0; (i < minDim); i = (i + 1)) {
    sum = (sum + this_._data[i][i]);
  }
  return sum;
}

String Matrix2D_toString(dynamic this__) {
  final this_ = this__ as Matrix2DValue;
  String rowStrings = StaticList<String>.of(StaticList<String>.of(this_._data.map(ClosureEnv_global_13_new(GC.allocateLocal(ClosureEnv_global_13())))).map(ClosureEnv_global_15_new(GC.allocateLocal(ClosureEnv_global_15())))).join(', ');
  return 'Matrix(${this_.rows}x${this_.cols}: ${rowStrings})';
}

class EntityValue extends VPtr {

  EntityValue() {
    vptr['get_entityId'] = Entity_get_entityId;
  }
}

EntityValue Entity_new(dynamic this__) {
  final this_ = this__ as EntityValue;
  return this_;
}

String Entity_get_entityId(dynamic this__) {
  throw UnimplementedError('Entity_get_entityId is abstract');
}

class ProductValue extends Product_Entity_Auditable_CacheableValue {
  late String entityId;
  late String name;
  late double price;

  ProductValue() {
    vptr['get_entityId'] = Product_get_entityId;
    vptr['audit'] = Product_Entity_Auditable_audit;
    vptr['get_auditLog'] = Product_Entity_Auditable_get_auditLog;
    vptr['markDirty'] = Product_Entity_Auditable_Cacheable_markDirty;
    vptr['markCached'] = Product_Entity_Auditable_Cacheable_markCached;
    vptr['get_isDirty'] = Product_Entity_Auditable_Cacheable_get_isDirty;
    vptr['get_cacheStatus'] = Product_Entity_Auditable_Cacheable_get_cacheStatus;
    vptr['toString'] = Product_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

ProductValue Product_new(dynamic this__, String entityId, String name, double price) {
  final this_ = this__ as ProductValue;
  Product_Entity_Auditable_Cacheable_new(this_);
  this_.entityId = entityId;
  this_.name = name;
  this_.price = price;
  return this_;
}

String Product_toString(dynamic this__) {
  final this_ = this__ as ProductValue;
  return 'Product(${this_.entityId}, ${this_.name}, \$${this_.price}, ${(this_.vptr['get_cacheStatus'] as Function)(this_)}, audits=${this_._auditLog.length})';
}

String Product_get_entityId(dynamic this__) {
  final this_ = this__ as ProductValue;
  return this_.entityId;
}

void Product_audit(dynamic this__, String action) { Product_Entity_Auditable_audit(this__, action); }

StaticList<String> Product_get_auditLog(dynamic this__) => Product_Entity_Auditable_get_auditLog(this__);

void Product_markDirty(dynamic this__) { Product_Entity_Auditable_Cacheable_markDirty(this__); }

void Product_markCached(dynamic this__) { Product_Entity_Auditable_Cacheable_markCached(this__); }

bool Product_get_isDirty(dynamic this__) => Product_Entity_Auditable_Cacheable_get_isDirty(this__);

String Product_get_cacheStatus(dynamic this__) => Product_Entity_Auditable_Cacheable_get_cacheStatus(this__);

class UserProfile_Object_SerializableValue extends VPtr {

  UserProfile_Object_SerializableValue() {
    vptr['toMap'] = UserProfile_Object_Serializable_toMap;
    vptr['serialize'] = UserProfile_Object_Serializable_serialize;
  }
}

UserProfile_Object_SerializableValue UserProfile_Object_Serializable_new(dynamic this__) {
  final this_ = this__ as UserProfile_Object_SerializableValue;
  return this_;
}

StaticMap<String, dynamic> UserProfile_Object_Serializable_toMap(dynamic this__) {
  throw UnimplementedError('UserProfile_Object_Serializable_toMap is abstract');
}

String UserProfile_Object_Serializable_serialize(dynamic this__) {
  final this_ = this__ as UserProfile_Object_SerializableValue;
  return Serializable_serialize(this_);
}

class UserProfile_Object_Serializable_ValidatableValue extends UserProfile_Object_SerializableValue {

  UserProfile_Object_Serializable_ValidatableValue() {
    vptr['validate'] = UserProfile_Object_Serializable_Validatable_validate;
    vptr['get_isValid'] = UserProfile_Object_Serializable_Validatable_get_isValid;
    vptr['get_validationSummary'] = UserProfile_Object_Serializable_Validatable_get_validationSummary;
  }
}

UserProfile_Object_Serializable_ValidatableValue UserProfile_Object_Serializable_Validatable_new(dynamic this__) {
  final this_ = this__ as UserProfile_Object_Serializable_ValidatableValue;
  UserProfile_Object_Serializable_new(this_);
  return this_;
}

StaticList<String> UserProfile_Object_Serializable_Validatable_validate(dynamic this__) {
  throw UnimplementedError('UserProfile_Object_Serializable_Validatable_validate is abstract');
}

bool UserProfile_Object_Serializable_Validatable_get_isValid(dynamic this__) {
  final this_ = this__ as UserProfile_Object_Serializable_ValidatableValue;
  return Validatable_get_isValid(this_);
}

String UserProfile_Object_Serializable_Validatable_get_validationSummary(dynamic this__) {
  final this_ = this__ as UserProfile_Object_Serializable_ValidatableValue;
  return Validatable_get_validationSummary(this_);
}

StaticMap<String, dynamic> UserProfile_Object_Serializable_Validatable_toMap(dynamic this__) => UserProfile_Object_Serializable_toMap(this__);

String UserProfile_Object_Serializable_Validatable_serialize(dynamic this__) => UserProfile_Object_Serializable_serialize(this__);

class Product_Entity_AuditableValue extends EntityValue {
  late StaticList<String> _auditLog = StaticList<String>.of([]);

  Product_Entity_AuditableValue() {
    vptr['audit'] = Product_Entity_Auditable_audit;
    vptr['get_auditLog'] = Product_Entity_Auditable_get_auditLog;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _auditLog?.gcMark(flag);
  }
}

Product_Entity_AuditableValue Product_Entity_Auditable_new(dynamic this__) {
  final this_ = this__ as Product_Entity_AuditableValue;
  Entity_new(this_);
  return this_;
}

void Product_Entity_Auditable_audit(dynamic this__, String action) {
  final this_ = this__ as Product_Entity_AuditableValue;
  Auditable_audit(this_, action);
  return;
}

StaticList<String> Product_Entity_Auditable_get_auditLog(dynamic this__) {
  final this_ = this__ as Product_Entity_AuditableValue;
  return Auditable_get_auditLog(this_);
}

String Product_Entity_Auditable_get_entityId(dynamic this__) => Entity_get_entityId(this__);

class Product_Entity_Auditable_CacheableValue extends Product_Entity_AuditableValue {
  late StaticList<String> _auditLog = StaticList<String>.of([]);
  late StaticDateTime? _cachedAt = null;
  late bool _isDirty = true;

  Product_Entity_Auditable_CacheableValue() {
    vptr['markDirty'] = Product_Entity_Auditable_Cacheable_markDirty;
    vptr['markCached'] = Product_Entity_Auditable_Cacheable_markCached;
    vptr['get_isDirty'] = Product_Entity_Auditable_Cacheable_get_isDirty;
    vptr['get_cacheStatus'] = Product_Entity_Auditable_Cacheable_get_cacheStatus;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _auditLog?.gcMark(flag);
  }
}

Product_Entity_Auditable_CacheableValue Product_Entity_Auditable_Cacheable_new(dynamic this__) {
  final this_ = this__ as Product_Entity_Auditable_CacheableValue;
  Product_Entity_Auditable_new(this_);
  return this_;
}

void Product_Entity_Auditable_Cacheable_markDirty(dynamic this__) {
  final this_ = this__ as Product_Entity_Auditable_CacheableValue;
  Cacheable_markDirty(this_);
  return;
}

void Product_Entity_Auditable_Cacheable_markCached(dynamic this__) {
  final this_ = this__ as Product_Entity_Auditable_CacheableValue;
  Cacheable_markCached(this_);
  return;
}

bool Product_Entity_Auditable_Cacheable_get_isDirty(dynamic this__) {
  final this_ = this__ as Product_Entity_Auditable_CacheableValue;
  return Cacheable_get_isDirty(this_);
}

String Product_Entity_Auditable_Cacheable_get_cacheStatus(dynamic this__) {
  final this_ = this__ as Product_Entity_Auditable_CacheableValue;
  return Cacheable_get_cacheStatus(this_);
}

String Product_Entity_Auditable_Cacheable_get_entityId(dynamic this__) => Entity_get_entityId(this__);

void Product_Entity_Auditable_Cacheable_audit(dynamic this__, String action) { Product_Entity_Auditable_audit(this__, action); }

StaticList<String> Product_Entity_Auditable_Cacheable_get_auditLog(dynamic this__) => Product_Entity_Auditable_get_auditLog(this__);

dynamic makeCounter({int start = 0, int step = 1}) {
  int current = start;
  return ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()), current, step);
}

dynamic makeAccumulator(int initial) {
  int total = initial;
  return ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()), total);
}

StaticList<dynamic> makeClosureList(int count) {
  StaticList<dynamic> closures = StaticList<dynamic>.of([]);
  for (int i = 0; (i < count); i = (i + 1)) {
    closures.add(ClosureEnv_global_19_new(GC.allocateLocal(ClosureEnv_global_19()), i));
  }
  return closures;
}

TypeFunction1<C, A> composeFunc<A extends dynamic, B extends dynamic, C extends dynamic>(TypeFunction1<C, B> funcBC, TypeFunction1<B, A> funcAB) {
  return ClosureEnv_global_20_new<C, B, A>(GC.allocateLocal(ClosureEnv_global_20<C, B, A>()), funcBC, funcAB);
}

TypeFunction1<TypeFunction1<C, B>, A> curry<A extends dynamic, B extends dynamic, C extends dynamic>(TypeFunction2<C, A, B> biFunc) {
  return ClosureEnv_global_21_new<C, A, B>(GC.allocateLocal(ClosureEnv_global_21<C, A, B>()), biFunc);
}

T pipe<T extends dynamic>(T value, StaticList<TypeFunction1<T, T>> transforms) {
  T result = value;
  for (final transform in transforms) {
    result = transform(result);
  }
  return result;
}

TypeFunction1<B, A> memoize<A extends dynamic, B extends dynamic>(TypeFunction1<B, A> func) {
  StaticMap<A, B> cache = StaticMap<A, B>.of({});
  return ClosureEnv_global_23_new<A, B>(GC.allocateLocal(ClosureEnv_global_23<A, B>()), cache, func);
}

String classifyNumber(int number) {
  String result = '';
  if ((number < 0)) {
    result = 'negative';
    if (((number % 2) == 0)) {
      result = (result + '_even');
    } else {
      result = (result + '_odd');
    }
    if ((number < -100)) {
      result = (result + '_large');
    } else {
      if ((number < -10)) {
        result = (result + '_medium');
      } else {
        result = (result + '_small');
      }
    }
  } else {
    if ((number == 0)) {
      result = 'zero';
    } else {
      result = 'positive';
      bool isPrime = (number > 1);
      do {
        for (int i = 2; ((i * i) <= number); i = (i + 1)) {
          if (((number % i) == 0)) {
            isPrime = false;
            break;
          }
        }
      } while (false);
      if (isPrime && (number > 1)) {
        result = (result + '_prime');
      } else {
        if ((number > 1)) {
          do {
            for (int i = 2; (i <= number); i = (i + 1)) {
              if (((number % i) == 0)) {
                result = (result + '_composite(smallest_factor=${i})');
                break;
              }
            }
          } while (false);
        }
      }
    }
  }
  return result;
}

StaticList<int> parseNumbers(StaticList<String> inputs) {
  StaticList<int> results = StaticList<int>.of([]);
  for (int i = 0; (i < inputs.length); i = (i + 1)) {
    do {
      try {
        String trimmed = inputs[i].trim();
        if (trimmed.isEmpty) {
          break;
        }
        int value = int.parse(trimmed);
        if ((value < 0)) {
          throw DartArgumentError('Negative value at index ${i}: ${value}');
        }
        results.add(value);
      } on FormatException catch ( _) {
        results.add(-1);
      } on ArgumentError catch ( e) {
        results.add(-2);
      }
    } while (false);
  }
  return results;
}

Promise<int> asyncAdd(int a, int b) {
  smAwait(promiseDelayed(StaticDuration(milliseconds: 1), () => null));
  return Promise.value<int>((a + b));
}

Promise<String> asyncTransform(int value) {
  int doubled = smAwait(asyncAdd(value, value));
  int tripled = smAwait(asyncAdd(doubled, value));
  return Promise.value<String>('value=${value}, doubled=${doubled}, tripled=${tripled}');
}

Promise<StaticList<int>> asyncSequence(int count) {
  StaticList<int> results = StaticList<int>.of([]);
  for (int i = 0; (i < count); i = (i + 1)) {
    int value = smAwait(asyncAdd(i, (i * i)));
    results.add(value);
  }
  return Promise.value<StaticList<int>>(results);
}

bool IntMathExtension_get_isPrime(int this_) {
  if ((this_ <= 1)) {
    return false;
  }
  if ((this_ <= 3)) {
    return true;
  }
  if (((this_ % 2) == 0) || ((this_ % 3) == 0)) {
    return false;
  }
  for (int i = 5; ((i * i) <= this_); i = (i + 6)) {
    if (((this_ % i) == 0) || ((this_ % (i + 2)) == 0)) {
      return false;
    }
  }
  return true;
}

int IntMathExtension_get_factorial(int this_) {
  if ((this_ < 0)) {
    throw DartArgumentError('Factorial not defined for negative numbers');
  }
  if ((this_ <= 1)) {
    return 1;
  }
  int result = 1;
  for (int i = 2; (i <= this_); i = (i + 1)) {
    result = (result * i);
  }
  return result;
}

StaticList<int> IntMathExtension_get_digits(int this_) {
  if ((this_ == 0)) {
    return StaticList<int>.of([0]);
  }
  StaticList<int> result = StaticList<int>.of([]);
  int n = this_.abs();
  while ((n > 0)) {
    result.insert(0, (n % 10));
    n = (n ~/ 10);
  }
  return result;
}

T IterableStats_get_sum<T extends dynamic>(StaticList<T> this_) {
  return this_.reduce(ClosureEnv_global_24_new<T>(GC.allocateLocal(ClosureEnv_global_24<T>())));
}

double IterableStats_get_average<T extends dynamic>(StaticList<T> this_) {
  return (this_.isEmpty ? 0.0 : (IterableStats_get_sum(this_) / this_.length));
}

T IterableStats_get_max<T extends dynamic>(StaticList<T> this_) {
  return this_.reduce(ClosureEnv_global_25_new<T>(GC.allocateLocal(ClosureEnv_global_25<T>())));
}

T IterableStats_get_min<T extends dynamic>(StaticList<T> this_) {
  return this_.reduce(ClosureEnv_global_26_new<T>(GC.allocateLocal(ClosureEnv_global_26<T>())));
}

void main() {
  staticPrint('=== 高级语法还原测试 ===\n');
  staticPrint('--- 1. 嵌套闭包 ---');
  dynamic counter = makeCounter(start: 5, step: 3);
  staticPrint('counter: ${counter()}, ${counter()}, ${counter()}');
  dynamic acc = makeAccumulator(100);
  dynamic snap1 = acc(10);
  dynamic snap2 = acc(20);
  staticPrint('snap1: ${snap1.call()}');
  staticPrint('snap2: ${snap2.call()}');
  StaticList<dynamic> closures = makeClosureList(4);
  for (final cl in closures) {
    staticPrint('  ${cl()}');
  }
  staticPrint('\n--- 2. 二叉树 ---');
  TreeNodeValue<int> tree = TreeNode_new<int>(TreeNodeValue<int>(), 1, TreeNode_new<int>(TreeNodeValue<int>(), 2, TreeNode_new<int>(TreeNodeValue<int>(), 4), TreeNode_new<int>(TreeNodeValue<int>(), 5)), TreeNode_new<int>(TreeNodeValue<int>(), 3, null, TreeNode_new<int>(TreeNodeValue<int>(), 6)));
  staticPrint('preorder: ${(tree.vptr['preorder'] as Function)(tree)}');
  staticPrint('inorder: ${(tree.vptr['inorder'] as Function)(tree)}');
  staticPrint('depth: ${(tree.vptr['get_depth'] as Function)(tree)}');
  TreeNodeValue<String> strTree = (tree.vptr['map_String'] as Function)(tree, ClosureEnv_global_27_new(GC.allocateLocal(ClosureEnv_global_27())));
  staticPrint('mapped preorder: ${(strTree.vptr['preorder'] as Function)(strTree)}');
  staticPrint('\n--- 3. 链表 ---');
  LinkedNodeValue<int> list = LinkedNode_new<int>(LinkedNodeValue<int>(), 1, LinkedNode_new<int>(LinkedNodeValue<int>(), 2, LinkedNode_new<int>(LinkedNodeValue<int>(), 3, LinkedNode_new<int>(LinkedNodeValue<int>(), 4))));
  staticPrint('list: ${list}');
  staticPrint('length: ${(list.vptr['get_length'] as Function)(list)}');
  LinkedNodeValue<int> revList = (list.vptr['reversed'] as Function)(list);
  staticPrint('reversed: ${revList}');
  staticPrint('\n--- 4. Either ---');
  EitherValue<String, int> right = Either_new_right<String, int>(EitherValue<String, int>(), 42);
  EitherValue<String, int> left = Either_new_left<String, int>(EitherValue<String, int>(), 'error');
  staticPrint('right: ${right}');
  staticPrint('left: ${left}');
  staticPrint('right.fold: ${(right.vptr['fold_String'] as Function)(right, ClosureEnv_global_28_new(GC.allocateLocal(ClosureEnv_global_28())), ClosureEnv_global_29_new(GC.allocateLocal(ClosureEnv_global_29())))}');
  staticPrint('left.fold: ${(left.vptr['fold_String'] as Function)(left, ClosureEnv_global_30_new(GC.allocateLocal(ClosureEnv_global_30())), ClosureEnv_global_31_new(GC.allocateLocal(ClosureEnv_global_31())))}');
  EitherValue<String, int> mapped = (right.vptr['mapRight_int'] as Function)(right, ClosureEnv_global_32_new(GC.allocateLocal(ClosureEnv_global_32())));
  staticPrint('mapped right: ${mapped}');
  EitherValue<String, dynamic> chained = (right.vptr['flatMap_dynamic'] as Function)(right, ClosureEnv_global_33_new(GC.allocateLocal(ClosureEnv_global_33())));
  staticPrint('chained: ${chained}');
  staticPrint('\n--- 5. 函数式编程 ---');
  TypeFunction1<int, int> double2 = ClosureEnv_global_34_new(GC.allocateLocal(ClosureEnv_global_34()));
  TypeFunction1<int, int> addOne = ClosureEnv_global_35_new(GC.allocateLocal(ClosureEnv_global_35()));
  TypeFunction1<int, int> composed = composeFunc(addOne, double2);
  staticPrint('compose(double, addOne)(5): ${composed(5)}');
  TypeFunction1<TypeFunction1<int, int>, int> curriedAdd = curry(ClosureEnv_global_36_new(GC.allocateLocal(ClosureEnv_global_36())));
  TypeFunction1<int, int> add10 = curriedAdd(10);
  staticPrint('curriedAdd(10)(5): ${add10(5)}');
  int piped = pipe(3, StaticList<TypeFunction1<int, int>>.of([ClosureEnv_global_37_new(GC.allocateLocal(ClosureEnv_global_37())), ClosureEnv_global_38_new(GC.allocateLocal(ClosureEnv_global_38())), ClosureEnv_global_39_new(GC.allocateLocal(ClosureEnv_global_39()))]));
  staticPrint('pipe(3, [*2, +10, ^2]): ${piped}');
  TypeFunction1<int, int> memoFib = memoize(ClosureEnv_global_40_new(GC.allocateLocal(ClosureEnv_global_40())));
  staticPrint('memoized(10): ${memoFib(10)}');
  staticPrint('memoized(10) again: ${memoFib(10)}');
  staticPrint('\n--- 6. 多重嵌套控制流 ---');
  StaticList<int> testNumbers = StaticList<int>.of([-150, -42, -3, 0, 1, 7, 12, 97]);
  for (final n in testNumbers) {
    staticPrint('  ${n} → ${classifyNumber(n)}');
  }
  staticPrint('parseNumbers: ${parseNumbers(StaticList<String>.of(['10', 'abc', ' 42 ', '-5', '', '7']))}');
  staticPrint('\n--- 7. mixin 组合 ---');
  UserProfileValue user1 = UserProfile_new(UserProfileValue(), 'Alice', 'alice@example.com', 25);
  staticPrint('user1: ${user1}');
  staticPrint('serialize: ${(user1.vptr['serialize'] as Function)(user1)}');
  staticPrint('validation: ${(user1.vptr['get_validationSummary'] as Function)(user1)}');
  UserProfileValue user2 = UserProfile_new(UserProfileValue(), '', 'invalid-email', -5);
  staticPrint('user2 validation: ${(user2.vptr['get_validationSummary'] as Function)(user2)}');
  staticPrint('\n--- 8. 模板方法模式 ---');
  StringToIntTransformerValue strToInt = StringToIntTransformer_new(StringToIntTransformerValue());
  staticPrint('strToInt("  42  "): ${(strToInt.vptr['transform'] as Function)(strToInt, '  42  ')}');
  IntToStringTransformerValue intToStr = IntToStringTransformer_new(IntToStringTransformerValue(), 'NUM:');
  staticPrint('intToStr(123): ${(intToStr.vptr['transform'] as Function)(intToStr, 123)}');
  ChainedTransformerValue<String, int, String> chained2 = ChainedTransformer_new<String, int, String>(ChainedTransformerValue<String, int, String>(), strToInt, intToStr);
  staticPrint('chained(" 99 "): ${(chained2.vptr['transform'] as Function)(chained2, ' 99 ')}');
  staticPrint('\n--- 9. 单例 Registry ---');
  RegistryValue reg1 = Registry_new();
  RegistryValue reg2 = Registry_new();
  staticPrint('same instance: ${identical(reg1, reg2)}');
  (reg1.vptr['register'] as Function)(reg1, 'name', 'Dart');
  (reg1.vptr['register'] as Function)(reg1, 'version', 3);
  staticPrint('registry: ${reg1}');
  staticPrint('lookup name: ${(reg2.vptr['lookup'] as Function)(reg2, 'name')}');
  staticPrint('keys: ${(reg1.vptr['get_keys'] as Function)(reg1)}');
  (reg1.vptr['clear'] as Function)(reg1);
  staticPrint('\n--- 10. 集合操作链 ---');
  StaticList<StaticMap<String, dynamic>> records = StaticList<StaticMap<String, dynamic>>.of([StaticMap<String, dynamic>.of({'name': 'Alice', 'score': 95}), StaticMap<String, dynamic>.of({'name': 'Bob', 'score': 72}), StaticMap<String, dynamic>.of({'name': 'Carol', 'score': 88}), StaticMap<String, dynamic>.of({'name': 'Dave', 'score': 45}), StaticMap<String, dynamic>.of({'name': 'Eve', 'score': 91}), StaticMap<String, dynamic>.of({'name': 'Frank', 'score': 63})]);
  StaticList<StaticMap<String, dynamic>> processed = DataProcessor_processRecords(records);
  for (final r in processed) {
    staticPrint('  ${r['name']}: ${r['score']} (${r['grade']}, passed=${r['passed']})');
  }
  StaticMap<String, double> averages = DataProcessor_averageByGrade(processed);
  staticPrint('averages: ${averages}');
  staticPrint('\n--- 11. late 变量 ---');
  ExpensiveComputationValue comp = ExpensiveComputation_new(ExpensiveComputationValue(), 42);
  staticPrint('comp: ${comp}');
  staticPrint('computedValue: ${comp.computedValue}');
  (comp.vptr['initialize'] as Function)(comp, 'test description');
  staticPrint('description: ${comp.description}');
  staticPrint('\n--- 12. 局部函数 + 递归 ---');
  staticPrint('fibonacci(10): ${MathUtils_fibonacci(10)}');
  staticPrint('fibonacci(20): ${MathUtils_fibonacci(20)}');
  staticPrint('primeFactors(360): ${MathUtils_primeFactors(360)}');
  staticPrint('gcd(48, 18): ${MathUtils_gcd(48, 18)}');
  staticPrint('lcm(12, 18): ${MathUtils_lcm(12, 18)}');
  staticPrint('\n--- 13. 多重 implements ---');
  StaticList<ScoreValue> scores = StaticList<ScoreValue>.of([Score_new(ScoreValue(), 'Math', 90), Score_new(ScoreValue(), 'English', 75), WeightedScore_new(WeightedScoreValue(), 'Physics', 85, 1.5), WeightedScore_new(WeightedScoreValue(), 'Art', 95, 0.5)]);
  for (final s in scores) {
    staticPrint('  ${(s.vptr['prettyPrint'] as Function)(s)}');
  }
  WeightedScoreValue ws1 = (scores[2] as WeightedScoreValue);
  WeightedScoreValue ws2 = (scores[3] as WeightedScoreValue);
  staticPrint('physics > art (weighted): ${(ws1.vptr['isGreaterThan'] as Function)(ws1, ws2)}');
  staticPrint('\n--- 14. 字符串操作 ---');
  staticPrint('camelToSnake("helloWorldFoo"): ${TextProcessor_camelToSnake('helloWorldFoo')}');
  staticPrint('snakeToCamel("hello_world_foo"): ${TextProcessor_snakeToCamel('hello_world_foo')}');
  StaticMap<String, int> freq = TextProcessor_wordFrequency('the quick brown fox jumps over the lazy fox');
  staticPrint('word frequency: ${freq}');
  staticPrint('truncate: ${TextProcessor_truncate('Hello, World! This is a long string.', 20)}');
  staticPrint('\n--- 15. async 链 ---');
  String asyncResult = smAwait(asyncTransform(5));
  staticPrint('asyncTransform(5): ${asyncResult}');
  StaticList<int> asyncSeq = smAwait(asyncSequence(5));
  staticPrint('asyncSequence(5): ${asyncSeq}');
  staticPrint('\n--- 16. 增强枚举 ---');
  for (final s in StaticList.of([Season.spring, Season.summer, Season.autumn, Season.winter])) {
    staticPrint('  ${s} → ${Season_get_displayName(s)}, next=${Season_get_displayName(Season_get_next(s))}, warm=${Season_get_isWarm(s)}');
  }
  staticPrint('\n--- 17. 嵌套 Map 操作 ---');
  StaticMap<String, dynamic> base = StaticMap<String, dynamic>.of({'a': 1, 'b': StaticMap<String, int>.of({'x': 10, 'y': 20}), 'c': 3});
  StaticMap<String, dynamic> overlay = StaticMap<String, dynamic>.of({'b': StaticMap<String, int>.of({'y': 99, 'z': 30}), 'd': 4});
  dynamic merged = JsonLikeProcessor_deepMerge(base, overlay);
  staticPrint('deepMerge: ${merged}');
  StaticMap<String, dynamic> nested = StaticMap<String, dynamic>.of({'user': StaticMap<String, dynamic>.of({'name': 'Alice', 'address': StaticMap<String, String>.of({'city': 'NYC', 'zip': '10001'})}), 'role': 'admin'});
  staticPrint('flattenKeys: ${JsonLikeProcessor_flattenKeys(nested)}');
  staticPrint('\n--- 18. 扩展方法 ---');
  staticPrint('7.isPrime: ${IntMathExtension_get_isPrime(7)}');
  staticPrint('12.isPrime: ${IntMathExtension_get_isPrime(12)}');
  staticPrint('5.factorial: ${IntMathExtension_get_factorial(5)}');
  staticPrint('12345.digits: ${IntMathExtension_get_digits(12345)}');
  StaticList<int> nums = StaticList<int>.of([10, 20, 30, 40, 50]);
  staticPrint('sum: ${IterableStats_get_sum(nums)}, avg: ${IterableStats_get_average(nums)}, max: ${IterableStats_get_max(nums)}, min: ${IterableStats_get_min(nums)}');
  staticPrint('\n--- 19. Matrix2D ---');
  Matrix2DValue m1 = Matrix2D_new(Matrix2DValue(), StaticList<StaticList<double>>.of([StaticList<double>.of([1.0, 2.0]), StaticList<double>.of([3.0, 4.0])]));
  Matrix2DValue m2 = Matrix2D_new_identity(Matrix2DValue(), 2);
  staticPrint('m1: ${m1}');
  staticPrint('m2 (identity): ${m2}');
  staticPrint('m1 + m2: ${(m1.vptr['operatorPlus'] as Function)(m1, m2)}');
  staticPrint('m1 * m2: ${(m1.vptr['operatorStar'] as Function)(m1, m2)}');
  staticPrint('m1 trace: ${(m1.vptr['get_trace'] as Function)(m1)}');
  Matrix2DValue m3 = Matrix2D_new_zeros(Matrix2DValue(), 2, 3);
  staticPrint('zeros(2,3): ${m3}');
  staticPrint('\n--- 20. 综合 mixin + 抽象类 ---');
  ProductValue product = Product_new(ProductValue(), 'P001', 'Widget', 9.99);
  (product.vptr['audit'] as Function)(product, 'created');
  (product.vptr['audit'] as Function)(product, 'priced');
  (product.vptr['markCached'] as Function)(product);
  staticPrint('product: ${product}');
  staticPrint('auditLog: ${(product.vptr['get_auditLog'] as Function)(product)}');
  (product.vptr['markDirty'] as Function)(product);
  staticPrint('after markDirty: ${(product.vptr['get_cacheStatus'] as Function)(product)}');
  staticPrint('\n=== 所有高级语法测试通过 ✅ ===');
}

class ClosureEnv_global_0 extends TypeFunction1<String, StaticMapEntry<String, dynamic>> {

  ClosureEnv_global_0() {
  }
  String call(StaticMapEntry<String, dynamic> e) =>
      ClosureEnv_global_0_call(this, e);
}

String ClosureEnv_global_0_call(dynamic env__, StaticMapEntry<String, dynamic> e) {
  final env = env__ as ClosureEnv_global_0;
  return '${e.key}=${e.value}';
}

ClosureEnv_global_0 ClosureEnv_global_0_new(ClosureEnv_global_0 env_) {
  return env_;
}

class ClosureEnv_global_1 extends TypeFunction1<bool, StaticMap<String, dynamic>> {

  ClosureEnv_global_1() {
  }
  bool call(StaticMap<String, dynamic> r) =>
      ClosureEnv_global_1_call(this, r);
}

bool ClosureEnv_global_1_call(dynamic env__, StaticMap<String, dynamic> r) {
  final env = env__ as ClosureEnv_global_1;
  return r.containsKey('name') && r.containsKey('score');
}

ClosureEnv_global_1 ClosureEnv_global_1_new(ClosureEnv_global_1 env_) {
  return env_;
}

class ClosureEnv_global_2 extends TypeFunction1<bool, StaticMap<String, dynamic>> {

  ClosureEnv_global_2() {
  }
  bool call(StaticMap<String, dynamic> r) =>
      ClosureEnv_global_2_call(this, r);
}

bool ClosureEnv_global_2_call(dynamic env__, StaticMap<String, dynamic> r) {
  final env = env__ as ClosureEnv_global_2;
  return ((r['score'] as int) >= 0);
}

ClosureEnv_global_2 ClosureEnv_global_2_new(ClosureEnv_global_2 env_) {
  return env_;
}

class ClosureEnv_global_3 extends TypeFunction1<StaticMap<String, dynamic>, StaticMap<String, dynamic>> {

  ClosureEnv_global_3() {
  }
  StaticMap<String, dynamic> call(StaticMap<String, dynamic> r) =>
      ClosureEnv_global_3_call(this, r);
}

StaticMap<String, dynamic> ClosureEnv_global_3_call(dynamic env__, StaticMap<String, dynamic> r) {
  final env = env__ as ClosureEnv_global_3;
  return StaticMap<String, dynamic>.of({'name': (r['name'] as String).toUpperCase(), 'score': (r['score'] as int), 'grade': DataProcessor__scoreToGrade((r['score'] as int)), 'passed': ((r['score'] as int) >= 60)});
}

ClosureEnv_global_3 ClosureEnv_global_3_new(ClosureEnv_global_3 env_) {
  return env_;
}

class ClosureEnv_global_4 extends TypeFunction2<int, StaticMap<String, dynamic>, StaticMap<String, dynamic>> {

  ClosureEnv_global_4() {
  }
  int call(StaticMap<String, dynamic> a, StaticMap<String, dynamic> b) =>
      ClosureEnv_global_4_call(this, a, b);
}

int ClosureEnv_global_4_call(dynamic env__, StaticMap<String, dynamic> a, StaticMap<String, dynamic> b) {
  final env = env__ as ClosureEnv_global_4;
  return (b['score'] as int).compareTo((a['score'] as int));
}

ClosureEnv_global_4 ClosureEnv_global_4_new(ClosureEnv_global_4 env_) {
  return env_;
}

class ClosureEnv_global_5 extends TypeFunction0<StaticList<StaticMap<String, dynamic>>> {

  ClosureEnv_global_5() {
  }
  StaticList<StaticMap<String, dynamic>> call() =>
      ClosureEnv_global_5_call(this);
}

StaticList<StaticMap<String, dynamic>> ClosureEnv_global_5_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_5;
  return StaticList<StaticMap<String, dynamic>>.of([]);
}

ClosureEnv_global_5 ClosureEnv_global_5_new(ClosureEnv_global_5 env_) {
  return env_;
}

class ClosureEnv_global_7 extends TypeFunction2<int, int, StaticMap<String, dynamic>> {

  ClosureEnv_global_7() {
  }
  int call(int sum, StaticMap<String, dynamic> r) =>
      ClosureEnv_global_7_call(this, sum, r);
}

int ClosureEnv_global_7_call(dynamic env__, int sum, StaticMap<String, dynamic> r) {
  final env = env__ as ClosureEnv_global_7;
  return (sum + (r['score'] as int));
}

ClosureEnv_global_7 ClosureEnv_global_7_new(ClosureEnv_global_7 env_) {
  return env_;
}

class ClosureEnv_global_6 extends TypeFunction2<StaticMapEntry<String, double>, String, StaticList<StaticMap<String, dynamic>>> {

  ClosureEnv_global_6() {
  }
  StaticMapEntry<String, double> call(String grade, StaticList<StaticMap<String, dynamic>> items) =>
      ClosureEnv_global_6_call(this, grade, items);
}

StaticMapEntry<String, double> ClosureEnv_global_6_call(dynamic env__, String grade, StaticList<StaticMap<String, dynamic>> items) {
  final env = env__ as ClosureEnv_global_6;
  int total = items.fold(0, ClosureEnv_global_7_new(GC.allocateLocal(ClosureEnv_global_7())));
  return StaticMapEntry<String, double>(grade, (total / items.length));
}

ClosureEnv_global_6 ClosureEnv_global_6_new(ClosureEnv_global_6 env_) {
  return env_;
}

class ClosureEnv_global_8 extends TypeFunction1<String, String> {

  ClosureEnv_global_8() {
  }
  String call(String p) =>
      ClosureEnv_global_8_call(this, p);
}

String ClosureEnv_global_8_call(dynamic env__, String p) {
  final env = env__ as ClosureEnv_global_8;
  return (p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1)}');
}

ClosureEnv_global_8 ClosureEnv_global_8_new(ClosureEnv_global_8 env_) {
  return env_;
}

class ClosureEnv_global_9 extends TypeFunction1<bool, String> {

  ClosureEnv_global_9() {
  }
  bool call(String w) =>
      ClosureEnv_global_9_call(this, w);
}

bool ClosureEnv_global_9_call(dynamic env__, String w) {
  final env = env__ as ClosureEnv_global_9;
  return w.isNotEmpty;
}

ClosureEnv_global_9 ClosureEnv_global_9_new(ClosureEnv_global_9 env_) {
  return env_;
}

class ClosureEnv_global_10 extends TypeFunction1<StaticList<double>, int> {
  late int cols;

  ClosureEnv_global_10() {
  }
  StaticList<double> call(int _) =>
      ClosureEnv_global_10_call(this, _);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

StaticList<double> ClosureEnv_global_10_call(dynamic env__, int _) {
  final env = env__ as ClosureEnv_global_10;
  return StaticList<double>.filled(env.cols, 0.0);
}

ClosureEnv_global_10 ClosureEnv_global_10_new(ClosureEnv_global_10 env_, int cols) {
  env_.cols = cols;
  return env_;
}

class ClosureEnv_global_12 extends TypeFunction1<double, int> {
  late int i;

  ClosureEnv_global_12() {
  }
  double call(int j) =>
      ClosureEnv_global_12_call(this, j);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

double ClosureEnv_global_12_call(dynamic env__, int j) {
  final env = env__ as ClosureEnv_global_12;
  return ((env.i == j) ? 1.0 : 0.0);
}

ClosureEnv_global_12 ClosureEnv_global_12_new(ClosureEnv_global_12 env_, int i) {
  env_.i = i;
  return env_;
}

class ClosureEnv_global_11 extends TypeFunction1<StaticList<double>, int> {
  late int size;

  ClosureEnv_global_11() {
  }
  StaticList<double> call(int i) =>
      ClosureEnv_global_11_call(this, i);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

StaticList<double> ClosureEnv_global_11_call(dynamic env__, int i) {
  final env = env__ as ClosureEnv_global_11;
  return StaticList<double>.generate(env.size, ClosureEnv_global_12_new(GC.allocateLocal(ClosureEnv_global_12()), i));
}

ClosureEnv_global_11 ClosureEnv_global_11_new(ClosureEnv_global_11 env_, int size) {
  env_.size = size;
  return env_;
}

class ClosureEnv_global_14 extends TypeFunction1<String, double> {

  ClosureEnv_global_14() {
  }
  String call(double v) =>
      ClosureEnv_global_14_call(this, v);
}

String ClosureEnv_global_14_call(dynamic env__, double v) {
  final env = env__ as ClosureEnv_global_14;
  return dart_str_toStringAsFixed(v, 1);
}

ClosureEnv_global_14 ClosureEnv_global_14_new(ClosureEnv_global_14 env_) {
  return env_;
}

class ClosureEnv_global_13 extends TypeFunction1<String, StaticList<double>> {

  ClosureEnv_global_13() {
  }
  String call(StaticList<double> row) =>
      ClosureEnv_global_13_call(this, row);
}

String ClosureEnv_global_13_call(dynamic env__, StaticList<double> row) {
  final env = env__ as ClosureEnv_global_13;
  return StaticList<String>.of(row.map(ClosureEnv_global_14_new(GC.allocateLocal(ClosureEnv_global_14())))).join(', ');
}

ClosureEnv_global_13 ClosureEnv_global_13_new(ClosureEnv_global_13 env_) {
  return env_;
}

class ClosureEnv_global_15 extends TypeFunction1<String, String> {

  ClosureEnv_global_15() {
  }
  String call(String r) =>
      ClosureEnv_global_15_call(this, r);
}

String ClosureEnv_global_15_call(dynamic env__, String r) {
  final env = env__ as ClosureEnv_global_15;
  return '[${r}]';
}

ClosureEnv_global_15 ClosureEnv_global_15_new(ClosureEnv_global_15 env_) {
  return env_;
}

class ClosureEnv_global_16 extends TypeFunction0<int> {
  late int current;
  late int step;

  ClosureEnv_global_16() {
  }
  int call() =>
      ClosureEnv_global_16_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

int ClosureEnv_global_16_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_16;
  env.current = (env.current + env.step);
  return env.current;
}

ClosureEnv_global_16 ClosureEnv_global_16_new(ClosureEnv_global_16 env_, int current, int step) {
  env_.current = current;
  env_.step = step;
  return env_;
}

class ClosureEnv_global_18 extends TypeFunction0<String> {
  late int snapshot;
  late int total;

  ClosureEnv_global_18() {
  }
  String call() =>
      ClosureEnv_global_18_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

String ClosureEnv_global_18_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_18;
  return 'accumulated: ${env.snapshot} (current total: ${env.total})';
}

ClosureEnv_global_18 ClosureEnv_global_18_new(ClosureEnv_global_18 env_, int snapshot, int total) {
  env_.snapshot = snapshot;
  env_.total = total;
  return env_;
}

class ClosureEnv_global_17 extends TypeFunction1<TypeFunction0<String>, int> {
  late int total;

  ClosureEnv_global_17() {
  }
  TypeFunction0<String> call(int amount) =>
      ClosureEnv_global_17_call(this, amount);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

TypeFunction0<String> ClosureEnv_global_17_call(dynamic env__, int amount) {
  final env = env__ as ClosureEnv_global_17;
  env.total = (env.total + amount);
  int snapshot = env.total;
  return ClosureEnv_global_18_new(GC.allocateLocal(ClosureEnv_global_18()), snapshot, env.total);
}

ClosureEnv_global_17 ClosureEnv_global_17_new(ClosureEnv_global_17 env_, int total) {
  env_.total = total;
  return env_;
}

class ClosureEnv_global_19 extends TypeFunction0<String> {
  late int i;

  ClosureEnv_global_19() {
  }
  String call() =>
      ClosureEnv_global_19_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

String ClosureEnv_global_19_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_19;
  return 'closure_${env.i}';
}

ClosureEnv_global_19 ClosureEnv_global_19_new(ClosureEnv_global_19 env_, int i) {
  env_.i = i;
  return env_;
}

class ClosureEnv_global_20<C extends dynamic, B extends dynamic, A extends dynamic> extends TypeFunction1<C, A> {
  late TypeFunction1<C, B> funcBC;
  late TypeFunction1<B, A> funcAB;

  ClosureEnv_global_20() {
  }
  C call(A a) =>
      ClosureEnv_global_20_call(this, a);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    funcBC?.gcMark(flag);
    funcAB?.gcMark(flag);
  }
}

C ClosureEnv_global_20_call<C extends dynamic, B extends dynamic, A extends dynamic>(dynamic env__, A a) {
  final env = env__ as ClosureEnv_global_20<C, B, A>;
  return env.funcBC(env.funcAB(a));
}

ClosureEnv_global_20<C, B, A> ClosureEnv_global_20_new<C extends dynamic, B extends dynamic, A extends dynamic>(ClosureEnv_global_20<C, B, A> env_, TypeFunction1<C, B> funcBC, TypeFunction1<B, A> funcAB) {
  env_.funcBC = funcBC;
  env_.funcAB = funcAB;
  return env_;
}

class ClosureEnv_global_22<C extends dynamic, A extends dynamic, B extends dynamic> extends TypeFunction1<C, B> {
  late TypeFunction2<C, A, B> biFunc;
  late A a;

  ClosureEnv_global_22() {
  }
  C call(B b) =>
      ClosureEnv_global_22_call(this, b);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    biFunc?.gcMark(flag);
  }
}

C ClosureEnv_global_22_call<C extends dynamic, A extends dynamic, B extends dynamic>(dynamic env__, B b) {
  final env = env__ as ClosureEnv_global_22<C, A, B>;
  return env.biFunc(env.a, b);
}

ClosureEnv_global_22<C, A, B> ClosureEnv_global_22_new<C extends dynamic, A extends dynamic, B extends dynamic>(ClosureEnv_global_22<C, A, B> env_, TypeFunction2<C, A, B> biFunc, A a) {
  env_.biFunc = biFunc;
  env_.a = a;
  return env_;
}

class ClosureEnv_global_21<C extends dynamic, A extends dynamic, B extends dynamic> extends TypeFunction1<TypeFunction1<C, B>, A> {
  late TypeFunction2<C, A, B> biFunc;

  ClosureEnv_global_21() {
  }
  TypeFunction1<C, B> call(A a) =>
      ClosureEnv_global_21_call(this, a);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    biFunc?.gcMark(flag);
  }
}

TypeFunction1<C, B> ClosureEnv_global_21_call<C extends dynamic, A extends dynamic, B extends dynamic>(dynamic env__, A a) {
  final env = env__ as ClosureEnv_global_21<C, A, B>;
  return ClosureEnv_global_22_new<C, A, B>(GC.allocateLocal(ClosureEnv_global_22<C, A, B>()), env.biFunc, a);
}

ClosureEnv_global_21<C, A, B> ClosureEnv_global_21_new<C extends dynamic, A extends dynamic, B extends dynamic>(ClosureEnv_global_21<C, A, B> env_, TypeFunction2<C, A, B> biFunc) {
  env_.biFunc = biFunc;
  return env_;
}

class ClosureEnv_global_23<A extends dynamic, B extends dynamic> extends TypeFunction1<B, A> {
  late StaticMap<A, B> cache;
  late TypeFunction1<B, A> func;

  ClosureEnv_global_23() {
  }
  B call(A arg) =>
      ClosureEnv_global_23_call(this, arg);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    cache?.gcMark(flag);
    func?.gcMark(flag);
  }
}

B ClosureEnv_global_23_call<A extends dynamic, B extends dynamic>(dynamic env__, A arg) {
  final env = env__ as ClosureEnv_global_23<A, B>;
  if (env.cache.containsKey(arg)) {
    return (env.cache[arg] as B);
  }
  B result = env.func(arg);
  env.cache[arg] = result;
  return result;
}

ClosureEnv_global_23<A, B> ClosureEnv_global_23_new<A extends dynamic, B extends dynamic>(ClosureEnv_global_23<A, B> env_, StaticMap<A, B> cache, TypeFunction1<B, A> func) {
  env_.cache = cache;
  env_.func = func;
  return env_;
}

class ClosureEnv_global_24<T extends dynamic> extends TypeFunction2<T, T, T> {

  ClosureEnv_global_24() {
  }
  T call(T a, T b) =>
      ClosureEnv_global_24_call(this, a, b);
}

T ClosureEnv_global_24_call<T extends dynamic>(dynamic env__, T a, T b) {
  final env = env__ as ClosureEnv_global_24<T>;
  return ((a + b) as T);
}

ClosureEnv_global_24<T> ClosureEnv_global_24_new<T extends dynamic>(ClosureEnv_global_24<T> env_) {
  return env_;
}

class ClosureEnv_global_25<T extends dynamic> extends TypeFunction2<T, T, T> {

  ClosureEnv_global_25() {
  }
  T call(T a, T b) =>
      ClosureEnv_global_25_call(this, a, b);
}

T ClosureEnv_global_25_call<T extends dynamic>(dynamic env__, T a, T b) {
  final env = env__ as ClosureEnv_global_25<T>;
  return ((a > b) ? a : b);
}

ClosureEnv_global_25<T> ClosureEnv_global_25_new<T extends dynamic>(ClosureEnv_global_25<T> env_) {
  return env_;
}

class ClosureEnv_global_26<T extends dynamic> extends TypeFunction2<T, T, T> {

  ClosureEnv_global_26() {
  }
  T call(T a, T b) =>
      ClosureEnv_global_26_call(this, a, b);
}

T ClosureEnv_global_26_call<T extends dynamic>(dynamic env__, T a, T b) {
  final env = env__ as ClosureEnv_global_26<T>;
  return ((a < b) ? a : b);
}

ClosureEnv_global_26<T> ClosureEnv_global_26_new<T extends dynamic>(ClosureEnv_global_26<T> env_) {
  return env_;
}

class ClosureEnv_global_27 extends TypeFunction1<String, int> {

  ClosureEnv_global_27() {
  }
  String call(int v) =>
      ClosureEnv_global_27_call(this, v);
}

String ClosureEnv_global_27_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_27;
  return 'N${v}';
}

ClosureEnv_global_27 ClosureEnv_global_27_new(ClosureEnv_global_27 env_) {
  return env_;
}

class ClosureEnv_global_28 extends TypeFunction1<String, String> {

  ClosureEnv_global_28() {
  }
  String call(String l) =>
      ClosureEnv_global_28_call(this, l);
}

String ClosureEnv_global_28_call(dynamic env__, String l) {
  final env = env__ as ClosureEnv_global_28;
  return 'L:${l}';
}

ClosureEnv_global_28 ClosureEnv_global_28_new(ClosureEnv_global_28 env_) {
  return env_;
}

class ClosureEnv_global_29 extends TypeFunction1<String, int> {

  ClosureEnv_global_29() {
  }
  String call(int r) =>
      ClosureEnv_global_29_call(this, r);
}

String ClosureEnv_global_29_call(dynamic env__, int r) {
  final env = env__ as ClosureEnv_global_29;
  return 'R:${r}';
}

ClosureEnv_global_29 ClosureEnv_global_29_new(ClosureEnv_global_29 env_) {
  return env_;
}

class ClosureEnv_global_30 extends TypeFunction1<String, String> {

  ClosureEnv_global_30() {
  }
  String call(String l) =>
      ClosureEnv_global_30_call(this, l);
}

String ClosureEnv_global_30_call(dynamic env__, String l) {
  final env = env__ as ClosureEnv_global_30;
  return 'L:${l}';
}

ClosureEnv_global_30 ClosureEnv_global_30_new(ClosureEnv_global_30 env_) {
  return env_;
}

class ClosureEnv_global_31 extends TypeFunction1<String, int> {

  ClosureEnv_global_31() {
  }
  String call(int r) =>
      ClosureEnv_global_31_call(this, r);
}

String ClosureEnv_global_31_call(dynamic env__, int r) {
  final env = env__ as ClosureEnv_global_31;
  return 'R:${r}';
}

ClosureEnv_global_31 ClosureEnv_global_31_new(ClosureEnv_global_31 env_) {
  return env_;
}

class ClosureEnv_global_32 extends TypeFunction1<int, int> {

  ClosureEnv_global_32() {
  }
  int call(int v) =>
      ClosureEnv_global_32_call(this, v);
}

int ClosureEnv_global_32_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_32;
  return (v * 2);
}

ClosureEnv_global_32 ClosureEnv_global_32_new(ClosureEnv_global_32 env_) {
  return env_;
}

class ClosureEnv_global_33 extends TypeFunction1<EitherValue<String, dynamic>, int> {

  ClosureEnv_global_33() {
  }
  EitherValue<String, dynamic> call(int v) =>
      ClosureEnv_global_33_call(this, v);
}

EitherValue<String, dynamic> ClosureEnv_global_33_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_33;
  return ((v > 10) ? Either_new_right<String, String>(EitherValue<String, String>(), 'big_${v}') : Either_new_left<String, dynamic>(EitherValue<String, dynamic>(), 'too small'));
}

ClosureEnv_global_33 ClosureEnv_global_33_new(ClosureEnv_global_33 env_) {
  return env_;
}

class ClosureEnv_global_34 extends TypeFunction1<int, int> {

  ClosureEnv_global_34() {
  }
  int call(int x) =>
      ClosureEnv_global_34_call(this, x);
}

int ClosureEnv_global_34_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_34;
  return (x * 2);
}

ClosureEnv_global_34 ClosureEnv_global_34_new(ClosureEnv_global_34 env_) {
  return env_;
}

class ClosureEnv_global_35 extends TypeFunction1<int, int> {

  ClosureEnv_global_35() {
  }
  int call(int x) =>
      ClosureEnv_global_35_call(this, x);
}

int ClosureEnv_global_35_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_35;
  return (x + 1);
}

ClosureEnv_global_35 ClosureEnv_global_35_new(ClosureEnv_global_35 env_) {
  return env_;
}

class ClosureEnv_global_36 extends TypeFunction2<int, int, int> {

  ClosureEnv_global_36() {
  }
  int call(int a, int b) =>
      ClosureEnv_global_36_call(this, a, b);
}

int ClosureEnv_global_36_call(dynamic env__, int a, int b) {
  final env = env__ as ClosureEnv_global_36;
  return (a + b);
}

ClosureEnv_global_36 ClosureEnv_global_36_new(ClosureEnv_global_36 env_) {
  return env_;
}

class ClosureEnv_global_37 extends TypeFunction1<int, int> {

  ClosureEnv_global_37() {
  }
  int call(int x) =>
      ClosureEnv_global_37_call(this, x);
}

int ClosureEnv_global_37_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_37;
  return (x * 2);
}

ClosureEnv_global_37 ClosureEnv_global_37_new(ClosureEnv_global_37 env_) {
  return env_;
}

class ClosureEnv_global_38 extends TypeFunction1<int, int> {

  ClosureEnv_global_38() {
  }
  int call(int x) =>
      ClosureEnv_global_38_call(this, x);
}

int ClosureEnv_global_38_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_38;
  return (x + 10);
}

ClosureEnv_global_38 ClosureEnv_global_38_new(ClosureEnv_global_38 env_) {
  return env_;
}

class ClosureEnv_global_39 extends TypeFunction1<int, int> {

  ClosureEnv_global_39() {
  }
  int call(int x) =>
      ClosureEnv_global_39_call(this, x);
}

int ClosureEnv_global_39_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_39;
  return (x * x);
}

ClosureEnv_global_39 ClosureEnv_global_39_new(ClosureEnv_global_39 env_) {
  return env_;
}

class ClosureEnv_global_40 extends TypeFunction1<int, int> {

  ClosureEnv_global_40() {
  }
  int call(int n) =>
      ClosureEnv_global_40_call(this, n);
}

int ClosureEnv_global_40_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_global_40;
  if ((n <= 1)) {
    return n;
  }
  return n;
}

ClosureEnv_global_40 ClosureEnv_global_40_new(ClosureEnv_global_40 env_) {
  return env_;
}


import 'package:dart2cpp/platform/dart/runtime_classes.dart';

typedef UnaryFunc<A, B> = TypeFunction1<B, A>;

class TreeNodeClassInfo<T> extends ClassInfo {
  Function? preorder;
  Function? inorder;
  Function? get_depth;
  Function? map;
  dynamic map_String;
}

class TreeNodeValue<T> extends AnyGC {
  late T value;
  late TreeNodeValue<T>? left;
  late TreeNodeValue<T>? right;
  @override
  ClassInfo get classInfo {
    final ci = TreeNodeClassInfo<T>();
    ci.preorder = TreeNode_preorder<T>;
    ci.inorder = TreeNode_inorder<T>;
    ci.get_depth = TreeNode_get_depth<T>;
    ci.toString_ = TreeNode_toString<T>;
    ci.map_String = TreeNode_map<T, String>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (value is AnyGC) (value as AnyGC).gcMark(flag);
    if (left is AnyGC) (left as AnyGC).gcMark(flag);
    if (right is AnyGC) (right as AnyGC).gcMark(flag);
  }
}

TreeNodeValue<T> TreeNode_new<T>(AnyGC this__, T value, [TreeNodeValue<T>? left = null, TreeNodeValue<T>? right = null]) {
  final this_ = this__ as TreeNodeValue<T>;
  this_.value = value;
  this_.left = left;
  this_.right = right;
  return this_;
}

StaticList<T> TreeNode_preorder<T>(AnyGC this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final StaticList<T> result = StaticList<T>.of([this_.value]);
  if (!((this_.left == null)))   result.addAll((() { final _r0 = this_.left!; return (_r0.classInfo as TreeNodeClassInfo).preorder!(_r0); })());
  if (!((this_.right == null)))   result.addAll((() { final _r1 = this_.right!; return (_r1.classInfo as TreeNodeClassInfo).preorder!(_r1); })());
  return result;
}

StaticList<T> TreeNode_inorder<T>(AnyGC this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final StaticList<T> result = StaticList<T>();
  if (!((this_.left == null)))   result.addAll((() { final _r2 = this_.left!; return (_r2.classInfo as TreeNodeClassInfo).inorder!(_r2); })());
  result.add(this_.value);
  if (!((this_.right == null)))   result.addAll((() { final _r3 = this_.right!; return (_r3.classInfo as TreeNodeClassInfo).inorder!(_r3); })());
  return result;
}

int TreeNode_get_depth<T>(AnyGC this__) {
  final this_ = this__ as TreeNodeValue<T>;
  final int leftDepth = ((() { final _let5 = this_.left; return (_let5 == null) ? null : (_let5.classInfo as TreeNodeClassInfo).get_depth!(_let5); })() ?? 0);
  final int rightDepth = ((() { final _let7 = this_.right; return (_let7 == null) ? null : (_let7.classInfo as TreeNodeClassInfo).get_depth!(_let7); })() ?? 0);
  return (1 + ((leftDepth > rightDepth) ? leftDepth : rightDepth));
}

TreeNodeValue<R> TreeNode_map<T, R>(AnyGC this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as TreeNodeValue<T>;
  return TreeNode_new<R>(GC.allocateLocal(TreeNodeValue<R>()), transform.call(this_.value), (() { final _let8 = this_.left; return (_let8 == null) ? null : TreeNode_map<T, R>(_let8, transform); })(), (() { final _let9 = this_.right; return (_let9 == null) ? null : TreeNode_map<T, R>(_let9, transform); })());
}

String TreeNode_toString<T>(AnyGC this__) {
  final this_ = this__ as TreeNodeValue<T>;
  return 'TreeNode(${this_.value})';
}


class LinkedNodeClassInfo<T> extends ClassInfo {
  Function? reversed;
  Function? toList;
  Function? get_length;
}

class LinkedNodeValue<T> extends AnyGC {
  late T data;
  late LinkedNodeValue<T>? next;
  @override
  ClassInfo get classInfo {
    final ci = LinkedNodeClassInfo<T>();
    ci.reversed = LinkedNode_reversed<T>;
    ci.toList = LinkedNode_toList<T>;
    ci.get_length = LinkedNode_get_length<T>;
    ci.toString_ = LinkedNode_toString<T>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (data is AnyGC) (data as AnyGC).gcMark(flag);
    if (next is AnyGC) (next as AnyGC).gcMark(flag);
  }
}

LinkedNodeValue<T> LinkedNode_new<T>(AnyGC this__, T data, [LinkedNodeValue<T>? next = null]) {
  final this_ = this__ as LinkedNodeValue<T>;
  this_.data = data;
  this_.next = next;
  return this_;
}

LinkedNodeValue<T> LinkedNode_reversed<T>(AnyGC this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  if ((this_.next == null))   return LinkedNode_new<T>(GC.allocateLocal(LinkedNodeValue<T>()), this_.data);
  final LinkedNodeValue<T> rev = (() { final _r10 = this_.next!; return (_r10.classInfo as LinkedNodeClassInfo).reversed!(_r10); })();
  LinkedNodeValue<T> tail = rev;
  while (!((tail.next == null))) {
    tail = tail.next!;
  }
  tail.next = LinkedNode_new<T>(GC.allocateLocal(LinkedNodeValue<T>()), this_.data);
  return rev;
}

StaticList<T> LinkedNode_toList<T>(AnyGC this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  final StaticList<T> result = StaticList<T>.of([this_.data]);
  LinkedNodeValue<T>? current = this_.next;
  while (!((current == null))) {
    result.add(current!.data);
    current = current!.next;
  }
  return result;
}

int LinkedNode_get_length<T>(AnyGC this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  int count = 1;
  LinkedNodeValue<T>? current = this_.next;
  while (!((current == null))) {
    count = (count + 1);
    current = current!.next;
  }
  return count;
}

String LinkedNode_toString<T>(AnyGC this__) {
  final this_ = this__ as LinkedNodeValue<T>;
  return 'LinkedNode(${(this_.classInfo as LinkedNodeClassInfo).toList!(this_).join(' -> ')})';
}


class EitherClassInfo<L, R> extends ClassInfo {
  Function? get_isLeft;
  Function? get_isRight;
  Function? get_leftValue;
  Function? get_rightValue;
  Function? fold;
  Function? mapRight;
  Function? flatMap;
}

class EitherValue<L, R> extends AnyGC {
  late L? _left;
  late R? _right;
  late bool _isRight;
  @override
  ClassInfo get classInfo {
    final ci = EitherClassInfo<L, R>();
    ci.get_isLeft = Either_get_isLeft<L, R>;
    ci.get_isRight = Either_get_isRight<L, R>;
    ci.get_leftValue = Either_get_leftValue<L, R>;
    ci.get_rightValue = Either_get_rightValue<L, R>;
    ci.toString_ = Either_toString<L, R>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_left is AnyGC) (_left as AnyGC).gcMark(flag);
    if (_right is AnyGC) (_right as AnyGC).gcMark(flag);
  }
}

EitherValue<L, R> Either_new_left<L, R>(AnyGC this__, L value) {
  final this_ = this__ as EitherValue<L, R>;
  this_._left = value;
  this_._right = null;
  this_._isRight = false;
  return this_;
}

EitherValue<L, R> Either_new_right<L, R>(AnyGC this__, R value) {
  final this_ = this__ as EitherValue<L, R>;
  this_._left = null;
  this_._right = value;
  this_._isRight = true;
  return this_;
}

bool Either_get_isLeft<L, R>(AnyGC this__) {
  final this_ = this__ as EitherValue<L, R>;
  return !(this_._isRight);
}

bool Either_get_isRight<L, R>(AnyGC this__) {
  final this_ = this__ as EitherValue<L, R>;
  return this_._isRight;
}

L Either_get_leftValue<L, R>(AnyGC this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (!((this_.classInfo as EitherClassInfo).get_isLeft!(this_)))   throw DartStateError('Not a left value');
  return (this_._left as L);
}

R Either_get_rightValue<L, R>(AnyGC this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (!((this_.classInfo as EitherClassInfo).get_isRight!(this_)))   throw DartStateError('Not a right value');
  return (this_._right as R);
}

T Either_fold<L, R, T>(AnyGC this__, TypeFunction1<T, L> onLeft, TypeFunction1<T, R> onRight) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return onRight.call((this_._right as R));
  return onLeft.call((this_._left as L));
}

EitherValue<L, R2> Either_mapRight<L, R, R2>(AnyGC this__, TypeFunction1<R2, R> transform) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return Either_new_right<L, R2>(GC.allocateLocal(EitherValue<L, R2>()), transform.call((this_._right as R)));
  return Either_new_left<L, R2>(GC.allocateLocal(EitherValue<L, R2>()), (this_._left as L));
}

EitherValue<L, R2> Either_flatMap<L, R, R2>(AnyGC this__, TypeFunction1<EitherValue<L, R2>, R> transform) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return transform.call((this_._right as R));
  return Either_new_left<L, R2>(GC.allocateLocal(EitherValue<L, R2>()), (this_._left as L));
}

String Either_toString<L, R>(AnyGC this__) {
  final this_ = this__ as EitherValue<L, R>;
  if (this_._isRight)   return 'Right(${this_._right})';
  return 'Left(${this_._left})';
}


// mixin Serializable → static functions for delegation
String Serializable_serialize(AnyGC this__) {
  final dynamic this_ = this__;
  final StaticMap<String, dynamic> map = StaticMap<String, dynamic>.of((this_.classInfo as dynamic).toMap!(this_));
  final String entries = map.entries.map(ClosureEnv_anon_0_new(GC.allocateLocal(ClosureEnv_anon_0()))).join(', ');
  return '{${entries}}';
}


// mixin Validatable → static functions for delegation
bool Validatable_get_isValid(AnyGC this__) {
  final dynamic this_ = this__;
  return (this_.classInfo as dynamic).validate!(this_).isEmpty;
}

String Validatable_get_validationSummary(AnyGC this__) {
  final dynamic this_ = this__;
  final StaticList<String> errors = StaticList<String>.of((this_.classInfo as dynamic).validate!(this_));
  if (errors.isEmpty)   return 'valid';
  return 'invalid: ${errors.join('; ')}';
}


// mixin Copyable → static functions for delegation

class UserProfileClassInfo extends UserProfile_Object_Serializable_ValidatableClassInfo {
}

class UserProfileValue extends UserProfile_Object_Serializable_ValidatableValue {
  late String name;
  late String email;
  late int age;
  static UserProfileClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static UserProfileClassInfo _initClassInfo() {
    final ci = UserProfileClassInfo();
    ci.toMap = UserProfile_toMap;
    ci.serialize = UserProfile_serialize;
    ci.validate = UserProfile_validate;
    ci.get_isValid = UserProfile_get_isValid;
    ci.get_validationSummary = UserProfile_get_validationSummary;
    ci.toString_ = UserProfile_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

UserProfileValue UserProfile_new(AnyGC this__, String name, String email, int age) {
  final this_ = this__ as UserProfileValue;
  this_.name = name;
  this_.email = email;
  this_.age = age;
  return this_;
}

StaticMap<String, dynamic> UserProfile_toMap(AnyGC this__) {
  final this_ = this__ as UserProfileValue;
  return StaticMap<String, dynamic>.of({'name': this_.name, 'email': this_.email, 'age': this_.age});
}

StaticList<String> UserProfile_validate(AnyGC this__) {
  final this_ = this__ as UserProfileValue;
  final StaticList<String> errors = StaticList<String>();
  if (this_.name.isEmpty)   errors.add('name is empty');
  if (!(this_.email.contains('@')))   errors.add('invalid email');
  if (((this_.age < 0) || (this_.age > 150)))   errors.add('invalid age');
  return errors;
}

String UserProfile_toString(AnyGC this__) {
  final this_ = this__ as UserProfileValue;
  return 'UserProfile(${this_.name}, ${this_.email}, ${this_.age})';
}

String UserProfile_serialize(AnyGC this__) {
  final this_ = this__ as UserProfileValue;
  return Serializable_serialize(this_);
}

bool UserProfile_get_isValid(AnyGC this__) {
  final this_ = this__ as UserProfileValue;
  return Validatable_get_isValid(this_);
}

String UserProfile_get_validationSummary(AnyGC this__) {
  final this_ = this__ as UserProfileValue;
  return Validatable_get_validationSummary(this_);
}


class DataTransformerClassInfo<TInput, TOutput> extends ClassInfo {
  Function? transform;
  Function? preValidate;
  Function? process;
  Function? postProcess;
}

class DataTransformerValue<TInput, TOutput> extends AnyGC {
  @override
  ClassInfo get classInfo => DataTransformerClassInfo<TInput, TOutput>();
}

DataTransformerValue<TInput, TOutput> DataTransformer_new<TInput, TOutput>(AnyGC this__) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return this_;
}

TOutput DataTransformer_transform<TInput, TOutput>(AnyGC this__, TInput input) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  final TInput validated = (this_.classInfo as DataTransformerClassInfo).preValidate!(this_, input);
  final TOutput processed = (this_.classInfo as DataTransformerClassInfo).process!(this_, validated);
  return (this_.classInfo as DataTransformerClassInfo).postProcess!(this_, processed);
}

TInput DataTransformer_preValidate<TInput, TOutput>(AnyGC this__, TInput input) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return input;
}

TOutput DataTransformer_process<TInput, TOutput>(dynamic this_, TInput input) {
  throw UnimplementedError('DataTransformer.process is abstract');
}

TOutput DataTransformer_postProcess<TInput, TOutput>(AnyGC this__, TOutput output) {
  final this_ = this__ as DataTransformerValue<TInput, TOutput>;
  return output;
}


class StringToIntTransformerClassInfo extends DataTransformerClassInfo<String, int> {
}

class StringToIntTransformerValue extends DataTransformerValue<String, int> {
  static StringToIntTransformerClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static StringToIntTransformerClassInfo _initClassInfo() {
    final ci = StringToIntTransformerClassInfo();
    ci.transform = StringToIntTransformer_transform;
    ci.preValidate = StringToIntTransformer_preValidate;
    ci.process = StringToIntTransformer_process;
    ci.postProcess = StringToIntTransformer_postProcess;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

StringToIntTransformerValue StringToIntTransformer_new(AnyGC this__) {
  final this_ = this__ as StringToIntTransformerValue;
  DataTransformer_new<String, int>(this_);
  return this_;
}

String StringToIntTransformer_preValidate(AnyGC this__, String input) {
  final this_ = this__ as StringToIntTransformerValue;
  return input.trim();
}

int StringToIntTransformer_process(AnyGC this__, String input) {
  final this_ = this__ as StringToIntTransformerValue;
  return int.parse(input);
}

int StringToIntTransformer_transform(AnyGC this__, String input) {
  final this_ = this__ as StringToIntTransformerValue;
  return DataTransformer_transform<String, int>(this_, input);
}

int StringToIntTransformer_postProcess(AnyGC this__, int output) {
  final this_ = this__ as StringToIntTransformerValue;
  return DataTransformer_postProcess<String, int>(this_, output);
}


class IntToStringTransformerClassInfo extends DataTransformerClassInfo<int, String> {
}

class IntToStringTransformerValue extends DataTransformerValue<int, String> {
  late String prefix;
  static IntToStringTransformerClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static IntToStringTransformerClassInfo _initClassInfo() {
    final ci = IntToStringTransformerClassInfo();
    ci.transform = IntToStringTransformer_transform;
    ci.preValidate = IntToStringTransformer_preValidate;
    ci.process = IntToStringTransformer_process;
    ci.postProcess = IntToStringTransformer_postProcess;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

IntToStringTransformerValue IntToStringTransformer_new(AnyGC this__, [String prefix = '']) {
  final this_ = this__ as IntToStringTransformerValue;
  DataTransformer_new<int, String>(this_);
  this_.prefix = prefix;
  return this_;
}

String IntToStringTransformer_process(AnyGC this__, int input) {
  final this_ = this__ as IntToStringTransformerValue;
  return '${this_.prefix}${input.toString()}';
}

String IntToStringTransformer_postProcess(AnyGC this__, String output) {
  final this_ = this__ as IntToStringTransformerValue;
  return output.toUpperCase();
}

String IntToStringTransformer_transform(AnyGC this__, int input) {
  final this_ = this__ as IntToStringTransformerValue;
  return DataTransformer_transform<int, String>(this_, input);
}

int IntToStringTransformer_preValidate(AnyGC this__, int input) {
  final this_ = this__ as IntToStringTransformerValue;
  return DataTransformer_preValidate<int, String>(this_, input);
}


class ChainedTransformerClassInfo<A, B, C> extends DataTransformerClassInfo<A, C> {
}

class ChainedTransformerValue<A, B, C> extends DataTransformerValue<A, C> {
  late DataTransformerValue<A, B> first;
  late DataTransformerValue<B, C> second;
  @override
  ClassInfo get classInfo {
    final ci = ChainedTransformerClassInfo<A, B, C>();
    ci.transform = ChainedTransformer_transform<A, B, C>;
    ci.preValidate = ChainedTransformer_preValidate<A, B, C>;
    ci.process = ChainedTransformer_process<A, B, C>;
    ci.postProcess = ChainedTransformer_postProcess<A, B, C>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (first is AnyGC) (first as AnyGC).gcMark(flag);
    if (second is AnyGC) (second as AnyGC).gcMark(flag);
  }
}

ChainedTransformerValue<A, B, C> ChainedTransformer_new<A, B, C>(AnyGC this__, DataTransformerValue<A, B> first, DataTransformerValue<B, C> second) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  DataTransformer_new<A, C>(this_);
  this_.first = first;
  this_.second = second;
  return this_;
}

C ChainedTransformer_process<A, B, C>(AnyGC this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  final B intermediate = (this_.first.classInfo as DataTransformerClassInfo).transform!(this_.first, input);
  return (this_.second.classInfo as DataTransformerClassInfo).transform!(this_.second, intermediate);
}

C ChainedTransformer_transform<A, B, C>(AnyGC this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  return DataTransformer_transform<A, C>(this_, input);
}

A ChainedTransformer_preValidate<A, B, C>(AnyGC this__, A input) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  return DataTransformer_preValidate<A, C>(this_, input);
}

C ChainedTransformer_postProcess<A, B, C>(AnyGC this__, C output) {
  final this_ = this__ as ChainedTransformerValue<A, B, C>;
  return DataTransformer_postProcess<A, C>(this_, output);
}


class RegistryClassInfo extends ClassInfo {
  Function? register;
  Function? lookup;
  Function? contains;
  Function? get_size;
  Function? get_accessCount;
  Function? get_keys;
  Function? clear;
}

class RegistryValue extends AnyGC {
  late StaticMap<String, dynamic> _store = StaticMap<String, dynamic>.of({});
  late int _accessCount = 0;
  static RegistryClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static RegistryClassInfo _initClassInfo() {
    final ci = RegistryClassInfo();
    ci.register = Registry_register;
    ci.lookup = Registry_lookup;
    ci.contains = Registry_contains;
    ci.get_size = Registry_get_size;
    ci.get_accessCount = Registry_get_accessCount;
    ci.get_keys = Registry_get_keys;
    ci.clear = Registry_clear;
    ci.toString_ = Registry_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_store is AnyGC) (_store as AnyGC).gcMark(flag);
  }
}

final RegistryValue Registry__instance = Registry_new__internal(GC.allocateGlobal(RegistryValue()));
RegistryValue Registry_new__internal(AnyGC this__) {
  final this_ = this__ as RegistryValue;
  return this_;
}

RegistryValue Registry_new() {
  return Registry__instance;
}

void Registry_register(AnyGC this__, String key, AnyGC value) {
  final this_ = this__ as RegistryValue;
  this_._store[key] = value;
  this_._accessCount = (this_._accessCount + 1);
}

dynamic Registry_lookup(AnyGC this__, String key) {
  final this_ = this__ as RegistryValue;
  this_._accessCount = (this_._accessCount + 1);
  return this_._store[key];
}

bool Registry_contains(AnyGC this__, String key) {
  final this_ = this__ as RegistryValue;
  return this_._store.containsKey(key);
}

int Registry_get_size(AnyGC this__) {
  final this_ = this__ as RegistryValue;
  return this_._store.length;
}

int Registry_get_accessCount(AnyGC this__) {
  final this_ = this__ as RegistryValue;
  return this_._accessCount;
}

StaticList<String> Registry_get_keys(AnyGC this__) {
  final this_ = this__ as RegistryValue;
  return (StaticList.of(this_._store.keys.toList())..sort());
}

void Registry_clear(AnyGC this__) {
  final this_ = this__ as RegistryValue;
  this_._store.clear();
  this_._accessCount = 0;
}

String Registry_toString(AnyGC this__) {
  final this_ = this__ as RegistryValue;
  return 'Registry(size=${(this_.classInfo as RegistryClassInfo).get_size!(this_)}, accesses=${(this_.classInfo as RegistryClassInfo).get_accessCount!(this_)})';
}


class DataProcessorClassInfo extends ClassInfo {
}

class DataProcessorValue extends AnyGC {
  static DataProcessorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DataProcessorClassInfo _initClassInfo() {
    final ci = DataProcessorClassInfo();
    return ci;
  }
}

DataProcessorValue DataProcessor_new(AnyGC this__) {
  final this_ = this__ as DataProcessorValue;
  return this_;
}

StaticList<StaticMap<String, dynamic>> DataProcessor_processRecords(StaticList<StaticMap<String, dynamic>> records) {
  return (StaticList.of(records.where(ClosureEnv_anon_2_new(GC.allocateLocal(ClosureEnv_anon_2()))).where(ClosureEnv_anon_3_new(GC.allocateLocal(ClosureEnv_anon_3()))).map(ClosureEnv_anon_4_new(GC.allocateLocal(ClosureEnv_anon_4()))).toList())..sort(ClosureEnv_anon_1_new(GC.allocateLocal(ClosureEnv_anon_1()))));
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
    StaticIterator<StaticMap<String, dynamic>> sync_for_iterator = StaticIterator(records.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final StaticMap<String, dynamic> record = StaticMap<String, dynamic>.of(sync_for_iterator.current);
{
        final String grade = (record['grade'] as String);
        groups.putIfAbsent(grade, ClosureEnv_anon_5_new(GC.allocateLocal(ClosureEnv_anon_5())));
        groups[grade]!.add(record);
      }
    }
  }
  return groups;
}

StaticMap<String, double> DataProcessor_averageByGrade(StaticList<StaticMap<String, dynamic>> records) {
  final StaticMap<String, StaticList<StaticMap<String, dynamic>>> groups = StaticMap<String, StaticList<StaticMap<String, dynamic>>>.of(DataProcessor_groupByGrade(records));
  return groups.map(ClosureEnv_anon_6_new(GC.allocateLocal(ClosureEnv_anon_6())));
}


class ExpensiveComputationClassInfo extends ClassInfo {
  Function? initialize;
}

class ExpensiveComputationValue extends AnyGC {
  late int seed;
  late int computedValue = ExpensiveComputation__computeExpensive(this);
  late String description;
  static ExpensiveComputationClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ExpensiveComputationClassInfo _initClassInfo() {
    final ci = ExpensiveComputationClassInfo();
    ci.initialize = ExpensiveComputation_initialize;
    ci.toString_ = ExpensiveComputation_toString;
    return ci;
  }
}

ExpensiveComputationValue ExpensiveComputation_new(AnyGC this__, int seed) {
  final this_ = this__ as ExpensiveComputationValue;
  this_.seed = seed;
  return this_;
}

int ExpensiveComputation__computeExpensive(AnyGC this__) {
  final this_ = this__ as ExpensiveComputationValue;
  int result = this_.seed;
  for (var i = 0; (i < 10); i = (i + 1)) {
    result = (((result * 31) + 17) % 1000);
  }
  return result;
}

void ExpensiveComputation_initialize(AnyGC this__, String desc) {
  final this_ = this__ as ExpensiveComputationValue;
  this_.description = desc;
}

String ExpensiveComputation_toString(AnyGC this__) {
  final this_ = this__ as ExpensiveComputationValue;
  return 'ExpensiveComputation(seed=${this_.seed}, computed=${this_.computedValue})';
}


class MathUtilsClassInfo extends ClassInfo {
}

class MathUtilsValue extends AnyGC {
  static MathUtilsClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MathUtilsClassInfo _initClassInfo() {
    final ci = MathUtilsClassInfo();
    return ci;
  }
}

MathUtilsValue MathUtils_new(AnyGC this__) {
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


class Printable3ClassInfo extends ClassInfo {
  Function? prettyPrint;
}

class Printable3Value extends AnyGC {
  static Printable3ClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Printable3ClassInfo _initClassInfo() {
    final ci = Printable3ClassInfo();
    ci.prettyPrint = Printable3_prettyPrint;
    return ci;
  }
}

Printable3Value Printable3_new(AnyGC this__) {
  final this_ = this__ as Printable3Value;
  return this_;
}

String Printable3_prettyPrint(dynamic this_) {
  throw UnimplementedError('Printable3.prettyPrint is abstract');
}


class ScoreClassInfo extends Printable3ClassInfo {
  Function? compareTo2;
  Function? isLessThan;
  Function? isGreaterThan;
}

class ScoreValue extends AnyGC implements Printable3Value {
  late String subject;
  late int points;
  static ScoreClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ScoreClassInfo _initClassInfo() {
    final ci = ScoreClassInfo();
    ci.prettyPrint = Score_prettyPrint;
    ci.compareTo2 = Score_compareTo2;
    ci.isLessThan = Score_isLessThan;
    ci.isGreaterThan = Score_isGreaterThan;
    ci.toString_ = Score_toString;
    return ci;
  }
}

ScoreValue Score_new(AnyGC this__, String subject, int points) {
  final this_ = this__ as ScoreValue;
  this_.subject = subject;
  this_.points = points;
  return this_;
}

int Score_compareTo2(AnyGC this__, ScoreValue other) {
  final this_ = this__ as ScoreValue;
  return this_.points.compareTo(other.points);
}

bool Score_isLessThan(AnyGC this__, ScoreValue other) {
  final this_ = this__ as ScoreValue;
  return ((this_.classInfo as ScoreClassInfo).compareTo2!(this_, other) < 0);
}

bool Score_isGreaterThan(AnyGC this__, ScoreValue other) {
  final this_ = this__ as ScoreValue;
  return ((this_.classInfo as ScoreClassInfo).compareTo2!(this_, other) > 0);
}

String Score_prettyPrint(AnyGC this__) {
  final this_ = this__ as ScoreValue;
  return '[${this_.subject}: ${this_.points} pts]';
}

String Score_toString(AnyGC this__) {
  final this_ = this__ as ScoreValue;
  return 'Score(${this_.subject}, ${this_.points})';
}


class WeightedScoreClassInfo extends ScoreClassInfo {
  Function? get_weightedPoints;
}

class WeightedScoreValue extends ScoreValue {
  late double weight;
  static WeightedScoreClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static WeightedScoreClassInfo _initClassInfo() {
    final ci = WeightedScoreClassInfo();
    ci.prettyPrint = WeightedScore_prettyPrint;
    ci.compareTo2 = WeightedScore_compareTo2;
    ci.isLessThan = WeightedScore_isLessThan;
    ci.isGreaterThan = WeightedScore_isGreaterThan;
    ci.toString_ = WeightedScore_toString;
    ci.get_weightedPoints = WeightedScore_get_weightedPoints;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

WeightedScoreValue WeightedScore_new(AnyGC this__, String subject, int points, double weight) {
  final this_ = this__ as WeightedScoreValue;
  Score_new(this_, subject, points);
  this_.weight = weight;
  return this_;
}

double WeightedScore_get_weightedPoints(AnyGC this__) {
  final this_ = this__ as WeightedScoreValue;
  return (this_.points * this_.weight);
}

int WeightedScore_compareTo2(AnyGC this__, ScoreValue other) {
  final this_ = this__ as WeightedScoreValue;
  if ((other is WeightedScoreValue)) {
    return (this_.classInfo as WeightedScoreClassInfo).get_weightedPoints!(this_).compareTo((other.classInfo as WeightedScoreClassInfo).get_weightedPoints!(other));
  }
  return Score_compareTo2(this_, other);
}

String WeightedScore_prettyPrint(AnyGC this__) {
  final this_ = this__ as WeightedScoreValue;
  return '[${this_.subject}: ${this_.points} pts × ${this_.weight} = ${(this_.classInfo as WeightedScoreClassInfo).get_weightedPoints!(this_).toStringAsFixed(1)}]';
}

String WeightedScore_toString(AnyGC this__) {
  final this_ = this__ as WeightedScoreValue;
  return 'WeightedScore(${this_.subject}, ${this_.points}, w=${this_.weight})';
}

bool WeightedScore_isLessThan(AnyGC this__, ScoreValue other) {
  final this_ = this__ as WeightedScoreValue;
  return Score_isLessThan(this_, other);
}

bool WeightedScore_isGreaterThan(AnyGC this__, ScoreValue other) {
  final this_ = this__ as WeightedScoreValue;
  return Score_isGreaterThan(this_, other);
}


class TextProcessorClassInfo extends ClassInfo {
}

class TextProcessorValue extends AnyGC {
  static TextProcessorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static TextProcessorClassInfo _initClassInfo() {
    final ci = TextProcessorClassInfo();
    return ci;
  }
}

TextProcessorValue TextProcessor_new(AnyGC this__) {
  final this_ = this__ as TextProcessorValue;
  return this_;
}

String TextProcessor_camelToSnake(String input) {
  final StaticStringBuffer result = StaticStringBuffer();
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
  final String rest = parts.skip(1).map(ClosureEnv_anon_8_new(GC.allocateLocal(ClosureEnv_anon_8()))).join();
  return '${first}${rest}';
}

StaticMap<String, int> TextProcessor_wordFrequency(String text) {
  final StaticList<String> words = StaticList.of(text.toLowerCase().replaceAll(StaticRegExp('[^a-z\\s]'), '').split(StaticRegExp('\\s+')).where(ClosureEnv_anon_9_new(GC.allocateLocal(ClosureEnv_anon_9()))).toList());
  final StaticMap<String, int> freq = StaticMap<String, int>.of({});
{
    StaticIterator<String> sync_for_iterator = StaticIterator(words.iterator);
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
  _L22: do {
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
  _L23: do {
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

class JsonLikeProcessorClassInfo extends ClassInfo {
}

class JsonLikeProcessorValue extends AnyGC {
  static JsonLikeProcessorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static JsonLikeProcessorClassInfo _initClassInfo() {
    final ci = JsonLikeProcessorClassInfo();
    return ci;
  }
}

JsonLikeProcessorValue JsonLikeProcessor_new(AnyGC this__) {
  final this_ = this__ as JsonLikeProcessorValue;
  return this_;
}

dynamic JsonLikeProcessor_deepMerge(StaticMap<String, dynamic> base, StaticMap<String, dynamic> overlay) {
  final StaticMap<String, dynamic> result = StaticMap<String, dynamic>.from(base);
{
    StaticIterator<String> sync_for_iterator = StaticIterator(overlay.keys.iterator);
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
    StaticIterator<StaticMapEntry<String, dynamic>> sync_for_iterator = StaticIterator(map.entries.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final StaticMapEntry<String, dynamic> entry = sync_for_iterator.current;
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


class Matrix2DClassInfo extends ClassInfo {
  Function? get;
  Function? operatorPlus;
  Function? operatorStar;
  Function? get_trace;
}

class Matrix2DValue extends AnyGC {
  late StaticList<StaticList<double>> _data;
  late int rows;
  late int cols;
  static Matrix2DClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Matrix2DClassInfo _initClassInfo() {
    final ci = Matrix2DClassInfo();
    ci.get = Matrix2D_get;
    ci.operatorPlus = Matrix2D_operatorPlus;
    ci.operatorStar = Matrix2D_operatorStar;
    ci.get_trace = Matrix2D_get_trace;
    ci.toString_ = Matrix2D_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_data is AnyGC) (_data as AnyGC).gcMark(flag);
  }
}

Matrix2DValue Matrix2D_new(AnyGC this__, StaticList<StaticList<double>> _data) {
  final this_ = this__ as Matrix2DValue;
  this_._data = _data;
  this_.rows = _data.length;
  this_.cols = (_data.isEmpty ? 0 : _data[0].length);
  return this_;
}

Matrix2DValue Matrix2D_new_zeros(AnyGC this__, int rows, int cols) {
  final this_ = this__ as Matrix2DValue;
  this_.rows = rows;
  this_.cols = cols;
  this_._data = StaticList<StaticList<double>>.generate(rows, ClosureEnv_anon_10_new(GC.allocateLocal(ClosureEnv_anon_10()), cols));
  return this_;
}

Matrix2DValue Matrix2D_new_identity(AnyGC this__, int size) {
  final this_ = this__ as Matrix2DValue;
  this_.rows = size;
  this_.cols = size;
  this_._data = StaticList<StaticList<double>>.generate(size, ClosureEnv_anon_11_new(GC.allocateLocal(ClosureEnv_anon_11()), size));
  return this_;
}

double Matrix2D_get(AnyGC this__, int row, int col) {
  final this_ = this__ as Matrix2DValue;
  return this_._data[row][col];
}

Matrix2DValue Matrix2D_operatorPlus(AnyGC this__, Matrix2DValue other) {
  final this_ = this__ as Matrix2DValue;
  final Matrix2DValue result = Matrix2D_new_zeros(GC.allocateLocal(Matrix2DValue()), this_.rows, this_.cols);
  for (var i = 0; (i < this_.rows); i = (i + 1)) {
    for (var j = 0; (j < this_.cols); j = (j + 1)) {
      result._data[i][j] = (this_._data[i][j] + other._data[i][j]);
    }
  }
  return result;
}

Matrix2DValue Matrix2D_operatorStar(AnyGC this__, Matrix2DValue other) {
  final this_ = this__ as Matrix2DValue;
  final Matrix2DValue result = Matrix2D_new_zeros(GC.allocateLocal(Matrix2DValue()), this_.rows, other.cols);
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

double Matrix2D_get_trace(AnyGC this__) {
  final this_ = this__ as Matrix2DValue;
  double sum = 0.0;
  final int minDim = ((this_.rows < this_.cols) ? this_.rows : this_.cols);
  for (var i = 0; (i < minDim); i = (i + 1)) {
    sum = (sum + this_._data[i][i]);
  }
  return sum;
}

String Matrix2D_toString(AnyGC this__) {
  final this_ = this__ as Matrix2DValue;
  final String rowStrings = this_._data.map(ClosureEnv_anon_13_new(GC.allocateLocal(ClosureEnv_anon_13()))).map(ClosureEnv_anon_15_new(GC.allocateLocal(ClosureEnv_anon_15()))).join(', ');
  return 'Matrix(${this_.rows}x${this_.cols}: ${rowStrings})';
}


class EntityClassInfo extends ClassInfo {
  Function? get_entityId;
}

class EntityValue extends AnyGC {
  static EntityClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static EntityClassInfo _initClassInfo() {
    final ci = EntityClassInfo();
    ci.get_entityId = Entity_get_entityId;
    return ci;
  }
}

EntityValue Entity_new(AnyGC this__) {
  final this_ = this__ as EntityValue;
  return this_;
}

String Entity_get_entityId(dynamic this_) {
  throw UnimplementedError('Entity.entityId is abstract');
}


// mixin Auditable → static functions for delegation
void Auditable_audit(AnyGC this__, String action) {
  final dynamic this_ = this__;
  this_._auditLog.add('[${(this_.classInfo as dynamic).get_entityId!(this_)}] ${action}');
}

StaticList<String> Auditable_get_auditLog(AnyGC this__) {
  final dynamic this_ = this__;
  return StaticList<String>.unmodifiable(this_._auditLog);
}


// mixin Cacheable → static functions for delegation
void Cacheable_markDirty(AnyGC this__) {
  final dynamic this_ = this__;
  this_._isDirty = true;
}

void Cacheable_markCached(AnyGC this__) {
  final dynamic this_ = this__;
  this_._isDirty = false;
  this_._cachedAt = StaticDateTime.now();
}

bool Cacheable_get_isDirty(AnyGC this__) {
  final dynamic this_ = this__;
  return this_._isDirty;
}

String Cacheable_get_cacheStatus(AnyGC this__) {
  final dynamic this_ = this__;
  return (this_._isDirty ? 'dirty' : 'cached');
}


class ProductClassInfo extends Product_Entity_Auditable_CacheableClassInfo {
}

class ProductValue extends Product_Entity_Auditable_CacheableValue {
  late String entityId;
  late String name;
  late double price;
  static ProductClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ProductClassInfo _initClassInfo() {
    final ci = ProductClassInfo();
    ci.get_entityId = Product_get_entityId;
    ci.audit = Product_audit;
    ci.get_auditLog = Product_get_auditLog;
    ci.markDirty = Product_markDirty;
    ci.markCached = Product_markCached;
    ci.get_isDirty = Product_get_isDirty;
    ci.get_cacheStatus = Product_get_cacheStatus;
    ci.toString_ = Product_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

ProductValue Product_new(AnyGC this__, String entityId, String name, double price) {
  final this_ = this__ as ProductValue;
  Entity_new(this_);
  this_.entityId = entityId;
  this_.name = name;
  this_.price = price;
  return this_;
}

String Product_toString(AnyGC this__) {
  final this_ = this__ as ProductValue;
  return 'Product(${this_.entityId}, ${this_.name}, \$${this_.price}, ${(this_.classInfo as ProductClassInfo).get_cacheStatus!(this_)}, audits=${this_._auditLog.length})';
}

String Product_get_entityId(AnyGC this__) {
  final this_ = this__ as ProductValue;
  return this_.entityId;
}

void Product_audit(AnyGC this__, String action) {
  final this_ = this__ as ProductValue;
  Auditable_audit(this_, action);
}

StaticList<String> Product_get_auditLog(AnyGC this__) {
  final this_ = this__ as ProductValue;
  return Auditable_get_auditLog(this_);
}

void Product_markDirty(AnyGC this__) {
  final this_ = this__ as ProductValue;
  Cacheable_markDirty(this_);
}

void Product_markCached(AnyGC this__) {
  final this_ = this__ as ProductValue;
  Cacheable_markCached(this_);
}

bool Product_get_isDirty(AnyGC this__) {
  final this_ = this__ as ProductValue;
  return Cacheable_get_isDirty(this_);
}

String Product_get_cacheStatus(AnyGC this__) {
  final this_ = this__ as ProductValue;
  return Cacheable_get_cacheStatus(this_);
}


class UserProfile_Object_SerializableClassInfo extends ClassInfo {
  Function? toMap;
  Function? serialize;
}

class UserProfile_Object_SerializableValue extends AnyGC {
  static UserProfile_Object_SerializableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static UserProfile_Object_SerializableClassInfo _initClassInfo() {
    final ci = UserProfile_Object_SerializableClassInfo();
    return ci;
  }
}


class UserProfile_Object_Serializable_ValidatableClassInfo extends UserProfile_Object_SerializableClassInfo {
  Function? validate;
  Function? get_isValid;
  Function? get_validationSummary;
}

class UserProfile_Object_Serializable_ValidatableValue extends UserProfile_Object_SerializableValue {
  static UserProfile_Object_Serializable_ValidatableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static UserProfile_Object_Serializable_ValidatableClassInfo _initClassInfo() {
    final ci = UserProfile_Object_Serializable_ValidatableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Product_Entity_AuditableClassInfo extends EntityClassInfo {
  Function? audit;
  Function? get_auditLog;
}

class Product_Entity_AuditableValue extends EntityValue {
  late StaticList<String> _auditLog = StaticList<String>();
  static Product_Entity_AuditableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Product_Entity_AuditableClassInfo _initClassInfo() {
    final ci = Product_Entity_AuditableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_auditLog is AnyGC) (_auditLog as AnyGC).gcMark(flag);
  }
}


class Product_Entity_Auditable_CacheableClassInfo extends Product_Entity_AuditableClassInfo {
  Function? markDirty;
  Function? markCached;
  Function? get_isDirty;
  Function? get_cacheStatus;
}

class Product_Entity_Auditable_CacheableValue extends Product_Entity_AuditableValue {
  late StaticDateTime? _cachedAt = null;
  late bool _isDirty = true;
  static Product_Entity_Auditable_CacheableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Product_Entity_Auditable_CacheableClassInfo _initClassInfo() {
    final ci = Product_Entity_Auditable_CacheableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_cachedAt is AnyGC) (_cachedAt as AnyGC).gcMark(flag);
  }
}


dynamic makeCounter({int start = 0, int step = 1}) {
  IntBox current = IntBox(start);
  return ClosureEnv_makeCounter_16_new(GC.allocateLocal(ClosureEnv_makeCounter_16()), current, step);
}

dynamic makeAccumulator(int initial) {
  IntBox total = IntBox(initial);
  return ClosureEnv_makeAccumulator_17_new(GC.allocateLocal(ClosureEnv_makeAccumulator_17()), total);
}

StaticList<dynamic> makeClosureList(int count) {
  final StaticList<dynamic> closures = StaticList<dynamic>();
  for (var i = 0; (i < count); i = (i + 1)) {
    closures.add(ClosureEnv_makeClosureList_19_new(GC.allocateLocal(ClosureEnv_makeClosureList_19()), i));
  }
  return closures;
}

TypeFunction1<C, A> composeFunc<A, B, C>(TypeFunction1<C, B> funcBC, TypeFunction1<B, A> funcAB) {
  return ClosureEnv_composeFunc_20_new<C, B, A>(GC.allocateLocal(ClosureEnv_composeFunc_20<C, B, A>()), funcBC, funcAB);
}

TypeFunction1<TypeFunction1<C, B>, A> curry<A, B, C>(TypeFunction2<C, A, B> biFunc) {
  return ClosureEnv_curry_21_new<C, A, B>(GC.allocateLocal(ClosureEnv_curry_21<C, A, B>()), biFunc);
}

T pipe<T>(T value, StaticList<TypeFunction1<T, T>> transforms) {
  T result = value;
{
    StaticIterator<TypeFunction1<T, T>> sync_for_iterator = StaticIterator(transforms.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final TypeFunction1<T, T> transform = sync_for_iterator.current;
{
        result = transform.call(result);
      }
    }
  }
  return result;
}

TypeFunction1<B, A> memoize<A, B>(TypeFunction1<B, A> func) {
  final StaticMap<A, B> cache = StaticMap<A, B>.of({});
  return ClosureEnv_memoize_23_new<A, B>(GC.allocateLocal(ClosureEnv_memoize_23<A, B>()), cache, func);
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
    _L26:
    for (var i = 2; ((i * i) <= number); i = (i + 1)) {
      if (((number % i) == 0)) {
        isPrime = false;
        break _L26;
      }
    }
    if ((isPrime && (number > 1))) {
      result = (result + '_prime');
    }
 else     if ((number > 1)) {
      _L27:
      for (var i = 2; (i <= number); i = (i + 1)) {
        if (((number % i) == 0)) {
          result = (result + '_composite(smallest_factor=${i})');
          break _L27;
        }
      }
    }
  }
  return result;
}

StaticList<int> parseNumbers(StaticList<String> inputs) {
  final StaticList<int> results = StaticList<int>();
  for (var i = 0; (i < inputs.length); i = (i + 1))   _L28: do {
{
      try {
        final String trimmed = inputs[i].trim();
        if (trimmed.isEmpty)         break _L28;
        final int value = int.parse(trimmed);
        if ((value < 0)) {
          throw DartArgumentError('Negative value at index ${i}: ${value}');
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
  if ((this_ < 0))   throw DartArgumentError('Factorial not defined for negative numbers');
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
  return this_.reduce(ClosureEnv_IterableStats_get_sum_27_new<T>(GC.allocateLocal(ClosureEnv_IterableStats_get_sum_27<T>())));
}

double IterableStats_get_average<T extends num>(final Iterable<T> this_) {
  return (this_.isEmpty ? 0.0 : (IterableStats_get_sum(this_) / this_.length));
}

T IterableStats_get_max<T extends num>(final Iterable<T> this_) {
  return this_.reduce(ClosureEnv_IterableStats_get_max_28_new<T>(GC.allocateLocal(ClosureEnv_IterableStats_get_max_28<T>())));
}

T IterableStats_get_min<T extends num>(final Iterable<T> this_) {
  return this_.reduce(ClosureEnv_IterableStats_get_min_29_new<T>(GC.allocateLocal(ClosureEnv_IterableStats_get_min_29<T>())));
}

void main() {
  staticPrint('=== 高级语法还原测试 ===\n');
  staticPrint('--- 1. 嵌套闭包 ---');
  final dynamic counter = makeCounter(start: 5, step: 3);
  staticPrint('counter: ${counter.call()}, ${counter.call()}, ${counter.call()}');
  final dynamic acc = makeAccumulator(100);
  final dynamic snap1 = acc.call(10);
  final dynamic snap2 = acc.call(20);
  staticPrint('snap1: ${snap1.call()}');
  staticPrint('snap2: ${snap2.call()}');
  final StaticList<dynamic> closures = StaticList<dynamic>.of(makeClosureList(4));
{
    StaticIterator<dynamic> sync_for_iterator = StaticIterator(closures.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final dynamic cl = sync_for_iterator.current;
{
        staticPrint('  ${cl.call()}');
      }
    }
  }
  staticPrint('\n--- 2. 二叉树 ---');
  final TreeNodeValue<int> tree = TreeNode_new<int>(GC.allocateLocal(TreeNodeValue<int>()), 1, TreeNode_new<int>(GC.allocateLocal(TreeNodeValue<int>()), 2, TreeNode_new<int>(GC.allocateLocal(TreeNodeValue<int>()), 4), TreeNode_new<int>(GC.allocateLocal(TreeNodeValue<int>()), 5)), TreeNode_new<int>(GC.allocateLocal(TreeNodeValue<int>()), 3, null, TreeNode_new<int>(GC.allocateLocal(TreeNodeValue<int>()), 6)));
  staticPrint('preorder: ${(tree.classInfo as TreeNodeClassInfo).preorder!(tree)}');
  staticPrint('inorder: ${(tree.classInfo as TreeNodeClassInfo).inorder!(tree)}');
  staticPrint('depth: ${(tree.classInfo as TreeNodeClassInfo).get_depth!(tree)}');
  final TreeNodeValue<String> strTree = (tree.classInfo as TreeNodeClassInfo).map_String!(tree, ClosureEnv_main_30_new(GC.allocateLocal(ClosureEnv_main_30())));
  staticPrint('mapped preorder: ${(strTree.classInfo as TreeNodeClassInfo).preorder!(strTree)}');
  staticPrint('\n--- 3. 链表 ---');
  final LinkedNodeValue<int> list = LinkedNode_new<int>(GC.allocateLocal(LinkedNodeValue<int>()), 1, LinkedNode_new<int>(GC.allocateLocal(LinkedNodeValue<int>()), 2, LinkedNode_new<int>(GC.allocateLocal(LinkedNodeValue<int>()), 3, LinkedNode_new<int>(GC.allocateLocal(LinkedNodeValue<int>()), 4))));
  staticPrint('list: ${list}');
  staticPrint('length: ${(list.classInfo as LinkedNodeClassInfo).get_length!(list)}');
  final LinkedNodeValue<int> revList = (list.classInfo as LinkedNodeClassInfo).reversed!(list);
  staticPrint('reversed: ${revList}');
  staticPrint('\n--- 6. 多重嵌套控制流 ---');
  final StaticList<int> testNumbers = StaticList<int>.of([(-150), (-42), (-3), 0, 1, 7, 12, 97]);
{
    StaticIterator<int> sync_for_iterator = StaticIterator(testNumbers.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final int n = sync_for_iterator.current;
{
        staticPrint('  ${n} → ${classifyNumber(n)}');
      }
    }
  }
  staticPrint('parseNumbers: ${parseNumbers(StaticList<String>.of(['10', 'abc', ' 42 ', '-5', '', '7']))}');
  staticPrint('\n--- 7. mixin 组合 ---');
  final UserProfileValue user1 = UserProfile_new(GC.allocateLocal(UserProfileValue()), 'Alice', 'alice@example.com', 25);
  staticPrint('user1: ${user1}');
  staticPrint('serialize: ${(user1.classInfo as UserProfileClassInfo).serialize!(user1)}');
  staticPrint('validation: ${(user1.classInfo as UserProfileClassInfo).get_validationSummary!(user1)}');
  final UserProfileValue user2 = UserProfile_new(GC.allocateLocal(UserProfileValue()), '', 'invalid-email', (-5));
  staticPrint('user2 validation: ${(user2.classInfo as UserProfileClassInfo).get_validationSummary!(user2)}');
  staticPrint('\n--- 8. 模板方法模式 ---');
  final StringToIntTransformerValue strToInt = StringToIntTransformer_new(GC.allocateLocal(StringToIntTransformerValue()));
  staticPrint('strToInt("  42  "): ${(strToInt.classInfo as StringToIntTransformerClassInfo).transform!(strToInt, '  42  ')}');
  final IntToStringTransformerValue intToStr = IntToStringTransformer_new(GC.allocateLocal(IntToStringTransformerValue()), 'NUM:');
  staticPrint('intToStr(123): ${(intToStr.classInfo as IntToStringTransformerClassInfo).transform!(intToStr, 123)}');
  final ChainedTransformerValue<String, int, String> chained2 = ChainedTransformer_new<String, int, String>(GC.allocateLocal(ChainedTransformerValue<String, int, String>()), strToInt, intToStr);
  staticPrint('chained(" 99 "): ${(chained2.classInfo as ChainedTransformerClassInfo).transform!(chained2, ' 99 ')}');
  staticPrint('\n--- 9. 单例 Registry ---');
  final RegistryValue reg1 = Registry_new();
  final RegistryValue reg2 = Registry_new();
  staticPrint('same instance: ${identical(reg1, reg2)}');
  (reg1.classInfo as RegistryClassInfo).register!(reg1, 'name', StringBox('Dart'));
  (reg1.classInfo as RegistryClassInfo).register!(reg1, 'version', IntBox(3));
  staticPrint('registry: ${reg1}');
  staticPrint('lookup name: ${(reg2.classInfo as RegistryClassInfo).lookup!(reg2, 'name')}');
  staticPrint('keys: ${(reg1.classInfo as RegistryClassInfo).get_keys!(reg1)}');
  (reg1.classInfo as RegistryClassInfo).clear!(reg1);
  staticPrint('\n--- 10. 集合操作链 ---');
  final StaticList<StaticMap<String, Object>> records = StaticList<StaticMap<String, Object>>.of([StaticMap<String, Object>.of({'name': 'Alice', 'score': 95}), StaticMap<String, Object>.of({'name': 'Bob', 'score': 72}), StaticMap<String, Object>.of({'name': 'Carol', 'score': 88}), StaticMap<String, Object>.of({'name': 'Dave', 'score': 45}), StaticMap<String, Object>.of({'name': 'Eve', 'score': 91}), StaticMap<String, Object>.of({'name': 'Frank', 'score': 63})]);
  final StaticList<StaticMap<String, dynamic>> processed = StaticList<StaticMap<String, dynamic>>.of(DataProcessor_processRecords(records));
{
    StaticIterator<StaticMap<String, dynamic>> sync_for_iterator = StaticIterator(processed.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final StaticMap<String, dynamic> r = StaticMap<String, dynamic>.of(sync_for_iterator.current);
{
        staticPrint('  ${r['name']}: ${r['score']} (${r['grade']}, passed=${r['passed']})');
      }
    }
  }
  final StaticMap<String, double> averages = StaticMap<String, double>.of(DataProcessor_averageByGrade(processed));
  staticPrint('averages: ${averages}');
  staticPrint('\n--- 11. late 变量 ---');
  final ExpensiveComputationValue comp = ExpensiveComputation_new(GC.allocateLocal(ExpensiveComputationValue()), 42);
  staticPrint('comp: ${comp}');
  staticPrint('computedValue: ${comp.computedValue}');
  (comp.classInfo as ExpensiveComputationClassInfo).initialize!(comp, 'test description');
  staticPrint('description: ${comp.description}');
  staticPrint('\n--- 12. 局部函数 + 递归 ---');
  staticPrint('fibonacci(10): ${MathUtils_fibonacci(10)}');
  staticPrint('fibonacci(20): ${MathUtils_fibonacci(20)}');
  staticPrint('primeFactors(360): ${MathUtils_primeFactors(360)}');
  staticPrint('gcd(48, 18): ${MathUtils_gcd(48, 18)}');
  staticPrint('lcm(12, 18): ${MathUtils_lcm(12, 18)}');
  staticPrint('\n--- 13. 多重 implements ---');
  final StaticList<ScoreValue> scores = StaticList<ScoreValue>.of([Score_new(GC.allocateLocal(ScoreValue()), 'Math', 90), Score_new(GC.allocateLocal(ScoreValue()), 'English', 75), WeightedScore_new(GC.allocateLocal(WeightedScoreValue()), 'Physics', 85, 1.5), WeightedScore_new(GC.allocateLocal(WeightedScoreValue()), 'Art', 95, 0.5)]);
{
    StaticIterator<ScoreValue> sync_for_iterator = StaticIterator(scores.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final ScoreValue s = sync_for_iterator.current;
{
        staticPrint('  ${(s.classInfo as ScoreClassInfo).prettyPrint!(s)}');
      }
    }
  }
  final WeightedScoreValue ws1 = (scores[2] as WeightedScoreValue);
  final WeightedScoreValue ws2 = (scores[3] as WeightedScoreValue);
  staticPrint('physics > art (weighted): ${(ws1.classInfo as WeightedScoreClassInfo).isGreaterThan!(ws1, ws2)}');
  staticPrint('\n--- 14. 字符串操作 ---');
  staticPrint('camelToSnake("helloWorldFoo"): ${TextProcessor_camelToSnake('helloWorldFoo')}');
  staticPrint('snakeToCamel("hello_world_foo"): ${TextProcessor_snakeToCamel('hello_world_foo')}');
  final StaticMap<String, int> freq = StaticMap<String, int>.of(TextProcessor_wordFrequency('the quick brown fox jumps over the lazy fox'));
  staticPrint('word frequency: ${freq}');
  staticPrint('truncate: ${TextProcessor_truncate('Hello, World! This is a long string.', 20)}');
  staticPrint('\n--- 15. async 链 ---');
  final String asyncResult = smAwait(asyncTransform(5));
  staticPrint('asyncTransform(5): ${asyncResult}');
  final StaticList<int> asyncSeq = StaticList<int>.of(smAwait(asyncSequence(5)));
  staticPrint('asyncSequence(5): ${asyncSeq}');
  staticPrint('\n--- 16. 增强枚举 ---');
{
    StaticIterator<Season> sync_for_iterator = StaticIterator(const [Season.spring, Season.summer, Season.autumn, Season.winter].iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final Season s = sync_for_iterator.current;
{
        staticPrint('  ${s} → ${Season_get_displayName(s)}, next=${Season_get_displayName(Season_get_next(s))}, warm=${Season_get_isWarm(s)}');
      }
    }
  }
  staticPrint('\n--- 17. 嵌套 Map 操作 ---');
  final StaticMap<String, Object> base = StaticMap<String, Object>.of({'a': 1, 'b': StaticMap<String, int>.of({'x': 10, 'y': 20}), 'c': 3});
  final StaticMap<String, Object> overlay = StaticMap<String, Object>.of({'b': StaticMap<String, int>.of({'y': 99, 'z': 30}), 'd': 4});
  final dynamic merged = JsonLikeProcessor_deepMerge(base, overlay);
  staticPrint('deepMerge: ${merged}');
  final StaticMap<String, Object> nested = StaticMap<String, Object>.of({'user': StaticMap<String, Object>.of({'name': 'Alice', 'address': StaticMap<String, String>.of({'city': 'NYC', 'zip': '10001'})}), 'role': 'admin'});
  staticPrint('flattenKeys: ${JsonLikeProcessor_flattenKeys(nested)}');
  staticPrint('\n--- 18. 扩展方法 ---');
  staticPrint('7.isPrime: ${IntMathExtension_get_isPrime(7)}');
  staticPrint('12.isPrime: ${IntMathExtension_get_isPrime(12)}');
  staticPrint('5.factorial: ${IntMathExtension_get_factorial(5)}');
  staticPrint('12345.digits: ${IntMathExtension_get_digits(12345)}');
  final StaticList<int> nums = StaticList<int>.of([10, 20, 30, 40, 50]);
  staticPrint('sum: ${IterableStats_get_sum(nums)}, avg: ${IterableStats_get_average(nums)}, max: ${IterableStats_get_max(nums)}, min: ${IterableStats_get_min(nums)}');
  staticPrint('\n--- 19. Matrix2D ---');
  final Matrix2DValue m1 = Matrix2D_new(GC.allocateLocal(Matrix2DValue()), StaticList<StaticList<double>>.of([StaticList<double>.of([1.0, 2.0]), StaticList<double>.of([3.0, 4.0])]));
  final Matrix2DValue m2 = Matrix2D_new_identity(GC.allocateLocal(Matrix2DValue()), 2);
  staticPrint('m1: ${m1}');
  staticPrint('m2 (identity): ${m2}');
  staticPrint('m1 + m2: ${(m1.classInfo as Matrix2DClassInfo).operatorPlus!(m1, m2)}');
  staticPrint('m1 * m2: ${(m1.classInfo as Matrix2DClassInfo).operatorStar!(m1, m2)}');
  staticPrint('m1 trace: ${(m1.classInfo as Matrix2DClassInfo).get_trace!(m1)}');
  final Matrix2DValue m3 = Matrix2D_new_zeros(GC.allocateLocal(Matrix2DValue()), 2, 3);
  staticPrint('zeros(2,3): ${m3}');
  staticPrint('\n--- 20. 综合 mixin + 抽象类 ---');
  final ProductValue product = Product_new(GC.allocateLocal(ProductValue()), 'P001', 'Widget', 9.99);
  (product.classInfo as ProductClassInfo).audit!(product, 'created');
  (product.classInfo as ProductClassInfo).audit!(product, 'priced');
  (product.classInfo as ProductClassInfo).markCached!(product);
  staticPrint('product: ${product}');
  staticPrint('auditLog: ${(product.classInfo as ProductClassInfo).get_auditLog!(product)}');
  (product.classInfo as ProductClassInfo).markDirty!(product);
  staticPrint('after markDirty: ${(product.classInfo as ProductClassInfo).get_cacheStatus!(product)}');
  staticPrint('\n=== 所有高级语法测试通过 ✅ ===');
  drainScheduler();
}

class ClosureEnv_anon_0 extends TypeFunction1<String, StaticMapEntry<String, dynamic>> {
  ClosureEnv_anon_0();
  @override
  String call(StaticMapEntry<String, dynamic> e) => fnPtr(this, e);
}
ClosureEnv_anon_0 ClosureEnv_anon_0_new(ClosureEnv_anon_0 env_) {
  env_.fnPtr = ClosureEnv_anon_0_call;
  return env_;
}
String ClosureEnv_anon_0_call(AnyGC env__, StaticMapEntry<String, dynamic> e) {
  final env = env__ as ClosureEnv_anon_0;

  return '${e.key}=${e.value}';
}

class ClosureEnv_anon_1 extends TypeFunction2<int, StaticMap<String, dynamic>, StaticMap<String, dynamic>> {
  ClosureEnv_anon_1();
  @override
  int call(StaticMap<String, dynamic> a, StaticMap<String, dynamic> b) => fnPtr(this, a, b);
}
ClosureEnv_anon_1 ClosureEnv_anon_1_new(ClosureEnv_anon_1 env_) {
  env_.fnPtr = ClosureEnv_anon_1_call;
  return env_;
}
int ClosureEnv_anon_1_call(AnyGC env__, StaticMap<String, dynamic> a, StaticMap<String, dynamic> b) {
  final env = env__ as ClosureEnv_anon_1;

  return (b['score'] as int).compareTo((a['score'] as int));
}

class ClosureEnv_anon_2 extends TypeFunction1<bool, StaticMap<String, dynamic>> {
  ClosureEnv_anon_2();
  @override
  bool call(StaticMap<String, dynamic> r) => fnPtr(this, r);
}
ClosureEnv_anon_2 ClosureEnv_anon_2_new(ClosureEnv_anon_2 env_) {
  env_.fnPtr = ClosureEnv_anon_2_call;
  return env_;
}
bool ClosureEnv_anon_2_call(AnyGC env__, StaticMap<String, dynamic> r) {
  final env = env__ as ClosureEnv_anon_2;

  return (r.containsKey('name') && r.containsKey('score'));
}

class ClosureEnv_anon_3 extends TypeFunction1<bool, StaticMap<String, dynamic>> {
  ClosureEnv_anon_3();
  @override
  bool call(StaticMap<String, dynamic> r) => fnPtr(this, r);
}
ClosureEnv_anon_3 ClosureEnv_anon_3_new(ClosureEnv_anon_3 env_) {
  env_.fnPtr = ClosureEnv_anon_3_call;
  return env_;
}
bool ClosureEnv_anon_3_call(AnyGC env__, StaticMap<String, dynamic> r) {
  final env = env__ as ClosureEnv_anon_3;

  return ((r['score'] as int) >= 0);
}

class ClosureEnv_anon_4 extends TypeFunction1<StaticMap<String, Object>, StaticMap<String, dynamic>> {
  ClosureEnv_anon_4();
  @override
  StaticMap<String, Object> call(StaticMap<String, dynamic> r) => fnPtr(this, r);
}
ClosureEnv_anon_4 ClosureEnv_anon_4_new(ClosureEnv_anon_4 env_) {
  env_.fnPtr = ClosureEnv_anon_4_call;
  return env_;
}
StaticMap<String, Object> ClosureEnv_anon_4_call(AnyGC env__, StaticMap<String, dynamic> r) {
  final env = env__ as ClosureEnv_anon_4;

  return StaticMap<String, Object>.of({'name': (r['name'] as String).toUpperCase(), 'score': (r['score'] as int), 'grade': DataProcessor__scoreToGrade((r['score'] as int)), 'passed': ((r['score'] as int) >= 60)});
}

class ClosureEnv_anon_5 extends TypeFunction0<StaticList<StaticMap<String, dynamic>>> {
  ClosureEnv_anon_5();
  @override
  StaticList<StaticMap<String, dynamic>> call() => fnPtr(this);
}
ClosureEnv_anon_5 ClosureEnv_anon_5_new(ClosureEnv_anon_5 env_) {
  env_.fnPtr = ClosureEnv_anon_5_call;
  return env_;
}
StaticList<StaticMap<String, dynamic>> ClosureEnv_anon_5_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_5;

  return StaticList<StaticMap<String, dynamic>>();
}

class ClosureEnv_ClosureEnv_anon_6_7 extends TypeFunction2<int, int, StaticMap<String, dynamic>> {
  ClosureEnv_ClosureEnv_anon_6_7();
  @override
  int call(int sum, StaticMap<String, dynamic> r) => fnPtr(this, sum, r);
}
ClosureEnv_ClosureEnv_anon_6_7 ClosureEnv_ClosureEnv_anon_6_7_new(ClosureEnv_ClosureEnv_anon_6_7 env_) {
  env_.fnPtr = ClosureEnv_ClosureEnv_anon_6_7_call;
  return env_;
}
int ClosureEnv_ClosureEnv_anon_6_7_call(AnyGC env__, int sum, StaticMap<String, dynamic> r) {
  final env = env__ as ClosureEnv_ClosureEnv_anon_6_7;

  return (sum + (r['score'] as int));
}

class ClosureEnv_anon_6 extends TypeFunction2<StaticMapEntry<String, double>, String, StaticList<StaticMap<String, dynamic>>> {
  ClosureEnv_anon_6();
  @override
  StaticMapEntry<String, double> call(String grade, StaticList<StaticMap<String, dynamic>> items) => fnPtr(this, grade, items);
}
ClosureEnv_anon_6 ClosureEnv_anon_6_new(ClosureEnv_anon_6 env_) {
  env_.fnPtr = ClosureEnv_anon_6_call;
  return env_;
}
StaticMapEntry<String, double> ClosureEnv_anon_6_call(AnyGC env__, String grade, StaticList<StaticMap<String, dynamic>> items) {
  final env = env__ as ClosureEnv_anon_6;

    final int total = items.fold(0, ClosureEnv_ClosureEnv_anon_6_7_new(GC.allocateLocal(ClosureEnv_ClosureEnv_anon_6_7())));
    return StaticMapEntry(grade, (total / items.length));
  }

class ClosureEnv_anon_8 extends TypeFunction1<String, String> {
  ClosureEnv_anon_8();
  @override
  String call(String p) => fnPtr(this, p);
}
ClosureEnv_anon_8 ClosureEnv_anon_8_new(ClosureEnv_anon_8 env_) {
  env_.fnPtr = ClosureEnv_anon_8_call;
  return env_;
}
String ClosureEnv_anon_8_call(AnyGC env__, String p) {
  final env = env__ as ClosureEnv_anon_8;

  return (p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1)}');
}

class ClosureEnv_anon_9 extends TypeFunction1<bool, String> {
  ClosureEnv_anon_9();
  @override
  bool call(String w) => fnPtr(this, w);
}
ClosureEnv_anon_9 ClosureEnv_anon_9_new(ClosureEnv_anon_9 env_) {
  env_.fnPtr = ClosureEnv_anon_9_call;
  return env_;
}
bool ClosureEnv_anon_9_call(AnyGC env__, String w) {
  final env = env__ as ClosureEnv_anon_9;

  return w.isNotEmpty;
}

class ClosureEnv_anon_10 extends TypeFunction1<StaticList<double>, int> {
  late int cols;
  ClosureEnv_anon_10();
  @override
  StaticList<double> call(int _) => fnPtr(this, _);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (cols is AnyGC) (cols as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_10 ClosureEnv_anon_10_new(ClosureEnv_anon_10 env_, int cols) {
  env_.fnPtr = ClosureEnv_anon_10_call;
  env_.cols = cols;
  return env_;
}
StaticList<double> ClosureEnv_anon_10_call(AnyGC env__, int _) {
  final env = env__ as ClosureEnv_anon_10;

  return StaticList<double>.filled(env.cols, 0.0);
}

class ClosureEnv_ClosureEnv_anon_11_12 extends TypeFunction1<double, int> {
  late IntBox i;
  ClosureEnv_ClosureEnv_anon_11_12();
  @override
  double call(int j) => fnPtr(this, j);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (i is AnyGC) (i as AnyGC).gcMark(flag);
  }
}
ClosureEnv_ClosureEnv_anon_11_12 ClosureEnv_ClosureEnv_anon_11_12_new(ClosureEnv_ClosureEnv_anon_11_12 env_, IntBox i) {
  env_.fnPtr = ClosureEnv_ClosureEnv_anon_11_12_call;
  env_.i = i;
  return env_;
}
double ClosureEnv_ClosureEnv_anon_11_12_call(AnyGC env__, int j) {
  final env = env__ as ClosureEnv_ClosureEnv_anon_11_12;

  return ((env.i.value == j) ? 1.0 : 0.0);
}

class ClosureEnv_anon_11 extends TypeFunction1<StaticList<double>, int> {
  late int size;
  ClosureEnv_anon_11();
  @override
  StaticList<double> call(int i_raw) => fnPtr(this, i_raw);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (size is AnyGC) (size as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_11 ClosureEnv_anon_11_new(ClosureEnv_anon_11 env_, int size) {
  env_.fnPtr = ClosureEnv_anon_11_call;
  env_.size = size;
  return env_;
}
StaticList<double> ClosureEnv_anon_11_call(AnyGC env__, int i_raw) {
  final env = env__ as ClosureEnv_anon_11;

  IntBox i = IntBox(i_raw);
  return StaticList<double>.generate(env.size, ClosureEnv_ClosureEnv_anon_11_12_new(GC.allocateLocal(ClosureEnv_ClosureEnv_anon_11_12()), i));
}

class ClosureEnv_ClosureEnv_anon_13_14 extends TypeFunction1<String, double> {
  ClosureEnv_ClosureEnv_anon_13_14();
  @override
  String call(double v) => fnPtr(this, v);
}
ClosureEnv_ClosureEnv_anon_13_14 ClosureEnv_ClosureEnv_anon_13_14_new(ClosureEnv_ClosureEnv_anon_13_14 env_) {
  env_.fnPtr = ClosureEnv_ClosureEnv_anon_13_14_call;
  return env_;
}
String ClosureEnv_ClosureEnv_anon_13_14_call(AnyGC env__, double v) {
  final env = env__ as ClosureEnv_ClosureEnv_anon_13_14;

  return v.toStringAsFixed(1);
}

class ClosureEnv_anon_13 extends TypeFunction1<String, StaticList<double>> {
  ClosureEnv_anon_13();
  @override
  String call(StaticList<double> row) => fnPtr(this, row);
}
ClosureEnv_anon_13 ClosureEnv_anon_13_new(ClosureEnv_anon_13 env_) {
  env_.fnPtr = ClosureEnv_anon_13_call;
  return env_;
}
String ClosureEnv_anon_13_call(AnyGC env__, StaticList<double> row) {
  final env = env__ as ClosureEnv_anon_13;

  return row.map(ClosureEnv_ClosureEnv_anon_13_14_new(GC.allocateLocal(ClosureEnv_ClosureEnv_anon_13_14()))).join(', ');
}

class ClosureEnv_anon_15 extends TypeFunction1<String, String> {
  ClosureEnv_anon_15();
  @override
  String call(String r) => fnPtr(this, r);
}
ClosureEnv_anon_15 ClosureEnv_anon_15_new(ClosureEnv_anon_15 env_) {
  env_.fnPtr = ClosureEnv_anon_15_call;
  return env_;
}
String ClosureEnv_anon_15_call(AnyGC env__, String r) {
  final env = env__ as ClosureEnv_anon_15;

  return '[${r}]';
}

class ClosureEnv_makeCounter_16 extends TypeFunction0<int> {
  late IntBox current;
  late int step;
  ClosureEnv_makeCounter_16();
  @override
  int call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (current is AnyGC) (current as AnyGC).gcMark(flag);
    if (step is AnyGC) (step as AnyGC).gcMark(flag);
  }
}
ClosureEnv_makeCounter_16 ClosureEnv_makeCounter_16_new(ClosureEnv_makeCounter_16 env_, IntBox current, int step) {
  env_.fnPtr = ClosureEnv_makeCounter_16_call;
  env_.current = current;
  env_.step = step;
  return env_;
}
int ClosureEnv_makeCounter_16_call(AnyGC env__) {
  final env = env__ as ClosureEnv_makeCounter_16;

    env.current.value = (env.current.value + env.step);
    return env.current.value;
  }

class ClosureEnv_ClosureEnv_makeAccumulator_17_18 extends TypeFunction0<String> {
  late IntBox snapshot;
  late IntBox total;
  ClosureEnv_ClosureEnv_makeAccumulator_17_18();
  @override
  String call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (snapshot is AnyGC) (snapshot as AnyGC).gcMark(flag);
    if (total is AnyGC) (total as AnyGC).gcMark(flag);
  }
}
ClosureEnv_ClosureEnv_makeAccumulator_17_18 ClosureEnv_ClosureEnv_makeAccumulator_17_18_new(ClosureEnv_ClosureEnv_makeAccumulator_17_18 env_, IntBox snapshot, IntBox total) {
  env_.fnPtr = ClosureEnv_ClosureEnv_makeAccumulator_17_18_call;
  env_.snapshot = snapshot;
  env_.total = total;
  return env_;
}
String ClosureEnv_ClosureEnv_makeAccumulator_17_18_call(AnyGC env__) {
  final env = env__ as ClosureEnv_ClosureEnv_makeAccumulator_17_18;

  return 'accumulated: ${env.snapshot.value} (current total: ${env.total.value})';
}

class ClosureEnv_makeAccumulator_17 extends TypeFunction1<TypeFunction0<String>, int> {
  late IntBox total;
  ClosureEnv_makeAccumulator_17();
  @override
  TypeFunction0<String> call(int amount) => fnPtr(this, amount);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (total is AnyGC) (total as AnyGC).gcMark(flag);
  }
}
ClosureEnv_makeAccumulator_17 ClosureEnv_makeAccumulator_17_new(ClosureEnv_makeAccumulator_17 env_, IntBox total) {
  env_.fnPtr = ClosureEnv_makeAccumulator_17_call;
  env_.total = total;
  return env_;
}
TypeFunction0<String> ClosureEnv_makeAccumulator_17_call(AnyGC env__, int amount) {
  final env = env__ as ClosureEnv_makeAccumulator_17;

    env.total.value = (env.total.value + amount);
    IntBox snapshot = IntBox(env.total.value);
    return ClosureEnv_ClosureEnv_makeAccumulator_17_18_new(GC.allocateLocal(ClosureEnv_ClosureEnv_makeAccumulator_17_18()), snapshot, env.total);
  }

class ClosureEnv_makeClosureList_19 extends TypeFunction0<String> {
  late int i;
  ClosureEnv_makeClosureList_19();
  @override
  String call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (i is AnyGC) (i as AnyGC).gcMark(flag);
  }
}
ClosureEnv_makeClosureList_19 ClosureEnv_makeClosureList_19_new(ClosureEnv_makeClosureList_19 env_, int i) {
  env_.fnPtr = ClosureEnv_makeClosureList_19_call;
  env_.i = i;
  return env_;
}
String ClosureEnv_makeClosureList_19_call(AnyGC env__) {
  final env = env__ as ClosureEnv_makeClosureList_19;

  return 'closure_${env.i}';
}

class ClosureEnv_composeFunc_20<C, B, A> extends TypeFunction1<C, A> {
  late TypeFunction1<C, B> funcBC;
  late TypeFunction1<B, A> funcAB;
  ClosureEnv_composeFunc_20();
  @override
  C call(A a) => fnPtr(this, a);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (funcBC is AnyGC) (funcBC as AnyGC).gcMark(flag);
    if (funcAB is AnyGC) (funcAB as AnyGC).gcMark(flag);
  }
}
ClosureEnv_composeFunc_20<C, B, A> ClosureEnv_composeFunc_20_new<C, B, A>(ClosureEnv_composeFunc_20<C, B, A> env_, TypeFunction1<C, B> funcBC, TypeFunction1<B, A> funcAB) {
  env_.fnPtr = ClosureEnv_composeFunc_20_call<C, B, A>;
  env_.funcBC = funcBC;
  env_.funcAB = funcAB;
  return env_;
}
C ClosureEnv_composeFunc_20_call<C, B, A>(AnyGC env__, A a) {
  final env = env__ as ClosureEnv_composeFunc_20<C, B, A>;

  return env.funcBC.call(env.funcAB.call(a));
}

class ClosureEnv_ClosureEnv_curry_21_22<C, A, B> extends TypeFunction1<C, B> {
  late TypeFunction2<C, A, B> biFunc;
  late ObjectBox<A> a;
  ClosureEnv_ClosureEnv_curry_21_22();
  @override
  C call(B b) => fnPtr(this, b);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (biFunc is AnyGC) (biFunc as AnyGC).gcMark(flag);
    if (a is AnyGC) (a as AnyGC).gcMark(flag);
  }
}
ClosureEnv_ClosureEnv_curry_21_22<C, A, B> ClosureEnv_ClosureEnv_curry_21_22_new<C, A, B>(ClosureEnv_ClosureEnv_curry_21_22<C, A, B> env_, TypeFunction2<C, A, B> biFunc, ObjectBox<A> a) {
  env_.fnPtr = ClosureEnv_ClosureEnv_curry_21_22_call<C, A, B>;
  env_.biFunc = biFunc;
  env_.a = a;
  return env_;
}
C ClosureEnv_ClosureEnv_curry_21_22_call<C, A, B>(AnyGC env__, B b) {
  final env = env__ as ClosureEnv_ClosureEnv_curry_21_22<C, A, B>;

  return env.biFunc.call(env.a.value, b);
}

class ClosureEnv_curry_21<C, A, B> extends TypeFunction1<TypeFunction1<C, B>, A> {
  late TypeFunction2<C, A, B> biFunc;
  ClosureEnv_curry_21();
  @override
  TypeFunction1<C, B> call(A a_raw) => fnPtr(this, a_raw);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (biFunc is AnyGC) (biFunc as AnyGC).gcMark(flag);
  }
}
ClosureEnv_curry_21<C, A, B> ClosureEnv_curry_21_new<C, A, B>(ClosureEnv_curry_21<C, A, B> env_, TypeFunction2<C, A, B> biFunc) {
  env_.fnPtr = ClosureEnv_curry_21_call<C, A, B>;
  env_.biFunc = biFunc;
  return env_;
}
TypeFunction1<C, B> ClosureEnv_curry_21_call<C, A, B>(AnyGC env__, A a_raw) {
  final env = env__ as ClosureEnv_curry_21<C, A, B>;

  ObjectBox<A> a = ObjectBox<A>(a_raw);
  return ClosureEnv_ClosureEnv_curry_21_22_new<C, A, B>(GC.allocateLocal(ClosureEnv_ClosureEnv_curry_21_22<C, A, B>()), env.biFunc, a);
}

class ClosureEnv_memoize_23<A, B> extends TypeFunction1<B, A> {
  late StaticMap<A, B> cache;
  late TypeFunction1<B, A> func;
  ClosureEnv_memoize_23();
  @override
  B call(A arg) => fnPtr(this, arg);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (cache is AnyGC) (cache as AnyGC).gcMark(flag);
    if (func is AnyGC) (func as AnyGC).gcMark(flag);
  }
}
ClosureEnv_memoize_23<A, B> ClosureEnv_memoize_23_new<A, B>(ClosureEnv_memoize_23<A, B> env_, StaticMap<A, B> cache, TypeFunction1<B, A> func) {
  env_.fnPtr = ClosureEnv_memoize_23_call<A, B>;
  env_.cache = cache;
  env_.func = func;
  return env_;
}
B ClosureEnv_memoize_23_call<A, B>(AnyGC env__, A arg) {
  final env = env__ as ClosureEnv_memoize_23<A, B>;

    if (env.cache.containsKey(arg))     return (env.cache[arg] as B);
    final B result = env.func.call(arg);
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
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 1)));
{
    env._promise.complete((env.a.value + env.b.value));
    return;
  }
  env._promise.complete(0);
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
{
    env._promise.complete('value=${env.value.value}, doubled=${doubled}, tripled=${tripled}');
    return;
  }
  env._promise.complete('');
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
{
    env._promise.complete(results);
    return;
  }
  env._promise.complete(null as StaticList<int>);
  return;
}
class ClosureEnv_IterableStats_get_sum_27<T extends num> extends TypeFunction2<T, T, T> {
  ClosureEnv_IterableStats_get_sum_27();
  @override
  T call(T a, T b) => fnPtr(this, a, b);
}
ClosureEnv_IterableStats_get_sum_27<T> ClosureEnv_IterableStats_get_sum_27_new<T extends num>(ClosureEnv_IterableStats_get_sum_27<T> env_) {
  env_.fnPtr = ClosureEnv_IterableStats_get_sum_27_call<T>;
  return env_;
}
T ClosureEnv_IterableStats_get_sum_27_call<T extends num>(AnyGC env__, T a, T b) {
  final env = env__ as ClosureEnv_IterableStats_get_sum_27<T>;

  return ((a + b) as T);
}

class ClosureEnv_IterableStats_get_max_28<T extends num> extends TypeFunction2<T, T, T> {
  ClosureEnv_IterableStats_get_max_28();
  @override
  T call(T a, T b) => fnPtr(this, a, b);
}
ClosureEnv_IterableStats_get_max_28<T> ClosureEnv_IterableStats_get_max_28_new<T extends num>(ClosureEnv_IterableStats_get_max_28<T> env_) {
  env_.fnPtr = ClosureEnv_IterableStats_get_max_28_call<T>;
  return env_;
}
T ClosureEnv_IterableStats_get_max_28_call<T extends num>(AnyGC env__, T a, T b) {
  final env = env__ as ClosureEnv_IterableStats_get_max_28<T>;

  return ((a > b) ? a : b);
}

class ClosureEnv_IterableStats_get_min_29<T extends num> extends TypeFunction2<T, T, T> {
  ClosureEnv_IterableStats_get_min_29();
  @override
  T call(T a, T b) => fnPtr(this, a, b);
}
ClosureEnv_IterableStats_get_min_29<T> ClosureEnv_IterableStats_get_min_29_new<T extends num>(ClosureEnv_IterableStats_get_min_29<T> env_) {
  env_.fnPtr = ClosureEnv_IterableStats_get_min_29_call<T>;
  return env_;
}
T ClosureEnv_IterableStats_get_min_29_call<T extends num>(AnyGC env__, T a, T b) {
  final env = env__ as ClosureEnv_IterableStats_get_min_29<T>;

  return ((a < b) ? a : b);
}

class ClosureEnv_main_30 extends TypeFunction1<String, int> {
  ClosureEnv_main_30();
  @override
  String call(int v) => fnPtr(this, v);
}
ClosureEnv_main_30 ClosureEnv_main_30_new(ClosureEnv_main_30 env_) {
  env_.fnPtr = ClosureEnv_main_30_call;
  return env_;
}
String ClosureEnv_main_30_call(AnyGC env__, int v) {
  final env = env__ as ClosureEnv_main_30;

  return 'N${v}';
}


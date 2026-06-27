import 'package:dart2cpp/restorer/runtime_classes.dart';

typedef Predicate<T extends dynamic> = TypeFunction1<bool, T>;

typedef Transformer<A extends dynamic, B extends dynamic> = TypeFunction1<B, A>;

typedef Reducer<T extends dynamic> = TypeFunction2<T, T, T>;

String Printable_toPrettyString(dynamic this__) {
  final this_ = this__ as dynamic;
  return '[${(this_.vptr['get_label'] as Function)(this_)}]';
}

String Serializable_toJson<T extends dynamic>(dynamic this__) {
  final this_ = this__ as dynamic;
  return '{"data": "${(this_.vptr['serialize'] as Function)(this_)}"}';
}

StaticMap<String, dynamic> Cacheable__cache = StaticMap<String, dynamic>.of({});

void Cacheable_cacheValue<K extends dynamic>(dynamic this__, dynamic value) {
  final this_ = this__ as dynamic;
  Cacheable._cache['${(this_.vptr['get_cacheKey'] as Function)(this_)}'] = value;
}

dynamic Cacheable_getCachedValue<K extends dynamic>(dynamic this__) {
  final this_ = this__ as dynamic;
  return Cacheable._cache['${(this_.vptr['get_cacheKey'] as Function)(this_)}'];
}

bool Validatable_get_isValid(dynamic this__) {
  final this_ = this__ as dynamic;
  return (this_.vptr['validate'] as Function)(this_).isEmpty;
}

void Loggable_log(dynamic this__, String message) {
  final this_ = this__ as dynamic;
  this_._logs.add(message);
}

StaticList<String> Loggable_get_logs(dynamic this__) {
  final this_ = this__ as dynamic;
  return StaticList<String>.unmodifiable(this_._logs);
}

void Observable_observe<T extends dynamic>(dynamic this__, TypeFunction1<void, T> callback) {
  final this_ = this__ as dynamic;
  this_._observers.add(callback);
}

void Observable_notify<T extends dynamic>(dynamic this__, T value) {
  final this_ = this__ as dynamic;
  for (final cb in this_._observers) {
    cb(value);
  }
}

enum Priority {
  low,
  medium,
  high,
  critical;
}

enum Color {
  red,
  green,
  blue;
}

String Color_get_hex(dynamic this__) {
  final this_ = this__ as Color;
  do {
    switch (this_) {
      case Color.red:
        return '#FF0000';
      case Color.green:
        return '#00FF00';
      case Color.blue:
        return '#0000FF';
    }
  } while (false);
}

bool Color_get_isWarm(dynamic this__) {
  final this_ = this__ as Color;
  return (this_ == Color.red);
}

class Comparable2Value<T extends dynamic> extends VPtr {

  Comparable2Value() {
    vptr['compareTo'] = Comparable2_compareTo<T>;
    vptr['operatorLt'] = Comparable2_operatorLt<T>;
    vptr['operatorGt'] = Comparable2_operatorGt<T>;
    vptr['operatorLe'] = Comparable2_operatorLe<T>;
    vptr['operatorGe'] = Comparable2_operatorGe<T>;
  }
}

Comparable2Value<T> Comparable2_new<T extends dynamic>(dynamic this__) {
  final this_ = this__ as Comparable2Value<T>;
  return this_;
}

int Comparable2_compareTo<T extends dynamic>(dynamic this__) {
  throw UnimplementedError('Comparable2_compareTo is abstract');
}

bool Comparable2_operatorLt<T extends dynamic>(dynamic this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.vptr['compareTo'] as Function)(this_, other) < 0);
}

bool Comparable2_operatorGt<T extends dynamic>(dynamic this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.vptr['compareTo'] as Function)(this_, other) > 0);
}

bool Comparable2_operatorLe<T extends dynamic>(dynamic this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.vptr['compareTo'] as Function)(this_, other) <= 0);
}

bool Comparable2_operatorGe<T extends dynamic>(dynamic this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.vptr['compareTo'] as Function)(this_, other) >= 0);
}

class EntityValue<ID extends dynamic> extends Entity_Object_Printable_CacheableValue<ID> {
  late ID id;
  late String name;

  EntityValue() {
    vptr['get_label'] = Entity_get_label<ID>;
    vptr['toPrettyString'] = Entity_Object_Printable_toPrettyString<ID>;
    vptr['get_cacheKey'] = Entity_get_cacheKey<ID>;
    vptr['cacheValue'] = Entity_Object_Printable_Cacheable_cacheValue<ID>;
    vptr['getCachedValue'] = Entity_Object_Printable_Cacheable_getCachedValue<ID>;
    vptr['toString'] = Entity_toString<ID>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

EntityValue<ID> Entity_new<ID extends dynamic>(dynamic this__, ID id, String name) {
  final this_ = this__ as EntityValue<ID>;
  Entity_Object_Printable_Cacheable_new(this_);
  this_.id = id;
  this_.name = name;
  return this_;
}

String Entity_get_label<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as EntityValue<ID>;
  return '${this_.name}(${this_.id})';
}

ID Entity_get_cacheKey<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as EntityValue<ID>;
  return this_.id;
}

String Entity_toString<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as EntityValue<ID>;
  return 'Entity(${this_.id}, ${this_.name})';
}

String Entity_toPrettyString<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_toPrettyString(this__);

void Entity_cacheValue<ID extends dynamic>(dynamic this__, dynamic value) { Entity_Object_Printable_Cacheable_cacheValue(this__, value); }

dynamic Entity_getCachedValue<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_Cacheable_getCachedValue(this__);

class TimestampedEntityValue<ID extends dynamic> extends EntityValue<ID> {
  late int createdAt;
  late int updatedAt;

  TimestampedEntityValue() {
    vptr['get_label'] = TimestampedEntity_get_label<ID>;
    vptr['get_age'] = TimestampedEntity_get_age;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

TimestampedEntityValue<ID> TimestampedEntity_new<ID extends dynamic>(dynamic this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  Entity_new(this_, id, name);
  this_.createdAt = createdAt;
  this_.updatedAt = updatedAt;
  return this_;
}

StaticDuration TimestampedEntity_get_age<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return StaticDuration(milliseconds: (this_.updatedAt - this_.createdAt));
}

String TimestampedEntity_get_label<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return '${this_.name}(${this_.id}, age=${(this_.vptr['get_age'] as Function)(this_).inMilliseconds}ms)';
}

String TimestampedEntity_toPrettyString<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_toPrettyString(this__);

ID TimestampedEntity_get_cacheKey<ID extends dynamic>(dynamic this__) => Entity_get_cacheKey(this__);

void TimestampedEntity_cacheValue<ID extends dynamic>(dynamic this__, dynamic value) { Entity_Object_Printable_Cacheable_cacheValue(this__, value); }

dynamic TimestampedEntity_getCachedValue<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_Cacheable_getCachedValue(this__);

String TimestampedEntity_toString<ID extends dynamic>(dynamic this__) => Entity_toString(this__);

class VersionedEntityValue<ID extends dynamic> extends VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> {
  late int _version;
  late StaticList<String> _changelog;

  VersionedEntityValue() {
    vptr['get_label'] = VersionedEntity_get_label<ID>;
    vptr['serialize'] = VersionedEntity_serialize<ID>;
    vptr['toJson'] = VersionedEntity_TimestampedEntity_Serializable_toJson<ID>;
    vptr['validate'] = VersionedEntity_validate<ID>;
    vptr['get_isValid'] = VersionedEntity_TimestampedEntity_Serializable_Validatable_get_isValid<ID>;
    vptr['get_version'] = VersionedEntity_get_version;
    vptr['bump'] = VersionedEntity_bump;
    vptr['get_changelog'] = VersionedEntity_get_changelog;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _changelog?.gcMark(flag);
  }
}

VersionedEntityValue<ID> VersionedEntity_new<ID extends dynamic>(dynamic this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as VersionedEntityValue<ID>;
  VersionedEntity_TimestampedEntity_Serializable_Validatable_new(this_, id, name, createdAt, updatedAt);
  this_._version = 1;
  this_._changelog = StaticList<String>.of([]);
  return this_;
}

int VersionedEntity_get_version<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return this_._version;
}

void VersionedEntity_bump<ID extends dynamic>(dynamic this__, String change) {
  final this_ = this__ as VersionedEntityValue<ID>;
  this_._version = (this_._version + 1);
  this_._changelog.add('v${this_._version}: ${change}');
}

StaticList<String> VersionedEntity_get_changelog<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return StaticList<String>.unmodifiable(this_._changelog);
}

String VersionedEntity_serialize<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return '${this_.id}:${this_.name}:v${this_._version}';
}

StaticList<String> VersionedEntity_validate<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  StaticList<String> errors = StaticList<String>.of([]);
  if (this_.name.isEmpty) {
    errors.add('name is empty');
  }
  if ((this_._version < 1)) {
    errors.add('invalid version');
  }
  return errors;
}

String VersionedEntity_get_label<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return '${this_.name}(v${this_._version})';
}

String VersionedEntity_toPrettyString<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_toPrettyString(this__);

ID VersionedEntity_get_cacheKey<ID extends dynamic>(dynamic this__) => Entity_get_cacheKey(this__);

void VersionedEntity_cacheValue<ID extends dynamic>(dynamic this__, dynamic value) { Entity_Object_Printable_Cacheable_cacheValue(this__, value); }

dynamic VersionedEntity_getCachedValue<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_Cacheable_getCachedValue(this__);

String VersionedEntity_toString<ID extends dynamic>(dynamic this__) => Entity_toString(this__);

StaticDuration VersionedEntity_get_age<ID extends dynamic>(dynamic this__) => TimestampedEntity_get_age(this__);

String VersionedEntity_toJson<ID extends dynamic>(dynamic this__) => VersionedEntity_TimestampedEntity_Serializable_toJson(this__);

bool VersionedEntity_get_isValid<ID extends dynamic>(dynamic this__) => VersionedEntity_TimestampedEntity_Serializable_Validatable_get_isValid(this__);

class MoneyValue extends Money_Comparable2_PrintableValue {
  late int cents;
  late String currency;

  MoneyValue() {
    vptr['compareTo'] = Money_compareTo;
    vptr['get_label'] = Money_get_label;
    vptr['toPrettyString'] = Money_Comparable2_Printable_toPrettyString;
    vptr['operatorPlus'] = Money_operatorPlus;
    vptr['operatorMinus'] = Money_operatorMinus;
    vptr['operatorStar'] = Money_operatorStar;
    vptr['operatorUnaryMinus'] = Money_operatorUnaryMinus;
    vptr['toString'] = Money_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

MoneyValue Money_new(dynamic this__, int cents, [String currency = 'USD']) {
  final this_ = this__ as MoneyValue;
  Money_Comparable2_Printable_new(this_);
  this_.cents = cents;
  this_.currency = currency;
  return this_;
}

MoneyValue Money_new_fromDollars(dynamic this__, double dollars, [String currency = 'USD']) {
  final this_ = this__ as MoneyValue;
  Money_Comparable2_Printable_new(this_);
  this_.cents = (dollars * 100).round();
  this_.currency = currency;
  return this_;
}

MoneyValue Money_operatorPlus(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  if (!(this_.currency == other.currency)) {
    throw DartArgumentError('Currency mismatch');
  }
  return Money_new(MoneyValue(), (this_.cents + other.cents), this_.currency);
}

MoneyValue Money_operatorMinus(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  if (!(this_.currency == other.currency)) {
    throw DartArgumentError('Currency mismatch');
  }
  return Money_new(MoneyValue(), (this_.cents - other.cents), this_.currency);
}

MoneyValue Money_operatorStar(dynamic this__, int factor) {
  final this_ = this__ as MoneyValue;
  return Money_new(MoneyValue(), (this_.cents * factor), this_.currency);
}

MoneyValue Money_operatorUnaryMinus(dynamic this__) {
  final this_ = this__ as MoneyValue;
  return Money_new(MoneyValue(), -this_.cents, this_.currency);
}

int Money_compareTo(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return (this_.cents - other.cents);
}

String Money_get_label(dynamic this__) {
  final this_ = this__ as MoneyValue;
  return '\$${dart_str_toStringAsFixed((this_.cents / 100), 2)} ${this_.currency}';
}

String Money_toString(dynamic this__) {
  final this_ = this__ as MoneyValue;
  return (this_.vptr['get_label'] as Function)(this_);
}

bool Money_operatorLt(dynamic this__, MoneyValue other) => Comparable2_operatorLt<Money>(this__, other);

bool Money_operatorGt(dynamic this__, MoneyValue other) => Comparable2_operatorGt<Money>(this__, other);

bool Money_operatorLe(dynamic this__, MoneyValue other) => Comparable2_operatorLe<Money>(this__, other);

bool Money_operatorGe(dynamic this__, MoneyValue other) => Comparable2_operatorGe<Money>(this__, other);

String Money_toPrettyString(dynamic this__) => Money_Comparable2_Printable_toPrettyString(this__);

class ConfigValue extends VPtr {
  late StaticMap<String, dynamic> _data;

  ConfigValue() {
    vptr['operatorIndex'] = Config_operatorIndex;
    vptr['operatorIndexSet'] = Config_operatorIndexSet;
    vptr['containsKey'] = Config_containsKey;
    vptr['get_length'] = Config_get_length;
    vptr['toString'] = Config_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _data?.gcMark(flag);
  }
}

ConfigValue Config_new(dynamic this__, StaticMap<String, dynamic> _data) {
  final this_ = this__ as ConfigValue;
  this_._data = _data;
  return this_;
}

ConfigValue Config_new_empty(dynamic this__) {
  final this_ = this__ as ConfigValue;
  this_._data = StaticMap<String, dynamic>.of({});
  return this_;
}

ConfigValue Config_new_fromPairs(dynamic this__, StaticList<StaticList<dynamic>> pairs) {
  final this_ = this__ as ConfigValue;
  this_._data = (() { StaticMap<String, dynamic> _unnamed = StaticMap<String, dynamic>.of({});
for (final p in pairs) {
  _unnamed[(p[0] as String)] = p[1];
}
return _unnamed; })();
  return this_;
}

ConfigValue Config_new_withDefaults(StaticMap<String, dynamic> overrides) {
  StaticMap<String, dynamic> defaults = StaticMap<String, dynamic>.of({'debug': false, 'maxRetries': 3, 'timeout': 30, 'name': 'default'});
  defaults.addAll(overrides);
  return Config_new(ConfigValue(), defaults);
}

dynamic Config_operatorIndex(dynamic this__, String key) {
  final this_ = this__ as ConfigValue;
  return this_._data[key];
}

void Config_operatorIndexSet(dynamic this__, String key, dynamic value) {
  final this_ = this__ as ConfigValue;
  (() { final _unnamed = this_._data; return (() { final _unnamed = key; return (() { final _unnamed = value; return (() { final _unnamed = _unnamed[_unnamed] = _unnamed; return _unnamed; })(); })(); })(); })();
  return;
}

bool Config_containsKey(dynamic this__, String key) {
  final this_ = this__ as ConfigValue;
  return this_._data.containsKey(key);
}

int Config_get_length(dynamic this__) {
  final this_ = this__ as ConfigValue;
  return this_._data.length;
}

String Config_toString(dynamic this__) {
  final this_ = this__ as ConfigValue;
  StaticList<String> sorted = (() { final _unnamed = StaticList<String>.of(this_._data.keys.toList()); return (() { _unnamed.sort();
return _unnamed; })(); })();
  StaticList<String> entries = StaticList<String>.of(sorted.map(ClosureEnv_global_0_new(GC.allocateLocal(ClosureEnv_global_0()), this_)));
  return 'Config{${entries.join(', ')}}';
}

class EventBusValue extends VPtr {
  late StaticList<TypeFunction1<void, String>> _listeners;

  EventBusValue() {
    vptr['on'] = EventBus_on;
    vptr['emit'] = EventBus_emit;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _listeners?.gcMark(flag);
  }
}

EventBusValue EventBus_new(dynamic this__) {
  final this_ = this__ as EventBusValue;
  return this_;
}

void EventBus_on(dynamic this__, TypeFunction1<void, String> listener) {
  final this_ = this__ as EventBusValue;
  this_._listeners.add(listener);
}

void EventBus_emit(dynamic this__, String event) {
  final this_ = this__ as EventBusValue;
  for (final listener in this_._listeners) {
    listener(event);
  }
}

class DrawableValue extends VPtr {

  DrawableValue() {
    vptr['draw'] = Drawable_draw;
  }
}

DrawableValue Drawable_new(dynamic this__) {
  final this_ = this__ as DrawableValue;
  return this_;
}

void Drawable_draw(dynamic this__) {
  throw UnimplementedError('Drawable_draw is abstract');
}

class ResizableValue extends VPtr {

  ResizableValue() {
    vptr['resize'] = Resizable_resize;
  }
}

ResizableValue Resizable_new(dynamic this__) {
  final this_ = this__ as ResizableValue;
  return this_;
}

void Resizable_resize(dynamic this__) {
  throw UnimplementedError('Resizable_resize is abstract');
}

class ClickableValue extends VPtr {

  ClickableValue() {
    vptr['onClick'] = Clickable_onClick;
  }
}

ClickableValue Clickable_new(dynamic this__) {
  final this_ = this__ as ClickableValue;
  return this_;
}

void Clickable_onClick(dynamic this__) {
  throw UnimplementedError('Clickable_onClick is abstract');
}

class WidgetValue extends VPtr implements DrawableValue, ResizableValue, ClickableValue {
  late String _state;
  late double _scale;
  late int _clickCount;

  WidgetValue() {
    vptr['draw'] = Widget_draw;
    vptr['resize'] = Widget_resize;
    vptr['onClick'] = Widget_onClick;
    vptr['get_info'] = Widget_get_info;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

WidgetValue Widget_new(dynamic this__) {
  final this_ = this__ as WidgetValue;
  return this_;
}

void Widget_draw(dynamic this__) {
  final this_ = this__ as WidgetValue;
  this_._state = 'drawn';
}

void Widget_resize(dynamic this__, double factor) {
  final this_ = this__ as WidgetValue;
  this_._scale = (this_._scale * factor);
}

void Widget_onClick(dynamic this__) {
  final this_ = this__ as WidgetValue;
  this_._clickCount = (this_._clickCount + 1);
  this_._state = 'clicked(${this_._clickCount})';
}

String Widget_get_info(dynamic this__) {
  final this_ = this__ as WidgetValue;
  return 'Widget(state=${this_._state}, scale=${dart_str_toStringAsFixed(this_._scale, 1)}, clicks=${this_._clickCount})';
}

class PairValue<A extends dynamic, B extends dynamic> extends VPtr {
  late A first;
  late B second;

  PairValue() {
    vptr['swap'] = Pair_swap<A, B>;
    vptr['mapFirst'] = Pair_mapFirst<A, B, dynamic>;
    vptr['mapSecond'] = Pair_mapSecond<A, B, dynamic>;
    vptr['fold'] = Pair_fold<A, B, dynamic>;
    vptr['toString'] = Pair_toString<A, B>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

PairValue<A, B> Pair_new<A extends dynamic, B extends dynamic>(dynamic this__, A first, B second) {
  final this_ = this__ as PairValue<A, B>;
  this_.first = first;
  this_.second = second;
  return this_;
}

PairValue<B, A> Pair_swap<A extends dynamic, B extends dynamic>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<B, A>(PairValue<B, A>(), this_.second, this_.first);
}

PairValue<C, B> Pair_mapFirst<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__, TypeFunction1<C, A> transform) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<C, B>(PairValue<C, B>(), transform(this_.first), this_.second);
}

PairValue<A, C> Pair_mapSecond<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__, TypeFunction1<C, B> transform) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<A, C>(PairValue<A, C>(), this_.first, transform(this_.second));
}

R Pair_fold<A extends dynamic, B extends dynamic, R extends dynamic>(dynamic this__, TypeFunction2<R, A, B> combine) {
  final this_ = this__ as PairValue<A, B>;
  return combine(this_.first, this_.second);
}

String Pair_toString<A extends dynamic, B extends dynamic>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return 'Pair(${this_.first}, ${this_.second})';
}

class TripleValue<A extends dynamic, B extends dynamic, C extends dynamic> extends PairValue<A, B> {
  late C third;

  TripleValue() {
    vptr['toString'] = Triple_toString<A, B, C>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

TripleValue<A, B, C> Triple_new<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__, A first, B second, C third) {
  final this_ = this__ as TripleValue<A, B, C>;
  Pair_new(this_, first, second);
  this_.third = third;
  return this_;
}

String Triple_toString<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__) {
  final this_ = this__ as TripleValue<A, B, C>;
  return 'Triple(${this_.first}, ${this_.second}, ${this_.third})';
}

PairValue<B, A> Triple_swap<A extends dynamic, B extends dynamic, C extends dynamic>(dynamic this__) => Pair_swap(this__);

PairValue<C, B> Triple_mapFirst<A extends dynamic, B extends dynamic, C extends dynamic, C extends dynamic>(dynamic this__, TypeFunction1<C, A> transform) => Pair_mapFirst(this__, transform);

PairValue<A, C> Triple_mapSecond<A extends dynamic, B extends dynamic, C extends dynamic, C extends dynamic>(dynamic this__, TypeFunction1<C, B> transform) => Pair_mapSecond(this__, transform);

R Triple_fold<A extends dynamic, B extends dynamic, C extends dynamic, R extends dynamic>(dynamic this__, TypeFunction2<R, A, B> combine) => Pair_fold(this__, combine);

class StringBuilderValue extends VPtr {
  late StaticStringBuffer _buf;
  late String _separator;

  StringBuilderValue() {
    vptr['withSeparator'] = StringBuilder_withSeparator;
    vptr['add'] = StringBuilder_add;
    vptr['addAll'] = StringBuilder_addAll;
    vptr['get_length'] = StringBuilder_get_length;
    vptr['toString'] = StringBuilder_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _buf?.gcMark(flag);
  }
}

StringBuilderValue StringBuilder_new(dynamic this__) {
  final this_ = this__ as StringBuilderValue;
  return this_;
}

StringBuilderValue StringBuilder_withSeparator(dynamic this__, String sep) {
  final this_ = this__ as StringBuilderValue;
  this_._separator = sep;
  return this_;
}

StringBuilderValue StringBuilder_add(dynamic this__, String text) {
  final this_ = this__ as StringBuilderValue;
  if (this_._buf.isNotEmpty && this_._separator.isNotEmpty) {
    this_._buf.write(this_._separator);
  }
  this_._buf.write(text);
  return this_;
}

StringBuilderValue StringBuilder_addAll(dynamic this__, StaticList<String> texts) {
  final this_ = this__ as StringBuilderValue;
  for (final t in texts) {
    (this_.vptr['add'] as Function)(this_, t);
  }
  return this_;
}

int StringBuilder_get_length(dynamic this__) {
  final this_ = this__ as StringBuilderValue;
  return this_._buf.length;
}

String StringBuilder_toString(dynamic this__) {
  final this_ = this__ as StringBuilderValue;
  return this_._buf.toString();
}

class AppErrorValue extends VPtr {
  late String message;
  late String code;
  late AppErrorValue? cause;

  AppErrorValue() {
    vptr['toString'] = AppError_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

AppErrorValue AppError_new(dynamic this__, String message, String code, [AppErrorValue? cause = null]) {
  final this_ = this__ as AppErrorValue;
  this_.message = message;
  this_.code = code;
  this_.cause = cause;
  return this_;
}

String AppError_toString(dynamic this__) {
  final this_ = this__ as AppErrorValue;
  StaticList<String> chain = StaticList<String>.of([]);
  AppErrorValue? current = this_;
  while (!(current == null)) {
    chain.add('${current.code}:${current.message}');
    current = current.cause;
  }
  return chain.join(' -> ');
}

class DataPipelineValue<T extends dynamic> extends VPtr {
  late StaticList<T> _data;

  DataPipelineValue() {
    vptr['where'] = DataPipeline_where<T>;
    vptr['map'] = DataPipeline_map<T, dynamic>;
    vptr['sorted'] = DataPipeline_sorted<T>;
    vptr['take'] = DataPipeline_take<T>;
    vptr['fold'] = DataPipeline_fold<T, dynamic>;
    vptr['toList'] = DataPipeline_toList<T>;
    vptr['toString'] = DataPipeline_toString<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _data?.gcMark(flag);
  }
}

DataPipelineValue<T> DataPipeline_new<T extends dynamic>(dynamic this__, StaticList<T> _data) {
  final this_ = this__ as DataPipelineValue<T>;
  this_._data = _data;
  return this_;
}

DataPipelineValue<T> DataPipeline_where<T extends dynamic>(dynamic this__, TypeFunction1<bool, T> test) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<T>(DataPipelineValue<T>(), StaticList<T>.of(StaticList<T>.of(this_._data.where(test)).toList()));
}

DataPipelineValue<R> DataPipeline_map<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<R>(DataPipelineValue<R>(), StaticList<R>.of(StaticList<R>.of(this_._data.map(transform)).toList()));
}

DataPipelineValue<T> DataPipeline_sorted<T extends dynamic>(dynamic this__, TypeFunction2<int, T, T> compare) {
  final this_ = this__ as DataPipelineValue<T>;
  StaticList<T> copy = StaticList<T>.from(this_._data);
  copy.sort(compare);
  return DataPipeline_new<T>(DataPipelineValue<T>(), copy);
}

DataPipelineValue<T> DataPipeline_take<T extends dynamic>(dynamic this__, int count) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<T>(DataPipelineValue<T>(), StaticList<T>.of(StaticList<T>.of(this_._data.take(count)).toList()));
}

R DataPipeline_fold<T extends dynamic, R extends dynamic>(dynamic this__, R initial, TypeFunction2<R, R, T> combine) {
  final this_ = this__ as DataPipelineValue<T>;
  return this_._data.fold(initial, combine);
}

StaticList<T> DataPipeline_toList<T extends dynamic>(dynamic this__) {
  final this_ = this__ as DataPipelineValue<T>;
  return StaticList<T>.unmodifiable(this_._data);
}

String DataPipeline_toString<T extends dynamic>(dynamic this__) {
  final this_ = this__ as DataPipelineValue<T>;
  return 'Pipeline(${this_._data})';
}

class BoundedValueValue extends VPtr {
  late double _value;
  late double _min;
  late double _max;

  BoundedValueValue() {
    vptr['get_value'] = BoundedValue_get_value;
    vptr['set_value'] = BoundedValue_set_value;
    vptr['operatorPlus'] = BoundedValue_operatorPlus;
    vptr['toString'] = BoundedValue_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

BoundedValueValue BoundedValue_new(dynamic this__, double _value, double _min, double _max) {
  final this_ = this__ as BoundedValueValue;
  this_._value = _value;
  this_._min = _min;
  this_._max = _max;
  BoundedValue__clamp(this_);
  return this_;
}

double BoundedValue_get_value(dynamic this__) {
  final this_ = this__ as BoundedValueValue;
  return this_._value;
}

void BoundedValue_set_value(dynamic this__, double v) {
  final this_ = this__ as BoundedValueValue;
  this_._value = v;
  BoundedValue__clamp(this_);
}

void BoundedValue__clamp(dynamic this__) {
  final this_ = this__ as BoundedValueValue;
  if ((this_._value < this_._min)) {
    this_._value = this_._min;
  }
  if ((this_._value > this_._max)) {
    this_._value = this_._max;
  }
}

BoundedValueValue BoundedValue_operatorPlus(dynamic this__, double delta) {
  final this_ = this__ as BoundedValueValue;
  return BoundedValue_new(BoundedValueValue(), (this_._value + delta), this_._min, this_._max);
}

String BoundedValue_toString(dynamic this__) {
  final this_ = this__ as BoundedValueValue;
  return 'BoundedValue(${this_._value}, min=${this_._min}, max=${this_._max})';
}

class MathUtilsValue extends VPtr {

  MathUtilsValue() {
  }
}

double MathUtils_pi = 3.14159265358979;

int MathUtils__callCount = 0;

MathUtilsValue MathUtils_new(dynamic this__) {
  final this_ = this__ as MathUtilsValue;
  return this_;
}

int MathUtils_get_callCount() {
  return MathUtils__callCount;
}

int MathUtils_factorial(int n) {
  MathUtils__callCount = (MathUtils__callCount + 1);
  if ((n <= 1)) {
    return 1;
  }
  return (n * MathUtils_factorial((n - 1)));
}

StaticList<int> MathUtils_fibonacci(int count) {
  MathUtils__callCount = (MathUtils__callCount + 1);
  if ((count <= 0)) {
    return StaticList<int>.of([]);
  }
  if ((count == 1)) {
    return StaticList<int>.of([0]);
  }
  StaticList<int> fibs = StaticList<int>.of([0, 1]);
  for (int i = 2; (i < count); i = (i + 1)) {
    fibs.add((fibs[(i - 1)] + fibs[(i - 2)]));
  }
  return fibs;
}

double MathUtils_lerp(double a, double b, double t) {
  MathUtils__callCount = (MathUtils__callCount + 1);
  return (a + ((b - a) * t));
}

class ReactiveStoreValue<V extends dynamic> extends ReactiveStore_Object_Loggable_ObservableValue<V> {
  late StaticMap<String, V> _store;

  ReactiveStoreValue() {
    vptr['log'] = ReactiveStore_Object_Loggable_log<V>;
    vptr['get_logs'] = ReactiveStore_Object_Loggable_get_logs<V>;
    vptr['observe'] = ReactiveStore_Object_Loggable_Observable_observe<V>;
    vptr['notify'] = ReactiveStore_Object_Loggable_Observable_notify<V>;
    vptr['get'] = ReactiveStore_get<V>;
    vptr['set'] = ReactiveStore_set<V>;
    vptr['get_size'] = ReactiveStore_get_size;
    vptr['toString'] = ReactiveStore_toString<V>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _store?.gcMark(flag);
  }
}

ReactiveStoreValue<V> ReactiveStore_new<V extends dynamic>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  ReactiveStore_Object_Loggable_Observable_new(this_);
  return this_;
}

V? ReactiveStore_get<V extends dynamic>(dynamic this__, String key) {
  final this_ = this__ as ReactiveStoreValue<V>;
  (this_.vptr['log'] as Function)(this_, 'get: ${key}');
  return this_._store[key];
}

void ReactiveStore_set<V extends dynamic>(dynamic this__, String key, V value) {
  final this_ = this__ as ReactiveStoreValue<V>;
  (this_.vptr['log'] as Function)(this_, 'set: ${key}=${value}');
  this_._store[key] = value;
  (this_.vptr['notify'] as Function)(this_, value);
}

int ReactiveStore_get_size<V extends dynamic>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return this_._store.length;
}

String ReactiveStore_toString<V extends dynamic>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return 'Store(${this_._store})';
}

void ReactiveStore_log<V extends dynamic>(dynamic this__, String message) { ReactiveStore_Object_Loggable_log(this__, message); }

StaticList<String> ReactiveStore_get_logs<V extends dynamic>(dynamic this__) => ReactiveStore_Object_Loggable_get_logs(this__);

void ReactiveStore_observe<V extends dynamic>(dynamic this__, TypeFunction1<void, V> callback) { ReactiveStore_Object_Loggable_Observable_observe(this__, callback); }

void ReactiveStore_notify<V extends dynamic>(dynamic this__, V value) { ReactiveStore_Object_Loggable_Observable_notify(this__, value); }

class ShapeValue extends VPtr {

  ShapeValue() {
    vptr['area'] = Shape_area;
    vptr['get_shapeName'] = Shape_get_shapeName;
  }
}

ShapeValue Shape_new(dynamic this__) {
  final this_ = this__ as ShapeValue;
  return this_;
}

double Shape_area(dynamic this__) {
  throw UnimplementedError('Shape_area is abstract');
}

String Shape_get_shapeName(dynamic this__) {
  throw UnimplementedError('Shape_get_shapeName is abstract');
}

class CircleValue extends VPtr implements ShapeValue {
  late double radius;

  CircleValue() {
    vptr['area'] = Circle_area;
    vptr['get_shapeName'] = Circle_get_shapeName;
    vptr['toString'] = Circle_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

CircleValue Circle_new(dynamic this__, double radius) {
  final this_ = this__ as CircleValue;
  this_.radius = radius;
  return this_;
}

double Circle_area(dynamic this__) {
  final this_ = this__ as CircleValue;
  return ((3.14159 * this_.radius) * this_.radius);
}

String Circle_get_shapeName(dynamic this__) {
  final this_ = this__ as CircleValue;
  return 'Circle';
}

String Circle_toString(dynamic this__) {
  final this_ = this__ as CircleValue;
  return 'Circle(r=${this_.radius})';
}

class RectangleValue extends VPtr implements ShapeValue {
  late double width;
  late double height;

  RectangleValue() {
    vptr['area'] = Rectangle_area;
    vptr['get_shapeName'] = Rectangle_get_shapeName;
    vptr['toString'] = Rectangle_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

RectangleValue Rectangle_new(dynamic this__, double width, double height) {
  final this_ = this__ as RectangleValue;
  this_.width = width;
  this_.height = height;
  return this_;
}

double Rectangle_area(dynamic this__) {
  final this_ = this__ as RectangleValue;
  return (this_.width * this_.height);
}

String Rectangle_get_shapeName(dynamic this__) {
  final this_ = this__ as RectangleValue;
  return 'Rectangle';
}

String Rectangle_toString(dynamic this__) {
  final this_ = this__ as RectangleValue;
  return 'Rectangle(${this_.width}x${this_.height})';
}

class NodeValue<T extends dynamic> extends VPtr {
  late T value;
  late StaticList<NodeValue<T>> children;

  NodeValue() {
    vptr['addChild'] = Node_addChild<T>;
    vptr['flatten'] = Node_flatten<T>;
    vptr['mapTree'] = Node_mapTree<T, dynamic>;
    vptr['toString'] = Node_toString<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    children?.gcMark(flag);
  }
}

NodeValue<T> Node_new<T extends dynamic>(dynamic this__, T value, [StaticList<NodeValue<T>>? children = null]) {
  final this_ = this__ as NodeValue<T>;
  this_.value = value;
  this_.children = (() { final _unnamed = children; return ((_unnamed == null) ? StaticList<NodeValue<T>>.of([]) : _unnamed); })();
  return this_;
}

void Node_addChild<T extends dynamic>(dynamic this__, NodeValue<T> child) {
  final this_ = this__ as NodeValue<T>;
  this_.children.add(child);
}

StaticList<T> Node_flatten<T extends dynamic>(dynamic this__) {
  final this_ = this__ as NodeValue<T>;
  StaticList<T> result = StaticList<T>.of([this_.value]);
  for (final child in this_.children) {
    result.addAll((child.vptr['flatten'] as Function)(child));
  }
  return result;
}

NodeValue<R> Node_mapTree<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as NodeValue<T>;
  return Node_new<R>(NodeValue<R>(), transform(this_.value), StaticList<NodeValue<R>>.of(StaticList<NodeValue<R>>.of(this_.children.map(ClosureEnv_global_1_new<R, T>(GC.allocateLocal(ClosureEnv_global_1<R, T>()), transform))).toList()));
}

String Node_toString<T extends dynamic>(dynamic this__) {
  final this_ = this__ as NodeValue<T>;
  if (this_.children.isEmpty) {
    return '${this_.value}';
  }
  return '${this_.value}(${this_.children.join(', ')})';
}

class LabeledNodeValue<T extends dynamic> extends LabeledNode_Node_PrintableValue<T> {
  late String nodeLabel;

  LabeledNodeValue() {
    vptr['toString'] = LabeledNode_toString<T>;
    vptr['get_label'] = LabeledNode_get_label<T>;
    vptr['toPrettyString'] = LabeledNode_Node_Printable_toPrettyString<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

LabeledNodeValue<T> LabeledNode_new<T extends dynamic>(dynamic this__, String nodeLabel, T value, [StaticList<NodeValue<T>>? children = null]) {
  final this_ = this__ as LabeledNodeValue<T>;
  LabeledNode_Node_Printable_new(this_, value, children);
  this_.nodeLabel = nodeLabel;
  return this_;
}

String LabeledNode_get_label<T extends dynamic>(dynamic this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return '${this_.nodeLabel}:${this_.value}';
}

String LabeledNode_toString<T extends dynamic>(dynamic this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return '[${this_.nodeLabel}]${this_.value}';
}

void LabeledNode_addChild<T extends dynamic>(dynamic this__, NodeValue<T> child) { Node_addChild(this__, child); }

StaticList<T> LabeledNode_flatten<T extends dynamic>(dynamic this__) => Node_flatten(this__);

NodeValue<R> LabeledNode_mapTree<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) => Node_mapTree(this__, transform);

String LabeledNode_toPrettyString<T extends dynamic>(dynamic this__) => LabeledNode_Node_Printable_toPrettyString(this__);

class Entity_Object_PrintableValue extends VPtr {

  Entity_Object_PrintableValue() {
    vptr['get_label'] = Entity_Object_Printable_get_label;
    vptr['toPrettyString'] = Entity_Object_Printable_toPrettyString;
  }
}

Entity_Object_PrintableValue Entity_Object_Printable_new(dynamic this__) {
  final this_ = this__ as Entity_Object_PrintableValue;
  return this_;
}

String Entity_Object_Printable_get_label(dynamic this__) {
  throw UnimplementedError('Entity_Object_Printable_get_label is abstract');
}

String Entity_Object_Printable_toPrettyString(dynamic this__) {
  final this_ = this__ as Entity_Object_PrintableValue;
  return Printable_toPrettyString(this_);
}

class Entity_Object_Printable_CacheableValue<ID extends dynamic> extends Entity_Object_PrintableValue {

  Entity_Object_Printable_CacheableValue() {
    vptr['get_cacheKey'] = Entity_Object_Printable_Cacheable_get_cacheKey<ID>;
    vptr['cacheValue'] = Entity_Object_Printable_Cacheable_cacheValue<ID>;
    vptr['getCachedValue'] = Entity_Object_Printable_Cacheable_getCachedValue<ID>;
  }
}

Entity_Object_Printable_CacheableValue<ID> Entity_Object_Printable_Cacheable_new<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as Entity_Object_Printable_CacheableValue<ID>;
  Entity_Object_Printable_new(this_);
  return this_;
}

ID Entity_Object_Printable_Cacheable_get_cacheKey<ID extends dynamic>(dynamic this__) {
  throw UnimplementedError('Entity_Object_Printable_Cacheable_get_cacheKey is abstract');
}

void Entity_Object_Printable_Cacheable_cacheValue<ID extends dynamic>(dynamic this__, dynamic value) {
  final this_ = this__ as Entity_Object_Printable_CacheableValue<ID>;
  Cacheable_cacheValue(this_, value);
  return;
}

dynamic Entity_Object_Printable_Cacheable_getCachedValue<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as Entity_Object_Printable_CacheableValue<ID>;
  return Cacheable_getCachedValue(this_);
}

String Entity_Object_Printable_Cacheable_get_label<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_get_label(this__);

String Entity_Object_Printable_Cacheable_toPrettyString<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_toPrettyString(this__);

class VersionedEntity_TimestampedEntity_SerializableValue<ID extends dynamic> extends TimestampedEntityValue<ID> {

  VersionedEntity_TimestampedEntity_SerializableValue() {
    vptr['serialize'] = VersionedEntity_TimestampedEntity_Serializable_serialize<ID>;
    vptr['toJson'] = VersionedEntity_TimestampedEntity_Serializable_toJson<ID>;
  }
}

VersionedEntity_TimestampedEntity_SerializableValue<ID> VersionedEntity_TimestampedEntity_Serializable_new<ID extends dynamic>(dynamic this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as VersionedEntity_TimestampedEntity_SerializableValue<ID>;
  TimestampedEntity_new(this_, id, name, createdAt, updatedAt);
  return this_;
}

String VersionedEntity_TimestampedEntity_Serializable_serialize<ID extends dynamic>(dynamic this__) {
  throw UnimplementedError('VersionedEntity_TimestampedEntity_Serializable_serialize is abstract');
}

String VersionedEntity_TimestampedEntity_Serializable_toJson<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as VersionedEntity_TimestampedEntity_SerializableValue<ID>;
  return Serializable_toJson(this_);
}

String VersionedEntity_TimestampedEntity_Serializable_get_label<ID extends dynamic>(dynamic this__) => TimestampedEntity_get_label(this__);

String VersionedEntity_TimestampedEntity_Serializable_toPrettyString<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_toPrettyString(this__);

ID VersionedEntity_TimestampedEntity_Serializable_get_cacheKey<ID extends dynamic>(dynamic this__) => Entity_get_cacheKey(this__);

void VersionedEntity_TimestampedEntity_Serializable_cacheValue<ID extends dynamic>(dynamic this__, dynamic value) { Entity_Object_Printable_Cacheable_cacheValue(this__, value); }

dynamic VersionedEntity_TimestampedEntity_Serializable_getCachedValue<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_Cacheable_getCachedValue(this__);

String VersionedEntity_TimestampedEntity_Serializable_toString<ID extends dynamic>(dynamic this__) => Entity_toString(this__);

StaticDuration VersionedEntity_TimestampedEntity_Serializable_get_age<ID extends dynamic>(dynamic this__) => TimestampedEntity_get_age(this__);

class VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID extends dynamic> extends VersionedEntity_TimestampedEntity_SerializableValue<ID> {

  VersionedEntity_TimestampedEntity_Serializable_ValidatableValue() {
    vptr['validate'] = VersionedEntity_TimestampedEntity_Serializable_Validatable_validate<ID>;
    vptr['get_isValid'] = VersionedEntity_TimestampedEntity_Serializable_Validatable_get_isValid<ID>;
  }
}

VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> VersionedEntity_TimestampedEntity_Serializable_Validatable_new<ID extends dynamic>(dynamic this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID>;
  VersionedEntity_TimestampedEntity_Serializable_new(this_, id, name, createdAt, updatedAt);
  return this_;
}

StaticList<String> VersionedEntity_TimestampedEntity_Serializable_Validatable_validate<ID extends dynamic>(dynamic this__) {
  throw UnimplementedError('VersionedEntity_TimestampedEntity_Serializable_Validatable_validate is abstract');
}

bool VersionedEntity_TimestampedEntity_Serializable_Validatable_get_isValid<ID extends dynamic>(dynamic this__) {
  final this_ = this__ as VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID>;
  return Validatable_get_isValid(this_);
}

String VersionedEntity_TimestampedEntity_Serializable_Validatable_get_label<ID extends dynamic>(dynamic this__) => TimestampedEntity_get_label(this__);

String VersionedEntity_TimestampedEntity_Serializable_Validatable_toPrettyString<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_toPrettyString(this__);

ID VersionedEntity_TimestampedEntity_Serializable_Validatable_get_cacheKey<ID extends dynamic>(dynamic this__) => Entity_get_cacheKey(this__);

void VersionedEntity_TimestampedEntity_Serializable_Validatable_cacheValue<ID extends dynamic>(dynamic this__, dynamic value) { Entity_Object_Printable_Cacheable_cacheValue(this__, value); }

dynamic VersionedEntity_TimestampedEntity_Serializable_Validatable_getCachedValue<ID extends dynamic>(dynamic this__) => Entity_Object_Printable_Cacheable_getCachedValue(this__);

String VersionedEntity_TimestampedEntity_Serializable_Validatable_toString<ID extends dynamic>(dynamic this__) => Entity_toString(this__);

StaticDuration VersionedEntity_TimestampedEntity_Serializable_Validatable_get_age<ID extends dynamic>(dynamic this__) => TimestampedEntity_get_age(this__);

String VersionedEntity_TimestampedEntity_Serializable_Validatable_serialize<ID extends dynamic>(dynamic this__) => VersionedEntity_TimestampedEntity_Serializable_serialize(this__);

String VersionedEntity_TimestampedEntity_Serializable_Validatable_toJson<ID extends dynamic>(dynamic this__) => VersionedEntity_TimestampedEntity_Serializable_toJson(this__);

class Money_Comparable2_PrintableValue extends Comparable2Value<MoneyValue> {

  Money_Comparable2_PrintableValue() {
    vptr['get_label'] = Money_Comparable2_Printable_get_label;
    vptr['toPrettyString'] = Money_Comparable2_Printable_toPrettyString;
  }
}

Money_Comparable2_PrintableValue Money_Comparable2_Printable_new(dynamic this__) {
  final this_ = this__ as Money_Comparable2_PrintableValue;
  Comparable2_new(this_);
  return this_;
}

String Money_Comparable2_Printable_get_label(dynamic this__) {
  throw UnimplementedError('Money_Comparable2_Printable_get_label is abstract');
}

String Money_Comparable2_Printable_toPrettyString(dynamic this__) {
  final this_ = this__ as Money_Comparable2_PrintableValue;
  return Printable_toPrettyString(this_);
}

int Money_Comparable2_Printable_compareTo(dynamic this__, MoneyValue other) => Comparable2_compareTo<Money>(this__, other);

bool Money_Comparable2_Printable_operatorLt(dynamic this__, MoneyValue other) => Comparable2_operatorLt<Money>(this__, other);

bool Money_Comparable2_Printable_operatorGt(dynamic this__, MoneyValue other) => Comparable2_operatorGt<Money>(this__, other);

bool Money_Comparable2_Printable_operatorLe(dynamic this__, MoneyValue other) => Comparable2_operatorLe<Money>(this__, other);

bool Money_Comparable2_Printable_operatorGe(dynamic this__, MoneyValue other) => Comparable2_operatorGe<Money>(this__, other);

class ReactiveStore_Object_LoggableValue extends VPtr {

  ReactiveStore_Object_LoggableValue() {
    vptr['log'] = ReactiveStore_Object_Loggable_log;
    vptr['get_logs'] = ReactiveStore_Object_Loggable_get_logs;
  }
}

ReactiveStore_Object_LoggableValue ReactiveStore_Object_Loggable_new(dynamic this__) {
  final this_ = this__ as ReactiveStore_Object_LoggableValue;
  return this_;
}

void ReactiveStore_Object_Loggable_log(dynamic this__, String message) {
  final this_ = this__ as ReactiveStore_Object_LoggableValue;
  Loggable_log(this_, message);
  return;
}

StaticList<String> ReactiveStore_Object_Loggable_get_logs(dynamic this__) {
  final this_ = this__ as ReactiveStore_Object_LoggableValue;
  return Loggable_get_logs(this_);
}

class ReactiveStore_Object_Loggable_ObservableValue<V extends dynamic> extends ReactiveStore_Object_LoggableValue {

  ReactiveStore_Object_Loggable_ObservableValue() {
    vptr['observe'] = ReactiveStore_Object_Loggable_Observable_observe<V>;
    vptr['notify'] = ReactiveStore_Object_Loggable_Observable_notify<V>;
  }
}

ReactiveStore_Object_Loggable_ObservableValue<V> ReactiveStore_Object_Loggable_Observable_new<V extends dynamic>(dynamic this__) {
  final this_ = this__ as ReactiveStore_Object_Loggable_ObservableValue<V>;
  ReactiveStore_Object_Loggable_new(this_);
  return this_;
}

void ReactiveStore_Object_Loggable_Observable_observe<V extends dynamic>(dynamic this__, TypeFunction1<void, V> callback) {
  final this_ = this__ as ReactiveStore_Object_Loggable_ObservableValue<V>;
  Observable_observe(this_, callback);
  return;
}

void ReactiveStore_Object_Loggable_Observable_notify<V extends dynamic>(dynamic this__, V value) {
  final this_ = this__ as ReactiveStore_Object_Loggable_ObservableValue<V>;
  Observable_notify(this_, value);
  return;
}

void ReactiveStore_Object_Loggable_Observable_log<V extends dynamic>(dynamic this__, String message) { ReactiveStore_Object_Loggable_log(this__, message); }

StaticList<String> ReactiveStore_Object_Loggable_Observable_get_logs<V extends dynamic>(dynamic this__) => ReactiveStore_Object_Loggable_get_logs(this__);

class LabeledNode_Node_PrintableValue<T extends dynamic> extends NodeValue<T> {

  LabeledNode_Node_PrintableValue() {
    vptr['get_label'] = LabeledNode_Node_Printable_get_label<T>;
    vptr['toPrettyString'] = LabeledNode_Node_Printable_toPrettyString<T>;
  }
}

LabeledNode_Node_PrintableValue<T> LabeledNode_Node_Printable_new<T extends dynamic>(dynamic this__, T value, [StaticList<NodeValue<T>>? children = null]) {
  final this_ = this__ as LabeledNode_Node_PrintableValue<T>;
  Node_new(this_, value, children);
  return this_;
}

String LabeledNode_Node_Printable_get_label<T extends dynamic>(dynamic this__) {
  throw UnimplementedError('LabeledNode_Node_Printable_get_label is abstract');
}

String LabeledNode_Node_Printable_toPrettyString<T extends dynamic>(dynamic this__) {
  final this_ = this__ as LabeledNode_Node_PrintableValue<T>;
  return Printable_toPrettyString(this_);
}

void LabeledNode_Node_Printable_addChild<T extends dynamic>(dynamic this__, NodeValue<T> child) { Node_addChild(this__, child); }

StaticList<T> LabeledNode_Node_Printable_flatten<T extends dynamic>(dynamic this__) => Node_flatten(this__);

NodeValue<R> LabeledNode_Node_Printable_mapTree<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) => Node_mapTree(this__, transform);

String LabeledNode_Node_Printable_toString<T extends dynamic>(dynamic this__) => Node_toString(this__);

T applyTransform<T extends dynamic>(T value, TypeFunction1<T, T> transform) {
  return transform(value);
}

StaticList<T> filterWith<T extends dynamic>(StaticList<T> items, TypeFunction1<bool, T> predicate) {
  StaticList<T> result = StaticList<T>.of([]);
  for (final item in items) {
    if (predicate(item)) {
      result.add(item);
    }
  }
  return result;
}

T reduceList<T extends dynamic>(StaticList<T> items, TypeFunction2<T, T, T> reducer) {
  T acc = items.first;
  for (int i = 1; (i < items.length); i = (i + 1)) {
    acc = reducer(acc, items[i]);
  }
  return acc;
}

StaticList<String> testClosureBoxing() {
  StaticList<String> log = StaticList<String>.of([]);
  int counter = 0;
  TypeFunction0<int> increment = ClosureEnv_global_2_new(GC.allocateLocal(ClosureEnv_global_2()), counter);
  increment();
  increment();
  log.add('counter=${counter}');
  StaticList<TypeFunction0<int>> fns = StaticList<TypeFunction0<int>>.of([]);
  for (int i = 0; (i < 3); i = (i + 1)) {
    fns.add(ClosureEnv_global_3_new(GC.allocateLocal(ClosureEnv_global_3()), i));
  }
  log.add('fns=${StaticList<int>.of(StaticList<int>.of(fns.map(ClosureEnv_global_4_new(GC.allocateLocal(ClosureEnv_global_4())))).toList())}');
  int outer = 0;
  TypeFunction1<TypeFunction1<int, int>, int> makeAdder = ClosureEnv_global_5_new(GC.allocateLocal(ClosureEnv_global_5()), outer);
  TypeFunction1<int, int> adder = makeAdder(100);
  adder(5);
  adder(10);
  log.add('outer=${outer}, adder(0)=${adder(0)}');
  String captureParam(String prefix) {
    int count = 0;
    TypeFunction0<String> fn = ClosureEnv_global_7_new(GC.allocateLocal(ClosureEnv_global_7()), count, prefix);
    fn();
    fn();
    return fn();
  }
  log.add('captureParam=${captureParam('test')}');
  EventBusValue bus = EventBus_new(EventBusValue());
  StaticList<String> received = StaticList<String>.of([]);
  (bus.vptr['on'] as Function)(bus, ClosureEnv_global_8_new(GC.allocateLocal(ClosureEnv_global_8()), received));
  (bus.vptr['emit'] as Function)(bus, 'hello');
  (bus.vptr['emit'] as Function)(bus, 'world');
  log.add('received=${received}');
  return log;
}

String testExceptionChain() {
  try {
    try {
      throw AppError_new(AppErrorValue(), 'not found', 'E404');
    } on dynamic catch ( e) {
      throw AppError_new(AppErrorValue(), 'service failed', 'E500', (e as AppErrorValue));
    }
  } on dynamic catch ( e) {
    try {
      throw AppError_new(AppErrorValue(), 'gateway error', 'E502', (e as AppErrorValue));
    } on dynamic catch ( e2) {
      return e2.toString();
    }
  }
}

String formatRecord({required String name, int age = 0, String? email = null, bool active = true, StaticList<String> tags = StaticList.of([])}) {
  StaticList<String> parts = StaticList<String>.of([name]);
  if ((age > 0)) {
    parts.add('age=${age}');
  }
  if (!(email == null)) {
    parts.add('email=${email}');
  }
  parts.add('active=${active}');
  if (tags.isNotEmpty) {
    parts.add('tags=${tags}');
  }
  return 'Record(${parts.join(', ')})';
}

String greetAll(String greeting, [String name = 'World', String suffix = '!']) {
  return '${greeting}, ${name}${suffix}';
}

String describeShape(ShapeValue shape) {
  if (shape is CircleValue) {
    return '${(shape.vptr['get_shapeName'] as Function)(shape)}: r=${shape.radius}, area=${dart_str_toStringAsFixed((shape.vptr['area'] as Function)(shape), 2)}';
  } else {
    if (shape is RectangleValue) {
      return '${(shape.vptr['get_shapeName'] as Function)(shape)}: ${shape.width}x${shape.height}, area=${dart_str_toStringAsFixed((shape.vptr['area'] as Function)(shape), 2)}';
    }
  }
  return 'Unknown shape: area=${(shape.vptr['area'] as Function)(shape)}';
}

String evaluateGrade(int score) {
  String letter = ((score >= 90) ? 'A' : ((score >= 80) ? 'B' : ((score >= 70) ? 'C' : ((score >= 60) ? 'D' : 'F'))));
  late String description;
  do {
    switch (letter) {
      case 'A':
        description = 'Excellent';
        break;
      case 'B':
        description = 'Good';
        break;
      case 'C':
        description = 'Average';
        break;
      case 'D':
        description = 'Below Average';
        break;
      default:
        description = 'Failing';
    }
  } while (false);
  return '${score} → ${letter} (${description})';
}

void main() {
  staticPrint('--- 1. typedef + Function ---');
  int doubled = applyTransform(21, ClosureEnv_global_9_new(GC.allocateLocal(ClosureEnv_global_9())));
  staticPrint('applyTransform: ${doubled}');
  StaticList<int> evens = filterWith(StaticList<int>.of([1, 2, 3, 4, 5, 6]), ClosureEnv_global_10_new(GC.allocateLocal(ClosureEnv_global_10())));
  staticPrint('filterWith: ${evens}');
  int sum = reduceList(StaticList<int>.of([1, 2, 3, 4, 5]), ClosureEnv_global_11_new(GC.allocateLocal(ClosureEnv_global_11())));
  staticPrint('reduceList: ${sum}');
  staticPrint('\n--- 2. 枚举类 ---');
  staticPrint('red hex: ${Color_get_hex(Color.red)}');
  staticPrint('green isWarm: ${Color_get_isWarm(Color.green)}');
  staticPrint('priorities: ${StaticList<String>.of(StaticList<String>.of(StaticList.of([Priority.low, Priority.medium, Priority.high, Priority.critical]).map(ClosureEnv_global_12_new(GC.allocateLocal(ClosureEnv_global_12())))).toList())}');
  staticPrint('\n--- 3. 运算符重载 ---');
  MoneyValue price1 = Money_new(MoneyValue(), 1099, 'USD');
  MoneyValue price2 = Money_new_fromDollars(MoneyValue(), 5.5);
  MoneyValue total = (price1.vptr['operatorPlus'] as Function)(price1, price2);
  MoneyValue negated = (price2.vptr['operatorUnaryMinus'] as Function)(price2);
  staticPrint('price1: ${(price1.vptr['toPrettyString'] as Function)(price1)}');
  staticPrint('price2: ${price2}');
  staticPrint('total: ${total}');
  staticPrint('negated: ${negated}');
  staticPrint('price1 > price2: ${(price1.vptr['operatorGt'] as Function)(price1, price2)}');
  staticPrint('price1 < price2: ${(price1.vptr['operatorLt'] as Function)(price1, price2)}');
  staticPrint('price1 * 3: ${(price1.vptr['operatorStar'] as Function)(price1, 3)}');
  staticPrint('\n--- 4. 多层泛型继承 ---');
  EntityValue<int> entity = Entity_new<int>(EntityValue<int>(), 1, 'alice');
  staticPrint('entity: ${entity}');
  staticPrint('entity label: ${(entity.vptr['toPrettyString'] as Function)(entity)}');
  (entity.vptr['cacheValue'] as Function)(entity, 'cached_data');
  staticPrint('cached: ${(entity.vptr['getCachedValue'] as Function)(entity)}');
  TimestampedEntityValue<String> tsEntity = TimestampedEntity_new<String>(TimestampedEntityValue<String>(), 'u1', 'bob', 1000, 2000);
  staticPrint('tsEntity label: ${(tsEntity.vptr['toPrettyString'] as Function)(tsEntity)}');
  VersionedEntityValue<int> vEntity = VersionedEntity_new<int>(VersionedEntityValue<int>(), 42, 'project', 1000, 5000);
  (vEntity.vptr['bump'] as Function)(vEntity, 'initial release');
  (vEntity.vptr['bump'] as Function)(vEntity, 'bug fix');
  staticPrint('vEntity label: ${(vEntity.vptr['toPrettyString'] as Function)(vEntity)}');
  staticPrint('vEntity version: ${(vEntity.vptr['get_version'] as Function)(vEntity)}');
  staticPrint('vEntity changelog: ${(vEntity.vptr['get_changelog'] as Function)(vEntity)}');
  staticPrint('vEntity serialize: ${(vEntity.vptr['serialize'] as Function)(vEntity)}');
  staticPrint('vEntity toJson: ${(vEntity.vptr['toJson'] as Function)(vEntity)}');
  staticPrint('vEntity isValid: ${(vEntity.vptr['get_isValid'] as Function)(vEntity)}');
  staticPrint('vEntity validate: ${(vEntity.vptr['validate'] as Function)(vEntity)}');
  staticPrint('\n--- 5. 工厂构造 ---');
  ConfigValue cfg1 = Config_new_empty(ConfigValue());
  (cfg1.vptr['operatorIndexSet'] as Function)(cfg1, 'host', 'localhost');
  staticPrint('cfg1: ${cfg1}');
  ConfigValue cfg2 = Config_new_fromPairs(ConfigValue(), StaticList<StaticList<dynamic>>.of([StaticList<dynamic>.of(['a', 1]), StaticList<dynamic>.of(['b', 2])]));
  staticPrint('cfg2: ${cfg2}');
  ConfigValue cfg3 = Config_new_withDefaults(StaticMap<String, dynamic>.of({'debug': true, 'name': 'prod'}));
  staticPrint('cfg3: ${cfg3}');
  staticPrint('cfg3[maxRetries]: ${(cfg3.vptr['operatorIndex'] as Function)(cfg3, 'maxRetries')}');
  staticPrint('\n--- 6. 闭包 Box 化 ---');
  StaticList<String> closureLog = testClosureBoxing();
  for (final line in closureLog) {
    staticPrint(line);
  }
  staticPrint('\n--- 7. 多重 implements ---');
  WidgetValue widget = Widget_new(WidgetValue());
  (widget.vptr['draw'] as Function)(widget);
  (widget.vptr['resize'] as Function)(widget, 1.5);
  (widget.vptr['onClick'] as Function)(widget);
  (widget.vptr['onClick'] as Function)(widget);
  staticPrint('widget: ${(widget.vptr['get_info'] as Function)(widget)}');
  staticPrint('\n--- 8. 泛型 Pair ---');
  PairValue<int, String> pair = Pair_new<int, String>(PairValue<int, String>(), 42, 'hello');
  staticPrint('pair: ${pair}');
  staticPrint('swap: ${(pair.vptr['swap'] as Function)(pair)}');
  staticPrint('mapFirst: ${(pair.vptr['mapFirst_int'] as Function)(pair, ClosureEnv_global_13_new(GC.allocateLocal(ClosureEnv_global_13())))}');
  staticPrint('mapSecond: ${(pair.vptr['mapSecond_String'] as Function)(pair, ClosureEnv_global_14_new(GC.allocateLocal(ClosureEnv_global_14())))}');
  staticPrint('fold: ${(pair.vptr['fold_String'] as Function)(pair, ClosureEnv_global_15_new(GC.allocateLocal(ClosureEnv_global_15())))}');
  TripleValue<int, String, bool> triple = Triple_new<int, String, bool>(TripleValue<int, String, bool>(), 1, 'yes', true);
  staticPrint('triple: ${triple}');
  staticPrint('\n--- 9. 级联操作 ---');
  StringBuilderValue sb = (() { final _unnamed = StringBuilder_new(StringBuilderValue()); return (() { (_unnamed.vptr['withSeparator'] as Function)(_unnamed, ', ');
(_unnamed.vptr['add'] as Function)(_unnamed, 'alpha');
(_unnamed.vptr['add'] as Function)(_unnamed, 'beta');
(_unnamed.vptr['addAll'] as Function)(_unnamed, StaticList<String>.of(['gamma', 'delta']));
return _unnamed; })(); })();
  staticPrint('builder: ${sb}');
  staticPrint('length: ${(sb.vptr['get_length'] as Function)(sb)}');
  staticPrint('\n--- 10. 异常处理链 ---');
  staticPrint('chain: ${testExceptionChain()}');
  staticPrint('\n--- 11. 集合操作 ---');
  DataPipelineValue<int> pipeline = ((((DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()))).vptr['sorted'] as Function)((DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()))), ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()))).vptr['take'] as Function)(((DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()))).vptr['sorted'] as Function)((DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()))), ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()))), 5).vptr['map_int'] as Function)((((DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()))).vptr['sorted'] as Function)((DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()))), ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()))).vptr['take'] as Function)(((DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()))).vptr['sorted'] as Function)((DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16()))), ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()))), 5), ClosureEnv_global_18_new(GC.allocateLocal(ClosureEnv_global_18())));
  staticPrint('pipeline: ${(pipeline.vptr['toList'] as Function)(pipeline)}');
  int pipeSum = (DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([1, 2, 3, 4, 5])).vptr['fold_int'] as Function)(DataPipeline_new<int>(DataPipelineValue<int>(), StaticList<int>.of([1, 2, 3, 4, 5])), 0, ClosureEnv_global_19_new(GC.allocateLocal(ClosureEnv_global_19())));
  staticPrint('pipeSum: ${pipeSum}');
  staticPrint('\n--- 12. 可选参数 ---');
  staticPrint(formatRecord(name: 'Alice', age: 30, email: 'alice@test.com'));
  staticPrint(formatRecord(name: 'Bob', tags: StaticList<String>.of(['admin', 'vip'])));
  staticPrint(greetAll('Hello'));
  staticPrint(greetAll('Hi', 'Dart', '!!'));
  staticPrint('\n--- 13. BoundedValue ---');
  BoundedValueValue bv = BoundedValue_new(BoundedValueValue(), 5.0, 0.0, 10.0);
  staticPrint('bv: ${bv}');
  (bv.vptr['set_value'] as Function)(bv, 15.0);
  staticPrint('after set 15: ${bv}');
  (bv.vptr['set_value'] as Function)(bv, -5.0);
  staticPrint('after set -5: ${bv}');
  BoundedValueValue bv2 = (bv.vptr['operatorPlus'] as Function)(bv, 7.0);
  staticPrint('bv + 7: ${bv2}');
  staticPrint('\n--- 14. 静态方法 ---');
  staticPrint('5! = ${MathUtils_factorial(5)}');
  staticPrint('fib(8): ${MathUtils_fibonacci(8)}');
  staticPrint('lerp(0,100,0.3): ${MathUtils_lerp(0.0, 100.0, 0.3)}');
  staticPrint('callCount: ${MathUtils_get_callCount()}');
  staticPrint('\n--- 15. ReactiveStore ---');
  ReactiveStoreValue<int> store = ReactiveStore_new<int>(ReactiveStoreValue<int>());
  StaticList<int> observed = StaticList<int>.of([]);
  (store.vptr['observe'] as Function)(store, ClosureEnv_global_20_new(GC.allocateLocal(ClosureEnv_global_20()), observed));
  (store.vptr['set'] as Function)(store, 'x', 10);
  (store.vptr['set'] as Function)(store, 'y', 20);
  staticPrint('store: ${store}');
  staticPrint('store.get(x): ${(store.vptr['get'] as Function)(store, 'x')}');
  staticPrint('store.size: ${(store.vptr['get_size'] as Function)(store)}');
  staticPrint('observed: ${observed}');
  staticPrint('logs: ${(store.vptr['get_logs'] as Function)(store)}');
  staticPrint('\n--- 16. 类型转换 ---');
  StaticList<ShapeValue> shapes = StaticList<ShapeValue>.of([Circle_new(CircleValue(), 5.0), Rectangle_new(RectangleValue(), 3.0, 4.0), Circle_new(CircleValue(), 1.0)]);
  for (final s in shapes) {
    staticPrint(describeShape(s));
  }
  staticPrint('\n--- 17. 树结构 ---');
  NodeValue<int> tree = Node_new<int>(NodeValue<int>(), 1, StaticList<NodeValue<int>>.of([Node_new<int>(NodeValue<int>(), 2, StaticList<NodeValue<int>>.of([Node_new<int>(NodeValue<int>(), 4), Node_new<int>(NodeValue<int>(), 5)])), Node_new<int>(NodeValue<int>(), 3, StaticList<NodeValue<int>>.of([Node_new<int>(NodeValue<int>(), 6)]))]));
  staticPrint('tree: ${tree}');
  staticPrint('flatten: ${(tree.vptr['flatten'] as Function)(tree)}');
  NodeValue<String> strTree = (tree.vptr['mapTree_String'] as Function)(tree, ClosureEnv_global_21_new(GC.allocateLocal(ClosureEnv_global_21())));
  staticPrint('mapped: ${strTree}');
  LabeledNodeValue<int> labeled = LabeledNode_new<int>(LabeledNodeValue<int>(), 'root', 100);
  (labeled.vptr['addChild'] as Function)(labeled, Node_new<int>(NodeValue<int>(), 200));
  (labeled.vptr['addChild'] as Function)(labeled, Node_new<int>(NodeValue<int>(), 300));
  staticPrint('labeled: ${labeled}');
  staticPrint('labeled pretty: ${(labeled.vptr['toPrettyString'] as Function)(labeled)}');
  staticPrint('labeled flatten: ${(labeled.vptr['flatten'] as Function)(labeled)}');
  staticPrint('\n--- 18. 评分 ---');
  staticPrint(evaluateGrade(95));
  staticPrint(evaluateGrade(82));
  staticPrint(evaluateGrade(67));
  staticPrint(evaluateGrade(55));
  staticPrint('\n=== 所有压力测试通过 ✅ ===');
}

class ClosureEnv_global_0 extends TypeFunction1<String, String> {
  late ConfigValue this_;

  ClosureEnv_global_0() {
  }
  String call(String k) =>
      ClosureEnv_global_0_call(this, k);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

String ClosureEnv_global_0_call(dynamic env__, String k) {
  final env = env__ as ClosureEnv_global_0;
  return '${k}=${env.this_._data[k]}';
}

ClosureEnv_global_0 ClosureEnv_global_0_new(ClosureEnv_global_0 env_, ConfigValue this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_1<R extends dynamic, T extends dynamic> extends TypeFunction1<NodeValue<R>, NodeValue<T>> {
  late TypeFunction1<R, T> transform;

  ClosureEnv_global_1() {
  }
  NodeValue<R> call(NodeValue<T> c) =>
      ClosureEnv_global_1_call(this, c);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    transform?.gcMark(flag);
  }
}

NodeValue<R> ClosureEnv_global_1_call<R extends dynamic, T extends dynamic>(dynamic env__, NodeValue<T> c) {
  final env = env__ as ClosureEnv_global_1<R, T>;
  return (c.vptr['mapTree'] as Function)(c, env.transform);
}

ClosureEnv_global_1<R, T> ClosureEnv_global_1_new<R extends dynamic, T extends dynamic>(ClosureEnv_global_1<R, T> env_, TypeFunction1<R, T> transform) {
  env_.transform = transform;
  return env_;
}

class ClosureEnv_global_2 extends TypeFunction0<int> {
  late int counter;

  ClosureEnv_global_2() {
  }
  int call() =>
      ClosureEnv_global_2_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

int ClosureEnv_global_2_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_2;
  env.counter = (env.counter + 1);
  return env.counter;
}

ClosureEnv_global_2 ClosureEnv_global_2_new(ClosureEnv_global_2 env_, int counter) {
  env_.counter = counter;
  return env_;
}

class ClosureEnv_global_3 extends TypeFunction0<int> {
  late int i;

  ClosureEnv_global_3() {
  }
  int call() =>
      ClosureEnv_global_3_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

int ClosureEnv_global_3_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_3;
  return (env.i * 10);
}

ClosureEnv_global_3 ClosureEnv_global_3_new(ClosureEnv_global_3 env_, int i) {
  env_.i = i;
  return env_;
}

class ClosureEnv_global_4 extends TypeFunction1<int, TypeFunction0<int>> {

  ClosureEnv_global_4() {
  }
  int call(TypeFunction0<int> f) =>
      ClosureEnv_global_4_call(this, f);
}

int ClosureEnv_global_4_call(dynamic env__, TypeFunction0<int> f) {
  final env = env__ as ClosureEnv_global_4;
  return f();
}

ClosureEnv_global_4 ClosureEnv_global_4_new(ClosureEnv_global_4 env_) {
  return env_;
}

class ClosureEnv_global_6 extends TypeFunction1<int, int> {
  late int inner;
  late int outer;

  ClosureEnv_global_6() {
  }
  int call(int x) =>
      ClosureEnv_global_6_call(this, x);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

int ClosureEnv_global_6_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_6;
  env.inner.value = (env.inner.value + x);
  env.outer = (env.outer + x);
  return env.inner.value;
}

ClosureEnv_global_6 ClosureEnv_global_6_new(ClosureEnv_global_6 env_, int inner, int outer) {
  env_.inner = inner;
  env_.outer = outer;
  return env_;
}

class ClosureEnv_global_5 extends TypeFunction1<TypeFunction1<int, int>, int> {
  late int outer;

  ClosureEnv_global_5() {
  }
  TypeFunction1<int, int> call(int base) =>
      ClosureEnv_global_5_call(this, base);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

TypeFunction1<int, int> ClosureEnv_global_5_call(dynamic env__, int base) {
  final env = env__ as ClosureEnv_global_5;
  IntBox inner = IntBox(base);
  return ClosureEnv_global_6_new(GC.allocateLocal(ClosureEnv_global_6()), inner, env.outer);
}

ClosureEnv_global_5 ClosureEnv_global_5_new(ClosureEnv_global_5 env_, int outer) {
  env_.outer = outer;
  return env_;
}

class ClosureEnv_global_7 extends TypeFunction0<String> {
  late int count;
  late String prefix;

  ClosureEnv_global_7() {
  }
  String call() =>
      ClosureEnv_global_7_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

String ClosureEnv_global_7_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_7;
  env.count = (env.count + 1);
  return '${env.prefix}-${env.count}';
}

ClosureEnv_global_7 ClosureEnv_global_7_new(ClosureEnv_global_7 env_, int count, String prefix) {
  env_.count = count;
  env_.prefix = prefix;
  return env_;
}

class ClosureEnv_global_8 extends TypeFunction1<void, String> {
  late StaticList<String> received;

  ClosureEnv_global_8() {
  }
  void call(String event) =>
      ClosureEnv_global_8_call(this, event);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    received?.gcMark(flag);
  }
}

void ClosureEnv_global_8_call(dynamic env__, String event) {
  final env = env__ as ClosureEnv_global_8;
  env.received.add(event);
}

ClosureEnv_global_8 ClosureEnv_global_8_new(ClosureEnv_global_8 env_, StaticList<String> received) {
  env_.received = received;
  return env_;
}

class ClosureEnv_global_9 extends TypeFunction1<int, int> {

  ClosureEnv_global_9() {
  }
  int call(int x) =>
      ClosureEnv_global_9_call(this, x);
}

int ClosureEnv_global_9_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_9;
  return (x * 2);
}

ClosureEnv_global_9 ClosureEnv_global_9_new(ClosureEnv_global_9 env_) {
  return env_;
}

class ClosureEnv_global_10 extends TypeFunction1<bool, int> {

  ClosureEnv_global_10() {
  }
  bool call(int x) =>
      ClosureEnv_global_10_call(this, x);
}

bool ClosureEnv_global_10_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_10;
  return ((x % 2) == 0);
}

ClosureEnv_global_10 ClosureEnv_global_10_new(ClosureEnv_global_10 env_) {
  return env_;
}

class ClosureEnv_global_11 extends TypeFunction2<int, int, int> {

  ClosureEnv_global_11() {
  }
  int call(int a, int b) =>
      ClosureEnv_global_11_call(this, a, b);
}

int ClosureEnv_global_11_call(dynamic env__, int a, int b) {
  final env = env__ as ClosureEnv_global_11;
  return (a + b);
}

ClosureEnv_global_11 ClosureEnv_global_11_new(ClosureEnv_global_11 env_) {
  return env_;
}

class ClosureEnv_global_12 extends TypeFunction1<String, Priority> {

  ClosureEnv_global_12() {
  }
  String call(Priority p) =>
      ClosureEnv_global_12_call(this, p);
}

String ClosureEnv_global_12_call(dynamic env__, Priority p) {
  final env = env__ as ClosureEnv_global_12;
  return StaticList<String>.of('${p}'.split('.')).last;
}

ClosureEnv_global_12 ClosureEnv_global_12_new(ClosureEnv_global_12 env_) {
  return env_;
}

class ClosureEnv_global_13 extends TypeFunction1<int, int> {

  ClosureEnv_global_13() {
  }
  int call(int x) =>
      ClosureEnv_global_13_call(this, x);
}

int ClosureEnv_global_13_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_13;
  return (x * 2);
}

ClosureEnv_global_13 ClosureEnv_global_13_new(ClosureEnv_global_13 env_) {
  return env_;
}

class ClosureEnv_global_14 extends TypeFunction1<String, String> {

  ClosureEnv_global_14() {
  }
  String call(String s) =>
      ClosureEnv_global_14_call(this, s);
}

String ClosureEnv_global_14_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_global_14;
  return s.toUpperCase();
}

ClosureEnv_global_14 ClosureEnv_global_14_new(ClosureEnv_global_14 env_) {
  return env_;
}

class ClosureEnv_global_15 extends TypeFunction2<String, int, String> {

  ClosureEnv_global_15() {
  }
  String call(int a, String b) =>
      ClosureEnv_global_15_call(this, a, b);
}

String ClosureEnv_global_15_call(dynamic env__, int a, String b) {
  final env = env__ as ClosureEnv_global_15;
  return '${b}=${a}';
}

ClosureEnv_global_15 ClosureEnv_global_15_new(ClosureEnv_global_15 env_) {
  return env_;
}

class ClosureEnv_global_16 extends TypeFunction1<bool, int> {

  ClosureEnv_global_16() {
  }
  bool call(int x) =>
      ClosureEnv_global_16_call(this, x);
}

bool ClosureEnv_global_16_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_16;
  return (x > 2);
}

ClosureEnv_global_16 ClosureEnv_global_16_new(ClosureEnv_global_16 env_) {
  return env_;
}

class ClosureEnv_global_17 extends TypeFunction2<int, int, int> {

  ClosureEnv_global_17() {
  }
  int call(int a, int b) =>
      ClosureEnv_global_17_call(this, a, b);
}

int ClosureEnv_global_17_call(dynamic env__, int a, int b) {
  final env = env__ as ClosureEnv_global_17;
  return (a - b);
}

ClosureEnv_global_17 ClosureEnv_global_17_new(ClosureEnv_global_17 env_) {
  return env_;
}

class ClosureEnv_global_18 extends TypeFunction1<int, int> {

  ClosureEnv_global_18() {
  }
  int call(int x) =>
      ClosureEnv_global_18_call(this, x);
}

int ClosureEnv_global_18_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_18;
  return (x * 10);
}

ClosureEnv_global_18 ClosureEnv_global_18_new(ClosureEnv_global_18 env_) {
  return env_;
}

class ClosureEnv_global_19 extends TypeFunction2<int, int, int> {

  ClosureEnv_global_19() {
  }
  int call(int acc, int x) =>
      ClosureEnv_global_19_call(this, acc, x);
}

int ClosureEnv_global_19_call(dynamic env__, int acc, int x) {
  final env = env__ as ClosureEnv_global_19;
  return (acc + x);
}

ClosureEnv_global_19 ClosureEnv_global_19_new(ClosureEnv_global_19 env_) {
  return env_;
}

class ClosureEnv_global_20 extends TypeFunction1<void, int> {
  late StaticList<int> observed;

  ClosureEnv_global_20() {
  }
  void call(int v) =>
      ClosureEnv_global_20_call(this, v);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    observed?.gcMark(flag);
  }
}

void ClosureEnv_global_20_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_20;
  env.observed.add(v);
}

ClosureEnv_global_20 ClosureEnv_global_20_new(ClosureEnv_global_20 env_, StaticList<int> observed) {
  env_.observed = observed;
  return env_;
}

class ClosureEnv_global_21 extends TypeFunction1<String, int> {

  ClosureEnv_global_21() {
  }
  String call(int x) =>
      ClosureEnv_global_21_call(this, x);
}

String ClosureEnv_global_21_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_21;
  return 'N${x}';
}

ClosureEnv_global_21 ClosureEnv_global_21_new(ClosureEnv_global_21 env_) {
  return env_;
}


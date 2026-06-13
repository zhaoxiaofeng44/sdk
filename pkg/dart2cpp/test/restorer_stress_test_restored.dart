import 'package:dart2cpp/restorer/runtime_classes.dart';

typedef Predicate<T> = TypeFunction1<bool, T>;

typedef Transformer<A, B> = TypeFunction1<B, A>;

typedef Reducer<T> = TypeFunction2<T, T, T>;

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

String Color_get_hex(Color this_) {
  do {
    switch (this_) {
      case Color.red:
{
          return '#FF0000';
        }
      case Color.green:
{
          return '#00FF00';
        }
      case Color.blue:
{
          return '#0000FF';
        }
    }
  } while (false);
}

bool Color_get_isWarm(Color this_) {
  return (this_ == Color.red);
}

class Comparable2Value<T> extends VPtr {
  Comparable2Value() {
    vptr['compareTo'] = Comparable2_compareTo<T>;
    vptr['operatorLt'] = Comparable2_operatorLt<T>;
    vptr['operatorGt'] = Comparable2_operatorGt<T>;
    vptr['operatorLte'] = Comparable2_operatorLte<T>;
    vptr['operatorGte'] = Comparable2_operatorGte<T>;
  }
}

Comparable2Value<T> Comparable2_new<T>(dynamic this__) {
  final this_ = this__ as Comparable2Value<T>;
  return this_;
}

int Comparable2_compareTo<T>(dynamic this_, T other) {
  throw UnimplementedError('Comparable2.compareTo is abstract');
}

bool Comparable2_operatorLt<T>(dynamic this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.vptr['compareTo'] as int Function(dynamic, T))(this_, other) < 0);
}

bool Comparable2_operatorGt<T>(dynamic this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.vptr['compareTo'] as int Function(dynamic, T))(this_, other) > 0);
}

bool Comparable2_operatorLte<T>(dynamic this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.vptr['compareTo'] as int Function(dynamic, T))(this_, other) <= 0);
}

bool Comparable2_operatorGte<T>(dynamic this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.vptr['compareTo'] as int Function(dynamic, T))(this_, other) >= 0);
}


// mixin Printable → static functions for delegation
String Printable_toPrettyString(dynamic this__) {
  final this_ = this__;
  return '[${(this_.vptr['get_label'] as String Function(dynamic))(this_)}]';
}


// mixin Serializable → static functions for delegation
String Serializable_toJson<T>(dynamic this__) {
  final this_ = this__;
  return '{"data": "${(this_.vptr['serialize'] as T Function(dynamic))(this_)}"}';
}


// mixin Cacheable → static functions for delegation
final StaticMap<String, dynamic> Cacheable__cache = StaticMap<String, dynamic>.of({});
void Cacheable_cacheValue<K>(dynamic this__, dynamic value) {
  final this_ = this__;
  Cacheable__cache['${(this_.vptr['get_cacheKey'] as K Function(dynamic))(this_)}'] = value;
}

dynamic Cacheable_getCachedValue<K>(dynamic this__) {
  final this_ = this__;
  return Cacheable__cache['${(this_.vptr['get_cacheKey'] as K Function(dynamic))(this_)}'];
}


// mixin Validatable → static functions for delegation
bool Validatable_get_isValid(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['validate'] as StaticList<String> Function(dynamic))(this_).isEmpty;
}


class EntityValue<ID> extends Entity_Object_Printable_CacheableValue<ID> {
  late ID id;
  late String name;
  EntityValue() {
    vptr['get_label'] = Entity_get_label<ID>;
    vptr['toPrettyString'] = Entity_toPrettyString<ID>;
    vptr['get_cacheKey'] = Entity_get_cacheKey<ID>;
    vptr['cacheValue'] = Entity_cacheValue<ID>;
    vptr['getCachedValue'] = Entity_getCachedValue<ID>;
    vptr['toString'] = Entity_toString<ID>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (id is AnyGC) (id as AnyGC).gcMark(flag);
  }
}

EntityValue<ID> Entity_new<ID>(dynamic this__, ID id, String name) {
  final this_ = this__ as EntityValue<ID>;
  this_.id = id;
  this_.name = name;
  return this_;
}

String Entity_get_label<ID>(dynamic this__) {
  final this_ = this__ as EntityValue<ID>;
  return '${this_.name}(${this_.id})';
}

ID Entity_get_cacheKey<ID>(dynamic this__) {
  final this_ = this__ as EntityValue<ID>;
  return this_.id;
}

String Entity_toString<ID>(dynamic this__) {
  final this_ = this__ as EntityValue<ID>;
  return 'Entity(${this_.id}, ${this_.name})';
}

String Entity_toPrettyString<ID>(dynamic this__) {
  final this_ = this__ as EntityValue<ID>;
  return Printable_toPrettyString(this_);
}

void Entity_cacheValue<ID>(dynamic this__, dynamic value) {
  final this_ = this__ as EntityValue<ID>;
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic Entity_getCachedValue<ID>(dynamic this__) {
  final this_ = this__ as EntityValue<ID>;
  return Cacheable_getCachedValue<ID>(this_);
}


class TimestampedEntityValue<ID> extends EntityValue<ID> {
  late int createdAt;
  late int updatedAt;
  TimestampedEntityValue() {
    vptr['get_label'] = TimestampedEntity_get_label<ID>;
    vptr['toPrettyString'] = TimestampedEntity_toPrettyString<ID>;
    vptr['get_cacheKey'] = TimestampedEntity_get_cacheKey<ID>;
    vptr['cacheValue'] = TimestampedEntity_cacheValue<ID>;
    vptr['getCachedValue'] = TimestampedEntity_getCachedValue<ID>;
    vptr['toString'] = TimestampedEntity_toString<ID>;
    vptr['get_age'] = TimestampedEntity_get_age<ID>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

TimestampedEntityValue<ID> TimestampedEntity_new<ID>(dynamic this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  Entity_new<ID>(this_, id, name);
  this_.createdAt = createdAt;
  this_.updatedAt = updatedAt;
  return this_;
}

StaticDuration TimestampedEntity_get_age<ID>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return StaticDuration(milliseconds: (this_.updatedAt - this_.createdAt));
}

String TimestampedEntity_get_label<ID>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return '${this_.name}(${this_.id}, age=${(this_.vptr['get_age'] as StaticDuration Function(dynamic))(this_).inMilliseconds}ms)';
}

String TimestampedEntity_toPrettyString<ID>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Printable_toPrettyString(this_);
}

ID TimestampedEntity_get_cacheKey<ID>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Entity_get_cacheKey<ID>(this_);
}

void TimestampedEntity_cacheValue<ID>(dynamic this__, dynamic value) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic TimestampedEntity_getCachedValue<ID>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Cacheable_getCachedValue<ID>(this_);
}

String TimestampedEntity_toString<ID>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Entity_toString<ID>(this_);
}


class VersionedEntityValue<ID> extends VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> {
  late int _version;
  late StaticList<String> _changelog;
  VersionedEntityValue() {
    vptr['get_label'] = VersionedEntity_get_label<ID>;
    vptr['toPrettyString'] = VersionedEntity_toPrettyString<ID>;
    vptr['get_cacheKey'] = VersionedEntity_get_cacheKey<ID>;
    vptr['cacheValue'] = VersionedEntity_cacheValue<ID>;
    vptr['getCachedValue'] = VersionedEntity_getCachedValue<ID>;
    vptr['toString'] = VersionedEntity_toString<ID>;
    vptr['get_age'] = VersionedEntity_get_age<ID>;
    vptr['serialize'] = VersionedEntity_serialize<ID>;
    vptr['toJson'] = VersionedEntity_toJson<ID>;
    vptr['validate'] = VersionedEntity_validate<ID>;
    vptr['get_isValid'] = VersionedEntity_get_isValid<ID>;
    vptr['get_version'] = VersionedEntity_get_version<ID>;
    vptr['bump'] = VersionedEntity_bump<ID>;
    vptr['get_changelog'] = VersionedEntity_get_changelog<ID>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_changelog is AnyGC) (_changelog as AnyGC).gcMark(flag);
  }
}

VersionedEntityValue<ID> VersionedEntity_new<ID>(dynamic this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as VersionedEntityValue<ID>;
  TimestampedEntity_new<ID>(this_, id, name, createdAt, updatedAt);
  this_._version = 1;
  this_._changelog = StaticList<String>.of([]);
  return this_;
}

int VersionedEntity_get_version<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return this_._version;
}

void VersionedEntity_bump<ID>(dynamic this__, String change) {
  final this_ = this__ as VersionedEntityValue<ID>;
  this_._version = (this_._version + 1);
  this_._changelog.add('v${this_._version}: ${change}');
}

StaticList<String> VersionedEntity_get_changelog<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return StaticList<String>.unmodifiable(this_._changelog);
}

String VersionedEntity_serialize<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return '${this_.id}:${this_.name}:v${this_._version}';
}

StaticList<String> VersionedEntity_validate<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  final StaticList<String> errors = StaticList<String>.of([]);
  if (this_.name.isEmpty)   errors.add('name is empty');
  if ((this_._version < 1))   errors.add('invalid version');
  return errors;
}

String VersionedEntity_get_label<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return '${this_.name}(v${this_._version})';
}

String VersionedEntity_toPrettyString<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Printable_toPrettyString(this_);
}

ID VersionedEntity_get_cacheKey<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Entity_get_cacheKey<ID>(this_);
}

void VersionedEntity_cacheValue<ID>(dynamic this__, dynamic value) {
  final this_ = this__ as VersionedEntityValue<ID>;
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic VersionedEntity_getCachedValue<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Cacheable_getCachedValue<ID>(this_);
}

String VersionedEntity_toString<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Entity_toString<ID>(this_);
}

StaticDuration VersionedEntity_get_age<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return TimestampedEntity_get_age<ID>(this_);
}

String VersionedEntity_toJson<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Serializable_toJson<String>(this_);
}

bool VersionedEntity_get_isValid<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Validatable_get_isValid(this_);
}


class MoneyValue extends Money_Comparable2_PrintableValue {
  late int cents;
  late String currency;
  MoneyValue() {
    vptr['compareTo'] = Money_compareTo;
    vptr['operatorLt'] = Money_operatorLt;
    vptr['operatorGt'] = Money_operatorGt;
    vptr['operatorLte'] = Money_operatorLte;
    vptr['operatorGte'] = Money_operatorGte;
    vptr['get_label'] = Money_get_label;
    vptr['toPrettyString'] = Money_toPrettyString;
    vptr['operatorPlus'] = Money_operatorPlus;
    vptr['operatorMinus'] = Money_operatorMinus;
    vptr['operatorStar'] = Money_operatorStar;
    vptr['operatorNeg'] = Money_operatorNeg;
    vptr['toString'] = Money_toString;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

MoneyValue Money_new(dynamic this__, int cents, [String currency = 'USD']) {
  final this_ = this__ as MoneyValue;
  Comparable2_new<MoneyValue>(this_);
  this_.cents = cents;
  this_.currency = currency;
  return this_;
}

MoneyValue Money_new_fromDollars(dynamic this__, double dollars, [String currency = 'USD']) {
  final this_ = this__ as MoneyValue;
  Comparable2_new<MoneyValue>(this_);
  this_.cents = (dollars * 100).round();
  this_.currency = currency;
  return this_;
}

MoneyValue Money_operatorPlus(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  if (!((this_.currency == other.currency)))   throw DartArgumentError('Currency mismatch');
  return Money_new(GC.allocateLocal(MoneyValue()), (this_.cents + other.cents), this_.currency);
}

MoneyValue Money_operatorMinus(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  if (!((this_.currency == other.currency)))   throw DartArgumentError('Currency mismatch');
  return Money_new(GC.allocateLocal(MoneyValue()), (this_.cents - other.cents), this_.currency);
}

MoneyValue Money_operatorStar(dynamic this__, int factor) {
  final this_ = this__ as MoneyValue;
  return Money_new(GC.allocateLocal(MoneyValue()), (this_.cents * factor), this_.currency);
}

MoneyValue Money_operatorNeg(dynamic this__) {
  final this_ = this__ as MoneyValue;
  return Money_new(GC.allocateLocal(MoneyValue()), (-this_.cents), this_.currency);
}

int Money_compareTo(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return (this_.cents - other.cents);
}

String Money_get_label(dynamic this__) {
  final this_ = this__ as MoneyValue;
  return '\$${(this_.cents / 100).toStringAsFixed(2)} ${this_.currency}';
}

String Money_toString(dynamic this__) {
  final this_ = this__ as MoneyValue;
  return (this_.vptr['get_label'] as String Function(dynamic))(this_);
}

bool Money_operatorLt(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return Comparable2_operatorLt<MoneyValue>(this_, other);
}

bool Money_operatorGt(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return Comparable2_operatorGt<MoneyValue>(this_, other);
}

bool Money_operatorLte(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return Comparable2_operatorLte<MoneyValue>(this_, other);
}

bool Money_operatorGte(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return Comparable2_operatorGte<MoneyValue>(this_, other);
}

String Money_toPrettyString(dynamic this__) {
  final this_ = this__ as MoneyValue;
  return Printable_toPrettyString(this_);
}


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
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_data is AnyGC) (_data as AnyGC).gcMark(flag);
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
  this_._data = (() {   final StaticMap<String, dynamic> _v0 = StaticMap<String, dynamic>.of({});
  for (final p in pairs)   _v0[(p[0] as String)] = p[1];
 return _v0; })();
  return this_;
}

ConfigValue Config_new_withDefaults(StaticMap<String, dynamic> overrides) {
  final StaticMap<String, dynamic> defaults = StaticMap<String, dynamic>.of({'debug': false, 'maxRetries': 3, 'timeout': 30, 'name': 'default'});
  defaults.addAll(overrides);
  return Config_new(GC.allocateLocal(ConfigValue()), defaults);
}

dynamic Config_operatorIndex(dynamic this__, String key) {
  final this_ = this__ as ConfigValue;
  return this_._data[key];
}

void Config_operatorIndexSet(dynamic this__, String key, dynamic value) {
  final this_ = this__ as ConfigValue;
  (() { final _let1 = this_._data; return (() { final _let2 = key; return (() { final _let3 = value; return (() { final _let4 = _let1[_let2] = _let3; return _let3; })(); })(); })(); })();
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
  final StaticList<String> sorted = (StaticList.of(this_._data.keys.toList())..sort());
  final Iterable<String> entries = sorted.map(ClosureEnv_anon_0_new(GC.allocateLocal(ClosureEnv_anon_0()), this_));
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
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_listeners is AnyGC) (_listeners as AnyGC).gcMark(flag);
  }
}

EventBusValue EventBus_new(dynamic this__) {
  final this_ = this__ as EventBusValue;
  this_._listeners = StaticList<TypeFunction1<void, String>>.of([]);
  return this_;
}

void EventBus_on(dynamic this__, TypeFunction1<void, String> listener) {
  final this_ = this__ as EventBusValue;
  this_._listeners.add(listener);
}

void EventBus_emit(dynamic this__, String event) {
  final this_ = this__ as EventBusValue;
  for (final listener in this_._listeners) {
    listener.closureCall(listener, event);
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

void Drawable_draw(dynamic this_) {
  throw UnimplementedError('Drawable.draw is abstract');
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

void Resizable_resize(dynamic this_, double factor) {
  throw UnimplementedError('Resizable.resize is abstract');
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

void Clickable_onClick(dynamic this_) {
  throw UnimplementedError('Clickable.onClick is abstract');
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
}

WidgetValue Widget_new(dynamic this__) {
  final this_ = this__ as WidgetValue;
  this_._state = 'idle';
  this_._scale = 1.0;
  this_._clickCount = 0;
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
  return 'Widget(state=${this_._state}, scale=${this_._scale.toStringAsFixed(1)}, clicks=${this_._clickCount})';
}


class PairValue<A, B> extends VPtr {
  late A first;
  late B second;
  PairValue() {
    vptr['swap'] = Pair_swap<A, B>;
    vptr['toString'] = Pair_toString<A, B>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (first is AnyGC) (first as AnyGC).gcMark(flag);
    if (second is AnyGC) (second as AnyGC).gcMark(flag);
  }
}

PairValue<A, B> Pair_new<A, B>(dynamic this__, A first, B second) {
  final this_ = this__ as PairValue<A, B>;
  this_.vptr['mapFirst_int'] = Pair_mapFirst<A, B, int>;
  this_.vptr['mapSecond_String'] = Pair_mapSecond<A, B, String>;
  this_.vptr['fold_String'] = Pair_fold<A, B, String>;
  this_.first = first;
  this_.second = second;
  return this_;
}

PairValue<B, A> Pair_swap<A, B>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<B, A>(GC.allocateLocal(PairValue<B, A>()), this_.second, this_.first);
}

PairValue<C, B> Pair_mapFirst<A, B, C>(dynamic this__, TypeFunction1<C, A> transform) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<C, B>(GC.allocateLocal(PairValue<C, B>()), transform.closureCall(transform, this_.first), this_.second);
}

PairValue<A, C> Pair_mapSecond<A, B, C>(dynamic this__, TypeFunction1<C, B> transform) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<A, C>(GC.allocateLocal(PairValue<A, C>()), this_.first, transform.closureCall(transform, this_.second));
}

R Pair_fold<A, B, R>(dynamic this__, TypeFunction2<R, A, B> combine) {
  final this_ = this__ as PairValue<A, B>;
  return combine.closureCall(combine, this_.first, this_.second);
}

String Pair_toString<A, B>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return 'Pair(${this_.first}, ${this_.second})';
}


class TripleValue<A, B, C> extends PairValue<A, B> {
  late C third;
  TripleValue() {
    vptr['swap'] = Triple_swap<A, B, C>;
    vptr['mapFirst'] = Triple_mapFirst<A, B, C>;
    vptr['mapSecond'] = Triple_mapSecond<A, B, C>;
    vptr['toString'] = Triple_toString<A, B, C>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (third is AnyGC) (third as AnyGC).gcMark(flag);
  }
}

TripleValue<A, B, C> Triple_new<A, B, C>(dynamic this__, A first, B second, C third) {
  final this_ = this__ as TripleValue<A, B, C>;
  Pair_new<A, B>(this_, first, second);
  this_.vptr['fold_String'] = Triple_fold<A, B, C, String>;
  this_.third = third;
  return this_;
}

String Triple_toString<A, B, C>(dynamic this__) {
  final this_ = this__ as TripleValue<A, B, C>;
  return 'Triple(${this_.first}, ${this_.second}, ${this_.third})';
}

PairValue<B, A> Triple_swap<A, B, C>(dynamic this__) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_swap<A, B>(this_);
}

PairValue<C, B> Triple_mapFirst<A, B, C>(dynamic this__, TypeFunction1<C, A> transform) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_mapFirst<A, B, C>(this_, transform);
}

PairValue<A, C> Triple_mapSecond<A, B, C>(dynamic this__, TypeFunction1<C, B> transform) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_mapSecond<A, B, C>(this_, transform);
}

R Triple_fold<A, B, C, R>(dynamic this__, TypeFunction2<R, A, B> combine) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_fold<A, B, R>(this_, combine);
}


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
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_buf is AnyGC) (_buf as AnyGC).gcMark(flag);
  }
}

StringBuilderValue StringBuilder_new(dynamic this__) {
  final this_ = this__ as StringBuilderValue;
  this_._buf = StaticStringBuffer();
  this_._separator = '';
  return this_;
}

StringBuilderValue StringBuilder_withSeparator(dynamic this__, String sep) {
  final this_ = this__ as StringBuilderValue;
  this_._separator = sep;
  return this_;
}

StringBuilderValue StringBuilder_add(dynamic this__, String text) {
  final this_ = this__ as StringBuilderValue;
  if ((this_._buf.isNotEmpty && this_._separator.isNotEmpty)) {
    this_._buf.write(this_._separator);
  }
  this_._buf.write(text);
  return this_;
}

StringBuilderValue StringBuilder_addAll(dynamic this__, StaticList<String> texts) {
  final this_ = this__ as StringBuilderValue;
  for (final t in texts) {
    (this_.vptr['add'] as StringBuilderValue Function(dynamic, String))(this_, t);
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
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (cause is AnyGC) (cause as AnyGC).gcMark(flag);
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
  final StaticList<String> chain = StaticList<String>.of([]);
  AppErrorValue? current = this_;
  while (!((current == null))) {
    chain.add('${current.code}:${current.message}');
    current = current.cause;
  }
  return chain.join(' -> ');
}


class DataPipelineValue<T> extends VPtr {
  late StaticList<T> _data;
  DataPipelineValue() {
    vptr['where'] = DataPipeline_where<T>;
    vptr['sorted'] = DataPipeline_sorted<T>;
    vptr['take'] = DataPipeline_take<T>;
    vptr['toList'] = DataPipeline_toList<T>;
    vptr['toString'] = DataPipeline_toString<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_data is AnyGC) (_data as AnyGC).gcMark(flag);
  }
}

DataPipelineValue<T> DataPipeline_new<T>(dynamic this__, StaticList<T> _data) {
  final this_ = this__ as DataPipelineValue<T>;
  this_.vptr['map_int'] = DataPipeline_map<T, int>;
  this_.vptr['fold_int'] = DataPipeline_fold<T, int>;
  this_._data = _data;
  return this_;
}

DataPipelineValue<T> DataPipeline_where<T>(dynamic this__, TypeFunction1<bool, T> test) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<T>(GC.allocateLocal(DataPipelineValue<T>()), StaticList.of(this_._data.where(test).toList()));
}

DataPipelineValue<R> DataPipeline_map<T, R>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<R>(GC.allocateLocal(DataPipelineValue<R>()), StaticList.of(this_._data.map(transform).toList()));
}

DataPipelineValue<T> DataPipeline_sorted<T>(dynamic this__, TypeFunction2<int, T, T> compare) {
  final this_ = this__ as DataPipelineValue<T>;
  final StaticList<T> copy = StaticList<T>.of(this_._data);
  copy.sort(compare);
  return DataPipeline_new<T>(GC.allocateLocal(DataPipelineValue<T>()), copy);
}

DataPipelineValue<T> DataPipeline_take<T>(dynamic this__, int count) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<T>(GC.allocateLocal(DataPipelineValue<T>()), StaticList.of(this_._data.take(count).toList()));
}

R DataPipeline_fold<T, R>(dynamic this__, R initial, TypeFunction2<R, R, T> combine) {
  final this_ = this__ as DataPipelineValue<T>;
  return this_._data.fold(initial, combine);
}

StaticList<T> DataPipeline_toList<T>(dynamic this__) {
  final this_ = this__ as DataPipelineValue<T>;
  return StaticList<T>.unmodifiable(this_._data);
}

String DataPipeline_toString<T>(dynamic this__) {
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
  if ((this_._value < this_._min))   this_._value = this_._min;
  if ((this_._value > this_._max))   this_._value = this_._max;
}

BoundedValueValue BoundedValue_operatorPlus(dynamic this__, double delta) {
  final this_ = this__ as BoundedValueValue;
  return BoundedValue_new(GC.allocateLocal(BoundedValueValue()), (this_._value + delta), this_._min, this_._max);
}

String BoundedValue_toString(dynamic this__) {
  final this_ = this__ as BoundedValueValue;
  return 'BoundedValue(${this_._value}, min=${this_._min}, max=${this_._max})';
}


class MathUtilsValue extends VPtr {
}

const double MathUtils_pi = 3.14159265358979;
int MathUtils__callCount = 0;
MathUtilsValue MathUtils_new(dynamic this__) {
  final this_ = this__ as MathUtilsValue;
  return this_;
}

int MathUtils_callCount() {
  return MathUtils__callCount;
}

int MathUtils_factorial(int n) {
  MathUtils__callCount = (MathUtils__callCount + 1);
  if ((n <= 1))   return 1;
  return (n * MathUtils_factorial((n - 1)));
}

StaticList<int> MathUtils_fibonacci(int count) {
  MathUtils__callCount = (MathUtils__callCount + 1);
  if ((count <= 0))   return StaticList<int>.of([]);
  if ((count == 1))   return StaticList<int>.of([0]);
  final StaticList<int> fibs = StaticList<int>.of([0, 1]);
  for (var i = 2; (i < count); i = (i + 1)) {
    fibs.add((fibs[(i - 1)] + fibs[(i - 2)]));
  }
  return fibs;
}

double MathUtils_lerp(double a, double b, double t) {
  MathUtils__callCount = (MathUtils__callCount + 1);
  return (a + ((b - a) * t));
}


// mixin Loggable → static functions for delegation
void Loggable_log(dynamic this__, String message) {
  final this_ = this__;
  this_._logs.add(message);
}

StaticList<String> Loggable_get_logs(dynamic this__) {
  final this_ = this__;
  return StaticList<String>.unmodifiable(this_._logs);
}


// mixin Observable → static functions for delegation
void Observable_observe<T>(dynamic this__, TypeFunction1<void, T> callback) {
  final this_ = this__;
  this_._observers.add(callback);
}

void Observable_notify<T>(dynamic this__, T value) {
  final this_ = this__;
  for (final cb in this_._observers) {
    cb.closureCall(cb, value);
  }
}


class ReactiveStoreValue<V> extends ReactiveStore_Object_Loggable_ObservableValue<V> {
  late StaticMap<String, V> _store;
  ReactiveStoreValue() {
    vptr['log'] = ReactiveStore_log<V>;
    vptr['get_logs'] = ReactiveStore_get_logs<V>;
    vptr['observe'] = ReactiveStore_observe<V>;
    vptr['notify'] = ReactiveStore_notify<V>;
    vptr['get'] = ReactiveStore_get<V>;
    vptr['set'] = ReactiveStore_set<V>;
    vptr['get_size'] = ReactiveStore_get_size<V>;
    vptr['toString'] = ReactiveStore_toString<V>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_store is AnyGC) (_store as AnyGC).gcMark(flag);
  }
}

ReactiveStoreValue<V> ReactiveStore_new<V>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  this_._logs = StaticList<String>.of([]);
  this_._observers = StaticList<TypeFunction1<void, V>>.of([]);
  this_._store = StaticMap<String, V>.of({});
  return this_;
}

V? ReactiveStore_get<V>(dynamic this__, String key) {
  final this_ = this__ as ReactiveStoreValue<V>;
  (this_.vptr['log'] as void Function(dynamic, String))(this_, 'get: ${key}');
  return this_._store[key];
}

void ReactiveStore_set<V>(dynamic this__, String key, V value) {
  final this_ = this__ as ReactiveStoreValue<V>;
  (this_.vptr['log'] as void Function(dynamic, String))(this_, 'set: ${key}=${value}');
  this_._store[key] = value;
  (this_.vptr['notify'] as void Function(dynamic, V))(this_, value);
}

int ReactiveStore_get_size<V>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return this_._store.length;
}

String ReactiveStore_toString<V>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return 'Store(${this_._store})';
}

void ReactiveStore_log<V>(dynamic this__, String message) {
  final this_ = this__ as ReactiveStoreValue<V>;
  Loggable_log(this_, message);
}

StaticList<String> ReactiveStore_get_logs<V>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return Loggable_get_logs(this_);
}

void ReactiveStore_observe<V>(dynamic this__, TypeFunction1<void, V> callback) {
  final this_ = this__ as ReactiveStoreValue<V>;
  Observable_observe<V>(this_, callback);
}

void ReactiveStore_notify<V>(dynamic this__, V value) {
  final this_ = this__ as ReactiveStoreValue<V>;
  Observable_notify<V>(this_, value);
}


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

double Shape_area(dynamic this_) {
  throw UnimplementedError('Shape.area is abstract');
}

String Shape_get_shapeName(dynamic this_) {
  throw UnimplementedError('Shape.shapeName is abstract');
}


class CircleValue extends VPtr implements ShapeValue {
  late double radius;
  CircleValue() {
    vptr['area'] = Circle_area;
    vptr['get_shapeName'] = Circle_get_shapeName;
    vptr['toString'] = Circle_toString;
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


class NodeValue<T> extends VPtr {
  late T value;
  late StaticList<NodeValue<T>> children;
  NodeValue() {
    vptr['addChild'] = Node_addChild<T>;
    vptr['flatten'] = Node_flatten<T>;
    vptr['toString'] = Node_toString<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (value is AnyGC) (value as AnyGC).gcMark(flag);
    if (children is AnyGC) (children as AnyGC).gcMark(flag);
  }
}

NodeValue<T> Node_new<T>(dynamic this__, T value, [StaticList<NodeValue<T>>? children = null]) {
  final this_ = this__ as NodeValue<T>;
  this_.vptr['mapTree_String'] = Node_mapTree<T, String>;
  this_.value = value;
  this_.children = (children ?? StaticList<NodeValue<T>>.of([]));
  return this_;
}

void Node_addChild<T>(dynamic this__, NodeValue<T> child) {
  final this_ = this__ as NodeValue<T>;
  this_.children.add(child);
}

StaticList<T> Node_flatten<T>(dynamic this__) {
  final this_ = this__ as NodeValue<T>;
  final StaticList<T> result = StaticList<T>.of([this_.value]);
  for (final child in this_.children) {
    result.addAll((child.vptr['flatten'] as StaticList<T> Function(dynamic))(child));
  }
  return result;
}

NodeValue<R> Node_mapTree<T, R>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as NodeValue<T>;
  return Node_new<R>(GC.allocateLocal(NodeValue<R>()), transform.closureCall(transform, this_.value), StaticList.of(this_.children.map(ClosureEnv_anon_1_new<R, T>(GC.allocateLocal(ClosureEnv_anon_1<R, T>()), transform)).toList()));
}

String Node_toString<T>(dynamic this__) {
  final this_ = this__ as NodeValue<T>;
  if (this_.children.isEmpty)   return '${this_.value}';
  return '${this_.value}(${this_.children.join(', ')})';
}


class LabeledNodeValue<T> extends LabeledNode_Node_PrintableValue<T> {
  late String nodeLabel;
  LabeledNodeValue() {
    vptr['addChild'] = LabeledNode_addChild<T>;
    vptr['flatten'] = LabeledNode_flatten<T>;
    vptr['toString'] = LabeledNode_toString<T>;
    vptr['get_label'] = LabeledNode_get_label<T>;
    vptr['toPrettyString'] = LabeledNode_toPrettyString<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

LabeledNodeValue<T> LabeledNode_new<T>(dynamic this__, String nodeLabel, T value, [StaticList<NodeValue<T>>? children = null]) {
  final this_ = this__ as LabeledNodeValue<T>;
  Node_new<T>(this_, value, children);
  this_.vptr['mapTree_String'] = LabeledNode_mapTree<T, String>;
  this_.nodeLabel = nodeLabel;
  return this_;
}

String LabeledNode_get_label<T>(dynamic this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return '${this_.nodeLabel}:${this_.value}';
}

String LabeledNode_toString<T>(dynamic this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return '[${this_.nodeLabel}]${this_.value}';
}

void LabeledNode_addChild<T>(dynamic this__, NodeValue<T> child) {
  final this_ = this__ as LabeledNodeValue<T>;
  Node_addChild<T>(this_, child);
}

StaticList<T> LabeledNode_flatten<T>(dynamic this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Node_flatten<T>(this_);
}

NodeValue<R> LabeledNode_mapTree<T, R>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Node_mapTree<T, R>(this_, transform);
}

String LabeledNode_toPrettyString<T>(dynamic this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Printable_toPrettyString(this_);
}


class Entity_Object_PrintableValue extends VPtr {
  Entity_Object_PrintableValue() {
    vptr['toPrettyString'] = Printable_toPrettyString;
  }
}


class Entity_Object_Printable_CacheableValue<ID> extends Entity_Object_PrintableValue {
  Entity_Object_Printable_CacheableValue() {
    vptr['cacheValue'] = Cacheable_cacheValue<ID>;
    vptr['getCachedValue'] = Cacheable_getCachedValue<ID>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class VersionedEntity_TimestampedEntity_SerializableValue<ID> extends TimestampedEntityValue<ID> {
  VersionedEntity_TimestampedEntity_SerializableValue() {
    vptr['toJson'] = Serializable_toJson<String>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> extends VersionedEntity_TimestampedEntity_SerializableValue<ID> {
  VersionedEntity_TimestampedEntity_Serializable_ValidatableValue() {
    vptr['get_isValid'] = Validatable_get_isValid;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Money_Comparable2_PrintableValue extends Comparable2Value<MoneyValue> {
  Money_Comparable2_PrintableValue() {
    vptr['toPrettyString'] = Printable_toPrettyString;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class ReactiveStore_Object_LoggableValue extends VPtr {
  late StaticList<String> _logs;
  ReactiveStore_Object_LoggableValue() {
    vptr['log'] = Loggable_log;
    vptr['get_logs'] = Loggable_get_logs;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_logs is AnyGC) (_logs as AnyGC).gcMark(flag);
  }
}


class ReactiveStore_Object_Loggable_ObservableValue<V> extends ReactiveStore_Object_LoggableValue {
  late StaticList<TypeFunction1<void, V>> _observers;
  ReactiveStore_Object_Loggable_ObservableValue() {
    vptr['observe'] = Observable_observe<V>;
    vptr['notify'] = Observable_notify<V>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_observers is AnyGC) (_observers as AnyGC).gcMark(flag);
  }
}


class LabeledNode_Node_PrintableValue<T> extends NodeValue<T> {
  LabeledNode_Node_PrintableValue() {
    vptr['toPrettyString'] = Printable_toPrettyString;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


T applyTransform<T>(T value, TypeFunction1<T, T> transform) {
  return transform.closureCall(transform, value);
}

StaticList<T> filterWith<T>(StaticList<T> items, TypeFunction1<bool, T> predicate) {
  final StaticList<T> result = StaticList<T>.of([]);
  for (final item in items) {
    if (predicate.closureCall(predicate, item))     result.add(item);
  }
  return result;
}

T reduceList<T>(StaticList<T> items, TypeFunction2<T, T, T> reducer) {
  T acc = items.first;
  for (var i = 1; (i < items.length); i = (i + 1)) {
    acc = reducer.closureCall(reducer, acc, items[i]);
  }
  return acc;
}

StaticList<String> testClosureBoxing() {
  final StaticList<String> log = StaticList<String>.of([]);
  IntBox counter = IntBox(0);
  final TypeFunction0<int> increment = ClosureEnv_testClosureBoxing_2_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_2()), counter);
  increment.closureCall(increment);
  increment.closureCall(increment);
  log.add('counter=${counter.value}');
  final StaticList<TypeFunction0<int>> fns = StaticList<TypeFunction0<int>>.of([]);
  for (var i = 0; (i < 3); i = (i + 1)) {
    fns.add(ClosureEnv_testClosureBoxing_3_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_3()), i));
  }
  log.add('fns=${StaticList.of(fns.map(ClosureEnv_testClosureBoxing_4_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_4()))).toList())}');
  IntBox outer = IntBox(0);
  final TypeFunction1<TypeFunction1<int, int>, int> makeAdder = ClosureEnv_testClosureBoxing_5_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_5()), outer);
  final TypeFunction1<int, int> adder = makeAdder.closureCall(makeAdder, 100);
  adder.closureCall(adder, 5);
  adder.closureCall(adder, 10);
  log.add('outer=${outer.value}, adder(0)=${adder.closureCall(adder, 0)}');
  String captureParam(String prefix) {
    int count = 0;
    final TypeFunction0<String> fn = ClosureEnv_testClosureBoxing_7_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_7()), count, prefix);
    fn.closureCall(fn);
    fn.closureCall(fn);
    return fn.closureCall(fn);
  }

  log.add('captureParam=${captureParam('test')}');
  final EventBusValue bus = EventBus_new(GC.allocateLocal(EventBusValue()));
  StaticList<String> received = StaticList<String>.of([]);
  (bus.vptr['on'] as void Function(dynamic, TypeFunction1<void, String>))(bus, ClosureEnv_testClosureBoxing_9_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_9()), received));
  (bus.vptr['emit'] as void Function(dynamic, String))(bus, 'hello');
  (bus.vptr['emit'] as void Function(dynamic, String))(bus, 'world');
  log.add('received=${received}');
  return log;
}

String testExceptionChain() {
  try {
    try {
      throw AppError_new(GC.allocateLocal(AppErrorValue()), 'not found', 'E404');
    }
 catch (e) {
      throw AppError_new(GC.allocateLocal(AppErrorValue()), 'service failed', 'E500', (e as AppErrorValue));
    }
  }
 catch (e) {
    try {
      throw AppError_new(GC.allocateLocal(AppErrorValue()), 'gateway error', 'E502', (e as AppErrorValue));
    }
 catch (e2) {
      return e2.toString();
    }
  }
}

String formatRecord({required String name, int age = 0, String? email = null, bool active = true, Iterable<String> tags = const []}) {
  final StaticList<String> parts = StaticList<String>.of([name]);
  if ((age > 0))   parts.add('age=${age}');
  if (!((email == null)))   parts.add('email=${email}');
  parts.add('active=${active}');
  if (tags.isNotEmpty)   parts.add('tags=${tags}');
  return 'Record(${parts.join(', ')})';
}

String greetAll(String greeting, [String name = 'World', String suffix = '!']) {
  return '${greeting}, ${name}${suffix}';
}

String describeShape(ShapeValue shape) {
  if ((shape is CircleValue)) {
    return '${(shape.vptr['get_shapeName'] as String Function(dynamic))(shape)}: r=${shape.radius}, area=${(shape.vptr['area'] as double Function(dynamic))(shape).toStringAsFixed(2)}';
  }
 else   if ((shape is RectangleValue)) {
    return '${(shape.vptr['get_shapeName'] as String Function(dynamic))(shape)}: ${shape.width}x${shape.height}, area=${(shape.vptr['area'] as double Function(dynamic))(shape).toStringAsFixed(2)}';
  }
  return 'Unknown shape: area=${(shape.vptr['area'] as double Function(dynamic))(shape)}';
}

String evaluateGrade(int score) {
  final String letter = ((score >= 90) ? 'A' : ((score >= 80) ? 'B' : ((score >= 70) ? 'C' : ((score >= 60) ? 'D' : 'F'))));
  late String description;
  do {
    switch (letter) {
      case 'A':
{
          description = 'Excellent';
          break;
        }
      case 'B':
{
          description = 'Good';
          break;
        }
      case 'C':
{
          description = 'Average';
          break;
        }
      case 'D':
{
          description = 'Below Average';
          break;
        }
      default:
{
          description = 'Failing';
        }
    }
  } while (false);
  return '${score} → ${letter} (${description})';
}

void main() {
  staticPrint('--- 1. typedef + Function ---');
  final int doubled = applyTransform<int>(21, ClosureEnv_main_10_new(GC.allocateLocal(ClosureEnv_main_10())));
  staticPrint('applyTransform: ${doubled}');
  final StaticList<int> evens = StaticList<int>.of(filterWith<int>(StaticList<int>.of([1, 2, 3, 4, 5, 6]), ClosureEnv_main_11_new(GC.allocateLocal(ClosureEnv_main_11()))));
  staticPrint('filterWith: ${evens}');
  final int sum = reduceList<int>(StaticList<int>.of([1, 2, 3, 4, 5]), ClosureEnv_main_12_new(GC.allocateLocal(ClosureEnv_main_12())));
  staticPrint('reduceList: ${sum}');
  staticPrint('\n--- 2. 枚举类 ---');
  staticPrint('red hex: ${Color_get_hex(Color.red)}');
  staticPrint('green isWarm: ${Color_get_isWarm(Color.green)}');
  staticPrint('priorities: ${StaticList.of(const [Priority.low, Priority.medium, Priority.high, Priority.critical].map(ClosureEnv_main_13_new(GC.allocateLocal(ClosureEnv_main_13()))).toList())}');
  staticPrint('\n--- 3. 运算符重载 ---');
  final MoneyValue price1 = Money_new(GC.allocateLocal(MoneyValue()), 1099, 'USD');
  final MoneyValue price2 = Money_new_fromDollars(GC.allocateLocal(MoneyValue()), 5.5);
  final MoneyValue total = (price1.vptr['operatorPlus'] as MoneyValue Function(dynamic, MoneyValue))(price1, price2);
  final MoneyValue negated = (price2.vptr['operatorNeg'] as MoneyValue Function(dynamic))(price2);
  staticPrint('price1: ${(price1.vptr['toPrettyString'] as String Function(dynamic))(price1)}');
  staticPrint('price2: ${price2}');
  staticPrint('total: ${total}');
  staticPrint('negated: ${negated}');
  staticPrint('price1 > price2: ${(price1.vptr['operatorGt'] as bool Function(dynamic, MoneyValue))(price1, price2)}');
  staticPrint('price1 < price2: ${(price1.vptr['operatorLt'] as bool Function(dynamic, MoneyValue))(price1, price2)}');
  staticPrint('price1 * 3: ${(price1.vptr['operatorStar'] as MoneyValue Function(dynamic, int))(price1, 3)}');
  staticPrint('\n--- 4. 多层泛型继承 ---');
  final EntityValue<int> entity = Entity_new<int>(GC.allocateLocal(EntityValue<int>()), 1, 'alice');
  staticPrint('entity: ${entity}');
  staticPrint('entity label: ${(entity.vptr['toPrettyString'] as String Function(dynamic))(entity)}');
  (entity.vptr['cacheValue'] as void Function(dynamic, dynamic))(entity, 'cached_data');
  staticPrint('cached: ${(entity.vptr['getCachedValue'] as dynamic Function(dynamic))(entity)}');
  final TimestampedEntityValue<String> tsEntity = TimestampedEntity_new<String>(GC.allocateLocal(TimestampedEntityValue<String>()), 'u1', 'bob', 1000, 2000);
  staticPrint('tsEntity label: ${(tsEntity.vptr['toPrettyString'] as String Function(dynamic))(tsEntity)}');
  final VersionedEntityValue<int> vEntity = VersionedEntity_new<int>(GC.allocateLocal(VersionedEntityValue<int>()), 42, 'project', 1000, 5000);
  (vEntity.vptr['bump'] as void Function(dynamic, String))(vEntity, 'initial release');
  (vEntity.vptr['bump'] as void Function(dynamic, String))(vEntity, 'bug fix');
  staticPrint('vEntity label: ${(vEntity.vptr['toPrettyString'] as String Function(dynamic))(vEntity)}');
  staticPrint('vEntity version: ${(vEntity.vptr['get_version'] as int Function(dynamic))(vEntity)}');
  staticPrint('vEntity changelog: ${(vEntity.vptr['get_changelog'] as StaticList<String> Function(dynamic))(vEntity)}');
  staticPrint('vEntity serialize: ${(vEntity.vptr['serialize'] as String Function(dynamic))(vEntity)}');
  staticPrint('vEntity toJson: ${(vEntity.vptr['toJson'] as String Function(dynamic))(vEntity)}');
  staticPrint('vEntity isValid: ${(vEntity.vptr['get_isValid'] as bool Function(dynamic))(vEntity)}');
  staticPrint('vEntity validate: ${(vEntity.vptr['validate'] as StaticList<String> Function(dynamic))(vEntity)}');
  staticPrint('\n--- 5. 工厂构造 ---');
  final ConfigValue cfg1 = Config_new_empty(GC.allocateLocal(ConfigValue()));
  (cfg1.vptr['operatorIndexSet'] as void Function(dynamic, String, dynamic))(cfg1, 'host', 'localhost');
  staticPrint('cfg1: ${cfg1}');
  final ConfigValue cfg2 = Config_new_fromPairs(GC.allocateLocal(ConfigValue()), StaticList<StaticList<dynamic>>.of([StaticList.of(['a', 1]), StaticList.of(['b', 2])]));
  staticPrint('cfg2: ${cfg2}');
  final ConfigValue cfg3 = Config_new_withDefaults(StaticMap<String, dynamic>.of({'debug': true, 'name': 'prod'}));
  staticPrint('cfg3: ${cfg3}');
  staticPrint('cfg3[maxRetries]: ${(cfg3.vptr['operatorIndex'] as dynamic Function(dynamic, String))(cfg3, 'maxRetries')}');
  staticPrint('\n--- 6. 闭包 Box 化 ---');
  final StaticList<String> closureLog = StaticList<String>.of(testClosureBoxing());
  for (final line in closureLog) {
    staticPrint(line);
  }
  staticPrint('\n--- 7. 多重 implements ---');
  final WidgetValue widget = Widget_new(GC.allocateLocal(WidgetValue()));
  (widget.vptr['draw'] as void Function(dynamic))(widget);
  (widget.vptr['resize'] as void Function(dynamic, double))(widget, 1.5);
  (widget.vptr['onClick'] as void Function(dynamic))(widget);
  (widget.vptr['onClick'] as void Function(dynamic))(widget);
  staticPrint('widget: ${(widget.vptr['get_info'] as String Function(dynamic))(widget)}');
  staticPrint('\n--- 8. 泛型 Pair ---');
  final PairValue<int, String> pair = Pair_new<int, String>(GC.allocateLocal(PairValue<int, String>()), 42, 'hello');
  staticPrint('pair: ${pair}');
  staticPrint('swap: ${(pair.vptr['swap'] as PairValue<String, int> Function(dynamic))(pair)}');
  staticPrint('mapFirst: ${(pair.vptr['mapFirst_int'] as PairValue<int, String> Function(dynamic, TypeFunction1<int, int>))(pair, ClosureEnv_main_15_new(GC.allocateLocal(ClosureEnv_main_15())))}');
  staticPrint('mapSecond: ${(pair.vptr['mapSecond_String'] as PairValue<int, String> Function(dynamic, TypeFunction1<String, String>))(pair, ClosureEnv_main_17_new(GC.allocateLocal(ClosureEnv_main_17())))}');
  staticPrint('fold: ${(pair.vptr['fold_String'] as String Function(dynamic, TypeFunction2<String, int, String>))(pair, ClosureEnv_main_19_new(GC.allocateLocal(ClosureEnv_main_19())))}');
  final TripleValue<int, String, bool> triple = Triple_new<int, String, bool>(GC.allocateLocal(TripleValue<int, String, bool>()), 1, 'yes', true);
  staticPrint('triple: ${triple}');
  staticPrint('\n--- 9. 级联操作 ---');
  final StringBuilderValue sb = (() { final _let7 = StringBuilder_new(GC.allocateLocal(StringBuilderValue())); (_let7.vptr['withSeparator'] as StringBuilderValue Function(dynamic, String))(_let7, ', '); (_let7.vptr['add'] as StringBuilderValue Function(dynamic, String))(_let7, 'alpha'); (_let7.vptr['add'] as StringBuilderValue Function(dynamic, String))(_let7, 'beta'); (_let7.vptr['addAll'] as StringBuilderValue Function(dynamic, StaticList<String>))(_let7, StaticList<String>.of(['gamma', 'delta'])); return _let7; })();
  staticPrint('builder: ${sb}');
  staticPrint('length: ${(sb.vptr['get_length'] as int Function(dynamic))(sb)}');
  staticPrint('\n--- 10. 异常处理链 ---');
  staticPrint('chain: ${testExceptionChain()}');
  staticPrint('\n--- 11. 集合操作 ---');
  final DataPipelineValue<int> pipeline = ((((DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<bool, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21()))).vptr['sorted'] as DataPipelineValue<int> Function(dynamic, TypeFunction2<int, int, int>))((DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<bool, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21()))), ClosureEnv_main_23_new(GC.allocateLocal(ClosureEnv_main_23()))).vptr['take'] as DataPipelineValue<int> Function(dynamic, int))(((DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<bool, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21()))).vptr['sorted'] as DataPipelineValue<int> Function(dynamic, TypeFunction2<int, int, int>))((DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<bool, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21()))), ClosureEnv_main_23_new(GC.allocateLocal(ClosureEnv_main_23()))), 5).vptr['map_int'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<int, int>))((((DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<bool, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21()))).vptr['sorted'] as DataPipelineValue<int> Function(dynamic, TypeFunction2<int, int, int>))((DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<bool, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21()))), ClosureEnv_main_23_new(GC.allocateLocal(ClosureEnv_main_23()))).vptr['take'] as DataPipelineValue<int> Function(dynamic, int))(((DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<bool, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21()))).vptr['sorted'] as DataPipelineValue<int> Function(dynamic, TypeFunction2<int, int, int>))((DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])).vptr['where'] as DataPipelineValue<int> Function(dynamic, TypeFunction1<bool, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21()))), ClosureEnv_main_23_new(GC.allocateLocal(ClosureEnv_main_23()))), 5), ClosureEnv_main_25_new(GC.allocateLocal(ClosureEnv_main_25())));
  staticPrint('pipeline: ${(pipeline.vptr['toList'] as StaticList<int> Function(dynamic))(pipeline)}');
  final int pipeSum = (DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([1, 2, 3, 4, 5])).vptr['fold_int'] as int Function(dynamic, int, TypeFunction2<int, int, int>))(DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([1, 2, 3, 4, 5])), 0, ClosureEnv_main_27_new(GC.allocateLocal(ClosureEnv_main_27())));
  staticPrint('pipeSum: ${pipeSum}');
  staticPrint('\n--- 12. 可选参数 ---');
  staticPrint(formatRecord(name: 'Alice', age: 30, email: 'alice@test.com'));
  staticPrint(formatRecord(name: 'Bob', tags: StaticList<String>.of(['admin', 'vip'])));
  staticPrint(greetAll('Hello'));
  staticPrint(greetAll('Hi', 'Dart', '!!'));
  staticPrint('\n--- 13. BoundedValue ---');
  final BoundedValueValue bv = BoundedValue_new(GC.allocateLocal(BoundedValueValue()), 5.0, 0.0, 10.0);
  staticPrint('bv: ${bv}');
  (bv.vptr['set_value'] as void Function(dynamic, double))(bv, 15.0);
  staticPrint('after set 15: ${bv}');
  (bv.vptr['set_value'] as void Function(dynamic, double))(bv, (-5.0));
  staticPrint('after set -5: ${bv}');
  final BoundedValueValue bv2 = (bv.vptr['operatorPlus'] as BoundedValueValue Function(dynamic, double))(bv, 7.0);
  staticPrint('bv + 7: ${bv2}');
  staticPrint('\n--- 14. 静态方法 ---');
  staticPrint('5! = ${MathUtils_factorial(5)}');
  staticPrint('fib(8): ${MathUtils_fibonacci(8)}');
  staticPrint('lerp(0,100,0.3): ${MathUtils_lerp(0.0, 100.0, 0.3)}');
  staticPrint('callCount: ${MathUtils_callCount()}');
  staticPrint('\n--- 15. ReactiveStore ---');
  final ReactiveStoreValue<int> store = ReactiveStore_new<int>(GC.allocateLocal(ReactiveStoreValue<int>()));
  final StaticList<int> observed = StaticList<int>.of([]);
  (store.vptr['observe'] as void Function(dynamic, TypeFunction1<void, int>))(store, ClosureEnv_main_29_new(GC.allocateLocal(ClosureEnv_main_29()), observed));
  (store.vptr['set'] as void Function(dynamic, String, int))(store, 'x', 10);
  (store.vptr['set'] as void Function(dynamic, String, int))(store, 'y', 20);
  staticPrint('store: ${store}');
  staticPrint('store.get(x): ${(store.vptr['get'] as int? Function(dynamic, String))(store, 'x')}');
  staticPrint('store.size: ${(store.vptr['get_size'] as int Function(dynamic))(store)}');
  staticPrint('observed: ${observed}');
  staticPrint('logs: ${(store.vptr['get_logs'] as StaticList<String> Function(dynamic))(store)}');
  staticPrint('\n--- 16. 类型转换 ---');
  final StaticList<ShapeValue> shapes = StaticList<ShapeValue>.of([Circle_new(GC.allocateLocal(CircleValue()), 5.0), Rectangle_new(GC.allocateLocal(RectangleValue()), 3.0, 4.0), Circle_new(GC.allocateLocal(CircleValue()), 1.0)]);
  for (final s in shapes) {
    staticPrint(describeShape(s));
  }
  staticPrint('\n--- 17. 树结构 ---');
  final NodeValue<int> tree = Node_new<int>(GC.allocateLocal(NodeValue<int>()), 1, StaticList<NodeValue<int>>.of([Node_new<int>(GC.allocateLocal(NodeValue<int>()), 2, StaticList<NodeValue<int>>.of([Node_new<int>(GC.allocateLocal(NodeValue<int>()), 4), Node_new<int>(GC.allocateLocal(NodeValue<int>()), 5)])), Node_new<int>(GC.allocateLocal(NodeValue<int>()), 3, StaticList<NodeValue<int>>.of([Node_new<int>(GC.allocateLocal(NodeValue<int>()), 6)]))]));
  staticPrint('tree: ${tree}');
  staticPrint('flatten: ${(tree.vptr['flatten'] as StaticList<int> Function(dynamic))(tree)}');
  final NodeValue<String> strTree = (tree.vptr['mapTree_String'] as NodeValue<String> Function(dynamic, TypeFunction1<String, int>))(tree, ClosureEnv_main_31_new(GC.allocateLocal(ClosureEnv_main_31())));
  staticPrint('mapped: ${strTree}');
  final LabeledNodeValue<int> labeled = LabeledNode_new<int>(GC.allocateLocal(LabeledNodeValue<int>()), 'root', 100);
  (labeled.vptr['addChild'] as void Function(dynamic, NodeValue<int>))(labeled, Node_new<int>(GC.allocateLocal(NodeValue<int>()), 200));
  (labeled.vptr['addChild'] as void Function(dynamic, NodeValue<int>))(labeled, Node_new<int>(GC.allocateLocal(NodeValue<int>()), 300));
  staticPrint('labeled: ${labeled}');
  staticPrint('labeled pretty: ${(labeled.vptr['toPrettyString'] as String Function(dynamic))(labeled)}');
  staticPrint('labeled flatten: ${(labeled.vptr['flatten'] as StaticList<int> Function(dynamic))(labeled)}');
  staticPrint('\n--- 18. 评分 ---');
  staticPrint(evaluateGrade(95));
  staticPrint(evaluateGrade(82));
  staticPrint(evaluateGrade(67));
  staticPrint(evaluateGrade(55));
  staticPrint('\n=== 所有压力测试通过 ✅ ===');
}

class ClosureEnv_anon_0 extends TypeFunction1<String, String> {
  late ConfigValue this_;
  ClosureEnv_anon_0();
  @override
  String call(String k) => closureCall(this, k);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_0 ClosureEnv_anon_0_new(ClosureEnv_anon_0 env_, ConfigValue this_) {
  env_.closureCall = ClosureEnv_anon_0_call;
  env_.this_ = this_;
  return env_;
}
String ClosureEnv_anon_0_call(dynamic env__, String k) {
  final env = env__ as ClosureEnv_anon_0;

  return '${k}=${env.this_._data[k]}';
}

class ClosureEnv_anon_1<R, T> extends TypeFunction1<NodeValue<R>, NodeValue<T>> {
  late TypeFunction1<R, T> transform;
  ClosureEnv_anon_1();
  @override
  NodeValue<R> call(NodeValue<T> c) => closureCall(this, c);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (transform is AnyGC) (transform as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_1<R, T> ClosureEnv_anon_1_new<R, T>(ClosureEnv_anon_1<R, T> env_, TypeFunction1<R, T> transform) {
  env_.closureCall = ClosureEnv_anon_1_call<R, T>;
  env_.transform = transform;
  return env_;
}
NodeValue<R> ClosureEnv_anon_1_call<R, T>(dynamic env__, NodeValue<T> c) {
  final env = env__ as ClosureEnv_anon_1<R, T>;

  return Node_mapTree<T, R>(c, env.transform);
}

class ClosureEnv_testClosureBoxing_2 extends TypeFunction0<int> {
  late IntBox counter;
  ClosureEnv_testClosureBoxing_2();
  @override
  int call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (counter is AnyGC) (counter as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_2 ClosureEnv_testClosureBoxing_2_new(ClosureEnv_testClosureBoxing_2 env_, IntBox counter) {
  env_.closureCall = ClosureEnv_testClosureBoxing_2_call;
  env_.counter = counter;
  return env_;
}
int ClosureEnv_testClosureBoxing_2_call(dynamic env__) {
  final env = env__ as ClosureEnv_testClosureBoxing_2;

    env.counter.value = (env.counter.value + 1);
    return env.counter.value;
  }

class ClosureEnv_testClosureBoxing_3 extends TypeFunction0<int> {
  late int i;
  ClosureEnv_testClosureBoxing_3();
  @override
  int call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (i is AnyGC) (i as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_3 ClosureEnv_testClosureBoxing_3_new(ClosureEnv_testClosureBoxing_3 env_, int i) {
  env_.closureCall = ClosureEnv_testClosureBoxing_3_call;
  env_.i = i;
  return env_;
}
int ClosureEnv_testClosureBoxing_3_call(dynamic env__) {
  final env = env__ as ClosureEnv_testClosureBoxing_3;

  return (env.i * 10);
}

class ClosureEnv_testClosureBoxing_4 extends TypeFunction1<int, TypeFunction0<int>> {
  ClosureEnv_testClosureBoxing_4();
  @override
  int call(TypeFunction0<int> f) => closureCall(this, f);
}
ClosureEnv_testClosureBoxing_4 ClosureEnv_testClosureBoxing_4_new(ClosureEnv_testClosureBoxing_4 env_) {
  env_.closureCall = ClosureEnv_testClosureBoxing_4_call;
  return env_;
}
int ClosureEnv_testClosureBoxing_4_call(dynamic env__, TypeFunction0<int> f) {
  final env = env__ as ClosureEnv_testClosureBoxing_4;

  return f.closureCall(f);
}

class ClosureEnv_ClosureEnv_testClosureBoxing_5_6 extends TypeFunction1<int, int> {
  late IntBox inner;
  late IntBox outer;
  ClosureEnv_ClosureEnv_testClosureBoxing_5_6();
  @override
  int call(int x) => closureCall(this, x);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (inner is AnyGC) (inner as AnyGC).gcMark(flag);
    if (outer is AnyGC) (outer as AnyGC).gcMark(flag);
  }
}
ClosureEnv_ClosureEnv_testClosureBoxing_5_6 ClosureEnv_ClosureEnv_testClosureBoxing_5_6_new(ClosureEnv_ClosureEnv_testClosureBoxing_5_6 env_, IntBox inner, IntBox outer) {
  env_.closureCall = ClosureEnv_ClosureEnv_testClosureBoxing_5_6_call;
  env_.inner = inner;
  env_.outer = outer;
  return env_;
}
int ClosureEnv_ClosureEnv_testClosureBoxing_5_6_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_ClosureEnv_testClosureBoxing_5_6;

      env.inner.value = (env.inner.value + x);
      env.outer.value = (env.outer.value + x);
      return env.inner.value;
    }

class ClosureEnv_testClosureBoxing_5 extends TypeFunction1<TypeFunction1<int, int>, int> {
  late IntBox outer;
  ClosureEnv_testClosureBoxing_5();
  @override
  TypeFunction1<int, int> call(int base) => closureCall(this, base);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (outer is AnyGC) (outer as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_5 ClosureEnv_testClosureBoxing_5_new(ClosureEnv_testClosureBoxing_5 env_, IntBox outer) {
  env_.closureCall = ClosureEnv_testClosureBoxing_5_call;
  env_.outer = outer;
  return env_;
}
TypeFunction1<int, int> ClosureEnv_testClosureBoxing_5_call(dynamic env__, int base) {
  final env = env__ as ClosureEnv_testClosureBoxing_5;

    IntBox inner = IntBox(base);
    return ClosureEnv_ClosureEnv_testClosureBoxing_5_6_new(GC.allocateLocal(ClosureEnv_ClosureEnv_testClosureBoxing_5_6()), inner, env.outer);
  }

class ClosureEnv_testClosureBoxing_7 extends TypeFunction0<String> {
  late int count;
  late String prefix;
  ClosureEnv_testClosureBoxing_7();
  @override
  String call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (count is AnyGC) (count as AnyGC).gcMark(flag);
    if (prefix is AnyGC) (prefix as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_7 ClosureEnv_testClosureBoxing_7_new(ClosureEnv_testClosureBoxing_7 env_, int count, String prefix) {
  env_.closureCall = ClosureEnv_testClosureBoxing_7_call;
  env_.count = count;
  env_.prefix = prefix;
  return env_;
}
String ClosureEnv_testClosureBoxing_7_call(dynamic env__) {
  final env = env__ as ClosureEnv_testClosureBoxing_7;

      env.count = (env.count + 1);
      return '${env.prefix}-${env.count}';
    }

class ClosureEnv_testClosureBoxing_8 extends TypeFunction1<void, String> {
  late StaticList<String> received;
  ClosureEnv_testClosureBoxing_8();
  @override
  void call(String event) => closureCall(this, event);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (received is AnyGC) (received as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_8 ClosureEnv_testClosureBoxing_8_new(ClosureEnv_testClosureBoxing_8 env_, StaticList<String> received) {
  env_.closureCall = ClosureEnv_testClosureBoxing_8_call;
  env_.received = received;
  return env_;
}
void ClosureEnv_testClosureBoxing_8_call(dynamic env__, String event) {
  final env = env__ as ClosureEnv_testClosureBoxing_8;

    env.received.add(event);
  }

class ClosureEnv_testClosureBoxing_9 extends TypeFunction1<void, String> {
  late StaticList<String> received;
  ClosureEnv_testClosureBoxing_9();
  @override
  void call(String event) => closureCall(this, event);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (received is AnyGC) (received as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_9 ClosureEnv_testClosureBoxing_9_new(ClosureEnv_testClosureBoxing_9 env_, StaticList<String> received) {
  env_.closureCall = ClosureEnv_testClosureBoxing_9_call;
  env_.received = received;
  return env_;
}
void ClosureEnv_testClosureBoxing_9_call(dynamic env__, String event) {
  final env = env__ as ClosureEnv_testClosureBoxing_9;

    env.received.add(event);
  }

class ClosureEnv_main_10 extends TypeFunction1<int, int> {
  ClosureEnv_main_10();
  @override
  int call(int x) => closureCall(this, x);
}
ClosureEnv_main_10 ClosureEnv_main_10_new(ClosureEnv_main_10 env_) {
  env_.closureCall = ClosureEnv_main_10_call;
  return env_;
}
int ClosureEnv_main_10_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_10;

  return (x * 2);
}

class ClosureEnv_main_11 extends TypeFunction1<bool, int> {
  ClosureEnv_main_11();
  @override
  bool call(int x) => closureCall(this, x);
}
ClosureEnv_main_11 ClosureEnv_main_11_new(ClosureEnv_main_11 env_) {
  env_.closureCall = ClosureEnv_main_11_call;
  return env_;
}
bool ClosureEnv_main_11_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_11;

  return ((x % 2) == 0);
}

class ClosureEnv_main_12 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_12();
  @override
  int call(int a, int b) => closureCall(this, a, b);
}
ClosureEnv_main_12 ClosureEnv_main_12_new(ClosureEnv_main_12 env_) {
  env_.closureCall = ClosureEnv_main_12_call;
  return env_;
}
int ClosureEnv_main_12_call(dynamic env__, int a, int b) {
  final env = env__ as ClosureEnv_main_12;

  return (a + b);
}

class ClosureEnv_main_13 extends TypeFunction1<String, Priority> {
  ClosureEnv_main_13();
  @override
  String call(Priority p) => closureCall(this, p);
}
ClosureEnv_main_13 ClosureEnv_main_13_new(ClosureEnv_main_13 env_) {
  env_.closureCall = ClosureEnv_main_13_call;
  return env_;
}
String ClosureEnv_main_13_call(dynamic env__, Priority p) {
  final env = env__ as ClosureEnv_main_13;

  return '${p}'.split('.').last;
}

class ClosureEnv_main_14 extends TypeFunction1<int, int> {
  ClosureEnv_main_14();
  @override
  int call(int x) => closureCall(this, x);
}
ClosureEnv_main_14 ClosureEnv_main_14_new(ClosureEnv_main_14 env_) {
  env_.closureCall = ClosureEnv_main_14_call;
  return env_;
}
int ClosureEnv_main_14_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_14;

  return (x * 2);
}

class ClosureEnv_main_15 extends TypeFunction1<int, int> {
  ClosureEnv_main_15();
  @override
  int call(int x) => closureCall(this, x);
}
ClosureEnv_main_15 ClosureEnv_main_15_new(ClosureEnv_main_15 env_) {
  env_.closureCall = ClosureEnv_main_15_call;
  return env_;
}
int ClosureEnv_main_15_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_15;

  return (x * 2);
}

class ClosureEnv_main_16 extends TypeFunction1<String, String> {
  ClosureEnv_main_16();
  @override
  String call(String s) => closureCall(this, s);
}
ClosureEnv_main_16 ClosureEnv_main_16_new(ClosureEnv_main_16 env_) {
  env_.closureCall = ClosureEnv_main_16_call;
  return env_;
}
String ClosureEnv_main_16_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_16;

  return s.toUpperCase();
}

class ClosureEnv_main_17 extends TypeFunction1<String, String> {
  ClosureEnv_main_17();
  @override
  String call(String s) => closureCall(this, s);
}
ClosureEnv_main_17 ClosureEnv_main_17_new(ClosureEnv_main_17 env_) {
  env_.closureCall = ClosureEnv_main_17_call;
  return env_;
}
String ClosureEnv_main_17_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_17;

  return s.toUpperCase();
}

class ClosureEnv_main_18 extends TypeFunction2<String, int, String> {
  ClosureEnv_main_18();
  @override
  String call(int a, String b) => closureCall(this, a, b);
}
ClosureEnv_main_18 ClosureEnv_main_18_new(ClosureEnv_main_18 env_) {
  env_.closureCall = ClosureEnv_main_18_call;
  return env_;
}
String ClosureEnv_main_18_call(dynamic env__, int a, String b) {
  final env = env__ as ClosureEnv_main_18;

  return '${b}=${a}';
}

class ClosureEnv_main_19 extends TypeFunction2<String, int, String> {
  ClosureEnv_main_19();
  @override
  String call(int a, String b) => closureCall(this, a, b);
}
ClosureEnv_main_19 ClosureEnv_main_19_new(ClosureEnv_main_19 env_) {
  env_.closureCall = ClosureEnv_main_19_call;
  return env_;
}
String ClosureEnv_main_19_call(dynamic env__, int a, String b) {
  final env = env__ as ClosureEnv_main_19;

  return '${b}=${a}';
}

class ClosureEnv_main_20 extends TypeFunction1<bool, int> {
  ClosureEnv_main_20();
  @override
  bool call(int x) => closureCall(this, x);
}
ClosureEnv_main_20 ClosureEnv_main_20_new(ClosureEnv_main_20 env_) {
  env_.closureCall = ClosureEnv_main_20_call;
  return env_;
}
bool ClosureEnv_main_20_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_20;

  return (x > 2);
}

class ClosureEnv_main_21 extends TypeFunction1<bool, int> {
  ClosureEnv_main_21();
  @override
  bool call(int x) => closureCall(this, x);
}
ClosureEnv_main_21 ClosureEnv_main_21_new(ClosureEnv_main_21 env_) {
  env_.closureCall = ClosureEnv_main_21_call;
  return env_;
}
bool ClosureEnv_main_21_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_21;

  return (x > 2);
}

class ClosureEnv_main_22 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_22();
  @override
  int call(int a, int b) => closureCall(this, a, b);
}
ClosureEnv_main_22 ClosureEnv_main_22_new(ClosureEnv_main_22 env_) {
  env_.closureCall = ClosureEnv_main_22_call;
  return env_;
}
int ClosureEnv_main_22_call(dynamic env__, int a, int b) {
  final env = env__ as ClosureEnv_main_22;

  return (a - b);
}

class ClosureEnv_main_23 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_23();
  @override
  int call(int a, int b) => closureCall(this, a, b);
}
ClosureEnv_main_23 ClosureEnv_main_23_new(ClosureEnv_main_23 env_) {
  env_.closureCall = ClosureEnv_main_23_call;
  return env_;
}
int ClosureEnv_main_23_call(dynamic env__, int a, int b) {
  final env = env__ as ClosureEnv_main_23;

  return (a - b);
}

class ClosureEnv_main_24 extends TypeFunction1<int, int> {
  ClosureEnv_main_24();
  @override
  int call(int x) => closureCall(this, x);
}
ClosureEnv_main_24 ClosureEnv_main_24_new(ClosureEnv_main_24 env_) {
  env_.closureCall = ClosureEnv_main_24_call;
  return env_;
}
int ClosureEnv_main_24_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_24;

  return (x * 10);
}

class ClosureEnv_main_25 extends TypeFunction1<int, int> {
  ClosureEnv_main_25();
  @override
  int call(int x) => closureCall(this, x);
}
ClosureEnv_main_25 ClosureEnv_main_25_new(ClosureEnv_main_25 env_) {
  env_.closureCall = ClosureEnv_main_25_call;
  return env_;
}
int ClosureEnv_main_25_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_25;

  return (x * 10);
}

class ClosureEnv_main_26 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_26();
  @override
  int call(int acc, int x) => closureCall(this, acc, x);
}
ClosureEnv_main_26 ClosureEnv_main_26_new(ClosureEnv_main_26 env_) {
  env_.closureCall = ClosureEnv_main_26_call;
  return env_;
}
int ClosureEnv_main_26_call(dynamic env__, int acc, int x) {
  final env = env__ as ClosureEnv_main_26;

  return (acc + x);
}

class ClosureEnv_main_27 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_27();
  @override
  int call(int acc, int x) => closureCall(this, acc, x);
}
ClosureEnv_main_27 ClosureEnv_main_27_new(ClosureEnv_main_27 env_) {
  env_.closureCall = ClosureEnv_main_27_call;
  return env_;
}
int ClosureEnv_main_27_call(dynamic env__, int acc, int x) {
  final env = env__ as ClosureEnv_main_27;

  return (acc + x);
}

class ClosureEnv_main_28 extends TypeFunction1<void, int> {
  late StaticList<int> observed;
  ClosureEnv_main_28();
  @override
  void call(int v) => closureCall(this, v);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (observed is AnyGC) (observed as AnyGC).gcMark(flag);
  }
}
ClosureEnv_main_28 ClosureEnv_main_28_new(ClosureEnv_main_28 env_, StaticList<int> observed) {
  env_.closureCall = ClosureEnv_main_28_call;
  env_.observed = observed;
  return env_;
}
void ClosureEnv_main_28_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_main_28;

    env.observed.add(v);
  }

class ClosureEnv_main_29 extends TypeFunction1<void, int> {
  late StaticList<int> observed;
  ClosureEnv_main_29();
  @override
  void call(int v) => closureCall(this, v);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (observed is AnyGC) (observed as AnyGC).gcMark(flag);
  }
}
ClosureEnv_main_29 ClosureEnv_main_29_new(ClosureEnv_main_29 env_, StaticList<int> observed) {
  env_.closureCall = ClosureEnv_main_29_call;
  env_.observed = observed;
  return env_;
}
void ClosureEnv_main_29_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_main_29;

    env.observed.add(v);
  }

class ClosureEnv_main_30 extends TypeFunction1<String, int> {
  ClosureEnv_main_30();
  @override
  String call(int x) => closureCall(this, x);
}
ClosureEnv_main_30 ClosureEnv_main_30_new(ClosureEnv_main_30 env_) {
  env_.closureCall = ClosureEnv_main_30_call;
  return env_;
}
String ClosureEnv_main_30_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_30;

  return 'N${x}';
}

class ClosureEnv_main_31 extends TypeFunction1<String, int> {
  ClosureEnv_main_31();
  @override
  String call(int x) => closureCall(this, x);
}
ClosureEnv_main_31 ClosureEnv_main_31_new(ClosureEnv_main_31 env_) {
  env_.closureCall = ClosureEnv_main_31_call;
  return env_;
}
String ClosureEnv_main_31_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_31;

  return 'N${x}';
}


class VPtr {
  late Map<String, dynamic> vptr;
  VPtr() {
    vptr = <String, dynamic>{
      'toString': null,
      'operatorEq': null,
      'get_hashCode': null,
    };
  }
  @override
  String toString() {
    final fn = vptr['toString'];
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

typedef Predicate<T> = bool Function(T);

typedef Transformer<A, B> = B Function(A);

typedef Reducer<T> = T Function(T, T);

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
}

Comparable2Value<T> Comparable2_new<T>(dynamic this__) {
  final this_ = this__ as Comparable2Value<T>;
  this_.vptr['compareTo'] = Comparable2_compareTo<T>;
  this_.vptr['operatorLt'] = Comparable2_operatorLt<T>;
  this_.vptr['operatorGt'] = Comparable2_operatorGt<T>;
  this_.vptr['operatorLte'] = Comparable2_operatorLte<T>;
  this_.vptr['operatorGte'] = Comparable2_operatorGte<T>;
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
final Map<String, dynamic> Cacheable__cache = <String, dynamic>{};
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
  return (this_.vptr['validate'] as List<String> Function(dynamic))(this_).isEmpty;
}


class EntityValue<ID> extends Entity_Object_Printable_CacheableValue<ID> {
  late ID id;
  late String name;
}

EntityValue<ID> Entity_new<ID>(dynamic this__, ID id, String name) {
  final this_ = this__ as EntityValue<ID>;
  Entity_Object_Printable_Cacheable_init(this_);
  this_.vptr['get_label'] = Entity_get_label<ID>;
  this_.vptr['toPrettyString'] = Entity_toPrettyString<ID>;
  this_.vptr['get_cacheKey'] = Entity_get_cacheKey<ID>;
  this_.vptr['cacheValue'] = Entity_cacheValue<ID>;
  this_.vptr['getCachedValue'] = Entity_getCachedValue<ID>;
  this_.vptr['toString'] = Entity_toString<ID>;
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
}

TimestampedEntityValue<ID> TimestampedEntity_new<ID>(dynamic this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  Entity_new(this_, id, name);
  this_.vptr['get_label'] = TimestampedEntity_get_label<ID>;
  this_.vptr['toPrettyString'] = TimestampedEntity_toPrettyString<ID>;
  this_.vptr['get_cacheKey'] = TimestampedEntity_get_cacheKey<ID>;
  this_.vptr['cacheValue'] = TimestampedEntity_cacheValue<ID>;
  this_.vptr['getCachedValue'] = TimestampedEntity_getCachedValue<ID>;
  this_.vptr['toString'] = TimestampedEntity_toString<ID>;
  this_.vptr['get_age'] = TimestampedEntity_get_age<ID>;
  this_.createdAt = createdAt;
  this_.updatedAt = updatedAt;
  return this_;
}

Duration TimestampedEntity_get_age<ID>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Duration(milliseconds: (this_.updatedAt - this_.createdAt));
}

String TimestampedEntity_get_label<ID>(dynamic this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return '${this_.name}(${this_.id}, age=${(this_.vptr['get_age'] as Duration Function(dynamic))(this_).inMilliseconds}ms)';
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
  late List<String> _changelog;
}

VersionedEntityValue<ID> VersionedEntity_new<ID>(dynamic this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as VersionedEntityValue<ID>;
  TimestampedEntity_new(this_, id, name, createdAt, updatedAt);
  VersionedEntity_TimestampedEntity_Serializable_Validatable_init(this_);
  this_.vptr['get_label'] = VersionedEntity_get_label<ID>;
  this_.vptr['toPrettyString'] = VersionedEntity_toPrettyString<ID>;
  this_.vptr['get_cacheKey'] = VersionedEntity_get_cacheKey<ID>;
  this_.vptr['cacheValue'] = VersionedEntity_cacheValue<ID>;
  this_.vptr['getCachedValue'] = VersionedEntity_getCachedValue<ID>;
  this_.vptr['toString'] = VersionedEntity_toString<ID>;
  this_.vptr['get_age'] = VersionedEntity_get_age<ID>;
  this_.vptr['serialize'] = VersionedEntity_serialize<ID>;
  this_.vptr['toJson'] = VersionedEntity_toJson<ID>;
  this_.vptr['validate'] = VersionedEntity_validate<ID>;
  this_.vptr['get_isValid'] = VersionedEntity_get_isValid<ID>;
  this_.vptr['get_version'] = VersionedEntity_get_version<ID>;
  this_.vptr['bump'] = VersionedEntity_bump<ID>;
  this_.vptr['get_changelog'] = VersionedEntity_get_changelog<ID>;
  this_._version = 1;
  this_._changelog = <String>[];
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

List<String> VersionedEntity_get_changelog<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return List.unmodifiable(this_._changelog);
}

String VersionedEntity_serialize<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return '${this_.id}:${this_.name}:v${this_._version}';
}

List<String> VersionedEntity_validate<ID>(dynamic this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  final List<String> errors = <String>[];
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

Duration VersionedEntity_get_age<ID>(dynamic this__) {
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
}

MoneyValue Money_new(dynamic this__, int cents, [String currency = 'USD']) {
  final this_ = this__ as MoneyValue;
  Comparable2_new(this_);
  Money_Comparable2_Printable_init(this_);
  this_.vptr['compareTo'] = Money_compareTo;
  this_.vptr['operatorLt'] = Money_operatorLt;
  this_.vptr['operatorGt'] = Money_operatorGt;
  this_.vptr['operatorLte'] = Money_operatorLte;
  this_.vptr['operatorGte'] = Money_operatorGte;
  this_.vptr['get_label'] = Money_get_label;
  this_.vptr['toPrettyString'] = Money_toPrettyString;
  this_.vptr['operatorPlus'] = Money_operatorPlus;
  this_.vptr['operatorMinus'] = Money_operatorMinus;
  this_.vptr['operatorStar'] = Money_operatorStar;
  this_.vptr['operatorNeg'] = Money_operatorNeg;
  this_.vptr['toString'] = Money_toString;
  this_.cents = cents;
  this_.currency = currency;
  return this_;
}

MoneyValue Money_new_fromDollars(dynamic this__, double dollars, [String currency = 'USD']) {
  final this_ = this__ as MoneyValue;
  Comparable2_new(this_);
  Money_Comparable2_Printable_init(this_);
  this_.vptr['compareTo'] = Money_compareTo;
  this_.vptr['operatorLt'] = Money_operatorLt;
  this_.vptr['operatorGt'] = Money_operatorGt;
  this_.vptr['operatorLte'] = Money_operatorLte;
  this_.vptr['operatorGte'] = Money_operatorGte;
  this_.vptr['get_label'] = Money_get_label;
  this_.vptr['toPrettyString'] = Money_toPrettyString;
  this_.vptr['operatorPlus'] = Money_operatorPlus;
  this_.vptr['operatorMinus'] = Money_operatorMinus;
  this_.vptr['operatorStar'] = Money_operatorStar;
  this_.vptr['operatorNeg'] = Money_operatorNeg;
  this_.vptr['toString'] = Money_toString;
  this_.cents = (dollars * 100).round();
  this_.currency = currency;
  return this_;
}

MoneyValue Money_operatorPlus(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  if (!((this_.currency == other.currency)))   throw ArgumentError('Currency mismatch');
  return Money_new(MoneyValue(), (this_.cents + other.cents), this_.currency);
}

MoneyValue Money_operatorMinus(dynamic this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  if (!((this_.currency == other.currency)))   throw ArgumentError('Currency mismatch');
  return Money_new(MoneyValue(), (this_.cents - other.cents), this_.currency);
}

MoneyValue Money_operatorStar(dynamic this__, int factor) {
  final this_ = this__ as MoneyValue;
  return Money_new(MoneyValue(), (this_.cents * factor), this_.currency);
}

MoneyValue Money_operatorNeg(dynamic this__) {
  final this_ = this__ as MoneyValue;
  return Money_new(MoneyValue(), (-this_.cents), this_.currency);
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
  late Map<String, dynamic> _data;
}

ConfigValue Config_new(dynamic this__, Map<String, dynamic> _data) {
  final this_ = this__ as ConfigValue;
  this_.vptr['operatorIndex'] = Config_operatorIndex;
  this_.vptr['operatorIndexSet'] = Config_operatorIndexSet;
  this_.vptr['containsKey'] = Config_containsKey;
  this_.vptr['get_length'] = Config_get_length;
  this_.vptr['toString'] = Config_toString;
  this_._data = _data;
  return this_;
}

ConfigValue Config_new_empty(dynamic this__) {
  final this_ = this__ as ConfigValue;
  this_.vptr['operatorIndex'] = Config_operatorIndex;
  this_.vptr['operatorIndexSet'] = Config_operatorIndexSet;
  this_.vptr['containsKey'] = Config_containsKey;
  this_.vptr['get_length'] = Config_get_length;
  this_.vptr['toString'] = Config_toString;
  this_._data = <String, dynamic>{};
  return this_;
}

ConfigValue Config_new_fromPairs(dynamic this__, List<List<dynamic>> pairs) {
  final this_ = this__ as ConfigValue;
  this_.vptr['operatorIndex'] = Config_operatorIndex;
  this_.vptr['operatorIndexSet'] = Config_operatorIndexSet;
  this_.vptr['containsKey'] = Config_containsKey;
  this_.vptr['get_length'] = Config_get_length;
  this_.vptr['toString'] = Config_toString;
  this_._data = (() {   final Map<String, dynamic> _v0 = <String, dynamic>{};
  for (final p in pairs)   _v0[(p[0] as String)] = p[1];
 return _v0; })();
  return this_;
}

ConfigValue Config_new_withDefaults(Map<String, dynamic> overrides) {
  final Map<String, dynamic> defaults = <String, dynamic>{'debug': false, 'maxRetries': 3, 'timeout': 30, 'name': 'default'};
  defaults.addAll(overrides);
  return Config_new(ConfigValue(), defaults);
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
  final List<String> sorted = (this_._data.keys.toList()..sort());
  final Iterable<String> entries = sorted.map(ClosureEnv_anon_0(this_).call);
  return 'Config{${entries.join(', ')}}';
}


class EventBusValue extends VPtr {
  late List<void Function(String)> _listeners;
}

EventBusValue EventBus_new(dynamic this__) {
  final this_ = this__ as EventBusValue;
  this_.vptr['on'] = EventBus_on;
  this_.vptr['emit'] = EventBus_emit;
  this_._listeners = <void Function(String)>[];
  return this_;
}

void EventBus_on(dynamic this__, void Function(String) listener) {
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
}

DrawableValue Drawable_new(dynamic this__) {
  final this_ = this__ as DrawableValue;
  this_.vptr['draw'] = Drawable_draw;
  return this_;
}

void Drawable_draw(dynamic this_) {
  throw UnimplementedError('Drawable.draw is abstract');
}


class ResizableValue extends VPtr {
}

ResizableValue Resizable_new(dynamic this__) {
  final this_ = this__ as ResizableValue;
  this_.vptr['resize'] = Resizable_resize;
  return this_;
}

void Resizable_resize(dynamic this_, double factor) {
  throw UnimplementedError('Resizable.resize is abstract');
}


class ClickableValue extends VPtr {
}

ClickableValue Clickable_new(dynamic this__) {
  final this_ = this__ as ClickableValue;
  this_.vptr['onClick'] = Clickable_onClick;
  return this_;
}

void Clickable_onClick(dynamic this_) {
  throw UnimplementedError('Clickable.onClick is abstract');
}


class WidgetValue extends VPtr implements DrawableValue, ResizableValue, ClickableValue {
  late String _state;
  late double _scale;
  late int _clickCount;
}

WidgetValue Widget_new(dynamic this__) {
  final this_ = this__ as WidgetValue;
  this_.vptr['draw'] = Widget_draw;
  this_.vptr['resize'] = Widget_resize;
  this_.vptr['onClick'] = Widget_onClick;
  this_.vptr['get_info'] = Widget_get_info;
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
}

PairValue<A, B> Pair_new<A, B>(dynamic this__, A first, B second) {
  final this_ = this__ as PairValue<A, B>;
  this_.vptr['swap'] = Pair_swap<A, B>;
  this_.vptr['mapFirst_int'] = Pair_mapFirst<A, B, int>;
  this_.vptr['mapSecond_String'] = Pair_mapSecond<A, B, String>;
  this_.vptr['fold_String'] = Pair_fold<A, B, String>;
  this_.vptr['toString'] = Pair_toString<A, B>;
  this_.first = first;
  this_.second = second;
  return this_;
}

PairValue<B, A> Pair_swap<A, B>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<B, A>(PairValue<B, A>(), this_.second, this_.first);
}

PairValue<C, B> Pair_mapFirst<A, B, C>(dynamic this__, C Function(A) transform) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<C, B>(PairValue<C, B>(), transform(this_.first), this_.second);
}

PairValue<A, C> Pair_mapSecond<A, B, C>(dynamic this__, C Function(B) transform) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<A, C>(PairValue<A, C>(), this_.first, transform(this_.second));
}

R Pair_fold<A, B, R>(dynamic this__, R Function(A, B) combine) {
  final this_ = this__ as PairValue<A, B>;
  return combine(this_.first, this_.second);
}

String Pair_toString<A, B>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return 'Pair(${this_.first}, ${this_.second})';
}


class TripleValue<A, B, C> extends PairValue<A, B> {
  late C third;
}

TripleValue<A, B, C> Triple_new<A, B, C>(dynamic this__, A first, B second, C third) {
  final this_ = this__ as TripleValue<A, B, C>;
  Pair_new(this_, first, second);
  this_.vptr['swap'] = Triple_swap<A, B, C>;
  this_.vptr['mapFirst'] = Triple_mapFirst<A, B, C>;
  this_.vptr['mapSecond'] = Triple_mapSecond<A, B, C>;
  this_.vptr['fold_String'] = Triple_fold<A, B, C, String>;
  this_.vptr['toString'] = Triple_toString<A, B, C>;
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

PairValue<C, B> Triple_mapFirst<A, B, C>(dynamic this__, C Function(A) transform) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_mapFirst<A, B, C>(this_, transform);
}

PairValue<A, C> Triple_mapSecond<A, B, C>(dynamic this__, C Function(B) transform) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_mapSecond<A, B, C>(this_, transform);
}

R Triple_fold<A, B, C, R>(dynamic this__, R Function(A, B) combine) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_fold<A, B, R>(this_, combine);
}


class StringBuilderValue extends VPtr {
  late StringBuffer _buf;
  late String _separator;
}

StringBuilderValue StringBuilder_new(dynamic this__) {
  final this_ = this__ as StringBuilderValue;
  this_.vptr['withSeparator'] = StringBuilder_withSeparator;
  this_.vptr['add'] = StringBuilder_add;
  this_.vptr['addAll'] = StringBuilder_addAll;
  this_.vptr['get_length'] = StringBuilder_get_length;
  this_.vptr['toString'] = StringBuilder_toString;
  this_._buf = StringBuffer();
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

StringBuilderValue StringBuilder_addAll(dynamic this__, List<String> texts) {
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
}

AppErrorValue AppError_new(dynamic this__, String message, String code, [AppErrorValue? cause = null]) {
  final this_ = this__ as AppErrorValue;
  this_.vptr['toString'] = AppError_toString;
  this_.message = message;
  this_.code = code;
  this_.cause = cause;
  return this_;
}

String AppError_toString(dynamic this__) {
  final this_ = this__ as AppErrorValue;
  final List<String> chain = <String>[];
  AppErrorValue? current = this_;
  while (!((current == null))) {
    chain.add('${current.code}:${current.message}');
    current = current.cause;
  }
  return chain.join(' -> ');
}


class DataPipelineValue<T> extends VPtr {
  late List<T> _data;
}

DataPipelineValue<T> DataPipeline_new<T>(dynamic this__, List<T> _data) {
  final this_ = this__ as DataPipelineValue<T>;
  this_.vptr['where'] = DataPipeline_where<T>;
  this_.vptr['map_int'] = DataPipeline_map<T, int>;
  this_.vptr['sorted'] = DataPipeline_sorted<T>;
  this_.vptr['take'] = DataPipeline_take<T>;
  this_.vptr['fold_int'] = DataPipeline_fold<T, int>;
  this_.vptr['toList'] = DataPipeline_toList<T>;
  this_.vptr['toString'] = DataPipeline_toString<T>;
  this_._data = _data;
  return this_;
}

DataPipelineValue<T> DataPipeline_where<T>(dynamic this__, bool Function(T) test) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<T>(DataPipelineValue<T>(), this_._data.where(test).toList());
}

DataPipelineValue<R> DataPipeline_map<T, R>(dynamic this__, R Function(T) transform) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<R>(DataPipelineValue<R>(), this_._data.map(transform).toList());
}

DataPipelineValue<T> DataPipeline_sorted<T>(dynamic this__, int Function(T, T) compare) {
  final this_ = this__ as DataPipelineValue<T>;
  final List<T> copy = List.from(this_._data);
  copy.sort(compare);
  return DataPipeline_new<T>(DataPipelineValue<T>(), copy);
}

DataPipelineValue<T> DataPipeline_take<T>(dynamic this__, int count) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<T>(DataPipelineValue<T>(), this_._data.take(count).toList());
}

R DataPipeline_fold<T, R>(dynamic this__, R initial, R Function(R, T) combine) {
  final this_ = this__ as DataPipelineValue<T>;
  return this_._data.fold(initial, combine);
}

List<T> DataPipeline_toList<T>(dynamic this__) {
  final this_ = this__ as DataPipelineValue<T>;
  return List.unmodifiable(this_._data);
}

String DataPipeline_toString<T>(dynamic this__) {
  final this_ = this__ as DataPipelineValue<T>;
  return 'Pipeline(${this_._data})';
}


class BoundedValueValue extends VPtr {
  late double _value;
  late double _min;
  late double _max;
}

BoundedValueValue BoundedValue_new(dynamic this__, double _value, double _min, double _max) {
  final this_ = this__ as BoundedValueValue;
  this_.vptr['get_value'] = BoundedValue_get_value;
  this_.vptr['set_value'] = BoundedValue_set_value;
  this_.vptr['operatorPlus'] = BoundedValue_operatorPlus;
  this_.vptr['toString'] = BoundedValue_toString;
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
  return BoundedValue_new(BoundedValueValue(), (this_._value + delta), this_._min, this_._max);
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

List<int> MathUtils_fibonacci(int count) {
  MathUtils__callCount = (MathUtils__callCount + 1);
  if ((count <= 0))   return <int>[];
  if ((count == 1))   return <int>[0];
  final List<int> fibs = <int>[0, 1];
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

List<String> Loggable_get_logs(dynamic this__) {
  final this_ = this__;
  return List.unmodifiable(this_._logs);
}


// mixin Observable → static functions for delegation
void Observable_observe<T>(dynamic this__, void Function(T) callback) {
  final this_ = this__;
  this_._observers.add(callback);
}

void Observable_notify<T>(dynamic this__, T value) {
  final this_ = this__;
  for (final cb in this_._observers) {
    cb(value);
  }
}


class ReactiveStoreValue<V> extends ReactiveStore_Object_Loggable_ObservableValue<V> {
  late Map<String, V> _store;
}

ReactiveStoreValue<V> ReactiveStore_new<V>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  ReactiveStore_Object_Loggable_Observable_init(this_);
  this_.vptr['log'] = ReactiveStore_log<V>;
  this_.vptr['get_logs'] = ReactiveStore_get_logs<V>;
  this_.vptr['observe'] = ReactiveStore_observe<V>;
  this_.vptr['notify'] = ReactiveStore_notify<V>;
  this_.vptr['get'] = ReactiveStore_get<V>;
  this_.vptr['set'] = ReactiveStore_set<V>;
  this_.vptr['get_size'] = ReactiveStore_get_size<V>;
  this_.vptr['toString'] = ReactiveStore_toString<V>;
  this_._logs = <String>[];
  this_._observers = <void Function(V)>[];
  this_._store = <String, V>{};
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

List<String> ReactiveStore_get_logs<V>(dynamic this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return Loggable_get_logs(this_);
}

void ReactiveStore_observe<V>(dynamic this__, void Function(V) callback) {
  final this_ = this__ as ReactiveStoreValue<V>;
  Observable_observe<V>(this_, callback);
}

void ReactiveStore_notify<V>(dynamic this__, V value) {
  final this_ = this__ as ReactiveStoreValue<V>;
  Observable_notify<V>(this_, value);
}


class ShapeValue extends VPtr {
}

ShapeValue Shape_new(dynamic this__) {
  final this_ = this__ as ShapeValue;
  this_.vptr['area'] = Shape_area;
  this_.vptr['get_shapeName'] = Shape_get_shapeName;
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
}

CircleValue Circle_new(dynamic this__, double radius) {
  final this_ = this__ as CircleValue;
  this_.vptr['area'] = Circle_area;
  this_.vptr['get_shapeName'] = Circle_get_shapeName;
  this_.vptr['toString'] = Circle_toString;
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
}

RectangleValue Rectangle_new(dynamic this__, double width, double height) {
  final this_ = this__ as RectangleValue;
  this_.vptr['area'] = Rectangle_area;
  this_.vptr['get_shapeName'] = Rectangle_get_shapeName;
  this_.vptr['toString'] = Rectangle_toString;
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
  late List<NodeValue<T>> children;
}

NodeValue<T> Node_new<T>(dynamic this__, T value, [List<NodeValue<T>>? children = null]) {
  final this_ = this__ as NodeValue<T>;
  this_.vptr['addChild'] = Node_addChild<T>;
  this_.vptr['flatten'] = Node_flatten<T>;
  this_.vptr['mapTree_String'] = Node_mapTree<T, String>;
  this_.vptr['toString'] = Node_toString<T>;
  this_.value = value;
  this_.children = (children ?? <NodeValue<T>>[]);
  return this_;
}

void Node_addChild<T>(dynamic this__, NodeValue<T> child) {
  final this_ = this__ as NodeValue<T>;
  this_.children.add(child);
}

List<T> Node_flatten<T>(dynamic this__) {
  final this_ = this__ as NodeValue<T>;
  final List<T> result = <T>[this_.value];
  for (final child in this_.children) {
    result.addAll((child.vptr['flatten'] as List<T> Function(dynamic))(child));
  }
  return result;
}

NodeValue<R> Node_mapTree<T, R>(dynamic this__, R Function(T) transform) {
  final this_ = this__ as NodeValue<T>;
  return Node_new<R>(NodeValue<R>(), transform(this_.value), this_.children.map(ClosureEnv_anon_1(transform).call).toList());
}

String Node_toString<T>(dynamic this__) {
  final this_ = this__ as NodeValue<T>;
  if (this_.children.isEmpty)   return '${this_.value}';
  return '${this_.value}(${this_.children.join(', ')})';
}


class LabeledNodeValue<T> extends LabeledNode_Node_PrintableValue<T> {
  late String nodeLabel;
}

LabeledNodeValue<T> LabeledNode_new<T>(dynamic this__, String nodeLabel, T value, [List<NodeValue<T>>? children = null]) {
  final this_ = this__ as LabeledNodeValue<T>;
  Node_new(this_, value, children);
  LabeledNode_Node_Printable_init(this_);
  this_.vptr['addChild'] = LabeledNode_addChild<T>;
  this_.vptr['flatten'] = LabeledNode_flatten<T>;
  this_.vptr['mapTree_String'] = LabeledNode_mapTree<T, String>;
  this_.vptr['toString'] = LabeledNode_toString<T>;
  this_.vptr['get_label'] = LabeledNode_get_label<T>;
  this_.vptr['toPrettyString'] = LabeledNode_toPrettyString<T>;
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

List<T> LabeledNode_flatten<T>(dynamic this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Node_flatten<T>(this_);
}

NodeValue<R> LabeledNode_mapTree<T, R>(dynamic this__, R Function(T) transform) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Node_mapTree<T, R>(this_, transform);
}

String LabeledNode_toPrettyString<T>(dynamic this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Printable_toPrettyString(this_);
}


class Entity_Object_PrintableValue extends VPtr {
}

void Entity_Object_Printable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['toPrettyString'] = Printable_toPrettyString;
}


class Entity_Object_Printable_CacheableValue<ID> extends Entity_Object_PrintableValue {
}

void Entity_Object_Printable_Cacheable_init(dynamic this__) {
  Entity_Object_Printable_init(this__);
  final this_ = this__;
  this_.vptr['cacheValue'] = Cacheable_cacheValue;
  this_.vptr['getCachedValue'] = Cacheable_getCachedValue;
}


class VersionedEntity_TimestampedEntity_SerializableValue<ID> extends TimestampedEntityValue<ID> {
}

void VersionedEntity_TimestampedEntity_Serializable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['toJson'] = Serializable_toJson;
}


class VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> extends VersionedEntity_TimestampedEntity_SerializableValue<ID> {
}

void VersionedEntity_TimestampedEntity_Serializable_Validatable_init(dynamic this__) {
  VersionedEntity_TimestampedEntity_Serializable_init(this__);
  final this_ = this__;
  this_.vptr['get_isValid'] = Validatable_get_isValid;
}


class Money_Comparable2_PrintableValue extends Comparable2Value<MoneyValue> {
}

void Money_Comparable2_Printable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['toPrettyString'] = Printable_toPrettyString;
}


class ReactiveStore_Object_LoggableValue extends VPtr {
  late List<String> _logs;
}

void ReactiveStore_Object_Loggable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['log'] = Loggable_log;
  this_.vptr['get_logs'] = Loggable_get_logs;
}


class ReactiveStore_Object_Loggable_ObservableValue<V> extends ReactiveStore_Object_LoggableValue {
  late List<void Function(V)> _observers;
}

void ReactiveStore_Object_Loggable_Observable_init(dynamic this__) {
  ReactiveStore_Object_Loggable_init(this__);
  final this_ = this__;
  this_.vptr['observe'] = Observable_observe;
  this_.vptr['notify'] = Observable_notify;
}


class LabeledNode_Node_PrintableValue<T> extends NodeValue<T> {
}

void LabeledNode_Node_Printable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['toPrettyString'] = Printable_toPrettyString;
}


T applyTransform<T>(T value, T Function(T) transform) {
  return transform(value);
}

List<T> filterWith<T>(List<T> items, bool Function(T) predicate) {
  final List<T> result = <T>[];
  for (final item in items) {
    if (predicate(item))     result.add(item);
  }
  return result;
}

T reduceList<T>(List<T> items, T Function(T, T) reducer) {
  T acc = items.first;
  for (var i = 1; (i < items.length); i = (i + 1)) {
    acc = reducer(acc, items[i]);
  }
  return acc;
}

List<String> testClosureBoxing() {
  final List<String> log = <String>[];
  IntBox counter = IntBox(0);
  final int Function() increment = ClosureEnv_testClosureBoxing_2(counter).call;
  increment();
  increment();
  log.add('counter=${counter.value}');
  final List<int Function()> fns = <int Function()>[];
  for (var i = 0; (i < 3); i = (i + 1)) {
    fns.add(ClosureEnv_testClosureBoxing_3(i).call);
  }
  log.add('fns=${fns.map((int Function() f) => f()).toList()}');
  IntBox outer = IntBox(0);
  final int Function(int) Function(int) makeAdder = ClosureEnv_testClosureBoxing_4(outer).call;
  final int Function(int) adder = makeAdder(100);
  adder(5);
  adder(10);
  log.add('outer=${outer.value}, adder(0)=${adder(0)}');
  String captureParam(String prefix) {
    int count = 0;
    final String Function() fn = ClosureEnv_testClosureBoxing_6(count, prefix).call;
    fn();
    fn();
    return fn();
  }

  log.add('captureParam=${captureParam('test')}');
  final EventBusValue bus = EventBus_new(EventBusValue());
  List<String> received = <String>[];
  (bus.vptr['on'] as void Function(dynamic, void Function(String)))(bus, ClosureEnv_testClosureBoxing_8(received).call);
  (bus.vptr['emit'] as void Function(dynamic, String))(bus, 'hello');
  (bus.vptr['emit'] as void Function(dynamic, String))(bus, 'world');
  log.add('received=${received}');
  return log;
}

String testExceptionChain() {
  try {
    try {
      throw AppError_new(AppErrorValue(), 'not found', 'E404');
    }
 catch (e) {
      throw AppError_new(AppErrorValue(), 'service failed', 'E500', (e as AppErrorValue));
    }
  }
 catch (e) {
    try {
      throw AppError_new(AppErrorValue(), 'gateway error', 'E502', (e as AppErrorValue));
    }
 catch (e2) {
      return e2.toString();
    }
  }
}

String formatRecord({required String name, int age = 0, String? email = null, bool active = true, List<String> tags = const []}) {
  final List<String> parts = <String>[name];
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
  print('--- 1. typedef + Function ---');
  final int doubled = applyTransform<int>(21, (int x) => (x * 2));
  print('applyTransform: ${doubled}');
  final List<int> evens = filterWith<int>(<int>[1, 2, 3, 4, 5, 6], (int x) => ((x % 2) == 0));
  print('filterWith: ${evens}');
  final int sum = reduceList<int>(<int>[1, 2, 3, 4, 5], (int a, int b) => (a + b));
  print('reduceList: ${sum}');
  print('\n--- 2. 枚举类 ---');
  print('red hex: ${Color_get_hex(Color.red)}');
  print('green isWarm: ${Color_get_isWarm(Color.green)}');
  print('priorities: ${const [Priority.low, Priority.medium, Priority.high, Priority.critical].map((Priority p) => '${p}'.split('.').last).toList()}');
  print('\n--- 3. 运算符重载 ---');
  final MoneyValue price1 = Money_new(MoneyValue(), 1099, 'USD');
  final MoneyValue price2 = Money_new_fromDollars(MoneyValue(), 5.5);
  final MoneyValue total = (price1.vptr['operatorPlus'] as MoneyValue Function(dynamic, MoneyValue))(price1, price2);
  final MoneyValue negated = (price2.vptr['operatorNeg'] as MoneyValue Function(dynamic))(price2);
  print('price1: ${(price1.vptr['toPrettyString'] as String Function(dynamic))(price1)}');
  print('price2: ${price2}');
  print('total: ${total}');
  print('negated: ${negated}');
  print('price1 > price2: ${(price1.vptr['operatorGt'] as bool Function(dynamic, MoneyValue))(price1, price2)}');
  print('price1 < price2: ${(price1.vptr['operatorLt'] as bool Function(dynamic, MoneyValue))(price1, price2)}');
  print('price1 * 3: ${(price1.vptr['operatorStar'] as MoneyValue Function(dynamic, int))(price1, 3)}');
  print('\n--- 4. 多层泛型继承 ---');
  final EntityValue<int> entity = Entity_new<int>(EntityValue<int>(), 1, 'alice');
  print('entity: ${entity}');
  print('entity label: ${(entity.vptr['toPrettyString'] as String Function(dynamic))(entity)}');
  (entity.vptr['cacheValue'] as void Function(dynamic, dynamic))(entity, 'cached_data');
  print('cached: ${(entity.vptr['getCachedValue'] as dynamic Function(dynamic))(entity)}');
  final TimestampedEntityValue<String> tsEntity = TimestampedEntity_new<String>(TimestampedEntityValue<String>(), 'u1', 'bob', 1000, 2000);
  print('tsEntity label: ${(tsEntity.vptr['toPrettyString'] as String Function(dynamic))(tsEntity)}');
  final VersionedEntityValue<int> vEntity = VersionedEntity_new<int>(VersionedEntityValue<int>(), 42, 'project', 1000, 5000);
  (vEntity.vptr['bump'] as void Function(dynamic, String))(vEntity, 'initial release');
  (vEntity.vptr['bump'] as void Function(dynamic, String))(vEntity, 'bug fix');
  print('vEntity label: ${(vEntity.vptr['toPrettyString'] as String Function(dynamic))(vEntity)}');
  print('vEntity version: ${(vEntity.vptr['get_version'] as int Function(dynamic))(vEntity)}');
  print('vEntity changelog: ${(vEntity.vptr['get_changelog'] as List<String> Function(dynamic))(vEntity)}');
  print('vEntity serialize: ${(vEntity.vptr['serialize'] as String Function(dynamic))(vEntity)}');
  print('vEntity toJson: ${(vEntity.vptr['toJson'] as String Function(dynamic))(vEntity)}');
  print('vEntity isValid: ${(vEntity.vptr['get_isValid'] as bool Function(dynamic))(vEntity)}');
  print('vEntity validate: ${(vEntity.vptr['validate'] as List<String> Function(dynamic))(vEntity)}');
  print('\n--- 5. 工厂构造 ---');
  final ConfigValue cfg1 = Config_new_empty(ConfigValue());
  (cfg1.vptr['operatorIndexSet'] as void Function(dynamic, String, dynamic))(cfg1, 'host', 'localhost');
  print('cfg1: ${cfg1}');
  final ConfigValue cfg2 = Config_new_fromPairs(ConfigValue(), <List<dynamic>>[['a', 1], ['b', 2]]);
  print('cfg2: ${cfg2}');
  final ConfigValue cfg3 = Config_new_withDefaults(<String, dynamic>{'debug': true, 'name': 'prod'});
  print('cfg3: ${cfg3}');
  print('cfg3[maxRetries]: ${(cfg3.vptr['operatorIndex'] as dynamic Function(dynamic, String))(cfg3, 'maxRetries')}');
  print('\n--- 6. 闭包 Box 化 ---');
  final List<String> closureLog = testClosureBoxing();
  for (final line in closureLog) {
    print(line);
  }
  print('\n--- 7. 多重 implements ---');
  final WidgetValue widget = Widget_new(WidgetValue());
  (widget.vptr['draw'] as void Function(dynamic))(widget);
  (widget.vptr['resize'] as void Function(dynamic, double))(widget, 1.5);
  (widget.vptr['onClick'] as void Function(dynamic))(widget);
  (widget.vptr['onClick'] as void Function(dynamic))(widget);
  print('widget: ${(widget.vptr['get_info'] as String Function(dynamic))(widget)}');
  print('\n--- 8. 泛型 Pair ---');
  final PairValue<int, String> pair = Pair_new<int, String>(PairValue<int, String>(), 42, 'hello');
  print('pair: ${pair}');
  print('swap: ${(pair.vptr['swap'] as PairValue<String, int> Function(dynamic))(pair)}');
  print('mapFirst: ${(pair.vptr['mapFirst_int'] as PairValue<int, String> Function(dynamic, int Function(int)))(pair, (int x) => (x * 2))}');
  print('mapSecond: ${(pair.vptr['mapSecond_String'] as PairValue<int, String> Function(dynamic, String Function(String)))(pair, (String s) => s.toUpperCase())}');
  print('fold: ${(pair.vptr['fold_String'] as String Function(dynamic, String Function(int, String)))(pair, (int a, String b) => '${b}=${a}')}');
  final TripleValue<int, String, bool> triple = Triple_new<int, String, bool>(TripleValue<int, String, bool>(), 1, 'yes', true);
  print('triple: ${triple}');
  print('\n--- 9. 级联操作 ---');
  final StringBuilderValue sb = (() { final _let7 = StringBuilder_new(StringBuilderValue()); (_let7.vptr['withSeparator'] as StringBuilderValue Function(dynamic, String))(_let7, ', '); (_let7.vptr['add'] as StringBuilderValue Function(dynamic, String))(_let7, 'alpha'); (_let7.vptr['add'] as StringBuilderValue Function(dynamic, String))(_let7, 'beta'); (_let7.vptr['addAll'] as StringBuilderValue Function(dynamic, List<String>))(_let7, <String>['gamma', 'delta']); return _let7; })();
  print('builder: ${sb}');
  print('length: ${(sb.vptr['get_length'] as int Function(dynamic))(sb)}');
  print('\n--- 10. 异常处理链 ---');
  print('chain: ${testExceptionChain()}');
  print('\n--- 11. 集合操作 ---');
  final DataPipelineValue<int> pipeline = ((((DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]).vptr['where'] as DataPipelineValue<int> Function(dynamic, bool Function(int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]), (int x) => (x > 2)).vptr['sorted'] as DataPipelineValue<int> Function(dynamic, int Function(int, int)))((DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]).vptr['where'] as DataPipelineValue<int> Function(dynamic, bool Function(int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]), (int x) => (x > 2)), (int a, int b) => (a - b)).vptr['take'] as DataPipelineValue<int> Function(dynamic, int))(((DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]).vptr['where'] as DataPipelineValue<int> Function(dynamic, bool Function(int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]), (int x) => (x > 2)).vptr['sorted'] as DataPipelineValue<int> Function(dynamic, int Function(int, int)))((DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]).vptr['where'] as DataPipelineValue<int> Function(dynamic, bool Function(int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]), (int x) => (x > 2)), (int a, int b) => (a - b)), 5).vptr['map_int'] as DataPipelineValue<int> Function(dynamic, int Function(int)))((((DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]).vptr['where'] as DataPipelineValue<int> Function(dynamic, bool Function(int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]), (int x) => (x > 2)).vptr['sorted'] as DataPipelineValue<int> Function(dynamic, int Function(int, int)))((DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]).vptr['where'] as DataPipelineValue<int> Function(dynamic, bool Function(int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]), (int x) => (x > 2)), (int a, int b) => (a - b)).vptr['take'] as DataPipelineValue<int> Function(dynamic, int))(((DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]).vptr['where'] as DataPipelineValue<int> Function(dynamic, bool Function(int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]), (int x) => (x > 2)).vptr['sorted'] as DataPipelineValue<int> Function(dynamic, int Function(int, int)))((DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]).vptr['where'] as DataPipelineValue<int> Function(dynamic, bool Function(int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]), (int x) => (x > 2)), (int a, int b) => (a - b)), 5), (int x) => (x * 10));
  print('pipeline: ${(pipeline.vptr['toList'] as List<int> Function(dynamic))(pipeline)}');
  final int pipeSum = (DataPipeline_new<int>(DataPipelineValue<int>(), <int>[1, 2, 3, 4, 5]).vptr['fold_int'] as int Function(dynamic, int, int Function(int, int)))(DataPipeline_new<int>(DataPipelineValue<int>(), <int>[1, 2, 3, 4, 5]), 0, (int acc, int x) => (acc + x));
  print('pipeSum: ${pipeSum}');
  print('\n--- 12. 可选参数 ---');
  print(formatRecord(name: 'Alice', age: 30, email: 'alice@test.com'));
  print(formatRecord(name: 'Bob', tags: <String>['admin', 'vip']));
  print(greetAll('Hello'));
  print(greetAll('Hi', 'Dart', '!!'));
  print('\n--- 13. BoundedValue ---');
  final BoundedValueValue bv = BoundedValue_new(BoundedValueValue(), 5.0, 0.0, 10.0);
  print('bv: ${bv}');
  (bv.vptr['set_value'] as void Function(dynamic, double))(bv, 15.0);
  print('after set 15: ${bv}');
  (bv.vptr['set_value'] as void Function(dynamic, double))(bv, (-5.0));
  print('after set -5: ${bv}');
  final BoundedValueValue bv2 = (bv.vptr['operatorPlus'] as BoundedValueValue Function(dynamic, double))(bv, 7.0);
  print('bv + 7: ${bv2}');
  print('\n--- 14. 静态方法 ---');
  print('5! = ${MathUtils_factorial(5)}');
  print('fib(8): ${MathUtils_fibonacci(8)}');
  print('lerp(0,100,0.3): ${MathUtils_lerp(0.0, 100.0, 0.3)}');
  print('callCount: ${MathUtils_callCount()}');
  print('\n--- 15. ReactiveStore ---');
  final ReactiveStoreValue<int> store = ReactiveStore_new<int>(ReactiveStoreValue<int>());
  final List<int> observed = <int>[];
  (store.vptr['observe'] as void Function(dynamic, void Function(int)))(store, ClosureEnv_main_10(observed).call);
  (store.vptr['set'] as void Function(dynamic, String, int))(store, 'x', 10);
  (store.vptr['set'] as void Function(dynamic, String, int))(store, 'y', 20);
  print('store: ${store}');
  print('store.get(x): ${(store.vptr['get'] as int? Function(dynamic, String))(store, 'x')}');
  print('store.size: ${(store.vptr['get_size'] as int Function(dynamic))(store)}');
  print('observed: ${observed}');
  print('logs: ${(store.vptr['get_logs'] as List<String> Function(dynamic))(store)}');
  print('\n--- 16. 类型转换 ---');
  final List<ShapeValue> shapes = <ShapeValue>[Circle_new(CircleValue(), 5.0), Rectangle_new(RectangleValue(), 3.0, 4.0), Circle_new(CircleValue(), 1.0)];
  for (final s in shapes) {
    print(describeShape(s));
  }
  print('\n--- 17. 树结构 ---');
  final NodeValue<int> tree = Node_new<int>(NodeValue<int>(), 1, <NodeValue<int>>[Node_new<int>(NodeValue<int>(), 2, <NodeValue<int>>[Node_new<int>(NodeValue<int>(), 4), Node_new<int>(NodeValue<int>(), 5)]), Node_new<int>(NodeValue<int>(), 3, <NodeValue<int>>[Node_new<int>(NodeValue<int>(), 6)])]);
  print('tree: ${tree}');
  print('flatten: ${(tree.vptr['flatten'] as List<int> Function(dynamic))(tree)}');
  final NodeValue<String> strTree = (tree.vptr['mapTree_String'] as NodeValue<String> Function(dynamic, String Function(int)))(tree, (int x) => 'N${x}');
  print('mapped: ${strTree}');
  final LabeledNodeValue<int> labeled = LabeledNode_new<int>(LabeledNodeValue<int>(), 'root', 100);
  (labeled.vptr['addChild'] as void Function(dynamic, NodeValue<int>))(labeled, Node_new<int>(NodeValue<int>(), 200));
  (labeled.vptr['addChild'] as void Function(dynamic, NodeValue<int>))(labeled, Node_new<int>(NodeValue<int>(), 300));
  print('labeled: ${labeled}');
  print('labeled pretty: ${(labeled.vptr['toPrettyString'] as String Function(dynamic))(labeled)}');
  print('labeled flatten: ${(labeled.vptr['flatten'] as List<int> Function(dynamic))(labeled)}');
  print('\n--- 18. 评分 ---');
  print(evaluateGrade(95));
  print(evaluateGrade(82));
  print(evaluateGrade(67));
  print(evaluateGrade(55));
  print('\n=== 所有压力测试通过 ✅ ===');
}

class ClosureEnv_anon_0 {
  ConfigValue this_;
  ClosureEnv_anon_0(this.this_);
  String call(String k) => ClosureEnv_anon_0_call(this, k);
}
String ClosureEnv_anon_0_call(ClosureEnv_anon_0 env, String k) {
  return '${k}=${env.this_._data[k]}';
}

class ClosureEnv_anon_1<R, T> {
  R Function(T) transform;
  ClosureEnv_anon_1(this.transform);
  NodeValue<R> call(NodeValue<T> c) => ClosureEnv_anon_1_call<R, T>(this, c);
}
NodeValue<R> ClosureEnv_anon_1_call<R, T>(ClosureEnv_anon_1<R, T> env, NodeValue<T> c) {
  return Node_mapTree<T, R>(c, env.transform);
}

class ClosureEnv_testClosureBoxing_2 {
  IntBox counter;
  ClosureEnv_testClosureBoxing_2(this.counter);
  int call() => ClosureEnv_testClosureBoxing_2_call(this);
}
int ClosureEnv_testClosureBoxing_2_call(ClosureEnv_testClosureBoxing_2 env) {
    env.counter.value = (env.counter.value + 1);
    return env.counter.value;
  }

class ClosureEnv_testClosureBoxing_3 {
  int i;
  ClosureEnv_testClosureBoxing_3(this.i);
  int call() => ClosureEnv_testClosureBoxing_3_call(this);
}
int ClosureEnv_testClosureBoxing_3_call(ClosureEnv_testClosureBoxing_3 env) {
  return (env.i * 10);
}

class ClosureEnv_ClosureEnv_testClosureBoxing_4_5 {
  IntBox inner;
  IntBox outer;
  ClosureEnv_ClosureEnv_testClosureBoxing_4_5(this.inner, this.outer);
  int call(int x) => ClosureEnv_ClosureEnv_testClosureBoxing_4_5_call(this, x);
}
int ClosureEnv_ClosureEnv_testClosureBoxing_4_5_call(ClosureEnv_ClosureEnv_testClosureBoxing_4_5 env, int x) {
      env.inner.value = (env.inner.value + x);
      env.outer.value = (env.outer.value + x);
      return env.inner.value;
    }

class ClosureEnv_testClosureBoxing_4 {
  IntBox outer;
  ClosureEnv_testClosureBoxing_4(this.outer);
  int Function(int) call(int base) => ClosureEnv_testClosureBoxing_4_call(this, base);
}
int Function(int) ClosureEnv_testClosureBoxing_4_call(ClosureEnv_testClosureBoxing_4 env, int base) {
    IntBox inner = IntBox(base);
    return ClosureEnv_ClosureEnv_testClosureBoxing_4_5(inner, env.outer).call;
  }

class ClosureEnv_testClosureBoxing_6 {
  int count;
  String prefix;
  ClosureEnv_testClosureBoxing_6(this.count, this.prefix);
  String call() => ClosureEnv_testClosureBoxing_6_call(this);
}
String ClosureEnv_testClosureBoxing_6_call(ClosureEnv_testClosureBoxing_6 env) {
      env.count = (env.count + 1);
      return '${env.prefix}-${env.count}';
    }

class ClosureEnv_testClosureBoxing_7 {
  List<String> received;
  ClosureEnv_testClosureBoxing_7(this.received);
  void call(String event) => ClosureEnv_testClosureBoxing_7_call(this, event);
}
void ClosureEnv_testClosureBoxing_7_call(ClosureEnv_testClosureBoxing_7 env, String event) {
    env.received.add(event);
  }

class ClosureEnv_testClosureBoxing_8 {
  List<String> received;
  ClosureEnv_testClosureBoxing_8(this.received);
  void call(String event) => ClosureEnv_testClosureBoxing_8_call(this, event);
}
void ClosureEnv_testClosureBoxing_8_call(ClosureEnv_testClosureBoxing_8 env, String event) {
    env.received.add(event);
  }

class ClosureEnv_main_9 {
  List<int> observed;
  ClosureEnv_main_9(this.observed);
  void call(int v) => ClosureEnv_main_9_call(this, v);
}
void ClosureEnv_main_9_call(ClosureEnv_main_9 env, int v) {
    env.observed.add(v);
  }

class ClosureEnv_main_10 {
  List<int> observed;
  ClosureEnv_main_10(this.observed);
  void call(int v) => ClosureEnv_main_10_call(this, v);
}
void ClosureEnv_main_10_call(ClosureEnv_main_10 env, int v) {
    env.observed.add(v);
  }


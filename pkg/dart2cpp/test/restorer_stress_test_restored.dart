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

void Comparable2_new<T>(Comparable2Value<T> this_) {
  this_.vptr = {
    'compareTo': (self, _a0) => Comparable2_compareTo<T>(self, _a0),
    'operatorLt': (self, _a0) => Comparable2_operatorLt<T>(self, _a0),
    'operatorGt': (self, _a0) => Comparable2_operatorGt<T>(self, _a0),
    'operatorLte': (self, _a0) => Comparable2_operatorLte<T>(self, _a0),
    'operatorGte': (self, _a0) => Comparable2_operatorGte<T>(self, _a0),
  };
}

int Comparable2_compareTo<T>(Comparable2Value<T> this_, T other) {
  throw UnimplementedError('Comparable2.compareTo is abstract');
}

bool Comparable2_operatorLt<T>(Comparable2Value<T> this_, T other) {
  return ((this_.vptr['compareTo'] as Function)(this_, other) < 0);
}

bool Comparable2_operatorGt<T>(Comparable2Value<T> this_, T other) {
  return ((this_.vptr['compareTo'] as Function)(this_, other) > 0);
}

bool Comparable2_operatorLte<T>(Comparable2Value<T> this_, T other) {
  return ((this_.vptr['compareTo'] as Function)(this_, other) <= 0);
}

bool Comparable2_operatorGte<T>(Comparable2Value<T> this_, T other) {
  return ((this_.vptr['compareTo'] as Function)(this_, other) >= 0);
}


// mixin Printable → static functions for delegation
String Printable_toPrettyString(dynamic this_) {
  return '[${(this_.vptr['get_label'] as Function)(this_)}]';
}


// mixin Serializable → static functions for delegation
String Serializable_toJson<T>(dynamic this_) {
  return '{"data": "${(this_.vptr['serialize'] as Function)(this_)}"}';
}


// mixin Cacheable → static functions for delegation
final Map<String, dynamic> Cacheable__cache = <String, dynamic>{};
void Cacheable_cacheValue<K>(dynamic this_, dynamic value) {
  Cacheable__cache['${(this_.vptr['get_cacheKey'] as Function)(this_)}'] = value;
}

dynamic Cacheable_getCachedValue<K>(dynamic this_) {
  return Cacheable__cache['${(this_.vptr['get_cacheKey'] as Function)(this_)}'];
}


// mixin Validatable → static functions for delegation
bool Validatable_get_isValid(dynamic this_) {
  return (this_.vptr['validate'] as Function)(this_).isEmpty;
}


class EntityValue<ID> extends Entity_Object_Printable_CacheableValue<ID> {
  late ID id;
  late String name;
}

void Entity_new<ID>(EntityValue<ID> this_, ID id, String name) {
  this_.vptr = {
    'get_label': (self) => Entity_get_label<ID>(self),
    'toPrettyString': (self) => Entity_toPrettyString<ID>(self),
    'get_cacheKey': (self) => Entity_get_cacheKey<ID>(self),
    'cacheValue': (self, _a0) => Entity_cacheValue<ID>(self, _a0),
    'getCachedValue': (self) => Entity_getCachedValue<ID>(self),
    'toString_': (self) => Entity_toString<ID>(self),
  };
  this_.id = id;
  this_.name = name;
}

String Entity_get_label<ID>(EntityValue<ID> this_) {
  return '${this_.name}(${this_.id})';
}

ID Entity_get_cacheKey<ID>(EntityValue<ID> this_) {
  return this_.id;
}

String Entity_toString<ID>(EntityValue<ID> this_) {
  return 'Entity(${this_.id}, ${this_.name})';
}

String Entity_toPrettyString<ID>(EntityValue<ID> this_) {
  return Printable_toPrettyString(this_);
}

void Entity_cacheValue<ID>(EntityValue<ID> this_, dynamic value) {
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic Entity_getCachedValue<ID>(EntityValue<ID> this_) {
  return Cacheable_getCachedValue<ID>(this_);
}


class TimestampedEntityValue<ID> extends EntityValue<ID> {
  late int createdAt;
  late int updatedAt;
}

void TimestampedEntity_new<ID>(TimestampedEntityValue<ID> this_, ID id, String name, int createdAt, int updatedAt) {
  Entity_new(this_, id, name);
  this_.vptr = {
    ...this_.vptr,
    'get_label': (self) => TimestampedEntity_get_label<ID>(self),
    'toPrettyString': (self) => TimestampedEntity_toPrettyString<ID>(self),
    'get_cacheKey': (self) => TimestampedEntity_get_cacheKey<ID>(self),
    'cacheValue': (self, _a0) => TimestampedEntity_cacheValue<ID>(self, _a0),
    'getCachedValue': (self) => TimestampedEntity_getCachedValue<ID>(self),
    'toString_': (self) => TimestampedEntity_toString<ID>(self),
    'get_age': (self) => TimestampedEntity_get_age<ID>(self),
  };
  this_.createdAt = createdAt;
  this_.updatedAt = updatedAt;
}

Duration TimestampedEntity_get_age<ID>(TimestampedEntityValue<ID> this_) {
  return Duration(milliseconds: (this_.updatedAt - this_.createdAt));
}

String TimestampedEntity_get_label<ID>(TimestampedEntityValue<ID> this_) {
  return '${this_.name}(${this_.id}, age=${(this_.vptr['get_age'] as Duration Function(TimestampedEntityValue))(this_).inMilliseconds}ms)';
}

String TimestampedEntity_toPrettyString<ID>(TimestampedEntityValue<ID> this_) {
  return Printable_toPrettyString(this_);
}

ID TimestampedEntity_get_cacheKey<ID>(TimestampedEntityValue<ID> this_) {
  return Entity_get_cacheKey<ID>(this_);
}

void TimestampedEntity_cacheValue<ID>(TimestampedEntityValue<ID> this_, dynamic value) {
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic TimestampedEntity_getCachedValue<ID>(TimestampedEntityValue<ID> this_) {
  return Cacheable_getCachedValue<ID>(this_);
}

String TimestampedEntity_toString<ID>(TimestampedEntityValue<ID> this_) {
  return Entity_toString<ID>(this_);
}


class VersionedEntityValue<ID> extends VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> {
  late int _version;
  late List<String> _changelog;
}

void VersionedEntity_new<ID>(VersionedEntityValue<ID> this_, ID id, String name, int createdAt, int updatedAt) {
  TimestampedEntity_new(this_, id, name, createdAt, updatedAt);
  this_.vptr = {
    'get_label': (self) => VersionedEntity_get_label<ID>(self),
    'toPrettyString': (self) => VersionedEntity_toPrettyString<ID>(self),
    'get_cacheKey': (self) => VersionedEntity_get_cacheKey<ID>(self),
    'cacheValue': (self, _a0) => VersionedEntity_cacheValue<ID>(self, _a0),
    'getCachedValue': (self) => VersionedEntity_getCachedValue<ID>(self),
    'toString_': (self) => VersionedEntity_toString<ID>(self),
    'get_age': (self) => VersionedEntity_get_age<ID>(self),
    'serialize': (self) => VersionedEntity_serialize<ID>(self),
    'toJson': (self) => VersionedEntity_toJson<ID>(self),
    'validate': (self) => VersionedEntity_validate<ID>(self),
    'get_isValid': (self) => VersionedEntity_get_isValid<ID>(self),
    'get_version': (self) => VersionedEntity_get_version<ID>(self),
    'bump': (self, _a0) => VersionedEntity_bump<ID>(self, _a0),
    'get_changelog': (self) => VersionedEntity_get_changelog<ID>(self),
  };
  this_._version = 1;
  this_._changelog = <String>[];
}

int VersionedEntity_get_version<ID>(VersionedEntityValue<ID> this_) {
  return this_._version;
}

void VersionedEntity_bump<ID>(VersionedEntityValue<ID> this_, String change) {
  this_._version = (this_._version + 1);
  this_._changelog.add('v${this_._version}: ${change}');
}

List<String> VersionedEntity_get_changelog<ID>(VersionedEntityValue<ID> this_) {
  return List.unmodifiable(this_._changelog);
}

String VersionedEntity_serialize<ID>(VersionedEntityValue<ID> this_) {
  return '${this_.id}:${this_.name}:v${this_._version}';
}

List<String> VersionedEntity_validate<ID>(VersionedEntityValue<ID> this_) {
  final List<String> errors = <String>[];
  if (this_.name.isEmpty)   errors.add('name is empty');
  if ((this_._version < 1))   errors.add('invalid version');
  return errors;
}

String VersionedEntity_get_label<ID>(VersionedEntityValue<ID> this_) {
  return '${this_.name}(v${this_._version})';
}

String VersionedEntity_toPrettyString<ID>(VersionedEntityValue<ID> this_) {
  return Printable_toPrettyString(this_);
}

ID VersionedEntity_get_cacheKey<ID>(VersionedEntityValue<ID> this_) {
  return Entity_get_cacheKey<ID>(this_);
}

void VersionedEntity_cacheValue<ID>(VersionedEntityValue<ID> this_, dynamic value) {
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic VersionedEntity_getCachedValue<ID>(VersionedEntityValue<ID> this_) {
  return Cacheable_getCachedValue<ID>(this_);
}

String VersionedEntity_toString<ID>(VersionedEntityValue<ID> this_) {
  return Entity_toString<ID>(this_);
}

Duration VersionedEntity_get_age<ID>(VersionedEntityValue<ID> this_) {
  return TimestampedEntity_get_age<ID>(this_);
}

String VersionedEntity_toJson<ID>(VersionedEntityValue<ID> this_) {
  return Serializable_toJson<String>(this_);
}

bool VersionedEntity_get_isValid<ID>(VersionedEntityValue<ID> this_) {
  return Validatable_get_isValid(this_);
}


class MoneyValue extends Money_Comparable2_PrintableValue {
  late int cents;
  late String currency;
}

void Money_new(MoneyValue this_, int cents, [String currency = 'USD']) {
  Comparable2_new(this_);
  this_.vptr = {
    'compareTo': Money_compareTo,
    'operatorLt': Money_operatorLt,
    'operatorGt': Money_operatorGt,
    'operatorLte': Money_operatorLte,
    'operatorGte': Money_operatorGte,
    'get_label': Money_get_label,
    'toPrettyString': Money_toPrettyString,
    'operatorPlus': Money_operatorPlus,
    'operatorMinus': Money_operatorMinus,
    'operatorStar': Money_operatorStar,
    'operatorNeg': Money_operatorNeg,
    'toString_': Money_toString,
  };
  this_.cents = cents;
  this_.currency = currency;
}

void Money_new_fromDollars(MoneyValue this_, double dollars, [String currency = 'USD']) {
  Comparable2_new(this_);
  this_.vptr = {
    'compareTo': Money_compareTo,
    'operatorLt': Money_operatorLt,
    'operatorGt': Money_operatorGt,
    'operatorLte': Money_operatorLte,
    'operatorGte': Money_operatorGte,
    'get_label': Money_get_label,
    'toPrettyString': Money_toPrettyString,
    'operatorPlus': Money_operatorPlus,
    'operatorMinus': Money_operatorMinus,
    'operatorStar': Money_operatorStar,
    'operatorNeg': Money_operatorNeg,
    'toString_': Money_toString,
  };
  this_.cents = (dollars * 100).round();
  this_.currency = currency;
}

MoneyValue Money_operatorPlus(MoneyValue this_, MoneyValue other) {
  if (!((this_.currency == other.currency)))   throw ArgumentError('Currency mismatch');
  return (() { final _obj = MoneyValue(); Money_new(_obj, (this_.cents + other.cents), this_.currency); return _obj; })();
}

MoneyValue Money_operatorMinus(MoneyValue this_, MoneyValue other) {
  if (!((this_.currency == other.currency)))   throw ArgumentError('Currency mismatch');
  return (() { final _obj = MoneyValue(); Money_new(_obj, (this_.cents - other.cents), this_.currency); return _obj; })();
}

MoneyValue Money_operatorStar(MoneyValue this_, int factor) {
  return (() { final _obj = MoneyValue(); Money_new(_obj, (this_.cents * factor), this_.currency); return _obj; })();
}

MoneyValue Money_operatorNeg(MoneyValue this_) {
  return (() { final _obj = MoneyValue(); Money_new(_obj, (-this_.cents), this_.currency); return _obj; })();
}

int Money_compareTo(Comparable2Value<MoneyValue> this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return (this_.cents - other.cents);
}

String Money_get_label(MoneyValue this_) {
  return '\$${(this_.cents / 100).toStringAsFixed(2)} ${this_.currency}';
}

String Money_toString(MoneyValue this_) {
  return (this_.vptr['get_label'] as String Function(MoneyValue))(this_);
}

bool Money_operatorLt(MoneyValue this_, MoneyValue other) {
  return Comparable2_operatorLt<MoneyValue>(this_, other);
}

bool Money_operatorGt(MoneyValue this_, MoneyValue other) {
  return Comparable2_operatorGt<MoneyValue>(this_, other);
}

bool Money_operatorLte(MoneyValue this_, MoneyValue other) {
  return Comparable2_operatorLte<MoneyValue>(this_, other);
}

bool Money_operatorGte(MoneyValue this_, MoneyValue other) {
  return Comparable2_operatorGte<MoneyValue>(this_, other);
}

String Money_toPrettyString(MoneyValue this_) {
  return Printable_toPrettyString(this_);
}


class ConfigValue extends VPtr {
  late Map<String, dynamic> _data;
}

void Config_new(ConfigValue this_, Map<String, dynamic> _data) {
  this_.vptr = {
    'operatorIndex': Config_operatorIndex,
    'operatorIndexSet': Config_operatorIndexSet,
    'containsKey': Config_containsKey,
    'get_length': Config_get_length,
    'toString_': Config_toString,
  };
  this_._data = _data;
}

void Config_new_empty(ConfigValue this_) {
  this_.vptr = {
    'operatorIndex': Config_operatorIndex,
    'operatorIndexSet': Config_operatorIndexSet,
    'containsKey': Config_containsKey,
    'get_length': Config_get_length,
    'toString_': Config_toString,
  };
  this_._data = <String, dynamic>{};
}

void Config_new_fromPairs(ConfigValue this_, List<List<dynamic>> pairs) {
  this_.vptr = {
    'operatorIndex': Config_operatorIndex,
    'operatorIndexSet': Config_operatorIndexSet,
    'containsKey': Config_containsKey,
    'get_length': Config_get_length,
    'toString_': Config_toString,
  };
  this_._data = (() {   final Map<String, dynamic> _v0 = <String, dynamic>{};
  for (final p in pairs)   _v0[(p[0] as String)] = p[1];
 return _v0; })();
}

ConfigValue Config_new_withDefaults(Map<String, dynamic> overrides) {
  final Map<String, dynamic> defaults = <String, dynamic>{'debug': false, 'maxRetries': 3, 'timeout': 30, 'name': 'default'};
  defaults.addAll(overrides);
  return (() { final _obj = ConfigValue(); Config_new(_obj, defaults); return _obj; })();
}

dynamic Config_operatorIndex(ConfigValue this_, String key) {
  return this_._data[key];
}

void Config_operatorIndexSet(ConfigValue this_, String key, dynamic value) {
  (() { final _let1 = this_._data; return (() { final _let2 = key; return (() { final _let3 = value; return (() { final _let4 = _let1[_let2] = _let3; return _let3; })(); })(); })(); })();
}

bool Config_containsKey(ConfigValue this_, String key) {
  return this_._data.containsKey(key);
}

int Config_get_length(ConfigValue this_) {
  return this_._data.length;
}

String Config_toString(ConfigValue this_) {
  final List<String> sorted = (this_._data.keys.toList()..sort());
  final Iterable<String> entries = sorted.map(ClosureEnv_anon_0(this_).call);
  return 'Config{${entries.join(', ')}}';
}


class EventBusValue extends VPtr {
  late List<void Function(String)> _listeners;
}

void EventBus_new(EventBusValue this_) {
  this_.vptr = {
    'on': EventBus_on,
    'emit': EventBus_emit,
  };
  this_._listeners = <void Function(String)>[];
}

void EventBus_on(EventBusValue this_, void Function(String) listener) {
  this_._listeners.add(listener);
}

void EventBus_emit(EventBusValue this_, String event) {
  for (final listener in this_._listeners) {
    listener(event);
  }
}


class DrawableValue extends VPtr {
}

void Drawable_new(DrawableValue this_) {
  this_.vptr = {
    'draw': Drawable_draw,
  };
}

void Drawable_draw(DrawableValue this_) {
  throw UnimplementedError('Drawable.draw is abstract');
}


class ResizableValue extends VPtr {
}

void Resizable_new(ResizableValue this_) {
  this_.vptr = {
    'resize': Resizable_resize,
  };
}

void Resizable_resize(ResizableValue this_, double factor) {
  throw UnimplementedError('Resizable.resize is abstract');
}


class ClickableValue extends VPtr {
}

void Clickable_new(ClickableValue this_) {
  this_.vptr = {
    'onClick': Clickable_onClick,
  };
}

void Clickable_onClick(ClickableValue this_) {
  throw UnimplementedError('Clickable.onClick is abstract');
}


class WidgetValue extends VPtr implements DrawableValue, ResizableValue, ClickableValue {
  late String _state;
  late double _scale;
  late int _clickCount;
}

void Widget_new(WidgetValue this_) {
  this_.vptr = {
    'draw': Widget_draw,
    'resize': Widget_resize,
    'onClick': Widget_onClick,
    'get_info': Widget_get_info,
  };
  this_._state = 'idle';
  this_._scale = 1.0;
  this_._clickCount = 0;
}

void Widget_draw(WidgetValue this_) {
  this_._state = 'drawn';
}

void Widget_resize(WidgetValue this_, double factor) {
  this_._scale = (this_._scale * factor);
}

void Widget_onClick(WidgetValue this_) {
  this_._clickCount = (this_._clickCount + 1);
  this_._state = 'clicked(${this_._clickCount})';
}

String Widget_get_info(WidgetValue this_) {
  return 'Widget(state=${this_._state}, scale=${this_._scale.toStringAsFixed(1)}, clicks=${this_._clickCount})';
}


class PairValue<A, B> extends VPtr {
  late A first;
  late B second;
}

void Pair_new<A, B>(PairValue<A, B> this_, A first, B second) {
  this_.vptr = {
    'swap': (self) => Pair_swap<A, B>(self),
    'mapFirst': (self, _a0) => Pair_mapFirst(self, _a0),
    'mapSecond': (self, _a0) => Pair_mapSecond(self, _a0),
    'fold': (self, _a0) => Pair_fold(self, _a0),
    'toString_': (self) => Pair_toString<A, B>(self),
  };
  this_.first = first;
  this_.second = second;
}

PairValue<B, A> Pair_swap<A, B>(PairValue<A, B> this_) {
  return (() { final _obj = PairValue<B, A>(); Pair_new(_obj, this_.second, this_.first); return _obj; })();
}

PairValue<C, B> Pair_mapFirst<A, B, C>(PairValue<A, B> this_, C Function(A) transform) {
  return (() { final _obj = PairValue<C, B>(); Pair_new(_obj, transform(this_.first), this_.second); return _obj; })();
}

PairValue<A, C> Pair_mapSecond<A, B, C>(PairValue<A, B> this_, C Function(B) transform) {
  return (() { final _obj = PairValue<A, C>(); Pair_new(_obj, this_.first, transform(this_.second)); return _obj; })();
}

R Pair_fold<A, B, R>(PairValue<A, B> this_, R Function(A, B) combine) {
  return combine(this_.first, this_.second);
}

String Pair_toString<A, B>(PairValue<A, B> this_) {
  return 'Pair(${this_.first}, ${this_.second})';
}


class TripleValue<A, B, C> extends PairValue<A, B> {
  late C third;
}

void Triple_new<A, B, C>(TripleValue<A, B, C> this_, A first, B second, C third) {
  Pair_new(this_, first, second);
  this_.vptr = {
    ...this_.vptr,
    'swap': (self) => Triple_swap<A, B, C>(self),
    'mapFirst': (self, _a0) => Triple_mapFirst(self, _a0),
    'mapSecond': (self, _a0) => Triple_mapSecond(self, _a0),
    'fold': (self, _a0) => Triple_fold(self, _a0),
    'toString_': (self) => Triple_toString<A, B, C>(self),
  };
  this_.third = third;
}

String Triple_toString<A, B, C>(PairValue<A, B> this__) {
  final this_ = this__ as TripleValue<A, B, C>;
  return 'Triple(${this_.first}, ${this_.second}, ${this_.third})';
}

PairValue<B, A> Triple_swap<A, B, C>(TripleValue<A, B, C> this_) {
  return Pair_swap<A, B>(this_);
}

PairValue<C, B> Triple_mapFirst<A, B, C>(TripleValue<A, B, C> this_, C Function(A) transform) {
  return Pair_mapFirst<A, B, C>(this_, transform);
}

PairValue<A, C> Triple_mapSecond<A, B, C>(TripleValue<A, B, C> this_, C Function(B) transform) {
  return Pair_mapSecond<A, B, C>(this_, transform);
}

R Triple_fold<A, B, C, R>(TripleValue<A, B, C> this_, R Function(A, B) combine) {
  return Pair_fold<A, B, R>(this_, combine);
}


class StringBuilderValue extends VPtr {
  late StringBuffer _buf;
  late String _separator;
}

void StringBuilder_new(StringBuilderValue this_) {
  this_.vptr = {
    'withSeparator': StringBuilder_withSeparator,
    'add': StringBuilder_add,
    'addAll': StringBuilder_addAll,
    'get_length': StringBuilder_get_length,
    'toString_': StringBuilder_toString,
  };
  this_._buf = StringBuffer();
  this_._separator = '';
}

StringBuilderValue StringBuilder_withSeparator(StringBuilderValue this_, String sep) {
  this_._separator = sep;
  return this_;
}

StringBuilderValue StringBuilder_add(StringBuilderValue this_, String text) {
  if ((this_._buf.isNotEmpty && this_._separator.isNotEmpty)) {
    this_._buf.write(this_._separator);
  }
  this_._buf.write(text);
  return this_;
}

StringBuilderValue StringBuilder_addAll(StringBuilderValue this_, List<String> texts) {
  for (final t in texts) {
    (this_.vptr['add'] as StringBuilderValue Function(StringBuilderValue, String))(this_, t);
  }
  return this_;
}

int StringBuilder_get_length(StringBuilderValue this_) {
  return this_._buf.length;
}

String StringBuilder_toString(StringBuilderValue this_) {
  return this_._buf.toString();
}


class AppErrorValue extends VPtr {
  late String message;
  late String code;
  late AppErrorValue? cause;
}

void AppError_new(AppErrorValue this_, String message, String code, [AppErrorValue? cause = null]) {
  this_.vptr = {
    'toString_': AppError_toString,
  };
  this_.message = message;
  this_.code = code;
  this_.cause = cause;
}

String AppError_toString(AppErrorValue this_) {
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

void DataPipeline_new<T>(DataPipelineValue<T> this_, List<T> _data) {
  this_.vptr = {
    'where': (self, _a0) => DataPipeline_where<T>(self, _a0),
    'map': (self, _a0) => DataPipeline_map(self, _a0),
    'sorted': (self, _a0) => DataPipeline_sorted<T>(self, _a0),
    'take': (self, _a0) => DataPipeline_take<T>(self, _a0),
    'fold': (self, _a0, _a1) => DataPipeline_fold(self, _a0, _a1),
    'toList': (self) => DataPipeline_toList<T>(self),
    'toString_': (self) => DataPipeline_toString<T>(self),
  };
  this_._data = _data;
}

DataPipelineValue<T> DataPipeline_where<T>(DataPipelineValue<T> this_, bool Function(T) test) {
  return (() { final _obj = DataPipelineValue<T>(); DataPipeline_new(_obj, this_._data.where(test).toList()); return _obj; })();
}

DataPipelineValue<R> DataPipeline_map<T, R>(DataPipelineValue<T> this_, R Function(T) transform) {
  return (() { final _obj = DataPipelineValue<R>(); DataPipeline_new(_obj, this_._data.map(transform).toList()); return _obj; })();
}

DataPipelineValue<T> DataPipeline_sorted<T>(DataPipelineValue<T> this_, int Function(T, T) compare) {
  final List<T> copy = List.from(this_._data);
  copy.sort(compare);
  return (() { final _obj = DataPipelineValue<T>(); DataPipeline_new(_obj, copy); return _obj; })();
}

DataPipelineValue<T> DataPipeline_take<T>(DataPipelineValue<T> this_, int count) {
  return (() { final _obj = DataPipelineValue<T>(); DataPipeline_new(_obj, this_._data.take(count).toList()); return _obj; })();
}

R DataPipeline_fold<T, R>(DataPipelineValue<T> this_, R initial, R Function(R, T) combine) {
  return this_._data.fold(initial, combine);
}

List<T> DataPipeline_toList<T>(DataPipelineValue<T> this_) {
  return List.unmodifiable(this_._data);
}

String DataPipeline_toString<T>(DataPipelineValue<T> this_) {
  return 'Pipeline(${this_._data})';
}


class BoundedValueValue extends VPtr {
  late double _value;
  late double _min;
  late double _max;
}

void BoundedValue_new(BoundedValueValue this_, double _value, double _min, double _max) {
  this_.vptr = {
    'get_value': BoundedValue_get_value,
    'set_value': BoundedValue_set_value,
    'operatorPlus': BoundedValue_operatorPlus,
    'toString_': BoundedValue_toString,
  };
  this_._value = _value;
  this_._min = _min;
  this_._max = _max;
  BoundedValue__clamp(this_);
}

double BoundedValue_get_value(BoundedValueValue this_) {
  return this_._value;
}

void BoundedValue_set_value(BoundedValueValue this_, double v) {
  this_._value = v;
  BoundedValue__clamp(this_);
}

void BoundedValue__clamp(BoundedValueValue this_) {
  if ((this_._value < this_._min))   this_._value = this_._min;
  if ((this_._value > this_._max))   this_._value = this_._max;
}

BoundedValueValue BoundedValue_operatorPlus(BoundedValueValue this_, double delta) {
  return (() { final _obj = BoundedValueValue(); BoundedValue_new(_obj, (this_._value + delta), this_._min, this_._max); return _obj; })();
}

String BoundedValue_toString(BoundedValueValue this_) {
  return 'BoundedValue(${this_._value}, min=${this_._min}, max=${this_._max})';
}


class MathUtilsValue extends VPtr {
}

const double MathUtils_pi = 3.14159265358979;
int MathUtils__callCount = 0;
void MathUtils_new(MathUtilsValue this_) {
  this_.vptr = {
  };
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
void Loggable_log(dynamic this_, String message) {
  this_._logs.add(message);
}

List<String> Loggable_get_logs(dynamic this_) {
  return List.unmodifiable(this_._logs);
}


// mixin Observable → static functions for delegation
void Observable_observe<T>(dynamic this_, void Function(T) callback) {
  this_._observers.add(callback);
}

void Observable_notify<T>(dynamic this_, T value) {
  for (final cb in this_._observers) {
    cb(value);
  }
}


class ReactiveStoreValue<V> extends ReactiveStore_Object_Loggable_ObservableValue<V> {
  late Map<String, V> _store;
}

void ReactiveStore_new<V>(ReactiveStoreValue<V> this_) {
  this_.vptr = {
    'log': (self, _a0) => ReactiveStore_log<V>(self, _a0),
    'get_logs': (self) => ReactiveStore_get_logs<V>(self),
    'observe': (self, _a0) => ReactiveStore_observe<V>(self, _a0),
    'notify': (self, _a0) => ReactiveStore_notify<V>(self, _a0),
    'get': (self, _a0) => ReactiveStore_get<V>(self, _a0),
    'set': (self, _a0, _a1) => ReactiveStore_set<V>(self, _a0, _a1),
    'get_size': (self) => ReactiveStore_get_size<V>(self),
    'toString_': (self) => ReactiveStore_toString<V>(self),
  };
  this_._logs = <String>[];
  this_._observers = <void Function(V)>[];
  this_._store = <String, V>{};
}

V? ReactiveStore_get<V>(ReactiveStoreValue<V> this_, String key) {
  (this_.vptr['log'] as Function)(this_, 'get: ${key}');
  return this_._store[key];
}

void ReactiveStore_set<V>(ReactiveStoreValue<V> this_, String key, V value) {
  (this_.vptr['log'] as Function)(this_, 'set: ${key}=${value}');
  this_._store[key] = value;
  (this_.vptr['notify'] as Function)(this_, value);
}

int ReactiveStore_get_size<V>(ReactiveStoreValue<V> this_) {
  return this_._store.length;
}

String ReactiveStore_toString<V>(ReactiveStoreValue<V> this_) {
  return 'Store(${this_._store})';
}

void ReactiveStore_log<V>(ReactiveStoreValue<V> this_, String message) {
  Loggable_log(this_, message);
}

List<String> ReactiveStore_get_logs<V>(ReactiveStoreValue<V> this_) {
  return Loggable_get_logs(this_);
}

void ReactiveStore_observe<V>(ReactiveStoreValue<V> this_, void Function(V) callback) {
  Observable_observe<V>(this_, callback);
}

void ReactiveStore_notify<V>(ReactiveStoreValue<V> this_, V value) {
  Observable_notify<V>(this_, value);
}


class ShapeValue extends VPtr {
}

void Shape_new(ShapeValue this_) {
  this_.vptr = {
    'area': Shape_area,
    'get_shapeName': Shape_get_shapeName,
  };
}

double Shape_area(ShapeValue this_) {
  throw UnimplementedError('Shape.area is abstract');
}

String Shape_get_shapeName(ShapeValue this_) {
  throw UnimplementedError('Shape.shapeName is abstract');
}


class CircleValue extends VPtr implements ShapeValue {
  late double radius;
}

void Circle_new(CircleValue this_, double radius) {
  this_.vptr = {
    'area': Circle_area,
    'get_shapeName': Circle_get_shapeName,
    'toString_': Circle_toString,
  };
  this_.radius = radius;
}

double Circle_area(CircleValue this_) {
  return ((3.14159 * this_.radius) * this_.radius);
}

String Circle_get_shapeName(CircleValue this_) {
  return 'Circle';
}

String Circle_toString(CircleValue this_) {
  return 'Circle(r=${this_.radius})';
}


class RectangleValue extends VPtr implements ShapeValue {
  late double width;
  late double height;
}

void Rectangle_new(RectangleValue this_, double width, double height) {
  this_.vptr = {
    'area': Rectangle_area,
    'get_shapeName': Rectangle_get_shapeName,
    'toString_': Rectangle_toString,
  };
  this_.width = width;
  this_.height = height;
}

double Rectangle_area(RectangleValue this_) {
  return (this_.width * this_.height);
}

String Rectangle_get_shapeName(RectangleValue this_) {
  return 'Rectangle';
}

String Rectangle_toString(RectangleValue this_) {
  return 'Rectangle(${this_.width}x${this_.height})';
}


class NodeValue<T> extends VPtr {
  late T value;
  late List<NodeValue<T>> children;
}

void Node_new<T>(NodeValue<T> this_, T value, [List<NodeValue<T>>? children = null]) {
  this_.vptr = {
    'addChild': (self, _a0) => Node_addChild<T>(self, _a0),
    'flatten': (self) => Node_flatten<T>(self),
    'mapTree': (self, _a0) => Node_mapTree(self, _a0),
    'toString_': (self) => Node_toString<T>(self),
  };
  this_.value = value;
  this_.children = (children ?? <NodeValue<T>>[]);
}

void Node_addChild<T>(NodeValue<T> this_, NodeValue<T> child) {
  this_.children.add(child);
}

List<T> Node_flatten<T>(NodeValue<T> this_) {
  final List<T> result = <T>[this_.value];
  for (final child in this_.children) {
    result.addAll((child.vptr['flatten'] as Function)(child));
  }
  return result;
}

NodeValue<R> Node_mapTree<T, R>(NodeValue<T> this_, R Function(T) transform_raw) {
  ObjectBox<R Function(T)> transform = ObjectBox<R Function(T)>(transform_raw);
  return (() { final _obj = NodeValue<R>(); Node_new(_obj, transform.value(this_.value), this_.children.map(ClosureEnv_anon_1(transform).call).toList()); return _obj; })();
}

String Node_toString<T>(NodeValue<T> this_) {
  if (this_.children.isEmpty)   return '${this_.value}';
  return '${this_.value}(${this_.children.join(', ')})';
}


class LabeledNodeValue<T> extends LabeledNode_Node_PrintableValue<T> {
  late String nodeLabel;
}

void LabeledNode_new<T>(LabeledNodeValue<T> this_, String nodeLabel, T value, [List<NodeValue<T>>? children = null]) {
  Node_new(this_, value, children);
  this_.vptr = {
    'addChild': (self, _a0) => LabeledNode_addChild<T>(self, _a0),
    'flatten': (self) => LabeledNode_flatten<T>(self),
    'mapTree': (self, _a0) => LabeledNode_mapTree(self, _a0),
    'toString_': (self) => LabeledNode_toString<T>(self),
    'get_label': (self) => LabeledNode_get_label<T>(self),
    'toPrettyString': (self) => LabeledNode_toPrettyString<T>(self),
  };
  this_.nodeLabel = nodeLabel;
}

String LabeledNode_get_label<T>(LabeledNodeValue<T> this_) {
  return '${this_.nodeLabel}:${this_.value}';
}

String LabeledNode_toString<T>(NodeValue<T> this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return '[${this_.nodeLabel}]${this_.value}';
}

void LabeledNode_addChild<T>(LabeledNodeValue<T> this_, NodeValue<T> child) {
  Node_addChild<T>(this_, child);
}

List<T> LabeledNode_flatten<T>(LabeledNodeValue<T> this_) {
  return Node_flatten<T>(this_);
}

NodeValue<R> LabeledNode_mapTree<T, R>(LabeledNodeValue<T> this_, R Function(T) transform) {
  return Node_mapTree<T, R>(this_, transform);
}

String LabeledNode_toPrettyString<T>(LabeledNodeValue<T> this_) {
  return Printable_toPrettyString(this_);
}


class Entity_Object_PrintableValue extends VPtr {
}


class Entity_Object_Printable_CacheableValue<ID> extends Entity_Object_PrintableValue {
}


class VersionedEntity_TimestampedEntity_SerializableValue<ID> extends TimestampedEntityValue<ID> {
}


class VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> extends VersionedEntity_TimestampedEntity_SerializableValue<ID> {
}


class Money_Comparable2_PrintableValue extends Comparable2Value<MoneyValue> {
}


class ReactiveStore_Object_LoggableValue extends VPtr {
  late List<String> _logs;
}


class ReactiveStore_Object_Loggable_ObservableValue<V> extends ReactiveStore_Object_LoggableValue {
  late List<void Function(V)> _observers;
}


class LabeledNode_Node_PrintableValue<T> extends NodeValue<T> {
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
  final EventBusValue bus = (() { final _obj = EventBusValue(); EventBus_new(_obj); return _obj; })();
  ObjectBox<List<String>> received = ObjectBox<List<String>>(<String>[]);
  (bus.vptr['on'] as void Function(EventBusValue, void Function(String)))(bus, ClosureEnv_testClosureBoxing_8(received).call);
  (bus.vptr['emit'] as void Function(EventBusValue, String))(bus, 'hello');
  (bus.vptr['emit'] as void Function(EventBusValue, String))(bus, 'world');
  log.add('received=${received.value}');
  return log;
}

String testExceptionChain() {
  try {
    try {
      throw (() { final _obj = AppErrorValue(); AppError_new(_obj, 'not found', 'E404'); return _obj; })();
    }
 catch (e) {
      throw (() { final _obj = AppErrorValue(); AppError_new(_obj, 'service failed', 'E500', (e as AppErrorValue)); return _obj; })();
    }
  }
 catch (e) {
    try {
      throw (() { final _obj = AppErrorValue(); AppError_new(_obj, 'gateway error', 'E502', (e as AppErrorValue)); return _obj; })();
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
    return '${(shape.vptr['get_shapeName'] as String Function(CircleValue))(shape)}: r=${shape.radius}, area=${(shape.vptr['area'] as Function)(shape).toStringAsFixed(2)}';
  }
 else   if ((shape is RectangleValue)) {
    return '${(shape.vptr['get_shapeName'] as String Function(RectangleValue))(shape)}: ${shape.width}x${shape.height}, area=${(shape.vptr['area'] as Function)(shape).toStringAsFixed(2)}';
  }
  return 'Unknown shape: area=${(shape.vptr['area'] as double Function(ShapeValue))(shape)}';
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
  final int doubled = applyTransform(21, (int x) => (x * 2));
  print('applyTransform: ${doubled}');
  final List<int> evens = filterWith(<int>[1, 2, 3, 4, 5, 6], (int x) => ((x % 2) == 0));
  print('filterWith: ${evens}');
  final int sum = reduceList(<int>[1, 2, 3, 4, 5], (int a, int b) => (a + b));
  print('reduceList: ${sum}');
  print('\n--- 2. 枚举类 ---');
  print('red hex: ${Color_get_hex(Color.red)}');
  print('green isWarm: ${Color_get_isWarm(Color.green)}');
  print('priorities: ${const [Priority.low, Priority.medium, Priority.high, Priority.critical].map((Priority p) => '${p}'.split('.').last).toList()}');
  print('\n--- 3. 运算符重载 ---');
  final MoneyValue price1 = (() { final _obj = MoneyValue(); Money_new(_obj, 1099, 'USD'); return _obj; })();
  final MoneyValue price2 = (() { final _obj = MoneyValue(); Money_new_fromDollars(_obj, 5.5); return _obj; })();
  final MoneyValue total = (price1.vptr['operatorPlus'] as MoneyValue Function(MoneyValue, MoneyValue))(price1, price2);
  final MoneyValue negated = (price2.vptr['operatorNeg'] as MoneyValue Function(MoneyValue))(price2);
  print('price1: ${(price1.vptr['toPrettyString'] as Function)(price1)}');
  print('price2: ${price2}');
  print('total: ${total}');
  print('negated: ${negated}');
  print('price1 > price2: ${(price1.vptr['operatorGt'] as bool Function(MoneyValue, MoneyValue))(price1, price2)}');
  print('price1 < price2: ${(price1.vptr['operatorLt'] as bool Function(MoneyValue, MoneyValue))(price1, price2)}');
  print('price1 * 3: ${(price1.vptr['operatorStar'] as MoneyValue Function(MoneyValue, int))(price1, 3)}');
  print('\n--- 4. 多层泛型继承 ---');
  final EntityValue<int> entity = (() { final _obj = EntityValue<int>(); Entity_new(_obj, 1, 'alice'); return _obj; })();
  print('entity: ${entity}');
  print('entity label: ${(entity.vptr['toPrettyString'] as Function)(entity)}');
  (entity.vptr['cacheValue'] as Function)(entity, 'cached_data');
  print('cached: ${(entity.vptr['getCachedValue'] as Function)(entity)}');
  final TimestampedEntityValue<String> tsEntity = (() { final _obj = TimestampedEntityValue<String>(); TimestampedEntity_new(_obj, 'u1', 'bob', 1000, 2000); return _obj; })();
  print('tsEntity label: ${(tsEntity.vptr['toPrettyString'] as Function)(tsEntity)}');
  final VersionedEntityValue<int> vEntity = (() { final _obj = VersionedEntityValue<int>(); VersionedEntity_new(_obj, 42, 'project', 1000, 5000); return _obj; })();
  (vEntity.vptr['bump'] as Function)(vEntity, 'initial release');
  (vEntity.vptr['bump'] as Function)(vEntity, 'bug fix');
  print('vEntity label: ${(vEntity.vptr['toPrettyString'] as Function)(vEntity)}');
  print('vEntity version: ${(vEntity.vptr['get_version'] as int Function(VersionedEntityValue))(vEntity)}');
  print('vEntity changelog: ${(vEntity.vptr['get_changelog'] as List<String> Function(VersionedEntityValue))(vEntity)}');
  print('vEntity serialize: ${(vEntity.vptr['serialize'] as Function)(vEntity)}');
  print('vEntity toJson: ${(vEntity.vptr['toJson'] as Function)(vEntity)}');
  print('vEntity isValid: ${(vEntity.vptr['get_isValid'] as bool Function(VersionedEntityValue))(vEntity)}');
  print('vEntity validate: ${(vEntity.vptr['validate'] as Function)(vEntity)}');
  print('\n--- 5. 工厂构造 ---');
  final ConfigValue cfg1 = (() { final _obj = ConfigValue(); Config_new_empty(_obj); return _obj; })();
  (cfg1.vptr['operatorIndexSet'] as void Function(ConfigValue, String, dynamic))(cfg1, 'host', 'localhost');
  print('cfg1: ${cfg1}');
  final ConfigValue cfg2 = (() { final _obj = ConfigValue(); Config_new_fromPairs(_obj, <List<dynamic>>[['a', 1], ['b', 2]]); return _obj; })();
  print('cfg2: ${cfg2}');
  final ConfigValue cfg3 = Config_new_withDefaults(<String, dynamic>{'debug': true, 'name': 'prod'});
  print('cfg3: ${cfg3}');
  print('cfg3[maxRetries]: ${(cfg3.vptr['operatorIndex'] as dynamic Function(ConfigValue, String))(cfg3, 'maxRetries')}');
  print('\n--- 6. 闭包 Box 化 ---');
  final List<String> closureLog = testClosureBoxing();
  for (final line in closureLog) {
    print(line);
  }
  print('\n--- 7. 多重 implements ---');
  final WidgetValue widget = (() { final _obj = WidgetValue(); Widget_new(_obj); return _obj; })();
  (widget.vptr['draw'] as Function)(widget);
  (widget.vptr['resize'] as Function)(widget, 1.5);
  (widget.vptr['onClick'] as Function)(widget);
  (widget.vptr['onClick'] as Function)(widget);
  print('widget: ${(widget.vptr['get_info'] as String Function(WidgetValue))(widget)}');
  print('\n--- 8. 泛型 Pair ---');
  final PairValue<int, String> pair = (() { final _obj = PairValue<int, String>(); Pair_new(_obj, 42, 'hello'); return _obj; })();
  print('pair: ${pair}');
  print('swap: ${(pair.vptr['swap'] as Function)(pair)}');
  print('mapFirst: ${Pair_mapFirst<int, String, int>(pair, (int x) => (x * 2))}');
  print('mapSecond: ${Pair_mapSecond<int, String, String>(pair, (String s) => s.toUpperCase())}');
  print('fold: ${Pair_fold<int, String, String>(pair, (int a, String b) => '${b}=${a}')}');
  final TripleValue<int, String, bool> triple = (() { final _obj = TripleValue<int, String, bool>(); Triple_new(_obj, 1, 'yes', true); return _obj; })();
  print('triple: ${triple}');
  print('\n--- 9. 级联操作 ---');
  final StringBuilderValue sb = (() { final _let7 = (() { final _obj = StringBuilderValue(); StringBuilder_new(_obj); return _obj; })(); (_let7.vptr['withSeparator'] as StringBuilderValue Function(StringBuilderValue, String))(_let7, ', '); (_let7.vptr['add'] as StringBuilderValue Function(StringBuilderValue, String))(_let7, 'alpha'); (_let7.vptr['add'] as StringBuilderValue Function(StringBuilderValue, String))(_let7, 'beta'); (_let7.vptr['addAll'] as StringBuilderValue Function(StringBuilderValue, List<String>))(_let7, <String>['gamma', 'delta']); return _let7; })();
  print('builder: ${sb}');
  print('length: ${(sb.vptr['get_length'] as int Function(StringBuilderValue))(sb)}');
  print('\n--- 10. 异常处理链 ---');
  print('chain: ${testExceptionChain()}');
  print('\n--- 11. 集合操作 ---');
  final DataPipelineValue<int> pipeline = DataPipeline_map<int, int>(((((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]); return _obj; })().vptr['where'] as Function)((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]); return _obj; })(), (int x) => (x > 2)).vptr['sorted'] as Function)(((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]); return _obj; })().vptr['where'] as Function)((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]); return _obj; })(), (int x) => (x > 2)), (int a, int b) => (a - b)).vptr['take'] as Function)((((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]); return _obj; })().vptr['where'] as Function)((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]); return _obj; })(), (int x) => (x > 2)).vptr['sorted'] as Function)(((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]); return _obj; })().vptr['where'] as Function)((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[5, 3, 8, 1, 9, 2, 7, 4, 6]); return _obj; })(), (int x) => (x > 2)), (int a, int b) => (a - b)), 5), (int x) => (x * 10));
  print('pipeline: ${(pipeline.vptr['toList'] as Function)(pipeline)}');
  final int pipeSum = DataPipeline_fold<int, int>((() { final _obj = DataPipelineValue<int>(); DataPipeline_new(_obj, <int>[1, 2, 3, 4, 5]); return _obj; })(), 0, (int acc, int x) => (acc + x));
  print('pipeSum: ${pipeSum}');
  print('\n--- 12. 可选参数 ---');
  print(formatRecord(name: 'Alice', age: 30, email: 'alice@test.com'));
  print(formatRecord(name: 'Bob', tags: <String>['admin', 'vip']));
  print(greetAll('Hello'));
  print(greetAll('Hi', 'Dart', '!!'));
  print('\n--- 13. BoundedValue ---');
  final BoundedValueValue bv = (() { final _obj = BoundedValueValue(); BoundedValue_new(_obj, 5.0, 0.0, 10.0); return _obj; })();
  print('bv: ${bv}');
  (bv.vptr['set_value'] as void Function(BoundedValueValue, double))(bv, 15.0);
  print('after set 15: ${bv}');
  (bv.vptr['set_value'] as void Function(BoundedValueValue, double))(bv, (-5.0));
  print('after set -5: ${bv}');
  final BoundedValueValue bv2 = (bv.vptr['operatorPlus'] as BoundedValueValue Function(BoundedValueValue, double))(bv, 7.0);
  print('bv + 7: ${bv2}');
  print('\n--- 14. 静态方法 ---');
  print('5! = ${MathUtils_factorial(5)}');
  print('fib(8): ${MathUtils_fibonacci(8)}');
  print('lerp(0,100,0.3): ${MathUtils_lerp(0.0, 100.0, 0.3)}');
  print('callCount: ${MathUtils_callCount()}');
  print('\n--- 15. ReactiveStore ---');
  final ReactiveStoreValue<int> store = (() { final _obj = ReactiveStoreValue<int>(); ReactiveStore_new(_obj); return _obj; })();
  ObjectBox<List<int>> observed = ObjectBox<List<int>>(<int>[]);
  (store.vptr['observe'] as Function)(store, ClosureEnv_main_10(observed).call);
  (store.vptr['set'] as Function)(store, 'x', 10);
  (store.vptr['set'] as Function)(store, 'y', 20);
  print('store: ${store}');
  print('store.get(x): ${(store.vptr['get'] as Function)(store, 'x')}');
  print('store.size: ${(store.vptr['get_size'] as int Function(ReactiveStoreValue))(store)}');
  print('observed: ${observed.value}');
  print('logs: ${(store.vptr['get_logs'] as List<String> Function(ReactiveStoreValue))(store)}');
  print('\n--- 16. 类型转换 ---');
  final List<ShapeValue> shapes = <ShapeValue>[(() { final _obj = CircleValue(); Circle_new(_obj, 5.0); return _obj; })(), (() { final _obj = RectangleValue(); Rectangle_new(_obj, 3.0, 4.0); return _obj; })(), (() { final _obj = CircleValue(); Circle_new(_obj, 1.0); return _obj; })()];
  for (final s in shapes) {
    print(describeShape(s));
  }
  print('\n--- 17. 树结构 ---');
  final NodeValue<int> tree = (() { final _obj = NodeValue<int>(); Node_new(_obj, 1, <NodeValue<int>>[(() { final _obj = NodeValue<int>(); Node_new(_obj, 2, <NodeValue<int>>[(() { final _obj = NodeValue<int>(); Node_new(_obj, 4); return _obj; })(), (() { final _obj = NodeValue<int>(); Node_new(_obj, 5); return _obj; })()]); return _obj; })(), (() { final _obj = NodeValue<int>(); Node_new(_obj, 3, <NodeValue<int>>[(() { final _obj = NodeValue<int>(); Node_new(_obj, 6); return _obj; })()]); return _obj; })()]); return _obj; })();
  print('tree: ${tree}');
  print('flatten: ${(tree.vptr['flatten'] as Function)(tree)}');
  final NodeValue<String> strTree = Node_mapTree<int, String>(tree, (int x) => 'N${x}');
  print('mapped: ${strTree}');
  final LabeledNodeValue<int> labeled = (() { final _obj = LabeledNodeValue<int>(); LabeledNode_new(_obj, 'root', 100); return _obj; })();
  (labeled.vptr['addChild'] as Function)(labeled, (() { final _obj = NodeValue<int>(); Node_new(_obj, 200); return _obj; })());
  (labeled.vptr['addChild'] as Function)(labeled, (() { final _obj = NodeValue<int>(); Node_new(_obj, 300); return _obj; })());
  print('labeled: ${labeled}');
  print('labeled pretty: ${(labeled.vptr['toPrettyString'] as Function)(labeled)}');
  print('labeled flatten: ${(labeled.vptr['flatten'] as Function)(labeled)}');
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
  ObjectBox<R Function(T)> transform;
  ClosureEnv_anon_1(this.transform);
  NodeValue<R> call(NodeValue<T> c) => ClosureEnv_anon_1_call<R, T>(this, c);
}
NodeValue<R> ClosureEnv_anon_1_call<R, T>(ClosureEnv_anon_1<R, T> env, NodeValue<T> c) {
  return Node_mapTree<T, R>(c, env.transform.value);
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
  ObjectBox<List<String>> received;
  ClosureEnv_testClosureBoxing_7(this.received);
  void call(String event) => ClosureEnv_testClosureBoxing_7_call(this, event);
}
void ClosureEnv_testClosureBoxing_7_call(ClosureEnv_testClosureBoxing_7 env, String event) {
    env.received.value.add(event);
  }

class ClosureEnv_testClosureBoxing_8 {
  ObjectBox<List<String>> received;
  ClosureEnv_testClosureBoxing_8(this.received);
  void call(String event) => ClosureEnv_testClosureBoxing_8_call(this, event);
}
void ClosureEnv_testClosureBoxing_8_call(ClosureEnv_testClosureBoxing_8 env, String event) {
    env.received.value.add(event);
  }

class ClosureEnv_main_9 {
  ObjectBox<List<int>> observed;
  ClosureEnv_main_9(this.observed);
  void call(int v) => ClosureEnv_main_9_call(this, v);
}
void ClosureEnv_main_9_call(ClosureEnv_main_9 env, int v) {
    env.observed.value.add(v);
  }

class ClosureEnv_main_10 {
  ObjectBox<List<int>> observed;
  ClosureEnv_main_10(this.observed);
  void call(int v) => ClosureEnv_main_10_call(this, v);
}
void ClosureEnv_main_10_call(ClosureEnv_main_10 env, int v) {
    env.observed.value.add(v);
  }


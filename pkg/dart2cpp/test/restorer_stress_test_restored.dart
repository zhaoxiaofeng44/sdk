import 'package:dart2cpp/platform/dart/runtime_classes.dart';

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
  _L0: do {
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

class Comparable2ClassInfo<T> extends ClassInfo {
  Function? compareTo;
  Function? operatorLt;
  Function? operatorGt;
  Function? operatorLte;
  Function? operatorGte;
}

class Comparable2Value<T> extends AnyGC {
  @override
  ClassInfo get classInfo => Comparable2ClassInfo<T>();
}

Comparable2Value<T> Comparable2_new<T>(AnyGC this__) {
  final this_ = this__ as Comparable2Value<T>;
  return this_;
}

int Comparable2_compareTo<T>(dynamic this_, T other) {
  throw UnimplementedError('Comparable2.compareTo is abstract');
}

bool Comparable2_operatorLt<T>(AnyGC this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.classInfo as Comparable2ClassInfo).compareTo!(this_, other) < 0);
}

bool Comparable2_operatorGt<T>(AnyGC this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.classInfo as Comparable2ClassInfo).compareTo!(this_, other) > 0);
}

bool Comparable2_operatorLte<T>(AnyGC this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.classInfo as Comparable2ClassInfo).compareTo!(this_, other) <= 0);
}

bool Comparable2_operatorGte<T>(AnyGC this__, T other) {
  final this_ = this__ as Comparable2Value<T>;
  return ((this_.classInfo as Comparable2ClassInfo).compareTo!(this_, other) >= 0);
}


// mixin Printable → static functions for delegation
String Printable_toPrettyString(AnyGC this__) {
  final dynamic this_ = this__;
  return '[${(this_.classInfo as dynamic).get_label!(this_)}]';
}


// mixin Serializable → static functions for delegation
String Serializable_toJson<T>(AnyGC this__) {
  final dynamic this_ = this__;
  return '{"data": "${(this_.classInfo as dynamic).serialize!(this_)}"}';
}


// mixin Cacheable → static functions for delegation
final StaticMap<String, dynamic> Cacheable__cache = StaticMap<String, dynamic>.of({});
void Cacheable_cacheValue<K>(AnyGC this__, dynamic value) {
  final dynamic this_ = this__;
  Cacheable__cache['${(this_.classInfo as dynamic).get_cacheKey!(this_)}'] = value;
}

dynamic Cacheable_getCachedValue<K>(AnyGC this__) {
  final dynamic this_ = this__;
  return Cacheable__cache['${(this_.classInfo as dynamic).get_cacheKey!(this_)}'];
}


// mixin Validatable → static functions for delegation
bool Validatable_get_isValid(AnyGC this__) {
  final dynamic this_ = this__;
  return (this_.classInfo as dynamic).validate!(this_).isEmpty;
}


class EntityClassInfo<ID> extends Entity_Object_Printable_CacheableClassInfo<ID> {
}

class EntityValue<ID> extends Entity_Object_Printable_CacheableValue<ID> {
  late ID id;
  late String name;
  @override
  ClassInfo get classInfo {
    final ci = EntityClassInfo<ID>();
    ci.get_label = Entity_get_label<ID>;
    ci.toPrettyString = Entity_toPrettyString<ID>;
    ci.get_cacheKey = Entity_get_cacheKey<ID>;
    ci.cacheValue = Entity_cacheValue<ID>;
    ci.getCachedValue = Entity_getCachedValue<ID>;
    ci.toString_ = Entity_toString<ID>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (id is AnyGC) (id as AnyGC).gcMark(flag);
  }
}

EntityValue<ID> Entity_new<ID>(AnyGC this__, ID id, String name) {
  final this_ = this__ as EntityValue<ID>;
  this_.id = id;
  this_.name = name;
  return this_;
}

String Entity_get_label<ID>(AnyGC this__) {
  final this_ = this__ as EntityValue<ID>;
  return '${this_.name}(${this_.id})';
}

ID Entity_get_cacheKey<ID>(AnyGC this__) {
  final this_ = this__ as EntityValue<ID>;
  return this_.id;
}

String Entity_toString<ID>(AnyGC this__) {
  final this_ = this__ as EntityValue<ID>;
  return 'Entity(${this_.id}, ${this_.name})';
}

String Entity_toPrettyString<ID>(AnyGC this__) {
  final this_ = this__ as EntityValue<ID>;
  return Printable_toPrettyString(this_);
}

void Entity_cacheValue<ID>(AnyGC this__, dynamic value) {
  final this_ = this__ as EntityValue<ID>;
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic Entity_getCachedValue<ID>(AnyGC this__) {
  final this_ = this__ as EntityValue<ID>;
  return Cacheable_getCachedValue<ID>(this_);
}


class TimestampedEntityClassInfo<ID> extends EntityClassInfo<ID> {
  Function? get_age;
}

class TimestampedEntityValue<ID> extends EntityValue<ID> {
  late int createdAt;
  late int updatedAt;
  @override
  ClassInfo get classInfo {
    final ci = TimestampedEntityClassInfo<ID>();
    ci.get_label = TimestampedEntity_get_label<ID>;
    ci.toPrettyString = TimestampedEntity_toPrettyString<ID>;
    ci.get_cacheKey = TimestampedEntity_get_cacheKey<ID>;
    ci.cacheValue = TimestampedEntity_cacheValue<ID>;
    ci.getCachedValue = TimestampedEntity_getCachedValue<ID>;
    ci.toString_ = TimestampedEntity_toString<ID>;
    ci.get_age = TimestampedEntity_get_age<ID>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

TimestampedEntityValue<ID> TimestampedEntity_new<ID>(AnyGC this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  Entity_new<ID>(this_, id, name);
  this_.createdAt = createdAt;
  this_.updatedAt = updatedAt;
  return this_;
}

StaticDuration TimestampedEntity_get_age<ID>(AnyGC this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return StaticDuration(milliseconds: (this_.updatedAt - this_.createdAt));
}

String TimestampedEntity_get_label<ID>(AnyGC this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return '${this_.name}(${this_.id}, age=${(this_.classInfo as TimestampedEntityClassInfo).get_age!(this_).inMilliseconds}ms)';
}

String TimestampedEntity_toPrettyString<ID>(AnyGC this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Printable_toPrettyString(this_);
}

ID TimestampedEntity_get_cacheKey<ID>(AnyGC this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Entity_get_cacheKey<ID>(this_);
}

void TimestampedEntity_cacheValue<ID>(AnyGC this__, dynamic value) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic TimestampedEntity_getCachedValue<ID>(AnyGC this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Cacheable_getCachedValue<ID>(this_);
}

String TimestampedEntity_toString<ID>(AnyGC this__) {
  final this_ = this__ as TimestampedEntityValue<ID>;
  return Entity_toString<ID>(this_);
}


class VersionedEntityClassInfo<ID> extends VersionedEntity_TimestampedEntity_Serializable_ValidatableClassInfo<ID> {
  Function? get_version;
  Function? bump;
  Function? get_changelog;
}

class VersionedEntityValue<ID> extends VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> {
  late int _version;
  late StaticList<String> _changelog;
  @override
  ClassInfo get classInfo {
    final ci = VersionedEntityClassInfo<ID>();
    ci.get_label = VersionedEntity_get_label<ID>;
    ci.toPrettyString = VersionedEntity_toPrettyString<ID>;
    ci.get_cacheKey = VersionedEntity_get_cacheKey<ID>;
    ci.cacheValue = VersionedEntity_cacheValue<ID>;
    ci.getCachedValue = VersionedEntity_getCachedValue<ID>;
    ci.toString_ = VersionedEntity_toString<ID>;
    ci.get_age = VersionedEntity_get_age<ID>;
    ci.serialize = VersionedEntity_serialize<ID>;
    ci.toJson = VersionedEntity_toJson<ID>;
    ci.validate = VersionedEntity_validate<ID>;
    ci.get_isValid = VersionedEntity_get_isValid<ID>;
    ci.get_version = VersionedEntity_get_version<ID>;
    ci.bump = VersionedEntity_bump<ID>;
    ci.get_changelog = VersionedEntity_get_changelog<ID>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_changelog is AnyGC) (_changelog as AnyGC).gcMark(flag);
  }
}

VersionedEntityValue<ID> VersionedEntity_new<ID>(AnyGC this__, ID id, String name, int createdAt, int updatedAt) {
  final this_ = this__ as VersionedEntityValue<ID>;
  TimestampedEntity_new<ID>(this_, id, name, createdAt, updatedAt);
  this_._version = 1;
  this_._changelog = StaticList<String>();
  return this_;
}

int VersionedEntity_get_version<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return this_._version;
}

void VersionedEntity_bump<ID>(AnyGC this__, String change) {
  final this_ = this__ as VersionedEntityValue<ID>;
  this_._version = (this_._version + 1);
  this_._changelog.add('v${this_._version}: ${change}');
}

StaticList<String> VersionedEntity_get_changelog<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return StaticList<String>.unmodifiable(this_._changelog);
}

String VersionedEntity_serialize<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return '${this_.id}:${this_.name}:v${this_._version}';
}

StaticList<String> VersionedEntity_validate<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  final StaticList<String> errors = StaticList<String>();
  if (this_.name.isEmpty)   errors.add('name is empty');
  if ((this_._version < 1))   errors.add('invalid version');
  return errors;
}

String VersionedEntity_get_label<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return '${this_.name}(v${this_._version})';
}

String VersionedEntity_toPrettyString<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Printable_toPrettyString(this_);
}

ID VersionedEntity_get_cacheKey<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Entity_get_cacheKey<ID>(this_);
}

void VersionedEntity_cacheValue<ID>(AnyGC this__, dynamic value) {
  final this_ = this__ as VersionedEntityValue<ID>;
  Cacheable_cacheValue<ID>(this_, value);
}

dynamic VersionedEntity_getCachedValue<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Cacheable_getCachedValue<ID>(this_);
}

String VersionedEntity_toString<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Entity_toString<ID>(this_);
}

StaticDuration VersionedEntity_get_age<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return TimestampedEntity_get_age<ID>(this_);
}

String VersionedEntity_toJson<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Serializable_toJson<String>(this_);
}

bool VersionedEntity_get_isValid<ID>(AnyGC this__) {
  final this_ = this__ as VersionedEntityValue<ID>;
  return Validatable_get_isValid(this_);
}


class MoneyClassInfo extends Money_Comparable2_PrintableClassInfo {
  Function? operatorPlus;
  Function? operatorMinus;
  Function? operatorStar;
  Function? operatorNeg;
}

class MoneyValue extends Money_Comparable2_PrintableValue {
  late int cents;
  late String currency;
  static MoneyClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MoneyClassInfo _initClassInfo() {
    final ci = MoneyClassInfo();
    ci.compareTo = Money_compareTo;
    ci.operatorLt = Money_operatorLt;
    ci.operatorGt = Money_operatorGt;
    ci.operatorLte = Money_operatorLte;
    ci.operatorGte = Money_operatorGte;
    ci.get_label = Money_get_label;
    ci.toPrettyString = Money_toPrettyString;
    ci.operatorPlus = Money_operatorPlus;
    ci.operatorMinus = Money_operatorMinus;
    ci.operatorStar = Money_operatorStar;
    ci.operatorNeg = Money_operatorNeg;
    ci.toString_ = Money_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

MoneyValue Money_new(AnyGC this__, int cents, [String currency = 'USD']) {
  final this_ = this__ as MoneyValue;
  Comparable2_new<MoneyValue>(this_);
  this_.cents = cents;
  this_.currency = currency;
  return this_;
}

MoneyValue Money_new_fromDollars(AnyGC this__, double dollars, [String currency = 'USD']) {
  final this_ = this__ as MoneyValue;
  Comparable2_new<MoneyValue>(this_);
  this_.cents = (dollars * 100).round();
  this_.currency = currency;
  return this_;
}

MoneyValue Money_operatorPlus(AnyGC this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  if (!((this_.currency == other.currency)))   throw DartArgumentError('Currency mismatch');
  return Money_new(GC.allocateLocal(MoneyValue()), (this_.cents + other.cents), this_.currency);
}

MoneyValue Money_operatorMinus(AnyGC this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  if (!((this_.currency == other.currency)))   throw DartArgumentError('Currency mismatch');
  return Money_new(GC.allocateLocal(MoneyValue()), (this_.cents - other.cents), this_.currency);
}

MoneyValue Money_operatorStar(AnyGC this__, int factor) {
  final this_ = this__ as MoneyValue;
  return Money_new(GC.allocateLocal(MoneyValue()), (this_.cents * factor), this_.currency);
}

MoneyValue Money_operatorNeg(AnyGC this__) {
  final this_ = this__ as MoneyValue;
  return Money_new(GC.allocateLocal(MoneyValue()), (-this_.cents), this_.currency);
}

int Money_compareTo(AnyGC this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return (this_.cents - other.cents);
}

String Money_get_label(AnyGC this__) {
  final this_ = this__ as MoneyValue;
  return '\$${(this_.cents / 100).toStringAsFixed(2)} ${this_.currency}';
}

String Money_toString(AnyGC this__) {
  final this_ = this__ as MoneyValue;
  return (this_.classInfo as MoneyClassInfo).get_label!(this_);
}

bool Money_operatorLt(AnyGC this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return Comparable2_operatorLt<MoneyValue>(this_, other);
}

bool Money_operatorGt(AnyGC this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return Comparable2_operatorGt<MoneyValue>(this_, other);
}

bool Money_operatorLte(AnyGC this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return Comparable2_operatorLte<MoneyValue>(this_, other);
}

bool Money_operatorGte(AnyGC this__, MoneyValue other) {
  final this_ = this__ as MoneyValue;
  return Comparable2_operatorGte<MoneyValue>(this_, other);
}

String Money_toPrettyString(AnyGC this__) {
  final this_ = this__ as MoneyValue;
  return Printable_toPrettyString(this_);
}


class ConfigClassInfo extends ClassInfo {
  Function? operatorIndex;
  Function? operatorIndexSet;
  Function? containsKey;
  Function? get_length;
}

class ConfigValue extends AnyGC {
  late StaticMap<String, dynamic> _data;
  static ConfigClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ConfigClassInfo _initClassInfo() {
    final ci = ConfigClassInfo();
    ci.operatorIndex = Config_operatorIndex;
    ci.operatorIndexSet = Config_operatorIndexSet;
    ci.containsKey = Config_containsKey;
    ci.get_length = Config_get_length;
    ci.toString_ = Config_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_data is AnyGC) (_data as AnyGC).gcMark(flag);
  }
}

ConfigValue Config_new(AnyGC this__, StaticMap<String, dynamic> _data) {
  final this_ = this__ as ConfigValue;
  this_._data = _data;
  return this_;
}

ConfigValue Config_new_empty(AnyGC this__) {
  final this_ = this__ as ConfigValue;
  this_._data = StaticMap<String, dynamic>.of({});
  return this_;
}

ConfigValue Config_new_fromPairs(AnyGC this__, StaticList<StaticList<dynamic>> pairs) {
  final this_ = this__ as ConfigValue;
  this_._data = (() {   final StaticMap<String, dynamic> _v1 = StaticMap<String, dynamic>.of({});
{
    StaticIterator<StaticList<dynamic>> sync_for_iterator = StaticIterator(pairs.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final StaticList<dynamic> p = StaticList<dynamic>.of(sync_for_iterator.current);
      _v1[(p[0] as String)] = p[1];
    }
  }
 return _v1; })();
  return this_;
}

ConfigValue Config_new_withDefaults(StaticMap<String, dynamic> overrides) {
  final StaticMap<String, dynamic> defaults = StaticMap<String, dynamic>.of({'debug': false, 'maxRetries': 3, 'timeout': 30, 'name': 'default'});
  defaults.addAll(overrides);
  return Config_new(GC.allocateLocal(ConfigValue()), defaults);
}

dynamic Config_operatorIndex(AnyGC this__, String key) {
  final this_ = this__ as ConfigValue;
  return this_._data[key];
}

void Config_operatorIndexSet(AnyGC this__, String key, AnyGC value) {
  final this_ = this__ as ConfigValue;
  (() { final _let2 = this_._data; return (() { final _let3 = key; return (() { final _let4 = value; return (() { final _let5 = _let2[_let3] = _let4; return _let4; })(); })(); })(); })();
}

bool Config_containsKey(AnyGC this__, String key) {
  final this_ = this__ as ConfigValue;
  return this_._data.containsKey(key);
}

int Config_get_length(AnyGC this__) {
  final this_ = this__ as ConfigValue;
  return this_._data.length;
}

String Config_toString(AnyGC this__) {
  final this_ = this__ as ConfigValue;
  final StaticList<String> sorted = (StaticList.of(this_._data.keys.toList())..sort());
  final Iterable<String> entries = sorted.map(ClosureEnv_anon_0_new(GC.allocateLocal(ClosureEnv_anon_0()), this_));
  return 'Config{${entries.join(', ')}}';
}


class EventBusClassInfo extends ClassInfo {
  Function? on;
  Function? emit;
}

class EventBusValue extends AnyGC {
  late StaticList<TypeFunction1<void, String>> _listeners = StaticList<TypeFunction1<void, String>>();
  static EventBusClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static EventBusClassInfo _initClassInfo() {
    final ci = EventBusClassInfo();
    ci.on = EventBus_on;
    ci.emit = EventBus_emit;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_listeners is AnyGC) (_listeners as AnyGC).gcMark(flag);
  }
}

EventBusValue EventBus_new(AnyGC this__) {
  final this_ = this__ as EventBusValue;
  return this_;
}

void EventBus_on(AnyGC this__, TypeFunction1<void, String> listener) {
  final this_ = this__ as EventBusValue;
  this_._listeners.add(listener);
}

void EventBus_emit(AnyGC this__, String event) {
  final this_ = this__ as EventBusValue;
{
    StaticIterator<TypeFunction1<void, String>> sync_for_iterator = StaticIterator(this_._listeners.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final TypeFunction1<void, String> listener = sync_for_iterator.current;
{
        listener.call(event);
      }
    }
  }
}


class DrawableClassInfo extends ClassInfo {
  Function? draw;
}

class DrawableValue extends AnyGC {
  static DrawableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DrawableClassInfo _initClassInfo() {
    final ci = DrawableClassInfo();
    ci.draw = Drawable_draw;
    return ci;
  }
}

DrawableValue Drawable_new(AnyGC this__) {
  final this_ = this__ as DrawableValue;
  return this_;
}

void Drawable_draw(dynamic this_) {
  throw UnimplementedError('Drawable.draw is abstract');
}


class ResizableClassInfo extends ClassInfo {
  Function? resize;
}

class ResizableValue extends AnyGC {
  static ResizableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ResizableClassInfo _initClassInfo() {
    final ci = ResizableClassInfo();
    ci.resize = Resizable_resize;
    return ci;
  }
}

ResizableValue Resizable_new(AnyGC this__) {
  final this_ = this__ as ResizableValue;
  return this_;
}

void Resizable_resize(dynamic this_, double factor) {
  throw UnimplementedError('Resizable.resize is abstract');
}


class ClickableClassInfo extends ClassInfo {
  Function? onClick;
}

class ClickableValue extends AnyGC {
  static ClickableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ClickableClassInfo _initClassInfo() {
    final ci = ClickableClassInfo();
    ci.onClick = Clickable_onClick;
    return ci;
  }
}

ClickableValue Clickable_new(AnyGC this__) {
  final this_ = this__ as ClickableValue;
  return this_;
}

void Clickable_onClick(dynamic this_) {
  throw UnimplementedError('Clickable.onClick is abstract');
}


class WidgetClassInfo extends DrawableClassInfo {
  Function? resize;
  Function? onClick;
  Function? get_info;
}

class WidgetValue extends AnyGC implements DrawableValue, ResizableValue, ClickableValue {
  late String _state = 'idle';
  late double _scale = 1.0;
  late int _clickCount = 0;
  static WidgetClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static WidgetClassInfo _initClassInfo() {
    final ci = WidgetClassInfo();
    ci.draw = Widget_draw;
    ci.resize = Widget_resize;
    ci.onClick = Widget_onClick;
    ci.get_info = Widget_get_info;
    return ci;
  }
}

WidgetValue Widget_new(AnyGC this__) {
  final this_ = this__ as WidgetValue;
  return this_;
}

void Widget_draw(AnyGC this__) {
  final this_ = this__ as WidgetValue;
  this_._state = 'drawn';
}

void Widget_resize(AnyGC this__, double factor) {
  final this_ = this__ as WidgetValue;
  this_._scale = (this_._scale * factor);
}

void Widget_onClick(AnyGC this__) {
  final this_ = this__ as WidgetValue;
  this_._clickCount = (this_._clickCount + 1);
  this_._state = 'clicked(${this_._clickCount})';
}

String Widget_get_info(AnyGC this__) {
  final this_ = this__ as WidgetValue;
  return 'Widget(state=${this_._state}, scale=${this_._scale.toStringAsFixed(1)}, clicks=${this_._clickCount})';
}


class PairClassInfo<A, B> extends ClassInfo {
  Function? swap;
  Function? mapFirst;
  dynamic mapFirst_int;
  Function? mapSecond;
  dynamic mapSecond_String;
  Function? fold;
  dynamic fold_String;
}

class PairValue<A, B> extends AnyGC {
  late A first;
  late B second;
  @override
  ClassInfo get classInfo {
    final ci = PairClassInfo<A, B>();
    ci.swap = Pair_swap<A, B>;
    ci.toString_ = Pair_toString<A, B>;
    ci.mapFirst_int = Pair_mapFirst<A, B, int>;
    ci.mapSecond_String = Pair_mapSecond<A, B, String>;
    ci.fold_String = Pair_fold<A, B, String>;
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

PairValue<A, B> Pair_new<A, B>(AnyGC this__, A first, B second) {
  final this_ = this__ as PairValue<A, B>;
  this_.first = first;
  this_.second = second;
  return this_;
}

PairValue<B, A> Pair_swap<A, B>(AnyGC this__) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<B, A>(GC.allocateLocal(PairValue<B, A>()), this_.second, this_.first);
}

PairValue<C, B> Pair_mapFirst<A, B, C>(AnyGC this__, TypeFunction1<C, A> transform) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<C, B>(GC.allocateLocal(PairValue<C, B>()), transform.call(this_.first), this_.second);
}

PairValue<A, C> Pair_mapSecond<A, B, C>(AnyGC this__, TypeFunction1<C, B> transform) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<A, C>(GC.allocateLocal(PairValue<A, C>()), this_.first, transform.call(this_.second));
}

R Pair_fold<A, B, R>(AnyGC this__, TypeFunction2<R, A, B> combine) {
  final this_ = this__ as PairValue<A, B>;
  return combine.call(this_.first, this_.second);
}

String Pair_toString<A, B>(AnyGC this__) {
  final this_ = this__ as PairValue<A, B>;
  return 'Pair(${this_.first}, ${this_.second})';
}


class TripleClassInfo<A, B, C> extends PairClassInfo<A, B> {
  dynamic mapFirst_int;
  dynamic mapSecond_String;
  dynamic fold_String;
}

class TripleValue<A, B, C> extends PairValue<A, B> {
  late C third;
  @override
  ClassInfo get classInfo {
    final ci = TripleClassInfo<A, B, C>();
    ci.swap = Triple_swap<A, B, C>;
    ci.mapFirst = Triple_mapFirst<A, B, C>;
    ci.mapSecond = Triple_mapSecond<A, B, C>;
    ci.toString_ = Triple_toString<A, B, C>;
    ci.fold_String = Triple_fold<A, B, C, String>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (third is AnyGC) (third as AnyGC).gcMark(flag);
  }
}

TripleValue<A, B, C> Triple_new<A, B, C>(AnyGC this__, A first, B second, C third) {
  final this_ = this__ as TripleValue<A, B, C>;
  Pair_new<A, B>(this_, first, second);
  this_.third = third;
  return this_;
}

String Triple_toString<A, B, C>(AnyGC this__) {
  final this_ = this__ as TripleValue<A, B, C>;
  return 'Triple(${this_.first}, ${this_.second}, ${this_.third})';
}

PairValue<B, A> Triple_swap<A, B, C>(AnyGC this__) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_swap<A, B>(this_);
}

PairValue<C, B> Triple_mapFirst<A, B, C>(AnyGC this__, TypeFunction1<C, A> transform) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_mapFirst<A, B, C>(this_, transform);
}

PairValue<A, C> Triple_mapSecond<A, B, C>(AnyGC this__, TypeFunction1<C, B> transform) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_mapSecond<A, B, C>(this_, transform);
}

R Triple_fold<A, B, C, R>(AnyGC this__, TypeFunction2<R, A, B> combine) {
  final this_ = this__ as TripleValue<A, B, C>;
  return Pair_fold<A, B, R>(this_, combine);
}


class StringBuilderClassInfo extends ClassInfo {
  Function? withSeparator;
  Function? add;
  Function? addAll;
  Function? get_length;
}

class StringBuilderValue extends AnyGC {
  late StaticStringBuffer _buf = StaticStringBuffer();
  late String _separator = '';
  static StringBuilderClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static StringBuilderClassInfo _initClassInfo() {
    final ci = StringBuilderClassInfo();
    ci.withSeparator = StringBuilder_withSeparator;
    ci.add = StringBuilder_add;
    ci.addAll = StringBuilder_addAll;
    ci.get_length = StringBuilder_get_length;
    ci.toString_ = StringBuilder_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_buf is AnyGC) (_buf as AnyGC).gcMark(flag);
  }
}

StringBuilderValue StringBuilder_new(AnyGC this__) {
  final this_ = this__ as StringBuilderValue;
  return this_;
}

StringBuilderValue StringBuilder_withSeparator(AnyGC this__, String sep) {
  final this_ = this__ as StringBuilderValue;
  this_._separator = sep;
  return this_;
}

StringBuilderValue StringBuilder_add(AnyGC this__, String text) {
  final this_ = this__ as StringBuilderValue;
  if ((this_._buf.isNotEmpty && this_._separator.isNotEmpty)) {
    this_._buf.write(this_._separator);
  }
  this_._buf.write(text);
  return this_;
}

StringBuilderValue StringBuilder_addAll(AnyGC this__, StaticList<String> texts) {
  final this_ = this__ as StringBuilderValue;
{
    StaticIterator<String> sync_for_iterator = StaticIterator(texts.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final String t = sync_for_iterator.current;
{
        (this_.classInfo as StringBuilderClassInfo).add!(this_, t);
      }
    }
  }
  return this_;
}

int StringBuilder_get_length(AnyGC this__) {
  final this_ = this__ as StringBuilderValue;
  return this_._buf.length;
}

String StringBuilder_toString(AnyGC this__) {
  final this_ = this__ as StringBuilderValue;
  return this_._buf.toString();
}


class AppErrorClassInfo extends ClassInfo {
}

class AppErrorValue extends AnyGC {
  late String message;
  late String code;
  late AppErrorValue? cause;
  static AppErrorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static AppErrorClassInfo _initClassInfo() {
    final ci = AppErrorClassInfo();
    ci.toString_ = AppError_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (cause is AnyGC) (cause as AnyGC).gcMark(flag);
  }
}

AppErrorValue AppError_new(AnyGC this__, String message, String code, [AppErrorValue? cause = null]) {
  final this_ = this__ as AppErrorValue;
  this_.message = message;
  this_.code = code;
  this_.cause = cause;
  return this_;
}

String AppError_toString(AnyGC this__) {
  final this_ = this__ as AppErrorValue;
  final StaticList<String> chain = StaticList<String>();
  AppErrorValue? current = this_;
  while (!((current == null))) {
    chain.add('${current.code}:${current.message}');
    current = current.cause;
  }
  return chain.join(' -> ');
}


class DataPipelineClassInfo<T> extends ClassInfo {
  Function? where;
  Function? map;
  dynamic map_int;
  Function? sorted;
  Function? take;
  Function? fold;
  dynamic fold_int;
  Function? toList;
}

class DataPipelineValue<T> extends AnyGC {
  late StaticList<T> _data;
  @override
  ClassInfo get classInfo {
    final ci = DataPipelineClassInfo<T>();
    ci.where = DataPipeline_where<T>;
    ci.sorted = DataPipeline_sorted<T>;
    ci.take = DataPipeline_take<T>;
    ci.toList = DataPipeline_toList<T>;
    ci.toString_ = DataPipeline_toString<T>;
    ci.map_int = DataPipeline_map<T, int>;
    ci.fold_int = DataPipeline_fold<T, int>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_data is AnyGC) (_data as AnyGC).gcMark(flag);
  }
}

DataPipelineValue<T> DataPipeline_new<T>(AnyGC this__, StaticList<T> _data) {
  final this_ = this__ as DataPipelineValue<T>;
  this_._data = _data;
  return this_;
}

DataPipelineValue<T> DataPipeline_where<T>(AnyGC this__, TypeFunction1<bool, T> test) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<T>(GC.allocateLocal(DataPipelineValue<T>()), StaticList.of(this_._data.where(test).toList()));
}

DataPipelineValue<R> DataPipeline_map<T, R>(AnyGC this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<R>(GC.allocateLocal(DataPipelineValue<R>()), StaticList.of(this_._data.map(transform).toList()));
}

DataPipelineValue<T> DataPipeline_sorted<T>(AnyGC this__, TypeFunction2<int, T, T> compare) {
  final this_ = this__ as DataPipelineValue<T>;
  final StaticList<T> copy = StaticList<T>.of(this_._data);
  copy.sort(compare);
  return DataPipeline_new<T>(GC.allocateLocal(DataPipelineValue<T>()), copy);
}

DataPipelineValue<T> DataPipeline_take<T>(AnyGC this__, int count) {
  final this_ = this__ as DataPipelineValue<T>;
  return DataPipeline_new<T>(GC.allocateLocal(DataPipelineValue<T>()), StaticList.of(this_._data.take(count).toList()));
}

R DataPipeline_fold<T, R>(AnyGC this__, R initial, TypeFunction2<R, R, T> combine) {
  final this_ = this__ as DataPipelineValue<T>;
  return this_._data.fold(initial, combine);
}

StaticList<T> DataPipeline_toList<T>(AnyGC this__) {
  final this_ = this__ as DataPipelineValue<T>;
  return StaticList<T>.unmodifiable(this_._data);
}

String DataPipeline_toString<T>(AnyGC this__) {
  final this_ = this__ as DataPipelineValue<T>;
  return 'Pipeline(${this_._data})';
}


class BoundedValueClassInfo extends ClassInfo {
  Function? get_value;
  Function? set_value;
  Function? operatorPlus;
}

class BoundedValueValue extends AnyGC {
  late double _value;
  late double _min;
  late double _max;
  static BoundedValueClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static BoundedValueClassInfo _initClassInfo() {
    final ci = BoundedValueClassInfo();
    ci.get_value = BoundedValue_get_value;
    ci.set_value = BoundedValue_set_value;
    ci.operatorPlus = BoundedValue_operatorPlus;
    ci.toString_ = BoundedValue_toString;
    return ci;
  }
}

BoundedValueValue BoundedValue_new(AnyGC this__, double _value, double _min, double _max) {
  final this_ = this__ as BoundedValueValue;
  this_._value = _value;
  this_._min = _min;
  this_._max = _max;
  BoundedValue__clamp(this_);
  return this_;
}

double BoundedValue_get_value(AnyGC this__) {
  final this_ = this__ as BoundedValueValue;
  return this_._value;
}

void BoundedValue_set_value(AnyGC this__, double v) {
  final this_ = this__ as BoundedValueValue;
  this_._value = v;
  BoundedValue__clamp(this_);
}

void BoundedValue__clamp(AnyGC this__) {
  final this_ = this__ as BoundedValueValue;
  if ((this_._value < this_._min))   this_._value = this_._min;
  if ((this_._value > this_._max))   this_._value = this_._max;
}

BoundedValueValue BoundedValue_operatorPlus(AnyGC this__, double delta) {
  final this_ = this__ as BoundedValueValue;
  return BoundedValue_new(GC.allocateLocal(BoundedValueValue()), (this_._value + delta), this_._min, this_._max);
}

String BoundedValue_toString(AnyGC this__) {
  final this_ = this__ as BoundedValueValue;
  return 'BoundedValue(${this_._value}, min=${this_._min}, max=${this_._max})';
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

const double MathUtils_pi = 3.14159265358979;
int MathUtils__callCount = 0;
MathUtilsValue MathUtils_new(AnyGC this__) {
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
  if ((count <= 0))   return StaticList<int>();
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
void Loggable_log(AnyGC this__, String message) {
  final dynamic this_ = this__;
  this_._logs.add(message);
}

StaticList<String> Loggable_get_logs(AnyGC this__) {
  final dynamic this_ = this__;
  return StaticList<String>.unmodifiable(this_._logs);
}


// mixin Observable → static functions for delegation
void Observable_observe<T>(AnyGC this__, TypeFunction1<void, T> callback) {
  final dynamic this_ = this__;
  this_._observers.add(callback);
}

void Observable_notify<T>(AnyGC this__, T value) {
  final dynamic this_ = this__;
{
    StaticIterator<TypeFunction1<void, T>> sync_for_iterator = StaticIterator(this_._observers.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final TypeFunction1<void, T> cb = sync_for_iterator.current;
{
        cb.call(value);
      }
    }
  }
}


class ReactiveStoreClassInfo<V> extends ReactiveStore_Object_Loggable_ObservableClassInfo<V> {
  Function? get;
  Function? set;
  Function? get_size;
}

class ReactiveStoreValue<V> extends ReactiveStore_Object_Loggable_ObservableValue<V> {
  late StaticMap<String, V> _store = StaticMap<String, V>.of({});
  @override
  ClassInfo get classInfo {
    final ci = ReactiveStoreClassInfo<V>();
    ci.log = ReactiveStore_log<V>;
    ci.get_logs = ReactiveStore_get_logs<V>;
    ci.observe = ReactiveStore_observe<V>;
    ci.notify = ReactiveStore_notify<V>;
    ci.get = ReactiveStore_get<V>;
    ci.set = ReactiveStore_set<V>;
    ci.get_size = ReactiveStore_get_size<V>;
    ci.toString_ = ReactiveStore_toString<V>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_store is AnyGC) (_store as AnyGC).gcMark(flag);
  }
}

ReactiveStoreValue<V> ReactiveStore_new<V>(AnyGC this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return this_;
}

V? ReactiveStore_get<V>(AnyGC this__, String key) {
  final this_ = this__ as ReactiveStoreValue<V>;
  (this_.classInfo as ReactiveStoreClassInfo).log!(this_, 'get: ${key}');
  return this_._store[key];
}

void ReactiveStore_set<V>(AnyGC this__, String key, V value) {
  final this_ = this__ as ReactiveStoreValue<V>;
  (this_.classInfo as ReactiveStoreClassInfo).log!(this_, 'set: ${key}=${value}');
  this_._store[key] = value;
  (this_.classInfo as ReactiveStoreClassInfo).notify!(this_, value);
}

int ReactiveStore_get_size<V>(AnyGC this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return this_._store.length;
}

String ReactiveStore_toString<V>(AnyGC this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return 'Store(${this_._store})';
}

void ReactiveStore_log<V>(AnyGC this__, String message) {
  final this_ = this__ as ReactiveStoreValue<V>;
  Loggable_log(this_, message);
}

StaticList<String> ReactiveStore_get_logs<V>(AnyGC this__) {
  final this_ = this__ as ReactiveStoreValue<V>;
  return Loggable_get_logs(this_);
}

void ReactiveStore_observe<V>(AnyGC this__, TypeFunction1<void, V> callback) {
  final this_ = this__ as ReactiveStoreValue<V>;
  Observable_observe<V>(this_, callback);
}

void ReactiveStore_notify<V>(AnyGC this__, V value) {
  final this_ = this__ as ReactiveStoreValue<V>;
  Observable_notify<V>(this_, value);
}


class ShapeClassInfo extends ClassInfo {
  Function? area;
  Function? get_shapeName;
}

class ShapeValue extends AnyGC {
  static ShapeClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ShapeClassInfo _initClassInfo() {
    final ci = ShapeClassInfo();
    ci.area = Shape_area;
    ci.get_shapeName = Shape_get_shapeName;
    return ci;
  }
}

ShapeValue Shape_new(AnyGC this__) {
  final this_ = this__ as ShapeValue;
  return this_;
}

double Shape_area(dynamic this_) {
  throw UnimplementedError('Shape.area is abstract');
}

String Shape_get_shapeName(dynamic this_) {
  throw UnimplementedError('Shape.shapeName is abstract');
}


class CircleClassInfo extends ShapeClassInfo {
}

class CircleValue extends AnyGC implements ShapeValue {
  late double radius;
  static CircleClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CircleClassInfo _initClassInfo() {
    final ci = CircleClassInfo();
    ci.area = Circle_area;
    ci.get_shapeName = Circle_get_shapeName;
    ci.toString_ = Circle_toString;
    return ci;
  }
}

CircleValue Circle_new(AnyGC this__, double radius) {
  final this_ = this__ as CircleValue;
  this_.radius = radius;
  return this_;
}

double Circle_area(AnyGC this__) {
  final this_ = this__ as CircleValue;
  return ((3.14159 * this_.radius) * this_.radius);
}

String Circle_get_shapeName(AnyGC this__) {
  final this_ = this__ as CircleValue;
  return 'Circle';
}

String Circle_toString(AnyGC this__) {
  final this_ = this__ as CircleValue;
  return 'Circle(r=${this_.radius})';
}


class RectangleClassInfo extends ShapeClassInfo {
}

class RectangleValue extends AnyGC implements ShapeValue {
  late double width;
  late double height;
  static RectangleClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static RectangleClassInfo _initClassInfo() {
    final ci = RectangleClassInfo();
    ci.area = Rectangle_area;
    ci.get_shapeName = Rectangle_get_shapeName;
    ci.toString_ = Rectangle_toString;
    return ci;
  }
}

RectangleValue Rectangle_new(AnyGC this__, double width, double height) {
  final this_ = this__ as RectangleValue;
  this_.width = width;
  this_.height = height;
  return this_;
}

double Rectangle_area(AnyGC this__) {
  final this_ = this__ as RectangleValue;
  return (this_.width * this_.height);
}

String Rectangle_get_shapeName(AnyGC this__) {
  final this_ = this__ as RectangleValue;
  return 'Rectangle';
}

String Rectangle_toString(AnyGC this__) {
  final this_ = this__ as RectangleValue;
  return 'Rectangle(${this_.width}x${this_.height})';
}


class NodeClassInfo<T> extends ClassInfo {
  Function? addChild;
  Function? flatten;
  Function? mapTree;
}

class NodeValue<T> extends AnyGC {
  late T value;
  late StaticList<NodeValue<T>> children;
  @override
  ClassInfo get classInfo {
    final ci = NodeClassInfo<T>();
    ci.addChild = Node_addChild<T>;
    ci.flatten = Node_flatten<T>;
    ci.toString_ = Node_toString<T>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (value is AnyGC) (value as AnyGC).gcMark(flag);
    if (children is AnyGC) (children as AnyGC).gcMark(flag);
  }
}

NodeValue<T> Node_new<T>(AnyGC this__, T value, [StaticList<NodeValue<T>>? children = null]) {
  final this_ = this__ as NodeValue<T>;
  this_.value = value;
  this_.children = (children ?? StaticList<NodeValue<T>>());
  return this_;
}

void Node_addChild<T>(AnyGC this__, NodeValue<T> child) {
  final this_ = this__ as NodeValue<T>;
  this_.children.add(child);
}

StaticList<T> Node_flatten<T>(AnyGC this__) {
  final this_ = this__ as NodeValue<T>;
  final StaticList<T> result = StaticList<T>.of([this_.value]);
{
    StaticIterator<NodeValue<T>> sync_for_iterator = StaticIterator(this_.children.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final NodeValue<T> child = sync_for_iterator.current;
{
        result.addAll((child.classInfo as NodeClassInfo).flatten!(child));
      }
    }
  }
  return result;
}

NodeValue<R> Node_mapTree<T, R>(AnyGC this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as NodeValue<T>;
  return Node_new<R>(GC.allocateLocal(NodeValue<R>()), transform.call(this_.value), StaticList.of(this_.children.map(ClosureEnv_anon_1_new<R, T>(GC.allocateLocal(ClosureEnv_anon_1<R, T>()), transform)).toList()));
}

String Node_toString<T>(AnyGC this__) {
  final this_ = this__ as NodeValue<T>;
  if (this_.children.isEmpty)   return '${this_.value}';
  return '${this_.value}(${this_.children.join(', ')})';
}


class LabeledNodeClassInfo<T> extends LabeledNode_Node_PrintableClassInfo<T> {
}

class LabeledNodeValue<T> extends LabeledNode_Node_PrintableValue<T> {
  late String nodeLabel;
  @override
  ClassInfo get classInfo {
    final ci = LabeledNodeClassInfo<T>();
    ci.addChild = LabeledNode_addChild<T>;
    ci.flatten = LabeledNode_flatten<T>;
    ci.toString_ = LabeledNode_toString<T>;
    ci.get_label = LabeledNode_get_label<T>;
    ci.toPrettyString = LabeledNode_toPrettyString<T>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

LabeledNodeValue<T> LabeledNode_new<T>(AnyGC this__, String nodeLabel, T value, [StaticList<NodeValue<T>>? children = null]) {
  final this_ = this__ as LabeledNodeValue<T>;
  Node_new<T>(this_, value, children);
  this_.nodeLabel = nodeLabel;
  return this_;
}

String LabeledNode_get_label<T>(AnyGC this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return '${this_.nodeLabel}:${this_.value}';
}

String LabeledNode_toString<T>(AnyGC this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return '[${this_.nodeLabel}]${this_.value}';
}

void LabeledNode_addChild<T>(AnyGC this__, NodeValue<T> child) {
  final this_ = this__ as LabeledNodeValue<T>;
  Node_addChild<T>(this_, child);
}

StaticList<T> LabeledNode_flatten<T>(AnyGC this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Node_flatten<T>(this_);
}

NodeValue<R> LabeledNode_mapTree<T, R>(AnyGC this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Node_mapTree<T, R>(this_, transform);
}

String LabeledNode_toPrettyString<T>(AnyGC this__) {
  final this_ = this__ as LabeledNodeValue<T>;
  return Printable_toPrettyString(this_);
}


class Entity_Object_PrintableClassInfo extends ClassInfo {
  Function? get_label;
  Function? toPrettyString;
}

class Entity_Object_PrintableValue extends AnyGC {
  static Entity_Object_PrintableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Entity_Object_PrintableClassInfo _initClassInfo() {
    final ci = Entity_Object_PrintableClassInfo();
    return ci;
  }
}


class Entity_Object_Printable_CacheableClassInfo<ID> extends Entity_Object_PrintableClassInfo {
  Function? get_cacheKey;
  Function? cacheValue;
  Function? getCachedValue;
}

class Entity_Object_Printable_CacheableValue<ID> extends Entity_Object_PrintableValue {
  @override
  ClassInfo get classInfo {
    final ci = Entity_Object_Printable_CacheableClassInfo<ID>();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class VersionedEntity_TimestampedEntity_SerializableClassInfo<ID> extends TimestampedEntityClassInfo<ID> {
  Function? serialize;
  Function? toJson;
}

class VersionedEntity_TimestampedEntity_SerializableValue<ID> extends TimestampedEntityValue<ID> {
  @override
  ClassInfo get classInfo {
    final ci = VersionedEntity_TimestampedEntity_SerializableClassInfo<ID>();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class VersionedEntity_TimestampedEntity_Serializable_ValidatableClassInfo<ID> extends VersionedEntity_TimestampedEntity_SerializableClassInfo<ID> {
  Function? validate;
  Function? get_isValid;
}

class VersionedEntity_TimestampedEntity_Serializable_ValidatableValue<ID> extends VersionedEntity_TimestampedEntity_SerializableValue<ID> {
  @override
  ClassInfo get classInfo {
    final ci = VersionedEntity_TimestampedEntity_Serializable_ValidatableClassInfo<ID>();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Money_Comparable2_PrintableClassInfo extends Comparable2ClassInfo<MoneyValue> {
  Function? get_label;
  Function? toPrettyString;
}

class Money_Comparable2_PrintableValue extends Comparable2Value<MoneyValue> {
  static Money_Comparable2_PrintableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Money_Comparable2_PrintableClassInfo _initClassInfo() {
    final ci = Money_Comparable2_PrintableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class ReactiveStore_Object_LoggableClassInfo extends ClassInfo {
  Function? log;
  Function? get_logs;
}

class ReactiveStore_Object_LoggableValue extends AnyGC {
  late StaticList<String> _logs = StaticList<String>();
  static ReactiveStore_Object_LoggableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ReactiveStore_Object_LoggableClassInfo _initClassInfo() {
    final ci = ReactiveStore_Object_LoggableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_logs is AnyGC) (_logs as AnyGC).gcMark(flag);
  }
}


class ReactiveStore_Object_Loggable_ObservableClassInfo<V> extends ReactiveStore_Object_LoggableClassInfo {
  Function? observe;
  Function? notify;
}

class ReactiveStore_Object_Loggable_ObservableValue<V> extends ReactiveStore_Object_LoggableValue {
  late StaticList<TypeFunction1<void, V>> _observers = StaticList<TypeFunction1<void, V>>();
  @override
  ClassInfo get classInfo {
    final ci = ReactiveStore_Object_Loggable_ObservableClassInfo<V>();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_observers is AnyGC) (_observers as AnyGC).gcMark(flag);
  }
}


class LabeledNode_Node_PrintableClassInfo<T> extends NodeClassInfo<T> {
  Function? get_label;
  Function? toPrettyString;
}

class LabeledNode_Node_PrintableValue<T> extends NodeValue<T> {
  @override
  ClassInfo get classInfo {
    final ci = LabeledNode_Node_PrintableClassInfo<T>();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


T applyTransform<T>(T value, TypeFunction1<T, T> transform) {
  return transform.call(value);
}

StaticList<T> filterWith<T>(StaticList<T> items, TypeFunction1<bool, T> predicate) {
  final StaticList<T> result = StaticList<T>();
{
    StaticIterator<T> sync_for_iterator = StaticIterator(items.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final T item = sync_for_iterator.current;
{
        if (predicate.call(item))         result.add(item);
      }
    }
  }
  return result;
}

T reduceList<T>(StaticList<T> items, TypeFunction2<T, T, T> reducer) {
  T acc = items.first;
  for (var i = 1; (i < items.length); i = (i + 1)) {
    acc = reducer.call(acc, items[i]);
  }
  return acc;
}

StaticList<String> testClosureBoxing() {
  final StaticList<String> log = StaticList<String>();
  IntBox counter = IntBox(0);
  final TypeFunction0<int> increment = ClosureEnv_testClosureBoxing_2_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_2()), counter);
  increment.call();
  increment.call();
  log.add('counter=${counter.value}');
  final StaticList<TypeFunction0<int>> fns = StaticList<TypeFunction0<int>>();
  for (var i = 0; (i < 3); i = (i + 1)) {
    fns.add(ClosureEnv_testClosureBoxing_3_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_3()), i));
  }
  log.add('fns=${StaticList.of(fns.map(ClosureEnv_testClosureBoxing_4_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_4()))).toList())}');
  IntBox outer = IntBox(0);
  final TypeFunction1<TypeFunction1<int, int>, int> makeAdder = ClosureEnv_testClosureBoxing_5_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_5()), outer);
  final TypeFunction1<int, int> adder = makeAdder.call(100);
  adder.call(5);
  adder.call(10);
  log.add('outer=${outer.value}, adder(0)=${adder.call(0)}');
  String captureParam(String prefix) {
    int count = 0;
    final TypeFunction0<String> fn = ClosureEnv_testClosureBoxing_7_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_7()), count, prefix);
    fn.call();
    fn.call();
    return fn.call();
  }

  log.add('captureParam=${captureParam('test')}');
  final EventBusValue bus = EventBus_new(GC.allocateLocal(EventBusValue()));
  StaticList<String> received = StaticList<String>();
  (bus.classInfo as EventBusClassInfo).on!(bus, ClosureEnv_testClosureBoxing_8_new(GC.allocateLocal(ClosureEnv_testClosureBoxing_8()), received));
  (bus.classInfo as EventBusClassInfo).emit!(bus, 'hello');
  (bus.classInfo as EventBusClassInfo).emit!(bus, 'world');
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
    return '${(shape.classInfo as CircleClassInfo).get_shapeName!(shape)}: r=${shape.radius}, area=${(shape.classInfo as CircleClassInfo).area!(shape).toStringAsFixed(2)}';
  }
 else   if ((shape is RectangleValue)) {
    return '${(shape.classInfo as RectangleClassInfo).get_shapeName!(shape)}: ${shape.width}x${shape.height}, area=${(shape.classInfo as RectangleClassInfo).area!(shape).toStringAsFixed(2)}';
  }
  return 'Unknown shape: area=${(shape.classInfo as ShapeClassInfo).area!(shape)}';
}

String evaluateGrade(int score) {
  final String letter = ((score >= 90) ? 'A' : ((score >= 80) ? 'B' : ((score >= 70) ? 'C' : ((score >= 60) ? 'D' : 'F'))));
  late String description;
  _L8: do {
    switch (letter) {
      case 'A':
{
          description = 'Excellent';
          break _L8;
        }
      case 'B':
{
          description = 'Good';
          break _L8;
        }
      case 'C':
{
          description = 'Average';
          break _L8;
        }
      case 'D':
{
          description = 'Below Average';
          break _L8;
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
  final int doubled = applyTransform<int>(21, ClosureEnv_main_9_new(GC.allocateLocal(ClosureEnv_main_9())));
  staticPrint('applyTransform: ${doubled}');
  final StaticList<int> evens = StaticList<int>.of(filterWith<int>(StaticList<int>.of([1, 2, 3, 4, 5, 6]), ClosureEnv_main_10_new(GC.allocateLocal(ClosureEnv_main_10()))));
  staticPrint('filterWith: ${evens}');
  final int sum = reduceList<int>(StaticList<int>.of([1, 2, 3, 4, 5]), ClosureEnv_main_11_new(GC.allocateLocal(ClosureEnv_main_11())));
  staticPrint('reduceList: ${sum}');
  staticPrint('\n--- 2. 枚举类 ---');
  staticPrint('red hex: ${Color_get_hex(Color.red)}');
  staticPrint('green isWarm: ${Color_get_isWarm(Color.green)}');
  staticPrint('priorities: ${StaticList.of(const [Priority.low, Priority.medium, Priority.high, Priority.critical].map(ClosureEnv_main_12_new(GC.allocateLocal(ClosureEnv_main_12()))).toList())}');
  staticPrint('\n--- 3. 运算符重载 ---');
  final MoneyValue price1 = Money_new(GC.allocateLocal(MoneyValue()), 1099, 'USD');
  final MoneyValue price2 = Money_new_fromDollars(GC.allocateLocal(MoneyValue()), 5.5);
  final MoneyValue total = (price1.classInfo as MoneyClassInfo).operatorPlus!(price1, price2);
  final MoneyValue negated = (price2.classInfo as MoneyClassInfo).operatorNeg!(price2);
  staticPrint('price1: ${(price1.classInfo as MoneyClassInfo).toPrettyString!(price1)}');
  staticPrint('price2: ${price2}');
  staticPrint('total: ${total}');
  staticPrint('negated: ${negated}');
  staticPrint('price1 > price2: ${(price1.classInfo as MoneyClassInfo).operatorGt!(price1, price2)}');
  staticPrint('price1 < price2: ${(price1.classInfo as MoneyClassInfo).operatorLt!(price1, price2)}');
  staticPrint('price1 * 3: ${(price1.classInfo as MoneyClassInfo).operatorStar!(price1, 3)}');
  staticPrint('\n--- 4. 多层泛型继承 ---');
  final EntityValue<int> entity = Entity_new<int>(GC.allocateLocal(EntityValue<int>()), 1, 'alice');
  staticPrint('entity: ${entity}');
  staticPrint('entity label: ${(entity.classInfo as EntityClassInfo).toPrettyString!(entity)}');
  (entity.classInfo as EntityClassInfo).cacheValue!(entity, StringBox('cached_data'));
  staticPrint('cached: ${(entity.classInfo as EntityClassInfo).getCachedValue!(entity)}');
  final TimestampedEntityValue<String> tsEntity = TimestampedEntity_new<String>(GC.allocateLocal(TimestampedEntityValue<String>()), 'u1', 'bob', 1000, 2000);
  staticPrint('tsEntity label: ${(tsEntity.classInfo as TimestampedEntityClassInfo).toPrettyString!(tsEntity)}');
  final VersionedEntityValue<int> vEntity = VersionedEntity_new<int>(GC.allocateLocal(VersionedEntityValue<int>()), 42, 'project', 1000, 5000);
  (vEntity.classInfo as VersionedEntityClassInfo).bump!(vEntity, 'initial release');
  (vEntity.classInfo as VersionedEntityClassInfo).bump!(vEntity, 'bug fix');
  staticPrint('vEntity label: ${(vEntity.classInfo as VersionedEntityClassInfo).toPrettyString!(vEntity)}');
  staticPrint('vEntity version: ${(vEntity.classInfo as VersionedEntityClassInfo).get_version!(vEntity)}');
  staticPrint('vEntity changelog: ${(vEntity.classInfo as VersionedEntityClassInfo).get_changelog!(vEntity)}');
  staticPrint('vEntity serialize: ${(vEntity.classInfo as VersionedEntityClassInfo).serialize!(vEntity)}');
  staticPrint('vEntity toJson: ${(vEntity.classInfo as VersionedEntityClassInfo).toJson!(vEntity)}');
  staticPrint('vEntity isValid: ${(vEntity.classInfo as VersionedEntityClassInfo).get_isValid!(vEntity)}');
  staticPrint('vEntity validate: ${(vEntity.classInfo as VersionedEntityClassInfo).validate!(vEntity)}');
  staticPrint('\n--- 5. 工厂构造 ---');
  final ConfigValue cfg1 = Config_new_empty(GC.allocateLocal(ConfigValue()));
  (cfg1.classInfo as ConfigClassInfo).operatorIndexSet!(cfg1, 'host', StringBox('localhost'));
  staticPrint('cfg1: ${cfg1}');
  final ConfigValue cfg2 = Config_new_fromPairs(GC.allocateLocal(ConfigValue()), StaticList<StaticList<dynamic>>.of([StaticList<dynamic>.of(['a', 1]), StaticList<dynamic>.of(['b', 2])]));
  staticPrint('cfg2: ${cfg2}');
  final ConfigValue cfg3 = Config_new_withDefaults(StaticMap<String, dynamic>.of({'debug': true, 'name': 'prod'}));
  staticPrint('cfg3: ${cfg3}');
  staticPrint('cfg3[maxRetries]: ${(cfg3.classInfo as ConfigClassInfo).operatorIndex!(cfg3, 'maxRetries')}');
  staticPrint('\n--- 6. 闭包 Box 化 ---');
  final StaticList<String> closureLog = StaticList<String>.of(testClosureBoxing());
{
    StaticIterator<String> sync_for_iterator = StaticIterator(closureLog.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final String line = sync_for_iterator.current;
{
        staticPrint(line);
      }
    }
  }
  staticPrint('\n--- 7. 多重 implements ---');
  final WidgetValue widget = Widget_new(GC.allocateLocal(WidgetValue()));
  (widget.classInfo as WidgetClassInfo).draw!(widget);
  (widget.classInfo as WidgetClassInfo).resize!(widget, 1.5);
  (widget.classInfo as WidgetClassInfo).onClick!(widget);
  (widget.classInfo as WidgetClassInfo).onClick!(widget);
  staticPrint('widget: ${(widget.classInfo as WidgetClassInfo).get_info!(widget)}');
  staticPrint('\n--- 8. 泛型 Pair ---');
  final PairValue<int, String> pair = Pair_new<int, String>(GC.allocateLocal(PairValue<int, String>()), 42, 'hello');
  staticPrint('pair: ${pair}');
  staticPrint('swap: ${(pair.classInfo as PairClassInfo).swap!(pair)}');
  staticPrint('mapFirst: ${(pair.classInfo as PairClassInfo).mapFirst_int!(pair, ClosureEnv_main_13_new(GC.allocateLocal(ClosureEnv_main_13())))}');
  staticPrint('mapSecond: ${(pair.classInfo as PairClassInfo).mapSecond_String!(pair, ClosureEnv_main_14_new(GC.allocateLocal(ClosureEnv_main_14())))}');
  staticPrint('fold: ${(pair.classInfo as PairClassInfo).fold_String!(pair, ClosureEnv_main_15_new(GC.allocateLocal(ClosureEnv_main_15())))}');
  final TripleValue<int, String, bool> triple = Triple_new<int, String, bool>(GC.allocateLocal(TripleValue<int, String, bool>()), 1, 'yes', true);
  staticPrint('triple: ${triple}');
  staticPrint('\n--- 9. 级联操作 ---');
  final StringBuilderValue sb = (() { final _let9 = StringBuilder_new(GC.allocateLocal(StringBuilderValue())); (_let9.classInfo as StringBuilderClassInfo).withSeparator!(_let9, ', '); (_let9.classInfo as StringBuilderClassInfo).add!(_let9, 'alpha'); (_let9.classInfo as StringBuilderClassInfo).add!(_let9, 'beta'); (_let9.classInfo as StringBuilderClassInfo).addAll!(_let9, StaticList<String>.of(['gamma', 'delta'])); return _let9; })();
  staticPrint('builder: ${sb}');
  staticPrint('length: ${(sb.classInfo as StringBuilderClassInfo).get_length!(sb)}');
  staticPrint('\n--- 10. 异常处理链 ---');
  staticPrint('chain: ${testExceptionChain()}');
  staticPrint('\n--- 11. 集合操作 ---');
  final DataPipelineValue<int> pipeline = (() { final _r13 = (() { final _r12 = (() { final _r11 = (() { final _r10 = DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([5, 3, 8, 1, 9, 2, 7, 4, 6])); return (_r10.classInfo as DataPipelineClassInfo).where!(_r10, ClosureEnv_main_16_new(GC.allocateLocal(ClosureEnv_main_16()))); })(); return (_r11.classInfo as DataPipelineClassInfo).sorted!(_r11, ClosureEnv_main_17_new(GC.allocateLocal(ClosureEnv_main_17()))); })(); return (_r12.classInfo as DataPipelineClassInfo).take!(_r12, 5); })(); return (_r13.classInfo as DataPipelineClassInfo).map_int!(_r13, ClosureEnv_main_18_new(GC.allocateLocal(ClosureEnv_main_18()))); })();
  staticPrint('pipeline: ${(pipeline.classInfo as DataPipelineClassInfo).toList!(pipeline)}');
  final int pipeSum = (() { final _r14 = DataPipeline_new<int>(GC.allocateLocal(DataPipelineValue<int>()), StaticList<int>.of([1, 2, 3, 4, 5])); return (_r14.classInfo as dynamic).fold_int!(_r14, 0, ClosureEnv_main_19_new(GC.allocateLocal(ClosureEnv_main_19()))); })();
  staticPrint('pipeSum: ${pipeSum}');
  staticPrint('\n--- 12. 可选参数 ---');
  staticPrint(formatRecord(name: 'Alice', age: 30, email: 'alice@test.com'));
  staticPrint(formatRecord(name: 'Bob', tags: StaticList<String>.of(['admin', 'vip'])));
  staticPrint(greetAll('Hello'));
  staticPrint(greetAll('Hi', 'Dart', '!!'));
  staticPrint('\n--- 13. BoundedValue ---');
  final BoundedValueValue bv = BoundedValue_new(GC.allocateLocal(BoundedValueValue()), 5.0, 0.0, 10.0);
  staticPrint('bv: ${bv}');
  (bv.classInfo as BoundedValueClassInfo).set_value!(bv, 15.0);
  staticPrint('after set 15: ${bv}');
  (bv.classInfo as BoundedValueClassInfo).set_value!(bv, (-5.0));
  staticPrint('after set -5: ${bv}');
  final BoundedValueValue bv2 = (bv.classInfo as BoundedValueClassInfo).operatorPlus!(bv, 7.0);
  staticPrint('bv + 7: ${bv2}');
  staticPrint('\n--- 14. 静态方法 ---');
  staticPrint('5! = ${MathUtils_factorial(5)}');
  staticPrint('fib(8): ${MathUtils_fibonacci(8)}');
  staticPrint('lerp(0,100,0.3): ${MathUtils_lerp(0.0, 100.0, 0.3)}');
  staticPrint('callCount: ${MathUtils_callCount()}');
  staticPrint('\n--- 15. ReactiveStore ---');
  final ReactiveStoreValue<int> store = ReactiveStore_new<int>(GC.allocateLocal(ReactiveStoreValue<int>()));
  final StaticList<int> observed = StaticList<int>();
  (store.classInfo as ReactiveStoreClassInfo).observe!(store, ClosureEnv_main_20_new(GC.allocateLocal(ClosureEnv_main_20()), observed));
  (store.classInfo as ReactiveStoreClassInfo).set!(store, 'x', 10);
  (store.classInfo as ReactiveStoreClassInfo).set!(store, 'y', 20);
  staticPrint('store: ${store}');
  staticPrint('store.get(x): ${(store.classInfo as ReactiveStoreClassInfo).get!(store, 'x')}');
  staticPrint('store.size: ${(store.classInfo as ReactiveStoreClassInfo).get_size!(store)}');
  staticPrint('observed: ${observed}');
  staticPrint('logs: ${(store.classInfo as ReactiveStoreClassInfo).get_logs!(store)}');
  staticPrint('\n--- 16. 类型转换 ---');
  final StaticList<ShapeValue> shapes = StaticList<ShapeValue>.of([Circle_new(GC.allocateLocal(CircleValue()), 5.0), Rectangle_new(GC.allocateLocal(RectangleValue()), 3.0, 4.0), Circle_new(GC.allocateLocal(CircleValue()), 1.0)]);
{
    StaticIterator<ShapeValue> sync_for_iterator = StaticIterator(shapes.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final ShapeValue s = sync_for_iterator.current;
{
        staticPrint(describeShape(s));
      }
    }
  }
  staticPrint('\n--- 18. 评分 ---');
  staticPrint(evaluateGrade(95));
  staticPrint(evaluateGrade(82));
  staticPrint(evaluateGrade(67));
  staticPrint(evaluateGrade(55));
  staticPrint('\n=== 所有压力测试通过 ✅ ===');
  drainScheduler();
}

class ClosureEnv_anon_0 extends TypeFunction1<String, String> {
  late ConfigValue this_;
  ClosureEnv_anon_0();
  @override
  String call(String k) => fnPtr(this, k);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_0 ClosureEnv_anon_0_new(ClosureEnv_anon_0 env_, ConfigValue this_) {
  env_.fnPtr = ClosureEnv_anon_0_call;
  env_.this_ = this_;
  return env_;
}
String ClosureEnv_anon_0_call(AnyGC env__, String k) {
  final env = env__ as ClosureEnv_anon_0;

  return '${k}=${env.this_._data[k]}';
}

class ClosureEnv_anon_1<R, T> extends TypeFunction1<NodeValue<R>, NodeValue<T>> {
  late TypeFunction1<R, T> transform;
  ClosureEnv_anon_1();
  @override
  NodeValue<R> call(NodeValue<T> c) => fnPtr(this, c);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (transform is AnyGC) (transform as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_1<R, T> ClosureEnv_anon_1_new<R, T>(ClosureEnv_anon_1<R, T> env_, TypeFunction1<R, T> transform) {
  env_.fnPtr = ClosureEnv_anon_1_call<R, T>;
  env_.transform = transform;
  return env_;
}
NodeValue<R> ClosureEnv_anon_1_call<R, T>(AnyGC env__, NodeValue<T> c) {
  final env = env__ as ClosureEnv_anon_1<R, T>;

  return Node_mapTree<T, R>(c, env.transform);
}

class ClosureEnv_testClosureBoxing_2 extends TypeFunction0<int> {
  late IntBox counter;
  ClosureEnv_testClosureBoxing_2();
  @override
  int call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (counter is AnyGC) (counter as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_2 ClosureEnv_testClosureBoxing_2_new(ClosureEnv_testClosureBoxing_2 env_, IntBox counter) {
  env_.fnPtr = ClosureEnv_testClosureBoxing_2_call;
  env_.counter = counter;
  return env_;
}
int ClosureEnv_testClosureBoxing_2_call(AnyGC env__) {
  final env = env__ as ClosureEnv_testClosureBoxing_2;

    env.counter.value = (env.counter.value + 1);
    return env.counter.value;
  }

class ClosureEnv_testClosureBoxing_3 extends TypeFunction0<int> {
  late int i;
  ClosureEnv_testClosureBoxing_3();
  @override
  int call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (i is AnyGC) (i as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_3 ClosureEnv_testClosureBoxing_3_new(ClosureEnv_testClosureBoxing_3 env_, int i) {
  env_.fnPtr = ClosureEnv_testClosureBoxing_3_call;
  env_.i = i;
  return env_;
}
int ClosureEnv_testClosureBoxing_3_call(AnyGC env__) {
  final env = env__ as ClosureEnv_testClosureBoxing_3;

  return (env.i * 10);
}

class ClosureEnv_testClosureBoxing_4 extends TypeFunction1<int, TypeFunction0<int>> {
  ClosureEnv_testClosureBoxing_4();
  @override
  int call(TypeFunction0<int> f) => fnPtr(this, f);
}
ClosureEnv_testClosureBoxing_4 ClosureEnv_testClosureBoxing_4_new(ClosureEnv_testClosureBoxing_4 env_) {
  env_.fnPtr = ClosureEnv_testClosureBoxing_4_call;
  return env_;
}
int ClosureEnv_testClosureBoxing_4_call(AnyGC env__, TypeFunction0<int> f) {
  final env = env__ as ClosureEnv_testClosureBoxing_4;

  return f.call();
}

class ClosureEnv_ClosureEnv_testClosureBoxing_5_6 extends TypeFunction1<int, int> {
  late IntBox inner;
  late IntBox outer;
  ClosureEnv_ClosureEnv_testClosureBoxing_5_6();
  @override
  int call(int x) => fnPtr(this, x);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (inner is AnyGC) (inner as AnyGC).gcMark(flag);
    if (outer is AnyGC) (outer as AnyGC).gcMark(flag);
  }
}
ClosureEnv_ClosureEnv_testClosureBoxing_5_6 ClosureEnv_ClosureEnv_testClosureBoxing_5_6_new(ClosureEnv_ClosureEnv_testClosureBoxing_5_6 env_, IntBox inner, IntBox outer) {
  env_.fnPtr = ClosureEnv_ClosureEnv_testClosureBoxing_5_6_call;
  env_.inner = inner;
  env_.outer = outer;
  return env_;
}
int ClosureEnv_ClosureEnv_testClosureBoxing_5_6_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_ClosureEnv_testClosureBoxing_5_6;

      env.inner.value = (env.inner.value + x);
      env.outer.value = (env.outer.value + x);
      return env.inner.value;
    }

class ClosureEnv_testClosureBoxing_5 extends TypeFunction1<TypeFunction1<int, int>, int> {
  late IntBox outer;
  ClosureEnv_testClosureBoxing_5();
  @override
  TypeFunction1<int, int> call(int base) => fnPtr(this, base);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (outer is AnyGC) (outer as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_5 ClosureEnv_testClosureBoxing_5_new(ClosureEnv_testClosureBoxing_5 env_, IntBox outer) {
  env_.fnPtr = ClosureEnv_testClosureBoxing_5_call;
  env_.outer = outer;
  return env_;
}
TypeFunction1<int, int> ClosureEnv_testClosureBoxing_5_call(AnyGC env__, int base) {
  final env = env__ as ClosureEnv_testClosureBoxing_5;

    IntBox inner = IntBox(base);
    return ClosureEnv_ClosureEnv_testClosureBoxing_5_6_new(GC.allocateLocal(ClosureEnv_ClosureEnv_testClosureBoxing_5_6()), inner, env.outer);
  }

class ClosureEnv_testClosureBoxing_7 extends TypeFunction0<String> {
  late int count;
  late String prefix;
  ClosureEnv_testClosureBoxing_7();
  @override
  String call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (count is AnyGC) (count as AnyGC).gcMark(flag);
    if (prefix is AnyGC) (prefix as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_7 ClosureEnv_testClosureBoxing_7_new(ClosureEnv_testClosureBoxing_7 env_, int count, String prefix) {
  env_.fnPtr = ClosureEnv_testClosureBoxing_7_call;
  env_.count = count;
  env_.prefix = prefix;
  return env_;
}
String ClosureEnv_testClosureBoxing_7_call(AnyGC env__) {
  final env = env__ as ClosureEnv_testClosureBoxing_7;

      env.count = (env.count + 1);
      return '${env.prefix}-${env.count}';
    }

class ClosureEnv_testClosureBoxing_8 extends TypeFunction1<void, String> {
  late StaticList<String> received;
  ClosureEnv_testClosureBoxing_8();
  @override
  void call(String event) => fnPtr(this, event);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (received is AnyGC) (received as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testClosureBoxing_8 ClosureEnv_testClosureBoxing_8_new(ClosureEnv_testClosureBoxing_8 env_, StaticList<String> received) {
  env_.fnPtr = ClosureEnv_testClosureBoxing_8_call;
  env_.received = received;
  return env_;
}
void ClosureEnv_testClosureBoxing_8_call(AnyGC env__, String event) {
  final env = env__ as ClosureEnv_testClosureBoxing_8;

    env.received.add(event);
  }

class ClosureEnv_main_9 extends TypeFunction1<int, int> {
  ClosureEnv_main_9();
  @override
  int call(int x) => fnPtr(this, x);
}
ClosureEnv_main_9 ClosureEnv_main_9_new(ClosureEnv_main_9 env_) {
  env_.fnPtr = ClosureEnv_main_9_call;
  return env_;
}
int ClosureEnv_main_9_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_main_9;

  return (x * 2);
}

class ClosureEnv_main_10 extends TypeFunction1<bool, int> {
  ClosureEnv_main_10();
  @override
  bool call(int x) => fnPtr(this, x);
}
ClosureEnv_main_10 ClosureEnv_main_10_new(ClosureEnv_main_10 env_) {
  env_.fnPtr = ClosureEnv_main_10_call;
  return env_;
}
bool ClosureEnv_main_10_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_main_10;

  return ((x % 2) == 0);
}

class ClosureEnv_main_11 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_11();
  @override
  int call(int a, int b) => fnPtr(this, a, b);
}
ClosureEnv_main_11 ClosureEnv_main_11_new(ClosureEnv_main_11 env_) {
  env_.fnPtr = ClosureEnv_main_11_call;
  return env_;
}
int ClosureEnv_main_11_call(AnyGC env__, int a, int b) {
  final env = env__ as ClosureEnv_main_11;

  return (a + b);
}

class ClosureEnv_main_12 extends TypeFunction1<String, Priority> {
  ClosureEnv_main_12();
  @override
  String call(Priority p) => fnPtr(this, p);
}
ClosureEnv_main_12 ClosureEnv_main_12_new(ClosureEnv_main_12 env_) {
  env_.fnPtr = ClosureEnv_main_12_call;
  return env_;
}
String ClosureEnv_main_12_call(AnyGC env__, Priority p) {
  final env = env__ as ClosureEnv_main_12;

  return '${p}'.split('.').last;
}

class ClosureEnv_main_13 extends TypeFunction1<int, int> {
  ClosureEnv_main_13();
  @override
  int call(int x) => fnPtr(this, x);
}
ClosureEnv_main_13 ClosureEnv_main_13_new(ClosureEnv_main_13 env_) {
  env_.fnPtr = ClosureEnv_main_13_call;
  return env_;
}
int ClosureEnv_main_13_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_main_13;

  return (x * 2);
}

class ClosureEnv_main_14 extends TypeFunction1<String, String> {
  ClosureEnv_main_14();
  @override
  String call(String s) => fnPtr(this, s);
}
ClosureEnv_main_14 ClosureEnv_main_14_new(ClosureEnv_main_14 env_) {
  env_.fnPtr = ClosureEnv_main_14_call;
  return env_;
}
String ClosureEnv_main_14_call(AnyGC env__, String s) {
  final env = env__ as ClosureEnv_main_14;

  return s.toUpperCase();
}

class ClosureEnv_main_15 extends TypeFunction2<String, int, String> {
  ClosureEnv_main_15();
  @override
  String call(int a, String b) => fnPtr(this, a, b);
}
ClosureEnv_main_15 ClosureEnv_main_15_new(ClosureEnv_main_15 env_) {
  env_.fnPtr = ClosureEnv_main_15_call;
  return env_;
}
String ClosureEnv_main_15_call(AnyGC env__, int a, String b) {
  final env = env__ as ClosureEnv_main_15;

  return '${b}=${a}';
}

class ClosureEnv_main_16 extends TypeFunction1<bool, int> {
  ClosureEnv_main_16();
  @override
  bool call(int x) => fnPtr(this, x);
}
ClosureEnv_main_16 ClosureEnv_main_16_new(ClosureEnv_main_16 env_) {
  env_.fnPtr = ClosureEnv_main_16_call;
  return env_;
}
bool ClosureEnv_main_16_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_main_16;

  return (x > 2);
}

class ClosureEnv_main_17 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_17();
  @override
  int call(int a, int b) => fnPtr(this, a, b);
}
ClosureEnv_main_17 ClosureEnv_main_17_new(ClosureEnv_main_17 env_) {
  env_.fnPtr = ClosureEnv_main_17_call;
  return env_;
}
int ClosureEnv_main_17_call(AnyGC env__, int a, int b) {
  final env = env__ as ClosureEnv_main_17;

  return (a - b);
}

class ClosureEnv_main_18 extends TypeFunction1<int, int> {
  ClosureEnv_main_18();
  @override
  int call(int x) => fnPtr(this, x);
}
ClosureEnv_main_18 ClosureEnv_main_18_new(ClosureEnv_main_18 env_) {
  env_.fnPtr = ClosureEnv_main_18_call;
  return env_;
}
int ClosureEnv_main_18_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_main_18;

  return (x * 10);
}

class ClosureEnv_main_19 extends TypeFunction2<int, int, int> {
  ClosureEnv_main_19();
  @override
  int call(int acc, int x) => fnPtr(this, acc, x);
}
ClosureEnv_main_19 ClosureEnv_main_19_new(ClosureEnv_main_19 env_) {
  env_.fnPtr = ClosureEnv_main_19_call;
  return env_;
}
int ClosureEnv_main_19_call(AnyGC env__, int acc, int x) {
  final env = env__ as ClosureEnv_main_19;

  return (acc + x);
}

class ClosureEnv_main_20 extends TypeFunction1<void, int> {
  late StaticList<int> observed;
  ClosureEnv_main_20();
  @override
  void call(int v) => fnPtr(this, v);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (observed is AnyGC) (observed as AnyGC).gcMark(flag);
  }
}
ClosureEnv_main_20 ClosureEnv_main_20_new(ClosureEnv_main_20 env_, StaticList<int> observed) {
  env_.fnPtr = ClosureEnv_main_20_call;
  env_.observed = observed;
  return env_;
}
void ClosureEnv_main_20_call(AnyGC env__, int v) {
  final env = env__ as ClosureEnv_main_20;

    env.observed.add(v);
  }


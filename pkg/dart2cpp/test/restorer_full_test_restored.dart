import 'package:dart2cpp/platform/dart/runtime_classes.dart';

typedef Predicate<T> = TypeFunction1<bool, T>;

typedef Transformer<A, B> = TypeFunction1<B, A>;

typedef VoidCallback = TypeFunction0<void>;

// mixin Printable → static functions for delegation
void Printable_printInfo(AnyGC this__) {
  final dynamic this_ = this__;
  staticPrint('[${(this_.classInfo as dynamic).get_displayName!(this_)}]');
}


// mixin Orderable → static functions for delegation
bool Orderable_isLessThan<T>(AnyGC this__, T other) {
  final dynamic this_ = this__;
  return ((this_.classInfo as dynamic).compareTo!(this_, other) < 0);
}

bool Orderable_isGreaterThan<T>(AnyGC this__, T other) {
  final dynamic this_ = this__;
  return ((this_.classInfo as dynamic).compareTo!(this_, other) > 0);
}


class AnimalClassInfo extends ClassInfo {
  Function? speak;
}

class AnimalValue extends AnyGC {
  late String name;
  late int age;
  static AnimalClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static AnimalClassInfo _initClassInfo() {
    final ci = AnimalClassInfo();
    ci.speak = Animal_speak;
    ci.toString_ = Animal_toString;
    return ci;
  }
}

AnimalValue Animal_new(AnyGC this__, String name, int age) {
  final this_ = this__ as AnimalValue;
  this_.name = name;
  this_.age = age;
  return this_;
}

String Animal_speak(dynamic this_) {
  throw UnimplementedError('Animal.speak is abstract');
}

String Animal_toString(AnyGC this__) {
  final this_ = this__ as AnimalValue;
  return '${this_.name}(age=${this_.age})';
}


class DogClassInfo extends Dog_Animal_Printable_OrderableClassInfo {
}

class DogValue extends Dog_Animal_Printable_OrderableValue {
  late String breed;
  static DogClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DogClassInfo _initClassInfo() {
    final ci = DogClassInfo();
    ci.speak = Dog_speak;
    ci.toString_ = Dog_toString;
    ci.get_displayName = Dog_get_displayName;
    ci.printInfo = Dog_printInfo;
    ci.compareTo = Dog_compareTo;
    ci.isLessThan = Dog_isLessThan;
    ci.isGreaterThan = Dog_isGreaterThan;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DogValue Dog_new(AnyGC this__, String name, int age, String breed) {
  final this_ = this__ as DogValue;
  Animal_new(this_, name, age);
  this_.breed = breed;
  return this_;
}

String Dog_get_displayName(AnyGC this__) {
  final this_ = this__ as DogValue;
  return 'Dog:${this_.name}';
}

String Dog_speak(AnyGC this__) {
  final this_ = this__ as DogValue;
  return 'Woof!';
}

int Dog_compareTo(AnyGC this__, DogValue other) {
  final this_ = this__ as DogValue;
  return this_.age.compareTo(other.age);
}

String Dog_toString(AnyGC this__) {
  final this_ = this__ as DogValue;
  return Animal_toString(this_);
}

void Dog_printInfo(AnyGC this__) {
  final this_ = this__ as DogValue;
  Printable_printInfo(this_);
}

bool Dog_isLessThan(AnyGC this__, DogValue other) {
  final this_ = this__ as DogValue;
  return Orderable_isLessThan<DogValue>(this_, other);
}

bool Dog_isGreaterThan(AnyGC this__, DogValue other) {
  final this_ = this__ as DogValue;
  return Orderable_isGreaterThan<DogValue>(this_, other);
}


class CatClassInfo extends Cat_Animal_PrintableClassInfo {
  Function? get_mood;
  Function? set_mood;
}

class CatValue extends Cat_Animal_PrintableValue {
  late String _mood;
  static CatClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CatClassInfo _initClassInfo() {
    final ci = CatClassInfo();
    ci.speak = Cat_speak;
    ci.toString_ = Cat_toString;
    ci.get_displayName = Cat_get_displayName;
    ci.printInfo = Cat_printInfo;
    ci.get_mood = Cat_get_mood;
    ci.set_mood = Cat_set_mood;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CatValue Cat_new(AnyGC this__, String name, int age) {
  final this_ = this__ as CatValue;
  Animal_new(this_, name, age);
  this_._mood = 'happy';
  return this_;
}

String Cat_get_displayName(AnyGC this__) {
  final this_ = this__ as CatValue;
  return 'Cat:${this_.name}';
}

String Cat_speak(AnyGC this__) {
  final this_ = this__ as CatValue;
  return 'Meow!';
}

String Cat_get_mood(AnyGC this__) {
  final this_ = this__ as CatValue;
  return this_._mood;
}

void Cat_set_mood(AnyGC this__, String value) {
  final this_ = this__ as CatValue;
  this_._mood = value;
}

String Cat_toString(AnyGC this__) {
  final this_ = this__ as CatValue;
  return Animal_toString(this_);
}

void Cat_printInfo(AnyGC this__) {
  final this_ = this__ as CatValue;
  Printable_printInfo(this_);
}


class Vector2DClassInfo extends ClassInfo {
  Function? operatorPlus;
  Function? operatorMinus;
  Function? operatorStar;
  Function? get_length;
}

class Vector2DValue extends AnyGC {
  late double x;
  late double y;
  static Vector2DClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Vector2DClassInfo _initClassInfo() {
    final ci = Vector2DClassInfo();
    ci.operatorPlus = Vector2D_operatorPlus;
    ci.operatorMinus = Vector2D_operatorMinus;
    ci.operatorStar = Vector2D_operatorStar;
    ci.operatorEq = Vector2D_operatorEq;
    ci.get_length = Vector2D_get_length;
    ci.toString_ = Vector2D_toString;
    return ci;
  }
}

Vector2DValue Vector2D_new(AnyGC this__, double x, double y) {
  final this_ = this__ as Vector2DValue;
  this_.x = x;
  this_.y = y;
  return this_;
}

Vector2DValue Vector2D_operatorPlus(AnyGC this__, Vector2DValue other) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x + other.x), (this_.y + other.y));
}

Vector2DValue Vector2D_operatorMinus(AnyGC this__, Vector2DValue other) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x - other.x), (this_.y - other.y));
}

Vector2DValue Vector2D_operatorStar(AnyGC this__, double scalar) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x * scalar), (this_.y * scalar));
}

bool Vector2D_operatorEq(AnyGC this__, Object other) {
  final this_ = this__ as Vector2DValue;
  return (((other is Vector2DValue) && (this_.x == other.x)) && (this_.y == other.y));
}

double Vector2D_get_length(AnyGC this__) {
  final this_ = this__ as Vector2DValue;
  return ((((this_.x * this_.x) + (this_.y * this_.y)) < 0) ? 0.0 : Vector2D__sqrt(((this_.x * this_.x) + (this_.y * this_.y))));
}

double Vector2D__sqrt(double v) {
  if ((v <= 0))   return 0.0;
  double guess = (v / 2);
  for (var i = 0; (i < 20); i = (i + 1)) {
    guess = ((guess + (v / guess)) / 2);
  }
  return guess;
}

String Vector2D_toString(AnyGC this__) {
  final this_ = this__ as Vector2DValue;
  return 'Vector2D(${this_.x}, ${this_.y})';
}


class CounterClassInfo extends ClassInfo {
  Function? increment;
  Function? decrement;
  Function? get_value;
}

class CounterValue extends AnyGC {
  late int _value;
  late String label;
  static CounterClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CounterClassInfo _initClassInfo() {
    final ci = CounterClassInfo();
    ci.increment = Counter_increment;
    ci.decrement = Counter_decrement;
    ci.get_value = Counter_get_value;
    ci.toString_ = Counter_toString;
    return ci;
  }
}

int Counter__instanceCount = 0;
const int Counter_maxValue = 100;
CounterValue Counter_new__(AnyGC this__, String label, int _value) {
  final this_ = this__ as CounterValue;
  this_.label = label;
  this_._value = _value;
  Counter__instanceCount = (Counter__instanceCount + 1);
  return this_;
}

CounterValue Counter_new(String label, {int initialValue = 0}) {
  return Counter_new__(GC.allocateLocal(CounterValue()), label, initialValue);
}

CounterValue Counter_new_fromString(String spec) {
  final StaticList<String> parts = StaticList<String>.of(spec.split(':'));
  return Counter_new__(GC.allocateLocal(CounterValue()), parts[0], int.parse(parts[1]));
}

int Counter_instanceCount() {
  return Counter__instanceCount;
}

void Counter_increment(AnyGC this__, int step) {
  final this_ = this__ as CounterValue;
  this_._value = (this_._value + step).clamp(0, 100);
}

void Counter_decrement(AnyGC this__, int step) {
  final this_ = this__ as CounterValue;
  this_._value = (this_._value - step).clamp(0, 100);
}

int Counter_get_value(AnyGC this__) {
  final this_ = this__ as CounterValue;
  return this_._value;
}

String Counter_toString(AnyGC this__) {
  final this_ = this__ as CounterValue;
  return '${this_.label}: ${this_._value}';
}


class ResultClassInfo<T> extends ClassInfo {
  Function? fold;
  dynamic fold_String;
}

class ResultValue<T> extends AnyGC {
  late T? data;
  late String? error;
  late bool isSuccess;
  @override
  ClassInfo get classInfo {
    final ci = ResultClassInfo<T>();
    ci.toString_ = Result_toString<T>;
    ci.fold_String = Result_fold<T, String>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (data is AnyGC) (data as AnyGC).gcMark(flag);
  }
}

ResultValue<T> Result_new_success<T>(AnyGC this__, T value) {
  final this_ = this__ as ResultValue<T>;
  this_.data = value;
  this_.error = null;
  this_.isSuccess = true;
  return this_;
}

ResultValue<T> Result_new_failure<T>(AnyGC this__, String message) {
  final this_ = this__ as ResultValue<T>;
  this_.data = null;
  this_.error = message;
  this_.isSuccess = false;
  return this_;
}

R Result_fold<T, R>(AnyGC this__, TypeFunction1<R, T> onSuccess, TypeFunction1<R, String> onFailure) {
  final this_ = this__ as ResultValue<T>;
  if ((this_.isSuccess && !((this_.data == null)))) {
    return onSuccess.call((this_.data as T));
  }
  return onFailure.call((this_.error ?? 'Unknown error'));
}

String Result_toString<T>(AnyGC this__) {
  final this_ = this__ as ResultValue<T>;
  return (this_.isSuccess ? 'Result.success(${this_.data})' : 'Result.failure(${this_.error})');
}


class LazyLoaderClassInfo extends ClassInfo {
  Function? initialize;
  Function? get_data;
  Function? get_computedValue;
}

class LazyLoaderValue extends AnyGC {
  late String _data;
  late int _computedValue;
  late bool _initialized = false;
  static LazyLoaderClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static LazyLoaderClassInfo _initClassInfo() {
    final ci = LazyLoaderClassInfo();
    ci.initialize = LazyLoader_initialize;
    ci.get_data = LazyLoader_get_data;
    ci.get_computedValue = LazyLoader_get_computedValue;
    return ci;
  }
}

LazyLoaderValue LazyLoader_new(AnyGC this__) {
  final this_ = this__ as LazyLoaderValue;
  return this_;
}

void LazyLoader_initialize(AnyGC this__, String data) {
  final this_ = this__ as LazyLoaderValue;
  this_._data = data;
  this_._computedValue = (data.length * 2);
  this_._initialized = true;
}

String LazyLoader_get_data(AnyGC this__) {
  final this_ = this__ as LazyLoaderValue;
  return (this_._initialized ? this_._data : 'not initialized');
}

int LazyLoader_get_computedValue(AnyGC this__) {
  final this_ = this__ as LazyLoaderValue;
  return (this_._initialized ? this_._computedValue : (-1));
}


class BoundedValueClassInfo extends ClassInfo {
  Function? set;
  Function? get_current;
}

class BoundedValueValue extends AnyGC {
  late double min;
  late double max;
  late double _current;
  static BoundedValueClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static BoundedValueClassInfo _initClassInfo() {
    final ci = BoundedValueClassInfo();
    ci.set = BoundedValue_set;
    ci.get_current = BoundedValue_get_current;
    return ci;
  }
}

BoundedValueValue BoundedValue_new(AnyGC this__, double min, double max, double initial) {
  final this_ = this__ as BoundedValueValue;
  this_.min = min;
  this_.max = max;
  this_._current = initial;
  assert((this_.min <= this_.max), 'min must be <= max');
  assert(((initial >= this_.min) && (initial <= this_.max)), 'initial must be in [min, max]');
  return this_;
}

void BoundedValue_set(AnyGC this__, double value) {
  final this_ = this__ as BoundedValueValue;
  assert(((value >= this_.min) && (value <= this_.max)), 'value ${value} out of bounds [${this_.min}, ${this_.max}]');
  this_._current = value;
}

double BoundedValue_get_current(AnyGC this__) {
  final this_ = this__ as BoundedValueValue;
  return this_._current;
}


class ShapeClassInfo extends ClassInfo {
  Function? describe;
}

class ShapeValue extends AnyGC {
  late String color;
  late double opacity;
  static ShapeClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ShapeClassInfo _initClassInfo() {
    final ci = ShapeClassInfo();
    ci.describe = Shape_describe;
    return ci;
  }
}

ShapeValue Shape_new(AnyGC this__, String color, {double opacity = 1.0}) {
  final this_ = this__ as ShapeValue;
  this_.color = color;
  this_.opacity = opacity;
  return this_;
}

ShapeValue Shape_new_transparent(AnyGC this__, String color) {
  final this_ = this__ as ShapeValue;
  Shape_new(this_, color, opacity: 0.5);
  return this_;
}

String Shape_describe(AnyGC this__) {
  final this_ = this__ as ShapeValue;
  return 'Shape(color=${this_.color}, opacity=${this_.opacity})';
}


class PolygonClassInfo extends ShapeClassInfo {
  Function? perimeter;
}

class PolygonValue extends ShapeValue {
  late int sides;
  static PolygonClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static PolygonClassInfo _initClassInfo() {
    final ci = PolygonClassInfo();
    ci.describe = Polygon_describe;
    ci.perimeter = Polygon_perimeter;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

PolygonValue Polygon_new(AnyGC this__, String color, int sides, {double opacity = 1.0}) {
  final this_ = this__ as PolygonValue;
  Shape_new(this_, color, opacity: opacity);
  this_.sides = sides;
  return this_;
}

String Polygon_describe(AnyGC this__) {
  final this_ = this__ as PolygonValue;
  return 'Polygon(sides=${this_.sides}, ${Shape_describe(this_)})';
}

double Polygon_perimeter(AnyGC this__, double sideLength) {
  final this_ = this__ as PolygonValue;
  return (this_.sides * sideLength);
}


class RegularPolygonClassInfo extends PolygonClassInfo {
  Function? area;
}

class RegularPolygonValue extends PolygonValue {
  late double sideLength;
  static RegularPolygonClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static RegularPolygonClassInfo _initClassInfo() {
    final ci = RegularPolygonClassInfo();
    ci.describe = RegularPolygon_describe;
    ci.perimeter = RegularPolygon_perimeter;
    ci.area = RegularPolygon_area;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

RegularPolygonValue RegularPolygon_new(AnyGC this__, String color, int sides, double sideLength, {double opacity = 1.0}) {
  final this_ = this__ as RegularPolygonValue;
  Polygon_new(this_, color, sides, opacity: opacity);
  this_.sideLength = sideLength;
  return this_;
}

String RegularPolygon_describe(AnyGC this__) {
  final this_ = this__ as RegularPolygonValue;
  return 'RegularPolygon(sideLen=${this_.sideLength}, ${Polygon_describe(this_)})';
}

double RegularPolygon_perimeter(AnyGC this__, double? overrideSideLength) {
  final this_ = this__ as RegularPolygonValue;
  return (this_.sides * (overrideSideLength ?? this_.sideLength));
}

double RegularPolygon_area(AnyGC this__) {
  final this_ = this__ as RegularPolygonValue;
  return (((this_.sides * this_.sideLength) * this_.sideLength) / 4.0);
}


class SquareClassInfo extends RegularPolygonClassInfo {
}

class SquareValue extends RegularPolygonValue {
  static SquareClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static SquareClassInfo _initClassInfo() {
    final ci = SquareClassInfo();
    ci.describe = Square_describe;
    ci.perimeter = Square_perimeter;
    ci.area = Square_area;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

SquareValue Square_new(AnyGC this__, String color, double size, {double opacity = 1.0}) {
  final this_ = this__ as SquareValue;
  RegularPolygon_new(this_, color, 4, size, opacity: opacity);
  return this_;
}

String Square_describe(AnyGC this__) {
  final this_ = this__ as SquareValue;
  return 'Square(size=${this_.sideLength}, color=${this_.color})';
}

double Square_perimeter(AnyGC this__, double? overrideSideLength) {
  final this_ = this__ as SquareValue;
  return RegularPolygon_perimeter(this_, overrideSideLength);
}

double Square_area(AnyGC this__) {
  final this_ = this__ as SquareValue;
  return RegularPolygon_area(this_);
}


class SerializableClassInfo extends ClassInfo {
  Function? serialize;
}

class SerializableValue extends AnyGC {
  static SerializableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static SerializableClassInfo _initClassInfo() {
    final ci = SerializableClassInfo();
    ci.serialize = Serializable_serialize;
    return ci;
  }
}

SerializableValue Serializable_new(AnyGC this__) {
  final this_ = this__ as SerializableValue;
  return this_;
}

String Serializable_serialize(dynamic this_) {
  throw UnimplementedError('Serializable.serialize is abstract');
}


class CloneableClassInfo<T> extends ClassInfo {
  Function? clone;
}

class CloneableValue<T> extends AnyGC {
  @override
  ClassInfo get classInfo => CloneableClassInfo<T>();
}

CloneableValue<T> Cloneable_new<T>(AnyGC this__) {
  final this_ = this__ as CloneableValue<T>;
  return this_;
}

T Cloneable_clone<T>(dynamic this_) {
  throw UnimplementedError('Cloneable.clone is abstract');
}


class Comparable2ClassInfo<T> extends ClassInfo {
  Function? compareTo2;
}

class Comparable2Value<T> extends AnyGC {
  @override
  ClassInfo get classInfo => Comparable2ClassInfo<T>();
}

Comparable2Value<T> Comparable2_new<T>(AnyGC this__) {
  final this_ = this__ as Comparable2Value<T>;
  return this_;
}

int Comparable2_compareTo2<T>(dynamic this_, T other) {
  throw UnimplementedError('Comparable2.compareTo2 is abstract');
}


class DataPointClassInfo extends SerializableClassInfo {
  Function? clone;
  Function? compareTo2;
}

class DataPointValue extends AnyGC implements SerializableValue, CloneableValue<DataPointValue>, Comparable2Value<DataPointValue> {
  late double x;
  late double y;
  late String label;
  static DataPointClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DataPointClassInfo _initClassInfo() {
    final ci = DataPointClassInfo();
    ci.serialize = DataPoint_serialize;
    ci.clone = DataPoint_clone;
    ci.compareTo2 = DataPoint_compareTo2;
    ci.toString_ = DataPoint_toString;
    return ci;
  }
}

DataPointValue DataPoint_new(AnyGC this__, double x, double y, String label) {
  final this_ = this__ as DataPointValue;
  this_.x = x;
  this_.y = y;
  this_.label = label;
  return this_;
}

String DataPoint_serialize(AnyGC this__) {
  final this_ = this__ as DataPointValue;
  return '{"x":${this_.x},"y":${this_.y},"label":"${this_.label}"}';
}

DataPointValue DataPoint_clone(AnyGC this__) {
  final this_ = this__ as DataPointValue;
  return DataPoint_new(GC.allocateLocal(DataPointValue()), this_.x, this_.y, this_.label);
}

int DataPoint_compareTo2(AnyGC this__, DataPointValue other) {
  final this_ = this__ as DataPointValue;
  final double dx = (this_.x - other.x);
  if (!((dx == 0)))   return ((dx > 0) ? 1 : (-1));
  final double dy = (this_.y - other.y);
  if (!((dy == 0)))   return ((dy > 0) ? 1 : (-1));
  return 0;
}

String DataPoint_toString(AnyGC this__) {
  final this_ = this__ as DataPointValue;
  return 'DataPoint(${this_.x}, ${this_.y}, "${this_.label}")';
}


// mixin Loggable → static functions for delegation
void Loggable_log(AnyGC this__, String message) {
  final dynamic this_ = this__;
  staticPrint('[${(this_.classInfo as dynamic).get_logTag!(this_)}] ${message}');
}


// mixin Validatable → static functions for delegation
bool Validatable_validate(AnyGC this__) {
  final dynamic this_ = this__;
  return (this_.classInfo as dynamic).serialize!(this_).isNotEmpty;
}


class LoggedDataPointClassInfo extends LoggedDataPoint_DataPoint_Loggable_ValidatableClassInfo {
}

class LoggedDataPointValue extends LoggedDataPoint_DataPoint_Loggable_ValidatableValue {
  static LoggedDataPointClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static LoggedDataPointClassInfo _initClassInfo() {
    final ci = LoggedDataPointClassInfo();
    ci.serialize = LoggedDataPoint_serialize;
    ci.clone = LoggedDataPoint_clone;
    ci.compareTo2 = LoggedDataPoint_compareTo2;
    ci.toString_ = LoggedDataPoint_toString;
    ci.get_logTag = LoggedDataPoint_get_logTag;
    ci.log = LoggedDataPoint_log;
    ci.validate = LoggedDataPoint_validate;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

LoggedDataPointValue LoggedDataPoint_new(AnyGC this__, double x, double y, String label) {
  final this_ = this__ as LoggedDataPointValue;
  DataPoint_new(this_, x, y, label);
  return this_;
}

String LoggedDataPoint_get_logTag(AnyGC this__) {
  final this_ = this__ as LoggedDataPointValue;
  return 'DataPoint';
}

String LoggedDataPoint_serialize(AnyGC this__) {
  final this_ = this__ as LoggedDataPointValue;
  return DataPoint_serialize(this_);
}

DataPointValue LoggedDataPoint_clone(AnyGC this__) {
  final this_ = this__ as LoggedDataPointValue;
  return DataPoint_clone(this_);
}

int LoggedDataPoint_compareTo2(AnyGC this__, DataPointValue other) {
  final this_ = this__ as LoggedDataPointValue;
  return DataPoint_compareTo2(this_, other);
}

String LoggedDataPoint_toString(AnyGC this__) {
  final this_ = this__ as LoggedDataPointValue;
  return DataPoint_toString(this_);
}

void LoggedDataPoint_log(AnyGC this__, String message) {
  final this_ = this__ as LoggedDataPointValue;
  Loggable_log(this_, message);
}

bool LoggedDataPoint_validate(AnyGC this__) {
  final this_ = this__ as LoggedDataPointValue;
  return Validatable_validate(this_);
}


enum Priority {
  low(1, 'Low'),
  medium(5, 'Medium'),
  high(10, 'High'),
  critical(100, 'Critical');

  final int level;
  final String displayName;

  const Priority(this.level, this.displayName);
}

bool Priority_isHigherThan(Priority this_, Priority other) {
  return (this_.level > other.level);
}

String Priority_toString(Priority this_) {
  return '${this_.displayName}(level=${this_.level})';
}

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE');

  final String value;

  const HttpMethod(this.value);
}

bool HttpMethod_get_isReadOnly(HttpMethod this_) {
  return (this_ == HttpMethod.get);
}

class ConfigClassInfo extends ClassInfo {
}

class ConfigValue extends AnyGC {
  late String host;
  late int port;
  late bool secure;
  late String baseUrl;
  static ConfigClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ConfigClassInfo _initClassInfo() {
    final ci = ConfigClassInfo();
    ci.toString_ = Config_toString;
    return ci;
  }
}

ConfigValue Config_new(AnyGC this__, String host, int port, {bool secure = false}) {
  final this_ = this__ as ConfigValue;
  this_.host = host;
  this_.port = port;
  this_.secure = secure;
  this_.baseUrl = '${(secure ? 'https' : 'http')}://${host}:${port}';
  return this_;
}

ConfigValue Config_new_localhost(AnyGC this__, {int port = 8080}) {
  final this_ = this__ as ConfigValue;
  Config_new(this_, 'localhost', port);
  return this_;
}

ConfigValue Config_new_production(AnyGC this__, String host) {
  final this_ = this__ as ConfigValue;
  Config_new(this_, host, 443, secure: true);
  return this_;
}

String Config_toString(AnyGC this__) {
  final this_ = this__ as ConfigValue;
  return 'Config(${this_.baseUrl})';
}


class SortedListClassInfo<T> extends ClassInfo {
  Function? add;
  Function? get_first;
  Function? get_last;
  Function? get_length;
  Function? toList;
}

class SortedListValue<T extends Comparable<dynamic>> extends AnyGC {
  late StaticList<T> _items = StaticList<T>();
  @override
  ClassInfo get classInfo {
    final ci = SortedListClassInfo<T>();
    ci.add = SortedList_add<T>;
    ci.get_first = SortedList_get_first<T>;
    ci.get_last = SortedList_get_last<T>;
    ci.get_length = SortedList_get_length<T>;
    ci.toList = SortedList_toList<T>;
    ci.toString_ = SortedList_toString<T>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_items is AnyGC) (_items as AnyGC).gcMark(flag);
  }
}

SortedListValue<T> SortedList_new<T extends Comparable<dynamic>>(AnyGC this__) {
  final this_ = this__ as SortedListValue<T>;
  return this_;
}

void SortedList_add<T extends Comparable<dynamic>>(AnyGC this__, T item) {
  final this_ = this__ as SortedListValue<T>;
  this_._items.add(item);
  this_._items.sort();
}

T SortedList_get_first<T extends Comparable<dynamic>>(AnyGC this__) {
  final this_ = this__ as SortedListValue<T>;
  return this_._items.first;
}

T SortedList_get_last<T extends Comparable<dynamic>>(AnyGC this__) {
  final this_ = this__ as SortedListValue<T>;
  return this_._items.last;
}

int SortedList_get_length<T extends Comparable<dynamic>>(AnyGC this__) {
  final this_ = this__ as SortedListValue<T>;
  return this_._items.length;
}

StaticList<T> SortedList_toList<T extends Comparable<dynamic>>(AnyGC this__) {
  final this_ = this__ as SortedListValue<T>;
  return StaticList<T>.unmodifiable(this_._items);
}

String SortedList_toString<T extends Comparable<dynamic>>(AnyGC this__) {
  final this_ = this__ as SortedListValue<T>;
  return 'SortedList(${this_._items})';
}


class NullSafetyDemoClassInfo extends ClassInfo {
  Function? demonstrate;
}

class NullSafetyDemoValue extends AnyGC {
  late String? nullableField;
  late String nonNullField;
  static NullSafetyDemoClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static NullSafetyDemoClassInfo _initClassInfo() {
    final ci = NullSafetyDemoClassInfo();
    ci.demonstrate = NullSafetyDemo_demonstrate;
    return ci;
  }
}

NullSafetyDemoValue NullSafetyDemo_new(AnyGC this__, String nonNullField, [String? nullableField = null]) {
  final this_ = this__ as NullSafetyDemoValue;
  this_.nonNullField = nonNullField;
  this_.nullableField = nullableField;
  return this_;
}

String NullSafetyDemo_demonstrate(AnyGC this__) {
  final this_ = this__ as NullSafetyDemoValue;
  final int? len = this_.nullableField?.length;
  final int safeLen = (len ?? (-1));
  ((this_.nullableField == null) ? this_.nullableField = 'default' : null);
  final String forced = this_.nullableField!.toUpperCase();
  return 'len=${safeLen}, forced=${forced}';
}


class RendererClassInfo extends ClassInfo {
  Function? render;
  Function? get_name;
}

class RendererValue extends AnyGC {
  static RendererClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static RendererClassInfo _initClassInfo() {
    final ci = RendererClassInfo();
    ci.render = Renderer_render;
    ci.get_name = Renderer_get_name;
    return ci;
  }
}

RendererValue Renderer_new(AnyGC this__) {
  final this_ = this__ as RendererValue;
  return this_;
}

void Renderer_render(dynamic this_, Object shape) {
  throw UnimplementedError('Renderer.render is abstract');
}

String Renderer_get_name(dynamic this_) {
  throw UnimplementedError('Renderer.name is abstract');
}


class CircleRendererClassInfo extends RendererClassInfo {
}

class CircleRendererValue extends RendererValue {
  static CircleRendererClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CircleRendererClassInfo _initClassInfo() {
    final ci = CircleRendererClassInfo();
    ci.render = CircleRenderer_render;
    ci.get_name = CircleRenderer_get_name;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CircleRendererValue CircleRenderer_new(AnyGC this__) {
  final this_ = this__ as CircleRendererValue;
  Renderer_new(this_);
  return this_;
}

void CircleRenderer_render(AnyGC this__, String shape) {
  final this_ = this__ as CircleRendererValue;
  staticPrint('  CircleRenderer: drawing ${shape}');
}

String CircleRenderer_get_name(AnyGC this__) {
  final this_ = this__ as CircleRendererValue;
  return 'CircleRenderer';
}


class PipelineClassInfo<TInput, TOutput> extends ClassInfo {
  Function? execute;
  Function? then;
}

class PipelineValue<TInput, TOutput> extends AnyGC {
  late TypeFunction1<TOutput, TInput> _transform;
  @override
  ClassInfo get classInfo {
    final ci = PipelineClassInfo<TInput, TOutput>();
    ci.execute = Pipeline_execute<TInput, TOutput>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_transform is AnyGC) (_transform as AnyGC).gcMark(flag);
  }
}

PipelineValue<TInput, TOutput> Pipeline_new<TInput, TOutput>(AnyGC this__, TypeFunction1<TOutput, TInput> _transform) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  this_._transform = _transform;
  return this_;
}

TOutput Pipeline_execute<TInput, TOutput>(AnyGC this__, TInput input) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return (() { final _let5 = input; return this_._transform.call(_let5); })();
}

PipelineValue<TInput, TNewOutput> Pipeline_then<TInput, TOutput, TNewOutput>(AnyGC this__, TypeFunction1<TNewOutput, TOutput> next) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return Pipeline_new<TInput, TNewOutput>(GC.allocateLocal(PipelineValue<TInput, TNewOutput>()), ClosureEnv_anon_0_new<TNewOutput, TOutput, TInput>(GC.allocateLocal(ClosureEnv_anon_0<TNewOutput, TOutput, TInput>()), this_, next));
}


class BitFlagsClassInfo extends ClassInfo {
  Function? set;
  Function? clear;
  Function? has;
}

class BitFlagsValue extends AnyGC {
  late int _flags;
  static BitFlagsClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static BitFlagsClassInfo _initClassInfo() {
    final ci = BitFlagsClassInfo();
    ci.set = BitFlags_set;
    ci.clear = BitFlags_clear;
    ci.has = BitFlags_has;
    ci.toString_ = BitFlags_toString;
    return ci;
  }
}

const int BitFlags_read = 1;
const int BitFlags_write = 2;
const int BitFlags_execute = 4;
BitFlagsValue BitFlags_new(AnyGC this__, [int _flags = 0]) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = _flags;
  return this_;
}

void BitFlags_set(AnyGC this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = (this_._flags | flag);
}

void BitFlags_clear(AnyGC this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = (this_._flags & (~flag));
}

bool BitFlags_has(AnyGC this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  return !(((this_._flags & flag) == 0));
}

String BitFlags_toString(AnyGC this__) {
  final this_ = this__ as BitFlagsValue;
  final StaticList<String> parts = StaticList<String>();
  if ((this_.classInfo as BitFlagsClassInfo).has!(this_, 1))   parts.add('r');
  if ((this_.classInfo as BitFlagsClassInfo).has!(this_, 2))   parts.add('w');
  if ((this_.classInfo as BitFlagsClassInfo).has!(this_, 4))   parts.add('x');
  return (parts.isEmpty ? '-' : parts.join(''));
}


// mixin Timestamped → static functions for delegation
int Timestamped_get_timestamp(AnyGC this__) {
  final dynamic this_ = this__;
  return 1234567890;
}

String Timestamped_get_timeStr(AnyGC this__) {
  final dynamic this_ = this__;
  return 'T:${(this_.classInfo as dynamic).get_timestamp!(this_)}';
}


// mixin Tagged → static functions for delegation
void Tagged_addTag(AnyGC this__, String tag) {
  final dynamic this_ = this__;
  this_._tags.add(tag);
}

StaticList<String> Tagged_get_tags(AnyGC this__) {
  final dynamic this_ = this__;
  return StaticList<String>.unmodifiable(this_._tags);
}


class EventClassInfo extends Event_Object_Timestamped_TaggedClassInfo {
}

class EventValue extends Event_Object_Timestamped_TaggedValue {
  late String name;
  static EventClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static EventClassInfo _initClassInfo() {
    final ci = EventClassInfo();
    ci.get_timestamp = Event_get_timestamp;
    ci.get_timeStr = Event_get_timeStr;
    ci.addTag = Event_addTag;
    ci.get_tags = Event_get_tags;
    ci.toString_ = Event_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

EventValue Event_new(AnyGC this__, String name) {
  final this_ = this__ as EventValue;
  this_.name = name;
  return this_;
}

String Event_toString(AnyGC this__) {
  final this_ = this__ as EventValue;
  return 'Event(${this_.name}, ${(this_.classInfo as EventClassInfo).get_timeStr!(this_)}, tags=${(this_.classInfo as EventClassInfo).get_tags!(this_)})';
}

int Event_get_timestamp(AnyGC this__) {
  final this_ = this__ as EventValue;
  return Timestamped_get_timestamp(this_);
}

String Event_get_timeStr(AnyGC this__) {
  final this_ = this__ as EventValue;
  return Timestamped_get_timeStr(this_);
}

void Event_addTag(AnyGC this__, String tag) {
  final this_ = this__ as EventValue;
  Tagged_addTag(this_, tag);
}

StaticList<String> Event_get_tags(AnyGC this__) {
  final this_ = this__ as EventValue;
  return Tagged_get_tags(this_);
}


class ImportantEventClassInfo extends ImportantEvent_Event_LoggableClassInfo {
}

class ImportantEventValue extends ImportantEvent_Event_LoggableValue {
  late Priority priority;
  static ImportantEventClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ImportantEventClassInfo _initClassInfo() {
    final ci = ImportantEventClassInfo();
    ci.get_timestamp = ImportantEvent_get_timestamp;
    ci.get_timeStr = ImportantEvent_get_timeStr;
    ci.addTag = ImportantEvent_addTag;
    ci.get_tags = ImportantEvent_get_tags;
    ci.toString_ = ImportantEvent_toString;
    ci.get_logTag = ImportantEvent_get_logTag;
    ci.log = ImportantEvent_log;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (priority is AnyGC) (priority as AnyGC).gcMark(flag);
  }
}

ImportantEventValue ImportantEvent_new(AnyGC this__, String name, Priority priority) {
  final this_ = this__ as ImportantEventValue;
  Event_new(this_, name);
  this_.priority = priority;
  return this_;
}

String ImportantEvent_get_logTag(AnyGC this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent';
}

String ImportantEvent_toString(AnyGC this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent(${this_.name}, ${Priority_toString(this_.priority)}, ${(this_.classInfo as ImportantEventClassInfo).get_timeStr!(this_)})';
}

int ImportantEvent_get_timestamp(AnyGC this__) {
  final this_ = this__ as ImportantEventValue;
  return Timestamped_get_timestamp(this_);
}

String ImportantEvent_get_timeStr(AnyGC this__) {
  final this_ = this__ as ImportantEventValue;
  return Timestamped_get_timeStr(this_);
}

void ImportantEvent_addTag(AnyGC this__, String tag) {
  final this_ = this__ as ImportantEventValue;
  Tagged_addTag(this_, tag);
}

StaticList<String> ImportantEvent_get_tags(AnyGC this__) {
  final this_ = this__ as ImportantEventValue;
  return Tagged_get_tags(this_);
}

void ImportantEvent_log(AnyGC this__, String message) {
  final this_ = this__ as ImportantEventValue;
  Loggable_log(this_, message);
}


class Dog_Animal_PrintableClassInfo extends AnimalClassInfo {
  Function? get_displayName;
  Function? printInfo;
}

class Dog_Animal_PrintableValue extends AnimalValue {
  static Dog_Animal_PrintableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Dog_Animal_PrintableClassInfo _initClassInfo() {
    final ci = Dog_Animal_PrintableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Dog_Animal_Printable_OrderableClassInfo extends Dog_Animal_PrintableClassInfo {
  Function? compareTo;
  Function? isLessThan;
  Function? isGreaterThan;
}

class Dog_Animal_Printable_OrderableValue extends Dog_Animal_PrintableValue {
  static Dog_Animal_Printable_OrderableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Dog_Animal_Printable_OrderableClassInfo _initClassInfo() {
    final ci = Dog_Animal_Printable_OrderableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Cat_Animal_PrintableClassInfo extends AnimalClassInfo {
  Function? get_displayName;
  Function? printInfo;
}

class Cat_Animal_PrintableValue extends AnimalValue {
  static Cat_Animal_PrintableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Cat_Animal_PrintableClassInfo _initClassInfo() {
    final ci = Cat_Animal_PrintableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class LoggedDataPoint_DataPoint_LoggableClassInfo extends DataPointClassInfo {
  Function? get_logTag;
  Function? log;
}

class LoggedDataPoint_DataPoint_LoggableValue extends DataPointValue {
  static LoggedDataPoint_DataPoint_LoggableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static LoggedDataPoint_DataPoint_LoggableClassInfo _initClassInfo() {
    final ci = LoggedDataPoint_DataPoint_LoggableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class LoggedDataPoint_DataPoint_Loggable_ValidatableClassInfo extends LoggedDataPoint_DataPoint_LoggableClassInfo {
  Function? validate;
}

class LoggedDataPoint_DataPoint_Loggable_ValidatableValue extends LoggedDataPoint_DataPoint_LoggableValue {
  static LoggedDataPoint_DataPoint_Loggable_ValidatableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static LoggedDataPoint_DataPoint_Loggable_ValidatableClassInfo _initClassInfo() {
    final ci = LoggedDataPoint_DataPoint_Loggable_ValidatableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Event_Object_TimestampedClassInfo extends ClassInfo {
  Function? get_timestamp;
  Function? get_timeStr;
}

class Event_Object_TimestampedValue extends AnyGC {
  static Event_Object_TimestampedClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Event_Object_TimestampedClassInfo _initClassInfo() {
    final ci = Event_Object_TimestampedClassInfo();
    return ci;
  }
}


class Event_Object_Timestamped_TaggedClassInfo extends Event_Object_TimestampedClassInfo {
  Function? addTag;
  Function? get_tags;
}

class Event_Object_Timestamped_TaggedValue extends Event_Object_TimestampedValue {
  late StaticList<String> _tags = StaticList<String>();
  static Event_Object_Timestamped_TaggedClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Event_Object_Timestamped_TaggedClassInfo _initClassInfo() {
    final ci = Event_Object_Timestamped_TaggedClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_tags is AnyGC) (_tags as AnyGC).gcMark(flag);
  }
}


class ImportantEvent_Event_LoggableClassInfo extends EventClassInfo {
  Function? get_logTag;
  Function? log;
}

class ImportantEvent_Event_LoggableValue extends EventValue {
  static ImportantEvent_Event_LoggableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ImportantEvent_Event_LoggableClassInfo _initClassInfo() {
    final ci = ImportantEvent_Event_LoggableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


String formatMessage(String template, [String? subject = null, int? count = null]) {
  String result = template;
  if (!((subject == null)))   result = result.replaceAll('{subject}', subject);
  if (!((count == null)))   result = result.replaceAll('{count}', count.toString());
  return result;
}

String buildQuery({required String endpoint, StaticMap<String, String>? params = null, int maxWait = 30, bool secure = true}) {
  final String scheme = (secure ? 'https' : 'http');
  final String query = ((() { final _let8 = params; return (_let8 == null) ? null : _let8.entries.map(ClosureEnv_buildQuery_1_new(GC.allocateLocal(ClosureEnv_buildQuery_1()))).join('&'); })() ?? '');
  final String suffix = (query.isEmpty ? '' : '?${query}');
  return '${scheme}://${endpoint}${suffix} (timeout=${maxWait}s)';
}

Iterable<int> range(int start, int end, [int step = 1]) sync* {
  for (var i = start; (i < end); i = (i + step)) {
    yield i;
  }
}

Iterable<int> fibonacci(int count) sync* {
  int a = 0;
  int b = 1;
  for (var i = 0; (i < count); i = (i + 1)) {
    yield a;
    final int next = (a + b);
    a = b;
    b = next;
  }
}

Promise<StaticList<String>> countDown(int from) {
  final env = ClosureEnv_countDown_2(from);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

(String, int) getPersonRecord() {
  return ('Alice', 30);
}

(String, double, double) getLocation() {
  return ('Beijing', 39.9, 116.4);
}

(int, int) divmod(int a, int b) {
  return ((a ~/ b), (a % b));
}

String describeValue(Object? value) {
  return (() {   late String _v9;
  final Object? _v10 = value;
  const dynamic _v11 = null;
  _L12: do {
{
{
        if ((_v10 == null)) {
          _v9 = 'null';
          break _L12;
        }
      }
{
        late int n;
        if ((((_v10 is int) && (() { final _let13 = n = _v10; return true; })()) && (n < 0))) {
          _v9 = 'negative int: ${n}';
          break _L12;
        }
      }
{
        late int n;
        if ((_v10 is int)) {
          n = _v10;
          _v9 = 'positive int: ${n}';
          break _L12;
        }
      }
{
        late String s;
        if ((((_v10 is String) && (() { final _let14 = s = _v10; return true; })()) && s.isEmpty)) {
          _v9 = 'empty string';
          break _L12;
        }
      }
{
        late String s;
        if ((_v10 is String)) {
          s = _v10;
          _v9 = 'string: "${s}"';
          break _L12;
        }
      }
{
        late StaticList<dynamic> list;
        if ((((_v10 is StaticList<dynamic>) && (() { final _let15 = list = _v10; return true; })()) && list.isEmpty)) {
          _v9 = 'empty list';
          break _L12;
        }
      }
{
        late StaticList<dynamic> list;
        if ((_v10 is StaticList<dynamic>)) {
          list = _v10;
          _v9 = 'list of ${list.length}';
          break _L12;
        }
      }
{
        if (true) {
          _v9 = 'unknown: ${value.runtimeType}';
          break _L12;
        }
      }
    }
  } while (false);
 return _v9; })();
}

StaticList<int> buildList() {
  return (StaticList<int>()..add(1)..add(2)..addAll(StaticList<int>.of([3, 4, 5]))..sort());
}

StaticStringBuffer buildBuffer() {
  return (StaticStringBuffer()..write('Hello')..write(', ')..write('World')..writeln('!'));
}

StaticList<int> mergeAndFilter(StaticList<int> a, StaticList<int> b, bool includeNegative) {
  return (() {   final StaticList<int> _v18 = StaticList<int>.of(a);
  _v18.addAll(b);
  if (includeNegative)   _v18.add((-1));
  for (var i = 10; (i <= 12); i = (i + 1))   _v18.add(i);
 return _v18; })();
}

StaticMap<String, int> buildScoreMap(StaticList<String> names, bool addBonus) {
  return (() {   final StaticMap<String, int> _v19 = StaticMap<String, int>.of({});
  for (var i = 0; (i < names.length); i = (i + 1))   _v19[names[i]] = ((i + 1) * 10);
  if (addBonus)   _v19['bonus'] = 999;
 return _v19; })();
}

int parseAndDivide(String a, String b) {
  try {
    final int x = int.parse(a);
    final int y = int.parse(b);
    if ((y == 0))     throw DartArgumentError('Division by zero');
    return (x ~/ y);
  }
 on FormatException {
    rethrow;
  }
 on ArgumentError catch (e) {
    throw DartStateError('Math error: ${e.message}');
  }
}

String multiLineExample() {
  final String raw = 'raw\\nstring\\ttabs';
  final String multiLine = 'line1\nline2\nline3';
  final String nested = 'lines: ${multiLine.split('\n').length}, raw: ${raw}';
  return nested;
}

TypeFunction1<C, A> compose<A, B, C>(TypeFunction1<B, A> f, TypeFunction1<C, B> g) {
  return ClosureEnv_compose_3_new<C, B, A>(GC.allocateLocal(ClosureEnv_compose_3<C, B, A>()), g, f);
}

TypeFunction1<bool, T> and<T>(TypeFunction1<bool, T> p1, TypeFunction1<bool, T> p2) {
  return ClosureEnv_and_4_new<T>(GC.allocateLocal(ClosureEnv_and_4<T>()), p1, p2);
}

StaticList<B> flatMap<A, B>(StaticList<A> list, TypeFunction1<StaticList<B>, A> f) {
  return StaticList.of(list.expand(f).toList());
}

T findMax<T extends Comparable<dynamic>>(StaticList<T> items) {
  T maxItem = items.first;
{
    StaticIterator<T> sync_for_iterator = StaticIterator(items.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final T item = sync_for_iterator.current;
{
        if ((item.compareTo(maxItem) > 0)) {
          maxItem = item;
        }
      }
    }
  }
  return maxItem;
}

R applyTwice<T, R>(T value, TypeFunction1<R, T> fn1, TypeFunction1<R, R> fn2) {
  return fn2.call(fn1.call(value));
}

String? findFirst(StaticList<String> items, TypeFunction1<bool, String> test) {
{
    StaticIterator<String> sync_for_iterator = StaticIterator(items.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final String item = sync_for_iterator.current;
{
        if (test.call(item))         return item;
      }
    }
  }
  return null;
}

StaticList<int> filterWithForIn(StaticList<int> items) {
  final StaticList<int> result = StaticList<int>();
{
    StaticIterator<int> sync_for_iterator = StaticIterator(items.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final int item = sync_for_iterator.current;
{
        if (((item >= 0) && (item <= 100))) {
          result.add(item);
        }
      }
    }
  }
  return result;
}

int collatzSteps(int n) {
  int steps = 0;
  _L20:
  do {
    if ((n == 1))     break _L20;
    if (((n % 2) == 0)) {
      n = (n ~/ 2);
    }
 else {
      n = ((3 * n) + 1);
    }
    steps = (steps + 1);
  }
 while (!((n == 1)));
  return steps;
}

String typeTest(Object value) {
  if ((value is int)) {
    return 'int: ${(value * 2)}';
  }
 else   if ((value is String)) {
    return 'string: ${value.toUpperCase()}';
  }
 else   if ((value is StaticList<int>)) {
    return 'list<int>: ${value.length} items';
  }
 else   if ((value is bool)) {
    return 'bool: ${value}';
  }
  return 'other: ${value.runtimeType}';
}

double safeCast(Object value) {
  try {
    return (value as double);
  }
 catch (e) {
    return 0.0;
  }
}

String tryCatchFinally(int code) {
  final StaticStringBuffer log = StaticStringBuffer();
  try {
    log.write('try ');
    if ((code == 1))     throw DartFormatException('bad format');
    if ((code == 2))     throw DartArgumentError('bad arg');
    log.write('ok ');
  }
 on FormatException catch (e) {
    log.write('format:${e.message} ');
  }
 on ArgumentError catch (e) {
    log.write('arg:${e.message} ');
  }
 catch (e) {
    log.write('other:${e} ');
  }
 finally {
    log.write('finally');
  }
  return log.toString();
}

String dayType(int day) {
  _L21: do {
    switch (day) {
      case 1:
      case 7:
{
          return 'weekend';
        }
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
{
          return 'weekday';
        }
      default:
{
          return 'invalid';
        }
    }
  } while (false);
}

void main() {
  staticPrint('=== 全面语法节点还原测试 ===\n');
  staticPrint('--- 1. mixin + implements ---');
  final DogValue dog1 = Dog_new(GC.allocateLocal(DogValue()), 'Rex', 3, 'Labrador');
  final DogValue dog2 = Dog_new(GC.allocateLocal(DogValue()), 'Max', 5, 'Poodle');
  (dog1.classInfo as DogClassInfo).printInfo!(dog1);
  staticPrint('${(dog1.classInfo as DogClassInfo).speak!(dog1)} (${dog1.breed})');
  staticPrint('dog1 < dog2: ${(dog1.classInfo as DogClassInfo).isLessThan!(dog1, dog2)}');
  staticPrint('dog1 > dog2: ${(dog1.classInfo as DogClassInfo).isGreaterThan!(dog1, dog2)}');
  final CatValue cat = Cat_new(GC.allocateLocal(CatValue()), 'Whiskers', 2);
  (cat.classInfo as CatClassInfo).printInfo!(cat);
  staticPrint('${(cat.classInfo as CatClassInfo).speak!(cat)}, mood: ${(cat.classInfo as CatClassInfo).get_mood!(cat)}');
  (cat.classInfo as CatClassInfo).set_mood!(cat, 'sleepy');
  staticPrint('mood after set: ${(cat.classInfo as CatClassInfo).get_mood!(cat)}');
  staticPrint('\n--- 2. operator 重载 ---');
  final Vector2DValue v1 = Vector2D_new(Vector2DValue(), 3.0, 4.0);
  final Vector2DValue v2 = Vector2D_new(Vector2DValue(), 1.0, 2.0);
  final Vector2DValue sum = (() { final _r22 = Vector2D_new(Vector2DValue(), 3.0, 4.0); return (_r22.classInfo as dynamic).operatorPlus!(_r22, Vector2D_new(Vector2DValue(), 1.0, 2.0)); })();
  final Vector2DValue diff = (() { final _r23 = Vector2D_new(Vector2DValue(), 3.0, 4.0); return (_r23.classInfo as dynamic).operatorMinus!(_r23, Vector2D_new(Vector2DValue(), 1.0, 2.0)); })();
  final Vector2DValue scaled = (() { final _r24 = Vector2D_new(Vector2DValue(), 3.0, 4.0); return (_r24.classInfo as dynamic).operatorStar!(_r24, 2.0); })();
  staticPrint('v1 + v2 = ${sum}');
  staticPrint('v1 - v2 = ${diff}');
  staticPrint('v1 * 2 = ${scaled}');
  staticPrint('v1.length = ${(() { final _r25 = Vector2D_new(Vector2DValue(), 3.0, 4.0); return (_r25.classInfo as dynamic).get_length!(_r25); })().toStringAsFixed(2)}');
  staticPrint('v1 == Vector2D(3,4): ${(Vector2D_new(Vector2DValue(), 3.0, 4.0) == Vector2D_new(Vector2DValue(), 3.0, 4.0))}');
  staticPrint('\n--- 3. static + factory ---');
  final CounterValue c1 = Counter_new('alpha');
  final CounterValue c2 = Counter_new('beta', initialValue: 50);
  final CounterValue c3 = Counter_new_fromString('gamma:25');
  (c1.classInfo as CounterClassInfo).increment!(c1, 10);
  (c2.classInfo as CounterClassInfo).decrement!(c2, 5);
  (c3.classInfo as CounterClassInfo).increment!(c3, 1);
  staticPrint('${c1}, ${c2}, ${c3}');
  staticPrint('instances: ${Counter_instanceCount()}');
  staticPrint('maxValue: 100');
  staticPrint('\n--- 4. Result<T> + named params ---');
  final ResultValue<int> ok = Result_new_success<int>(ResultValue<int>(), 42);
  final ResultValue<int> err = Result_new_failure<int>(ResultValue<int>(), 'not found');
  staticPrint('ok: ${Result_new_success<int>(ResultValue<int>(), 42)}');
  staticPrint('err: ${Result_new_failure<int>(ResultValue<int>(), 'not found')}');
  final String okMsg = (() { final _r26 = Result_new_success<int>(ResultValue<int>(), 42); return (_r26.classInfo as dynamic).fold_String!(_r26, ClosureEnv_main_5_new(GC.allocateLocal(ClosureEnv_main_5())), ClosureEnv_main_6_new(GC.allocateLocal(ClosureEnv_main_6()))); })();
  final String errMsg = (() { final _r27 = Result_new_failure<int>(ResultValue<int>(), 'not found'); return (_r27.classInfo as dynamic).fold_String!(_r27, ClosureEnv_main_7_new(GC.allocateLocal(ClosureEnv_main_7())), ClosureEnv_main_8_new(GC.allocateLocal(ClosureEnv_main_8()))); })();
  staticPrint('okMsg: ${okMsg}');
  staticPrint('errMsg: ${errMsg}');
  staticPrint('\n--- 5. 可选参数 ---');
  staticPrint(formatMessage('Hello {subject}!', 'Dart'));
  staticPrint(formatMessage('Count: {count}', null, 99));
  staticPrint(formatMessage('No params'));
  staticPrint(buildQuery(endpoint: 'api.example.com/users'));
  staticPrint(buildQuery(endpoint: 'api.example.com/search', params: StaticMap<String, String>.of({'q': 'dart', 'page': '1'}), maxWait: 10, secure: false));
  staticPrint('\n--- 6. sync* 生成器 ---');
  final StaticList<int> r = StaticList.of(range(0, 10, 2).toList());
  staticPrint('range(0,10,2): ${r}');
  final StaticList<int> fib = StaticList.of(fibonacci(8).toList());
  staticPrint('fibonacci(8): ${fib}');
  staticPrint('\n--- 7. async countdown ---');
  final StaticList<String> countdown = StaticList<String>.of(smAwait(countDown(3)));
  staticPrint('countdown: ${countdown}');
  staticPrint('\n--- 8. record 类型 ---');
  final (String, int) person = getPersonRecord();
  staticPrint('person: ${person.$1}, age=${person.$2}');
  final (String, double, double) loc = getLocation();
  staticPrint('location: ${loc.$1} (${loc.$2}, ${loc.$3})');
  final int q;
  final int r2;
{
    final (int, int) _v10 = divmod(17, 5);
    q = _v10.$1;
    r2 = _v10.$2;
  }
  staticPrint('divmod(17,5): quotient=${q}, remainder=${r2}');
  staticPrint('\n--- 9. pattern matching ---');
  final StaticList<Object?> values = StaticList<Object?>.of([null, (-5), 42, '', 'hello']);
{
    StaticIterator<Object?> sync_for_iterator = StaticIterator(values.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final Object? v = sync_for_iterator.current;
{
        staticPrint('  ${describeValue(v)}');
      }
    }
  }
  staticPrint('\n--- 10. 级联操作符 ---');
  final StaticList<int> list = StaticList<int>.of(buildList());
  staticPrint('buildList: ${list}');
  final StaticStringBuffer buf = buildBuffer();
  staticPrint('buildBuffer: ${buf.toString().trim()}');
  staticPrint('\n--- 11. 展开 + 集合 if/for ---');
  final StaticList<int> merged = StaticList<int>.of(mergeAndFilter(StaticList<int>.of([1, 2]), StaticList<int>.of([3, 4]), true));
  staticPrint('merged(includeNeg=true): ${merged}');
  final StaticList<int> mergedNoNeg = StaticList<int>.of(mergeAndFilter(StaticList<int>.of([1, 2]), StaticList<int>.of([3, 4]), false));
  staticPrint('merged(includeNeg=false): ${mergedNoNeg}');
  final StaticMap<String, int> scores = StaticMap<String, int>.of(buildScoreMap(StaticList<String>.of(['Alice', 'Bob', 'Carol']), true));
  staticPrint('scores: ${scores}');
  staticPrint('\n--- 12. late 变量 ---');
  final LazyLoaderValue loader = LazyLoader_new(GC.allocateLocal(LazyLoaderValue()));
  staticPrint('before init: ${(loader.classInfo as LazyLoaderClassInfo).get_data!(loader)}, ${(loader.classInfo as LazyLoaderClassInfo).get_computedValue!(loader)}');
  (loader.classInfo as LazyLoaderClassInfo).initialize!(loader, 'hello');
  staticPrint('after init: ${(loader.classInfo as LazyLoaderClassInfo).get_data!(loader)}, ${(loader.classInfo as LazyLoaderClassInfo).get_computedValue!(loader)}');
  staticPrint('\n--- 13. rethrow ---');
  try {
    parseAndDivide('10', '2');
    staticPrint('10/2 = ${parseAndDivide('10', '2')}');
  }
 catch (e) {
    staticPrint('unexpected: ${e}');
  }
  try {
    parseAndDivide('10', '0');
  }
 on StateError catch (e) {
    staticPrint('StateError: ${e.message}');
  }
  try {
    parseAndDivide('abc', '2');
  }
 on FormatException catch (e) {
    staticPrint('FormatException: ${e.message}');
  }
  staticPrint('\n--- 14. assert ---');
  final BoundedValueValue bv = BoundedValue_new(GC.allocateLocal(BoundedValueValue()), 0.0, 10.0, 5.0);
  (bv.classInfo as BoundedValueClassInfo).set!(bv, 7.5);
  staticPrint('BoundedValue: ${(bv.classInfo as BoundedValueClassInfo).get_current!(bv)}');
  staticPrint('\n--- 15. 字符串 ---');
  staticPrint(multiLineExample());
  staticPrint('\n--- 16. typedef + 函数式组合 ---');
  final TypeFunction1<String, int> doubleIt = compose<int, int, String>(ClosureEnv_main_9_new(GC.allocateLocal(ClosureEnv_main_9())), ClosureEnv_main_10_new(GC.allocateLocal(ClosureEnv_main_10())));
  staticPrint('compose(5): ${doubleIt.call(5)}');
  final TypeFunction1<bool, int> isPositive = ClosureEnv_main_11_new(GC.allocateLocal(ClosureEnv_main_11()));
  final TypeFunction1<bool, int> isEven = ClosureEnv_main_12_new(GC.allocateLocal(ClosureEnv_main_12()));
  final TypeFunction1<bool, int> isPositiveEven = and<int>(isPositive, isEven);
  final StaticList<int> nums = StaticList<int>.of([(-2), (-1), 0, 1, 2, 3, 4]);
  staticPrint('positiveEvens: ${StaticList.of(nums.where(isPositiveEven).toList())}');
  final StaticList<int> nested = StaticList<int>.of(flatMap<int, int>(StaticList<int>.of([1, 2, 3]), ClosureEnv_main_13_new(GC.allocateLocal(ClosureEnv_main_13()))));
  staticPrint('flatMap: ${nested}');
  staticPrint('\n--- 19. 多层继承链 ---');
  final ShapeValue shape = Shape_new(GC.allocateLocal(ShapeValue()), 'red');
  staticPrint((shape.classInfo as ShapeClassInfo).describe!(shape));
  final ShapeValue transparentShape = Shape_new_transparent(GC.allocateLocal(ShapeValue()), 'blue');
  staticPrint((transparentShape.classInfo as ShapeClassInfo).describe!(transparentShape));
  final PolygonValue polygon = Polygon_new(GC.allocateLocal(PolygonValue()), 'green', 6, opacity: 0.8);
  staticPrint((polygon.classInfo as PolygonClassInfo).describe!(polygon));
  staticPrint('perimeter: ${(polygon.classInfo as PolygonClassInfo).perimeter!(polygon, 3.0)}');
  final RegularPolygonValue hexagon = RegularPolygon_new(GC.allocateLocal(RegularPolygonValue()), 'yellow', 6, 5.0);
  staticPrint((hexagon.classInfo as RegularPolygonClassInfo).describe!(hexagon));
  staticPrint('perimeter: ${(hexagon.classInfo as RegularPolygonClassInfo).perimeter!(hexagon, null)}');
  staticPrint('area: ${(hexagon.classInfo as RegularPolygonClassInfo).area!(hexagon)}');
  final SquareValue square = Square_new(GC.allocateLocal(SquareValue()), 'white', 10.0, opacity: 0.9);
  staticPrint((square.classInfo as SquareClassInfo).describe!(square));
  staticPrint('square perimeter: ${(square.classInfo as SquareClassInfo).perimeter!(square, null)}');
  staticPrint('\n--- 20. implements 多接口 ---');
  final DataPointValue dp1 = DataPoint_new(GC.allocateLocal(DataPointValue()), 1.0, 2.0, 'A');
  final DataPointValue dp2 = DataPoint_new(GC.allocateLocal(DataPointValue()), 3.0, 1.0, 'B');
  staticPrint('dp1: ${dp1}');
  staticPrint('dp1.serialize: ${(dp1.classInfo as DataPointClassInfo).serialize!(dp1)}');
  final DataPointValue dp1Clone = (dp1.classInfo as DataPointClassInfo).clone!(dp1);
  staticPrint('dp1.clone: ${dp1Clone}');
  staticPrint('dp1.compareTo2(dp2): ${(dp1.classInfo as DataPointClassInfo).compareTo2!(dp1, dp2)}');
  staticPrint('\n--- 21. mixin on 约束 ---');
  final LoggedDataPointValue ldp = LoggedDataPoint_new(GC.allocateLocal(LoggedDataPointValue()), 5.0, 6.0, 'logged');
  (ldp.classInfo as LoggedDataPointClassInfo).log!(ldp, 'created');
  staticPrint('validate: ${(ldp.classInfo as LoggedDataPointClassInfo).validate!(ldp)}');
  staticPrint('serialize: ${(ldp.classInfo as LoggedDataPointClassInfo).serialize!(ldp)}');
  staticPrint('\n--- 22. 增强枚举 ---');
  staticPrint('Priority.high: ${Priority}.high');
  staticPrint('high > medium: ${Priority_isHigherThan(Priority.high, Priority.medium)}');
  staticPrint('low > high: ${Priority_isHigherThan(Priority.low, Priority.high)}');
{
    StaticIterator<Priority> sync_for_iterator = StaticIterator(const [Priority.low, Priority.medium, Priority.high, Priority.critical].iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final Priority p = sync_for_iterator.current;
{
        staticPrint('  ${Priority_toString(p)}');
      }
    }
  }
  staticPrint('GET isReadOnly: ${HttpMethod_get_isReadOnly(HttpMethod.get)}');
  staticPrint('POST isReadOnly: ${HttpMethod_get_isReadOnly(HttpMethod.post)}');
  staticPrint('\n--- 23. 重定向构造函数 ---');
  final ConfigValue cfg1 = Config_new(GC.allocateLocal(ConfigValue()), 'example.com', 8080);
  final ConfigValue cfg2 = Config_new_localhost(GC.allocateLocal(ConfigValue()));
  final ConfigValue cfg3 = Config_new_production(GC.allocateLocal(ConfigValue()), 'api.example.com');
  staticPrint('cfg1: ${cfg1}');
  staticPrint('cfg2: ${cfg2}');
  staticPrint('cfg3: ${cfg3}');
  staticPrint('\n--- 25. null safety ---');
  final NullSafetyDemoValue ns1 = NullSafetyDemo_new(GC.allocateLocal(NullSafetyDemoValue()), 'hello', 'world');
  staticPrint('ns1: ${(ns1.classInfo as NullSafetyDemoClassInfo).demonstrate!(ns1)}');
  final NullSafetyDemoValue ns2 = NullSafetyDemo_new(GC.allocateLocal(NullSafetyDemoValue()), 'hello');
  staticPrint('ns2: ${(ns2.classInfo as NullSafetyDemoClassInfo).demonstrate!(ns2)}');
  final String? found = findFirst(StaticList<String>.of(['apple', 'banana', 'cherry']), ClosureEnv_main_14_new(GC.allocateLocal(ClosureEnv_main_14())));
  staticPrint('findFirst(b): ${found}');
  final String? notFound = findFirst(StaticList<String>.of(['apple', 'banana']), ClosureEnv_main_15_new(GC.allocateLocal(ClosureEnv_main_15())));
  staticPrint('findFirst(z): ${notFound}');
  staticPrint('\n--- 26. for-in + do-while ---');
  final StaticList<int> filtered = StaticList<int>.of(filterWithForIn(StaticList<int>.of([5, (-3), 10, 200, 50, (-1), 80])));
  staticPrint('filterWithForIn: ${filtered}');
  staticPrint('collatz(6): ${collatzSteps(6)}');
  staticPrint('collatz(27): ${collatzSteps(27)}');
  staticPrint('\n--- 27. 类型测试 ---');
  staticPrint(typeTest(42));
  staticPrint(typeTest('hello'));
  staticPrint(typeTest(true));
  staticPrint(typeTest(StaticList<int>.of([1, 2, 3])));
  staticPrint('safeCast(3.14): ${safeCast(3.14)}');
  staticPrint('safeCast("x"): ${safeCast('x')}');
  staticPrint('\n--- 28. try-catch-finally ---');
  staticPrint('code=0: ${tryCatchFinally(0)}');
  staticPrint('code=1: ${tryCatchFinally(1)}');
  staticPrint('code=2: ${tryCatchFinally(2)}');
  staticPrint('\n--- 29. covariant ---');
  final CircleRendererValue renderer = CircleRenderer_new(GC.allocateLocal(CircleRendererValue()));
  staticPrint('renderer: ${(renderer.classInfo as CircleRendererClassInfo).get_name!(renderer)}');
  (renderer.classInfo as CircleRendererClassInfo).render!(renderer, 'circle');
  staticPrint('\n--- 31. switch-case ---');
  staticPrint('day 1: ${dayType(1)}');
  staticPrint('day 3: ${dayType(3)}');
  staticPrint('day 7: ${dayType(7)}');
  staticPrint('day 9: ${dayType(9)}');
  staticPrint('\n--- 32. 位运算 ---');
  final BitFlagsValue flags = BitFlags_new(GC.allocateLocal(BitFlagsValue()));
  (flags.classInfo as BitFlagsClassInfo).set!(flags, 1);
  (flags.classInfo as BitFlagsClassInfo).set!(flags, 4);
  staticPrint('flags: ${flags}');
  staticPrint('has read: ${(flags.classInfo as BitFlagsClassInfo).has!(flags, 1)}');
  staticPrint('has write: ${(flags.classInfo as BitFlagsClassInfo).has!(flags, 2)}');
  (flags.classInfo as BitFlagsClassInfo).set!(flags, 2);
  staticPrint('after set write: ${flags}');
  (flags.classInfo as BitFlagsClassInfo).clear!(flags, 4);
  staticPrint('after clear execute: ${flags}');
  staticPrint('\n--- 33. 多层 mixin ---');
  final EventValue event = Event_new(GC.allocateLocal(EventValue()), 'meeting');
  (event.classInfo as EventClassInfo).addTag!(event, 'work');
  (event.classInfo as EventClassInfo).addTag!(event, 'important');
  staticPrint(event);
  final ImportantEventValue impEvent = ImportantEvent_new(GC.allocateLocal(ImportantEventValue()), 'deadline', Priority.critical);
  (impEvent.classInfo as ImportantEventClassInfo).addTag!(impEvent, 'urgent');
  (impEvent.classInfo as ImportantEventClassInfo).log!(impEvent, 'created');
  staticPrint(impEvent);
  staticPrint('\n=== 所有测试通过 ✅ ===');
  drainScheduler();
}

class ClosureEnv_anon_0<TNewOutput, TOutput, TInput> extends TypeFunction1<TNewOutput, TInput> {
  late PipelineValue<TInput, TOutput> this_;
  late TypeFunction1<TNewOutput, TOutput> next;
  ClosureEnv_anon_0();
  @override
  TNewOutput call(TInput input) => fnPtr(this, input);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
    if (next is AnyGC) (next as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_0<TNewOutput, TOutput, TInput> ClosureEnv_anon_0_new<TNewOutput, TOutput, TInput>(ClosureEnv_anon_0<TNewOutput, TOutput, TInput> env_, PipelineValue<TInput, TOutput> this_, TypeFunction1<TNewOutput, TOutput> next) {
  env_.fnPtr = ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>;
  env_.this_ = this_;
  env_.next = next;
  return env_;
}
TNewOutput ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>(AnyGC env__, TInput input) {
  final env = env__ as ClosureEnv_anon_0<TNewOutput, TOutput, TInput>;

  return env.next.call((() { final _let6 = input; return env.this_._transform.call(_let6); })());
}

class ClosureEnv_buildQuery_1 extends TypeFunction1<String, StaticMapEntry<String, String>> {
  ClosureEnv_buildQuery_1();
  @override
  String call(StaticMapEntry<String, String> e) => fnPtr(this, e);
}
ClosureEnv_buildQuery_1 ClosureEnv_buildQuery_1_new(ClosureEnv_buildQuery_1 env_) {
  env_.fnPtr = ClosureEnv_buildQuery_1_call;
  return env_;
}
String ClosureEnv_buildQuery_1_call(AnyGC env__, StaticMapEntry<String, String> e) {
  final env = env__ as ClosureEnv_buildQuery_1;

  return '${e.key}=${e.value}';
}

class ClosureEnv_countDown_2 {
  IntBox from;
  Promise<StaticList<String>> _promise;
  ClosureEnv_countDown_2(int from) : _promise = Promise<StaticList<String>>(), from = IntBox(from);
  void call() => ClosureEnv_countDown_2_call(this);
}
void ClosureEnv_countDown_2_call(ClosureEnv_countDown_2 env) {
  final StaticList<String> result = StaticList<String>();
  for (var i = env.from.value; (i >= 0); i = (i - 1)) {
    smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 1)));
    result.add(((i == 0) ? 'Go!' : '${i}...'));
  }
{
    env._promise.complete(result);
    return;
  }
  env._promise.complete(null as StaticList<String>);
  return;
}
class ClosureEnv_compose_3<C, B, A> extends TypeFunction1<C, A> {
  late TypeFunction1<C, B> g;
  late TypeFunction1<B, A> f;
  ClosureEnv_compose_3();
  @override
  C call(A input) => fnPtr(this, input);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (g is AnyGC) (g as AnyGC).gcMark(flag);
    if (f is AnyGC) (f as AnyGC).gcMark(flag);
  }
}
ClosureEnv_compose_3<C, B, A> ClosureEnv_compose_3_new<C, B, A>(ClosureEnv_compose_3<C, B, A> env_, TypeFunction1<C, B> g, TypeFunction1<B, A> f) {
  env_.fnPtr = ClosureEnv_compose_3_call<C, B, A>;
  env_.g = g;
  env_.f = f;
  return env_;
}
C ClosureEnv_compose_3_call<C, B, A>(AnyGC env__, A input) {
  final env = env__ as ClosureEnv_compose_3<C, B, A>;

  return env.g.call(env.f.call(input));
}

class ClosureEnv_and_4<T> extends TypeFunction1<bool, T> {
  late TypeFunction1<bool, T> p1;
  late TypeFunction1<bool, T> p2;
  ClosureEnv_and_4();
  @override
  bool call(T value) => fnPtr(this, value);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (p1 is AnyGC) (p1 as AnyGC).gcMark(flag);
    if (p2 is AnyGC) (p2 as AnyGC).gcMark(flag);
  }
}
ClosureEnv_and_4<T> ClosureEnv_and_4_new<T>(ClosureEnv_and_4<T> env_, TypeFunction1<bool, T> p1, TypeFunction1<bool, T> p2) {
  env_.fnPtr = ClosureEnv_and_4_call<T>;
  env_.p1 = p1;
  env_.p2 = p2;
  return env_;
}
bool ClosureEnv_and_4_call<T>(AnyGC env__, T value) {
  final env = env__ as ClosureEnv_and_4<T>;

  return (env.p1.call(value) && env.p2.call(value));
}

class ClosureEnv_main_5 extends TypeFunction1<String, int> {
  ClosureEnv_main_5();
  @override
  String call(int d) => fnPtr(this, d);
}
ClosureEnv_main_5 ClosureEnv_main_5_new(ClosureEnv_main_5 env_) {
  env_.fnPtr = ClosureEnv_main_5_call;
  return env_;
}
String ClosureEnv_main_5_call(AnyGC env__, int d) {
  final env = env__ as ClosureEnv_main_5;

  return 'got ${d}';
}

class ClosureEnv_main_6 extends TypeFunction1<String, String> {
  ClosureEnv_main_6();
  @override
  String call(String e) => fnPtr(this, e);
}
ClosureEnv_main_6 ClosureEnv_main_6_new(ClosureEnv_main_6 env_) {
  env_.fnPtr = ClosureEnv_main_6_call;
  return env_;
}
String ClosureEnv_main_6_call(AnyGC env__, String e) {
  final env = env__ as ClosureEnv_main_6;

  return 'error: ${e}';
}

class ClosureEnv_main_7 extends TypeFunction1<String, int> {
  ClosureEnv_main_7();
  @override
  String call(int d) => fnPtr(this, d);
}
ClosureEnv_main_7 ClosureEnv_main_7_new(ClosureEnv_main_7 env_) {
  env_.fnPtr = ClosureEnv_main_7_call;
  return env_;
}
String ClosureEnv_main_7_call(AnyGC env__, int d) {
  final env = env__ as ClosureEnv_main_7;

  return 'got ${d}';
}

class ClosureEnv_main_8 extends TypeFunction1<String, String> {
  ClosureEnv_main_8();
  @override
  String call(String e) => fnPtr(this, e);
}
ClosureEnv_main_8 ClosureEnv_main_8_new(ClosureEnv_main_8 env_) {
  env_.fnPtr = ClosureEnv_main_8_call;
  return env_;
}
String ClosureEnv_main_8_call(AnyGC env__, String e) {
  final env = env__ as ClosureEnv_main_8;

  return 'error: ${e}';
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

class ClosureEnv_main_10 extends TypeFunction1<String, int> {
  ClosureEnv_main_10();
  @override
  String call(int x) => fnPtr(this, x);
}
ClosureEnv_main_10 ClosureEnv_main_10_new(ClosureEnv_main_10 env_) {
  env_.fnPtr = ClosureEnv_main_10_call;
  return env_;
}
String ClosureEnv_main_10_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_main_10;

  return 'result=${x}';
}

class ClosureEnv_main_11 extends TypeFunction1<bool, int> {
  ClosureEnv_main_11();
  @override
  bool call(int n) => fnPtr(this, n);
}
ClosureEnv_main_11 ClosureEnv_main_11_new(ClosureEnv_main_11 env_) {
  env_.fnPtr = ClosureEnv_main_11_call;
  return env_;
}
bool ClosureEnv_main_11_call(AnyGC env__, int n) {
  final env = env__ as ClosureEnv_main_11;

  return (n > 0);
}

class ClosureEnv_main_12 extends TypeFunction1<bool, int> {
  ClosureEnv_main_12();
  @override
  bool call(int n) => fnPtr(this, n);
}
ClosureEnv_main_12 ClosureEnv_main_12_new(ClosureEnv_main_12 env_) {
  env_.fnPtr = ClosureEnv_main_12_call;
  return env_;
}
bool ClosureEnv_main_12_call(AnyGC env__, int n) {
  final env = env__ as ClosureEnv_main_12;

  return ((n % 2) == 0);
}

class ClosureEnv_main_13 extends TypeFunction1<StaticList<int>, int> {
  ClosureEnv_main_13();
  @override
  StaticList<int> call(int x) => fnPtr(this, x);
}
ClosureEnv_main_13 ClosureEnv_main_13_new(ClosureEnv_main_13 env_) {
  env_.fnPtr = ClosureEnv_main_13_call;
  return env_;
}
StaticList<int> ClosureEnv_main_13_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_main_13;

  return StaticList<int>.of([x, (x * x)]);
}

class ClosureEnv_main_14 extends TypeFunction1<bool, String> {
  ClosureEnv_main_14();
  @override
  bool call(String s) => fnPtr(this, s);
}
ClosureEnv_main_14 ClosureEnv_main_14_new(ClosureEnv_main_14 env_) {
  env_.fnPtr = ClosureEnv_main_14_call;
  return env_;
}
bool ClosureEnv_main_14_call(AnyGC env__, String s) {
  final env = env__ as ClosureEnv_main_14;

  return s.startsWith('b');
}

class ClosureEnv_main_15 extends TypeFunction1<bool, String> {
  ClosureEnv_main_15();
  @override
  bool call(String s) => fnPtr(this, s);
}
ClosureEnv_main_15 ClosureEnv_main_15_new(ClosureEnv_main_15 env_) {
  env_.fnPtr = ClosureEnv_main_15_call;
  return env_;
}
bool ClosureEnv_main_15_call(AnyGC env__, String s) {
  final env = env__ as ClosureEnv_main_15;

  return s.startsWith('z');
}


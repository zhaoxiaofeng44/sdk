import 'package:dart2cpp/restorer/runtime_classes.dart';

typedef Predicate<T extends dynamic> = TypeFunction1<bool, T>;

typedef Transformer<A extends dynamic, B extends dynamic> = TypeFunction1<B, A>;

typedef VoidCallback = TypeFunction0<void>;

void Printable_printInfo(dynamic this__) {
  final this_ = this__ as dynamic;
  staticPrint('[${(this_.vptr['get_displayName'] as Function)(this_)}]');
  return;
}

bool Orderable_isLessThan<T extends dynamic>(dynamic this__, T other) {
  final this_ = this__ as dynamic;
  return ((this_.vptr['compareTo'] as Function)(this_, other) < 0);
}

bool Orderable_isGreaterThan<T extends dynamic>(dynamic this__, T other) {
  final this_ = this__ as dynamic;
  return ((this_.vptr['compareTo'] as Function)(this_, other) > 0);
}

void Loggable_log(dynamic this__, String message) {
  final this_ = this__ as dynamic;
  staticPrint('[${(this_.vptr['get_logTag'] as Function)(this_)}] ${message}');
  return;
}

bool Validatable_validate(dynamic this__) {
  final this_ = this__ as dynamic;
  return (this_.vptr['serialize'] as Function)(this_).isNotEmpty;
}

int Timestamped_get_timestamp(dynamic this__) {
  final this_ = this__ as dynamic;
  return 1234567890;
}

String Timestamped_get_timeStr(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'T:${(this_.vptr['get_timestamp'] as Function)(this_)}';
}

void Tagged_addTag(dynamic this__, String tag) {
  final this_ = this__ as dynamic;
  this_._tags.add(tag);
  return;
}

StaticList<String> Tagged_get_tags(dynamic this__) {
  final this_ = this__ as dynamic;
  return StaticList<String>.unmodifiable(this_._tags);
}

class AnimalValue extends VPtr {
  late String name;
  late int age;

  AnimalValue() {
    vptr['speak'] = Animal_speak;
    vptr['toString'] = Animal_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

AnimalValue Animal_new(dynamic this__, String name, int age) {
  final this_ = this__ as AnimalValue;
  this_.name = name;
  this_.age = age;
  return this_;
}

String Animal_speak(dynamic this__) {
  throw UnimplementedError('Animal_speak is abstract');
}

String Animal_toString(dynamic this__) {
  final this_ = this__ as AnimalValue;
  return '${this_.name}(age=${this_.age})';
}

class DogValue extends Dog_Animal_Printable_OrderableValue {
  late String breed;

  DogValue() {
    vptr['speak'] = Dog_speak;
    vptr['get_displayName'] = Dog_get_displayName;
    vptr['printInfo'] = Dog_Animal_Printable_printInfo;
    vptr['compareTo'] = Dog_compareTo;
    vptr['isLessThan'] = Dog_Animal_Printable_Orderable_isLessThan;
    vptr['isGreaterThan'] = Dog_Animal_Printable_Orderable_isGreaterThan;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

DogValue Dog_new(dynamic this__, String name, int age, String breed) {
  final this_ = this__ as DogValue;
  Dog_Animal_Printable_Orderable_new(this_, name, age);
  this_.breed = breed;
  return this_;
}

String Dog_get_displayName(dynamic this__) {
  final this_ = this__ as DogValue;
  return 'Dog:${this_.name}';
}

String Dog_speak(dynamic this__) {
  final this_ = this__ as DogValue;
  return 'Woof!';
}

int Dog_compareTo(dynamic this__, DogValue other) {
  final this_ = this__ as DogValue;
  return this_.age.compareTo(other.age);
}

String Dog_toString(dynamic this__) => Animal_toString(this__);

void Dog_printInfo(dynamic this__) { Dog_Animal_Printable_printInfo(this__); }

bool Dog_isLessThan(dynamic this__, DogValue other) => Dog_Animal_Printable_Orderable_isLessThan(this__, other);

bool Dog_isGreaterThan(dynamic this__, DogValue other) => Dog_Animal_Printable_Orderable_isGreaterThan(this__, other);

class CatValue extends Cat_Animal_PrintableValue {
  late String _mood;

  CatValue() {
    vptr['speak'] = Cat_speak;
    vptr['get_displayName'] = Cat_get_displayName;
    vptr['printInfo'] = Cat_Animal_Printable_printInfo;
    vptr['get_mood'] = Cat_get_mood;
    vptr['set_mood'] = Cat_set_mood;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

CatValue Cat_new(dynamic this__, String name, int age) {
  final this_ = this__ as CatValue;
  Cat_Animal_Printable_new(this_, name, age);
  this_._mood = 'happy';
  return this_;
}

String Cat_get_displayName(dynamic this__) {
  final this_ = this__ as CatValue;
  return 'Cat:${this_.name}';
}

String Cat_speak(dynamic this__) {
  final this_ = this__ as CatValue;
  return 'Meow!';
}

String Cat_get_mood(dynamic this__) {
  final this_ = this__ as CatValue;
  return this_._mood;
}

void Cat_set_mood(dynamic this__, String value) {
  final this_ = this__ as CatValue;
  this_._mood = value;
  return;
}

String Cat_toString(dynamic this__) => Animal_toString(this__);

void Cat_printInfo(dynamic this__) { Cat_Animal_Printable_printInfo(this__); }

class Vector2DValue extends VPtr {
  late double x;
  late double y;

  Vector2DValue() {
    vptr['operatorPlus'] = Vector2D_operatorPlus;
    vptr['operatorMinus'] = Vector2D_operatorMinus;
    vptr['operatorStar'] = Vector2D_operatorStar;
    vptr['operatorEq'] = Vector2D_operatorEq;
    vptr['get_length'] = Vector2D_get_length;
    vptr['toString'] = Vector2D_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

Vector2DValue Vector2D_new(dynamic this__, double x, double y) {
  final this_ = this__ as Vector2DValue;
  this_.x = x;
  this_.y = y;
  return this_;
}

Vector2DValue Vector2D_operatorPlus(dynamic this__, Vector2DValue other) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(Vector2DValue(), (this_.x + other.x), (this_.y + other.y));
}

Vector2DValue Vector2D_operatorMinus(dynamic this__, Vector2DValue other) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(Vector2DValue(), (this_.x - other.x), (this_.y - other.y));
}

Vector2DValue Vector2D_operatorStar(dynamic this__, double scalar) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(Vector2DValue(), (this_.x * scalar), (this_.y * scalar));
}

bool Vector2D_operatorEq(dynamic this__, dynamic other) {
  final this_ = this__ as Vector2DValue;
  return other is Vector2DValue && (this_.x == other.x) && (this_.y == other.y);
}

double Vector2D_get_length(dynamic this__) {
  final this_ = this__ as Vector2DValue;
  return ((((this_.x * this_.x) + (this_.y * this_.y)) < 0) ? 0.0 : Vector2D__sqrt(((this_.x * this_.x) + (this_.y * this_.y))));
}

double Vector2D__sqrt(double v) {
  if ((v <= 0)) {
    return 0.0;
  }
  double guess = (v / 2);
  for (int i = 0; (i < 20); i = (i + 1)) {
    guess = ((guess + (v / guess)) / 2);
  }
  return guess;
}

String Vector2D_toString(dynamic this__) {
  final this_ = this__ as Vector2DValue;
  return 'Vector2D(${this_.x}, ${this_.y})';
}

class CounterValue extends VPtr {
  late int _value;
  late String label;

  CounterValue() {
    vptr['increment'] = Counter_increment;
    vptr['decrement'] = Counter_decrement;
    vptr['get_value'] = Counter_get_value;
    vptr['toString'] = Counter_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

int Counter__instanceCount = 0;

int Counter_maxValue = 100;

CounterValue Counter_new__(dynamic this__, String label, int _value) {
  final this_ = this__ as CounterValue;
  this_.label = label;
  this_._value = _value;
  Counter__instanceCount = (Counter__instanceCount + 1);
  return this_;
}

CounterValue Counter_new(String label, {int initialValue = 0}) {
  return Counter_new__(CounterValue(), label, initialValue);
}

CounterValue Counter_new_fromString(String spec) {
  StaticList<String> parts = StaticList<String>.of(spec.split(':'));
  return Counter_new__(CounterValue(), parts[0], int.parse(parts[1]));
}

int Counter_get_instanceCount() {
  return Counter__instanceCount;
}

void Counter_increment(dynamic this__, [int step = 1]) {
  final this_ = this__ as CounterValue;
  this_._value = (this_._value + step).clamp(0, 100);
}

void Counter_decrement(dynamic this__, [int step = 1]) {
  final this_ = this__ as CounterValue;
  this_._value = (this_._value - step).clamp(0, 100);
}

int Counter_get_value(dynamic this__) {
  final this_ = this__ as CounterValue;
  return this_._value;
}

String Counter_toString(dynamic this__) {
  final this_ = this__ as CounterValue;
  return '${this_.label}: ${this_._value}';
}

class ResultValue<T extends dynamic> extends VPtr {
  late T? data;
  late String? error;
  late bool isSuccess;

  ResultValue() {
    vptr['fold'] = Result_fold<T, dynamic>;
    vptr['fold_String'] = Result_fold<T, String>;
    vptr['toString'] = Result_toString<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

ResultValue<T> Result_new_success<T extends dynamic>(dynamic this__, T value) {
  final this_ = this__ as ResultValue<T>;
  this_.data = value;
  this_.error = null;
  this_.isSuccess = true;
  return this_;
}

ResultValue<T> Result_new_failure<T extends dynamic>(dynamic this__, String message) {
  final this_ = this__ as ResultValue<T>;
  this_.data = null;
  this_.error = message;
  this_.isSuccess = false;
  return this_;
}

R Result_fold<T extends dynamic, R extends dynamic>(dynamic this__, {required TypeFunction1<R, T> onSuccess, required TypeFunction1<R, String> onFailure}) {
  final this_ = this__ as ResultValue<T>;
  if (this_.isSuccess && !(this_.data == null)) {
    return onSuccess((this_.data as T));
  }
  return onFailure((() { final _unnamed = this_.error; return ((_unnamed == null) ? 'Unknown error' : _unnamed); })());
}

String Result_toString<T extends dynamic>(dynamic this__) {
  final this_ = this__ as ResultValue<T>;
  return (this_.isSuccess ? 'Result.success(${this_.data})' : 'Result.failure(${this_.error})');
}

class LazyLoaderValue extends VPtr {
  late String _data;
  late int _computedValue;
  late bool _initialized = false;

  LazyLoaderValue() {
    vptr['initialize'] = LazyLoader_initialize;
    vptr['get_data'] = LazyLoader_get_data;
    vptr['get_computedValue'] = LazyLoader_get_computedValue;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

LazyLoaderValue LazyLoader_new(dynamic this__) {
  final this_ = this__ as LazyLoaderValue;
  return this_;
}

void LazyLoader_initialize(dynamic this__, String data) {
  final this_ = this__ as LazyLoaderValue;
  this_._data = data;
  this_._computedValue = (data.length * 2);
  this_._initialized = true;
}

String LazyLoader_get_data(dynamic this__) {
  final this_ = this__ as LazyLoaderValue;
  return (this_._initialized ? this_._data : 'not initialized');
}

int LazyLoader_get_computedValue(dynamic this__) {
  final this_ = this__ as LazyLoaderValue;
  return (this_._initialized ? this_._computedValue : -1);
}

class BoundedValueValue extends VPtr {
  late double min;
  late double max;
  late double _current;

  BoundedValueValue() {
    vptr['set'] = BoundedValue_set;
    vptr['get_current'] = BoundedValue_get_current;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

BoundedValueValue BoundedValue_new(dynamic this__, double min, double max, double initial) {
  final this_ = this__ as BoundedValueValue;
  this_.min = min;
  this_.max = max;
  this_._current = initial;
  assert((this_.min <= this_.max), 'min must be <= max');
  assert((initial >= this_.min) && (initial <= this_.max), 'initial must be in [min, max]');
  return this_;
}

void BoundedValue_set(dynamic this__, double value) {
  final this_ = this__ as BoundedValueValue;
  assert((value >= this_.min) && (value <= this_.max), 'value ${value} out of bounds [${this_.min}, ${this_.max}]');
  this_._current = value;
}

double BoundedValue_get_current(dynamic this__) {
  final this_ = this__ as BoundedValueValue;
  return this_._current;
}

class ShapeValue extends VPtr {
  late String color;
  late double opacity;

  ShapeValue() {
    vptr['describe'] = Shape_describe;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

ShapeValue Shape_new(dynamic this__, String color, {double opacity = 1.0}) {
  final this_ = this__ as ShapeValue;
  this_.color = color;
  this_.opacity = opacity;
  return this_;
}

ShapeValue Shape_new_transparent(dynamic this__, String color) {
  final this_ = this__ as ShapeValue;
  return Shape_new(this_, color, opacity: 0.5);
}

String Shape_describe(dynamic this__) {
  final this_ = this__ as ShapeValue;
  return 'Shape(color=${this_.color}, opacity=${this_.opacity})';
}

class PolygonValue extends ShapeValue {
  late int sides;

  PolygonValue() {
    vptr['describe'] = Polygon_describe;
    vptr['perimeter'] = Polygon_perimeter;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

PolygonValue Polygon_new(dynamic this__, String color, int sides, {double opacity = 1.0}) {
  final this_ = this__ as PolygonValue;
  Shape_new(this_, color, opacity: opacity);
  this_.sides = sides;
  return this_;
}

String Polygon_describe(dynamic this__) {
  final this_ = this__ as PolygonValue;
  return 'Polygon(sides=${this_.sides}, ${Shape_describe(this_)})';
}

double Polygon_perimeter(dynamic this__, double sideLength) {
  final this_ = this__ as PolygonValue;
  return (this_.sides * sideLength);
}

class RegularPolygonValue extends PolygonValue {
  late double sideLength;

  RegularPolygonValue() {
    vptr['describe'] = RegularPolygon_describe;
    vptr['perimeter'] = RegularPolygon_perimeter;
    vptr['area'] = RegularPolygon_area;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

RegularPolygonValue RegularPolygon_new(dynamic this__, String color, int sides, double sideLength, {double opacity = 1.0}) {
  final this_ = this__ as RegularPolygonValue;
  Polygon_new(this_, color, sides, opacity: opacity);
  this_.sideLength = sideLength;
  return this_;
}

String RegularPolygon_describe(dynamic this__) {
  final this_ = this__ as RegularPolygonValue;
  return 'RegularPolygon(sideLen=${this_.sideLength}, ${Polygon_describe(this_)})';
}

double RegularPolygon_perimeter(dynamic this__, [double? overrideSideLength = null]) {
  final this_ = this__ as RegularPolygonValue;
  return (this_.sides * (() { final _unnamed = overrideSideLength; return ((_unnamed == null) ? this_.sideLength : _unnamed); })());
}

double RegularPolygon_area(dynamic this__) {
  final this_ = this__ as RegularPolygonValue;
  return (((this_.sides * this_.sideLength) * this_.sideLength) / 4.0);
}

class SquareValue extends RegularPolygonValue {

  SquareValue() {
    vptr['describe'] = Square_describe;
  }
}

SquareValue Square_new(dynamic this__, String color, double size, {double opacity = 1.0}) {
  final this_ = this__ as SquareValue;
  RegularPolygon_new(this_, color, 4, size, opacity: opacity);
  return this_;
}

String Square_describe(dynamic this__) {
  final this_ = this__ as SquareValue;
  return 'Square(size=${this_.sideLength}, color=${this_.color})';
}

double Square_perimeter(dynamic this__, [double? overrideSideLength]) => RegularPolygon_perimeter(this__, overrideSideLength);

double Square_area(dynamic this__) => RegularPolygon_area(this__);

class SerializableValue extends VPtr {

  SerializableValue() {
    vptr['serialize'] = Serializable_serialize;
  }
}

SerializableValue Serializable_new(dynamic this__) {
  final this_ = this__ as SerializableValue;
  return this_;
}

String Serializable_serialize(dynamic this__) {
  throw UnimplementedError('Serializable_serialize is abstract');
}

class CloneableValue<T extends dynamic> extends VPtr {

  CloneableValue() {
    vptr['clone'] = Cloneable_clone<T>;
  }
}

CloneableValue<T> Cloneable_new<T extends dynamic>(dynamic this__) {
  final this_ = this__ as CloneableValue<T>;
  return this_;
}

T Cloneable_clone<T extends dynamic>(dynamic this__) {
  throw UnimplementedError('Cloneable_clone is abstract');
}

class Comparable2Value<T extends dynamic> extends VPtr {

  Comparable2Value() {
    vptr['compareTo2'] = Comparable2_compareTo2<T>;
  }
}

Comparable2Value<T> Comparable2_new<T extends dynamic>(dynamic this__) {
  final this_ = this__ as Comparable2Value<T>;
  return this_;
}

int Comparable2_compareTo2<T extends dynamic>(dynamic this__) {
  throw UnimplementedError('Comparable2_compareTo2 is abstract');
}

class DataPointValue extends VPtr implements SerializableValue, CloneableValue, Comparable2Value {
  late double x;
  late double y;
  late String label;

  DataPointValue() {
    vptr['serialize'] = DataPoint_serialize;
    vptr['clone'] = DataPoint_clone;
    vptr['compareTo2'] = DataPoint_compareTo2;
    vptr['toString'] = DataPoint_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

DataPointValue DataPoint_new(dynamic this__, double x, double y, String label) {
  final this_ = this__ as DataPointValue;
  this_.x = x;
  this_.y = y;
  this_.label = label;
  return this_;
}

String DataPoint_serialize(dynamic this__) {
  final this_ = this__ as DataPointValue;
  return '{"x":${this_.x},"y":${this_.y},"label":"${this_.label}"}';
}

DataPointValue DataPoint_clone(dynamic this__) {
  final this_ = this__ as DataPointValue;
  return DataPoint_new(DataPointValue(), this_.x, this_.y, this_.label);
}

int DataPoint_compareTo2(dynamic this__, DataPointValue other) {
  final this_ = this__ as DataPointValue;
  double dx = (this_.x - other.x);
  if (!(dx == 0)) {
    return ((dx > 0) ? 1 : -1);
  }
  double dy = (this_.y - other.y);
  if (!(dy == 0)) {
    return ((dy > 0) ? 1 : -1);
  }
  return 0;
}

String DataPoint_toString(dynamic this__) {
  final this_ = this__ as DataPointValue;
  return 'DataPoint(${this_.x}, ${this_.y}, "${this_.label}")';
}

class LoggedDataPointValue extends LoggedDataPoint_DataPoint_Loggable_ValidatableValue {

  LoggedDataPointValue() {
    vptr['get_logTag'] = LoggedDataPoint_get_logTag;
    vptr['log'] = LoggedDataPoint_DataPoint_Loggable_log;
    vptr['validate'] = LoggedDataPoint_DataPoint_Loggable_Validatable_validate;
  }
}

LoggedDataPointValue LoggedDataPoint_new(dynamic this__, double x, double y, String label) {
  final this_ = this__ as LoggedDataPointValue;
  LoggedDataPoint_DataPoint_Loggable_Validatable_new(this_, x, y, label);
  return this_;
}

String LoggedDataPoint_get_logTag(dynamic this__) {
  final this_ = this__ as LoggedDataPointValue;
  return 'DataPoint';
}

String LoggedDataPoint_serialize(dynamic this__) => DataPoint_serialize(this__);

DataPointValue LoggedDataPoint_clone(dynamic this__) => DataPoint_clone(this__);

int LoggedDataPoint_compareTo2(dynamic this__, DataPointValue other) => DataPoint_compareTo2(this__, other);

String LoggedDataPoint_toString(dynamic this__) => DataPoint_toString(this__);

void LoggedDataPoint_log(dynamic this__, String message) { LoggedDataPoint_DataPoint_Loggable_log(this__, message); }

bool LoggedDataPoint_validate(dynamic this__) => LoggedDataPoint_DataPoint_Loggable_Validatable_validate(this__);

enum Priority {
  low(1, 'Low'),
  medium(5, 'Medium'),
  high(10, 'High'),
  critical(100, 'Critical');

  final int level;
  final String displayName;

  const Priority(this.level, this.displayName);
}

int Priority_get_level(dynamic this__) {
  final this_ = this__ as Priority;
  switch (this_) {
    case Priority.low:
      return 1;
    case Priority.medium:
      return 5;
    case Priority.high:
      return 10;
    case Priority.critical:
      return 100;
  }
  throw StateError('Unknown Priority value');
}

String Priority_get_displayName(dynamic this__) {
  final this_ = this__ as Priority;
  switch (this_) {
    case Priority.low:
      return 'Low';
    case Priority.medium:
      return 'Medium';
    case Priority.high:
      return 'High';
    case Priority.critical:
      return 'Critical';
  }
  throw StateError('Unknown Priority value');
}

bool Priority_isHigherThan(dynamic this__, Priority other) {
  final this_ = this__ as Priority;
  return (Priority_get_level(this_) > Priority_get_level(other));
}

String Priority_toString(dynamic this__) {
  final this_ = this__ as Priority;
  return '${Priority_get_displayName(this_)}(level=${Priority_get_level(this_)})';
}

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE');

  final String value;

  const HttpMethod(this.value);
}

String HttpMethod_get_value(dynamic this__) {
  final this_ = this__ as HttpMethod;
  switch (this_) {
    case HttpMethod.get:
      return 'GET';
    case HttpMethod.post:
      return 'POST';
    case HttpMethod.put:
      return 'PUT';
    case HttpMethod.delete:
      return 'DELETE';
  }
  throw StateError('Unknown HttpMethod value');
}

bool HttpMethod_get_isReadOnly(dynamic this__) {
  final this_ = this__ as HttpMethod;
  return (this_ == HttpMethod.get);
}

class ConfigValue extends VPtr {
  late String host;
  late int port;
  late bool secure;
  late String baseUrl;

  ConfigValue() {
    vptr['toString'] = Config_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

ConfigValue Config_new(dynamic this__, String host, int port, {bool secure = false}) {
  final this_ = this__ as ConfigValue;
  this_.host = host;
  this_.port = port;
  this_.secure = secure;
  this_.baseUrl = '${(secure ? 'https' : 'http')}://${host}:${port}';
  return this_;
}

ConfigValue Config_new_localhost(dynamic this__, {int port = 8080}) {
  final this_ = this__ as ConfigValue;
  return Config_new(this_, 'localhost', port);
}

ConfigValue Config_new_production(dynamic this__, String host) {
  final this_ = this__ as ConfigValue;
  return Config_new(this_, host, 443, secure: true);
}

String Config_toString(dynamic this__) {
  final this_ = this__ as ConfigValue;
  return 'Config(${this_.baseUrl})';
}

class SortedListValue<T extends Comparable<dynamic>> extends VPtr {
  late StaticList<T> _items = StaticList<T>.of([]);

  SortedListValue() {
    vptr['add'] = SortedList_add<T>;
    vptr['get_first'] = SortedList_get_first<T>;
    vptr['get_last'] = SortedList_get_last<T>;
    vptr['get_length'] = SortedList_get_length;
    vptr['toList'] = SortedList_toList<T>;
    vptr['toString'] = SortedList_toString<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _items?.gcMark(flag);
  }
}

SortedListValue<T> SortedList_new<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  return this_;
}

void SortedList_add<T extends Comparable<dynamic>>(dynamic this__, T item) {
  final this_ = this__ as SortedListValue<T>;
  this_._items.add(item);
  this_._items.sort();
}

T SortedList_get_first<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  return this_._items.first;
}

T SortedList_get_last<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  return this_._items.last;
}

int SortedList_get_length<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  return this_._items.length;
}

StaticList<T> SortedList_toList<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  return StaticList<T>.unmodifiable(this_._items);
}

String SortedList_toString<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  return 'SortedList(${this_._items})';
}

class NullSafetyDemoValue extends VPtr {
  late String? nullableField;
  late String nonNullField;

  NullSafetyDemoValue() {
    vptr['demonstrate'] = NullSafetyDemo_demonstrate;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

NullSafetyDemoValue NullSafetyDemo_new(dynamic this__, String nonNullField, [String? nullableField = null]) {
  final this_ = this__ as NullSafetyDemoValue;
  this_.nonNullField = nonNullField;
  this_.nullableField = nullableField;
  return this_;
}

String NullSafetyDemo_demonstrate(dynamic this__) {
  final this_ = this__ as NullSafetyDemoValue;
  int? len = (() { final _unnamed = this_.nullableField; return ((_unnamed == null) ? null : _unnamed.length); })();
  int safeLen = (() { final _unnamed = len; return ((_unnamed == null) ? -1 : _unnamed); })();
  ((this_.nullableField == null) ? this_.nullableField = 'default' : null);
  String forced = this_.nullableField!.toUpperCase();
  return 'len=${safeLen}, forced=${forced}';
}

class RendererValue extends VPtr {

  RendererValue() {
    vptr['render'] = Renderer_render;
    vptr['get_name'] = Renderer_get_name;
  }
}

RendererValue Renderer_new(dynamic this__) {
  final this_ = this__ as RendererValue;
  return this_;
}

void Renderer_render(dynamic this__) {
  throw UnimplementedError('Renderer_render is abstract');
}

String Renderer_get_name(dynamic this__) {
  throw UnimplementedError('Renderer_get_name is abstract');
}

class CircleRendererValue extends RendererValue {

  CircleRendererValue() {
    vptr['render'] = CircleRenderer_render;
    vptr['get_name'] = CircleRenderer_get_name;
  }
}

CircleRendererValue CircleRenderer_new(dynamic this__) {
  final this_ = this__ as CircleRendererValue;
  Renderer_new(this_);
  return this_;
}

void CircleRenderer_render(dynamic this__, String shape) {
  final this_ = this__ as CircleRendererValue;
  staticPrint('  CircleRenderer: drawing ${shape}');
}

String CircleRenderer_get_name(dynamic this__) {
  final this_ = this__ as CircleRendererValue;
  return 'CircleRenderer';
}

class PipelineValue<TInput extends dynamic, TOutput extends dynamic> extends VPtr {
  late TypeFunction1<TOutput, TInput> _transform;

  PipelineValue() {
    vptr['execute'] = Pipeline_execute<TInput, TOutput>;
    vptr['then'] = Pipeline_then<TInput, TOutput, dynamic>;
    vptr['then_String'] = Pipeline_then<TInput, TOutput, String>;
    vptr['then_int'] = Pipeline_then<TInput, TOutput, int>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _transform?.gcMark(flag);
  }
}

PipelineValue<TInput, TOutput> Pipeline_new<TInput extends dynamic, TOutput extends dynamic>(dynamic this__, TypeFunction1<TOutput, TInput> _transform) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  this_._transform = _transform;
  return this_;
}

TOutput Pipeline_execute<TInput extends dynamic, TOutput extends dynamic>(dynamic this__, TInput input) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return (() { final _unnamed = input; return this_._transform(_unnamed); })();
}

PipelineValue<TInput, TNewOutput> Pipeline_then<TInput extends dynamic, TOutput extends dynamic, TNewOutput extends dynamic>(dynamic this__, TypeFunction1<TNewOutput, TOutput> next) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return Pipeline_new<TInput, TNewOutput>(PipelineValue<TInput, TNewOutput>(), ClosureEnv_global_0_new<TNewOutput, TOutput, TInput>(GC.allocateLocal(ClosureEnv_global_0<TNewOutput, TOutput, TInput>()), this_, next));
}

class BitFlagsValue extends VPtr {
  late int _flags;

  BitFlagsValue() {
    vptr['set'] = BitFlags_set;
    vptr['clear'] = BitFlags_clear;
    vptr['has'] = BitFlags_has;
    vptr['toString'] = BitFlags_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

int BitFlags_read = 1;

int BitFlags_write = 2;

int BitFlags_execute = 4;

BitFlagsValue BitFlags_new(dynamic this__, [int _flags = 0]) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = _flags;
  return this_;
}

void BitFlags_set(dynamic this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = (this_._flags | flag);
  return;
}

void BitFlags_clear(dynamic this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = (this_._flags & ~flag);
  return;
}

bool BitFlags_has(dynamic this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  return !((this_._flags & flag) == 0);
}

String BitFlags_toString(dynamic this__) {
  final this_ = this__ as BitFlagsValue;
  StaticList<String> parts = StaticList<String>.of([]);
  if ((this_.vptr['has'] as Function)(this_, 1)) {
    parts.add('r');
  }
  if ((this_.vptr['has'] as Function)(this_, 2)) {
    parts.add('w');
  }
  if ((this_.vptr['has'] as Function)(this_, 4)) {
    parts.add('x');
  }
  return (parts.isEmpty ? '-' : parts.join(''));
}

class EventValue extends Event_Object_Timestamped_TaggedValue {
  late String name;

  EventValue() {
    vptr['get_timestamp'] = Event_Object_Timestamped_get_timestamp;
    vptr['get_timeStr'] = Event_Object_Timestamped_get_timeStr;
    vptr['addTag'] = Event_Object_Timestamped_Tagged_addTag;
    vptr['get_tags'] = Event_Object_Timestamped_Tagged_get_tags;
    vptr['toString'] = Event_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

EventValue Event_new(dynamic this__, String name) {
  final this_ = this__ as EventValue;
  Event_Object_Timestamped_Tagged_new(this_);
  this_.name = name;
  return this_;
}

String Event_toString(dynamic this__) {
  final this_ = this__ as EventValue;
  return 'Event(${this_.name}, ${(this_.vptr['get_timeStr'] as Function)(this_)}, tags=${(this_.vptr['get_tags'] as Function)(this_)})';
}

int Event_get_timestamp(dynamic this__) => Event_Object_Timestamped_get_timestamp(this__);

String Event_get_timeStr(dynamic this__) => Event_Object_Timestamped_get_timeStr(this__);

void Event_addTag(dynamic this__, String tag) { Event_Object_Timestamped_Tagged_addTag(this__, tag); }

StaticList<String> Event_get_tags(dynamic this__) => Event_Object_Timestamped_Tagged_get_tags(this__);

class ImportantEventValue extends ImportantEvent_Event_LoggableValue {
  late Priority priority;

  ImportantEventValue() {
    vptr['toString'] = ImportantEvent_toString;
    vptr['get_logTag'] = ImportantEvent_get_logTag;
    vptr['log'] = ImportantEvent_Event_Loggable_log;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

ImportantEventValue ImportantEvent_new(dynamic this__, String name, Priority priority) {
  final this_ = this__ as ImportantEventValue;
  ImportantEvent_Event_Loggable_new(this_, name);
  this_.priority = priority;
  return this_;
}

String ImportantEvent_get_logTag(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent';
}

String ImportantEvent_toString(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent(${this_.name}, ${Priority_toString(this_.priority)}, ${(this_.vptr['get_timeStr'] as Function)(this_)})';
}

int ImportantEvent_get_timestamp(dynamic this__) => Event_Object_Timestamped_get_timestamp(this__);

String ImportantEvent_get_timeStr(dynamic this__) => Event_Object_Timestamped_get_timeStr(this__);

void ImportantEvent_addTag(dynamic this__, String tag) { Event_Object_Timestamped_Tagged_addTag(this__, tag); }

StaticList<String> ImportantEvent_get_tags(dynamic this__) => Event_Object_Timestamped_Tagged_get_tags(this__);

void ImportantEvent_log(dynamic this__, String message) { ImportantEvent_Event_Loggable_log(this__, message); }

class Dog_Animal_PrintableValue extends AnimalValue {

  Dog_Animal_PrintableValue() {
    vptr['get_displayName'] = Dog_Animal_Printable_get_displayName;
    vptr['printInfo'] = Dog_Animal_Printable_printInfo;
  }
}

Dog_Animal_PrintableValue Dog_Animal_Printable_new(dynamic this__, String name, int age) {
  final this_ = this__ as Dog_Animal_PrintableValue;
  Animal_new(this_, name, age);
  return this_;
}

String Dog_Animal_Printable_get_displayName(dynamic this__) {
  throw UnimplementedError('Dog_Animal_Printable_get_displayName is abstract');
}

void Dog_Animal_Printable_printInfo(dynamic this__) {
  final this_ = this__ as Dog_Animal_PrintableValue;
  Printable_printInfo(this_);
  return;
}

String Dog_Animal_Printable_speak(dynamic this__) => Animal_speak(this__);

String Dog_Animal_Printable_toString(dynamic this__) => Animal_toString(this__);

class Dog_Animal_Printable_OrderableValue extends Dog_Animal_PrintableValue {

  Dog_Animal_Printable_OrderableValue() {
    vptr['compareTo'] = Dog_Animal_Printable_Orderable_compareTo;
    vptr['isLessThan'] = Dog_Animal_Printable_Orderable_isLessThan;
    vptr['isGreaterThan'] = Dog_Animal_Printable_Orderable_isGreaterThan;
  }
}

Dog_Animal_Printable_OrderableValue Dog_Animal_Printable_Orderable_new(dynamic this__, String name, int age) {
  final this_ = this__ as Dog_Animal_Printable_OrderableValue;
  Dog_Animal_Printable_new(this_, name, age);
  return this_;
}

int Dog_Animal_Printable_Orderable_compareTo(dynamic this__) {
  throw UnimplementedError('Dog_Animal_Printable_Orderable_compareTo is abstract');
}

bool Dog_Animal_Printable_Orderable_isLessThan(dynamic this__, DogValue other) {
  final this_ = this__ as Dog_Animal_Printable_OrderableValue;
  return Orderable_isLessThan(this_, other);
}

bool Dog_Animal_Printable_Orderable_isGreaterThan(dynamic this__, DogValue other) {
  final this_ = this__ as Dog_Animal_Printable_OrderableValue;
  return Orderable_isGreaterThan(this_, other);
}

String Dog_Animal_Printable_Orderable_speak(dynamic this__) => Animal_speak(this__);

String Dog_Animal_Printable_Orderable_toString(dynamic this__) => Animal_toString(this__);

String Dog_Animal_Printable_Orderable_get_displayName(dynamic this__) => Dog_Animal_Printable_get_displayName(this__);

void Dog_Animal_Printable_Orderable_printInfo(dynamic this__) { Dog_Animal_Printable_printInfo(this__); }

class Cat_Animal_PrintableValue extends AnimalValue {

  Cat_Animal_PrintableValue() {
    vptr['get_displayName'] = Cat_Animal_Printable_get_displayName;
    vptr['printInfo'] = Cat_Animal_Printable_printInfo;
  }
}

Cat_Animal_PrintableValue Cat_Animal_Printable_new(dynamic this__, String name, int age) {
  final this_ = this__ as Cat_Animal_PrintableValue;
  Animal_new(this_, name, age);
  return this_;
}

String Cat_Animal_Printable_get_displayName(dynamic this__) {
  throw UnimplementedError('Cat_Animal_Printable_get_displayName is abstract');
}

void Cat_Animal_Printable_printInfo(dynamic this__) {
  final this_ = this__ as Cat_Animal_PrintableValue;
  Printable_printInfo(this_);
  return;
}

String Cat_Animal_Printable_speak(dynamic this__) => Animal_speak(this__);

String Cat_Animal_Printable_toString(dynamic this__) => Animal_toString(this__);

class LoggedDataPoint_DataPoint_LoggableValue extends DataPointValue {

  LoggedDataPoint_DataPoint_LoggableValue() {
    vptr['get_logTag'] = LoggedDataPoint_DataPoint_Loggable_get_logTag;
    vptr['log'] = LoggedDataPoint_DataPoint_Loggable_log;
  }
}

LoggedDataPoint_DataPoint_LoggableValue LoggedDataPoint_DataPoint_Loggable_new(dynamic this__, double x, double y, String label) {
  final this_ = this__ as LoggedDataPoint_DataPoint_LoggableValue;
  DataPoint_new(this_, x, y, label);
  return this_;
}

String LoggedDataPoint_DataPoint_Loggable_get_logTag(dynamic this__) {
  throw UnimplementedError('LoggedDataPoint_DataPoint_Loggable_get_logTag is abstract');
}

void LoggedDataPoint_DataPoint_Loggable_log(dynamic this__, String message) {
  final this_ = this__ as LoggedDataPoint_DataPoint_LoggableValue;
  Loggable_log(this_, message);
  return;
}

String LoggedDataPoint_DataPoint_Loggable_serialize(dynamic this__) => DataPoint_serialize(this__);

DataPointValue LoggedDataPoint_DataPoint_Loggable_clone(dynamic this__) => DataPoint_clone(this__);

int LoggedDataPoint_DataPoint_Loggable_compareTo2(dynamic this__, DataPointValue other) => DataPoint_compareTo2(this__, other);

String LoggedDataPoint_DataPoint_Loggable_toString(dynamic this__) => DataPoint_toString(this__);

class LoggedDataPoint_DataPoint_Loggable_ValidatableValue extends LoggedDataPoint_DataPoint_LoggableValue {

  LoggedDataPoint_DataPoint_Loggable_ValidatableValue() {
    vptr['validate'] = LoggedDataPoint_DataPoint_Loggable_Validatable_validate;
  }
}

LoggedDataPoint_DataPoint_Loggable_ValidatableValue LoggedDataPoint_DataPoint_Loggable_Validatable_new(dynamic this__, double x, double y, String label) {
  final this_ = this__ as LoggedDataPoint_DataPoint_Loggable_ValidatableValue;
  LoggedDataPoint_DataPoint_Loggable_new(this_, x, y, label);
  return this_;
}

bool LoggedDataPoint_DataPoint_Loggable_Validatable_validate(dynamic this__) {
  final this_ = this__ as LoggedDataPoint_DataPoint_Loggable_ValidatableValue;
  return Validatable_validate(this_);
}

String LoggedDataPoint_DataPoint_Loggable_Validatable_serialize(dynamic this__) => DataPoint_serialize(this__);

DataPointValue LoggedDataPoint_DataPoint_Loggable_Validatable_clone(dynamic this__) => DataPoint_clone(this__);

int LoggedDataPoint_DataPoint_Loggable_Validatable_compareTo2(dynamic this__, DataPointValue other) => DataPoint_compareTo2(this__, other);

String LoggedDataPoint_DataPoint_Loggable_Validatable_toString(dynamic this__) => DataPoint_toString(this__);

String LoggedDataPoint_DataPoint_Loggable_Validatable_get_logTag(dynamic this__) => LoggedDataPoint_DataPoint_Loggable_get_logTag(this__);

void LoggedDataPoint_DataPoint_Loggable_Validatable_log(dynamic this__, String message) { LoggedDataPoint_DataPoint_Loggable_log(this__, message); }

class Event_Object_TimestampedValue extends VPtr {

  Event_Object_TimestampedValue() {
    vptr['get_timestamp'] = Event_Object_Timestamped_get_timestamp;
    vptr['get_timeStr'] = Event_Object_Timestamped_get_timeStr;
  }
}

Event_Object_TimestampedValue Event_Object_Timestamped_new(dynamic this__) {
  final this_ = this__ as Event_Object_TimestampedValue;
  return this_;
}

int Event_Object_Timestamped_get_timestamp(dynamic this__) {
  final this_ = this__ as Event_Object_TimestampedValue;
  return Timestamped_get_timestamp(this_);
}

String Event_Object_Timestamped_get_timeStr(dynamic this__) {
  final this_ = this__ as Event_Object_TimestampedValue;
  return Timestamped_get_timeStr(this_);
}

class Event_Object_Timestamped_TaggedValue extends Event_Object_TimestampedValue {
  late StaticList<String> _tags = StaticList<String>.of([]);

  Event_Object_Timestamped_TaggedValue() {
    vptr['addTag'] = Event_Object_Timestamped_Tagged_addTag;
    vptr['get_tags'] = Event_Object_Timestamped_Tagged_get_tags;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _tags?.gcMark(flag);
  }
}

Event_Object_Timestamped_TaggedValue Event_Object_Timestamped_Tagged_new(dynamic this__) {
  final this_ = this__ as Event_Object_Timestamped_TaggedValue;
  Event_Object_Timestamped_new(this_);
  return this_;
}

void Event_Object_Timestamped_Tagged_addTag(dynamic this__, String tag) {
  final this_ = this__ as Event_Object_Timestamped_TaggedValue;
  Tagged_addTag(this_, tag);
  return;
}

StaticList<String> Event_Object_Timestamped_Tagged_get_tags(dynamic this__) {
  final this_ = this__ as Event_Object_Timestamped_TaggedValue;
  return Tagged_get_tags(this_);
}

int Event_Object_Timestamped_Tagged_get_timestamp(dynamic this__) => Event_Object_Timestamped_get_timestamp(this__);

String Event_Object_Timestamped_Tagged_get_timeStr(dynamic this__) => Event_Object_Timestamped_get_timeStr(this__);

class ImportantEvent_Event_LoggableValue extends EventValue {

  ImportantEvent_Event_LoggableValue() {
    vptr['get_logTag'] = ImportantEvent_Event_Loggable_get_logTag;
    vptr['log'] = ImportantEvent_Event_Loggable_log;
  }
}

ImportantEvent_Event_LoggableValue ImportantEvent_Event_Loggable_new(dynamic this__, String name) {
  final this_ = this__ as ImportantEvent_Event_LoggableValue;
  Event_new(this_, name);
  return this_;
}

String ImportantEvent_Event_Loggable_get_logTag(dynamic this__) {
  throw UnimplementedError('ImportantEvent_Event_Loggable_get_logTag is abstract');
}

void ImportantEvent_Event_Loggable_log(dynamic this__, String message) {
  final this_ = this__ as ImportantEvent_Event_LoggableValue;
  Loggable_log(this_, message);
  return;
}

int ImportantEvent_Event_Loggable_get_timestamp(dynamic this__) => Event_Object_Timestamped_get_timestamp(this__);

String ImportantEvent_Event_Loggable_get_timeStr(dynamic this__) => Event_Object_Timestamped_get_timeStr(this__);

void ImportantEvent_Event_Loggable_addTag(dynamic this__, String tag) { Event_Object_Timestamped_Tagged_addTag(this__, tag); }

StaticList<String> ImportantEvent_Event_Loggable_get_tags(dynamic this__) => Event_Object_Timestamped_Tagged_get_tags(this__);

String ImportantEvent_Event_Loggable_toString(dynamic this__) => Event_toString(this__);

String formatMessage(String template, [String? subject = null, int? count = null]) {
  String result = template;
  if (!(subject == null)) {
    result = result.replaceAll('{subject}', subject);
  }
  if (!(count == null)) {
    result = result.replaceAll('{count}', count.toString());
  }
  return result;
}

String buildQuery({required String endpoint, StaticMap<String, String>? params = null, int maxWait = 30, bool secure = true}) {
  String scheme = (secure ? 'https' : 'http');
  String query = (() { final _unnamed = (() { final _unnamed = params; return ((_unnamed == null) ? null : StaticList<String>.of(_unnamed.entries.map(ClosureEnv_global_1_new(GC.allocateLocal(ClosureEnv_global_1())))).join('&')); })(); return ((_unnamed == null) ? '' : _unnamed); })();
  String suffix = (query.isEmpty ? '' : '?${query}');
  return '${scheme}://${endpoint}${suffix} (timeout=${maxWait}s)';
}

Iterable<int> range(int start, int end, [int step = 1]) sync* {
  for (int i = start; (i < end); i = (i + step)) {
    yield i;
  }
}

Iterable<int> fibonacci(int count) sync* {
  int a = 0;
  int b = 1;
  for (int i = 0; (i < count); i = (i + 1)) {
    yield a;
    int next = (a + b);
    a = b;
    b = next;
  }
}

Promise<StaticList<String>> countDown(int from) {
  StaticList<String> result = StaticList<String>.of([]);
  for (int i = from; (i >= 0); i = (i - 1)) {
    smAwait(promiseDelayed(StaticDuration(milliseconds: 1), () => null));
    result.add(((i == 0) ? 'Go!' : '${i}...'));
  }
  return Promise.value<StaticList<String>>(result);
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

String describeValue(dynamic value) {
  return (() { late String _unnamed;
dynamic _0_0 = value;
do {
  if ((_0_0 == null)) {
    _unnamed = 'null';
    break;
  }
  late int n;
  if (_0_0 is int && (() { final _unnamed = n = _0_0; return true; })() && (n < 0)) {
    _unnamed = 'negative int: ${n}';
    break;
  }
  if (_0_0 is int) {
    n = _0_0;
    _unnamed = 'positive int: ${n}';
    break;
  }
  late String s;
  if (_0_0 is String && (() { final _unnamed = s = _0_0; return true; })() && s.isEmpty) {
    _unnamed = 'empty string';
    break;
  }
  if (_0_0 is String) {
    s = _0_0;
    _unnamed = 'string: "${s}"';
    break;
  }
  late StaticList<dynamic> list;
  if (_0_0 is StaticList<dynamic> && (() { final _unnamed = list = _0_0; return true; })() && list.isEmpty) {
    _unnamed = 'empty list';
    break;
  }
  if (_0_0 is StaticList<dynamic>) {
    list = _0_0;
    _unnamed = 'list of ${list.length}';
    break;
  }
  if (true) {
    _unnamed = 'unknown: ${value.runtimeType}';
    break;
  }
  throw ReachabilityError('None of the patterns in the switch expression the matched input value. See https://github.com/dart-lang/language/issues/3488 for details.');
} while (false);
return _unnamed; })();
}

StaticList<int> buildList() {
  return (() { final _unnamed = StaticList<int>.of([]); return (() { _unnamed.add(1);
_unnamed.add(2);
_unnamed.addAll(StaticList<int>.of([3, 4, 5]));
_unnamed.sort();
return _unnamed; })(); })();
}

StaticStringBuffer buildBuffer() {
  return (() { final _unnamed = StaticStringBuffer(); return (() { _unnamed.write('Hello');
_unnamed.write(', ');
_unnamed.write('World');
_unnamed.writeln('!');
return _unnamed; })(); })();
}

StaticList<int> mergeAndFilter(StaticList<int> a, StaticList<int> b, bool includeNegative) {
  return (() { StaticList<int> _unnamed = StaticList<int>.of(a);
_unnamed.addAll(b);
if (includeNegative) {
  _unnamed.add(-1);
}
for (int i = 10; (i <= 12); i = (i + 1)) {
  _unnamed.add(i);
}
return _unnamed; })();
}

StaticMap<String, int> buildScoreMap(StaticList<String> names, bool addBonus) {
  return (() { StaticMap<String, int> _unnamed = StaticMap<String, int>.of({});
for (int i = 0; (i < names.length); i = (i + 1)) {
  _unnamed[names[i]] = ((i + 1) * 10);
}
if (addBonus) {
  _unnamed['bonus'] = 999;
}
return _unnamed; })();
}

int parseAndDivide(String a, String b) {
  try {
    int x = int.parse(a);
    int y = int.parse(b);
    if ((y == 0)) {
      throw DartArgumentError('Division by zero');
    }
    return (x ~/ y);
  } on FormatException catch ( _) {
    rethrow;
  } on ArgumentError catch ( e) {
    throw DartStateError('Math error: ${e.message}');
  }
}

String multiLineExample() {
  String raw = 'raw\\nstring\\ttabs';
  String multiLine = 'line1\nline2\nline3';
  String nested = 'lines: ${StaticList<String>.of(multiLine.split('\n')).length}, raw: ${raw}';
  return nested;
}

TypeFunction1<C, A> compose<A extends dynamic, B extends dynamic, C extends dynamic>(TypeFunction1<B, A> f, TypeFunction1<C, B> g) {
  return ClosureEnv_global_2_new<C, B, A>(GC.allocateLocal(ClosureEnv_global_2<C, B, A>()), g, f);
}

TypeFunction1<bool, T> and<T extends dynamic>(TypeFunction1<bool, T> p1, TypeFunction1<bool, T> p2) {
  return ClosureEnv_global_3_new<T>(GC.allocateLocal(ClosureEnv_global_3<T>()), p1, p2);
}

StaticList<B> flatMap<A extends dynamic, B extends dynamic>(StaticList<A> list, TypeFunction1<StaticList<B>, A> f) {
  return StaticList<B>.of(StaticList<B>.of(list.expand(f)).toList());
}

T findMax<T extends Comparable<dynamic>>(StaticList<T> items) {
  T maxItem = items.first;
  for (final item in items) {
    if ((item.compareTo(maxItem) > 0)) {
      maxItem = item;
    }
  }
  return maxItem;
}

R applyTwice<T extends dynamic, R extends dynamic>(T value, TypeFunction1<R, T> fn1, TypeFunction1<R, R> fn2) {
  return fn2(fn1(value));
}

String? findFirst(StaticList<String> items, TypeFunction1<bool, String> test) {
  for (final item in items) {
    if (test(item)) {
      return item;
    }
  }
  return null;
}

StaticList<int> filterWithForIn(StaticList<int> items) {
  StaticList<int> result = StaticList<int>.of([]);
  for (final item in items) {
    if ((item >= 0) && (item <= 100)) {
      result.add(item);
    }
  }
  return result;
}

int collatzSteps(int n) {
  int steps = 0;
  do {
    do {
      if ((n == 1)) {
        break;
      }
      if (((n % 2) == 0)) {
        n = (n ~/ 2);
      } else {
        n = ((3 * n) + 1);
      }
      steps = (steps + 1);
    } while (!(n == 1));
  } while (false);
  return steps;
}

String typeTest(dynamic value) {
  if (value is int) {
    return 'int: ${(value * 2)}';
  } else {
    if (value is String) {
      return 'string: ${value.toUpperCase()}';
    } else {
      if (value is StaticList<int>) {
        return 'list<int>: ${value.length} items';
      } else {
        if (value is bool) {
          return 'bool: ${value}';
        }
      }
    }
  }
  return 'other: ${value.runtimeType}';
}

double safeCast(dynamic value) {
  try {
    return (value as double);
  } on dynamic catch ( e) {
    return 0.0;
  }
}

String tryCatchFinally(int code) {
  StaticStringBuffer log = StaticStringBuffer();
  try {
    log.write('try ');
    if ((code == 1)) {
      throw DartFormatException('bad format');
    }
    if ((code == 2)) {
      throw DartArgumentError('bad arg');
    }
    log.write('ok ');
  } on FormatException catch ( e) {
    log.write('format:${e.message} ');
  } on ArgumentError catch ( e) {
    log.write('arg:${e.message} ');
  } on dynamic catch ( e) {
    log.write('other:${e} ');
  } finally {
    log.write('finally');
  }
  return log.toString();
}

String dayType(int day) {
  do {
    switch (day) {
      case 1 || 7:
        return 'weekend';
      case 2 || 3 || 4 || 5 || 6:
        return 'weekday';
      default:
        return 'invalid';
    }
  } while (false);
}

void main() {
  staticPrint('=== 全面语法节点还原测试 ===\n');
  staticPrint('--- 1. mixin + implements ---');
  DogValue dog1 = Dog_new(DogValue(), 'Rex', 3, 'Labrador');
  DogValue dog2 = Dog_new(DogValue(), 'Max', 5, 'Poodle');
  (dog1.vptr['printInfo'] as Function)(dog1);
  staticPrint('${(dog1.vptr['speak'] as Function)(dog1)} (${dog1.breed})');
  staticPrint('dog1 < dog2: ${(dog1.vptr['isLessThan'] as Function)(dog1, dog2)}');
  staticPrint('dog1 > dog2: ${(dog1.vptr['isGreaterThan'] as Function)(dog1, dog2)}');
  CatValue cat = Cat_new(CatValue(), 'Whiskers', 2);
  (cat.vptr['printInfo'] as Function)(cat);
  staticPrint('${(cat.vptr['speak'] as Function)(cat)}, mood: ${(cat.vptr['get_mood'] as Function)(cat)}');
  (cat.vptr['set_mood'] as Function)(cat, 'sleepy');
  staticPrint('mood after set: ${(cat.vptr['get_mood'] as Function)(cat)}');
  staticPrint('\n--- 2. operator 重载 ---');
  Vector2DValue sum = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorPlus'] as Function)(Vector2D_new(Vector2DValue(), 3.0, 4.0), Vector2D_new(Vector2DValue(), 1.0, 2.0));
  Vector2DValue diff = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorMinus'] as Function)(Vector2D_new(Vector2DValue(), 3.0, 4.0), Vector2D_new(Vector2DValue(), 1.0, 2.0));
  Vector2DValue scaled = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorStar'] as Function)(Vector2D_new(Vector2DValue(), 3.0, 4.0), 2.0);
  staticPrint('v1 + v2 = ${sum}');
  staticPrint('v1 - v2 = ${diff}');
  staticPrint('v1 * 2 = ${scaled}');
  staticPrint('v1.length = ${dart_str_toStringAsFixed((Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['get_length'] as Function)(Vector2D_new(Vector2DValue(), 3.0, 4.0)), 2)}');
  staticPrint('v1 == Vector2D(3,4): ${(Vector2D_new(Vector2DValue(), 3.0, 4.0) == Vector2D_new(Vector2DValue(), 3.0, 4.0))}');
  staticPrint('\n--- 3. static + factory ---');
  CounterValue c1 = Counter_new('alpha');
  CounterValue c2 = Counter_new('beta', initialValue: 50);
  CounterValue c3 = Counter_new_fromString('gamma:25');
  (c1.vptr['increment'] as Function)(c1, 10);
  (c2.vptr['decrement'] as Function)(c2, 5);
  (c3.vptr['increment'] as Function)(c3);
  staticPrint('${c1}, ${c2}, ${c3}');
  staticPrint('instances: ${Counter_get_instanceCount()}');
  staticPrint('maxValue: 100');
  staticPrint('\n--- 4. Result<T> + named params ---');
  staticPrint('ok: ${Result_new_success<int>(ResultValue<int>(), 42)}');
  staticPrint('err: ${Result_new_failure<int>(ResultValue<int>(), 'not found')}');
  String okMsg = (Result_new_success<int>(ResultValue<int>(), 42).vptr['fold_String'] as Function)(Result_new_success<int>(ResultValue<int>(), 42), onSuccess: ClosureEnv_global_4_new(GC.allocateLocal(ClosureEnv_global_4())), onFailure: ClosureEnv_global_5_new(GC.allocateLocal(ClosureEnv_global_5())));
  String errMsg = (Result_new_failure<int>(ResultValue<int>(), 'not found').vptr['fold_String'] as Function)(Result_new_failure<int>(ResultValue<int>(), 'not found'), onSuccess: ClosureEnv_global_6_new(GC.allocateLocal(ClosureEnv_global_6())), onFailure: ClosureEnv_global_7_new(GC.allocateLocal(ClosureEnv_global_7())));
  staticPrint('okMsg: ${okMsg}');
  staticPrint('errMsg: ${errMsg}');
  staticPrint('\n--- 5. 可选参数 ---');
  staticPrint(formatMessage('Hello {subject}!', 'Dart'));
  staticPrint(formatMessage('Count: {count}', null, 99));
  staticPrint(formatMessage('No params'));
  staticPrint(buildQuery(endpoint: 'api.example.com/users'));
  staticPrint(buildQuery(endpoint: 'api.example.com/search', params: StaticMap<String, String>.of({'q': 'dart', 'page': '1'}), maxWait: 10, secure: false));
  staticPrint('\n--- 6. sync* 生成器 ---');
  StaticList<int> r = StaticList<int>.of(range(0, 10, 2).toList());
  staticPrint('range(0,10,2): ${r}');
  StaticList<int> fib = StaticList<int>.of(fibonacci(8).toList());
  staticPrint('fibonacci(8): ${fib}');
  staticPrint('\n--- 7. async countdown ---');
  StaticList<String> countdown = smAwait(countDown(3));
  staticPrint('countdown: ${countdown}');
  staticPrint('\n--- 8. record 类型 ---');
  (String, int) person = getPersonRecord();
  staticPrint('person: ${person.$1}, age=${person.$2}');
  (String, double, double) loc = getLocation();
  staticPrint('location: ${loc.$1} (${loc.$2}, ${loc.$3})');
  late int q;
  late int r2;
  (int, int) _0_0 = divmod(17, 5);
  q = _0_0.$1;
  r2 = _0_0.$2;
  staticPrint('divmod(17,5): quotient=${q}, remainder=${r2}');
  staticPrint('\n--- 9. pattern matching ---');
  StaticList<dynamic> values = StaticList<dynamic>.of([null, -5, 42, '', 'hello', StaticList<int>.of([]), StaticList<int>.of([1, 2, 3])]);
  for (final v in values) {
    staticPrint('  ${describeValue(v)}');
  }
  staticPrint('\n--- 10. 级联操作符 ---');
  StaticList<int> list = buildList();
  staticPrint('buildList: ${list}');
  StaticStringBuffer buf = buildBuffer();
  staticPrint('buildBuffer: ${buf.toString().trim()}');
  staticPrint('\n--- 11. 展开 + 集合 if/for ---');
  StaticList<int> merged = mergeAndFilter(StaticList<int>.of([1, 2]), StaticList<int>.of([3, 4]), true);
  staticPrint('merged(includeNeg=true): ${merged}');
  StaticList<int> mergedNoNeg = mergeAndFilter(StaticList<int>.of([1, 2]), StaticList<int>.of([3, 4]), false);
  staticPrint('merged(includeNeg=false): ${mergedNoNeg}');
  StaticMap<String, int> scores = buildScoreMap(StaticList<String>.of(['Alice', 'Bob', 'Carol']), true);
  staticPrint('scores: ${scores}');
  staticPrint('\n--- 12. late 变量 ---');
  LazyLoaderValue loader = LazyLoader_new(LazyLoaderValue());
  staticPrint('before init: ${(loader.vptr['get_data'] as Function)(loader)}, ${(loader.vptr['get_computedValue'] as Function)(loader)}');
  (loader.vptr['initialize'] as Function)(loader, 'hello');
  staticPrint('after init: ${(loader.vptr['get_data'] as Function)(loader)}, ${(loader.vptr['get_computedValue'] as Function)(loader)}');
  staticPrint('\n--- 13. rethrow ---');
  try {
    parseAndDivide('10', '2');
    staticPrint('10/2 = ${parseAndDivide('10', '2')}');
  } on dynamic catch ( e) {
    staticPrint('unexpected: ${e}');
  }
  try {
    parseAndDivide('10', '0');
  } on StateError catch ( e) {
    staticPrint('StateError: ${e.message}');
  }
  try {
    parseAndDivide('abc', '2');
  } on FormatException catch ( e) {
    staticPrint('FormatException: ${e.message}');
  }
  staticPrint('\n--- 14. assert ---');
  BoundedValueValue bv = BoundedValue_new(BoundedValueValue(), 0.0, 10.0, 5.0);
  (bv.vptr['set'] as Function)(bv, 7.5);
  staticPrint('BoundedValue: ${(bv.vptr['get_current'] as Function)(bv)}');
  staticPrint('\n--- 15. 字符串 ---');
  staticPrint(multiLineExample());
  staticPrint('\n--- 16. typedef + 函数式组合 ---');
  TypeFunction1<String, int> doubleIt = compose(ClosureEnv_global_8_new(GC.allocateLocal(ClosureEnv_global_8())), ClosureEnv_global_9_new(GC.allocateLocal(ClosureEnv_global_9())));
  staticPrint('compose(5): ${doubleIt(5)}');
  TypeFunction1<bool, int> isPositive = ClosureEnv_global_10_new(GC.allocateLocal(ClosureEnv_global_10()));
  TypeFunction1<bool, int> isEven = ClosureEnv_global_11_new(GC.allocateLocal(ClosureEnv_global_11()));
  TypeFunction1<bool, int> isPositiveEven = and(isPositive, isEven);
  StaticList<int> nums = StaticList<int>.of([-2, -1, 0, 1, 2, 3, 4]);
  staticPrint('positiveEvens: ${StaticList<int>.of(StaticList<int>.of(nums.where(isPositiveEven)).toList())}');
  StaticList<int> nested = flatMap(StaticList<int>.of([1, 2, 3]), ClosureEnv_global_12_new(GC.allocateLocal(ClosureEnv_global_12())));
  staticPrint('flatMap: ${nested}');
  staticPrint('\n--- 19. 多层继承链 ---');
  ShapeValue shape = Shape_new(ShapeValue(), 'red');
  staticPrint((shape.vptr['describe'] as Function)(shape));
  ShapeValue transparentShape = Shape_new_transparent(ShapeValue(), 'blue');
  staticPrint((transparentShape.vptr['describe'] as Function)(transparentShape));
  PolygonValue polygon = Polygon_new(PolygonValue(), 'green', 6, opacity: 0.8);
  staticPrint((polygon.vptr['describe'] as Function)(polygon));
  staticPrint('perimeter: ${(polygon.vptr['perimeter'] as Function)(polygon, 3.0)}');
  RegularPolygonValue hexagon = RegularPolygon_new(RegularPolygonValue(), 'yellow', 6, 5.0);
  staticPrint((hexagon.vptr['describe'] as Function)(hexagon));
  staticPrint('perimeter: ${(hexagon.vptr['perimeter'] as Function)(hexagon)}');
  staticPrint('area: ${(hexagon.vptr['area'] as Function)(hexagon)}');
  SquareValue square = Square_new(SquareValue(), 'white', 10.0, opacity: 0.9);
  staticPrint((square.vptr['describe'] as Function)(square));
  staticPrint('square perimeter: ${(square.vptr['perimeter'] as Function)(square)}');
  staticPrint('\n--- 20. implements 多接口 ---');
  DataPointValue dp1 = DataPoint_new(DataPointValue(), 1.0, 2.0, 'A');
  DataPointValue dp2 = DataPoint_new(DataPointValue(), 3.0, 1.0, 'B');
  staticPrint('dp1: ${dp1}');
  staticPrint('dp1.serialize: ${(dp1.vptr['serialize'] as Function)(dp1)}');
  DataPointValue dp1Clone = (dp1.vptr['clone'] as Function)(dp1);
  staticPrint('dp1.clone: ${dp1Clone}');
  staticPrint('dp1.compareTo2(dp2): ${(dp1.vptr['compareTo2'] as Function)(dp1, dp2)}');
  staticPrint('\n--- 21. mixin on 约束 ---');
  LoggedDataPointValue ldp = LoggedDataPoint_new(LoggedDataPointValue(), 5.0, 6.0, 'logged');
  (ldp.vptr['log'] as Function)(ldp, 'created');
  staticPrint('validate: ${(ldp.vptr['validate'] as Function)(ldp)}');
  staticPrint('serialize: ${(ldp.vptr['serialize'] as Function)(ldp)}');
  staticPrint('\n--- 22. 增强枚举 ---');
  staticPrint('Priority.high: ${Priority}.high');
  staticPrint('high > medium: ${Priority_isHigherThan(Priority.high, Priority.medium)}');
  staticPrint('low > high: ${Priority_isHigherThan(Priority.low, Priority.high)}');
  for (final p in StaticList.of([Priority.low, Priority.medium, Priority.high, Priority.critical])) {
    staticPrint('  ${Priority_toString(p)}');
  }
  staticPrint('GET isReadOnly: ${HttpMethod_get_isReadOnly(HttpMethod.get)}');
  staticPrint('POST isReadOnly: ${HttpMethod_get_isReadOnly(HttpMethod.post)}');
  staticPrint('\n--- 23. 重定向构造函数 ---');
  ConfigValue cfg1 = Config_new(ConfigValue(), 'example.com', 8080);
  ConfigValue cfg2 = Config_new_localhost(ConfigValue());
  ConfigValue cfg3 = Config_new_production(ConfigValue(), 'api.example.com');
  staticPrint('cfg1: ${cfg1}');
  staticPrint('cfg2: ${cfg2}');
  staticPrint('cfg3: ${cfg3}');
  staticPrint('\n--- 24. 泛型约束 ---');
  SortedListValue<int> sortedList = SortedList_new<int>(SortedListValue<int>());
  (sortedList.vptr['add'] as Function)(sortedList, 5);
  (sortedList.vptr['add'] as Function)(sortedList, 1);
  (sortedList.vptr['add'] as Function)(sortedList, 3);
  (sortedList.vptr['add'] as Function)(sortedList, 2);
  staticPrint('sorted: ${sortedList}');
  staticPrint('first: ${(sortedList.vptr['get_first'] as Function)(sortedList)}, last: ${(sortedList.vptr['get_last'] as Function)(sortedList)}');
  int maxVal = findMax(StaticList<int>.of([3, 7, 1, 9, 4]));
  staticPrint('findMax: ${maxVal}');
  String result = applyTwice(5, ClosureEnv_global_13_new(GC.allocateLocal(ClosureEnv_global_13())), ClosureEnv_global_14_new(GC.allocateLocal(ClosureEnv_global_14())));
  staticPrint('applyTwice: ${result}');
  staticPrint('\n--- 25. null safety ---');
  NullSafetyDemoValue ns1 = NullSafetyDemo_new(NullSafetyDemoValue(), 'hello', 'world');
  staticPrint('ns1: ${(ns1.vptr['demonstrate'] as Function)(ns1)}');
  NullSafetyDemoValue ns2 = NullSafetyDemo_new(NullSafetyDemoValue(), 'hello');
  staticPrint('ns2: ${(ns2.vptr['demonstrate'] as Function)(ns2)}');
  String? found = findFirst(StaticList<String>.of(['apple', 'banana', 'cherry']), ClosureEnv_global_15_new(GC.allocateLocal(ClosureEnv_global_15())));
  staticPrint('findFirst(b): ${found}');
  String? notFound = findFirst(StaticList<String>.of(['apple', 'banana']), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16())));
  staticPrint('findFirst(z): ${notFound}');
  staticPrint('\n--- 26. for-in + do-while ---');
  StaticList<int> filtered = filterWithForIn(StaticList<int>.of([5, -3, 10, 200, 50, -1, 80]));
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
  CircleRendererValue renderer = CircleRenderer_new(CircleRendererValue());
  staticPrint('renderer: ${(renderer.vptr['get_name'] as Function)(renderer)}');
  (renderer.vptr['render'] as Function)(renderer, 'circle');
  staticPrint('\n--- 30. Pipeline 泛型链 ---');
  PipelineValue<int, String> pipeline = ((Pipeline_new<int, String>(PipelineValue<int, String>(), ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()))).vptr['then_int'] as Function)(Pipeline_new<int, String>(PipelineValue<int, String>(), ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()))), ClosureEnv_global_18_new(GC.allocateLocal(ClosureEnv_global_18()))).vptr['then_String'] as Function)((Pipeline_new<int, String>(PipelineValue<int, String>(), ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()))).vptr['then_int'] as Function)(Pipeline_new<int, String>(PipelineValue<int, String>(), ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17()))), ClosureEnv_global_18_new(GC.allocateLocal(ClosureEnv_global_18()))), ClosureEnv_global_19_new(GC.allocateLocal(ClosureEnv_global_19())));
  staticPrint('pipeline(42): ${(pipeline.vptr['execute'] as Function)(pipeline, 42)}');
  staticPrint('pipeline(12345): ${(pipeline.vptr['execute'] as Function)(pipeline, 12345)}');
  staticPrint('\n--- 31. switch-case ---');
  staticPrint('day 1: ${dayType(1)}');
  staticPrint('day 3: ${dayType(3)}');
  staticPrint('day 7: ${dayType(7)}');
  staticPrint('day 9: ${dayType(9)}');
  staticPrint('\n--- 32. 位运算 ---');
  BitFlagsValue flags = BitFlags_new(BitFlagsValue());
  (flags.vptr['set'] as Function)(flags, 1);
  (flags.vptr['set'] as Function)(flags, 4);
  staticPrint('flags: ${flags}');
  staticPrint('has read: ${(flags.vptr['has'] as Function)(flags, 1)}');
  staticPrint('has write: ${(flags.vptr['has'] as Function)(flags, 2)}');
  (flags.vptr['set'] as Function)(flags, 2);
  staticPrint('after set write: ${flags}');
  (flags.vptr['clear'] as Function)(flags, 4);
  staticPrint('after clear execute: ${flags}');
  staticPrint('\n--- 33. 多层 mixin ---');
  EventValue event = Event_new(EventValue(), 'meeting');
  (event.vptr['addTag'] as Function)(event, 'work');
  (event.vptr['addTag'] as Function)(event, 'important');
  staticPrint(event);
  ImportantEventValue impEvent = ImportantEvent_new(ImportantEventValue(), 'deadline', Priority.critical);
  (impEvent.vptr['addTag'] as Function)(impEvent, 'urgent');
  (impEvent.vptr['log'] as Function)(impEvent, 'created');
  staticPrint(impEvent);
  staticPrint('\n=== 所有测试通过 ✅ ===');
}

class ClosureEnv_global_0<TNewOutput extends dynamic, TOutput extends dynamic, TInput extends dynamic> extends TypeFunction1<TNewOutput, TInput> {
  late PipelineValue this_;
  late TypeFunction1<TNewOutput, TOutput> next;

  ClosureEnv_global_0() {
  }
  TNewOutput call(TInput input) =>
      ClosureEnv_global_0_call(this, input);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
    next?.gcMark(flag);
  }
}

TNewOutput ClosureEnv_global_0_call<TNewOutput extends dynamic, TOutput extends dynamic, TInput extends dynamic>(dynamic env__, TInput input) {
  final env = env__ as ClosureEnv_global_0<TNewOutput, TOutput, TInput>;
  return env.next((() { final _unnamed = input; return env.this_._transform(_unnamed); })());
}

ClosureEnv_global_0<TNewOutput, TOutput, TInput> ClosureEnv_global_0_new<TNewOutput extends dynamic, TOutput extends dynamic, TInput extends dynamic>(ClosureEnv_global_0<TNewOutput, TOutput, TInput> env_, PipelineValue this_, TypeFunction1<TNewOutput, TOutput> next) {
  env_.this_ = this_;
  env_.next = next;
  return env_;
}

class ClosureEnv_global_1 extends TypeFunction1<String, StaticMapEntry<String, String>> {

  ClosureEnv_global_1() {
  }
  String call(StaticMapEntry<String, String> e) =>
      ClosureEnv_global_1_call(this, e);
}

String ClosureEnv_global_1_call(dynamic env__, StaticMapEntry<String, String> e) {
  final env = env__ as ClosureEnv_global_1;
  return '${e.key}=${e.value}';
}

ClosureEnv_global_1 ClosureEnv_global_1_new(ClosureEnv_global_1 env_) {
  return env_;
}

class ClosureEnv_global_2<C extends dynamic, B extends dynamic, A extends dynamic> extends TypeFunction1<C, A> {
  late TypeFunction1<C, B> g;
  late TypeFunction1<B, A> f;

  ClosureEnv_global_2() {
  }
  C call(A input) =>
      ClosureEnv_global_2_call(this, input);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    g?.gcMark(flag);
    f?.gcMark(flag);
  }
}

C ClosureEnv_global_2_call<C extends dynamic, B extends dynamic, A extends dynamic>(dynamic env__, A input) {
  final env = env__ as ClosureEnv_global_2<C, B, A>;
  return env.g(env.f(input));
}

ClosureEnv_global_2<C, B, A> ClosureEnv_global_2_new<C extends dynamic, B extends dynamic, A extends dynamic>(ClosureEnv_global_2<C, B, A> env_, TypeFunction1<C, B> g, TypeFunction1<B, A> f) {
  env_.g = g;
  env_.f = f;
  return env_;
}

class ClosureEnv_global_3<T extends dynamic> extends TypeFunction1<bool, T> {
  late TypeFunction1<bool, T> p1;
  late TypeFunction1<bool, T> p2;

  ClosureEnv_global_3() {
  }
  bool call(T value) =>
      ClosureEnv_global_3_call(this, value);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    p1?.gcMark(flag);
    p2?.gcMark(flag);
  }
}

bool ClosureEnv_global_3_call<T extends dynamic>(dynamic env__, T value) {
  final env = env__ as ClosureEnv_global_3<T>;
  return env.p1(value) && env.p2(value);
}

ClosureEnv_global_3<T> ClosureEnv_global_3_new<T extends dynamic>(ClosureEnv_global_3<T> env_, TypeFunction1<bool, T> p1, TypeFunction1<bool, T> p2) {
  env_.p1 = p1;
  env_.p2 = p2;
  return env_;
}

class ClosureEnv_global_4 extends TypeFunction1<String, int> {

  ClosureEnv_global_4() {
  }
  String call(int d) =>
      ClosureEnv_global_4_call(this, d);
}

String ClosureEnv_global_4_call(dynamic env__, int d) {
  final env = env__ as ClosureEnv_global_4;
  return 'got ${d}';
}

ClosureEnv_global_4 ClosureEnv_global_4_new(ClosureEnv_global_4 env_) {
  return env_;
}

class ClosureEnv_global_5 extends TypeFunction1<String, String> {

  ClosureEnv_global_5() {
  }
  String call(String e) =>
      ClosureEnv_global_5_call(this, e);
}

String ClosureEnv_global_5_call(dynamic env__, String e) {
  final env = env__ as ClosureEnv_global_5;
  return 'error: ${e}';
}

ClosureEnv_global_5 ClosureEnv_global_5_new(ClosureEnv_global_5 env_) {
  return env_;
}

class ClosureEnv_global_6 extends TypeFunction1<String, int> {

  ClosureEnv_global_6() {
  }
  String call(int d) =>
      ClosureEnv_global_6_call(this, d);
}

String ClosureEnv_global_6_call(dynamic env__, int d) {
  final env = env__ as ClosureEnv_global_6;
  return 'got ${d}';
}

ClosureEnv_global_6 ClosureEnv_global_6_new(ClosureEnv_global_6 env_) {
  return env_;
}

class ClosureEnv_global_7 extends TypeFunction1<String, String> {

  ClosureEnv_global_7() {
  }
  String call(String e) =>
      ClosureEnv_global_7_call(this, e);
}

String ClosureEnv_global_7_call(dynamic env__, String e) {
  final env = env__ as ClosureEnv_global_7;
  return 'error: ${e}';
}

ClosureEnv_global_7 ClosureEnv_global_7_new(ClosureEnv_global_7 env_) {
  return env_;
}

class ClosureEnv_global_8 extends TypeFunction1<int, int> {

  ClosureEnv_global_8() {
  }
  int call(int x) =>
      ClosureEnv_global_8_call(this, x);
}

int ClosureEnv_global_8_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_8;
  return (x * 2);
}

ClosureEnv_global_8 ClosureEnv_global_8_new(ClosureEnv_global_8 env_) {
  return env_;
}

class ClosureEnv_global_9 extends TypeFunction1<String, int> {

  ClosureEnv_global_9() {
  }
  String call(int x) =>
      ClosureEnv_global_9_call(this, x);
}

String ClosureEnv_global_9_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_9;
  return 'result=${x}';
}

ClosureEnv_global_9 ClosureEnv_global_9_new(ClosureEnv_global_9 env_) {
  return env_;
}

class ClosureEnv_global_10 extends TypeFunction1<bool, int> {

  ClosureEnv_global_10() {
  }
  bool call(int n) =>
      ClosureEnv_global_10_call(this, n);
}

bool ClosureEnv_global_10_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_global_10;
  return (n > 0);
}

ClosureEnv_global_10 ClosureEnv_global_10_new(ClosureEnv_global_10 env_) {
  return env_;
}

class ClosureEnv_global_11 extends TypeFunction1<bool, int> {

  ClosureEnv_global_11() {
  }
  bool call(int n) =>
      ClosureEnv_global_11_call(this, n);
}

bool ClosureEnv_global_11_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_global_11;
  return ((n % 2) == 0);
}

ClosureEnv_global_11 ClosureEnv_global_11_new(ClosureEnv_global_11 env_) {
  return env_;
}

class ClosureEnv_global_12 extends TypeFunction1<StaticList<int>, int> {

  ClosureEnv_global_12() {
  }
  StaticList<int> call(int x) =>
      ClosureEnv_global_12_call(this, x);
}

StaticList<int> ClosureEnv_global_12_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_12;
  return StaticList<int>.of([x, (x * x)]);
}

ClosureEnv_global_12 ClosureEnv_global_12_new(ClosureEnv_global_12 env_) {
  return env_;
}

class ClosureEnv_global_13 extends TypeFunction1<String, int> {

  ClosureEnv_global_13() {
  }
  String call(int x) =>
      ClosureEnv_global_13_call(this, x);
}

String ClosureEnv_global_13_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_13;
  return 'n=${x}';
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
  return '${s}!';
}

ClosureEnv_global_14 ClosureEnv_global_14_new(ClosureEnv_global_14 env_) {
  return env_;
}

class ClosureEnv_global_15 extends TypeFunction1<bool, String> {

  ClosureEnv_global_15() {
  }
  bool call(String s) =>
      ClosureEnv_global_15_call(this, s);
}

bool ClosureEnv_global_15_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_global_15;
  return s.startsWith('b');
}

ClosureEnv_global_15 ClosureEnv_global_15_new(ClosureEnv_global_15 env_) {
  return env_;
}

class ClosureEnv_global_16 extends TypeFunction1<bool, String> {

  ClosureEnv_global_16() {
  }
  bool call(String s) =>
      ClosureEnv_global_16_call(this, s);
}

bool ClosureEnv_global_16_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_global_16;
  return s.startsWith('z');
}

ClosureEnv_global_16 ClosureEnv_global_16_new(ClosureEnv_global_16 env_) {
  return env_;
}

class ClosureEnv_global_17 extends TypeFunction1<String, int> {

  ClosureEnv_global_17() {
  }
  String call(int n) =>
      ClosureEnv_global_17_call(this, n);
}

String ClosureEnv_global_17_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_global_17;
  return 'val=${n}';
}

ClosureEnv_global_17 ClosureEnv_global_17_new(ClosureEnv_global_17 env_) {
  return env_;
}

class ClosureEnv_global_18 extends TypeFunction1<int, String> {

  ClosureEnv_global_18() {
  }
  int call(String s) =>
      ClosureEnv_global_18_call(this, s);
}

int ClosureEnv_global_18_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_global_18;
  return s.length;
}

ClosureEnv_global_18 ClosureEnv_global_18_new(ClosureEnv_global_18 env_) {
  return env_;
}

class ClosureEnv_global_19 extends TypeFunction1<String, int> {

  ClosureEnv_global_19() {
  }
  String call(int len) =>
      ClosureEnv_global_19_call(this, len);
}

String ClosureEnv_global_19_call(dynamic env__, int len) {
  final env = env__ as ClosureEnv_global_19;
  return 'len=${len}';
}

ClosureEnv_global_19 ClosureEnv_global_19_new(ClosureEnv_global_19 env_) {
  return env_;
}


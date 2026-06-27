import 'package:dart2cpp/restorer/runtime_classes.dart';

typedef Predicate<T> = TypeFunction1<bool, T>;

typedef Transformer<A, B> = TypeFunction1<B, A>;

typedef VoidCallback = TypeFunction0<void>;

// mixin Printable → static functions for delegation
void Printable_printInfo(dynamic this__) {
  final this_ = this__;
  staticPrint('[${(this_.vptr['get_displayName'] as String Function(dynamic))(this_)}]');
}


// mixin Orderable → static functions for delegation
bool Orderable_isLessThan<T>(dynamic this__, T other) {
  final this_ = this__;
  return ((this_.vptr['compareTo'] as int Function(dynamic, T))(this_, other) < 0);
}

bool Orderable_isGreaterThan<T>(dynamic this__, T other) {
  final this_ = this__;
  return ((this_.vptr['compareTo'] as int Function(dynamic, T))(this_, other) > 0);
}


class AnimalValue extends VPtr {
  late String name;
  late int age;
  AnimalValue() {
    vptr['speak'] = Animal_speak;
    vptr['toString'] = Animal_toString;
  }
}

AnimalValue Animal_new(dynamic this__, String name, int age) {
  final this_ = this__ as AnimalValue;
  this_.name = name;
  this_.age = age;
  return this_;
}

String Animal_speak(dynamic this_) {
  throw UnimplementedError('Animal.speak is abstract');
}

String Animal_toString(dynamic this__) {
  final this_ = this__ as AnimalValue;
  return '${this_.name}(age=${this_.age})';
}


class DogValue extends Dog_Animal_Printable_OrderableValue {
  late String breed;
  DogValue() {
    vptr['speak'] = Dog_speak;
    vptr['toString'] = Dog_toString;
    vptr['get_displayName'] = Dog_get_displayName;
    vptr['printInfo'] = Dog_printInfo;
    vptr['compareTo'] = Dog_compareTo;
    vptr['isLessThan'] = Dog_isLessThan;
    vptr['isGreaterThan'] = Dog_isGreaterThan;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DogValue Dog_new(dynamic this__, String name, int age, String breed) {
  final this_ = this__ as DogValue;
  Animal_new(this_, name, age);
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

String Dog_toString(dynamic this__) {
  final this_ = this__ as DogValue;
  return Animal_toString(this_);
}

void Dog_printInfo(dynamic this__) {
  final this_ = this__ as DogValue;
  Printable_printInfo(this_);
}

bool Dog_isLessThan(dynamic this__, DogValue other) {
  final this_ = this__ as DogValue;
  return Orderable_isLessThan<DogValue>(this_, other);
}

bool Dog_isGreaterThan(dynamic this__, DogValue other) {
  final this_ = this__ as DogValue;
  return Orderable_isGreaterThan<DogValue>(this_, other);
}


class CatValue extends Cat_Animal_PrintableValue {
  late String _mood;
  CatValue() {
    vptr['speak'] = Cat_speak;
    vptr['toString'] = Cat_toString;
    vptr['get_displayName'] = Cat_get_displayName;
    vptr['printInfo'] = Cat_printInfo;
    vptr['get_mood'] = Cat_get_mood;
    vptr['set_mood'] = Cat_set_mood;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CatValue Cat_new(dynamic this__, String name, int age) {
  final this_ = this__ as CatValue;
  Animal_new(this_, name, age);
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
}

String Cat_toString(dynamic this__) {
  final this_ = this__ as CatValue;
  return Animal_toString(this_);
}

void Cat_printInfo(dynamic this__) {
  final this_ = this__ as CatValue;
  Printable_printInfo(this_);
}


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
}

Vector2DValue Vector2D_new(dynamic this__, double x, double y) {
  final this_ = this__ as Vector2DValue;
  this_.x = x;
  this_.y = y;
  return this_;
}

Vector2DValue Vector2D_operatorPlus(dynamic this__, Vector2DValue other) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x + other.x), (this_.y + other.y));
}

Vector2DValue Vector2D_operatorMinus(dynamic this__, Vector2DValue other) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x - other.x), (this_.y - other.y));
}

Vector2DValue Vector2D_operatorStar(dynamic this__, double scalar) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x * scalar), (this_.y * scalar));
}

bool Vector2D_operatorEq(dynamic this__, Object other) {
  final this_ = this__ as Vector2DValue;
  return (((other is Vector2DValue) && (this_.x == other.x)) && (this_.y == other.y));
}

double Vector2D_get_length(dynamic this__) {
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
}

int Counter__instanceCount = 0;
const int Counter_maxValue = 100;
CounterValue Counter_new__(dynamic this__, String label, int _value) {
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

void Counter_increment(dynamic this__, int step) {
  final this_ = this__ as CounterValue;
  this_._value = (this_._value + step).clamp(0, 100);
}

void Counter_decrement(dynamic this__, int step) {
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


class ResultValue<T> extends VPtr {
  late T? data;
  late String? error;
  late bool isSuccess;
  ResultValue() {
    vptr['toString'] = Result_toString<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (data is AnyGC) (data as AnyGC).gcMark(flag);
  }
}

ResultValue<T> Result_new_success<T>(dynamic this__, T value) {
  final this_ = this__ as ResultValue<T>;
  this_.vptr['fold_String'] = Result_fold<T, String>;
  this_.data = value;
  this_.error = null;
  this_.isSuccess = true;
  return this_;
}

ResultValue<T> Result_new_failure<T>(dynamic this__, String message) {
  final this_ = this__ as ResultValue<T>;
  this_.vptr['fold_String'] = Result_fold<T, String>;
  this_.data = null;
  this_.error = message;
  this_.isSuccess = false;
  return this_;
}

R Result_fold<T, R>(dynamic this__, TypeFunction1<R, T> onSuccess, TypeFunction1<R, String> onFailure) {
  final this_ = this__ as ResultValue<T>;
  if ((this_.isSuccess && !((this_.data == null)))) {
    return onSuccess.closureCall(onSuccess, (this_.data as T));
  }
  return onFailure.closureCall(onFailure, (this_.error ?? 'Unknown error'));
}

String Result_toString<T>(dynamic this__) {
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
  return (this_._initialized ? this_._computedValue : (-1));
}


class BoundedValueValue extends VPtr {
  late double min;
  late double max;
  late double _current;
  BoundedValueValue() {
    vptr['set'] = BoundedValue_set;
    vptr['get_current'] = BoundedValue_get_current;
  }
}

BoundedValueValue BoundedValue_new(dynamic this__, double min, double max, double initial) {
  final this_ = this__ as BoundedValueValue;
  this_.min = min;
  this_.max = max;
  this_._current = initial;
  assert((this_.min <= this_.max), 'min must be <= max');
  assert(((initial >= this_.min) && (initial <= this_.max)), 'initial must be in [min, max]');
  return this_;
}

void BoundedValue_set(dynamic this__, double value) {
  final this_ = this__ as BoundedValueValue;
  assert(((value >= this_.min) && (value <= this_.max)), 'value ${value} out of bounds [${this_.min}, ${this_.max}]');
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
}

ShapeValue Shape_new(dynamic this__, String color, {double opacity = 1.0}) {
  final this_ = this__ as ShapeValue;
  this_.color = color;
  this_.opacity = opacity;
  return this_;
}

ShapeValue Shape_new_transparent(dynamic this__, String color) {
  final this_ = this__ as ShapeValue;
  Shape_new(this_, color, opacity: 0.5);
  return this_;
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
    if (gcFlag == flag) return;
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
    if (gcFlag == flag) return;
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

double RegularPolygon_perimeter(dynamic this__, double? overrideSideLength) {
  final this_ = this__ as RegularPolygonValue;
  return (this_.sides * (overrideSideLength ?? this_.sideLength));
}

double RegularPolygon_area(dynamic this__) {
  final this_ = this__ as RegularPolygonValue;
  return (((this_.sides * this_.sideLength) * this_.sideLength) / 4.0);
}


class SquareValue extends RegularPolygonValue {
  SquareValue() {
    vptr['describe'] = Square_describe;
    vptr['perimeter'] = Square_perimeter;
    vptr['area'] = Square_area;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
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

double Square_perimeter(dynamic this__, double? overrideSideLength) {
  final this_ = this__ as SquareValue;
  return RegularPolygon_perimeter(this_, overrideSideLength);
}

double Square_area(dynamic this__) {
  final this_ = this__ as SquareValue;
  return RegularPolygon_area(this_);
}


class SerializableValue extends VPtr {
  SerializableValue() {
    vptr['serialize'] = Serializable_serialize;
  }
}

SerializableValue Serializable_new(dynamic this__) {
  final this_ = this__ as SerializableValue;
  return this_;
}

String Serializable_serialize(dynamic this_) {
  throw UnimplementedError('Serializable.serialize is abstract');
}


class CloneableValue<T> extends VPtr {
  CloneableValue() {
    vptr['clone'] = Cloneable_clone<T>;
  }
}

CloneableValue<T> Cloneable_new<T>(dynamic this__) {
  final this_ = this__ as CloneableValue<T>;
  return this_;
}

T Cloneable_clone<T>(dynamic this_) {
  throw UnimplementedError('Cloneable.clone is abstract');
}


class Comparable2Value<T> extends VPtr {
  Comparable2Value() {
    vptr['compareTo2'] = Comparable2_compareTo2<T>;
  }
}

Comparable2Value<T> Comparable2_new<T>(dynamic this__) {
  final this_ = this__ as Comparable2Value<T>;
  return this_;
}

int Comparable2_compareTo2<T>(dynamic this_, T other) {
  throw UnimplementedError('Comparable2.compareTo2 is abstract');
}


class DataPointValue extends VPtr implements SerializableValue, CloneableValue<DataPointValue>, Comparable2Value<DataPointValue> {
  late double x;
  late double y;
  late String label;
  DataPointValue() {
    vptr['serialize'] = DataPoint_serialize;
    vptr['clone'] = DataPoint_clone;
    vptr['compareTo2'] = DataPoint_compareTo2;
    vptr['toString'] = DataPoint_toString;
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
  return DataPoint_new(GC.allocateLocal(DataPointValue()), this_.x, this_.y, this_.label);
}

int DataPoint_compareTo2(dynamic this__, DataPointValue other) {
  final this_ = this__ as DataPointValue;
  final double dx = (this_.x - other.x);
  if (!((dx == 0)))   return ((dx > 0) ? 1 : (-1));
  final double dy = (this_.y - other.y);
  if (!((dy == 0)))   return ((dy > 0) ? 1 : (-1));
  return 0;
}

String DataPoint_toString(dynamic this__) {
  final this_ = this__ as DataPointValue;
  return 'DataPoint(${this_.x}, ${this_.y}, "${this_.label}")';
}


// mixin Loggable → static functions for delegation
void Loggable_log(dynamic this__, String message) {
  final this_ = this__;
  staticPrint('[${(this_.vptr['get_logTag'] as String Function(dynamic))(this_)}] ${message}');
}


// mixin Validatable → static functions for delegation
bool Validatable_validate(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['serialize'] as String Function(dynamic))(this_).isNotEmpty;
}


class LoggedDataPointValue extends LoggedDataPoint_DataPoint_Loggable_ValidatableValue {
  LoggedDataPointValue() {
    vptr['serialize'] = LoggedDataPoint_serialize;
    vptr['clone'] = LoggedDataPoint_clone;
    vptr['compareTo2'] = LoggedDataPoint_compareTo2;
    vptr['toString'] = LoggedDataPoint_toString;
    vptr['get_logTag'] = LoggedDataPoint_get_logTag;
    vptr['log'] = LoggedDataPoint_log;
    vptr['validate'] = LoggedDataPoint_validate;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

LoggedDataPointValue LoggedDataPoint_new(dynamic this__, double x, double y, String label) {
  final this_ = this__ as LoggedDataPointValue;
  DataPoint_new(this_, x, y, label);
  return this_;
}

String LoggedDataPoint_get_logTag(dynamic this__) {
  final this_ = this__ as LoggedDataPointValue;
  return 'DataPoint';
}

String LoggedDataPoint_serialize(dynamic this__) {
  final this_ = this__ as LoggedDataPointValue;
  return DataPoint_serialize(this_);
}

DataPointValue LoggedDataPoint_clone(dynamic this__) {
  final this_ = this__ as LoggedDataPointValue;
  return DataPoint_clone(this_);
}

int LoggedDataPoint_compareTo2(dynamic this__, DataPointValue other) {
  final this_ = this__ as LoggedDataPointValue;
  return DataPoint_compareTo2(this_, other);
}

String LoggedDataPoint_toString(dynamic this__) {
  final this_ = this__ as LoggedDataPointValue;
  return DataPoint_toString(this_);
}

void LoggedDataPoint_log(dynamic this__, String message) {
  final this_ = this__ as LoggedDataPointValue;
  Loggable_log(this_, message);
}

bool LoggedDataPoint_validate(dynamic this__) {
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

class ConfigValue extends VPtr {
  late String host;
  late int port;
  late bool secure;
  late String baseUrl;
  ConfigValue() {
    vptr['toString'] = Config_toString;
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
  Config_new(this_, 'localhost', port);
  return this_;
}

ConfigValue Config_new_production(dynamic this__, String host) {
  final this_ = this__ as ConfigValue;
  Config_new(this_, host, 443, secure: true);
  return this_;
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
    vptr['get_length'] = SortedList_get_length<T>;
    vptr['toList'] = SortedList_toList<T>;
    vptr['toString'] = SortedList_toString<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_items is AnyGC) (_items as AnyGC).gcMark(flag);
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
}

NullSafetyDemoValue NullSafetyDemo_new(dynamic this__, String nonNullField, [String? nullableField = null]) {
  final this_ = this__ as NullSafetyDemoValue;
  this_.nonNullField = nonNullField;
  this_.nullableField = nullableField;
  return this_;
}

String NullSafetyDemo_demonstrate(dynamic this__) {
  final this_ = this__ as NullSafetyDemoValue;
  final int? len = this_.nullableField?.length;
  final int safeLen = (len ?? (-1));
  ((this_.nullableField == null) ? this_.nullableField = 'default' : null);
  final String forced = this_.nullableField!.toUpperCase();
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

void Renderer_render(dynamic this_, Object shape) {
  throw UnimplementedError('Renderer.render is abstract');
}

String Renderer_get_name(dynamic this_) {
  throw UnimplementedError('Renderer.name is abstract');
}


class CircleRendererValue extends RendererValue {
  CircleRendererValue() {
    vptr['render'] = CircleRenderer_render;
    vptr['get_name'] = CircleRenderer_get_name;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
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


class PipelineValue<TInput, TOutput> extends VPtr {
  late TypeFunction1<TOutput, TInput> _transform;
  PipelineValue() {
    vptr['execute'] = Pipeline_execute<TInput, TOutput>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_transform is AnyGC) (_transform as AnyGC).gcMark(flag);
  }
}

PipelineValue<TInput, TOutput> Pipeline_new<TInput, TOutput>(dynamic this__, TypeFunction1<TOutput, TInput> _transform) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  this_.vptr['then_String'] = Pipeline_then<TInput, TOutput, String>;
  this_.vptr['then_int'] = Pipeline_then<TInput, TOutput, int>;
  this_._transform = _transform;
  return this_;
}

TOutput Pipeline_execute<TInput, TOutput>(dynamic this__, TInput input) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return (() { final _let4 = input; return this_._transform.closureCall(this_._transform, _let4); })();
}

PipelineValue<TInput, TNewOutput> Pipeline_then<TInput, TOutput, TNewOutput>(dynamic this__, TypeFunction1<TNewOutput, TOutput> next) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return Pipeline_new<TInput, TNewOutput>(GC.allocateLocal(PipelineValue<TInput, TNewOutput>()), ClosureEnv_anon_0_new<TNewOutput, TOutput, TInput>(GC.allocateLocal(ClosureEnv_anon_0<TNewOutput, TOutput, TInput>()), this_, next));
}


class BitFlagsValue extends VPtr {
  late int _flags;
  BitFlagsValue() {
    vptr['set'] = BitFlags_set;
    vptr['clear'] = BitFlags_clear;
    vptr['has'] = BitFlags_has;
    vptr['toString'] = BitFlags_toString;
  }
}

const int BitFlags_read = 1;
const int BitFlags_write = 2;
const int BitFlags_execute = 4;
BitFlagsValue BitFlags_new(dynamic this__, [int _flags = 0]) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = _flags;
  return this_;
}

void BitFlags_set(dynamic this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = (this_._flags | flag);
}

void BitFlags_clear(dynamic this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  this_._flags = (this_._flags & (~flag));
}

bool BitFlags_has(dynamic this__, int flag) {
  final this_ = this__ as BitFlagsValue;
  return !(((this_._flags & flag) == 0));
}

String BitFlags_toString(dynamic this__) {
  final this_ = this__ as BitFlagsValue;
  final StaticList<String> parts = StaticList<String>.of([]);
  if ((this_.vptr['has'] as bool Function(dynamic, int))(this_, 1))   parts.add('r');
  if ((this_.vptr['has'] as bool Function(dynamic, int))(this_, 2))   parts.add('w');
  if ((this_.vptr['has'] as bool Function(dynamic, int))(this_, 4))   parts.add('x');
  return (parts.isEmpty ? '-' : parts.join(''));
}


// mixin Timestamped → static functions for delegation
int Timestamped_get_timestamp(dynamic this__) {
  final this_ = this__;
  return 1234567890;
}

String Timestamped_get_timeStr(dynamic this__) {
  final this_ = this__;
  return 'T:${(this_.vptr['get_timestamp'] as int Function(dynamic))(this_)}';
}


// mixin Tagged → static functions for delegation
void Tagged_addTag(dynamic this__, String tag) {
  final this_ = this__;
  this_._tags.add(tag);
}

StaticList<String> Tagged_get_tags(dynamic this__) {
  final this_ = this__;
  return StaticList<String>.unmodifiable(this_._tags);
}


class EventValue extends Event_Object_Timestamped_TaggedValue {
  late String name;
  EventValue() {
    vptr['get_timestamp'] = Event_get_timestamp;
    vptr['get_timeStr'] = Event_get_timeStr;
    vptr['addTag'] = Event_addTag;
    vptr['get_tags'] = Event_get_tags;
    vptr['toString'] = Event_toString;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

EventValue Event_new(dynamic this__, String name) {
  final this_ = this__ as EventValue;
  this_.name = name;
  return this_;
}

String Event_toString(dynamic this__) {
  final this_ = this__ as EventValue;
  return 'Event(${this_.name}, ${(this_.vptr['get_timeStr'] as String Function(dynamic))(this_)}, tags=${(this_.vptr['get_tags'] as StaticList<String> Function(dynamic))(this_)})';
}

int Event_get_timestamp(dynamic this__) {
  final this_ = this__ as EventValue;
  return Timestamped_get_timestamp(this_);
}

String Event_get_timeStr(dynamic this__) {
  final this_ = this__ as EventValue;
  return Timestamped_get_timeStr(this_);
}

void Event_addTag(dynamic this__, String tag) {
  final this_ = this__ as EventValue;
  Tagged_addTag(this_, tag);
}

StaticList<String> Event_get_tags(dynamic this__) {
  final this_ = this__ as EventValue;
  return Tagged_get_tags(this_);
}


class ImportantEventValue extends ImportantEvent_Event_LoggableValue {
  late Priority priority;
  ImportantEventValue() {
    vptr['get_timestamp'] = ImportantEvent_get_timestamp;
    vptr['get_timeStr'] = ImportantEvent_get_timeStr;
    vptr['addTag'] = ImportantEvent_addTag;
    vptr['get_tags'] = ImportantEvent_get_tags;
    vptr['toString'] = ImportantEvent_toString;
    vptr['get_logTag'] = ImportantEvent_get_logTag;
    vptr['log'] = ImportantEvent_log;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (priority is AnyGC) (priority as AnyGC).gcMark(flag);
  }
}

ImportantEventValue ImportantEvent_new(dynamic this__, String name, Priority priority) {
  final this_ = this__ as ImportantEventValue;
  Event_new(this_, name);
  this_.priority = priority;
  return this_;
}

String ImportantEvent_get_logTag(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent';
}

String ImportantEvent_toString(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent(${this_.name}, ${Priority_toString(this_.priority)}, ${(this_.vptr['get_timeStr'] as String Function(dynamic))(this_)})';
}

int ImportantEvent_get_timestamp(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return Timestamped_get_timestamp(this_);
}

String ImportantEvent_get_timeStr(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return Timestamped_get_timeStr(this_);
}

void ImportantEvent_addTag(dynamic this__, String tag) {
  final this_ = this__ as ImportantEventValue;
  Tagged_addTag(this_, tag);
}

StaticList<String> ImportantEvent_get_tags(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return Tagged_get_tags(this_);
}

void ImportantEvent_log(dynamic this__, String message) {
  final this_ = this__ as ImportantEventValue;
  Loggable_log(this_, message);
}


class Dog_Animal_PrintableValue extends AnimalValue {
  Dog_Animal_PrintableValue() {
    vptr['printInfo'] = Printable_printInfo;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Dog_Animal_Printable_OrderableValue extends Dog_Animal_PrintableValue {
  Dog_Animal_Printable_OrderableValue() {
    vptr['isLessThan'] = Orderable_isLessThan<DogValue>;
    vptr['isGreaterThan'] = Orderable_isGreaterThan<DogValue>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Cat_Animal_PrintableValue extends AnimalValue {
  Cat_Animal_PrintableValue() {
    vptr['printInfo'] = Printable_printInfo;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class LoggedDataPoint_DataPoint_LoggableValue extends DataPointValue {
  LoggedDataPoint_DataPoint_LoggableValue() {
    vptr['log'] = Loggable_log;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class LoggedDataPoint_DataPoint_Loggable_ValidatableValue extends LoggedDataPoint_DataPoint_LoggableValue {
  LoggedDataPoint_DataPoint_Loggable_ValidatableValue() {
    vptr['validate'] = Validatable_validate;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Event_Object_TimestampedValue extends VPtr {
  Event_Object_TimestampedValue() {
    vptr['get_timestamp'] = Timestamped_get_timestamp;
    vptr['get_timeStr'] = Timestamped_get_timeStr;
  }
}


class Event_Object_Timestamped_TaggedValue extends Event_Object_TimestampedValue {
  late StaticList<String> _tags = StaticList<String>.of([]);
  Event_Object_Timestamped_TaggedValue() {
    vptr['addTag'] = Tagged_addTag;
    vptr['get_tags'] = Tagged_get_tags;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_tags is AnyGC) (_tags as AnyGC).gcMark(flag);
  }
}


class ImportantEvent_Event_LoggableValue extends EventValue {
  ImportantEvent_Event_LoggableValue() {
    vptr['log'] = Loggable_log;
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
  final String query = ((() { final _let7 = params; return (_let7 == null) ? null : _let7.entries.map(ClosureEnv_buildQuery_1_new(GC.allocateLocal(ClosureEnv_buildQuery_1()))).join('&'); })() ?? '');
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
  return (() {   late String _v8;
  final Object? _v9 = value;
  do {
{
{
        if ((_v9 == null)) {
          _v8 = 'null';
          break;
        }
      }
{
        late int n;
        if ((((_v9 is int) && (() { final _let10 = n = _v9; return true; })()) && (n < 0))) {
          _v8 = 'negative int: ${n}';
          break;
        }
      }
{
        late int n;
        if ((_v9 is int)) {
          n = _v9;
          _v8 = 'positive int: ${n}';
          break;
        }
      }
{
        late String s;
        if ((((_v9 is String) && (() { final _let11 = s = _v9; return true; })()) && s.isEmpty)) {
          _v8 = 'empty string';
          break;
        }
      }
{
        late String s;
        if ((_v9 is String)) {
          s = _v9;
          _v8 = 'string: "${s}"';
          break;
        }
      }
{
        late StaticList<dynamic> list;
        if ((((_v9 is StaticList<dynamic>) && (() { final _let12 = list = _v9; return true; })()) && list.isEmpty)) {
          _v8 = 'empty list';
          break;
        }
      }
{
        late StaticList<dynamic> list;
        if ((_v9 is StaticList<dynamic>)) {
          list = _v9;
          _v8 = 'list of ${list.length}';
          break;
        }
      }
{
        if (true) {
          _v8 = 'unknown: ${value.runtimeType}';
          break;
        }
      }
    }
  } while (false);
 return _v8; })();
}

StaticList<int> buildList() {
  return (StaticList<int>.of([])..add(1)..add(2)..addAll(StaticList<int>.of([3, 4, 5]))..sort());
}

StaticStringBuffer buildBuffer() {
  return (StaticStringBuffer()..write('Hello')..write(', ')..write('World')..writeln('!'));
}

StaticList<int> mergeAndFilter(StaticList<int> a, StaticList<int> b, bool includeNegative) {
  return (() {   final StaticList<int> _v15 = StaticList<int>.of(a);
  _v15.addAll(b);
  if (includeNegative)   _v15.add((-1));
  for (var i = 10; (i <= 12); i = (i + 1))   _v15.add(i);
 return _v15; })();
}

StaticMap<String, int> buildScoreMap(StaticList<String> names, bool addBonus) {
  return (() {   final StaticMap<String, int> _v16 = StaticMap<String, int>.of({});
  for (var i = 0; (i < names.length); i = (i + 1))   _v16[names[i]] = ((i + 1) * 10);
  if (addBonus)   _v16['bonus'] = 999;
 return _v16; })();
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
  for (final item in items) {
    if ((item.compareTo(maxItem) > 0)) {
      maxItem = item;
    }
  }
  return maxItem;
}

R applyTwice<T, R>(T value, TypeFunction1<R, T> fn1, TypeFunction1<R, R> fn2) {
  return fn2.closureCall(fn2, fn1.closureCall(fn1, value));
}

String? findFirst(StaticList<String> items, TypeFunction1<bool, String> test) {
  for (final item in items) {
    if (test.closureCall(test, item))     return item;
  }
  return null;
}

StaticList<int> filterWithForIn(StaticList<int> items) {
  final StaticList<int> result = StaticList<int>.of([]);
  for (final item in items) {
    if (((item >= 0) && (item <= 100))) {
      result.add(item);
    }
  }
  return result;
}

int collatzSteps(int n) {
  int steps = 0;
  do {
    do {
      if ((n == 1))       break;
      if (((n % 2) == 0)) {
        n = (n ~/ 2);
      }
 else {
        n = ((3 * n) + 1);
      }
      steps = (steps + 1);
    }
 while (!((n == 1)));
  } while (false);
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
  do {
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
  (dog1.vptr['printInfo'] as void Function(dynamic))(dog1);
  staticPrint('${(dog1.vptr['speak'] as String Function(dynamic))(dog1)} (${dog1.breed})');
  staticPrint('dog1 < dog2: ${(dog1.vptr['isLessThan'] as bool Function(dynamic, DogValue))(dog1, dog2)}');
  staticPrint('dog1 > dog2: ${(dog1.vptr['isGreaterThan'] as bool Function(dynamic, DogValue))(dog1, dog2)}');
  final CatValue cat = Cat_new(GC.allocateLocal(CatValue()), 'Whiskers', 2);
  (cat.vptr['printInfo'] as void Function(dynamic))(cat);
  staticPrint('${(cat.vptr['speak'] as String Function(dynamic))(cat)}, mood: ${(cat.vptr['get_mood'] as String Function(dynamic))(cat)}');
  (cat.vptr['set_mood'] as void Function(dynamic, String))(cat, 'sleepy');
  staticPrint('mood after set: ${(cat.vptr['get_mood'] as String Function(dynamic))(cat)}');
  staticPrint('\n--- 2. operator 重载 ---');
  final Vector2DValue sum = (() { final _r17 = Vector2D_new(Vector2DValue(), 3.0, 4.0); return (_r17.vptr['operatorPlus'] as Vector2DValue Function(dynamic, Vector2DValue))(_r17, Vector2D_new(Vector2DValue(), 1.0, 2.0)); })();
  final Vector2DValue diff = (() { final _r18 = Vector2D_new(Vector2DValue(), 3.0, 4.0); return (_r18.vptr['operatorMinus'] as Vector2DValue Function(dynamic, Vector2DValue))(_r18, Vector2D_new(Vector2DValue(), 1.0, 2.0)); })();
  final Vector2DValue scaled = (() { final _r19 = Vector2D_new(Vector2DValue(), 3.0, 4.0); return (_r19.vptr['operatorStar'] as Vector2DValue Function(dynamic, double))(_r19, 2.0); })();
  staticPrint('v1 + v2 = ${sum}');
  staticPrint('v1 - v2 = ${diff}');
  staticPrint('v1 * 2 = ${scaled}');
  staticPrint('v1.length = ${(() { final _r20 = Vector2D_new(Vector2DValue(), 3.0, 4.0); return (_r20.vptr['get_length'] as double Function(dynamic))(_r20); })().toStringAsFixed(2)}');
  staticPrint('v1 == Vector2D(3,4): ${(Vector2D_new(Vector2DValue(), 3.0, 4.0) == Vector2D_new(Vector2DValue(), 3.0, 4.0))}');
  staticPrint('\n--- 3. static + factory ---');
  final CounterValue c1 = Counter_new('alpha');
  final CounterValue c2 = Counter_new('beta', initialValue: 50);
  final CounterValue c3 = Counter_new_fromString('gamma:25');
  (c1.vptr['increment'] as void Function(dynamic, int))(c1, 10);
  (c2.vptr['decrement'] as void Function(dynamic, int))(c2, 5);
  (c3.vptr['increment'] as void Function(dynamic, int))(c3, 1);
  staticPrint('${c1}, ${c2}, ${c3}');
  staticPrint('instances: ${Counter_instanceCount()}');
  staticPrint('maxValue: 100');
  staticPrint('\n--- 4. Result<T> + named params ---');
  staticPrint('ok: ${Result_new_success<int>(ResultValue<int>(), 42)}');
  staticPrint('err: ${Result_new_failure<int>(ResultValue<int>(), 'not found')}');
  final String okMsg = (() { final _r21 = Result_new_success<int>(ResultValue<int>(), 42); return (_r21.vptr['fold_String'] as String Function(dynamic, TypeFunction1<String, int>, TypeFunction1<String, String>))(_r21, ClosureEnv_main_7_new(GC.allocateLocal(ClosureEnv_main_7())), ClosureEnv_main_8_new(GC.allocateLocal(ClosureEnv_main_8()))); })();
  final String errMsg = (() { final _r22 = Result_new_failure<int>(ResultValue<int>(), 'not found'); return (_r22.vptr['fold_String'] as String Function(dynamic, TypeFunction1<String, int>, TypeFunction1<String, String>))(_r22, ClosureEnv_main_11_new(GC.allocateLocal(ClosureEnv_main_11())), ClosureEnv_main_12_new(GC.allocateLocal(ClosureEnv_main_12()))); })();
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
    final (int, int) _v9 = divmod(17, 5);
    q = _v9.$1;
    r2 = _v9.$2;
  }
  staticPrint('divmod(17,5): quotient=${q}, remainder=${r2}');
  staticPrint('\n--- 9. pattern matching ---');
  final StaticList<Object?> values = StaticList<Object?>.of([null, (-5), 42, '', 'hello', StaticList<int>.of([]), StaticList<int>.of([1, 2, 3])]);
  for (final v in values) {
    staticPrint('  ${describeValue(v)}');
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
  staticPrint('before init: ${(loader.vptr['get_data'] as String Function(dynamic))(loader)}, ${(loader.vptr['get_computedValue'] as int Function(dynamic))(loader)}');
  (loader.vptr['initialize'] as void Function(dynamic, String))(loader, 'hello');
  staticPrint('after init: ${(loader.vptr['get_data'] as String Function(dynamic))(loader)}, ${(loader.vptr['get_computedValue'] as int Function(dynamic))(loader)}');
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
  (bv.vptr['set'] as void Function(dynamic, double))(bv, 7.5);
  staticPrint('BoundedValue: ${(bv.vptr['get_current'] as double Function(dynamic))(bv)}');
  staticPrint('\n--- 15. 字符串 ---');
  staticPrint(multiLineExample());
  staticPrint('\n--- 16. typedef + 函数式组合 ---');
  final TypeFunction1<String, int> doubleIt = compose<int, int, String>(ClosureEnv_main_13_new(GC.allocateLocal(ClosureEnv_main_13())), ClosureEnv_main_14_new(GC.allocateLocal(ClosureEnv_main_14())));
  staticPrint('compose(5): ${doubleIt.closureCall(doubleIt, 5)}');
  final TypeFunction1<bool, int> isPositive = ClosureEnv_main_15_new(GC.allocateLocal(ClosureEnv_main_15()));
  final TypeFunction1<bool, int> isEven = ClosureEnv_main_16_new(GC.allocateLocal(ClosureEnv_main_16()));
  final TypeFunction1<bool, int> isPositiveEven = and<int>(isPositive, isEven);
  final StaticList<int> nums = StaticList<int>.of([(-2), (-1), 0, 1, 2, 3, 4]);
  staticPrint('positiveEvens: ${StaticList.of(nums.where(isPositiveEven).toList())}');
  final StaticList<int> nested = StaticList<int>.of(flatMap<int, int>(StaticList<int>.of([1, 2, 3]), ClosureEnv_main_17_new(GC.allocateLocal(ClosureEnv_main_17()))));
  staticPrint('flatMap: ${nested}');
  staticPrint('\n--- 19. 多层继承链 ---');
  final ShapeValue shape = Shape_new(GC.allocateLocal(ShapeValue()), 'red');
  staticPrint((shape.vptr['describe'] as String Function(dynamic))(shape));
  final ShapeValue transparentShape = Shape_new_transparent(GC.allocateLocal(ShapeValue()), 'blue');
  staticPrint((transparentShape.vptr['describe'] as String Function(dynamic))(transparentShape));
  final PolygonValue polygon = Polygon_new(GC.allocateLocal(PolygonValue()), 'green', 6, opacity: 0.8);
  staticPrint((polygon.vptr['describe'] as String Function(dynamic))(polygon));
  staticPrint('perimeter: ${(polygon.vptr['perimeter'] as double Function(dynamic, double))(polygon, 3.0)}');
  final RegularPolygonValue hexagon = RegularPolygon_new(GC.allocateLocal(RegularPolygonValue()), 'yellow', 6, 5.0);
  staticPrint((hexagon.vptr['describe'] as String Function(dynamic))(hexagon));
  staticPrint('perimeter: ${(hexagon.vptr['perimeter'] as double Function(dynamic, double?))(hexagon, null)}');
  staticPrint('area: ${(hexagon.vptr['area'] as double Function(dynamic))(hexagon)}');
  final SquareValue square = Square_new(GC.allocateLocal(SquareValue()), 'white', 10.0, opacity: 0.9);
  staticPrint((square.vptr['describe'] as String Function(dynamic))(square));
  staticPrint('square perimeter: ${(square.vptr['perimeter'] as double Function(dynamic, double?))(square, null)}');
  staticPrint('\n--- 20. implements 多接口 ---');
  final DataPointValue dp1 = DataPoint_new(GC.allocateLocal(DataPointValue()), 1.0, 2.0, 'A');
  final DataPointValue dp2 = DataPoint_new(GC.allocateLocal(DataPointValue()), 3.0, 1.0, 'B');
  staticPrint('dp1: ${dp1}');
  staticPrint('dp1.serialize: ${(dp1.vptr['serialize'] as String Function(dynamic))(dp1)}');
  final DataPointValue dp1Clone = (dp1.vptr['clone'] as DataPointValue Function(dynamic))(dp1);
  staticPrint('dp1.clone: ${dp1Clone}');
  staticPrint('dp1.compareTo2(dp2): ${(dp1.vptr['compareTo2'] as int Function(dynamic, DataPointValue))(dp1, dp2)}');
  staticPrint('\n--- 21. mixin on 约束 ---');
  final LoggedDataPointValue ldp = LoggedDataPoint_new(GC.allocateLocal(LoggedDataPointValue()), 5.0, 6.0, 'logged');
  (ldp.vptr['log'] as void Function(dynamic, String))(ldp, 'created');
  staticPrint('validate: ${(ldp.vptr['validate'] as bool Function(dynamic))(ldp)}');
  staticPrint('serialize: ${(ldp.vptr['serialize'] as String Function(dynamic))(ldp)}');
  staticPrint('\n--- 22. 增强枚举 ---');
  staticPrint('Priority.high: ${Priority}.high');
  staticPrint('high > medium: ${Priority_isHigherThan(Priority.high, Priority.medium)}');
  staticPrint('low > high: ${Priority_isHigherThan(Priority.low, Priority.high)}');
  for (final p in const [Priority.low, Priority.medium, Priority.high, Priority.critical]) {
    staticPrint('  ${Priority_toString(p)}');
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
  staticPrint('\n--- 24. 泛型约束 ---');
  final SortedListValue<int> sortedList = SortedList_new<int>(GC.allocateLocal(SortedListValue<int>()));
  (sortedList.vptr['add'] as void Function(dynamic, int))(sortedList, 5);
  (sortedList.vptr['add'] as void Function(dynamic, int))(sortedList, 1);
  (sortedList.vptr['add'] as void Function(dynamic, int))(sortedList, 3);
  (sortedList.vptr['add'] as void Function(dynamic, int))(sortedList, 2);
  staticPrint('sorted: ${sortedList}');
  staticPrint('first: ${(sortedList.vptr['get_first'] as int Function(dynamic))(sortedList)}, last: ${(sortedList.vptr['get_last'] as int Function(dynamic))(sortedList)}');
  final int maxVal = findMax<int>(StaticList<int>.of([3, 7, 1, 9, 4]));
  staticPrint('findMax: ${maxVal}');
  final String result = applyTwice<int, String>(5, ClosureEnv_main_18_new(GC.allocateLocal(ClosureEnv_main_18())), ClosureEnv_main_19_new(GC.allocateLocal(ClosureEnv_main_19())));
  staticPrint('applyTwice: ${result}');
  staticPrint('\n--- 25. null safety ---');
  final NullSafetyDemoValue ns1 = NullSafetyDemo_new(GC.allocateLocal(NullSafetyDemoValue()), 'hello', 'world');
  staticPrint('ns1: ${(ns1.vptr['demonstrate'] as String Function(dynamic))(ns1)}');
  final NullSafetyDemoValue ns2 = NullSafetyDemo_new(GC.allocateLocal(NullSafetyDemoValue()), 'hello');
  staticPrint('ns2: ${(ns2.vptr['demonstrate'] as String Function(dynamic))(ns2)}');
  final String? found = findFirst(StaticList<String>.of(['apple', 'banana', 'cherry']), ClosureEnv_main_20_new(GC.allocateLocal(ClosureEnv_main_20())));
  staticPrint('findFirst(b): ${found}');
  final String? notFound = findFirst(StaticList<String>.of(['apple', 'banana']), ClosureEnv_main_21_new(GC.allocateLocal(ClosureEnv_main_21())));
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
  staticPrint('renderer: ${(renderer.vptr['get_name'] as String Function(dynamic))(renderer)}');
  (renderer.vptr['render'] as void Function(dynamic, String))(renderer, 'circle');
  staticPrint('\n--- 30. Pipeline 泛型链 ---');
  final PipelineValue<int, String> pipeline = (() { final _r24 = (() { final _r23 = Pipeline_new<int, String>(GC.allocateLocal(PipelineValue<int, String>()), ClosureEnv_main_22_new(GC.allocateLocal(ClosureEnv_main_22()))); return (_r23.vptr['then_int'] as PipelineValue<int, int> Function(dynamic, TypeFunction1<int, String>))(_r23, ClosureEnv_main_24_new(GC.allocateLocal(ClosureEnv_main_24()))); })(); return (_r24.vptr['then_String'] as PipelineValue<int, String> Function(dynamic, TypeFunction1<String, int>))(_r24, ClosureEnv_main_26_new(GC.allocateLocal(ClosureEnv_main_26()))); })();
  staticPrint('pipeline(42): ${(pipeline.vptr['execute'] as String Function(dynamic, int))(pipeline, 42)}');
  staticPrint('pipeline(12345): ${(pipeline.vptr['execute'] as String Function(dynamic, int))(pipeline, 12345)}');
  staticPrint('\n--- 31. switch-case ---');
  staticPrint('day 1: ${dayType(1)}');
  staticPrint('day 3: ${dayType(3)}');
  staticPrint('day 7: ${dayType(7)}');
  staticPrint('day 9: ${dayType(9)}');
  staticPrint('\n--- 32. 位运算 ---');
  final BitFlagsValue flags = BitFlags_new(GC.allocateLocal(BitFlagsValue()));
  (flags.vptr['set'] as void Function(dynamic, int))(flags, 1);
  (flags.vptr['set'] as void Function(dynamic, int))(flags, 4);
  staticPrint('flags: ${flags}');
  staticPrint('has read: ${(flags.vptr['has'] as bool Function(dynamic, int))(flags, 1)}');
  staticPrint('has write: ${(flags.vptr['has'] as bool Function(dynamic, int))(flags, 2)}');
  (flags.vptr['set'] as void Function(dynamic, int))(flags, 2);
  staticPrint('after set write: ${flags}');
  (flags.vptr['clear'] as void Function(dynamic, int))(flags, 4);
  staticPrint('after clear execute: ${flags}');
  staticPrint('\n--- 33. 多层 mixin ---');
  final EventValue event = Event_new(GC.allocateLocal(EventValue()), 'meeting');
  (event.vptr['addTag'] as void Function(dynamic, String))(event, 'work');
  (event.vptr['addTag'] as void Function(dynamic, String))(event, 'important');
  staticPrint(event);
  final ImportantEventValue impEvent = ImportantEvent_new(GC.allocateLocal(ImportantEventValue()), 'deadline', Priority.critical);
  (impEvent.vptr['addTag'] as void Function(dynamic, String))(impEvent, 'urgent');
  (impEvent.vptr['log'] as void Function(dynamic, String))(impEvent, 'created');
  staticPrint(impEvent);
  staticPrint('\n=== 所有测试通过 ✅ ===');
}

class ClosureEnv_anon_0<TNewOutput, TOutput, TInput> extends TypeFunction1<TNewOutput, TInput> {
  late PipelineValue<TInput, TOutput> this_;
  late TypeFunction1<TNewOutput, TOutput> next;
  ClosureEnv_anon_0();
  @override
  TNewOutput call(TInput input) => closureCall(this, input);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
    if (next is AnyGC) (next as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_0<TNewOutput, TOutput, TInput> ClosureEnv_anon_0_new<TNewOutput, TOutput, TInput>(ClosureEnv_anon_0<TNewOutput, TOutput, TInput> env_, PipelineValue<TInput, TOutput> this_, TypeFunction1<TNewOutput, TOutput> next) {
  env_.closureCall = ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>;
  env_.this_ = this_;
  env_.next = next;
  return env_;
}
TNewOutput ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>(dynamic env__, TInput input) {
  final env = env__ as ClosureEnv_anon_0<TNewOutput, TOutput, TInput>;

  return env.next.closureCall(env.next, (() { final _let5 = input; return env.this_._transform.closureCall(env.this_._transform, _let5); })());
}

class ClosureEnv_buildQuery_1 extends TypeFunction1<String, StaticMapEntry<String, String>> {
  ClosureEnv_buildQuery_1();
  @override
  String call(StaticMapEntry<String, String> e) => closureCall(this, e);
}
ClosureEnv_buildQuery_1 ClosureEnv_buildQuery_1_new(ClosureEnv_buildQuery_1 env_) {
  env_.closureCall = ClosureEnv_buildQuery_1_call;
  return env_;
}
String ClosureEnv_buildQuery_1_call(dynamic env__, StaticMapEntry<String, String> e) {
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
  final StaticList<String> result = StaticList<String>.of([]);
  for (var i = env.from.value; (i >= 0); i = (i - 1)) {
    smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 1)));
    result.add(((i == 0) ? 'Go!' : '${i}...'));
  }
{
    env._promise.complete(result);
    return;
  }
  env._promise.complete(null as dynamic);
  return;
}
class ClosureEnv_compose_3<C, B, A> extends TypeFunction1<C, A> {
  late TypeFunction1<C, B> g;
  late TypeFunction1<B, A> f;
  ClosureEnv_compose_3();
  @override
  C call(A input) => closureCall(this, input);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (g is AnyGC) (g as AnyGC).gcMark(flag);
    if (f is AnyGC) (f as AnyGC).gcMark(flag);
  }
}
ClosureEnv_compose_3<C, B, A> ClosureEnv_compose_3_new<C, B, A>(ClosureEnv_compose_3<C, B, A> env_, TypeFunction1<C, B> g, TypeFunction1<B, A> f) {
  env_.closureCall = ClosureEnv_compose_3_call<C, B, A>;
  env_.g = g;
  env_.f = f;
  return env_;
}
C ClosureEnv_compose_3_call<C, B, A>(dynamic env__, A input) {
  final env = env__ as ClosureEnv_compose_3<C, B, A>;

  return env.g.closureCall(env.g, env.f.closureCall(env.f, input));
}

class ClosureEnv_and_4<T> extends TypeFunction1<bool, T> {
  late TypeFunction1<bool, T> p1;
  late TypeFunction1<bool, T> p2;
  ClosureEnv_and_4();
  @override
  bool call(T value) => closureCall(this, value);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (p1 is AnyGC) (p1 as AnyGC).gcMark(flag);
    if (p2 is AnyGC) (p2 as AnyGC).gcMark(flag);
  }
}
ClosureEnv_and_4<T> ClosureEnv_and_4_new<T>(ClosureEnv_and_4<T> env_, TypeFunction1<bool, T> p1, TypeFunction1<bool, T> p2) {
  env_.closureCall = ClosureEnv_and_4_call<T>;
  env_.p1 = p1;
  env_.p2 = p2;
  return env_;
}
bool ClosureEnv_and_4_call<T>(dynamic env__, T value) {
  final env = env__ as ClosureEnv_and_4<T>;

  return (env.p1.closureCall(env.p1, value) && env.p2.closureCall(env.p2, value));
}

class ClosureEnv_main_5 extends TypeFunction1<String, int> {
  ClosureEnv_main_5();
  @override
  String call(int d) => closureCall(this, d);
}
ClosureEnv_main_5 ClosureEnv_main_5_new(ClosureEnv_main_5 env_) {
  env_.closureCall = ClosureEnv_main_5_call;
  return env_;
}
String ClosureEnv_main_5_call(dynamic env__, int d) {
  final env = env__ as ClosureEnv_main_5;

  return 'got ${d}';
}

class ClosureEnv_main_6 extends TypeFunction1<String, String> {
  ClosureEnv_main_6();
  @override
  String call(String e) => closureCall(this, e);
}
ClosureEnv_main_6 ClosureEnv_main_6_new(ClosureEnv_main_6 env_) {
  env_.closureCall = ClosureEnv_main_6_call;
  return env_;
}
String ClosureEnv_main_6_call(dynamic env__, String e) {
  final env = env__ as ClosureEnv_main_6;

  return 'error: ${e}';
}

class ClosureEnv_main_7 extends TypeFunction1<String, int> {
  ClosureEnv_main_7();
  @override
  String call(int d) => closureCall(this, d);
}
ClosureEnv_main_7 ClosureEnv_main_7_new(ClosureEnv_main_7 env_) {
  env_.closureCall = ClosureEnv_main_7_call;
  return env_;
}
String ClosureEnv_main_7_call(dynamic env__, int d) {
  final env = env__ as ClosureEnv_main_7;

  return 'got ${d}';
}

class ClosureEnv_main_8 extends TypeFunction1<String, String> {
  ClosureEnv_main_8();
  @override
  String call(String e) => closureCall(this, e);
}
ClosureEnv_main_8 ClosureEnv_main_8_new(ClosureEnv_main_8 env_) {
  env_.closureCall = ClosureEnv_main_8_call;
  return env_;
}
String ClosureEnv_main_8_call(dynamic env__, String e) {
  final env = env__ as ClosureEnv_main_8;

  return 'error: ${e}';
}

class ClosureEnv_main_9 extends TypeFunction1<String, int> {
  ClosureEnv_main_9();
  @override
  String call(int d) => closureCall(this, d);
}
ClosureEnv_main_9 ClosureEnv_main_9_new(ClosureEnv_main_9 env_) {
  env_.closureCall = ClosureEnv_main_9_call;
  return env_;
}
String ClosureEnv_main_9_call(dynamic env__, int d) {
  final env = env__ as ClosureEnv_main_9;

  return 'got ${d}';
}

class ClosureEnv_main_10 extends TypeFunction1<String, String> {
  ClosureEnv_main_10();
  @override
  String call(String e) => closureCall(this, e);
}
ClosureEnv_main_10 ClosureEnv_main_10_new(ClosureEnv_main_10 env_) {
  env_.closureCall = ClosureEnv_main_10_call;
  return env_;
}
String ClosureEnv_main_10_call(dynamic env__, String e) {
  final env = env__ as ClosureEnv_main_10;

  return 'error: ${e}';
}

class ClosureEnv_main_11 extends TypeFunction1<String, int> {
  ClosureEnv_main_11();
  @override
  String call(int d) => closureCall(this, d);
}
ClosureEnv_main_11 ClosureEnv_main_11_new(ClosureEnv_main_11 env_) {
  env_.closureCall = ClosureEnv_main_11_call;
  return env_;
}
String ClosureEnv_main_11_call(dynamic env__, int d) {
  final env = env__ as ClosureEnv_main_11;

  return 'got ${d}';
}

class ClosureEnv_main_12 extends TypeFunction1<String, String> {
  ClosureEnv_main_12();
  @override
  String call(String e) => closureCall(this, e);
}
ClosureEnv_main_12 ClosureEnv_main_12_new(ClosureEnv_main_12 env_) {
  env_.closureCall = ClosureEnv_main_12_call;
  return env_;
}
String ClosureEnv_main_12_call(dynamic env__, String e) {
  final env = env__ as ClosureEnv_main_12;

  return 'error: ${e}';
}

class ClosureEnv_main_13 extends TypeFunction1<int, int> {
  ClosureEnv_main_13();
  @override
  int call(int x) => closureCall(this, x);
}
ClosureEnv_main_13 ClosureEnv_main_13_new(ClosureEnv_main_13 env_) {
  env_.closureCall = ClosureEnv_main_13_call;
  return env_;
}
int ClosureEnv_main_13_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_13;

  return (x * 2);
}

class ClosureEnv_main_14 extends TypeFunction1<String, int> {
  ClosureEnv_main_14();
  @override
  String call(int x) => closureCall(this, x);
}
ClosureEnv_main_14 ClosureEnv_main_14_new(ClosureEnv_main_14 env_) {
  env_.closureCall = ClosureEnv_main_14_call;
  return env_;
}
String ClosureEnv_main_14_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_14;

  return 'result=${x}';
}

class ClosureEnv_main_15 extends TypeFunction1<bool, int> {
  ClosureEnv_main_15();
  @override
  bool call(int n) => closureCall(this, n);
}
ClosureEnv_main_15 ClosureEnv_main_15_new(ClosureEnv_main_15 env_) {
  env_.closureCall = ClosureEnv_main_15_call;
  return env_;
}
bool ClosureEnv_main_15_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_main_15;

  return (n > 0);
}

class ClosureEnv_main_16 extends TypeFunction1<bool, int> {
  ClosureEnv_main_16();
  @override
  bool call(int n) => closureCall(this, n);
}
ClosureEnv_main_16 ClosureEnv_main_16_new(ClosureEnv_main_16 env_) {
  env_.closureCall = ClosureEnv_main_16_call;
  return env_;
}
bool ClosureEnv_main_16_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_main_16;

  return ((n % 2) == 0);
}

class ClosureEnv_main_17 extends TypeFunction1<StaticList<int>, int> {
  ClosureEnv_main_17();
  @override
  StaticList<int> call(int x) => closureCall(this, x);
}
ClosureEnv_main_17 ClosureEnv_main_17_new(ClosureEnv_main_17 env_) {
  env_.closureCall = ClosureEnv_main_17_call;
  return env_;
}
StaticList<int> ClosureEnv_main_17_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_17;

  return StaticList<int>.of([x, (x * x)]);
}

class ClosureEnv_main_18 extends TypeFunction1<String, int> {
  ClosureEnv_main_18();
  @override
  String call(int x) => closureCall(this, x);
}
ClosureEnv_main_18 ClosureEnv_main_18_new(ClosureEnv_main_18 env_) {
  env_.closureCall = ClosureEnv_main_18_call;
  return env_;
}
String ClosureEnv_main_18_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_18;

  return 'n=${x}';
}

class ClosureEnv_main_19 extends TypeFunction1<String, String> {
  ClosureEnv_main_19();
  @override
  String call(String s) => closureCall(this, s);
}
ClosureEnv_main_19 ClosureEnv_main_19_new(ClosureEnv_main_19 env_) {
  env_.closureCall = ClosureEnv_main_19_call;
  return env_;
}
String ClosureEnv_main_19_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_19;

  return '${s}!';
}

class ClosureEnv_main_20 extends TypeFunction1<bool, String> {
  ClosureEnv_main_20();
  @override
  bool call(String s) => closureCall(this, s);
}
ClosureEnv_main_20 ClosureEnv_main_20_new(ClosureEnv_main_20 env_) {
  env_.closureCall = ClosureEnv_main_20_call;
  return env_;
}
bool ClosureEnv_main_20_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_20;

  return s.startsWith('b');
}

class ClosureEnv_main_21 extends TypeFunction1<bool, String> {
  ClosureEnv_main_21();
  @override
  bool call(String s) => closureCall(this, s);
}
ClosureEnv_main_21 ClosureEnv_main_21_new(ClosureEnv_main_21 env_) {
  env_.closureCall = ClosureEnv_main_21_call;
  return env_;
}
bool ClosureEnv_main_21_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_21;

  return s.startsWith('z');
}

class ClosureEnv_main_22 extends TypeFunction1<String, int> {
  ClosureEnv_main_22();
  @override
  String call(int n) => closureCall(this, n);
}
ClosureEnv_main_22 ClosureEnv_main_22_new(ClosureEnv_main_22 env_) {
  env_.closureCall = ClosureEnv_main_22_call;
  return env_;
}
String ClosureEnv_main_22_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_main_22;

  return 'val=${n}';
}

class ClosureEnv_main_23 extends TypeFunction1<int, String> {
  ClosureEnv_main_23();
  @override
  int call(String s) => closureCall(this, s);
}
ClosureEnv_main_23 ClosureEnv_main_23_new(ClosureEnv_main_23 env_) {
  env_.closureCall = ClosureEnv_main_23_call;
  return env_;
}
int ClosureEnv_main_23_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_23;

  return s.length;
}

class ClosureEnv_main_24 extends TypeFunction1<int, String> {
  ClosureEnv_main_24();
  @override
  int call(String s) => closureCall(this, s);
}
ClosureEnv_main_24 ClosureEnv_main_24_new(ClosureEnv_main_24 env_) {
  env_.closureCall = ClosureEnv_main_24_call;
  return env_;
}
int ClosureEnv_main_24_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_24;

  return s.length;
}

class ClosureEnv_main_25 extends TypeFunction1<String, int> {
  ClosureEnv_main_25();
  @override
  String call(int len) => closureCall(this, len);
}
ClosureEnv_main_25 ClosureEnv_main_25_new(ClosureEnv_main_25 env_) {
  env_.closureCall = ClosureEnv_main_25_call;
  return env_;
}
String ClosureEnv_main_25_call(dynamic env__, int len) {
  final env = env__ as ClosureEnv_main_25;

  return 'len=${len}';
}

class ClosureEnv_main_26 extends TypeFunction1<String, int> {
  ClosureEnv_main_26();
  @override
  String call(int len) => closureCall(this, len);
}
ClosureEnv_main_26 ClosureEnv_main_26_new(ClosureEnv_main_26 env_) {
  env_.closureCall = ClosureEnv_main_26_call;
  return env_;
}
String ClosureEnv_main_26_call(dynamic env__, int len) {
  final env = env__ as ClosureEnv_main_26;

  return 'len=${len}';
}


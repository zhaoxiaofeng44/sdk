import 'package:dart2cpp/restorer/runtime_classes.dart';

typedef Predicate<T> = TypeFunction1<bool, T>;

typedef Transformer<A, B> = TypeFunction1<B, A>;

typedef VoidCallback = TypeFunction0<void>;

// mixin Printable → static functions for delegation
void Printable_printInfo(dynamic this__) {
  final this_ = this__;
  print('[${(this_.vptr['get_displayName'] as TypeFunction1<String, dynamic>)(this_)}]');
}


// mixin Orderable → static functions for delegation
bool Orderable_isLessThan<T>(dynamic this__, T other) {
  final this_ = this__;
  return ((this_.vptr['compareTo'] as TypeFunction2<int, dynamic, T>)(this_, other) < 0);
}

bool Orderable_isGreaterThan<T>(dynamic this__, T other) {
  final this_ = this__;
  return ((this_.vptr['compareTo'] as TypeFunction2<int, dynamic, T>)(this_, other) > 0);
}


class AnimalValue extends VPtr {
  late String name;
  late int age;
  AnimalValue() {
    vptr['speak'] = const _TearOff_Animal_speak();
    vptr['toString'] = const _TearOff_Animal_toString();
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
    vptr['speak'] = const _TearOff_Dog_speak();
    vptr['toString'] = const _TearOff_Dog_toString();
    vptr['get_displayName'] = const _TearOff_Dog_get_displayName();
    vptr['printInfo'] = const _TearOff_Dog_printInfo();
    vptr['compareTo'] = const _TearOff_Dog_compareTo();
    vptr['isLessThan'] = const _TearOff_Dog_isLessThan();
    vptr['isGreaterThan'] = const _TearOff_Dog_isGreaterThan();
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
  return Orderable_isLessThan<dynamic>(this_, other);
}

bool Dog_isGreaterThan(dynamic this__, DogValue other) {
  final this_ = this__ as DogValue;
  return Orderable_isGreaterThan<dynamic>(this_, other);
}


class CatValue extends Cat_Animal_PrintableValue {
  late String _mood;
  CatValue() {
    vptr['speak'] = const _TearOff_Cat_speak();
    vptr['toString'] = const _TearOff_Cat_toString();
    vptr['get_displayName'] = const _TearOff_Cat_get_displayName();
    vptr['printInfo'] = const _TearOff_Cat_printInfo();
    vptr['get_mood'] = const _TearOff_Cat_get_mood();
    vptr['set_mood'] = const _TearOff_Cat_set_mood();
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
    vptr['operatorPlus'] = const _TearOff_Vector2D_operatorPlus();
    vptr['operatorMinus'] = const _TearOff_Vector2D_operatorMinus();
    vptr['operatorStar'] = const _TearOff_Vector2D_operatorStar();
    vptr['operatorEq'] = const _TearOff_Vector2D_operatorEq();
    vptr['get_length'] = const _TearOff_Vector2D_get_length();
    vptr['toString'] = const _TearOff_Vector2D_toString();
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
    vptr['increment'] = const _TearOff_Counter_increment();
    vptr['decrement'] = const _TearOff_Counter_decrement();
    vptr['get_value'] = const _TearOff_Counter_get_value();
    vptr['toString'] = const _TearOff_Counter_toString();
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
  return Counter_new__(CounterValue(), label, initialValue);
}

CounterValue Counter_new_fromString(String spec) {
  final StaticList<String> parts = StaticList<String>.of(spec.split(':'));
  return Counter_new__(CounterValue(), parts[0], int.parse(parts[1]));
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
    vptr['toString'] = _TearOff_Result_toString<T>();
  }
}

ResultValue<T> Result_new_success<T>(dynamic this__, T value) {
  final this_ = this__ as ResultValue<T>;
  this_.vptr['fold_String'] = _TearOff_Result_fold_String<T>();
  this_.data = value;
  this_.error = null;
  this_.isSuccess = true;
  return this_;
}

ResultValue<T> Result_new_failure<T>(dynamic this__, String message) {
  final this_ = this__ as ResultValue<T>;
  this_.vptr['fold_String'] = _TearOff_Result_fold_String<T>();
  this_.data = null;
  this_.error = message;
  this_.isSuccess = false;
  return this_;
}

R Result_fold<T, R>(dynamic this__, TypeFunction1<R, T> onSuccess, TypeFunction1<R, String> onFailure) {
  final this_ = this__ as ResultValue<T>;
  if ((this_.isSuccess && !((this_.data == null)))) {
    return onSuccess((this_.data as T));
  }
  return onFailure((this_.error ?? 'Unknown error'));
}

String Result_toString<T>(dynamic this__) {
  final this_ = this__ as ResultValue<T>;
  return (this_.isSuccess ? 'Result.success(${this_.data})' : 'Result.failure(${this_.error})');
}


class LazyLoaderValue extends VPtr {
  late String _data;
  late int _computedValue;
  late bool _initialized;
  LazyLoaderValue() {
    vptr['initialize'] = const _TearOff_LazyLoader_initialize();
    vptr['get_data'] = const _TearOff_LazyLoader_get_data();
    vptr['get_computedValue'] = const _TearOff_LazyLoader_get_computedValue();
  }
}

LazyLoaderValue LazyLoader_new(dynamic this__) {
  final this_ = this__ as LazyLoaderValue;
  this_._initialized = false;
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
    vptr['set'] = const _TearOff_BoundedValue_set();
    vptr['get_current'] = const _TearOff_BoundedValue_get_current();
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
    vptr['describe'] = const _TearOff_Shape_describe();
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
    vptr['describe'] = const _TearOff_Polygon_describe();
    vptr['perimeter'] = const _TearOff_Polygon_perimeter();
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
    vptr['describe'] = const _TearOff_RegularPolygon_describe();
    vptr['perimeter'] = const _TearOff_RegularPolygon_perimeter();
    vptr['area'] = const _TearOff_RegularPolygon_area();
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
    vptr['describe'] = const _TearOff_Square_describe();
    vptr['perimeter'] = const _TearOff_Square_perimeter();
    vptr['area'] = const _TearOff_Square_area();
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
    vptr['serialize'] = const _TearOff_Serializable_serialize();
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
    vptr['clone'] = _TearOff_Cloneable_clone<T>();
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
    vptr['compareTo2'] = _TearOff_Comparable2_compareTo2<T>();
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
    vptr['serialize'] = const _TearOff_DataPoint_serialize();
    vptr['clone'] = const _TearOff_DataPoint_clone();
    vptr['compareTo2'] = const _TearOff_DataPoint_compareTo2();
    vptr['toString'] = const _TearOff_DataPoint_toString();
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
  print('[${(this_.vptr['get_logTag'] as TypeFunction1<String, dynamic>)(this_)}] ${message}');
}


// mixin Validatable → static functions for delegation
bool Validatable_validate(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['serialize'] as TypeFunction1<String, dynamic>)(this_).isNotEmpty;
}


class LoggedDataPointValue extends LoggedDataPoint_DataPoint_Loggable_ValidatableValue {
  LoggedDataPointValue() {
    vptr['serialize'] = const _TearOff_LoggedDataPoint_serialize();
    vptr['clone'] = const _TearOff_LoggedDataPoint_clone();
    vptr['compareTo2'] = const _TearOff_LoggedDataPoint_compareTo2();
    vptr['toString'] = const _TearOff_LoggedDataPoint_toString();
    vptr['get_logTag'] = const _TearOff_LoggedDataPoint_get_logTag();
    vptr['log'] = const _TearOff_LoggedDataPoint_log();
    vptr['validate'] = const _TearOff_LoggedDataPoint_validate();
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
    vptr['toString'] = const _TearOff_Config_toString();
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
  late StaticList<T> _items;
  SortedListValue() {
    vptr['add'] = _TearOff_SortedList_add<T>();
    vptr['get_first'] = _TearOff_SortedList_get_first<T>();
    vptr['get_last'] = _TearOff_SortedList_get_last<T>();
    vptr['get_length'] = _TearOff_SortedList_get_length<T>();
    vptr['toList'] = _TearOff_SortedList_toList<T>();
    vptr['toString'] = _TearOff_SortedList_toString<T>();
  }
}

SortedListValue<T> SortedList_new<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  this_._items = StaticList<T>();
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
    vptr['demonstrate'] = const _TearOff_NullSafetyDemo_demonstrate();
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
    vptr['render'] = const _TearOff_Renderer_render();
    vptr['get_name'] = const _TearOff_Renderer_get_name();
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
    vptr['render'] = const _TearOff_CircleRenderer_render();
    vptr['get_name'] = const _TearOff_CircleRenderer_get_name();
  }
}

CircleRendererValue CircleRenderer_new(dynamic this__) {
  final this_ = this__ as CircleRendererValue;
  Renderer_new(this_);
  return this_;
}

void CircleRenderer_render(dynamic this__, String shape) {
  final this_ = this__ as CircleRendererValue;
  print('  CircleRenderer: drawing ${shape}');
}

String CircleRenderer_get_name(dynamic this__) {
  final this_ = this__ as CircleRendererValue;
  return 'CircleRenderer';
}


class PipelineValue<TInput, TOutput> extends VPtr {
  late TypeFunction1<TOutput, TInput> _transform;
  PipelineValue() {
    vptr['execute'] = _TearOff_Pipeline_execute<TInput, TOutput>();
  }
}

PipelineValue<TInput, TOutput> Pipeline_new<TInput, TOutput>(dynamic this__, TypeFunction1<TOutput, TInput> _transform) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  this_.vptr['then_String'] = _TearOff_Pipeline_then_String<TInput, TOutput>();
  this_.vptr['then_int'] = _TearOff_Pipeline_then_int<TInput, TOutput>();
  this_._transform = _transform;
  return this_;
}

TOutput Pipeline_execute<TInput, TOutput>(dynamic this__, TInput input) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return (() { final _let5 = input; return this_._transform(_let5); })();
}

PipelineValue<TInput, TNewOutput> Pipeline_then<TInput, TOutput, TNewOutput>(dynamic this__, TypeFunction1<TNewOutput, TOutput> next) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return Pipeline_new<TInput, TNewOutput>(PipelineValue<TInput, TNewOutput>(), ClosureEnv_anon_0<TNewOutput, TOutput, TInput>(this_, next));
}


class BitFlagsValue extends VPtr {
  late int _flags;
  BitFlagsValue() {
    vptr['set'] = const _TearOff_BitFlags_set();
    vptr['clear'] = const _TearOff_BitFlags_clear();
    vptr['has'] = const _TearOff_BitFlags_has();
    vptr['toString'] = const _TearOff_BitFlags_toString();
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
  final StaticList<String> parts = StaticList<String>();
  if ((this_.vptr['has'] as TypeFunction2<bool, dynamic, int>)(this_, 1))   parts.add('r');
  if ((this_.vptr['has'] as TypeFunction2<bool, dynamic, int>)(this_, 2))   parts.add('w');
  if ((this_.vptr['has'] as TypeFunction2<bool, dynamic, int>)(this_, 4))   parts.add('x');
  return (parts.isEmpty ? '-' : parts.join(''));
}


// mixin Timestamped → static functions for delegation
int Timestamped_get_timestamp(dynamic this__) {
  final this_ = this__;
  return 1234567890;
}

String Timestamped_get_timeStr(dynamic this__) {
  final this_ = this__;
  return 'T:${(this_.vptr['get_timestamp'] as TypeFunction1<int, dynamic>)(this_)}';
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
    vptr['get_timestamp'] = const _TearOff_Event_get_timestamp();
    vptr['get_timeStr'] = const _TearOff_Event_get_timeStr();
    vptr['addTag'] = const _TearOff_Event_addTag();
    vptr['get_tags'] = const _TearOff_Event_get_tags();
    vptr['toString'] = const _TearOff_Event_toString();
  }
}

EventValue Event_new(dynamic this__, String name) {
  final this_ = this__ as EventValue;
  this_.name = name;
  this_._tags = StaticList<String>();
  return this_;
}

String Event_toString(dynamic this__) {
  final this_ = this__ as EventValue;
  return 'Event(${this_.name}, ${(this_.vptr['get_timeStr'] as TypeFunction1<String, dynamic>)(this_)}, tags=${(this_.vptr['get_tags'] as TypeFunction1<StaticList<String>, dynamic>)(this_)})';
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
    vptr['get_timestamp'] = const _TearOff_ImportantEvent_get_timestamp();
    vptr['get_timeStr'] = const _TearOff_ImportantEvent_get_timeStr();
    vptr['addTag'] = const _TearOff_ImportantEvent_addTag();
    vptr['get_tags'] = const _TearOff_ImportantEvent_get_tags();
    vptr['toString'] = const _TearOff_ImportantEvent_toString();
    vptr['get_logTag'] = const _TearOff_ImportantEvent_get_logTag();
    vptr['log'] = const _TearOff_ImportantEvent_log();
  }
}

ImportantEventValue ImportantEvent_new(dynamic this__, String name, Priority priority) {
  final this_ = this__ as ImportantEventValue;
  Event_new(this_, name);
  this_.priority = priority;
  this_._tags = StaticList<String>();
  return this_;
}

String ImportantEvent_get_logTag(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent';
}

String ImportantEvent_toString(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent(${this_.name}, ${Priority_toString(this_.priority)}, ${(this_.vptr['get_timeStr'] as TypeFunction1<String, dynamic>)(this_)})';
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
}


class Dog_Animal_Printable_OrderableValue extends Dog_Animal_PrintableValue {
}


class Cat_Animal_PrintableValue extends AnimalValue {
}


class LoggedDataPoint_DataPoint_LoggableValue extends DataPointValue {
}


class LoggedDataPoint_DataPoint_Loggable_ValidatableValue extends LoggedDataPoint_DataPoint_LoggableValue {
}


class Event_Object_TimestampedValue extends VPtr {
}


class Event_Object_Timestamped_TaggedValue extends Event_Object_TimestampedValue {
  late StaticList<String> _tags;
}


class ImportantEvent_Event_LoggableValue extends EventValue {
}


String formatMessage(String template, [String? subject = null, int? count = null]) {
  String result = template;
  if (!((subject == null)))   result = result.replaceAll('{subject}', subject);
  if (!((count == null)))   result = result.replaceAll('{count}', count.toString());
  return result;
}

String buildQuery({required String endpoint, StaticMap<String, String>? params = null, int maxWait = 30, bool secure = true}) {
  final String scheme = (secure ? 'https' : 'http');
  final String query = ((() { final _let8 = params; return (_let8 == null) ? null : _let8.entries.map(ClosureEnv_buildQuery_1()).join('&'); })() ?? '');
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
  do {
{
{
        if ((_v10 == null)) {
          _v9 = 'null';
          break;
        }
      }
{
        late int n;
        if ((((_v10 is int) && (() { final _let11 = n = _v10; return true; })()) && (n < 0))) {
          _v9 = 'negative int: ${n}';
          break;
        }
      }
{
        late int n;
        if ((_v10 is int)) {
          n = _v10;
          _v9 = 'positive int: ${n}';
          break;
        }
      }
{
        late String s;
        if ((((_v10 is String) && (() { final _let12 = s = _v10; return true; })()) && s.isEmpty)) {
          _v9 = 'empty string';
          break;
        }
      }
{
        late String s;
        if ((_v10 is String)) {
          s = _v10;
          _v9 = 'string: "${s}"';
          break;
        }
      }
{
        late StaticList<dynamic> list;
        if ((((_v10 is StaticList<dynamic>) && (() { final _let13 = list = _v10; return true; })()) && list.isEmpty)) {
          _v9 = 'empty list';
          break;
        }
      }
{
        late StaticList<dynamic> list;
        if ((_v10 is StaticList<dynamic>)) {
          list = _v10;
          _v9 = 'list of ${list.length}';
          break;
        }
      }
{
        if (true) {
          _v9 = 'unknown: ${value.runtimeType}';
          break;
        }
      }
    }
  } while (false);
 return _v9; })();
}

StaticList<int> buildList() {
  return (StaticList<int>()..add(1)..add(2)..addAll(StaticList<int>.of([3, 4, 5]))..sort());
}

StringBuffer buildBuffer() {
  return (StringBuffer()..write('Hello')..write(', ')..write('World')..writeln('!'));
}

StaticList<int> mergeAndFilter(StaticList<int> a, StaticList<int> b, bool includeNegative) {
  return (() {   final StaticList<int> _v16 = StaticList<int>.of(a);
  _v16.addAll(b);
  if (includeNegative)   _v16.add((-1));
  for (var i = 10; (i <= 12); i = (i + 1))   _v16.add(i);
 return _v16; })();
}

StaticMap<String, int> buildScoreMap(StaticList<String> names, bool addBonus) {
  return (() {   final StaticMap<String, int> _v17 = StaticMap<String, int>.of({});
  for (var i = 0; (i < names.length); i = (i + 1))   _v17[names[i]] = ((i + 1) * 10);
  if (addBonus)   _v17['bonus'] = 999;
 return _v17; })();
}

int parseAndDivide(String a, String b) {
  try {
    final int x = int.parse(a);
    final int y = int.parse(b);
    if ((y == 0))     throw ArgumentError('Division by zero');
    return (x ~/ y);
  }
 on FormatException {
    rethrow;
  }
 on ArgumentError catch (e) {
    throw StateError('Math error: ${e.message}');
  }
}

String multiLineExample() {
  final String raw = 'raw\\nstring\\ttabs';
  final String multiLine = 'line1\nline2\nline3';
  final String nested = 'lines: ${multiLine.split('\n').length}, raw: ${raw}';
  return nested;
}

TypeFunction1<C, A> compose<A, B, C>(TypeFunction1<B, A> f, TypeFunction1<C, B> g) {
  return ClosureEnv_compose_3<C, B, A>(g, f);
}

TypeFunction1<bool, T> and<T>(TypeFunction1<bool, T> p1, TypeFunction1<bool, T> p2) {
  return ClosureEnv_and_4<T>(p1, p2);
}

StaticList<B> flatMap<A, B>(StaticList<A> list, TypeFunction1<StaticList<B>, A> f) {
  return StaticList.of(list.expand(f).toList());
}

T findMax<T extends Comparable<dynamic>>(StaticList<T> items) {
  T maxItem = items.first;
{
    Iterator<T> sync_for_iterator = items.iterator;
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
  return fn2(fn1(value));
}

String? findFirst(StaticList<String> items, TypeFunction1<bool, String> test) {
{
    Iterator<String> sync_for_iterator = items.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final String item = sync_for_iterator.current;
{
        if (test(item))         return item;
      }
    }
  }
  return null;
}

StaticList<int> filterWithForIn(StaticList<int> items) {
  final StaticList<int> result = StaticList<int>();
{
    Iterator<int> sync_for_iterator = items.iterator;
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
  final StringBuffer log = StringBuffer();
  try {
    log.write('try ');
    if ((code == 1))     throw FormatException('bad format');
    if ((code == 2))     throw ArgumentError('bad arg');
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
  print('=== 全面语法节点还原测试 ===\n');
  print('--- 1. mixin + implements ---');
  final DogValue dog1 = Dog_new(DogValue(), 'Rex', 3, 'Labrador');
  final DogValue dog2 = Dog_new(DogValue(), 'Max', 5, 'Poodle');
  (dog1.vptr['printInfo'] as TypeFunction1<void, dynamic>)(dog1);
  print('${(dog1.vptr['speak'] as TypeFunction1<String, dynamic>)(dog1)} (${dog1.breed})');
  print('dog1 < dog2: ${(dog1.vptr['isLessThan'] as TypeFunction2<bool, dynamic, DogValue>)(dog1, dog2)}');
  print('dog1 > dog2: ${(dog1.vptr['isGreaterThan'] as TypeFunction2<bool, dynamic, DogValue>)(dog1, dog2)}');
  final CatValue cat = Cat_new(CatValue(), 'Whiskers', 2);
  (cat.vptr['printInfo'] as TypeFunction1<void, dynamic>)(cat);
  print('${(cat.vptr['speak'] as TypeFunction1<String, dynamic>)(cat)}, mood: ${(cat.vptr['get_mood'] as TypeFunction1<String, dynamic>)(cat)}');
  (cat.vptr['set_mood'] as TypeFunction2<void, dynamic, String>)(cat, 'sleepy');
  print('mood after set: ${(cat.vptr['get_mood'] as TypeFunction1<String, dynamic>)(cat)}');
  print('\n--- 2. operator 重载 ---');
  final Vector2DValue sum = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorPlus'] as TypeFunction2<Vector2DValue, dynamic, Vector2DValue>)(Vector2D_new(Vector2DValue(), 3.0, 4.0), Vector2D_new(Vector2DValue(), 1.0, 2.0));
  final Vector2DValue diff = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorMinus'] as TypeFunction2<Vector2DValue, dynamic, Vector2DValue>)(Vector2D_new(Vector2DValue(), 3.0, 4.0), Vector2D_new(Vector2DValue(), 1.0, 2.0));
  final Vector2DValue scaled = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorStar'] as TypeFunction2<Vector2DValue, dynamic, double>)(Vector2D_new(Vector2DValue(), 3.0, 4.0), 2.0);
  print('v1 + v2 = ${sum}');
  print('v1 - v2 = ${diff}');
  print('v1 * 2 = ${scaled}');
  print('v1.length = ${(Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['get_length'] as TypeFunction1<double, dynamic>)(Vector2D_new(Vector2DValue(), 3.0, 4.0)).toStringAsFixed(2)}');
  print('v1 == Vector2D(3,4): ${(Vector2D_new(Vector2DValue(), 3.0, 4.0) == Vector2D_new(Vector2DValue(), 3.0, 4.0))}');
  print('\n--- 3. static + factory ---');
  final CounterValue c1 = Counter_new('alpha');
  final CounterValue c2 = Counter_new('beta', initialValue: 50);
  final CounterValue c3 = Counter_new_fromString('gamma:25');
  (c1.vptr['increment'] as TypeFunction2<void, dynamic, int>)(c1, 10);
  (c2.vptr['decrement'] as TypeFunction2<void, dynamic, int>)(c2, 5);
  (c3.vptr['increment'] as TypeFunction2<void, dynamic, int>)(c3, 1);
  print('${c1}, ${c2}, ${c3}');
  print('instances: ${Counter_instanceCount()}');
  print('maxValue: 100');
  print('\n--- 4. Result<T> + named params ---');
  print('ok: ${Result_new_success<int>(ResultValue<int>(), 42)}');
  print('err: ${Result_new_failure<int>(ResultValue<int>(), 'not found')}');
  final String okMsg = (Result_new_success<int>(ResultValue<int>(), 42).vptr['fold_String'] as TypeFunction3<String, dynamic, TypeFunction1<String, int>, TypeFunction1<String, String>>)(Result_new_success<int>(ResultValue<int>(), 42), ClosureEnv_main_7(), ClosureEnv_main_8());
  final String errMsg = (Result_new_failure<int>(ResultValue<int>(), 'not found').vptr['fold_String'] as TypeFunction3<String, dynamic, TypeFunction1<String, int>, TypeFunction1<String, String>>)(Result_new_failure<int>(ResultValue<int>(), 'not found'), ClosureEnv_main_11(), ClosureEnv_main_12());
  print('okMsg: ${okMsg}');
  print('errMsg: ${errMsg}');
  print('\n--- 5. 可选参数 ---');
  print(formatMessage('Hello {subject}!', 'Dart'));
  print(formatMessage('Count: {count}', null, 99));
  print(formatMessage('No params'));
  print(buildQuery(endpoint: 'api.example.com/users'));
  print(buildQuery(endpoint: 'api.example.com/search', params: StaticMap<String, String>.of({'q': 'dart', 'page': '1'}), maxWait: 10, secure: false));
  print('\n--- 6. sync* 生成器 ---');
  final StaticList<int> r = StaticList.of(range(0, 10, 2).toList());
  print('range(0,10,2): ${r}');
  final StaticList<int> fib = StaticList.of(fibonacci(8).toList());
  print('fibonacci(8): ${fib}');
  print('\n--- 7. async countdown ---');
  final StaticList<String> countdown = StaticList<String>.of(smAwait(countDown(3)));
  print('countdown: ${countdown}');
  print('\n--- 8. record 类型 ---');
  final (String, int) person = getPersonRecord();
  print('person: ${person.$1}, age=${person.$2}');
  final (String, double, double) loc = getLocation();
  print('location: ${loc.$1} (${loc.$2}, ${loc.$3})');
  final int q;
  final int r2;
{
    final (int, int) _v10 = divmod(17, 5);
    q = _v10.$1;
    r2 = _v10.$2;
  }
  print('divmod(17,5): quotient=${q}, remainder=${r2}');
  print('\n--- 9. pattern matching ---');
  final StaticList<Object?> values = StaticList<Object?>.of([null, (-5), 42, '', 'hello', StaticList<int>(), StaticList<int>.of([1, 2, 3])]);
{
    Iterator<Object?> sync_for_iterator = values.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final Object? v = sync_for_iterator.current;
{
        print('  ${describeValue(v)}');
      }
    }
  }
  print('\n--- 10. 级联操作符 ---');
  final StaticList<int> list = StaticList<int>.of(buildList());
  print('buildList: ${list}');
  final StringBuffer buf = buildBuffer();
  print('buildBuffer: ${buf.toString().trim()}');
  print('\n--- 11. 展开 + 集合 if/for ---');
  final StaticList<int> merged = StaticList<int>.of(mergeAndFilter(StaticList<int>.of([1, 2]), StaticList<int>.of([3, 4]), true));
  print('merged(includeNeg=true): ${merged}');
  final StaticList<int> mergedNoNeg = StaticList<int>.of(mergeAndFilter(StaticList<int>.of([1, 2]), StaticList<int>.of([3, 4]), false));
  print('merged(includeNeg=false): ${mergedNoNeg}');
  final StaticMap<String, int> scores = StaticMap<String, int>.of(buildScoreMap(StaticList<String>.of(['Alice', 'Bob', 'Carol']), true));
  print('scores: ${scores}');
  print('\n--- 12. late 变量 ---');
  final LazyLoaderValue loader = LazyLoader_new(LazyLoaderValue());
  print('before init: ${(loader.vptr['get_data'] as TypeFunction1<String, dynamic>)(loader)}, ${(loader.vptr['get_computedValue'] as TypeFunction1<int, dynamic>)(loader)}');
  (loader.vptr['initialize'] as TypeFunction2<void, dynamic, String>)(loader, 'hello');
  print('after init: ${(loader.vptr['get_data'] as TypeFunction1<String, dynamic>)(loader)}, ${(loader.vptr['get_computedValue'] as TypeFunction1<int, dynamic>)(loader)}');
  print('\n--- 13. rethrow ---');
  try {
    parseAndDivide('10', '2');
    print('10/2 = ${parseAndDivide('10', '2')}');
  }
 catch (e) {
    print('unexpected: ${e}');
  }
  try {
    parseAndDivide('10', '0');
  }
 on StateError catch (e) {
    print('StateError: ${e.message}');
  }
  try {
    parseAndDivide('abc', '2');
  }
 on FormatException catch (e) {
    print('FormatException: ${e.message}');
  }
  print('\n--- 14. assert ---');
  final BoundedValueValue bv = BoundedValue_new(BoundedValueValue(), 0.0, 10.0, 5.0);
  (bv.vptr['set'] as TypeFunction2<void, dynamic, double>)(bv, 7.5);
  print('BoundedValue: ${(bv.vptr['get_current'] as TypeFunction1<double, dynamic>)(bv)}');
  print('\n--- 15. 字符串 ---');
  print(multiLineExample());
  print('\n--- 16. typedef + 函数式组合 ---');
  final TypeFunction1<String, int> doubleIt = compose<int, int, String>(ClosureEnv_main_13(), ClosureEnv_main_14());
  print('compose(5): ${doubleIt(5)}');
  final TypeFunction1<bool, int> isPositive = ClosureEnv_main_15();
  final TypeFunction1<bool, int> isEven = ClosureEnv_main_16();
  final TypeFunction1<bool, int> isPositiveEven = and<int>(isPositive, isEven);
  final StaticList<int> nums = StaticList<int>.of([(-2), (-1), 0, 1, 2, 3, 4]);
  print('positiveEvens: ${StaticList.of(nums.where(isPositiveEven).toList())}');
  final StaticList<int> nested = StaticList<int>.of(flatMap<int, int>(StaticList<int>.of([1, 2, 3]), ClosureEnv_main_17()));
  print('flatMap: ${nested}');
  print('\n--- 19. 多层继承链 ---');
  final ShapeValue shape = Shape_new(ShapeValue(), 'red');
  print((shape.vptr['describe'] as TypeFunction1<String, dynamic>)(shape));
  final ShapeValue transparentShape = Shape_new_transparent(ShapeValue(), 'blue');
  print((transparentShape.vptr['describe'] as TypeFunction1<String, dynamic>)(transparentShape));
  final PolygonValue polygon = Polygon_new(PolygonValue(), 'green', 6, opacity: 0.8);
  print((polygon.vptr['describe'] as TypeFunction1<String, dynamic>)(polygon));
  print('perimeter: ${(polygon.vptr['perimeter'] as TypeFunction2<double, dynamic, double>)(polygon, 3.0)}');
  final RegularPolygonValue hexagon = RegularPolygon_new(RegularPolygonValue(), 'yellow', 6, 5.0);
  print((hexagon.vptr['describe'] as TypeFunction1<String, dynamic>)(hexagon));
  print('perimeter: ${(hexagon.vptr['perimeter'] as TypeFunction2<double, dynamic, double?>)(hexagon, null)}');
  print('area: ${(hexagon.vptr['area'] as TypeFunction1<double, dynamic>)(hexagon)}');
  final SquareValue square = Square_new(SquareValue(), 'white', 10.0, opacity: 0.9);
  print((square.vptr['describe'] as TypeFunction1<String, dynamic>)(square));
  print('square perimeter: ${(square.vptr['perimeter'] as TypeFunction2<double, dynamic, double?>)(square, null)}');
  print('\n--- 20. implements 多接口 ---');
  final DataPointValue dp1 = DataPoint_new(DataPointValue(), 1.0, 2.0, 'A');
  final DataPointValue dp2 = DataPoint_new(DataPointValue(), 3.0, 1.0, 'B');
  print('dp1: ${dp1}');
  print('dp1.serialize: ${(dp1.vptr['serialize'] as TypeFunction1<String, dynamic>)(dp1)}');
  final DataPointValue dp1Clone = (dp1.vptr['clone'] as TypeFunction1<DataPointValue, dynamic>)(dp1);
  print('dp1.clone: ${dp1Clone}');
  print('dp1.compareTo2(dp2): ${(dp1.vptr['compareTo2'] as TypeFunction2<int, dynamic, DataPointValue>)(dp1, dp2)}');
  print('\n--- 21. mixin on 约束 ---');
  final LoggedDataPointValue ldp = LoggedDataPoint_new(LoggedDataPointValue(), 5.0, 6.0, 'logged');
  (ldp.vptr['log'] as TypeFunction2<void, dynamic, String>)(ldp, 'created');
  print('validate: ${(ldp.vptr['validate'] as TypeFunction1<bool, dynamic>)(ldp)}');
  print('serialize: ${(ldp.vptr['serialize'] as TypeFunction1<String, dynamic>)(ldp)}');
  print('\n--- 22. 增强枚举 ---');
  print('Priority.high: ${Priority}.high');
  print('high > medium: ${Priority_isHigherThan(Priority.high, Priority.medium)}');
  print('low > high: ${Priority_isHigherThan(Priority.low, Priority.high)}');
{
    Iterator<Priority> sync_for_iterator = const [Priority.low, Priority.medium, Priority.high, Priority.critical].iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final Priority p = sync_for_iterator.current;
{
        print('  ${Priority_toString(p)}');
      }
    }
  }
  print('GET isReadOnly: ${HttpMethod_get_isReadOnly(HttpMethod.get)}');
  print('POST isReadOnly: ${HttpMethod_get_isReadOnly(HttpMethod.post)}');
  print('\n--- 23. 重定向构造函数 ---');
  final ConfigValue cfg1 = Config_new(ConfigValue(), 'example.com', 8080);
  final ConfigValue cfg2 = Config_new_localhost(ConfigValue());
  final ConfigValue cfg3 = Config_new_production(ConfigValue(), 'api.example.com');
  print('cfg1: ${cfg1}');
  print('cfg2: ${cfg2}');
  print('cfg3: ${cfg3}');
  print('\n--- 24. 泛型约束 ---');
  final SortedListValue<int> sortedList = SortedList_new<int>(SortedListValue<int>());
  (sortedList.vptr['add'] as TypeFunction2<void, dynamic, int>)(sortedList, 5);
  (sortedList.vptr['add'] as TypeFunction2<void, dynamic, int>)(sortedList, 1);
  (sortedList.vptr['add'] as TypeFunction2<void, dynamic, int>)(sortedList, 3);
  (sortedList.vptr['add'] as TypeFunction2<void, dynamic, int>)(sortedList, 2);
  print('sorted: ${sortedList}');
  print('first: ${(sortedList.vptr['get_first'] as TypeFunction1<int, dynamic>)(sortedList)}, last: ${(sortedList.vptr['get_last'] as TypeFunction1<int, dynamic>)(sortedList)}');
  final int maxVal = findMax<int>(StaticList<int>.of([3, 7, 1, 9, 4]));
  print('findMax: ${maxVal}');
  final String result = applyTwice<int, String>(5, ClosureEnv_main_18(), ClosureEnv_main_19());
  print('applyTwice: ${result}');
  print('\n--- 25. null safety ---');
  final NullSafetyDemoValue ns1 = NullSafetyDemo_new(NullSafetyDemoValue(), 'hello', 'world');
  print('ns1: ${(ns1.vptr['demonstrate'] as TypeFunction1<String, dynamic>)(ns1)}');
  final NullSafetyDemoValue ns2 = NullSafetyDemo_new(NullSafetyDemoValue(), 'hello');
  print('ns2: ${(ns2.vptr['demonstrate'] as TypeFunction1<String, dynamic>)(ns2)}');
  final String? found = findFirst(StaticList<String>.of(['apple', 'banana', 'cherry']), ClosureEnv_main_20());
  print('findFirst(b): ${found}');
  final String? notFound = findFirst(StaticList<String>.of(['apple', 'banana']), ClosureEnv_main_21());
  print('findFirst(z): ${notFound}');
  print('\n--- 26. for-in + do-while ---');
  final StaticList<int> filtered = StaticList<int>.of(filterWithForIn(StaticList<int>.of([5, (-3), 10, 200, 50, (-1), 80])));
  print('filterWithForIn: ${filtered}');
  print('collatz(6): ${collatzSteps(6)}');
  print('collatz(27): ${collatzSteps(27)}');
  print('\n--- 27. 类型测试 ---');
  print(typeTest(42));
  print(typeTest('hello'));
  print(typeTest(true));
  print(typeTest(StaticList<int>.of([1, 2, 3])));
  print('safeCast(3.14): ${safeCast(3.14)}');
  print('safeCast("x"): ${safeCast('x')}');
  print('\n--- 28. try-catch-finally ---');
  print('code=0: ${tryCatchFinally(0)}');
  print('code=1: ${tryCatchFinally(1)}');
  print('code=2: ${tryCatchFinally(2)}');
  print('\n--- 29. covariant ---');
  final CircleRendererValue renderer = CircleRenderer_new(CircleRendererValue());
  print('renderer: ${(renderer.vptr['get_name'] as TypeFunction1<String, dynamic>)(renderer)}');
  (renderer.vptr['render'] as TypeFunction2<void, dynamic, String>)(renderer, 'circle');
  print('\n--- 30. Pipeline 泛型链 ---');
  final PipelineValue<int, String> pipeline = ((Pipeline_new<int, String>(PipelineValue<int, String>(), ClosureEnv_main_22()).vptr['then_int'] as TypeFunction2<PipelineValue<int, int>, dynamic, TypeFunction1<int, String>>)(Pipeline_new<int, String>(PipelineValue<int, String>(), ClosureEnv_main_22()), ClosureEnv_main_24()).vptr['then_String'] as TypeFunction2<PipelineValue<int, String>, dynamic, TypeFunction1<String, int>>)((Pipeline_new<int, String>(PipelineValue<int, String>(), ClosureEnv_main_22()).vptr['then_int'] as TypeFunction2<PipelineValue<int, int>, dynamic, TypeFunction1<int, String>>)(Pipeline_new<int, String>(PipelineValue<int, String>(), ClosureEnv_main_22()), ClosureEnv_main_24()), ClosureEnv_main_26());
  print('pipeline(42): ${(pipeline.vptr['execute'] as TypeFunction2<String, dynamic, int>)(pipeline, 42)}');
  print('pipeline(12345): ${(pipeline.vptr['execute'] as TypeFunction2<String, dynamic, int>)(pipeline, 12345)}');
  print('\n--- 31. switch-case ---');
  print('day 1: ${dayType(1)}');
  print('day 3: ${dayType(3)}');
  print('day 7: ${dayType(7)}');
  print('day 9: ${dayType(9)}');
  print('\n--- 32. 位运算 ---');
  final BitFlagsValue flags = BitFlags_new(BitFlagsValue());
  (flags.vptr['set'] as TypeFunction2<void, dynamic, int>)(flags, 1);
  (flags.vptr['set'] as TypeFunction2<void, dynamic, int>)(flags, 4);
  print('flags: ${flags}');
  print('has read: ${(flags.vptr['has'] as TypeFunction2<bool, dynamic, int>)(flags, 1)}');
  print('has write: ${(flags.vptr['has'] as TypeFunction2<bool, dynamic, int>)(flags, 2)}');
  (flags.vptr['set'] as TypeFunction2<void, dynamic, int>)(flags, 2);
  print('after set write: ${flags}');
  (flags.vptr['clear'] as TypeFunction2<void, dynamic, int>)(flags, 4);
  print('after clear execute: ${flags}');
  print('\n--- 33. 多层 mixin ---');
  final EventValue event = Event_new(EventValue(), 'meeting');
  (event.vptr['addTag'] as TypeFunction2<void, dynamic, String>)(event, 'work');
  (event.vptr['addTag'] as TypeFunction2<void, dynamic, String>)(event, 'important');
  print(event);
  final ImportantEventValue impEvent = ImportantEvent_new(ImportantEventValue(), 'deadline', Priority.critical);
  (impEvent.vptr['addTag'] as TypeFunction2<void, dynamic, String>)(impEvent, 'urgent');
  (impEvent.vptr['log'] as TypeFunction2<void, dynamic, String>)(impEvent, 'created');
  print(impEvent);
  print('\n=== 所有测试通过 ✅ ===');
}

class _TearOff_Animal_speak extends TypeFunction1<String, dynamic> {
  const _TearOff_Animal_speak();
  @override
  String call(dynamic this_) => Animal_speak(this_);
}
class _TearOff_Animal_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Animal_toString();
  @override
  String call(dynamic this_) => Animal_toString(this_);
}
class _TearOff_Dog_speak extends TypeFunction1<String, dynamic> {
  const _TearOff_Dog_speak();
  @override
  String call(dynamic this_) => Dog_speak(this_);
}
class _TearOff_Dog_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Dog_toString();
  @override
  String call(dynamic this_) => Dog_toString(this_);
}
class _TearOff_Dog_get_displayName extends TypeFunction1<String, dynamic> {
  const _TearOff_Dog_get_displayName();
  @override
  String call(dynamic this_) => Dog_get_displayName(this_);
}
class _TearOff_Dog_printInfo extends TypeFunction1<void, dynamic> {
  const _TearOff_Dog_printInfo();
  @override
  void call(dynamic this_) => Dog_printInfo(this_);
}
class _TearOff_Dog_compareTo extends TypeFunction2<int, dynamic, DogValue> {
  const _TearOff_Dog_compareTo();
  @override
  int call(dynamic this_, DogValue other) => Dog_compareTo(this_, other);
}
class _TearOff_Dog_isLessThan extends TypeFunction2<bool, dynamic, DogValue> {
  const _TearOff_Dog_isLessThan();
  @override
  bool call(dynamic this_, DogValue other) => Dog_isLessThan(this_, other);
}
class _TearOff_Dog_isGreaterThan extends TypeFunction2<bool, dynamic, DogValue> {
  const _TearOff_Dog_isGreaterThan();
  @override
  bool call(dynamic this_, DogValue other) => Dog_isGreaterThan(this_, other);
}
class _TearOff_Cat_speak extends TypeFunction1<String, dynamic> {
  const _TearOff_Cat_speak();
  @override
  String call(dynamic this_) => Cat_speak(this_);
}
class _TearOff_Cat_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Cat_toString();
  @override
  String call(dynamic this_) => Cat_toString(this_);
}
class _TearOff_Cat_get_displayName extends TypeFunction1<String, dynamic> {
  const _TearOff_Cat_get_displayName();
  @override
  String call(dynamic this_) => Cat_get_displayName(this_);
}
class _TearOff_Cat_printInfo extends TypeFunction1<void, dynamic> {
  const _TearOff_Cat_printInfo();
  @override
  void call(dynamic this_) => Cat_printInfo(this_);
}
class _TearOff_Cat_get_mood extends TypeFunction1<String, dynamic> {
  const _TearOff_Cat_get_mood();
  @override
  String call(dynamic this_) => Cat_get_mood(this_);
}
class _TearOff_Cat_set_mood extends TypeFunction2<void, dynamic, String> {
  const _TearOff_Cat_set_mood();
  @override
  void call(dynamic this_, String value) => Cat_set_mood(this_, value);
}
class _TearOff_Vector2D_operatorPlus extends TypeFunction2<Vector2DValue, dynamic, Vector2DValue> {
  const _TearOff_Vector2D_operatorPlus();
  @override
  Vector2DValue call(dynamic this_, Vector2DValue other) => Vector2D_operatorPlus(this_, other);
}
class _TearOff_Vector2D_operatorMinus extends TypeFunction2<Vector2DValue, dynamic, Vector2DValue> {
  const _TearOff_Vector2D_operatorMinus();
  @override
  Vector2DValue call(dynamic this_, Vector2DValue other) => Vector2D_operatorMinus(this_, other);
}
class _TearOff_Vector2D_operatorStar extends TypeFunction2<Vector2DValue, dynamic, double> {
  const _TearOff_Vector2D_operatorStar();
  @override
  Vector2DValue call(dynamic this_, double scalar) => Vector2D_operatorStar(this_, scalar);
}
class _TearOff_Vector2D_operatorEq extends TypeFunction2<bool, dynamic, Object> {
  const _TearOff_Vector2D_operatorEq();
  @override
  bool call(dynamic this_, Object other) => Vector2D_operatorEq(this_, other);
}
class _TearOff_Vector2D_get_length extends TypeFunction1<double, dynamic> {
  const _TearOff_Vector2D_get_length();
  @override
  double call(dynamic this_) => Vector2D_get_length(this_);
}
class _TearOff_Vector2D_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Vector2D_toString();
  @override
  String call(dynamic this_) => Vector2D_toString(this_);
}
class _TearOff_Counter_increment extends TypeFunction2<void, dynamic, int> {
  const _TearOff_Counter_increment();
  @override
  void call(dynamic this_, int step) => Counter_increment(this_, step);
}
class _TearOff_Counter_decrement extends TypeFunction2<void, dynamic, int> {
  const _TearOff_Counter_decrement();
  @override
  void call(dynamic this_, int step) => Counter_decrement(this_, step);
}
class _TearOff_Counter_get_value extends TypeFunction1<int, dynamic> {
  const _TearOff_Counter_get_value();
  @override
  int call(dynamic this_) => Counter_get_value(this_);
}
class _TearOff_Counter_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Counter_toString();
  @override
  String call(dynamic this_) => Counter_toString(this_);
}
class _TearOff_Result_toString<T> extends TypeFunction1<String, dynamic> {
  _TearOff_Result_toString();
  @override
  String call(dynamic this_) => Result_toString<T>(this_);
}
class _TearOff_Result_fold_String<T> extends TypeFunction3<String, dynamic, TypeFunction1<String, T>, TypeFunction1<String, String>> {
  _TearOff_Result_fold_String();
  @override
  String call(dynamic this_, TypeFunction1<String, T> onSuccess, TypeFunction1<String, String> onFailure) => Result_fold<T, String>(this_, onSuccess, onFailure);
}
class _TearOff_LazyLoader_initialize extends TypeFunction2<void, dynamic, String> {
  const _TearOff_LazyLoader_initialize();
  @override
  void call(dynamic this_, String data) => LazyLoader_initialize(this_, data);
}
class _TearOff_LazyLoader_get_data extends TypeFunction1<String, dynamic> {
  const _TearOff_LazyLoader_get_data();
  @override
  String call(dynamic this_) => LazyLoader_get_data(this_);
}
class _TearOff_LazyLoader_get_computedValue extends TypeFunction1<int, dynamic> {
  const _TearOff_LazyLoader_get_computedValue();
  @override
  int call(dynamic this_) => LazyLoader_get_computedValue(this_);
}
class _TearOff_BoundedValue_set extends TypeFunction2<void, dynamic, double> {
  const _TearOff_BoundedValue_set();
  @override
  void call(dynamic this_, double value) => BoundedValue_set(this_, value);
}
class _TearOff_BoundedValue_get_current extends TypeFunction1<double, dynamic> {
  const _TearOff_BoundedValue_get_current();
  @override
  double call(dynamic this_) => BoundedValue_get_current(this_);
}
class _TearOff_Shape_describe extends TypeFunction1<String, dynamic> {
  const _TearOff_Shape_describe();
  @override
  String call(dynamic this_) => Shape_describe(this_);
}
class _TearOff_Polygon_describe extends TypeFunction1<String, dynamic> {
  const _TearOff_Polygon_describe();
  @override
  String call(dynamic this_) => Polygon_describe(this_);
}
class _TearOff_Polygon_perimeter extends TypeFunction2<double, dynamic, double> {
  const _TearOff_Polygon_perimeter();
  @override
  double call(dynamic this_, double sideLength) => Polygon_perimeter(this_, sideLength);
}
class _TearOff_RegularPolygon_describe extends TypeFunction1<String, dynamic> {
  const _TearOff_RegularPolygon_describe();
  @override
  String call(dynamic this_) => RegularPolygon_describe(this_);
}
class _TearOff_RegularPolygon_perimeter extends TypeFunction2<double, dynamic, double?> {
  const _TearOff_RegularPolygon_perimeter();
  @override
  double call(dynamic this_, double? overrideSideLength) => RegularPolygon_perimeter(this_, overrideSideLength);
}
class _TearOff_RegularPolygon_area extends TypeFunction1<double, dynamic> {
  const _TearOff_RegularPolygon_area();
  @override
  double call(dynamic this_) => RegularPolygon_area(this_);
}
class _TearOff_Square_describe extends TypeFunction1<String, dynamic> {
  const _TearOff_Square_describe();
  @override
  String call(dynamic this_) => Square_describe(this_);
}
class _TearOff_Square_perimeter extends TypeFunction2<double, dynamic, double?> {
  const _TearOff_Square_perimeter();
  @override
  double call(dynamic this_, double? overrideSideLength) => Square_perimeter(this_, overrideSideLength);
}
class _TearOff_Square_area extends TypeFunction1<double, dynamic> {
  const _TearOff_Square_area();
  @override
  double call(dynamic this_) => Square_area(this_);
}
class _TearOff_Serializable_serialize extends TypeFunction1<String, dynamic> {
  const _TearOff_Serializable_serialize();
  @override
  String call(dynamic this_) => Serializable_serialize(this_);
}
class _TearOff_Cloneable_clone<T> extends TypeFunction1<T, dynamic> {
  _TearOff_Cloneable_clone();
  @override
  T call(dynamic this_) => Cloneable_clone<T>(this_);
}
class _TearOff_Comparable2_compareTo2<T> extends TypeFunction2<int, dynamic, T> {
  _TearOff_Comparable2_compareTo2();
  @override
  int call(dynamic this_, T other) => Comparable2_compareTo2<T>(this_, other);
}
class _TearOff_DataPoint_serialize extends TypeFunction1<String, dynamic> {
  const _TearOff_DataPoint_serialize();
  @override
  String call(dynamic this_) => DataPoint_serialize(this_);
}
class _TearOff_DataPoint_clone extends TypeFunction1<DataPointValue, dynamic> {
  const _TearOff_DataPoint_clone();
  @override
  DataPointValue call(dynamic this_) => DataPoint_clone(this_);
}
class _TearOff_DataPoint_compareTo2 extends TypeFunction2<int, dynamic, DataPointValue> {
  const _TearOff_DataPoint_compareTo2();
  @override
  int call(dynamic this_, DataPointValue other) => DataPoint_compareTo2(this_, other);
}
class _TearOff_DataPoint_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_DataPoint_toString();
  @override
  String call(dynamic this_) => DataPoint_toString(this_);
}
class _TearOff_LoggedDataPoint_serialize extends TypeFunction1<String, dynamic> {
  const _TearOff_LoggedDataPoint_serialize();
  @override
  String call(dynamic this_) => LoggedDataPoint_serialize(this_);
}
class _TearOff_LoggedDataPoint_clone extends TypeFunction1<DataPointValue, dynamic> {
  const _TearOff_LoggedDataPoint_clone();
  @override
  DataPointValue call(dynamic this_) => LoggedDataPoint_clone(this_);
}
class _TearOff_LoggedDataPoint_compareTo2 extends TypeFunction2<int, dynamic, DataPointValue> {
  const _TearOff_LoggedDataPoint_compareTo2();
  @override
  int call(dynamic this_, DataPointValue other) => LoggedDataPoint_compareTo2(this_, other);
}
class _TearOff_LoggedDataPoint_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_LoggedDataPoint_toString();
  @override
  String call(dynamic this_) => LoggedDataPoint_toString(this_);
}
class _TearOff_LoggedDataPoint_get_logTag extends TypeFunction1<String, dynamic> {
  const _TearOff_LoggedDataPoint_get_logTag();
  @override
  String call(dynamic this_) => LoggedDataPoint_get_logTag(this_);
}
class _TearOff_LoggedDataPoint_log extends TypeFunction2<void, dynamic, String> {
  const _TearOff_LoggedDataPoint_log();
  @override
  void call(dynamic this_, String message) => LoggedDataPoint_log(this_, message);
}
class _TearOff_LoggedDataPoint_validate extends TypeFunction1<bool, dynamic> {
  const _TearOff_LoggedDataPoint_validate();
  @override
  bool call(dynamic this_) => LoggedDataPoint_validate(this_);
}
class _TearOff_Config_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Config_toString();
  @override
  String call(dynamic this_) => Config_toString(this_);
}
class _TearOff_SortedList_add<T extends Comparable<dynamic>> extends TypeFunction2<void, dynamic, T> {
  _TearOff_SortedList_add();
  @override
  void call(dynamic this_, T item) => SortedList_add<T>(this_, item);
}
class _TearOff_SortedList_get_first<T extends Comparable<dynamic>> extends TypeFunction1<T, dynamic> {
  _TearOff_SortedList_get_first();
  @override
  T call(dynamic this_) => SortedList_get_first<T>(this_);
}
class _TearOff_SortedList_get_last<T extends Comparable<dynamic>> extends TypeFunction1<T, dynamic> {
  _TearOff_SortedList_get_last();
  @override
  T call(dynamic this_) => SortedList_get_last<T>(this_);
}
class _TearOff_SortedList_get_length<T extends Comparable<dynamic>> extends TypeFunction1<int, dynamic> {
  _TearOff_SortedList_get_length();
  @override
  int call(dynamic this_) => SortedList_get_length<T>(this_);
}
class _TearOff_SortedList_toList<T extends Comparable<dynamic>> extends TypeFunction1<StaticList<T>, dynamic> {
  _TearOff_SortedList_toList();
  @override
  StaticList<T> call(dynamic this_) => SortedList_toList<T>(this_);
}
class _TearOff_SortedList_toString<T extends Comparable<dynamic>> extends TypeFunction1<String, dynamic> {
  _TearOff_SortedList_toString();
  @override
  String call(dynamic this_) => SortedList_toString<T>(this_);
}
class _TearOff_NullSafetyDemo_demonstrate extends TypeFunction1<String, dynamic> {
  const _TearOff_NullSafetyDemo_demonstrate();
  @override
  String call(dynamic this_) => NullSafetyDemo_demonstrate(this_);
}
class _TearOff_Renderer_render extends TypeFunction2<void, dynamic, Object> {
  const _TearOff_Renderer_render();
  @override
  void call(dynamic this_, Object shape) => Renderer_render(this_, shape);
}
class _TearOff_Renderer_get_name extends TypeFunction1<String, dynamic> {
  const _TearOff_Renderer_get_name();
  @override
  String call(dynamic this_) => Renderer_get_name(this_);
}
class _TearOff_CircleRenderer_render extends TypeFunction2<void, dynamic, String> {
  const _TearOff_CircleRenderer_render();
  @override
  void call(dynamic this_, String shape) => CircleRenderer_render(this_, shape);
}
class _TearOff_CircleRenderer_get_name extends TypeFunction1<String, dynamic> {
  const _TearOff_CircleRenderer_get_name();
  @override
  String call(dynamic this_) => CircleRenderer_get_name(this_);
}
class _TearOff_Pipeline_execute<TInput, TOutput> extends TypeFunction2<TOutput, dynamic, TInput> {
  _TearOff_Pipeline_execute();
  @override
  TOutput call(dynamic this_, TInput input) => Pipeline_execute<TInput, TOutput>(this_, input);
}
class _TearOff_Pipeline_then_String<TInput, TOutput> extends TypeFunction2<PipelineValue<TInput, String>, dynamic, TypeFunction1<String, TOutput>> {
  _TearOff_Pipeline_then_String();
  @override
  PipelineValue<TInput, String> call(dynamic this_, TypeFunction1<String, TOutput> next) => Pipeline_then<TInput, TOutput, String>(this_, next);
}
class _TearOff_Pipeline_then_int<TInput, TOutput> extends TypeFunction2<PipelineValue<TInput, int>, dynamic, TypeFunction1<int, TOutput>> {
  _TearOff_Pipeline_then_int();
  @override
  PipelineValue<TInput, int> call(dynamic this_, TypeFunction1<int, TOutput> next) => Pipeline_then<TInput, TOutput, int>(this_, next);
}
class ClosureEnv_anon_0<TNewOutput, TOutput, TInput> extends TypeFunction1<TNewOutput, TInput> {
  PipelineValue<TInput, TOutput> this_;
  TypeFunction1<TNewOutput, TOutput> next;
  ClosureEnv_anon_0(this.this_, this.next);
  @override
  TNewOutput call(TInput input) => ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>(this, input);
}
TNewOutput ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>(ClosureEnv_anon_0<TNewOutput, TOutput, TInput> env, TInput input) {
  return env.next((() { final _let6 = input; return env.this_._transform(_let6); })());
}

class _TearOff_BitFlags_set extends TypeFunction2<void, dynamic, int> {
  const _TearOff_BitFlags_set();
  @override
  void call(dynamic this_, int flag) => BitFlags_set(this_, flag);
}
class _TearOff_BitFlags_clear extends TypeFunction2<void, dynamic, int> {
  const _TearOff_BitFlags_clear();
  @override
  void call(dynamic this_, int flag) => BitFlags_clear(this_, flag);
}
class _TearOff_BitFlags_has extends TypeFunction2<bool, dynamic, int> {
  const _TearOff_BitFlags_has();
  @override
  bool call(dynamic this_, int flag) => BitFlags_has(this_, flag);
}
class _TearOff_BitFlags_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_BitFlags_toString();
  @override
  String call(dynamic this_) => BitFlags_toString(this_);
}
class _TearOff_Event_get_timestamp extends TypeFunction1<int, dynamic> {
  const _TearOff_Event_get_timestamp();
  @override
  int call(dynamic this_) => Event_get_timestamp(this_);
}
class _TearOff_Event_get_timeStr extends TypeFunction1<String, dynamic> {
  const _TearOff_Event_get_timeStr();
  @override
  String call(dynamic this_) => Event_get_timeStr(this_);
}
class _TearOff_Event_addTag extends TypeFunction2<void, dynamic, String> {
  const _TearOff_Event_addTag();
  @override
  void call(dynamic this_, String tag) => Event_addTag(this_, tag);
}
class _TearOff_Event_get_tags extends TypeFunction1<StaticList<String>, dynamic> {
  const _TearOff_Event_get_tags();
  @override
  StaticList<String> call(dynamic this_) => Event_get_tags(this_);
}
class _TearOff_Event_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Event_toString();
  @override
  String call(dynamic this_) => Event_toString(this_);
}
class _TearOff_ImportantEvent_get_timestamp extends TypeFunction1<int, dynamic> {
  const _TearOff_ImportantEvent_get_timestamp();
  @override
  int call(dynamic this_) => ImportantEvent_get_timestamp(this_);
}
class _TearOff_ImportantEvent_get_timeStr extends TypeFunction1<String, dynamic> {
  const _TearOff_ImportantEvent_get_timeStr();
  @override
  String call(dynamic this_) => ImportantEvent_get_timeStr(this_);
}
class _TearOff_ImportantEvent_addTag extends TypeFunction2<void, dynamic, String> {
  const _TearOff_ImportantEvent_addTag();
  @override
  void call(dynamic this_, String tag) => ImportantEvent_addTag(this_, tag);
}
class _TearOff_ImportantEvent_get_tags extends TypeFunction1<StaticList<String>, dynamic> {
  const _TearOff_ImportantEvent_get_tags();
  @override
  StaticList<String> call(dynamic this_) => ImportantEvent_get_tags(this_);
}
class _TearOff_ImportantEvent_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_ImportantEvent_toString();
  @override
  String call(dynamic this_) => ImportantEvent_toString(this_);
}
class _TearOff_ImportantEvent_get_logTag extends TypeFunction1<String, dynamic> {
  const _TearOff_ImportantEvent_get_logTag();
  @override
  String call(dynamic this_) => ImportantEvent_get_logTag(this_);
}
class _TearOff_ImportantEvent_log extends TypeFunction2<void, dynamic, String> {
  const _TearOff_ImportantEvent_log();
  @override
  void call(dynamic this_, String message) => ImportantEvent_log(this_, message);
}
class ClosureEnv_buildQuery_1 extends TypeFunction1<String, MapEntry<String, String>> {
  ClosureEnv_buildQuery_1();
  @override
  String call(MapEntry<String, String> e) => ClosureEnv_buildQuery_1_call(this, e);
}
String ClosureEnv_buildQuery_1_call(ClosureEnv_buildQuery_1 env, MapEntry<String, String> e) {
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
    smAwait(promiseDelayed<dynamic>(Duration(milliseconds: 1)));
    result.add(((i == 0) ? 'Go!' : '${i}...'));
  }
  env._promise.complete(result);
  return;
}
class ClosureEnv_compose_3<C, B, A> extends TypeFunction1<C, A> {
  TypeFunction1<C, B> g;
  TypeFunction1<B, A> f;
  ClosureEnv_compose_3(this.g, this.f);
  @override
  C call(A input) => ClosureEnv_compose_3_call<C, B, A>(this, input);
}
C ClosureEnv_compose_3_call<C, B, A>(ClosureEnv_compose_3<C, B, A> env, A input) {
  return env.g(env.f(input));
}

class ClosureEnv_and_4<T> extends TypeFunction1<bool, T> {
  TypeFunction1<bool, T> p1;
  TypeFunction1<bool, T> p2;
  ClosureEnv_and_4(this.p1, this.p2);
  @override
  bool call(T value) => ClosureEnv_and_4_call<T>(this, value);
}
bool ClosureEnv_and_4_call<T>(ClosureEnv_and_4<T> env, T value) {
  return (env.p1(value) && env.p2(value));
}

class ClosureEnv_main_5 extends TypeFunction1<String, int> {
  ClosureEnv_main_5();
  @override
  String call(int d) => ClosureEnv_main_5_call(this, d);
}
String ClosureEnv_main_5_call(ClosureEnv_main_5 env, int d) {
  return 'got ${d}';
}

class ClosureEnv_main_6 extends TypeFunction1<String, String> {
  ClosureEnv_main_6();
  @override
  String call(String e) => ClosureEnv_main_6_call(this, e);
}
String ClosureEnv_main_6_call(ClosureEnv_main_6 env, String e) {
  return 'error: ${e}';
}

class ClosureEnv_main_7 extends TypeFunction1<String, int> {
  ClosureEnv_main_7();
  @override
  String call(int d) => ClosureEnv_main_7_call(this, d);
}
String ClosureEnv_main_7_call(ClosureEnv_main_7 env, int d) {
  return 'got ${d}';
}

class ClosureEnv_main_8 extends TypeFunction1<String, String> {
  ClosureEnv_main_8();
  @override
  String call(String e) => ClosureEnv_main_8_call(this, e);
}
String ClosureEnv_main_8_call(ClosureEnv_main_8 env, String e) {
  return 'error: ${e}';
}

class ClosureEnv_main_9 extends TypeFunction1<String, int> {
  ClosureEnv_main_9();
  @override
  String call(int d) => ClosureEnv_main_9_call(this, d);
}
String ClosureEnv_main_9_call(ClosureEnv_main_9 env, int d) {
  return 'got ${d}';
}

class ClosureEnv_main_10 extends TypeFunction1<String, String> {
  ClosureEnv_main_10();
  @override
  String call(String e) => ClosureEnv_main_10_call(this, e);
}
String ClosureEnv_main_10_call(ClosureEnv_main_10 env, String e) {
  return 'error: ${e}';
}

class ClosureEnv_main_11 extends TypeFunction1<String, int> {
  ClosureEnv_main_11();
  @override
  String call(int d) => ClosureEnv_main_11_call(this, d);
}
String ClosureEnv_main_11_call(ClosureEnv_main_11 env, int d) {
  return 'got ${d}';
}

class ClosureEnv_main_12 extends TypeFunction1<String, String> {
  ClosureEnv_main_12();
  @override
  String call(String e) => ClosureEnv_main_12_call(this, e);
}
String ClosureEnv_main_12_call(ClosureEnv_main_12 env, String e) {
  return 'error: ${e}';
}

class ClosureEnv_main_13 extends TypeFunction1<int, int> {
  ClosureEnv_main_13();
  @override
  int call(int x) => ClosureEnv_main_13_call(this, x);
}
int ClosureEnv_main_13_call(ClosureEnv_main_13 env, int x) {
  return (x * 2);
}

class ClosureEnv_main_14 extends TypeFunction1<String, int> {
  ClosureEnv_main_14();
  @override
  String call(int x) => ClosureEnv_main_14_call(this, x);
}
String ClosureEnv_main_14_call(ClosureEnv_main_14 env, int x) {
  return 'result=${x}';
}

class ClosureEnv_main_15 extends TypeFunction1<bool, int> {
  ClosureEnv_main_15();
  @override
  bool call(int n) => ClosureEnv_main_15_call(this, n);
}
bool ClosureEnv_main_15_call(ClosureEnv_main_15 env, int n) {
  return (n > 0);
}

class ClosureEnv_main_16 extends TypeFunction1<bool, int> {
  ClosureEnv_main_16();
  @override
  bool call(int n) => ClosureEnv_main_16_call(this, n);
}
bool ClosureEnv_main_16_call(ClosureEnv_main_16 env, int n) {
  return ((n % 2) == 0);
}

class ClosureEnv_main_17 extends TypeFunction1<StaticList<int>, int> {
  ClosureEnv_main_17();
  @override
  StaticList<int> call(int x) => ClosureEnv_main_17_call(this, x);
}
StaticList<int> ClosureEnv_main_17_call(ClosureEnv_main_17 env, int x) {
  return StaticList<int>.of([x, (x * x)]);
}

class ClosureEnv_main_18 extends TypeFunction1<String, int> {
  ClosureEnv_main_18();
  @override
  String call(int x) => ClosureEnv_main_18_call(this, x);
}
String ClosureEnv_main_18_call(ClosureEnv_main_18 env, int x) {
  return 'n=${x}';
}

class ClosureEnv_main_19 extends TypeFunction1<String, String> {
  ClosureEnv_main_19();
  @override
  String call(String s) => ClosureEnv_main_19_call(this, s);
}
String ClosureEnv_main_19_call(ClosureEnv_main_19 env, String s) {
  return '${s}!';
}

class ClosureEnv_main_20 extends TypeFunction1<bool, String> {
  ClosureEnv_main_20();
  @override
  bool call(String s) => ClosureEnv_main_20_call(this, s);
}
bool ClosureEnv_main_20_call(ClosureEnv_main_20 env, String s) {
  return s.startsWith('b');
}

class ClosureEnv_main_21 extends TypeFunction1<bool, String> {
  ClosureEnv_main_21();
  @override
  bool call(String s) => ClosureEnv_main_21_call(this, s);
}
bool ClosureEnv_main_21_call(ClosureEnv_main_21 env, String s) {
  return s.startsWith('z');
}

class ClosureEnv_main_22 extends TypeFunction1<String, int> {
  ClosureEnv_main_22();
  @override
  String call(int n) => ClosureEnv_main_22_call(this, n);
}
String ClosureEnv_main_22_call(ClosureEnv_main_22 env, int n) {
  return 'val=${n}';
}

class ClosureEnv_main_23 extends TypeFunction1<int, String> {
  ClosureEnv_main_23();
  @override
  int call(String s) => ClosureEnv_main_23_call(this, s);
}
int ClosureEnv_main_23_call(ClosureEnv_main_23 env, String s) {
  return s.length;
}

class ClosureEnv_main_24 extends TypeFunction1<int, String> {
  ClosureEnv_main_24();
  @override
  int call(String s) => ClosureEnv_main_24_call(this, s);
}
int ClosureEnv_main_24_call(ClosureEnv_main_24 env, String s) {
  return s.length;
}

class ClosureEnv_main_25 extends TypeFunction1<String, int> {
  ClosureEnv_main_25();
  @override
  String call(int len) => ClosureEnv_main_25_call(this, len);
}
String ClosureEnv_main_25_call(ClosureEnv_main_25 env, int len) {
  return 'len=${len}';
}

class ClosureEnv_main_26 extends TypeFunction1<String, int> {
  ClosureEnv_main_26();
  @override
  String call(int len) => ClosureEnv_main_26_call(this, len);
}
String ClosureEnv_main_26_call(ClosureEnv_main_26 env, int len) {
  return 'len=${len}';
}


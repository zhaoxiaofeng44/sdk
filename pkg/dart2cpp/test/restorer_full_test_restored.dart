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

typedef VoidCallback = void Function();

// mixin Printable → static functions for delegation
void Printable_printInfo(dynamic this__) {
  final this_ = this__;
  print('[${(this_.vptr['get_displayName'] as String Function(dynamic))(this_)}]');
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
}

AnimalValue Animal_new(dynamic this__, String name, int age) {
  final this_ = this__ as AnimalValue;
  this_.vptr['speak'] = Animal_speak;
  this_.vptr['toString'] = Animal_toString;
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
}

DogValue Dog_new(dynamic this__, String name, int age, String breed) {
  final this_ = this__ as DogValue;
  Animal_new(this_, name, age);
  Dog_Animal_Printable_Orderable_init(this_);
  this_.vptr['speak'] = Dog_speak;
  this_.vptr['toString'] = Dog_toString;
  this_.vptr['get_displayName'] = Dog_get_displayName;
  this_.vptr['printInfo'] = Dog_printInfo;
  this_.vptr['compareTo'] = Dog_compareTo;
  this_.vptr['isLessThan'] = Dog_isLessThan;
  this_.vptr['isGreaterThan'] = Dog_isGreaterThan;
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
}

CatValue Cat_new(dynamic this__, String name, int age) {
  final this_ = this__ as CatValue;
  Animal_new(this_, name, age);
  Cat_Animal_Printable_init(this_);
  this_.vptr['speak'] = Cat_speak;
  this_.vptr['toString'] = Cat_toString;
  this_.vptr['get_displayName'] = Cat_get_displayName;
  this_.vptr['printInfo'] = Cat_printInfo;
  this_.vptr['get_mood'] = Cat_get_mood;
  this_.vptr['set_mood'] = Cat_set_mood;
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
}

Vector2DValue Vector2D_new(dynamic this__, double x, double y) {
  final this_ = this__ as Vector2DValue;
  this_.vptr['operatorPlus'] = Vector2D_operatorPlus;
  this_.vptr['operatorMinus'] = Vector2D_operatorMinus;
  this_.vptr['operatorStar'] = Vector2D_operatorStar;
  this_.vptr['operatorEq'] = Vector2D_operatorEq;
  this_.vptr['get_length'] = Vector2D_get_length;
  this_.vptr['toString'] = Vector2D_toString;
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
}

int Counter__instanceCount = 0;
const int Counter_maxValue = 100;
CounterValue Counter_new__(dynamic this__, String label, int _value) {
  final this_ = this__ as CounterValue;
  this_.vptr['increment'] = Counter_increment;
  this_.vptr['decrement'] = Counter_decrement;
  this_.vptr['get_value'] = Counter_get_value;
  this_.vptr['toString'] = Counter_toString;
  this_.label = label;
  this_._value = _value;
  Counter__instanceCount = (Counter__instanceCount + 1);
  return this_;
}

CounterValue Counter_new(String label, {int initialValue = 0}) {
  return Counter_new__(CounterValue(), label, initialValue);
}

CounterValue Counter_new_fromString(String spec) {
  final List<String> parts = spec.split(':');
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
}

ResultValue<T> Result_new_success<T>(dynamic this__, T value) {
  final this_ = this__ as ResultValue<T>;
  this_.vptr['fold_String'] = Result_fold<T, String>;
  this_.vptr['toString'] = Result_toString<T>;
  this_.data = value;
  this_.error = null;
  this_.isSuccess = true;
  return this_;
}

ResultValue<T> Result_new_failure<T>(dynamic this__, String message) {
  final this_ = this__ as ResultValue<T>;
  this_.vptr['fold_String'] = Result_fold<T, String>;
  this_.vptr['toString'] = Result_toString<T>;
  this_.data = null;
  this_.error = message;
  this_.isSuccess = false;
  return this_;
}

R Result_fold<T, R>(dynamic this__, {required R Function(T) onSuccess, required R Function(String) onFailure}) {
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
}

LazyLoaderValue LazyLoader_new(dynamic this__) {
  final this_ = this__ as LazyLoaderValue;
  this_.vptr['initialize'] = LazyLoader_initialize;
  this_.vptr['get_data'] = LazyLoader_get_data;
  this_.vptr['get_computedValue'] = LazyLoader_get_computedValue;
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
}

BoundedValueValue BoundedValue_new(dynamic this__, double min, double max, double initial) {
  final this_ = this__ as BoundedValueValue;
  this_.vptr['set'] = BoundedValue_set;
  this_.vptr['get_current'] = BoundedValue_get_current;
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
}

ShapeValue Shape_new(dynamic this__, String color, {double opacity = 1.0}) {
  final this_ = this__ as ShapeValue;
  this_.vptr['describe'] = Shape_describe;
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
}

PolygonValue Polygon_new(dynamic this__, String color, int sides, {double opacity = 1.0}) {
  final this_ = this__ as PolygonValue;
  Shape_new(this_, color, opacity: opacity);
  this_.vptr['describe'] = Polygon_describe;
  this_.vptr['perimeter'] = Polygon_perimeter;
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
}

RegularPolygonValue RegularPolygon_new(dynamic this__, String color, int sides, double sideLength, {double opacity = 1.0}) {
  final this_ = this__ as RegularPolygonValue;
  Polygon_new(this_, color, sides, opacity: opacity);
  this_.vptr['describe'] = RegularPolygon_describe;
  this_.vptr['perimeter'] = RegularPolygon_perimeter;
  this_.vptr['area'] = RegularPolygon_area;
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
}

SquareValue Square_new(dynamic this__, String color, double size, {double opacity = 1.0}) {
  final this_ = this__ as SquareValue;
  RegularPolygon_new(this_, color, 4, size, opacity: opacity);
  this_.vptr['describe'] = Square_describe;
  this_.vptr['perimeter'] = Square_perimeter;
  this_.vptr['area'] = Square_area;
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
}

SerializableValue Serializable_new(dynamic this__) {
  final this_ = this__ as SerializableValue;
  this_.vptr['serialize'] = Serializable_serialize;
  return this_;
}

String Serializable_serialize(dynamic this_) {
  throw UnimplementedError('Serializable.serialize is abstract');
}


class CloneableValue<T> extends VPtr {
}

CloneableValue<T> Cloneable_new<T>(dynamic this__) {
  final this_ = this__ as CloneableValue<T>;
  this_.vptr['clone'] = Cloneable_clone<T>;
  return this_;
}

T Cloneable_clone<T>(dynamic this_) {
  throw UnimplementedError('Cloneable.clone is abstract');
}


class Comparable2Value<T> extends VPtr {
}

Comparable2Value<T> Comparable2_new<T>(dynamic this__) {
  final this_ = this__ as Comparable2Value<T>;
  this_.vptr['compareTo2'] = Comparable2_compareTo2<T>;
  return this_;
}

int Comparable2_compareTo2<T>(dynamic this_, T other) {
  throw UnimplementedError('Comparable2.compareTo2 is abstract');
}


class DataPointValue extends VPtr implements SerializableValue, CloneableValue<DataPointValue>, Comparable2Value<DataPointValue> {
  late double x;
  late double y;
  late String label;
}

DataPointValue DataPoint_new(dynamic this__, double x, double y, String label) {
  final this_ = this__ as DataPointValue;
  this_.vptr['serialize'] = DataPoint_serialize;
  this_.vptr['clone'] = DataPoint_clone;
  this_.vptr['compareTo2'] = DataPoint_compareTo2;
  this_.vptr['toString'] = DataPoint_toString;
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
  print('[${(this_.vptr['get_logTag'] as String Function(dynamic))(this_)}] ${message}');
}


// mixin Validatable → static functions for delegation
bool Validatable_validate(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['serialize'] as String Function(dynamic))(this_).isNotEmpty;
}


class LoggedDataPointValue extends LoggedDataPoint_DataPoint_Loggable_ValidatableValue {
}

LoggedDataPointValue LoggedDataPoint_new(dynamic this__, double x, double y, String label) {
  final this_ = this__ as LoggedDataPointValue;
  DataPoint_new(this_, x, y, label);
  LoggedDataPoint_DataPoint_Loggable_Validatable_init(this_);
  this_.vptr['serialize'] = LoggedDataPoint_serialize;
  this_.vptr['clone'] = LoggedDataPoint_clone;
  this_.vptr['compareTo2'] = LoggedDataPoint_compareTo2;
  this_.vptr['toString'] = LoggedDataPoint_toString;
  this_.vptr['get_logTag'] = LoggedDataPoint_get_logTag;
  this_.vptr['log'] = LoggedDataPoint_log;
  this_.vptr['validate'] = LoggedDataPoint_validate;
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
}

ConfigValue Config_new(dynamic this__, String host, int port, {bool secure = false}) {
  final this_ = this__ as ConfigValue;
  this_.vptr['toString'] = Config_toString;
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
  late List<T> _items;
}

SortedListValue<T> SortedList_new<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  this_.vptr['add'] = SortedList_add<T>;
  this_.vptr['get_first'] = SortedList_get_first<T>;
  this_.vptr['get_last'] = SortedList_get_last<T>;
  this_.vptr['get_length'] = SortedList_get_length<T>;
  this_.vptr['toList'] = SortedList_toList<T>;
  this_.vptr['toString'] = SortedList_toString<T>;
  this_._items = <T>[];
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

List<T> SortedList_toList<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  return List.unmodifiable(this_._items);
}

String SortedList_toString<T extends Comparable<dynamic>>(dynamic this__) {
  final this_ = this__ as SortedListValue<T>;
  return 'SortedList(${this_._items})';
}


class NullSafetyDemoValue extends VPtr {
  late String? nullableField;
  late String nonNullField;
}

NullSafetyDemoValue NullSafetyDemo_new(dynamic this__, String nonNullField, [String? nullableField = null]) {
  final this_ = this__ as NullSafetyDemoValue;
  this_.vptr['demonstrate'] = NullSafetyDemo_demonstrate;
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
}

RendererValue Renderer_new(dynamic this__) {
  final this_ = this__ as RendererValue;
  this_.vptr['render'] = Renderer_render;
  this_.vptr['get_name'] = Renderer_get_name;
  return this_;
}

void Renderer_render(dynamic this_, Object shape) {
  throw UnimplementedError('Renderer.render is abstract');
}

String Renderer_get_name(dynamic this_) {
  throw UnimplementedError('Renderer.name is abstract');
}


class CircleRendererValue extends RendererValue {
}

CircleRendererValue CircleRenderer_new(dynamic this__) {
  final this_ = this__ as CircleRendererValue;
  Renderer_new(this_);
  this_.vptr['render'] = CircleRenderer_render;
  this_.vptr['get_name'] = CircleRenderer_get_name;
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
  late TOutput Function(TInput) _transform;
}

PipelineValue<TInput, TOutput> Pipeline_new<TInput, TOutput>(dynamic this__, TOutput Function(TInput) _transform) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  this_.vptr['execute'] = Pipeline_execute<TInput, TOutput>;
  this_.vptr['then_String'] = Pipeline_then<TInput, TOutput, String>;
  this_.vptr['then_int'] = Pipeline_then<TInput, TOutput, int>;
  this_._transform = _transform;
  return this_;
}

TOutput Pipeline_execute<TInput, TOutput>(dynamic this__, TInput input) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  return (() { final _let4 = input; return this_._transform(_let4); })();
}

PipelineValue<TInput, TNewOutput> Pipeline_then<TInput, TOutput, TNewOutput>(dynamic this__, TNewOutput Function(TOutput) next_raw) {
  final this_ = this__ as PipelineValue<TInput, TOutput>;
  ObjectBox<TNewOutput Function(TOutput)> next = ObjectBox<TNewOutput Function(TOutput)>(next_raw);
  return Pipeline_new<TInput, TNewOutput>(PipelineValue<TInput, TNewOutput>(), ClosureEnv_anon_0(this_, next).call);
}


class BitFlagsValue extends VPtr {
  late int _flags;
}

const int BitFlags_read = 1;
const int BitFlags_write = 2;
const int BitFlags_execute = 4;
BitFlagsValue BitFlags_new(dynamic this__, [int _flags = 0]) {
  final this_ = this__ as BitFlagsValue;
  this_.vptr['set'] = BitFlags_set;
  this_.vptr['clear'] = BitFlags_clear;
  this_.vptr['has'] = BitFlags_has;
  this_.vptr['toString'] = BitFlags_toString;
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
  final List<String> parts = <String>[];
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

List<String> Tagged_get_tags(dynamic this__) {
  final this_ = this__;
  return List.unmodifiable(this_._tags);
}


class EventValue extends Event_Object_Timestamped_TaggedValue {
  late String name;
}

EventValue Event_new(dynamic this__, String name) {
  final this_ = this__ as EventValue;
  Event_Object_Timestamped_Tagged_init(this_);
  this_.vptr['get_timestamp'] = Event_get_timestamp;
  this_.vptr['get_timeStr'] = Event_get_timeStr;
  this_.vptr['addTag'] = Event_addTag;
  this_.vptr['get_tags'] = Event_get_tags;
  this_.vptr['toString'] = Event_toString;
  this_.name = name;
  this_._tags = <String>[];
  return this_;
}

String Event_toString(dynamic this__) {
  final this_ = this__ as EventValue;
  return 'Event(${this_.name}, ${(this_.vptr['get_timeStr'] as String Function(dynamic))(this_)}, tags=${(this_.vptr['get_tags'] as List<String> Function(dynamic))(this_)})';
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

List<String> Event_get_tags(dynamic this__) {
  final this_ = this__ as EventValue;
  return Tagged_get_tags(this_);
}


class ImportantEventValue extends ImportantEvent_Event_LoggableValue {
  late Priority priority;
}

ImportantEventValue ImportantEvent_new(dynamic this__, String name, Priority priority) {
  final this_ = this__ as ImportantEventValue;
  Event_new(this_, name);
  ImportantEvent_Event_Loggable_init(this_);
  this_.vptr['get_timestamp'] = ImportantEvent_get_timestamp;
  this_.vptr['get_timeStr'] = ImportantEvent_get_timeStr;
  this_.vptr['addTag'] = ImportantEvent_addTag;
  this_.vptr['get_tags'] = ImportantEvent_get_tags;
  this_.vptr['toString'] = ImportantEvent_toString;
  this_.vptr['get_logTag'] = ImportantEvent_get_logTag;
  this_.vptr['log'] = ImportantEvent_log;
  this_.priority = priority;
  this_._tags = <String>[];
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

List<String> ImportantEvent_get_tags(dynamic this__) {
  final this_ = this__ as ImportantEventValue;
  return Tagged_get_tags(this_);
}

void ImportantEvent_log(dynamic this__, String message) {
  final this_ = this__ as ImportantEventValue;
  Loggable_log(this_, message);
}


class Dog_Animal_PrintableValue extends AnimalValue {
}

void Dog_Animal_Printable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['printInfo'] = Printable_printInfo;
}


class Dog_Animal_Printable_OrderableValue extends Dog_Animal_PrintableValue {
}

void Dog_Animal_Printable_Orderable_init(dynamic this__) {
  Dog_Animal_Printable_init(this__);
  final this_ = this__;
  this_.vptr['isLessThan'] = Orderable_isLessThan;
  this_.vptr['isGreaterThan'] = Orderable_isGreaterThan;
}


class Cat_Animal_PrintableValue extends AnimalValue {
}

void Cat_Animal_Printable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['printInfo'] = Printable_printInfo;
}


class LoggedDataPoint_DataPoint_LoggableValue extends DataPointValue {
}

void LoggedDataPoint_DataPoint_Loggable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['log'] = Loggable_log;
}


class LoggedDataPoint_DataPoint_Loggable_ValidatableValue extends LoggedDataPoint_DataPoint_LoggableValue {
}

void LoggedDataPoint_DataPoint_Loggable_Validatable_init(dynamic this__) {
  LoggedDataPoint_DataPoint_Loggable_init(this__);
  final this_ = this__;
  this_.vptr['validate'] = Validatable_validate;
}


class Event_Object_TimestampedValue extends VPtr {
}

void Event_Object_Timestamped_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['get_timestamp'] = Timestamped_get_timestamp;
  this_.vptr['get_timeStr'] = Timestamped_get_timeStr;
}


class Event_Object_Timestamped_TaggedValue extends Event_Object_TimestampedValue {
  late List<String> _tags;
}

void Event_Object_Timestamped_Tagged_init(dynamic this__) {
  Event_Object_Timestamped_init(this__);
  final this_ = this__;
  this_.vptr['addTag'] = Tagged_addTag;
  this_.vptr['get_tags'] = Tagged_get_tags;
}


class ImportantEvent_Event_LoggableValue extends EventValue {
}

void ImportantEvent_Event_Loggable_init(dynamic this__) {
  final this_ = this__;
  this_.vptr['log'] = Loggable_log;
}


String formatMessage(String template, [String? subject = null, int? count = null]) {
  String result = template;
  if (!((subject == null)))   result = result.replaceAll('{subject}', subject);
  if (!((count == null)))   result = result.replaceAll('{count}', count.toString());
  return result;
}

String buildQuery({required String endpoint, Map<String, String>? params = null, int maxWait = 30, bool secure = true}) {
  final String scheme = (secure ? 'https' : 'http');
  final String query = ((() { final _let7 = params; return (_let7 == null) ? null : _let7.entries.map((MapEntry<String, String> e) => '${e.key}=${e.value}').join('&'); })() ?? '');
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

Stream<String> countDown(int from) async* {
  for (var i = from; (i >= 0); i = (i - 1)) {
    await Future.delayed(Duration(milliseconds: 1));
    yield ((i == 0) ? 'Go!' : '${i}...');
  }
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
        late List<dynamic> list;
        if ((((_v9 is List<dynamic>) && (() { final _let12 = list = _v9; return true; })()) && list.isEmpty)) {
          _v8 = 'empty list';
          break;
        }
      }
{
        late List<dynamic> list;
        if ((_v9 is List<dynamic>)) {
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

List<int> buildList() {
  return (<int>[]..add(1)..add(2)..addAll(<int>[3, 4, 5])..sort());
}

StringBuffer buildBuffer() {
  return (StringBuffer()..write('Hello')..write(', ')..write('World')..writeln('!'));
}

List<int> mergeAndFilter(List<int> a, List<int> b, bool includeNegative) {
  return (() {   final List<int> _v15 = List.of(a);
  _v15.addAll(b);
  if (includeNegative)   _v15.add((-1));
  for (var i = 10; (i <= 12); i = (i + 1))   _v15.add(i);
 return _v15; })();
}

Map<String, int> buildScoreMap(List<String> names, bool addBonus) {
  return (() {   final Map<String, int> _v16 = <String, int>{};
  for (var i = 0; (i < names.length); i = (i + 1))   _v16[names[i]] = ((i + 1) * 10);
  if (addBonus)   _v16['bonus'] = 999;
 return _v16; })();
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

C Function(A) compose<A, B, C>(B Function(A) f_raw, C Function(B) g_raw) {
  ObjectBox<B Function(A)> f = ObjectBox<B Function(A)>(f_raw);
  ObjectBox<C Function(B)> g = ObjectBox<C Function(B)>(g_raw);
  return ClosureEnv_compose_1(g, f).call;
}

bool Function(T) and<T>(bool Function(T) p1_raw, bool Function(T) p2_raw) {
  ObjectBox<bool Function(T)> p1 = ObjectBox<bool Function(T)>(p1_raw);
  ObjectBox<bool Function(T)> p2 = ObjectBox<bool Function(T)>(p2_raw);
  return ClosureEnv_and_2(p1, p2).call;
}

List<B> flatMap<A, B>(List<A> list, List<B> Function(A) f) {
  return list.expand(f).toList();
}

T findMax<T extends Comparable<dynamic>>(List<T> items) {
  T maxItem = items.first;
  for (final item in items) {
    if ((item.compareTo(maxItem) > 0)) {
      maxItem = item;
    }
  }
  return maxItem;
}

R applyTwice<T, R>(T value, R Function(T) fn1, R Function(R) fn2) {
  return fn2(fn1(value));
}

String? findFirst(List<String> items, bool Function(String) test) {
  for (final item in items) {
    if (test(item))     return item;
  }
  return null;
}

List<int> filterWithForIn(List<int> items) {
  final List<int> result = <int>[];
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
 else   if ((value is List<int>)) {
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

void main() async {
  print('=== 全面语法节点还原测试 ===\n');
  print('--- 1. mixin + implements ---');
  final DogValue dog1 = Dog_new(DogValue(), 'Rex', 3, 'Labrador');
  final DogValue dog2 = Dog_new(DogValue(), 'Max', 5, 'Poodle');
  (dog1.vptr['printInfo'] as void Function(dynamic))(dog1);
  print('${(dog1.vptr['speak'] as String Function(dynamic))(dog1)} (${dog1.breed})');
  print('dog1 < dog2: ${(dog1.vptr['isLessThan'] as bool Function(dynamic, DogValue))(dog1, dog2)}');
  print('dog1 > dog2: ${(dog1.vptr['isGreaterThan'] as bool Function(dynamic, DogValue))(dog1, dog2)}');
  final CatValue cat = Cat_new(CatValue(), 'Whiskers', 2);
  (cat.vptr['printInfo'] as void Function(dynamic))(cat);
  print('${(cat.vptr['speak'] as String Function(dynamic))(cat)}, mood: ${(cat.vptr['get_mood'] as String Function(dynamic))(cat)}');
  (cat.vptr['set_mood'] as void Function(dynamic, String))(cat, 'sleepy');
  print('mood after set: ${(cat.vptr['get_mood'] as String Function(dynamic))(cat)}');
  print('\n--- 2. operator 重载 ---');
  final Vector2DValue sum = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorPlus'] as Vector2DValue Function(dynamic, Vector2DValue))(Vector2D_new(Vector2DValue(), 3.0, 4.0), Vector2D_new(Vector2DValue(), 1.0, 2.0));
  final Vector2DValue diff = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorMinus'] as Vector2DValue Function(dynamic, Vector2DValue))(Vector2D_new(Vector2DValue(), 3.0, 4.0), Vector2D_new(Vector2DValue(), 1.0, 2.0));
  final Vector2DValue scaled = (Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['operatorStar'] as Vector2DValue Function(dynamic, double))(Vector2D_new(Vector2DValue(), 3.0, 4.0), 2.0);
  print('v1 + v2 = ${sum}');
  print('v1 - v2 = ${diff}');
  print('v1 * 2 = ${scaled}');
  print('v1.length = ${(Vector2D_new(Vector2DValue(), 3.0, 4.0).vptr['get_length'] as double Function(dynamic))(Vector2D_new(Vector2DValue(), 3.0, 4.0)).toStringAsFixed(2)}');
  print('v1 == Vector2D(3,4): ${(Vector2D_new(Vector2DValue(), 3.0, 4.0) == Vector2D_new(Vector2DValue(), 3.0, 4.0))}');
  print('\n--- 3. static + factory ---');
  final CounterValue c1 = Counter_new('alpha');
  final CounterValue c2 = Counter_new('beta', initialValue: 50);
  final CounterValue c3 = Counter_new_fromString('gamma:25');
  (c1.vptr['increment'] as void Function(dynamic, int))(c1, 10);
  (c2.vptr['decrement'] as void Function(dynamic, int))(c2, 5);
  (c3.vptr['increment'] as void Function(dynamic, int))(c3, 1);
  print('${c1}, ${c2}, ${c3}');
  print('instances: ${Counter_instanceCount()}');
  print('maxValue: 100');
  print('\n--- 4. Result<T> + named params ---');
  print('ok: ${Result_new_success<int>(ResultValue<int>(), 42)}');
  print('err: ${Result_new_failure<int>(ResultValue<int>(), 'not found')}');
  final String okMsg = (Result_new_success<int>(ResultValue<int>(), 42).vptr['fold_String'] as String Function(dynamic, {required String Function(String) onFailure, required String Function(int) onSuccess}))(Result_new_success<int>(ResultValue<int>(), 42), onSuccess: (int d) => 'got ${d}', onFailure: (String e) => 'error: ${e}');
  final String errMsg = (Result_new_failure<int>(ResultValue<int>(), 'not found').vptr['fold_String'] as String Function(dynamic, {required String Function(String) onFailure, required String Function(int) onSuccess}))(Result_new_failure<int>(ResultValue<int>(), 'not found'), onSuccess: (int d) => 'got ${d}', onFailure: (String e) => 'error: ${e}');
  print('okMsg: ${okMsg}');
  print('errMsg: ${errMsg}');
  print('\n--- 5. 可选参数 ---');
  print(formatMessage('Hello {subject}!', 'Dart'));
  print(formatMessage('Count: {count}', null, 99));
  print(formatMessage('No params'));
  print(buildQuery(endpoint: 'api.example.com/users'));
  print(buildQuery(endpoint: 'api.example.com/search', params: <String, String>{'q': 'dart', 'page': '1'}, maxWait: 10, secure: false));
  print('\n--- 6. sync* 生成器 ---');
  final List<int> r = range(0, 10, 2).toList();
  print('range(0,10,2): ${r}');
  final List<int> fib = fibonacci(8).toList();
  print('fibonacci(8): ${fib}');
  print('\n--- 7. async* 生成器 ---');
  final List<String> countdown = await countDown(3).toList();
  print('countdown: ${countdown}');
  print('\n--- 8. record 类型 ---');
  final (String, int) person = getPersonRecord();
  print('person: ${person.$1}, age=${person.$2}');
  final (String, double, double) loc = getLocation();
  print('location: ${loc.$1} (${loc.$2}, ${loc.$3})');
  final int q;
  final int r2;
{
    final (int, int) _v9 = divmod(17, 5);
    q = _v9.$1;
    r2 = _v9.$2;
  }
  print('divmod(17,5): quotient=${q}, remainder=${r2}');
  print('\n--- 9. pattern matching ---');
  final List<Object?> values = <Object?>[null, (-5), 42, '', 'hello', <int>[], <int>[1, 2, 3]];
  for (final v in values) {
    print('  ${describeValue(v)}');
  }
  print('\n--- 10. 级联操作符 ---');
  final List<int> list = buildList();
  print('buildList: ${list}');
  final StringBuffer buf = buildBuffer();
  print('buildBuffer: ${buf.toString().trim()}');
  print('\n--- 11. 展开 + 集合 if/for ---');
  final List<int> merged = mergeAndFilter(<int>[1, 2], <int>[3, 4], true);
  print('merged(includeNeg=true): ${merged}');
  final List<int> mergedNoNeg = mergeAndFilter(<int>[1, 2], <int>[3, 4], false);
  print('merged(includeNeg=false): ${mergedNoNeg}');
  final Map<String, int> scores = buildScoreMap(<String>['Alice', 'Bob', 'Carol'], true);
  print('scores: ${scores}');
  print('\n--- 12. late 变量 ---');
  final LazyLoaderValue loader = LazyLoader_new(LazyLoaderValue());
  print('before init: ${(loader.vptr['get_data'] as String Function(dynamic))(loader)}, ${(loader.vptr['get_computedValue'] as int Function(dynamic))(loader)}');
  (loader.vptr['initialize'] as void Function(dynamic, String))(loader, 'hello');
  print('after init: ${(loader.vptr['get_data'] as String Function(dynamic))(loader)}, ${(loader.vptr['get_computedValue'] as int Function(dynamic))(loader)}');
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
  (bv.vptr['set'] as void Function(dynamic, double))(bv, 7.5);
  print('BoundedValue: ${(bv.vptr['get_current'] as double Function(dynamic))(bv)}');
  print('\n--- 15. 字符串 ---');
  print(multiLineExample());
  print('\n--- 16. typedef + 函数式组合 ---');
  final String Function(int) doubleIt = compose<int, int, String>((int x) => (x * 2), (int x) => 'result=${x}');
  print('compose(5): ${doubleIt(5)}');
  final bool Function(int) isPositive = (int n) => (n > 0);
  final bool Function(int) isEven = (int n) => ((n % 2) == 0);
  final bool Function(int) isPositiveEven = and<int>(isPositive, isEven);
  final List<int> nums = <int>[(-2), (-1), 0, 1, 2, 3, 4];
  print('positiveEvens: ${nums.where(isPositiveEven).toList()}');
  final List<int> nested = flatMap<int, int>(<int>[1, 2, 3], (int x) => <int>[x, (x * x)]);
  print('flatMap: ${nested}');
  print('\n--- 19. 多层继承链 ---');
  final ShapeValue shape = Shape_new(ShapeValue(), 'red');
  print((shape.vptr['describe'] as String Function(dynamic))(shape));
  final ShapeValue transparentShape = Shape_new_transparent(ShapeValue(), 'blue');
  print((transparentShape.vptr['describe'] as String Function(dynamic))(transparentShape));
  final PolygonValue polygon = Polygon_new(PolygonValue(), 'green', 6, opacity: 0.8);
  print((polygon.vptr['describe'] as String Function(dynamic))(polygon));
  print('perimeter: ${(polygon.vptr['perimeter'] as double Function(dynamic, double))(polygon, 3.0)}');
  final RegularPolygonValue hexagon = RegularPolygon_new(RegularPolygonValue(), 'yellow', 6, 5.0);
  print((hexagon.vptr['describe'] as String Function(dynamic))(hexagon));
  print('perimeter: ${(hexagon.vptr['perimeter'] as double Function(dynamic, double?))(hexagon, null)}');
  print('area: ${(hexagon.vptr['area'] as double Function(dynamic))(hexagon)}');
  final SquareValue square = Square_new(SquareValue(), 'white', 10.0, opacity: 0.9);
  print((square.vptr['describe'] as String Function(dynamic))(square));
  print('square perimeter: ${(square.vptr['perimeter'] as double Function(dynamic, double?))(square, null)}');
  print('\n--- 20. implements 多接口 ---');
  final DataPointValue dp1 = DataPoint_new(DataPointValue(), 1.0, 2.0, 'A');
  final DataPointValue dp2 = DataPoint_new(DataPointValue(), 3.0, 1.0, 'B');
  print('dp1: ${dp1}');
  print('dp1.serialize: ${(dp1.vptr['serialize'] as String Function(dynamic))(dp1)}');
  final DataPointValue dp1Clone = (dp1.vptr['clone'] as DataPointValue Function(dynamic))(dp1);
  print('dp1.clone: ${dp1Clone}');
  print('dp1.compareTo2(dp2): ${(dp1.vptr['compareTo2'] as int Function(dynamic, DataPointValue))(dp1, dp2)}');
  print('\n--- 21. mixin on 约束 ---');
  final LoggedDataPointValue ldp = LoggedDataPoint_new(LoggedDataPointValue(), 5.0, 6.0, 'logged');
  (ldp.vptr['log'] as void Function(dynamic, String))(ldp, 'created');
  print('validate: ${(ldp.vptr['validate'] as bool Function(dynamic))(ldp)}');
  print('serialize: ${(ldp.vptr['serialize'] as String Function(dynamic))(ldp)}');
  print('\n--- 22. 增强枚举 ---');
  print('Priority.high: ${Priority}.high');
  print('high > medium: ${Priority_isHigherThan(Priority.high, Priority.medium)}');
  print('low > high: ${Priority_isHigherThan(Priority.low, Priority.high)}');
  for (final p in const [Priority.low, Priority.medium, Priority.high, Priority.critical]) {
    print('  ${Priority_toString(p)}');
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
  (sortedList.vptr['add'] as void Function(dynamic, int))(sortedList, 5);
  (sortedList.vptr['add'] as void Function(dynamic, int))(sortedList, 1);
  (sortedList.vptr['add'] as void Function(dynamic, int))(sortedList, 3);
  (sortedList.vptr['add'] as void Function(dynamic, int))(sortedList, 2);
  print('sorted: ${sortedList}');
  print('first: ${(sortedList.vptr['get_first'] as dynamic Function(dynamic))(sortedList)}, last: ${(sortedList.vptr['get_last'] as dynamic Function(dynamic))(sortedList)}');
  final int maxVal = findMax<int>(<int>[3, 7, 1, 9, 4]);
  print('findMax: ${maxVal}');
  final String result = applyTwice<int, String>(5, (int x) => 'n=${x}', (String s) => '${s}!');
  print('applyTwice: ${result}');
  print('\n--- 25. null safety ---');
  final NullSafetyDemoValue ns1 = NullSafetyDemo_new(NullSafetyDemoValue(), 'hello', 'world');
  print('ns1: ${(ns1.vptr['demonstrate'] as String Function(dynamic))(ns1)}');
  final NullSafetyDemoValue ns2 = NullSafetyDemo_new(NullSafetyDemoValue(), 'hello');
  print('ns2: ${(ns2.vptr['demonstrate'] as String Function(dynamic))(ns2)}');
  final String? found = findFirst(<String>['apple', 'banana', 'cherry'], (String s) => s.startsWith('b'));
  print('findFirst(b): ${found}');
  final String? notFound = findFirst(<String>['apple', 'banana'], (String s) => s.startsWith('z'));
  print('findFirst(z): ${notFound}');
  print('\n--- 26. for-in + do-while ---');
  final List<int> filtered = filterWithForIn(<int>[5, (-3), 10, 200, 50, (-1), 80]);
  print('filterWithForIn: ${filtered}');
  print('collatz(6): ${collatzSteps(6)}');
  print('collatz(27): ${collatzSteps(27)}');
  print('\n--- 27. 类型测试 ---');
  print(typeTest(42));
  print(typeTest('hello'));
  print(typeTest(true));
  print(typeTest(<int>[1, 2, 3]));
  print('safeCast(3.14): ${safeCast(3.14)}');
  print('safeCast("x"): ${safeCast('x')}');
  print('\n--- 28. try-catch-finally ---');
  print('code=0: ${tryCatchFinally(0)}');
  print('code=1: ${tryCatchFinally(1)}');
  print('code=2: ${tryCatchFinally(2)}');
  print('\n--- 29. covariant ---');
  final CircleRendererValue renderer = CircleRenderer_new(CircleRendererValue());
  print('renderer: ${(renderer.vptr['get_name'] as String Function(dynamic))(renderer)}');
  (renderer.vptr['render'] as void Function(dynamic, String))(renderer, 'circle');
  print('\n--- 30. Pipeline 泛型链 ---');
  final PipelineValue<int, String> pipeline = ((Pipeline_new<int, String>(PipelineValue<int, String>(), (int n) => 'val=${n}').vptr['then_int'] as PipelineValue<int, int> Function(dynamic, int Function(String)))(Pipeline_new<int, String>(PipelineValue<int, String>(), (int n) => 'val=${n}'), (String s) => s.length).vptr['then_String'] as PipelineValue<int, String> Function(dynamic, String Function(int)))((Pipeline_new<int, String>(PipelineValue<int, String>(), (int n) => 'val=${n}').vptr['then_int'] as PipelineValue<int, int> Function(dynamic, int Function(String)))(Pipeline_new<int, String>(PipelineValue<int, String>(), (int n) => 'val=${n}'), (String s) => s.length), (int len) => 'len=${len}');
  print('pipeline(42): ${(pipeline.vptr['execute'] as String Function(dynamic, int))(pipeline, 42)}');
  print('pipeline(12345): ${(pipeline.vptr['execute'] as String Function(dynamic, int))(pipeline, 12345)}');
  print('\n--- 31. switch-case ---');
  print('day 1: ${dayType(1)}');
  print('day 3: ${dayType(3)}');
  print('day 7: ${dayType(7)}');
  print('day 9: ${dayType(9)}');
  print('\n--- 32. 位运算 ---');
  final BitFlagsValue flags = BitFlags_new(BitFlagsValue());
  (flags.vptr['set'] as void Function(dynamic, int))(flags, 1);
  (flags.vptr['set'] as void Function(dynamic, int))(flags, 4);
  print('flags: ${flags}');
  print('has read: ${(flags.vptr['has'] as bool Function(dynamic, int))(flags, 1)}');
  print('has write: ${(flags.vptr['has'] as bool Function(dynamic, int))(flags, 2)}');
  (flags.vptr['set'] as void Function(dynamic, int))(flags, 2);
  print('after set write: ${flags}');
  (flags.vptr['clear'] as void Function(dynamic, int))(flags, 4);
  print('after clear execute: ${flags}');
  print('\n--- 33. 多层 mixin ---');
  final EventValue event = Event_new(EventValue(), 'meeting');
  (event.vptr['addTag'] as void Function(dynamic, String))(event, 'work');
  (event.vptr['addTag'] as void Function(dynamic, String))(event, 'important');
  print(event);
  final ImportantEventValue impEvent = ImportantEvent_new(ImportantEventValue(), 'deadline', Priority.critical);
  (impEvent.vptr['addTag'] as void Function(dynamic, String))(impEvent, 'urgent');
  (impEvent.vptr['log'] as void Function(dynamic, String))(impEvent, 'created');
  print(impEvent);
  print('\n=== 所有测试通过 ✅ ===');
}

class ClosureEnv_anon_0<TNewOutput, TOutput, TInput> {
  PipelineValue<TInput, TOutput> this_;
  ObjectBox<TNewOutput Function(TOutput)> next;
  ClosureEnv_anon_0(this.this_, this.next);
  TNewOutput call(TInput input) => ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>(this, input);
}
TNewOutput ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>(ClosureEnv_anon_0<TNewOutput, TOutput, TInput> env, TInput input) {
  return env.next.value((() { final _let5 = input; return env.this_._transform(_let5); })());
}

class ClosureEnv_compose_1<C, B, A> {
  ObjectBox<C Function(B)> g;
  ObjectBox<B Function(A)> f;
  ClosureEnv_compose_1(this.g, this.f);
  C call(A input) => ClosureEnv_compose_1_call<C, B, A>(this, input);
}
C ClosureEnv_compose_1_call<C, B, A>(ClosureEnv_compose_1<C, B, A> env, A input) {
  return env.g.value(env.f.value(input));
}

class ClosureEnv_and_2<T> {
  ObjectBox<bool Function(T)> p1;
  ObjectBox<bool Function(T)> p2;
  ClosureEnv_and_2(this.p1, this.p2);
  bool call(T value) => ClosureEnv_and_2_call<T>(this, value);
}
bool ClosureEnv_and_2_call<T>(ClosureEnv_and_2<T> env, T value) {
  return (env.p1.value(value) && env.p2.value(value));
}


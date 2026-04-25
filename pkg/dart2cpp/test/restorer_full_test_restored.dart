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

typedef Predicate<T> = bool Function(T);

typedef Transformer<A, B> = B Function(A);

typedef VoidCallback = void Function();

// mixin Printable → static functions for delegation
void Printable_printInfo(dynamic this_) {
  print('[${(this_.vptr['get_displayName'] as Function)(this_)}]');
}


// mixin Orderable → static functions for delegation
bool Orderable_isLessThan<T>(dynamic this_, T other) {
  return ((this_.vptr['compareTo'] as Function)(this_, other) < 0);
}

bool Orderable_isGreaterThan<T>(dynamic this_, T other) {
  return ((this_.vptr['compareTo'] as Function)(this_, other) > 0);
}


class AnimalValue extends VPtr {
  late String name;
  late int age;
}

void Animal_new(AnimalValue this_, String name, int age) {
  this_.vptr = {
    'speak': Animal_speak,
    'toString_': Animal_toString,
  };
  this_.name = name;
  this_.age = age;
}

String Animal_speak(AnimalValue this_) {
  throw UnimplementedError('Animal.speak is abstract');
}

String Animal_toString(AnimalValue this_) {
  return '${this_.name}(age=${this_.age})';
}


class DogValue extends Dog_Animal_Printable_OrderableValue {
  late String name;
  late int age;
  late String breed;
}

void Dog_new(DogValue this_, String name, int age, String breed) {
  Animal_new(this_, name, age);
  this_.vptr = {
    'speak': Dog_speak,
    'toString_': Dog_toString,
    'get_displayName': Dog_get_displayName,
    'printInfo': Dog_printInfo,
    'compareTo': Dog_compareTo,
    'isLessThan': Dog_isLessThan,
    'isGreaterThan': Dog_isGreaterThan,
  };
  this_.breed = breed;
}

String Dog_get_displayName(DogValue this_) {
  return 'Dog:${this_.name}';
}

String Dog_speak(AnimalValue this__) {
  final this_ = this__ as DogValue;
  return 'Woof!';
}

int Dog_compareTo(DogValue this_, DogValue other) {
  return this_.age.compareTo(other.age);
}

String Dog_toString(AnimalValue this_) {
  return Animal_toString(this_);
}

void Dog_printInfo(DogValue this_) {
  Printable_printInfo(this_);
}

bool Dog_isLessThan(DogValue this_, DogValue other) {
  return Orderable_isLessThan(this_, other);
}

bool Dog_isGreaterThan(DogValue this_, DogValue other) {
  return Orderable_isGreaterThan(this_, other);
}


class CatValue extends Cat_Animal_PrintableValue {
  late String name;
  late int age;
  late String _mood;
}

void Cat_new(CatValue this_, String name, int age) {
  Animal_new(this_, name, age);
  this_.vptr = {
    'speak': Cat_speak,
    'toString_': Cat_toString,
    'get_displayName': Cat_get_displayName,
    'printInfo': Cat_printInfo,
    'get_mood': Cat_get_mood,
    'set_mood': Cat_set_mood,
  };
  this_._mood = 'happy';
}

String Cat_get_displayName(CatValue this_) {
  return 'Cat:${this_.name}';
}

String Cat_speak(AnimalValue this__) {
  final this_ = this__ as CatValue;
  return 'Meow!';
}

String Cat_get_mood(CatValue this_) {
  return this_._mood;
}

void Cat_set_mood(CatValue this_, String value) {
  this_._mood = value;
}

String Cat_toString(AnimalValue this_) {
  return Animal_toString(this_);
}

void Cat_printInfo(CatValue this_) {
  Printable_printInfo(this_);
}


class Vector2DValue extends VPtr {
  late double x;
  late double y;
}

void Vector2D_new(Vector2DValue this_, double x, double y) {
  this_.vptr = {
    'operatorPlus': Vector2D_operatorPlus,
    'operatorMinus': Vector2D_operatorMinus,
    'operatorStar': Vector2D_operatorStar,
    'operatorEq': Vector2D_operatorEq,
    'get_length': Vector2D_get_length,
    'toString_': Vector2D_toString,
  };
  this_.x = x;
  this_.y = y;
}

Vector2DValue Vector2D_operatorPlus(Vector2DValue this_, Vector2DValue other) {
  return (() { final _obj = Vector2DValue(); Vector2D_new(_obj, (this_.x + other.x), (this_.y + other.y)); return _obj; })();
}

Vector2DValue Vector2D_operatorMinus(Vector2DValue this_, Vector2DValue other) {
  return (() { final _obj = Vector2DValue(); Vector2D_new(_obj, (this_.x - other.x), (this_.y - other.y)); return _obj; })();
}

Vector2DValue Vector2D_operatorStar(Vector2DValue this_, double scalar) {
  return (() { final _obj = Vector2DValue(); Vector2D_new(_obj, (this_.x * scalar), (this_.y * scalar)); return _obj; })();
}

bool Vector2D_operatorEq(Vector2DValue this_, Object other) {
  return (((other is Vector2DValue) && (this_.x == other.x)) && (this_.y == other.y));
}

double Vector2D_get_length(Vector2DValue this_) {
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

String Vector2D_toString(Vector2DValue this_) {
  return 'Vector2D(${this_.x}, ${this_.y})';
}


class CounterValue extends VPtr {
  late int _value;
  late String label;
}

int Counter__instanceCount = 0;
const int Counter_maxValue = 100;
void Counter_new__(CounterValue this_, String label, int _value) {
  this_.vptr = {
    'increment': Counter_increment,
    'decrement': Counter_decrement,
    'get_value': Counter_get_value,
    'toString_': Counter_toString,
  };
  this_.label = label;
  this_._value = _value;
  Counter__instanceCount = (Counter__instanceCount + 1);
}

CounterValue Counter_new(String label, {int initialValue = 0}) {
  return (() { final _obj = CounterValue(); Counter_new__(_obj, label, initialValue); return _obj; })();
}

CounterValue Counter_new_fromString(String spec) {
  final List<String> parts = spec.split(':');
  return (() { final _obj = CounterValue(); Counter_new__(_obj, parts[0], int.parse(parts[1])); return _obj; })();
}

int Counter_instanceCount() {
  return Counter__instanceCount;
}

void Counter_increment(CounterValue this_, int step) {
  this_._value = (this_._value + step).clamp(0, 100);
}

void Counter_decrement(CounterValue this_, int step) {
  this_._value = (this_._value - step).clamp(0, 100);
}

int Counter_get_value(CounterValue this_) {
  return this_._value;
}

String Counter_toString(CounterValue this_) {
  return '${this_.label}: ${this_._value}';
}


class ResultValue<T> extends VPtr {
  late T? data;
  late String? error;
  late bool isSuccess;
}

void Result_new_success<T>(ResultValue<T> this_, T value) {
  this_.vptr = {
    'fold': (self, {required dynamic Function(T) onSuccess, required dynamic Function(String) onFailure}) => Result_fold(self, onSuccess: onSuccess, onFailure: onFailure),
    'toString_': (self) => Result_toString<T>(self),
  };
  this_.data = value;
  this_.error = null;
  this_.isSuccess = true;
}

void Result_new_failure<T>(ResultValue<T> this_, String message) {
  this_.vptr = {
    'fold': (self, {required dynamic Function(T) onSuccess, required dynamic Function(String) onFailure}) => Result_fold(self, onSuccess: onSuccess, onFailure: onFailure),
    'toString_': (self) => Result_toString<T>(self),
  };
  this_.data = null;
  this_.error = message;
  this_.isSuccess = false;
}

R Result_fold<T, R>(ResultValue<T> this_, {required R Function(T) onSuccess, required R Function(String) onFailure}) {
  if ((this_.isSuccess && !((this_.data == null)))) {
    return onSuccess((this_.data as T));
  }
  return onFailure((this_.error ?? 'Unknown error'));
}

String Result_toString<T>(ResultValue<T> this_) {
  return (this_.isSuccess ? 'Result.success(${this_.data})' : 'Result.failure(${this_.error})');
}


class LazyLoaderValue extends VPtr {
  late String _data;
  late int _computedValue;
  late bool _initialized;
}

void LazyLoader_new(LazyLoaderValue this_) {
  this_.vptr = {
    'initialize': LazyLoader_initialize,
    'get_data': LazyLoader_get_data,
    'get_computedValue': LazyLoader_get_computedValue,
  };
  this_._initialized = false;
}

void LazyLoader_initialize(LazyLoaderValue this_, String data) {
  this_._data = data;
  this_._computedValue = (data.length * 2);
  this_._initialized = true;
}

String LazyLoader_get_data(LazyLoaderValue this_) {
  return (this_._initialized ? this_._data : 'not initialized');
}

int LazyLoader_get_computedValue(LazyLoaderValue this_) {
  return (this_._initialized ? this_._computedValue : (-1));
}


class BoundedValueValue extends VPtr {
  late double min;
  late double max;
  late double _current;
}

void BoundedValue_new(BoundedValueValue this_, double min, double max, double initial) {
  this_.vptr = {
    'set': BoundedValue_set,
    'get_current': BoundedValue_get_current,
  };
  this_.min = min;
  this_.max = max;
  this_._current = initial;
  assert((this_.min <= this_.max), 'min must be <= max');
  assert(((initial >= this_.min) && (initial <= this_.max)), 'initial must be in [min, max]');
}

void BoundedValue_set(BoundedValueValue this_, double value) {
  assert(((value >= this_.min) && (value <= this_.max)), 'value ${value} out of bounds [${this_.min}, ${this_.max}]');
  this_._current = value;
}

double BoundedValue_get_current(BoundedValueValue this_) {
  return this_._current;
}


class ShapeValue extends VPtr {
  late String color;
  late double opacity;
}

void Shape_new(ShapeValue this_, String color, {double opacity = 1.0}) {
  this_.vptr = {
    'describe': Shape_describe,
  };
  this_.color = color;
  this_.opacity = opacity;
}

void Shape_new_transparent(ShapeValue this_, String color) {
  Shape_new(this_, color, opacity: 0.5);
}

String Shape_describe(ShapeValue this_) {
  return 'Shape(color=${this_.color}, opacity=${this_.opacity})';
}


class PolygonValue extends ShapeValue {
  late String color;
  late double opacity;
  late int sides;
}

void Polygon_new(PolygonValue this_, String color, int sides, {double opacity = 1.0}) {
  Shape_new(this_, color, opacity: opacity);
  this_.vptr = {
    ...this_.vptr,
    'describe': Polygon_describe,
    'perimeter': Polygon_perimeter,
  };
  this_.sides = sides;
}

String Polygon_describe(ShapeValue this__) {
  final this_ = this__ as PolygonValue;
  return 'Polygon(sides=${this_.sides}, ${Shape_describe(this_)})';
}

double Polygon_perimeter(PolygonValue this_, double sideLength) {
  return (this_.sides * sideLength);
}


class RegularPolygonValue extends PolygonValue {
  late String color;
  late double opacity;
  late int sides;
  late double sideLength;
}

void RegularPolygon_new(RegularPolygonValue this_, String color, int sides, double sideLength, {double opacity = 1.0}) {
  Polygon_new(this_, color, sides, opacity: opacity);
  this_.vptr = {
    ...this_.vptr,
    'describe': RegularPolygon_describe,
    'perimeter': RegularPolygon_perimeter,
    'area': RegularPolygon_area,
  };
  this_.sideLength = sideLength;
}

String RegularPolygon_describe(ShapeValue this__) {
  final this_ = this__ as RegularPolygonValue;
  return 'RegularPolygon(sideLen=${this_.sideLength}, ${Polygon_describe(this_)})';
}

double RegularPolygon_perimeter(PolygonValue this__, double? overrideSideLength) {
  final this_ = this__ as RegularPolygonValue;
  return (this_.sides * (overrideSideLength ?? this_.sideLength));
}

double RegularPolygon_area(RegularPolygonValue this_) {
  return (((this_.sides * this_.sideLength) * this_.sideLength) / 4.0);
}


class SquareValue extends RegularPolygonValue {
  late String color;
  late double opacity;
  late int sides;
  late double sideLength;
}

void Square_new(SquareValue this_, String color, double size, {double opacity = 1.0}) {
  RegularPolygon_new(this_, color, 4, size, opacity: opacity);
  this_.vptr = {
    ...this_.vptr,
    'describe': Square_describe,
    'perimeter': Square_perimeter,
    'area': Square_area,
  };
}

String Square_describe(ShapeValue this__) {
  final this_ = this__ as SquareValue;
  return 'Square(size=${this_.sideLength}, color=${this_.color})';
}

double Square_perimeter(PolygonValue this_, double? overrideSideLength) {
  return RegularPolygon_perimeter(this_, overrideSideLength);
}

double Square_area(RegularPolygonValue this_) {
  return RegularPolygon_area(this_);
}


class SerializableValue extends VPtr {
}

void Serializable_new(SerializableValue this_) {
  this_.vptr = {
    'serialize': Serializable_serialize,
  };
}

String Serializable_serialize(SerializableValue this_) {
  throw UnimplementedError('Serializable.serialize is abstract');
}


class CloneableValue<T> extends VPtr {
}

void Cloneable_new<T>(CloneableValue<T> this_) {
  this_.vptr = {
    'clone': (self) => Cloneable_clone<T>(self),
  };
}

T Cloneable_clone<T>(CloneableValue<T> this_) {
  throw UnimplementedError('Cloneable.clone is abstract');
}


class Comparable2Value<T> extends VPtr {
}

void Comparable2_new<T>(Comparable2Value<T> this_) {
  this_.vptr = {
    'compareTo2': (self, _a0) => Comparable2_compareTo2<T>(self, _a0),
  };
}

int Comparable2_compareTo2<T>(Comparable2Value<T> this_, T other) {
  throw UnimplementedError('Comparable2.compareTo2 is abstract');
}


class DataPointValue extends VPtr {
  late double x;
  late double y;
  late String label;
}

void DataPoint_new(DataPointValue this_, double x, double y, String label) {
  this_.vptr = {
    'serialize': DataPoint_serialize,
    'clone': DataPoint_clone,
    'compareTo2': DataPoint_compareTo2,
    'toString_': DataPoint_toString,
  };
  this_.x = x;
  this_.y = y;
  this_.label = label;
}

String DataPoint_serialize(DataPointValue this_) {
  return '{"x":${this_.x},"y":${this_.y},"label":"${this_.label}"}';
}

DataPointValue DataPoint_clone(DataPointValue this_) {
  return (() { final _obj = DataPointValue(); DataPoint_new(_obj, this_.x, this_.y, this_.label); return _obj; })();
}

int DataPoint_compareTo2(DataPointValue this_, DataPointValue other) {
  final double dx = (this_.x - other.x);
  if (!((dx == 0)))   return ((dx > 0) ? 1 : (-1));
  final double dy = (this_.y - other.y);
  if (!((dy == 0)))   return ((dy > 0) ? 1 : (-1));
  return 0;
}

String DataPoint_toString(DataPointValue this_) {
  return 'DataPoint(${this_.x}, ${this_.y}, "${this_.label}")';
}


// mixin Loggable → static functions for delegation
void Loggable_log(dynamic this_, String message) {
  print('[${(this_.vptr['get_logTag'] as Function)(this_)}] ${message}');
}


// mixin Validatable → static functions for delegation
bool Validatable_validate(dynamic this_) {
  return (this_.vptr['serialize'] as Function)(this_).isNotEmpty;
}


class LoggedDataPointValue extends LoggedDataPoint_DataPoint_Loggable_ValidatableValue {
  late double x;
  late double y;
  late String label;
}

void LoggedDataPoint_new(LoggedDataPointValue this_, double x, double y, String label) {
  DataPoint_new(this_, x, y, label);
  this_.vptr = {
    'serialize': LoggedDataPoint_serialize,
    'clone': LoggedDataPoint_clone,
    'compareTo2': LoggedDataPoint_compareTo2,
    'toString_': LoggedDataPoint_toString,
    'get_logTag': LoggedDataPoint_get_logTag,
    'log': LoggedDataPoint_log,
    'validate': LoggedDataPoint_validate,
  };
}

String LoggedDataPoint_get_logTag(LoggedDataPointValue this_) {
  return 'DataPoint';
}

String LoggedDataPoint_serialize(LoggedDataPointValue this_) {
  return DataPoint_serialize(this_);
}

DataPointValue LoggedDataPoint_clone(LoggedDataPointValue this_) {
  return DataPoint_clone(this_);
}

int LoggedDataPoint_compareTo2(LoggedDataPointValue this_, DataPointValue other) {
  return DataPoint_compareTo2(this_, other);
}

String LoggedDataPoint_toString(DataPointValue this_) {
  return DataPoint_toString(this_);
}

void LoggedDataPoint_log(LoggedDataPointValue this_, String message) {
  Loggable_log(this_, message);
}

bool LoggedDataPoint_validate(LoggedDataPointValue this_) {
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

void Config_new(ConfigValue this_, String host, int port, {bool secure = false}) {
  this_.vptr = {
    'toString_': Config_toString,
  };
  this_.host = host;
  this_.port = port;
  this_.secure = secure;
  this_.baseUrl = '${(secure ? 'https' : 'http')}://${host}:${port}';
}

void Config_new_localhost(ConfigValue this_, {int port = 8080}) {
  Config_new(this_, 'localhost', port);
}

void Config_new_production(ConfigValue this_, String host) {
  Config_new(this_, host, 443, secure: true);
}

String Config_toString(ConfigValue this_) {
  return 'Config(${this_.baseUrl})';
}


class SortedListValue<T extends Comparable<dynamic>> extends VPtr {
  late List<T> _items;
}

void SortedList_new<T extends Comparable<dynamic>>(SortedListValue<T> this_) {
  this_.vptr = {
    'add': (self, _a0) => SortedList_add<T>(self, _a0),
    'get_first': (self) => SortedList_get_first<T>(self),
    'get_last': (self) => SortedList_get_last<T>(self),
    'get_length': (self) => SortedList_get_length<T>(self),
    'toList': (self) => SortedList_toList<T>(self),
    'toString_': (self) => SortedList_toString<T>(self),
  };
  this_._items = <T>[];
}

void SortedList_add<T extends Comparable<dynamic>>(SortedListValue<T> this_, T item) {
  this_._items.add(item);
  this_._items.sort();
}

T SortedList_get_first<T extends Comparable<dynamic>>(SortedListValue<T> this_) {
  return this_._items.first;
}

T SortedList_get_last<T extends Comparable<dynamic>>(SortedListValue<T> this_) {
  return this_._items.last;
}

int SortedList_get_length<T extends Comparable<dynamic>>(SortedListValue<T> this_) {
  return this_._items.length;
}

List<T> SortedList_toList<T extends Comparable<dynamic>>(SortedListValue<T> this_) {
  return List.unmodifiable(this_._items);
}

String SortedList_toString<T extends Comparable<dynamic>>(SortedListValue<T> this_) {
  return 'SortedList(${this_._items})';
}


class NullSafetyDemoValue extends VPtr {
  late String? nullableField;
  late String nonNullField;
}

void NullSafetyDemo_new(NullSafetyDemoValue this_, String nonNullField, [String? nullableField = null]) {
  this_.vptr = {
    'demonstrate': NullSafetyDemo_demonstrate,
  };
  this_.nonNullField = nonNullField;
  this_.nullableField = nullableField;
}

String NullSafetyDemo_demonstrate(NullSafetyDemoValue this_) {
  final int? len = this_.nullableField?.length;
  final int safeLen = (len ?? (-1));
  ((this_.nullableField == null) ? this_.nullableField = 'default' : null);
  final String forced = this_.nullableField!.toUpperCase();
  return 'len=${safeLen}, forced=${forced}';
}


class RendererValue extends VPtr {
}

void Renderer_new(RendererValue this_) {
  this_.vptr = {
    'render': Renderer_render,
    'get_name': Renderer_get_name,
  };
}

void Renderer_render(RendererValue this_, Object shape) {
  throw UnimplementedError('Renderer.render is abstract');
}

String Renderer_get_name(RendererValue this_) {
  throw UnimplementedError('Renderer.name is abstract');
}


class CircleRendererValue extends RendererValue {
}

void CircleRenderer_new(CircleRendererValue this_) {
  Renderer_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'render': CircleRenderer_render,
    'get_name': CircleRenderer_get_name,
  };
}

void CircleRenderer_render(RendererValue this__, String shape) {
  final this_ = this__ as CircleRendererValue;
  print('  CircleRenderer: drawing ${shape}');
}

String CircleRenderer_get_name(RendererValue this__) {
  final this_ = this__ as CircleRendererValue;
  return 'CircleRenderer';
}


class PipelineValue<TInput, TOutput> extends VPtr {
  late TOutput Function(TInput) _transform;
}

void Pipeline_new<TInput, TOutput>(PipelineValue<TInput, TOutput> this_, TOutput Function(TInput) _transform) {
  this_.vptr = {
    'execute': (self, _a0) => Pipeline_execute<TInput, TOutput>(self, _a0),
    'then': (self, _a0) => Pipeline_then(self, _a0),
  };
  this_._transform = _transform;
}

TOutput Pipeline_execute<TInput, TOutput>(PipelineValue<TInput, TOutput> this_, TInput input) {
  return (() { final _let4 = input; return this_._transform(_let4); })();
}

PipelineValue<TInput, TNewOutput> Pipeline_then<TInput, TOutput, TNewOutput>(PipelineValue<TInput, TOutput> this_, TNewOutput Function(TOutput) next) {
  return (() { final _obj = PipelineValue<TInput, TNewOutput>(); Pipeline_new(_obj, ClosureEnv_anon_0(this_, next)); return _obj; })();
}


class BitFlagsValue extends VPtr {
  late int _flags;
}

const int BitFlags_read = 1;
const int BitFlags_write = 2;
const int BitFlags_execute = 4;
void BitFlags_new(BitFlagsValue this_, [int _flags = 0]) {
  this_.vptr = {
    'set': BitFlags_set,
    'clear': BitFlags_clear,
    'has': BitFlags_has,
    'toString_': BitFlags_toString,
  };
  this_._flags = _flags;
}

void BitFlags_set(BitFlagsValue this_, int flag) {
  this_._flags = (this_._flags | flag);
}

void BitFlags_clear(BitFlagsValue this_, int flag) {
  this_._flags = (this_._flags & (~flag));
}

bool BitFlags_has(BitFlagsValue this_, int flag) {
  return !(((this_._flags & flag) == 0));
}

String BitFlags_toString(BitFlagsValue this_) {
  final List<String> parts = <String>[];
  if ((this_.vptr['has'] as bool Function(BitFlagsValue, int))(this_, 1))   parts.add('r');
  if ((this_.vptr['has'] as bool Function(BitFlagsValue, int))(this_, 2))   parts.add('w');
  if ((this_.vptr['has'] as bool Function(BitFlagsValue, int))(this_, 4))   parts.add('x');
  return (parts.isEmpty ? '-' : parts.join(''));
}


// mixin Timestamped → static functions for delegation
int Timestamped_get_timestamp(dynamic this_) {
  return 1234567890;
}

String Timestamped_get_timeStr(dynamic this_) {
  return 'T:${(this_.vptr['get_timestamp'] as Function)(this_)}';
}


// mixin Tagged → static functions for delegation
void Tagged_addTag(dynamic this_, String tag) {
  this_._tags.add(tag);
}

List<String> Tagged_get_tags(dynamic this_) {
  return List.unmodifiable(this_._tags);
}


class EventValue extends Event_Object_Timestamped_TaggedValue {
  late List<String> _tags;
  late String name;
}

void Event_new(EventValue this_, String name) {
  this_.vptr = {
    'get_timestamp': Event_get_timestamp,
    'get_timeStr': Event_get_timeStr,
    'addTag': Event_addTag,
    'get_tags': Event_get_tags,
    'toString_': Event_toString,
  };
  this_.name = name;
  this_._tags = <String>[];
}

String Event_toString(EventValue this_) {
  return 'Event(${this_.name}, ${(this_.vptr['get_timeStr'] as String Function(EventValue))(this_)}, tags=${(this_.vptr['get_tags'] as List<String> Function(EventValue))(this_)})';
}

int Event_get_timestamp(EventValue this_) {
  return Timestamped_get_timestamp(this_);
}

String Event_get_timeStr(EventValue this_) {
  return Timestamped_get_timeStr(this_);
}

void Event_addTag(EventValue this_, String tag) {
  Tagged_addTag(this_, tag);
}

List<String> Event_get_tags(EventValue this_) {
  return Tagged_get_tags(this_);
}


class ImportantEventValue extends ImportantEvent_Event_LoggableValue {
  late List<String> _tags;
  late String name;
  late Priority priority;
}

void ImportantEvent_new(ImportantEventValue this_, String name, Priority priority) {
  Event_new(this_, name);
  this_.vptr = {
    'get_timestamp': ImportantEvent_get_timestamp,
    'get_timeStr': ImportantEvent_get_timeStr,
    'addTag': ImportantEvent_addTag,
    'get_tags': ImportantEvent_get_tags,
    'toString_': ImportantEvent_toString,
    'get_logTag': ImportantEvent_get_logTag,
    'log': ImportantEvent_log,
  };
  this_.priority = priority;
  this_._tags = <String>[];
}

String ImportantEvent_get_logTag(ImportantEventValue this_) {
  return 'ImportantEvent';
}

String ImportantEvent_toString(EventValue this__) {
  final this_ = this__ as ImportantEventValue;
  return 'ImportantEvent(${this_.name}, ${Priority_toString(this_.priority)}, ${(this_.vptr['get_timeStr'] as String Function(ImportantEventValue))(this_)})';
}

int ImportantEvent_get_timestamp(ImportantEventValue this_) {
  return Timestamped_get_timestamp(this_);
}

String ImportantEvent_get_timeStr(ImportantEventValue this_) {
  return Timestamped_get_timeStr(this_);
}

void ImportantEvent_addTag(ImportantEventValue this_, String tag) {
  Tagged_addTag(this_, tag);
}

List<String> ImportantEvent_get_tags(ImportantEventValue this_) {
  return Tagged_get_tags(this_);
}

void ImportantEvent_log(ImportantEventValue this_, String message) {
  Loggable_log(this_, message);
}


class Dog_Animal_PrintableValue extends AnimalValue {
  late String name;
  late int age;
}


class Dog_Animal_Printable_OrderableValue extends Dog_Animal_PrintableValue {
  late String name;
  late int age;
}


class Cat_Animal_PrintableValue extends AnimalValue {
  late String name;
  late int age;
}


class LoggedDataPoint_DataPoint_LoggableValue extends DataPointValue {
  late double x;
  late double y;
  late String label;
}


class LoggedDataPoint_DataPoint_Loggable_ValidatableValue extends LoggedDataPoint_DataPoint_LoggableValue {
  late double x;
  late double y;
  late String label;
}


class Event_Object_TimestampedValue extends VPtr {
}


class Event_Object_Timestamped_TaggedValue extends Event_Object_TimestampedValue {
  late List<String> _tags;
}


class ImportantEvent_Event_LoggableValue extends EventValue {
  late List<String> _tags;
  late String name;
}


String formatMessage(String template, [String? subject = null, int? count = null]) {
  String result = template;
  if (!((subject == null)))   result = result.replaceAll('{subject}', subject);
  if (!((count == null)))   result = result.replaceAll('{count}', count.toString());
  return result;
}

String buildQuery({required String endpoint, Map<String, String>? params = null, int maxWait = 30, bool secure = true}) {
  final String scheme = (secure ? 'https' : 'http');
  final String query = ((() { final _let7 = params; return _let7 == null ? null : _let7.entries.map((MapEntry<String, String> e) => '${e.key}=${e.value}').join('&'); })() ?? '');
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

C Function(A) compose<A, B, C>(B Function(A) f, C Function(B) g) {
  return ClosureEnv_compose_1(g, f);
}

bool Function(T) and<T>(bool Function(T) p1, bool Function(T) p2) {
  return ClosureEnv_and_2(p1, p2);
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
  final DogValue dog1 = (() { final _obj = DogValue(); Dog_new(_obj, 'Rex', 3, 'Labrador'); return _obj; })();
  final DogValue dog2 = (() { final _obj = DogValue(); Dog_new(_obj, 'Max', 5, 'Poodle'); return _obj; })();
  (dog1.vptr['printInfo'] as void Function(DogValue))(dog1);
  print('${(dog1.vptr['speak'] as String Function(DogValue))(dog1)} (${dog1.breed})');
  print('dog1 < dog2: ${(dog1.vptr['isLessThan'] as bool Function(DogValue, DogValue))(dog1, dog2)}');
  print('dog1 > dog2: ${(dog1.vptr['isGreaterThan'] as bool Function(DogValue, DogValue))(dog1, dog2)}');
  final CatValue cat = (() { final _obj = CatValue(); Cat_new(_obj, 'Whiskers', 2); return _obj; })();
  (cat.vptr['printInfo'] as void Function(CatValue))(cat);
  print('${(cat.vptr['speak'] as String Function(CatValue))(cat)}, mood: ${(cat.vptr['get_mood'] as String Function(CatValue))(cat)}');
  (cat.vptr['set_mood'] as void Function(CatValue, String))(cat, 'sleepy');
  print('mood after set: ${(cat.vptr['get_mood'] as String Function(CatValue))(cat)}');
  print('\n--- 2. operator 重载 ---');
  final Vector2DValue sum = ((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })().vptr['operatorPlus'] as Vector2DValue Function(Vector2DValue, Vector2DValue))((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })(), (() { final _obj = Vector2DValue(); Vector2D_new(_obj, 1.0, 2.0); return _obj; })());
  final Vector2DValue diff = ((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })().vptr['operatorMinus'] as Vector2DValue Function(Vector2DValue, Vector2DValue))((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })(), (() { final _obj = Vector2DValue(); Vector2D_new(_obj, 1.0, 2.0); return _obj; })());
  final Vector2DValue scaled = ((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })().vptr['operatorStar'] as Vector2DValue Function(Vector2DValue, double))((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })(), 2.0);
  print('v1 + v2 = ${sum}');
  print('v1 - v2 = ${diff}');
  print('v1 * 2 = ${scaled}');
  print('v1.length = ${((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })().vptr['get_length'] as double Function(Vector2DValue))((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })()).toStringAsFixed(2)}');
  print('v1 == Vector2D(3,4): ${((() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })() == (() { final _obj = Vector2DValue(); Vector2D_new(_obj, 3.0, 4.0); return _obj; })())}');
  print('\n--- 3. static + factory ---');
  final CounterValue c1 = Counter_new('alpha');
  final CounterValue c2 = Counter_new('beta', initialValue: 50);
  final CounterValue c3 = Counter_new_fromString('gamma:25');
  (c1.vptr['increment'] as void Function(CounterValue, int))(c1, 10);
  (c2.vptr['decrement'] as void Function(CounterValue, int))(c2, 5);
  (c3.vptr['increment'] as void Function(CounterValue, int))(c3, 1);
  print('${c1}, ${c2}, ${c3}');
  print('instances: ${Counter_instanceCount()}');
  print('maxValue: 100');
  print('\n--- 4. Result<T> + named params ---');
  print('ok: ${(() { final _obj = ResultValue<int>(); Result_new_success(_obj, 42); return _obj; })()}');
  print('err: ${(() { final _obj = ResultValue<int>(); Result_new_failure(_obj, 'not found'); return _obj; })()}');
  final String okMsg = ((() { final _obj = ResultValue<int>(); Result_new_success(_obj, 42); return _obj; })().vptr['fold'] as Function)((() { final _obj = ResultValue<int>(); Result_new_success(_obj, 42); return _obj; })(), onSuccess: (int d) => 'got ${d}', onFailure: (String e) => 'error: ${e}');
  final String errMsg = ((() { final _obj = ResultValue<int>(); Result_new_failure(_obj, 'not found'); return _obj; })().vptr['fold'] as Function)((() { final _obj = ResultValue<int>(); Result_new_failure(_obj, 'not found'); return _obj; })(), onSuccess: (int d) => 'got ${d}', onFailure: (String e) => 'error: ${e}');
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
  final LazyLoaderValue loader = (() { final _obj = LazyLoaderValue(); LazyLoader_new(_obj); return _obj; })();
  print('before init: ${(loader.vptr['get_data'] as String Function(LazyLoaderValue))(loader)}, ${(loader.vptr['get_computedValue'] as int Function(LazyLoaderValue))(loader)}');
  (loader.vptr['initialize'] as void Function(LazyLoaderValue, String))(loader, 'hello');
  print('after init: ${(loader.vptr['get_data'] as String Function(LazyLoaderValue))(loader)}, ${(loader.vptr['get_computedValue'] as int Function(LazyLoaderValue))(loader)}');
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
  final BoundedValueValue bv = (() { final _obj = BoundedValueValue(); BoundedValue_new(_obj, 0.0, 10.0, 5.0); return _obj; })();
  (bv.vptr['set'] as void Function(BoundedValueValue, double))(bv, 7.5);
  print('BoundedValue: ${(bv.vptr['get_current'] as double Function(BoundedValueValue))(bv)}');
  print('\n--- 15. 字符串 ---');
  print(multiLineExample());
  print('\n--- 16. typedef + 函数式组合 ---');
  final String Function(int) doubleIt = compose((int x) => (x * 2), (int x) => 'result=${x}');
  print('compose(5): ${doubleIt(5)}');
  final bool Function(int) isPositive = (int n) => (n > 0);
  final bool Function(int) isEven = (int n) => ((n % 2) == 0);
  final bool Function(int) isPositiveEven = and(isPositive, isEven);
  final List<int> nums = <int>[(-2), (-1), 0, 1, 2, 3, 4];
  print('positiveEvens: ${nums.where(isPositiveEven).toList()}');
  final List<int> nested = flatMap(<int>[1, 2, 3], (int x) => <int>[x, (x * x)]);
  print('flatMap: ${nested}');
  print('\n--- 19. 多层继承链 ---');
  final ShapeValue shape = (() { final _obj = ShapeValue(); Shape_new(_obj, 'red'); return _obj; })();
  print((shape.vptr['describe'] as String Function(ShapeValue))(shape));
  final ShapeValue transparentShape = (() { final _obj = ShapeValue(); Shape_new_transparent(_obj, 'blue'); return _obj; })();
  print((transparentShape.vptr['describe'] as String Function(ShapeValue))(transparentShape));
  final PolygonValue polygon = (() { final _obj = PolygonValue(); Polygon_new(_obj, 'green', 6, opacity: 0.8); return _obj; })();
  print((polygon.vptr['describe'] as String Function(PolygonValue))(polygon));
  print('perimeter: ${(polygon.vptr['perimeter'] as double Function(PolygonValue, double))(polygon, 3.0)}');
  final RegularPolygonValue hexagon = (() { final _obj = RegularPolygonValue(); RegularPolygon_new(_obj, 'yellow', 6, 5.0); return _obj; })();
  print((hexagon.vptr['describe'] as String Function(RegularPolygonValue))(hexagon));
  print('perimeter: ${(hexagon.vptr['perimeter'] as double Function(RegularPolygonValue, double?))(hexagon, null)}');
  print('area: ${(hexagon.vptr['area'] as double Function(RegularPolygonValue))(hexagon)}');
  final SquareValue square = (() { final _obj = SquareValue(); Square_new(_obj, 'white', 10.0, opacity: 0.9); return _obj; })();
  print((square.vptr['describe'] as String Function(SquareValue))(square));
  print('square perimeter: ${(square.vptr['perimeter'] as double Function(SquareValue, double?))(square, null)}');
  print('\n--- 20. implements 多接口 ---');
  final DataPointValue dp1 = (() { final _obj = DataPointValue(); DataPoint_new(_obj, 1.0, 2.0, 'A'); return _obj; })();
  final DataPointValue dp2 = (() { final _obj = DataPointValue(); DataPoint_new(_obj, 3.0, 1.0, 'B'); return _obj; })();
  print('dp1: ${dp1}');
  print('dp1.serialize: ${(dp1.vptr['serialize'] as String Function(DataPointValue))(dp1)}');
  final DataPointValue dp1Clone = (dp1.vptr['clone'] as DataPointValue Function(DataPointValue))(dp1);
  print('dp1.clone: ${dp1Clone}');
  print('dp1.compareTo2(dp2): ${(dp1.vptr['compareTo2'] as int Function(DataPointValue, DataPointValue))(dp1, dp2)}');
  print('\n--- 21. mixin on 约束 ---');
  final LoggedDataPointValue ldp = (() { final _obj = LoggedDataPointValue(); LoggedDataPoint_new(_obj, 5.0, 6.0, 'logged'); return _obj; })();
  (ldp.vptr['log'] as void Function(LoggedDataPointValue, String))(ldp, 'created');
  print('validate: ${(ldp.vptr['validate'] as bool Function(LoggedDataPointValue))(ldp)}');
  print('serialize: ${(ldp.vptr['serialize'] as String Function(LoggedDataPointValue))(ldp)}');
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
  final ConfigValue cfg1 = (() { final _obj = ConfigValue(); Config_new(_obj, 'example.com', 8080); return _obj; })();
  final ConfigValue cfg2 = (() { final _obj = ConfigValue(); Config_new_localhost(_obj); return _obj; })();
  final ConfigValue cfg3 = (() { final _obj = ConfigValue(); Config_new_production(_obj, 'api.example.com'); return _obj; })();
  print('cfg1: ${cfg1}');
  print('cfg2: ${cfg2}');
  print('cfg3: ${cfg3}');
  print('\n--- 24. 泛型约束 ---');
  final SortedListValue<int> sortedList = (() { final _obj = SortedListValue<int>(); SortedList_new(_obj); return _obj; })();
  (sortedList.vptr['add'] as void Function(SortedListValue, int))(sortedList, 5);
  (sortedList.vptr['add'] as void Function(SortedListValue, int))(sortedList, 1);
  (sortedList.vptr['add'] as void Function(SortedListValue, int))(sortedList, 3);
  (sortedList.vptr['add'] as void Function(SortedListValue, int))(sortedList, 2);
  print('sorted: ${sortedList}');
  print('first: ${(sortedList.vptr['get_first'] as dynamic Function(SortedListValue))(sortedList)}, last: ${(sortedList.vptr['get_last'] as dynamic Function(SortedListValue))(sortedList)}');
  final int maxVal = findMax(<int>[3, 7, 1, 9, 4]);
  print('findMax: ${maxVal}');
  final String result = applyTwice(5, (int x) => 'n=${x}', (String s) => '${s}!');
  print('applyTwice: ${result}');
  print('\n--- 25. null safety ---');
  final NullSafetyDemoValue ns1 = (() { final _obj = NullSafetyDemoValue(); NullSafetyDemo_new(_obj, 'hello', 'world'); return _obj; })();
  print('ns1: ${(ns1.vptr['demonstrate'] as String Function(NullSafetyDemoValue))(ns1)}');
  final NullSafetyDemoValue ns2 = (() { final _obj = NullSafetyDemoValue(); NullSafetyDemo_new(_obj, 'hello'); return _obj; })();
  print('ns2: ${(ns2.vptr['demonstrate'] as String Function(NullSafetyDemoValue))(ns2)}');
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
  final CircleRendererValue renderer = (() { final _obj = CircleRendererValue(); CircleRenderer_new(_obj); return _obj; })();
  print('renderer: ${(renderer.vptr['get_name'] as String Function(CircleRendererValue))(renderer)}');
  (renderer.vptr['render'] as void Function(CircleRendererValue, String))(renderer, 'circle');
  print('\n--- 30. Pipeline 泛型链 ---');
  final PipelineValue<int, String> pipeline = Pipeline_then<int, int, String>(Pipeline_then<int, String, int>((() { final _obj = PipelineValue<int, String>(); Pipeline_new(_obj, (int n) => 'val=${n}'); return _obj; })(), (String s) => s.length), (int len) => 'len=${len}');
  print('pipeline(42): ${(pipeline.vptr['execute'] as String Function(PipelineValue, int))(pipeline, 42)}');
  print('pipeline(12345): ${(pipeline.vptr['execute'] as String Function(PipelineValue, int))(pipeline, 12345)}');
  print('\n--- 31. switch-case ---');
  print('day 1: ${dayType(1)}');
  print('day 3: ${dayType(3)}');
  print('day 7: ${dayType(7)}');
  print('day 9: ${dayType(9)}');
  print('\n--- 32. 位运算 ---');
  final BitFlagsValue flags = (() { final _obj = BitFlagsValue(); BitFlags_new(_obj); return _obj; })();
  (flags.vptr['set'] as void Function(BitFlagsValue, int))(flags, 1);
  (flags.vptr['set'] as void Function(BitFlagsValue, int))(flags, 4);
  print('flags: ${flags}');
  print('has read: ${(flags.vptr['has'] as bool Function(BitFlagsValue, int))(flags, 1)}');
  print('has write: ${(flags.vptr['has'] as bool Function(BitFlagsValue, int))(flags, 2)}');
  (flags.vptr['set'] as void Function(BitFlagsValue, int))(flags, 2);
  print('after set write: ${flags}');
  (flags.vptr['clear'] as void Function(BitFlagsValue, int))(flags, 4);
  print('after clear execute: ${flags}');
  print('\n--- 33. 多层 mixin ---');
  final EventValue event = (() { final _obj = EventValue(); Event_new(_obj, 'meeting'); return _obj; })();
  (event.vptr['addTag'] as void Function(EventValue, String))(event, 'work');
  (event.vptr['addTag'] as void Function(EventValue, String))(event, 'important');
  print(event);
  final ImportantEventValue impEvent = (() { final _obj = ImportantEventValue(); ImportantEvent_new(_obj, 'deadline', Priority.critical); return _obj; })();
  (impEvent.vptr['addTag'] as void Function(ImportantEventValue, String))(impEvent, 'urgent');
  (impEvent.vptr['log'] as void Function(ImportantEventValue, String))(impEvent, 'created');
  print(impEvent);
  print('\n=== 所有测试通过 ✅ ===');
}

class ClosureEnv_anon_0<TNewOutput, TOutput, TInput> {
  PipelineValue<TInput, TOutput> this_;
  TNewOutput Function(TOutput) next;
  ClosureEnv_anon_0(this.this_, this.next);
  TNewOutput call(TInput input) => ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>(this, input);
}
TNewOutput ClosureEnv_anon_0_call<TNewOutput, TOutput, TInput>(ClosureEnv_anon_0<TNewOutput, TOutput, TInput> env, TInput input) {
  return env.next((() { final _let5 = input; return env.this_._transform(_let5); })());
}

class ClosureEnv_compose_1<C, B, A> {
  C Function(B) g;
  B Function(A) f;
  ClosureEnv_compose_1(this.g, this.f);
  C call(A input) => ClosureEnv_compose_1_call<C, B, A>(this, input);
}
C ClosureEnv_compose_1_call<C, B, A>(ClosureEnv_compose_1<C, B, A> env, A input) {
  return env.g(env.f(input));
}

class ClosureEnv_and_2<T> {
  bool Function(T) p1;
  bool Function(T) p2;
  ClosureEnv_and_2(this.p1, this.p2);
  bool call(T value) => ClosureEnv_and_2_call<T>(this, value);
}
bool ClosureEnv_and_2_call<T>(ClosureEnv_and_2<T> env, T value) {
  return (env.p1(value) && env.p2(value));
}


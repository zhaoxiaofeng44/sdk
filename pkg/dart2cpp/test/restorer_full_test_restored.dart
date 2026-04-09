typedef Predicate<T> = bool Function(T);

typedef Transformer<A, B> = B Function(A);

typedef VoidCallback = void Function();

// mixin Printable → lowered via synthetic intermediate classes

// mixin Orderable → lowered via synthetic intermediate classes

class AnimalValue {
  late AnimalVTable vptr;
  final String name;
  final int age;
}

class AnimalVTable {
  late String Function(AnimalValue this_) speak;
  late String Function(AnimalValue this_) toString;
}

AnimalValue Animal_new(String name, int age) {
  final obj = AnimalValue();
  obj.vptr = AnimalVTable()
    ..speak = Animal_speak
    ..toString = Animal_toString
  ;
  obj.name = name;
  obj.age = age;
  return obj;
}

String Animal_toString(AnimalValue this_) {
  return '${this_.name}(age=${this_.age})';
}


class DogValue extends Dog_Animal_Printable_OrderableValue {
  @override
  late DogVTable vptr;
  final String breed;
}

class DogVTable extends Dog_Animal_Printable_OrderableVTable {
  @override
  late String Function(DogValue this_) get_displayName;
  @override
  late String Function(DogValue this_) speak;
  @override
  late int Function(DogValue this_, DogValue) compareTo;
}

DogValue Dog_new(String name, int age, String breed) {
  final obj = DogValue();
  obj.vptr = DogVTable()
    ..get_displayName = Dog_get_displayName
    ..speak = Dog_speak
    ..compareTo = Dog_compareTo
  ;
  obj.name = name;
  obj.age = age;
  obj.breed = breed;
  return obj;
}

String Dog_get_displayName(DogValue this_) {
  return 'Dog:${this_.name}';
}

String Dog_speak(DogValue this_) {
  return 'Woof!';
}

int Dog_compareTo(DogValue this_, DogValue other) {
  return this_.age.compareTo(other.age);
}


class CatValue extends Cat_Animal_PrintableValue {
  @override
  late CatVTable vptr;
  late String _mood;
}

class CatVTable extends Cat_Animal_PrintableVTable {
  @override
  late String Function(CatValue this_) get_displayName;
  @override
  late String Function(CatValue this_) speak;
  late String Function(CatValue this_) get_mood;
  late void Function(CatValue this_, String value) set_mood;
}

CatValue Cat_new(String name, int age) {
  final obj = CatValue();
  obj.vptr = CatVTable()
    ..get_displayName = Cat_get_displayName
    ..speak = Cat_speak
    ..get_mood = Cat_get_mood
    ..set_mood = Cat_set_mood
  ;
  obj.name = name;
  obj.age = age;
  obj._mood = 'happy';
  return obj;
}

String Cat_get_displayName(CatValue this_) {
  return 'Cat:${this_.name}';
}

String Cat_speak(CatValue this_) {
  return 'Meow!';
}

String Cat_get_mood(CatValue this_) {
  return this_._mood;
}

void Cat_set_mood(CatValue this_, String value) {
  this_._mood = value;
}


class Vector2DValue {
  late Vector2DVTable vptr;
  final double x;
  final double y;
}

class Vector2DVTable {
  late Vector2DValue Function(Vector2DValue this_, Vector2DValue) operatorPlus;
  late Vector2DValue Function(Vector2DValue this_, Vector2DValue) operatorMinus;
  late Vector2DValue Function(Vector2DValue this_, double) operatorStar;
  late bool Function(Vector2DValue this_, Object) operatorEq;
  late double Function(Vector2DValue this_) get_length;
  late String Function(Vector2DValue this_) toString;
}

Vector2DValue Vector2D_new(double x, double y) {
  final obj = Vector2DValue();
  obj.vptr = Vector2DVTable()
    ..operatorPlus = Vector2D_operatorPlus
    ..operatorMinus = Vector2D_operatorMinus
    ..operatorStar = Vector2D_operatorStar
    ..operatorEq = Vector2D_operatorEq
    ..get_length = Vector2D_get_length
    ..toString = Vector2D_toString
  ;
  obj.x = x;
  obj.y = y;
  return obj;
}

Vector2DValue Vector2D_operatorPlus(Vector2DValue this_, Vector2DValue other) {
  return Vector2D_new((this_.x + other.x), (this_.y + other.y));
}

Vector2DValue Vector2D_operatorMinus(Vector2DValue this_, Vector2DValue other) {
  return Vector2D_new((this_.x - other.x), (this_.y - other.y));
}

Vector2DValue Vector2D_operatorStar(Vector2DValue this_, double scalar) {
  return Vector2D_new((this_.x * scalar), (this_.y * scalar));
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


class CounterValue {
  late CounterVTable vptr;
  int _value;
  final String label;
}

class CounterVTable {
  late void Function(CounterValue this_, int) increment;
  late void Function(CounterValue this_, int) decrement;
  late int Function(CounterValue this_) get_value;
  late String Function(CounterValue this_) toString;
}

int Counter__instanceCount = 0;
const int Counter_maxValue = 100;
CounterValue Counter_new__(String label, int _value) {
  final obj = CounterValue();
  obj.vptr = CounterVTable()
    ..increment = Counter_increment
    ..decrement = Counter_decrement
    ..get_value = Counter_get_value
    ..toString = Counter_toString
  ;
  obj.label = label;
  obj._value = _value;
  Counter._instanceCount = (Counter._instanceCount + 1);
  return obj;
}

CounterValue Counter_new(String label, {int initialValue = 0}) {
  return Counter_new__(label, initialValue);
}

CounterValue Counter_new_fromString(String spec) {
  final List<String> parts = spec.split(':');
  return Counter_new__(parts[0], int.parse(parts[1]));
}

int Counter_instanceCount() {
  return Counter._instanceCount;
}

void Counter_increment(CounterValue this_, [int step = 1]) {
  this_._value = (this_._value + step).clamp(0, 100);
}

void Counter_decrement(CounterValue this_, [int step = 1]) {
  this_._value = (this_._value - step).clamp(0, 100);
}

int Counter_get_value(CounterValue this_) {
  return this_._value;
}

String Counter_toString(CounterValue this_) {
  return '${this_.label}: ${this_._value}';
}


class ResultValue<T> {
  late ResultVTable vptr;
  final T? data;
  final String? error;
  final bool isSuccess;
}

class ResultVTable<T> {
  late R Function(ResultValue this_, R Function(T), R Function(String)) fold;
  late String Function(ResultValue this_) toString;
}

ResultValue<T> Result_new_success(T value) {
  final obj = ResultValue();
  obj.vptr = ResultVTable()
    ..fold = Result_fold
    ..toString = Result_toString
  ;
  obj.data = value;
  obj.error = null;
  obj.isSuccess = true;
  return obj;
}

ResultValue<T> Result_new_failure(String message) {
  final obj = ResultValue();
  obj.vptr = ResultVTable()
    ..fold = Result_fold
    ..toString = Result_toString
  ;
  obj.data = null;
  obj.error = message;
  obj.isSuccess = false;
  return obj;
}

R Result_fold(ResultValue this_, {required R Function(T) onSuccess, required R Function(String) onFailure}) {
  if ((this_.isSuccess && !((this_.data == null)))) {
    return onSuccess((() { final _let0 = this_.data; return ((_let0 == null) ? (_let0 as T) : _let0); })());
  }
  return onFailure((() { final _let1 = this_.error; return ((_let1 == null) ? 'Unknown error' : _let1); })());
}

String Result_toString(ResultValue this_) {
  return (this_.isSuccess ? 'Result.success(${this_.data})' : 'Result.failure(${this_.error})');
}


class LazyLoaderValue {
  late LazyLoaderVTable vptr;
  late final String _data;
  late int _computedValue;
  bool _initialized = false;
}

class LazyLoaderVTable {
  late void Function(LazyLoaderValue this_, String) initialize;
  late String Function(LazyLoaderValue this_) get_data;
  late int Function(LazyLoaderValue this_) get_computedValue;
}

LazyLoaderValue LazyLoader_new() {
  final obj = LazyLoaderValue();
  obj.vptr = LazyLoaderVTable()
    ..initialize = LazyLoader_initialize
    ..get_data = LazyLoader_get_data
    ..get_computedValue = LazyLoader_get_computedValue
  ;
  return obj;
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


class BoundedValueValue {
  late BoundedValueVTable vptr;
  final double min;
  final double max;
  double _current;
}

class BoundedValueVTable {
  late void Function(BoundedValueValue this_, double) set;
  late double Function(BoundedValueValue this_) get_current;
}

BoundedValueValue BoundedValue_new(double min, double max, double initial) {
  final obj = BoundedValueValue();
  obj.vptr = BoundedValueVTable()
    ..set = BoundedValue_set
    ..get_current = BoundedValue_get_current
  ;
  obj.min = min;
  obj.max = max;
  obj._current = initial;
  assert((obj.min <= obj.max), 'min must be <= max');
  assert(((initial >= obj.min) && (initial <= obj.max)), 'initial must be in [min, max]');
  return obj;
}

void BoundedValue_set(BoundedValueValue this_, double value) {
  assert(((value >= this_.min) && (value <= this_.max)), 'value ${value} out of bounds [${this_.min}, ${this_.max}]');
  this_._current = value;
}

double BoundedValue_get_current(BoundedValueValue this_) {
  return this_._current;
}


class ShapeValue {
  late ShapeVTable vptr;
  final String color;
  final double opacity;
}

class ShapeVTable {
  late String Function(ShapeValue this_) describe;
}

ShapeValue Shape_new(String color, {double opacity = 1.0}) {
  final obj = ShapeValue();
  obj.vptr = ShapeVTable()
    ..describe = Shape_describe
  ;
  obj.color = color;
  obj.opacity = opacity;
  return obj;
}

ShapeValue Shape_new_transparent(String color) {
  final obj = ShapeValue();
  obj.vptr = ShapeVTable()
    ..describe = Shape_describe
  ;
  final obj = Shape_new(color, opacity: 0.5);
  return obj;
}

String Shape_describe(ShapeValue this_) {
  return 'Shape(color=${this_.color}, opacity=${this_.opacity})';
}


class PolygonValue extends ShapeValue {
  @override
  late PolygonVTable vptr;
  final int sides;
}

class PolygonVTable extends ShapeVTable {
  @override
  late String Function(PolygonValue this_) describe;
  late double Function(PolygonValue this_, double) perimeter;
}

PolygonValue Polygon_new(String color, int sides, {double opacity = 1.0}) {
  final obj = PolygonValue();
  obj.vptr = PolygonVTable()
    ..describe = Polygon_describe
    ..perimeter = Polygon_perimeter
  ;
  obj.color = color;
  obj.opacity = opacity;
  obj.sides = sides;
  return obj;
}

String Polygon_describe(PolygonValue this_) {
  return 'Polygon(sides=${this_.sides}, ${Shape_describe(this_)})';
}

double Polygon_perimeter(PolygonValue this_, double sideLength) {
  return (this_.sides * sideLength);
}


class RegularPolygonValue extends PolygonValue {
  @override
  late RegularPolygonVTable vptr;
  final double sideLength;
}

class RegularPolygonVTable extends PolygonVTable {
  @override
  late String Function(RegularPolygonValue this_) describe;
  @override
  late double Function(RegularPolygonValue this_, double?) perimeter;
  late double Function(RegularPolygonValue this_) area;
}

RegularPolygonValue RegularPolygon_new(String color, int sides, double sideLength, {double opacity = 1.0}) {
  final obj = RegularPolygonValue();
  obj.vptr = RegularPolygonVTable()
    ..describe = RegularPolygon_describe
    ..perimeter = RegularPolygon_perimeter
    ..area = RegularPolygon_area
  ;
  obj.sides = sides;
  obj.color = color;
  obj.opacity = opacity;
  obj.sideLength = sideLength;
  return obj;
}

String RegularPolygon_describe(RegularPolygonValue this_) {
  return 'RegularPolygon(sideLen=${this_.sideLength}, ${Polygon_describe(this_)})';
}

double RegularPolygon_perimeter(RegularPolygonValue this_, [double? overrideSideLength = null]) {
  return (this_.sides * (() { final _let2 = overrideSideLength; return ((_let2 == null) ? this_.sideLength : _let2); })());
}

double RegularPolygon_area(RegularPolygonValue this_) {
  return (((this_.sides * this_.sideLength) * this_.sideLength) / 4.0);
}


class SquareValue extends RegularPolygonValue {
  @override
  late SquareVTable vptr;
}

class SquareVTable extends RegularPolygonVTable {
  @override
  late String Function(SquareValue this_) describe;
  @override
  late double Function(RegularPolygonValue this_, double?) perimeter;
  @override
  late double Function(RegularPolygonValue this_) area;
}

SquareValue Square_new(String color, double size, {double opacity = 1.0}) {
  final obj = SquareValue();
  obj.vptr = SquareVTable()
    ..describe = Square_describe
    ..perimeter = RegularPolygon_perimeter
    ..area = RegularPolygon_area
  ;
  obj.sideLength = size;
  obj.sides = sides;
  obj.color = color;
  obj.opacity = opacity;
  return obj;
}

String Square_describe(SquareValue this_) {
  return 'Square(size=${this_.sideLength}, color=${this_.color})';
}


class SerializableValue {
  late SerializableVTable vptr;
}

class SerializableVTable {
  late String Function(SerializableValue this_) serialize;
}

SerializableValue Serializable_new() {
  final obj = SerializableValue();
  obj.vptr = SerializableVTable()
    ..serialize = Serializable_serialize
  ;
  return obj;
}


class CloneableValue<T> {
  late CloneableVTable vptr;
}

class CloneableVTable<T> {
  late T Function(CloneableValue this_) clone;
}

CloneableValue<T> Cloneable_new() {
  final obj = CloneableValue();
  obj.vptr = CloneableVTable()
    ..clone = Cloneable_clone
  ;
  return obj;
}


class Comparable2Value<T> {
  late Comparable2VTable vptr;
}

class Comparable2VTable<T> {
  late int Function(Comparable2Value this_, T) compareTo2;
}

Comparable2Value<T> Comparable2_new() {
  final obj = Comparable2Value();
  obj.vptr = Comparable2VTable()
    ..compareTo2 = Comparable2_compareTo2
  ;
  return obj;
}


class DataPointValue {
  late DataPointVTable vptr;
  final double x;
  final double y;
  final String label;
}

class DataPointVTable {
  late String Function(DataPointValue this_) serialize;
  late DataPointValue Function(DataPointValue this_) clone;
  late int Function(DataPointValue this_, DataPointValue) compareTo2;
  late String Function(DataPointValue this_) toString;
}

DataPointValue DataPoint_new(double x, double y, String label) {
  final obj = DataPointValue();
  obj.vptr = DataPointVTable()
    ..serialize = DataPoint_serialize
    ..clone = DataPoint_clone
    ..compareTo2 = DataPoint_compareTo2
    ..toString = DataPoint_toString
  ;
  obj.x = x;
  obj.y = y;
  obj.label = label;
  return obj;
}

String DataPoint_serialize(DataPointValue this_) {
  return '{"x":${this_.x},"y":${this_.y},"label":"${this_.label}"}';
}

DataPointValue DataPoint_clone(DataPointValue this_) {
  return DataPoint_new(this_.x, this_.y, this_.label);
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


// mixin Loggable → lowered via synthetic intermediate classes

// mixin Validatable → lowered via synthetic intermediate classes

class LoggedDataPointValue extends LoggedDataPoint_DataPoint_Loggable_ValidatableValue {
  @override
  late LoggedDataPointVTable vptr;
}

class LoggedDataPointVTable extends LoggedDataPoint_DataPoint_Loggable_ValidatableVTable {
  @override
  late String Function(LoggedDataPointValue this_) get_logTag;
}

LoggedDataPointValue LoggedDataPoint_new(double x, double y, String label) {
  final obj = LoggedDataPointValue();
  obj.vptr = LoggedDataPointVTable()
    ..get_logTag = LoggedDataPoint_get_logTag
  ;
  obj.x = x;
  obj.y = y;
  obj.label = label;
  return obj;
}

String LoggedDataPoint_get_logTag(LoggedDataPointValue this_) {
  return 'DataPoint';
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

class ConfigValue {
  late ConfigVTable vptr;
  final String host;
  final int port;
  final bool secure;
  final String baseUrl;
}

class ConfigVTable {
  late String Function(ConfigValue this_) toString;
}

ConfigValue Config_new(String host, int port, {bool secure = false}) {
  final obj = ConfigValue();
  obj.vptr = ConfigVTable()
    ..toString = Config_toString
  ;
  obj.host = host;
  obj.port = port;
  obj.secure = secure;
  obj.baseUrl = '${(secure ? 'https' : 'http')}://${host}:${port}';
  return obj;
}

ConfigValue Config_new_localhost({int port = 8080}) {
  final obj = ConfigValue();
  obj.vptr = ConfigVTable()
    ..toString = Config_toString
  ;
  final obj = Config_new('localhost', port);
  return obj;
}

ConfigValue Config_new_production(String host) {
  final obj = ConfigValue();
  obj.vptr = ConfigVTable()
    ..toString = Config_toString
  ;
  final obj = Config_new(host, 443, secure: true);
  return obj;
}

String Config_toString(ConfigValue this_) {
  return 'Config(${this_.baseUrl})';
}


class SortedListValue<T extends Comparable<dynamic>> {
  late SortedListVTable vptr;
  final List<T> _items = <T>[];
}

class SortedListVTable<T extends Comparable<dynamic>> {
  late void Function(SortedListValue this_, T) add;
  late T Function(SortedListValue this_) get_first;
  late T Function(SortedListValue this_) get_last;
  late int Function(SortedListValue this_) get_length;
  late List<T> Function(SortedListValue this_) toList;
  late String Function(SortedListValue this_) toString;
}

SortedListValue<T extends Comparable<dynamic>> SortedList_new() {
  final obj = SortedListValue();
  obj.vptr = SortedListVTable()
    ..add = SortedList_add
    ..get_first = SortedList_get_first
    ..get_last = SortedList_get_last
    ..get_length = SortedList_get_length
    ..toList = SortedList_toList
    ..toString = SortedList_toString
  ;
  return obj;
}

void SortedList_add(SortedListValue this_, T item) {
  this_._items.add(item);
  this_._items.sort();
}

T SortedList_get_first(SortedListValue this_) {
  return this_._items.first;
}

T SortedList_get_last(SortedListValue this_) {
  return this_._items.last;
}

int SortedList_get_length(SortedListValue this_) {
  return this_._items.length;
}

List<T> SortedList_toList(SortedListValue this_) {
  return List.unmodifiable(this_._items);
}

String SortedList_toString(SortedListValue this_) {
  return 'SortedList(${this_._items})';
}


class NullSafetyDemoValue {
  late NullSafetyDemoVTable vptr;
  String? nullableField;
  final String nonNullField;
}

class NullSafetyDemoVTable {
  late String Function(NullSafetyDemoValue this_) demonstrate;
}

NullSafetyDemoValue NullSafetyDemo_new(String nonNullField, [String? nullableField = null]) {
  final obj = NullSafetyDemoValue();
  obj.vptr = NullSafetyDemoVTable()
    ..demonstrate = NullSafetyDemo_demonstrate
  ;
  obj.nonNullField = nonNullField;
  obj.nullableField = nullableField;
  return obj;
}

String NullSafetyDemo_demonstrate(NullSafetyDemoValue this_) {
  final int? len = (() { final _let3 = this_.nullableField; return ((_let3 == null) ? null : _let3.length); })();
  final int safeLen = (() { final _let4 = len; return ((_let4 == null) ? (-1) : _let4); })();
  ((this_.nullableField == null) ? this_.nullableField = 'default' : null);
  final String forced = this_.nullableField!.toUpperCase();
  return 'len=${safeLen}, forced=${forced}';
}


class RendererValue {
  late RendererVTable vptr;
}

class RendererVTable {
  late void Function(RendererValue this_, Object) render;
  late String Function(RendererValue this_) get_name;
}

RendererValue Renderer_new() {
  final obj = RendererValue();
  obj.vptr = RendererVTable()
    ..render = Renderer_render
    ..get_name = Renderer_get_name
  ;
  return obj;
}


class CircleRendererValue extends RendererValue {
  @override
  late CircleRendererVTable vptr;
}

class CircleRendererVTable extends RendererVTable {
  @override
  late void Function(CircleRendererValue this_, String) render;
  @override
  late String Function(CircleRendererValue this_) get_name;
}

CircleRendererValue CircleRenderer_new() {
  final obj = CircleRendererValue();
  obj.vptr = CircleRendererVTable()
    ..render = CircleRenderer_render
    ..get_name = CircleRenderer_get_name
  ;
  return obj;
}

void CircleRenderer_render(CircleRendererValue this_, covariant String shape) {
  print('  CircleRenderer: drawing ${shape}');
}

String CircleRenderer_get_name(CircleRendererValue this_) {
  return 'CircleRenderer';
}


class PipelineValue<TInput, TOutput> {
  late PipelineVTable vptr;
  final TOutput Function(TInput) _transform;
}

class PipelineVTable<TInput, TOutput> {
  late TOutput Function(PipelineValue this_, TInput) execute;
  late PipelineValue<TInput, TNewOutput> Function(PipelineValue this_, TNewOutput Function(TOutput)) then;
}

PipelineValue<TInput, TOutput> Pipeline_new(TOutput Function(TInput) _transform) {
  final obj = PipelineValue();
  obj.vptr = PipelineVTable()
    ..execute = Pipeline_execute
    ..then = Pipeline_then
  ;
  obj._transform = _transform;
  return obj;
}

TOutput Pipeline_execute(PipelineValue this_, TInput input) {
  return (() { final _let5 = input; return this_._transform(_let5); })();
}

PipelineValue<TInput, TNewOutput> Pipeline_then(PipelineValue this_, TNewOutput Function(TOutput) next) {
  return Pipeline_new(ClosureEnv_anon_0(this_, next));
}


class BitFlagsValue {
  late BitFlagsVTable vptr;
  int _flags;
}

class BitFlagsVTable {
  late void Function(BitFlagsValue this_, int) set;
  late void Function(BitFlagsValue this_, int) clear;
  late bool Function(BitFlagsValue this_, int) has;
  late String Function(BitFlagsValue this_) toString;
}

const int BitFlags_read = 1;
const int BitFlags_write = 2;
const int BitFlags_execute = 4;
BitFlagsValue BitFlags_new([int _flags = 0]) {
  final obj = BitFlagsValue();
  obj.vptr = BitFlagsVTable()
    ..set = BitFlags_set
    ..clear = BitFlags_clear
    ..has = BitFlags_has
    ..toString = BitFlags_toString
  ;
  obj._flags = _flags;
  return obj;
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
  if (this_.vptr.has(this_, 1))   parts.add('r');
  if (this_.vptr.has(this_, 2))   parts.add('w');
  if (this_.vptr.has(this_, 4))   parts.add('x');
  return (parts.isEmpty ? '-' : parts.join(''));
}


// mixin Timestamped → lowered via synthetic intermediate classes

// mixin Tagged → lowered via synthetic intermediate classes

class EventValue extends Event_Object_Timestamped_TaggedValue {
  @override
  late EventVTable vptr;
  final String name;
}

class EventVTable extends Event_Object_Timestamped_TaggedVTable {
  late String Function(EventValue this_) toString;
}

EventValue Event_new(String name) {
  final obj = EventValue();
  obj.vptr = EventVTable()
    ..toString = Event_toString
  ;
  obj.name = name;
  return obj;
}

String Event_toString(EventValue this_) {
  return 'Event(${this_.name}, ${this_.timeStr}, tags=${this_.tags})';
}


class ImportantEventValue extends ImportantEvent_Event_LoggableValue {
  @override
  late ImportantEventVTable vptr;
  final Priority priority;
}

class ImportantEventVTable extends ImportantEvent_Event_LoggableVTable {
  @override
  late String Function(ImportantEventValue this_) get_logTag;
  @override
  late String Function(ImportantEventValue this_) toString;
}

ImportantEventValue ImportantEvent_new(String name, Priority priority) {
  final obj = ImportantEventValue();
  obj.vptr = ImportantEventVTable()
    ..get_logTag = ImportantEvent_get_logTag
    ..toString = ImportantEvent_toString
  ;
  obj.name = name;
  obj.priority = priority;
  return obj;
}

String ImportantEvent_get_logTag(ImportantEventValue this_) {
  return 'ImportantEvent';
}

String ImportantEvent_toString(ImportantEventValue this_) {
  return 'ImportantEvent(${this_.name}, ${this_.priority}, ${this_.timeStr})';
}


class Dog_Animal_PrintableValue extends AnimalValue {
  @override
  late Dog_Animal_PrintableVTable vptr;
}

class Dog_Animal_PrintableVTable extends AnimalVTable {
  @override
  late String Function(AnimalValue this_) speak;
  @override
  late String Function(AnimalValue this_) toString;
  late String Function(Dog_Animal_PrintableValue this_) get_displayName;
  late void Function(Dog_Animal_PrintableValue this_) printInfo;
}

Dog_Animal_PrintableValue Dog_Animal_Printable_new(String name, int age) {
  final obj = Dog_Animal_PrintableValue();
  obj.vptr = Dog_Animal_PrintableVTable()
    ..speak = Animal_speak
    ..toString = Animal_toString
    ..get_displayName = Dog_Animal_Printable_get_displayName
    ..printInfo = Dog_Animal_Printable_printInfo
  ;
  obj.name = name;
  obj.age = age;
  return obj;
}

void Dog_Animal_Printable_printInfo(Dog_Animal_PrintableValue this_) {
  print('[${this_.displayName}]');
}


class Dog_Animal_Printable_OrderableValue extends Dog_Animal_PrintableValue {
  @override
  late Dog_Animal_Printable_OrderableVTable vptr;
}

class Dog_Animal_Printable_OrderableVTable extends Dog_Animal_PrintableVTable {
  @override
  late String Function(AnimalValue this_) speak;
  @override
  late String Function(AnimalValue this_) toString;
  @override
  late String Function(Dog_Animal_PrintableValue this_) get_displayName;
  @override
  late void Function(Dog_Animal_PrintableValue this_) printInfo;
  late int Function(Dog_Animal_Printable_OrderableValue this_, DogValue) compareTo;
  late bool Function(Dog_Animal_Printable_OrderableValue this_, DogValue) isLessThan;
  late bool Function(Dog_Animal_Printable_OrderableValue this_, DogValue) isGreaterThan;
}

Dog_Animal_Printable_OrderableValue Dog_Animal_Printable_Orderable_new(String name, int age) {
  final obj = Dog_Animal_Printable_OrderableValue();
  obj.vptr = Dog_Animal_Printable_OrderableVTable()
    ..speak = Animal_speak
    ..toString = Animal_toString
    ..get_displayName = Dog_Animal_Printable_get_displayName
    ..printInfo = Dog_Animal_Printable_printInfo
    ..compareTo = Dog_Animal_Printable_Orderable_compareTo
    ..isLessThan = Dog_Animal_Printable_Orderable_isLessThan
    ..isGreaterThan = Dog_Animal_Printable_Orderable_isGreaterThan
  ;
  obj.name = name;
  obj.age = age;
  return obj;
}

bool Dog_Animal_Printable_Orderable_isLessThan(Dog_Animal_Printable_OrderableValue this_, DogValue other) {
  return (this_.vptr.compareTo(this_, other) < 0);
}

bool Dog_Animal_Printable_Orderable_isGreaterThan(Dog_Animal_Printable_OrderableValue this_, DogValue other) {
  return (this_.vptr.compareTo(this_, other) > 0);
}


class Cat_Animal_PrintableValue extends AnimalValue {
  @override
  late Cat_Animal_PrintableVTable vptr;
}

class Cat_Animal_PrintableVTable extends AnimalVTable {
  @override
  late String Function(AnimalValue this_) speak;
  @override
  late String Function(AnimalValue this_) toString;
  late String Function(Cat_Animal_PrintableValue this_) get_displayName;
  late void Function(Cat_Animal_PrintableValue this_) printInfo;
}

Cat_Animal_PrintableValue Cat_Animal_Printable_new(String name, int age) {
  final obj = Cat_Animal_PrintableValue();
  obj.vptr = Cat_Animal_PrintableVTable()
    ..speak = Animal_speak
    ..toString = Animal_toString
    ..get_displayName = Cat_Animal_Printable_get_displayName
    ..printInfo = Cat_Animal_Printable_printInfo
  ;
  obj.name = name;
  obj.age = age;
  return obj;
}

void Cat_Animal_Printable_printInfo(Cat_Animal_PrintableValue this_) {
  print('[${this_.displayName}]');
}


class LoggedDataPoint_DataPoint_LoggableValue extends DataPointValue {
  @override
  late LoggedDataPoint_DataPoint_LoggableVTable vptr;
}

class LoggedDataPoint_DataPoint_LoggableVTable extends DataPointVTable {
  @override
  late String Function(DataPointValue this_) serialize;
  @override
  late DataPointValue Function(DataPointValue this_) clone;
  @override
  late int Function(DataPointValue this_, DataPointValue) compareTo2;
  @override
  late String Function(DataPointValue this_) toString;
  late String Function(LoggedDataPoint_DataPoint_LoggableValue this_) get_logTag;
  late void Function(LoggedDataPoint_DataPoint_LoggableValue this_, String) log;
}

LoggedDataPoint_DataPoint_LoggableValue LoggedDataPoint_DataPoint_Loggable_new(double x, double y, String label) {
  final obj = LoggedDataPoint_DataPoint_LoggableValue();
  obj.vptr = LoggedDataPoint_DataPoint_LoggableVTable()
    ..serialize = DataPoint_serialize
    ..clone = DataPoint_clone
    ..compareTo2 = DataPoint_compareTo2
    ..toString = DataPoint_toString
    ..get_logTag = LoggedDataPoint_DataPoint_Loggable_get_logTag
    ..log = LoggedDataPoint_DataPoint_Loggable_log
  ;
  obj.x = x;
  obj.y = y;
  obj.label = label;
  return obj;
}

void LoggedDataPoint_DataPoint_Loggable_log(LoggedDataPoint_DataPoint_LoggableValue this_, String message) {
  print('[${this_.logTag}] ${message}');
}


class LoggedDataPoint_DataPoint_Loggable_ValidatableValue extends LoggedDataPoint_DataPoint_LoggableValue {
  @override
  late LoggedDataPoint_DataPoint_Loggable_ValidatableVTable vptr;
}

class LoggedDataPoint_DataPoint_Loggable_ValidatableVTable extends LoggedDataPoint_DataPoint_LoggableVTable {
  @override
  late String Function(DataPointValue this_) serialize;
  @override
  late DataPointValue Function(DataPointValue this_) clone;
  @override
  late int Function(DataPointValue this_, DataPointValue) compareTo2;
  @override
  late String Function(DataPointValue this_) toString;
  @override
  late String Function(LoggedDataPoint_DataPoint_LoggableValue this_) get_logTag;
  @override
  late void Function(LoggedDataPoint_DataPoint_LoggableValue this_, String) log;
  late bool Function(LoggedDataPoint_DataPoint_Loggable_ValidatableValue this_) validate;
}

LoggedDataPoint_DataPoint_Loggable_ValidatableValue LoggedDataPoint_DataPoint_Loggable_Validatable_new(double x, double y, String label) {
  final obj = LoggedDataPoint_DataPoint_Loggable_ValidatableValue();
  obj.vptr = LoggedDataPoint_DataPoint_Loggable_ValidatableVTable()
    ..serialize = DataPoint_serialize
    ..clone = DataPoint_clone
    ..compareTo2 = DataPoint_compareTo2
    ..toString = DataPoint_toString
    ..get_logTag = LoggedDataPoint_DataPoint_Loggable_get_logTag
    ..log = LoggedDataPoint_DataPoint_Loggable_log
    ..validate = LoggedDataPoint_DataPoint_Loggable_Validatable_validate
  ;
  obj.x = x;
  obj.y = y;
  obj.label = label;
  return obj;
}

bool LoggedDataPoint_DataPoint_Loggable_Validatable_validate(LoggedDataPoint_DataPoint_Loggable_ValidatableValue this_) {
  return this_.vptr.serialize(this_).isNotEmpty;
}


class Event_Object_TimestampedValue {
  late Event_Object_TimestampedVTable vptr;
}

class Event_Object_TimestampedVTable {
  late int Function(Event_Object_TimestampedValue this_) get_timestamp;
  late String Function(Event_Object_TimestampedValue this_) get_timeStr;
}

Event_Object_TimestampedValue Event_Object_Timestamped_new() {
  final obj = Event_Object_TimestampedValue();
  obj.vptr = Event_Object_TimestampedVTable()
    ..get_timestamp = Event_Object_Timestamped_get_timestamp
    ..get_timeStr = Event_Object_Timestamped_get_timeStr
  ;
  return obj;
}

int Event_Object_Timestamped_get_timestamp(Event_Object_TimestampedValue this_) {
  return 1234567890;
}

String Event_Object_Timestamped_get_timeStr(Event_Object_TimestampedValue this_) {
  return 'T:${this_.timestamp}';
}


class Event_Object_Timestamped_TaggedValue extends Event_Object_TimestampedValue {
  @override
  late Event_Object_Timestamped_TaggedVTable vptr;
  final List<String> _tags = <String>[];
}

class Event_Object_Timestamped_TaggedVTable extends Event_Object_TimestampedVTable {
  @override
  late int Function(Event_Object_TimestampedValue this_) get_timestamp;
  @override
  late String Function(Event_Object_TimestampedValue this_) get_timeStr;
  late void Function(Event_Object_Timestamped_TaggedValue this_, String) addTag;
  late List<String> Function(Event_Object_Timestamped_TaggedValue this_) get_tags;
}

Event_Object_Timestamped_TaggedValue Event_Object_Timestamped_Tagged_new() {
  final obj = Event_Object_Timestamped_TaggedValue();
  obj.vptr = Event_Object_Timestamped_TaggedVTable()
    ..get_timestamp = Event_Object_Timestamped_get_timestamp
    ..get_timeStr = Event_Object_Timestamped_get_timeStr
    ..addTag = Event_Object_Timestamped_Tagged_addTag
    ..get_tags = Event_Object_Timestamped_Tagged_get_tags
  ;
  return obj;
}

void Event_Object_Timestamped_Tagged_addTag(Event_Object_Timestamped_TaggedValue this_, String tag) {
  this_._tags.add(tag);
}

List<String> Event_Object_Timestamped_Tagged_get_tags(Event_Object_Timestamped_TaggedValue this_) {
  return List.unmodifiable(this_._tags);
}


class ImportantEvent_Event_LoggableValue extends EventValue {
  @override
  late ImportantEvent_Event_LoggableVTable vptr;
}

class ImportantEvent_Event_LoggableVTable extends EventVTable {
  @override
  late String Function(EventValue this_) toString;
  late String Function(ImportantEvent_Event_LoggableValue this_) get_logTag;
  late void Function(ImportantEvent_Event_LoggableValue this_, String) log;
}

ImportantEvent_Event_LoggableValue ImportantEvent_Event_Loggable_new(String name) {
  final obj = ImportantEvent_Event_LoggableValue();
  obj.vptr = ImportantEvent_Event_LoggableVTable()
    ..toString = Event_toString
    ..get_logTag = ImportantEvent_Event_Loggable_get_logTag
    ..log = ImportantEvent_Event_Loggable_log
  ;
  obj.name = name;
  return obj;
}

void ImportantEvent_Event_Loggable_log(ImportantEvent_Event_LoggableValue this_, String message) {
  print('[${this_.logTag}] ${message}');
}


String formatMessage(String template, [String? subject = null, int? count = null]) {
  String result = template;
  if (!((subject == null)))   result = result.replaceAll('{subject}', subject);
  if (!((count == null)))   result = result.replaceAll('{count}', count.toString());
  return result;
}

String buildQuery({required String endpoint, Map<String, String>? params = null, int maxWait = 30, bool secure = true}) {
  final String scheme = (secure ? 'https' : 'http');
  final String query = (() { final _let7 = (() { final _let8 = params; return ((_let8 == null) ? null : _let8.entries.map((MapEntry<String, String> e) => '${e.key}=${e.value}').join('&')); })(); return ((_let7 == null) ? '' : _let7); })();
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
        late List<dynamic> list;
        if ((((_v10 is List<dynamic>) && (() { final _let13 = list = _v10; return true; })()) && list.isEmpty)) {
          _v9 = 'empty list';
          break;
        }
      }
{
        late List<dynamic> list;
        if ((_v10 is List<dynamic>)) {
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

List<int> buildList() {
  return (() { final _let14 = <int>[]; return (() {   _let14.add(1);
  _let14.add(2);
  _let14.addAll(<int>[3, 4, 5]);
  _let14.sort();
 return _let14; })(); })();
}

StringBuffer buildBuffer() {
  return (() { final _let15 = StringBuffer(); return (() {   _let15.write('Hello');
  _let15.write(', ');
  _let15.write('World');
  _let15.writeln('!');
 return _let15; })(); })();
}

List<int> mergeAndFilter(List<int> a, List<int> b, bool includeNegative) {
  return (() {   final List<int> _v16 = List.of(a);
  _v16.addAll(b);
  if (includeNegative)   _v16.add((-1));
  for (var i = 10; (i <= 12); i = (i + 1))   _v16.add(i);
 return _v16; })();
}

Map<String, int> buildScoreMap(List<String> names, bool addBonus) {
  return (() {   final Map<String, int> _v17 = <String, int>{};
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

R applyTwice<T, R>(T value, R Function(T) fn1, R Function(R) fn2) {
  return fn2(fn1(value));
}

String? findFirst(List<String> items, bool Function(String) test) {
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

List<int> filterWithForIn(List<int> items) {
  final List<int> result = <int>[];
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
  final DogValue dog1 = Dog_new('Rex', 3, 'Labrador');
  final DogValue dog2 = Dog_new('Max', 5, 'Poodle');
  dog1.vptr.printInfo(dog1);
  print('${dog1.vptr.speak(dog1)} (${dog1.breed})');
  print('dog1 < dog2: ${dog1.vptr.isLessThan(dog1, dog2)}');
  print('dog1 > dog2: ${dog1.vptr.isGreaterThan(dog1, dog2)}');
  final CatValue cat = Cat_new('Whiskers', 2);
  cat.vptr.printInfo(cat);
  print('${cat.vptr.speak(cat)}, mood: ${cat.mood}');
  cat.mood = 'sleepy';
  print('mood after set: ${cat.mood}');
  print('\n--- 2. operator 重载 ---');
  final Vector2DValue sum = Vector2D_new(3.0, 4.0).vptr.operatorPlus(Vector2D_new(3.0, 4.0), Vector2D_new(1.0, 2.0));
  final Vector2DValue diff = Vector2D_new(3.0, 4.0).vptr.operatorMinus(Vector2D_new(3.0, 4.0), Vector2D_new(1.0, 2.0));
  final Vector2DValue scaled = Vector2D_new(3.0, 4.0).vptr.operatorStar(Vector2D_new(3.0, 4.0), 2.0);
  print('v1 + v2 = ${sum}');
  print('v1 - v2 = ${diff}');
  print('v1 * 2 = ${scaled}');
  print('v1.length = ${Vector2D_new(3.0, 4.0).length.toStringAsFixed(2)}');
  print('v1 == Vector2D(3,4): ${(Vector2D_new(3.0, 4.0) == Vector2D_new(3.0, 4.0))}');
  print('\n--- 3. static + factory ---');
  final CounterValue c1 = Counter_new('alpha');
  final CounterValue c2 = Counter_new('beta', initialValue: 50);
  final CounterValue c3 = Counter_new_fromString('gamma:25');
  c1.vptr.increment(c1, 10);
  c2.vptr.decrement(c2, 5);
  c3.vptr.increment(c3);
  print('${c1}, ${c2}, ${c3}');
  print('instances: ${Counter.instanceCount}');
  print('maxValue: 100');
  print('\n--- 4. Result<T> + named params ---');
  print('ok: ${Result_new_success(42)}');
  print('err: ${Result_new_failure('not found')}');
  final String okMsg = Result_new_success(42).vptr.fold(Result_new_success(42), onSuccess: (int d) => 'got ${d}', onFailure: (String e) => 'error: ${e}');
  final String errMsg = Result_new_failure('not found').vptr.fold(Result_new_failure('not found'), onSuccess: (int d) => 'got ${d}', onFailure: (String e) => 'error: ${e}');
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
    final (int, int) _v10 = divmod(17, 5);
    q = _v10.$1;
    r2 = _v10.$2;
  }
  print('divmod(17,5): quotient=${q}, remainder=${r2}');
  print('\n--- 9. pattern matching ---');
  final List<Object?> values = <Object?>[null, (-5), 42, '', 'hello', <int>[], <int>[1, 2, 3]];
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
  final LazyLoaderValue loader = LazyLoader_new();
  print('before init: ${loader.data}, ${loader.computedValue}');
  loader.vptr.initialize(loader, 'hello');
  print('after init: ${loader.data}, ${loader.computedValue}');
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
  final BoundedValueValue bv = BoundedValue_new(0.0, 10.0, 5.0);
  bv.vptr.set(bv, 7.5);
  print('BoundedValue: ${bv.current}');
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
  final ShapeValue shape = Shape_new('red');
  print(shape.vptr.describe(shape));
  final ShapeValue transparentShape = Shape_new_transparent('blue');
  print(transparentShape.vptr.describe(transparentShape));
  final PolygonValue polygon = Polygon_new('green', 6, opacity: 0.8);
  print(polygon.vptr.describe(polygon));
  print('perimeter: ${polygon.vptr.perimeter(polygon, 3.0)}');
  final RegularPolygonValue hexagon = RegularPolygon_new('yellow', 6, 5.0);
  print(hexagon.vptr.describe(hexagon));
  print('perimeter: ${hexagon.vptr.perimeter(hexagon)}');
  print('area: ${hexagon.vptr.area(hexagon)}');
  final SquareValue square = Square_new('white', 10.0, opacity: 0.9);
  print(square.vptr.describe(square));
  print('square perimeter: ${square.vptr.perimeter(square)}');
  print('\n--- 20. implements 多接口 ---');
  final DataPointValue dp1 = DataPoint_new(1.0, 2.0, 'A');
  final DataPointValue dp2 = DataPoint_new(3.0, 1.0, 'B');
  print('dp1: ${dp1}');
  print('dp1.serialize: ${dp1.vptr.serialize(dp1)}');
  final DataPointValue dp1Clone = dp1.vptr.clone(dp1);
  print('dp1.clone: ${dp1Clone}');
  print('dp1.compareTo2(dp2): ${dp1.vptr.compareTo2(dp1, dp2)}');
  print('\n--- 21. mixin on 约束 ---');
  final LoggedDataPointValue ldp = LoggedDataPoint_new(5.0, 6.0, 'logged');
  ldp.vptr.log(ldp, 'created');
  print('validate: ${ldp.vptr.validate(ldp)}');
  print('serialize: ${ldp.vptr.serialize(ldp)}');
  print('\n--- 22. 增强枚举 ---');
  print('Priority.high: ${Priority}.high');
  print('high > medium: ${Priority_isHigherThan(Priority.high, Priority.medium)}');
  print('low > high: ${Priority_isHigherThan(Priority.low, Priority.high)}');
{
    Iterator<Priority> sync_for_iterator = const [Priority.low, Priority.medium, Priority.high, Priority.critical].iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final Priority p = sync_for_iterator.current;
{
        print('  ${p}');
      }
    }
  }
  print('GET isReadOnly: ${HttpMethod_get_isReadOnly(HttpMethod.get)}');
  print('POST isReadOnly: ${HttpMethod_get_isReadOnly(HttpMethod.post)}');
  print('\n--- 23. 重定向构造函数 ---');
  final ConfigValue cfg1 = Config_new('example.com', 8080);
  final ConfigValue cfg2 = Config_new_localhost();
  final ConfigValue cfg3 = Config_new_production('api.example.com');
  print('cfg1: ${cfg1}');
  print('cfg2: ${cfg2}');
  print('cfg3: ${cfg3}');
  print('\n--- 24. 泛型约束 ---');
  final SortedListValue<int> sortedList = SortedList_new();
  sortedList.vptr.add(sortedList, 5);
  sortedList.vptr.add(sortedList, 1);
  sortedList.vptr.add(sortedList, 3);
  sortedList.vptr.add(sortedList, 2);
  print('sorted: ${sortedList}');
  print('first: ${sortedList.first}, last: ${sortedList.last}');
  final int maxVal = findMax(<int>[3, 7, 1, 9, 4]);
  print('findMax: ${maxVal}');
  final String result = applyTwice(5, (int x) => 'n=${x}', (String s) => '${s}!');
  print('applyTwice: ${result}');
  print('\n--- 25. null safety ---');
  final NullSafetyDemoValue ns1 = NullSafetyDemo_new('hello', 'world');
  print('ns1: ${ns1.vptr.demonstrate(ns1)}');
  final NullSafetyDemoValue ns2 = NullSafetyDemo_new('hello');
  print('ns2: ${ns2.vptr.demonstrate(ns2)}');
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
  final CircleRendererValue renderer = CircleRenderer_new();
  print('renderer: ${renderer.name}');
  renderer.vptr.render(renderer, 'circle');
  print('\n--- 30. Pipeline 泛型链 ---');
  final PipelineValue<int, String> pipeline = Pipeline_new((int n) => 'val=${n}').vptr.then(Pipeline_new((int n) => 'val=${n}'), (String s) => s.length).vptr.then(Pipeline_new((int n) => 'val=${n}').vptr.then(Pipeline_new((int n) => 'val=${n}'), (String s) => s.length), (int len) => 'len=${len}');
  print('pipeline(42): ${pipeline.vptr.execute(pipeline, 42)}');
  print('pipeline(12345): ${pipeline.vptr.execute(pipeline, 12345)}');
  print('\n--- 31. switch-case ---');
  print('day 1: ${dayType(1)}');
  print('day 3: ${dayType(3)}');
  print('day 7: ${dayType(7)}');
  print('day 9: ${dayType(9)}');
  print('\n--- 32. 位运算 ---');
  final BitFlagsValue flags = BitFlags_new();
  flags.vptr.set(flags, 1);
  flags.vptr.set(flags, 4);
  print('flags: ${flags}');
  print('has read: ${flags.vptr.has(flags, 1)}');
  print('has write: ${flags.vptr.has(flags, 2)}');
  flags.vptr.set(flags, 2);
  print('after set write: ${flags}');
  flags.vptr.clear(flags, 4);
  print('after clear execute: ${flags}');
  print('\n--- 33. 多层 mixin ---');
  final EventValue event = Event_new('meeting');
  event.vptr.addTag(event, 'work');
  event.vptr.addTag(event, 'important');
  print(event);
  final ImportantEventValue impEvent = ImportantEvent_new('deadline', Priority.critical);
  impEvent.vptr.addTag(impEvent, 'urgent');
  impEvent.vptr.log(impEvent, 'created');
  print(impEvent);
  print('\n=== 所有测试通过 ✅ ===');
}

class ClosureEnv_anon_0 {
  PipelineValue this_;
  TNewOutput Function(TOutput) next;
  ClosureEnv_anon_0(this.this_, this.next);
  TNewOutput call(TInput input) => ClosureEnv_anon_0_call(this, input);
}
TNewOutput ClosureEnv_anon_0_call(ClosureEnv_anon_0 env, TInput input) {
  return env.next((() { final _let6 = input; return env.this_._transform(_let6); })());
}

class ClosureEnv_compose_1 {
  C Function(B) g;
  B Function(A) f;
  ClosureEnv_compose_1(this.g, this.f);
  C call(A input) => ClosureEnv_compose_1_call(this, input);
}
C ClosureEnv_compose_1_call(ClosureEnv_compose_1 env, A input) {
  return env.g(env.f(input));
}

class ClosureEnv_and_2 {
  bool Function(T) p1;
  bool Function(T) p2;
  ClosureEnv_and_2(this.p1, this.p2);
  bool call(T value) => ClosureEnv_and_2_call(this, value);
}
bool ClosureEnv_and_2_call(ClosureEnv_and_2 env, T value) {
  return (env.p1(value) && env.p2(value));
}


import 'package:dart2cpp/restorer/runtime_classes.dart';

// mixin Logger → static functions for delegation
String Logger_get_prefix(dynamic this__) {
  final this_ = this__;
  return 'LOG';
}

String Logger_format(dynamic this__, String msg) {
  final this_ = this__;
  return '[${(this_.vptr['get_prefix'] as String Function(dynamic))(this_)}] ${msg}';
}


// mixin Formatter → static functions for delegation
String Formatter_get_prefix(dynamic this__) {
  final this_ = this__;
  return 'FMT';
}

String Formatter_format(dynamic this__, String msg) {
  final this_ = this__;
  return '{${(this_.vptr['get_prefix'] as String Function(dynamic))(this_)}: ${msg}}';
}


class DiamondClassValue extends DiamondClass_Object_Logger_FormatterValue {
  late String name;
  DiamondClassValue() {
    vptr['get_prefix'] = DiamondClass_get_prefix;
    vptr['format'] = DiamondClass_format;
    vptr['display'] = DiamondClass_display;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DiamondClassValue DiamondClass_new(dynamic this__, String name) {
  final this_ = this__ as DiamondClassValue;
  this_.name = name;
  return this_;
}

String DiamondClass_display(dynamic this__, String msg) {
  final this_ = this__ as DiamondClassValue;
  return '${this_.name}: ${(this_.vptr['format'] as String Function(dynamic, String))(this_, msg)}';
}

String DiamondClass_get_prefix(dynamic this__) {
  final this_ = this__ as DiamondClassValue;
  return Formatter_get_prefix(this_);
}

String DiamondClass_format(dynamic this__, String msg) {
  final this_ = this__ as DiamondClassValue;
  return Formatter_format(this_, msg);
}


// mixin StatefulMixin → static functions for delegation
int StatefulMixin_get_counter(dynamic this__) {
  final this_ = this__;
  return this_._counter;
}

void StatefulMixin_set_counter(dynamic this__, int value) {
  final this_ = this__;
  this_._counter = value;
}

void StatefulMixin_increment(dynamic this__) {
  final this_ = this__;
  (this_.vptr['set_counter'] as void Function(dynamic, int))(this_, ((this_.vptr['get_counter'] as int Function(dynamic))(this_) + 1));
}

void StatefulMixin_decrement(dynamic this__) {
  final this_ = this__;
  (this_.vptr['set_counter'] as void Function(dynamic, int))(this_, ((this_.vptr['get_counter'] as int Function(dynamic))(this_) - 1));
}

String StatefulMixin_get_counterStatus(dynamic this__) {
  final this_ = this__;
  return 'count=${(this_.vptr['get_counter'] as int Function(dynamic))(this_)}';
}


class StatefulWidgetValue extends StatefulWidget_Object_StatefulMixinValue {
  late String id;
  StatefulWidgetValue() {
    vptr['get_counter'] = StatefulWidget_get_counter;
    vptr['set_counter'] = StatefulWidget_set_counter;
    vptr['increment'] = StatefulWidget_increment;
    vptr['decrement'] = StatefulWidget_decrement;
    vptr['get_counterStatus'] = StatefulWidget_get_counterStatus;
    vptr['toString'] = StatefulWidget_toString;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

StatefulWidgetValue StatefulWidget_new(dynamic this__, String id) {
  final this_ = this__ as StatefulWidgetValue;
  this_.id = id;
  this_._counter = 0;
  return this_;
}

String StatefulWidget_toString(dynamic this__) {
  final this_ = this__ as StatefulWidgetValue;
  return 'Widget(${this_.id}, ${(this_.vptr['get_counterStatus'] as String Function(dynamic))(this_)})';
}

int StatefulWidget_get_counter(dynamic this__) {
  final this_ = this__ as StatefulWidgetValue;
  return StatefulMixin_get_counter(this_);
}

void StatefulWidget_set_counter(dynamic this__, int value) {
  final this_ = this__ as StatefulWidgetValue;
  StatefulMixin_set_counter(this_, value);
}

void StatefulWidget_increment(dynamic this__) {
  final this_ = this__ as StatefulWidgetValue;
  StatefulMixin_increment(this_);
}

void StatefulWidget_decrement(dynamic this__) {
  final this_ = this__ as StatefulWidgetValue;
  StatefulMixin_decrement(this_);
}

String StatefulWidget_get_counterStatus(dynamic this__) {
  final this_ = this__ as StatefulWidgetValue;
  return StatefulMixin_get_counterStatus(this_);
}


// mixin LayerA → static functions for delegation
String LayerA_layer(dynamic this__) {
  final this_ = this__;
  return 'A';
}

String LayerA_onlyA(dynamic this__) {
  final this_ = this__;
  return 'onlyA';
}


// mixin LayerB → static functions for delegation
String LayerB_layer(dynamic this__) {
  final this_ = this__;
  return 'B';
}

String LayerB_onlyB(dynamic this__) {
  final this_ = this__;
  return 'onlyB';
}


// mixin LayerC → static functions for delegation
String LayerC_layer(dynamic this__) {
  final this_ = this__;
  return 'C';
}

String LayerC_onlyC(dynamic this__) {
  final this_ = this__;
  return 'onlyC';
}


class DeepMixinClassValue extends DeepMixinClass_Object_LayerA_LayerB_LayerCValue {
  DeepMixinClassValue() {
    vptr['layer'] = DeepMixinClass_layer;
    vptr['onlyA'] = DeepMixinClass_onlyA;
    vptr['onlyB'] = DeepMixinClass_onlyB;
    vptr['onlyC'] = DeepMixinClass_onlyC;
    vptr['allLayers'] = DeepMixinClass_allLayers;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DeepMixinClassValue DeepMixinClass_new(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return this_;
}

String DeepMixinClass_allLayers(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return '${(this_.vptr['layer'] as String Function(dynamic))(this_)}-${(this_.vptr['onlyA'] as String Function(dynamic))(this_)}-${(this_.vptr['onlyB'] as String Function(dynamic))(this_)}-${(this_.vptr['onlyC'] as String Function(dynamic))(this_)}';
}

String DeepMixinClass_layer(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return LayerC_layer(this_);
}

String DeepMixinClass_onlyA(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return LayerA_onlyA(this_);
}

String DeepMixinClass_onlyB(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return LayerB_onlyB(this_);
}

String DeepMixinClass_onlyC(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return LayerC_onlyC(this_);
}


// mixin Mappable → static functions for delegation
R Mappable_mapValue<T, R>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__;
  return transform.closureCall(transform, (this_.vptr['get_value'] as T Function(dynamic))(this_));
}

String Mappable_describe<T>(dynamic this__) {
  final this_ = this__;
  return 'Mappable<${T}>(${(this_.vptr['get_value'] as T Function(dynamic))(this_)})';
}


// mixin Filterable → static functions for delegation
bool Filterable_test<T>(dynamic this__, TypeFunction1<bool, T> predicate) {
  final this_ = this__;
  return predicate.closureCall(predicate, (this_.vptr['get_value'] as T Function(dynamic))(this_));
}


class BoxValue<T> extends Box_Object_Mappable_FilterableValue<T> {
  late T value;
  BoxValue() {
    vptr['get_value'] = Box_get_value<T>;
    vptr['describe'] = Box_describe<T>;
    vptr['test'] = Box_test<T>;
    vptr['toString'] = Box_toString<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (value is AnyGC) (value as AnyGC).gcMark(flag);
  }
}

BoxValue<T> Box_new<T>(dynamic this__, T value) {
  final this_ = this__ as BoxValue<T>;
  this_.vptr['mapValue_int'] = Box_mapValue<T, int>;
  this_.vptr['mapValue_String'] = Box_mapValue<T, String>;
  this_.value = value;
  return this_;
}

String Box_toString<T>(dynamic this__) {
  final this_ = this__ as BoxValue<T>;
  return 'Box(${this_.value})';
}

T Box_get_value<T>(dynamic this__) {
  final this_ = this__ as BoxValue<T>;
  return this_.value;
}

R Box_mapValue<T, R>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as BoxValue<T>;
  return Mappable_mapValue<T, R>(this_, transform);
}

String Box_describe<T>(dynamic this__) {
  final this_ = this__ as BoxValue<T>;
  return Mappable_describe<T>(this_);
}

bool Box_test<T>(dynamic this__, TypeFunction1<bool, T> predicate) {
  final this_ = this__ as BoxValue<T>;
  return Filterable_test<T>(this_, predicate);
}


class IdentifiableValue extends VPtr {
  IdentifiableValue() {
    vptr['get_id'] = Identifiable_get_id;
  }
}

IdentifiableValue Identifiable_new(dynamic this__) {
  final this_ = this__ as IdentifiableValue;
  return this_;
}

String Identifiable_get_id(dynamic this_) {
  throw UnimplementedError('Identifiable.id is abstract');
}


class DescribableValue extends VPtr {
  DescribableValue() {
    vptr['describe'] = Describable_describe;
  }
}

DescribableValue Describable_new(dynamic this__) {
  final this_ = this__ as DescribableValue;
  return this_;
}

String Describable_describe(dynamic this_) {
  throw UnimplementedError('Describable.describe is abstract');
}


// mixin Taggable → static functions for delegation
void Taggable_tag(dynamic this__, String t) {
  final this_ = this__;
  this_._tags.add(t);
}

StaticList<String> Taggable_get_allTags(dynamic this__) {
  final this_ = this__;
  return StaticList<String>.unmodifiable(this_._tags);
}

bool Taggable_hasTag(dynamic this__, String t) {
  final this_ = this__;
  return this_._tags.contains(t);
}


class ResourceValue extends VPtr implements IdentifiableValue, DescribableValue {
  late String id;
  late String type;
  ResourceValue() {
    vptr['get_id'] = Resource_get_id;
    vptr['describe'] = Resource_describe;
  }
}

ResourceValue Resource_new(dynamic this__, String id, String type) {
  final this_ = this__ as ResourceValue;
  this_.id = id;
  this_.type = type;
  return this_;
}

String Resource_describe(dynamic this__) {
  final this_ = this__ as ResourceValue;
  return 'Resource(${this_.id}, type=${this_.type})';
}

dynamic Resource_get_id(ResourceValue this_) {
  throw UnimplementedError('Resource.id delegate missing proc');
}


class TaggedResourceValue extends TaggedResource_Resource_TaggableValue {
  TaggedResourceValue() {
    vptr['get_id'] = TaggedResource_get_id;
    vptr['describe'] = TaggedResource_describe;
    vptr['tag'] = TaggedResource_tag;
    vptr['get_allTags'] = TaggedResource_get_allTags;
    vptr['hasTag'] = TaggedResource_hasTag;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

TaggedResourceValue TaggedResource_new(dynamic this__, String id, String type) {
  final this_ = this__ as TaggedResourceValue;
  Resource_new(this_, id, type);
  this_._tags = StaticList<String>.of([]);
  return this_;
}

String TaggedResource_describe(dynamic this__) {
  final this_ = this__ as TaggedResourceValue;
  return '${Resource_describe(this_)}, tags=${(this_.vptr['get_allTags'] as StaticList<String> Function(dynamic))(this_)}';
}

dynamic TaggedResource_get_id(TaggedResourceValue this_) {
  throw UnimplementedError('TaggedResource.id delegate missing proc');
}

void TaggedResource_tag(dynamic this__, String t) {
  final this_ = this__ as TaggedResourceValue;
  Taggable_tag(this_, t);
}

StaticList<String> TaggedResource_get_allTags(dynamic this__) {
  final this_ = this__ as TaggedResourceValue;
  return Taggable_get_allTags(this_);
}

bool TaggedResource_hasTag(dynamic this__, String t) {
  final this_ = this__ as TaggedResourceValue;
  return Taggable_hasTag(this_, t);
}


class BaseProcessorValue extends VPtr {
  BaseProcessorValue() {
    vptr['process'] = BaseProcessor_process;
    vptr['get_processorName'] = BaseProcessor_get_processorName;
  }
}

BaseProcessorValue BaseProcessor_new(dynamic this__) {
  final this_ = this__ as BaseProcessorValue;
  return this_;
}

String BaseProcessor_process(dynamic this__, String input) {
  final this_ = this__ as BaseProcessorValue;
  return input.trim();
}

String BaseProcessor_get_processorName(dynamic this__) {
  final this_ = this__ as BaseProcessorValue;
  return 'Base';
}


class UpperProcessorValue extends BaseProcessorValue {
  UpperProcessorValue() {
    vptr['process'] = UpperProcessor_process;
    vptr['get_processorName'] = UpperProcessor_get_processorName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

UpperProcessorValue UpperProcessor_new(dynamic this__) {
  final this_ = this__ as UpperProcessorValue;
  BaseProcessor_new(this_);
  return this_;
}

String UpperProcessor_process(dynamic this__, String input) {
  final this_ = this__ as UpperProcessorValue;
  return BaseProcessor_process(this_, input).toUpperCase();
}

String UpperProcessor_get_processorName(dynamic this__) {
  final this_ = this__ as UpperProcessorValue;
  return '${BaseProcessor_get_processorName(this_)}->Upper';
}


class PrefixProcessorValue extends UpperProcessorValue {
  late String prefix;
  PrefixProcessorValue() {
    vptr['process'] = PrefixProcessor_process;
    vptr['get_processorName'] = PrefixProcessor_get_processorName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

PrefixProcessorValue PrefixProcessor_new(dynamic this__, String prefix) {
  final this_ = this__ as PrefixProcessorValue;
  UpperProcessor_new(this_);
  this_.prefix = prefix;
  return this_;
}

String PrefixProcessor_process(dynamic this__, String input) {
  final this_ = this__ as PrefixProcessorValue;
  return '${this_.prefix}:${UpperProcessor_process(this_, input)}';
}

String PrefixProcessor_get_processorName(dynamic this__) {
  final this_ = this__ as PrefixProcessorValue;
  return '${UpperProcessor_get_processorName(this_)}->Prefix(${this_.prefix})';
}


// mixin Addable → static functions for delegation
int Addable_addValues(dynamic this__, int other) {
  final this_ = this__;
  return ((this_.vptr['get_numericValue'] as int Function(dynamic))(this_) + other);
}

int Addable_doubleValue(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['addValues'] as int Function(dynamic, int))(this_, (this_.vptr['get_numericValue'] as int Function(dynamic))(this_));
}


class AmountValue extends Amount_Object_AddableValue {
  late int numericValue;
  AmountValue() {
    vptr['get_numericValue'] = Amount_get_numericValue;
    vptr['addValues'] = Amount_addValues;
    vptr['doubleValue'] = Amount_doubleValue;
    vptr['operatorPlus'] = Amount_operatorPlus;
    vptr['operatorMinus'] = Amount_operatorMinus;
    vptr['operatorLt'] = Amount_operatorLt;
    vptr['operatorGt'] = Amount_operatorGt;
    vptr['toString'] = Amount_toString;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

AmountValue Amount_new(dynamic this__, int numericValue) {
  final this_ = this__ as AmountValue;
  this_.numericValue = numericValue;
  return this_;
}

AmountValue Amount_operatorPlus(dynamic this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return Amount_new(GC.allocateLocal(AmountValue()), (this_.numericValue + other.numericValue));
}

AmountValue Amount_operatorMinus(dynamic this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return Amount_new(GC.allocateLocal(AmountValue()), (this_.numericValue - other.numericValue));
}

bool Amount_operatorLt(dynamic this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return (this_.numericValue < other.numericValue);
}

bool Amount_operatorGt(dynamic this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return (this_.numericValue > other.numericValue);
}

String Amount_toString(dynamic this__) {
  final this_ = this__ as AmountValue;
  return 'Amount(${this_.numericValue})';
}

int Amount_get_numericValue(dynamic this__) {
  final this_ = this__ as AmountValue;
  return this_.numericValue;
}

int Amount_addValues(dynamic this__, int other) {
  final this_ = this__ as AmountValue;
  return Addable_addValues(this_, other);
}

int Amount_doubleValue(dynamic this__) {
  final this_ = this__ as AmountValue;
  return Addable_doubleValue(this_);
}


// mixin Printable2 → static functions for delegation
void Printable2_prettyPrint(dynamic this__) {
  final this_ = this__;
  staticPrint('>> ${(this_.vptr['toPrettyString'] as String Function(dynamic))(this_)}');
}


class VehicleValue extends VPtr {
  late String make;
  late int year;
  VehicleValue() {
    vptr['toString'] = Vehicle_toString;
  }
}

VehicleValue Vehicle_new(dynamic this__, String make, int year) {
  final this_ = this__ as VehicleValue;
  this_.make = make;
  this_.year = year;
  return this_;
}

String Vehicle_toString(dynamic this__) {
  final this_ = this__ as VehicleValue;
  return 'Vehicle(${this_.make}, ${this_.year})';
}


class CarValue extends Car_Vehicle_Printable2Value {
  late int doors;
  CarValue() {
    vptr['toString'] = Car_toString;
    vptr['toPrettyString'] = Car_toPrettyString;
    vptr['prettyPrint'] = Car_prettyPrint;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CarValue Car_new(dynamic this__, String make, int year, int doors) {
  final this_ = this__ as CarValue;
  Vehicle_new(this_, make, year);
  this_.doors = doors;
  return this_;
}

String Car_toPrettyString(dynamic this__) {
  final this_ = this__ as CarValue;
  return 'Car[${this_.make}, ${this_.year}, ${this_.doors}dr]';
}

String Car_toString(dynamic this__) {
  final this_ = this__ as CarValue;
  return 'Car(${this_.make}, ${this_.year}, ${this_.doors}dr)';
}

void Car_prettyPrint(dynamic this__) {
  final this_ = this__ as CarValue;
  Printable2_prettyPrint(this_);
}


class ElectricCarValue extends CarValue {
  late int range;
  ElectricCarValue() {
    vptr['toString'] = ElectricCar_toString;
    vptr['toPrettyString'] = ElectricCar_toPrettyString;
    vptr['prettyPrint'] = ElectricCar_prettyPrint;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

ElectricCarValue ElectricCar_new(dynamic this__, String make, int year, int doors, int range) {
  final this_ = this__ as ElectricCarValue;
  Car_new(this_, make, year, doors);
  this_.range = range;
  return this_;
}

String ElectricCar_toPrettyString(dynamic this__) {
  final this_ = this__ as ElectricCarValue;
  return '${Car_toPrettyString(this_)}+EV(${this_.range}km)';
}

String ElectricCar_toString(dynamic this__) {
  final this_ = this__ as ElectricCarValue;
  return 'ElectricCar(${this_.make}, ${this_.year}, ${this_.doors}dr, ${this_.range}km)';
}

void ElectricCar_prettyPrint(dynamic this__) {
  final this_ = this__ as ElectricCarValue;
  Printable2_prettyPrint(this_);
}


class MeasurableValue extends VPtr {
  MeasurableValue() {
    vptr['measure'] = Measurable_measure;
  }
}

MeasurableValue Measurable_new(dynamic this__) {
  final this_ = this__ as MeasurableValue;
  return this_;
}

double Measurable_measure(dynamic this_) {
  throw UnimplementedError('Measurable.measure is abstract');
}


// mixin Scalable → static functions for delegation
double Scalable_scale(dynamic this__, double factor) {
  final this_ = this__;
  return ((this_.vptr['measure'] as double Function(dynamic))(this_) * factor);
}

String Scalable_measureInfo(dynamic this__) {
  final this_ = this__;
  return 'measure=${(this_.vptr['measure'] as double Function(dynamic))(this_).toStringAsFixed(1)}';
}


class SegmentValue extends Segment_Measurable_ScalableValue {
  late double length;
  SegmentValue() {
    vptr['measure'] = Segment_measure;
    vptr['scale'] = Segment_scale;
    vptr['measureInfo'] = Segment_measureInfo;
    vptr['toString'] = Segment_toString;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

SegmentValue Segment_new(dynamic this__, double length) {
  final this_ = this__ as SegmentValue;
  Measurable_new(this_);
  this_.length = length;
  return this_;
}

double Segment_measure(dynamic this__) {
  final this_ = this__ as SegmentValue;
  return this_.length;
}

String Segment_toString(dynamic this__) {
  final this_ = this__ as SegmentValue;
  return 'Segment(${this_.length}, ${(this_.vptr['measureInfo'] as String Function(dynamic))(this_)})';
}

double Segment_scale(dynamic this__, double factor) {
  final this_ = this__ as SegmentValue;
  return Scalable_scale(this_, factor);
}

String Segment_measureInfo(dynamic this__) {
  final this_ = this__ as SegmentValue;
  return Scalable_measureInfo(this_);
}


class WeightedSegmentValue extends SegmentValue {
  late double weight;
  WeightedSegmentValue() {
    vptr['measure'] = WeightedSegment_measure;
    vptr['scale'] = WeightedSegment_scale;
    vptr['measureInfo'] = WeightedSegment_measureInfo;
    vptr['toString'] = WeightedSegment_toString;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

WeightedSegmentValue WeightedSegment_new(dynamic this__, double length, double weight) {
  final this_ = this__ as WeightedSegmentValue;
  Segment_new(this_, length);
  this_.weight = weight;
  return this_;
}

double WeightedSegment_measure(dynamic this__) {
  final this_ = this__ as WeightedSegmentValue;
  return (this_.length * this_.weight);
}

String WeightedSegment_toString(dynamic this__) {
  final this_ = this__ as WeightedSegmentValue;
  return 'WeightedSegment(len=${this_.length}, w=${this_.weight}, ${(this_.vptr['measureInfo'] as String Function(dynamic))(this_)})';
}

double WeightedSegment_scale(dynamic this__, double factor) {
  final this_ = this__ as WeightedSegmentValue;
  return Scalable_scale(this_, factor);
}

String WeightedSegment_measureInfo(dynamic this__) {
  final this_ = this__ as WeightedSegmentValue;
  return Scalable_measureInfo(this_);
}


// mixin NamedMixin → static functions for delegation
String NamedMixin_get_label(dynamic this__) {
  final this_ = this__;
  return 'NamedMixin';
}

String NamedMixin_greet(dynamic this__) {
  final this_ = this__;
  return 'Hello from ${(this_.vptr['get_label'] as String Function(dynamic))(this_)}';
}


// mixin DescribedMixin → static functions for delegation
String DescribedMixin_get_label(dynamic this__) {
  final this_ = this__;
  return 'DescribedMixin';
}

String DescribedMixin_info(dynamic this__) {
  final this_ = this__;
  return 'Info: ${(this_.vptr['get_label'] as String Function(dynamic))(this_)}';
}


class MultiMixinEntityValue extends MultiMixinEntity_Object_NamedMixin_DescribedMixinValue {
  MultiMixinEntityValue() {
    vptr['get_label'] = MultiMixinEntity_get_label;
    vptr['greet'] = MultiMixinEntity_greet;
    vptr['info'] = MultiMixinEntity_info;
    vptr['fullInfo'] = MultiMixinEntity_fullInfo;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

MultiMixinEntityValue MultiMixinEntity_new(dynamic this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return this_;
}

String MultiMixinEntity_get_label(dynamic this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return 'Entity';
}

String MultiMixinEntity_fullInfo(dynamic this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return '${(this_.vptr['greet'] as String Function(dynamic))(this_)} | ${(this_.vptr['info'] as String Function(dynamic))(this_)}';
}

String MultiMixinEntity_greet(dynamic this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return NamedMixin_greet(this_);
}

String MultiMixinEntity_info(dynamic this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return DescribedMixin_info(this_);
}


class EncoderValue extends VPtr {
  EncoderValue() {
    vptr['encode'] = Encoder_encode;
  }
}

EncoderValue Encoder_new(dynamic this__) {
  final this_ = this__ as EncoderValue;
  return this_;
}

String Encoder_encode(dynamic this_, String input) {
  throw UnimplementedError('Encoder.encode is abstract');
}


// mixin Base64Mixin → static functions for delegation
String Base64Mixin_encode(dynamic this__, String input) {
  final this_ = this__;
  return 'base64(${input})';
}


// mixin HexMixin → static functions for delegation
String HexMixin_encode(dynamic this__, String input) {
  final this_ = this__;
  return 'hex(${input})';
}


class MultiEncoderValue extends MultiEncoder_Object_Base64Mixin_HexMixinValue {
  MultiEncoderValue() {
    vptr['encode'] = MultiEncoder_encode;
    vptr['encodeAll'] = MultiEncoder_encodeAll;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

MultiEncoderValue MultiEncoder_new(dynamic this__) {
  final this_ = this__ as MultiEncoderValue;
  return this_;
}

String MultiEncoder_encodeAll(dynamic this__, String input) {
  final this_ = this__ as MultiEncoderValue;
  return (this_.vptr['encode'] as String Function(dynamic, String))(this_, input);
}

String MultiEncoder_encode(dynamic this__, String input) {
  final this_ = this__ as MultiEncoderValue;
  return HexMixin_encode(this_, input);
}


class CustomEncoderValue extends MultiEncoderValue {
  CustomEncoderValue() {
    vptr['encode'] = CustomEncoder_encode;
    vptr['encodeAll'] = CustomEncoder_encodeAll;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CustomEncoderValue CustomEncoder_new(dynamic this__) {
  final this_ = this__ as CustomEncoderValue;
  MultiEncoder_new(this_);
  return this_;
}

String CustomEncoder_encode(dynamic this__, String input) {
  final this_ = this__ as CustomEncoderValue;
  return 'custom(${MultiEncoder_encode(this_, input)})';
}

String CustomEncoder_encodeAll(dynamic this__, String input) {
  final this_ = this__ as CustomEncoderValue;
  return MultiEncoder_encodeAll(this_, input);
}


class ContainerValue<T> extends VPtr {
  late T item;
  ContainerValue() {
    vptr['describe'] = Container_describe<T>;
    vptr['get_content'] = Container_get_content<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (item is AnyGC) (item as AnyGC).gcMark(flag);
  }
}

ContainerValue<T> Container_new<T>(dynamic this__, T item) {
  final this_ = this__ as ContainerValue<T>;
  this_.item = item;
  return this_;
}

String Container_describe<T>(dynamic this__) {
  final this_ = this__ as ContainerValue<T>;
  return 'Container<${T}>(${this_.item})';
}

T Container_get_content<T>(dynamic this__) {
  final this_ = this__ as ContainerValue<T>;
  return this_.item;
}


class LabeledContainerValue<T> extends ContainerValue<T> {
  late String label;
  LabeledContainerValue() {
    vptr['describe'] = LabeledContainer_describe<T>;
    vptr['get_content'] = LabeledContainer_get_content<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

LabeledContainerValue<T> LabeledContainer_new<T>(dynamic this__, T item, String label) {
  final this_ = this__ as LabeledContainerValue<T>;
  Container_new<T>(this_, item);
  this_.label = label;
  return this_;
}

String LabeledContainer_describe<T>(dynamic this__) {
  final this_ = this__ as LabeledContainerValue<T>;
  return 'Labeled[${this_.label}]: ${Container_describe<T>(this_)}';
}

T LabeledContainer_get_content<T>(dynamic this__) {
  final this_ = this__ as LabeledContainerValue<T>;
  return Container_get_content<T>(this_);
}


class PriorityContainerValue<T> extends LabeledContainerValue<T> {
  late int priority;
  PriorityContainerValue() {
    vptr['describe'] = PriorityContainer_describe<T>;
    vptr['get_content'] = PriorityContainer_get_content<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

PriorityContainerValue<T> PriorityContainer_new<T>(dynamic this__, T item, String label, int priority) {
  final this_ = this__ as PriorityContainerValue<T>;
  LabeledContainer_new<T>(this_, item, label);
  this_.priority = priority;
  return this_;
}

String PriorityContainer_describe<T>(dynamic this__) {
  final this_ = this__ as PriorityContainerValue<T>;
  return '(P${this_.priority}) ${LabeledContainer_describe<T>(this_)}';
}

T PriorityContainer_get_content<T>(dynamic this__) {
  final this_ = this__ as PriorityContainerValue<T>;
  return Container_get_content<T>(this_);
}


// mixin ChainMixin → static functions for delegation
String ChainMixin_step1(dynamic this__) {
  final this_ = this__;
  return 'S1';
}

String ChainMixin_step2(dynamic this__) {
  final this_ = this__;
  return '${(this_.vptr['step1'] as String Function(dynamic))(this_)}->S2';
}

String ChainMixin_step3(dynamic this__) {
  final this_ = this__;
  return '${(this_.vptr['step2'] as String Function(dynamic))(this_)}->S3';
}

String ChainMixin_fullChain(dynamic this__) {
  final this_ = this__;
  return '${(this_.vptr['step3'] as String Function(dynamic))(this_)}->done';
}


class ChainClassValue extends ChainClass_Object_ChainMixinValue {
  ChainClassValue() {
    vptr['step1'] = ChainClass_step1;
    vptr['step2'] = ChainClass_step2;
    vptr['step3'] = ChainClass_step3;
    vptr['fullChain'] = ChainClass_fullChain;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

ChainClassValue ChainClass_new(dynamic this__) {
  final this_ = this__ as ChainClassValue;
  return this_;
}

String ChainClass_step1(dynamic this__) {
  final this_ = this__ as ChainClassValue;
  return 'X1';
}

String ChainClass_step2(dynamic this__) {
  final this_ = this__ as ChainClassValue;
  return ChainMixin_step2(this_);
}

String ChainClass_step3(dynamic this__) {
  final this_ = this__ as ChainClassValue;
  return ChainMixin_step3(this_);
}

String ChainClass_fullChain(dynamic this__) {
  final this_ = this__ as ChainClassValue;
  return ChainMixin_fullChain(this_);
}


class ChainSubClassValue extends ChainClassValue {
  ChainSubClassValue() {
    vptr['step1'] = ChainSubClass_step1;
    vptr['step2'] = ChainSubClass_step2;
    vptr['step3'] = ChainSubClass_step3;
    vptr['fullChain'] = ChainSubClass_fullChain;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

ChainSubClassValue ChainSubClass_new(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  ChainClass_new(this_);
  return this_;
}

String ChainSubClass_step2(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  return '${(this_.vptr['step1'] as String Function(dynamic))(this_)}->Y2';
}

String ChainSubClass_step1(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  return ChainClass_step1(this_);
}

String ChainSubClass_step3(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  return ChainMixin_step3(this_);
}

String ChainSubClass_fullChain(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  return ChainMixin_fullChain(this_);
}


class Expression2Value extends VPtr {
  Expression2Value() {
    vptr['evaluate'] = Expression2_evaluate;
    vptr['display'] = Expression2_display;
  }
}

Expression2Value Expression2_new(dynamic this__) {
  final this_ = this__ as Expression2Value;
  return this_;
}

double Expression2_evaluate(dynamic this_) {
  throw UnimplementedError('Expression2.evaluate is abstract');
}

String Expression2_display(dynamic this_) {
  throw UnimplementedError('Expression2.display is abstract');
}


class NumberExprValue extends Expression2Value {
  late double value;
  NumberExprValue() {
    vptr['evaluate'] = NumberExpr_evaluate;
    vptr['display'] = NumberExpr_display;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

NumberExprValue NumberExpr_new(dynamic this__, double value) {
  final this_ = this__ as NumberExprValue;
  Expression2_new(this_);
  this_.value = value;
  return this_;
}

double NumberExpr_evaluate(dynamic this__) {
  final this_ = this__ as NumberExprValue;
  return this_.value;
}

String NumberExpr_display(dynamic this__) {
  final this_ = this__ as NumberExprValue;
  return ((this_.value == this_.value.toInt()) ? '${this_.value.toInt()}' : '${this_.value}');
}


class BinaryExprValue extends Expression2Value {
  late Expression2Value left;
  late Expression2Value right;
  late String op;
  late TypeFunction2<double, double, double> _compute;
  BinaryExprValue() {
    vptr['evaluate'] = BinaryExpr_evaluate;
    vptr['display'] = BinaryExpr_display;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (left is AnyGC) (left as AnyGC).gcMark(flag);
    if (right is AnyGC) (right as AnyGC).gcMark(flag);
    if (_compute is AnyGC) (_compute as AnyGC).gcMark(flag);
  }
}

BinaryExprValue BinaryExpr_new(dynamic this__, Expression2Value left, Expression2Value right, String op, TypeFunction2<double, double, double> _compute) {
  final this_ = this__ as BinaryExprValue;
  Expression2_new(this_);
  this_.left = left;
  this_.right = right;
  this_.op = op;
  this_._compute = _compute;
  return this_;
}

BinaryExprValue BinaryExpr_new_add(Expression2Value l, Expression2Value r) {
  return BinaryExpr_new(GC.allocateLocal(BinaryExprValue()), l, r, '+', ClosureEnv_anon_0_new(GC.allocateLocal(ClosureEnv_anon_0())));
}

BinaryExprValue BinaryExpr_new_mul(Expression2Value l, Expression2Value r) {
  return BinaryExpr_new(GC.allocateLocal(BinaryExprValue()), l, r, '*', ClosureEnv_anon_1_new(GC.allocateLocal(ClosureEnv_anon_1())));
}

double BinaryExpr_evaluate(dynamic this__) {
  final this_ = this__ as BinaryExprValue;
  return (() { final _let0 = (this_.left.vptr['evaluate'] as double Function(dynamic))(this_.left); return (() { final _let1 = (this_.right.vptr['evaluate'] as double Function(dynamic))(this_.right); return this_._compute.closureCall(this_._compute, _let0, _let1); })(); })();
}

String BinaryExpr_display(dynamic this__) {
  final this_ = this__ as BinaryExprValue;
  return '(${(this_.left.vptr['display'] as String Function(dynamic))(this_.left)} ${this_.op} ${(this_.right.vptr['display'] as String Function(dynamic))(this_.right)})';
}


// mixin HealthMixin → static functions for delegation
int HealthMixin_get_maxHealth(dynamic this__) {
  final this_ = this__;
  return 100;
}

int HealthMixin_get_health(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['get_maxHealth'] as int Function(dynamic))(this_);
}

String HealthMixin_healthBar(dynamic this__) {
  final this_ = this__;
  return 'HP:${(this_.vptr['get_health'] as int Function(dynamic))(this_)}/${(this_.vptr['get_maxHealth'] as int Function(dynamic))(this_)}';
}


// mixin ManaMixin → static functions for delegation
int ManaMixin_get_maxMana(dynamic this__) {
  final this_ = this__;
  return 50;
}

int ManaMixin_get_mana(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['get_maxMana'] as int Function(dynamic))(this_);
}

String ManaMixin_manaBar(dynamic this__) {
  final this_ = this__;
  return 'MP:${(this_.vptr['get_mana'] as int Function(dynamic))(this_)}/${(this_.vptr['get_maxMana'] as int Function(dynamic))(this_)}';
}


// mixin StaminaMixin → static functions for delegation
int StaminaMixin_get_maxStamina(dynamic this__) {
  final this_ = this__;
  return 80;
}

int StaminaMixin_get_stamina(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['get_maxStamina'] as int Function(dynamic))(this_);
}

String StaminaMixin_staminaBar(dynamic this__) {
  final this_ = this__;
  return 'SP:${(this_.vptr['get_stamina'] as int Function(dynamic))(this_)}/${(this_.vptr['get_maxStamina'] as int Function(dynamic))(this_)}';
}


class GameCharacterValue extends GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue {
  late String name;
  GameCharacterValue() {
    vptr['get_maxHealth'] = GameCharacter_get_maxHealth;
    vptr['get_health'] = GameCharacter_get_health;
    vptr['healthBar'] = GameCharacter_healthBar;
    vptr['get_maxMana'] = GameCharacter_get_maxMana;
    vptr['get_mana'] = GameCharacter_get_mana;
    vptr['manaBar'] = GameCharacter_manaBar;
    vptr['get_maxStamina'] = GameCharacter_get_maxStamina;
    vptr['get_stamina'] = GameCharacter_get_stamina;
    vptr['staminaBar'] = GameCharacter_staminaBar;
    vptr['statusBars'] = GameCharacter_statusBars;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

GameCharacterValue GameCharacter_new(dynamic this__, String name) {
  final this_ = this__ as GameCharacterValue;
  this_.name = name;
  return this_;
}

String GameCharacter_statusBars(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return '${this_.name}: ${(this_.vptr['healthBar'] as String Function(dynamic))(this_)} ${(this_.vptr['manaBar'] as String Function(dynamic))(this_)} ${(this_.vptr['staminaBar'] as String Function(dynamic))(this_)}';
}

int GameCharacter_get_maxHealth(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return HealthMixin_get_maxHealth(this_);
}

int GameCharacter_get_health(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return HealthMixin_get_health(this_);
}

String GameCharacter_healthBar(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return HealthMixin_healthBar(this_);
}

int GameCharacter_get_maxMana(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return ManaMixin_get_maxMana(this_);
}

int GameCharacter_get_mana(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return ManaMixin_get_mana(this_);
}

String GameCharacter_manaBar(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return ManaMixin_manaBar(this_);
}

int GameCharacter_get_maxStamina(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return StaminaMixin_get_maxStamina(this_);
}

int GameCharacter_get_stamina(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return StaminaMixin_get_stamina(this_);
}

String GameCharacter_staminaBar(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return StaminaMixin_staminaBar(this_);
}


class WarriorValue extends GameCharacterValue {
  WarriorValue() {
    vptr['get_maxHealth'] = Warrior_get_maxHealth;
    vptr['get_health'] = Warrior_get_health;
    vptr['healthBar'] = Warrior_healthBar;
    vptr['get_maxMana'] = Warrior_get_maxMana;
    vptr['get_mana'] = Warrior_get_mana;
    vptr['manaBar'] = Warrior_manaBar;
    vptr['get_maxStamina'] = Warrior_get_maxStamina;
    vptr['get_stamina'] = Warrior_get_stamina;
    vptr['staminaBar'] = Warrior_staminaBar;
    vptr['statusBars'] = Warrior_statusBars;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

WarriorValue Warrior_new(dynamic this__, String name) {
  final this_ = this__ as WarriorValue;
  GameCharacter_new(this_, name);
  return this_;
}

int Warrior_get_maxHealth(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return 150;
}

int Warrior_get_maxStamina(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return 120;
}

int Warrior_get_health(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return HealthMixin_get_health(this_);
}

String Warrior_healthBar(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return HealthMixin_healthBar(this_);
}

int Warrior_get_maxMana(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return ManaMixin_get_maxMana(this_);
}

int Warrior_get_mana(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return ManaMixin_get_mana(this_);
}

String Warrior_manaBar(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return ManaMixin_manaBar(this_);
}

int Warrior_get_stamina(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return StaminaMixin_get_stamina(this_);
}

String Warrior_staminaBar(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return StaminaMixin_staminaBar(this_);
}

String Warrior_statusBars(dynamic this__) {
  final this_ = this__ as WarriorValue;
  return GameCharacter_statusBars(this_);
}


class MageValue extends GameCharacterValue {
  MageValue() {
    vptr['get_maxHealth'] = Mage_get_maxHealth;
    vptr['get_health'] = Mage_get_health;
    vptr['healthBar'] = Mage_healthBar;
    vptr['get_maxMana'] = Mage_get_maxMana;
    vptr['get_mana'] = Mage_get_mana;
    vptr['manaBar'] = Mage_manaBar;
    vptr['get_maxStamina'] = Mage_get_maxStamina;
    vptr['get_stamina'] = Mage_get_stamina;
    vptr['staminaBar'] = Mage_staminaBar;
    vptr['statusBars'] = Mage_statusBars;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

MageValue Mage_new(dynamic this__, String name) {
  final this_ = this__ as MageValue;
  GameCharacter_new(this_, name);
  return this_;
}

int Mage_get_maxMana(dynamic this__) {
  final this_ = this__ as MageValue;
  return 200;
}

int Mage_get_maxHealth(dynamic this__) {
  final this_ = this__ as MageValue;
  return 60;
}

int Mage_get_health(dynamic this__) {
  final this_ = this__ as MageValue;
  return HealthMixin_get_health(this_);
}

String Mage_healthBar(dynamic this__) {
  final this_ = this__ as MageValue;
  return HealthMixin_healthBar(this_);
}

int Mage_get_mana(dynamic this__) {
  final this_ = this__ as MageValue;
  return ManaMixin_get_mana(this_);
}

String Mage_manaBar(dynamic this__) {
  final this_ = this__ as MageValue;
  return ManaMixin_manaBar(this_);
}

int Mage_get_maxStamina(dynamic this__) {
  final this_ = this__ as MageValue;
  return StaminaMixin_get_maxStamina(this_);
}

int Mage_get_stamina(dynamic this__) {
  final this_ = this__ as MageValue;
  return StaminaMixin_get_stamina(this_);
}

String Mage_staminaBar(dynamic this__) {
  final this_ = this__ as MageValue;
  return StaminaMixin_staminaBar(this_);
}

String Mage_statusBars(dynamic this__) {
  final this_ = this__ as MageValue;
  return GameCharacter_statusBars(this_);
}


class DiamondClass_Object_LoggerValue extends VPtr {
  DiamondClass_Object_LoggerValue() {
    vptr['get_prefix'] = Logger_get_prefix;
    vptr['format'] = Logger_format;
  }
}


class DiamondClass_Object_Logger_FormatterValue extends DiamondClass_Object_LoggerValue {
  DiamondClass_Object_Logger_FormatterValue() {
    vptr['get_prefix'] = Formatter_get_prefix;
    vptr['format'] = Formatter_format;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class StatefulWidget_Object_StatefulMixinValue extends VPtr {
  late int _counter;
  StatefulWidget_Object_StatefulMixinValue() {
    vptr['get_counter'] = StatefulMixin_get_counter;
    vptr['set_counter'] = StatefulMixin_set_counter;
    vptr['increment'] = StatefulMixin_increment;
    vptr['decrement'] = StatefulMixin_decrement;
    vptr['get_counterStatus'] = StatefulMixin_get_counterStatus;
  }
}


class DeepMixinClass_Object_LayerAValue extends VPtr {
  DeepMixinClass_Object_LayerAValue() {
    vptr['layer'] = LayerA_layer;
    vptr['onlyA'] = LayerA_onlyA;
  }
}


class DeepMixinClass_Object_LayerA_LayerBValue extends DeepMixinClass_Object_LayerAValue {
  DeepMixinClass_Object_LayerA_LayerBValue() {
    vptr['layer'] = LayerB_layer;
    vptr['onlyB'] = LayerB_onlyB;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class DeepMixinClass_Object_LayerA_LayerB_LayerCValue extends DeepMixinClass_Object_LayerA_LayerBValue {
  DeepMixinClass_Object_LayerA_LayerB_LayerCValue() {
    vptr['layer'] = LayerC_layer;
    vptr['onlyC'] = LayerC_onlyC;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Box_Object_MappableValue<T> extends VPtr {
  Box_Object_MappableValue() {
    vptr['mapValue'] = Mappable_mapValue<T, dynamic>;
    vptr['describe'] = Mappable_describe<T>;
  }
}


class Box_Object_Mappable_FilterableValue<T> extends Box_Object_MappableValue<T> {
  Box_Object_Mappable_FilterableValue() {
    vptr['test'] = Filterable_test<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class TaggedResource_Resource_TaggableValue extends ResourceValue {
  late StaticList<String> _tags;
  TaggedResource_Resource_TaggableValue() {
    vptr['tag'] = Taggable_tag;
    vptr['get_allTags'] = Taggable_get_allTags;
    vptr['hasTag'] = Taggable_hasTag;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_tags is AnyGC) (_tags as AnyGC).gcMark(flag);
  }
}


class Amount_Object_AddableValue extends VPtr {
  Amount_Object_AddableValue() {
    vptr['addValues'] = Addable_addValues;
    vptr['doubleValue'] = Addable_doubleValue;
  }
}


class Car_Vehicle_Printable2Value extends VehicleValue {
  Car_Vehicle_Printable2Value() {
    vptr['prettyPrint'] = Printable2_prettyPrint;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Segment_Measurable_ScalableValue extends MeasurableValue {
  Segment_Measurable_ScalableValue() {
    vptr['scale'] = Scalable_scale;
    vptr['measureInfo'] = Scalable_measureInfo;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class MultiMixinEntity_Object_NamedMixinValue extends VPtr {
  MultiMixinEntity_Object_NamedMixinValue() {
    vptr['get_label'] = NamedMixin_get_label;
    vptr['greet'] = NamedMixin_greet;
  }
}


class MultiMixinEntity_Object_NamedMixin_DescribedMixinValue extends MultiMixinEntity_Object_NamedMixinValue {
  MultiMixinEntity_Object_NamedMixin_DescribedMixinValue() {
    vptr['get_label'] = DescribedMixin_get_label;
    vptr['info'] = DescribedMixin_info;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class MultiEncoder_Object_Base64MixinValue extends VPtr {
  MultiEncoder_Object_Base64MixinValue() {
    vptr['encode'] = Base64Mixin_encode;
  }
}


class MultiEncoder_Object_Base64Mixin_HexMixinValue extends MultiEncoder_Object_Base64MixinValue {
  MultiEncoder_Object_Base64Mixin_HexMixinValue() {
    vptr['encode'] = HexMixin_encode;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class ChainClass_Object_ChainMixinValue extends VPtr {
  ChainClass_Object_ChainMixinValue() {
    vptr['step1'] = ChainMixin_step1;
    vptr['step2'] = ChainMixin_step2;
    vptr['step3'] = ChainMixin_step3;
    vptr['fullChain'] = ChainMixin_fullChain;
  }
}


class GameCharacter_Object_HealthMixinValue extends VPtr {
  GameCharacter_Object_HealthMixinValue() {
    vptr['get_maxHealth'] = HealthMixin_get_maxHealth;
    vptr['get_health'] = HealthMixin_get_health;
    vptr['healthBar'] = HealthMixin_healthBar;
  }
}


class GameCharacter_Object_HealthMixin_ManaMixinValue extends GameCharacter_Object_HealthMixinValue {
  GameCharacter_Object_HealthMixin_ManaMixinValue() {
    vptr['get_maxMana'] = ManaMixin_get_maxMana;
    vptr['get_mana'] = ManaMixin_get_mana;
    vptr['manaBar'] = ManaMixin_manaBar;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue extends GameCharacter_Object_HealthMixin_ManaMixinValue {
  GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue() {
    vptr['get_maxStamina'] = StaminaMixin_get_maxStamina;
    vptr['get_stamina'] = StaminaMixin_get_stamina;
    vptr['staminaBar'] = StaminaMixin_staminaBar;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


void main() {
  staticPrint('=== 复杂 OOP 边界测试 ===\n');
  staticPrint('--- 1. 菱形继承 ---');
  final DiamondClassValue diamond = DiamondClass_new(GC.allocateLocal(DiamondClassValue()), 'DC');
  staticPrint('prefix: ${(diamond.vptr['get_prefix'] as String Function(dynamic))(diamond)}');
  staticPrint('format: ${(diamond.vptr['format'] as String Function(dynamic, String))(diamond, 'hello')}');
  staticPrint('display: ${(diamond.vptr['display'] as String Function(dynamic, String))(diamond, 'world')}');
  staticPrint('\n--- 2. StatefulMixin ---');
  final StatefulWidgetValue widget = StatefulWidget_new(GC.allocateLocal(StatefulWidgetValue()), 'btn1');
  staticPrint('initial: ${widget}');
  (widget.vptr['increment'] as void Function(dynamic))(widget);
  (widget.vptr['increment'] as void Function(dynamic))(widget);
  (widget.vptr['increment'] as void Function(dynamic))(widget);
  staticPrint('after 3 inc: ${widget}');
  (widget.vptr['decrement'] as void Function(dynamic))(widget);
  staticPrint('after 1 dec: ${widget}');
  (widget.vptr['set_counter'] as void Function(dynamic, int))(widget, 10);
  staticPrint('after set 10: ${widget}');
  staticPrint('\n--- 3. 深层 mixin 链 ---');
  final DeepMixinClassValue deep = DeepMixinClass_new(GC.allocateLocal(DeepMixinClassValue()));
  staticPrint('layer: ${(deep.vptr['layer'] as String Function(dynamic))(deep)}');
  staticPrint('allLayers: ${(deep.vptr['allLayers'] as String Function(dynamic))(deep)}');
  staticPrint('\n--- 4. 泛型 mixin ---');
  final BoxValue<int> intBox = Box_new<int>(GC.allocateLocal(BoxValue<int>()), 42);
  staticPrint('intBox: ${intBox}');
  staticPrint('describe: ${(intBox.vptr['describe'] as String Function(dynamic))(intBox)}');
  staticPrint('mapValue: ${(intBox.vptr['mapValue_int'] as int Function(dynamic, TypeFunction1<int, int>))(intBox, ClosureEnv_main_3_new(GC.allocateLocal(ClosureEnv_main_3())))}');
  staticPrint('test >10: ${(intBox.vptr['test'] as bool Function(dynamic, TypeFunction1<bool, int>))(intBox, ClosureEnv_main_5_new(GC.allocateLocal(ClosureEnv_main_5())))}');
  staticPrint('test >100: ${(intBox.vptr['test'] as bool Function(dynamic, TypeFunction1<bool, int>))(intBox, ClosureEnv_main_7_new(GC.allocateLocal(ClosureEnv_main_7())))}');
  final BoxValue<String> strBox = Box_new<String>(GC.allocateLocal(BoxValue<String>()), 'dart');
  staticPrint('strBox mapValue: ${(strBox.vptr['mapValue_String'] as String Function(dynamic, TypeFunction1<String, String>))(strBox, ClosureEnv_main_9_new(GC.allocateLocal(ClosureEnv_main_9())))}');
  staticPrint('\n--- 5. 抽象+mixin+implements ---');
  final TaggedResourceValue res = TaggedResource_new(GC.allocateLocal(TaggedResourceValue()), 'r1', 'file');
  (res.vptr['tag'] as void Function(dynamic, String))(res, 'important');
  (res.vptr['tag'] as void Function(dynamic, String))(res, 'v2');
  staticPrint('describe: ${(res.vptr['describe'] as String Function(dynamic))(res)}');
  staticPrint('id: ${res.id}');
  staticPrint('hasTag important: ${(res.vptr['hasTag'] as bool Function(dynamic, String))(res, 'important')}');
  staticPrint('hasTag draft: ${(res.vptr['hasTag'] as bool Function(dynamic, String))(res, 'draft')}');
  staticPrint('\n--- 6. super 调用链 ---');
  final BaseProcessorValue base = BaseProcessor_new(GC.allocateLocal(BaseProcessorValue()));
  staticPrint('base: ${(base.vptr['process'] as String Function(dynamic, String))(base, '  hello  ')} (${(base.vptr['get_processorName'] as String Function(dynamic))(base)})');
  final UpperProcessorValue upper = UpperProcessor_new(GC.allocateLocal(UpperProcessorValue()));
  staticPrint('upper: ${(upper.vptr['process'] as String Function(dynamic, String))(upper, '  hello  ')} (${(upper.vptr['get_processorName'] as String Function(dynamic))(upper)})');
  final PrefixProcessorValue prefix = PrefixProcessor_new(GC.allocateLocal(PrefixProcessorValue()), 'PRE');
  staticPrint('prefix: ${(prefix.vptr['process'] as String Function(dynamic, String))(prefix, '  hello  ')} (${(prefix.vptr['get_processorName'] as String Function(dynamic))(prefix)})');
  staticPrint('\n--- 7. mixin + operator ---');
  final AmountValue a1 = Amount_new(GC.allocateLocal(AmountValue()), 10);
  final AmountValue a2 = Amount_new(GC.allocateLocal(AmountValue()), 5);
  staticPrint('a1 + a2: ${(a1.vptr['operatorPlus'] as AmountValue Function(dynamic, AmountValue))(a1, a2)}');
  staticPrint('a1 - a2: ${(a1.vptr['operatorMinus'] as AmountValue Function(dynamic, AmountValue))(a1, a2)}');
  staticPrint('a1 < a2: ${(a1.vptr['operatorLt'] as bool Function(dynamic, AmountValue))(a1, a2)}');
  staticPrint('a1 > a2: ${(a1.vptr['operatorGt'] as bool Function(dynamic, AmountValue))(a1, a2)}');
  staticPrint('doubleValue: ${(a1.vptr['doubleValue'] as int Function(dynamic))(a1)}');
  staticPrint('addValues: ${(a1.vptr['addValues'] as int Function(dynamic, int))(a1, 3)}');
  staticPrint('\n--- 8. 多层继承+mixin ---');
  final CarValue car = Car_new(GC.allocateLocal(CarValue()), 'Toyota', 2024, 4);
  staticPrint('car: ${car}');
  (car.vptr['prettyPrint'] as void Function(dynamic))(car);
  final ElectricCarValue ev = ElectricCar_new(GC.allocateLocal(ElectricCarValue()), 'Tesla', 2025, 4, 500);
  staticPrint('ev: ${ev}');
  (ev.vptr['prettyPrint'] as void Function(dynamic))(ev);
  staticPrint('\n--- 9. mixin on 约束 ---');
  final SegmentValue seg = Segment_new(GC.allocateLocal(SegmentValue()), 10.0);
  staticPrint('seg: ${seg}');
  staticPrint('scale(2): ${(seg.vptr['scale'] as double Function(dynamic, double))(seg, 2.0)}');
  final WeightedSegmentValue wseg = WeightedSegment_new(GC.allocateLocal(WeightedSegmentValue()), 10.0, 0.5);
  staticPrint('wseg: ${wseg}');
  staticPrint('wseg.scale(3): ${(wseg.vptr['scale'] as double Function(dynamic, double))(wseg, 3.0)}');
  staticPrint('\n--- 10. 多 mixin 同名 getter ---');
  final MultiMixinEntityValue entity = MultiMixinEntity_new(GC.allocateLocal(MultiMixinEntityValue()));
  staticPrint('label: ${(entity.vptr['get_label'] as String Function(dynamic))(entity)}');
  staticPrint('greet: ${(entity.vptr['greet'] as String Function(dynamic))(entity)}');
  staticPrint('info: ${(entity.vptr['info'] as String Function(dynamic))(entity)}');
  staticPrint('fullInfo: ${(entity.vptr['fullInfo'] as String Function(dynamic))(entity)}');
  staticPrint('\n--- 11. 接口+mixin 覆盖 ---');
  final MultiEncoderValue multi = MultiEncoder_new(GC.allocateLocal(MultiEncoderValue()));
  staticPrint('multi.encode: ${(multi.vptr['encode'] as String Function(dynamic, String))(multi, 'abc')}');
  staticPrint('multi.encodeAll: ${(multi.vptr['encodeAll'] as String Function(dynamic, String))(multi, 'xyz')}');
  final CustomEncoderValue custom = CustomEncoder_new(GC.allocateLocal(CustomEncoderValue()));
  staticPrint('custom.encode: ${(custom.vptr['encode'] as String Function(dynamic, String))(custom, 'abc')}');
  staticPrint('custom.encodeAll: ${(custom.vptr['encodeAll'] as String Function(dynamic, String))(custom, 'xyz')}');
  staticPrint('\n--- 12. 泛型继承链 ---');
  final ContainerValue<int> c1 = Container_new<int>(GC.allocateLocal(ContainerValue<int>()), 42);
  staticPrint('c1: ${(c1.vptr['describe'] as String Function(dynamic))(c1)}');
  final LabeledContainerValue<String> c2 = LabeledContainer_new<String>(GC.allocateLocal(LabeledContainerValue<String>()), 'hello', 'greeting');
  staticPrint('c2: ${(c2.vptr['describe'] as String Function(dynamic))(c2)}');
  final PriorityContainerValue<double> c3 = PriorityContainer_new<double>(GC.allocateLocal(PriorityContainerValue<double>()), 3.14, 'pi', 1);
  staticPrint('c3: ${(c3.vptr['describe'] as String Function(dynamic))(c3)}');
  staticPrint('c3.content: ${(c3.vptr['get_content'] as double Function(dynamic))(c3)}');
  staticPrint('\n--- 13. mixin 调用链 ---');
  final ChainClassValue chain1 = ChainClass_new(GC.allocateLocal(ChainClassValue()));
  staticPrint('chain1.fullChain: ${(chain1.vptr['fullChain'] as String Function(dynamic))(chain1)}');
  staticPrint('chain1.step3: ${(chain1.vptr['step3'] as String Function(dynamic))(chain1)}');
  final ChainSubClassValue chain2 = ChainSubClass_new(GC.allocateLocal(ChainSubClassValue()));
  staticPrint('chain2.fullChain: ${(chain2.vptr['fullChain'] as String Function(dynamic))(chain2)}');
  staticPrint('chain2.step3: ${(chain2.vptr['step3'] as String Function(dynamic))(chain2)}');
  staticPrint('\n--- 14. 表达式树 ---');
  final BinaryExprValue expr = BinaryExpr_new_add(NumberExpr_new(GC.allocateLocal(NumberExprValue()), 3.0), BinaryExpr_new_mul(NumberExpr_new(GC.allocateLocal(NumberExprValue()), 4.0), NumberExpr_new(GC.allocateLocal(NumberExprValue()), 5.0)));
  staticPrint('expr: ${(expr.vptr['display'] as String Function(dynamic))(expr)}');
  staticPrint('result: ${(expr.vptr['evaluate'] as double Function(dynamic))(expr)}');
  staticPrint('\n--- 15. 游戏角色 ---');
  final GameCharacterValue hero = GameCharacter_new(GC.allocateLocal(GameCharacterValue()), 'Hero');
  staticPrint((hero.vptr['statusBars'] as String Function(dynamic))(hero));
  final WarriorValue warrior = Warrior_new(GC.allocateLocal(WarriorValue()), 'Conan');
  staticPrint((warrior.vptr['statusBars'] as String Function(dynamic))(warrior));
  final MageValue mage = Mage_new(GC.allocateLocal(MageValue()), 'Gandalf');
  staticPrint((mage.vptr['statusBars'] as String Function(dynamic))(mage));
  staticPrint('\n=== 所有复杂 OOP 测试通过 ✅ ===');
}

class ClosureEnv_anon_0 extends TypeFunction2<double, double, double> {
  ClosureEnv_anon_0();
  @override
  double call(double a, double b) => closureCall(this, a, b);
}
ClosureEnv_anon_0 ClosureEnv_anon_0_new(ClosureEnv_anon_0 env_) {
  env_.closureCall = ClosureEnv_anon_0_call;
  return env_;
}
double ClosureEnv_anon_0_call(dynamic env__, double a, double b) {
  final env = env__ as ClosureEnv_anon_0;

  return (a + b);
}

class ClosureEnv_anon_1 extends TypeFunction2<double, double, double> {
  ClosureEnv_anon_1();
  @override
  double call(double a, double b) => closureCall(this, a, b);
}
ClosureEnv_anon_1 ClosureEnv_anon_1_new(ClosureEnv_anon_1 env_) {
  env_.closureCall = ClosureEnv_anon_1_call;
  return env_;
}
double ClosureEnv_anon_1_call(dynamic env__, double a, double b) {
  final env = env__ as ClosureEnv_anon_1;

  return (a * b);
}

class ClosureEnv_main_2 extends TypeFunction1<int, int> {
  ClosureEnv_main_2();
  @override
  int call(int v) => closureCall(this, v);
}
ClosureEnv_main_2 ClosureEnv_main_2_new(ClosureEnv_main_2 env_) {
  env_.closureCall = ClosureEnv_main_2_call;
  return env_;
}
int ClosureEnv_main_2_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_main_2;

  return (v * 2);
}

class ClosureEnv_main_3 extends TypeFunction1<int, int> {
  ClosureEnv_main_3();
  @override
  int call(int v) => closureCall(this, v);
}
ClosureEnv_main_3 ClosureEnv_main_3_new(ClosureEnv_main_3 env_) {
  env_.closureCall = ClosureEnv_main_3_call;
  return env_;
}
int ClosureEnv_main_3_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_main_3;

  return (v * 2);
}

class ClosureEnv_main_4 extends TypeFunction1<bool, int> {
  ClosureEnv_main_4();
  @override
  bool call(int v) => closureCall(this, v);
}
ClosureEnv_main_4 ClosureEnv_main_4_new(ClosureEnv_main_4 env_) {
  env_.closureCall = ClosureEnv_main_4_call;
  return env_;
}
bool ClosureEnv_main_4_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_main_4;

  return (v > 10);
}

class ClosureEnv_main_5 extends TypeFunction1<bool, int> {
  ClosureEnv_main_5();
  @override
  bool call(int v) => closureCall(this, v);
}
ClosureEnv_main_5 ClosureEnv_main_5_new(ClosureEnv_main_5 env_) {
  env_.closureCall = ClosureEnv_main_5_call;
  return env_;
}
bool ClosureEnv_main_5_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_main_5;

  return (v > 10);
}

class ClosureEnv_main_6 extends TypeFunction1<bool, int> {
  ClosureEnv_main_6();
  @override
  bool call(int v) => closureCall(this, v);
}
ClosureEnv_main_6 ClosureEnv_main_6_new(ClosureEnv_main_6 env_) {
  env_.closureCall = ClosureEnv_main_6_call;
  return env_;
}
bool ClosureEnv_main_6_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_main_6;

  return (v > 100);
}

class ClosureEnv_main_7 extends TypeFunction1<bool, int> {
  ClosureEnv_main_7();
  @override
  bool call(int v) => closureCall(this, v);
}
ClosureEnv_main_7 ClosureEnv_main_7_new(ClosureEnv_main_7 env_) {
  env_.closureCall = ClosureEnv_main_7_call;
  return env_;
}
bool ClosureEnv_main_7_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_main_7;

  return (v > 100);
}

class ClosureEnv_main_8 extends TypeFunction1<String, String> {
  ClosureEnv_main_8();
  @override
  String call(String s) => closureCall(this, s);
}
ClosureEnv_main_8 ClosureEnv_main_8_new(ClosureEnv_main_8 env_) {
  env_.closureCall = ClosureEnv_main_8_call;
  return env_;
}
String ClosureEnv_main_8_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_8;

  return s.toUpperCase();
}

class ClosureEnv_main_9 extends TypeFunction1<String, String> {
  ClosureEnv_main_9();
  @override
  String call(String s) => closureCall(this, s);
}
ClosureEnv_main_9 ClosureEnv_main_9_new(ClosureEnv_main_9 env_) {
  env_.closureCall = ClosureEnv_main_9_call;
  return env_;
}
String ClosureEnv_main_9_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_9;

  return s.toUpperCase();
}


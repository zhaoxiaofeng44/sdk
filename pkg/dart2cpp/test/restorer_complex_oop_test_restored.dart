import 'package:dart2cpp/restorer/runtime_classes.dart';

// mixin Logger → static functions for delegation
String Logger_get_prefix(dynamic this__) {
  final this_ = this__;
  return 'LOG';
}

String Logger_format(dynamic this__, String msg) {
  final this_ = this__;
  return '[${(this_.vptr['get_prefix'] as TypeFunction1<String, dynamic>)(this_)}] ${msg}';
}


// mixin Formatter → static functions for delegation
String Formatter_get_prefix(dynamic this__) {
  final this_ = this__;
  return 'FMT';
}

String Formatter_format(dynamic this__, String msg) {
  final this_ = this__;
  return '{${(this_.vptr['get_prefix'] as TypeFunction1<String, dynamic>)(this_)}: ${msg}}';
}


class DiamondClassValue extends DiamondClass_Object_Logger_FormatterValue {
  late String name;
  DiamondClassValue() {
    vptr['get_prefix'] = const _TearOff_DiamondClass_get_prefix();
    vptr['format'] = const _TearOff_DiamondClass_format();
    vptr['display'] = const _TearOff_DiamondClass_display();
  }
}

DiamondClassValue DiamondClass_new(dynamic this__, String name) {
  final this_ = this__ as DiamondClassValue;
  this_.name = name;
  return this_;
}

String DiamondClass_display(dynamic this__, String msg) {
  final this_ = this__ as DiamondClassValue;
  return '${this_.name}: ${(this_.vptr['format'] as TypeFunction2<String, dynamic, String>)(this_, msg)}';
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
  (this_.vptr['set_counter'] as TypeFunction2<void, dynamic, int>)(this_, ((this_.vptr['get_counter'] as TypeFunction1<int, dynamic>)(this_) + 1));
}

void StatefulMixin_decrement(dynamic this__) {
  final this_ = this__;
  (this_.vptr['set_counter'] as TypeFunction2<void, dynamic, int>)(this_, ((this_.vptr['get_counter'] as TypeFunction1<int, dynamic>)(this_) - 1));
}

String StatefulMixin_get_counterStatus(dynamic this__) {
  final this_ = this__;
  return 'count=${(this_.vptr['get_counter'] as TypeFunction1<int, dynamic>)(this_)}';
}


class StatefulWidgetValue extends StatefulWidget_Object_StatefulMixinValue {
  late String id;
  StatefulWidgetValue() {
    vptr['get_counter'] = const _TearOff_StatefulWidget_get_counter();
    vptr['set_counter'] = const _TearOff_StatefulWidget_set_counter();
    vptr['increment'] = const _TearOff_StatefulWidget_increment();
    vptr['decrement'] = const _TearOff_StatefulWidget_decrement();
    vptr['get_counterStatus'] = const _TearOff_StatefulWidget_get_counterStatus();
    vptr['toString'] = const _TearOff_StatefulWidget_toString();
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
  return 'Widget(${this_.id}, ${(this_.vptr['get_counterStatus'] as TypeFunction1<String, dynamic>)(this_)})';
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
    vptr['layer'] = const _TearOff_DeepMixinClass_layer();
    vptr['onlyA'] = const _TearOff_DeepMixinClass_onlyA();
    vptr['onlyB'] = const _TearOff_DeepMixinClass_onlyB();
    vptr['onlyC'] = const _TearOff_DeepMixinClass_onlyC();
    vptr['allLayers'] = const _TearOff_DeepMixinClass_allLayers();
  }
}

DeepMixinClassValue DeepMixinClass_new(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return this_;
}

String DeepMixinClass_allLayers(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return '${(this_.vptr['layer'] as TypeFunction1<String, dynamic>)(this_)}-${(this_.vptr['onlyA'] as TypeFunction1<String, dynamic>)(this_)}-${(this_.vptr['onlyB'] as TypeFunction1<String, dynamic>)(this_)}-${(this_.vptr['onlyC'] as TypeFunction1<String, dynamic>)(this_)}';
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
  return transform((this_.vptr['get_value'] as TypeFunction1<T, dynamic>)(this_));
}

String Mappable_describe<T>(dynamic this__) {
  final this_ = this__;
  return 'Mappable<${T}>(${(this_.vptr['get_value'] as TypeFunction1<T, dynamic>)(this_)})';
}


// mixin Filterable → static functions for delegation
bool Filterable_test<T>(dynamic this__, TypeFunction1<bool, T> predicate) {
  final this_ = this__;
  return predicate((this_.vptr['get_value'] as TypeFunction1<T, dynamic>)(this_));
}


class BoxValue<T> extends Box_Object_Mappable_FilterableValue<T> {
  late T value;
  BoxValue() {
    vptr['get_value'] = _TearOff_Box_get_value<T>();
    vptr['describe'] = _TearOff_Box_describe<T>();
    vptr['test'] = _TearOff_Box_test<T>();
    vptr['toString'] = _TearOff_Box_toString<T>();
  }
}

BoxValue<T> Box_new<T>(dynamic this__, T value) {
  final this_ = this__ as BoxValue<T>;
  this_.vptr['mapValue_int'] = _TearOff_Box_mapValue_int<T>();
  this_.vptr['mapValue_String'] = _TearOff_Box_mapValue_String<T>();
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
    vptr['get_id'] = const _TearOff_Identifiable_get_id();
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
    vptr['describe'] = const _TearOff_Describable_describe();
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
    vptr['describe'] = const _TearOff_Resource_describe();
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
    vptr['describe'] = const _TearOff_TaggedResource_describe();
    vptr['tag'] = const _TearOff_TaggedResource_tag();
    vptr['get_allTags'] = const _TearOff_TaggedResource_get_allTags();
    vptr['hasTag'] = const _TearOff_TaggedResource_hasTag();
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
  return '${Resource_describe(this_)}, tags=${(this_.vptr['get_allTags'] as TypeFunction1<StaticList<String>, dynamic>)(this_)}';
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
    vptr['process'] = const _TearOff_BaseProcessor_process();
    vptr['get_processorName'] = const _TearOff_BaseProcessor_get_processorName();
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
    vptr['process'] = const _TearOff_UpperProcessor_process();
    vptr['get_processorName'] = const _TearOff_UpperProcessor_get_processorName();
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
    vptr['process'] = const _TearOff_PrefixProcessor_process();
    vptr['get_processorName'] = const _TearOff_PrefixProcessor_get_processorName();
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
  return ((this_.vptr['get_numericValue'] as TypeFunction1<int, dynamic>)(this_) + other);
}

int Addable_doubleValue(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['addValues'] as TypeFunction2<int, dynamic, int>)(this_, (this_.vptr['get_numericValue'] as TypeFunction1<int, dynamic>)(this_));
}


class AmountValue extends Amount_Object_AddableValue {
  late int numericValue;
  AmountValue() {
    vptr['get_numericValue'] = const _TearOff_Amount_get_numericValue();
    vptr['addValues'] = const _TearOff_Amount_addValues();
    vptr['doubleValue'] = const _TearOff_Amount_doubleValue();
    vptr['operatorPlus'] = const _TearOff_Amount_operatorPlus();
    vptr['operatorMinus'] = const _TearOff_Amount_operatorMinus();
    vptr['operatorLt'] = const _TearOff_Amount_operatorLt();
    vptr['operatorGt'] = const _TearOff_Amount_operatorGt();
    vptr['toString'] = const _TearOff_Amount_toString();
  }
}

AmountValue Amount_new(dynamic this__, int numericValue) {
  final this_ = this__ as AmountValue;
  this_.numericValue = numericValue;
  return this_;
}

AmountValue Amount_operatorPlus(dynamic this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return Amount_new(AmountValue(), (this_.numericValue + other.numericValue));
}

AmountValue Amount_operatorMinus(dynamic this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return Amount_new(AmountValue(), (this_.numericValue - other.numericValue));
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
  print('>> ${(this_.vptr['toPrettyString'] as TypeFunction1<String, dynamic>)(this_)}');
}


class VehicleValue extends VPtr {
  late String make;
  late int year;
  VehicleValue() {
    vptr['toString'] = const _TearOff_Vehicle_toString();
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
    vptr['toString'] = const _TearOff_Car_toString();
    vptr['toPrettyString'] = const _TearOff_Car_toPrettyString();
    vptr['prettyPrint'] = const _TearOff_Car_prettyPrint();
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
    vptr['toString'] = const _TearOff_ElectricCar_toString();
    vptr['toPrettyString'] = const _TearOff_ElectricCar_toPrettyString();
    vptr['prettyPrint'] = const _TearOff_ElectricCar_prettyPrint();
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
    vptr['measure'] = const _TearOff_Measurable_measure();
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
  return ((this_.vptr['measure'] as TypeFunction1<double, dynamic>)(this_) * factor);
}

String Scalable_measureInfo(dynamic this__) {
  final this_ = this__;
  return 'measure=${(this_.vptr['measure'] as TypeFunction1<double, dynamic>)(this_).toStringAsFixed(1)}';
}


class SegmentValue extends Segment_Measurable_ScalableValue {
  late double length;
  SegmentValue() {
    vptr['measure'] = const _TearOff_Segment_measure();
    vptr['scale'] = const _TearOff_Segment_scale();
    vptr['measureInfo'] = const _TearOff_Segment_measureInfo();
    vptr['toString'] = const _TearOff_Segment_toString();
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
  return 'Segment(${this_.length}, ${(this_.vptr['measureInfo'] as TypeFunction1<String, dynamic>)(this_)})';
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
    vptr['measure'] = const _TearOff_WeightedSegment_measure();
    vptr['scale'] = const _TearOff_WeightedSegment_scale();
    vptr['measureInfo'] = const _TearOff_WeightedSegment_measureInfo();
    vptr['toString'] = const _TearOff_WeightedSegment_toString();
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
  return 'WeightedSegment(len=${this_.length}, w=${this_.weight}, ${(this_.vptr['measureInfo'] as TypeFunction1<String, dynamic>)(this_)})';
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
  return 'Hello from ${(this_.vptr['get_label'] as TypeFunction1<String, dynamic>)(this_)}';
}


// mixin DescribedMixin → static functions for delegation
String DescribedMixin_get_label(dynamic this__) {
  final this_ = this__;
  return 'DescribedMixin';
}

String DescribedMixin_info(dynamic this__) {
  final this_ = this__;
  return 'Info: ${(this_.vptr['get_label'] as TypeFunction1<String, dynamic>)(this_)}';
}


class MultiMixinEntityValue extends MultiMixinEntity_Object_NamedMixin_DescribedMixinValue {
  MultiMixinEntityValue() {
    vptr['get_label'] = const _TearOff_MultiMixinEntity_get_label();
    vptr['greet'] = const _TearOff_MultiMixinEntity_greet();
    vptr['info'] = const _TearOff_MultiMixinEntity_info();
    vptr['fullInfo'] = const _TearOff_MultiMixinEntity_fullInfo();
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
  return '${(this_.vptr['greet'] as TypeFunction1<String, dynamic>)(this_)} | ${(this_.vptr['info'] as TypeFunction1<String, dynamic>)(this_)}';
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
    vptr['encode'] = const _TearOff_Encoder_encode();
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
    vptr['encode'] = const _TearOff_MultiEncoder_encode();
    vptr['encodeAll'] = const _TearOff_MultiEncoder_encodeAll();
  }
}

MultiEncoderValue MultiEncoder_new(dynamic this__) {
  final this_ = this__ as MultiEncoderValue;
  return this_;
}

String MultiEncoder_encodeAll(dynamic this__, String input) {
  final this_ = this__ as MultiEncoderValue;
  return (this_.vptr['encode'] as TypeFunction2<String, dynamic, String>)(this_, input);
}

String MultiEncoder_encode(dynamic this__, String input) {
  final this_ = this__ as MultiEncoderValue;
  return HexMixin_encode(this_, input);
}


class CustomEncoderValue extends MultiEncoderValue {
  CustomEncoderValue() {
    vptr['encode'] = const _TearOff_CustomEncoder_encode();
    vptr['encodeAll'] = const _TearOff_CustomEncoder_encodeAll();
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
    vptr['describe'] = _TearOff_Container_describe<T>();
    vptr['get_content'] = _TearOff_Container_get_content<T>();
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
    vptr['describe'] = _TearOff_LabeledContainer_describe<T>();
    vptr['get_content'] = _TearOff_LabeledContainer_get_content<T>();
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
    vptr['describe'] = _TearOff_PriorityContainer_describe<T>();
    vptr['get_content'] = _TearOff_PriorityContainer_get_content<T>();
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
  return '${(this_.vptr['step1'] as TypeFunction1<String, dynamic>)(this_)}->S2';
}

String ChainMixin_step3(dynamic this__) {
  final this_ = this__;
  return '${(this_.vptr['step2'] as TypeFunction1<String, dynamic>)(this_)}->S3';
}

String ChainMixin_fullChain(dynamic this__) {
  final this_ = this__;
  return '${(this_.vptr['step3'] as TypeFunction1<String, dynamic>)(this_)}->done';
}


class ChainClassValue extends ChainClass_Object_ChainMixinValue {
  ChainClassValue() {
    vptr['step1'] = const _TearOff_ChainClass_step1();
    vptr['step2'] = const _TearOff_ChainClass_step2();
    vptr['step3'] = const _TearOff_ChainClass_step3();
    vptr['fullChain'] = const _TearOff_ChainClass_fullChain();
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
    vptr['step1'] = const _TearOff_ChainSubClass_step1();
    vptr['step2'] = const _TearOff_ChainSubClass_step2();
    vptr['step3'] = const _TearOff_ChainSubClass_step3();
    vptr['fullChain'] = const _TearOff_ChainSubClass_fullChain();
  }
}

ChainSubClassValue ChainSubClass_new(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  ChainClass_new(this_);
  return this_;
}

String ChainSubClass_step2(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  return '${(this_.vptr['step1'] as TypeFunction1<String, dynamic>)(this_)}->Y2';
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
    vptr['evaluate'] = const _TearOff_Expression2_evaluate();
    vptr['display'] = const _TearOff_Expression2_display();
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
    vptr['evaluate'] = const _TearOff_NumberExpr_evaluate();
    vptr['display'] = const _TearOff_NumberExpr_display();
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
    vptr['evaluate'] = const _TearOff_BinaryExpr_evaluate();
    vptr['display'] = const _TearOff_BinaryExpr_display();
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
  return BinaryExpr_new(BinaryExprValue(), l, r, '+', ClosureEnv_anon_0());
}

BinaryExprValue BinaryExpr_new_mul(Expression2Value l, Expression2Value r) {
  return BinaryExpr_new(BinaryExprValue(), l, r, '*', ClosureEnv_anon_1());
}

double BinaryExpr_evaluate(dynamic this__) {
  final this_ = this__ as BinaryExprValue;
  return (() { final _let0 = (this_.left.vptr['evaluate'] as TypeFunction1<double, dynamic>)(this_.left); return (() { final _let1 = (this_.right.vptr['evaluate'] as TypeFunction1<double, dynamic>)(this_.right); return this_._compute(_let0, _let1); })(); })();
}

String BinaryExpr_display(dynamic this__) {
  final this_ = this__ as BinaryExprValue;
  return '(${(this_.left.vptr['display'] as TypeFunction1<String, dynamic>)(this_.left)} ${this_.op} ${(this_.right.vptr['display'] as TypeFunction1<String, dynamic>)(this_.right)})';
}


// mixin HealthMixin → static functions for delegation
int HealthMixin_get_maxHealth(dynamic this__) {
  final this_ = this__;
  return 100;
}

int HealthMixin_get_health(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['get_maxHealth'] as TypeFunction1<int, dynamic>)(this_);
}

String HealthMixin_healthBar(dynamic this__) {
  final this_ = this__;
  return 'HP:${(this_.vptr['get_health'] as TypeFunction1<int, dynamic>)(this_)}/${(this_.vptr['get_maxHealth'] as TypeFunction1<int, dynamic>)(this_)}';
}


// mixin ManaMixin → static functions for delegation
int ManaMixin_get_maxMana(dynamic this__) {
  final this_ = this__;
  return 50;
}

int ManaMixin_get_mana(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['get_maxMana'] as TypeFunction1<int, dynamic>)(this_);
}

String ManaMixin_manaBar(dynamic this__) {
  final this_ = this__;
  return 'MP:${(this_.vptr['get_mana'] as TypeFunction1<int, dynamic>)(this_)}/${(this_.vptr['get_maxMana'] as TypeFunction1<int, dynamic>)(this_)}';
}


// mixin StaminaMixin → static functions for delegation
int StaminaMixin_get_maxStamina(dynamic this__) {
  final this_ = this__;
  return 80;
}

int StaminaMixin_get_stamina(dynamic this__) {
  final this_ = this__;
  return (this_.vptr['get_maxStamina'] as TypeFunction1<int, dynamic>)(this_);
}

String StaminaMixin_staminaBar(dynamic this__) {
  final this_ = this__;
  return 'SP:${(this_.vptr['get_stamina'] as TypeFunction1<int, dynamic>)(this_)}/${(this_.vptr['get_maxStamina'] as TypeFunction1<int, dynamic>)(this_)}';
}


class GameCharacterValue extends GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue {
  late String name;
  GameCharacterValue() {
    vptr['get_maxHealth'] = const _TearOff_GameCharacter_get_maxHealth();
    vptr['get_health'] = const _TearOff_GameCharacter_get_health();
    vptr['healthBar'] = const _TearOff_GameCharacter_healthBar();
    vptr['get_maxMana'] = const _TearOff_GameCharacter_get_maxMana();
    vptr['get_mana'] = const _TearOff_GameCharacter_get_mana();
    vptr['manaBar'] = const _TearOff_GameCharacter_manaBar();
    vptr['get_maxStamina'] = const _TearOff_GameCharacter_get_maxStamina();
    vptr['get_stamina'] = const _TearOff_GameCharacter_get_stamina();
    vptr['staminaBar'] = const _TearOff_GameCharacter_staminaBar();
    vptr['statusBars'] = const _TearOff_GameCharacter_statusBars();
  }
}

GameCharacterValue GameCharacter_new(dynamic this__, String name) {
  final this_ = this__ as GameCharacterValue;
  this_.name = name;
  return this_;
}

String GameCharacter_statusBars(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return '${this_.name}: ${(this_.vptr['healthBar'] as TypeFunction1<String, dynamic>)(this_)} ${(this_.vptr['manaBar'] as TypeFunction1<String, dynamic>)(this_)} ${(this_.vptr['staminaBar'] as TypeFunction1<String, dynamic>)(this_)}';
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
    vptr['get_maxHealth'] = const _TearOff_Warrior_get_maxHealth();
    vptr['get_health'] = const _TearOff_Warrior_get_health();
    vptr['healthBar'] = const _TearOff_Warrior_healthBar();
    vptr['get_maxMana'] = const _TearOff_Warrior_get_maxMana();
    vptr['get_mana'] = const _TearOff_Warrior_get_mana();
    vptr['manaBar'] = const _TearOff_Warrior_manaBar();
    vptr['get_maxStamina'] = const _TearOff_Warrior_get_maxStamina();
    vptr['get_stamina'] = const _TearOff_Warrior_get_stamina();
    vptr['staminaBar'] = const _TearOff_Warrior_staminaBar();
    vptr['statusBars'] = const _TearOff_Warrior_statusBars();
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
    vptr['get_maxHealth'] = const _TearOff_Mage_get_maxHealth();
    vptr['get_health'] = const _TearOff_Mage_get_health();
    vptr['healthBar'] = const _TearOff_Mage_healthBar();
    vptr['get_maxMana'] = const _TearOff_Mage_get_maxMana();
    vptr['get_mana'] = const _TearOff_Mage_get_mana();
    vptr['manaBar'] = const _TearOff_Mage_manaBar();
    vptr['get_maxStamina'] = const _TearOff_Mage_get_maxStamina();
    vptr['get_stamina'] = const _TearOff_Mage_get_stamina();
    vptr['staminaBar'] = const _TearOff_Mage_staminaBar();
    vptr['statusBars'] = const _TearOff_Mage_statusBars();
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
    vptr['get_prefix'] = const _TearOff_Logger_get_prefix();
    vptr['format'] = const _TearOff_Logger_format();
  }
}


class DiamondClass_Object_Logger_FormatterValue extends DiamondClass_Object_LoggerValue {
  DiamondClass_Object_Logger_FormatterValue() {
    vptr['get_prefix'] = const _TearOff_Formatter_get_prefix();
    vptr['format'] = const _TearOff_Formatter_format();
  }
}


class StatefulWidget_Object_StatefulMixinValue extends VPtr {
  late int _counter;
  StatefulWidget_Object_StatefulMixinValue() {
    vptr['get_counter'] = const _TearOff_StatefulMixin_get_counter();
    vptr['set_counter'] = const _TearOff_StatefulMixin_set_counter();
    vptr['increment'] = const _TearOff_StatefulMixin_increment();
    vptr['decrement'] = const _TearOff_StatefulMixin_decrement();
    vptr['get_counterStatus'] = const _TearOff_StatefulMixin_get_counterStatus();
  }
}


class DeepMixinClass_Object_LayerAValue extends VPtr {
  DeepMixinClass_Object_LayerAValue() {
    vptr['layer'] = const _TearOff_LayerA_layer();
    vptr['onlyA'] = const _TearOff_LayerA_onlyA();
  }
}


class DeepMixinClass_Object_LayerA_LayerBValue extends DeepMixinClass_Object_LayerAValue {
  DeepMixinClass_Object_LayerA_LayerBValue() {
    vptr['layer'] = const _TearOff_LayerB_layer();
    vptr['onlyB'] = const _TearOff_LayerB_onlyB();
  }
}


class DeepMixinClass_Object_LayerA_LayerB_LayerCValue extends DeepMixinClass_Object_LayerA_LayerBValue {
  DeepMixinClass_Object_LayerA_LayerB_LayerCValue() {
    vptr['layer'] = const _TearOff_LayerC_layer();
    vptr['onlyC'] = const _TearOff_LayerC_onlyC();
  }
}


class Box_Object_MappableValue<T> extends VPtr {
  Box_Object_MappableValue() {
    vptr['mapValue'] = _TearOff_Mappable_mapValue<T>();
    vptr['describe'] = _TearOff_Mappable_describe<T>();
  }
}


class Box_Object_Mappable_FilterableValue<T> extends Box_Object_MappableValue<T> {
  Box_Object_Mappable_FilterableValue() {
    vptr['test'] = _TearOff_Filterable_test<T>();
  }
}


class TaggedResource_Resource_TaggableValue extends ResourceValue {
  late StaticList<String> _tags;
  TaggedResource_Resource_TaggableValue() {
    vptr['tag'] = const _TearOff_Taggable_tag();
    vptr['get_allTags'] = const _TearOff_Taggable_get_allTags();
    vptr['hasTag'] = const _TearOff_Taggable_hasTag();
  }
}


class Amount_Object_AddableValue extends VPtr {
  Amount_Object_AddableValue() {
    vptr['addValues'] = const _TearOff_Addable_addValues();
    vptr['doubleValue'] = const _TearOff_Addable_doubleValue();
  }
}


class Car_Vehicle_Printable2Value extends VehicleValue {
  Car_Vehicle_Printable2Value() {
    vptr['prettyPrint'] = const _TearOff_Printable2_prettyPrint();
  }
}


class Segment_Measurable_ScalableValue extends MeasurableValue {
  Segment_Measurable_ScalableValue() {
    vptr['scale'] = const _TearOff_Scalable_scale();
    vptr['measureInfo'] = const _TearOff_Scalable_measureInfo();
  }
}


class MultiMixinEntity_Object_NamedMixinValue extends VPtr {
  MultiMixinEntity_Object_NamedMixinValue() {
    vptr['get_label'] = const _TearOff_NamedMixin_get_label();
    vptr['greet'] = const _TearOff_NamedMixin_greet();
  }
}


class MultiMixinEntity_Object_NamedMixin_DescribedMixinValue extends MultiMixinEntity_Object_NamedMixinValue {
  MultiMixinEntity_Object_NamedMixin_DescribedMixinValue() {
    vptr['get_label'] = const _TearOff_DescribedMixin_get_label();
    vptr['info'] = const _TearOff_DescribedMixin_info();
  }
}


class MultiEncoder_Object_Base64MixinValue extends VPtr {
  MultiEncoder_Object_Base64MixinValue() {
    vptr['encode'] = const _TearOff_Base64Mixin_encode();
  }
}


class MultiEncoder_Object_Base64Mixin_HexMixinValue extends MultiEncoder_Object_Base64MixinValue {
  MultiEncoder_Object_Base64Mixin_HexMixinValue() {
    vptr['encode'] = const _TearOff_HexMixin_encode();
  }
}


class ChainClass_Object_ChainMixinValue extends VPtr {
  ChainClass_Object_ChainMixinValue() {
    vptr['step1'] = const _TearOff_ChainMixin_step1();
    vptr['step2'] = const _TearOff_ChainMixin_step2();
    vptr['step3'] = const _TearOff_ChainMixin_step3();
    vptr['fullChain'] = const _TearOff_ChainMixin_fullChain();
  }
}


class GameCharacter_Object_HealthMixinValue extends VPtr {
  GameCharacter_Object_HealthMixinValue() {
    vptr['get_maxHealth'] = const _TearOff_HealthMixin_get_maxHealth();
    vptr['get_health'] = const _TearOff_HealthMixin_get_health();
    vptr['healthBar'] = const _TearOff_HealthMixin_healthBar();
  }
}


class GameCharacter_Object_HealthMixin_ManaMixinValue extends GameCharacter_Object_HealthMixinValue {
  GameCharacter_Object_HealthMixin_ManaMixinValue() {
    vptr['get_maxMana'] = const _TearOff_ManaMixin_get_maxMana();
    vptr['get_mana'] = const _TearOff_ManaMixin_get_mana();
    vptr['manaBar'] = const _TearOff_ManaMixin_manaBar();
  }
}


class GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue extends GameCharacter_Object_HealthMixin_ManaMixinValue {
  GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue() {
    vptr['get_maxStamina'] = const _TearOff_StaminaMixin_get_maxStamina();
    vptr['get_stamina'] = const _TearOff_StaminaMixin_get_stamina();
    vptr['staminaBar'] = const _TearOff_StaminaMixin_staminaBar();
  }
}


void main() {
  print('=== 复杂 OOP 边界测试 ===\n');
  print('--- 1. 菱形继承 ---');
  final DiamondClassValue diamond = DiamondClass_new(DiamondClassValue(), 'DC');
  print('prefix: ${(diamond.vptr['get_prefix'] as TypeFunction1<String, dynamic>)(diamond)}');
  print('format: ${(diamond.vptr['format'] as TypeFunction2<String, dynamic, String>)(diamond, 'hello')}');
  print('display: ${(diamond.vptr['display'] as TypeFunction2<String, dynamic, String>)(diamond, 'world')}');
  print('\n--- 2. StatefulMixin ---');
  final StatefulWidgetValue widget = StatefulWidget_new(StatefulWidgetValue(), 'btn1');
  print('initial: ${widget}');
  (widget.vptr['increment'] as TypeFunction1<void, dynamic>)(widget);
  (widget.vptr['increment'] as TypeFunction1<void, dynamic>)(widget);
  (widget.vptr['increment'] as TypeFunction1<void, dynamic>)(widget);
  print('after 3 inc: ${widget}');
  (widget.vptr['decrement'] as TypeFunction1<void, dynamic>)(widget);
  print('after 1 dec: ${widget}');
  (widget.vptr['set_counter'] as TypeFunction2<void, dynamic, int>)(widget, 10);
  print('after set 10: ${widget}');
  print('\n--- 3. 深层 mixin 链 ---');
  final DeepMixinClassValue deep = DeepMixinClass_new(DeepMixinClassValue());
  print('layer: ${(deep.vptr['layer'] as TypeFunction1<String, dynamic>)(deep)}');
  print('allLayers: ${(deep.vptr['allLayers'] as TypeFunction1<String, dynamic>)(deep)}');
  print('\n--- 4. 泛型 mixin ---');
  final BoxValue<int> intBox = Box_new<int>(BoxValue<int>(), 42);
  print('intBox: ${intBox}');
  print('describe: ${(intBox.vptr['describe'] as TypeFunction1<String, dynamic>)(intBox)}');
  print('mapValue: ${(intBox.vptr['mapValue_int'] as TypeFunction2<int, dynamic, TypeFunction1<int, int>>)(intBox, ClosureEnv_main_3())}');
  print('test >10: ${(intBox.vptr['test'] as TypeFunction2<bool, dynamic, TypeFunction1<bool, int>>)(intBox, ClosureEnv_main_5())}');
  print('test >100: ${(intBox.vptr['test'] as TypeFunction2<bool, dynamic, TypeFunction1<bool, int>>)(intBox, ClosureEnv_main_7())}');
  final BoxValue<String> strBox = Box_new<String>(BoxValue<String>(), 'dart');
  print('strBox mapValue: ${(strBox.vptr['mapValue_String'] as TypeFunction2<String, dynamic, TypeFunction1<String, String>>)(strBox, ClosureEnv_main_9())}');
  print('\n--- 5. 抽象+mixin+implements ---');
  final TaggedResourceValue res = TaggedResource_new(TaggedResourceValue(), 'r1', 'file');
  (res.vptr['tag'] as TypeFunction2<void, dynamic, String>)(res, 'important');
  (res.vptr['tag'] as TypeFunction2<void, dynamic, String>)(res, 'v2');
  print('describe: ${(res.vptr['describe'] as TypeFunction1<String, dynamic>)(res)}');
  print('id: ${res.id}');
  print('hasTag important: ${(res.vptr['hasTag'] as TypeFunction2<bool, dynamic, String>)(res, 'important')}');
  print('hasTag draft: ${(res.vptr['hasTag'] as TypeFunction2<bool, dynamic, String>)(res, 'draft')}');
  print('\n--- 6. super 调用链 ---');
  final BaseProcessorValue base = BaseProcessor_new(BaseProcessorValue());
  print('base: ${(base.vptr['process'] as TypeFunction2<String, dynamic, String>)(base, '  hello  ')} (${(base.vptr['get_processorName'] as TypeFunction1<String, dynamic>)(base)})');
  final UpperProcessorValue upper = UpperProcessor_new(UpperProcessorValue());
  print('upper: ${(upper.vptr['process'] as TypeFunction2<String, dynamic, String>)(upper, '  hello  ')} (${(upper.vptr['get_processorName'] as TypeFunction1<String, dynamic>)(upper)})');
  final PrefixProcessorValue prefix = PrefixProcessor_new(PrefixProcessorValue(), 'PRE');
  print('prefix: ${(prefix.vptr['process'] as TypeFunction2<String, dynamic, String>)(prefix, '  hello  ')} (${(prefix.vptr['get_processorName'] as TypeFunction1<String, dynamic>)(prefix)})');
  print('\n--- 7. mixin + operator ---');
  final AmountValue a1 = Amount_new(AmountValue(), 10);
  final AmountValue a2 = Amount_new(AmountValue(), 5);
  print('a1 + a2: ${(a1.vptr['operatorPlus'] as TypeFunction2<AmountValue, dynamic, AmountValue>)(a1, a2)}');
  print('a1 - a2: ${(a1.vptr['operatorMinus'] as TypeFunction2<AmountValue, dynamic, AmountValue>)(a1, a2)}');
  print('a1 < a2: ${(a1.vptr['operatorLt'] as TypeFunction2<bool, dynamic, AmountValue>)(a1, a2)}');
  print('a1 > a2: ${(a1.vptr['operatorGt'] as TypeFunction2<bool, dynamic, AmountValue>)(a1, a2)}');
  print('doubleValue: ${(a1.vptr['doubleValue'] as TypeFunction1<int, dynamic>)(a1)}');
  print('addValues: ${(a1.vptr['addValues'] as TypeFunction2<int, dynamic, int>)(a1, 3)}');
  print('\n--- 8. 多层继承+mixin ---');
  final CarValue car = Car_new(CarValue(), 'Toyota', 2024, 4);
  print('car: ${car}');
  (car.vptr['prettyPrint'] as TypeFunction1<void, dynamic>)(car);
  final ElectricCarValue ev = ElectricCar_new(ElectricCarValue(), 'Tesla', 2025, 4, 500);
  print('ev: ${ev}');
  (ev.vptr['prettyPrint'] as TypeFunction1<void, dynamic>)(ev);
  print('\n--- 9. mixin on 约束 ---');
  final SegmentValue seg = Segment_new(SegmentValue(), 10.0);
  print('seg: ${seg}');
  print('scale(2): ${(seg.vptr['scale'] as TypeFunction2<double, dynamic, double>)(seg, 2.0)}');
  final WeightedSegmentValue wseg = WeightedSegment_new(WeightedSegmentValue(), 10.0, 0.5);
  print('wseg: ${wseg}');
  print('wseg.scale(3): ${(wseg.vptr['scale'] as TypeFunction2<double, dynamic, double>)(wseg, 3.0)}');
  print('\n--- 10. 多 mixin 同名 getter ---');
  final MultiMixinEntityValue entity = MultiMixinEntity_new(MultiMixinEntityValue());
  print('label: ${(entity.vptr['get_label'] as TypeFunction1<String, dynamic>)(entity)}');
  print('greet: ${(entity.vptr['greet'] as TypeFunction1<String, dynamic>)(entity)}');
  print('info: ${(entity.vptr['info'] as TypeFunction1<String, dynamic>)(entity)}');
  print('fullInfo: ${(entity.vptr['fullInfo'] as TypeFunction1<String, dynamic>)(entity)}');
  print('\n--- 11. 接口+mixin 覆盖 ---');
  final MultiEncoderValue multi = MultiEncoder_new(MultiEncoderValue());
  print('multi.encode: ${(multi.vptr['encode'] as TypeFunction2<String, dynamic, String>)(multi, 'abc')}');
  print('multi.encodeAll: ${(multi.vptr['encodeAll'] as TypeFunction2<String, dynamic, String>)(multi, 'xyz')}');
  final CustomEncoderValue custom = CustomEncoder_new(CustomEncoderValue());
  print('custom.encode: ${(custom.vptr['encode'] as TypeFunction2<String, dynamic, String>)(custom, 'abc')}');
  print('custom.encodeAll: ${(custom.vptr['encodeAll'] as TypeFunction2<String, dynamic, String>)(custom, 'xyz')}');
  print('\n--- 12. 泛型继承链 ---');
  final ContainerValue<int> c1 = Container_new<int>(ContainerValue<int>(), 42);
  print('c1: ${(c1.vptr['describe'] as TypeFunction1<String, dynamic>)(c1)}');
  final LabeledContainerValue<String> c2 = LabeledContainer_new<String>(LabeledContainerValue<String>(), 'hello', 'greeting');
  print('c2: ${(c2.vptr['describe'] as TypeFunction1<String, dynamic>)(c2)}');
  final PriorityContainerValue<double> c3 = PriorityContainer_new<double>(PriorityContainerValue<double>(), 3.14, 'pi', 1);
  print('c3: ${(c3.vptr['describe'] as TypeFunction1<String, dynamic>)(c3)}');
  print('c3.content: ${(c3.vptr['get_content'] as TypeFunction1<double, dynamic>)(c3)}');
  print('\n--- 13. mixin 调用链 ---');
  final ChainClassValue chain1 = ChainClass_new(ChainClassValue());
  print('chain1.fullChain: ${(chain1.vptr['fullChain'] as TypeFunction1<String, dynamic>)(chain1)}');
  print('chain1.step3: ${(chain1.vptr['step3'] as TypeFunction1<String, dynamic>)(chain1)}');
  final ChainSubClassValue chain2 = ChainSubClass_new(ChainSubClassValue());
  print('chain2.fullChain: ${(chain2.vptr['fullChain'] as TypeFunction1<String, dynamic>)(chain2)}');
  print('chain2.step3: ${(chain2.vptr['step3'] as TypeFunction1<String, dynamic>)(chain2)}');
  print('\n--- 14. 表达式树 ---');
  final BinaryExprValue expr = BinaryExpr_new_add(NumberExpr_new(NumberExprValue(), 3.0), BinaryExpr_new_mul(NumberExpr_new(NumberExprValue(), 4.0), NumberExpr_new(NumberExprValue(), 5.0)));
  print('expr: ${(expr.vptr['display'] as TypeFunction1<String, dynamic>)(expr)}');
  print('result: ${(expr.vptr['evaluate'] as TypeFunction1<double, dynamic>)(expr)}');
  print('\n--- 15. 游戏角色 ---');
  final GameCharacterValue hero = GameCharacter_new(GameCharacterValue(), 'Hero');
  print((hero.vptr['statusBars'] as TypeFunction1<String, dynamic>)(hero));
  final WarriorValue warrior = Warrior_new(WarriorValue(), 'Conan');
  print((warrior.vptr['statusBars'] as TypeFunction1<String, dynamic>)(warrior));
  final MageValue mage = Mage_new(MageValue(), 'Gandalf');
  print((mage.vptr['statusBars'] as TypeFunction1<String, dynamic>)(mage));
  print('\n=== 所有复杂 OOP 测试通过 ✅ ===');
}

class _TearOff_DiamondClass_get_prefix extends TypeFunction1<String, dynamic> {
  const _TearOff_DiamondClass_get_prefix();
  @override
  String call(dynamic this_) => DiamondClass_get_prefix(this_);
}
class _TearOff_DiamondClass_format extends TypeFunction2<String, dynamic, String> {
  const _TearOff_DiamondClass_format();
  @override
  String call(dynamic this_, String msg) => DiamondClass_format(this_, msg);
}
class _TearOff_DiamondClass_display extends TypeFunction2<String, dynamic, String> {
  const _TearOff_DiamondClass_display();
  @override
  String call(dynamic this_, String msg) => DiamondClass_display(this_, msg);
}
class _TearOff_StatefulWidget_get_counter extends TypeFunction1<int, dynamic> {
  const _TearOff_StatefulWidget_get_counter();
  @override
  int call(dynamic this_) => StatefulWidget_get_counter(this_);
}
class _TearOff_StatefulWidget_set_counter extends TypeFunction2<void, dynamic, int> {
  const _TearOff_StatefulWidget_set_counter();
  @override
  void call(dynamic this_, int value) => StatefulWidget_set_counter(this_, value);
}
class _TearOff_StatefulWidget_increment extends TypeFunction1<void, dynamic> {
  const _TearOff_StatefulWidget_increment();
  @override
  void call(dynamic this_) => StatefulWidget_increment(this_);
}
class _TearOff_StatefulWidget_decrement extends TypeFunction1<void, dynamic> {
  const _TearOff_StatefulWidget_decrement();
  @override
  void call(dynamic this_) => StatefulWidget_decrement(this_);
}
class _TearOff_StatefulWidget_get_counterStatus extends TypeFunction1<String, dynamic> {
  const _TearOff_StatefulWidget_get_counterStatus();
  @override
  String call(dynamic this_) => StatefulWidget_get_counterStatus(this_);
}
class _TearOff_StatefulWidget_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_StatefulWidget_toString();
  @override
  String call(dynamic this_) => StatefulWidget_toString(this_);
}
class _TearOff_DeepMixinClass_layer extends TypeFunction1<String, dynamic> {
  const _TearOff_DeepMixinClass_layer();
  @override
  String call(dynamic this_) => DeepMixinClass_layer(this_);
}
class _TearOff_DeepMixinClass_onlyA extends TypeFunction1<String, dynamic> {
  const _TearOff_DeepMixinClass_onlyA();
  @override
  String call(dynamic this_) => DeepMixinClass_onlyA(this_);
}
class _TearOff_DeepMixinClass_onlyB extends TypeFunction1<String, dynamic> {
  const _TearOff_DeepMixinClass_onlyB();
  @override
  String call(dynamic this_) => DeepMixinClass_onlyB(this_);
}
class _TearOff_DeepMixinClass_onlyC extends TypeFunction1<String, dynamic> {
  const _TearOff_DeepMixinClass_onlyC();
  @override
  String call(dynamic this_) => DeepMixinClass_onlyC(this_);
}
class _TearOff_DeepMixinClass_allLayers extends TypeFunction1<String, dynamic> {
  const _TearOff_DeepMixinClass_allLayers();
  @override
  String call(dynamic this_) => DeepMixinClass_allLayers(this_);
}
class _TearOff_Box_get_value<T> extends TypeFunction1<T, dynamic> {
  _TearOff_Box_get_value();
  @override
  T call(dynamic this_) => Box_get_value<T>(this_);
}
class _TearOff_Box_describe<T> extends TypeFunction1<String, dynamic> {
  _TearOff_Box_describe();
  @override
  String call(dynamic this_) => Box_describe<T>(this_);
}
class _TearOff_Box_test<T> extends TypeFunction2<bool, dynamic, TypeFunction1<bool, T>> {
  _TearOff_Box_test();
  @override
  bool call(dynamic this_, TypeFunction1<bool, T> predicate) => Box_test<T>(this_, predicate);
}
class _TearOff_Box_toString<T> extends TypeFunction1<String, dynamic> {
  _TearOff_Box_toString();
  @override
  String call(dynamic this_) => Box_toString<T>(this_);
}
class _TearOff_Box_mapValue_int<T> extends TypeFunction2<int, dynamic, TypeFunction1<int, T>> {
  _TearOff_Box_mapValue_int();
  @override
  int call(dynamic this_, TypeFunction1<int, T> transform) => Box_mapValue<T, int>(this_, transform);
}
class _TearOff_Box_mapValue_String<T> extends TypeFunction2<String, dynamic, TypeFunction1<String, T>> {
  _TearOff_Box_mapValue_String();
  @override
  String call(dynamic this_, TypeFunction1<String, T> transform) => Box_mapValue<T, String>(this_, transform);
}
class _TearOff_Identifiable_get_id extends TypeFunction1<String, dynamic> {
  const _TearOff_Identifiable_get_id();
  @override
  String call(dynamic this_) => Identifiable_get_id(this_);
}
class _TearOff_Describable_describe extends TypeFunction1<String, dynamic> {
  const _TearOff_Describable_describe();
  @override
  String call(dynamic this_) => Describable_describe(this_);
}
class _TearOff_Resource_describe extends TypeFunction1<String, dynamic> {
  const _TearOff_Resource_describe();
  @override
  String call(dynamic this_) => Resource_describe(this_);
}
class _TearOff_TaggedResource_describe extends TypeFunction1<String, dynamic> {
  const _TearOff_TaggedResource_describe();
  @override
  String call(dynamic this_) => TaggedResource_describe(this_);
}
class _TearOff_TaggedResource_tag extends TypeFunction2<void, dynamic, String> {
  const _TearOff_TaggedResource_tag();
  @override
  void call(dynamic this_, String t) => TaggedResource_tag(this_, t);
}
class _TearOff_TaggedResource_get_allTags extends TypeFunction1<StaticList<String>, dynamic> {
  const _TearOff_TaggedResource_get_allTags();
  @override
  StaticList<String> call(dynamic this_) => TaggedResource_get_allTags(this_);
}
class _TearOff_TaggedResource_hasTag extends TypeFunction2<bool, dynamic, String> {
  const _TearOff_TaggedResource_hasTag();
  @override
  bool call(dynamic this_, String t) => TaggedResource_hasTag(this_, t);
}
class _TearOff_BaseProcessor_process extends TypeFunction2<String, dynamic, String> {
  const _TearOff_BaseProcessor_process();
  @override
  String call(dynamic this_, String input) => BaseProcessor_process(this_, input);
}
class _TearOff_BaseProcessor_get_processorName extends TypeFunction1<String, dynamic> {
  const _TearOff_BaseProcessor_get_processorName();
  @override
  String call(dynamic this_) => BaseProcessor_get_processorName(this_);
}
class _TearOff_UpperProcessor_process extends TypeFunction2<String, dynamic, String> {
  const _TearOff_UpperProcessor_process();
  @override
  String call(dynamic this_, String input) => UpperProcessor_process(this_, input);
}
class _TearOff_UpperProcessor_get_processorName extends TypeFunction1<String, dynamic> {
  const _TearOff_UpperProcessor_get_processorName();
  @override
  String call(dynamic this_) => UpperProcessor_get_processorName(this_);
}
class _TearOff_PrefixProcessor_process extends TypeFunction2<String, dynamic, String> {
  const _TearOff_PrefixProcessor_process();
  @override
  String call(dynamic this_, String input) => PrefixProcessor_process(this_, input);
}
class _TearOff_PrefixProcessor_get_processorName extends TypeFunction1<String, dynamic> {
  const _TearOff_PrefixProcessor_get_processorName();
  @override
  String call(dynamic this_) => PrefixProcessor_get_processorName(this_);
}
class _TearOff_Amount_get_numericValue extends TypeFunction1<int, dynamic> {
  const _TearOff_Amount_get_numericValue();
  @override
  int call(dynamic this_) => Amount_get_numericValue(this_);
}
class _TearOff_Amount_addValues extends TypeFunction2<int, dynamic, int> {
  const _TearOff_Amount_addValues();
  @override
  int call(dynamic this_, int other) => Amount_addValues(this_, other);
}
class _TearOff_Amount_doubleValue extends TypeFunction1<int, dynamic> {
  const _TearOff_Amount_doubleValue();
  @override
  int call(dynamic this_) => Amount_doubleValue(this_);
}
class _TearOff_Amount_operatorPlus extends TypeFunction2<AmountValue, dynamic, AmountValue> {
  const _TearOff_Amount_operatorPlus();
  @override
  AmountValue call(dynamic this_, AmountValue other) => Amount_operatorPlus(this_, other);
}
class _TearOff_Amount_operatorMinus extends TypeFunction2<AmountValue, dynamic, AmountValue> {
  const _TearOff_Amount_operatorMinus();
  @override
  AmountValue call(dynamic this_, AmountValue other) => Amount_operatorMinus(this_, other);
}
class _TearOff_Amount_operatorLt extends TypeFunction2<bool, dynamic, AmountValue> {
  const _TearOff_Amount_operatorLt();
  @override
  bool call(dynamic this_, AmountValue other) => Amount_operatorLt(this_, other);
}
class _TearOff_Amount_operatorGt extends TypeFunction2<bool, dynamic, AmountValue> {
  const _TearOff_Amount_operatorGt();
  @override
  bool call(dynamic this_, AmountValue other) => Amount_operatorGt(this_, other);
}
class _TearOff_Amount_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Amount_toString();
  @override
  String call(dynamic this_) => Amount_toString(this_);
}
class _TearOff_Vehicle_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Vehicle_toString();
  @override
  String call(dynamic this_) => Vehicle_toString(this_);
}
class _TearOff_Car_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Car_toString();
  @override
  String call(dynamic this_) => Car_toString(this_);
}
class _TearOff_Car_toPrettyString extends TypeFunction1<String, dynamic> {
  const _TearOff_Car_toPrettyString();
  @override
  String call(dynamic this_) => Car_toPrettyString(this_);
}
class _TearOff_Car_prettyPrint extends TypeFunction1<void, dynamic> {
  const _TearOff_Car_prettyPrint();
  @override
  void call(dynamic this_) => Car_prettyPrint(this_);
}
class _TearOff_ElectricCar_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_ElectricCar_toString();
  @override
  String call(dynamic this_) => ElectricCar_toString(this_);
}
class _TearOff_ElectricCar_toPrettyString extends TypeFunction1<String, dynamic> {
  const _TearOff_ElectricCar_toPrettyString();
  @override
  String call(dynamic this_) => ElectricCar_toPrettyString(this_);
}
class _TearOff_ElectricCar_prettyPrint extends TypeFunction1<void, dynamic> {
  const _TearOff_ElectricCar_prettyPrint();
  @override
  void call(dynamic this_) => ElectricCar_prettyPrint(this_);
}
class _TearOff_Measurable_measure extends TypeFunction1<double, dynamic> {
  const _TearOff_Measurable_measure();
  @override
  double call(dynamic this_) => Measurable_measure(this_);
}
class _TearOff_Segment_measure extends TypeFunction1<double, dynamic> {
  const _TearOff_Segment_measure();
  @override
  double call(dynamic this_) => Segment_measure(this_);
}
class _TearOff_Segment_scale extends TypeFunction2<double, dynamic, double> {
  const _TearOff_Segment_scale();
  @override
  double call(dynamic this_, double factor) => Segment_scale(this_, factor);
}
class _TearOff_Segment_measureInfo extends TypeFunction1<String, dynamic> {
  const _TearOff_Segment_measureInfo();
  @override
  String call(dynamic this_) => Segment_measureInfo(this_);
}
class _TearOff_Segment_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Segment_toString();
  @override
  String call(dynamic this_) => Segment_toString(this_);
}
class _TearOff_WeightedSegment_measure extends TypeFunction1<double, dynamic> {
  const _TearOff_WeightedSegment_measure();
  @override
  double call(dynamic this_) => WeightedSegment_measure(this_);
}
class _TearOff_WeightedSegment_scale extends TypeFunction2<double, dynamic, double> {
  const _TearOff_WeightedSegment_scale();
  @override
  double call(dynamic this_, double factor) => WeightedSegment_scale(this_, factor);
}
class _TearOff_WeightedSegment_measureInfo extends TypeFunction1<String, dynamic> {
  const _TearOff_WeightedSegment_measureInfo();
  @override
  String call(dynamic this_) => WeightedSegment_measureInfo(this_);
}
class _TearOff_WeightedSegment_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_WeightedSegment_toString();
  @override
  String call(dynamic this_) => WeightedSegment_toString(this_);
}
class _TearOff_MultiMixinEntity_get_label extends TypeFunction1<String, dynamic> {
  const _TearOff_MultiMixinEntity_get_label();
  @override
  String call(dynamic this_) => MultiMixinEntity_get_label(this_);
}
class _TearOff_MultiMixinEntity_greet extends TypeFunction1<String, dynamic> {
  const _TearOff_MultiMixinEntity_greet();
  @override
  String call(dynamic this_) => MultiMixinEntity_greet(this_);
}
class _TearOff_MultiMixinEntity_info extends TypeFunction1<String, dynamic> {
  const _TearOff_MultiMixinEntity_info();
  @override
  String call(dynamic this_) => MultiMixinEntity_info(this_);
}
class _TearOff_MultiMixinEntity_fullInfo extends TypeFunction1<String, dynamic> {
  const _TearOff_MultiMixinEntity_fullInfo();
  @override
  String call(dynamic this_) => MultiMixinEntity_fullInfo(this_);
}
class _TearOff_Encoder_encode extends TypeFunction2<String, dynamic, String> {
  const _TearOff_Encoder_encode();
  @override
  String call(dynamic this_, String input) => Encoder_encode(this_, input);
}
class _TearOff_MultiEncoder_encode extends TypeFunction2<String, dynamic, String> {
  const _TearOff_MultiEncoder_encode();
  @override
  String call(dynamic this_, String input) => MultiEncoder_encode(this_, input);
}
class _TearOff_MultiEncoder_encodeAll extends TypeFunction2<String, dynamic, String> {
  const _TearOff_MultiEncoder_encodeAll();
  @override
  String call(dynamic this_, String input) => MultiEncoder_encodeAll(this_, input);
}
class _TearOff_CustomEncoder_encode extends TypeFunction2<String, dynamic, String> {
  const _TearOff_CustomEncoder_encode();
  @override
  String call(dynamic this_, String input) => CustomEncoder_encode(this_, input);
}
class _TearOff_CustomEncoder_encodeAll extends TypeFunction2<String, dynamic, String> {
  const _TearOff_CustomEncoder_encodeAll();
  @override
  String call(dynamic this_, String input) => CustomEncoder_encodeAll(this_, input);
}
class _TearOff_Container_describe<T> extends TypeFunction1<String, dynamic> {
  _TearOff_Container_describe();
  @override
  String call(dynamic this_) => Container_describe<T>(this_);
}
class _TearOff_Container_get_content<T> extends TypeFunction1<T, dynamic> {
  _TearOff_Container_get_content();
  @override
  T call(dynamic this_) => Container_get_content<T>(this_);
}
class _TearOff_LabeledContainer_describe<T> extends TypeFunction1<String, dynamic> {
  _TearOff_LabeledContainer_describe();
  @override
  String call(dynamic this_) => LabeledContainer_describe<T>(this_);
}
class _TearOff_LabeledContainer_get_content<T> extends TypeFunction1<T, dynamic> {
  _TearOff_LabeledContainer_get_content();
  @override
  T call(dynamic this_) => LabeledContainer_get_content<T>(this_);
}
class _TearOff_PriorityContainer_describe<T> extends TypeFunction1<String, dynamic> {
  _TearOff_PriorityContainer_describe();
  @override
  String call(dynamic this_) => PriorityContainer_describe<T>(this_);
}
class _TearOff_PriorityContainer_get_content<T> extends TypeFunction1<T, dynamic> {
  _TearOff_PriorityContainer_get_content();
  @override
  T call(dynamic this_) => PriorityContainer_get_content<T>(this_);
}
class _TearOff_ChainClass_step1 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainClass_step1();
  @override
  String call(dynamic this_) => ChainClass_step1(this_);
}
class _TearOff_ChainClass_step2 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainClass_step2();
  @override
  String call(dynamic this_) => ChainClass_step2(this_);
}
class _TearOff_ChainClass_step3 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainClass_step3();
  @override
  String call(dynamic this_) => ChainClass_step3(this_);
}
class _TearOff_ChainClass_fullChain extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainClass_fullChain();
  @override
  String call(dynamic this_) => ChainClass_fullChain(this_);
}
class _TearOff_ChainSubClass_step1 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainSubClass_step1();
  @override
  String call(dynamic this_) => ChainSubClass_step1(this_);
}
class _TearOff_ChainSubClass_step2 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainSubClass_step2();
  @override
  String call(dynamic this_) => ChainSubClass_step2(this_);
}
class _TearOff_ChainSubClass_step3 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainSubClass_step3();
  @override
  String call(dynamic this_) => ChainSubClass_step3(this_);
}
class _TearOff_ChainSubClass_fullChain extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainSubClass_fullChain();
  @override
  String call(dynamic this_) => ChainSubClass_fullChain(this_);
}
class _TearOff_Expression2_evaluate extends TypeFunction1<double, dynamic> {
  const _TearOff_Expression2_evaluate();
  @override
  double call(dynamic this_) => Expression2_evaluate(this_);
}
class _TearOff_Expression2_display extends TypeFunction1<String, dynamic> {
  const _TearOff_Expression2_display();
  @override
  String call(dynamic this_) => Expression2_display(this_);
}
class _TearOff_NumberExpr_evaluate extends TypeFunction1<double, dynamic> {
  const _TearOff_NumberExpr_evaluate();
  @override
  double call(dynamic this_) => NumberExpr_evaluate(this_);
}
class _TearOff_NumberExpr_display extends TypeFunction1<String, dynamic> {
  const _TearOff_NumberExpr_display();
  @override
  String call(dynamic this_) => NumberExpr_display(this_);
}
class _TearOff_BinaryExpr_evaluate extends TypeFunction1<double, dynamic> {
  const _TearOff_BinaryExpr_evaluate();
  @override
  double call(dynamic this_) => BinaryExpr_evaluate(this_);
}
class _TearOff_BinaryExpr_display extends TypeFunction1<String, dynamic> {
  const _TearOff_BinaryExpr_display();
  @override
  String call(dynamic this_) => BinaryExpr_display(this_);
}
class ClosureEnv_anon_0 extends TypeFunction2<double, double, double> {
  ClosureEnv_anon_0();
  @override
  double call(double a, double b) => ClosureEnv_anon_0_call(this, a, b);
}
double ClosureEnv_anon_0_call(ClosureEnv_anon_0 env, double a, double b) {
  return (a + b);
}

class ClosureEnv_anon_1 extends TypeFunction2<double, double, double> {
  ClosureEnv_anon_1();
  @override
  double call(double a, double b) => ClosureEnv_anon_1_call(this, a, b);
}
double ClosureEnv_anon_1_call(ClosureEnv_anon_1 env, double a, double b) {
  return (a * b);
}

class _TearOff_GameCharacter_get_maxHealth extends TypeFunction1<int, dynamic> {
  const _TearOff_GameCharacter_get_maxHealth();
  @override
  int call(dynamic this_) => GameCharacter_get_maxHealth(this_);
}
class _TearOff_GameCharacter_get_health extends TypeFunction1<int, dynamic> {
  const _TearOff_GameCharacter_get_health();
  @override
  int call(dynamic this_) => GameCharacter_get_health(this_);
}
class _TearOff_GameCharacter_healthBar extends TypeFunction1<String, dynamic> {
  const _TearOff_GameCharacter_healthBar();
  @override
  String call(dynamic this_) => GameCharacter_healthBar(this_);
}
class _TearOff_GameCharacter_get_maxMana extends TypeFunction1<int, dynamic> {
  const _TearOff_GameCharacter_get_maxMana();
  @override
  int call(dynamic this_) => GameCharacter_get_maxMana(this_);
}
class _TearOff_GameCharacter_get_mana extends TypeFunction1<int, dynamic> {
  const _TearOff_GameCharacter_get_mana();
  @override
  int call(dynamic this_) => GameCharacter_get_mana(this_);
}
class _TearOff_GameCharacter_manaBar extends TypeFunction1<String, dynamic> {
  const _TearOff_GameCharacter_manaBar();
  @override
  String call(dynamic this_) => GameCharacter_manaBar(this_);
}
class _TearOff_GameCharacter_get_maxStamina extends TypeFunction1<int, dynamic> {
  const _TearOff_GameCharacter_get_maxStamina();
  @override
  int call(dynamic this_) => GameCharacter_get_maxStamina(this_);
}
class _TearOff_GameCharacter_get_stamina extends TypeFunction1<int, dynamic> {
  const _TearOff_GameCharacter_get_stamina();
  @override
  int call(dynamic this_) => GameCharacter_get_stamina(this_);
}
class _TearOff_GameCharacter_staminaBar extends TypeFunction1<String, dynamic> {
  const _TearOff_GameCharacter_staminaBar();
  @override
  String call(dynamic this_) => GameCharacter_staminaBar(this_);
}
class _TearOff_GameCharacter_statusBars extends TypeFunction1<String, dynamic> {
  const _TearOff_GameCharacter_statusBars();
  @override
  String call(dynamic this_) => GameCharacter_statusBars(this_);
}
class _TearOff_Warrior_get_maxHealth extends TypeFunction1<int, dynamic> {
  const _TearOff_Warrior_get_maxHealth();
  @override
  int call(dynamic this_) => Warrior_get_maxHealth(this_);
}
class _TearOff_Warrior_get_health extends TypeFunction1<int, dynamic> {
  const _TearOff_Warrior_get_health();
  @override
  int call(dynamic this_) => Warrior_get_health(this_);
}
class _TearOff_Warrior_healthBar extends TypeFunction1<String, dynamic> {
  const _TearOff_Warrior_healthBar();
  @override
  String call(dynamic this_) => Warrior_healthBar(this_);
}
class _TearOff_Warrior_get_maxMana extends TypeFunction1<int, dynamic> {
  const _TearOff_Warrior_get_maxMana();
  @override
  int call(dynamic this_) => Warrior_get_maxMana(this_);
}
class _TearOff_Warrior_get_mana extends TypeFunction1<int, dynamic> {
  const _TearOff_Warrior_get_mana();
  @override
  int call(dynamic this_) => Warrior_get_mana(this_);
}
class _TearOff_Warrior_manaBar extends TypeFunction1<String, dynamic> {
  const _TearOff_Warrior_manaBar();
  @override
  String call(dynamic this_) => Warrior_manaBar(this_);
}
class _TearOff_Warrior_get_maxStamina extends TypeFunction1<int, dynamic> {
  const _TearOff_Warrior_get_maxStamina();
  @override
  int call(dynamic this_) => Warrior_get_maxStamina(this_);
}
class _TearOff_Warrior_get_stamina extends TypeFunction1<int, dynamic> {
  const _TearOff_Warrior_get_stamina();
  @override
  int call(dynamic this_) => Warrior_get_stamina(this_);
}
class _TearOff_Warrior_staminaBar extends TypeFunction1<String, dynamic> {
  const _TearOff_Warrior_staminaBar();
  @override
  String call(dynamic this_) => Warrior_staminaBar(this_);
}
class _TearOff_Warrior_statusBars extends TypeFunction1<String, dynamic> {
  const _TearOff_Warrior_statusBars();
  @override
  String call(dynamic this_) => Warrior_statusBars(this_);
}
class _TearOff_Mage_get_maxHealth extends TypeFunction1<int, dynamic> {
  const _TearOff_Mage_get_maxHealth();
  @override
  int call(dynamic this_) => Mage_get_maxHealth(this_);
}
class _TearOff_Mage_get_health extends TypeFunction1<int, dynamic> {
  const _TearOff_Mage_get_health();
  @override
  int call(dynamic this_) => Mage_get_health(this_);
}
class _TearOff_Mage_healthBar extends TypeFunction1<String, dynamic> {
  const _TearOff_Mage_healthBar();
  @override
  String call(dynamic this_) => Mage_healthBar(this_);
}
class _TearOff_Mage_get_maxMana extends TypeFunction1<int, dynamic> {
  const _TearOff_Mage_get_maxMana();
  @override
  int call(dynamic this_) => Mage_get_maxMana(this_);
}
class _TearOff_Mage_get_mana extends TypeFunction1<int, dynamic> {
  const _TearOff_Mage_get_mana();
  @override
  int call(dynamic this_) => Mage_get_mana(this_);
}
class _TearOff_Mage_manaBar extends TypeFunction1<String, dynamic> {
  const _TearOff_Mage_manaBar();
  @override
  String call(dynamic this_) => Mage_manaBar(this_);
}
class _TearOff_Mage_get_maxStamina extends TypeFunction1<int, dynamic> {
  const _TearOff_Mage_get_maxStamina();
  @override
  int call(dynamic this_) => Mage_get_maxStamina(this_);
}
class _TearOff_Mage_get_stamina extends TypeFunction1<int, dynamic> {
  const _TearOff_Mage_get_stamina();
  @override
  int call(dynamic this_) => Mage_get_stamina(this_);
}
class _TearOff_Mage_staminaBar extends TypeFunction1<String, dynamic> {
  const _TearOff_Mage_staminaBar();
  @override
  String call(dynamic this_) => Mage_staminaBar(this_);
}
class _TearOff_Mage_statusBars extends TypeFunction1<String, dynamic> {
  const _TearOff_Mage_statusBars();
  @override
  String call(dynamic this_) => Mage_statusBars(this_);
}
class _TearOff_Logger_get_prefix extends TypeFunction1<String, dynamic> {
  const _TearOff_Logger_get_prefix();
  @override
  String call(dynamic this_) => Logger_get_prefix(this_);
}
class _TearOff_Logger_format extends TypeFunction2<String, dynamic, String> {
  const _TearOff_Logger_format();
  @override
  String call(dynamic this_, String msg) => Logger_format(this_, msg);
}
class _TearOff_Formatter_get_prefix extends TypeFunction1<String, dynamic> {
  const _TearOff_Formatter_get_prefix();
  @override
  String call(dynamic this_) => Formatter_get_prefix(this_);
}
class _TearOff_Formatter_format extends TypeFunction2<String, dynamic, String> {
  const _TearOff_Formatter_format();
  @override
  String call(dynamic this_, String msg) => Formatter_format(this_, msg);
}
class _TearOff_StatefulMixin_get_counter extends TypeFunction1<int, dynamic> {
  const _TearOff_StatefulMixin_get_counter();
  @override
  int call(dynamic this_) => StatefulMixin_get_counter(this_);
}
class _TearOff_StatefulMixin_set_counter extends TypeFunction2<void, dynamic, int> {
  const _TearOff_StatefulMixin_set_counter();
  @override
  void call(dynamic this_, int value) => StatefulMixin_set_counter(this_, value);
}
class _TearOff_StatefulMixin_increment extends TypeFunction1<void, dynamic> {
  const _TearOff_StatefulMixin_increment();
  @override
  void call(dynamic this_) => StatefulMixin_increment(this_);
}
class _TearOff_StatefulMixin_decrement extends TypeFunction1<void, dynamic> {
  const _TearOff_StatefulMixin_decrement();
  @override
  void call(dynamic this_) => StatefulMixin_decrement(this_);
}
class _TearOff_StatefulMixin_get_counterStatus extends TypeFunction1<String, dynamic> {
  const _TearOff_StatefulMixin_get_counterStatus();
  @override
  String call(dynamic this_) => StatefulMixin_get_counterStatus(this_);
}
class _TearOff_LayerA_layer extends TypeFunction1<String, dynamic> {
  const _TearOff_LayerA_layer();
  @override
  String call(dynamic this_) => LayerA_layer(this_);
}
class _TearOff_LayerA_onlyA extends TypeFunction1<String, dynamic> {
  const _TearOff_LayerA_onlyA();
  @override
  String call(dynamic this_) => LayerA_onlyA(this_);
}
class _TearOff_LayerB_layer extends TypeFunction1<String, dynamic> {
  const _TearOff_LayerB_layer();
  @override
  String call(dynamic this_) => LayerB_layer(this_);
}
class _TearOff_LayerB_onlyB extends TypeFunction1<String, dynamic> {
  const _TearOff_LayerB_onlyB();
  @override
  String call(dynamic this_) => LayerB_onlyB(this_);
}
class _TearOff_LayerC_layer extends TypeFunction1<String, dynamic> {
  const _TearOff_LayerC_layer();
  @override
  String call(dynamic this_) => LayerC_layer(this_);
}
class _TearOff_LayerC_onlyC extends TypeFunction1<String, dynamic> {
  const _TearOff_LayerC_onlyC();
  @override
  String call(dynamic this_) => LayerC_onlyC(this_);
}
class _TearOff_Mappable_mapValue<T> extends TypeFunction2<dynamic, dynamic, TypeFunction1<dynamic, T>> {
  _TearOff_Mappable_mapValue();
  @override
  dynamic call(dynamic this_, TypeFunction1<dynamic, T> transform) => Mappable_mapValue<T, dynamic>(this_, transform);
}
class _TearOff_Mappable_describe<T> extends TypeFunction1<String, dynamic> {
  _TearOff_Mappable_describe();
  @override
  String call(dynamic this_) => Mappable_describe<T>(this_);
}
class _TearOff_Filterable_test<T> extends TypeFunction2<bool, dynamic, TypeFunction1<bool, T>> {
  _TearOff_Filterable_test();
  @override
  bool call(dynamic this_, TypeFunction1<bool, T> predicate) => Filterable_test<T>(this_, predicate);
}
class _TearOff_Taggable_tag extends TypeFunction2<void, dynamic, String> {
  const _TearOff_Taggable_tag();
  @override
  void call(dynamic this_, String t) => Taggable_tag(this_, t);
}
class _TearOff_Taggable_get_allTags extends TypeFunction1<StaticList<String>, dynamic> {
  const _TearOff_Taggable_get_allTags();
  @override
  StaticList<String> call(dynamic this_) => Taggable_get_allTags(this_);
}
class _TearOff_Taggable_hasTag extends TypeFunction2<bool, dynamic, String> {
  const _TearOff_Taggable_hasTag();
  @override
  bool call(dynamic this_, String t) => Taggable_hasTag(this_, t);
}
class _TearOff_Addable_addValues extends TypeFunction2<int, dynamic, int> {
  const _TearOff_Addable_addValues();
  @override
  int call(dynamic this_, int other) => Addable_addValues(this_, other);
}
class _TearOff_Addable_doubleValue extends TypeFunction1<int, dynamic> {
  const _TearOff_Addable_doubleValue();
  @override
  int call(dynamic this_) => Addable_doubleValue(this_);
}
class _TearOff_Printable2_prettyPrint extends TypeFunction1<void, dynamic> {
  const _TearOff_Printable2_prettyPrint();
  @override
  void call(dynamic this_) => Printable2_prettyPrint(this_);
}
class _TearOff_Scalable_scale extends TypeFunction2<double, dynamic, double> {
  const _TearOff_Scalable_scale();
  @override
  double call(dynamic this_, double factor) => Scalable_scale(this_, factor);
}
class _TearOff_Scalable_measureInfo extends TypeFunction1<String, dynamic> {
  const _TearOff_Scalable_measureInfo();
  @override
  String call(dynamic this_) => Scalable_measureInfo(this_);
}
class _TearOff_NamedMixin_get_label extends TypeFunction1<String, dynamic> {
  const _TearOff_NamedMixin_get_label();
  @override
  String call(dynamic this_) => NamedMixin_get_label(this_);
}
class _TearOff_NamedMixin_greet extends TypeFunction1<String, dynamic> {
  const _TearOff_NamedMixin_greet();
  @override
  String call(dynamic this_) => NamedMixin_greet(this_);
}
class _TearOff_DescribedMixin_get_label extends TypeFunction1<String, dynamic> {
  const _TearOff_DescribedMixin_get_label();
  @override
  String call(dynamic this_) => DescribedMixin_get_label(this_);
}
class _TearOff_DescribedMixin_info extends TypeFunction1<String, dynamic> {
  const _TearOff_DescribedMixin_info();
  @override
  String call(dynamic this_) => DescribedMixin_info(this_);
}
class _TearOff_Base64Mixin_encode extends TypeFunction2<String, dynamic, String> {
  const _TearOff_Base64Mixin_encode();
  @override
  String call(dynamic this_, String input) => Base64Mixin_encode(this_, input);
}
class _TearOff_HexMixin_encode extends TypeFunction2<String, dynamic, String> {
  const _TearOff_HexMixin_encode();
  @override
  String call(dynamic this_, String input) => HexMixin_encode(this_, input);
}
class _TearOff_ChainMixin_step1 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainMixin_step1();
  @override
  String call(dynamic this_) => ChainMixin_step1(this_);
}
class _TearOff_ChainMixin_step2 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainMixin_step2();
  @override
  String call(dynamic this_) => ChainMixin_step2(this_);
}
class _TearOff_ChainMixin_step3 extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainMixin_step3();
  @override
  String call(dynamic this_) => ChainMixin_step3(this_);
}
class _TearOff_ChainMixin_fullChain extends TypeFunction1<String, dynamic> {
  const _TearOff_ChainMixin_fullChain();
  @override
  String call(dynamic this_) => ChainMixin_fullChain(this_);
}
class _TearOff_HealthMixin_get_maxHealth extends TypeFunction1<int, dynamic> {
  const _TearOff_HealthMixin_get_maxHealth();
  @override
  int call(dynamic this_) => HealthMixin_get_maxHealth(this_);
}
class _TearOff_HealthMixin_get_health extends TypeFunction1<int, dynamic> {
  const _TearOff_HealthMixin_get_health();
  @override
  int call(dynamic this_) => HealthMixin_get_health(this_);
}
class _TearOff_HealthMixin_healthBar extends TypeFunction1<String, dynamic> {
  const _TearOff_HealthMixin_healthBar();
  @override
  String call(dynamic this_) => HealthMixin_healthBar(this_);
}
class _TearOff_ManaMixin_get_maxMana extends TypeFunction1<int, dynamic> {
  const _TearOff_ManaMixin_get_maxMana();
  @override
  int call(dynamic this_) => ManaMixin_get_maxMana(this_);
}
class _TearOff_ManaMixin_get_mana extends TypeFunction1<int, dynamic> {
  const _TearOff_ManaMixin_get_mana();
  @override
  int call(dynamic this_) => ManaMixin_get_mana(this_);
}
class _TearOff_ManaMixin_manaBar extends TypeFunction1<String, dynamic> {
  const _TearOff_ManaMixin_manaBar();
  @override
  String call(dynamic this_) => ManaMixin_manaBar(this_);
}
class _TearOff_StaminaMixin_get_maxStamina extends TypeFunction1<int, dynamic> {
  const _TearOff_StaminaMixin_get_maxStamina();
  @override
  int call(dynamic this_) => StaminaMixin_get_maxStamina(this_);
}
class _TearOff_StaminaMixin_get_stamina extends TypeFunction1<int, dynamic> {
  const _TearOff_StaminaMixin_get_stamina();
  @override
  int call(dynamic this_) => StaminaMixin_get_stamina(this_);
}
class _TearOff_StaminaMixin_staminaBar extends TypeFunction1<String, dynamic> {
  const _TearOff_StaminaMixin_staminaBar();
  @override
  String call(dynamic this_) => StaminaMixin_staminaBar(this_);
}
class ClosureEnv_main_2 extends TypeFunction1<int, int> {
  ClosureEnv_main_2();
  @override
  int call(int v) => ClosureEnv_main_2_call(this, v);
}
int ClosureEnv_main_2_call(ClosureEnv_main_2 env, int v) {
  return (v * 2);
}

class ClosureEnv_main_3 extends TypeFunction1<int, int> {
  ClosureEnv_main_3();
  @override
  int call(int v) => ClosureEnv_main_3_call(this, v);
}
int ClosureEnv_main_3_call(ClosureEnv_main_3 env, int v) {
  return (v * 2);
}

class ClosureEnv_main_4 extends TypeFunction1<bool, int> {
  ClosureEnv_main_4();
  @override
  bool call(int v) => ClosureEnv_main_4_call(this, v);
}
bool ClosureEnv_main_4_call(ClosureEnv_main_4 env, int v) {
  return (v > 10);
}

class ClosureEnv_main_5 extends TypeFunction1<bool, int> {
  ClosureEnv_main_5();
  @override
  bool call(int v) => ClosureEnv_main_5_call(this, v);
}
bool ClosureEnv_main_5_call(ClosureEnv_main_5 env, int v) {
  return (v > 10);
}

class ClosureEnv_main_6 extends TypeFunction1<bool, int> {
  ClosureEnv_main_6();
  @override
  bool call(int v) => ClosureEnv_main_6_call(this, v);
}
bool ClosureEnv_main_6_call(ClosureEnv_main_6 env, int v) {
  return (v > 100);
}

class ClosureEnv_main_7 extends TypeFunction1<bool, int> {
  ClosureEnv_main_7();
  @override
  bool call(int v) => ClosureEnv_main_7_call(this, v);
}
bool ClosureEnv_main_7_call(ClosureEnv_main_7 env, int v) {
  return (v > 100);
}

class ClosureEnv_main_8 extends TypeFunction1<String, String> {
  ClosureEnv_main_8();
  @override
  String call(String s) => ClosureEnv_main_8_call(this, s);
}
String ClosureEnv_main_8_call(ClosureEnv_main_8 env, String s) {
  return s.toUpperCase();
}

class ClosureEnv_main_9 extends TypeFunction1<String, String> {
  ClosureEnv_main_9();
  @override
  String call(String s) => ClosureEnv_main_9_call(this, s);
}
String ClosureEnv_main_9_call(ClosureEnv_main_9 env, String s) {
  return s.toUpperCase();
}


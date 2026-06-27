import 'package:dart2cpp/restorer/runtime_classes.dart';

String Logger_get_prefix(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'LOG';
}

String Logger_format(dynamic this__, String msg) {
  final this_ = this__ as dynamic;
  return '[${(this_.vptr['get_prefix'] as Function)(this_)}] ${msg}';
}

String Formatter_get_prefix(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'FMT';
}

String Formatter_format(dynamic this__, String msg) {
  final this_ = this__ as dynamic;
  return '{${(this_.vptr['get_prefix'] as Function)(this_)}: ${msg}}';
}

int StatefulMixin_get_counter(dynamic this__) {
  final this_ = this__ as dynamic;
  return this_._counter;
}

void StatefulMixin_set_counter(dynamic this__, int value) {
  final this_ = this__ as dynamic;
  this_._counter = value;
  return;
}

void StatefulMixin_increment(dynamic this__) {
  final this_ = this__ as dynamic;
  (this_.vptr['set_counter'] as Function)(this_, ((this_.vptr['get_counter'] as Function)(this_) + 1));
  return;
}

void StatefulMixin_decrement(dynamic this__) {
  final this_ = this__ as dynamic;
  (this_.vptr['set_counter'] as Function)(this_, ((this_.vptr['get_counter'] as Function)(this_) - 1));
  return;
}

String StatefulMixin_get_counterStatus(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'count=${(this_.vptr['get_counter'] as Function)(this_)}';
}

String LayerA_layer(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'A';
}

String LayerA_onlyA(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'onlyA';
}

String LayerB_layer(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'B';
}

String LayerB_onlyB(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'onlyB';
}

String LayerC_layer(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'C';
}

String LayerC_onlyC(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'onlyC';
}

R Mappable_mapValue<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as dynamic;
  return transform((this_.vptr['get_value'] as Function)(this_));
}

String Mappable_describe<T extends dynamic>(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'Mappable<${(this_.vptr['get_value'] as Function)(this_).runtimeType}>(${(this_.vptr['get_value'] as Function)(this_)})';
}

bool Filterable_test<T extends dynamic>(dynamic this__, TypeFunction1<bool, T> predicate) {
  final this_ = this__ as dynamic;
  return predicate((this_.vptr['get_value'] as Function)(this_));
}

void Taggable_tag(dynamic this__, String t) {
  final this_ = this__ as dynamic;
  this_._tags.add(t);
  return;
}

StaticList<String> Taggable_get_allTags(dynamic this__) {
  final this_ = this__ as dynamic;
  return StaticList<String>.unmodifiable(this_._tags);
}

bool Taggable_hasTag(dynamic this__, String t) {
  final this_ = this__ as dynamic;
  return this_._tags.contains(t);
}

int Addable_addValues(dynamic this__, int other) {
  final this_ = this__ as dynamic;
  return ((this_.vptr['get_numericValue'] as Function)(this_) + other);
}

int Addable_doubleValue(dynamic this__) {
  final this_ = this__ as dynamic;
  return (this_.vptr['addValues'] as Function)(this_, (this_.vptr['get_numericValue'] as Function)(this_));
}

void Printable2_prettyPrint(dynamic this__) {
  final this_ = this__ as dynamic;
  staticPrint('>> ${(this_.vptr['toPrettyString'] as Function)(this_)}');
  return;
}

double Scalable_scale(dynamic this__, double factor) {
  final this_ = this__ as dynamic;
  return ((this_.vptr['measure'] as Function)(this_) * factor);
}

String Scalable_measureInfo(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'measure=${dart_str_toStringAsFixed((this_.vptr['measure'] as Function)(this_), 1)}';
}

String NamedMixin_get_label(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'NamedMixin';
}

String NamedMixin_greet(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'Hello from ${(this_.vptr['get_label'] as Function)(this_)}';
}

String DescribedMixin_get_label(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'DescribedMixin';
}

String DescribedMixin_info(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'Info: ${(this_.vptr['get_label'] as Function)(this_)}';
}

String Base64Mixin_encode(dynamic this__, String input) {
  final this_ = this__ as dynamic;
  return 'base64(${input})';
}

String HexMixin_encode(dynamic this__, String input) {
  final this_ = this__ as dynamic;
  return 'hex(${input})';
}

String ChainMixin_step1(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'S1';
}

String ChainMixin_step2(dynamic this__) {
  final this_ = this__ as dynamic;
  return '${(this_.vptr['step1'] as Function)(this_)}->S2';
}

String ChainMixin_step3(dynamic this__) {
  final this_ = this__ as dynamic;
  return '${(this_.vptr['step2'] as Function)(this_)}->S3';
}

String ChainMixin_fullChain(dynamic this__) {
  final this_ = this__ as dynamic;
  return '${(this_.vptr['step3'] as Function)(this_)}->done';
}

int HealthMixin_get_maxHealth(dynamic this__) {
  final this_ = this__ as dynamic;
  return 100;
}

int HealthMixin_get_health(dynamic this__) {
  final this_ = this__ as dynamic;
  return (this_.vptr['get_maxHealth'] as Function)(this_);
}

String HealthMixin_healthBar(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'HP:${(this_.vptr['get_health'] as Function)(this_)}/${(this_.vptr['get_maxHealth'] as Function)(this_)}';
}

int ManaMixin_get_maxMana(dynamic this__) {
  final this_ = this__ as dynamic;
  return 50;
}

int ManaMixin_get_mana(dynamic this__) {
  final this_ = this__ as dynamic;
  return (this_.vptr['get_maxMana'] as Function)(this_);
}

String ManaMixin_manaBar(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'MP:${(this_.vptr['get_mana'] as Function)(this_)}/${(this_.vptr['get_maxMana'] as Function)(this_)}';
}

int StaminaMixin_get_maxStamina(dynamic this__) {
  final this_ = this__ as dynamic;
  return 80;
}

int StaminaMixin_get_stamina(dynamic this__) {
  final this_ = this__ as dynamic;
  return (this_.vptr['get_maxStamina'] as Function)(this_);
}

String StaminaMixin_staminaBar(dynamic this__) {
  final this_ = this__ as dynamic;
  return 'SP:${(this_.vptr['get_stamina'] as Function)(this_)}/${(this_.vptr['get_maxStamina'] as Function)(this_)}';
}

class DiamondClassValue extends DiamondClass_Object_Logger_FormatterValue {
  late String name;

  DiamondClassValue() {
    vptr['get_prefix'] = DiamondClass_Object_Logger_Formatter_get_prefix;
    vptr['format'] = DiamondClass_Object_Logger_Formatter_format;
    vptr['display'] = DiamondClass_display;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

DiamondClassValue DiamondClass_new(dynamic this__, String name) {
  final this_ = this__ as DiamondClassValue;
  DiamondClass_Object_Logger_Formatter_new(this_);
  this_.name = name;
  return this_;
}

String DiamondClass_display(dynamic this__, String msg) {
  final this_ = this__ as DiamondClassValue;
  return '${this_.name}: ${(this_.vptr['format'] as Function)(this_, msg)}';
}

String DiamondClass_get_prefix(dynamic this__) => DiamondClass_Object_Logger_Formatter_get_prefix(this__);

String DiamondClass_format(dynamic this__, String msg) => DiamondClass_Object_Logger_Formatter_format(this__, msg);

class StatefulWidgetValue extends StatefulWidget_Object_StatefulMixinValue {
  late String id;

  StatefulWidgetValue() {
    vptr['get_counter'] = StatefulWidget_Object_StatefulMixin_get_counter;
    vptr['set_counter'] = StatefulWidget_Object_StatefulMixin_set_counter;
    vptr['increment'] = StatefulWidget_Object_StatefulMixin_increment;
    vptr['decrement'] = StatefulWidget_Object_StatefulMixin_decrement;
    vptr['get_counterStatus'] = StatefulWidget_Object_StatefulMixin_get_counterStatus;
    vptr['toString'] = StatefulWidget_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

StatefulWidgetValue StatefulWidget_new(dynamic this__, String id) {
  final this_ = this__ as StatefulWidgetValue;
  StatefulWidget_Object_StatefulMixin_new(this_);
  this_.id = id;
  return this_;
}

String StatefulWidget_toString(dynamic this__) {
  final this_ = this__ as StatefulWidgetValue;
  return 'Widget(${this_.id}, ${(this_.vptr['get_counterStatus'] as Function)(this_)})';
}

int StatefulWidget_get_counter(dynamic this__) => StatefulWidget_Object_StatefulMixin_get_counter(this__);

void StatefulWidget_set_counter(dynamic this__, int value) { StatefulWidget_Object_StatefulMixin_set_counter(this__, value); }

void StatefulWidget_increment(dynamic this__) { StatefulWidget_Object_StatefulMixin_increment(this__); }

void StatefulWidget_decrement(dynamic this__) { StatefulWidget_Object_StatefulMixin_decrement(this__); }

String StatefulWidget_get_counterStatus(dynamic this__) => StatefulWidget_Object_StatefulMixin_get_counterStatus(this__);

class DeepMixinClassValue extends DeepMixinClass_Object_LayerA_LayerB_LayerCValue {

  DeepMixinClassValue() {
    vptr['layer'] = DeepMixinClass_Object_LayerA_LayerB_LayerC_layer;
    vptr['onlyA'] = DeepMixinClass_Object_LayerA_onlyA;
    vptr['onlyB'] = DeepMixinClass_Object_LayerA_LayerB_onlyB;
    vptr['onlyC'] = DeepMixinClass_Object_LayerA_LayerB_LayerC_onlyC;
    vptr['allLayers'] = DeepMixinClass_allLayers;
  }
}

DeepMixinClassValue DeepMixinClass_new(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  DeepMixinClass_Object_LayerA_LayerB_LayerC_new(this_);
  return this_;
}

String DeepMixinClass_allLayers(dynamic this__) {
  final this_ = this__ as DeepMixinClassValue;
  return '${(this_.vptr['layer'] as Function)(this_)}-${(this_.vptr['onlyA'] as Function)(this_)}-${(this_.vptr['onlyB'] as Function)(this_)}-${(this_.vptr['onlyC'] as Function)(this_)}';
}

String DeepMixinClass_layer(dynamic this__) => DeepMixinClass_Object_LayerA_LayerB_LayerC_layer(this__);

String DeepMixinClass_onlyA(dynamic this__) => DeepMixinClass_Object_LayerA_onlyA(this__);

String DeepMixinClass_onlyB(dynamic this__) => DeepMixinClass_Object_LayerA_LayerB_onlyB(this__);

String DeepMixinClass_onlyC(dynamic this__) => DeepMixinClass_Object_LayerA_LayerB_LayerC_onlyC(this__);

class BoxValue<T extends dynamic> extends Box_Object_Mappable_FilterableValue<T> {
  late T value;

  BoxValue() {
    vptr['get_value'] = Box_get_value;
    vptr['mapValue'] = Box_Object_Mappable_mapValue<T, dynamic>;
    vptr['mapValue_int'] = Box_Object_Mappable_mapValue<T, int>;
    vptr['mapValue_String'] = Box_Object_Mappable_mapValue<T, String>;
    vptr['describe'] = Box_Object_Mappable_describe<T>;
    vptr['test'] = Box_Object_Mappable_Filterable_test<T>;
    vptr['toString'] = Box_toString<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

BoxValue<T> Box_new<T extends dynamic>(dynamic this__, T value) {
  final this_ = this__ as BoxValue<T>;
  Box_Object_Mappable_Filterable_new(this_);
  this_.value = value;
  return this_;
}

String Box_toString<T extends dynamic>(dynamic this__) {
  final this_ = this__ as BoxValue<T>;
  return 'Box(${this_.value})';
}

T Box_get_value<T extends dynamic>(dynamic this__) {
  final this_ = this__ as BoxValue<T>;
  return this_.value;
}

R Box_mapValue<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) => Box_Object_Mappable_mapValue<T, R>(this__, transform);

String Box_describe<T extends dynamic>(dynamic this__) => Box_Object_Mappable_describe<T>(this__);

bool Box_test<T extends dynamic>(dynamic this__, TypeFunction1<bool, T> predicate) => Box_Object_Mappable_Filterable_test<T>(this__, predicate);

class IdentifiableValue extends VPtr {

  IdentifiableValue() {
    vptr['get_id'] = Identifiable_get_id;
  }
}

IdentifiableValue Identifiable_new(dynamic this__) {
  final this_ = this__ as IdentifiableValue;
  return this_;
}

String Identifiable_get_id(dynamic this__) {
  throw UnimplementedError('Identifiable_get_id is abstract');
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

String Describable_describe(dynamic this__) {
  throw UnimplementedError('Describable_describe is abstract');
}

class ResourceValue extends VPtr implements IdentifiableValue, DescribableValue {
  late String id;
  late String type;

  ResourceValue() {
    vptr['get_id'] = Resource_get_id;
    vptr['describe'] = Resource_describe;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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

String Resource_get_id(dynamic this__) {
  final this_ = this__ as ResourceValue;
  return this_.id;
}

class TaggedResourceValue extends TaggedResource_Resource_TaggableValue {

  TaggedResourceValue() {
    vptr['describe'] = TaggedResource_describe;
    vptr['tag'] = TaggedResource_Resource_Taggable_tag;
    vptr['get_allTags'] = TaggedResource_Resource_Taggable_get_allTags;
    vptr['hasTag'] = TaggedResource_Resource_Taggable_hasTag;
  }
}

TaggedResourceValue TaggedResource_new(dynamic this__, String id, String type) {
  final this_ = this__ as TaggedResourceValue;
  TaggedResource_Resource_Taggable_new(this_, id, type);
  return this_;
}

String TaggedResource_describe(dynamic this__) {
  final this_ = this__ as TaggedResourceValue;
  return '${TaggedResource_Resource_Taggable_describe(this_)}, tags=${(this_.vptr['get_allTags'] as Function)(this_)}';
}

dynamic TaggedResource_get_id(dynamic this__) => Resource_get_id(this__);

void TaggedResource_tag(dynamic this__, String t) { TaggedResource_Resource_Taggable_tag(this__, t); }

StaticList<String> TaggedResource_get_allTags(dynamic this__) => TaggedResource_Resource_Taggable_get_allTags(this__);

bool TaggedResource_hasTag(dynamic this__, String t) => TaggedResource_Resource_Taggable_hasTag(this__, t);

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

class AmountValue extends Amount_Object_AddableValue {
  late int numericValue;

  AmountValue() {
    vptr['get_numericValue'] = Amount_get_numericValue;
    vptr['addValues'] = Amount_Object_Addable_addValues;
    vptr['doubleValue'] = Amount_Object_Addable_doubleValue;
    vptr['operatorPlus'] = Amount_operatorPlus;
    vptr['operatorMinus'] = Amount_operatorMinus;
    vptr['operatorLt'] = Amount_operatorLt;
    vptr['operatorGt'] = Amount_operatorGt;
    vptr['toString'] = Amount_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

AmountValue Amount_new(dynamic this__, int numericValue) {
  final this_ = this__ as AmountValue;
  Amount_Object_Addable_new(this_);
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

int Amount_addValues(dynamic this__, int other) => Amount_Object_Addable_addValues(this__, other);

int Amount_doubleValue(dynamic this__) => Amount_Object_Addable_doubleValue(this__);

class VehicleValue extends VPtr {
  late String make;
  late int year;

  VehicleValue() {
    vptr['toString'] = Vehicle_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
    vptr['prettyPrint'] = Car_Vehicle_Printable2_prettyPrint;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

CarValue Car_new(dynamic this__, String make, int year, int doors) {
  final this_ = this__ as CarValue;
  Car_Vehicle_Printable2_new(this_, make, year);
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

void Car_prettyPrint(dynamic this__) { Car_Vehicle_Printable2_prettyPrint(this__); }

class ElectricCarValue extends CarValue {
  late int range;

  ElectricCarValue() {
    vptr['toString'] = ElectricCar_toString;
    vptr['toPrettyString'] = ElectricCar_toPrettyString;
  }

  @override
  void gcMark(int flag) {
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

void ElectricCar_prettyPrint(dynamic this__) { Car_Vehicle_Printable2_prettyPrint(this__); }

class MeasurableValue extends VPtr {

  MeasurableValue() {
    vptr['measure'] = Measurable_measure;
  }
}

MeasurableValue Measurable_new(dynamic this__) {
  final this_ = this__ as MeasurableValue;
  return this_;
}

double Measurable_measure(dynamic this__) {
  throw UnimplementedError('Measurable_measure is abstract');
}

class SegmentValue extends Segment_Measurable_ScalableValue {
  late double length;

  SegmentValue() {
    vptr['measure'] = Segment_measure;
    vptr['scale'] = Segment_Measurable_Scalable_scale;
    vptr['measureInfo'] = Segment_Measurable_Scalable_measureInfo;
    vptr['toString'] = Segment_toString;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

SegmentValue Segment_new(dynamic this__, double length) {
  final this_ = this__ as SegmentValue;
  Segment_Measurable_Scalable_new(this_);
  this_.length = length;
  return this_;
}

double Segment_measure(dynamic this__) {
  final this_ = this__ as SegmentValue;
  return this_.length;
}

String Segment_toString(dynamic this__) {
  final this_ = this__ as SegmentValue;
  return 'Segment(${this_.length}, ${(this_.vptr['measureInfo'] as Function)(this_)})';
}

double Segment_scale(dynamic this__, double factor) => Segment_Measurable_Scalable_scale(this__, factor);

String Segment_measureInfo(dynamic this__) => Segment_Measurable_Scalable_measureInfo(this__);

class WeightedSegmentValue extends SegmentValue {
  late double weight;

  WeightedSegmentValue() {
    vptr['measure'] = WeightedSegment_measure;
    vptr['toString'] = WeightedSegment_toString;
  }

  @override
  void gcMark(int flag) {
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
  return 'WeightedSegment(len=${this_.length}, w=${this_.weight}, ${(this_.vptr['measureInfo'] as Function)(this_)})';
}

double WeightedSegment_scale(dynamic this__, double factor) => Segment_Measurable_Scalable_scale(this__, factor);

String WeightedSegment_measureInfo(dynamic this__) => Segment_Measurable_Scalable_measureInfo(this__);

class MultiMixinEntityValue extends MultiMixinEntity_Object_NamedMixin_DescribedMixinValue {

  MultiMixinEntityValue() {
    vptr['get_label'] = MultiMixinEntity_get_label;
    vptr['greet'] = MultiMixinEntity_Object_NamedMixin_greet;
    vptr['info'] = MultiMixinEntity_Object_NamedMixin_DescribedMixin_info;
    vptr['fullInfo'] = MultiMixinEntity_fullInfo;
  }
}

MultiMixinEntityValue MultiMixinEntity_new(dynamic this__) {
  final this_ = this__ as MultiMixinEntityValue;
  MultiMixinEntity_Object_NamedMixin_DescribedMixin_new(this_);
  return this_;
}

String MultiMixinEntity_get_label(dynamic this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return 'Entity';
}

String MultiMixinEntity_fullInfo(dynamic this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return '${(this_.vptr['greet'] as Function)(this_)} | ${(this_.vptr['info'] as Function)(this_)}';
}

String MultiMixinEntity_greet(dynamic this__) => MultiMixinEntity_Object_NamedMixin_greet(this__);

String MultiMixinEntity_info(dynamic this__) => MultiMixinEntity_Object_NamedMixin_DescribedMixin_info(this__);

class EncoderValue extends VPtr {

  EncoderValue() {
    vptr['encode'] = Encoder_encode;
  }
}

EncoderValue Encoder_new(dynamic this__) {
  final this_ = this__ as EncoderValue;
  return this_;
}

String Encoder_encode(dynamic this__) {
  throw UnimplementedError('Encoder_encode is abstract');
}

class MultiEncoderValue extends MultiEncoder_Object_Base64Mixin_HexMixinValue {

  MultiEncoderValue() {
    vptr['encode'] = MultiEncoder_Object_Base64Mixin_HexMixin_encode;
    vptr['encodeAll'] = MultiEncoder_encodeAll;
  }
}

MultiEncoderValue MultiEncoder_new(dynamic this__) {
  final this_ = this__ as MultiEncoderValue;
  MultiEncoder_Object_Base64Mixin_HexMixin_new(this_);
  return this_;
}

String MultiEncoder_encodeAll(dynamic this__, String input) {
  final this_ = this__ as MultiEncoderValue;
  return (this_.vptr['encode'] as Function)(this_, input);
}

String MultiEncoder_encode(dynamic this__, String input) => MultiEncoder_Object_Base64Mixin_HexMixin_encode(this__, input);

class CustomEncoderValue extends MultiEncoderValue {

  CustomEncoderValue() {
    vptr['encode'] = CustomEncoder_encode;
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

String CustomEncoder_encodeAll(dynamic this__, String input) => MultiEncoder_encodeAll(this__, input);

class ContainerValue<T extends dynamic> extends VPtr {
  late T item;

  ContainerValue() {
    vptr['describe'] = Container_describe<T>;
    vptr['get_content'] = Container_get_content<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

ContainerValue<T> Container_new<T extends dynamic>(dynamic this__, T item) {
  final this_ = this__ as ContainerValue<T>;
  this_.item = item;
  return this_;
}

String Container_describe<T extends dynamic>(dynamic this__) {
  final this_ = this__ as ContainerValue<T>;
  return 'Container<${this_.item.runtimeType}>(${this_.item})';
}

T Container_get_content<T extends dynamic>(dynamic this__) {
  final this_ = this__ as ContainerValue<T>;
  return this_.item;
}

class LabeledContainerValue<T extends dynamic> extends ContainerValue<T> {
  late String label;

  LabeledContainerValue() {
    vptr['describe'] = LabeledContainer_describe<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

LabeledContainerValue<T> LabeledContainer_new<T extends dynamic>(dynamic this__, T item, String label) {
  final this_ = this__ as LabeledContainerValue<T>;
  Container_new(this_, item);
  this_.label = label;
  return this_;
}

String LabeledContainer_describe<T extends dynamic>(dynamic this__) {
  final this_ = this__ as LabeledContainerValue<T>;
  return 'Labeled[${this_.label}]: ${Container_describe(this_)}';
}

T LabeledContainer_get_content<T extends dynamic>(dynamic this__) => Container_get_content<T>(this__);

class PriorityContainerValue<T extends dynamic> extends LabeledContainerValue<T> {
  late int priority;

  PriorityContainerValue() {
    vptr['describe'] = PriorityContainer_describe<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

PriorityContainerValue<T> PriorityContainer_new<T extends dynamic>(dynamic this__, T item, String label, int priority) {
  final this_ = this__ as PriorityContainerValue<T>;
  LabeledContainer_new(this_, item, label);
  this_.priority = priority;
  return this_;
}

String PriorityContainer_describe<T extends dynamic>(dynamic this__) {
  final this_ = this__ as PriorityContainerValue<T>;
  return '(P${this_.priority}) ${LabeledContainer_describe(this_)}';
}

T PriorityContainer_get_content<T extends dynamic>(dynamic this__) => Container_get_content<T>(this__);

class ChainClassValue extends ChainClass_Object_ChainMixinValue {

  ChainClassValue() {
    vptr['step1'] = ChainClass_step1;
    vptr['step2'] = ChainClass_Object_ChainMixin_step2;
    vptr['step3'] = ChainClass_Object_ChainMixin_step3;
    vptr['fullChain'] = ChainClass_Object_ChainMixin_fullChain;
  }
}

ChainClassValue ChainClass_new(dynamic this__) {
  final this_ = this__ as ChainClassValue;
  ChainClass_Object_ChainMixin_new(this_);
  return this_;
}

String ChainClass_step1(dynamic this__) {
  final this_ = this__ as ChainClassValue;
  return 'X1';
}

String ChainClass_step2(dynamic this__) => ChainClass_Object_ChainMixin_step2(this__);

String ChainClass_step3(dynamic this__) => ChainClass_Object_ChainMixin_step3(this__);

String ChainClass_fullChain(dynamic this__) => ChainClass_Object_ChainMixin_fullChain(this__);

class ChainSubClassValue extends ChainClassValue {

  ChainSubClassValue() {
    vptr['step2'] = ChainSubClass_step2;
  }
}

ChainSubClassValue ChainSubClass_new(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  ChainClass_new(this_);
  return this_;
}

String ChainSubClass_step2(dynamic this__) {
  final this_ = this__ as ChainSubClassValue;
  return '${(this_.vptr['step1'] as Function)(this_)}->Y2';
}

String ChainSubClass_step1(dynamic this__) => ChainClass_step1(this__);

String ChainSubClass_step3(dynamic this__) => ChainClass_Object_ChainMixin_step3(this__);

String ChainSubClass_fullChain(dynamic this__) => ChainClass_Object_ChainMixin_fullChain(this__);

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

double Expression2_evaluate(dynamic this__) {
  throw UnimplementedError('Expression2_evaluate is abstract');
}

String Expression2_display(dynamic this__) {
  throw UnimplementedError('Expression2_display is abstract');
}

class NumberExprValue extends Expression2Value {
  late double value;

  NumberExprValue() {
    vptr['evaluate'] = NumberExpr_evaluate;
    vptr['display'] = NumberExpr_display;
  }

  @override
  void gcMark(int flag) {
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
    super.gcMark(flag);
    left?.gcMark(flag);
    right?.gcMark(flag);
    _compute?.gcMark(flag);
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
  return BinaryExpr_new(BinaryExprValue(), l, r, '+', ClosureEnv_global_0_new(GC.allocateLocal(ClosureEnv_global_0())));
}

BinaryExprValue BinaryExpr_new_mul(Expression2Value l, Expression2Value r) {
  return BinaryExpr_new(BinaryExprValue(), l, r, '*', ClosureEnv_global_1_new(GC.allocateLocal(ClosureEnv_global_1())));
}

double BinaryExpr_evaluate(dynamic this__) {
  final this_ = this__ as BinaryExprValue;
  return (() { final _unnamed1 = (this_.left.vptr['evaluate'] as Function)(this_.left); return (() { final _unnamed2 = (this_.right.vptr['evaluate'] as Function)(this_.right); return this_._compute(_unnamed1, _unnamed2); })(); })();
}

String BinaryExpr_display(dynamic this__) {
  final this_ = this__ as BinaryExprValue;
  return '(${(this_.left.vptr['display'] as Function)(this_.left)} ${this_.op} ${(this_.right.vptr['display'] as Function)(this_.right)})';
}

class GameCharacterValue extends GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue {
  late String name;

  GameCharacterValue() {
    vptr['get_maxHealth'] = GameCharacter_Object_HealthMixin_get_maxHealth;
    vptr['get_health'] = GameCharacter_Object_HealthMixin_get_health;
    vptr['healthBar'] = GameCharacter_Object_HealthMixin_healthBar;
    vptr['get_maxMana'] = GameCharacter_Object_HealthMixin_ManaMixin_get_maxMana;
    vptr['get_mana'] = GameCharacter_Object_HealthMixin_ManaMixin_get_mana;
    vptr['manaBar'] = GameCharacter_Object_HealthMixin_ManaMixin_manaBar;
    vptr['get_maxStamina'] = GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_maxStamina;
    vptr['get_stamina'] = GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_stamina;
    vptr['staminaBar'] = GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_staminaBar;
    vptr['statusBars'] = GameCharacter_statusBars;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

GameCharacterValue GameCharacter_new(dynamic this__, String name) {
  final this_ = this__ as GameCharacterValue;
  GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_new(this_);
  this_.name = name;
  return this_;
}

String GameCharacter_statusBars(dynamic this__) {
  final this_ = this__ as GameCharacterValue;
  return '${this_.name}: ${(this_.vptr['healthBar'] as Function)(this_)} ${(this_.vptr['manaBar'] as Function)(this_)} ${(this_.vptr['staminaBar'] as Function)(this_)}';
}

int GameCharacter_get_maxHealth(dynamic this__) => GameCharacter_Object_HealthMixin_get_maxHealth(this__);

int GameCharacter_get_health(dynamic this__) => GameCharacter_Object_HealthMixin_get_health(this__);

String GameCharacter_healthBar(dynamic this__) => GameCharacter_Object_HealthMixin_healthBar(this__);

int GameCharacter_get_maxMana(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_get_maxMana(this__);

int GameCharacter_get_mana(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_get_mana(this__);

String GameCharacter_manaBar(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_manaBar(this__);

int GameCharacter_get_maxStamina(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_maxStamina(this__);

int GameCharacter_get_stamina(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_stamina(this__);

String GameCharacter_staminaBar(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_staminaBar(this__);

class WarriorValue extends GameCharacterValue {

  WarriorValue() {
    vptr['get_maxHealth'] = Warrior_get_maxHealth;
    vptr['get_maxStamina'] = Warrior_get_maxStamina;
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

int Warrior_get_health(dynamic this__) => GameCharacter_Object_HealthMixin_get_health(this__);

String Warrior_healthBar(dynamic this__) => GameCharacter_Object_HealthMixin_healthBar(this__);

int Warrior_get_maxMana(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_get_maxMana(this__);

int Warrior_get_mana(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_get_mana(this__);

String Warrior_manaBar(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_manaBar(this__);

int Warrior_get_stamina(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_stamina(this__);

String Warrior_staminaBar(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_staminaBar(this__);

String Warrior_statusBars(dynamic this__) => GameCharacter_statusBars(this__);

class MageValue extends GameCharacterValue {

  MageValue() {
    vptr['get_maxHealth'] = Mage_get_maxHealth;
    vptr['get_maxMana'] = Mage_get_maxMana;
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

int Mage_get_health(dynamic this__) => GameCharacter_Object_HealthMixin_get_health(this__);

String Mage_healthBar(dynamic this__) => GameCharacter_Object_HealthMixin_healthBar(this__);

int Mage_get_mana(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_get_mana(this__);

String Mage_manaBar(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_manaBar(this__);

int Mage_get_maxStamina(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_maxStamina(this__);

int Mage_get_stamina(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_stamina(this__);

String Mage_staminaBar(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_staminaBar(this__);

String Mage_statusBars(dynamic this__) => GameCharacter_statusBars(this__);

class DiamondClass_Object_LoggerValue extends VPtr {

  DiamondClass_Object_LoggerValue() {
    vptr['get_prefix'] = DiamondClass_Object_Logger_get_prefix;
    vptr['format'] = DiamondClass_Object_Logger_format;
  }
}

DiamondClass_Object_LoggerValue DiamondClass_Object_Logger_new(dynamic this__) {
  final this_ = this__ as DiamondClass_Object_LoggerValue;
  return this_;
}

String DiamondClass_Object_Logger_get_prefix(dynamic this__) {
  final this_ = this__ as DiamondClass_Object_LoggerValue;
  return Logger_get_prefix(this_);
}

String DiamondClass_Object_Logger_format(dynamic this__, String msg) {
  final this_ = this__ as DiamondClass_Object_LoggerValue;
  return Logger_format(this_, msg);
}

class DiamondClass_Object_Logger_FormatterValue extends DiamondClass_Object_LoggerValue {

  DiamondClass_Object_Logger_FormatterValue() {
    vptr['get_prefix'] = DiamondClass_Object_Logger_Formatter_get_prefix;
    vptr['format'] = DiamondClass_Object_Logger_Formatter_format;
  }
}

DiamondClass_Object_Logger_FormatterValue DiamondClass_Object_Logger_Formatter_new(dynamic this__) {
  final this_ = this__ as DiamondClass_Object_Logger_FormatterValue;
  DiamondClass_Object_Logger_new(this_);
  return this_;
}

String DiamondClass_Object_Logger_Formatter_get_prefix(dynamic this__) {
  final this_ = this__ as DiamondClass_Object_Logger_FormatterValue;
  return Formatter_get_prefix(this_);
}

String DiamondClass_Object_Logger_Formatter_format(dynamic this__, String msg) {
  final this_ = this__ as DiamondClass_Object_Logger_FormatterValue;
  return Formatter_format(this_, msg);
}

class StatefulWidget_Object_StatefulMixinValue extends VPtr {
  late int _counter = 0;

  StatefulWidget_Object_StatefulMixinValue() {
    vptr['get_counter'] = StatefulWidget_Object_StatefulMixin_get_counter;
    vptr['set_counter'] = StatefulWidget_Object_StatefulMixin_set_counter;
    vptr['increment'] = StatefulWidget_Object_StatefulMixin_increment;
    vptr['decrement'] = StatefulWidget_Object_StatefulMixin_decrement;
    vptr['get_counterStatus'] = StatefulWidget_Object_StatefulMixin_get_counterStatus;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

StatefulWidget_Object_StatefulMixinValue StatefulWidget_Object_StatefulMixin_new(dynamic this__) {
  final this_ = this__ as StatefulWidget_Object_StatefulMixinValue;
  return this_;
}

int StatefulWidget_Object_StatefulMixin_get_counter(dynamic this__) {
  final this_ = this__ as StatefulWidget_Object_StatefulMixinValue;
  return StatefulMixin_get_counter(this_);
}

void StatefulWidget_Object_StatefulMixin_set_counter(dynamic this__, int value) {
  final this_ = this__ as StatefulWidget_Object_StatefulMixinValue;
  StatefulMixin_set_counter(this_, value);
  return;
}

void StatefulWidget_Object_StatefulMixin_increment(dynamic this__) {
  final this_ = this__ as StatefulWidget_Object_StatefulMixinValue;
  StatefulMixin_increment(this_);
  return;
}

void StatefulWidget_Object_StatefulMixin_decrement(dynamic this__) {
  final this_ = this__ as StatefulWidget_Object_StatefulMixinValue;
  StatefulMixin_decrement(this_);
  return;
}

String StatefulWidget_Object_StatefulMixin_get_counterStatus(dynamic this__) {
  final this_ = this__ as StatefulWidget_Object_StatefulMixinValue;
  return StatefulMixin_get_counterStatus(this_);
}

class DeepMixinClass_Object_LayerAValue extends VPtr {

  DeepMixinClass_Object_LayerAValue() {
    vptr['layer'] = DeepMixinClass_Object_LayerA_layer;
    vptr['onlyA'] = DeepMixinClass_Object_LayerA_onlyA;
  }
}

DeepMixinClass_Object_LayerAValue DeepMixinClass_Object_LayerA_new(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerAValue;
  return this_;
}

String DeepMixinClass_Object_LayerA_layer(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerAValue;
  return LayerA_layer(this_);
}

String DeepMixinClass_Object_LayerA_onlyA(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerAValue;
  return LayerA_onlyA(this_);
}

class DeepMixinClass_Object_LayerA_LayerBValue extends DeepMixinClass_Object_LayerAValue {

  DeepMixinClass_Object_LayerA_LayerBValue() {
    vptr['layer'] = DeepMixinClass_Object_LayerA_LayerB_layer;
    vptr['onlyB'] = DeepMixinClass_Object_LayerA_LayerB_onlyB;
  }
}

DeepMixinClass_Object_LayerA_LayerBValue DeepMixinClass_Object_LayerA_LayerB_new(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerA_LayerBValue;
  DeepMixinClass_Object_LayerA_new(this_);
  return this_;
}

String DeepMixinClass_Object_LayerA_LayerB_layer(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerA_LayerBValue;
  return LayerB_layer(this_);
}

String DeepMixinClass_Object_LayerA_LayerB_onlyB(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerA_LayerBValue;
  return LayerB_onlyB(this_);
}

String DeepMixinClass_Object_LayerA_LayerB_onlyA(dynamic this__) => DeepMixinClass_Object_LayerA_onlyA(this__);

class DeepMixinClass_Object_LayerA_LayerB_LayerCValue extends DeepMixinClass_Object_LayerA_LayerBValue {

  DeepMixinClass_Object_LayerA_LayerB_LayerCValue() {
    vptr['layer'] = DeepMixinClass_Object_LayerA_LayerB_LayerC_layer;
    vptr['onlyC'] = DeepMixinClass_Object_LayerA_LayerB_LayerC_onlyC;
  }
}

DeepMixinClass_Object_LayerA_LayerB_LayerCValue DeepMixinClass_Object_LayerA_LayerB_LayerC_new(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerA_LayerB_LayerCValue;
  DeepMixinClass_Object_LayerA_LayerB_new(this_);
  return this_;
}

String DeepMixinClass_Object_LayerA_LayerB_LayerC_layer(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerA_LayerB_LayerCValue;
  return LayerC_layer(this_);
}

String DeepMixinClass_Object_LayerA_LayerB_LayerC_onlyC(dynamic this__) {
  final this_ = this__ as DeepMixinClass_Object_LayerA_LayerB_LayerCValue;
  return LayerC_onlyC(this_);
}

String DeepMixinClass_Object_LayerA_LayerB_LayerC_onlyA(dynamic this__) => DeepMixinClass_Object_LayerA_onlyA(this__);

String DeepMixinClass_Object_LayerA_LayerB_LayerC_onlyB(dynamic this__) => DeepMixinClass_Object_LayerA_LayerB_onlyB(this__);

class Box_Object_MappableValue<T extends dynamic> extends VPtr {

  Box_Object_MappableValue() {
    vptr['get_value'] = Box_Object_Mappable_get_value<T>;
    vptr['mapValue'] = Box_Object_Mappable_mapValue<T, dynamic>;
    vptr['describe'] = Box_Object_Mappable_describe<T>;
  }
}

Box_Object_MappableValue<T> Box_Object_Mappable_new<T extends dynamic>(dynamic this__) {
  final this_ = this__ as Box_Object_MappableValue<T>;
  return this_;
}

T Box_Object_Mappable_get_value<T extends dynamic>(dynamic this__) {
  throw UnimplementedError('Box_Object_Mappable_get_value is abstract');
}

R Box_Object_Mappable_mapValue<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as Box_Object_MappableValue<T>;
  return Mappable_mapValue(this_, transform);
}

String Box_Object_Mappable_describe<T extends dynamic>(dynamic this__) {
  final this_ = this__ as Box_Object_MappableValue<T>;
  return Mappable_describe(this_);
}

class Box_Object_Mappable_FilterableValue<T extends dynamic> extends Box_Object_MappableValue<T> {

  Box_Object_Mappable_FilterableValue() {
    vptr['get_value'] = Box_Object_Mappable_Filterable_get_value<T>;
    vptr['test'] = Box_Object_Mappable_Filterable_test<T>;
  }
}

Box_Object_Mappable_FilterableValue<T> Box_Object_Mappable_Filterable_new<T extends dynamic>(dynamic this__) {
  final this_ = this__ as Box_Object_Mappable_FilterableValue<T>;
  Box_Object_Mappable_new(this_);
  return this_;
}

T Box_Object_Mappable_Filterable_get_value<T extends dynamic>(dynamic this__) {
  throw UnimplementedError('Box_Object_Mappable_Filterable_get_value is abstract');
}

bool Box_Object_Mappable_Filterable_test<T extends dynamic>(dynamic this__, TypeFunction1<bool, T> predicate) {
  final this_ = this__ as Box_Object_Mappable_FilterableValue<T>;
  return Filterable_test(this_, predicate);
}

R Box_Object_Mappable_Filterable_mapValue<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> transform) => Box_Object_Mappable_mapValue<T, R>(this__, transform);

String Box_Object_Mappable_Filterable_describe<T extends dynamic>(dynamic this__) => Box_Object_Mappable_describe<T>(this__);

class TaggedResource_Resource_TaggableValue extends ResourceValue {
  late StaticList<String> _tags = StaticList<String>.of([]);

  TaggedResource_Resource_TaggableValue() {
    vptr['tag'] = TaggedResource_Resource_Taggable_tag;
    vptr['get_allTags'] = TaggedResource_Resource_Taggable_get_allTags;
    vptr['hasTag'] = TaggedResource_Resource_Taggable_hasTag;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _tags?.gcMark(flag);
  }
}

TaggedResource_Resource_TaggableValue TaggedResource_Resource_Taggable_new(dynamic this__, String id, String type) {
  final this_ = this__ as TaggedResource_Resource_TaggableValue;
  Resource_new(this_, id, type);
  return this_;
}

void TaggedResource_Resource_Taggable_tag(dynamic this__, String t) {
  final this_ = this__ as TaggedResource_Resource_TaggableValue;
  Taggable_tag(this_, t);
  return;
}

StaticList<String> TaggedResource_Resource_Taggable_get_allTags(dynamic this__) {
  final this_ = this__ as TaggedResource_Resource_TaggableValue;
  return Taggable_get_allTags(this_);
}

bool TaggedResource_Resource_Taggable_hasTag(dynamic this__, String t) {
  final this_ = this__ as TaggedResource_Resource_TaggableValue;
  return Taggable_hasTag(this_, t);
}

dynamic TaggedResource_Resource_Taggable_get_id(dynamic this__) => Resource_get_id(this__);

String TaggedResource_Resource_Taggable_describe(dynamic this__) => Resource_describe(this__);

class Amount_Object_AddableValue extends VPtr {

  Amount_Object_AddableValue() {
    vptr['get_numericValue'] = Amount_Object_Addable_get_numericValue;
    vptr['addValues'] = Amount_Object_Addable_addValues;
    vptr['doubleValue'] = Amount_Object_Addable_doubleValue;
  }
}

Amount_Object_AddableValue Amount_Object_Addable_new(dynamic this__) {
  final this_ = this__ as Amount_Object_AddableValue;
  return this_;
}

int Amount_Object_Addable_get_numericValue(dynamic this__) {
  throw UnimplementedError('Amount_Object_Addable_get_numericValue is abstract');
}

int Amount_Object_Addable_addValues(dynamic this__, int other) {
  final this_ = this__ as Amount_Object_AddableValue;
  return Addable_addValues(this_, other);
}

int Amount_Object_Addable_doubleValue(dynamic this__) {
  final this_ = this__ as Amount_Object_AddableValue;
  return Addable_doubleValue(this_);
}

class Car_Vehicle_Printable2Value extends VehicleValue {

  Car_Vehicle_Printable2Value() {
    vptr['toPrettyString'] = Car_Vehicle_Printable2_toPrettyString;
    vptr['prettyPrint'] = Car_Vehicle_Printable2_prettyPrint;
  }
}

Car_Vehicle_Printable2Value Car_Vehicle_Printable2_new(dynamic this__, String make, int year) {
  final this_ = this__ as Car_Vehicle_Printable2Value;
  Vehicle_new(this_, make, year);
  return this_;
}

String Car_Vehicle_Printable2_toPrettyString(dynamic this__) {
  throw UnimplementedError('Car_Vehicle_Printable2_toPrettyString is abstract');
}

void Car_Vehicle_Printable2_prettyPrint(dynamic this__) {
  final this_ = this__ as Car_Vehicle_Printable2Value;
  Printable2_prettyPrint(this_);
  return;
}

String Car_Vehicle_Printable2_toString(dynamic this__) => Vehicle_toString(this__);

class Segment_Measurable_ScalableValue extends MeasurableValue {

  Segment_Measurable_ScalableValue() {
    vptr['scale'] = Segment_Measurable_Scalable_scale;
    vptr['measureInfo'] = Segment_Measurable_Scalable_measureInfo;
  }
}

Segment_Measurable_ScalableValue Segment_Measurable_Scalable_new(dynamic this__) {
  final this_ = this__ as Segment_Measurable_ScalableValue;
  Measurable_new(this_);
  return this_;
}

double Segment_Measurable_Scalable_scale(dynamic this__, double factor) {
  final this_ = this__ as Segment_Measurable_ScalableValue;
  return Scalable_scale(this_, factor);
}

String Segment_Measurable_Scalable_measureInfo(dynamic this__) {
  final this_ = this__ as Segment_Measurable_ScalableValue;
  return Scalable_measureInfo(this_);
}

double Segment_Measurable_Scalable_measure(dynamic this__) => Measurable_measure(this__);

class MultiMixinEntity_Object_NamedMixinValue extends VPtr {

  MultiMixinEntity_Object_NamedMixinValue() {
    vptr['get_label'] = MultiMixinEntity_Object_NamedMixin_get_label;
    vptr['greet'] = MultiMixinEntity_Object_NamedMixin_greet;
  }
}

MultiMixinEntity_Object_NamedMixinValue MultiMixinEntity_Object_NamedMixin_new(dynamic this__) {
  final this_ = this__ as MultiMixinEntity_Object_NamedMixinValue;
  return this_;
}

String MultiMixinEntity_Object_NamedMixin_get_label(dynamic this__) {
  final this_ = this__ as MultiMixinEntity_Object_NamedMixinValue;
  return NamedMixin_get_label(this_);
}

String MultiMixinEntity_Object_NamedMixin_greet(dynamic this__) {
  final this_ = this__ as MultiMixinEntity_Object_NamedMixinValue;
  return NamedMixin_greet(this_);
}

class MultiMixinEntity_Object_NamedMixin_DescribedMixinValue extends MultiMixinEntity_Object_NamedMixinValue {

  MultiMixinEntity_Object_NamedMixin_DescribedMixinValue() {
    vptr['get_label'] = MultiMixinEntity_Object_NamedMixin_DescribedMixin_get_label;
    vptr['info'] = MultiMixinEntity_Object_NamedMixin_DescribedMixin_info;
  }
}

MultiMixinEntity_Object_NamedMixin_DescribedMixinValue MultiMixinEntity_Object_NamedMixin_DescribedMixin_new(dynamic this__) {
  final this_ = this__ as MultiMixinEntity_Object_NamedMixin_DescribedMixinValue;
  MultiMixinEntity_Object_NamedMixin_new(this_);
  return this_;
}

String MultiMixinEntity_Object_NamedMixin_DescribedMixin_get_label(dynamic this__) {
  final this_ = this__ as MultiMixinEntity_Object_NamedMixin_DescribedMixinValue;
  return DescribedMixin_get_label(this_);
}

String MultiMixinEntity_Object_NamedMixin_DescribedMixin_info(dynamic this__) {
  final this_ = this__ as MultiMixinEntity_Object_NamedMixin_DescribedMixinValue;
  return DescribedMixin_info(this_);
}

String MultiMixinEntity_Object_NamedMixin_DescribedMixin_greet(dynamic this__) => MultiMixinEntity_Object_NamedMixin_greet(this__);

class MultiEncoder_Object_Base64MixinValue extends VPtr {

  MultiEncoder_Object_Base64MixinValue() {
    vptr['encode'] = MultiEncoder_Object_Base64Mixin_encode;
  }
}

MultiEncoder_Object_Base64MixinValue MultiEncoder_Object_Base64Mixin_new(dynamic this__) {
  final this_ = this__ as MultiEncoder_Object_Base64MixinValue;
  return this_;
}

String MultiEncoder_Object_Base64Mixin_encode(dynamic this__, String input) {
  final this_ = this__ as MultiEncoder_Object_Base64MixinValue;
  return Base64Mixin_encode(this_, input);
}

class MultiEncoder_Object_Base64Mixin_HexMixinValue extends MultiEncoder_Object_Base64MixinValue {

  MultiEncoder_Object_Base64Mixin_HexMixinValue() {
    vptr['encode'] = MultiEncoder_Object_Base64Mixin_HexMixin_encode;
  }
}

MultiEncoder_Object_Base64Mixin_HexMixinValue MultiEncoder_Object_Base64Mixin_HexMixin_new(dynamic this__) {
  final this_ = this__ as MultiEncoder_Object_Base64Mixin_HexMixinValue;
  MultiEncoder_Object_Base64Mixin_new(this_);
  return this_;
}

String MultiEncoder_Object_Base64Mixin_HexMixin_encode(dynamic this__, String input) {
  final this_ = this__ as MultiEncoder_Object_Base64Mixin_HexMixinValue;
  return HexMixin_encode(this_, input);
}

class ChainClass_Object_ChainMixinValue extends VPtr {

  ChainClass_Object_ChainMixinValue() {
    vptr['step1'] = ChainClass_Object_ChainMixin_step1;
    vptr['step2'] = ChainClass_Object_ChainMixin_step2;
    vptr['step3'] = ChainClass_Object_ChainMixin_step3;
    vptr['fullChain'] = ChainClass_Object_ChainMixin_fullChain;
  }
}

ChainClass_Object_ChainMixinValue ChainClass_Object_ChainMixin_new(dynamic this__) {
  final this_ = this__ as ChainClass_Object_ChainMixinValue;
  return this_;
}

String ChainClass_Object_ChainMixin_step1(dynamic this__) {
  final this_ = this__ as ChainClass_Object_ChainMixinValue;
  return ChainMixin_step1(this_);
}

String ChainClass_Object_ChainMixin_step2(dynamic this__) {
  final this_ = this__ as ChainClass_Object_ChainMixinValue;
  return ChainMixin_step2(this_);
}

String ChainClass_Object_ChainMixin_step3(dynamic this__) {
  final this_ = this__ as ChainClass_Object_ChainMixinValue;
  return ChainMixin_step3(this_);
}

String ChainClass_Object_ChainMixin_fullChain(dynamic this__) {
  final this_ = this__ as ChainClass_Object_ChainMixinValue;
  return ChainMixin_fullChain(this_);
}

class GameCharacter_Object_HealthMixinValue extends VPtr {

  GameCharacter_Object_HealthMixinValue() {
    vptr['get_maxHealth'] = GameCharacter_Object_HealthMixin_get_maxHealth;
    vptr['get_health'] = GameCharacter_Object_HealthMixin_get_health;
    vptr['healthBar'] = GameCharacter_Object_HealthMixin_healthBar;
  }
}

GameCharacter_Object_HealthMixinValue GameCharacter_Object_HealthMixin_new(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixinValue;
  return this_;
}

int GameCharacter_Object_HealthMixin_get_maxHealth(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixinValue;
  return HealthMixin_get_maxHealth(this_);
}

int GameCharacter_Object_HealthMixin_get_health(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixinValue;
  return HealthMixin_get_health(this_);
}

String GameCharacter_Object_HealthMixin_healthBar(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixinValue;
  return HealthMixin_healthBar(this_);
}

class GameCharacter_Object_HealthMixin_ManaMixinValue extends GameCharacter_Object_HealthMixinValue {

  GameCharacter_Object_HealthMixin_ManaMixinValue() {
    vptr['get_maxMana'] = GameCharacter_Object_HealthMixin_ManaMixin_get_maxMana;
    vptr['get_mana'] = GameCharacter_Object_HealthMixin_ManaMixin_get_mana;
    vptr['manaBar'] = GameCharacter_Object_HealthMixin_ManaMixin_manaBar;
  }
}

GameCharacter_Object_HealthMixin_ManaMixinValue GameCharacter_Object_HealthMixin_ManaMixin_new(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixin_ManaMixinValue;
  GameCharacter_Object_HealthMixin_new(this_);
  return this_;
}

int GameCharacter_Object_HealthMixin_ManaMixin_get_maxMana(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixin_ManaMixinValue;
  return ManaMixin_get_maxMana(this_);
}

int GameCharacter_Object_HealthMixin_ManaMixin_get_mana(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixin_ManaMixinValue;
  return ManaMixin_get_mana(this_);
}

String GameCharacter_Object_HealthMixin_ManaMixin_manaBar(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixin_ManaMixinValue;
  return ManaMixin_manaBar(this_);
}

int GameCharacter_Object_HealthMixin_ManaMixin_get_maxHealth(dynamic this__) => GameCharacter_Object_HealthMixin_get_maxHealth(this__);

int GameCharacter_Object_HealthMixin_ManaMixin_get_health(dynamic this__) => GameCharacter_Object_HealthMixin_get_health(this__);

String GameCharacter_Object_HealthMixin_ManaMixin_healthBar(dynamic this__) => GameCharacter_Object_HealthMixin_healthBar(this__);

class GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue extends GameCharacter_Object_HealthMixin_ManaMixinValue {

  GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue() {
    vptr['get_maxStamina'] = GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_maxStamina;
    vptr['get_stamina'] = GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_stamina;
    vptr['staminaBar'] = GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_staminaBar;
  }
}

GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_new(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue;
  GameCharacter_Object_HealthMixin_ManaMixin_new(this_);
  return this_;
}

int GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_maxStamina(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue;
  return StaminaMixin_get_maxStamina(this_);
}

int GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_stamina(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue;
  return StaminaMixin_get_stamina(this_);
}

String GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_staminaBar(dynamic this__) {
  final this_ = this__ as GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue;
  return StaminaMixin_staminaBar(this_);
}

int GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_maxHealth(dynamic this__) => GameCharacter_Object_HealthMixin_get_maxHealth(this__);

int GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_health(dynamic this__) => GameCharacter_Object_HealthMixin_get_health(this__);

String GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_healthBar(dynamic this__) => GameCharacter_Object_HealthMixin_healthBar(this__);

int GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_maxMana(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_get_maxMana(this__);

int GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_get_mana(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_get_mana(this__);

String GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixin_manaBar(dynamic this__) => GameCharacter_Object_HealthMixin_ManaMixin_manaBar(this__);

void main() {
  staticPrint('=== 复杂 OOP 边界测试 ===\n');
  staticPrint('--- 1. 菱形继承 ---');
  DiamondClassValue diamond = DiamondClass_new(DiamondClassValue(), 'DC');
  staticPrint('prefix: ${(diamond.vptr['get_prefix'] as Function)(diamond)}');
  staticPrint('format: ${(diamond.vptr['format'] as Function)(diamond, 'hello')}');
  staticPrint('display: ${(diamond.vptr['display'] as Function)(diamond, 'world')}');
  staticPrint('\n--- 2. StatefulMixin ---');
  StatefulWidgetValue widget = StatefulWidget_new(StatefulWidgetValue(), 'btn1');
  staticPrint('initial: ${widget}');
  (widget.vptr['increment'] as Function)(widget);
  (widget.vptr['increment'] as Function)(widget);
  (widget.vptr['increment'] as Function)(widget);
  staticPrint('after 3 inc: ${widget}');
  (widget.vptr['decrement'] as Function)(widget);
  staticPrint('after 1 dec: ${widget}');
  (widget.vptr['set_counter'] as Function)(widget, 10);
  staticPrint('after set 10: ${widget}');
  staticPrint('\n--- 3. 深层 mixin 链 ---');
  DeepMixinClassValue deep = DeepMixinClass_new(DeepMixinClassValue());
  staticPrint('layer: ${(deep.vptr['layer'] as Function)(deep)}');
  staticPrint('allLayers: ${(deep.vptr['allLayers'] as Function)(deep)}');
  staticPrint('\n--- 4. 泛型 mixin ---');
  BoxValue<int> intBox = Box_new<int>(BoxValue<int>(), 42);
  staticPrint('intBox: ${intBox}');
  staticPrint('describe: ${(intBox.vptr['describe'] as Function)(intBox)}');
  staticPrint('mapValue: ${(intBox.vptr['mapValue_int'] as Function)(intBox, ClosureEnv_global_2_new(GC.allocateLocal(ClosureEnv_global_2())))}');
  staticPrint('test >10: ${(intBox.vptr['test'] as Function)(intBox, ClosureEnv_global_3_new(GC.allocateLocal(ClosureEnv_global_3())))}');
  staticPrint('test >100: ${(intBox.vptr['test'] as Function)(intBox, ClosureEnv_global_4_new(GC.allocateLocal(ClosureEnv_global_4())))}');
  BoxValue<String> strBox = Box_new<String>(BoxValue<String>(), 'dart');
  staticPrint('strBox mapValue: ${(strBox.vptr['mapValue_String'] as Function)(strBox, ClosureEnv_global_5_new(GC.allocateLocal(ClosureEnv_global_5())))}');
  staticPrint('\n--- 5. 抽象+mixin+implements ---');
  TaggedResourceValue res = TaggedResource_new(TaggedResourceValue(), 'r1', 'file');
  (res.vptr['tag'] as Function)(res, 'important');
  (res.vptr['tag'] as Function)(res, 'v2');
  staticPrint('describe: ${(res.vptr['describe'] as Function)(res)}');
  staticPrint('id: ${res.id}');
  staticPrint('hasTag important: ${(res.vptr['hasTag'] as Function)(res, 'important')}');
  staticPrint('hasTag draft: ${(res.vptr['hasTag'] as Function)(res, 'draft')}');
  staticPrint('\n--- 6. super 调用链 ---');
  BaseProcessorValue base = BaseProcessor_new(BaseProcessorValue());
  staticPrint('base: ${(base.vptr['process'] as Function)(base, '  hello  ')} (${(base.vptr['get_processorName'] as Function)(base)})');
  UpperProcessorValue upper = UpperProcessor_new(UpperProcessorValue());
  staticPrint('upper: ${(upper.vptr['process'] as Function)(upper, '  hello  ')} (${(upper.vptr['get_processorName'] as Function)(upper)})');
  PrefixProcessorValue prefix = PrefixProcessor_new(PrefixProcessorValue(), 'PRE');
  staticPrint('prefix: ${(prefix.vptr['process'] as Function)(prefix, '  hello  ')} (${(prefix.vptr['get_processorName'] as Function)(prefix)})');
  staticPrint('\n--- 7. mixin + operator ---');
  AmountValue a1 = Amount_new(AmountValue(), 10);
  AmountValue a2 = Amount_new(AmountValue(), 5);
  staticPrint('a1 + a2: ${(a1.vptr['operatorPlus'] as Function)(a1, a2)}');
  staticPrint('a1 - a2: ${(a1.vptr['operatorMinus'] as Function)(a1, a2)}');
  staticPrint('a1 < a2: ${(a1.vptr['operatorLt'] as Function)(a1, a2)}');
  staticPrint('a1 > a2: ${(a1.vptr['operatorGt'] as Function)(a1, a2)}');
  staticPrint('doubleValue: ${(a1.vptr['doubleValue'] as Function)(a1)}');
  staticPrint('addValues: ${(a1.vptr['addValues'] as Function)(a1, 3)}');
  staticPrint('\n--- 8. 多层继承+mixin ---');
  CarValue car = Car_new(CarValue(), 'Toyota', 2024, 4);
  staticPrint('car: ${car}');
  (car.vptr['prettyPrint'] as Function)(car);
  ElectricCarValue ev = ElectricCar_new(ElectricCarValue(), 'Tesla', 2025, 4, 500);
  staticPrint('ev: ${ev}');
  (ev.vptr['prettyPrint'] as Function)(ev);
  staticPrint('\n--- 9. mixin on 约束 ---');
  SegmentValue seg = Segment_new(SegmentValue(), 10.0);
  staticPrint('seg: ${seg}');
  staticPrint('scale(2): ${(seg.vptr['scale'] as Function)(seg, 2.0)}');
  WeightedSegmentValue wseg = WeightedSegment_new(WeightedSegmentValue(), 10.0, 0.5);
  staticPrint('wseg: ${wseg}');
  staticPrint('wseg.scale(3): ${(wseg.vptr['scale'] as Function)(wseg, 3.0)}');
  staticPrint('\n--- 10. 多 mixin 同名 getter ---');
  MultiMixinEntityValue entity = MultiMixinEntity_new(MultiMixinEntityValue());
  staticPrint('label: ${(entity.vptr['get_label'] as Function)(entity)}');
  staticPrint('greet: ${(entity.vptr['greet'] as Function)(entity)}');
  staticPrint('info: ${(entity.vptr['info'] as Function)(entity)}');
  staticPrint('fullInfo: ${(entity.vptr['fullInfo'] as Function)(entity)}');
  staticPrint('\n--- 11. 接口+mixin 覆盖 ---');
  MultiEncoderValue multi = MultiEncoder_new(MultiEncoderValue());
  staticPrint('multi.encode: ${(multi.vptr['encode'] as Function)(multi, 'abc')}');
  staticPrint('multi.encodeAll: ${(multi.vptr['encodeAll'] as Function)(multi, 'xyz')}');
  CustomEncoderValue custom = CustomEncoder_new(CustomEncoderValue());
  staticPrint('custom.encode: ${(custom.vptr['encode'] as Function)(custom, 'abc')}');
  staticPrint('custom.encodeAll: ${(custom.vptr['encodeAll'] as Function)(custom, 'xyz')}');
  staticPrint('\n--- 12. 泛型继承链 ---');
  ContainerValue<int> c1 = Container_new<int>(ContainerValue<int>(), 42);
  staticPrint('c1: ${(c1.vptr['describe'] as Function)(c1)}');
  LabeledContainerValue<String> c2 = LabeledContainer_new<String>(LabeledContainerValue<String>(), 'hello', 'greeting');
  staticPrint('c2: ${(c2.vptr['describe'] as Function)(c2)}');
  PriorityContainerValue<double> c3 = PriorityContainer_new<double>(PriorityContainerValue<double>(), 3.14, 'pi', 1);
  staticPrint('c3: ${(c3.vptr['describe'] as Function)(c3)}');
  staticPrint('c3.content: ${(c3.vptr['get_content'] as Function)(c3)}');
  staticPrint('\n--- 13. mixin 调用链 ---');
  ChainClassValue chain1 = ChainClass_new(ChainClassValue());
  staticPrint('chain1.fullChain: ${(chain1.vptr['fullChain'] as Function)(chain1)}');
  staticPrint('chain1.step3: ${(chain1.vptr['step3'] as Function)(chain1)}');
  ChainSubClassValue chain2 = ChainSubClass_new(ChainSubClassValue());
  staticPrint('chain2.fullChain: ${(chain2.vptr['fullChain'] as Function)(chain2)}');
  staticPrint('chain2.step3: ${(chain2.vptr['step3'] as Function)(chain2)}');
  staticPrint('\n--- 14. 表达式树 ---');
  BinaryExprValue expr = BinaryExpr_new_add(NumberExpr_new(NumberExprValue(), 3.0), BinaryExpr_new_mul(NumberExpr_new(NumberExprValue(), 4.0), NumberExpr_new(NumberExprValue(), 5.0)));
  staticPrint('expr: ${(expr.vptr['display'] as Function)(expr)}');
  staticPrint('result: ${(expr.vptr['evaluate'] as Function)(expr)}');
  staticPrint('\n--- 15. 游戏角色 ---');
  GameCharacterValue hero = GameCharacter_new(GameCharacterValue(), 'Hero');
  staticPrint((hero.vptr['statusBars'] as Function)(hero));
  WarriorValue warrior = Warrior_new(WarriorValue(), 'Conan');
  staticPrint((warrior.vptr['statusBars'] as Function)(warrior));
  MageValue mage = Mage_new(MageValue(), 'Gandalf');
  staticPrint((mage.vptr['statusBars'] as Function)(mage));
  staticPrint('\n=== 所有复杂 OOP 测试通过 ✅ ===');
}

class ClosureEnv_global_0 extends TypeFunction2<double, double, double> {

  ClosureEnv_global_0() {
  }
  double call(double a, double b) =>
      ClosureEnv_global_0_call(this, a, b);
}

double ClosureEnv_global_0_call(dynamic env__, double a, double b) {
  final env = env__ as ClosureEnv_global_0;
  return (a + b);
}

ClosureEnv_global_0 ClosureEnv_global_0_new(ClosureEnv_global_0 env_) {
  return env_;
}

class ClosureEnv_global_1 extends TypeFunction2<double, double, double> {

  ClosureEnv_global_1() {
  }
  double call(double a, double b) =>
      ClosureEnv_global_1_call(this, a, b);
}

double ClosureEnv_global_1_call(dynamic env__, double a, double b) {
  final env = env__ as ClosureEnv_global_1;
  return (a * b);
}

ClosureEnv_global_1 ClosureEnv_global_1_new(ClosureEnv_global_1 env_) {
  return env_;
}

class ClosureEnv_global_2 extends TypeFunction1<int, int> {

  ClosureEnv_global_2() {
  }
  int call(int v) =>
      ClosureEnv_global_2_call(this, v);
}

int ClosureEnv_global_2_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_2;
  return (v * 2);
}

ClosureEnv_global_2 ClosureEnv_global_2_new(ClosureEnv_global_2 env_) {
  return env_;
}

class ClosureEnv_global_3 extends TypeFunction1<bool, int> {

  ClosureEnv_global_3() {
  }
  bool call(int v) =>
      ClosureEnv_global_3_call(this, v);
}

bool ClosureEnv_global_3_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_3;
  return (v > 10);
}

ClosureEnv_global_3 ClosureEnv_global_3_new(ClosureEnv_global_3 env_) {
  return env_;
}

class ClosureEnv_global_4 extends TypeFunction1<bool, int> {

  ClosureEnv_global_4() {
  }
  bool call(int v) =>
      ClosureEnv_global_4_call(this, v);
}

bool ClosureEnv_global_4_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_4;
  return (v > 100);
}

ClosureEnv_global_4 ClosureEnv_global_4_new(ClosureEnv_global_4 env_) {
  return env_;
}

class ClosureEnv_global_5 extends TypeFunction1<String, String> {

  ClosureEnv_global_5() {
  }
  String call(String s) =>
      ClosureEnv_global_5_call(this, s);
}

String ClosureEnv_global_5_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_global_5;
  return s.toUpperCase();
}

ClosureEnv_global_5 ClosureEnv_global_5_new(ClosureEnv_global_5 env_) {
  return env_;
}


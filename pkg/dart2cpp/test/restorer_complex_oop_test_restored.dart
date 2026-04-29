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

// mixin Logger → static functions for delegation
String Logger_get_prefix(dynamic this_) {
  return 'LOG';
}

String Logger_format(dynamic this_, String msg) {
  return '[${(this_.vptr['get_prefix'] as Function)(this_)}] ${msg}';
}


// mixin Formatter → static functions for delegation
String Formatter_get_prefix(dynamic this_) {
  return 'FMT';
}

String Formatter_format(dynamic this_, String msg) {
  return '{${(this_.vptr['get_prefix'] as Function)(this_)}: ${msg}}';
}


class DiamondClassValue extends DiamondClass_Object_Logger_FormatterValue {
  late String name;
}

void DiamondClass_new(DiamondClassValue this_, String name) {
  this_.vptr = {
    'get_prefix': DiamondClass_get_prefix,
    'format': DiamondClass_format,
    'display': DiamondClass_display,
  };
  this_.name = name;
}

String DiamondClass_display(DiamondClassValue this_, String msg) {
  return '${this_.name}: ${(this_.vptr['format'] as Function)(this_, msg)}';
}

String DiamondClass_get_prefix(DiamondClassValue this_) {
  return Formatter_get_prefix(this_);
}

String DiamondClass_format(DiamondClassValue this_, String msg) {
  return Formatter_format(this_, msg);
}


// mixin StatefulMixin → static functions for delegation
int StatefulMixin_get_counter(dynamic this_) {
  return this_._counter;
}

void StatefulMixin_set_counter(dynamic this_, int value) {
  this_._counter = value;
}

void StatefulMixin_increment(dynamic this_) {
  this_.counter = ((this_.vptr['get_counter'] as Function)(this_) + 1);
}

void StatefulMixin_decrement(dynamic this_) {
  this_.counter = ((this_.vptr['get_counter'] as Function)(this_) - 1);
}

String StatefulMixin_get_counterStatus(dynamic this_) {
  return 'count=${(this_.vptr['get_counter'] as Function)(this_)}';
}


class StatefulWidgetValue extends StatefulWidget_Object_StatefulMixinValue {
  late String id;
}

void StatefulWidget_new(StatefulWidgetValue this_, String id) {
  this_.vptr = {
    'get_counter': StatefulWidget_get_counter,
    'set_counter': StatefulWidget_set_counter,
    'increment': StatefulWidget_increment,
    'decrement': StatefulWidget_decrement,
    'get_counterStatus': StatefulWidget_get_counterStatus,
    'toString_': StatefulWidget_toString,
  };
  this_.id = id;
  this_._counter = 0;
}

String StatefulWidget_toString(StatefulWidgetValue this_) {
  return 'Widget(${this_.id}, ${(this_.vptr['get_counterStatus'] as String Function(StatefulWidgetValue))(this_)})';
}

int StatefulWidget_get_counter(StatefulWidgetValue this_) {
  return StatefulMixin_get_counter(this_);
}

void StatefulWidget_set_counter(StatefulWidgetValue this_, int value) {
  StatefulMixin_set_counter(this_, value);
}

void StatefulWidget_increment(StatefulWidgetValue this_) {
  StatefulMixin_increment(this_);
}

void StatefulWidget_decrement(StatefulWidgetValue this_) {
  StatefulMixin_decrement(this_);
}

String StatefulWidget_get_counterStatus(StatefulWidgetValue this_) {
  return StatefulMixin_get_counterStatus(this_);
}


// mixin LayerA → static functions for delegation
String LayerA_layer(dynamic this_) {
  return 'A';
}

String LayerA_onlyA(dynamic this_) {
  return 'onlyA';
}


// mixin LayerB → static functions for delegation
String LayerB_layer(dynamic this_) {
  return 'B';
}

String LayerB_onlyB(dynamic this_) {
  return 'onlyB';
}


// mixin LayerC → static functions for delegation
String LayerC_layer(dynamic this_) {
  return 'C';
}

String LayerC_onlyC(dynamic this_) {
  return 'onlyC';
}


class DeepMixinClassValue extends DeepMixinClass_Object_LayerA_LayerB_LayerCValue {
}

void DeepMixinClass_new(DeepMixinClassValue this_) {
  this_.vptr = {
    'layer': DeepMixinClass_layer,
    'onlyA': DeepMixinClass_onlyA,
    'onlyB': DeepMixinClass_onlyB,
    'onlyC': DeepMixinClass_onlyC,
    'allLayers': DeepMixinClass_allLayers,
  };
}

String DeepMixinClass_allLayers(DeepMixinClassValue this_) {
  return '${(this_.vptr['layer'] as Function)(this_)}-${(this_.vptr['onlyA'] as Function)(this_)}-${(this_.vptr['onlyB'] as Function)(this_)}-${(this_.vptr['onlyC'] as Function)(this_)}';
}

String DeepMixinClass_layer(DeepMixinClassValue this_) {
  return LayerC_layer(this_);
}

String DeepMixinClass_onlyA(DeepMixinClassValue this_) {
  return LayerA_onlyA(this_);
}

String DeepMixinClass_onlyB(DeepMixinClassValue this_) {
  return LayerB_onlyB(this_);
}

String DeepMixinClass_onlyC(DeepMixinClassValue this_) {
  return LayerC_onlyC(this_);
}


// mixin Mappable → static functions for delegation
R Mappable_mapValue<T, R>(dynamic this_, R Function(T) transform) {
  return transform((this_.vptr['get_value'] as Function)(this_));
}

String Mappable_describe<T>(dynamic this_) {
  return 'Mappable<${T}>(${(this_.vptr['get_value'] as Function)(this_)})';
}


// mixin Filterable → static functions for delegation
bool Filterable_test<T>(dynamic this_, bool Function(T) predicate) {
  return predicate((this_.vptr['get_value'] as Function)(this_));
}


class BoxValue<T> extends Box_Object_Mappable_FilterableValue<T> {
  late T value;
}

void Box_new<T>(BoxValue<T> this_, T value) {
  this_.vptr = {
    'get_value': (self) => Box_get_value<T>(self),
    'mapValue': (self, _a0) => Box_mapValue(self, _a0),
    'describe': (self) => Box_describe<T>(self),
    'test': (self, _a0) => Box_test<T>(self, _a0),
    'toString_': (self) => Box_toString<T>(self),
  };
  this_.value = value;
}

String Box_toString<T>(BoxValue<T> this_) {
  return 'Box(${this_.value})';
}

T Box_get_value<T>(BoxValue<T> this_) {
  return (this_ as BoxValue).value;
}

R Box_mapValue<T, R>(BoxValue<T> this_, R Function(T) transform) {
  return Mappable_mapValue(this_, transform);
}

String Box_describe<T>(BoxValue<T> this_) {
  return Mappable_describe(this_);
}

bool Box_test<T>(BoxValue<T> this_, bool Function(T) predicate) {
  return Filterable_test(this_, predicate);
}


class IdentifiableValue extends VPtr {
}

void Identifiable_new(IdentifiableValue this_) {
  this_.vptr = {
    'get_id': Identifiable_get_id,
  };
}

String Identifiable_get_id(IdentifiableValue this_) {
  throw UnimplementedError('Identifiable.id is abstract');
}


class DescribableValue extends VPtr {
}

void Describable_new(DescribableValue this_) {
  this_.vptr = {
    'describe': Describable_describe,
  };
}

String Describable_describe(DescribableValue this_) {
  throw UnimplementedError('Describable.describe is abstract');
}


// mixin Taggable → static functions for delegation
void Taggable_tag(dynamic this_, String t) {
  this_._tags.add(t);
}

List<String> Taggable_get_allTags(dynamic this_) {
  return List.unmodifiable(this_._tags);
}

bool Taggable_hasTag(dynamic this_, String t) {
  return this_._tags.contains(t);
}


class ResourceValue extends VPtr {
  late String id;
  late String type;
}

void Resource_new(ResourceValue this_, String id, String type) {
  this_.vptr = {
    'get_id': Resource_get_id,
    'describe': Resource_describe,
  };
  this_.id = id;
  this_.type = type;
}

String Resource_describe(ResourceValue this_) {
  return 'Resource(${this_.id}, type=${this_.type})';
}

dynamic Resource_get_id(ResourceValue this_) {
  throw UnimplementedError('Resource.id delegate missing proc');
}


class TaggedResourceValue extends TaggedResource_Resource_TaggableValue {
}

void TaggedResource_new(TaggedResourceValue this_, String id, String type) {
  Resource_new(this_, id, type);
  this_.vptr = {
    'get_id': TaggedResource_get_id,
    'describe': TaggedResource_describe,
    'tag': TaggedResource_tag,
    'get_allTags': TaggedResource_get_allTags,
    'hasTag': TaggedResource_hasTag,
  };
  this_._tags = <String>[];
}

String TaggedResource_describe(TaggedResourceValue this_) {
  return '${Resource_describe(this_)}, tags=${(this_.vptr['get_allTags'] as List<String> Function(TaggedResourceValue))(this_)}';
}

dynamic TaggedResource_get_id(TaggedResourceValue this_) {
  throw UnimplementedError('TaggedResource.id delegate missing proc');
}

void TaggedResource_tag(TaggedResourceValue this_, String t) {
  Taggable_tag(this_, t);
}

List<String> TaggedResource_get_allTags(TaggedResourceValue this_) {
  return Taggable_get_allTags(this_);
}

bool TaggedResource_hasTag(TaggedResourceValue this_, String t) {
  return Taggable_hasTag(this_, t);
}


class BaseProcessorValue extends VPtr {
}

void BaseProcessor_new(BaseProcessorValue this_) {
  this_.vptr = {
    'process': BaseProcessor_process,
    'get_processorName': BaseProcessor_get_processorName,
  };
}

String BaseProcessor_process(BaseProcessorValue this_, String input) {
  return input.trim();
}

String BaseProcessor_get_processorName(BaseProcessorValue this_) {
  return 'Base';
}


class UpperProcessorValue extends BaseProcessorValue {
}

void UpperProcessor_new(UpperProcessorValue this_) {
  BaseProcessor_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'process': UpperProcessor_process,
    'get_processorName': UpperProcessor_get_processorName,
  };
}

String UpperProcessor_process(BaseProcessorValue this__, String input) {
  final this_ = this__ as UpperProcessorValue;
  return BaseProcessor_process(this_, input).toUpperCase();
}

String UpperProcessor_get_processorName(BaseProcessorValue this__) {
  final this_ = this__ as UpperProcessorValue;
  return '${BaseProcessor_get_processorName(this_)}->Upper';
}


class PrefixProcessorValue extends UpperProcessorValue {
  late String prefix;
}

void PrefixProcessor_new(PrefixProcessorValue this_, String prefix) {
  UpperProcessor_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'process': PrefixProcessor_process,
    'get_processorName': PrefixProcessor_get_processorName,
  };
  this_.prefix = prefix;
}

String PrefixProcessor_process(BaseProcessorValue this__, String input) {
  final this_ = this__ as PrefixProcessorValue;
  return '${this_.prefix}:${UpperProcessor_process(this_, input)}';
}

String PrefixProcessor_get_processorName(BaseProcessorValue this__) {
  final this_ = this__ as PrefixProcessorValue;
  return '${UpperProcessor_get_processorName(this_)}->Prefix(${this_.prefix})';
}


// mixin Addable → static functions for delegation
int Addable_addValues(dynamic this_, int other) {
  return ((this_.vptr['get_numericValue'] as Function)(this_) + other);
}

int Addable_doubleValue(dynamic this_) {
  return (this_.vptr['addValues'] as Function)(this_, (this_.vptr['get_numericValue'] as Function)(this_));
}


class AmountValue extends Amount_Object_AddableValue {
  late int numericValue;
}

void Amount_new(AmountValue this_, int numericValue) {
  this_.vptr = {
    'get_numericValue': Amount_get_numericValue,
    'addValues': Amount_addValues,
    'doubleValue': Amount_doubleValue,
    'operatorPlus': Amount_operatorPlus,
    'operatorMinus': Amount_operatorMinus,
    'operatorLt': Amount_operatorLt,
    'operatorGt': Amount_operatorGt,
    'toString_': Amount_toString,
  };
  this_.numericValue = numericValue;
}

AmountValue Amount_operatorPlus(AmountValue this_, AmountValue other) {
  return (() { final _obj = AmountValue(); Amount_new(_obj, (this_.numericValue + other.numericValue)); return _obj; })();
}

AmountValue Amount_operatorMinus(AmountValue this_, AmountValue other) {
  return (() { final _obj = AmountValue(); Amount_new(_obj, (this_.numericValue - other.numericValue)); return _obj; })();
}

bool Amount_operatorLt(AmountValue this_, AmountValue other) {
  return (this_.numericValue < other.numericValue);
}

bool Amount_operatorGt(AmountValue this_, AmountValue other) {
  return (this_.numericValue > other.numericValue);
}

String Amount_toString(AmountValue this_) {
  return 'Amount(${this_.numericValue})';
}

int Amount_get_numericValue(AmountValue this_) {
  return (this_ as AmountValue).numericValue;
}

int Amount_addValues(AmountValue this_, int other) {
  return Addable_addValues(this_, other);
}

int Amount_doubleValue(AmountValue this_) {
  return Addable_doubleValue(this_);
}


// mixin Printable2 → static functions for delegation
void Printable2_prettyPrint(dynamic this_) {
  print('>> ${(this_.vptr['toPrettyString'] as Function)(this_)}');
}


class VehicleValue extends VPtr {
  late String make;
  late int year;
}

void Vehicle_new(VehicleValue this_, String make, int year) {
  this_.vptr = {
    'toString_': Vehicle_toString,
  };
  this_.make = make;
  this_.year = year;
}

String Vehicle_toString(VehicleValue this_) {
  return 'Vehicle(${this_.make}, ${this_.year})';
}


class CarValue extends Car_Vehicle_Printable2Value {
  late int doors;
}

void Car_new(CarValue this_, String make, int year, int doors) {
  Vehicle_new(this_, make, year);
  this_.vptr = {
    'toString_': Car_toString,
    'toPrettyString': Car_toPrettyString,
    'prettyPrint': Car_prettyPrint,
  };
  this_.doors = doors;
}

String Car_toPrettyString(CarValue this_) {
  return 'Car[${this_.make}, ${this_.year}, ${this_.doors}dr]';
}

String Car_toString(VehicleValue this__) {
  final this_ = this__ as CarValue;
  return 'Car(${this_.make}, ${this_.year}, ${this_.doors}dr)';
}

void Car_prettyPrint(CarValue this_) {
  Printable2_prettyPrint(this_);
}


class ElectricCarValue extends CarValue {
  late int range;
}

void ElectricCar_new(ElectricCarValue this_, String make, int year, int doors, int range) {
  Car_new(this_, make, year, doors);
  this_.vptr = {
    ...this_.vptr,
    'toString_': ElectricCar_toString,
    'toPrettyString': ElectricCar_toPrettyString,
    'prettyPrint': ElectricCar_prettyPrint,
  };
  this_.range = range;
}

String ElectricCar_toPrettyString(ElectricCarValue this_) {
  return '${Car_toPrettyString(this_)}+EV(${this_.range}km)';
}

String ElectricCar_toString(VehicleValue this__) {
  final this_ = this__ as ElectricCarValue;
  return 'ElectricCar(${this_.make}, ${this_.year}, ${this_.doors}dr, ${this_.range}km)';
}

void ElectricCar_prettyPrint(ElectricCarValue this_) {
  Printable2_prettyPrint(this_);
}


class MeasurableValue extends VPtr {
}

void Measurable_new(MeasurableValue this_) {
  this_.vptr = {
    'measure': Measurable_measure,
  };
}

double Measurable_measure(MeasurableValue this_) {
  throw UnimplementedError('Measurable.measure is abstract');
}


// mixin Scalable → static functions for delegation
double Scalable_scale(dynamic this_, double factor) {
  return ((this_.vptr['measure'] as Function)(this_) * factor);
}

String Scalable_measureInfo(dynamic this_) {
  return 'measure=${(this_.vptr['measure'] as Function)(this_).toStringAsFixed(1)}';
}


class SegmentValue extends Segment_Measurable_ScalableValue {
  late double length;
}

void Segment_new(SegmentValue this_, double length) {
  Measurable_new(this_);
  this_.vptr = {
    'measure': Segment_measure,
    'scale': Segment_scale,
    'measureInfo': Segment_measureInfo,
    'toString_': Segment_toString,
  };
  this_.length = length;
}

double Segment_measure(MeasurableValue this__) {
  final this_ = this__ as SegmentValue;
  return this_.length;
}

String Segment_toString(SegmentValue this_) {
  return 'Segment(${this_.length}, ${(this_.vptr['measureInfo'] as Function)(this_)})';
}

double Segment_scale(SegmentValue this_, double factor) {
  return Scalable_scale(this_, factor);
}

String Segment_measureInfo(SegmentValue this_) {
  return Scalable_measureInfo(this_);
}


class WeightedSegmentValue extends SegmentValue {
  late double weight;
}

void WeightedSegment_new(WeightedSegmentValue this_, double length, double weight) {
  Segment_new(this_, length);
  this_.vptr = {
    ...this_.vptr,
    'measure': WeightedSegment_measure,
    'scale': WeightedSegment_scale,
    'measureInfo': WeightedSegment_measureInfo,
    'toString_': WeightedSegment_toString,
  };
  this_.weight = weight;
}

double WeightedSegment_measure(MeasurableValue this__) {
  final this_ = this__ as WeightedSegmentValue;
  return (this_.length * this_.weight);
}

String WeightedSegment_toString(SegmentValue this__) {
  final this_ = this__ as WeightedSegmentValue;
  return 'WeightedSegment(len=${this_.length}, w=${this_.weight}, ${(this_.vptr['measureInfo'] as Function)(this_)})';
}

double WeightedSegment_scale(WeightedSegmentValue this_, double factor) {
  return Scalable_scale(this_, factor);
}

String WeightedSegment_measureInfo(WeightedSegmentValue this_) {
  return Scalable_measureInfo(this_);
}


// mixin NamedMixin → static functions for delegation
String NamedMixin_get_label(dynamic this_) {
  return 'NamedMixin';
}

String NamedMixin_greet(dynamic this_) {
  return 'Hello from ${(this_.vptr['get_label'] as Function)(this_)}';
}


// mixin DescribedMixin → static functions for delegation
String DescribedMixin_get_label(dynamic this_) {
  return 'DescribedMixin';
}

String DescribedMixin_info(dynamic this_) {
  return 'Info: ${(this_.vptr['get_label'] as Function)(this_)}';
}


class MultiMixinEntityValue extends MultiMixinEntity_Object_NamedMixin_DescribedMixinValue {
}

void MultiMixinEntity_new(MultiMixinEntityValue this_) {
  this_.vptr = {
    'get_label': MultiMixinEntity_get_label,
    'greet': MultiMixinEntity_greet,
    'info': MultiMixinEntity_info,
    'fullInfo': MultiMixinEntity_fullInfo,
  };
}

String MultiMixinEntity_get_label(MultiMixinEntityValue this_) {
  return 'Entity';
}

String MultiMixinEntity_fullInfo(MultiMixinEntityValue this_) {
  return '${(this_.vptr['greet'] as Function)(this_)} | ${(this_.vptr['info'] as Function)(this_)}';
}

String MultiMixinEntity_greet(MultiMixinEntityValue this_) {
  return NamedMixin_greet(this_);
}

String MultiMixinEntity_info(MultiMixinEntityValue this_) {
  return DescribedMixin_info(this_);
}


class EncoderValue extends VPtr {
}

void Encoder_new(EncoderValue this_) {
  this_.vptr = {
    'encode': Encoder_encode,
  };
}

String Encoder_encode(EncoderValue this_, String input) {
  throw UnimplementedError('Encoder.encode is abstract');
}


// mixin Base64Mixin → static functions for delegation
String Base64Mixin_encode(dynamic this_, String input) {
  return 'base64(${input})';
}


// mixin HexMixin → static functions for delegation
String HexMixin_encode(dynamic this_, String input) {
  return 'hex(${input})';
}


class MultiEncoderValue extends MultiEncoder_Object_Base64Mixin_HexMixinValue {
}

void MultiEncoder_new(MultiEncoderValue this_) {
  this_.vptr = {
    'encode': MultiEncoder_encode,
    'encodeAll': MultiEncoder_encodeAll,
  };
}

String MultiEncoder_encodeAll(MultiEncoderValue this_, String input) {
  return (this_.vptr['encode'] as Function)(this_, input);
}

String MultiEncoder_encode(MultiEncoderValue this_, String input) {
  return HexMixin_encode(this_, input);
}


class CustomEncoderValue extends MultiEncoderValue {
}

void CustomEncoder_new(CustomEncoderValue this_) {
  MultiEncoder_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'encode': CustomEncoder_encode,
    'encodeAll': CustomEncoder_encodeAll,
  };
}

String CustomEncoder_encode(CustomEncoderValue this_, String input) {
  return 'custom(${MultiEncoder_encode(this_, input)})';
}

String CustomEncoder_encodeAll(MultiEncoderValue this_, String input) {
  return MultiEncoder_encodeAll(this_, input);
}


class ContainerValue<T> extends VPtr {
  late T item;
}

void Container_new<T>(ContainerValue<T> this_, T item) {
  this_.vptr = {
    'describe': (self) => Container_describe<T>(self),
    'get_content': (self) => Container_get_content<T>(self),
  };
  this_.item = item;
}

String Container_describe<T>(ContainerValue<T> this_) {
  return 'Container<${T}>(${this_.item})';
}

T Container_get_content<T>(ContainerValue<T> this_) {
  return this_.item;
}


class LabeledContainerValue<T> extends ContainerValue<T> {
  late String label;
}

void LabeledContainer_new<T>(LabeledContainerValue<T> this_, T item, String label) {
  Container_new(this_, item);
  this_.vptr = {
    ...this_.vptr,
    'describe': (self) => LabeledContainer_describe<T>(self),
    'get_content': (self) => LabeledContainer_get_content<T>(self),
  };
  this_.label = label;
}

String LabeledContainer_describe<T>(ContainerValue<T> this__) {
  final this_ = this__ as LabeledContainerValue<T>;
  return 'Labeled[${this_.label}]: ${Container_describe(this_)}';
}

T LabeledContainer_get_content<T>(ContainerValue<T> this_) {
  return Container_get_content(this_);
}


class PriorityContainerValue<T> extends LabeledContainerValue<T> {
  late int priority;
}

void PriorityContainer_new<T>(PriorityContainerValue<T> this_, T item, String label, int priority) {
  LabeledContainer_new(this_, item, label);
  this_.vptr = {
    ...this_.vptr,
    'describe': (self) => PriorityContainer_describe<T>(self),
    'get_content': (self) => PriorityContainer_get_content<T>(self),
  };
  this_.priority = priority;
}

String PriorityContainer_describe<T>(ContainerValue<T> this__) {
  final this_ = this__ as PriorityContainerValue<T>;
  return '(P${this_.priority}) ${LabeledContainer_describe(this_)}';
}

T PriorityContainer_get_content<T>(ContainerValue<T> this_) {
  return Container_get_content(this_);
}


// mixin ChainMixin → static functions for delegation
String ChainMixin_step1(dynamic this_) {
  return 'S1';
}

String ChainMixin_step2(dynamic this_) {
  return '${(this_.vptr['step1'] as Function)(this_)}->S2';
}

String ChainMixin_step3(dynamic this_) {
  return '${(this_.vptr['step2'] as Function)(this_)}->S3';
}

String ChainMixin_fullChain(dynamic this_) {
  return '${(this_.vptr['step3'] as Function)(this_)}->done';
}


class ChainClassValue extends ChainClass_Object_ChainMixinValue {
}

void ChainClass_new(ChainClassValue this_) {
  this_.vptr = {
    'step1': ChainClass_step1,
    'step2': ChainClass_step2,
    'step3': ChainClass_step3,
    'fullChain': ChainClass_fullChain,
  };
}

String ChainClass_step1(ChainClassValue this_) {
  return 'X1';
}

String ChainClass_step2(ChainClassValue this_) {
  return ChainMixin_step2(this_);
}

String ChainClass_step3(ChainClassValue this_) {
  return ChainMixin_step3(this_);
}

String ChainClass_fullChain(ChainClassValue this_) {
  return ChainMixin_fullChain(this_);
}


class ChainSubClassValue extends ChainClassValue {
}

void ChainSubClass_new(ChainSubClassValue this_) {
  ChainClass_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'step1': ChainSubClass_step1,
    'step2': ChainSubClass_step2,
    'step3': ChainSubClass_step3,
    'fullChain': ChainSubClass_fullChain,
  };
}

String ChainSubClass_step2(ChainSubClassValue this_) {
  return '${(this_.vptr['step1'] as Function)(this_)}->Y2';
}

String ChainSubClass_step1(ChainSubClassValue this_) {
  return ChainClass_step1(this_);
}

String ChainSubClass_step3(ChainSubClassValue this_) {
  return ChainMixin_step3(this_);
}

String ChainSubClass_fullChain(ChainSubClassValue this_) {
  return ChainMixin_fullChain(this_);
}


class Expression2Value extends VPtr {
}

void Expression2_new(Expression2Value this_) {
  this_.vptr = {
    'evaluate': Expression2_evaluate,
    'display': Expression2_display,
  };
}

double Expression2_evaluate(Expression2Value this_) {
  throw UnimplementedError('Expression2.evaluate is abstract');
}

String Expression2_display(Expression2Value this_) {
  throw UnimplementedError('Expression2.display is abstract');
}


class NumberExprValue extends Expression2Value {
  late double value;
}

void NumberExpr_new(NumberExprValue this_, double value) {
  Expression2_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'evaluate': NumberExpr_evaluate,
    'display': NumberExpr_display,
  };
  this_.value = value;
}

double NumberExpr_evaluate(Expression2Value this__) {
  final this_ = this__ as NumberExprValue;
  return this_.value;
}

String NumberExpr_display(Expression2Value this__) {
  final this_ = this__ as NumberExprValue;
  return ((this_.value == this_.value.toInt()) ? '${this_.value.toInt()}' : '${this_.value}');
}


class BinaryExprValue extends Expression2Value {
  late Expression2Value left;
  late Expression2Value right;
  late String op;
  late double Function(double, double) _compute;
}

void BinaryExpr_new(BinaryExprValue this_, Expression2Value left, Expression2Value right, String op, double Function(double, double) _compute) {
  Expression2_new(this_);
  this_.vptr = {
    ...this_.vptr,
    'evaluate': BinaryExpr_evaluate,
    'display': BinaryExpr_display,
  };
  this_.left = left;
  this_.right = right;
  this_.op = op;
  this_._compute = _compute;
}

BinaryExprValue BinaryExpr_new_add(Expression2Value l, Expression2Value r) {
  return (() { final _obj = BinaryExprValue(); BinaryExpr_new(_obj, l, r, '+', (double a, double b) => (a + b)); return _obj; })();
}

BinaryExprValue BinaryExpr_new_mul(Expression2Value l, Expression2Value r) {
  return (() { final _obj = BinaryExprValue(); BinaryExpr_new(_obj, l, r, '*', (double a, double b) => (a * b)); return _obj; })();
}

double BinaryExpr_evaluate(Expression2Value this__) {
  final this_ = this__ as BinaryExprValue;
  return (() { final _let0 = (this_.left.vptr['evaluate'] as double Function(Expression2Value))(this_.left); return (() { final _let1 = (this_.right.vptr['evaluate'] as double Function(Expression2Value))(this_.right); return this_._compute(_let0, _let1); })(); })();
}

String BinaryExpr_display(Expression2Value this__) {
  final this_ = this__ as BinaryExprValue;
  return '(${(this_.left.vptr['display'] as String Function(Expression2Value))(this_.left)} ${this_.op} ${(this_.right.vptr['display'] as String Function(Expression2Value))(this_.right)})';
}


// mixin HealthMixin → static functions for delegation
int HealthMixin_get_maxHealth(dynamic this_) {
  return 100;
}

int HealthMixin_get_health(dynamic this_) {
  return (this_.vptr['get_maxHealth'] as Function)(this_);
}

String HealthMixin_healthBar(dynamic this_) {
  return 'HP:${(this_.vptr['get_health'] as Function)(this_)}/${(this_.vptr['get_maxHealth'] as Function)(this_)}';
}


// mixin ManaMixin → static functions for delegation
int ManaMixin_get_maxMana(dynamic this_) {
  return 50;
}

int ManaMixin_get_mana(dynamic this_) {
  return (this_.vptr['get_maxMana'] as Function)(this_);
}

String ManaMixin_manaBar(dynamic this_) {
  return 'MP:${(this_.vptr['get_mana'] as Function)(this_)}/${(this_.vptr['get_maxMana'] as Function)(this_)}';
}


// mixin StaminaMixin → static functions for delegation
int StaminaMixin_get_maxStamina(dynamic this_) {
  return 80;
}

int StaminaMixin_get_stamina(dynamic this_) {
  return (this_.vptr['get_maxStamina'] as Function)(this_);
}

String StaminaMixin_staminaBar(dynamic this_) {
  return 'SP:${(this_.vptr['get_stamina'] as Function)(this_)}/${(this_.vptr['get_maxStamina'] as Function)(this_)}';
}


class GameCharacterValue extends GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue {
  late String name;
}

void GameCharacter_new(GameCharacterValue this_, String name) {
  this_.vptr = {
    'get_maxHealth': GameCharacter_get_maxHealth,
    'get_health': GameCharacter_get_health,
    'healthBar': GameCharacter_healthBar,
    'get_maxMana': GameCharacter_get_maxMana,
    'get_mana': GameCharacter_get_mana,
    'manaBar': GameCharacter_manaBar,
    'get_maxStamina': GameCharacter_get_maxStamina,
    'get_stamina': GameCharacter_get_stamina,
    'staminaBar': GameCharacter_staminaBar,
    'statusBars': GameCharacter_statusBars,
  };
  this_.name = name;
}

String GameCharacter_statusBars(GameCharacterValue this_) {
  return '${this_.name}: ${(this_.vptr['healthBar'] as Function)(this_)} ${(this_.vptr['manaBar'] as Function)(this_)} ${(this_.vptr['staminaBar'] as Function)(this_)}';
}

int GameCharacter_get_maxHealth(GameCharacterValue this_) {
  return HealthMixin_get_maxHealth(this_);
}

int GameCharacter_get_health(GameCharacterValue this_) {
  return HealthMixin_get_health(this_);
}

String GameCharacter_healthBar(GameCharacterValue this_) {
  return HealthMixin_healthBar(this_);
}

int GameCharacter_get_maxMana(GameCharacterValue this_) {
  return ManaMixin_get_maxMana(this_);
}

int GameCharacter_get_mana(GameCharacterValue this_) {
  return ManaMixin_get_mana(this_);
}

String GameCharacter_manaBar(GameCharacterValue this_) {
  return ManaMixin_manaBar(this_);
}

int GameCharacter_get_maxStamina(GameCharacterValue this_) {
  return StaminaMixin_get_maxStamina(this_);
}

int GameCharacter_get_stamina(GameCharacterValue this_) {
  return StaminaMixin_get_stamina(this_);
}

String GameCharacter_staminaBar(GameCharacterValue this_) {
  return StaminaMixin_staminaBar(this_);
}


class WarriorValue extends GameCharacterValue {
}

void Warrior_new(WarriorValue this_, String name) {
  GameCharacter_new(this_, name);
  this_.vptr = {
    ...this_.vptr,
    'get_maxHealth': Warrior_get_maxHealth,
    'get_health': Warrior_get_health,
    'healthBar': Warrior_healthBar,
    'get_maxMana': Warrior_get_maxMana,
    'get_mana': Warrior_get_mana,
    'manaBar': Warrior_manaBar,
    'get_maxStamina': Warrior_get_maxStamina,
    'get_stamina': Warrior_get_stamina,
    'staminaBar': Warrior_staminaBar,
    'statusBars': Warrior_statusBars,
  };
}

int Warrior_get_maxHealth(WarriorValue this_) {
  return 150;
}

int Warrior_get_maxStamina(WarriorValue this_) {
  return 120;
}

int Warrior_get_health(WarriorValue this_) {
  return HealthMixin_get_health(this_);
}

String Warrior_healthBar(WarriorValue this_) {
  return HealthMixin_healthBar(this_);
}

int Warrior_get_maxMana(WarriorValue this_) {
  return ManaMixin_get_maxMana(this_);
}

int Warrior_get_mana(WarriorValue this_) {
  return ManaMixin_get_mana(this_);
}

String Warrior_manaBar(WarriorValue this_) {
  return ManaMixin_manaBar(this_);
}

int Warrior_get_stamina(WarriorValue this_) {
  return StaminaMixin_get_stamina(this_);
}

String Warrior_staminaBar(WarriorValue this_) {
  return StaminaMixin_staminaBar(this_);
}

String Warrior_statusBars(GameCharacterValue this_) {
  return GameCharacter_statusBars(this_);
}


class MageValue extends GameCharacterValue {
}

void Mage_new(MageValue this_, String name) {
  GameCharacter_new(this_, name);
  this_.vptr = {
    ...this_.vptr,
    'get_maxHealth': Mage_get_maxHealth,
    'get_health': Mage_get_health,
    'healthBar': Mage_healthBar,
    'get_maxMana': Mage_get_maxMana,
    'get_mana': Mage_get_mana,
    'manaBar': Mage_manaBar,
    'get_maxStamina': Mage_get_maxStamina,
    'get_stamina': Mage_get_stamina,
    'staminaBar': Mage_staminaBar,
    'statusBars': Mage_statusBars,
  };
}

int Mage_get_maxMana(MageValue this_) {
  return 200;
}

int Mage_get_maxHealth(MageValue this_) {
  return 60;
}

int Mage_get_health(MageValue this_) {
  return HealthMixin_get_health(this_);
}

String Mage_healthBar(MageValue this_) {
  return HealthMixin_healthBar(this_);
}

int Mage_get_mana(MageValue this_) {
  return ManaMixin_get_mana(this_);
}

String Mage_manaBar(MageValue this_) {
  return ManaMixin_manaBar(this_);
}

int Mage_get_maxStamina(MageValue this_) {
  return StaminaMixin_get_maxStamina(this_);
}

int Mage_get_stamina(MageValue this_) {
  return StaminaMixin_get_stamina(this_);
}

String Mage_staminaBar(MageValue this_) {
  return StaminaMixin_staminaBar(this_);
}

String Mage_statusBars(GameCharacterValue this_) {
  return GameCharacter_statusBars(this_);
}


class DiamondClass_Object_LoggerValue extends VPtr {
}


class DiamondClass_Object_Logger_FormatterValue extends DiamondClass_Object_LoggerValue {
}


class StatefulWidget_Object_StatefulMixinValue extends VPtr {
  late int _counter;
}


class DeepMixinClass_Object_LayerAValue extends VPtr {
}


class DeepMixinClass_Object_LayerA_LayerBValue extends DeepMixinClass_Object_LayerAValue {
}


class DeepMixinClass_Object_LayerA_LayerB_LayerCValue extends DeepMixinClass_Object_LayerA_LayerBValue {
}


class Box_Object_MappableValue<T> extends VPtr {
}


class Box_Object_Mappable_FilterableValue<T> extends Box_Object_MappableValue<T> {
}


class TaggedResource_Resource_TaggableValue extends ResourceValue {
  late List<String> _tags;
}


class Amount_Object_AddableValue extends VPtr {
}


class Car_Vehicle_Printable2Value extends VehicleValue {
}


class Segment_Measurable_ScalableValue extends MeasurableValue {
}


class MultiMixinEntity_Object_NamedMixinValue extends VPtr {
}


class MultiMixinEntity_Object_NamedMixin_DescribedMixinValue extends MultiMixinEntity_Object_NamedMixinValue {
}


class MultiEncoder_Object_Base64MixinValue extends VPtr {
}


class MultiEncoder_Object_Base64Mixin_HexMixinValue extends MultiEncoder_Object_Base64MixinValue {
}


class ChainClass_Object_ChainMixinValue extends VPtr {
}


class GameCharacter_Object_HealthMixinValue extends VPtr {
}


class GameCharacter_Object_HealthMixin_ManaMixinValue extends GameCharacter_Object_HealthMixinValue {
}


class GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue extends GameCharacter_Object_HealthMixin_ManaMixinValue {
}


void main() {
  print('=== 复杂 OOP 边界测试 ===\n');
  print('--- 1. 菱形继承 ---');
  final DiamondClassValue diamond = (() { final _obj = DiamondClassValue(); DiamondClass_new(_obj, 'DC'); return _obj; })();
  print('prefix: ${(diamond.vptr['get_prefix'] as String Function(DiamondClassValue))(diamond)}');
  print('format: ${(diamond.vptr['format'] as Function)(diamond, 'hello')}');
  print('display: ${(diamond.vptr['display'] as String Function(DiamondClassValue, String))(diamond, 'world')}');
  print('\n--- 2. StatefulMixin ---');
  final StatefulWidgetValue widget = (() { final _obj = StatefulWidgetValue(); StatefulWidget_new(_obj, 'btn1'); return _obj; })();
  print('initial: ${widget}');
  (widget.vptr['increment'] as Function)(widget);
  (widget.vptr['increment'] as Function)(widget);
  (widget.vptr['increment'] as Function)(widget);
  print('after 3 inc: ${widget}');
  (widget.vptr['decrement'] as Function)(widget);
  print('after 1 dec: ${widget}');
  (widget.vptr['set_counter'] as void Function(StatefulWidgetValue, int))(widget, 10);
  print('after set 10: ${widget}');
  print('\n--- 3. 深层 mixin 链 ---');
  final DeepMixinClassValue deep = (() { final _obj = DeepMixinClassValue(); DeepMixinClass_new(_obj); return _obj; })();
  print('layer: ${(deep.vptr['layer'] as Function)(deep)}');
  print('allLayers: ${(deep.vptr['allLayers'] as String Function(DeepMixinClassValue))(deep)}');
  print('\n--- 4. 泛型 mixin ---');
  final BoxValue<int> intBox = (() { final _obj = BoxValue<int>(); Box_new(_obj, 42); return _obj; })();
  print('intBox: ${intBox}');
  print('describe: ${(intBox.vptr['describe'] as Function)(intBox)}');
  print('mapValue: ${Box_mapValue<int, int>(intBox, (int v) => (v * 2))}');
  print('test >10: ${(intBox.vptr['test'] as Function)(intBox, (int v) => (v > 10))}');
  print('test >100: ${(intBox.vptr['test'] as Function)(intBox, (int v) => (v > 100))}');
  final BoxValue<String> strBox = (() { final _obj = BoxValue<String>(); Box_new(_obj, 'dart'); return _obj; })();
  print('strBox mapValue: ${Box_mapValue<String, String>(strBox, (String s) => s.toUpperCase())}');
  print('\n--- 5. 抽象+mixin+implements ---');
  final TaggedResourceValue res = (() { final _obj = TaggedResourceValue(); TaggedResource_new(_obj, 'r1', 'file'); return _obj; })();
  (res.vptr['tag'] as Function)(res, 'important');
  (res.vptr['tag'] as Function)(res, 'v2');
  print('describe: ${(res.vptr['describe'] as String Function(TaggedResourceValue))(res)}');
  print('id: ${res.id}');
  print('hasTag important: ${(res.vptr['hasTag'] as Function)(res, 'important')}');
  print('hasTag draft: ${(res.vptr['hasTag'] as Function)(res, 'draft')}');
  print('\n--- 6. super 调用链 ---');
  final BaseProcessorValue base = (() { final _obj = BaseProcessorValue(); BaseProcessor_new(_obj); return _obj; })();
  print('base: ${(base.vptr['process'] as String Function(BaseProcessorValue, String))(base, '  hello  ')} (${(base.vptr['get_processorName'] as String Function(BaseProcessorValue))(base)})');
  final UpperProcessorValue upper = (() { final _obj = UpperProcessorValue(); UpperProcessor_new(_obj); return _obj; })();
  print('upper: ${(upper.vptr['process'] as String Function(UpperProcessorValue, String))(upper, '  hello  ')} (${(upper.vptr['get_processorName'] as String Function(UpperProcessorValue))(upper)})');
  final PrefixProcessorValue prefix = (() { final _obj = PrefixProcessorValue(); PrefixProcessor_new(_obj, 'PRE'); return _obj; })();
  print('prefix: ${(prefix.vptr['process'] as String Function(PrefixProcessorValue, String))(prefix, '  hello  ')} (${(prefix.vptr['get_processorName'] as String Function(PrefixProcessorValue))(prefix)})');
  print('\n--- 7. mixin + operator ---');
  final AmountValue a1 = (() { final _obj = AmountValue(); Amount_new(_obj, 10); return _obj; })();
  final AmountValue a2 = (() { final _obj = AmountValue(); Amount_new(_obj, 5); return _obj; })();
  print('a1 + a2: ${(a1.vptr['operatorPlus'] as AmountValue Function(AmountValue, AmountValue))(a1, a2)}');
  print('a1 - a2: ${(a1.vptr['operatorMinus'] as AmountValue Function(AmountValue, AmountValue))(a1, a2)}');
  print('a1 < a2: ${(a1.vptr['operatorLt'] as bool Function(AmountValue, AmountValue))(a1, a2)}');
  print('a1 > a2: ${(a1.vptr['operatorGt'] as bool Function(AmountValue, AmountValue))(a1, a2)}');
  print('doubleValue: ${(a1.vptr['doubleValue'] as Function)(a1)}');
  print('addValues: ${(a1.vptr['addValues'] as Function)(a1, 3)}');
  print('\n--- 8. 多层继承+mixin ---');
  final CarValue car = (() { final _obj = CarValue(); Car_new(_obj, 'Toyota', 2024, 4); return _obj; })();
  print('car: ${car}');
  (car.vptr['prettyPrint'] as Function)(car);
  final ElectricCarValue ev = (() { final _obj = ElectricCarValue(); ElectricCar_new(_obj, 'Tesla', 2025, 4, 500); return _obj; })();
  print('ev: ${ev}');
  (ev.vptr['prettyPrint'] as Function)(ev);
  print('\n--- 9. mixin on 约束 ---');
  final SegmentValue seg = (() { final _obj = SegmentValue(); Segment_new(_obj, 10.0); return _obj; })();
  print('seg: ${seg}');
  print('scale(2): ${(seg.vptr['scale'] as Function)(seg, 2.0)}');
  final WeightedSegmentValue wseg = (() { final _obj = WeightedSegmentValue(); WeightedSegment_new(_obj, 10.0, 0.5); return _obj; })();
  print('wseg: ${wseg}');
  print('wseg.scale(3): ${(wseg.vptr['scale'] as Function)(wseg, 3.0)}');
  print('\n--- 10. 多 mixin 同名 getter ---');
  final MultiMixinEntityValue entity = (() { final _obj = MultiMixinEntityValue(); MultiMixinEntity_new(_obj); return _obj; })();
  print('label: ${(entity.vptr['get_label'] as String Function(MultiMixinEntityValue))(entity)}');
  print('greet: ${(entity.vptr['greet'] as Function)(entity)}');
  print('info: ${(entity.vptr['info'] as Function)(entity)}');
  print('fullInfo: ${(entity.vptr['fullInfo'] as String Function(MultiMixinEntityValue))(entity)}');
  print('\n--- 11. 接口+mixin 覆盖 ---');
  final MultiEncoderValue multi = (() { final _obj = MultiEncoderValue(); MultiEncoder_new(_obj); return _obj; })();
  print('multi.encode: ${(multi.vptr['encode'] as Function)(multi, 'abc')}');
  print('multi.encodeAll: ${(multi.vptr['encodeAll'] as String Function(MultiEncoderValue, String))(multi, 'xyz')}');
  final CustomEncoderValue custom = (() { final _obj = CustomEncoderValue(); CustomEncoder_new(_obj); return _obj; })();
  print('custom.encode: ${(custom.vptr['encode'] as String Function(CustomEncoderValue, String))(custom, 'abc')}');
  print('custom.encodeAll: ${(custom.vptr['encodeAll'] as Function)(custom, 'xyz')}');
  print('\n--- 12. 泛型继承链 ---');
  final ContainerValue<int> c1 = (() { final _obj = ContainerValue<int>(); Container_new(_obj, 42); return _obj; })();
  print('c1: ${(c1.vptr['describe'] as Function)(c1)}');
  final LabeledContainerValue<String> c2 = (() { final _obj = LabeledContainerValue<String>(); LabeledContainer_new(_obj, 'hello', 'greeting'); return _obj; })();
  print('c2: ${(c2.vptr['describe'] as Function)(c2)}');
  final PriorityContainerValue<double> c3 = (() { final _obj = PriorityContainerValue<double>(); PriorityContainer_new(_obj, 3.14, 'pi', 1); return _obj; })();
  print('c3: ${(c3.vptr['describe'] as Function)(c3)}');
  print('c3.content: ${(c3.vptr['get_content'] as dynamic Function(dynamic))(c3)}');
  print('\n--- 13. mixin 调用链 ---');
  final ChainClassValue chain1 = (() { final _obj = ChainClassValue(); ChainClass_new(_obj); return _obj; })();
  print('chain1.fullChain: ${(chain1.vptr['fullChain'] as Function)(chain1)}');
  print('chain1.step3: ${(chain1.vptr['step3'] as Function)(chain1)}');
  final ChainSubClassValue chain2 = (() { final _obj = ChainSubClassValue(); ChainSubClass_new(_obj); return _obj; })();
  print('chain2.fullChain: ${(chain2.vptr['fullChain'] as Function)(chain2)}');
  print('chain2.step3: ${(chain2.vptr['step3'] as Function)(chain2)}');
  print('\n--- 14. 表达式树 ---');
  final BinaryExprValue expr = BinaryExpr_new_add((() { final _obj = NumberExprValue(); NumberExpr_new(_obj, 3.0); return _obj; })(), BinaryExpr_new_mul((() { final _obj = NumberExprValue(); NumberExpr_new(_obj, 4.0); return _obj; })(), (() { final _obj = NumberExprValue(); NumberExpr_new(_obj, 5.0); return _obj; })()));
  print('expr: ${(expr.vptr['display'] as String Function(BinaryExprValue))(expr)}');
  print('result: ${(expr.vptr['evaluate'] as double Function(BinaryExprValue))(expr)}');
  print('\n--- 15. 游戏角色 ---');
  final GameCharacterValue hero = (() { final _obj = GameCharacterValue(); GameCharacter_new(_obj, 'Hero'); return _obj; })();
  print((hero.vptr['statusBars'] as String Function(GameCharacterValue))(hero));
  final WarriorValue warrior = (() { final _obj = WarriorValue(); Warrior_new(_obj, 'Conan'); return _obj; })();
  print((warrior.vptr['statusBars'] as Function)(warrior));
  final MageValue mage = (() { final _obj = MageValue(); Mage_new(_obj, 'Gandalf'); return _obj; })();
  print((mage.vptr['statusBars'] as Function)(mage));
  print('\n=== 所有复杂 OOP 测试通过 ✅ ===');
}


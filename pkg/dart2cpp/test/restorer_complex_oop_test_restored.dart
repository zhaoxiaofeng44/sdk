import 'package:dart2cpp/platform/dart/runtime_classes.dart';

// mixin Logger → static functions for delegation
String Logger_get_prefix(AnyGC this__) {
  final dynamic this_ = this__;
  return 'LOG';
}

String Logger_format(AnyGC this__, String msg) {
  final dynamic this_ = this__;
  return '[${(this_.classInfo as dynamic).get_prefix!(this_)}] ${msg}';
}


// mixin Formatter → static functions for delegation
String Formatter_get_prefix(AnyGC this__) {
  final dynamic this_ = this__;
  return 'FMT';
}

String Formatter_format(AnyGC this__, String msg) {
  final dynamic this_ = this__;
  return '{${(this_.classInfo as dynamic).get_prefix!(this_)}: ${msg}}';
}


class DiamondClassClassInfo extends DiamondClass_Object_Logger_FormatterClassInfo {
  Function? display;
}

class DiamondClassValue extends DiamondClass_Object_Logger_FormatterValue {
  late String name;
  static DiamondClassClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DiamondClassClassInfo _initClassInfo() {
    final ci = DiamondClassClassInfo();
    ci.get_prefix = DiamondClass_get_prefix;
    ci.format = DiamondClass_format;
    ci.display = DiamondClass_display;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DiamondClassValue DiamondClass_new(AnyGC this__, String name) {
  final this_ = this__ as DiamondClassValue;
  this_.name = name;
  return this_;
}

String DiamondClass_display(AnyGC this__, String msg) {
  final this_ = this__ as DiamondClassValue;
  return '${this_.name}: ${(this_.classInfo as DiamondClassClassInfo).format!(this_, msg)}';
}

String DiamondClass_get_prefix(AnyGC this__) {
  final this_ = this__ as DiamondClassValue;
  return Formatter_get_prefix(this_);
}

String DiamondClass_format(AnyGC this__, String msg) {
  final this_ = this__ as DiamondClassValue;
  return Formatter_format(this_, msg);
}


// mixin StatefulMixin → static functions for delegation
int StatefulMixin_get_counter(AnyGC this__) {
  final dynamic this_ = this__;
  return this_._counter;
}

void StatefulMixin_set_counter(AnyGC this__, int value) {
  final dynamic this_ = this__;
  this_._counter = value;
}

void StatefulMixin_increment(AnyGC this__) {
  final dynamic this_ = this__;
  (this_.classInfo as dynamic).set_counter!(this_, ((this_.classInfo as dynamic).get_counter!(this_) + 1));
}

void StatefulMixin_decrement(AnyGC this__) {
  final dynamic this_ = this__;
  (this_.classInfo as dynamic).set_counter!(this_, ((this_.classInfo as dynamic).get_counter!(this_) - 1));
}

String StatefulMixin_get_counterStatus(AnyGC this__) {
  final dynamic this_ = this__;
  return 'count=${(this_.classInfo as dynamic).get_counter!(this_)}';
}


class StatefulWidgetClassInfo extends StatefulWidget_Object_StatefulMixinClassInfo {
}

class StatefulWidgetValue extends StatefulWidget_Object_StatefulMixinValue {
  late String id;
  static StatefulWidgetClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static StatefulWidgetClassInfo _initClassInfo() {
    final ci = StatefulWidgetClassInfo();
    ci.get_counter = StatefulWidget_get_counter;
    ci.increment = StatefulWidget_increment;
    ci.decrement = StatefulWidget_decrement;
    ci.get_counterStatus = StatefulWidget_get_counterStatus;
    ci.set_counter = StatefulWidget_set_counter;
    ci.toString_ = StatefulWidget_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

StatefulWidgetValue StatefulWidget_new(AnyGC this__, String id) {
  final this_ = this__ as StatefulWidgetValue;
  this_.id = id;
  return this_;
}

String StatefulWidget_toString(AnyGC this__) {
  final this_ = this__ as StatefulWidgetValue;
  return 'Widget(${this_.id}, ${(this_.classInfo as StatefulWidgetClassInfo).get_counterStatus!(this_)})';
}

int StatefulWidget_get_counter(AnyGC this__) {
  final this_ = this__ as StatefulWidgetValue;
  return StatefulMixin_get_counter(this_);
}

void StatefulWidget_increment(AnyGC this__) {
  final this_ = this__ as StatefulWidgetValue;
  StatefulMixin_increment(this_);
}

void StatefulWidget_decrement(AnyGC this__) {
  final this_ = this__ as StatefulWidgetValue;
  StatefulMixin_decrement(this_);
}

String StatefulWidget_get_counterStatus(AnyGC this__) {
  final this_ = this__ as StatefulWidgetValue;
  return StatefulMixin_get_counterStatus(this_);
}

void StatefulWidget_set_counter(AnyGC this__, int value) {
  final this_ = this__ as StatefulWidgetValue;
  StatefulMixin_set_counter(this_, value);
}


// mixin LayerA → static functions for delegation
String LayerA_layer(AnyGC this__) {
  final dynamic this_ = this__;
  return 'A';
}

String LayerA_onlyA(AnyGC this__) {
  final dynamic this_ = this__;
  return 'onlyA';
}


// mixin LayerB → static functions for delegation
String LayerB_layer(AnyGC this__) {
  final dynamic this_ = this__;
  return 'B';
}

String LayerB_onlyB(AnyGC this__) {
  final dynamic this_ = this__;
  return 'onlyB';
}


// mixin LayerC → static functions for delegation
String LayerC_layer(AnyGC this__) {
  final dynamic this_ = this__;
  return 'C';
}

String LayerC_onlyC(AnyGC this__) {
  final dynamic this_ = this__;
  return 'onlyC';
}


class DeepMixinClassClassInfo extends DeepMixinClass_Object_LayerA_LayerB_LayerCClassInfo {
  Function? allLayers;
}

class DeepMixinClassValue extends DeepMixinClass_Object_LayerA_LayerB_LayerCValue {
  static DeepMixinClassClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DeepMixinClassClassInfo _initClassInfo() {
    final ci = DeepMixinClassClassInfo();
    ci.layer = DeepMixinClass_layer;
    ci.onlyA = DeepMixinClass_onlyA;
    ci.onlyB = DeepMixinClass_onlyB;
    ci.onlyC = DeepMixinClass_onlyC;
    ci.allLayers = DeepMixinClass_allLayers;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DeepMixinClassValue DeepMixinClass_new(AnyGC this__) {
  final this_ = this__ as DeepMixinClassValue;
  return this_;
}

String DeepMixinClass_allLayers(AnyGC this__) {
  final this_ = this__ as DeepMixinClassValue;
  return '${(this_.classInfo as DeepMixinClassClassInfo).layer!(this_)}-${(this_.classInfo as DeepMixinClassClassInfo).onlyA!(this_)}-${(this_.classInfo as DeepMixinClassClassInfo).onlyB!(this_)}-${(this_.classInfo as DeepMixinClassClassInfo).onlyC!(this_)}';
}

String DeepMixinClass_layer(AnyGC this__) {
  final this_ = this__ as DeepMixinClassValue;
  return LayerC_layer(this_);
}

String DeepMixinClass_onlyA(AnyGC this__) {
  final this_ = this__ as DeepMixinClassValue;
  return LayerA_onlyA(this_);
}

String DeepMixinClass_onlyB(AnyGC this__) {
  final this_ = this__ as DeepMixinClassValue;
  return LayerB_onlyB(this_);
}

String DeepMixinClass_onlyC(AnyGC this__) {
  final this_ = this__ as DeepMixinClassValue;
  return LayerC_onlyC(this_);
}


// mixin Mappable → static functions for delegation
R Mappable_mapValue<T, R>(AnyGC this__, TypeFunction1<R, T> transform) {
  final dynamic this_ = this__;
  return transform.call((this_.classInfo as dynamic).get_value!(this_));
}

String Mappable_describe<T>(AnyGC this__) {
  final dynamic this_ = this__;
  return 'Mappable<${T}>(${(this_.classInfo as dynamic).get_value!(this_)})';
}


// mixin Filterable → static functions for delegation
bool Filterable_test<T>(AnyGC this__, TypeFunction1<bool, T> predicate) {
  final dynamic this_ = this__;
  return predicate.call((this_.classInfo as dynamic).get_value!(this_));
}


class BoxClassInfo<T> extends Box_Object_Mappable_FilterableClassInfo<T> {
  dynamic mapValue_int;
  dynamic mapValue_String;
}

class BoxValue<T> extends Box_Object_Mappable_FilterableValue<T> {
  late T value;
  @override
  ClassInfo get classInfo {
    final ci = BoxClassInfo<T>();
    ci.get_value = Box_get_value<T>;
    ci.describe = Box_describe<T>;
    ci.test = Box_test<T>;
    ci.toString_ = Box_toString<T>;
    ci.mapValue_int = Box_mapValue<T, int>;
    ci.mapValue_String = Box_mapValue<T, String>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (value is AnyGC) (value as AnyGC).gcMark(flag);
  }
}

BoxValue<T> Box_new<T>(AnyGC this__, T value) {
  final this_ = this__ as BoxValue<T>;
  this_.value = value;
  return this_;
}

String Box_toString<T>(AnyGC this__) {
  final this_ = this__ as BoxValue<T>;
  return 'Box(${this_.value})';
}

T Box_get_value<T>(AnyGC this__) {
  final this_ = this__ as BoxValue<T>;
  return this_.value;
}

R Box_mapValue<T, R>(AnyGC this__, TypeFunction1<R, T> transform) {
  final this_ = this__ as BoxValue<T>;
  return Mappable_mapValue<T, R>(this_, transform);
}

String Box_describe<T>(AnyGC this__) {
  final this_ = this__ as BoxValue<T>;
  return Mappable_describe<T>(this_);
}

bool Box_test<T>(AnyGC this__, TypeFunction1<bool, T> predicate) {
  final this_ = this__ as BoxValue<T>;
  return Filterable_test<T>(this_, predicate);
}


class IdentifiableClassInfo extends ClassInfo {
  Function? get_id;
}

class IdentifiableValue extends AnyGC {
  static IdentifiableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static IdentifiableClassInfo _initClassInfo() {
    final ci = IdentifiableClassInfo();
    ci.get_id = Identifiable_get_id;
    return ci;
  }
}

IdentifiableValue Identifiable_new(AnyGC this__) {
  final this_ = this__ as IdentifiableValue;
  return this_;
}

String Identifiable_get_id(dynamic this_) {
  throw UnimplementedError('Identifiable.id is abstract');
}


class DescribableClassInfo extends ClassInfo {
  Function? describe;
}

class DescribableValue extends AnyGC {
  static DescribableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DescribableClassInfo _initClassInfo() {
    final ci = DescribableClassInfo();
    ci.describe = Describable_describe;
    return ci;
  }
}

DescribableValue Describable_new(AnyGC this__) {
  final this_ = this__ as DescribableValue;
  return this_;
}

String Describable_describe(dynamic this_) {
  throw UnimplementedError('Describable.describe is abstract');
}


// mixin Taggable → static functions for delegation
void Taggable_tag(AnyGC this__, String t) {
  final dynamic this_ = this__;
  this_._tags.add(t);
}

StaticList<String> Taggable_get_allTags(AnyGC this__) {
  final dynamic this_ = this__;
  return StaticList<String>.unmodifiable(this_._tags);
}

bool Taggable_hasTag(AnyGC this__, String t) {
  final dynamic this_ = this__;
  return this_._tags.contains(t);
}


class ResourceClassInfo extends IdentifiableClassInfo {
  Function? describe;
}

class ResourceValue extends AnyGC implements IdentifiableValue, DescribableValue {
  late String id;
  late String type;
  static ResourceClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ResourceClassInfo _initClassInfo() {
    final ci = ResourceClassInfo();
    ci.get_id = Resource_get_id;
    ci.describe = Resource_describe;
    return ci;
  }
}

ResourceValue Resource_new(AnyGC this__, String id, String type) {
  final this_ = this__ as ResourceValue;
  this_.id = id;
  this_.type = type;
  return this_;
}

String Resource_describe(AnyGC this__) {
  final this_ = this__ as ResourceValue;
  return 'Resource(${this_.id}, type=${this_.type})';
}

AnyGC Resource_get_id(ResourceValue this_) {
  throw UnimplementedError('Resource.id delegate missing proc');
}


class TaggedResourceClassInfo extends TaggedResource_Resource_TaggableClassInfo {
}

class TaggedResourceValue extends TaggedResource_Resource_TaggableValue {
  static TaggedResourceClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static TaggedResourceClassInfo _initClassInfo() {
    final ci = TaggedResourceClassInfo();
    ci.get_id = TaggedResource_get_id;
    ci.describe = TaggedResource_describe;
    ci.tag = TaggedResource_tag;
    ci.get_allTags = TaggedResource_get_allTags;
    ci.hasTag = TaggedResource_hasTag;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

TaggedResourceValue TaggedResource_new(AnyGC this__, String id, String type) {
  final this_ = this__ as TaggedResourceValue;
  Resource_new(this_, id, type);
  return this_;
}

String TaggedResource_describe(AnyGC this__) {
  final this_ = this__ as TaggedResourceValue;
  return '${Resource_describe(this_)}, tags=${(this_.classInfo as TaggedResourceClassInfo).get_allTags!(this_)}';
}

AnyGC TaggedResource_get_id(TaggedResourceValue this_) {
  throw UnimplementedError('TaggedResource.id delegate missing proc');
}

void TaggedResource_tag(AnyGC this__, String t) {
  final this_ = this__ as TaggedResourceValue;
  Taggable_tag(this_, t);
}

StaticList<String> TaggedResource_get_allTags(AnyGC this__) {
  final this_ = this__ as TaggedResourceValue;
  return Taggable_get_allTags(this_);
}

bool TaggedResource_hasTag(AnyGC this__, String t) {
  final this_ = this__ as TaggedResourceValue;
  return Taggable_hasTag(this_, t);
}


class BaseProcessorClassInfo extends ClassInfo {
  Function? process;
  Function? get_processorName;
}

class BaseProcessorValue extends AnyGC {
  static BaseProcessorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static BaseProcessorClassInfo _initClassInfo() {
    final ci = BaseProcessorClassInfo();
    ci.process = BaseProcessor_process;
    ci.get_processorName = BaseProcessor_get_processorName;
    return ci;
  }
}

BaseProcessorValue BaseProcessor_new(AnyGC this__) {
  final this_ = this__ as BaseProcessorValue;
  return this_;
}

String BaseProcessor_process(AnyGC this__, String input) {
  final this_ = this__ as BaseProcessorValue;
  return input.trim();
}

String BaseProcessor_get_processorName(AnyGC this__) {
  final this_ = this__ as BaseProcessorValue;
  return 'Base';
}


class UpperProcessorClassInfo extends BaseProcessorClassInfo {
}

class UpperProcessorValue extends BaseProcessorValue {
  static UpperProcessorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static UpperProcessorClassInfo _initClassInfo() {
    final ci = UpperProcessorClassInfo();
    ci.process = UpperProcessor_process;
    ci.get_processorName = UpperProcessor_get_processorName;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

UpperProcessorValue UpperProcessor_new(AnyGC this__) {
  final this_ = this__ as UpperProcessorValue;
  BaseProcessor_new(this_);
  return this_;
}

String UpperProcessor_process(AnyGC this__, String input) {
  final this_ = this__ as UpperProcessorValue;
  return BaseProcessor_process(this_, input).toUpperCase();
}

String UpperProcessor_get_processorName(AnyGC this__) {
  final this_ = this__ as UpperProcessorValue;
  return '${BaseProcessor_get_processorName(this_)}->Upper';
}


class PrefixProcessorClassInfo extends UpperProcessorClassInfo {
}

class PrefixProcessorValue extends UpperProcessorValue {
  late String prefix;
  static PrefixProcessorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static PrefixProcessorClassInfo _initClassInfo() {
    final ci = PrefixProcessorClassInfo();
    ci.process = PrefixProcessor_process;
    ci.get_processorName = PrefixProcessor_get_processorName;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

PrefixProcessorValue PrefixProcessor_new(AnyGC this__, String prefix) {
  final this_ = this__ as PrefixProcessorValue;
  UpperProcessor_new(this_);
  this_.prefix = prefix;
  return this_;
}

String PrefixProcessor_process(AnyGC this__, String input) {
  final this_ = this__ as PrefixProcessorValue;
  return '${this_.prefix}:${UpperProcessor_process(this_, input)}';
}

String PrefixProcessor_get_processorName(AnyGC this__) {
  final this_ = this__ as PrefixProcessorValue;
  return '${UpperProcessor_get_processorName(this_)}->Prefix(${this_.prefix})';
}


// mixin Addable → static functions for delegation
int Addable_addValues(AnyGC this__, int other) {
  final dynamic this_ = this__;
  return ((this_.classInfo as dynamic).get_numericValue!(this_) + other);
}

int Addable_doubleValue(AnyGC this__) {
  final dynamic this_ = this__;
  return (this_.classInfo as dynamic).addValues!(this_, (this_.classInfo as dynamic).get_numericValue!(this_));
}


class AmountClassInfo extends Amount_Object_AddableClassInfo {
  Function? operatorPlus;
  Function? operatorMinus;
  Function? operatorLt;
  Function? operatorGt;
}

class AmountValue extends Amount_Object_AddableValue {
  late int numericValue;
  static AmountClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static AmountClassInfo _initClassInfo() {
    final ci = AmountClassInfo();
    ci.get_numericValue = Amount_get_numericValue;
    ci.addValues = Amount_addValues;
    ci.doubleValue = Amount_doubleValue;
    ci.operatorPlus = Amount_operatorPlus;
    ci.operatorMinus = Amount_operatorMinus;
    ci.operatorLt = Amount_operatorLt;
    ci.operatorGt = Amount_operatorGt;
    ci.toString_ = Amount_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

AmountValue Amount_new(AnyGC this__, int numericValue) {
  final this_ = this__ as AmountValue;
  this_.numericValue = numericValue;
  return this_;
}

AmountValue Amount_operatorPlus(AnyGC this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return Amount_new(GC.allocateLocal(AmountValue()), (this_.numericValue + other.numericValue));
}

AmountValue Amount_operatorMinus(AnyGC this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return Amount_new(GC.allocateLocal(AmountValue()), (this_.numericValue - other.numericValue));
}

bool Amount_operatorLt(AnyGC this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return (this_.numericValue < other.numericValue);
}

bool Amount_operatorGt(AnyGC this__, AmountValue other) {
  final this_ = this__ as AmountValue;
  return (this_.numericValue > other.numericValue);
}

String Amount_toString(AnyGC this__) {
  final this_ = this__ as AmountValue;
  return 'Amount(${this_.numericValue})';
}

int Amount_get_numericValue(AnyGC this__) {
  final this_ = this__ as AmountValue;
  return this_.numericValue;
}

int Amount_addValues(AnyGC this__, int other) {
  final this_ = this__ as AmountValue;
  return Addable_addValues(this_, other);
}

int Amount_doubleValue(AnyGC this__) {
  final this_ = this__ as AmountValue;
  return Addable_doubleValue(this_);
}


// mixin Printable2 → static functions for delegation
void Printable2_prettyPrint(AnyGC this__) {
  final dynamic this_ = this__;
  staticPrint('>> ${(this_.classInfo as dynamic).toPrettyString!(this_)}');
}


class VehicleClassInfo extends ClassInfo {
}

class VehicleValue extends AnyGC {
  late String make;
  late int year;
  static VehicleClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static VehicleClassInfo _initClassInfo() {
    final ci = VehicleClassInfo();
    ci.toString_ = Vehicle_toString;
    return ci;
  }
}

VehicleValue Vehicle_new(AnyGC this__, String make, int year) {
  final this_ = this__ as VehicleValue;
  this_.make = make;
  this_.year = year;
  return this_;
}

String Vehicle_toString(AnyGC this__) {
  final this_ = this__ as VehicleValue;
  return 'Vehicle(${this_.make}, ${this_.year})';
}


class CarClassInfo extends Car_Vehicle_Printable2ClassInfo {
}

class CarValue extends Car_Vehicle_Printable2Value {
  late int doors;
  static CarClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CarClassInfo _initClassInfo() {
    final ci = CarClassInfo();
    ci.toString_ = Car_toString;
    ci.toPrettyString = Car_toPrettyString;
    ci.prettyPrint = Car_prettyPrint;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CarValue Car_new(AnyGC this__, String make, int year, int doors) {
  final this_ = this__ as CarValue;
  Vehicle_new(this_, make, year);
  this_.doors = doors;
  return this_;
}

String Car_toPrettyString(AnyGC this__) {
  final this_ = this__ as CarValue;
  return 'Car[${this_.make}, ${this_.year}, ${this_.doors}dr]';
}

String Car_toString(AnyGC this__) {
  final this_ = this__ as CarValue;
  return 'Car(${this_.make}, ${this_.year}, ${this_.doors}dr)';
}

void Car_prettyPrint(AnyGC this__) {
  final this_ = this__ as CarValue;
  Printable2_prettyPrint(this_);
}


class ElectricCarClassInfo extends CarClassInfo {
}

class ElectricCarValue extends CarValue {
  late int range;
  static ElectricCarClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ElectricCarClassInfo _initClassInfo() {
    final ci = ElectricCarClassInfo();
    ci.toString_ = ElectricCar_toString;
    ci.toPrettyString = ElectricCar_toPrettyString;
    ci.prettyPrint = ElectricCar_prettyPrint;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

ElectricCarValue ElectricCar_new(AnyGC this__, String make, int year, int doors, int range) {
  final this_ = this__ as ElectricCarValue;
  Car_new(this_, make, year, doors);
  this_.range = range;
  return this_;
}

String ElectricCar_toPrettyString(AnyGC this__) {
  final this_ = this__ as ElectricCarValue;
  return '${Car_toPrettyString(this_)}+EV(${this_.range}km)';
}

String ElectricCar_toString(AnyGC this__) {
  final this_ = this__ as ElectricCarValue;
  return 'ElectricCar(${this_.make}, ${this_.year}, ${this_.doors}dr, ${this_.range}km)';
}

void ElectricCar_prettyPrint(AnyGC this__) {
  final this_ = this__ as ElectricCarValue;
  Printable2_prettyPrint(this_);
}


class MeasurableClassInfo extends ClassInfo {
  Function? measure;
}

class MeasurableValue extends AnyGC {
  static MeasurableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MeasurableClassInfo _initClassInfo() {
    final ci = MeasurableClassInfo();
    ci.measure = Measurable_measure;
    return ci;
  }
}

MeasurableValue Measurable_new(AnyGC this__) {
  final this_ = this__ as MeasurableValue;
  return this_;
}

double Measurable_measure(dynamic this_) {
  throw UnimplementedError('Measurable.measure is abstract');
}


// mixin Scalable → static functions for delegation
double Scalable_scale(AnyGC this__, double factor) {
  final dynamic this_ = this__;
  return ((this_.classInfo as dynamic).measure!(this_) * factor);
}

String Scalable_measureInfo(AnyGC this__) {
  final dynamic this_ = this__;
  return 'measure=${(this_.classInfo as dynamic).measure!(this_).toStringAsFixed(1)}';
}


class SegmentClassInfo extends Segment_Measurable_ScalableClassInfo {
}

class SegmentValue extends Segment_Measurable_ScalableValue {
  late double length;
  static SegmentClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static SegmentClassInfo _initClassInfo() {
    final ci = SegmentClassInfo();
    ci.measure = Segment_measure;
    ci.scale = Segment_scale;
    ci.measureInfo = Segment_measureInfo;
    ci.toString_ = Segment_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

SegmentValue Segment_new(AnyGC this__, double length) {
  final this_ = this__ as SegmentValue;
  Measurable_new(this_);
  this_.length = length;
  return this_;
}

double Segment_measure(AnyGC this__) {
  final this_ = this__ as SegmentValue;
  return this_.length;
}

String Segment_toString(AnyGC this__) {
  final this_ = this__ as SegmentValue;
  return 'Segment(${this_.length}, ${(this_.classInfo as SegmentClassInfo).measureInfo!(this_)})';
}

double Segment_scale(AnyGC this__, double factor) {
  final this_ = this__ as SegmentValue;
  return Scalable_scale(this_, factor);
}

String Segment_measureInfo(AnyGC this__) {
  final this_ = this__ as SegmentValue;
  return Scalable_measureInfo(this_);
}


class WeightedSegmentClassInfo extends SegmentClassInfo {
}

class WeightedSegmentValue extends SegmentValue {
  late double weight;
  static WeightedSegmentClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static WeightedSegmentClassInfo _initClassInfo() {
    final ci = WeightedSegmentClassInfo();
    ci.measure = WeightedSegment_measure;
    ci.scale = WeightedSegment_scale;
    ci.measureInfo = WeightedSegment_measureInfo;
    ci.toString_ = WeightedSegment_toString;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

WeightedSegmentValue WeightedSegment_new(AnyGC this__, double length, double weight) {
  final this_ = this__ as WeightedSegmentValue;
  Segment_new(this_, length);
  this_.weight = weight;
  return this_;
}

double WeightedSegment_measure(AnyGC this__) {
  final this_ = this__ as WeightedSegmentValue;
  return (this_.length * this_.weight);
}

String WeightedSegment_toString(AnyGC this__) {
  final this_ = this__ as WeightedSegmentValue;
  return 'WeightedSegment(len=${this_.length}, w=${this_.weight}, ${(this_.classInfo as WeightedSegmentClassInfo).measureInfo!(this_)})';
}

double WeightedSegment_scale(AnyGC this__, double factor) {
  final this_ = this__ as WeightedSegmentValue;
  return Scalable_scale(this_, factor);
}

String WeightedSegment_measureInfo(AnyGC this__) {
  final this_ = this__ as WeightedSegmentValue;
  return Scalable_measureInfo(this_);
}


// mixin NamedMixin → static functions for delegation
String NamedMixin_get_label(AnyGC this__) {
  final dynamic this_ = this__;
  return 'NamedMixin';
}

String NamedMixin_greet(AnyGC this__) {
  final dynamic this_ = this__;
  return 'Hello from ${(this_.classInfo as dynamic).get_label!(this_)}';
}


// mixin DescribedMixin → static functions for delegation
String DescribedMixin_get_label(AnyGC this__) {
  final dynamic this_ = this__;
  return 'DescribedMixin';
}

String DescribedMixin_info(AnyGC this__) {
  final dynamic this_ = this__;
  return 'Info: ${(this_.classInfo as dynamic).get_label!(this_)}';
}


class MultiMixinEntityClassInfo extends MultiMixinEntity_Object_NamedMixin_DescribedMixinClassInfo {
  Function? fullInfo;
}

class MultiMixinEntityValue extends MultiMixinEntity_Object_NamedMixin_DescribedMixinValue {
  static MultiMixinEntityClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MultiMixinEntityClassInfo _initClassInfo() {
    final ci = MultiMixinEntityClassInfo();
    ci.get_label = MultiMixinEntity_get_label;
    ci.greet = MultiMixinEntity_greet;
    ci.info = MultiMixinEntity_info;
    ci.fullInfo = MultiMixinEntity_fullInfo;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

MultiMixinEntityValue MultiMixinEntity_new(AnyGC this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return this_;
}

String MultiMixinEntity_get_label(AnyGC this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return 'Entity';
}

String MultiMixinEntity_fullInfo(AnyGC this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return '${(this_.classInfo as MultiMixinEntityClassInfo).greet!(this_)} | ${(this_.classInfo as MultiMixinEntityClassInfo).info!(this_)}';
}

String MultiMixinEntity_greet(AnyGC this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return NamedMixin_greet(this_);
}

String MultiMixinEntity_info(AnyGC this__) {
  final this_ = this__ as MultiMixinEntityValue;
  return DescribedMixin_info(this_);
}


class EncoderClassInfo extends ClassInfo {
  Function? encode;
}

class EncoderValue extends AnyGC {
  static EncoderClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static EncoderClassInfo _initClassInfo() {
    final ci = EncoderClassInfo();
    ci.encode = Encoder_encode;
    return ci;
  }
}

EncoderValue Encoder_new(AnyGC this__) {
  final this_ = this__ as EncoderValue;
  return this_;
}

String Encoder_encode(dynamic this_, String input) {
  throw UnimplementedError('Encoder.encode is abstract');
}


// mixin Base64Mixin → static functions for delegation
String Base64Mixin_encode(AnyGC this__, String input) {
  final dynamic this_ = this__;
  return 'base64(${input})';
}


// mixin HexMixin → static functions for delegation
String HexMixin_encode(AnyGC this__, String input) {
  final dynamic this_ = this__;
  return 'hex(${input})';
}


class MultiEncoderClassInfo extends MultiEncoder_Object_Base64Mixin_HexMixinClassInfo {
  Function? encodeAll;
}

class MultiEncoderValue extends MultiEncoder_Object_Base64Mixin_HexMixinValue {
  static MultiEncoderClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MultiEncoderClassInfo _initClassInfo() {
    final ci = MultiEncoderClassInfo();
    ci.encode = MultiEncoder_encode;
    ci.encodeAll = MultiEncoder_encodeAll;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

MultiEncoderValue MultiEncoder_new(AnyGC this__) {
  final this_ = this__ as MultiEncoderValue;
  return this_;
}

String MultiEncoder_encodeAll(AnyGC this__, String input) {
  final this_ = this__ as MultiEncoderValue;
  return (this_.classInfo as MultiEncoderClassInfo).encode!(this_, input);
}

String MultiEncoder_encode(AnyGC this__, String input) {
  final this_ = this__ as MultiEncoderValue;
  return HexMixin_encode(this_, input);
}


class CustomEncoderClassInfo extends MultiEncoderClassInfo {
}

class CustomEncoderValue extends MultiEncoderValue {
  static CustomEncoderClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CustomEncoderClassInfo _initClassInfo() {
    final ci = CustomEncoderClassInfo();
    ci.encode = CustomEncoder_encode;
    ci.encodeAll = CustomEncoder_encodeAll;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CustomEncoderValue CustomEncoder_new(AnyGC this__) {
  final this_ = this__ as CustomEncoderValue;
  MultiEncoder_new(this_);
  return this_;
}

String CustomEncoder_encode(AnyGC this__, String input) {
  final this_ = this__ as CustomEncoderValue;
  return 'custom(${MultiEncoder_encode(this_, input)})';
}

String CustomEncoder_encodeAll(AnyGC this__, String input) {
  final this_ = this__ as CustomEncoderValue;
  return MultiEncoder_encodeAll(this_, input);
}


class ContainerClassInfo<T> extends ClassInfo {
  Function? describe;
  Function? get_content;
}

class ContainerValue<T> extends AnyGC {
  late T item;
  @override
  ClassInfo get classInfo {
    final ci = ContainerClassInfo<T>();
    ci.describe = Container_describe<T>;
    ci.get_content = Container_get_content<T>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (item is AnyGC) (item as AnyGC).gcMark(flag);
  }
}

ContainerValue<T> Container_new<T>(AnyGC this__, T item) {
  final this_ = this__ as ContainerValue<T>;
  this_.item = item;
  return this_;
}

String Container_describe<T>(AnyGC this__) {
  final this_ = this__ as ContainerValue<T>;
  return 'Container<${T}>(${this_.item})';
}

T Container_get_content<T>(AnyGC this__) {
  final this_ = this__ as ContainerValue<T>;
  return this_.item;
}


class LabeledContainerClassInfo<T> extends ContainerClassInfo<T> {
}

class LabeledContainerValue<T> extends ContainerValue<T> {
  late String label;
  @override
  ClassInfo get classInfo {
    final ci = LabeledContainerClassInfo<T>();
    ci.describe = LabeledContainer_describe<T>;
    ci.get_content = LabeledContainer_get_content<T>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

LabeledContainerValue<T> LabeledContainer_new<T>(AnyGC this__, T item, String label) {
  final this_ = this__ as LabeledContainerValue<T>;
  Container_new<T>(this_, item);
  this_.label = label;
  return this_;
}

String LabeledContainer_describe<T>(AnyGC this__) {
  final this_ = this__ as LabeledContainerValue<T>;
  return 'Labeled[${this_.label}]: ${Container_describe<T>(this_)}';
}

T LabeledContainer_get_content<T>(AnyGC this__) {
  final this_ = this__ as LabeledContainerValue<T>;
  return Container_get_content<T>(this_);
}


class PriorityContainerClassInfo<T> extends LabeledContainerClassInfo<T> {
}

class PriorityContainerValue<T> extends LabeledContainerValue<T> {
  late int priority;
  @override
  ClassInfo get classInfo {
    final ci = PriorityContainerClassInfo<T>();
    ci.describe = PriorityContainer_describe<T>;
    ci.get_content = PriorityContainer_get_content<T>;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

PriorityContainerValue<T> PriorityContainer_new<T>(AnyGC this__, T item, String label, int priority) {
  final this_ = this__ as PriorityContainerValue<T>;
  LabeledContainer_new<T>(this_, item, label);
  this_.priority = priority;
  return this_;
}

String PriorityContainer_describe<T>(AnyGC this__) {
  final this_ = this__ as PriorityContainerValue<T>;
  return '(P${this_.priority}) ${LabeledContainer_describe<T>(this_)}';
}

T PriorityContainer_get_content<T>(AnyGC this__) {
  final this_ = this__ as PriorityContainerValue<T>;
  return Container_get_content<T>(this_);
}


// mixin ChainMixin → static functions for delegation
String ChainMixin_step1(AnyGC this__) {
  final dynamic this_ = this__;
  return 'S1';
}

String ChainMixin_step2(AnyGC this__) {
  final dynamic this_ = this__;
  return '${(this_.classInfo as dynamic).step1!(this_)}->S2';
}

String ChainMixin_step3(AnyGC this__) {
  final dynamic this_ = this__;
  return '${(this_.classInfo as dynamic).step2!(this_)}->S3';
}

String ChainMixin_fullChain(AnyGC this__) {
  final dynamic this_ = this__;
  return '${(this_.classInfo as dynamic).step3!(this_)}->done';
}


class ChainClassClassInfo extends ChainClass_Object_ChainMixinClassInfo {
}

class ChainClassValue extends ChainClass_Object_ChainMixinValue {
  static ChainClassClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ChainClassClassInfo _initClassInfo() {
    final ci = ChainClassClassInfo();
    ci.step1 = ChainClass_step1;
    ci.step2 = ChainClass_step2;
    ci.step3 = ChainClass_step3;
    ci.fullChain = ChainClass_fullChain;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

ChainClassValue ChainClass_new(AnyGC this__) {
  final this_ = this__ as ChainClassValue;
  return this_;
}

String ChainClass_step1(AnyGC this__) {
  final this_ = this__ as ChainClassValue;
  return 'X1';
}

String ChainClass_step2(AnyGC this__) {
  final this_ = this__ as ChainClassValue;
  return ChainMixin_step2(this_);
}

String ChainClass_step3(AnyGC this__) {
  final this_ = this__ as ChainClassValue;
  return ChainMixin_step3(this_);
}

String ChainClass_fullChain(AnyGC this__) {
  final this_ = this__ as ChainClassValue;
  return ChainMixin_fullChain(this_);
}


class ChainSubClassClassInfo extends ChainClassClassInfo {
}

class ChainSubClassValue extends ChainClassValue {
  static ChainSubClassClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ChainSubClassClassInfo _initClassInfo() {
    final ci = ChainSubClassClassInfo();
    ci.step1 = ChainSubClass_step1;
    ci.step2 = ChainSubClass_step2;
    ci.step3 = ChainSubClass_step3;
    ci.fullChain = ChainSubClass_fullChain;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

ChainSubClassValue ChainSubClass_new(AnyGC this__) {
  final this_ = this__ as ChainSubClassValue;
  ChainClass_new(this_);
  return this_;
}

String ChainSubClass_step2(AnyGC this__) {
  final this_ = this__ as ChainSubClassValue;
  return '${(this_.classInfo as ChainSubClassClassInfo).step1!(this_)}->Y2';
}

String ChainSubClass_step1(AnyGC this__) {
  final this_ = this__ as ChainSubClassValue;
  return ChainClass_step1(this_);
}

String ChainSubClass_step3(AnyGC this__) {
  final this_ = this__ as ChainSubClassValue;
  return ChainMixin_step3(this_);
}

String ChainSubClass_fullChain(AnyGC this__) {
  final this_ = this__ as ChainSubClassValue;
  return ChainMixin_fullChain(this_);
}


class Expression2ClassInfo extends ClassInfo {
  Function? evaluate;
  Function? display;
}

class Expression2Value extends AnyGC {
  static Expression2ClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Expression2ClassInfo _initClassInfo() {
    final ci = Expression2ClassInfo();
    ci.evaluate = Expression2_evaluate;
    ci.display = Expression2_display;
    return ci;
  }
}

Expression2Value Expression2_new(AnyGC this__) {
  final this_ = this__ as Expression2Value;
  return this_;
}

double Expression2_evaluate(dynamic this_) {
  throw UnimplementedError('Expression2.evaluate is abstract');
}

String Expression2_display(dynamic this_) {
  throw UnimplementedError('Expression2.display is abstract');
}


class NumberExprClassInfo extends Expression2ClassInfo {
}

class NumberExprValue extends Expression2Value {
  late double value;
  static NumberExprClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static NumberExprClassInfo _initClassInfo() {
    final ci = NumberExprClassInfo();
    ci.evaluate = NumberExpr_evaluate;
    ci.display = NumberExpr_display;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

NumberExprValue NumberExpr_new(AnyGC this__, double value) {
  final this_ = this__ as NumberExprValue;
  Expression2_new(this_);
  this_.value = value;
  return this_;
}

double NumberExpr_evaluate(AnyGC this__) {
  final this_ = this__ as NumberExprValue;
  return this_.value;
}

String NumberExpr_display(AnyGC this__) {
  final this_ = this__ as NumberExprValue;
  return ((this_.value == this_.value.toInt()) ? '${this_.value.toInt()}' : '${this_.value}');
}


class BinaryExprClassInfo extends Expression2ClassInfo {
}

class BinaryExprValue extends Expression2Value {
  late Expression2Value left;
  late Expression2Value right;
  late String op;
  late TypeFunction2<double, double, double> _compute;
  static BinaryExprClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static BinaryExprClassInfo _initClassInfo() {
    final ci = BinaryExprClassInfo();
    ci.evaluate = BinaryExpr_evaluate;
    ci.display = BinaryExpr_display;
    return ci;
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

BinaryExprValue BinaryExpr_new(AnyGC this__, Expression2Value left, Expression2Value right, String op, TypeFunction2<double, double, double> _compute) {
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

double BinaryExpr_evaluate(AnyGC this__) {
  final this_ = this__ as BinaryExprValue;
  return (() { final _let0 = (this_.left.classInfo as Expression2ClassInfo).evaluate!(this_.left); return (() { final _let1 = (this_.right.classInfo as Expression2ClassInfo).evaluate!(this_.right); return this_._compute.call(_let0, _let1); })(); })();
}

String BinaryExpr_display(AnyGC this__) {
  final this_ = this__ as BinaryExprValue;
  return '(${(this_.left.classInfo as Expression2ClassInfo).display!(this_.left)} ${this_.op} ${(this_.right.classInfo as Expression2ClassInfo).display!(this_.right)})';
}


// mixin HealthMixin → static functions for delegation
int HealthMixin_get_maxHealth(AnyGC this__) {
  final dynamic this_ = this__;
  return 100;
}

int HealthMixin_get_health(AnyGC this__) {
  final dynamic this_ = this__;
  return (this_.classInfo as dynamic).get_maxHealth!(this_);
}

String HealthMixin_healthBar(AnyGC this__) {
  final dynamic this_ = this__;
  return 'HP:${(this_.classInfo as dynamic).get_health!(this_)}/${(this_.classInfo as dynamic).get_maxHealth!(this_)}';
}


// mixin ManaMixin → static functions for delegation
int ManaMixin_get_maxMana(AnyGC this__) {
  final dynamic this_ = this__;
  return 50;
}

int ManaMixin_get_mana(AnyGC this__) {
  final dynamic this_ = this__;
  return (this_.classInfo as dynamic).get_maxMana!(this_);
}

String ManaMixin_manaBar(AnyGC this__) {
  final dynamic this_ = this__;
  return 'MP:${(this_.classInfo as dynamic).get_mana!(this_)}/${(this_.classInfo as dynamic).get_maxMana!(this_)}';
}


// mixin StaminaMixin → static functions for delegation
int StaminaMixin_get_maxStamina(AnyGC this__) {
  final dynamic this_ = this__;
  return 80;
}

int StaminaMixin_get_stamina(AnyGC this__) {
  final dynamic this_ = this__;
  return (this_.classInfo as dynamic).get_maxStamina!(this_);
}

String StaminaMixin_staminaBar(AnyGC this__) {
  final dynamic this_ = this__;
  return 'SP:${(this_.classInfo as dynamic).get_stamina!(this_)}/${(this_.classInfo as dynamic).get_maxStamina!(this_)}';
}


class GameCharacterClassInfo extends GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinClassInfo {
  Function? statusBars;
}

class GameCharacterValue extends GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue {
  late String name;
  static GameCharacterClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static GameCharacterClassInfo _initClassInfo() {
    final ci = GameCharacterClassInfo();
    ci.get_maxHealth = GameCharacter_get_maxHealth;
    ci.get_health = GameCharacter_get_health;
    ci.healthBar = GameCharacter_healthBar;
    ci.get_maxMana = GameCharacter_get_maxMana;
    ci.get_mana = GameCharacter_get_mana;
    ci.manaBar = GameCharacter_manaBar;
    ci.get_maxStamina = GameCharacter_get_maxStamina;
    ci.get_stamina = GameCharacter_get_stamina;
    ci.staminaBar = GameCharacter_staminaBar;
    ci.statusBars = GameCharacter_statusBars;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

GameCharacterValue GameCharacter_new(AnyGC this__, String name) {
  final this_ = this__ as GameCharacterValue;
  this_.name = name;
  return this_;
}

String GameCharacter_statusBars(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return '${this_.name}: ${(this_.classInfo as GameCharacterClassInfo).healthBar!(this_)} ${(this_.classInfo as GameCharacterClassInfo).manaBar!(this_)} ${(this_.classInfo as GameCharacterClassInfo).staminaBar!(this_)}';
}

int GameCharacter_get_maxHealth(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return HealthMixin_get_maxHealth(this_);
}

int GameCharacter_get_health(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return HealthMixin_get_health(this_);
}

String GameCharacter_healthBar(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return HealthMixin_healthBar(this_);
}

int GameCharacter_get_maxMana(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return ManaMixin_get_maxMana(this_);
}

int GameCharacter_get_mana(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return ManaMixin_get_mana(this_);
}

String GameCharacter_manaBar(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return ManaMixin_manaBar(this_);
}

int GameCharacter_get_maxStamina(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return StaminaMixin_get_maxStamina(this_);
}

int GameCharacter_get_stamina(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return StaminaMixin_get_stamina(this_);
}

String GameCharacter_staminaBar(AnyGC this__) {
  final this_ = this__ as GameCharacterValue;
  return StaminaMixin_staminaBar(this_);
}


class WarriorClassInfo extends GameCharacterClassInfo {
}

class WarriorValue extends GameCharacterValue {
  static WarriorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static WarriorClassInfo _initClassInfo() {
    final ci = WarriorClassInfo();
    ci.get_maxHealth = Warrior_get_maxHealth;
    ci.get_health = Warrior_get_health;
    ci.healthBar = Warrior_healthBar;
    ci.get_maxMana = Warrior_get_maxMana;
    ci.get_mana = Warrior_get_mana;
    ci.manaBar = Warrior_manaBar;
    ci.get_maxStamina = Warrior_get_maxStamina;
    ci.get_stamina = Warrior_get_stamina;
    ci.staminaBar = Warrior_staminaBar;
    ci.statusBars = Warrior_statusBars;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

WarriorValue Warrior_new(AnyGC this__, String name) {
  final this_ = this__ as WarriorValue;
  GameCharacter_new(this_, name);
  return this_;
}

int Warrior_get_maxHealth(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return 150;
}

int Warrior_get_maxStamina(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return 120;
}

int Warrior_get_health(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return HealthMixin_get_health(this_);
}

String Warrior_healthBar(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return HealthMixin_healthBar(this_);
}

int Warrior_get_maxMana(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return ManaMixin_get_maxMana(this_);
}

int Warrior_get_mana(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return ManaMixin_get_mana(this_);
}

String Warrior_manaBar(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return ManaMixin_manaBar(this_);
}

int Warrior_get_stamina(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return StaminaMixin_get_stamina(this_);
}

String Warrior_staminaBar(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return StaminaMixin_staminaBar(this_);
}

String Warrior_statusBars(AnyGC this__) {
  final this_ = this__ as WarriorValue;
  return GameCharacter_statusBars(this_);
}


class MageClassInfo extends GameCharacterClassInfo {
}

class MageValue extends GameCharacterValue {
  static MageClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MageClassInfo _initClassInfo() {
    final ci = MageClassInfo();
    ci.get_maxHealth = Mage_get_maxHealth;
    ci.get_health = Mage_get_health;
    ci.healthBar = Mage_healthBar;
    ci.get_maxMana = Mage_get_maxMana;
    ci.get_mana = Mage_get_mana;
    ci.manaBar = Mage_manaBar;
    ci.get_maxStamina = Mage_get_maxStamina;
    ci.get_stamina = Mage_get_stamina;
    ci.staminaBar = Mage_staminaBar;
    ci.statusBars = Mage_statusBars;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

MageValue Mage_new(AnyGC this__, String name) {
  final this_ = this__ as MageValue;
  GameCharacter_new(this_, name);
  return this_;
}

int Mage_get_maxMana(AnyGC this__) {
  final this_ = this__ as MageValue;
  return 200;
}

int Mage_get_maxHealth(AnyGC this__) {
  final this_ = this__ as MageValue;
  return 60;
}

int Mage_get_health(AnyGC this__) {
  final this_ = this__ as MageValue;
  return HealthMixin_get_health(this_);
}

String Mage_healthBar(AnyGC this__) {
  final this_ = this__ as MageValue;
  return HealthMixin_healthBar(this_);
}

int Mage_get_mana(AnyGC this__) {
  final this_ = this__ as MageValue;
  return ManaMixin_get_mana(this_);
}

String Mage_manaBar(AnyGC this__) {
  final this_ = this__ as MageValue;
  return ManaMixin_manaBar(this_);
}

int Mage_get_maxStamina(AnyGC this__) {
  final this_ = this__ as MageValue;
  return StaminaMixin_get_maxStamina(this_);
}

int Mage_get_stamina(AnyGC this__) {
  final this_ = this__ as MageValue;
  return StaminaMixin_get_stamina(this_);
}

String Mage_staminaBar(AnyGC this__) {
  final this_ = this__ as MageValue;
  return StaminaMixin_staminaBar(this_);
}

String Mage_statusBars(AnyGC this__) {
  final this_ = this__ as MageValue;
  return GameCharacter_statusBars(this_);
}


class DiamondClass_Object_LoggerClassInfo extends ClassInfo {
  Function? get_prefix;
  Function? format;
}

class DiamondClass_Object_LoggerValue extends AnyGC {
  static DiamondClass_Object_LoggerClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DiamondClass_Object_LoggerClassInfo _initClassInfo() {
    final ci = DiamondClass_Object_LoggerClassInfo();
    return ci;
  }
}


class DiamondClass_Object_Logger_FormatterClassInfo extends DiamondClass_Object_LoggerClassInfo {
}

class DiamondClass_Object_Logger_FormatterValue extends DiamondClass_Object_LoggerValue {
  static DiamondClass_Object_Logger_FormatterClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DiamondClass_Object_Logger_FormatterClassInfo _initClassInfo() {
    final ci = DiamondClass_Object_Logger_FormatterClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class StatefulWidget_Object_StatefulMixinClassInfo extends ClassInfo {
  Function? get_counter;
  Function? increment;
  Function? decrement;
  Function? get_counterStatus;
  Function? set_counter;
}

class StatefulWidget_Object_StatefulMixinValue extends AnyGC {
  late int _counter = 0;
  static StatefulWidget_Object_StatefulMixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static StatefulWidget_Object_StatefulMixinClassInfo _initClassInfo() {
    final ci = StatefulWidget_Object_StatefulMixinClassInfo();
    return ci;
  }
}


class DeepMixinClass_Object_LayerAClassInfo extends ClassInfo {
  Function? layer;
  Function? onlyA;
}

class DeepMixinClass_Object_LayerAValue extends AnyGC {
  static DeepMixinClass_Object_LayerAClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DeepMixinClass_Object_LayerAClassInfo _initClassInfo() {
    final ci = DeepMixinClass_Object_LayerAClassInfo();
    return ci;
  }
}


class DeepMixinClass_Object_LayerA_LayerBClassInfo extends DeepMixinClass_Object_LayerAClassInfo {
  Function? onlyB;
}

class DeepMixinClass_Object_LayerA_LayerBValue extends DeepMixinClass_Object_LayerAValue {
  static DeepMixinClass_Object_LayerA_LayerBClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DeepMixinClass_Object_LayerA_LayerBClassInfo _initClassInfo() {
    final ci = DeepMixinClass_Object_LayerA_LayerBClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class DeepMixinClass_Object_LayerA_LayerB_LayerCClassInfo extends DeepMixinClass_Object_LayerA_LayerBClassInfo {
  Function? onlyC;
}

class DeepMixinClass_Object_LayerA_LayerB_LayerCValue extends DeepMixinClass_Object_LayerA_LayerBValue {
  static DeepMixinClass_Object_LayerA_LayerB_LayerCClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DeepMixinClass_Object_LayerA_LayerB_LayerCClassInfo _initClassInfo() {
    final ci = DeepMixinClass_Object_LayerA_LayerB_LayerCClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Box_Object_MappableClassInfo<T> extends ClassInfo {
  Function? get_value;
  Function? mapValue;
  Function? describe;
}

class Box_Object_MappableValue<T> extends AnyGC {
  @override
  ClassInfo get classInfo {
    final ci = Box_Object_MappableClassInfo<T>();
    return ci;
  }
}


class Box_Object_Mappable_FilterableClassInfo<T> extends Box_Object_MappableClassInfo<T> {
  Function? test;
}

class Box_Object_Mappable_FilterableValue<T> extends Box_Object_MappableValue<T> {
  @override
  ClassInfo get classInfo {
    final ci = Box_Object_Mappable_FilterableClassInfo<T>();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class TaggedResource_Resource_TaggableClassInfo extends ResourceClassInfo {
  Function? tag;
  Function? get_allTags;
  Function? hasTag;
}

class TaggedResource_Resource_TaggableValue extends ResourceValue {
  late StaticList<String> _tags = StaticList<String>();
  static TaggedResource_Resource_TaggableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static TaggedResource_Resource_TaggableClassInfo _initClassInfo() {
    final ci = TaggedResource_Resource_TaggableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_tags is AnyGC) (_tags as AnyGC).gcMark(flag);
  }
}


class Amount_Object_AddableClassInfo extends ClassInfo {
  Function? get_numericValue;
  Function? addValues;
  Function? doubleValue;
}

class Amount_Object_AddableValue extends AnyGC {
  static Amount_Object_AddableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Amount_Object_AddableClassInfo _initClassInfo() {
    final ci = Amount_Object_AddableClassInfo();
    return ci;
  }
}


class Car_Vehicle_Printable2ClassInfo extends VehicleClassInfo {
  Function? toPrettyString;
  Function? prettyPrint;
}

class Car_Vehicle_Printable2Value extends VehicleValue {
  static Car_Vehicle_Printable2ClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Car_Vehicle_Printable2ClassInfo _initClassInfo() {
    final ci = Car_Vehicle_Printable2ClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Segment_Measurable_ScalableClassInfo extends MeasurableClassInfo {
  Function? scale;
  Function? measureInfo;
}

class Segment_Measurable_ScalableValue extends MeasurableValue {
  static Segment_Measurable_ScalableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Segment_Measurable_ScalableClassInfo _initClassInfo() {
    final ci = Segment_Measurable_ScalableClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class MultiMixinEntity_Object_NamedMixinClassInfo extends ClassInfo {
  Function? get_label;
  Function? greet;
}

class MultiMixinEntity_Object_NamedMixinValue extends AnyGC {
  static MultiMixinEntity_Object_NamedMixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MultiMixinEntity_Object_NamedMixinClassInfo _initClassInfo() {
    final ci = MultiMixinEntity_Object_NamedMixinClassInfo();
    return ci;
  }
}


class MultiMixinEntity_Object_NamedMixin_DescribedMixinClassInfo extends MultiMixinEntity_Object_NamedMixinClassInfo {
  Function? info;
}

class MultiMixinEntity_Object_NamedMixin_DescribedMixinValue extends MultiMixinEntity_Object_NamedMixinValue {
  static MultiMixinEntity_Object_NamedMixin_DescribedMixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MultiMixinEntity_Object_NamedMixin_DescribedMixinClassInfo _initClassInfo() {
    final ci = MultiMixinEntity_Object_NamedMixin_DescribedMixinClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class MultiEncoder_Object_Base64MixinClassInfo extends ClassInfo {
  Function? encode;
}

class MultiEncoder_Object_Base64MixinValue extends AnyGC {
  static MultiEncoder_Object_Base64MixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MultiEncoder_Object_Base64MixinClassInfo _initClassInfo() {
    final ci = MultiEncoder_Object_Base64MixinClassInfo();
    return ci;
  }
}


class MultiEncoder_Object_Base64Mixin_HexMixinClassInfo extends MultiEncoder_Object_Base64MixinClassInfo {
}

class MultiEncoder_Object_Base64Mixin_HexMixinValue extends MultiEncoder_Object_Base64MixinValue {
  static MultiEncoder_Object_Base64Mixin_HexMixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static MultiEncoder_Object_Base64Mixin_HexMixinClassInfo _initClassInfo() {
    final ci = MultiEncoder_Object_Base64Mixin_HexMixinClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class ChainClass_Object_ChainMixinClassInfo extends ClassInfo {
  Function? step1;
  Function? step2;
  Function? step3;
  Function? fullChain;
}

class ChainClass_Object_ChainMixinValue extends AnyGC {
  static ChainClass_Object_ChainMixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ChainClass_Object_ChainMixinClassInfo _initClassInfo() {
    final ci = ChainClass_Object_ChainMixinClassInfo();
    return ci;
  }
}


class GameCharacter_Object_HealthMixinClassInfo extends ClassInfo {
  Function? get_maxHealth;
  Function? get_health;
  Function? healthBar;
}

class GameCharacter_Object_HealthMixinValue extends AnyGC {
  static GameCharacter_Object_HealthMixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static GameCharacter_Object_HealthMixinClassInfo _initClassInfo() {
    final ci = GameCharacter_Object_HealthMixinClassInfo();
    return ci;
  }
}


class GameCharacter_Object_HealthMixin_ManaMixinClassInfo extends GameCharacter_Object_HealthMixinClassInfo {
  Function? get_maxMana;
  Function? get_mana;
  Function? manaBar;
}

class GameCharacter_Object_HealthMixin_ManaMixinValue extends GameCharacter_Object_HealthMixinValue {
  static GameCharacter_Object_HealthMixin_ManaMixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static GameCharacter_Object_HealthMixin_ManaMixinClassInfo _initClassInfo() {
    final ci = GameCharacter_Object_HealthMixin_ManaMixinClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinClassInfo extends GameCharacter_Object_HealthMixin_ManaMixinClassInfo {
  Function? get_maxStamina;
  Function? get_stamina;
  Function? staminaBar;
}

class GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue extends GameCharacter_Object_HealthMixin_ManaMixinValue {
  static GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinClassInfo _initClassInfo() {
    final ci = GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinClassInfo();
    return ci;
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
  staticPrint('prefix: ${(diamond.classInfo as DiamondClassClassInfo).get_prefix!(diamond)}');
  staticPrint('format: ${(diamond.classInfo as DiamondClassClassInfo).format!(diamond, 'hello')}');
  staticPrint('display: ${(diamond.classInfo as DiamondClassClassInfo).display!(diamond, 'world')}');
  staticPrint('\n--- 2. StatefulMixin ---');
  final StatefulWidgetValue widget = StatefulWidget_new(GC.allocateLocal(StatefulWidgetValue()), 'btn1');
  staticPrint('initial: ${widget}');
  (widget.classInfo as StatefulWidgetClassInfo).increment!(widget);
  (widget.classInfo as StatefulWidgetClassInfo).increment!(widget);
  (widget.classInfo as StatefulWidgetClassInfo).increment!(widget);
  staticPrint('after 3 inc: ${widget}');
  (widget.classInfo as StatefulWidgetClassInfo).decrement!(widget);
  staticPrint('after 1 dec: ${widget}');
  (widget.classInfo as StatefulWidgetClassInfo).set_counter!(widget, 10);
  staticPrint('after set 10: ${widget}');
  staticPrint('\n--- 3. 深层 mixin 链 ---');
  final DeepMixinClassValue deep = DeepMixinClass_new(GC.allocateLocal(DeepMixinClassValue()));
  staticPrint('layer: ${(deep.classInfo as DeepMixinClassClassInfo).layer!(deep)}');
  staticPrint('allLayers: ${(deep.classInfo as DeepMixinClassClassInfo).allLayers!(deep)}');
  staticPrint('\n--- 4. 泛型 mixin ---');
  final BoxValue<int> intBox = Box_new<int>(GC.allocateLocal(BoxValue<int>()), 42);
  staticPrint('intBox: ${intBox}');
  staticPrint('describe: ${(intBox.classInfo as BoxClassInfo).describe!(intBox)}');
  staticPrint('mapValue: ${(intBox.classInfo as BoxClassInfo).mapValue_int!(intBox, ClosureEnv_main_2_new(GC.allocateLocal(ClosureEnv_main_2())))}');
  staticPrint('test >10: ${(intBox.classInfo as BoxClassInfo).test!(intBox, ClosureEnv_main_3_new(GC.allocateLocal(ClosureEnv_main_3())))}');
  staticPrint('test >100: ${(intBox.classInfo as BoxClassInfo).test!(intBox, ClosureEnv_main_4_new(GC.allocateLocal(ClosureEnv_main_4())))}');
  final BoxValue<String> strBox = Box_new<String>(GC.allocateLocal(BoxValue<String>()), 'dart');
  staticPrint('strBox mapValue: ${(strBox.classInfo as BoxClassInfo).mapValue_String!(strBox, ClosureEnv_main_5_new(GC.allocateLocal(ClosureEnv_main_5())))}');
  staticPrint('\n--- 5. 抽象+mixin+implements ---');
  final TaggedResourceValue res = TaggedResource_new(GC.allocateLocal(TaggedResourceValue()), 'r1', 'file');
  (res.classInfo as TaggedResourceClassInfo).tag!(res, 'important');
  (res.classInfo as TaggedResourceClassInfo).tag!(res, 'v2');
  staticPrint('describe: ${(res.classInfo as TaggedResourceClassInfo).describe!(res)}');
  staticPrint('id: ${res.id}');
  staticPrint('hasTag important: ${(res.classInfo as TaggedResourceClassInfo).hasTag!(res, 'important')}');
  staticPrint('hasTag draft: ${(res.classInfo as TaggedResourceClassInfo).hasTag!(res, 'draft')}');
  staticPrint('\n--- 6. super 调用链 ---');
  final BaseProcessorValue base = BaseProcessor_new(GC.allocateLocal(BaseProcessorValue()));
  staticPrint('base: ${(base.classInfo as BaseProcessorClassInfo).process!(base, '  hello  ')} (${(base.classInfo as BaseProcessorClassInfo).get_processorName!(base)})');
  final UpperProcessorValue upper = UpperProcessor_new(GC.allocateLocal(UpperProcessorValue()));
  staticPrint('upper: ${(upper.classInfo as UpperProcessorClassInfo).process!(upper, '  hello  ')} (${(upper.classInfo as UpperProcessorClassInfo).get_processorName!(upper)})');
  final PrefixProcessorValue prefix = PrefixProcessor_new(GC.allocateLocal(PrefixProcessorValue()), 'PRE');
  staticPrint('prefix: ${(prefix.classInfo as PrefixProcessorClassInfo).process!(prefix, '  hello  ')} (${(prefix.classInfo as PrefixProcessorClassInfo).get_processorName!(prefix)})');
  staticPrint('\n--- 7. mixin + operator ---');
  final AmountValue a1 = Amount_new(GC.allocateLocal(AmountValue()), 10);
  final AmountValue a2 = Amount_new(GC.allocateLocal(AmountValue()), 5);
  staticPrint('a1 + a2: ${(a1.classInfo as AmountClassInfo).operatorPlus!(a1, a2)}');
  staticPrint('a1 - a2: ${(a1.classInfo as AmountClassInfo).operatorMinus!(a1, a2)}');
  staticPrint('a1 < a2: ${(a1.classInfo as AmountClassInfo).operatorLt!(a1, a2)}');
  staticPrint('a1 > a2: ${(a1.classInfo as AmountClassInfo).operatorGt!(a1, a2)}');
  staticPrint('doubleValue: ${(a1.classInfo as AmountClassInfo).doubleValue!(a1)}');
  staticPrint('addValues: ${(a1.classInfo as AmountClassInfo).addValues!(a1, 3)}');
  staticPrint('\n--- 8. 多层继承+mixin ---');
  final CarValue car = Car_new(GC.allocateLocal(CarValue()), 'Toyota', 2024, 4);
  staticPrint('car: ${car}');
  (car.classInfo as CarClassInfo).prettyPrint!(car);
  final ElectricCarValue ev = ElectricCar_new(GC.allocateLocal(ElectricCarValue()), 'Tesla', 2025, 4, 500);
  staticPrint('ev: ${ev}');
  (ev.classInfo as ElectricCarClassInfo).prettyPrint!(ev);
  staticPrint('\n--- 9. mixin on 约束 ---');
  final SegmentValue seg = Segment_new(GC.allocateLocal(SegmentValue()), 10.0);
  staticPrint('seg: ${seg}');
  staticPrint('scale(2): ${(seg.classInfo as SegmentClassInfo).scale!(seg, 2.0)}');
  final WeightedSegmentValue wseg = WeightedSegment_new(GC.allocateLocal(WeightedSegmentValue()), 10.0, 0.5);
  staticPrint('wseg: ${wseg}');
  staticPrint('wseg.scale(3): ${(wseg.classInfo as WeightedSegmentClassInfo).scale!(wseg, 3.0)}');
  staticPrint('\n--- 10. 多 mixin 同名 getter ---');
  final MultiMixinEntityValue entity = MultiMixinEntity_new(GC.allocateLocal(MultiMixinEntityValue()));
  staticPrint('label: ${(entity.classInfo as MultiMixinEntityClassInfo).get_label!(entity)}');
  staticPrint('greet: ${(entity.classInfo as MultiMixinEntityClassInfo).greet!(entity)}');
  staticPrint('info: ${(entity.classInfo as MultiMixinEntityClassInfo).info!(entity)}');
  staticPrint('fullInfo: ${(entity.classInfo as MultiMixinEntityClassInfo).fullInfo!(entity)}');
  staticPrint('\n--- 11. 接口+mixin 覆盖 ---');
  final MultiEncoderValue multi = MultiEncoder_new(GC.allocateLocal(MultiEncoderValue()));
  staticPrint('multi.encode: ${(multi.classInfo as MultiEncoderClassInfo).encode!(multi, 'abc')}');
  staticPrint('multi.encodeAll: ${(multi.classInfo as MultiEncoderClassInfo).encodeAll!(multi, 'xyz')}');
  final CustomEncoderValue custom = CustomEncoder_new(GC.allocateLocal(CustomEncoderValue()));
  staticPrint('custom.encode: ${(custom.classInfo as CustomEncoderClassInfo).encode!(custom, 'abc')}');
  staticPrint('custom.encodeAll: ${(custom.classInfo as CustomEncoderClassInfo).encodeAll!(custom, 'xyz')}');
  staticPrint('\n--- 12. 泛型继承链 ---');
  final ContainerValue<int> c1 = Container_new<int>(GC.allocateLocal(ContainerValue<int>()), 42);
  staticPrint('c1: ${(c1.classInfo as ContainerClassInfo).describe!(c1)}');
  final LabeledContainerValue<String> c2 = LabeledContainer_new<String>(GC.allocateLocal(LabeledContainerValue<String>()), 'hello', 'greeting');
  staticPrint('c2: ${(c2.classInfo as LabeledContainerClassInfo).describe!(c2)}');
  final PriorityContainerValue<double> c3 = PriorityContainer_new<double>(GC.allocateLocal(PriorityContainerValue<double>()), 3.14, 'pi', 1);
  staticPrint('c3: ${(c3.classInfo as PriorityContainerClassInfo).describe!(c3)}');
  staticPrint('c3.content: ${(c3.classInfo as PriorityContainerClassInfo).get_content!(c3)}');
  staticPrint('\n--- 13. mixin 调用链 ---');
  final ChainClassValue chain1 = ChainClass_new(GC.allocateLocal(ChainClassValue()));
  staticPrint('chain1.fullChain: ${(chain1.classInfo as ChainClassClassInfo).fullChain!(chain1)}');
  staticPrint('chain1.step3: ${(chain1.classInfo as ChainClassClassInfo).step3!(chain1)}');
  final ChainSubClassValue chain2 = ChainSubClass_new(GC.allocateLocal(ChainSubClassValue()));
  staticPrint('chain2.fullChain: ${(chain2.classInfo as ChainSubClassClassInfo).fullChain!(chain2)}');
  staticPrint('chain2.step3: ${(chain2.classInfo as ChainSubClassClassInfo).step3!(chain2)}');
  staticPrint('\n--- 14. 表达式树 ---');
  final BinaryExprValue expr = BinaryExpr_new_add(NumberExpr_new(GC.allocateLocal(NumberExprValue()), 3.0), BinaryExpr_new_mul(NumberExpr_new(GC.allocateLocal(NumberExprValue()), 4.0), NumberExpr_new(GC.allocateLocal(NumberExprValue()), 5.0)));
  staticPrint('expr: ${(expr.classInfo as BinaryExprClassInfo).display!(expr)}');
  staticPrint('result: ${(expr.classInfo as BinaryExprClassInfo).evaluate!(expr)}');
  staticPrint('\n--- 15. 游戏角色 ---');
  final GameCharacterValue hero = GameCharacter_new(GC.allocateLocal(GameCharacterValue()), 'Hero');
  staticPrint((hero.classInfo as GameCharacterClassInfo).statusBars!(hero));
  final WarriorValue warrior = Warrior_new(GC.allocateLocal(WarriorValue()), 'Conan');
  staticPrint((warrior.classInfo as WarriorClassInfo).statusBars!(warrior));
  final MageValue mage = Mage_new(GC.allocateLocal(MageValue()), 'Gandalf');
  staticPrint((mage.classInfo as MageClassInfo).statusBars!(mage));
  staticPrint('\n=== 所有复杂 OOP 测试通过 ✅ ===');
  drainScheduler();
}

class ClosureEnv_anon_0 extends TypeFunction2<double, double, double> {
  ClosureEnv_anon_0();
  @override
  double call(double a, double b) => fnPtr(this, a, b);
}
ClosureEnv_anon_0 ClosureEnv_anon_0_new(ClosureEnv_anon_0 env_) {
  env_.fnPtr = ClosureEnv_anon_0_call;
  return env_;
}
double ClosureEnv_anon_0_call(AnyGC env__, double a, double b) {
  final env = env__ as ClosureEnv_anon_0;

  return (a + b);
}

class ClosureEnv_anon_1 extends TypeFunction2<double, double, double> {
  ClosureEnv_anon_1();
  @override
  double call(double a, double b) => fnPtr(this, a, b);
}
ClosureEnv_anon_1 ClosureEnv_anon_1_new(ClosureEnv_anon_1 env_) {
  env_.fnPtr = ClosureEnv_anon_1_call;
  return env_;
}
double ClosureEnv_anon_1_call(AnyGC env__, double a, double b) {
  final env = env__ as ClosureEnv_anon_1;

  return (a * b);
}

class ClosureEnv_main_2 extends TypeFunction1<int, int> {
  ClosureEnv_main_2();
  @override
  int call(int v) => fnPtr(this, v);
}
ClosureEnv_main_2 ClosureEnv_main_2_new(ClosureEnv_main_2 env_) {
  env_.fnPtr = ClosureEnv_main_2_call;
  return env_;
}
int ClosureEnv_main_2_call(AnyGC env__, int v) {
  final env = env__ as ClosureEnv_main_2;

  return (v * 2);
}

class ClosureEnv_main_3 extends TypeFunction1<bool, int> {
  ClosureEnv_main_3();
  @override
  bool call(int v) => fnPtr(this, v);
}
ClosureEnv_main_3 ClosureEnv_main_3_new(ClosureEnv_main_3 env_) {
  env_.fnPtr = ClosureEnv_main_3_call;
  return env_;
}
bool ClosureEnv_main_3_call(AnyGC env__, int v) {
  final env = env__ as ClosureEnv_main_3;

  return (v > 10);
}

class ClosureEnv_main_4 extends TypeFunction1<bool, int> {
  ClosureEnv_main_4();
  @override
  bool call(int v) => fnPtr(this, v);
}
ClosureEnv_main_4 ClosureEnv_main_4_new(ClosureEnv_main_4 env_) {
  env_.fnPtr = ClosureEnv_main_4_call;
  return env_;
}
bool ClosureEnv_main_4_call(AnyGC env__, int v) {
  final env = env__ as ClosureEnv_main_4;

  return (v > 100);
}

class ClosureEnv_main_5 extends TypeFunction1<String, String> {
  ClosureEnv_main_5();
  @override
  String call(String s) => fnPtr(this, s);
}
ClosureEnv_main_5 ClosureEnv_main_5_new(ClosureEnv_main_5 env_) {
  env_.fnPtr = ClosureEnv_main_5_call;
  return env_;
}
String ClosureEnv_main_5_call(AnyGC env__, String s) {
  final env = env__ as ClosureEnv_main_5;

  return s.toUpperCase();
}


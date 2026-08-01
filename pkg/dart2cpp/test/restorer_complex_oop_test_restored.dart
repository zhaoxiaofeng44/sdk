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
  String Function(AnyGC, String)? display;
  DiamondClassClassInfo() {
    get_prefix = DiamondClass_get_prefix;
    format = DiamondClass_format;
    display = DiamondClass_display;
  }
}

class DiamondClassValue extends DiamondClass_Object_Logger_FormatterValue {
  late String name;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DiamondClassClassInfo>(runtimeType, DiamondClassClassInfo.new);
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
  StatefulWidgetClassInfo() {
    get_counter = StatefulWidget_get_counter;
    increment = StatefulWidget_increment;
    decrement = StatefulWidget_decrement;
    get_counterStatus = StatefulWidget_get_counterStatus;
    set_counter = StatefulWidget_set_counter;
    toString_ = StatefulWidget_toString;
  }
}

class StatefulWidgetValue extends StatefulWidget_Object_StatefulMixinValue {
  late String id;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<StatefulWidgetClassInfo>(runtimeType, StatefulWidgetClassInfo.new);
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
  String Function(AnyGC)? allLayers;
  DeepMixinClassClassInfo() {
    layer = DeepMixinClass_layer;
    onlyA = DeepMixinClass_onlyA;
    onlyB = DeepMixinClass_onlyB;
    onlyC = DeepMixinClass_onlyC;
    allLayers = DeepMixinClass_allLayers;
  }
}

class DeepMixinClassValue extends DeepMixinClass_Object_LayerA_LayerB_LayerCValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DeepMixinClassClassInfo>(runtimeType, DeepMixinClassClassInfo.new);
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
  int Function(AnyGC, TypeFunction1<int, T>)? mapValue_int;
  String Function(AnyGC, TypeFunction1<String, T>)? mapValue_String;
  BoxClassInfo() {
    get_value = Box_get_value<T>;
    describe = Box_describe<T>;
    test = Box_test<T>;
    toString_ = Box_toString<T>;
    mapValue_int = Box_mapValue<T, int>;
    mapValue_String = Box_mapValue<T, String>;
  }
}

class BoxValue<T> extends Box_Object_Mappable_FilterableValue<T> {
  late T value;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<BoxClassInfo<T>>(runtimeType, BoxClassInfo<T>.new);
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
  String Function(AnyGC)? get_id;
  IdentifiableClassInfo() {
    get_id = Identifiable_get_id;
  }
}

class IdentifiableValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<IdentifiableClassInfo>(runtimeType, IdentifiableClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as IdentifiableClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as IdentifiableClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as IdentifiableClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

IdentifiableValue Identifiable_new(AnyGC this__) {
  final this_ = this__ as IdentifiableValue;
  return this_;
}

String Identifiable_get_id(AnyGC this_) {
  throw UnimplementedError('Identifiable.id is abstract');
}


class DescribableClassInfo extends ClassInfo {
  String Function(AnyGC)? describe;
  DescribableClassInfo() {
    describe = Describable_describe;
  }
}

class DescribableValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DescribableClassInfo>(runtimeType, DescribableClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as DescribableClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as DescribableClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as DescribableClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

DescribableValue Describable_new(AnyGC this__) {
  final this_ = this__ as DescribableValue;
  return this_;
}

String Describable_describe(AnyGC this_) {
  throw UnimplementedError('Describable.describe is abstract');
}


// mixin Taggable → static functions for delegation
void Taggable_tag(AnyGC this__, String t) {
  final dynamic this_ = this__;
  (this_._tags.classInfo as StaticListClassInfo).add!(this_._tags, t);
}

StaticList<String> Taggable_get_allTags(AnyGC this__) {
  final dynamic this_ = this__;
  return StaticList<String>.unmodifiable(this_._tags);
}

bool Taggable_hasTag(AnyGC this__, String t) {
  final dynamic this_ = this__;
  return (this_._tags.classInfo as StaticListClassInfo).contains!(this_._tags, t);
}


class ResourceClassInfo extends IdentifiableClassInfo {
  String Function(AnyGC)? describe;
  ResourceClassInfo() {
    get_id = Resource_get_id;
    describe = Resource_describe;
  }
}

class ResourceValue extends AnyGC implements IdentifiableValue, DescribableValue {
  late String id;
  late String type;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ResourceClassInfo>(runtimeType, ResourceClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as ResourceClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as ResourceClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as ResourceClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
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

String Resource_get_id(AnyGC this__) {
  final this_ = this__ as ResourceValue;
  return this_.id;
}


class TaggedResourceClassInfo extends TaggedResource_Resource_TaggableClassInfo {
  TaggedResourceClassInfo() {
    get_id = TaggedResource_get_id;
    describe = TaggedResource_describe;
    tag = TaggedResource_tag;
    get_allTags = TaggedResource_get_allTags;
    hasTag = TaggedResource_hasTag;
  }
}

class TaggedResourceValue extends TaggedResource_Resource_TaggableValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<TaggedResourceClassInfo>(runtimeType, TaggedResourceClassInfo.new);
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
  return '${Resource_describe(this_)}, tags=${((this_.classInfo as TaggedResourceClassInfo).get_allTags!(this_).classInfo as StaticListClassInfo).toString_!((this_.classInfo as TaggedResourceClassInfo).get_allTags!(this_))}';
}

String TaggedResource_get_id(AnyGC this__) {
  final this_ = this__ as TaggedResourceValue;
  return this_.id;
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
  String Function(AnyGC, String)? process;
  String Function(AnyGC)? get_processorName;
  BaseProcessorClassInfo() {
    process = BaseProcessor_process;
    get_processorName = BaseProcessor_get_processorName;
  }
}

class BaseProcessorValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<BaseProcessorClassInfo>(runtimeType, BaseProcessorClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as BaseProcessorClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as BaseProcessorClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as BaseProcessorClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
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
  UpperProcessorClassInfo() {
    process = UpperProcessor_process;
    get_processorName = UpperProcessor_get_processorName;
  }
}

class UpperProcessorValue extends BaseProcessorValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<UpperProcessorClassInfo>(runtimeType, UpperProcessorClassInfo.new);
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
  PrefixProcessorClassInfo() {
    process = PrefixProcessor_process;
    get_processorName = PrefixProcessor_get_processorName;
  }
}

class PrefixProcessorValue extends UpperProcessorValue {
  late String prefix;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<PrefixProcessorClassInfo>(runtimeType, PrefixProcessorClassInfo.new);
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
  AmountValue Function(AnyGC, AmountValue)? operatorPlus;
  AmountValue Function(AnyGC, AmountValue)? operatorMinus;
  bool Function(AnyGC, AmountValue)? operatorLt;
  bool Function(AnyGC, AmountValue)? operatorGt;
  AmountClassInfo() {
    get_numericValue = Amount_get_numericValue;
    addValues = Amount_addValues;
    doubleValue = Amount_doubleValue;
    operatorPlus = Amount_operatorPlus;
    operatorMinus = Amount_operatorMinus;
    operatorLt = Amount_operatorLt;
    operatorGt = Amount_operatorGt;
    toString_ = Amount_toString;
  }
}

class AmountValue extends Amount_Object_AddableValue {
  late int numericValue;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<AmountClassInfo>(runtimeType, AmountClassInfo.new);
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
  VehicleClassInfo() {
    toString_ = Vehicle_toString;
  }
}

class VehicleValue extends AnyGC {
  late String make;
  late int year;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<VehicleClassInfo>(runtimeType, VehicleClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as VehicleClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as VehicleClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as VehicleClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
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
  CarClassInfo() {
    toString_ = Car_toString;
    toPrettyString = Car_toPrettyString;
    prettyPrint = Car_prettyPrint;
  }
}

class CarValue extends Car_Vehicle_Printable2Value {
  late int doors;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<CarClassInfo>(runtimeType, CarClassInfo.new);
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
  ElectricCarClassInfo() {
    toString_ = ElectricCar_toString;
    toPrettyString = ElectricCar_toPrettyString;
    prettyPrint = ElectricCar_prettyPrint;
  }
}

class ElectricCarValue extends CarValue {
  late int range;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ElectricCarClassInfo>(runtimeType, ElectricCarClassInfo.new);
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
  double Function(AnyGC)? measure;
  MeasurableClassInfo() {
    measure = Measurable_measure;
  }
}

class MeasurableValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<MeasurableClassInfo>(runtimeType, MeasurableClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as MeasurableClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as MeasurableClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as MeasurableClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

MeasurableValue Measurable_new(AnyGC this__) {
  final this_ = this__ as MeasurableValue;
  return this_;
}

double Measurable_measure(AnyGC this_) {
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
  SegmentClassInfo() {
    measure = Segment_measure;
    scale = Segment_scale;
    measureInfo = Segment_measureInfo;
    toString_ = Segment_toString;
  }
}

class SegmentValue extends Segment_Measurable_ScalableValue {
  late double length;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<SegmentClassInfo>(runtimeType, SegmentClassInfo.new);
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
  WeightedSegmentClassInfo() {
    measure = WeightedSegment_measure;
    scale = WeightedSegment_scale;
    measureInfo = WeightedSegment_measureInfo;
    toString_ = WeightedSegment_toString;
  }
}

class WeightedSegmentValue extends SegmentValue {
  late double weight;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<WeightedSegmentClassInfo>(runtimeType, WeightedSegmentClassInfo.new);
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
  String Function(AnyGC)? fullInfo;
  MultiMixinEntityClassInfo() {
    get_label = MultiMixinEntity_get_label;
    greet = MultiMixinEntity_greet;
    info = MultiMixinEntity_info;
    fullInfo = MultiMixinEntity_fullInfo;
  }
}

class MultiMixinEntityValue extends MultiMixinEntity_Object_NamedMixin_DescribedMixinValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<MultiMixinEntityClassInfo>(runtimeType, MultiMixinEntityClassInfo.new);
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
  String Function(AnyGC, String)? encode;
  EncoderClassInfo() {
    encode = Encoder_encode;
  }
}

class EncoderValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<EncoderClassInfo>(runtimeType, EncoderClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as EncoderClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as EncoderClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as EncoderClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

EncoderValue Encoder_new(AnyGC this__) {
  final this_ = this__ as EncoderValue;
  return this_;
}

String Encoder_encode(AnyGC this_, String input) {
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
  String Function(AnyGC, String)? encodeAll;
  MultiEncoderClassInfo() {
    encode = MultiEncoder_encode;
    encodeAll = MultiEncoder_encodeAll;
  }
}

class MultiEncoderValue extends MultiEncoder_Object_Base64Mixin_HexMixinValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<MultiEncoderClassInfo>(runtimeType, MultiEncoderClassInfo.new);
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
  CustomEncoderClassInfo() {
    encode = CustomEncoder_encode;
    encodeAll = CustomEncoder_encodeAll;
  }
}

class CustomEncoderValue extends MultiEncoderValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<CustomEncoderClassInfo>(runtimeType, CustomEncoderClassInfo.new);
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
  String Function(AnyGC)? describe;
  T Function(AnyGC)? get_content;
  ContainerClassInfo() {
    describe = Container_describe<T>;
    get_content = Container_get_content<T>;
  }
}

class ContainerValue<T> extends AnyGC {
  late T item;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ContainerClassInfo<T>>(runtimeType, ContainerClassInfo<T>.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (item is AnyGC) (item as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as ContainerClassInfo<T>).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as ContainerClassInfo<T>).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as ContainerClassInfo<T>).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
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
  LabeledContainerClassInfo() {
    describe = LabeledContainer_describe<T>;
    get_content = LabeledContainer_get_content<T>;
  }
}

class LabeledContainerValue<T> extends ContainerValue<T> {
  late String label;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<LabeledContainerClassInfo<T>>(runtimeType, LabeledContainerClassInfo<T>.new);
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
  PriorityContainerClassInfo() {
    describe = PriorityContainer_describe<T>;
    get_content = PriorityContainer_get_content<T>;
  }
}

class PriorityContainerValue<T> extends LabeledContainerValue<T> {
  late int priority;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<PriorityContainerClassInfo<T>>(runtimeType, PriorityContainerClassInfo<T>.new);
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
  ChainClassClassInfo() {
    step1 = ChainClass_step1;
    step2 = ChainClass_step2;
    step3 = ChainClass_step3;
    fullChain = ChainClass_fullChain;
  }
}

class ChainClassValue extends ChainClass_Object_ChainMixinValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ChainClassClassInfo>(runtimeType, ChainClassClassInfo.new);
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
  ChainSubClassClassInfo() {
    step1 = ChainSubClass_step1;
    step2 = ChainSubClass_step2;
    step3 = ChainSubClass_step3;
    fullChain = ChainSubClass_fullChain;
  }
}

class ChainSubClassValue extends ChainClassValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ChainSubClassClassInfo>(runtimeType, ChainSubClassClassInfo.new);
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
  double Function(AnyGC)? evaluate;
  String Function(AnyGC)? display;
  Expression2ClassInfo() {
    evaluate = Expression2_evaluate;
    display = Expression2_display;
  }
}

class Expression2Value extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Expression2ClassInfo>(runtimeType, Expression2ClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as Expression2ClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as Expression2ClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as Expression2ClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

Expression2Value Expression2_new(AnyGC this__) {
  final this_ = this__ as Expression2Value;
  return this_;
}

double Expression2_evaluate(AnyGC this_) {
  throw UnimplementedError('Expression2.evaluate is abstract');
}

String Expression2_display(AnyGC this_) {
  throw UnimplementedError('Expression2.display is abstract');
}


class NumberExprClassInfo extends Expression2ClassInfo {
  NumberExprClassInfo() {
    evaluate = NumberExpr_evaluate;
    display = NumberExpr_display;
  }
}

class NumberExprValue extends Expression2Value {
  late double value;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<NumberExprClassInfo>(runtimeType, NumberExprClassInfo.new);
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
  BinaryExprClassInfo() {
    evaluate = BinaryExpr_evaluate;
    display = BinaryExpr_display;
  }
}

class BinaryExprValue extends Expression2Value {
  late Expression2Value left;
  late Expression2Value right;
  late String op;
  late TypeFunction2<double, double, double> _compute;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<BinaryExprClassInfo>(runtimeType, BinaryExprClassInfo.new);
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
  String Function(AnyGC)? statusBars;
  GameCharacterClassInfo() {
    get_maxHealth = GameCharacter_get_maxHealth;
    get_health = GameCharacter_get_health;
    healthBar = GameCharacter_healthBar;
    get_maxMana = GameCharacter_get_maxMana;
    get_mana = GameCharacter_get_mana;
    manaBar = GameCharacter_manaBar;
    get_maxStamina = GameCharacter_get_maxStamina;
    get_stamina = GameCharacter_get_stamina;
    staminaBar = GameCharacter_staminaBar;
    statusBars = GameCharacter_statusBars;
  }
}

class GameCharacterValue extends GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue {
  late String name;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<GameCharacterClassInfo>(runtimeType, GameCharacterClassInfo.new);
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
  WarriorClassInfo() {
    get_maxHealth = Warrior_get_maxHealth;
    get_health = Warrior_get_health;
    healthBar = Warrior_healthBar;
    get_maxMana = Warrior_get_maxMana;
    get_mana = Warrior_get_mana;
    manaBar = Warrior_manaBar;
    get_maxStamina = Warrior_get_maxStamina;
    get_stamina = Warrior_get_stamina;
    staminaBar = Warrior_staminaBar;
    statusBars = Warrior_statusBars;
  }
}

class WarriorValue extends GameCharacterValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<WarriorClassInfo>(runtimeType, WarriorClassInfo.new);
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
  MageClassInfo() {
    get_maxHealth = Mage_get_maxHealth;
    get_health = Mage_get_health;
    healthBar = Mage_healthBar;
    get_maxMana = Mage_get_maxMana;
    get_mana = Mage_get_mana;
    manaBar = Mage_manaBar;
    get_maxStamina = Mage_get_maxStamina;
    get_stamina = Mage_get_stamina;
    staminaBar = Mage_staminaBar;
    statusBars = Mage_statusBars;
  }
}

class MageValue extends GameCharacterValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<MageClassInfo>(runtimeType, MageClassInfo.new);
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
  String Function(AnyGC)? get_prefix;
  String Function(AnyGC, String)? format;
}

class DiamondClass_Object_LoggerValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DiamondClass_Object_LoggerClassInfo>(runtimeType, DiamondClass_Object_LoggerClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as DiamondClass_Object_LoggerClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as DiamondClass_Object_LoggerClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as DiamondClass_Object_LoggerClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class DiamondClass_Object_Logger_FormatterClassInfo extends DiamondClass_Object_LoggerClassInfo {
}

class DiamondClass_Object_Logger_FormatterValue extends DiamondClass_Object_LoggerValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DiamondClass_Object_Logger_FormatterClassInfo>(runtimeType, DiamondClass_Object_Logger_FormatterClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class StatefulWidget_Object_StatefulMixinClassInfo extends ClassInfo {
  int Function(AnyGC)? get_counter;
  void Function(AnyGC)? increment;
  void Function(AnyGC)? decrement;
  String Function(AnyGC)? get_counterStatus;
  void Function(AnyGC, int)? set_counter;
}

class StatefulWidget_Object_StatefulMixinValue extends AnyGC {
  late int _counter = 0;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<StatefulWidget_Object_StatefulMixinClassInfo>(runtimeType, StatefulWidget_Object_StatefulMixinClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as StatefulWidget_Object_StatefulMixinClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as StatefulWidget_Object_StatefulMixinClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as StatefulWidget_Object_StatefulMixinClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class DeepMixinClass_Object_LayerAClassInfo extends ClassInfo {
  String Function(AnyGC)? layer;
  String Function(AnyGC)? onlyA;
}

class DeepMixinClass_Object_LayerAValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DeepMixinClass_Object_LayerAClassInfo>(runtimeType, DeepMixinClass_Object_LayerAClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as DeepMixinClass_Object_LayerAClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as DeepMixinClass_Object_LayerAClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as DeepMixinClass_Object_LayerAClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class DeepMixinClass_Object_LayerA_LayerBClassInfo extends DeepMixinClass_Object_LayerAClassInfo {
  String Function(AnyGC)? onlyB;
}

class DeepMixinClass_Object_LayerA_LayerBValue extends DeepMixinClass_Object_LayerAValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DeepMixinClass_Object_LayerA_LayerBClassInfo>(runtimeType, DeepMixinClass_Object_LayerA_LayerBClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class DeepMixinClass_Object_LayerA_LayerB_LayerCClassInfo extends DeepMixinClass_Object_LayerA_LayerBClassInfo {
  String Function(AnyGC)? onlyC;
}

class DeepMixinClass_Object_LayerA_LayerB_LayerCValue extends DeepMixinClass_Object_LayerA_LayerBValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DeepMixinClass_Object_LayerA_LayerB_LayerCClassInfo>(runtimeType, DeepMixinClass_Object_LayerA_LayerB_LayerCClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Box_Object_MappableClassInfo<T> extends ClassInfo {
  T Function(AnyGC)? get_value;
  Function? mapValue;
  String Function(AnyGC)? describe;
}

class Box_Object_MappableValue<T> extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Box_Object_MappableClassInfo<T>>(runtimeType, Box_Object_MappableClassInfo<T>.new);
  @override
  String toString() {
    final fn = (classInfo as Box_Object_MappableClassInfo<T>).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as Box_Object_MappableClassInfo<T>).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as Box_Object_MappableClassInfo<T>).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class Box_Object_Mappable_FilterableClassInfo<T> extends Box_Object_MappableClassInfo<T> {
  bool Function(AnyGC, TypeFunction1<bool, T>)? test;
}

class Box_Object_Mappable_FilterableValue<T> extends Box_Object_MappableValue<T> {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Box_Object_Mappable_FilterableClassInfo<T>>(runtimeType, Box_Object_Mappable_FilterableClassInfo<T>.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class TaggedResource_Resource_TaggableClassInfo extends ResourceClassInfo {
  void Function(AnyGC, String)? tag;
  StaticList<String> Function(AnyGC)? get_allTags;
  bool Function(AnyGC, String)? hasTag;
}

class TaggedResource_Resource_TaggableValue extends ResourceValue {
  late StaticList<String> _tags = StaticList<String>();
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<TaggedResource_Resource_TaggableClassInfo>(runtimeType, TaggedResource_Resource_TaggableClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_tags is AnyGC) (_tags as AnyGC).gcMark(flag);
  }
}


class Amount_Object_AddableClassInfo extends ClassInfo {
  int Function(AnyGC)? get_numericValue;
  int Function(AnyGC, int)? addValues;
  int Function(AnyGC)? doubleValue;
}

class Amount_Object_AddableValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Amount_Object_AddableClassInfo>(runtimeType, Amount_Object_AddableClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as Amount_Object_AddableClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as Amount_Object_AddableClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as Amount_Object_AddableClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class Car_Vehicle_Printable2ClassInfo extends VehicleClassInfo {
  String Function(AnyGC)? toPrettyString;
  void Function(AnyGC)? prettyPrint;
}

class Car_Vehicle_Printable2Value extends VehicleValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Car_Vehicle_Printable2ClassInfo>(runtimeType, Car_Vehicle_Printable2ClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class Segment_Measurable_ScalableClassInfo extends MeasurableClassInfo {
  double Function(AnyGC, double)? scale;
  String Function(AnyGC)? measureInfo;
}

class Segment_Measurable_ScalableValue extends MeasurableValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Segment_Measurable_ScalableClassInfo>(runtimeType, Segment_Measurable_ScalableClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class MultiMixinEntity_Object_NamedMixinClassInfo extends ClassInfo {
  String Function(AnyGC)? get_label;
  String Function(AnyGC)? greet;
}

class MultiMixinEntity_Object_NamedMixinValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<MultiMixinEntity_Object_NamedMixinClassInfo>(runtimeType, MultiMixinEntity_Object_NamedMixinClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as MultiMixinEntity_Object_NamedMixinClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as MultiMixinEntity_Object_NamedMixinClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as MultiMixinEntity_Object_NamedMixinClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class MultiMixinEntity_Object_NamedMixin_DescribedMixinClassInfo extends MultiMixinEntity_Object_NamedMixinClassInfo {
  String Function(AnyGC)? info;
}

class MultiMixinEntity_Object_NamedMixin_DescribedMixinValue extends MultiMixinEntity_Object_NamedMixinValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<MultiMixinEntity_Object_NamedMixin_DescribedMixinClassInfo>(runtimeType, MultiMixinEntity_Object_NamedMixin_DescribedMixinClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class MultiEncoder_Object_Base64MixinClassInfo extends ClassInfo {
  String Function(AnyGC, String)? encode;
}

class MultiEncoder_Object_Base64MixinValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<MultiEncoder_Object_Base64MixinClassInfo>(runtimeType, MultiEncoder_Object_Base64MixinClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as MultiEncoder_Object_Base64MixinClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as MultiEncoder_Object_Base64MixinClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as MultiEncoder_Object_Base64MixinClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class MultiEncoder_Object_Base64Mixin_HexMixinClassInfo extends MultiEncoder_Object_Base64MixinClassInfo {
}

class MultiEncoder_Object_Base64Mixin_HexMixinValue extends MultiEncoder_Object_Base64MixinValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<MultiEncoder_Object_Base64Mixin_HexMixinClassInfo>(runtimeType, MultiEncoder_Object_Base64Mixin_HexMixinClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class ChainClass_Object_ChainMixinClassInfo extends ClassInfo {
  String Function(AnyGC)? step1;
  String Function(AnyGC)? step2;
  String Function(AnyGC)? step3;
  String Function(AnyGC)? fullChain;
}

class ChainClass_Object_ChainMixinValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ChainClass_Object_ChainMixinClassInfo>(runtimeType, ChainClass_Object_ChainMixinClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as ChainClass_Object_ChainMixinClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as ChainClass_Object_ChainMixinClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as ChainClass_Object_ChainMixinClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class GameCharacter_Object_HealthMixinClassInfo extends ClassInfo {
  int Function(AnyGC)? get_maxHealth;
  int Function(AnyGC)? get_health;
  String Function(AnyGC)? healthBar;
}

class GameCharacter_Object_HealthMixinValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<GameCharacter_Object_HealthMixinClassInfo>(runtimeType, GameCharacter_Object_HealthMixinClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as GameCharacter_Object_HealthMixinClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as GameCharacter_Object_HealthMixinClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as GameCharacter_Object_HealthMixinClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}


class GameCharacter_Object_HealthMixin_ManaMixinClassInfo extends GameCharacter_Object_HealthMixinClassInfo {
  int Function(AnyGC)? get_maxMana;
  int Function(AnyGC)? get_mana;
  String Function(AnyGC)? manaBar;
}

class GameCharacter_Object_HealthMixin_ManaMixinValue extends GameCharacter_Object_HealthMixinValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<GameCharacter_Object_HealthMixin_ManaMixinClassInfo>(runtimeType, GameCharacter_Object_HealthMixin_ManaMixinClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinClassInfo extends GameCharacter_Object_HealthMixin_ManaMixinClassInfo {
  int Function(AnyGC)? get_maxStamina;
  int Function(AnyGC)? get_stamina;
  String Function(AnyGC)? staminaBar;
}

class GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinValue extends GameCharacter_Object_HealthMixin_ManaMixinValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinClassInfo>(runtimeType, GameCharacter_Object_HealthMixin_ManaMixin_StaminaMixinClassInfo.new);
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
  staticPrint('describe: ${(intBox.classInfo as BoxClassInfo<int>).describe!(intBox)}');
  staticPrint('mapValue: ${(intBox.classInfo as BoxClassInfo<int>).mapValue_int!(intBox, ClosureEnv_main_2_new(GC.allocateLocal(ClosureEnv_main_2())))}');
  staticPrint('test >10: ${(intBox.classInfo as BoxClassInfo<int>).test!(intBox, ClosureEnv_main_3_new(GC.allocateLocal(ClosureEnv_main_3())))}');
  staticPrint('test >100: ${(intBox.classInfo as BoxClassInfo<int>).test!(intBox, ClosureEnv_main_4_new(GC.allocateLocal(ClosureEnv_main_4())))}');
  final BoxValue<String> strBox = Box_new<String>(GC.allocateLocal(BoxValue<String>()), 'dart');
  staticPrint('strBox mapValue: ${(strBox.classInfo as BoxClassInfo<String>).mapValue_String!(strBox, ClosureEnv_main_5_new(GC.allocateLocal(ClosureEnv_main_5())))}');
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
  staticPrint('c1: ${(c1.classInfo as ContainerClassInfo<int>).describe!(c1)}');
  final LabeledContainerValue<String> c2 = LabeledContainer_new<String>(GC.allocateLocal(LabeledContainerValue<String>()), 'hello', 'greeting');
  staticPrint('c2: ${(c2.classInfo as LabeledContainerClassInfo<String>).describe!(c2)}');
  final PriorityContainerValue<double> c3 = PriorityContainer_new<double>(GC.allocateLocal(PriorityContainerValue<double>()), 3.14, 'pi', 1);
  staticPrint('c3: ${(c3.classInfo as PriorityContainerClassInfo<double>).describe!(c3)}');
  staticPrint('c3.content: ${(c3.classInfo as PriorityContainerClassInfo<double>).get_content!(c3)}');
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


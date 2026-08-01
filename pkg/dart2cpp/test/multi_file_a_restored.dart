import 'package:dart2cpp/platform/dart/runtime_classes.dart';


class AnimalClassInfo extends ClassInfo {
  String Function(AnyGC)? speak;
  AnimalClassInfo() {
    speak = Animal_speak;
  }
}

class AnimalValue extends AnyGC {
  late String name;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<AnimalClassInfo>(runtimeType, AnimalClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as AnimalClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as AnimalClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as AnimalClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

AnimalValue Animal_new(AnyGC this__, String name) {
  final this_ = this__ as AnimalValue;
  this_.name = name;
  return this_;
}

String Animal_speak(AnyGC this__) {
  final this_ = this__ as AnimalValue;
  return '${this_.name} makes a sound';
}


class DogClassInfo extends AnimalClassInfo {
  DogClassInfo() {
    speak = Dog_speak;
  }
}

class DogValue extends AnimalValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<DogClassInfo>(runtimeType, DogClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DogValue Dog_new(AnyGC this__, String name) {
  final this_ = this__ as DogValue;
  Animal_new(this_, name);
  return this_;
}

String Dog_speak(AnyGC this__) {
  final this_ = this__ as DogValue;
  return '${this_.name} says Woof!';
}


void greetFromA(AnimalValue a) {
  staticPrint((a.classInfo as AnimalClassInfo).speak!(a));
}


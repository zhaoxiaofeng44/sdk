import 'package:dart2cpp/platform/dart/runtime_classes.dart';


class AnimalValue extends VPtr {
  late String name;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['speak'] = Animal_speak;
    }
    return vptrMap!;
  }
}

AnimalValue Animal_new(dynamic this__, String name) {
  final this_ = this__ as AnimalValue;
  this_.name = name;
  return this_;
}

String Animal_speak(dynamic this__) {
  final this_ = this__ as AnimalValue;
  return '${this_.name} makes a sound';
}


class DogValue extends AnimalValue {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = Map<String, dynamic>.from(AnimalValue.getVptrMap());
      vptrMap!['speak'] = Dog_speak;
    }
    return vptrMap!;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DogValue Dog_new(dynamic this__, String name) {
  final this_ = this__ as DogValue;
  Animal_new(this_, name);
  return this_;
}

String Dog_speak(dynamic this__) {
  final this_ = this__ as DogValue;
  return '${this_.name} says Woof!';
}


void greetFromA(AnimalValue a) {
  staticPrint((a.vptr['speak'] as String Function(dynamic))(a));
}


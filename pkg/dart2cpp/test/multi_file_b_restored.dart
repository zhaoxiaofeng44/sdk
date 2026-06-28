import 'package:dart2cpp/platform/dart/runtime_classes.dart';

import 'multi_file_a_restored.dart' as lib_1;

class CatValue extends lib_1.AnimalValue {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = Map<String, dynamic>.from(lib_1.AnimalValue.getVptrMap());
      vptrMap!['speak'] = Cat_speak;
    }
    return vptrMap!;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CatValue Cat_new(dynamic this__, String name) {
  final this_ = this__ as CatValue;
  lib_1.Animal_new(this_, name);
  return this_;
}

String Cat_speak(dynamic this__) {
  final this_ = this__ as CatValue;
  return '${this_.name} says Meow!';
}


void greetFromB(lib_1.AnimalValue a) {
  staticPrint('B: ${(a.vptr['speak'] as String Function(dynamic))(a)}');
}


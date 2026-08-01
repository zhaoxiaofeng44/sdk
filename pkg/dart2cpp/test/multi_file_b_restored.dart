import 'package:dart2cpp/platform/dart/runtime_classes.dart';

import 'multi_file_a_restored.dart' as lib_1;

class CatClassInfo extends AnimalClassInfo {
  CatClassInfo() {
    speak = Cat_speak;
  }
}

class CatValue extends lib_1.AnimalValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<CatClassInfo>(runtimeType, CatClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CatValue Cat_new(AnyGC this__, String name) {
  final this_ = this__ as CatValue;
  lib_1.Animal_new(this_, name);
  return this_;
}

String Cat_speak(AnyGC this__) {
  final this_ = this__ as CatValue;
  return '${this_.name} says Meow!';
}


void greetFromB(lib_1.AnimalValue a) {
  staticPrint('B: ${(a.classInfo as AnimalClassInfo).speak!(a)}');
}


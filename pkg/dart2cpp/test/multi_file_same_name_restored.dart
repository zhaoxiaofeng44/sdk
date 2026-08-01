import 'package:dart2cpp/platform/dart/runtime_classes.dart';


class AnimalClassInfo extends ClassInfo {
  String Function(AnyGC)? describe;
  AnimalClassInfo() {
    describe = Animal_describe;
  }
}

class AnimalValue extends AnyGC {
  late String species;
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

AnimalValue Animal_new(AnyGC this__, String species) {
  final this_ = this__ as AnimalValue;
  this_.species = species;
  return this_;
}

String Animal_describe(AnyGC this__) {
  final this_ = this__ as AnimalValue;
  return 'Species: ${this_.species}';
}


void describeAnimal(AnimalValue a) {
  staticPrint((a.classInfo as AnimalClassInfo).describe!(a));
}


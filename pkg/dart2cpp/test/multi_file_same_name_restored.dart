import 'package:dart2cpp/platform/dart/runtime_classes.dart';


class AnimalValue extends VPtr {
  late String species;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['describe'] = Animal_describe;
    }
    return vptrMap!;
  }
}

AnimalValue Animal_new(dynamic this__, String species) {
  final this_ = this__ as AnimalValue;
  this_.species = species;
  return this_;
}

String Animal_describe(dynamic this__) {
  final this_ = this__ as AnimalValue;
  return 'Species: ${this_.species}';
}


void describeAnimal(AnimalValue a) {
  staticPrint((a.vptr['describe'] as String Function(dynamic))(a));
}


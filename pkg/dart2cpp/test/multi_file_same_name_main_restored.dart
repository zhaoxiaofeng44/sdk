import 'package:dart2cpp/platform/dart/runtime_classes.dart';

import 'multi_file_a_restored.dart' as lib_1;
import 'multi_file_same_name_restored.dart' as lib_2;

void main() {
  final lib_1.DogValue dogA = lib_1.Dog_new(GC.allocateLocal(lib_1.DogValue()), 'Buddy');
  staticPrint('From A: ${(dogA.classInfo as DogClassInfo).speak!(dogA)}');
  final lib_2.AnimalValue animalC = lib_2.Animal_new(GC.allocateLocal(lib_2.AnimalValue()), 'Tiger');
  staticPrint('From C: ${(animalC.classInfo as AnimalClassInfo).describe!(animalC)}');
  lib_1.greetFromA(dogA);
  lib_2.describeAnimal(animalC);
  drainScheduler();
}


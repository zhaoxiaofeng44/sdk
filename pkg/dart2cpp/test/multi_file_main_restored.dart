import 'package:dart2cpp/platform/dart/runtime_classes.dart';

import 'multi_file_a_restored.dart' as lib_1;
import 'multi_file_b_restored.dart' as lib_2;

void main() {
  final lib_1.DogValue dog = lib_1.Dog_new(GC.allocateLocal(lib_1.DogValue()), 'Buddy');
  final lib_2.CatValue cat = lib_2.Cat_new(GC.allocateLocal(lib_2.CatValue()), 'Whiskers');
  lib_1.greetFromA(dog);
  lib_1.greetFromA(cat);
  lib_2.greetFromB(dog);
  lib_2.greetFromB(cat);
  drainScheduler();
}


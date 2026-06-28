// File B: defines Cat and uses Animal from A
import 'multi_file_a.dart';

class Cat extends Animal {
  Cat(super.name);
  @override
  String speak() => '${name} says Meow!';
}

void greetFromB(Animal a) {
  print('B: ${a.speak()}');
}

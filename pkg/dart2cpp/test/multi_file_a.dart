// File A: defines Animal and Dog
class Animal {
  String name;
  Animal(this.name);
  String speak() => '$name makes a sound';
}

class Dog extends Animal {
  Dog(super.name);
  @override
  String speak() => '${name} says Woof!';
}

void greetFromA(Animal a) {
  print(a.speak());
}

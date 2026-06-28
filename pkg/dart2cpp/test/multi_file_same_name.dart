// File C: defines another Animal class to test name isolation
class Animal {
  String species;
  Animal(this.species);
  String describe() => 'Species: $species';
}

void describeAnimal(Animal a) {
  print(a.describe());
}

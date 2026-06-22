class Animal {
  String name;
  int age;

  Animal(this.name, this.age);

  String speak() {
    return '$name says hello';
  }

  String toString() {
    return 'Animal($name, age=$age)';
  }
}

class Dog extends Animal {
  String breed;

  Dog(String name, int age, this.breed) : super(name, age);

  @override
  String speak() {
    return '$name barks!';
  }

  @override
  String toString() {
    return 'Dog($name, age=$age, breed=$breed)';
  }
}

class Cat extends Animal {
  bool isIndoor;

  Cat(String name, int age, this.isIndoor) : super(name, age);

  @override
  String speak() {
    return '$name meows!';
  }
}

void main() {
  var dog = Dog('Rex', 5, 'German Shepherd');
  var cat = Cat('Whiskers', 3, true);

  print(dog.speak());
  print(cat.speak());
  print(dog.toString());

  // 多态
  List<Animal> animals = [dog, cat];
  for (var animal in animals) {
    print(animal.speak());
  }
}

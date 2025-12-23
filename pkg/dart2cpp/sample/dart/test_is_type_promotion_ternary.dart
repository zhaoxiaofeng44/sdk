// 测试三元表达式中的 is 类型推断和类型提升

class Animal {
  String name;
  Animal(this.name);
}

class Dog extends Animal {
  String breed;

  Dog(String name, this.breed) : super(name);

  void bark() {
    print('$name says: Woof! Woof!');
  }
}

class Cat extends Animal {
  bool isLazy;

  Cat(String name, this.isLazy) : super(name);

  void meow() {
    print('$name says: Meow!');
  }
}

void main() {
  // 测试1: 简单的 is 检查在三元表达式条件中
  Animal animal1 = Dog('Rex', 'Labrador');
  var result1 = animal1 is Dog ? animal1.bark() : print('Not a dog');

  // 测试2: is 检查 && 另一个条件
  Animal animal2 = Cat('Whiskers', true);
  var result2 = animal2 is Cat && animal2.isLazy
      ? animal2.meow()
      : print('Not a lazy cat');

  // 测试3: 多个 is 检查用 && 连接
  var obj1 = 'Hello';
  var obj2 = 42;
  var result3 = obj1 is String && obj2 is int
      ? print('${obj1.length} and $obj2')
      : print('Type mismatch');

  // 测试4: 复杂的 && 链式条件
  Animal animal3 = Dog('Buddy', 'Golden Retriever');
  var result4 =
      animal3 is Dog && animal3.breed.length > 5 && animal3.name.length > 3
          ? print('Long breed name: ${animal3.breed}')
          : print('Short name');

  // 测试5: 嵌套三元表达式中的 is 检查
  Animal animal4 = Cat('Tom', false);
  var result5 = animal4 is Cat
      ? (animal4.isLazy ? print('Lazy cat') : animal4.meow())
      : print('Not a cat');
}

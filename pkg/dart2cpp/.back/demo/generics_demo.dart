/// 泛型演示
/// 
/// 测试泛型类、泛型方法、类型约束等泛型特性

void main() {
  print('🔥 泛型演示开始');
  
  // 1. 泛型类
  testGenericClasses();
  
  // 2. 泛型方法
  testGenericMethods();
  
  // 3. 类型约束
  testTypeConstraints();
  
  // 4. 泛型集合
  testGenericCollections();
  
  // 5. 协变和逆变
  testVariance();
  
  print('✅ 泛型演示完成');
}

/// 测试泛型类
void testGenericClasses() {
  print('\n📌 测试泛型类');
  
  // 基本泛型类
  var intBox = Box<int>(42);
  var stringBox = Box<String>('Hello');
  var boolBox = Box<bool>(true);
  
  print('  整数盒子: ${intBox.getValue()}');
  print('  字符串盒子: ${stringBox.getValue()}');
  print('  布尔盒子: ${boolBox.getValue()}');
  
  // 修改值
  intBox.setValue(100);
  stringBox.setValue('World');
  
  print('  修改后整数盒子: ${intBox.getValue()}');
  print('  修改后字符串盒子: ${stringBox.getValue()}');
  
  // 多泛型参数
  var pair = Pair<String, int>('Alice', 25);
  print('  键值对: ${pair.first} -> ${pair.second}');
  
  pair.swap();
  print('  交换后: ${pair.first} -> ${pair.second}');
  
  // 嵌套泛型
  var nestedBox = Box<Box<String>>(Box<String>('Nested'));
  print('  嵌套盒子: ${nestedBox.getValue().getValue()}');
  
  // 泛型继承
  var numberContainer = NumberContainer<int>(42);
  numberContainer.add(10);
  print('  数字容器: ${numberContainer.getValue()}');
  
  var doubleContainer = NumberContainer<double>(3.14);
  doubleContainer.multiply(2.0);
  print('  浮点容器: ${doubleContainer.getValue()}');
}

/// 测试泛型方法
void testGenericMethods() {
  print('\n📌 测试泛型方法');
  
  // 基本泛型方法
  String stringResult = identity<String>('Hello');
  int intResult = identity<int>(42);
  bool boolResult = identity<bool>(true);
  
  print('  identity<String>: $stringResult');
  print('  identity<int>: $intResult');
  print('  identity<bool>: $boolResult');
  
  // 类型推断
  var inferredString = identity('Inferred'); // 推断为 String
  var inferredInt = identity(100); // 推断为 int
  
  print('  推断字符串: $inferredString');
  print('  推断整数: $inferredInt');
  
  // 泛型方法交换
  var a = 'First';
  var b = 'Second';
  var swapped = swap<String>(a, b);
  print('  交换前: $a, $b');
  print('  交换后: ${swapped.first}, ${swapped.second}');
  
  // 泛型列表操作
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> strings = ['a', 'b', 'c'];
  
  int firstNumber = getFirst<int>(numbers);
  String firstString = getFirst<String>(strings);
  
  print('  第一个数字: $firstNumber');
  print('  第一个字符串: $firstString');
  
  // 泛型转换
  List<String> numberStrings = map<int, String>(numbers, (n) => 'Number: $n');
  print('  转换结果: $numberStrings');
  
  // 泛型过滤
  List<int> evenNumbers = filter<int>(numbers, (n) => n % 2 == 0);
  print('  偶数过滤: $evenNumbers');
}

/// 测试类型约束
void testTypeConstraints() {
  print('\n📌 测试类型约束');
  
  // 数字约束
  var intCalculator = NumberCalculator<int>();
  var doubleCalculator = NumberCalculator<double>();
  
  print('  整数计算: ${intCalculator.add(5, 3)}');
  print('  浮点计算: ${doubleCalculator.add(2.5, 1.5)}');
  
  // 比较约束
  var intComparator = Comparator<int>();
  var stringComparator = Comparator<String>();
  
  print('  整数比较: ${intComparator.max(10, 5)}');
  print('  字符串比较: ${stringComparator.max('apple', 'banana')}');
  
  // 可序列化约束
  var person = Person('Alice', 25);
  var student = Student('Bob', 20, 'S001');
  
  var personSerializer = Serializer<Person>();
  var studentSerializer = Serializer<Student>();
  
  print('  人员序列化: ${personSerializer.serialize(person)}');
  print('  学生序列化: ${studentSerializer.serialize(student)}');
  
  // 集合约束
  var listProcessor = CollectionProcessor<List<int>>();
  var setProcessor = CollectionProcessor<Set<String>>();
  
  print('  列表大小: ${listProcessor.getSize([1, 2, 3, 4, 5])}');
  print('  集合大小: ${setProcessor.getSize({'a', 'b', 'c'})}');
}

/// 测试泛型集合
void testGenericCollections() {
  print('\n📌 测试泛型集合');
  
  // 自定义泛型列表
  var intList = GenericList<int>();
  intList.add(1);
  intList.add(2);
  intList.add(3);
  
  print('  自定义列表: ${intList.toList()}');
  print('  列表大小: ${intList.size}');
  print('  获取索引1: ${intList.get(1)}');
  
  // 自定义泛型栈
  var stringStack = GenericStack<String>();
  stringStack.push('First');
  stringStack.push('Second');
  stringStack.push('Third');
  
  print('  栈顶元素: ${stringStack.peek()}');
  print('  弹出元素: ${stringStack.pop()}');
  print('  栈大小: ${stringStack.size}');
  
  // 自定义泛型队列
  var intQueue = GenericQueue<int>();
  intQueue.enqueue(10);
  intQueue.enqueue(20);
  intQueue.enqueue(30);
  
  print('  队列前端: ${intQueue.front()}');
  print('  出队元素: ${intQueue.dequeue()}');
  print('  队列大小: ${intQueue.size}');
  
  // 泛型映射
  var stringIntMap = GenericMap<String, int>();
  stringIntMap.put('one', 1);
  stringIntMap.put('two', 2);
  stringIntMap.put('three', 3);
  
  print('  映射获取: ${stringIntMap.get('two')}');
  print('  映射大小: ${stringIntMap.size}');
  print('  所有键: ${stringIntMap.keys()}');
}

/// 测试协变和逆变
void testVariance() {
  print('\n📌 测试协变和逆变');
  
  // 协变示例 (covariant)
  var animalList = <Animal>[Dog('Buddy'), Cat('Whiskers')];
  var dogList = <Dog>[Dog('Max'), Dog('Rex')];
  
  // 协变：List<Dog> 可以赋值给 List<Animal>
  List<Animal> animals = dogList; // 这在 Dart 中是允许的
  
  print('  动物列表:');
  for (var animal in animals) {
    print('    ${animal.name} 说: ${animal.makeSound()}');
  }
  
  // 函数类型的协变和逆变
  Function(Animal) animalHandler = (Animal animal) {
    print('    处理动物: ${animal.name}');
  };
  
  Function(Dog) dogHandler = (Dog dog) {
    print('    处理狗: ${dog.name}, 品种: ${dog.breed}');
  };
  
  // 逆变：Function(Animal) 可以处理 Dog
  dogHandler = animalHandler; // 逆变
  dogHandler(Dog('Covariant Dog'));
  
  // 泛型方法的协变
  var processor = AnimalProcessor<Dog>();
  processor.process(Dog('Generic Dog'));
  
  // 使用协变处理不同类型
  processAnimals([Dog('Dog1'), Cat('Cat1')]);
}

// ============================================================================
// 泛型类定义
// ============================================================================

/// 基本泛型盒子类
class Box<T> {
  T _value;
  
  Box(this._value);
  
  T getValue() => _value;
  void setValue(T value) => _value = value;
  
  @override
  String toString() => 'Box<$T>($_value)';
}

/// 多泛型参数类
class Pair<T, U> {
  T first;
  U second;
  
  Pair(this.first, this.second);
  
  void swap() {
    var temp = first;
    first = second as T;
    second = temp as U;
  }
  
  @override
  String toString() => 'Pair<$T, $U>($first, $second)';
}

/// 带约束的泛型类
class NumberContainer<T extends num> extends Box<T> {
  NumberContainer(T value) : super(value);
  
  void add(T value) {
    setValue(getValue() + value as T);
  }
  
  void multiply(T value) {
    setValue(getValue() * value as T);
  }
}

/// 数字计算器（类型约束）
class NumberCalculator<T extends num> {
  T add(T a, T b) => a + b as T;
  T subtract(T a, T b) => a - b as T;
  T multiply(T a, T b) => a * b as T;
  T divide(T a, T b) => a / b as T;
}

/// 比较器（Comparable 约束）
class Comparator<T extends Comparable<T>> {
  T max(T a, T b) => a.compareTo(b) > 0 ? a : b;
  T min(T a, T b) => a.compareTo(b) < 0 ? a : b;
  
  List<T> sort(List<T> items) {
    var sorted = List<T>.from(items);
    sorted.sort();
    return sorted;
  }
}

/// 可序列化接口
abstract class Serializable {
  String serialize();
}

/// 序列化器（接口约束）
class Serializer<T extends Serializable> {
  String serialize(T object) {
    return object.serialize();
  }
}

/// 集合处理器（集合约束）
class CollectionProcessor<T extends Iterable> {
  int getSize(T collection) => collection.length;
  bool isEmpty(T collection) => collection.isEmpty;
  bool isNotEmpty(T collection) => collection.isNotEmpty;
}

// ============================================================================
// 自定义泛型集合
// ============================================================================

/// 泛型列表
class GenericList<T> {
  final List<T> _items = <T>[];
  
  void add(T item) => _items.add(item);
  void remove(T item) => _items.remove(item);
  T get(int index) => _items[index];
  void set(int index, T item) => _items[index] = item;
  
  int get size => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  
  List<T> toList() => List<T>.from(_items);
  
  void clear() => _items.clear();
}

/// 泛型栈
class GenericStack<T> {
  final List<T> _items = <T>[];
  
  void push(T item) => _items.add(item);
  
  T pop() {
    if (_items.isEmpty) throw StateError('Stack is empty');
    return _items.removeLast();
  }
  
  T peek() {
    if (_items.isEmpty) throw StateError('Stack is empty');
    return _items.last;
  }
  
  int get size => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  
  void clear() => _items.clear();
}

/// 泛型队列
class GenericQueue<T> {
  final List<T> _items = <T>[];
  
  void enqueue(T item) => _items.add(item);
  
  T dequeue() {
    if (_items.isEmpty) throw StateError('Queue is empty');
    return _items.removeAt(0);
  }
  
  T front() {
    if (_items.isEmpty) throw StateError('Queue is empty');
    return _items.first;
  }
  
  int get size => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  
  void clear() => _items.clear();
}

/// 泛型映射
class GenericMap<K, V> {
  final Map<K, V> _items = <K, V>{};
  
  void put(K key, V value) => _items[key] = value;
  V? get(K key) => _items[key];
  void remove(K key) => _items.remove(key);
  
  int get size => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  
  Iterable<K> keys() => _items.keys;
  Iterable<V> values() => _items.values;
  
  bool containsKey(K key) => _items.containsKey(key);
  bool containsValue(V value) => _items.containsValue(value);
  
  void clear() => _items.clear();
}

// ============================================================================
// 协变逆变示例类
// ============================================================================

/// 动物基类
class Animal {
  String name;
  Animal(this.name);
  String makeSound() => '$name makes a sound';
}

/// 狗类
class Dog extends Animal {
  String breed;
  Dog(String name, [this.breed = 'Unknown']) : super(name);
  
  @override
  String makeSound() => '$name barks';
}

/// 猫类
class Cat extends Animal {
  Cat(String name) : super(name);
  
  @override
  String makeSound() => '$name meows';
}

/// 动物处理器
class AnimalProcessor<T extends Animal> {
  void process(T animal) {
    print('    处理 ${T.toString()}: ${animal.makeSound()}');
  }
}

/// 人员类（实现序列化）
class Person implements Serializable {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  @override
  String serialize() => 'Person{name: $name, age: $age}';
}

/// 学生类（继承人员，实现序列化）
class Student extends Person {
  String studentId;
  
  Student(String name, int age, this.studentId) : super(name, age);
  
  @override
  String serialize() => 'Student{name: $name, age: $age, id: $studentId}';
}

// ============================================================================
// 泛型方法
// ============================================================================

/// 身份函数
T identity<T>(T value) => value;

/// 交换函数
Pair<T, T> swap<T>(T first, T second) => Pair<T, T>(second, first);

/// 获取第一个元素
T getFirst<T>(List<T> list) {
  if (list.isEmpty) throw StateError('List is empty');
  return list.first;
}

/// 映射函数
List<U> map<T, U>(List<T> list, U Function(T) mapper) {
  return list.map(mapper).toList();
}

/// 过滤函数
List<T> filter<T>(List<T> list, bool Function(T) predicate) {
  return list.where(predicate).toList();
}

/// 处理动物列表（协变示例）
void processAnimals(List<Animal> animals) {
  print('  处理动物列表:');
  for (var animal in animals) {
    print('    ${animal.makeSound()}');
  }
}
/// 泛型测试用例
/// 
/// 测试Dart泛型特性，包括：
/// - 泛型类
/// - 泛型方法
/// - 类型约束
/// - 协变和逆变
/// - 泛型集合

void main() {
  print('🔥 泛型测试开始');
  
  // 1. 泛型类测试
  testGenericClasses();
  
  // 2. 泛型方法测试
  testGenericMethods();
  
  // 3. 类型约束测试
  testTypeConstraints();
  
  // 4. 泛型集合测试
  testGenericCollections();
  
  // 5. 协变和逆变测试
  testVariance();
  
  // 6. 泛型接口测试
  testGenericInterfaces();
  
  print('✅ 泛型测试完成');
}

/// 测试泛型类
void testGenericClasses() {
  print('\n📌 测试泛型类');
  
  // 基本泛型类
  var intBox = Box<int>(42);
  var stringBox = Box<String>('Hello');
  var boolBox = Box<bool>(true);
  
  print('  基本泛型类:');
  print('    整数盒子: ${intBox.getValue()}');
  print('    字符串盒子: ${stringBox.getValue()}');
  print('    布尔盒子: ${boolBox.getValue()}');
  
  // 修改值
  intBox.setValue(100);
  stringBox.setValue('World');
  
  print('  修改后:');
  print('    整数盒子: ${intBox.getValue()}');
  print('    字符串盒子: ${stringBox.getValue()}');
  
  // 多泛型参数
  var pair = Pair<String, int>('Alice', 25);
  print('  多泛型参数:');
  print('    键值对: ${pair.first} -> ${pair.second}');
  
  pair.swap();
  print('    交换后: ${pair.first} -> ${pair.second}');
  
  // 嵌套泛型
  var nestedBox = Box<Box<String>>(Box<String>('Nested'));
  print('  嵌套泛型: ${nestedBox.getValue().getValue()}');
  
  // 泛型继承
  var numberContainer = NumberContainer<int>(42);
  numberContainer.add(10);
  print('  泛型继承: ${numberContainer.getValue()}');
  
  var doubleContainer = NumberContainer<double>(3.14);
  doubleContainer.multiply(2.0);
  print('  浮点容器: ${doubleContainer.getValue()}');
  
  // 泛型工厂
  var factory = ContainerFactory<String>();
  var container1 = factory.create('Hello');
  var container2 = factory.create('World');
  
  print('  泛型工厂:');
  print('    容器1: ${container1.getValue()}');
  print('    容器2: ${container2.getValue()}');
}

/// 测试泛型方法
void testGenericMethods() {
  print('\n📌 测试泛型方法');
  
  // 基本泛型方法
  String stringResult = identity<String>('Hello');
  int intResult = identity<int>(42);
  bool boolResult = identity<bool>(true);
  
  print('  基本泛型方法:');
  print('    identity<String>: $stringResult');
  print('    identity<int>: $intResult');
  print('    identity<bool>: $boolResult');
  
  // 类型推断
  var inferredString = identity('Inferred'); // 推断为 String
  var inferredInt = identity(100); // 推断为 int
  
  print('  类型推断:');
  print('    推断字符串: $inferredString');
  print('    推断整数: $inferredInt');
  
  // 泛型方法交换
  var a = 'First';
  var b = 'Second';
  var swapped = swap<String>(a, b);
  print('  泛型交换:');
  print('    交换前: $a, $b');
  print('    交换后: ${swapped.first}, ${swapped.second}');
  
  // 泛型列表操作
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> strings = ['a', 'b', 'c'];
  
  int firstNumber = getFirst<int>(numbers);
  String firstString = getFirst<String>(strings);
  
  print('  泛型列表操作:');
  print('    第一个数字: $firstNumber');
  print('    第一个字符串: $firstString');
  
  // 泛型转换
  List<String> numberStrings = mapList<int, String>(numbers, (n) => 'Number: $n');
  print('    转换结果: ${numberStrings.take(3).toList()}');
  
  // 泛型过滤
  List<int> evenNumbers = filterList<int>(numbers, (n) => n % 2 == 0);
  print('    偶数过滤: $evenNumbers');
  
  // 泛型归约
  int sum = reduceList<int>(numbers, (a, b) => a + b);
  String concatenated = reduceList<String>(['a', 'b', 'c'], (a, b) => a + b);
  
  print('  泛型归约:');
  print('    数字求和: $sum');
  print('    字符串连接: $concatenated');
}

/// 测试类型约束
void testTypeConstraints() {
  print('\n📌 测试类型约束');
  
  // 数字约束
  var intCalculator = NumberCalculator<int>();
  var doubleCalculator = NumberCalculator<double>();
  
  print('  数字约束:');
  print('    整数计算: ${intCalculator.add(5, 3)}');
  print('    浮点计算: ${doubleCalculator.add(2.5, 1.5)}');
  print('    整数最大值: ${intCalculator.max(10, 5)}');
  print('    浮点最大值: ${doubleCalculator.max(3.14, 2.71)}');
  
  // 比较约束
  var intComparator = Comparator<int>();
  var stringComparator = Comparator<String>();
  
  print('  比较约束:');
  print('    整数比较: ${intComparator.max(10, 5)}');
  print('    字符串比较: ${stringComparator.max('apple', 'banana')}');
  print('    整数排序: ${intComparator.sort([3, 1, 4, 1, 5])}');
  
  // 可序列化约束
  var person = Person('Alice', 25);
  var student = Student('Bob', 20, 'S001');
  
  var personSerializer = Serializer<Person>();
  var studentSerializer = Serializer<Student>();
  
  print('  序列化约束:');
  print('    人员序列化: ${personSerializer.serialize(person)}');
  print('    学生序列化: ${studentSerializer.serialize(student)}');
  
  // 集合约束
  var listProcessor = CollectionProcessor<List<int>>();
  var setProcessor = CollectionProcessor<Set<String>>();
  
  print('  集合约束:');
  print('    列表大小: ${listProcessor.getSize([1, 2, 3, 4, 5])}');
  print('    集合大小: ${setProcessor.getSize({'a', 'b', 'c'})}');
  
  // 多重约束
  var advancedProcessor = AdvancedProcessor<Person>();
  print('    高级处理: ${advancedProcessor.process(person)}');
}

/// 测试泛型集合
void testGenericCollections() {
  print('\n📌 测试泛型集合');
  
  // 自定义泛型列表
  var intList = GenericList<int>();
  intList.add(1);
  intList.add(2);
  intList.add(3);
  
  print('  自定义泛型列表:');
  print('    列表内容: ${intList.toList()}');
  print('    列表大小: ${intList.size}');
  print('    获取索引1: ${intList.get(1)}');
  
  // 自定义泛型栈
  var stringStack = GenericStack<String>();
  stringStack.push('First');
  stringStack.push('Second');
  stringStack.push('Third');
  
  print('  自定义泛型栈:');
  print('    栈顶元素: ${stringStack.peek()}');
  print('    弹出元素: ${stringStack.pop()}');
  print('    栈大小: ${stringStack.size}');
  
  // 自定义泛型队列
  var intQueue = GenericQueue<int>();
  intQueue.enqueue(10);
  intQueue.enqueue(20);
  intQueue.enqueue(30);
  
  print('  自定义泛型队列:');
  print('    队列前端: ${intQueue.front()}');
  print('    出队元素: ${intQueue.dequeue()}');
  print('    队列大小: ${intQueue.size}');
  
  // 泛型映射
  var stringIntMap = GenericMap<String, int>();
  stringIntMap.put('one', 1);
  stringIntMap.put('two', 2);
  stringIntMap.put('three', 3);
  
  print('  泛型映射:');
  print('    获取值: ${stringIntMap.get('two')}');
  print('    映射大小: ${stringIntMap.size}');
  print('    所有键: ${stringIntMap.keys()}');
  
  // 泛型树
  var intTree = BinaryTree<int>();
  intTree.insert(5);
  intTree.insert(3);
  intTree.insert(7);
  intTree.insert(1);
  intTree.insert(9);
  
  print('  泛型二叉树:');
  print('    包含5: ${intTree.contains(5)}');
  print('    包含6: ${intTree.contains(6)}');
  print('    树的大小: ${intTree.size}');
}

/// 测试协变和逆变
void testVariance() {
  print('\n📌 测试协变和逆变');
  
  // 协变示例 (covariant)
  var animalList = <Animal>[Dog('Buddy'), Cat('Whiskers')];
  var dogList = <Dog>[Dog('Max'), Dog('Rex')];
  
  // 协变：List<Dog> 可以赋值给 List<Animal>
  List<Animal> animals = dogList; // 这在 Dart 中是允许的
  
  print('  协变示例:');
  print('    动物列表:');
  for (var animal in animals) {
    print('      ${animal.name} 说: ${animal.makeSound()}');
  }
  
  // 函数类型的协变和逆变
  Function(Animal) animalHandler = (Animal animal) {
    print('      处理动物: ${animal.name}');
  };
  
  Function(Dog) dogHandler = (Dog dog) {
    print('      处理狗: ${dog.name}, 品种: ${dog.breed}');
  };
  
  // 逆变：Function(Animal) 可以处理 Dog
  dogHandler = animalHandler; // 逆变
  dogHandler(Dog('Covariant Dog', 'Labrador'));
  
  // 泛型方法的协变
  var processor = AnimalProcessor<Dog>();
  processor.process(Dog('Generic Dog', 'Poodle'));
  
  // 使用协变处理不同类型
  processAnimals([Dog('Dog1', 'Beagle'), Cat('Cat1', 'Siamese')]);
  
  // 泛型接口协变
  Producer<Animal> animalProducer = DogProducer();
  Animal producedAnimal = animalProducer.produce();
  print('    生产的动物: ${producedAnimal.name}');
  
  // 泛型接口逆变
  Consumer<Dog> dogConsumer = AnimalConsumer();
  dogConsumer.consume(Dog('Consumed Dog', 'Bulldog'));
}

/// 测试泛型接口
void testGenericInterfaces() {
  print('\n📌 测试泛型接口');
  
  // 泛型仓库接口
  Repository<String> stringRepo = StringRepository();
  stringRepo.save('Hello');
  stringRepo.save('World');
  
  print('  泛型仓库:');
  print('    查找: ${stringRepo.findById('Hello')}');
  print('    所有项: ${stringRepo.findAll()}');
  
  Repository<int> intRepo = IntRepository();
  intRepo.save(42);
  intRepo.save(100);
  
  print('    整数仓库: ${intRepo.findAll()}');
  
  // 泛型转换器接口
  Converter<String, int> stringToInt = StringToIntConverter();
  Converter<int, String> intToString = IntToStringConverter();
  
  print('  泛型转换器:');
  print('    字符串转整数: ${stringToInt.convert('123')}');
  print('    整数转字符串: ${intToString.convert(456)}');
  
  // 泛型验证器接口
  Validator<String> emailValidator = EmailValidator();
  Validator<int> ageValidator = AgeValidator();
  
  print('  泛型验证器:');
  print('    邮箱验证: ${emailValidator.validate('test@example.com')}');
  print('    年龄验证: ${ageValidator.validate(25)}');
  print('    无效邮箱: ${emailValidator.validate('invalid')}');
  print('    无效年龄: ${ageValidator.validate(-5)}');
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
}

/// 泛型继承
class NumberContainer<T extends num> extends Box<T> {
  NumberContainer(T value) : super(value);
  
  void add(T value) {
    setValue((_value + value) as T);
  }
  
  void multiply(T value) {
    setValue((_value * value) as T);
  }
}

/// 泛型工厂
class ContainerFactory<T> {
  Box<T> create(T value) {
    return Box<T>(value);
  }
}

/// 数字计算器（类型约束）
class NumberCalculator<T extends num> {
  T add(T a, T b) => (a + b) as T;
  T subtract(T a, T b) => (a - b) as T;
  T multiply(T a, T b) => (a * b) as T;
  T max(T a, T b) => a > b ? a : b;
  T min(T a, T b) => a < b ? a : b;
}

/// 比较器（类型约束）
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
  Map<String, dynamic> toJson();
}

/// 序列化器（类型约束）
class Serializer<T extends Serializable> {
  String serialize(T object) {
    return object.toJson().toString();
  }
}

/// 集合处理器（类型约束）
class CollectionProcessor<T extends Iterable> {
  int getSize(T collection) => collection.length;
  bool isEmpty(T collection) => collection.isEmpty;
}

/// 高级处理器（多重约束）
class AdvancedProcessor<T extends Serializable> {
  String process(T object) {
    return 'Processing: ${object.toJson()}';
  }
}

/// 自定义泛型列表
class GenericList<T> {
  final List<T> _items = [];
  
  void add(T item) => _items.add(item);
  T get(int index) => _items[index];
  int get size => _items.length;
  List<T> toList() => List<T>.from(_items);
}

/// 自定义泛型栈
class GenericStack<T> {
  final List<T> _items = [];
  
  void push(T item) => _items.add(item);
  T pop() => _items.removeLast();
  T peek() => _items.last;
  int get size => _items.length;
  bool get isEmpty => _items.isEmpty;
}

/// 自定义泛型队列
class GenericQueue<T> {
  final List<T> _items = [];
  
  void enqueue(T item) => _items.add(item);
  T dequeue() => _items.removeAt(0);
  T front() => _items.first;
  int get size => _items.length;
  bool get isEmpty => _items.isEmpty;
}

/// 自定义泛型映射
class GenericMap<K, V> {
  final Map<K, V> _items = {};
  
  void put(K key, V value) => _items[key] = value;
  V? get(K key) => _items[key];
  int get size => _items.length;
  Iterable<K> keys() => _items.keys;
  Iterable<V> values() => _items.values;
}

/// 泛型二叉树
class BinaryTree<T extends Comparable<T>> {
  TreeNode<T>? _root;
  int _size = 0;
  
  void insert(T value) {
    _root = _insertNode(_root, value);
    _size++;
  }
  
  bool contains(T value) {
    return _findNode(_root, value) != null;
  }
  
  int get size => _size;
  
  TreeNode<T>? _insertNode(TreeNode<T>? node, T value) {
    if (node == null) {
      return TreeNode<T>(value);
    }
    
    if (value.compareTo(node.value) < 0) {
      node.left = _insertNode(node.left, value);
    } else {
      node.right = _insertNode(node.right, value);
    }
    
    return node;
  }
  
  TreeNode<T>? _findNode(TreeNode<T>? node, T value) {
    if (node == null) return null;
    
    int comparison = value.compareTo(node.value);
    if (comparison == 0) return node;
    if (comparison < 0) return _findNode(node.left, value);
    return _findNode(node.right, value);
  }
}

/// 树节点
class TreeNode<T> {
  T value;
  TreeNode<T>? left;
  TreeNode<T>? right;
  
  TreeNode(this.value);
}

/// 动物基类
class Animal {
  String name;
  
  Animal(this.name);
  
  String makeSound() => 'Some sound';
}

/// 狗类
class Dog extends Animal {
  String breed;
  
  Dog(String name, this.breed) : super(name);
  
  @override
  String makeSound() => 'Woof!';
}

/// 猫类
class Cat extends Animal {
  String breed;
  
  Cat(String name, this.breed) : super(name);
  
  @override
  String makeSound() => 'Meow!';
}

/// 动物处理器
class AnimalProcessor<T extends Animal> {
  void process(T animal) {
    print('      处理动物: ${animal.name}, 声音: ${animal.makeSound()}');
  }
}

/// 生产者接口（协变）
abstract class Producer<out T> {
  T produce();
}

/// 消费者接口（逆变）
abstract class Consumer<in T> {
  void consume(T item);
}

/// 狗生产者
class DogProducer implements Producer<Dog> {
  @override
  Dog produce() => Dog('Produced Dog', 'Golden Retriever');
}

/// 动物消费者
class AnimalConsumer implements Consumer<Animal> {
  @override
  void consume(Animal animal) {
    print('      消费动物: ${animal.name}');
  }
}

/// 人员类
class Person implements Serializable {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  @override
  Map<String, dynamic> toJson() => {'name': name, 'age': age};
}

/// 学生类
class Student extends Person {
  String studentId;
  
  Student(String name, int age, this.studentId) : super(name, age);
  
  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'studentId': studentId,
  };
}

/// 泛型仓库接口
abstract class Repository<T> {
  void save(T item);
  T? findById(String id);
  List<T> findAll();
}

/// 字符串仓库实现
class StringRepository implements Repository<String> {
  final List<String> _items = [];
  
  @override
  void save(String item) => _items.add(item);
  
  @override
  String? findById(String id) => _items.contains(id) ? id : null;
  
  @override
  List<String> findAll() => List.from(_items);
}

/// 整数仓库实现
class IntRepository implements Repository<int> {
  final List<int> _items = [];
  
  @override
  void save(int item) => _items.add(item);
  
  @override
  int? findById(String id) {
    int? intId = int.tryParse(id);
    return intId != null && _items.contains(intId) ? intId : null;
  }
  
  @override
  List<int> findAll() => List.from(_items);
}

/// 泛型转换器接口
abstract class Converter<T, R> {
  R convert(T input);
}

/// 字符串转整数转换器
class StringToIntConverter implements Converter<String, int> {
  @override
  int convert(String input) => int.parse(input);
}

/// 整数转字符串转换器
class IntToStringConverter implements Converter<int, String> {
  @override
  String convert(int input) => input.toString();
}

/// 泛型验证器接口
abstract class Validator<T> {
  bool validate(T input);
}

/// 邮箱验证器
class EmailValidator implements Validator<String> {
  @override
  bool validate(String input) => input.contains('@') && input.contains('.');
}

/// 年龄验证器
class AgeValidator implements Validator<int> {
  @override
  bool validate(int input) => input >= 0 && input <= 150;
}

// ============================================================================
// 泛型函数定义
// ============================================================================

/// 身份函数
T identity<T>(T value) => value;

/// 交换函数
Pair<T, T> swap<T>(T a, T b) => Pair<T, T>(b, a);

/// 获取第一个元素
T getFirst<T>(List<T> list) => list.first;

/// 映射列表
List<R> mapList<T, R>(List<T> list, R Function(T) mapper) {
  return list.map(mapper).toList();
}

/// 过滤列表
List<T> filterList<T>(List<T> list, bool Function(T) predicate) {
  return list.where(predicate).toList();
}

/// 归约列表
T reduceList<T>(List<T> list, T Function(T, T) reducer) {
  return list.reduce(reducer);
}

/// 处理动物列表
void processAnimals(List<Animal> animals) {
  print('  处理动物列表:');
  for (var animal in animals) {
    print('    ${animal.name}: ${animal.makeSound()}');
  }
}

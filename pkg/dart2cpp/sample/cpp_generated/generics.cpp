#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Box
// ============================================================================

class Box {
private:
  Any _value;
public:
  Box(Any _value) : _value(_value) {
  }
  
  Any getValue() {
    return this->_value;
  }
  
  Nullable setValue(Any value) {
    return this->_value = value;
  }
  
  String toString() {
    return dart_concat(dart_string("Box<"), Type::of<TypeParameterType(Box.T%)>(), dart_string(">("), this->_value, dart_string(")"));
  }
  
};

// ============================================================================
// 类: Pair
// ============================================================================

class Pair {
public:
  Any first;
  Any second;
  Pair(Any first, Any second) : first(first), second(second) {
  }
  
  Nullable swap() {
    auto temp = this->first;
this->first = dart_cast<Any>(this->second);
this->second = dart_cast<Any>(temp);
return Void;
  }
  
};

// ============================================================================
// 类: NumberContainer
// ============================================================================

class NumberContainer : public Box {
public:
  NumberContainer(Any value) : Box(value) {
  }
  
  Nullable add(Any value) {
    this->setValue(dart_cast<Any>((this->_value + value)));
return Void;
  }
  
  Nullable multiply(Any value) {
    this->setValue(dart_cast<Any>((this->_value * value)));
return Void;
  }
  
};

// ============================================================================
// 类: ContainerFactory
// ============================================================================

class ContainerFactory {
public:
  ContainerFactory() {
  }
  
  Box create(Any value) {
    return ObjectPtr<Box>(new Box(value));
  }
  
};

// ============================================================================
// 类: NumberCalculator
// ============================================================================

class NumberCalculator {
public:
  NumberCalculator() {
  }
  
  Any add(Any a, Any b) {
    return dart_cast<Any>((a + b));
  }
  
  Any subtract(Any a, Any b) {
    return dart_cast<Any>((a - b));
  }
  
  Any multiply(Any a, Any b) {
    return dart_cast<Any>((a * b));
  }
  
  Any max(Any a, Any b) {
    return (a > b) ? a : b;
  }
  
  Any min(Any a, Any b) {
    return (a < b) ? a : b;
  }
  
};

// ============================================================================
// 类: Comparator
// ============================================================================

class Comparator {
public:
  Comparator() {
  }
  
  Any max(Any a, Any b) {
    return (a->compareTo(b) > dart_int(0)) ? a : b;
  }
  
  Any min(Any a, Any b) {
    return (a->compareTo(b) < dart_int(0)) ? a : b;
  }
  
  List<Any> sort(List<Any> items) {
    auto sorted = List::from(items);
sorted->sort();
return sorted;
  }
  
};

// ============================================================================
// 类: Serializable
// ============================================================================

DART_INTERFACE(Serializable)
  DART_ABSTRACT_METHOD(Map<String, Any>, toJson, ())
DART_INTERFACE_END

// ============================================================================
// 类: Serializer
// ============================================================================

class Serializer {
public:
  Serializer() {
  }
  
  String serialize(Any object) {
    return object->toJson()->toString();
  }
  
};

// ============================================================================
// 类: CollectionProcessor
// ============================================================================

class CollectionProcessor {
public:
  CollectionProcessor() {
  }
  
  Int getSize(Any collection) {
    return collection->size();
  }
  
  Bool isEmpty(Any collection) {
    return collection->isEmpty;
  }
  
};

// ============================================================================
// 类: AdvancedProcessor
// ============================================================================

class AdvancedProcessor {
public:
  AdvancedProcessor() {
  }
  
  String process(Any object) {
    return dart_concat(dart_string("Processing: "), object->toJson());
  }
  
};

// ============================================================================
// 类: GenericList
// ============================================================================

class GenericList {
private:
  List<Any> _items = _GrowableList::(dart_int(0));
public:
  GenericList() {
  }
  
  Nullable add(Any item) {
    return this->_items->add(item);
  }
  
  Any get(Int index) {
    return this->_items->[](index);
  }
  
  Int size() {
    return this->_items->size();
  }
  
  List<Any> toList() {
    return List::from(this->_items);
  }
  
};

// ============================================================================
// 类: GenericStack
// ============================================================================

class GenericStack {
private:
  List<Any> _items = _GrowableList::(dart_int(0));
public:
  GenericStack() {
  }
  
  Nullable push(Any item) {
    return this->_items->add(item);
  }
  
  Any pop() {
    return this->_items->removeLast();
  }
  
  Any peek() {
    return this->_items->last;
  }
  
  Int size() {
    return this->_items->size();
  }
  
  Bool isEmpty() {
    return this->_items->isEmpty;
  }
  
};

// ============================================================================
// 类: GenericQueue
// ============================================================================

class GenericQueue {
private:
  List<Any> _items = _GrowableList::(dart_int(0));
public:
  GenericQueue() {
  }
  
  Nullable enqueue(Any item) {
    return this->_items->add(item);
  }
  
  Any dequeue() {
    return this->_items->removeAt(dart_int(0));
  }
  
  Any front() {
    return this->_items->first;
  }
  
  Int size() {
    return this->_items->size();
  }
  
  Bool isEmpty() {
    return this->_items->isEmpty;
  }
  
};

// ============================================================================
// 类: GenericMap
// ============================================================================

class GenericMap {
private:
  Map<Any, Any> _items = Map<Any, Any>::create();
public:
  GenericMap() {
  }
  
  Nullable put(Any key, Any value) {
    return ([&]() { Map<Any, Any> let_var = this->_items; return ([&]() { Any let_var = key; return ([&]() { Any let_var = value; return ([&]() { Nullable let_var = let_var->[]=(let_var, let_var); return let_var; })(); })(); })(); })();
  }
  
  Any get(Any key) {
    return this->_items->[](key);
  }
  
  Int size() {
    return this->_items->size();
  }
  
  Iterable keys() {
    return this->_items->keys;
  }
  
  Iterable values() {
    return this->_items->values;
  }
  
};

// ============================================================================
// 类: BinaryTree
// ============================================================================

class BinaryTree {
private:
  TreeNode _root = Null;
  Int _size = dart_int(0);
public:
  BinaryTree() {
  }
  
  Nullable insert(Any value) {
    this->_root = this->_insertNode(this->_root, value);
this->_size = (this->_size + dart_int(1));
return Void;
  }
  
  Bool contains(Any value) {
    return !(dart_is_null(this->_findNode(this->_root, value)));
  }
  
  Int size() {
    return this->_size;
  }
  
  TreeNode _insertNode(TreeNode node, Any value) {
    if (dart_is_null(node)) {
return ObjectPtr<TreeNode>(new TreeNode(value));
}
if ((value->compareTo(node->value) < dart_int(0))) {
node->left = this->_insertNode(node->left, value);
} else {
node->right = this->_insertNode(node->right, value);
}
return node;
  }
  
  TreeNode _findNode(TreeNode node, Any value) {
    if (dart_is_null(node)) {
return Null;
}
auto comparison = value->compareTo(node->value);
if ((comparison == dart_int(0))) {
return node;
}
if ((comparison < dart_int(0))) {
return this->_findNode(node->left, value);
}
return this->_findNode(node->right, value);
  }
  
};

// ============================================================================
// 类: TreeNode
// ============================================================================

class TreeNode {
public:
  Any value;
  TreeNode left = Null;
  TreeNode right = Null;
  TreeNode(Any value) : value(value) {
  }
  
};

// ============================================================================
// 类: Animal
// ============================================================================

class Animal {
public:
  String name;
  Animal(String name) : name(name) {
  }
  
  String makeSound() {
    return dart_string("Some sound");
  }
  
};

// ============================================================================
// 类: Dog
// ============================================================================

class Dog : public Animal {
public:
  String breed;
  Dog(String name, String breed) : breed(breed), Animal(name) {
  }
  
  String makeSound() {
    return dart_string("Woof!");
  }
  
};

// ============================================================================
// 类: Cat
// ============================================================================

class Cat : public Animal {
public:
  String breed;
  Cat(String name, String breed) : breed(breed), Animal(name) {
  }
  
  String makeSound() {
    return dart_string("Meow!");
  }
  
};

// ============================================================================
// 类: AnimalProcessor
// ============================================================================

class AnimalProcessor {
public:
  AnimalProcessor() {
  }
  
  Nullable process(Any animal) {
    dart_print(dart_concat(dart_string("      处理动物: "), animal->name, dart_string(", 声音: "), animal->makeSound()));
return Void;
  }
  
};

// ============================================================================
// 类: Producer
// ============================================================================

DART_INTERFACE(Producer)
  DART_ABSTRACT_METHOD(Any, produce, ())
DART_INTERFACE_END

// ============================================================================
// 类: Consumer
// ============================================================================

DART_INTERFACE(Consumer)
  DART_ABSTRACT_METHOD(Nullable, consume, (Any item))
DART_INTERFACE_END

// ============================================================================
// 类: DogProducer
// ============================================================================

class DogProducer : DART_IMPLEMENTS(Producer) {
public:
  DogProducer() {
  }
  
  Dog produce() {
    return ObjectPtr<Dog>(new Dog(dart_string("Produced Dog"), dart_string("Golden Retriever")));
  }
  
};

// ============================================================================
// 类: AnimalConsumer
// ============================================================================

class AnimalConsumer : DART_IMPLEMENTS(Consumer) {
public:
  AnimalConsumer() {
  }
  
  Nullable consume(Animal animal) {
    dart_print(dart_concat(dart_string("      消费动物: "), animal->name));
return Void;
  }
  
};

// ============================================================================
// 类: Person
// ============================================================================

class Person : DART_IMPLEMENTS(Serializable) {
public:
  String name;
  Int age;
  Person(String name, Int age) : name(name), age(age) {
  }
  
  Map<String, Any> toJson() {
    return Map<String, Any>::createFromEntries({{dart_string("name"), this->name}, {dart_string("age"), this->age}});
  }
  
};

// ============================================================================
// 类: Student
// ============================================================================

class Student : public Person {
public:
  String studentId;
  Student(String name, Int age, String studentId) : studentId(studentId), Person(name, age) {
  }
  
  Map<String, Any> toJson() {
    return ([&]() { const auto unnamed_var = LinkedHashMap::of(super::toJson()); unnamed_var->[]=(dart_string("studentId"), this->studentId); return unnamed_var; })();
  }
  
};

// ============================================================================
// 类: Repository
// ============================================================================

DART_INTERFACE(Repository)
  DART_ABSTRACT_METHOD(Nullable, save, (Any item))
  DART_ABSTRACT_METHOD(Any, findById, (String id))
  DART_ABSTRACT_METHOD(List<Any>, findAll, ())
DART_INTERFACE_END

// ============================================================================
// 类: StringRepository
// ============================================================================

class StringRepository : DART_IMPLEMENTS(Repository) {
private:
  List<String> _items = _GrowableList::(dart_int(0));
public:
  StringRepository() {
  }
  
  Nullable save(String item) {
    return this->_items->add(item);
  }
  
  String findById(String id) {
    return this->_items->contains(id) ? id : Null;
  }
  
  List<String> findAll() {
    return List::from(this->_items);
  }
  
};

// ============================================================================
// 类: IntRepository
// ============================================================================

class IntRepository : DART_IMPLEMENTS(Repository) {
private:
  List<Int> _items = _GrowableList::(dart_int(0));
public:
  IntRepository() {
  }
  
  Nullable save(Int item) {
    return this->_items->add(item);
  }
  
  Int findById(String id) {
    auto intId = int::tryParse(id);
return !(dart_is_null(intId)) && this->_items->contains(intId) ? intId : Null;
  }
  
  List<Int> findAll() {
    return List::from(this->_items);
  }
  
};

// ============================================================================
// 类: Converter
// ============================================================================

DART_INTERFACE(Converter)
  DART_ABSTRACT_METHOD(Any, convert, (Any input))
DART_INTERFACE_END

// ============================================================================
// 类: StringToIntConverter
// ============================================================================

class StringToIntConverter : DART_IMPLEMENTS(Converter) {
public:
  StringToIntConverter() {
  }
  
  Int convert(String input) {
    return int::parse(input);
  }
  
};

// ============================================================================
// 类: IntToStringConverter
// ============================================================================

class IntToStringConverter : DART_IMPLEMENTS(Converter) {
public:
  IntToStringConverter() {
  }
  
  String convert(Int input) {
    return input->toString();
  }
  
};

// ============================================================================
// 类: Validator
// ============================================================================

DART_INTERFACE(Validator)
  DART_ABSTRACT_METHOD(Bool, validate, (Any input))
DART_INTERFACE_END

// ============================================================================
// 类: EmailValidator
// ============================================================================

class EmailValidator : DART_IMPLEMENTS(Validator) {
public:
  EmailValidator() {
  }
  
  Bool validate(String input) {
    return input->contains(dart_string("@")) && input->contains(dart_string("."));
  }
  
};

// ============================================================================
// 类: AgeValidator
// ============================================================================

class AgeValidator : DART_IMPLEMENTS(Validator) {
public:
  AgeValidator() {
  }
  
  Bool validate(Int input) {
    return (input >= dart_int(0)) && (input <= dart_int(150));
  }
  
};

Nullable testGenericClasses() {
  dart_print(dart_string("\n📌 测试泛型类"));
auto intBox = ObjectPtr<Box>(new Box(dart_int(42)));
auto stringBox = ObjectPtr<Box>(new Box(dart_string("Hello")));
auto boolBox = ObjectPtr<Box>(new Box(dart_bool(true)));
dart_print(dart_string("  基本泛型类:"));
dart_print(dart_concat(dart_string("    整数盒子: "), intBox->getValue()));
dart_print(dart_concat(dart_string("    字符串盒子: "), stringBox->getValue()));
dart_print(dart_concat(dart_string("    布尔盒子: "), boolBox->getValue()));
intBox->setValue(dart_int(100));
stringBox->setValue(dart_string("World"));
dart_print(dart_string("  修改后:"));
dart_print(dart_concat(dart_string("    整数盒子: "), intBox->getValue()));
dart_print(dart_concat(dart_string("    字符串盒子: "), stringBox->getValue()));
auto pair = ObjectPtr<Pair>(new Pair(dart_string("Alice"), dart_int(25)));
dart_print(dart_string("  多泛型参数:"));
dart_print(dart_concat(dart_string("    键值对: "), pair->first, dart_string(" -> "), pair->second));
pair->swap();
dart_print(dart_concat(dart_string("    交换后: "), pair->first, dart_string(" -> "), pair->second));
auto nestedBox = ObjectPtr<Box>(new Box(ObjectPtr<Box>(new Box(dart_string("Nested")))));
dart_print(dart_concat(dart_string("  嵌套泛型: "), nestedBox->getValue()->getValue()));
auto numberContainer = ObjectPtr<NumberContainer>(new NumberContainer(dart_int(42)));
numberContainer->add(dart_int(10));
dart_print(dart_concat(dart_string("  泛型继承: "), numberContainer->getValue()));
auto doubleContainer = ObjectPtr<NumberContainer>(new NumberContainer(dart_double(3.14)));
doubleContainer->multiply(dart_double(2.0));
dart_print(dart_concat(dart_string("  浮点容器: "), doubleContainer->getValue()));
auto factory = ObjectPtr<ContainerFactory>(new ContainerFactory());
auto container1 = factory->create(dart_string("Hello"));
auto container2 = factory->create(dart_string("World"));
dart_print(dart_string("  泛型工厂:"));
dart_print(dart_concat(dart_string("    容器1: "), container1->getValue()));
dart_print(dart_concat(dart_string("    容器2: "), container2->getValue()));
return Void;
}

Nullable testGenericMethods() {
  dart_print(dart_string("\n📌 测试泛型方法"));
auto stringResult = identity(dart_string("Hello"));
auto intResult = identity(dart_int(42));
auto boolResult = identity(dart_bool(true));
dart_print(dart_string("  基本泛型方法:"));
dart_print(dart_concat(dart_string("    identity<String>: "), stringResult));
dart_print(dart_concat(dart_string("    identity<int>: "), intResult));
dart_print(dart_concat(dart_string("    identity<bool>: "), boolResult));
auto inferredString = identity(dart_string("Inferred"));
auto inferredInt = identity(dart_int(100));
dart_print(dart_string("  类型推断:"));
dart_print(dart_concat(dart_string("    推断字符串: "), inferredString));
dart_print(dart_concat(dart_string("    推断整数: "), inferredInt));
auto a = dart_string("First");
auto b = dart_string("Second");
auto swapped = swap(a, b);
dart_print(dart_string("  泛型交换:"));
dart_print(dart_concat(dart_string("    交换前: "), a, dart_string(", "), b));
dart_print(dart_concat(dart_string("    交换后: "), swapped->first, dart_string(", "), swapped->second));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto strings = dart_literal(dart_string("a"), dart_string("b"), dart_string("c"));
auto firstNumber = getFirst(numbers);
auto firstString = getFirst(strings);
dart_print(dart_string("  泛型列表操作:"));
dart_print(dart_concat(dart_string("    第一个数字: "), firstNumber));
dart_print(dart_concat(dart_string("    第一个字符串: "), firstString));
auto numberStrings = mapList(numbers, [&](Int n) { return dart_concat(dart_string("Number: "), n); });
dart_print(dart_concat(dart_string("    转换结果: "), numberStrings->take(dart_int(3))->toList()));
auto evenNumbers = filterList(numbers, [&](Int n) { return ((n % dart_int(2)) == dart_int(0)); });
dart_print(dart_concat(dart_string("    偶数过滤: "), evenNumbers));
auto sum = reduceList(numbers, [&](Int a, Int b) { return (a + b); });
auto concatenated = reduceList(dart_literal(dart_string("a"), dart_string("b"), dart_string("c")), [&](String a, String b) { return (a + b); });
dart_print(dart_string("  泛型归约:"));
dart_print(dart_concat(dart_string("    数字求和: "), sum));
dart_print(dart_concat(dart_string("    字符串连接: "), concatenated));
}

Nullable testTypeConstraints() {
  dart_print(dart_string("\n📌 测试类型约束"));
auto intCalculator = ObjectPtr<NumberCalculator>(new NumberCalculator());
auto doubleCalculator = ObjectPtr<NumberCalculator>(new NumberCalculator());
dart_print(dart_string("  数字约束:"));
dart_print(dart_concat(dart_string("    整数计算: "), intCalculator->add(dart_int(5), dart_int(3))));
dart_print(dart_concat(dart_string("    浮点计算: "), doubleCalculator->add(dart_double(2.5), dart_double(1.5))));
dart_print(dart_concat(dart_string("    整数最大值: "), intCalculator->max(dart_int(10), dart_int(5))));
dart_print(dart_concat(dart_string("    浮点最大值: "), doubleCalculator->max(dart_double(3.14), dart_double(2.71))));
auto intComparator = ObjectPtr<Comparator>(new Comparator());
auto stringComparator = ObjectPtr<Comparator>(new Comparator());
dart_print(dart_string("  比较约束:"));
dart_print(dart_concat(dart_string("    整数比较: "), intComparator->max(dart_int(10), dart_int(5))));
dart_print(dart_concat(dart_string("    字符串比较: "), stringComparator->max(dart_string("apple"), dart_string("banana"))));
dart_print(dart_concat(dart_string("    整数排序: "), intComparator->sort(dart_literal(dart_int(3), dart_int(1), dart_int(4), dart_int(1), dart_int(5)))));
auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25)));
auto student = ObjectPtr<Student>(new Student(dart_string("Bob"), dart_int(20), dart_string("S001")));
auto personSerializer = ObjectPtr<Serializer>(new Serializer());
auto studentSerializer = ObjectPtr<Serializer>(new Serializer());
dart_print(dart_string("  序列化约束:"));
dart_print(dart_concat(dart_string("    人员序列化: "), personSerializer->serialize(person)));
dart_print(dart_concat(dart_string("    学生序列化: "), studentSerializer->serialize(student)));
auto listProcessor = ObjectPtr<CollectionProcessor>(new CollectionProcessor());
auto setProcessor = ObjectPtr<CollectionProcessor>(new CollectionProcessor());
dart_print(dart_string("  集合约束:"));
dart_print(dart_concat(dart_string("    列表大小: "), listProcessor->getSize(dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)))));
dart_print(dart_concat(dart_string("    集合大小: "), setProcessor->getSize(([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_string("a")); unnamed_var->add(dart_string("b")); unnamed_var->add(dart_string("c")); return unnamed_var; })())));
auto advancedProcessor = ObjectPtr<AdvancedProcessor>(new AdvancedProcessor());
dart_print(dart_concat(dart_string("    高级处理: "), advancedProcessor->process(person)));
}

Nullable testGenericCollections() {
  dart_print(dart_string("\n📌 测试泛型集合"));
auto intList = ObjectPtr<GenericList>(new GenericList());
intList->add(dart_int(1));
intList->add(dart_int(2));
intList->add(dart_int(3));
dart_print(dart_string("  自定义泛型列表:"));
dart_print(dart_concat(dart_string("    列表内容: "), intList->toList()));
dart_print(dart_concat(dart_string("    列表大小: "), intList->size));
dart_print(dart_concat(dart_string("    获取索引1: "), intList->get(dart_int(1))));
auto stringStack = ObjectPtr<GenericStack>(new GenericStack());
stringStack->push(dart_string("First"));
stringStack->push(dart_string("Second"));
stringStack->push(dart_string("Third"));
dart_print(dart_string("  自定义泛型栈:"));
dart_print(dart_concat(dart_string("    栈顶元素: "), stringStack->peek()));
dart_print(dart_concat(dart_string("    弹出元素: "), stringStack->pop()));
dart_print(dart_concat(dart_string("    栈大小: "), stringStack->size));
auto intQueue = ObjectPtr<GenericQueue>(new GenericQueue());
intQueue->enqueue(dart_int(10));
intQueue->enqueue(dart_int(20));
intQueue->enqueue(dart_int(30));
dart_print(dart_string("  自定义泛型队列:"));
dart_print(dart_concat(dart_string("    队列前端: "), intQueue->front()));
dart_print(dart_concat(dart_string("    出队元素: "), intQueue->dequeue()));
dart_print(dart_concat(dart_string("    队列大小: "), intQueue->size));
auto stringIntMap = ObjectPtr<GenericMap>(new GenericMap());
stringIntMap->put(dart_string("one"), dart_int(1));
stringIntMap->put(dart_string("two"), dart_int(2));
stringIntMap->put(dart_string("three"), dart_int(3));
dart_print(dart_string("  泛型映射:"));
dart_print(dart_concat(dart_string("    获取值: "), stringIntMap->get(dart_string("two"))));
dart_print(dart_concat(dart_string("    映射大小: "), stringIntMap->size));
dart_print(dart_concat(dart_string("    所有键: "), stringIntMap->keys()));
auto intTree = ObjectPtr<BinaryTree>(new BinaryTree());
intTree->insert(dart_int(5));
intTree->insert(dart_int(3));
intTree->insert(dart_int(7));
intTree->insert(dart_int(1));
intTree->insert(dart_int(9));
dart_print(dart_string("  泛型二叉树:"));
dart_print(dart_concat(dart_string("    包含5: "), intTree->contains(dart_int(5))));
dart_print(dart_concat(dart_string("    包含6: "), intTree->contains(dart_int(6))));
dart_print(dart_concat(dart_string("    树的大小: "), intTree->size));
return Void;
}

Nullable testVariance() {
  dart_print(dart_string("\n📌 测试协变和逆变"));
auto animalList = dart_literal(/* Invalid: temp_dart_source.dart:259:32: Error: Too few positional arguments: 2 required, 1 given.
  var animalList = <Animal>[Dog('Buddy'), Cat('Whiskers')];
                               ^ */, /* Invalid: temp_dart_source.dart:259:46: Error: Too few positional arguments: 2 required, 1 given.
  var animalList = <Animal>[Dog('Buddy'), Cat('Whiskers')];
                                             ^ */);
auto dogList = dart_literal(/* Invalid: temp_dart_source.dart:260:26: Error: Too few positional arguments: 2 required, 1 given.
  var dogList = <Dog>[Dog('Max'), Dog('Rex')];
                         ^ */, /* Invalid: temp_dart_source.dart:260:38: Error: Too few positional arguments: 2 required, 1 given.
  var dogList = <Dog>[Dog('Max'), Dog('Rex')];
                                     ^ */);
auto animals = dogList;
dart_print(dart_string("  协变示例:"));
dart_print(dart_string("    动物列表:"));
auto sync_for_iterator = animals->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto animal = sync_for_iterator->current;
dart_print(dart_concat(dart_string("      "), animal->name, dart_string(" 说: "), animal->makeSound()));
}
auto animalHandler = [&](Animal animal) { dart_print(dart_concat(dart_string("      处理动物: "), animal->name)); };
auto dogHandler = [&](Dog dog) { dart_print(dart_concat(dart_string("      处理狗: "), dog->name, dart_string(", 品种: "), dog->breed)); };
dogHandler = animalHandler;
dogHandler(ObjectPtr<Dog>(new Dog(dart_string("Covariant Dog"), dart_string("Labrador"))));
auto processor = ObjectPtr<AnimalProcessor>(new AnimalProcessor());
processor->process(ObjectPtr<Dog>(new Dog(dart_string("Generic Dog"), dart_string("Poodle"))));
processAnimals(dart_literal(ObjectPtr<Dog>(new Dog(dart_string("Dog1"), dart_string("Beagle"))), ObjectPtr<Cat>(new Cat(dart_string("Cat1"), dart_string("Siamese")))));
auto animalProducer = ObjectPtr<DogProducer>(new DogProducer());
auto producedAnimal = animalProducer->produce();
dart_print(dart_concat(dart_string("    生产的动物: "), producedAnimal->name));
auto dogConsumer = ObjectPtr<AnimalConsumer>(new AnimalConsumer());
dogConsumer->consume(ObjectPtr<Dog>(new Dog(dart_string("Consumed Dog"), dart_string("Bulldog"))));
return Void;
}

Nullable testGenericInterfaces() {
  dart_print(dart_string("\n📌 测试泛型接口"));
auto stringRepo = ObjectPtr<StringRepository>(new StringRepository());
stringRepo->save(dart_string("Hello"));
stringRepo->save(dart_string("World"));
dart_print(dart_string("  泛型仓库:"));
dart_print(dart_concat(dart_string("    查找: "), stringRepo->findById(dart_string("Hello"))));
dart_print(dart_concat(dart_string("    所有项: "), stringRepo->findAll()));
auto intRepo = ObjectPtr<IntRepository>(new IntRepository());
intRepo->save(dart_int(42));
intRepo->save(dart_int(100));
dart_print(dart_concat(dart_string("    整数仓库: "), intRepo->findAll()));
auto stringToInt = ObjectPtr<StringToIntConverter>(new StringToIntConverter());
auto intToString = ObjectPtr<IntToStringConverter>(new IntToStringConverter());
dart_print(dart_string("  泛型转换器:"));
dart_print(dart_concat(dart_string("    字符串转整数: "), stringToInt->convert(dart_string("123"))));
dart_print(dart_concat(dart_string("    整数转字符串: "), intToString->convert(dart_int(456))));
auto emailValidator = ObjectPtr<EmailValidator>(new EmailValidator());
auto ageValidator = ObjectPtr<AgeValidator>(new AgeValidator());
dart_print(dart_string("  泛型验证器:"));
dart_print(dart_concat(dart_string("    邮箱验证: "), emailValidator->validate(dart_string("test@example.com"))));
dart_print(dart_concat(dart_string("    年龄验证: "), ageValidator->validate(dart_int(25))));
dart_print(dart_concat(dart_string("    无效邮箱: "), emailValidator->validate(dart_string("invalid"))));
dart_print(dart_concat(dart_string("    无效年龄: "), ageValidator->validate(dart_int(-5))));
return Void;
}

Any identity(Any value) {
  return value;
}

Pair swap(Any a, Any b) {
  return ObjectPtr<Pair>(new Pair(b, a));
}

Any getFirst(List<Any> list) {
  return list->first;
}

List<Any> mapList(List<Any> list, std::function<Any()> mapper) {
  return list->map(mapper)->toList();
}

List<Any> filterList(List<Any> list, std::function<Bool()> predicate) {
  return list->where(predicate)->toList();
}

Any reduceList(List<Any> list, std::function<Any()> reducer) {
  return list->reduce(reducer);
}

Nullable processAnimals(List<Animal> animals) {
  dart_print(dart_string("  处理动物列表:"));
auto sync_for_iterator = animals->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto animal = sync_for_iterator->current;
dart_print(dart_concat(dart_string("    "), animal->name, dart_string(": "), animal->makeSound()));
};
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 泛型测试开始"));
testGenericClasses();
testGenericMethods();
testTypeConstraints();
testGenericCollections();
testVariance();
testGenericInterfaces();
dart_print(dart_string("✅ 泛型测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

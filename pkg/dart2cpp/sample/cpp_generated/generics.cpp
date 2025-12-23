#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Box
// ============================================================================

template<typename T>
class Box {
private:
  T _value;
public:
  Box(T _value) : _value(_value) {
  }
  
  T getValue() {
    return this->_value;
  }
  
  T setValue(T value) {
    return this->_value = value;
  }
  
  String toString() {
    return dart_concat(dart_string("Box<"), (Type::of<TypeParameterType(Box.T%)>()).toString(), dart_string(">("), (this->_value).toString(), dart_string(")"));
  }
  
};

// ============================================================================
// 类: Pair
// ============================================================================

template<typename T, typename U>
class Pair {
public:
  T first;
  U second;
  Pair(T first, U second) : first(first), second(second) {
  }
  
  Nullable swap() {
    auto temp = this->first();
this->first = dart_cast<T>(this->second);
this->second = dart_cast<U>(temp);
return Void;
  }
  
};

// ============================================================================
// 类: NumberContainer
// ============================================================================

template<typename T>
class NumberContainer : public Box<T> {
public:
  NumberContainer(T value) : Box(value) {
  }
  
  Nullable add(T value) {
    this->setValue(dart_cast<T>(this->_value->operator_add(value)));
return Void;
  }
  
  Nullable multiply(T value) {
    this->setValue(dart_cast<T>(this->_value->operator_mul(value)));
return Void;
  }
  
};

// ============================================================================
// 类: ContainerFactory
// ============================================================================

template<typename T>
class ContainerFactory {
public:
  ContainerFactory() {
  }
  
  ObjectPtr<Box> create(T value) {
    return ObjectPtr<Box<T>>(new Box<T>(value));
  }
  
};

// ============================================================================
// 类: NumberCalculator
// ============================================================================

template<typename T>
class NumberCalculator {
public:
  NumberCalculator() {
  }
  
  T add(T a, T b) {
    return dart_cast<T>(a->operator_add(b));
  }
  
  T subtract(T a, T b) {
    return dart_cast<T>(a->operator_sub(b));
  }
  
  T multiply(T a, T b) {
    return dart_cast<T>(a->operator_mul(b));
  }
  
  T max(T a, T b) {
    return a->operator_greater(b) ? a : b;
  }
  
  T min(T a, T b) {
    return a->operator_less(b) ? a : b;
  }
  
};

// ============================================================================
// 类: Comparator
// ============================================================================

template<typename T>
class Comparator {
public:
  Comparator() {
  }
  
  T max(T a, T b) {
    return a->compareTo(b)->operator_greater(dart_int(0)) ? a : b;
  }
  
  T min(T a, T b) {
    return a->compareTo(b)->operator_less(dart_int(0)) ? a : b;
  }
  
  ObjectPtr<List<T>> sort(ObjectPtr<List<T>> items) {
    auto sorted = List<List>::from(items);
sorted->sort();
return sorted;
  }
  
};

// ============================================================================
// 类: Serializable
// ============================================================================

class Serializable {
public:
  virtual ~Serializable() = default;
  
  virtual ObjectPtr<Map<String, Any>> toJson() = 0;
};

// ============================================================================
// 类: Serializer
// ============================================================================

template<typename T>
class Serializer {
public:
  Serializer() {
  }
  
  String serialize(T object) {
    return object->toJson()->toString();
  }
  
};

// ============================================================================
// 类: CollectionProcessor
// ============================================================================

template<typename T>
class CollectionProcessor {
public:
  CollectionProcessor() {
  }
  
  Int getSize(T collection) {
    return collection->size();
  }
  
  Bool isEmpty(T collection) {
    return collection->isEmpty();
  }
  
};

// ============================================================================
// 类: AdvancedProcessor
// ============================================================================

template<typename T>
class AdvancedProcessor {
public:
  AdvancedProcessor() {
  }
  
  String process(T object) {
    return dart_string("Processing: ") + (object->toJson()).toString();
  }
  
};

// ============================================================================
// 类: GenericList
// ============================================================================

template<typename T>
class GenericList {
private:
  ObjectPtr<List<T>> _items = dart_literal<Any>();
public:
  GenericList() {
  }
  
  Nullable add(T item) {
    return this->_items->add(item);
  }
  
  T get(Int index) {
    return this->_items->operator_index(index);
  }
  
  Int size() {
    return this->_items->size();
  }
  
  ObjectPtr<List<T>> toList() {
    return List<Any>::from(this->_items);
  }
  
};

// ============================================================================
// 类: GenericStack
// ============================================================================

template<typename T>
class GenericStack {
private:
  ObjectPtr<List<T>> _items = dart_literal<Any>();
public:
  GenericStack() {
  }
  
  Nullable push(T item) {
    return this->_items->add(item);
  }
  
  T pop() {
    return this->_items->removeLast();
  }
  
  T peek() {
    return this->_items->last();
  }
  
  Int size() {
    return this->_items->size();
  }
  
  Bool isEmpty() {
    return this->_items->isEmpty();
  }
  
};

// ============================================================================
// 类: GenericQueue
// ============================================================================

template<typename T>
class GenericQueue {
private:
  ObjectPtr<List<T>> _items = dart_literal<Any>();
public:
  GenericQueue() {
  }
  
  Nullable enqueue(T item) {
    return this->_items->add(item);
  }
  
  T dequeue() {
    return this->_items->removeAt(dart_int(0));
  }
  
  T front() {
    return this->_items->first();
  }
  
  Int size() {
    return this->_items->size();
  }
  
  Bool isEmpty() {
    return this->_items->isEmpty();
  }
  
};

// ============================================================================
// 类: GenericMap
// ============================================================================

template<typename K, typename V>
class GenericMap {
private:
  ObjectPtr<Map<K, V>> _items = Map<K, V>::create();
public:
  GenericMap() {
  }
  
  Nullable put(K key, V value) {
    return ([&]() { auto let_var = this->_items; return ([&]() { auto let_var = key; return ([&]() { auto let_var = value; return ([&]() { auto let_var = let_var->operator_index_set(let_var, let_var); return let_var; })(); })(); })(); })();
  }
  
  V get(K key) {
    return this->_items->operator_index(key);
  }
  
  Int size() {
    return this->_items->size();
  }
  
  ObjectPtr<Iterable> keys() {
    return this->_items->keys();
  }
  
  ObjectPtr<Iterable> values() {
    return this->_items->values();
  }
  
};

// ============================================================================
// 类: BinaryTree
// ============================================================================

template<typename T>
class BinaryTree {
private:
  ObjectPtr<TreeNode> _root = Null;
  Int _size = dart_int(0);
public:
  BinaryTree() {
  }
  
  Nullable insert(T value) {
    this->_root = this->_insertNode(this->_root, value);
this->_size = this->_size->operator_add(dart_int(1));
return Void;
  }
  
  Bool contains(T value) {
    return !(dart_is_null(this->_findNode(this->_root, value)));
  }
  
  Int size() {
    return this->_size;
  }
  
  ObjectPtr<TreeNode> _insertNode(ObjectPtr<TreeNode> node, T value) {
    if (dart_is_null(node)) {
return ObjectPtr<TreeNode<T>>(new TreeNode<T>(value));
}
if (value->compareTo(node->value)->operator_less(dart_int(0))) {
node->left = this->_insertNode(node->left, value);
} else {
node->right = this->_insertNode(node->right, value);
}
return node;
  }
  
  ObjectPtr<TreeNode> _findNode(ObjectPtr<TreeNode> node, T value) {
    if (dart_is_null(node)) {
return Null;
}
auto comparison = value->compareTo(node->value);
if ((comparison == dart_int(0))) {
return node;
}
if (comparison->operator_less(dart_int(0))) {
return this->_findNode(node->left, value);
}
return this->_findNode(node->right, value);
  }
  
};

// ============================================================================
// 类: TreeNode
// ============================================================================

template<typename T>
class TreeNode {
public:
  T value;
  ObjectPtr<TreeNode> left = Null;
  ObjectPtr<TreeNode> right = Null;
  TreeNode(T value) : value(value) {
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

template<typename T>
class AnimalProcessor {
public:
  AnimalProcessor() {
  }
  
  Nullable process(T animal) {
    dart_print(dart_concat(dart_string("      处理动物: "), (animal->name).toString(), dart_string(", 声音: "), (animal->makeSound()).toString()));
return Void;
  }
  
};

// ============================================================================
// 类: Producer
// ============================================================================

template<typename T>
class Producer {
public:
  virtual ~Producer() = default;
  
  virtual T produce() = 0;
};

// ============================================================================
// 类: Consumer
// ============================================================================

template<typename T>
class Consumer {
public:
  virtual ~Consumer() = default;
  
  virtual Nullable consume(T item) = 0;
};

// ============================================================================
// 类: DogProducer
// ============================================================================

class DogProducer : virtual public Producer<ObjectPtr<Dog>> {
public:
  DogProducer() {
  }
  
  ObjectPtr<Dog> produce() {
    return ObjectPtr<Dog>(new Dog(dart_string("Produced Dog"), dart_string("Golden Retriever")));
  }
  
};

// ============================================================================
// 类: AnimalConsumer
// ============================================================================

class AnimalConsumer : virtual public Consumer<ObjectPtr<Animal>> {
public:
  AnimalConsumer() {
  }
  
  Nullable consume(ObjectPtr<Animal> animal) {
    dart_print(dart_string("      消费动物: ") + (animal->name).toString());
return Void;
  }
  
};

// ============================================================================
// 类: Person
// ============================================================================

class Person : virtual public Serializable {
public:
  String name;
  Int age;
  Person(String name, Int age) : name(name), age(age) {
  }
  
  ObjectPtr<Map<String, Any>> toJson() {
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
  
  ObjectPtr<Map<String, Any>> toJson() {
    return ([&]() { const auto unnamed_var = LinkedHashMap::of(this->toJson()); unnamed_var->operator_index_set(dart_string("studentId"), this->studentId); return unnamed_var; })();
  }
  
};

// ============================================================================
// 类: Repository
// ============================================================================

template<typename T>
class Repository {
public:
  virtual ~Repository() = default;
  
  virtual Nullable save(T item) = 0;
  virtual T findById(String id) = 0;
  virtual ObjectPtr<List<T>> findAll() = 0;
};

// ============================================================================
// 类: StringRepository
// ============================================================================

class StringRepository : virtual public Repository<String> {
private:
  ObjectPtr<List<String>> _items = dart_literal<String>();
public:
  StringRepository() {
  }
  
  Nullable save(String item) {
    return this->_items->add(item);
  }
  
  String findById(String id) {
    return this->_items->contains(id) ? id : Null;
  }
  
  ObjectPtr<List<String>> findAll() {
    return List<String>::from(this->_items);
  }
  
};

// ============================================================================
// 类: IntRepository
// ============================================================================

class IntRepository : virtual public Repository<Int> {
private:
  ObjectPtr<List<Int>> _items = dart_literal<Int>();
public:
  IntRepository() {
  }
  
  Nullable save(Int item) {
    return this->_items->add(item);
  }
  
  Int findById(String id) {
    auto intId = Int::tryParse(id, nullptr);
return !(dart_is_null(intId)) && this->_items->contains(intId) ? intId : Null;
  }
  
  ObjectPtr<List<Int>> findAll() {
    return List<Int>::from(this->_items);
  }
  
};

// ============================================================================
// 类: Converter
// ============================================================================

template<typename T, typename R>
class Converter {
public:
  virtual ~Converter() = default;
  
  virtual R convert(T input) = 0;
};

// ============================================================================
// 类: StringToIntConverter
// ============================================================================

class StringToIntConverter : virtual public Converter<String, Int> {
public:
  StringToIntConverter() {
  }
  
  Int convert(String input) {
    return Int::parse(input, nullptr, nullptr);
  }
  
};

// ============================================================================
// 类: IntToStringConverter
// ============================================================================

class IntToStringConverter : virtual public Converter<Int, String> {
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

template<typename T>
class Validator {
public:
  virtual ~Validator() = default;
  
  virtual Bool validate(T input) = 0;
};

// ============================================================================
// 类: EmailValidator
// ============================================================================

class EmailValidator : virtual public Validator<String> {
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

class AgeValidator : virtual public Validator<Int> {
public:
  AgeValidator() {
  }
  
  Bool validate(Int input) {
    return input->operator_greater_equals(dart_int(0)) && input->operator_less_equals(dart_int(150));
  }
  
};

Nullable testGenericClasses();
Nullable testGenericMethods();
Nullable testTypeConstraints();
Nullable testGenericCollections();
Nullable testVariance();
Nullable testGenericInterfaces();
template<typename T>
T identity(T value);
template<typename T>
ObjectPtr<Pair> swap(T a, T b);
template<typename T>
T getFirst(ObjectPtr<List<T>> list);
template<typename T, typename R>
ObjectPtr<List<R>> mapList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> mapper);
template<typename T>
ObjectPtr<List<T>> filterList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<std::function<Bool(T)>, Bool, T>> predicate);
template<typename T>
T reduceList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<std::function<T(T, T)>, T, T, T>> reducer);
Nullable processAnimals(ObjectPtr<List<ObjectPtr<Animal>>> animals);
Nullable testGenericClasses() {
  dart_print(dart_string("\n📌 测试泛型类"));
auto intBox = ObjectPtr<Box<Int>>(new Box<Int>(dart_int(42)));
auto stringBox = ObjectPtr<Box<String>>(new Box<String>(dart_string("Hello")));
auto boolBox = ObjectPtr<Box<Bool>>(new Box<Bool>(dart_bool(true)));
dart_print(dart_string("  基本泛型类:"));
dart_print(dart_string("    整数盒子: ") + (intBox->getValue()).toString());
dart_print(dart_string("    字符串盒子: ") + (stringBox->getValue()).toString());
dart_print(dart_string("    布尔盒子: ") + (boolBox->getValue()).toString());
intBox->setValue(dart_int(100));
stringBox->setValue(dart_string("World"));
dart_print(dart_string("  修改后:"));
dart_print(dart_string("    整数盒子: ") + (intBox->getValue()).toString());
dart_print(dart_string("    字符串盒子: ") + (stringBox->getValue()).toString());
auto pair = ObjectPtr<Pair<String, Int>>(new Pair<String, Int>(dart_string("Alice"), dart_int(25)));
dart_print(dart_string("  多泛型参数:"));
dart_print(dart_concat(dart_string("    键值对: "), (pair->first()).toString(), dart_string(" -> "), (pair->second).toString()));
pair->swap();
dart_print(dart_concat(dart_string("    交换后: "), (pair->first()).toString(), dart_string(" -> "), (pair->second).toString()));
auto nestedBox = ObjectPtr<Box<ObjectPtr<Box>>>(new Box<ObjectPtr<Box>>(ObjectPtr<Box<String>>(new Box<String>(dart_string("Nested")))));
dart_print(dart_string("  嵌套泛型: ") + (nestedBox->getValue()->getValue()).toString());
auto numberContainer = ObjectPtr<NumberContainer<Int>>(new NumberContainer<Int>(dart_int(42)));
numberContainer->add(dart_int(10));
dart_print(dart_string("  泛型继承: ") + (numberContainer->getValue()).toString());
auto doubleContainer = ObjectPtr<NumberContainer<Double>>(new NumberContainer<Double>(dart_double(3.14)));
doubleContainer->multiply(dart_double(2.0));
dart_print(dart_string("  浮点容器: ") + (doubleContainer->getValue()).toString());
auto factory = ObjectPtr<ContainerFactory<String>>(new ContainerFactory<String>());
auto container1 = factory->create(dart_string("Hello"));
auto container2 = factory->create(dart_string("World"));
dart_print(dart_string("  泛型工厂:"));
dart_print(dart_string("    容器1: ") + (container1->getValue()).toString());
dart_print(dart_string("    容器2: ") + (container2->getValue()).toString());
return Void;
}

Nullable testGenericMethods() {
  dart_print(dart_string("\n📌 测试泛型方法"));
auto stringResult = identity(dart_string("Hello"));
auto intResult = identity(dart_int(42));
auto boolResult = identity(dart_bool(true));
dart_print(dart_string("  基本泛型方法:"));
dart_print(dart_string("    identity<String>: ") + (stringResult).toString());
dart_print(dart_string("    identity<int>: ") + (intResult).toString());
dart_print(dart_string("    identity<bool>: ") + (boolResult).toString());
auto inferredString = identity(dart_string("Inferred"));
auto inferredInt = identity(dart_int(100));
dart_print(dart_string("  类型推断:"));
dart_print(dart_string("    推断字符串: ") + (inferredString).toString());
dart_print(dart_string("    推断整数: ") + (inferredInt).toString());
auto a = dart_string("First");
auto b = dart_string("Second");
auto swapped = swap(a, b);
dart_print(dart_string("  泛型交换:"));
dart_print(dart_concat(dart_string("    交换前: "), (a).toString(), dart_string(", "), (b).toString()));
dart_print(dart_concat(dart_string("    交换后: "), (swapped->first()).toString(), dart_string(", "), (swapped->second).toString()));
auto numbers = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto strings = dart_literal<String>(dart_string("a"), dart_string("b"), dart_string("c"));
auto firstNumber = getFirst(numbers);
auto firstString = getFirst(strings);
dart_print(dart_string("  泛型列表操作:"));
dart_print(dart_string("    第一个数字: ") + (firstNumber).toString());
dart_print(dart_string("    第一个字符串: ") + (firstString).toString());
auto numberStrings = mapList(numbers, makeFunction([&](Int n) { return dart_string("Number: ") + (n).toString(); }));
dart_print(dart_string("    转换结果: ") + (numberStrings->take(dart_int(3))->toList()).toString());
auto evenNumbers = filterList(numbers, makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }));
dart_print(dart_string("    偶数过滤: ") + (evenNumbers).toString());
auto sum = reduceList(numbers, makeFunction([&](Int a, Int b) { return a->operator_add(b); }));
auto concatenated = reduceList(dart_literal<String>(dart_string("a"), dart_string("b"), dart_string("c")), makeFunction([&](String a, String b) { return a->operator_add(b); }));
dart_print(dart_string("  泛型归约:"));
dart_print(dart_string("    数字求和: ") + (sum).toString());
dart_print(dart_string("    字符串连接: ") + (concatenated).toString());
return Void;
}

Nullable testTypeConstraints() {
  dart_print(dart_string("\n📌 测试类型约束"));
auto intCalculator = ObjectPtr<NumberCalculator<Int>>(new NumberCalculator<Int>());
auto doubleCalculator = ObjectPtr<NumberCalculator<Double>>(new NumberCalculator<Double>());
dart_print(dart_string("  数字约束:"));
dart_print(dart_string("    整数计算: ") + (intCalculator->add(dart_int(5), dart_int(3))).toString());
dart_print(dart_string("    浮点计算: ") + (doubleCalculator->add(dart_double(2.5), dart_double(1.5))).toString());
dart_print(dart_string("    整数最大值: ") + (intCalculator->max(dart_int(10), dart_int(5))).toString());
dart_print(dart_string("    浮点最大值: ") + (doubleCalculator->max(dart_double(3.14), dart_double(2.71))).toString());
auto intComparator = ObjectPtr<Comparator<Int>>(new Comparator<Int>());
auto stringComparator = ObjectPtr<Comparator<String>>(new Comparator<String>());
dart_print(dart_string("  比较约束:"));
dart_print(dart_string("    整数比较: ") + (intComparator->max(dart_int(10), dart_int(5))).toString());
dart_print(dart_string("    字符串比较: ") + (stringComparator->max(dart_string("apple"), dart_string("banana"))).toString());
dart_print(dart_string("    整数排序: ") + (intComparator->sort(dart_literal<Int>(dart_int(3), dart_int(1), dart_int(4), dart_int(1), dart_int(5)))).toString());
auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25)));
auto student = ObjectPtr<Student>(new Student(dart_string("Bob"), dart_int(20), dart_string("S001")));
auto personSerializer = ObjectPtr<Serializer<ObjectPtr<Person>>>(new Serializer<ObjectPtr<Person>>());
auto studentSerializer = ObjectPtr<Serializer<ObjectPtr<Student>>>(new Serializer<ObjectPtr<Student>>());
dart_print(dart_string("  序列化约束:"));
dart_print(dart_string("    人员序列化: ") + (personSerializer->serialize(person)).toString());
dart_print(dart_string("    学生序列化: ") + (studentSerializer->serialize(student)).toString());
auto listProcessor = ObjectPtr<CollectionProcessor<ObjectPtr<List<Int>>>>(new CollectionProcessor<ObjectPtr<List<Int>>>());
auto setProcessor = ObjectPtr<CollectionProcessor<ObjectPtr<Set<String>>>>(new CollectionProcessor<ObjectPtr<Set<String>>>());
dart_print(dart_string("  集合约束:"));
dart_print(dart_string("    列表大小: ") + (listProcessor->getSize(dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)))).toString());
dart_print(dart_string("    集合大小: ") + (setProcessor->getSize(([&]() { const auto unnamed_var = ObjectPtr<Set<String>>(new Set<String>()); unnamed_var->add(dart_string("a")); unnamed_var->add(dart_string("b")); unnamed_var->add(dart_string("c")); return unnamed_var; })())).toString());
auto advancedProcessor = ObjectPtr<AdvancedProcessor<ObjectPtr<Person>>>(new AdvancedProcessor<ObjectPtr<Person>>());
dart_print(dart_string("    高级处理: ") + (advancedProcessor->process(person)).toString());
return Void;
}

Nullable testGenericCollections() {
  dart_print(dart_string("\n📌 测试泛型集合"));
auto intList = ObjectPtr<GenericList<Int>>(new GenericList<Int>());
intList->add(dart_int(1));
intList->add(dart_int(2));
intList->add(dart_int(3));
dart_print(dart_string("  自定义泛型列表:"));
dart_print(dart_string("    列表内容: ") + (intList->toList()).toString());
dart_print(dart_string("    列表大小: ") + (intList->get_size()).toString());
dart_print(dart_string("    获取索引1: ") + (intList->get(dart_int(1))).toString());
auto stringStack = ObjectPtr<GenericStack<String>>(new GenericStack<String>());
stringStack->push(dart_string("First"));
stringStack->push(dart_string("Second"));
stringStack->push(dart_string("Third"));
dart_print(dart_string("  自定义泛型栈:"));
dart_print(dart_string("    栈顶元素: ") + (stringStack->peek()).toString());
dart_print(dart_string("    弹出元素: ") + (stringStack->pop()).toString());
dart_print(dart_string("    栈大小: ") + (stringStack->get_size()).toString());
auto intQueue = ObjectPtr<GenericQueue<Int>>(new GenericQueue<Int>());
intQueue->enqueue(dart_int(10));
intQueue->enqueue(dart_int(20));
intQueue->enqueue(dart_int(30));
dart_print(dart_string("  自定义泛型队列:"));
dart_print(dart_string("    队列前端: ") + (intQueue->front()).toString());
dart_print(dart_string("    出队元素: ") + (intQueue->dequeue()).toString());
dart_print(dart_string("    队列大小: ") + (intQueue->get_size()).toString());
auto stringIntMap = ObjectPtr<GenericMap<String, Int>>(new GenericMap<String, Int>());
stringIntMap->put(dart_string("one"), dart_int(1));
stringIntMap->put(dart_string("two"), dart_int(2));
stringIntMap->put(dart_string("three"), dart_int(3));
dart_print(dart_string("  泛型映射:"));
dart_print(dart_string("    获取值: ") + (stringIntMap->get(dart_string("two"))).toString());
dart_print(dart_string("    映射大小: ") + (stringIntMap->get_size()).toString());
dart_print(dart_string("    所有键: ") + (stringIntMap->keys()).toString());
auto intTree = ObjectPtr<BinaryTree<Int>>(new BinaryTree<Int>());
intTree->insert(dart_int(5));
intTree->insert(dart_int(3));
intTree->insert(dart_int(7));
intTree->insert(dart_int(1));
intTree->insert(dart_int(9));
dart_print(dart_string("  泛型二叉树:"));
dart_print(dart_string("    包含5: ") + (intTree->contains(dart_int(5))).toString());
dart_print(dart_string("    包含6: ") + (intTree->contains(dart_int(6))).toString());
dart_print(dart_string("    树的大小: ") + (intTree->get_size()).toString());
return Void;
}

Nullable testVariance() {
  dart_print(dart_string("\n📌 测试协变和逆变"));
auto animalList = dart_literal<ObjectPtr<Animal>>(/* Invalid: temp_dart_source.dart:260:32: Error: Too few positional arguments: 2 required, 1 given.
  var animalList = <Animal>[Dog('Buddy'), Cat('Whiskers')];
                               ^ */, /* Invalid: temp_dart_source.dart:260:46: Error: Too few positional arguments: 2 required, 1 given.
  var animalList = <Animal>[Dog('Buddy'), Cat('Whiskers')];
                                             ^ */);
auto dogList = dart_literal<ObjectPtr<Dog>>(/* Invalid: temp_dart_source.dart:261:26: Error: Too few positional arguments: 2 required, 1 given.
  var dogList = <Dog>[Dog('Max'), Dog('Rex')];
                         ^ */, /* Invalid: temp_dart_source.dart:261:38: Error: Too few positional arguments: 2 required, 1 given.
  var dogList = <Dog>[Dog('Max'), Dog('Rex')];
                                     ^ */);
auto animals = dogList;
dart_print(dart_string("  协变示例:"));
dart_print(dart_string("    动物列表:"));
auto sync_for_iterator = animals->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto animal = sync_for_iterator->next();
dart_print(dart_concat(dart_string("      "), (animal->name).toString(), dart_string(" 说: "), (animal->makeSound()).toString()));
}
auto animalHandler = makeFunction([&](ObjectPtr<Animal> animal) { dart_print(dart_string("      处理动物: ") + (animal->name).toString()); });
auto dogHandler = makeFunction([&](ObjectPtr<Dog> dog) { dart_print(dart_concat(dart_string("      处理狗: "), (dog->name).toString(), dart_string(", 品种: "), (dog->breed).toString())); });
dogHandler = animalHandler;
dogHandler->call(ObjectPtr<Dog>(new Dog(dart_string("Covariant Dog"), dart_string("Labrador"))));
auto processor = ObjectPtr<AnimalProcessor<ObjectPtr<Dog>>>(new AnimalProcessor<ObjectPtr<Dog>>());
processor->process(ObjectPtr<Dog>(new Dog(dart_string("Generic Dog"), dart_string("Poodle"))));
processAnimals(dart_literal<ObjectPtr<Animal>>(ObjectPtr<Dog>(new Dog(dart_string("Dog1"), dart_string("Beagle"))), ObjectPtr<Cat>(new Cat(dart_string("Cat1"), dart_string("Siamese")))));
return Void;
}

Nullable testGenericInterfaces() {
  dart_print(dart_string("\n📌 测试泛型接口"));
auto stringRepo = ObjectPtr<StringRepository>(new StringRepository());
stringRepo->save(dart_string("Hello"));
stringRepo->save(dart_string("World"));
dart_print(dart_string("  泛型仓库:"));
dart_print(dart_string("    查找: ") + (stringRepo->findById(dart_string("Hello"))).toString());
dart_print(dart_string("    所有项: ") + (stringRepo->findAll()).toString());
auto intRepo = ObjectPtr<IntRepository>(new IntRepository());
intRepo->save(dart_int(42));
intRepo->save(dart_int(100));
dart_print(dart_string("    整数仓库: ") + (intRepo->findAll()).toString());
auto stringToInt = ObjectPtr<StringToIntConverter>(new StringToIntConverter());
auto intToString = ObjectPtr<IntToStringConverter>(new IntToStringConverter());
dart_print(dart_string("  泛型转换器:"));
dart_print(dart_string("    字符串转整数: ") + (stringToInt->convert(dart_string("123"))).toString());
dart_print(dart_string("    整数转字符串: ") + (intToString->convert(dart_int(456))).toString());
auto emailValidator = ObjectPtr<EmailValidator>(new EmailValidator());
auto ageValidator = ObjectPtr<AgeValidator>(new AgeValidator());
dart_print(dart_string("  泛型验证器:"));
dart_print(dart_string("    邮箱验证: ") + (emailValidator->validate(dart_string("test@example.com"))).toString());
dart_print(dart_string("    年龄验证: ") + (ageValidator->validate(dart_int(25))).toString());
dart_print(dart_string("    无效邮箱: ") + (emailValidator->validate(dart_string("invalid"))).toString());
dart_print(dart_string("    无效年龄: ") + (ageValidator->validate(dart_int(-5))).toString());
return Void;
}

template<typename T>
T identity(T value) {
  return value;
}

template<typename T>
ObjectPtr<Pair> swap(T a, T b) {
  return ObjectPtr<Pair<T, T>>(new Pair<T, T>(b, a));
}

template<typename T>
T getFirst(ObjectPtr<List<T>> list) {
  return list->first();
}

template<typename T, typename R>
ObjectPtr<List<R>> mapList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> mapper) {
  return list->map(mapper)->toList();
}

template<typename T>
ObjectPtr<List<T>> filterList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<std::function<Bool(T)>, Bool, T>> predicate) {
  return list->where(predicate)->toList();
}

template<typename T>
T reduceList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<std::function<T(T, T)>, T, T, T>> reducer) {
  return list->reduce(reducer);
}

Nullable processAnimals(ObjectPtr<List<ObjectPtr<Animal>>> animals) {
  dart_print(dart_string("  处理动物列表:"));
auto sync_for_iterator = animals->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto animal = sync_for_iterator->next();
dart_print(dart_concat(dart_string("    "), (animal->name).toString(), dart_string(": "), (animal->makeSound()).toString()));
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

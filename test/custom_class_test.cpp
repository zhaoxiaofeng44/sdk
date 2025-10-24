#include "../pkg/dart2bytecode/base/object.h"
#include <iostream>
#include <memory>

// ============================================================================
// 自定义类定义 - 必须通过ObjectPtr使用
// ============================================================================

// 1. 基础自定义类 - Animal（动物）
class Animal : public Object {
private:
    String name_;
    Int age_;
    
protected:
    // 受保护的构造函数，允许派生类访问，但防止直接实例化
    Animal(const String& name, const Int& age) : name_(name), age_(age) {
        std::cout << "Animal构造: " << name_.getValue() << std::endl;
    }
    
public:
    // 静态工厂方法，返回ObjectPtr
    static ObjectPtr<Animal> create(const String& name, const Int& age) {
        return ObjectPtr<Animal>(new Animal(name, age));
    }
    
    virtual ~Animal() {
        std::cout << "Animal析构: " << name_.getValue() << std::endl;
    }
    
    // Getter方法
    String getName() const { return name_; }
    Int getAge() const { return age_; }
    
    // 虚方法 - 多态
    virtual String makeSound() const {
        return String("Some sound");
    }
    
    virtual String toString() const {
        return String("Animal(name: ") + name_ + String(", age: ") + age_.toString() + String(")");
    }
    
    // 对象比较
    Bool equals(const Animal& other) const {
        return name_ == other.name_ && age_ == other.age_;
    }
    
    // 运算符重载
    bool operator==(const Animal& other) const {
        return equals(other).value;
    }
};

// 2. 继承类 - Dog（狗）
class Dog : public Animal {
private:
    String breed_;
    
    Dog(const String& name, const Int& age, const String& breed)
        : Animal(name, age), breed_(breed) {
        std::cout << "Dog构造: " << name.getValue() << std::endl;
    }
    
public:
    // 返回Dog类型的工厂方法
    static ObjectPtr<Dog> createDog(const String& name, const Int& age, const String& breed) {
        return ObjectPtr<Dog>(new Dog(name, age, breed));
    }
    
    // 返回Animal类型的工厂方法（用于多态）
    static ObjectPtr<Animal> create(const String& name, const Int& age, const String& breed) {
        return ObjectPtr<Animal>(new Dog(name, age, breed));
    }
    
    virtual ~Dog() {
        std::cout << "Dog析构: " << getName().getValue() << std::endl;
    }
    
    String getBreed() const { return breed_; }
    
    // 方法重写
    virtual String makeSound() const override {
        return String("Woof! Woof!");
    }
    
    virtual String toString() const override {
        return String("Dog(name: ") + getName() + 
               String(", age: ") + getAge().toString() +
               String(", breed: ") + breed_ + String(")");
    }
};

// 3. 继承类 - Cat（猫）
class Cat : public Animal {
private:
    Bool isIndoor_;
    
    Cat(const String& name, const Int& age, const Bool& isIndoor)
        : Animal(name, age), isIndoor_(isIndoor) {
        std::cout << "Cat构造: " << name.getValue() << std::endl;
    }
    
public:
    // 返回Cat类型的工厂方法
    static ObjectPtr<Cat> createCat(const String& name, const Int& age, const Bool& isIndoor) {
        return ObjectPtr<Cat>(new Cat(name, age, isIndoor));
    }
    
    // 返回Animal类型的工厂方法（用于多态）
    static ObjectPtr<Animal> create(const String& name, const Int& age, const Bool& isIndoor) {
        return ObjectPtr<Animal>(new Cat(name, age, isIndoor));
    }
    
    virtual ~Cat() {
        std::cout << "Cat析构: " << getName().getValue() << std::endl;
    }
    
    Bool getIsIndoor() const { return isIndoor_; }
    
    virtual String makeSound() const override {
        return String("Meow! Meow!");
    }
    
    virtual String toString() const override {
        return String("Cat(name: ") + getName() + 
               String(", age: ") + getAge().toString() +
               String(", indoor: ") + (isIndoor_.value ? String("yes") : String("no")) + String(")");
    }
};

// 4. 复杂自定义类 - Person（人）
class Person : public Object {
private:
    String name_;
    Int age_;
    List<ObjectPtr<Animal>> pets_;
    
    Person(const String& name, const Int& age) : name_(name), age_(age) {
        std::cout << "Person构造: " << name_.getValue() << std::endl;
    }
    
public:
    static ObjectPtr<Person> create(const String& name, const Int& age) {
        return ObjectPtr<Person>(new Person(name, age));
    }
    
    virtual ~Person() {
        std::cout << "Person析构: " << name_.getValue() << std::endl;
    }
    
    String getName() const { return name_; }
    Int getAge() const { return age_; }
    
    void addPet(ObjectPtr<Animal> pet) {
        pets_.add(pet);
    }
    
    Int getPetCount() const {
        return pets_.size();
    }
    
    void listPets() const {
        std::cout << name_.getValue() << "的宠物:" << std::endl;
        pets_.forEach([](const ObjectPtr<Animal>& pet) {
            std::cout << "  - " << pet->getName().getValue() 
                      << " (" << pet->makeSound().getValue() << ")" << std::endl;
        });
    }
    
    virtual String toString() const {
        return String("Person(name: ") + name_ + 
               String(", age: ") + age_.toString() +
               String(", pets: ") + pets_.size().toString() + String(")");
    }
};

// 5. 泛型数据容器类
template<typename T>
class DataContainer : public Object {
private:
    T data_;
    String label_;
    
    DataContainer(const T& data, const String& label) 
        : data_(data), label_(label) {
        std::cout << "DataContainer构造: " << label_.getValue() << std::endl;
    }
    
public:
    static ObjectPtr<DataContainer<T>> create(const T& data, const String& label) {
        return ObjectPtr<DataContainer<T>>(new DataContainer<T>(data, label));
    }
    
    virtual ~DataContainer() {
        std::cout << "DataContainer析构: " << label_.getValue() << std::endl;
    }
    
    T getData() const { return data_; }
    String getLabel() const { return label_; }
    
    void setData(const T& data) { data_ = data; }
    
    virtual String toString() const override {
        return String("DataContainer(label: ") + label_ + String(")");
    }
};

// 6. 接口类 - Drawable
class Drawable {
public:
    virtual void draw() const = 0;
    virtual ~Drawable() {}
};

// 7. 实现接口的类 - Shape
class Shape : public Object, public Drawable {
private:
    String color_;
    Double size_;
    
    Shape(const String& color, const Double& size) 
        : color_(color), size_(size) {
        std::cout << "Shape构造: " << color_.getValue() << std::endl;
    }
    
public:
    static ObjectPtr<Shape> create(const String& color, const Double& size) {
        return ObjectPtr<Shape>(new Shape(color, size));
    }
    
    virtual ~Shape() {
        std::cout << "Shape析构: " << color_.getValue() << std::endl;
    }
    
    String getColor() const { return color_; }
    Double getSize() const { return size_; }
    
    virtual void draw() const override {
        std::cout << "绘制" << color_.getValue() << "形状，大小: " 
                  << size_.toDouble() << std::endl;
    }
    
    virtual String toString() const {
        return String("Shape(color: ") + color_ + 
               String(", size: ") + size_.toString() + String(")");
    }
};

// ============================================================================
// 前向声明（用于模板实例化）
// ============================================================================
class Animal;
class Dog;
class Cat;
class Person;

// ============================================================================
// 测试函数
// ============================================================================

// 测试1: 基本对象创建和使用
void test_basic_object_creation() {
    std::cout << "\n=== 测试1: 基本对象创建和使用 ===" << std::endl;
    
    // 创建Animal对象（通过ObjectPtr）
    ObjectPtr<Animal> animal = Animal::create(String("Generic"), Int(5));
    
    std::cout << "动物名称: " << animal->getName().getValue() << std::endl;
    std::cout << "动物年龄: " << animal->getAge().toInt() << std::endl;
    std::cout << "动物叫声: " << animal->makeSound().getValue() << std::endl;
    std::cout << "toString: " << animal->toString().getValue() << std::endl;
}

// 测试2: 继承和多态
void test_inheritance_and_polymorphism() {
    std::cout << "\n=== 测试2: 继承和多态 ===" << std::endl;
    
    // 创建Dog和Cat对象
    ObjectPtr<Dog> dog = Dog::createDog(String("Buddy"), Int(3), String("Golden Retriever"));
    ObjectPtr<Cat> cat = Cat::createCat(String("Whiskers"), Int(2), Bool(true));
    
    std::cout << "狗: " << dog->toString().getValue() << std::endl;
    std::cout << "狗叫声: " << dog->makeSound().getValue() << std::endl;
    
    std::cout << "猫: " << cat->toString().getValue() << std::endl;
    std::cout << "猫叫声: " << cat->makeSound().getValue() << std::endl;
    
    // 多态测试 - 使用基类指针
    std::cout << "\n多态测试:" << std::endl;
    List<ObjectPtr<Animal>> animals;
    // 通过基类工厂方法创建，实现多态
    animals.add(Dog::createDog(String("Poly1"), Int(3), String("Breed1")));
    animals.add(Cat::createCat(String("Poly2"), Int(2), Bool(true)));
    
    animals.forEach([](const ObjectPtr<Animal>& animal) {
        std::cout << "  " << animal->getName().getValue() 
                  << " 说: " << animal->makeSound().getValue() << std::endl;
    });
}

// 测试3: 对象组合
void test_object_composition() {
    std::cout << "\n=== 测试3: 对象组合 ===" << std::endl;
    
    // 创建Person和宠物
    ObjectPtr<Person> person = Person::create(String("Alice"), Int(25));
    
    ObjectPtr<Dog> dog1 = Dog::createDog(String("Max"), Int(4), String("Labrador"));
    ObjectPtr<Dog> dog2 = Dog::createDog(String("Charlie"), Int(2), String("Beagle"));
    ObjectPtr<Cat> cat = Cat::createCat(String("Luna"), Int(3), Bool(true));
    
    person->addPet(dog1);
    person->addPet(dog2);
    person->addPet(cat);
    
    std::cout << person->toString().getValue() << std::endl;
    person->listPets();
}

// 测试4: ObjectPtr引用计数
void test_reference_counting() {
    std::cout << "\n=== 测试4: ObjectPtr引用计数 ===" << std::endl;
    
    ObjectPtr<Animal> animal1 = Animal::create(String("Shared"), Int(5));
    std::cout << "创建animal1" << std::endl;
    
    {
        ObjectPtr<Animal> animal2 = animal1;  // 共享引用
        std::cout << "创建animal2（共享引用）" << std::endl;
        std::cout << "animal2名称: " << animal2->getName().getValue() << std::endl;
    }  // animal2离开作用域
    
    std::cout << "animal2已销毁，animal1仍然有效" << std::endl;
    std::cout << "animal1名称: " << animal1->getName().getValue() << std::endl;
}

// 测试5: 泛型容器与自定义类
void test_generic_containers() {
    std::cout << "\n=== 测试5: 泛型容器与自定义类 ===" << std::endl;
    
    // List<ObjectPtr<Animal>>
    List<ObjectPtr<Animal>> animalList;
    animalList.add(Dog::createDog(String("Rex"), Int(5), String("German Shepherd")));
    animalList.add(Cat::createCat(String("Mittens"), Int(3), Bool(false)));
    animalList.add(Dog::createDog(String("Spot"), Int(2), String("Dalmatian")));
    
    std::cout << "动物列表大小: " << animalList.size().toInt() << std::endl;
    std::cout << "遍历动物列表:" << std::endl;
    animalList.forEach([](const ObjectPtr<Animal>& animal) {
        std::cout << "  " << animal->toString().getValue() << std::endl;
    });
    
    // Map<String, ObjectPtr<Animal>>
    Map<String, ObjectPtr<Animal>> animalMap;
    animalMap.put(String("dog1"), Dog::createDog(String("Fido"), Int(4), String("Poodle")));
    animalMap.put(String("cat1"), Cat::createCat(String("Fluffy"), Int(2), Bool(true)));
    
    std::cout << "\n动物Map:" << std::endl;
    animalMap.forEach([](const String& key, const ObjectPtr<Animal>& animal) {
        std::cout << "  " << key.getValue() << ": " 
                  << animal->getName().getValue() << std::endl;
    });
}

// 测试6: 泛型DataContainer
void test_generic_data_container() {
    std::cout << "\n=== 测试6: 泛型DataContainer ===" << std::endl;
    
    // DataContainer<Int>
    ObjectPtr<DataContainer<Int>> intContainer = 
        DataContainer<Int>::create(Int(42), String("整数容器"));
    std::cout << "整数容器值: " << intContainer->getData().toInt() << std::endl;
    
    // DataContainer<String>
    ObjectPtr<DataContainer<String>> stringContainer = 
        DataContainer<String>::create(String("Hello"), String("字符串容器"));
    std::cout << "字符串容器值: " << stringContainer->getData().getValue() << std::endl;
    
    // DataContainer<ObjectPtr<Animal>>
    ObjectPtr<DataContainer<ObjectPtr<Animal>>> animalContainer = 
        DataContainer<ObjectPtr<Animal>>::create(
            Dog::createDog(String("Rover"), Int(3), String("Bulldog")),
            String("动物容器")
        );
    std::cout << "动物容器值: " << animalContainer->getData()->getName().getValue() << std::endl;
}

// 测试7: 接口实现
void test_interface_implementation() {
    std::cout << "\n=== 测试7: 接口实现 ===" << std::endl;
    
    ObjectPtr<Shape> shape1 = Shape::create(String("红色"), Double(10.5));
    ObjectPtr<Shape> shape2 = Shape::create(String("蓝色"), Double(15.0));
    
    std::cout << "形状1: " << shape1->toString().getValue() << std::endl;
    shape1->draw();
    
    std::cout << "形状2: " << shape2->toString().getValue() << std::endl;
    shape2->draw();
}

// 测试8: 对象比较和相等性
void test_object_equality() {
    std::cout << "\n=== 测试8: 对象比较和相等性 ===" << std::endl;
    
    ObjectPtr<Animal> animal1 = Animal::create(String("Test"), Int(5));
    ObjectPtr<Animal> animal2 = Animal::create(String("Test"), Int(5));
    ObjectPtr<Animal> animal3 = Animal::create(String("Other"), Int(3));
    
    // 使用ObjectPtr的相等性比较
    std::cout << "animal1 == animal2: " << (animal1 == animal2).value << std::endl;
    std::cout << "animal1 == animal3: " << (animal1 == animal3).value << std::endl;
    
    // 使用对象的equals方法
    std::cout << "animal1.equals(animal2): " << animal1->equals(*animal2.get()).value << std::endl;
}

// 测试9: 嵌套泛型
void test_nested_generics() {
    std::cout << "\n=== 测试9: 嵌套泛型 ===" << std::endl;
    
    // List<List<ObjectPtr<Animal>>>
    List<ObjectPtr<Animal>> dogList;
    dogList.add(Dog::createDog(String("Dog1"), Int(2), String("Breed1")));
    dogList.add(Dog::createDog(String("Dog2"), Int(3), String("Breed2")));
    
    List<ObjectPtr<Animal>> catList;
    catList.add(Cat::createCat(String("Cat1"), Int(1), Bool(true)));
    catList.add(Cat::createCat(String("Cat2"), Int(2), Bool(false)));
    
    std::cout << "狗列表大小: " << dogList.size().toInt() << std::endl;
    std::cout << "猫列表大小: " << catList.size().toInt() << std::endl;
    
    // Map<String, List<ObjectPtr<Animal>>>
    Map<String, Int> animalCounts;
    animalCounts.put(String("dogs"), dogList.size());
    animalCounts.put(String("cats"), catList.size());
    
    std::cout << "\n动物统计:" << std::endl;
    animalCounts.forEach([](const String& type, const Int& count) {
        std::cout << "  " << type.getValue() << ": " << count.toInt() << std::endl;
    });
}

// 测试10: 异常处理与自定义类
void test_exception_handling() {
    std::cout << "\n=== 测试10: 异常处理与自定义类 ===" << std::endl;
    
    try {
        ObjectPtr<Animal> nullAnimal;
        // 尝试访问null对象
        std::cout << "尝试访问null对象..." << std::endl;
        if (nullAnimal.isNull().value) {
            std::cout << "对象为null，安全检查通过" << std::endl;
        } else {
            String name = nullAnimal->getName();  // 这会抛出异常
        }
    } catch (const std::exception& e) {
        std::cout << "捕获异常: " << e.what() << std::endl;
    }
    
    // 正常对象
    ObjectPtr<Animal> validAnimal = Animal::create(String("Valid"), Int(3));
    if (validAnimal.isNotNull().value) {
        std::cout << "对象有效: " << validAnimal->getName().getValue() << std::endl;
    }
}

// 测试11: 复杂的对象图
void test_complex_object_graph() {
    std::cout << "\n=== 测试11: 复杂的对象图 ===" << std::endl;
    
    // 创建多个Person，每个有多个Pet
    List<ObjectPtr<Person>> people;
    
    ObjectPtr<Person> alice = Person::create(String("Alice"), Int(25));
    alice->addPet(Dog::createDog(String("Max"), Int(3), String("Labrador")));
    alice->addPet(Cat::createCat(String("Whiskers"), Int(2), Bool(true)));
    people.add(alice);
    
    ObjectPtr<Person> bob = Person::create(String("Bob"), Int(30));
    bob->addPet(Dog::createDog(String("Buddy"), Int(5), String("Golden Retriever")));
    people.add(bob);
    
    ObjectPtr<Person> charlie = Person::create(String("Charlie"), Int(28));
    charlie->addPet(Cat::createCat(String("Luna"), Int(1), Bool(true)));
    charlie->addPet(Cat::createCat(String("Shadow"), Int(3), Bool(false)));
    charlie->addPet(Dog::createDog(String("Rocky"), Int(4), String("Bulldog")));
    people.add(charlie);
    
    std::cout << "人员列表:" << std::endl;
    people.forEach([](const ObjectPtr<Person>& person) {
        std::cout << "\n" << person->toString().getValue() << std::endl;
        person->listPets();
    });
}

// 测试12: 泛型算法
void test_generic_algorithms() {
    std::cout << "\n=== 测试12: 泛型算法 ===" << std::endl;
    
    List<ObjectPtr<Animal>> animals;
    animals.add(Dog::createDog(String("Dog1"), Int(2), String("Breed1")));
    animals.add(Cat::createCat(String("Cat1"), Int(5), Bool(true)));
    animals.add(Dog::createDog(String("Dog2"), Int(3), String("Breed2")));
    animals.add(Cat::createCat(String("Cat2"), Int(1), Bool(false)));
    
    // 计算平均年龄
    Int totalAge(0);
    animals.forEach([&totalAge](const ObjectPtr<Animal>& animal) {
        totalAge = totalAge + animal->getAge();
    });
    Double avgAge = totalAge.toDouble() / Double(animals.size().toInt());
    std::cout << "平均年龄: " << avgAge.toDouble() << std::endl;
    
    // 查找最老的动物
    ObjectPtr<Animal> oldest = animals[Int(0)];
    animals.forEach([&oldest](const ObjectPtr<Animal>& animal) {
        if (animal->getAge() > oldest->getAge()) {
            oldest = animal;
        }
    });
    std::cout << "最老的动物: " << oldest->getName().getValue() 
              << " (" << oldest->getAge().toInt() << "岁)" << std::endl;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << "自定义类与ObjectPtr全面测试" << std::endl;
    std::cout << "========================================" << std::endl;
    
    try {
        test_basic_object_creation();
        test_inheritance_and_polymorphism();
        test_object_composition();
        test_reference_counting();
        test_generic_containers();
        test_generic_data_container();
        test_interface_implementation();
        test_object_equality();
        test_nested_generics();
        test_exception_handling();
        test_complex_object_graph();
        test_generic_algorithms();
        
        std::cout << "\n========================================" << std::endl;
        std::cout << "所有测试完成！" << std::endl;
        std::cout << "========================================" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "测试过程中发生异常: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}

// ============================================================================
// 模板显式实例化（必须在类定义之后）
// ============================================================================


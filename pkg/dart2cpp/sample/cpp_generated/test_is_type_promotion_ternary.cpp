#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Animal
// ============================================================================

class Animal {
public:
  String name;
  Animal(String name) : name(name) {
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
  
  Nullable bark() {
    dart_print((this->name).toString() + dart_string(" says: Woof! Woof!"));
return Void;
  }
  
};

// ============================================================================
// 类: Cat
// ============================================================================

class Cat : public Animal {
public:
  Bool isLazy;
  Cat(String name, Bool isLazy) : isLazy(isLazy), Animal(name) {
  }
  
  Nullable meow() {
    dart_print((this->name).toString() + dart_string(" says: Meow!"));
return Void;
  }
  
};

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto animal1 = ObjectPtr<Dog>(new Dog(dart_string("Rex"), dart_string("Labrador")));
auto result1 = dart_is<ObjectPtr<Dog>>(animal1) ? dart_cast<ObjectPtr<Dog>>(animal1)->bark() : dart_print(dart_string("Not a dog"));
auto animal2 = ObjectPtr<Cat>(new Cat(dart_string("Whiskers"), dart_bool(true)));
auto result2 = dart_is<ObjectPtr<Cat>>(animal2) && dart_cast<ObjectPtr<Cat>>(animal2)->isLazy ? dart_cast<ObjectPtr<Cat>>(animal2)->meow() : dart_print(dart_string("Not a lazy cat"));
auto obj1 = dart_string("Hello");
auto obj2 = dart_int(42);
auto result3 = dart_is<String>(obj1) && dart_is<Int>(obj2) ? dart_print(dart_concat((obj1->size()).toString(), dart_string(" and "), (obj2).toString())) : dart_print(dart_string("Type mismatch"));
auto animal3 = ObjectPtr<Dog>(new Dog(dart_string("Buddy"), dart_string("Golden Retriever")));
auto result4 = dart_is<ObjectPtr<Dog>>(animal3) && dart_cast<ObjectPtr<Dog>>(animal3)->breed->length->>(dart_int(5)) && dart_cast<ObjectPtr<Dog>>(animal3)->name->length->>(dart_int(3)) ? dart_print(dart_string("Long breed name: ") + (animal3->breed).toString()) : dart_print(dart_string("Short name"));
auto animal4 = ObjectPtr<Cat>(new Cat(dart_string("Tom"), dart_bool(false)));
auto result5 = dart_is<ObjectPtr<Cat>>(animal4) ? animal4->isLazy ? dart_print(dart_string("Lazy cat")) : dart_cast<ObjectPtr<Cat>>(animal4)->meow() : dart_print(dart_string("Not a cat"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

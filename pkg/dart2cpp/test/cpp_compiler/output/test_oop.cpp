#include "dart2cpp_lowered.h"

// === Forward declarations ===
struct AnimalValue;
struct DogValue;
struct CatValue;

// === Static function forward declarations ===
std::string Animal_speak(AnyPtr this__);
std::string Animal_toString(AnyPtr this__);
std::string Dog_speak(AnyPtr this__);
std::string Dog_toString(AnyPtr this__);
std::string Cat_speak(AnyPtr this__);

// === Animal: Value struct ===
struct AnimalValue : VPtr {
    std::string name{};
    int64_t age{};

    AnimalValue() {
        _typeName = "Animal";
        vptr["speak"] = reinterpret_cast<void*>(&Animal_speak);
        vptr["toString"] = reinterpret_cast<void*>(&Animal_toString);
    }

    static const char* staticTypeName() { return "Animal"; }
};

// === Dog: Value struct ===
struct DogValue : AnimalValue {
    std::string breed{};

    DogValue() {
        _typeName = "Dog";
        vptr["speak"] = reinterpret_cast<void*>(&Dog_speak);
        vptr["toString"] = reinterpret_cast<void*>(&Dog_toString);
    }

    static const char* staticTypeName() { return "Dog"; }
};

// === Cat: Value struct ===
struct CatValue : AnimalValue {
    bool isIndoor{};

    CatValue() {
        _typeName = "Cat";
        vptr["speak"] = reinterpret_cast<void*>(&Cat_speak);
    }

    static const char* staticTypeName() { return "Cat"; }
};

// === Static functions ===
std::string Animal_speak(AnyPtr this__) {
    auto this_ = static_cast<AnimalValue*>(this__.toVPtr());
    return dart_str(this_->name, " says hello");
}

std::string Animal_toString(AnyPtr this__) {
    auto this_ = static_cast<AnimalValue*>(this__.toVPtr());
    return dart_str("Animal(", this_->name, ", age=", this_->age, ")");
}

std::string Dog_speak(AnyPtr this__) {
    auto this_ = static_cast<DogValue*>(this__.toVPtr());
    return dart_str(this_->name, " barks!");
}

std::string Dog_toString(AnyPtr this__) {
    auto this_ = static_cast<DogValue*>(this__.toVPtr());
    return dart_str("Dog(", this_->name, ", age=", this_->age, ", breed=", this_->breed, ")");
}

std::string Cat_speak(AnyPtr this__) {
    auto this_ = static_cast<CatValue*>(this__.toVPtr());
    return dart_str(this_->name, " meows!");
}

// === Constructor functions ===
AnimalValue* Animal_new(AnimalValue* this__, const std::string& name, int64_t age) {
    this__->name = name;
    this__->age = age;
    return this__;
}

DogValue* Dog_new(DogValue* this__, const std::string& name, int64_t age, const std::string& breed) {
    Animal_new(static_cast<AnimalValue*>(this__), name, age);
    this__->breed = breed;
    return this__;
}

CatValue* Cat_new(CatValue* this__, const std::string& name, int64_t age, bool isIndoor) {
    Animal_new(static_cast<AnimalValue*>(this__), name, age);
    this__->isIndoor = isIndoor;
    return this__;
}

int main() {
    auto dog = Dog_new(GC::allocateLocal(new DogValue()), "Rex", 5, "German Shepherd");
    auto cat = Cat_new(GC::allocateLocal(new CatValue()), "Whiskers", 3, true);

    // vptr dispatch method calls
    using SpeakFn = std::string(*)(AnyPtr);
    staticPrint(AnyPtr::fromString(
        reinterpret_cast<SpeakFn>(dog->vptr["speak"])(AnyPtr::fromVPtr(dog))));
    staticPrint(AnyPtr::fromString(
        reinterpret_cast<SpeakFn>(cat->vptr["speak"])(AnyPtr::fromVPtr(cat))));
    staticPrint(AnyPtr::fromString(
        reinterpret_cast<SpeakFn>(dog->vptr["toString"])(AnyPtr::fromVPtr(dog))));

    // Polymorphic iteration via AnyPtr
    auto animals = StaticList<AnyPtr>::of({
        AnyPtr::fromVPtr(dog),
        AnyPtr::fromVPtr(cat)
    });

    for (int i = 0; i < animals->length(); i++) {
        auto animal = (*animals)[i];
        staticPrint(AnyPtr::fromString(
            reinterpret_cast<SpeakFn>(animal.toVPtr()->vptr["speak"])(animal)));
    }

    return 0;
}

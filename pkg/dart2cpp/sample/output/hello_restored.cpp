#include "dart2cpp_lowered.h"

struct GreeterValue;
void main();

struct GreeterValue : VPtr {
    std::string name{""};

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};


GreeterValue* Greeter_new(GreeterValue* this__, std::string name) {
    auto this_ = this__;
    this_->name = name;
    Object_new(this_);
    // unsupported: EmptyStatement
    return this_;
}

std::string Greeter_greet(AnyPtr this__) {
    auto this_ = static_cast<GreeterValue*>(this__.toVPtr());
    return dart_str("Hello, ") + dart_str(this_->name) + dart_str("!");
}

void Greeter_sayHello(AnyPtr this__) {
    auto this_ = static_cast<GreeterValue*>(this__.toVPtr());
    staticPrint((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_.toVPtr()->vptr["greet"]))(this_));
}

void main() {
    GreeterValue* greeter = Greeter_new(GC::allocateLocal(new GreeterValue()), "World");
    (reinterpret_cast<AnyPtr(*)(AnyPtr)>(greeter.toVPtr()->vptr["sayHello"]))(greeter);
    StaticList<std::string>* names = _literal3("Alice", "Bob", "Charlie");
    StaticIterator<std::string>* sync_for_iterator = names->iterator;
    while ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(sync_for_iterator.toVPtr()->vptr["moveNext"]))(sync_for_iterator)) {
        std::string name = sync_for_iterator->current;
        GreeterValue* g = Greeter_new(GC::allocateLocal(new GreeterValue()), name);
        (reinterpret_cast<AnyPtr(*)(AnyPtr)>(g.toVPtr()->vptr["sayHello"]))(g);
    }
}


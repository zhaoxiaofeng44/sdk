#include "dart2cpp_lowered.h"

struct ShapeValue;
struct PairValue;
struct CircleValue;
struct RectangleValue;
struct Direction;
std::string StringExtensions_capitalize(std::string this_);
TypeFunction0<std::string>* StringExtensions_get_capitalize(std::string this_);
bool StringExtensions_get_isPalindrome(std::string this_);
StaticList<T>* ListExtensions_filterWhere(StaticList<T>* this_, TypeFunction1<bool, T>* predicate);
TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*>* ListExtensions_get_filterWhere(StaticList<T>* this_);
T identity(T value);
StaticList<T>* repeat(T item, int64_t count);
FunctionValue* makeAdder(int64_t base);
StaticList<int64_t>* mapList(StaticList<int64_t>* items, TypeFunction1<int64_t, int64_t>* transform);
Promise<std::string>* fetchData(std::string url);
Promise<StaticList<std::string>*>* fetchAll(StaticList<std::string>* urls);
std::string findFirst(StaticList<std::string>* items, TypeFunction1<bool, std::string>* predicate);
int64_t safeLength(std::string text);
void main();

struct Direction : VPtr {
    std::string _name;
    int64_t _index;

    static Direction* north;
    static Direction* south;
    static Direction* east;
    static Direction* west;
    static Direction* values;

    Direction(std::string n, int64_t i) : _name(std::move(n)), _index(i) {
        GC::allocateLocal(this);
    }

    std::string toString() override { return _name; }
};

Direction* Direction::north = new Direction("north", 0);
Direction* Direction::south = new Direction("south", 1);
Direction* Direction::east = new Direction("east", 2);
Direction* Direction::west = new Direction("west", 3);
Direction* Direction::values = new Direction("values", 4);

struct ShapeValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ShapeValue::_vptrMap;

template<typename A, typename B>
struct PairValue : VPtr {
    A first{{}};
    B second{{}};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

// 注意: 模板类 PairValue 的 _vptrMap 在每个实例化类型中独立

struct CircleValue : ShapeValue {
    double _radius{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CircleValue::_vptrMap;

struct RectangleValue : ShapeValue {
    double width{0.0};
    double height{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> RectangleValue::_vptrMap;


ShapeValue* Shape_new(ShapeValue* this__) {
    auto this_ = this__;
    if (ShapeValue::_vptrMap.empty()) {
        ShapeValue::_vptrMap["name"] = reinterpret_cast<void*>(&Shape_name);
        ShapeValue::_vptrMap["area"] = reinterpret_cast<void*>(&Shape_area);
        ShapeValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&Shape_perimeter);
        ShapeValue::_vptrMap["toString"] = reinterpret_cast<void*>(&Shape_toString);
    }
    return this_;
}

std::string Shape_name(AnyPtr this__) {
    auto this_ = static_cast<ShapeValue*>(this__.toVPtr());
    return "";
}

double Shape_area(AnyPtr this__) {
    auto this_ = static_cast<ShapeValue*>(this__.toVPtr());
    return 0.0;
}

double Shape_perimeter(AnyPtr this__) {
    auto this_ = static_cast<ShapeValue*>(this__.toVPtr());
    return 0.0;
}

std::string Shape_toString(AnyPtr this__) {
    auto this_ = static_cast<ShapeValue*>(this__.toVPtr());
    return dart_str(this_->name) + dart_str("(area=") + dart_str((reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["area"]))(this_)->getVptrMap()["toStringAsFixed"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["area"]))(this_), 2)) + dart_str(")");
}

PairValue* Pair_new(PairValue* this__, A first, B second) {
    auto this_ = this__;
    if (PairValue::_vptrMap.empty()) {
        PairValue::_vptrMap["swap"] = reinterpret_cast<void*>(&Pair_swap);
        PairValue::_vptrMap["toString"] = reinterpret_cast<void*>(&Pair_toString);
    }
    this_->first = first;
    this_->second = second;
    return this_;
}

PairValue* Pair_swap(AnyPtr this__) {
    auto this_ = static_cast<PairValue*>(this__.toVPtr());
    return Pair_new(GC::allocateLocal(new PairValue()), this_->second, this_->first);
}

std::string Pair_toString(AnyPtr this__) {
    auto this_ = static_cast<PairValue*>(this__.toVPtr());
    return dart_str("(") + dart_str(this_->first) + dart_str(", ") + dart_str(this_->second) + dart_str(")");
}

CircleValue* Circle_new(CircleValue* this__, double _radius) {
    auto this_ = this__;
    if (CircleValue::_vptrMap.empty()) {
        CircleValue::_vptrMap["name"] = reinterpret_cast<void*>(&Circle_name);
        CircleValue::_vptrMap["area"] = reinterpret_cast<void*>(&Circle_area);
        CircleValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&Circle_perimeter);
        CircleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&Circle_toString);
        CircleValue::_vptrMap["radius"] = reinterpret_cast<void*>(&Circle_radius);
        CircleValue::_vptrMap["radius"] = reinterpret_cast<void*>(&Circle_radius);
    }
    this_->_radius = _radius;
    Shape_new(this_);
    return this_;
}

CircleValue* Circle_new_unit(CircleValue* this__) {
    auto this_ = this__;
    this_->_radius = 1.0;
    Shape_new(this_);
    return this_;
}

double Circle_radius(AnyPtr this__) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
    return this_->_radius;
}

void Circle_radius(AnyPtr this__, double value) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
    if ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(value->getVptrMap()["_"]))(value, 0)) {
        throw DartException(ArgumentError_new(GC::allocateLocal(new ArgumentErrorValue()), "Radius must be non-negative").toStringValue());
    }
    (this_->_radius = value);
}

std::string Circle_name(AnyPtr this__) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
    return "Circle";
}

double Circle_area(AnyPtr this__) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
    return (reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(3.14159265->getVptrMap()["_"]))(3.14159265, this_->_radius)->getVptrMap()["_"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(3.14159265->getVptrMap()["_"]))(3.14159265, this_->_radius), this_->_radius);
}

double Circle_perimeter(AnyPtr this__) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
    return (reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(2->getVptrMap()["_"]))(2, 3.14159265)->getVptrMap()["_"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(2->getVptrMap()["_"]))(2, 3.14159265), this_->_radius);
}

RectangleValue* Rectangle_new(RectangleValue* this__, double width, double height) {
    auto this_ = this__;
    if (RectangleValue::_vptrMap.empty()) {
        RectangleValue::_vptrMap["name"] = reinterpret_cast<void*>(&Rectangle_name);
        RectangleValue::_vptrMap["area"] = reinterpret_cast<void*>(&Rectangle_area);
        RectangleValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&Rectangle_perimeter);
        RectangleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&Rectangle_toString);
    }
    this_->width = width;
    this_->height = height;
    Shape_new(this_);
    return this_;
}

std::string Rectangle_name(AnyPtr this__) {
    auto this_ = static_cast<RectangleValue*>(this__.toVPtr());
    return "Rectangle";
}

double Rectangle_area(AnyPtr this__) {
    auto this_ = static_cast<RectangleValue*>(this__.toVPtr());
    return (reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->width->getVptrMap()["_"]))(this_->width, this_->height);
}

double Rectangle_perimeter(AnyPtr this__) {
    auto this_ = static_cast<RectangleValue*>(this__.toVPtr());
    return (reinterpret_cast<AnyPtr(*)(AnyPtr)>(2->getVptrMap()["_"]))(2, (reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->width->getVptrMap()["_"]))(this_->width, this_->height));
}

std::string StringExtensions_capitalize(std::string this_) {
    if (this_->isEmpty) {
        return this_;
    }
    return dart_str((reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["__"]))(this_, 0)->getVptrMap()["toUpperCase"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["__"]))(this_, 0))) + dart_str((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["substring"]))(this_, 1));
}

TypeFunction0<std::string>* StringExtensions_get_capitalize(std::string this_) {
    return /* closure */ nullptr;
}

bool StringExtensions_get_isPalindrome(std::string this_) {
    std::string reversed = (reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["split"]))(this_, "")->reversed->getVptrMap()["join"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["split"]))(this_, "")->reversed);
    return (this_ == reversed);
}

StaticList<T>* ListExtensions_filterWhere(StaticList<T>* this_, TypeFunction1<bool, T>* predicate) {
    return (reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["where"]))(this_, predicate)->getVptrMap()["toList"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(this_->getVptrMap()["where"]))(this_, predicate));
}

TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*>* ListExtensions_get_filterWhere(StaticList<T>* this_) {
    return /* closure */ nullptr;
}

T identity(T value) {
    return value;
}

StaticList<T>* repeat(T item, int64_t count) {
    return generate(count, /* closure */ nullptr);
}

FunctionValue* makeAdder(int64_t base) {
    return /* closure */ nullptr;
}

StaticList<int64_t>* mapList(StaticList<int64_t>* items, TypeFunction1<int64_t, int64_t>* transform) {
    return (reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(items->getVptrMap()["map"]))(items, transform)->getVptrMap()["toList"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(items->getVptrMap()["map"]))(items, transform));
}

Promise<std::string>* fetchData(std::string url) {
    smAwait<AnyPtr>(delayed(Duration_new(GC::allocateLocal(new DurationValue()))));
    return dart_str("data from ") + dart_str(url);
}

Promise<StaticList<std::string>*>* fetchAll(StaticList<std::string>* urls) {
    StaticList<std::string>* results = _unnamed(0);
    StaticIterator<std::string>* sync_for_iterator = urls->iterator;
    while ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(sync_for_iterator->getVptrMap()["moveNext"]))(sync_for_iterator)) {
        std::string url = sync_for_iterator->current;
        std::string data = smAwait<AnyPtr>(fetchData(url));
        (reinterpret_cast<AnyPtr(*)(AnyPtr)>(results->getVptrMap()["add"]))(results, data);
    }
    return results;
}

std::string findFirst(StaticList<std::string>* items, TypeFunction1<bool, std::string>* predicate) {
    StaticIterator<std::string>* sync_for_iterator = items->iterator;
    while ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(sync_for_iterator->getVptrMap()["moveNext"]))(sync_for_iterator)) {
        std::string item = sync_for_iterator->current;
        if (predicate->call(item)) {
            return item;
        }
    }
    return AnyPtr::null();
}

int64_t safeLength(std::string text) {
    return ([&]() { int64_t _let0 = ([&]() { std::string _let1 = text; return (_let1.isNull() ? AnyPtr::null() : _let1->length); })(); return (_let0.isNull() ? 0 : _let0); })();
}

void main() {
    staticPrint("=== 复杂语法节点还原测试 ===\n");
    staticPrint("--- 1. 泛型类 Pair ---");
    PairValue* pair = Pair_new(GC::allocateLocal(new PairValue()), "hello", 42);
    PairValue* swapped = (reinterpret_cast<AnyPtr(*)(AnyPtr)>(pair->getVptrMap()["swap"]))(pair);
    staticPrint(dart_str("pair: ") + dart_str(pair));
    staticPrint(dart_str("swapped: ") + dart_str(swapped));
    assert((pair->first == "hello"));
    assert((swapped->first == 42));
    staticPrint("\n--- 2. 继承 + 多态 ---");
    StaticList<ShapeValue*>* shapes = _literal3(Circle_new(GC::allocateLocal(new CircleValue()), 5.0), Rectangle_new(GC::allocateLocal(new RectangleValue()), 3.0, 4.0), Circle_new_unit(GC::allocateLocal(new CircleValue())));
    StaticIterator<ShapeValue*>* sync_for_iterator = shapes->iterator;
    while ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(sync_for_iterator->getVptrMap()["moveNext"]))(sync_for_iterator)) {
        ShapeValue* shape = sync_for_iterator->current;
        staticPrint(dart_str("  ") + dart_str(shape) + dart_str(", perimeter=") + dart_str((reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(shape->getVptrMap()["perimeter"]))(shape)->getVptrMap()["toStringAsFixed"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(shape->getVptrMap()["perimeter"]))(shape), 2)));
    }
    staticPrint("\n--- 3. getter/setter + 异常 ---");
    CircleValue* circle = Circle_new(GC::allocateLocal(new CircleValue()), 3.0);
    (circle->radius = 5.0);
    staticPrint(dart_str("radius after set: ") + dart_str(circle->radius));
    try {
        (circle->radius = (reinterpret_cast<AnyPtr(*)(AnyPtr)>(1.0->getVptrMap()["unary_"]))(1.0));
        staticPrint("ERROR: should have thrown");
    } catch (const std::exception& e) {
        staticPrint(dart_str("Caught expected error: ") + dart_str(e));
    }
    staticPrint("\n--- 4. 枚举 + switch ---");
    StaticList<DirectionValue*>* directions = _literal3(/* TODO: ConstantExpression */, /* TODO: ConstantExpression */, /* TODO: ConstantExpression */);
    StaticIterator<DirectionValue*>* sync_for_iterator = directions->iterator;
    while ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(sync_for_iterator->getVptrMap()["moveNext"]))(sync_for_iterator)) {
        DirectionValue* dir = sync_for_iterator->current;
        std::string label = /* TODO: BlockExpression */;
        staticPrint(dart_str("  ") + dart_str(dir) + dart_str(" -> ") + dart_str(label));
    }
    staticPrint("\n--- 5. 扩展方法 ---");
    std::string word = "hello";
    staticPrint(dart_str("capitalize: ") + dart_str(StringExtensions_capitalize(word)));
    staticPrint(dart_str("isPalindrome(\"racecar\"): ") + dart_str(StringExtensions_get_isPalindrome("racecar")));
    staticPrint(dart_str("isPalindrome(\"hello\"): ") + dart_str(StringExtensions_get_isPalindrome("hello")));
    StaticList<int64_t>* numbers = _literal6(1, 2, 3, 4, 5, 6);
    StaticList<int64_t>* evens = ListExtensions_filterWhere(numbers, /* closure */ nullptr);
    staticPrint(dart_str("evens: ") + dart_str(evens));
    staticPrint("\n--- 6. 泛型函数 ---");
    staticPrint(dart_str("identity<int>(99): ") + dart_str(identity(99)));
    staticPrint(dart_str("repeat(\"x\", 3): ") + dart_str(repeat("x", 3)));
    staticPrint("\n--- 7. 高阶函数 + 闭包 ---");
    FunctionValue* add10 = makeAdder(10);
    staticPrint(dart_str("add10(5): ") + dart_str(add10->call(5)));
    StaticList<int64_t>* doubled = mapList(_literal4(1, 2, 3, 4), /* closure */ nullptr);
    staticPrint(dart_str("doubled: ") + dart_str(doubled));
    int64_t counter = 0;
    TypeFunction0<int64_t>* increment = /* closure */ nullptr;
    staticPrint(dart_str("counter: ") + dart_str(increment->call()) + dart_str(", ") + dart_str(increment->call()) + dart_str(", ") + dart_str(increment->call()));
    staticPrint("\n--- 8. 可空类型 ---");
    StaticList<std::string>* items = _literal3("apple", "banana", "cherry");
    std::string found = findFirst(items, /* closure */ nullptr);
    staticPrint(dart_str("found: ") + dart_str(found));
    std::string notFound = findFirst(items, /* closure */ nullptr);
    staticPrint(dart_str("notFound: ") + dart_str(notFound));
    staticPrint(dart_str("safeLength(null): ") + dart_str(safeLength(AnyPtr::null())));
    staticPrint(dart_str("safeLength(\"dart\"): ") + dart_str(safeLength("dart")));
    staticPrint("\n--- 9. 集合操作 ---");
    StaticMap<std::string, int64_t>* map = StaticMap<AnyPtr, AnyPtr>::empty();
    StaticMap<std::string, int64_t>* filtered = fromEntries((reinterpret_cast<AnyPtr(*)(AnyPtr)>(map->entries->getVptrMap()["where"]))(map->entries, /* closure */ nullptr));
    staticPrint(dart_str("filtered map: ") + dart_str(filtered));
    StaticSet<int64_t>* set1 = /* TODO: BlockExpression */;
    StaticSet<int64_t>* set2 = /* TODO: BlockExpression */;
    StaticSet<int64_t>* intersection = (reinterpret_cast<AnyPtr(*)(AnyPtr)>(set1->getVptrMap()["intersection"]))(set1, set2);
    staticPrint(dart_str("intersection: ") + dart_str(intersection));
    staticPrint("\n--- 10. 字符串插值 ---");
    std::string name = "Dart";
    int64_t version = 3;
    std::string greeting = dart_str("Hello, ") + dart_str(name) + dart_str(" ") + dart_str(version) + dart_str("!");
    std::string multiExpr = dart_str("Sum: ") + dart_str((reinterpret_cast<AnyPtr(*)(AnyPtr)>((reinterpret_cast<AnyPtr(*)(AnyPtr)>(1->getVptrMap()["_"]))(1, 2)->getVptrMap()["_"]))((reinterpret_cast<AnyPtr(*)(AnyPtr)>(1->getVptrMap()["_"]))(1, 2), 3)) + dart_str(", Upper: ") + dart_str((reinterpret_cast<AnyPtr(*)(AnyPtr)>(name->getVptrMap()["toUpperCase"]))(name));
    staticPrint(greeting);
    staticPrint(multiExpr);
    staticPrint("\n--- 11. 条件表达式 + 类型检查 ---");
    AnyPtr value = 42;
    std::string typeLabel = (false /* is InterfaceType(int) */ ? "integer" : (false /* is InterfaceType(String) */ ? "string" : "other"));
    staticPrint(dart_str("typeLabel: ") + dart_str(typeLabel));
    staticPrint("\n--- 12. 循环语句 ---");
    int64_t sum = 0;
    int64_t i = 1;
    while ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(i->getVptrMap()["__"]))(i, 5)) {
        (sum = (reinterpret_cast<AnyPtr(*)(AnyPtr)>(sum->getVptrMap()["_"]))(sum, i));
        (i = (reinterpret_cast<AnyPtr(*)(AnyPtr)>(i->getVptrMap()["_"]))(i, 1));
    }
    staticPrint(dart_str("sum 1..5: ") + dart_str(sum));
    int64_t product = 1;
    int64_t n = 5;
    while ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(n->getVptrMap()["_"]))(n, 0)) {
        (product = (reinterpret_cast<AnyPtr(*)(AnyPtr)>(product->getVptrMap()["_"]))(product, n));
        (n = (reinterpret_cast<AnyPtr(*)(AnyPtr)>(n->getVptrMap()["_"]))(n, 1));
    }
    staticPrint(dart_str("5! = ") + dart_str(product));
    int64_t doCount = 0;
    do {
        (doCount = (reinterpret_cast<AnyPtr(*)(AnyPtr)>(doCount->getVptrMap()["_"]))(doCount, 1));
    } while ((reinterpret_cast<AnyPtr(*)(AnyPtr)>(doCount->getVptrMap()["_"]))(doCount, 3));
    staticPrint(dart_str("doCount: ") + dart_str(doCount));
    staticPrint("\n--- 13. try/catch/finally ---");
    std::string result = "";
    // unsupported: TryFinally
    staticPrint(dart_str("result: ") + dart_str(result));
    staticPrint("\n--- 14. 集合字面量 ---");
    StaticList<int64_t>* constList = /* TODO: ConstantExpression */;
    StaticMap<std::string, std::string>* constMap = /* TODO: ConstantExpression */;
    StaticSet<int64_t>* constSet = /* TODO: ConstantExpression */;
    staticPrint(dart_str("constList: ") + dart_str(/* TODO: ConstantExpression */));
    staticPrint(dart_str("constMap: ") + dart_str(/* TODO: ConstantExpression */));
    staticPrint(dart_str("constSet: ") + dart_str(/* TODO: ConstantExpression */));
    staticPrint("\n=== 所有测试通过 ✅ ===");
}


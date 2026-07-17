#include "dart2cpp_lowered.h"

struct PersonValue;
struct LateTestValue;
struct ShapeValue;
struct CircleValue;
struct SquareValue;
struct VectorValue;
struct CounterValue;
struct AnimalValue;
struct DogValue;
struct FlyableMixin;
struct SwimmableMixin;
struct DuckValue;
struct Color;
int64_t Color_get_value(Color* this__);
void Flyable_fly(FlyableMixin* this__);
void Swimmable_swim(SwimmableMixin* this__);
PersonValue* Person_new(PersonValue* this__);
void Person_greet(PersonValue* this__);
LateTestValue* LateTest_new(LateTestValue* this__);
void LateTest_init(LateTestValue* this__);
std::string LateTest_get(LateTestValue* this__);
ShapeValue* Shape_new(ShapeValue* this__);
double Shape_area(ShapeValue* this__);
CircleValue* Circle_new(CircleValue* this__, double radius);
double Circle_area(CircleValue* this__);
SquareValue* Square_new(SquareValue* this__, double side);
double Square_area(SquareValue* this__);
VectorValue* Vector_new(VectorValue* this__, double x, double y);
VectorValue* Vector_add(VectorValue* this__, VectorValue* other);
VectorValue* Vector_mul(VectorValue* this__, double scalar);
std::string Vector_toString(VectorValue* this__);
CounterValue* Counter_new(CounterValue* this__);
void Counter_increment();
int64_t Counter_get_value();
AnimalValue* Animal_new(AnimalValue* this__);
void Animal_speak(AnimalValue* this__);
DogValue* Dog_new(DogValue* this__);
void Dog_speak(DogValue* this__);
DuckValue* Duck_new(DuckValue* this__);
void Duck_quack(DuckValue* this__);
void testSpread();
void testCollectionIfFor();
void testCascade();
void testNullAware();
void testLate();
Promise<int64_t>* asyncInt();
Promise<std::string>* asyncString();
Promise<void>* asyncVoid();
void testAsync();
StaticList<int64_t>* syncGen();
StaticList<AnyGC*>* asyncGen();
void testGenerators();
void testEnum();
std::string StringExtension_capitalize(std::string this_);
TypeFunction0<std::string>* StringExtension_get_capitalize(std::string this_);
void testExtension();
AnyGC* getRecord();
AnyGC* getNamedRecord();
void testRecords();
void testPatternMatching();
void testSealed();
void testOperators();
void testStatic();
void testAbstract();
void testMixin();
template<typename T> T max(T a, T b);
void testGenericBounds();
bool isEven(int64_t n);
void testTypedef();
void testAssert();
void testLabels();
int main();
void Duck_Object_Flyable_fly(DuckValue* this__);
void Duck_Object_Flyable_Swimmable_swim(DuckValue* this__);
void Duck_fly(DuckValue* this__);
void Duck_swim(DuckValue* this__);

struct Color : VPtr {
    std::string _name;
    int64_t _index;

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    static Color* red;
    static Color* green;
    static Color* blue;
    static Color* values;

    Color(std::string n, int64_t i) : _name(std::move(n)), _index(i) {}

    std::string toString() const override {
        auto& _vm = const_cast<Color*>(this)->getVptrMap();
        auto _it = _vm.find("toString");
        if (_it != _vm.end()) {
            return dynAs<std::string>(reinterpret_cast<AnyGC*(*)(AnyGC*)>(_it->second)(const_cast<Color*>(this)));
        }
        return "Color." + _name;
    }
};

std::unordered_map<std::string, void*> Color::_vptrMap;

Color* Color::red = new Color("red", 0);
Color* Color::green = new Color("green", 1);
Color* Color::blue = new Color("blue", 2);
Color* Color::values = new Color("values", 3);

struct FlyableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> FlyableMixin::_vptrMap;


struct SwimmableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> SwimmableMixin::_vptrMap;


struct PersonValue : VPtr {
    std::string name{""};
    int64_t age{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> PersonValue::_vptrMap;

struct LateTestValue : VPtr {
    std::string value{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> LateTestValue::_vptrMap;

struct ShapeValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ShapeValue::_vptrMap;

struct CircleValue : ShapeValue {
    double radius{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CircleValue::_vptrMap;

struct SquareValue : ShapeValue {
    double side{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> SquareValue::_vptrMap;

struct VectorValue : VPtr {
    double x{0.0};
    double y{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> VectorValue::_vptrMap;

struct CounterValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CounterValue::_vptrMap;

struct AnimalValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> AnimalValue::_vptrMap;

struct DogValue : AnimalValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AnimalValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DogValue::_vptrMap;

struct DuckValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DuckValue::_vptrMap;

struct TearOff_0 : TypeFunction1<void, AnyGC*> {
    TearOff_0() {}
    void call(AnyGC* object) {
        staticPrint(object);
    }
};

struct TearOff_1 : TypeFunction1<void, AnyGC*> {
    TearOff_1() {}
    void call(AnyGC* object) {
        staticPrint(object);
    }
};

struct TearOff_2 : TypeFunction1<void, AnyGC*> {
    TearOff_2() {}
    void call(AnyGC* object) {
        staticPrint(object);
    }
};

struct ClosureEnv_3 : TypeFunction0<std::string> {
    std::string this_;
    ClosureEnv_3(std::string this_) : this_(std::move(this_)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_3*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
    return StringExtension_capitalize(this_);
    }
};

struct TearOff_4 : TypeFunction1<bool, int64_t> {
    TearOff_4() {}
    bool call(int64_t n) {
        return isEven(n);
    }
};


int64_t Color_get_value(Color* this__) {
    auto this_ = this__;
    return this_->_index;
}

AnyGC* _vptr_wrap_Color_get_value(AnyGC* obj__) {
    return _box(Color_get_value(static_cast<Color*>(obj__)));
}

static bool _Color_value_registered = []{ Color::_vptrMap["get_value"] = reinterpret_cast<void*>(&_vptr_wrap_Color_get_value); return true; }();
void Flyable_fly(FlyableMixin* this__) {
    auto this_ = this__;
    staticPrint(std::string("Flying!"));
    return;
}

void Swimmable_swim(SwimmableMixin* this__) {
    auto this_ = this__;
    staticPrint(std::string("Swimming!"));
    return;
}

AnyGC* _vptr_wrap_Person_greet(AnyGC* obj__) {
    Person_greet(static_cast<PersonValue*>(obj__));
    return nullptr;
}

static bool _Person_vptr_registered = []{ PersonValue::_vptrMap["greet"] = reinterpret_cast<void*>(&_vptr_wrap_Person_greet); return true; }();
PersonValue* Person_new(PersonValue* this__) {
    auto this_ = this__;
    if (PersonValue::_vptrMap.empty()) {
        PersonValue::_vptrMap["greet"] = reinterpret_cast<void*>(&_vptr_wrap_Person_greet);
    }
    this_->name = std::string("");
    this_->age = 0LL;
    return this_;
}

void Person_greet(PersonValue* this__) {
    auto this_ = this__;
    staticPrint(dart_str(std::string("Hello, ")) + dart_str(this_->name));
    return;
}

AnyGC* _vptr_wrap_LateTest_init(AnyGC* obj__) {
    LateTest_init(static_cast<LateTestValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_LateTest_get(AnyGC* obj__) {
    return _box(LateTest_get(static_cast<LateTestValue*>(obj__)));
}

static bool _LateTest_vptr_registered = []{ LateTestValue::_vptrMap["init"] = reinterpret_cast<void*>(&_vptr_wrap_LateTest_init); LateTestValue::_vptrMap["get"] = reinterpret_cast<void*>(&_vptr_wrap_LateTest_get); return true; }();
LateTestValue* LateTest_new(LateTestValue* this__) {
    auto this_ = this__;
    if (LateTestValue::_vptrMap.empty()) {
        LateTestValue::_vptrMap["init"] = reinterpret_cast<void*>(&_vptr_wrap_LateTest_init);
        LateTestValue::_vptrMap["get"] = reinterpret_cast<void*>(&_vptr_wrap_LateTest_get);
    }
    return this_;
}

void LateTest_init(LateTestValue* this__) {
    auto this_ = this__;
    (this_->value = std::string("initialized"));
}

std::string LateTest_get(LateTestValue* this__) {
    auto this_ = this__;
    return this_->value;
}

AnyGC* _vptr_wrap_Shape_area(AnyGC* obj__) {
    return _box(Shape_area(static_cast<ShapeValue*>(obj__)));
}

static bool _Shape_vptr_registered = []{ ShapeValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_area); return true; }();
ShapeValue* Shape_new(ShapeValue* this__) {
    auto this_ = this__;
    if (ShapeValue::_vptrMap.empty()) {
        ShapeValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_area);
    }
    return this_;
}

double Shape_area(ShapeValue* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Shape.area")));
}

AnyGC* _vptr_wrap_Circle_area(AnyGC* obj__) {
    return _box(Circle_area(static_cast<CircleValue*>(obj__)));
}

static bool _Circle_vptr_registered = []{ CircleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_area); return true; }();
CircleValue* Circle_new(CircleValue* this__, double radius) {
    auto this_ = this__;
    if (CircleValue::_vptrMap.empty()) {
        CircleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_area);
    }
    this_->radius = radius;
    Shape_new(this_);
    return this_;
}

double Circle_area(CircleValue* this__) {
    auto this_ = this__;
    return ((3.14 * this_->radius) * this_->radius);
}

AnyGC* _vptr_wrap_Square_area(AnyGC* obj__) {
    return _box(Square_area(static_cast<SquareValue*>(obj__)));
}

static bool _Square_vptr_registered = []{ SquareValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Square_area); return true; }();
SquareValue* Square_new(SquareValue* this__, double side) {
    auto this_ = this__;
    if (SquareValue::_vptrMap.empty()) {
        SquareValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Square_area);
    }
    this_->side = side;
    Shape_new(this_);
    return this_;
}

double Square_area(SquareValue* this__) {
    auto this_ = this__;
    return (this_->side * this_->side);
}

AnyGC* _vptr_wrap_Vector_add(AnyGC* obj__, AnyGC* arg0) {
    return _box(Vector_add(static_cast<VectorValue*>(obj__), static_cast<VectorValue*>(arg0)));
}

AnyGC* _vptr_wrap_Vector_mul(AnyGC* obj__, AnyGC* arg0) {
    return _box(Vector_mul(static_cast<VectorValue*>(obj__), dynAs<double>(arg0)));
}

AnyGC* _vptr_wrap_Vector_toString(AnyGC* obj__) {
    return _box(Vector_toString(static_cast<VectorValue*>(obj__)));
}

static bool _Vector_vptr_registered = []{ VectorValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Vector_add); VectorValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Vector_mul); VectorValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Vector_toString); return true; }();
VectorValue* Vector_new(VectorValue* this__, double x, double y) {
    auto this_ = this__;
    if (VectorValue::_vptrMap.empty()) {
        VectorValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Vector_add);
        VectorValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Vector_mul);
        VectorValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Vector_toString);
    }
    this_->x = x;
    this_->y = y;
    return this_;
}

VectorValue* Vector_add(VectorValue* this__, VectorValue* other) {
    auto this_ = this__;
    return Vector_new(GC::allocateLocal(new VectorValue()), (this_->x + other->x), (this_->y + other->y));
}

VectorValue* Vector_mul(VectorValue* this__, double scalar) {
    auto this_ = this__;
    return Vector_new(GC::allocateLocal(new VectorValue()), (this_->x * scalar), (this_->y * scalar));
}

std::string Vector_toString(VectorValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("(")) + dart_str(this_->x) + dart_str(std::string(", ")) + dart_str(this_->y) + dart_str(std::string(")"));
}

int64_t count = 0LL;
CounterValue* Counter_new(CounterValue* this__) {
    auto this_ = this__;
    return this_;
}

void Counter_increment() {
    count = (count + 1LL);
}

int64_t Counter_get_value() {
    return count;
}

AnyGC* _vptr_wrap_Animal_speak(AnyGC* obj__) {
    Animal_speak(static_cast<AnimalValue*>(obj__));
    return nullptr;
}

static bool _Animal_vptr_registered = []{ AnimalValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Animal_speak); return true; }();
AnimalValue* Animal_new(AnimalValue* this__) {
    auto this_ = this__;
    if (AnimalValue::_vptrMap.empty()) {
        AnimalValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Animal_speak);
    }
    return this_;
}

void Animal_speak(AnimalValue* this__) {
    auto this_ = this__;
}

AnyGC* _vptr_wrap_Dog_speak(AnyGC* obj__) {
    Dog_speak(static_cast<DogValue*>(obj__));
    return nullptr;
}

static bool _Dog_vptr_registered = []{ DogValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_speak); return true; }();
DogValue* Dog_new(DogValue* this__) {
    auto this_ = this__;
    if (DogValue::_vptrMap.empty()) {
        DogValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_speak);
    }
    return this_;
}

void Dog_speak(DogValue* this__) {
    auto this_ = this__;
    staticPrint(std::string("Woof!"));
    return;
}

AnyGC* _vptr_wrap_Duck_fly(AnyGC* obj__) {
    Duck_fly(static_cast<DuckValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Duck_swim(AnyGC* obj__) {
    Duck_swim(static_cast<DuckValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Duck_quack(AnyGC* obj__) {
    Duck_quack(static_cast<DuckValue*>(obj__));
    return nullptr;
}

static bool _Duck_vptr_registered = []{ DuckValue::_vptrMap["fly"] = reinterpret_cast<void*>(&_vptr_wrap_Duck_fly); DuckValue::_vptrMap["swim"] = reinterpret_cast<void*>(&_vptr_wrap_Duck_swim); DuckValue::_vptrMap["quack"] = reinterpret_cast<void*>(&_vptr_wrap_Duck_quack); return true; }();
DuckValue* Duck_new(DuckValue* this__) {
    auto this_ = this__;
    if (DuckValue::_vptrMap.empty()) {
        DuckValue::_vptrMap["fly"] = reinterpret_cast<void*>(&_vptr_wrap_Duck_fly);
        DuckValue::_vptrMap["swim"] = reinterpret_cast<void*>(&_vptr_wrap_Duck_swim);
        DuckValue::_vptrMap["quack"] = reinterpret_cast<void*>(&_vptr_wrap_Duck_quack);
    }
    return this_;
}

void Duck_quack(DuckValue* this__) {
    auto this_ = this__;
    staticPrint(std::string("Quack!"));
    return;
}

void testSpread() {
    StaticList<int64_t>* list1 = GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL}));
    StaticList<int64_t>* list2 = GC::allocateLocal(new StaticList<int64_t>({4LL, 5LL, 6LL}));
    StaticList<int64_t>* combined = ([&]() {     StaticList<int64_t>* _v0 = ([&]() { auto* _src = list1; auto* _dst = GC::allocateLocal(new StaticList<int64_t>()); for (int _i = 0; _i < _src->length(); _i++) _dst->add((*_src)[_i]); return _dst; })();
    _v0->addAll(list2);
 return _v0; })();
    staticPrint(combined);
    StaticMap<std::string, int64_t>* map1 = ([&]() { auto* _m = StaticMap<std::string, int64_t>::empty(); _m->set(std::string("a"), 1LL); return _m; })();
    StaticMap<std::string, int64_t>* map2 = ([&]() { auto* _m = StaticMap<std::string, int64_t>::empty(); _m->set(std::string("b"), 2LL); return _m; })();
    StaticMap<std::string, int64_t>* combinedMap = ([&]() {     StaticMap<std::string, int64_t>* _v1 = of<std::string, int64_t>(map1);
    /* unsupported collection method: addAll on Map */ _v1->addAll(map2);
 return _v1; })();
    staticPrint(combinedMap);
}

void testCollectionIfFor() {
    bool includeExtra = true;
    StaticList<int64_t>* list = ([&]() {     StaticList<int64_t>* _v2 = GC::allocateLocal(new StaticList<int64_t>({1LL}));
    if (includeExtra) {
        _v2->add(2LL);
    }
    int64_t i = 3LL;
    while ((i <= 5LL)) {
        _v2->add(i);
        (i = (i + 1LL));
    }
 return _v2; })();
    staticPrint(list);
}

void testCascade() {
    PersonValue* p = ([&]() { PersonValue* _let3 = Person_new(GC::allocateLocal(new PersonValue())); return ([&]() {     (_let3->name = std::string("Alice"));
    (_let3->age = 30LL);
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(_let3->getVptrMap()["greet"]))(_let3);
 return _let3; })(); })();
    staticPrint(p->name);
}

void testNullAware() {
    std::string nullable{""};
    std::string result = (nullable.empty() ? std::string("default") : nullable);
    staticPrint(result);
    int64_t length = ([&]() { std::string _let6 = nullable; int64_t _let5 = ([&]() { std::string _let6 = nullable; return (_let6.empty() ? 0 : static_cast<int64_t>(_let6.length())); })();  return (false ? 0LL : _let5); })();
    staticPrint(length);
    ((nullable.empty()) ? (nullable = std::string("assigned")) : "");
    staticPrint(nullable);
}

void testLate() {
    LateTestValue* t = LateTest_new(GC::allocateLocal(new LateTestValue()));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(t->getVptrMap()["init"]))(t);
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(t->getVptrMap()["get"]))(t)));
}

Promise<int64_t>* asyncInt() {
    auto _promise = GC::allocateLocal(new Promise<int64_t>());
    smAwait<AnyGC*>(_box(promiseDelayed(1, []() -> AnyGC* { return nullptr; })));
    _promise->complete(_box(42LL));
    return _promise;
}

Promise<std::string>* asyncString() {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    smAwait<AnyGC*>(_box(promiseDelayed(1, []() -> AnyGC* { return nullptr; })));
    _promise->complete(_box(std::string("hello")));
    return _promise;
}

Promise<void>* asyncVoid() {
    auto _promise = GC::allocateLocal(new Promise<void>());
    smAwait<AnyGC*>(_box(promiseDelayed(1, []() -> AnyGC* { return nullptr; })));
    staticPrint(std::string("done"));
    _promise->complete(nullptr);
    return _promise;
}

void testAsync() {
    Promise_then(asyncInt(), GC::allocateLocal(static_cast<TypeFunction1<void, AnyGC*>*>(new TearOff_0())));
    Promise_then(asyncString(), GC::allocateLocal(static_cast<TypeFunction1<void, AnyGC*>*>(new TearOff_1())));
    asyncVoid();
}

StaticList<int64_t>* syncGen() {
    auto _result = GC::allocateLocal(new StaticList<int64_t>());
    _result->add(1LL);
    _result->add(2LL);
    _result->add(3LL);
    return _result;
}

StaticList<AnyGC*>* asyncGen() {
    auto _result = GC::allocateLocal(new StaticList<AnyGC*>());
    _result->add(_box(1LL));
    _result->add(_box(2LL));
    _result->add(_box(3LL));
    return _result;
}

void testGenerators() {
    staticPrint(syncGen());
    Promise_then(([&]() { auto* _stream = asyncGen(); auto* _promise = GC::allocateLocal(new Promise<StaticList<int64_t>*>()); _promise->complete(_box(_stream->toList())); return _promise; })(), GC::allocateLocal(static_cast<TypeFunction1<void, AnyGC*>*>(new TearOff_2())));
}

void testEnum() {
    staticPrint(Color::red->_name);
    staticPrint(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(Color::green->getVptrMap()["get_value"]))(Color::green)));
}

std::string StringExtension_capitalize(std::string this_) {
    if (this_.empty()) {
        return this_;
    }
    return (dart_str_toUpper(std::string(1, this_[0LL])) + this_.substr(1LL));
}

TypeFunction0<std::string>* StringExtension_get_capitalize(std::string this_) {
    return GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_3(this_)));
}

void testExtension() {
    staticPrint(StringExtension_capitalize(std::string("hello")));
}

AnyGC* getRecord() {
    return _box([&]() -> AnyGC* { auto _r0 = std::string("hello"); auto _r1 = 42LL; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }());
}

AnyGC* getNamedRecord() {
    return _box(([&]() { std::string _let7 = std::string("Alice"); return [&]() -> AnyGC* { auto _r0 = 30LL; auto _r1 = _let7; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }(); })());
}

void testRecords() {
    AnyGC* r1 = getRecord();
    staticPrint(dart_str(std::get<0>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(r1)->data))) + dart_str(std::string(", ")) + dart_str(std::get<1>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(r1)->data))));
    AnyGC* r2 = getNamedRecord();
    staticPrint(dart_str(std::get<1>(*reinterpret_cast<std::tuple<int64_t, std::string>*>(static_cast<TupleBox*>(r2)->data))) + dart_str(std::string(", ")) + dart_str(std::get<0>(*reinterpret_cast<std::tuple<int64_t, std::string>*>(static_cast<TupleBox*>(r2)->data))));
}

void testPatternMatching() {
    StaticList<int64_t>* obj = GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL}));
    _L0:
    do {
        StaticList<int64_t>* _v9 = obj;
        int64_t _v10 = 3;
        int64_t _v11 = 1;
        int64_t _v12 = 2;
        if (((((_v9->length() == 3) && (1 == (*_v9)[0LL])) && (2 == (*_v9)[1LL])) && (3 == (*_v9)[2LL]))) {
            staticPrint(std::string("matched"));
            break;
        }
        staticPrint(std::string("not matched"));
    } while (false);
    int64_t a{0};
    int64_t b{0};
    AnyGC* _v13 = [&]() -> AnyGC* { auto _r0 = 1LL; auto _r1 = 2LL; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }();
    (a = std::get<0>(*reinterpret_cast<std::tuple<int64_t, int64_t>*>(static_cast<TupleBox*>(_v13)->data)));
    (b = std::get<1>(*reinterpret_cast<std::tuple<int64_t, int64_t>*>(static_cast<TupleBox*>(_v13)->data)));
    staticPrint(dart_str(a) + dart_str(std::string(", ")) + dart_str(b));
}

void testSealed() {
    StaticList<ShapeValue*>* shapes = GC::allocateLocal(new StaticList<ShapeValue*>({Circle_new(GC::allocateLocal(new CircleValue()), 5.0), Square_new(GC::allocateLocal(new SquareValue()), 4.0)}));
    StaticIterator<ShapeValue*>* sync_for_iterator = shapes->iterator();
    while (sync_for_iterator->moveNext()) {
        ShapeValue* shape = sync_for_iterator->current();
        staticPrint(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(shape->getVptrMap()["area"]))(shape)));
    }
}

void testOperators() {
    VectorValue* v1 = Vector_new(GC::allocateLocal(new VectorValue()), 1.0, 2.0);
    VectorValue* v2 = Vector_new(GC::allocateLocal(new VectorValue()), 3.0, 4.0);
    staticPrint(reinterpret_cast<VectorValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(v1->getVptrMap()["+"]))(v1, _box(v2))));
    staticPrint(reinterpret_cast<VectorValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(v1->getVptrMap()["*"]))(v1, _box(2.0))));
}

void testStatic() {
    Counter_increment();
    Counter_increment();
    staticPrint(Counter_get_value());
}

void testAbstract() {
    AnimalValue* a = Dog_new(GC::allocateLocal(new DogValue()));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(a->getVptrMap()["speak"]))(a);
}

void testMixin() {
    DuckValue* d = Duck_new(GC::allocateLocal(new DuckValue()));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(d->getVptrMap()["fly"]))(d);
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(d->getVptrMap()["swim"]))(d);
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(d->getVptrMap()["quack"]))(d);
}

template<typename T>
T max(T a, T b) {
    return ((([&]() -> int64_t { if constexpr (std::is_pointer_v<decltype(a)>) { auto* _vp = dynamic_cast<VPtr*>(static_cast<AnyGC*>(a)); if (_vp) { return dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(dynamic_cast<VPtr*>(static_cast<AnyGC*>(a))->getVptrMap()["compareTo"]))(static_cast<AnyGC*>(a), _box(b))); } else { return static_cast<int64_t>(0); } } else { return ((a) > (b) ? 1LL : ((a) < (b) ? -1LL : 0LL)); } })() > 0LL) ? a : b);
}

void testGenericBounds() {
    staticPrint(max(GC::allocateLocal(new IntBox(3LL)), GC::allocateLocal(new IntBox(5LL))));
    staticPrint(max(GC::allocateLocal(new StringBox(std::string("apple"))), GC::allocateLocal(new StringBox(std::string("banana")))));
}

bool isEven(int64_t n) {
    return ((n % 2LL) == 0LL);
}

void testTypedef() {
    TypeFunction1<bool, int64_t>* pred = GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new TearOff_4()));
    staticPrint(pred->call(4LL));
}

void testAssert() {
    int64_t x = 5LL;
    assert((x > 0LL));
    staticPrint(std::string("assert passed"));
}

void testLabels() {
    _L1:
    int64_t i = 0LL;
    while ((i < 3LL)) {
        int64_t j = 0LL;
        while ((j < 3LL)) {
            if (((i == 1LL) && (j == 1LL))) {
                break;
            }
            staticPrint(dart_str(i) + dart_str(std::string(", ")) + dart_str(j));
            (j = (j + 1LL));
        }
        (i = (i + 1LL));
    }
}

int main() {
    staticPrint(std::string("=== 1. Spread ==="));
    testSpread();
    staticPrint(std::string("\n=== 2. Collection If/For ==="));
    testCollectionIfFor();
    staticPrint(std::string("\n=== 3. Cascade ==="));
    testCascade();
    staticPrint(std::string("\n=== 4. Null-aware ==="));
    testNullAware();
    staticPrint(std::string("\n=== 5. Late ==="));
    testLate();
    staticPrint(std::string("\n=== 6. Async ==="));
    testAsync();
    staticPrint(std::string("\n=== 7. Generators ==="));
    testGenerators();
    staticPrint(std::string("\n=== 8. Enum ==="));
    testEnum();
    staticPrint(std::string("\n=== 9. Extension ==="));
    testExtension();
    staticPrint(std::string("\n=== 10. Records ==="));
    testRecords();
    staticPrint(std::string("\n=== 11. Pattern Matching ==="));
    testPatternMatching();
    staticPrint(std::string("\n=== 12. Sealed Classes ==="));
    testSealed();
    staticPrint(std::string("\n=== 13. Operators ==="));
    testOperators();
    staticPrint(std::string("\n=== 14. Static ==="));
    testStatic();
    staticPrint(std::string("\n=== 15. Abstract ==="));
    testAbstract();
    staticPrint(std::string("\n=== 16. Mixin ==="));
    testMixin();
    staticPrint(std::string("\n=== 17. Generic Bounds ==="));
    testGenericBounds();
    staticPrint(std::string("\n=== 18. Typedef ==="));
    testTypedef();
    staticPrint(std::string("\n=== 19. Assert ==="));
    testAssert();
    staticPrint(std::string("\n=== 20. Labels ==="));
    testLabels();
    staticPrint(std::string("\n=== All tests completed ==="));
    return 0;
}

void Duck_fly(DuckValue* this__) {
    auto this_ = this__;
    staticPrint(std::string("Flying!"));
    return;
}

void Duck_swim(DuckValue* this__) {
    auto this_ = this__;
    staticPrint(std::string("Swimming!"));
    return;
}


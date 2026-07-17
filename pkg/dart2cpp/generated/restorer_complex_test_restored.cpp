#include "dart2cpp_lowered.h"

struct ShapeValue;
template<typename A, typename B> struct PairValue;
struct CircleValue;
struct RectangleValue;
struct Direction;
ShapeValue* Shape_new(ShapeValue* this__);
std::string Shape_get_name(ShapeValue* this__);
double Shape_area(ShapeValue* this__);
double Shape_perimeter(ShapeValue* this__);
std::string Shape_toString(ShapeValue* this__);
template<typename A, typename B> PairValue<A, B>* Pair_new(PairValue<A, B>* this__, A first, B second);
template<typename A, typename B> PairValue<B, A>* Pair_swap(PairValue<A, B>* this__);
template<typename A, typename B> std::string Pair_toString(PairValue<A, B>* this__);
CircleValue* Circle_new(CircleValue* this__, double _radius);
CircleValue* Circle_new_unit(CircleValue* this__);
double Circle_get_radius(CircleValue* this__);
void Circle_set_radius(CircleValue* this__, double value);
std::string Circle_get_name(CircleValue* this__);
double Circle_area(CircleValue* this__);
double Circle_perimeter(CircleValue* this__);
RectangleValue* Rectangle_new(RectangleValue* this__, double width, double height);
std::string Rectangle_get_name(RectangleValue* this__);
double Rectangle_area(RectangleValue* this__);
double Rectangle_perimeter(RectangleValue* this__);
std::string StringExtensions_capitalize(std::string this_);
TypeFunction0<std::string>* StringExtensions_get_capitalize(std::string this_);
bool StringExtensions_get_isPalindrome(std::string this_);
template<typename T> StaticList<T>* ListExtensions_filterWhere(StaticList<T>* this_, TypeFunction1<bool, T>* predicate);
template<typename T> TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*>* ListExtensions_get_filterWhere(StaticList<T>* this_);
template<typename T> T identity(T value);
template<typename T> StaticList<T>* repeat(T item, int64_t count);
TypeFunction* makeAdder(int64_t base);
StaticList<int64_t>* mapList(StaticList<int64_t>* items, TypeFunction1<int64_t, int64_t>* transform);
Promise<std::string>* fetchData(std::string url);
Promise<StaticList<std::string>*>* fetchAll(StaticList<std::string>* urls);
std::string findFirst(StaticList<std::string>* items, TypeFunction1<bool, std::string>* predicate);
int64_t safeLength(std::string text);
int main();
AnyGC* Circle_toString(CircleValue* this__);
AnyGC* Rectangle_toString(RectangleValue* this__);

struct Direction : VPtr {
    std::string _name;
    int64_t _index;

    static Direction* north;
    static Direction* south;
    static Direction* east;
    static Direction* west;
    static Direction* values;

    Direction(std::string n, int64_t i) : _name(std::move(n)), _index(i) {}

    std::string toString() const override { return "Direction." + _name; }
};

Direction* Direction::north = new Direction("north", 0);
Direction* Direction::south = new Direction("south", 1);
Direction* Direction::east = new Direction("east", 2);
Direction* Direction::west = new Direction("west", 3);
Direction* Direction::values = new Direction("values", 4);

struct ShapeValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ShapeValue::_vptrMap;

template<typename A, typename B>
struct PairValue : VPtr {
    A first{};
    B second{};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename A, typename B> std::unordered_map<std::string, void*> PairValue<A, B>::_vptrMap;

struct CircleValue : ShapeValue {
    double _radius{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CircleValue::_vptrMap;

struct RectangleValue : ShapeValue {
    double width{0.0};
    double height{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> RectangleValue::_vptrMap;

struct ClosureEnv_0 : TypeFunction0<std::string> {
    std::string this_;
    ClosureEnv_0(std::string this_) : this_(std::move(this_)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
    return StringExtensions_capitalize(this_);
    }
};

template<typename T>
struct ClosureEnv_1 : TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*> {
    StaticList<T>* this_;
    ClosureEnv_1(StaticList<T>* this_) : this_(std::move(this_)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<TypeFunction1<bool, T>*>(_p0)));
    }
    StaticList<T>* call(TypeFunction1<bool, T>* predicate) {
    return ListExtensions_filterWhere<T>(this_, predicate);
    }
};

template<typename T>
struct ClosureEnv_2 : TypeFunction1<T, int64_t> {
    T item;
    ClosureEnv_2(T item) : item(std::move(item)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    T call(int64_t _) {
    return item;
    }
};

struct ClosureEnv_3 : TypeFunction1<int64_t, int64_t> {
    int64_t base;
    ClosureEnv_3(int64_t base) : base(std::move(base)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_3*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t x) {
    return (base + x);
    }
};

struct ClosureEnv_4 : TypeFunction1<bool, int64_t> {
    ClosureEnv_4() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_4*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    bool call(int64_t n) {
    return ((n % 2LL) == 0LL);
    }
};

struct ClosureEnv_5 : TypeFunction1<int64_t, int64_t> {
    ClosureEnv_5() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_5*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t x) {
    return (x * 2LL);
    }
};

struct ClosureEnv_6 : TypeFunction0<int64_t> {
    IntBox* counter;
    ClosureEnv_6(IntBox* counter) : counter(counter) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_6*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
    (counter->value = (counter->value + 1LL));
    return counter->value;
    }
};

struct ClosureEnv_7 : TypeFunction1<bool, std::string> {
    ClosureEnv_7() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_7*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    bool call(std::string s) {
    return (s.find(std::string("b")) == 0);
    }
};

struct ClosureEnv_8 : TypeFunction1<bool, std::string> {
    ClosureEnv_8() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_8*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    bool call(std::string s) {
    return (s.find(std::string("z")) == 0);
    }
};

struct ClosureEnv_9 : TypeFunction1<bool, StaticMapEntry<std::string, int64_t>> {
    ClosureEnv_9() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_9*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(*reinterpret_cast<StaticMapEntry<std::string, int64_t>*>(dynamic_cast<VPtr*>(_p0))));
    }
    bool call(StaticMapEntry<std::string, int64_t> e) {
    return (e.value > 1LL);
    }
};


AnyGC* _vptr_wrap_Shape_get_name(AnyGC* obj__) {
    return _box(Shape_get_name(static_cast<ShapeValue*>(obj__)));
}

AnyGC* _vptr_wrap_Shape_area(AnyGC* obj__) {
    return _box(Shape_area(static_cast<ShapeValue*>(obj__)));
}

AnyGC* _vptr_wrap_Shape_perimeter(AnyGC* obj__) {
    return _box(Shape_perimeter(static_cast<ShapeValue*>(obj__)));
}

AnyGC* _vptr_wrap_Shape_toString(AnyGC* obj__) {
    return _box(Shape_toString(static_cast<ShapeValue*>(obj__)));
}

static bool _Shape_vptr_registered = []{ ShapeValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_get_name); ShapeValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_area); ShapeValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_perimeter); ShapeValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_toString); return true; }();
ShapeValue* Shape_new(ShapeValue* this__) {
    auto this_ = this__;
    if (ShapeValue::_vptrMap.empty()) {
        ShapeValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_get_name);
        ShapeValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_area);
        ShapeValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_perimeter);
        ShapeValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_toString);
    }
    return this_;
}

std::string Shape_get_name(ShapeValue* this__) {
    auto this_ = this__;
    return "";
}

double Shape_area(ShapeValue* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Shape.area")));
}

double Shape_perimeter(ShapeValue* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Shape.perimeter")));
}

std::string Shape_toString(ShapeValue* this__) {
    auto this_ = this__;
    return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_name"]))(this_))) + dart_str(std::string("(area=")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(2LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["area"]))(this_)); return _ss.str(); })()) + dart_str(std::string(")"));
}

template<typename A, typename B>
AnyGC* _vptr_wrap_Pair_swap(AnyGC* obj__) {
    return _box(Pair_swap<A, B>(static_cast<PairValue<A, B>*>(obj__)));
}

template<typename A, typename B>
AnyGC* _vptr_wrap_Pair_toString(AnyGC* obj__) {
    return _box(Pair_toString<A, B>(static_cast<PairValue<A, B>*>(obj__)));
}

template<typename A, typename B> void _register_Pair_vptr() {
    if (PairValue<A, B>::_vptrMap.empty()) {
        PairValue<A, B>::_vptrMap["swap"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_swap<A, B>);
        PairValue<A, B>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_toString<A, B>);
    }
}
template<typename A, typename B>
PairValue<A, B>* Pair_new(PairValue<A, B>* this__, A first, B second) {
    auto this_ = this__;
    if (PairValue<A, B>::_vptrMap.empty()) {
        PairValue<A, B>::_vptrMap["swap"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_swap<A, B>);
        PairValue<A, B>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_toString<A, B>);
    }
    this_->first = first;
    this_->second = second;
    return this_;
}

template<typename A, typename B>
PairValue<B, A>* Pair_swap(PairValue<A, B>* this__) {
    auto this_ = this__;
    return Pair_new<B, A>(GC::allocateLocal(new PairValue<B, A>()), this_->second, this_->first);
}

template<typename A, typename B>
std::string Pair_toString(PairValue<A, B>* this__) {
    auto this_ = this__;
    return dart_str(std::string("(")) + dart_str(this_->first) + dart_str(std::string(", ")) + dart_str(this_->second) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Circle_get_name(AnyGC* obj__) {
    return _box(Circle_get_name(static_cast<CircleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Circle_area(AnyGC* obj__) {
    return _box(Circle_area(static_cast<CircleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Circle_perimeter(AnyGC* obj__) {
    return _box(Circle_perimeter(static_cast<CircleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Circle_toString(AnyGC* obj__) {
    return _box(Circle_toString(static_cast<CircleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Circle_get_radius(AnyGC* obj__) {
    return _box(Circle_get_radius(static_cast<CircleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Circle_set_radius(AnyGC* obj__, AnyGC* arg0) {
    Circle_set_radius(static_cast<CircleValue*>(obj__), dynAs<double>(arg0));
    return nullptr;
}

static bool _Circle_vptr_registered = []{ CircleValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_get_name); CircleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_area); CircleValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_perimeter); CircleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_toString); CircleValue::_vptrMap["get_radius"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_get_radius); CircleValue::_vptrMap["set_radius"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_set_radius); return true; }();
CircleValue* Circle_new(CircleValue* this__, double _radius) {
    auto this_ = this__;
    if (CircleValue::_vptrMap.empty()) {
        CircleValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_get_name);
        CircleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_area);
        CircleValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_perimeter);
        CircleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_toString);
        CircleValue::_vptrMap["get_radius"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_get_radius);
        CircleValue::_vptrMap["set_radius"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_set_radius);
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

double Circle_get_radius(CircleValue* this__) {
    auto this_ = this__;
    return this_->_radius;
}

void Circle_set_radius(CircleValue* this__, double value) {
    auto this_ = this__;
    if ((value < 0LL)) {
        throw DartArgumentError(std::string("Radius must be non-negative"));
    }
    (this_->_radius = value);
}

std::string Circle_get_name(CircleValue* this__) {
    auto this_ = this__;
    return std::string("Circle");
}

double Circle_area(CircleValue* this__) {
    auto this_ = this__;
    return ((3.14159265 * this_->_radius) * this_->_radius);
}

double Circle_perimeter(CircleValue* this__) {
    auto this_ = this__;
    return ((2LL * 3.14159265) * this_->_radius);
}

AnyGC* _vptr_wrap_Rectangle_get_name(AnyGC* obj__) {
    return _box(Rectangle_get_name(static_cast<RectangleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Rectangle_area(AnyGC* obj__) {
    return _box(Rectangle_area(static_cast<RectangleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Rectangle_perimeter(AnyGC* obj__) {
    return _box(Rectangle_perimeter(static_cast<RectangleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Rectangle_toString(AnyGC* obj__) {
    return _box(Rectangle_toString(static_cast<RectangleValue*>(obj__)));
}

static bool _Rectangle_vptr_registered = []{ RectangleValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_get_name); RectangleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_area); RectangleValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_perimeter); RectangleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_toString); return true; }();
RectangleValue* Rectangle_new(RectangleValue* this__, double width, double height) {
    auto this_ = this__;
    if (RectangleValue::_vptrMap.empty()) {
        RectangleValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_get_name);
        RectangleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_area);
        RectangleValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_perimeter);
        RectangleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_toString);
    }
    this_->width = width;
    this_->height = height;
    Shape_new(this_);
    return this_;
}

std::string Rectangle_get_name(RectangleValue* this__) {
    auto this_ = this__;
    return std::string("Rectangle");
}

double Rectangle_area(RectangleValue* this__) {
    auto this_ = this__;
    return (this_->width * this_->height);
}

double Rectangle_perimeter(RectangleValue* this__) {
    auto this_ = this__;
    return (2LL * (this_->width + this_->height));
}

std::string StringExtensions_capitalize(std::string this_) {
    if (this_.empty()) {
        return this_;
    }
    return dart_str(dart_str_toUpper(std::string(1, this_[0LL]))) + dart_str(this_.substr(1LL));
}

TypeFunction0<std::string>* StringExtensions_get_capitalize(std::string this_) {
    return GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_0(this_)));
}

bool StringExtensions_get_isPalindrome(std::string this_) {
    std::string reversed = dart_str_split(this_, std::string(""))->reversed()->join();
    return (this_ == reversed);
}

template<typename T>
StaticList<T>* ListExtensions_filterWhere(StaticList<T>* this_, TypeFunction1<bool, T>* predicate) {
    return this_->where(predicate);
}

template<typename T>
TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*>* ListExtensions_get_filterWhere(StaticList<T>* this_) {
    return GC::allocateLocal(static_cast<TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*>*>(new ClosureEnv_1<T>(this_)));
}

template<typename T>
T identity(T value) {
    return value;
}

template<typename T>
StaticList<T>* repeat(T item, int64_t count) {
    return ([&]() { auto* _list = GC::allocateLocal(new StaticList<T>()); auto* _gen = GC::allocateLocal(static_cast<TypeFunction1<T, int64_t>*>(new ClosureEnv_2<T>(item))); for (int64_t _i = 0; _i < count; _i++) _list->add(_gen->call(_i)); return _list; })();
}

TypeFunction* makeAdder(int64_t base) {
    return GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_3(base)));
}

StaticList<int64_t>* mapList(StaticList<int64_t>* items, TypeFunction1<int64_t, int64_t>* transform) {
    return items->map(transform);
}

Promise<std::string>* fetchData(std::string url) {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    smAwait<AnyGC*>(_box(promiseDelayed(1, []() -> AnyGC* { return nullptr; })));
    _promise->complete(_box(dart_str(std::string("data from ")) + dart_str(url)));
    return _promise;
}

Promise<StaticList<std::string>*>* fetchAll(StaticList<std::string>* urls) {
    auto _promise = GC::allocateLocal(new Promise<StaticList<std::string>*>());
    StaticList<std::string>* results = GC::allocateLocal(new StaticList<std::string>());
    StaticIterator<std::string>* sync_for_iterator = urls->iterator();
    while (sync_for_iterator->moveNext()) {
        std::string url = sync_for_iterator->current();
        std::string data = smAwait<std::string>(fetchData(url));
        results->add(data);
    }
    _promise->complete(_box(results));
    return _promise;
}

std::string findFirst(StaticList<std::string>* items, TypeFunction1<bool, std::string>* predicate) {
    StaticIterator<std::string>* sync_for_iterator = items->iterator();
    while (sync_for_iterator->moveNext()) {
        std::string item = sync_for_iterator->current();
        if (predicate->call(item)) {
            return item;
        }
    }
    return "";
}

int64_t safeLength(std::string text) {
    return ([&]() { std::string _let1 = text; int64_t _let0 = ([&]() { std::string _let1 = text; return (_let1.empty() ? 0 : static_cast<int64_t>(_let1.length())); })();  return (false ? 0LL : _let0); })();
}

int main() {
    staticPrint(std::string("=== 复杂语法节点还原测试 ===\n"));
    staticPrint(std::string("--- 1. 泛型类 Pair ---"));
    PairValue<std::string, int64_t>* pair = Pair_new<std::string, int64_t>(GC::allocateLocal(new PairValue<std::string, int64_t>()), std::string("hello"), 42LL);
    PairValue<int64_t, std::string>* swapped = static_cast<PairValue<int64_t, std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(pair->getVptrMap()["swap"]))(pair));
    staticPrint(dart_str(std::string("pair: ")) + dart_str(pair));
    staticPrint(dart_str(std::string("swapped: ")) + dart_str(swapped));
    assert((pair->first == std::string("hello")));
    assert((swapped->first == 42LL));
    staticPrint(std::string("\n--- 2. 继承 + 多态 ---"));
    StaticList<ShapeValue*>* shapes = GC::allocateLocal(new StaticList<ShapeValue*>({Circle_new(GC::allocateLocal(new CircleValue()), 5.0), Rectangle_new(GC::allocateLocal(new RectangleValue()), 3.0, 4.0), Circle_new_unit(GC::allocateLocal(new CircleValue()))}));
    StaticIterator<ShapeValue*>* sync_for_iterator = shapes->iterator();
    while (sync_for_iterator->moveNext()) {
        ShapeValue* shape = sync_for_iterator->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(shape) + dart_str(std::string(", perimeter=")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(2LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(shape->getVptrMap()["perimeter"]))(shape)); return _ss.str(); })()));
    }
    staticPrint(std::string("\n--- 3. getter/setter + 异常 ---"));
    CircleValue* circle = Circle_new(GC::allocateLocal(new CircleValue()), 3.0);
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(circle->getVptrMap()["set_radius"]))(circle, _box(5.0));
    staticPrint(dart_str(std::string("radius after set: ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(circle->getVptrMap()["get_radius"]))(circle))));
    try {
        (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(circle->getVptrMap()["set_radius"]))(circle, _box((-1.0)));
        staticPrint(std::string("ERROR: should have thrown"));
    } catch (const DartArgumentError& e) {
        staticPrint(dart_str(std::string("Caught expected error: ")) + dart_str(e));
    }
    staticPrint(std::string("\n--- 4. 枚举 + switch ---"));
    StaticList<Direction*>* directions = GC::allocateLocal(new StaticList<Direction*>({Direction::north, Direction::east, Direction::south}));
    StaticIterator<Direction*>* sync_for_iterator_0 = directions->iterator();
    while (sync_for_iterator_0->moveNext()) {
        Direction* dir = sync_for_iterator_0->current();
        std::string label = ([&]() {         std::string _v2{""};
        _L1:
        do {
            switch (dir->_index) {
                _sw_case_0:
                case 0:
                {
                    (_v2 = std::string("N"));
                    break;
                    break;
                }
                _sw_case_1:
                case 1:
                {
                    (_v2 = std::string("S"));
                    break;
                    break;
                }
                _sw_case_2:
                case 2:
                {
                    (_v2 = std::string("E"));
                    break;
                    break;
                }
                _sw_case_3:
                case 3:
                {
                    (_v2 = std::string("W"));
                    break;
                    break;
                }
            }
        } while (false);
 return _v2; })();
        staticPrint(dart_str(std::string("  ")) + dart_str(dir) + dart_str(std::string(" -> ")) + dart_str(label));
    }
    staticPrint(std::string("\n--- 5. 扩展方法 ---"));
    std::string word = std::string("hello");
    staticPrint(dart_str(std::string("capitalize: ")) + dart_str(StringExtensions_capitalize(word)));
    staticPrint(dart_str(std::string("isPalindrome(\"racecar\"): ")) + dart_str(StringExtensions_get_isPalindrome(std::string("racecar"))));
    staticPrint(dart_str(std::string("isPalindrome(\"hello\"): ")) + dart_str(StringExtensions_get_isPalindrome(std::string("hello"))));
    StaticList<int64_t>* numbers = GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL, 5LL, 6LL}));
    StaticList<int64_t>* evens = ListExtensions_filterWhere<int64_t>(numbers, GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_4())));
    staticPrint(dart_str(std::string("evens: ")) + dart_str(evens));
    staticPrint(std::string("\n--- 6. 泛型函数 ---"));
    staticPrint(dart_str(std::string("identity<int>(99): ")) + dart_str(identity<int64_t>(99LL)));
    staticPrint(dart_str(std::string("repeat(\"x\", 3): ")) + dart_str(repeat<std::string>(std::string("x"), 3LL)));
    staticPrint(std::string("\n--- 7. 高阶函数 + 闭包 ---"));
    TypeFunction* add10 = makeAdder(10LL);
    staticPrint(dart_str(std::string("add10(5): ")) + dart_str(add10->dynCall(_box(5LL))));
    StaticList<int64_t>* doubled = mapList(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL})), GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_5())));
    staticPrint(dart_str(std::string("doubled: ")) + dart_str(doubled));
    IntBox* counter = new IntBox(0LL);
    TypeFunction0<int64_t>* increment = GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_6(counter)));
    staticPrint(dart_str(std::string("counter: ")) + dart_str(increment->call()) + dart_str(std::string(", ")) + dart_str(increment->call()) + dart_str(std::string(", ")) + dart_str(increment->call()));
    staticPrint(std::string("\n--- 8. 可空类型 ---"));
    StaticList<std::string>* items = GC::allocateLocal(new StaticList<std::string>({std::string("apple"), std::string("banana"), std::string("cherry")}));
    std::string found = findFirst(items, GC::allocateLocal(static_cast<TypeFunction1<bool, std::string>*>(new ClosureEnv_7())));
    staticPrint(dart_str(std::string("found: ")) + dart_str(found));
    std::string notFound = findFirst(items, GC::allocateLocal(static_cast<TypeFunction1<bool, std::string>*>(new ClosureEnv_8())));
    staticPrint(dart_str(std::string("notFound: ")) + dart_str(notFound));
    staticPrint(dart_str(std::string("safeLength(null): ")) + dart_str(safeLength("")));
    staticPrint(dart_str(std::string("safeLength(\"dart\"): ")) + dart_str(safeLength(std::string("dart"))));
    staticPrint(std::string("\n--- 9. 集合操作 ---"));
    StaticMap<std::string, int64_t>* map = ([&]() { auto* _m = StaticMap<std::string, int64_t>::empty(); _m->set(std::string("a"), 1LL); _m->set(std::string("b"), 2LL); _m->set(std::string("c"), 3LL); return _m; })();
    StaticMap<std::string, int64_t>* filtered = fromEntries<std::string, int64_t>(map->entries()->where(GC::allocateLocal(static_cast<TypeFunction1<bool, StaticMapEntry<std::string, int64_t>>*>(new ClosureEnv_9()))));
    staticPrint(dart_str(std::string("filtered map: ")) + dart_str(filtered));
    StaticSet<int64_t>* set1 = ([&]() {     StaticSet<int64_t>* _v4 = _Set_new<int64_t>(GC::allocateLocal(new _SetValue<int64_t>()));
    _v4->add(1LL);
    _v4->add(2LL);
    _v4->add(3LL);
    _v4->add(4LL);
 return _v4; })();
    StaticSet<int64_t>* set2 = ([&]() {     StaticSet<int64_t>* _v5 = _Set_new<int64_t>(GC::allocateLocal(new _SetValue<int64_t>()));
    _v5->add(3LL);
    _v5->add(4LL);
    _v5->add(5LL);
    _v5->add(6LL);
 return _v5; })();
    StaticSet<int64_t>* intersection = /* unsupported collection method: intersection on Set */ set1->intersection(set2);
    staticPrint(dart_str(std::string("intersection: ")) + dart_str(intersection));
    staticPrint(std::string("\n--- 10. 字符串插值 ---"));
    std::string name = std::string("Dart");
    int64_t version = 3LL;
    std::string greeting = dart_str(std::string("Hello, ")) + dart_str(name) + dart_str(std::string(" ")) + dart_str(version) + dart_str(std::string("!"));
    std::string multiExpr = dart_str(std::string("Sum: ")) + dart_str(((1LL + 2LL) + 3LL)) + dart_str(std::string(", Upper: ")) + dart_str(dart_str_toUpper(name));
    staticPrint(greeting);
    staticPrint(multiExpr);
    staticPrint(std::string("\n--- 11. 条件表达式 + 类型检查 ---"));
    AnyGC* value = _box(42LL);
    std::string typeLabel = ((dynamic_cast<IntBox*>(value) != nullptr) ? std::string("integer") : ((dynamic_cast<StringBox*>(value) != nullptr) ? std::string("string") : std::string("other")));
    staticPrint(dart_str(std::string("typeLabel: ")) + dart_str(typeLabel));
    staticPrint(std::string("\n--- 12. 循环语句 ---"));
    int64_t sum = 0LL;
    int64_t i = 1LL;
    while ((i <= 5LL)) {
        (sum = (sum + i));
        (i = (i + 1LL));
    }
    staticPrint(dart_str(std::string("sum 1..5: ")) + dart_str(sum));
    int64_t product = 1LL;
    int64_t n = 5LL;
    while ((n > 0LL)) {
        (product = (product * n));
        (n = (n - 1LL));
    }
    staticPrint(dart_str(std::string("5! = ")) + dart_str(product));
    int64_t doCount = 0LL;
    do {
        (doCount = (doCount + 1LL));
    } while ((doCount < 3LL));
    staticPrint(dart_str(std::string("doCount: ")) + dart_str(doCount));
    staticPrint(std::string("\n--- 13. try/catch/finally ---"));
    std::string result = std::string("");
    try {
        (result = std::string("try"));
        throw DartStateError(std::string("test error"));
    } catch (const DartException& e) {
        (result = (result + dart_str(std::string("+catch(")) + dart_str(e.message) + dart_str(std::string(")"))));
    }
    // finally
    (result = (result + std::string("+finally")));
    staticPrint(dart_str(std::string("result: ")) + dart_str(result));
    staticPrint(std::string("\n--- 14. 集合字面量 ---"));
    StaticList<int64_t>* constList = GC::allocateLocal(new StaticList<int64_t>({1, 2, 3}));
    StaticMap<std::string, std::string>* constMap = GC::allocateLocal(new StaticMap<std::string, std::string>());
    StaticSet<int64_t>* constSet = GC::allocateLocal(new StaticSet<int64_t>({10, 20, 30}));
    staticPrint(dart_str(std::string("constList: ")) + dart_str(GC::allocateLocal(new StaticList<int64_t>({1, 2, 3}))));
    staticPrint(dart_str(std::string("constMap: ")) + dart_str(GC::allocateLocal(new StaticMap<std::string, std::string>())));
    staticPrint(dart_str(std::string("constSet: ")) + dart_str(GC::allocateLocal(new StaticSet<int64_t>({10, 20, 30}))));
    staticPrint(std::string("\n=== 所有测试通过 ✅ ==="));
    return 0;
}

AnyGC* Circle_toString(CircleValue* this__) {
    auto this_ = this__;
    return _box(Shape_toString(this_));
}

AnyGC* Rectangle_toString(RectangleValue* this__) {
    auto this_ = this__;
    return _box(Shape_toString(this_));
}


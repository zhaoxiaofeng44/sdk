#include "dart2cpp_lowered.h"

// === Forward declarations: Value structs ===
struct ShapeValue;
template<typename A, typename B> struct PairValue;
struct CircleValue;
struct RectangleValue;
struct ClosureEnv_global_0;
template<typename T> struct ClosureEnv_global_1;
template<typename T> struct ClosureEnv_global_2;
struct ClosureEnv_global_3;
struct ClosureEnv_global_4;
struct ClosureEnv_global_5;
struct ClosureEnv_global_6;
struct ClosureEnv_global_7;
struct ClosureEnv_global_8;
struct ClosureEnv_global_9;

// === Forward declarations: static functions ===
ShapeValue* Shape_new(ShapeValue* this__);
std::string Shape_get_name(AnyPtr this__);
double Shape_area(AnyPtr this__);
double Shape_perimeter(AnyPtr this__);
std::string Shape_toString(AnyPtr this__);
template<typename A, typename B> PairValue<A, B>* Pair_new(PairValue<A, B>* this__, A first, B second);
template<typename A, typename B> PairValue<B, A>* Pair_swap(AnyPtr this__);
template<typename A, typename B> std::string Pair_toString(AnyPtr this__);
CircleValue* Circle_new(CircleValue* this__, double _radius);
CircleValue* Circle_new_unit(CircleValue* this__);
double Circle_get_radius(AnyPtr this__);
void Circle_set_radius(AnyPtr this__, double value);
std::string Circle_get_name(AnyPtr this__);
double Circle_area(AnyPtr this__);
double Circle_perimeter(AnyPtr this__);
std::string Circle_toString(AnyPtr this__);
RectangleValue* Rectangle_new(RectangleValue* this__, double width, double height);
std::string Rectangle_get_name(AnyPtr this__);
double Rectangle_area(AnyPtr this__);
double Rectangle_perimeter(AnyPtr this__);
std::string Rectangle_toString(AnyPtr this__);
std::string StringExtensions_capitalize(std::string this_);
TypeFunction0<std::string>* StringExtensions_get_capitalize(std::string this_);
bool StringExtensions_get_isPalindrome(std::string this_);
template<typename T> StaticList<T>* ListExtensions_filterWhere(StaticList<T>* this_, TypeFunction1<bool, T>* predicate);
template<typename T> TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*>* ListExtensions_get_filterWhere(StaticList<T>* this_);
template<typename T> T identity(T value);
template<typename T> StaticList<T>* repeat(T item, int count);
AnyPtr makeAdder(int base);
StaticList<int>* mapList(StaticList<int>* items, TypeFunction1<int, int>* transform);
Promise<std::string>* fetchData(std::string url);
Promise<StaticList<std::string>*>* fetchAll(StaticList<std::string>* urls);
AnyPtr findFirst(StaticList<std::string>* items, TypeFunction1<bool, std::string>* predicate);
int safeLength(AnyPtr text);
std::string ClosureEnv_global_0_call(AnyPtr env__);
ClosureEnv_global_0* ClosureEnv_global_0_new(ClosureEnv_global_0* env_, std::string this_);
template<typename T> StaticList<T>* ClosureEnv_global_1_call(AnyPtr env__, TypeFunction1<bool, T>* predicate);
template<typename T> ClosureEnv_global_1<T>* ClosureEnv_global_1_new(ClosureEnv_global_1<T>* env_, StaticList<T>* this_);
template<typename T> T ClosureEnv_global_2_call(AnyPtr env__, int _);
template<typename T> ClosureEnv_global_2<T>* ClosureEnv_global_2_new(ClosureEnv_global_2<T>* env_, T item);
int ClosureEnv_global_3_call(AnyPtr env__, int x);
ClosureEnv_global_3* ClosureEnv_global_3_new(ClosureEnv_global_3* env_, int base);
bool ClosureEnv_global_4_call(AnyPtr env__, int n);
ClosureEnv_global_4* ClosureEnv_global_4_new(ClosureEnv_global_4* env_);
int ClosureEnv_global_5_call(AnyPtr env__, int x);
ClosureEnv_global_5* ClosureEnv_global_5_new(ClosureEnv_global_5* env_);
int ClosureEnv_global_6_call(AnyPtr env__);
ClosureEnv_global_6* ClosureEnv_global_6_new(ClosureEnv_global_6* env_, int counter);
bool ClosureEnv_global_7_call(AnyPtr env__, std::string s);
ClosureEnv_global_7* ClosureEnv_global_7_new(ClosureEnv_global_7* env_);
bool ClosureEnv_global_8_call(AnyPtr env__, std::string s);
ClosureEnv_global_8* ClosureEnv_global_8_new(ClosureEnv_global_8* env_);
bool ClosureEnv_global_9_call(AnyPtr env__, StaticMapEntry<std::string, int> e);
ClosureEnv_global_9* ClosureEnv_global_9_new(ClosureEnv_global_9* env_);

std::string ClosureEnv_global_0_call(AnyPtr env__);
ClosureEnv_global_0* ClosureEnv_global_0_new(ClosureEnv_global_0* env_, std::string this_);

struct ClosureEnv_global_0 : TypeFunction0<std::string> {
    std::string this_{};

    ClosureEnv_global_0() {
    }
    std::string call() {
        return ClosureEnv_global_0_call(AnyPtr::fromTypeFunction(this));
    }

    void gcMark(int flag) override {
        TypeFunction::gcMark(flag);
    }
};

std::string ClosureEnv_global_0_call(AnyPtr env__) {
    auto env = static_cast<ClosureEnv_global_0*>(env__.toTypeFunction());
return StringExtensions_capitalize(env->this_);
}

ClosureEnv_global_0* ClosureEnv_global_0_new(ClosureEnv_global_0* env_, std::string this_) {
    env_->this_ = this_;
    env_->closureCall = reinterpret_cast<void*>(static_cast<std::string(*)(AnyPtr)>(&ClosureEnv_global_0_call));
    GC::allocateLocal(env_);
    return env_;
}

template<typename T> StaticList<T>* ClosureEnv_global_1_call(AnyPtr env__, TypeFunction1<bool, T>* predicate);
template<typename T> ClosureEnv_global_1<T>* ClosureEnv_global_1_new(ClosureEnv_global_1<T>* env_, StaticList<T>* this_);

template<typename T> struct ClosureEnv_global_1 : TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*> {
    StaticList<T>* this_{};

    ClosureEnv_global_1<T>() {
    }
    StaticList<T>* call(TypeFunction1<bool, T>* predicate) {
        return ClosureEnv_global_1_call(AnyPtr::fromTypeFunction(this), predicate);
    }

    void gcMark(int flag) override {
        TypeFunction::gcMark(flag);
        if (this_) this_->gcMark(flag);
    }
};

template<typename T> StaticList<T>* ClosureEnv_global_1_call(AnyPtr env__, TypeFunction1<bool, T>* predicate) {
    auto env = static_cast<ClosureEnv_global_1<T>*>(env__.toTypeFunction());
return ListExtensions_filterWhere(env->this_, predicate);
}

template<typename T> ClosureEnv_global_1<T>* ClosureEnv_global_1_new(ClosureEnv_global_1<T>* env_, StaticList<T>* this_) {
    env_->this_ = this_;
    env_->closureCall = reinterpret_cast<void*>(static_cast<StaticList<T>*(*)(AnyPtr, TypeFunction1<bool, T>*)>(&ClosureEnv_global_1_call<T>));
    GC::allocateLocal(env_);
    return env_;
}

template<typename T> T ClosureEnv_global_2_call(AnyPtr env__, int _);
template<typename T> ClosureEnv_global_2<T>* ClosureEnv_global_2_new(ClosureEnv_global_2<T>* env_, T item);

template<typename T> struct ClosureEnv_global_2 : TypeFunction1<T, int> {
    T item{};

    ClosureEnv_global_2<T>() {
    }
    T call(int _) {
        return ClosureEnv_global_2_call(AnyPtr::fromTypeFunction(this), _);
    }

    void gcMark(int flag) override {
        TypeFunction::gcMark(flag);
    }
};

template<typename T> T ClosureEnv_global_2_call(AnyPtr env__, int _) {
    auto env = static_cast<ClosureEnv_global_2<T>*>(env__.toTypeFunction());
return env->item;
}

template<typename T> ClosureEnv_global_2<T>* ClosureEnv_global_2_new(ClosureEnv_global_2<T>* env_, T item) {
    env_->item = item;
    env_->closureCall = reinterpret_cast<void*>(static_cast<T(*)(AnyPtr, int)>(&ClosureEnv_global_2_call<T>));
    GC::allocateLocal(env_);
    return env_;
}

int ClosureEnv_global_3_call(AnyPtr env__, int x);
ClosureEnv_global_3* ClosureEnv_global_3_new(ClosureEnv_global_3* env_, int base);

struct ClosureEnv_global_3 : TypeFunction1<int, int> {
    int base{};

    ClosureEnv_global_3() {
    }
    int call(int x) {
        return ClosureEnv_global_3_call(AnyPtr::fromTypeFunction(this), x);
    }

    void gcMark(int flag) override {
        TypeFunction::gcMark(flag);
    }
};

int ClosureEnv_global_3_call(AnyPtr env__, int x) {
    auto env = static_cast<ClosureEnv_global_3*>(env__.toTypeFunction());
return (env->base + x);
}

ClosureEnv_global_3* ClosureEnv_global_3_new(ClosureEnv_global_3* env_, int base) {
    env_->base = base;
    env_->closureCall = reinterpret_cast<void*>(static_cast<int(*)(AnyPtr, int)>(&ClosureEnv_global_3_call));
    GC::allocateLocal(env_);
    return env_;
}

bool ClosureEnv_global_4_call(AnyPtr env__, int n);
ClosureEnv_global_4* ClosureEnv_global_4_new(ClosureEnv_global_4* env_);

struct ClosureEnv_global_4 : TypeFunction1<bool, int> {

    ClosureEnv_global_4() {
    }
    bool call(int n) {
        return ClosureEnv_global_4_call(AnyPtr::fromTypeFunction(this), n);
    }
};

bool ClosureEnv_global_4_call(AnyPtr env__, int n) {
    auto env = static_cast<ClosureEnv_global_4*>(env__.toTypeFunction());
return ((n % 2) == 0);
}

ClosureEnv_global_4* ClosureEnv_global_4_new(ClosureEnv_global_4* env_) {
    env_->closureCall = reinterpret_cast<void*>(static_cast<bool(*)(AnyPtr, int)>(&ClosureEnv_global_4_call));
    GC::allocateLocal(env_);
    return env_;
}

int ClosureEnv_global_5_call(AnyPtr env__, int x);
ClosureEnv_global_5* ClosureEnv_global_5_new(ClosureEnv_global_5* env_);

struct ClosureEnv_global_5 : TypeFunction1<int, int> {

    ClosureEnv_global_5() {
    }
    int call(int x) {
        return ClosureEnv_global_5_call(AnyPtr::fromTypeFunction(this), x);
    }
};

int ClosureEnv_global_5_call(AnyPtr env__, int x) {
    auto env = static_cast<ClosureEnv_global_5*>(env__.toTypeFunction());
return (x * 2);
}

ClosureEnv_global_5* ClosureEnv_global_5_new(ClosureEnv_global_5* env_) {
    env_->closureCall = reinterpret_cast<void*>(static_cast<int(*)(AnyPtr, int)>(&ClosureEnv_global_5_call));
    GC::allocateLocal(env_);
    return env_;
}

int ClosureEnv_global_6_call(AnyPtr env__);
ClosureEnv_global_6* ClosureEnv_global_6_new(ClosureEnv_global_6* env_, int counter);

struct ClosureEnv_global_6 : TypeFunction0<int> {
    int counter{};

    ClosureEnv_global_6() {
    }
    int call() {
        return ClosureEnv_global_6_call(AnyPtr::fromTypeFunction(this));
    }

    void gcMark(int flag) override {
        TypeFunction::gcMark(flag);
    }
};

int ClosureEnv_global_6_call(AnyPtr env__) {
    auto env = static_cast<ClosureEnv_global_6*>(env__.toTypeFunction());
env->counter = (env->counter + 1);
return env->counter;
}

ClosureEnv_global_6* ClosureEnv_global_6_new(ClosureEnv_global_6* env_, int counter) {
    env_->counter = counter;
    env_->closureCall = reinterpret_cast<void*>(static_cast<int(*)(AnyPtr)>(&ClosureEnv_global_6_call));
    GC::allocateLocal(env_);
    return env_;
}

bool ClosureEnv_global_7_call(AnyPtr env__, std::string s);
ClosureEnv_global_7* ClosureEnv_global_7_new(ClosureEnv_global_7* env_);

struct ClosureEnv_global_7 : TypeFunction1<bool, std::string> {

    ClosureEnv_global_7() {
    }
    bool call(std::string s) {
        return ClosureEnv_global_7_call(AnyPtr::fromTypeFunction(this), s);
    }
};

bool ClosureEnv_global_7_call(AnyPtr env__, std::string s) {
    auto env = static_cast<ClosureEnv_global_7*>(env__.toTypeFunction());
return (s.find("b") == 0);
}

ClosureEnv_global_7* ClosureEnv_global_7_new(ClosureEnv_global_7* env_) {
    env_->closureCall = reinterpret_cast<void*>(static_cast<bool(*)(AnyPtr, std::string)>(&ClosureEnv_global_7_call));
    GC::allocateLocal(env_);
    return env_;
}

bool ClosureEnv_global_8_call(AnyPtr env__, std::string s);
ClosureEnv_global_8* ClosureEnv_global_8_new(ClosureEnv_global_8* env_);

struct ClosureEnv_global_8 : TypeFunction1<bool, std::string> {

    ClosureEnv_global_8() {
    }
    bool call(std::string s) {
        return ClosureEnv_global_8_call(AnyPtr::fromTypeFunction(this), s);
    }
};

bool ClosureEnv_global_8_call(AnyPtr env__, std::string s) {
    auto env = static_cast<ClosureEnv_global_8*>(env__.toTypeFunction());
return (s.find("z") == 0);
}

ClosureEnv_global_8* ClosureEnv_global_8_new(ClosureEnv_global_8* env_) {
    env_->closureCall = reinterpret_cast<void*>(static_cast<bool(*)(AnyPtr, std::string)>(&ClosureEnv_global_8_call));
    GC::allocateLocal(env_);
    return env_;
}

bool ClosureEnv_global_9_call(AnyPtr env__, StaticMapEntry<std::string, int> e);
ClosureEnv_global_9* ClosureEnv_global_9_new(ClosureEnv_global_9* env_);

struct ClosureEnv_global_9 : TypeFunction1<bool, StaticMapEntry<std::string, int>> {

    ClosureEnv_global_9() {
    }
    bool call(StaticMapEntry<std::string, int> e) {
        return ClosureEnv_global_9_call(AnyPtr::fromTypeFunction(this), e);
    }
};

bool ClosureEnv_global_9_call(AnyPtr env__, StaticMapEntry<std::string, int> e) {
    auto env = static_cast<ClosureEnv_global_9*>(env__.toTypeFunction());
return (e.value > 1);
}

ClosureEnv_global_9* ClosureEnv_global_9_new(ClosureEnv_global_9* env_) {
    env_->closureCall = reinterpret_cast<void*>(static_cast<bool(*)(AnyPtr, StaticMapEntry<std::string, int>)>(&ClosureEnv_global_9_call));
    GC::allocateLocal(env_);
    return env_;
}

struct ShapeValue : VPtr {

    ShapeValue() {
        _typeName = "Shape";
        vptr["get_name"] = reinterpret_cast<void*>(&Shape_get_name);
        vptr["area"] = reinterpret_cast<void*>(&Shape_area);
        vptr["perimeter"] = reinterpret_cast<void*>(&Shape_perimeter);
        vptr["toString"] = reinterpret_cast<void*>(&Shape_toString);
    }
};

ShapeValue* Shape_new(ShapeValue* this__) {
    return this__;
}

std::string Shape_get_name(AnyPtr this__) {
    throw DartUnimplementedError("Shape_get_name is abstract");
}

double Shape_area(AnyPtr this__) {
    throw DartUnimplementedError("Shape_area is abstract");
}

double Shape_perimeter(AnyPtr this__) {
    throw DartUnimplementedError("Shape_perimeter is abstract");
}

std::string Shape_toString(AnyPtr this__) {
    auto this_ = static_cast<ShapeValue*>(this__.toVPtr());
return dart_str(reinterpret_cast<std::string(*)(AnyPtr)>(this_->vptr["get_name"])(AnyPtr::fromVPtr(this_))) + "(area=" + dart_str(dart_str_toStringAsFixed(reinterpret_cast<double(*)(AnyPtr)>(this_->vptr["area"])(AnyPtr::fromVPtr(this_)), 2)) + ")";
}

template<typename A, typename B> struct PairValue : VPtr {
    A first{};
    B second{};

    PairValue() {
        _typeName = "Pair";
        vptr["swap"] = reinterpret_cast<void*>(&Pair_swap<A, B>);
        vptr["toString"] = reinterpret_cast<void*>(&Pair_toString<A, B>);
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename A, typename B> PairValue<A, B>* Pair_new(PairValue<A, B>* this__, A first, B second) {
    this__->first = first;
    this__->second = second;
    return this__;
}

template<typename A, typename B> PairValue<B, A>* Pair_swap(AnyPtr this__) {
    auto this_ = static_cast<PairValue<A, B>*>(this__.toVPtr());
return Pair_new<B, A>(GC::allocateLocal(new PairValue<B, A>()), this_->second, this_->first);
}

template<typename A, typename B> std::string Pair_toString(AnyPtr this__) {
    auto this_ = static_cast<PairValue<A, B>*>(this__.toVPtr());
return "(" + dart_str(this_->first) + ", " + dart_str(this_->second) + ")";
}

struct CircleValue : ShapeValue {
    double _radius{};

    CircleValue() {
        _typeName = "Circle";
        vptr["get_name"] = reinterpret_cast<void*>(&Circle_get_name);
        vptr["area"] = reinterpret_cast<void*>(&Circle_area);
        vptr["perimeter"] = reinterpret_cast<void*>(&Circle_perimeter);
        vptr["get_radius"] = reinterpret_cast<void*>(&Circle_get_radius);
        vptr["set_radius"] = reinterpret_cast<void*>(&Circle_set_radius);
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

CircleValue* Circle_new(CircleValue* this__, double _radius) {
    Shape_new(this__);
    this__->_radius = _radius;
    return this__;
}

CircleValue* Circle_new_unit(CircleValue* this__) {
    Shape_new(this__);
    this__->_radius = 1.0;
    return this__;
}

double Circle_get_radius(AnyPtr this__) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
return this_->_radius;
}

void Circle_set_radius(AnyPtr this__, double value) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
if ((value < 0)) {
    throw DartArgumentError("Radius must be non-negative");
}
this_->_radius = value;
}

std::string Circle_get_name(AnyPtr this__) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
return "Circle";
}

double Circle_area(AnyPtr this__) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
return ((3.14159265 * this_->_radius) * this_->_radius);
}

double Circle_perimeter(AnyPtr this__) {
    auto this_ = static_cast<CircleValue*>(this__.toVPtr());
return ((2 * 3.14159265) * this_->_radius);
}

std::string Circle_toString(AnyPtr this__) { return Shape_toString(this__); }

struct RectangleValue : ShapeValue {
    double width{};
    double height{};

    RectangleValue() {
        _typeName = "Rectangle";
        vptr["get_name"] = reinterpret_cast<void*>(&Rectangle_get_name);
        vptr["area"] = reinterpret_cast<void*>(&Rectangle_area);
        vptr["perimeter"] = reinterpret_cast<void*>(&Rectangle_perimeter);
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

RectangleValue* Rectangle_new(RectangleValue* this__, double width, double height) {
    Shape_new(this__);
    this__->width = width;
    this__->height = height;
    return this__;
}

std::string Rectangle_get_name(AnyPtr this__) {
    auto this_ = static_cast<RectangleValue*>(this__.toVPtr());
return "Rectangle";
}

double Rectangle_area(AnyPtr this__) {
    auto this_ = static_cast<RectangleValue*>(this__.toVPtr());
return (this_->width * this_->height);
}

double Rectangle_perimeter(AnyPtr this__) {
    auto this_ = static_cast<RectangleValue*>(this__.toVPtr());
return (2 * (this_->width + this_->height));
}

std::string Rectangle_toString(AnyPtr this__) { return Shape_toString(this__); }

enum class Direction {
    north,
    south,
    east,
    west
};

std::string StringExtensions_capitalize(std::string this_) {
if (this_.empty()) {
    return this_;
}
return dart_str(dart_str_toUpper(this_.substr(0, 1))) + dart_str(this_.substr(1));
}

TypeFunction0<std::string>* StringExtensions_get_capitalize(std::string this_) {
return ClosureEnv_global_0_new(GC::allocateLocal(new ClosureEnv_global_0()), this_);
}

bool StringExtensions_get_isPalindrome(std::string this_) {
std::string reversed = dart_str_split(this_, "")->reversed()->join();
return (this_ == reversed);
}

template<typename T> StaticList<T>* ListExtensions_filterWhere(StaticList<T>* this_, TypeFunction1<bool, T>* predicate) {
return this_->where(predicate);
}

template<typename T> TypeFunction1<StaticList<T>*, TypeFunction1<bool, T>*>* ListExtensions_get_filterWhere(StaticList<T>* this_) {
return ClosureEnv_global_1_new<T>(GC::allocateLocal(new ClosureEnv_global_1<T>()), this_);
}

template<typename T> T identity(T value) {
return value;
}

template<typename T> StaticList<T>* repeat(T item, int count) {
return StaticList<T>::generate(count, ClosureEnv_global_2_new<T>(GC::allocateLocal(new ClosureEnv_global_2<T>()), item));
}

AnyPtr makeAdder(int base) {
return ClosureEnv_global_3_new(GC::allocateLocal(new ClosureEnv_global_3()), base);
}

StaticList<int>* mapList(StaticList<int>* items, TypeFunction1<int, int>* transform) {
return items->map(transform);
}

Promise<std::string>* fetchData(std::string url) {
smAwait<AnyPtr>(promiseDelayed(1, []() { return AnyPtr(); }));
return Promise<std::string>::value("data from " + dart_str(url));
}

Promise<StaticList<std::string>*>* fetchAll(StaticList<std::string>* urls) {
StaticList<std::string>* results = StaticList<std::string>::of({});
for (auto& url : *urls) {
    std::string data = smAwait<std::string>(fetchData(url));
    results->add(data);
}
return Promise<StaticList<std::string>*>::value(results);
}

AnyPtr findFirst(StaticList<std::string>* items, TypeFunction1<bool, std::string>* predicate) {
for (auto& item : *items) {
    if (predicate->call(item)) {
        return AnyPtr::fromAuto(item);
    }
}
return AnyPtr();
}

int safeLength(AnyPtr text) {
return ([&]() { auto _unnamed = ([&]() { auto _unnamed = text; return ((_unnamed == AnyPtr()) ? AnyPtr() : AnyPtr::fromInt(static_cast<int64_t>(_unnamed.toStringValue().length()))); })(); return ((_unnamed == AnyPtr()) ? AnyPtr::fromInt(0) : _unnamed); })();
}

int main() {
staticPrint("=== 复杂语法节点还原测试 ===\n");
staticPrint("--- 1. 泛型类 Pair ---");
PairValue<std::string, int>* pair = Pair_new<std::string, int>(GC::allocateLocal(new PairValue<std::string, int>()), "hello", 42);
PairValue<int, std::string>* swapped = reinterpret_cast<PairValue<int, std::string>*(*)(AnyPtr)>(pair->vptr["swap"])(AnyPtr::fromVPtr(pair));
staticPrint("pair: " + dart_str(pair));
staticPrint("swapped: " + dart_str(swapped));
assert((pair->first == "hello"));
assert((swapped->first == 42));
staticPrint("\n--- 2. 继承 + 多态 ---");
StaticList<ShapeValue*>* shapes = StaticList<ShapeValue*>::of({Circle_new(GC::allocateLocal(new CircleValue()), 5.0), Rectangle_new(GC::allocateLocal(new RectangleValue()), 3.0, 4.0), Circle_new_unit(GC::allocateLocal(new CircleValue()))});
for (auto* shape : *shapes) {
    staticPrint("  " + dart_str(shape) + ", perimeter=" + dart_str(dart_str_toStringAsFixed(reinterpret_cast<double(*)(AnyPtr)>(shape->vptr["perimeter"])(AnyPtr::fromVPtr(shape)), 2)));
}
staticPrint("\n--- 3. getter/setter + 异常 ---");
CircleValue* circle = Circle_new(GC::allocateLocal(new CircleValue()), 3.0);
reinterpret_cast<AnyPtr(*)(AnyPtr, AnyPtr)>(circle->vptr["set_radius"])(AnyPtr::fromVPtr(circle), AnyPtr::fromDouble(5.0));
staticPrint("radius after set: " + dart_str(reinterpret_cast<double(*)(AnyPtr)>(circle->vptr["get_radius"])(AnyPtr::fromVPtr(circle))));
try {
    reinterpret_cast<AnyPtr(*)(AnyPtr, AnyPtr)>(circle->vptr["set_radius"])(AnyPtr::fromVPtr(circle), AnyPtr::fromDouble(-1.0));
    staticPrint("ERROR: should have thrown");
} catch (DartArgumentError e) {
    staticPrint("Caught expected error: " + dart_str(e));
}
staticPrint("\n--- 4. 枚举 + switch ---");
StaticList<Direction>* directions = StaticList<Direction>::of({Direction::north, Direction::east, Direction::south});
for (auto& dir : *directions) {
    std::string label = ([&]() { auto _unnamed = AnyPtr(); return _unnamed; })();
    staticPrint("  " + dart_str(dir) + " -> " + dart_str(label));
}
staticPrint("\n--- 5. 扩展方法 ---");
std::string word = "hello";
staticPrint("capitalize: " + dart_str(StringExtensions_capitalize(word)));
staticPrint("isPalindrome(\"racecar\"): " + dart_str(StringExtensions_get_isPalindrome("racecar")));
staticPrint("isPalindrome(\"hello\"): " + dart_str(StringExtensions_get_isPalindrome("hello")));
StaticList<int>* numbers = StaticList<int>::of({1, 2, 3, 4, 5, 6});
StaticList<int>* evens = ListExtensions_filterWhere(numbers, ClosureEnv_global_4_new(GC::allocateLocal(new ClosureEnv_global_4())));
staticPrint("evens: " + dart_str(evens));
staticPrint("\n--- 6. 泛型函数 ---");
staticPrint("identity<int>(99): " + dart_str(identity(99)));
staticPrint("repeat(\"x\", 3): " + dart_str(repeat("x", 3)));
staticPrint("\n--- 7. 高阶函数 + 闭包 ---");
AnyPtr add10 = makeAdder(10);
staticPrint("add10(5): " + dart_str(add10(5)));
StaticList<int>* doubled = mapList(StaticList<int>::of({1, 2, 3, 4}), ClosureEnv_global_5_new(GC::allocateLocal(new ClosureEnv_global_5())));
staticPrint("doubled: " + dart_str(doubled));
int counter = 0;
TypeFunction0<int>* increment = ClosureEnv_global_6_new(GC::allocateLocal(new ClosureEnv_global_6()), counter);
staticPrint("counter: " + dart_str(increment->call()) + ", " + dart_str(increment->call()) + ", " + dart_str(increment->call()));
staticPrint("\n--- 8. 可空类型 ---");
StaticList<std::string>* items = StaticList<std::string>::of({"apple", "banana", "cherry"});
AnyPtr found = findFirst(items, ClosureEnv_global_7_new(GC::allocateLocal(new ClosureEnv_global_7())));
staticPrint("found: " + dart_str(found));
AnyPtr notFound = findFirst(items, ClosureEnv_global_8_new(GC::allocateLocal(new ClosureEnv_global_8())));
staticPrint("notFound: " + dart_str(notFound));
staticPrint("safeLength(null): " + dart_str(safeLength(AnyPtr())));
staticPrint("safeLength(\"dart\"): " + dart_str(safeLength("dart")));
staticPrint("\n--- 9. 集合操作 ---");
StaticMap<std::string, int>* map = StaticMap<std::string, int>::of({StaticMapEntry<std::string, int>("a", 1), StaticMapEntry<std::string, int>("b", 2), StaticMapEntry<std::string, int>("c", 3)});
StaticMap<std::string, int>* filtered = StaticMap::fromEntries(map->entries->where(ClosureEnv_global_9_new(GC::allocateLocal(new ClosureEnv_global_9()))));
staticPrint("filtered map: " + dart_str(filtered));
StaticSet<int>* set1 = StaticSet<int>::of({1, 2, 3, 4});
StaticSet<int>* set2 = StaticSet<int>::of({3, 4, 5, 6});
StaticSet<int>* intersection = set1.intersection(set2);
staticPrint("intersection: " + dart_str(intersection));
staticPrint("\n--- 10. 字符串插值 ---");
std::string name = "Dart";
int version = 3;
std::string greeting = "Hello, " + dart_str(name) + " " + dart_str(version) + "!";
std::string multiExpr = "Sum: " + dart_str(((1 + 2) + 3)) + ", Upper: " + dart_str(dart_str_toUpper(name));
staticPrint(greeting);
staticPrint(multiExpr);
staticPrint("\n--- 11. 条件表达式 + 类型检查 ---");
AnyPtr value = 42;
std::string typeLabel = (dart_is<int>(value) ? "integer" : (dart_is<std::string>(value) ? "string" : "other"));
staticPrint("typeLabel: " + dart_str(typeLabel));
staticPrint("\n--- 12. 循环语句 ---");
int sum = 0;
for (int i = 1; (i <= 5); i = (i + 1)) {
    sum = (sum + i);
}
staticPrint("sum 1..5: " + dart_str(sum));
int product = 1;
int n = 5;
while ((n > 0)) {
    product = (product * n);
    n = (n - 1);
}
staticPrint("5! = " + dart_str(product));
int doCount = 0;
do {
    doCount = (doCount + 1);
} while ((doCount < 3));
staticPrint("doCount: " + dart_str(doCount));
staticPrint("\n--- 13. try/catch/finally ---");
std::string result = "";
try {
    result = "try";
    throw DartStateError("test error");
} catch (DartStateError e) {
    result = (result + "+catch(" + dart_str(e->message) + ")");
}
// finally
result = (result + "+finally");
}
staticPrint("result: " + dart_str(result));
staticPrint("\n--- 14. 集合字面量 ---");
staticPrint("constList: " + dart_str(StaticList<AnyPtr>::of({1, 2, 3})));
staticPrint("constMap: " + dart_str(StaticMap<AnyPtr, AnyPtr>::of({StaticMapEntry<AnyPtr, AnyPtr>("key", "value")})));
staticPrint("constSet: " + dart_str(StaticSet<AnyPtr>::of({10, 20, 30})));
staticPrint("\n=== 所有测试通过 ✅ ===");
}


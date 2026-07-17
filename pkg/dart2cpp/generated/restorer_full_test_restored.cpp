#include "dart2cpp_lowered.h"

struct PrintableMixin;
template<typename T> struct OrderableMixin;
struct AnimalValue;
struct DogValue;
struct CatValue;
struct Vector2DValue;
struct CounterValue;
template<typename T> struct ResultValue;
struct LazyLoaderValue;
struct BoundedValueValue;
struct ShapeValue;
struct PolygonValue;
struct RegularPolygonValue;
struct SquareValue;
struct SerializableValue;
template<typename T> struct CloneableValue;
template<typename T> struct Comparable2Value;
struct DataPointValue;
struct LoggableMixin;
struct ValidatableMixin;
struct LoggedDataPointValue;
struct ConfigValue;
template<typename T> struct SortedListValue;
struct NullSafetyDemoValue;
struct RendererValue;
struct CircleRendererValue;
template<typename TInput, typename TOutput> struct PipelineValue;
struct BitFlagsValue;
struct TimestampedMixin;
struct TaggedMixin;
struct EventValue;
struct ImportantEventValue;
struct Priority;
bool Priority_isHigherThan(Priority* this__, Priority* other);
std::string Priority_toString(Priority* this__);
struct HttpMethod;
bool HttpMethod_get_isReadOnly(HttpMethod* this__);
std::string Printable_displayName(PrintableMixin* this__);
void Printable_printInfo(PrintableMixin* this__);
template<typename T> int64_t Orderable_compareTo(OrderableMixin<T>* this__, T other);
template<typename T> bool Orderable_isLessThan(OrderableMixin<T>* this__, T other);
template<typename T> bool Orderable_isGreaterThan(OrderableMixin<T>* this__, T other);
std::string Loggable_logTag(LoggableMixin* this__);
void Loggable_log_(LoggableMixin* this__, std::string message);
bool Validatable_validate(ValidatableMixin* this__);
int64_t Timestamped_timestamp(TimestampedMixin* this__);
std::string Timestamped_timeStr(TimestampedMixin* this__);
void Tagged_addTag(TaggedMixin* this__, std::string tag);
StaticList<std::string>* Tagged_tags(TaggedMixin* this__);
AnimalValue* Animal_new(AnimalValue* this__, std::string name, int64_t age);
std::string Animal_speak(AnimalValue* this__);
std::string Animal_toString(AnimalValue* this__);
DogValue* Dog_new(DogValue* this__, std::string name, int64_t age, std::string breed);
std::string Dog_get_displayName(DogValue* this__);
std::string Dog_speak(DogValue* this__);
int64_t Dog_compareTo(DogValue* this__, DogValue* other);
CatValue* Cat_new(CatValue* this__, std::string name, int64_t age);
std::string Cat_get_displayName(CatValue* this__);
std::string Cat_speak(CatValue* this__);
std::string Cat_get_mood(CatValue* this__);
void Cat_set_mood(CatValue* this__, std::string value);
Vector2DValue* Vector2D_new(Vector2DValue* this__, double x, double y);
Vector2DValue* Vector2D_add(Vector2DValue* this__, Vector2DValue* other);
Vector2DValue* Vector2D_sub(Vector2DValue* this__, Vector2DValue* other);
Vector2DValue* Vector2D_mul(Vector2DValue* this__, double scalar);
bool Vector2D_eq(Vector2DValue* this__, AnyGC* other);
double Vector2D_get_length(Vector2DValue* this__);
double Vector2D__sqrt(double v);
std::string Vector2D_toString(Vector2DValue* this__);
CounterValue* Counter_new__(CounterValue* this__, std::string label, int64_t _value);
CounterValue* Counter_new(std::string label, int64_t initialValue = 0);
CounterValue* Counter_new_fromString(std::string spec);
int64_t Counter_get_instanceCount();
void Counter_increment(CounterValue* this__, int64_t step);
void Counter_decrement(CounterValue* this__, int64_t step);
int64_t Counter_get_value(CounterValue* this__);
std::string Counter_toString(CounterValue* this__);
template<typename T> ResultValue<T>* Result_new_success(ResultValue<T>* this__, T value);
template<typename T> ResultValue<T>* Result_new_failure(ResultValue<T>* this__, std::string message);
template<typename T, typename R> R Result_fold(ResultValue<T>* this__, TypeFunction1<R, T>* onSuccess, TypeFunction1<R, std::string>* onFailure);
template<typename T> std::string Result_toString(ResultValue<T>* this__);
LazyLoaderValue* LazyLoader_new(LazyLoaderValue* this__);
void LazyLoader_initialize(LazyLoaderValue* this__, std::string data);
std::string LazyLoader_get_data(LazyLoaderValue* this__);
int64_t LazyLoader_get_computedValue(LazyLoaderValue* this__);
BoundedValueValue* BoundedValue_new(BoundedValueValue* this__, double min, double max, double initial);
void BoundedValue_set(BoundedValueValue* this__, double value);
double BoundedValue_get_current(BoundedValueValue* this__);
ShapeValue* Shape_new(ShapeValue* this__, std::string color, double opacity = 1.0);
ShapeValue* Shape_new_transparent(ShapeValue* this__, std::string color);
std::string Shape_describe(ShapeValue* this__);
PolygonValue* Polygon_new(PolygonValue* this__, std::string color, int64_t sides, double opacity = 1.0);
std::string Polygon_describe(PolygonValue* this__);
double Polygon_perimeter(PolygonValue* this__, double sideLength);
RegularPolygonValue* RegularPolygon_new(RegularPolygonValue* this__, std::string color, int64_t sides, double sideLength, double opacity = 1.0);
std::string RegularPolygon_describe(RegularPolygonValue* this__);
double RegularPolygon_perimeter(RegularPolygonValue* this__, double overrideSideLength);
double RegularPolygon_area(RegularPolygonValue* this__);
SquareValue* Square_new(SquareValue* this__, std::string color, double size, double opacity = 1.0);
std::string Square_describe(SquareValue* this__);
SerializableValue* Serializable_new(SerializableValue* this__);
std::string Serializable_serialize(SerializableValue* this__);
template<typename T> CloneableValue<T>* Cloneable_new(CloneableValue<T>* this__);
template<typename T> T Cloneable_clone(CloneableValue<T>* this__);
template<typename T> Comparable2Value<T>* Comparable2_new(Comparable2Value<T>* this__);
template<typename T> int64_t Comparable2_compareTo2(Comparable2Value<T>* this__, T other);
DataPointValue* DataPoint_new(DataPointValue* this__, double x, double y, std::string label);
std::string DataPoint_serialize(DataPointValue* this__);
DataPointValue* DataPoint_clone(DataPointValue* this__);
int64_t DataPoint_compareTo2(DataPointValue* this__, DataPointValue* other);
std::string DataPoint_toString(DataPointValue* this__);
LoggedDataPointValue* LoggedDataPoint_new(LoggedDataPointValue* this__, double x, double y, std::string label);
std::string LoggedDataPoint_get_logTag(LoggedDataPointValue* this__);
ConfigValue* Config_new(ConfigValue* this__, std::string host, int64_t port, bool secure = false);
ConfigValue* Config_new_localhost(ConfigValue* this__, int64_t port = 8080);
ConfigValue* Config_new_production(ConfigValue* this__, std::string host);
std::string Config_toString(ConfigValue* this__);
template<typename T> SortedListValue<T>* SortedList_new(SortedListValue<T>* this__);
template<typename T> void SortedList_add(SortedListValue<T>* this__, T item);
template<typename T> T SortedList_get_first(SortedListValue<T>* this__);
template<typename T> T SortedList_get_last(SortedListValue<T>* this__);
template<typename T> int64_t SortedList_get_length(SortedListValue<T>* this__);
template<typename T> StaticList<T>* SortedList_toList(SortedListValue<T>* this__);
template<typename T> std::string SortedList_toString(SortedListValue<T>* this__);
NullSafetyDemoValue* NullSafetyDemo_new(NullSafetyDemoValue* this__, std::string nonNullField, std::string nullableField = "");
std::string NullSafetyDemo_demonstrate(NullSafetyDemoValue* this__);
RendererValue* Renderer_new(RendererValue* this__);
void Renderer_render(RendererValue* this__, AnyGC* shape);
std::string Renderer_get_name(RendererValue* this__);
CircleRendererValue* CircleRenderer_new(CircleRendererValue* this__);
void CircleRenderer_render(CircleRendererValue* this__, std::string shape);
std::string CircleRenderer_get_name(CircleRendererValue* this__);
template<typename TInput, typename TOutput> PipelineValue<TInput, TOutput>* Pipeline_new(PipelineValue<TInput, TOutput>* this__, TypeFunction1<TOutput, TInput>* _transform);
template<typename TInput, typename TOutput> TOutput Pipeline_execute(PipelineValue<TInput, TOutput>* this__, TInput input);
template<typename TInput, typename TOutput, typename TNewOutput> PipelineValue<TInput, TNewOutput>* Pipeline_then(PipelineValue<TInput, TOutput>* this__, TypeFunction1<TNewOutput, TOutput>* next);
BitFlagsValue* BitFlags_new(BitFlagsValue* this__, int64_t _flags = 0);
void BitFlags_set(BitFlagsValue* this__, int64_t flag);
void BitFlags_clear(BitFlagsValue* this__, int64_t flag);
bool BitFlags_has(BitFlagsValue* this__, int64_t flag);
std::string BitFlags_toString(BitFlagsValue* this__);
EventValue* Event_new(EventValue* this__, std::string name);
std::string Event_toString(EventValue* this__);
ImportantEventValue* ImportantEvent_new(ImportantEventValue* this__, std::string name, Priority* priority);
std::string ImportantEvent_get_logTag(ImportantEventValue* this__);
std::string ImportantEvent_toString(ImportantEventValue* this__);
std::string formatMessage(std::string template_, std::string subject, int64_t count);
std::string buildQuery(std::string endpoint, StaticMap<std::string, std::string>* params, int64_t maxWait, bool secure);
StaticList<int64_t>* range(int64_t start, int64_t end, int64_t step);
StaticList<int64_t>* fibonacci(int64_t count);
Promise<StaticList<std::string>*>* countDown(int64_t from);
AnyGC* getPersonRecord();
AnyGC* getLocation();
AnyGC* divmod(int64_t a, int64_t b);
std::string describeValue(AnyGC* value);
StaticList<int64_t>* buildList();
StaticStringBuffer* buildBuffer();
StaticList<int64_t>* mergeAndFilter(StaticList<int64_t>* a, StaticList<int64_t>* b, bool includeNegative);
StaticMap<std::string, int64_t>* buildScoreMap(StaticList<std::string>* names, bool addBonus);
int64_t parseAndDivide(std::string a, std::string b);
std::string multiLineExample();
template<typename A, typename B, typename C> TypeFunction1<C, A>* compose(TypeFunction1<B, A>* f, TypeFunction1<C, B>* g);
template<typename T> TypeFunction1<bool, T>* and_(TypeFunction1<bool, T>* p1, TypeFunction1<bool, T>* p2);
template<typename A, typename B> StaticList<B>* flatMap(StaticList<A>* list, TypeFunction1<StaticList<B>*, A>* f);
template<typename T> T findMax(StaticList<T>* items);
template<typename T, typename R> R applyTwice(T value, TypeFunction1<R, T>* fn1, TypeFunction1<R, R>* fn2);
std::string findFirst(StaticList<std::string>* items, TypeFunction1<bool, std::string>* test);
StaticList<int64_t>* filterWithForIn(StaticList<int64_t>* items);
int64_t collatzSteps(int64_t n);
std::string typeTest(AnyGC* value);
double safeCast(AnyGC* value);
std::string tryCatchFinally(int64_t code);
std::string dayType(int64_t day);
int main();
void Dog_Animal_Printable_printInfo(DogValue* this__);
AnyGC* Dog_Animal_Printable_Orderable_isLessThan(DogValue* this__, DogValue* other);
AnyGC* Dog_Animal_Printable_Orderable_isGreaterThan(DogValue* this__, DogValue* other);
void Cat_Animal_Printable_printInfo(CatValue* this__);
void LoggedDataPoint_log_(LoggedDataPointValue* this__, std::string message);
AnyGC* LoggedDataPoint_DataPoint_Loggable_Validatable_validate(LoggedDataPointValue* this__);
AnyGC* Event_Object_Timestamped_get_timestamp(EventValue* this__);
AnyGC* Event_Object_Timestamped_get_timeStr(EventValue* this__);
void Event_Object_Timestamped_Tagged_addTag(EventValue* this__, std::string tag);
AnyGC* Event_Object_Timestamped_Tagged_get_tags(EventValue* this__);
void ImportantEvent_log_(ImportantEventValue* this__, std::string message);
std::string formatMessage(std::string template_, std::string subject = "", int64_t count = 0);
std::string buildQuery(std::string endpoint, StaticMap<std::string, std::string>* params = nullptr, int64_t maxWait = 30, bool secure = true);
StaticList<int64_t>* range(int64_t start, int64_t end, int64_t step = 1);
AnyGC* Dog_toString(DogValue* this__);
void Dog_printInfo(DogValue* this__);
AnyGC* Dog_isLessThan(DogValue* this__, DogValue* other);
AnyGC* Dog_isGreaterThan(DogValue* this__, DogValue* other);
AnyGC* Cat_toString(CatValue* this__);
void Cat_printInfo(CatValue* this__);
AnyGC* Square_perimeter(SquareValue* this__, double overrideSideLength);
AnyGC* Square_area(SquareValue* this__);
AnyGC* LoggedDataPoint_serialize(LoggedDataPointValue* this__);
AnyGC* LoggedDataPoint_clone(LoggedDataPointValue* this__);
AnyGC* LoggedDataPoint_compareTo2(LoggedDataPointValue* this__, DataPointValue* other);
AnyGC* LoggedDataPoint_toString(LoggedDataPointValue* this__);
AnyGC* LoggedDataPoint_validate(LoggedDataPointValue* this__);
AnyGC* Event_get_timestamp(EventValue* this__);
AnyGC* Event_get_timeStr(EventValue* this__);
void Event_addTag(EventValue* this__, std::string tag);
AnyGC* Event_get_tags(EventValue* this__);
AnyGC* ImportantEvent_get_timestamp(ImportantEventValue* this__);
AnyGC* ImportantEvent_get_timeStr(ImportantEventValue* this__);
void ImportantEvent_addTag(ImportantEventValue* this__, std::string tag);
AnyGC* ImportantEvent_get_tags(ImportantEventValue* this__);

struct Priority : VPtr {
    std::string _name;
    int64_t _index;
    int64_t level{0};
    std::string displayName{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    static Priority* low;
    static Priority* medium;
    static Priority* high;
    static Priority* critical;
    static Priority* values;

    Priority(std::string n, int64_t i, int64_t level, std::string displayName) : _name(std::move(n)), _index(i), level(level), displayName(displayName) {}

    std::string toString() const override {
        auto& _vm = const_cast<Priority*>(this)->getVptrMap();
        auto _it = _vm.find("toString");
        if (_it != _vm.end()) {
            return dynAs<std::string>(reinterpret_cast<AnyGC*(*)(AnyGC*)>(_it->second)(const_cast<Priority*>(this)));
        }
        return "Priority." + _name;
    }
};

std::unordered_map<std::string, void*> Priority::_vptrMap;

Priority* Priority::low = new Priority("low", 0, 1, std::string("Low"));
Priority* Priority::medium = new Priority("medium", 1, 5, std::string("Medium"));
Priority* Priority::high = new Priority("high", 2, 10, std::string("High"));
Priority* Priority::critical = new Priority("critical", 3, 100, std::string("Critical"));
Priority* Priority::values = new Priority("values", 4, 0, "");

struct HttpMethod : VPtr {
    std::string _name;
    int64_t _index;
    std::string value{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    static HttpMethod* get;
    static HttpMethod* post;
    static HttpMethod* put;
    static HttpMethod* delete_;
    static HttpMethod* values;

    HttpMethod(std::string n, int64_t i, std::string value) : _name(std::move(n)), _index(i), value(value) {}

    std::string toString() const override {
        auto& _vm = const_cast<HttpMethod*>(this)->getVptrMap();
        auto _it = _vm.find("toString");
        if (_it != _vm.end()) {
            return dynAs<std::string>(reinterpret_cast<AnyGC*(*)(AnyGC*)>(_it->second)(const_cast<HttpMethod*>(this)));
        }
        return "HttpMethod." + _name;
    }
};

std::unordered_map<std::string, void*> HttpMethod::_vptrMap;

HttpMethod* HttpMethod::get = new HttpMethod("get", 0, std::string("GET"));
HttpMethod* HttpMethod::post = new HttpMethod("post", 1, std::string("POST"));
HttpMethod* HttpMethod::put = new HttpMethod("put", 2, std::string("PUT"));
HttpMethod* HttpMethod::delete_ = new HttpMethod("delete_", 3, std::string("DELETE"));
HttpMethod* HttpMethod::values = new HttpMethod("values", 4, "");

struct PrintableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> PrintableMixin::_vptrMap;


template<typename T>
struct OrderableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
template<typename T> std::unordered_map<std::string, void*> OrderableMixin<T>::_vptrMap;


struct LoggableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> LoggableMixin::_vptrMap;


struct ValidatableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> ValidatableMixin::_vptrMap;


struct TimestampedMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> TimestampedMixin::_vptrMap;


struct TaggedMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
    StaticList<std::string>* _tags{nullptr};
};
std::unordered_map<std::string, void*> TaggedMixin::_vptrMap;


struct AnimalValue : VPtr {
    std::string name{""};
    int64_t age{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> AnimalValue::_vptrMap;

struct DogValue : AnimalValue {
    std::string breed{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AnimalValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DogValue::_vptrMap;

struct CatValue : AnimalValue {
    std::string _mood{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AnimalValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CatValue::_vptrMap;

struct Vector2DValue : VPtr {
    double x{0.0};
    double y{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> Vector2DValue::_vptrMap;

struct CounterValue : VPtr {
    int64_t _value{0};
    std::string label{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CounterValue::_vptrMap;

template<typename T>
struct ResultValue : VPtr {
    T data{};
    std::string error{""};
    bool isSuccess{false};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> ResultValue<T>::_vptrMap;

struct LazyLoaderValue : VPtr {
    std::string _data{""};
    int64_t _computedValue{0};
    bool _initialized{false};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> LazyLoaderValue::_vptrMap;

struct BoundedValueValue : VPtr {
    double min{0.0};
    double max{0.0};
    double _current{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> BoundedValueValue::_vptrMap;

struct ShapeValue : VPtr {
    std::string color{""};
    double opacity{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ShapeValue::_vptrMap;

struct PolygonValue : ShapeValue {
    int64_t sides{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ShapeValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> PolygonValue::_vptrMap;

struct RegularPolygonValue : PolygonValue {
    double sideLength{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        PolygonValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> RegularPolygonValue::_vptrMap;

struct SquareValue : RegularPolygonValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        RegularPolygonValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> SquareValue::_vptrMap;

struct SerializableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> SerializableValue::_vptrMap;

template<typename T>
struct CloneableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> CloneableValue<T>::_vptrMap;

template<typename T>
struct Comparable2Value : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> Comparable2Value<T>::_vptrMap;

struct DataPointValue : SerializableValue {
    double x{0.0};
    double y{0.0};
    std::string label{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        SerializableValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DataPointValue::_vptrMap;

struct LoggedDataPointValue : DataPointValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        DataPointValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> LoggedDataPointValue::_vptrMap;

struct ConfigValue : VPtr {
    std::string host{""};
    int64_t port{0};
    bool secure{false};
    std::string baseUrl{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ConfigValue::_vptrMap;

template<typename T>
struct SortedListValue : VPtr {
    StaticList<T>* _items{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_items) _items->gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> SortedListValue<T>::_vptrMap;

struct NullSafetyDemoValue : VPtr {
    std::string nullableField{""};
    std::string nonNullField{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> NullSafetyDemoValue::_vptrMap;

struct RendererValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> RendererValue::_vptrMap;

struct CircleRendererValue : RendererValue {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        RendererValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CircleRendererValue::_vptrMap;

template<typename TInput, typename TOutput>
struct PipelineValue : VPtr {
    TypeFunction1<TOutput, TInput>* _transform{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_transform) _transform->gcMark(flag);
    }
};

template<typename TInput, typename TOutput> std::unordered_map<std::string, void*> PipelineValue<TInput, TOutput>::_vptrMap;

template<typename TInput, typename TOutput, typename TNewOutput>
struct ClosureEnv_0 : TypeFunction1<TNewOutput, TInput> {
    PipelineValue<TInput, TOutput>* this_;
    TypeFunction1<TNewOutput, TOutput>* next;
    ClosureEnv_0(PipelineValue<TInput, TOutput>* this_, TypeFunction1<TNewOutput, TOutput>* next) : this_(this_), next(std::move(next)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<TInput>(_p0)));
    }
    TNewOutput call(TInput input) {
    return next->call(([&]() { TInput _let6 = input; return this_->_transform->call(_let6); })());
    }
};

struct BitFlagsValue : VPtr {
    int64_t _flags{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> BitFlagsValue::_vptrMap;

struct EventValue : VPtr {
    std::string name{""};
    StaticList<std::string>* _tags{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_tags) _tags->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> EventValue::_vptrMap;

struct ImportantEventValue : EventValue {
    Priority* priority{nullptr};
    StaticList<std::string>* _tags{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        EventValue::gcMark(flag);
        if (priority) priority->gcMark(flag);
        if (_tags) _tags->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ImportantEventValue::_vptrMap;

struct ClosureEnv_1 : TypeFunction1<std::string, StaticMapEntry<std::string, std::string>> {
    ClosureEnv_1() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(*reinterpret_cast<StaticMapEntry<std::string, std::string>*>(dynamic_cast<VPtr*>(_p0))));
    }
    std::string call(StaticMapEntry<std::string, std::string> e) {
    return dart_str(e.key) + dart_str(std::string("=")) + dart_str(e.value);
    }
};

template<typename C, typename B, typename A>
struct ClosureEnv_2 : TypeFunction1<C, A> {
    TypeFunction1<C, B>* g;
    TypeFunction1<B, A>* f;
    ClosureEnv_2(TypeFunction1<C, B>* g, TypeFunction1<B, A>* f) : g(std::move(g)), f(std::move(f)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<A>(_p0)));
    }
    C call(A input) {
    return g->call(f->call(input));
    }
};

template<typename T>
struct ClosureEnv_3 : TypeFunction1<bool, T> {
    TypeFunction1<bool, T>* p1;
    TypeFunction1<bool, T>* p2;
    ClosureEnv_3(TypeFunction1<bool, T>* p1, TypeFunction1<bool, T>* p2) : p1(std::move(p1)), p2(std::move(p2)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_3*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<T>(_p0)));
    }
    bool call(T value) {
    return (p1->call(value) && p2->call(value));
    }
};

struct ClosureEnv_4 : TypeFunction1<std::string, int64_t> {
    ClosureEnv_4() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_4*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    std::string call(int64_t d) {
    return dart_str(std::string("got ")) + dart_str(d);
    }
};

struct ClosureEnv_5 : TypeFunction1<std::string, std::string> {
    ClosureEnv_5() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_5*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    std::string call(std::string e) {
    return dart_str(std::string("error: ")) + dart_str(e);
    }
};

struct ClosureEnv_6 : TypeFunction1<std::string, int64_t> {
    ClosureEnv_6() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_6*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    std::string call(int64_t d) {
    return dart_str(std::string("got ")) + dart_str(d);
    }
};

struct ClosureEnv_7 : TypeFunction1<std::string, std::string> {
    ClosureEnv_7() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_7*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    std::string call(std::string e) {
    return dart_str(std::string("error: ")) + dart_str(e);
    }
};

struct ClosureEnv_8 : TypeFunction1<int64_t, int64_t> {
    ClosureEnv_8() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_8*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t x) {
    return (x * 2LL);
    }
};

struct ClosureEnv_9 : TypeFunction1<std::string, int64_t> {
    ClosureEnv_9() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_9*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    std::string call(int64_t x) {
    return dart_str(std::string("result=")) + dart_str(x);
    }
};

struct ClosureEnv_10 : TypeFunction1<bool, int64_t> {
    ClosureEnv_10() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_10*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    bool call(int64_t n) {
    return (n > 0LL);
    }
};

struct ClosureEnv_11 : TypeFunction1<bool, int64_t> {
    ClosureEnv_11() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_11*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    bool call(int64_t n) {
    return ((n % 2LL) == 0LL);
    }
};

struct ClosureEnv_12 : TypeFunction1<StaticList<int64_t>*, int64_t> {
    ClosureEnv_12() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_12*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    StaticList<int64_t>* call(int64_t x) {
    return GC::allocateLocal(new StaticList<int64_t>({x, (x * x)}));
    }
};

struct ClosureEnv_13 : TypeFunction1<bool, std::string> {
    ClosureEnv_13() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_13*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    bool call(std::string s) {
    return (s.find(std::string("b")) == 0);
    }
};

struct ClosureEnv_14 : TypeFunction1<bool, std::string> {
    ClosureEnv_14() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_14*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    bool call(std::string s) {
    return (s.find(std::string("z")) == 0);
    }
};


bool Priority_isHigherThan(Priority* this__, Priority* other) {
    auto this_ = this__;
    return (this_->level > other->level);
}

AnyGC* _vptr_wrap_Priority_isHigherThan(AnyGC* obj__, AnyGC* arg0) {
    return _box(Priority_isHigherThan(static_cast<Priority*>(obj__), static_cast<Priority*>(arg0)));
}

static bool _Priority_isHigherThan_registered = []{ Priority::_vptrMap["isHigherThan"] = reinterpret_cast<void*>(&_vptr_wrap_Priority_isHigherThan); return true; }();
std::string Priority_toString(Priority* this__) {
    auto this_ = this__;
    return dart_str(this_->displayName) + dart_str(std::string("(level=")) + dart_str(this_->level) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Priority_toString(AnyGC* obj__) {
    return _box(Priority_toString(static_cast<Priority*>(obj__)));
}

static bool _Priority_toString_registered = []{ Priority::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Priority_toString); return true; }();
bool HttpMethod_get_isReadOnly(HttpMethod* this__) {
    auto this_ = this__;
    return (this_ == HttpMethod::get);
}

AnyGC* _vptr_wrap_HttpMethod_get_isReadOnly(AnyGC* obj__) {
    return _box(HttpMethod_get_isReadOnly(static_cast<HttpMethod*>(obj__)));
}

static bool _HttpMethod_isReadOnly_registered = []{ HttpMethod::_vptrMap["get_isReadOnly"] = reinterpret_cast<void*>(&_vptr_wrap_HttpMethod_get_isReadOnly); return true; }();
std::string Printable_displayName(PrintableMixin* this__) {
    auto this_ = this__;
    return "";
}

void Printable_printInfo(PrintableMixin* this__) {
    auto this_ = this__;
    staticPrint(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_displayName"]))(this_))) + dart_str(std::string("]")));
    return;
}

template<typename T>
int64_t Orderable_compareTo(OrderableMixin<T>* this__, T other) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Orderable.compareTo")));
}

template<typename T>
bool Orderable_isLessThan(OrderableMixin<T>* this__, T other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo"]))(this_, _box(other))) < 0LL);
}

template<typename T>
bool Orderable_isGreaterThan(OrderableMixin<T>* this__, T other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo"]))(this_, _box(other))) > 0LL);
}

std::string Loggable_logTag(LoggableMixin* this__) {
    auto this_ = this__;
    return "";
}

void Loggable_log_(LoggableMixin* this__, std::string message) {
    auto this_ = this__;
    staticPrint(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_logTag"]))(this_))) + dart_str(std::string("] ")) + dart_str(message));
    return;
}

bool Validatable_validate(ValidatableMixin* this__) {
    auto this_ = this__;
    return !dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["serialize"]))(this_)).empty();
}

int64_t Timestamped_timestamp(TimestampedMixin* this__) {
    auto this_ = this__;
    return 1234567890LL;
}

std::string Timestamped_timeStr(TimestampedMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("T:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_timestamp"]))(this_)));
}

void Tagged_addTag(TaggedMixin* this__, std::string tag) {
    auto this_ = this__;
    this_->_tags->add(tag);
    return;
}

StaticList<std::string>* Tagged_tags(TaggedMixin* this__) {
    auto this_ = this__;
    return unmodifiable<std::string>(this_->_tags);
}

AnyGC* _vptr_wrap_Animal_speak(AnyGC* obj__) {
    return _box(Animal_speak(static_cast<AnimalValue*>(obj__)));
}

AnyGC* _vptr_wrap_Animal_toString(AnyGC* obj__) {
    return _box(Animal_toString(static_cast<AnimalValue*>(obj__)));
}

static bool _Animal_vptr_registered = []{ AnimalValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Animal_speak); AnimalValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Animal_toString); return true; }();
AnimalValue* Animal_new(AnimalValue* this__, std::string name, int64_t age) {
    auto this_ = this__;
    if (AnimalValue::_vptrMap.empty()) {
        AnimalValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Animal_speak);
        AnimalValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Animal_toString);
    }
    this_->name = name;
    this_->age = age;
    return this_;
}

std::string Animal_speak(AnimalValue* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Animal.speak")));
}

std::string Animal_toString(AnimalValue* this__) {
    auto this_ = this__;
    return dart_str(this_->name) + dart_str(std::string("(age=")) + dart_str(this_->age) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Dog_speak(AnyGC* obj__) {
    return _box(Dog_speak(static_cast<DogValue*>(obj__)));
}

AnyGC* _vptr_wrap_Dog_toString(AnyGC* obj__) {
    return _box(Dog_toString(static_cast<DogValue*>(obj__)));
}

AnyGC* _vptr_wrap_Dog_get_displayName(AnyGC* obj__) {
    return _box(Dog_get_displayName(static_cast<DogValue*>(obj__)));
}

AnyGC* _vptr_wrap_Dog_printInfo(AnyGC* obj__) {
    Dog_printInfo(static_cast<DogValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Dog_compareTo(AnyGC* obj__, AnyGC* arg0) {
    return _box(Dog_compareTo(static_cast<DogValue*>(obj__), static_cast<DogValue*>(arg0)));
}

AnyGC* _vptr_wrap_Dog_isLessThan(AnyGC* obj__, AnyGC* arg0) {
    return _box(Dog_isLessThan(static_cast<DogValue*>(obj__), static_cast<DogValue*>(arg0)));
}

AnyGC* _vptr_wrap_Dog_isGreaterThan(AnyGC* obj__, AnyGC* arg0) {
    return _box(Dog_isGreaterThan(static_cast<DogValue*>(obj__), static_cast<DogValue*>(arg0)));
}

static bool _Dog_vptr_registered = []{ DogValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_speak); DogValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_toString); DogValue::_vptrMap["get_displayName"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_get_displayName); DogValue::_vptrMap["printInfo"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_printInfo); DogValue::_vptrMap["compareTo"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_compareTo); DogValue::_vptrMap["isLessThan"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_isLessThan); DogValue::_vptrMap["isGreaterThan"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_isGreaterThan); return true; }();
DogValue* Dog_new(DogValue* this__, std::string name, int64_t age, std::string breed) {
    auto this_ = this__;
    if (DogValue::_vptrMap.empty()) {
        DogValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_speak);
        DogValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_toString);
        DogValue::_vptrMap["get_displayName"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_get_displayName);
        DogValue::_vptrMap["printInfo"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_printInfo);
        DogValue::_vptrMap["compareTo"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_compareTo);
        DogValue::_vptrMap["isLessThan"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_isLessThan);
        DogValue::_vptrMap["isGreaterThan"] = reinterpret_cast<void*>(&_vptr_wrap_Dog_isGreaterThan);
    }
    this_->breed = breed;
    Animal_new(this_, name, age);
    return this_;
}

std::string Dog_get_displayName(DogValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Dog:")) + dart_str(this_->name);
}

std::string Dog_speak(DogValue* this__) {
    auto this_ = this__;
    return std::string("Woof!");
}

int64_t Dog_compareTo(DogValue* this__, DogValue* other) {
    auto this_ = this__;
    return ((this_->age) > static_cast<int64_t>(static_cast<AnimalValue*>(other)->age) ? 1LL : ((this_->age) < static_cast<int64_t>(static_cast<AnimalValue*>(other)->age) ? -1LL : 0LL));
}

AnyGC* _vptr_wrap_Cat_speak(AnyGC* obj__) {
    return _box(Cat_speak(static_cast<CatValue*>(obj__)));
}

AnyGC* _vptr_wrap_Cat_toString(AnyGC* obj__) {
    return _box(Cat_toString(static_cast<CatValue*>(obj__)));
}

AnyGC* _vptr_wrap_Cat_get_displayName(AnyGC* obj__) {
    return _box(Cat_get_displayName(static_cast<CatValue*>(obj__)));
}

AnyGC* _vptr_wrap_Cat_printInfo(AnyGC* obj__) {
    Cat_printInfo(static_cast<CatValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Cat_get_mood(AnyGC* obj__) {
    return _box(Cat_get_mood(static_cast<CatValue*>(obj__)));
}

AnyGC* _vptr_wrap_Cat_set_mood(AnyGC* obj__, AnyGC* arg0) {
    Cat_set_mood(static_cast<CatValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

static bool _Cat_vptr_registered = []{ CatValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_speak); CatValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_toString); CatValue::_vptrMap["get_displayName"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_get_displayName); CatValue::_vptrMap["printInfo"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_printInfo); CatValue::_vptrMap["get_mood"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_get_mood); CatValue::_vptrMap["set_mood"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_set_mood); return true; }();
CatValue* Cat_new(CatValue* this__, std::string name, int64_t age) {
    auto this_ = this__;
    if (CatValue::_vptrMap.empty()) {
        CatValue::_vptrMap["speak"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_speak);
        CatValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_toString);
        CatValue::_vptrMap["get_displayName"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_get_displayName);
        CatValue::_vptrMap["printInfo"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_printInfo);
        CatValue::_vptrMap["get_mood"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_get_mood);
        CatValue::_vptrMap["set_mood"] = reinterpret_cast<void*>(&_vptr_wrap_Cat_set_mood);
    }
    Animal_new(this_, name, age);
    (this_->_mood = std::string("happy"));
    return this_;
}

std::string Cat_get_displayName(CatValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Cat:")) + dart_str(this_->name);
}

std::string Cat_speak(CatValue* this__) {
    auto this_ = this__;
    return std::string("Meow!");
}

std::string Cat_get_mood(CatValue* this__) {
    auto this_ = this__;
    return this_->_mood;
}

void Cat_set_mood(CatValue* this__, std::string value) {
    auto this_ = this__;
    (this_->_mood = value);
    return;
}

AnyGC* _vptr_wrap_Vector2D_add(AnyGC* obj__, AnyGC* arg0) {
    return _box(Vector2D_add(static_cast<Vector2DValue*>(obj__), static_cast<Vector2DValue*>(arg0)));
}

AnyGC* _vptr_wrap_Vector2D_sub(AnyGC* obj__, AnyGC* arg0) {
    return _box(Vector2D_sub(static_cast<Vector2DValue*>(obj__), static_cast<Vector2DValue*>(arg0)));
}

AnyGC* _vptr_wrap_Vector2D_mul(AnyGC* obj__, AnyGC* arg0) {
    return _box(Vector2D_mul(static_cast<Vector2DValue*>(obj__), dynAs<double>(arg0)));
}

AnyGC* _vptr_wrap_Vector2D_eq(AnyGC* obj__, AnyGC* arg0) {
    return _box(Vector2D_eq(static_cast<Vector2DValue*>(obj__), arg0));
}

AnyGC* _vptr_wrap_Vector2D_get_length(AnyGC* obj__) {
    return _box(Vector2D_get_length(static_cast<Vector2DValue*>(obj__)));
}

AnyGC* _vptr_wrap_Vector2D_toString(AnyGC* obj__) {
    return _box(Vector2D_toString(static_cast<Vector2DValue*>(obj__)));
}

static bool _Vector2D_vptr_registered = []{ Vector2DValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_add); Vector2DValue::_vptrMap["-"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_sub); Vector2DValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_mul); Vector2DValue::_vptrMap["=="] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_eq); Vector2DValue::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_get_length); Vector2DValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_toString); return true; }();
Vector2DValue* Vector2D_new(Vector2DValue* this__, double x, double y) {
    auto this_ = this__;
    if (Vector2DValue::_vptrMap.empty()) {
        Vector2DValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_add);
        Vector2DValue::_vptrMap["-"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_sub);
        Vector2DValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_mul);
        Vector2DValue::_vptrMap["=="] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_eq);
        Vector2DValue::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_get_length);
        Vector2DValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_toString);
    }
    this_->x = x;
    this_->y = y;
    return this_;
}

Vector2DValue* Vector2D_add(Vector2DValue* this__, Vector2DValue* other) {
    auto this_ = this__;
    return Vector2D_new(GC::allocateLocal(new Vector2DValue()), (this_->x + other->x), (this_->y + other->y));
}

Vector2DValue* Vector2D_sub(Vector2DValue* this__, Vector2DValue* other) {
    auto this_ = this__;
    return Vector2D_new(GC::allocateLocal(new Vector2DValue()), (this_->x - other->x), (this_->y - other->y));
}

Vector2DValue* Vector2D_mul(Vector2DValue* this__, double scalar) {
    auto this_ = this__;
    return Vector2D_new(GC::allocateLocal(new Vector2DValue()), (this_->x * scalar), (this_->y * scalar));
}

bool Vector2D_eq(Vector2DValue* this__, AnyGC* other) {
    auto this_ = this__;
    return ((dart_is<Vector2DValue>(other) && (this_->x == static_cast<Vector2DValue*>(other)->x)) && (this_->y == static_cast<Vector2DValue*>(other)->y));
}

double Vector2D_get_length(Vector2DValue* this__) {
    auto this_ = this__;
    return ((((this_->x * this_->x) + (this_->y * this_->y)) < 0LL) ? 0.0 : Vector2D__sqrt(((this_->x * this_->x) + (this_->y * this_->y))));
}

double Vector2D__sqrt(double v) {
    if ((v <= 0LL)) {
        return 0.0;
    }
    double guess = (v / 2LL);
    int64_t i = 0LL;
    while ((i < 20LL)) {
        (guess = ((guess + (v / guess)) / 2LL));
        (i = (i + 1LL));
    }
    return guess;
}

std::string Vector2D_toString(Vector2DValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Vector2D(")) + dart_str(this_->x) + dart_str(std::string(", ")) + dart_str(this_->y) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Counter_increment(AnyGC* obj__, AnyGC* arg0) {
    Counter_increment(static_cast<CounterValue*>(obj__), dynAs<int64_t>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_Counter_decrement(AnyGC* obj__, AnyGC* arg0) {
    Counter_decrement(static_cast<CounterValue*>(obj__), dynAs<int64_t>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_Counter_get_value(AnyGC* obj__) {
    return _box(Counter_get_value(static_cast<CounterValue*>(obj__)));
}

AnyGC* _vptr_wrap_Counter_toString(AnyGC* obj__) {
    return _box(Counter_toString(static_cast<CounterValue*>(obj__)));
}

static bool _Counter_vptr_registered = []{ CounterValue::_vptrMap["increment"] = reinterpret_cast<void*>(&_vptr_wrap_Counter_increment); CounterValue::_vptrMap["decrement"] = reinterpret_cast<void*>(&_vptr_wrap_Counter_decrement); CounterValue::_vptrMap["get_value"] = reinterpret_cast<void*>(&_vptr_wrap_Counter_get_value); CounterValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Counter_toString); return true; }();
int64_t _instanceCount = 0LL;
CounterValue* Counter_new__(CounterValue* this__, std::string label, int64_t _value) {
    auto this_ = this__;
    this_->label = label;
    this_->_value = _value;
    _instanceCount = (_instanceCount + 1LL);
    return this_;
}

CounterValue* Counter_new(std::string label, int64_t initialValue) {
    return Counter_new__(GC::allocateLocal(new CounterValue()), label, initialValue);
}

CounterValue* Counter_new_fromString(std::string spec) {
    StaticList<std::string>* parts = dart_str_split(spec, std::string(":"));
    return Counter_new__(GC::allocateLocal(new CounterValue()), (*parts)[0LL], dart_stoll((*parts)[1LL]));
}

int64_t Counter_get_instanceCount() {
    return _instanceCount;
}

void Counter_increment(CounterValue* this__, int64_t step) {
    auto this_ = this__;
    (this_->_value = std::max(static_cast<int64_t>(0LL), std::min((this_->_value + step), static_cast<int64_t>(100))));
}

void Counter_decrement(CounterValue* this__, int64_t step) {
    auto this_ = this__;
    (this_->_value = std::max(static_cast<int64_t>(0LL), std::min((this_->_value - step), static_cast<int64_t>(100))));
}

int64_t Counter_get_value(CounterValue* this__) {
    auto this_ = this__;
    return this_->_value;
}

std::string Counter_toString(CounterValue* this__) {
    auto this_ = this__;
    return dart_str(this_->label) + dart_str(std::string(": ")) + dart_str(this_->_value);
}

template<typename T>
AnyGC* _vptr_wrap_Result_fold(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    _TypeFnAdapter1<T> _adapter0(static_cast<TypeFunction*>(arg0));
    _TypeFnAdapter1<std::string> _adapter1(static_cast<TypeFunction*>(arg1));
    return _box(Result_fold<T, AnyGC*>(static_cast<ResultValue<T>*>(obj__), &_adapter0, &_adapter1));
}

template<typename T>
AnyGC* _vptr_wrap_Result_toString(AnyGC* obj__) {
    return _box(Result_toString<T>(static_cast<ResultValue<T>*>(obj__)));
}

template<typename T> void _register_Result_vptr() {
    if (ResultValue<T>::_vptrMap.empty()) {
        ResultValue<T>::_vptrMap["fold"] = reinterpret_cast<void*>(&_vptr_wrap_Result_fold<T>);
        ResultValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Result_toString<T>);
    }
}
template<typename T>
ResultValue<T>* Result_new_success(ResultValue<T>* this__, T value) {
    auto this_ = this__;
    this_->data = value;
    this_->error = "";
    this_->isSuccess = true;
    return this_;
}

template<typename T>
ResultValue<T>* Result_new_failure(ResultValue<T>* this__, std::string message) {
    auto this_ = this__;
    this_->data = T{};
    this_->error = message;
    this_->isSuccess = false;
    return this_;
}

template<typename T, typename R>
R Result_fold(ResultValue<T>* this__, TypeFunction1<R, T>* onSuccess, TypeFunction1<R, std::string>* onFailure) {
    auto this_ = this__;
    if ((this_->isSuccess && !((dart_isNull(this_->data))))) {
        return onSuccess->call(([&]() { T _let0 = this_->data; return ((dart_isNull(_let0)) ? _let0 : _let0); })());
    }
    return onFailure->call((this_->error.empty() ? std::string("Unknown error") : this_->error));
}

template<typename T>
std::string Result_toString(ResultValue<T>* this__) {
    auto this_ = this__;
    return (this_->isSuccess ? dart_str(std::string("Result.success(")) + dart_str(this_->data) + dart_str(std::string(")")) : dart_str(std::string("Result.failure(")) + dart_str(this_->error) + dart_str(std::string(")")));
}

AnyGC* _vptr_wrap_LazyLoader_initialize(AnyGC* obj__, AnyGC* arg0) {
    LazyLoader_initialize(static_cast<LazyLoaderValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_LazyLoader_get_data(AnyGC* obj__) {
    return _box(LazyLoader_get_data(static_cast<LazyLoaderValue*>(obj__)));
}

AnyGC* _vptr_wrap_LazyLoader_get_computedValue(AnyGC* obj__) {
    return _box(LazyLoader_get_computedValue(static_cast<LazyLoaderValue*>(obj__)));
}

static bool _LazyLoader_vptr_registered = []{ LazyLoaderValue::_vptrMap["initialize"] = reinterpret_cast<void*>(&_vptr_wrap_LazyLoader_initialize); LazyLoaderValue::_vptrMap["get_data"] = reinterpret_cast<void*>(&_vptr_wrap_LazyLoader_get_data); LazyLoaderValue::_vptrMap["get_computedValue"] = reinterpret_cast<void*>(&_vptr_wrap_LazyLoader_get_computedValue); return true; }();
LazyLoaderValue* LazyLoader_new(LazyLoaderValue* this__) {
    auto this_ = this__;
    if (LazyLoaderValue::_vptrMap.empty()) {
        LazyLoaderValue::_vptrMap["initialize"] = reinterpret_cast<void*>(&_vptr_wrap_LazyLoader_initialize);
        LazyLoaderValue::_vptrMap["get_data"] = reinterpret_cast<void*>(&_vptr_wrap_LazyLoader_get_data);
        LazyLoaderValue::_vptrMap["get_computedValue"] = reinterpret_cast<void*>(&_vptr_wrap_LazyLoader_get_computedValue);
    }
    this_->_initialized = false;
    return this_;
}

void LazyLoader_initialize(LazyLoaderValue* this__, std::string data) {
    auto this_ = this__;
    (this_->_data = data);
    (this_->_computedValue = (static_cast<int64_t>(data.length()) * 2LL));
    (this_->_initialized = true);
}

std::string LazyLoader_get_data(LazyLoaderValue* this__) {
    auto this_ = this__;
    return (this_->_initialized ? this_->_data : std::string("not initialized"));
}

int64_t LazyLoader_get_computedValue(LazyLoaderValue* this__) {
    auto this_ = this__;
    return (this_->_initialized ? this_->_computedValue : (-1LL));
}

AnyGC* _vptr_wrap_BoundedValue_set(AnyGC* obj__, AnyGC* arg0) {
    BoundedValue_set(static_cast<BoundedValueValue*>(obj__), dynAs<double>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_BoundedValue_get_current(AnyGC* obj__) {
    return _box(BoundedValue_get_current(static_cast<BoundedValueValue*>(obj__)));
}

static bool _BoundedValue_vptr_registered = []{ BoundedValueValue::_vptrMap["set"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_set); BoundedValueValue::_vptrMap["get_current"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_get_current); return true; }();
BoundedValueValue* BoundedValue_new(BoundedValueValue* this__, double min, double max, double initial) {
    auto this_ = this__;
    if (BoundedValueValue::_vptrMap.empty()) {
        BoundedValueValue::_vptrMap["set"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_set);
        BoundedValueValue::_vptrMap["get_current"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_get_current);
    }
    this_->min = min;
    this_->max = max;
    this_->_current = initial;
    assert((this_->min <= this_->max));
    assert(((initial >= this_->min) && (initial <= this_->max)));
    return this_;
}

void BoundedValue_set(BoundedValueValue* this__, double value) {
    auto this_ = this__;
    assert(((value >= this_->min) && (value <= this_->max)));
    (this_->_current = value);
}

double BoundedValue_get_current(BoundedValueValue* this__) {
    auto this_ = this__;
    return this_->_current;
}

AnyGC* _vptr_wrap_Shape_describe(AnyGC* obj__) {
    return _box(Shape_describe(static_cast<ShapeValue*>(obj__)));
}

static bool _Shape_vptr_registered = []{ ShapeValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_describe); return true; }();
ShapeValue* Shape_new(ShapeValue* this__, std::string color, double opacity) {
    auto this_ = this__;
    if (ShapeValue::_vptrMap.empty()) {
        ShapeValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_describe);
    }
    this_->color = color;
    this_->opacity = opacity;
    return this_;
}

ShapeValue* Shape_new_transparent(ShapeValue* this__, std::string color) {
    auto this_ = this__;
    return this_;
}

std::string Shape_describe(ShapeValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Shape(color=")) + dart_str(this_->color) + dart_str(std::string(", opacity=")) + dart_str(this_->opacity) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Polygon_describe(AnyGC* obj__) {
    return _box(Polygon_describe(static_cast<PolygonValue*>(obj__)));
}

AnyGC* _vptr_wrap_Polygon_perimeter(AnyGC* obj__, AnyGC* arg0) {
    return _box(Polygon_perimeter(static_cast<PolygonValue*>(obj__), dynAs<double>(arg0)));
}

static bool _Polygon_vptr_registered = []{ PolygonValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Polygon_describe); PolygonValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Polygon_perimeter); return true; }();
PolygonValue* Polygon_new(PolygonValue* this__, std::string color, int64_t sides, double opacity) {
    auto this_ = this__;
    if (PolygonValue::_vptrMap.empty()) {
        PolygonValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Polygon_describe);
        PolygonValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Polygon_perimeter);
    }
    this_->sides = sides;
    Shape_new(this_, color);
    return this_;
}

std::string Polygon_describe(PolygonValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Polygon(sides=")) + dart_str(this_->sides) + dart_str(std::string(", ")) + dart_str(Shape_describe(this_)) + dart_str(std::string(")"));
}

double Polygon_perimeter(PolygonValue* this__, double sideLength) {
    auto this_ = this__;
    return (this_->sides * sideLength);
}

AnyGC* _vptr_wrap_RegularPolygon_describe(AnyGC* obj__) {
    return _box(RegularPolygon_describe(static_cast<RegularPolygonValue*>(obj__)));
}

AnyGC* _vptr_wrap_RegularPolygon_perimeter(AnyGC* obj__, AnyGC* arg0) {
    return _box(RegularPolygon_perimeter(static_cast<RegularPolygonValue*>(obj__), dynAs<double>(arg0)));
}

AnyGC* _vptr_wrap_RegularPolygon_area(AnyGC* obj__) {
    return _box(RegularPolygon_area(static_cast<RegularPolygonValue*>(obj__)));
}

static bool _RegularPolygon_vptr_registered = []{ RegularPolygonValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_RegularPolygon_describe); RegularPolygonValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_RegularPolygon_perimeter); RegularPolygonValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_RegularPolygon_area); return true; }();
RegularPolygonValue* RegularPolygon_new(RegularPolygonValue* this__, std::string color, int64_t sides, double sideLength, double opacity) {
    auto this_ = this__;
    if (RegularPolygonValue::_vptrMap.empty()) {
        RegularPolygonValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_RegularPolygon_describe);
        RegularPolygonValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_RegularPolygon_perimeter);
        RegularPolygonValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_RegularPolygon_area);
    }
    this_->sideLength = sideLength;
    Polygon_new(this_, color, sides);
    return this_;
}

std::string RegularPolygon_describe(RegularPolygonValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("RegularPolygon(sideLen=")) + dart_str(this_->sideLength) + dart_str(std::string(", ")) + dart_str(Polygon_describe(this_)) + dart_str(std::string(")"));
}

double RegularPolygon_perimeter(RegularPolygonValue* this__, double overrideSideLength) {
    auto this_ = this__;
    return (this_->sides * overrideSideLength);
}

double RegularPolygon_area(RegularPolygonValue* this__) {
    auto this_ = this__;
    return (static_cast<double>(((this_->sides * this_->sideLength) * this_->sideLength)) / static_cast<double>(4.0));
}

AnyGC* _vptr_wrap_Square_describe(AnyGC* obj__) {
    return _box(Square_describe(static_cast<SquareValue*>(obj__)));
}

AnyGC* _vptr_wrap_Square_perimeter(AnyGC* obj__, AnyGC* arg0) {
    return _box(Square_perimeter(static_cast<SquareValue*>(obj__), dynAs<double>(arg0)));
}

AnyGC* _vptr_wrap_Square_area(AnyGC* obj__) {
    return _box(Square_area(static_cast<SquareValue*>(obj__)));
}

static bool _Square_vptr_registered = []{ SquareValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Square_describe); SquareValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Square_perimeter); SquareValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Square_area); return true; }();
SquareValue* Square_new(SquareValue* this__, std::string color, double size, double opacity) {
    auto this_ = this__;
    if (SquareValue::_vptrMap.empty()) {
        SquareValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_Square_describe);
        SquareValue::_vptrMap["perimeter"] = reinterpret_cast<void*>(&_vptr_wrap_Square_perimeter);
        SquareValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Square_area);
    }
    RegularPolygon_new(this_, color, 4LL, size);
    return this_;
}

std::string Square_describe(SquareValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Square(size=")) + dart_str(this_->sideLength) + dart_str(std::string(", color=")) + dart_str(this_->color) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Serializable_serialize(AnyGC* obj__) {
    return _box(Serializable_serialize(static_cast<SerializableValue*>(obj__)));
}

static bool _Serializable_vptr_registered = []{ SerializableValue::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_Serializable_serialize); return true; }();
SerializableValue* Serializable_new(SerializableValue* this__) {
    auto this_ = this__;
    if (SerializableValue::_vptrMap.empty()) {
        SerializableValue::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_Serializable_serialize);
    }
    return this_;
}

std::string Serializable_serialize(SerializableValue* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Serializable.serialize")));
}

template<typename T>
AnyGC* _vptr_wrap_Cloneable_clone(AnyGC* obj__) {
    return _box(Cloneable_clone<T>(static_cast<CloneableValue<T>*>(obj__)));
}

template<typename T> void _register_Cloneable_vptr() {
    if (CloneableValue<T>::_vptrMap.empty()) {
        CloneableValue<T>::_vptrMap["clone"] = reinterpret_cast<void*>(&_vptr_wrap_Cloneable_clone<T>);
    }
}
template<typename T>
CloneableValue<T>* Cloneable_new(CloneableValue<T>* this__) {
    auto this_ = this__;
    if (CloneableValue<T>::_vptrMap.empty()) {
        CloneableValue<T>::_vptrMap["clone"] = reinterpret_cast<void*>(&_vptr_wrap_Cloneable_clone<T>);
    }
    return this_;
}

template<typename T>
T Cloneable_clone(CloneableValue<T>* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Cloneable.clone")));
}

template<typename T>
AnyGC* _vptr_wrap_Comparable2_compareTo2(AnyGC* obj__, AnyGC* arg0) {
    return _box(Comparable2_compareTo2<T>(static_cast<Comparable2Value<T>*>(obj__), dynAs<T>(arg0)));
}

template<typename T> void _register_Comparable2_vptr() {
    if (Comparable2Value<T>::_vptrMap.empty()) {
        Comparable2Value<T>::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_compareTo2<T>);
    }
}
template<typename T>
Comparable2Value<T>* Comparable2_new(Comparable2Value<T>* this__) {
    auto this_ = this__;
    if (Comparable2Value<T>::_vptrMap.empty()) {
        Comparable2Value<T>::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_compareTo2<T>);
    }
    return this_;
}

template<typename T>
int64_t Comparable2_compareTo2(Comparable2Value<T>* this__, T other) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Comparable2.compareTo2")));
}

AnyGC* _vptr_wrap_DataPoint_serialize(AnyGC* obj__) {
    return _box(DataPoint_serialize(static_cast<DataPointValue*>(obj__)));
}

AnyGC* _vptr_wrap_DataPoint_clone(AnyGC* obj__) {
    return _box(DataPoint_clone(static_cast<DataPointValue*>(obj__)));
}

AnyGC* _vptr_wrap_DataPoint_compareTo2(AnyGC* obj__, AnyGC* arg0) {
    return _box(DataPoint_compareTo2(static_cast<DataPointValue*>(obj__), static_cast<DataPointValue*>(arg0)));
}

AnyGC* _vptr_wrap_DataPoint_toString(AnyGC* obj__) {
    return _box(DataPoint_toString(static_cast<DataPointValue*>(obj__)));
}

static bool _DataPoint_vptr_registered = []{ DataPointValue::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_DataPoint_serialize); DataPointValue::_vptrMap["clone"] = reinterpret_cast<void*>(&_vptr_wrap_DataPoint_clone); DataPointValue::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_DataPoint_compareTo2); DataPointValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_DataPoint_toString); return true; }();
DataPointValue* DataPoint_new(DataPointValue* this__, double x, double y, std::string label) {
    auto this_ = this__;
    if (DataPointValue::_vptrMap.empty()) {
        DataPointValue::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_DataPoint_serialize);
        DataPointValue::_vptrMap["clone"] = reinterpret_cast<void*>(&_vptr_wrap_DataPoint_clone);
        DataPointValue::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_DataPoint_compareTo2);
        DataPointValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_DataPoint_toString);
    }
    this_->x = x;
    this_->y = y;
    this_->label = label;
    return this_;
}

std::string DataPoint_serialize(DataPointValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("{\"x\":")) + dart_str(this_->x) + dart_str(std::string(",\"y\":")) + dart_str(this_->y) + dart_str(std::string(",\"label\":\"")) + dart_str(this_->label) + dart_str(std::string("\"}"));
}

DataPointValue* DataPoint_clone(DataPointValue* this__) {
    auto this_ = this__;
    return DataPoint_new(GC::allocateLocal(new DataPointValue()), this_->x, this_->y, this_->label);
}

int64_t DataPoint_compareTo2(DataPointValue* this__, DataPointValue* other) {
    auto this_ = this__;
    double dx = (this_->x - other->x);
    if (!((dx == 0LL))) {
        return ((dx > 0LL) ? 1LL : (-1LL));
    }
    double dy = (this_->y - other->y);
    if (!((dy == 0LL))) {
        return ((dy > 0LL) ? 1LL : (-1LL));
    }
    return 0LL;
}

std::string DataPoint_toString(DataPointValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("DataPoint(")) + dart_str(this_->x) + dart_str(std::string(", ")) + dart_str(this_->y) + dart_str(std::string(", \"")) + dart_str(this_->label) + dart_str(std::string("\")"));
}

AnyGC* _vptr_wrap_LoggedDataPoint_serialize(AnyGC* obj__) {
    return _box(LoggedDataPoint_serialize(static_cast<LoggedDataPointValue*>(obj__)));
}

AnyGC* _vptr_wrap_LoggedDataPoint_clone(AnyGC* obj__) {
    return _box(LoggedDataPoint_clone(static_cast<LoggedDataPointValue*>(obj__)));
}

AnyGC* _vptr_wrap_LoggedDataPoint_compareTo2(AnyGC* obj__, AnyGC* arg0) {
    return _box(LoggedDataPoint_compareTo2(static_cast<LoggedDataPointValue*>(obj__), static_cast<DataPointValue*>(arg0)));
}

AnyGC* _vptr_wrap_LoggedDataPoint_toString(AnyGC* obj__) {
    return _box(LoggedDataPoint_toString(static_cast<LoggedDataPointValue*>(obj__)));
}

AnyGC* _vptr_wrap_LoggedDataPoint_get_logTag(AnyGC* obj__) {
    return _box(LoggedDataPoint_get_logTag(static_cast<LoggedDataPointValue*>(obj__)));
}

AnyGC* _vptr_wrap_LoggedDataPoint_log_(AnyGC* obj__, AnyGC* arg0) {
    LoggedDataPoint_log_(static_cast<LoggedDataPointValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_LoggedDataPoint_validate(AnyGC* obj__) {
    return _box(LoggedDataPoint_validate(static_cast<LoggedDataPointValue*>(obj__)));
}

static bool _LoggedDataPoint_vptr_registered = []{ LoggedDataPointValue::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_serialize); LoggedDataPointValue::_vptrMap["clone"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_clone); LoggedDataPointValue::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_compareTo2); LoggedDataPointValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_toString); LoggedDataPointValue::_vptrMap["get_logTag"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_get_logTag); LoggedDataPointValue::_vptrMap["log_"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_log_); LoggedDataPointValue::_vptrMap["validate"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_validate); return true; }();
LoggedDataPointValue* LoggedDataPoint_new(LoggedDataPointValue* this__, double x, double y, std::string label) {
    auto this_ = this__;
    if (LoggedDataPointValue::_vptrMap.empty()) {
        LoggedDataPointValue::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_serialize);
        LoggedDataPointValue::_vptrMap["clone"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_clone);
        LoggedDataPointValue::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_compareTo2);
        LoggedDataPointValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_toString);
        LoggedDataPointValue::_vptrMap["get_logTag"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_get_logTag);
        LoggedDataPointValue::_vptrMap["log_"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_log_);
        LoggedDataPointValue::_vptrMap["validate"] = reinterpret_cast<void*>(&_vptr_wrap_LoggedDataPoint_validate);
    }
    DataPoint_new(this_, x, y, label);
    return this_;
}

std::string LoggedDataPoint_get_logTag(LoggedDataPointValue* this__) {
    auto this_ = this__;
    return std::string("DataPoint");
}

AnyGC* _vptr_wrap_Config_toString(AnyGC* obj__) {
    return _box(Config_toString(static_cast<ConfigValue*>(obj__)));
}

static bool _Config_vptr_registered = []{ ConfigValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Config_toString); return true; }();
ConfigValue* Config_new(ConfigValue* this__, std::string host, int64_t port, bool secure) {
    auto this_ = this__;
    if (ConfigValue::_vptrMap.empty()) {
        ConfigValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Config_toString);
    }
    this_->host = host;
    this_->port = port;
    this_->secure = secure;
    this_->baseUrl = dart_str((secure ? std::string("https") : std::string("http"))) + dart_str(std::string("://")) + dart_str(host) + dart_str(std::string(":")) + dart_str(port);
    return this_;
}

ConfigValue* Config_new_localhost(ConfigValue* this__, int64_t port) {
    auto this_ = this__;
    return this_;
}

ConfigValue* Config_new_production(ConfigValue* this__, std::string host) {
    auto this_ = this__;
    return this_;
}

std::string Config_toString(ConfigValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Config(")) + dart_str(this_->baseUrl) + dart_str(std::string(")"));
}

template<typename T>
AnyGC* _vptr_wrap_SortedList_add(AnyGC* obj__, AnyGC* arg0) {
    SortedList_add<T>(static_cast<SortedListValue<T>*>(obj__), dynAs<T>(arg0));
    return nullptr;
}

template<typename T>
AnyGC* _vptr_wrap_SortedList_get_first(AnyGC* obj__) {
    return _box(SortedList_get_first<T>(static_cast<SortedListValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_SortedList_get_last(AnyGC* obj__) {
    return _box(SortedList_get_last<T>(static_cast<SortedListValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_SortedList_get_length(AnyGC* obj__) {
    return _box(SortedList_get_length<T>(static_cast<SortedListValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_SortedList_toList(AnyGC* obj__) {
    return _box(SortedList_toList<T>(static_cast<SortedListValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_SortedList_toString(AnyGC* obj__) {
    return _box(SortedList_toString<T>(static_cast<SortedListValue<T>*>(obj__)));
}

template<typename T> void _register_SortedList_vptr() {
    if (SortedListValue<T>::_vptrMap.empty()) {
        SortedListValue<T>::_vptrMap["add"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_add<T>);
        SortedListValue<T>::_vptrMap["get_first"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_get_first<T>);
        SortedListValue<T>::_vptrMap["get_last"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_get_last<T>);
        SortedListValue<T>::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_get_length<T>);
        SortedListValue<T>::_vptrMap["toList"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_toList<T>);
        SortedListValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_toString<T>);
    }
}
template<typename T>
SortedListValue<T>* SortedList_new(SortedListValue<T>* this__) {
    auto this_ = this__;
    if (SortedListValue<T>::_vptrMap.empty()) {
        SortedListValue<T>::_vptrMap["add"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_add<T>);
        SortedListValue<T>::_vptrMap["get_first"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_get_first<T>);
        SortedListValue<T>::_vptrMap["get_last"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_get_last<T>);
        SortedListValue<T>::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_get_length<T>);
        SortedListValue<T>::_vptrMap["toList"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_toList<T>);
        SortedListValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_SortedList_toString<T>);
    }
    this_->_items = GC::allocateLocal(new StaticList<T>());
    return this_;
}

template<typename T>
void SortedList_add(SortedListValue<T>* this__, T item) {
    auto this_ = this__;
    this_->_items->add(item);
    this_->_items->sort();
}

template<typename T>
T SortedList_get_first(SortedListValue<T>* this__) {
    auto this_ = this__;
    return this_->_items->first();
}

template<typename T>
T SortedList_get_last(SortedListValue<T>* this__) {
    auto this_ = this__;
    return this_->_items->last();
}

template<typename T>
int64_t SortedList_get_length(SortedListValue<T>* this__) {
    auto this_ = this__;
    return this_->_items->length();
}

template<typename T>
StaticList<T>* SortedList_toList(SortedListValue<T>* this__) {
    auto this_ = this__;
    return unmodifiable<T>(this_->_items);
}

template<typename T>
std::string SortedList_toString(SortedListValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("SortedList(")) + dart_str(this_->_items) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_NullSafetyDemo_demonstrate(AnyGC* obj__) {
    return _box(NullSafetyDemo_demonstrate(static_cast<NullSafetyDemoValue*>(obj__)));
}

static bool _NullSafetyDemo_vptr_registered = []{ NullSafetyDemoValue::_vptrMap["demonstrate"] = reinterpret_cast<void*>(&_vptr_wrap_NullSafetyDemo_demonstrate); return true; }();
NullSafetyDemoValue* NullSafetyDemo_new(NullSafetyDemoValue* this__, std::string nonNullField, std::string nullableField) {
    auto this_ = this__;
    if (NullSafetyDemoValue::_vptrMap.empty()) {
        NullSafetyDemoValue::_vptrMap["demonstrate"] = reinterpret_cast<void*>(&_vptr_wrap_NullSafetyDemo_demonstrate);
    }
    this_->nonNullField = nonNullField;
    this_->nullableField = nullableField;
    return this_;
}

std::string NullSafetyDemo_demonstrate(NullSafetyDemoValue* this__) {
    auto this_ = this__;
    int64_t len = ([&]() { std::string _let3 = this_->nullableField; return (_let3.empty() ? 0 : static_cast<int64_t>(_let3.length())); })();
    int64_t safeLen = len;
    ((this_->nullableField.empty()) ? (this_->nullableField = std::string("default")) : "");
    std::string forced = dart_str_toUpper(this_->nullableField);
    return dart_str(std::string("len=")) + dart_str(safeLen) + dart_str(std::string(", forced=")) + dart_str(forced);
}

AnyGC* _vptr_wrap_Renderer_render(AnyGC* obj__, AnyGC* arg0) {
    Renderer_render(static_cast<RendererValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_Renderer_get_name(AnyGC* obj__) {
    return _box(Renderer_get_name(static_cast<RendererValue*>(obj__)));
}

static bool _Renderer_vptr_registered = []{ RendererValue::_vptrMap["render"] = reinterpret_cast<void*>(&_vptr_wrap_Renderer_render); RendererValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_Renderer_get_name); return true; }();
RendererValue* Renderer_new(RendererValue* this__) {
    auto this_ = this__;
    if (RendererValue::_vptrMap.empty()) {
        RendererValue::_vptrMap["render"] = reinterpret_cast<void*>(&_vptr_wrap_Renderer_render);
        RendererValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_Renderer_get_name);
    }
    return this_;
}

void Renderer_render(RendererValue* this__, AnyGC* shape) {
    auto this_ = this__;
}

std::string Renderer_get_name(RendererValue* this__) {
    auto this_ = this__;
    return "";
}

AnyGC* _vptr_wrap_CircleRenderer_render(AnyGC* obj__, AnyGC* arg0) {
    CircleRenderer_render(static_cast<CircleRendererValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_CircleRenderer_get_name(AnyGC* obj__) {
    return _box(CircleRenderer_get_name(static_cast<CircleRendererValue*>(obj__)));
}

static bool _CircleRenderer_vptr_registered = []{ CircleRendererValue::_vptrMap["render"] = reinterpret_cast<void*>(&_vptr_wrap_CircleRenderer_render); CircleRendererValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_CircleRenderer_get_name); return true; }();
CircleRendererValue* CircleRenderer_new(CircleRendererValue* this__) {
    auto this_ = this__;
    if (CircleRendererValue::_vptrMap.empty()) {
        CircleRendererValue::_vptrMap["render"] = reinterpret_cast<void*>(&_vptr_wrap_CircleRenderer_render);
        CircleRendererValue::_vptrMap["get_name"] = reinterpret_cast<void*>(&_vptr_wrap_CircleRenderer_get_name);
    }
    Renderer_new(this_);
    return this_;
}

void CircleRenderer_render(CircleRendererValue* this__, std::string shape) {
    auto this_ = this__;
    staticPrint(dart_str(std::string("  CircleRenderer: drawing ")) + dart_str(shape));
}

std::string CircleRenderer_get_name(CircleRendererValue* this__) {
    auto this_ = this__;
    return std::string("CircleRenderer");
}

template<typename TInput, typename TOutput>
AnyGC* _vptr_wrap_Pipeline_execute(AnyGC* obj__, AnyGC* arg0) {
    return _box(Pipeline_execute<TInput, TOutput>(static_cast<PipelineValue<TInput, TOutput>*>(obj__), dynAs<TInput>(arg0)));
}

template<typename TInput, typename TOutput>
AnyGC* _vptr_wrap_Pipeline_then(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<TOutput> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(Pipeline_then<TInput, TOutput, AnyGC*>(static_cast<PipelineValue<TInput, TOutput>*>(obj__), &_adapter0));
}

template<typename TInput, typename TOutput> void _register_Pipeline_vptr() {
    if (PipelineValue<TInput, TOutput>::_vptrMap.empty()) {
        PipelineValue<TInput, TOutput>::_vptrMap["execute"] = reinterpret_cast<void*>(&_vptr_wrap_Pipeline_execute<TInput, TOutput>);
        PipelineValue<TInput, TOutput>::_vptrMap["then"] = reinterpret_cast<void*>(&_vptr_wrap_Pipeline_then<TInput, TOutput>);
    }
}
template<typename TInput, typename TOutput>
PipelineValue<TInput, TOutput>* Pipeline_new(PipelineValue<TInput, TOutput>* this__, TypeFunction1<TOutput, TInput>* _transform) {
    auto this_ = this__;
    if (PipelineValue<TInput, TOutput>::_vptrMap.empty()) {
        PipelineValue<TInput, TOutput>::_vptrMap["execute"] = reinterpret_cast<void*>(&_vptr_wrap_Pipeline_execute<TInput, TOutput>);
        PipelineValue<TInput, TOutput>::_vptrMap["then"] = reinterpret_cast<void*>(&_vptr_wrap_Pipeline_then<TInput, TOutput>);
    }
    this_->_transform = _transform;
    return this_;
}

template<typename TInput, typename TOutput>
TOutput Pipeline_execute(PipelineValue<TInput, TOutput>* this__, TInput input) {
    auto this_ = this__;
    return ([&]() { TInput _let5 = input; return this_->_transform->call(_let5); })();
}

template<typename TInput, typename TOutput, typename TNewOutput>
PipelineValue<TInput, TNewOutput>* Pipeline_then(PipelineValue<TInput, TOutput>* this__, TypeFunction1<TNewOutput, TOutput>* next) {
    auto this_ = this__;
    return Pipeline_new<TInput, TNewOutput>(GC::allocateLocal(new PipelineValue<TInput, TNewOutput>()), static_cast<TypeFunction1<TNewOutput, TInput>*>(GC::allocateLocal(static_cast<TypeFunction1<TNewOutput, TInput>*>(new ClosureEnv_0<TInput, TOutput, TNewOutput>(this_, next)))));
}

AnyGC* _vptr_wrap_BitFlags_set(AnyGC* obj__, AnyGC* arg0) {
    BitFlags_set(static_cast<BitFlagsValue*>(obj__), dynAs<int64_t>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_BitFlags_clear(AnyGC* obj__, AnyGC* arg0) {
    BitFlags_clear(static_cast<BitFlagsValue*>(obj__), dynAs<int64_t>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_BitFlags_has(AnyGC* obj__, AnyGC* arg0) {
    return _box(BitFlags_has(static_cast<BitFlagsValue*>(obj__), dynAs<int64_t>(arg0)));
}

AnyGC* _vptr_wrap_BitFlags_toString(AnyGC* obj__) {
    return _box(BitFlags_toString(static_cast<BitFlagsValue*>(obj__)));
}

static bool _BitFlags_vptr_registered = []{ BitFlagsValue::_vptrMap["set"] = reinterpret_cast<void*>(&_vptr_wrap_BitFlags_set); BitFlagsValue::_vptrMap["clear"] = reinterpret_cast<void*>(&_vptr_wrap_BitFlags_clear); BitFlagsValue::_vptrMap["has"] = reinterpret_cast<void*>(&_vptr_wrap_BitFlags_has); BitFlagsValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_BitFlags_toString); return true; }();
BitFlagsValue* BitFlags_new(BitFlagsValue* this__, int64_t _flags) {
    auto this_ = this__;
    if (BitFlagsValue::_vptrMap.empty()) {
        BitFlagsValue::_vptrMap["set"] = reinterpret_cast<void*>(&_vptr_wrap_BitFlags_set);
        BitFlagsValue::_vptrMap["clear"] = reinterpret_cast<void*>(&_vptr_wrap_BitFlags_clear);
        BitFlagsValue::_vptrMap["has"] = reinterpret_cast<void*>(&_vptr_wrap_BitFlags_has);
        BitFlagsValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_BitFlags_toString);
    }
    this_->_flags = _flags;
    return this_;
}

void BitFlags_set(BitFlagsValue* this__, int64_t flag) {
    auto this_ = this__;
    (this_->_flags = (this_->_flags | flag));
    return;
}

void BitFlags_clear(BitFlagsValue* this__, int64_t flag) {
    auto this_ = this__;
    (this_->_flags = (this_->_flags & (~flag)));
    return;
}

bool BitFlags_has(BitFlagsValue* this__, int64_t flag) {
    auto this_ = this__;
    return !(((this_->_flags & flag) == 0LL));
}

std::string BitFlags_toString(BitFlagsValue* this__) {
    auto this_ = this__;
    StaticList<std::string>* parts = GC::allocateLocal(new StaticList<std::string>());
    if (dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["has"]))(this_, _box(1)))) {
        parts->add(std::string("r"));
    }
    if (dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["has"]))(this_, _box(2)))) {
        parts->add(std::string("w"));
    }
    if (dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["has"]))(this_, _box(4)))) {
        parts->add(std::string("x"));
    }
    return (parts->isEmpty() ? std::string("-") : parts->join(std::string("")));
}

AnyGC* _vptr_wrap_Event_get_timestamp(AnyGC* obj__) {
    return _box(Event_get_timestamp(static_cast<EventValue*>(obj__)));
}

AnyGC* _vptr_wrap_Event_get_timeStr(AnyGC* obj__) {
    return _box(Event_get_timeStr(static_cast<EventValue*>(obj__)));
}

AnyGC* _vptr_wrap_Event_addTag(AnyGC* obj__, AnyGC* arg0) {
    Event_addTag(static_cast<EventValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_Event_get_tags(AnyGC* obj__) {
    return _box(Event_get_tags(static_cast<EventValue*>(obj__)));
}

AnyGC* _vptr_wrap_Event_toString(AnyGC* obj__) {
    return _box(Event_toString(static_cast<EventValue*>(obj__)));
}

static bool _Event_vptr_registered = []{ EventValue::_vptrMap["get_timestamp"] = reinterpret_cast<void*>(&_vptr_wrap_Event_get_timestamp); EventValue::_vptrMap["get_timeStr"] = reinterpret_cast<void*>(&_vptr_wrap_Event_get_timeStr); EventValue::_vptrMap["addTag"] = reinterpret_cast<void*>(&_vptr_wrap_Event_addTag); EventValue::_vptrMap["get_tags"] = reinterpret_cast<void*>(&_vptr_wrap_Event_get_tags); EventValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Event_toString); return true; }();
EventValue* Event_new(EventValue* this__, std::string name) {
    auto this_ = this__;
    if (EventValue::_vptrMap.empty()) {
        EventValue::_vptrMap["get_timestamp"] = reinterpret_cast<void*>(&_vptr_wrap_Event_get_timestamp);
        EventValue::_vptrMap["get_timeStr"] = reinterpret_cast<void*>(&_vptr_wrap_Event_get_timeStr);
        EventValue::_vptrMap["addTag"] = reinterpret_cast<void*>(&_vptr_wrap_Event_addTag);
        EventValue::_vptrMap["get_tags"] = reinterpret_cast<void*>(&_vptr_wrap_Event_get_tags);
        EventValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Event_toString);
    }
    this_->name = name;
    this_->_tags = GC::allocateLocal(new StaticList<std::string>());
    return this_;
}

std::string Event_toString(EventValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Event(")) + dart_str(this_->name) + dart_str(std::string(", ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_timeStr"]))(this_))) + dart_str(std::string(", tags=")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_tags"]))(this_)) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_ImportantEvent_get_timestamp(AnyGC* obj__) {
    return _box(ImportantEvent_get_timestamp(static_cast<ImportantEventValue*>(obj__)));
}

AnyGC* _vptr_wrap_ImportantEvent_get_timeStr(AnyGC* obj__) {
    return _box(ImportantEvent_get_timeStr(static_cast<ImportantEventValue*>(obj__)));
}

AnyGC* _vptr_wrap_ImportantEvent_addTag(AnyGC* obj__, AnyGC* arg0) {
    ImportantEvent_addTag(static_cast<ImportantEventValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_ImportantEvent_get_tags(AnyGC* obj__) {
    return _box(ImportantEvent_get_tags(static_cast<ImportantEventValue*>(obj__)));
}

AnyGC* _vptr_wrap_ImportantEvent_toString(AnyGC* obj__) {
    return _box(ImportantEvent_toString(static_cast<ImportantEventValue*>(obj__)));
}

AnyGC* _vptr_wrap_ImportantEvent_get_logTag(AnyGC* obj__) {
    return _box(ImportantEvent_get_logTag(static_cast<ImportantEventValue*>(obj__)));
}

AnyGC* _vptr_wrap_ImportantEvent_log_(AnyGC* obj__, AnyGC* arg0) {
    ImportantEvent_log_(static_cast<ImportantEventValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

static bool _ImportantEvent_vptr_registered = []{ ImportantEventValue::_vptrMap["get_timestamp"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_get_timestamp); ImportantEventValue::_vptrMap["get_timeStr"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_get_timeStr); ImportantEventValue::_vptrMap["addTag"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_addTag); ImportantEventValue::_vptrMap["get_tags"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_get_tags); ImportantEventValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_toString); ImportantEventValue::_vptrMap["get_logTag"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_get_logTag); ImportantEventValue::_vptrMap["log_"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_log_); return true; }();
ImportantEventValue* ImportantEvent_new(ImportantEventValue* this__, std::string name, Priority* priority) {
    auto this_ = this__;
    if (ImportantEventValue::_vptrMap.empty()) {
        ImportantEventValue::_vptrMap["get_timestamp"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_get_timestamp);
        ImportantEventValue::_vptrMap["get_timeStr"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_get_timeStr);
        ImportantEventValue::_vptrMap["addTag"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_addTag);
        ImportantEventValue::_vptrMap["get_tags"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_get_tags);
        ImportantEventValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_toString);
        ImportantEventValue::_vptrMap["get_logTag"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_get_logTag);
        ImportantEventValue::_vptrMap["log_"] = reinterpret_cast<void*>(&_vptr_wrap_ImportantEvent_log_);
    }
    this_->priority = priority;
    Event_new(this_, name);
    this_->_tags = GC::allocateLocal(new StaticList<std::string>());
    return this_;
}

std::string ImportantEvent_get_logTag(ImportantEventValue* this__) {
    auto this_ = this__;
    return std::string("ImportantEvent");
}

std::string ImportantEvent_toString(ImportantEventValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("ImportantEvent(")) + dart_str(this_->name) + dart_str(std::string(", ")) + dart_str(this_->priority) + dart_str(std::string(", ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_timeStr"]))(this_))) + dart_str(std::string(")"));
}

std::string formatMessage(std::string template_, std::string subject, int64_t count) {
    std::string result = template_;
    if (!((subject.empty()))) {
        (result = dart_str_replaceAll(result, std::string("{subject}"), subject));
    }
    if (!(false)) {
        (result = dart_str_replaceAll(result, std::string("{count}"), std::to_string(count)));
    }
    return result;
}

std::string buildQuery(std::string endpoint, StaticMap<std::string, std::string>* params, int64_t maxWait, bool secure) {
    std::string scheme = (secure ? std::string("https") : std::string("http"));
    std::string query = ([&]() { StaticMap<std::string, std::string>* _let8 = params; std::string _let7 = ([&]() { StaticMap<std::string, std::string>* _let8 = params; return (dart_isNull(_let8) ? std::string("") : _let8->entries()->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, StaticMapEntry<std::string, std::string>>*>(new ClosureEnv_1())))->join(std::string("&"))); })();  return ((_let7.empty()) ? std::string("") : _let7); })();
    std::string suffix = (query.empty() ? std::string("") : dart_str(std::string("?")) + dart_str(query));
    return dart_str(scheme) + dart_str(std::string("://")) + dart_str(endpoint) + dart_str(suffix) + dart_str(std::string(" (timeout=")) + dart_str(maxWait) + dart_str(std::string("s)"));
}

StaticList<int64_t>* range(int64_t start, int64_t end, int64_t step) {
    auto _result = GC::allocateLocal(new StaticList<int64_t>());
    int64_t i = start;
    while ((i < end)) {
        _result->add(i);
        (i = (i + step));
    }
    return _result;
}

StaticList<int64_t>* fibonacci(int64_t count) {
    auto _result = GC::allocateLocal(new StaticList<int64_t>());
    int64_t a = 0LL;
    int64_t b = 1LL;
    int64_t i = 0LL;
    while ((i < count)) {
        _result->add(a);
        int64_t next = (a + b);
        (a = b);
        (b = next);
        (i = (i + 1LL));
    }
    return _result;
}

Promise<StaticList<std::string>*>* countDown(int64_t from) {
    auto _promise = GC::allocateLocal(new Promise<StaticList<std::string>*>());
    StaticList<std::string>* result = GC::allocateLocal(new StaticList<std::string>());
    int64_t i = from;
    while ((i >= 0LL)) {
        smAwait<AnyGC*>(_box(promiseDelayed(1, []() -> AnyGC* { return nullptr; })));
        result->add(((i == 0LL) ? std::string("Go!") : dart_str(i) + dart_str(std::string("..."))));
        (i = (i - 1LL));
    }
    _promise->complete(_box(result));
    return _promise;
}

AnyGC* getPersonRecord() {
    return _box([&]() -> AnyGC* { auto _r0 = std::string("Alice"); auto _r1 = 30LL; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }());
}

AnyGC* getLocation() {
    return _box([&]() -> AnyGC* { auto _r0 = std::string("Beijing"); auto _r1 = 39.9; auto _r2 = 116.4; auto* _t = new std::tuple(_r0, _r1, _r2); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(", "), _r2, std::string(")")))); }());
}

AnyGC* divmod(int64_t a, int64_t b) {
    return _box([&]() -> AnyGC* { auto _r0 = (a / b); auto _r1 = (a % b); auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }());
}

std::string describeValue(AnyGC* value) {
    return ([&]() {     std::string _v9{""};
    AnyGC* _v10 = value;
    AnyGC* _v11 = nullptr;
    _L0:
    do {
        if ((dart_isNull(_v10))) {
            (_v9 = std::string("null"));
            break;
        }
        int64_t n{0};
        if ((((dynamic_cast<IntBox*>(_v10) != nullptr) && ([&]() { AnyGC* _let13 = ([&]() { (void)((n = dynAs<int64_t>(_v10))); return nullptr; })(); return true; })()) && (n < 0LL))) {
            (_v9 = dart_str(std::string("negative int: ")) + dart_str(n));
            break;
        }
        int64_t n_1{0};
        if ((dynamic_cast<IntBox*>(_v10) != nullptr)) {
            (n_1 = dynAs<int64_t>(_v10));
            (_v9 = dart_str(std::string("positive int: ")) + dart_str(n_1));
            break;
        }
        std::string s{""};
        if ((((dynamic_cast<StringBox*>(_v10) != nullptr) && ([&]() { AnyGC* _let14 = ([&]() { (void)((s = dynAs<std::string>(_v10))); return nullptr; })(); return true; })()) && s.empty())) {
            (_v9 = std::string("empty string"));
            break;
        }
        std::string s_2{""};
        if ((dynamic_cast<StringBox*>(_v10) != nullptr)) {
            (s_2 = dynAs<std::string>(_v10));
            (_v9 = dart_str(std::string("string: \"")) + dart_str(s_2) + dart_str(std::string("\"")));
            break;
        }
        StaticList<AnyGC*>* list{nullptr};
        if ((((dynamic_cast<VPtr*>(_v10) != nullptr && static_cast<VPtr*>(_v10)->_typeName == "List") && ([&]() { AnyGC* _let15 = (list = static_cast<StaticList<AnyGC*>*>(_v10)); return true; })()) && list->isEmpty())) {
            (_v9 = std::string("empty list"));
            break;
        }
        StaticList<AnyGC*>* list_3{nullptr};
        if ((dynamic_cast<VPtr*>(_v10) != nullptr && static_cast<VPtr*>(_v10)->_typeName == "List")) {
            (list_3 = static_cast<StaticList<AnyGC*>*>(_v10));
            (_v9 = dart_str(std::string("list of ")) + dart_str(list_3->length()));
            break;
        }
        if (true) {
            (_v9 = dart_str(std::string("unknown: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(static_cast<VPtr*>(value)->getVptrMap()["get_runtimeType"]))(static_cast<VPtr*>(value))));
            break;
        }
        throw DartException(dart_str(ReachabilityError_new(GC::allocateLocal(new ReachabilityErrorValue()), std::string("None of the patterns in the switch expression the matched input value. See https://github.com/dart-lang/language/issues/3488 for details."))));
    } while (false);
 return _v9; })();
}

StaticList<int64_t>* buildList() {
    return ([&]() { StaticList<int64_t>* _let16 = GC::allocateLocal(new StaticList<int64_t>()); return ([&]() {     _let16->add(1LL);
    _let16->add(2LL);
    _let16->addAll(GC::allocateLocal(new StaticList<int64_t>({3LL, 4LL, 5LL})));
    _let16->sort();
 return _let16; })(); })();
}

StaticStringBuffer* buildBuffer() {
    return ([&]() { StaticStringBuffer* _let17 = GC::allocateLocal(new StaticStringBuffer()); return ([&]() {     _let17->write(std::string("Hello"));
    _let17->write(std::string(", "));
    _let17->write(std::string("World"));
    _let17->writeln(std::string("!"));
 return _let17; })(); })();
}

StaticList<int64_t>* mergeAndFilter(StaticList<int64_t>* a, StaticList<int64_t>* b, bool includeNegative) {
    return ([&]() {     StaticList<int64_t>* _v18 = ([&]() { auto* _src = a; auto* _dst = GC::allocateLocal(new StaticList<int64_t>()); for (int _i = 0; _i < _src->length(); _i++) _dst->add((*_src)[_i]); return _dst; })();
    _v18->addAll(b);
    if (includeNegative) {
        _v18->add((-1LL));
    }
    int64_t i = 10LL;
    while ((i <= 12LL)) {
        _v18->add(i);
        (i = (i + 1LL));
    }
 return _v18; })();
}

StaticMap<std::string, int64_t>* buildScoreMap(StaticList<std::string>* names, bool addBonus) {
    return ([&]() {     StaticMap<std::string, int64_t>* _v19 = StaticMap<std::string, int64_t>::empty();
    int64_t i = 0LL;
    while ((i < names->length())) {
        _v19->set((*names)[i], ((i + 1LL) * 10LL));
        (i = (i + 1LL));
    }
    if (addBonus) {
        _v19->set(std::string("bonus"), 999LL);
    }
 return _v19; })();
}

int64_t parseAndDivide(std::string a, std::string b) {
    try {
        int64_t x = dart_stoll(a);
        int64_t y = dart_stoll(b);
        if ((y == 0LL)) {
            throw DartArgumentError(std::string("Division by zero"));
        }
        return (x / y);
    } catch (const DartFormatException& _e) {
        throw;
    } catch (const DartArgumentError& e) {
        throw DartStateError(dart_str(std::string("Math error: ")) + dart_str(e.message));
    }
}

std::string multiLineExample() {
    std::string raw = std::string("raw\\nstring\\ttabs");
    std::string multiLine = std::string("line1\nline2\nline3");
    std::string nested = dart_str(std::string("lines: ")) + dart_str(dart_str_split(multiLine, std::string("\n"))->length()) + dart_str(std::string(", raw: ")) + dart_str(raw);
    return nested;
}

template<typename A, typename B, typename C>
TypeFunction1<C, A>* compose(TypeFunction1<B, A>* f, TypeFunction1<C, B>* g) {
    return GC::allocateLocal(static_cast<TypeFunction1<C, A>*>(new ClosureEnv_2<C, B, A>(g, f)));
}

template<typename T>
TypeFunction1<bool, T>* and_(TypeFunction1<bool, T>* p1, TypeFunction1<bool, T>* p2) {
    return GC::allocateLocal(static_cast<TypeFunction1<bool, T>*>(new ClosureEnv_3<T>(p1, p2)));
}

template<typename A, typename B>
StaticList<B>* flatMap(StaticList<A>* list, TypeFunction1<StaticList<B>*, A>* f) {
    return /* unsupported collection method: expand on List */ list->expand(f);
}

template<typename T>
T findMax(StaticList<T>* items) {
    T maxItem = items->first();
    StaticIterator<T>* sync_for_iterator = items->iterator();
    while (sync_for_iterator->moveNext()) {
        T item = sync_for_iterator->current();
        if ((([&]() -> int64_t { if constexpr (std::is_pointer_v<decltype(item)>) { auto* _vp = dynamic_cast<VPtr*>(static_cast<AnyGC*>(item)); if (_vp) { return dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(dynamic_cast<VPtr*>(static_cast<AnyGC*>(item))->getVptrMap()["compareTo"]))(static_cast<AnyGC*>(item), _box(maxItem))); } else { return static_cast<int64_t>(0); } } else { return ((item) > (maxItem) ? 1LL : ((item) < (maxItem) ? -1LL : 0LL)); } })() > 0LL)) {
            (maxItem = item);
        }
    }
    return maxItem;
}

template<typename T, typename R>
R applyTwice(T value, TypeFunction1<R, T>* fn1, TypeFunction1<R, R>* fn2) {
    return fn2->call(fn1->call(value));
}

std::string findFirst(StaticList<std::string>* items, TypeFunction1<bool, std::string>* test) {
    StaticIterator<std::string>* sync_for_iterator = items->iterator();
    while (sync_for_iterator->moveNext()) {
        std::string item = sync_for_iterator->current();
        if (test->call(item)) {
            return item;
        }
    }
    return "";
}

StaticList<int64_t>* filterWithForIn(StaticList<int64_t>* items) {
    StaticList<int64_t>* result = GC::allocateLocal(new StaticList<int64_t>());
    StaticIterator<int64_t>* sync_for_iterator = items->iterator();
    while (sync_for_iterator->moveNext()) {
        int64_t item = sync_for_iterator->current();
        if (((item >= 0LL) && (item <= 100LL))) {
            result->add(item);
        }
    }
    return result;
}

int64_t collatzSteps(int64_t n) {
    int64_t steps = 0LL;
    _L4:
    do {
        if ((n == 1LL)) {
            break;
        }
        if (((n % 2LL) == 0LL)) {
            (n = (n / 2LL));
        } else {
            (n = ((3LL * n) + 1LL));
        }
        (steps = (steps + 1LL));
    } while (!((n == 1LL)));
    return steps;
}

std::string typeTest(AnyGC* value) {
    if ((dynamic_cast<IntBox*>(value) != nullptr)) {
        return dart_str(std::string("int: ")) + dart_str((dynAs<int64_t>(value) * 2LL));
    } else {
        if ((dynamic_cast<StringBox*>(value) != nullptr)) {
            return dart_str(std::string("string: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(static_cast<VPtr*>(value)->getVptrMap()["toUpperCase"]))(value)));
        } else {
            if ((dynamic_cast<StaticList<int64_t>*>(value) != nullptr)) {
                return dart_str(std::string("list<int>: ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(static_cast<VPtr*>(value)->getVptrMap()["get_length"]))(static_cast<VPtr*>(value)))) + dart_str(std::string(" items"));
            } else {
                if ((dynamic_cast<BoolBox*>(value) != nullptr)) {
                    return dart_str(std::string("bool: ")) + dart_str(value);
                }
            }
        }
    }
    return dart_str(std::string("other: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(static_cast<VPtr*>(value)->getVptrMap()["get_runtimeType"]))(static_cast<VPtr*>(value)));
}

double safeCast(AnyGC* value) {
    try {
        return dynAs<double>(value);
    } catch (const DartException& e) {
        return 0.0;
    }
}

std::string tryCatchFinally(int64_t code) {
    StaticStringBuffer* log_ = GC::allocateLocal(new StaticStringBuffer());
    try {
        log_->write(std::string("try "));
        if ((code == 1LL)) {
            throw DartFormatException(std::string("bad format"));
        }
        if ((code == 2LL)) {
            throw DartArgumentError(std::string("bad arg"));
        }
        log_->write(std::string("ok "));
    } catch (const DartException& e) {
        log_->write(dart_str(std::string("format:")) + dart_str(e.message) + dart_str(std::string(" ")));
    } catch (const DartException& e) {
        log_->write(dart_str(std::string("arg:")) + dart_str(e.message) + dart_str(std::string(" ")));
    } catch (const DartException& e) {
        log_->write(dart_str(std::string("other:")) + dart_str(e) + dart_str(std::string(" ")));
    }
    // finally
    log_->write(std::string("finally"));
    return log_->toString();
}

std::string dayType(int64_t day) {
    _L5:
    do {
        switch (day) {
            _sw_case_0:
            case 1:
            case 7:
            {
                return std::string("weekend");
                break;
            }
            _sw_case_1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            {
                return std::string("weekday");
                break;
            }
            _sw_case_2:
            default: {
                return std::string("invalid");
                break;
            }
        }
    } while (false);
}

int main() {
    staticPrint(std::string("=== 全面语法节点还原测试 ===\n"));
    staticPrint(std::string("--- 1. mixin + implements ---"));
    DogValue* dog1 = Dog_new(GC::allocateLocal(new DogValue()), std::string("Rex"), 3LL, std::string("Labrador"));
    DogValue* dog2 = Dog_new(GC::allocateLocal(new DogValue()), std::string("Max"), 5LL, std::string("Poodle"));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(dog1->getVptrMap()["printInfo"]))(dog1);
    staticPrint(dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(dog1->getVptrMap()["speak"]))(dog1))) + dart_str(std::string(" (")) + dart_str(dog1->breed) + dart_str(std::string(")")));
    staticPrint(dart_str(std::string("dog1 < dog2: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(dog1->getVptrMap()["isLessThan"]))(dog1, _box(dog2)))));
    staticPrint(dart_str(std::string("dog1 > dog2: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(dog1->getVptrMap()["isGreaterThan"]))(dog1, _box(dog2)))));
    CatValue* cat = Cat_new(GC::allocateLocal(new CatValue()), std::string("Whiskers"), 2LL);
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(cat->getVptrMap()["printInfo"]))(cat);
    staticPrint(dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(cat->getVptrMap()["speak"]))(cat))) + dart_str(std::string(", mood: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(cat->getVptrMap()["get_mood"]))(cat))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(cat->getVptrMap()["set_mood"]))(cat, _box(std::string("sleepy")));
    staticPrint(dart_str(std::string("mood after set: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(cat->getVptrMap()["get_mood"]))(cat))));
    staticPrint(std::string("\n--- 2. operator 重载 ---"));
    Vector2DValue* v1 = ([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })();
    Vector2DValue* v2 = ([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 1.0; _obj->y = 2.0; return _obj; })();
    Vector2DValue* sum = reinterpret_cast<Vector2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })()->getVptrMap()["+"]))(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })(), _box(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 1.0; _obj->y = 2.0; return _obj; })())));
    Vector2DValue* diff = reinterpret_cast<Vector2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })()->getVptrMap()["-"]))(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })(), _box(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 1.0; _obj->y = 2.0; return _obj; })())));
    Vector2DValue* scaled = reinterpret_cast<Vector2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })()->getVptrMap()["*"]))(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })(), _box(2.0)));
    staticPrint(dart_str(std::string("v1 + v2 = ")) + dart_str(sum));
    staticPrint(dart_str(std::string("v1 - v2 = ")) + dart_str(diff));
    staticPrint(dart_str(std::string("v1 * 2 = ")) + dart_str(scaled));
    staticPrint(dart_str(std::string("v1.length = ")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(2LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })()->getVptrMap()["get_length"]))(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })())); return _ss.str(); })()));
    staticPrint(dart_str(std::string("v1 == Vector2D(3,4): ")) + dart_str(([&]() -> bool { auto& _vm = (([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })())->getVptrMap(); auto _it = _vm.find("=="); if (_it != _vm.end()) { return dynAs<bool>(reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(_it->second)(static_cast<AnyGC*>(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })()), _box(([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })()))); } return (([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })()) == (([&]() { auto* _obj = GC::allocateLocal(new Vector2DValue()); _obj->x = 3.0; _obj->y = 4.0; return _obj; })()); })()));
    staticPrint(std::string("\n--- 3. static + factory ---"));
    CounterValue* c1 = Counter_new(std::string("alpha"), 0);
    CounterValue* c2 = Counter_new(std::string("beta"), 50LL);
    CounterValue* c3 = Counter_new_fromString(std::string("gamma:25"));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(c1->getVptrMap()["increment"]))(c1, _box(10LL));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(c2->getVptrMap()["decrement"]))(c2, _box(5LL));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(c3->getVptrMap()["increment"]))(c3, _box(1));
    staticPrint(dart_str(c1) + dart_str(std::string(", ")) + dart_str(c2) + dart_str(std::string(", ")) + dart_str(c3));
    staticPrint(dart_str(std::string("instances: ")) + dart_str(Counter_get_instanceCount()));
    staticPrint(std::string("maxValue: 100"));
    staticPrint(std::string("\n--- 4. Result<T> + named params ---"));
    ResultValue<int64_t>* ok = ([&]() {{ _register_Result_vptr<int64_t>(); auto* _obj = GC::allocateLocal(new ResultValue<int64_t>()); _obj->data = 42; _obj->error = ""; _obj->isSuccess = true; return _obj; }})();
    ResultValue<int64_t>* err = ([&]() {{ _register_Result_vptr<int64_t>(); auto* _obj = GC::allocateLocal(new ResultValue<int64_t>()); _obj->data = 0; _obj->error = std::string("not found"); _obj->isSuccess = false; return _obj; }})();
    staticPrint(dart_str(std::string("ok: ")) + dart_str(([&]() {{ _register_Result_vptr<int64_t>(); auto* _obj = GC::allocateLocal(new ResultValue<int64_t>()); _obj->data = 42; _obj->error = ""; _obj->isSuccess = true; return _obj; }})()));
    staticPrint(dart_str(std::string("err: ")) + dart_str(([&]() {{ _register_Result_vptr<int64_t>(); auto* _obj = GC::allocateLocal(new ResultValue<int64_t>()); _obj->data = 0; _obj->error = std::string("not found"); _obj->isSuccess = false; return _obj; }})()));
    std::string okMsg = dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(([&]() {{ _register_Result_vptr<int64_t>(); auto* _obj = GC::allocateLocal(new ResultValue<int64_t>()); _obj->data = 42; _obj->error = ""; _obj->isSuccess = true; return _obj; }})()->getVptrMap()["fold"]))(([&]() {{ _register_Result_vptr<int64_t>(); auto* _obj = GC::allocateLocal(new ResultValue<int64_t>()); _obj->data = 42; _obj->error = ""; _obj->isSuccess = true; return _obj; }})(), _box(GC::allocateLocal(static_cast<TypeFunction1<std::string, int64_t>*>(new ClosureEnv_4()))), _box(GC::allocateLocal(static_cast<TypeFunction1<std::string, std::string>*>(new ClosureEnv_5())))));
    std::string errMsg = dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(([&]() {{ _register_Result_vptr<int64_t>(); auto* _obj = GC::allocateLocal(new ResultValue<int64_t>()); _obj->data = 0; _obj->error = std::string("not found"); _obj->isSuccess = false; return _obj; }})()->getVptrMap()["fold"]))(([&]() {{ _register_Result_vptr<int64_t>(); auto* _obj = GC::allocateLocal(new ResultValue<int64_t>()); _obj->data = 0; _obj->error = std::string("not found"); _obj->isSuccess = false; return _obj; }})(), _box(GC::allocateLocal(static_cast<TypeFunction1<std::string, int64_t>*>(new ClosureEnv_6()))), _box(GC::allocateLocal(static_cast<TypeFunction1<std::string, std::string>*>(new ClosureEnv_7())))));
    staticPrint(dart_str(std::string("okMsg: ")) + dart_str(okMsg));
    staticPrint(dart_str(std::string("errMsg: ")) + dart_str(errMsg));
    staticPrint(std::string("\n--- 5. 可选参数 ---"));
    staticPrint(formatMessage(std::string("Hello {subject}!"), std::string("Dart")));
    staticPrint(formatMessage(std::string("Count: {count}"), "", 99LL));
    staticPrint(formatMessage(std::string("No params")));
    staticPrint(buildQuery(std::string("api.example.com/users"), nullptr, 30, true));
    staticPrint(buildQuery(std::string("api.example.com/search"), ([&]() { auto* _m = StaticMap<std::string, std::string>::empty(); _m->set(std::string("q"), std::string("dart")); _m->set(std::string("page"), std::string("1")); return _m; })(), 10LL, false));
    staticPrint(std::string("\n--- 6. sync* 生成器 ---"));
    StaticList<int64_t>* r = range(0LL, 10LL, 2LL);
    staticPrint(dart_str(std::string("range(0,10,2): ")) + dart_str(r));
    StaticList<int64_t>* fib = fibonacci(8LL);
    staticPrint(dart_str(std::string("fibonacci(8): ")) + dart_str(fib));
    staticPrint(std::string("\n--- 7. async countdown ---"));
    StaticList<std::string>* countdown = smAwait<StaticList<std::string>*>(countDown(3LL));
    staticPrint(dart_str(std::string("countdown: ")) + dart_str(countdown));
    staticPrint(std::string("\n--- 8. record 类型 ---"));
    AnyGC* person = getPersonRecord();
    staticPrint(dart_str(std::string("person: ")) + dart_str(std::get<0>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(person)->data))) + dart_str(std::string(", age=")) + dart_str(std::get<1>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(person)->data))));
    AnyGC* loc = getLocation();
    staticPrint(dart_str(std::string("location: ")) + dart_str(std::get<0>(*reinterpret_cast<std::tuple<std::string, double, double>*>(static_cast<TupleBox*>(loc)->data))) + dart_str(std::string(" (")) + dart_str(std::get<1>(*reinterpret_cast<std::tuple<std::string, double, double>*>(static_cast<TupleBox*>(loc)->data))) + dart_str(std::string(", ")) + dart_str(std::get<2>(*reinterpret_cast<std::tuple<std::string, double, double>*>(static_cast<TupleBox*>(loc)->data))) + dart_str(std::string(")")));
    int64_t q{0};
    int64_t r2{0};
    AnyGC* _v10 = divmod(17LL, 5LL);
    (q = std::get<0>(*reinterpret_cast<std::tuple<int64_t, int64_t>*>(static_cast<TupleBox*>(_v10)->data)));
    (r2 = std::get<1>(*reinterpret_cast<std::tuple<int64_t, int64_t>*>(static_cast<TupleBox*>(_v10)->data)));
    staticPrint(dart_str(std::string("divmod(17,5): quotient=")) + dart_str(q) + dart_str(std::string(", remainder=")) + dart_str(r2));
    staticPrint(std::string("\n--- 9. pattern matching ---"));
    StaticList<AnyGC*>* values = GC::allocateLocal(new StaticList<AnyGC*>({nullptr, GC::allocateLocal(new IntBox((-5LL))), GC::allocateLocal(new IntBox(42LL)), GC::allocateLocal(new StringBox(std::string(""))), GC::allocateLocal(new StringBox(std::string("hello")))}));
    StaticIterator<AnyGC*>* sync_for_iterator = values->iterator();
    while (sync_for_iterator->moveNext()) {
        AnyGC* v = sync_for_iterator->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(describeValue(v)));
    }
    staticPrint(std::string("\n--- 10. 级联操作符 ---"));
    StaticList<int64_t>* list = buildList();
    staticPrint(dart_str(std::string("buildList: ")) + dart_str(list));
    StaticStringBuffer* buf = buildBuffer();
    staticPrint(dart_str(std::string("buildBuffer: ")) + dart_str(dart_str_trim(buf->toString())));
    staticPrint(std::string("\n--- 11. 展开 + 集合 if/for ---"));
    StaticList<int64_t>* merged = mergeAndFilter(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL})), GC::allocateLocal(new StaticList<int64_t>({3LL, 4LL})), true);
    staticPrint(dart_str(std::string("merged(includeNeg=true): ")) + dart_str(merged));
    StaticList<int64_t>* mergedNoNeg = mergeAndFilter(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL})), GC::allocateLocal(new StaticList<int64_t>({3LL, 4LL})), false);
    staticPrint(dart_str(std::string("merged(includeNeg=false): ")) + dart_str(mergedNoNeg));
    StaticMap<std::string, int64_t>* scores = buildScoreMap(GC::allocateLocal(new StaticList<std::string>({std::string("Alice"), std::string("Bob"), std::string("Carol")})), true);
    staticPrint(dart_str(std::string("scores: ")) + dart_str(scores));
    staticPrint(std::string("\n--- 12. late 变量 ---"));
    LazyLoaderValue* loader = LazyLoader_new(GC::allocateLocal(new LazyLoaderValue()));
    staticPrint(dart_str(std::string("before init: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(loader->getVptrMap()["get_data"]))(loader))) + dart_str(std::string(", ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(loader->getVptrMap()["get_computedValue"]))(loader))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(loader->getVptrMap()["initialize"]))(loader, _box(std::string("hello")));
    staticPrint(dart_str(std::string("after init: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(loader->getVptrMap()["get_data"]))(loader))) + dart_str(std::string(", ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(loader->getVptrMap()["get_computedValue"]))(loader))));
    staticPrint(std::string("\n--- 13. rethrow ---"));
    try {
        parseAndDivide(std::string("10"), std::string("2"));
        staticPrint(dart_str(std::string("10/2 = ")) + dart_str(parseAndDivide(std::string("10"), std::string("2"))));
    } catch (const DartException& e) {
        staticPrint(dart_str(std::string("unexpected: ")) + dart_str(e));
    }
    try {
        parseAndDivide(std::string("10"), std::string("0"));
    } catch (const DartStateError& e) {
        staticPrint(dart_str(std::string("StateError: ")) + dart_str(e.message));
    }
    try {
        parseAndDivide(std::string("abc"), std::string("2"));
    } catch (const DartFormatException& e) {
        staticPrint(dart_str(std::string("FormatException: ")) + dart_str(e.message));
    }
    staticPrint(std::string("\n--- 14. assert ---"));
    BoundedValueValue* bv = BoundedValue_new(GC::allocateLocal(new BoundedValueValue()), 0.0, 10.0, 5.0);
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(bv->getVptrMap()["set"]))(bv, _box(7.5));
    staticPrint(dart_str(std::string("BoundedValue: ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(bv->getVptrMap()["get_current"]))(bv))));
    staticPrint(std::string("\n--- 15. 字符串 ---"));
    staticPrint(multiLineExample());
    staticPrint(std::string("\n--- 16. typedef + 函数式组合 ---"));
    TypeFunction1<std::string, int64_t>* doubleIt = compose<int64_t, int64_t, std::string>(GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_8())), GC::allocateLocal(static_cast<TypeFunction1<std::string, int64_t>*>(new ClosureEnv_9())));
    staticPrint(dart_str(std::string("compose(5): ")) + dart_str(doubleIt->call(5LL)));
    TypeFunction1<bool, int64_t>* isPositive = GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_10()));
    TypeFunction1<bool, int64_t>* isEven = GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_11()));
    TypeFunction1<bool, int64_t>* isPositiveEven = and_<int64_t>(isPositive, isEven);
    StaticList<int64_t>* nums = GC::allocateLocal(new StaticList<int64_t>({(-2LL), (-1LL), 0LL, 1LL, 2LL, 3LL, 4LL}));
    staticPrint(dart_str(std::string("positiveEvens: ")) + dart_str(nums->where(isPositiveEven)));
    StaticList<int64_t>* nested = flatMap<int64_t, int64_t>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL})), GC::allocateLocal(static_cast<TypeFunction1<StaticList<int64_t>*, int64_t>*>(new ClosureEnv_12())));
    staticPrint(dart_str(std::string("flatMap: ")) + dart_str(nested));
    staticPrint(std::string("\n--- 19. 多层继承链 ---"));
    ShapeValue* shape = Shape_new(GC::allocateLocal(new ShapeValue()), std::string("red"));
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(shape->getVptrMap()["describe"]))(shape)));
    ShapeValue* transparentShape = Shape_new_transparent(GC::allocateLocal(new ShapeValue()), std::string("blue"));
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(transparentShape->getVptrMap()["describe"]))(transparentShape)));
    PolygonValue* polygon = Polygon_new(GC::allocateLocal(new PolygonValue()), std::string("green"), 6LL, 0.8);
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(polygon->getVptrMap()["describe"]))(polygon)));
    staticPrint(dart_str(std::string("perimeter: ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(polygon->getVptrMap()["perimeter"]))(polygon, _box(3.0)))));
    RegularPolygonValue* hexagon = RegularPolygon_new(GC::allocateLocal(new RegularPolygonValue()), std::string("yellow"), 6LL, 5.0);
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(hexagon->getVptrMap()["describe"]))(hexagon)));
    staticPrint(dart_str(std::string("perimeter: ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(hexagon->getVptrMap()["perimeter"]))(hexagon, _box(nullptr)))));
    staticPrint(dart_str(std::string("area: ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(hexagon->getVptrMap()["area"]))(hexagon))));
    SquareValue* square = Square_new(GC::allocateLocal(new SquareValue()), std::string("white"), 10.0, 0.9);
    staticPrint(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(square->getVptrMap()["describe"]))(square)));
    staticPrint(dart_str(std::string("square perimeter: ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(square->getVptrMap()["perimeter"]))(square, _box(nullptr)))));
    staticPrint(std::string("\n--- 20. implements 多接口 ---"));
    DataPointValue* dp1 = DataPoint_new(GC::allocateLocal(new DataPointValue()), 1.0, 2.0, std::string("A"));
    DataPointValue* dp2 = DataPoint_new(GC::allocateLocal(new DataPointValue()), 3.0, 1.0, std::string("B"));
    staticPrint(dart_str(std::string("dp1: ")) + dart_str(dp1));
    staticPrint(dart_str(std::string("dp1.serialize: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(dp1->getVptrMap()["serialize"]))(dp1))));
    DataPointValue* dp1Clone = static_cast<DataPointValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(dp1->getVptrMap()["clone"]))(dp1));
    staticPrint(dart_str(std::string("dp1.clone: ")) + dart_str(dp1Clone));
    staticPrint(dart_str(std::string("dp1.compareTo2(dp2): ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(dp1->getVptrMap()["compareTo2"]))(dp1, _box(dp2)))));
    staticPrint(std::string("\n--- 21. mixin on 约束 ---"));
    LoggedDataPointValue* ldp = LoggedDataPoint_new(GC::allocateLocal(new LoggedDataPointValue()), 5.0, 6.0, std::string("logged"));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(ldp->getVptrMap()["log_"]))(ldp, _box(std::string("created")));
    staticPrint(dart_str(std::string("validate: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ldp->getVptrMap()["validate"]))(ldp))));
    staticPrint(dart_str(std::string("serialize: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ldp->getVptrMap()["serialize"]))(ldp))));
    staticPrint(std::string("\n--- 22. 增强枚举 ---"));
    staticPrint(dart_str(std::string("Priority.high: ")) + dart_str(std::string("Priority")) + dart_str(std::string(".high")));
    staticPrint(dart_str(std::string("high > medium: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(Priority::high->getVptrMap()["isHigherThan"]))(Priority::high, _box(Priority::medium)))));
    staticPrint(dart_str(std::string("low > high: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(Priority::low->getVptrMap()["isHigherThan"]))(Priority::low, _box(Priority::high)))));
    StaticIterator<Priority*>* sync_for_iterator_6 = GC::allocateLocal(new StaticList<Priority*>({Priority::low, Priority::medium, Priority::high, Priority::critical}))->iterator();
    while (sync_for_iterator_6->moveNext()) {
        Priority* p = sync_for_iterator_6->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(p));
    }
    staticPrint(dart_str(std::string("GET isReadOnly: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(HttpMethod::get->getVptrMap()["get_isReadOnly"]))(HttpMethod::get))));
    staticPrint(dart_str(std::string("POST isReadOnly: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(HttpMethod::post->getVptrMap()["get_isReadOnly"]))(HttpMethod::post))));
    staticPrint(std::string("\n--- 23. 重定向构造函数 ---"));
    ConfigValue* cfg1 = Config_new(GC::allocateLocal(new ConfigValue()), std::string("example.com"), 8080LL);
    ConfigValue* cfg2 = Config_new_localhost(GC::allocateLocal(new ConfigValue()));
    ConfigValue* cfg3 = Config_new_production(GC::allocateLocal(new ConfigValue()), std::string("api.example.com"));
    staticPrint(dart_str(std::string("cfg1: ")) + dart_str(cfg1));
    staticPrint(dart_str(std::string("cfg2: ")) + dart_str(cfg2));
    staticPrint(dart_str(std::string("cfg3: ")) + dart_str(cfg3));
    staticPrint(std::string("\n--- 25. null safety ---"));
    NullSafetyDemoValue* ns1 = NullSafetyDemo_new(GC::allocateLocal(new NullSafetyDemoValue()), std::string("hello"), std::string("world"));
    staticPrint(dart_str(std::string("ns1: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ns1->getVptrMap()["demonstrate"]))(ns1))));
    NullSafetyDemoValue* ns2 = NullSafetyDemo_new(GC::allocateLocal(new NullSafetyDemoValue()), std::string("hello"));
    staticPrint(dart_str(std::string("ns2: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ns2->getVptrMap()["demonstrate"]))(ns2))));
    std::string found = findFirst(GC::allocateLocal(new StaticList<std::string>({std::string("apple"), std::string("banana"), std::string("cherry")})), GC::allocateLocal(static_cast<TypeFunction1<bool, std::string>*>(new ClosureEnv_13())));
    staticPrint(dart_str(std::string("findFirst(b): ")) + dart_str(found));
    std::string notFound = findFirst(GC::allocateLocal(new StaticList<std::string>({std::string("apple"), std::string("banana")})), GC::allocateLocal(static_cast<TypeFunction1<bool, std::string>*>(new ClosureEnv_14())));
    staticPrint(dart_str(std::string("findFirst(z): ")) + dart_str(notFound));
    staticPrint(std::string("\n--- 26. for-in + do-while ---"));
    StaticList<int64_t>* filtered = filterWithForIn(GC::allocateLocal(new StaticList<int64_t>({5LL, (-3LL), 10LL, 200LL, 50LL, (-1LL), 80LL})));
    staticPrint(dart_str(std::string("filterWithForIn: ")) + dart_str(filtered));
    staticPrint(dart_str(std::string("collatz(6): ")) + dart_str(collatzSteps(6LL)));
    staticPrint(dart_str(std::string("collatz(27): ")) + dart_str(collatzSteps(27LL)));
    staticPrint(std::string("\n--- 27. 类型测试 ---"));
    staticPrint(typeTest(GC::allocateLocal(new IntBox(42LL))));
    staticPrint(typeTest(GC::allocateLocal(new StringBox(std::string("hello")))));
    staticPrint(typeTest(GC::allocateLocal(new BoolBox(true))));
    staticPrint(typeTest(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL}))));
    staticPrint(dart_str(std::string("safeCast(3.14): ")) + dart_str(safeCast(GC::allocateLocal(new DoubleBox(3.14)))));
    staticPrint(dart_str(std::string("safeCast(\"x\"): ")) + dart_str(safeCast(GC::allocateLocal(new StringBox(std::string("x"))))));
    staticPrint(std::string("\n--- 28. try-catch-finally ---"));
    staticPrint(dart_str(std::string("code=0: ")) + dart_str(tryCatchFinally(0LL)));
    staticPrint(dart_str(std::string("code=1: ")) + dart_str(tryCatchFinally(1LL)));
    staticPrint(dart_str(std::string("code=2: ")) + dart_str(tryCatchFinally(2LL)));
    staticPrint(std::string("\n--- 29. covariant ---"));
    CircleRendererValue* renderer = CircleRenderer_new(GC::allocateLocal(new CircleRendererValue()));
    staticPrint(dart_str(std::string("renderer: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(renderer->getVptrMap()["get_name"]))(renderer))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(renderer->getVptrMap()["render"]))(renderer, _box(std::string("circle")));
    staticPrint(std::string("\n--- 31. switch-case ---"));
    staticPrint(dart_str(std::string("day 1: ")) + dart_str(dayType(1LL)));
    staticPrint(dart_str(std::string("day 3: ")) + dart_str(dayType(3LL)));
    staticPrint(dart_str(std::string("day 7: ")) + dart_str(dayType(7LL)));
    staticPrint(dart_str(std::string("day 9: ")) + dart_str(dayType(9LL)));
    staticPrint(std::string("\n--- 32. 位运算 ---"));
    BitFlagsValue* flags = BitFlags_new(GC::allocateLocal(new BitFlagsValue()));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(flags->getVptrMap()["set"]))(flags, _box(1));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(flags->getVptrMap()["set"]))(flags, _box(4));
    staticPrint(dart_str(std::string("flags: ")) + dart_str(flags));
    staticPrint(dart_str(std::string("has read: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(flags->getVptrMap()["has"]))(flags, _box(1)))));
    staticPrint(dart_str(std::string("has write: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(flags->getVptrMap()["has"]))(flags, _box(2)))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(flags->getVptrMap()["set"]))(flags, _box(2));
    staticPrint(dart_str(std::string("after set write: ")) + dart_str(flags));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(flags->getVptrMap()["clear"]))(flags, _box(4));
    staticPrint(dart_str(std::string("after clear execute: ")) + dart_str(flags));
    staticPrint(std::string("\n--- 33. 多层 mixin ---"));
    EventValue* event = Event_new(GC::allocateLocal(new EventValue()), std::string("meeting"));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(event->getVptrMap()["addTag"]))(event, _box(std::string("work")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(event->getVptrMap()["addTag"]))(event, _box(std::string("important")));
    staticPrint(event);
    ImportantEventValue* impEvent = ImportantEvent_new(GC::allocateLocal(new ImportantEventValue()), std::string("deadline"), static_cast<Priority*>(Priority::critical));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(impEvent->getVptrMap()["addTag"]))(impEvent, _box(std::string("urgent")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(impEvent->getVptrMap()["log_"]))(impEvent, _box(std::string("created")));
    staticPrint(impEvent);
    staticPrint(std::string("\n=== 所有测试通过 ✅ ==="));
    return 0;
}

AnyGC* Dog_toString(DogValue* this__) {
    auto this_ = this__;
    return _box(Animal_toString(this_));
}

void Dog_printInfo(DogValue* this__) {
    auto this_ = this__;
    staticPrint(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_displayName"]))(this_))) + dart_str(std::string("]")));
    return;
}

AnyGC* Dog_isLessThan(DogValue* this__, DogValue* other) {
    auto this_ = this__;
    return _box((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo"]))(this_, _box(other))) < 0LL));
}

AnyGC* Dog_isGreaterThan(DogValue* this__, DogValue* other) {
    auto this_ = this__;
    return _box((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo"]))(this_, _box(other))) > 0LL));
}

AnyGC* Cat_toString(CatValue* this__) {
    auto this_ = this__;
    return _box(Animal_toString(this_));
}

void Cat_printInfo(CatValue* this__) {
    auto this_ = this__;
    staticPrint(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_displayName"]))(this_))) + dart_str(std::string("]")));
    return;
}

AnyGC* Square_perimeter(SquareValue* this__, double overrideSideLength) {
    auto this_ = this__;
    return _box((this_->sides * overrideSideLength));
}

AnyGC* Square_area(SquareValue* this__) {
    auto this_ = this__;
    return _box(RegularPolygon_area(this_));
}

AnyGC* LoggedDataPoint_serialize(LoggedDataPointValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("{\"x\":")) + dart_str(this_->x) + dart_str(std::string(",\"y\":")) + dart_str(this_->y) + dart_str(std::string(",\"label\":\"")) + dart_str(this_->label) + dart_str(std::string("\"}")));
}

AnyGC* LoggedDataPoint_clone(LoggedDataPointValue* this__) {
    auto this_ = this__;
    return _box(DataPoint_new(GC::allocateLocal(new DataPointValue()), this_->x, this_->y, this_->label));
}

AnyGC* LoggedDataPoint_compareTo2(LoggedDataPointValue* this__, DataPointValue* other) {
    auto this_ = this__;
    double dx = (this_->x - other->x);
    if (!((dx == 0LL))) {
        return _box(((dx > 0LL) ? 1LL : (-1LL)));
    }
    double dy = (this_->y - other->y);
    if (!((dy == 0LL))) {
        return _box(((dy > 0LL) ? 1LL : (-1LL)));
    }
    return _box(0LL);
}

AnyGC* LoggedDataPoint_toString(LoggedDataPointValue* this__) {
    auto this_ = this__;
    return _box(DataPoint_toString(this_));
}

void LoggedDataPoint_log_(LoggedDataPointValue* this__, std::string message) {
    auto this_ = this__;
    staticPrint(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_logTag"]))(this_))) + dart_str(std::string("] ")) + dart_str(message));
    return;
}

AnyGC* LoggedDataPoint_validate(LoggedDataPointValue* this__) {
    auto this_ = this__;
    return _box(!dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["serialize"]))(this_)).empty());
}

AnyGC* Event_get_timestamp(EventValue* this__) {
    auto this_ = this__;
    return _box(1234567890LL);
}

AnyGC* Event_get_timeStr(EventValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("T:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_timestamp"]))(this_))));
}

void Event_addTag(EventValue* this__, std::string tag) {
    auto this_ = this__;
    this_->_tags->add(tag);
    return;
}

AnyGC* Event_get_tags(EventValue* this__) {
    auto this_ = this__;
    return _box(unmodifiable<std::string>(this_->_tags));
}

AnyGC* ImportantEvent_get_timestamp(ImportantEventValue* this__) {
    auto this_ = this__;
    return _box(1234567890LL);
}

AnyGC* ImportantEvent_get_timeStr(ImportantEventValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("T:")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_timestamp"]))(this_))));
}

void ImportantEvent_addTag(ImportantEventValue* this__, std::string tag) {
    auto this_ = this__;
    this_->_tags->add(tag);
    return;
}

AnyGC* ImportantEvent_get_tags(ImportantEventValue* this__) {
    auto this_ = this__;
    return _box(unmodifiable<std::string>(this_->_tags));
}

void ImportantEvent_log_(ImportantEventValue* this__, std::string message) {
    auto this_ = this__;
    staticPrint(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_logTag"]))(this_))) + dart_str(std::string("] ")) + dart_str(message));
    return;
}


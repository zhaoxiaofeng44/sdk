#include "dart2cpp_lowered.h"

template<typename T> struct Comparable2Value;
struct PrintableMixin;
template<typename T> struct SerializableMixin;
template<typename K> struct CacheableMixin;
struct ValidatableMixin;
template<typename ID> struct EntityValue;
template<typename ID> struct TimestampedEntityValue;
template<typename ID> struct VersionedEntityValue;
struct MoneyValue;
struct ConfigValue;
struct EventBusValue;
struct DrawableValue;
struct ResizableValue;
struct ClickableValue;
struct WidgetValue;
template<typename A, typename B> struct PairValue;
template<typename A, typename B, typename C> struct TripleValue;
struct StringBuilderValue;
struct AppErrorValue;
template<typename T> struct DataPipelineValue;
struct BoundedValueValue;
struct MathUtilsValue;
struct LoggableMixin;
template<typename T> struct ObservableMixin;
template<typename V> struct ReactiveStoreValue;
struct ShapeValue;
struct CircleValue;
struct RectangleValue;
template<typename T> struct NodeValue;
template<typename T> struct LabeledNodeValue;
struct Priority;
struct Color;
std::string Color_get_hex(Color* this__);
bool Color_get_isWarm(Color* this__);
std::string Printable_label(PrintableMixin* this__);
std::string Printable_toPrettyString(PrintableMixin* this__);
template<typename T> T Serializable_serialize(SerializableMixin<T>* this__);
template<typename T> std::string Serializable_toJson(SerializableMixin<T>* this__);
extern StaticMap<std::string, AnyGC*>* _cache;
template<typename K> K Cacheable_cacheKey(CacheableMixin<K>* this__);
template<typename K> void Cacheable_cacheValue(CacheableMixin<K>* this__, AnyGC* value);
template<typename K> AnyGC* Cacheable_getCachedValue(CacheableMixin<K>* this__);
template<typename K> void Cacheable_clearCache();
StaticList<std::string>* Validatable_validate(ValidatableMixin* this__);
bool Validatable_isValid(ValidatableMixin* this__);
void Loggable_log_(LoggableMixin* this__, std::string message);
StaticList<std::string>* Loggable_logs(LoggableMixin* this__);
template<typename T> void Observable_observe(ObservableMixin<T>* this__, TypeFunction1<void, T>* callback);
template<typename T> void Observable_notify(ObservableMixin<T>* this__, T value);
template<typename T> Comparable2Value<T>* Comparable2_new(Comparable2Value<T>* this__);
template<typename T> int64_t Comparable2_compareTo(Comparable2Value<T>* this__, T other);
template<typename T> bool Comparable2_lt(Comparable2Value<T>* this__, T other);
template<typename T> bool Comparable2_gt(Comparable2Value<T>* this__, T other);
template<typename T> bool Comparable2_le(Comparable2Value<T>* this__, T other);
template<typename T> bool Comparable2_ge(Comparable2Value<T>* this__, T other);
template<typename ID> EntityValue<ID>* Entity_new(EntityValue<ID>* this__, ID id, std::string name);
template<typename ID> std::string Entity_get_label(EntityValue<ID>* this__);
template<typename ID> ID Entity_get_cacheKey(EntityValue<ID>* this__);
template<typename ID> std::string Entity_toString(EntityValue<ID>* this__);
template<typename ID> TimestampedEntityValue<ID>* TimestampedEntity_new(TimestampedEntityValue<ID>* this__, ID id, std::string name, int64_t createdAt, int64_t updatedAt);
template<typename ID> StaticDuration TimestampedEntity_get_age(TimestampedEntityValue<ID>* this__);
template<typename ID> std::string TimestampedEntity_get_label(TimestampedEntityValue<ID>* this__);
template<typename ID> VersionedEntityValue<ID>* VersionedEntity_new(VersionedEntityValue<ID>* this__, ID id, std::string name, int64_t createdAt, int64_t updatedAt);
template<typename ID> int64_t VersionedEntity_get_version(VersionedEntityValue<ID>* this__);
template<typename ID> void VersionedEntity_bump(VersionedEntityValue<ID>* this__, std::string change);
template<typename ID> StaticList<std::string>* VersionedEntity_get_changelog(VersionedEntityValue<ID>* this__);
template<typename ID> std::string VersionedEntity_serialize(VersionedEntityValue<ID>* this__);
template<typename ID> StaticList<std::string>* VersionedEntity_validate(VersionedEntityValue<ID>* this__);
template<typename ID> std::string VersionedEntity_get_label(VersionedEntityValue<ID>* this__);
MoneyValue* Money_new(MoneyValue* this__, int64_t cents, std::string currency = std::string("USD"));
MoneyValue* Money_new_fromDollars(MoneyValue* this__, double dollars, std::string currency = std::string("USD"));
MoneyValue* Money_add(MoneyValue* this__, MoneyValue* other);
MoneyValue* Money_sub(MoneyValue* this__, MoneyValue* other);
MoneyValue* Money_mul(MoneyValue* this__, int64_t factor);
MoneyValue* Money_neg(MoneyValue* this__);
int64_t Money_compareTo(MoneyValue* this__, MoneyValue* other);
std::string Money_get_label(MoneyValue* this__);
std::string Money_toString(MoneyValue* this__);
ConfigValue* Config_new(ConfigValue* this__, StaticMap<std::string, AnyGC*>* _data);
ConfigValue* Config_new_empty(ConfigValue* this__);
ConfigValue* Config_new_fromPairs(ConfigValue* this__, StaticList<StaticList<AnyGC*>*>* pairs);
ConfigValue* Config_new_withDefaults(StaticMap<std::string, AnyGC*>* overrides);
AnyGC* Config_index(ConfigValue* this__, std::string key);
void Config_indexSet(ConfigValue* this__, std::string key, AnyGC* value);
bool Config_containsKey(ConfigValue* this__, std::string key);
int64_t Config_get_length(ConfigValue* this__);
std::string Config_toString(ConfigValue* this__);
EventBusValue* EventBus_new(EventBusValue* this__);
void EventBus_on(EventBusValue* this__, TypeFunction1<void, std::string>* listener);
void EventBus_emit(EventBusValue* this__, std::string event);
DrawableValue* Drawable_new(DrawableValue* this__);
void Drawable_draw(DrawableValue* this__);
ResizableValue* Resizable_new(ResizableValue* this__);
void Resizable_resize(ResizableValue* this__, double factor);
ClickableValue* Clickable_new(ClickableValue* this__);
void Clickable_onClick(ClickableValue* this__);
WidgetValue* Widget_new(WidgetValue* this__);
void Widget_draw(WidgetValue* this__);
void Widget_resize(WidgetValue* this__, double factor);
void Widget_onClick(WidgetValue* this__);
std::string Widget_get_info(WidgetValue* this__);
template<typename A, typename B> PairValue<A, B>* Pair_new(PairValue<A, B>* this__, A first, B second);
template<typename A, typename B> PairValue<B, A>* Pair_swap(PairValue<A, B>* this__);
template<typename A, typename B, typename C> PairValue<C, B>* Pair_mapFirst(PairValue<A, B>* this__, TypeFunction1<C, A>* transform);
template<typename A, typename B, typename C> PairValue<A, C>* Pair_mapSecond(PairValue<A, B>* this__, TypeFunction1<C, B>* transform);
template<typename A, typename B, typename R> R Pair_fold(PairValue<A, B>* this__, TypeFunction2<R, A, B>* combine);
template<typename A, typename B> std::string Pair_toString(PairValue<A, B>* this__);
template<typename A, typename B, typename C> TripleValue<A, B, C>* Triple_new(TripleValue<A, B, C>* this__, A first, B second, C third);
template<typename A, typename B, typename C> std::string Triple_toString(TripleValue<A, B, C>* this__);
StringBuilderValue* StringBuilder_new(StringBuilderValue* this__);
StringBuilderValue* StringBuilder_withSeparator(StringBuilderValue* this__, std::string sep);
StringBuilderValue* StringBuilder_add(StringBuilderValue* this__, std::string text);
StringBuilderValue* StringBuilder_addAll(StringBuilderValue* this__, StaticList<std::string>* texts);
int64_t StringBuilder_get_length(StringBuilderValue* this__);
std::string StringBuilder_toString(StringBuilderValue* this__);
AppErrorValue* AppError_new(AppErrorValue* this__, std::string message, std::string code, AppErrorValue* cause = nullptr);
std::string AppError_toString(AppErrorValue* this__);
template<typename T> DataPipelineValue<T>* DataPipeline_new(DataPipelineValue<T>* this__, StaticList<T>* _data);
template<typename T> DataPipelineValue<T>* DataPipeline_where(DataPipelineValue<T>* this__, TypeFunction1<bool, T>* test);
template<typename T, typename R> DataPipelineValue<R>* DataPipeline_map(DataPipelineValue<T>* this__, TypeFunction1<R, T>* transform);
template<typename T> DataPipelineValue<T>* DataPipeline_sorted(DataPipelineValue<T>* this__, TypeFunction2<int64_t, T, T>* compare);
template<typename T> DataPipelineValue<T>* DataPipeline_take(DataPipelineValue<T>* this__, int64_t count);
template<typename T, typename R> R DataPipeline_fold(DataPipelineValue<T>* this__, R initial, TypeFunction2<R, R, T>* combine);
template<typename T> StaticList<T>* DataPipeline_toList(DataPipelineValue<T>* this__);
template<typename T> std::string DataPipeline_toString(DataPipelineValue<T>* this__);
BoundedValueValue* BoundedValue_new(BoundedValueValue* this__, double _value, double _min, double _max);
double BoundedValue_get_value(BoundedValueValue* this__);
void BoundedValue_set_value(BoundedValueValue* this__, double v);
void BoundedValue__clamp(BoundedValueValue* this__);
BoundedValueValue* BoundedValue_add(BoundedValueValue* this__, double delta);
std::string BoundedValue_toString(BoundedValueValue* this__);
MathUtilsValue* MathUtils_new(MathUtilsValue* this__);
int64_t MathUtils_get_callCount();
int64_t MathUtils_factorial(int64_t n);
StaticList<int64_t>* MathUtils_fibonacci(int64_t count);
double MathUtils_lerp(double a, double b, double t);
template<typename V> ReactiveStoreValue<V>* ReactiveStore_new(ReactiveStoreValue<V>* this__);
template<typename V> V ReactiveStore_get(ReactiveStoreValue<V>* this__, std::string key);
template<typename V> void ReactiveStore_set(ReactiveStoreValue<V>* this__, std::string key, V value);
template<typename V> int64_t ReactiveStore_get_size(ReactiveStoreValue<V>* this__);
template<typename V> std::string ReactiveStore_toString(ReactiveStoreValue<V>* this__);
ShapeValue* Shape_new(ShapeValue* this__);
double Shape_area(ShapeValue* this__);
std::string Shape_get_shapeName(ShapeValue* this__);
CircleValue* Circle_new(CircleValue* this__, double radius);
double Circle_area(CircleValue* this__);
std::string Circle_get_shapeName(CircleValue* this__);
std::string Circle_toString(CircleValue* this__);
RectangleValue* Rectangle_new(RectangleValue* this__, double width, double height);
double Rectangle_area(RectangleValue* this__);
std::string Rectangle_get_shapeName(RectangleValue* this__);
std::string Rectangle_toString(RectangleValue* this__);
template<typename T> NodeValue<T>* Node_new(NodeValue<T>* this__, T value, StaticList<NodeValue<T>*>* children = nullptr);
template<typename T> void Node_addChild(NodeValue<T>* this__, NodeValue<T>* child);
template<typename T> StaticList<T>* Node_flatten(NodeValue<T>* this__);
template<typename T, typename R> NodeValue<R>* Node_mapTree(NodeValue<T>* this__, TypeFunction1<R, T>* transform);
template<typename T> std::string Node_toString(NodeValue<T>* this__);
template<typename T> LabeledNodeValue<T>* LabeledNode_new(LabeledNodeValue<T>* this__, std::string nodeLabel, T value, StaticList<NodeValue<T>*>* children = nullptr);
template<typename T> std::string LabeledNode_get_label(LabeledNodeValue<T>* this__);
template<typename T> std::string LabeledNode_toString(LabeledNodeValue<T>* this__);
template<typename T> T applyTransform(T value, TypeFunction1<T, T>* transform);
template<typename T> StaticList<T>* filterWith(StaticList<T>* items, TypeFunction1<bool, T>* predicate);
template<typename T> T reduceList(StaticList<T>* items, TypeFunction2<T, T, T>* reducer);
StaticList<std::string>* testClosureBoxing();
std::string testExceptionChain();
std::string formatRecord(std::string name, int64_t age, std::string email, bool active, StaticList<std::string>* tags);
std::string greetAll(std::string greeting, std::string name, std::string suffix);
std::string describeShape(ShapeValue* shape);
std::string evaluateGrade(int64_t score);
int main();
template<typename ID> AnyGC* Entity_Object_Printable_toPrettyString(EntityValue<ID>* this__);
template<typename ID> void Entity_Object_Printable_Cacheable_cacheValue(EntityValue<ID>* this__, AnyGC* value);
template<typename ID> AnyGC* Entity_Object_Printable_Cacheable_getCachedValue(EntityValue<ID>* this__);
template<typename ID> AnyGC* VersionedEntity_TimestampedEntity_Serializable_toJson(VersionedEntityValue<ID>* this__);
template<typename ID> AnyGC* VersionedEntity_TimestampedEntity_Serializable_Validatable_get_isValid(VersionedEntityValue<ID>* this__);
AnyGC* Money_Comparable2_Printable_toPrettyString(MoneyValue* this__);
template<typename V> void ReactiveStore_log_(ReactiveStoreValue<V>* this__, std::string message);
template<typename V> AnyGC* ReactiveStore_Object_Loggable_get_logs(ReactiveStoreValue<V>* this__);
template<typename V> void ReactiveStore_Object_Loggable_Observable_observe(ReactiveStoreValue<V>* this__, TypeFunction1<void, V>* callback);
template<typename V> void ReactiveStore_Object_Loggable_Observable_notify(ReactiveStoreValue<V>* this__, V value);
template<typename T> AnyGC* LabeledNode_Node_Printable_toPrettyString(LabeledNodeValue<T>* this__);
std::string formatRecord(std::string name, int64_t age = 0, std::string email = "", bool active = true, StaticList<std::string>* tags = GC::allocateLocal(new StaticList<std::string>()));
std::string greetAll(std::string greeting, std::string name = std::string("World"), std::string suffix = std::string("!"));
template<typename ID> AnyGC* Entity_toPrettyString(EntityValue<ID>* this__);
template<typename ID> void Entity_cacheValue(EntityValue<ID>* this__, AnyGC* value);
template<typename ID> AnyGC* Entity_getCachedValue(EntityValue<ID>* this__);
template<typename ID> AnyGC* TimestampedEntity_toPrettyString(TimestampedEntityValue<ID>* this__);
template<typename ID> AnyGC* TimestampedEntity_get_cacheKey(TimestampedEntityValue<ID>* this__);
template<typename ID> void TimestampedEntity_cacheValue(TimestampedEntityValue<ID>* this__, AnyGC* value);
template<typename ID> AnyGC* TimestampedEntity_getCachedValue(TimestampedEntityValue<ID>* this__);
template<typename ID> AnyGC* TimestampedEntity_toString(TimestampedEntityValue<ID>* this__);
template<typename ID> AnyGC* VersionedEntity_toPrettyString(VersionedEntityValue<ID>* this__);
template<typename ID> AnyGC* VersionedEntity_get_cacheKey(VersionedEntityValue<ID>* this__);
template<typename ID> void VersionedEntity_cacheValue(VersionedEntityValue<ID>* this__, AnyGC* value);
template<typename ID> AnyGC* VersionedEntity_getCachedValue(VersionedEntityValue<ID>* this__);
template<typename ID> AnyGC* VersionedEntity_toString(VersionedEntityValue<ID>* this__);
template<typename ID> AnyGC* VersionedEntity_get_age(VersionedEntityValue<ID>* this__);
template<typename ID> AnyGC* VersionedEntity_toJson(VersionedEntityValue<ID>* this__);
template<typename ID> AnyGC* VersionedEntity_get_isValid(VersionedEntityValue<ID>* this__);
AnyGC* Money_lt(MoneyValue* this__, AnyGC* other);
AnyGC* Money_gt(MoneyValue* this__, AnyGC* other);
AnyGC* Money_le(MoneyValue* this__, AnyGC* other);
AnyGC* Money_ge(MoneyValue* this__, AnyGC* other);
AnyGC* Money_toPrettyString(MoneyValue* this__);
template<typename A, typename B, typename C> AnyGC* Triple_swap(TripleValue<A, B, C>* this__);
template<typename A, typename B, typename C> AnyGC* Triple_mapFirst(TripleValue<A, B, C>* this__, TypeFunction1<C, A>* transform);
template<typename A, typename B, typename C> AnyGC* Triple_mapSecond(TripleValue<A, B, C>* this__, TypeFunction1<C, B>* transform);
template<typename A, typename B, typename C, typename R> AnyGC* Triple_fold(TripleValue<A, B, C>* this__, TypeFunction2<R, A, B>* combine);
template<typename V> AnyGC* ReactiveStore_get_logs(ReactiveStoreValue<V>* this__);
template<typename V> void ReactiveStore_observe(ReactiveStoreValue<V>* this__, TypeFunction1<void, V>* callback);
template<typename V> void ReactiveStore_notify(ReactiveStoreValue<V>* this__, V value);
template<typename T> void LabeledNode_addChild(LabeledNodeValue<T>* this__, NodeValue<T>* child);
template<typename T> AnyGC* LabeledNode_flatten(LabeledNodeValue<T>* this__);
template<typename T, typename R> AnyGC* LabeledNode_mapTree(LabeledNodeValue<T>* this__, TypeFunction1<R, T>* transform);
template<typename T> AnyGC* LabeledNode_toPrettyString(LabeledNodeValue<T>* this__);

struct Priority : VPtr {
    std::string _name;
    int64_t _index;

    static Priority* low;
    static Priority* medium;
    static Priority* high;
    static Priority* critical;
    static Priority* values;

    Priority(std::string n, int64_t i) : _name(std::move(n)), _index(i) {}

    std::string toString() const override { return "Priority." + _name; }
};

Priority* Priority::low = new Priority("low", 0);
Priority* Priority::medium = new Priority("medium", 1);
Priority* Priority::high = new Priority("high", 2);
Priority* Priority::critical = new Priority("critical", 3);
Priority* Priority::values = new Priority("values", 4);

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

struct PrintableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> PrintableMixin::_vptrMap;


template<typename T>
struct SerializableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
template<typename T> std::unordered_map<std::string, void*> SerializableMixin<T>::_vptrMap;


template<typename K>
struct CacheableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
template<typename K> std::unordered_map<std::string, void*> CacheableMixin<K>::_vptrMap;


struct ValidatableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> ValidatableMixin::_vptrMap;


struct LoggableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
    StaticList<std::string>* _logs{nullptr};
};
std::unordered_map<std::string, void*> LoggableMixin::_vptrMap;


template<typename T>
struct ObservableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
    StaticList<TypeFunction1<void, T>*>* _observers{nullptr};
};
template<typename T> std::unordered_map<std::string, void*> ObservableMixin<T>::_vptrMap;


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

template<typename ID>
struct EntityValue : VPtr {
    ID id{};
    std::string name{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename ID> std::unordered_map<std::string, void*> EntityValue<ID>::_vptrMap;

template<typename ID>
struct TimestampedEntityValue : EntityValue<ID> {
    int64_t createdAt{0};
    int64_t updatedAt{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        EntityValue<ID>::gcMark(flag);
    }
};

template<typename ID> std::unordered_map<std::string, void*> TimestampedEntityValue<ID>::_vptrMap;

template<typename ID>
struct VersionedEntityValue : TimestampedEntityValue<ID> {
    int64_t _version{0};
    StaticList<std::string>* _changelog{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        TimestampedEntityValue<ID>::gcMark(flag);
        if (_changelog) _changelog->gcMark(flag);
    }
};

template<typename ID> std::unordered_map<std::string, void*> VersionedEntityValue<ID>::_vptrMap;

struct MoneyValue : Comparable2Value<AnyGC*> {
    int64_t cents{0};
    std::string currency{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        Comparable2Value<AnyGC*>::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> MoneyValue::_vptrMap;

struct ConfigValue : VPtr {
    StaticMap<std::string, AnyGC*>* _data{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_data) _data->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ConfigValue::_vptrMap;

struct ClosureEnv_0 : TypeFunction1<std::string, std::string> {
    ConfigValue* this_;
    ClosureEnv_0(ConfigValue* this_) : this_(this_) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    std::string call(std::string k) {
    return dart_str(k) + dart_str(std::string("=")) + dart_str(_box(*(*this_->_data)[k]));
    }
};

struct EventBusValue : VPtr {
    StaticList<TypeFunction1<void, std::string>*>* _listeners{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_listeners) _listeners->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> EventBusValue::_vptrMap;

struct DrawableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DrawableValue::_vptrMap;

struct ResizableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ResizableValue::_vptrMap;

struct ClickableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ClickableValue::_vptrMap;

struct WidgetValue : DrawableValue {
    std::string _state{""};
    double _scale{0.0};
    int64_t _clickCount{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        DrawableValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> WidgetValue::_vptrMap;

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

template<typename A, typename B, typename C>
struct TripleValue : PairValue<A, B> {
    C third{};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        PairValue<A, B>::gcMark(flag);
    }
};

template<typename A, typename B, typename C> std::unordered_map<std::string, void*> TripleValue<A, B, C>::_vptrMap;

struct StringBuilderValue : VPtr {
    StaticStringBuffer* _buf{nullptr};
    std::string _separator{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_buf) _buf->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> StringBuilderValue::_vptrMap;

struct AppErrorValue : VPtr {
    std::string message{""};
    std::string code{""};
    AppErrorValue* cause{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (cause) cause->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> AppErrorValue::_vptrMap;

template<typename T>
struct DataPipelineValue : VPtr {
    StaticList<T>* _data{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_data) _data->gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> DataPipelineValue<T>::_vptrMap;

struct BoundedValueValue : VPtr {
    double _value{0.0};
    double _min{0.0};
    double _max{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> BoundedValueValue::_vptrMap;

struct MathUtilsValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> MathUtilsValue::_vptrMap;

template<typename V>
struct ReactiveStoreValue : VPtr {
    StaticMap<std::string, V>* _store{nullptr};
    StaticList<TypeFunction1<void, V>*>* _observers{nullptr};
    StaticList<std::string>* _logs{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_store) _store->gcMark(flag);
        if (_observers) _observers->gcMark(flag);
        if (_logs) _logs->gcMark(flag);
    }
};

template<typename V> std::unordered_map<std::string, void*> ReactiveStoreValue<V>::_vptrMap;

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

template<typename T>
struct NodeValue : VPtr {
    T value{};
    StaticList<NodeValue<T>*>* children{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (children) children->gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> NodeValue<T>::_vptrMap;

template<typename R, typename T>
struct ClosureEnv_1 : TypeFunction1<NodeValue<R>*, NodeValue<T>*> {
    TypeFunction1<R, T>* transform;
    ClosureEnv_1(TypeFunction1<R, T>* transform) : transform(std::move(transform)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<NodeValue<T>*>(_p0)));
    }
    NodeValue<R>* call(NodeValue<T>* c) {
    return reinterpret_cast<NodeValue<R>*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(c->getVptrMap()["mapTree"]))(c, _box(transform)));
    }
};

template<typename T>
struct LabeledNodeValue : NodeValue<T> {
    std::string nodeLabel{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        NodeValue<T>::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> LabeledNodeValue<T>::_vptrMap;

struct ClosureEnv_2 : TypeFunction0<int64_t> {
    IntBox* counter;
    ClosureEnv_2(IntBox* counter) : counter(counter) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
    (counter->value = (counter->value + 1LL));
    return counter->value;
    }
};

struct ClosureEnv_3 : TypeFunction0<int64_t> {
    int64_t i;
    ClosureEnv_3(int64_t i) : i(std::move(i)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_3*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
        return (i * 10LL);
    }
};

struct ClosureEnv_4 : TypeFunction1<int64_t, TypeFunction0<int64_t>*> {
    ClosureEnv_4() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_4*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<TypeFunction0<int64_t>*>(_p0)));
    }
    int64_t call(TypeFunction0<int64_t>* f) {
return f->call();
    }
};

struct ClosureEnv_6 : TypeFunction1<int64_t, int64_t> {
    IntBox* inner;
    IntBox* outer;
    ClosureEnv_6(IntBox* inner, IntBox* outer) : inner(inner), outer(outer) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_6*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t x) {
    (inner->value = (inner->value + x));
    (outer->value = (outer->value + x));
    return inner->value;
    }
};

struct ClosureEnv_5 : TypeFunction1<TypeFunction1<int64_t, int64_t>*, int64_t> {
    IntBox* outer;
    ClosureEnv_5(IntBox* outer) : outer(outer) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_5*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    TypeFunction1<int64_t, int64_t>* call(int64_t base) {
    IntBox* inner = new IntBox(base);
    return GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_6(inner, outer)));
    }
};

struct ClosureEnv_7 : TypeFunction0<std::string> {
    IntBox* count;
    std::string prefix;
    ClosureEnv_7(IntBox* count, std::string prefix) : count(count), prefix(std::move(prefix)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_7*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
        (count->value = (count->value + 1LL));
        return dart_str(prefix) + dart_str(std::string("-")) + dart_str(count->value);
    }
};

struct ClosureEnv_8 : TypeFunction1<void, std::string> {
    StaticList<std::string>* received;
    ClosureEnv_8(StaticList<std::string>* received) : received(std::move(received)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_8*>(dynamic_cast<TypeFunction*>(_env));
        _self->call(dynAs<std::string>(_p0));
        return nullptr;
    }
    void call(std::string event) {
received->add(event);
    }
};

struct ClosureEnv_9 : TypeFunction1<int64_t, int64_t> {
    ClosureEnv_9() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_9*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t x) {
    return (x * 2LL);
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
    bool call(int64_t x) {
    return ((x % 2LL) == 0LL);
    }
};

struct ClosureEnv_11 : TypeFunction2<int64_t, int64_t, int64_t> {
    ClosureEnv_11() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_11*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0), dynAs<int64_t>(_p1)));
    }
    int64_t call(int64_t a, int64_t b) {
    return (a + b);
    }
};

struct ClosureEnv_12 : TypeFunction1<std::string, Priority*> {
    ClosureEnv_12() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_12*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<Priority*>(_p0)));
    }
    std::string call(Priority* p) {
    return dart_str_split(dart_str(p), std::string("."))->last();
    }
};

struct ClosureEnv_13 : TypeFunction1<int64_t, int64_t> {
    ClosureEnv_13() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_13*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t x) {
    return (x * 2LL);
    }
};

struct ClosureEnv_14 : TypeFunction1<std::string, std::string> {
    ClosureEnv_14() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_14*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    std::string call(std::string s) {
    return dart_str_toUpper(s);
    }
};

struct ClosureEnv_15 : TypeFunction2<std::string, int64_t, std::string> {
    ClosureEnv_15() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_15*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0), dynAs<std::string>(_p1)));
    }
    std::string call(int64_t a, std::string b) {
    return dart_str(b) + dart_str(std::string("=")) + dart_str(a);
    }
};

struct ClosureEnv_16 : TypeFunction1<bool, int64_t> {
    ClosureEnv_16() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_16*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    bool call(int64_t x) {
    return (x > 2LL);
    }
};

struct ClosureEnv_17 : TypeFunction2<int64_t, int64_t, int64_t> {
    ClosureEnv_17() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_17*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0), dynAs<int64_t>(_p1)));
    }
    int64_t call(int64_t a, int64_t b) {
    return (a - b);
    }
};

struct ClosureEnv_18 : TypeFunction1<int64_t, int64_t> {
    ClosureEnv_18() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_18*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t x) {
    return (x * 10LL);
    }
};

struct ClosureEnv_19 : TypeFunction2<int64_t, int64_t, int64_t> {
    ClosureEnv_19() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_19*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0), dynAs<int64_t>(_p1)));
    }
    int64_t call(int64_t acc, int64_t x) {
    return (acc + x);
    }
};

struct ClosureEnv_20 : TypeFunction1<void, int64_t> {
    StaticList<int64_t>* observed;
    ClosureEnv_20(StaticList<int64_t>* observed) : observed(std::move(observed)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_20*>(dynamic_cast<TypeFunction*>(_env));
        _self->call(dynAs<int64_t>(_p0));
        return nullptr;
    }
    void call(int64_t v) {
    observed->add(v);
    }
};


std::string Color_get_hex(Color* this__) {
    auto this_ = this__;
    _L0:
    do {
        switch (this_->_index) {
            _sw_case_0:
            case 0:
            {
                return std::string("#FF0000");
                break;
            }
            _sw_case_1:
            case 1:
            {
                return std::string("#00FF00");
                break;
            }
            _sw_case_2:
            case 2:
            {
                return std::string("#0000FF");
                break;
            }
        }
    } while (false);
}

AnyGC* _vptr_wrap_Color_get_hex(AnyGC* obj__) {
    return _box(Color_get_hex(static_cast<Color*>(obj__)));
}

static bool _Color_hex_registered = []{ Color::_vptrMap["get_hex"] = reinterpret_cast<void*>(&_vptr_wrap_Color_get_hex); return true; }();
bool Color_get_isWarm(Color* this__) {
    auto this_ = this__;
    return (this_ == Color::red);
}

AnyGC* _vptr_wrap_Color_get_isWarm(AnyGC* obj__) {
    return _box(Color_get_isWarm(static_cast<Color*>(obj__)));
}

static bool _Color_isWarm_registered = []{ Color::_vptrMap["get_isWarm"] = reinterpret_cast<void*>(&_vptr_wrap_Color_get_isWarm); return true; }();
std::string Printable_label(PrintableMixin* this__) {
    auto this_ = this__;
    return "";
}

std::string Printable_toPrettyString(PrintableMixin* this__) {
    auto this_ = this__;
    return dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_))) + dart_str(std::string("]"));
}

template<typename T>
T Serializable_serialize(SerializableMixin<T>* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Serializable.serialize")));
}

template<typename T>
std::string Serializable_toJson(SerializableMixin<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("{\"data\": \"")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["serialize"]))(this_)) + dart_str(std::string("\"}"));
}

StaticMap<std::string, AnyGC*>* _cache = StaticMap<std::string, AnyGC*>::empty();
template<typename K>
K Cacheable_cacheKey(CacheableMixin<K>* this__) {
    auto this_ = this__;
    return K{};
}

template<typename K>
void Cacheable_cacheValue(CacheableMixin<K>* this__, AnyGC* value) {
    auto this_ = this__;
    _cache->set(dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheKey"]))(this_)), value);
}

template<typename K>
AnyGC* Cacheable_getCachedValue(CacheableMixin<K>* this__) {
    auto this_ = this__;
    return _box(*(*_cache)[dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheKey"]))(this_))]);
}

template<typename K>
void Cacheable_clearCache() {
    _cache->clear();
}

StaticList<std::string>* Validatable_validate(ValidatableMixin* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Validatable.validate")));
}

bool Validatable_isValid(ValidatableMixin* this__) {
    auto this_ = this__;
    return static_cast<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["validate"]))(this_))->isEmpty();
}

void Loggable_log_(LoggableMixin* this__, std::string message) {
    auto this_ = this__;
    this_->_logs->add(message);
}

StaticList<std::string>* Loggable_logs(LoggableMixin* this__) {
    auto this_ = this__;
    return unmodifiable<std::string>(this_->_logs);
}

template<typename T>
void Observable_observe(ObservableMixin<T>* this__, TypeFunction1<void, T>* callback) {
    auto this_ = this__;
    this_->_observers->add(callback);
}

template<typename T>
void Observable_notify(ObservableMixin<T>* this__, T value) {
    auto this_ = this__;
    StaticIterator<TypeFunction1<void, T>*>* sync_for_iterator = this_->_observers->iterator();
    while (sync_for_iterator->moveNext()) {
        TypeFunction1<void, T>* cb = sync_for_iterator->current();
        cb->call(value);
    }
}

template<typename T>
AnyGC* _vptr_wrap_Comparable2_compareTo(AnyGC* obj__, AnyGC* arg0) {
    return _box(Comparable2_compareTo<T>(static_cast<Comparable2Value<T>*>(obj__), dynAs<T>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_Comparable2_lt(AnyGC* obj__, AnyGC* arg0) {
    return _box(Comparable2_lt<T>(static_cast<Comparable2Value<T>*>(obj__), dynAs<T>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_Comparable2_gt(AnyGC* obj__, AnyGC* arg0) {
    return _box(Comparable2_gt<T>(static_cast<Comparable2Value<T>*>(obj__), dynAs<T>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_Comparable2_le(AnyGC* obj__, AnyGC* arg0) {
    return _box(Comparable2_le<T>(static_cast<Comparable2Value<T>*>(obj__), dynAs<T>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_Comparable2_ge(AnyGC* obj__, AnyGC* arg0) {
    return _box(Comparable2_ge<T>(static_cast<Comparable2Value<T>*>(obj__), dynAs<T>(arg0)));
}

template<typename T> void _register_Comparable2_vptr() {
    if (Comparable2Value<T>::_vptrMap.empty()) {
        Comparable2Value<T>::_vptrMap["compareTo"] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_compareTo<T>);
        Comparable2Value<T>::_vptrMap["<"] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_lt<T>);
        Comparable2Value<T>::_vptrMap[">"] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_gt<T>);
        Comparable2Value<T>::_vptrMap["<="] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_le<T>);
        Comparable2Value<T>::_vptrMap[">="] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_ge<T>);
    }
}
template<typename T>
Comparable2Value<T>* Comparable2_new(Comparable2Value<T>* this__) {
    auto this_ = this__;
    if (Comparable2Value<T>::_vptrMap.empty()) {
        Comparable2Value<T>::_vptrMap["compareTo"] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_compareTo<T>);
        Comparable2Value<T>::_vptrMap["<"] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_lt<T>);
        Comparable2Value<T>::_vptrMap[">"] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_gt<T>);
        Comparable2Value<T>::_vptrMap["<="] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_le<T>);
        Comparable2Value<T>::_vptrMap[">="] = reinterpret_cast<void*>(&_vptr_wrap_Comparable2_ge<T>);
    }
    return this_;
}

template<typename T>
int64_t Comparable2_compareTo(Comparable2Value<T>* this__, T other) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Comparable2.compareTo")));
}

template<typename T>
bool Comparable2_lt(Comparable2Value<T>* this__, T other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo"]))(this_, _box(other))) < 0LL);
}

template<typename T>
bool Comparable2_gt(Comparable2Value<T>* this__, T other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo"]))(this_, _box(other))) > 0LL);
}

template<typename T>
bool Comparable2_le(Comparable2Value<T>* this__, T other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo"]))(this_, _box(other))) <= 0LL);
}

template<typename T>
bool Comparable2_ge(Comparable2Value<T>* this__, T other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo"]))(this_, _box(other))) >= 0LL);
}

template<typename ID>
AnyGC* _vptr_wrap_Entity_get_label(AnyGC* obj__) {
    return _box(Entity_get_label<ID>(static_cast<EntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_Entity_toPrettyString(AnyGC* obj__) {
    return _box(Entity_toPrettyString<ID>(static_cast<EntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_Entity_get_cacheKey(AnyGC* obj__) {
    return _box(Entity_get_cacheKey<ID>(static_cast<EntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_Entity_cacheValue(AnyGC* obj__, AnyGC* arg0) {
    Entity_cacheValue<ID>(static_cast<EntityValue<ID>*>(obj__), arg0);
    return nullptr;
}

template<typename ID>
AnyGC* _vptr_wrap_Entity_getCachedValue(AnyGC* obj__) {
    return _box(Entity_getCachedValue<ID>(static_cast<EntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_Entity_toString(AnyGC* obj__) {
    return _box(Entity_toString<ID>(static_cast<EntityValue<ID>*>(obj__)));
}

template<typename ID> void _register_Entity_vptr() {
    if (EntityValue<ID>::_vptrMap.empty()) {
        EntityValue<ID>::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_get_label<ID>);
        EntityValue<ID>::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_toPrettyString<ID>);
        EntityValue<ID>::_vptrMap["get_cacheKey"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_get_cacheKey<ID>);
        EntityValue<ID>::_vptrMap["cacheValue"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_cacheValue<ID>);
        EntityValue<ID>::_vptrMap["getCachedValue"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_getCachedValue<ID>);
        EntityValue<ID>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_toString<ID>);
    }
}
template<typename ID>
EntityValue<ID>* Entity_new(EntityValue<ID>* this__, ID id, std::string name) {
    auto this_ = this__;
    if (EntityValue<ID>::_vptrMap.empty()) {
        EntityValue<ID>::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_get_label<ID>);
        EntityValue<ID>::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_toPrettyString<ID>);
        EntityValue<ID>::_vptrMap["get_cacheKey"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_get_cacheKey<ID>);
        EntityValue<ID>::_vptrMap["cacheValue"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_cacheValue<ID>);
        EntityValue<ID>::_vptrMap["getCachedValue"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_getCachedValue<ID>);
        EntityValue<ID>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_toString<ID>);
    }
    this_->id = id;
    this_->name = name;
    return this_;
}

template<typename ID>
std::string Entity_get_label(EntityValue<ID>* this__) {
    auto this_ = this__;
    return dart_str(this_->name) + dart_str(std::string("(")) + dart_str(this_->id) + dart_str(std::string(")"));
}

template<typename ID>
ID Entity_get_cacheKey(EntityValue<ID>* this__) {
    auto this_ = this__;
    return this_->id;
}

template<typename ID>
std::string Entity_toString(EntityValue<ID>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Entity(")) + dart_str(this_->id) + dart_str(std::string(", ")) + dart_str(this_->name) + dart_str(std::string(")"));
}

template<typename ID>
AnyGC* _vptr_wrap_TimestampedEntity_get_label(AnyGC* obj__) {
    return _box(TimestampedEntity_get_label<ID>(static_cast<TimestampedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_TimestampedEntity_toPrettyString(AnyGC* obj__) {
    return _box(TimestampedEntity_toPrettyString<ID>(static_cast<TimestampedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_TimestampedEntity_get_cacheKey(AnyGC* obj__) {
    return _box(TimestampedEntity_get_cacheKey<ID>(static_cast<TimestampedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_TimestampedEntity_cacheValue(AnyGC* obj__, AnyGC* arg0) {
    TimestampedEntity_cacheValue<ID>(static_cast<TimestampedEntityValue<ID>*>(obj__), arg0);
    return nullptr;
}

template<typename ID>
AnyGC* _vptr_wrap_TimestampedEntity_getCachedValue(AnyGC* obj__) {
    return _box(TimestampedEntity_getCachedValue<ID>(static_cast<TimestampedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_TimestampedEntity_toString(AnyGC* obj__) {
    return _box(TimestampedEntity_toString<ID>(static_cast<TimestampedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_TimestampedEntity_get_age(AnyGC* obj__) {
    return _box(TimestampedEntity_get_age<ID>(static_cast<TimestampedEntityValue<ID>*>(obj__)));
}

template<typename ID> void _register_TimestampedEntity_vptr() {
    if (TimestampedEntityValue<ID>::_vptrMap.empty()) {
        TimestampedEntityValue<ID>::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_get_label<ID>);
        TimestampedEntityValue<ID>::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_toPrettyString<ID>);
        TimestampedEntityValue<ID>::_vptrMap["get_cacheKey"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_get_cacheKey<ID>);
        TimestampedEntityValue<ID>::_vptrMap["cacheValue"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_cacheValue<ID>);
        TimestampedEntityValue<ID>::_vptrMap["getCachedValue"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_getCachedValue<ID>);
        TimestampedEntityValue<ID>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_toString<ID>);
        TimestampedEntityValue<ID>::_vptrMap["get_age"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_get_age<ID>);
    }
}
template<typename ID>
TimestampedEntityValue<ID>* TimestampedEntity_new(TimestampedEntityValue<ID>* this__, ID id, std::string name, int64_t createdAt, int64_t updatedAt) {
    auto this_ = this__;
    if (TimestampedEntityValue<ID>::_vptrMap.empty()) {
        TimestampedEntityValue<ID>::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_get_label<ID>);
        TimestampedEntityValue<ID>::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_toPrettyString<ID>);
        TimestampedEntityValue<ID>::_vptrMap["get_cacheKey"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_get_cacheKey<ID>);
        TimestampedEntityValue<ID>::_vptrMap["cacheValue"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_cacheValue<ID>);
        TimestampedEntityValue<ID>::_vptrMap["getCachedValue"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_getCachedValue<ID>);
        TimestampedEntityValue<ID>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_toString<ID>);
        TimestampedEntityValue<ID>::_vptrMap["get_age"] = reinterpret_cast<void*>(&_vptr_wrap_TimestampedEntity_get_age<ID>);
    }
    this_->createdAt = createdAt;
    this_->updatedAt = updatedAt;
    Entity_new<ID>(this_, id, name);
    return this_;
}

template<typename ID>
StaticDuration TimestampedEntity_get_age(TimestampedEntityValue<ID>* this__) {
    auto this_ = this__;
    return StaticDuration::milliseconds((this_->updatedAt - this_->createdAt));
}

template<typename ID>
std::string TimestampedEntity_get_label(TimestampedEntityValue<ID>* this__) {
    auto this_ = this__;
    return dart_str(this_->name) + dart_str(std::string("(")) + dart_str(this_->id) + dart_str(std::string(", age=")) + dart_str((*static_cast<StaticDuration*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_age"]))(this_))).inMilliseconds()) + dart_str(std::string("ms)"));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_get_label(AnyGC* obj__) {
    return _box(VersionedEntity_get_label<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_toPrettyString(AnyGC* obj__) {
    return _box(VersionedEntity_toPrettyString<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_get_cacheKey(AnyGC* obj__) {
    return _box(VersionedEntity_get_cacheKey<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_cacheValue(AnyGC* obj__, AnyGC* arg0) {
    VersionedEntity_cacheValue<ID>(static_cast<VersionedEntityValue<ID>*>(obj__), arg0);
    return nullptr;
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_getCachedValue(AnyGC* obj__) {
    return _box(VersionedEntity_getCachedValue<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_toString(AnyGC* obj__) {
    return _box(VersionedEntity_toString<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_get_age(AnyGC* obj__) {
    return _box(VersionedEntity_get_age<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_serialize(AnyGC* obj__) {
    return _box(VersionedEntity_serialize<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_toJson(AnyGC* obj__) {
    return _box(VersionedEntity_toJson<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_validate(AnyGC* obj__) {
    return _box(VersionedEntity_validate<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_get_isValid(AnyGC* obj__) {
    return _box(VersionedEntity_get_isValid<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_get_version(AnyGC* obj__) {
    return _box(VersionedEntity_get_version<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_bump(AnyGC* obj__, AnyGC* arg0) {
    VersionedEntity_bump<ID>(static_cast<VersionedEntityValue<ID>*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

template<typename ID>
AnyGC* _vptr_wrap_VersionedEntity_get_changelog(AnyGC* obj__) {
    return _box(VersionedEntity_get_changelog<ID>(static_cast<VersionedEntityValue<ID>*>(obj__)));
}

template<typename ID> void _register_VersionedEntity_vptr() {
    if (VersionedEntityValue<ID>::_vptrMap.empty()) {
        VersionedEntityValue<ID>::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_label<ID>);
        VersionedEntityValue<ID>::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_toPrettyString<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_cacheKey"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_cacheKey<ID>);
        VersionedEntityValue<ID>::_vptrMap["cacheValue"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_cacheValue<ID>);
        VersionedEntityValue<ID>::_vptrMap["getCachedValue"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_getCachedValue<ID>);
        VersionedEntityValue<ID>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_toString<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_age"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_age<ID>);
        VersionedEntityValue<ID>::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_serialize<ID>);
        VersionedEntityValue<ID>::_vptrMap["toJson"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_toJson<ID>);
        VersionedEntityValue<ID>::_vptrMap["validate"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_validate<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_isValid"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_isValid<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_version"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_version<ID>);
        VersionedEntityValue<ID>::_vptrMap["bump"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_bump<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_changelog"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_changelog<ID>);
    }
}
template<typename ID>
VersionedEntityValue<ID>* VersionedEntity_new(VersionedEntityValue<ID>* this__, ID id, std::string name, int64_t createdAt, int64_t updatedAt) {
    auto this_ = this__;
    if (VersionedEntityValue<ID>::_vptrMap.empty()) {
        VersionedEntityValue<ID>::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_label<ID>);
        VersionedEntityValue<ID>::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_toPrettyString<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_cacheKey"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_cacheKey<ID>);
        VersionedEntityValue<ID>::_vptrMap["cacheValue"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_cacheValue<ID>);
        VersionedEntityValue<ID>::_vptrMap["getCachedValue"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_getCachedValue<ID>);
        VersionedEntityValue<ID>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_toString<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_age"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_age<ID>);
        VersionedEntityValue<ID>::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_serialize<ID>);
        VersionedEntityValue<ID>::_vptrMap["toJson"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_toJson<ID>);
        VersionedEntityValue<ID>::_vptrMap["validate"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_validate<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_isValid"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_isValid<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_version"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_version<ID>);
        VersionedEntityValue<ID>::_vptrMap["bump"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_bump<ID>);
        VersionedEntityValue<ID>::_vptrMap["get_changelog"] = reinterpret_cast<void*>(&_vptr_wrap_VersionedEntity_get_changelog<ID>);
    }
    this_->_version = 1LL;
    this_->_changelog = GC::allocateLocal(new StaticList<std::string>());
    TimestampedEntity_new<ID>(this_, id, name, createdAt, updatedAt);
    return this_;
}

template<typename ID>
int64_t VersionedEntity_get_version(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return this_->_version;
}

template<typename ID>
void VersionedEntity_bump(VersionedEntityValue<ID>* this__, std::string change) {
    auto this_ = this__;
    (this_->_version = (this_->_version + 1LL));
    this_->_changelog->add(dart_str(std::string("v")) + dart_str(this_->_version) + dart_str(std::string(": ")) + dart_str(change));
}

template<typename ID>
StaticList<std::string>* VersionedEntity_get_changelog(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return unmodifiable<std::string>(this_->_changelog);
}

template<typename ID>
std::string VersionedEntity_serialize(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return dart_str(this_->id) + dart_str(std::string(":")) + dart_str(this_->name) + dart_str(std::string(":v")) + dart_str(this_->_version);
}

template<typename ID>
StaticList<std::string>* VersionedEntity_validate(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    StaticList<std::string>* errors = GC::allocateLocal(new StaticList<std::string>());
    if (this_->name.empty()) {
        errors->add(std::string("name is empty"));
    }
    if ((this_->_version < 1LL)) {
        errors->add(std::string("invalid version"));
    }
    return errors;
}

template<typename ID>
std::string VersionedEntity_get_label(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return dart_str(this_->name) + dart_str(std::string("(v")) + dart_str(this_->_version) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Money_compareTo(AnyGC* obj__, AnyGC* arg0) {
    return _box(Money_compareTo(static_cast<MoneyValue*>(obj__), static_cast<MoneyValue*>(arg0)));
}

AnyGC* _vptr_wrap_Money_lt(AnyGC* obj__, AnyGC* arg0) {
    return _box(Money_lt(static_cast<MoneyValue*>(obj__), arg0));
}

AnyGC* _vptr_wrap_Money_gt(AnyGC* obj__, AnyGC* arg0) {
    return _box(Money_gt(static_cast<MoneyValue*>(obj__), arg0));
}

AnyGC* _vptr_wrap_Money_le(AnyGC* obj__, AnyGC* arg0) {
    return _box(Money_le(static_cast<MoneyValue*>(obj__), arg0));
}

AnyGC* _vptr_wrap_Money_ge(AnyGC* obj__, AnyGC* arg0) {
    return _box(Money_ge(static_cast<MoneyValue*>(obj__), arg0));
}

AnyGC* _vptr_wrap_Money_get_label(AnyGC* obj__) {
    return _box(Money_get_label(static_cast<MoneyValue*>(obj__)));
}

AnyGC* _vptr_wrap_Money_toPrettyString(AnyGC* obj__) {
    return _box(Money_toPrettyString(static_cast<MoneyValue*>(obj__)));
}

AnyGC* _vptr_wrap_Money_add(AnyGC* obj__, AnyGC* arg0) {
    return _box(Money_add(static_cast<MoneyValue*>(obj__), static_cast<MoneyValue*>(arg0)));
}

AnyGC* _vptr_wrap_Money_sub(AnyGC* obj__, AnyGC* arg0) {
    return _box(Money_sub(static_cast<MoneyValue*>(obj__), static_cast<MoneyValue*>(arg0)));
}

AnyGC* _vptr_wrap_Money_mul(AnyGC* obj__, AnyGC* arg0) {
    return _box(Money_mul(static_cast<MoneyValue*>(obj__), dynAs<int64_t>(arg0)));
}

AnyGC* _vptr_wrap_Money_neg(AnyGC* obj__) {
    return _box(Money_neg(static_cast<MoneyValue*>(obj__)));
}

AnyGC* _vptr_wrap_Money_toString(AnyGC* obj__) {
    return _box(Money_toString(static_cast<MoneyValue*>(obj__)));
}

static bool _Money_vptr_registered = []{ MoneyValue::_vptrMap["compareTo"] = reinterpret_cast<void*>(&_vptr_wrap_Money_compareTo); MoneyValue::_vptrMap["<"] = reinterpret_cast<void*>(&_vptr_wrap_Money_lt); MoneyValue::_vptrMap[">"] = reinterpret_cast<void*>(&_vptr_wrap_Money_gt); MoneyValue::_vptrMap["<="] = reinterpret_cast<void*>(&_vptr_wrap_Money_le); MoneyValue::_vptrMap[">="] = reinterpret_cast<void*>(&_vptr_wrap_Money_ge); MoneyValue::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_Money_get_label); MoneyValue::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_Money_toPrettyString); MoneyValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Money_add); MoneyValue::_vptrMap["-"] = reinterpret_cast<void*>(&_vptr_wrap_Money_sub); MoneyValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Money_mul); MoneyValue::_vptrMap["unary-"] = reinterpret_cast<void*>(&_vptr_wrap_Money_neg); MoneyValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Money_toString); return true; }();
MoneyValue* Money_new(MoneyValue* this__, int64_t cents, std::string currency) {
    auto this_ = this__;
    if (MoneyValue::_vptrMap.empty()) {
        MoneyValue::_vptrMap["compareTo"] = reinterpret_cast<void*>(&_vptr_wrap_Money_compareTo);
        MoneyValue::_vptrMap["<"] = reinterpret_cast<void*>(&_vptr_wrap_Money_lt);
        MoneyValue::_vptrMap[">"] = reinterpret_cast<void*>(&_vptr_wrap_Money_gt);
        MoneyValue::_vptrMap["<="] = reinterpret_cast<void*>(&_vptr_wrap_Money_le);
        MoneyValue::_vptrMap[">="] = reinterpret_cast<void*>(&_vptr_wrap_Money_ge);
        MoneyValue::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_Money_get_label);
        MoneyValue::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_Money_toPrettyString);
        MoneyValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Money_add);
        MoneyValue::_vptrMap["-"] = reinterpret_cast<void*>(&_vptr_wrap_Money_sub);
        MoneyValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Money_mul);
        MoneyValue::_vptrMap["unary-"] = reinterpret_cast<void*>(&_vptr_wrap_Money_neg);
        MoneyValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Money_toString);
    }
    this_->cents = cents;
    this_->currency = currency;
    Comparable2_new<AnyGC*>(this_);
    return this_;
}

MoneyValue* Money_new_fromDollars(MoneyValue* this__, double dollars, std::string currency) {
    auto this_ = this__;
    this_->cents = /* unsupported double method: round */ (dollars * 100LL);
    this_->currency = currency;
    Comparable2_new<AnyGC*>(this_);
    return this_;
}

MoneyValue* Money_add(MoneyValue* this__, MoneyValue* other) {
    auto this_ = this__;
    if (!((this_->currency == other->currency))) {
        throw DartArgumentError(std::string("Currency mismatch"));
    }
    return Money_new(GC::allocateLocal(new MoneyValue()), (this_->cents + other->cents), this_->currency);
}

MoneyValue* Money_sub(MoneyValue* this__, MoneyValue* other) {
    auto this_ = this__;
    if (!((this_->currency == other->currency))) {
        throw DartArgumentError(std::string("Currency mismatch"));
    }
    return Money_new(GC::allocateLocal(new MoneyValue()), (this_->cents - other->cents), this_->currency);
}

MoneyValue* Money_mul(MoneyValue* this__, int64_t factor) {
    auto this_ = this__;
    return Money_new(GC::allocateLocal(new MoneyValue()), (this_->cents * factor), this_->currency);
}

MoneyValue* Money_neg(MoneyValue* this__) {
    auto this_ = this__;
    return Money_new(GC::allocateLocal(new MoneyValue()), (-this_->cents), this_->currency);
}

int64_t Money_compareTo(MoneyValue* this__, MoneyValue* other) {
    auto this_ = this__;
    return (this_->cents - other->cents);
}

std::string Money_get_label(MoneyValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("$")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(2LL) << (static_cast<double>(this_->cents) / static_cast<double>(100LL)); return _ss.str(); })()) + dart_str(std::string(" ")) + dart_str(this_->currency);
}

std::string Money_toString(MoneyValue* this__) {
    auto this_ = this__;
    return dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_));
}

AnyGC* _vptr_wrap_Config_index(AnyGC* obj__, AnyGC* arg0) {
    return _box(Config_index(static_cast<ConfigValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_Config_indexSet(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    Config_indexSet(static_cast<ConfigValue*>(obj__), dynAs<std::string>(arg0), arg1);
    return nullptr;
}

AnyGC* _vptr_wrap_Config_containsKey(AnyGC* obj__, AnyGC* arg0) {
    return _box(Config_containsKey(static_cast<ConfigValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_Config_get_length(AnyGC* obj__) {
    return _box(Config_get_length(static_cast<ConfigValue*>(obj__)));
}

AnyGC* _vptr_wrap_Config_toString(AnyGC* obj__) {
    return _box(Config_toString(static_cast<ConfigValue*>(obj__)));
}

static bool _Config_vptr_registered = []{ ConfigValue::_vptrMap["[]"] = reinterpret_cast<void*>(&_vptr_wrap_Config_index); ConfigValue::_vptrMap["[]="] = reinterpret_cast<void*>(&_vptr_wrap_Config_indexSet); ConfigValue::_vptrMap["containsKey"] = reinterpret_cast<void*>(&_vptr_wrap_Config_containsKey); ConfigValue::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_Config_get_length); ConfigValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Config_toString); return true; }();
ConfigValue* Config_new(ConfigValue* this__, StaticMap<std::string, AnyGC*>* _data) {
    auto this_ = this__;
    if (ConfigValue::_vptrMap.empty()) {
        ConfigValue::_vptrMap["[]"] = reinterpret_cast<void*>(&_vptr_wrap_Config_index);
        ConfigValue::_vptrMap["[]="] = reinterpret_cast<void*>(&_vptr_wrap_Config_indexSet);
        ConfigValue::_vptrMap["containsKey"] = reinterpret_cast<void*>(&_vptr_wrap_Config_containsKey);
        ConfigValue::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_Config_get_length);
        ConfigValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Config_toString);
    }
    this_->_data = _data;
    return this_;
}

ConfigValue* Config_new_empty(ConfigValue* this__) {
    auto this_ = this__;
    this_->_data = StaticMap<std::string, AnyGC*>::empty();
    return this_;
}

ConfigValue* Config_new_fromPairs(ConfigValue* this__, StaticList<StaticList<AnyGC*>*>* pairs) {
    auto this_ = this__;
    this_->_data = ([&]() {     StaticMap<std::string, AnyGC*>* _v1 = StaticMap<std::string, AnyGC*>::empty();
    StaticIterator<StaticList<AnyGC*>*>* sync_for_iterator = pairs->iterator();
    while (sync_for_iterator->moveNext()) {
        StaticList<AnyGC*>* p = sync_for_iterator->current();
        _v1->set(dynAs<std::string>((*p)[0LL]), (*p)[1LL]);
    }
 return _v1; })();
    return this_;
}

ConfigValue* Config_new_withDefaults(StaticMap<std::string, AnyGC*>* overrides) {
    StaticMap<std::string, AnyGC*>* defaults = ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("debug"), GC::allocateLocal(new BoolBox(false))); _m->set(std::string("maxRetries"), GC::allocateLocal(new IntBox(3LL))); _m->set(std::string("timeout"), GC::allocateLocal(new IntBox(30LL))); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("default")))); return _m; })();
    /* unsupported collection method: addAll on Map */ defaults->addAll(overrides);
    return Config_new(GC::allocateLocal(new ConfigValue()), static_cast<StaticMap<std::string, AnyGC*>*>(defaults));
}

AnyGC* Config_index(ConfigValue* this__, std::string key) {
    auto this_ = this__;
    return _box(*(*this_->_data)[key]);
}

void Config_indexSet(ConfigValue* this__, std::string key, AnyGC* value) {
    auto this_ = this__;
    ([&]() { StaticMap<std::string, AnyGC*>* _let2 = this_->_data; std::string _let3 = key; AnyGC* _let4 = value; _let2->set(_let3, _let4);  return _let4; })();
    return;
}

bool Config_containsKey(ConfigValue* this__, std::string key) {
    auto this_ = this__;
    return this_->_data->containsKey(key);
}

int64_t Config_get_length(ConfigValue* this__) {
    auto this_ = this__;
    return this_->_data->length();
}

std::string Config_toString(ConfigValue* this__) {
    auto this_ = this__;
    StaticList<std::string>* sorted = ([&]() { StaticList<std::string>* _let6 = this_->_data->keys(); return ([&]() {     _let6->sort();
 return _let6; })(); })();
    StaticList<std::string>* entries = sorted->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, std::string>*>(new ClosureEnv_0(this_))));
    return dart_str(std::string("Config{")) + dart_str(entries->join(std::string(", "))) + dart_str(std::string("}"));
}

AnyGC* _vptr_wrap_EventBus_on(AnyGC* obj__, AnyGC* arg0) {
    EventBus_on(static_cast<EventBusValue*>(obj__), static_cast<TypeFunction1<void, std::string>*>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_EventBus_emit(AnyGC* obj__, AnyGC* arg0) {
    EventBus_emit(static_cast<EventBusValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

static bool _EventBus_vptr_registered = []{ EventBusValue::_vptrMap["on"] = reinterpret_cast<void*>(&_vptr_wrap_EventBus_on); EventBusValue::_vptrMap["emit"] = reinterpret_cast<void*>(&_vptr_wrap_EventBus_emit); return true; }();
EventBusValue* EventBus_new(EventBusValue* this__) {
    auto this_ = this__;
    if (EventBusValue::_vptrMap.empty()) {
        EventBusValue::_vptrMap["on"] = reinterpret_cast<void*>(&_vptr_wrap_EventBus_on);
        EventBusValue::_vptrMap["emit"] = reinterpret_cast<void*>(&_vptr_wrap_EventBus_emit);
    }
    this_->_listeners = GC::allocateLocal(new StaticList<TypeFunction1<void, std::string>*>());
    return this_;
}

void EventBus_on(EventBusValue* this__, TypeFunction1<void, std::string>* listener) {
    auto this_ = this__;
    this_->_listeners->add(listener);
}

void EventBus_emit(EventBusValue* this__, std::string event) {
    auto this_ = this__;
    StaticIterator<TypeFunction1<void, std::string>*>* sync_for_iterator = this_->_listeners->iterator();
    while (sync_for_iterator->moveNext()) {
        TypeFunction1<void, std::string>* listener = sync_for_iterator->current();
        listener->call(event);
    }
}

AnyGC* _vptr_wrap_Drawable_draw(AnyGC* obj__) {
    Drawable_draw(static_cast<DrawableValue*>(obj__));
    return nullptr;
}

static bool _Drawable_vptr_registered = []{ DrawableValue::_vptrMap["draw"] = reinterpret_cast<void*>(&_vptr_wrap_Drawable_draw); return true; }();
DrawableValue* Drawable_new(DrawableValue* this__) {
    auto this_ = this__;
    if (DrawableValue::_vptrMap.empty()) {
        DrawableValue::_vptrMap["draw"] = reinterpret_cast<void*>(&_vptr_wrap_Drawable_draw);
    }
    return this_;
}

void Drawable_draw(DrawableValue* this__) {
    auto this_ = this__;
}

AnyGC* _vptr_wrap_Resizable_resize(AnyGC* obj__, AnyGC* arg0) {
    Resizable_resize(static_cast<ResizableValue*>(obj__), dynAs<double>(arg0));
    return nullptr;
}

static bool _Resizable_vptr_registered = []{ ResizableValue::_vptrMap["resize"] = reinterpret_cast<void*>(&_vptr_wrap_Resizable_resize); return true; }();
ResizableValue* Resizable_new(ResizableValue* this__) {
    auto this_ = this__;
    if (ResizableValue::_vptrMap.empty()) {
        ResizableValue::_vptrMap["resize"] = reinterpret_cast<void*>(&_vptr_wrap_Resizable_resize);
    }
    return this_;
}

void Resizable_resize(ResizableValue* this__, double factor) {
    auto this_ = this__;
}

AnyGC* _vptr_wrap_Clickable_onClick(AnyGC* obj__) {
    Clickable_onClick(static_cast<ClickableValue*>(obj__));
    return nullptr;
}

static bool _Clickable_vptr_registered = []{ ClickableValue::_vptrMap["onClick"] = reinterpret_cast<void*>(&_vptr_wrap_Clickable_onClick); return true; }();
ClickableValue* Clickable_new(ClickableValue* this__) {
    auto this_ = this__;
    if (ClickableValue::_vptrMap.empty()) {
        ClickableValue::_vptrMap["onClick"] = reinterpret_cast<void*>(&_vptr_wrap_Clickable_onClick);
    }
    return this_;
}

void Clickable_onClick(ClickableValue* this__) {
    auto this_ = this__;
}

AnyGC* _vptr_wrap_Widget_draw(AnyGC* obj__) {
    Widget_draw(static_cast<WidgetValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Widget_resize(AnyGC* obj__, AnyGC* arg0) {
    Widget_resize(static_cast<WidgetValue*>(obj__), dynAs<double>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_Widget_onClick(AnyGC* obj__) {
    Widget_onClick(static_cast<WidgetValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Widget_get_info(AnyGC* obj__) {
    return _box(Widget_get_info(static_cast<WidgetValue*>(obj__)));
}

static bool _Widget_vptr_registered = []{ WidgetValue::_vptrMap["draw"] = reinterpret_cast<void*>(&_vptr_wrap_Widget_draw); WidgetValue::_vptrMap["resize"] = reinterpret_cast<void*>(&_vptr_wrap_Widget_resize); WidgetValue::_vptrMap["onClick"] = reinterpret_cast<void*>(&_vptr_wrap_Widget_onClick); WidgetValue::_vptrMap["get_info"] = reinterpret_cast<void*>(&_vptr_wrap_Widget_get_info); return true; }();
WidgetValue* Widget_new(WidgetValue* this__) {
    auto this_ = this__;
    if (WidgetValue::_vptrMap.empty()) {
        WidgetValue::_vptrMap["draw"] = reinterpret_cast<void*>(&_vptr_wrap_Widget_draw);
        WidgetValue::_vptrMap["resize"] = reinterpret_cast<void*>(&_vptr_wrap_Widget_resize);
        WidgetValue::_vptrMap["onClick"] = reinterpret_cast<void*>(&_vptr_wrap_Widget_onClick);
        WidgetValue::_vptrMap["get_info"] = reinterpret_cast<void*>(&_vptr_wrap_Widget_get_info);
    }
    this_->_state = std::string("idle");
    this_->_scale = 1.0;
    this_->_clickCount = 0LL;
    return this_;
}

void Widget_draw(WidgetValue* this__) {
    auto this_ = this__;
    (this_->_state = std::string("drawn"));
}

void Widget_resize(WidgetValue* this__, double factor) {
    auto this_ = this__;
    (this_->_scale = (this_->_scale * factor));
}

void Widget_onClick(WidgetValue* this__) {
    auto this_ = this__;
    (this_->_clickCount = (this_->_clickCount + 1LL));
    (this_->_state = dart_str(std::string("clicked(")) + dart_str(this_->_clickCount) + dart_str(std::string(")")));
}

std::string Widget_get_info(WidgetValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Widget(state=")) + dart_str(this_->_state) + dart_str(std::string(", scale=")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(1LL) << this_->_scale; return _ss.str(); })()) + dart_str(std::string(", clicks=")) + dart_str(this_->_clickCount) + dart_str(std::string(")"));
}

template<typename A, typename B>
AnyGC* _vptr_wrap_Pair_swap(AnyGC* obj__) {
    return _box(Pair_swap<A, B>(static_cast<PairValue<A, B>*>(obj__)));
}

template<typename A, typename B>
AnyGC* _vptr_wrap_Pair_mapFirst(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<A> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(Pair_mapFirst<A, B, AnyGC*>(static_cast<PairValue<A, B>*>(obj__), &_adapter0));
}

template<typename A, typename B>
AnyGC* _vptr_wrap_Pair_mapSecond(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<B> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(Pair_mapSecond<A, B, AnyGC*>(static_cast<PairValue<A, B>*>(obj__), &_adapter0));
}

template<typename A, typename B>
AnyGC* _vptr_wrap_Pair_fold(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter2<A, B> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(Pair_fold<A, B, AnyGC*>(static_cast<PairValue<A, B>*>(obj__), &_adapter0));
}

template<typename A, typename B>
AnyGC* _vptr_wrap_Pair_toString(AnyGC* obj__) {
    return _box(Pair_toString<A, B>(static_cast<PairValue<A, B>*>(obj__)));
}

template<typename A, typename B> void _register_Pair_vptr() {
    if (PairValue<A, B>::_vptrMap.empty()) {
        PairValue<A, B>::_vptrMap["swap"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_swap<A, B>);
        PairValue<A, B>::_vptrMap["mapFirst"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_mapFirst<A, B>);
        PairValue<A, B>::_vptrMap["mapSecond"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_mapSecond<A, B>);
        PairValue<A, B>::_vptrMap["fold"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_fold<A, B>);
        PairValue<A, B>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_toString<A, B>);
    }
}
template<typename A, typename B>
PairValue<A, B>* Pair_new(PairValue<A, B>* this__, A first, B second) {
    auto this_ = this__;
    if (PairValue<A, B>::_vptrMap.empty()) {
        PairValue<A, B>::_vptrMap["swap"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_swap<A, B>);
        PairValue<A, B>::_vptrMap["mapFirst"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_mapFirst<A, B>);
        PairValue<A, B>::_vptrMap["mapSecond"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_mapSecond<A, B>);
        PairValue<A, B>::_vptrMap["fold"] = reinterpret_cast<void*>(&_vptr_wrap_Pair_fold<A, B>);
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

template<typename A, typename B, typename C>
PairValue<C, B>* Pair_mapFirst(PairValue<A, B>* this__, TypeFunction1<C, A>* transform) {
    auto this_ = this__;
    return Pair_new<C, B>(GC::allocateLocal(new PairValue<C, B>()), transform->call(this_->first), this_->second);
}

template<typename A, typename B, typename C>
PairValue<A, C>* Pair_mapSecond(PairValue<A, B>* this__, TypeFunction1<C, B>* transform) {
    auto this_ = this__;
    return Pair_new<A, C>(GC::allocateLocal(new PairValue<A, C>()), this_->first, transform->call(this_->second));
}

template<typename A, typename B, typename R>
R Pair_fold(PairValue<A, B>* this__, TypeFunction2<R, A, B>* combine) {
    auto this_ = this__;
    return combine->call(this_->first, this_->second);
}

template<typename A, typename B>
std::string Pair_toString(PairValue<A, B>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Pair(")) + dart_str(this_->first) + dart_str(std::string(", ")) + dart_str(this_->second) + dart_str(std::string(")"));
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_Triple_swap(AnyGC* obj__) {
    return _box(Triple_swap<A, B, C>(static_cast<TripleValue<A, B, C>*>(obj__)));
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_Triple_mapFirst(AnyGC* obj__, AnyGC* arg0) {
    return _box(Triple_mapFirst<A, B, C>(static_cast<TripleValue<A, B, C>*>(obj__), static_cast<TypeFunction1<C, A>*>(arg0)));
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_Triple_mapSecond(AnyGC* obj__, AnyGC* arg0) {
    return _box(Triple_mapSecond<A, B, C>(static_cast<TripleValue<A, B, C>*>(obj__), static_cast<TypeFunction1<C, B>*>(arg0)));
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_Triple_fold(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter2<A, B> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(Triple_fold<A, B, C, AnyGC*>(static_cast<TripleValue<A, B, C>*>(obj__), &_adapter0));
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_Triple_toString(AnyGC* obj__) {
    return _box(Triple_toString<A, B, C>(static_cast<TripleValue<A, B, C>*>(obj__)));
}

template<typename A, typename B, typename C> void _register_Triple_vptr() {
    if (TripleValue<A, B, C>::_vptrMap.empty()) {
        TripleValue<A, B, C>::_vptrMap["swap"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_swap<A, B, C>);
        TripleValue<A, B, C>::_vptrMap["mapFirst"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_mapFirst<A, B, C>);
        TripleValue<A, B, C>::_vptrMap["mapSecond"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_mapSecond<A, B, C>);
        TripleValue<A, B, C>::_vptrMap["fold"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_fold<A, B, C>);
        TripleValue<A, B, C>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_toString<A, B, C>);
    }
}
template<typename A, typename B, typename C>
TripleValue<A, B, C>* Triple_new(TripleValue<A, B, C>* this__, A first, B second, C third) {
    auto this_ = this__;
    if (TripleValue<A, B, C>::_vptrMap.empty()) {
        TripleValue<A, B, C>::_vptrMap["swap"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_swap<A, B, C>);
        TripleValue<A, B, C>::_vptrMap["mapFirst"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_mapFirst<A, B, C>);
        TripleValue<A, B, C>::_vptrMap["mapSecond"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_mapSecond<A, B, C>);
        TripleValue<A, B, C>::_vptrMap["fold"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_fold<A, B, C>);
        TripleValue<A, B, C>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Triple_toString<A, B, C>);
    }
    this_->third = third;
    Pair_new<A, B>(this_, first, second);
    return this_;
}

template<typename A, typename B, typename C>
std::string Triple_toString(TripleValue<A, B, C>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Triple(")) + dart_str(this_->first) + dart_str(std::string(", ")) + dart_str(this_->second) + dart_str(std::string(", ")) + dart_str(this_->third) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_StringBuilder_withSeparator(AnyGC* obj__, AnyGC* arg0) {
    return _box(StringBuilder_withSeparator(static_cast<StringBuilderValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_StringBuilder_add(AnyGC* obj__, AnyGC* arg0) {
    return _box(StringBuilder_add(static_cast<StringBuilderValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_StringBuilder_addAll(AnyGC* obj__, AnyGC* arg0) {
    return _box(StringBuilder_addAll(static_cast<StringBuilderValue*>(obj__), static_cast<StaticList<std::string>*>(arg0)));
}

AnyGC* _vptr_wrap_StringBuilder_get_length(AnyGC* obj__) {
    return _box(StringBuilder_get_length(static_cast<StringBuilderValue*>(obj__)));
}

AnyGC* _vptr_wrap_StringBuilder_toString(AnyGC* obj__) {
    return _box(StringBuilder_toString(static_cast<StringBuilderValue*>(obj__)));
}

static bool _StringBuilder_vptr_registered = []{ StringBuilderValue::_vptrMap["withSeparator"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_withSeparator); StringBuilderValue::_vptrMap["add"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_add); StringBuilderValue::_vptrMap["addAll"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_addAll); StringBuilderValue::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_get_length); StringBuilderValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_toString); return true; }();
StringBuilderValue* StringBuilder_new(StringBuilderValue* this__) {
    auto this_ = this__;
    if (StringBuilderValue::_vptrMap.empty()) {
        StringBuilderValue::_vptrMap["withSeparator"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_withSeparator);
        StringBuilderValue::_vptrMap["add"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_add);
        StringBuilderValue::_vptrMap["addAll"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_addAll);
        StringBuilderValue::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_get_length);
        StringBuilderValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_StringBuilder_toString);
    }
    this_->_buf = GC::allocateLocal(new StaticStringBuffer());
    this_->_separator = std::string("");
    return this_;
}

StringBuilderValue* StringBuilder_withSeparator(StringBuilderValue* this__, std::string sep) {
    auto this_ = this__;
    (this_->_separator = sep);
    return this_;
}

StringBuilderValue* StringBuilder_add(StringBuilderValue* this__, std::string text) {
    auto this_ = this__;
    if ((this_->_buf->isNotEmpty() && !this_->_separator.empty())) {
        this_->_buf->write(this_->_separator);
    }
    this_->_buf->write(text);
    return this_;
}

StringBuilderValue* StringBuilder_addAll(StringBuilderValue* this__, StaticList<std::string>* texts) {
    auto this_ = this__;
    StaticIterator<std::string>* sync_for_iterator = texts->iterator();
    while (sync_for_iterator->moveNext()) {
        std::string t = sync_for_iterator->current();
        (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["add"]))(this_, _box(t));
    }
    return this_;
}

int64_t StringBuilder_get_length(StringBuilderValue* this__) {
    auto this_ = this__;
    return this_->_buf->length();
}

std::string StringBuilder_toString(StringBuilderValue* this__) {
    auto this_ = this__;
    return this_->_buf->toString();
}

AnyGC* _vptr_wrap_AppError_toString(AnyGC* obj__) {
    return _box(AppError_toString(static_cast<AppErrorValue*>(obj__)));
}

static bool _AppError_vptr_registered = []{ AppErrorValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_AppError_toString); return true; }();
AppErrorValue* AppError_new(AppErrorValue* this__, std::string message, std::string code, AppErrorValue* cause) {
    auto this_ = this__;
    if (AppErrorValue::_vptrMap.empty()) {
        AppErrorValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_AppError_toString);
    }
    this_->message = message;
    this_->code = code;
    this_->cause = cause;
    return this_;
}

std::string AppError_toString(AppErrorValue* this__) {
    auto this_ = this__;
    StaticList<std::string>* chain = GC::allocateLocal(new StaticList<std::string>());
    AppErrorValue* current = this_;
    while (!((dart_isNull(current)))) {
        chain->add(dart_str(current->code) + dart_str(std::string(":")) + dart_str(current->message));
        (current = current->cause);
    }
    return chain->join(std::string(" -> "));
}

template<typename T>
AnyGC* _vptr_wrap_DataPipeline_where(AnyGC* obj__, AnyGC* arg0) {
    return _box(DataPipeline_where<T>(static_cast<DataPipelineValue<T>*>(obj__), static_cast<TypeFunction1<bool, T>*>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_DataPipeline_map(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<T> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(DataPipeline_map<T, AnyGC*>(static_cast<DataPipelineValue<T>*>(obj__), &_adapter0));
}

template<typename T>
AnyGC* _vptr_wrap_DataPipeline_sorted(AnyGC* obj__, AnyGC* arg0) {
    return _box(DataPipeline_sorted<T>(static_cast<DataPipelineValue<T>*>(obj__), static_cast<TypeFunction2<int64_t, T, T>*>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_DataPipeline_take(AnyGC* obj__, AnyGC* arg0) {
    return _box(DataPipeline_take<T>(static_cast<DataPipelineValue<T>*>(obj__), dynAs<int64_t>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_DataPipeline_fold(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    _TypeFnAdapter2<AnyGC*, T> _adapter1(static_cast<TypeFunction*>(arg1));
    return _box(DataPipeline_fold<T, AnyGC*>(static_cast<DataPipelineValue<T>*>(obj__), arg0, &_adapter1));
}

template<typename T>
AnyGC* _vptr_wrap_DataPipeline_toList(AnyGC* obj__) {
    return _box(DataPipeline_toList<T>(static_cast<DataPipelineValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_DataPipeline_toString(AnyGC* obj__) {
    return _box(DataPipeline_toString<T>(static_cast<DataPipelineValue<T>*>(obj__)));
}

template<typename T> void _register_DataPipeline_vptr() {
    if (DataPipelineValue<T>::_vptrMap.empty()) {
        DataPipelineValue<T>::_vptrMap["where"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_where<T>);
        DataPipelineValue<T>::_vptrMap["map"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_map<T>);
        DataPipelineValue<T>::_vptrMap["sorted"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_sorted<T>);
        DataPipelineValue<T>::_vptrMap["take"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_take<T>);
        DataPipelineValue<T>::_vptrMap["fold"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_fold<T>);
        DataPipelineValue<T>::_vptrMap["toList"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_toList<T>);
        DataPipelineValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_toString<T>);
    }
}
template<typename T>
DataPipelineValue<T>* DataPipeline_new(DataPipelineValue<T>* this__, StaticList<T>* _data) {
    auto this_ = this__;
    if (DataPipelineValue<T>::_vptrMap.empty()) {
        DataPipelineValue<T>::_vptrMap["where"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_where<T>);
        DataPipelineValue<T>::_vptrMap["map"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_map<T>);
        DataPipelineValue<T>::_vptrMap["sorted"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_sorted<T>);
        DataPipelineValue<T>::_vptrMap["take"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_take<T>);
        DataPipelineValue<T>::_vptrMap["fold"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_fold<T>);
        DataPipelineValue<T>::_vptrMap["toList"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_toList<T>);
        DataPipelineValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_DataPipeline_toString<T>);
    }
    this_->_data = _data;
    return this_;
}

template<typename T>
DataPipelineValue<T>* DataPipeline_where(DataPipelineValue<T>* this__, TypeFunction1<bool, T>* test) {
    auto this_ = this__;
    return DataPipeline_new<T>(GC::allocateLocal(new DataPipelineValue<T>()), static_cast<StaticList<T>*>(this_->_data->where(test)));
}

template<typename T, typename R>
DataPipelineValue<R>* DataPipeline_map(DataPipelineValue<T>* this__, TypeFunction1<R, T>* transform) {
    auto this_ = this__;
    return DataPipeline_new<R>(GC::allocateLocal(new DataPipelineValue<R>()), static_cast<StaticList<R>*>(this_->_data->map(transform)));
}

template<typename T>
DataPipelineValue<T>* DataPipeline_sorted(DataPipelineValue<T>* this__, TypeFunction2<int64_t, T, T>* compare) {
    auto this_ = this__;
    StaticList<T>* copy = StaticList<T>::from(this_->_data);
    copy->sort(compare);
    return DataPipeline_new<T>(GC::allocateLocal(new DataPipelineValue<T>()), static_cast<StaticList<T>*>(copy));
}

template<typename T>
DataPipelineValue<T>* DataPipeline_take(DataPipelineValue<T>* this__, int64_t count) {
    auto this_ = this__;
    return DataPipeline_new<T>(GC::allocateLocal(new DataPipelineValue<T>()), static_cast<StaticList<T>*>(/* unsupported collection method: take on List */ this_->_data->take(count)));
}

template<typename T, typename R>
R DataPipeline_fold(DataPipelineValue<T>* this__, R initial, TypeFunction2<R, R, T>* combine) {
    auto this_ = this__;
    return this_->_data->fold(initial, combine);
}

template<typename T>
StaticList<T>* DataPipeline_toList(DataPipelineValue<T>* this__) {
    auto this_ = this__;
    return unmodifiable<T>(this_->_data);
}

template<typename T>
std::string DataPipeline_toString(DataPipelineValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Pipeline(")) + dart_str(this_->_data) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_BoundedValue_get_value(AnyGC* obj__) {
    return _box(BoundedValue_get_value(static_cast<BoundedValueValue*>(obj__)));
}

AnyGC* _vptr_wrap_BoundedValue_set_value(AnyGC* obj__, AnyGC* arg0) {
    BoundedValue_set_value(static_cast<BoundedValueValue*>(obj__), dynAs<double>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_BoundedValue_add(AnyGC* obj__, AnyGC* arg0) {
    return _box(BoundedValue_add(static_cast<BoundedValueValue*>(obj__), dynAs<double>(arg0)));
}

AnyGC* _vptr_wrap_BoundedValue_toString(AnyGC* obj__) {
    return _box(BoundedValue_toString(static_cast<BoundedValueValue*>(obj__)));
}

static bool _BoundedValue_vptr_registered = []{ BoundedValueValue::_vptrMap["get_value"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_get_value); BoundedValueValue::_vptrMap["set_value"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_set_value); BoundedValueValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_add); BoundedValueValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_toString); return true; }();
BoundedValueValue* BoundedValue_new(BoundedValueValue* this__, double _value, double _min, double _max) {
    auto this_ = this__;
    if (BoundedValueValue::_vptrMap.empty()) {
        BoundedValueValue::_vptrMap["get_value"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_get_value);
        BoundedValueValue::_vptrMap["set_value"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_set_value);
        BoundedValueValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_add);
        BoundedValueValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_BoundedValue_toString);
    }
    this_->_value = _value;
    this_->_min = _min;
    this_->_max = _max;
    BoundedValue__clamp(this_);
    return this_;
}

double BoundedValue_get_value(BoundedValueValue* this__) {
    auto this_ = this__;
    return this_->_value;
}

void BoundedValue_set_value(BoundedValueValue* this__, double v) {
    auto this_ = this__;
    (this_->_value = v);
    BoundedValue__clamp(this_);
}

void BoundedValue__clamp(BoundedValueValue* this__) {
    auto this_ = this__;
    if ((this_->_value < this_->_min)) {
        (this_->_value = this_->_min);
    }
    if ((this_->_value > this_->_max)) {
        (this_->_value = this_->_max);
    }
}

BoundedValueValue* BoundedValue_add(BoundedValueValue* this__, double delta) {
    auto this_ = this__;
    return BoundedValue_new(GC::allocateLocal(new BoundedValueValue()), (this_->_value + delta), this_->_min, this_->_max);
}

std::string BoundedValue_toString(BoundedValueValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("BoundedValue(")) + dart_str(this_->_value) + dart_str(std::string(", min=")) + dart_str(this_->_min) + dart_str(std::string(", max=")) + dart_str(this_->_max) + dart_str(std::string(")"));
}

int64_t _callCount = 0LL;
MathUtilsValue* MathUtils_new(MathUtilsValue* this__) {
    auto this_ = this__;
    return this_;
}

int64_t MathUtils_get_callCount() {
    return _callCount;
}

int64_t MathUtils_factorial(int64_t n) {
    _callCount = (_callCount + 1LL);
    if ((n <= 1LL)) {
        return 1LL;
    }
    return (n * MathUtils_factorial((n - 1LL)));
}

StaticList<int64_t>* MathUtils_fibonacci(int64_t count) {
    _callCount = (_callCount + 1LL);
    if ((count <= 0LL)) {
        return GC::allocateLocal(new StaticList<int64_t>());
    }
    if ((count == 1LL)) {
        return GC::allocateLocal(new StaticList<int64_t>({0LL}));
    }
    StaticList<int64_t>* fibs = GC::allocateLocal(new StaticList<int64_t>({0LL, 1LL}));
    int64_t i = 2LL;
    while ((i < count)) {
        fibs->add(((*fibs)[(i - 1LL)] + (*fibs)[(i - 2LL)]));
        (i = (i + 1LL));
    }
    return fibs;
}

double MathUtils_lerp(double a, double b, double t) {
    _callCount = (_callCount + 1LL);
    return (a + ((b - a) * t));
}

template<typename V>
AnyGC* _vptr_wrap_ReactiveStore_log_(AnyGC* obj__, AnyGC* arg0) {
    ReactiveStore_log_<V>(static_cast<ReactiveStoreValue<V>*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

template<typename V>
AnyGC* _vptr_wrap_ReactiveStore_get_logs(AnyGC* obj__) {
    return _box(ReactiveStore_get_logs<V>(static_cast<ReactiveStoreValue<V>*>(obj__)));
}

template<typename V>
AnyGC* _vptr_wrap_ReactiveStore_observe(AnyGC* obj__, AnyGC* arg0) {
    ReactiveStore_observe<V>(static_cast<ReactiveStoreValue<V>*>(obj__), static_cast<TypeFunction1<void, V>*>(arg0));
    return nullptr;
}

template<typename V>
AnyGC* _vptr_wrap_ReactiveStore_notify(AnyGC* obj__, AnyGC* arg0) {
    ReactiveStore_notify<V>(static_cast<ReactiveStoreValue<V>*>(obj__), dynAs<V>(arg0));
    return nullptr;
}

template<typename V>
AnyGC* _vptr_wrap_ReactiveStore_get(AnyGC* obj__, AnyGC* arg0) {
    return _box(ReactiveStore_get<V>(static_cast<ReactiveStoreValue<V>*>(obj__), dynAs<std::string>(arg0)));
}

template<typename V>
AnyGC* _vptr_wrap_ReactiveStore_set(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    ReactiveStore_set<V>(static_cast<ReactiveStoreValue<V>*>(obj__), dynAs<std::string>(arg0), dynAs<V>(arg1));
    return nullptr;
}

template<typename V>
AnyGC* _vptr_wrap_ReactiveStore_get_size(AnyGC* obj__) {
    return _box(ReactiveStore_get_size<V>(static_cast<ReactiveStoreValue<V>*>(obj__)));
}

template<typename V>
AnyGC* _vptr_wrap_ReactiveStore_toString(AnyGC* obj__) {
    return _box(ReactiveStore_toString<V>(static_cast<ReactiveStoreValue<V>*>(obj__)));
}

template<typename V> void _register_ReactiveStore_vptr() {
    if (ReactiveStoreValue<V>::_vptrMap.empty()) {
        ReactiveStoreValue<V>::_vptrMap["log_"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_log_<V>);
        ReactiveStoreValue<V>::_vptrMap["get_logs"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_get_logs<V>);
        ReactiveStoreValue<V>::_vptrMap["observe"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_observe<V>);
        ReactiveStoreValue<V>::_vptrMap["notify"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_notify<V>);
        ReactiveStoreValue<V>::_vptrMap["get"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_get<V>);
        ReactiveStoreValue<V>::_vptrMap["set"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_set<V>);
        ReactiveStoreValue<V>::_vptrMap["get_size"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_get_size<V>);
        ReactiveStoreValue<V>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_toString<V>);
    }
}
template<typename V>
ReactiveStoreValue<V>* ReactiveStore_new(ReactiveStoreValue<V>* this__) {
    auto this_ = this__;
    if (ReactiveStoreValue<V>::_vptrMap.empty()) {
        ReactiveStoreValue<V>::_vptrMap["log_"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_log_<V>);
        ReactiveStoreValue<V>::_vptrMap["get_logs"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_get_logs<V>);
        ReactiveStoreValue<V>::_vptrMap["observe"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_observe<V>);
        ReactiveStoreValue<V>::_vptrMap["notify"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_notify<V>);
        ReactiveStoreValue<V>::_vptrMap["get"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_get<V>);
        ReactiveStoreValue<V>::_vptrMap["set"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_set<V>);
        ReactiveStoreValue<V>::_vptrMap["get_size"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_get_size<V>);
        ReactiveStoreValue<V>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_ReactiveStore_toString<V>);
    }
    this_->_store = StaticMap<std::string, V>::empty();
    this_->_observers = GC::allocateLocal(new StaticList<TypeFunction1<void, V>*>());
    this_->_logs = GC::allocateLocal(new StaticList<std::string>());
    return this_;
}

template<typename V>
V ReactiveStore_get(ReactiveStoreValue<V>* this__, std::string key) {
    auto this_ = this__;
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["log_"]))(this_, _box(dart_str(std::string("get: ")) + dart_str(key)));
    return (*(*this_->_store)[key]);
}

template<typename V>
void ReactiveStore_set(ReactiveStoreValue<V>* this__, std::string key, V value) {
    auto this_ = this__;
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["log_"]))(this_, _box(dart_str(std::string("set: ")) + dart_str(key) + dart_str(std::string("=")) + dart_str(value)));
    this_->_store->set(key, value);
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["notify"]))(this_, _box(value));
}

template<typename V>
int64_t ReactiveStore_get_size(ReactiveStoreValue<V>* this__) {
    auto this_ = this__;
    return this_->_store->length();
}

template<typename V>
std::string ReactiveStore_toString(ReactiveStoreValue<V>* this__) {
    auto this_ = this__;
    return dart_str(std::string("Store(")) + dart_str(this_->_store) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Shape_area(AnyGC* obj__) {
    return _box(Shape_area(static_cast<ShapeValue*>(obj__)));
}

AnyGC* _vptr_wrap_Shape_get_shapeName(AnyGC* obj__) {
    return _box(Shape_get_shapeName(static_cast<ShapeValue*>(obj__)));
}

static bool _Shape_vptr_registered = []{ ShapeValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_area); ShapeValue::_vptrMap["get_shapeName"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_get_shapeName); return true; }();
ShapeValue* Shape_new(ShapeValue* this__) {
    auto this_ = this__;
    if (ShapeValue::_vptrMap.empty()) {
        ShapeValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_area);
        ShapeValue::_vptrMap["get_shapeName"] = reinterpret_cast<void*>(&_vptr_wrap_Shape_get_shapeName);
    }
    return this_;
}

double Shape_area(ShapeValue* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Shape.area")));
}

std::string Shape_get_shapeName(ShapeValue* this__) {
    auto this_ = this__;
    return "";
}

AnyGC* _vptr_wrap_Circle_area(AnyGC* obj__) {
    return _box(Circle_area(static_cast<CircleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Circle_get_shapeName(AnyGC* obj__) {
    return _box(Circle_get_shapeName(static_cast<CircleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Circle_toString(AnyGC* obj__) {
    return _box(Circle_toString(static_cast<CircleValue*>(obj__)));
}

static bool _Circle_vptr_registered = []{ CircleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_area); CircleValue::_vptrMap["get_shapeName"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_get_shapeName); CircleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_toString); return true; }();
CircleValue* Circle_new(CircleValue* this__, double radius) {
    auto this_ = this__;
    if (CircleValue::_vptrMap.empty()) {
        CircleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_area);
        CircleValue::_vptrMap["get_shapeName"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_get_shapeName);
        CircleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Circle_toString);
    }
    this_->radius = radius;
    return this_;
}

double Circle_area(CircleValue* this__) {
    auto this_ = this__;
    return ((3.14159 * this_->radius) * this_->radius);
}

std::string Circle_get_shapeName(CircleValue* this__) {
    auto this_ = this__;
    return std::string("Circle");
}

std::string Circle_toString(CircleValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Circle(r=")) + dart_str(this_->radius) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Rectangle_area(AnyGC* obj__) {
    return _box(Rectangle_area(static_cast<RectangleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Rectangle_get_shapeName(AnyGC* obj__) {
    return _box(Rectangle_get_shapeName(static_cast<RectangleValue*>(obj__)));
}

AnyGC* _vptr_wrap_Rectangle_toString(AnyGC* obj__) {
    return _box(Rectangle_toString(static_cast<RectangleValue*>(obj__)));
}

static bool _Rectangle_vptr_registered = []{ RectangleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_area); RectangleValue::_vptrMap["get_shapeName"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_get_shapeName); RectangleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_toString); return true; }();
RectangleValue* Rectangle_new(RectangleValue* this__, double width, double height) {
    auto this_ = this__;
    if (RectangleValue::_vptrMap.empty()) {
        RectangleValue::_vptrMap["area"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_area);
        RectangleValue::_vptrMap["get_shapeName"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_get_shapeName);
        RectangleValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Rectangle_toString);
    }
    this_->width = width;
    this_->height = height;
    return this_;
}

double Rectangle_area(RectangleValue* this__) {
    auto this_ = this__;
    return (this_->width * this_->height);
}

std::string Rectangle_get_shapeName(RectangleValue* this__) {
    auto this_ = this__;
    return std::string("Rectangle");
}

std::string Rectangle_toString(RectangleValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Rectangle(")) + dart_str(this_->width) + dart_str(std::string("x")) + dart_str(this_->height) + dart_str(std::string(")"));
}

template<typename T>
AnyGC* _vptr_wrap_Node_addChild(AnyGC* obj__, AnyGC* arg0) {
    Node_addChild<T>(static_cast<NodeValue<T>*>(obj__), static_cast<NodeValue<T>*>(arg0));
    return nullptr;
}

template<typename T>
AnyGC* _vptr_wrap_Node_flatten(AnyGC* obj__) {
    return _box(Node_flatten<T>(static_cast<NodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_Node_mapTree(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<T> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(Node_mapTree<T, AnyGC*>(static_cast<NodeValue<T>*>(obj__), &_adapter0));
}

template<typename T>
AnyGC* _vptr_wrap_Node_toString(AnyGC* obj__) {
    return _box(Node_toString<T>(static_cast<NodeValue<T>*>(obj__)));
}

template<typename T> void _register_Node_vptr() {
    if (NodeValue<T>::_vptrMap.empty()) {
        NodeValue<T>::_vptrMap["addChild"] = reinterpret_cast<void*>(&_vptr_wrap_Node_addChild<T>);
        NodeValue<T>::_vptrMap["flatten"] = reinterpret_cast<void*>(&_vptr_wrap_Node_flatten<T>);
        NodeValue<T>::_vptrMap["mapTree"] = reinterpret_cast<void*>(&_vptr_wrap_Node_mapTree<T>);
        NodeValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Node_toString<T>);
    }
}
template<typename T>
NodeValue<T>* Node_new(NodeValue<T>* this__, T value, StaticList<NodeValue<T>*>* children) {
    auto this_ = this__;
    if (NodeValue<T>::_vptrMap.empty()) {
        NodeValue<T>::_vptrMap["addChild"] = reinterpret_cast<void*>(&_vptr_wrap_Node_addChild<T>);
        NodeValue<T>::_vptrMap["flatten"] = reinterpret_cast<void*>(&_vptr_wrap_Node_flatten<T>);
        NodeValue<T>::_vptrMap["mapTree"] = reinterpret_cast<void*>(&_vptr_wrap_Node_mapTree<T>);
        NodeValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Node_toString<T>);
    }
    this_->value = value;
    this_->children = (dart_isNull(children) ? GC::allocateLocal(new StaticList<NodeValue<T>*>()) : children);
    return this_;
}

template<typename T>
void Node_addChild(NodeValue<T>* this__, NodeValue<T>* child) {
    auto this_ = this__;
    this_->children->add(child);
}

template<typename T>
StaticList<T>* Node_flatten(NodeValue<T>* this__) {
    auto this_ = this__;
    StaticList<T>* result = GC::allocateLocal(new StaticList<T>({this_->value}));
    StaticIterator<NodeValue<T>*>* sync_for_iterator = this_->children->iterator();
    while (sync_for_iterator->moveNext()) {
        NodeValue<T>* child = sync_for_iterator->current();
        result->addAll(static_cast<StaticList<T>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(child->getVptrMap()["flatten"]))(child)));
    }
    return result;
}

template<typename T, typename R>
NodeValue<R>* Node_mapTree(NodeValue<T>* this__, TypeFunction1<R, T>* transform) {
    auto this_ = this__;
    return Node_new<R>(GC::allocateLocal(new NodeValue<R>()), transform->call(this_->value), static_cast<StaticList<NodeValue<R>*>*>(this_->children->map(GC::allocateLocal(static_cast<TypeFunction1<NodeValue<R>*, NodeValue<T>*>*>(new ClosureEnv_1<R, T>(transform))))));
}

template<typename T>
std::string Node_toString(NodeValue<T>* this__) {
    auto this_ = this__;
    if (this_->children->isEmpty()) {
        return dart_str(this_->value);
    }
    return dart_str(this_->value) + dart_str(std::string("(")) + dart_str(this_->children->join(std::string(", "))) + dart_str(std::string(")"));
}

template<typename T>
AnyGC* _vptr_wrap_LabeledNode_addChild(AnyGC* obj__, AnyGC* arg0) {
    LabeledNode_addChild<T>(static_cast<LabeledNodeValue<T>*>(obj__), static_cast<NodeValue<T>*>(arg0));
    return nullptr;
}

template<typename T>
AnyGC* _vptr_wrap_LabeledNode_flatten(AnyGC* obj__) {
    return _box(LabeledNode_flatten<T>(static_cast<LabeledNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_LabeledNode_mapTree(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<T> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(LabeledNode_mapTree<T, AnyGC*>(static_cast<LabeledNodeValue<T>*>(obj__), &_adapter0));
}

template<typename T>
AnyGC* _vptr_wrap_LabeledNode_toString(AnyGC* obj__) {
    return _box(LabeledNode_toString<T>(static_cast<LabeledNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_LabeledNode_get_label(AnyGC* obj__) {
    return _box(LabeledNode_get_label<T>(static_cast<LabeledNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_LabeledNode_toPrettyString(AnyGC* obj__) {
    return _box(LabeledNode_toPrettyString<T>(static_cast<LabeledNodeValue<T>*>(obj__)));
}

template<typename T> void _register_LabeledNode_vptr() {
    if (LabeledNodeValue<T>::_vptrMap.empty()) {
        LabeledNodeValue<T>::_vptrMap["addChild"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_addChild<T>);
        LabeledNodeValue<T>::_vptrMap["flatten"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_flatten<T>);
        LabeledNodeValue<T>::_vptrMap["mapTree"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_mapTree<T>);
        LabeledNodeValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_toString<T>);
        LabeledNodeValue<T>::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_get_label<T>);
        LabeledNodeValue<T>::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_toPrettyString<T>);
    }
}
template<typename T>
LabeledNodeValue<T>* LabeledNode_new(LabeledNodeValue<T>* this__, std::string nodeLabel, T value, StaticList<NodeValue<T>*>* children) {
    auto this_ = this__;
    if (LabeledNodeValue<T>::_vptrMap.empty()) {
        LabeledNodeValue<T>::_vptrMap["addChild"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_addChild<T>);
        LabeledNodeValue<T>::_vptrMap["flatten"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_flatten<T>);
        LabeledNodeValue<T>::_vptrMap["mapTree"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_mapTree<T>);
        LabeledNodeValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_toString<T>);
        LabeledNodeValue<T>::_vptrMap["get_label"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_get_label<T>);
        LabeledNodeValue<T>::_vptrMap["toPrettyString"] = reinterpret_cast<void*>(&_vptr_wrap_LabeledNode_toPrettyString<T>);
    }
    this_->nodeLabel = nodeLabel;
    Node_new<T>(this_, value, children);
    return this_;
}

template<typename T>
std::string LabeledNode_get_label(LabeledNodeValue<T>* this__) {
    auto this_ = this__;
    return dart_str(this_->nodeLabel) + dart_str(std::string(":")) + dart_str(this_->value);
}

template<typename T>
std::string LabeledNode_toString(LabeledNodeValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("[")) + dart_str(this_->nodeLabel) + dart_str(std::string("]")) + dart_str(this_->value);
}

template<typename T>
T applyTransform(T value, TypeFunction1<T, T>* transform) {
    return transform->call(value);
}

template<typename T>
StaticList<T>* filterWith(StaticList<T>* items, TypeFunction1<bool, T>* predicate) {
    StaticList<T>* result = GC::allocateLocal(new StaticList<T>());
    StaticIterator<T>* sync_for_iterator = items->iterator();
    while (sync_for_iterator->moveNext()) {
        T item = sync_for_iterator->current();
        if (predicate->call(item)) {
            result->add(item);
        }
    }
    return result;
}

template<typename T>
T reduceList(StaticList<T>* items, TypeFunction2<T, T, T>* reducer) {
    T acc = items->first();
    int64_t i = 1LL;
    while ((i < items->length())) {
        (acc = reducer->call(acc, (*items)[i]));
        (i = (i + 1LL));
    }
    return acc;
}

StaticList<std::string>* testClosureBoxing() {
    StaticList<std::string>* log_ = GC::allocateLocal(new StaticList<std::string>());
    IntBox* counter = new IntBox(0LL);
    TypeFunction0<int64_t>* increment = GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_2(counter)));
    increment->call();
    increment->call();
    log_->add(dart_str(std::string("counter=")) + dart_str(counter->value));
    StaticList<TypeFunction0<int64_t>*>* fns = GC::allocateLocal(new StaticList<TypeFunction0<int64_t>*>());
    int64_t i = 0LL;
    while ((i < 3LL)) {
    fns->add(GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_3(i))));
    (i = (i + 1LL));
}
    log_->add(dart_str(std::string("fns=")) + dart_str(fns->map(GC::allocateLocal(static_cast<TypeFunction1<int64_t, TypeFunction0<int64_t>*>*>(new ClosureEnv_4())))));
    IntBox* outer = new IntBox(0LL);
    TypeFunction1<TypeFunction1<int64_t, int64_t>*, int64_t>* makeAdder = GC::allocateLocal(static_cast<TypeFunction1<TypeFunction1<int64_t, int64_t>*, int64_t>*>(new ClosureEnv_5(outer)));
    TypeFunction1<int64_t, int64_t>* adder = makeAdder->call(100LL);
    adder->call(5LL);
    adder->call(10LL);
    log_->add(dart_str(std::string("outer=")) + dart_str(outer->value) + dart_str(std::string(", adder(0)=")) + dart_str(adder->call(0LL)));
    std::function<std::string(std::string)> captureParam = [&](std::string prefix) -> std::string {
        IntBox* count = new IntBox(0LL);
    TypeFunction0<std::string>* fn = GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_7(count, prefix)));
    fn->call();
    fn->call();
    return fn->call();
};
log_->add(dart_str(std::string("captureParam=")) + dart_str(captureParam(std::string("test"))));
EventBusValue* bus = EventBus_new(GC::allocateLocal(new EventBusValue()));
StaticList<std::string>* received = GC::allocateLocal(new StaticList<std::string>());
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(bus->getVptrMap()["on"]))(bus, _box(GC::allocateLocal(static_cast<TypeFunction1<void, std::string>*>(new ClosureEnv_8(received)))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(bus->getVptrMap()["emit"]))(bus, _box(std::string("hello")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(bus->getVptrMap()["emit"]))(bus, _box(std::string("world")));
    log_->add(dart_str(std::string("received=")) + dart_str(received));
    return log_;
}

std::string testExceptionChain() {
    try {
        try {
            throw DartException(dart_str(AppError_new(GC::allocateLocal(new AppErrorValue()), std::string("not found"), std::string("E404"))));
        } catch (const DartException& e) {
            throw DartException(dart_str(AppError_new(GC::allocateLocal(new AppErrorValue()), std::string("service failed"), std::string("E500"), static_cast<AppErrorValue*>(nullptr))));
        }
    } catch (const DartException& e) {
        try {
            throw DartException(dart_str(AppError_new(GC::allocateLocal(new AppErrorValue()), std::string("gateway error"), std::string("E502"), static_cast<AppErrorValue*>(nullptr))));
        } catch (const DartException& e2) {
            return e2.toString();
        }
    }
}

std::string formatRecord(std::string name, int64_t age, std::string email, bool active, StaticList<std::string>* tags) {
    StaticList<std::string>* parts = GC::allocateLocal(new StaticList<std::string>({name}));
    if ((age > 0LL)) {
        parts->add(dart_str(std::string("age=")) + dart_str(age));
    }
    if (!((email.empty()))) {
        parts->add(dart_str(std::string("email=")) + dart_str(email));
    }
    parts->add(dart_str(std::string("active=")) + dart_str(active));
    if (tags->isNotEmpty()) {
        parts->add(dart_str(std::string("tags=")) + dart_str(tags));
    }
    return dart_str(std::string("Record(")) + dart_str(parts->join(std::string(", "))) + dart_str(std::string(")"));
}

std::string greetAll(std::string greeting, std::string name, std::string suffix) {
    return dart_str(greeting) + dart_str(std::string(", ")) + dart_str(name) + dart_str(suffix);
}

std::string describeShape(ShapeValue* shape) {
    if (dart_is<CircleValue>(shape)) {
        return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(shape->getVptrMap()["get_shapeName"]))(shape))) + dart_str(std::string(": r=")) + dart_str(static_cast<CircleValue*>(shape)->radius) + dart_str(std::string(", area=")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(2LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(shape->getVptrMap()["area"]))(shape)); return _ss.str(); })());
    } else {
        if (dart_is<RectangleValue>(shape)) {
            return dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(shape->getVptrMap()["get_shapeName"]))(shape))) + dart_str(std::string(": ")) + dart_str(static_cast<RectangleValue*>(shape)->width) + dart_str(std::string("x")) + dart_str(static_cast<RectangleValue*>(shape)->height) + dart_str(std::string(", area=")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(2LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(shape->getVptrMap()["area"]))(shape)); return _ss.str(); })());
        }
    }
    return dart_str(std::string("Unknown shape: area=")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(shape->getVptrMap()["area"]))(shape)));
}

std::string evaluateGrade(int64_t score) {
    std::string letter = ((score >= 90LL) ? std::string("A") : ((score >= 80LL) ? std::string("B") : ((score >= 70LL) ? std::string("C") : ((score >= 60LL) ? std::string("D") : std::string("F")))));
    std::string description{""};
    _L1:
    do {
        const std::string& _sw2 = letter;
        if (_sw2 == std::string("A")) {
            (description = std::string("Excellent"));
            break;
        }
        else if (_sw2 == std::string("B")) {
            (description = std::string("Good"));
            break;
        }
        else if (_sw2 == std::string("C")) {
            (description = std::string("Average"));
            break;
        }
        else if (_sw2 == std::string("D")) {
            (description = std::string("Below Average"));
            break;
        }
        else {
            (description = std::string("Failing"));
        }
    } while (false);
    return dart_str(score) + dart_str(std::string(" → ")) + dart_str(letter) + dart_str(std::string(" (")) + dart_str(description) + dart_str(std::string(")"));
}

int main() {
    staticPrint(std::string("--- 1. typedef + Function ---"));
    int64_t doubled = applyTransform<int64_t>(21LL, GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_9())));
    staticPrint(dart_str(std::string("applyTransform: ")) + dart_str(doubled));
    StaticList<int64_t>* evens = filterWith<int64_t>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL, 5LL, 6LL})), GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_10())));
    staticPrint(dart_str(std::string("filterWith: ")) + dart_str(evens));
    int64_t sum = reduceList<int64_t>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL, 5LL})), GC::allocateLocal(static_cast<TypeFunction2<int64_t, int64_t, int64_t>*>(new ClosureEnv_11())));
    staticPrint(dart_str(std::string("reduceList: ")) + dart_str(sum));
    staticPrint(std::string("\n--- 2. 枚举类 ---"));
    staticPrint(dart_str(std::string("red hex: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(Color::red->getVptrMap()["get_hex"]))(Color::red))));
    staticPrint(dart_str(std::string("green isWarm: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(Color::green->getVptrMap()["get_isWarm"]))(Color::green))));
    staticPrint(dart_str(std::string("priorities: ")) + dart_str(GC::allocateLocal(new StaticList<Priority*>({Priority::low, Priority::medium, Priority::high, Priority::critical}))->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, Priority*>*>(new ClosureEnv_12())))));
    staticPrint(std::string("\n--- 3. 运算符重载 ---"));
    MoneyValue* price1 = Money_new(GC::allocateLocal(new MoneyValue()), 1099LL, std::string("USD"));
    MoneyValue* price2 = Money_new_fromDollars(GC::allocateLocal(new MoneyValue()), 5.5);
    MoneyValue* total = reinterpret_cast<MoneyValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(price1->getVptrMap()["+"]))(price1, _box(price2)));
    MoneyValue* negated = reinterpret_cast<MoneyValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(price2->getVptrMap()["unary-"]))(price2));
    staticPrint(dart_str(std::string("price1: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(price1->getVptrMap()["toPrettyString"]))(price1))));
    staticPrint(dart_str(std::string("price2: ")) + dart_str(price2));
    staticPrint(dart_str(std::string("total: ")) + dart_str(total));
    staticPrint(dart_str(std::string("negated: ")) + dart_str(negated));
    staticPrint(dart_str(std::string("price1 > price2: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(price1->getVptrMap()[">"]))(price1, _box(price2)))));
    staticPrint(dart_str(std::string("price1 < price2: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(price1->getVptrMap()["<"]))(price1, _box(price2)))));
    staticPrint(dart_str(std::string("price1 * 3: ")) + dart_str(reinterpret_cast<MoneyValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(price1->getVptrMap()["*"]))(price1, _box(3LL)))));
    staticPrint(std::string("\n--- 4. 多层泛型继承 ---"));
    EntityValue<int64_t>* entity = Entity_new<int64_t>(GC::allocateLocal(new EntityValue<int64_t>()), 1LL, std::string("alice"));
    staticPrint(dart_str(std::string("entity: ")) + dart_str(entity));
    staticPrint(dart_str(std::string("entity label: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(entity->getVptrMap()["toPrettyString"]))(entity))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(entity->getVptrMap()["cacheValue"]))(entity, _box(std::string("cached_data")));
    staticPrint(dart_str(std::string("cached: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(entity->getVptrMap()["getCachedValue"]))(entity)));
    TimestampedEntityValue<std::string>* tsEntity = TimestampedEntity_new<std::string>(GC::allocateLocal(new TimestampedEntityValue<std::string>()), std::string("u1"), std::string("bob"), 1000LL, 2000LL);
    staticPrint(dart_str(std::string("tsEntity label: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(tsEntity->getVptrMap()["toPrettyString"]))(tsEntity))));
    VersionedEntityValue<int64_t>* vEntity = VersionedEntity_new<int64_t>(GC::allocateLocal(new VersionedEntityValue<int64_t>()), 42LL, std::string("project"), 1000LL, 5000LL);
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(vEntity->getVptrMap()["bump"]))(vEntity, _box(std::string("initial release")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(vEntity->getVptrMap()["bump"]))(vEntity, _box(std::string("bug fix")));
    staticPrint(dart_str(std::string("vEntity label: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(vEntity->getVptrMap()["toPrettyString"]))(vEntity))));
    staticPrint(dart_str(std::string("vEntity version: ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(vEntity->getVptrMap()["get_version"]))(vEntity))));
    staticPrint(dart_str(std::string("vEntity changelog: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(vEntity->getVptrMap()["get_changelog"]))(vEntity)));
    staticPrint(dart_str(std::string("vEntity serialize: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(vEntity->getVptrMap()["serialize"]))(vEntity))));
    staticPrint(dart_str(std::string("vEntity toJson: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(vEntity->getVptrMap()["toJson"]))(vEntity))));
    staticPrint(dart_str(std::string("vEntity isValid: ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(vEntity->getVptrMap()["get_isValid"]))(vEntity))));
    staticPrint(dart_str(std::string("vEntity validate: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(vEntity->getVptrMap()["validate"]))(vEntity)));
    staticPrint(std::string("\n--- 5. 工厂构造 ---"));
    ConfigValue* cfg1 = Config_new_empty(GC::allocateLocal(new ConfigValue()));
    (reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*,AnyGC*)>(cfg1->getVptrMap()["[]="]))(cfg1, _box(std::string("host")), _box(std::string("localhost")));
    staticPrint(dart_str(std::string("cfg1: ")) + dart_str(cfg1));
    ConfigValue* cfg2 = Config_new_fromPairs(GC::allocateLocal(new ConfigValue()), static_cast<StaticList<StaticList<AnyGC*>*>*>(GC::allocateLocal(new StaticList<StaticList<AnyGC*>*>({GC::allocateLocal(new StaticList<AnyGC*>({GC::allocateLocal(new StringBox(std::string("a"))), GC::allocateLocal(new IntBox(1LL))})), GC::allocateLocal(new StaticList<AnyGC*>({GC::allocateLocal(new StringBox(std::string("b"))), GC::allocateLocal(new IntBox(2LL))}))}))));
    staticPrint(dart_str(std::string("cfg2: ")) + dart_str(cfg2));
    ConfigValue* cfg3 = Config_new_withDefaults(([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("debug"), GC::allocateLocal(new BoolBox(true))); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("prod")))); return _m; })());
    staticPrint(dart_str(std::string("cfg3: ")) + dart_str(cfg3));
    staticPrint(dart_str(std::string("cfg3[maxRetries]: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(cfg3->getVptrMap()["[]"]))(cfg3, _box(std::string("maxRetries")))));
    staticPrint(std::string("\n--- 6. 闭包 Box 化 ---"));
    StaticList<std::string>* closureLog = testClosureBoxing();
    StaticIterator<std::string>* sync_for_iterator = closureLog->iterator();
    while (sync_for_iterator->moveNext()) {
        std::string line = sync_for_iterator->current();
        staticPrint(line);
    }
    staticPrint(std::string("\n--- 7. 多重 implements ---"));
    WidgetValue* widget = Widget_new(GC::allocateLocal(new WidgetValue()));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(widget->getVptrMap()["draw"]))(widget);
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(widget->getVptrMap()["resize"]))(widget, _box(1.5));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(widget->getVptrMap()["onClick"]))(widget);
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(widget->getVptrMap()["onClick"]))(widget);
    staticPrint(dart_str(std::string("widget: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(widget->getVptrMap()["get_info"]))(widget))));
    staticPrint(std::string("\n--- 8. 泛型 Pair ---"));
    PairValue<int64_t, std::string>* pair = Pair_new<int64_t, std::string>(GC::allocateLocal(new PairValue<int64_t, std::string>()), 42LL, std::string("hello"));
    staticPrint(dart_str(std::string("pair: ")) + dart_str(pair));
    staticPrint(dart_str(std::string("swap: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(pair->getVptrMap()["swap"]))(pair)));
    staticPrint(dart_str(std::string("mapFirst: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(pair->getVptrMap()["mapFirst"]))(pair, _box(GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_13()))))));
    staticPrint(dart_str(std::string("mapSecond: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(pair->getVptrMap()["mapSecond"]))(pair, _box(GC::allocateLocal(static_cast<TypeFunction1<std::string, std::string>*>(new ClosureEnv_14()))))));
    staticPrint(dart_str(std::string("fold: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(pair->getVptrMap()["fold"]))(pair, _box(GC::allocateLocal(static_cast<TypeFunction2<std::string, int64_t, std::string>*>(new ClosureEnv_15()))))));
    TripleValue<int64_t, std::string, bool>* triple = Triple_new<int64_t, std::string, bool>(GC::allocateLocal(new TripleValue<int64_t, std::string, bool>()), 1LL, std::string("yes"), true);
    staticPrint(dart_str(std::string("triple: ")) + dart_str(triple));
    staticPrint(std::string("\n--- 9. 级联操作 ---"));
    StringBuilderValue* sb = ([&]() { StringBuilderValue* _let9 = StringBuilder_new(GC::allocateLocal(new StringBuilderValue())); return ([&]() {     (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(_let9->getVptrMap()["withSeparator"]))(_let9, _box(std::string(", ")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(_let9->getVptrMap()["add"]))(_let9, _box(std::string("alpha")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(_let9->getVptrMap()["add"]))(_let9, _box(std::string("beta")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(_let9->getVptrMap()["addAll"]))(_let9, _box(GC::allocateLocal(new StaticList<std::string>({std::string("gamma"), std::string("delta")}))));
 return _let9; })(); })();
    staticPrint(dart_str(std::string("builder: ")) + dart_str(sb));
    staticPrint(dart_str(std::string("length: ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(sb->getVptrMap()["get_length"]))(sb))));
    staticPrint(std::string("\n--- 10. 异常处理链 ---"));
    staticPrint(dart_str(std::string("chain: ")) + dart_str(testExceptionChain()));
    staticPrint(std::string("\n--- 11. 集合操作 ---"));
    DataPipelineValue<int64_t>* pipeline = static_cast<DataPipelineValue<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL}))))->getVptrMap()["where"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL})))), _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_16())))))->getVptrMap()["sorted"]))(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL}))))->getVptrMap()["where"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL})))), _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_16()))))), _box(GC::allocateLocal(static_cast<TypeFunction2<int64_t, int64_t, int64_t>*>(new ClosureEnv_17())))))->getVptrMap()["take"]))(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL}))))->getVptrMap()["where"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL})))), _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_16())))))->getVptrMap()["sorted"]))(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL}))))->getVptrMap()["where"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL})))), _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_16()))))), _box(GC::allocateLocal(static_cast<TypeFunction2<int64_t, int64_t, int64_t>*>(new ClosureEnv_17()))))), _box(5LL)))->getVptrMap()["map"]))(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL}))))->getVptrMap()["where"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL})))), _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_16())))))->getVptrMap()["sorted"]))(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL}))))->getVptrMap()["where"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL})))), _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_16()))))), _box(GC::allocateLocal(static_cast<TypeFunction2<int64_t, int64_t, int64_t>*>(new ClosureEnv_17())))))->getVptrMap()["take"]))(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL}))))->getVptrMap()["where"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL})))), _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_16())))))->getVptrMap()["sorted"]))(static_cast<VPtr*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL}))))->getVptrMap()["where"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({5LL, 3LL, 8LL, 1LL, 9LL, 2LL, 7LL, 4LL, 6LL})))), _box(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_16()))))), _box(GC::allocateLocal(static_cast<TypeFunction2<int64_t, int64_t, int64_t>*>(new ClosureEnv_17()))))), _box(5LL))), _box(GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_18())))));
    staticPrint(dart_str(std::string("pipeline: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(pipeline->getVptrMap()["toList"]))(pipeline)));
    int64_t pipeSum = dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL, 5LL}))))->getVptrMap()["fold"]))(DataPipeline_new<int64_t>(GC::allocateLocal(new DataPipelineValue<int64_t>()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL, 5LL})))), _box(0LL), _box(GC::allocateLocal(static_cast<TypeFunction2<int64_t, int64_t, int64_t>*>(new ClosureEnv_19())))));
    staticPrint(dart_str(std::string("pipeSum: ")) + dart_str(pipeSum));
    staticPrint(std::string("\n--- 12. 可选参数 ---"));
    staticPrint(formatRecord(std::string("Alice"), 30LL, std::string("alice@test.com"), true, GC::allocateLocal(new StaticList<std::string>())));
    staticPrint(formatRecord(std::string("Bob"), 0, "", true, GC::allocateLocal(new StaticList<std::string>({std::string("admin"), std::string("vip")}))));
    staticPrint(greetAll(std::string("Hello")));
    staticPrint(greetAll(std::string("Hi"), std::string("Dart"), std::string("!!")));
    staticPrint(std::string("\n--- 13. BoundedValue ---"));
    BoundedValueValue* bv = BoundedValue_new(GC::allocateLocal(new BoundedValueValue()), 5.0, 0.0, 10.0);
    staticPrint(dart_str(std::string("bv: ")) + dart_str(bv));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(bv->getVptrMap()["set_value"]))(bv, _box(15.0));
    staticPrint(dart_str(std::string("after set 15: ")) + dart_str(bv));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(bv->getVptrMap()["set_value"]))(bv, _box((-5.0)));
    staticPrint(dart_str(std::string("after set -5: ")) + dart_str(bv));
    BoundedValueValue* bv2 = reinterpret_cast<BoundedValueValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(bv->getVptrMap()["+"]))(bv, _box(7.0)));
    staticPrint(dart_str(std::string("bv + 7: ")) + dart_str(bv2));
    staticPrint(std::string("\n--- 14. 静态方法 ---"));
    staticPrint(dart_str(std::string("5! = ")) + dart_str(MathUtils_factorial(5LL)));
    staticPrint(dart_str(std::string("fib(8): ")) + dart_str(MathUtils_fibonacci(8LL)));
    staticPrint(dart_str(std::string("lerp(0,100,0.3): ")) + dart_str(MathUtils_lerp(0.0, 100.0, 0.3)));
    staticPrint(dart_str(std::string("callCount: ")) + dart_str(MathUtils_get_callCount()));
    staticPrint(std::string("\n--- 15. ReactiveStore ---"));
    ReactiveStoreValue<int64_t>* store = ReactiveStore_new<int64_t>(GC::allocateLocal(new ReactiveStoreValue<int64_t>()));
    StaticList<int64_t>* observed = GC::allocateLocal(new StaticList<int64_t>());
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(store->getVptrMap()["observe"]))(store, _box(GC::allocateLocal(static_cast<TypeFunction1<void, int64_t>*>(new ClosureEnv_20(observed)))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(store->getVptrMap()["set"]))(store, _box(std::string("x")), _box(10LL));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(store->getVptrMap()["set"]))(store, _box(std::string("y")), _box(20LL));
    staticPrint(dart_str(std::string("store: ")) + dart_str(store));
    staticPrint(dart_str(std::string("store.get(x): ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(store->getVptrMap()["get"]))(store, _box(std::string("x")))));
    staticPrint(dart_str(std::string("store.size: ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(store->getVptrMap()["get_size"]))(store))));
    staticPrint(dart_str(std::string("observed: ")) + dart_str(observed));
    staticPrint(dart_str(std::string("logs: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(store->getVptrMap()["get_logs"]))(store)));
    staticPrint(std::string("\n--- 16. 类型转换 ---"));
    StaticList<ShapeValue*>* shapes = GC::allocateLocal(new StaticList<ShapeValue*>({Circle_new(GC::allocateLocal(new CircleValue()), 5.0), Rectangle_new(GC::allocateLocal(new RectangleValue()), 3.0, 4.0), Circle_new(GC::allocateLocal(new CircleValue()), 1.0)}));
    StaticIterator<ShapeValue*>* sync_for_iterator_3 = shapes->iterator();
    while (sync_for_iterator_3->moveNext()) {
        ShapeValue* s = sync_for_iterator_3->current();
        staticPrint(describeShape(s));
    }
    staticPrint(std::string("\n--- 18. 评分 ---"));
    staticPrint(evaluateGrade(95LL));
    staticPrint(evaluateGrade(82LL));
    staticPrint(evaluateGrade(67LL));
    staticPrint(evaluateGrade(55LL));
    staticPrint(std::string("\n=== 所有压力测试通过 ✅ ==="));
    return 0;
}

template<typename ID>
AnyGC* Entity_toPrettyString(EntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_))) + dart_str(std::string("]")));
}

template<typename ID>
void Entity_cacheValue(EntityValue<ID>* this__, AnyGC* value) {
    auto this_ = this__;
    _cache->set(dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheKey"]))(this_)), value);
}

template<typename ID>
AnyGC* Entity_getCachedValue(EntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(*(*_cache)[dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheKey"]))(this_))]);
}

template<typename ID>
AnyGC* TimestampedEntity_toPrettyString(TimestampedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_))) + dart_str(std::string("]")));
}

template<typename ID>
AnyGC* TimestampedEntity_get_cacheKey(TimestampedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(this_->id);
}

template<typename ID>
void TimestampedEntity_cacheValue(TimestampedEntityValue<ID>* this__, AnyGC* value) {
    auto this_ = this__;
    _cache->set(dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheKey"]))(this_)), value);
}

template<typename ID>
AnyGC* TimestampedEntity_getCachedValue(TimestampedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(*(*_cache)[dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheKey"]))(this_))]);
}

template<typename ID>
AnyGC* TimestampedEntity_toString(TimestampedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(Entity_toString<ID>(static_cast<EntityValue<ID>*>(this_)));
}

template<typename ID>
AnyGC* VersionedEntity_toPrettyString(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_))) + dart_str(std::string("]")));
}

template<typename ID>
AnyGC* VersionedEntity_get_cacheKey(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(this_->id);
}

template<typename ID>
void VersionedEntity_cacheValue(VersionedEntityValue<ID>* this__, AnyGC* value) {
    auto this_ = this__;
    _cache->set(dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheKey"]))(this_)), value);
}

template<typename ID>
AnyGC* VersionedEntity_getCachedValue(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(*(*_cache)[dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheKey"]))(this_))]);
}

template<typename ID>
AnyGC* VersionedEntity_toString(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("Entity(")) + dart_str(this_->id) + dart_str(std::string(", ")) + dart_str(this_->name) + dart_str(std::string(")")));
}

template<typename ID>
AnyGC* VersionedEntity_get_age(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(TimestampedEntity_get_age<ID>(static_cast<TimestampedEntityValue<ID>*>(this_)));
}

template<typename ID>
AnyGC* VersionedEntity_toJson(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("{\"data\": \"")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["serialize"]))(this_)) + dart_str(std::string("\"}")));
}

template<typename ID>
AnyGC* VersionedEntity_get_isValid(VersionedEntityValue<ID>* this__) {
    auto this_ = this__;
    return _box(static_cast<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["validate"]))(this_))->isEmpty());
}

AnyGC* Money_lt(MoneyValue* this__, AnyGC* other) {
    auto this_ = this__;
    return _box(Comparable2_lt(this_, other));
}

AnyGC* Money_gt(MoneyValue* this__, AnyGC* other) {
    auto this_ = this__;
    return _box(Comparable2_gt(this_, other));
}

AnyGC* Money_le(MoneyValue* this__, AnyGC* other) {
    auto this_ = this__;
    return _box(Comparable2_le(this_, other));
}

AnyGC* Money_ge(MoneyValue* this__, AnyGC* other) {
    auto this_ = this__;
    return _box(Comparable2_ge(this_, other));
}

AnyGC* Money_toPrettyString(MoneyValue* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_))) + dart_str(std::string("]")));
}

template<typename A, typename B, typename C>
AnyGC* Triple_swap(TripleValue<A, B, C>* this__) {
    auto this_ = this__;
    return _box(Pair_swap<A, B>(static_cast<PairValue<A, B>*>(this_)));
}

template<typename A, typename B, typename C>
AnyGC* Triple_mapFirst(TripleValue<A, B, C>* this__, TypeFunction1<C, A>* transform) {
    auto this_ = this__;
    return _box(Pair_mapFirst<A, B>(static_cast<PairValue<A, B>*>(this_), transform));
}

template<typename A, typename B, typename C>
AnyGC* Triple_mapSecond(TripleValue<A, B, C>* this__, TypeFunction1<C, B>* transform) {
    auto this_ = this__;
    return _box(Pair_mapSecond<A, B>(static_cast<PairValue<A, B>*>(this_), transform));
}

template<typename A, typename B, typename C, typename R>
AnyGC* Triple_fold(TripleValue<A, B, C>* this__, TypeFunction2<R, A, B>* combine) {
    auto this_ = this__;
    return _box(Pair_fold<A, B>(static_cast<PairValue<A, B>*>(this_), combine));
}

template<typename V>
void ReactiveStore_log_(ReactiveStoreValue<V>* this__, std::string message) {
    auto this_ = this__;
    this_->_logs->add(message);
}

template<typename V>
AnyGC* ReactiveStore_get_logs(ReactiveStoreValue<V>* this__) {
    auto this_ = this__;
    return _box(unmodifiable<std::string>(this_->_logs));
}

template<typename V>
void ReactiveStore_observe(ReactiveStoreValue<V>* this__, TypeFunction1<void, V>* callback) {
    auto this_ = this__;
    this_->_observers->add(callback);
}

template<typename V>
void ReactiveStore_notify(ReactiveStoreValue<V>* this__, V value) {
    auto this_ = this__;
    StaticIterator<TypeFunction1<void, V>*>* _sync_for_iterator = this_->_observers->iterator();
    while (_sync_for_iterator->moveNext()) {
        TypeFunction1<void, V>* cb = _sync_for_iterator->current();
        cb->call(value);
    }
}

template<typename T>
void LabeledNode_addChild(LabeledNodeValue<T>* this__, NodeValue<T>* child) {
    auto this_ = this__;
    return Node_addChild<T>(static_cast<NodeValue<T>*>(this_), child);
}

template<typename T>
AnyGC* LabeledNode_flatten(LabeledNodeValue<T>* this__) {
    auto this_ = this__;
    return _box(Node_flatten<T>(static_cast<NodeValue<T>*>(this_)));
}

template<typename T, typename R>
AnyGC* LabeledNode_mapTree(LabeledNodeValue<T>* this__, TypeFunction1<R, T>* transform) {
    auto this_ = this__;
    return _box(Node_mapTree<T>(static_cast<NodeValue<T>*>(this_), transform));
}

template<typename T>
AnyGC* LabeledNode_toPrettyString(LabeledNodeValue<T>* this__) {
    auto this_ = this__;
    return _box(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_label"]))(this_))) + dart_str(std::string("]")));
}


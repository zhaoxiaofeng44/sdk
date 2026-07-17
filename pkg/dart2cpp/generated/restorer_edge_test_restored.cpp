#include "dart2cpp_lowered.h"

struct LazyConfigValue;
struct LateWithDependencyValue;
struct LoggerMixin;
template<typename T> struct ValidatorMixin;
struct ServiceValue;
struct Vector2DValue;
template<typename T> struct RepositoryValue;
struct CacheableValue;
template<typename T> struct InMemoryCacheMixin;
struct ItemRepoValue;
struct ConfigValue;
StaticList<std::string>* Logger_messages(LoggerMixin* this__);
Promise<void>* Logger_logAsync(LoggerMixin* this__, std::string msg);
void Logger_logSync(LoggerMixin* this__, std::string msg);
template<typename T> bool Validator_validate(ValidatorMixin<T>* this__, T value);
template<typename T> Promise<bool>* Validator_validateAsync(ValidatorMixin<T>* this__, T value);
template<typename T> bool InMemoryCache_isCached(InMemoryCacheMixin<T>* this__, std::string key);
template<typename T> void InMemoryCache_invalidate(InMemoryCacheMixin<T>* this__, std::string key);
template<typename T> Promise<T>* InMemoryCache_cachedFindById(InMemoryCacheMixin<T>* this__, std::string id);
LazyConfigValue* LazyConfig_new(LazyConfigValue* this__, std::string name);
int64_t LazyConfig__nextId();
std::string LazyConfig__expensiveInit(LazyConfigValue* this__);
LateWithDependencyValue* LateWithDependency_new(LateWithDependencyValue* this__);
std::string LateWithDependency_describe(LateWithDependencyValue* this__);
ServiceValue* Service_new(ServiceValue* this__);
bool Service_validate(ServiceValue* this__, std::string value);
Promise<std::string>* Service_process(ServiceValue* this__, std::string input);
Vector2DValue* Vector2D_new(Vector2DValue* this__, double x, double y);
Vector2DValue* Vector2D_add(Vector2DValue* this__, Vector2DValue* other);
Vector2DValue* Vector2D_sub(Vector2DValue* this__, Vector2DValue* other);
Vector2DValue* Vector2D_mul(Vector2DValue* this__, double scalar);
bool Vector2D_eq(Vector2DValue* this__, AnyGC* other);
int64_t Vector2D_get_hashCode(Vector2DValue* this__);
double Vector2D_magnitude(Vector2DValue* this__);
std::string Vector2D_toString(Vector2DValue* this__);
template<typename T> RepositoryValue<T>* Repository_new(RepositoryValue<T>* this__);
template<typename T> Promise<T>* Repository_findById(RepositoryValue<T>* this__, std::string id);
template<typename T> Promise<StaticList<T>*>* Repository_findAll(RepositoryValue<T>* this__);
template<typename T> Promise<void>* Repository_save(RepositoryValue<T>* this__, std::string id, T item);
CacheableValue* Cacheable_new(CacheableValue* this__);
bool Cacheable_isCached(CacheableValue* this__, std::string key);
void Cacheable_invalidate(CacheableValue* this__, std::string key);
ItemRepoValue* ItemRepo_new(ItemRepoValue* this__);
Promise<std::string>* ItemRepo_findById(ItemRepoValue* this__, std::string id);
Promise<StaticList<std::string>*>* ItemRepo_findAll(ItemRepoValue* this__);
Promise<void>* ItemRepo_save(ItemRepoValue* this__, std::string id, std::string item);
ConfigValue* Config_new__internal(ConfigValue* this__, std::string env, int64_t port, bool debug);
ConfigValue* Config_new_development();
ConfigValue* Config_new_production();
ConfigValue* Config_new_custom(std::string env, int64_t port);
std::string Config_toString(ConfigValue* this__);
Promise<AnyGC*>* logMessage(std::string msg);
Promise<AnyGC*>* logWithDelay(std::string msg, int64_t ticks);
Promise<AnyGC*>* safeLog(std::string msg);
StaticList<int64_t>* collectOdds(int64_t n);
int64_t countDigits(int64_t n);
StaticList<std::string>* skipEmpty(StaticList<std::string>* items);
std::string classify(int64_t n);
Promise<int64_t>* awaitNonFuture();
Promise<std::string>* awaitMixed();
Promise<int64_t>* deepAsync(int64_t depth);
Promise<std::string>* asyncErrorChain();
Promise<int64_t>* _failingAsync();
Promise<std::string>* nestedTryAsync();
Promise<std::string>* asyncWithClosure();
Promise<std::string>* nestedClosureAsync();
Vector2DValue* sumVectors(StaticList<Vector2DValue*>* vectors);
StaticList<Vector2DValue*>* scaleAll(StaticList<Vector2DValue*>* vectors, double factor);
AnyGC* nameAge(std::string name, int64_t age);
AnyGC* personInfo(std::string n, int64_t a, std::string r);
StaticList<AnyGC*>* topN(StaticList<AnyGC*>* data, int64_t n);
std::string describeValue(AnyGC* value);
int main();
StaticList<std::string>* Service_Object_Logger_get_messages(ServiceValue* this__);
AnyGC* Service_Object_Logger_logAsync(ServiceValue* this__, std::string msg);
void Service_Object_Logger_logSync(ServiceValue* this__, std::string msg);
AnyGC* Service_Object_Logger_Validator_validateAsync(ServiceValue* this__, std::string value);
AnyGC* ItemRepo_Repository_InMemoryCache_isCached(ItemRepoValue* this__, std::string key);
void ItemRepo_Repository_InMemoryCache_invalidate(ItemRepoValue* this__, std::string key);
AnyGC* ItemRepo_Repository_InMemoryCache_cachedFindById(ItemRepoValue* this__, std::string id);
extern StaticList<std::string>* log_;
StaticList<std::string>* Service_get_messages(ServiceValue* this__);
AnyGC* Service_logAsync(ServiceValue* this__, std::string msg);
void Service_logSync(ServiceValue* this__, std::string msg);
AnyGC* Service_validateAsync(ServiceValue* this__, std::string value);
AnyGC* ItemRepo_isCached(ItemRepoValue* this__, std::string key);
void ItemRepo_invalidate(ItemRepoValue* this__, std::string key);
AnyGC* ItemRepo_cachedFindById(ItemRepoValue* this__, std::string id);

struct LoggerMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> LoggerMixin::_vptrMap;


template<typename T>
struct ValidatorMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
template<typename T> std::unordered_map<std::string, void*> ValidatorMixin<T>::_vptrMap;


template<typename T>
struct InMemoryCacheMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
    StaticMap<std::string, T>* _cache{nullptr};
};
template<typename T> std::unordered_map<std::string, void*> InMemoryCacheMixin<T>::_vptrMap;


struct LazyConfigValue : VPtr {
    std::string computed{""};
    int64_t counter{0};
    std::string name{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> LazyConfigValue::_vptrMap;

struct LateWithDependencyValue : VPtr {
    int64_t base{0};
    int64_t doubled{0};
    std::string label{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> LateWithDependencyValue::_vptrMap;

struct ServiceValue : VPtr {
    StaticList<std::string>* messages{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (messages) messages->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ServiceValue::_vptrMap;

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

template<typename T>
struct RepositoryValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> RepositoryValue<T>::_vptrMap;

struct CacheableValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> CacheableValue::_vptrMap;

struct ItemRepoValue : RepositoryValue<AnyGC*> {
    StaticMap<std::string, std::string>* _store{nullptr};
    StaticMap<std::string, std::string>* _cache{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        RepositoryValue<AnyGC*>::gcMark(flag);
        if (_store) _store->gcMark(flag);
        if (_cache) _cache->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ItemRepoValue::_vptrMap;

struct ConfigValue : VPtr {
    std::string env{""};
    int64_t port{0};
    bool debug{false};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ConfigValue::_vptrMap;

struct ClosureEnv_0 : TypeFunction2<Vector2DValue*, Vector2DValue*, Vector2DValue*> {
    ClosureEnv_0() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<Vector2DValue*>(_p0), static_cast<Vector2DValue*>(_p1)));
    }
    Vector2DValue* call(Vector2DValue* a, Vector2DValue* b) {
    return reinterpret_cast<Vector2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(a->getVptrMap()["+"]))(a, _box(b)));
    }
};

struct ClosureEnv_1 : TypeFunction1<Vector2DValue*, Vector2DValue*> {
    double factor;
    ClosureEnv_1(double factor) : factor(std::move(factor)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<Vector2DValue*>(_p0)));
    }
    Vector2DValue* call(Vector2DValue* v) {
    return reinterpret_cast<Vector2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(v->getVptrMap()["*"]))(v, _box(factor)));
    }
};

struct ClosureEnv_2 : TypeFunction2<int64_t, AnyGC*, AnyGC*> {
    ClosureEnv_2() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<AnyGC*>(_p0), static_cast<AnyGC*>(_p1)));
    }
    int64_t call(AnyGC* a, AnyGC* b) {
    return ((std::get<1>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(b)->data))) > static_cast<int64_t>(std::get<1>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(a)->data))) ? 1LL : ((std::get<1>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(b)->data))) < static_cast<int64_t>(std::get<1>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(a)->data))) ? -1LL : 0LL));
    }
};


StaticList<std::string>* Logger_messages(LoggerMixin* this__) {
    auto this_ = this__;
    return nullptr;
}

Promise<void>* Logger_logAsync(LoggerMixin* this__, std::string msg) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<void>());
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    static_cast<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_messages"]))(this_))->add(dart_str(std::string("[async] ")) + dart_str(msg));
    _promise->complete(nullptr);
    return _promise;
}

void Logger_logSync(LoggerMixin* this__, std::string msg) {
    auto this_ = this__;
    static_cast<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_messages"]))(this_))->add(dart_str(std::string("[sync] ")) + dart_str(msg));
}

template<typename T>
bool Validator_validate(ValidatorMixin<T>* this__, T value) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Validator.validate")));
}

template<typename T>
Promise<bool>* Validator_validateAsync(ValidatorMixin<T>* this__, T value) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<bool>());
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    _promise->complete(_box(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["validate"]))(this_, _box(value)))));
    return _promise;
}

template<typename T>
bool InMemoryCache_isCached(InMemoryCacheMixin<T>* this__, std::string key) {
    auto this_ = this__;
    return this_->_cache->containsKey(key);
}

template<typename T>
void InMemoryCache_invalidate(InMemoryCacheMixin<T>* this__, std::string key) {
    auto this_ = this__;
    _box(this_->_cache->remove(key));
    return;
}

template<typename T>
Promise<T>* InMemoryCache_cachedFindById(InMemoryCacheMixin<T>* this__, std::string id) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<T>());
    if (dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["isCached"]))(this_, _box(id)))) {
        _promise->complete(_box((*(*this_->_cache)[id])));
        return _promise;
    }
    T item = dynAs<T>(smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["findById"]))(this_, _box(id)))));
    if (!((dart_isNull(item)))) {
        this_->_cache->set(id, item);
    }
    _promise->complete(_box(item));
    return _promise;
}

int64_t _idCounter = 0LL;
LazyConfigValue* LazyConfig_new(LazyConfigValue* this__, std::string name) {
    auto this_ = this__;
    this_->name = name;
    this_->computed = LazyConfig__expensiveInit(this_);
    this_->counter = LazyConfig__nextId();
    return this_;
}

int64_t LazyConfig__nextId() {
    return _idCounter = (_idCounter + 1LL);
}

std::string LazyConfig__expensiveInit(LazyConfigValue* this__) {
    auto this_ = this__;
    return dart_str(this_->name) + dart_str(std::string("_config_initialized"));
}

AnyGC* _vptr_wrap_LateWithDependency_describe(AnyGC* obj__) {
    return _box(LateWithDependency_describe(static_cast<LateWithDependencyValue*>(obj__)));
}

static bool _LateWithDependency_vptr_registered = []{ LateWithDependencyValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_LateWithDependency_describe); return true; }();
LateWithDependencyValue* LateWithDependency_new(LateWithDependencyValue* this__) {
    auto this_ = this__;
    if (LateWithDependencyValue::_vptrMap.empty()) {
        LateWithDependencyValue::_vptrMap["describe"] = reinterpret_cast<void*>(&_vptr_wrap_LateWithDependency_describe);
    }
    this_->base = 10LL;
    this_->doubled = (this_->base * 2LL);
    this_->label = dart_str(std::string("val=")) + dart_str(this_->doubled);
    return this_;
}

std::string LateWithDependency_describe(LateWithDependencyValue* this__) {
    auto this_ = this__;
    return this_->label;
}

AnyGC* _vptr_wrap_Service_get_messages(AnyGC* obj__) {
    return _box(Service_get_messages(static_cast<ServiceValue*>(obj__)));
}

AnyGC* _vptr_wrap_Service_logAsync(AnyGC* obj__, AnyGC* arg0) {
    return _box(Service_logAsync(static_cast<ServiceValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_Service_logSync(AnyGC* obj__, AnyGC* arg0) {
    Service_logSync(static_cast<ServiceValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_Service_validate(AnyGC* obj__, AnyGC* arg0) {
    return _box(Service_validate(static_cast<ServiceValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_Service_validateAsync(AnyGC* obj__, AnyGC* arg0) {
    return _box(Service_validateAsync(static_cast<ServiceValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_Service_process(AnyGC* obj__, AnyGC* arg0) {
    return _box(Service_process(static_cast<ServiceValue*>(obj__), dynAs<std::string>(arg0)));
}

static bool _Service_vptr_registered = []{ ServiceValue::_vptrMap["get_messages"] = reinterpret_cast<void*>(&_vptr_wrap_Service_get_messages); ServiceValue::_vptrMap["logAsync"] = reinterpret_cast<void*>(&_vptr_wrap_Service_logAsync); ServiceValue::_vptrMap["logSync"] = reinterpret_cast<void*>(&_vptr_wrap_Service_logSync); ServiceValue::_vptrMap["validate"] = reinterpret_cast<void*>(&_vptr_wrap_Service_validate); ServiceValue::_vptrMap["validateAsync"] = reinterpret_cast<void*>(&_vptr_wrap_Service_validateAsync); ServiceValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_Service_process); return true; }();
ServiceValue* Service_new(ServiceValue* this__) {
    auto this_ = this__;
    if (ServiceValue::_vptrMap.empty()) {
        ServiceValue::_vptrMap["get_messages"] = reinterpret_cast<void*>(&_vptr_wrap_Service_get_messages);
        ServiceValue::_vptrMap["logAsync"] = reinterpret_cast<void*>(&_vptr_wrap_Service_logAsync);
        ServiceValue::_vptrMap["logSync"] = reinterpret_cast<void*>(&_vptr_wrap_Service_logSync);
        ServiceValue::_vptrMap["validate"] = reinterpret_cast<void*>(&_vptr_wrap_Service_validate);
        ServiceValue::_vptrMap["validateAsync"] = reinterpret_cast<void*>(&_vptr_wrap_Service_validateAsync);
        ServiceValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_Service_process);
    }
    this_->messages = GC::allocateLocal(new StaticList<std::string>());
    return this_;
}

bool Service_validate(ServiceValue* this__, std::string value) {
    auto this_ = this__;
    return !value.empty();
}

Promise<std::string>* Service_process(ServiceValue* this__, std::string input) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["logSync"]))(this_, _box(dart_str(std::string("processing: ")) + dart_str(input)));
    smAwait<void>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["logAsync"]))(this_, _box(dart_str(std::string("validating: ")) + dart_str(input))));
    bool valid = smAwait<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["validateAsync"]))(this_, _box(input)));
    if (!(valid)) {
        _promise->complete(_box(std::string("invalid")));
        return _promise;
    }
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["logSync"]))(this_, _box(std::string("done")));
    _promise->complete(_box(dart_str(std::string("ok: ")) + dart_str(input)));
    return _promise;
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

AnyGC* _vptr_wrap_Vector2D_get_hashCode(AnyGC* obj__) {
    return _box(Vector2D_get_hashCode(static_cast<Vector2DValue*>(obj__)));
}

AnyGC* _vptr_wrap_Vector2D_magnitude(AnyGC* obj__) {
    return _box(Vector2D_magnitude(static_cast<Vector2DValue*>(obj__)));
}

AnyGC* _vptr_wrap_Vector2D_toString(AnyGC* obj__) {
    return _box(Vector2D_toString(static_cast<Vector2DValue*>(obj__)));
}

static bool _Vector2D_vptr_registered = []{ Vector2DValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_add); Vector2DValue::_vptrMap["-"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_sub); Vector2DValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_mul); Vector2DValue::_vptrMap["=="] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_eq); Vector2DValue::_vptrMap["get_hashCode"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_get_hashCode); Vector2DValue::_vptrMap["magnitude"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_magnitude); Vector2DValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_toString); return true; }();
Vector2DValue* Vector2D_new(Vector2DValue* this__, double x, double y) {
    auto this_ = this__;
    if (Vector2DValue::_vptrMap.empty()) {
        Vector2DValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_add);
        Vector2DValue::_vptrMap["-"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_sub);
        Vector2DValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_mul);
        Vector2DValue::_vptrMap["=="] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_eq);
        Vector2DValue::_vptrMap["get_hashCode"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_get_hashCode);
        Vector2DValue::_vptrMap["magnitude"] = reinterpret_cast<void*>(&_vptr_wrap_Vector2D_magnitude);
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

int64_t Vector2D_get_hashCode(Vector2DValue* this__) {
    auto this_ = this__;
    return (static_cast<int64_t>(std::hash<double>{}(this_->x)) ^ static_cast<int64_t>(std::hash<double>{}(this_->y)));
}

double Vector2D_magnitude(Vector2DValue* this__) {
    auto this_ = this__;
    return std::abs(((this_->x * this_->x) + (this_->y * this_->y)));
}

std::string Vector2D_toString(Vector2DValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("(")) + dart_str(this_->x) + dart_str(std::string(", ")) + dart_str(this_->y) + dart_str(std::string(")"));
}

template<typename T>
AnyGC* _vptr_wrap_Repository_findById(AnyGC* obj__, AnyGC* arg0) {
    return _box(Repository_findById<T>(static_cast<RepositoryValue<T>*>(obj__), dynAs<std::string>(arg0)));
}

template<typename T>
AnyGC* _vptr_wrap_Repository_findAll(AnyGC* obj__) {
    return _box(Repository_findAll<T>(static_cast<RepositoryValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_Repository_save(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    return _box(Repository_save<T>(static_cast<RepositoryValue<T>*>(obj__), dynAs<std::string>(arg0), dynAs<T>(arg1)));
}

template<typename T> void _register_Repository_vptr() {
    if (RepositoryValue<T>::_vptrMap.empty()) {
        RepositoryValue<T>::_vptrMap["findById"] = reinterpret_cast<void*>(&_vptr_wrap_Repository_findById<T>);
        RepositoryValue<T>::_vptrMap["findAll"] = reinterpret_cast<void*>(&_vptr_wrap_Repository_findAll<T>);
        RepositoryValue<T>::_vptrMap["save"] = reinterpret_cast<void*>(&_vptr_wrap_Repository_save<T>);
    }
}
template<typename T>
RepositoryValue<T>* Repository_new(RepositoryValue<T>* this__) {
    auto this_ = this__;
    if (RepositoryValue<T>::_vptrMap.empty()) {
        RepositoryValue<T>::_vptrMap["findById"] = reinterpret_cast<void*>(&_vptr_wrap_Repository_findById<T>);
        RepositoryValue<T>::_vptrMap["findAll"] = reinterpret_cast<void*>(&_vptr_wrap_Repository_findAll<T>);
        RepositoryValue<T>::_vptrMap["save"] = reinterpret_cast<void*>(&_vptr_wrap_Repository_save<T>);
    }
    return this_;
}

template<typename T>
Promise<T>* Repository_findById(RepositoryValue<T>* this__, std::string id) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Repository.findById")));
}

template<typename T>
Promise<StaticList<T>*>* Repository_findAll(RepositoryValue<T>* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Repository.findAll")));
}

template<typename T>
Promise<void>* Repository_save(RepositoryValue<T>* this__, std::string id, T item) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Repository.save")));
}

AnyGC* _vptr_wrap_Cacheable_isCached(AnyGC* obj__, AnyGC* arg0) {
    return _box(Cacheable_isCached(static_cast<CacheableValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_Cacheable_invalidate(AnyGC* obj__, AnyGC* arg0) {
    Cacheable_invalidate(static_cast<CacheableValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

static bool _Cacheable_vptr_registered = []{ CacheableValue::_vptrMap["isCached"] = reinterpret_cast<void*>(&_vptr_wrap_Cacheable_isCached); CacheableValue::_vptrMap["invalidate"] = reinterpret_cast<void*>(&_vptr_wrap_Cacheable_invalidate); return true; }();
CacheableValue* Cacheable_new(CacheableValue* this__) {
    auto this_ = this__;
    if (CacheableValue::_vptrMap.empty()) {
        CacheableValue::_vptrMap["isCached"] = reinterpret_cast<void*>(&_vptr_wrap_Cacheable_isCached);
        CacheableValue::_vptrMap["invalidate"] = reinterpret_cast<void*>(&_vptr_wrap_Cacheable_invalidate);
    }
    return this_;
}

bool Cacheable_isCached(CacheableValue* this__, std::string key) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Cacheable.isCached")));
}

void Cacheable_invalidate(CacheableValue* this__, std::string key) {
    auto this_ = this__;
}

AnyGC* _vptr_wrap_ItemRepo_findById(AnyGC* obj__, AnyGC* arg0) {
    return _box(ItemRepo_findById(static_cast<ItemRepoValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_ItemRepo_findAll(AnyGC* obj__) {
    return _box(ItemRepo_findAll(static_cast<ItemRepoValue*>(obj__)));
}

AnyGC* _vptr_wrap_ItemRepo_save(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    return _box(ItemRepo_save(static_cast<ItemRepoValue*>(obj__), dynAs<std::string>(arg0), dynAs<std::string>(arg1)));
}

AnyGC* _vptr_wrap_ItemRepo_isCached(AnyGC* obj__, AnyGC* arg0) {
    return _box(ItemRepo_isCached(static_cast<ItemRepoValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_ItemRepo_invalidate(AnyGC* obj__, AnyGC* arg0) {
    ItemRepo_invalidate(static_cast<ItemRepoValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_ItemRepo_cachedFindById(AnyGC* obj__, AnyGC* arg0) {
    return _box(ItemRepo_cachedFindById(static_cast<ItemRepoValue*>(obj__), dynAs<std::string>(arg0)));
}

static bool _ItemRepo_vptr_registered = []{ ItemRepoValue::_vptrMap["findById"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_findById); ItemRepoValue::_vptrMap["findAll"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_findAll); ItemRepoValue::_vptrMap["save"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_save); ItemRepoValue::_vptrMap["isCached"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_isCached); ItemRepoValue::_vptrMap["invalidate"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_invalidate); ItemRepoValue::_vptrMap["cachedFindById"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_cachedFindById); return true; }();
ItemRepoValue* ItemRepo_new(ItemRepoValue* this__) {
    auto this_ = this__;
    if (ItemRepoValue::_vptrMap.empty()) {
        ItemRepoValue::_vptrMap["findById"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_findById);
        ItemRepoValue::_vptrMap["findAll"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_findAll);
        ItemRepoValue::_vptrMap["save"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_save);
        ItemRepoValue::_vptrMap["isCached"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_isCached);
        ItemRepoValue::_vptrMap["invalidate"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_invalidate);
        ItemRepoValue::_vptrMap["cachedFindById"] = reinterpret_cast<void*>(&_vptr_wrap_ItemRepo_cachedFindById);
    }
    Repository_new<AnyGC*>(this_);
    this_->_store = StaticMap<std::string, std::string>::empty();
    this_->_cache = StaticMap<std::string, std::string>::empty();
    return this_;
}

Promise<std::string>* ItemRepo_findById(ItemRepoValue* this__, std::string id) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    _promise->complete(_box((*(*this_->_store)[id])));
    return _promise;
}

Promise<StaticList<std::string>*>* ItemRepo_findAll(ItemRepoValue* this__) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<StaticList<std::string>*>());
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    _promise->complete(_box(this_->_store->values()));
    return _promise;
}

Promise<void>* ItemRepo_save(ItemRepoValue* this__, std::string id, std::string item) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<void>());
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    this_->_store->set(id, item);
    _promise->complete(nullptr);
    return _promise;
}

AnyGC* _vptr_wrap_Config_toString(AnyGC* obj__) {
    return _box(Config_toString(static_cast<ConfigValue*>(obj__)));
}

static bool _Config_vptr_registered = []{ ConfigValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Config_toString); return true; }();
ConfigValue* Config_new__internal(ConfigValue* this__, std::string env, int64_t port, bool debug) {
    auto this_ = this__;
    this_->env = env;
    this_->port = port;
    this_->debug = debug;
    return this_;
}

ConfigValue* Config_new_development() {
    return Config_new__internal(GC::allocateLocal(new ConfigValue()), std::string("dev"), 3000LL, true);
}

ConfigValue* Config_new_production() {
    return Config_new__internal(GC::allocateLocal(new ConfigValue()), std::string("prod"), 8080LL, false);
}

ConfigValue* Config_new_custom(std::string env, int64_t port) {
    return Config_new__internal(GC::allocateLocal(new ConfigValue()), env, port, (env == std::string("dev")));
}

std::string Config_toString(ConfigValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Config(")) + dart_str(this_->env) + dart_str(std::string(", port=")) + dart_str(this_->port) + dart_str(std::string(", debug=")) + dart_str(this_->debug) + dart_str(std::string(")"));
}

Promise<AnyGC*>* logMessage(std::string msg) {
    auto _promise = GC::allocateLocal(new Promise<AnyGC*>());
    std::string prefix = dynAs<std::string>(smAwait<AnyGC*>(_box(Promise<std::string>::resolved(std::string("[LOG]")))));
    log_->add(dart_str(prefix) + dart_str(std::string(" ")) + dart_str(msg));
    _promise->complete(nullptr);
    return _promise;
}

Promise<AnyGC*>* logWithDelay(std::string msg, int64_t ticks) {
    auto _promise = GC::allocateLocal(new Promise<AnyGC*>());
    smAwait<AnyGC*>(_box(promiseDelayed(1, []() -> AnyGC* { return nullptr; })));
    log_->add(msg);
    _promise->complete(nullptr);
    return _promise;
}

Promise<AnyGC*>* safeLog(std::string msg) {
    auto _promise = GC::allocateLocal(new Promise<AnyGC*>());
    try {
        std::string result = dynAs<std::string>(smAwait<AnyGC*>(_box(Promise<std::string>::resolved(msg))));
        log_->add(dart_str(std::string("safe: ")) + dart_str(result));
    } catch (const DartException& e) {
        log_->add(dart_str(std::string("error: ")) + dart_str(e));
    }
    _promise->complete(nullptr);
    return _promise;
}

StaticList<int64_t>* collectOdds(int64_t n) {
    StaticList<int64_t>* result = GC::allocateLocal(new StaticList<int64_t>());
    int64_t i = 0LL;
    while ((i < n)) {
        _L0:
        do {
            if (((i % 2LL) == 0LL)) {
                break;
            }
            result->add(i);
        } while (false);
        (i = (i + 1LL));
    }
    return result;
}

int64_t countDigits(int64_t n) {
    int64_t count = 0LL;
    while ((n > 0LL)) {
        _L1:
        do {
            int64_t digit = (n % 10LL);
            (n = (n / 10LL));
            if ((digit == 0LL)) {
                break;
            }
            (count = (count + 1LL));
        } while (false);
    }
    return count;
}

StaticList<std::string>* skipEmpty(StaticList<std::string>* items) {
    StaticList<std::string>* result = GC::allocateLocal(new StaticList<std::string>());
    int64_t i = 0LL;
    do {
        _L2:
        do {
            if ((*items)[i].empty()) {
                (i = (i + 1LL));
                break;
            }
            result->add((*items)[i]);
            (i = (i + 1LL));
        } while (false);
    } while ((i < items->length()));
    return result;
}

std::string classify(int64_t n) {
    StaticStringBuffer* result = GC::allocateLocal(new StaticStringBuffer());
    _L3:
    do {
        switch ((n % 5LL)) {
            _sw_case_0:
            case 0:
            {
                result->write(std::string("div5"));
                goto _sw_case_5;
                break;
            }
            _sw_case_1:
            case 1:
            {
                result->write(std::string("mod1"));
                break;
                break;
            }
            _sw_case_2:
            case 2:
            {
                result->write(std::string("mod2"));
                break;
                break;
            }
            _sw_case_3:
            case 3:
            {
                result->write(std::string("mod3"));
                goto _sw_case_5;
                break;
            }
            _sw_case_4:
            case 4:
            {
                result->write(std::string("mod4"));
                break;
                break;
            }
            _sw_case_5:
            default: {
                result->write(std::string("(default)"));
                break;
            }
        }
    } while (false);
    return result->toString();
}

Promise<int64_t>* awaitNonFuture() {
    auto _promise = GC::allocateLocal(new Promise<int64_t>());
    int64_t a = dynAs<int64_t>(smAwait<AnyGC*>(_box(42LL)));
    std::string b = dynAs<std::string>(smAwait<AnyGC*>(_box(std::string("hello"))));
    bool c = dynAs<bool>(smAwait<AnyGC*>(_box(true)));
    _promise->complete(_box(((a + static_cast<int64_t>(b.length())) + (c ? 1LL : 0LL))));
    return _promise;
}

Promise<std::string>* awaitMixed() {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    int64_t x = dynAs<int64_t>(smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(10LL))));
    int64_t y = dynAs<int64_t>(smAwait<AnyGC*>(_box(20LL)));
    int64_t z = dynAs<int64_t>(smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(30LL))));
    _promise->complete(_box(dart_str(std::string("sum=")) + dart_str(((x + y) + z))));
    return _promise;
}

Promise<int64_t>* deepAsync(int64_t depth) {
    auto _promise = GC::allocateLocal(new Promise<int64_t>());
    if ((depth <= 0LL)) {
        _promise->complete(_box(1LL));
        return _promise;
    }
    int64_t sub = smAwait<int64_t>(deepAsync((depth - 1LL)));
    _promise->complete(_box((sub + depth)));
    return _promise;
}

Promise<std::string>* asyncErrorChain() {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    try {
        int64_t v = smAwait<int64_t>(_failingAsync());
        _promise->complete(_box(dart_str(std::string("unexpected: ")) + dart_str(v)));
        return _promise;
    } catch (const DartException& e) {
        _promise->complete(_box(dart_str(std::string("caught: ")) + dart_str(e)));
        return _promise;
    }
}

Promise<int64_t>* _failingAsync() {
    auto _promise = GC::allocateLocal(new Promise<int64_t>());
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    throw DartException(std::string("deep failure"));
    _promise->complete(nullptr);
    return _promise;
}

Promise<std::string>* nestedTryAsync() {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    StaticList<std::string>* steps = GC::allocateLocal(new StaticList<std::string>());
    try {
        steps->add(std::string("outer-try"));
        try {
            steps->add(std::string("inner-try"));
            smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(1LL)));
            throw DartException(std::string("inner"));
        } catch (const DartException& e) {
            steps->add(dart_str(std::string("inner-catch: ")) + dart_str(e));
            throw DartException(std::string("rethrown"));
        }
        // finally
        steps->add(std::string("inner-finally"));
    } catch (const DartException& e) {
        steps->add(dart_str(std::string("outer-catch: ")) + dart_str(e));
    }
    // finally
    steps->add(std::string("outer-finally"));
    _promise->complete(_box(steps->join(std::string(" -> "))));
    return _promise;
}

Promise<std::string>* asyncWithClosure() {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    std::string prefix = std::string("result");
    std::function<std::string(int64_t)> format = [&](int64_t value) -> std::string {
        return dart_str(prefix) + dart_str(std::string(": ")) + dart_str(value);
    };
    int64_t v = dynAs<int64_t>(smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(42LL))));
    _promise->complete(_box(format(v)));
    return _promise;
}

Promise<std::string>* nestedClosureAsync() {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    std::string outer = std::string("start");
    std::function<std::string(std::string)> transform = [&](std::string input) -> std::string {
        std::string inner = input;
        std::function<std::string()> apply = [&]() -> std::string {
            return dart_str(outer) + dart_str(std::string("->")) + dart_str(inner);
        };
        return apply();
    };
    std::string result = dynAs<std::string>(smAwait<AnyGC*>(_box(Promise<std::string>::resolved(transform(std::string("hello"))))));
    (outer = std::string("end"));
    _promise->complete(_box(dart_str(result) + dart_str(std::string("|")) + dart_str(outer)));
    return _promise;
}

Vector2DValue* sumVectors(StaticList<Vector2DValue*>* vectors) {
    return vectors->reduce(GC::allocateLocal(static_cast<TypeFunction2<Vector2DValue*, Vector2DValue*, Vector2DValue*>*>(new ClosureEnv_0())));
}

StaticList<Vector2DValue*>* scaleAll(StaticList<Vector2DValue*>* vectors, double factor) {
    return vectors->map(GC::allocateLocal(static_cast<TypeFunction1<Vector2DValue*, Vector2DValue*>*>(new ClosureEnv_1(factor))));
}

AnyGC* nameAge(std::string name, int64_t age) {
    return _box([&]() -> AnyGC* { auto _r0 = name; auto _r1 = age; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }());
}

AnyGC* personInfo(std::string n, int64_t a, std::string r) {
    return _box(([&]() { std::string _let4 = n; return [&]() -> AnyGC* { auto _r0 = a; auto _r1 = _let4; auto _r2 = r; auto* _t = new std::tuple(_r0, _r1, _r2); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(", "), _r2, std::string(")")))); }(); })());
}

StaticList<AnyGC*>* topN(StaticList<AnyGC*>* data, int64_t n) {
    StaticList<AnyGC*>* sorted = StaticList<AnyGC*>::from(data);
    sorted->sort(GC::allocateLocal(static_cast<TypeFunction2<int64_t, AnyGC*, AnyGC*>*>(new ClosureEnv_2())));
    return /* unsupported collection method: take on List */ sorted->take(n);
}

std::string describeValue(AnyGC* value) {
    _L4:
    do {
        AnyGC* _v6 = value;
        AnyGC* _v7 = nullptr;
        int64_t n{0};
        if ((((dynamic_cast<IntBox*>(_v6) != nullptr) && ([&]() { AnyGC* _let8 = ([&]() { (void)((n = dynAs<int64_t>(_v6))); return nullptr; })(); return true; })()) && (n < 0LL))) {
            return dart_str(std::string("negative int: ")) + dart_str(n);
        }
        int64_t n_5{0};
        if ((((dynamic_cast<IntBox*>(_v6) != nullptr) && ([&]() { AnyGC* _let9 = ([&]() { (void)((n_5 = dynAs<int64_t>(_v6))); return nullptr; })(); return true; })()) && (n_5 == 0LL))) {
            return std::string("zero");
        }
        int64_t n_6{0};
        if (((dynamic_cast<IntBox*>(_v6) != nullptr) && ([&]() { AnyGC* _let10 = ([&]() { (void)((n_6 = dynAs<int64_t>(_v6))); return nullptr; })(); return true; })())) {
            return dart_str(std::string("positive int: ")) + dart_str(n_6);
        }
        std::string s{""};
        if ((((dynamic_cast<StringBox*>(_v6) != nullptr) && ([&]() { AnyGC* _let11 = ([&]() { (void)((s = dynAs<std::string>(_v6))); return nullptr; })(); return true; })()) && s.empty())) {
            return std::string("empty string");
        }
        std::string s_7{""};
        if (((dynamic_cast<StringBox*>(_v6) != nullptr) && ([&]() { AnyGC* _let12 = ([&]() { (void)((s_7 = dynAs<std::string>(_v6))); return nullptr; })(); return true; })())) {
            return dart_str(std::string("string: ")) + dart_str(s_7) + dart_str(std::string(" (len=")) + dart_str(static_cast<int64_t>(s_7.length())) + dart_str(std::string(")"));
        }
        StaticList<AnyGC*>* l{nullptr};
        if (((dynamic_cast<VPtr*>(_v6) != nullptr && static_cast<VPtr*>(_v6)->_typeName == "List") && ([&]() { AnyGC* _let13 = (l = static_cast<StaticList<AnyGC*>*>(_v6)); return true; })())) {
            return dart_str(std::string("list of ")) + dart_str(l->length());
        }
        if ((dart_isNull(_v6))) {
            return std::string("null");
        }
        return dart_str(std::string("unknown: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(static_cast<VPtr*>(value)->getVptrMap()["get_runtimeType"]))(static_cast<VPtr*>(value)));
    } while (false);
}

int main() {
    staticPrint(std::string("--- 1. async void ---"));
    log_->clear();
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    logMessage(std::string("hello"));
    smAwait<AnyGC*>(_box(promiseDelayed(3, []() -> AnyGC* { return nullptr; })));
    staticPrint(dart_str(std::string("  log after logMessage: ")) + dart_str(log_));
    log_->clear();
    safeLog(std::string("test"));
    smAwait<AnyGC*>(_box(promiseDelayed(3, []() -> AnyGC* { return nullptr; })));
    staticPrint(dart_str(std::string("  safeLog result: ")) + dart_str(log_));
    staticPrint(std::string("\n--- 2. continue ---"));
    staticPrint(dart_str(std::string("  collectOdds(10): ")) + dart_str(collectOdds(10LL)));
    staticPrint(dart_str(std::string("  countDigits(10203): ")) + dart_str(countDigits(10203LL)));
    staticPrint(dart_str(std::string("  skipEmpty([\"a\",\"\",\"b\",\"\",\"c\"]): ")) + dart_str(skipEmpty(GC::allocateLocal(new StaticList<std::string>({std::string("a"), std::string(""), std::string("b"), std::string(""), std::string("c")})))));
    staticPrint(dart_str(std::string("  classify(10): ")) + dart_str(classify(10LL)));
    staticPrint(dart_str(std::string("  classify(7): ")) + dart_str(classify(7LL)));
    staticPrint(dart_str(std::string("  classify(13): ")) + dart_str(classify(13LL)));
    staticPrint(dart_str(std::string("  classify(4): ")) + dart_str(classify(4LL)));
    staticPrint(dart_str(std::string("  classify(1): ")) + dart_str(classify(1LL)));
    staticPrint(std::string("\n--- 3. late fields ---"));
    LazyConfigValue* cfg = LazyConfig_new(GC::allocateLocal(new LazyConfigValue()), std::string("app"));
    staticPrint(dart_str(std::string("  name: ")) + dart_str(cfg->name));
    staticPrint(dart_str(std::string("  computed: ")) + dart_str(cfg->computed));
    staticPrint(dart_str(std::string("  counter: ")) + dart_str(cfg->counter));
    LateWithDependencyValue* dep = LateWithDependency_new(GC::allocateLocal(new LateWithDependencyValue()));
    staticPrint(dart_str(std::string("  describe: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(dep->getVptrMap()["describe"]))(dep))));
    staticPrint(std::string("\n--- 4. await non-Future ---"));
    staticPrint(dart_str(std::string("  awaitNonFuture: ")) + dart_str(smAwait<int64_t>(awaitNonFuture())));
    staticPrint(dart_str(std::string("  awaitMixed: ")) + dart_str(smAwait<std::string>(awaitMixed())));
    staticPrint(std::string("\n--- 5. deep async ---"));
    staticPrint(dart_str(std::string("  deepAsync(10): ")) + dart_str(smAwait<int64_t>(deepAsync(10LL))));
    staticPrint(dart_str(std::string("  asyncErrorChain: ")) + dart_str(smAwait<std::string>(asyncErrorChain())));
    staticPrint(dart_str(std::string("  nestedTryAsync: ")) + dart_str(smAwait<std::string>(nestedTryAsync())));
    staticPrint(std::string("\n--- 6. closure + async ---"));
    staticPrint(dart_str(std::string("  asyncWithClosure: ")) + dart_str(smAwait<std::string>(asyncWithClosure())));
    staticPrint(dart_str(std::string("  nestedClosureAsync: ")) + dart_str(smAwait<std::string>(nestedClosureAsync())));
    staticPrint(std::string("\n--- 7. mixin + async ---"));
    ServiceValue* svc = Service_new(GC::allocateLocal(new ServiceValue()));
    std::string r = smAwait<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(svc->getVptrMap()["process"]))(svc, _box(std::string("hello"))));
    staticPrint(dart_str(std::string("  process result: ")) + dart_str(r));
    staticPrint(dart_str(std::string("  messages: ")) + dart_str(svc->messages));
    std::string invalidResult = smAwait<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(svc->getVptrMap()["process"]))(svc, _box(std::string(""))));
    staticPrint(dart_str(std::string("  invalid result: ")) + dart_str(invalidResult));
    staticPrint(std::string("\n--- 8. operators ---"));
    Vector2DValue* v1 = Vector2D_new(GC::allocateLocal(new Vector2DValue()), 1.0, 2.0);
    Vector2DValue* v2 = Vector2D_new(GC::allocateLocal(new Vector2DValue()), 3.0, 4.0);
    staticPrint(dart_str(std::string("  v1 + v2 = ")) + dart_str(reinterpret_cast<Vector2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(v1->getVptrMap()["+"]))(v1, _box(v2)))));
    staticPrint(dart_str(std::string("  v1 - v2 = ")) + dart_str(reinterpret_cast<Vector2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(v1->getVptrMap()["-"]))(v1, _box(v2)))));
    staticPrint(dart_str(std::string("  v1 * 3 = ")) + dart_str(reinterpret_cast<Vector2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(v1->getVptrMap()["*"]))(v1, _box(3.0)))));
    staticPrint(dart_str(std::string("  v1 == Vector2D(1,2): ")) + dart_str(([&]() -> bool { auto& _vm = (v1)->getVptrMap(); auto _it = _vm.find("=="); if (_it != _vm.end()) { return dynAs<bool>(reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(_it->second)(static_cast<AnyGC*>(v1), _box(Vector2D_new(GC::allocateLocal(new Vector2DValue()), 1.0, 2.0)))); } return (v1) == (Vector2D_new(GC::allocateLocal(new Vector2DValue()), 1.0, 2.0)); })()));
    Vector2DValue* sum = sumVectors(GC::allocateLocal(new StaticList<Vector2DValue*>({v1, v2, Vector2D_new(GC::allocateLocal(new Vector2DValue()), 5.0, 6.0)})));
    staticPrint(dart_str(std::string("  sumVectors: ")) + dart_str(sum));
    StaticList<Vector2DValue*>* scaled = scaleAll(GC::allocateLocal(new StaticList<Vector2DValue*>({v1, v2})), 2.0);
    staticPrint(dart_str(std::string("  scaleAll: ")) + dart_str(scaled));
    staticPrint(std::string("\n--- 9. Records ---"));
    AnyGC* na = nameAge(std::string("Alice"), 30LL);
    staticPrint(dart_str(std::string("  nameAge: (")) + dart_str(std::get<0>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(na)->data))) + dart_str(std::string(", ")) + dart_str(std::get<1>(*reinterpret_cast<std::tuple<std::string, int64_t>*>(static_cast<TupleBox*>(na)->data))) + dart_str(std::string(")")));
    AnyGC* pi = personInfo(std::string("Bob"), 25LL, std::string("dev"));
    staticPrint(dart_str(std::string("  personInfo: (")) + dart_str(std::get<1>(*reinterpret_cast<std::tuple<int64_t, std::string, std::string>*>(static_cast<TupleBox*>(pi)->data))) + dart_str(std::string(", ")) + dart_str(std::get<0>(*reinterpret_cast<std::tuple<int64_t, std::string, std::string>*>(static_cast<TupleBox*>(pi)->data))) + dart_str(std::string(", ")) + dart_str(std::get<2>(*reinterpret_cast<std::tuple<int64_t, std::string, std::string>*>(static_cast<TupleBox*>(pi)->data))) + dart_str(std::string(")")));
    StaticList<AnyGC*>* data = GC::allocateLocal(new StaticList<AnyGC*>({[&]() -> AnyGC* { auto _r0 = std::string("Alice"); auto _r1 = 90LL; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }(), [&]() -> AnyGC* { auto _r0 = std::string("Bob"); auto _r1 = 85LL; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }(), [&]() -> AnyGC* { auto _r0 = std::string("Charlie"); auto _r1 = 95LL; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }(), [&]() -> AnyGC* { auto _r0 = std::string("Diana"); auto _r1 = 88LL; auto* _t = new std::tuple(_r0, _r1); return GC::allocateLocal(new TupleBox(_t, dart_str(std::string("("), _r0, std::string(", "), _r1, std::string(")")))); }()}));
    staticPrint(dart_str(std::string("  topN(2): ")) + dart_str(topN(data, 2LL)));
    staticPrint(std::string("\n--- 10. Repository ---"));
    ItemRepoValue* repo = ItemRepo_new(GC::allocateLocal(new ItemRepoValue()));
    smAwait<void>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(repo->getVptrMap()["save"]))(repo, _box(std::string("1")), _box(std::string("item-A"))));
    smAwait<void>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(repo->getVptrMap()["save"]))(repo, _box(std::string("2")), _box(std::string("item-B"))));
    smAwait<void>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(repo->getVptrMap()["save"]))(repo, _box(std::string("3")), _box(std::string("item-C"))));
    staticPrint(dart_str(std::string("  findById(1): ")) + dart_str(smAwait<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(repo->getVptrMap()["findById"]))(repo, _box(std::string("1"))))));
    staticPrint(dart_str(std::string("  findAll: ")) + dart_str(smAwait<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(repo->getVptrMap()["findAll"]))(repo))));
    staticPrint(dart_str(std::string("  isCached(1): ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(repo->getVptrMap()["isCached"]))(repo, _box(std::string("1"))))));
    std::string cached = smAwait<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(repo->getVptrMap()["cachedFindById"]))(repo, _box(std::string("2"))));
    staticPrint(dart_str(std::string("  cachedFindById(2): ")) + dart_str(cached));
    staticPrint(dart_str(std::string("  isCached(2): ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(repo->getVptrMap()["isCached"]))(repo, _box(std::string("2"))))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(repo->getVptrMap()["invalidate"]))(repo, _box(std::string("2")));
    staticPrint(dart_str(std::string("  after invalidate(2), isCached(2): ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(repo->getVptrMap()["isCached"]))(repo, _box(std::string("2"))))));
    staticPrint(std::string("\n--- 11. Factory constructors ---"));
    staticPrint(dart_str(std::string("  dev: ")) + dart_str(Config_new_development()));
    staticPrint(dart_str(std::string("  prod: ")) + dart_str(Config_new_production()));
    staticPrint(dart_str(std::string("  custom: ")) + dart_str(Config_new_custom(std::string("staging"), 9090LL)));
    staticPrint(std::string("\n--- 12. Switch patterns ---"));
    StaticIterator<AnyGC*>* sync_for_iterator = GC::allocateLocal(new StaticList<AnyGC*>({GC::allocateLocal(new IntBox((-5LL))), GC::allocateLocal(new IntBox(0LL)), GC::allocateLocal(new IntBox(42LL)), GC::allocateLocal(new StringBox(std::string(""))), GC::allocateLocal(new StringBox(std::string("hello"))), GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL})), GC::allocateLocal(new BoolBox(true))}))->iterator();
    while (sync_for_iterator->moveNext()) {
        AnyGC* v = sync_for_iterator->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(v) + dart_str(std::string(" => ")) + dart_str(describeValue(v)));
    }
    staticPrint(std::string("\n=== all edge case tests passed ==="));
    return 0;
}

StaticList<std::string>* log_ = GC::allocateLocal(new StaticList<std::string>());

StaticList<std::string>* Service_get_messages(ServiceValue* this__) {
    auto this_ = this__;
    return nullptr;
}

AnyGC* Service_logAsync(ServiceValue* this__, std::string msg) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<void>());
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    this_->messages->add(dart_str(std::string("[async] ")) + dart_str(msg));
    _promise->complete(nullptr);
    return _promise;
}

void Service_logSync(ServiceValue* this__, std::string msg) {
    auto this_ = this__;
    this_->messages->add(dart_str(std::string("[sync] ")) + dart_str(msg));
}

AnyGC* Service_validateAsync(ServiceValue* this__, std::string value) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<bool>());
    smAwait<AnyGC*>(_box(Promise<int64_t>::resolved(0LL)));
    _promise->complete(_box(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["validate"]))(this_, _box(value)))));
    return _promise;
}

AnyGC* ItemRepo_isCached(ItemRepoValue* this__, std::string key) {
    auto this_ = this__;
    return _box(this_->_cache->containsKey(key));
}

void ItemRepo_invalidate(ItemRepoValue* this__, std::string key) {
    auto this_ = this__;
    _box(this_->_cache->remove(key));
    return;
}

AnyGC* ItemRepo_cachedFindById(ItemRepoValue* this__, std::string id) {
    auto this_ = this__;
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    if (dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["isCached"]))(this_, _box(id)))) {
        _promise->complete(_box((*(*this_->_cache)[id])));
        return _promise;
    }
    std::string item = dynAs<std::string>(smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["findById"]))(this_, _box(id)))));
    if (!((item.empty()))) {
        this_->_cache->set(id, item);
    }
    _promise->complete(_box(item));
    return _promise;
}


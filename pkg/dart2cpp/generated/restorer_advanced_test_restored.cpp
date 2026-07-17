#include "dart2cpp_lowered.h"

template<typename T> struct TreeNodeValue;
template<typename T> struct LinkedNodeValue;
template<typename L, typename R> struct EitherValue;
struct SerializableMixin;
struct ValidatableMixin;
template<typename T> struct CopyableMixin;
struct UserProfileValue;
template<typename TInput, typename TOutput> struct DataTransformerValue;
struct StringToIntTransformerValue;
struct IntToStringTransformerValue;
template<typename A, typename B, typename C> struct ChainedTransformerValue;
struct RegistryValue;
struct DataProcessorValue;
struct ExpensiveComputationValue;
struct MathUtilsValue;
struct Printable3Value;
struct ScoreValue;
struct WeightedScoreValue;
struct TextProcessorValue;
struct JsonLikeProcessorValue;
struct Matrix2DValue;
struct EntityValue;
struct AuditableMixin;
struct CacheableMixin;
struct ProductValue;
struct Season;
std::string Season_get_displayName(Season* this__);
Season* Season_get_next(Season* this__);
bool Season_get_isWarm(Season* this__);
StaticMap<std::string, AnyGC*>* Serializable_toMap(SerializableMixin* this__);
std::string Serializable_serialize(SerializableMixin* this__);
StaticList<std::string>* Validatable_validate(ValidatableMixin* this__);
bool Validatable_isValid(ValidatableMixin* this__);
std::string Validatable_validationSummary(ValidatableMixin* this__);
template<typename T> T Copyable_copyWith(CopyableMixin<T>* this__);
void Auditable_audit(AuditableMixin* this__, std::string action);
StaticList<std::string>* Auditable_auditLog(AuditableMixin* this__);
void Cacheable_markDirty(CacheableMixin* this__);
void Cacheable_markCached(CacheableMixin* this__);
bool Cacheable_isDirty(CacheableMixin* this__);
std::string Cacheable_cacheStatus(CacheableMixin* this__);
template<typename T> TreeNodeValue<T>* TreeNode_new(TreeNodeValue<T>* this__, T value, TreeNodeValue<T>* left = nullptr, TreeNodeValue<T>* right = nullptr);
template<typename T> StaticList<T>* TreeNode_preorder(TreeNodeValue<T>* this__);
template<typename T> StaticList<T>* TreeNode_inorder(TreeNodeValue<T>* this__);
template<typename T> int64_t TreeNode_get_depth(TreeNodeValue<T>* this__);
template<typename T, typename R> TreeNodeValue<R>* TreeNode_map(TreeNodeValue<T>* this__, TypeFunction1<R, T>* transform);
template<typename T> std::string TreeNode_toString(TreeNodeValue<T>* this__);
template<typename T> LinkedNodeValue<T>* LinkedNode_new(LinkedNodeValue<T>* this__, T data, LinkedNodeValue<T>* next = nullptr);
template<typename T> LinkedNodeValue<T>* LinkedNode_reversed(LinkedNodeValue<T>* this__);
template<typename T> StaticList<T>* LinkedNode_toList(LinkedNodeValue<T>* this__);
template<typename T> int64_t LinkedNode_get_length(LinkedNodeValue<T>* this__);
template<typename T> std::string LinkedNode_toString(LinkedNodeValue<T>* this__);
template<typename L, typename R> EitherValue<L, R>* Either_new_left(EitherValue<L, R>* this__, L value);
template<typename L, typename R> EitherValue<L, R>* Either_new_right(EitherValue<L, R>* this__, R value);
template<typename L, typename R> bool Either_get_isLeft(EitherValue<L, R>* this__);
template<typename L, typename R> bool Either_get_isRight(EitherValue<L, R>* this__);
template<typename L, typename R> L Either_get_leftValue(EitherValue<L, R>* this__);
template<typename L, typename R> R Either_get_rightValue(EitherValue<L, R>* this__);
template<typename L, typename R, typename T> T Either_fold(EitherValue<L, R>* this__, TypeFunction1<T, L>* onLeft, TypeFunction1<T, R>* onRight);
template<typename L, typename R, typename R2> EitherValue<L, R2>* Either_mapRight(EitherValue<L, R>* this__, TypeFunction1<R2, R>* transform);
template<typename L, typename R, typename R2> EitherValue<L, R2>* Either_flatMap(EitherValue<L, R>* this__, TypeFunction1<EitherValue<L, R2>*, R>* transform);
template<typename L, typename R> std::string Either_toString(EitherValue<L, R>* this__);
UserProfileValue* UserProfile_new(UserProfileValue* this__, std::string name, std::string email, int64_t age);
StaticMap<std::string, AnyGC*>* UserProfile_toMap(UserProfileValue* this__);
StaticList<std::string>* UserProfile_validate(UserProfileValue* this__);
std::string UserProfile_toString(UserProfileValue* this__);
template<typename TInput, typename TOutput> DataTransformerValue<TInput, TOutput>* DataTransformer_new(DataTransformerValue<TInput, TOutput>* this__);
template<typename TInput, typename TOutput> TOutput DataTransformer_transform(DataTransformerValue<TInput, TOutput>* this__, TInput input);
template<typename TInput, typename TOutput> TInput DataTransformer_preValidate(DataTransformerValue<TInput, TOutput>* this__, TInput input);
template<typename TInput, typename TOutput> TOutput DataTransformer_process(DataTransformerValue<TInput, TOutput>* this__, TInput input);
template<typename TInput, typename TOutput> TOutput DataTransformer_postProcess(DataTransformerValue<TInput, TOutput>* this__, TOutput output);
StringToIntTransformerValue* StringToIntTransformer_new(StringToIntTransformerValue* this__);
std::string StringToIntTransformer_preValidate(StringToIntTransformerValue* this__, std::string input);
int64_t StringToIntTransformer_process(StringToIntTransformerValue* this__, std::string input);
IntToStringTransformerValue* IntToStringTransformer_new(IntToStringTransformerValue* this__, std::string prefix = std::string(""));
std::string IntToStringTransformer_process(IntToStringTransformerValue* this__, int64_t input);
std::string IntToStringTransformer_postProcess(IntToStringTransformerValue* this__, std::string output);
template<typename A, typename B, typename C> ChainedTransformerValue<A, B, C>* ChainedTransformer_new(ChainedTransformerValue<A, B, C>* this__, DataTransformerValue<A, B>* first, DataTransformerValue<B, C>* second);
template<typename A, typename B, typename C> C ChainedTransformer_process(ChainedTransformerValue<A, B, C>* this__, A input);
RegistryValue* Registry_new__internal(RegistryValue* this__);
RegistryValue* Registry_new();
void Registry_register_(RegistryValue* this__, std::string key, AnyGC* value);
AnyGC* Registry_lookup(RegistryValue* this__, std::string key);
bool Registry_contains(RegistryValue* this__, std::string key);
int64_t Registry_get_size(RegistryValue* this__);
int64_t Registry_get_accessCount(RegistryValue* this__);
StaticList<std::string>* Registry_get_keys(RegistryValue* this__);
void Registry_clear(RegistryValue* this__);
std::string Registry_toString(RegistryValue* this__);
DataProcessorValue* DataProcessor_new(DataProcessorValue* this__);
StaticList<StaticMap<std::string, AnyGC*>*>* DataProcessor_processRecords(StaticList<StaticMap<std::string, AnyGC*>*>* records);
std::string DataProcessor__scoreToGrade(int64_t score);
StaticMap<std::string, StaticList<StaticMap<std::string, AnyGC*>*>*>* DataProcessor_groupByGrade(StaticList<StaticMap<std::string, AnyGC*>*>* records);
StaticMap<std::string, double>* DataProcessor_averageByGrade(StaticList<StaticMap<std::string, AnyGC*>*>* records);
ExpensiveComputationValue* ExpensiveComputation_new(ExpensiveComputationValue* this__, int64_t seed);
int64_t ExpensiveComputation__computeExpensive(ExpensiveComputationValue* this__);
void ExpensiveComputation_initialize(ExpensiveComputationValue* this__, std::string desc);
std::string ExpensiveComputation_toString(ExpensiveComputationValue* this__);
MathUtilsValue* MathUtils_new(MathUtilsValue* this__);
int64_t MathUtils_fibonacci(int64_t n);
StaticList<int64_t>* MathUtils_primeFactors(int64_t n);
int64_t MathUtils_gcd(int64_t a, int64_t b);
int64_t MathUtils_lcm(int64_t a, int64_t b);
Printable3Value* Printable3_new(Printable3Value* this__);
std::string Printable3_prettyPrint(Printable3Value* this__);
ScoreValue* Score_new(ScoreValue* this__, std::string subject, int64_t points);
int64_t Score_compareTo2(ScoreValue* this__, ScoreValue* other);
bool Score_isLessThan(ScoreValue* this__, ScoreValue* other);
bool Score_isGreaterThan(ScoreValue* this__, ScoreValue* other);
std::string Score_prettyPrint(ScoreValue* this__);
std::string Score_toString(ScoreValue* this__);
WeightedScoreValue* WeightedScore_new(WeightedScoreValue* this__, std::string subject, int64_t points, double weight);
double WeightedScore_get_weightedPoints(WeightedScoreValue* this__);
int64_t WeightedScore_compareTo2(WeightedScoreValue* this__, ScoreValue* other);
std::string WeightedScore_prettyPrint(WeightedScoreValue* this__);
std::string WeightedScore_toString(WeightedScoreValue* this__);
TextProcessorValue* TextProcessor_new(TextProcessorValue* this__);
std::string TextProcessor_camelToSnake(std::string input);
std::string TextProcessor_snakeToCamel(std::string input);
StaticMap<std::string, int64_t>* TextProcessor_wordFrequency(std::string text);
std::string TextProcessor_truncate(std::string text, int64_t maxLength, std::string suffix);
JsonLikeProcessorValue* JsonLikeProcessor_new(JsonLikeProcessorValue* this__);
AnyGC* JsonLikeProcessor_deepMerge(StaticMap<std::string, AnyGC*>* base, StaticMap<std::string, AnyGC*>* overlay);
StaticList<std::string>* JsonLikeProcessor_flattenKeys(StaticMap<std::string, AnyGC*>* map, std::string prefix);
Matrix2DValue* Matrix2D_new(Matrix2DValue* this__, StaticList<StaticList<double>*>* _data);
Matrix2DValue* Matrix2D_new_zeros(Matrix2DValue* this__, int64_t rows, int64_t cols);
Matrix2DValue* Matrix2D_new_identity(Matrix2DValue* this__, int64_t size);
double Matrix2D_get(Matrix2DValue* this__, int64_t row, int64_t col);
Matrix2DValue* Matrix2D_add(Matrix2DValue* this__, Matrix2DValue* other);
Matrix2DValue* Matrix2D_mul(Matrix2DValue* this__, Matrix2DValue* other);
double Matrix2D_get_trace(Matrix2DValue* this__);
std::string Matrix2D_toString(Matrix2DValue* this__);
EntityValue* Entity_new(EntityValue* this__);
std::string Entity_get_entityId(EntityValue* this__);
ProductValue* Product_new(ProductValue* this__, std::string entityId, std::string name, double price);
std::string Product_toString(ProductValue* this__);
TypeFunction* makeCounter(int64_t start, int64_t step);
TypeFunction* makeAccumulator(int64_t initial);
StaticList<TypeFunction*>* makeClosureList(int64_t count);
template<typename A, typename B, typename C> TypeFunction1<C, A>* composeFunc(TypeFunction1<C, B>* funcBC, TypeFunction1<B, A>* funcAB);
template<typename A, typename B, typename C> TypeFunction1<TypeFunction1<C, B>*, A>* curry(TypeFunction2<C, A, B>* biFunc);
template<typename T> T pipe(T value, StaticList<TypeFunction1<T, T>*>* transforms);
template<typename A, typename B> TypeFunction1<B, A>* memoize(TypeFunction1<B, A>* func);
std::string classifyNumber(int64_t number);
StaticList<int64_t>* parseNumbers(StaticList<std::string>* inputs);
Promise<int64_t>* asyncAdd(int64_t a, int64_t b);
Promise<std::string>* asyncTransform(int64_t value);
Promise<StaticList<int64_t>*>* asyncSequence(int64_t count);
bool IntMathExtension_get_isPrime(int64_t this_);
int64_t IntMathExtension_get_factorial(int64_t this_);
StaticList<int64_t>* IntMathExtension_get_digits(int64_t this_);
template<typename T> T IterableStats_get_sum(StaticList<T>* this_);
template<typename T> double IterableStats_get_average(StaticList<T>* this_);
template<typename T> T IterableStats_get_max(StaticList<T>* this_);
template<typename T> T IterableStats_get_min(StaticList<T>* this_);
int main();
AnyGC* UserProfile_Object_Serializable_serialize(UserProfileValue* this__);
AnyGC* UserProfile_Object_Serializable_Validatable_get_isValid(UserProfileValue* this__);
AnyGC* UserProfile_Object_Serializable_Validatable_get_validationSummary(UserProfileValue* this__);
void Product_Entity_Auditable_audit(ProductValue* this__, std::string action);
AnyGC* Product_Entity_Auditable_get_auditLog(ProductValue* this__);
void Product_Entity_Auditable_Cacheable_markDirty(ProductValue* this__);
void Product_Entity_Auditable_Cacheable_markCached(ProductValue* this__);
AnyGC* Product_Entity_Auditable_Cacheable_get_isDirty(ProductValue* this__);
AnyGC* Product_Entity_Auditable_Cacheable_get_cacheStatus(ProductValue* this__);
TypeFunction* makeCounter(int64_t start = 0, int64_t step = 1);
AnyGC* UserProfile_serialize(UserProfileValue* this__);
AnyGC* UserProfile_get_isValid(UserProfileValue* this__);
AnyGC* UserProfile_get_validationSummary(UserProfileValue* this__);
AnyGC* StringToIntTransformer_transform(StringToIntTransformerValue* this__, std::string input);
AnyGC* StringToIntTransformer_postProcess(StringToIntTransformerValue* this__, int64_t output);
AnyGC* IntToStringTransformer_transform(IntToStringTransformerValue* this__, int64_t input);
AnyGC* IntToStringTransformer_preValidate(IntToStringTransformerValue* this__, int64_t input);
template<typename A, typename B, typename C> AnyGC* ChainedTransformer_transform(ChainedTransformerValue<A, B, C>* this__, A input);
template<typename A, typename B, typename C> AnyGC* ChainedTransformer_preValidate(ChainedTransformerValue<A, B, C>* this__, A input);
template<typename A, typename B, typename C> AnyGC* ChainedTransformer_postProcess(ChainedTransformerValue<A, B, C>* this__, C output);
AnyGC* WeightedScore_isLessThan(WeightedScoreValue* this__, ScoreValue* other);
AnyGC* WeightedScore_isGreaterThan(WeightedScoreValue* this__, ScoreValue* other);
std::string Product_get_entityId(ProductValue* this__);
void Product_audit(ProductValue* this__, std::string action);
AnyGC* Product_get_auditLog(ProductValue* this__);
void Product_markDirty(ProductValue* this__);
void Product_markCached(ProductValue* this__);
AnyGC* Product_get_isDirty(ProductValue* this__);
AnyGC* Product_get_cacheStatus(ProductValue* this__);

struct Season : VPtr {
    std::string _name;
    int64_t _index;

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    static Season* spring;
    static Season* summer;
    static Season* autumn;
    static Season* winter;
    static Season* values;

    Season(std::string n, int64_t i) : _name(std::move(n)), _index(i) {}

    std::string toString() const override {
        auto& _vm = const_cast<Season*>(this)->getVptrMap();
        auto _it = _vm.find("toString");
        if (_it != _vm.end()) {
            return dynAs<std::string>(reinterpret_cast<AnyGC*(*)(AnyGC*)>(_it->second)(const_cast<Season*>(this)));
        }
        return "Season." + _name;
    }
};

std::unordered_map<std::string, void*> Season::_vptrMap;

Season* Season::spring = new Season("spring", 0);
Season* Season::summer = new Season("summer", 1);
Season* Season::autumn = new Season("autumn", 2);
Season* Season::winter = new Season("winter", 3);
Season* Season::values = new Season("values", 4);

struct SerializableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> SerializableMixin::_vptrMap;

struct ClosureEnv_0 : TypeFunction1<std::string, StaticMapEntry<std::string, AnyGC*>> {
    ClosureEnv_0() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(*reinterpret_cast<StaticMapEntry<std::string, AnyGC*>*>(dynamic_cast<VPtr*>(_p0))));
    }
    std::string call(StaticMapEntry<std::string, AnyGC*> e) {
    return dart_str(e.key) + dart_str(std::string("=")) + dart_str(e.value);
    }
};


struct ValidatableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
std::unordered_map<std::string, void*> ValidatableMixin::_vptrMap;


template<typename T>
struct CopyableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
};
template<typename T> std::unordered_map<std::string, void*> CopyableMixin<T>::_vptrMap;


struct AuditableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
    StaticList<std::string>* _auditLog{nullptr};
};
std::unordered_map<std::string, void*> AuditableMixin::_vptrMap;


struct CacheableMixin : AnyGC {
    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }
    StaticDateTime _cachedAt{};
    bool _isDirty{false};
};
std::unordered_map<std::string, void*> CacheableMixin::_vptrMap;


template<typename T>
struct TreeNodeValue : VPtr {
    T value{};
    TreeNodeValue<T>* left{nullptr};
    TreeNodeValue<T>* right{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (left) left->gcMark(flag);
        if (right) right->gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> TreeNodeValue<T>::_vptrMap;

template<typename T>
struct LinkedNodeValue : VPtr {
    T data{};
    LinkedNodeValue<T>* next{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (next) next->gcMark(flag);
    }
};

template<typename T> std::unordered_map<std::string, void*> LinkedNodeValue<T>::_vptrMap;

template<typename L, typename R>
struct EitherValue : VPtr {
    L _left{};
    R _right{};
    bool _isRight{false};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename L, typename R> std::unordered_map<std::string, void*> EitherValue<L, R>::_vptrMap;

struct UserProfileValue : VPtr {
    std::string name{""};
    std::string email{""};
    int64_t age{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> UserProfileValue::_vptrMap;

template<typename TInput, typename TOutput>
struct DataTransformerValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

template<typename TInput, typename TOutput> std::unordered_map<std::string, void*> DataTransformerValue<TInput, TOutput>::_vptrMap;

struct StringToIntTransformerValue : DataTransformerValue<std::string, int64_t> {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        DataTransformerValue<std::string, int64_t>::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> StringToIntTransformerValue::_vptrMap;

struct IntToStringTransformerValue : DataTransformerValue<int64_t, std::string> {
    std::string prefix{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        DataTransformerValue<int64_t, std::string>::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> IntToStringTransformerValue::_vptrMap;

template<typename A, typename B, typename C>
struct ChainedTransformerValue : DataTransformerValue<A, C> {
    DataTransformerValue<A, B>* first{nullptr};
    DataTransformerValue<B, C>* second{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        DataTransformerValue<A, C>::gcMark(flag);
        if (first) first->gcMark(flag);
        if (second) second->gcMark(flag);
    }
};

template<typename A, typename B, typename C> std::unordered_map<std::string, void*> ChainedTransformerValue<A, B, C>::_vptrMap;

struct RegistryValue : VPtr {
    StaticMap<std::string, AnyGC*>* _store{nullptr};
    int64_t _accessCount{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_store) _store->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> RegistryValue::_vptrMap;

struct DataProcessorValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> DataProcessorValue::_vptrMap;

struct ClosureEnv_1 : TypeFunction1<bool, StaticMap<std::string, AnyGC*>*> {
    ClosureEnv_1() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<StaticMap<std::string, AnyGC*>*>(_p0)));
    }
    bool call(StaticMap<std::string, AnyGC*>* r) {
    return (r->containsKey(std::string("name")) && r->containsKey(std::string("score")));
    }
};

struct ClosureEnv_2 : TypeFunction1<bool, StaticMap<std::string, AnyGC*>*> {
    ClosureEnv_2() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<StaticMap<std::string, AnyGC*>*>(_p0)));
    }
    bool call(StaticMap<std::string, AnyGC*>* r) {
    return (dynAs<int64_t>(_box(*(*r)[std::string("score")])) >= 0LL);
    }
};

struct ClosureEnv_3 : TypeFunction1<StaticMap<std::string, AnyGC*>*, StaticMap<std::string, AnyGC*>*> {
    ClosureEnv_3() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_3*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<StaticMap<std::string, AnyGC*>*>(_p0)));
    }
    StaticMap<std::string, AnyGC*>* call(StaticMap<std::string, AnyGC*>* r) {
    return ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(dart_str_toUpper(dynAs<std::string>(_box(*(*r)[std::string("name")])))))); _m->set(std::string("score"), GC::allocateLocal(new IntBox(dynAs<int64_t>(_box(*(*r)[std::string("score")]))))); _m->set(std::string("grade"), GC::allocateLocal(new StringBox(DataProcessor__scoreToGrade(dynAs<int64_t>(_box(*(*r)[std::string("score")])))))); _m->set(std::string("passed"), GC::allocateLocal(new BoolBox((dynAs<int64_t>(_box(*(*r)[std::string("score")])) >= 60LL)))); return _m; })();
    }
};

struct ClosureEnv_4 : TypeFunction2<int64_t, StaticMap<std::string, AnyGC*>*, StaticMap<std::string, AnyGC*>*> {
    ClosureEnv_4() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_4*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<StaticMap<std::string, AnyGC*>*>(_p0), static_cast<StaticMap<std::string, AnyGC*>*>(_p1)));
    }
    int64_t call(StaticMap<std::string, AnyGC*>* a, StaticMap<std::string, AnyGC*>* b) {
    return ((dynAs<int64_t>(_box(*(*b)[std::string("score")]))) > static_cast<int64_t>(dynAs<int64_t>(_box(*(*a)[std::string("score")]))) ? 1LL : ((dynAs<int64_t>(_box(*(*b)[std::string("score")]))) < static_cast<int64_t>(dynAs<int64_t>(_box(*(*a)[std::string("score")]))) ? -1LL : 0LL));
    }
};

struct ClosureEnv_5 : TypeFunction0<StaticList<StaticMap<std::string, AnyGC*>*>*> {
    ClosureEnv_5() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_5*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    StaticList<StaticMap<std::string, AnyGC*>*>* call() {
        return GC::allocateLocal(new StaticList<StaticMap<std::string, AnyGC*>*>());
    }
};

struct ClosureEnv_7 : TypeFunction2<int64_t, int64_t, StaticMap<std::string, AnyGC*>*> {
    ClosureEnv_7() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_7*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0), static_cast<StaticMap<std::string, AnyGC*>*>(_p1)));
    }
    int64_t call(int64_t sum, StaticMap<std::string, AnyGC*>* r) {
    return (sum + dynAs<int64_t>(_box(*(*r)[std::string("score")])));
    }
};

struct ClosureEnv_6 : TypeFunction2<StaticMapEntry<std::string, double>, std::string, StaticList<StaticMap<std::string, AnyGC*>*>*> {
    ClosureEnv_6() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_6*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0), static_cast<StaticList<StaticMap<std::string, AnyGC*>*>*>(_p1)));
    }
    StaticMapEntry<std::string, double> call(std::string grade, StaticList<StaticMap<std::string, AnyGC*>*>* items) {
    int64_t total = items->fold(0LL, GC::allocateLocal(static_cast<TypeFunction2<int64_t, int64_t, StaticMap<std::string, AnyGC*>*>*>(new ClosureEnv_7())));
    return StaticMapEntry<std::string, double>(grade, (static_cast<double>(total) / static_cast<double>(items->length())));
    }
};

struct ExpensiveComputationValue : VPtr {
    int64_t seed{0};
    int64_t computedValue{0};
    std::string description{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ExpensiveComputationValue::_vptrMap;

struct MathUtilsValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> MathUtilsValue::_vptrMap;

struct Printable3Value : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> Printable3Value::_vptrMap;

struct ScoreValue : Printable3Value {
    std::string subject{""};
    int64_t points{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        Printable3Value::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ScoreValue::_vptrMap;

struct WeightedScoreValue : ScoreValue {
    double weight{0.0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        ScoreValue::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> WeightedScoreValue::_vptrMap;

struct TextProcessorValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> TextProcessorValue::_vptrMap;

struct ClosureEnv_8 : TypeFunction1<std::string, std::string> {
    ClosureEnv_8() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_8*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    std::string call(std::string p) {
    return (p.empty() ? std::string("") : dart_str(dart_str_toUpper(std::string(1, p[0LL]))) + dart_str(p.substr(1LL)));
    }
};

struct ClosureEnv_9 : TypeFunction1<bool, std::string> {
    ClosureEnv_9() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_9*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    bool call(std::string w) {
    return !w.empty();
    }
};

struct JsonLikeProcessorValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> JsonLikeProcessorValue::_vptrMap;

struct Matrix2DValue : VPtr {
    StaticList<StaticList<double>*>* _data{nullptr};
    int64_t rows{0};
    int64_t cols{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_data) _data->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> Matrix2DValue::_vptrMap;

struct ClosureEnv_10 : TypeFunction1<StaticList<double>*, int64_t> {
    int64_t cols;
    ClosureEnv_10(int64_t cols) : cols(std::move(cols)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_10*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    StaticList<double>* call(int64_t _) {
    return ([&]() { auto* _list = GC::allocateLocal(new StaticList<double>()); for (int64_t _i = 0; _i < cols; _i++) _list->add(0.0); return _list; })();
    }
};

struct ClosureEnv_12 : TypeFunction1<double, int64_t> {
    int64_t i;
    ClosureEnv_12(int64_t i) : i(std::move(i)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_12*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    double call(int64_t j) {
    return ((i == j) ? 1.0 : 0.0);
    }
};

struct ClosureEnv_11 : TypeFunction1<StaticList<double>*, int64_t> {
    int64_t size;
    ClosureEnv_11(int64_t size) : size(std::move(size)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_11*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    StaticList<double>* call(int64_t i) {
    return ([&]() { auto* _list = GC::allocateLocal(new StaticList<double>()); auto* _gen = GC::allocateLocal(static_cast<TypeFunction1<double, int64_t>*>(new ClosureEnv_12(i))); for (int64_t _i = 0; _i < size; _i++) _list->add(_gen->call(_i)); return _list; })();
    }
};

struct ClosureEnv_14 : TypeFunction1<std::string, double> {
    ClosureEnv_14() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_14*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<double>(_p0)));
    }
    std::string call(double v) {
    return ([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(1LL) << v; return _ss.str(); })();
    }
};

struct ClosureEnv_13 : TypeFunction1<std::string, StaticList<double>*> {
    ClosureEnv_13() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_13*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<StaticList<double>*>(_p0)));
    }
    std::string call(StaticList<double>* row) {
    return row->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, double>*>(new ClosureEnv_14())))->join(std::string(", "));
    }
};

struct ClosureEnv_15 : TypeFunction1<std::string, std::string> {
    ClosureEnv_15() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_15*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<std::string>(_p0)));
    }
    std::string call(std::string r) {
    return dart_str(std::string("[")) + dart_str(r) + dart_str(std::string("]"));
    }
};

struct EntityValue : VPtr {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> EntityValue::_vptrMap;

struct ProductValue : EntityValue {
    std::string entityId{""};
    std::string name{""};
    double price{0.0};
    StaticDateTime _cachedAt{};
    bool _isDirty{false};
    StaticList<std::string>* _auditLog{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        EntityValue::gcMark(flag);
        if (_auditLog) _auditLog->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ProductValue::_vptrMap;

struct ClosureEnv_16 : TypeFunction0<int64_t> {
    IntBox* current;
    int64_t step;
    ClosureEnv_16(IntBox* current, int64_t step) : current(current), step(std::move(step)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_16*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
    (current->value = (current->value + step));
    return current->value;
    }
};

struct ClosureEnv_18 : TypeFunction0<std::string> {
    IntBox* snapshot;
    IntBox* total;
    ClosureEnv_18(IntBox* snapshot, IntBox* total) : snapshot(snapshot), total(total) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_18*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
    return dart_str(std::string("accumulated: ")) + dart_str(snapshot->value) + dart_str(std::string(" (current total: ")) + dart_str(total->value) + dart_str(std::string(")"));
    }
};

struct ClosureEnv_17 : TypeFunction1<TypeFunction0<std::string>*, int64_t> {
    IntBox* total;
    ClosureEnv_17(IntBox* total) : total(total) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_17*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    TypeFunction0<std::string>* call(int64_t amount) {
    (total->value = (total->value + amount));
    IntBox* snapshot = new IntBox(total->value);
    return GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_18(snapshot, total)));
    }
};

struct ClosureEnv_19 : TypeFunction0<std::string> {
    int64_t i;
    ClosureEnv_19(int64_t i) : i(std::move(i)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_19*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
        return dart_str(std::string("closure_")) + dart_str(i);
    }
};

template<typename C, typename B, typename A>
struct ClosureEnv_20 : TypeFunction1<C, A> {
    TypeFunction1<C, B>* funcBC;
    TypeFunction1<B, A>* funcAB;
    ClosureEnv_20(TypeFunction1<C, B>* funcBC, TypeFunction1<B, A>* funcAB) : funcBC(std::move(funcBC)), funcAB(std::move(funcAB)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_20*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<A>(_p0)));
    }
    C call(A a) {
    return funcBC->call(funcAB->call(a));
    }
};

template<typename C, typename A, typename B>
struct ClosureEnv_22 : TypeFunction1<C, B> {
    TypeFunction2<C, A, B>* biFunc;
    A a;
    ClosureEnv_22(TypeFunction2<C, A, B>* biFunc, A a) : biFunc(std::move(biFunc)), a(std::move(a)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_22*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<B>(_p0)));
    }
    C call(B b) {
    return biFunc->call(a, b);
    }
};

template<typename C, typename A, typename B>
struct ClosureEnv_21 : TypeFunction1<TypeFunction1<C, B>*, A> {
    TypeFunction2<C, A, B>* biFunc;
    ClosureEnv_21(TypeFunction2<C, A, B>* biFunc) : biFunc(std::move(biFunc)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_21*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<A>(_p0)));
    }
    TypeFunction1<C, B>* call(A a) {
    return GC::allocateLocal(static_cast<TypeFunction1<C, B>*>(new ClosureEnv_22<C, A, B>(biFunc, a)));
    }
};

template<typename A, typename B>
struct ClosureEnv_23 : TypeFunction1<B, A> {
    StaticMap<A, B>* cache;
    TypeFunction1<B, A>* func;
    ClosureEnv_23(StaticMap<A, B>* cache, TypeFunction1<B, A>* func) : cache(std::move(cache)), func(std::move(func)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_23*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<A>(_p0)));
    }
    B call(A arg) {
    if (cache->containsKey(arg)) {
        return ([&]() { B _let25 = (*(*cache)[arg]); return ((dart_isNull(_let25)) ? _let25 : _let25); })();
    }
    B result = func->call(arg);
    cache->set(arg, result);
    return result;
    }
};

template<typename T>
struct ClosureEnv_24 : TypeFunction2<T, T, T> {
    ClosureEnv_24() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_24*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<T>(_p0), dynAs<T>(_p1)));
    }
    T call(T a, T b) {
    return static_cast<T>((a + b));
    }
};

template<typename T>
struct ClosureEnv_25 : TypeFunction2<T, T, T> {
    ClosureEnv_25() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_25*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<T>(_p0), dynAs<T>(_p1)));
    }
    T call(T a, T b) {
    return ((a > b) ? a : b);
    }
};

template<typename T>
struct ClosureEnv_26 : TypeFunction2<T, T, T> {
    ClosureEnv_26() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_26*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<T>(_p0), dynAs<T>(_p1)));
    }
    T call(T a, T b) {
    return ((a < b) ? a : b);
    }
};

struct ClosureEnv_27 : TypeFunction1<std::string, int64_t> {
    ClosureEnv_27() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_27*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    std::string call(int64_t v) {
    return dart_str(std::string("N")) + dart_str(v);
    }
};

struct ClosureEnv_28 : TypeFunction1<std::string, StaticMapEntry<std::string, AnyGC*>> {
    ClosureEnv_28() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_28*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(*reinterpret_cast<StaticMapEntry<std::string, AnyGC*>*>(dynamic_cast<VPtr*>(_p0))));
    }
    std::string call(StaticMapEntry<std::string, AnyGC*> e) {
    return dart_str(e.key) + dart_str(std::string("=")) + dart_str(e.value);
    }
};


std::string Season_get_displayName(Season* this__) {
    auto this_ = this__;
    _L0:
    do {
        switch (this_->_index) {
            _sw_case_0:
            case 0:
            {
                return std::string("Spring");
                break;
            }
            _sw_case_1:
            case 1:
            {
                return std::string("Summer");
                break;
            }
            _sw_case_2:
            case 2:
            {
                return std::string("Autumn");
                break;
            }
            _sw_case_3:
            case 3:
            {
                return std::string("Winter");
                break;
            }
        }
    } while (false);
}

AnyGC* _vptr_wrap_Season_get_displayName(AnyGC* obj__) {
    return _box(Season_get_displayName(static_cast<Season*>(obj__)));
}

static bool _Season_displayName_registered = []{ Season::_vptrMap["get_displayName"] = reinterpret_cast<void*>(&_vptr_wrap_Season_get_displayName); return true; }();
Season* Season_get_next(Season* this__) {
    auto this_ = this__;
    _L1:
    do {
        switch (this_->_index) {
            _sw_case_0:
            case 0:
            {
                return Season::summer;
                break;
            }
            _sw_case_1:
            case 1:
            {
                return Season::autumn;
                break;
            }
            _sw_case_2:
            case 2:
            {
                return Season::winter;
                break;
            }
            _sw_case_3:
            case 3:
            {
                return Season::spring;
                break;
            }
        }
    } while (false);
}

AnyGC* _vptr_wrap_Season_get_next(AnyGC* obj__) {
    return _box(Season_get_next(static_cast<Season*>(obj__)));
}

static bool _Season_next_registered = []{ Season::_vptrMap["get_next"] = reinterpret_cast<void*>(&_vptr_wrap_Season_get_next); return true; }();
bool Season_get_isWarm(Season* this__) {
    auto this_ = this__;
    return ((this_ == Season::spring) || (this_ == Season::summer));
}

AnyGC* _vptr_wrap_Season_get_isWarm(AnyGC* obj__) {
    return _box(Season_get_isWarm(static_cast<Season*>(obj__)));
}

static bool _Season_isWarm_registered = []{ Season::_vptrMap["get_isWarm"] = reinterpret_cast<void*>(&_vptr_wrap_Season_get_isWarm); return true; }();
StaticMap<std::string, AnyGC*>* Serializable_toMap(SerializableMixin* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Serializable.toMap")));
}

std::string Serializable_serialize(SerializableMixin* this__) {
    auto this_ = this__;
    StaticMap<std::string, AnyGC*>* map = static_cast<StaticMap<std::string, AnyGC*>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["toMap"]))(this_));
    std::string entries = map->entries()->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, StaticMapEntry<std::string, AnyGC*>>*>(new ClosureEnv_0())))->join(std::string(", "));
    return dart_str(std::string("{")) + dart_str(entries) + dart_str(std::string("}"));
}

StaticList<std::string>* Validatable_validate(ValidatableMixin* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Validatable.validate")));
}

bool Validatable_isValid(ValidatableMixin* this__) {
    auto this_ = this__;
    return static_cast<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["validate"]))(this_))->isEmpty();
}

std::string Validatable_validationSummary(ValidatableMixin* this__) {
    auto this_ = this__;
    StaticList<std::string>* errors = static_cast<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["validate"]))(this_));
    if (errors->isEmpty()) {
        return std::string("valid");
    }
    return dart_str(std::string("invalid: ")) + dart_str(errors->join(std::string("; ")));
}

template<typename T>
T Copyable_copyWith(CopyableMixin<T>* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Copyable.copyWith")));
}

void Auditable_audit(AuditableMixin* this__, std::string action) {
    auto this_ = this__;
    this_->_auditLog->add(dart_str(std::string("[")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_entityId"]))(this_))) + dart_str(std::string("] ")) + dart_str(action));
}

StaticList<std::string>* Auditable_auditLog(AuditableMixin* this__) {
    auto this_ = this__;
    return unmodifiable<std::string>(this_->_auditLog);
}

void Cacheable_markDirty(CacheableMixin* this__) {
    auto this_ = this__;
    (this_->_isDirty = true);
    return;
}

void Cacheable_markCached(CacheableMixin* this__) {
    auto this_ = this__;
    (this_->_isDirty = false);
    (this_->_cachedAt = StaticDateTime::now());
}

bool Cacheable_isDirty(CacheableMixin* this__) {
    auto this_ = this__;
    return this_->_isDirty;
}

std::string Cacheable_cacheStatus(CacheableMixin* this__) {
    auto this_ = this__;
    return (this_->_isDirty ? std::string("dirty") : std::string("cached"));
}

template<typename T>
AnyGC* _vptr_wrap_TreeNode_preorder(AnyGC* obj__) {
    return _box(TreeNode_preorder<T>(static_cast<TreeNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_TreeNode_inorder(AnyGC* obj__) {
    return _box(TreeNode_inorder<T>(static_cast<TreeNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_TreeNode_get_depth(AnyGC* obj__) {
    return _box(TreeNode_get_depth<T>(static_cast<TreeNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_TreeNode_map(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<T> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(TreeNode_map<T, AnyGC*>(static_cast<TreeNodeValue<T>*>(obj__), &_adapter0));
}

template<typename T>
AnyGC* _vptr_wrap_TreeNode_toString(AnyGC* obj__) {
    return _box(TreeNode_toString<T>(static_cast<TreeNodeValue<T>*>(obj__)));
}

template<typename T> void _register_TreeNode_vptr() {
    if (TreeNodeValue<T>::_vptrMap.empty()) {
        TreeNodeValue<T>::_vptrMap["preorder"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_preorder<T>);
        TreeNodeValue<T>::_vptrMap["inorder"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_inorder<T>);
        TreeNodeValue<T>::_vptrMap["get_depth"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_get_depth<T>);
        TreeNodeValue<T>::_vptrMap["map"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_map<T>);
        TreeNodeValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_toString<T>);
    }
}
template<typename T>
TreeNodeValue<T>* TreeNode_new(TreeNodeValue<T>* this__, T value, TreeNodeValue<T>* left, TreeNodeValue<T>* right) {
    auto this_ = this__;
    if (TreeNodeValue<T>::_vptrMap.empty()) {
        TreeNodeValue<T>::_vptrMap["preorder"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_preorder<T>);
        TreeNodeValue<T>::_vptrMap["inorder"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_inorder<T>);
        TreeNodeValue<T>::_vptrMap["get_depth"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_get_depth<T>);
        TreeNodeValue<T>::_vptrMap["map"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_map<T>);
        TreeNodeValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_TreeNode_toString<T>);
    }
    this_->value = value;
    this_->left = left;
    this_->right = right;
    return this_;
}

template<typename T>
StaticList<T>* TreeNode_preorder(TreeNodeValue<T>* this__) {
    auto this_ = this__;
    StaticList<T>* result = GC::allocateLocal(new StaticList<T>({this_->value}));
    if (!((dart_isNull(this_->left)))) {
        result->addAll(static_cast<StaticList<T>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->left->getVptrMap()["preorder"]))(this_->left)));
    }
    if (!((dart_isNull(this_->right)))) {
        result->addAll(static_cast<StaticList<T>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->right->getVptrMap()["preorder"]))(this_->right)));
    }
    return result;
}

template<typename T>
StaticList<T>* TreeNode_inorder(TreeNodeValue<T>* this__) {
    auto this_ = this__;
    StaticList<T>* result = GC::allocateLocal(new StaticList<T>());
    if (!((dart_isNull(this_->left)))) {
        result->addAll(static_cast<StaticList<T>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->left->getVptrMap()["inorder"]))(this_->left)));
    }
    result->add(this_->value);
    if (!((dart_isNull(this_->right)))) {
        result->addAll(static_cast<StaticList<T>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->right->getVptrMap()["inorder"]))(this_->right)));
    }
    return result;
}

template<typename T>
int64_t TreeNode_get_depth(TreeNodeValue<T>* this__) {
    auto this_ = this__;
    int64_t leftDepth = ([&]() { TreeNodeValue<T>* _let5 = this_->left; int64_t _let4 = ([&]() { TreeNodeValue<T>* _let5 = this_->left; return (dart_isNull(_let5) ? 0 : dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(_let5->getVptrMap()["get_depth"]))(_let5))); })();  return (false ? 0LL : _let4); })();
    int64_t rightDepth = ([&]() { TreeNodeValue<T>* _let7 = this_->right; int64_t _let6 = ([&]() { TreeNodeValue<T>* _let7 = this_->right; return (dart_isNull(_let7) ? 0 : dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(_let7->getVptrMap()["get_depth"]))(_let7))); })();  return (false ? 0LL : _let6); })();
    return (1LL + ((leftDepth > rightDepth) ? leftDepth : rightDepth));
}

template<typename T, typename R>
TreeNodeValue<R>* TreeNode_map(TreeNodeValue<T>* this__, TypeFunction1<R, T>* transform) {
    auto this_ = this__;
    return TreeNode_new<R>(GC::allocateLocal(new TreeNodeValue<R>()), transform->call(this_->value), static_cast<TreeNodeValue<R>*>(([&]() -> AnyGC* { TreeNodeValue<T>* _let8 = this_->left; if (dart_isNull(_let8)) return nullptr; return ((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(_let8->getVptrMap()["map"]))(_let8, _box(transform))); })()), static_cast<TreeNodeValue<R>*>(([&]() -> AnyGC* { TreeNodeValue<T>* _let9 = this_->right; if (dart_isNull(_let9)) return nullptr; return ((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(_let9->getVptrMap()["map"]))(_let9, _box(transform))); })()));
}

template<typename T>
std::string TreeNode_toString(TreeNodeValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("TreeNode(")) + dart_str(this_->value) + dart_str(std::string(")"));
}

template<typename T>
AnyGC* _vptr_wrap_LinkedNode_reversed(AnyGC* obj__) {
    return _box(LinkedNode_reversed<T>(static_cast<LinkedNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_LinkedNode_toList(AnyGC* obj__) {
    return _box(LinkedNode_toList<T>(static_cast<LinkedNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_LinkedNode_get_length(AnyGC* obj__) {
    return _box(LinkedNode_get_length<T>(static_cast<LinkedNodeValue<T>*>(obj__)));
}

template<typename T>
AnyGC* _vptr_wrap_LinkedNode_toString(AnyGC* obj__) {
    return _box(LinkedNode_toString<T>(static_cast<LinkedNodeValue<T>*>(obj__)));
}

template<typename T> void _register_LinkedNode_vptr() {
    if (LinkedNodeValue<T>::_vptrMap.empty()) {
        LinkedNodeValue<T>::_vptrMap["reversed"] = reinterpret_cast<void*>(&_vptr_wrap_LinkedNode_reversed<T>);
        LinkedNodeValue<T>::_vptrMap["toList"] = reinterpret_cast<void*>(&_vptr_wrap_LinkedNode_toList<T>);
        LinkedNodeValue<T>::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_LinkedNode_get_length<T>);
        LinkedNodeValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_LinkedNode_toString<T>);
    }
}
template<typename T>
LinkedNodeValue<T>* LinkedNode_new(LinkedNodeValue<T>* this__, T data, LinkedNodeValue<T>* next) {
    auto this_ = this__;
    if (LinkedNodeValue<T>::_vptrMap.empty()) {
        LinkedNodeValue<T>::_vptrMap["reversed"] = reinterpret_cast<void*>(&_vptr_wrap_LinkedNode_reversed<T>);
        LinkedNodeValue<T>::_vptrMap["toList"] = reinterpret_cast<void*>(&_vptr_wrap_LinkedNode_toList<T>);
        LinkedNodeValue<T>::_vptrMap["get_length"] = reinterpret_cast<void*>(&_vptr_wrap_LinkedNode_get_length<T>);
        LinkedNodeValue<T>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_LinkedNode_toString<T>);
    }
    this_->data = data;
    this_->next = next;
    return this_;
}

template<typename T>
LinkedNodeValue<T>* LinkedNode_reversed(LinkedNodeValue<T>* this__) {
    auto this_ = this__;
    if ((dart_isNull(this_->next))) {
        return LinkedNode_new<T>(GC::allocateLocal(new LinkedNodeValue<T>()), this_->data);
    }
    LinkedNodeValue<T>* rev = static_cast<LinkedNodeValue<T>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->next->getVptrMap()["reversed"]))(this_->next));
    LinkedNodeValue<T>* tail = rev;
    while (!((dart_isNull(tail->next)))) {
        (tail = tail->next);
    }
    (tail->next = LinkedNode_new<T>(GC::allocateLocal(new LinkedNodeValue<T>()), this_->data));
    return rev;
}

template<typename T>
StaticList<T>* LinkedNode_toList(LinkedNodeValue<T>* this__) {
    auto this_ = this__;
    StaticList<T>* result = GC::allocateLocal(new StaticList<T>({this_->data}));
    LinkedNodeValue<T>* current = this_->next;
    while (!((dart_isNull(current)))) {
        result->add(current->data);
        (current = current->next);
    }
    return result;
}

template<typename T>
int64_t LinkedNode_get_length(LinkedNodeValue<T>* this__) {
    auto this_ = this__;
    int64_t count = 1LL;
    LinkedNodeValue<T>* current = this_->next;
    while (!((dart_isNull(current)))) {
        (count = (count + 1LL));
        (current = current->next);
    }
    return count;
}

template<typename T>
std::string LinkedNode_toString(LinkedNodeValue<T>* this__) {
    auto this_ = this__;
    return dart_str(std::string("LinkedNode(")) + dart_str(static_cast<StaticList<T>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["toList"]))(this_))->join(std::string(" -> "))) + dart_str(std::string(")"));
}

template<typename L, typename R>
AnyGC* _vptr_wrap_Either_get_isLeft(AnyGC* obj__) {
    return _box(Either_get_isLeft<L, R>(static_cast<EitherValue<L, R>*>(obj__)));
}

template<typename L, typename R>
AnyGC* _vptr_wrap_Either_get_isRight(AnyGC* obj__) {
    return _box(Either_get_isRight<L, R>(static_cast<EitherValue<L, R>*>(obj__)));
}

template<typename L, typename R>
AnyGC* _vptr_wrap_Either_get_leftValue(AnyGC* obj__) {
    return _box(Either_get_leftValue<L, R>(static_cast<EitherValue<L, R>*>(obj__)));
}

template<typename L, typename R>
AnyGC* _vptr_wrap_Either_get_rightValue(AnyGC* obj__) {
    return _box(Either_get_rightValue<L, R>(static_cast<EitherValue<L, R>*>(obj__)));
}

template<typename L, typename R>
AnyGC* _vptr_wrap_Either_fold(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    _TypeFnAdapter1<L> _adapter0(static_cast<TypeFunction*>(arg0));
    _TypeFnAdapter1<R> _adapter1(static_cast<TypeFunction*>(arg1));
    return _box(Either_fold<L, R, AnyGC*>(static_cast<EitherValue<L, R>*>(obj__), &_adapter0, &_adapter1));
}

template<typename L, typename R>
AnyGC* _vptr_wrap_Either_mapRight(AnyGC* obj__, AnyGC* arg0) {
    _TypeFnAdapter1<R> _adapter0(static_cast<TypeFunction*>(arg0));
    return _box(Either_mapRight<L, R, AnyGC*>(static_cast<EitherValue<L, R>*>(obj__), &_adapter0));
}

template<typename L, typename R>
AnyGC* _vptr_wrap_Either_flatMap(AnyGC* obj__, AnyGC* arg0) {
    return _box(Either_flatMap<L, R, AnyGC*>(static_cast<EitherValue<L, R>*>(obj__), arg0));
}

template<typename L, typename R>
AnyGC* _vptr_wrap_Either_toString(AnyGC* obj__) {
    return _box(Either_toString<L, R>(static_cast<EitherValue<L, R>*>(obj__)));
}

template<typename L, typename R> void _register_Either_vptr() {
    if (EitherValue<L, R>::_vptrMap.empty()) {
        EitherValue<L, R>::_vptrMap["get_isLeft"] = reinterpret_cast<void*>(&_vptr_wrap_Either_get_isLeft<L, R>);
        EitherValue<L, R>::_vptrMap["get_isRight"] = reinterpret_cast<void*>(&_vptr_wrap_Either_get_isRight<L, R>);
        EitherValue<L, R>::_vptrMap["get_leftValue"] = reinterpret_cast<void*>(&_vptr_wrap_Either_get_leftValue<L, R>);
        EitherValue<L, R>::_vptrMap["get_rightValue"] = reinterpret_cast<void*>(&_vptr_wrap_Either_get_rightValue<L, R>);
        EitherValue<L, R>::_vptrMap["fold"] = reinterpret_cast<void*>(&_vptr_wrap_Either_fold<L, R>);
        EitherValue<L, R>::_vptrMap["mapRight"] = reinterpret_cast<void*>(&_vptr_wrap_Either_mapRight<L, R>);
        EitherValue<L, R>::_vptrMap["flatMap"] = reinterpret_cast<void*>(&_vptr_wrap_Either_flatMap<L, R>);
        EitherValue<L, R>::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Either_toString<L, R>);
    }
}
template<typename L, typename R>
EitherValue<L, R>* Either_new_left(EitherValue<L, R>* this__, L value) {
    auto this_ = this__;
    this_->_left = value;
    this_->_right = R{};
    this_->_isRight = false;
    return this_;
}

template<typename L, typename R>
EitherValue<L, R>* Either_new_right(EitherValue<L, R>* this__, R value) {
    auto this_ = this__;
    this_->_left = L{};
    this_->_right = value;
    this_->_isRight = true;
    return this_;
}

template<typename L, typename R>
bool Either_get_isLeft(EitherValue<L, R>* this__) {
    auto this_ = this__;
    return !(this_->_isRight);
}

template<typename L, typename R>
bool Either_get_isRight(EitherValue<L, R>* this__) {
    auto this_ = this__;
    return this_->_isRight;
}

template<typename L, typename R>
L Either_get_leftValue(EitherValue<L, R>* this__) {
    auto this_ = this__;
    if (!(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_isLeft"]))(this_)))) {
        throw DartStateError(std::string("Not a left value"));
    }
    return ([&]() { L _let11 = this_->_left; return ((dart_isNull(_let11)) ? _let11 : _let11); })();
}

template<typename L, typename R>
R Either_get_rightValue(EitherValue<L, R>* this__) {
    auto this_ = this__;
    if (!(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_isRight"]))(this_)))) {
        throw DartStateError(std::string("Not a right value"));
    }
    return ([&]() { R _let12 = this_->_right; return ((dart_isNull(_let12)) ? _let12 : _let12); })();
}

template<typename L, typename R, typename T>
T Either_fold(EitherValue<L, R>* this__, TypeFunction1<T, L>* onLeft, TypeFunction1<T, R>* onRight) {
    auto this_ = this__;
    if (this_->_isRight) {
        return onRight->call(([&]() { R _let13 = this_->_right; return ((dart_isNull(_let13)) ? _let13 : _let13); })());
    }
    return onLeft->call(([&]() { L _let14 = this_->_left; return ((dart_isNull(_let14)) ? _let14 : _let14); })());
}

template<typename L, typename R, typename R2>
EitherValue<L, R2>* Either_mapRight(EitherValue<L, R>* this__, TypeFunction1<R2, R>* transform) {
    auto this_ = this__;
    if (this_->_isRight) {
        return Either_new_right<L, R2>(GC::allocateLocal(new EitherValue<L, R2>()), transform->call(([&]() { R _let15 = this_->_right; return ((dart_isNull(_let15)) ? _let15 : _let15); })()));
    }
    return Either_new_left<L, R2>(GC::allocateLocal(new EitherValue<L, R2>()), ([&]() { L _let16 = this_->_left; return ((dart_isNull(_let16)) ? _let16 : _let16); })());
}

template<typename L, typename R, typename R2>
EitherValue<L, R2>* Either_flatMap(EitherValue<L, R>* this__, TypeFunction1<EitherValue<L, R2>*, R>* transform) {
    auto this_ = this__;
    if (this_->_isRight) {
        return transform->call(([&]() { R _let17 = this_->_right; return ((dart_isNull(_let17)) ? _let17 : _let17); })());
    }
    return Either_new_left<L, R2>(GC::allocateLocal(new EitherValue<L, R2>()), ([&]() { L _let18 = this_->_left; return ((dart_isNull(_let18)) ? _let18 : _let18); })());
}

template<typename L, typename R>
std::string Either_toString(EitherValue<L, R>* this__) {
    auto this_ = this__;
    if (this_->_isRight) {
        return dart_str(std::string("Right(")) + dart_str(this_->_right) + dart_str(std::string(")"));
    }
    return dart_str(std::string("Left(")) + dart_str(this_->_left) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_UserProfile_toMap(AnyGC* obj__) {
    return _box(UserProfile_toMap(static_cast<UserProfileValue*>(obj__)));
}

AnyGC* _vptr_wrap_UserProfile_serialize(AnyGC* obj__) {
    return _box(UserProfile_serialize(static_cast<UserProfileValue*>(obj__)));
}

AnyGC* _vptr_wrap_UserProfile_validate(AnyGC* obj__) {
    return _box(UserProfile_validate(static_cast<UserProfileValue*>(obj__)));
}

AnyGC* _vptr_wrap_UserProfile_get_isValid(AnyGC* obj__) {
    return _box(UserProfile_get_isValid(static_cast<UserProfileValue*>(obj__)));
}

AnyGC* _vptr_wrap_UserProfile_get_validationSummary(AnyGC* obj__) {
    return _box(UserProfile_get_validationSummary(static_cast<UserProfileValue*>(obj__)));
}

AnyGC* _vptr_wrap_UserProfile_toString(AnyGC* obj__) {
    return _box(UserProfile_toString(static_cast<UserProfileValue*>(obj__)));
}

static bool _UserProfile_vptr_registered = []{ UserProfileValue::_vptrMap["toMap"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_toMap); UserProfileValue::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_serialize); UserProfileValue::_vptrMap["validate"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_validate); UserProfileValue::_vptrMap["get_isValid"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_get_isValid); UserProfileValue::_vptrMap["get_validationSummary"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_get_validationSummary); UserProfileValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_toString); return true; }();
UserProfileValue* UserProfile_new(UserProfileValue* this__, std::string name, std::string email, int64_t age) {
    auto this_ = this__;
    if (UserProfileValue::_vptrMap.empty()) {
        UserProfileValue::_vptrMap["toMap"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_toMap);
        UserProfileValue::_vptrMap["serialize"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_serialize);
        UserProfileValue::_vptrMap["validate"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_validate);
        UserProfileValue::_vptrMap["get_isValid"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_get_isValid);
        UserProfileValue::_vptrMap["get_validationSummary"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_get_validationSummary);
        UserProfileValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_UserProfile_toString);
    }
    this_->name = name;
    this_->email = email;
    this_->age = age;
    return this_;
}

StaticMap<std::string, AnyGC*>* UserProfile_toMap(UserProfileValue* this__) {
    auto this_ = this__;
    return ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(this_->name))); _m->set(std::string("email"), GC::allocateLocal(new StringBox(this_->email))); _m->set(std::string("age"), GC::allocateLocal(new IntBox(this_->age))); return _m; })();
}

StaticList<std::string>* UserProfile_validate(UserProfileValue* this__) {
    auto this_ = this__;
    StaticList<std::string>* errors = GC::allocateLocal(new StaticList<std::string>());
    if (this_->name.empty()) {
        errors->add(std::string("name is empty"));
    }
    if (!((this_->email.find(std::string("@")) != std::string::npos))) {
        errors->add(std::string("invalid email"));
    }
    if (((this_->age < 0LL) || (this_->age > 150LL))) {
        errors->add(std::string("invalid age"));
    }
    return errors;
}

std::string UserProfile_toString(UserProfileValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("UserProfile(")) + dart_str(this_->name) + dart_str(std::string(", ")) + dart_str(this_->email) + dart_str(std::string(", ")) + dart_str(this_->age) + dart_str(std::string(")"));
}

template<typename TInput, typename TOutput>
AnyGC* _vptr_wrap_DataTransformer_transform(AnyGC* obj__, AnyGC* arg0) {
    return _box(DataTransformer_transform<TInput, TOutput>(static_cast<DataTransformerValue<TInput, TOutput>*>(obj__), dynAs<TInput>(arg0)));
}

template<typename TInput, typename TOutput>
AnyGC* _vptr_wrap_DataTransformer_preValidate(AnyGC* obj__, AnyGC* arg0) {
    return _box(DataTransformer_preValidate<TInput, TOutput>(static_cast<DataTransformerValue<TInput, TOutput>*>(obj__), dynAs<TInput>(arg0)));
}

template<typename TInput, typename TOutput>
AnyGC* _vptr_wrap_DataTransformer_process(AnyGC* obj__, AnyGC* arg0) {
    return _box(DataTransformer_process<TInput, TOutput>(static_cast<DataTransformerValue<TInput, TOutput>*>(obj__), dynAs<TInput>(arg0)));
}

template<typename TInput, typename TOutput>
AnyGC* _vptr_wrap_DataTransformer_postProcess(AnyGC* obj__, AnyGC* arg0) {
    return _box(DataTransformer_postProcess<TInput, TOutput>(static_cast<DataTransformerValue<TInput, TOutput>*>(obj__), dynAs<TOutput>(arg0)));
}

template<typename TInput, typename TOutput> void _register_DataTransformer_vptr() {
    if (DataTransformerValue<TInput, TOutput>::_vptrMap.empty()) {
        DataTransformerValue<TInput, TOutput>::_vptrMap["transform"] = reinterpret_cast<void*>(&_vptr_wrap_DataTransformer_transform<TInput, TOutput>);
        DataTransformerValue<TInput, TOutput>::_vptrMap["preValidate"] = reinterpret_cast<void*>(&_vptr_wrap_DataTransformer_preValidate<TInput, TOutput>);
        DataTransformerValue<TInput, TOutput>::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_DataTransformer_process<TInput, TOutput>);
        DataTransformerValue<TInput, TOutput>::_vptrMap["postProcess"] = reinterpret_cast<void*>(&_vptr_wrap_DataTransformer_postProcess<TInput, TOutput>);
    }
}
template<typename TInput, typename TOutput>
DataTransformerValue<TInput, TOutput>* DataTransformer_new(DataTransformerValue<TInput, TOutput>* this__) {
    auto this_ = this__;
    if (DataTransformerValue<TInput, TOutput>::_vptrMap.empty()) {
        DataTransformerValue<TInput, TOutput>::_vptrMap["transform"] = reinterpret_cast<void*>(&_vptr_wrap_DataTransformer_transform<TInput, TOutput>);
        DataTransformerValue<TInput, TOutput>::_vptrMap["preValidate"] = reinterpret_cast<void*>(&_vptr_wrap_DataTransformer_preValidate<TInput, TOutput>);
        DataTransformerValue<TInput, TOutput>::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_DataTransformer_process<TInput, TOutput>);
        DataTransformerValue<TInput, TOutput>::_vptrMap["postProcess"] = reinterpret_cast<void*>(&_vptr_wrap_DataTransformer_postProcess<TInput, TOutput>);
    }
    return this_;
}

template<typename TInput, typename TOutput>
TOutput DataTransformer_transform(DataTransformerValue<TInput, TOutput>* this__, TInput input) {
    auto this_ = this__;
    TInput validated = dynAs<TInput>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["preValidate"]))(this_, _box(input)));
    TOutput processed = dynAs<TOutput>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["process"]))(this_, _box(validated)));
    return dynAs<TOutput>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["postProcess"]))(this_, _box(processed)));
}

template<typename TInput, typename TOutput>
TInput DataTransformer_preValidate(DataTransformerValue<TInput, TOutput>* this__, TInput input) {
    auto this_ = this__;
    return input;
}

template<typename TInput, typename TOutput>
TOutput DataTransformer_process(DataTransformerValue<TInput, TOutput>* this__, TInput input) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method DataTransformer.process")));
}

template<typename TInput, typename TOutput>
TOutput DataTransformer_postProcess(DataTransformerValue<TInput, TOutput>* this__, TOutput output) {
    auto this_ = this__;
    return output;
}

AnyGC* _vptr_wrap_StringToIntTransformer_transform(AnyGC* obj__, AnyGC* arg0) {
    return _box(StringToIntTransformer_transform(static_cast<StringToIntTransformerValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_StringToIntTransformer_preValidate(AnyGC* obj__, AnyGC* arg0) {
    return _box(StringToIntTransformer_preValidate(static_cast<StringToIntTransformerValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_StringToIntTransformer_process(AnyGC* obj__, AnyGC* arg0) {
    return _box(StringToIntTransformer_process(static_cast<StringToIntTransformerValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_StringToIntTransformer_postProcess(AnyGC* obj__, AnyGC* arg0) {
    return _box(StringToIntTransformer_postProcess(static_cast<StringToIntTransformerValue*>(obj__), dynAs<int64_t>(arg0)));
}

static bool _StringToIntTransformer_vptr_registered = []{ StringToIntTransformerValue::_vptrMap["transform"] = reinterpret_cast<void*>(&_vptr_wrap_StringToIntTransformer_transform); StringToIntTransformerValue::_vptrMap["preValidate"] = reinterpret_cast<void*>(&_vptr_wrap_StringToIntTransformer_preValidate); StringToIntTransformerValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_StringToIntTransformer_process); StringToIntTransformerValue::_vptrMap["postProcess"] = reinterpret_cast<void*>(&_vptr_wrap_StringToIntTransformer_postProcess); return true; }();
StringToIntTransformerValue* StringToIntTransformer_new(StringToIntTransformerValue* this__) {
    auto this_ = this__;
    if (StringToIntTransformerValue::_vptrMap.empty()) {
        StringToIntTransformerValue::_vptrMap["transform"] = reinterpret_cast<void*>(&_vptr_wrap_StringToIntTransformer_transform);
        StringToIntTransformerValue::_vptrMap["preValidate"] = reinterpret_cast<void*>(&_vptr_wrap_StringToIntTransformer_preValidate);
        StringToIntTransformerValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_StringToIntTransformer_process);
        StringToIntTransformerValue::_vptrMap["postProcess"] = reinterpret_cast<void*>(&_vptr_wrap_StringToIntTransformer_postProcess);
    }
    DataTransformer_new<std::string, int64_t>(this_);
    return this_;
}

std::string StringToIntTransformer_preValidate(StringToIntTransformerValue* this__, std::string input) {
    auto this_ = this__;
    return dart_str_trim(input);
}

int64_t StringToIntTransformer_process(StringToIntTransformerValue* this__, std::string input) {
    auto this_ = this__;
    return dart_stoll(input);
}

AnyGC* _vptr_wrap_IntToStringTransformer_transform(AnyGC* obj__, AnyGC* arg0) {
    return _box(IntToStringTransformer_transform(static_cast<IntToStringTransformerValue*>(obj__), dynAs<int64_t>(arg0)));
}

AnyGC* _vptr_wrap_IntToStringTransformer_preValidate(AnyGC* obj__, AnyGC* arg0) {
    return _box(IntToStringTransformer_preValidate(static_cast<IntToStringTransformerValue*>(obj__), dynAs<int64_t>(arg0)));
}

AnyGC* _vptr_wrap_IntToStringTransformer_process(AnyGC* obj__, AnyGC* arg0) {
    return _box(IntToStringTransformer_process(static_cast<IntToStringTransformerValue*>(obj__), dynAs<int64_t>(arg0)));
}

AnyGC* _vptr_wrap_IntToStringTransformer_postProcess(AnyGC* obj__, AnyGC* arg0) {
    return _box(IntToStringTransformer_postProcess(static_cast<IntToStringTransformerValue*>(obj__), dynAs<std::string>(arg0)));
}

static bool _IntToStringTransformer_vptr_registered = []{ IntToStringTransformerValue::_vptrMap["transform"] = reinterpret_cast<void*>(&_vptr_wrap_IntToStringTransformer_transform); IntToStringTransformerValue::_vptrMap["preValidate"] = reinterpret_cast<void*>(&_vptr_wrap_IntToStringTransformer_preValidate); IntToStringTransformerValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_IntToStringTransformer_process); IntToStringTransformerValue::_vptrMap["postProcess"] = reinterpret_cast<void*>(&_vptr_wrap_IntToStringTransformer_postProcess); return true; }();
IntToStringTransformerValue* IntToStringTransformer_new(IntToStringTransformerValue* this__, std::string prefix) {
    auto this_ = this__;
    if (IntToStringTransformerValue::_vptrMap.empty()) {
        IntToStringTransformerValue::_vptrMap["transform"] = reinterpret_cast<void*>(&_vptr_wrap_IntToStringTransformer_transform);
        IntToStringTransformerValue::_vptrMap["preValidate"] = reinterpret_cast<void*>(&_vptr_wrap_IntToStringTransformer_preValidate);
        IntToStringTransformerValue::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_IntToStringTransformer_process);
        IntToStringTransformerValue::_vptrMap["postProcess"] = reinterpret_cast<void*>(&_vptr_wrap_IntToStringTransformer_postProcess);
    }
    this_->prefix = prefix;
    DataTransformer_new<int64_t, std::string>(this_);
    return this_;
}

std::string IntToStringTransformer_process(IntToStringTransformerValue* this__, int64_t input) {
    auto this_ = this__;
    return dart_str(this_->prefix) + dart_str(std::to_string(input));
}

std::string IntToStringTransformer_postProcess(IntToStringTransformerValue* this__, std::string output) {
    auto this_ = this__;
    return dart_str_toUpper(output);
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_ChainedTransformer_transform(AnyGC* obj__, AnyGC* arg0) {
    return _box(ChainedTransformer_transform<A, B, C>(static_cast<ChainedTransformerValue<A, B, C>*>(obj__), dynAs<A>(arg0)));
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_ChainedTransformer_preValidate(AnyGC* obj__, AnyGC* arg0) {
    return _box(ChainedTransformer_preValidate<A, B, C>(static_cast<ChainedTransformerValue<A, B, C>*>(obj__), dynAs<A>(arg0)));
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_ChainedTransformer_process(AnyGC* obj__, AnyGC* arg0) {
    return _box(ChainedTransformer_process<A, B, C>(static_cast<ChainedTransformerValue<A, B, C>*>(obj__), dynAs<A>(arg0)));
}

template<typename A, typename B, typename C>
AnyGC* _vptr_wrap_ChainedTransformer_postProcess(AnyGC* obj__, AnyGC* arg0) {
    return _box(ChainedTransformer_postProcess<A, B, C>(static_cast<ChainedTransformerValue<A, B, C>*>(obj__), dynAs<C>(arg0)));
}

template<typename A, typename B, typename C> void _register_ChainedTransformer_vptr() {
    if (ChainedTransformerValue<A, B, C>::_vptrMap.empty()) {
        ChainedTransformerValue<A, B, C>::_vptrMap["transform"] = reinterpret_cast<void*>(&_vptr_wrap_ChainedTransformer_transform<A, B, C>);
        ChainedTransformerValue<A, B, C>::_vptrMap["preValidate"] = reinterpret_cast<void*>(&_vptr_wrap_ChainedTransformer_preValidate<A, B, C>);
        ChainedTransformerValue<A, B, C>::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_ChainedTransformer_process<A, B, C>);
        ChainedTransformerValue<A, B, C>::_vptrMap["postProcess"] = reinterpret_cast<void*>(&_vptr_wrap_ChainedTransformer_postProcess<A, B, C>);
    }
}
template<typename A, typename B, typename C>
ChainedTransformerValue<A, B, C>* ChainedTransformer_new(ChainedTransformerValue<A, B, C>* this__, DataTransformerValue<A, B>* first, DataTransformerValue<B, C>* second) {
    auto this_ = this__;
    if (ChainedTransformerValue<A, B, C>::_vptrMap.empty()) {
        ChainedTransformerValue<A, B, C>::_vptrMap["transform"] = reinterpret_cast<void*>(&_vptr_wrap_ChainedTransformer_transform<A, B, C>);
        ChainedTransformerValue<A, B, C>::_vptrMap["preValidate"] = reinterpret_cast<void*>(&_vptr_wrap_ChainedTransformer_preValidate<A, B, C>);
        ChainedTransformerValue<A, B, C>::_vptrMap["process"] = reinterpret_cast<void*>(&_vptr_wrap_ChainedTransformer_process<A, B, C>);
        ChainedTransformerValue<A, B, C>::_vptrMap["postProcess"] = reinterpret_cast<void*>(&_vptr_wrap_ChainedTransformer_postProcess<A, B, C>);
    }
    this_->first = first;
    this_->second = second;
    DataTransformer_new<A, C>(this_);
    return this_;
}

template<typename A, typename B, typename C>
C ChainedTransformer_process(ChainedTransformerValue<A, B, C>* this__, A input) {
    auto this_ = this__;
    B intermediate = dynAs<B>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->first->getVptrMap()["transform"]))(this_->first, _box(input)));
    return dynAs<C>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->second->getVptrMap()["transform"]))(this_->second, _box(intermediate)));
}

AnyGC* _vptr_wrap_Registry_register_(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    Registry_register_(static_cast<RegistryValue*>(obj__), dynAs<std::string>(arg0), arg1);
    return nullptr;
}

AnyGC* _vptr_wrap_Registry_lookup(AnyGC* obj__, AnyGC* arg0) {
    return _box(Registry_lookup(static_cast<RegistryValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_Registry_contains(AnyGC* obj__, AnyGC* arg0) {
    return _box(Registry_contains(static_cast<RegistryValue*>(obj__), dynAs<std::string>(arg0)));
}

AnyGC* _vptr_wrap_Registry_get_size(AnyGC* obj__) {
    return _box(Registry_get_size(static_cast<RegistryValue*>(obj__)));
}

AnyGC* _vptr_wrap_Registry_get_accessCount(AnyGC* obj__) {
    return _box(Registry_get_accessCount(static_cast<RegistryValue*>(obj__)));
}

AnyGC* _vptr_wrap_Registry_get_keys(AnyGC* obj__) {
    return _box(Registry_get_keys(static_cast<RegistryValue*>(obj__)));
}

AnyGC* _vptr_wrap_Registry_clear(AnyGC* obj__) {
    Registry_clear(static_cast<RegistryValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Registry_toString(AnyGC* obj__) {
    return _box(Registry_toString(static_cast<RegistryValue*>(obj__)));
}

static bool _Registry_vptr_registered = []{ RegistryValue::_vptrMap["register_"] = reinterpret_cast<void*>(&_vptr_wrap_Registry_register_); RegistryValue::_vptrMap["lookup"] = reinterpret_cast<void*>(&_vptr_wrap_Registry_lookup); RegistryValue::_vptrMap["contains"] = reinterpret_cast<void*>(&_vptr_wrap_Registry_contains); RegistryValue::_vptrMap["get_size"] = reinterpret_cast<void*>(&_vptr_wrap_Registry_get_size); RegistryValue::_vptrMap["get_accessCount"] = reinterpret_cast<void*>(&_vptr_wrap_Registry_get_accessCount); RegistryValue::_vptrMap["get_keys"] = reinterpret_cast<void*>(&_vptr_wrap_Registry_get_keys); RegistryValue::_vptrMap["clear"] = reinterpret_cast<void*>(&_vptr_wrap_Registry_clear); RegistryValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Registry_toString); return true; }();
RegistryValue* _instance = Registry_new__internal(GC::allocateLocal(new RegistryValue()));
RegistryValue* Registry_new__internal(RegistryValue* this__) {
    auto this_ = this__;
    this_->_store = StaticMap<std::string, AnyGC*>::empty();
    this_->_accessCount = 0LL;
    return this_;
}

RegistryValue* Registry_new() {
    return _instance;
}

void Registry_register_(RegistryValue* this__, std::string key, AnyGC* value) {
    auto this_ = this__;
    this_->_store->set(key, value);
    (this_->_accessCount = (this_->_accessCount + 1LL));
}

AnyGC* Registry_lookup(RegistryValue* this__, std::string key) {
    auto this_ = this__;
    (this_->_accessCount = (this_->_accessCount + 1LL));
    return _box(*(*this_->_store)[key]);
}

bool Registry_contains(RegistryValue* this__, std::string key) {
    auto this_ = this__;
    return this_->_store->containsKey(key);
}

int64_t Registry_get_size(RegistryValue* this__) {
    auto this_ = this__;
    return this_->_store->length();
}

int64_t Registry_get_accessCount(RegistryValue* this__) {
    auto this_ = this__;
    return this_->_accessCount;
}

StaticList<std::string>* Registry_get_keys(RegistryValue* this__) {
    auto this_ = this__;
    return ([&]() { StaticList<std::string>* _let19 = this_->_store->keys(); return ([&]() {     _let19->sort();
 return _let19; })(); })();
}

void Registry_clear(RegistryValue* this__) {
    auto this_ = this__;
    this_->_store->clear();
    (this_->_accessCount = 0LL);
}

std::string Registry_toString(RegistryValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Registry(size=")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_size"]))(this_))) + dart_str(std::string(", accesses=")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_accessCount"]))(this_))) + dart_str(std::string(")"));
}

DataProcessorValue* DataProcessor_new(DataProcessorValue* this__) {
    auto this_ = this__;
    return this_;
}

StaticList<StaticMap<std::string, AnyGC*>*>* DataProcessor_processRecords(StaticList<StaticMap<std::string, AnyGC*>*>* records) {
    return ([&]() { StaticList<StaticMap<std::string, AnyGC*>*>* _let20 = records->where(GC::allocateLocal(static_cast<TypeFunction1<bool, StaticMap<std::string, AnyGC*>*>*>(new ClosureEnv_1())))->where(GC::allocateLocal(static_cast<TypeFunction1<bool, StaticMap<std::string, AnyGC*>*>*>(new ClosureEnv_2())))->map(GC::allocateLocal(static_cast<TypeFunction1<StaticMap<std::string, AnyGC*>*, StaticMap<std::string, AnyGC*>*>*>(new ClosureEnv_3()))); return ([&]() {     _let20->sort(GC::allocateLocal(static_cast<TypeFunction2<int64_t, StaticMap<std::string, AnyGC*>*, StaticMap<std::string, AnyGC*>*>*>(new ClosureEnv_4())));
 return _let20; })(); })();
}

std::string DataProcessor__scoreToGrade(int64_t score) {
    if ((score >= 90LL)) {
        return std::string("A");
    }
    if ((score >= 80LL)) {
        return std::string("B");
    }
    if ((score >= 70LL)) {
        return std::string("C");
    }
    if ((score >= 60LL)) {
        return std::string("D");
    }
    return std::string("F");
}

StaticMap<std::string, StaticList<StaticMap<std::string, AnyGC*>*>*>* DataProcessor_groupByGrade(StaticList<StaticMap<std::string, AnyGC*>*>* records) {
    StaticMap<std::string, StaticList<StaticMap<std::string, AnyGC*>*>*>* groups = StaticMap<std::string, StaticList<StaticMap<std::string, AnyGC*>*>*>::empty();
    StaticIterator<StaticMap<std::string, AnyGC*>*>* sync_for_iterator = records->iterator();
    while (sync_for_iterator->moveNext()) {
        StaticMap<std::string, AnyGC*>* record = sync_for_iterator->current();
        std::string grade = dynAs<std::string>(_box(*(*record)[std::string("grade")]));
    groups->putIfAbsent(grade, GC::allocateLocal(static_cast<TypeFunction0<StaticList<StaticMap<std::string, AnyGC*>*>*>*>(new ClosureEnv_5())));
    static_cast<StaticList<StaticMap<std::string, AnyGC*>*>*>(_box(*(*groups)[grade]))->add(record);
}
return groups;
}

StaticMap<std::string, double>* DataProcessor_averageByGrade(StaticList<StaticMap<std::string, AnyGC*>*>* records) {
    StaticMap<std::string, StaticList<StaticMap<std::string, AnyGC*>*>*>* groups = DataProcessor_groupByGrade(records);
    return groups->map(GC::allocateLocal(static_cast<TypeFunction2<StaticMapEntry<std::string, double>, std::string, StaticList<StaticMap<std::string, AnyGC*>*>*>*>(new ClosureEnv_6())));
}

AnyGC* _vptr_wrap_ExpensiveComputation_initialize(AnyGC* obj__, AnyGC* arg0) {
    ExpensiveComputation_initialize(static_cast<ExpensiveComputationValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_ExpensiveComputation_toString(AnyGC* obj__) {
    return _box(ExpensiveComputation_toString(static_cast<ExpensiveComputationValue*>(obj__)));
}

static bool _ExpensiveComputation_vptr_registered = []{ ExpensiveComputationValue::_vptrMap["initialize"] = reinterpret_cast<void*>(&_vptr_wrap_ExpensiveComputation_initialize); ExpensiveComputationValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_ExpensiveComputation_toString); return true; }();
ExpensiveComputationValue* ExpensiveComputation_new(ExpensiveComputationValue* this__, int64_t seed) {
    auto this_ = this__;
    if (ExpensiveComputationValue::_vptrMap.empty()) {
        ExpensiveComputationValue::_vptrMap["initialize"] = reinterpret_cast<void*>(&_vptr_wrap_ExpensiveComputation_initialize);
        ExpensiveComputationValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_ExpensiveComputation_toString);
    }
    this_->seed = seed;
    this_->computedValue = ExpensiveComputation__computeExpensive(this_);
    return this_;
}

int64_t ExpensiveComputation__computeExpensive(ExpensiveComputationValue* this__) {
    auto this_ = this__;
    int64_t result = this_->seed;
    int64_t i = 0LL;
    while ((i < 10LL)) {
        (result = (((result * 31LL) + 17LL) % 1000LL));
        (i = (i + 1LL));
    }
    return result;
}

void ExpensiveComputation_initialize(ExpensiveComputationValue* this__, std::string desc) {
    auto this_ = this__;
    (this_->description = desc);
}

std::string ExpensiveComputation_toString(ExpensiveComputationValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("ExpensiveComputation(seed=")) + dart_str(this_->seed) + dart_str(std::string(", computed=")) + dart_str(this_->computedValue) + dart_str(std::string(")"));
}

MathUtilsValue* MathUtils_new(MathUtilsValue* this__) {
    auto this_ = this__;
    return this_;
}

int64_t MathUtils_fibonacci(int64_t n) {
    StaticMap<int64_t, int64_t>* memo = StaticMap<int64_t, int64_t>::empty();
    std::function<int64_t(int64_t)> fib = [&](int64_t k) -> int64_t {
        if ((k <= 1LL)) {
            return k;
        }
        if (memo->containsKey(k)) {
            return (*(*memo)[k]);
        }
        int64_t result = (fib((k - 1LL)) + fib((k - 2LL)));
        memo->set(k, result);
        return result;
    };
    return fib(n);
}

StaticList<int64_t>* MathUtils_primeFactors(int64_t n) {
    StaticList<int64_t>* factors = GC::allocateLocal(new StaticList<int64_t>());
    std::function<void(int64_t)> extractFactor = [&](int64_t factor) -> void {
        while (((n % factor) == 0LL)) {
            factors->add(factor);
            (n = (n / factor));
        }
    };
    extractFactor(2LL);
    int64_t i = 3LL;
    while (((i * i) <= n)) {
        extractFactor(i);
        (i = (i + 2LL));
    }
    if ((n > 1LL)) {
        factors->add(n);
    }
    return factors;
}

int64_t MathUtils_gcd(int64_t a, int64_t b) {
    while (!((b == 0LL))) {
        int64_t temp = b;
        (b = (a % b));
        (a = temp);
    }
    return a;
}

int64_t MathUtils_lcm(int64_t a, int64_t b) {
    return ((a * b) / MathUtils_gcd(a, b));
}

AnyGC* _vptr_wrap_Printable3_prettyPrint(AnyGC* obj__) {
    return _box(Printable3_prettyPrint(static_cast<Printable3Value*>(obj__)));
}

static bool _Printable3_vptr_registered = []{ Printable3Value::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_Printable3_prettyPrint); return true; }();
Printable3Value* Printable3_new(Printable3Value* this__) {
    auto this_ = this__;
    if (Printable3Value::_vptrMap.empty()) {
        Printable3Value::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_Printable3_prettyPrint);
    }
    return this_;
}

std::string Printable3_prettyPrint(Printable3Value* this__) {
    auto this_ = this__;
    throw DartUnimplementedError(dart_str(std::string("abstract method Printable3.prettyPrint")));
}

AnyGC* _vptr_wrap_Score_prettyPrint(AnyGC* obj__) {
    return _box(Score_prettyPrint(static_cast<ScoreValue*>(obj__)));
}

AnyGC* _vptr_wrap_Score_compareTo2(AnyGC* obj__, AnyGC* arg0) {
    return _box(Score_compareTo2(static_cast<ScoreValue*>(obj__), static_cast<ScoreValue*>(arg0)));
}

AnyGC* _vptr_wrap_Score_isLessThan(AnyGC* obj__, AnyGC* arg0) {
    return _box(Score_isLessThan(static_cast<ScoreValue*>(obj__), static_cast<ScoreValue*>(arg0)));
}

AnyGC* _vptr_wrap_Score_isGreaterThan(AnyGC* obj__, AnyGC* arg0) {
    return _box(Score_isGreaterThan(static_cast<ScoreValue*>(obj__), static_cast<ScoreValue*>(arg0)));
}

AnyGC* _vptr_wrap_Score_toString(AnyGC* obj__) {
    return _box(Score_toString(static_cast<ScoreValue*>(obj__)));
}

static bool _Score_vptr_registered = []{ ScoreValue::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_Score_prettyPrint); ScoreValue::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_Score_compareTo2); ScoreValue::_vptrMap["isLessThan"] = reinterpret_cast<void*>(&_vptr_wrap_Score_isLessThan); ScoreValue::_vptrMap["isGreaterThan"] = reinterpret_cast<void*>(&_vptr_wrap_Score_isGreaterThan); ScoreValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Score_toString); return true; }();
ScoreValue* Score_new(ScoreValue* this__, std::string subject, int64_t points) {
    auto this_ = this__;
    if (ScoreValue::_vptrMap.empty()) {
        ScoreValue::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_Score_prettyPrint);
        ScoreValue::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_Score_compareTo2);
        ScoreValue::_vptrMap["isLessThan"] = reinterpret_cast<void*>(&_vptr_wrap_Score_isLessThan);
        ScoreValue::_vptrMap["isGreaterThan"] = reinterpret_cast<void*>(&_vptr_wrap_Score_isGreaterThan);
        ScoreValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Score_toString);
    }
    this_->subject = subject;
    this_->points = points;
    return this_;
}

int64_t Score_compareTo2(ScoreValue* this__, ScoreValue* other) {
    auto this_ = this__;
    return ((this_->points) > static_cast<int64_t>(other->points) ? 1LL : ((this_->points) < static_cast<int64_t>(other->points) ? -1LL : 0LL));
}

bool Score_isLessThan(ScoreValue* this__, ScoreValue* other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo2"]))(this_, _box(other))) < 0LL);
}

bool Score_isGreaterThan(ScoreValue* this__, ScoreValue* other) {
    auto this_ = this__;
    return (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["compareTo2"]))(this_, _box(other))) > 0LL);
}

std::string Score_prettyPrint(ScoreValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("[")) + dart_str(this_->subject) + dart_str(std::string(": ")) + dart_str(this_->points) + dart_str(std::string(" pts]"));
}

std::string Score_toString(ScoreValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Score(")) + dart_str(this_->subject) + dart_str(std::string(", ")) + dart_str(this_->points) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_WeightedScore_prettyPrint(AnyGC* obj__) {
    return _box(WeightedScore_prettyPrint(static_cast<WeightedScoreValue*>(obj__)));
}

AnyGC* _vptr_wrap_WeightedScore_compareTo2(AnyGC* obj__, AnyGC* arg0) {
    return _box(WeightedScore_compareTo2(static_cast<WeightedScoreValue*>(obj__), static_cast<ScoreValue*>(arg0)));
}

AnyGC* _vptr_wrap_WeightedScore_isLessThan(AnyGC* obj__, AnyGC* arg0) {
    return _box(WeightedScore_isLessThan(static_cast<WeightedScoreValue*>(obj__), static_cast<ScoreValue*>(arg0)));
}

AnyGC* _vptr_wrap_WeightedScore_isGreaterThan(AnyGC* obj__, AnyGC* arg0) {
    return _box(WeightedScore_isGreaterThan(static_cast<WeightedScoreValue*>(obj__), static_cast<ScoreValue*>(arg0)));
}

AnyGC* _vptr_wrap_WeightedScore_toString(AnyGC* obj__) {
    return _box(WeightedScore_toString(static_cast<WeightedScoreValue*>(obj__)));
}

AnyGC* _vptr_wrap_WeightedScore_get_weightedPoints(AnyGC* obj__) {
    return _box(WeightedScore_get_weightedPoints(static_cast<WeightedScoreValue*>(obj__)));
}

static bool _WeightedScore_vptr_registered = []{ WeightedScoreValue::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_prettyPrint); WeightedScoreValue::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_compareTo2); WeightedScoreValue::_vptrMap["isLessThan"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_isLessThan); WeightedScoreValue::_vptrMap["isGreaterThan"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_isGreaterThan); WeightedScoreValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_toString); WeightedScoreValue::_vptrMap["get_weightedPoints"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_get_weightedPoints); return true; }();
WeightedScoreValue* WeightedScore_new(WeightedScoreValue* this__, std::string subject, int64_t points, double weight) {
    auto this_ = this__;
    if (WeightedScoreValue::_vptrMap.empty()) {
        WeightedScoreValue::_vptrMap["prettyPrint"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_prettyPrint);
        WeightedScoreValue::_vptrMap["compareTo2"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_compareTo2);
        WeightedScoreValue::_vptrMap["isLessThan"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_isLessThan);
        WeightedScoreValue::_vptrMap["isGreaterThan"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_isGreaterThan);
        WeightedScoreValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_toString);
        WeightedScoreValue::_vptrMap["get_weightedPoints"] = reinterpret_cast<void*>(&_vptr_wrap_WeightedScore_get_weightedPoints);
    }
    this_->weight = weight;
    Score_new(this_, subject, points);
    return this_;
}

double WeightedScore_get_weightedPoints(WeightedScoreValue* this__) {
    auto this_ = this__;
    return (this_->points * this_->weight);
}

int64_t WeightedScore_compareTo2(WeightedScoreValue* this__, ScoreValue* other) {
    auto this_ = this__;
    if (dart_is<WeightedScoreValue>(other)) {
        return ((dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_weightedPoints"]))(this_))) > static_cast<double>(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(other->getVptrMap()["get_weightedPoints"]))(other))) ? 1LL : ((dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_weightedPoints"]))(this_))) < static_cast<double>(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(other->getVptrMap()["get_weightedPoints"]))(other))) ? -1LL : 0LL));
    }
    return Score_compareTo2(this_, other);
}

std::string WeightedScore_prettyPrint(WeightedScoreValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("[")) + dart_str(this_->subject) + dart_str(std::string(": ")) + dart_str(this_->points) + dart_str(std::string(" pts × ")) + dart_str(this_->weight) + dart_str(std::string(" = ")) + dart_str(([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision(1LL) << dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_weightedPoints"]))(this_)); return _ss.str(); })()) + dart_str(std::string("]"));
}

std::string WeightedScore_toString(WeightedScoreValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("WeightedScore(")) + dart_str(this_->subject) + dart_str(std::string(", ")) + dart_str(this_->points) + dart_str(std::string(", w=")) + dart_str(this_->weight) + dart_str(std::string(")"));
}

TextProcessorValue* TextProcessor_new(TextProcessorValue* this__) {
    auto this_ = this__;
    return this_;
}

std::string TextProcessor_camelToSnake(std::string input) {
    StaticStringBuffer* result = GC::allocateLocal(new StaticStringBuffer());
    int64_t i = 0LL;
    while ((i < static_cast<int64_t>(input.length()))) {
        std::string char_ = std::string(1, input[i]);
        if ((((char_ == dart_str_toUpper(char_)) && !((char_ == dart_str_toLower(char_)))) && (i > 0LL))) {
            result->write(std::string("_"));
        }
        result->write(dart_str_toLower(char_));
        (i = (i + 1LL));
    }
    return result->toString();
}

std::string TextProcessor_snakeToCamel(std::string input) {
    StaticList<std::string>* parts = dart_str_split(input, std::string("_"));
    if (parts->isEmpty()) {
        return input;
    }
    std::string first = (*parts)[0LL];
    std::string rest = /* unsupported collection method: skip on List */ parts->skip(1LL)->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, std::string>*>(new ClosureEnv_8())))->join();
    return dart_str(first) + dart_str(rest);
}

StaticMap<std::string, int64_t>* TextProcessor_wordFrequency(std::string text) {
    StaticList<std::string>* words = dart_str_split(dart_str_replaceAll(dart_str_toLower(text), std::string("[^a-z\\s]"), std::string("")), std::string("\\s+"))->where(GC::allocateLocal(static_cast<TypeFunction1<bool, std::string>*>(new ClosureEnv_9())));
    StaticMap<std::string, int64_t>* freq = StaticMap<std::string, int64_t>::empty();
    StaticIterator<std::string>* sync_for_iterator = words->iterator();
    while (sync_for_iterator->moveNext()) {
        std::string word = sync_for_iterator->current();
        freq->set(word, ((dart_isNull((*freq)[word]) ? 0LL : (*(*freq)[word])) + 1LL));
    }
    return freq;
}

std::string TextProcessor_truncate(std::string text, int64_t maxLength, std::string suffix) {
    if ((static_cast<int64_t>(text.length()) <= maxLength)) {
        return text;
    }
    return dart_str(text.substr(0LL, (maxLength - static_cast<int64_t>(suffix.length())) - 0LL)) + dart_str(suffix);
}

JsonLikeProcessorValue* JsonLikeProcessor_new(JsonLikeProcessorValue* this__) {
    auto this_ = this__;
    return this_;
}

AnyGC* JsonLikeProcessor_deepMerge(StaticMap<std::string, AnyGC*>* base, StaticMap<std::string, AnyGC*>* overlay) {
    StaticMap<std::string, AnyGC*>* result = StaticMap<std::string, AnyGC*>::from(base);
    StaticIterator<std::string>* sync_for_iterator = overlay->keys()->iterator();
    while (sync_for_iterator->moveNext()) {
        std::string key = sync_for_iterator->current();
        if (((result->containsKey(key) && (dynamic_cast<StaticMap<std::string, AnyGC*>*>(_box(*(*result)[key])) != nullptr)) && (dynamic_cast<StaticMap<std::string, AnyGC*>*>(_box(*(*overlay)[key])) != nullptr))) {
            result->set(key, JsonLikeProcessor_deepMerge(static_cast<StaticMap<std::string, AnyGC*>*>(_box(*(*result)[key])), static_cast<StaticMap<std::string, AnyGC*>*>(_box(*(*overlay)[key]))));
        } else {
            result->set(key, _box(*(*overlay)[key]));
        }
    }
    return _box(result);
}

StaticList<std::string>* JsonLikeProcessor_flattenKeys(StaticMap<std::string, AnyGC*>* map, std::string prefix) {
    StaticList<std::string>* keys = GC::allocateLocal(new StaticList<std::string>());
    StaticIterator<StaticMapEntry<std::string, AnyGC*>>* sync_for_iterator = map->entries()->iterator();
    while (sync_for_iterator->moveNext()) {
        StaticMapEntry<std::string, AnyGC*> entry = sync_for_iterator->current();
        std::string fullKey = (prefix.empty() ? entry.key : dart_str(prefix) + dart_str(std::string(".")) + dart_str(entry.key));
        if ((dynamic_cast<StaticMap<std::string, AnyGC*>*>(entry.value) != nullptr)) {
            keys->addAll(JsonLikeProcessor_flattenKeys(static_cast<StaticMap<std::string, AnyGC*>*>(entry.value), fullKey));
        } else {
            keys->add(fullKey);
        }
    }
    return ([&]() { StaticList<std::string>* _let24 = keys; return ([&]() {     _let24->sort();
 return _let24; })(); })();
}

AnyGC* _vptr_wrap_Matrix2D_get(AnyGC* obj__, AnyGC* arg0, AnyGC* arg1) {
    return _box(Matrix2D_get(static_cast<Matrix2DValue*>(obj__), dynAs<int64_t>(arg0), dynAs<int64_t>(arg1)));
}

AnyGC* _vptr_wrap_Matrix2D_add(AnyGC* obj__, AnyGC* arg0) {
    return _box(Matrix2D_add(static_cast<Matrix2DValue*>(obj__), static_cast<Matrix2DValue*>(arg0)));
}

AnyGC* _vptr_wrap_Matrix2D_mul(AnyGC* obj__, AnyGC* arg0) {
    return _box(Matrix2D_mul(static_cast<Matrix2DValue*>(obj__), static_cast<Matrix2DValue*>(arg0)));
}

AnyGC* _vptr_wrap_Matrix2D_get_trace(AnyGC* obj__) {
    return _box(Matrix2D_get_trace(static_cast<Matrix2DValue*>(obj__)));
}

AnyGC* _vptr_wrap_Matrix2D_toString(AnyGC* obj__) {
    return _box(Matrix2D_toString(static_cast<Matrix2DValue*>(obj__)));
}

static bool _Matrix2D_vptr_registered = []{ Matrix2DValue::_vptrMap["get"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_get); Matrix2DValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_add); Matrix2DValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_mul); Matrix2DValue::_vptrMap["get_trace"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_get_trace); Matrix2DValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_toString); return true; }();
Matrix2DValue* Matrix2D_new(Matrix2DValue* this__, StaticList<StaticList<double>*>* _data) {
    auto this_ = this__;
    if (Matrix2DValue::_vptrMap.empty()) {
        Matrix2DValue::_vptrMap["get"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_get);
        Matrix2DValue::_vptrMap["+"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_add);
        Matrix2DValue::_vptrMap["*"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_mul);
        Matrix2DValue::_vptrMap["get_trace"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_get_trace);
        Matrix2DValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Matrix2D_toString);
    }
    this_->_data = _data;
    this_->rows = _data->length();
    this_->cols = (_data->isEmpty() ? 0LL : (*_data)[0LL]->length());
    return this_;
}

Matrix2DValue* Matrix2D_new_zeros(Matrix2DValue* this__, int64_t rows, int64_t cols) {
    auto this_ = this__;
    this_->rows = rows;
    this_->cols = cols;
    this_->_data = ([&]() { auto* _list = GC::allocateLocal(new StaticList<StaticList<double>*>()); auto* _gen = GC::allocateLocal(static_cast<TypeFunction1<StaticList<double>*, int64_t>*>(new ClosureEnv_10(cols))); for (int64_t _i = 0; _i < rows; _i++) _list->add(_gen->call(_i)); return _list; })();
    return this_;
}

Matrix2DValue* Matrix2D_new_identity(Matrix2DValue* this__, int64_t size) {
    auto this_ = this__;
    this_->rows = size;
    this_->cols = size;
    this_->_data = ([&]() { auto* _list = GC::allocateLocal(new StaticList<StaticList<double>*>()); auto* _gen = GC::allocateLocal(static_cast<TypeFunction1<StaticList<double>*, int64_t>*>(new ClosureEnv_11(size))); for (int64_t _i = 0; _i < size; _i++) _list->add(_gen->call(_i)); return _list; })();
    return this_;
}

double Matrix2D_get(Matrix2DValue* this__, int64_t row, int64_t col) {
    auto this_ = this__;
    return (*(*this_->_data)[row])[col];
}

Matrix2DValue* Matrix2D_add(Matrix2DValue* this__, Matrix2DValue* other) {
    auto this_ = this__;
    Matrix2DValue* result = Matrix2D_new_zeros(GC::allocateLocal(new Matrix2DValue()), this_->rows, this_->cols);
    int64_t i = 0LL;
    while ((i < this_->rows)) {
        int64_t j = 0LL;
        while ((j < this_->cols)) {
            (*(*result->_data)[i])[j] = ((*(*this_->_data)[i])[j] + (*(*other->_data)[i])[j]);
            (j = (j + 1LL));
        }
        (i = (i + 1LL));
    }
    return result;
}

Matrix2DValue* Matrix2D_mul(Matrix2DValue* this__, Matrix2DValue* other) {
    auto this_ = this__;
    Matrix2DValue* result = Matrix2D_new_zeros(GC::allocateLocal(new Matrix2DValue()), this_->rows, other->cols);
    int64_t i = 0LL;
    while ((i < this_->rows)) {
        int64_t j = 0LL;
        while ((j < other->cols)) {
            double sum = 0.0;
            int64_t k = 0LL;
            while ((k < this_->cols)) {
                (sum = (sum + ((*(*this_->_data)[i])[k] * (*(*other->_data)[k])[j])));
                (k = (k + 1LL));
            }
            (*(*result->_data)[i])[j] = sum;
            (j = (j + 1LL));
        }
        (i = (i + 1LL));
    }
    return result;
}

double Matrix2D_get_trace(Matrix2DValue* this__) {
    auto this_ = this__;
    double sum = 0.0;
    int64_t minDim = ((this_->rows < this_->cols) ? this_->rows : this_->cols);
    int64_t i = 0LL;
    while ((i < minDim)) {
        (sum = (sum + (*(*this_->_data)[i])[i]));
        (i = (i + 1LL));
    }
    return sum;
}

std::string Matrix2D_toString(Matrix2DValue* this__) {
    auto this_ = this__;
    std::string rowStrings = this_->_data->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, StaticList<double>*>*>(new ClosureEnv_13())))->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, std::string>*>(new ClosureEnv_15())))->join(std::string(", "));
    return dart_str(std::string("Matrix(")) + dart_str(this_->rows) + dart_str(std::string("x")) + dart_str(this_->cols) + dart_str(std::string(": ")) + dart_str(rowStrings) + dart_str(std::string(")"));
}

AnyGC* _vptr_wrap_Entity_get_entityId(AnyGC* obj__) {
    return _box(Entity_get_entityId(static_cast<EntityValue*>(obj__)));
}

static bool _Entity_vptr_registered = []{ EntityValue::_vptrMap["get_entityId"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_get_entityId); return true; }();
EntityValue* Entity_new(EntityValue* this__) {
    auto this_ = this__;
    if (EntityValue::_vptrMap.empty()) {
        EntityValue::_vptrMap["get_entityId"] = reinterpret_cast<void*>(&_vptr_wrap_Entity_get_entityId);
    }
    return this_;
}

std::string Entity_get_entityId(EntityValue* this__) {
    auto this_ = this__;
    return "";
}

AnyGC* _vptr_wrap_Product_get_entityId(AnyGC* obj__) {
    return _box(Product_get_entityId(static_cast<ProductValue*>(obj__)));
}

AnyGC* _vptr_wrap_Product_audit(AnyGC* obj__, AnyGC* arg0) {
    Product_audit(static_cast<ProductValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_Product_get_auditLog(AnyGC* obj__) {
    return _box(Product_get_auditLog(static_cast<ProductValue*>(obj__)));
}

AnyGC* _vptr_wrap_Product_markDirty(AnyGC* obj__) {
    Product_markDirty(static_cast<ProductValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Product_markCached(AnyGC* obj__) {
    Product_markCached(static_cast<ProductValue*>(obj__));
    return nullptr;
}

AnyGC* _vptr_wrap_Product_get_isDirty(AnyGC* obj__) {
    return _box(Product_get_isDirty(static_cast<ProductValue*>(obj__)));
}

AnyGC* _vptr_wrap_Product_get_cacheStatus(AnyGC* obj__) {
    return _box(Product_get_cacheStatus(static_cast<ProductValue*>(obj__)));
}

AnyGC* _vptr_wrap_Product_toString(AnyGC* obj__) {
    return _box(Product_toString(static_cast<ProductValue*>(obj__)));
}

static bool _Product_vptr_registered = []{ ProductValue::_vptrMap["get_entityId"] = reinterpret_cast<void*>(&_vptr_wrap_Product_get_entityId); ProductValue::_vptrMap["audit"] = reinterpret_cast<void*>(&_vptr_wrap_Product_audit); ProductValue::_vptrMap["get_auditLog"] = reinterpret_cast<void*>(&_vptr_wrap_Product_get_auditLog); ProductValue::_vptrMap["markDirty"] = reinterpret_cast<void*>(&_vptr_wrap_Product_markDirty); ProductValue::_vptrMap["markCached"] = reinterpret_cast<void*>(&_vptr_wrap_Product_markCached); ProductValue::_vptrMap["get_isDirty"] = reinterpret_cast<void*>(&_vptr_wrap_Product_get_isDirty); ProductValue::_vptrMap["get_cacheStatus"] = reinterpret_cast<void*>(&_vptr_wrap_Product_get_cacheStatus); ProductValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Product_toString); return true; }();
ProductValue* Product_new(ProductValue* this__, std::string entityId, std::string name, double price) {
    auto this_ = this__;
    if (ProductValue::_vptrMap.empty()) {
        ProductValue::_vptrMap["get_entityId"] = reinterpret_cast<void*>(&_vptr_wrap_Product_get_entityId);
        ProductValue::_vptrMap["audit"] = reinterpret_cast<void*>(&_vptr_wrap_Product_audit);
        ProductValue::_vptrMap["get_auditLog"] = reinterpret_cast<void*>(&_vptr_wrap_Product_get_auditLog);
        ProductValue::_vptrMap["markDirty"] = reinterpret_cast<void*>(&_vptr_wrap_Product_markDirty);
        ProductValue::_vptrMap["markCached"] = reinterpret_cast<void*>(&_vptr_wrap_Product_markCached);
        ProductValue::_vptrMap["get_isDirty"] = reinterpret_cast<void*>(&_vptr_wrap_Product_get_isDirty);
        ProductValue::_vptrMap["get_cacheStatus"] = reinterpret_cast<void*>(&_vptr_wrap_Product_get_cacheStatus);
        ProductValue::_vptrMap["toString"] = reinterpret_cast<void*>(&_vptr_wrap_Product_toString);
    }
    this_->entityId = entityId;
    this_->name = name;
    this_->price = price;
    Entity_new(this_);
    this_->_isDirty = true;
    this_->_auditLog = GC::allocateLocal(new StaticList<std::string>());
    return this_;
}

std::string Product_toString(ProductValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("Product(")) + dart_str(this_->entityId) + dart_str(std::string(", ")) + dart_str(this_->name) + dart_str(std::string(", $")) + dart_str(this_->price) + dart_str(std::string(", ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_cacheStatus"]))(this_))) + dart_str(std::string(", audits=")) + dart_str(this_->_auditLog->length()) + dart_str(std::string(")"));
}

TypeFunction* makeCounter(int64_t start, int64_t step) {
    IntBox* current = new IntBox(start);
    return GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_16(current, step)));
}

TypeFunction* makeAccumulator(int64_t initial) {
    IntBox* total = new IntBox(initial);
    return GC::allocateLocal(static_cast<TypeFunction1<TypeFunction0<std::string>*, int64_t>*>(new ClosureEnv_17(total)));
}

StaticList<TypeFunction*>* makeClosureList(int64_t count) {
    StaticList<TypeFunction*>* closures = GC::allocateLocal(new StaticList<TypeFunction*>());
    int64_t i = 0LL;
    while ((i < count)) {
    closures->add(GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_19(i))));
    (i = (i + 1LL));
}
return closures;
}

template<typename A, typename B, typename C>
TypeFunction1<C, A>* composeFunc(TypeFunction1<C, B>* funcBC, TypeFunction1<B, A>* funcAB) {
    return GC::allocateLocal(static_cast<TypeFunction1<C, A>*>(new ClosureEnv_20<C, B, A>(funcBC, funcAB)));
}

template<typename A, typename B, typename C>
TypeFunction1<TypeFunction1<C, B>*, A>* curry(TypeFunction2<C, A, B>* biFunc) {
    return GC::allocateLocal(static_cast<TypeFunction1<TypeFunction1<C, B>*, A>*>(new ClosureEnv_21<C, A, B>(biFunc)));
}

template<typename T>
T pipe(T value, StaticList<TypeFunction1<T, T>*>* transforms) {
    T result = value;
    StaticIterator<TypeFunction1<T, T>*>* sync_for_iterator = transforms->iterator();
    while (sync_for_iterator->moveNext()) {
        TypeFunction1<T, T>* transform = sync_for_iterator->current();
        (result = transform->call(result));
    }
    return result;
}

template<typename A, typename B>
TypeFunction1<B, A>* memoize(TypeFunction1<B, A>* func) {
    StaticMap<A, B>* cache = StaticMap<A, B>::empty();
    return GC::allocateLocal(static_cast<TypeFunction1<B, A>*>(new ClosureEnv_23<A, B>(cache, func)));
}

std::string classifyNumber(int64_t number) {
    std::string result = std::string("");
    if ((number < 0LL)) {
        (result = std::string("negative"));
        if (((number % 2LL) == 0LL)) {
            (result = (result + std::string("_even")));
        } else {
            (result = (result + std::string("_odd")));
        }
        if ((number < (-100LL))) {
            (result = (result + std::string("_large")));
        } else {
            if ((number < (-10LL))) {
                (result = (result + std::string("_medium")));
            } else {
                (result = (result + std::string("_small")));
            }
        }
    } else {
        if ((number == 0LL)) {
            (result = std::string("zero"));
        } else {
            (result = std::string("positive"));
            bool isPrime = (number > 1LL);
            _L2:
            int64_t i = 2LL;
            while (((i * i) <= number)) {
                if (((number % i) == 0LL)) {
                    (isPrime = false);
                    break;
                }
                (i = (i + 1LL));
            }
            if ((isPrime && (number > 1LL))) {
                (result = (result + std::string("_prime")));
            } else {
                if ((number > 1LL)) {
                    _L3:
                    int64_t i_4 = 2LL;
                    while ((i_4 <= number)) {
                        if (((number % i_4) == 0LL)) {
                            (result = (result + dart_str(std::string("_composite(smallest_factor=")) + dart_str(i_4) + dart_str(std::string(")"))));
                            break;
                        }
                        (i_4 = (i_4 + 1LL));
                    }
                }
            }
        }
    }
    return result;
}

StaticList<int64_t>* parseNumbers(StaticList<std::string>* inputs) {
    StaticList<int64_t>* results = GC::allocateLocal(new StaticList<int64_t>());
    int64_t i = 0LL;
    while ((i < inputs->length())) {
        _L5:
        do {
            try {
                std::string trimmed = dart_str_trim((*inputs)[i]);
                if (trimmed.empty()) {
                    break;
                }
                int64_t value = dart_stoll(trimmed);
                if ((value < 0LL)) {
                    throw DartArgumentError(dart_str(std::string("Negative value at index ")) + dart_str(i) + dart_str(std::string(": ")) + dart_str(value));
                }
                results->add(value);
            } catch (const DartFormatException& _e) {
                results->add((-1LL));
            } catch (const DartArgumentError& e) {
                results->add((-2LL));
            }
        } while (false);
        (i = (i + 1LL));
    }
    return results;
}

Promise<int64_t>* asyncAdd(int64_t a, int64_t b) {
    auto _promise = GC::allocateLocal(new Promise<int64_t>());
    smAwait<AnyGC*>(_box(promiseDelayed(1, []() -> AnyGC* { return nullptr; })));
    _promise->complete(_box((a + b)));
    return _promise;
}

Promise<std::string>* asyncTransform(int64_t value) {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    int64_t doubled = smAwait<int64_t>(asyncAdd(value, value));
    int64_t tripled = smAwait<int64_t>(asyncAdd(doubled, value));
    _promise->complete(_box(dart_str(std::string("value=")) + dart_str(value) + dart_str(std::string(", doubled=")) + dart_str(doubled) + dart_str(std::string(", tripled=")) + dart_str(tripled)));
    return _promise;
}

Promise<StaticList<int64_t>*>* asyncSequence(int64_t count) {
    auto _promise = GC::allocateLocal(new Promise<StaticList<int64_t>*>());
    StaticList<int64_t>* results = GC::allocateLocal(new StaticList<int64_t>());
    int64_t i = 0LL;
    while ((i < count)) {
        int64_t value = smAwait<int64_t>(asyncAdd(i, (i * i)));
        results->add(value);
        (i = (i + 1LL));
    }
    _promise->complete(_box(results));
    return _promise;
}

bool IntMathExtension_get_isPrime(int64_t this_) {
    if ((this_ <= 1LL)) {
        return false;
    }
    if ((this_ <= 3LL)) {
        return true;
    }
    if ((((this_ % 2LL) == 0LL) || ((this_ % 3LL) == 0LL))) {
        return false;
    }
    int64_t i = 5LL;
    while (((i * i) <= this_)) {
        if ((((this_ % i) == 0LL) || ((this_ % (i + 2LL)) == 0LL))) {
            return false;
        }
        (i = (i + 6LL));
    }
    return true;
}

int64_t IntMathExtension_get_factorial(int64_t this_) {
    if ((this_ < 0LL)) {
        throw DartArgumentError(std::string("Factorial not defined for negative numbers"));
    }
    if ((this_ <= 1LL)) {
        return 1LL;
    }
    int64_t result = 1LL;
    int64_t i = 2LL;
    while ((i <= this_)) {
        (result = (result * i));
        (i = (i + 1LL));
    }
    return result;
}

StaticList<int64_t>* IntMathExtension_get_digits(int64_t this_) {
    if ((this_ == 0LL)) {
        return GC::allocateLocal(new StaticList<int64_t>({0LL}));
    }
    StaticList<int64_t>* result = GC::allocateLocal(new StaticList<int64_t>());
    int64_t n = std::abs(this_);
    while ((n > 0LL)) {
        result->insert(0LL, (n % 10LL));
        (n = (n / 10LL));
    }
    return result;
}

template<typename T>
T IterableStats_get_sum(StaticList<T>* this_) {
    return this_->reduce(GC::allocateLocal(static_cast<TypeFunction2<T, T, T>*>(new ClosureEnv_24<T>())));
}

template<typename T>
double IterableStats_get_average(StaticList<T>* this_) {
    return (this_->isEmpty() ? 0.0 : (IterableStats_get_sum<T>(this_) / this_->length()));
}

template<typename T>
T IterableStats_get_max(StaticList<T>* this_) {
    return this_->reduce(GC::allocateLocal(static_cast<TypeFunction2<T, T, T>*>(new ClosureEnv_25<T>())));
}

template<typename T>
T IterableStats_get_min(StaticList<T>* this_) {
    return this_->reduce(GC::allocateLocal(static_cast<TypeFunction2<T, T, T>*>(new ClosureEnv_26<T>())));
}

int main() {
    staticPrint(std::string("=== 高级语法还原测试 ===\n"));
    staticPrint(std::string("--- 1. 嵌套闭包 ---"));
    TypeFunction* counter = makeCounter(5LL, 3LL);
    staticPrint(dart_str(std::string("counter: ")) + dart_str(counter->dynCall()) + dart_str(std::string(", ")) + dart_str(counter->dynCall()) + dart_str(std::string(", ")) + dart_str(counter->dynCall()));
    TypeFunction* acc = makeAccumulator(100LL);
    AnyGC* snap1 = acc->dynCall(_box(10LL));
    AnyGC* snap2 = acc->dynCall(_box(20LL));
    staticPrint(dart_str(std::string("snap1: ")) + dart_str(static_cast<TypeFunction*>(snap1)->dynCall()));
    staticPrint(dart_str(std::string("snap2: ")) + dart_str(static_cast<TypeFunction*>(snap2)->dynCall()));
    StaticList<TypeFunction*>* closures = makeClosureList(4LL);
    StaticIterator<TypeFunction*>* sync_for_iterator = closures->iterator();
    while (sync_for_iterator->moveNext()) {
        TypeFunction* cl = sync_for_iterator->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(cl->dynCall()));
    }
    staticPrint(std::string("\n--- 2. 二叉树 ---"));
    TreeNodeValue<int64_t>* tree = TreeNode_new<int64_t>(GC::allocateLocal(new TreeNodeValue<int64_t>()), 1LL, static_cast<TreeNodeValue<int64_t>*>(TreeNode_new<int64_t>(GC::allocateLocal(new TreeNodeValue<int64_t>()), 2LL, static_cast<TreeNodeValue<int64_t>*>(TreeNode_new<int64_t>(GC::allocateLocal(new TreeNodeValue<int64_t>()), 4LL)), static_cast<TreeNodeValue<int64_t>*>(TreeNode_new<int64_t>(GC::allocateLocal(new TreeNodeValue<int64_t>()), 5LL)))), static_cast<TreeNodeValue<int64_t>*>(TreeNode_new<int64_t>(GC::allocateLocal(new TreeNodeValue<int64_t>()), 3LL, static_cast<TreeNodeValue<int64_t>*>(nullptr), static_cast<TreeNodeValue<int64_t>*>(TreeNode_new<int64_t>(GC::allocateLocal(new TreeNodeValue<int64_t>()), 6LL)))));
    staticPrint(dart_str(std::string("preorder: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(tree->getVptrMap()["preorder"]))(tree)));
    staticPrint(dart_str(std::string("inorder: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(tree->getVptrMap()["inorder"]))(tree)));
    staticPrint(dart_str(std::string("depth: ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(tree->getVptrMap()["get_depth"]))(tree))));
    TreeNodeValue<std::string>* strTree = static_cast<TreeNodeValue<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(tree->getVptrMap()["map"]))(tree, _box(GC::allocateLocal(static_cast<TypeFunction1<std::string, int64_t>*>(new ClosureEnv_27())))));
    staticPrint(dart_str(std::string("mapped preorder: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(strTree->getVptrMap()["preorder"]))(strTree)));
    staticPrint(std::string("\n--- 3. 链表 ---"));
    LinkedNodeValue<int64_t>* list = LinkedNode_new<int64_t>(GC::allocateLocal(new LinkedNodeValue<int64_t>()), 1LL, static_cast<LinkedNodeValue<int64_t>*>(LinkedNode_new<int64_t>(GC::allocateLocal(new LinkedNodeValue<int64_t>()), 2LL, static_cast<LinkedNodeValue<int64_t>*>(LinkedNode_new<int64_t>(GC::allocateLocal(new LinkedNodeValue<int64_t>()), 3LL, static_cast<LinkedNodeValue<int64_t>*>(LinkedNode_new<int64_t>(GC::allocateLocal(new LinkedNodeValue<int64_t>()), 4LL)))))));
    staticPrint(dart_str(std::string("list: ")) + dart_str(list));
    staticPrint(dart_str(std::string("length: ")) + dart_str(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(list->getVptrMap()["get_length"]))(list))));
    LinkedNodeValue<int64_t>* revList = static_cast<LinkedNodeValue<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(list->getVptrMap()["reversed"]))(list));
    staticPrint(dart_str(std::string("reversed: ")) + dart_str(revList));
    staticPrint(std::string("\n--- 6. 多重嵌套控制流 ---"));
    StaticList<int64_t>* testNumbers = GC::allocateLocal(new StaticList<int64_t>({(-150LL), (-42LL), (-3LL), 0LL, 1LL, 7LL, 12LL, 97LL}));
    StaticIterator<int64_t>* sync_for_iterator_6 = testNumbers->iterator();
    while (sync_for_iterator_6->moveNext()) {
        int64_t n = sync_for_iterator_6->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(n) + dart_str(std::string(" → ")) + dart_str(classifyNumber(n)));
    }
    staticPrint(dart_str(std::string("parseNumbers: ")) + dart_str(parseNumbers(GC::allocateLocal(new StaticList<std::string>({std::string("10"), std::string("abc"), std::string(" 42 "), std::string("-5"), std::string(""), std::string("7")})))));
    staticPrint(std::string("\n--- 7. mixin 组合 ---"));
    UserProfileValue* user1 = UserProfile_new(GC::allocateLocal(new UserProfileValue()), std::string("Alice"), std::string("alice@example.com"), 25LL);
    staticPrint(dart_str(std::string("user1: ")) + dart_str(user1));
    staticPrint(dart_str(std::string("serialize: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(user1->getVptrMap()["serialize"]))(user1))));
    staticPrint(dart_str(std::string("validation: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(user1->getVptrMap()["get_validationSummary"]))(user1))));
    UserProfileValue* user2 = UserProfile_new(GC::allocateLocal(new UserProfileValue()), std::string(""), std::string("invalid-email"), (-5LL));
    staticPrint(dart_str(std::string("user2 validation: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(user2->getVptrMap()["get_validationSummary"]))(user2))));
    staticPrint(std::string("\n--- 8. 模板方法模式 ---"));
    StringToIntTransformerValue* strToInt = StringToIntTransformer_new(GC::allocateLocal(new StringToIntTransformerValue()));
    staticPrint(dart_str(std::string("strToInt(\"  42  \"): ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(strToInt->getVptrMap()["transform"]))(strToInt, _box(std::string("  42  ")))));
    IntToStringTransformerValue* intToStr = IntToStringTransformer_new(GC::allocateLocal(new IntToStringTransformerValue()), std::string("NUM:"));
    staticPrint(dart_str(std::string("intToStr(123): ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(intToStr->getVptrMap()["transform"]))(intToStr, _box(123LL))));
    ChainedTransformerValue<std::string, int64_t, std::string>* chained2 = ChainedTransformer_new<std::string, int64_t, std::string>(GC::allocateLocal(new ChainedTransformerValue<std::string, int64_t, std::string>()), static_cast<DataTransformerValue<std::string, int64_t>*>(strToInt), static_cast<DataTransformerValue<int64_t, std::string>*>(intToStr));
    staticPrint(dart_str(std::string("chained(\" 99 \"): ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(chained2->getVptrMap()["transform"]))(chained2, _box(std::string(" 99 ")))));
    staticPrint(std::string("\n--- 9. 单例 Registry ---"));
    RegistryValue* reg1 = Registry_new();
    RegistryValue* reg2 = Registry_new();
    staticPrint(dart_str(std::string("same instance: ")) + dart_str((reg1 == reg2)));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(reg1->getVptrMap()["register_"]))(reg1, _box(std::string("name")), _box(std::string("Dart")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*)>(reg1->getVptrMap()["register_"]))(reg1, _box(std::string("version")), _box(3LL));
    staticPrint(dart_str(std::string("registry: ")) + dart_str(reg1));
    staticPrint(dart_str(std::string("lookup name: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(reg2->getVptrMap()["lookup"]))(reg2, _box(std::string("name")))));
    staticPrint(dart_str(std::string("keys: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(reg1->getVptrMap()["get_keys"]))(reg1)));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(reg1->getVptrMap()["clear"]))(reg1);
    staticPrint(std::string("\n--- 10. 集合操作链 ---"));
    StaticList<StaticMap<std::string, AnyGC*>*>* records = GC::allocateLocal(new StaticList<StaticMap<std::string, AnyGC*>*>({([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("Alice")))); _m->set(std::string("score"), GC::allocateLocal(new IntBox(95LL))); return _m; })(), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("Bob")))); _m->set(std::string("score"), GC::allocateLocal(new IntBox(72LL))); return _m; })(), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("Carol")))); _m->set(std::string("score"), GC::allocateLocal(new IntBox(88LL))); return _m; })(), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("Dave")))); _m->set(std::string("score"), GC::allocateLocal(new IntBox(45LL))); return _m; })(), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("Eve")))); _m->set(std::string("score"), GC::allocateLocal(new IntBox(91LL))); return _m; })(), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("Frank")))); _m->set(std::string("score"), GC::allocateLocal(new IntBox(63LL))); return _m; })()}));
    StaticList<StaticMap<std::string, AnyGC*>*>* processed = DataProcessor_processRecords(records);
    StaticIterator<StaticMap<std::string, AnyGC*>*>* sync_for_iterator_7 = processed->iterator();
    while (sync_for_iterator_7->moveNext()) {
        StaticMap<std::string, AnyGC*>* r = sync_for_iterator_7->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(_box(*(*r)[std::string("name")])) + dart_str(std::string(": ")) + dart_str(_box(*(*r)[std::string("score")])) + dart_str(std::string(" (")) + dart_str(_box(*(*r)[std::string("grade")])) + dart_str(std::string(", passed=")) + dart_str(_box(*(*r)[std::string("passed")])) + dart_str(std::string(")")));
    }
    StaticMap<std::string, double>* averages = DataProcessor_averageByGrade(processed);
    staticPrint(dart_str(std::string("averages: ")) + dart_str(averages));
    staticPrint(std::string("\n--- 11. late 变量 ---"));
    ExpensiveComputationValue* comp = ExpensiveComputation_new(GC::allocateLocal(new ExpensiveComputationValue()), 42LL);
    staticPrint(dart_str(std::string("comp: ")) + dart_str(comp));
    staticPrint(dart_str(std::string("computedValue: ")) + dart_str(comp->computedValue));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(comp->getVptrMap()["initialize"]))(comp, _box(std::string("test description")));
    staticPrint(dart_str(std::string("description: ")) + dart_str(comp->description));
    staticPrint(std::string("\n--- 12. 局部函数 + 递归 ---"));
    staticPrint(dart_str(std::string("fibonacci(10): ")) + dart_str(MathUtils_fibonacci(10LL)));
    staticPrint(dart_str(std::string("fibonacci(20): ")) + dart_str(MathUtils_fibonacci(20LL)));
    staticPrint(dart_str(std::string("primeFactors(360): ")) + dart_str(MathUtils_primeFactors(360LL)));
    staticPrint(dart_str(std::string("gcd(48, 18): ")) + dart_str(MathUtils_gcd(48LL, 18LL)));
    staticPrint(dart_str(std::string("lcm(12, 18): ")) + dart_str(MathUtils_lcm(12LL, 18LL)));
    staticPrint(std::string("\n--- 13. 多重 implements ---"));
    StaticList<ScoreValue*>* scores = GC::allocateLocal(new StaticList<ScoreValue*>({Score_new(GC::allocateLocal(new ScoreValue()), std::string("Math"), 90LL), Score_new(GC::allocateLocal(new ScoreValue()), std::string("English"), 75LL), WeightedScore_new(GC::allocateLocal(new WeightedScoreValue()), std::string("Physics"), 85LL, 1.5), WeightedScore_new(GC::allocateLocal(new WeightedScoreValue()), std::string("Art"), 95LL, 0.5)}));
    StaticIterator<ScoreValue*>* sync_for_iterator_8 = scores->iterator();
    while (sync_for_iterator_8->moveNext()) {
        ScoreValue* s = sync_for_iterator_8->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(s->getVptrMap()["prettyPrint"]))(s))));
    }
    WeightedScoreValue* ws1 = static_cast<WeightedScoreValue*>((*scores)[2LL]);
    WeightedScoreValue* ws2 = static_cast<WeightedScoreValue*>((*scores)[3LL]);
    staticPrint(dart_str(std::string("physics > art (weighted): ")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(ws1->getVptrMap()["isGreaterThan"]))(ws1, _box(ws2)))));
    staticPrint(std::string("\n--- 14. 字符串操作 ---"));
    staticPrint(dart_str(std::string("camelToSnake(\"helloWorldFoo\"): ")) + dart_str(TextProcessor_camelToSnake(std::string("helloWorldFoo"))));
    staticPrint(dart_str(std::string("snakeToCamel(\"hello_world_foo\"): ")) + dart_str(TextProcessor_snakeToCamel(std::string("hello_world_foo"))));
    StaticMap<std::string, int64_t>* freq = TextProcessor_wordFrequency(std::string("the quick brown fox jumps over the lazy fox"));
    staticPrint(dart_str(std::string("word frequency: ")) + dart_str(freq));
    staticPrint(dart_str(std::string("truncate: ")) + dart_str(TextProcessor_truncate(std::string("Hello, World! This is a long string."), 20LL, std::string("..."))));
    staticPrint(std::string("\n--- 15. async 链 ---"));
    std::string asyncResult = smAwait<std::string>(asyncTransform(5LL));
    staticPrint(dart_str(std::string("asyncTransform(5): ")) + dart_str(asyncResult));
    StaticList<int64_t>* asyncSeq = smAwait<StaticList<int64_t>*>(asyncSequence(5LL));
    staticPrint(dart_str(std::string("asyncSequence(5): ")) + dart_str(asyncSeq));
    staticPrint(std::string("\n--- 16. 增强枚举 ---"));
    StaticIterator<Season*>* sync_for_iterator_9 = GC::allocateLocal(new StaticList<Season*>({Season::spring, Season::summer, Season::autumn, Season::winter}))->iterator();
    while (sync_for_iterator_9->moveNext()) {
        Season* s_10 = sync_for_iterator_9->current();
        staticPrint(dart_str(std::string("  ")) + dart_str(s_10) + dart_str(std::string(" → ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(s_10->getVptrMap()["get_displayName"]))(s_10))) + dart_str(std::string(", next=")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(static_cast<Season*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(s_10->getVptrMap()["get_next"]))(s_10))->getVptrMap()["get_displayName"]))(static_cast<Season*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(s_10->getVptrMap()["get_next"]))(s_10))))) + dart_str(std::string(", warm=")) + dart_str(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(s_10->getVptrMap()["get_isWarm"]))(s_10))));
    }
    staticPrint(std::string("\n--- 17. 嵌套 Map 操作 ---"));
    StaticMap<std::string, AnyGC*>* base = ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("a"), GC::allocateLocal(new IntBox(1LL))); _m->set(std::string("b"), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("x"), GC::allocateLocal(new IntBox(10LL))); _m->set(std::string("y"), GC::allocateLocal(new IntBox(20LL))); return _m; })()); _m->set(std::string("c"), GC::allocateLocal(new IntBox(3LL))); return _m; })();
    StaticMap<std::string, AnyGC*>* overlay = ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("b"), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("y"), GC::allocateLocal(new IntBox(99LL))); _m->set(std::string("z"), GC::allocateLocal(new IntBox(30LL))); return _m; })()); _m->set(std::string("d"), GC::allocateLocal(new IntBox(4LL))); return _m; })();
    AnyGC* merged = JsonLikeProcessor_deepMerge(base, overlay);
    staticPrint(dart_str(std::string("deepMerge: ")) + dart_str(merged));
    StaticMap<std::string, AnyGC*>* nested = ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("user"), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("name"), GC::allocateLocal(new StringBox(std::string("Alice")))); _m->set(std::string("address"), ([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("city"), GC::allocateLocal(new StringBox(std::string("NYC")))); _m->set(std::string("zip"), GC::allocateLocal(new StringBox(std::string("10001")))); return _m; })()); return _m; })()); _m->set(std::string("role"), GC::allocateLocal(new StringBox(std::string("admin")))); return _m; })();
    staticPrint(dart_str(std::string("flattenKeys: ")) + dart_str(JsonLikeProcessor_flattenKeys(nested, std::string(""))));
    staticPrint(std::string("\n--- 18. 扩展方法 ---"));
    staticPrint(dart_str(std::string("7.isPrime: ")) + dart_str(IntMathExtension_get_isPrime(7LL)));
    staticPrint(dart_str(std::string("12.isPrime: ")) + dart_str(IntMathExtension_get_isPrime(12LL)));
    staticPrint(dart_str(std::string("5.factorial: ")) + dart_str(IntMathExtension_get_factorial(5LL)));
    staticPrint(dart_str(std::string("12345.digits: ")) + dart_str(IntMathExtension_get_digits(12345LL)));
    StaticList<int64_t>* nums = GC::allocateLocal(new StaticList<int64_t>({10LL, 20LL, 30LL, 40LL, 50LL}));
    staticPrint(dart_str(std::string("sum: ")) + dart_str(IterableStats_get_sum<int64_t>(nums)) + dart_str(std::string(", avg: ")) + dart_str(IterableStats_get_average<int64_t>(nums)) + dart_str(std::string(", max: ")) + dart_str(IterableStats_get_max<int64_t>(nums)) + dart_str(std::string(", min: ")) + dart_str(IterableStats_get_min<int64_t>(nums)));
    staticPrint(std::string("\n--- 19. Matrix2D ---"));
    Matrix2DValue* m1 = Matrix2D_new(GC::allocateLocal(new Matrix2DValue()), static_cast<StaticList<StaticList<double>*>*>(GC::allocateLocal(new StaticList<StaticList<double>*>({GC::allocateLocal(new StaticList<double>({1.0, 2.0})), GC::allocateLocal(new StaticList<double>({3.0, 4.0}))}))));
    Matrix2DValue* m2 = Matrix2D_new_identity(GC::allocateLocal(new Matrix2DValue()), 2LL);
    staticPrint(dart_str(std::string("m1: ")) + dart_str(m1));
    staticPrint(dart_str(std::string("m2 (identity): ")) + dart_str(m2));
    staticPrint(dart_str(std::string("m1 + m2: ")) + dart_str(reinterpret_cast<Matrix2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(m1->getVptrMap()["+"]))(m1, _box(m2)))));
    staticPrint(dart_str(std::string("m1 * m2: ")) + dart_str(reinterpret_cast<Matrix2DValue*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(m1->getVptrMap()["*"]))(m1, _box(m2)))));
    staticPrint(dart_str(std::string("m1 trace: ")) + dart_str(dynAs<double>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(m1->getVptrMap()["get_trace"]))(m1))));
    Matrix2DValue* m3 = Matrix2D_new_zeros(GC::allocateLocal(new Matrix2DValue()), 2LL, 3LL);
    staticPrint(dart_str(std::string("zeros(2,3): ")) + dart_str(m3));
    staticPrint(std::string("\n--- 20. 综合 mixin + 抽象类 ---"));
    ProductValue* product = Product_new(GC::allocateLocal(new ProductValue()), std::string("P001"), std::string("Widget"), 9.99);
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(product->getVptrMap()["audit"]))(product, _box(std::string("created")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(product->getVptrMap()["audit"]))(product, _box(std::string("priced")));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(product->getVptrMap()["markCached"]))(product);
    staticPrint(dart_str(std::string("product: ")) + dart_str(product));
    staticPrint(dart_str(std::string("auditLog: ")) + dart_str((reinterpret_cast<AnyGC*(*)(AnyGC*)>(product->getVptrMap()["get_auditLog"]))(product)));
    (reinterpret_cast<AnyGC*(*)(AnyGC*)>(product->getVptrMap()["markDirty"]))(product);
    staticPrint(dart_str(std::string("after markDirty: ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(product->getVptrMap()["get_cacheStatus"]))(product))));
    staticPrint(std::string("\n=== 所有高级语法测试通过 ✅ ==="));
    return 0;
}

AnyGC* UserProfile_serialize(UserProfileValue* this__) {
    auto this_ = this__;
    StaticMap<std::string, AnyGC*>* map = static_cast<StaticMap<std::string, AnyGC*>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["toMap"]))(this_));
    std::string entries = map->entries()->map(GC::allocateLocal(static_cast<TypeFunction1<std::string, StaticMapEntry<std::string, AnyGC*>>*>(new ClosureEnv_28())))->join(std::string(", "));
    return _box(dart_str(std::string("{")) + dart_str(entries) + dart_str(std::string("}")));
}

AnyGC* UserProfile_get_isValid(UserProfileValue* this__) {
    auto this_ = this__;
    return _box(static_cast<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["validate"]))(this_))->isEmpty());
}

AnyGC* UserProfile_get_validationSummary(UserProfileValue* this__) {
    auto this_ = this__;
    StaticList<std::string>* errors = static_cast<StaticList<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["validate"]))(this_));
    if (errors->isEmpty()) {
        return _box(std::string("valid"));
    }
    return _box(dart_str(std::string("invalid: ")) + dart_str(errors->join(std::string("; "))));
}

AnyGC* StringToIntTransformer_transform(StringToIntTransformerValue* this__, std::string input) {
    auto this_ = this__;
    return _box(DataTransformer_transform<std::string, int64_t>(static_cast<DataTransformerValue<std::string, int64_t>*>(this_), input));
}

AnyGC* StringToIntTransformer_postProcess(StringToIntTransformerValue* this__, int64_t output) {
    auto this_ = this__;
    return _box(DataTransformer_postProcess<std::string, int64_t>(static_cast<DataTransformerValue<std::string, int64_t>*>(this_), output));
}

AnyGC* IntToStringTransformer_transform(IntToStringTransformerValue* this__, int64_t input) {
    auto this_ = this__;
    return _box(DataTransformer_transform<int64_t, std::string>(static_cast<DataTransformerValue<int64_t, std::string>*>(this_), input));
}

AnyGC* IntToStringTransformer_preValidate(IntToStringTransformerValue* this__, int64_t input) {
    auto this_ = this__;
    return _box(DataTransformer_preValidate<int64_t, std::string>(static_cast<DataTransformerValue<int64_t, std::string>*>(this_), input));
}

template<typename A, typename B, typename C>
AnyGC* ChainedTransformer_transform(ChainedTransformerValue<A, B, C>* this__, A input) {
    auto this_ = this__;
    return _box(DataTransformer_transform<A, C>(static_cast<DataTransformerValue<A, C>*>(this_), input));
}

template<typename A, typename B, typename C>
AnyGC* ChainedTransformer_preValidate(ChainedTransformerValue<A, B, C>* this__, A input) {
    auto this_ = this__;
    return _box(DataTransformer_preValidate<A, C>(static_cast<DataTransformerValue<A, C>*>(this_), input));
}

template<typename A, typename B, typename C>
AnyGC* ChainedTransformer_postProcess(ChainedTransformerValue<A, B, C>* this__, C output) {
    auto this_ = this__;
    return _box(DataTransformer_postProcess<A, C>(static_cast<DataTransformerValue<A, C>*>(this_), output));
}

AnyGC* WeightedScore_isLessThan(WeightedScoreValue* this__, ScoreValue* other) {
    auto this_ = this__;
    return _box(Score_isLessThan(this_, other));
}

AnyGC* WeightedScore_isGreaterThan(WeightedScoreValue* this__, ScoreValue* other) {
    auto this_ = this__;
    return _box(Score_isGreaterThan(this_, other));
}

std::string Product_get_entityId(ProductValue* this__) {
    auto this_ = this__;
    return Entity_get_entityId(this_);
}

void Product_audit(ProductValue* this__, std::string action) {
    auto this_ = this__;
    this_->_auditLog->add(dart_str(std::string("[")) + dart_str(this_->entityId) + dart_str(std::string("] ")) + dart_str(action));
}

AnyGC* Product_get_auditLog(ProductValue* this__) {
    auto this_ = this__;
    return _box(unmodifiable<std::string>(this_->_auditLog));
}

void Product_markDirty(ProductValue* this__) {
    auto this_ = this__;
    (this_->_isDirty = true);
    return;
}

void Product_markCached(ProductValue* this__) {
    auto this_ = this__;
    (this_->_isDirty = false);
    (this_->_cachedAt = StaticDateTime::now());
}

AnyGC* Product_get_isDirty(ProductValue* this__) {
    auto this_ = this__;
    return _box(this_->_isDirty);
}

AnyGC* Product_get_cacheStatus(ProductValue* this__) {
    auto this_ = this__;
    return _box((this_->_isDirty ? std::string("dirty") : std::string("cached")));
}


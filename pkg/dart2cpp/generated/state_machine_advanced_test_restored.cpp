#include "dart2cpp_lowered.h"

struct FibStateMachineValue;
struct Level3SMValue;
struct Level2SMValue;
struct Level1SMValue;
struct ConditionalAwaitSMValue;
struct FindFirstSMValue;
struct TryCatchSMValue;
struct FutureAnySMValue;
struct TimeoutSMValue;
struct AsyncMapSMValue;
struct AsyncReduceSMValue;
struct ClosureEnv_process_0Value;
struct ProcessWithClosureSMValue;
struct AsyncGeneratorSMValue;
struct ComplexBusinessSMValue;
FibStateMachineValue* FibStateMachine_new(FibStateMachineValue* this__, int64_t n);
bool FibStateMachine_step(FibStateMachineValue* this__);
Level3SMValue* Level3SM_new(Level3SMValue* this__);
bool Level3SM_step(Level3SMValue* this__);
Level2SMValue* Level2SM_new(Level2SMValue* this__);
bool Level2SM_step(Level2SMValue* this__);
Level1SMValue* Level1SM_new(Level1SMValue* this__);
bool Level1SM_step(Level1SMValue* this__);
ConditionalAwaitSMValue* ConditionalAwaitSM_new(ConditionalAwaitSMValue* this__, bool flag);
bool ConditionalAwaitSM_step(ConditionalAwaitSMValue* this__);
FindFirstSMValue* FindFirstSM_new(FindFirstSMValue* this__, StaticList<int64_t>* items);
bool FindFirstSM_step(FindFirstSMValue* this__);
TryCatchSMValue* TryCatchSM_new(TryCatchSMValue* this__);
bool TryCatchSM_step(TryCatchSMValue* this__);
FutureAnySMValue* FutureAnySM_new(FutureAnySMValue* this__);
bool FutureAnySM_step(FutureAnySMValue* this__);
TimeoutSMValue* TimeoutSM_new(TimeoutSMValue* this__, int64_t taskDelay, int64_t timeoutDelay);
bool TimeoutSM_step(TimeoutSMValue* this__);
AsyncMapSMValue* AsyncMapSM_new(AsyncMapSMValue* this__, StaticList<int64_t>* items);
bool AsyncMapSM_step(AsyncMapSMValue* this__);
AsyncReduceSMValue* AsyncReduceSM_new(AsyncReduceSMValue* this__);
bool AsyncReduceSM_step(AsyncReduceSMValue* this__);
ClosureEnv_process_0Value* ClosureEnv_process_0_new(ClosureEnv_process_0Value* this__, int64_t factor);
int64_t ClosureEnv_process_0_call(ClosureEnv_process_0Value* this__, int64_t x);
ProcessWithClosureSMValue* ProcessWithClosureSM_new(ProcessWithClosureSMValue* this__, StaticList<int64_t>* items);
bool ProcessWithClosureSM_step(ProcessWithClosureSMValue* this__);
AsyncGeneratorSMValue* AsyncGeneratorSM_new(AsyncGeneratorSMValue* this__, int64_t max);
bool AsyncGeneratorSM_step(AsyncGeneratorSMValue* this__);
ComplexBusinessSMValue* ComplexBusinessSM_new(ComplexBusinessSMValue* this__, int64_t depth);
bool ComplexBusinessSM_step(ComplexBusinessSMValue* this__);
void testRecursiveAsync();
void testExceptionPropagation();
void testConditionalAwait();
void testLoopBreakAwait();
void testTryCatchAwait();
void testFutureAny();
void testTimeout();
void testAsyncPipeline();
void testClosureCaptureAwait();
void testAsyncGenerator();
void testComplexBusiness();
int main();

struct FibStateMachineValue : AsyncStateMachine<int64_t> {
    int64_t n{0};
    int64_t _a{0};
    Promise<int64_t>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<int64_t>::gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return FibStateMachine_step(this);
    }
};

std::unordered_map<std::string, void*> FibStateMachineValue::_vptrMap;

struct Level3SMValue : AsyncStateMachine<int64_t> {

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<int64_t>::gcMark(flag);
    }

    bool step() override {
        return Level3SM_step(this);
    }
};

std::unordered_map<std::string, void*> Level3SMValue::_vptrMap;

struct Level2SMValue : AsyncStateMachine<int64_t> {
    Promise<int64_t>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<int64_t>::gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return Level2SM_step(this);
    }
};

std::unordered_map<std::string, void*> Level2SMValue::_vptrMap;

struct Level1SMValue : AsyncStateMachine<std::string> {
    Promise<int64_t>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return Level1SM_step(this);
    }
};

std::unordered_map<std::string, void*> Level1SMValue::_vptrMap;

struct ConditionalAwaitSMValue : AsyncStateMachine<std::string> {
    bool flag{false};
    Promise<std::string>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return ConditionalAwaitSM_step(this);
    }
};

std::unordered_map<std::string, void*> ConditionalAwaitSMValue::_vptrMap;

struct ClosureEnv_0 : TypeFunction0<std::string> {
    ClosureEnv_0() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
                    return std::string("branch_true");
    }
};

struct ClosureEnv_1 : TypeFunction0<std::string> {
    ClosureEnv_1() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
    return std::string("branch_false");
    }
};

struct FindFirstSMValue : AsyncStateMachine<int64_t> {
    StaticList<int64_t>* items{nullptr};
    int64_t _index{0};
    Promise<int64_t>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<int64_t>::gcMark(flag);
        if (items) items->gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return FindFirstSM_step(this);
    }
};

std::unordered_map<std::string, void*> FindFirstSMValue::_vptrMap;

struct ClosureEnv_2 : TypeFunction0<int64_t> {
    FindFirstSMValue* this_;
    ClosureEnv_2(FindFirstSMValue* this_) : this_(this_) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
                return ((*this_->items)[this_->_index] * 3LL);
    }
};

struct TryCatchSMValue : AsyncStateMachine<std::string> {
    std::string _log{""};
    Promise<AnyGC*>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return TryCatchSM_step(this);
    }
};

std::unordered_map<std::string, void*> TryCatchSMValue::_vptrMap;

struct ClosureEnv_3 : TypeFunction0<std::string> {
    ClosureEnv_3() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_3*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
                throw DartException(std::string("boom"));
                return "";
        return ""; /* unreachable */
    }
};

struct ClosureEnv_4 : TypeFunction0<std::string> {
    ClosureEnv_4() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_4*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
        return std::string("recovered");
    }
};

struct FutureAnySMValue : AsyncStateMachine<std::string> {
    StaticList<Promise<std::string>*>* _futures{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_futures) _futures->gcMark(flag);
    }

    bool step() override {
        return FutureAnySM_step(this);
    }
};

std::unordered_map<std::string, void*> FutureAnySMValue::_vptrMap;

struct ClosureEnv_5 : TypeFunction0<std::string> {
    ClosureEnv_5() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_5*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
                return std::string("slow");
    }
};

struct ClosureEnv_6 : TypeFunction0<std::string> {
    ClosureEnv_6() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_6*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
    return std::string("fast");
    }
};

struct ClosureEnv_7 : TypeFunction0<std::string> {
    ClosureEnv_7() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_7*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
    return std::string("slowest");
    }
};

struct TimeoutSMValue : AsyncStateMachine<std::string> {
    int64_t taskDelay{0};
    int64_t timeoutDelay{0};
    Promise<std::string>* _taskFuture{nullptr};
    Promise<std::string>* _timeoutFuture{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_taskFuture) _taskFuture->gcMark(flag);
        if (_timeoutFuture) _timeoutFuture->gcMark(flag);
    }

    bool step() override {
        return TimeoutSM_step(this);
    }
};

std::unordered_map<std::string, void*> TimeoutSMValue::_vptrMap;

struct ClosureEnv_8 : TypeFunction0<std::string> {
    ClosureEnv_8() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_8*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
                return std::string("done");
    }
};

struct ClosureEnv_9 : TypeFunction0<std::string> {
    ClosureEnv_9() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_9*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
    return std::string("TIMEOUT");
    }
};

struct AsyncMapSMValue : AsyncStateMachine<StaticList<std::string>*> {
    StaticList<int64_t>* items{nullptr};
    StaticList<std::string>* _results{nullptr};
    int64_t _index{0};
    Promise<std::string>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<StaticList<std::string>*>::gcMark(flag);
        if (items) items->gcMark(flag);
        if (_results) _results->gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return AsyncMapSM_step(this);
    }
};

std::unordered_map<std::string, void*> AsyncMapSMValue::_vptrMap;

struct ClosureEnv_10 : TypeFunction0<std::string> {
    int64_t item;
    ClosureEnv_10(int64_t item) : item(std::move(item)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_10*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
                return dart_str(std::string("item_")) + dart_str((item * 2LL));
    }
};

struct AsyncReduceSMValue : AsyncStateMachine<std::string> {
    Promise<StaticList<std::string>*>* _mapFuture{nullptr};
    Promise<std::string>* _reducePending{nullptr};
    StaticList<std::string>* _items{nullptr};
    int64_t _index{0};
    std::string _acc{""};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_mapFuture) _mapFuture->gcMark(flag);
        if (_reducePending) _reducePending->gcMark(flag);
        if (_items) _items->gcMark(flag);
    }

    bool step() override {
        return AsyncReduceSM_step(this);
    }
};

std::unordered_map<std::string, void*> AsyncReduceSMValue::_vptrMap;

struct ClosureEnv_11 : TypeFunction0<std::string> {
    AsyncReduceSMValue* this_;
    ClosureEnv_11(AsyncReduceSMValue* this_) : this_(this_) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_11*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
                std::string sep = (this_->_acc.empty() ? std::string("") : std::string("+"));
                return dart_str(this_->_acc) + dart_str(sep) + dart_str((*this_->_items)[this_->_index]);
    }
};

struct ClosureEnv_process_0Value : VPtr {
    int64_t factor{0};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

std::unordered_map<std::string, void*> ClosureEnv_process_0Value::_vptrMap;

struct ProcessWithClosureSMValue : AsyncStateMachine<StaticList<int64_t>*> {
    ClosureEnv_process_0Value* _env{nullptr};
    StaticList<int64_t>* items{nullptr};
    StaticList<int64_t>* _results{nullptr};
    int64_t _index{0};
    Promise<int64_t>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<StaticList<int64_t>*>::gcMark(flag);
        if (_env) _env->gcMark(flag);
        if (items) items->gcMark(flag);
        if (_results) _results->gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return ProcessWithClosureSM_step(this);
    }
};

std::unordered_map<std::string, void*> ProcessWithClosureSMValue::_vptrMap;

struct ClosureEnv_12 : TypeFunction0<int64_t> {
    ProcessWithClosureSMValue* this_;
    int64_t item;
    ClosureEnv_12(ProcessWithClosureSMValue* this_, int64_t item) : this_(this_), item(std::move(item)) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_12*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
                return dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->_env->getVptrMap()["call"]))(this_->_env, _box(item)));
    }
};

struct AsyncGeneratorSMValue : AsyncStateMachine<StaticList<int64_t>*> {
    int64_t max{0};
    int64_t _i{0};
    StaticList<int64_t>* _yielded{nullptr};
    Promise<int64_t>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<StaticList<int64_t>*>::gcMark(flag);
        if (_yielded) _yielded->gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return AsyncGeneratorSM_step(this);
    }
};

std::unordered_map<std::string, void*> AsyncGeneratorSMValue::_vptrMap;

struct ClosureEnv_13 : TypeFunction0<int64_t> {
    AsyncGeneratorSMValue* this_;
    ClosureEnv_13(AsyncGeneratorSMValue* this_) : this_(this_) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_13*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
                return (this_->_i * this_->_i);
    }
};

struct ComplexBusinessSMValue : AsyncStateMachine<StaticMap<std::string, AnyGC*>*> {
    int64_t depth{0};
    Promise<StaticMap<std::string, AnyGC*>*>* _pending{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<StaticMap<std::string, AnyGC*>*>::gcMark(flag);
        if (_pending) _pending->gcMark(flag);
    }

    bool step() override {
        return ComplexBusinessSM_step(this);
    }
};

std::unordered_map<std::string, void*> ComplexBusinessSMValue::_vptrMap;


AnyGC* _vptr_wrap_FibStateMachine_step(AnyGC* obj__) {
    return _box(FibStateMachine_step(static_cast<FibStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_FibStateMachine_start(AnyGC* obj__) {
    return _box(static_cast<FibStateMachineValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_FibStateMachine_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<FibStateMachineValue*>(obj__)->completeWith(dynAs<int64_t>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_FibStateMachine_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<FibStateMachineValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _FibStateMachine_vptr_registered = []{ FibStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_FibStateMachine_step); FibStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_FibStateMachine_start); FibStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_FibStateMachine_completeWith); FibStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_FibStateMachine_completeWithError); return true; }();
FibStateMachineValue* FibStateMachine_new(FibStateMachineValue* this__, int64_t n) {
    auto this_ = this__;
    if (FibStateMachineValue::_vptrMap.empty()) {
        FibStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_FibStateMachine_step);
    }
    this_->n = n;
    this_->_a = 0LL;
    return this_;
}

bool FibStateMachine_step(FibStateMachineValue* this__) {
    auto this_ = this__;
    _L0:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                if ((this_->n <= 1LL)) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->n));
                    return true;
                }
                (this_->_pending = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(FibStateMachine_new(GC::allocateLocal(new FibStateMachineValue()), (this_->n - 1LL))->getVptrMap()["start"]))(FibStateMachine_new(GC::allocateLocal(new FibStateMachineValue()), (this_->n - 1LL)))));
                (this_->smState = 1LL);
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if (this_->_pending->isPending()) {
                    return false;
                }
                (this_->_a = this_->_pending->typedResult());
                (this_->_pending = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(FibStateMachine_new(GC::allocateLocal(new FibStateMachineValue()), (this_->n - 2LL))->getVptrMap()["start"]))(FibStateMachine_new(GC::allocateLocal(new FibStateMachineValue()), (this_->n - 2LL)))));
                (this_->smState = 2LL);
                return false;
                break;
            }
            _sw_case_2:
            case 2:
            {
                if (this_->_pending->isPending()) {
                    return false;
                }
                (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box((this_->_a + this_->_pending->typedResult())));
                return true;
                break;
            }
            _sw_case_3:
            default: {
                return true;
                break;
            }
        }
    } while (false);
}

AnyGC* _vptr_wrap_Level3SM_step(AnyGC* obj__) {
    return _box(Level3SM_step(static_cast<Level3SMValue*>(obj__)));
}

AnyGC* _vptr_wrap_Level3SM_start(AnyGC* obj__) {
    return _box(static_cast<Level3SMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_Level3SM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<Level3SMValue*>(obj__)->completeWith(dynAs<int64_t>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_Level3SM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<Level3SMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _Level3SM_vptr_registered = []{ Level3SMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_Level3SM_step); Level3SMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_Level3SM_start); Level3SMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_Level3SM_completeWith); Level3SMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_Level3SM_completeWithError); return true; }();
Level3SMValue* Level3SM_new(Level3SMValue* this__) {
    auto this_ = this__;
    if (Level3SMValue::_vptrMap.empty()) {
        Level3SMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_Level3SM_step);
    }
    return this_;
}

bool Level3SM_step(Level3SMValue* this__) {
    auto this_ = this__;
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWithError"]))(this_, _box(DartException(std::string("deep error"))));
    return true;
}

AnyGC* _vptr_wrap_Level2SM_step(AnyGC* obj__) {
    return _box(Level2SM_step(static_cast<Level2SMValue*>(obj__)));
}

AnyGC* _vptr_wrap_Level2SM_start(AnyGC* obj__) {
    return _box(static_cast<Level2SMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_Level2SM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<Level2SMValue*>(obj__)->completeWith(dynAs<int64_t>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_Level2SM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<Level2SMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _Level2SM_vptr_registered = []{ Level2SMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_Level2SM_step); Level2SMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_Level2SM_start); Level2SMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_Level2SM_completeWith); Level2SMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_Level2SM_completeWithError); return true; }();
Level2SMValue* Level2SM_new(Level2SMValue* this__) {
    auto this_ = this__;
    if (Level2SMValue::_vptrMap.empty()) {
        Level2SMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_Level2SM_step);
    }
    return this_;
}

bool Level2SM_step(Level2SMValue* this__) {
    auto this_ = this__;
    _L1:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                (this_->_pending = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(Level3SM_new(GC::allocateLocal(new Level3SMValue()))->getVptrMap()["start"]))(Level3SM_new(GC::allocateLocal(new Level3SMValue())))));
                (this_->smState = 1LL);
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if (this_->_pending->isPending()) {
                    return false;
                }
                if (this_->_pending->isError()) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWithError"]))(this_, _box(this_->_pending->error));
                    return true;
                }
                (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_pending->typedResult()));
                return true;
                break;
            }
            _sw_case_2:
            default: {
                return true;
                break;
            }
        }
    } while (false);
}

AnyGC* _vptr_wrap_Level1SM_step(AnyGC* obj__) {
    return _box(Level1SM_step(static_cast<Level1SMValue*>(obj__)));
}

AnyGC* _vptr_wrap_Level1SM_start(AnyGC* obj__) {
    return _box(static_cast<Level1SMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_Level1SM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<Level1SMValue*>(obj__)->completeWith(dynAs<std::string>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_Level1SM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<Level1SMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _Level1SM_vptr_registered = []{ Level1SMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_Level1SM_step); Level1SMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_Level1SM_start); Level1SMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_Level1SM_completeWith); Level1SMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_Level1SM_completeWithError); return true; }();
Level1SMValue* Level1SM_new(Level1SMValue* this__) {
    auto this_ = this__;
    if (Level1SMValue::_vptrMap.empty()) {
        Level1SMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_Level1SM_step);
    }
    return this_;
}

bool Level1SM_step(Level1SMValue* this__) {
    auto this_ = this__;
    _L2:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                (this_->_pending = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(Level2SM_new(GC::allocateLocal(new Level2SMValue()))->getVptrMap()["start"]))(Level2SM_new(GC::allocateLocal(new Level2SMValue())))));
                (this_->smState = 1LL);
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if (this_->_pending->isPending()) {
                    return false;
                }
                if (this_->_pending->isError()) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(dart_str(std::string("caught: ")) + dart_str(this_->_pending->error)));
                    return true;
                }
                (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(std::string("ok")));
                return true;
                break;
            }
            _sw_case_2:
            default: {
                return true;
                break;
            }
        }
    } while (false);
}

AnyGC* _vptr_wrap_ConditionalAwaitSM_step(AnyGC* obj__) {
    return _box(ConditionalAwaitSM_step(static_cast<ConditionalAwaitSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_ConditionalAwaitSM_start(AnyGC* obj__) {
    return _box(static_cast<ConditionalAwaitSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_ConditionalAwaitSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<ConditionalAwaitSMValue*>(obj__)->completeWith(dynAs<std::string>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_ConditionalAwaitSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<ConditionalAwaitSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _ConditionalAwaitSM_vptr_registered = []{ ConditionalAwaitSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ConditionalAwaitSM_step); ConditionalAwaitSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ConditionalAwaitSM_start); ConditionalAwaitSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ConditionalAwaitSM_completeWith); ConditionalAwaitSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ConditionalAwaitSM_completeWithError); return true; }();
ConditionalAwaitSMValue* ConditionalAwaitSM_new(ConditionalAwaitSMValue* this__, bool flag) {
    auto this_ = this__;
    if (ConditionalAwaitSMValue::_vptrMap.empty()) {
        ConditionalAwaitSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ConditionalAwaitSM_step);
    }
    this_->flag = flag;
    return this_;
}

bool ConditionalAwaitSM_step(ConditionalAwaitSMValue* this__) {
    auto this_ = this__;
    _L3:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                if (this_->flag) {
    (this_->_pending = delayed<std::string>(2LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_0()))));
    (this_->smState = 1LL);
} else {
    (this_->_pending = delayed<std::string>(1LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_1()))));
    (this_->smState = 2LL);
}
return false;
break;
}
_sw_case_1:
case 1:
{
if (this_->_pending->isPending()) {
    return false;
}
(reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_pending->typedResult()));
return true;
break;
}
_sw_case_2:
case 2:
{
if (this_->_pending->isPending()) {
    return false;
}
(reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_pending->typedResult()));
return true;
break;
}
_sw_case_3:
default: {
return true;
break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_FindFirstSM_step(AnyGC* obj__) {
    return _box(FindFirstSM_step(static_cast<FindFirstSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_FindFirstSM_start(AnyGC* obj__) {
    return _box(static_cast<FindFirstSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_FindFirstSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<FindFirstSMValue*>(obj__)->completeWith(dynAs<int64_t>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_FindFirstSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<FindFirstSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _FindFirstSM_vptr_registered = []{ FindFirstSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_FindFirstSM_step); FindFirstSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_FindFirstSM_start); FindFirstSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_FindFirstSM_completeWith); FindFirstSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_FindFirstSM_completeWithError); return true; }();
FindFirstSMValue* FindFirstSM_new(FindFirstSMValue* this__, StaticList<int64_t>* items) {
    auto this_ = this__;
    if (FindFirstSMValue::_vptrMap.empty()) {
        FindFirstSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_FindFirstSM_step);
    }
    this_->items = items;
    return this_;
}

bool FindFirstSM_step(FindFirstSMValue* this__) {
    auto this_ = this__;
    _L4:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                if ((this_->_index >= this_->items->length())) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box((-1LL)));
                    return true;
                }
    (this_->_pending = delayed<int64_t>(1LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_2(this_)))));
    (this_->smState = 1LL);
    return false;
    break;
}
_sw_case_1:
case 1:
{
    if (this_->_pending->isPending()) {
        return false;
    }
    int64_t result = this_->_pending->typedResult();
    if ((result > 10LL)) {
        (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(result));
        return true;
    }
    (this_->_index = (this_->_index + 1LL));
    (this_->smState = 0LL);
    return false;
    break;
}
_sw_case_2:
default: {
    return true;
    break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_TryCatchSM_step(AnyGC* obj__) {
    return _box(TryCatchSM_step(static_cast<TryCatchSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_TryCatchSM_start(AnyGC* obj__) {
    return _box(static_cast<TryCatchSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_TryCatchSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<TryCatchSMValue*>(obj__)->completeWith(dynAs<std::string>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_TryCatchSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<TryCatchSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _TryCatchSM_vptr_registered = []{ TryCatchSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_TryCatchSM_step); TryCatchSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_TryCatchSM_start); TryCatchSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_TryCatchSM_completeWith); TryCatchSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_TryCatchSM_completeWithError); return true; }();
TryCatchSMValue* TryCatchSM_new(TryCatchSMValue* this__) {
    auto this_ = this__;
    if (TryCatchSMValue::_vptrMap.empty()) {
        TryCatchSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_TryCatchSM_step);
    }
    this_->_log = std::string("");
    return this_;
}

bool TryCatchSM_step(TryCatchSMValue* this__) {
    auto this_ = this__;
    _L5:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                (this_->_log = (this_->_log + std::string("try;")));
    (this_->_pending = reinterpret_cast<Promise<AnyGC*>*>(delayed<std::string>(1LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_3())))));
    (this_->smState = 1LL);
    return false;
    break;
}
_sw_case_1:
case 1:
{
    if (this_->_pending->isPending()) {
        return false;
    }
    if (this_->_pending->isError()) {
        (this_->_log = (this_->_log + dart_str(std::string("catch:")) + dart_str(this_->_pending->error) + dart_str(std::string(";"))));
    (this_->_pending = reinterpret_cast<Promise<AnyGC*>*>(delayed<std::string>(1LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_4())))));
    (this_->smState = 2LL);
    return false;
}
(reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_log));
return true;
break;
}
_sw_case_2:
case 2:
{
if (this_->_pending->isPending()) {
    return false;
}
(this_->_log = (this_->_log + dynAs<std::string>(this_->_pending->typedResult())));
(reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_log));
return true;
break;
}
_sw_case_3:
default: {
return true;
break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_FutureAnySM_step(AnyGC* obj__) {
    return _box(FutureAnySM_step(static_cast<FutureAnySMValue*>(obj__)));
}

AnyGC* _vptr_wrap_FutureAnySM_start(AnyGC* obj__) {
    return _box(static_cast<FutureAnySMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_FutureAnySM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<FutureAnySMValue*>(obj__)->completeWith(dynAs<std::string>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_FutureAnySM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<FutureAnySMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _FutureAnySM_vptr_registered = []{ FutureAnySMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_FutureAnySM_step); FutureAnySMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_FutureAnySM_start); FutureAnySMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_FutureAnySM_completeWith); FutureAnySMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_FutureAnySM_completeWithError); return true; }();
FutureAnySMValue* FutureAnySM_new(FutureAnySMValue* this__) {
    auto this_ = this__;
    if (FutureAnySMValue::_vptrMap.empty()) {
        FutureAnySMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_FutureAnySM_step);
    }
    return this_;
}

bool FutureAnySM_step(FutureAnySMValue* this__) {
    auto this_ = this__;
    _L6:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
    (this_->_futures = GC::allocateLocal(new StaticList<Promise<std::string>*>({delayed<std::string>(5LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_5()))), delayed<std::string>(2LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_6()))), delayed<std::string>(8LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_7())))})));
    (this_->smState = 1LL);
    return false;
    break;
}
_sw_case_1:
case 1:
{
    StaticIterator<Promise<std::string>*>* sync_for_iterator = this_->_futures->iterator();
    while (sync_for_iterator->moveNext()) {
        Promise<std::string>* f = sync_for_iterator->current();
        if (f->isCompleted()) {
            (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(f->typedResult()));
            return true;
        }
    }
    return false;
    break;
}
_sw_case_2:
default: {
    return true;
    break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_TimeoutSM_step(AnyGC* obj__) {
    return _box(TimeoutSM_step(static_cast<TimeoutSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_TimeoutSM_start(AnyGC* obj__) {
    return _box(static_cast<TimeoutSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_TimeoutSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<TimeoutSMValue*>(obj__)->completeWith(dynAs<std::string>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_TimeoutSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<TimeoutSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _TimeoutSM_vptr_registered = []{ TimeoutSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_TimeoutSM_step); TimeoutSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_TimeoutSM_start); TimeoutSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_TimeoutSM_completeWith); TimeoutSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_TimeoutSM_completeWithError); return true; }();
TimeoutSMValue* TimeoutSM_new(TimeoutSMValue* this__, int64_t taskDelay, int64_t timeoutDelay) {
    auto this_ = this__;
    if (TimeoutSMValue::_vptrMap.empty()) {
        TimeoutSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_TimeoutSM_step);
    }
    this_->taskDelay = taskDelay;
    this_->timeoutDelay = timeoutDelay;
    return this_;
}

bool TimeoutSM_step(TimeoutSMValue* this__) {
    auto this_ = this__;
    _L7:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
    (this_->_taskFuture = delayed<std::string>(this_->taskDelay, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_8()))));
    (this_->_timeoutFuture = delayed<std::string>(this_->timeoutDelay, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_9()))));
    (this_->smState = 1LL);
    return false;
    break;
}
_sw_case_1:
case 1:
{
    if (this_->_taskFuture->isCompleted()) {
        (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_taskFuture->typedResult()));
        return true;
    }
    if (this_->_timeoutFuture->isCompleted()) {
        (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_timeoutFuture->typedResult()));
        return true;
    }
    return false;
    break;
}
_sw_case_2:
default: {
    return true;
    break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_AsyncMapSM_step(AnyGC* obj__) {
    return _box(AsyncMapSM_step(static_cast<AsyncMapSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_AsyncMapSM_start(AnyGC* obj__) {
    return _box(static_cast<AsyncMapSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_AsyncMapSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<AsyncMapSMValue*>(obj__)->completeWith(static_cast<StaticList<std::string>*>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_AsyncMapSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<AsyncMapSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _AsyncMapSM_vptr_registered = []{ AsyncMapSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncMapSM_step); AsyncMapSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncMapSM_start); AsyncMapSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncMapSM_completeWith); AsyncMapSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncMapSM_completeWithError); return true; }();
AsyncMapSMValue* AsyncMapSM_new(AsyncMapSMValue* this__, StaticList<int64_t>* items) {
    auto this_ = this__;
    if (AsyncMapSMValue::_vptrMap.empty()) {
        AsyncMapSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncMapSM_step);
    }
    this_->items = items;
    this_->_results = GC::allocateLocal(new StaticList<std::string>());
    return this_;
}

bool AsyncMapSM_step(AsyncMapSMValue* this__) {
    auto this_ = this__;
    _L8:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                if ((this_->_index >= this_->items->length())) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_results));
                    return true;
                }
                int64_t item = (*this_->items)[this_->_index];
    (this_->_pending = delayed<std::string>(1LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_10(item)))));
    (this_->smState = 1LL);
    return false;
    break;
}
_sw_case_1:
case 1:
{
    if (this_->_pending->isPending()) {
        return false;
    }
    this_->_results->add(this_->_pending->typedResult());
    (this_->_index = (this_->_index + 1LL));
    (this_->smState = 0LL);
    return false;
    break;
}
_sw_case_2:
default: {
    return true;
    break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_AsyncReduceSM_step(AnyGC* obj__) {
    return _box(AsyncReduceSM_step(static_cast<AsyncReduceSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_AsyncReduceSM_start(AnyGC* obj__) {
    return _box(static_cast<AsyncReduceSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_AsyncReduceSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<AsyncReduceSMValue*>(obj__)->completeWith(dynAs<std::string>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_AsyncReduceSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<AsyncReduceSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _AsyncReduceSM_vptr_registered = []{ AsyncReduceSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncReduceSM_step); AsyncReduceSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncReduceSM_start); AsyncReduceSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncReduceSM_completeWith); AsyncReduceSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncReduceSM_completeWithError); return true; }();
AsyncReduceSMValue* AsyncReduceSM_new(AsyncReduceSMValue* this__) {
    auto this_ = this__;
    if (AsyncReduceSMValue::_vptrMap.empty()) {
        AsyncReduceSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncReduceSM_step);
    }
    this_->_items = GC::allocateLocal(new StaticList<std::string>());
    this_->_acc = std::string("");
    return this_;
}

bool AsyncReduceSM_step(AsyncReduceSMValue* this__) {
    auto this_ = this__;
    _L9:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                (this_->_mapFuture = static_cast<Promise<StaticList<std::string>*>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(AsyncMapSM_new(GC::allocateLocal(new AsyncMapSMValue()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL}))))->getVptrMap()["start"]))(AsyncMapSM_new(GC::allocateLocal(new AsyncMapSMValue()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL})))))));
                (this_->smState = 1LL);
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if (this_->_mapFuture->isPending()) {
                    return false;
                }
                (this_->_items = this_->_mapFuture->typedResult());
                (this_->smState = 2LL);
                return false;
                break;
            }
            _sw_case_2:
            case 2:
            {
                if ((this_->_index >= this_->_items->length())) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_acc));
                    return true;
                }
    (this_->_reducePending = delayed<std::string>(1LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_11(this_)))));
    (this_->smState = 3LL);
    return false;
    break;
}
_sw_case_3:
case 3:
{
    if (this_->_reducePending->isPending()) {
        return false;
    }
    (this_->_acc = this_->_reducePending->typedResult());
    (this_->_index = (this_->_index + 1LL));
    (this_->smState = 2LL);
    return false;
    break;
}
_sw_case_4:
default: {
    return true;
    break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_ClosureEnv_process_0_call(AnyGC* obj__, AnyGC* arg0) {
    return _box(ClosureEnv_process_0_call(static_cast<ClosureEnv_process_0Value*>(obj__), dynAs<int64_t>(arg0)));
}

static bool _ClosureEnv_process_0_vptr_registered = []{ ClosureEnv_process_0Value::_vptrMap["call"] = reinterpret_cast<void*>(&_vptr_wrap_ClosureEnv_process_0_call); return true; }();
ClosureEnv_process_0Value* ClosureEnv_process_0_new(ClosureEnv_process_0Value* this__, int64_t factor) {
    auto this_ = this__;
    if (ClosureEnv_process_0Value::_vptrMap.empty()) {
        ClosureEnv_process_0Value::_vptrMap["call"] = reinterpret_cast<void*>(&_vptr_wrap_ClosureEnv_process_0_call);
    }
    this_->factor = factor;
    return this_;
}

int64_t ClosureEnv_process_0_call(ClosureEnv_process_0Value* this__, int64_t x) {
    auto this_ = this__;
    return (x * this_->factor);
}

AnyGC* _vptr_wrap_ProcessWithClosureSM_step(AnyGC* obj__) {
    return _box(ProcessWithClosureSM_step(static_cast<ProcessWithClosureSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_ProcessWithClosureSM_start(AnyGC* obj__) {
    return _box(static_cast<ProcessWithClosureSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_ProcessWithClosureSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<ProcessWithClosureSMValue*>(obj__)->completeWith(static_cast<StaticList<int64_t>*>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_ProcessWithClosureSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<ProcessWithClosureSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _ProcessWithClosureSM_vptr_registered = []{ ProcessWithClosureSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ProcessWithClosureSM_step); ProcessWithClosureSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ProcessWithClosureSM_start); ProcessWithClosureSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ProcessWithClosureSM_completeWith); ProcessWithClosureSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ProcessWithClosureSM_completeWithError); return true; }();
ProcessWithClosureSMValue* ProcessWithClosureSM_new(ProcessWithClosureSMValue* this__, StaticList<int64_t>* items) {
    auto this_ = this__;
    if (ProcessWithClosureSMValue::_vptrMap.empty()) {
        ProcessWithClosureSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ProcessWithClosureSM_step);
    }
    this_->items = items;
    this_->_results = GC::allocateLocal(new StaticList<int64_t>());
    return this_;
}

bool ProcessWithClosureSM_step(ProcessWithClosureSMValue* this__) {
    auto this_ = this__;
    _L10:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                (this_->_env = ClosureEnv_process_0_new(GC::allocateLocal(new ClosureEnv_process_0Value()), 3LL));
                (this_->smState = 1LL);
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if ((this_->_index >= this_->items->length())) {
                    (this_->smState = 3LL);
                    return false;
                }
                int64_t item = (*this_->items)[this_->_index];
    (this_->_pending = delayed<int64_t>(1LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_12(this_, item)))));
    (this_->smState = 2LL);
    return false;
    break;
}
_sw_case_2:
case 2:
{
    if (this_->_pending->isPending()) {
        return false;
    }
    this_->_results->add(this_->_pending->typedResult());
    (this_->_index = (this_->_index + 1LL));
    (this_->smState = 1LL);
    return false;
    break;
}
_sw_case_3:
case 3:
{
    (this_->_env->factor = 5LL);
    this_->_results->add(dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->_env->getVptrMap()["call"]))(this_->_env, _box(100LL))));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_results));
    return true;
    break;
}
_sw_case_4:
default: {
    return true;
    break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_AsyncGeneratorSM_step(AnyGC* obj__) {
    return _box(AsyncGeneratorSM_step(static_cast<AsyncGeneratorSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_AsyncGeneratorSM_start(AnyGC* obj__) {
    return _box(static_cast<AsyncGeneratorSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_AsyncGeneratorSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<AsyncGeneratorSMValue*>(obj__)->completeWith(static_cast<StaticList<int64_t>*>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_AsyncGeneratorSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<AsyncGeneratorSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _AsyncGeneratorSM_vptr_registered = []{ AsyncGeneratorSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncGeneratorSM_step); AsyncGeneratorSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncGeneratorSM_start); AsyncGeneratorSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncGeneratorSM_completeWith); AsyncGeneratorSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncGeneratorSM_completeWithError); return true; }();
AsyncGeneratorSMValue* AsyncGeneratorSM_new(AsyncGeneratorSMValue* this__, int64_t max) {
    auto this_ = this__;
    if (AsyncGeneratorSMValue::_vptrMap.empty()) {
        AsyncGeneratorSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_AsyncGeneratorSM_step);
    }
    this_->max = max;
    this_->_i = 0LL;
    this_->_yielded = GC::allocateLocal(new StaticList<int64_t>());
    return this_;
}

bool AsyncGeneratorSM_step(AsyncGeneratorSMValue* this__) {
    auto this_ = this__;
    _L11:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                if ((this_->_i >= this_->max)) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(this_->_yielded));
                    return true;
                }
    (this_->_pending = delayed<int64_t>(1LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_13(this_)))));
    (this_->smState = 1LL);
    return false;
    break;
}
_sw_case_1:
case 1:
{
    if (this_->_pending->isPending()) {
        return false;
    }
    this_->_yielded->add(this_->_pending->typedResult());
    (this_->_i = (this_->_i + 1LL));
    (this_->smState = 0LL);
    return false;
    break;
}
_sw_case_2:
default: {
    return true;
    break;
}
}
} while (false);
}

AnyGC* _vptr_wrap_ComplexBusinessSM_step(AnyGC* obj__) {
    return _box(ComplexBusinessSM_step(static_cast<ComplexBusinessSMValue*>(obj__)));
}

AnyGC* _vptr_wrap_ComplexBusinessSM_start(AnyGC* obj__) {
    return _box(static_cast<ComplexBusinessSMValue*>(obj__)->start());
}
AnyGC* _vptr_wrap_ComplexBusinessSM_completeWith(AnyGC* obj__, AnyGC* arg0) {
    static_cast<ComplexBusinessSMValue*>(obj__)->completeWith(static_cast<StaticMap<std::string, AnyGC*>*>(arg0));
    return nullptr;
}
AnyGC* _vptr_wrap_ComplexBusinessSM_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    static_cast<ComplexBusinessSMValue*>(obj__)->completeWithError(arg0);
    return nullptr;
}
static bool _ComplexBusinessSM_vptr_registered = []{ ComplexBusinessSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ComplexBusinessSM_step); ComplexBusinessSMValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ComplexBusinessSM_start); ComplexBusinessSMValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ComplexBusinessSM_completeWith); ComplexBusinessSMValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ComplexBusinessSM_completeWithError); return true; }();
ComplexBusinessSMValue* ComplexBusinessSM_new(ComplexBusinessSMValue* this__, int64_t depth) {
    auto this_ = this__;
    if (ComplexBusinessSMValue::_vptrMap.empty()) {
        ComplexBusinessSMValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ComplexBusinessSM_step);
    }
    this_->depth = depth;
    return this_;
}

bool ComplexBusinessSM_step(ComplexBusinessSMValue* this__) {
    auto this_ = this__;
    _L12:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                if ((this_->depth <= 0LL)) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWithError"]))(this_, _box(DartException(std::string("max depth"))));
                    return true;
                }
                (this_->_pending = static_cast<Promise<StaticMap<std::string, AnyGC*>*>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ComplexBusinessSM_new(GC::allocateLocal(new ComplexBusinessSMValue()), (this_->depth - 1LL))->getVptrMap()["start"]))(ComplexBusinessSM_new(GC::allocateLocal(new ComplexBusinessSMValue()), (this_->depth - 1LL)))));
                (this_->smState = 1LL);
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if (this_->_pending->isPending()) {
                    return false;
                }
                if (this_->_pending->isError()) {
                    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("depth"), GC::allocateLocal(new IntBox(this_->depth))); _m->set(std::string("error"), GC::allocateLocal(new StringBox(dart_str(this_->_pending->error)))); return _m; })()));
                    return true;
                }
                (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(([&]() { auto* _m = StaticMap<std::string, AnyGC*>::empty(); _m->set(std::string("depth"), GC::allocateLocal(new IntBox(this_->depth))); _m->set(std::string("child"), this_->_pending->typedResult()); return _m; })()));
                return true;
                break;
            }
            _sw_case_2:
            default: {
                return true;
                break;
            }
        }
    } while (false);
}

void testRecursiveAsync() {
    staticPrint(std::string("\n--- 1. 递归异步 fibonacci ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(FibStateMachine_new(GC::allocateLocal(new FibStateMachineValue()), 7LL)->getVptrMap()["start"]))(FibStateMachine_new(GC::allocateLocal(new FibStateMachineValue()), 7LL))));
    assert((dynAs<int64_t>(r) == 13LL));
    staticPrint(dart_str(std::string("  ✓ asyncFib(7) = ")) + dart_str(r));
}

void testExceptionPropagation() {
    staticPrint(std::string("\n--- 2. 异常传播链 (3层) ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(Level1SM_new(GC::allocateLocal(new Level1SMValue()))->getVptrMap()["start"]))(Level1SM_new(GC::allocateLocal(new Level1SMValue())))));
    assert(dynAs<bool>((reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["contains"]))(static_cast<VPtr*>(r), _box(std::string("deep error")))));
    staticPrint(dart_str(std::string("  ✓ level1() caught 3-level exception: \"")) + dart_str(r) + dart_str(std::string("\"")));
}

void testConditionalAwait() {
    staticPrint(std::string("\n--- 3. 条件分支中的 await ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r1 = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ConditionalAwaitSM_new(GC::allocateLocal(new ConditionalAwaitSMValue()), true)->getVptrMap()["start"]))(ConditionalAwaitSM_new(GC::allocateLocal(new ConditionalAwaitSMValue()), true))));
    assert((dynAs<std::string>(r1) == std::string("branch_true")));
    GlobalScheduler::instance().reset();
    AnyGC* r2 = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ConditionalAwaitSM_new(GC::allocateLocal(new ConditionalAwaitSMValue()), false)->getVptrMap()["start"]))(ConditionalAwaitSM_new(GC::allocateLocal(new ConditionalAwaitSMValue()), false))));
    assert((dynAs<std::string>(r2) == std::string("branch_false")));
    staticPrint(dart_str(std::string("  ✓ conditionalAwait(true) = \"")) + dart_str(r1) + dart_str(std::string("\"")));
    staticPrint(dart_str(std::string("  ✓ conditionalAwait(false) = \"")) + dart_str(r2) + dart_str(std::string("\"")));
}

void testLoopBreakAwait() {
    staticPrint(std::string("\n--- 4. 循环 + 提前 break 中的 await ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(FindFirstSM_new(GC::allocateLocal(new FindFirstSMValue()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL, 5LL}))))->getVptrMap()["start"]))(FindFirstSM_new(GC::allocateLocal(new FindFirstSMValue()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL, 5LL})))))));
    assert((dynAs<int64_t>(r) == 12LL));
    staticPrint(dart_str(std::string("  ✓ findFirst([1,2,3,4,5]) = ")) + dart_str(r) + dart_str(std::string(" (4*3=12 > 10)")));
}

void testTryCatchAwait() {
    staticPrint(std::string("\n--- 5. try-catch 中的 await ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(TryCatchSM_new(GC::allocateLocal(new TryCatchSMValue()))->getVptrMap()["start"]))(TryCatchSM_new(GC::allocateLocal(new TryCatchSMValue())))));
    assert((dynAs<std::string>(r) == std::string("try;catch:boom;recovered")));
    staticPrint(dart_str(std::string("  ✓ tryCatchAwait() = \"")) + dart_str(r) + dart_str(std::string("\"")));
}

void testFutureAny() {
    staticPrint(std::string("\n--- 6. Future.any 模拟（竞争取最先完成） ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(FutureAnySM_new(GC::allocateLocal(new FutureAnySMValue()))->getVptrMap()["start"]))(FutureAnySM_new(GC::allocateLocal(new FutureAnySMValue())))));
    assert((dynAs<std::string>(r) == std::string("fast")));
    staticPrint(dart_str(std::string("  ✓ Future.any([slow(5), fast(2), slowest(8)]) = \"")) + dart_str(r) + dart_str(std::string("\"")));
}

void testTimeout() {
    staticPrint(std::string("\n--- 7. 超时控制模拟 ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r1 = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(TimeoutSM_new(GC::allocateLocal(new TimeoutSMValue()), 2LL, 5LL)->getVptrMap()["start"]))(TimeoutSM_new(GC::allocateLocal(new TimeoutSMValue()), 2LL, 5LL))));
    assert((dynAs<std::string>(r1) == std::string("done")));
    staticPrint(dart_str(std::string("  ✓ task(2) timeout(5) = \"")) + dart_str(r1) + dart_str(std::string("\" (task wins)")));
    GlobalScheduler::instance().reset();
    AnyGC* r2 = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(TimeoutSM_new(GC::allocateLocal(new TimeoutSMValue()), 10LL, 3LL)->getVptrMap()["start"]))(TimeoutSM_new(GC::allocateLocal(new TimeoutSMValue()), 10LL, 3LL))));
    assert((dynAs<std::string>(r2) == std::string("TIMEOUT")));
    staticPrint(dart_str(std::string("  ✓ task(10) timeout(3) = \"")) + dart_str(r2) + dart_str(std::string("\" (timeout wins)")));
}

void testAsyncPipeline() {
    staticPrint(std::string("\n--- 8. 链式异步变换管道 (map → reduce) ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(AsyncReduceSM_new(GC::allocateLocal(new AsyncReduceSMValue()))->getVptrMap()["start"]))(AsyncReduceSM_new(GC::allocateLocal(new AsyncReduceSMValue())))));
    assert((dynAs<std::string>(r) == std::string("item_2+item_4+item_6+item_8")));
    staticPrint(dart_str(std::string("  ✓ asyncMap([1,2,3,4]).reduce(+) = \"")) + dart_str(r) + dart_str(std::string("\"")));
}

void testClosureCaptureAwait() {
    staticPrint(std::string("\n--- 9. 闭包捕获 + await (ClosureEnv 模式) ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ProcessWithClosureSM_new(GC::allocateLocal(new ProcessWithClosureSMValue()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL}))))->getVptrMap()["start"]))(ProcessWithClosureSM_new(GC::allocateLocal(new ProcessWithClosureSMValue()), static_cast<StaticList<int64_t>*>(GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL})))))));
    assert((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["get_length"]))(static_cast<VPtr*>(r))) == 4LL));
    assert(((((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(0LL))) == 3LL) && (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(1LL))) == 6LL)) && (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(2LL))) == 9LL)) && (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(3LL))) == 500LL)));
    staticPrint(dart_str(std::string("  ✓ processWithClosure([1,2,3]) = ")) + dart_str(r));
    staticPrint(std::string("    (factor=3→[3,6,9], mutate factor=5→100*5=500)"));
}

void testAsyncGenerator() {
    staticPrint(std::string("\n--- 10. async* 生成器模拟 ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(AsyncGeneratorSM_new(GC::allocateLocal(new AsyncGeneratorSMValue()), 5LL)->getVptrMap()["start"]))(AsyncGeneratorSM_new(GC::allocateLocal(new AsyncGeneratorSMValue()), 5LL))));
    assert((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["get_length"]))(static_cast<VPtr*>(r))) == 5LL));
    assert((((((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(0LL))) == 0LL) && (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(1LL))) == 1LL)) && (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(2LL))) == 4LL)) && (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(3LL))) == 9LL)) && (dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(4LL))) == 16LL)));
    staticPrint(dart_str(std::string("  ✓ countUp(5) yields ")) + dart_str(r));
}

void testComplexBusiness() {
    staticPrint(std::string("\n--- 11. 复合场景：递归+异常+条件 ---"));
    GlobalScheduler::instance().reset();
    AnyGC* r = smAwait<AnyGC*>(_box((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ComplexBusinessSM_new(GC::allocateLocal(new ComplexBusinessSMValue()), 3LL)->getVptrMap()["start"]))(ComplexBusinessSM_new(GC::allocateLocal(new ComplexBusinessSMValue()), 3LL))));
    assert((dynAs<int64_t>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(std::string("depth")))) == 3LL));
    StaticMap<std::string, AnyGC*>* child2 = static_cast<StaticMap<std::string, AnyGC*>*>((reinterpret_cast<AnyGC*(*)(AnyGC*,AnyGC*)>(static_cast<VPtr*>(r)->getVptrMap()["[]"]))(static_cast<VPtr*>(r), _box(std::string("child"))));
    assert((dynAs<int64_t>(_box(*(*child2)[std::string("depth")])) == 2LL));
    StaticMap<std::string, AnyGC*>* child1 = static_cast<StaticMap<std::string, AnyGC*>*>(_box(*(*child2)[std::string("child")]));
    assert((dynAs<int64_t>(_box(*(*child1)[std::string("depth")])) == 1LL));
    assert((dynAs<std::string>(_box(*(*child1)[std::string("error")])).find(std::string("max depth")) != std::string::npos));
    staticPrint(std::string("  ✓ complexBusiness(3) = nested map with error at bottom"));
    staticPrint(std::string("    depth=3 → child(depth=2) → child(depth=1, error:\"max depth\")"));
}

int main() {
    staticPrint(std::string("═══════════════════════════════════════════"));
    staticPrint(std::string(" 复杂协程场景验证测试"));
    staticPrint(std::string("═══════════════════════════════════════════"));
    testRecursiveAsync();
    testExceptionPropagation();
    testConditionalAwait();
    testLoopBreakAwait();
    testTryCatchAwait();
    testFutureAny();
    testTimeout();
    testAsyncPipeline();
    testClosureCaptureAwait();
    testAsyncGenerator();
    testComplexBusiness();
    staticPrint(std::string("\n═══════════════════════════════════════════"));
    staticPrint(std::string(" ✅ 全部 11 个复杂场景测试通过！"));
    staticPrint(std::string("═══════════════════════════════════════════"));
    return 0;
}


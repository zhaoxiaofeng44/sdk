#include "dart2cpp_lowered.h"

template<typename T> struct PromiseValue;
struct GlobalSchedulerValue;
struct _DelayedTaskValue;
template<typename T> struct AsyncStateMachineValue;
struct AddAsyncStateMachineValue;
struct InnerAsyncStateMachineValue;
struct OuterAsyncStateMachineValue;
struct ErrorStateMachineValue;
struct ParallelAwaitStateMachineValue;
struct ComputeStepStateMachineValue;
struct PipelineStateMachineValue;
struct CompleterState;
template<typename T> Promise<T>* Promise_new(Promise<T>* this__);
template<typename T> CompleterState Promise_get_state(Promise<T>* this__);
template<typename T> bool Promise_get_isCompleted(Promise<T>* this__);
template<typename T> bool Promise_get_isError(Promise<T>* this__);
template<typename T> bool Promise_get_isPending(Promise<T>* this__);
template<typename T> AnyGC* Promise_get_error(Promise<T>* this__);
template<typename T> T Promise_get_result(Promise<T>* this__);
template<typename T> void Promise_complete(Promise<T>* this__, T value);
template<typename T> void Promise_completeError(Promise<T>* this__, AnyGC* error);
template<typename T> Promise<T>* Promise_value(T val);
template<typename T> Promise<T>* Promise_delayed(int64_t delayTicks, TypeFunction0<T>* computation);
template<typename T, typename R> Promise<R>* Promise_then(Promise<T>* this__, TypeFunction1<R, T>* onValue);
GlobalScheduler* GlobalScheduler_new__(GlobalScheduler* this__);
void GlobalScheduler_registerActivePromise(GlobalScheduler* this__, Promise<AnyGC*>* promise);
void GlobalScheduler_registerDelayedTask(GlobalScheduler* this__, int64_t delayTicks, TypeFunction0<void>* callback);
void GlobalScheduler_tick(GlobalScheduler* this__);
bool GlobalScheduler_get_hasActiveTasks(GlobalScheduler* this__);
void GlobalScheduler_reset(GlobalScheduler* this__);
_DelayedTaskValue* _DelayedTask_new(_DelayedTaskValue* this__, int64_t targetTick, TypeFunction0<void>* callback);
template<typename T> AsyncStateMachine<T>* AsyncStateMachine_new(AsyncStateMachine<T>* this__);
template<typename T> bool AsyncStateMachine_step(AsyncStateMachine<T>* this__);
template<typename T> void AsyncStateMachine_completeWith(AsyncStateMachine<T>* this__, T value);
template<typename T> void AsyncStateMachine_completeWithError(AsyncStateMachine<T>* this__, AnyGC* error);
template<typename T> Promise<T>* AsyncStateMachine_start(AsyncStateMachine<T>* this__);
AddAsyncStateMachineValue* AddAsyncStateMachine_new(AddAsyncStateMachineValue* this__, int64_t a, int64_t b);
std::string AddAsyncStateMachine_get_debugName(AddAsyncStateMachineValue* this__);
bool AddAsyncStateMachine_step(AddAsyncStateMachineValue* this__);
InnerAsyncStateMachineValue* InnerAsyncStateMachine_new(InnerAsyncStateMachineValue* this__);
std::string InnerAsyncStateMachine_get_debugName(InnerAsyncStateMachineValue* this__);
bool InnerAsyncStateMachine_step(InnerAsyncStateMachineValue* this__);
OuterAsyncStateMachineValue* OuterAsyncStateMachine_new(OuterAsyncStateMachineValue* this__);
std::string OuterAsyncStateMachine_get_debugName(OuterAsyncStateMachineValue* this__);
bool OuterAsyncStateMachine_step(OuterAsyncStateMachineValue* this__);
ErrorStateMachineValue* ErrorStateMachine_new(ErrorStateMachineValue* this__);
std::string ErrorStateMachine_get_debugName(ErrorStateMachineValue* this__);
bool ErrorStateMachine_step(ErrorStateMachineValue* this__);
ParallelAwaitStateMachineValue* ParallelAwaitStateMachine_new(ParallelAwaitStateMachineValue* this__);
std::string ParallelAwaitStateMachine_get_debugName(ParallelAwaitStateMachineValue* this__);
bool ParallelAwaitStateMachine_step(ParallelAwaitStateMachineValue* this__);
ComputeStepStateMachineValue* ComputeStepStateMachine_new(ComputeStepStateMachineValue* this__, int64_t input);
std::string ComputeStepStateMachine_get_debugName(ComputeStepStateMachineValue* this__);
bool ComputeStepStateMachine_step(ComputeStepStateMachineValue* this__);
PipelineStateMachineValue* PipelineStateMachine_new(PipelineStateMachineValue* this__);
std::string PipelineStateMachine_get_debugName(PipelineStateMachineValue* this__);
bool PipelineStateMachine_step(PipelineStateMachineValue* this__);
void log_(std::string msg);
template<typename T> T smAwait(Promise<T>* future);
void testBasicAwait();
void testDelayedFuture();
void testMultipleAwaitSerial();
void testNestedAsync();
void testThenChain();
void testErrorHandling();
void testParallelAwait();
void testPipeline();
void testTickCounting();
int main();
extern bool enableLog;
void AddAsyncStateMachine_completeWith(AddAsyncStateMachineValue* this__, int64_t value);
void AddAsyncStateMachine_completeWithError(AddAsyncStateMachineValue* this__, AnyGC* error);
AnyGC* AddAsyncStateMachine_start(AddAsyncStateMachineValue* this__);
void InnerAsyncStateMachine_completeWith(InnerAsyncStateMachineValue* this__, std::string value);
void InnerAsyncStateMachine_completeWithError(InnerAsyncStateMachineValue* this__, AnyGC* error);
AnyGC* InnerAsyncStateMachine_start(InnerAsyncStateMachineValue* this__);
void OuterAsyncStateMachine_completeWith(OuterAsyncStateMachineValue* this__, std::string value);
void OuterAsyncStateMachine_completeWithError(OuterAsyncStateMachineValue* this__, AnyGC* error);
AnyGC* OuterAsyncStateMachine_start(OuterAsyncStateMachineValue* this__);
void ErrorStateMachine_completeWith(ErrorStateMachineValue* this__, std::string value);
void ErrorStateMachine_completeWithError(ErrorStateMachineValue* this__, AnyGC* error);
AnyGC* ErrorStateMachine_start(ErrorStateMachineValue* this__);
void ParallelAwaitStateMachine_completeWith(ParallelAwaitStateMachineValue* this__, StaticList<int64_t>* value);
void ParallelAwaitStateMachine_completeWithError(ParallelAwaitStateMachineValue* this__, AnyGC* error);
AnyGC* ParallelAwaitStateMachine_start(ParallelAwaitStateMachineValue* this__);
void ComputeStepStateMachine_completeWith(ComputeStepStateMachineValue* this__, int64_t value);
void ComputeStepStateMachine_completeWithError(ComputeStepStateMachineValue* this__, AnyGC* error);
AnyGC* ComputeStepStateMachine_start(ComputeStepStateMachineValue* this__);
void PipelineStateMachine_completeWith(PipelineStateMachineValue* this__, int64_t value);
void PipelineStateMachine_completeWithError(PipelineStateMachineValue* this__, AnyGC* error);
AnyGC* PipelineStateMachine_start(PipelineStateMachineValue* this__);

struct CompleterState : VPtr {
    std::string _name;
    int64_t _index;

    static CompleterState* pending;
    static CompleterState* completed;
    static CompleterState* error;
    static CompleterState* values;

    CompleterState(std::string n, int64_t i) : _name(std::move(n)), _index(i) {}

    std::string toString() const override { return "CompleterState." + _name; }
};

CompleterState* CompleterState::pending = new CompleterState("pending", 0);
CompleterState* CompleterState::completed = new CompleterState("completed", 1);
CompleterState* CompleterState::error = new CompleterState("error", 2);
CompleterState* CompleterState::values = new CompleterState("values", 3);

struct _DelayedTaskValue : VPtr {
    int64_t targetTick{0};
    TypeFunction0<void>* callback{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() override { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (callback) callback->gcMark(flag);
    }
};

std::unordered_map<std::string, void*> _DelayedTaskValue::_vptrMap;

struct AddAsyncStateMachineValue : AsyncStateMachine<int64_t> {
    int64_t a{0};
    int64_t b{0};
    int64_t _x{0};
    int64_t _y{0};
    Promise<int64_t>* _pendingFuture{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<int64_t>::gcMark(flag);
        if (_pendingFuture) _pendingFuture->gcMark(flag);
    }

    bool step() override {
        return AddAsyncStateMachine_step(this);
    }
};

std::unordered_map<std::string, void*> AddAsyncStateMachineValue::_vptrMap;

struct ClosureEnv_0 : TypeFunction0<int64_t> {
    AddAsyncStateMachineValue* this_;
    ClosureEnv_0(AddAsyncStateMachineValue* this_) : this_(this_) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
                return this_->b;
    }
};

struct InnerAsyncStateMachineValue : AsyncStateMachine<std::string> {
    Promise<std::string>* _pendingFuture{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_pendingFuture) _pendingFuture->gcMark(flag);
    }

    bool step() override {
        return InnerAsyncStateMachine_step(this);
    }
};

std::unordered_map<std::string, void*> InnerAsyncStateMachineValue::_vptrMap;

struct ClosureEnv_1 : TypeFunction0<std::string> {
    ClosureEnv_1() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
                return std::string("inner");
    }
};

struct OuterAsyncStateMachineValue : AsyncStateMachine<std::string> {
    std::string _prefix{""};
    Promise<std::string>* _pendingFuture{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_pendingFuture) _pendingFuture->gcMark(flag);
    }

    bool step() override {
        return OuterAsyncStateMachine_step(this);
    }
};

std::unordered_map<std::string, void*> OuterAsyncStateMachineValue::_vptrMap;

struct ErrorStateMachineValue : AsyncStateMachine<std::string> {
    Promise<int64_t>* _pendingFuture{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<std::string>::gcMark(flag);
        if (_pendingFuture) _pendingFuture->gcMark(flag);
    }

    bool step() override {
        return ErrorStateMachine_step(this);
    }
};

std::unordered_map<std::string, void*> ErrorStateMachineValue::_vptrMap;

struct ClosureEnv_2 : TypeFunction0<int64_t> {
    ClosureEnv_2() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
                throw DartException(std::string("something went wrong"));
        return 0; /* unreachable */
    }
};

struct ParallelAwaitStateMachineValue : AsyncStateMachine<StaticList<int64_t>*> {
    StaticList<Promise<int64_t>*>* _futures{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<StaticList<int64_t>*>::gcMark(flag);
        if (_futures) _futures->gcMark(flag);
    }

    bool step() override {
        return ParallelAwaitStateMachine_step(this);
    }
};

std::unordered_map<std::string, void*> ParallelAwaitStateMachineValue::_vptrMap;

struct ClosureEnv_3 : TypeFunction0<int64_t> {
    ClosureEnv_3() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_3*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
                return 10LL;
    }
};

struct ClosureEnv_4 : TypeFunction0<int64_t> {
    ClosureEnv_4() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_4*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
    return 20LL;
    }
};

struct ClosureEnv_5 : TypeFunction0<int64_t> {
    ClosureEnv_5() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_5*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
    return 30LL;
    }
};

struct ClosureEnv_6 : TypeFunction1<bool, Promise<int64_t>*> {
    ClosureEnv_6() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_6*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<Promise<int64_t>*>(_p0)));
    }
    bool call(Promise<int64_t>* f) {
    return (f->isCompleted() || f->isError());
    }
};

struct ClosureEnv_7 : TypeFunction1<int64_t, Promise<int64_t>*> {
    ClosureEnv_7() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_7*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(static_cast<Promise<int64_t>*>(_p0)));
    }
    int64_t call(Promise<int64_t>* f) {
    return f->typedResult();
    }
};

struct ComputeStepStateMachineValue : AsyncStateMachine<int64_t> {
    int64_t input{0};
    Promise<int64_t>* _pendingFuture{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<int64_t>::gcMark(flag);
        if (_pendingFuture) _pendingFuture->gcMark(flag);
    }

    bool step() override {
        return ComputeStepStateMachine_step(this);
    }
};

std::unordered_map<std::string, void*> ComputeStepStateMachineValue::_vptrMap;

struct ClosureEnv_8 : TypeFunction0<int64_t> {
    ComputeStepStateMachineValue* this_;
    ClosureEnv_8(ComputeStepStateMachineValue* this_) : this_(this_) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_8*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
                return (this_->input * 2LL);
    }
};

struct PipelineStateMachineValue : AsyncStateMachine<int64_t> {
    int64_t _a{0};
    int64_t _b{0};
    int64_t _c{0};
    Promise<int64_t>* _pendingFuture{nullptr};

    static std::unordered_map<std::string, void*> _vptrMap;
    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }

    void gcMark(int flag) override {
        if (this->gcFlag == flag) return;
        AsyncStateMachine<int64_t>::gcMark(flag);
        if (_pendingFuture) _pendingFuture->gcMark(flag);
    }

    bool step() override {
        return PipelineStateMachine_step(this);
    }
};

std::unordered_map<std::string, void*> PipelineStateMachineValue::_vptrMap;

struct ClosureEnv_9 : TypeFunction0<std::string> {
    ClosureEnv_9() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_9*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    std::string call() {
    return std::string("hello after delay");
    }
};

struct ClosureEnv_10 : TypeFunction1<int64_t, int64_t> {
    ClosureEnv_10() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_10*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t v) {
    return (v * 2LL);
    }
};

struct ClosureEnv_11 : TypeFunction1<std::string, int64_t> {
    ClosureEnv_11() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_11*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    std::string call(int64_t v) {
    return dart_str(std::string("value=")) + dart_str(v);
    }
};

struct ClosureEnv_12 : TypeFunction0<int64_t> {
    ClosureEnv_12() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* _self = static_cast<ClosureEnv_12*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call());
    }
    int64_t call() {
    return 99LL;
    }
};


_DelayedTaskValue* _DelayedTask_new(_DelayedTaskValue* this__, int64_t targetTick, TypeFunction0<void>* callback) {
    auto this_ = this__;
    this_->targetTick = targetTick;
    this_->callback = callback;
    return this_;
}

AnyGC* _vptr_wrap_AddAsyncStateMachine_step(AnyGC* obj__) {
    return _box(AddAsyncStateMachine_step(static_cast<AddAsyncStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_AddAsyncStateMachine_completeWith(AnyGC* obj__, AnyGC* arg0) {
    AddAsyncStateMachine_completeWith(static_cast<AddAsyncStateMachineValue*>(obj__), dynAs<int64_t>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_AddAsyncStateMachine_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    AddAsyncStateMachine_completeWithError(static_cast<AddAsyncStateMachineValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_AddAsyncStateMachine_start(AnyGC* obj__) {
    return _box(AddAsyncStateMachine_start(static_cast<AddAsyncStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_AddAsyncStateMachine_get_debugName(AnyGC* obj__) {
    return _box(AddAsyncStateMachine_get_debugName(static_cast<AddAsyncStateMachineValue*>(obj__)));
}

static bool _AddAsyncStateMachine_vptr_registered = []{ AddAsyncStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_step); AddAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_completeWith); AddAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_completeWithError); AddAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_start); AddAsyncStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_get_debugName); AddAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_start); AddAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_completeWith); AddAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_completeWithError); return true; }();
AddAsyncStateMachineValue* AddAsyncStateMachine_new(AddAsyncStateMachineValue* this__, int64_t a, int64_t b) {
    auto this_ = this__;
    if (AddAsyncStateMachineValue::_vptrMap.empty()) {
        AddAsyncStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_step);
        AddAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_completeWith);
        AddAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_completeWithError);
        AddAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_start);
        AddAsyncStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_AddAsyncStateMachine_get_debugName);
    }
    this_->a = a;
    this_->b = b;
    this_->_x = 0LL;
    this_->_y = 0LL;
    return this_;
}

std::string AddAsyncStateMachine_get_debugName(AddAsyncStateMachineValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("AddAsync(")) + dart_str(this_->a) + dart_str(std::string(",")) + dart_str(this_->b) + dart_str(std::string(")"));
}

bool AddAsyncStateMachine_step(AddAsyncStateMachineValue* this__) {
    auto this_ = this__;
    _L0:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                (this_->_pendingFuture = Promise_value<int64_t>(this_->a));
                (this_->smState = 1LL);
                log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 0→1, created value future for ")) + dart_str(this_->a));
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if (this_->_pendingFuture->isPending()) {
                    return false;
                }
                (this_->_x = this_->_pendingFuture->typedResult());
    (this_->_pendingFuture = Promise_delayed<int64_t>(2LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_0(this_)))));
    (this_->smState = 2LL);
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 1→2, got x=")) + dart_str(this_->_x) + dart_str(std::string(", created delayed future for ")) + dart_str(this_->b));
    return false;
    break;
}
_sw_case_2:
case 2:
{
    if (this_->_pendingFuture->isPending()) {
        return false;
    }
    (this_->_y = this_->_pendingFuture->typedResult());
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 2→done, got y=")) + dart_str(this_->_y) + dart_str(std::string(", result=")) + dart_str((this_->_x + this_->_y)));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box((this_->_x + this_->_y)));
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

AnyGC* _vptr_wrap_InnerAsyncStateMachine_step(AnyGC* obj__) {
    return _box(InnerAsyncStateMachine_step(static_cast<InnerAsyncStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_InnerAsyncStateMachine_completeWith(AnyGC* obj__, AnyGC* arg0) {
    InnerAsyncStateMachine_completeWith(static_cast<InnerAsyncStateMachineValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_InnerAsyncStateMachine_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    InnerAsyncStateMachine_completeWithError(static_cast<InnerAsyncStateMachineValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_InnerAsyncStateMachine_start(AnyGC* obj__) {
    return _box(InnerAsyncStateMachine_start(static_cast<InnerAsyncStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_InnerAsyncStateMachine_get_debugName(AnyGC* obj__) {
    return _box(InnerAsyncStateMachine_get_debugName(static_cast<InnerAsyncStateMachineValue*>(obj__)));
}

static bool _InnerAsyncStateMachine_vptr_registered = []{ InnerAsyncStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_step); InnerAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_completeWith); InnerAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_completeWithError); InnerAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_start); InnerAsyncStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_get_debugName); InnerAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_start); InnerAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_completeWith); InnerAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_completeWithError); return true; }();
InnerAsyncStateMachineValue* InnerAsyncStateMachine_new(InnerAsyncStateMachineValue* this__) {
    auto this_ = this__;
    if (InnerAsyncStateMachineValue::_vptrMap.empty()) {
        InnerAsyncStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_step);
        InnerAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_completeWith);
        InnerAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_completeWithError);
        InnerAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_start);
        InnerAsyncStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_InnerAsyncStateMachine_get_debugName);
    }
    return this_;
}

std::string InnerAsyncStateMachine_get_debugName(InnerAsyncStateMachineValue* this__) {
    auto this_ = this__;
    return std::string("InnerAsync");
}

bool InnerAsyncStateMachine_step(InnerAsyncStateMachineValue* this__) {
    auto this_ = this__;
    _L1:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
    (this_->_pendingFuture = Promise_delayed<std::string>(2LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_1()))));
    (this_->smState = 1LL);
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 0→1, created delayed future")));
    return false;
    break;
}
_sw_case_1:
case 1:
{
    if (this_->_pendingFuture->isPending()) {
        return false;
    }
    std::string val = this_->_pendingFuture->typedResult();
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 1→done, val=")) + dart_str(val) + dart_str(std::string(" → ")) + dart_str(dart_str_toUpper(val)));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(dart_str_toUpper(val)));
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

AnyGC* _vptr_wrap_OuterAsyncStateMachine_step(AnyGC* obj__) {
    return _box(OuterAsyncStateMachine_step(static_cast<OuterAsyncStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_OuterAsyncStateMachine_completeWith(AnyGC* obj__, AnyGC* arg0) {
    OuterAsyncStateMachine_completeWith(static_cast<OuterAsyncStateMachineValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_OuterAsyncStateMachine_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    OuterAsyncStateMachine_completeWithError(static_cast<OuterAsyncStateMachineValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_OuterAsyncStateMachine_start(AnyGC* obj__) {
    return _box(OuterAsyncStateMachine_start(static_cast<OuterAsyncStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_OuterAsyncStateMachine_get_debugName(AnyGC* obj__) {
    return _box(OuterAsyncStateMachine_get_debugName(static_cast<OuterAsyncStateMachineValue*>(obj__)));
}

static bool _OuterAsyncStateMachine_vptr_registered = []{ OuterAsyncStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_step); OuterAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_completeWith); OuterAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_completeWithError); OuterAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_start); OuterAsyncStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_get_debugName); OuterAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_start); OuterAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_completeWith); OuterAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_completeWithError); return true; }();
OuterAsyncStateMachineValue* OuterAsyncStateMachine_new(OuterAsyncStateMachineValue* this__) {
    auto this_ = this__;
    if (OuterAsyncStateMachineValue::_vptrMap.empty()) {
        OuterAsyncStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_step);
        OuterAsyncStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_completeWith);
        OuterAsyncStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_completeWithError);
        OuterAsyncStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_start);
        OuterAsyncStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_OuterAsyncStateMachine_get_debugName);
    }
    this_->_prefix = std::string("");
    return this_;
}

std::string OuterAsyncStateMachine_get_debugName(OuterAsyncStateMachineValue* this__) {
    auto this_ = this__;
    return std::string("OuterAsync");
}

bool OuterAsyncStateMachine_step(OuterAsyncStateMachineValue* this__) {
    auto this_ = this__;
    _L2:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                (this_->_pendingFuture = Promise_value<std::string>(std::string("result:")));
                (this_->smState = 1LL);
                log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 0→1, created value future")));
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if (this_->_pendingFuture->isPending()) {
                    return false;
                }
                (this_->_prefix = this_->_pendingFuture->typedResult());
                InnerAsyncStateMachineValue* innerSm = InnerAsyncStateMachine_new(GC::allocateLocal(new InnerAsyncStateMachineValue()));
                (this_->_pendingFuture = static_cast<Promise<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(innerSm->getVptrMap()["start"]))(innerSm)));
                (this_->smState = 2LL);
                log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 1→2, prefix=")) + dart_str(this_->_prefix) + dart_str(std::string(", started InnerAsync")));
                return false;
                break;
            }
            _sw_case_2:
            case 2:
            {
                if (this_->_pendingFuture->isPending()) {
                    return false;
                }
                std::string innerResult = this_->_pendingFuture->typedResult();
                log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 2→done, inner=")) + dart_str(innerResult));
                (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(dart_str(this_->_prefix) + dart_str(std::string(" ")) + dart_str(innerResult)));
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

AnyGC* _vptr_wrap_ErrorStateMachine_step(AnyGC* obj__) {
    return _box(ErrorStateMachine_step(static_cast<ErrorStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_ErrorStateMachine_completeWith(AnyGC* obj__, AnyGC* arg0) {
    ErrorStateMachine_completeWith(static_cast<ErrorStateMachineValue*>(obj__), dynAs<std::string>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_ErrorStateMachine_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    ErrorStateMachine_completeWithError(static_cast<ErrorStateMachineValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_ErrorStateMachine_start(AnyGC* obj__) {
    return _box(ErrorStateMachine_start(static_cast<ErrorStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_ErrorStateMachine_get_debugName(AnyGC* obj__) {
    return _box(ErrorStateMachine_get_debugName(static_cast<ErrorStateMachineValue*>(obj__)));
}

static bool _ErrorStateMachine_vptr_registered = []{ ErrorStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_step); ErrorStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_completeWith); ErrorStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_completeWithError); ErrorStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_start); ErrorStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_get_debugName); ErrorStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_start); ErrorStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_completeWith); ErrorStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_completeWithError); return true; }();
ErrorStateMachineValue* ErrorStateMachine_new(ErrorStateMachineValue* this__) {
    auto this_ = this__;
    if (ErrorStateMachineValue::_vptrMap.empty()) {
        ErrorStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_step);
        ErrorStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_completeWith);
        ErrorStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_completeWithError);
        ErrorStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_start);
        ErrorStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_ErrorStateMachine_get_debugName);
    }
    return this_;
}

std::string ErrorStateMachine_get_debugName(ErrorStateMachineValue* this__) {
    auto this_ = this__;
    return std::string("ErrorSM");
}

bool ErrorStateMachine_step(ErrorStateMachineValue* this__) {
    auto this_ = this__;
    _L3:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
    (this_->_pendingFuture = Promise_delayed<int64_t>(1LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_2()))));
    (this_->smState = 1LL);
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 0→1, created delayed future (will throw)")));
    return false;
    break;
}
_sw_case_1:
case 1:
{
    if (this_->_pendingFuture->isPending()) {
        return false;
    }
    if (this_->_pendingFuture->isError()) {
        log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 1→done, caught error")));
        (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(dart_str(std::string("caught: ")) + dart_str(this_->_pendingFuture->error)));
        return true;
    }
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(std::string("unexpected success")));
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

AnyGC* _vptr_wrap_ParallelAwaitStateMachine_step(AnyGC* obj__) {
    return _box(ParallelAwaitStateMachine_step(static_cast<ParallelAwaitStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_ParallelAwaitStateMachine_completeWith(AnyGC* obj__, AnyGC* arg0) {
    ParallelAwaitStateMachine_completeWith(static_cast<ParallelAwaitStateMachineValue*>(obj__), static_cast<StaticList<int64_t>*>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_ParallelAwaitStateMachine_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    ParallelAwaitStateMachine_completeWithError(static_cast<ParallelAwaitStateMachineValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_ParallelAwaitStateMachine_start(AnyGC* obj__) {
    return _box(ParallelAwaitStateMachine_start(static_cast<ParallelAwaitStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_ParallelAwaitStateMachine_get_debugName(AnyGC* obj__) {
    return _box(ParallelAwaitStateMachine_get_debugName(static_cast<ParallelAwaitStateMachineValue*>(obj__)));
}

static bool _ParallelAwaitStateMachine_vptr_registered = []{ ParallelAwaitStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_step); ParallelAwaitStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_completeWith); ParallelAwaitStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_completeWithError); ParallelAwaitStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_start); ParallelAwaitStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_get_debugName); ParallelAwaitStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_start); ParallelAwaitStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_completeWith); ParallelAwaitStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_completeWithError); return true; }();
ParallelAwaitStateMachineValue* ParallelAwaitStateMachine_new(ParallelAwaitStateMachineValue* this__) {
    auto this_ = this__;
    if (ParallelAwaitStateMachineValue::_vptrMap.empty()) {
        ParallelAwaitStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_step);
        ParallelAwaitStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_completeWith);
        ParallelAwaitStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_completeWithError);
        ParallelAwaitStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_start);
        ParallelAwaitStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_ParallelAwaitStateMachine_get_debugName);
    }
    return this_;
}

std::string ParallelAwaitStateMachine_get_debugName(ParallelAwaitStateMachineValue* this__) {
    auto this_ = this__;
    return std::string("ParallelSM");
}

bool ParallelAwaitStateMachine_step(ParallelAwaitStateMachineValue* this__) {
    auto this_ = this__;
    _L4:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
    (this_->_futures = GC::allocateLocal(new StaticList<Promise<int64_t>*>({Promise_delayed<int64_t>(3LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_3()))), Promise_delayed<int64_t>(2LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_4()))), Promise_delayed<int64_t>(1LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_5())))})));
    (this_->smState = 1LL);
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 0→1, created 3 delayed futures")));
    return false;
    break;
}
_sw_case_1:
case 1:
{
    bool allDone = this_->_futures->every(GC::allocateLocal(static_cast<TypeFunction1<bool, Promise<int64_t>*>*>(new ClosureEnv_6())));
    if (!(allDone)) {
        return false;
    }
    StaticList<int64_t>* results = this_->_futures->map(GC::allocateLocal(static_cast<TypeFunction1<int64_t, Promise<int64_t>*>*>(new ClosureEnv_7())));
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 1→done, all futures completed: ")) + dart_str(results));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(results));
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

AnyGC* _vptr_wrap_ComputeStepStateMachine_step(AnyGC* obj__) {
    return _box(ComputeStepStateMachine_step(static_cast<ComputeStepStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_ComputeStepStateMachine_completeWith(AnyGC* obj__, AnyGC* arg0) {
    ComputeStepStateMachine_completeWith(static_cast<ComputeStepStateMachineValue*>(obj__), dynAs<int64_t>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_ComputeStepStateMachine_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    ComputeStepStateMachine_completeWithError(static_cast<ComputeStepStateMachineValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_ComputeStepStateMachine_start(AnyGC* obj__) {
    return _box(ComputeStepStateMachine_start(static_cast<ComputeStepStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_ComputeStepStateMachine_get_debugName(AnyGC* obj__) {
    return _box(ComputeStepStateMachine_get_debugName(static_cast<ComputeStepStateMachineValue*>(obj__)));
}

static bool _ComputeStepStateMachine_vptr_registered = []{ ComputeStepStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_step); ComputeStepStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_completeWith); ComputeStepStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_completeWithError); ComputeStepStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_start); ComputeStepStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_get_debugName); ComputeStepStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_start); ComputeStepStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_completeWith); ComputeStepStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_completeWithError); return true; }();
ComputeStepStateMachineValue* ComputeStepStateMachine_new(ComputeStepStateMachineValue* this__, int64_t input) {
    auto this_ = this__;
    if (ComputeStepStateMachineValue::_vptrMap.empty()) {
        ComputeStepStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_step);
        ComputeStepStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_completeWith);
        ComputeStepStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_completeWithError);
        ComputeStepStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_start);
        ComputeStepStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_ComputeStepStateMachine_get_debugName);
    }
    this_->input = input;
    return this_;
}

std::string ComputeStepStateMachine_get_debugName(ComputeStepStateMachineValue* this__) {
    auto this_ = this__;
    return dart_str(std::string("ComputeStep(")) + dart_str(this_->input) + dart_str(std::string(")"));
}

bool ComputeStepStateMachine_step(ComputeStepStateMachineValue* this__) {
    auto this_ = this__;
    _L5:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
    (this_->_pendingFuture = Promise_delayed<int64_t>(1LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_8(this_)))));
    (this_->smState = 1LL);
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 0→1")));
    return false;
    break;
}
_sw_case_1:
case 1:
{
    if (this_->_pendingFuture->isPending()) {
        return false;
    }
    int64_t r = this_->_pendingFuture->typedResult();
    log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 1→done, result=")) + dart_str(r));
    (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(r));
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

AnyGC* _vptr_wrap_PipelineStateMachine_step(AnyGC* obj__) {
    return _box(PipelineStateMachine_step(static_cast<PipelineStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_PipelineStateMachine_completeWith(AnyGC* obj__, AnyGC* arg0) {
    PipelineStateMachine_completeWith(static_cast<PipelineStateMachineValue*>(obj__), dynAs<int64_t>(arg0));
    return nullptr;
}

AnyGC* _vptr_wrap_PipelineStateMachine_completeWithError(AnyGC* obj__, AnyGC* arg0) {
    PipelineStateMachine_completeWithError(static_cast<PipelineStateMachineValue*>(obj__), arg0);
    return nullptr;
}

AnyGC* _vptr_wrap_PipelineStateMachine_start(AnyGC* obj__) {
    return _box(PipelineStateMachine_start(static_cast<PipelineStateMachineValue*>(obj__)));
}

AnyGC* _vptr_wrap_PipelineStateMachine_get_debugName(AnyGC* obj__) {
    return _box(PipelineStateMachine_get_debugName(static_cast<PipelineStateMachineValue*>(obj__)));
}

static bool _PipelineStateMachine_vptr_registered = []{ PipelineStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_step); PipelineStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_completeWith); PipelineStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_completeWithError); PipelineStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_start); PipelineStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_get_debugName); PipelineStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_start); PipelineStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_completeWith); PipelineStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_completeWithError); return true; }();
PipelineStateMachineValue* PipelineStateMachine_new(PipelineStateMachineValue* this__) {
    auto this_ = this__;
    if (PipelineStateMachineValue::_vptrMap.empty()) {
        PipelineStateMachineValue::_vptrMap["step"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_step);
        PipelineStateMachineValue::_vptrMap["completeWith"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_completeWith);
        PipelineStateMachineValue::_vptrMap["completeWithError"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_completeWithError);
        PipelineStateMachineValue::_vptrMap["start"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_start);
        PipelineStateMachineValue::_vptrMap["get_debugName"] = reinterpret_cast<void*>(&_vptr_wrap_PipelineStateMachine_get_debugName);
    }
    this_->_a = 0LL;
    this_->_b = 0LL;
    this_->_c = 0LL;
    return this_;
}

std::string PipelineStateMachine_get_debugName(PipelineStateMachineValue* this__) {
    auto this_ = this__;
    return std::string("PipelineSM");
}

bool PipelineStateMachine_step(PipelineStateMachineValue* this__) {
    auto this_ = this__;
    _L6:
    do {
        switch (this_->smState) {
            _sw_case_0:
            case 0:
            {
                (this_->_pendingFuture = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ComputeStepStateMachine_new(GC::allocateLocal(new ComputeStepStateMachineValue()), 1LL)->getVptrMap()["start"]))(ComputeStepStateMachine_new(GC::allocateLocal(new ComputeStepStateMachineValue()), 1LL))));
                (this_->smState = 1LL);
                log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 0→1, started ComputeStep(1)")));
                return false;
                break;
            }
            _sw_case_1:
            case 1:
            {
                if (this_->_pendingFuture->isPending()) {
                    return false;
                }
                (this_->_a = this_->_pendingFuture->typedResult());
                (this_->_pendingFuture = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ComputeStepStateMachine_new(GC::allocateLocal(new ComputeStepStateMachineValue()), this_->_a)->getVptrMap()["start"]))(ComputeStepStateMachine_new(GC::allocateLocal(new ComputeStepStateMachineValue()), this_->_a))));
                (this_->smState = 2LL);
                log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 1→2, a=")) + dart_str(this_->_a) + dart_str(std::string(", started ComputeStep(")) + dart_str(this_->_a) + dart_str(std::string(")")));
                return false;
                break;
            }
            _sw_case_2:
            case 2:
            {
                if (this_->_pendingFuture->isPending()) {
                    return false;
                }
                (this_->_b = this_->_pendingFuture->typedResult());
                (this_->_pendingFuture = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(ComputeStepStateMachine_new(GC::allocateLocal(new ComputeStepStateMachineValue()), this_->_b)->getVptrMap()["start"]))(ComputeStepStateMachine_new(GC::allocateLocal(new ComputeStepStateMachineValue()), this_->_b))));
                (this_->smState = 3LL);
                log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 2→3, b=")) + dart_str(this_->_b) + dart_str(std::string(", started ComputeStep(")) + dart_str(this_->_b) + dart_str(std::string(")")));
                return false;
                break;
            }
            _sw_case_3:
            case 3:
            {
                if (this_->_pendingFuture->isPending()) {
                    return false;
                }
                (this_->_c = this_->_pendingFuture->typedResult());
                log_(dart_str(std::string("  ")) + dart_str(dynAs<std::string>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(this_->getVptrMap()["get_debugName"]))(this_))) + dart_str(std::string(": state 3→done, c=")) + dart_str(this_->_c) + dart_str(std::string(", sum=")) + dart_str(((this_->_a + this_->_b) + this_->_c)));
                (reinterpret_cast<AnyGC*(*)(AnyGC*, AnyGC*)>(this_->getVptrMap()["completeWith"]))(this_, _box(((this_->_a + this_->_b) + this_->_c)));
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

void log_(std::string msg) {
    if (enableLog) {
        staticPrint(dart_str(std::string("  [LOG] ")) + dart_str(msg));
    }
}

template<typename T>
T smAwait(Promise<T>* future) {
    int64_t roundCount = 0LL;
    int64_t maxRounds = 100000;
    log_(dart_str(std::string("smAwait: waiting for future (completed=")) + dart_str(future->isCompleted()) + dart_str(std::string(")")));
    while ((!(future->isCompleted()) && !(future->isError()))) {
        GlobalScheduler::instance().tick();
        (roundCount = (roundCount + 1LL));
        if ((roundCount > 100000)) {
            throw DartStateError(std::string("smAwait exceeded 100000 rounds — possible deadlock"));
        }
    }
    if (future->isError()) {
        log_(dart_str(std::string("smAwait: future resolved with ERROR after ")) + dart_str(roundCount) + dart_str(std::string(" ticks")));
        throw DartException(dart_str(future->error));
    }
    log_(dart_str(std::string("smAwait: future resolved with value after ")) + dart_str(roundCount) + dart_str(std::string(" ticks")));
    return future->typedResult();
}

void testBasicAwait() {
    staticPrint(std::string("\n--- Demo 1: 基础 await (Promise.value) ---"));
    GlobalScheduler::instance().reset();
    Promise<int64_t>* future = Promise_value<int64_t>(42LL);
    int64_t result = smAwait<int64_t>(future);
    assert((result == 42LL));
    staticPrint(dart_str(std::string("  ✓ smAwait(Promise.value(42)) = ")) + dart_str(result));
}

void testDelayedFuture() {
    staticPrint(std::string("\n--- Demo 2: 延迟 Future ---"));
    GlobalScheduler::instance().reset();
    Promise<std::string>* future = Promise_delayed<std::string>(3LL, GC::allocateLocal(static_cast<TypeFunction0<std::string>*>(new ClosureEnv_9())));
    std::string result = smAwait<std::string>(future);
    assert((result == std::string("hello after delay")));
    staticPrint(dart_str(std::string("  ✓ smAwait(delayed(3 ticks)) = \"")) + dart_str(result) + dart_str(std::string("\"")));
}

void testMultipleAwaitSerial() {
    staticPrint(std::string("\n--- Demo 3: 多 await 串行 (addAsync(10, 20)) ---"));
    GlobalScheduler::instance().reset();
    AddAsyncStateMachineValue* sm = AddAsyncStateMachine_new(GC::allocateLocal(new AddAsyncStateMachineValue()), 10LL, 20LL);
    Promise<int64_t>* future = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(sm->getVptrMap()["start"]))(sm));
    int64_t result = smAwait<int64_t>(future);
    assert((result == 30LL));
    staticPrint(dart_str(std::string("  ✓ addAsync(10, 20) = ")) + dart_str(result));
}

void testNestedAsync() {
    staticPrint(std::string("\n--- Demo 4: 嵌套异步调用 ---"));
    GlobalScheduler::instance().reset();
    OuterAsyncStateMachineValue* sm = OuterAsyncStateMachine_new(GC::allocateLocal(new OuterAsyncStateMachineValue()));
    Promise<std::string>* future = static_cast<Promise<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(sm->getVptrMap()["start"]))(sm));
    std::string result = smAwait<std::string>(future);
    assert((result == std::string("result: INNER")));
    staticPrint(dart_str(std::string("  ✓ outerAsync() = \"")) + dart_str(result) + dart_str(std::string("\"")));
}

void testThenChain() {
    staticPrint(std::string("\n--- Demo 5: then 链式调用 ---"));
    GlobalScheduler::instance().reset();
    Promise<std::string>* future = Promise_then(Promise_then(Promise_value<int64_t>(5LL), GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_10()))), GC::allocateLocal(static_cast<TypeFunction1<std::string, int64_t>*>(new ClosureEnv_11())));
    std::string result = smAwait<std::string>(future);
    assert((result == std::string("value=10")));
    staticPrint(dart_str(std::string("  ✓ Promise.value(5).then(*2).then(format) = \"")) + dart_str(result) + dart_str(std::string("\"")));
}

void testErrorHandling() {
    staticPrint(std::string("\n--- Demo 6: 异常处理 ---"));
    GlobalScheduler::instance().reset();
    ErrorStateMachineValue* sm = ErrorStateMachine_new(GC::allocateLocal(new ErrorStateMachineValue()));
    Promise<std::string>* future = static_cast<Promise<std::string>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(sm->getVptrMap()["start"]))(sm));
    std::string result = smAwait<std::string>(future);
    assert((result.find(std::string("something went wrong")) != std::string::npos));
    staticPrint(dart_str(std::string("  ✓ error caught and recovered: \"")) + dart_str(result) + dart_str(std::string("\"")));
}

void testParallelAwait() {
    staticPrint(std::string("\n--- Demo 7: 并行 await (Future.wait 模拟) ---"));
    GlobalScheduler::instance().reset();
    ParallelAwaitStateMachineValue* sm = ParallelAwaitStateMachine_new(GC::allocateLocal(new ParallelAwaitStateMachineValue()));
    Promise<StaticList<int64_t>*>* future = static_cast<Promise<StaticList<int64_t>*>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(sm->getVptrMap()["start"]))(sm));
    StaticList<int64_t>* result = smAwait<StaticList<int64_t>*>(future);
    assert((result->length() == 3LL));
    assert(((((*result)[0LL] == 10LL) && ((*result)[1LL] == 20LL)) && ((*result)[2LL] == 30LL)));
    staticPrint(dart_str(std::string("  ✓ parallel([d3→10, d2→20, d1→30]) = ")) + dart_str(result));
}

void testPipeline() {
    staticPrint(std::string("\n--- Demo 8: 多层嵌套管道 pipeline ---"));
    GlobalScheduler::instance().reset();
    PipelineStateMachineValue* sm = PipelineStateMachine_new(GC::allocateLocal(new PipelineStateMachineValue()));
    Promise<int64_t>* future = static_cast<Promise<int64_t>*>((reinterpret_cast<AnyGC*(*)(AnyGC*)>(sm->getVptrMap()["start"]))(sm));
    int64_t result = smAwait<int64_t>(future);
    assert((result == 14LL));
    staticPrint(dart_str(std::string("  ✓ pipeline(1→2→4→8, sum=14) = ")) + dart_str(result));
}

void testTickCounting() {
    staticPrint(std::string("\n--- Demo 9: tick 计数验证 ---"));
    GlobalScheduler::instance().reset();
    Promise<int64_t>* future = Promise_delayed<int64_t>(5LL, GC::allocateLocal(static_cast<TypeFunction0<int64_t>*>(new ClosureEnv_12())));
    int64_t ticksBefore = GlobalScheduler::instance()._currentTick;
    int64_t result = smAwait<int64_t>(future);
    int64_t ticksAfter = GlobalScheduler::instance()._currentTick;
    int64_t ticksUsed = (ticksAfter - ticksBefore);
    assert((result == 99LL));
    assert((ticksUsed >= 5LL));
    staticPrint(dart_str(std::string("  ✓ delayed(5 ticks) completed in ")) + dart_str(ticksUsed) + dart_str(std::string(" ticks, result=")) + dart_str(result));
}

int main() {
    staticPrint(std::string("═══════════════════════════════════════════"));
    staticPrint(std::string(" 状态机协程验证测试"));
    staticPrint(std::string("═══════════════════════════════════════════"));
    testBasicAwait();
    testDelayedFuture();
    testMultipleAwaitSerial();
    testNestedAsync();
    testThenChain();
    testErrorHandling();
    testParallelAwait();
    testPipeline();
    testTickCounting();
    staticPrint(std::string("\n═══════════════════════════════════════════"));
    staticPrint(std::string(" ✅ 全部 9 个测试通过！"));
    staticPrint(std::string("═══════════════════════════════════════════"));
    return 0;
}

bool enableLog = true;

void AddAsyncStateMachine_completeWith(AddAsyncStateMachineValue* this__, int64_t value) {
    auto this_ = this__;
    AsyncStateMachine_completeWith<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_), value);
}

void AddAsyncStateMachine_completeWithError(AddAsyncStateMachineValue* this__, AnyGC* error) {
    auto this_ = this__;
    AsyncStateMachine_completeWithError<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_), error);
}

AnyGC* AddAsyncStateMachine_start(AddAsyncStateMachineValue* this__) {
    auto this_ = this__;
    return _box(AsyncStateMachine_start<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_)));
}

void InnerAsyncStateMachine_completeWith(InnerAsyncStateMachineValue* this__, std::string value) {
    auto this_ = this__;
    AsyncStateMachine_completeWith<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_), value);
}

void InnerAsyncStateMachine_completeWithError(InnerAsyncStateMachineValue* this__, AnyGC* error) {
    auto this_ = this__;
    AsyncStateMachine_completeWithError<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_), error);
}

AnyGC* InnerAsyncStateMachine_start(InnerAsyncStateMachineValue* this__) {
    auto this_ = this__;
    return _box(AsyncStateMachine_start<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_)));
}

void OuterAsyncStateMachine_completeWith(OuterAsyncStateMachineValue* this__, std::string value) {
    auto this_ = this__;
    AsyncStateMachine_completeWith<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_), value);
}

void OuterAsyncStateMachine_completeWithError(OuterAsyncStateMachineValue* this__, AnyGC* error) {
    auto this_ = this__;
    AsyncStateMachine_completeWithError<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_), error);
}

AnyGC* OuterAsyncStateMachine_start(OuterAsyncStateMachineValue* this__) {
    auto this_ = this__;
    return _box(AsyncStateMachine_start<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_)));
}

void ErrorStateMachine_completeWith(ErrorStateMachineValue* this__, std::string value) {
    auto this_ = this__;
    AsyncStateMachine_completeWith<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_), value);
}

void ErrorStateMachine_completeWithError(ErrorStateMachineValue* this__, AnyGC* error) {
    auto this_ = this__;
    AsyncStateMachine_completeWithError<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_), error);
}

AnyGC* ErrorStateMachine_start(ErrorStateMachineValue* this__) {
    auto this_ = this__;
    return _box(AsyncStateMachine_start<std::string>(static_cast<AsyncStateMachine<std::string>*>(this_)));
}

void ParallelAwaitStateMachine_completeWith(ParallelAwaitStateMachineValue* this__, StaticList<int64_t>* value) {
    auto this_ = this__;
    AsyncStateMachine_completeWith<StaticList<int64_t>*>(static_cast<AsyncStateMachine<StaticList<int64_t>*>*>(this_), value);
}

void ParallelAwaitStateMachine_completeWithError(ParallelAwaitStateMachineValue* this__, AnyGC* error) {
    auto this_ = this__;
    AsyncStateMachine_completeWithError<StaticList<int64_t>*>(static_cast<AsyncStateMachine<StaticList<int64_t>*>*>(this_), error);
}

AnyGC* ParallelAwaitStateMachine_start(ParallelAwaitStateMachineValue* this__) {
    auto this_ = this__;
    return _box(AsyncStateMachine_start<StaticList<int64_t>*>(static_cast<AsyncStateMachine<StaticList<int64_t>*>*>(this_)));
}

void ComputeStepStateMachine_completeWith(ComputeStepStateMachineValue* this__, int64_t value) {
    auto this_ = this__;
    AsyncStateMachine_completeWith<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_), value);
}

void ComputeStepStateMachine_completeWithError(ComputeStepStateMachineValue* this__, AnyGC* error) {
    auto this_ = this__;
    AsyncStateMachine_completeWithError<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_), error);
}

AnyGC* ComputeStepStateMachine_start(ComputeStepStateMachineValue* this__) {
    auto this_ = this__;
    return _box(AsyncStateMachine_start<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_)));
}

void PipelineStateMachine_completeWith(PipelineStateMachineValue* this__, int64_t value) {
    auto this_ = this__;
    AsyncStateMachine_completeWith<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_), value);
}

void PipelineStateMachine_completeWithError(PipelineStateMachineValue* this__, AnyGC* error) {
    auto this_ = this__;
    AsyncStateMachine_completeWithError<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_), error);
}

AnyGC* PipelineStateMachine_start(PipelineStateMachineValue* this__) {
    auto this_ = this__;
    return _box(AsyncStateMachine_start<int64_t>(static_cast<AsyncStateMachine<int64_t>*>(this_)));
}


#include "dart2cpp_lowered.h"

int main();
void testArray();
void testStaticList();
void testStaticMap();
void testStaticSet();

struct ClosureEnv_0 : TypeFunction1<int64_t, int64_t> {
    ClosureEnv_0() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_0*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    int64_t call(int64_t x) {
    return (x * 2LL);
    }
};

struct ClosureEnv_1 : TypeFunction1<bool, int64_t> {
    ClosureEnv_1() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* _self = static_cast<ClosureEnv_1*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0)));
    }
    bool call(int64_t x) {
    return (x > 3LL);
    }
};

struct ClosureEnv_2 : TypeFunction2<int64_t, int64_t, int64_t> {
    ClosureEnv_2() {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* _self = static_cast<ClosureEnv_2*>(dynamic_cast<TypeFunction*>(_env));
        return _box(_self->call(dynAs<int64_t>(_p0), dynAs<int64_t>(_p1)));
    }
    int64_t call(int64_t a, int64_t b) {
    return (a + b);
    }
};


int main() {
    testArray();
    testStaticList();
    testStaticMap();
    testStaticSet();
    staticPrint(std::string("\n✅ All static collection tests passed!"));
    return 0;
}

void testArray() {
    staticPrint(std::string("--- Array Tests ---"));
    Array<int64_t>* fixedArray = GC::allocateLocal(new Array<int64_t>(5LL, 0LL));
    assert((fixedArray->length() == 5LL));
    assert(((*fixedArray)[0LL] == 0LL));
    (*fixedArray)[2LL] = 42LL;
    assert(((*fixedArray)[2LL] == 42LL));
    staticPrint(std::string("  ✓ Fixed size Array"));
    Array<std::string>* fromArray = GC::allocateLocal(new Array<std::string>(GC::allocateLocal(new StaticList<std::string>({std::string("a"), std::string("b"), std::string("c")}))));
    assert((fromArray->length() == 3LL));
    assert(((*fromArray)[1LL] == std::string("b")));
    staticPrint(std::string("  ✓ Array.from"));
    Array<int64_t>* dynamicArray = GC::allocateLocal(new Array<int64_t>());
    dynamicArray->add(10LL);
    dynamicArray->add(20LL);
    dynamicArray->add(30LL);
    assert((dynamicArray->length() == 3LL));
    assert(((*dynamicArray)[1LL] == 20LL));
    dynamicArray->removeAt(1LL);
    assert((dynamicArray->length() == 2LL));
    assert(((*dynamicArray)[1LL] == 30LL));
    staticPrint(std::string("  ✓ Dynamic Array add/removeAt"));
    assert((dynamicArray->indexOf(30LL) == 1LL));
    assert(dynamicArray->contains(10LL));
    assert(!(dynamicArray->contains(99LL)));
    staticPrint(std::string("  ✓ Array indexOf/contains"));
}

void testStaticList() {
    staticPrint(std::string("\n--- StaticList Tests ---"));
    StaticList<int64_t>* emptyList = GC::allocateLocal(new StaticList<int64_t>());
    assert(emptyList->isEmpty());
    assert((emptyList->length() == 0LL));
    staticPrint(std::string("  ✓ Empty StaticList"));
    StaticList<int64_t>* list = GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL, 5LL}));
    assert((list->length() == 5LL));
    assert(((*list)[0LL] == 1LL));
    assert(((*list)[4LL] == 5LL));
    staticPrint(std::string("  ✓ StaticList.of"));
    list->add(6LL);
    assert((list->length() == 6LL));
    assert(((*list)[5LL] == 6LL));
    (*list)[2LL] = 99LL;
    assert(((*list)[2LL] == 99LL));
    staticPrint(std::string("  ✓ StaticList add/operator[]="));
    list->remove(99LL);
    assert((list->length() == 5LL));
    assert(!(list->contains(99LL)));
    staticPrint(std::string("  ✓ StaticList remove"));
    StaticList<int64_t>* doubled = list->map(GC::allocateLocal(static_cast<TypeFunction1<int64_t, int64_t>*>(new ClosureEnv_0())));
    assert((doubled->length() == list->length()));
    assert(((*doubled)[0LL] == ((*list)[0LL] * 2LL)));
    staticPrint(std::string("  ✓ StaticList map"));
    StaticList<int64_t>* filtered = list->where(GC::allocateLocal(static_cast<TypeFunction1<bool, int64_t>*>(new ClosureEnv_1())));
    assert((filtered->length() > 0LL));
    int64_t i = 0LL;
    while ((i < filtered->length())) {
        assert(((*filtered)[i] > 3LL));
        (i = (i + 1LL));
    }
    staticPrint(std::string("  ✓ StaticList where"));
    int64_t sum = GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL, 4LL}))->reduce(GC::allocateLocal(static_cast<TypeFunction2<int64_t, int64_t, int64_t>*>(new ClosureEnv_2())));
    assert((sum == 10LL));
    staticPrint(std::string("  ✓ StaticList reduce"));
    StaticList<std::string>* fl = GC::allocateLocal(new StaticList<std::string>({std::string("hello"), std::string("world")}));
    assert((fl->first() == std::string("hello")));
    assert((fl->last() == std::string("world")));
    staticPrint(std::string("  ✓ StaticList first/last"));
    assert((GC::allocateLocal(new StaticList<int64_t>({1LL, 2LL, 3LL}))->toString() == std::string("[1, 2, 3]")));
    staticPrint(std::string("  ✓ StaticList toString"));
}

void testStaticMap() {
    staticPrint(std::string("\n--- StaticMap Tests ---"));
    StaticMap<std::string, int64_t>* emptyMap = GC::allocateLocal(new StaticMap<std::string, int64_t>());
    assert(emptyMap->isEmpty());
    staticPrint(std::string("  ✓ Empty StaticMap"));
    StaticMap<std::string, int64_t>* map = ([&]() { auto* _m = StaticMap<std::string, int64_t>::empty(); _m->set(std::string("a"), 1LL); _m->set(std::string("b"), 2LL); _m->set(std::string("c"), 3LL); return _m; })();
    assert((map->length() == 3LL));
    assert(((*(*map)[std::string("a")]) == 1LL));
    assert(((*(*map)[std::string("b")]) == 2LL));
    assert(((*(*map)[std::string("c")]) == 3LL));
    staticPrint(std::string("  ✓ StaticMap.of"));
    map->set(std::string("d"), 4LL);
    assert((map->length() == 4LL));
    assert(((*(*map)[std::string("d")]) == 4LL));
    map->set(std::string("a"), 10LL);
    assert(((*(*map)[std::string("a")]) == 10LL));
    assert((map->length() == 4LL));
    staticPrint(std::string("  ✓ StaticMap operator[]="));
    assert(map->containsKey(std::string("b")));
    assert(!(map->containsKey(std::string("z"))));
    assert(map->containsValue(2LL));
    assert(!(map->containsValue(99LL)));
    staticPrint(std::string("  ✓ StaticMap containsKey/containsValue"));
    int64_t removed = dynAs<int64_t>(_box(map->remove(std::string("b"))));
    assert((removed == 2LL));
    assert((map->length() == 3LL));
    assert(!(map->containsKey(std::string("b"))));
    staticPrint(std::string("  ✓ StaticMap remove"));
    assert((map->keys()->length() == 3LL));
    assert((map->values()->length() == 3LL));
    staticPrint(std::string("  ✓ StaticMap keys/values"));
    assert((dart_isNull((*map)[std::string("nonexistent")])));
    staticPrint(std::string("  ✓ StaticMap null for missing key"));
    StaticMap<std::string, int64_t>* simpleMap = ([&]() { auto* _m = StaticMap<std::string, int64_t>::empty(); _m->set(std::string("x"), 1LL); return _m; })();
    assert((simpleMap->toString() == std::string("{x: 1}")));
    staticPrint(std::string("  ✓ StaticMap toString"));
}

void testStaticSet() {
    staticPrint(std::string("\n--- StaticSet Tests ---"));
    StaticSet<int64_t>* emptySet = GC::allocateLocal(new StaticSet<int64_t>());
    assert(emptySet->isEmpty());
    staticPrint(std::string("  ✓ Empty StaticSet"));
    StaticSet<int64_t>* set_ = GC::allocateLocal(new StaticSet<int64_t>({1LL, 2LL, 3LL, 2LL, 1LL}));
    assert((set_->length() == 3LL));
    assert(set_->contains(1LL));
    assert(set_->contains(2LL));
    assert(set_->contains(3LL));
    staticPrint(std::string("  ✓ StaticSet.of with deduplication"));
    bool added = set_->add(4LL);
    assert((added == true));
    assert((set_->length() == 4LL));
    bool notAdded = set_->add(2LL);
    assert((notAdded == false));
    assert((set_->length() == 4LL));
    staticPrint(std::string("  ✓ StaticSet add uniqueness"));
    set_->remove(3LL);
    assert((set_->length() == 3LL));
    assert(!(set_->contains(3LL)));
    staticPrint(std::string("  ✓ StaticSet remove"));
    StaticSet<int64_t>* setA = GC::allocateLocal(new StaticSet<int64_t>({1LL, 2LL, 3LL}));
    StaticSet<int64_t>* setB = GC::allocateLocal(new StaticSet<int64_t>({3LL, 4LL, 5LL}));
    StaticSet<int64_t>* unionSet = setA->unionSet(setB);
    assert((unionSet->length() == 5LL));
    staticPrint(std::string("  ✓ StaticSet union"));
    StaticSet<int64_t>* interSet = setA->intersection(setB);
    assert((interSet->length() == 1LL));
    assert(interSet->contains(3LL));
    staticPrint(std::string("  ✓ StaticSet intersection"));
    StaticSet<int64_t>* diffSet = setA->difference(setB);
    assert((diffSet->length() == 2LL));
    assert(diffSet->contains(1LL));
    assert(diffSet->contains(2LL));
    assert(!(diffSet->contains(3LL)));
    staticPrint(std::string("  ✓ StaticSet difference"));
    StaticSet<std::string>* strSet = GC::allocateLocal(new StaticSet<std::string>({std::string("a"), std::string("b")}));
    assert((strSet->toString() == std::string("{a, b}")));
    staticPrint(std::string("  ✓ StaticSet toString"));
}


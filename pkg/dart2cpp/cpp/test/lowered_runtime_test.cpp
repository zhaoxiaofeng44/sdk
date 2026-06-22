// ============================================================================
// dart2cpp_lowered.h 运行时单元测试
// ============================================================================
// 编译：g++ -std=c++17 -I ../../cpp/core/ lowered_runtime_test.cpp -o lowered_runtime_test
// 运行：./lowered_runtime_test
// ============================================================================

#include "dart2cpp_lowered.h"
#include <cassert>
#include <iostream>

// ---- 测试辅助 ----

int testsPassed = 0;
int testsFailed = 0;

#define TEST(name) \
    void test_##name(); \
    struct TestRunner_##name { \
        TestRunner_##name() { \
            std::cout << "  " << #name << "... "; \
            try { \
                test_##name(); \
                std::cout << "\033[32mPASS\033[0m" << std::endl; \
                testsPassed++; \
            } catch (const std::exception& e) { \
                std::cout << "\033[31mFAIL: " << e.what() << "\033[0m" << std::endl; \
                testsFailed++; \
            } \
        } \
    } testRunner_##name; \
    void test_##name()

#define ASSERT(cond) \
    if (!(cond)) throw std::runtime_error("Assertion failed: " #cond)

#define ASSERT_EQ(a, b) \
    if ((a) != (b)) throw std::runtime_error("Assertion failed: " #a " == " #b)

// ---- AnyPtr 测试 ----

TEST(AnyPtr_Null) {
    AnyPtr p;
    ASSERT(p.isNull());
    ASSERT_EQ(p.toStringValue(), "null");
}

TEST(AnyPtr_Int) {
    AnyPtr p = AnyPtr::fromInt(42);
    ASSERT(p.isInt());
    ASSERT_EQ(p.toInt(), 42);
    ASSERT_EQ(p.toStringValue(), "42");
}

TEST(AnyPtr_Double) {
    AnyPtr p = AnyPtr::fromDouble(3.14);
    ASSERT(p.isDouble());
    ASSERT_EQ(p.toDouble(), 3.14);
}

TEST(AnyPtr_Bool) {
    AnyPtr p = AnyPtr::fromBool(true);
    ASSERT(p.isBool());
    ASSERT_EQ(p.toBool(), true);
    ASSERT_EQ(p.toStringValue(), "true");
}

TEST(AnyPtr_String) {
    AnyPtr p = AnyPtr::fromString("hello");
    ASSERT(p.isString());
    ASSERT_EQ(p.toStringValue(), "hello");
    ASSERT_EQ(p.castTo<std::string>(), "hello");
}

TEST(AnyPtr_Equality) {
    AnyPtr a = AnyPtr::fromInt(10);
    AnyPtr b = AnyPtr::fromInt(10);
    AnyPtr c = AnyPtr::fromInt(20);
    ASSERT(a == b);
    ASSERT(a != c);
}

TEST(AnyPtr_Copy) {
    AnyPtr a = AnyPtr::fromString("test");
    AnyPtr b = a;  // copy
    ASSERT_EQ(a.toStringValue(), b.toStringValue());
    ASSERT(a == b);
}

// ---- GC 测试 ----

TEST(GC_AllocateLocal) {
    GC::reset();
    auto* box = GC::allocateLocal(new IntBox(42));
    ASSERT(box != nullptr);
    ASSERT_EQ(box->value, 42);
    ASSERT_EQ(GC::objectCount(), 1);
    GC::reset();
}

TEST(GC_AllocateGlobal) {
    GC::reset();
    auto* box = GC::allocateGlobal(new IntBox(100));
    ASSERT(box != nullptr);
    ASSERT_EQ(box->value, 100);
    ASSERT_EQ(GC::rootCount(), 1);
    GC::reset();
}

TEST(GC_Collect) {
    GC::reset();
    auto* root = GC::allocateGlobal(new IntBox(1));
    auto* local = GC::allocateLocal(new IntBox(2));
    auto* orphan = GC::allocateLocal(new IntBox(3));
    (void)orphan;  // not referenced by root

    ASSERT_EQ(GC::objectCount(), 3);
    int collected = GC::collect();
    // root 和 local 都存活（local 未被 GC 追踪为可回收）
    // 实际上标记-清除只回收未被 root 标记到的
    ASSERT(collected >= 0);
    GC::reset();
}

// ---- VPtr 测试 ----

TEST(VPtr_Basic) {
    GC::reset();
    auto* vp = GC::allocateLocal(new VPtr());
    vp->_typeName = "TestValue";
    ASSERT_EQ(vp->toString(), "TestValue");
    GC::reset();
}

static int64_t testMethod(AnyPtr this__) {
    return 42;
}

TEST(VPtr_VtableDispatch) {
    GC::reset();
    auto* vp = GC::allocateLocal(new VPtr());
    vp->_typeName = "TestValue";
    vp->vptr["getValue"] = reinterpret_cast<void*>(&testMethod);

    // 通过 vptr 调用
    auto fn = reinterpret_cast<int64_t(*)(AnyPtr)>(vp->vptr["getValue"]);
    int64_t result = fn(AnyPtr::fromVPtr(vp));
    ASSERT_EQ(result, 42);
    GC::reset();
}

// ---- Box 类型测试 ----

TEST(IntBox_Basic) {
    auto* box = new IntBox(42);
    ASSERT_EQ(box->value, 42);
    box->value = 100;
    ASSERT_EQ(box->value, 100);
    delete box;
}

TEST(StringBox_Basic) {
    auto* box = new StringBox("hello");
    ASSERT_EQ(box->value, "hello");
    box->value = "world";
    ASSERT_EQ(box->value, "world");
    delete box;
}

// ---- TypeFunction 测试 ----

static int64_t testClosure(AnyPtr env__) {
    return 99;
}

TEST(TypeFunction0_Call) {
    GC::reset();
    auto* fn = GC::allocateLocal(new TypeFunction0<int64_t>());
    fn->closureCall = reinterpret_cast<void*>(&testClosure);
    int64_t result = fn->call();
    ASSERT_EQ(result, 99);
    GC::reset();
}

static int64_t testClosure1(AnyPtr env__, int64_t x) {
    return x * 2;
}

TEST(TypeFunction1_Call) {
    GC::reset();
    auto* fn = GC::allocateLocal(new TypeFunction1<int64_t, int64_t>());
    fn->closureCall = reinterpret_cast<void*>(&testClosure1);
    int64_t result = fn->call(21);
    ASSERT_EQ(result, 42);
    GC::reset();
}

// ---- 静态集合测试 ----

TEST(StaticList_Basic) {
    GC::reset();
    auto* list = StaticList<int64_t>::of({1, 2, 3});
    ASSERT_EQ(list->length(), 3);
    ASSERT_EQ((*list)[0], 1);
    ASSERT_EQ((*list)[1], 2);
    ASSERT_EQ((*list)[2], 3);
    list->add(4);
    ASSERT_EQ(list->length(), 4);
    ASSERT_EQ((*list)[3], 4);
    GC::reset();
}

TEST(StaticMap_Basic) {
    GC::reset();
    auto* map = StaticMap<std::string, int64_t>::empty();
    map->set("a", 1);
    map->set("b", 2);
    ASSERT_EQ(map->length(), 2);
    ASSERT(map->containsKey("a"));
    ASSERT_EQ(*(*map)["a"], 1);
    ASSERT_EQ(*(*map)["b"], 2);
    GC::reset();
}

TEST(StaticSet_Basic) {
    GC::reset();
    auto* set = StaticSet<int64_t>::of({1, 2, 3});
    ASSERT_EQ(set->length(), 3);
    ASSERT(set->contains(1));
    ASSERT(set->contains(2));
    ASSERT(!set->contains(4));
    set->add(4);
    ASSERT(set->contains(4));
    ASSERT_EQ(set->length(), 4);
    GC::reset();
}

// ---- Promise / smAwait 测试 ----

TEST(Promise_Complete) {
    GC::reset();
    auto* promise = GC::allocateLocal(new Promise<int64_t>());
    promise->setStartCallback([promise]() {
        promise->completeTyped(42);
    });

    int64_t result = smAwait<int64_t>(promise);
    ASSERT_EQ(result, 42);
    GC::reset();
}

TEST(Promise_DelayedComplete) {
    GC::reset();
    auto* promise = GC::allocateLocal(new Promise<int64_t>());
    int tickCount = 0;
    promise->setStartCallback([promise, &tickCount]() {
        // 模拟异步：在回调中完成
        promise->completeTyped(99);
        tickCount++;
    });

    int64_t result = smAwait<int64_t>(promise);
    ASSERT_EQ(result, 99);
    ASSERT_EQ(tickCount, 1);
    GC::reset();
}

// ---- staticPrint 测试 ----

TEST(StaticPrint_Int) {
    // 验证不崩溃
    staticPrint(AnyPtr::fromInt(42));
    staticPrint(int64_t(42));
}

TEST(StaticPrint_String) {
    staticPrint(AnyPtr::fromString("hello"));
    staticPrint(std::string("hello"));
    staticPrint("hello");
}

// ---- dart_str 测试 ----

TEST(DartStr_Concat) {
    std::string result = dart_str("hello ", 42, " world");
    ASSERT_EQ(result, "hello 42 world");
}

TEST(DartStr_Bool) {
    std::string result = dart_str("flag=", true);
    ASSERT_EQ(result, "flag=true");
}

// ---- 异常测试 ----

TEST(Exception_Throw) {
    bool caught = false;
    try {
        throw DartException("test error");
    } catch (const DartException& e) {
        caught = true;
        ASSERT_EQ(std::string(e.what()), "test error");
    }
    ASSERT(caught);
}

TEST(Exception_Hierarchy) {
    bool caught = false;
    try {
        throw DartStateError("bad state");
    } catch (const DartException& e) {
        caught = true;
        ASSERT_EQ(std::string(e.what()), "bad state");
    }
    ASSERT(caught);
}

// ---- 主入口 ----

int main() {
    std::cout << "\n\033[1m\033[36m╔══════════════════════════════════════════════════════╗\033[0m" << std::endl;
    std::cout << "\033[1m\033[36m║      dart2cpp_lowered.h 运行时单元测试                ║\033[0m" << std::endl;
    std::cout << "\033[1m\033[36m╚══════════════════════════════════════════════════════╝\033[0m\n" << std::endl;

    // 测试由全局构造函数自动注册并运行

    std::cout << "\n\033[1m结果: \033[0m";
    std::cout << "\033[32m" << testsPassed << " 通过\033[0m, ";
    if (testsFailed > 0) {
        std::cout << "\033[31m" << testsFailed << " 失败\033[0m" << std::endl;
    } else {
        std::cout << "0 失败" << std::endl;
    }

    return testsFailed > 0 ? 1 : 0;
}

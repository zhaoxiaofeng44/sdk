#include "dart2cpp_lowered.h"

Promise<std::string>* greetAsync(std::string name);
Promise<std::string>* chainAsync(std::string prefix);
Promise<std::string>* multiAwait(std::string a, std::string b);
Promise<std::string>* tryCatchAsync(std::string input);
Promise<std::string>* conditionalAsync(bool flag);
int main();

Promise<std::string>* greetAsync(std::string name) {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    _promise->complete(_box(dart_str(std::string("hello ")) + dart_str(name)));
    return _promise;
}

Promise<std::string>* chainAsync(std::string prefix) {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    std::string greeting = smAwait<std::string>(greetAsync(std::string("world")));
    _promise->complete(_box(dart_str(prefix) + dart_str(std::string(": ")) + dart_str(greeting)));
    return _promise;
}

Promise<std::string>* multiAwait(std::string a, std::string b) {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    std::string r1 = smAwait<std::string>(greetAsync(a));
    std::string r2 = smAwait<std::string>(greetAsync(b));
    _promise->complete(_box(dart_str(r1) + dart_str(std::string(" and ")) + dart_str(r2)));
    return _promise;
}

Promise<std::string>* tryCatchAsync(std::string input) {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    try {
        if ((input == std::string("fail"))) {
            throw DartException(std::string("expected failure"));
        }
        std::string result = smAwait<std::string>(greetAsync(input));
        _promise->complete(_box(dart_str(std::string("ok: ")) + dart_str(result)));
        return _promise;
    } catch (const DartException& e) {
        _promise->complete(_box(dart_str(std::string("caught: ")) + dart_str(e)));
        return _promise;
    }
}

Promise<std::string>* conditionalAsync(bool flag) {
    auto _promise = GC::allocateLocal(new Promise<std::string>());
    if (flag) {
        _promise->complete(_box(smAwait<std::string>(greetAsync(std::string("yes")))));
        return _promise;
    } else {
        _promise->complete(_box(smAwait<std::string>(greetAsync(std::string("no")))));
        return _promise;
    }
}

int main() {
    staticPrint(std::string("=== async/await 转换验证测试 ===\n"));
    staticPrint(std::string("--- 1. 基础 async 函数 ---"));
    std::string v1 = smAwait<std::string>(greetAsync(std::string("dart")));
    assert((v1 == std::string("hello dart")));
    staticPrint(dart_str(std::string("  ✓ greetAsync(\"dart\") = \"")) + dart_str(v1) + dart_str(std::string("\"")));
    staticPrint(std::string("\n--- 2. 串行 await ---"));
    std::string v2 = smAwait<std::string>(chainAsync(std::string("prefix")));
    assert((v2 == std::string("prefix: hello world")));
    staticPrint(dart_str(std::string("  ✓ chainAsync(\"prefix\") = \"")) + dart_str(v2) + dart_str(std::string("\"")));
    staticPrint(std::string("\n--- 3. 多个 await ---"));
    std::string v3 = smAwait<std::string>(multiAwait(std::string("alice"), std::string("bob")));
    assert((v3 == std::string("hello alice and hello bob")));
    staticPrint(dart_str(std::string("  ✓ multiAwait(\"alice\",\"bob\") = \"")) + dart_str(v3) + dart_str(std::string("\"")));
    staticPrint(std::string("\n--- 4. try-catch 中的 await ---"));
    std::string v4a = smAwait<std::string>(tryCatchAsync(std::string("ok_input")));
    assert((v4a == std::string("ok: hello ok_input")));
    staticPrint(dart_str(std::string("  ✓ tryCatchAsync(\"ok_input\") = \"")) + dart_str(v4a) + dart_str(std::string("\"")));
    std::string v4b = smAwait<std::string>(tryCatchAsync(std::string("fail")));
    assert((v4b == std::string("caught: Exception: expected failure")));
    staticPrint(dart_str(std::string("  ✓ tryCatchAsync(\"fail\") = \"")) + dart_str(v4b) + dart_str(std::string("\"")));
    staticPrint(std::string("\n--- 5. 条件分支中的 await ---"));
    std::string v5a = smAwait<std::string>(conditionalAsync(true));
    std::string v5b = smAwait<std::string>(conditionalAsync(false));
    assert((v5a == std::string("hello yes")));
    assert((v5b == std::string("hello no")));
    staticPrint(dart_str(std::string("  ✓ conditionalAsync(true) = \"")) + dart_str(v5a) + dart_str(std::string("\"")));
    staticPrint(dart_str(std::string("  ✓ conditionalAsync(false) = \"")) + dart_str(v5b) + dart_str(std::string("\"")));
    staticPrint(std::string("\n=== ✅ 全部 5 个 async/await 测试通过！ ==="));
    return 0;
}


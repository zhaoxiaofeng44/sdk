#include <iostream>
#include <functional>
#include <vector>

// 简化的 Any 类型
struct Any {
    int type_id;
    union ValueUnion {
        int int_value;
        ValueUnion() : int_value(0) {}
        ValueUnion(int v) : int_value(v) {}
    } value;
    
    Any() : type_id(0) { value.int_value = 0; }
    Any(int v) : type_id(1) { value.int_value = v; }
};

// 简化的 Int 类型
struct Int : public Any {
    Int() : Any() { type_id = 1; }
    Int(int v) : Any(v) { type_id = 1; }
    
    int getValue() const { return value.int_value; }
};

// Function 基类
class Function {
public:
    virtual ~Function() {}
    virtual Any apply(const std::vector<Any>& args) = 0;
};

// TypedFunction 模板类
template<typename R, typename... Args>
class TypedFunction : public Function {
private:
    std::function<R(Args...)> func_;
    
public:
    TypedFunction(std::function<R(Args...)> func) : func_(std::move(func)) {}
    
    Any apply(const std::vector<Any>& args) override {
        if (args.size() != sizeof...(Args)) {
            throw std::runtime_error("Argument count mismatch");
        }
        return callImpl(args, std::index_sequence_for<Args...>{});
    }
    
private:
    template<std::size_t... I>
    Any callImpl(const std::vector<Any>& args, std::index_sequence<I...>) {
        if constexpr (std::is_same_v<R, Int>) {
            return Any(func_(Int(args[I].value.int_value)...).getValue());
        } else {
            func_(Int(args[I].value.int_value)...);
            return Any(); // 返回空Any
        }
    }
};

// 静态工厂方法
template<typename Ret, typename... Arguments>
Function* makeFunction(std::function<Ret(Arguments...)> func) {
    return new TypedFunction<Ret, Arguments...>(std::move(func));
}

template<typename Ret, typename... Arguments>
Function* makeFunction(Ret (*func)(Arguments...)) {
    return makeFunction(std::function<Ret(Arguments...)>(func));
}

template<typename F>
Function* makeFunction(F&& lambda) {
    return makeFunction(std::function(std::forward<F>(lambda)));
}

// 测试函数
Int add(Int a, Int b) {
    return Int(a.getValue() + b.getValue());
}

Int calculate(Int a, Int b, Function* operation) {
    return Int(operation->apply({a, b}).value.int_value);
}

int main() {
    try {
        // 测试普通函数
        auto result1 = calculate(Int(10), Int(5), makeFunction(&add));
        std::cout << "10 + 5 = " << result1.getValue() << std::endl;
        
        // 测试 lambda
        auto multiply = makeFunction([](Int a, Int b) -> Int {
            return Int(a.getValue() * b.getValue());
        });
        auto result2 = calculate(Int(10), Int(5), multiply);
        std::cout << "10 * 5 = " << result2.getValue() << std::endl;
        
        delete multiply;
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}
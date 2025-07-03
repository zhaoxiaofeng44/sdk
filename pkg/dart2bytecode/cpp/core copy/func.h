#ifndef _FUNC_H_
#define _FUNC_H_

#include <any>
#include <functional>
#include <tuple>

// 前向声明
class Object;
class ProcedureFunc;
template <typename ThisPtr, typename R, typename... Args>
class ProcedureWrapper;
class Function;

#include "object.h"

class Function : public Object {
public:
    enum Type { Normal,
                Procedure,
                Closure,
                Unkown };
    virtual Type getType() const = 0;
};

template <typename R, typename... Args>
class FunctionApply : public Function {

    virtual R operator()(Args... args) const = 0;
};

// 过程函数：绑定了this指针的成员函数
template <typename ThisPtr, typename R, typename... Args>
class ProcedureWrapper : public FunctionApply<R, Args...> {

    ThisPtr *owner;
    int index;

public:
    ProcedureWrapper(ThisPtr t, int i) : owner(t), index(i) {}

    virtual ~ProcedureWrapper() = default;

    virtual Function::Type getType() const { return Function::Type::Procedure; }

    virtual R operator()(Args... args) const {
        return reinterpret_cast<R (*)(ThisPtr, Args...)>(owner->vtab[index])(
            reinterpret_cast<ThisPtr>(owner), args...);
    }
};

// 闭包函数：带捕获变量的函数
template <typename R, typename... Args>
class ClosureWrapper : public FunctionApply<R, Args...> {
  
    Object **array;
    int length;
    R (*ptr)(Args...);

public:
    ClosureWrapper(Object **array, int length, R (*ptr)(Args...))
        : array(array), length(length), ptr(ptr) {}

    virtual ~ClosureWrapper() = default;

    virtual Function::Type getType() const { return Function::Type::Closure; }

    virtual R operator()(Args... args) const { return ptr(args...); }
};

template <typename R, typename... Args>
class FunctionWrapper : public FunctionApply<R, Args...> {
    R (*ptr)(Args...);

public:
    FunctionWrapper(R (*ptr)(Args...)) : ptr(ptr) {}

    virtual ~FunctionWrapper() = default;

    virtual Function::Type getType() const { return Function::Type::Normal; }

    virtual R operator()(Args... args) const { return ptr(args...); }
};

template <typename R, typename... Args>
static R cppApply(Function *wrapper, Args... args) {
    if (!wrapper)
        return R{};

    FunctionApply<R, Args...> *func = reinterpret_cast<FunctionApply<R, Args...> *>(wrapper);
    return func->operator()(args...);
}

template <typename ThisPtr, typename R, typename... Args>
static R cppApply(ThisPtr *thisPtr, int index, Args... args) {
    ProcedureWrapper<ThisPtr, R, Args...> wrapper(thisPtr, index);
    return wrapper(args...);
}

#endif // _FUNC_H_

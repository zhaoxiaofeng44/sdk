#ifndef _FUNC_H_
#define _FUNC_H_

#include <any>
#include <functional>
#include <tuple>
#include "object.h"

// 前向声明
class ProcedureFunc;
template <typename ThisPtr, typename R, typename... Args>
class ProcedureWrapper;
class Function;

class Function : public Object {
 public:
  enum Type { Normal, Procedure, Closure, Unkown, Lambda };
  virtual Type getType() const = 0;
};

template <typename R, typename... Args>
class FunctionApply : public Function {
 public:
  virtual R operator()(Args... args) const = 0;
};

// 过程函数：绑定了this指针的成员函数
template <typename ThisPtr, typename R, typename... Args>
class ProcedureWrapper : public FunctionApply<R, Args...> {
  ThisPtr* owner;
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
  Object** array;
  int length;
  R (*ptr)(Args...);

 public:
  ClosureWrapper(Object** array, int length, R (*ptr)(Args...))
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
class LambdaWrapper : public FunctionApply<R, Args...> {
  std::function<R(Args...)> func;

 public:
  LambdaWrapper(std::function<R(Args...)> func) : func(func) {}

  virtual ~LambdaWrapper() = default;

  virtual Function::Type getType() const { return Function::Type::Lambda; }

  virtual R operator()(Args... args) const { return func(args...); }
};

// template <typename R, typename... Args>
// static R cppApply(Function *wrapper, Args... args) {
//     if (!wrapper)
//         return R{};

//     FunctionApply<R, Args...> *func = reinterpret_cast<FunctionApply<R, Args...> *>(wrapper);
//     return func(args...);
// }

// template <typename R, typename... Args>
// static R cppApply(R(*func)(Args... args),Args... args) {
//     return func(args...);
// }

// template <typename ThisPtr, typename R, typename... Args>
// static R cppApply(ThisPtr *thisPtr, int index, Args... args) {
//     ProcedureWrapper<ThisPtr, R, Args...> wrapper(thisPtr, index);
//     return wrapper(args...);
// }

template <typename R, typename... Args>
inline static R cppApply(Function* wrapper, Args... args) {
  if constexpr (std::is_void<R>::value) {
    // void时什么都不返回
    (*reinterpret_cast<FunctionApply<R, Args...>*>(wrapper))(args...);
    return;
  } else {
    return (*reinterpret_cast<FunctionApply<R, Args...>*>(wrapper))(
        args...);  // 或者 return R{};
  }
}

template <typename R, typename... Args>
inline static R cppApply(Object* thisPtr, String* name, Args... args) {
  using FuncType = R (*)(Object*, Args...);
  FuncType func;
  ObjectImp* objImp = reinterpret_cast<ObjectImp*>(thisPtr);
  if (objImp && objImp->ptrs) {
    // 调用成员函数
    auto it = objImp->ptrs->find(name);
    if (it != objImp->ptrs->end()) {
      func = reinterpret_cast<FuncType>(it->second);
    }
  }
  if constexpr (std::is_void<R>::value) {
    // void时什么都不返回
    func(thisPtr, args...);
  } else {
    return func(thisPtr, args...);
  }
}

#endif  // _FUNC_H_

#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: MyTest
// ============================================================================

class MyTest {
public:
  Int a;
  Int b;
  MyTest(Int a, Int b) : a(a), b(b) {
  }
  
  Nullable testA() {
    return Void;
  }
  
  Int getgg() {
    return (this->a + this->b);
  }
  
};

// ============================================================================
// 类: MyTest2
// ============================================================================

class MyTest2 : DART_IMPLEMENTS(MyTest) {
public:
  MyTest2(Int a, Int b) {
    this->a = a;
this->b = b;
  }
  
  Any noSuchMethod(Invocation invocation) {
    dart_print(invocation);
return super::noSuchMethod(invocation);
  }
  
  Int a() {
    return dart_cast<Int>(this->noSuchMethod(ObjectPtr<_InvocationMirror>(new _InvocationMirror(/* Constant: SymbolConstant */, dart_int(1), List<Type>::createConst({}), List<Any>::createConst({}), Map::unmodifiable(Map<Symbol, Any>::createConst())))));
  }
  
  Nullable a(Int value) {
    return this->noSuchMethod(ObjectPtr<_InvocationMirror>(new _InvocationMirror(/* Constant: SymbolConstant */, dart_int(2), List<Type>::createConst({}), List::unmodifiable(dart_literal(value)), Map::unmodifiable(Map<Symbol, Any>::createConst()))));
  }
  
  Int b() {
    return dart_cast<Int>(this->noSuchMethod(ObjectPtr<_InvocationMirror>(new _InvocationMirror(/* Constant: SymbolConstant */, dart_int(1), List<Type>::createConst({}), List<Any>::createConst({}), Map::unmodifiable(Map<Symbol, Any>::createConst())))));
  }
  
  Nullable b(Int value) {
    return this->noSuchMethod(ObjectPtr<_InvocationMirror>(new _InvocationMirror(/* Constant: SymbolConstant */, dart_int(2), List<Type>::createConst({}), List::unmodifiable(dart_literal(value)), Map::unmodifiable(Map<Symbol, Any>::createConst()))));
  }
  
  Nullable testA() {
    return this->noSuchMethod(ObjectPtr<_InvocationMirror>(new _InvocationMirror(/* Constant: SymbolConstant */, dart_int(0), List<Type>::createConst({}), List<Any>::createConst({}), Map::unmodifiable(Map<Symbol, Any>::createConst()))));
  }
  
  Int getgg() {
    return dart_cast<Int>(this->noSuchMethod(ObjectPtr<_InvocationMirror>(new _InvocationMirror(/* Constant: SymbolConstant */, dart_int(0), List<Type>::createConst({}), List<Any>::createConst({}), Map::unmodifiable(Map<Symbol, Any>::createConst())))));
  }
  
};

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 基础语法测试开始"));
auto myTest2 = ObjectPtr<MyTest2>(new MyTest2(dart_int(1), dart_int(3)));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

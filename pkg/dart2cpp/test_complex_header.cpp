#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Vector2D
// ============================================================================

class Vector2D {
public:
  Double x;
  Double y;
  Vector2D(Double x, Double y) : x(x), y(y) {
  }
  
  Double magnitude() {
    auto sum = this->x->operator_mul(this->x)->operator_add(this->y->operator_mul(this->y));
return MathExtension::sqrt(sum);
  }
  
  ObjectPtr<Vector2D> operator_add(ObjectPtr<Vector2D> other) {
    return ObjectPtr<Vector2D>(new Vector2D(this->x->operator_add(other->x), this->y->operator_add(other->y)));
  }
  
};

// ============================================================================
// 类: Container
// ============================================================================

template<typename T>
class Container {
public:
  T value;
  Container(T value) : value(value) {
  }
  
  T getValue() {
    return this->value;
  }
  
};

// ============================================================================
// Extension: MathExtension
// ============================================================================

namespace MathExtension {
  inline Double sqrt(Double this_) {
    if (this_->operator_less(dart_int(0))) {
return dart_double(0.0);
}
auto x = this_;
auto prev = dart_double(0.0);
while (x->operator_sub(prev)->abs()->operator_greater(dart_double(0.0001))) {
prev = x;
x = x->operator_add(this_->operator_div(x))->operator_div(dart_double(2.0));
}
return x;
  }
  
} // namespace MathExtension

// ============================================================================
// Extension: LetExtension
// ============================================================================

namespace LetExtension {
  template<typename T, typename R>
  inline R let(T this_, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> block) {
    return block->call(this_);
  }
  
} // namespace LetExtension

template<typename T>
T identity(T value);
Double MathExtension::sqrt(Double this_);
template<typename T, typename R>
R LetExtension::let(T this_, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> block);
template<typename T>
T identity(T value) {
  return value;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto v1 = ObjectPtr<Vector2D>(new Vector2D(dart_double(3.0), dart_double(4.0)));
dart_print(dart_string("Magnitude: ") + (v1->magnitude()).toString());
auto result = LetExtension::let(v1, makeFunction([&](ObjectPtr<Vector2D> v) { return v->magnitude(); }));
dart_print(dart_string("Let result: ") + (result).toString());
auto container = ObjectPtr<Container<ObjectPtr<Vector2D>>>(new Container<ObjectPtr<Vector2D>>(v1));
dart_print(dart_string("Container value magnitude: ") + (container->getValue()->magnitude()).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

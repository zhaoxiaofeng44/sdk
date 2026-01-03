#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Point
// ============================================================================

class Point {
public:
  Double x;
  Double y;
  Point(Double x, Double y) : x(x), y(y) {
  }
  
  Double distanceTo(ObjectPtr<Point> other) {
    auto distSquared = this->x->operator_sub(other->x)->operator_mul(this->x->operator_sub(other->x))->operator_add(this->y->operator_sub(other->y)->operator_mul(this->y->operator_sub(other->y)));
return MathExtension::sqrt(distSquared);
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

Double calculateDistance(ObjectPtr<Point> a, ObjectPtr<Point> b);
Double MathExtension::sqrt(Double this_);
Double calculateDistance(ObjectPtr<Point> a, ObjectPtr<Point> b) {
  return a->distanceTo(b);
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto p1 = ObjectPtr<Point>(new Point(dart_double(0.0), dart_double(0.0)));
auto p2 = ObjectPtr<Point>(new Point(dart_double(3.0), dart_double(4.0)));
dart_print(dart_string("Distance: ") + (calculateDistance(p1, p2)).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

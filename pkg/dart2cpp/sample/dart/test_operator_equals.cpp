#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Vector
// ============================================================================

class Vector {
public:
  Double x;
  Double y;
  Vector(Double x, Double y) : x(x), y(y) {
  }
  
  Bool operator_equals(ObjectPtr<Object> other) {
    return dart_is<ObjectPtr<Vector>>(other) && (this->x == dart_cast<ObjectPtr<Vector>>(other)->x) && (this->y == dart_cast<ObjectPtr<Vector>>(other)->y);
  }
  
  Int hashCode() {
    return Object::hash(this->x, this->y);
  }
  
};

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto v1 = ObjectPtr<Vector>(new Vector(dart_double(1.0), dart_double(2.0)));
auto v2 = ObjectPtr<Vector>(new Vector(dart_double(1.0), dart_double(2.0)));
auto v3 = ObjectPtr<Vector>(new Vector(dart_double(3.0), dart_double(4.0)));
dart_print(dart_string("v1 == v2: ") + ((v1 == v2)).toString());
dart_print(dart_string("v1 == v3: ") + ((v1 == v3)).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Builder
// ============================================================================

class Builder {
private:
  String _value = dart_string("");
public:
  Builder() {
  }
  
  ObjectPtr<Builder> add(String text) {
    this->_value = (this->_value + text);
return ObjectPtr<std::remove_reference_t<decltype(*this)>>(this);
  }
  
  String build() {
    return this->_value;
  }
  
};

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto builder = ObjectPtr<Builder>(new Builder())->add(dart_string("Hello"))->add(dart_string(" "))->add(dart_string("World"));
dart_print(builder->build());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto buffer = ObjectPtr<StringBuffer>(new StringBuffer());
buffer->write(dart_string("Hello"));
dart_print(buffer->toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

#include "dart2cpp.h"

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("开始测试异常处理"));
    
    // 测试正常的try-catch
    try {
      auto value1 = dart_int(42);
      dart_print(dart_string("值: ") + value1.toString());
    } catch (const std::exception& e) {
      dart_print(dart_string("捕获异常: ") + dart_string(e.what()));
    }
    
    // 测试另一个try-catch
    try {
      auto value2 = dart_string("Hello");
      dart_print(dart_string("字符串: ") + value2.toString());
    } catch (const std::exception& e) {
      dart_print(dart_string("捕获异常: ") + dart_string(e.what()));
    }
    
    dart_print(dart_string("✅ 异常处理测试成功"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
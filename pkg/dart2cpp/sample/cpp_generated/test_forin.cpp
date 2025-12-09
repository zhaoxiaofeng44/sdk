#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto fruits = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"));
dart_print(dart_string("For-in test:"));
auto sync_for_iterator = fruits->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto fruit = sync_for_iterator->next();
dart_print(fruit);
}
dart_print(dart_string("Done!"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

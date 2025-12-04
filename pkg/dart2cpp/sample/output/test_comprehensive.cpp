#include "dart2cpp.h"

// 工具宏定义

Int add(Int a, Int b);
Nullable greet(String name, String title = String(Null));
Int add(Int a, Int b) {
  return (a + b);
}

Nullable greet(String name, String title) {
  if (!(dart_is_null(title))) {
dart_print(dart_concat(dart_string("Hello, "), title, dart_string(" "), name, dart_string("!")));
} else {
dart_print(dart_concat(dart_string("Hello, "), name, dart_string("!")));
};
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("=== 综合测试 ==="));
auto result = add(dart_int(10), dart_int(20));
dart_print(dart_concat(dart_string("Add result: "), result));
greet(dart_string("Alice"));
greet(dart_string("Bob"), dart_string("Mr."));
auto items = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"));
dart_print(dart_string("\\nFor-in loop:"));
auto sync_for_iterator = items->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto item = sync_for_iterator->next();
dart_print(dart_concat(dart_string("  - "), item));
}
dart_print(dart_string("\\n✅ 所有测试通过！"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

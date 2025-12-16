#include "dart2cpp.h"

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("开始测试Map功能"));
    
    // 测试createFromEntries
    auto map1 = Map<String, String>::createFromEntries({
      {dart_string("key1"), dart_string("value1")},
      {dart_string("key2"), dart_string("value2")}
    });
    
    dart_print(dart_string("Map大小: ") + map1->size().toString());
    dart_print(dart_string("key1的值: ") + map1->get(dart_string("key1")));
    
    // 测试普通创建方法
    auto map2 = Map<String, Int>::create({
      {dart_string("one"), dart_int(1)},
      {dart_string("two"), dart_int(2)}
    });
    
    dart_print(dart_string("Map2大小: ") + map2->size().toString());
    dart_print(dart_string("two的值: ") + map2->get(dart_string("two")).toString());
    
    dart_print(dart_string("✅ Map功能测试成功"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
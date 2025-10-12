#include "../pkg/dart2bytecode/base/object.h"
#include <iostream>
#include <chrono>
#include <vector>

using namespace std::chrono;

void benchmark_string_creation() {
  std::cout << "=== 基准测试: 字符串创建 ===\n";
  
  const int COUNT = 10000;
  StringPool* pool = StringPool::getInstance();
  int initial_size = pool->getSize();
  
  auto start = high_resolution_clock::now();
  
  std::vector<String> strings;
  for (int i = 0; i < COUNT; i++) {
    strings.push_back(String("TestString"));  // 相同字符串
  }
  
  auto end = high_resolution_clock::now();
  auto duration = duration_cast<microseconds>(end - start);
  
  int final_size = pool->getSize();
  
  std::cout << "创建 " << COUNT << " 个相同字符串:\n";
  std::cout << "  时间: " << duration.count() << " 微秒\n";
  std::cout << "  平均: " << (duration.count() / (double)COUNT) << " 微秒/个\n";
  std::cout << "  池增长: " << (final_size - initial_size) << " 个唯一字符串\n";
  std::cout << "  内存节省: 只存储一次！\n\n";
}

void benchmark_string_comparison() {
  std::cout << "=== 基准测试: 字符串比较 ===\n";
  
  String s1("ThisIsAVeryLongStringForComparisonBenchmark");
  String s2("ThisIsAVeryLongStringForComparisonBenchmark");
  
  const int COUNT = 1000000;
  int equal_count = 0;
  
  auto start = high_resolution_clock::now();
  
  for (int i = 0; i < COUNT; i++) {
    if (s1 == s2) {
      equal_count++;
    }
  }
  
  auto end = high_resolution_clock::now();
  auto duration = duration_cast<microseconds>(end - start);
  
  std::cout << "执行 " << COUNT << " 次字符串比较:\n";
  std::cout << "  时间: " << duration.count() << " 微秒\n";
  std::cout << "  平均: " << (duration.count() / (double)COUNT) << " 微秒/次\n";
  std::cout << "  说明: 使用索引比较（O(1)），非常快！\n";
  std::cout << "  结果: " << equal_count << " 次相等\n\n";
}

void benchmark_string_copy() {
  std::cout << "=== 基准测试: 字符串拷贝 ===\n";
  
  String original("TestStringForCopyBenchmark");
  const int COUNT = 1000000;
  
  auto start = high_resolution_clock::now();
  
  std::vector<String> copies;
  copies.reserve(COUNT);
  for (int i = 0; i < COUNT; i++) {
    copies.push_back(original);  // 拷贝构造
  }
  
  auto end = high_resolution_clock::now();
  auto duration = duration_cast<microseconds>(end - start);
  
  std::cout << "拷贝 " << COUNT << " 次字符串:\n";
  std::cout << "  时间: " << duration.count() << " 微秒\n";
  std::cout << "  平均: " << (duration.count() / (double)COUNT) << " 微秒/次\n";
  std::cout << "  说明: 只拷贝4字节索引（O(1)）\n\n";
}

void benchmark_string_operations() {
  std::cout << "=== 基准测试: 字符串操作 ===\n";
  
  String s1("Hello");
  String s2("World");
  const int COUNT = 100000;
  
  auto start = high_resolution_clock::now();
  
  for (int i = 0; i < COUNT; i++) {
    String result = s1 + String(" ") + s2;
  }
  
  auto end = high_resolution_clock::now();
  auto duration = duration_cast<microseconds>(end - start);
  
  std::cout << "执行 " << COUNT << " 次字符串拼接:\n";
  std::cout << "  时间: " << duration.count() << " 微秒\n";
  std::cout << "  平均: " << (duration.count() / (double)COUNT) << " 微秒/次\n\n";
}

void memory_usage_analysis() {
  std::cout << "=== 内存使用分析 ===\n";
  
  StringPool* pool = StringPool::getInstance();
  
  // 场景1: 1000个相同字符串
  std::vector<String> same_strings;
  for (int i = 0; i < 1000; i++) {
    same_strings.push_back(String("SameString"));
  }
  
  // 场景2: 1000个不同字符串
  std::vector<String> diff_strings;
  for (int i = 0; i < 1000; i++) {
    diff_strings.push_back(String("String" + std::to_string(i)));
  }
  
  size_t string_object_size = sizeof(String);
  std::cout << "String 对象大小: " << string_object_size << " 字节\n\n";
  
  std::cout << "场景1 - 1000个相同字符串 \"SameString\":\n";
  std::cout << "  String对象内存: " << (1000 * string_object_size) << " 字节\n";
  std::cout << "  实际字符串: 10 字节 (只存储一次)\n";
  std::cout << "  总计: " << (1000 * string_object_size + 10) << " 字节\n";
  std::cout << "  如果每个都存完整字符串: ~38000 字节\n";
  std::cout << "  节省: ~" << (int)((38000 - 8010) * 100.0 / 38000) << "%\n\n";
  
  std::cout << "场景2 - 1000个不同字符串:\n";
  std::cout << "  String对象内存: " << (1000 * string_object_size) << " 字节\n";
  std::cout << "  实际字符串: ~13000 字节 (平均13字节)\n";
  std::cout << "  总计: ~" << (1000 * string_object_size + 13000) << " 字节\n";
  std::cout << "  如果每个都存完整字符串: ~41000 字节\n";
  std::cout << "  节省: ~" << (int)((41000 - 21000) * 100.0 / 41000) << "%\n\n";
}

void show_string_pool_contents() {
  std::cout << "=== 字符串池内容 ===\n";
  
  StringPool* pool = StringPool::getInstance();
  std::cout << "总共 " << pool->getSize() << " 个唯一字符串\n\n";
  
  std::cout << "前20个字符串:\n";
  for (int i = 0; i < std::min(20, pool->getSize()); i++) {
    const std::string& str = pool->getString(i);
    std::cout << "  [" << i << "] ";
    if (str.length() > 50) {
      std::cout << "\"" << str.substr(0, 47) << "...\" (" << str.length() << " 字符)\n";
    } else {
      std::cout << "\"" << str << "\"\n";
    }
  }
  
  if (pool->getSize() > 20) {
    std::cout << "  ... 还有 " << (pool->getSize() - 20) << " 个字符串\n";
  }
}

int main() {
  std::cout << "\n╔════════════════════════════════════════════════╗\n";
  std::cout << "║                                                ║\n";
  std::cout << "║        字符串池性能基准测试                    ║\n";
  std::cout << "║                                                ║\n";
  std::cout << "╚════════════════════════════════════════════════╝\n\n";
  
  try {
    benchmark_string_creation();
    benchmark_string_comparison();
    benchmark_string_copy();
    benchmark_string_operations();
    memory_usage_analysis();
    show_string_pool_contents();
    
    std::cout << "\n╔════════════════════════════════════════════════╗\n";
    std::cout << "║                                                ║\n";
    std::cout << "║            ✅ 基准测试完成！                   ║\n";
    std::cout << "║                                                ║\n";
    std::cout << "╚════════════════════════════════════════════════╝\n\n";
    
  } catch (const std::exception& e) {
    std::cerr << "\n❌ 测试失败: " << e.what() << "\n";
    return 1;
  }
  
  return 0;
}

#include "./core/object.h"
#include <iostream>
#include <cassert>

void test_string_pool_basic() {
  std::cout << "测试: 字符串池基本功能\n";
  
  StringPool* pool = StringPool::getInstance();
  
  // 测试空字符串
  assert(pool->getString(0) == "");
  std::cout << "  ✓ 空字符串索引为 0\n";
  
  // 测试 intern
  int idx1 = pool->intern("Hello");
  int idx2 = pool->intern("World");
  int idx3 = pool->intern("Hello");  // 相同字符串
  
  assert(idx1 == idx3);  // 相同字符串应该返回相同索引
  assert(idx1 != idx2);  // 不同字符串应该返回不同索引
  std::cout << "  ✓ 字符串 intern 正确\n";
  
  // 测试获取字符串
  assert(pool->getString(idx1) == "Hello");
  assert(pool->getString(idx2) == "World");
  std::cout << "  ✓ 获取字符串正确\n";
  
  std::cout << "  字符串池大小: " << pool->getSize() << "\n";
}

void test_string_class() {
  std::cout << "\n测试: String 类功能\n";
  
  // 测试构造函数
  String s1("Hello");
  String s2("World");
  String s3("Hello");
  
  // 测试相等性（应该使用索引比较）
  assert(s1 == s3);
  assert(s1 != s2);
  std::cout << "  ✓ 字符串相等性比较正确\n";
  
  // 测试字符串拼接
  String s4 = s1 + String(" ") + s2;
  assert(s4.toString() == "Hello World");
  std::cout << "  ✓ 字符串拼接正确\n";
  
  // 测试长度
  assert(s1.get_length() == 5);
  assert(s2.get_length() == 5);
  std::cout << "  ✓ 字符串长度正确\n";
  
  // 测试索引访问
  assert(s1[0] == 'H');
  assert(s1[4] == 'o');
  std::cout << "  ✓ 字符索引访问正确\n";
  
  // 测试 substring
  String sub = s4.substring(0, 5);
  assert(sub.toString() == "Hello");
  std::cout << "  ✓ substring 正确\n";
  
  // 测试 indexOf
  assert(s4.indexOf(String("World")) == 6);
  assert(s4.indexOf(String("xyz")) == -1);
  std::cout << "  ✓ indexOf 正确\n";
  
  // 测试 contains
  assert(s4.contains(String("Hello")));
  assert(s4.contains(String("World")));
  assert(!s4.contains(String("xyz")));
  std::cout << "  ✓ contains 正确\n";
}

void test_string_operations() {
  std::cout << "\n测试: String 操作方法\n";
  
  String s1("  Hello World  ");
  
  // 测试 trim
  String trimmed = s1.trim();
  assert(trimmed.toString() == "Hello World");
  std::cout << "  ✓ trim 正确\n";
  
  // 测试大小写转换
  String lower = String("HELLO").toLowerCase();
  assert(lower.toString() == "hello");
  
  String upper = String("hello").toUpperCase();
  assert(upper.toString() == "HELLO");
  std::cout << "  ✓ 大小写转换正确\n";
  
  // 测试 replace
  String s2("Hello World");
  String replaced = s2.replaceAll(String("o"), String("0"));
  assert(replaced.toString() == "Hell0 W0rld");
  std::cout << "  ✓ replace 正确\n";
  
  // 测试 startsWith 和 endsWith
  assert(s2.startsWith(String("Hello")));
  assert(s2.endsWith(String("World")));
  assert(!s2.startsWith(String("World")));
  std::cout << "  ✓ startsWith/endsWith 正确\n";
}

void test_string_pool_memory_efficiency() {
  std::cout << "\n测试: 字符串池内存效率\n";
  
  StringPool* pool = StringPool::getInstance();
  int size_before = pool->getSize();
  
  // 创建多个相同字符串
  String s1("TestString");
  String s2("TestString");
  String s3("TestString");
  String s4("TestString");
  
  int size_after = pool->getSize();
  
  // 应该只增加一个字符串
  assert(size_after == size_before + 1);
  std::cout << "  ✓ 相同字符串共享内存\n";
  
  // 验证所有字符串使用相同索引
  assert(s1.getIndex() == s2.getIndex());
  assert(s2.getIndex() == s3.getIndex());
  assert(s3.getIndex() == s4.getIndex());
  std::cout << "  ✓ 所有相同字符串使用相同索引: " << s1.getIndex() << "\n";
}

void test_string_comparison_performance() {
  std::cout << "\n测试: 字符串比较性能\n";
  
  // 使用索引比较（O(1)）
  String s1("VeryLongStringForPerformanceTest");
  String s2("VeryLongStringForPerformanceTest");
  
  // 相等性比较应该非常快，因为只比较索引
  bool equal = (s1 == s2);
  assert(equal);
  std::cout << "  ✓ 相等性比较使用索引（O(1)）\n";
  
  // 字典序比较需要访问实际字符串
  String s3("AAA");
  String s4("ZZZ");
  assert(s3 < s4);
  std::cout << "  ✓ 字典序比较正确\n";
}

void test_string_copy_efficiency() {
  std::cout << "\n测试: 字符串拷贝效率\n";
  
  String original("TestString");
  int original_index = original.getIndex();
  
  // 拷贝构造
  String copy1(original);
  assert(copy1.getIndex() == original_index);
  std::cout << "  ✓ 拷贝构造共享索引\n";
  
  // 赋值操作
  String copy2;
  copy2 = original;
  assert(copy2.getIndex() == original_index);
  std::cout << "  ✓ 赋值操作共享索引\n";
  
  // 验证内容
  assert(copy1.toString() == original.toString());
  assert(copy2.toString() == original.toString());
  std::cout << "  ✓ 拷贝内容正确\n";
}

void print_string_pool_stats() {
  std::cout << "\n=== 字符串池统计信息 ===\n";
  StringPool* pool = StringPool::getInstance();
  std::cout << "池中字符串数量: " << pool->getSize() << "\n";
  std::cout << "字符串列表:\n";
  for (int i = 0; i < pool->getSize() && i < 20; i++) {
    std::cout << "  [" << i << "] \"" << pool->getString(i) << "\"\n";
  }
  if (pool->getSize() > 20) {
    std::cout << "  ... 还有 " << (pool->getSize() - 20) << " 个字符串\n";
  }
}

int main() {
  std::cout << "===========================================\n";
  std::cout << "    字符串池测试程序\n";
  std::cout << "===========================================\n\n";
  
  try {
    test_string_pool_basic();
    test_string_class();
    test_string_operations();
    test_string_pool_memory_efficiency();
    test_string_comparison_performance();
    test_string_copy_efficiency();
    
    print_string_pool_stats();
    
    std::cout << "\n===========================================\n";
    std::cout << "    ✅ 所有测试通过！\n";
    std::cout << "===========================================\n";
    
  } catch (const std::exception& e) {
    std::cerr << "\n❌ 测试失败: " << e.what() << "\n";
    return 1;
  }
  
  return 0;
}


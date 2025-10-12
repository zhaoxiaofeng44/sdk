// API 使用示例集合
import 'dart:async';

// 示例1：基本的数据容器操作
void example1_BasicDataContainer() {
  print('\n=== 示例1：基本的数据容器操作 ===');
  
  // 这些示例展示了如何创建和使用 CppUserData
  // 实际运行时需要导入相应的模块
  
  print('创建空容器...');
  print('创建固定大小容器...');
  print('创建常量容器...');
}

// 示例2：指针数组操作
void example2_PointerArrayOperations() {
  print('\n=== 示例2：指针数组操作 ===');
  
  print('创建指针数组...');
  print('设置数组元素...');
  print('获取数组元素...');
  print('获取数组长度...');
}

// 示例3：字符串处理
void example3_StringProcessing() {
  print('\n=== 示例3：字符串处理 ===');
  
  // 字符串转字符代码
  print('将字符串转换为字符代码...');
  
  // 字符代码转字符串
  print('将字符代码转换为字符串...');
  
  // 获取字符串长度
  print('获取字符串长度...');
}

// 示例4：动态数组操作
void example4_DynamicArrayOperations() {
  print('\n=== 示例4：动态数组操作 ===');
  
  print('创建空数组...');
  print('添加元素...');
  print('删除元素...');
  print('清空数组...');
}

// 示例5：类型装箱和拆箱
void example5_BoxingUnboxing() {
  print('\n=== 示例5：类型装箱和拆箱 ===');
  
  // 装箱不同类型
  print('装箱整数...');
  print('装箱浮点数...');
  print('装箱布尔值...');
  print('装箱字符串...');
  
  // 拆箱
  print('拆箱整数...');
  print('拆箱浮点数...');
}

// 示例6：异步任务处理
Future<void> example6_AsyncTasks() async {
  print('\n=== 示例6：异步任务处理 ===');
  
  print('创建异步任务...');
  print('等待任务完成...');
  print('获取任务结果...');
}

// 示例7：错误处理
Future<void> example7_ErrorHandling() async {
  print('\n=== 示例7：错误处理 ===');
  
  print('创建可能失败的任务...');
  print('捕获和处理错误...');
}

// 示例8：类型检查
void example8_TypeChecking() {
  print('\n=== 示例8：类型检查 ===');
  
  print('检查 null...');
  print('检查整数...');
  print('检查浮点数...');
  print('检查布尔值...');
  print('检查字符串...');
  print('检查列表...');
  print('检查映射...');
}

// 示例9：类型转换
void example9_TypeConversion() {
  print('\n=== 示例9：类型转换 ===');
  
  // 转换为整数
  print('转换为整数...');
  print('  42 -> 42');
  print('  3.14 -> 3');
  print('  "100" -> 100');
  print('  "invalid" -> 0');
  
  // 转换为浮点数
  print('转换为浮点数...');
  print('  42 -> 42.0');
  print('  "3.14" -> 3.14');
  
  // 转换为布尔值
  print('转换为布尔值...');
  print('  1 -> true');
  print('  0 -> false');
  print('  "true" -> true');
}

// 示例10：调试和诊断
void example10_DebugAndDiagnostics() {
  print('\n=== 示例10：调试和诊断 ===');
  
  print('打印调试信息...');
  print('获取堆栈跟踪...');
}

// 示例11：复杂数据结构
void example11_ComplexDataStructures() {
  print('\n=== 示例11：复杂数据结构 ===');
  
  print('创建嵌套数组...');
  print('创建对象数组...');
  print('混合类型数组...');
}

// 示例12：实际应用场景 - 数据序列化
void example12_DataSerialization() {
  print('\n=== 示例12：数据序列化 ===');
  
  // 模拟将对象序列化为可传递的格式
  print('序列化用户对象...');
  var userData = {
    'name': 'Alice',
    'age': 30,
    'email': 'alice@example.com',
    'active': true
  };
  
  print('用户数据: $userData');
  print('序列化为数组...');
  print('传递给 C++...');
}

// 示例13：实际应用场景 - 异步数据获取
Future<void> example13_AsyncDataFetching() async {
  print('\n=== 示例13：异步数据获取 ===');
  
  print('模拟从 C++ 异步获取数据...');
  
  // 模拟延迟
  await Future.delayed(Duration(milliseconds: 100));
  
  print('数据获取完成！');
  print('处理返回的数据...');
}

// 示例14：实际应用场景 - 回调处理
void example14_CallbackHandling() {
  print('\n=== 示例14：回调处理 ===');
  
  print('设置 C++ 回调...');
  print('触发回调...');
  print('处理回调结果...');
}

// 示例15：性能优化技巧
void example15_PerformanceOptimization() {
  print('\n=== 示例15：性能优化技巧 ===');
  
  print('使用常量数据...');
  print('批量操作...');
  print('重用对象...');
  print('及时清理...');
}

// 主函数：运行所有示例
void main() async {
  print('===========================================');
  print('     Dart-C++ API 使用示例集合');
  print('===========================================');
  
  example1_BasicDataContainer();
  example2_PointerArrayOperations();
  example3_StringProcessing();
  example4_DynamicArrayOperations();
  example5_BoxingUnboxing();
  
  await example6_AsyncTasks();
  await example7_ErrorHandling();
  
  example8_TypeChecking();
  example9_TypeConversion();
  example10_DebugAndDiagnostics();
  example11_ComplexDataStructures();
  example12_DataSerialization();
  
  await example13_AsyncDataFetching();
  
  example14_CallbackHandling();
  example15_PerformanceOptimization();
  
  print('\n===========================================');
  print('     所有示例运行完成！');
  print('===========================================');
}

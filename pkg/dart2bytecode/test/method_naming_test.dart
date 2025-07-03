import 'dart:io';

void main() {
  print('=== 验证方法命名修正测试 ===');

  // 读取生成的头文件
  final outputFile = File('output.h');
  if (!outputFile.existsSync()) {
    print('❌ 错误：output.h 文件不存在');
    return;
  }

  final content = outputFile.readAsStringSync();

  // 检查StringBuffer类的方法命名
  print('\n=== 检查StringBuffer类方法命名 ===');

  // 应该有的简单方法名
  final expectedSimpleMethods = [
    'write(Object* obj)',
    'clear()',
    'writeCharCode(Int* charCode)',
    'writeln(Object* obj)',
    '_writeString(String* str)',
    '_ensureCapacity(Int* n)',
    '_consumeBuffer()',
    '_addPart(String* str)',
    '_compact()',
  ];

  // 不应该有的带类名前缀的方法名
  final unwantedPrefixedMethods = [
    'StringBuffer_write',
    'StringBuffer_clear',
    'StringBuffer_writeCharCode',
    'StringBuffer_writeln',
    'StringBuffer__writeString',
    'StringBuffer__ensureCapacity',
    'StringBuffer__consumeBuffer',
    'StringBuffer__addPart',
    'StringBuffer__compact',
  ];

  bool hasCorrectMethods = true;

  // 检查是否有正确的简单方法名
  for (final method in expectedSimpleMethods) {
    if (content.contains(method)) {
      print('✅ 找到正确的方法名: $method');
    } else {
      print('❌ 缺少正确的方法名: $method');
      hasCorrectMethods = false;
    }
  }

  // 检查是否还有不需要的带前缀的方法名
  for (final method in unwantedPrefixedMethods) {
    if (content.contains(method)) {
      print('❌ 仍然存在带前缀的方法名: $method');
      hasCorrectMethods = false;
    } else {
      print('✅ 已删除带前缀的方法名: $method');
    }
  }

  // 检查应该保留前缀的方法
  print('\n=== 检查应该保留前缀的方法 ===');

  final shouldHavePrefixMethods = [
    'cppCtr_', // 构造函数
    'cppGet_length', // Getter
    'cppGet_isEmpty', // Getter
    'cppGet_isNotEmpty', // Getter
    'Object_toString', // Object方法重写
  ];

  for (final method in shouldHavePrefixMethods) {
    if (content.contains(method)) {
      print('✅ 正确保留了前缀方法: $method');
    } else {
      print('❌ 缺少应该有前缀的方法: $method');
      hasCorrectMethods = false;
    }
  }

  // 检查其他类的方法命名
  print('\n=== 检查其他类的方法命名 ===');

  // 检查CyBase类的方法
  if (content.contains('virtual void test() noexcept;')) {
    print('✅ CyBase类方法名正确: test()');
  } else if (content.contains('virtual void CyBase_test() noexcept;')) {
    print('❌ CyBase类方法仍有前缀: CyBase_test()');
    hasCorrectMethods = false;
  }

  // 检查CyFather类的方法
  if (content.contains('virtual void myTest() noexcept;')) {
    print('✅ CyFather类方法名正确: myTest()');
  } else if (content.contains('virtual void CyFather_myTest() noexcept;')) {
    print('❌ CyFather类方法仍有前缀: CyFather_myTest()');
    hasCorrectMethods = false;
  }

  if (hasCorrectMethods) {
    print('\n✅ 所有方法命名都符合文档要求');
  } else {
    print('\n❌ 方法命名还有问题需要修复');
  }

  print('\n=== 测试完成 ===');
}

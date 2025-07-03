/*
 * 函数指针成员功能演示
 * 
 * 此文件展示了修改后的 Dart 到 C++ 转换器如何在类定义中
 * 添加函数指针成员，将类方法与对应的全局函数关联。
 */

void main() {
  print('=== 函数指针成员功能演示 ===');

  print('修改后的转换器现在会在每个类定义中添加函数指针成员：');
  print('');

  print('示例类定义（转换前的 Dart 代码）：');
  print('class Calculator {');
  print('  int value = 0;');
  print('  Calculator(int initialValue) { value = initialValue; }');
  print('  void add(int other) { value += other; }');
  print('  int multiply(int factor) { return value * factor; }');
  print('  int operator [](int index) { return value + index; }');
  print('  void operator []=(int index, int val) { value = val; }');
  print('}');
  print('');

  print('转换后的 C++ 类定义：');
  print('class Calculator : public Object {');
  print('public:');
  print('    Int* value;');
  print('    // 函数指针成员 - 关联到对应的全局函数');
  print(
      '    const decltype(&Calculator_cppCtr_) cppCtr_ = &Calculator_cppCtr_;');
  print('    const decltype(&Calculator_add) add = &Calculator_add;');
  print(
      '    const decltype(&Calculator_multiply) multiply = &Calculator_multiply;');
  print(
      '    const decltype(&Calculator_cpp_subscript) cpp_subscript = &Calculator_cpp_subscript;');
  print(
      '    const decltype(&Calculator_cpp_subscriptAssign) cpp_subscriptAssign = &Calculator_cpp_subscriptAssign;');
  print('};');
  print('');

  print('🎯 关键特点：');
  print('1. 函数指针成员使用原始方法名（不带类名前缀）');
  print('2. 操作符重载方法名自动转换：');
  print('   - [] → cpp_subscript');
  print('   - []= → cpp_subscriptAssign');
  print('   - + → cpp_add');
  print('   - == → cpp_equals');
  print('   - 等等...');
  print('3. getter/setter 方法：');
  print('   - get:propertyName → cppGet_propertyName');
  print('   - set:propertyName → cppSet_propertyName');
  print('4. 构造函数：');
  print('   - 默认构造函数 → cppCtr_');
  print('   - 命名构造函数 → cppCtr_name');
  print('');

  print('💡 使用方式：');
  print('// 方式1：传统全局函数调用');
  print('Calculator* calc = Calculator_cppNew();');
  print('Calculator_add(calc, Int_cppNew(5));');
  print('');
  print('// 方式2：通过函数指针成员调用');
  print('calc->add(calc, Int_cppNew(5));');
  print('');
  print('// 方式3：获取函数指针进行传递');
  print('auto addFunc = calc->add;');
  print('addFunc(calc, Int_cppNew(10));');
  print('');
  print('// 方式4：操作符重载调用');
  print('Int* result = calc->cpp_subscript(calc, Int_cppNew(0));');
  print('calc->cpp_subscriptAssign(calc, Int_cppNew(0), Int_cppNew(100));');
  print('');

  print('🚀 技术优势：');
  print('✓ 类型安全：使用 decltype 自动推导函数指针类型');
  print('✓ 零运行时开销：所有函数指针在编译时确定');
  print('✓ 向后兼容：完全保持原有全局函数调用方式');
  print('✓ 面向对象：支持通过类实例直接调用方法');
  print('✓ 灵活性：支持函数指针传递和回调');
  print('✓ 完整支持：包括构造函数、getter/setter、操作符重载');

  print('');
  print('=== 演示完成 ===');
}

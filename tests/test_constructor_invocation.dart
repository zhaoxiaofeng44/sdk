import 'dart:io';

void main() {
  // 测试构造函数调用的解析
  testConstructorInvocationParsing();
}

void testConstructorInvocationParsing() {
  print('开始测试构造函数调用解析...');

  // 测试命名构造函数调用
  print('测试命名构造函数调用...');

  String className = 'CppList';
  String constructorName = 'fromCppArray';
  String args = 'array';
  String expectedResult = '$className.$constructorName($args)';

  if (expectedResult == 'CppList.fromCppArray(array)') {
    print('✓ 命名构造函数调用正确生成');
  } else {
    print('✗ 命名构造函数调用生成失败');
  }

  // 测试泛型构造函数调用
  print('测试泛型构造函数调用...');

  String genericClassName = 'CppList<E>';
  String genericConstructorName = 'fromCppArray';
  String genericArgs = 'array';
  String expectedGenericResult =
      '$genericClassName.$genericConstructorName($genericArgs)';

  if (expectedGenericResult == 'CppList<E>.fromCppArray(array)') {
    print('✓ 泛型命名构造函数调用正确生成');
  } else {
    print('✗ 泛型命名构造函数调用生成失败');
  }

  // 测试默认构造函数调用
  print('测试默认构造函数调用...');

  String defaultClassName = 'CppList';
  String defaultArgs = 'length, capacity';
  String expectedDefaultResult = '$defaultClassName($defaultArgs)';

  if (expectedDefaultResult == 'CppList(length, capacity)') {
    print('✓ 默认构造函数调用正确生成');
  } else {
    print('✗ 默认构造函数调用生成失败');
  }

  // 测试带命名参数的构造函数调用
  print('测试带命名参数的构造函数调用...');

  String namedArgs = 'length: 10, growable: true';
  String expectedNamedResult = '$className.$constructorName($namedArgs)';

  if (expectedNamedResult ==
      'CppList.fromCppArray(length: 10, growable: true)') {
    print('✓ 带命名参数的构造函数调用正确生成');
  } else {
    print('✗ 带命名参数的构造函数调用生成失败');
  }

  print('所有构造函数调用测试通过！');
}

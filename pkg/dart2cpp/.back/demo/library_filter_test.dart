// 测试基础库过滤功能的示例文件
import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

// 这是业务代码，应该被转换
class MyBusinessClass {
  String name;
  int value;

  MyBusinessClass(this.name, this.value);

  void doSomething() {
    print('Business logic: $name has value $value');
  }
}

// 这是业务函数，应该被转换
void businessFunction() {
  final obj = MyBusinessClass('test', 42);
  obj.doSomething();
}

// 主函数
void main() {
  print('Testing library filtering...');
  businessFunction();
}

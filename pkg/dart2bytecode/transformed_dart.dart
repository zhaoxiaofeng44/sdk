import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'lib/demo/box.dart';
import 'lib/demo/function.dart';

/// 全局Void类型变量，用于替代void返回值
final Void = null;

/// 全局函数和变量
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp/test_dart2bytecode.dart

void main() {
  {
  print(const_0);
  int x = 42;
  int y = (x * 2);
  print(const_1 + CppString.convertString(x) + const_2 + CppString.convertString(y));
  List<int> list = CppArrayList<int>.fromCppArray(native_cppArrayConst(5, 1, 2, 3, 4, 5));
  print(const_3 + CppString.convertString(list));
  Map<String, Object> map = {const_4: const_5, const_6: 25};
  print(const_7 + CppString.convertString(map));
}
}

/// 全局const常量定义
/// 自动生成的const常量，用于替换重复的const值
const const_0 = CppString.fromCppUserData(CppUserData.constant([]));
const const_1 = CppString.fromCppUserData(CppUserData.constant([]));
const const_2 = CppString.fromCppUserData(CppUserData.constant([]));
const const_3 = CppString.fromCppUserData(CppUserData.constant([]));
const const_4 = CppString.fromCppUserData(CppUserData.constant([]));
const const_5 = CppString.fromCppUserData(CppUserData.constant([]));
const const_6 = CppString.fromCppUserData(CppUserData.constant([]));
const const_7 = CppString.fromCppUserData(CppUserData.constant([]));


/// 全局拆箱方法
/// 用于将装箱类型转换回基本类型
/// 支持在as表达式中自动替换调用

int asInt(dynamic value) {
  if (value is BoxInt) {
    return value.value;
  } else if (value is int) {
    return value;
  } else {
    throw TypeError();
  }
}

double asDouble(dynamic value) {
  if (value is BoxDouble) {
    return value.value;
  } else if (value is double) {
    return value;
  } else if (value is int) {
    return value.toDouble();
  } else {
    throw TypeError();
  }
}

bool asBool(dynamic value) {
  if (value is BoxBool) {
    return value.value;
  } else if (value is bool) {
    return value;
  } else {
    throw TypeError();
  }
}

String asString(dynamic value) {
  if (value is BoxString) {
    return value.value;
  } else if (value is String) {
    return value;
  } else {
    throw TypeError();
  }
}


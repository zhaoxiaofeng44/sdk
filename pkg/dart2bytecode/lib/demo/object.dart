import 'string.dart';

class CppAny {
  const CppAny();

  CppString toCppString() {
    return CppString.Empty;
  }
}

@pragma('cpp:native', 'ObjectExt')
extension ObjectExt on Object {
  CppString toCppString() {
    if (this is CppAny) {
      return (this as CppAny).toCppString();
    }
    throw "Cannot convert to CppString";
  }
}

// 测试 extension 方法调用
void testExtensionCall(Object obj) {
  var result = obj.toCppString();
  print(result);
}

// 测试 extension getter 调用
void testExtensionGetter(Object obj) {
  var getter = obj.toCppString;
  print(getter);
}

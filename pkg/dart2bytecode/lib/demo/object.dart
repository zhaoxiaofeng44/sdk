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

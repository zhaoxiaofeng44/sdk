import 'string.dart';

@pragma('cpp:patch', 'Object')
class CppObject {
  const CppObject();

  CppString toCppString() {
    return CppString.Empty;
  }
}

@pragma('cpp:native', 'CppPointerArray')
class CppPointerArray {}

@pragma('cpp:native', 'CppByteArray')
class CppByteArray {}

@pragma('cpp:native', 'CppApi')
class CppApi {
  static CppPointerArray cppCreatePointerArray(int length) {
    throw UnimplementedError();
  }

  static int cppGetPointerArrayLength(CppPointerArray array) {
    throw UnimplementedError();
  }

  static Object? cppGetPointerArrayItem(CppPointerArray array, int index) {
    throw UnimplementedError();
  }

  static void cppSetPointerArrayItem(
      CppPointerArray array, int index, Object? value) {
    throw UnimplementedError();
  }

  static CppByteArray cppCreateByteArray(int length) {
    throw UnimplementedError();
  }

  static int cppGetByteArrayLength(CppByteArray array) {
    throw UnimplementedError();
  }

  static int cppGetByteArrayItem(CppByteArray array, int index) {
    throw UnimplementedError();
  }

  static int cppSetByteArrayItem(CppByteArray array, int index, int value) {
    throw UnimplementedError();
  }

  static String cppJoinListString(CppPointerArray array, String separator) {
    throw UnimplementedError();
  }

  static bool cppBoolValue(bool value) {
    throw UnimplementedError();
  }

  static String getCurrentStackTrace() {
    throw UnimplementedError();
  }
}

@pragma('cpp:native', 'CppUserData')
class CppUserData {}

@pragma('cpp:native', 'CppApi')
class CppApi {
  static CppUserData cppCreatePointerArray(int length) {
    throw UnimplementedError();
  }

  static int cppGetPointerArrayLength(CppUserData array) {
    throw UnimplementedError();
  }

  static Object? cppGetPointerArrayItem(CppUserData array, int index) {
    throw UnimplementedError();
  }

  static void cppSetPointerArrayItem(
      CppUserData array, int index, Object? value) {
    throw UnimplementedError();
  }

  static CppUserData cppCreateByteArray(int length) {
    throw UnimplementedError();
  }

  static int cppGetByteArrayLength(CppUserData array) {
    throw UnimplementedError();
  }

  static int cppGetByteArrayItem(CppUserData array, int index) {
    throw UnimplementedError();
  }

  static int cppSetByteArrayItem(CppUserData array, int index, int value) {
    throw UnimplementedError();
  }

  static String cppJoinListString(CppUserData array, String separator) {
    throw UnimplementedError();
  }

  static bool cppBoolValue(bool value) {
    throw UnimplementedError();
  }

  static String getCurrentStackTrace() {
    throw UnimplementedError();
  }

  static void print(Object? object) {
    throw UnimplementedError();
  }

  
}

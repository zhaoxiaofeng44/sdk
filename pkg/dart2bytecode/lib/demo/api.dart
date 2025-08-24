@pragma('cpp:native', 'CppUserData')
class CppUserData {
  final List<dynamic> data;

  CppUserData() : data = List<dynamic>.filled(0, null, growable: true);

  const CppUserData.constant(List<dynamic> data) : data = data;
}

const CppUserData cppUserDataEmpty = CppUserData.constant([]);

@pragma('cpp:native', 'CppApi')
class CppApi {
  static CppUserData cppCreatePointerArray(int length) {
    CppUserData userData = CppUserData();
    userData.data.length = length;
    return userData;
  }

  static int cppGetPointerArrayLength(CppUserData array) {
    return array.data.length;
  }

  static Object? cppGetPointerArrayItem(CppUserData array, int index) {
    return array.data[index];
  }

  static void cppSetPointerArrayItem(
      CppUserData array, int index, Object? value) {
    array.data[index] = value;
  }

  static CppUserData cppCreateByteArray(int length) {
    return CppUserData.constant(List<dynamic>.empty(growable: true));
  }

  static int cppGetByteArrayLength(CppUserData array) {
    return array.data.length;
  }

  static int cppGetByteArrayItem(CppUserData array, int index) {
    return array.data[index];
  }

  static void cppSetByteArrayItem(CppUserData array, int index, int value) {
    array.data[index] = value;
  }

  static bool cppBoolValue(bool value) {
    return value;
  }

  static String getCurrentStackTrace() {
    return StackTrace.current.toString();
  }

  static void print(Object? object) {
    print(object);
  }

  static CppUserData cppArrayConst(int length,
      [Object? v1,
      Object? v2,
      Object? v3,
      Object? v4,
      Object? v5,
      Object? v6,
      Object? v7,
      Object? v8,
      Object? v9,
      Object? v10]) {
    return CppUserData.constant(
        [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10]..length = length);
  }
}

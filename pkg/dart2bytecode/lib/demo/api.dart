import 'package:dart2bytecode/demo/object.dart';

import 'string.dart';

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

  static void print(Object? object) {
    print(object);
  }

  static CppUserData getCurrentStackTrace() {
    return cppToString(StackTrace.current.toString());
  }

  static CppUserData cppToString(Object? object) {
    if (object == null) {
      return CppUserData.constant(['null']);
    }
    return CppUserData.constant(object.toString().codeUnits);
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

  static CppUserData cppCharCodes(Object? value) {
    return CppUserData.constant(value.toString().codeUnits);
  }
}

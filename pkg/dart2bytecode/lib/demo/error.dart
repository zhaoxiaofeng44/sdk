import 'api.dart';

@pragma('cpp:patch', 'Error')
class CppError implements Error {
  CppError();

  static String safeToString(Object? object) {
    if (null == object) {
      return "null";
    }
    if (object is String) {
      return object as String; //不能优化，不然类型会有问题
    }
    return object.toString();
  }

  StackTrace? get stackTrace => CppStackTrace.current;
}

@pragma('cpp:patch', 'StackTrace')
class CppStackTrace implements StackTrace {
  CppStackTrace();

  static CppStackTrace _current = CppStackTrace();
  static CppStackTrace get current => _current;

  String toString() => CppApi.getCurrentStackTrace();
}

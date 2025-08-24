import 'api.dart';
import 'object.dart';
import 'string.dart';

@pragma('cpp:patch', 'Error')
class CppError extends CppObject {
  CppError();

  CppStackTrace? get stackTrace => CppStackTrace.current;
}

@pragma('cpp:patch', 'StackTrace')
class CppStackTrace extends CppObject {
  CppStackTrace();

  static CppStackTrace _current = CppStackTrace();
  static CppStackTrace get current => _current;

  CppString toCppString() =>
      CppString.fromString(CppApi.getCurrentStackTrace());
}

import 'dart:async';
import 'object.dart';
import 'box.dart';

@pragma('cpp:native', 'CppUserData')
class CppUserData {
  final List<dynamic> data;

  CppUserData() : data = List<dynamic>.filled(0, null, growable: true);

  CppUserData.withLength(int length) : data = List<dynamic>.filled(length, null, growable: true);

  const CppUserData.constant(List<dynamic> data) : data = data;
}

const CppUserData cppUserDataEmpty = CppUserData.constant([]);

@pragma('cpp:native', 'CppApi')
CppUserData native_cppCreatePointerArray(int length) {
  CppUserData userData = CppUserData.withLength(length);
  return userData;
}

@pragma('cpp:native', 'CppApi')
int native_cppGetPointerArrayLength(CppUserData array) {
  return array.data.length;
}

@pragma('cpp:native', 'CppApi')
Object? native_cppGetPointerArrayItem(CppUserData array, int index) {
  return array.data[index];
}

@pragma('cpp:native', 'CppApi')
void native_cppSetPointerArrayItem(
    CppUserData array, int index, Object? value) {
  array.data[index] = value;
}

@pragma('cpp:native', 'CppApi')
void native_print(Object? object) {
  print(object);
}

@pragma('cpp:native', 'CppApi')
CppUserData native_getCurrentStackTrace() {
  return native_cppToString(StackTrace.current.toString());
}

@pragma('cpp:native', 'CppApi')
CppUserData native_cppToString(Object? object) {
  if (object == null) {
    return CppUserData.constant(['null']);
  }
  return CppUserData.constant(object.toString().codeUnits);
}

@pragma('cpp:native', 'CppApi')
CppUserData native_cppArrayConst(int length,
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
      [ v1, v2, v3, v4, v5, v6, v7, v8, v9, v10 ]..length = length);
}

@pragma('cpp:native', 'CppApi')
CppUserData native_cppCharCodes(Object? value) {
  return CppUserData.constant(value.toString().codeUnits);
}

@pragma('cpp:native', 'CppApi')
CppUserData native_cppCreateAsyncTask() {
  CppUserData userData = CppUserData.withLength(3);
  userData.data[0] = Completer();
  userData.data[1] = false;
  userData.data[2] = null;
  return userData;
}

@pragma('cpp:native', 'CppApi')
Future<void> native_cppAwaitAsyncTask(CppUserData taskData) {
  return (native_cppGetPointerArrayItem(taskData, 0) as Completer).future;
}

@pragma('cpp:native', 'CppApi')
Object? native_cppGetAsyncTaskResult(CppUserData taskData) {
  return taskData.data[2];
}

@pragma('cpp:native', 'CppApi')
CppAny native_cppBox(Object? value) {
  if (value is int) {
    return BoxInt(value);
  }
  if (value is double) {
    return BoxDouble(value);
  }
  if (value is bool) {
    return BoxBool(value);
  }
  if (value is String) {
    return BoxString(value);
  }
  if (value is CppAny) {
    return value;
  }
  throw ArgumentError('Unsupported type: ${value.runtimeType}');
}

@pragma('cpp:native', 'CppApi')
T native_cppUnbox<T>(Object? value) {
  if (T is int) {
    if (value is BoxInt) {
      return value.unbox() as T;
    }
    if (value is int) {
      return value as T;
    }
  }
  if (T is double) {
    if (value is BoxDouble) {
      return value.unbox() as T;
    }
    if (value is double) {
      return value as T;
    }
  }
  if (T is bool) {
    if (value is BoxBool) {
      return value.unbox() as T;
    }
    if (value is bool) {
      return value as T;
    }
  }
  if (T is String) {
    if (value is BoxString) {
      return value.unbox() as T;
    }
    if (value is String) {
      return value as T;
    }
  }
  return value as T;
}

// 异步任务相关的辅助函数
@pragma('cpp:native', 'CppApi')
void native_cppCompleteAsyncTask(CppUserData taskData, Object? result) {
  taskData.data[1] = true;
  taskData.data[2] = result;
  (taskData.data[0] as Completer).complete();
}

@pragma('cpp:native', 'CppApi')
void native_cppCompleteAsyncTaskWithError(CppUserData taskData, Object error, [StackTrace? stackTrace]) {
  taskData.data[1] = true;
  taskData.data[2] = null;
  (taskData.data[0] as Completer).completeError(error, stackTrace);
}

@pragma('cpp:native', 'CppApi')
bool native_cppIsAsyncTaskDone(CppUserData taskData) {
  return taskData.data[1] as bool;
}

// 数组操作相关函数
@pragma('cpp:native', 'CppApi')
CppUserData native_cppCreateArray(List<Object?> items) {
  return CppUserData.constant(items);
}

@pragma('cpp:native', 'CppApi')
void native_cppClearArray(CppUserData array) {
  array.data.clear();
}

@pragma('cpp:native', 'CppApi')
void native_cppAddToArray(CppUserData array, Object? item) {
  array.data.add(item);
}

@pragma('cpp:native', 'CppApi')
void native_cppRemoveFromArray(CppUserData array, int index) {
  if (index >= 0 && index < array.data.length) {
    array.data.removeAt(index);
  }
}

// 字符串相关函数
@pragma('cpp:native', 'CppApi')
String native_cppFromCharCodes(CppUserData charCodes) {
  return String.fromCharCodes(charCodes.data.cast<int>());
}

@pragma('cpp:native', 'CppApi')
int native_cppStringLength(String str) {
  return str.length;
}

// 类型检查函数
@pragma('cpp:native', 'CppApi')
bool native_cppIsNull(Object? value) {
  return value == null;
}

@pragma('cpp:native', 'CppApi')
bool native_cppIsInt(Object? value) {
  return value is int;
}

@pragma('cpp:native', 'CppApi')
bool native_cppIsDouble(Object? value) {
  return value is double;
}

@pragma('cpp:native', 'CppApi')
bool native_cppIsBool(Object? value) {
  return value is bool;
}

@pragma('cpp:native', 'CppApi')
bool native_cppIsString(Object? value) {
  return value is String;
}

@pragma('cpp:native', 'CppApi')
bool native_cppIsList(Object? value) {
  return value is List;
}

@pragma('cpp:native', 'CppApi')
bool native_cppIsMap(Object? value) {
  return value is Map;
}

// 类型转换函数
@pragma('cpp:native', 'CppApi')
int native_cppToInt(Object? value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

@pragma('cpp:native', 'CppApi')
double native_cppToDouble(Object? value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

bool native_cppToBool(Object? value) {
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}

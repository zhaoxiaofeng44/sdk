/// 异常体系 — 替代裸 dart:core 异常类型

/// DartException — 替代裸 Exception
class DartException implements Exception {
  final String? message;
  DartException([this.message]);

  @override
  String toString() => message ?? 'DartException';
}

/// DartStateError — 替代裸 StateError
class DartStateError extends StateError {
  DartStateError(String message) : super(message);
}

/// DartArgumentError — 替代裸 ArgumentError
class DartArgumentError extends ArgumentError {
  DartArgumentError([dynamic message]) : super(message);
}

/// DartRangeError — 替代裸 RangeError
class DartRangeError extends RangeError {
  DartRangeError([dynamic message]) : super(message);

  /// 替代 RangeError.range
  DartRangeError.range(int invalidValue, int minValue, int maxValue,
      [String? name, String? message])
      : super.range(invalidValue, minValue, maxValue, name, message);

  /// 替代 RangeError.value
  DartRangeError.value(num value, [String? name, String? message])
      : super.value(value, name, message);
}

/// 替代 RangeError.index（工厂构造函数，不能用 super.index）
DartRangeError dartRangeErrorIndex(int index, dynamic indexable,
    [String? name, String? message, int? length]) {
  // 触发原生检查逻辑后包装
  try {
    throw RangeError.index(index, indexable, name, message, length);
  } on RangeError catch (e) {
    final wrapped = DartRangeError(e.message);
    return wrapped;
  }
}

/// DartFormatException — 替代裸 FormatException
class DartFormatException extends FormatException {
  const DartFormatException([String message = '', dynamic source, int? offset])
      : super(message, source, offset);
}

/// DartUnsupportedError — 替代裸 UnsupportedError
class DartUnsupportedError extends UnsupportedError {
  DartUnsupportedError([String? message]) : super(message ?? '');
}

/// DartUnimplementedError — 替代裸 UnimplementedError
class DartUnimplementedError extends UnimplementedError {
  DartUnimplementedError([String? message]) : super(message);
}

/// ReachabilityError — 用于 switch 表达式穷尽性检查的运行时错误
class ReachabilityError extends Error {
  final String message;
  ReachabilityError([this.message = '']);
  @override
  String toString() => 'ReachabilityError: $message';
}

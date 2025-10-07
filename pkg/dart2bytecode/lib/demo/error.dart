import 'api.dart';
import 'object.dart';
import 'string.dart';

@pragma('cpp:patch', 'StackTrace')
class CppStackTrace extends CppAny {
  CppStackTrace();

  static CppStackTrace _current = CppStackTrace();
  static CppStackTrace get current => _current;

  CppString toCppString() =>
      CppString.fromCppUserData(native_getCurrentStackTrace());
}

@pragma('cpp:patch', 'Error')
class CppError extends CppAny {
  CppError();

  CppStackTrace? get stackTrace => CppStackTrace.current;
}

@pragma('cpp:patch', 'StateError')
class CppStateError extends CppError {
  CppString message;
  CppStateError(this.message);
}

@pragma('cpp:patch', 'RangeError')
class CppRangeError extends CppError {
  /// The minimum value that [invalidValue] is allowed to assume.
  final num? start;

  /// The maximum value that [invalidValue] is allowed to assume.
  final num? end;

  /// The invalid value.
  final num? invalidValue;

  /// The parameter name of the invalid value.
  final CppString? name;

  /// The error message.
  final CppString? message;

  /// Create a new [CppRangeError] with the given [message].
  CppRangeError(this.message)
      : start = null,
        end = null,
        invalidValue = null,
        name = null;

  /// Create a new [CppRangeError] with a message for the given [value].
  ///
  /// An optional [name] can specify the argument name that has the
  /// invalid value, and the [message] can override the default error
  /// description.
  CppRangeError.value(num invalidValue, [this.name, this.message])
      : start = null,
        end = null,
        invalidValue = invalidValue;

  /// Create a new [CppRangeError] for a value being outside the valid range.
  ///
  /// The allowed range is from [minValue] to [maxValue], inclusive.
  /// If `minValue` or `maxValue` are `null`, the range is infinite in
  /// that direction.
  ///
  /// An optional [name] can specify the argument name that has the
  /// invalid value, and the [message] can override the default error
  /// description.
  CppRangeError.range(num invalidValue, int? minValue, int? maxValue,
      [this.name, this.message])
      : start = minValue,
        end = maxValue,
        invalidValue = invalidValue;
}

@pragma('cpp:patch', 'IndexError')
class CppIndexError extends CppError {
  /// The indexable object that [invalidValue] was not a valid index into.
  final CppAny? indexable;

  /// The length of [indexable] at the time of the error.
  final int length;

  /// The invalid index value.
  final int invalidValue;

  /// The parameter name of the index value.
  final CppString? name;

  /// The error message.
  final CppString? message;

  /// Creates a new [CppIndexError] stating that [invalidValue] is not a valid index
  /// into [indexable].
  ///
  /// The [length] is the length of [indexable] at the time of the error.
  /// If `length` is omitted, it defaults to `indexable.length`.
  CppIndexError(this.invalidValue, this.indexable,
      [this.name, this.message, int? length])
      : length = length ?? 0;

  /// Creates a new [CppIndexError] stating that [invalidValue] is not a valid index
  /// into [indexable].
  ///
  /// The [length] is the length of [indexable] at the time of the error.
  CppIndexError.withLength(this.invalidValue, this.length,
      {this.indexable, this.name, this.message});
}

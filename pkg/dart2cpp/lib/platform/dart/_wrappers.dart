/// 语义脱钩包装类型 — 让生成代码不直接出现裸 dart:core 标识符
///
/// 包含：staticPrint, dart_str_toStringAsFixed, StaticStringBuffer,
///       StaticRegExp, StaticDuration, StaticDateTime, StaticComparable

import '_exceptions.dart';

// ---- IO ----

/// staticPrint — 替代裸 print，便于 C++ 落地时统一替换
void staticPrint(Object? object) => print(object);

/// dart_str_toStringAsFixed — 将 double.toStringAsFixed 静态化
///
/// 用法: `dart_str_toStringAsFixed(value, digits)`
/// 等价于: `value.toStringAsFixed(digits)`
String dart_str_toStringAsFixed(dynamic value, int digits) {
  if (value is double) return value.toStringAsFixed(digits);
  return value.toString();
}

// ---- StringBuffer ----

/// StaticStringBuffer — 委托 StringBuffer
class StaticStringBuffer {
  final StringBuffer _delegate;

  StaticStringBuffer([Object content = '']) : _delegate = StringBuffer(content);

  void write(Object? obj) => _delegate.write(obj);
  void writeln([Object? obj = '']) => _delegate.writeln(obj);
  void writeAll(Iterable objects, [String separator = '']) =>
      _delegate.writeAll(objects, separator);
  void writeCharCode(int charCode) => _delegate.writeCharCode(charCode);

  int get length => _delegate.length;
  bool get isEmpty => _delegate.isEmpty;
  bool get isNotEmpty => _delegate.isNotEmpty;
  void clear() => _delegate.clear();

  @override
  String toString() => _delegate.toString();
}

// ---- RegExp ----

/// StaticRegExp — 委托 RegExp，实现 Pattern 以兼容 String.replaceAll 等
class StaticRegExp implements Pattern {
  final RegExp _delegate;

  StaticRegExp(String source,
      {bool multiLine = false,
      bool caseSensitive = true,
      bool unicode = false,
      bool dotAll = false})
      : _delegate = RegExp(source,
            multiLine: multiLine,
            caseSensitive: caseSensitive,
            unicode: unicode,
            dotAll: dotAll);

  bool hasMatch(String input) => _delegate.hasMatch(input);
  RegExpMatch? firstMatch(String input) => _delegate.firstMatch(input);
  @override
  Iterable<RegExpMatch> allMatches(String string, [int start = 0]) =>
      _delegate.allMatches(string, start);

  @override
  Match? matchAsPrefix(String string, [int start = 0]) =>
      _delegate.matchAsPrefix(string, start);
  String get pattern => _delegate.pattern;
  bool get isMultiLine => _delegate.isMultiLine;
  bool get isCaseSensitive => _delegate.isCaseSensitive;
  bool get isUnicode => _delegate.isUnicode;
  bool get isDotAll => _delegate.isDotAll;

  /// 委托 RegExp.escape 静态方法
  static String escape(String text) => RegExp.escape(text);

  @override
  String toString() => _delegate.toString();
}

// ---- Duration ----

/// StaticDuration — 委托 Duration
class StaticDuration {
  final Duration _delegate;

  StaticDuration(
      {int days = 0,
      int hours = 0,
      int minutes = 0,
      int seconds = 0,
      int milliseconds = 0,
      int microseconds = 0})
      : _delegate = Duration(
            days: days,
            hours: hours,
            minutes: minutes,
            seconds: seconds,
            milliseconds: milliseconds,
            microseconds: microseconds);

  StaticDuration._(this._delegate);

  int get inDays => _delegate.inDays;
  int get inHours => _delegate.inHours;
  int get inMinutes => _delegate.inMinutes;
  int get inSeconds => _delegate.inSeconds;
  int get inMilliseconds => _delegate.inMilliseconds;
  int get inMicroseconds => _delegate.inMicroseconds;

  Duration toDuration() => _delegate;

  @override
  String toString() => _delegate.toString();

  @override
  bool operator ==(Object other) =>
      other is StaticDuration && other._delegate == _delegate;

  @override
  int get hashCode => _delegate.hashCode;
}

// ---- DateTime ----

/// StaticDateTime — 委托 DateTime
class StaticDateTime {
  final DateTime _delegate;

  StaticDateTime(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : _delegate = DateTime(
            year, month, day, hour, minute, second, millisecond, microsecond);

  StaticDateTime._(this._delegate);

  factory StaticDateTime.now() => StaticDateTime._(DateTime.now());
  factory StaticDateTime.utc(int year,
          [int month = 1,
          int day = 1,
          int hour = 0,
          int minute = 0,
          int second = 0,
          int millisecond = 0,
          int microsecond = 0]) =>
      StaticDateTime._(DateTime.utc(
          year, month, day, hour, minute, second, millisecond, microsecond));
  factory StaticDateTime.parse(String formattedString) =>
      StaticDateTime._(DateTime.parse(formattedString));
  factory StaticDateTime.tryParse(String formattedString) {
    final dt = DateTime.tryParse(formattedString);
    if (dt == null) throw DartFormatException('Invalid date format: $formattedString');
    return StaticDateTime._(dt);
  }
  factory StaticDateTime.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch,
          {bool isUtc = false}) =>
      StaticDateTime._(DateTime.fromMillisecondsSinceEpoch(
          millisecondsSinceEpoch,
          isUtc: isUtc));
  factory StaticDateTime.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch,
          {bool isUtc = false}) =>
      StaticDateTime._(DateTime.fromMicrosecondsSinceEpoch(
          microsecondsSinceEpoch,
          isUtc: isUtc));

  int get year => _delegate.year;
  int get month => _delegate.month;
  int get day => _delegate.day;
  int get hour => _delegate.hour;
  int get minute => _delegate.minute;
  int get second => _delegate.second;
  int get millisecond => _delegate.millisecond;
  int get microsecond => _delegate.microsecond;
  int get weekday => _delegate.weekday;
  int get millisecondsSinceEpoch => _delegate.millisecondsSinceEpoch;
  int get microsecondsSinceEpoch => _delegate.microsecondsSinceEpoch;
  bool get isUtc => _delegate.isUtc;

  StaticDateTime add(StaticDuration duration) =>
      StaticDateTime._(_delegate.add(duration.toDuration()));
  StaticDateTime subtract(StaticDuration duration) =>
      StaticDateTime._(_delegate.subtract(duration.toDuration()));
  StaticDuration difference(StaticDateTime other) =>
      StaticDuration._(_delegate.difference(other._delegate));
  bool isBefore(StaticDateTime other) => _delegate.isBefore(other._delegate);
  bool isAfter(StaticDateTime other) => _delegate.isAfter(other._delegate);
  bool isAtSameMomentAs(StaticDateTime other) =>
      _delegate.isAtSameMomentAs(other._delegate);
  String toIso8601String() => _delegate.toIso8601String();
  StaticDateTime toUtc() => StaticDateTime._(_delegate.toUtc());
  StaticDateTime toLocal() => StaticDateTime._(_delegate.toLocal());

  DateTime toDateTime() => _delegate;

  @override
  String toString() => _delegate.toString();

  @override
  bool operator ==(Object other) =>
      other is StaticDateTime && other._delegate == _delegate;

  @override
  int get hashCode => _delegate.hashCode;
}

// ---- Comparable ----

/// StaticComparable<T> — 替代裸 Comparable<T>
abstract class StaticComparable<T> {
  int compareTo(T other);
}

import 'api.dart';

final CppUserData cppUserDataEmpty = CppApi.cppCreateByteArray(0);

/// 字符串池管理类
///
/// 该类负责管理CppUserData的共享和复用，确保相同内容的字符串
/// 使用同一个CppUserData对象，从而节省内存。
class CppStringPool {
  static final CppStringPool _instance = CppStringPool._internal();

  /// 获取单例实例
  static CppStringPool get instance => _instance;

  CppStringPool._internal();

  /// 直接存储CppUserData对象的池
  final List<CppUserData> _pool = [cppUserDataEmpty];

  /// 从代码单元列表获取或创建CppUserData
  CppUserData getOrCreateFromCodeUnits(List<int> codeUnits) {
    // 直接在池中查找相同内容的CppUserData
    for (final existing in _pool) {
      if (_compareUserData(existing, codeUnits)) {
        return existing;
      }
    }

    // 创建新的CppUserData
    final userData = CppApi.cppCreateByteArray(codeUnits.length);
    for (int i = 0; i < codeUnits.length; i++) {
      CppApi.cppSetByteArrayItem(userData, i, codeUnits[i]);
    }

    _pool.add(userData);
    return userData;
  }

  /// 从代码单元列表获取或创建CppUserData
  CppUserData getOrCreateFromUserData(CppUserData userData) {
    if (_pool.contains(userData)) {
      return userData;
    }
    _pool.add(userData);
    return userData;
  }

  /// 比较CppUserData与代码单元列表是否相同
  bool _compareUserData(CppUserData userData, List<int> codeUnits) {
    final length = CppApi.cppGetByteArrayLength(userData);
    if (length != codeUnits.length) return false;

    for (int i = 0; i < length; i++) {
      if (CppApi.cppGetByteArrayItem(userData, i) != codeUnits[i]) {
        return false;
      }
    }
    return true;
  }

  /// 清空池（仅用于测试）
  void clear() {
    _pool.clear();
  }

  /// 获取池的统计信息
  CppStringPoolStats getStats() {
    int totalMemory = 0;
    for (final userData in _pool) {
      totalMemory += CppApi.cppGetByteArrayLength(userData);
    }

    return CppStringPoolStats(
      totalStrings: _pool.length,
      totalMemory: totalMemory,
    );
  }
}

/// 字符串池统计信息
class CppStringPoolStats {
  final int totalStrings; // 池中不同字符串的数量
  final int totalMemory; // 总内存使用（字符数）

  CppStringPoolStats({
    required this.totalStrings,
    required this.totalMemory,
  });

  @override
  String toString() {
    return 'CppStringPoolStats{\n'
        '  不同字符串数: $totalStrings\n'
        '  总内存使用: $totalMemory 字符\n'
        '}';
  }
}

@pragma("cpp:patch-class", "StringBuffer")
@pragma('cpp:patch', 'StringBuffer')
class CppStringBuffer {
  final List<CppUserData> _parts;

  CppStringBuffer([Object content = ""])
      : _parts = [_convertStringToUserData(content)];

  static CppUserData _convertStringToUserData(Object obj) {
    if (obj is CppString) {
      return obj._codeUnits;
    }
    return CppStringPool.instance
        .getOrCreateFromCodeUnits(_convertStringToCodeUnits(obj.toString()));
  }

  // 工具方法：将String转换为代码单元列表
  static List<int> _convertStringToCodeUnits(String str) {
    final codeUnits = <int>[];
    for (int i = 0; i < str.length; i++) {
      codeUnits.add(str.codeUnitAt(i));
    }
    return codeUnits;
  }

  // 标准StringBuffer方法
  void write(Object? obj) {
    if (obj == null) return;
    _parts.add(_convertStringToUserData(obj));
  }

  void writeAll(Iterable objects, [CppString? separator]) {
    var iterator = objects.iterator;
    if (iterator.moveNext()) {
      _parts.add(_convertStringToUserData(iterator.current));
      while (iterator.moveNext()) {
        if (separator != null && separator.isNotEmpty) {
          _parts.add(separator._codeUnits);
        }
        _parts.add(_convertStringToUserData(iterator.current));
      }
    }
  }

  void writeCharCode(int charCode) {
    _parts.add(_convertStringToUserData(CppString.fromCharCode(charCode)));
  }

  void writeln([Object? obj = ""]) {
    if (obj != null) {
      _parts.add(_convertStringToUserData(obj));
    }
    _parts.add(_convertStringToUserData(CppString.fromCharCode(10))); // \n
  }

  void clear() {
    _parts.clear();
  }

  CppString toCppString() {
    final codeUnits = <int>[];
    for (final part in _parts) {
      final length = CppApi.cppGetByteArrayLength(part);
      for (int i = 0; i < length; i++) {
        codeUnits.add(CppApi.cppGetByteArrayItem(part, i));
      }
    }
    return CppString.fromCodeUnits(codeUnits);
  }

  int get length {
    int totalLength = 0;
    for (final part in _parts) {
      totalLength += CppApi.cppGetByteArrayLength(part);
    }
    return totalLength;
  }

  bool get isEmpty => _parts.isEmpty;

  bool get isNotEmpty => _parts.isNotEmpty;
}

/// CppString - 基于CppUserData实现的字符串类
///
/// 该类提供了与Dart标准String相同的接口和方法，
/// 内部使用CppUserData字节数组来存储UTF-16代码单元，
/// 支持高效的字符串操作和内存管理。
///
/// 注意：由于Dart的限制，此类不能直接implement String，
/// 但提供了String的所有方法和功能。
@pragma("cpp:patch-class", "String")
@pragma('cpp:patch', 'String')
class CppString implements Comparable<CppString> {
  static CppString Empty = CppString.fromCppUserData(cppUserDataEmpty);

  final CppUserData _codeUnits;

  /// 构造函数 - 从代码单元数组创建CppString
  CppString.fromCppUserData(CppUserData userData)
      : _codeUnits = CppStringPool.instance.getOrCreateFromUserData(userData);

  /// 构造函数 - 从代码单元数组创建CppString
  CppString.fromCodeUnits(List<int> codeUnits)
      : _codeUnits = CppStringPool.instance.getOrCreateFromCodeUnits(codeUnits);

  /// 从单个字符的代码单元创建CppString
  CppString.fromCharCode(int charCode)
      : _codeUnits =
            CppStringPool.instance.getOrCreateFromCodeUnits([charCode]);

  /// 从字符代码列表创建CppString
  CppString.fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end])
      : _codeUnits = CppStringPool.instance.getOrCreateFromCodeUnits(charCodes
            .skip(start)
            .take((end ?? charCodes.length) - start)
            .toList());

  /// 将内部代码单元转换为完整字符串（仅在与外部String互操作时使用）
  String _toExternalString() {
    final codeUnits = <int>[];
    for (int i = 0; i < length; i++) {
      codeUnits.add(CppApi.cppGetByteArrayItem(_codeUnits, i));
    }
    return String.fromCharCodes(codeUnits);
  }

  /// 比较两个CppString的代码单元是否相等
  bool _equalCodeUnits(CppString other) {
    final thisLength = length;
    final otherLength = other.length;
    if (thisLength != otherLength) return false;
    for (int i = 0; i < thisLength; i++) {
      if (CppApi.cppGetByteArrayItem(_codeUnits, i) !=
          CppApi.cppGetByteArrayItem(other._codeUnits, i)) {
        return false;
      }
    }
    return true;
  }

  // ============================================================================
  // 基础属性和操作符
  // ============================================================================

  CppString operator [](int index) {
    final thisLength = length;
    if (index < 0 || index >= thisLength) {
      throw RangeError.index(index, this, 'index');
    }
    final codeUnit = CppApi.cppGetByteArrayItem(_codeUnits, index);
    return CppString.fromCharCode(codeUnit);
  }

  int get length => CppApi.cppGetByteArrayLength(_codeUnits);

  bool get isEmpty => length == 0;

  bool get isNotEmpty => length > 0;

  int get hashCode {
    // 计算代码单元的哈希值
    int hash = 0;
    for (int i = 0; i < length; i++) {
      hash =
          (hash * 31 + CppApi.cppGetByteArrayItem(_codeUnits, i)) & 0x7FFFFFFF;
    }
    return hash;
  }

  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is CppString) {
      return _equalCodeUnits(other);
    }
    return false;
  }

  CppString operator +(CppString other) {
    // 直接连接代码单元
    final thisLength = length;
    final otherLength = other.length;
    final newCodeUnits = <int>[];
    for (int i = 0; i < thisLength; i++) {
      newCodeUnits.add(CppApi.cppGetByteArrayItem(_codeUnits, i));
    }
    for (int i = 0; i < otherLength; i++) {
      newCodeUnits.add(CppApi.cppGetByteArrayItem(other._codeUnits, i));
    }
    return CppString.fromCodeUnits(newCodeUnits);
  }

  CppString operator *(int times) {
    if (times <= 0) return CppString.Empty;
    if (times == 1) return this;

    // 直接重复代码单元
    final thisLength = length;
    final newCodeUnits = <int>[];
    for (int repeat = 0; repeat < times; repeat++) {
      for (int i = 0; i < thisLength; i++) {
        newCodeUnits.add(CppApi.cppGetByteArrayItem(_codeUnits, i));
      }
    }
    return CppString.fromCodeUnits(newCodeUnits);
  }

  // ============================================================================
  // 字符和代码单元访问
  // ============================================================================

  int codeUnitAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.index(index, this, 'index');
    }
    return CppApi.cppGetByteArrayItem(_codeUnits, index);
  }

  List<int> get codeUnits {
    final thisLength = length;
    final units = <int>[];
    for (int i = 0; i < thisLength; i++) {
      units.add(CppApi.cppGetByteArrayItem(_codeUnits, i));
    }
    return units;
  }

  Runes get runes => _toExternalString().runes;

  // ============================================================================
  // 比较方法
  // ============================================================================

  int compareTo(CppString other) {
    final thisLength = length;
    final otherLength = other.length;
    int minLength = thisLength < otherLength ? thisLength : otherLength;
    for (int i = 0; i < minLength; i++) {
      int thisCodeUnit = CppApi.cppGetByteArrayItem(_codeUnits, i);
      int otherCodeUnit = CppApi.cppGetByteArrayItem(other._codeUnits, i);
      if (thisCodeUnit != otherCodeUnit) {
        return thisCodeUnit - otherCodeUnit;
      }
    }
    return thisLength - otherLength;
  }

  // ============================================================================
  // 查找和匹配方法
  // ============================================================================

  bool startsWith(CppString pattern, [int index = 0]) {
    if (index < 0 || index >= length) return false;
    if (index + pattern.length > length) return false;

    for (int i = 0; i < pattern.length; i++) {
      if (CppApi.cppGetByteArrayItem(_codeUnits, index + i) !=
          CppApi.cppGetByteArrayItem(pattern._codeUnits, i)) {
        return false;
      }
    }
    return true;
  }

  bool endsWith(CppString other) {
    if (other.length > length) return false;
    int startIndex = length - other.length;

    for (int i = 0; i < other.length; i++) {
      if (CppApi.cppGetByteArrayItem(_codeUnits, startIndex + i) !=
          CppApi.cppGetByteArrayItem(other._codeUnits, i)) {
        return false;
      }
    }
    return true;
  }

  int indexOf(CppString pattern, [int start = 0]) {
    if (start < 0) start = 0;
    if (pattern.isEmpty) return start;
    if (start + pattern.length > length) return -1;

    for (int i = start; i <= length - pattern.length; i++) {
      bool match = true;
      for (int j = 0; j < pattern.length; j++) {
        if (CppApi.cppGetByteArrayItem(_codeUnits, i + j) !=
            CppApi.cppGetByteArrayItem(pattern._codeUnits, j)) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  int lastIndexOf(CppString pattern, [int? start]) {
    if (pattern.isEmpty) return start ?? length;
    start ??= length;
    if (start < 0) return -1;
    if (start + pattern.length > length) start = length - pattern.length;

    for (int i = start; i >= 0; i--) {
      bool match = true;
      for (int j = 0; j < pattern.length; j++) {
        if (CppApi.cppGetByteArrayItem(_codeUnits, i + j) !=
            CppApi.cppGetByteArrayItem(pattern._codeUnits, j)) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  bool contains(CppString other, [int startIndex = 0]) {
    return indexOf(other, startIndex) != -1;
  }

  // ============================================================================
  // 子字符串和截取方法
  // ============================================================================

  CppString substring(int start, [int? end]) {
    end ??= length;
    if (start < 0) start = 0;
    if (end > length) end = length;
    if (start >= end) return CppString.Empty;

    final newLength = end - start;
    final newCodeUnits = <int>[];

    for (int i = 0; i < newLength; i++) {
      final codeUnit = CppApi.cppGetByteArrayItem(_codeUnits, start + i);
      newCodeUnits.add(codeUnit);
    }

    return CppString.fromCodeUnits(newCodeUnits);
  }

  // ============================================================================
  // 修剪方法
  // ============================================================================

  CppString trim() {
    int start = 0;
    int end = length;

    // 从左边开始找到第一个非空白字符
    while (start < end &&
        _isWhitespace(CppApi.cppGetByteArrayItem(_codeUnits, start))) {
      start++;
    }

    // 从右边开始找到最后一个非空白字符
    while (end > start &&
        _isWhitespace(CppApi.cppGetByteArrayItem(_codeUnits, end - 1))) {
      end--;
    }

    return substring(start, end);
  }

  CppString trimLeft() {
    int start = 0;

    // 从左边开始找到第一个非空白字符
    while (start < length &&
        _isWhitespace(CppApi.cppGetByteArrayItem(_codeUnits, start))) {
      start++;
    }

    return substring(start);
  }

  CppString trimRight() {
    int end = length;

    // 从右边开始找到最后一个非空白字符
    while (end > 0 &&
        _isWhitespace(CppApi.cppGetByteArrayItem(_codeUnits, end - 1))) {
      end--;
    }

    return substring(0, end);
  }

  /// 检查字符是否为空白字符
  bool _isWhitespace(int codeUnit) {
    // 常见的空白字符代码单元
    return codeUnit == 0x09 || // \t
        codeUnit == 0x0A || // \n
        codeUnit == 0x0B || // \v
        codeUnit == 0x0C || // \f
        codeUnit == 0x0D || // \r
        codeUnit == 0x20 || // space
        codeUnit == 0xA0; // non-breaking space
  }

  // ============================================================================
  // 填充方法
  // ============================================================================

  CppString padLeft(int width, [CppString? padding]) {
    if (width <= length) return this;
    padding ??= CppString.fromCharCode(32); // 默认空格字符

    final padLength = width - length;
    final padCount = (padLength / padding.length).ceil();
    final padString = padding * padCount;
    final actualPad = padString.substring(0, padLength);

    return actualPad + this;
  }

  CppString padRight(int width, [CppString? padding]) {
    if (width <= length) return this;
    padding ??= CppString.fromCharCode(32); // 默认空格字符

    final padLength = width - length;
    final padCount = (padLength / padding.length).ceil();
    final padString = padding * padCount;
    final actualPad = padString.substring(0, padLength);

    return this + actualPad;
  }

  // ============================================================================
  // 替换方法
  // ============================================================================

  CppString replaceFirst(CppString from, CppString to, [int startIndex = 0]) {
    int index = indexOf(from, startIndex);
    if (index == -1) return this;

    final beforePart = substring(0, index);
    final afterPart = substring(index + from.length);
    return beforePart + to + afterPart;
  }

  // Note: replaceFirstMapped 需要Match和Pattern支持，在纯CppString环境中暫不实现

  CppString replaceAll(CppString from, CppString replace) {
    if (from.isEmpty) return this;

    final parts = split(from);
    if (parts.length == 1) return this; // 没有找到任何匹配

    final result = <CppString>[];
    for (int i = 0; i < parts.length; i++) {
      result.add(parts[i]);
      if (i < parts.length - 1) {
        result.add(replace);
      }
    }

    return join(result);
  }

  // Note: replaceAllMapped 需要Match和Pattern支持，在纯CppString环境中暫不实现

  CppString replaceRange(int start, int? end, CppString replacement) {
    end ??= length;
    if (start < 0) start = 0;
    if (end > length) end = length;
    if (start >= end) return this + replacement;

    final beforePart = substring(0, start);
    final afterPart = substring(end);
    return beforePart + replacement + afterPart;
  }

  // ============================================================================
  // 分割方法
  // ============================================================================

  List<CppString> split(CppString separator) {
    if (separator.isEmpty) {
      // 分割为单个字符
      final result = <CppString>[];
      for (int i = 0; i < length; i++) {
        result.add(substring(i, i + 1));
      }
      return result;
    }

    final result = <CppString>[];
    int start = 0;
    int index = indexOf(separator, start);

    while (index != -1) {
      result.add(substring(start, index));
      start = index + separator.length;
      index = indexOf(separator, start);
    }

    // 添加最后一部分
    result.add(substring(start));
    return result;
  }

  // Note: splitMapJoin 需要Pattern和Match支持，在纯CppString环境中暂不实现

  // ============================================================================
  // 大小写转换方法
  // ============================================================================

  CppString toLowerCase() {
    // 先计算结果字符串，然后使用池化创建
    final resultCodeUnits = <int>[];
    for (int i = 0; i < length; i++) {
      int codeUnit = CppApi.cppGetByteArrayItem(_codeUnits, i);
      // 简单的ASCII大写转小写
      if (codeUnit >= 65 && codeUnit <= 90) {
        // A-Z
        codeUnit += 32; // 转换为a-z
      }
      resultCodeUnits.add(codeUnit);
    }

    return CppString.fromCodeUnits(resultCodeUnits);
  }

  CppString toUpperCase() {
    // 先计算结果字符串，然后使用池化创建
    final resultCodeUnits = <int>[];
    for (int i = 0; i < length; i++) {
      int codeUnit = CppApi.cppGetByteArrayItem(_codeUnits, i);
      // 简单的ASCII小写转大写
      if (codeUnit >= 97 && codeUnit <= 122) {
        // a-z
        codeUnit -= 32; // 转换为A-Z
      }
      resultCodeUnits.add(codeUnit);
    }

    return CppString.fromCodeUnits(resultCodeUnits);
  }

  // ============================================================================
  // Pattern接口实现（String实现了Pattern）
  // ============================================================================

  Iterable<CppStringMatch> allMatches(CppString string, [int start = 0]) {
    if (start < 0 || start > string.length) {
      throw RangeError.range(start, 0, string.length, 'start');
    }
    return _CppStringAllMatchesIterable(string, this, start);
  }

  CppStringMatch? matchAsPrefix(CppString string, [int start = 0]) {
    if (start < 0 || start > string.length) {
      throw RangeError.range(start, 0, string.length);
    }
    if (start + length > string.length) return null;
    for (int i = 0; i < length; i++) {
      if (CppApi.cppGetByteArrayItem(string._codeUnits, start + i) !=
          CppApi.cppGetByteArrayItem(_codeUnits, i)) {
        return null;
      }
    }
    return CppStringMatch(start, string, this);
  }

  // ============================================================================
  // Object方法重写和便利方法
  // ============================================================================

  CppString toCppString() {
    return this;
  }

  /// 转换为标准Dart String
  /// 这是与标准String互操作的主要方法
  String toStandardString() {
    return _toExternalString();
  }

  /// 从标准String创建CppString的工厂方法
  static CppString fromString(String source) {
    final codeUnits = <int>[];
    for (int i = 0; i < source.length; i++) {
      codeUnits.add(source.codeUnitAt(i));
    }
    return CppString.fromCodeUnits(codeUnits);
  }

  /// 释放对字符串池的引用（当不再需要此CppString时调用）
  /// 注意：由于现在使用直接共享，此方法暂时为空实现
  void dispose() {
    // 现在字符串池直接共享CppUserData，无需手动释放
    // 可以在这里添加未来的清理逻辑
  }

  /// 检查两个CppString是否共享相同的CppUserData（用于测试）
  bool sharesDataWith(CppString other) {
    return identical(_codeUnits, other._codeUnits);
  }

  /// 获取底层CppUserData的哈希码（用于调试）
  int get dataHashCode => _codeUnits.hashCode;

  /// 连接多个CppString
  static CppString join(Iterable<CppString> strings, [CppString? separator]) {
    separator ??= CppString.Empty;

    final stringList = strings.toList();
    if (stringList.isEmpty) return CppString.Empty;
    if (stringList.length == 1) return stringList[0];

    // 直接创建结果，无需预计算总长度

    // 创建结果数组
    final newCodeUnits = <int>[];
    for (int i = 0; i < stringList.length; i++) {
      final str = stringList[i];
      for (int j = 0; j < str.length; j++) {
        newCodeUnits.add(CppApi.cppGetByteArrayItem(str._codeUnits, j));
      }

      if (i < stringList.length - 1) {
        for (int j = 0; j < separator.length; j++) {
          newCodeUnits.add(CppApi.cppGetByteArrayItem(separator._codeUnits, j));
        }
      }
    }

    return CppString.fromCodeUnits(newCodeUnits);
  }
}

/// 基于 CppString 的字面量匹配结果实现
final class CppStringMatch {
  const CppStringMatch(this.start, this.input, this.pattern);

  int get end => start + pattern.length;

  CppString group(int group) {
    if (group != 0) {
      throw RangeError.value(group);
    }
    return pattern;
  }

  CppString operator [](int group) =>
      group == 0 ? pattern : (throw RangeError.value(group));

  int get groupCount => 0;

  final int start;
  final CppString input;
  final CppString pattern;
}

final class _CppStringAllMatchesIterable extends Iterable<CppStringMatch> {
  final CppString _input;
  final CppString _pattern;
  final int _index;

  _CppStringAllMatchesIterable(this._input, this._pattern, this._index);

  @override
  Iterator<CppStringMatch> get iterator =>
      _CppStringAllMatchesIterator(_input, _pattern, _index);

  @override
  CppStringMatch get first {
    final index = _input.indexOf(_pattern, _index);
    if (index >= 0) {
      return CppStringMatch(index, _input, _pattern);
    }
    throw StateError('No element');
  }
}

final class _CppStringAllMatchesIterator implements Iterator<CppStringMatch> {
  final CppString _input;
  final CppString _pattern;
  int _index;
  CppStringMatch? _current;

  _CppStringAllMatchesIterator(this._input, this._pattern, this._index);

  @override
  bool moveNext() {
    final patternLen = _pattern.length;
    if (_index + patternLen > _input.length) {
      _current = null;
      return false;
    }
    final index = _input.indexOf(_pattern, _index);
    if (index < 0) {
      _index = _input.length + 1;
      _current = null;
      return false;
    }
    final end = index + patternLen;
    _current = CppStringMatch(index, _input, _pattern);
    // 空匹配时避免重复位置
    _index = (end == _index) ? end + 1 : end;
    return true;
  }

  @override
  CppStringMatch get current => _current as CppStringMatch;
}

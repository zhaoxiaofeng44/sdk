// 字符常量和工具类
class CodeUnit {
  // ASCII 常量
  static const int NULL = 0x00;
  static const int SPACE = 0x20;
  static const int TAB = 0x09;
  static const int LF = 0x0A;
  static const int CR = 0x0D;

  static const int DIGIT_0 = 0x30;
  static const int DIGIT_9 = 0x39;

  static const int UPPER_A = 0x41;
  static const int UPPER_Z = 0x5A;

  static const int LOWER_A = 0x61;
  static const int LOWER_Z = 0x7A;

  // Unicode 相关常量
  static const int HIGH_SURROGATE_MIN = 0xD800;
  static const int HIGH_SURROGATE_MAX = 0xDBFF;
  static const int LOW_SURROGATE_MIN = 0xDC00;
  static const int LOW_SURROGATE_MAX = 0xDFFF;

  // 字符判断方法
  static bool isWhitespace(int codeUnit) {
    return codeUnit == SPACE ||
        codeUnit == TAB ||
        codeUnit == LF ||
        codeUnit == CR;
  }

  static bool isDigit(int codeUnit) {
    return codeUnit >= DIGIT_0 && codeUnit <= DIGIT_9;
  }

  static bool isUpperCase(int codeUnit) {
    return codeUnit >= UPPER_A && codeUnit <= UPPER_Z;
  }

  static bool isLowerCase(int codeUnit) {
    return codeUnit >= LOWER_A && codeUnit <= LOWER_Z;
  }

  static bool isAlpha(int codeUnit) {
    return isUpperCase(codeUnit) || isLowerCase(codeUnit);
  }

  static bool isAlphaNumeric(int codeUnit) {
    return isAlpha(codeUnit) || isDigit(codeUnit);
  }

  // 字符转换方法
  static int toLowerCase(int codeUnit) {
    if (isUpperCase(codeUnit)) {
      return codeUnit + (LOWER_A - UPPER_A);
    }
    return codeUnit;
  }

  static int toUpperCase(int codeUnit) {
    if (isLowerCase(codeUnit)) {
      return codeUnit - (LOWER_A - UPPER_A);
    }
    return codeUnit;
  }

  // Unicode 相关方法
  static bool isHighSurrogate(int codeUnit) {
    return codeUnit >= HIGH_SURROGATE_MIN && codeUnit <= HIGH_SURROGATE_MAX;
  }

  static bool isLowSurrogate(int codeUnit) {
    return codeUnit >= LOW_SURROGATE_MIN && codeUnit <= LOW_SURROGATE_MAX;
  }
}

// 用于字符串池的键
class _StringKey {
  final List<int> codeUnits;
  final int _hashCode;

  _StringKey(this.codeUnits) : _hashCode = _computeHashCode(codeUnits);

  static int _computeHashCode(List<int> codeUnits) {
    int hash = 0;
    for (int codeUnit in codeUnits) {
      hash = 31 * hash + codeUnit;
    }
    return hash;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! _StringKey) return false;
    if (hashCode != other.hashCode) return false;
    if (codeUnits.length != other.codeUnits.length) return false;
    for (int i = 0; i < codeUnits.length; i++) {
      if (codeUnits[i] != other.codeUnits[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => _hashCode;
}

// 字符串匹配结果
class StringMatch {
  final PooledString source;
  final int start;
  final int end;

  StringMatch(this.source, this.start, this.end);

  PooledString get matched => source.substring(start, end);

  @override
  String toString() =>
      'StringMatch(start: $start, end: $end, matched: $matched)';
}

class PooledString implements String {
  // 字符串池
  static final Map<_StringKey, PooledString> _stringPool = {};

  // 实际存储的代码单元
  final List<int> _codeUnits;

  // 缓存的哈希码
  late final int _hashCode;

  // 空字符串单例
  static final PooledString empty = PooledString._([]);

  // 私有构造函数
  PooledString._(List<int> codeUnits)
      : _codeUnits = List.unmodifiable(codeUnits) {
    _hashCode = _computeHashCode();
  }

  // 计算哈希码
  int _computeHashCode() {
    int hash = 0;
    for (int codeUnit in _codeUnits) {
      hash = 31 * hash + codeUnit;
    }
    return hash;
  }

  // 字符串池管理方法
  static void clearPool() {
    _stringPool.clear();
  }

  static int get poolSize => _stringPool.length;

  static bool isInterned(List<int> codeUnits) {
    return _stringPool.containsKey(_StringKey(codeUnits));
  }

  // 工厂构造方法
  factory PooledString.fromCodeUnits(List<int> codeUnits) {
    if (codeUnits.isEmpty) return empty;
    var key = _StringKey(codeUnits);
    return _stringPool.putIfAbsent(
        key, () => PooledString._(List<int>.from(codeUnits)));
  }

  factory PooledString.fromUtf8(List<int> bytes) {
    if (bytes.isEmpty) return empty;
    List<int> codeUnits = _utf8Decode(bytes);
    return PooledString.fromCodeUnits(codeUnits);
  }

  factory PooledString.fromUtf16(List<int> units) {
    if (units.isEmpty) return empty;
    return PooledString.fromCodeUnits(List<int>.from(units));
  }

  factory PooledString.fromCharCodes(Iterable<int> charCodes) {
    return PooledString.fromCodeUnits(charCodes.toList());
  }

  // UTF-8 解码
  static List<int> _utf8Decode(List<int> bytes) {
    List<int> codeUnits = [];
    int i = 0;
    while (i < bytes.length) {
      int byte = bytes[i];
      if (byte < 0x80) {
        // 单字节 ASCII
        codeUnits.add(byte);
        i++;
      } else if (byte < 0xE0) {
        // 双字节
        if (i + 1 >= bytes.length) throw FormatException('Invalid UTF-8');
        int value = ((byte & 0x1F) << 6) | (bytes[i + 1] & 0x3F);
        codeUnits.add(value);
        i += 2;
      } else if (byte < 0xF0) {
        // 三字节
        if (i + 2 >= bytes.length) throw FormatException('Invalid UTF-8');
        int value = ((byte & 0x0F) << 12) |
            ((bytes[i + 1] & 0x3F) << 6) |
            (bytes[i + 2] & 0x3F);
        codeUnits.add(value);
        i += 3;
      } else {
        // 四字节
        if (i + 3 >= bytes.length) throw FormatException('Invalid UTF-8');
        int value = ((byte & 0x07) << 18) |
            ((bytes[i + 1] & 0x3F) << 12) |
            ((bytes[i + 2] & 0x3F) << 6) |
            (bytes[i + 3] & 0x3F);
        // 将四字节UTF-8转换为代理对
        value -= 0x10000;
        codeUnits.add(0xD800 | (value >> 10));
        codeUnits.add(0xDC00 | (value & 0x3FF));
        i += 4;
      }
    }
    return codeUnits;
  }

  // 编码方法
  List<int> toUtf8() {
    List<int> bytes = [];
    for (int i = 0; i < _codeUnits.length; i++) {
      int codeUnit = _codeUnits[i];
      if (codeUnit < 0x80) {
        // ASCII
        bytes.add(codeUnit);
      } else if (codeUnit < 0x800) {
        // 双字节
        bytes.add(0xC0 | (codeUnit >> 6));
        bytes.add(0x80 | (codeUnit & 0x3F));
      } else if (CodeUnit.isHighSurrogate(codeUnit)) {
        // 代理对
        if (i + 1 >= _codeUnits.length) {
          throw FormatException('Invalid surrogate pair');
        }
        int nextCodeUnit = _codeUnits[i + 1];
        if (!CodeUnit.isLowSurrogate(nextCodeUnit)) {
          throw FormatException('Invalid surrogate pair');
        }
        int value = 0x10000 + ((codeUnit - CodeUnit.HIGH_SURROGATE_MIN) << 10) |
            (nextCodeUnit - CodeUnit.LOW_SURROGATE_MIN);
        // 四字节UTF-8
        bytes.add(0xF0 | (value >> 18));
        bytes.add(0x80 | ((value >> 12) & 0x3F));
        bytes.add(0x80 | ((value >> 6) & 0x3F));
        bytes.add(0x80 | (value & 0x3F));
        i++;
      } else {
        // 三字节
        bytes.add(0xE0 | (codeUnit >> 12));
        bytes.add(0x80 | ((codeUnit >> 6) & 0x3F));
        bytes.add(0x80 | (codeUnit & 0x3F));
      }
    }
    return bytes;
  }

  List<int> toUtf16() => List<int>.from(_codeUnits);

  // 基本属性和访问方法
  int get length => _codeUnits.length;
  bool get isEmpty => _codeUnits.isEmpty;
  bool get isNotEmpty => _codeUnits.isNotEmpty;
  List<int> get codeUnits => List.unmodifiable(_codeUnits);

  int codeUnitAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length);
    }
    return _codeUnits[index];
  }

  // 比较操作
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PooledString) return false;
    if (length != other.length) return false;
    if (_hashCode != other._hashCode) return false;
    for (int i = 0; i < length; i++) {
      if (_codeUnits[i] != other._codeUnits[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => _hashCode;

  int compareTo(PooledString other) {
    final int len1 = length;
    final int len2 = other.length;
    final int lim = len1 < len2 ? len1 : len2;

    for (int i = 0; i < lim; i++) {
      int c1 = _codeUnits[i];
      int c2 = other._codeUnits[i];
      if (c1 != c2) {
        return c1 - c2;
      }
    }
    return len1 - len2;
  }

  // 字符串操作
  PooledString operator +(PooledString other) {
    if (isEmpty) return other;
    if (other.isEmpty) return this;
    var newCodeUnits = List<int>.from(_codeUnits)..addAll(other._codeUnits);
    return PooledString.fromCodeUnits(newCodeUnits);
  }

  PooledString operator *(int times) {
    if (times <= 0) return empty;
    if (times == 1) return this;
    var newCodeUnits = <int>[];
    for (int i = 0; i < times; i++) {
      newCodeUnits.addAll(_codeUnits);
    }
    return PooledString.fromCodeUnits(newCodeUnits);
  }

  PooledString substring(int start, [int? end]) {
    RangeError.checkValidRange(start, end, length);
    end ??= length;
    if (start == 0 && end == length) return this;
    if (start == end) return empty;
    return PooledString.fromCodeUnits(_codeUnits.sublist(start, end));
  }

  // 大小写转换
  PooledString toLowerCase() {
    var newCodeUnits = List<int>.from(_codeUnits);
    for (int i = 0; i < newCodeUnits.length; i++) {
      newCodeUnits[i] = CodeUnit.toLowerCase(newCodeUnits[i]);
    }
    return PooledString.fromCodeUnits(newCodeUnits);
  }

  PooledString toUpperCase() {
    var newCodeUnits = List<int>.from(_codeUnits);
    for (int i = 0; i < newCodeUnits.length; i++) {
      newCodeUnits[i] = CodeUnit.toUpperCase(newCodeUnits[i]);
    }
    return PooledString.fromCodeUnits(newCodeUnits);
  }

  // 修剪操作
  PooledString trim() {
    int start = 0;
    int end = length;

    while (start < end && CodeUnit.isWhitespace(_codeUnits[start])) {
      start++;
    }

    while (end > start && CodeUnit.isWhitespace(_codeUnits[end - 1])) {
      end--;
    }

    if (start == 0 && end == length) return this;
    return substring(start, end);
  }

  PooledString trimLeft() {
    int start = 0;
    while (start < length && CodeUnit.isWhitespace(_codeUnits[start])) {
      start++;
    }
    return start > 0 ? substring(start) : this;
  }

  PooledString trimRight() {
    int end = length;
    while (end > 0 && CodeUnit.isWhitespace(_codeUnits[end - 1])) {
      end--;
    }
    return end < length ? substring(0, end) : this;
  }

  // 填充操作
  PooledString padLeft(int width, [PooledString? padding]) {
    padding ??= PooledString.fromCodeUnits([CodeUnit.SPACE]);
    if (length >= width) return this;

    int padLength = width - length;
    var newCodeUnits = <int>[];

    while (padLength > 0) {
      if (padLength >= padding.length) {
        newCodeUnits.addAll(padding._codeUnits);
        padLength -= padding.length;
      } else {
        newCodeUnits.addAll(padding._codeUnits.sublist(0, padLength));
        padLength = 0;
      }
    }

    newCodeUnits.addAll(_codeUnits);
    return PooledString.fromCodeUnits(newCodeUnits);
  }

  PooledString padRight(int width, [PooledString? padding]) {
    padding ??= PooledString.fromCodeUnits([CodeUnit.SPACE]);
    if (length >= width) return this;

    int padLength = width - length;
    var newCodeUnits = List<int>.from(_codeUnits);

    while (padLength > 0) {
      if (padLength >= padding.length) {
        newCodeUnits.addAll(padding._codeUnits);
        padLength -= padding.length;
      } else {
        newCodeUnits.addAll(padding._codeUnits.sublist(0, padLength));
        padLength = 0;
      }
    }

    return PooledString.fromCodeUnits(newCodeUnits);
  }

  // 查找和匹配
  int indexOf(PooledString pattern, [int start = 0]) {
    if (start < 0) start = 0;
    if (pattern.isEmpty || start >= length) return -1;

    outer:
    for (int i = start; i <= length - pattern.length; i++) {
      for (int j = 0; j < pattern.length; j++) {
        if (_codeUnits[i + j] != pattern._codeUnits[j]) {
          continue outer;
        }
      }
      return i;
    }
    return -1;
  }

  int lastIndexOf(PooledString pattern, [int? start]) {
    start ??= length - pattern.length;
    if (pattern.isEmpty) return start.clamp(0, length);
    if (start < 0) return -1;

    outer:
    for (int i = start.clamp(0, length - pattern.length); i >= 0; i--) {
      for (int j = 0; j < pattern.length; j++) {
        if (_codeUnits[i + j] != pattern._codeUnits[j]) {
          continue outer;
        }
      }
      return i;
    }
    return -1;
  }

  // Pattern 接口实现
  Iterable<StringMatch> allMatches(PooledString source, [int start = 0]) {
    var matches = <StringMatch>[];
    while (start <= source.length - length) {
      int index = source.indexOf(this, start);
      if (index == -1) break;
      matches.add(StringMatch(source, index, index + length));
      start = index + 1;
    }
    return matches;
  }

  StringMatch? matchAsPrefix(PooledString source, [int start = 0]) {
    if (start < 0) start = 0;
    if (start + length > source.length) return null;

    for (int i = 0; i < length; i++) {
      if (_codeUnits[i] != source._codeUnits[start + i]) {
        return null;
      }
    }
    return StringMatch(source, start, start + length);
  }

  // 替换操作
  PooledString replaceAll(PooledString from, PooledString to) {
    if (from.isEmpty) return this;

    List<int> result = [];
    int start = 0;
    int match;

    while ((match = indexOf(from, start)) != -1) {
      result.addAll(_codeUnits.sublist(start, match));
      result.addAll(to._codeUnits);
      start = match + from.length;
    }

    if (start < length) {
      result.addAll(_codeUnits.sublist(start));
    }

    return result.isEmpty ? this : PooledString.fromCodeUnits(result);
  }

  PooledString replaceRange(int start, int? end, PooledString replacement) {
    RangeError.checkValidRange(start, end, length);
    end ??= length;

    List<int> result = List<int>.from(_codeUnits);
    result.replaceRange(start, end, replacement._codeUnits);
    return PooledString.fromCodeUnits(result);
  }

  // 分割操作
  List<PooledString> split(PooledString pattern) {
    if (pattern.isEmpty) {
      return List.generate(
          length, (i) => PooledString.fromCodeUnits([_codeUnits[i]]));
    }

    List<PooledString> result = [];
    int start = 0;
    int match;

    while ((match = indexOf(pattern, start)) != -1) {
      result.add(substring(start, match));
      start = match + pattern.length;
    }

    result.add(substring(start));
    return result;
  }

  // 判断操作
  bool contains(PooledString other, [int startIndex = 0]) {
    return indexOf(other, startIndex) >= 0;
  }

  bool startsWith(PooledString pattern, [int start = 0]) {
    if (start < 0) return false;
    if (start + pattern.length > length) return false;
    for (int i = 0; i < pattern.length; i++) {
      if (_codeUnits[start + i] != pattern._codeUnits[i]) {
        return false;
      }
    }
    return true;
  }

  bool endsWith(PooledString pattern) {
    if (pattern.length > length) return false;
    int start = length - pattern.length;
    for (int i = 0; i < pattern.length; i++) {
      if (_codeUnits[start + i] != pattern._codeUnits[i]) {
        return false;
      }
    }
    return true;
  }

  // 迭代器支持
  Iterator<int> get iterator => _codeUnits.iterator;

  // 格式化支持
  static PooledString format(PooledString pattern, List<Object> args) {
    List<int> result = [];
    int argIndex = 0;
    bool inPlaceholder = false;

    for (int i = 0; i < pattern.length; i++) {
      int char = pattern._codeUnits[i];

      if (char == 0x25) {
        // %
        if (i + 1 < pattern.length && pattern._codeUnits[i + 1] == 0x25) {
          // %% -> %
          result.add(char);
          i++;
        } else {
          inPlaceholder = true;
        }
      } else if (inPlaceholder) {
        if (argIndex >= args.length) {
          throw FormatException('Not enough arguments');
        }

        // 简单的格式化支持
        switch (char) {
          case 0x73: // s
            var arg = args[argIndex++];
            if (arg is PooledString) {
              result.addAll(arg._codeUnits);
            } else {
              result.addAll(PooledString.fromCodeUnits(arg.toString().codeUnits)
                  ._codeUnits);
            }
            break;
          case 0x64: // d
            var arg = args[argIndex++];
            if (arg is! num) {
              throw FormatException('Expected number for %d');
            }
            result.addAll(
                PooledString.fromCodeUnits(arg.round().toString().codeUnits)
                    ._codeUnits);
            break;
          default:
            throw FormatException('Unsupported format character');
        }
        inPlaceholder = false;
      } else {
        result.add(char);
      }
    }

    if (inPlaceholder) {
      throw FormatException('Incomplete format pattern');
    }

    return PooledString.fromCodeUnits(result);
  }

  // 数字转换支持
  static PooledString fromNumber(num value) {
    return PooledString.fromCodeUnits(value.toString().codeUnits);
  }

  // 布尔值转换支持
  static final PooledString trueValue =
      PooledString.fromCodeUnits('true'.codeUnits);
  static final PooledString falseValue =
      PooledString.fromCodeUnits('false'.codeUnits);

  static PooledString fromBool(bool value) {
    return value ? trueValue : falseValue;
  }

  // 连接多个字符串
  static PooledString join(Iterable<PooledString> strings,
      [PooledString? separator]) {
    if (strings.isEmpty) return empty;

    separator ??= empty;
    if (strings.length == 1) return strings.first;

    List<int> result = [];
    bool first = true;

    for (var str in strings) {
      if (!first && separator.isNotEmpty) {
        result.addAll(separator._codeUnits);
      }
      result.addAll(str._codeUnits);
      first = false;
    }

    return PooledString.fromCodeUnits(result);
  }

  // 构建支持
  static PooledStringBuilder builder() => PooledStringBuilder();
}

// 字符串构建器
class PooledStringBuilder {
  final List<int> _buffer = [];

  void write(PooledString str) {
    _buffer.addAll(str._codeUnits);
  }

  void writeCodeUnit(int codeUnit) {
    _buffer.add(codeUnit);
  }

  void writeCodeUnits(List<int> codeUnits) {
    _buffer.addAll(codeUnits);
  }

  PooledString build() {
    return PooledString.fromCodeUnits(_buffer);
  }

  void clear() {
    _buffer.clear();
  }

  int get length => _buffer.length;
}

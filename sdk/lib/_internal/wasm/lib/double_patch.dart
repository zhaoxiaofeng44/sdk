// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:math' as math;
part of "core_patch.dart";

@patch
class double {
  @patch
  static double parse(String source) {
    double? result = tryParse(source);
    if (result == null) {
      throw FormatException('Invalid double $source');
    }
    return result;
  }

  // @patch
  // static double? tryParse(String source) {
  //   // Notice that JS parseFloat accepts garbage at the end of the string.
  //   // Accept only:
  //   // - [+/-]NaN
  //   // - [+/-]Infinity
  //   // - a Dart double literal
  //   // We do allow leading or trailing whitespace.
  //   double result = JS<double>(r"""s => {
  //     if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
  //       return NaN;
  //     }
  //     return parseFloat(s);
  //   }""", jsStringFromDartString(source).toExternRef);
  //   if (result.isNaN) {
  //     String trimmed = source.trim();
  //     if (!(trimmed == 'NaN' || trimmed == '+NaN' || trimmed == '-NaN')) {
  //       return null;
  //     }
  //   }
  //   return result;
  // }
  @patch
  static double? tryParse(String source) {
    final trimmed = source.trim();
    if (trimmed.isEmpty) return null;

    // // 匹配有效数字模式的正则表达式
    // if (!_validDoublePattern.hasMatch(trimmed)) {
    //   return _parseSpecialCases(trimmed);
    // }

    if (trimmed == 'NaN') return double.nan;
    if (trimmed == '+NaN') return double.nan;
    if (trimmed == '-NaN') return -double.nan;
    if (trimmed == 'Infinity') return double.infinity;
    if (trimmed == '+Infinity') return double.infinity;
    if (trimmed == '-Infinity') return double.negativeInfinity;

    return _parseDartDouble(trimmed);
  }

// // 验证正则表达式（等效原JS版本）
//   static final RegExp _validDoublePattern = RegExp(r'^[+-]?(?:'
//       r'Infinity|'
//       r'NaN|'
//       r'(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?'
//       r')$');

// 处理特殊值
  // static double? _parseSpecialCases(String s) {
  //   if (s == 'NaN') return double.nan;
  //   if (s == '+NaN') return double.nan;
  //   if (s == '-NaN') return -double.nan;
  //   if (s == 'Infinity') return double.infinity;
  //   if (s == '+Infinity') return double.infinity;
  //   if (s == '-Infinity') return double.negativeInfinity;
  //   return null;
  // }

// 核心解析逻辑
  static double? _parseDartDouble(String s) {
    double sign = 1.0;
    int index = 0;
    final chars = s.codeUnits;

    // 处理符号
    if (chars[0] == 0x2B /* '+' */) {
      index++;
    } else if (chars[0] == 0x2D /* '-' */) {
      sign = -1.0;
      index++;
    }

    // 数值解析状态
    var integer = 0.0;
    var fraction = 0.0;
    var exponent = 0;
    var decimalPlace = 0.0;
    var hasInteger = false;
    var hasFraction = false;

    // 解析整数部分
    while (index < chars.length) {
      final c = chars[index];
      if (c == 0x2E /* '.' */) break;
      if (c == 0x65 || c == 0x45 /* 'e' or 'E' */) break;
      if (c < 0x30 || c > 0x39) return double.nan;

      integer = integer * 10 + (c - 0x30);
      hasInteger = true;
      index++;
    }

    // 解析小数部分
    if (index < chars.length && chars[index] == 0x2E) {
      index++;
      decimalPlace = 1.0;

      while (index < chars.length) {
        final c = chars[index];
        if (c == 0x65 || c == 0x45) break;
        if (c < 0x30 || c > 0x39) return double.nan;

        fraction = fraction * 10 + (c - 0x30);
        decimalPlace *= 10;
        hasFraction = true;
        index++;
      }
    }

    // 解析指数部分
    if (index < chars.length &&
        (chars[index] == 0x65 || chars[index] == 0x45)) {
      index++;
      var expSign = 1;

      if (index < chars.length) {
        if (chars[index] == 0x2B) {
          index++;
        } else if (chars[index] == 0x2D) {
          expSign = -1;
          index++;
        }
      }

      while (index < chars.length) {
        final c = chars[index];
        if (c < 0x30 || c > 0x39) return double.nan;

        exponent = exponent * 10 + (c - 0x30);
        index++;
      }

      exponent *= expSign;
    }

    // 计算结果
    double value = (integer + (hasFraction ? fraction / decimalPlace : 0.0));
    if (exponent != 0) value *= math.pow(10, exponent);

    // 处理全零的特殊情况
    if (value == 0.0 && (hasInteger || hasFraction)) {
      return sign * value;
    }

    return value.isFinite ? sign * value : null;
  }
}

/// 运算符名称映射 — 统一的 vptr key 与静态函数后缀。
///
/// 从 restorer 的 `_vptrEntryKey` / `_operatorFuncName` 和
/// cpp_compiler 的 `operatorVptrKey` / `operatorCppSuffix` 合并。
library operator_names;

import 'analysis_context.dart';

/// 运算符 → vptr key / 函数名后缀 的统一映射。
class OperatorNames {
  OperatorNames._();

  /// 运算符文本 → vptr key 后缀。
  /// 如 `+` → `operatorPlus`，`==` → `operatorEq`。
  static const Map<String, String> _operatorVptrSuffix = {
    '+': 'operatorPlus',
    '-': 'operatorMinus',
    '*': 'operatorStar',
    '/': 'operatorSlash',
    '~/': 'operatorTildeSlash',
    '%': 'operatorPercent',
    '<': 'operatorLt',
    '>': 'operatorGt',
    '<=': 'operatorLe',
    '>=': 'operatorGe',
    '==': 'operatorEq',
    '[]': 'operatorIndex',
    '[]=': 'operatorIndexSet',
    'unary-': 'operatorUnaryMinus',
    '~': 'operatorTilde',
    '|': 'operatorPipe',
    '&': 'operatorAmpersand',
    '^': 'operatorCaret',
    '<<': 'operatorShiftLeft',
    '>>': 'operatorShiftRight',
  };

  /// 获取 vptr key。
  ///
  /// - 普通方法：直接使用 [name]
  /// - getter：`get_$name`
  /// - setter：`set_$name`
  /// - 运算符：`$operatorSuffix`（如 `operatorPlus`）
  static String vptrKey(String name, VTableEntryKind kind) {
    switch (kind) {
      case VTableEntryKind.method:
        return _operatorVptrSuffix[name] ?? name;
      case VTableEntryKind.getter:
        return 'get_$name';
      case VTableEntryKind.setter:
        return 'set_$name';
      case VTableEntryKind.operator_:
        return _operatorVptrSuffix[name] ?? name;
    }
  }

  /// 是否为二元运算符。
  static bool isBinaryOp(String name) =>
      _operatorVptrSuffix.containsKey(name) &&
      name != 'unary-' &&
      name != '~' &&
      name != '[]' &&
      name != '[]=';

  /// 是否为运算符名称。
  static bool isOperator(String name) =>
      _operatorVptrSuffix.containsKey(name);

  /// 获取运算符的 C++ 后缀名（用于函数命名，如 `Dog_operatorPlus`）。
  static String cppSuffix(String name) =>
      _operatorVptrSuffix[name] ?? name;

  /// 从 VTableEntryKind 和 Procedure 推断静态函数名后缀。
  static String staticFuncSuffix(String methodName, VTableEntryKind kind) {
    switch (kind) {
      case VTableEntryKind.method:
        if (isOperator(methodName)) return cppSuffix(methodName);
        return methodName;
      case VTableEntryKind.getter:
        return 'get_$methodName';
      case VTableEntryKind.setter:
        return 'set_$methodName';
      case VTableEntryKind.operator_:
        return cppSuffix(methodName);
    }
  }

  /// 生成完整的静态函数名：`ClassName_suffix`。
  static String staticFuncName(
      String className, String methodName, VTableEntryKind kind) {
    return '${className}_${staticFuncSuffix(methodName, kind)}';
  }

  /// 清洗扩展方法名（如 `Ext|get#prop` → `Ext_get_prop`）。
  static String sanitizeExtensionMethodName(String name) {
    return name
        .replaceAll('|', '_')
        .replaceAll('#', '_')
        .replaceAll('=', '_eq')
        .replaceAll('<', '_lt')
        .replaceAll('>', '_gt');
  }
}

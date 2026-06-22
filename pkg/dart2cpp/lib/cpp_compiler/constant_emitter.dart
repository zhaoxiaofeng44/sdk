/// Dart→C++ 常量生成器
///
/// 将 Dart Kernel Constant 节点转换为 C++ 表达式。
/// 镜像 `lib/restorer/constant_restorer.dart`。
library;

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

import 'type_mapper.dart';

/// C++ 常量生成器。
class ConstantEmitter {
  final TypeMapper typeMapper;

  ConstantEmitter(this.typeMapper);

  /// 将 Kernel Constant 转换为 C++ 表达式
  String emit(Constant constant) {
    if (constant is IntConstant) return constant.value.toString();
    if (constant is DoubleConstant) {
      final s = constant.value.toString();
      if (!s.contains('.') && !s.contains('e') && !s.contains('E')) {
        return '$s.0';
      }
      return s;
    }
    if (constant is BoolConstant) return constant.value ? 'true' : 'false';
    if (constant is StringConstant) {
      return '"${_escapeString(constant.value)}"';
    }
    if (constant is NullConstant) return 'AnyPtr()';

    if (constant is ListConstant) {
      if (constant.entries.isEmpty) return 'StaticList<AnyPtr>::empty()';
      final elements = constant.entries.map((e) => emit(e)).join(', ');
      return 'StaticList<AnyPtr>::of({$elements})';
    }

    if (constant is SetConstant) {
      if (constant.entries.isEmpty) return 'StaticSet<AnyPtr>::empty()';
      final elements = constant.entries.map((e) => emit(e)).join(', ');
      return 'StaticSet<AnyPtr>::of({$elements})';
    }

    if (constant is MapConstant) {
      if (constant.entries.isEmpty) return 'StaticMap<AnyPtr, AnyPtr>::empty()';
      final entries = constant.entries.map((e) {
        final key = emit(e.key);
        final value = emit(e.value);
        return 'StaticMapEntry<AnyPtr, AnyPtr>($key, $value)';
      }).join(', ');
      return 'StaticMap<AnyPtr, AnyPtr>::of({$entries})';
    }

    if (constant is InstanceConstant) {
      return _emitInstanceConstant(constant);
    }

    if (constant is TearOffConstant) {
      return _emitTearOffConstant(constant);
    }

    if (constant is TypeLiteralConstant) {
      return '/* TypeLiteral */';
    }

    if (constant is SymbolConstant) {
      return '"${constant.name}"';
    }

    return 'AnyPtr()';
  }

  String _emitInstanceConstant(InstanceConstant constant) {
    final className = constant.classNode.name;
    // 用户类 → _new 调用
    if (typeMapper.isUserClass(className)) {
      // 构建构造参数（从field值映射）
      final fieldValues = <String>[];
      for (final entry in constant.fieldValues.entries) {
        final fieldValue = emit(entry.value);
        fieldValues.add(fieldValue);
      }
      final args = fieldValues.join(', ');
      return '${className}_new(GC::allocateLocal(new ${className}Value())${args.isNotEmpty ? ', $args' : ''})';
    }
    // SDK 类 → 根据类型生成构造表达式
    switch (className) {
      case 'Duration':
        final micros = constant.fieldValues.entries
            .where((e) => e.key.asField.name.text == '_microseconds')
            .map((e) => emit(e.value))
            .firstOrNull ?? '0';
        return 'StaticDuration($micros)';
      case 'DateTime':
        return 'StaticDateTime()';
      default:
        return 'AnyPtr()';
    }
  }

  String _emitTearOffConstant(TearOffConstant constant) {
    // TearOffConstant 表示方法引用（函数指针/闭包）
    // 在C++中通过静态函数名表示
    // Kernel API: TearOffConstant有procedure属性（较新版本）或target属性
    try {
      // 尝试新版本API
      final proc = (constant as dynamic).procedure;
      if (proc is Procedure) {
        final cls = proc.enclosingClass;
        if (cls != null && !proc.isStatic) {
          // 实例方法的tear-off → 返回对应的静态委托函数名
          // 实际调用时需要通过TypeFunction包装结合receiver进行派发
          final methodName = proc.name.text;
          if (proc.isGetter) {
            return '${cls.name}_get_$methodName';
          } else if (proc.isSetter) {
            return '${cls.name}_set_$methodName';
          } else if (TypeMapper.isOperatorName(methodName)) {
            return '${cls.name}_operator${TypeMapper.operatorCppSuffix(methodName)}';
          }
          return '${cls.name}_$methodName';
        }
        if (cls != null && proc.isStatic) {
          return '${cls.name}_${proc.name.text}';
        }
        return typeMapper.cleanIdentifier(proc.name.text);
      }
    } catch (_) {}
    try {
      // 尝试旧版本API
      final target = (constant as dynamic).target;
      if (target is Member) {
        final name = target.name.text;
        if (target.enclosingClass != null) {
          return '${target.enclosingClass!.name}_$name';
        }
        return typeMapper.cleanIdentifier(name);
      }
    } catch (_) {}
    // 无法解析的TearOffConstant → 退化为AnyPtr
    return 'AnyPtr()';
  }

  String _escapeString(String s) {
    return s
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }
}

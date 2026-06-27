/// 常量转换器 — 将 Kernel Constant 转为 IrExpression。
///
/// 合并自：
/// - `restorer/constant_restorer.dart` 的 `_restoreConstant`
/// - `cpp_compiler/constant_emitter.dart` 的 `emit`
library constant_transformer;

import 'package:kernel/kernel.dart';
import 'package:dart2cpp/ir/ir_nodes.dart';
import 'ir_transformer.dart';

/// 常量转换器。
class ConstantTransformer {
  final IrTransformer ir;

  ConstantTransformer(this.ir);

  /// 将 Kernel Constant 转为 IrExpression。
  IrExpression transform(Constant constant) {
    if (constant is IntConstant) {
      return IrIntLiteral(constant.value);
    }
    if (constant is DoubleConstant) {
      return IrDoubleLiteral(constant.value);
    }
    if (constant is BoolConstant) {
      return IrBoolLiteral(constant.value);
    }
    if (constant is StringConstant) {
      return IrStringLiteral(constant.value);
    }
    if (constant is NullConstant) {
      return const IrNullLiteral();
    }
    if (constant is ListConstant) {
      return _transformListConstant(constant);
    }
    if (constant is SetConstant) {
      return _transformSetConstant(constant);
    }
    if (constant is MapConstant) {
      return _transformMapConstant(constant);
    }
    if (constant is InstanceConstant) {
      return _transformInstanceConstant(constant);
    }
    if (constant is TypeLiteralConstant) {
      return IrTypeLiteral(ir.typeTransformer.transform(constant.type));
    }
    if (constant is SymbolConstant) {
      return IrSymbolLiteral(constant.name);
    }
    if (constant is RecordConstant) {
      return _transformRecordConstant(constant);
    }
    if (constant is StaticTearOffConstant) {
      return _transformStaticTearOff(constant);
    }
    if (constant is ConstructorTearOffConstant) {
      return _transformConstructorTearOff(constant);
    }

    // Fallback
    return IrRawCode(
      dartCode: '/* unknown constant: ${constant.runtimeType} */',
      cppCode: '/* unknown constant: ${constant.runtimeType} */',
    );
  }

  IrExpression _transformListConstant(ListConstant constant) {
    final elements =
        constant.entries.map((e) => transform(e)).toList();
    return IrListLiteral(elements, typeArgs: const [], isConst: true);
  }

  IrExpression _transformSetConstant(SetConstant constant) {
    final elements =
        constant.entries.map((e) => transform(e)).toList();
    return IrSetLiteral(elements, typeArgs: const [], isConst: true);
  }

  IrExpression _transformMapConstant(MapConstant constant) {
    final entries = <IrMapEntry>[];
    for (final entry in constant.entries) {
      entries.add(IrMapEntry(
        transform(entry.key),
        transform(entry.value),
      ));
    }
    return IrMapLiteral(entries, typeArgs: const [], isConst: true);
  }

  IrExpression _transformInstanceConstant(InstanceConstant constant) {
    final className = constant.classNode.name;

    // 检查是否为枚举常量
    if (_isEnumConstant(constant)) {
      return _transformEnumConstant(constant);
    }

    // SDK 特殊类
    if (className == 'Duration') {
      return _transformDurationConstant(constant);
    }

    // 用户类 → X_new(XValue(), args)
    if (ir.ctx.isUserClass(className)) {
      return _transformUserInstanceConstant(constant);
    }

    // Fallback
    return IrRawCode(
      dartCode: '/* instance constant: $className */',
      cppCode: '/* instance constant: $className */',
    );
  }

  bool _isEnumConstant(InstanceConstant constant) {
    final superClass = constant.classNode.supertype?.classNode;
    if (superClass == null) return false;
    return superClass.name == '_Enum' || superClass.name == 'Enum';
  }

  IrExpression _transformEnumConstant(InstanceConstant constant) {
    // 枚举常量 → EnumName.valueName
    final className = constant.classNode.name;
    // 从 fields 中找 _name 字段
    String? valueName;
    for (final entry in constant.fieldValues.entries) {
      if (entry.key.asField.name.text == '_name' && entry.value is StringConstant) {
        valueName = (entry.value as StringConstant).value;
      }
    }
    if (valueName != null) {
      return IrRawCode(
        dartCode: '$className.$valueName',
        cppCode: '$className::$valueName',
      );
    }
    return IrRawCode(
      dartCode: '$className.values[0]',
      cppCode: '$className(0)',
    );
  }

  IrExpression _transformDurationConstant(InstanceConstant constant) {
    // Duration 常量 → StaticDuration(microseconds)
    int microseconds = 0;
    for (final entry in constant.fieldValues.entries) {
      if (entry.key.asField.name.text == '_duration' &&
          entry.value is IntConstant) {
        microseconds = (entry.value as IntConstant).value;
      }
    }
    return IrRawCode(
      dartCode: 'StaticDuration(microseconds: $microseconds)',
      cppCode: 'StaticDuration($microseconds)',
    );
  }

  IrExpression _transformUserInstanceConstant(InstanceConstant constant) {
    final className = constant.classNode.name;
    final typeArgs = constant.typeArguments
        .map((t) => ir.typeTransformer.transform(t))
        .toList();

    // 收集字段值
    final fieldMap = <String, Constant>{};
    for (final entry in constant.fieldValues.entries) {
      fieldMap[entry.key.asField.name.text] = entry.value;
    }

    // 通过评分找到最佳匹配的构造函数
    final cls = constant.classNode;
    Constructor? bestCtor;
    int bestScore = -1;
    for (final ctor in cls.constructors) {
      if (!ctor.isConst) continue;
      final score = _matchConstructor(ctor, fieldMap);
      if (score > bestScore) {
        bestScore = score;
        bestCtor = ctor;
      }
    }

    // 构建参数
    final args = <IrExpression>[];
    if (bestCtor != null) {
      // 通过初始化列表找到参数到字段的映射
      final paramToField = <String, String>{};
      for (final init in bestCtor.initializers) {
        if (init is FieldInitializer && init.value is VariableGet) {
          final varGet = init.value as VariableGet;
          paramToField[varGet.variable.name ?? ''] = init.field.name.text;
        }
      }

      for (final param in bestCtor.function.positionalParameters) {
        final paramName = param.name ?? '';
        // 先尝试按参数名直接匹配字段
        if (fieldMap.containsKey(paramName)) {
          args.add(transform(fieldMap[paramName]!));
        } else if (paramToField.containsKey(paramName)) {
          // 通过初始化列表映射找到对应的字段
          final fieldName = paramToField[paramName]!;
          if (fieldMap.containsKey(fieldName)) {
            args.add(transform(fieldMap[fieldName]!));
          } else if (param.initializer != null) {
            args.add(ir.expressionTransformer.transform(param.initializer!));
          } else {
            args.add(const IrNullLiteral());
          }
        } else if (param.initializer != null) {
          args.add(ir.expressionTransformer.transform(param.initializer!));
        } else {
          args.add(const IrNullLiteral());
        }
      }
    }

    final ctorName = bestCtor?.name.text ?? '';
    final newFuncName = ctorName.isEmpty
        ? '${className}_new'
        : '${className}_new_$ctorName';

    return IrConstructorCall(className, newFuncName, args,
        typeArgs: typeArgs, ctorName: ctorName.isEmpty ? null : ctorName);
  }

  /// 评分匹配构造函数：根据字段值判断哪个构造函数被调用
  int _matchConstructor(Constructor ctor, Map<String, Constant> fieldValues) {
    // 构建从参数到字段的映射
    final paramToField = <String, String>{};
    for (final init in ctor.initializers) {
      if (init is FieldInitializer && init.value is VariableGet) {
        final varGet = init.value as VariableGet;
        final paramName = varGet.variable.name;
        if (paramName != null) {
          paramToField[paramName] = init.field.name.text;
        }
      }
    }

    int score = 0;
    final func = ctor.function;

    // 检查位置参数
    for (final param in func.positionalParameters) {
      final paramName = param.name ?? '';
      final fieldName = paramToField[paramName] ?? paramName;
      if (fieldValues.containsKey(fieldName)) {
        final value = fieldValues[fieldName]!;
        // 如果参数类型不允许 null 但字段值为 null，则不匹配
        if (value is NullConstant && param.type.nullability != Nullability.nullable) {
          return -1;
        }
        score++;
      } else if (param.initializer == null && param.isRequired) {
        // 必需的位置参数没有对应字段值，不匹配
        return -1;
      }
    }

    return score;
  }

  IrExpression _transformRecordConstant(RecordConstant constant) {
    final positional =
        constant.positional.map((e) => transform(e)).toList();
    final named = <String, IrExpression>{
      for (final entry in constant.named.entries)
        entry.key: transform(entry.value),
    };
    return IrRecordLiteral(positional, named);
  }

  IrExpression _transformStaticTearOff(StaticTearOffConstant constant) {
    final target = constant.target;
    final className = target.enclosingClass?.name;
    if (className != null && ir.ctx.isUserClass(className)) {
      return IrRawCode(
        dartCode: '${className}_${target.name.text}',
        cppCode: '${className}_${target.name.text}',
      );
    }
    return IrRawCode(
      dartCode: target.name.text,
      cppCode: target.name.text,
    );
  }

  IrExpression _transformConstructorTearOff(
      ConstructorTearOffConstant constant) {
    final className = constant.target.enclosingClass?.name ?? 'Unknown';
    return IrRawCode(
      dartCode: '${className}_new',
      cppCode: '${className}_new',
    );
  }
}

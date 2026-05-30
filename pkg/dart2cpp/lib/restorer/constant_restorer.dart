part of 'dart_restorer.dart';

// ============================================================================
// Constant Restorer
// ============================================================================

mixin _ConstantRestorer on _DartRestorerBase, _TypeUtils {
  // ---- Constants ----

  String _restoreConstant(Constant c) {
    if (c is IntConstant) return '${c.value}';
    if (c is DoubleConstant) {
      if (c.value == c.value.toInt().toDouble()) return '${c.value.toStringAsFixed(1)}';
      return '${c.value}';
    }
    if (c is BoolConstant) return '${c.value}';
    if (c is StringConstant) {
      final escaped = c.value
          .replaceAll('\\', '\\\\')
          .replaceAll("'", "\\'")
          .replaceAll('\n', '\\n');
      return "'$escaped'";
    }
    if (c is NullConstant) return 'null';
    if (c is ListConstant) {
      final items = c.entries.map((e) => _restoreConstant(e)).join(', ');
      // 常量 List 保留为原生 const [] 字面量
      // 参数默认值等 compile-time constant 上下文要求 const 表达式，
      // StaticList.of() 非 const，无法替换
      return 'const [$items]';
    }
    if (c is SetConstant) {
      final items = c.entries.map((e) => _restoreConstant(e)).join(', ');
      return 'const {$items}';
    }
    if (c is MapConstant) {
      final entries = c.entries.map((e) {
        return '${_restoreConstant(e.key)}: ${_restoreConstant(e.value)}';
      }).join(', ');
      return 'const {$entries}';
    }
    if (c is InstanceConstant) {
      final className = c.classNode.name;
      if (className == 'override') return '@override';
      if (className == 'pragma') return '@pragma';
      if (className == 'Duration') {
        return 'Duration()';
      }
      // 检查是否是 enum 值（superclass 是 _Enum）
      if (_isEnumConstant(c)) {
        return _restoreEnumConstant(c);
      }
      // 尝试匹配类的 const 构造函数来还原正确的构造函数调用
      return _restoreInstanceConstant(c);
    }
    if (c is TypeLiteralConstant) return _restoreType(c.type);
    if (c is SymbolConstant) return '#${c.name}';
    if (c is RecordConstant) {
      final parts = <String>[];
      for (final p in c.positional) {
        parts.add(_restoreConstant(p));
      }
      for (final entry in c.named.entries) {
        parts.add('${entry.key}: ${_restoreConstant(entry.value)}');
      }
      return 'const (${parts.join(', ')})';
    }
    // Bug 26: 处理 StaticTearOffConstant / ConstructorTearOffConstant 等 tear-off 常量
    // 这些常量有 target/targetReference 属性指向被 tear-off 的 Procedure/Constructor
    try {
      final target = (c as dynamic).target;
      if (target is Procedure) {
        final name = target.name.text;
        if (target.enclosingClass != null) {
          final className = target.enclosingClass!.name;
          if (_isUserClass(className)) {
            return '${className}_$name';
          }
          return '$className.$name';
        }
        return name;
      }
      if (target is Constructor) {
        final className = target.enclosingClass.name;
        final ctorName = target.name.text;
        if (_isUserClass(className)) {
          return ctorName.isEmpty ? '${className}_new' : '${className}_new_$ctorName';
        }
        return ctorName.isEmpty ? className : '$className.$ctorName';
      }
    } catch (_) {}
    // 尝试 procedure 属性（某些 Kernel 版本使用）
    try {
      final proc = (c as dynamic).procedure;
      if (proc is Procedure) {
        final name = proc.name.text;
        if (proc.enclosingClass != null) {
          return '${proc.enclosingClass!.name}.$name';
        }
        return name;
      }
    } catch (_) {}
    return '/* const ${c.runtimeType} */';
  }

  /// 还原 InstanceConstant 为正确的构造函数调用
  /// Kernel 中 InstanceConstant 只存储字段值映射，需要匹配类的构造函数来还原
  String _restoreInstanceConstant(InstanceConstant c) {
    final cls = c.classNode;
    final className = cls.name;

    // OOP Lowering: 用户自定义类的常量 → X_new(args) 形式
    if (_isUserClass(className)) {
      return _restoreInstanceConstantLowered(c);
    }

    // 收集字段值（排除 null 和默认值以找到最佳构造函数）
    final fieldValues = <String, Constant>{};
    for (final entry in c.fieldValues.entries) {
      fieldValues[entry.key.asField.name.text] = entry.value;
    }

    // 尝试匹配类的 const 构造函数
    Constructor? bestCtor;
    int bestScore = -1;

    for (final ctor in cls.constructors) {
      if (!ctor.isConst) continue;
      final score = _matchConstructor(ctor, fieldValues);
      if (score > bestScore) {
        bestScore = score;
        bestCtor = ctor;
      }
    }

    if (bestCtor != null) {
      return _buildConstantCtorCall(className, bestCtor, fieldValues, c.typeArguments);
    }

    // 回退：使用字段名作为命名参数
    final fields = c.fieldValues.entries.map((e) {
      return '${e.key.asField.name.text}: ${_restoreConstant(e.value)}';
    }).join(', ');
    return 'const $className($fields)';
  }

  /// OOP Lowering: 用户自定义类的 InstanceConstant → X_new(field values)
  String _restoreInstanceConstantLowered(InstanceConstant c) {
    final className = c.classNode.name;
    final cls = c.classNode;

    // 收集字段值
    final fieldValues = <String, Constant>{};
    for (final entry in c.fieldValues.entries) {
      fieldValues[entry.key.asField.name.text] = entry.value;
    }

    // 尝试匹配 const 构造函数来确定参数顺序
    Constructor? bestCtor;
    int bestScore = -1;
    for (final ctor in cls.constructors) {
      if (!ctor.isConst) continue;
      final score = _matchConstructor(ctor, fieldValues);
      if (score > bestScore) {
        bestScore = score;
        bestCtor = ctor;
      }
    }

    if (bestCtor != null) {
      final ctorName = bestCtor.name.text;
      final funcName = ctorName.isEmpty
          ? '${className}_new'
          : '${className}_new_$ctorName';

      // 构建参数列表（按构造函数参数顺序）
      final paramToField = <String, String>{};
      for (final init in bestCtor.initializers) {
        if (init is FieldInitializer && init.value is VariableGet) {
          final varGet = init.value as VariableGet;
          final paramName = varGet.variable.name;
          if (paramName != null) {
            paramToField[paramName] = init.field.name.text;
          }
        }
      }

      final argParts = <String>[];
      for (final param in bestCtor.function.positionalParameters) {
        final paramName = param.name ?? '';
        final fieldName = paramToField[paramName] ?? paramName;
        if (fieldValues.containsKey(fieldName)) {
          argParts.add(_restoreConstant(fieldValues[fieldName]!));
        }
      }
      for (final param in bestCtor.function.namedParameters) {
        final paramName = param.name ?? '';
        final fieldName = paramToField[paramName] ?? paramName;
        if (fieldValues.containsKey(fieldName)) {
          final value = fieldValues[fieldName]!;
          if (param.initializer != null && _isConstantMatchingDefault(value, param.initializer!)) {
            continue;
          }
          argParts.add('$paramName: ${_restoreConstant(value)}');
        }
      }

      final argsStr = argParts.join(', ');
      // 类型参数
      final typeArgs = c.typeArguments.isNotEmpty
          ? '<${c.typeArguments.map(_restoreType).join(', ')}>'
          : '';
      final valueType = '${className}Value$typeArgs';
      // X_new 返回 this_，显式传递泛型类型参数（this_ 为 dynamic 后编译器无法推断）
      return argsStr.isEmpty
          ? '$funcName$typeArgs($valueType())'
          : '$funcName$typeArgs($valueType(), $argsStr)';
    }

    // 回退：使用字段名作为命名参数
    final fields = c.fieldValues.entries.map((e) {
      return '${e.key.asField.name.text}: ${_restoreConstant(e.value)}';
    }).join(', ');
    final typeArgs = c.typeArguments.isNotEmpty
        ? '<${c.typeArguments.map(_restoreType).join(', ')}>'
        : '';
    final valueType = '${className}Value$typeArgs';
    return fields.isEmpty
        ? '${className}_new($valueType())'
        : '${className}_new($valueType(), $fields)';
  }

  /// 计算构造函数与字段值的匹配分数
  /// 返回 -1 表示不匹配，否则返回匹配分数（越高越好）
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

    // 检查位置参数：每个位置参数对应的字段值不应为 null（除非参数类型允许 null）
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
      } else if (param.initializer == null && !param.isRequired) {
        // 必需的位置参数没有对应字段值，不匹配
        return -1;
      }
    }

    return score;
  }

  /// 根据匹配的构造函数构建 const 构造函数调用
  String _buildConstantCtorCall(
    String className,
    Constructor ctor,
    Map<String, Constant> fieldValues,
    List<DartType> typeArguments,
  ) {
    final ctorName = ctor.name.text;
    final func = ctor.function;
    final argParts = <String>[];

    // 构建从参数名到字段名的映射
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

    // 位置参数
    for (final param in func.positionalParameters) {
      final paramName = param.name ?? '';
      final fieldName = paramToField[paramName] ?? paramName;
      if (fieldValues.containsKey(fieldName)) {
        argParts.add(_restoreConstant(fieldValues[fieldName]!));
      }
    }

    // 命名参数（只输出非默认值的）
    for (final param in func.namedParameters) {
      final paramName = param.name ?? '';
      final fieldName = paramToField[paramName] ?? paramName;
      if (fieldValues.containsKey(fieldName)) {
        final value = fieldValues[fieldName]!;
        // 检查是否有默认值且与默认值相同
        if (param.initializer != null && _isConstantMatchingDefault(value, param.initializer!)) {
          continue; // 跳过与默认值相同的命名参数
        }
        argParts.add('$paramName: ${_restoreConstant(value)}');
      }
    }

    // 构建类型参数
    final typeArgs = typeArguments.where((t) => t is! DynamicType).toList();
    final typeArgStr = typeArgs.isNotEmpty
        ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
        : '';

    final argsStr = argParts.join(', ');
    if (ctorName.isEmpty) {
      return 'const $className$typeArgStr($argsStr)';
    }
    return 'const $className$typeArgStr.$ctorName($argsStr)';
  }

  /// 检查常量值是否与表达式的默认值匹配
  bool _isConstantMatchingDefault(Constant value, Expression defaultExpr) {
    if (defaultExpr is IntLiteral && value is IntConstant) {
      return defaultExpr.value == value.value;
    }
    if (defaultExpr is DoubleLiteral && value is DoubleConstant) {
      return defaultExpr.value == value.value;
    }
    if (defaultExpr is BoolLiteral && value is BoolConstant) {
      return defaultExpr.value == value.value;
    }
    if (defaultExpr is StringLiteral && value is StringConstant) {
      return defaultExpr.value == value.value;
    }
    if (defaultExpr is NullLiteral && value is NullConstant) {
      return true;
    }
    return false;
  }

  /// 检查 InstanceConstant 是否是 enum 值
  bool _isEnumConstant(InstanceConstant c) {
    final supertype = c.classNode.supertype;
    if (supertype == null) return false;
    return supertype.classNode.name == '_Enum';
  }

  /// 将 enum 的 InstanceConstant 还原为 EnumName.valueName
  String _restoreEnumConstant(InstanceConstant c) {
    final className = c.classNode.name;
    // 从 enum 类的 static const 字段中找到匹配的值名称
    for (final field in c.classNode.fields) {
      if (!field.isStatic || !field.isConst) continue;
      if (field.name.text == 'values') continue;
      // 检查字段的初始化器是否是相同的常量
      if (field.initializer is ConstantExpression) {
        final fieldConst = (field.initializer as ConstantExpression).constant;
        if (fieldConst == c) {
          return '$className.${field.name.text}';
        }
      }
    }
    // 回退：从 fieldValues 中查找 _name 字段
    for (final entry in c.fieldValues.entries) {
      final fieldName = entry.key.asField.name.text;
      if (fieldName == '_name' && entry.value is StringConstant) {
        final valueName = (entry.value as StringConstant).value;
        return '$className.$valueName';
      }
    }
    return '$className.unknown';
  }
}

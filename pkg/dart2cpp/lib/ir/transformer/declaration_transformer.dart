/// 声明转换器 — 将 Kernel Class/Mixin/Enum/Procedure 转为 IR 声明。
///
/// 合并自：
/// - `restorer/declaration_restorer.dart`
/// - `cpp_compiler/declaration_emitter.dart`
library declaration_transformer;

import 'package:kernel/kernel.dart';
import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/shared.dart';
import 'ir_transformer.dart';

/// 声明转换器。
class DeclarationTransformer {
  final IrTransformer ir;

  DeclarationTransformer(this.ir);

  // -----------------------------------------------------------------------
  // 类
  // -----------------------------------------------------------------------

  /// 转换用户类 → IrValueClass + IrConstructorFunc + IrStaticFunc[] + IrDelegateFunc[]
  List<IrNode> transformClass(Class cls) {
    final className = cls.name.contains('&')
        ? _sanitizeSyntheticName(cls.name)
        : cls.name;
    final parentName = ir.ctx.classHierarchy[className];
    final isSyntheticMixin = ir.ctx.isSyntheticMixin(className);

    // 设置上下文
    final savedClass = ir.currentClass;
    final savedClassName = ir.currentClassName;
    ir.currentClass = cls;
    ir.currentClassName = className;

    // 类型参数替换设置
    _setupTypeParamSubstitution(cls, className, parentName);

    // 1. Value 类
    final valueClass = _buildValueClass(cls, className, parentName, isSyntheticMixin);

    final result = <IrNode>[valueClass];

    // 2. 静态字段
    for (final field in cls.fields) {
      if (field.isStatic) {
        result.add(_buildStaticField(field, className));
      }
    }

    // 3. 构造函数（cls.constructors 只含生成式构造，工厂构造在 cls.procedures 中）
    for (final ctor in cls.constructors) {
      result.add(_buildConstructorFunc(cls, ctor, className, parentName));
    }

    // 获取 vtable 条目（用于后续的字段和委托方法生成）
    final vtableEntries = ir.ctx.getVTableEntries(className);

    // 4. 实例方法 → 静态函数; 静态方法 → 顶层函数; 工厂构造
    for (final proc in cls.procedures) {
      // 跳过 synthetic mixin 的私有 getter/setter
      // 这些在 mixin 中没有生成对应的静态函数
      if (isSyntheticMixin && proc.name.text.startsWith('_')) {
        continue;
      }
      if (!proc.isStatic && !proc.isFactory) {
        result.add(_buildInstanceMethodAsStatic(cls, proc, className));
      } else if (proc.isStatic && !proc.isFactory) {
        result.add(_buildStaticMethod(cls, proc, className));
      } else if (proc.isFactory) {
        result.add(_buildFactoryConstructor(cls, proc, className, parentName));
      }
    }

    // 4.5 为字段生成隐式 getter/setter（如果字段覆盖了父类的抽象 getter/setter）
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      final fieldName = field.name.text;

      // 检查是否有对应的 vtable 条目（即字段覆盖了父类的 getter/setter）
      final hasGetterEntry = vtableEntries.any(
        (e) => e.name == fieldName && e.kind == VTableEntryKind.getter,
      );
      if (hasGetterEntry) {
        // 生成 getter 函数
        final getterFunc = _buildFieldGetter(cls, field, className);
        result.add(getterFunc);
      }

      // 检查是否有对应的 setter 条目（如果字段不是 final）
      if (!field.isFinal) {
        final hasSetterEntry = vtableEntries.any(
          (e) => e.name == fieldName && e.kind == VTableEntryKind.setter,
        );
        if (hasSetterEntry) {
          // 生成 setter 函数
          final setterFunc = _buildFieldSetter(cls, field, className);
          result.add(setterFunc);
        }
      }
    }

    // 5. 委托方法（继承但未覆盖的）
    final ownMethods = cls.procedures
        .where((p) => !p.isStatic && !p.isFactory)
        .map((p) => p.name.text)
        .toSet();

    // 添加字段的隐式 getter/setter 到 ownMethods
    // 当字段覆盖了父类的抽象 getter/setter 时，需要避免生成委托函数
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      ownMethods.add(field.name.text);
    }

    for (final entry in vtableEntries) {
      if (!ownMethods.contains(entry.name) &&
          entry.declaringClassName != className &&
          entry.declaringClassName != null) {
        // 跳过 mixin 的私有 getter/setter（以下划线开头）
        // 这些在 mixin 中没有生成对应的静态函数
        if (ir.ctx.isMixin(entry.declaringClassName!) &&
            entry.name.startsWith('_')) {
          continue;
        }
        result.add(_buildDelegateFunc(cls, entry, className));
      }
    }

    ir.currentClass = savedClass;
    ir.currentClassName = savedClassName;
    ir.typeTransformer.clearTypeParamSubstitution();
    return result;
  }

  /// Build a getter function for a field that overrides an abstract getter
  IrStaticFunc _buildFieldGetter(Class cls, Field field, String className) {
    final fieldName = field.name.text;
    final funcName = '${className}_get_$fieldName';
    final fieldType = ir.typeTransformer.transform(field.type);

    final params = <IrFuncParam>[
      const IrFuncParam('this__', IrDynamicType()),
    ];

    // 添加类的类型参数到方法签名
    final typeParams = ir.typeTransformer.transformTypeParameters(cls.typeParameters);

    // 生成 return this_.fieldName;
    final thisExpr = IrThisExpr(replacementName: 'this_');
    final fieldGet = IrFieldGet(thisExpr, fieldName, type: fieldType);
    final body = IrReturnStmt(value: fieldGet, returnType: fieldType);

    return IrStaticFunc(
      name: funcName,
      params: params,
      returnType: fieldType,
      body: body,
      typeParams: typeParams,
      isGetter: true,
      sourceClassName: className,
    );
  }

  /// Build a setter function for a field that overrides an abstract setter
  IrStaticFunc _buildFieldSetter(Class cls, Field field, String className) {
    final fieldName = field.name.text;
    final funcName = '${className}_set_$fieldName';
    final fieldType = ir.typeTransformer.transform(field.type);

    final params = <IrFuncParam>[
      const IrFuncParam('this__', IrDynamicType()),
      IrFuncParam('value', fieldType),
    ];

    // 添加类的类型参数到方法签名
    final typeParams = ir.typeTransformer.transformTypeParameters(cls.typeParameters);

    // 生成 this_.fieldName = value;
    final thisExpr = IrThisExpr(replacementName: 'this_');
    final valueExpr = IrVariableGet('value', type: fieldType);
    final fieldSet = IrFieldSet(thisExpr, fieldName, valueExpr);
    final body = IrExprStmt(fieldSet);

    return IrStaticFunc(
      name: funcName,
      params: params,
      returnType: const IrVoidType(),
      body: body,
      typeParams: typeParams,
      isSetter: true,
      sourceClassName: className,
    );
  }

  /// Find mixin functions by name
  IrMixinFuncs? _findMixinFuncs(String mixinName) {
    for (final mixin in _processedMixins) {
      if (mixin.mixinName == mixinName) {
        return mixin;
      }
    }
    return null;
  }

  /// Track processed mixins for lookup
  final List<IrMixinFuncs> _processedMixins = [];

  IrValueClass _buildValueClass(
      Class cls, String className, String? parentName, bool isSyntheticMixin) {
    // 父类
    final parentTypeArgs = <IrType>[];
    if (cls.supertype != null) {
      for (final ta in cls.supertype!.typeArguments) {
        parentTypeArgs.add(ir.typeTransformer.transform(ta));
      }
    }

    // implements
    final implementsNames = <String>[];
    for (final impl in cls.implementedTypes) {
      final ifaceName = impl.classNode.name;
      if (ir.ctx.isUserClass(ifaceName)) {
        implementsNames.add(ifaceName);
      }
    }

    // 类型参数
    final typeParams =
        ir.typeTransformer.transformTypeParameters(cls.typeParameters);

    // 字段
    final fields = <IrFieldDef>[];
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      if (field.name.text.startsWith('_') && field.name.text.endsWith('#')) continue;
      final name = field.name.text;
      final type = ir.typeTransformer.transform(field.type);
      IrExpression? defaultValue;
      if (field.initializer != null) {
        defaultValue = ir.expressionTransformer.transform(field.initializer!);
      }
      fields.add(IrFieldDef(name, type, defaultValue: defaultValue));
    }

    // 对于 synthetic mixin 类，需要添加来自 mixin 的实例字段
    if (isSyntheticMixin) {
      // 解析 synthetic class name 以获取 mixin 名称
      // 格式: BaseClass_Mixin1_Mixin2_...
      final parts = className.split('_');
      if (parts.length > 1) {
        // 跳过第一个部分（BaseClass），其余部分是 mixin 名称
        for (var i = 1; i < parts.length; i++) {
          final mixinName = parts[i];
          if (ir.ctx.isMixin(mixinName)) {
            // 查找 mixin 的 instance fields
            final mixinFuncs = _findMixinFuncs(mixinName);
            if (mixinFuncs != null) {
              // 添加 mixin 的实例字段（避免重复）
              for (final mixinField in mixinFuncs.instanceFields) {
                if (!fields.any((f) => f.name == mixinField.name)) {
                  fields.add(mixinField);
                }
              }
            }
          }
        }
      }
    }

    // vptr 条目
    final vptrEntries = _buildVptrRegistrations(cls, className);

    return IrValueClass(
      className: className,
      parentClassName: parentName,
      parentTypeArgs: parentTypeArgs,
      implementsNames: implementsNames,
      typeParams: typeParams,
      fields: fields,
      vptrEntries: vptrEntries,
      isSyntheticMixin: isSyntheticMixin,
    );
  }

  List<IrVptrRegistration> _buildVptrRegistrations(Class cls, String className) {
    final entries = ir.ctx.getVTableEntries(className);
    final registrations = <IrVptrRegistration>[];

    // Get class type parameter names for tear-off type arguments
    final classTypeParamNames = cls.typeParameters
        .map((tp) => tp.name ?? 'T')
        .toList();
    final classTypeArgsStr = classTypeParamNames.isNotEmpty
        ? '<${classTypeParamNames.join(', ')}>'
        : '';

    for (final entry in entries) {
      // Register methods declared in this class OR overridden by this class
      // (overridden methods have staticFuncName starting with className)
      final isDeclaredHere = entry.declaringClassName == className;
      final isOverriddenHere = entry.staticFuncName.startsWith('${className}_');

      if (!isDeclaredHere && !isOverriddenHere) continue;

      final key = entry.vptrKey;

      // Check if this method uses class type parameters
      // If yes, we need to tear off with class type arguments
      String dartCode = entry.staticFuncName;
      String cppCode = entry.staticFuncName;

      if (entry.proc != null) {
        final methodFunc = entry.proc!.function;
        // Check if method signature references class type parameters
        // or if the method itself is a template method
        final usesClassTypeParams = _methodUsesClassTypeParams(methodFunc, cls);
        final isTemplateMethod = methodFunc.typeParameters.isNotEmpty;
        final isOverridden = _isOverriddenMethod(entry, cls);
        final isOverridingObjectMethod = _isOverridingObjectMethod(entry, cls);

        // If the class has type parameters, we need to specify template arguments when taking the address
        // This applies to:
        // 1. Methods that use class type parameters
        // 2. Template methods (methods with their own type parameters)
        // 3. Overridden methods in generic classes (to avoid ambiguity)
        // 4. Methods that override Object methods (toString, hashCode, ==) in generic classes
        if ((classTypeArgsStr.isNotEmpty || isTemplateMethod) &&
            (usesClassTypeParams || isTemplateMethod || isOverridden || isOverridingObjectMethod)) {
          // Need to specify template arguments when taking address
          // For template methods, also include method type params as dynamic
          final allArgs = <String>[...classTypeParamNames];
          if (isTemplateMethod) {
            for (final tp in methodFunc.typeParameters) {
              allArgs.add('dynamic');
            }
          }
          if (allArgs.isNotEmpty) {
            final allTypeArgs = '<${allArgs.join(', ')}>';
            dartCode = '${entry.staticFuncName}$allTypeArgs';
            cppCode = '${entry.staticFuncName}$allTypeArgs';
          }
        }
      }

      final tearOff = IrRawCode(
        dartCode: dartCode,
        cppCode: cppCode,
      );
      registrations.add(IrVptrRegistration(key, tearOff));

      // 方法级泛型特化：为每个具体类型组合生成额外的 vptr 条目
      if (entry.proc != null && entry.proc!.function.typeParameters.isNotEmpty) {
        final methodName = entry.name;
        final specEntries = <MethodSpecEntry>{};

        // 沿继承链查找特化条目（可能记录在父类名下）
        String? lookupName = className;
        while (lookupName != null && lookupName.isNotEmpty) {
          final classSpecs = ir.ctx.methodTypeSpecializations[lookupName];
          if (classSpecs != null && classSpecs[methodName] != null) {
            specEntries.addAll(classSpecs[methodName]!);
          }
          lookupName = ir.ctx.classHierarchy[lookupName];
        }

        for (final specEntry in specEntries) {
          final specKey = '${key}_${specEntry.vptrSuffix}';
          final callTypeArgsList = <String>[
            ...classTypeParamNames,
            ...specEntry.typeArgStrs,
          ];
          final specTypeArgs = '<${callTypeArgsList.join(', ')}>';
          final specTearOff = IrRawCode(
            dartCode: '${entry.staticFuncName}$specTypeArgs',
            cppCode: '${entry.staticFuncName}$specTypeArgs',
          );
          registrations.add(IrVptrRegistration(specKey, specTearOff));
        }
      }
    }

    return registrations;
  }

  /// Check if a method's signature uses any of the class's type parameters.
  bool _methodUsesClassTypeParams(FunctionNode methodFunc, Class cls) {
    final classTypeParamNames = cls.typeParameters
        .map((tp) => tp.name)
        .where((name) => name != null)
        .cast<String>()
        .toSet();

    // Check if the method itself has type parameters (template method)
    if (methodFunc.typeParameters.isNotEmpty) {
      return true;
    }

    // Check return type
    if (_typeReferencesTypeParams(methodFunc.returnType, classTypeParamNames)) {
      return true;
    }

    // Check parameter types
    for (final param in methodFunc.positionalParameters) {
      if (_typeReferencesTypeParams(param.type, classTypeParamNames)) {
        return true;
      }
    }
    for (final param in methodFunc.namedParameters) {
      if (_typeReferencesTypeParams(param.type, classTypeParamNames)) {
        return true;
      }
    }

    // Check method body for references to class type parameters
    if (methodFunc.body != null) {
      if (_bodyReferencesTypeParams(methodFunc.body!, classTypeParamNames)) {
        return true;
      }
    }

    return false;
  }

  /// Check if a method body references any of the given type parameter names.
  bool _bodyReferencesTypeParams(TreeNode node, Set<String> typeParamNames) {
    if (node is VariableDeclaration) {
      if (_typeReferencesTypeParams(node.type, typeParamNames)) {
        return true;
      }
      if (node.initializer != null) {
        return _bodyReferencesTypeParams(node.initializer!, typeParamNames);
      }
    }
    if (node is VariableGet) {
      return _typeReferencesTypeParams(node.variable.type, typeParamNames);
    }
    if (node is VariableSet) {
      return _typeReferencesTypeParams(node.variable.type, typeParamNames) ||
          _bodyReferencesTypeParams(node.value, typeParamNames);
    }
    if (node is FunctionExpression) {
      return _bodyReferencesTypeParams(node.function, typeParamNames);
    }
    if (node is FunctionNode) {
      for (final param in node.positionalParameters) {
        if (_typeReferencesTypeParams(param.type, typeParamNames)) {
          return true;
        }
      }
      for (final param in node.namedParameters) {
        if (_typeReferencesTypeParams(param.type, typeParamNames)) {
          return true;
        }
      }
      if (_typeReferencesTypeParams(node.returnType, typeParamNames)) {
        return true;
      }
      if (node.body != null) {
        return _bodyReferencesTypeParams(node.body!, typeParamNames);
      }
    }
    if (node is Block) {
      for (final stmt in node.statements) {
        if (_bodyReferencesTypeParams(stmt, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is ExpressionStatement) {
      return _bodyReferencesTypeParams(node.expression, typeParamNames);
    }
    if (node is ReturnStatement) {
      if (node.expression != null) {
        return _bodyReferencesTypeParams(node.expression!, typeParamNames);
      }
    }
    if (node is IfStatement) {
      if (_bodyReferencesTypeParams(node.condition, typeParamNames)) {
        return true;
      }
      if (_bodyReferencesTypeParams(node.then, typeParamNames)) {
        return true;
      }
      if (node.otherwise != null) {
        if (_bodyReferencesTypeParams(node.otherwise!, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is ConditionalExpression) {
      if (_bodyReferencesTypeParams(node.condition, typeParamNames)) {
        return true;
      }
      if (_bodyReferencesTypeParams(node.then, typeParamNames)) {
        return true;
      }
      if (_bodyReferencesTypeParams(node.otherwise, typeParamNames)) {
        return true;
      }
    }
    if (node is StringConcatenation) {
      for (final expr in node.expressions) {
        if (_bodyReferencesTypeParams(expr, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is InstanceInvocation) {
      if (_bodyReferencesTypeParams(node.receiver, typeParamNames)) {
        return true;
      }
      for (final arg in node.arguments.positional) {
        if (_bodyReferencesTypeParams(arg, typeParamNames)) {
          return true;
        }
      }
      for (final arg in node.arguments.named) {
        if (_bodyReferencesTypeParams(arg.value, typeParamNames)) {
          return true;
        }
      }
      // Check type arguments
      for (final typeArg in node.arguments.types) {
        if (_typeReferencesTypeParams(typeArg, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is InstanceGet) {
      return _bodyReferencesTypeParams(node.receiver, typeParamNames);
    }
    if (node is InstanceSet) {
      return _bodyReferencesTypeParams(node.receiver, typeParamNames) ||
          _bodyReferencesTypeParams(node.value, typeParamNames);
    }
    if (node is StaticInvocation) {
      for (final arg in node.arguments.positional) {
        if (_bodyReferencesTypeParams(arg, typeParamNames)) {
          return true;
        }
      }
      for (final arg in node.arguments.named) {
        if (_bodyReferencesTypeParams(arg.value, typeParamNames)) {
          return true;
        }
      }
      // Check type arguments
      for (final typeArg in node.arguments.types) {
        if (_typeReferencesTypeParams(typeArg, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is ConstructorInvocation) {
      for (final arg in node.arguments.positional) {
        if (_bodyReferencesTypeParams(arg, typeParamNames)) {
          return true;
        }
      }
      for (final arg in node.arguments.named) {
        if (_bodyReferencesTypeParams(arg.value, typeParamNames)) {
          return true;
        }
      }
      // Check type arguments
      for (final typeArg in node.arguments.types) {
        if (_typeReferencesTypeParams(typeArg, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is IsExpression) {
      return _bodyReferencesTypeParams(node.operand, typeParamNames) ||
          _typeReferencesTypeParams(node.type, typeParamNames);
    }
    if (node is AsExpression) {
      return _bodyReferencesTypeParams(node.operand, typeParamNames) ||
          _typeReferencesTypeParams(node.type, typeParamNames);
    }
    if (node is Not) {
      return _bodyReferencesTypeParams(node.operand, typeParamNames);
    }
    if (node is LogicalExpression) {
      return _bodyReferencesTypeParams(node.left, typeParamNames) ||
          _bodyReferencesTypeParams(node.right, typeParamNames);
    }
    if (node is ListLiteral) {
      for (final expr in node.expressions) {
        if (_bodyReferencesTypeParams(expr, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is MapLiteral) {
      for (final entry in node.entries) {
        if (_bodyReferencesTypeParams(entry.key, typeParamNames) ||
            _bodyReferencesTypeParams(entry.value, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is SetLiteral) {
      for (final expr in node.expressions) {
        if (_bodyReferencesTypeParams(expr, typeParamNames)) {
          return true;
        }
      }
    }
    if (node is Throw) {
      return _bodyReferencesTypeParams(node.expression, typeParamNames);
    }
    if (node is AwaitExpression) {
      return _bodyReferencesTypeParams(node.operand, typeParamNames);
    }
    if (node is Let) {
      if (node.variable.initializer != null) {
        if (_bodyReferencesTypeParams(node.variable.initializer!, typeParamNames)) {
          return true;
        }
      }
      return _bodyReferencesTypeParams(node.body, typeParamNames);
    }
    if (node is TypeLiteral) {
      return _typeReferencesTypeParams(node.type, typeParamNames);
    }
    return false;
  }

  /// Check if a DartType references any of the given type parameter names.
  bool _typeReferencesTypeParams(DartType type, Set<String> typeParamNames) {
    if (type is TypeParameterType) {
      return typeParamNames.contains(type.parameter.name);
    }
    if (type is InterfaceType) {
      for (final typeArg in type.typeArguments) {
        if (_typeReferencesTypeParams(typeArg, typeParamNames)) {
          return true;
        }
      }
    }
    if (type is FunctionType) {
      if (_typeReferencesTypeParams(type.returnType, typeParamNames)) {
        return true;
      }
      for (final param in type.positionalParameters) {
        if (_typeReferencesTypeParams(param, typeParamNames)) {
          return true;
        }
      }
      for (final param in type.namedParameters) {
        if (_typeReferencesTypeParams(param.type, typeParamNames)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Check if a method is overridden in the current class.
  bool _isOverriddenMethod(VTableEntry entry, Class cls) {
    // If the method is declared in this class, it's not overridden
    if (entry.declaringClassName == cls.name) {
      return false;
    }
    // If the method is declared in a parent class, check if it's overridden
    return true;
  }

  /// Check if a method is overriding an Object method (toString, hashCode, ==).
  bool _isOverridingObjectMethod(VTableEntry entry, Class cls) {
    // Check if this is a well-known Object method
    final objectMethods = {'toString', 'hashCode', '==', 'noSuchMethod', 'runtimeType'};
    if (!objectMethods.contains(entry.name)) {
      return false;
    }

    // Check if the method is declared in this class (not inherited)
    if (entry.declaringClassName != cls.name) {
      return false;
    }

    // Check if the class has type parameters
    if (cls.typeParameters.isEmpty) {
      return false;
    }

    // This is an override of an Object method in a generic class
    return true;
  }

  IrConstructorFunc _buildConstructorFunc(
      Class cls, Constructor ctor, String className, String? parentName) {
    final ctorName = ctor.name.text;
    final funcName = ctorName.isEmpty
        ? '${className}_new'
        : '${className}_new_$ctorName';

    // 参数
    final func = ctor.function;
    final params = <IrFuncParam>[];
    for (var i = 0; i < func.requiredParameterCount; i++) {
      final p = func.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
      ));
    }
    for (var i = func.requiredParameterCount;
        i < func.positionalParameters.length;
        i++) {
      final p = func.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isOptional: true,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }
    for (final p in func.namedParameters) {
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isNamed: true,
        isRequired: p.isRequired,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }

    // 类型参数
    final typeParams =
        ir.typeTransformer.transformTypeParameters(cls.typeParameters);

    // 字段初始化
    final fieldInits = <String, IrExpression>{};
    final bodyStmts = <IrStatement>[];

    // 父类构造调用名
    String? parentNewFuncName;
    if (parentName != null && ir.ctx.isUserClass(parentName)) {
      parentNewFuncName = '${parentName}_new';
    }

    // 初始化列表
    final superArgs = <IrExpression>[];
    final superNamedArgs = <String, IrExpression>{};
    String? redirectTargetName;
    List<IrExpression>? redirectArgs;
    Map<String, IrExpression>? redirectNamedArgs;

    for (final init in ctor.initializers) {
      if (init is FieldInitializer) {
        fieldInits[init.field.name.text] =
            ir.expressionTransformer.transform(init.value);
      } else if (init is SuperInitializer) {
        // 处理 super 初始化列表，收集传递给父类构造函数的参数
        for (final arg in init.arguments.positional) {
          superArgs.add(ir.expressionTransformer.transform(arg));
        }
        // 收集命名参数
        for (final named in init.arguments.named) {
          superNamedArgs[named.name] = ir.expressionTransformer.transform(named.value);
        }
      } else if (init is RedirectingInitializer) {
        // 处理重定向构造函数：this(...) 调用
        final targetCtor = init.target;
        final targetCtorName = targetCtor.name.text;
        redirectTargetName = targetCtorName.isEmpty
            ? '${className}_new'
            : '${className}_new_$targetCtorName';

        // 收集位置参数
        redirectArgs = <IrExpression>[];
        for (final arg in init.arguments.positional) {
          redirectArgs!.add(ir.expressionTransformer.transform(arg));
        }

        // 收集命名参数
        if (init.arguments.named.isNotEmpty) {
          redirectNamedArgs = <String, IrExpression>{};
          for (final named in init.arguments.named) {
            redirectNamedArgs![named.name] = ir.expressionTransformer.transform(named.value);
          }
        }
      }
    }

    // 构造函数体
    if (ctor.function.body != null) {
      // 设置 this 替换名 — 构造函数体内 this → this_
      final savedThisReplacement = ir.thisReplacementName;
      ir.thisReplacementName = 'this_';
      ir.insideMethodBody = true;

      final body = ir.statementTransformer.transform(ctor.function.body!);
      if (body is IrBlockStmt) {
        bodyStmts.addAll(body.statements);
      } else {
        bodyStmts.add(body);
      }

      ir.thisReplacementName = savedThisReplacement;
      ir.insideMethodBody = false;
    }

    return IrConstructorFunc(
      name: funcName,
      className: className,
      parentClassName: parentName,
      parentNewFuncName: parentNewFuncName,
      params: params,
      typeParams: typeParams,
      bodyStatements: bodyStmts,
      fieldInitializers: fieldInits,
      superArgs: superArgs.isEmpty ? null : superArgs,
      superNamedArgs: superNamedArgs.isEmpty ? null : superNamedArgs,
      redirectTargetName: redirectTargetName,
      redirectArgs: redirectArgs,
      redirectNamedArgs: redirectNamedArgs,
    );
  }

  IrStaticFunc _buildInstanceMethodAsStatic(
      Class cls, Procedure proc, String className) {
    final name = proc.name.text;
    final kind = _inferKind(proc, name);
    final suffix = OperatorNames.staticFuncSuffix(name, kind);
    final funcName = '${className}_$suffix';

    final isGetter = proc.isGetter;
    final isSetter = proc.isSetter;

    // 抽象方法
    if (proc.isAbstract) {
      final typeParams = <IrTypeParameterType>[
        ...ir.typeTransformer.transformTypeParameters(cls.typeParameters),
        ...ir.typeTransformer.transformTypeParameters(proc.function.typeParameters),
      ];
      return IrStaticFunc(
        name: funcName,
        params: [const IrFuncParam('this__', IrDynamicType())],
        returnType: ir.typeTransformer.transform(proc.function.returnType),
        body: const IrBlockStmt([]),
        typeParams: typeParams,
        isAbstract: true,
        isGetter: isGetter,
        isSetter: isSetter,
        sourceClassName: className,
      );
    }

    // 参数
    final params = <IrFuncParam>[
      const IrFuncParam('this__', IrDynamicType()),
    ];
    for (var i = 0; i < proc.function.requiredParameterCount; i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
      ));
    }
    for (var i = proc.function.requiredParameterCount;
        i < proc.function.positionalParameters.length;
        i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isOptional: true,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }
    for (final p in proc.function.namedParameters) {
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isNamed: true,
        isRequired: p.isRequired,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }

    final returnType = ir.typeTransformer.transform(proc.function.returnType);
    // Combine class type params + method type params for instance methods
    final typeParams = <IrTypeParameterType>[
      ...ir.typeTransformer.transformTypeParameters(cls.typeParameters),
      ...ir.typeTransformer.transformTypeParameters(proc.function.typeParameters),
    ];

    // Box 预分析
    final savedBoxedVars = ir.boxedVars;
    final savedCurrentParams = ir.currentFunctionParams;
    ir.boxedVars = {...ir.boxedVars, ...BoxAnalyzer().analyze(proc.function)};
    ir.currentFunctionParams = proc.function.positionalParameters;

    // 设置 this 替换
    final savedThisReplacement = ir.thisReplacementName;
    final savedInsideMethod = ir.insideMethodBody;
    final savedAsync = ir.insideAsyncFunction;
    final savedAsyncReturnType = ir.asyncInnerReturnType;
    final savedMethodName = ir.currentMethodName;
    final savedMethodClassName = ir.currentMethodClassName;
    final savedMethodTypeParams = ir.currentMethodTypeParams;

    ir.thisReplacementName = 'this_';
    ir.insideMethodBody = true;
    // 设置当前方法信息（用于检测方法级递归调用）
    ir.currentMethodName = name;
    ir.currentMethodClassName = className;
    ir.currentMethodTypeParams = proc.function.typeParameters;

    // async 检测
    final isAsync = proc.function.asyncMarker == AsyncMarker.Async;
    // sync* 检测
    final isSyncStar = proc.function.asyncMarker == AsyncMarker.SyncStar;
    IrType? asyncInnerType;
    if (isAsync) {
      ir.insideAsyncFunction = true;
      final retType = proc.function.returnType;
      if (retType is InterfaceType && retType.typeArguments.isNotEmpty) {
        asyncInnerType = ir.typeTransformer.transform(retType.typeArguments.first);
      } else {
        asyncInnerType = const IrDynamicType();
      }
      ir.asyncInnerReturnType = asyncInnerType;
    }

    // 设置当前函数返回类型（用于 void 返回值的 return 抑制）
    final savedReturnType = ir.currentFunctionReturnType;
    ir.currentFunctionReturnType = returnType;

    // 转换函数体
    IrStatement body;
    if (isGetter) {
      // 对于 getter，检查是否有对应的字段
      // 如果有，生成访问字段的函数体（覆盖任何现有的函数体）
      final field = cls.fields.cast<Field?>().firstWhere(
        (f) => f != null && f.name.text == name && !f.isStatic,
        orElse: () => null,
      );
      if (field != null) {
        // 生成 return this_.fieldName;
        final thisExpr = IrThisExpr(replacementName: ir.thisReplacementName);
        final fieldGet = IrFieldGet(thisExpr, name, type: returnType);
        body = IrReturnStmt(value: fieldGet, returnType: returnType);
      } else if (proc.function.body != null) {
        body = ir.statementTransformer.transform(proc.function.body!);
      } else {
        body = const IrBlockStmt([]);
      }
    } else if (isSetter) {
      // 对于 setter，检查是否有对应的字段
      // 如果有，生成设置字段的函数体
      final fieldName = name.startsWith('_') ? name : name;
      final field = cls.fields.cast<Field?>().firstWhere(
        (f) => f != null && f.name.text == fieldName && !f.isStatic,
        orElse: () => null,
      );
      if (field != null && params.length > 1) {
        // 生成 this_.fieldName = value;
        final thisExpr = IrThisExpr(replacementName: ir.thisReplacementName);
        final valueParam = params.last;
        final valueExpr = IrVariableGet(valueParam.name, type: valueParam.type);
        final fieldSet = IrFieldSet(thisExpr, fieldName, valueExpr);
        body = IrExprStmt(fieldSet);
      } else if (proc.function.body != null) {
        body = ir.statementTransformer.transform(proc.function.body!);
      } else {
        body = const IrBlockStmt([]);
      }
    } else if (proc.function.body != null) {
      body = ir.statementTransformer.transform(proc.function.body!);
    } else {
      body = const IrBlockStmt([]);
    }

    // 恢复状态
    ir.boxedVars = savedBoxedVars;
    ir.currentFunctionParams = savedCurrentParams;
    ir.thisReplacementName = savedThisReplacement;
    ir.insideMethodBody = savedInsideMethod;
    ir.insideAsyncFunction = savedAsync;
    ir.asyncInnerReturnType = savedAsyncReturnType;
    ir.currentFunctionReturnType = savedReturnType;
    ir.currentMethodName = savedMethodName;
    ir.currentMethodClassName = savedMethodClassName;
    ir.currentMethodTypeParams = savedMethodTypeParams;

    return IrStaticFunc(
      name: funcName,
      params: params,
      returnType: returnType,
      body: body,
      typeParams: typeParams,
      isGetter: isGetter,
      isSetter: isSetter,
      isAsync: isAsync,
      asyncInnerType: asyncInnerType,
      isSyncStar: isSyncStar,
      sourceClassName: className,
    );
  }

  /// Build a static method as a top-level function: ClassName_methodName(args)
  IrStaticFunc _buildStaticMethod(Class cls, Procedure proc, String className) {
    final name = proc.name.text;
    final kind = _inferKind(proc, name);
    final suffix = OperatorNames.staticFuncSuffix(name, kind);
    final funcName = '${className}_$suffix';

    final params = <IrFuncParam>[];
    for (var i = 0; i < proc.function.requiredParameterCount; i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
      ));
    }
    for (var i = proc.function.requiredParameterCount;
        i < proc.function.positionalParameters.length;
        i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isOptional: true,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }
    for (final p in proc.function.namedParameters) {
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isNamed: true,
        isRequired: p.isRequired,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }

    final returnType = ir.typeTransformer.transform(proc.function.returnType);
    final typeParams = ir.typeTransformer.transformTypeParameters(proc.function.typeParameters);

    // async detection
    final isAsync = proc.function.asyncMarker == AsyncMarker.Async;
    // sync* detection
    final isSyncStar = proc.function.asyncMarker == AsyncMarker.SyncStar;
    IrType? asyncInnerType;
    final savedAsync = ir.insideAsyncFunction;
    final savedAsyncReturnType = ir.asyncInnerReturnType;
    if (isAsync) {
      ir.insideAsyncFunction = true;
      final retType = proc.function.returnType;
      if (retType is InterfaceType && retType.typeArguments.isNotEmpty) {
        asyncInnerType = ir.typeTransformer.transform(retType.typeArguments.first);
      } else {
        asyncInnerType = const IrDynamicType();
      }
      ir.asyncInnerReturnType = asyncInnerType;
    }

    final savedReturnType = ir.currentFunctionReturnType;
    ir.currentFunctionReturnType = returnType;

    final body = proc.function.body != null
        ? ir.statementTransformer.transform(proc.function.body!)
        : const IrBlockStmt([]);

    ir.currentFunctionReturnType = savedReturnType;
    ir.insideAsyncFunction = savedAsync;
    ir.asyncInnerReturnType = savedAsyncReturnType;

    return IrStaticFunc(
      name: funcName,
      params: params,
      returnType: returnType,
      body: body,
      typeParams: typeParams,
      isAsync: isAsync,
      isSyncStar: isSyncStar,
      asyncInnerType: asyncInnerType,
    );
  }

  /// Build a factory constructor as a top-level function.
  /// Factory constructors are like static methods — they don't take this__.
  IrStaticFunc _buildFactoryConstructor(
      Class cls, Procedure proc, String className, String? parentName) {
    final ctorName = proc.name.text;
    final funcName = ctorName.isEmpty
        ? '${className}_new'
        : '${className}_new_$ctorName';

    final params = <IrFuncParam>[];
    for (var i = 0; i < proc.function.requiredParameterCount; i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
      ));
    }
    for (var i = proc.function.requiredParameterCount;
        i < proc.function.positionalParameters.length;
        i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isOptional: true,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }
    for (final p in proc.function.namedParameters) {
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isNamed: true,
        isRequired: p.isRequired,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }

    final returnType = ir.typeTransformer.transform(proc.function.returnType);
    final typeParams = ir.typeTransformer.transformTypeParameters(proc.function.typeParameters);

    final savedReturnType = ir.currentFunctionReturnType;
    ir.currentFunctionReturnType = returnType;

    final body = proc.function.body != null
        ? ir.statementTransformer.transform(proc.function.body!)
        : const IrBlockStmt([]);

    ir.currentFunctionReturnType = savedReturnType;

    return IrStaticFunc(
      name: funcName,
      params: params,
      returnType: returnType,
      body: body,
      typeParams: typeParams,
    );
  }

  IrDelegateFunc _buildDelegateFunc(
      Class cls, VTableEntry entry, String className) {
    final kind = entry.kind;
    final suffix = OperatorNames.staticFuncSuffix(entry.name, kind);
    final funcName = '${className}_$suffix';

    // 参数：从 entry.proc 获取
    final params = <IrFuncParam>[
      const IrFuncParam('this__', IrDynamicType()),
    ];
    IrType returnType = const IrDynamicType();
    final typeParams = <IrTypeParameterType>[
      ...ir.typeTransformer.transformTypeParameters(cls.typeParameters),
    ];

    // 构建类型替换映射（用于继承链上的类型参数替换）
    final parentClass = entry.proc?.enclosingClass;
    final substitution = parentClass != null
        ? _buildDelegateTypeSubstitution(cls, parentClass)
        : <TypeParameter, IrType>{};

    // 保存并设置精确替换上下文
    final savedDirectSub = Map<TypeParameter, IrType>.from(
        ir.typeTransformer.directTypeSubstitution);
    ir.typeTransformer.directTypeSubstitution = substitution;

    // 构建传递给目标函数的类型参数
    final targetTypeArgs = <String>[];
    if (parentClass != null && parentClass.typeParameters.isNotEmpty) {
      for (final param in parentClass.typeParameters) {
        final mapped = substitution[param];
        if (mapped != null) {
          targetTypeArgs.add(_irTypeToString(mapped));
        } else {
          // 如果没有映射，使用类型参数名本身
          targetTypeArgs.add(param.name ?? 'T');
        }
      }
    }

    // DEBUG: 输出调试信息
    print('DEBUG _buildDelegateFunc: $funcName');
    print('  parentClass: ${parentClass?.name}');
    print('  parentClass.typeParameters: ${parentClass?.typeParameters.map((tp) => tp.name).toList()}');
    print('  substitution: ${substitution.entries.map((e) => '${e.key.name} -> ${_irTypeToString(e.value)}').toList()}');
    print('  targetTypeArgs: $targetTypeArgs');

    if (entry.proc != null) {
      // Add method type params
      final methodTypeParams = ir.typeTransformer.transformTypeParameters(
          entry.proc!.function.typeParameters);
      typeParams.addAll(methodTypeParams);

      // 将方法的类型参数也添加到 targetTypeArgs
      for (final tp in methodTypeParams) {
        targetTypeArgs.add(tp.name);
      }

      for (var i = 0; i < entry.proc!.function.requiredParameterCount; i++) {
        final p = entry.proc!.function.positionalParameters[i];
        params.add(IrFuncParam(
          _cleanVarName(p.name),
          ir.typeTransformer.transform(p.type),
        ));
      }
      for (var i = entry.proc!.function.requiredParameterCount;
          i < entry.proc!.function.positionalParameters.length;
          i++) {
        final p = entry.proc!.function.positionalParameters[i];
        params.add(IrFuncParam(
          _cleanVarName(p.name),
          ir.typeTransformer.transform(p.type),
          isOptional: true,
        ));
      }
      returnType = ir.typeTransformer.transform(entry.proc!.function.returnType);
    }

    // 恢复替换上下文
    ir.typeTransformer.directTypeSubstitution = savedDirectSub;

    return IrDelegateFunc(
      name: funcName,
      targetFuncName: entry.staticFuncName,
      params: params,
      returnType: returnType,
      typeParams: typeParams,
      targetTypeArgs: targetTypeArgs,
      isGetter: kind == VTableEntryKind.getter,
      isSetter: kind == VTableEntryKind.setter,
    );
  }

  IrTopLevelField _buildStaticField(Field field, String className) {
    final name = '${className}_${field.name.text}';
    final type = ir.typeTransformer.transform(field.type);
    IrExpression? init;

    final savedIsStatic = ir.isStaticFieldContext;
    ir.isStaticFieldContext = true;

    if (field.initializer != null) {
      init = ir.expressionTransformer.transform(field.initializer!);
    }

    ir.isStaticFieldContext = savedIsStatic;

    return IrTopLevelField(name, type,
        init: init, isStatic: true, className: className);
  }

  // -----------------------------------------------------------------------
  // Mixin
  // -----------------------------------------------------------------------

  IrMixinFuncs transformMixin(Class cls) {
    final mixinName = cls.name;

    // 设置上下文
    final savedClass = ir.currentClass;
    final savedClassName = ir.currentClassName;
    ir.currentClass = cls;
    ir.currentClassName = mixinName;

    final funcs = <IrStaticFunc>[];
    for (final proc in cls.procedures) {
      if (proc.isStatic || proc.isFactory || proc.isAbstract) continue;
      if (proc.function.body == null) continue;
      funcs.add(_buildMixinMethodAsStatic(cls, proc, mixinName));
    }

    // 静态字段
    final staticFields = <IrTopLevelField>[];
    for (final field in cls.fields) {
      if (field.isStatic) {
        staticFields.add(_buildStaticField(field, mixinName));
      }
    }

    // 实例字段（包括私有字段，如 _auditLog）
    final instanceFields = <IrFieldDef>[];
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      if (field.name.text.startsWith('_') && field.name.text.endsWith('#')) continue;
      final name = field.name.text;
      final type = ir.typeTransformer.transform(field.type);
      IrExpression? defaultValue;
      if (field.initializer != null) {
        defaultValue = ir.expressionTransformer.transform(field.initializer!);
      }
      instanceFields.add(IrFieldDef(name, type, defaultValue: defaultValue));
    }

    ir.currentClass = savedClass;
    ir.currentClassName = savedClassName;
    final mixinFuncs = IrMixinFuncs(mixinName, funcs: funcs, staticFields: staticFields, instanceFields: instanceFields);
    _processedMixins.add(mixinFuncs);
    return mixinFuncs;
  }

  IrStaticFunc _buildMixinMethodAsStatic(
      Class cls, Procedure proc, String mixinName) {
    final name = proc.name.text;
    final kind = _inferKind(proc, name);
    final suffix = OperatorNames.staticFuncSuffix(name, kind);
    final funcName = '${mixinName}_$suffix';

    final isGetter = proc.isGetter;
    final isSetter = proc.isSetter;

    // Abstract method - still needs type params
    if (proc.isAbstract) {
      final typeParams = <IrTypeParameterType>[
        ...ir.typeTransformer.transformTypeParameters(cls.typeParameters),
        ...ir.typeTransformer.transformTypeParameters(proc.function.typeParameters),
      ];
      return IrStaticFunc(
        name: funcName,
        params: [const IrFuncParam('this__', IrDynamicType())],
        returnType: ir.typeTransformer.transform(proc.function.returnType),
        body: const IrBlockStmt([]),
        typeParams: typeParams,
        isAbstract: true,
        isGetter: isGetter,
        isSetter: isSetter,
        sourceClassName: mixinName,
      );
    }

    final params = <IrFuncParam>[
      const IrFuncParam('this__', IrDynamicType()),
    ];
    for (var i = 0; i < proc.function.requiredParameterCount; i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
      ));
    }
    for (var i = proc.function.requiredParameterCount;
        i < proc.function.positionalParameters.length;
        i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isOptional: true,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }

    final returnType = ir.typeTransformer.transform(proc.function.returnType);
    // Combine mixin type params + method type params
    final typeParams = <IrTypeParameterType>[
      ...ir.typeTransformer.transformTypeParameters(cls.typeParameters),
      ...ir.typeTransformer.transformTypeParameters(proc.function.typeParameters),
    ];

    // 设置 this 替换
    final savedThisReplacement = ir.thisReplacementName;
    final savedInsideMethod = ir.insideMethodBody;
    final savedReturnType = ir.currentFunctionReturnType;
    ir.thisReplacementName = 'this_';
    ir.insideMethodBody = true;
    ir.currentFunctionReturnType = returnType;

    final body = proc.function.body != null
        ? ir.statementTransformer.transform(proc.function.body!)
        : const IrBlockStmt([]);

    ir.thisReplacementName = savedThisReplacement;
    ir.insideMethodBody = savedInsideMethod;
    ir.currentFunctionReturnType = savedReturnType;

    return IrStaticFunc(
      name: funcName,
      params: params,
      returnType: returnType,
      body: body,
      typeParams: typeParams,
      isGetter: proc.isGetter,
      isSetter: proc.isSetter,
      sourceClassName: mixinName,
    );
  }

  // -----------------------------------------------------------------------
  // Enum
  // -----------------------------------------------------------------------

  IrEnumDecl transformEnum(Class cls) {
    final enumName = cls.name;

    // 枚举值 — 提取字段值
    final values = <IrEnumValue>[];
    for (final field in cls.fields) {
      if (field.isStatic &&
          field.isConst &&
          field.type is InterfaceType &&
          (field.type as InterfaceType).classNode == cls &&
          field.name.text != 'values') {
        // 提取枚举常量的字段值
        final args = <IrExpression>[];
        if (field.initializer is ConstantExpression) {
          final constExpr = field.initializer as ConstantExpression;
          if (constExpr.constant is InstanceConstant) {
            final instanceConst = constExpr.constant as InstanceConstant;
            // 按照用户字段顺序提取值
            for (final userField in cls.fields) {
              if (userField.isStatic) continue;
              if (userField.name.text == 'index' || userField.name.text == '_name') continue;
              // 在 fieldValues 中找到对应的值
              for (final entry in instanceConst.fieldValues.entries) {
                if (entry.key.asField.name.text == userField.name.text) {
                  args.add(ir.constantTransformer.transform(entry.value));
                  break;
                }
              }
            }
          }
        }
        values.add(IrEnumValue(field.name.text, args));
      }
    }

    // 用户自定义字段
    final userFields = <IrEnumFieldDef>[];
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      if (field.name.text == 'index' || field.name.text == '_name') continue;
      userFields.add(IrEnumFieldDef(
        field.name.text,
        ir.typeTransformer.transform(field.type),
      ));
    }

    // 方法
    final methods = <IrStaticFunc>[];
    for (final proc in cls.procedures) {
      if (proc.isStatic || proc.isFactory) continue;
      // Skip internal enum methods (start with _)
      if (proc.name.text.startsWith('_')) continue;
      methods.add(_buildInstanceMethodAsStatic(cls, proc, enumName));
    }

    // 类型参数
    final typeParams =
        ir.typeTransformer.transformTypeParameters(cls.typeParameters);

    return IrEnumDecl(
      name: enumName,
      typeParams: typeParams,
      values: values,
      userFields: userFields,
      methods: methods,
    );
  }

  // -----------------------------------------------------------------------
  // Typedef
  // -----------------------------------------------------------------------

  IrTypedef transformTypedef(Typedef td) {
    final type = ir.typeTransformer.transform(td.type!);
    final typeParams =
        ir.typeTransformer.transformTypeParameters(td.typeParameters);
    return IrTypedef(td.name, type, typeParams: typeParams);
  }

  // -----------------------------------------------------------------------
  // 顶层函数 / 字段
  // -----------------------------------------------------------------------

  IrStaticFunc transformTopLevelProcedure(Procedure proc) {
    var name = proc.name.text;
    // Sanitize extension method names (e.g. "Ext|get#prop" → "Ext_get_prop")
    if (name.contains('|') || name.contains('#')) {
      name = OperatorNames.sanitizeExtensionMethodName(name);
    }

    final params = <IrFuncParam>[];
    for (var i = 0; i < proc.function.requiredParameterCount; i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
      ));
    }
    for (var i = proc.function.requiredParameterCount;
        i < proc.function.positionalParameters.length;
        i++) {
      final p = proc.function.positionalParameters[i];
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isOptional: true,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }
    for (final p in proc.function.namedParameters) {
      params.add(IrFuncParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        isNamed: true,
        isRequired: p.isRequired,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }

    final returnType = ir.typeTransformer.transform(proc.function.returnType);
    final typeParams =
        ir.typeTransformer.transformTypeParameters(proc.function.typeParameters);

    // Preserve original return type — C++ emitter will override for main()
    IrType finalReturnType = returnType;

    // async 检测
    final isAsync = proc.function.asyncMarker == AsyncMarker.Async;
    // sync* 检测
    final isSyncStar = proc.function.asyncMarker == AsyncMarker.SyncStar;
    IrType? asyncInnerType;
    final savedAsync = ir.insideAsyncFunction;
    final savedAsyncReturnType = ir.asyncInnerReturnType;
    if (isAsync) {
      ir.insideAsyncFunction = true;
      final retType = proc.function.returnType;
      if (retType is InterfaceType && retType.typeArguments.isNotEmpty) {
        asyncInnerType = ir.typeTransformer.transform(retType.typeArguments.first);
      } else {
        asyncInnerType = const IrDynamicType();
      }
      ir.asyncInnerReturnType = asyncInnerType;
    }

    // 设置当前函数的返回类型
    final savedReturnType = ir.currentFunctionReturnType;
    ir.currentFunctionReturnType = finalReturnType;

    final body = proc.function.body != null
        ? ir.statementTransformer.transform(proc.function.body!)
        : const IrBlockStmt([]);

    // 恢复之前的返回类型
    ir.currentFunctionReturnType = savedReturnType;
    ir.insideAsyncFunction = savedAsync;
    ir.asyncInnerReturnType = savedAsyncReturnType;

    return IrStaticFunc(
      name: name,
      params: params,
      returnType: finalReturnType,
      body: body,
      typeParams: typeParams,
      isAsync: isAsync,
      isSyncStar: isSyncStar,
      asyncInnerType: asyncInnerType,
    );
  }

  IrTopLevelField transformTopLevelField(Field field) {
    final name = field.name.text;
    final type = ir.typeTransformer.transform(field.type);

    final savedIsStatic = ir.isStaticFieldContext;
    ir.isStaticFieldContext = true;

    IrExpression? init;
    if (field.initializer != null) {
      init = ir.expressionTransformer.transform(field.initializer!);
    }

    ir.isStaticFieldContext = savedIsStatic;

    return IrTopLevelField(name, type, init: init, isFinal: field.isFinal);
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  void _setupTypeParamSubstitution(Class cls, String className, String? parentName) {
    ir.typeTransformer.clearTypeParamSubstitution();
    if (parentName == null) return;
    if (cls.supertype == null) return;

    final parentClass = ir.ctx.classNodes[parentName];
    if (parentClass == null) return;

    final parentTypeParams = parentClass.typeParameters;
    final concreteArgs = cls.supertype!.typeArguments;

    if (parentTypeParams.length != concreteArgs.length) return;

    final substitution = <String, String>{};
    for (var i = 0; i < parentTypeParams.length; i++) {
      final paramName = parentTypeParams[i].name ?? 'T';
      final concreteType = concreteArgs[i];
      if (concreteType is InterfaceType) {
        substitution[paramName] = concreteType.classNode.name;
      } else if (concreteType is VoidType) {
        substitution[paramName] = 'void';
      }
    }

    ir.typeTransformer.activeTypeParamSubstitution = substitution;
    ir.typeTransformer.activeTypeParamTargets = parentTypeParams.toSet();
  }

  VTableEntryKind _inferKind(Procedure proc, String name) {
    if (proc.isGetter) return VTableEntryKind.getter;
    if (proc.isSetter) return VTableEntryKind.setter;
    if (OperatorNames.isOperator(name)) return VTableEntryKind.operator_;
    return VTableEntryKind.method;
  }

  // -----------------------------------------------------------------------
  // 委托函数类型参数替换
  // -----------------------------------------------------------------------

  /// 构建委托函数的类型参数替换映射。
  ///
  /// 当子类继承泛型父类的方法时，需要将父类的类型参数映射到子类的具体类型。
  /// 例如：`ChainedTransformer<A, B, C> extends DataTransformer<A, C>`
  /// 需要构建映射：`{TInput → A, TOutput → C}`
  Map<TypeParameter, IrType> _buildDelegateTypeSubstitution(
      Class childClass, Class parentClass) {
    // 如果方法定义在当前类中，无需替换
    if (parentClass == childClass) return {};
    // 如果父类没有类型参数，无需替换
    if (parentClass.typeParameters.isEmpty) return {};

    // 检查当前类是否拥有所有父类的类型参数（同名）
    final childTypeParamNames =
        childClass.typeParameters.map((tp) => tp.name).toSet();
    final parentTypeParamNames =
        parentClass.typeParameters.map((tp) => tp.name).toSet();
    if (parentTypeParamNames.every((n) => childTypeParamNames.contains(n))) {
      return {};
    }

    // 解析继承链上的具体类型参数
    final concreteTypeArgs =
        _resolveConcreteTypeArgsForAncestor(childClass, parentClass);
    if (concreteTypeArgs == null || concreteTypeArgs.isEmpty) return {};

    // 构建精确替换映射
    final substitution = <TypeParameter, IrType>{};
    for (var i = 0;
        i < parentClass.typeParameters.length && i < concreteTypeArgs.length;
        i++) {
      substitution[parentClass.typeParameters[i]] = concreteTypeArgs[i];
    }
    return substitution;
  }

  /// 沿继承链向上查找目标祖先类，解析其具体类型参数。
  ///
  /// 例如：对于 `ChainedTransformer<A, B, C> extends DataTransformer<A, C>`，
  /// 调用 `_resolveConcreteTypeArgsForAncestor(ChainedTransformer, DataTransformer)`
  /// 返回 `[IrTypeParameterType('A'), IrTypeParameterType('C')]`。
  List<IrType>? _resolveConcreteTypeArgsForAncestor(
      Class currentClass, Class ancestorClass) {
    final superType = currentClass.supertype;
    if (superType == null) return null;

    // 直接命中：当前类的父类就是目标祖先
    if (superType.classNode == ancestorClass) {
      if (superType.typeArguments.isEmpty) return null;
      return superType.typeArguments
          .map((ta) => ir.typeTransformer.transform(ta))
          .toList();
    }

    // 递归向上查找
    final parentClass = superType.classNode;
    final result =
        _resolveConcreteTypeArgsForAncestor(parentClass, ancestorClass);
    if (result != null) {
      // 处理中间层的类型参数传递
      // 例如：A<T> extends B<T, String> extends C<List<T>, String>
      // 需要将 B 的类型参数映射到 A 传入的具体类型
      if (superType.typeArguments.isNotEmpty &&
          parentClass.typeParameters.isNotEmpty) {
        final intermediateSub = <TypeParameter, IrType>{};
        for (var i = 0;
            i < parentClass.typeParameters.length &&
                i < superType.typeArguments.length;
            i++) {
          intermediateSub[parentClass.typeParameters[i]] =
              ir.typeTransformer.transform(superType.typeArguments[i]);
        }

        // 将结果中的中间类型参数替换为最终类型
        final savedDirectSub = Map<TypeParameter, IrType>.from(
            ir.typeTransformer.directTypeSubstitution);
        ir.typeTransformer.directTypeSubstitution = intermediateSub;

        final finalResult = result.map((irType) {
          if (irType is IrTypeParameterType) {
            // 检查是否在当前类的类型参数中
            for (final param in parentClass.typeParameters) {
              if (param.name == irType.name &&
                  intermediateSub.containsKey(param)) {
                return intermediateSub[param]!;
              }
            }
          }
          return irType;
        }).toList();

        ir.typeTransformer.directTypeSubstitution = savedDirectSub;
        return finalResult;
      }
      return result;
    }

    return null;
  }

  /// 将 IrType 转换为字符串（用于构建目标函数的类型参数列表）。
  String _irTypeToString(IrType type) {
    if (type is IrTypeParameterType) return type.name;
    if (type is IrPrimitiveType) {
      return switch (type.kind) {
        PrimitiveKind.int_ => 'int',
        PrimitiveKind.double_ => 'double',
        PrimitiveKind.bool_ => 'bool',
        PrimitiveKind.string_ => 'String',
      };
    }
    if (type is IrVoidType) return 'void';
    if (type is IrDynamicType) return 'dynamic';
    if (type is IrUserType) {
      final args = type.typeArgs.isNotEmpty
          ? '<${type.typeArgs.map(_irTypeToString).join(', ')}>'
          : '';
      return '${type.className}$args';
    }
    if (type is IrNullableType) return '${_irTypeToString(type.inner)}?';
    if (type is IrCollectionType) {
      final kind = switch (type.kind) {
        CollectionKind.list => 'StaticList',
        CollectionKind.map => 'StaticMap',
        CollectionKind.set_ => 'StaticSet',
        CollectionKind.iterable => 'StaticList',
        CollectionKind.iterator => 'StaticList',
      };
      final args = type.typeArgs.isNotEmpty
          ? '<${type.typeArgs.map(_irTypeToString).join(', ')}>'
          : '';
      return '$kind$args';
    }
    if (type is IrPromiseType) {
      return 'Promise<${_irTypeToString(type.innerType)}>';
    }
    return 'dynamic';
  }

  String _sanitizeSyntheticName(String name) {
    var result = name;
    if (result.startsWith('_')) result = result.substring(1);
    return result.replaceAll('&', '_');
  }

  String _cleanVarName(String? name) {
    if (name == null || name.isEmpty) return '_unnamed';
    var result = name;
    if (result.startsWith(':#')) result = result.substring(2);
    if (result.startsWith('#')) result = result.substring(1);
    result = result.replaceAll('#', '_').replaceAll(':', '_');
    // Prefix digit-starting names with underscore (e.g., `0_0` → `_0_0`)
    if (result.isNotEmpty && result.codeUnitAt(0) >= 0x30 && result.codeUnitAt(0) <= 0x39) {
      result = '_$result';
    }
    // Avoid Dart keywords
    const keywords = {
      'this', 'super', 'null', 'true', 'false', 'abstract', 'as', 'assert',
      'async', 'await', 'break', 'case', 'catch', 'class', 'const', 'continue',
      'covariant', 'default', 'deferred', 'do', 'dynamic', 'else', 'enum',
      'export', 'extends', 'extension', 'external', 'factory', 'final',
      'finally', 'for', 'Function', 'get', 'hide', 'if', 'implements',
      'import', 'in', 'interface', 'is', 'late', 'library', 'mixin', 'new',
      'on', 'operator', 'part', 'required', 'rethrow', 'return', 'set', 'show',
      'static', 'switch', 'sync', 'throw', 'try', 'typedef', 'var', 'void',
      'while', 'with', 'yield',
    };
    if (keywords.contains(result)) return '${result}_';
    return result;
  }
}

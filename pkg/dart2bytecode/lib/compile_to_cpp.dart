import 'package:kernel/kernel.dart';

void printTranslator(Component component) {
  // 生成完整的Dart代码文件头部
  _printDartHeader();

  // 遍历组件中的所有库
  for (final library in component.libraries) {
    _printLibraryCode(library);
  }
}

void _printDartHeader() {
  print('// Generated Dart code from Component');
  print('// Auto-generated - do not modify');
  print('');
}

void _printLibraryCode(Library library) {
  // 打印库声明
  final libraryUri = library.importUri.toString();
  if (!libraryUri.startsWith('dart:') && !libraryUri.contains('package:')) {
    print('library ${_getLibraryName(library)};');
    print('');
  }

  // 打印导入语句
  _printImports(library);

  // 处理类列表，按语法节点类型组织
  final classGroups = _groupClassesByNodeType(library.classes);

  // 按照特定顺序生成类代码
  _generateClassesCode(classGroups);
}

void _printImports(Library library) {
  // 收集所有需要的导入
  final imports = <String>{};

  for (final dependency in library.dependencies) {
    final importedLibrary = dependency.targetLibrary;
    final uri = importedLibrary.importUri.toString();
    if (!uri.startsWith('dart:core')) {
      if (dependency.isExport) {
        imports.add('export \'$uri\';');
      } else {
        var prefix = dependency.name;
        if (prefix != null && prefix.isNotEmpty) {
          imports.add('import \'$uri\' as $prefix;');
        } else {
          imports.add('import \'$uri\';');
        }
      }
    }
  }

  for (final import in imports) {
    print(import);
  }
  if (imports.isNotEmpty) {
    print('');
  }
}

String _getLibraryName(Library library) {
  final uri = library.importUri.toString();
  return uri.replaceAll('/', '_').replaceAll('.', '_');
}

Map<String, List<Class>> _groupClassesByNodeType(List<Class> classes) {
  final groups = <String, List<Class>>{
    'abstract': [],
    'enum': [],
    'mixin': [],
    'concrete': [],
    'extension': [],
  };

  for (final cls in classes) {
    final nodeType = _identifyClassNodeType(cls);
    groups[nodeType]?.add(cls);
  }

  return groups;
}

String _identifyClassNodeType(Class cls) {
  // 优先识别语法节点类型
  if (cls.isEnum) {
    return 'enum';
  } else if (cls.isMixinClass) {
    return 'mixin';
  } else if (cls.isAbstract) {
    return 'abstract';
  } else {
    // 检查是否为扩展类型
    final hasExtensionMembers = cls.procedures
        .any((p) => p.kind == ProcedureKind.Method && p.isExtensionMember);
    if (hasExtensionMembers) {
      return 'extension';
    }
    return 'concrete';
  }
}

void _generateClassesCode(Map<String, List<Class>> classGroups) {
  // 按照语法重要性顺序生成代码
  final orderedGroups = ['enum', 'mixin', 'abstract', 'extension', 'concrete'];

  for (final groupName in orderedGroups) {
    final classes = classGroups[groupName] ?? [];
    if (classes.isNotEmpty) {
      print('// ===== ${groupName.toUpperCase()} CLASSES =====');
      print('');

      for (final cls in classes) {
        _generateClassCode(cls, groupName);
        print('');
      }
    }
  }
}

void _generateClassCode(Class cls, String nodeType) {
  final className = cls.name;
  final typeParams = _getTypeParameters(cls);
  final supertype = _getSupertype(cls);
  final interfaces = _getInterfaces(cls);
  final mixins = _getMixins(cls);

  // 生成类声明头部
  String classDeclaration;
  switch (nodeType) {
    case 'enum':
      classDeclaration = 'enum $className$typeParams';
      break;
    case 'mixin':
      classDeclaration = 'mixin $className$typeParams';
      if (supertype.isNotEmpty) {
        classDeclaration += ' on $supertype';
      }
      break;
    case 'abstract':
      classDeclaration = 'abstract class $className$typeParams';
      break;
    case 'extension':
      classDeclaration =
          'extension $className$typeParams on ${supertype.isNotEmpty ? supertype : 'Object'}';
      break;
    default:
      classDeclaration = 'class $className$typeParams';
  }

  // 添加继承和实现
  if (nodeType != 'extension' && nodeType != 'enum') {
    if (supertype.isNotEmpty && supertype != 'Object') {
      classDeclaration += ' extends $supertype';
    }
    if (mixins.isNotEmpty) {
      classDeclaration += ' with ${mixins.join(', ')}';
    }
    if (interfaces.isNotEmpty) {
      classDeclaration += ' implements ${interfaces.join(', ')}';
    }
  }

  print('$classDeclaration {');

  // 生成类成员
  _generateClassMembers(cls, nodeType);

  print('}');
}

String _getTypeParameters(Class cls) {
  if (cls.typeParameters.isEmpty) return '';
  final params = cls.typeParameters.map((tp) => tp.name).join(', ');
  return '<$params>';
}

String _getSupertype(Class cls) {
  if (cls.supertype == null) return '';
  return _getTypeString(cls.supertype!.asInterfaceType);
}

List<String> _getInterfaces(Class cls) {
  return cls.implementedTypes
      .map((type) => _getTypeString(type.asInterfaceType))
      .toList();
}

List<String> _getMixins(Class cls) {
  if (cls.mixedInType != null) {
    return [_getTypeString(cls.mixedInType!.asInterfaceType)];
  }
  return [];
}

void _generateClassMembers(Class cls, String nodeType) {
  // 按成员类型分组
  final fields = <Field>[];
  final constructors = <Constructor>[];
  final methods = <Procedure>[];
  final getters = <Procedure>[];
  final setters = <Procedure>[];

  // 分类成员
  for (final field in cls.fields) {
    fields.add(field);
  }

  for (final constructor in cls.constructors) {
    constructors.add(constructor);
  }

  for (final procedure in cls.procedures) {
    switch (procedure.kind) {
      case ProcedureKind.Method:
      case ProcedureKind.Operator:
        methods.add(procedure);
        break;
      case ProcedureKind.Getter:
        getters.add(procedure);
        break;
      case ProcedureKind.Setter:
        setters.add(procedure);
        break;
      case ProcedureKind.Factory:
        // Factory constructors are handled as procedures, not constructors
        methods.add(procedure);
        break;
    }
  }

  // 生成字段
  if (fields.isNotEmpty) {
    print('  // Fields');
    for (final field in fields) {
      _generateFieldCode(field);
    }
    print('');
  }

  // 生成构造函数
  if (constructors.isNotEmpty &&
      nodeType != 'enum' &&
      nodeType != 'extension') {
    print('  // Constructors');
    for (final constructor in constructors) {
      _generateConstructorCode(constructor);
    }
    print('');
  }

  // 生成方法
  if (methods.isNotEmpty) {
    print('  // Methods');
    for (final method in methods) {
      _generateMethodCode(method);
    }
    print('');
  }

  // 生成getters和setters
  if (getters.isNotEmpty || setters.isNotEmpty) {
    print('  // Properties');
    for (final getter in getters) {
      _generateGetterCode(getter);
    }
    for (final setter in setters) {
      _generateSetterCode(setter);
    }
    print('');
  }
}

void _generateFieldCode(Field field) {
  final type = _getTypeString(field.type);
  final name = field.name.text;
  final modifiers = <String>[];

  if (field.isStatic) modifiers.add('static');
  if (field.isFinal) modifiers.add('final');
  if (field.isConst) modifiers.add('const');

  final modifierStr = modifiers.join(' ');
  final prefix = modifierStr.isEmpty ? '' : '$modifierStr ';

  print('  $prefix$type $name;');
}

void _generateConstructorCode(Constructor constructor) {
  final className = constructor.enclosingClass.name;
  final constructorName = constructor.name.text;
  final displayName =
      constructorName.isEmpty ? className : '$className.$constructorName';

  final params = constructor.function.positionalParameters
      .map((p) => '${_getTypeString(p.type)} ${p.name ?? 'param'}')
      .join(', ');

  print('  $displayName($params);');
}

void _generateMethodCode(Procedure method) {
  final returnType = _getTypeString(method.function.returnType);
  final name = method.name.text;
  final modifiers = <String>[];

  if (method.isStatic) modifiers.add('static');
  if (method.isAbstract) modifiers.add('abstract');

  final params = method.function.positionalParameters
      .map((p) => '${_getTypeString(p.type)} ${p.name ?? 'param'}')
      .join(', ');

  final modifierStr = modifiers.join(' ');
  final prefix = modifierStr.isEmpty ? '' : '$modifierStr ';

  print('  $prefix$returnType $name($params);');
}

void _generateGetterCode(Procedure getter) {
  final returnType = _getTypeString(getter.function.returnType);
  final name = getter.name.text;
  print('  $returnType get $name;');
}

void _generateSetterCode(Procedure setter) {
  final paramType = setter.function.positionalParameters.isNotEmpty
      ? _getTypeString(setter.function.positionalParameters.first.type)
      : 'dynamic';
  final name = setter.name.text;
  print('  set $name($paramType value);');
}

String _getTypeString(DartType type) {
  if (type is InterfaceType) {
    final className = type.classNode.name;
    if (type.typeArguments.isEmpty) {
      return className;
    } else {
      final args = type.typeArguments.map(_getTypeString).join(', ');
      return '$className<$args>';
    }
  } else if (type is FunctionType) {
    final returnType = _getTypeString(type.returnType);
    final params = type.positionalParameters.map(_getTypeString).join(', ');
    return '$returnType Function($params)';
  } else if (type is TypeParameterType) {
    return type.parameter.name ?? 'T';
  } else if (type is DynamicType) {
    return 'dynamic';
  } else if (type is VoidType) {
    return 'void';
  } else if (type is NeverType) {
    return 'Never';
  }
  return 'dynamic';
}

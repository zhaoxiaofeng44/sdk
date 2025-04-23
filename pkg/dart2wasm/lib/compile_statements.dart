import 'package:kernel/kernel.dart';
import 'package:kernel/src/printer.dart';
import 'package:kernel/src/text_util.dart';
import 'package:kernel/ast.dart';

String nullabilityToString(Nullability nullability) {
  switch (nullability) {
    case Nullability.legacy:
      return '*';
    case Nullability.nullable:
      return '?';
    case Nullability.undetermined:
      return '%';
    case Nullability.nonNullable:
      return '';
  }
}

String nameToString(Name? node, {bool includeLibraryName = false}) {
  if (node == null) {
    return 'null';
  } else if (node.library != null && includeLibraryName) {
    return '${libraryNameToString(node.library)}::${node.text}';
  } else {
    return node.text;
  }
}

String libraryNameToString(Library? node) {
  return node == null ? 'null' : node.name ?? 'library ${node.importUri}';
}

String libraryReferenceToString(Reference? reference) {
  if (reference == null) {
    return '<missing-library-reference>';
  } else {
    Library? node = reference.node as Library?;
    if (node != null) {
      return node.importUri.toString();
    } else {
      CanonicalName? canonicalName = reference.canonicalName;
      if (canonicalName != null) {
        return qualifiedCanonicalNameToString(canonicalName,
            includeLibraryName: false);
      } else {
        return '<unlinked-library-reference>';
      }
    }
  }
}

String qualifiedClassNameToString(Class node,
    {bool includeLibraryName = false}) {
  TreeNode? parent = node.parent;
  if (parent is Library && includeLibraryName) {
    return libraryNameToString(parent) + '::' + classNameToString(node);
  } else {
    return classNameToString(node);
  }
}

String qualifiedCanonicalNameToString(CanonicalName canonicalName,
    {bool includeLibraryName = false,
    bool includeLibraryNamesInTypes = false}) {
  if (canonicalName.isRoot) {
    return '<root>';
  } else if (canonicalName.parent!.isRoot) {
    // Library.
    return 'library ${canonicalName.name}';
  } else if (canonicalName.parent!.parent!.isRoot) {
    // Class or extension.
    if (!includeLibraryName) {
      return canonicalName.name;
    }
    String parentName = qualifiedCanonicalNameToString(canonicalName.parent!,
        includeLibraryName: includeLibraryName,
        includeLibraryNamesInTypes: includeLibraryNamesInTypes);
    return '$parentName::${canonicalName.name}';
  } else {
    // Constructor, field, procedure (factory, getter, setter etc), typedef;
    // but we could technically be anywhere in the "hierarchy" --- at the
    // @typedef for instance, or at the uri of a library for a private name.
    CanonicalName parentNotPrivateUri = canonicalName.parent!;
    if (canonicalName.name.startsWith("_")) {
      parentNotPrivateUri = parentNotPrivateUri.parent!;
    }
    if (parentNotPrivateUri.name == CanonicalName.typedefsName) {
      includeLibraryName = includeLibraryNamesInTypes;
    }
    if (parentNotPrivateUri.parent!.parent!.parent?.isRoot == true) {
      // Parent is class (or extension).
      String parentName = qualifiedCanonicalNameToString(
          parentNotPrivateUri.parent!,
          includeLibraryName: includeLibraryName,
          includeLibraryNamesInTypes: includeLibraryNamesInTypes);
      //return "$parentName.${canonicalName.name}";
      return canonicalName.name;
    } else {
      // Parent is library.
      if (!includeLibraryName) {
        return canonicalName.name;
      }
      String parentName = qualifiedCanonicalNameToString(
          parentNotPrivateUri.parent!,
          includeLibraryName: includeLibraryName,
          includeLibraryNamesInTypes: includeLibraryNamesInTypes);
      return '$parentName::${canonicalName.name}';
    }
  }
}

String qualifiedClassNameToStringByReference(Reference? reference,
    {bool includeLibraryName = false}) {
  if (reference == null) {
    return '<missing-class-reference>';
  } else {
    Class? node = reference.node as Class?;
    if (node != null) {
      return qualifiedClassNameToString(node,
          includeLibraryName: includeLibraryName);
    } else {
      CanonicalName? canonicalName = reference.canonicalName;
      if (canonicalName != null) {
        return qualifiedCanonicalNameToString(canonicalName,
            includeLibraryName: includeLibraryName);
      } else {
        return '<unlinked-class-reference>';
      }
    }
  }
}

String classNameToString(Class? node) {
  return node == null ? 'null' : node.name;
}

String qualifiedExtensionNameToString(Extension node,
    {bool includeLibraryName = false}) {
  TreeNode? parent = node.parent;
  if (parent is Library && includeLibraryName) {
    return libraryNameToString(parent) + '::' + extensionNameToString(node);
  } else {
    return extensionNameToString(node);
  }
}

String qualifiedExtensionNameToStringByReference(Reference? reference,
    {bool includeLibraryName = false}) {
  if (reference == null) {
    return '<missing-extension-reference>';
  } else {
    Extension? node = reference.node as Extension?;
    if (node != null) {
      return qualifiedExtensionNameToString(node,
          includeLibraryName: includeLibraryName);
    } else {
      CanonicalName? canonicalName = reference.canonicalName;
      if (canonicalName != null) {
        return qualifiedCanonicalNameToString(canonicalName,
            includeLibraryName: includeLibraryName);
      } else {
        return '<unlinked-extension-reference>';
      }
    }
  }
}

String extensionNameToString(Extension? node) {
  return node == null ? 'null' : node.name;
}

String qualifiedExtensionTypeDeclarationNameToString(
    ExtensionTypeDeclaration node,
    {bool includeLibraryName = false}) {
  TreeNode? parent = node.parent;
  if (parent is Library && includeLibraryName) {
    return libraryNameToString(parent) +
        '::' +
        extensionTypeDeclarationNameToString(node);
  } else {
    return extensionTypeDeclarationNameToString(node);
  }
}

String qualifiedExtensionTypeDeclarationNameToStringByReference(
    Reference? reference,
    {bool includeLibraryName = false}) {
  if (reference == null) {
    return '<missing-extension-type-declaration-reference>';
  } else {
    ExtensionTypeDeclaration? node =
        reference.node as ExtensionTypeDeclaration?;
    if (node != null) {
      return qualifiedExtensionTypeDeclarationNameToString(node,
          includeLibraryName: includeLibraryName);
    } else {
      CanonicalName? canonicalName = reference.canonicalName;
      if (canonicalName != null) {
        return qualifiedCanonicalNameToString(canonicalName,
            includeLibraryName: includeLibraryName);
      } else {
        return '<unlinked-extension-type-declaration-reference>';
      }
    }
  }
}

String extensionTypeDeclarationNameToString(ExtensionTypeDeclaration? node) {
  return node == null ? 'null' : node.name;
}

String qualifiedTypedefNameToString(Typedef node,
    {bool includeLibraryName = false}) {
  TreeNode? parent = node.parent;
  if (parent is Library && includeLibraryName) {
    return libraryNameToString(parent) + '::' + typedefNameToString(node);
  } else {
    return typedefNameToString(node);
  }
}

String qualifiedTypedefNameToStringByReference(Reference? reference,
    {bool includeLibraryName = false}) {
  if (reference == null) {
    return '<missing-typedef-reference>';
  } else {
    Typedef? node = reference.node as Typedef?;
    if (node != null) {
      return qualifiedTypedefNameToString(node,
          includeLibraryName: includeLibraryName);
    } else {
      CanonicalName? canonicalName = reference.canonicalName;
      if (canonicalName != null) {
        return qualifiedCanonicalNameToString(canonicalName,
            includeLibraryName: includeLibraryName);
      } else {
        return '<unlinked-typedef-reference>';
      }
    }
  }
}

String typedefNameToString(Typedef? node) {
  return node == null ? 'null' : node.name;
}

String qualifiedMemberNameToString(Member node,
    {bool includeLibraryName = false}) {
  TreeNode? parent = node.parent;
  if (parent is Class) {
    // return qualifiedClassNameToString(parent,
    //         includeLibraryName: includeLibraryName) +
    //     '.' +
    //     memberNameToString(node);
    return memberNameToString(node);
  } else if (parent is ExtensionTypeDeclaration) {
    // return qualifiedExtensionTypeDeclarationNameToString(parent,
    //         includeLibraryName: includeLibraryName) +
    //     '.' +
    //     memberNameToString(node);

    return memberNameToString(node);
  } else if (parent is Library && includeLibraryName) {
    return libraryNameToString(parent) + '::' + memberNameToString(node);
  } else {
    return memberNameToString(node);
  }
}

String qualifiedMemberNameToStringByReference(Reference? reference,
    {bool includeLibraryName = false}) {
  if (reference == null) {
    return '<missing-member-reference>';
  } else {
    Member? node = reference.node as Member?;
    if (node != null) {
      return qualifiedMemberNameToString(node,
          includeLibraryName: includeLibraryName);
    } else {
      CanonicalName? canonicalName = reference.canonicalName;
      if (canonicalName != null) {
        return qualifiedCanonicalNameToString(canonicalName,
            includeLibraryName: includeLibraryName);
      } else {
        return '<unlinked-member-reference>';
      }
    }
  }
}

String memberNameToString(Member node) {
  return node.name.text;
}

String qualifiedTypeParameterNameToString(TypeParameter node,
    {required bool includeLibraryName, required bool recurseOnLocalFunction}) {
  GenericDeclaration? declaration = node.declaration;
  String? declarationName =
      _qualifiedTypeParameterGenericDeclarationNameToString(declaration,
          includeLibraryName: includeLibraryName,
          recurseOnLocalFunction: recurseOnLocalFunction);
  if (declarationName != null) {
    //return "$declarationName.${typeParameterNameToString(node)}";
    return "${typeParameterNameToString(node)}";
  }

  return typeParameterNameToString(node);
}

String? _qualifiedTypeParameterGenericDeclarationNameToString(
    GenericDeclaration? declaration,
    {required bool includeLibraryName,
    required bool recurseOnLocalFunction}) {
  switch (declaration) {
    case Class():
      return qualifiedClassNameToString(declaration,
          includeLibraryName: includeLibraryName);
    case Extension():
      return qualifiedExtensionNameToString(declaration,
          includeLibraryName: includeLibraryName);
    case ExtensionTypeDeclaration():
      return qualifiedExtensionTypeDeclarationNameToString(declaration,
          includeLibraryName: includeLibraryName);
    case Typedef():
      return qualifiedTypedefNameToString(declaration,
          includeLibraryName: includeLibraryName);
    case Procedure():
      return qualifiedMemberNameToString(declaration,
          includeLibraryName: includeLibraryName);
    case LocalFunction():
      if (recurseOnLocalFunction &&
          declaration is FunctionDeclaration &&
          declaration.variable.name != null) {
        TreeNode? parent = declaration.parent;
        while (parent != null && parent is! GenericDeclaration) {
          parent = parent.parent;
        }
        if (parent is GenericDeclaration) {
          String? parentName =
              _qualifiedTypeParameterGenericDeclarationNameToString(parent,
                  includeLibraryName: includeLibraryName,
                  recurseOnLocalFunction: recurseOnLocalFunction);
          //return "$parentName.${declaration.variable.name}";
          return declaration.variable.name;
        }
      }
      return null;
    case null:
      return null;
  }
}

String qualifiedStructuralParameterNameToString(StructuralParameter node,
    {bool includeLibraryName = false}) {
  return structuralParameterNameToString(node);
}

String typeParameterNameToString(TypeParameter node) {
  return node.name ??
      "null-named TypeParameter ${node.runtimeType} ${node.hashCode}";
}

String structuralParameterNameToString(StructuralParameter node) {
  return node.name ??
      "null-named StructuralParameter "
          "${node.runtimeType} ${node.hashCode}";
}

String? getEscapedCharacter(int codeUnit) {
  switch (codeUnit) {
    case 9:
      return r'\t';
    case 10:
      return r'\n';
    case 11:
      return r'\v';
    case 12:
      return r'\f';
    case 13:
      return r'\r';
    case 34:
      return r'\"';
    case 36:
      return r'\$';
    case 92:
      return r'\\';
    default:
      if (codeUnit < 32 || codeUnit > 126) {
        return r'\u' + '$codeUnit'.padLeft(4, '0');
      } else {
        return null;
      }
  }
}

String escapeString(String string) {
  StringBuffer? buffer;
  for (int i = 0; i < string.length; ++i) {
    String? character = getEscapedCharacter(string.codeUnitAt(i));
    if (character != null) {
      buffer ??= new StringBuffer(string.substring(0, i));
      buffer.write(character);
    } else {
      buffer?.write(string[i]);
    }
  }
  return buffer == null ? string : buffer.toString();
}

class MyAstPrinter implements AstPrinter {
  final AstTextStrategy _strategy = defaultAstTextStrategy;
  final StringBuffer _sb = new StringBuffer();
  int _statementLevel = 0;
  int _expressionLevel = 0;
  int _constantLevel = 0;
  int _indentationLevel = 0;
  late final Map<LabeledStatement, String> _labelNames = {};
  late final Map<VariableDeclaration, String> _variableNames = {};

  bool get includeAuxiliaryProperties => _strategy.includeAuxiliaryProperties;

  MyAstPrinter();

  void incIndentation() {
    _indentationLevel++;
  }

  void decIndentation() {
    _indentationLevel--;
  }

  void write(String value) {
    _sb.write(value);
  }

  @override
  void writeClassName(Reference? reference, {bool forType = false}) {
    _sb.write(qualifiedClassNameToStringByReference(reference,
        includeLibraryName: forType
            ? _strategy.includeLibraryNamesInTypes
            : _strategy.includeLibraryNamesInMembers));
  }

  void writeTypedefName(Reference? reference) {
    _sb.write(qualifiedTypedefNameToStringByReference(reference,
        includeLibraryName: _strategy.includeLibraryNamesInTypes));
  }

  void writeExtensionName(Reference? reference) {
    _sb.write(qualifiedExtensionNameToStringByReference(reference,
        includeLibraryName: _strategy.includeLibraryNamesInMembers));
  }

  void writeExtensionTypeDeclarationName(Reference? reference) {
    _sb.write(qualifiedExtensionTypeDeclarationNameToStringByReference(
        reference,
        includeLibraryName: _strategy.includeLibraryNamesInMembers));
  }

  void writeQualifiedCanonicalNameToString(CanonicalName canonicalName) {
    _sb.write(qualifiedCanonicalNameToString(canonicalName,
        includeLibraryName: _strategy.includeLibraryNamesInMembers,
        includeLibraryNamesInTypes: _strategy.includeLibraryNamesInTypes));
  }

  void writeMemberName(Reference? reference) {
    _sb.write(qualifiedMemberNameToStringByReference(reference,
        includeLibraryName: _strategy.includeLibraryNamesInMembers));
  }

  void writeInterfaceMemberName(Reference? reference, Name? name) {
    if (name != null && (reference == null || reference.node == null)) {
      writeName(name);
    } else {
      write('{');
      _sb.write(qualifiedMemberNameToStringByReference(reference,
          includeLibraryName: _strategy.includeLibraryNamesInMembers));
      write('}');
    }
  }

  void writeLibraryReference(Reference reference) {
    _sb.write(libraryReferenceToString(reference));
  }

  void writeName(Name? name) {
    _sb.write(nameToString(name,
        includeLibraryName: _strategy.includeLibraryNamesInMembers));
  }

  void writeNamedType(NamedType node) {
    node.toTextInternal(this);
  }

  void writeTypeParameterName(TypeParameter parameter) {
    _sb.write(_strategy.useQualifiedTypeParameterNames
        ? qualifiedTypeParameterNameToString(parameter,
            includeLibraryName: _strategy.includeLibraryNamesInTypes,
            recurseOnLocalFunction: _strategy
                .useQualifiedTypeParameterNamesRecurseOnNamedLocalFunctions)
        : typeParameterNameToString(parameter));
  }

  void writeStructuralParameterName(StructuralParameter parameter) {
    _sb.write(_strategy.useQualifiedTypeParameterNames
        ? qualifiedStructuralParameterNameToString(parameter,
            includeLibraryName: _strategy.includeLibraryNamesInTypes)
        : structuralParameterNameToString(parameter));
  }

  void newLine() {
    if (_strategy.useMultiline) {
      _sb.writeln();
      _sb.write(_strategy.indentation * _indentationLevel);
    } else {
      _sb.write(' ');
    }
  }

  String getLabelName(LabeledStatement node) {
    return _labelNames[node] ??= 'label${_labelNames.length}';
  }

  String getVariableName(VariableDeclaration node) {
    String? name = node.name;
    if (name != null) {
      return name;
    }
    return _variableNames[node] ??= '#${_variableNames.length}';
  }

  String getSwitchCaseName(SwitchCase node) {
    if (node.isDefault) {
      return '"default:"';
    } else {
      return '"case ${node.expressions.first.toText(_strategy)}:"';
    }
  }

  void writeStatement(Statement node) {
    int oldStatementLevel = _statementLevel;
    _statementLevel++;
    if (_strategy.maxStatementDepth != null &&
        _statementLevel > _strategy.maxStatementDepth!) {
      _sb.write('...');
    } else {
      node.toTextInternal(this);
    }
    _statementLevel = oldStatementLevel;
  }

  void writeExpression(Expression node, {int? minimumPrecedence}) {
    int oldExpressionLevel = _expressionLevel;
    _expressionLevel++;
    if (_strategy.maxExpressionDepth != null &&
        _expressionLevel > _strategy.maxExpressionDepth!) {
      _sb.write('...');
    } else {
      bool needsParentheses =
          minimumPrecedence != null && node.precedence < minimumPrecedence;
      if (needsParentheses) {
        _sb.write('(');
      }
      node.toTextInternal(this);
      if (needsParentheses) {
        _sb.write(')');
      }
    }
    _expressionLevel = oldExpressionLevel;
  }

  void writeNamedExpression(NamedExpression node) {
    node.toTextInternal(this);
  }

  void writeCatch(Catch node) {
    node.toTextInternal(this);
  }

  void writeSwitchCase(SwitchCase node) {
    node.toTextInternal(this);
  }

  void writeType(DartType node) {
    node.toTextInternal(this);
  }

  void writeNullability(Nullability nullability) {
    if (!_strategy.showNullableOnly || nullability == Nullability.nullable) {
      write(nullabilityToString(nullability));
    }
  }

  void writeConstant(Constant node) {
    int oldConstantLevel = _constantLevel;
    _constantLevel++;
    if (_strategy.maxConstantDepth != null &&
        _constantLevel > _strategy.maxConstantDepth!) {
      _sb.write('...');
    } else {
      node.toTextInternal(this);
    }
    _constantLevel = oldConstantLevel;
  }

  void writeMapEntry(MapLiteralEntry node) {
    node.toTextInternal(this);
  }

  /// Writes [types] to the printer buffer separated by ', '.
  void writeTypes(List<DartType> types) {
    for (int index = 0; index < types.length; index++) {
      if (index > 0) {
        _sb.write(', ');
      }
      writeType(types[index]);
    }
  }

  /// If [types] is non-empty, writes [types] to the printer buffer delimited by
  /// '<' and '>', and separated by ', '.
  void writeTypeArguments(List<DartType> types) {
    if (types.isNotEmpty) {
      _sb.write('<');
      writeTypes(types);
      _sb.write('>');
    }
  }

  /// If [typeParameters] is non-empty, writes [typeParameters] to the printer
  /// buffer delimited by '<' and '>', and separated by ', '.
  ///
  /// The bound of a type parameter is included, as 'T extends Bound', if the
  /// bound is neither `Object?` nor `Object*`.
  void writeTypeParameters(List<TypeParameter> typeParameters) {
    if (typeParameters.isNotEmpty) {
      _sb.write("<");
      String comma = "";
      for (TypeParameter typeParameter in typeParameters) {
        _sb.write(comma);
        _sb.write(typeParameter.name);
        DartType bound = typeParameter.bound;

        bool isTopObject(DartType type) {
          if (type is InterfaceType &&
              type.classReference.node != null &&
              type.classNode.name == 'Object') {
            Uri uri = type.classNode.enclosingLibrary.importUri;
            return uri.isScheme('dart') &&
                uri.path == 'core' &&
                (type.nullability == Nullability.legacy ||
                    type.nullability == Nullability.nullable);
          }
          return false;
        }

        if (!isTopObject(bound) || isTopObject(typeParameter.defaultType)) {
          // Include explicit bounds only.
          _sb.write(' extends ');
          writeType(bound);
        }
        comma = ", ";
      }
      _sb.write(">");
    }
  }

  /// If [typeParameters] is non-empty, writes [typeParameters] to the printer
  /// buffer delimited by '<' and '>', and separated by ', '.
  ///
  /// The bound of a type parameter is included, as 'T extends Bound', if the
  /// bound is neither `Object?` nor `Object*`.
  void writeStructuralParameters(List<StructuralParameter> typeParameters) {
    if (typeParameters.isNotEmpty) {
      _sb.write("<");
      String comma = "";
      for (StructuralParameter typeParameter in typeParameters) {
        _sb.write(comma);
        _sb.write(typeParameter.name);
        DartType bound = typeParameter.bound;

        bool isTopObject(DartType type) {
          if (type is InterfaceType &&
              type.classReference.node != null &&
              type.classNode.name == 'Object') {
            Uri uri = type.classNode.enclosingLibrary.importUri;
            return uri.isScheme('dart') &&
                uri.path == 'core' &&
                (type.nullability == Nullability.legacy ||
                    type.nullability == Nullability.nullable);
          }
          return false;
        }

        if (!isTopObject(bound) || isTopObject(typeParameter.defaultType)) {
          // Include explicit bounds only.
          _sb.write(' extends ');
          writeType(bound);
        }
        comma = ", ";
      }
      _sb.write(">");
    }
  }

  /// Writes [expressions] to the printer buffer separated by ', '.
  void writeExpressions(List<Expression> expressions) {
    if (expressions.isNotEmpty &&
        _strategy.maxExpressionDepth != null &&
        _expressionLevel + 1 > _strategy.maxExpressionDepth!) {
      // The maximum expression depth will be exceeded for all [expressions].
      // Print the list as one occurrence '...' instead one per expression.
      _sb.write('...');
    } else if (_strategy.maxExpressionsLength != null &&
        expressions.length > _strategy.maxExpressionsLength!) {
      _sb.write('...');
    } else {
      for (int index = 0; index < expressions.length; index++) {
        if (index > 0) {
          _sb.write(', ');
        }
        writeExpression(expressions[index]);
      }
    }
  }

  /// Writes [statements] to the printer buffer delimited by '{' and '}'.
  ///
  /// If using a multiline strategy, the statements printed on separate lines
  /// that are indented one level.
  void writeBlock(List<Statement> statements) {
    if (statements.isEmpty) {
      write('{}');
    } else {
      write('{');
      incIndentation();
      writeStatements(statements);
      decIndentation();
      newLine();
      write('}');
    }
  }

  /// Writes [statements] to the printer buffer.
  ///
  /// If using a multiline strategy, the statements printed on separate lines
  /// that are indented one level.
  void writeStatements(List<Statement> statements) {
    if (statements.isNotEmpty &&
        _strategy.maxStatementDepth != null &&
        _statementLevel + 1 > _strategy.maxStatementDepth!) {
      // The maximum statement depth will be exceeded for all [statements].
      // Print the list as one occurrence '...' instead one per statement.
      _sb.write(' ...');
    } else if (_strategy.maxStatementsLength != null &&
        statements.length > _strategy.maxStatementsLength!) {
      _sb.write(' ...');
    } else {
      for (Statement statement in statements) {
        newLine();
        writeStatement(statement);
      }
    }
  }

  /// Writes arguments [node] to the printer buffer.
  ///
  /// If [includeTypeArguments] is `true` type arguments in [node] are included.
  /// Otherwise only the positional and named arguments are included.
  void writeArguments(Arguments node, {bool includeTypeArguments = true}) {
    node.toTextInternal(this, includeTypeArguments: includeTypeArguments);
  }

  /// Writes the variable declaration [node] to the printer buffer.
  ///
  /// If [includeModifiersAndType] is `true`, the declaration is prefixed by
  /// the modifiers and declared type of the variable. Otherwise only the
  /// name and the initializer, if present, are included.
  ///
  /// If [isLate] and [type] are provided, these values are used instead of
  /// the corresponding properties on [node].
  void writeVariableDeclaration(VariableDeclaration node,
      {bool includeModifiersAndType = true,
      bool? isLate,
      DartType? type,
      bool includeInitializer = true}) {
    if (includeModifiersAndType) {
      if (node.isRequired) {
        _sb.write('required ');
      }
      if (isLate ?? node.isLate) {
        _sb.write('late ');
      }
      if (node.isFinal) {
        _sb.write('final ');
      }
      if (node.isConst) {
        _sb.write('const ');
      }
      writeType(type ?? node.type);
      _sb.write(' ');
    }
    _sb.write(getVariableName(node));
    if (includeInitializer && node.initializer != null && !node.isRequired) {
      _sb.write(' = ');
      writeExpression(node.initializer!);
    }
  }

  void writeFunctionNode(FunctionNode node, String name) {
    writeType(node.returnType);
    _sb.write(' ');
    _sb.write(name);
    if (node.typeParameters.isNotEmpty) {
      _sb.write('<');
      for (int index = 0; index < node.typeParameters.length; index++) {
        if (index > 0) {
          _sb.write(', ');
        }
        _sb.write(node.typeParameters[index].name);
        _sb.write(' extends ');
        writeType(node.typeParameters[index].bound);
      }
      _sb.write('>');
    }
    _sb.write('(');
    for (int index = 0; index < node.positionalParameters.length; index++) {
      if (index > 0) {
        _sb.write(', ');
      }
      if (index == node.requiredParameterCount) {
        _sb.write('[');
      }
      writeVariableDeclaration(node.positionalParameters[index]);
    }
    if (node.requiredParameterCount < node.positionalParameters.length) {
      _sb.write(']');
    }
    if (node.namedParameters.isNotEmpty) {
      if (node.positionalParameters.isNotEmpty) {
        _sb.write(', ');
      }
      _sb.write('{');
      for (int index = 0; index < node.namedParameters.length; index++) {
        if (index > 0) {
          _sb.write(', ');
        }
        writeVariableDeclaration(node.namedParameters[index]);
      }
      _sb.write('}');
    }
    _sb.write(')');
    Statement? body = node.body;
    if (body != null) {
      if (body is ReturnStatement) {
        _sb.write(' => ');
        writeExpression(body.expression!);
      } else {
        _sb.write(' ');
        writeStatement(body);
      }
    } else {
      _sb.write(';');
    }
  }

  void writeConstantMapEntry(ConstantMapEntry node) {
    node.toTextInternal(this);
  }

  /// Returns the text written to this printer.
  String getText() => _sb.toString();
}

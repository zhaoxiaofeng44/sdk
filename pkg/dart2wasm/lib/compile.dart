// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:build_integration/file_system/multi_root.dart'
    show MultiRootFileSystem;
import 'package:front_end/src/api_prototype/macros.dart' as macros
    show isMacroLibraryUri;
import 'package:front_end/src/api_prototype/standard_file_system.dart'
    show StandardFileSystem;
import 'package:front_end/src/api_unstable/vm.dart'
    show
        CompilerOptions,
        CompilerResult,
        DiagnosticMessage,
        kernelForProgram,
        NnbdMode,
        Severity;
import 'package:kernel/ast.dart';
import 'package:kernel/class_hierarchy.dart';
import 'package:kernel/core_types.dart';
import 'package:kernel/kernel.dart' show writeComponentToText;
import 'package:kernel/library_index.dart';
import 'package:kernel/verifier.dart';
import 'package:vm/kernel_front_end.dart' show writeDepfile;
import 'package:vm/transformations/mixin_deduplication.dart'
    as mixin_deduplication show transformComponent;
import 'package:vm/transformations/to_string_transformer.dart'
    as to_string_transformer;
import 'package:vm/transformations/type_flow/transformer.dart' as globalTypeFlow
    show transformComponent;
import 'package:vm/transformations/unreachable_code_elimination.dart'
    as unreachable_code_elimination;
import 'package:wasm_builder/wasm_builder.dart' show Serializer;
import 'package:kernel/type_environment.dart';
import 'package:kernel/type_algebra.dart';


import 'class_info.dart';
import 'compile_statements.dart';
import 'compiler_options.dart' as compiler;
import 'constant_evaluator.dart';
import 'cy_helper.dart';
import 'deferred_loading.dart' as deferred_loading;
import 'js/runtime_generator.dart' as js;
import 'record_class_generator.dart';
import 'records.dart';
import 'target.dart' as wasm show Mode;
import 'target.dart' hide Mode;
import 'translator.dart';

sealed class CompilationResult {}

class CompilationSuccess extends CompilationResult {
  final Map<String, ({Uint8List moduleBytes, String? sourceMap})> wasmModules;
  final String jsRuntime;

  CompilationSuccess(this.wasmModules, this.jsRuntime);
}

class CompilationError extends CompilationResult {}

/// The CFE has crashed with an exception.
///
/// This is a CFE bug and should be reported by users.
class CFECrashError extends CompilationError {
  final Object error;
  final StackTrace stackTrace;

  CFECrashError(this.error, this.stackTrace);
}

/// Compiling the Dart program resulted in compile-time errors.
///
/// This is a bug in the dart program (e.g. syntax errors, static type errors,
/// ...) that's being compiled.  Users have to address those errors in their
/// code for it to compile successfully.
///
/// The errors are already printed via the `handleDiagnosticMessage` callback.
/// (We print them as soon as they are reported by CFE. i.e. we stream errors
/// instead of accumulating/batching all of them and reporting at the end.)
class CFECompileTimeErrors extends CompilationError {
  CFECompileTimeErrors();
}

/// Compile a Dart file into a Wasm module.
///
/// Returns `null` if an error occurred during compilation. The
/// [handleDiagnosticMessage] callback will have received an error message
/// describing the error.
///
/// When generating source maps, `sourceMapUrlGenerator` argument should be
/// provided which takes the module name and gives the URL of the source map.
/// This value will be added to the Wasm module in `sourceMappingURL` section.
/// When this argument is null the code generator does not generate source
/// mappings.
Future<CompilationResult> compileToModule(
    compiler.WasmCompilerOptions options,
    Uri Function(String moduleName)? sourceMapUrlGenerator,
    void Function(DiagnosticMessage) handleDiagnosticMessage) async {
  var hadCompileTimeError = false;
  void diagnosticMessageHandler(DiagnosticMessage message) {
    if (message.severity == Severity.error) {
      hadCompileTimeError = true;
    }
    handleDiagnosticMessage(message);
  }

  final wasm.Mode mode;
  if (options.translatorOptions.jsCompatibility) {
    mode = wasm.Mode.jsCompatibility;
  } else {
    mode = wasm.Mode.regular;
  }
  final WasmTarget target = WasmTarget(
      enableExperimentalFfi: options.translatorOptions.enableExperimentalFfi,
      enableExperimentalWasmInterop:
          options.translatorOptions.enableExperimentalWasmInterop,
      removeAsserts: !options.translatorOptions.enableAsserts,
      mode: mode);
  CompilerOptions compilerOptions = CompilerOptions()
    ..target = target
    // This is a dummy directory that always exists. This option should be
    // unused as we pass platform.dill or libraries.json, though currently the
    // CFE mandates this option to be there (but doesn't use it).
    // => Remove this once CFE no longer mandates this (or remove option in CFE
    // entirely).
    ..sdkRoot = Uri.file('.')
    ..librariesSpecificationUri = options.librariesSpecPath
    ..packagesFileUri = options.packagesPath
    ..environmentDefines = {
      'dart.tool.dart2wasm': 'true',
      ...options.environment,
    }
    ..explicitExperimentalFlags = options.feExperimentalFlags
    ..verbose = false
    ..onDiagnostic = diagnosticMessageHandler
    ..nnbdMode = NnbdMode.Strong;
  if (options.multiRootScheme != null) {
    compilerOptions.fileSystem = MultiRootFileSystem(
        options.multiRootScheme!,
        options.multiRoots.isEmpty ? [Uri.base] : options.multiRoots,
        StandardFileSystem.instance);
  }

  if (options.platformPath != null) {
    compilerOptions.sdkSummary = options.platformPath;
  } else {
    compilerOptions.compileSdk = true;
  }

  CompilerResult? compilerResult;
  try {
    compilerResult = await kernelForProgram(options.mainUri, compilerOptions);
  } catch (e, s) {
    return CFECrashError(e, s);
  }
  if (hadCompileTimeError) return CFECompileTimeErrors();
  assert(compilerResult != null);

  Component component = compilerResult!.component!;
  CoreTypes coreTypes = compilerResult.coreTypes!;
  ClassHierarchy classHierarchy = compilerResult.classHierarchy!;
  LibraryIndex libraryIndex = LibraryIndex(component, [
    "dart:_boxed_bool",
    "dart:_boxed_double",
    "dart:_boxed_int",
    "dart:_compact_hash",
    "dart:_internal",
    "dart:_js_helper",
    "dart:_js_types",
    "dart:_list",
    "dart:_string",
    "dart:_wasm",
    "dart:async",
    "dart:collection",
    "dart:core",
    "dart:ffi",
    "dart:typed_data",
  ]);

  if (options.dumpKernelAfterCfe != null) {
    writeComponentToText(component, path: options.dumpKernelAfterCfe!);
  }

  if (options.deleteToStringPackageUri.isNotEmpty) {
    to_string_transformer.transformComponent(
        component, options.deleteToStringPackageUri);
  }

  if (options.translatorOptions.enableMultiModuleStressTestMode) {
    deferred_loading.transformComponentForTestMode(
        component, classHierarchy, coreTypes, target);
  }

  ConstantEvaluator constantEvaluator = ConstantEvaluator(
      options, target, component, coreTypes, classHierarchy, libraryIndex);
  unreachable_code_elimination.transformComponent(target, component,
      constantEvaluator, options.translatorOptions.enableAsserts);

  js.RuntimeFinalizer jsRuntimeFinalizer =
      js.createRuntimeFinalizer(component, coreTypes, classHierarchy);

  final Map<RecordShape, Class> recordClasses =
      generateRecordClasses(component, coreTypes);
  target.recordClasses = recordClasses;

  if (options.dumpKernelBeforeTfa != null) {
    writeComponentToText(component, path: options.dumpKernelBeforeTfa!);
  }

  mixin_deduplication.transformComponent(component);

  // Patch `dart:_internal`s `mainTearOff` getter.
  final internalLib = component.libraries
      .singleWhere((lib) => lib.importUri.toString() == 'dart:_internal');
  final mainTearOff = internalLib.procedures
      .singleWhere((procedure) => procedure.name.text == 'mainTearOff');
  mainTearOff.isExternal = false;
  mainTearOff.function.body = ReturnStatement(
      ConstantExpression(StaticTearOffConstant(component.mainMethod!)));

  // 这一步会改写class 的属性
  // Keep the flags in-sync with
  // pkg/vm/test/transformations/type_flow/transformer_test.dart
  globalTypeFlow.transformComponent(target, coreTypes, component,
      useRapidTypeAnalysis: false);

  if (options.dumpKernelAfterTfa != null) {
    writeComponentToText(component,
        path: options.dumpKernelAfterTfa!, showMetadata: true);
  }

  assert(() {
    verifyComponent(
        target, VerificationStage.afterGlobalTransformations, component);
    return true;
  }());

  final moduleOutputData = deferred_loading.modulesForComponent(
      component, options, target, coreTypes);

  var translator = Translator(component, coreTypes, libraryIndex, recordClasses,
      moduleOutputData, options.translatorOptions);

  String? depFile = options.depFile;
  if (depFile != null) {
    writeDepfile(
        compilerOptions.fileSystem,
        // TODO(https://dartbug.com/55246): track macro deps when available.
        component.uriToSource.keys
            .where((uri) => !macros.isMacroLibraryUri(uri)),
        options.outputFile,
        depFile);
  }

  final generateSourceMaps = options.translatorOptions.generateSourceMaps;
  final modules = translator.translate(sourceMapUrlGenerator);

  final wasmModules = <String, ({Uint8List moduleBytes, String? sourceMap})>{};
  modules.forEach((moduleOutput, module) {
    final serializer = Serializer();
    module.serialize(serializer);
    final wasmModuleSerialized = serializer.data;

    final sourceMap =
        generateSourceMaps ? serializer.sourceMapSerializer.serialize() : null;
    wasmModules[moduleOutput.moduleName] =
        (moduleBytes: wasmModuleSerialized, sourceMap: sourceMap);
  });

  String jsRuntime = jsRuntimeFinalizer.generate(
      translator.functions.translatedProcedures,
      translator.internalizedStringsForJSRuntime,
      mode);

  printTranslator(translator);
  return CompilationSuccess(wasmModules, jsRuntime);
}

void printTranslator(Translator translator) {
  for (final classInfo in translator.classInfo.values) {
    if ('MyTest' != classInfo.cls?.name && 'ComplexTest' !=classInfo.cls?.name ) {
      continue;
    }
    // print('Class: ${classInfo.cls?.name}');
    // print('  - superInfo: ${classInfo.superInfo?.cls?.name}');

    // var printer = MyAstPrinter();
    // classInfo.cls?.toTextInternal(printer);
    // print(printer.getText());
    // classInfo.cls.toStringInternal();
    printClass(classInfo);
  }

  //printSort(translator);
}

void printClass(ClassInfo classInfo){
  if (classInfo.cls == null) {
    return;
  }

  // First print headers and base classes
  if (classInfo.cls!.name == "MyTest") {
    print('''
#include <string>
#include <iostream>
#include <memory>
#include <vector>
#include <map>
#include <set>
#include "containers.hpp"

class Object {
public:
  virtual ~Object() = default;
  virtual std::string toString() const {
    return "Object";
  }
};
''');
    printStringClass();
    printContainerClasses();
    print("");
  }

  // Then print class declaration
  printClassDeclaration(classInfo);
  print("");
  // Then print function implementations
  printClassImplementation(classInfo);
}

void printStringClass() {
  print('''
class String : public Object {
public:
  std::string value;
  int length;

  static String* _new_0() {
    String* obj = new String();
    obj->value = "";
    obj->length = 0;
    return obj;
  }

  static String* fromStdString(const std::string& str) {
    String* obj = new String();
    obj->value = str;
    obj->length = str.length();
    return obj;
  }

  static String* fromInt(int value) {
    return fromStdString(std::to_string(value));
  }

  String* operator+(const String* other) const {
    if (other == nullptr) return nullptr;
    return fromStdString(this->value + other->value);
  }

  String* operator+(int value) const {
    return fromStdString(this->value + std::to_string(value));
  }

  bool operator==(const String* other) const {
    if (other == nullptr) return false;
    return this->value == other->value;
  }

  bool operator!=(const String* other) const {
    return !(*this == other);
  }

  virtual std::string toString() const override {
    return value;
  }

  int get_length() const {
    return length;
  }
};
''');
}

void printContainerClasses() {
  print('''
template<typename T>
class List : public Object {
public:
  std::vector<T> items;

  static List<T>* _new_0() {
    List<T>* obj = new List<T>();
    return obj;
  }

  void add(T item) {
    items.push_back(item);
  }

  T get(int index) {
    return items[index];
  }

  void set(int index, T value) {
    items[index] = value;
  }

  int get length() {
    return items.size();
  }

  virtual std::string toString() const override {
    std::string result = "[";
    for (size_t i = 0; i < items.size(); ++i) {
      if (i > 0) result += ", ";
      if constexpr (std::is_pointer<T>::value) {
        result += items[i] ? items[i]->toString() : "null";
      } else {
        result += std::to_string(items[i]);
      }
    }
    result += "]";
    return result;
  }
};

template<typename K, typename V>
class Map : public Object {
public:
  std::map<K, V> items;

  static Map<K, V>* _new_0() {
    Map<K, V>* obj = new Map<K, V>();
    return obj;
  }

  void put(K key, V value) {
    items[key] = value;
  }

  V get(K key) {
    return items[key];
  }

  bool containsKey(K key) {
    return items.find(key) != items.end();
  }

  int get length() {
    return items.size();
  }

  virtual std::string toString() const override {
    std::string result = "{";
    bool first = true;
    for (const auto& pair : items) {
      if (!first) result += ", ";
      if constexpr (std::is_pointer<K>::value) {
        result += pair.first ? pair.first->toString() : "null";
      } else {
        result += std::to_string(pair.first);
      }
      result += ": ";
      if constexpr (std::is_pointer<V>::value) {
        result += pair.second ? pair.second->toString() : "null";
      } else {
        result += std::to_string(pair.second);
      }
      first = false;
    }
    result += "}";
    return result;
  }
};

template<typename T>
class Set : public Object {
public:
  std::set<T> items;

  static Set<T>* _new_0() {
    Set<T>* obj = new Set<T>();
    return obj;
  }

  void add(T item) {
    items.insert(item);
  }

  bool contains(T item) {
    return items.find(item) != items.end();
  }

  int get length() {
    return items.size();
  }

  virtual std::string toString() const override {
    std::string result = "{";
    bool first = true;
    for (const auto& item : items) {
      if (!first) result += ", ";
      if constexpr (std::is_pointer<T>::value) {
        result += item ? item->toString() : "null";
      } else {
        result += std::to_string(item);
      }
      first = false;
    }
    result += "}";
    return result;
  }
};
''');
}

void printClassDeclaration(ClassInfo classInfo) {
  var printer = MyAstPrinter();
  
  // Print class header with template parameters if any
  var typeParameters = classInfo.cls?.typeParameters.map((e) => "typename ${e.name}");
  if (typeParameters?.isNotEmpty ?? false) {
    print("template<${typeParameters!.join(",")}>");
  }

  // Print class declaration with inheritance
  var className = classInfo.cls!.name.replaceAll("&", r"$");
  var superClassName = classInfo.superInfo == null ? "Object" : 
                    classInfo.superInfo!.cls?.name.replaceAll("&", r"$") ?? "Object";
  print("class $className : public $superClassName {");
  print("public:");

  // Print fields
  for (var field in classInfo.cls!.fields) {
    var fieldType = printer.displayType(field.type);
    var fieldName = field.name.text.replaceAll("#", r"$");
    print("  $fieldType $fieldName;");
  }

  // Print constructors
    for (var constructor in classInfo.cls!.constructors) {
      var parameters = [
        ...constructor.function.positionalParameters.map(
          (parameter) => "${printer.displayType(parameter.type)} ${parameter.name}"),
        ...constructor.function.namedParameters.map(
          (parameter) => "${printer.displayType(parameter.type)} ${parameter.name}")
    ];
    
    print("  static $className* ${printer.getFunctionName(constructor.name.text)}(${parameters.join(", ")});");
  }

  // Print methods
  for (var procedure in classInfo.cls!.procedures) {
    var methodName = printer.getMethodName(procedure);
    var returnType = printer.displayType(procedure.function.returnType);
    var parameters = [
      ...procedure.function.positionalParameters.map(
          (parameter) => "${printer.displayType(parameter.type)} ${parameter.name}"),
      ...procedure.function.namedParameters.map(
          (parameter) => "${printer.displayType(parameter.type)} ${parameter.name}")
    ];

    var staticPrefix = procedure.isStatic ? "static " : "";
    var virtualPrefix = !procedure.isStatic ? "virtual " : "";
    
    print("  $staticPrefix$virtualPrefix$returnType $methodName(${parameters.join(", ")});");
    }

  print("};");
}

void printClassImplementation(ClassInfo classInfo) {
  var printer = MyAstPrinter();
  var className = classInfo.cls!.name.replaceAll("&", r"$");
  
  // Print constructor implementations
  for (var constructor in classInfo.cls!.constructors) {
  var parameters = [
      ...constructor.function.positionalParameters.map(
          (parameter) => "${printer.displayType(parameter.type)} ${parameter.name}"),
      ...constructor.function.namedParameters.map(
          (parameter) => "${printer.displayType(parameter.type)} ${parameter.name}")
    ];
    
    print("$className* $className::${printer.getFunctionName(constructor.name.text)}(${parameters.join(", ")}) {");
    print("  $className* obj = new $className();");
    
    // Initialize fields if constructor has a body
    if (constructor.function.body != null) {
      printer.writeStatement(constructor.function.body!);
      print("  ${printer.getText()}");
    }
    
    print("  return obj;");
    print("}");
    print("");
  }

  // Print method implementations
  for (var procedure in classInfo.cls!.procedures) {
    var methodName = printer.getMethodName(procedure);
    var returnType = printer.displayType(procedure.function.returnType);
    var parameters = [
      ...procedure.function.positionalParameters.map(
          (parameter) => "${printer.displayType(parameter.type)} ${parameter.name}"),
      ...procedure.function.namedParameters.map(
          (parameter) => "${printer.displayType(parameter.type)} ${parameter.name}")
    ];

    var staticPrefix = procedure.isStatic ? "static " : "";
    
    print("$returnType ${className}::$methodName(${parameters.join(", ")}) {");
    
    // Add method body if it exists
    if (procedure.function.body != null) {
      printer.writeStatement(procedure.function.body!);
      print("  ${printer.getText()}");
    } else {
      // Add default return statement if needed
      if (returnType != "void") {
        if (returnType == "int" || returnType == "double") {
          print("  return 0;");
        } else if (returnType == "bool") {
          print("  return false;");
        } else if (returnType.endsWith("*")) {
          print("  return nullptr;");
        }
      }
    }
    
    print("}");
    print("");
    }
}

class MyAstPrinter {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;
  
  String getText() {
    return _buffer.toString();
  }

  void write(String text) {
    _buffer.write(text);
  }

  void writeNewline() {
    _buffer.write('\n');
    _buffer.write('  ' * _indentLevel);
  }

  void indent() {
    _indentLevel++;
  }

  void unindent() {
    _indentLevel--;
  }

  String logicalExpressionOperatorToString(LogicalExpressionOperator operator) {
    switch (operator) {
      case LogicalExpressionOperator.AND:
        return "&&";
      case LogicalExpressionOperator.OR:
        return "||";
    }
  }

  String getFunctionName(String name) {
    return name.replaceAll('.', '_');
  }

  String getMethodName(Member member) {
    return member.name.text;
  }

  String displayType(DartType type) {
    if (type is InterfaceType) {
      return type.classNode.name;
    } else if (type is FunctionType) {
      return "Function";
    } else if (type is DynamicType) {
      return "dynamic";
    } else if (type is VoidType) {
      return "void";
    } else if (type is TypeParameterType) {
      return "Never";
    } else if (type is NullType) {
      return "Null";
    } else {
      return "dynamic";
    }
  }

  void writeVariableDeclaration(VariableDeclaration variable) {
    write('var ');
    write(variable.name ?? '');
    if (variable.initializer != null) {
      write(' = ');
      writeExpression(variable.initializer!);
    }
  }

  void writeStatement(Statement statement) {
    if (statement is Block) {
      write('{');
      indent();
      for (var stmt in statement.statements) {
        writeStatement(stmt);
      }
      unindent();
      write('}');
    } else if (statement is SwitchStatement) {
      write('switch (');
      writeExpression(statement.expression);
      write(') {');
      indent();
      for (var switchCase in statement.cases) {
        if (switchCase.isDefault) {
          write('default: {');
        } else {
          write('case ');
          writeExpression(switchCase.expressions.first);
          write(': {');
        }
        indent();
        if (switchCase.body is Block) {
          Block block = switchCase.body as Block;
          for (var stmt in block.statements) {
            writeStatement(stmt);
          }
        } else {
          writeStatement(switchCase.body);
        }
        unindent();
        write('}');
      }
      unindent();
      write('}');
    } else if (statement is LabeledStatement) {
      // Skip label for now
      writeStatement(statement.body);
    } else if (statement is ExpressionStatement) {
      writeExpression(statement.expression);
      write(';');
    } else if (statement is ReturnStatement) {
      write('return');
      if (statement.expression != null) {
        write(' ');
        writeExpression(statement.expression!);
      }
      write(';');
    } else if (statement is IfStatement) {
      write('if (');
      writeExpression(statement.condition);
      write(') ');
      writeStatement(statement.then);
      if (statement.otherwise != null) {
        write(' else ');
        writeStatement(statement.otherwise!);
      }
    } else if (statement is BreakStatement) {
      write('break');
      write(';');
    } else if (statement is VariableDeclaration) {
      write('var ');
      write(statement.name ?? '');
      if (statement.initializer != null) {
        write(' = ');
        writeExpression(statement.initializer!);
      }
      write(';');
    }
  }

  void writeExpression(Expression expression) {
    if (expression is ListLiteral) {
      write('[');
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write(']');
    } else if (expression is MapLiteral) {
      write('{');
      bool first = true;
      for (var entry in expression.entries) {
        if (!first) write(', ');
        first = false;
        writeExpression(entry.key);
        write(': ');
        writeExpression(entry.value);
      }
      write('}');
    } else if (expression is SetLiteral) {
      write('{');
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write('}');
    } else if (expression is LogicalExpression) {
      writeExpression(expression.left);
      write(' ');
      write(logicalExpressionOperatorToString(expression.operatorEnum));
      write(' ');
      writeExpression(expression.right);
    } else if (expression is IntLiteral) {
      write(expression.value.toString());
    } else if (expression is DoubleLiteral) {
      write(expression.value.toString());
    } else if (expression is StringLiteral) {
      write('"${expression.value}"');
    } else if (expression is BoolLiteral) {
      write(expression.value.toString());
    } else if (expression is NullLiteral) {
      write("nullptr");
    } else if (expression is VariableGet) {
      write(expression.variable.name ?? "");
    } else if (expression is ThisExpression) {
      write("this");
    } else if (expression is InstanceGet) {
      writeExpression(expression.receiver);
      write(".");
      write(expression.name.text);
    } else if (expression is InstanceSet) {
      writeExpression(expression.receiver);
      write(".");
      write(expression.name.text);
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is StaticInvocation) {
      write(expression.target.name.text);
      write("(");
      bool first = true;
      for (var argument in expression.arguments.positional) {
        if (!first) write(", ");
        first = false;
        writeExpression(argument);
      }
      write(")");
    } else if (expression is InstanceInvocation) {
      writeExpression(expression.receiver);
      write(".");
      write(expression.name.text);
      write("(");
      bool first = true;
      for (var argument in expression.arguments.positional) {
        if (!first) write(", ");
        first = false;
        writeExpression(argument);
      }
      write(")");
    }
  }

  String getLabelName(Statement statement) {
    return '';
  }
}


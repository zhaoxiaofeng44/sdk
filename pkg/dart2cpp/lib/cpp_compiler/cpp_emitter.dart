/// Dart→C++ 代码生成编排器
///
/// 管理 C++ 输出的全局状态：
/// - 输出缓冲区 (`_buf`)
/// - 缩进状态 (`_indent`)
/// - 延迟输出队列（闭包声明、前向声明）
/// - 驱动各 emitter（declaration / expression / statement / closure / constant）
library;

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

import 'type_mapper.dart';
import 'class_info_collector.dart';
import 'runtime_header_emitter.dart';
import 'declaration_emitter.dart';
import 'expression_emitter.dart';
import 'statement_emitter.dart';
import 'closure_emitter.dart';
import 'constant_emitter.dart';

/// C++ 代码生成编排器。
///
/// 调用顺序：
/// 1. `prepare()` — 设置 classInfo、typeMapper
/// 2. `emit(component)` — 生成完整 C++ 源码
class CppEmitter {
  /// 输出缓冲区
  final StringBuffer _buf = StringBuffer();

  /// 缩进级别
  int _indent = 0;

  /// 类型映射器（由 cpp_compiler 注入）
  late TypeMapper typeMapper;

  /// 类信息（由 cpp_compiler 注入）
  late ClassInfo classInfo;

  /// 子 emitter（在 prepare 后初始化）
  late DeclarationEmitter declarationEmitter;
  late ExpressionEmitter expressionEmitter;
  late StatementEmitter statementEmitter;
  late ClosureEmitter closureEmitter;
  late ConstantEmitter constantEmitter;

  /// 待输出的闭包声明（struct + _new + 前向声明，延迟到末尾）
  final List<String> _pendingClosureDecls = [];

  /// 待输出的闭包 _call 函数体（延迟到末尾，在闭包声明之后输出）
  final List<String> _pendingClosureCallBodies = [];

  /// 待输出的前向声明
  final List<String> _pendingForwardDecls = [];

  /// 已收集的 Value struct 名称（用于前向声明）
  final List<String> _valueStructNames = [];

  /// 已收集的静态函数前向声明
  final List<String> _staticFuncDecls = [];

  /// 当前正在处理的类（null 表示在顶层）
  Class? currentClass;

  /// 是否在 async 函数体内
  bool insideAsyncFunction = false;

  /// 当前 async 函数的 Promise 内部返回类型
  String asyncInnerReturnType = 'AnyPtr';

  /// 当前闭包体内，被捕获变量 → env 前缀
  final Map<VariableDeclaration, String> capturedVarEnvPrefix = {};

  /// 当前闭包体内，this 是否被捕获到 env 中
  bool thisIsCapturedInEnv = false;

  /// 需要 Box 化的变量声明集合
  final Set<VariableDeclaration> boxedVars = {};

  /// 当前函数的参数列表（用于判断变量是否是参数）
  final List<VariableDeclaration> currentFunctionParams = [];

  /// 全局闭包计数器
  int closureCounter = 0;

  /// 当前上下文名称栈（用于闭包命名）
  final List<String> closureContextStack = [];

  /// 变量计数器（生成临时变量名）
  int varCounter = 0;

  /// 是否在实例方法体内（用于 this → this_ 转换）
  bool insideMethodBody = false;

  /// 是否在静态/顶层字段初始化上下文中
  bool isStaticFieldContext = false;

  /// this 的替换名称
  String thisReplacementName = 'this_';

  // ============================================================================
  // 缩进管理 + 输出控制
  // ============================================================================

  /// 主输出缓冲区
  StringBuffer _activeBuf = StringBuffer();

  String get _pad => '    ' * _indent;

  /// 获取当前活跃缓冲区（可能是主缓冲区或临时缓冲区）
  StringBuffer get activeBuffer => _activeBuf;

  void indentMore() => _indent++;
  void indentLess() => _indent--;

  void writeLine([String line = '']) {
    if (line.isEmpty) {
      _activeBuf.writeln();
    } else {
      _activeBuf.writeln('$_pad$line');
    }
  }

  void write(String text) {
    _activeBuf.write(text);
  }

  /// 将输出切换到指定缓冲区（用于闭包_call函数体等需要延迟输出的场景）
  void writeToBuffer(StringBuffer buf) {
    _activeBuf = buf;
  }

  /// 将输出恢复到主缓冲区
  void restoreMainBuffer() {
    _activeBuf = _buf;
  }

  // ============================================================================
  // 准备阶段
  // ============================================================================

  /// 准备阶段：收集所有前向声明信息，初始化子 emitter
  void prepare(Component component, TypeMapper mapper, ClassInfo info) {
    typeMapper = mapper;
    classInfo = info;

    // 初始化子 emitter
    expressionEmitter = ExpressionEmitter(this, typeMapper, classInfo);
    statementEmitter = StatementEmitter(this, typeMapper, classInfo, expressionEmitter);
    declarationEmitter = DeclarationEmitter(this, typeMapper, classInfo);
    closureEmitter = ClosureEmitter(this, typeMapper, classInfo);
    constantEmitter = ConstantEmitter(typeMapper);

    // 收集所有 Value struct 名称
    for (final name in info.userClasses) {
      _valueStructNames.add('${name}Value');
    }

    // 收集所有静态函数前向声明（从类信息中推导）
    _collectAllStaticFuncDecls(component);
  }

  /// 收集所有需要前向声明的静态函数
  void _collectAllStaticFuncDecls(Component component) {
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;

      for (final cls in lib.classes) {
        // 跳过 mixin 声明（它们生成独立的静态函数）
        if (cls.isMixinDeclaration && !cls.name.contains('&')) {
          // mixin 静态函数前向声明
          final mixinName = cls.name;
          for (final proc in cls.procedures) {
            if (proc.isStatic || proc.isFactory) continue;
            final methodName = proc.name.text;
            String funcName;
            if (proc.isGetter) {
              funcName = '${mixinName}_get_$methodName';
            } else if (proc.isSetter) {
              funcName = '${mixinName}_set_$methodName';
            } else if (TypeMapper.isOperatorName(methodName)) {
              funcName = '${mixinName}_operator${TypeMapper.operatorCppSuffix(methodName)}';
            } else {
              funcName = '${mixinName}_$methodName';
            }
            final retType = typeMapper.cppType(proc.function.returnType);
            final params = _buildStaticFuncParamSignature(proc.function, includeThis: true);
            _staticFuncDecls.add('$retType $funcName($params)');
          }
          continue;
        }

        // enum 不需要前向声明
        if (_isEnumClass(cls)) continue;

        // 用户类
        final isSynthetic = cls.name.contains('&');
        final className = isSynthetic
            ? _sanitizeSyntheticName(cls.name)
            : cls.name;
        if (className.isEmpty) continue;

        // 构造函数 → _new 前向声明
        for (final ctor in cls.constructors) {
          String funcName;
          if (ctor.name.text.isEmpty) {
            funcName = '${className}_new';
          } else {
            funcName = '${className}_new_${typeMapper.cleanIdentifier(ctor.name.text)}';
          }
          final retType = '$className*';
          final positionalParams = ctor.function.positionalParameters;
          final requiredCount = ctor.function.requiredParameterCount;
          final namedParams = ctor.function.namedParameters;
          final paramParts = <String>['$className* this__'];
          for (var i = 0; i < requiredCount; i++) {
            paramParts.add('${typeMapper.cppType(positionalParams[i].type)} ${typeMapper.cleanIdentifier(positionalParams[i].name ?? "_p")}');
          }
          for (final p in namedParams) {
            paramParts.add('${typeMapper.cppType(p.type)} ${typeMapper.cleanIdentifier(p.name ?? "_p")}');
          }
          _staticFuncDecls.add('$retType $funcName(${paramParts.join(", ")})');
        }

        // 实例方法 → 静态函数前向声明
        for (final proc in cls.procedures) {
          if (proc.isStatic || proc.isFactory) continue;
          final methodName = proc.name.text;
          String funcName;
          if (proc.isGetter) {
            funcName = '${className}_get_$methodName';
          } else if (proc.isSetter) {
            funcName = '${className}_set_$methodName';
          } else if (TypeMapper.isOperatorName(methodName)) {
            funcName = '${className}_operator${TypeMapper.operatorCppSuffix(methodName)}';
          } else {
            funcName = '${className}_$methodName';
          }
          final retType = typeMapper.cppType(proc.function.returnType);
          final params = _buildStaticFuncParamSignature(proc.function, includeThis: true);
          _staticFuncDecls.add('$retType $funcName($params)');
        }

        // 委托函数前向声明（继承但未在当前类定义的方法）
        final vtableEntries = classInfo.classVTableEntries[className] ?? [];
        final definedMethods = cls.procedures
            .where((p) => !p.isStatic && !p.isFactory)
            .map((p) => p.name.text)
            .toSet();
        for (final entry in vtableEntries) {
          if (!definedMethods.contains(entry.name)) {
            String funcName;
            if (entry.kind == 'getter') {
              funcName = '${className}_get_${entry.name}';
            } else if (entry.kind == 'setter') {
              funcName = '${className}_set_${entry.name}';
            } else if (entry.kind == 'operator') {
              funcName = '${className}_operator${TypeMapper.operatorCppSuffix(entry.name)}';
            } else {
              funcName = '${className}_${entry.name}';
            }
            final params = ['AnyPtr this__',
              ...entry.cppParamTypes.asMap().entries.map((e) => '${e.value} _p${e.key}')
            ].join(', ');
            _staticFuncDecls.add('${entry.cppReturnType} $funcName($params)');
          }
        }
      }

      // 顶层函数前向声明
      for (final proc in lib.procedures) {
        if (proc.name.text == 'main') continue;
        final name = typeMapper.cleanIdentifier(proc.name.text);
        final retType = typeMapper.cppType(proc.function.returnType);
        final params = _buildStaticFuncParamSignature(proc.function, includeThis: false);
        _staticFuncDecls.add('$retType $name($params)');
      }
    }
  }

  /// 构建静态函数参数签名（用于前向声明）
  String _buildStaticFuncParamSignature(FunctionNode func, {bool includeThis = false}) {
    final parts = <String>[];
    if (includeThis) {
      parts.add('AnyPtr this__');
    }
    for (final p in func.positionalParameters) {
      parts.add('${typeMapper.cppType(p.type)} ${typeMapper.cleanIdentifier(p.name ?? "_p")}');
    }
    for (final p in func.namedParameters) {
      parts.add('${typeMapper.cppType(p.type)} ${typeMapper.cleanIdentifier(p.name ?? "_p")}');
    }
    return parts.join(', ');
  }

  bool _isEnumClass(Class cls) {
    if (cls.supertype == null) return false;
    return cls.supertype!.classNode.name == '_Enum' ||
        cls.supertype!.classNode.name == 'Enum';
  }

  String _sanitizeSyntheticName(String name) {
    var cleaned = name.startsWith('_') ? name.substring(1) : name;
    cleaned = cleaned.replaceAll('&', '_');
    return cleaned;
  }

  // ============================================================================
  // 主生成方法
  // ============================================================================

  /// 生成完整的 C++ 源码
  String emit(Component component) {
    _buf.clear();
    _indent = 0;
    _pendingClosureDecls.clear();
    _pendingForwardDecls.clear();
    _staticFuncDecls.clear();

    // 1. 运行时头文件 + 前向声明
    final headerEmitter = RuntimeHeaderEmitter();
    _buf.write(headerEmitter.emit(
      forwardDeclStructs: _valueStructNames,
      forwardDeclFunctions: _staticFuncDecls,
    ));

    // 2. 遍历所有用户库，生成声明
    Procedure? mainProc;
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;

      // 查找 main 函数
      for (final proc in lib.procedures) {
        if (proc.name.text == 'main') {
          mainProc = proc;
          break;
        }
      }

      // 生成该库的所有声明
      declarationEmitter.emitAll(lib);
    }

    // 3. 刷新延迟的闭包声明
    flushPendingDecls();

    // 4. 生成 main() 函数
    declarationEmitter.emitMain(mainProc);

    return _buf.toString();
  }

  // ============================================================================
  // 延迟输出管理
  // ============================================================================

  /// 添加闭包声明到延迟队列
  void addClosureDecl(String decl) {
    _pendingClosureDecls.add(decl);
  }

  /// 添加闭包 _call 函数体到延迟队列（在闭包声明之后输出）
  void addClosureCallBody(String body) {
    _pendingClosureCallBodies.add(body);
  }

  /// 添加静态函数前向声明
  void addStaticFuncDecl(String decl) {
    _staticFuncDecls.add(decl);
  }

  /// 获取新唯一变量名
  String freshVar([String prefix = '_v']) {
    return '$prefix${varCounter++}';
  }

  /// 获取新唯一闭包 ID
  int nextClosureId() => closureCounter++;

  /// 刷新延迟输出到缓冲区
  void flushPendingDecls() {
    if (_pendingClosureDecls.isNotEmpty) {
      writeLine();
      writeLine('// === ClosureEnv declarations ===');
      for (final decl in _pendingClosureDecls) {
        _buf.write(decl);
      }
      _pendingClosureDecls.clear();
    }
    if (_pendingClosureCallBodies.isNotEmpty) {
      writeLine();
      writeLine('// === ClosureEnv _call function bodies ===');
      for (final body in _pendingClosureCallBodies) {
        _buf.write(body);
      }
      _pendingClosureCallBodies.clear();
    }
  }
}

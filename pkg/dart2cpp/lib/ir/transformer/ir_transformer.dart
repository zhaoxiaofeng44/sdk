/// AST → IR 转换主控制器。
///
/// 编排各子转换器，将 Kernel Component 转为 IrProgram。
library ir_transformer;

import 'package:kernel/kernel.dart';
import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/shared.dart';
import 'type_transformer.dart';
import 'constant_transformer.dart';
import 'expression_transformer.dart';
import 'statement_transformer.dart';
import 'declaration_transformer.dart';
import 'closure_transformer.dart';

/// AST → IR 转换器。
class IrTransformer {
  final AnalysisContext ctx;

  late final TypeTransformer typeTransformer;
  late final ConstantTransformer constantTransformer;
  late final ExpressionTransformer expressionTransformer;
  late final StatementTransformer statementTransformer;
  late final DeclarationTransformer declarationTransformer;
  late final ClosureTransformer closureTransformer;

  /// 当前正在处理的类（`null` 表示顶层）。
  Class? currentClass;

  /// 当前类名。
  String? currentClassName;

  /// 是否在实例方法体内（`this` → `this_` 替换）。
  bool insideMethodBody = false;

  /// `this` 的替换名（方法体内为 `this_`，构造函数内为 `obj`）。
  String thisReplacementName = 'this_';

  /// 是否在 async 函数体内。
  bool insideAsyncFunction = false;

  /// async 函数的内部返回类型（`Future<T>` 中的 `T`）。
  IrType asyncInnerReturnType = const IrDynamicType();

  /// 闭包环境前缀（变量 → `env.` / `env->`）。
  Map<VariableDeclaration, String> capturedVarEnvPrefix = {};

  /// 是否 `this` 被捕获到闭包环境中。
  bool thisIsCapturedInEnv = false;

  /// 需要 Box 化的变量集合。
  Set<VariableDeclaration> boxedVars = {};

  /// 当前函数的参数列表。
  List<VariableDeclaration> currentFunctionParams = [];

  /// 当前函数的返回类型。
  IrType? currentFunctionReturnType;

  /// 当前本地函数名（用于处理递归调用）。
  String? currentLocalFunctionName;

  /// 当前正在处理的实例方法名（用于检测方法级递归调用）。
  String? currentMethodName;

  /// 当前方法所属的类名（用于检测方法级递归调用）。
  String? currentMethodClassName;

  /// 当前方法的方法级类型参数（用于递归调用时保留类型参数）。
  List<TypeParameter>? currentMethodTypeParams;

  /// 全局闭包计数器。
  int closureCounter = 0;

  /// 闭包上下文名称栈。
  List<String> closureContextStack = [];

  /// 变量计数器（生成临时变量名）。
  int varCounter = 0;

  /// 待输出的闭包类。
  List<IrClosureClass> pendingClosureDecls = [];

  /// 是否为静态字段上下文。
  bool isStaticFieldContext = false;

  IrTransformer(this.ctx) {
    typeTransformer = TypeTransformer(ctx);
    constantTransformer = ConstantTransformer(this);
    expressionTransformer = ExpressionTransformer(this);
    statementTransformer = StatementTransformer(this);
    declarationTransformer = DeclarationTransformer(this);
    closureTransformer = ClosureTransformer(this);
  }

  /// 将 Kernel Component 转为 IrProgram。
  IrProgram transform(Component component) {
    final libraries = <IrLibrary>[];

    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      libraries.add(_transformLibrary(lib));
    }

    return IrProgram(libraries);
  }

  /// 转换单个库。
  IrLibrary _transformLibrary(Library lib) {
    final typedefs = <IrTypedef>[];
    final mixins = <IrMixinFuncs>[];
    final declarations = <IrNode>[];
    final fields = <IrTopLevelField>[];
    IrStaticFunc? mainFunc;

    // 重置闭包队列
    pendingClosureDecls.clear();

    // typedef
    for (final td in lib.typedefs) {
      typedefs.add(declarationTransformer.transformTypedef(td));
    }

    // mixin 和 class
    for (final cls in lib.classes) {
      // 对于合成 mixin 中间类，需要检查清洗后的名称
      final checkName = cls.name.contains('&')
          ? _sanitizeSyntheticName(cls.name)
          : cls.name;

      if (ctx.isMixin(cls.name)) {
        mixins.add(declarationTransformer.transformMixin(cls));
      } else if (ctx.isEnum(cls.name)) {
        declarations.add(declarationTransformer.transformEnum(cls));
      } else if (ctx.isUserClass(checkName)) {
        declarations.addAll(declarationTransformer.transformClass(cls));
      }
    }

    // 顶层 procedure
    for (final proc in lib.procedures) {
      if (proc.name.text == 'main') {
        mainFunc = declarationTransformer.transformTopLevelProcedure(proc);
      } else {
        declarations.add(
            declarationTransformer.transformTopLevelProcedure(proc));
      }
    }

    // 顶层 field
    for (final field in lib.fields) {
      fields.add(declarationTransformer.transformTopLevelField(field));
    }

    return IrLibrary(
      name: lib.importUri.toString(),
      typedefs: typedefs,
      mixins: mixins,
      declarations: declarations,
      fields: fields,
      pendingClosures: List.from(pendingClosureDecls),
      mainFunc: mainFunc,
    );
  }

  /// 生成唯一闭包名。
  String freshClosureId() {
    return '${closureCounter++}';
  }

  /// 生成唯一临时变量名。
  String freshVarName([String prefix = 'tmp']) {
    return '${prefix}_${varCounter++}';
  }

  /// 获取当前闭包上下文名。
  String get closureContext =>
      closureContextStack.isNotEmpty ? closureContextStack.last : 'global';

  /// 清洗合成中间类名：去掉前导 `_`，`&` → `_`。
  static String _sanitizeSyntheticName(String name) {
    var result = name;
    if (result.startsWith('_')) result = result.substring(1);
    return result.replaceAll('&', '_');
  }
}

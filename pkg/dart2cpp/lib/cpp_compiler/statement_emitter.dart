/// Dart→C++ 语句生成器
///
/// 将 Dart Kernel Statement 节点转换为 C++ 语句字符串。
/// 核心转换：
/// - Block → { ... }
/// - VariableDeclaration → 类型声明 + 初始化
/// - ReturnStatement → return（async 体改写为 _promise.complete）
/// - IfStatement / ForStatement / WhileStatement → 对应 C++ 控制流
/// - TryCatch → try/catch（C++ 异常）
/// - SwitchStatement → switch/case
///
/// 镜像 `lib/restorer/statement_restorer.dart`。
library;

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

import 'type_mapper.dart';
import 'class_info_collector.dart';
import 'cpp_emitter.dart';
import 'expression_emitter.dart';

/// C++ 语句生成器。
class StatementEmitter {
  final CppEmitter emitter;
  final TypeMapper typeMapper;
  final ClassInfo classInfo;
  final ExpressionEmitter exprEmitter;

  StatementEmitter(this.emitter, this.typeMapper, this.classInfo, this.exprEmitter);

  // ============================================================================
  // 主入口
  // ============================================================================

  /// 将 Statement 转换为 C++ 语句（写入 emitter 的输出缓冲区）
  void emit(Statement stmt) {
    if (stmt is Block) _emitBlock(stmt);
    else if (stmt is ExpressionStatement) _emitExpressionStatement(stmt);
    else if (stmt is ReturnStatement) _emitReturnStatement(stmt);
    else if (stmt is VariableDeclaration) _emitVariableDeclaration(stmt);
    else if (stmt is IfStatement) _emitIfStatement(stmt);
    else if (stmt is ForStatement) _emitForStatement(stmt);
    else if (stmt is ForInStatement) _emitForInStatement(stmt);
    else if (stmt is WhileStatement) _emitWhileStatement(stmt);
    else if (stmt is DoStatement) _emitDoStatement(stmt);
    else if (stmt is TryCatch) _emitTryCatch(stmt);
    else if (stmt is TryFinally) _emitTryFinally(stmt);
    else if (stmt is SwitchStatement) _emitSwitchStatement(stmt);
    else if (stmt is BreakStatement) _emitBreakStatement(stmt);
    else if (stmt is AssertStatement) _emitAssertStatement(stmt);
    else if (stmt is LabeledStatement) _emitLabeledStatement(stmt);
    else if (stmt is YieldStatement) _emitYieldStatement(stmt);
    else if (stmt is FunctionDeclaration) _emitFunctionDeclaration(stmt);
    else {
      // 未识别的语句类型：输出为注释以便调试
      emitter.writeLine('/* unhandled statement: ${stmt.runtimeType} */');
    }
  }

  // ============================================================================
  // Block
  // ============================================================================

  void _emitBlock(Block stmt) {
    emitter.writeLine('{');
    emitter.indentMore();
    for (final s in stmt.statements) {
      emit(s);
    }
    emitter.indentLess();
    emitter.writeLine('}');
  }

  // ============================================================================
  // ExpressionStatement
  // ============================================================================

  void _emitExpressionStatement(ExpressionStatement stmt) {
    // 过滤 ReachabilityError throw（Kernel 生成的不可达标记）
    if (stmt.expression is Throw) {
      final thrown = (stmt.expression as Throw).expression;
      if (thrown is StaticInvocation) {
        final target = thrown.target;
        if (target.name.text == '_throwRangeError') {
          return;
        }
      }
    }
    final expr = exprEmitter.emit(stmt.expression);
    emitter.writeLine('$expr;');
  }

  // ============================================================================
  // ReturnStatement
  // ============================================================================

  void _emitReturnStatement(ReturnStatement stmt) {
    if (emitter.insideAsyncFunction) {
      // async 体：return expr → env->_promise->complete(value); return;
      if (stmt.expression != null) {
        final value = exprEmitter.emit(stmt.expression!);
        emitter.writeLine('env->_promise->complete(AnyPtr::fromAuto($value));');
      } else {
        emitter.writeLine('env->_promise->complete(AnyPtr());');
      }
      emitter.writeLine('return;');
    } else {
      if (stmt.expression != null) {
        final value = exprEmitter.emit(stmt.expression!);
        emitter.writeLine('return $value;');
      } else {
        emitter.writeLine('return;');
      }
    }
  }

  // ============================================================================
  // VariableDeclaration
  // ============================================================================

  void _emitVariableDeclaration(VariableDeclaration stmt) {
    final name = typeMapper.cleanIdentifier(stmt.name ?? '_v');
    final cppType = typeMapper.cppType(stmt.type);

    // Box 化变量
    if (emitter.boxedVars.contains(stmt)) {
      final boxType = typeMapper.boxTypeNameFor(stmt.type);
      if (boxType != null) {
        if (stmt.initializer != null) {
          final init = exprEmitter.emit(stmt.initializer!);
          emitter.writeLine(
              'auto $name = GC::allocateLocal(new $boxType($init));');
        } else {
          final defaultVal = typeMapper.defaultValueForType(stmt.type);
          emitter.writeLine(
              'auto $name = GC::allocateLocal(new $boxType($defaultVal));');
        }
        return;
      }
    }

    if (stmt.initializer != null) {
      final init = exprEmitter.emit(stmt.initializer!);
      if (stmt.isFinal || stmt.isConst) {
        emitter.writeLine('const $cppType $name = $init;');
      } else {
        emitter.writeLine('$cppType $name = $init;');
      }
    } else {
      if (stmt.isFinal || stmt.isConst) {
        emitter.writeLine('const $cppType $name{};');
      } else {
        emitter.writeLine('$cppType $name{};');
      }
    }
  }

  // ============================================================================
  // IfStatement
  // ============================================================================

  void _emitIfStatement(IfStatement stmt) {
    final cond = exprEmitter.emit(stmt.condition);
    emitter.writeLine('if ($cond) {');
    emitter.indentMore();
    _emitStatementBody(stmt.then);
    emitter.indentLess();
    if (stmt.otherwise != null && stmt.otherwise is! Block) {
      emitter.writeLine('} else {');
      emitter.indentMore();
      _emitStatementBody(stmt.otherwise!);
      emitter.indentLess();
    } else if (stmt.otherwise != null) {
      emitter.writeLine('} else {');
      emitter.indentMore();
      emit(stmt.otherwise!);
      emitter.indentLess();
    }
    emitter.writeLine('}');
  }

  // ============================================================================
  // ForStatement
  // ============================================================================

  void _emitForStatement(ForStatement stmt) {
    // 变量声明
    final varDecls = <String>[];
    for (final v in stmt.variables) {
      final name = typeMapper.cleanIdentifier(v.name ?? '_v');
      final cppType = typeMapper.cppType(v.type);
      if (v.initializer != null) {
        final init = exprEmitter.emit(v.initializer!);
        varDecls.add('$cppType $name = $init');
      } else {
        varDecls.add('$cppType $name');
      }
    }

    final initStr = varDecls.join(', ');
    final condStr = stmt.condition != null ? exprEmitter.emit(stmt.condition!) : '';
    final updateStr = stmt.updates.map((u) => exprEmitter.emit(u)).join(', ');

    emitter.writeLine('for ($initStr; $condStr; $updateStr) {');
    emitter.indentMore();
    _emitStatementBody(stmt.body);
    emitter.indentLess();
    emitter.writeLine('}');
  }

  // ============================================================================
  // ForInStatement
  // ============================================================================

  void _emitForInStatement(ForInStatement stmt) {
    final varName = typeMapper.cleanIdentifier(stmt.variable.name ?? '_v');
    final iterable = exprEmitter.emit(stmt.iterable);
    final iterVar = emitter.freshVar('_iter');

    emitter.writeLine('{');
    emitter.indentMore();
    emitter.writeLine('auto* $iterVar = $iterable->iterator();');
    emitter.writeLine('while ($iterVar->moveNext()) {');
    emitter.indentMore();
    emitter.writeLine('auto $varName = $iterVar->current();');
    _emitStatementBody(stmt.body);
    emitter.indentLess();
    emitter.writeLine('}');
    emitter.indentLess();
    emitter.writeLine('}');
  }

  // ============================================================================
  // WhileStatement / DoStatement
  // ============================================================================

  void _emitWhileStatement(WhileStatement stmt) {
    final cond = exprEmitter.emit(stmt.condition);
    emitter.writeLine('while ($cond) {');
    emitter.indentMore();
    _emitStatementBody(stmt.body);
    emitter.indentLess();
    emitter.writeLine('}');
  }

  void _emitDoStatement(DoStatement stmt) {
    emitter.writeLine('do {');
    emitter.indentMore();
    _emitStatementBody(stmt.body);
    emitter.indentLess();
    final cond = exprEmitter.emit(stmt.condition);
    emitter.writeLine('} while ($cond);');
  }

  // ============================================================================
  // TryCatch / TryFinally
  // ============================================================================

  void _emitTryCatch(TryCatch stmt) {
    emitter.writeLine('try {');
    emitter.indentMore();
    _emitStatementBody(stmt.body);
    emitter.indentLess();
    for (final c in stmt.catches) {
      final cppType = typeMapper.cppType(c.guard);
      final varName = c.exception != null
          ? typeMapper.cleanIdentifier(c.exception!.name ?? 'e')
          : '_e';
      emitter.writeLine('} catch (const $cppType& $varName) {');
      emitter.indentMore();
      _emitStatementBody(c.body);
      emitter.indentLess();
    }
    emitter.writeLine('}');
  }

  void _emitTryFinally(TryFinally stmt) {
    // C++ 没有 Dart 的 finally 语义（finally 总会执行，即使有异常）
    // 用 RAII guard 模式模拟：定义一个局部 struct，析构函数执行 finally 代码
    final guardVar = '__finally_guard_${stmt.hashCode.abs() % 10000}';
    if (stmt.body is TryCatch) {
      // 合并 try-catch-finally：try-catch 嵌套在 guard 内
      emitter.writeLine('struct ${guardVar}_t {');
      emitter.indentMore();
      emitter.writeLine('~${guardVar}_t() {');
      emitter.indentMore();
      _emitStatementBody(stmt.finalizer);
      emitter.indentLess();
      emitter.writeLine('}');
      emitter.indentLess();
      emitter.writeLine('} ${guardVar};');
      _emitTryCatch(stmt.body as TryCatch);
    } else {
      emitter.writeLine('struct ${guardVar}_t {');
      emitter.indentMore();
      emitter.writeLine('~${guardVar}_t() {');
      emitter.indentMore();
      _emitStatementBody(stmt.finalizer);
      emitter.indentLess();
      emitter.writeLine('}');
      emitter.indentLess();
      emitter.writeLine('} ${guardVar};');
      emitter.writeLine('try {');
      emitter.indentMore();
      _emitStatementBody(stmt.body);
      emitter.indentLess();
      emitter.writeLine('}');
      // catch(...) 确保异常也不会跳过 finally guard 析构
      emitter.writeLine('catch (...) { throw; }');
    }
  }

  // ============================================================================
  // SwitchStatement
  // ============================================================================

  void _emitSwitchStatement(SwitchStatement stmt) {
    final expr = exprEmitter.emit(stmt.expression);
    emitter.writeLine('switch ($expr) {');
    emitter.indentMore();
    for (final c in stmt.cases) {
      if (c.isDefault) {
        emitter.writeLine('default: {');
      } else {
        // 输出所有 case 值
        for (final e in c.expressions) {
          emitter.writeLine('case ${exprEmitter.emit(e)}:');
        }
        emitter.writeLine('{');
      }
      emitter.indentMore();
      _emitStatementBody(c.body);
      emitter.indentLess();
      emitter.writeLine('}');
    }
    emitter.indentLess();
    emitter.writeLine('}');
  }

  // ============================================================================
  // Break / Continue
  // ============================================================================

  void _emitBreakStatement(BreakStatement stmt) {
    emitter.writeLine('break;');
  }

  // ============================================================================
  // Assert
  // ============================================================================

  void _emitAssertStatement(AssertStatement stmt) {
    final cond = exprEmitter.emit(stmt.condition);
    if (stmt.message != null) {
      final msg = exprEmitter.emit(stmt.message!);
      emitter.writeLine('assert(($cond) && $msg);');
    } else {
      emitter.writeLine('assert($cond);');
    }
  }

  // ============================================================================
  // Labeled / Yield / FunctionDeclaration
  // ============================================================================

  void _emitLabeledStatement(LabeledStatement stmt) {
    // C++ 不支持 labeled break/continue，直接输出 body
    _emitStatementBody(stmt.body);
  }

  void _emitYieldStatement(YieldStatement stmt) {
    // sync* 的 yield 需要状态机实现（类似C++20 coroutine），
    // 当前C++运行时不支持co_yield，暂时将yield语句注释输出，
    // 需要状态机转换（参考Restorer的generator lowering）才能完整支持
    final value = exprEmitter.emit(stmt.expression);
    emitter.writeLine('// yield $value;');
  }

  void _emitFunctionDeclaration(FunctionDeclaration stmt) {
    final name = typeMapper.cleanIdentifier(stmt.variable.name ?? '_fn');
    final func = stmt.function;
    final retType = typeMapper.cppType(func.returnType);
    final params = func.positionalParameters.map((p) {
      final cppType = typeMapper.cppType(p.type);
      final pName = typeMapper.cleanIdentifier(p.name ?? '_p');
      return '$cppType $pName';
    }).join(', ');

    emitter.writeLine('auto $name = [&]($params) -> $retType {');
    emitter.indentMore();
    if (func.body != null) {
      emit(func.body!);
    }
    emitter.indentLess();
    emitter.writeLine('};');
  }

  // ============================================================================
  // 辅助方法
  // ============================================================================

  void _emitStatementBody(Statement stmt) {
    if (stmt is Block) {
      for (final s in stmt.statements) {
        emit(s);
      }
    } else {
      emit(stmt);
    }
  }
}

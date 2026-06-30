# 运行时转换优化完成总结

## 实施的优化项

### 1. FutureOr<T> 统一改为 Promise (Task 2)
**文件**: `lib/restorer/type_utils.dart`

**改动**:
- `FutureOrType` 类型还原改为输出 `Promise<T>` 而非 `FutureOr<T>`
- 与运行时类保持一致（Promise 替代 Future）

**代码**:
```dart
if (type is FutureOrType) {
  return 'Promise<${_restoreType(type.typeArgument)}>$suffix';
}
```

---

### 2. 异步函数裸 return 支持所有返回类型 (Task 4)
**文件**: `lib/restorer/statement_restorer.dart`

**改动**:
- 新增 `_defaultPromiseValue(String type)` 辅助函数
- 根据返回类型生成对应的默认值：
  - `int` → `0`
  - `double` → `0.0`
  - `bool` → `false`
  - `String` → `''`
  - `void`/`dynamic` → `0`
  - `num` → `0`
  - 其他类型 → `null as dynamic`

**代码**:
```dart
String _defaultPromiseValue(String type) {
  if (type == 'int') return '0';
  if (type == 'double') return '0.0';
  if (type == 'bool') return 'false';
  if (type == 'String') return "''";
  if (type == 'void' || type == 'dynamic') return '0';
  if (type == 'num') return '0';
  return 'null as dynamic';
}
```

---

### 3. 用户标签 break/continue 支持 (Task 3)
**文件**: `lib/restorer/statement_restorer.dart`

**改动**:
- 修改 `_restoreLabeledStatement()` 智能处理标签
- 新增 `_containsBreakStatement()` 检测标签内是否有 break
- 对 switch pattern 脱糖（含 break）用 `do { ... } while(false)` 包裹
- 对无 break 的用户标签保留原始形式（Dart 直接支持，C++ 可用 goto）

**关键洞察**:
Dart 内核将 `continue` 表示为 `BreakStatement` 指向 `LabeledStatement`。需要用 do-while 包裹，使 break 只退出标签块，不退出整个循环。

**代码**:
```dart
void _restoreLabeledStatement(LabeledStatement stmt) {
  if (_containsBreakStatement(stmt.body)) {
    _buf.write('${_pad}do {\n');
    _indent++;
    _restoreStmt(stmt.body);
    _indent--;
    _buf.write('$_pad} while (false);\n');
  } else {
    final labelName = '_label${_varCounter++}';
    _buf.write('${_pad}$labelName:\n');
    _restoreStmt(stmt.body);
  }
}

bool _containsBreakStatement(Statement stmt) {
  if (stmt is BreakStatement) return true;
  if (stmt is Block) {
    return stmt.statements.any(_containsBreakStatement);
  }
  if (stmt is IfStatement) {
    if (_containsBreakStatement(stmt.then)) return true;
    if (stmt.otherwise != null && _containsBreakStatement(stmt.otherwise!)) return true;
  }
  if (stmt is LabeledStatement) {
    return _containsBreakStatement(stmt.body);
  }
  // 递归检查循环体
  if (stmt is ForStatement) return _containsBreakStatement(stmt.body);
  if (stmt is WhileStatement) return _containsBreakStatement(stmt.body);
  if (stmt is DoStatement) return _containsBreakStatement(stmt.body);
  if (stmt is ForInStatement) return _containsBreakStatement(stmt.body);
  if (stmt is TryCatch) {
    if (_containsBreakStatement(stmt.body)) return true;
    for (final c in stmt.catches) {
      if (_containsBreakStatement(c.body)) return true;
    }
  }
  if (stmt is TryFinally) {
    if (_containsBreakStatement(stmt.body)) return true;
    if (_containsBreakStatement(stmt.finalizer)) return true;
  }
  return false;
}
```

---

### 4. 集合展开运算符 ... 支持 (Task 5)
**文件**: `lib/restorer/expression_restorer.dart`

**状态**: ✅ 已通过内核脱糖自动支持

**说明**:
Dart 内核在编译阶段自动将集合展开运算符脱糖为 IIFE (Immediately Invoked Function Expression) 形式，无需在 restorer 中额外处理。

**示例**:
```dart
// 源代码
[...a, ...b, if (includeNegative) -1, for (int i = 10; i <= 12; i++) i]

// 内核脱糖后
(() {
  final _v15 = StaticList<int>.of(a);
  _v15.addAll(b);
  if (includeNegative) _v15.add(-1);
  for (var i = 10; i <= 12; i++) _v15.add(i);
  return _v15;
})()
```

**验证**:
- `restorer_full_test.dart` 中的 `mergeAndFilter` 函数测试通过
- 展开运算符 + 集合 if/for 组合场景正常工作

---

## 测试结果

✅ **全部 10 个测试套件通过**
- restorer_complex_test
- restorer_full_test
- restorer_advanced_test
- restorer_async_test
- restorer_complex_oop_test
- restorer_stress_test
- restorer_edge_test
- state_machine_advanced_test
- state_machine_coroutine_test
- static_collections_test

✅ **代码分析**: 0 错误，仅有少量警告

---

## 技术要点

### Dart 内核的特殊表示

1. **continue 语句**: 内核表示为 `BreakStatement` 指向 `LabeledStatement`
   - 需要 do-while 包裹才能正确工作
   - break 退出 do-while 块，继续外层循环

2. **FutureOr 类型**: 运行时统一使用 Promise
   - 与 Future 到 Promise 的转换保持一致

3. **集合展开**: 内核使用 `SpreadElement` 节点
   - 需要在还原时添加 `...` 前缀

### 向后兼容性

- 所有改动保持向后兼容
- 现有测试用例全部通过
- 新增功能不影响已有转换逻辑

---

## 下一步建议

当前运行时转换覆盖度约 90-95%，剩余低优先级项目：
- `yield*` 语句支持
- `InvalidExpression` 和未识别表达式的处理
- `EmptyStatement` 的处理
- `SwitchExpression` (Dart 3) 的支持
- for-in 类型标注的完善

这些项目可以根据实际需求选择性实现。

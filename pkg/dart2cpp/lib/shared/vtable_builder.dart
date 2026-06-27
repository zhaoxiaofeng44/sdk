/// 虚表构建器 — 拓扑排序后为每个类构建虚表。
///
/// 合并自：
/// - `restorer/dart_restorer.dart` 的 `_collectVTableEntries`
/// - `cpp_compiler/class_info_collector.dart` 的 `_collectVTableEntries`
///
/// 两套代码逻辑完全相同（85%+ 共享），此处为唯一权威实现。
library vtable_builder;

import 'package:kernel/kernel.dart';
import 'analysis_context.dart';
import 'operator_names.dart';

/// 虚表构建器。
///
/// 依赖 [ClassInfoCollector] 先完成类信息收集。
/// 按拓扑排序（父→子）为每个类构建虚表。
class VTableBuilder {
  final AnalysisContext ctx;

  VTableBuilder(this.ctx);

  /// 构建所有用户类的虚表。
  void build() {
    final entries = _collectUserClassEntries();
    final sorted = _topologicalSort(entries);

    for (final (className, cls) in sorted) {
      _buildVTableForClass(cls, className);
    }
  }

  /// 收集所有用户类（含合成中间类）的 (name, Class) 对。
  List<(String, Class)> _collectUserClassEntries() {
    final result = <(String, Class)>[];
    for (final entry in ctx.classNodes.entries) {
      final name = entry.key;
      final cls = entry.value;
      if (ctx.userClasses.contains(name)) {
        result.add((name, cls));
      }
    }
    return result;
  }

  /// 拓扑排序：确保父类在子类之前处理。
  List<(String, Class)> _topologicalSort(List<(String, Class)> entries) {
    final byName = <String, Class>{for (final (n, c) in entries) n: c};
    final visited = <String>{};
    final result = <(String, Class)>[];

    void visit(String name) {
      if (visited.contains(name)) return;
      visited.add(name);
      final parent = ctx.classHierarchy[name];
      if (parent != null && byName.containsKey(parent)) {
        visit(parent);
      }
      final cls = byName[name];
      if (cls != null) {
        result.add((name, cls));
      }
    }

    for (final (name, _) in entries) {
      visit(name);
    }
    return result;
  }

  /// 为单个类构建虚表。
  void _buildVTableForClass(Class cls, String className) {
    final entries = <VTableEntry>[];

    // 1. 继承父类的虚表条目
    final parentName = ctx.classHierarchy[className];
    if (parentName != null && ctx.classVTableEntries.containsKey(parentName)) {
      entries.addAll(ctx.classVTableEntries[parentName]!);
    }

    // 2. 合并 implements 接口中的方法
    for (final impl in cls.implementedTypes) {
      final ifaceName = impl.classNode.name;
      if (ctx.classVTableEntries.containsKey(ifaceName)) {
        for (final ifaceEntry in ctx.classVTableEntries[ifaceName]!) {
          final alreadyExists = entries
              .any((e) => e.name == ifaceEntry.name && e.kind == ifaceEntry.kind);
          if (!alreadyExists) {
            entries.add(VTableEntry(
              name: ifaceEntry.name,
              kind: ifaceEntry.kind,
              staticFuncName: ifaceEntry.staticFuncName,
              declaringClassName: ifaceEntry.declaringClassName,
            ));
          }
        }
      }
    }

    // 3. 收集本类自身的方法
    for (final proc in cls.procedures) {
      if (proc.isStatic) continue;
      if (proc.isFactory) continue;
      if (proc.name.text.startsWith('_')) continue;

      final methodName = proc.name.text;
      final entry = _buildEntry(cls, proc, methodName, className);

      final existingIdx = entries
          .indexWhere((e) => e.name == methodName && e.kind == entry.kind);
      if (existingIdx >= 0) {
        // 重载：保留首次声明类的 declaringClassName
        final existingDeclaringClass =
            entries[existingIdx].declaringClassName ?? className;
        entries[existingIdx] = VTableEntry(
          name: entry.name,
          kind: entry.kind,
          staticFuncName: entry.staticFuncName,
          proc: entry.proc,
          declaringClassName: existingDeclaringClass,
        );
      } else {
        entries.add(VTableEntry(
          name: entry.name,
          kind: entry.kind,
          staticFuncName: entry.staticFuncName,
          proc: entry.proc,
          declaringClassName: className,
        ));
      }
    }

    // 4. 收集本类自身的字段，为隐式 getter/setter 创建虚表条目
    // 当字段覆盖了父类的抽象 getter/setter 时，需要更新虚表条目
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      final fieldName = field.name.text;

      // 为 getter 创建或更新虚表条目
      final getterIdx = entries.indexWhere(
        (e) => e.name == fieldName && e.kind == VTableEntryKind.getter,
      );
      if (getterIdx >= 0) {
        // 字段覆盖了父类的 getter，更新虚表条目
        final existingDeclaringClass =
            entries[getterIdx].declaringClassName ?? className;
        entries[getterIdx] = VTableEntry(
          name: fieldName,
          kind: VTableEntryKind.getter,
          staticFuncName: '${className}_get_$fieldName',
          declaringClassName: existingDeclaringClass,
        );
      }

      // 为 setter 创建或更新虚表条目（如果字段不是 final）
      if (!field.isFinal) {
        final setterIdx = entries.indexWhere(
          (e) => e.name == fieldName && e.kind == VTableEntryKind.setter,
        );
        if (setterIdx >= 0) {
          final existingDeclaringClass =
              entries[setterIdx].declaringClassName ?? className;
          entries[setterIdx] = VTableEntry(
            name: fieldName,
            kind: VTableEntryKind.setter,
            staticFuncName: '${className}_set_$fieldName',
            declaringClassName: existingDeclaringClass,
          );
        }
      }
    }

    ctx.classVTableEntries[className] = entries;
  }

  /// 从 Procedure 构建单个虚表条目。
  VTableEntry _buildEntry(
      Class cls, Procedure proc, String methodName, String className) {
    final kind = _inferKind(proc, methodName);
    final suffix = OperatorNames.staticFuncSuffix(methodName, kind);
    return VTableEntry(
      name: methodName,
      kind: kind,
      staticFuncName: '${className}_$suffix',
      proc: proc,
      declaringClassName: className,
    );
  }

  /// 推断虚表条目类型。
  static VTableEntryKind _inferKind(Procedure proc, String methodName) {
    if (proc.isGetter) return VTableEntryKind.getter;
    if (proc.isSetter) return VTableEntryKind.setter;
    if (OperatorNames.isOperator(methodName)) return VTableEntryKind.operator_;
    return VTableEntryKind.method;
  }
}

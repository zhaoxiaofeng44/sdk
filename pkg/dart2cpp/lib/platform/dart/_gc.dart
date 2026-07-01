/// AnyGC 基类 + GC 全局标记-清除垃圾回收器
///
/// 所有需要 GC 管理的类型（VPtr / Box / TypeFunction / 集合 / Promise）的公共基类。
/// 对象分配统一通过 GC.allocateLocal / GC.allocateGlobal 包装。

// ============================================================================
// AnyGC 基类
// ============================================================================

abstract class AnyGC {
  /// GC 标记位。每轮 GC 使用递增的 flag 值，被标记的对象 gcFlag == 当前 flag，
  /// 未被标记的对象 gcFlag < 当前 flag，即为垃圾。
  /// 使用公开字段以便跨 library 的 restored 代码子类可以访问。
  int gcFlag = 0;

  /// 标记当前对象为存活。子类覆写时应先调用 super，再递归标记子对象。
  /// [flag] 是本轮 GC 的标记值，避免每轮都要重置所有对象的 flag。
  void gcMark(int flag) {
    if (gcFlag == flag) return; // 已标记，防止循环引用无限递归
    gcFlag = flag;
  }
}

// ============================================================================
// GC — 全局标记-清除垃圾回收器
// ============================================================================

class GC {
  static int _currentFlag = 0;

  /// 所有已注册的 GC 对象（包括 root 和非 root）
  static final List<AnyGC> _objects = [];

  /// 顶层对象（静态变量 / 全局变量），作为 GC root
  static final List<AnyGC> _roots = [];

  /// 用于去重注册的标识集合（使用 Expando 避免调用未初始化对象的 hashCode）
  static Expando<bool> _registered = Expando<bool>('gc_registered');

  static void _resetRegistered() {
    _registered = Expando<bool>('gc_registered');
  }

  /// 分配一个局部对象（非 root），注册到 GC 并返回该对象。
  /// 用于包装 new 表达式：`GC.allocateLocal(X_new(XValue(), args))`
  static T allocateLocal<T extends AnyGC>(T object) {
    if (_registered[object] == null) {
      _registered[object] = true;
      _objects.add(object);
    }
    return object;
  }

  /// 分配一个全局对象（root），注册到 GC 并标记为 root，返回该对象。
  /// 用于静态变量 / 全局变量：`GC.allocateGlobal(X_new(XValue(), args))`
  static T allocateGlobal<T extends AnyGC>(T object) {
    if (_registered[object] == null) {
      _registered[object] = true;
      _objects.add(object);
    }
    if (!_roots.contains(object)) {
      _roots.add(object);
    }
    return object;
  }

  /// 从 root 集合中移除
  static void removeRoot(AnyGC object) {
    _roots.remove(object);
  }

  /// 执行一轮标记-清除 GC，返回被回收的对象数量
  static int collect() {
    _currentFlag++;
    final flag = _currentFlag;

    // 标记阶段：从每个 root 出发递归标记
    for (final root in _roots) {
      root.gcMark(flag);
    }

    // 清除阶段：移除未被标记的对象
    final beforeCount = _objects.length;
    _objects.removeWhere((obj) => obj.gcFlag != flag);
    // 重建 _registered（Expando 不支持 removeWhere，通过移除旧条目再重新添加实现）
    for (final obj in _objects) {
      _registered[obj] = true;
    }

    // 同步清理 roots 中已被回收的对象（理论上 root 总是被标记的，防御性清理）
    _roots.removeWhere((obj) => obj.gcFlag != flag);

    return beforeCount - _objects.length;
  }

  /// 获取当前管理的对象总数
  static int get objectCount => _objects.length;

  /// 获取当前 root 数量
  static int get rootCount => _roots.length;

  /// 重置 GC 状态（测试用）
  static void reset() {
    _objects.clear();
    _roots.clear();
    _resetRegistered();
    _currentFlag = 0;
  }
}

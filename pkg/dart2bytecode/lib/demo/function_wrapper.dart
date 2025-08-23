/// FunctionWrapper 包装类
/// 用于包装闭包函数，支持捕获外部变量
class FunctionWrapper<T extends Function> {
  /// 捕获的外部变量列表
  final List<dynamic> capturedVariables;

  /// 包装的函数
  final T function;

  /// 构造函数
  FunctionWrapper(this.capturedVariables, this.function);

  /// 获取实际的函数
  T call() => function;

  @override
  String toString() => 'FunctionWrapper($capturedVariables, $function)';
}

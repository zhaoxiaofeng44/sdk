class FunctionWrapper<F extends Function> {
  final F _function;
  final List<Object> _binding;
  FunctionWrapper(this._binding, this._function);

  F get call => _function;

  List<Object> get binding => _binding;

  @override
  String toString() {
    return '$_binding ${_function.toString()}';
  }
}

int main() {
  var aaa = FunctionWrapper<int Function(int, int, int)>(
      [1, 2, 3], (a, b, c) => a + b + c);
  print(aaa.call(1, 2, 3));
  return 0;
}

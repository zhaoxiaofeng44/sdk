import 'api.dart';



class FunctionWrapper<T> {
  final Function _function;
  FunctionWrapper(this._function);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return _function(invocation);
  }
}
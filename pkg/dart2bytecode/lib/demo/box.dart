import 'object.dart';

class BoxInt extends CppAny {
  int value;

  BoxInt([this.value = 0]);

  int unbox() => value;
}

class BoxDouble extends CppAny {
  double value;

  BoxDouble([this.value = 0.0]);

  double unbox() => value;
}

class BoxBool extends CppAny {
  bool value;

  BoxBool([this.value = false]);

  bool unbox() => value;
}

class BoxString extends CppAny {
  String value;

  BoxString([this.value = ""]);

  String unbox() => value;
}

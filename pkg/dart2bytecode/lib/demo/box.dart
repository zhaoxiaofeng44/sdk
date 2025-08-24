import 'object.dart';

class BoxInt extends CppObject {
  int value;

  BoxInt([this.value = 0]);

  int unbox() => value;
}

class BoxDouble extends CppObject {
  double value;

  BoxDouble([this.value = 0.0]);

  double unbox() => value;
}

class BoxBool extends CppObject {
  bool value;

  BoxBool([this.value = false]);

  bool unbox() => value;
}

class BoxString extends CppObject {
  String value;

  BoxString([this.value = ""]);

  String unbox() => value;
}

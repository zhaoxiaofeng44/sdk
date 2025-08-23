class BoxInt {
  int value;

  BoxInt([this.value = 0]);

  int unbox() => value;
}

class BoxDouble {
  double value;

  BoxDouble([this.value = 0.0]);

  double unbox() => value;
}

class BoxBool {
  bool value;

  BoxBool([this.value = false]);

  bool unbox() => value;
}

class BoxString {
  String value;

  BoxString([this.value = ""]);

  String unbox() => value;
}

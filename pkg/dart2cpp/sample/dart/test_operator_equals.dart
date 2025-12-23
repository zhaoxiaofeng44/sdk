// 测试 operator== 中的类型推断

class Vector {
  final double x, y;

  Vector(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  var v1 = Vector(1.0, 2.0);
  var v2 = Vector(1.0, 2.0);
  var v3 = Vector(3.0, 4.0);

  print('v1 == v2: ${v1 == v2}');
  print('v1 == v3: ${v1 == v3}');
}

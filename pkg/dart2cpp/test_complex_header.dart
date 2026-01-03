/// 复杂示例，测试头文件生成功能
class Vector2D {
  double x;
  double y;
  
  Vector2D(this.x, this.y);
  
  double magnitude() {
    var sum = x * x + y * y;
    return sum.sqrt();
  }
  
  Vector2D operator+(Vector2D other) {
    return Vector2D(x + other.x, y + other.y);
  }
}

/// 数学扩展
extension MathExtension on double {
  double sqrt() {
    if (this < 0) return 0;
    double x = this;
    double prev = 0;
    while ((x - prev).abs() > 0.0001) {
      prev = x;
      x = (x + this / x) / 2;
    }
    return x;
  }
}

/// 泛型扩展
extension LetExtension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}

/// 泛型类
class Container<T> {
  T value;
  
  Container(this.value);
  
  T getValue() => value;
}

/// 泛型函数
T identity<T>(T value) {
  return value;
}

void main() {
  var v1 = Vector2D(3, 4);
  print('Magnitude: ${v1.magnitude()}');
  
  var result = v1.let((v) => v.magnitude());
  print('Let result: $result');
  
  var container = Container<Vector2D>(v1);
  print('Container value magnitude: ${container.getValue().magnitude()}');
}
/// 测试头文件生成功能的Dart文件
class Point {
  double x;
  double y;
  
  Point(this.x, this.y);
  
  double distanceTo(Point other) {
    var distSquared = (x - other.x) * (x - other.x) + (y - other.y) * (y - other.y);
    return distSquared.sqrt();
  }
}

/// 扩展方法
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

/// 全局函数
double calculateDistance(Point a, Point b) {
  return a.distanceTo(b);
}

void main() {
  var p1 = Point(0, 0);
  var p2 = Point(3, 4);
  print('Distance: ${calculateDistance(p1, p2)}');
}
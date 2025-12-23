// 测试带类型的 List 字面量

void main() {
  // 测试1: 空的类型化 List
  var emptyDoubles = <double>[];
  print('空的 List<double> 列表: $emptyDoubles');

  // 测试2: 单层类型化 List
  var doubles = <double>[1.1, 2.2, 3.3];
  print('Double 列表: $doubles');

  var ints = <int>[1, 2, 3];
  print('Int 列表: $ints');

  var strings = <String>['hello', 'world'];
  print('String 列表: $strings');

  // 测试3: 嵌套类型化 List
  var matrix = <List<double>>[];
  matrix.add(<double>[1.0, 2.0]);
  matrix.add(<double>[3.0, 4.0]);
  print('矩阵: $matrix');

  // 测试4: 类型推断
  var result = <List<double>>[];
  for (int i = 0; i < 3; i++) {
    result.add(<double>[i.toDouble(), (i + 1).toDouble()]);
  }
  print('结果矩阵: $result');
}

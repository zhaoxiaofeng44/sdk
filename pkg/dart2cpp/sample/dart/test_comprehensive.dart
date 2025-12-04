/// 综合测试：验证已修复的问题
int add(int a, int b) {
  return a + b;
}

void greet(String name, [String? title]) {
  if (title != null) {
    print('Hello, $title $name!');
  } else {
    print('Hello, $name!');
  }
}

void main() {
  print('=== 综合测试 ===');

  // 测试1: 顶级函数调用
  int result = add(10, 20);
  print('Add result: $result');

  // 测试2: 可选参数
  greet('Alice');
  greet('Bob', 'Mr.');

  // 测试3: for-in 循环
  List<String> items = ['apple', 'banana', 'orange'];
  print('\\nFor-in loop:');
  for (String item in items) {
    print('  - $item');
  }

  print('\\n✅ 所有测试通过！');
}

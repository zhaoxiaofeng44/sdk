void main() {
  print('Hello, Dart to C++ World!');

  // 测试基本类型
  int number = 42;
  double pi = 3.14159;
  String message = 'Hello from Dart';
  bool isWorking = true;

  print('Number: $number');
  print('Pi: $pi');
  print('Message: $message');
  print('Is working: $isWorking');

  // 测试列表
  List<int> numbers = [1, 2, 3, 4, 5];
  print('Numbers: $numbers');

  // 测试循环
  for (int i = 0; i < 3; i++) {
    print('Loop iteration: $i');
  }

  // 测试条件语句
  if (isWorking) {
    print('✅ Script is working correctly!');
  } else {
    print('❌ Something went wrong');
  }

  print('Program completed successfully!');
}

// Basic conversion test - no external dependencies
void main() {
  print('Hello from Dart!');

  // Basic variables
  int x = 10;
  double y = 3.14;
  String message = 'Test';
  bool flag = true;

  // Basic operations
  int sum = x + 5;
  double product = y * 2.0;

  // Print results
  print('x = $x');
  print('y = $y');
  print('sum = $sum');
  print('product = $product');
  print('message = $message');
  print('flag = $flag');

  // Conditional
  if (flag) {
    print('Flag is true');
  } else {
    print('Flag is false');
  }

  // Loop
  for (int i = 0; i < 3; i++) {
    print('Loop iteration: $i');
  }

  print('Test completed!');
}

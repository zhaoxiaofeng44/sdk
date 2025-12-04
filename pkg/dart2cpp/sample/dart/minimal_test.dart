/// 最小测试 - 只测试空值合并
void main() {
  print('Test nullable');

  String? nullableString;
  String result = nullableString ?? 'default';
  print(result);
}

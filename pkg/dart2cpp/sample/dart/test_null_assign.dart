/// 测试空值合并赋值
void main() {
  int? nullableInt;
  nullableInt ??= 42;
  print(nullableInt);
}

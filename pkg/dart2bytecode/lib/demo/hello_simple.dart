void testIterableMethods() {
  // 测试for循环装箱
  {
    var list3 = [];
    for (int i = 0; i < 3; i++) {
      list3.add(() {
        print(i);
      });
    }
    list3.forEach((f) => f());
  }
}

void main() {
  testIterableMethods();
}

/// 类型提升测试
void main() {
  // 测试1: 基本的is类型检查和类型提升
  Object obj = "Hello";
  if (obj is String) {
    // 在这个分支中，obj被提升为String类型
    print(obj.length); // 可以访问String的方法
    print(obj.toUpperCase());
  }

  // 测试2: 使用dynamic类型
  dynamic value = 42;
  if (value is int) {
    print(value + 10); // value被提升为int类型
  }

  // 测试3: 嵌套的is检查
  Object? nullable = getValue();
  if (nullable != null) {
    if (nullable is String) {
      print(nullable.substring(0, 5)); // nullable被提升为String类型
    }
  }

  // 测试4: 逻辑与运算符中的类型提升
  Object x = getObject();
  Object y = getObject();

  if (x is String && y is int) {
    // x被提升为String，y被提升为int
    print(x.length + y);
  }

  // 测试5: else分支中类型不提升
  Object data = getData();
  if (data is List) {
    print(data.length); // data是List类型
  } else {
    // data在这里不是List类型，但仍然是Object
    print(data.toString());
  }

  // 测试6: 取反的is检查
  Object item = getItem();
  if (item is! int) {
    // item不是int，但类型没有提升
    print("Not an integer");
  } else {
    // item是int类型
    print(item.abs());
  }
}

Object getValue() {
  return "test";
}

Object getObject() {
  return "sample";
}

Object getData() {
  return [1, 2, 3];
}

Object getItem() {
  return 100;
}

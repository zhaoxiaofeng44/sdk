void main() {
  // 测试空值比较
  int? nullableInt;
  if (nullableInt == null) {
    print("nullableInt is null");
  }
  
  // 测试空合并操作符 ??
  String? nullableString;
  String result = nullableString ?? "default value";
  print(result);
  
  // 测试空安全调用操作符 ?.
  String? maybeString = "hello";
  int? length = maybeString?.length;
  print(length);
  
  // 测试链式空安全调用
  Person? person;
  String? cityName = person?.address?.city;
  print(cityName ?? "unknown city");
}

class Person {
  Address? address;
}

class Address {
  String? city;
}

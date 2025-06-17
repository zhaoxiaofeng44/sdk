class Test {
  void test() {
    // 测试List基本操作
    var numbers = <int>[];
    numbers.add(1);
    numbers.add(2);
    numbers.add(3);
    print("Numbers: $numbers");
    
    // 测试List的高级操作
    var doubled = numbers.map((n) => n * 2).toList();
    print("Doubled numbers: $doubled");
    
    // 测试String List
    var words = <String>[];
    words.add("Hello");
    words.add("World");
    print("Words: $words");
    
    // 测试Map操作
    var scores = <String, int>{};
    scores["Alice"] = 95;
    scores["Bob"] = 87;
    print("Scores: $scores");
    
    // 测试Set操作
    var set1 = <int>{1, 2, 3};
    var set2 = <int>{2, 3, 4};
    var intersection = set1.intersection(set2);
    print("Intersection: $intersection");
  }
}

void main() {
  var test = Test();
  test.test();
} 
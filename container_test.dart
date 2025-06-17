class ContainerTest {
  void testContainers() {
    // 测试List基本操作
    var numbers = <int>[];
    numbers.add(1);
    numbers.add(2);
    numbers.add(3);
    print("Numbers: $numbers");
    
    // 测试List的高级操作
    var doubled = numbers.map((n) => n * 2).toList();
    print("Doubled numbers: $doubled");
    
    var evenNumbers = numbers.where((n) => n % 2 == 0).toList();
    print("Even numbers: $evenNumbers");
    
    var sum = numbers.reduce((a, b) => a + b);
    print("Sum: $sum");
    
    // 测试String List
    var words = <String>[];
    words.add("Hello");
    words.add("World");
    print("Words: $words");
    
    // 测试Map操作
    var scores = <String, int>{};
    scores["Alice"] = 95;
    scores["Bob"] = 87;
    scores["Charlie"] = 92;
    print("Scores: $scores");
    
    print("Students: ${scores.keys.toList()}");
    print("All scores: ${scores.values.toList()}");
    
    // 测试Set操作
    var set1 = <int>{1, 2, 3, 4};
    var set2 = <int>{3, 4, 5, 6};
    
    var intersection = set1.intersection(set2);
    print("Intersection: $intersection");
    
    var union = set1.union(set2);
    print("Union: $union");
    
    var difference = set1.difference(set2);
    print("Difference: $difference");
    
    // 测试嵌套容器
    var matrix = <List<int>>[];
    for (var i = 0; i < 3; i++) {
      var row = <int>[];
      for (var j = 0; j < 3; j++) {
        row.add(i * 3 + j);
      }
      matrix.add(row);
    }
    print("Matrix: $matrix");
    
    // 测试Map嵌套List
    var studentCourses = <String, List<String>>{};
    studentCourses["Alice"] = ["Math", "Physics", "Chemistry"];
    studentCourses["Bob"] = ["History", "English", "Art"];
    print("Student courses: $studentCourses");
    
    // 测试复杂操作
    var totalScores = <String, Map<String, int>>{};
    totalScores["Term1"] = {"Alice": 95, "Bob": 87};
    totalScores["Term2"] = {"Alice": 92, "Bob": 90};
    print("Total scores: $totalScores");
    
    // 测试Set的字符串操作
    var stringSet = <String>{"apple", "banana", "orange"};
    print("Fruits: $stringSet");
    stringSet.add("grape");
    print("Added fruit: $stringSet");
    stringSet.remove("banana");
    print("Removed fruit: $stringSet");
  }
}

void main() {
  var test = ContainerTest();
  test.testContainers();
} 
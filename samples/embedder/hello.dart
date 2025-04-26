// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

//@pragma('wasm:entry-point', 'call')
// void main(List<String> args) {
//   var ttt = ["1", "2", "3", "4792hsdfssafkka"];
//   ttt.add("xmyyhssdgsgsg");
//   double ee = 7.4323;
//   int g = ee.ceil() % 4;

//   greet("aaaaa" + ttt[g]);
// }

// void greet(String person) {
//   double ee = 7.4323;
//   double ttt = ee + 6.2;
//   print("hi, ${ttt.ceil()}!");
// }


// @pragma('wasm:entry-point')
// void mylog(int person) {
//   print("hi, $person!");
// }

// @pragma('wasm:entry-point')
// class MyTest {
//   int aa = 1;
//   int bb;
//   MyTest(this.bb);

//   int get cc => aa + bb;
//   set cc(int value) {
//     aa = value;
//   }

//   void sum() {
//     aa = aa + bb;
//     print(aa);
//   }

//   @pragma('wasm:entry-point')
//   void sum2(int aa, String bb, {String cc = "default"}) {
//     var dd = "$aa$bb$cc";
//     this.bb = dd.length;
//     mylog("$dd$cc".length);
//   }

//   void Function(int a) test3(){
//     return (int a){};
//   }
// }

// @pragma('wasm:entry-point')
// int greet2(int person) {
//   MyTest aa = MyTest(2);
//   aa.cc = 3;
//   aa.bb = person;
//   aa.sum();
//   aa.sum2(person, "vv22", cc: "cc");
//   int t = person + aa.bb;
//   return t + person;
// }

// 定义一个回调函数类型
typedef DataProcessor = int Function(int value, {String? label});
typedef MapTransformer<K, V, R> = R Function(K key, V value);

class ComplexTest {
  // 实例变量
  final List<String> _messages = [];
  final Map<String, int> _scores = {};
  final Set<int> _uniqueIds = {};

  @pragma('wasm:entry-point')
  ComplexTest() {
    _messages.add("Initialized");
    print("ComplexTest initialized");
  }

  // 基础容器操作测试
  @pragma('wasm:entry-point')
  void testContainers() {
    // List操作
    var numbers = <int>[1, 2, 3, 4, 5];
    numbers.add(6);
    var doubled = numbers.map((n) => n * 2).toList();
    print("Doubled numbers: $doubled");

    var evenNumbers = numbers.where((n) => n % 2 == 0).toList();
    print("Even numbers: $evenNumbers");

    // Map操作
    var studentScores = <String, Map<String, int>>{
      'Term1': {'Alice': 95, 'Bob': 87, 'Charlie': 92},
      'Term2': {'Alice': 98, 'Bob': 85, 'Charlie': 90}
    };

    studentScores.forEach((term, scores) {
      print("$term results:");
      scores.forEach((student, score) => print("  $student: $score"));
    });

    // Set操作
    var set1 = <int>{1, 2, 3, 4};
    var set2 = <int>{3, 4, 5, 6};
    print("Set1 ∩ Set2: ${set1.intersection(set2)}");
    print("Set1 ∪ Set2: ${set1.union(set2)}");
    print("Set1 - Set2: ${set1.difference(set2)}");
  }

  // 高级函数特性测试
  @pragma('wasm:entry-point')
  int processWithCallback(int value, DataProcessor processor, {String? label}) {
    print("Processing value: $value${label != null ? ' with label: $label' : ''}");
    return processor(value, label: label);
  }

  // 泛型方法测试
  @pragma('wasm:entry-point')
  Map<K, R> transformMap<K, V, R>(
    Map<K, V> input,
    MapTransformer<K, V, R> transformer
  ) {
    var result = <K, R>{};
    input.forEach((key, value) {
      result[key] = transformer(key, value);
    });
    return result;
  }

  // 复杂数据结构测试
  @pragma('wasm:entry-point')
  void testNestedStructures() {
    var matrix = <List<int>>[];
    for (var i = 0; i < 3; i++) {
      var row = <int>[];
      for (var j = 0; j < 3; j++) {
        row.add(i * 3 + j);
      }
      matrix.add(row);
    }
    print("Matrix: $matrix");

    var studentCourses = <String, List<String>>{
      'Alice': ['Math', 'Physics', 'Chemistry'],
      'Bob': ['History', 'English', 'Art']
    };

    studentCourses.forEach((student, courses) {
      print("$student is taking: ${courses.join(', ')}");
    });
  }

  // 命名参数和可选参数测试
  @pragma('wasm:entry-point')
  void addScore({
    required String student,
    required int score,
    String subject = 'General',
    bool notify = false
  }) {
    _scores[student] = score;
    if (notify) {
      _messages.add("New score added for $student in $subject: $score");
    }
    print("Score added: $student - $subject: $score");
  }

  // 异步操作模拟
  @pragma('wasm:entry-point')
  void simulateAsyncOperations() {
    var operations = <String, int Function()>{
      'Operation 1': () => 42,
      'Operation 2': () => 84,
      'Operation 3': () => 126
    };

    operations.forEach((name, operation) {
      var result = operation();
      _uniqueIds.add(result);
      print("$name completed with result: $result");
    });
  }

  // 高级List操作测试
  @pragma('wasm:entry-point')
  void testAdvancedListOperations() {
    var numbers = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    // reduce操作
    var sum = numbers.reduce((a, b) => a + b);
    print("Sum: $sum");

    // fold操作
    var sumOfSquares = numbers.fold<int>(0, (sum, item) => sum + item * item);
    print("Sum of squares: $sumOfSquares");

    // 复杂转换
    var processedNumbers = numbers
        .where((n) => n % 2 == 0)
        .map((n) => n * n)
        .takeWhile((n) => n < 50)
        .toList();
    print("Processed numbers: $processedNumbers");
  }

  // 状态报告
  @pragma('wasm:entry-point')
  Map<String, dynamic> getStatus() {
    return {
      'messageCount': _messages.length,
      'scoreCount': _scores.length,
      'uniqueIdCount': _uniqueIds.length,
      'lastMessage': _messages.isEmpty ? null : _messages.last
    };
  }

  // 变量定义测试
  @pragma('wasm:entry-point')
  void testVariableDeclarations() {
    // 各种类型变量定义
    int intVar = 42;
    double doubleVar = 3.14;
    String stringVar = "Hello, Dart!";
    bool boolVar = true;
    dynamic dynamicVar = "Can change type";
    dynamicVar = 100;

    // 可空类型
    int? nullableInt;
    String? nullableString = null;

    // late变量
    late int lateInitVar;
    lateInitVar = 10;

    // const和final变量
    final int finalVar = 100;
    const double constVar = 3.14159;

    print("Variables: $intVar, $doubleVar, $stringVar, $boolVar, $dynamicVar");
    print("Nullable: $nullableInt, $nullableString");
    print("Late and Final/Const: $lateInitVar, $finalVar, $constVar");
  }

  // 函数赋值和高阶函数测试
  @pragma('wasm:entry-point')
  void testFunctionAssignment() {
    // 函数类型赋值
    int Function(int, int) addFunc = (a, b) => a + b;
    print("Function result: ${addFunc(5, 3)}");

    // 高阶函数
    int Function(int) multiplier(int factor) {
      return (int x) => x * factor;
    }

    var double2 = multiplier(2);
    var double3 = multiplier(3);
    print("Multiplier results: ${double2(4)}, ${double3(4)}");

    // 匿名函数
    var greet = (String name) {
      return "Hello, $name!";
    };
    print(greet("Dart"));
  }

  // 表达式测试
  @pragma('wasm:entry-point')
  void testExpressions() {
    // 算术表达式
    int a = 10, b = 3;
    print("Arithmetic: $a + $b = ${a + b}");
    print("Arithmetic: $a - $b = ${a - b}");
    print("Arithmetic: $a * $b = ${a * b}");
    print("Arithmetic: $a / $b = ${a / b}");
    print("Modulo: $a % $b = ${a % b}");

    // 位运算
    print("Bitwise: $a << 1 = ${a << 1}");
    print("Bitwise: $a >> 1 = ${a >> 1}");
    print("Bitwise AND: $a & $b = ${a & b}");
    print("Bitwise OR: $a | $b = ${a | b}");
    print("Bitwise XOR: $a ^ $b = ${a ^ b}");
  }

  // 条件判断测试
  @pragma('wasm:entry-point')
  void testConditionals() {
    int x = 10, y = 20;

    // if-else
    if (x > y) {
      print("x is greater than y");
    } else if (x < y) {
      print("x is less than y");
    } else {
      print("x is equal to y");
    }

    // 三元运算符
    String result = x > y ? "x is greater" : "y is greater or equal";
    print("Ternary result: $result");

    // 空值检查
    String? nullableStr = null;
    print("Null-aware: ${nullableStr ?? 'Default value'}");
  }

  // Switch语句测试
  @pragma('wasm:entry-point')
  void testSwitch(int value) {
    switch (value) {
      case 1:
        print("One");
        break;
      case 2:
        print("Two");
        break;
      case 3:
        print("Three");
        break;
      default:
        print("Unknown number");
    }
  }

  // 循环测试
  @pragma('wasm:entry-point')
  void testLoops() {
    // for循环
    print("For loop:");
    for (int i = 0; i < 5; i++) {
      print(i);
    }

    // for-in循环
    print("For-in loop:");
    var list = [1, 2, 3, 4, 5];
    for (var item in list) {
      print(item);
    }

    // while循环
    print("While loop:");
    int j = 0;
    while (j < 5) {
      print(j);
      j++;
    }

    // do-while循环
    print("Do-while loop:");
    int k = 0;
    do {
      print(k);
      k++;
    } while (k < 5);
  }
}



// // 全局函数
// @pragma('wasm:entry-point')
// void runAllTests() {
//   var test = ComplexTest();
  
//   // 测试容器操作
//   test.testContainers();
  
//   // 测试回调函数
//   var result = test.processWithCallback(
//     10,
//     (value, {label}) => value * 2,
//     label: "double"
//   );
//   print("Callback result: $result");
  
//   // 测试Map转换
//   var scores = {'Math': 95, 'Physics': 87, 'Chemistry': 92};
//   var transformed = test.transformMap<String, int, String>(
//     scores,
//     (subject, score) => "$subject: ${score >= 90 ? 'A' : 'B'}"
//   );
//   print("Transformed scores: $transformed");
  
//   // 测试嵌套结构
//   test.testNestedStructures();
  
//   // 测试命名参数
//   test.addScore(
//     student: "Alice",
//     score: 95,
//     subject: "Math",
//     notify: true
//   );
  
//   // 测试异步操作
//   test.simulateAsyncOperations();
  
//   // 测试高级List操作
//   test.testAdvancedListOperations();
  
//   // 打印状态报告
//   print("Final status: ${test.getStatus()}");
// }

@pragma('wasm:entry-point')
void main() {
  // print("Starting complex tests...");
  // runAllTests();
  // print("All tests completed!");

  var complexTest = ComplexTest();
  complexTest.testContainers();
  // 调用新增的测试方法
  // complexTest.testVariableDeclarations();
  // complexTest.testFunctionAssignment();
  // complexTest.testExpressions();
  // complexTest.testConditionals();
  // complexTest.testSwitch(2);
  // complexTest.testLoops();
}

// ============================================================================
// 高级 Dart 到 C++ 转换示例
// 测试更多语法特性
// ============================================================================

/// 学生类示例
class Student {
  String name;
  int age;
  List<String> subjects;
  Map<String, int> grades;

  Student(this.name, this.age) {
    subjects = [];
    grades = {};
  }

  /// 添加科目
  void addSubject(String subject) {
    subjects.add(subject);
    grades[subject] = 0;
  }

  /// 设置成绩
  void setGrade(String subject, int grade) {
    if (subjects.contains(subject)) {
      grades[subject] = grade;
    }
  }

  /// 获取平均分
  double getAverageGrade() {
    if (grades.isEmpty) return 0.0;

    int total = 0;
    for (String subject in subjects) {
      total += grades[subject] ?? 0;
    }

    return total / subjects.length;
  }

  /// 获取学生信息
  String getInfo() {
    var info = 'Student: $name, Age: $age';
    if (subjects.isNotEmpty) {
      info += '\nSubjects: ${subjects.join(", ")}';
      info += '\nAverage Grade: ${getAverageGrade().toStringAsFixed(2)}';
    }
    return info;
  }
}

/// 工具类示例
class MathUtils {
  /// 计算阶乘
  static int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
  }

  /// 判断是否为质数
  static bool isPrime(int n) {
    if (n < 2) return false;
    for (int i = 2; i * i <= n; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  /// 生成斐波那契数列
  static List<int> fibonacci(int count) {
    if (count <= 0) return [];
    if (count == 1) return [0];
    if (count == 2) return [0, 1];

    var result = [0, 1];
    for (int i = 2; i < count; i++) {
      result.add(result[i - 1] + result[i - 2]);
    }
    return result;
  }
}

/// 异步函数示例
Future<String> fetchUserData(String userId) async {
  // 模拟网络延迟
  await Future.delayed(Duration(milliseconds: 100));
  return 'User data for $userId: {name: "User$userId", active: true}';
}

/// 集合操作示例
void demonstrateCollections() {
  print('=== 集合操作示例 ===');

  // 列表操作
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var evenNumbers = numbers.where((n) => n % 2 == 0).toList();
  var doubled = numbers.map((n) => n * 2).toList();

  print('原始数字: $numbers');
  print('偶数: $evenNumbers');
  print('翻倍: $doubled');

  // Set操作
  var fruits = {'apple', 'banana', 'cherry', 'apple'};
  print('水果集合: $fruits');
  print('水果数量: ${fruits.length}');

  // Map操作
  var studentGrades = {'Alice': 95, 'Bob': 87, 'Charlie': 92, 'Diana': 88};

  print('学生成绩:');
  studentGrades.forEach((name, grade) {
    print('  $name: $grade');
  });

  var highGrades = studentGrades.values.where((grade) => grade >= 90);
  print('高分成绩: $highGrades');
}

/// 字符串操作示例
void demonstrateStrings() {
  print('=== 字符串操作示例 ===');

  var name = 'Dart';
  var version = 3.0;
  var message = 'Hello, $name $version!';
  var multiline = '''
    这是一个
    多行字符串
    示例
  ''';

  print('消息: $message');
  print('多行字符串: $multiline');
  print('大写: ${message.toUpperCase()}');
  print('小写: ${message.toLowerCase()}');
  print('长度: ${message.length}');
  print('是否包含Dart: ${message.contains("Dart")}');
}

/// 条件和循环示例
void demonstrateControlFlow() {
  print('=== 控制流示例 ===');

  // if-else
  var score = 85;
  var grade = '';
  if (score >= 90) {
    grade = 'A';
  } else if (score >= 80) {
    grade = 'B';
  } else if (score >= 70) {
    grade = 'C';
  } else {
    grade = 'F';
  }
  print('分数: $score, 等级: $grade');

  // switch
  var day = 'Monday';
  switch (day) {
    case 'Monday':
      print('周一，新的开始！');
      break;
    case 'Friday':
      print('周五，快到周末了！');
      break;
    default:
      print('普通的一天');
      break;
  }

  // for循环
  print('计数到5:');
  for (int i = 1; i <= 5; i++) {
    print('  $i');
  }

  // while循环
  print('倒计时:');
  int countdown = 3;
  while (countdown > 0) {
    print('  $countdown');
    countdown--;
  }
  print('  发射！');
}

/// 主函数
void main() async {
  print('=== 高级 Dart 到 C++ 转换示例 ===');
  print('');

  // 1. 类和对象示例
  print('1. 类和对象示例:');
  var student = Student('Alice', 20);
  student.addSubject('Math');
  student.addSubject('Physics');
  student.addSubject('Chemistry');

  student.setGrade('Math', 95);
  student.setGrade('Physics', 88);
  student.setGrade('Chemistry', 92);

  print(student.getInfo());
  print('');

  // 2. 静态方法示例
  print('2. 静态方法示例:');
  print('5的阶乘: ${MathUtils.factorial(5)}');
  print('17是质数: ${MathUtils.isPrime(17)}');

  var fibSequence = MathUtils.fibonacci(10);
  print('斐波那契数列(10项): $fibSequence');
  print('');

  // 3. 集合操作
  demonstrateCollections();
  print('');

  // 4. 字符串操作
  demonstrateStrings();
  print('');

  // 5. 控制流
  demonstrateControlFlow();
  print('');

  // 6. 异步操作示例
  print('6. 异步操作示例:');
  try {
    var userData = await fetchUserData('12345');
    print('获取到用户数据: $userData');
  } catch (e) {
    print('获取用户数据失败: $e');
  }
  print('');

  print('=== 示例完成 ===');
}

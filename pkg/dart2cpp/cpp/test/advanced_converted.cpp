#include "../pkg/dart2bytecode/base/object.h"
#include "../pkg/dart2bytecode/base/dart_oop_extensions.h"
#include "../pkg/dart2bytecode/base/dart_async.h"
#include <iostream>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// 集合类型辅助函数
template<typename T>
List<T> dart_list_from_values(std::initializer_list<T> values) {
    return List<T>::createFromValues(values);
}

template<typename T>
Set<T> dart_set_from_values(std::initializer_list<T> values) {
    return Set<T>::createFromValues(values);
}

// ============================================================================
// 类: Student
// ============================================================================

class Student : public Object {
public:
    String name;
    Int age;
    List<String> subjects;
    Map<String, Int> grades;
  
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
    void setGrade(String subject, Int grade) {
    if (subjects.contains(subject)) {
    grades[subject] = grade;
    }
    }
  
  /// 获取平均分
    Double getAverageGrade() {
    if (grades.isEmpty) return 0.0;
  
    Int total = 0;
    for (String subject in subjects) {
    total += grades[subject] ?? 0;
    }
  
    return total / subjects.length;
    }
  
  /// 获取学生信息
    String getInfo() {
    auto info = 'Student: $name, Age: $age';
    if (subjects.isNotEmpty) {
    info += '\nSubjects: ${subjects.join(", ")}';
    info += '\nAverage Grade: ${getAverageGrade().toStringAsFixed(2)}';
    }
    return info;
    }
};

// ============================================================================
// 类: MathUtils
// ============================================================================

class MathUtils : public Object {
public:
  /// 计算阶乘
    static Int factorial(Int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
    }
  
  /// 判断是否为质数
    static Bool isPrime(Int n) {
    if (n < 2) return false;
    for (Int i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
    }
    return true;
    }
  
  /// 生成斐波那契数列
    static List<Int> fibonacci(Int count) {
    if (count <= 0) return [];
    if (count == 1) return [0];
    if (count == 2) return [0, 1];
  
    auto result = [0, 1];
    for (Int i = 2; i < count; i++) {
    result.add(result[i-1] + result[i-2]);
    }
    return result;
    }
};

// ============================================================================
// 函数: fetchUserData
// ============================================================================

Future<String> fetchUserData(String userId) async { {
    // 模拟网络延迟
    await Future.delayed(Duration(milliseconds: dart_int(100)));
    return dart_string("User data for " + userId.toString() + ": Map<Any, Any>::create() /* TODO: 解析Map字面量: {name: dart_string("User" + userId.toString() + ""), active: dart_bool(true)} */");
}

// ============================================================================
// 函数: demonstrateCollections
// ============================================================================

void demonstrateCollections() { {
    dart_print(dart_string("=== 集合操作示例 ==="));
    
    // 列表操作
    auto numbers = dart_list_from_values(dart_set_from_values({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)}));
    auto evenNumbers = numbers.where([](const auto& n) { return n % dart_int(2; }) == dart_int(0)).toList();
    auto doubled = numbers.map([](const auto& n) { return n * dart_int(2; })).toList();
    
    dart_print(dart_string("原始数字: " + numbers.toString() + ""));
    dart_print(dart_string("偶数: " + evenNumbers.toString() + ""));
    dart_print(dart_string("翻倍: " + doubled.toString() + ""));
    
    // Set操作
    auto fruits = dart_set_from_values({dart_string("apple"), dart_string("banana"), dart_string("cherry"), dart_string("apple")});
    dart_print(dart_string("水果集合: " + fruits.toString() + ""));
// ============================================================================
// 函数: print
// ============================================================================

print('水果数量: ${fruits.length}'); {
    
    // Map操作
    auto studentGrades = {
    dart_string("Alice"): dart_int(95),
    dart_string("Bob"): dart_int(87),
    dart_string("Charlie"): dart_int(92),
    dart_string("Diana"): dart_int(88)
    };
    
    dart_print(dart_string("学生成绩:"));
// ============================================================================
// 函数: forEach
// ============================================================================

studentGrades.forEach((name, grade) { {
    dart_print(dart_string("  " + name.toString() + ": " + grade.toString() + ""));
    });
    
    auto highGrades = studentGrades.values.where([](const auto& grade) { return grade >= dart_int(90; }));
    dart_print(dart_string("高分成绩: " + highGrades.toString() + ""));
    }
    
    /// 字符串操作示例
// ============================================================================
// 函数: demonstrateStrings
// ============================================================================

void demonstrateStrings() { {
    dart_print(dart_string("=== 字符串操作示例 ==="));
    
    auto name = dart_string("Dart");
    auto version = dart_double(3.dart_int(0));
    auto message = dart_string("Hello, " + name.toString() + " " + version.toString() + "!");
    auto multiline = dart_string("")'
    这是一个
    多行字符串
    示例
    dart_string("")';
    
    dart_print(dart_string("消息: " + message.toString() + ""));
    dart_print(dart_string("多行字符串: " + multiline.toString() + ""));
// ============================================================================
// 函数: print
// ============================================================================

print('大写: ${message.toUpperCase()}'); {
// ============================================================================
// 函数: print
// ============================================================================

print('小写: ${message.toLowerCase()}'); {
// ============================================================================
// 函数: print
// ============================================================================

print('长度: ${message.length}'); {
// ============================================================================
// 函数: print
// ============================================================================

print('是否包含Dart: ${message.contains("Dart")}'); {
}

// ============================================================================
// 函数: demonstrateControlFlow
// ============================================================================

void demonstrateControlFlow() { {
    dart_print(dart_string("=== 控制流示例 ==="));
    
    // if-else
    auto score = dart_int(85);
    auto grade = dart_string("");
    if (score >= dart_int(90)) {
    grade = dart_string("A");
    } else if (score >= dart_int(80)) {
    grade = dart_string("B");
    } else if (score >= dart_int(70)) {
    grade = dart_string("C");
    } else {
    grade = dart_string("F");
    }
    dart_print(dart_string("分数: " + score.toString() + ", 等级: " + grade.toString() + ""));
    
    // switch
    auto day = dart_string("Monday");
// ============================================================================
// 函数: switch
// ============================================================================

switch (day) { {
    case dart_string("Monday"):
    dart_print(dart_string("周一，新的开始！"));
    break;
    case dart_string("Friday"):
    dart_print(dart_string("周五，快到周末了！"));
    break;
    default:
    dart_print(dart_string("普通的一天"));
    break;
}

// ============================================================================
// 函数: while
// ============================================================================

while (countdown > 0) { {
    dart_print(dart_string("  " + countdown.toString() + ""));
    countdown--;
}

// ============================================================================
// 函数: main
// ============================================================================

void main() async { {
    dart_print(dart_string("=== 高级 Dart 到 C++ 转换示例 ==="));
    dart_print(dart_string(""));
    
    // 1. 类和对象示例
    dart_print(dart_string("dart_int(1). 类和对象示例:"));
    auto student = Student(dart_string("Alice"), dart_int(20));
    student.addSubject(dart_string("Math"));
    student.addSubject(dart_string("Physics"));
    student.addSubject(dart_string("Chemistry"));
    
    student.setGrade(dart_string("Math"), dart_int(95));
    student.setGrade(dart_string("Physics"), dart_int(88));
    student.setGrade(dart_string("Chemistry"), dart_int(92));
    
    dart_print(student.getInfo());
    dart_print(dart_string(""));
    
    // 2. 静态方法示例
    dart_print(dart_string("dart_int(2). 静态方法示例:"));
// ============================================================================
// 函数: print
// ============================================================================

print('5的阶乘: ${MathUtils.factorial(5)}'); {
// ============================================================================
// 函数: print
// ============================================================================

print('17是质数: ${MathUtils.isPrime(17)}'); {
    
    auto fibSequence = MathUtils.fibonacci(dart_int(10));
    dart_print(dart_string("斐波那契数列(dart_int(10)项): " + fibSequence.toString() + ""));
    dart_print(dart_string(""));
    
    // 3. 集合操作
    demonstrateCollections();
    dart_print(dart_string(""));
    
    // 4. 字符串操作
    demonstrateStrings();
    dart_print(dart_string(""));
    
    // 5. 控制流
    demonstrateControlFlow();
    dart_print(dart_string(""));
    
    // 6. 异步操作示例
    dart_print(dart_string("dart_int(6). 异步操作示例:"));
    try {
    auto userData = await fetchUserData(dart_string("dart_int(12345)"));
    dart_print(dart_string("获取到用户数据: " + userData.toString() + ""));
// ============================================================================
// 函数: catch
// ============================================================================

} catch (e) { {
    dart_print(dart_string("获取用户数据失败: " + e.toString() + ""));
}


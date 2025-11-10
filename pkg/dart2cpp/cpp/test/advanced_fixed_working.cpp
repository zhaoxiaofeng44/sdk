#include "../core/object.h"
#include <iostream>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

// ============================================================================
// 类: Student
// ============================================================================

class Student : public Object {
public:
    String name;
    Int age;
    ObjectPtr<List<String>> subjects;
    ObjectPtr<Map<String, Int>> grades;
  
    Student(const String& n, const Int& a) : name(n), age(a) {
        subjects = List<String>::create();
        grades = Map<String, Int>::create();
    }
  
    // 添加科目
    void addSubject(const String& subject) {
        subjects->add(subject);
        grades->put(subject, Int(0));
    }
  
    // 设置成绩
    void setGrade(const String& subject, const Int& grade) {
        if (subjects->contains(subject)) {
            grades->put(subject, grade);
        }
    }
  
    // 获取平均分
    Double getAverageGrade() {
        if (grades->isEmpty()) return Double(0.0);
  
        Int total = Int(0);
        for (int i = 0; i < subjects->size().toInt(); i++) {
            String subject = subjects->get(i);
            total = total + grades->get(subject);
        }
  
        return Double(total.toDouble().value / subjects->size().toDouble().value);
    }
  
    // 获取学生信息
    String getInfo() {
        String info = String("Student: ") + name + String(", Age: ") + age.toString();
        if (!subjects->isEmpty()) {
            info = info + String("\nSubjects: ") + subjects->toString();
            info = info + String("\nAverage Grade: ") + getAverageGrade().toString();
        }
        return info;
    }
};

// ============================================================================
// 类: MathUtils
// ============================================================================

class MathUtils : public Object {
public:
    // 计算阶乘
    static Int factorial(const Int& n) {
        if (n.value <= 1) return Int(1);
        return n * factorial(Int(n.value - 1));
    }
  
    // 判断是否为质数
    static Bool isPrime(const Int& n) {
        if (n.value < 2) return Bool(false);
        for (int i = 2; i * i <= n.value; i++) {
            if (n.value % i == 0) return Bool(false);
        }
        return Bool(true);
    }
  
    // 生成斐波那契数列
    static ObjectPtr<List<Int>> fibonacci(const Int& count) {
        ObjectPtr<List<Int>> result = List<Int>::create();
        if (count.value <= 0) return result;
        if (count.value == 1) {
            result->add(Int(0));
            return result;
        }
        if (count.value == 2) {
            result->add(Int(0));
            result->add(Int(1));
            return result;
        }
  
        result->add(Int(0));
        result->add(Int(1));
        for (int i = 2; i < count.value; i++) {
            Int prev1 = result->get(i-1);
            Int prev2 = result->get(i-2);
            result->add(prev1 + prev2);
        }
        return result;
    }
};

// ============================================================================
// 函数: demonstrateCollections
// ============================================================================

void demonstrateCollections() {
    dart_print(String("=== 集合操作示例 ==="));
    
    // 列表操作
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    for (int i = 1; i <= 10; i++) {
        numbers->add(Int(i));
    }
    
    dart_print(String("原始数字: ") + numbers->toString());
    
    // 简单的偶数过滤
    ObjectPtr<List<Int>> evenNumbers = List<Int>::create();
    for (int i = 0; i < numbers->size().toInt(); i++) {
        Int num = numbers->get(i);
        if (num.value % 2 == 0) {
            evenNumbers->add(num);
        }
    }
    dart_print(String("偶数: ") + evenNumbers->toString());
    
    // 简单的翻倍操作
    ObjectPtr<List<Int>> doubled = List<Int>::create();
    for (int i = 0; i < numbers->size().toInt(); i++) {
        Int num = numbers->get(i);
        doubled->add(Int(num.value * 2));
    }
    dart_print(String("翻倍: ") + doubled->toString());
}

// ============================================================================
// 函数: demonstrateStrings
// ============================================================================

void demonstrateStrings() {
    dart_print(String("=== 字符串操作示例 ==="));
    
    String name = String("Dart");
    Double version = Double(3.0);
    String message = String("Hello, ") + name + String(" ") + version.toString() + String("!");
    String multiline = String("这是一个\n多行字符串\n示例");
    
    dart_print(String("消息: ") + message);
    dart_print(String("多行字符串: ") + multiline);
    dart_print(String("长度: ") + message.get_length().toString());
    dart_print(String("是否包含Dart: ") + Bool(message.contains(String("Dart"))).toString());
}

// ============================================================================
// 函数: demonstrateControlFlow
// ============================================================================

void demonstrateControlFlow() {
    dart_print(String("=== 控制流示例 ==="));
    
    // if-else
    Int score = Int(85);
    String grade;
    if (score.value >= 90) {
        grade = String("A");
    } else if (score.value >= 80) {
        grade = String("B");
    } else if (score.value >= 70) {
        grade = String("C");
    } else {
        grade = String("F");
    }
    dart_print(String("分数: ") + score.toString() + String(", 等级: ") + grade);
    
    // switch 模拟
    String day = String("Monday");
    if (day.getValue() == "Monday") {
        dart_print(String("周一，新的开始！"));
    } else if (day.getValue() == "Friday") {
        dart_print(String("周五，快到周末了！"));
    } else {
        dart_print(String("普通的一天"));
    }
    
    // for 循环
    dart_print(String("数字1到5:"));
    for (int i = 1; i <= 5; i++) {
        dart_print(String("  ") + Int(i).toString());
    }
}

// ============================================================================
// 函数: demonstrateClasses
// ============================================================================

void demonstrateClasses() {
    dart_print(String("=== 类和对象示例 ==="));
    
    // 创建学生对象
    Student student(String("Alice"), Int(20));
    student.addSubject(String("Math"));
    student.addSubject(String("Physics"));
    student.addSubject(String("Chemistry"));
    
    student.setGrade(String("Math"), Int(95));
    student.setGrade(String("Physics"), Int(88));
    student.setGrade(String("Chemistry"), Int(92));
    
    dart_print(student.getInfo());
    
    // 数学工具类测试
    dart_print(String("=== 数学工具测试 ==="));
    dart_print(String("5的阶乘: ") + MathUtils::factorial(Int(5)).toString());
    dart_print(String("17是质数吗: ") + MathUtils::isPrime(Int(17)).toString());
    
    ObjectPtr<List<Int>> fib = MathUtils::fibonacci(Int(10));
    dart_print(String("斐波那契数列(前10项): ") + (*fib).toString());
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    try {
        dart_print(String("=== Dart2CPP 高级语法测试 (修复版) ==="));
        
        demonstrateCollections();
        std::cout << std::endl;
        
        demonstrateStrings();
        std::cout << std::endl;
        
        demonstrateControlFlow();
        std::cout << std::endl;
        
        demonstrateClasses();
        
        dart_print(String("=== 测试完成 ==="));
        
    } catch (const std::exception& e) {
        std::cerr << "错误: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}
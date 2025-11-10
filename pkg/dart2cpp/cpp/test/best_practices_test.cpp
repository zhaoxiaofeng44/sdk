#include "../core/object.h"
#include <iostream>

// ============================================================================
// 最佳实践示例：展示如何正确使用类型系统
// ============================================================================

// 自定义类示例 - 必须通过ObjectPtr使用
class Student : public Object {
private:
    String name_;
    Int age_;
    List<String> courses_;  // 成员可以是值类型容器
    
    // 私有构造函数
    Student(const String& name, const Int& age)
        : name_(name), age_(age) {
        std::cout << "Student构造: " << name_.getValue() << std::endl;
    }
    
public:
    // 静态工厂方法
    static ObjectPtr<Student> create(const String& name, const Int& age) {
        return ObjectPtr<Student>(new Student(name, age));
    }
    
    virtual ~Student() {
        std::cout << "Student析构: " << name_.getValue() << std::endl;
    }
    
    // Getter
    String getName() const { return name_; }
    Int getAge() const { return age_; }
    
    // 添加课程
    void addCourse(const String& course) {
        courses_.add(course);
    }
    
    // 获取课程列表（返回拷贝）
    List<String> getCourses() const {
        return courses_;
    }
    
    Int getCourseCount() const {
        return courses_.size();
    }
    
    virtual String toString() const override {
        return String("Student(") + name_ + String(", ") + 
               age_.toString() + String(", courses: ") + 
               courses_.size().toString() + String(")");
    }
    
    bool operator==(const Student& other) const {
        return name_ == other.name_ && age_ == other.age_;
    }
};

// ============================================================================
// 测试函数
// ============================================================================

// 示例1: 基础类型的正确使用
void test_basic_types() {
    std::cout << "\n=== 示例1: 基础类型 ===" << std::endl;
    
    // 直接使用值语义
    Int a = Int(10);
    Int b = Int(20);
    Int sum = a + b;
    
    std::cout << a.toInt() << " + " << b.toInt() 
              << " = " << sum.toInt() << std::endl;
    
    // String操作
    String firstName = String("John");
    String lastName = String("Doe");
    String fullName = firstName + String(" ") + lastName;
    
    std::cout << "Full name: " << fullName.getValue() << std::endl;
    
    // Bool操作
    Bool isPositive = a > Int(0);
    std::cout << "Is positive: " << isPositive.toString().getValue() << std::endl;
}

// 示例2: 容器类型的正确使用（值语义）
void test_containers_value_semantics() {
    std::cout << "\n=== 示例2: 容器（值语义）===" << std::endl;
    
    // List - 值语义，适合局部使用
    List<Int> numbers;
    for (int i = 1; i <= 5; i++) {
        numbers.add(Int(i));
    }
    
    std::cout << "Numbers count: " << numbers.size().toInt() << std::endl;
    
    // 使用forEach遍历
    std::cout << "Numbers: ";
    numbers.forEach([](const Int& n) {
        std::cout << n.toInt() << " ";
    });
    std::cout << std::endl;
    
    // Set - 去重
    Set<String> uniqueNames;
    uniqueNames.add(String("Alice"));
    uniqueNames.add(String("Bob"));
    uniqueNames.add(String("Alice"));  // 重复，不会添加
    
    std::cout << "Unique names: " << uniqueNames.size().toInt() << std::endl;
    
    // Map - 键值对
    Map<String, Int> scores;
    scores.put(String("Alice"), Int(95));
    scores.put(String("Bob"), Int(87));
    
    std::cout << "Scores:" << std::endl;
    scores.forEach([](const String& name, const Int& score) {
        std::cout << "  " << name.getValue() << ": " 
                  << score.toInt() << std::endl;
    });
}

// 示例3: 自定义类的正确使用（ObjectPtr）
void test_custom_class() {
    std::cout << "\n=== 示例3: 自定义类（ObjectPtr）===" << std::endl;
    
    // 创建Student对象
    ObjectPtr<Student> student = Student::create(String("Alice"), Int(20));
    
    // 添加课程
    student->addCourse(String("Math"));
    student->addCourse(String("Physics"));
    student->addCourse(String("Chemistry"));
    
    // 访问信息
    std::cout << "Name: " << student->getName().getValue() << std::endl;
    std::cout << "Age: " << student->getAge().toInt() << std::endl;
    std::cout << "Courses: " << student->getCourseCount().toInt() << std::endl;
    
    // toString
    std::cout << student->toString().getValue() << std::endl;
}

// 示例4: 引用共享
void test_reference_sharing() {
    std::cout << "\n=== 示例4: 引用共享 ===" << std::endl;
    
    // 创建对象
    ObjectPtr<Student> student1 = Student::create(String("Bob"), Int(22));
    student1->addCourse(String("Programming"));
    
    // 共享引用
    ObjectPtr<Student> student2 = student1;
    
    // 通过student2添加课程
    student2->addCourse(String("Database"));
    
    // student1也能看到更新
    std::cout << "Student1 courses: " << student1->getCourseCount().toInt() << std::endl;
    std::cout << "Student2 courses: " << student2->getCourseCount().toInt() << std::endl;
    
    std::cout << "Both reference the same object!" << std::endl;
}

// 示例5: 容器存储ObjectPtr（使用数组模拟）
void test_container_with_objectptr() {
    std::cout << "\n=== 示例5: 管理多个对象 ===" << std::endl;
    
    // 创建多个学生对象
    ObjectPtr<Student> alice = Student::create(String("Alice"), Int(20));
    ObjectPtr<Student> bob = Student::create(String("Bob"), Int(22));
    ObjectPtr<Student> charlie = Student::create(String("Charlie"), Int(21));
    
    alice->addCourse(String("Math"));
    bob->addCourse(String("Physics"));
    charlie->addCourse(String("Chemistry"));
    
    std::cout << "Student 1: " << alice->toString().getValue() << std::endl;
    std::cout << "Student 2: " << bob->toString().getValue() << std::endl;
    std::cout << "Student 3: " << charlie->toString().getValue() << std::endl;
    
    // 注意：由于模板实例化限制，不能直接使用 List<ObjectPtr<Student>>
    // 这需要在object.cpp中显式实例化，但那里不知道Student类
    // 实际项目中，可以使用std::vector<ObjectPtr<Student>>或者
    // 将所有自定义类定义在独立的模块中
}

// 示例6: 函数参数和返回值
ObjectPtr<Student> createStudentWithCourses(
    const String& name, 
    const Int& age, 
    const List<String>& courses) {  // List作为const引用传递
    
    ObjectPtr<Student> student = Student::create(name, age);
    
    // 添加所有课程
    courses.forEach([&student](const String& course) {
        student->addCourse(course);
    });
    
    return student;  // 返回ObjectPtr
}

void test_function_parameters() {
    std::cout << "\n=== 示例6: 函数参数和返回值 ===" << std::endl;
    
    // 准备课程列表
    List<String> courses;
    courses.add(String("Math"));
    courses.add(String("Science"));
    courses.add(String("History"));
    
    // 调用函数
    ObjectPtr<Student> student = createStudentWithCourses(
        String("David"),
        Int(23),
        courses
    );
    
    std::cout << "Created: " << student->toString().getValue() << std::endl;
}

// 示例7: 使用基础类型的Map
void test_composition() {
    std::cout << "\n=== 示例7: 组合使用 ===" << std::endl;
    
    // 使用Map存储学生ID到姓名的映射
    Map<String, String> studentMap;
    
    studentMap.put(String("STU001"), String("Alice"));
    studentMap.put(String("STU002"), String("Bob"));
    studentMap.put(String("STU003"), String("Charlie"));
    
    std::cout << "Students in map: " << studentMap.size().toInt() << std::endl;
    
    // 查询学生
    if (studentMap.containsKey(String("STU001")).value) {
        String name = studentMap[String("STU001")];
        std::cout << "Found: " << name.getValue() << std::endl;
    }
    
    // 遍历所有学生
    std::cout << "All students:" << std::endl;
    studentMap.forEach([](const String& id, const String& name) {
        std::cout << "  " << id.getValue() << ": " << name.getValue() << std::endl;
    });
}

// 示例8: 空指针检查
void test_null_check() {
    std::cout << "\n=== 示例8: 空指针检查 ===" << std::endl;
    
    ObjectPtr<Student> student;  // 默认为null
    
    // 安全检查
    if (student.isNull().value) {
        std::cout << "Student is null" << std::endl;
    }
    
    // 创建对象
    student = Student::create(String("Eve"), Int(19));
    
    if (student.isNotNull().value) {
        std::cout << "Student is not null: " 
                  << student->getName().getValue() << std::endl;
    }
}

// 示例9: 迭代器使用
void test_iterator_usage() {
    std::cout << "\n=== 示例9: 迭代器使用 ===" << std::endl;
    
    List<Int> numbers;
    for (int i = 1; i <= 5; i++) {
        numbers.add(Int(i));
    }
    
    // 使用迭代器
    std::cout << "Using iterator: ";
    ListIterator<Int> iter = numbers.iterator();
    while (iter.hasNext().value) {
        Int value = iter.next();
        std::cout << value.toInt() << " ";
    }
    std::cout << std::endl;
    
    // 使用forEach（推荐）
    std::cout << "Using forEach: ";
    numbers.forEach([](const Int& n) {
        std::cout << n.toInt() << " ";
    });
    std::cout << std::endl;
}

// 示例10: 性能考虑
void test_performance_considerations() {
    std::cout << "\n=== 示例10: 性能考虑 ===" << std::endl;
    
    // 场景1: 小容器，局部使用 - 值语义高效
    {
        List<Int> smallList;
        for (int i = 0; i < 10; i++) {
            smallList.add(Int(i));
        }
        // 自动析构，无开销
    }
    
    // 场景2: 需要共享 - 使用ObjectPtr避免拷贝
    {
        ObjectPtr<Student> sharedStudent = 
            Student::create(String("Shared"), Int(25));
        
        // 可以被多处引用，无拷贝
        ObjectPtr<Student> ref1 = sharedStudent;
        ObjectPtr<Student> ref2 = sharedStudent;
        // 引用计数管理
    }
    
    std::cout << "Performance test completed" << std::endl;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << "类型系统最佳实践示例" << std::endl;
    std::cout << "========================================" << std::endl;
    
    try {
        test_basic_types();
        test_containers_value_semantics();
        test_custom_class();
        test_reference_sharing();
        test_container_with_objectptr();
        test_function_parameters();
        test_composition();
        test_null_check();
        test_iterator_usage();
        test_performance_considerations();
        
        std::cout << "\n========================================" << std::endl;
        std::cout << "所有示例完成！" << std::endl;
        std::cout << "========================================" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "错误: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}

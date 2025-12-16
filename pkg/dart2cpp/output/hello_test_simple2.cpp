#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Person
// ============================================================================

class Person {
public:
  String name;
  Int age;
  Person(String name, Int age) : name(name), age(age) {
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->name).toString(), dart_string("，今年 "), (this->age).toString(), dart_string(" 岁。")));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("Person{name: "), (this->name).toString(), dart_string(", age: "), (this->age).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: Student
// ============================================================================

class Student : public Person {
public:
  String major;
  Student(String name, Int age, String major) : major(major), Person(name, age) {
  }
  
  Nullable study() {
    dart_print(dart_concat((this->name).toString(), dart_string(" 正在学习 "), (this->major).toString(), dart_string("。")));
return Void;
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->name).toString(), dart_string("，今年 "), (this->age).toString(), dart_string(" 岁，专业是 "), (this->major).toString(), dart_string("。")));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("Student{name: "), (this->name).toString(), dart_string(", age: "), (this->age).toString(), dart_string(", major: "), (this->major).toString(), dart_string("}"));
  }
  
};

Nullable testBasicTypes();
Nullable testControlFlow();
Nullable testFunctions();
Nullable testSimpleCollections();
Nullable testClasses();
Nullable testBasicTypes() {
  dart_print(dart_string("\n--- 基本数据类型 ---"));
auto age = dart_int(25);
auto price = dart_double(99.99);
auto quantity = dart_int(10);
auto name = dart_string("张三");
auto message = dart_string("你好，世界！");
auto multiline = dart_string("这是单行字符串");
auto isStudent = dart_bool(true);
auto isEmployed = dart_bool(false);
dart_print(dart_concat(dart_string("姓名: "), (name).toString(), dart_string(", 年龄: "), (age).toString()));
dart_print(dart_concat(dart_string("价格: "), (price).toString(), dart_string(", 数量: "), (quantity).toString()));
dart_print(dart_concat(dart_string("学生: "), (isStudent).toString(), dart_string(", 就业: "), (isEmployed).toString()));
dart_print(dart_string("消息: ") + (message).toString());
return Void;
}

Nullable testControlFlow() {
  dart_print(dart_string("\n--- 控制流 ---"));
auto score = dart_int(85);
if (score->operator_greater_equals(dart_int(90))) {
dart_print(dart_string("优秀"));
} else {
if (score->operator_greater_equals(dart_int(80))) {
dart_print(dart_string("良好"));
} else {
if (score->operator_greater_equals(dart_int(60))) {
dart_print(dart_string("及格"));
} else {
dart_print(dart_string("不及格"));
}
}
}
auto grade = dart_string("B");
if (grade == dart_string("A")) {
  dart_print(dart_string("优秀"));
} else if (grade == dart_string("B")) {
  dart_print(dart_string("良好"));
} else if (grade == dart_string("C")) {
  dart_print(dart_string("及格"));
}else {
  dart_print(dart_string("未知等级"));
}
dart_print(dart_string("For 循环:"));
for (auto i = dart_int(0); i->operator_less(dart_int(5)); i = i->operator_add(dart_int(1))) {
dart_print(dart_string("数字: ") + (i).toString());
}
auto fruits = dart_literal(dart_string("苹果"), dart_string("香蕉"), dart_string("橙子"));
dart_print(dart_string("For-in 循环:"));
auto sync_for_iterator = fruits->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto fruit = sync_for_iterator->next();
dart_print(dart_string("水果: ") + (fruit).toString());
}
dart_print(dart_string("While 循环:"));
auto count = dart_int(3);
while (count->operator_greater(dart_int(0))) {
dart_print(dart_string("倒计时: ") + (count).toString());
count = count->operator_sub(dart_int(1));
}
dart_print(dart_string("Do-while 循环:"));
auto number = dart_int(1);
do {
dart_print(dart_string("数字: ") + (number).toString());
number = number->operator_mul(dart_int(2));
} while ((number->operator_less_equals(dart_int(10))).toBool());
return Void;
}

Nullable testFunctions() {
  dart_print(dart_string("\n--- 函数 ---"));
dart_print(dart_string("函数测试完成"));
return Void;
}

Nullable testSimpleCollections() {
  dart_print(dart_string("\n--- 简单集合类型 ---"));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto names = dart_literal(dart_string("张三"), dart_string("李四"), dart_string("王五"));
dart_print(dart_string("数字列表: ") + (numbers).toString());
dart_print(dart_string("姓名列表: ") + (names).toString());
dart_print(dart_string("列表长度: ") + (numbers->size()).toString());
dart_print(dart_string("列表第一个元素: ") + (numbers->first()).toString());
dart_print(dart_string("列表最后一个元素: ") + (numbers->last()).toString());
numbers->add(dart_int(6));
dart_print(dart_string("添加元素后: ") + (numbers).toString());
return Void;
}

Nullable testClasses() {
  dart_print(dart_string("\n--- 类和对象 ---"));
auto person = ObjectPtr<Person>(new Person(dart_string("张三"), dart_int(25)));
dart_print(dart_string("个人信息: ") + (person->toString()).toString());
person->introduce();
dart_print(dart_string("姓名: ") + (person->name).toString());
dart_print(dart_string("年龄: ") + (person->age).toString());
person->age = dart_int(26);
dart_print(dart_string("一年后的年龄: ") + (person->age).toString());
auto student = ObjectPtr<Student>(new Student(dart_string("李四"), dart_int(20), dart_string("计算机科学")));
dart_print(dart_string("学生信息: ") + (student->toString()).toString());
student->study();
student->introduce();
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 Dart 基础语法测试开始"));
testBasicTypes();
testControlFlow();
testFunctions();
testSimpleCollections();
testClasses();
dart_print(dart_string("✅ Dart 基础语法测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

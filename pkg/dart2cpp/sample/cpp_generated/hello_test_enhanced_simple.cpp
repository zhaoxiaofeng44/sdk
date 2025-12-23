#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: SimplePerson
// ============================================================================

class SimplePerson {
private:
  String _name;
  Int _age;
public:
  SimplePerson(String _name, Int _age) : _name(_name), _age(_age) {
  }
  
  String getName() {
    return this->_name;
  }
  
  String setName(String value) {
    return this->_name = value;
  }
  
  Int getAge() {
    return this->_age;
  }
  
  Int setAge(Int value) {
    return this->_age = value;
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->_name).toString(), dart_string("，今年 "), (this->_age).toString(), dart_string(" 岁。")));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("SimplePerson{name: "), (this->_name).toString(), dart_string(", age: "), (this->_age).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: SimpleBox
// ============================================================================

template<typename T>
class SimpleBox {
private:
  T _value;
public:
  SimpleBox(T _value) : _value(_value) {
  }
  
  T getValue() {
    return this->_value;
  }
  
  T setValue(T value) {
    return this->_value = value;
  }
  
};

Nullable testBasicTypes();
Nullable testControlFlow();
Nullable testSimpleFunctions();
Nullable testSimpleCollections();
Nullable testSimpleClasses();
Nullable testSimpleGenerics();
Nullable testSimpleExceptions();
Nullable testBasicTypes() {
  dart_print(dart_string("\n--- 基本数据类型 ---"));
auto age = dart_int(25);
auto price = dart_double(99.99);
auto quantity = dart_int(10);
auto name = dart_string("张三");
auto message = dart_string("你好，世界！");
auto isStudent = dart_bool(true);
auto isEmployed = dart_bool(false);
dart_print(dart_string("基本类型测试完成"));
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
auto fruits = dart_literal<String>(dart_string("苹果"), dart_string("香蕉"), dart_string("橙子"));
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
auto testAge = dart_int(25);
auto isAdult = testAge->operator_greater_equals(dart_int(18)) ? dart_bool(true) : dart_bool(false);
dart_print(dart_string("成年人: ") + (isAdult).toString());
return Void;
}

Nullable testSimpleFunctions() {
  dart_print(dart_string("\n--- 简化函数 ---"));
auto greet = [&](String name) { return dart_concat(dart_string("你好, "), (name).toString(), dart_string("!")); };
auto add = [&](Int a, Int b) { return a->operator_add(b); };
dart_print(greet(dart_string("李四")));
dart_print(dart_string("加法结果: ") + (add(dart_int(5), dart_int(3))).toString());
return Void;
}

Nullable testSimpleCollections() {
  dart_print(dart_string("\n--- 简化集合 ---"));
auto numbers = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto names = dart_literal<String>(dart_string("张三"), dart_string("李四"), dart_string("王五"));
auto scores = Map<String, Int>::createFromEntries({{dart_string("张三"), dart_int(95)}, {dart_string("李四"), dart_int(87)}, {dart_string("王五"), dart_int(92)}});
dart_print(dart_string("数字列表长度: ") + (numbers->size()).toString());
dart_print(dart_string("第一个数字: ") + (numbers->first()).toString());
dart_print(dart_string("最后一个数字: ") + (numbers->last()).toString());
numbers->add(dart_int(6));
dart_print(dart_string("添加元素后列表长度: ") + (numbers->size()).toString());
dart_print(dart_string("张三的分数: ") + (scores->operator_index(dart_string("张三"))).toString());
scores->operator_index_set(dart_string("赵六"), dart_int(88));
dart_print(dart_string("更新后的分数数量: ") + (scores->size()).toString());
return Void;
}

Nullable testSimpleClasses() {
  dart_print(dart_string("\n--- 简化类 ---"));
auto person = ObjectPtr<SimplePerson>(new SimplePerson(dart_string("张三"), dart_int(25)));
dart_print(dart_string("创建Person对象"));
person->introduce();
dart_print(dart_string("姓名: ") + (person->getName()).toString());
person->setName(dart_string("李四"));
dart_print(dart_string("更新后姓名: ") + (person->getName()).toString());
return Void;
}

Nullable testSimpleGenerics() {
  dart_print(dart_string("\n--- 简化泛型 ---"));
auto stringBox = ObjectPtr<SimpleBox<String>>(new SimpleBox<String>(dart_string("Hello")));
auto intBox = ObjectPtr<SimpleBox<Int>>(new SimpleBox<Int>(dart_int(42)));
dart_print(dart_string("字符串盒子内容: ") + (stringBox->getValue()).toString());
dart_print(dart_string("整数盒子内容: ") + (intBox->getValue()).toString());
return Void;
}

Nullable testSimpleExceptions() {
  dart_print(dart_string("\n--- 简化异常处理 ---"));
try {
auto result = dart_int(10)->truncatingDivision(dart_int(2));
dart_print(dart_string("结果: ") + (result).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("异常处理测试完成"));
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 Dart 简化增强语法测试开始"));
testBasicTypes();
testControlFlow();
testSimpleFunctions();
testSimpleCollections();
testSimpleClasses();
testSimpleGenerics();
testSimpleExceptions();
dart_print(dart_string("✅ Dart 简化增强语法测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

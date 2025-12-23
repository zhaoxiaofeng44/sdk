#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: FinalPerson
// ============================================================================

class FinalPerson {
private:
  String _name;
  Int _age;
public:
  FinalPerson(String _name, Int _age) : _name(_name), _age(_age) {
  }
  
  String getName() {
    return this->_name;
  }
  
  Int getAge() {
    return this->_age;
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->_name).toString(), dart_string("，今年 "), (this->_age).toString(), dart_string(" 岁。")));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("FinalPerson{name: "), (this->_name).toString(), dart_string(", age: "), (this->_age).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: FinalStudent
// ============================================================================

class FinalStudent : public FinalPerson {
private:
  String _major;
public:
  FinalStudent(String name, Int age, String _major) : _major(_major), FinalPerson(name, age) {
  }
  
  String getMajor() {
    return this->_major;
  }
  
  Nullable study() {
    dart_print(dart_concat((this->getName()).toString(), dart_string(" 正在学习 "), (this->_major).toString()));
return Void;
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->getName()).toString(), dart_string("，今年 "), (this->getAge()).toString(), dart_string(" 岁，专业是 "), (this->_major).toString(), dart_string("。")));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("FinalStudent{name: "), (this->getName()).toString(), dart_string(", age: "), (this->getAge()).toString(), dart_string(", major: "), (this->_major).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: FinalContainer
// ============================================================================

template<typename T>
class FinalContainer {
private:
  T _value;
public:
  FinalContainer(T _value) : _value(_value) {
  }
  
  T getValue() {
    return this->_value;
  }
  
  T setValue(T newValue) {
    return this->_value = newValue;
  }
  
};

Nullable testDataTypes();
Nullable testFinalControlFlow();
Nullable testFinalFunctions();
Nullable testFinalCollections();
Nullable testFinalClasses();
Nullable testFinalGenerics();
Nullable testDataTypes() {
  dart_print(dart_string("\n--- 数据类型和操作 ---"));
auto age = dart_int(25);
auto price = dart_double(99.99);
auto name = dart_string("张三");
auto isStudent = dart_bool(true);
auto info = dart_concat(dart_string("姓名: "), (name).toString(), dart_string(", 年龄: "), (age).toString());
auto strLength = name->size();
auto ageStr = age->toString();
dart_print(dart_string("数据类型操作完成"));
return Void;
}

Nullable testFinalControlFlow() {
  dart_print(dart_string("\n--- 最终控制流 ---"));
auto score = dart_int(85);
if (score == dart_int(100) || score == dart_int(90)) {
  dart_print(dart_string("优秀"));
} else if (score == dart_int(80)) {
  dart_print(dart_string("良好"));
}else {
  dart_print(dart_string("其他分数"));
}
dart_print(dart_string("正序循环:"));
for (auto i = dart_int(1); i->operator_less_equals(dart_int(3)); i = i->operator_add(dart_int(1))) {
dart_print(dart_string("数字: ") + (i).toString());
}
auto fruits = dart_literal<String>(dart_string("苹果"), dart_string("香蕉"), dart_string("橙子"));
dart_print(dart_string("水果列表:"));
auto sync_for_iterator = fruits->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto fruit = sync_for_iterator->next();
dart_print(dart_string("  ") + (fruit).toString());
}
auto testAge = dart_int(20);
auto description = testAge->operator_greater_equals(dart_int(18)) ? dart_string("成年人") : dart_string("未成年人");
dart_print(dart_string("年龄描述: ") + (description).toString());
return Void;
}

Nullable testFinalFunctions() {
  dart_print(dart_string("\n--- 最终函数特性 ---"));
auto greetName = [&](String name) { return dart_concat(dart_string("你好, "), (name).toString(), dart_string("!")); };
auto addNumbers = [&](Int a, Int b) { return a->operator_add(b); };
auto greeting = greetName(dart_string("李四"));
auto sum = addNumbers(dart_int(1), dart_int(2));
dart_print(dart_string("问候语: ") + (greeting).toString());
dart_print(dart_string("两数之和: ") + (sum).toString());
return Void;
}

Nullable testFinalCollections() {
  dart_print(dart_string("\n--- 最终集合特性 ---"));
auto numbers = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("列表长度: ") + (numbers->size()).toString());
numbers->add(dart_int(6));
dart_print(dart_string("添加元素后长度: ") + (numbers->size()).toString());
auto scores = Map<String, Int>::createFromEntries({{dart_string("张三"), dart_int(95)}, {dart_string("李四"), dart_int(87)}});
dart_print(dart_string("映射大小: ") + (scores->size()).toString());
dart_print(dart_string("张三的分数: ") + (scores->operator_index(dart_string("张三"))).toString());
return Void;
}

Nullable testFinalClasses() {
  dart_print(dart_string("\n--- 最终类特性 ---"));
auto person = ObjectPtr<FinalPerson>(new FinalPerson(dart_string("张三"), dart_int(25)));
dart_print(dart_string("创建FinalPerson对象"));
person->introduce();
dart_print(dart_string("姓名: ") + (person->getName()).toString());
auto student = ObjectPtr<FinalStudent>(new FinalStudent(dart_string("王五"), dart_int(20), dart_string("计算机科学")));
dart_print(dart_string("创建FinalStudent对象"));
student->study();
student->introduce();
return Void;
}

Nullable testFinalGenerics() {
  dart_print(dart_string("\n--- 最终泛型特性 ---"));
auto stringContainer = ObjectPtr<FinalContainer<String>>(new FinalContainer<String>(dart_string("Hello")));
auto intContainer = ObjectPtr<FinalContainer<Int>>(new FinalContainer<Int>(dart_int(42)));
dart_print(dart_string("字符串容器值: ") + (stringContainer->getValue()).toString());
dart_print(dart_string("整数容器值: ") + (intContainer->getValue()).toString());
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 Dart 最终增强语法测试开始"));
testDataTypes();
testFinalControlFlow();
testFinalFunctions();
testFinalCollections();
testFinalClasses();
testFinalGenerics();
dart_print(dart_string("✅ Dart 最终增强语法测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

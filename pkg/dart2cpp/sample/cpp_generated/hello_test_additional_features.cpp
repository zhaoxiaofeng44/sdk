#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: AdditionalPerson
// ============================================================================

class AdditionalPerson {
private:
  String _name;
  Int _age;
public:
  AdditionalPerson(String _name, Int _age) : _name(_name), _age(_age) {
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
    return dart_concat(dart_string("AdditionalPerson{name: "), (this->_name).toString(), dart_string(", age: "), (this->_age).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: AdditionalStudent
// ============================================================================

class AdditionalStudent : public AdditionalPerson {
private:
  String _major;
public:
  AdditionalStudent(String name, Int age, String _major) : _major(_major), AdditionalPerson(name, age) {
  }
  
  String getMajor() {
    return this->_major;
  }
  
  String setMajor(String value) {
    return this->_major = value;
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
    return dart_concat(dart_string("AdditionalStudent{name: "), (this->getName()).toString(), dart_string(", age: "), (this->getAge()).toString(), dart_string(", major: "), (this->_major).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: GenericHolder
// ============================================================================

template<typename T>
class GenericHolder {
private:
  T _value;
public:
  GenericHolder(T _value) : _value(_value) {
  }
  
  T getValue() {
    return this->_value;
  }
  
  T setValue(T newValue) {
    return this->_value = newValue;
  }
  
};

Nullable testDataTypes();
Nullable testAdditionalControlFlow();
Nullable testAdditionalFunctions();
Nullable testAdditionalCollections();
Nullable testAdditionalClasses();
Nullable testAdditionalGenerics();
Nullable testSimpleExceptionHandling();
Nullable testSimpleNullSafety();
template<typename T>
T getFirst(ObjectPtr<List<T>> list);
Nullable testDataTypes() {
  dart_print(dart_string("\n--- 数据类型和操作 ---"));
auto age = dart_int(25);
auto price = dart_double(99.99);
auto name = dart_string("张三");
auto isStudent = dart_bool(true);
auto info = dart_concat(dart_string("姓名: "), (name).toString(), dart_string(", 年龄: "), (age).toString());
auto upper = name->toUpperCase();
auto lower = name->toLowerCase();
auto strLength = name->size();
auto ageStr = age->toString();
auto priceInt = price->toInt();
dart_print(dart_string("数据类型操作完成"));
return Void;
}

Nullable testAdditionalControlFlow() {
  dart_print(dart_string("\n--- 附加控制流特性 ---"));
auto score = dart_int(85);
if (score == dart_int(100) || score == dart_int(99) || score == dart_int(98)) {
  dart_print(dart_string("满分"));
} else if (score == dart_int(90) || score == dart_int(89) || score == dart_int(88) || score == dart_int(87) || score == dart_int(86) || score == dart_int(85)) {
  dart_print(dart_string("优秀"));
} else if (score == dart_int(80) || score == dart_int(79) || score == dart_int(78)) {
  dart_print(dart_string("良好"));
}else {
  dart_print(dart_string("其他分数"));
}
dart_print(dart_string("倒序循环:"));
for (auto i = dart_int(5); i->operator_greater_equals(dart_int(1)); i = i->operator_sub(dart_int(1))) {
dart_print(dart_string("数字: ") + (i).toString());
}
auto fruits = dart_literal<String>(dart_string("苹果"), dart_string("香蕉"), dart_string("橙子"));
dart_print(dart_string("水果列表:"));
auto sync_for_iterator = fruits->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto fruit = sync_for_iterator->next();
dart_print(dart_string("  ") + (fruit).toString());
}
auto counter = dart_int(0);
while (counter->operator_less(dart_int(3))) {
dart_print(dart_string("While循环: ") + (counter).toString());
counter = counter->operator_add(dart_int(1));
}
auto doCounter = dart_int(0);
do {
dart_print(dart_string("Do-while循环: ") + (doCounter).toString());
doCounter = doCounter->operator_add(dart_int(1));
} while ((doCounter->operator_less(dart_int(3))).toBool());
auto testAge = dart_int(20);
auto description = testAge->operator_greater_equals(dart_int(18)) ? dart_string("成年人") : dart_string("未成年人");
dart_print(dart_string("年龄描述: ") + (description).toString());
return Void;
}

Nullable testAdditionalFunctions() {
  dart_print(dart_string("\n--- 附加函数特性 ---"));
auto greet = [&](String name) { return dart_concat(dart_string("你好, "), (name).toString(), dart_string("!")); };
auto addThreeNumbers = [&](Int a, Int b, Int c) { return a->operator_add(b)->operator_add(c); };
auto greeting = greet(dart_string("李四"));
auto sum = addThreeNumbers(dart_int(1), dart_int(2), dart_int(3));
dart_print(dart_string("问候语: ") + (greeting).toString());
dart_print(dart_string("三数之和: ") + (sum).toString());
return Void;
}

Nullable testAdditionalCollections() {
  dart_print(dart_string("\n--- 附加集合特性 ---"));
auto numbers = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("列表长度: ") + (numbers->size()).toString());
dart_print(dart_string("第一个元素: ") + (numbers->first()).toString());
dart_print(dart_string("最后一个元素: ") + (numbers->last()).toString());
numbers->add(dart_int(6));
numbers->addAll(dart_literal<Int>(dart_int(7), dart_int(8)));
dart_print(dart_string("添加元素后长度: ") + (numbers->size()).toString());
auto scores = Map<String, Int>::createFromEntries({{dart_string("张三"), dart_int(95)}, {dart_string("李四"), dart_int(87)}, {dart_string("王五"), dart_int(92)}});
dart_print(dart_string("映射大小: ") + (scores->size()).toString());
dart_print(dart_string("张三的分数: ") + (scores->operator_index(dart_string("张三"))).toString());
scores->operator_index_set(dart_string("赵六"), dart_int(88));
dart_print(dart_string("更新后映射大小: ") + (scores->size()).toString());
return Void;
}

Nullable testAdditionalClasses() {
  dart_print(dart_string("\n--- 附加类特性 ---"));
auto person = ObjectPtr<AdditionalPerson>(new AdditionalPerson(dart_string("张三"), dart_int(25)));
dart_print(dart_string("创建AdditionalPerson对象: ") + (person).toString());
person->introduce();
dart_print(dart_string("姓名: ") + (person->getName()).toString());
person->setName(dart_string("李四"));
dart_print(dart_string("更新后姓名: ") + (person->getName()).toString());
auto student = ObjectPtr<AdditionalStudent>(new AdditionalStudent(dart_string("王五"), dart_int(20), dart_string("计算机科学")));
dart_print(dart_string("创建AdditionalStudent对象: ") + (student).toString());
student->study();
student->introduce();
return Void;
}

Nullable testAdditionalGenerics() {
  dart_print(dart_string("\n--- 附加泛型特性 ---"));
auto stringHolder = ObjectPtr<GenericHolder<String>>(new GenericHolder<String>(dart_string("Hello")));
auto intHolder = ObjectPtr<GenericHolder<Int>>(new GenericHolder<Int>(dart_int(42)));
dart_print(dart_string("字符串持有者值: ") + (stringHolder->getValue()).toString());
dart_print(dart_string("整数持有者值: ") + (intHolder->getValue()).toString());
auto numbers = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3));
auto strings = dart_literal<String>(dart_string("a"), dart_string("b"), dart_string("c"));
auto firstNumber = getFirst(numbers);
auto firstString = getFirst(strings);
dart_print(dart_string("第一个数字: ") + (firstNumber).toString());
dart_print(dart_string("第一个字符串: ") + (firstString).toString());
return Void;
}

Nullable testSimpleExceptionHandling() {
  dart_print(dart_string("\n--- 简单异常处理 ---"));
try {
auto result = dart_int(10)->truncatingDivision(dart_int(3));
dart_print(dart_string("整数除法结果: ") + (result).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("异常处理完成"));
return Void;
}

Nullable testSimpleNullSafety() {
  dart_print(dart_string("\n--- 简单空安全特性 ---"));
auto nullableString = dart_string("Hello");
auto nullString = Null;
auto nonNull1 = dart_null_coalesce(nullableString, dart_string("default"));
auto nonNull2 = dart_null_coalesce(nullString, dart_string("default"));
dart_print(dart_concat(dart_string("空值合并结果: "), (nonNull1).toString(), dart_string(", "), (nonNull2).toString()));
auto nullableList = dart_literal<String>(dart_string("a"), dart_string("b"), dart_string("c"));
auto length1 = dart_null_coalesce(nullableList, Null);
dart_print(dart_string("列表长度: ") + (length1).toString());
return Void;
}

template<typename T>
T getFirst(ObjectPtr<List<T>> list) {
  if (list->isEmpty()) {
throw DartException(Exception::create(dart_string("列表为空")));
}
return list->operator_index(dart_int(0));
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 Dart 附加特性测试开始"));
testDataTypes();
testAdditionalControlFlow();
testAdditionalFunctions();
testAdditionalCollections();
testAdditionalClasses();
testAdditionalGenerics();
testSimpleExceptionHandling();
testSimpleNullSafety();
dart_print(dart_string("✅ Dart 附加特性测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

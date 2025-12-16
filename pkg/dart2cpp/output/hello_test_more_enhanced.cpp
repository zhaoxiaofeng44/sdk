#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: MorePerson
// ============================================================================

class MorePerson {
public:
  String name;
  Int age;
  Int instanceCount = dart_int(0);
  MorePerson(String name, Int age) : name(name), age(age) {
    MorePerson::instanceCount = MorePerson::instanceCount->operator_add(dart_int(1));
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->name).toString(), dart_string("，今年 "), (this->age).toString(), dart_string(" 岁。")));
return Void;
  }
  
  Nullable logCreation() {
    dart_print(dart_string("创建了一个新的Person实例"));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("MorePerson{name: "), (this->name).toString(), dart_string(", age: "), (this->age).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: Student
// ============================================================================

class Student : public MorePerson {
public:
  String major;
  Student(String name, Int age, String major) : major(major), MorePerson(name, age) {
  }
  
  Nullable study() {
    dart_print(dart_concat((this->name).toString(), dart_string(" 正在学习 "), (this->major).toString()));
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

// ============================================================================
// 类: GenericContainer
// ============================================================================

template<typename T>

class GenericContainer {
public:
  T value;
  GenericContainer(T value) : value(value) {
  }
  
  T getValue() {
    return this->value;
  }
  
  Nullable setValue(T newValue) {
    return this->value = newValue;
  }
  
};

// ============================================================================
// 类: Color
// ============================================================================

class Color : public _Enum {
public:
  ObjectPtr<Color> red = ObjectPtr<Color>::createConst();
  ObjectPtr<Color> green = ObjectPtr<Color>::createConst();
  ObjectPtr<Color> blue = ObjectPtr<Color>::createConst();
  ObjectPtr<List<ObjectPtr<Color>>> values = List<ObjectPtr<Color>>::createConst({ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst()});
  Color(Int _index, String _name) : _Enum(index, name) {
  }
  
  String _enumToString() {
    return dart_string("Color.") + (this->_name).toString();
  }
  
};

Nullable testDataTypes();
Nullable testMoreControlFlow();
Nullable testMoreFunctions();
Nullable testMoreCollections();
Nullable testMoreClasses();
Nullable testMoreGenerics();
Nullable testExceptionHandling();
Nullable testNullSafety();
Nullable testAdvancedFeatures();
template<typename T>
T getFirstElement(ObjectPtr<List<T>> list);
Nullable testDataTypes() {
  dart_print(dart_string("\n--- 数据类型和操作 ---"));
auto age = dart_int(25);
auto price = dart_double(99.99);
auto name = dart_string("张三");
auto isStudent = dart_bool(true);
auto info = dart_concat(dart_string("姓名: "), (name).toString(), dart_string(", 年龄: "), (age).toString());
auto formatted = dart_string("价格: ") + (price->toStringAsFixed(dart_int(2))).toString();
auto upper = name->toUpperCase();
auto lower = name->toLowerCase();
auto strLength = name->size();
auto ageStr = age->toString();
auto priceInt = price->toInt();
auto ageDouble = age->toDouble();
dart_print(dart_string("数据类型操作完成"));
return Void;
}

Nullable testMoreControlFlow() {
  dart_print(dart_string("\n--- 更多控制流 ---"));
auto score = dart_int(85);
if (score == dart_int(100) || score == dart_int(99) || score == dart_int(98)) {
  dart_print(dart_string("满分"));
} else if (score == dart_int(90) || score == dart_int(89) || score == dart_int(88) || score == dart_int(87) || score == dart_int(86) || score == dart_int(85)) {
  dart_print(dart_string("优秀"));
}else {
  dart_print(dart_string("其他分数"));
}
dart_print(dart_string("倒序循环:"));
for (auto i = dart_int(5); i->operator_greater_equals(dart_int(1)); i = i->operator_sub(dart_int(1))) {
dart_print(dart_string("数字: ") + (i).toString());
}
auto fruits = dart_literal(dart_string("苹果"), dart_string("香蕉"), dart_string("橙子"));
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

Nullable testMoreFunctions() {
  dart_print(dart_string("\n--- 更多函数特性 ---"));
auto greeter = makeFunction([&](String name) { return dart_concat(dart_string("你好, "), (name).toString(), dart_string("!")); });
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto doubled = numbers->map(makeFunction([&](Int n) { return n->operator_mul(dart_int(2)); }))->toList();
auto evens = numbers->where(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }))->toList();
dart_print(dart_string("映射结果: ") + (doubled).toString());
dart_print(dart_string("过滤结果: ") + (evens).toString());
auto add = [&](Int a, Int b) -> Int return a->operator_add(b);;
auto multiply = [&](Int a, Int b) -> Int return a->operator_mul(b);;
dart_print(dart_string("加法结果: ") + (add(dart_int(3), dart_int(4))).toString());
dart_print(dart_string("乘法结果: ") + (multiply(dart_int(3), dart_int(4))).toString());
return Void;
}

Nullable testMoreCollections() {
  dart_print(dart_string("\n--- 更多集合特性 ---"));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("列表长度: ") + (numbers->size()).toString());
dart_print(dart_string("第一个元素: ") + (numbers->first()).toString());
dart_print(dart_string("最后一个元素: ") + (numbers->last()).toString());
numbers->add(dart_int(6));
numbers->addAll(dart_literal(dart_int(7), dart_int(8)));
dart_print(dart_string("添加元素后长度: ") + (numbers->size()).toString());
auto scores = Map<String, Int>::createFromEntries({{dart_string("张三"), dart_int(95)}, {dart_string("李四"), dart_int(87)}, {dart_string("王五"), dart_int(92)}});
dart_print(dart_string("映射大小: ") + (scores->size()).toString());
dart_print(dart_string("张三的分数: ") + (scores->operator_index(dart_string("张三"))).toString());
scores->operator_index_set(dart_string("赵六"), dart_int(88));
scores->addAll(Map<String, Int>::createFromEntries({{dart_string("孙七"), dart_int(90)}, {dart_string("周八"), dart_int(85)}}));
dart_print(dart_string("更新后映射大小: ") + (scores->size()).toString());
auto uniqueNames = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_string("张三")); unnamed_var->add(dart_string("李四")); unnamed_var->add(dart_string("王五")); return unnamed_var; })();
dart_print(dart_string("集合大小: ") + (uniqueNames->size()).toString());
uniqueNames->add(dart_string("赵六"));
dart_print(dart_string("添加后集合大小: ") + (uniqueNames->size()).toString());
return Void;
}

Nullable testMoreClasses() {
  dart_print(dart_string("\n--- 更多类特性 ---"));
auto person = ObjectPtr<MorePerson>(new MorePerson(dart_string("张三"), dart_int(25)));
dart_print(dart_string("创建MorePerson对象: ") + (person).toString());
person->introduce();
MorePerson::logCreation();
dart_print(dart_string("实例计数: ") + (MorePerson::instanceCount).toString());
auto student = ObjectPtr<Student>(new Student(dart_string("李四"), dart_int(20), dart_string("计算机科学")));
dart_print(dart_string("创建Student对象: ") + (student).toString());
student->study();
student->introduce();
return Void;
}

Nullable testMoreGenerics() {
  dart_print(dart_string("\n--- 更多泛型特性 ---"));
auto stringContainer = ObjectPtr<GenericContainer>(new GenericContainer(dart_string("Hello")));
auto intContainer = ObjectPtr<GenericContainer>(new GenericContainer(dart_int(42)));
dart_print(dart_string("字符串容器值: ") + (stringContainer->getValue()).toString());
dart_print(dart_string("整数容器值: ") + (intContainer->getValue()).toString());
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto strings = dart_literal(dart_string("a"), dart_string("b"), dart_string("c"));
auto firstNumber = getFirstElement(numbers);
auto firstString = getFirstElement(strings);
dart_print(dart_string("第一个数字: ") + (firstNumber).toString());
dart_print(dart_string("第一个字符串: ") + (firstString).toString());
return Void;
}

Nullable testExceptionHandling() {
  dart_print(dart_string("\n--- 异常处理 ---"));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ };
return Void;
}

Nullable testNullSafety() {
  dart_print(dart_string("\n--- 空安全特性 ---"));
auto nullableString = dart_string("Hello");
auto nullString = Null;
auto nonNull1 = dart_null_coalesce(nullableString, dart_string("default"));
auto nonNull2 = dart_null_coalesce(nullString, dart_string("default"));
dart_print(dart_concat(dart_string("空值合并结果: "), (nonNull1).toString(), dart_string(", "), (nonNull2).toString()));
auto nullableList = dart_literal(dart_string("a"), dart_string("b"), dart_string("c"));
auto length1 = dart_null_coalesce(nullableList, Null);
dart_print(dart_string("列表长度: ") + (length1).toString());
if (!(dart_is_null(nullableString))) {
auto definitelyNotNull = nullableString;
dart_print(dart_string("断言非空值: ") + (definitelyNotNull).toString());
};
return Void;
}

Nullable testAdvancedFeatures() {
  dart_print(dart_string("\n--- 高级特性 ---"));
auto text = dart_string("hello world");
dart_print(dart_string("扩展方法测试完成"));
dart_print(dart_string("枚举值: ") + (ObjectPtr<Color>::createConst()).toString());
dart_print(dart_string("圆周率: 3.14159"));
return Void;
}

template<typename T>
T getFirstElement(ObjectPtr<List<T>> list) {
  if (list->isEmpty()) {
throw DartException(Exception::(dart_string("列表为空")));
}
return list->operator_index(dart_int(0));
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 Dart 更多增强语法测试开始"));
testDataTypes();
testMoreControlFlow();
testMoreFunctions();
testMoreCollections();
testMoreClasses();
testMoreGenerics();
testExceptionHandling();
testNullSafety();
testAdvancedFeatures();
dart_print(dart_string("✅ Dart 更多增强语法测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

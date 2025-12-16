#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Person
// ============================================================================

class Person {
private:
  String _name;
  Int _age;
public:
  Person(String _name, Int _age) : _name(_name), _age(_age) {
  }
  
  String name() {
    return this->_name;
  }
  
  Nullable name(String value) {
    return this->_name = value;
  }
  
  Int age() {
    return this->_age;
  }
  
  Nullable age(Int value) {
    return this->_age = value;
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->_name).toString(), dart_string("，今年 "), (this->_age).toString(), dart_string(" 岁。")));
return Void;
  }
  
  Nullable logCreation() {
    dart_print(dart_string("创建了一个新的Person实例"));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("Person{name: "), (this->_name).toString(), dart_string(", age: "), (this->_age).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: Shape
// ============================================================================

DART_INTERFACE(Shape)
  DART_ABSTRACT_METHOD(Double, area, ())
DART_INTERFACE_END

// ============================================================================
// 类: Circle
// ============================================================================

class Circle : public Shape {
public:
  Double radius;
  Circle(Double radius) : radius(radius) {
  }
  
  Double area() {
    return dart_double(3.14159)->operator_mul(this->radius)->operator_mul(this->radius);
  }
  
};

// ============================================================================
// 类: Rectangle
// ============================================================================

class Rectangle : public Shape {
public:
  Double width;
  Double height;
  Rectangle(Double width, Double height) : width(width), height(height) {
  }
  
  Double area() {
    return this->width->operator_mul(this->height);
  }
  
};

// ============================================================================
// 类: Flyable
// ============================================================================

DART_INTERFACE(Flyable)
DART_INTERFACE_END

// ============================================================================
// 类: Speakable
// ============================================================================

DART_INTERFACE(Speakable)
DART_INTERFACE_END

// ============================================================================
// 类: Bird
// ============================================================================

class Bird : public _Bird&Object&Flyable&Speakable {
public:
  String name;
  Bird(String name) : name(name) {
  }
  
};

// ============================================================================
// 类: Box
// ============================================================================

template<typename T>

class Box {
private:
  T _value;
public:
  Box(T _value) : _value(_value) {
  }
  
  T getValue() {
    return this->_value;
  }
  
  Nullable setValue(T value) {
    return this->_value = value;
  }
  
};

// ============================================================================
// 类: _Bird&Object&Flyable
// ============================================================================

DART_INTERFACE(_Bird&Object&Flyable)
DART_INTERFACE_END

// ============================================================================
// 类: _Bird&Object&Flyable&Speakable
// ============================================================================

DART_INTERFACE(_Bird&Object&Flyable&Speakable)
DART_INTERFACE_END

Nullable testBasicTypes();
Nullable testControlFlow();
Nullable testEnhancedFunctions();
Nullable testEnhancedCollections();
Nullable testEnhancedClasses();
Nullable testGenerics();
Nullable testExceptions();
Nullable testNullSafety();
template<typename T>
T getFirst(ObjectPtr<List<T>> list);
Nullable validateAge(Int age);
Nullable testBasicTypes() {
  dart_print(dart_string("\n--- 基本数据类型 ---"));
auto age = dart_int(25);
auto price = dart_double(99.99);
auto quantity = dart_int(10);
auto name = dart_string("张三");
auto message = dart_string("你好，世界！");
auto isStudent = dart_bool(true);
auto isEmployed = dart_bool(false);
auto upperMessage = message->toUpperCase();
auto lowerMessage = message->toLowerCase();
auto messageLength = message->size();
dart_print(dart_string("基本类型操作完成"));
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
auto testAge = dart_int(25);
auto isAdult = testAge->operator_greater_equals(dart_int(18)) ? dart_bool(true) : dart_bool(false);
dart_print(dart_string("成年人: ") + (isAdult).toString());
return Void;
}

Nullable testEnhancedFunctions() {
  dart_print(dart_string("\n--- 增强函数 ---"));
auto greet = [&](String name, String greeting) -> String return dart_concat((greeting).toString(), dart_string(", "), (name).toString(), dart_string("!"));;
auto createProfile = [&]() -> String auto profile = dart_string("姓名: ") + (name).toString();
if (!(dart_is_null(age))) {
profile = profile->operator_add(dart_string(", 年龄: ") + (age).toString());
}
if (!(dart_is_null(city))) {
profile = profile->operator_add(dart_string(", 城市: ") + (city).toString());
}
return profile;;
auto calculate = [&](Int a, Int b, ObjectPtr<TypedFunction<std::function<Int(Int, Int)>, Int, Int, Int>> operation) -> Int return operation->call(a, b);;
auto add = [&](Int a, Int b) -> Int return a->operator_add(b);;
auto multiply = [&](Int a, Int b) -> Int return a->operator_mul(b);;
dart_print(greet(dart_string("李四")));
dart_print(greet(dart_string("王五"), dart_string("早上好")));
dart_print(createProfile(/*name:*/ dart_string("赵六"), /*age:*/ dart_int(30), /*city:*/ dart_string("北京")));
auto sum = calculate(dart_int(5), dart_int(3), add);
auto product = calculate(dart_int(5), dart_int(3), multiply);
dart_print(dart_concat(dart_string("计算结果: 和="), (sum).toString(), dart_string(", 积="), (product).toString()));
return Void;
}

Nullable testEnhancedCollections() {
  dart_print(dart_string("\n--- 增强集合 ---"));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto names = dart_literal(dart_string("张三"), dart_string("李四"), dart_string("王五"));
auto scores = Map<String, Int>::createFromEntries({{dart_string("张三"), dart_int(95)}, {dart_string("李四"), dart_int(87)}, {dart_string("王五"), dart_int(92)}});
auto uniqueNames = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_string("张三")); unnamed_var->add(dart_string("李四")); unnamed_var->add(dart_string("王五")); return unnamed_var; })();
dart_print(dart_string("数字列表长度: ") + (numbers->size()).toString());
dart_print(dart_string("第一个数字: ") + (numbers->first()).toString());
dart_print(dart_string("最后一个数字: ") + (numbers->last()).toString());
auto doubled = numbers->map(makeFunction([&](Int n) { return n->operator_mul(dart_int(2)); }))->toList();
auto evens = numbers->where(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }))->toList();
auto total = numbers->reduce(makeFunction([&](Int a, Int b) { return a->operator_add(b); }));
dart_print(dart_string("翻倍后的列表: ") + (doubled).toString());
dart_print(dart_string("偶数列表: ") + (evens).toString());
dart_print(dart_string("数字总和: ") + (total).toString());
dart_print(dart_string("张三的分数: ") + (scores->operator_index(dart_string("张三"))).toString());
scores->operator_index_set(dart_string("赵六"), dart_int(88));
dart_print(dart_string("更新后的分数: ") + (scores).toString());
return Void;
}

Nullable testEnhancedClasses() {
  dart_print(dart_string("\n--- 增强类 ---"));
auto person = ObjectPtr<Person>(new Person(dart_string("张三"), dart_int(25)));
dart_print(dart_string("人员信息: ") + (person->toString()).toString());
Person::logCreation();
dart_print(dart_string("人员姓名: ") + (person->name()).toString());
person->set_name(dart_string("李四"));
dart_print(dart_string("更新后姓名: ") + (person->name()).toString());
auto circle = ObjectPtr<Circle>(new Circle(dart_double(5.0)));
auto rectangle = ObjectPtr<Rectangle>(new Rectangle(dart_double(4.0), dart_double(6.0)));
dart_print(dart_string("圆形面积: ") + (circle->area()).toString());
dart_print(dart_string("矩形面积: ") + (rectangle->area()).toString());
auto bird = ObjectPtr<Bird>(new Bird(dart_string("鹦鹉")));
bird->fly();
bird->speak();
return Void;
}

Nullable testGenerics() {
  dart_print(dart_string("\n--- 泛型 ---"));
auto stringBox = ObjectPtr<Box>(new Box(dart_string("Hello")));
auto intBox = ObjectPtr<Box>(new Box(dart_int(42)));
dart_print(dart_string("字符串盒子内容: ") + (stringBox->getValue()).toString());
dart_print(dart_string("整数盒子内容: ") + (intBox->getValue()).toString());
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto strings = dart_literal(dart_string("a"), dart_string("b"), dart_string("c"));
auto firstNumber = getFirst(numbers);
auto firstString = getFirst(strings);
dart_print(dart_string("第一个数字: ") + (firstNumber).toString());
dart_print(dart_string("第一个字符串: ") + (firstString).toString());
return Void;
}

Nullable testExceptions() {
  dart_print(dart_string("\n--- 异常处理 ---"));
try {
auto result = dart_int(10)->truncatingDivision(dart_int(2));
dart_print(dart_string("结果: ") + (result).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
validateAge(dart_int(-5));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
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
auto definitelyNotNull = nullableString;
dart_print(dart_string("断言非空值: ") + (definitelyNotNull).toString());
return Void;
}

template<typename T>
T getFirst(ObjectPtr<List<T>> list) {
  if (list->isEmpty()) {
throw DartException(Exception::(dart_string("列表为空")));
}
return list->operator_index(dart_int(0));
}

Nullable validateAge(Int age) {
  if (age->operator_less(dart_int(0))) {
throw DartException(Exception::(dart_string("年龄不能为负数")));
}
dart_print(dart_string("有效年龄: ") + (age).toString());
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 Dart 增强语法测试开始"));
testBasicTypes();
testControlFlow();
testEnhancedFunctions();
testEnhancedCollections();
testEnhancedClasses();
testGenerics();
testExceptions();
testNullSafety();
dart_print(dart_string("✅ Dart 增强语法测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

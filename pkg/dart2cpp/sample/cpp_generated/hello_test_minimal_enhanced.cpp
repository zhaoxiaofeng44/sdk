#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: EnhancedPerson
// ============================================================================

class EnhancedPerson {
public:
  String name;
  Int age;
  EnhancedPerson(String name, Int age) : name(name), age(age) {
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->name).toString(), dart_string("，今年 "), (this->age).toString(), dart_string(" 岁。")));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("EnhancedPerson{name: "), (this->name).toString(), dart_string(", age: "), (this->age).toString(), dart_string("}"));
  }
  
};

// ============================================================================
// 类: GenericBox
// ============================================================================

template<typename T>
class GenericBox {
public:
  T value;
  GenericBox(T value) : value(value) {
  }
  
};

Nullable testDataTypes();
Nullable testEnhancedControlFlow();
Nullable testEnhancedFunctions();
Nullable testEnhancedCollections();
Nullable testEnhancedClasses();
Nullable testGenerics();
Nullable testDataTypes() {
  dart_print(dart_string("\n--- 数据类型和操作 ---"));
auto age = dart_int(25);
auto price = dart_double(99.99);
auto name = dart_string("张三");
auto isStudent = dart_bool(true);
auto ageString = age->toString();
auto priceInt = price->toInt();
dart_print(dart_string("数据类型操作完成"));
return Void;
}

Nullable testEnhancedControlFlow() {
  dart_print(dart_string("\n--- 增强控制流 ---"));
auto grade = dart_string("B");
if (grade == dart_string("A")) {
  dart_print(dart_string("优秀"));
} else if (grade == dart_string("B")) {
  dart_print(dart_string("良好"));
}else {
  dart_print(dart_string("其他等级"));
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

Nullable testEnhancedFunctions() {
  dart_print(dart_string("\n--- 增强函数 ---"));
dart_print(dart_string("函数特性测试完成"));
return Void;
}

Nullable testEnhancedCollections() {
  dart_print(dart_string("\n--- 增强集合 ---"));
auto numbers = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("列表长度: ") + (numbers->size()).toString());
auto scores = Map<String, Int>::createFromEntries({{dart_string("张三"), dart_int(95)}, {dart_string("李四"), dart_int(87)}});
dart_print(dart_string("映射大小: ") + (scores->size()).toString());
numbers->add(dart_int(6));
dart_print(dart_string("添加元素后长度: ") + (numbers->size()).toString());
return Void;
}

Nullable testEnhancedClasses() {
  dart_print(dart_string("\n--- 增强类 ---"));
auto person = ObjectPtr<EnhancedPerson>(new EnhancedPerson(dart_string("张三"), dart_int(25)));
dart_print(dart_string("创建EnhancedPerson对象"));
person->introduce();
return Void;
}

Nullable testGenerics() {
  dart_print(dart_string("\n--- 泛型 ---"));
dart_print(dart_string("泛型特性测试完成"));
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 Dart 最小化增强语法测试开始"));
testDataTypes();
testEnhancedControlFlow();
testEnhancedFunctions();
testEnhancedCollections();
testEnhancedClasses();
testGenerics();
dart_print(dart_string("✅ Dart 最小化增强语法测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

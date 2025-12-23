#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: WorkingPerson
// ============================================================================

class WorkingPerson {
public:
  String name;
  Int age;
  WorkingPerson(String name, Int age) : name(name), age(age) {
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("大家好，我是 "), (this->name).toString(), dart_string("，今年 "), (this->age).toString(), dart_string(" 岁。")));
return Void;
  }
  
  String toString() {
    return dart_concat(dart_string("WorkingPerson{name: "), (this->name).toString(), dart_string(", age: "), (this->age).toString(), dart_string("}"));
  }
  
};

Nullable testDataTypes();
Nullable testWorkingControlFlow();
Nullable testWorkingFunctions();
Nullable testWorkingCollections();
Nullable testWorkingClasses();
Nullable testWorkingGenerics();
Nullable testDataTypes() {
  dart_print(dart_string("\n--- 数据类型 ---"));
auto age = dart_int(25);
auto price = dart_double(99.99);
auto name = dart_string("张三");
auto isStudent = dart_bool(true);
dart_print(dart_string("基本类型测试完成"));
return Void;
}

Nullable testWorkingControlFlow() {
  dart_print(dart_string("\n--- 工作控制流 ---"));
auto score = dart_int(85);
if (score == dart_int(100) || score == dart_int(90)) {
  dart_print(dart_string("优秀"));
} else if (score == dart_int(80)) {
  dart_print(dart_string("良好"));
}else {
  dart_print(dart_string("其他分数"));
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

Nullable testWorkingFunctions() {
  dart_print(dart_string("\n--- 工作函数特性 ---"));
dart_print(dart_string("函数特性测试完成"));
return Void;
}

Nullable testWorkingCollections() {
  dart_print(dart_string("\n--- 工作集合特性 ---"));
auto numbers = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("列表长度: ") + (numbers->size()).toString());
auto scores = Map<String, Int>::createFromEntries({{dart_string("张三"), dart_int(95)}, {dart_string("李四"), dart_int(87)}});
dart_print(dart_string("映射大小: ") + (scores->size()).toString());
return Void;
}

Nullable testWorkingClasses() {
  dart_print(dart_string("\n--- 工作类特性 ---"));
auto person = ObjectPtr<WorkingPerson>(new WorkingPerson(dart_string("张三"), dart_int(25)));
dart_print(dart_string("创建WorkingPerson对象"));
person->introduce();
return Void;
}

Nullable testWorkingGenerics() {
  dart_print(dart_string("\n--- 工作泛型特性 ---"));
dart_print(dart_string("泛型特性测试完成"));
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 Dart 工作增强语法测试开始"));
testDataTypes();
testWorkingControlFlow();
testWorkingFunctions();
testWorkingCollections();
testWorkingClasses();
testWorkingGenerics();
dart_print(dart_string("✅ Dart 工作增强语法测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

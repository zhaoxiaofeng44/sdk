#include "dart2cpp.h"

// 工具宏定义

ObjectPtr<Object> getValue();
ObjectPtr<Object> getObject();
ObjectPtr<Object> getData();
ObjectPtr<Object> getItem();
ObjectPtr<Object> getValue() {
  return dart_string("test");
}

ObjectPtr<Object> getObject() {
  return dart_string("sample");
}

ObjectPtr<Object> getData() {
  return dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3));
}

ObjectPtr<Object> getItem() {
  return dart_int(100);
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto obj = dart_string("Hello");
if (dart_is<String>(obj)) {
auto obj_promoted = dart_cast<String>(obj);
dart_print(obj_promoted->size());
dart_print(obj_promoted->toUpperCase());
}
Any value = dart_int(42);
if (dart_is<Int>(value)) {
auto value_promoted = dart_cast<Int>(value);
dart_print(value_promoted->operator_add(dart_int(10)));
}
auto nullable = getValue();
if (!(dart_is_null(nullable))) {
if (dart_is<String>(nullable)) {
auto nullable_promoted = dart_cast<String>(nullable);
dart_print(nullable_promoted->substring(dart_int(0), dart_int(5)));
}
}
auto x = getObject();
auto y = getObject();
if (dart_is<String>(x) && dart_is<Int>(y)) {
auto x_promoted = dart_cast<String>(x);
auto y_promoted = dart_cast<Int>(y);
dart_print(x_promoted->size()->operator_add(y_promoted));
}
auto data = getData();
if (dart_is<ObjectPtr<List<Any>>>(data)) {
auto data_promoted = dart_cast<ObjectPtr<List<Any>>>(data);
dart_print(data_promoted->size());
} else {
dart_print(data->toString());
}
auto item = getItem();
if (!(dart_is<Int>(item))) {
dart_print(dart_string("Not an integer"));
} else {
auto item_promoted = dart_cast<Int>(item);
dart_print(item_promoted->abs());
}
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

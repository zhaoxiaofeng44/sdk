#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Point
// ============================================================================

class Point {
public:
  Double x;
  Double y;
  Point(Double x, Double y) : x(x), y(y) {
  }
  
  Point() : x(dart_double(0.0)), y(dart_double(0.0)) {
  }
  
  Point() : x(dart_double(1.0)), y(dart_double(0.0)) {
  }
  
  Point() : x(dart_double(0.0)), y(dart_double(1.0)) {
  }
  
  Double distance() {
    return MathExtension::sqrt(this->x->operator_mul(this->x)->operator_add(this->y->operator_mul(this->y)));
  }
  
  Bool operator_equals(ObjectPtr<Object> other) {
    return dart_is<ObjectPtr<Point>>(other) && (this->x == other->x) && (this->y == other->y);
  }
  
  Int hashCode() {
    return Object::hash(this->x, this->y, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr);
  }
  
  String toString() {
    return dart_concat(dart_string("Point("), (this->x).toString(), dart_string(", "), (this->y).toString(), dart_string(")"));
  }
  
};

// ============================================================================
// 类: Color
// ============================================================================

class Color {
public:
  Int value;
  Color(Int value) : value(value) {
  }
  
  ObjectPtr<Color> red() {
    return /* Invalid: temp_dart_source.dart:362:31: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.red() = Color._(0xFF0000);
                              ^ */;
  }
  
  ObjectPtr<Color> green() {
    return /* Invalid: temp_dart_source.dart:363:33: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.green() = Color._(0x00FF00);
                                ^ */;
  }
  
  ObjectPtr<Color> blue() {
    return /* Invalid: temp_dart_source.dart:364:32: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.blue() = Color._(0x0000FF);
                               ^ */;
  }
  
  String toString() {
    return dart_concat(dart_string("Color(0x"), (this->value->toRadixString(dart_int(16))->padLeft(dart_int(6), dart_string("0"))).toString(), dart_string(")"));
  }
  
};

// ============================================================================
// 类: Rectangle
// ============================================================================

class Rectangle {
public:
  ObjectPtr<Point> topLeft;
  ObjectPtr<Point> bottomRight;
  Rectangle(ObjectPtr<Point> topLeft, ObjectPtr<Point> bottomRight) : topLeft(topLeft), bottomRight(bottomRight) {
  }
  
  Double width() {
    return this->bottomRight->x->operator_sub(this->topLeft->x);
  }
  
  Double height() {
    return this->bottomRight->y->operator_sub(this->topLeft->y);
  }
  
  Double area() {
    return this->width()->operator_mul(this->height());
  }
  
  String toString() {
    return dart_concat(dart_string("Rectangle("), (this->topLeft).toString(), dart_string(", "), (this->bottomRight).toString(), dart_string(")"));
  }
  
};

// ============================================================================
// 类: Circle
// ============================================================================

class Circle {
public:
  ObjectPtr<Point> center;
  Double radius;
  Circle(ObjectPtr<Point> center, Double radius) : center(center), radius(radius) {
  }
  
  Double area() {
    return dart_double(3.14159)->operator_mul(this->radius)->operator_mul(this->radius);
  }
  
  Double circumference() {
    return dart_double(2.0)->operator_mul(dart_double(3.14159))->operator_mul(this->radius);
  }
  
  String toString() {
    return dart_concat(dart_string("Circle("), (this->center).toString(), dart_string(", "), (this->radius).toString(), dart_string(")"));
  }
  
};

// ============================================================================
// 类: MathConstants
// ============================================================================

class MathConstants {
public:
  Double PI = dart_double(3.14159265359);
  Double E = dart_double(2.71828182846);
  Double GOLDEN_RATIO = dart_double(1.61803398875);
  Double SQRT_2 = dart_double(1.41421356237);
  Double SQRT_3 = dart_double(1.73205080757);
  MathConstants() {
  }
  
};

// ============================================================================
// 类: PhysicsConstants
// ============================================================================

class PhysicsConstants {
public:
  Double SPEED_OF_LIGHT = dart_double(299792458.0);
  Double GRAVITY = dart_double(9.80665);
  Double PLANCK_CONSTANT = dart_double(6.62607015e-34);
  Double AVOGADRO_NUMBER = dart_double(6.02214076e+23);
  PhysicsConstants() {
  }
  
};

// ============================================================================
// 类: AppConfig
// ============================================================================

class AppConfig {
public:
  String APP_NAME = dart_string("Dart2CPP Test Suite");
  String VERSION = dart_string("1.0.0");
  Bool DEBUG_MODE = dart_bool(true);
  Int MAX_RETRY_COUNT = dart_int(3);
  ObjectPtr<Duration> TIMEOUT = ObjectPtr<Duration>::createConst();
  AppConfig() {
  }
  
};

// ============================================================================
// 类: HttpStatus
// ============================================================================

class HttpStatus {
public:
  Int OK = dart_int(200);
  Int CREATED = dart_int(201);
  Int BAD_REQUEST = dart_int(400);
  Int UNAUTHORIZED = dart_int(401);
  Int NOT_FOUND = dart_int(404);
  Int SERVER_ERROR = dart_int(500);
  HttpStatus() {
  }
  
};

// ============================================================================
// 类: FileTypes
// ============================================================================

class FileTypes {
public:
  ObjectPtr<List<String>> SUPPORTED_TYPES = List<String>::createConst({dart_string(".dart"), dart_string(".cpp"), dart_string(".h"), dart_string(".txt"), dart_string(".json")});
  ObjectPtr<Map<String, String>> MIME_TYPES = Map<String, String>::createConst();
  FileTypes() {
  }
  
};

// ============================================================================
// 类: Settings
// ============================================================================

class Settings {
public:
  ObjectPtr<Map<String, Any>> DEFAULT_SETTINGS = Map<String, Any>::createConst();
  ObjectPtr<List<String>> AVAILABLE_THEMES = List<String>::createConst({dart_string("light"), dart_string("dark"), dart_string("high-contrast")});
  Settings() {
  }
  
};

Nullable testBasicConstants();
Nullable testConstantCollections();
Nullable testConstantConstructors();
Nullable testStaticConstants();
Nullable testCompileTimeExpressions();
Double MathExtension::sqrt(Double _this);
ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension::get_sqrt(Double _this);
Nullable testBasicConstants() {
  dart_print(dart_string("\n📌 测试基本常量"));
dart_print(dart_string("  const 常量:"));
dart_print(dart_string("    constInt: 42"));
dart_print(dart_string("    constDouble: 3.14159"));
dart_print(dart_string("    constBool: true"));
dart_print(dart_string("    constString: Hello, World!"));
const auto finalInt = dart_int(100);
const auto finalDouble = dart_double(2.71828);
const auto finalBool = dart_bool(false);
const auto finalString = dart_string("Final String");
const auto finalTime = ObjectPtr<DateTime>(new DateTime());
dart_print(dart_string("  final 常量:"));
dart_print(dart_string("    finalInt: ") + (finalInt).toString());
dart_print(dart_string("    finalDouble: ") + (finalDouble).toString());
dart_print(dart_string("    finalBool: ") + (finalBool).toString());
dart_print(dart_string("    finalString: ") + (finalString).toString());
dart_print(dart_string("    finalTime: ") + (finalTime).toString());
const auto runTime = dart_string("Run Time: ") + (ObjectPtr<DateTime>(new DateTime())->millisecondsSinceEpoch()).toString();
dart_print(dart_string("  const vs final:"));
dart_print(dart_string("    编译时常量: Compile Time"));
dart_print(dart_string("    运行时常量: ") + (runTime).toString());
dart_print(dart_string("  常量表达式:"));
dart_print(dart_string("    sum: 30"));
dart_print(dart_string("    product: 200"));
dart_print(dart_string("    comparison: true"));
dart_print(dart_string("    interpolation: Sum: 30"));
return Void;
}

Nullable testConstantCollections() {
  dart_print(dart_string("\n📌 测试常量集合"));
dart_print(dart_string("  const 列表:"));
dart_print(dart_string("    constList: ") + (List<Int>::createConst({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)})).toString());
dart_print(dart_string("    constStringList: ") + (List<String>::createConst({dart_string("apple"), dart_string("banana"), dart_string("orange")})).toString());
dart_print(dart_string("    constBoolList: ") + (List<Bool>::createConst({dart_bool(true), dart_bool(false), dart_bool(true)})).toString());
dart_print(dart_string("  const 集合:"));
dart_print(dart_string("    constSet: ") + (Set<Int>::createConst({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)})).toString());
dart_print(dart_string("    constStringSet: ") + (Set<String>::createConst({dart_string("red"), dart_string("green"), dart_string("blue")})).toString());
dart_print(dart_string("  const 映射:"));
dart_print(dart_string("    constMap: ") + (Map<String, Int>::createConst()).toString());
dart_print(dart_string("    constNestedMap: ") + (Map<String, ObjectPtr<List<Int>>>::createConst()).toString());
dart_print(dart_string("  嵌套常量集合:"));
dart_print(dart_string("    constNestedList: ") + (List<ObjectPtr<List<Int>>>::createConst({List<Int>::createConst({dart_int(1), dart_int(2), dart_int(3)}), List<Int>::createConst({dart_int(4), dart_int(5), dart_int(6)}), List<Int>::createConst({dart_int(7), dart_int(8), dart_int(9)})})).toString());
dart_print(dart_string("    constDeepMap: ") + (Map<String, ObjectPtr<Map<String, Int>>>::createConst()).toString());
auto firstNumber = /* Invalid: The method '[]' can't be invoked on '<int>[1, 2, 3, 4, 5]' in a constant expression. */;
auto listLength = /* Invalid: The property 'length' can't be accessed on '<int>[1, 2, 3, 4, 5]' in a constant expression. */;
dart_print(dart_string("  常量集合操作:"));
dart_print(dart_string("    firstNumber: ") + (/* Invalid: The method '[]' can't be invoked on '<int>[1, 2, 3, 4, 5]' in a constant expression. */).toString());
dart_print(dart_string("    listLength: ") + (/* Invalid: The property 'length' can't be accessed on '<int>[1, 2, 3, 4, 5]' in a constant expression. */).toString());
dart_print(dart_string("    combined: ") + (List<Int>::createConst({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6)})).toString());
return Void;
}

Nullable testConstantConstructors() {
  dart_print(dart_string("\n📌 测试常量构造函数"));
dart_print(dart_string("  基本常量构造函数:"));
dart_print(dart_string("    p1: ") + (ObjectPtr<Point>::createConst()).toString());
dart_print(dart_string("    p2: ") + (ObjectPtr<Point>::createConst()).toString());
dart_print(dart_string("    p3: ") + (ObjectPtr<Point>::createConst()).toString());
dart_print(dart_string("    p1 == p2: ") + ((ObjectPtr<Point>::createConst() == ObjectPtr<Point>::createConst())).toString());
dart_print(dart_string("    identical(p1, p2): ") + (identical(ObjectPtr<Point>::createConst(), ObjectPtr<Point>::createConst())).toString());
dart_print(dart_concat(dart_string("    p1.x: "), (ObjectPtr<Point>::createConst()->x).toString(), dart_string(", p1.y: "), (ObjectPtr<Point>::createConst()->y).toString()));
dart_print(dart_string("    p1.distance: ") + (ObjectPtr<Point>::createConst()->distance()).toString());
dart_print(dart_string("  命名常量构造函数:"));
dart_print(dart_string("    origin: ") + (ObjectPtr<Point>::createConst()).toString());
dart_print(dart_string("    unitX: ") + (ObjectPtr<Point>::createConst()).toString());
dart_print(dart_string("    unitY: ") + (ObjectPtr<Point>::createConst()).toString());
auto red = /* Invalid: temp_dart_source.dart:362:31: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.red() = Color._(0xFF0000);
                              ^ */;
auto green = /* Invalid: temp_dart_source.dart:363:33: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.green() = Color._(0x00FF00);
                                ^ */;
auto blue = /* Invalid: temp_dart_source.dart:364:32: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.blue() = Color._(0x0000FF);
                               ^ */;
dart_print(dart_string("  常量工厂构造函数:"));
dart_print(dart_string("    red: ") + (/* Invalid: temp_dart_source.dart:362:31: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.red() = Color._(0xFF0000);
                              ^ */).toString());
dart_print(dart_string("    green: ") + (/* Invalid: temp_dart_source.dart:363:33: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.green() = Color._(0x00FF00);
                                ^ */).toString());
dart_print(dart_string("    blue: ") + (/* Invalid: temp_dart_source.dart:364:32: Error: The constructor function type 'Color Function(int)' isn't a subtype of 'Color Function()'.
 - 'Color' is from 'temp_dart_source.dart'.
  const factory Color.blue() = Color._(0x0000FF);
                               ^ */).toString());
dart_print(dart_string("  复杂常量对象:"));
dart_print(dart_string("    rect: ") + (ObjectPtr<Rectangle>::createConst()).toString());
dart_print(dart_string("    circle: ") + (ObjectPtr<Circle>::createConst()).toString());
dart_print(dart_string("    rect.area: ") + (ObjectPtr<Rectangle>::createConst()->area()).toString());
dart_print(dart_string("    circle.area: ") + (ObjectPtr<Circle>::createConst()->area()).toString());
dart_print(dart_string("  常量对象列表:"));
dart_print(dart_string("    constPoints: ") + (List<ObjectPtr<Point>>::createConst({ObjectPtr<Point>::createConst(), ObjectPtr<Point>::createConst(), ObjectPtr<Point>::createConst()})).toString());
return Void;
}

Nullable testStaticConstants() {
  dart_print(dart_string("\n📌 测试静态常量"));
dart_print(dart_string("  数学常量:"));
dart_print(dart_string("    PI: 3.14159265359"));
dart_print(dart_string("    E: 2.71828182846"));
dart_print(dart_string("    GOLDEN_RATIO: 1.61803398875"));
dart_print(dart_string("  物理常量:"));
dart_print(dart_string("    SPEED_OF_LIGHT: 299792458.0"));
dart_print(dart_string("    GRAVITY: 9.80665"));
dart_print(dart_string("    PLANCK_CONSTANT: 6.62607015e-34"));
dart_print(dart_string("  应用配置:"));
dart_print(dart_string("    APP_NAME: Dart2CPP Test Suite"));
dart_print(dart_string("    VERSION: 1.0.0"));
dart_print(dart_string("    DEBUG_MODE: true"));
dart_print(dart_string("    MAX_RETRY_COUNT: 3"));
dart_print(dart_string("  HTTP状态码:"));
dart_print(dart_string("    OK: 200"));
dart_print(dart_string("    NOT_FOUND: 404"));
dart_print(dart_string("    SERVER_ERROR: 500"));
dart_print(dart_string("  支持的文件类型: ") + (List<String>::createConst({dart_string(".dart"), dart_string(".cpp"), dart_string(".h"), dart_string(".txt"), dart_string(".json")})).toString());
dart_print(dart_string("  默认设置: ") + (Map<String, Any>::createConst()).toString());
return Void;
}

Nullable testCompileTimeExpressions() {
  dart_print(dart_string("\n📌 测试编译时常量表达式"));
dart_print(dart_string("  算术表达式:"));
dart_print(dart_string("    power: 1000"));
dart_print(dart_string("    average: 6.5"));
dart_print(dart_string("  字符串表达式:"));
dart_print(dart_string("    fullName: John Doe"));
dart_print(dart_string("    greeting: Hello, John!"));
dart_print(dart_string("    nameLength: 7"));
dart_print(dart_string("  布尔表达式:"));
dart_print(dart_string("    canDrive: false"));
dart_print(dart_string("    needsPermission: true"));
dart_print(dart_string("  条件表达式:"));
dart_print(dart_string("    grade: B"));
dart_print(dart_string("    passed: true"));
dart_print(dart_string("  集合表达式:"));
dart_print(dart_string("    extendedList: ") + (List<Int>::createConst({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)})).toString());
dart_print(dart_string("    colors: ") + (Set<String>::createConst({dart_string("red"), dart_string("green"), dart_string("blue")})).toString());
dart_print(dart_string("    colorCodes: ") + (Map<String, Int>::createConst()).toString());
dart_print(dart_string("  复杂表达式:"));
dart_print(dart_string("    circumference: 31.4159"));
dart_print(dart_string("    area: 78.53975"));
return Void;
}

Double MathExtension_sqrt(Double this) {
  if (this->operator_less(dart_int(0))) {
return dart_double(NaN);
}
auto x = this;
auto prev = dart_double(0.0);
while (x->operator_sub(prev)->abs()->operator_greater(dart_double(0.0001))) {
prev = x;
x = x->operator_add(this->operator_div(x))->operator_div(dart_double(2.0));
}
return x;
}

ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension_get_sqrt(Double this) {
  return makeFunction([&]() { return MathExtension::sqrt(this); });
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 常量处理测试开始"));
testBasicConstants();
testConstantCollections();
testConstantConstructors();
testStaticConstants();
testCompileTimeExpressions();
dart_print(dart_string("✅ 常量处理测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

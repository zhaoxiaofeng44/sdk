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
    dart_print(dart_concat(dart_string("    我是"), this->name, dart_string("，今年"), this->age, dart_string("岁")));
return Void;
  }
  
};

// ============================================================================
// 类: StringBuilder
// ============================================================================

class StringBuilder {
private:
  StringBuffer _buffer = ObjectPtr<StringBuffer>(new StringBuffer());
public:
  StringBuilder() {
  }
  
  StringBuilder append(String text) {
    this->_buffer->write(text);
return this;
  }
  
  String toString() {
    return this->_buffer->toString();
  }
  
};

// ============================================================================
// 类: Calculator
// ============================================================================

class Calculator {
public:
  Double value = dart_double(0.0);
  Calculator() {
  }
  
  Calculator add(Double n) {
    this->value = (this->value + n);
return this;
  }
  
  Calculator subtract(Double n) {
    this->value = (this->value - n);
return this;
  }
  
  Calculator multiply(Double n) {
    this->value = (this->value * n);
return this;
  }
  
  Calculator divide(Double n) {
    this->value = (this->value / n);
return this;
  }
  
};

// ============================================================================
// 类: Vector
// ============================================================================

class Vector {
public:
  Double x;
  Double y;
  Vector(Double x, Double y) : x(x), y(y) {
  }
  
  Vector +(Vector other) {
    return ObjectPtr<Vector>(new Vector((this->x + other->x), (this->y + other->y)));
  }
  
  Vector -(Vector other) {
    return ObjectPtr<Vector>(new Vector((this->x - other->x), (this->y - other->y)));
  }
  
  Vector *(Double scalar) {
    return ObjectPtr<Vector>(new Vector((this->x * scalar), (this->y * scalar)));
  }
  
  Bool ==(Object other) {
    return dart_is<Vector>(other) && (this->x == other->x) && (this->y == other->y);
  }
  
  Int hashCode() {
    return Object::hash(this->x, this->y);
  }
  
  Double length() {
    return MathExtension|sqrt(((this->x * this->x) + (this->y * this->y)));
  }
  
  String toString() {
    return dart_concat(dart_string("Vector("), this->x, dart_string(", "), this->y, dart_string(")"));
  }
  
};

// ============================================================================
// 类: Complex
// ============================================================================

class Complex {
public:
  Double real;
  Double imaginary;
  Complex(Double real, Double imaginary) : real(real), imaginary(imaginary) {
  }
  
  Complex +(Complex other) {
    return ObjectPtr<Complex>(new Complex((this->real + other->real), (this->imaginary + other->imaginary)));
  }
  
  Complex -(Complex other) {
    return ObjectPtr<Complex>(new Complex((this->real - other->real), (this->imaginary - other->imaginary)));
  }
  
  Complex *(Complex other) {
    return ObjectPtr<Complex>(new Complex(((this->real * other->real) - (this->imaginary * other->imaginary)), ((this->real * other->imaginary) + (this->imaginary * other->real))));
  }
  
  Complex /(Complex other) {
    auto denominator = ((other->real * other->real) + (other->imaginary * other->imaginary));
return ObjectPtr<Complex>(new Complex((((this->real * other->real) + (this->imaginary * other->imaginary)) / denominator), (((this->imaginary * other->real) - (this->real * other->imaginary)) / denominator)));
  }
  
  String toString() {
    return dart_concat(this->real, dart_string(" + "), this->imaginary, dart_string("i"));
  }
  
};

// ============================================================================
// 类: Matrix
// ============================================================================

class Matrix {
public:
  List<List<Double>> data;
  Matrix(List<List<Double>> data) : data(data) {
  }
  
  Matrix +(Matrix other) {
    auto result = _GrowableList::(dart_int(0));
for (auto i = dart_int(0); (i < this->data->size()); ++i) {
auto row = _GrowableList::(dart_int(0));
for (auto j = dart_int(0); (j < this->data->[](i)->size()); ++j) {
row->add((this->data->[](i)->[](j) + other->data->[](i)->[](j)));
}
result->add(row);
}
return ObjectPtr<Matrix>(new Matrix(result));
  }
  
  List<Double> [](Int index) {
    return this->data->[](index);
  }
  
  String toString() {
    return this->data->toString();
  }
  
};

// ============================================================================
// 类: Point
// ============================================================================

class Point : DART_IMPLEMENTS(Comparable) {
public:
  Double x;
  Double y;
  Point(Double x, Double y) : x(x), y(y) {
  }
  
  Int compareTo(Point other) {
    auto thisDistance = ((this->x * this->x) + (this->y * this->y));
auto otherDistance = ((other->x * other->x) + (other->y * other->y));
return thisDistance->compareTo(otherDistance);
  }
  
  Bool <(Point other) {
    return (this->compareTo(other) < dart_int(0));
  }
  
  Bool >(Point other) {
    return (this->compareTo(other) > dart_int(0));
  }
  
  Bool <=(Point other) {
    return (this->compareTo(other) <= dart_int(0));
  }
  
  Bool >=(Point other) {
    return (this->compareTo(other) >= dart_int(0));
  }
  
  Bool ==(Object other) {
    return dart_is<Point>(other) && (this->x == other->x) && (this->y == other->y);
  }
  
  Int hashCode() {
    return Object::hash(this->x, this->y);
  }
  
};

// ============================================================================
// 类: UserService
// ============================================================================

class UserService {
public:
  UserService() {
  }
  
  Nullable getUser(String id) {
    dart_print(dart_concat(dart_string("    获取用户: "), id));
return Void;
  }
  
  Nullable createUser(String name, String email) {
    dart_print(dart_concat(dart_string("    创建用户: "), name, dart_string(", "), email));
return Void;
  }
  
  Nullable deleteUser(String id) {
    dart_print(dart_concat(dart_string("    删除用户: "), id));
return Void;
  }
  
};

// ============================================================================
// 类: DataValidator
// ============================================================================

class DataValidator {
public:
  DataValidator() {
  }
  
  Nullable validateEmail(String email) {
    dart_print(dart_concat(dart_string("    验证邮箱: "), email));
return Void;
  }
  
  Nullable validateAge(Int age) {
    dart_print(dart_concat(dart_string("    验证年龄: "), age));
return Void;
  }
  
  Nullable validatePassword(String password) {
    dart_print(dart_concat(dart_string("    验证密码: "), password->replaceAll(RegExp::(dart_string(".")), dart_string("*"))));
return Void;
  }
  
};

// ============================================================================
// 类: required
// ============================================================================

class required {
public:
  required() {
  }
  
};

// ============================================================================
// 类: timeout
// ============================================================================

class timeout {
public:
  Int milliseconds;
  timeout(Int milliseconds) : milliseconds(milliseconds) {
  }
  
};

// ============================================================================
// 类: experimental
// ============================================================================

class experimental {
public:
  experimental() {
  }
  
};

Nullable testClosuresAndHigherOrder() {
  dart_print(dart_string("\n📌 测试闭包和高阶函数"));
auto makeAdder = [&](Int addBy) -> Function return [&](Int i) { return (i + addBy); };;
auto add2 = makeAdder(dart_int(2));
auto add5 = makeAdder(dart_int(5));
dart_print(dart_string("  简单闭包:"));
dart_print(dart_concat(dart_string("    add2(10): "), add2(dart_int(10))));
dart_print(dart_concat(dart_string("    add5(10): "), add5(dart_int(10))));
auto makeCounter = [&]() -> Function auto count = dart_int(0);
return [&]() { count = (count + dart_int(1));
return count; };;
auto counter = makeCounter();
dart_print(dart_string("  计数器闭包:"));
dart_print(dart_concat(dart_string("    计数: "), counter(), dart_string(", "), counter(), dart_string(", "), counter()));
auto makeMultiplier = [&](Int factor) -> Function auto callCount = dart_int(0);
return [&](Int value) { callCount = (callCount + dart_int(1));
dart_print(dart_concat(dart_string("    调用第"), callCount, dart_string("次")));
return (value * factor); };;
auto triple = makeMultiplier(dart_int(3));
dart_print(dart_string("  多变量闭包:"));
dart_print(dart_concat(dart_string("    triple(5): "), triple(dart_int(5))));
dart_print(dart_concat(dart_string("    triple(7): "), triple(dart_int(7))));
auto functions = _GrowableList::(dart_int(0));
for (auto i = dart_int(0); (i < dart_int(3)); ++i) {
auto captured = i;
functions->add([&]() { return captured; });
}
dart_print(dart_string("  循环变量捕获:"));
dart_print(dart_concat(dart_string("    捕获的值: "), functions->[](dart_int(0))(), dart_string(", "), functions->[](dart_int(1))(), dart_string(", "), functions->[](dart_int(2))()));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto result = applyTwice(dart_int(5), [&](Object x) { return dart_cast<Int>(/* Invalid: temp_dart_source.dart:92:39: Error: The operator '*' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the operator to an existing operator, or defining a '*' operator.
  int result = applyTwice(5, (x) => x * 2);
                                      ^ */); });
dart_print(dart_string("  高阶函数:"));
dart_print(dart_concat(dart_string("    applyTwice(5, x*2): "), result));
auto addOne = [&](Int x) { return (x + dart_int(1)); };
auto multiplyByTwo = [&](Int x) { return (x * dart_int(2)); };
auto composed = /* Invalid: temp_dart_source.dart:99:32: Error: A value of type 'dynamic Function(int)' can't be assigned to a variable of type 'int Function(int)'.
  int Function(int) composed = compose(multiplyByTwo, addOne);
                               ^ */;
dart_print(dart_concat(dart_string("    函数组合 (x+1)*2 应用于5: "), composed(dart_int(5))));
auto curriedAdd = curry([&](Int a, Int b) { return (a + b); });
auto add10 = curriedAdd(dart_int(10));
dart_print(dart_concat(dart_string("    柯里化加法: "), add10.call(dart_int(5))));
}

Nullable testCascadeNotation() {
  dart_print(dart_string("\n📌 测试级联操作符"));
auto person = ([&]() { Person let_var = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25))); return ([&]() { let_var->name = dart_string("Alice Smith"); let_var->age = dart_int(26); let_var->introduce(); return let_var; })(); })();
dart_print(dart_string("  基本级联:"));
dart_print(dart_concat(dart_string("    人员信息: "), person->name, dart_string(", "), person->age, dart_string("岁")));
auto builder = ([&]() { StringBuilder let_var = ObjectPtr<StringBuilder>(new StringBuilder()); return ([&]() { let_var->append(dart_string("Hello")); let_var->append(dart_string(" ")); let_var->append(dart_string("World")); let_var->append(dart_string("!")); return let_var; })(); })();
dart_print(dart_string("  级联方法调用:"));
dart_print(dart_concat(dart_string("    构建结果: "), builder->toString()));
auto numbers = ([&]() { List<Int> let_var = _GrowableList::(dart_int(0)); return ([&]() { let_var->add(dart_int(1)); let_var->add(dart_int(2)); let_var->add(dart_int(3)); let_var->addAll(dart_literal(dart_int(4), dart_int(5), dart_int(6))); return let_var; })(); })();
dart_print(dart_string("  嵌套级联:"));
dart_print(dart_concat(dart_string("    列表内容: "), numbers));
auto calculator = ([&]() { Calculator let_var = ObjectPtr<Calculator>(new Calculator()); return ([&]() { let_var->add(dart_double(10.0)); let_var->multiply(dart_double(2.0)); return let_var; })(); })();
if ((calculator->value > dart_int(15))) {
([&]() { Calculator let_var = calculator; return ([&]() { let_var->subtract(dart_double(5.0)); let_var->divide(dart_double(3.0)); return let_var; })(); })();
}
dart_print(dart_string("  条件级联:"));
dart_print(dart_concat(dart_string("    计算结果: "), calculator->value));
auto nullablePerson = ObjectPtr<Person>(new Person(dart_string("Bob"), dart_int(30)));
([&]() { Person let_var = nullablePerson; return dart_is_null(let_var) ? Null : ([&]() { let_var->name = dart_string("Bob Johnson"); let_var->age = dart_int(31); let_var->introduce(); return let_var; })(); })();
nullablePerson = Null;
([&]() { Person let_var = nullablePerson; return dart_is_null(let_var) ? Null : ([&]() { let_var->name = dart_string("Won't execute"); let_var->introduce(); return let_var; })(); })();
dart_print(dart_string("    空值级联测试完成"));
}

Nullable testExtensionMethods() {
  dart_print(dart_string("\n📌 测试扩展方法"));
auto text = dart_string("hello world");
dart_print(dart_string("  字符串扩展:"));
dart_print(dart_concat(dart_string("    首字母大写: "), StringExtensions|capitalize(text)));
dart_print(dart_concat(dart_string("    是否为回文: "), StringExtensions|isPalindrome(text)));
dart_print(dart_concat(dart_string("    单词数量: "), StringExtensions|wordCount(text)));
dart_print(dart_concat(dart_string("    反转: "), StringExtensions|reverse(text)));
auto palindrome = dart_string("racecar");
dart_print(dart_concat(dart_string("    \""), palindrome, dart_string("\" 是回文: "), StringExtensions|isPalindrome(palindrome)));
auto number = dart_int(5);
dart_print(dart_string("  数字扩展:"));
dart_print(dart_concat(dart_string("    阶乘: "), IntExtensions|factorial(number)));
dart_print(dart_concat(dart_string("    是否为偶数: "), number.isEven));
dart_print(dart_concat(dart_string("    是否为质数: "), IntExtensions|isPrime(number)));
dart_print(dart_concat(dart_string("    平方: "), IntExtensions|squared(number)));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("  列表扩展:"));
dart_print(dart_concat(dart_string("    第二个元素: "), ListExtensions|secondOrNull(numbers)));
dart_print(dart_concat(dart_string("    倒数第二个: "), ListExtensions|secondLastOrNull(numbers)));
dart_print(dart_concat(dart_string("    随机元素: "), ListExtensions|random(numbers)));
auto empty = _GrowableList::(dart_int(0));
dart_print(dart_concat(dart_string("    空列表第二个: "), ListExtensions|secondOrNull(empty)));
auto now = ObjectPtr<DateTime>(new DateTime());
dart_print(dart_string("  日期时间扩展:"));
dart_print(dart_concat(dart_string("    是否为今天: "), DateTimeExtensions|isToday(now)));
dart_print(dart_concat(dart_string("    格式化: "), DateTimeExtensions|formatDate(now)));
dart_print(dart_concat(dart_string("    添加工作日: "), DateTimeExtensions|formatDate(DateTimeExtensions|addBusinessDays(now, dart_int(5)))));
auto result1 = LetExtension|let(dart_int(42), [&](Int value) { return (value * dart_int(2)); });
auto result2 = LetExtension|let(dart_string("hello"), [&](String value) { return value->toUpperCase(); });
dart_print(dart_string("  泛型扩展:"));
dart_print(dart_concat(dart_string("    let应用于数字: "), result1));
dart_print(dart_concat(dart_string("    let应用于字符串: "), result2));
}

Nullable testOperatorOverloading() {
  dart_print(dart_string("\n📌 测试操作符重载"));
auto v1 = ObjectPtr<Vector>(new Vector(dart_double(3.0), dart_double(4.0)));
auto v2 = ObjectPtr<Vector>(new Vector(dart_double(1.0), dart_double(2.0)));
dart_print(dart_string("  向量操作符重载:"));
dart_print(dart_concat(dart_string("    v1: "), v1));
dart_print(dart_concat(dart_string("    v2: "), v2));
dart_print(dart_concat(dart_string("    v1 + v2: "), (v1 + v2)));
dart_print(dart_concat(dart_string("    v1 - v2: "), (v1 - v2)));
dart_print(dart_concat(dart_string("    v1 * 2: "), (v1 * dart_double(2.0))));
dart_print(dart_concat(dart_string("    v1 == v2: "), (v1 == v2)));
dart_print(dart_concat(dart_string("    v1长度: "), v1->size()));
auto c1 = ObjectPtr<Complex>(new Complex(dart_double(3.0), dart_double(4.0)));
auto c2 = ObjectPtr<Complex>(new Complex(dart_double(1.0), dart_double(2.0)));
dart_print(dart_string("  复数操作符重载:"));
dart_print(dart_concat(dart_string("    c1: "), c1));
dart_print(dart_concat(dart_string("    c2: "), c2));
dart_print(dart_concat(dart_string("    c1 + c2: "), (c1 + c2)));
dart_print(dart_concat(dart_string("    c1 - c2: "), (c1 - c2)));
dart_print(dart_concat(dart_string("    c1 * c2: "), (c1 * c2)));
dart_print(dart_concat(dart_string("    c1 / c2: "), (c1 / c2)));
auto m1 = ObjectPtr<Matrix>(new Matrix(dart_literal(dart_literal(dart_double(1.0), dart_double(2.0)), dart_literal(dart_double(3.0), dart_double(4.0)))));
auto m2 = ObjectPtr<Matrix>(new Matrix(dart_literal(dart_literal(dart_double(5.0), dart_double(6.0)), dart_literal(dart_double(7.0), dart_double(8.0)))));
dart_print(dart_string("  矩阵操作符重载:"));
dart_print(dart_concat(dart_string("    m1: "), m1));
dart_print(dart_concat(dart_string("    m2: "), m2));
dart_print(dart_concat(dart_string("    m1 + m2: "), (m1 + m2)));
dart_print(dart_concat(dart_string("    m1[0][1]: "), m1->[](dart_int(0))->[](dart_int(1))));
auto p1 = ObjectPtr<Point>(new Point(dart_double(1.0), dart_double(2.0)));
auto p2 = ObjectPtr<Point>(new Point(dart_double(3.0), dart_double(4.0)));
auto p3 = ObjectPtr<Point>(new Point(dart_double(1.0), dart_double(2.0)));
dart_print(dart_string("  点比较:"));
dart_print(dart_concat(dart_string("    p1 < p2: "), (p1 < p2)));
dart_print(dart_concat(dart_string("    p1 == p3: "), (p1 == p3)));
dart_print(dart_concat(dart_string("    p1.hashCode == p3.hashCode: "), (p1->hashCode == p3->hashCode)));
return Void;
}

Nullable testMetadataAnnotations() {
  dart_print(dart_string("\n📌 测试元数据注解"));
auto service = ObjectPtr<UserService>(new UserService());
service->getUser(dart_string("123"));
service->createUser(dart_string("Alice"), dart_string("alice@example.com"));
service->deleteUser(dart_string("456"));
auto validator = ObjectPtr<DataValidator>(new DataValidator());
validator->validateEmail(dart_string("test@example.com"));
validator->validateAge(dart_int(25));
validator->validatePassword(dart_string("secret123"));
dart_print(dart_string("  注解测试完成 (注解在编译时处理)"));
return Void;
}

Nullable testFunctionalProgramming() {
  dart_print(dart_string("\n📌 测试函数式编程"));
auto numbers = List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)});
auto result = numbers->where([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); })->map([&](Int n) { return (n * n); })->where([&](Int n) { return (n > dart_int(10)); })->toList();
dart_print(dart_string("  函数式链式操作:"));
dart_print(dart_concat(dart_string("    偶数平方大于10: "), result));
auto pipeline = pipe(dart_literal([&](List<Int> list) { return list->where([&](Int n) { return (n > dart_int(5)); }); }, [&](Iterable iter) { return iter->map([&](Int n) { return (n * dart_int(2)); }); }, [&](Iterable iter) { return iter->toList(); }));
auto pipeResult = pipeline(numbers);
dart_print(dart_concat(dart_string("    管道处理结果: "), pipeResult));
auto multiply = [&](Int a, Int b) { return (a * b); };
auto double = partial(multiply, dart_int(2));
dart_print(dart_string("  部分应用:"));
dart_print(dart_concat(dart_string("    double(5): "), double(dart_int(5))));
auto fibMemo = memoize(/* Constant: StaticTearOffConstant */);
dart_print(dart_string("  记忆化斐波那契:"));
dart_print(dart_concat(dart_string("    fib(10): "), fibMemo(dart_int(10))));
dart_print(dart_concat(dart_string("    fib(15): "), fibMemo(dart_int(15))));
auto lazyNumbers = generateLazy(dart_int(1000000));
auto firstFive = lazyNumbers->take(dart_int(5))->toList();
dart_print(dart_string("  惰性求值:"));
dart_print(dart_concat(dart_string("    前5个数: "), firstFive));
}

String StringExtensions|capitalize(String #this) {
  if (_this->isEmpty) {
return _this;
}
return (_this->[](dart_int(0))->toUpperCase() + _this->substring(dart_int(1)));
}

std::function<String()> StringExtensions|get#capitalize(String #this) {
  return [&]() { return StringExtensions|capitalize(_this); };
}

Bool StringExtensions|isPalindrome(String #this) {
  auto cleaned = _this->toLowerCase()->replaceAll(RegExp::(dart_string("[^a-z0-9]")), dart_string(""));
return (cleaned == cleaned->split(dart_string(""))->reversed->join(dart_string("")));
}

std::function<Bool()> StringExtensions|get#isPalindrome(String #this) {
  return [&]() { return StringExtensions|isPalindrome(_this); };
}

Int StringExtensions|wordCount(String #this) {
  return _this->trim()->split(RegExp::(dart_string("\\s+")))->where([&](String word) { return word->isNotEmpty; })->size();
}

std::function<Int()> StringExtensions|get#wordCount(String #this) {
  return [&]() { return StringExtensions|wordCount(_this); };
}

String StringExtensions|reverse(String #this) {
  return _this->split(dart_string(""))->reversed->join(dart_string(""));
}

std::function<String()> StringExtensions|get#reverse(String #this) {
  return [&]() { return StringExtensions|reverse(_this); };
}

Int IntExtensions|factorial(Int #this) {
  if ((_this <= dart_int(1))) {
return dart_int(1);
}
return (_this * IntExtensions|factorial((_this - dart_int(1))));
}

std::function<Int()> IntExtensions|get#factorial(Int #this) {
  return [&]() { return IntExtensions|factorial(_this); };
}

Bool IntExtensions|isPrime(Int #this) {
  if ((_this <= dart_int(1))) {
return dart_bool(false);
}
if ((_this <= dart_int(3))) {
return dart_bool(true);
}
if (((_this % dart_int(2)) == dart_int(0)) || ((_this % dart_int(3)) == dart_int(0))) {
return dart_bool(false);
}
for (auto i = dart_int(5); ((i * i) <= _this); i = (i + dart_int(6))) {
if (((_this % i) == dart_int(0)) || ((_this % (i + dart_int(2))) == dart_int(0))) {
return dart_bool(false);
}
}
return dart_bool(true);
}

std::function<Bool()> IntExtensions|get#isPrime(Int #this) {
  return [&]() { return IntExtensions|isPrime(_this); };
}

Int IntExtensions|squared(Int #this) {
  return (_this * _this);
}

std::function<Int()> IntExtensions|get#squared(Int #this) {
  return [&]() { return IntExtensions|squared(_this); };
}

Any ListExtensions|secondOrNull(List<Any> #this) {
  return (_this->size() >= dart_int(2)) ? _this->[](dart_int(1)) : Null;
}

std::function<Any()> ListExtensions|get#secondOrNull(List<Any> #this) {
  return [&]() { return ListExtensions|secondOrNull(_this); };
}

Any ListExtensions|secondLastOrNull(List<Any> #this) {
  return (_this->size() >= dart_int(2)) ? _this->[]((_this->size() - dart_int(2))) : Null;
}

std::function<Any()> ListExtensions|get#secondLastOrNull(List<Any> #this) {
  return [&]() { return ListExtensions|secondLastOrNull(_this); };
}

Any ListExtensions|random(List<Any> #this) {
  if (_this->isEmpty) {
throw DartException(ObjectPtr<StateError>(new StateError(dart_string("Empty list"))));
}
return _this->[]((ObjectPtr<DateTime>(new DateTime())->millisecondsSinceEpoch % _this->size()));
}

std::function<Any()> ListExtensions|get#random(List<Any> #this) {
  return [&]() { return ListExtensions|random(_this); };
}

Bool DateTimeExtensions|isToday(DateTime #this) {
  auto now = ObjectPtr<DateTime>(new DateTime());
return (_this->year == now->year) && (_this->month == now->month) && (_this->day == now->day);
}

std::function<Bool()> DateTimeExtensions|get#isToday(DateTime #this) {
  return [&]() { return DateTimeExtensions|isToday(_this); };
}

std::function<String()> DateTimeExtensions|get#formatDate(DateTime #this) {
  return [&]() { return DateTimeExtensions|formatDate(_this); };
}

String DateTimeExtensions|formatDate(DateTime #this) {
  return dart_concat(_this->year, dart_string("-"), _this->month->toString().padLeft(dart_int(2), dart_string("0")), dart_string("-"), _this->day->toString().padLeft(dart_int(2), dart_string("0")));
}

DateTime DateTimeExtensions|addBusinessDays(DateTime #this, Int days) {
  auto result = _this;
auto addedDays = dart_int(0);
while ((addedDays < days)) {
result = result->add(ObjectPtr<Duration>(new Duration(/*days:*/ dart_int(1))));
if ((result->weekday < dart_int(6))) {
addedDays = (addedDays + dart_int(1));
}
}
return result;
}

std::function<DateTime()> DateTimeExtensions|get#addBusinessDays(DateTime #this) {
  return [&](Int days) { return DateTimeExtensions|addBusinessDays(_this, days); };
}

Any LetExtension|let(Any #this, std::function<Any()> block) {
  return block(_this);
}

std::function<Any()> LetExtension|get#let(Any #this) {
  return [&](std::function<Any()> block) { return LetExtension|let(_this, block); };
}

Double MathExtension|sqrt(Double #this) {
  if ((_this < dart_int(0))) {
return dart_double(NaN);
}
auto x = _this;
auto prev = dart_double(0.0);
while (((x - prev)->abs() > dart_double(0.0001))) {
prev = x;
x = ((x + (_this / x)) / dart_int(2));
}
return x;
}

std::function<Double()> MathExtension|get#sqrt(Double #this) {
  return [&]() { return MathExtension|sqrt(_this); };
}

Any applyTwice(Any value, std::function<Any()> func) {
  return func(dart_cast<Any>(func(value)));
}

std::function<Any()> compose(std::function<Any()> f, std::function<Any()> g) {
  return [&](Any x) { return f(g(x)); };
}

std::function<Any()> curry(std::function<Any()> func) {
  return [&](Any first) { return [&](Any second) { return func(first, second); }; };
}

std::function<Any()> pipe(List<Function> functions) {
  return [&](Any input) { auto result = input;
auto sync_for_iterator = functions->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto func = sync_for_iterator->current;
result = func(result);
}
return result; };
}

std::function<Any()> partial(std::function<Any()> func, Any first) {
  return [&](Any second) { return func(first, second); };
}

Function memoize(Function func) {
  auto cache = Map<String, Any>::create();
return [&](Any arg) { auto key = arg->toString();
if (cache->containsKey(key)) {
return cache->[](key);
}
auto result = func(arg);
cache->[]=(key, result);
return result; };
}

Int fibonacci(Int n) {
  if ((n <= dart_int(1))) {
return n;
}
return (fibonacci((n - dart_int(1))) + fibonacci((n - dart_int(2))));
}

Iterable generateLazy(Int max) {
  for (auto i = dart_int(0); (i < max); ++i) {
co_yield i;  // C++20 coroutine
}
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 高级特性测试开始"));
testClosuresAndHigherOrder();
testCascadeNotation();
testExtensionMethods();
testOperatorOverloading();
testMetadataAnnotations();
testFunctionalProgramming();
dart_print(dart_string("✅ 高级特性测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

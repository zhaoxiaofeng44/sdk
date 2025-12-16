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
    dart_print(dart_concat(dart_string("    我是"), (this->name).toString(), dart_string("，今年"), (this->age).toString(), dart_string("岁")));
return Void;
  }
  
};

// ============================================================================
// 类: StringBuilder
// ============================================================================

class StringBuilder {
private:
  ObjectPtr<StringBuffer> _buffer = ObjectPtr<StringBuffer>(new StringBuffer());
public:
  StringBuilder() {
  }
  
  ObjectPtr<StringBuilder> append(String text) {
    this->_buffer->write(text);
return ObjectPtr<std::remove_reference_t<decltype(*this)>>(this);
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
  
  ObjectPtr<Calculator> add(Double n) {
    this->value = this->value->operator_add(n);
return ObjectPtr<std::remove_reference_t<decltype(*this)>>(this);
  }
  
  ObjectPtr<Calculator> subtract(Double n) {
    this->value = this->value->operator_sub(n);
return ObjectPtr<std::remove_reference_t<decltype(*this)>>(this);
  }
  
  ObjectPtr<Calculator> multiply(Double n) {
    this->value = this->value->operator_mul(n);
return ObjectPtr<std::remove_reference_t<decltype(*this)>>(this);
  }
  
  ObjectPtr<Calculator> divide(Double n) {
    this->value = this->value->operator_div(n);
return ObjectPtr<std::remove_reference_t<decltype(*this)>>(this);
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
  
  ObjectPtr<Vector> operator_add(ObjectPtr<Vector> other) {
    return ObjectPtr<Vector>(new Vector(this->x->operator_add(other->x), this->y->operator_add(other->y)));
  }
  
  ObjectPtr<Vector> operator_sub(ObjectPtr<Vector> other) {
    return ObjectPtr<Vector>(new Vector(this->x->operator_sub(other->x), this->y->operator_sub(other->y)));
  }
  
  ObjectPtr<Vector> operator_mul(Double scalar) {
    return ObjectPtr<Vector>(new Vector(this->x->operator_mul(scalar), this->y->operator_mul(scalar)));
  }
  
  Bool operator_equals(ObjectPtr<Object> other) {
    return dart_is<ObjectPtr<Vector>>(other) && (this->x == other->x) && (this->y == other->y);
  }
  
  Int hashCode() {
    return Object::hash(this->x, this->y, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr);
  }
  
  Double length() {
    return MathExtension::sqrt(this->x->operator_mul(this->x)->operator_add(this->y->operator_mul(this->y)));
  }
  
  String toString() {
    return dart_concat(dart_string("Vector("), (this->x).toString(), dart_string(", "), (this->y).toString(), dart_string(")"));
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
  
  ObjectPtr<Complex> operator_add(ObjectPtr<Complex> other) {
    return ObjectPtr<Complex>(new Complex(this->real->operator_add(other->real), this->imaginary->operator_add(other->imaginary)));
  }
  
  ObjectPtr<Complex> operator_sub(ObjectPtr<Complex> other) {
    return ObjectPtr<Complex>(new Complex(this->real->operator_sub(other->real), this->imaginary->operator_sub(other->imaginary)));
  }
  
  ObjectPtr<Complex> operator_mul(ObjectPtr<Complex> other) {
    return ObjectPtr<Complex>(new Complex(this->real->operator_mul(other->real)->operator_sub(this->imaginary->operator_mul(other->imaginary)), this->real->operator_mul(other->imaginary)->operator_add(this->imaginary->operator_mul(other->real))));
  }
  
  ObjectPtr<Complex> operator_div(ObjectPtr<Complex> other) {
    auto denominator = other->real->operator_mul(other->real)->operator_add(other->imaginary->operator_mul(other->imaginary));
return ObjectPtr<Complex>(new Complex(this->real->operator_mul(other->real)->operator_add(this->imaginary->operator_mul(other->imaginary))->operator_div(denominator), this->imaginary->operator_mul(other->real)->operator_sub(this->real->operator_mul(other->imaginary))->operator_div(denominator)));
  }
  
  String toString() {
    return dart_concat((this->real).toString(), dart_string(" + "), (this->imaginary).toString(), dart_string("i"));
  }
  
};

// ============================================================================
// 类: Matrix
// ============================================================================

class Matrix {
public:
  ObjectPtr<List<ObjectPtr<List<Double>>>> data;
  Matrix(ObjectPtr<List<ObjectPtr<List<Double>>>> data) : data(data) {
  }
  
  ObjectPtr<Matrix> operator_add(ObjectPtr<Matrix> other) {
    auto result = dart_literal(dart_int(0));
for (auto i = dart_int(0); i->operator_less(this->data->size()); i = i->operator_add(dart_int(1))) {
auto row = dart_literal(dart_int(0));
for (auto j = dart_int(0); j->operator_less(this->data->operator_index(i)->size()); j = j->operator_add(dart_int(1))) {
row->add(this->data->operator_index(i)->operator_index(j)->operator_add(other->data->operator_index(i)->operator_index(j)));
}
result->add(row);
}
return ObjectPtr<Matrix>(new Matrix(result));
  }
  
  ObjectPtr<List<Double>> operator_index(Int index) {
    return this->data->operator_index(index);
  }
  
  String toString() {
    return this->data->toString();
  }
  
};

// ============================================================================
// 类: Point
// ============================================================================

class Point : virtual public Comparable {
public:
  Double x;
  Double y;
  Point(Double x, Double y) : x(x), y(y) {
  }
  
  Int compareTo(ObjectPtr<Point> other) {
    auto thisDistance = this->x->operator_mul(this->x)->operator_add(this->y->operator_mul(this->y));
auto otherDistance = other->x->operator_mul(other->x)->operator_add(other->y->operator_mul(other->y));
return thisDistance->compareTo(otherDistance);
  }
  
  Bool operator_less(ObjectPtr<Point> other) {
    return this->compareTo(other)->operator_less(dart_int(0));
  }
  
  Bool operator_greater(ObjectPtr<Point> other) {
    return this->compareTo(other)->operator_greater(dart_int(0));
  }
  
  Bool operator_less_equals(ObjectPtr<Point> other) {
    return this->compareTo(other)->operator_less_equals(dart_int(0));
  }
  
  Bool operator_greater_equals(ObjectPtr<Point> other) {
    return this->compareTo(other)->operator_greater_equals(dart_int(0));
  }
  
  Bool operator_equals(ObjectPtr<Object> other) {
    return dart_is<ObjectPtr<Point>>(other) && (this->x == other->x) && (this->y == other->y);
  }
  
  Int hashCode() {
    return Object::hash(this->x, this->y, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr, nullptr);
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
    dart_print(dart_string("    获取用户: ") + (id).toString());
return Void;
  }
  
  Nullable createUser(String name, String email) {
    dart_print(dart_concat(dart_string("    创建用户: "), (name).toString(), dart_string(", "), (email).toString()));
return Void;
  }
  
  Nullable deleteUser(String id) {
    dart_print(dart_string("    删除用户: ") + (id).toString());
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
    dart_print(dart_string("    验证邮箱: ") + (email).toString());
return Void;
  }
  
  Nullable validateAge(Int age) {
    dart_print(dart_string("    验证年龄: ") + (age).toString());
return Void;
  }
  
  Nullable validatePassword(String password) {
    dart_print(dart_string("    验证密码: ") + (password->replaceAll(RegExp::(dart_string("."), Bool(Null), Bool(Null), Bool(Null), Bool(Null)), dart_string("*"))).toString());
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

Nullable testClosuresAndHigherOrder();
Nullable testCascadeNotation();
Nullable testExtensionMethods();
Nullable testOperatorOverloading();
Nullable testMetadataAnnotations();
Nullable testFunctionalProgramming();
String StringExtensions|capitalize(String _this);
ObjectPtr<TypedFunction<std::function<String()>, String>> StringExtensions|get_capitalize(String _this);
Bool StringExtensions|isPalindrome(String _this);
ObjectPtr<TypedFunction<std::function<Bool()>, Bool>> StringExtensions|get_isPalindrome(String _this);
Int StringExtensions|wordCount(String _this);
ObjectPtr<TypedFunction<std::function<Int()>, Int>> StringExtensions|get_wordCount(String _this);
String StringExtensions|reverse(String _this);
ObjectPtr<TypedFunction<std::function<String()>, String>> StringExtensions|get_reverse(String _this);
Int IntExtensions|factorial(Int _this);
ObjectPtr<TypedFunction<std::function<Int()>, Int>> IntExtensions|get_factorial(Int _this);
Bool IntExtensions|isPrime(Int _this);
ObjectPtr<TypedFunction<std::function<Bool()>, Bool>> IntExtensions|get_isPrime(Int _this);
Int IntExtensions|squared(Int _this);
ObjectPtr<TypedFunction<std::function<Int()>, Int>> IntExtensions|get_squared(Int _this);
template<typename T>
T ListExtensions|secondOrNull(ObjectPtr<List<T>> _this);
template<typename T>
ObjectPtr<TypedFunction<std::function<T()>, T>> ListExtensions|get_secondOrNull(ObjectPtr<List<T>> _this);
template<typename T>
T ListExtensions|secondLastOrNull(ObjectPtr<List<T>> _this);
template<typename T>
ObjectPtr<TypedFunction<std::function<T()>, T>> ListExtensions|get_secondLastOrNull(ObjectPtr<List<T>> _this);
template<typename T>
T ListExtensions|random(ObjectPtr<List<T>> _this);
template<typename T>
ObjectPtr<TypedFunction<std::function<T()>, T>> ListExtensions|get_random(ObjectPtr<List<T>> _this);
Bool DateTimeExtensions|isToday(ObjectPtr<DateTime> _this);
ObjectPtr<TypedFunction<std::function<Bool()>, Bool>> DateTimeExtensions|get_isToday(ObjectPtr<DateTime> _this);
ObjectPtr<TypedFunction<std::function<String()>, String>> DateTimeExtensions|get_formatDate(ObjectPtr<DateTime> _this);
String DateTimeExtensions|formatDate(ObjectPtr<DateTime> _this);
ObjectPtr<DateTime> DateTimeExtensions|addBusinessDays(ObjectPtr<DateTime> _this, Int days);
ObjectPtr<TypedFunction<std::function<ObjectPtr<DateTime>(Int)>, ObjectPtr<DateTime>, Int>> DateTimeExtensions|get_addBusinessDays(ObjectPtr<DateTime> _this);
template<typename T>
template<typename R>
R LetExtension::let(T _this, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> block);
template<typename T>
ObjectPtr<TypedFunction<std::function<Any(ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>>)>, Any, ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>>>> LetExtension::get_let(T _this);
Double MathExtension::sqrt(Double _this);
ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension::get_sqrt(Double _this);
template<typename T>
template<typename R>
R applyTwice(T value, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> func);
template<typename T>
template<typename R>
template<typename S>
ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>> compose(ObjectPtr<TypedFunction<std::function<S(R)>, S, R>> f, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> g);
template<typename T>
template<typename U>
template<typename R>
ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>> curry(ObjectPtr<TypedFunction<std::function<R(T, U)>, R, T, U>> func);
template<typename T>
ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>> pipe(ObjectPtr<List<ObjectPtr<Function>>> functions);
template<typename T>
template<typename U>
template<typename R>
ObjectPtr<TypedFunction<std::function<Any(U)>, Any, U>> partial(ObjectPtr<TypedFunction<std::function<R(T, U)>, R, T, U>> func, T first);
ObjectPtr<Function> memoize(ObjectPtr<Function> func);
Int fibonacci(Int n);
ObjectPtr<Iterable> generateLazy(Int max);
Nullable testClosuresAndHigherOrder() {
  dart_print(dart_string("\n📌 测试闭包和高阶函数"));
auto makeAdder = [&](Int addBy) -> ObjectPtr<Function> return makeFunction([&](Int i) { return i->operator_add(addBy); });;
auto add2 = makeAdder(dart_int(2));
auto add5 = makeAdder(dart_int(5));
dart_print(dart_string("  简单闭包:"));
dart_print(dart_string("    add2(10): ") + (add2->call(dart_int(10))).toString());
dart_print(dart_string("    add5(10): ") + (add5->call(dart_int(10))).toString());
auto makeCounter = [&]() -> ObjectPtr<Function> auto count = dart_int(0);
return makeFunction([&]() { count = count->operator_add(dart_int(1));
return count; });;
auto counter = makeCounter();
dart_print(dart_string("  计数器闭包:"));
dart_print(dart_concat(dart_string("    计数: "), (counter->call()).toString(), dart_string(", "), (counter->call()).toString(), dart_string(", "), (counter->call()).toString()));
auto makeMultiplier = [&](Int factor) -> ObjectPtr<Function> auto callCount = dart_int(0);
return makeFunction([&](Int value) { callCount = callCount->operator_add(dart_int(1));
dart_print(dart_concat(dart_string("    调用第"), (callCount).toString(), dart_string("次")));
return value->operator_mul(factor); });;
auto triple = makeMultiplier(dart_int(3));
dart_print(dart_string("  多变量闭包:"));
dart_print(dart_string("    triple(5): ") + (triple->call(dart_int(5))).toString());
dart_print(dart_string("    triple(7): ") + (triple->call(dart_int(7))).toString());
auto functions = dart_literal(dart_int(0));
for (auto i = dart_int(0); i->operator_less(dart_int(3)); i = i->operator_add(dart_int(1))) {
auto captured = i;
functions->add(makeFunction([&]() { return captured; }));
}
dart_print(dart_string("  循环变量捕获:"));
dart_print(dart_concat(dart_string("    捕获的值: "), (functions->operator_index(dart_int(0))->call()).toString(), dart_string(", "), (functions->operator_index(dart_int(1))->call()).toString(), dart_string(", "), (functions->operator_index(dart_int(2))->call()).toString()));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto result = applyTwice(dart_int(5), makeFunction([&](Int x) { return x->operator_mul(dart_int(2)); }));
dart_print(dart_string("  高阶函数:"));
dart_print(dart_string("    applyTwice(5, x*2): ") + (result).toString());
auto addOne = makeFunction([&](Int x) { return x->operator_add(dart_int(1)); });
auto multiplyByTwo = makeFunction([&](Int x) { return x->operator_mul(dart_int(2)); });
auto composed = /* Invalid: temp_dart_source.dart:99:32: Error: A value of type 'dynamic Function(int)' can't be assigned to a variable of type 'int Function(int)'.
  int Function(int) composed = compose(multiplyByTwo, addOne);
                               ^ */;
dart_print(dart_string("    函数组合 (x+1)*2 应用于5: ") + (composed->call(dart_int(5))).toString());
auto curriedAdd = curry(makeFunction([&](Int a, Int b) { return a->operator_add(b); }));
Any add10 = curriedAdd->call(dart_int(10));
dart_print(dart_string("    柯里化加法: ") + (add10.call(dart_int(5))).toString());
return Void;
}

Nullable testCascadeNotation() {
  dart_print(dart_string("\n📌 测试级联操作符"));
auto person = ([&]() { auto let_var = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25))); return ([&]() { let_var->name = dart_string("Alice Smith"); let_var->age = dart_int(26); let_var->introduce(); return let_var; })(); })();
dart_print(dart_string("  基本级联:"));
dart_print(dart_concat(dart_string("    人员信息: "), (person->name).toString(), dart_string(", "), (person->age).toString(), dart_string("岁")));
auto builder = ([&]() { auto let_var = ObjectPtr<StringBuilder>(new StringBuilder()); return ([&]() { let_var->append(dart_string("Hello")); let_var->append(dart_string(" ")); let_var->append(dart_string("World")); let_var->append(dart_string("!")); return let_var; })(); })();
dart_print(dart_string("  级联方法调用:"));
dart_print(dart_string("    构建结果: ") + (builder->toString()).toString());
auto numbers = ([&]() { auto let_var = dart_literal(dart_int(0)); return ([&]() { let_var->add(dart_int(1)); let_var->add(dart_int(2)); let_var->add(dart_int(3)); let_var->addAll(dart_literal(dart_int(4), dart_int(5), dart_int(6))); return let_var; })(); })();
dart_print(dart_string("  嵌套级联:"));
dart_print(dart_string("    列表内容: ") + (numbers).toString());
auto calculator = ([&]() { auto let_var = ObjectPtr<Calculator>(new Calculator()); return ([&]() { let_var->add(dart_double(10.0)); let_var->multiply(dart_double(2.0)); return let_var; })(); })();
if (calculator->value->operator_greater(dart_int(15))) {
([&]() { auto let_var = calculator; return ([&]() { let_var->subtract(dart_double(5.0)); let_var->divide(dart_double(3.0)); return let_var; })(); })();
}
dart_print(dart_string("  条件级联:"));
dart_print(dart_string("    计算结果: ") + (calculator->value).toString());
auto nullablePerson = ObjectPtr<Person>(new Person(dart_string("Bob"), dart_int(30)));
([&]() { auto let_var = nullablePerson; return dart_is_null(let_var) ? Null : ([&]() { let_var->name = dart_string("Bob Johnson"); let_var->age = dart_int(31); let_var->introduce(); return let_var; })(); })();
nullablePerson = Null;
([&]() { auto let_var = nullablePerson; return dart_is_null(let_var) ? Null : ([&]() { let_var->name = dart_string("Won't execute"); let_var->introduce(); return let_var; })(); })();
dart_print(dart_string("    空值级联测试完成"));
return Void;
}

Nullable testExtensionMethods() {
  dart_print(dart_string("\n📌 测试扩展方法"));
auto text = dart_string("hello world");
dart_print(dart_string("  字符串扩展:"));
dart_print(dart_string("    首字母大写: ") + (StringExtensions|capitalize(text)).toString());
dart_print(dart_string("    是否为回文: ") + (StringExtensions|isPalindrome(text)).toString());
dart_print(dart_string("    单词数量: ") + (StringExtensions|wordCount(text)).toString());
dart_print(dart_string("    反转: ") + (StringExtensions|reverse(text)).toString());
auto palindrome = dart_string("racecar");
dart_print(dart_concat(dart_string("    \""), (palindrome).toString(), dart_string("\" 是回文: "), (StringExtensions|isPalindrome(palindrome)).toString()));
auto number = dart_int(5);
dart_print(dart_string("  数字扩展:"));
dart_print(dart_string("    阶乘: ") + (IntExtensions|factorial(number)).toString());
dart_print(dart_string("    是否为偶数: ") + (number->isEven()).toString());
dart_print(dart_string("    是否为质数: ") + (IntExtensions|isPrime(number)).toString());
dart_print(dart_string("    平方: ") + (IntExtensions|squared(number)).toString());
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("  列表扩展:"));
dart_print(dart_string("    第二个元素: ") + (ListExtensions|secondOrNull(numbers)).toString());
dart_print(dart_string("    倒数第二个: ") + (ListExtensions|secondLastOrNull(numbers)).toString());
dart_print(dart_string("    随机元素: ") + (ListExtensions|random(numbers)).toString());
auto empty = dart_literal(dart_int(0));
dart_print(dart_string("    空列表第二个: ") + (ListExtensions|secondOrNull(empty)).toString());
auto now = ObjectPtr<DateTime>(new DateTime());
dart_print(dart_string("  日期时间扩展:"));
dart_print(dart_string("    是否为今天: ") + (DateTimeExtensions|isToday(now)).toString());
dart_print(dart_string("    格式化: ") + (DateTimeExtensions|formatDate(now)).toString());
dart_print(dart_string("    添加工作日: ") + (DateTimeExtensions|formatDate(DateTimeExtensions|addBusinessDays(now, dart_int(5)))).toString());
auto result1 = LetExtension::let(dart_int(42), makeFunction([&](Int value) { return value->operator_mul(dart_int(2)); }));
auto result2 = LetExtension::let(dart_string("hello"), makeFunction([&](String value) { return value->toUpperCase(); }));
dart_print(dart_string("  泛型扩展:"));
dart_print(dart_string("    let应用于数字: ") + (result1).toString());
dart_print(dart_string("    let应用于字符串: ") + (result2).toString());
return Void;
}

Nullable testOperatorOverloading() {
  dart_print(dart_string("\n📌 测试操作符重载"));
auto v1 = ObjectPtr<Vector>(new Vector(dart_double(3.0), dart_double(4.0)));
auto v2 = ObjectPtr<Vector>(new Vector(dart_double(1.0), dart_double(2.0)));
dart_print(dart_string("  向量操作符重载:"));
dart_print(dart_string("    v1: ") + (v1).toString());
dart_print(dart_string("    v2: ") + (v2).toString());
dart_print(dart_string("    v1 + v2: ") + (v1->operator_add(v2)).toString());
dart_print(dart_string("    v1 - v2: ") + (v1->operator_sub(v2)).toString());
dart_print(dart_string("    v1 * 2: ") + (v1->operator_mul(dart_double(2.0))).toString());
dart_print(dart_string("    v1 == v2: ") + ((v1 == v2)).toString());
dart_print(dart_string("    v1长度: ") + (v1->size()).toString());
auto c1 = ObjectPtr<Complex>(new Complex(dart_double(3.0), dart_double(4.0)));
auto c2 = ObjectPtr<Complex>(new Complex(dart_double(1.0), dart_double(2.0)));
dart_print(dart_string("  复数操作符重载:"));
dart_print(dart_string("    c1: ") + (c1).toString());
dart_print(dart_string("    c2: ") + (c2).toString());
dart_print(dart_string("    c1 + c2: ") + (c1->operator_add(c2)).toString());
dart_print(dart_string("    c1 - c2: ") + (c1->operator_sub(c2)).toString());
dart_print(dart_string("    c1 * c2: ") + (c1->operator_mul(c2)).toString());
dart_print(dart_string("    c1 / c2: ") + (c1->operator_div(c2)).toString());
auto m1 = ObjectPtr<Matrix>(new Matrix(dart_literal(dart_literal(dart_double(1.0), dart_double(2.0)), dart_literal(dart_double(3.0), dart_double(4.0)))));
auto m2 = ObjectPtr<Matrix>(new Matrix(dart_literal(dart_literal(dart_double(5.0), dart_double(6.0)), dart_literal(dart_double(7.0), dart_double(8.0)))));
dart_print(dart_string("  矩阵操作符重载:"));
dart_print(dart_string("    m1: ") + (m1).toString());
dart_print(dart_string("    m2: ") + (m2).toString());
dart_print(dart_string("    m1 + m2: ") + (m1->operator_add(m2)).toString());
dart_print(dart_string("    m1[0][1]: ") + (m1->operator_index(dart_int(0))->operator_index(dart_int(1))).toString());
auto p1 = ObjectPtr<Point>(new Point(dart_double(1.0), dart_double(2.0)));
auto p2 = ObjectPtr<Point>(new Point(dart_double(3.0), dart_double(4.0)));
auto p3 = ObjectPtr<Point>(new Point(dart_double(1.0), dart_double(2.0)));
dart_print(dart_string("  点比较:"));
dart_print(dart_string("    p1 < p2: ") + (p1->operator_less(p2)).toString());
dart_print(dart_string("    p1 == p3: ") + ((p1 == p3)).toString());
dart_print(dart_string("    p1.hashCode == p3.hashCode: ") + ((p1->hashCode() == p3->hashCode())).toString());
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
auto result = numbers->where(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }))->map(makeFunction([&](Int n) { return n->operator_mul(n); }))->where(makeFunction([&](Int n) { return n->operator_greater(dart_int(10)); }))->toList();
dart_print(dart_string("  函数式链式操作:"));
dart_print(dart_string("    偶数平方大于10: ") + (result).toString());
auto pipeline = pipe(dart_literal(makeFunction([&](ObjectPtr<List<Int>> list) { return list->where(makeFunction([&](Int n) { return n->operator_greater(dart_int(5)); })); }), makeFunction([&](ObjectPtr<Iterable> iter) { return iter->map(makeFunction([&](Int n) { return n->operator_mul(dart_int(2)); })); }), makeFunction([&](ObjectPtr<Iterable> iter) { return iter->toList(); })));
Any pipeResult = pipeline->call(numbers);
dart_print(dart_string("    管道处理结果: ") + (pipeResult).toString());
auto multiply = makeFunction([&](Int a, Int b) { return a->operator_mul(b); });
auto double = partial(multiply, dart_int(2));
dart_print(dart_string("  部分应用:"));
dart_print(dart_string("    double(5): ") + (double->call(dart_int(5))).toString());
auto fibMemo = memoize(makeFunction(&fibonacci));
dart_print(dart_string("  记忆化斐波那契:"));
dart_print(dart_string("    fib(10): ") + (fibMemo->call(dart_int(10))).toString());
dart_print(dart_string("    fib(15): ") + (fibMemo->call(dart_int(15))).toString());
auto lazyNumbers = generateLazy(dart_int(1000000));
auto firstFive = lazyNumbers->take(dart_int(5))->toList();
dart_print(dart_string("  惰性求值:"));
dart_print(dart_string("    前5个数: ") + (firstFive).toString());
return Void;
}

String StringExtensions_capitalize(String this) {
  if (this->isEmpty()) {
return ObjectPtr<std::remove_reference_t<decltype(*this)>>(this);
}
return this->operator_index(dart_int(0))->toUpperCase()->operator_add(this->substring(dart_int(1)));
}

ObjectPtr<TypedFunction<std::function<String()>, String>> StringExtensions_get_capitalize(String this) {
  return makeFunction([&]() { return StringExtensions|capitalize(this); });
}

Bool StringExtensions_isPalindrome(String this) {
  auto cleaned = this->toLowerCase()->replaceAll(RegExp::(dart_string("[^a-z0-9]"), Bool(Null), Bool(Null), Bool(Null), Bool(Null)), dart_string(""));
return (cleaned == cleaned->split(dart_string(""))->reversed()->join(dart_string("")));
}

ObjectPtr<TypedFunction<std::function<Bool()>, Bool>> StringExtensions_get_isPalindrome(String this) {
  return makeFunction([&]() { return StringExtensions|isPalindrome(this); });
}

Int StringExtensions_wordCount(String this) {
  return this->trim()->split(RegExp::(dart_string("\\s+"), Bool(Null), Bool(Null), Bool(Null), Bool(Null)))->where(makeFunction([&](String word) { return word->isNotEmpty(); }))->size();
}

ObjectPtr<TypedFunction<std::function<Int()>, Int>> StringExtensions_get_wordCount(String this) {
  return makeFunction([&]() { return StringExtensions|wordCount(this); });
}

String StringExtensions_reverse(String this) {
  return this->split(dart_string(""))->reversed()->join(dart_string(""));
}

ObjectPtr<TypedFunction<std::function<String()>, String>> StringExtensions_get_reverse(String this) {
  return makeFunction([&]() { return StringExtensions|reverse(this); });
}

Int IntExtensions_factorial(Int this) {
  if (this->operator_less_equals(dart_int(1))) {
return dart_int(1);
}
return this->operator_mul(IntExtensions|factorial(this->operator_sub(dart_int(1))));
}

ObjectPtr<TypedFunction<std::function<Int()>, Int>> IntExtensions_get_factorial(Int this) {
  return makeFunction([&]() { return IntExtensions|factorial(this); });
}

Bool IntExtensions_isPrime(Int this) {
  if (this->operator_less_equals(dart_int(1))) {
return dart_bool(false);
}
if (this->operator_less_equals(dart_int(3))) {
return dart_bool(true);
}
if ((this->operator_mod(dart_int(2)) == dart_int(0)) || (this->operator_mod(dart_int(3)) == dart_int(0))) {
return dart_bool(false);
}
for (auto i = dart_int(5); i->operator_mul(i)->operator_less_equals(this); i = i->operator_add(dart_int(6))) {
if ((this->operator_mod(i) == dart_int(0)) || (this->operator_mod(i->operator_add(dart_int(2))) == dart_int(0))) {
return dart_bool(false);
}
}
return dart_bool(true);
}

ObjectPtr<TypedFunction<std::function<Bool()>, Bool>> IntExtensions_get_isPrime(Int this) {
  return makeFunction([&]() { return IntExtensions|isPrime(this); });
}

Int IntExtensions_squared(Int this) {
  return this->operator_mul(this);
}

ObjectPtr<TypedFunction<std::function<Int()>, Int>> IntExtensions_get_squared(Int this) {
  return makeFunction([&]() { return IntExtensions|squared(this); });
}

template<typename T>
T ListExtensions_secondOrNull(ObjectPtr<List<T>> this) {
  return this->size()->operator_greater_equals(dart_int(2)) ? this->operator_index(dart_int(1)) : Null;
}

template<typename T>
ObjectPtr<TypedFunction<std::function<T()>, T>> ListExtensions_get_secondOrNull(ObjectPtr<List<T>> this) {
  return makeFunction([&]() { return ListExtensions|secondOrNull(this); });
}

template<typename T>
T ListExtensions_secondLastOrNull(ObjectPtr<List<T>> this) {
  return this->size()->operator_greater_equals(dart_int(2)) ? this->operator_index(this->size()->operator_sub(dart_int(2))) : Null;
}

template<typename T>
ObjectPtr<TypedFunction<std::function<T()>, T>> ListExtensions_get_secondLastOrNull(ObjectPtr<List<T>> this) {
  return makeFunction([&]() { return ListExtensions|secondLastOrNull(this); });
}

template<typename T>
T ListExtensions_random(ObjectPtr<List<T>> this) {
  if (this->isEmpty()) {
throw DartException(ObjectPtr<StateError>(new StateError(dart_string("Empty list"))));
}
return this->operator_index(ObjectPtr<DateTime>(new DateTime())->millisecondsSinceEpoch()->operator_mod(this->size()));
}

template<typename T>
ObjectPtr<TypedFunction<std::function<T()>, T>> ListExtensions_get_random(ObjectPtr<List<T>> this) {
  return makeFunction([&]() { return ListExtensions|random(this); });
}

Bool DateTimeExtensions_isToday(ObjectPtr<DateTime> this) {
  auto now = ObjectPtr<DateTime>(new DateTime());
return (this->year() == now->year()) && (this->month() == now->month()) && (this->day() == now->day());
}

ObjectPtr<TypedFunction<std::function<Bool()>, Bool>> DateTimeExtensions_get_isToday(ObjectPtr<DateTime> this) {
  return makeFunction([&]() { return DateTimeExtensions|isToday(this); });
}

ObjectPtr<TypedFunction<std::function<String()>, String>> DateTimeExtensions_get_formatDate(ObjectPtr<DateTime> this) {
  return makeFunction([&]() { return DateTimeExtensions|formatDate(this); });
}

String DateTimeExtensions_formatDate(ObjectPtr<DateTime> this) {
  return dart_concat((this->year()).toString(), dart_string("-"), (this->month()->toString()->padLeft(dart_int(2), dart_string("0"))).toString(), dart_string("-"), (this->day()->toString()->padLeft(dart_int(2), dart_string("0"))).toString());
}

ObjectPtr<DateTime> DateTimeExtensions_addBusinessDays(ObjectPtr<DateTime> this, Int days) {
  auto result = this;
auto addedDays = dart_int(0);
while (addedDays->operator_less(days)) {
result = result->add(ObjectPtr<Duration>(new Duration(dart_int(1), Int(Null), Int(Null), Int(Null), Int(Null), Int(Null))));
if (result->weekday()->operator_less(dart_int(6))) {
addedDays = addedDays->operator_add(dart_int(1));
}
}
return result;
}

ObjectPtr<TypedFunction<std::function<ObjectPtr<DateTime>(Int)>, ObjectPtr<DateTime>, Int>> DateTimeExtensions_get_addBusinessDays(ObjectPtr<DateTime> this) {
  return makeFunction([&](Int days) { return DateTimeExtensions|addBusinessDays(this, days); });
}

template<typename T>
template<typename R>
R LetExtension_let(T this, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> block) {
  return block->call(this);
}

template<typename T>
ObjectPtr<TypedFunction<std::function<Any(ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>>)>, Any, ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>>>> LetExtension_get_let(T this) {
  return makeFunction([&](ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> block) { return LetExtension::let(this, block); });
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

template<typename T>
template<typename R>
R applyTwice(T value, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> func) {
  return func->call(dart_cast<T>(func->call(value)));
}

template<typename T>
template<typename R>
template<typename S>
ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>> compose(ObjectPtr<TypedFunction<std::function<S(R)>, S, R>> f, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> g) {
  return makeFunction([&](T x) { return f->call(g->call(x)); });
}

template<typename T>
template<typename U>
template<typename R>
ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>> curry(ObjectPtr<TypedFunction<std::function<R(T, U)>, R, T, U>> func) {
  return makeFunction([&](T first) { return makeFunction([&](U second) { return func->call(first, second); }); });
}

template<typename T>
ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>> pipe(ObjectPtr<List<ObjectPtr<Function>>> functions) {
  return makeFunction([&](T input) { Any result = input;
auto sync_for_iterator = functions->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto func = sync_for_iterator->next();
result = func->call(result);
}
return result; });
}

template<typename T>
template<typename U>
template<typename R>
ObjectPtr<TypedFunction<std::function<Any(U)>, Any, U>> partial(ObjectPtr<TypedFunction<std::function<R(T, U)>, R, T, U>> func, T first) {
  return makeFunction([&](U second) { return func->call(first, second); });
}

ObjectPtr<Function> memoize(ObjectPtr<Function> func) {
  auto cache = Map<String, Any>::create();
return makeFunction([&](Any arg) { auto key = DART_ANY_CALL(arg, toString);
if (cache->containsKey(key)) {
return cache->operator_index(key);
}
Any result = func->call(arg);
cache->operator_index_set(key, result);
return result; });
}

Int fibonacci(Int n) {
  if (n->operator_less_equals(dart_int(1))) {
return n;
}
return fibonacci(n->operator_sub(dart_int(1)))->operator_add(fibonacci(n->operator_sub(dart_int(2))));
}

ObjectPtr<Iterable> generateLazy(Int max) {
  for (auto i = dart_int(0); i->operator_less(max); i = i->operator_add(dart_int(1))) {
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

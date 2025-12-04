#include "dart2cpp.h"

// 工具宏定义

Nullable testBasicTypes() {
  dart_print(dart_string("\n📌 测试基本数据类型"));
auto intValue = dart_int(42);
auto hexValue = dart_int(255);
auto negativeInt = dart_int(-10);
auto zero = dart_int(0);
auto doubleValue = dart_double(3.14159);
auto scientificValue = dart_double(142000.0);
auto negativeDouble = dart_double(-2.5);
auto trueValue = dart_bool(true);
auto falseValue = dart_bool(false);
auto singleQuote = dart_string("Hello");
auto doubleQuote = dart_string("World");
auto emptyString = dart_string("");
auto multiLine = dart_string("    This is a\n    multi-line string\n  ");
auto interpolation = dart_concat(dart_string("The answer is "), intValue);
auto expression = dart_concat(dart_string("Sum: "), (intValue + doubleValue));
dart_print(dart_concat(dart_string("  整数: "), intValue, dart_string(", 十六进制: "), hexValue, dart_string(", 负数: "), negativeInt, dart_string(", 零: "), zero));
dart_print(dart_concat(dart_string("  浮点数: "), doubleValue, dart_string(", 科学计数法: "), scientificValue, dart_string(", 负数: "), negativeDouble));
dart_print(dart_concat(dart_string("  布尔值: "), trueValue, dart_string(", "), falseValue));
dart_print(dart_concat(dart_string("  字符串: "), singleQuote, dart_string(" "), doubleQuote));
dart_print(dart_concat(dart_string("  插值: "), interpolation));
dart_print(dart_concat(dart_string("  表达式: "), expression));
dart_print(dart_concat(dart_string("  多行字符串长度: "), multiLine.length()));
return Void;
}

Nullable testVariableDeclarations() {
  dart_print(dart_string("\n📌 测试变量声明"));
auto autoInt = dart_int(100);
auto autoString = dart_string("auto");
auto autoDouble = dart_double(3.14);
auto autoBool = dart_bool(true);
const auto finalValue = dart_string("cannot change");
const auto typedFinal = dart_int(200);
const auto now = ObjectPtr<DateTime>(new DateTime());
Int nullableInt;
auto nullableString = Null;
Double nullableDouble;
auto nonNull = ([&]() { String let_var = nullableString; return dart_is_null(let_var) ? dart_string("default") : let_var; })();
dart_is_null(nullableInt) ? nullableInt = dart_int(42) : Null;
dart_print(dart_concat(dart_string("  var: "), autoInt, dart_string(", "), autoString, dart_string(", "), autoDouble, dart_string(", "), autoBool));
dart_print(dart_concat(dart_string("  final: "), finalValue, dart_string(", "), typedFinal));
dart_print(dart_string("  const: compile time constant, 3.14159, 100"));
dart_print(dart_concat(dart_string("  nullable: "), nullableInt, dart_string(", "), nullableString, dart_string(", "), nullableDouble));
dart_print(dart_concat(dart_string("  non-null: "), nonNull));
}

Nullable testOperators() {
  dart_print(dart_string("\n📌 测试运算符"));
auto a = dart_int(10);
auto b = dart_int(3);
auto x = dart_double(5.5);
auto y = dart_double(2.2);
dart_print(dart_string("  算术运算:"));
dart_print(dart_concat(dart_string("    "), a, dart_string(" + "), b, dart_string(" = "), (a + b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" - "), b, dart_string(" = "), (a - b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" * "), b, dart_string(" = "), (a * b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" / "), b, dart_string(" = "), (a / b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" % "), b, dart_string(" = "), (a % b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" ~/ "), b, dart_string(" = "), a.truncatingDivision(b)));
dart_print(dart_concat(dart_string("    -"), a, dart_string(" = "), a.operator_negate()));
dart_print(dart_string("  比较运算:"));
dart_print(dart_concat(dart_string("    "), a, dart_string(" == "), b, dart_string(": "), (a == b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" != "), b, dart_string(": "), !((a == b))));
dart_print(dart_concat(dart_string("    "), a, dart_string(" > "), b, dart_string(": "), (a > b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" < "), b, dart_string(": "), (a < b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" >= "), b, dart_string(": "), (a >= b)));
dart_print(dart_concat(dart_string("    "), a, dart_string(" <= "), b, dart_string(": "), (a <= b)));
auto p = dart_bool(true);
auto q = dart_bool(false);
dart_print(dart_string("  逻辑运算:"));
dart_print(dart_concat(dart_string("    "), p, dart_string(" && "), q, dart_string(": "), p && q));
dart_print(dart_concat(dart_string("    "), p, dart_string(" || "), q, dart_string(": "), p || q));
dart_print(dart_concat(dart_string("    !"), p, dart_string(": "), !(p)));
dart_print(dart_concat(dart_string("    !"), q, dart_string(": "), !(q)));
auto m = dart_int(12);
auto n = dart_int(5);
dart_print(dart_string("  位运算:"));
dart_print(dart_concat(dart_string("    "), m, dart_string(" & "), n, dart_string(": "), m.operator_bitwise_and(n)));
dart_print(dart_concat(dart_string("    "), m, dart_string(" | "), n, dart_string(": "), m.operator_bitwise_or(n)));
dart_print(dart_concat(dart_string("    "), m, dart_string(" ^ "), n, dart_string(": "), m.operator_bitwise_xor(n)));
dart_print(dart_concat(dart_string("    ~"), m, dart_string(": "), m.operator_bitwise_not()));
dart_print(dart_concat(dart_string("    "), m, dart_string(" << 1: "), m.operator_shift_left(dart_int(1))));
dart_print(dart_concat(dart_string("    "), m, dart_string(" >> 1: "), m.operator_shift_right(dart_int(1))));
auto c = dart_int(5);
c = (c + dart_int(2));
dart_print(dart_concat(dart_string("  赋值运算: c += 2 结果: "), c));
c = (c - dart_int(1));
dart_print(dart_concat(dart_string("  赋值运算: c -= 1 结果: "), c));
c = (c * dart_int(3));
dart_print(dart_concat(dart_string("  赋值运算: c *= 3 结果: "), c));
c = c.truncatingDivision(dart_int(2));
dart_print(dart_concat(dart_string("  赋值运算: c ~/= 2 结果: "), c));
auto result = (a > b) ? dart_string("a is greater") : dart_string("b is greater");
dart_print(dart_concat(dart_string("  三元运算符: "), result));
String nullable;
auto safe = ([&]() { String let_var = nullable; return dart_is_null(let_var) ? dart_string("default value") : let_var; })();
dart_print(dart_concat(dart_string("  空值合并: "), safe));
}

Nullable testControlFlow() {
  dart_print(dart_string("\n📌 测试控制流"));
auto score = dart_int(85);
dart_print(dart_string("  if-else 测试:"));
if ((score >= dart_int(90))) {
dart_print(dart_string("    成绩: 优秀"));
} else {
if ((score >= dart_int(80))) {
dart_print(dart_string("    成绩: 良好"));
} else {
if ((score >= dart_int(70))) {
dart_print(dart_string("    成绩: 中等"));
} else {
dart_print(dart_string("    成绩: 需要努力"));
}
}
}
auto grade = dart_string("B");
dart_print(dart_string("  switch-case 测试:"));
if (grade == dart_string("A")) {
  dart_print(dart_string("    等级: 优秀"));
} else if (grade == dart_string("B")) {
  dart_print(dart_string("    等级: 良好"));
} else if (grade == dart_string("C")) {
  dart_print(dart_string("    等级: 中等"));
}else {
  dart_print(dart_string("    等级: 未知"));
}
dart_print(dart_string("  for 循环测试:"));
for (auto i = dart_int(0); (i < dart_int(5)); ++i) {
dart_print(dart_concat(dart_string("    索引: "), i, dart_string(", 值: "), (i * i)));
}
auto fruits = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"));
dart_print(dart_string("  for-in 循环测试:"));
auto :sync-for-iterator = fruits->iterator();
for (; :sync-for-iterator->moveNext(); ) {
auto fruit = :sync-for-iterator->current();
dart_print(dart_concat(dart_string("    水果: "), fruit));
}
dart_print(dart_string("  while 循环测试:"));
auto count = dart_int(0);
while ((count < dart_int(3))) {
dart_print(dart_concat(dart_string("    计数: "), count));
count = (count + dart_int(1));
}
dart_print(dart_string("  do-while 循环测试:"));
auto num = dart_int(0);
do {
dart_print(dart_concat(dart_string("    数字: "), num));
num = (num + dart_int(1));
} while (((num < dart_int(3))).toBool());
dart_print(dart_string("  break 和 continue 测试:"));
for (auto i = dart_int(0); (i < dart_int(10)); ++i) {
if ((i == dart_int(2))) {
break;
}
if ((i == dart_int(7))) {
break;
}
dart_print(dart_concat(dart_string("    处理: "), i));
};
return Void;
}

Nullable testStringOperations() {
  dart_print(dart_string("\n📌 测试字符串操作"));
auto str1 = dart_string("Hello");
auto str2 = dart_string("World");
auto str3 = dart_string("  Dart Programming  ");
auto concat = ((str1 + dart_string(" ")) + str2);
dart_print(dart_concat(dart_string("  连接: "), concat));
auto value = dart_int(42);
auto interpolated = dart_concat(dart_string("The answer is "), value);
auto expression = dart_concat(dart_string("Sum: "), (dart_int(10) + dart_int(20)));
dart_print(dart_concat(dart_string("  插值: "), interpolated));
dart_print(dart_concat(dart_string("  表达式插值: "), expression));
dart_print(dart_string("  字符串属性:"));
dart_print(dart_concat(dart_string("    长度: "), str1.length()));
dart_print(dart_concat(dart_string("    是否为空: "), dart_string("").isEmpty()));
dart_print(dart_concat(dart_string("    是否不为空: "), str1.isNotEmpty()));
dart_print(dart_string("  字符串方法:"));
dart_print(dart_concat(dart_string("    大写: "), str1.toUpperCase()));
dart_print(dart_concat(dart_string("    小写: "), str2.toLowerCase()));
dart_print(dart_concat(dart_string("    去空格: \""), str3.trim(), dart_string("\"")));
dart_print(dart_concat(dart_string("    子字符串: "), str1.substring(dart_int(0), dart_int(4))));
dart_print(dart_concat(dart_string("    包含: "), str1.contains(dart_string("ell"))));
dart_print(dart_concat(dart_string("    开始于: "), str1.startsWith(dart_string("He"))));
dart_print(dart_concat(dart_string("    结束于: "), str1.endsWith(dart_string("lo"))));
dart_print(dart_concat(dart_string("    索引: "), str1.indexOf(dart_string("l"))));
dart_print(dart_concat(dart_string("    替换: "), str1.replaceAll(dart_string("l"), dart_string("L"))));
dart_print(dart_concat(dart_string("    分割: "), concat.split(dart_string(" "))));
dart_print(dart_string("  字符串比较:"));
dart_print(dart_concat(dart_string("    相等: "), (str1 == dart_string("Hello"))));
dart_print(dart_concat(dart_string("    比较: "), str1.compareTo(str2)));
auto multiLine = dart_string("    第一行\n    第二行\n    第三行\n  ");
dart_print(dart_concat(dart_string("  多行字符串行数: "), multiLine.split(dart_string("\n"))->length()));
return Void;
}

Nullable testFunctions() {
  dart_print(dart_string("\n📌 测试函数"));
auto sum = add(dart_int(5), dart_int(3));
dart_print(dart_concat(dart_string("  加法函数: add(5, 3) = "), sum));
greet(dart_string("Alice"));
greet(dart_string("Bob"), dart_string("Mr."));
createUser();
createUser();
auto multiply = [&](Int a, Int b) { return (a * b); };
dart_print(dart_concat(dart_string("  匿名函数: multiply(4, 5) = "), multiply(dart_int(4), dart_int(5))));
auto square = [&](Int x) { return (x * x); };
dart_print(dart_concat(dart_string("  箭头函数: square(6) = "), square(dart_int(6))));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto doubled = numbers->map([&](Int n) { return (n * dart_int(2)); })->toList();
dart_print(dart_concat(dart_string("  高阶函数 map: "), doubled));
auto evens = numbers->where([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); })->toList();
dart_print(dart_concat(dart_string("  高阶函数 where: "), evens));
auto result = calculate(dart_int(10), dart_int(5), /* Constant: StaticTearOffConstant */);
dart_print(dart_concat(dart_string("  函数作为参数: calculate(10, 5, add) = "), result));
result = calculate(dart_int(10), dart_int(5), /* Constant: StaticTearOffConstant */);
dart_print(dart_concat(dart_string("  函数作为参数: calculate(10, 5, subtract) = "), result));
}

Int add(Int a, Int b) {
  return (a + b);
}

Int subtract(Int a, Int b) {
  return (a - b);
}

Nullable greet(String name, String title) {
  if (!(dart_is_null(title))) {
dart_print(dart_concat(dart_string("  问候: Hello, "), title, dart_string(" "), name, dart_string("!")));
} else {
dart_print(dart_concat(dart_string("  问候: Hello, "), name, dart_string("!")));
};
return Void;
}

Nullable createUser(String name, Int age, String email) {
  dart_print(dart_concat(dart_string("  创建用户: "), name, dart_string(", "), age, dart_string("岁"), !(dart_is_null(email)) ? dart_concat(dart_string(", 邮箱: "), email) : dart_string("")));
return Void;
}

Int calculate(Int a, Int b, std::function<Int()> operation) {
  return operation(a, b);
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 基础语法测试开始"));
testBasicTypes();
testVariableDeclarations();
testOperators();
testControlFlow();
testStringOperations();
testFunctions();
dart_print(dart_string("✅ 基础语法测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

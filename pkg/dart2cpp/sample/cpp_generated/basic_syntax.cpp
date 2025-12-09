#include "dart2cpp.h"

// 工具宏定义

Nullable testBasicTypes();
Nullable testVariableDeclarations();
Nullable testOperators();
Nullable testControlFlow();
Nullable testStringOperations();
Nullable testFunctions();
Int add(Int a, Int b);
Int subtract(Int a, Int b);
Nullable greet(String name, String title = String(Null));
Nullable createUser(String name = String(Null), Int age = Int(Null), String email = String(Null));
Int calculate(Int a, Int b, std::function<Int(Int, Int)> operation);
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
auto interpolation = dart_string("The answer is ") + (intValue).toString();
auto expression = dart_string("Sum: ") + ((intValue + doubleValue)).toString();
dart_print(dart_concat(dart_string("  整数: "), (intValue).toString(), dart_string(", 十六进制: "), (hexValue).toString(), dart_string(", 负数: "), (negativeInt).toString(), dart_string(", 零: "), (zero).toString()));
dart_print(dart_concat(dart_string("  浮点数: "), (doubleValue).toString(), dart_string(", 科学计数法: "), (scientificValue).toString(), dart_string(", 负数: "), (negativeDouble).toString()));
dart_print(dart_concat(dart_string("  布尔值: "), (trueValue).toString(), dart_string(", "), (falseValue).toString()));
dart_print(dart_concat(dart_string("  字符串: "), (singleQuote).toString(), dart_string(" "), (doubleQuote).toString()));
dart_print(dart_string("  插值: ") + (interpolation).toString());
dart_print(dart_string("  表达式: ") + (expression).toString());
dart_print(dart_string("  多行字符串长度: ") + (multiLine.size()).toString());
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
Int nullableInt(Null);
auto nullableString = Null;
Double nullableDouble(Null);
auto nonNull = dart_null_coalesce(nullableString, dart_string("default"));
if (dart_is_null(nullableInt)) nullableInt = dart_int(42);
dart_print(dart_concat(dart_string("  var: "), (autoInt).toString(), dart_string(", "), (autoString).toString(), dart_string(", "), (autoDouble).toString(), dart_string(", "), (autoBool).toString()));
dart_print(dart_concat(dart_string("  final: "), (finalValue).toString(), dart_string(", "), (typedFinal).toString()));
dart_print(dart_string("  const: compile time constant, 3.14159, 100"));
dart_print(dart_concat(dart_string("  nullable: "), (nullableInt).toString(), dart_string(", "), (nullableString).toString(), dart_string(", "), (nullableDouble).toString()));
dart_print(dart_string("  non-null: ") + (nonNull).toString());
return Void;
}

Nullable testOperators() {
  dart_print(dart_string("\n📌 测试运算符"));
auto a = dart_int(10);
auto b = dart_int(3);
auto x = dart_double(5.5);
auto y = dart_double(2.2);
dart_print(dart_string("  算术运算:"));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" + "), (b).toString(), dart_string(" = "), ((a + b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" - "), (b).toString(), dart_string(" = "), ((a - b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" * "), (b).toString(), dart_string(" = "), ((a * b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" / "), (b).toString(), dart_string(" = "), ((a / b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" % "), (b).toString(), dart_string(" = "), ((a % b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" ~/ "), (b).toString(), dart_string(" = "), (a.truncatingDivision(b)).toString()));
dart_print(dart_concat(dart_string("    -"), (a).toString(), dart_string(" = "), (a.operator_negate()).toString()));
dart_print(dart_string("  比较运算:"));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" == "), (b).toString(), dart_string(": "), ((a == b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" != "), (b).toString(), dart_string(": "), (!((a == b))).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" > "), (b).toString(), dart_string(": "), ((a > b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" < "), (b).toString(), dart_string(": "), ((a < b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" >= "), (b).toString(), dart_string(": "), ((a >= b)).toString()));
dart_print(dart_concat(dart_string("    "), (a).toString(), dart_string(" <= "), (b).toString(), dart_string(": "), ((a <= b)).toString()));
auto p = dart_bool(true);
auto q = dart_bool(false);
dart_print(dart_string("  逻辑运算:"));
dart_print(dart_concat(dart_string("    "), (p).toString(), dart_string(" && "), (q).toString(), dart_string(": "), (p && q).toString()));
dart_print(dart_concat(dart_string("    "), (p).toString(), dart_string(" || "), (q).toString(), dart_string(": "), (p || q).toString()));
dart_print(dart_concat(dart_string("    !"), (p).toString(), dart_string(": "), (!(p)).toString()));
dart_print(dart_concat(dart_string("    !"), (q).toString(), dart_string(": "), (!(q)).toString()));
auto m = dart_int(12);
auto n = dart_int(5);
dart_print(dart_string("  位运算:"));
dart_print(dart_concat(dart_string("    "), (m).toString(), dart_string(" & "), (n).toString(), dart_string(": "), (m.operator_bitwise_and(n)).toString()));
dart_print(dart_concat(dart_string("    "), (m).toString(), dart_string(" | "), (n).toString(), dart_string(": "), (m.operator_bitwise_or(n)).toString()));
dart_print(dart_concat(dart_string("    "), (m).toString(), dart_string(" ^ "), (n).toString(), dart_string(": "), (m.operator_bitwise_xor(n)).toString()));
dart_print(dart_concat(dart_string("    ~"), (m).toString(), dart_string(": "), (m.operator_bitwise_not()).toString()));
dart_print(dart_concat(dart_string("    "), (m).toString(), dart_string(" << 1: "), (m.operator_shift_left(dart_int(1))).toString()));
dart_print(dart_concat(dart_string("    "), (m).toString(), dart_string(" >> 1: "), (m.operator_shift_right(dart_int(1))).toString()));
auto c = dart_int(5);
c = (c + dart_int(2));
dart_print(dart_string("  赋值运算: c += 2 结果: ") + (c).toString());
c = (c - dart_int(1));
dart_print(dart_string("  赋值运算: c -= 1 结果: ") + (c).toString());
c = (c * dart_int(3));
dart_print(dart_string("  赋值运算: c *= 3 结果: ") + (c).toString());
c = c.truncatingDivision(dart_int(2));
dart_print(dart_string("  赋值运算: c ~/= 2 结果: ") + (c).toString());
auto result = (a > b) ? dart_string("a is greater") : dart_string("b is greater");
dart_print(dart_string("  三元运算符: ") + (result).toString());
String nullable(Null);
auto safe = dart_null_coalesce(nullable, dart_string("default value"));
dart_print(dart_string("  空值合并: ") + (safe).toString());
return Void;
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
dart_print(dart_concat(dart_string("    索引: "), (i).toString(), dart_string(", 值: "), ((i * i)).toString()));
}
auto fruits = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"));
dart_print(dart_string("  for-in 循环测试:"));
auto sync_for_iterator = fruits->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto fruit = sync_for_iterator->next();
dart_print(dart_string("    水果: ") + (fruit).toString());
}
dart_print(dart_string("  while 循环测试:"));
auto count = dart_int(0);
while ((count < dart_int(3))) {
dart_print(dart_string("    计数: ") + (count).toString());
count = (count + dart_int(1));
}
dart_print(dart_string("  do-while 循环测试:"));
auto num = dart_int(0);
do {
dart_print(dart_string("    数字: ") + (num).toString());
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
dart_print(dart_string("    处理: ") + (i).toString());
};
return Void;
}

Nullable testStringOperations() {
  dart_print(dart_string("\n📌 测试字符串操作"));
auto str1 = dart_string("Hello");
auto str2 = dart_string("World");
auto str3 = dart_string("  Dart Programming  ");
auto concat = ((str1 + dart_string(" ")) + str2);
dart_print(dart_string("  连接: ") + (concat).toString());
auto value = dart_int(42);
auto interpolated = dart_string("The answer is ") + (value).toString();
auto expression = dart_string("Sum: ") + ((dart_int(10) + dart_int(20))).toString();
dart_print(dart_string("  插值: ") + (interpolated).toString());
dart_print(dart_string("  表达式插值: ") + (expression).toString());
dart_print(dart_string("  字符串属性:"));
dart_print(dart_string("    长度: ") + (str1.size()).toString());
dart_print(dart_string("    是否为空: ") + (dart_string("").isEmpty()).toString());
dart_print(dart_string("    是否不为空: ") + (str1.isNotEmpty()).toString());
dart_print(dart_string("  字符串方法:"));
dart_print(dart_string("    大写: ") + (str1.toUpperCase()).toString());
dart_print(dart_string("    小写: ") + (str2.toLowerCase()).toString());
dart_print(dart_concat(dart_string("    去空格: \""), (str3.trim()).toString(), dart_string("\"")));
dart_print(dart_string("    子字符串: ") + (str1.substring(dart_int(0), dart_int(4))).toString());
dart_print(dart_string("    包含: ") + (str1.contains(dart_string("ell"))).toString());
dart_print(dart_string("    开始于: ") + (str1.startsWith(dart_string("He"))).toString());
dart_print(dart_string("    结束于: ") + (str1.endsWith(dart_string("lo"))).toString());
dart_print(dart_string("    索引: ") + (str1.indexOf(dart_string("l"))).toString());
dart_print(dart_string("    替换: ") + (str1.replaceAll(dart_string("l"), dart_string("L"))).toString());
dart_print(dart_string("    分割: ") + (concat.split(dart_string(" "))).toString());
dart_print(dart_string("  字符串比较:"));
dart_print(dart_string("    相等: ") + ((str1 == dart_string("Hello"))).toString());
dart_print(dart_string("    比较: ") + (str1.compareTo(str2)).toString());
auto multiLine = dart_string("    第一行\n    第二行\n    第三行\n  ");
dart_print(dart_string("  多行字符串行数: ") + (multiLine.split(dart_string("\n"))->size()).toString());
return Void;
}

Nullable testFunctions() {
  dart_print(dart_string("\n📌 测试函数"));
auto sum = add(dart_int(5), dart_int(3));
dart_print(dart_string("  加法函数: add(5, 3) = ") + (sum).toString());
greet(dart_string("Alice"), String(Null));
greet(dart_string("Bob"), dart_string("Mr."));
createUser(dart_string("Charlie"), dart_int(25), String(Null));
createUser(dart_string("David"), dart_int(30), dart_string("david@example.com"));
auto multiply = makeFunction([&](Int a, Int b) { return (a * b); });
dart_print(dart_string("  匿名函数: multiply(4, 5) = ") + (multiply->apply(std::vector<Any>{dart_int(4), dart_int(5)})).toString());
auto square = makeFunction([&](Int x) { return (x * x); });
dart_print(dart_string("  箭头函数: square(6) = ") + (square->apply(std::vector<Any>{dart_int(6)})).toString());
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto doubled = numbers->map(makeFunction([&](Int n) { return (n * dart_int(2)); }))->toList();
dart_print(dart_string("  高阶函数 map: ") + (doubled).toString());
auto evens = numbers->where(makeFunction([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); }))->toList();
dart_print(dart_string("  高阶函数 where: ") + (evens).toString());
auto result = calculate(dart_int(10), dart_int(5), makeFunction(&add));
dart_print(dart_string("  函数作为参数: calculate(10, 5, add) = ") + (result).toString());
result = calculate(dart_int(10), dart_int(5), makeFunction(&subtract));
dart_print(dart_string("  函数作为参数: calculate(10, 5, subtract) = ") + (result).toString());
}

Int add(Int a, Int b) {
  return (a + b);
}

Int subtract(Int a, Int b) {
  return (a - b);
}

Nullable greet(String name, String title) {
  if (!(dart_is_null(title))) {
dart_print(dart_concat(dart_string("  问候: Hello, "), (title).toString(), dart_string(" "), (name).toString(), dart_string("!")));
} else {
dart_print(dart_concat(dart_string("  问候: Hello, "), (name).toString(), dart_string("!")));
};
return Void;
}

Nullable createUser(String name, Int age, String email) {
  dart_print(dart_concat(dart_string("  创建用户: "), (name).toString(), dart_string(", "), (age).toString(), dart_string("岁"), (!(dart_is_null(email)) ? dart_string(", 邮箱: ") + (email).toString() : dart_string("")).toString()));
return Void;
}

Int calculate(Int a, Int b, std::function<Int(Int, Int)> operation) {
  return operation->apply(std::vector<Any>{a, b});
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

#include "dart_object.h"
#include "dart_string.h"
#include "dart_helpers.h"
#include <iomanip>
#include "dart_macros.h"

// ============================================================================
// 全局 Null 和 Void 实例定义
// ============================================================================

Nullable Void;
Nullable Null;

// ============================================================================
// Any 实现
// ============================================================================

String Any::toString() const {
  return dart_string("Any");
}

Any::Any(const String& s) : type_id(4) {
  value.string_index = s.value.string_index;
}

// ============================================================================
// Int 实现
// ============================================================================

Int::Int() {
  type_id = 1;
  value.int_value = 0;
}

Int::Int(int v) {
  type_id = 1;
  value.int_value = v;
}

Int::Int(const Int& other) {
  type_id = other.type_id;
  value.int_value = other.value.int_value;
}

Int::Int(const Any& any) { 
  if (any.type_id == 1) {
    type_id = 1; 
    value.int_value = any.value.int_value;
  } else {
    type_id = 1;
    value.int_value = any.toInt();
  }
}

Int::Int(const Nullable&) { 
  type_id = 0; 
  value.int_value = 0; 
}

Int& Int::operator=(const Int& other) {
  if (this != &other) {
    type_id = other.type_id;
    value.int_value = other.value.int_value;
  }
  return *this;
}

Int& Int::operator=(const Any& any) {
  if (any.type_id == 1) {
    type_id = 1;
    value.int_value = any.value.int_value;
  } else {
    type_id = 1;
    value.int_value = any.toInt();
  }
  return *this;
}

Int& Int::operator=(const Nullable&) { 
  type_id = 0; 
  value.int_value = 0; 
  return *this; 
}

Int Int::operator_add(const Int& other) const {
  return Int(value.int_value + other.value.int_value);
}

Double Int::operator_add(const Double& other) const {
  return Double(static_cast<double>(value.int_value) + other.getValue());
}

Int Int::operator_sub(const Int& other) const {
  return Int(value.int_value - other.value.int_value);
}

Double Int::operator_sub(const Double& other) const {
  return Double(static_cast<double>(value.int_value) - other.getValue());
}

Int Int::operator_mul(const Int& other) const {
  return Int(value.int_value * other.value.int_value);
}

Double Int::operator_mul(const Double& other) const {
  return Double(static_cast<double>(value.int_value) * other.getValue());
}

Int Int::operator_div(const Int& other) const {
  return Int(value.int_value / other.value.int_value);
}

Double Int::operator_div(const Double& other) const {
  return Double(static_cast<double>(value.int_value) / other.getValue());
}



Int Int::operator_mod(const Int& other) const {
  if (other.value.int_value == 0) throw std::runtime_error("Division by zero");
  return Int(value.int_value % other.value.int_value);
}

Int Int::operator+(const Int& other) const {
  return operator_add(other);
}

Int Int::operator-(const Int& other) const {
  return operator_sub(other);
}

Int Int::operator*(const Int& other) const {
  return operator_mul(other);
}

Int Int::operator/(const Int& other) const {
  return operator_div(other);
}

Int Int::operator%(const Int& other) const {
  return operator_mod(other);
}

Int Int::integerDivision(const Int& other) const {
  if (other.value.int_value == 0) throw std::runtime_error("Division by zero");
  return Int(value.int_value / other.value.int_value);
}

Int Int::truncatingDivision(const Int& other) const {
  return integerDivision(other);
}

Int Int::operator_bitwise_and(const Int& other) const {
  return Int(value.int_value & other.value.int_value);
}

Int Int::operator_bitwise_or(const Int& other) const {
  return Int(value.int_value | other.value.int_value);
}

Int Int::operator_bitwise_xor(const Int& other) const {
  return Int(value.int_value ^ other.value.int_value);
}

Int Int::operator_shift_left(const Int& other) const {
  return Int(value.int_value << other.value.int_value);
}

Int Int::operator_shift_right(const Int& other) const {
  return Int(value.int_value >> other.value.int_value);
}

Int Int::operator_bitwise_not() const {
  return Int(~value.int_value);
}

// 标准位运算符
Int Int::operator&(const Int& other) const {
  return operator_bitwise_and(other);
}

Int Int::operator|(const Int& other) const {
  return operator_bitwise_or(other);
}

Int Int::operator^(const Int& other) const {
  return operator_bitwise_xor(other);
}

Int Int::operator<<(const Int& other) const {
  return operator_shift_left(other);
}

Int Int::operator>>(const Int& other) const {
  return operator_shift_right(other);
}

Int Int::operator~() const {
  return operator_bitwise_not();
}

Bool Int::operator_equals(const Int& other) const {
  return Bool(value.int_value == other.value.int_value);
}

Bool Int::operator_not_equals(const Int& other) const {
  return Bool(value.int_value != other.value.int_value);
}

Bool Int::operator_less(const Int& other) const {
  return Bool(value.int_value < other.value.int_value);
}

Bool Int::operator_less_equals(const Int& other) const {
  return Bool(value.int_value <= other.value.int_value);
}

Bool Int::operator_greater(const Int& other) const {
  return Bool(value.int_value > other.value.int_value);
}

Bool Int::operator_greater_equals(const Int& other) const {
  return Bool(value.int_value >= other.value.int_value);
}

Bool Int::operator==(const Int& other) const {
  return operator_equals(other);
}

Bool Int::operator!=(const Int& other) const {
  return operator_not_equals(other);
}

Bool Int::operator<(const Int& other) const {
  return operator_less(other);
}

Bool Int::operator<=(const Int& other) const {
  return operator_less_equals(other);
}

Bool Int::operator>(const Int& other) const {
  return operator_greater(other);
}

Bool Int::operator>=(const Int& other) const {
  return operator_greater_equals(other);
}

Int Int::operator_unary_minus() const {
  return Int(-value.int_value);
}

Int Int::operator_unary_plus() const {
  return Int(value.int_value);
}

// 标准一元运算符
Int Int::operator-() const {
  return operator_unary_minus();
}

Int Int::operator+() const {
  return operator_unary_plus();
}

Int Int::abs() const {
  return Int(std::abs(value.int_value));
}

String Int::toString() const {
  std::stringstream ss;
  ss << value.int_value;
  return String(ss.str());
}

Double Int::toDouble() const {
  return Double(static_cast<double>(value.int_value));
}

Int Int::compareTo(const Int& other) const {
  if (value.int_value < other.value.int_value) return Int(-1);
  if (value.int_value > other.value.int_value) return Int(1);
  return Int(0);
}

Int Int::gcd(const Int& other) const {
  int a = std::abs(value.int_value);
  int b = std::abs(other.value.int_value);
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return Int(a);
}

Int Int::get_sign() const {
  if (value.int_value > 0) return Int(1);
  if (value.int_value < 0) return Int(-1);
  return Int(0);
}

Bool Int::get_isEven() const {
  return Bool((value.int_value % 2) == 0);
}

Bool Int::get_isOdd() const {
  return Bool((value.int_value % 2) != 0);
}

Bool Int::get_isNegative() const {
  return Bool(value.int_value < 0);
}

Bool Int::get_isFinite() const {
  return Bool(true);
}

Bool Int::get_isInfinite() const {
  return Bool(false);
}

Bool Int::get_isNaN() const {
  return Bool(false);
}

int Int::toInt() const {
  return value.int_value;
}

bool Int::toBool() const {
  return value.int_value != 0;
}

Int Int::operator_negate() const {
  return Int(-value.int_value);
}

// Int 和 Double 混合运算
Double Int::operator+(const Double& other) const {
  return Double(static_cast<double>(value.int_value) + other.value.double_value);
}

Double Int::operator-(const Double& other) const {
  return Double(static_cast<double>(value.int_value) - other.value.double_value);
}

Double Int::operator*(const Double& other) const {
  return Double(static_cast<double>(value.int_value) * other.value.double_value);
}

Double Int::operator/(const Double& other) const {
  return Double(static_cast<double>(value.int_value) / other.value.double_value);
}

// 复合赋值运算符函数
Int& Int::operator_add_assign(const Int& other) {
  value.int_value += other.value.int_value;
  return *this;
}

Int& Int::operator_sub_assign(const Int& other) {
  value.int_value -= other.value.int_value;
  return *this;
}

Int& Int::operator_mul_assign(const Int& other) {
  value.int_value *= other.value.int_value;
  return *this;
}

Int& Int::operator_div_assign(const Int& other) {
  if (other.value.int_value == 0) throw std::runtime_error("Division by zero");
  value.int_value /= other.value.int_value;
  return *this;
}

Int& Int::operator_mod_assign(const Int& other) {
  if (other.value.int_value == 0) throw std::runtime_error("Division by zero");
  value.int_value %= other.value.int_value;
  return *this;
}

// 标准复合赋值运算符
Int& Int::operator+=(const Int& other) {
  return operator_add_assign(other);
}

Int& Int::operator-=(const Int& other) {
  return operator_sub_assign(other);
}

Int& Int::operator*=(const Int& other) {
  return operator_mul_assign(other);
}

Int& Int::operator/=(const Int& other) {
  return operator_div_assign(other);
}

Int& Int::operator%=(const Int& other) {
  return operator_mod_assign(other);
}

// 自增自减运算符函数
Int& Int::operator_increment() {
  ++value.int_value;
  return *this;
}

Int Int::operator_post_increment() {
  Int temp(*this);
  ++value.int_value;
  return temp;
}

Int& Int::operator_decrement() {
  --value.int_value;
  return *this;
}

Int Int::operator_post_decrement() {
  Int temp(*this);
  --value.int_value;
  return temp;
}

// 标准自增自减运算符
Int& Int::operator++() {
  return operator_increment();
}

Int Int::operator++(int) {
  return operator_post_increment();
}

Int& Int::operator--() {
  return operator_decrement();
}

Int Int::operator--(int) {
  return operator_post_decrement();
}

// 修复#6: Int::parse 静态方法
Int Int::parse(const String& source) {
  try {
    return Int(std::stoi(source.getValue()));
  } catch (const std::exception&) {
    throw std::runtime_error("FormatException: Invalid integer");
  }
}

Int Int::parse(const String& source, const Int& radix) {
  try {
    return Int(std::stoi(source.getValue(), nullptr, radix.getValue()));
  } catch (const std::exception&) {
    throw std::runtime_error("FormatException: Invalid integer");
  }
}

Int Int::tryParse(const String& source) {
  try {
    return Int(std::stoi(source.getValue()));
  } catch (const std::exception&) {
    return Int(0);  // 简化实现，返回0表示解析失败
  }
}

// 修复#11: Int::toRadixString 方法
String Int::toRadixString(const Int& radix) const {
  int val = value.int_value;
  int base = radix.getValue();
  if (base < 2 || base > 36) {
    throw std::runtime_error("RangeError: radix must be in range 2-36");
  }
  if (val == 0) return String("0");
  
  bool negative = val < 0;
  if (negative) val = -val;
  
  std::string result;
  const char* digits = "0123456789abcdefghijklmnopqrstuvwxyz";
  while (val > 0) {
    result = digits[val % base] + result;
    val /= base;
  }
  if (negative) result = "-" + result;
  return String(result);
}

// ============================================================================
// Double 实现
// ============================================================================

Double::Double() { 
  type_id = 2; 
  value.double_value = 0.0; 
}

Double::Double(double v) { 
  type_id = 2; 
  value.double_value = v; 
}

Double::Double(const Double& other) { 
  type_id = other.type_id; 
  value = other.value; 
}

Double::Double(const Int& other) { 
  type_id = 2; 
  value.double_value = static_cast<double>(other.value.int_value); 
}

Double::Double(const Any& any) {
  if (any.type_id == 2) {
    type_id = 2;
    value.double_value = any.value.double_value;
  } else {
    type_id = 2;
    value.double_value = any.toDouble();
  }
}

Double::Double(const Nullable&) { 
  type_id = 0; 
  value.double_value = 0.0; 
}

Double& Double::operator=(const Double& other) {
  if (this != &other) {
    type_id = other.type_id;
    value.double_value = other.value.double_value;
  }
  return *this;
}

Double& Double::operator=(const Any& any) {
  if (any.type_id == 2) {
    type_id = 2;
    value.double_value = any.value.double_value;
  } else {
    type_id = 2;
    value.double_value = any.toDouble();
  }
  return *this;
}

Double& Double::operator=(const Nullable&) { 
  type_id = 0; 
  value.double_value = 0.0; 
  return *this; 
}

Double Double::operator_add(const Double& other) const {
  return Double(value.double_value + other.value.double_value);
}

Double Double::operator_add(const Int& other) const {
  return Double(value.double_value + static_cast<double>(other.getValue()));
}

Double Double::operator_sub(const Double& other) const {
  return Double(value.double_value - other.value.double_value);
}

Double Double::operator_sub(const Int& other) const {
  return Double(value.double_value - static_cast<double>(other.getValue()));
}

Double Double::operator_mul(const Double& other) const {
  return Double(value.double_value * other.value.double_value);
}

Double Double::operator_mul(const Int& other) const {
  return Double(value.double_value * static_cast<double>(other.getValue()));
}

Double Double::operator_div(const Double& other) const {
  return Double(value.double_value / other.value.double_value);
}

Double Double::operator_div(const Int& other) const {
  return Double(value.double_value / static_cast<double>(other.getValue()));
}

Double Double::operator_mod(const Double& other) const {
  return Double(std::fmod(value.double_value, other.value.double_value));
}

Double Double::operator+(const Double& other) const {
  return operator_add(other);
}

Double Double::operator-(const Double& other) const {
  return operator_sub(other);
}

Double Double::operator*(const Double& other) const {
  return operator_mul(other);
}

Double Double::operator/(const Double& other) const {
  return operator_div(other);
}

Double Double::operator%(const Double& other) const {
  return operator_mod(other);
}

// 复合赋值运算符函数
Double& Double::operator_add_assign(const Double& other) {
  value.double_value += other.value.double_value;
  return *this;
}

Double& Double::operator_sub_assign(const Double& other) {
  value.double_value -= other.value.double_value;
  return *this;
}

Double& Double::operator_mul_assign(const Double& other) {
  value.double_value *= other.value.double_value;
  return *this;
}

Double& Double::operator_div_assign(const Double& other) {
  value.double_value /= other.value.double_value;
  return *this;
}

Double& Double::operator_mod_assign(const Double& other) {
  value.double_value = std::fmod(value.double_value, other.value.double_value);
  return *this;
}

// 标准复合赋值运算符
Double& Double::operator+=(const Double& other) {
  return operator_add_assign(other);
}

Double& Double::operator-=(const Double& other) {
  return operator_sub_assign(other);
}

Double& Double::operator*=(const Double& other) {
  return operator_mul_assign(other);
}

Double& Double::operator/=(const Double& other) {
  return operator_div_assign(other);
}

Double& Double::operator%=(const Double& other) {
  return operator_mod_assign(other);
}

// 自增自减运算符函数
Double& Double::operator_increment() {
  ++value.double_value;
  return *this;
}

Double Double::operator_post_increment() {
  Double temp(*this);
  ++value.double_value;
  return temp;
}

Double& Double::operator_decrement() {
  --value.double_value;
  return *this;
}

Double Double::operator_post_decrement() {
  Double temp(*this);
  --value.double_value;
  return temp;
}

// 标准自增自减运算符
Double& Double::operator++() {
  return operator_increment();
}

Double Double::operator++(int) {
  return operator_post_increment();
}

Double& Double::operator--() {
  return operator_decrement();
}

Double Double::operator--(int) {
  return operator_post_decrement();
}

Bool Double::operator_equals(const Double& other) const {
  return Bool(value.double_value == other.value.double_value);
}

Bool Double::operator_not_equals(const Double& other) const {
  return Bool(value.double_value != other.value.double_value);
}

Bool Double::operator_less(const Double& other) const {
  return Bool(value.double_value < other.value.double_value);
}

Bool Double::operator_less_equals(const Double& other) const {
  return Bool(value.double_value <= other.value.double_value);
}

Bool Double::operator_greater(const Double& other) const {
  return Bool(value.double_value > other.value.double_value);
}

Bool Double::operator_greater_equals(const Double& other) const {
  return Bool(value.double_value >= other.value.double_value);
}

Bool Double::operator==(const Double& other) const {
  return operator_equals(other);
}

Bool Double::operator!=(const Double& other) const {
  return operator_not_equals(other);
}

Bool Double::operator<(const Double& other) const {
  return operator_less(other);
}

Bool Double::operator<=(const Double& other) const {
  return operator_less_equals(other);
}

Bool Double::operator>(const Double& other) const {
  return operator_greater(other);
}

Bool Double::operator>=(const Double& other) const {
  return operator_greater_equals(other);
}

Double Double::operator_unary_minus() const {
  return Double(-value.double_value);
}

Double Double::operator_unary_plus() const {
  return Double(value.double_value);
}

Double Double::operator_negate() const {
  return Double(-value.double_value);
}

// 标准一元运算符
Double Double::operator-() const {
  return operator_unary_minus();
}

Double Double::operator+() const {
  return operator_unary_plus();
}

Double Double::abs() const {
  return Double(std::abs(value.double_value));
}

String Double::toString() const {
  std::stringstream ss;
  ss << value.double_value;
  return String(ss.str());
}

String Double::toStringAsFixed(const Int& digits) const {
  std::stringstream ss;
  ss << std::fixed << std::setprecision(digits.getValue()) << value.double_value;
  return String(ss.str());
}

Int Double::toInt() const {
  return Int(static_cast<int>(value.double_value));
}

Double Double::floor() const {
  return Double(std::floor(value.double_value));
}

Double Double::ceil() const {
  return Double(std::ceil(value.double_value));
}

Double Double::round() const {
  return Double(std::round(value.double_value));
}

Double Double::truncate() const {
  return Double(std::trunc(value.double_value));
}

Int Double::compareTo(const Double& other) const {
  if (value.double_value < other.value.double_value) return Int(-1);
  if (value.double_value > other.value.double_value) return Int(1);
  return Int(0);
}

Int Double::get_sign() const {
  if (value.double_value > 0.0) return Int(1);
  if (value.double_value < 0.0) return Int(-1);
  return Int(0);
}

Bool Double::get_isNegative() const {
  return Bool(value.double_value < 0.0);
}

Bool Double::get_isFinite() const {
  return Bool(std::isfinite(value.double_value));
}

Bool Double::get_isInfinite() const {
  return Bool(std::isinf(value.double_value));
}

Bool Double::get_isNaN() const {
  return Bool(std::isnan(value.double_value));
}

double Double::toDouble() const {
  return value.double_value;
}

Bool Double::toBool() const {
  return Bool(value.double_value != 0.0);
}

// 修复#6: Double::parse 静态方法
Double Double::parse(const String& source) {
  try {
    return Double(std::stod(source.getValue()));
  } catch (const std::exception&) {
    throw std::runtime_error("FormatException: Invalid double");
  }
}

Double Double::tryParse(const String& source) {
  try {
    return Double(std::stod(source.getValue()));
  } catch (const std::exception&) {
    return Double::nan;  // 解析失败返回NaN
  }
}

// 修复#7: Double 静态常量定义
const Double Double::nan = Double(std::nan(""));
const Double Double::infinity = Double(std::numeric_limits<double>::infinity());
const Double Double::negativeInfinity = Double(-std::numeric_limits<double>::infinity());
const Double Double::minPositive = Double(std::numeric_limits<double>::min());
const Double Double::maxFinite = Double(std::numeric_limits<double>::max());

// ============================================================================
// Bool 实现
// ============================================================================

Bool::Bool() {
  type_id = 3;
  value.bool_value = false;
}

Bool::Bool(bool v) {
  type_id = 3;
  value.bool_value = v;
}

Bool::Bool(const Bool& other) {
  type_id = other.type_id;
  value.bool_value = other.value.bool_value;
}

Bool::Bool(const Any& any) {
  if (any.type_id == 3) {
    type_id = 3;
    value.bool_value = any.value.bool_value;
  } else {
    type_id = 3;
    value.bool_value = any.toBool();
  }
}

Bool::Bool(const Nullable&) { 
  type_id = 0; 
  value.bool_value = false; 
}

Bool& Bool::operator=(const Bool& other) {
  if (this != &other) {
    type_id = other.type_id;
    value.bool_value = other.value.bool_value;
  }
  return *this;
}

Bool& Bool::operator=(const Any& any) {
  if (any.type_id == 3) {
    type_id = 3;
    value.bool_value = any.value.bool_value;
  } else {
    type_id = 3;
    value.bool_value = any.toBool();
  }
  return *this;
}

Bool& Bool::operator=(const Nullable&) { 
  type_id = 0; 
  value.bool_value = false; 
  return *this; 
}

Bool Bool::operator_and(const Bool& other) const {
  return Bool(value.bool_value && other.value.bool_value);
}

Bool Bool::operator_or(const Bool& other) const {
  return Bool(value.bool_value || other.value.bool_value);
}

Bool Bool::operator_not() const {
  return Bool(!value.bool_value);
}

Bool Bool::operator&&(const Bool& other) const {
  return operator_and(other);
}

Bool Bool::operator||(const Bool& other) const {
  return operator_or(other);
}

Bool Bool::operator!() const {
  return operator_not();
}

Bool Bool::operator_equals(const Bool& other) const {
  return Bool(value.bool_value == other.value.bool_value);
}

Bool Bool::operator_not_equals(const Bool& other) const {
  return Bool(value.bool_value != other.value.bool_value);
}

Bool Bool::operator==(const Bool& other) const {
  return operator_equals(other);
}

Bool Bool::operator!=(const Bool& other) const {
  return operator_not_equals(other);
}

String Bool::toString() const {
  return String(value.bool_value ? "true" : "false");
}

Int Bool::compareTo(const Bool& other) const {
  if (value.bool_value == other.value.bool_value) return Int(0);
  return value.bool_value ? Int(1) : Int(-1);
}

Bool::operator bool() const {
  return value.bool_value;
}

bool Bool::toBool() const {
  return value.bool_value;
}

Int Bool::toInt() const {
  return Int(value.bool_value ? 1 : 0);
}

// ============================================================================
// Object 实现
// ============================================================================

Object::Object() : ref_count(1) {}

Object::Object(const Object& other)
    : Any(other), ref_count(1) {}

Object& Object::operator=(const Object& other) {
  if (this != &other) {
    Any::operator=(other);
    ref_count = 1;
  }
  return *this;
}

void Object::increment() { 
  ref_count++; 
}

void Object::decrement() {
  ref_count--;
  if (ref_count <= 0) {
    delete this;
  }
}

int Object::getRefCount() const { 
  return ref_count; 
}

// 修复#9: Object::hash 静态方法
Int Object::hash(const Any& object) {
  // 根据类型计算哈希值
  switch (object.type_id) {
    case 1: return Int(std::hash<int>{}(object.value.int_value));
    case 2: return Int(static_cast<int>(std::hash<double>{}(object.value.double_value)));
    case 3: return Int(std::hash<bool>{}(object.value.bool_value));
    case 4: return Int(std::hash<int>{}(object.value.string_index));
    default: return Int(reinterpret_cast<std::intptr_t>(object.value.object_ptr));
  }
}

Int Object::hashAll(const std::vector<Any>& objects) {
  std::size_t result = 0;
  for (const auto& obj : objects) {
    result ^= std::hash<int>{}(hash(obj).getValue()) + 0x9e3779b9 + (result << 6) + (result >> 2);
  }
  return Int(static_cast<int>(result));
}

// ============================================================================
// Exception 实现 (修复#5)
// ============================================================================

Exception::Exception() : message_(String("")) {}

Exception::Exception(const String& message) : message_(message) {}

String Exception::getMessage() const {
  return message_;
}

String Exception::toString() const {
  return String("Exception: ") + message_;
}

ObjectPtr<Exception> Exception::create(const String& message) {
  return ObjectPtr<Exception>(new Exception(message));
}

// FormatException 实现
FormatException::FormatException() : Exception() {}
FormatException::FormatException(const String& message) : Exception(message) {}
String FormatException::toString() const {
  return String("FormatException: ") + message_;
}
ObjectPtr<FormatException> FormatException::create(const String& message) {
  return ObjectPtr<FormatException>(new FormatException(message));
}

// StateError 实现
StateError::StateError() : Exception() {}
StateError::StateError(const String& message) : Exception(message) {}
String StateError::toString() const {
  return String("StateError: ") + message_;
}
ObjectPtr<StateError> StateError::create(const String& message) {
  return ObjectPtr<StateError>(new StateError(message));
}

// ArgumentError 实现
ArgumentError::ArgumentError() : Exception() {}
ArgumentError::ArgumentError(const String& message) : Exception(message) {}
String ArgumentError::toString() const {
  return String("ArgumentError: ") + message_;
}
ObjectPtr<ArgumentError> ArgumentError::create(const String& message) {
  return ObjectPtr<ArgumentError>(new ArgumentError(message));
}

// RangeError 实现
RangeError::RangeError() : Exception() {}
RangeError::RangeError(const String& message) : Exception(message) {}
String RangeError::toString() const {
  return String("RangeError: ") + message_;
}
ObjectPtr<RangeError> RangeError::create(const String& message) {
  return ObjectPtr<RangeError>(new RangeError(message));
}

// ============================================================================
// CppUserData 实现
// ============================================================================

CppUserData::CppUserData() {
  type_id = 6;
  data = nullptr;
  ref_count = new int(1);
}

CppUserData::CppUserData(void* external_data) {
  type_id = 6;
  data = external_data;
  ref_count = new int(1);
}

CppUserData::CppUserData(int length) {
  type_id = 6;
  data = std::malloc(length);
  ref_count = new int(1);
}

CppUserData::CppUserData(const CppUserData& other) {
  type_id = other.type_id;
  data = other.data;
  ref_count = other.ref_count;
  (*ref_count)++;
}

CppUserData::~CppUserData() {
  (*ref_count)--;
  if (*ref_count <= 0) {
    if (data) {
      std::free(data);
    }
    delete ref_count;
  }
}

void* CppUserData::getData() const {
  return data;
}

int CppUserData::getRefCount() const {
  return *ref_count;
}

String CppUserData::toString() const {
  std::stringstream ss;
  ss << "CppUserData@" << data;
  return String(ss.str());
}

// ============================================================================
// Function 实现
// ============================================================================


Function::Function() {
  type_id = 4; // Function类型ID
}

Function::~Function() {}

Bool Function::isNull() const {
  // 对于抽象基类，始终返回false
  return Bool(false);
}

String Function::toString() const {
  return dart_string("Function");
}


// ============================================================================
// 类型转换函数特化实现
// ============================================================================

template<>
Int convertFromAny<Int>(const Any& any) {
  if (any.type_id == 1) {
    Int result;
    result.type_id = 1;
    result.value.int_value = any.value.int_value;
    return result;
  }
  return Int(any.toInt());
}

template<>
Any convertToAny<Int>(const Int& value) {
  Any result;
  result.type_id = 1;
  result.value.int_value = value.value.int_value;
  return result;
}

template<>
Double convertFromAny<Double>(const Any& any) {
  if (any.type_id == 2) {
    Double result;
    result.type_id = 2;
    result.value.double_value = any.value.double_value;
    return result;
  }
  return Double(any.toDouble());
}

template<>
Any convertToAny<Double>(const Double& value) {
  Any result;
  result.type_id = 2;
  result.value.double_value = value.value.double_value;
  return result;
}

template<>
Bool convertFromAny<Bool>(const Any& any) {
  if (any.type_id == 3) {
    Bool result;
    result.type_id = 3;
    result.value.bool_value = any.value.bool_value;
    return result;
  }
  return Bool(any.toBool());
}

template<>
Any convertToAny<Bool>(const Bool& value) {
  Any result;
  result.type_id = 3;
  result.value.bool_value = value.value.bool_value;
  return result;
}

// ============================================================================
// StringBuffer 实现
// ============================================================================

StringBuffer::StringBuffer() : buffer_("") {}

StringBuffer::StringBuffer(const String& initial) : buffer_(initial.getValue()) {}

void StringBuffer::write(const String& str) {
  buffer_ += str.getValue();
}

void StringBuffer::writeln(const String& str) {
  buffer_ += str.getValue() + "\n";
}

void StringBuffer::writeAll(const std::vector<String>& objects, const String& separator) {
  for (size_t i = 0; i < objects.size(); ++i) {
    if (i > 0) {
      buffer_ += separator.getValue();
    }
    buffer_ += objects[i].getValue();
  }
}

void StringBuffer::clear() {
  buffer_.clear();
}

Int StringBuffer::length() const {
  return Int(static_cast<int>(buffer_.length()));
}

Bool StringBuffer::isEmpty() const {
  return Bool(buffer_.empty());
}

Bool StringBuffer::isNotEmpty() const {
  return Bool(!buffer_.empty());
}

String StringBuffer::toString() const {
  return String(buffer_);
}

ObjectPtr<StringBuffer> StringBuffer::create() {
  return ObjectPtr<StringBuffer>(new StringBuffer());
}

ObjectPtr<StringBuffer> StringBuffer::create(const String& initial) {
  return ObjectPtr<StringBuffer>(new StringBuffer(initial));
}

// ============================================================================
// RegExp 类已被移除 - 功能已合并到 String 类型
// 请参见 dart_string.cpp 中的 String::hasMatch 等方法
// ============================================================================

// ============================================================================
// Timer 实现
// ============================================================================

Timer::Timer() : isActive_(false) {}

void Timer::cancel() {
  isActive_ = false;
}

Bool Timer::isActive() const {
  return Bool(isActive_);
}

String Timer::toString() const {
  return String("Timer");
}

ObjectPtr<Timer> Timer::create() {
  return ObjectPtr<Timer>(new Timer());
}

// ============================================================================
// List 方法实现
// ============================================================================

template<typename T>
void List<T>::addAll(const ObjectPtr<List<T>>& items) {
  if (items) {
    for (Int i = Int(0); i < items->size(); ++i) {
      add(items->get(i));
    }
  }
}

template<typename T>
void List<T>::insertAll(const Int& index, const ObjectPtr<List<T>>& items) {
  if (items) {
    Int insertIndex = index;
    for (Int i = Int(0); i < items->size(); ++i) {
      insert(insertIndex, items->get(i));
      insertIndex = insertIndex + Int(1);
    }
  }
}

template<typename T>
T List<T>::removeLast() {
  if (isEmpty().getValue()) {
    throw std::runtime_error("Cannot remove from empty list");
  }
  Int lastIndex = size() - Int(1);
  return removeAt(lastIndex);
}

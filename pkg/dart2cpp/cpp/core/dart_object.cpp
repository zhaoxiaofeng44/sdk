#include "dart_object.h"
#include "dart_string.h"
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

Int Int::operator_plus(const Int& other) const {
  return Int(value.int_value + other.value.int_value);
}

Int Int::operator_minus(const Int& other) const {
  return Int(value.int_value - other.value.int_value);
}

Int Int::operator_multiply(const Int& other) const {
  return Int(value.int_value * other.value.int_value);
}

Int Int::operator_divide(const Int& other) const {
  if (other.value.int_value == 0) throw std::runtime_error("Division by zero");
  return Int(value.int_value / other.value.int_value);
}

Int Int::operator_modulo(const Int& other) const {
  if (other.value.int_value == 0) throw std::runtime_error("Division by zero");
  return Int(value.int_value % other.value.int_value);
}

Int Int::operator+(const Int& other) const {
  return operator_plus(other);
}

Int Int::operator-(const Int& other) const {
  return operator_minus(other);
}

Int Int::operator*(const Int& other) const {
  return operator_multiply(other);
}

Int Int::operator/(const Int& other) const {
  return operator_divide(other);
}

Int Int::operator%(const Int& other) const {
  return operator_modulo(other);
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

Bool Int::operator==(const Int& other) const {
  return Bool(value.int_value == other.value.int_value);
}

Bool Int::operator!=(const Int& other) const {
  return Bool(value.int_value != other.value.int_value);
}

Bool Int::operator<(const Int& other) const {
  return Bool(value.int_value < other.value.int_value);
}

Bool Int::operator<=(const Int& other) const {
  return Bool(value.int_value <= other.value.int_value);
}

Bool Int::operator>(const Int& other) const {
  return Bool(value.int_value > other.value.int_value);
}

Bool Int::operator>=(const Int& other) const {
  return Bool(value.int_value >= other.value.int_value);
}

Int Int::operator_unary_minus() const {
  return Int(-value.int_value);
}

Int Int::operator_unary_plus() const {
  return Int(value.int_value);
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

// 复合赋值运算符
Int& Int::operator+=(const Int& other) {
  value.int_value += other.value.int_value;
  return *this;
}

Int& Int::operator-=(const Int& other) {
  value.int_value -= other.value.int_value;
  return *this;
}

Int& Int::operator*=(const Int& other) {
  value.int_value *= other.value.int_value;
  return *this;
}

Int& Int::operator/=(const Int& other) {
  if (other.value.int_value == 0) throw std::runtime_error("Division by zero");
  value.int_value /= other.value.int_value;
  return *this;
}

Int& Int::operator%=(const Int& other) {
  if (other.value.int_value == 0) throw std::runtime_error("Division by zero");
  value.int_value %= other.value.int_value;
  return *this;
}

// 自增自减运算符
Int& Int::operator++() {
  ++value.int_value;
  return *this;
}

Int Int::operator++(int) {
  Int temp(*this);
  ++value.int_value;
  return temp;
}

Int& Int::operator--() {
  --value.int_value;
  return *this;
}

Int Int::operator--(int) {
  Int temp(*this);
  --value.int_value;
  return temp;
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

Double Double::operator_plus(const Double& other) const {
  return Double(value.double_value + other.value.double_value);
}

Double Double::operator_minus(const Double& other) const {
  return Double(value.double_value - other.value.double_value);
}

Double Double::operator_multiply(const Double& other) const {
  return Double(value.double_value * other.value.double_value);
}

Double Double::operator_divide(const Double& other) const {
  return Double(value.double_value / other.value.double_value);
}

Double Double::operator_modulo(const Double& other) const {
  return Double(std::fmod(value.double_value, other.value.double_value));
}

Double Double::operator+(const Double& other) const {
  return operator_plus(other);
}

Double Double::operator-(const Double& other) const {
  return operator_minus(other);
}

Double Double::operator*(const Double& other) const {
  return operator_multiply(other);
}

Double Double::operator/(const Double& other) const {
  return operator_divide(other);
}

Double Double::operator%(const Double& other) const {
  return operator_modulo(other);
}

// 复合赋值运算符
Double& Double::operator+=(const Double& other) {
  value.double_value += other.value.double_value;
  return *this;
}

Double& Double::operator-=(const Double& other) {
  value.double_value -= other.value.double_value;
  return *this;
}

Double& Double::operator*=(const Double& other) {
  value.double_value *= other.value.double_value;
  return *this;
}

Double& Double::operator/=(const Double& other) {
  value.double_value /= other.value.double_value;
  return *this;
}

Double& Double::operator%=(const Double& other) {
  value.double_value = std::fmod(value.double_value, other.value.double_value);
  return *this;
}

// 自增自减运算符
Double& Double::operator++() {
  ++value.double_value;
  return *this;
}

Double Double::operator++(int) {
  Double temp(*this);
  ++value.double_value;
  return temp;
}

Double& Double::operator--() {
  --value.double_value;
  return *this;
}

Double Double::operator--(int) {
  Double temp(*this);
  --value.double_value;
  return temp;
}

Bool Double::operator==(const Double& other) const {
  return Bool(value.double_value == other.value.double_value);
}

Bool Double::operator!=(const Double& other) const {
  return Bool(value.double_value != other.value.double_value);
}

Bool Double::operator<(const Double& other) const {
  return Bool(value.double_value < other.value.double_value);
}

Bool Double::operator<=(const Double& other) const {
  return Bool(value.double_value <= other.value.double_value);
}

Bool Double::operator>(const Double& other) const {
  return Bool(value.double_value > other.value.double_value);
}

Bool Double::operator>=(const Double& other) const {
  return Bool(value.double_value >= other.value.double_value);
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

Bool Bool::operator&&(const Bool& other) const {
  return Bool(value.bool_value && other.value.bool_value);
}

Bool Bool::operator||(const Bool& other) const {
  return Bool(value.bool_value || other.value.bool_value);
}

Bool Bool::operator!() const {
  return Bool(!value.bool_value);
}

Bool Bool::operator==(const Bool& other) const {
  return Bool(value.bool_value == other.value.bool_value);
}

Bool Bool::operator!=(const Bool& other) const {
  return Bool(value.bool_value != other.value.bool_value);
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

Function::Function() : return_type_(0), param_count_(0) { 
  type_id = 15; 
}

Function::~Function() {}

Bool Function::isNull() const {
  // 对于抽象基类，始终返回false
  return Bool(false);
}

String Function::toString() const {
  return dart_string("Function");
}

Int Function::getParameterCount() const {
  return Int(static_cast<int>(param_count_));
}

std::vector<int> Function::getParameterTypes() const {
  return param_types_;
}

Int Function::getReturnType() const {
  return Int(return_type_);
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

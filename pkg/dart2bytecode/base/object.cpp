#include "object.h"

// ============================================================================
// 全局字符串池实现
// ============================================================================

StringPool* StringPool::instance_ = nullptr;

StringPool* StringPool::getInstance() {
  if (instance_ == nullptr) {
    instance_ = new StringPool();
    // 添加空字符串作为索引0
    instance_->pool_.push_back("");
    instance_->index_map_[""] = 0;
  }
  return instance_;
}

int StringPool::intern(const std::string& str) {
  auto it = index_map_.find(str);
  if (it != index_map_.end()) {
    return it->second;  // 已存在，返回索引
  }
  
  // 不存在，添加到池中
  int index = static_cast<int>(pool_.size());
  pool_.push_back(str);
  index_map_[str] = index;
  return index;
}

const std::string& StringPool::getString(int index) const {
  if (index >= 0 && index < static_cast<int>(pool_.size())) {
    return pool_[index];
  }
  throw std::out_of_range("String pool index out of range");
}

int StringPool::getSize() const {
  return static_cast<int>(pool_.size());
}

void StringPool::clear() {
  pool_.clear();
  index_map_.clear();
  // 重新添加空字符串
  pool_.push_back("");
  index_map_[""] = 0;
}

// ============================================================================
// Void 实现
// ============================================================================

Void::Void() {
  type_id = 0;
}

// ============================================================================
// Int 实现
// ============================================================================

Int::Int() : value(0) {
  type_id = 1;
}

Int::Int(int v) : value(v) {
  type_id = 1;
}

Int::Int(const Int& other) : value(other.value) {
  type_id = 1;
}

Int Int::operator+(const Int& other) const {
  return Int(value + other.value);
}

Int Int::operator-(const Int& other) const {
  return Int(value - other.value);
}

Int Int::operator*(const Int& other) const {
  return Int(value * other.value);
}

Int Int::operator/(const Int& other) const {
  if (other.value == 0) throw std::runtime_error("Division by zero");
  return Int(value / other.value);
}

Int Int::operator%(const Int& other) const {
  if (other.value == 0) throw std::runtime_error("Division by zero");
  return Int(value % other.value);
}

Int Int::integerDivision(const Int& other) const {
  if (other.value == 0) throw std::runtime_error("Division by zero");
  return Int(value / other.value);
}

Int Int::operator&(const Int& other) const {
  return Int(value & other.value);
}

Int Int::operator|(const Int& other) const {
  return Int(value | other.value);
}

Int Int::operator^(const Int& other) const {
  return Int(value ^ other.value);
}

Int Int::operator<<(const Int& other) const {
  return Int(value << other.value);
}

Int Int::operator>>(const Int& other) const {
  return Int(value >> other.value);
}

Int Int::operator~() const {
  return Int(~value);
}

bool Int::operator==(const Int& other) const {
  return value == other.value;
}

bool Int::operator!=(const Int& other) const {
  return value != other.value;
}

bool Int::operator<(const Int& other) const {
  return value < other.value;
}

bool Int::operator<=(const Int& other) const {
  return value <= other.value;
}

bool Int::operator>(const Int& other) const {
  return value > other.value;
}

bool Int::operator>=(const Int& other) const {
  return value >= other.value;
}

Int& Int::operator=(const Int& other) {
  if (this != &other) value = other.value;
  return *this;
}

Int Int::operator-() const {
  return Int(-value);
}

Int Int::operator+() const {
  return Int(value);
}

Int Int::abs() const {
  return Int(std::abs(value));
}

std::string Int::toString() const {
  std::stringstream ss;
  ss << value;
  return ss.str();
}

double Int::toDouble() const {
  return static_cast<double>(value);
}

int Int::compareTo(const Int& other) const {
  if (value < other.value) return -1;
  if (value > other.value) return 1;
  return 0;
}

Int Int::gcd(const Int& other) const {
  int a = std::abs(value);
  int b = std::abs(other.value);
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return Int(a);
}

int Int::get_sign() const {
  if (value > 0) return 1;
  if (value < 0) return -1;
  return 0;
}

bool Int::get_isEven() const {
  return (value % 2) == 0;
}

bool Int::get_isOdd() const {
  return (value % 2) != 0;
}

bool Int::get_isNegative() const {
  return value < 0;
}

bool Int::get_isFinite() const {
  return true;
}

bool Int::get_isInfinite() const {
  return false;
}

bool Int::get_isNaN() const {
  return false;
}

Int::operator int() const {
  return value;
}

Int::operator double() const {
  return static_cast<double>(value);
}

Int::operator bool() const {
  return value != 0;
}

// ============================================================================
// Double 实现
// ============================================================================

Double::Double() : value(0.0) {
  type_id = 2;
}

Double::Double(double v) : value(v) {
  type_id = 2;
}

Double::Double(const Double& other) : value(other.value) {
  type_id = 2;
}

Double::Double(const Int& other) : value(other.toDouble()) {
  type_id = 2;
}

Double Double::operator+(const Double& other) const {
  return Double(value + other.value);
}

Double Double::operator-(const Double& other) const {
  return Double(value - other.value);
}

Double Double::operator*(const Double& other) const {
  return Double(value * other.value);
}

Double Double::operator/(const Double& other) const {
  if (other.value == 0.0) return Double(value > 0 ? INFINITY : -INFINITY);
  return Double(value / other.value);
}

Double Double::operator%(const Double& other) const {
  if (other.value == 0.0) return Double(NAN);
  return Double(std::fmod(value, other.value));
}

bool Double::operator==(const Double& other) const {
  return value == other.value;
}

bool Double::operator!=(const Double& other) const {
  return value != other.value;
}

bool Double::operator<(const Double& other) const {
  return value < other.value;
}

bool Double::operator<=(const Double& other) const {
  return value <= other.value;
}

bool Double::operator>(const Double& other) const {
  return value > other.value;
}

bool Double::operator>=(const Double& other) const {
  return value >= other.value;
}

Double& Double::operator=(const Double& other) {
  if (this != &other) value = other.value;
  return *this;
}

Double Double::operator-() const {
  return Double(-value);
}

Double Double::operator+() const {
  return Double(value);
}

Double Double::abs() const {
  return Double(std::abs(value));
}

std::string Double::toString() const {
  if (get_isNaN()) return "NaN";
  if (get_isInfinite()) return value > 0 ? "Infinity" : "-Infinity";
  std::stringstream ss;
  ss << value;
  return ss.str();
}

int Double::toInt() const {
  if (get_isNaN() || get_isInfinite()) return 0;
  return static_cast<int>(value);
}

Double Double::floor() const {
  return Double(std::floor(value));
}

Double Double::ceil() const {
  return Double(std::ceil(value));
}

Double Double::round() const {
  return Double(std::round(value));
}

Double Double::truncate() const {
  return Double(std::trunc(value));
}

int Double::compareTo(const Double& other) const {
  if (get_isNaN() && other.get_isNaN()) return 0;
  if (get_isNaN()) return 1;
  if (other.get_isNaN()) return -1;
  if (value < other.value) return -1;
  if (value > other.value) return 1;
  return 0;
}

int Double::get_sign() const {
  if (get_isNaN()) return 0;
  if (value > 0.0 || (value == 0.0 && 1.0 / value > 0.0)) return 1;
  if (value < 0.0 || (value == 0.0 && 1.0 / value < 0.0)) return -1;
  return 0;
}

bool Double::get_isNegative() const {
  return value < 0.0 || (value == 0.0 && 1.0 / value < 0.0);
}

bool Double::get_isFinite() const {
  return std::isfinite(value);
}

bool Double::get_isInfinite() const {
  return std::isinf(value);
}

bool Double::get_isNaN() const {
  return std::isnan(value);
}

Double::operator double() const {
  return value;
}

Double::operator int() const {
  return toInt();
}

Double::operator bool() const {
  return !get_isNaN() && value != 0.0;
}

// ============================================================================
// Bool 实现
// ============================================================================

Bool::Bool() : value(false) {
  type_id = 3;
}

Bool::Bool(bool v) : value(v) {
  type_id = 3;
}

Bool::Bool(const Bool& other) : value(other.value) {
  type_id = 3;
}

Bool Bool::operator&&(const Bool& other) const {
  return Bool(value && other.value);
}

Bool Bool::operator||(const Bool& other) const {
  return Bool(value || other.value);
}

Bool Bool::operator!() const {
  return Bool(!value);
}

bool Bool::operator==(const Bool& other) const {
  return value == other.value;
}

bool Bool::operator!=(const Bool& other) const {
  return value != other.value;
}

Bool& Bool::operator=(const Bool& other) {
  if (this != &other) value = other.value;
  return *this;
}

std::string Bool::toString() const {
  return value ? "true" : "false";
}

int Bool::compareTo(const Bool& other) const {
  if (value == other.value) return 0;
  return value ? 1 : -1;
}

Bool::operator bool() const {
  return value;
}

Bool::operator int() const {
  return value ? 1 : 0;
}

// ============================================================================
// String 实现（使用字符串池）
// ============================================================================

String::String() {
  type_id = 4;
  string_index_ = 0;  // 空字符串索引
}

String::String(const std::string& v) {
  type_id = 4;
  string_index_ = StringPool::getInstance()->intern(v);
}

String::String(const char* v) {
  type_id = 4;
  string_index_ = StringPool::getInstance()->intern(std::string(v));
}

String::String(const String& other) {
  type_id = 4;
  string_index_ = other.string_index_;
}

String::String(int index) {
  type_id = 4;
  string_index_ = index;
}

const std::string& String::getValue() const {
  return StringPool::getInstance()->getString(string_index_);
}

int String::getIndex() const {
  return string_index_;
}

String String::operator+(const String& other) const {
  return String(getValue() + other.getValue());
}

bool String::operator==(const String& other) const {
  return string_index_ == other.string_index_;
}

bool String::operator!=(const String& other) const {
  return string_index_ != other.string_index_;
}

bool String::operator<(const String& other) const {
  return getValue() < other.getValue();
}

bool String::operator<=(const String& other) const {
  return getValue() <= other.getValue();
}

bool String::operator>(const String& other) const {
  return getValue() > other.getValue();
}

bool String::operator>=(const String& other) const {
  return getValue() >= other.getValue();
}

char String::operator[](int index) const {
  const std::string& str = getValue();
  if (index >= 0 && index < static_cast<int>(str.length())) {
    return str[index];
  }
  throw std::out_of_range("String index out of range");
}

String& String::operator=(const String& other) {
  if (this != &other) {
    string_index_ = other.string_index_;
  }
  return *this;
}

std::string String::toString() const {
  return getValue();
}

int String::get_length() const {
  return static_cast<int>(getValue().length());
}

bool String::get_isEmpty() const {
  return getValue().empty();
}

bool String::get_isNotEmpty() const {
  return !getValue().empty();
}

int String::compareTo(const String& other) const {
  const std::string& v1 = getValue();
  const std::string& v2 = other.getValue();
  if (v1 < v2) return -1;
  if (v1 > v2) return 1;
  return 0;
}

String String::substring(int start, int end) const {
  const std::string& str = getValue();
  if (end == -1) end = get_length();
  if (start < 0 || start > get_length() || end < start || end > get_length()) {
    throw std::out_of_range("Substring range out of bounds");
  }
  return String(str.substr(start, end - start));
}

int String::indexOf(const String& pattern, int start) const {
  const std::string& str = getValue();
  if (start < 0 || start >= get_length()) return -1;
  size_t pos = str.find(pattern.getValue(), start);
  return pos == std::string::npos ? -1 : static_cast<int>(pos);
}

int String::lastIndexOf(const String& pattern, int start) const {
  const std::string& str = getValue();
  if (start == -1) start = get_length() - 1;
  if (start < 0 || start >= get_length()) return -1;
  size_t pos = str.rfind(pattern.getValue(), start);
  return pos == std::string::npos ? -1 : static_cast<int>(pos);
}

bool String::startsWith(const String& pattern) const {
  const std::string& str = getValue();
  const std::string& pat = pattern.getValue();
  if (pat.length() > str.length()) return false;
  return str.substr(0, pat.length()) == pat;
}

bool String::endsWith(const String& pattern) const {
  const std::string& str = getValue();
  const std::string& pat = pattern.getValue();
  if (pat.length() > str.length()) return false;
  return str.substr(str.length() - pat.length()) == pat;
}

bool String::contains(const String& pattern) const {
  return indexOf(pattern) != -1;
}

String String::toLowerCase() const {
  std::string result = getValue();
  std::transform(result.begin(), result.end(), result.begin(), ::tolower);
  return String(result);
}

String String::toUpperCase() const {
  std::string result = getValue();
  std::transform(result.begin(), result.end(), result.begin(), ::toupper);
  return String(result);
}

String String::trim() const {
  std::string result = getValue();
  size_t start = result.find_first_not_of(" \t\n\r\f\v");
  if (start == std::string::npos) return String("");
  size_t end = result.find_last_not_of(" \t\n\r\f\v");
  return String(result.substr(start, end - start + 1));
}

String String::trimLeft() const {
  std::string result = getValue();
  size_t start = result.find_first_not_of(" \t\n\r\f\v");
  if (start == std::string::npos) return String("");
  return String(result.substr(start));
}

String String::trimRight() const {
  std::string result = getValue();
  size_t end = result.find_last_not_of(" \t\n\r\f\v");
  if (end == std::string::npos) return String("");
  return String(result.substr(0, end + 1));
}

String String::replaceAll(const String& from, const String& to) const {
  std::string result = getValue();
  const std::string& from_str = from.getValue();
  const std::string& to_str = to.getValue();
  size_t pos = 0;
  while ((pos = result.find(from_str, pos)) != std::string::npos) {
    result.replace(pos, from_str.length(), to_str);
    pos += to_str.length();
  }
  return String(result);
}

String String::replaceFirst(const String& from, const String& to) const {
  std::string result = getValue();
  const std::string& from_str = from.getValue();
  const std::string& to_str = to.getValue();
  size_t pos = result.find(from_str);
  if (pos != std::string::npos) {
    result.replace(pos, from_str.length(), to_str);
  }
  return String(result);
}

String String::padLeft(int width, const String& padding) const {
  const std::string& str = getValue();
  if (width <= get_length()) return *this;
  int padCount = width - get_length();
  std::string result;
  const std::string& pad_str = padding.getValue();
  for (int i = 0; i < padCount; i++) {
    result += pad_str;
  }
  result += str;
  return String(result);
}

String String::padRight(int width, const String& padding) const {
  const std::string& str = getValue();
  if (width <= get_length()) return *this;
  int padCount = width - get_length();
  std::string result = str;
  const std::string& pad_str = padding.getValue();
  for (int i = 0; i < padCount; i++) {
    result += pad_str;
  }
  return String(result);
}

String::operator std::string() const {
  return getValue();
}

String::operator const char*() const {
  return getValue().c_str();
}

// ============================================================================
// CppUserData 实现
// ============================================================================

CppUserData::CppUserData() : length(0), data(new void*[0]) {
  type_id = 5;
}

CppUserData::CppUserData(int length) : length(length), data(new void*[length]) {
  type_id = 5;
}

CppUserData::CppUserData(const CppUserData& other)
    : length(other.length), data(new void*[other.length]) {
  for (int i = 0; i < other.length; i++) {
    data[i] = other.data[i];
  }
  type_id = 5;
}

CppUserData::~CppUserData() {
  delete[] data;
}

CppUserData& CppUserData::operator=(const CppUserData& other) {
  if (this != &other) {
    delete[] data;
    length = other.length;
    type_id = 5;
    data = new void*[length];
    for (int i = 0; i < length; i++) {
      data[i] = other.data[i];
    }
  }
  return *this;
}


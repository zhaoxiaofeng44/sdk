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
// Any 实现
// ============================================================================

String Any::toString() const {
  return String("Any");
}

// ============================================================================
// Void 实现
// ============================================================================

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

Int Int::operator_plus(const Int& other) const {
  return Int(value + other.value);
}

Int Int::operator_minus(const Int& other) const {
  return Int(value - other.value);
}

Int Int::operator_multiply(const Int& other) const {
  return Int(value * other.value);
}

Int Int::operator_divide(const Int& other) const {
  if (other.value == 0) throw std::runtime_error("Division by zero");
  return Int(value / other.value);
}

Int Int::operator_modulo(const Int& other) const {
  if (other.value == 0) throw std::runtime_error("Division by zero");
  return Int(value % other.value);
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
  if (other.value == 0) throw std::runtime_error("Division by zero");
  return Int(value / other.value);
}

Int Int::operator_bitwise_and(const Int& other) const {
  return Int(value & other.value);
}

Int Int::operator_bitwise_or(const Int& other) const {
  return Int(value | other.value);
}

Int Int::operator_bitwise_xor(const Int& other) const {
  return Int(value ^ other.value);
}

Int Int::operator_shift_left(const Int& other) const {
  return Int(value << other.value);
}

Int Int::operator_shift_right(const Int& other) const {
  return Int(value >> other.value);
}

Int Int::operator_bitwise_not() const {
  return Int(~value);
}

Bool Int::operator==(const Int& other) const {
  return Bool(value == other.value);
}

Bool Int::operator!=(const Int& other) const {
  return Bool(value != other.value);
}

Bool Int::operator<(const Int& other) const {
  return Bool(value < other.value);
}

Bool Int::operator<=(const Int& other) const {
  return Bool(value <= other.value);
}

Bool Int::operator>(const Int& other) const {
  return Bool(value > other.value);
}

Bool Int::operator>=(const Int& other) const {
  return Bool(value >= other.value);
}


Int Int::operator_unary_minus() const {
  return Int(-value);
}

Int Int::operator_unary_plus() const {
  return Int(value);
}

Int Int::abs() const {
  return Int(std::abs(value));
}

String Int::toString() const {
  std::stringstream ss;
  ss << value;
  return String(ss.str());
}

Double Int::toDouble() const {
  return Double(static_cast<double>(value));
}

Int Int::compareTo(const Int& other) const {
  if (value < other.value) return Int(-1);
  if (value > other.value) return Int(1);
  return Int(0);
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

Int Int::get_sign() const {
  if (value > 0) return Int(1);
  if (value < 0) return Int(-1);
  return Int(0);
}

Bool Int::get_isEven() const {
  return Bool((value % 2) == 0);
}

Bool Int::get_isOdd() const {
  return Bool((value % 2) != 0);
}

Bool Int::get_isNegative() const {
  return Bool(value < 0);
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
  return value;
}


bool Int::toBool() const {
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

Double::Double(const Int& other) : value(static_cast<double>(other.value)) {
  type_id = 2;
}

Double Double::operator_plus(const Double& other) const {
  return Double(value + other.value);
}

Double Double::operator_minus(const Double& other) const {
  return Double(value - other.value);
}

Double Double::operator_multiply(const Double& other) const {
  return Double(value * other.value);
}

Double Double::operator_divide(const Double& other) const {
  if (other.value == 0.0) return Double(value > 0 ? INFINITY : -INFINITY);
  return Double(value / other.value);
}

Double Double::operator_modulo(const Double& other) const {
  if (other.value == 0.0) return Double(NAN);
  return Double(std::fmod(value, other.value));
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

Bool Double::operator==(const Double& other) const {
  return Bool(value == other.value);
}

Bool Double::operator!=(const Double& other) const {
  return Bool(value != other.value);
}

Bool Double::operator<(const Double& other) const {
  return Bool(value < other.value);
}

Bool Double::operator<=(const Double& other) const {
  return Bool(value <= other.value);
}

Bool Double::operator>(const Double& other) const {
  return Bool(value > other.value);
}

Bool Double::operator>=(const Double& other) const {
  return Bool(value >= other.value);
}


Double Double::operator_unary_minus() const {
  return Double(-value);
}

Double Double::operator_unary_plus() const {
  return Double(value);
}

Double Double::abs() const {
  return Double(std::abs(value));
}

String Double::toString() const {
  if (get_isNaN().value) return String("NaN");
  if (get_isInfinite().value) return value > 0 ? String("Infinity") : String("-Infinity");
  std::stringstream ss;
  ss << value;
  return String(ss.str());
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

Int Double::compareTo(const Double& other) const {
  if (get_isNaN().value && other.get_isNaN().value) return Int(0);
  if (get_isNaN().value) return Int(1);
  if (other.get_isNaN().value) return Int(-1);
  if (value < other.value) return Int(-1);
  if (value > other.value) return Int(1);
  return Int(0);
}

Int Double::get_sign() const {
  if (get_isNaN().value) return Int(0);
  if (value > 0.0 || (value == 0.0 && 1.0 / value > 0.0)) return Int(1);
  if (value < 0.0 || (value == 0.0 && 1.0 / value < 0.0)) return Int(-1);
  return Int(0);
}

Bool Double::get_isNegative() const {
  return Bool(value < 0.0 || (value == 0.0 && 1.0 / value < 0.0));
}

Bool Double::get_isFinite() const {
  return Bool(std::isfinite(value));
}

Bool Double::get_isInfinite() const {
  return Bool(std::isinf(value));
}

Bool Double::get_isNaN() const {
  return Bool(std::isnan(value));
}

double Double::toDouble() const {
  return value;
}

Int Double::toInt() const {
  if (get_isNaN().value || get_isInfinite().value) return Int(0);
  return Int(static_cast<int>(value));
}

Bool Double::toBool() const {
  return Bool(!get_isNaN().value && value != 0.0);
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

Bool Bool::operator==(const Bool& other) const {
  return Bool(value == other.value);
}

Bool Bool::operator!=(const Bool& other) const {
  return Bool(value != other.value);
}


String Bool::toString() const {
  return value ? String("true") : String("false");
}

Int Bool::compareTo(const Bool& other) const {
  if (value == other.value) return Int(0);
  return value ? Int(1) : Int(-1);
}

Bool::operator bool() const {
  return value;
}

bool Bool::toBool() const {
  return value;
}

Int Bool::toInt() const {
  return Int(value ? 1 : 0);
}

// ============================================================================
// String 实现（使用字符串池）
// ============================================================================

String::String() {
  type_id = 4;
  string_index_ = 0;  // 空字符串索引
}

String::String(const char* v) {
  type_id = 4;
  string_index_ = StringPool::getInstance()->intern(std::string(v));
}

String::String(const std::string& v) {
  type_id = 4;
  string_index_ = StringPool::getInstance()->intern(v);
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

Int String::getIndex() const {
  return Int(string_index_);
}

String String::operator+(const String& other) const {
  return String(getValue() + other.getValue());
}

String String::operator_concat(const String& other) const {
  return String(getValue() + other.getValue());
}

Bool String::operator==(const String& other) const {
  return Bool(string_index_ == other.string_index_);
}

Bool String::operator==(const char* other) const {
  return Bool(getValue() == std::string(other));
}

Bool String::operator==(const std::string& other) const {
  return Bool(getValue() == other);
}

Bool String::operator!=(const String& other) const {
  return Bool(string_index_ != other.string_index_);
}

Bool String::operator!=(const char* other) const {
  return Bool(getValue() != std::string(other));
}

Bool String::operator!=(const std::string& other) const {
  return Bool(getValue() != other);
}

Bool String::operator<(const String& other) const {
  return Bool(getValue() < other.getValue());
}

Bool String::operator<=(const String& other) const {
  return Bool(getValue() <= other.getValue());
}

Bool String::operator>(const String& other) const {
  return Bool(getValue() > other.getValue());
}

Bool String::operator>=(const String& other) const {
  return Bool(getValue() >= other.getValue());
}

String String::operator[](const Int& index) const {
  const std::string& str = getValue();
  int idx = index.toInt();
  int len = static_cast<int>(str.length());
  if (idx >= 0 && idx < len) {
    return String(str.substr(idx, 1));
  }
  throw std::out_of_range("String index out of range");
}


String String::toString() const {
  return String(getValue());
}

Int String::get_length() const {
  return Int(static_cast<int>(getValue().length()));
}

Bool String::get_isEmpty() const {
  return Bool(getValue().empty());
}

Bool String::get_isNotEmpty() const {
  return Bool(!getValue().empty());
}

Int String::compareTo(const String& other) const {
  const std::string& v1 = getValue();
  const std::string& v2 = other.getValue();
  if (v1 < v2) return Int(-1);
  if (v1 > v2) return Int(1);
  return Int(0);
}

String String::substring(const Int& start, const Int& end) const {
  const std::string& str = getValue();
  int startIdx = start.toInt();
  int endIdx = end.toInt();
  int length = get_length().toInt();

  if (endIdx == -1) {
    endIdx = length;
  }

  if (startIdx < 0 || startIdx > length || endIdx < startIdx || endIdx > length) {
    throw std::out_of_range("Substring range out of bounds");
  }

  return String(str.substr(startIdx, endIdx - startIdx));
}

Int String::indexOf(const String& pattern, const Int& start) const {
  const std::string& str = getValue();
  int startIdx = start.toInt();
  int length = get_length().toInt();

  if (startIdx < 0 || startIdx >= length) return Int(-1);

  size_t pos = str.find(pattern.getValue(), startIdx);
  return pos == std::string::npos ? Int(-1) : Int(static_cast<int>(pos));
}

Int String::lastIndexOf(const String& pattern, const Int& start) const {
  const std::string& str = getValue();
  int startIdx = start.toInt();
  int length = get_length().toInt();

  if (startIdx == -1) {
    startIdx = length - 1;
  }

  if (startIdx < 0 || startIdx >= length) return Int(-1);

  size_t pos = str.rfind(pattern.getValue(), startIdx);
  return pos == std::string::npos ? Int(-1) : Int(static_cast<int>(pos));
}

Bool String::startsWith(const String& pattern) const {
  const std::string& str = getValue();
  const std::string& pat = pattern.getValue();
  if (pat.length() > str.length()) return Bool(false);
  return Bool(str.substr(0, pat.length()) == pat);
}

Bool String::endsWith(const String& pattern) const {
  const std::string& str = getValue();
  const std::string& pat = pattern.getValue();
  if (pat.length() > str.length()) return Bool(false);
  return Bool(str.substr(str.length() - pat.length()) == pat);
}

Bool String::contains(const String& pattern) const {
  Int result = indexOf(pattern, Int(0));
  return Bool(result.toInt() != -1);
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

String String::padLeft(const Int& width, const String& padding) const {
  const std::string& str = getValue();
  int widthVal = width.toInt();
  int length = get_length().toInt();

  if (widthVal <= length) return *this;

  int padCount = widthVal - length;
  std::string result;
  const std::string& pad_str = padding.getValue();
  for (int i = 0; i < padCount; i++) {
    result += pad_str;
  }
  result += str;
  return String(result);
}

String String::padRight(const Int& width, const String& padding) const {
  const std::string& str = getValue();
  int widthVal = width.toInt();
  int length = get_length().toInt();

  if (widthVal <= length) return *this;

  int padCount = widthVal - length;
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
// CppUserData 引用计数实现已在头文件中定义
// ============================================================================

// ============================================================================
// List容器类型实现
// ============================================================================

template <typename T>
List<T>::List() {
  type_id = 6;
}

template <typename T>
List<T>::List(const List& other) : data_(other.data_) {
  type_id = 6;
}

template <typename T>
List<T>::List(std::initializer_list<T> init) : data_(init) {
  type_id = 6;
}

template <typename T>
void List<T>::add(const T& item) {
  data_.push_back(item);
}

template <typename T>
void List<T>::insert(Int index, const T& item) {
  int idx = index.toInt();
  int size = static_cast<int>(data_.size());

  if (idx < 0 || idx > size) {
    throw std::out_of_range("List index out of range");
  }

  data_.insert(data_.begin() + idx, item);
}

template <typename T>
void List<T>::remove(Int index) {
  int idx = index.toInt();
  int size = static_cast<int>(data_.size());

  if (idx < 0 || idx >= size) {
    throw std::out_of_range("List index out of range");
  }

  data_.erase(data_.begin() + idx);
}

template <typename T>
void List<T>::removeElement(const T& item) {
  data_.erase(std::remove(data_.begin(), data_.end(), item), data_.end());
}

template <typename T>
void List<T>::clear() {
  data_.clear();
}

template <typename T>
T& List<T>::operator[](Int index) {
  int idx = index.toInt();
  int size = static_cast<int>(data_.size());

  if (idx < 0 || idx >= size) {
    throw std::out_of_range("List index out of range");
  }

  return data_[idx];
}

template <typename T>
const T& List<T>::operator[](Int index) const {
  int idx = index.toInt();
  int size = static_cast<int>(data_.size());

  if (idx < 0 || idx >= size) {
    throw std::out_of_range("List index out of range");
  }

  return data_[idx];
}

template <typename T>
T List<T>::get(Int index) const {
  return (*this)[index];
}

template <typename T>
T List<T>::getFirst() const {
  if (data_.empty()) {
    throw std::out_of_range("List is empty");
  }
  return data_.front();
}

template <typename T>
T List<T>::getLast() const {
  if (data_.empty()) {
    throw std::out_of_range("List is empty");
  }
  return data_.back();
}

template <typename T>
Int List<T>::size() const {
  return Int(static_cast<int>(data_.size()));
}

template <typename T>
Bool List<T>::isEmpty() const {
  return Bool(data_.empty());
}

template <typename T>
Bool List<T>::contains(const T& item) const {
  return Bool(std::find(data_.begin(), data_.end(), item) != data_.end());
}

template <typename T>
Int List<T>::indexOf(const T& item) const {
  auto it = std::find(data_.begin(), data_.end(), item);
  if (it == data_.end()) {
    return Int(-1);
  }
  return Int(static_cast<int>(std::distance(data_.begin(), it)));
}

template <typename T>
Int List<T>::lastIndexOf(const T& item) const {
  auto it = std::find_end(data_.begin(), data_.end(), &item, &item + 1);
  if (it == data_.end()) {
    return Int(-1);
  }
  return Int(static_cast<int>(std::distance(data_.begin(), it)));
}

template <typename T>
void List<T>::sort() {
  std::sort(data_.begin(), data_.end());
}

template <typename T>
void List<T>::reverse() {
  std::reverse(data_.begin(), data_.end());
}

template <typename T>
ObjectPtr<List<T>> List<T>::subList(Int start, Int end) const {
  int startIdx = start.toInt();
  int endIdx = end.toInt();
  int size = static_cast<int>(data_.size());

  if (startIdx < 0 || startIdx >= size || endIdx < startIdx || endIdx > size) {
    throw std::out_of_range("SubList range out of bounds");
  }

  ObjectPtr<List<T>> result = List<T>::create();
  for (int i = startIdx; i < endIdx; i++) {
    result->add(data_[i]);
  }
  return result;
}

template <typename T>
String List<T>::toString() const {
  String result = String("[");
  for (size_t i = 0; i < data_.size(); i++) {
    if (i > 0) {
      result = result + String(", ");
    }
    result = result + String("item");
  }
  result = result + String("]");
  return result;
}

template <typename T>
ListIterator<T> List<T>::iterator() {
  return ListIterator<T>(data_.begin(), data_.end());
}

template <typename T>
void List<T>::forEach(std::function<void(const T&)> callback) const {
  for (const auto& item : data_) {
    callback(item);
  }
}

template <typename T>
List<T>::operator std::vector<T>() const {
  return data_;
}

// ============================================================================
// Set容器类型实现
// ============================================================================

template <typename T>
Set<T>::Set() {
  type_id = 7;
}

template <typename T>
Set<T>::Set(const Set& other) : data_(other.data_) {
  type_id = 7;
}

template <typename T>
Set<T>::Set(std::initializer_list<T> init) : data_(init) {
  type_id = 7;
}

template <typename T>
void Set<T>::add(const T& item) {
  data_.insert(item);
}

template <typename T>
void Set<T>::remove(const T& item) {
  data_.erase(item);
}

template <typename T>
void Set<T>::clear() {
  data_.clear();
}

template <typename T>
Bool Set<T>::contains(const T& item) const {
  return Bool(data_.find(item) != data_.end());
}

template <typename T>
Int Set<T>::size() const {
  return Int(static_cast<int>(data_.size()));
}

template <typename T>
Bool Set<T>::isEmpty() const {
  return Bool(data_.empty());
}

template <typename T>
ObjectPtr<Set<T>> Set<T>::unionWith(const ObjectPtr<Set<T>>& other) const {
  ObjectPtr<Set<T>> result = Set<T>::create(*this);
  for (const auto& item : other->data_) {
    result->add(item);
  }
  return result;
}

template <typename T>
ObjectPtr<Set<T>> Set<T>::intersection(const ObjectPtr<Set<T>>& other) const {
  ObjectPtr<Set<T>> result = Set<T>::create();
  for (const auto& item : data_) {
    if (other->contains(item).toBool()) {
      result->add(item);
    }
  }
  return result;
}

template <typename T>
ObjectPtr<Set<T>> Set<T>::difference(const ObjectPtr<Set<T>>& other) const {
  ObjectPtr<Set<T>> result = Set<T>::create();
  for (const auto& item : data_) {
    if (!other->contains(item).toBool()) {
      result->add(item);
    }
  }
  return result;
}

template <typename T>
Bool Set<T>::isSubsetOf(const ObjectPtr<Set<T>>& other) const {
  for (const auto& item : data_) {
    if (!other->contains(item).toBool()) {
      return Bool(false);
    }
  }
  return Bool(true);
}

template <typename T>
String Set<T>::toString() const {
  String result = String("{");
  bool first = true;
  for (const auto& item : data_) {
    (void)item;  // 避免未使用警告
    if (!first) {
      result = result + String(", ");
    }
    first = false;
    result = result + String("item");
  }
  result = result + String("}");
  return result;
}

template <typename T>
SetIterator<T> Set<T>::iterator() {
  return SetIterator<T>(data_.begin(), data_.end());
}

template <typename T>
void Set<T>::forEach(std::function<void(const T&)> callback) const {
  for (const auto& item : data_) {
    callback(item);
  }
}

template <typename T>
Set<T>::operator std::unordered_set<T>() const {
  return data_;
}

// ============================================================================
// Map容器类型实现
// ============================================================================

template <typename K, typename V>
Map<K, V>::Map() {
  type_id = 8;
}

template <typename K, typename V>
Map<K, V>::Map(const Map& other) : data_(other.data_) {
  type_id = 8;
}

template <typename K, typename V>
Map<K, V>::Map(std::initializer_list<std::pair<K, V>> init) {
  type_id = 8;
  for (const auto& pair : init) {
    data_[pair.first] = pair.second;
  }
}

template <typename K, typename V>
void Map<K, V>::put(const K& key, const V& value) {
  data_[key] = value;
}

template <typename K, typename V>
void Map<K, V>::remove(const K& key) {
  data_.erase(key);
}

template <typename K, typename V>
void Map<K, V>::clear() {
  data_.clear();
}

template <typename K, typename V>
V& Map<K, V>::operator[](const K& key) {
  return data_[key];
}

template <typename K, typename V>
const V& Map<K, V>::operator[](const K& key) const {
  auto it = data_.find(key);
  if (it == data_.end()) {
    throw std::out_of_range("Map key not found");
  }
  return it->second;
}

template <typename K, typename V>
V Map<K, V>::get(const K& key) const {
  return (*this)[key];
}

template <typename K, typename V>
Bool Map<K, V>::containsKey(const K& key) const {
  return Bool(data_.find(key) != data_.end());
}

template <typename K, typename V>
Bool Map<K, V>::containsValue(const V& value) const {
  for (const auto& pair : data_) {
    if (pair.second == value) {
      return Bool(true);
    }
  }
  return Bool(false);
}

template <typename K, typename V>
Int Map<K, V>::size() const {
  return Int(static_cast<int>(data_.size()));
}

template <typename K, typename V>
Bool Map<K, V>::isEmpty() const {
  return Bool(data_.empty());
}

template <typename K, typename V>
ObjectPtr<Set<K>> Map<K, V>::keySet() const {
  ObjectPtr<Set<K>> keys = Set<K>::create();
  for (const auto& pair : data_) {
    keys->add(pair.first);
  }
  return keys;
}

template <typename K, typename V>
ObjectPtr<List<V>> Map<K, V>::values() const {
  ObjectPtr<List<V>> vals = List<V>::create();
  for (const auto& pair : data_) {
    vals->add(pair.second);
  }
  return vals;
}

template <typename K, typename V>
String Map<K, V>::toString() const {
  String result = String("{");
  bool first = true;
  for (const auto& pair : data_) {
    (void)pair;  // 避免未使用警告
    if (!first) {
      result = result + String(", ");
    }
    first = false;
    result = result + String("key: value");
  }
  result = result + String("}");
  return result;
}

template <typename K, typename V>
MapIterator<K, V> Map<K, V>::iterator() {
  return MapIterator<K, V>(data_.begin(), data_.end());
}

template <typename K, typename V>
void Map<K, V>::forEach(std::function<void(const K&, const V&)> callback) const {
  for (const auto& pair : data_) {
    callback(pair.first, pair.second);
  }
}

template <typename K, typename V>
Map<K, V>::operator std::unordered_map<K, V>() const {
  return data_;
}

// ============================================================================
// 显式模板实例化
// ============================================================================

// List 实例化
template class List<Int>;
template class List<Double>;
template class List<String>;
template class List<Bool>;

// Set 实例化
template class Set<Int>;
template class Set<Double>;
template class Set<String>;
template class Set<Bool>;

// Map 实例化
template class Map<String, Int>;
template class Map<String, Double>;
template class Map<String, String>;
template class Map<Int, Int>;
template class Map<Int, String>;

// 为自定义类型添加前向声明和实例化
// 注意：这些类型在测试文件中定义，这里只是为了编译通过
// 实际使用时，应该在定义这些类型的文件中进行实例化


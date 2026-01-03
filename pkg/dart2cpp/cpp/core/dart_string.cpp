#include "dart_string.h"
#include "dart_object.h"
#include <iomanip>

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
// String 类实现
// ============================================================================

String::String() { 
  type_id = 4; 
  value.string_index = 0; 
}

String::String(const String& other) { 
  type_id = other.type_id; 
  value.string_index = other.value.string_index; 
}

String::String(const char* v) {
  type_id = 4;
  value.string_index = StringPool::getInstance()->intern(std::string(v));
}

String::String(const std::string& v) {
  type_id = 4;
  value.string_index = StringPool::getInstance()->intern(v);
}

String::String(int index) {
  type_id = 4;
  value.string_index = index;
}

String::String(const Any& any) {
  if (any.type_id == 4) {
    type_id = 4;
    value.string_index = any.value.string_index;
  } else {
    type_id = 4;
    value.string_index = any.getStringIndex();
  }
}

String::String(const Nullable&) { 
  type_id = 0; 
  value.string_index = 0; 
}

String& String::operator=(const String& other) {
  if (this != &other) {
    type_id = other.type_id;
    value.string_index = other.value.string_index;
  }
  return *this;
}

String& String::operator=(const Any& any) {
  if (any.type_id == 4) {
    type_id = 4;
    value.string_index = any.value.string_index;
  } else {
    type_id = 4;
    value.string_index = any.getStringIndex();
  }
  return *this;
}

String& String::operator=(const Nullable&) { 
  type_id = 0; 
  value.string_index = 0; 
  return *this; 
}

int String::getStringIndex() const { 
  return value.string_index; 
}

String String::operator_concat(const String& other) const {
  const std::string& str1 = StringPool::getInstance()->getString(value.string_index);
  const std::string& str2 = StringPool::getInstance()->getString(other.value.string_index);
  return String(str1 + str2);
}

String String::operator+(const String& other) const {
  return operator_concat(other);
}

String String::operator+(const Bool& other) const {
  const std::string& str1 = StringPool::getInstance()->getString(value.string_index);
  std::string str2 = other.getValue() ? "true" : "false";
  return String(str1 + str2);
}

String String::operator_add(const String& other) const {
  return operator_concat(other);
}

String String::operator_add(const Bool& other) const {
  const std::string& str1 = StringPool::getInstance()->getString(value.string_index);
  std::string str2 = other.getValue() ? "true" : "false";
  return String(str1 + str2);
}

Bool String::operator==(const String& other) const {
  return Bool(value.string_index == other.value.string_index);
}

Bool String::operator==(const char* other) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  return Bool(str == std::string(other));
}

Bool String::operator==(const std::string& other) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  return Bool(str == other);
}

Bool String::operator!=(const String& other) const {
  return Bool(value.string_index != other.value.string_index);
}

Bool String::operator!=(const char* other) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  return Bool(str != std::string(other));
}

Bool String::operator!=(const std::string& other) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  return Bool(str != other);
}

Bool String::operator<(const String& other) const {
  const std::string& str1 = StringPool::getInstance()->getString(value.string_index);
  const std::string& str2 = StringPool::getInstance()->getString(other.value.string_index);
  return Bool(str1 < str2);
}

Bool String::operator<=(const String& other) const {
  const std::string& str1 = StringPool::getInstance()->getString(value.string_index);
  const std::string& str2 = StringPool::getInstance()->getString(other.value.string_index);
  return Bool(str1 <= str2);
}

Bool String::operator>(const String& other) const {
  const std::string& str1 = StringPool::getInstance()->getString(value.string_index);
  const std::string& str2 = StringPool::getInstance()->getString(other.value.string_index);
  return Bool(str1 > str2);
}

Bool String::operator>=(const String& other) const {
  const std::string& str1 = StringPool::getInstance()->getString(value.string_index);
  const std::string& str2 = StringPool::getInstance()->getString(other.value.string_index);
  return Bool(str1 >= str2);
}

String String::operator[](const Int& index) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  int idx = index.getValue();
  if (idx >= 0 && idx < static_cast<int>(str.length())) {
    return String(std::string(1, str[idx]));
  }
  throw std::out_of_range("String index out of range");
}

String String::toString() const {
  return *this;
}

Int String::get_length() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  return Int(static_cast<int>(str.length()));
}

Int String::length() const {
  return get_length();
}

Int String::size() const {
  return get_length();
}

Bool String::get_isEmpty() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  return Bool(str.empty());
}

Bool String::isEmpty() const {
  return get_isEmpty();
}

Bool String::get_isNotEmpty() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  return Bool(!str.empty());
}

Bool String::isNotEmpty() const {
  return get_isNotEmpty();
}

Bool String::isNull() const {
  return Bool(false);  // String 对象本身不为 null
}

Int String::compareTo(const String& other) const {
  const std::string& str1 = StringPool::getInstance()->getString(value.string_index);
  const std::string& str2 = StringPool::getInstance()->getString(other.value.string_index);
  if (str1 < str2) return Int(-1);
  if (str1 > str2) return Int(1);
  return Int(0);
}

String String::substring(const Int& start, const Int& end) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  int startIdx = start.getValue();
  int endIdx = end.getValue();
  
  if (startIdx < 0) startIdx = 0;
  if (endIdx > static_cast<int>(str.length())) endIdx = static_cast<int>(str.length());
  if (startIdx >= endIdx) return String("");
  
  return String(str.substr(startIdx, endIdx - startIdx));
}

String String::substring(const Int& start) const {
  // 单参数版本：从 start 到字符串末尾
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  return substring(start, Int(static_cast<int>(str.length())));
}

Int String::indexOf(const String& pattern) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pat = StringPool::getInstance()->getString(pattern.value.string_index);
  
  size_t pos = str.find(pat, 0);
  if (pos == std::string::npos) {
    return Int(-1);
  }
  return Int(static_cast<int>(pos));
}

Int String::indexOf(const String& pattern, const Int& start) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pat = StringPool::getInstance()->getString(pattern.value.string_index);
  
  size_t pos = str.find(pat, start.getValue());
  if (pos == std::string::npos) {
    return Int(-1);
  }
  return Int(static_cast<int>(pos));
}

Int String::lastIndexOf(const String& pattern) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pat = StringPool::getInstance()->getString(pattern.value.string_index);
  
  size_t pos = str.rfind(pat);
  if (pos == std::string::npos) {
    return Int(-1);
  }
  return Int(static_cast<int>(pos));
}

Int String::lastIndexOf(const String& pattern, const Int& start) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pat = StringPool::getInstance()->getString(pattern.value.string_index);
  
  size_t startPos = (start.getValue() == -1) ? std::string::npos : start.getValue();
  size_t pos = str.rfind(pat, startPos);
  if (pos == std::string::npos) {
    return Int(-1);
  }
  return Int(static_cast<int>(pos));
}

Bool String::startsWith(const String& pattern) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pat = StringPool::getInstance()->getString(pattern.value.string_index);
  
  if (pat.length() > str.length()) return Bool(false);
  return Bool(str.substr(0, pat.length()) == pat);
}

Bool String::endsWith(const String& pattern) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pat = StringPool::getInstance()->getString(pattern.value.string_index);
  
  if (pat.length() > str.length()) return Bool(false);
  return Bool(str.substr(str.length() - pat.length()) == pat);
}

Bool String::contains(const String& pattern) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pat = StringPool::getInstance()->getString(pattern.value.string_index);
  
  return Bool(str.find(pat) != std::string::npos);
}

String String::toLowerCase() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  std::string result = str;
  std::transform(result.begin(), result.end(), result.begin(), ::tolower);
  return String(result);
}

String String::toUpperCase() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  std::string result = str;
  std::transform(result.begin(), result.end(), result.begin(), ::toupper);
  return String(result);
}

String String::trim() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  size_t start = str.find_first_not_of(" \t\n\r\f\v");
  if (start == std::string::npos) return String("");
  
  size_t end = str.find_last_not_of(" \t\n\r\f\v");
  return String(str.substr(start, end - start + 1));
}

String String::trimLeft() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  size_t start = str.find_first_not_of(" \t\n\r\f\v");
  if (start == std::string::npos) return String("");
  return String(str.substr(start));
}

String String::trimRight() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  size_t end = str.find_last_not_of(" \t\n\r\f\v");
  if (end == std::string::npos) return String("");
  return String(str.substr(0, end + 1));
}

String String::replaceAll(const String& from, const String& to) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& fromStr = StringPool::getInstance()->getString(from.value.string_index);
  const std::string& toStr = StringPool::getInstance()->getString(to.value.string_index);
  
  std::string result = str;
  size_t pos = 0;
  while ((pos = result.find(fromStr, pos)) != std::string::npos) {
    result.replace(pos, fromStr.length(), toStr);
    pos += toStr.length();
  }
  return String(result);
}

String String::replaceFirst(const String& from, const String& to) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& fromStr = StringPool::getInstance()->getString(from.value.string_index);
  const std::string& toStr = StringPool::getInstance()->getString(to.value.string_index);
  
  std::string result = str;
  size_t pos = result.find(fromStr);
  if (pos != std::string::npos) {
    result.replace(pos, fromStr.length(), toStr);
  }
  return String(result);
}

String String::padLeft(const Int& width, const String& padding) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pad = StringPool::getInstance()->getString(padding.value.string_index);
  
  int w = width.getValue();
  if (w <= static_cast<int>(str.length())) return *this;
  
  int padLength = w - static_cast<int>(str.length());
  std::string result;
  
  for (int i = 0; i < padLength; ++i) {
    result += pad;
  }
  result += str;
  
  return String(result);
}

String String::padRight(const Int& width, const String& padding) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& pad = StringPool::getInstance()->getString(padding.value.string_index);
  
  int w = width.getValue();
  if (w <= static_cast<int>(str.length())) return *this;
  
  int padLength = w - static_cast<int>(str.length());
  std::string result = str;
  
  for (int i = 0; i < padLength; ++i) {
    result += pad;
  }
  
  return String(result);
}

String String::repeat(const Int& times) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  int t = times.getValue();
  
  if (t <= 0) return String("");
  
  std::string result;
  for (int i = 0; i < t; ++i) {
    result += str;
  }
  
  return String(result);
}

String String::operator_mul(const Int& times) const {
  return repeat(times);
}

String String::operator*(const Int& times) const {
  return repeat(times);
}

ObjectPtr<List<Int> > String::get_codeUnits() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  ObjectPtr<List<Int> > result = List<Int>::create();
  for (unsigned char c : str) {
    result->add(Int(static_cast<int>(c)));
  }
  return result;
}

String::operator std::string() const {
  return StringPool::getInstance()->getString(value.string_index);
}

String::operator const char*() const {
  return StringPool::getInstance()->getString(value.string_index).c_str();
}

const std::string& String::getValue() const {
  return StringPool::getInstance()->getString(value.string_index);
}

Int String::getIndex() const {
  return Int(value.string_index);
}

// ============================================================================
// 字符串相关的全局函数实现
// ============================================================================

String create_dart_string(const char* str) {
  return String(str);
}

String create_dart_string(const std::string& str) {
  return String(str);
}

String create_dart_string(int value) {
  return String(std::to_string(value));
}

String create_dart_string(double value) {
  return String(std::to_string(value));
}

String create_dart_string(bool value) {
  return String(value ? "true" : "false");
}

// ============================================================================
// String 类型转换函数实现
// ============================================================================

String convertFromAny_String(const Any& any) {
  if (any.type_id == 4) {
    String result;
    result.type_id = 4;
    result.value.string_index = any.value.string_index;
    return result;
  }
  // 对于其他类型，转换为字符串表示
  return String("Any");
}

Any convertToAny_String(const String& value) {
  Any result;
  result.type_id = 4;
  result.value.string_index = value.value.string_index;
  return result;
}

String String::replaceRange(const Int& start, const Int& end, const String& replacement) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& repl = StringPool::getInstance()->getString(replacement.value.string_index);
  
  int startIdx = start.getValue();
  int endIdx = end.getValue();
  
  if (startIdx < 0) startIdx = 0;
  if (endIdx > static_cast<int>(str.length())) endIdx = static_cast<int>(str.length());
  if (startIdx >= endIdx) return *this;
  
  std::string result = str.substr(0, startIdx) + repl + str.substr(endIdx);
  return String(result);
}

ObjectPtr<List<String> > String::split(const String& separator) const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  const std::string& sep = StringPool::getInstance()->getString(separator.value.string_index);
  
  ObjectPtr<List<String> > result = List<String>::create();
  
  if (sep.empty()) {
    // 如果分隔符为空，返回包含整个字符串的列表
    result->add(*this);
    return result;
  }
  
  size_t start = 0;
  size_t found = str.find(sep);
  
  while (found != std::string::npos) {
    result->add(String(str.substr(start, found - start)));
    start = found + sep.length();
    found = str.find(sep, start);
  }
  
  // 添加最后一部分
  result->add(String(str.substr(start)));
  
  return result;
}

ObjectPtr<List<String> > String::splitMapJoin(const String& pattern) const {
  // 简单实现：使用 pattern 作为分隔符进行分割
  return split(pattern);
}

ObjectPtr<List<String> > String::splitChars() const {
  const std::string& str = StringPool::getInstance()->getString(value.string_index);
  ObjectPtr<List<String> > result = List<String>::create();
  
  for (size_t i = 0; i < str.length(); ++i) {
    result->add(String(std::string(1, str[i])));
  }
  
  return result;
}

String String::join(const ObjectPtr<List<String> >& strings, const String& separator) {
  if (strings.isNull().toBool() || strings->isEmpty().toBool()) {
    return String("");
  }
  
  const std::string& sep = StringPool::getInstance()->getString(separator.value.string_index);
  std::string result;
  
  int size = strings->size().getValue();
  for (int i = 0; i < size; ++i) {
    if (i > 0) {
      result += sep;
    }
    String str = strings->get(Int(i));
    result += StringPool::getInstance()->getString(str.value.string_index);
  }
  
  return String(result);
}

// ===========================================================================
// 静态扩展方法实现（从 StringExtensions 迁移）
// ===========================================================================

ObjectPtr<List<String>> String::splitStatic(const String& str, const String& delimiter) {
  ObjectPtr<List<String>> result = List<String>::create();
  std::string s = str.getValue();
  std::string delim = delimiter.getValue();
  
  if (delim.empty()) {
    result->add(str);
    return result;
  }
  
  size_t start = 0;
  size_t found = s.find(delim);
  
  while (found != std::string::npos) {
    if (found != start) {
      result->add(String(s.substr(start, found - start)));
    }
    start = found + delim.length();
    found = s.find(delim, start);
  }
  
  if (start < s.length()) {
    result->add(String(s.substr(start)));
  }
  
  return result;
}

String String::interpolate(const String& template_str, const ObjectPtr<Map<String, String>>& variables) {
  std::string result = template_str.getValue();
  
  // 简单的占位符替换：${变量名}
  auto it = variables->iterator();
  while (it->hasNext()) {
    String key = it->currentKey();
    String value = it->currentValue();
    
    std::string placeholder = "${" + key.getValue() + "}";
    size_t pos = result.find(placeholder);
    while (pos != std::string::npos) {
      result.replace(pos, placeholder.length(), value.getValue());
      pos = result.find(placeholder, pos + value.getValue().length());
    }
    it->next();
  }
  
  return String(result);
}

// ============================================================================
// RegExp 相关方法实现 - 将正则表达式功能合并到 String 类型
// ============================================================================

Bool String::hasMatch(const String& input) const {
  // 简化实现：基础字符串匹配
  const std::string& pattern = getValue();
  const std::string& str = input.getValue();
  return Bool(str.find(pattern) != std::string::npos);
}

String String::stringMatch(const String& input) const {
  const std::string& pattern = getValue();
  const std::string& str = input.getValue();
  auto pos = str.find(pattern);
  if (pos != std::string::npos) {
    return String(pattern);
  }
  return String("");
}

Int String::matchAsPrefix(const String& str, const Int& start) const {
  const std::string& pattern = getValue();
  const std::string& input = str.getValue();
  auto pos = input.find(pattern, start.getValue());
  return Int(pos != std::string::npos ? static_cast<int>(pos) : -1);
}

Int String::matchAsPrefix(const String& str) const {
  return matchAsPrefix(str, Int(0));
}

String String::pattern() const {
  return *this;  // 返回自身作为模式
}

Bool String::isCaseSensitive() const {
  return Bool(true);  // 默认区分大小写
}

Bool String::isMultiLine() const {
  return Bool(false);  // 默认不是多行模式
}

Bool String::isDotAll() const {
  return Bool(false);  // 默认不是 dotAll 模式
}

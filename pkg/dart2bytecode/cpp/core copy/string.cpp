#include "string.h"
#include "num.h"
#include <cstdlib>
#include <cstring>
#include <cctype>

// ==================== StringPoolEntry 实现 ====================



// ==================== StringPool 静态成员初始化 ====================

StringPoolEntry StringPool::pool[MAX_POOL_SIZE] = {};
int StringPool::poolSize = 0;

// ==================== StringPool 实现 ====================

bool StringPool::stringEqual(const char *s1, const char *s2, int len1, int len2) {
    if (len1 != len2) return false;
    if (s1 == s2) return true;
    if (!s1 || !s2) return false;
    
    for (int i = 0; i < len1; i++) {
        if (s1[i] != s2[i]) return false;
    }
    return true;
}

int StringPool::getStringLength(const char *str) {
    if (!str) return 0;
    int length = 0;
    while (str[length] != '\0') {
        length++;
    }
    return length;
}

char *StringPool::copyString(const char *str, int length) {
    if (!str) return nullptr;
    if (length < 0) length = 0;
    
    char *copy = new char[length + 1];
    for (int i = 0; i < length; i++) {
        copy[i] = str[i];
    }
    copy[length] = '\0';
    return copy;
}

StringPoolEntry* StringPool::intern(const char *str) {
    if (!str) {
        return nullptr;
    }

    int length = getStringLength(str);

    // 查找现有条目
    for (int i = 0; i < poolSize; i++) {
        if (pool[i].inUse && stringEqual(pool[i].data, str, pool[i].length, length)) {
            pool[i].refCount++;
            return &pool[i];
        }
    }

    // 创建新条目
    if (poolSize < MAX_POOL_SIZE) {
        pool[poolSize].data = copyString(str, length);
        pool[poolSize].length = length;
        pool[poolSize].refCount = 1;
        pool[poolSize].inUse = true;
        return &pool[poolSize++];
    }

    // 池已满，尝试重用未使用的条目
    for (int i = 0; i < MAX_POOL_SIZE; i++) {
        if (!pool[i].inUse) {
            pool[i].data = copyString(str, length);
            pool[i].length = length;
            pool[i].refCount = 1;
            pool[i].inUse = true;
            return &pool[i];
        }
    }

    return nullptr; // 池已满且无法重用
}

void StringPool::release(StringPoolEntry *entry) {
    if (!entry) return;
    
    entry->refCount--;
    if (entry->refCount <= 0) {
        delete[] entry->data;
        entry->data = nullptr;
        entry->length = 0;
        entry->inUse = false;
    }
}

int StringPool::getPoolSize() {
    return poolSize;
}

int StringPool::getActiveEntries() {
    int count = 0;
    for (int i = 0; i < MAX_POOL_SIZE; i++) {
        if (pool[i].inUse) count++;
    }
    return count;
}

// ==================== String 实例方法实现 ====================

String::String() : poolEntry(nullptr) {
    poolEntry = StringPool::intern("");
}

String::String(const char *str) : poolEntry(nullptr) {
    poolEntry = StringPool::intern(str ? str : "");
}

String::String(const String &other) : poolEntry(other.poolEntry) {
    if (poolEntry) {
        poolEntry->refCount++;
    }
}

String::~String() noexcept {
    if (poolEntry) {
        StringPool::release(poolEntry);
    }
}

String &String::operator=(const String &other) {
    if (this != &other) {
        if (poolEntry) {
            StringPool::release(poolEntry);
        }
        poolEntry = other.poolEntry;
        if (poolEntry) {
            poolEntry->refCount++;
        }
    }
    return *this;
}

String &String::operator=(const char *str) {
    if (poolEntry) {
        StringPool::release(poolEntry);
    }
    poolEntry = StringPool::intern(str ? str : "");
    return *this;
}

const char *String::c_str() const noexcept {
    return poolEntry ? poolEntry->data : "";
}

int String::length() const {
    return poolEntry ? poolEntry->length : 0;
}

char String::operator[](int index) const {
    if (!poolEntry || index < 0 || index >= poolEntry->length) {
        return '\0';
    }
    return poolEntry->data[index];
}

bool String::sharesSameData(const String &other) const {
    return poolEntry == other.poolEntry;
}

int String::getRefCount() const {
    return poolEntry ? poolEntry->refCount : 0;
}

// ==================== String 静态方法实现 ====================

// 操作符方法
String *String::cpp_add(String *b) noexcept {
    if (!b) return new String(*this);
    
    const char *str1 = this->c_str();
    const char *str2 = b->c_str();
    int len1 = this->length();
    int len2 = b->length();
    
    char *result = new char[len1 + len2 + 1];
    memcpy(result, str1, len1);
    memcpy(result + len1, str2, len2);
    result[len1 + len2] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

Bool *String::cpp_equals(String *b) noexcept {
    if (!b) return new Bool(false);
    return new Bool(StringPool::stringEqual(this->c_str(), b->c_str(), this->length(), b->length()));
}

Bool *String::cpp_greaterThan(String *b) noexcept {
    if (!b) return new Bool(false);
    return new Bool(strcmp(this->c_str(), b->c_str()) > 0);
}

Bool *String::cpp_lessThan(String *b) noexcept {
    if (!b) return new Bool(false);
    return new Bool(strcmp(this->c_str(), b->c_str()) < 0);
}

Bool *String::cpp_greaterThanOrEqual(String *b) noexcept {
    if (!b) return new Bool(false);
    return new Bool(strcmp(this->c_str(), b->c_str()) >= 0);
}

Bool *String::cpp_lessThanOrEqual(String *b) noexcept {
    if (!b) return new Bool(false);
    return new Bool(strcmp(this->c_str(), b->c_str()) <= 0);
}

String *String::cpp_subscript(Int *index) noexcept {
    if (!index) return new String("");
    
    int idx = index->getValue();
    if (idx < 0 || idx >= this->length()) {
        return new String("");
    }
    
    char c = (*this)[idx];
    char str[2] = {c, '\0'};
    return new String(str);
}

// 基本属性和检查方法
Int *String::getLength() noexcept {
    return new Int(this->length());
}

Bool *String::isEmpty() noexcept {
    return new Bool(this->length() == 0);
}

Bool *String::isNotEmpty() noexcept {
    return new Bool(this->length() > 0);
}

// Getter方法
Int *String::cppGet_length() noexcept {
    return this->getLength();
}

Bool *String::cppGet_isEmpty() noexcept {
    return this->isEmpty();
}

Bool *String::cppGet_isNotEmpty() noexcept {
    return this->isNotEmpty();
}

// 查找方法
Bool *String::contains(String *pattern) noexcept {
    if (!pattern) return new Bool(false);
    return new Bool(strstr(this->c_str(), pattern->c_str()) != nullptr);
}

Bool *String::startsWith(String *pattern) noexcept {
    if (!pattern) return new Bool(false);
    const char *str = this->c_str();
    const char *pat = pattern->c_str();
    int len = pattern->length();
    return new Bool(strncmp(str, pat, len) == 0);
}

Bool *String::endsWith(String *pattern) noexcept {
    if (!pattern) return new Bool(false);
    int len1 = this->length();
    int len2 = pattern->length();
    if (len2 > len1) return new Bool(false);
    
    const char *str = this->c_str();
    const char *pat = pattern->c_str();
    return new Bool(strcmp(str + len1 - len2, pat) == 0);
}

Int *String::indexOf(String *pattern, Int *start) noexcept {
    if (!pattern) return new Int(-1);
    int startPos = start ? start->getValue() : 0;
    if (startPos < 0) startPos = 0;
    
    const char *str = this->c_str();
    const char *pat = pattern->c_str();
    const char *pos = strstr(str + startPos, pat);
    return new Int(pos ? pos - str : -1);
}

Int *String::lastIndexOf(String *pattern, Int *start) noexcept {
    if (!pattern) return new Int(-1);
    int len1 = this->length();
    int len2 = pattern->length();
    int startPos = start ? start->getValue() : len1;
    if (startPos > len1) startPos = len1;
    
    const char *str = this->c_str();
    const char *pat = pattern->c_str();
    for (int i = startPos - len2; i >= 0; i--) {
        if (strncmp(str + i, pat, len2) == 0) {
            return new Int(i);
        }
    }
    return new Int(-1);
}

// 子字符串方法
String *String::substring(Int *start, Int *end) noexcept {
    if (!start) return new String(*this);
    
    int startPos = start->getValue();
    int endPos = end ? end->getValue() : this->length();
    int len = this->length();
    
    if (startPos < 0) startPos = 0;
    if (endPos > len) endPos = len;
    if (startPos >= endPos) return new String("");
    
    int newLen = endPos - startPos;
    char *result = new char[newLen + 1];
    memcpy(result, this->c_str() + startPos, newLen);
    result[newLen] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::substr(Int *start, Int *length) noexcept {
    if (!start) return new String(*this);
    
    int startPos = start->getValue();
    int len = length ? length->getValue() : this->length() - startPos;
    
    if (startPos < 0) startPos = 0;
    if (len < 0) len = 0;
    if (startPos + len > this->length()) len = this->length() - startPos;
    
    char *result = new char[len + 1];
    memcpy(result, this->c_str() + startPos, len);
    result[len] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

// 修剪方法
String *String::trim() noexcept {
    const char *str = this->c_str();
    int len = this->length();
    
    int start = 0;
    while (start < len && isspace(str[start])) start++;
    
    int end = len - 1;
    while (end >= start && isspace(str[end])) end--;
    
    int newLen = end - start + 1;
    if (newLen <= 0) return new String("");
    
    char *result = new char[newLen + 1];
    memcpy(result, str + start, newLen);
    result[newLen] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::trimLeft() noexcept {
    const char *str = this->c_str();
    int len = this->length();
    
    int start = 0;
    while (start < len && isspace(str[start])) start++;
    
    if (start >= len) return new String("");
    return new String(str + start);
}

String *String::trimRight() noexcept {
    const char *str = this->c_str();
    int len = this->length();
    
    int end = len - 1;
    while (end >= 0 && isspace(str[end])) end--;
    
    if (end < 0) return new String("");
    
    int newLen = end + 1;
    char *result = new char[newLen + 1];
    memcpy(result, str, newLen);
    result[newLen] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

// 大小写转换
String *String::toLowerCase() noexcept {
    const char *str = this->c_str();
    int len = this->length();
    
    char *result = new char[len + 1];
    for (int i = 0; i < len; i++) {
        result[i] = tolower(str[i]);
    }
    result[len] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::toUpperCase() noexcept {
    const char *str = this->c_str();
    int len = this->length();
    
    char *result = new char[len + 1];
    for (int i = 0; i < len; i++) {
        result[i] = toupper(str[i]);
    }
    result[len] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

// 替换方法
String *String::replaceAll(String *from, String *to) noexcept {
    if (!from || !to) return nullptr;
    const char *str = this->c_str();
    const char *fromStr = from->c_str();
    const char *toStr = to->c_str();
    int fromLen = from->length();
    if (fromLen == 0) return new String(*this);
    
    // 计算需要的空间
    int count = 0;
    const char *pos = str;
    while ((pos = strstr(pos, fromStr)) != nullptr) {
        count++;
        pos += fromLen;
    }
    
    if (count == 0) return new String(*this);
    
    int toLen = to->length();
    int newLen = this->length() + count * (toLen - fromLen);
    char *result = new char[newLen + 1];
    
    char *dest = result;
    const char *src = str;
    while ((pos = strstr(src, fromStr)) != nullptr) {
        int len = pos - src;
        memcpy(dest, src, len);
        dest += len;
        memcpy(dest, toStr, toLen);
        dest += toLen;
        src = pos + fromLen;
    }
    strcpy(dest, src);
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::replaceFirst(String *from, String *to) noexcept {
    if (!from || !to) return nullptr;
    const char *str = this->c_str();
    const char *fromStr = from->c_str();
    const char *toStr = to->c_str();
    int fromLen = from->length();
    if (fromLen == 0) return new String(*this);
    
    const char *pos = strstr(str, fromStr);
    if (!pos) return new String(*this);
    
    int toLen = to->length();
    int newLen = this->length() + toLen - fromLen;
    char *result = new char[newLen + 1];
    
    int prefixLen = pos - str;
    memcpy(result, str, prefixLen);
    memcpy(result + prefixLen, toStr, toLen);
    strcpy(result + prefixLen + toLen, pos + fromLen);
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::replaceRange(Int *start, Int *end, String *replacement) noexcept {
    if (!start || !end || !replacement) return nullptr;
    int startPos = start->getValue();
    int endPos = end->getValue();
    if (startPos < 0) startPos = 0;
    if (endPos > this->length()) endPos = this->length();
    if (startPos >= endPos) return new String(*this);
    
    const char *str = this->c_str();
    const char *repStr = replacement->c_str();
    int repLen = replacement->length();
    int newLen = this->length() - (endPos - startPos) + repLen;
    
    char *result = new char[newLen + 1];
    memcpy(result, str, startPos);
    memcpy(result + startPos, repStr, repLen);
    strcpy(result + startPos + repLen, str + endPos);
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

// 填充方法
String *String::padLeft(Int *width, String *padding) noexcept {
    if (!width) return nullptr;
    int targetWidth = width->getValue();
    if (targetWidth <= this->length()) return new String(*this);
    
    const char *padStr = padding ? padding->c_str() : " ";
    int padLen = padding ? padding->length() : 1;
    int padCount = (targetWidth - this->length() + padLen - 1) / padLen;
    
    char *result = new char[targetWidth + 1];
    char *dest = result;
    
    for (int i = 0; i < padCount; i++) {
        memcpy(dest, padStr, padLen);
        dest += padLen;
    }
    
    int remainingPad = targetWidth - this->length() - padCount * padLen;
    if (remainingPad > 0) {
        memcpy(dest, padStr, remainingPad);
        dest += remainingPad;
    }
    
    strcpy(dest, this->c_str());
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::padRight(Int *width, String *padding) noexcept {
    if (!width) return nullptr;
    int targetWidth = width->getValue();
    if (targetWidth <= this->length()) return new String(*this);
    
    const char *padStr = padding ? padding->c_str() : " ";
    int padLen = padding ? padding->length() : 1;
    int padCount = (targetWidth - this->length() + padLen - 1) / padLen;
    
    char *result = new char[targetWidth + 1];
    strcpy(result, this->c_str());
    char *dest = result + this->length();
    
    for (int i = 0; i < padCount; i++) {
        memcpy(dest, padStr, padLen);
        dest += padLen;
    }
    
    int remainingPad = targetWidth - this->length() - padCount * padLen;
    if (remainingPad > 0) {
        memcpy(dest, padStr, remainingPad);
        dest += remainingPad;
    }
    
    *dest = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

// 比较方法
Int *String::compareTo(String *b) noexcept {
    if (!b) return new Int(1);
    return new Int(strcmp(this->c_str(), b->c_str()));
}

Int *String::compareToIgnoreCase(String *b) noexcept {
    if (!b) return new Int(1);
    return new Int(strcasecmp(this->c_str(), b->c_str()));
}

// 重复和反转
String *String::repeat(Int *times) noexcept {
    if (!times) return nullptr;
    int count = times->getValue();
    if (count <= 0) return new String("");
    if (count == 1) return new String(*this);
    
    int len = this->length();
    int newLen = len * count;
    char *result = new char[newLen + 1];
    
    const char *str = this->c_str();
    char *dest = result;
    for (int i = 0; i < count; i++) {
        memcpy(dest, str, len);
        dest += len;
    }
    *dest = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::reverse() noexcept {
    int len = this->length();
    char *result = new char[len + 1];
    const char *str = this->c_str();
    
    for (int i = 0; i < len; i++) {
        result[i] = str[len - 1 - i];
    }
    result[len] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

// 数字转换
String *String::fromInt(Int *value) {
    if (!value) return nullptr;
    char buffer[32];
    snprintf(buffer, sizeof(buffer), "%d", value->getValue());
    return new String(buffer);
}

String *String::fromDouble(Double *value) {
    if (!value) return nullptr;
    char buffer[32];
    snprintf(buffer, sizeof(buffer), "%g", value->getValue());
    return new String(buffer);
}

Int *String::parseInt(Int *radix) noexcept {
    int base = radix ? radix->getValue() : 10;
    if (base < 2 || base > 36) return nullptr;
    
    const char *str = this->c_str();
    char *endptr;
    long value = strtol(str, &endptr, base);
    
    if (endptr == str || *endptr != '\0') return nullptr;
    return new Int(static_cast<int>(value));
}

Double *String::parseDouble() noexcept {
    const char *str = this->c_str();
    char *endptr;
    double value = strtod(str, &endptr);
    
    if (endptr == str || *endptr != '\0') return nullptr;
    return new Double(value);
}

// 简化的分割和连接方法
String **String::split(String *pattern, Int *limit) noexcept {
    if (!pattern) return nullptr;
    const char *str = this->c_str();
    const char *pat = pattern->c_str();
    int patLen = pattern->length();
    if (patLen == 0) return nullptr;
    
    int maxParts = limit ? limit->getValue() : 0;
    if (maxParts < 0) maxParts = 0;
    
    // 计算分割数
    int count = 1;
    const char *pos = str;
    while ((pos = strstr(pos, pat)) != nullptr) {
        count++;
        pos += patLen;
        if (maxParts > 0 && count >= maxParts) break;
    }
    
    String **result = new String*[count + 1];
    result[count] = nullptr;
    
    pos = str;
    const char *start = str;
    int i = 0;
    while ((pos = strstr(pos, pat)) != nullptr && (maxParts == 0 || i < maxParts - 1)) {
        int len = pos - start;
        char *part = new char[len + 1];
        memcpy(part, start, len);
        part[len] = '\0';
        result[i++] = new String(part);
        delete[] part;
        
        pos += patLen;
        start = pos;
    }
    
    result[i] = new String(start);
    return result;
}

Int *String::codeUnitAt(Int *index) noexcept {
    if (!index) return nullptr;
    int idx = index->getValue();
    if (idx < 0 || idx >= this->length()) return nullptr;
    return new Int(static_cast<unsigned char>((*this)[idx]));
}

// 简化的格式化和其他方法
String *String::format(String **args, Int *argCount) noexcept {
    if (!args || !argCount) return new String(*this);
    
    const char *str = this->c_str();
    int len = this->length();
    int n = argCount->getValue();
    
    // 预估结果字符串长度
    int resultLen = len;
    for (int i = 0; i < n; i++) {
        if (args[i]) {
            resultLen += args[i]->length();
        }
    }
    
    char *result = new char[resultLen * 2]; // 分配足够大的空间
    int pos = 0;
    int valueIndex = 0;
    
    for (int i = 0; i < len; i++) {
        if (str[i] == '{' && i + 1 < len && str[i + 1] == '}') {
            // 替换占位符
            if (valueIndex < n && args[valueIndex]) {
                const char *value = args[valueIndex]->c_str();
                int valueLen = args[valueIndex]->length();
                memcpy(result + pos, value, valueLen);
                pos += valueLen;
            }
            valueIndex++;
            i++; // 跳过 '}'
        } else {
            result[pos++] = str[i];
        }
    }
    result[pos] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::concat(String **strings, Int *count) noexcept {
    if (!strings || !count) return new String(*this);
    
    int n = count->getValue();
    if (n <= 0) return new String(*this);
    
    // 计算总长度
    int totalLen = this->length();
    for (int i = 0; i < n; i++) {
        if (strings[i]) {
            totalLen += strings[i]->length();
        }
    }
    
    // 创建结果字符串
    char *result = new char[totalLen + 1];
    int pos = 0;
    
    // 复制当前字符串
    memcpy(result, this->c_str(), this->length());
    pos += this->length();
    
    // 复制其他字符串
    for (int i = 0; i < n; i++) {
        if (strings[i]) {
            memcpy(result + pos, strings[i]->c_str(), strings[i]->length());
            pos += strings[i]->length();
        }
    }
    result[pos] = '\0';
    
    String *newStr = new String(result);
    delete[] result;
    return newStr;
}

String *String::interpolate(String **values, Int *count) noexcept {
    return format(values, count);
}

String *String::cppNew(const char *str, int length) noexcept {
    if (!str) return new String("");
    if (length < 0) length = strlen(str);
    char *copy = new char[length + 1];
    memcpy(copy, str, length);
    copy[length] = '\0';
    String *result = new String(copy);
    delete[] copy;
    return result;
}

// 添加cppToString函数的实现
String *cppToString(Object *obj) {
    if (obj) {
        return obj->toString();
    }
    return String::cppNew("null", sizeof("null") - 1);
}

// 添加缺少的虚函数实现
Bool* String::isOneByteString() noexcept { return new Bool(true); }
Int* String::getCodeUnitCount() noexcept { return new Int(length()); }
Bool* String::hasEscapeSequences() noexcept { return new Bool(false); }
String* String::normalize() noexcept { return new String(*this); }
String* String::removeNonPrintable() noexcept { return new String(*this); }
String* String::truncate(Int* maxLength) noexcept {
    if (!maxLength) return new String(*this);
    
    int maxLen = maxLength->getValue();
    if (maxLen < 0) maxLen = 0;
    
    if (this->length() <= maxLen) return new String(*this);
    
    char* result = new char[maxLen + 1];
    memcpy(result, this->c_str(), maxLen);
    result[maxLen] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::ellipsis(Int* maxLength) noexcept {
    if (!maxLength) return new String(*this);
    
    int maxLen = maxLength->getValue();
    if (maxLen < 3) maxLen = 3; // 至少需要3个字符来显示省略号
    
    if (this->length() <= maxLen) return new String(*this);
    
    int textLen = maxLen - 3; // 留出空间给省略号
    char* result = new char[maxLen + 1];
    memcpy(result, this->c_str(), textLen);
    result[textLen] = '.';
    result[textLen + 1] = '.';
    result[textLen + 2] = '.';
    result[maxLen] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::center(Int* width) noexcept {
    if (!width) return new String(*this);
    
    int targetWidth = width->getValue();
    if (targetWidth <= this->length()) return new String(*this);
    
    int padding = targetWidth - this->length();
    int leftPad = padding / 2;
    int rightPad = padding - leftPad;
    
    char* result = new char[targetWidth + 1];
    
    // 填充左侧空格
    for (int i = 0; i < leftPad; i++) {
        result[i] = ' ';
    }
    
    // 复制原字符串
    memcpy(result + leftPad, this->c_str(), this->length());
    
    // 填充右侧空格
    for (int i = 0; i < rightPad; i++) {
        result[leftPad + this->length() + i] = ' ';
    }
    
    result[targetWidth] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::slice(Int* start, Int* end) noexcept {
    if (!start) return new String(*this);
    
    int startPos = start->getValue();
    int endPos = end ? end->getValue() : this->length();
    
    // 处理负索引
    if (startPos < 0) startPos = this->length() + startPos;
    if (endPos < 0) endPos = this->length() + endPos;
    
    // 边界检查
    if (startPos < 0) startPos = 0;
    if (endPos > this->length()) endPos = this->length();
    if (startPos >= endPos) return new String("");
    
    int newLen = endPos - startPos;
    char* result = new char[newLen + 1];
    memcpy(result, this->c_str() + startPos, newLen);
    result[newLen] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::stripHtml() noexcept {
    const char* str = this->c_str();
    int len = this->length();
    
    char* result = new char[len + 1];
    int pos = 0;
    bool inTag = false;
    
    for (int i = 0; i < len; i++) {
        if (str[i] == '<') {
            inTag = true;
        } else if (str[i] == '>') {
            inTag = false;
        } else if (!inTag) {
            result[pos++] = str[i];
        }
    }
    
    result[pos] = '\0';
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::capitalize() noexcept {
    if (this->length() == 0) return new String("");
    
    const char* str = this->c_str();
    char* result = new char[this->length() + 1];
    
    result[0] = toupper(str[0]);
    for (int i = 1; i < this->length(); i++) {
        result[i] = str[i];
    }
    result[this->length()] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::decapitalize() noexcept {
    if (this->length() == 0) return new String("");
    
    const char* str = this->c_str();
    char* result = new char[this->length() + 1];
    
    result[0] = tolower(str[0]);
    for (int i = 1; i < this->length(); i++) {
        result[i] = str[i];
    }
    result[this->length()] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::swapCase() noexcept {
    const char* str = this->c_str();
    char* result = new char[this->length() + 1];
    
    for (int i = 0; i < this->length(); i++) {
        if (islower(str[i])) {
            result[i] = toupper(str[i]);
        } else if (isupper(str[i])) {
            result[i] = tolower(str[i]);
        } else {
            result[i] = str[i];
        }
    }
    result[this->length()] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::toTitleCase() noexcept {
    const char* str = this->c_str();
    char* result = new char[this->length() + 1];
    bool newWord = true;
    
    for (int i = 0; i < this->length(); i++) {
        if (isspace(str[i])) {
            result[i] = str[i];
            newWord = true;
        } else if (newWord) {
            result[i] = toupper(str[i]);
            newWord = false;
        } else {
            result[i] = tolower(str[i]);
        }
    }
    result[this->length()] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::toCamelCase() noexcept {
    const char* str = this->c_str();
    char* result = new char[this->length() + 1];
    int pos = 0;
    bool capitalize = false;
    
    for (int i = 0; i < this->length(); i++) {
        if (isalnum(str[i])) {
            if (capitalize) {
                result[pos++] = toupper(str[i]);
                capitalize = false;
            } else {
                result[pos++] = str[i];
            }
        } else {
            capitalize = true;
        }
    }
    
    result[pos] = '\0';
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::toSnakeCase() noexcept {
    const char* str = this->c_str();
    char* result = new char[this->length() * 2]; // 最坏情况：每个字符后面都有下划线
    int pos = 0;
    
    for (int i = 0; i < this->length(); i++) {
        if (isspace(str[i]) || str[i] == '-' || str[i] == '.') {
            result[pos++] = '_';
        } else if (isupper(str[i]) && i > 0 && !isupper(str[i-1]) && str[i-1] != '_') {
            result[pos++] = '_';
            result[pos++] = tolower(str[i]);
        } else {
            result[pos++] = tolower(str[i]);
        }
    }
    
    result[pos] = '\0';
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::toKebabCase() noexcept {
    const char* str = this->c_str();
    char* result = new char[this->length() * 2]; // 最坏情况：每个字符后面都有连字符
    int pos = 0;
    
    for (int i = 0; i < this->length(); i++) {
        if (isspace(str[i]) || str[i] == '_' || str[i] == '.') {
            result[pos++] = '-';
        } else if (isupper(str[i]) && i > 0 && !isupper(str[i-1]) && str[i-1] != '-') {
            result[pos++] = '-';
            result[pos++] = tolower(str[i]);
        } else {
            result[pos++] = tolower(str[i]);
        }
    }
    
    result[pos] = '\0';
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::join(String** strings, Int* count) noexcept {
    if (!strings || !count) return new String("");
    
    int n = count->getValue();
    if (n <= 0) return new String("");
    
    // 计算总长度
    int totalLen = 0;
    for (int i = 0; i < n; i++) {
        if (strings[i]) {
            if (i > 0) totalLen += this->length();
            totalLen += strings[i]->length();
        }
    }
    
    // 创建结果字符串
    char* result = new char[totalLen + 1];
    int pos = 0;
    
    for (int i = 0; i < n; i++) {
        if (strings[i]) {
            if (i > 0 && this->length() > 0) {
                memcpy(result + pos, this->c_str(), this->length());
                pos += this->length();
            }
            memcpy(result + pos, strings[i]->c_str(), strings[i]->length());
            pos += strings[i]->length();
        }
    }
    result[pos] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::escape() noexcept {
    const char* str = this->c_str();
    int len = this->length();
    
    // 计算转义后的长度
    int escapeLen = 0;
    for (int i = 0; i < len; i++) {
        char c = str[i];
        if (c == '"' || c == '\\' || c == '\n' || c == '\r' || c == '\t') {
            escapeLen += 2; // 需要两个字符: \和字符
        } else {
            escapeLen++;
        }
    }
    
    char* result = new char[escapeLen + 1];
    int pos = 0;
    
    for (int i = 0; i < len; i++) {
        char c = str[i];
        switch (c) {
            case '"':
                result[pos++] = '\\';
                result[pos++] = '"';
                break;
            case '\\':
                result[pos++] = '\\';
                result[pos++] = '\\';
                break;
            case '\n':
                result[pos++] = '\\';
                result[pos++] = 'n';
                break;
            case '\r':
                result[pos++] = '\\';
                result[pos++] = 'r';
                break;
            case '\t':
                result[pos++] = '\\';
                result[pos++] = 't';
                break;
            default:
                result[pos++] = c;
                break;
        }
    }
    result[pos] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

String* String::unescape() noexcept {
    const char* str = this->c_str();
    int len = this->length();
    
    char* result = new char[len + 1]; // 取消转义后长度一定不会超过原长度
    int pos = 0;
    
    for (int i = 0; i < len; i++) {
        if (str[i] == '\\' && i + 1 < len) {
            switch (str[i + 1]) {
                case '"':
                    result[pos++] = '"';
                    break;
                case '\\':
                    result[pos++] = '\\';
                    break;
                case 'n':
                    result[pos++] = '\n';
                    break;
                case 'r':
                    result[pos++] = '\r';
                    break;
                case 't':
                    result[pos++] = '\t';
                    break;
                default:
                    result[pos++] = str[i];
                    result[pos++] = str[i + 1];
                    break;
            }
            i++; // 跳过转义字符
        } else {
            result[pos++] = str[i];
        }
    }
    result[pos] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

Bool* String::matches(String* pattern) noexcept {
    if (!pattern) return new Bool(false);
    
    // 简单实现：仅支持*和?通配符
    const char* str = this->c_str();
    const char* pat = pattern->c_str();
    
    return new Bool(simpleMatch(str, pat));
}

// 简单的模式匹配辅助函数
bool String::simpleMatch(const char* str, const char* pattern) {
    if (*pattern == '\0') return *str == '\0';
    
    if (*pattern == '*') {
        // 星号可以匹配零个或多个字符
        while (*(pattern+1) == '*') pattern++; // 跳过连续的星号
        
        if (*(pattern+1) == '\0') return true; // 模式以*结尾，匹配任何剩余字符
        
        while (*str) {
            if (simpleMatch(str, pattern+1)) return true;
            str++;
        }
        return simpleMatch(str, pattern+1);
    }
    
    if (*pattern == '?' || *pattern == *str) {
        // 问号匹配任意单个字符，或者字符相等
        return simpleMatch(str+1, pattern+1);
    }
    
    return false;
}

String* String::extract(String* pattern) noexcept {
    if (!pattern) return new String("");
    
    // 简单实现：查找第一个匹配的子字符串
    const char* str = this->c_str();
    const char* pat = pattern->c_str();
    
    const char* found = strstr(str, pat);
    if (!found) return new String("");
    
    int patLen = pattern->length();
    char* result = new char[patLen + 1];
    memcpy(result, found, patLen);
    result[patLen] = '\0';
    
    String* newStr = new String(result);
    delete[] result;
    return newStr;
}

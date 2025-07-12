#include "string.h"
#include "num.h"
#include <cstdlib>
#include <cstring>
#include <cctype>

// ==================== StringPoolEntry 实现 ====================

StringPoolEntry::StringPoolEntry() : data(NULL), length(0), refCount(0), inUse(false) {}

// ==================== StringPool 静态成员初始化 ====================

StringPoolEntry StringPool::pool[MAX_POOL_SIZE];
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
    if (!str) return NULL;
    if (length < 0) length = 0;
    
    char *copy = new char[length + 1];
    for (int i = 0; i < length; i++) {
        copy[i] = str[i];
    }
    copy[length] = '\0';
    return copy;
}

StringPoolEntry *StringPool::intern(const char *str) {
    if (!str) {
        static StringPoolEntry emptyEntry;
        if (!emptyEntry.inUse) {
            emptyEntry.data = copyString("", 0);
            emptyEntry.length = 0;
            emptyEntry.refCount = 1;
            emptyEntry.inUse = true;
        } else {
            emptyEntry.refCount++;
        }
        return &emptyEntry;
    }
    
    int length = getStringLength(str);
    
    // 查找是否已经存在
    for (int i = 0; i < poolSize && i < MAX_POOL_SIZE; i++) {
        if (pool[i].inUse && stringEqual(pool[i].data, str, pool[i].length, length)) {
            pool[i].refCount++;
            return &pool[i];
        }
    }
    
    // 查找空闲位置
    for (int i = 0; i < MAX_POOL_SIZE; i++) {
        if (!pool[i].inUse) {
            pool[i].data = copyString(str, length);
            if (!pool[i].data) {
                return NULL; // 内存分配失败
            }
            pool[i].length = length;
            pool[i].refCount = 1;
            pool[i].inUse = true;
            if (i >= poolSize) {
                poolSize = i + 1;
            }
            return &pool[i];
        }
    }
    
    // 池已满，返回新的临时条目
    StringPoolEntry *temp = new StringPoolEntry();
    temp->data = copyString(str, length);
    if (!temp->data) {
        delete temp;
        return NULL; // 内存分配失败
    }
    temp->length = length;
    temp->refCount = 1;
    temp->inUse = true;
    return temp;
}

void StringPool::release(StringPoolEntry *entry) {
    if (!entry) return;
    
    entry->refCount--;
    if (entry->refCount <= 0) {
        delete[] entry->data;
        entry->data = NULL;
        entry->length = 0;
        entry->inUse = false;
        
        // 检查是否是池外分配的
        bool isPoolEntry = false;
        for (int i = 0; i < MAX_POOL_SIZE; i++) {
            if (&pool[i] == entry) {
                isPoolEntry = true;
                break;
            }
        }
        
        if (!isPoolEntry) {
            delete entry;
        }
    }
}

int StringPool::getPoolSize() {
    return poolSize;
}

int StringPool::getActiveEntries() {
    int active = 0;
    for (int i = 0; i < poolSize; i++) {
        if (pool[i].inUse) {
            active++;
        }
    }
    return active;
}

// ==================== String 实例方法实现 ====================

String::String() {
    poolEntry = StringPool::intern("");
}

String::String(const char *str) {
    poolEntry = StringPool::intern(str ? str : "");
}

String::String(const String &other) {
    poolEntry = other.poolEntry;
    if (poolEntry) {
        poolEntry->refCount++;
    }
}

String::~String() {
    StringPool::release(poolEntry);
}


Type* String::cppGet_runtimeType(Object* a){
    return Type::getStringType();
} 

String* String::toString(Object* obj){
    return (String*)obj;
} 

 Int* String::hashCode(Object* obj){
    return new Int(reinterpret_cast<intptr_t>(((String*)obj)->poolEntry));
 }                         
// ==================== 静态方法 - 对齐Dart String ====================

String &String::operator=(const String &other) {
    if (this != &other) {
        StringPool::release(poolEntry);
        poolEntry = other.poolEntry;
        if (poolEntry) {
            poolEntry->refCount++;
        }
    }
    return *this;
}

String &String::operator=(const char *str) {
    StringPool::release(poolEntry);
    poolEntry = StringPool::intern(str ? str : "");
    return *this;
}

const char *String::c_str() const {
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
String *String::cpp_add(String *a, String *b) {
    if (!a || !b) return new String("");
    
    int newLength = a->length() + b->length();
    char *newData = new char[newLength + 1];
    
    // 复制第一个字符串
    for (int i = 0; i < a->length(); i++) {
        newData[i] = a->c_str()[i];
    }
    
    // 复制第二个字符串
    for (int i = 0; i < b->length(); i++) {
        newData[a->length() + i] = b->c_str()[i];
    }
    
    newData[newLength] = '\0';
    String *result = new String(newData);
    delete[] newData;
    return result;
}

Bool *String::cpp_equals(String *a, String *b) {
    if (!a || !b) return new Bool(false);
    if (a->sharesSameData(*b)) return new Bool(true);
    
    return new Bool(StringPool::stringEqual(a->c_str(), b->c_str(), a->length(), b->length()));
}

Bool *String::cpp_greaterThan(String *a, String *b) {
    if (!a || !b) return new Bool(false);
    
    const char *str1 = a->c_str();
    const char *str2 = b->c_str();
    int len1 = a->length();
    int len2 = b->length();
    int minLen = len1 < len2 ? len1 : len2;
    
    for (int i = 0; i < minLen; i++) {
        if (str1[i] > str2[i]) return new Bool(true);
        if (str1[i] < str2[i]) return new Bool(false);
    }
    
    return new Bool(len1 > len2);
}

Bool *String::cpp_lessThan(String *a, String *b) {
    if (!a || !b) return new Bool(false);
    
    const char *str1 = a->c_str();
    const char *str2 = b->c_str();
    int len1 = a->length();
    int len2 = b->length();
    int minLen = len1 < len2 ? len1 : len2;
    
    for (int i = 0; i < minLen; i++) {
        if (str1[i] < str2[i]) return new Bool(true);
        if (str1[i] > str2[i]) return new Bool(false);
    }
    
    return new Bool(len1 < len2);
}

Bool *String::cpp_greaterThanOrEqual(String *a, String *b) {
    Bool *equals = cpp_equals(a, b);
    Bool *greater = cpp_greaterThan(a, b);
    Bool *result = new Bool(equals->m_data || greater->m_data);
    delete equals;
    delete greater;
    return result;
}

Bool *String::cpp_lessThanOrEqual(String *a, String *b) {
    Bool *equals = cpp_equals(a, b);
    Bool *less = cpp_lessThan(a, b);
    Bool *result = new Bool(equals->m_data || less->m_data);
    delete equals;
    delete less;
    return result;
}

String *String::cpp_subscript(String *str, Int *index) {
    if (!str || !index || index->getInt() < 0 || index->getInt() >= str->length()) {
        return new String("");
    }
    
    char singleChar[2] = {str->c_str()[index->getInt()], '\0'};
    return new String(singleChar);
}

// 基本属性和检查方法
Int *String::getLength(String *str) {
    return new Int(str ? str->length() : 0);
}

Bool *String::isEmpty(String *str) {
    return new Bool(!str || str->length() == 0);
}

Bool *String::isNotEmpty(String *str) {
    return new Bool(str && str->length() > 0);
}

// Getter方法
Int *String::cppGet_length(String *str) {
    return getLength(str);
}

Bool *String::cppGet_isEmpty(String *str) {
    return isEmpty(str);
}

Bool *String::cppGet_isNotEmpty(String *str) {
    return isNotEmpty(str);
}

// 查找方法
Bool *String::contains(String *str, String *pattern) {
    if (!str || !pattern) return new Bool(false);
    if (pattern->length() == 0) return new Bool(true);
    if (pattern->length() > str->length()) return new Bool(false);
    
    const char *haystack = str->c_str();
    const char *needle = pattern->c_str();
    int haystackLen = str->length();
    int needleLen = pattern->length();
    
    for (int i = 0; i <= haystackLen - needleLen; i++) {
        bool found = true;
        for (int j = 0; j < needleLen; j++) {
            if (haystack[i + j] != needle[j]) {
                found = false;
                break;
            }
        }
        if (found) return new Bool(true);
    }
    
    return new Bool(false);
}

Bool *String::startsWith(String *str, String *pattern) {
    if (!str || !pattern) return new Bool(false);
    if (pattern->length() > str->length()) return new Bool(false);
    
    const char *text = str->c_str();
    const char *prefix = pattern->c_str();
    
    for (int i = 0; i < pattern->length(); i++) {
        if (text[i] != prefix[i]) return new Bool(false);
    }
    
    return new Bool(true);
}

Bool *String::endsWith(String *str, String *pattern) {
    if (!str || !pattern) return new Bool(false);
    if (pattern->length() > str->length()) return new Bool(false);
    
    const char *text = str->c_str();
    const char *suffix = pattern->c_str();
    int offset = str->length() - pattern->length();
    
    for (int i = 0; i < pattern->length(); i++) {
        if (text[offset + i] != suffix[i]) return new Bool(false);
    }
    
    return new Bool(true);
}

Int *String::indexOf(String *str, String *pattern, Int *start) {
    if (!str || !pattern) return new Int(-1);
    
    int startPos = start ? start->getInt() : 0;
    if (startPos < 0) startPos = 0;
    if (startPos >= str->length()) return new Int(-1);
    
    const char *haystack = str->c_str();
    const char *needle = pattern->c_str();
    int haystackLen = str->length();
    int needleLen = pattern->length();
    
    for (int i = startPos; i <= haystackLen - needleLen; i++) {
        bool found = true;
        for (int j = 0; j < needleLen; j++) {
            if (haystack[i + j] != needle[j]) {
                found = false;
                break;
            }
        }
        if (found) return new Int(i);
    }
    
    return new Int(-1);
}

Int *String::lastIndexOf(String *str, String *pattern, Int *start) {
    if (!str || !pattern) return new Int(-1);
    
    int startPos = start ? start->getInt() : str->length() - pattern->length();
    if (startPos < 0) return new Int(-1);
    if (startPos > str->length() - pattern->length()) {
        startPos = str->length() - pattern->length();
    }
    
    const char *haystack = str->c_str();
    const char *needle = pattern->c_str();
    int needleLen = pattern->length();
    
    for (int i = startPos; i >= 0; i--) {
        bool found = true;
        for (int j = 0; j < needleLen; j++) {
            if (haystack[i + j] != needle[j]) {
                found = false;
                break;
            }
        }
        if (found) return new Int(i);
    }
    
    return new Int(-1);
}

// 子字符串方法
String *String::substring(String *str, Int *start, Int *end) {
    if (!str || !start) return new String("");
    
    int startPos = start->getInt();
    int endPos = end ? end->getInt() : str->length();
    
    if (startPos < 0) startPos = 0;
    if (endPos > str->length()) endPos = str->length();
    if (startPos >= endPos) return new String("");
    
    int newLength = endPos - startPos;
    char *newData = new char[newLength + 1];
    const char *source = str->c_str();
    
    for (int i = 0; i < newLength; i++) {
        newData[i] = source[startPos + i];
    }
    newData[newLength] = '\0';
    
    String *result = new String(newData);
    delete[] newData;
    return result;
}

String *String::substr(String *str, Int *start, Int *length) {
    if (!str || !start) return new String("");
    
    int endPos = length ? start->getInt() + length->getInt() : str->length();
    Int *end = new Int(endPos);
    String *result = substring(str, start, end);
    delete end;
    return result;
}

// 修剪方法
String *String::trim(String *str) {
    if (!str) return new String("");
    
    const char *data = str->c_str();
    int len = str->length();
    int start = 0;
    int end = len - 1;
    
    // 找到第一个非空白字符
    while (start < len && (data[start] == ' ' || data[start] == '\t' || 
                          data[start] == '\n' || data[start] == '\r')) {
        start++;
    }
    
    // 找到最后一个非空白字符
    while (end >= start && (data[end] == ' ' || data[end] == '\t' || 
                           data[end] == '\n' || data[end] == '\r')) {
        end--;
    }
    
    if (start > end) return new String("");
    
    Int *startInt = new Int(start);
    Int *endInt = new Int(end + 1);
    String *result = substring(str, startInt, endInt);
    delete startInt;
    delete endInt;
    return result;
}

String *String::trimLeft(String *str) {
    if (!str) return new String("");
    
    const char *data = str->c_str();
    int len = str->length();
    int start = 0;
    
    while (start < len && (data[start] == ' ' || data[start] == '\t' || 
                          data[start] == '\n' || data[start] == '\r')) {
        start++;
    }
    
    Int *startInt = new Int(start);
    String *result = substring(str, startInt, NULL);
    delete startInt;
    return result;
}

String *String::trimRight(String *str) {
    if (!str) return new String("");
    
    const char *data = str->c_str();
    int len = str->length();
    int end = len - 1;
    
    while (end >= 0 && (data[end] == ' ' || data[end] == '\t' || 
                       data[end] == '\n' || data[end] == '\r')) {
        end--;
    }
    
    Int *startInt = new Int(0);
    Int *endInt = new Int(end + 1);
    String *result = substring(str, startInt, endInt);
    delete startInt;
    delete endInt;
    return result;
}

// 大小写转换
String *String::toLowerCase(String *str) {
    if (!str) return new String("");
    
    int len = str->length();
    char *newData = new char[len + 1];
    const char *source = str->c_str();
    
    for (int i = 0; i < len; i++) {
        newData[i] = (char)std::tolower(source[i]);
    }
    newData[len] = '\0';
    
    String *result = new String(newData);
    delete[] newData;
    return result;
}

String *String::toUpperCase(String *str) {
    if (!str) return new String("");
    
    int len = str->length();
    char *newData = new char[len + 1];
    const char *source = str->c_str();
    
    for (int i = 0; i < len; i++) {
        newData[i] = (char)std::toupper(source[i]);
    }
    newData[len] = '\0';
    
    String *result = new String(newData);
    delete[] newData;
    return result;
}

// 替换方法
String *String::replaceAll(String *str, String *from, String *to) {
    if (!str || !from || !to || from->length() == 0) return new String(str->c_str());
    
    const char *source = str->c_str();
    const char *fromStr = from->c_str();
    const char *toStr = to->c_str();
    int sourceLen = str->length();
    int fromLen = from->length();
    int toLen = to->length();
    
    // 估算结果大小
    int maxResultLen = sourceLen * 2; // 简单估算
    char *result = new char[maxResultLen + 1];
    int resultPos = 0;
    int sourcePos = 0;
    
    while (sourcePos < sourceLen) {
        bool found = true;
        if (sourcePos <= sourceLen - fromLen) {
            for (int i = 0; i < fromLen; i++) {
                if (source[sourcePos + i] != fromStr[i]) {
                    found = false;
                    break;
                }
            }
        } else {
            found = false;
        }
        
        if (found) {
            // 复制替换字符串
            for (int i = 0; i < toLen && resultPos < maxResultLen; i++) {
                result[resultPos++] = toStr[i];
            }
            sourcePos += fromLen;
        } else {
            // 复制单个字符
            if (resultPos < maxResultLen) {
                result[resultPos++] = source[sourcePos];
            }
            sourcePos++;
        }
    }
    
    result[resultPos] = '\0';
    String *resultStr = new String(result);
    delete[] result;
    return resultStr;
}

String *String::replaceFirst(String *str, String *from, String *to) {
    if (!str || !from || !to) return new String(str->c_str());
    
    Int *index = indexOf(str, from, NULL);
    if (index->getInt() == -1) {
        delete index;
        return new String(str->c_str());
    }
    
    // 分割字符串并重新组合
    Int *start = new Int(0);
    Int *mid = new Int(index->getInt());
    Int *end = new Int(index->getInt() + from->length());
    
    String *part1 = substring(str, start, mid);
    String *part2 = substring(str, end, NULL);
    
    String *temp = cpp_add(part1, to);
    String *result = cpp_add(temp, part2);
    
    delete index;
    delete start;
    delete mid;
    delete end;
    delete part1;
    delete part2;
    delete temp;
    
    return result;
}

String *String::replaceRange(String *str, Int *start, Int *end, String *replacement) {
    if (!str || !start || !end || !replacement) return new String(str->c_str());
    
    Int *zero = new Int(0);
    String *part1 = substring(str, zero, start);
    String *part2 = substring(str, end, NULL);
    
    String *temp = cpp_add(part1, replacement);
    String *result = cpp_add(temp, part2);
    
    delete zero;
    delete part1;
    delete part2;
    delete temp;
    
    return result;
}

// 填充方法
String *String::padLeft(String *str, Int *width, String *padding) {
    if (!str || !width) return new String(str->c_str());
    
    String *pad = padding ? padding : new String(" ");
    int targetWidth = width->getInt();
    int currentWidth = str->length();
    
    if (currentWidth >= targetWidth) {
        if (!padding) delete pad;
        return new String(str->c_str());
    }
    
    int padNeeded = targetWidth - currentWidth;
    int padLen = pad->length();
    if (padLen == 0) {
        if (!padding) delete pad;
        return new String(str->c_str());
    }
    
    char *result = new char[targetWidth + 1];
    int pos = 0;
    
    // 添加填充
    for (int i = 0; i < padNeeded; i++) {
        result[pos++] = pad->c_str()[i % padLen];
    }
    
    // 添加原字符串
    const char *source = str->c_str();
    for (int i = 0; i < currentWidth; i++) {
        result[pos++] = source[i];
    }
    
    result[targetWidth] = '\0';
    String *resultStr = new String(result);
    delete[] result;
    if (!padding) delete pad;
    return resultStr;
}

String *String::padRight(String *str, Int *width, String *padding) {
    if (!str || !width) return new String(str->c_str());
    
    String *pad = padding ? padding : new String(" ");
    int targetWidth = width->getInt();
    int currentWidth = str->length();
    
    if (currentWidth >= targetWidth) {
        if (!padding) delete pad;
        return new String(str->c_str());
    }
    
    int padNeeded = targetWidth - currentWidth;
    int padLen = pad->length();
    if (padLen == 0) {
        if (!padding) delete pad;
        return new String(str->c_str());
    }
    
    char *result = new char[targetWidth + 1];
    int pos = 0;
    
    // 添加原字符串
    const char *source = str->c_str();
    for (int i = 0; i < currentWidth; i++) {
        result[pos++] = source[i];
    }
    
    // 添加填充
    for (int i = 0; i < padNeeded; i++) {
        result[pos++] = pad->c_str()[i % padLen];
    }
    
    result[targetWidth] = '\0';
    String *resultStr = new String(result);
    delete[] result;
    if (!padding) delete pad;
    return resultStr;
}

// 比较方法
Int *String::compareTo(String *a, String *b) {
    if (!a || !b) return new Int(0);
    
    const char *str1 = a->c_str();
    const char *str2 = b->c_str();
    int len1 = a->length();
    int len2 = b->length();
    int minLen = len1 < len2 ? len1 : len2;
    
    for (int i = 0; i < minLen; i++) {
        if (str1[i] < str2[i]) return new Int(-1);
        if (str1[i] > str2[i]) return new Int(1);
    }
    
    if (len1 < len2) return new Int(-1);
    if (len1 > len2) return new Int(1);
    return new Int(0);
}

Int *String::compareToIgnoreCase(String *a, String *b) {
    if (!a || !b) return new Int(0);
    
    String *lower1 = toLowerCase(a);
    String *lower2 = toLowerCase(b);
    Int *result = compareTo(lower1, lower2);
    delete lower1;
    delete lower2;
    return result;
}

// 重复和反转
String *String::repeat(String *str, Int *times) {
    if (!str || !times || times->getInt() <= 0) return new String("");
    
    int repeatCount = times->getInt();
    int sourceLen = str->length();
    int totalLen = sourceLen * repeatCount;
    
    char *result = new char[totalLen + 1];
    const char *source = str->c_str();
    
    for (int i = 0; i < repeatCount; i++) {
        for (int j = 0; j < sourceLen; j++) {
            result[i * sourceLen + j] = source[j];
        }
    }
    
    result[totalLen] = '\0';
    String *resultStr = new String(result);
    delete[] result;
    return resultStr;
}

String *String::reverse(String *str) {
    if (!str) return new String("");
    
    int len = str->length();
    char *result = new char[len + 1];
    const char *source = str->c_str();
    
    for (int i = 0; i < len; i++) {
        result[i] = source[len - 1 - i];
    }
    result[len] = '\0';
    
    String *resultStr = new String(result);
    delete[] result;
    return resultStr;
}

// 数字转换
String *String::fromInt(Int *value) {
    if (!value) return new String("0");
    
    int val = value->getInt();
    bool negative = val < 0;
    if (negative) val = -val;
    
    char buffer[32];
    int pos = 0;
    
    if (val == 0) {
        buffer[pos++] = '0';
    } else {
        while (val > 0) {
            buffer[pos++] = '0' + (val % 10);
            val /= 10;
        }
    }
    
    if (negative) {
        buffer[pos++] = '-';
    }
    
    // 反转字符串
    char *result = new char[pos + 1];
    for (int i = 0; i < pos; i++) {
        result[i] = buffer[pos - 1 - i];
    }
    result[pos] = '\0';
    
    String *resultStr = new String(result);
    delete[] result;
    return resultStr;
}

String *String::fromDouble(Double *value) {
    if (!value) return new String("0.0");
    
    // 简化的浮点数转字符串实现
    double val = value->getDouble();
    bool negative = val < 0;
    if (negative) val = -val;
    
    int intPart = (int)val;
    double fracPart = val - intPart;
    
    String *intStr = fromInt(new Int(negative ? -intPart : intPart));
    
    if (fracPart == 0.0) {
        return intStr;
    }
    
    // 简单处理小数部分
    char fracBuffer[32];
    fracBuffer[0] = '.';
    int fracPos = 1;
    
    for (int i = 0; i < 6; i++) { // 最多6位小数
        fracPart *= 10;
        int digit = (int)fracPart;
        fracBuffer[fracPos++] = '0' + digit;
        fracPart -= digit;
        if (fracPart < 0.000001) break; // 精度限制
    }
    
    fracBuffer[fracPos] = '\0';
    String *fracStr = new String(fracBuffer);
    String *result = cpp_add(intStr, fracStr);
    
    delete intStr;
    delete fracStr;
    return result;
}

Int *String::parseInt(String *str, Int *radix) {
    if (!str) return new Int(0);
    
    int base = radix ? radix->getInt() : 10;
    if (base < 2 || base > 36) return new Int(0);
    
    const char *data = str->c_str();
    int len = str->length();
    int pos = 0;
    bool negative = false;
    int result = 0;
    
    // 跳过空白
    while (pos < len && (data[pos] == ' ' || data[pos] == '\t')) {
        pos++;
    }
    
    // 处理符号
    if (pos < len) {
        if (data[pos] == '-') {
            negative = true;
            pos++;
        } else if (data[pos] == '+') {
            pos++;
        }
    }
    
    // 解析数字
    while (pos < len) {
        char c = data[pos];
        int digit = -1;
        
        if (c >= '0' && c <= '9') {
            digit = c - '0';
        } else if (c >= 'a' && c <= 'z') {
            digit = c - 'a' + 10;
        } else if (c >= 'A' && c <= 'Z') {
            digit = c - 'A' + 10;
        }
        
        if (digit < 0 || digit >= base) break;
        
        result = result * base + digit;
        pos++;
    }
    
    return new Int(negative ? -result : result);
}

Double *String::parseDouble(String *str) {
    if (!str) return new Double(0.0);
    
    const char *data = str->c_str();
    int len = str->length();
    int pos = 0;
    bool negative = false;
    double result = 0.0;
    
    // 跳过空白
    while (pos < len && (data[pos] == ' ' || data[pos] == '\t')) {
        pos++;
    }
    
    // 处理符号
    if (pos < len) {
        if (data[pos] == '-') {
            negative = true;
            pos++;
        } else if (data[pos] == '+') {
            pos++;
        }
    }
    
    // 解析整数部分
    while (pos < len && data[pos] >= '0' && data[pos] <= '9') {
        result = result * 10.0 + (data[pos] - '0');
        pos++;
    }
    
    // 解析小数部分
    if (pos < len && data[pos] == '.') {
        pos++;
        double fraction = 0.1;
        while (pos < len && data[pos] >= '0' && data[pos] <= '9') {
            result += (data[pos] - '0') * fraction;
            fraction *= 0.1;
            pos++;
        }
    }
    
    return new Double(negative ? -result : result);
}

// 简化的分割和连接方法
String **String::split(String *str, String *pattern, Int *limit) {
    // 简化实现：返回包含原字符串的单元素数组
    if (!str) return NULL;
    
    String **result = new String*[2];
    result[0] = new String(str->c_str());
    result[1] = NULL; // 结束标记
    return result;
}

String *String::join(String **strings, Int *count, String *separator) {
    if (!strings || !count || count->getInt() <= 0) return new String("");
    
    String *sep = separator ? separator : new String("");
    String *result = new String(strings[0]->c_str());
    
    for (int i = 1; i < count->getInt(); i++) {
        if (strings[i]) {
            String *temp1 = cpp_add(result, sep);
            String *temp2 = cpp_add(temp1, strings[i]);
            delete result;
            delete temp1;
            result = temp2;
        }
    }
    
    if (!separator) delete sep;
    return result;
}

// 其他辅助方法 - 简化实现
String *String::fromCharCode(Int *charCode) {
    if (!charCode) return new String("");
    
    char c = (char)charCode->getInt();
    char buffer[2] = {c, '\0'};
    return new String(buffer);
}

String *String::fromCharCodes(Int **charCodes, Int *length) {
    if (!charCodes || !length) return new String("");
    
    int len = length->getInt();
    char *buffer = new char[len + 1];
    
    for (int i = 0; i < len; i++) {
        buffer[i] = charCodes[i] ? (char)charCodes[i]->getInt() : '\0';
    }
    buffer[len] = '\0';
    
    String *result = new String(buffer);
    delete[] buffer;
    return result;
}

Int *String::codeUnitAt(String *str, Int *index) {
    if (!str || !index || index->getInt() < 0 || index->getInt() >= str->length()) {
        return new Int(0);
    }
    
    return new Int((int)str->c_str()[index->getInt()]);
}

// 简化的格式化和其他方法
String *String::format(String *template_str, String **args, Int *argCount) {
    // 简化实现：直接返回模板字符串
    return template_str ? new String(template_str->c_str()) : new String("");
}

String *String::escape(String *str) {
    return str ? new String(str->c_str()) : new String("");
}

String *String::unescape(String *str) {
    return str ? new String(str->c_str()) : new String("");
}

Bool *String::matches(String *str, String *pattern) {
    return contains(str, pattern);
}

String *String::extract(String *str, String *pattern) {
    Bool *match = contains(str, pattern);
    String *result = match->m_data ? new String(pattern->c_str()) : new String("");
    delete match;
    return result;
}

String *String::concat(String **strings, Int *count) {
    return join(strings, count, NULL);
}

String *String::interpolate(String *template_str, String **values, Int *count) {
    return format(template_str, values, count);
} 
// ==================== cppNew 方法实现 ====================

String *String::cppNew(const char *str) {
    return new String(str);
}

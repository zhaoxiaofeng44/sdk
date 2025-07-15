#include "api.h"
#include <cstring>  // 用于strcat函数

// 创建指针数组
CppPointerArray* CppApi::cppCreatePointerArray(Int* length) {
    if (length == NULL) {
        return NULL;
    }
    
    int len = length->getValue();
    if (len <= 0) {
        return NULL;
    }
    
    return new CppPointerArray(len);
}

// 获取指针数组长度
Int* CppApi::cppGetPointerArrayLength(CppPointerArray* array) {
    if (array == NULL) {
        return NULL;
    }
    
    return Int::cppNew(array->length);
}

// 获取指针数组项
Object* CppApi::cppGetPointerArrayItem(CppPointerArray* array, Int* index) {
    if (array == NULL || index == NULL) {
        return NULL;
    }
    
    int idx = index->getValue();
    if (idx < 0 || idx >= array->length) {
        return NULL;
    }
    
    return array->data[idx];
}

// 设置指针数组项
void CppApi::cppSetPointerArrayItem(CppPointerArray* array, Int* index, Object* value) {
    if (array == NULL || index == NULL) {
        return;
    }
    
    int idx = index->getValue();
    if (idx < 0 || idx >= array->length) {
        return;
    }
    
    array->data[idx] = value;
}

// 创建字节数组
CppByteArray* CppApi::cppCreateByteArray(Int* length) {
    if (length == NULL) {
        return NULL;
    }
    
    int len = length->getValue();
    if (len <= 0) {
        return NULL;
    }
    
    return new CppByteArray(len);
}

// 获取字节数组长度
Int* CppApi::cppGetByteArrayLength(CppByteArray* array) {
    if (array == NULL) {
        return NULL;
    }
    
    return Int::cppNew(array->length);
}

// 获取字节数组项
Int* CppApi::cppGetByteArrayItem(CppByteArray* array, Int* index) {
    if (array == NULL || index == NULL) {
        return NULL;
    }
    
    int idx = index->getValue();
    if (idx < 0 || idx >= array->length) {
        return NULL;
    }
    
    return Int::cppNew(array->data[idx]);
}

// 设置字节数组项
void CppApi::cppSetByteArrayItem(CppByteArray* array, Int* index, Int* value) {
    if (array == NULL || index == NULL || value == NULL) {
        return;
    }
    
    int idx = index->getValue();
    if (idx < 0 || idx >= array->length) {
        return;
    }
    
    array->data[idx] = static_cast<uint8_t>(value->getValue());
}

// 连接字符串列表
String* CppApi::cppJoinListString(CppPointerArray* array, String* separator) {
    if (array == NULL) {
        return String::cppNew("");
    }
    
    // 获取分隔符字符串，如果为NULL则使用空字符串
    const char* sep = "";
    if (separator != NULL) {
        sep = separator->c_str();
    }
    
    // 计算总长度
    int totalLength = 0;
    for (int i = 0; i < array->length; i++) {
        Object* item = array->data[i];
        if (item != NULL) {
            String* str = Object::toString(item);
            if (str != NULL) {
                totalLength += str->length();
            }
        }
        
        // 添加分隔符长度（除了最后一个元素）
        if (i < array->length - 1 && separator != NULL) {
            totalLength += separator->length();
        }
    }
    
    // 创建结果字符串
    char* result = new char[totalLength + 1];
    result[0] = '\0';
    
    for (int i = 0; i < array->length; i++) {
        Object* item = array->data[i];
        if (item != NULL) {
            String* str = Object::toString(item);
            if (str != NULL) {
                strcat(result, str->c_str());
            }
        }
        
        // 添加分隔符（除了最后一个元素）
        if (i < array->length - 1 && separator != NULL) {
            strcat(result, sep);
        }
    }
    
    String* resultStr = String::cppNew(result);
    delete[] result;
    
    return resultStr;
}

// 获取布尔值
bool CppApi::cppBoolValue(Bool* value) {
    if (value == NULL) {
        return false;
    }
    
    return value->getValue();
}

bool CppApi::cppBoolValue(bool value) {
    return value;
}

String* CppApi::getCurrentStackTrace() {
    return String::cppNew("");
}
#include "api.h"
#include <cstring>  // 用于strcat函数

// 创建指针数组
CppUserData* CppApi::cppCreatePointerArray(Int* length) {
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
Int* CppApi::cppGetPointerArrayLength(CppUserData* array) {
    if (array == NULL) {
        return NULL;
    }
    
    return Int::cppNew(reinterpret_cast<CppPointerArray*>(array)->length);
}

// 获取指针数组项
Object* CppApi::cppGetPointerArrayItem(CppUserData* array, Int* index) {
    if (array == NULL || index == NULL) {
        return NULL;
    }
    
    CppPointerArray* ptrArray = reinterpret_cast<CppPointerArray*>(array);
    int idx = index->getValue();
    if (idx < 0 || idx >= ptrArray->length) {
        return NULL;
    }
    
    return ptrArray->data[idx];
}

// 设置指针数组项
void CppApi::cppSetPointerArrayItem(CppUserData* array, Int* index, Object* value) {
    if (array == NULL || index == NULL) {
        return;
    }
    CppPointerArray* ptrArray = reinterpret_cast<CppPointerArray*>(array);
    int idx = index->getValue();
    if (idx < 0 || idx >= ptrArray->length) {
        return;
    }
    
    ptrArray->data[idx] = value;
}

// 创建字节数组
CppUserData* CppApi::cppCreateByteArray(Int* length) {
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
Int* CppApi::cppGetByteArrayLength(CppUserData* array) {
    if (array == NULL) {
        return NULL;
    }
    
    return Int::cppNew(reinterpret_cast<CppByteArray*>(array)->length);
}

// 获取字节数组项
Int* CppApi::cppGetByteArrayItem(CppUserData* array, Int* index) {
    if (array == NULL || index == NULL) {
        return NULL;
    }
    
    CppByteArray* byteArray = reinterpret_cast<CppByteArray*>(array);
    int idx = index->getValue();
    if (idx < 0 || idx >= byteArray->length) {
        return NULL;
    }
    
    return Int::cppNew(byteArray->data[idx]);
}

// 设置字节数组项
void CppApi::cppSetByteArrayItem(CppUserData* array, Int* index, Int* value) {
    if (array == NULL || index == NULL || value == NULL) {
        return;
    }
    
    CppByteArray* byteArray = reinterpret_cast<CppByteArray*>(array);
    int idx = index->getValue();
    if (idx < 0 || idx >= byteArray->length) {
        return;
    }
    
    byteArray->data[idx] = static_cast<uint8_t>(value->getValue());
}

// 连接字符串列表
String* CppApi::cppJoinListString(CppUserData* array, String* separator) {
    if (array == NULL) {
        return String::cppNew("");
    }
    
    // 获取分隔符字符串，如果为NULL则使用空字符串
    const char* sep = "";
    if (separator != NULL) {
        sep = separator->c_str();
    }
    
    CppPointerArray* ptrArray = reinterpret_cast<CppPointerArray*>(array);
    // 计算总长度
    int totalLength = 0;
    for (int i = 0; i < ptrArray->length; i++) {
        Object* item = ptrArray->data[i];
        if (item != NULL) {
            String* str = Object::toString(item);
            if (str != NULL) {
                totalLength += str->length();
            }
        }
        
        // 添加分隔符长度（除了最后一个元素）
        if (i < ptrArray->length - 1 && separator != NULL) {
            totalLength += separator->length();
        }
    }
    
    // 创建结果字符串
    char* result = new char[totalLength + 1];
    result[0] = '\0';
    
    for (int i = 0; i < ptrArray->length; i++) {
        Object* item = ptrArray->data[i];
        if (item != NULL) {
            String* str = Object::toString(item);
            if (str != NULL) {
                strcat(result, str->c_str());
            }
        }
        
        // 添加分隔符（除了最后一个元素）
        if (i < ptrArray->length - 1 && separator != NULL) {
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
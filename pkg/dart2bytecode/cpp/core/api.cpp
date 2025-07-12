#include "api.h"
#include <cstring>  // 用于strcat函数

// 创建指针数组
void** CppApi::cppCreatePointerArray(Int* length) {
    if (length == NULL) {
        return NULL;
    }
    
    int len = length->getValue();
    if (len <= 0) {
        return NULL;
    }
    
    // 分配内存并初始化为NULL
    void** array = new void*[len];
    //不初始化
    // for (int i = 0; i < len; i++) {
    //     array[i] = NULL;
    // }
    
    return array;
}

// 获取指针数组项
Object* CppApi::cppGetPointerArrayItem(void** array, Int* index) {
    if (array == NULL || index == NULL) {
        return NULL;
    }
    
    int idx = index->getValue();
    if (idx < 0) {
        return NULL;
    }
    
    return static_cast<Object*>(array[idx]);
}

// 设置指针数组项
void CppApi::cppSetPointerArrayItem(void** array, Int* index, Object* value) {
    if (array == NULL || index == NULL) {
        return;
    }
    
    int idx = index->getValue();
    if (idx < 0) {
        return;
    }
    
    array[idx] = static_cast<void*>(value);
}

// 创建字节数组
void** CppApi::cppCreateByteArray(Int* length) {
    if (length == NULL) {
        return NULL;
    }
    
    int len = length->getValue();
    if (len <= 0) {
        return NULL;
    }
    
    // 分配内存并初始化为NULL
    void** array = new void*[len];
    // for (int i = 0; i < len; i++) {
    //     array[i] = NULL;
    // }
    
    return array;
}

// 获取字节数组项
Int* CppApi::cppGetByteArrayItem(void** array, Int* index) {
    if (array == NULL || index == NULL) {
        return NULL;
    }
    
    int idx = index->getValue();
    if (idx < 0) {
        return NULL;
    }
    
    return static_cast<Int*>(array[idx]);
}

// 设置字节数组项
void CppApi::cppSetByteArrayItem(void** array, Int* index, Object* value) {
    if (array == NULL || index == NULL) {
        return;
    }
    
    int idx = index->getValue();
    if (idx < 0) {
        return;
    }
    
    array[idx] = static_cast<void*>(value);
}

// 连接字符串列表
String* CppApi::cppJoinListString(void** array, Int* length, String* separator) {
    if (array == NULL || length == NULL) {
        return String::cppNew("");
    }
    
    int len = length->getValue();
    if (len <= 0) {
        return String::cppNew("");
    }
    
    // 获取分隔符字符串，如果为NULL则使用空字符串
    const char* sep = "";
    if (separator != NULL) {
        sep = separator->c_str();
    }
    
    // 计算总长度
    int totalLength = 0;
    for (int i = 0; i < len; i++) {
        Object* item = static_cast<Object*>(array[i]);
        if (item != NULL) {
            String* str = Object::toString(item);
            if (str != NULL) {
                totalLength += str->length();
            }
        }
        
        // 添加分隔符长度（除了最后一个元素）
        if (i < len - 1 && separator != NULL) {
            totalLength += separator->length();
        }
    }
    
    // 创建结果字符串
    char* result = new char[totalLength + 1];
    result[0] = '\0';
    
    for (int i = 0; i < len; i++) {
        Object* item = static_cast<Object*>(array[i]);
        if (item != NULL) {
            String* str = Object::toString(item);
            if (str != NULL) {
                strcat(result, str->c_str());
            }
        }
        
        // 添加分隔符（除了最后一个元素）
        if (i < len - 1 && separator != NULL) {
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


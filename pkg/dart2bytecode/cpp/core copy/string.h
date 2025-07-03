#ifndef _CORE_STRING_H_
#define _CORE_STRING_H_

#include <cstddef> // 添加这个来定义 NULL
#include "object.h"
// 前向声明
class Bool;
class Int;
class Double;

// 字符串池条目
struct StringPoolEntry {
    char *data;
    int length;
    int refCount;
    bool inUse;

    StringPoolEntry() : data(nullptr), length(0), refCount(0), inUse(false) {}
};

// 简单的字符串池管理器
class StringPool {
private:
    static const int MAX_POOL_SIZE = 256;
    static StringPoolEntry pool[MAX_POOL_SIZE];
    static int poolSize;

    // 计算字符串长度
    static int getStringLength(const char *str);

    // 复制字符串
    static char *copyString(const char *str, int length);

public:
    // 简单的字符串比较函数 - 改为public
    static bool stringEqual(const char *s1, const char *s2, int len1, int len2);

    // 获取或创建字符串池条目
    static StringPoolEntry *intern(const char *str);

    // 释放引用
    static void release(StringPoolEntry *entry);

    // 获取池状态信息
    static int getPoolSize();
    static int getActiveEntries();
};

// Dart-style String implementation
class String : public Object {
private:
    StringPoolEntry *poolEntry;
    
    // 添加简单模式匹配的辅助函数
    bool simpleMatch(const char* str, const char* pattern);

public:
    String();
    String(const char *str);
    String(const String &other);
    ~String() noexcept override;

    String &operator=(const String &other);
    String &operator=(const char *str);

    const char *c_str() const noexcept;
    int length() const;
    char operator[](int index) const;

    // 检查两个String是否共享相同的数据
    bool sharesSameData(const String &other) const;

    // 获取引用计数
    int getRefCount() const;

    // ==================== 成员方法 - 对齐Dart String ====================

    // 操作符方法 (根据映射表转换)
    virtual String *cpp_add(String *b) noexcept;              // + 字符串拼接
    virtual Bool *cpp_equals(String *b) noexcept;             // == 相等比较
    virtual Bool *cpp_greaterThan(String *b) noexcept;        // > 大于比较
    virtual Bool *cpp_lessThan(String *b) noexcept;           // < 小于比较
    virtual Bool *cpp_greaterThanOrEqual(String *b) noexcept; // >= 大于等于
    virtual Bool *cpp_lessThanOrEqual(String *b) noexcept;    // <= 小于等于
    virtual String *cpp_subscript(Int *index) noexcept;       // [] 获取字符(返回单字符字符串)

    // 基本属性和检查方法
    virtual Int *getLength() noexcept;   // 获取长度
    virtual Bool *isEmpty() noexcept;    // 是否为空
    virtual Bool *isNotEmpty() noexcept; // 是否非空

    // Getter方法 (使用cppGet前缀)
    virtual Int *cppGet_length() noexcept;      // length getter
    virtual Bool *cppGet_isEmpty() noexcept;    // isEmpty getter
    virtual Bool *cppGet_isNotEmpty() noexcept; // isNotEmpty getter

    // 查找方法
    virtual Bool *contains(String *pattern) noexcept;                      // 是否包含
    virtual Bool *startsWith(String *pattern) noexcept;                    // 是否以...开始
    virtual Bool *endsWith(String *pattern) noexcept;                      // 是否以...结束
    virtual Int *indexOf(String *pattern, Int *start = NULL) noexcept;     // 查找索引
    virtual Int *lastIndexOf(String *pattern, Int *start = NULL) noexcept; // 最后索引

    // 子字符串方法
    virtual String *substring(Int *start, Int *end = NULL) noexcept; // 子字符串
    virtual String *substr(Int *start, Int *length = NULL) noexcept; // 子字符串(按长度)

    // 修剪方法
    virtual String *trim() noexcept;      // 去除首尾空白
    virtual String *trimLeft() noexcept;  // 去除左侧空白
    virtual String *trimRight() noexcept; // 去除右侧空白

    // 大小写转换
    virtual String *toLowerCase() noexcept; // 转小写
    virtual String *toUpperCase() noexcept; // 转大写

    // 替换方法
    virtual String *replaceAll(String *from, String *to) noexcept;                    // 替换所有
    virtual String *replaceFirst(String *from, String *to) noexcept;                  // 替换第一个
    virtual String *replaceRange(Int *start, Int *end, String *replacement) noexcept; // 替换范围

    // 填充方法
    virtual String *padLeft(Int *width, String *padding = NULL) noexcept;  // 左填充
    virtual String *padRight(Int *width, String *padding = NULL) noexcept; // 右填充

    // 比较方法
    virtual Int *compareTo(String *b) noexcept;           // 字符串比较(-1, 0, 1)
    virtual Int *compareToIgnoreCase(String *b) noexcept; // 忽略大小写比较

    // 分割和连接
    virtual String **split(String *pattern, Int *limit = NULL) noexcept; // 分割字符串(返回数组)
    virtual String *join(String **strings, Int *count) noexcept;         // 连接字符串数组(成员方法)

    // 编码和转换
    static String *fromCharCode(Int *charCode);                 // 从字符编码创建
    static String *fromCharCodes(Int **charCodes, Int *length); // 从字符编码数组创建
    virtual Int *codeUnitAt(Int *index) noexcept;            // 获取指定位置的字符编码

    // 重复和反转
    virtual String *repeat(Int *times) noexcept; // 重复字符串
    virtual String *reverse() noexcept;            // 反转字符串

    // 格式化
    virtual String *format(String **args, Int *argCount) noexcept; // 格式化字符串(成员方法)

    // 编码相关
    virtual String *escape() noexcept;   // 转义特殊字符
    virtual String *unescape() noexcept; // 取消转义

    // 数字转换
    static String *fromInt(Int *value);                   // 从整数创建
    static String *fromDouble(Double *value);             // 从浮点数创建
    virtual Int *parseInt(Int *radix = NULL) noexcept; // 解析为整数
    virtual Double *parseDouble() noexcept;              // 解析为浮点数

    // 匹配和正则(简化版)
    virtual Bool *matches(String *pattern) noexcept;   // 简单模式匹配
    virtual String *extract(String *pattern) noexcept; // 提取匹配内容

    // 工具方法
    virtual String *concat(String **strings, Int *count) noexcept;                    // 连接多个字符串(成员方法)
    virtual String *interpolate(String **values, Int *count) noexcept;               // 字符串插值(成员方法)

    // 辅助方法
    virtual Bool *isOneByteString() noexcept;                // 检查是否为单字节字符串
    virtual Int *getCodeUnitCount() noexcept;               // 获取代码单元数量
    virtual Bool *hasEscapeSequences() noexcept;            // 检查是否包含转义序列
    virtual String *normalize() noexcept;                    // 标准化字符串(处理换行符等)
    virtual String *removeNonPrintable() noexcept;          // 移除不可打印字符
    virtual String *truncate(Int *maxLength) noexcept;      // 截断字符串
    virtual String *ellipsis(Int *maxLength) noexcept;      // 添加省略号
    virtual String *center(Int *width) noexcept;            // 居中对齐
    virtual String *slice(Int *start, Int *end) noexcept;   // 切片操作
    virtual String *stripHtml() noexcept;                   // 移除HTML标签
    virtual String *capitalize() noexcept;                  // 首字母大写
    virtual String *decapitalize() noexcept;               // 首字母小写
    virtual String *swapCase() noexcept;                   // 大小写互换
    virtual String *toTitleCase() noexcept;                // 标题格式
    virtual String *toCamelCase() noexcept;                // 驼峰格式
    virtual String *toSnakeCase() noexcept;                // 下划线格式
    virtual String *toKebabCase() noexcept;                // 连字符格式

    static String *cppNew(const char *str, int length) noexcept;
};

// 这个函数应该保持静态，因为它是一个工具函数
String *cppToString(Object *obj);

#endif // _CORE_STRING_H_
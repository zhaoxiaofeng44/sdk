#ifndef _CORE_STRING_H_
#define _CORE_STRING_H_

#include <cstddef>  // 添加这个来定义 NULL
#include <cstdint>  // 添加这个来定义 uint8_t
#include "object.h"

// 前向声明
class Object;
class Bool;
class Int;
class Double;

// 字符串池条目
struct StringPoolEntry {
  uint8_t* data;
  int length;
  int refCount;
  bool inUse;

  StringPoolEntry();
};

// 简单的字符串池管理器
class StringPool {
 private:
  static const int MAX_POOL_SIZE = 256;
  static StringPoolEntry pool[MAX_POOL_SIZE];
  static int poolSize;

  // 计算字符串长度
  static int getStringLength(const char* str);
  static int getStringLength(const uint8_t* str);

  // 复制字符串
  static uint8_t* copyString(const char* str, int length);
  static uint8_t* copyString(const uint8_t* str, int length);

 public:
  // 简单的字符串比较函数 - 改为public
  static bool stringEqual(const uint8_t* s1,
                          const uint8_t* s2,
                          int len1,
                          int len2);

  // 获取或创建字符串池条目
  static StringPoolEntry* intern(const char* str);
  static StringPoolEntry* intern(const uint8_t* str);

  // 释放引用
  static void release(StringPoolEntry* entry);

  // 获取池状态信息
  static int getPoolSize();
  static int getActiveEntries();
};

// Dart-style String implementation
class String : public Object {
 private:
  StringPoolEntry* poolEntry;

 public:
  String();
  String(const char* str);
  String(const uint8_t* str);
  String(const String& other);
  ~String();

  String& operator=(const String& other);
  String& operator=(const char* str);
  String& operator=(const uint8_t* str);

  const char* c_str() const;
  int length() const;
  char operator[](int index) const;

  // 检查两个String是否共享相同的数据
  bool sharesSameData(const String& other) const;

  // 获取引用计数
  int getRefCount() const;

  // 转换为 UTF-8 编码数组
  uint8_t* toUnit8Code() const;

  static Type* cppGet_runtimeType(Object* a);  // runtimeType getter
  static String* toString(Object* obj);        // 获取字符串表示
  static Int* hashCode(Object* obj);  // 获取哈希码// 处理不存在的方法调用
  // ==================== 静态方法 - 对齐Dart String ====================

  // 操作符方法 (根据映射表转换)
  static String* cpp_add(String* a, String* b);               // + 字符串拼接
  static Bool* cpp_equals(String* a, String* b);              // == 相等比较
  static Bool* cpp_greaterThan(String* a, String* b);         // > 大于比较
  static Bool* cpp_lessThan(String* a, String* b);            // < 小于比较
  static Bool* cpp_greaterThanOrEqual(String* a, String* b);  // >= 大于等于
  static Bool* cpp_lessThanOrEqual(String* a, String* b);     // <= 小于等于
  static String* cpp_subscript(String* str,
                               Int* index);  // [] 获取字符(返回单字符字符串)

  // 基本属性和检查方法
  static Int* getLength(String* str);    // 获取长度
  static Bool* isEmpty(String* str);     // 是否为空
  static Bool* isNotEmpty(String* str);  // 是否非空

  // Getter方法 (使用cppGet前缀)
  static Int* cppGet_length(String* str);       // length getter
  static Bool* cppGet_isEmpty(String* str);     // isEmpty getter
  static Bool* cppGet_isNotEmpty(String* str);  // isNotEmpty getter

  // 查找方法
  static Bool* contains(String* str, String* pattern);    // 是否包含
  static Bool* startsWith(String* str, String* pattern);  // 是否以...开始
  static Bool* endsWith(String* str, String* pattern);    // 是否以...结束
  static Int* indexOf(String* str,
                      String* pattern,
                      Int* start = NULL);  // 查找索引
  static Int* lastIndexOf(String* str,
                          String* pattern,
                          Int* start = NULL);  // 最后索引

  // 子字符串方法
  static String* substring(String* str,
                           Int* start,
                           Int* end = NULL);  // 子字符串
  static String* substr(String* str,
                        Int* start,
                        Int* length = NULL);  // 子字符串(按长度)

  // 修剪方法
  static String* trim(String* str);       // 去除首尾空白
  static String* trimLeft(String* str);   // 去除左侧空白
  static String* trimRight(String* str);  // 去除右侧空白

  // 大小写转换
  static String* toLowerCase(String* str);  // 转小写
  static String* toUpperCase(String* str);  // 转大写

  // 替换方法
  static String* replaceAll(String* str, String* from, String* to);  // 替换所有
  static String* replaceFirst(String* str,
                              String* from,
                              String* to);  // 替换第一个
  static String* replaceRange(String* str,
                              Int* start,
                              Int* end,
                              String* replacement);  // 替换范围

  // 填充方法
  static String* padLeft(String* str,
                         Int* width,
                         String* padding = NULL);  // 左填充
  static String* padRight(String* str,
                          Int* width,
                          String* padding = NULL);  // 右填充

  // 比较方法
  static Int* compareTo(String* a, String* b);  // 字符串比较(-1, 0, 1)
  static Int* compareToIgnoreCase(String* a, String* b);  // 忽略大小写比较

  // 分割和连接
  static String** split(String* str,
                        String* pattern,
                        Int* limit = NULL);  // 分割字符串(返回数组)
  static String* join(String** strings,
                      Int* count,
                      String* separator);  // 连接字符串数组

  // 编码和转换
  static String* fromCharCode(Int* charCode);  // 从字符编码创建
  static String* fromCharCodes(Int** charCodes,
                               Int* length);        // 从字符编码数组创建
  static Int* codeUnitAt(String* str, Int* index);  // 获取指定位置的字符编码

  // 重复和反转
  static String* repeat(String* str, Int* times);  // 重复字符串
  static String* reverse(String* str);             // 反转字符串

  // 格式化
  static String* format(String* template_str,
                        String** args,
                        Int* argCount);  // 格式化字符串

  // 编码相关
  static String* escape(String* str);    // 转义特殊字符
  static String* unescape(String* str);  // 取消转义

  // 数字转换
  static String* fromInt(Int* value);                    // 从整数创建
  static String* fromDouble(Double* value);              // 从浮点数创建
  static Int* parseInt(String* str, Int* radix = NULL);  // 解析为整数
  static Double* parseDouble(String* str);               // 解析为浮点数

  // 匹配和正则(简化版)
  static Bool* matches(String* str, String* pattern);    // 简单模式匹配
  static String* extract(String* str, String* pattern);  // 提取匹配内容

  // 工具方法
  static String* concat(String** strings, Int* count);  // 连接多个字符串
  static String* interpolate(String* template_str,
                             String** values,
                             Int* count);  // 字符串插值

  static String* cppNew(const char* str);
  static String* cppNew(const uint8_t* str);
};

String* cppToString(Object* obj);

#endif  // _CORE_STRING_H_
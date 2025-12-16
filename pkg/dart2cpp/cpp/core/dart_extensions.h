#ifndef _DART_EXTENSIONS_H_
#define _DART_EXTENSIONS_H_

#include "dart_object.h"
#include "dart_string.h"

// ============================================================================
// Dart 扩展方法实现 - 使用命名空间和函数重载
// ============================================================================

namespace DartStringExtensions {
    /// 首字母大写
    String capitalize(const String& str) {
        if (str.isEmpty().getValue()) {
            return str;
        }
        std::string s = str.getValue();
        if (!s.empty()) {
            s[0] = std::toupper(s[0]);
        }
        return String(s);
    }
    
    /// 获取首字母大写的函数对象
    std::function<String()> get_capitalize(const String& str) {
        return [str]() { return capitalize(str); };
    }
    
    /// 检查是否为回文
    Bool isPalindrome(const String& str) {
        std::string s = str.getValue();
        // 转换为小写并移除非字母字符
        std::string cleaned;
        for (char c : s) {
            if (std::isalnum(c)) {
                cleaned += std::tolower(c);
            }
        }
        
        std::string reversed = cleaned;
        std::reverse(reversed.begin(), reversed.end());
        return Bool(cleaned == reversed);
    }
    
    /// 获取回文检查的函数对象
    std::function<Bool()> get_isPalindrome(const String& str) {
        return [str]() { return isPalindrome(str); };
    }
}

namespace MathExtensions {
    /// 平方根函数
    Double sqrt(const Double& value) {
        return Double(std::sqrt(value.getValue()));
    }
    
    /// 绝对值函数
    template<typename T>
    T abs(const T& value) {
        if constexpr (std::is_same_v<T, Int>) {
            return Int(std::abs(value.getValue()));
        } else if constexpr (std::is_same_v<T, Double>) {
            return Double(std::abs(value.getValue()));
        }
        return value;
    }
    
    /// 最大值
    template<typename T>
    T max(const T& a, const T& b) {
        if constexpr (std::is_same_v<T, Int>) {
            return Int(std::max(a.getValue(), b.getValue()));
        } else if constexpr (std::is_same_v<T, Double>) {
            return Double(std::max(a.getValue(), b.getValue()));
        }
        return a;
    }
    
    /// 最小值
    template<typename T>
    T min(const T& a, const T& b) {
        if constexpr (std::is_same_v<T, Int>) {
            return Int(std::min(a.getValue(), b.getValue()));
        } else if constexpr (std::is_same_v<T, Double>) {
            return Double(std::min(a.getValue(), b.getValue()));
        }
        return a;
    }
}

// ============================================================================
// 扩展方法宏定义 - 简化调用语法
// ============================================================================

// 字符串扩展宏
#define STRING_EXT_CAPITALIZE(str) DartStringExtensions::capitalize(str)
#define STRING_EXT_IS_PALINDROME(str) DartStringExtensions::isPalindrome(str)

// 数学扩展宏
#define MATH_EXT_SQRT(value) MathExtensions::sqrt(value)
#define MATH_EXT_ABS(value) MathExtensions::abs(value)
#define MATH_EXT_MAX(a, b) MathExtensions::max(a, b)
#define MATH_EXT_MIN(a, b) MathExtensions::min(a, b)

#endif // _DART_EXTENSIONS_H_
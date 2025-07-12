#include "num.h"
#include "string.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>

// 简单的整数转字符串函数
String intToString(int value) {
    if (value == 0) {
        return String("0");
    }

    char buffer[32];
    int index = 0;
    bool negative = value < 0;
    if (negative)
        value = -value;

    while (value > 0) {
        buffer[index++] = '0' + (value % 10);
        value /= 10;
    }

    if (negative) {
        buffer[index++] = '-';
    }

    // 反转字符串
    for (int i = 0; i < index / 2; i++) {
        char temp = buffer[i];
        buffer[i] = buffer[index - 1 - i];
        buffer[index - 1 - i] = temp;
    }

    buffer[index] = '\0';
    return String(buffer);
}

// 简单的双精度转字符串函数
String doubleToString(double value) {
    if (value != value) { // NaN check
        return String("nan");
    }
    if (value == 1.0 / 0.0) { // positive infinity
        return String("inf");
    }
    if (value == -1.0 / 0.0) { // negative infinity
        return String("-inf");
    }

    char buffer[64];
    int intPart = static_cast<int>(value);
    double fracPart = value - intPart;

    if (fracPart < 0)
        fracPart = -fracPart;

    String intStr = intToString(intPart);

    // 简单实现：只保留6位小数
    int fracInt = static_cast<int>(fracPart * 1000000);
    if (fracInt == 0) {
        return intStr;
    }

    String fracStr = intToString(fracInt);

    // 组合整数部分和小数部分
    const char *intCStr = intStr.c_str();
    const char *fracCStr = fracStr.c_str();

    int pos = 0;
    for (int i = 0; intCStr[i] != '\0'; i++) {
        buffer[pos++] = intCStr[i];
    }
    buffer[pos++] = '.';
    for (int i = 0; fracCStr[i] != '\0'; i++) {
        buffer[pos++] = fracCStr[i];
    }
    buffer[pos] = '\0';

    return String(buffer);
}

// 简单的字符串转整数函数
int stringToInt(const String &s, int radix) {
    const char *str = s.c_str();
    int result = 0;
    bool negative = false;
    int i = 0;

    if (str[0] == '-') {
        negative = true;
        i = 1;
    } else if (str[0] == '+') {
        i = 1;
    }

    for (; str[i] != '\0'; i++) {
        char c = str[i];
        int digit;

        if (c >= '0' && c <= '9') {
            digit = c - '0';
        } else if (c >= 'a' && c <= 'z') {
            digit = c - 'a' + 10;
        } else if (c >= 'A' && c <= 'Z') {
            digit = c - 'A' + 10;
        } else {
            break; // Invalid character
        }

        if (digit >= radix) {
            break; // Invalid digit for this radix
        }

        result = result * radix + digit;
    }

    return negative ? -result : result;
}

// 简单的字符串转双精度函数
double stringToDouble(const String &s) {
    const char *str = s.c_str();
    double result = 0.0;
    bool negative = false;
    int i = 0;

    if (str[0] == '-') {
        negative = true;
        i = 1;
    } else if (str[0] == '+') {
        i = 1;
    }

    // 整数部分
    for (; str[i] != '\0' && str[i] != '.'; i++) {
        if (str[i] >= '0' && str[i] <= '9') {
            result = result * 10 + (str[i] - '0');
        } else {
            break;
        }
    }

    // 小数部分
    if (str[i] == '.') {
        i++;
        double fraction = 0.1;
        for (; str[i] != '\0'; i++) {
            if (str[i] >= '0' && str[i] <= '9') {
                result += (str[i] - '0') * fraction;
                fraction *= 0.1;
            } else {
                break;
            }
        }
    }

    return negative ? -result : result;
}

// Num基本方法实现
Num *Num::cpp_unaryMinus(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        return new Num(-a->getInt());
    } else {
        return new Num(-a->getDouble());
    }
}

Num *Num::cpp_add(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (a->isInt() && b->isInt()) {
        return new Num(a->getInt() + b->getInt());
    } else {
        double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(val1 + val2);
    }
}

Num *Num::cpp_subtract(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (a->isInt() && b->isInt()) {
        return new Num(a->getInt() - b->getInt());
    } else {
        double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(val1 - val2);
    }
}

Num *Num::cpp_multiply(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (a->isInt() && b->isInt()) {
        return new Num(a->getInt() * b->getInt());
    } else {
        double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(val1 * val2);
    }
}

Num *Num::cpp_divide(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (b->isInt() && b->getInt() == 0) {
        // Division by zero - return infinity or throw
        return new Num(1.0 / 0.0); // positive infinity
    }
    if (b->isDouble() && b->getDouble() == 0.0) {
        return new Num(1.0 / 0.0); // positive infinity
    }

    // 保持整数除法结果为浮点数
    double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
    double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
    return new Num(val1 / val2);
}

Num *Num::cpp_remainder(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (b->isInt() && b->getInt() == 0) {
        return new Num(0.0 / 0.0); // NaN
    }
    if (b->isDouble() && b->getDouble() == 0.0) {
        return new Num(0.0 / 0.0); // NaN
    }

    if (a->isInt() && b->isInt()) {
        return new Num(a->getInt() % b->getInt());
    } else {
        double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(fmod(val1, val2));
    }
}

Num *Num::cpp_truncDiv(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (b->isInt() && b->getInt() == 0) {
        return new Num(1.0 / 0.0); // positive infinity
    }
    if (b->isDouble() && b->getDouble() == 0.0) {
        return new Num(1.0 / 0.0); // positive infinity
    }

    if (a->isInt() && b->isInt()) {
        return new Num(a->getInt() / b->getInt());
    } else {
        double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(static_cast<int>(val1 / val2));
    }
}

Num *Num::cpp_modulo(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    // 调用remainder实现，但确保结果为正数
    Num *result = cpp_remainder(a, b);
    if (!result)
        return nullptr;

    if (result->isInt()) {
        int val = result->getInt();
        if (val < 0) {
            int modulus = b->isInt() ? b->getInt() : static_cast<int>(b->getDouble());
            if (modulus > 0) {
                val = (val + modulus) % modulus;
            }
            delete result;
            return new Num(val);
        }
    } else {
        double val = result->getDouble();
        if (val < 0) {
            double modulus = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
            if (modulus > 0) {
                val = fmod(val + modulus, modulus);
            }
            delete result;
            return new Num(val);
        }
    }

    return result;
}

Num *Num::abs(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        int val = a->getInt();
        return new Num(val < 0 ? -val : val);
    } else {
        return new Num(fabs(a->getDouble()));
    }
}

Int *Num::ceil(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        return new Int(a->getInt()); // 整数的ceil就是它自己
    } else {
        return new Int(static_cast<int>(std::ceil(a->getDouble()))); // 浮点数的ceil转换为Int*
    }
}

Int *Num::floor(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        return new Int(a->getInt()); // 整数的floor就是它自己
    } else {
        return new Int(static_cast<int>(std::floor(a->getDouble()))); // 浮点数的floor转换为Int*
    }
}

Int *Num::round(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        return new Int(a->getInt()); // 整数的round就是它自己
    } else {
        return new Int(static_cast<int>(std::round(a->getDouble()))); // 浮点数的round转换为Int*
    }
}

Int *Num::truncate(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        return new Int(a->getInt()); // 整数的truncate就是它自己
    } else {
        return new Int(static_cast<int>(a->getDouble()));
    }
}

Num *Num::clamp(Num *a, Num *lower, Num *upper) {
    if (!a || !lower || !upper)
        return nullptr;
    // 全部作为double处理以便统一比较
    double aVal = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
    double lowerVal = lower->isDouble() ? lower->getDouble() : static_cast<double>(lower->getInt());
    double upperVal = upper->isDouble() ? upper->getDouble() : static_cast<double>(upper->getInt());

    if (aVal < lowerVal) {
        if (lower->isInt()) {
            return new Num(lower->getInt());
        } else {
            return new Num(lower->getDouble());
        }
    } else if (aVal > upperVal) {
        if (upper->isInt()) {
            return new Num(upper->getInt());
        } else {
            return new Num(upper->getDouble());
        }
    } else {
        if (a->isInt()) {
            return new Num(a->getInt());
        } else {
            return new Num(a->getDouble());
        }
    }
}

Bool *Num::cpp_equals(Num *a, Num *b) {
    if (!a || !b)
        return new Bool(false);
    if (a->isInt() && b->isInt()) {
        return new Bool(a->getInt() == b->getInt());
    } else {
        double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Bool(fabs(val1 - val2) < 1e-10); // 浮点数比较使用小误差范围
    }
}

Int *Num::cpp_compareTo(Num *a, Num *b) {
    if (!a || !b)
        return new Int(0);
    double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
    double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());

    if (fabs(val1 - val2) < 1e-10) {
        return new Int(0);
    } else if (val1 < val2) {
        return new Int(-1);
    } else {
        return new Int(1);
    }
}

Num *Num::cpp_bitwiseNot(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        return new Int(~a->getInt()); // 整数位运算返回Int*
    } else {
        // throw error - return NaN instead
        return new Double(0.0 / 0.0); // 浮点数位运算返回NaN
    }
}

Num *Num::cpp_increment(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        return new Num(a->getInt() + 1);
    } else {
        return new Num(a->getDouble() + 1.0);
    }
}

Num *Num::cpp_decrement(Num *a) {
    if (!a)
        return nullptr;
    if (a->isInt()) {
        return new Num(a->getInt() - 1);
    } else {
        return new Num(a->getDouble() - 1.0);
    }
}

Num *Num::cpp_bitwiseOr(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (a->isInt() && b->isInt()) {
        return new Int(a->getInt() | b->getInt()); // 整数位运算返回Int*
    } else {
        return new Double(0.0 / 0.0); // NaN for error
    }
}

Num *Num::cpp_bitwiseAnd(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (a->isInt() && b->isInt()) {
        return new Int(a->getInt() & b->getInt()); // 整数位运算返回Int*
    } else {
        return new Double(0.0 / 0.0); // NaN for error
    }
}

Num *Num::cpp_bitwiseXor(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (a->isInt() && b->isInt()) {
        return new Int(a->getInt() ^ b->getInt()); // 整数位运算返回Int*
    } else {
        return new Double(0.0 / 0.0); // NaN for error
    }
}

Num *Num::cpp_leftShift(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (a->isInt() && b->isInt()) {
        int val2 = b->getInt();
        if (val2 < 0) {
            return new Double(0.0 / 0.0); // NaN for error
        }
        return new Int(a->getInt() << val2); // 左移返回Int*
    } else {
        return new Double(0.0 / 0.0); // NaN for error
    }
}

Num *Num::cpp_rightShift(Num *a, Num *b) {
    if (!a || !b)
        return nullptr;
    if (a->isInt() && b->isInt()) {
        int val2 = b->getInt();
        if (val2 < 0) {
            return new Double(0.0 / 0.0); // NaN for error
        }
        return new Int(a->getInt() >> val2); // 右移返回Int*
    } else {
        return new Double(0.0 / 0.0); // NaN for error
    }
}

Bool *Num::cpp_lessThan(Num *a, Num *b) {
    if (!a || !b)
        return new Bool(false);
    double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
    double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());

    return new Bool(val1 < val2);
}

Bool *Num::cpp_lessThanOrEqual(Num *a, Num *b) {
    if (!a || !b)
        return new Bool(false);
    double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
    double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());

    return new Bool(val1 <= val2);
}

Bool *Num::cpp_greaterThan(Num *a, Num *b) {
    if (!a || !b)
        return new Bool(false);
    double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
    double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());

    return new Bool(val1 > val2);
}

Bool *Num::cpp_greaterThanOrEqual(Num *a, Num *b) {
    if (!a || !b)
        return new Bool(false);
    double val1 = a->isDouble() ? a->getDouble() : static_cast<double>(a->getInt());
    double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());

    return new Bool(val1 >= val2);
}

Int *Num::toInt(Num *a) {
    if (!a)
        return new Int(0);
    if (a->isInt()) {
        return new Int(a->getInt());
    } else {
        return new Int(static_cast<int>(a->getDouble()));
    }
}

Double *Num::toDouble(Num *a) {
    if (!a)
        return new Double(0.0);
    if (a->isDouble()) {
        return new Double(a->getDouble());
    } else {
        return new Double(static_cast<double>(a->getInt()));
    }
}

String *Num::toString(Num *a) {
    if (!a)
        return new String("null");
    if (a->isInt()) {
        return new String(intToString(a->getInt()).c_str());
    } else {
        return new String(doubleToString(a->getDouble()).c_str());
    }
}

Num *Num::cppNew(int i) {
    return new Num(i);
}
Num *Num::cppNew(double d) {
    return new Num(d);
}

// ==================== 从Int类移动过来的方法实现 ====================
Int *Num::bitLength(Int *a) {
    if (!a)
        return new Int(0);
    int val = a->getInt();
    if (val == 0) {
        return new Int(0);
    }

    // 对负数，先转换为正数
    if (val < 0) {
        val = -val - 1; // 二进制补码的绝对值
    }

    int length = 0;
    while (val > 0) {
        length++;
        val >>= 1;
    }

    return new Int(length);
}

Bool *Num::isEven(Int *a) {
    if (!a)
        return new Bool(false);
    return new Bool((a->getInt() & 1) == 0);
}

Bool *Num::isOdd(Int *a) {
    if (!a)
        return new Bool(false);
    return new Bool((a->getInt() & 1) == 1);
}

Bool *Num::isNegative(Int *a) {
    if (!a)
        return new Bool(false);
    return new Bool(a->getInt() < 0);
}

Int *Num::parseInt(String *s, Int *radix) {
    if (!s)
        return new Int(0);
    int radixValue = radix ? radix->getInt() : 10;
    return new Int(stringToInt(*s, radixValue));
}

// ==================== 从Double类移动过来的方法实现 ====================
Bool *Num::isNaN(Double *a) {
    if (!a)
        return new Bool(false);
    double val = a->getDouble();
    return new Bool(val != val);
}

Bool *Num::isInfinite(Double *a) {
    if (!a)
        return new Bool(false);
    double val = a->getDouble();
    return new Bool(val == 1.0 / 0.0 || val == -1.0 / 0.0);
}

Bool *Num::isFinite(Double *a) {
    if (!a)
        return new Bool(false);
    double val = a->getDouble();
    return new Bool(val == val && val != 1.0 / 0.0 && val != -1.0 / 0.0);
}

Double *Num::atan(Double *a) {
    if (!a)
        return new Double(0.0);
    return new Double(::atan(a->getDouble()));
}

Double *Num::acos(Double *a) {
    if (!a)
        return new Double(0.0);
    double val = a->getDouble();
    if (val < -1.0 || val > 1.0) {
        return new Double(0.0 / 0.0); // NaN
    }
    return new Double(::acos(val));
}

Double *Num::asin(Double *a) {
    if (!a)
        return new Double(0.0);
    double val = a->getDouble();
    if (val < -1.0 || val > 1.0) {
        return new Double(0.0 / 0.0); // NaN
    }
    return new Double(::asin(val));
}

Double *Num::atan2(Double *a, Double *b) {
    if (!a || !b)
        return new Double(0.0);
    return new Double(::atan2(a->getDouble(), b->getDouble()));
}

Double *Num::parseDouble(String *s) {
    if (!s)
        return new Double(0.0);
    return new Double(stringToDouble(*s));
}

// Bool方法实现
Bool *Bool::cpp_not(Bool *a) {
    if (!a)
        return new Bool(false);
    return new Bool(!a->m_data);
}

Bool *Bool::cpp_equals(Bool *a, Bool *b) {
    if (!a || !b)
        return new Bool(false);
    return new Bool(a->m_data == b->m_data);
}

Bool *Bool::cpp_bitwiseAnd(Bool *a, Bool *b) {
    if (!a || !b)
        return new Bool(false);
    return new Bool(a->m_data && b->m_data);
}

Bool *Bool::cpp_bitwiseXor(Bool *a, Bool *b) {
    if (!a || !b)
        return new Bool(false);
    return new Bool(a->m_data != b->m_data);
}

Bool *Bool::cpp_bitwiseOr(Bool *a, Bool *b) {
    if (!a || !b)
        return new Bool(false);
    return new Bool(a->m_data || b->m_data);
}

// ==================== cppGet前缀的Getter方法实现 ====================

// Int类的cppGet方法
Int *Num::cppGet_bitLength(Int *a) {
    return bitLength(a);
}

Bool *Num::cppGet_isEven(Int *a) {
    return isEven(a);
}

Bool *Num::cppGet_isOdd(Int *a) {
    return isOdd(a);
}

Bool *Num::cppGet_isNegative(Int *a) {
    return isNegative(a);
}

// Double类的cppGet方法
Bool *Num::cppGet_isNaN(Double *a) {
    return isNaN(a);
}

Bool *Num::cppGet_isInfinite(Double *a) {
    return isInfinite(a);
}

Bool *Num::cppGet_isFinite(Double *a) {
    return isFinite(a);
}

// ==================== 缺失的 cppNew 方法实现 ====================

// Int类的cppNew方法
Int *Int::cppNew(int i) {
    return new Int(i);
}

// Double类的cppNew方法
Double *Double::cppNew(int i) {
    return new Double(static_cast<double>(i));
}

Double *Double::cppNew(double d) {
    return new Double(d);
}

// Bool类的cppNew方法
Bool *Bool::cppNew(bool b) {
    return new Bool(b);
}

// ==================== 缺失的 toString 方法实现 ====================

// Int类的toString方法
String *Num::toString(Int *a) {
    if (!a)
        return new String("null");
    return new String(intToString(a->getInt()).c_str());
}

// Double类的toString方法
String *Num::toString(Double *a) {
    if (!a)
        return new String("null");
    return new String(doubleToString(a->getDouble()).c_str());
}

// Bool类的toString方法
String *Bool::toString(Bool *a) {
    if (!a)
        return new String("null");
    return new String(a->m_data ? "true" : "false");
}

// ==================== Int* 和 Double* 重载方法实现 ====================
// 注意：这些重载方法的实现已被移除，因为需要重新设计头文件结构
// 请参考 doc/NUM_OVERLOAD_ANALYSIS.md 了解完整的重载需求分析
//
// 当前的实现保持简单，所有操作都通过基类的Num*方法完成
// 未来可以通过以下步骤实现类型安全的重载：
// 1. 重新设计类继承结构
// 2. 为每个具体类型添加专门的静态方法
// 3. 实现编译时类型安全的操作符重载

// ==================== Int*参数的重载方法实现 ====================

// 算术运算重载（Int* + Int* -> Int*）
Int *Num::cpp_unaryMinus(Int *a) {
    if (!a) return nullptr;
    return new Int(-a->getInt());
}

Int *Num::cpp_add(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Int(a->getInt() + b->getInt());
}

Int *Num::cpp_subtract(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Int(a->getInt() - b->getInt());
}

Int *Num::cpp_multiply(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Int(a->getInt() * b->getInt());
}

Double *Num::cpp_divide(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() == 0) {
        return new Double(1.0 / 0.0); // positive infinity
    }
    return new Double(static_cast<double>(a->getInt()) / static_cast<double>(b->getInt()));
}

Int *Num::cpp_remainder(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() == 0) {
        return nullptr; // Error case
    }
    return new Int(a->getInt() % b->getInt());
}

Int *Num::cpp_truncDiv(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() == 0) {
        return nullptr; // Error case
    }
    return new Int(a->getInt() / b->getInt());
}

Int *Num::cpp_modulo(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() == 0) {
        return nullptr; // Error case
    }
    int result = a->getInt() % b->getInt();
    if (result < 0 && b->getInt() > 0) {
        result += b->getInt();
    }
    return new Int(result);
}

Int *Num::abs(Int *a) {
    if (!a) return nullptr;
    int val = a->getInt();
    return new Int(val < 0 ? -val : val);
}

Int *Num::cpp_increment(Int *a) {
    if (!a) return nullptr;
    return new Int(a->getInt() + 1);
}

Int *Num::cpp_decrement(Int *a) {
    if (!a) return nullptr;
    return new Int(a->getInt() - 1);
}

// 位运算重载（只对整数有效）
Int *Num::cpp_bitwiseNot(Int *a) {
    if (!a) return nullptr;
    return new Int(~a->getInt());
}

Int *Num::cpp_bitwiseOr(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Int(a->getInt() | b->getInt());
}

Int *Num::cpp_bitwiseAnd(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Int(a->getInt() & b->getInt());
}

Int *Num::cpp_bitwiseXor(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Int(a->getInt() ^ b->getInt());
}

Int *Num::cpp_leftShift(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() < 0) return nullptr; // Error case
    return new Int(a->getInt() << b->getInt());
}

Int *Num::cpp_rightShift(Int *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() < 0) return nullptr; // Error case
    return new Int(a->getInt() >> b->getInt());
}

// 数学函数重载
Int *Num::ceil(Int *a) {
    if (!a) return nullptr;
    return new Int(a->getInt()); // 整数的ceil就是它自己
}

Int *Num::floor(Int *a) {
    if (!a) return nullptr;
    return new Int(a->getInt()); // 整数的floor就是它自己
}

Int *Num::round(Int *a) {
    if (!a) return nullptr;
    return new Int(a->getInt()); // 整数的round就是它自己
}

Int *Num::truncate(Int *a) {
    if (!a) return nullptr;
    return new Int(a->getInt()); // 整数的truncate就是它自己
}

Int *Num::clamp(Int *a, Int *lower, Int *upper) {
    if (!a || !lower || !upper) return nullptr;
    int val = a->getInt();
    int lowerVal = lower->getInt();
    int upperVal = upper->getInt();
    
    if (val < lowerVal) return new Int(lowerVal);
    if (val > upperVal) return new Int(upperVal);
    return new Int(val);
}

// 比较运算重载
Bool *Num::cpp_equals(Int *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getInt() == b->getInt());
}

Int *Num::cpp_compareTo(Int *a, Int *b) {
    if (!a || !b) return new Int(0);
    int val1 = a->getInt();
    int val2 = b->getInt();
    if (val1 < val2) return new Int(-1);
    if (val1 > val2) return new Int(1);
    return new Int(0);
}

Bool *Num::cpp_lessThan(Int *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getInt() < b->getInt());
}

Bool *Num::cpp_lessThanOrEqual(Int *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getInt() <= b->getInt());
}

Bool *Num::cpp_greaterThan(Int *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getInt() > b->getInt());
}

Bool *Num::cpp_greaterThanOrEqual(Int *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getInt() >= b->getInt());
}

// ==================== Double*参数的重载方法实现 ====================

// 算术运算重载（Double* + Double* -> Double*）
Double *Num::cpp_unaryMinus(Double *a) {
    if (!a) return nullptr;
    return new Double(-a->getDouble());
}

Double *Num::cpp_add(Double *a, Double *b) {
    if (!a || !b) return nullptr;
    return new Double(a->getDouble() + b->getDouble());
}

Double *Num::cpp_subtract(Double *a, Double *b) {
    if (!a || !b) return nullptr;
    return new Double(a->getDouble() - b->getDouble());
}

Double *Num::cpp_multiply(Double *a, Double *b) {
    if (!a || !b) return nullptr;
    return new Double(a->getDouble() * b->getDouble());
}

Double *Num::cpp_divide(Double *a, Double *b) {
    if (!a || !b) return nullptr;
    if (b->getDouble() == 0.0) {
        return new Double(1.0 / 0.0); // positive infinity
    }
    return new Double(a->getDouble() / b->getDouble());
}

Double *Num::cpp_remainder(Double *a, Double *b) {
    if (!a || !b) return nullptr;
    if (b->getDouble() == 0.0) {
        return new Double(0.0 / 0.0); // NaN
    }
    return new Double(fmod(a->getDouble(), b->getDouble()));
}

Double *Num::cpp_modulo(Double *a, Double *b) {
    if (!a || !b) return nullptr;
    if (b->getDouble() == 0.0) {
        return new Double(0.0 / 0.0); // NaN
    }
    double result = fmod(a->getDouble(), b->getDouble());
    if (result < 0.0 && b->getDouble() > 0.0) {
        result += b->getDouble();
    }
    return new Double(result);
}

Double *Num::abs(Double *a) {
    if (!a) return nullptr;
    return new Double(fabs(a->getDouble()));
}

Double *Num::cpp_increment(Double *a) {
    if (!a) return nullptr;
    return new Double(a->getDouble() + 1.0);
}

Double *Num::cpp_decrement(Double *a) {
    if (!a) return nullptr;
    return new Double(a->getDouble() - 1.0);
}

// 数学函数重载
Int *Num::ceil(Double *a) {
    if (!a) return nullptr;
    return new Int(static_cast<int>(std::ceil(a->getDouble())));
}

Int *Num::floor(Double *a) {
    if (!a) return nullptr;
    return new Int(static_cast<int>(std::floor(a->getDouble())));
}

Int *Num::round(Double *a) {
    if (!a) return nullptr;
    return new Int(static_cast<int>(std::round(a->getDouble())));
}

Int *Num::truncate(Double *a) {
    if (!a) return nullptr;
    return new Int(static_cast<int>(a->getDouble()));
}

Double *Num::clamp(Double *a, Double *lower, Double *upper) {
    if (!a || !lower || !upper) return nullptr;
    double val = a->getDouble();
    double lowerVal = lower->getDouble();
    double upperVal = upper->getDouble();
    
    if (val < lowerVal) return new Double(lowerVal);
    if (val > upperVal) return new Double(upperVal);
    return new Double(val);
}

// 比较运算重载
Bool *Num::cpp_equals(Double *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(fabs(a->getDouble() - b->getDouble()) < 1e-10);
}

Int *Num::cpp_compareTo(Double *a, Double *b) {
    if (!a || !b) return new Int(0);
    double val1 = a->getDouble();
    double val2 = b->getDouble();
    if (fabs(val1 - val2) < 1e-10) return new Int(0);
    if (val1 < val2) return new Int(-1);
    return new Int(1);
}

Bool *Num::cpp_lessThan(Double *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getDouble() < b->getDouble());
}

Bool *Num::cpp_lessThanOrEqual(Double *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getDouble() <= b->getDouble());
}

Bool *Num::cpp_greaterThan(Double *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getDouble() > b->getDouble());
}

Bool *Num::cpp_greaterThanOrEqual(Double *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getDouble() >= b->getDouble());
}

// ==================== 混合类型重载方法实现 ====================

// Int* 和 Double* 混合运算（返回Double*）
Double *Num::cpp_add(Int *a, Double *b) {
    if (!a || !b) return nullptr;
    return new Double(static_cast<double>(a->getInt()) + b->getDouble());
}

Double *Num::cpp_add(Double *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Double(a->getDouble() + static_cast<double>(b->getInt()));
}

Double *Num::cpp_subtract(Int *a, Double *b) {
    if (!a || !b) return nullptr;
    return new Double(static_cast<double>(a->getInt()) - b->getDouble());
}

Double *Num::cpp_subtract(Double *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Double(a->getDouble() - static_cast<double>(b->getInt()));
}

Double *Num::cpp_multiply(Int *a, Double *b) {
    if (!a || !b) return nullptr;
    return new Double(static_cast<double>(a->getInt()) * b->getDouble());
}

Double *Num::cpp_multiply(Double *a, Int *b) {
    if (!a || !b) return nullptr;
    return new Double(a->getDouble() * static_cast<double>(b->getInt()));
}

Double *Num::cpp_divide(Int *a, Double *b) {
    if (!a || !b) return nullptr;
    if (b->getDouble() == 0.0) {
        return new Double(1.0 / 0.0); // positive infinity
    }
    return new Double(static_cast<double>(a->getInt()) / b->getDouble());
}

Double *Num::cpp_divide(Double *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() == 0) {
        return new Double(1.0 / 0.0); // positive infinity
    }
    return new Double(a->getDouble() / static_cast<double>(b->getInt()));
}

Double *Num::cpp_remainder(Int *a, Double *b) {
    if (!a || !b) return nullptr;
    if (b->getDouble() == 0.0) {
        return new Double(0.0 / 0.0); // NaN
    }
    return new Double(fmod(static_cast<double>(a->getInt()), b->getDouble()));
}

Double *Num::cpp_remainder(Double *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() == 0) {
        return new Double(0.0 / 0.0); // NaN
    }
    return new Double(fmod(a->getDouble(), static_cast<double>(b->getInt())));
}

Double *Num::cpp_modulo(Int *a, Double *b) {
    if (!a || !b) return nullptr;
    if (b->getDouble() == 0.0) {
        return new Double(0.0 / 0.0); // NaN
    }
    double result = fmod(static_cast<double>(a->getInt()), b->getDouble());
    if (result < 0.0 && b->getDouble() > 0.0) {
        result += b->getDouble();
    }
    return new Double(result);
}

Double *Num::cpp_modulo(Double *a, Int *b) {
    if (!a || !b) return nullptr;
    if (b->getInt() == 0) {
        return new Double(0.0 / 0.0); // NaN
    }
    double bVal = static_cast<double>(b->getInt());
    double result = fmod(a->getDouble(), bVal);
    if (result < 0.0 && bVal > 0.0) {
        result += bVal;
    }
    return new Double(result);
}

// 混合类型比较
Bool *Num::cpp_equals(Int *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(fabs(static_cast<double>(a->getInt()) - b->getDouble()) < 1e-10);
}

Bool *Num::cpp_equals(Double *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(fabs(a->getDouble() - static_cast<double>(b->getInt())) < 1e-10);
}

Int *Num::cpp_compareTo(Int *a, Double *b) {
    if (!a || !b) return new Int(0);
    double val1 = static_cast<double>(a->getInt());
    double val2 = b->getDouble();
    if (fabs(val1 - val2) < 1e-10) return new Int(0);
    if (val1 < val2) return new Int(-1);
    return new Int(1);
}

Int *Num::cpp_compareTo(Double *a, Int *b) {
    if (!a || !b) return new Int(0);
    double val1 = a->getDouble();
    double val2 = static_cast<double>(b->getInt());
    if (fabs(val1 - val2) < 1e-10) return new Int(0);
    if (val1 < val2) return new Int(-1);
    return new Int(1);
}

Bool *Num::cpp_lessThan(Int *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(static_cast<double>(a->getInt()) < b->getDouble());
}

Bool *Num::cpp_lessThan(Double *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getDouble() < static_cast<double>(b->getInt()));
}

Bool *Num::cpp_lessThanOrEqual(Int *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(static_cast<double>(a->getInt()) <= b->getDouble());
}

Bool *Num::cpp_lessThanOrEqual(Double *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getDouble() <= static_cast<double>(b->getInt()));
}

Bool *Num::cpp_greaterThan(Int *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(static_cast<double>(a->getInt()) > b->getDouble());
}

Bool *Num::cpp_greaterThan(Double *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getDouble() > static_cast<double>(b->getInt()));
}

Bool *Num::cpp_greaterThanOrEqual(Int *a, Double *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(static_cast<double>(a->getInt()) >= b->getDouble());
}

Bool *Num::cpp_greaterThanOrEqual(Double *a, Int *b) {
    if (!a || !b) return new Bool(false);
    return new Bool(a->getDouble() >= static_cast<double>(b->getInt()));
}

// ==================== cpp_negation 函数实现 ====================

// 基础版本：对Num*的逻辑否定运算，返回对应的数值否定
Num *Num::cpp_negation(Num *a) {
    if (!a) return nullptr;
    if (a->isInt()) {
        return new Int(-a->getInt());
    } else {
        return new Double(-a->getDouble());
    }
}

// Int版本：对Int*的否定运算，返回其负值
Int *Num::cpp_negation(Int *a) {
    if (!a) return nullptr;
    return new Int(-a->getInt());
}

// Double版本：对Double*的否定运算，返回其负值
Double *Num::cpp_negation(Double *a) {
    if (!a) return nullptr;
    return new Double(-a->getDouble());
}

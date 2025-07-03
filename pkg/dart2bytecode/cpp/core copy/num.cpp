#include "num.h"
#include "string.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>

// 添加缺失的构造函数实现
Num::Num(const Int &i) : type(INT_TYPE) {
    data.i = i.getValue();
}

Num::Num(const Double &d) : type(DOUBLE_TYPE) {
    data.d = d.getValue();
}

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
Num *Num::cpp_unaryMinus() noexcept {
    return new Num(this->isInt() ? -this->getInt() : -this->getDouble());
}

Num *Num::cpp_add(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt()) {
        return new Num(this->getInt() + b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(val1 + val2);
    }
}

Num *Num::cpp_subtract(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt()) {
        return new Num(this->getInt() - b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(val1 - val2);
    }
}

Num *Num::cpp_multiply(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt()) {
        return new Num(this->getInt() * b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(val1 * val2);
    }
}

Num *Num::cpp_divide(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt() && b->getInt() != 0) {
        return new Num(this->getInt() / b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(val1 / val2);
    }
}

Num *Num::cpp_remainder(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt() && b->getInt() != 0) {
        return new Num(this->getInt() % b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(fmod(val1, val2));
    }
}

Num *Num::cpp_truncDiv(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt() && b->getInt() != 0) {
        return new Num(this->getInt() / b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Num(trunc(val1 / val2));
    }
}

Num *Num::cpp_modulo(Num *b) noexcept {
    if (!b) return nullptr;
    double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
    double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
    return new Num(fmod(fmod(val1, val2) + val2, val2));
}

Num *Num::cpp_negation() noexcept {
    return this->isInt() ? new Int(~this->getInt()) : new Int(0);
}

Num *Num::abs() noexcept {
    if (this->isInt()) {
        int val = this->getInt();
        return new Num(val < 0 ? -val : val);
    } else {
        double val = this->getDouble();
        return new Num(val < 0 ? -val : val);
    }
}

Int *Num::ceil() noexcept {
    if (this->isInt()) {
        return new Int(this->getInt());
    } else {
        return new Int(static_cast<int>(std::ceil(this->getDouble())));
    }
}

Int *Num::floor() noexcept {
    if (this->isInt()) {
        return new Int(this->getInt());
    } else {
        return new Int(static_cast<int>(std::floor(this->getDouble())));
    }
}

Int *Num::round() noexcept {
    if (this->isInt()) {
        return new Int(this->getInt());
    } else {
        return new Int(static_cast<int>(std::round(this->getDouble())));
    }
}

Int *Num::truncate() noexcept {
    if (this->isInt()) {
        return new Int(this->getInt());
    } else {
        return new Int(static_cast<int>(std::trunc(this->getDouble())));
    }
}

Num *Num::clamp(Num *lower, Num *upper) noexcept {
    if (!lower || !upper) return nullptr;
    if (this->isInt() && lower->isInt() && upper->isInt()) {
        int val = this->getInt();
        int min = lower->getInt();
        int max = upper->getInt();
        return new Num(val < min ? min : (val > max ? max : val));
    } else {
        double val = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double min = lower->isDouble() ? lower->getDouble() : static_cast<double>(lower->getInt());
        double max = upper->isDouble() ? upper->getDouble() : static_cast<double>(upper->getInt());
        return new Num(val < min ? min : (val > max ? max : val));
    }
}

Bool *Num::cpp_equals(Num *b) noexcept {
    if (!b) return new Bool(false);
    if (this->isInt() && b->isInt()) {
        return new Bool(this->getInt() == b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Bool(val1 == val2);
    }
}

Int *Num::cpp_compareTo(Num *b) noexcept {
    if (!b) return new Int(0);
    if (this->isInt() && b->isInt()) {
        int val1 = this->getInt();
        int val2 = b->getInt();
        return new Int(val1 < val2 ? -1 : (val1 > val2 ? 1 : 0));
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Int(val1 < val2 ? -1 : (val1 > val2 ? 1 : 0));
    }
}

Num *Num::cpp_bitwiseNot() noexcept {
    return this->isInt() ? new Int(~this->getInt()) : new Int(0);
}

Num *Num::cpp_increment() noexcept {
    return this->isInt() ? new Int(this->getInt() + 1) : new Int(static_cast<int>(this->getDouble() + 1));
}

Num *Num::cpp_decrement() noexcept {
    return this->isInt() ? new Int(this->getInt() - 1) : new Int(static_cast<int>(this->getDouble() - 1));
}

Num *Num::cpp_bitwiseOr(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt()) {
        return new Int(this->getInt() | b->getInt());
    }
    return new Double(NAN);
}

Num *Num::cpp_bitwiseAnd(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt()) {
        return new Int(this->getInt() & b->getInt());
    }
    return new Double(NAN);
}

Num *Num::cpp_bitwiseXor(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt()) {
        return new Int(this->getInt() ^ b->getInt());
    }
    return new Double(NAN);
}

Num *Num::cpp_leftShift(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt()) {
        return new Int(this->getInt() << b->getInt());
    }
    return new Double(NAN);
}

Num *Num::cpp_rightShift(Num *b) noexcept {
    if (!b) return nullptr;
    if (this->isInt() && b->isInt()) {
        return new Int(this->getInt() >> b->getInt());
    }
    return new Double(NAN);
}

Bool *Num::cpp_lessThan(Num *b) noexcept {
    if (!b) return new Bool(false);
    if (this->isInt() && b->isInt()) {
        return new Bool(this->getInt() < b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Bool(val1 < val2);
    }
}

Bool *Num::cpp_lessThanOrEqual(Num *b) noexcept {
    if (!b) return new Bool(false);
    if (this->isInt() && b->isInt()) {
        return new Bool(this->getInt() <= b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Bool(val1 <= val2);
    }
}

Bool *Num::cpp_greaterThan(Num *b) noexcept {
    if (!b) return new Bool(false);
    if (this->isInt() && b->isInt()) {
        return new Bool(this->getInt() > b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Bool(val1 > val2);
    }
}

Bool *Num::cpp_greaterThanOrEqual(Num *b) noexcept {
    if (!b) return new Bool(false);
    if (this->isInt() && b->isInt()) {
        return new Bool(this->getInt() >= b->getInt());
    } else {
        double val1 = this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt());
        double val2 = b->isDouble() ? b->getDouble() : static_cast<double>(b->getInt());
        return new Bool(val1 >= val2);
    }
}

Int *Num::toInt() noexcept {
    return new Int(this->isInt() ? this->getInt() : static_cast<int>(this->getDouble()));
}

Double *Num::toDouble() noexcept {
    return new Double(this->isDouble() ? this->getDouble() : static_cast<double>(this->getInt()));
}

String *Num::toString() noexcept {
    if (this->isInt()) {
        return new String(intToString(this->getInt()));
    } else {
        return new String(doubleToString(this->getDouble()));
    }
}

// 静态工厂方法实现
Num *Num::cppNew(int i) noexcept {
    return new Num(i);
}

Num *Num::cppNew(double d) noexcept {
    return new Num(d);
}

// Int类方法实现
Int *Int::bitLength() noexcept {
    int val = this->getValue();
    if (val == 0) return new Int(0);
    if (val < 0) val = -val;
    return new Int(32 - __builtin_clz(val));
}

Bool *Int::isEven() noexcept {
    return new Bool((this->getValue() & 1) == 0);
}

Bool *Int::isOdd() noexcept {
    return new Bool((this->getValue() & 1) == 1);
}

Bool *Int::isNegative() noexcept {
    return new Bool(this->getValue() < 0);
}

Int *Int::cppGet_bitLength() noexcept {
    return this->bitLength();
}

Bool *Int::cppGet_isEven() noexcept {
    return this->isEven();
}

Bool *Int::cppGet_isOdd() noexcept {
    return this->isOdd();
}

Bool *Int::cppGet_isNegative() noexcept {
    return this->isNegative();
}

Int *Int::parseInt(String *s, Int *radix) noexcept {
    if (!s) return nullptr;
    int base = radix ? radix->getValue() : 10;
    if (base < 2 || base > 36) return nullptr;
    return new Int(stringToInt(*s, base));
}

String *Int::toString() noexcept {
    return new String(intToString(this->getValue()));
}

Int *Int::cppNew(int i) noexcept {
    return new Int(i);
}

// Double类方法实现
Bool *Double::isNaN() noexcept {
    return new Bool(std::isnan(this->getValue()));
}

Bool *Double::isInfinite() noexcept {
    return new Bool(std::isinf(this->getValue()));
}

Bool *Double::isFinite() noexcept {
    return new Bool(std::isfinite(this->getValue()));
}

Bool *Double::cppGet_isNaN() noexcept {
    return this->isNaN();
}

Bool *Double::cppGet_isInfinite() noexcept {
    return this->isInfinite();
}

Bool *Double::cppGet_isFinite() noexcept {
    return this->isFinite();
}

Double *Double::atan() noexcept {
    return new Double(std::atan(this->getValue()));
}

Double *Double::acos() noexcept {
    return new Double(std::acos(this->getValue()));
}

Double *Double::asin() noexcept {
    return new Double(std::asin(this->getValue()));
}

Double *Double::atan2(Double *b) noexcept {
    if (!b) return nullptr;
    return new Double(std::atan2(this->getValue(), b->getValue()));
}

Double *Double::parseDouble(String *s) noexcept {
    if (!s) return nullptr;
    return new Double(stringToDouble(*s));
}

String *Double::toString() noexcept {
    return new String(doubleToString(this->getValue()));
}

Double *Double::cppNew(int i) noexcept {
    return new Double(static_cast<double>(i));
}

Double *Double::cppNew(double d) noexcept {
    return new Double(d);
}

// Bool类方法实现
Bool *Bool::cpp_not() noexcept {
    return new Bool(!this->getValue());
}

Bool *Bool::cpp_equals(Bool *b) noexcept {
    if (!b) return new Bool(false);
    return new Bool(this->getValue() == b->getValue());
}

Bool *Bool::cpp_bitwiseAnd(Bool *b) noexcept {
    if (!b) return nullptr;
    return new Bool(this->getValue() && b->getValue());
}

Bool *Bool::cpp_bitwiseXor(Bool *b) noexcept {
    if (!b) return nullptr;
    return new Bool(this->getValue() != b->getValue());
}

Bool *Bool::cpp_bitwiseOr(Bool *b) noexcept {
    if (!b) return nullptr;
    return new Bool(this->getValue() || b->getValue());
}

String *Bool::toString() noexcept {
    return new String(this->getValue() ? "true" : "false");
}

Bool *Bool::cppNew(bool i) noexcept {
    return new Bool(i);
}


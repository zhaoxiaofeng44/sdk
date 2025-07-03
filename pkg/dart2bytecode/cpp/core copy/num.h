#ifndef _NUM_H_
#define _NUM_H_

#include "object.h"

// 前向声明
class String;
class Int;
class Double;
class Bool;

class Num : public Object {
public:
    enum Type { INT_TYPE,
                DOUBLE_TYPE };
    Type type;
    union {
        int i;
        double d;
    } data;

    Num(int i) : type(INT_TYPE) { data.i = i; }
    Num(double d) : type(DOUBLE_TYPE) { data.d = d; }
    Num(const Int &i);    // 只声明，不定义
    Num(const Double &d); // 只声明，不定义
    Num(const Num &n) : type(n.type), data(n.data) {}

    operator int() const noexcept {
        if (type == INT_TYPE) {
            return data.i;
        }
        return static_cast<int>(data.d);
    }

    operator double() const noexcept {
        if (type == DOUBLE_TYPE) {
            return data.d;
        }
        return static_cast<double>(data.i);
    }

    bool isInt() const noexcept { return type == INT_TYPE; }
    bool isDouble() const noexcept { return type == DOUBLE_TYPE; }
    int getInt() const noexcept { return data.i; }
    double getDouble() const noexcept { return data.d; }

    // ==================== 基础方法 ====================
    virtual Num *cpp_unaryMinus() noexcept;
    virtual Num *cpp_add(Num *b) noexcept;
    virtual Num *cpp_subtract(Num *b) noexcept;
    virtual Num *cpp_multiply(Num *b) noexcept;
    virtual Num *cpp_divide(Num *b) noexcept;
    virtual Num *cpp_remainder(Num *b) noexcept;
    virtual Num *cpp_truncDiv(Num *b) noexcept;
    virtual Num *cpp_modulo(Num *b) noexcept;
    virtual Num *cpp_negation() noexcept;

    virtual Num *abs() noexcept;
    virtual Int *ceil() noexcept;              // ceil总是返回Int*
    virtual Int *floor() noexcept;             // floor总是返回Int*
    virtual Int *round() noexcept;             // round总是返回Int*
    virtual Int *truncate() noexcept;          // truncate总是返回Int*
    virtual Num *clamp(Num *lower, Num *upper) noexcept;
    virtual Bool *cpp_equals(Num *b) noexcept;
    virtual Int *cpp_compareTo(Num *b) noexcept;
    virtual Num *cpp_bitwiseNot() noexcept;    // 整数输入返回Int*，否则返回NaN
    virtual Num *cpp_increment() noexcept;
    virtual Num *cpp_decrement() noexcept;
    virtual Num *cpp_bitwiseOr(Num *b) noexcept;   // 整数输入返回Int*，否则返回NaN
    virtual Num *cpp_bitwiseAnd(Num *b) noexcept;  // 整数位运算返回Int*，否则返回NaN
    virtual Num *cpp_bitwiseXor(Num *b) noexcept;  // 整数位运算返回Int*，否则返回NaN
    virtual Num *cpp_leftShift(Num *b) noexcept;   // 整数位运算返回Int*，否则返回NaN
    virtual Num *cpp_rightShift(Num *b) noexcept;  // 整数位运算返回Int*，否则返回NaN
    virtual Bool *cpp_lessThan(Num *b) noexcept;
    virtual Bool *cpp_lessThanOrEqual(Num *b) noexcept;
    virtual Bool *cpp_greaterThan(Num *b) noexcept;
    virtual Bool *cpp_greaterThanOrEqual(Num *b) noexcept;

    virtual Int *toInt() noexcept;
    virtual Double *toDouble() noexcept;
    virtual String *toString() noexcept override;

    static Num *cppNew(int i) noexcept;
    static Num *cppNew(double d) noexcept;
};

class Int : public Num {
public:
    Int() : Num(0) {}
    Int(int value) : Num(value) {}
    Int(const Int &other) : Num(other) {}

    // 访问数据使用基类的方法
    int getValue() const noexcept { return getInt(); }
    operator int() const noexcept { return getInt(); }

    virtual Int *bitLength() noexcept;
    virtual Bool *isEven() noexcept;
    virtual Bool *isOdd() noexcept;
    virtual Bool *isNegative() noexcept;

    // Getter方法 (使用cppGet前缀)
    virtual Int *cppGet_bitLength() noexcept;
    virtual Bool *cppGet_isEven() noexcept;
    virtual Bool *cppGet_isOdd() noexcept;
    virtual Bool *cppGet_isNegative() noexcept;

    virtual Int *parseInt(String *s, Int *radix = NULL) noexcept;
    virtual String *toString() noexcept override;

    static Int *cppNew(int i) noexcept;
};

class Double : public Num {
public:
    Double() : Num(0.0) {}
    Double(double value) : Num(value) {}
    Double(const Double &other) : Num(other) {}

    // 访问数据使用基类的方法
    double getValue() const noexcept { return getDouble(); }
    operator double() const noexcept { return getDouble(); }

    virtual Bool *isNaN() noexcept;
    virtual Bool *isInfinite() noexcept;
    virtual Bool *isFinite() noexcept;

    // Getter方法 (使用cppGet前缀)
    virtual Bool *cppGet_isNaN() noexcept;
    virtual Bool *cppGet_isInfinite() noexcept;
    virtual Bool *cppGet_isFinite() noexcept;

    virtual Double *atan() noexcept;
    virtual Double *acos() noexcept;
    virtual Double *asin() noexcept;
    virtual Double *atan2(Double *b) noexcept;

    virtual Double *parseDouble(String *s) noexcept;
    virtual String *toString() noexcept override;

    static Double *cppNew(int i) noexcept;
    static Double *cppNew(double d) noexcept;
};

class Bool : public Object {
public:
    bool m_data;

    Bool() : m_data(false) {}
    Bool(bool value) : m_data(value) {}
    Bool(const Bool &other) : m_data(other.m_data) {}

    operator bool() const noexcept { return m_data; }

    bool getValue() const noexcept { return m_data; }

    virtual Bool *cpp_not() noexcept;
    virtual Bool *cpp_equals(Bool *b) noexcept;
    virtual Bool *cpp_bitwiseAnd(Bool *b) noexcept;
    virtual Bool *cpp_bitwiseXor(Bool *b) noexcept;
    virtual Bool *cpp_bitwiseOr(Bool *b) noexcept;
    virtual String *toString() noexcept override;

    static Bool *cppNew(bool i) noexcept;
};

#endif // _NUM_H_

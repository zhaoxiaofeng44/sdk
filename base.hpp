#pragma once

#include <string>
#include <memory>
#include <iostream>

class String;

class Object {
public:
    virtual ~Object() = default;
    virtual String* toString() const;
};

class String : public Object {
public:
    std::string value;
    int length;

    static String* _new_0() {
        String* obj = new String();
        obj->value = "";
        obj->length = 0;
        return obj;
    }

    static String* fromStdString(const std::string& str) {
        String* obj = new String();
        obj->value = str;
        obj->length = str.length();
        return obj;
    }

    static String* fromInt(int value) {
        return fromStdString(std::to_string(value));
    }

    String* operator+(const String* other) const {
        if (other == nullptr) return nullptr;
        return fromStdString(this->value + other->value);
    }

    String* operator+(int value) const {
        return fromStdString(this->value + std::to_string(value));
    }

    bool operator==(const String* other) const {
        if (other == nullptr) return false;
        return this->value == other->value;
    }

    bool operator!=(const String* other) const {
        return !(*this == other);
    }

    virtual String* toString() const override {
        return fromStdString(value);
    }

    int get_length() const {
        return length;
    }
};

// 实现Object的toString方法
inline String* Object::toString() const {
    return String::fromStdString("Object");
}

// 用于打印的全局函数
inline void print(const Object* obj) {
    if (obj == nullptr) {
        std::cout << "null" << std::endl;
    } else {
        std::cout << obj->toString()->value << std::endl;
    }
}

inline void print(const char* str) {
    std::cout << str << std::endl;
}

inline void print(int value) {
    std::cout << value << std::endl;
}

inline void print(double value) {
    std::cout << value << std::endl;
}

inline void print(bool value) {
    std::cout << (value ? "true" : "false") << std::endl;
} 
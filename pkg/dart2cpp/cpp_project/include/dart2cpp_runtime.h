// Dart2Cpp Runtime Library Header
// Provides runtime support for converted Dart code

#ifndef DART2CPP_RUNTIME_H
#define DART2CPP_RUNTIME_H

#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <memory>

namespace dart2cpp {

// Forward declarations
class Bool;
class Int;
class Double;

// Dart Object base class
class Object {
public:
    virtual ~Object() = default;
    virtual std::string toString() const {
        return "Object";
    }
};

// Dart String class
class String : public Object {
private:
    std::string value_;

public:
    explicit String(const std::string& value) : value_(value) {}
    explicit String(const char* value) : value_(value ? value : "") {}

    const std::string& value() const { return value_; }
    int length() const { return static_cast<int>(value_.length()); }

    std::string toString() const override {
        return value_;
    }

    // String concatenation
    String operator+(const String& other) const {
        return String(value_ + other.value_);
    }

    // Equality
    bool operator==(const String& other) const {
        return value_ == other.value_;
    }

    bool operator!=(const String& other) const {
        return !(*this == other);
    }
};

// Dart Int class (using Int instead of int to avoid C++ keyword conflict)
class Int : public Object {
private:
    int64_t value_;

public:
    explicit Int(int64_t value) : value_(value) {}

    int64_t value() const { return value_; }

    std::string toString() const override {
        return std::to_string(value_);
    }

    // Arithmetic operators
    Int operator+(const Int& other) const { return Int(value_ + other.value_); }
    Int operator-(const Int& other) const { return Int(value_ - other.value_); }
    Int operator*(const Int& other) const { return Int(value_ * other.value_); }
    Int operator/(const Int& other) const { return Int(value_ / other.value_); }
    Int operator%(const Int& other) const { return Int(value_ % other.value_); }

    // Comparison operators
    bool operator<(const Int& other) const { return value_ < other.value_; }
    bool operator<=(const Int& other) const { return value_ <= other.value_; }
    bool operator>(const Int& other) const { return value_ > other.value_; }
    bool operator>=(const Int& other) const { return value_ >= other.value_; }
    bool operator==(const Int& other) const { return value_ == other.value_; }
    bool operator!=(const Int& other) const { return value_ != other.value_; }
};

// Dart Double class (using Double instead of double to avoid C++ keyword conflict)
class Double : public Object {
private:
    double value_;

public:
    explicit Double(double value) : value_(value) {}

    double value() const { return value_; }

    std::string toString() const override {
        return std::to_string(value_);
    }

    // Arithmetic operators
    Double operator+(const Double& other) const { return Double(value_ + other.value_); }
    Double operator-(const Double& other) const { return Double(value_ - other.value_); }
    Double operator*(const Double& other) const { return Double(value_ * other.value_); }
    Double operator/(const Double& other) const { return Double(value_ / other.value_); }
};

// Dart Bool class (using Bool instead of bool to avoid C++ keyword conflict)
class Bool : public Object {
private:
    bool value_;

public:
    explicit Bool(bool value) : value_(value) {}

    bool value() const { return value_; }

    std::string toString() const override {
        return value_ ? "true" : "false";
    }

    // Logical operators
    Bool operator&&(const Bool& other) const { return Bool(value_ && other.value_); }
    Bool operator||(const Bool& other) const { return Bool(value_ || other.value_); }
    Bool operator!() const { return Bool(!value_); }
};

// Type aliases to avoid keyword conflicts
using DartInt = Int;
using DartDouble = Double;
using DartBool = Bool;

// Dart List class (template)
template <typename T>
class List : public Object {
private:
    std::vector<T> elements_;

public:
    List() = default;

    void add(const T& element) {
        elements_.push_back(element);
    }

    T operator[](size_t index) const {
        return elements_[index];
    }

    T& operator[](size_t index) {
        return elements_[index];
    }

    size_t length() const {
        return elements_.size();
    }

    bool isEmpty() const {
        return elements_.empty();
    }

    std::string toString() const override {
        std::string result = "[";
        for (size_t i = 0; i < elements_.size(); ++i) {
            if (i > 0) result += ", ";
            // Convert to Object* and call toString()
            result += dynamic_cast<const Object*>(&elements_[i])->toString();
        }
        result += "]";
        return result;
    }
};

// Dart Map class (template)
template <typename K, typename V>
class Map : public Object {
private:
    std::map<K, V> elements_;

public:
    Map() = default;

    void operator[](const K& key) = delete; // Prevent direct assignment

    void set(const K& key, const V& value) {
        elements_[key] = value;
    }

    V get(const K& key) const {
        auto it = elements_.find(key);
        if (it != elements_.end()) {
            return it->second;
        }
        return V{};
    }

    bool containsKey(const K& key) const {
        return elements_.find(key) != elements_.end();
    }

    size_t length() const {
        return elements_.size();
    }

    bool isEmpty() const {
        return elements_.empty();
    }

    std::string toString() const override {
        std::string result = "{";
        bool first = true;
        for (const auto& pair : elements_) {
            if (!first) result += ", ";
            first = false;
            // Convert to Object* and call toString()
            result += dynamic_cast<const Object*>(&pair.first)->toString() +
                      ": " +
                      dynamic_cast<const Object*>(&pair.second)->toString();
        }
        result += "}";
        return result;
    }
};

// Helper functions
void print(const Object& obj) {
    std::cout << obj.toString() << std::endl;
}

void print(const std::string& message) {
    std::cout << message << std::endl;
}

// Null value
class Null : public Object {
public:
    std::string toString() const override {
        return "null";
    }
};

Null null_object;

} // namespace dart2cpp

#endif // DART2CPP_RUNTIME_H
// ============================================================================
// 综合Dart示例的C++版本 - 覆盖所有基本语法
// ============================================================================

#include <iostream>
#include <string>
#include <vector>
#include <set>
#include <map>
#include <memory>
#include <functional>
#include <cmath>
#include <algorithm>

using namespace std;

// 宏定义
#define dart_print(value) \
    cout << (value).toString().getValue() << endl;

// ============================================================================
// 1. 基础类型封装类
// ============================================================================

class String;
class Bool;

class Object {
public:
    virtual ~Object() = default;
    virtual String toString() const;
};

class String : public Object {
private:
    string value_;
public:
    String() : value_("") {}
    String(const string& val) : value_(val) {}
    String(const char* val) : value_(val) {}

    const string& getValue() const { return value_; }

    String operator+(const String& other) const {
        return String(value_ + other.value_);
    }

    bool operator==(const String& other) const {
        return value_ == other.value_;
    }

    bool operator<(const String& other) const {
        return value_ < other.value_;
    }

    bool operator>(const String& other) const {
        return value_ > other.value_;
    }

    String toString() const override {
        return String(value_);
    }
};

class Bool : public Object {
private:
    bool value_;
public:
    Bool() : value_(false) {}
    Bool(bool val) : value_(val) {}

    bool toBool() const { return value_; }

    Bool operator&&(const Bool& other) const {
        return Bool(value_ && other.value_);
    }

    Bool operator||(const Bool& other) const {
        return Bool(value_ || other.value_);
    }

    Bool operator!() const {
        return Bool(!value_);
    }

    bool operator==(const Bool& other) const {
        return value_ == other.value_;
    }

    String toString() const override {
        return String(value_ ? "true" : "false");
    }
};

class Int : public Object {
private:
    int value_;
public:
    Int() : value_(0) {}
    Int(int val) : value_(val) {}

    int toInt() const { return value_; }

    Int operator+(const Int& other) const {
        return Int(value_ + other.value_);
    }

    Int operator-(const Int& other) const {
        return Int(value_ - other.value_);
    }

    Int operator*(const Int& other) const {
        return Int(value_ * other.value_);
    }

    Int operator/(const Int& other) const {
        return value_ != 0 ? Int(value_ / other.value_) : Int(0);
    }

    Int operator%(const Int& other) const {
        return value_ != 0 ? Int(value_ % other.value_) : Int(0);
    }

    bool operator>(const Int& other) const {
        return value_ > other.value_;
    }

    bool operator<(const Int& other) const {
        return value_ < other.value_;
    }

    bool operator==(const Int& other) const {
        return value_ == other.value_;
    }

    Bool greaterThan(const Int& other) const {
        return Bool(value_ > other.value_);
    }

    Bool lessThan(const Int& other) const {
        return Bool(value_ < other.value_);
    }

    String toString() const override {
        return String(to_string(value_));
    }
};

class Double : public Object {
private:
    double value_;
public:
    Double() : value_(0.0) {}
    Double(double val) : value_(val) {}

    double toDouble() const { return value_; }

    Double operator+(const Double& other) const {
        return Double(value_ + other.value_);
    }

    Double operator-(const Double& other) const {
        return Double(value_ - other.value_);
    }

    Double operator*(const Double& other) const {
        return Double(value_ * other.value_);
    }

    Double operator/(const Double& other) const {
        return value_ != 0.0 ? Double(value_ / other.value_) : Double(0.0);
    }

    bool operator>(const Double& other) const {
        return value_ > other.value_;
    }

    bool operator<(const Double& other) const {
        return value_ < other.value_;
    }

    Bool greaterThan(const Double& other) const {
        return Bool(value_ > other.value_);
    }

    Bool lessThan(const Double& other) const {
        return Bool(value_ < other.value_);
    }

    String toString() const override {
        return String(to_string(value_));
    }
};

inline String Object::toString() const {
    return String("Object()");
}

// ============================================================================
// 2. 集合类
// ============================================================================

template<typename T>
class List : public Object {
private:
    vector<T> items_;
public:
    List() {}

    void add(const T& item) {
        items_.push_back(item);
    }

    void removeAt(int index) {
        if (index >= 0 && index < static_cast<int>(items_.size())) {
            items_.erase(items_.begin() + index);
        }
    }

    int getSize() const {
        return static_cast<int>(items_.size());
    }

    T& operator[](int index) {
        return items_[index];
    }

    const T& operator[](int index) const {
        return items_[index];
    }

    String toString() const override {
        string result = "[";
        for (size_t i = 0; i < items_.size(); i++) {
            if (i > 0) result += ", ";
            result += items_[i].toString().getValue();
        }
        result += "]";
        return String(result);
    }
};

template<typename K, typename V>
class Map : public Object {
private:
    map<K, V> items_;
public:
    Map() {}

    void put(const K& key, const V& value) {
        items_[key] = value;
    }

    V get(const K& key) const {
        auto it = items_.find(key);
        return it != items_.end() ? it->second : V();
    }

    int getSize() const {
        return static_cast<int>(items_.size());
    }

    String toString() const override {
        string result = "{";
        bool first = true;
        for (const auto& pair : items_) {
            if (!first) result += ", ";
            first = false;
            result += pair.first.toString().getValue() + ": " +
                     pair.second.toString().getValue();
        }
        result += "}";
        return String(result);
    }
};

// ============================================================================
// 3. 动物类示例
// ============================================================================

class Animal : public Object {
protected:
    String name_;
    Int age_;
public:
    Animal(const String& name, const Int& age) : name_(name), age_(age) {}

    virtual void speak() {
        cout << name_.getValue() << " makes a sound" << endl;
    }

    String getInfo() const {
        return String(name_.getValue() + " is " + to_string(age_.toInt()) + " years old");
    }
};

class Dog : public Animal {
private:
    String breed_;
public:
    Dog(const String& name, const Int& age, const String& breed)
        : Animal(name, age), breed_(breed) {}

    void speak() override {
        cout << name_.getValue() << " barks" << endl;
    }

    void wagTail() {
        cout << name_.getValue() << " wags tail" << endl;
    }
};

class Bird : public Animal {
public:
    Bird(const String& name, const Int& age) : Animal(name, age) {}

    void speak() override {
        cout << name_.getValue() << " chirps" << endl;
    }

    void fly() {
        cout << name_.getValue() << " flies" << endl;
    }
};

// ============================================================================
// 4. 辅助函数
// ============================================================================

Int add(const Int& a, const Int& b) {
    return a + b;
}

Int multiply(const Int& a, const Int& b) {
    return a * b;
}

Int findMax(const List<Int>& items) {
    if (items.getSize() == 0) return Int(0);

    Int max = items[0];
    for (int i = 1; i < items.getSize(); i++) {
        if (items[i] > max) {
            max = items[i];
        }
    }
    return max;
}

// ============================================================================
// 5. 测试函数
// ============================================================================

void testBasicTypes() {
    cout << "\n=== Test Basic Types ===" << endl;

    Int intVar(42);
    Double doubleVar(3.14159);
    Bool isTrue(true);
    String singleQuote("single");
    String doubleQuote("double");
    String interpolation("Value: " + to_string(intVar.toInt()));

    dart_print(intVar);
    dart_print(doubleVar);
    dart_print(isTrue);
    cout << "String: " << singleQuote.getValue() << endl;
}

void testOperators() {
    cout << "\n=== Test Operators ===" << endl;

    Int a(10);
    Int b(3);

    cout << "a = " << a.toInt() << ", b = " << b.toInt() << endl;
    cout << "a + b = " << (a + b).toInt() << endl;
    cout << "a - b = " << (a - b).toInt() << endl;
    cout << "a * b = " << (a * b).toInt() << endl;
    cout << "a / b = " << (a / b).toInt() << endl;
    cout << "a % b = " << (a % b).toInt() << endl;
    cout << "a > b: " << (a > b ? "true" : "false") << endl;
    cout << "a == b: " << (a == b ? "true" : "false") << endl;
}

void testControlFlow() {
    cout << "\n=== Test Control Flow ===" << endl;

    Int score(85);
    if (score.toInt() >= 90) {
        cout << "Grade: A" << endl;
    } else if (score.toInt() >= 80) {
        cout << "Grade: B" << endl;
    } else if (score.toInt() >= 70) {
        cout << "Grade: C" << endl;
    } else {
        cout << "Grade: F" << endl;
    }

    cout << "For loop:" << endl;
    for (int i = 0; i < 5; i++) {
        cout << "i = " << i << endl;
    }

    cout << "While loop:" << endl;
    Int count(0);
    while (count.toInt() < 3) {
        cout << "count = " << count.toInt() << endl;
        count = count + Int(1);
    }
}

void testCollections() {
    cout << "\n=== Test Collections ===" << endl;

    List<Int> numbers;
    numbers.add(Int(1));
    numbers.add(Int(2));
    numbers.add(Int(3));
    numbers.add(Int(4));
    numbers.add(Int(5));

    dart_print(numbers);
    cout << "Size: " << numbers.getSize() << endl;
    cout << "First: " << numbers[0].toInt() << endl;
    cout << "Last: " << numbers[numbers.getSize() - 1].toInt() << endl;

    numbers.add(Int(6));
    dart_print(numbers);

    Map<String, Int> scores;
    scores.put(String("Alice"), Int(95));
    scores.put(String("Bob"), Int(87));
    scores.put(String("Charlie"), Int(92));

    dart_print(scores);
    cout << "Alice score: " << scores.get(String("Alice")).toInt() << endl;
}

void testOOP() {
    cout << "\n=== Test OOP ===" << endl;

    Animal animal(String("Generic"), Int(5));
    cout << animal.getInfo().getValue() << endl;

    Dog dog(String("Buddy"), Int(3), String("Golden Retriever"));
    dog.speak();
    dog.wagTail();
    cout << dog.getInfo().getValue() << endl;

    Bird bird(String("Tweety"), Int(2));
    bird.speak();
    bird.fly();
    cout << bird.getInfo().getValue() << endl;
}

void testFunctions() {
    cout << "\n=== Test Functions ===" << endl;

    Int a(10), b(5);
    Int result1 = add(a, b);
    Int result2 = multiply(a, b);

    cout << "add(10, 5) = " << result1.toInt() << endl;
    cout << "multiply(10, 5) = " << result2.toInt() << endl;

    List<Int> nums;
    nums.add(Int(3));
    nums.add(Int(7));
    nums.add(Int(2));
    nums.add(Int(9));
    nums.add(Int(1));

    Int max = findMax(nums);
    cout << "Max of list: " << max.toInt() << endl;
}

void testExceptions() {
    cout << "\n=== Test Exceptions ===" << endl;

    try {
        Int divisor(0);
        Int result = Int(10) / divisor;
        cout << "Result: " << result.toInt() << endl;
    } catch (const exception& e) {
        cout << "Caught exception: " << e.what() << endl;
    }

    try {
        List<Int> list;
        // 正常访问
        cout << "List operations safe" << endl;
    } catch (const exception& e) {
        cout << "Caught exception: " << e.what() << endl;
    }
}

void testEnums() {
    cout << "\n=== Test Enums ===" << endl;

    enum Color { red, green, blue };
    Color favorite = red;

    cout << "Favorite color: " << favorite << endl;

    switch (favorite) {
        case red:
            cout << "Color is red" << endl;
            break;
        case green:
            cout << "Color is green" << endl;
            break;
        case blue:
            cout << "Color is blue" << endl;
            break;
    }
}

// ============================================================================
// 6. 主函数
// ============================================================================

int main() {
    cout << "========================================" << endl;
    cout << "Comprehensive Dart Example in C++" << endl;
    cout << "========================================" << endl;

    testBasicTypes();
    testOperators();
    testControlFlow();
    testCollections();
    testOOP();
    testFunctions();
    testExceptions();
    testEnums();

    cout << "\n========================================" << endl;
    cout << "All tests completed!" << endl;
    cout << "========================================" << endl;

    return 0;
}

// Generated C++ header
#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <memory>
#include <any>
#include <functional>
#include <stdint.h>

namespace dart_cpp {

// Forward declarations
class TestClass;

// Boxing classes for primitive types
class BoxInt {
public:
    public:
        int64_t value;
        BoxInt(int64_t val = 0) : value(val) {}
};

class BoxBool {
public:
    public:
        bool value;
        BoxBool(bool val = false) : value(val) {}
};

class BoxDouble {
public:
    public:
        double value;
        BoxDouble(double val = 0.0) : value(val) {}
};

class BoxString {
public:
    public:
        std::string value;
        BoxString(std::string val = "") : value(val) {}
};

// Class: TestClass
class TestClass {
public:
    private:
        DartObject* value;
    
    public:
        TestClass();
        virtual ~TestClass();
    
        DartObject* getValue();
};


} // namespace dart_cpp

// Generated C++ implementation
namespace dart_cpp {

// Implementation of class: TestClass
TestClass::TestClass() {
    // Default constructor
}

TestClass::~TestClass() {
    // Destructor
}

DartObject* TestClass::getValue() {
    return 42LL;
}



} // namespace dart_cpp


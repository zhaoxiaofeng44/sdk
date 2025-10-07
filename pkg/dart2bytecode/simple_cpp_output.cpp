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
class SimpleClass;

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

// Class: SimpleClass
class SimpleClass {
public:
    private:
        DartObject* value;
    
    public:
        SimpleClass();
        virtual ~SimpleClass();
    
        DartObject* getValue();
        // Static methods
        static DartObject* createInstance();
};


} // namespace dart_cpp

// Generated C++ implementation
namespace dart_cpp {

// Implementation of class: SimpleClass
SimpleClass::SimpleClass() {
    // Default constructor
}

SimpleClass::~SimpleClass() {
    // Destructor
}

DartObject* SimpleClass::getValue() {
    return 42LL;
}

static DartObject* SimpleClass::createInstance() {
    return 100LL;
}



} // namespace dart_cpp


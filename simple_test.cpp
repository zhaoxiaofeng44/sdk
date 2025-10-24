#include "pkg/dart2bytecode/base/object.h"
#include <iostream>

int main() {
    std::cout << "Simple test" << std::endl;
    
    Int a(42);
    String s = a.toString();
    std::cout << "Result: " << s.toString() << std::endl;
    
    return 0;
}

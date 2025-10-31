// Dart2Cpp Runtime Library Implementation
// Additional runtime support functions

#include "dart2cpp_runtime.h"

namespace dart2cpp {
// Any additional runtime implementations can go here

// Print helper for different types
void print(const char* message) {
    std::cout << message << std::endl;
}

void print(int value) {
    std::cout << value << std::endl;
}

void print(double value) {
    std::cout << value << std::endl;
}

void print(bool value) {
    std::cout << (value ? "true" : "false") << std::endl;
}

} // namespace dart2cpp
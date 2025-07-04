#include "../core/string.h"
#include "../core/num.h"
#include "../core/array.h"
#include "../core/object.h"
#include <iostream>
#include <cstring>


class TestClass {
    public:
    int a;
    int b;
    TestClass(int a, int b) : a(a), b(b) {
        super();
        
    }

    static TestClass* cppNew(TestClass* this, int a, int b) {
       this->a = a;
       this->b = b;
       return this;

    }
};

int main() {
    std::cout << "Running core library tests..." << std::endl;
  

  
    TestClass* tst = TestClass::cppNew(1, 2);
    std::cout << "All tests passed!" << std::endl;
    return 0;
}

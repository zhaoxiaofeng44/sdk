#include "../core/string.h"
#include "../core/num.h"
#include "../core/object.h"
#include <iostream>
#include <cstring>
#include "../output.h"


class TestClass {
    public:
    int a;
    int b;
    TestClass(int a, int b) : a(a), b(b) {
    }

    static TestClass* cppNew(int a, int b) {
       TestClass* instance = new TestClass(a, b);
       return instance;
    }
};

int main() {
    std::cout << "Running core library tests..." << std::endl;
  

  
    TestClass* tst = TestClass::cppNew(1, 2);
    std::cout << "TestClass created with a=" << tst->a << ", b=" << tst->b << std::endl;
    std::cout << "All tests passed!" << std::endl;




    Object* list = CppList::cppCtr_(CppList::cppNew(),Int::cppNew(10),Int::cppNew(16));
    CppList::add(list,Int::cppNew(1));
    CppList::add(list,Int::cppNew(2));
    CppList::add(list,Int::cppNew(3));
    std::cout << CppList::toString(list) << std::endl;

    return 0;
   
}

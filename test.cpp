#include "base.hpp"
#include "containers.hpp"
#include <cassert>

class MyTest : public Object {
public:
    String* name;
    int age;

    static MyTest* _new_0() {
        MyTest* obj = new MyTest();
        obj->name = String::fromStdString("John");
        obj->age = 25;
        return obj;
    }

    void testContainers() {
        // Test List advanced features
        auto list = List<String*>::create();
        list->add(String::fromStdString("Hello"));
        list->add(String::fromStdString("World"));
        list->insert(1, String::fromStdString("Beautiful"));
        print(list);  // Should print: [Hello, Beautiful, World]

        auto subList = list->sublist(1, 3);
        print(subList);  // Should print: [Beautiful, World]

        list->sort([](String* a, String* b) { 
            return a->value < b->value; 
        });
        print(list);  // Should print: [Beautiful, Hello, World]

        // Test Map advanced features
        auto map = Map<String*, int>::create();
        map->put(String::fromStdString("one"), 1);
        map->put(String::fromStdString("two"), 2);
        map->put(String::fromStdString("three"), 3);

        map->forEach([](String* key, int value) {
            print(key->operator+(String::fromStdString(": "))->operator+(String::fromInt(value)));
        });

        auto doubledMap = map->map<int>([](int v) { return v * 2; });
        doubledMap->forEach([](String* key, int value) {
            print(key->operator+(String::fromStdString(": "))->operator+(String::fromInt(value)));
        });

        // Test Set advanced features
        auto set1 = Set<String*>::create();
        set1->add(String::fromStdString("A"));
        set1->add(String::fromStdString("B"));
        set1->add(String::fromStdString("C"));

        auto set2 = Set<String*>::create();
        set2->add(String::fromStdString("B"));
        set2->add(String::fromStdString("C"));
        set2->add(String::fromStdString("D"));

        auto intersection = set1->intersection(set2);
        print(intersection);  // Should print: {B, C}

        auto union_ = set1->union_(set2);
        print(union_);  // Should print: {A, B, C, D}

        auto diff = set1->difference(set2);
        print(diff);  // Should print: {A}

        // Test functional features
        auto numbers = List<int>::create();
        for (int i = 1; i <= 5; i++) {
            numbers->add(i);
        }

        auto sum = numbers->reduce([](int a, int b) { return a + b; });
        print(sum);  // Should print: 15

        auto evenNumbers = numbers->where([](int x) { return x % 2 == 0; });
        print(evenNumbers->get_length());  // Should print: 2

        auto squares = numbers->map<int>([](int x) { return x * x; });
        squares->forEach([](int x) { print(x); });  // Should print: 1, 4, 9, 16, 25
    }
};

int main() {
    auto test = MyTest::_new_0();
    test->testContainers();
    return 0;
} 
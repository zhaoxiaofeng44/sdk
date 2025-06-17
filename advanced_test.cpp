#include "containers.hpp"
#include <iostream>

class Person {
private:
    String* name;
    int age;
    List<String*>* hobbies;
    Map<String*, String*>* attributes;

public:
    Person(String* name, int age) : name(name), age(age) {
        hobbies = new List<String*>();
        attributes = new Map<String*, String*>();
    }

    static Person* create(const char* name, int age) {
        return new Person(String::fromStdString(name), age);
    }

    void addHobby(const char* hobby) {
        hobbies->add(String::fromStdString(hobby));
    }

    void setAttribute(const char* key, const char* value) {
        attributes->put(String::fromStdString(key), String::fromStdString(value));
    }

    String* getName() const { return name; }
    int getAge() const { return age; }
    List<String*>* getHobbies() const { return hobbies; }
    Map<String*, String*>* getAttributes() const { return attributes; }

    String* toString() const {
        return String::fromStdString("Person(")
            ->operator+(name)
            ->operator+(String::fromStdString(", "))
            ->operator+(String::fromInt(age))
            ->operator+(String::fromStdString(", hobbies: "))
            ->operator+(hobbies->toString())
            ->operator+(String::fromStdString(", attributes: "))
            ->operator+(attributes->toString())
            ->operator+(String::fromStdString(")"));
    }
};

class AdvancedTest {
public:
    void testNestedContainers() {
        // 测试嵌套列表
        std::cout << "Testing nested lists..." << std::endl;
        auto matrix = new List<List<int>*>();
        for (int i = 0; i < 3; i++) {
            auto row = new List<int>();
            for (int j = 0; j < 3; j++) {
                row->add(i * 3 + j);
            }
            matrix->add(row);
        }
        std::cout << "Matrix: " << matrix->toString()->toStdString() << std::endl;

        // 测试Person对象列表
        std::cout << "\nTesting list of Person objects..." << std::endl;
        auto people = new List<Person*>();
        
        auto john = Person::create("John", 25);
        john->addHobby("reading");
        john->addHobby("gaming");
        john->setAttribute("city", "New York");
        john->setAttribute("occupation", "developer");
        people->add(john);

        auto alice = Person::create("Alice", 30);
        alice->addHobby("painting");
        alice->addHobby("gaming");
        alice->setAttribute("city", "Boston");
        alice->setAttribute("occupation", "designer");
        people->add(alice);

        std::cout << "People: " << people->toString()->toStdString() << std::endl;

        // 测试Map嵌套
        std::cout << "\nTesting nested maps..." << std::endl;
        auto cityPeople = new Map<String*, List<Person*>*>();
        for (int i = 0; i < people->length(); i++) {
            auto person = people->get(i);
            auto city = person->getAttributes()->get(String::fromStdString("city"));
            if (!cityPeople->containsKey(city)) {
                cityPeople->put(city, new List<Person*>());
            }
            cityPeople->get(city)->add(person);
        }

        std::cout << "People by city: " << cityPeople->toString()->toStdString() << std::endl;

        // 测试Set操作
        std::cout << "\nTesting set operations..." << std::endl;
        auto johnHobbies = new Set<String*>();
        for (int i = 0; i < john->getHobbies()->length(); i++) {
            johnHobbies->add(john->getHobbies()->get(i));
        }

        auto aliceHobbies = new Set<String*>();
        for (int i = 0; i < alice->getHobbies()->length(); i++) {
            aliceHobbies->add(alice->getHobbies()->get(i));
        }

        auto commonHobbies = johnHobbies->intersection(aliceHobbies);
        std::cout << "Common hobbies: " << commonHobbies->toString()->toStdString() << std::endl;

        // 测试高级List操作
        std::cout << "\nTesting advanced List operations..." << std::endl;
        auto names = people->map<String*>([](Person* p) { return p->getName(); });
        std::cout << "Names: " << names->toString()->toStdString() << std::endl;

        auto adults = people->where([](Person* p) { return p->getAge() >= 25; });
        std::cout << "Adults: " << adults->toString()->toStdString() << std::endl;

        auto totalAge = people->reduce<int>(0, [](int acc, Person* p) { return acc + p->getAge(); });
        std::cout << "Total age: " << totalAge << std::endl;

        auto avgAge = totalAge / people->length();
        std::cout << "Average age: " << avgAge << std::endl;
    }
};

int main() {
    AdvancedTest test;
    test.testNestedContainers();
    return 0;
} 
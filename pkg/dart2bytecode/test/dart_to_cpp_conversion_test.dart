import 'package:test/test.dart';
import '../lib/compile_to_cpp333.dart';

/// Dart 到 C++ 转换测试示例
///
/// 本测试文件展示了 Dart 代码如何通过 compile_to_cpp.dart 转换为 C++ 代码
void main() {
  group('Dart 到 C++ 转换示例', () {
    test('基础类和方法转换', () {
      // 原始 Dart 代码示例
      print('''
=== 原始 Dart 代码 ===
class Calculator {
  int value;
  
  Calculator(this.value);
  
  int add(int other) {
    value += other;
    return value;
  }
  
  int multiply(int factor) {
    value *= factor;
    return value;
  }
  
  String toString() {
    return "Calculator(value: \$value)";
  }
}

void main() {
  var calc = Calculator(10);
  calc.add(5);
  calc.multiply(2);
  print(calc.toString());
}
''');

      // 转换后的 C++ 代码示例
      print('''
=== 转换后的 C++ 代码 ===

// 头文件声明
class Calculator : public Object {
public:
    Int* value;
    
    static Calculator* cppCtr_(Calculator* cppThis, Int* value);
    static Int* add(Calculator* cppThis, Int* other);
    static Int* multiply(Calculator* cppThis, Int* factor);
    static String* cppGet_toString(Calculator* cppThis);
    static Calculator* cppNew();
};

// 实现文件
Calculator* Calculator::cppCtr_(Calculator* cppThis, Int* value) {
    cppThis->value = value;
    return cppThis;
}

Int* Calculator::add(Calculator* cppThis, Int* other) {
    cppThis->value = Int::cpp_add(cppThis->value, other);
    return cppThis->value;
}

Int* Calculator::multiply(Calculator* cppThis, Int* factor) {
    cppThis->value = Int::cpp_multiply(cppThis->value, factor);
    return cppThis->value;
}

String* Calculator::cppGet_toString(Calculator* cppThis) {
    return String::cpp_add(
        String::cppNew("Calculator(value: ", sizeof("Calculator(value: ")),
        String::cpp_add(
            cppToString(cppThis->value),
            String::cppNew(")", sizeof(")"))
        )
    );
}

Calculator* Calculator::cppNew() {
    static void *functionPtrs[] = {
        reinterpret_cast<void *>(&Calculator::cppCtr_),
        reinterpret_cast<void *>(&Calculator::add),
        reinterpret_cast<void *>(&Calculator::multiply),
        reinterpret_cast<void *>(&Calculator::cppGet_toString)
    };
    auto ptr = (Calculator*)malloc(sizeof(Calculator));
    ptr->vtab = functionPtrs;
    return ptr;
}

// 主函数转换
void main() {
    Calculator* calc = Calculator::cppCtr_(Calculator::cppNew(), Int::cppNew(10));
    Calculator::add(calc, Int::cppNew(5));
    Calculator::multiply(calc, Int::cppNew(2));
    print(Calculator::cppGet_toString(calc));
}
''');
    });

    test('泛型类转换示例', () {
      print('''
=== 泛型类 Dart 代码 ===
class Container<T> {
  T? item;
  
  Container(this.item);
  
  void setItem(T newItem) {
    item = newItem;
  }
  
  T? getItem() {
    return item;
  }
}

var stringContainer = Container<String>("Hello");
var intContainer = Container<int>(42);
''');

      print('''
=== 转换后的泛型 C++ 代码 ===
template<typename T>
class Container : public Object {
public:
    T * item;
    
    static Container<T>* cppCtr_(Container<T>* cppThis, T * item);
    static void setItem(Container<T>* cppThis, T * newItem);
    static T * getItem(Container<T>* cppThis);
    static Container<T>* cppNew();
};

template<typename T>
Container<T>* Container<T>::cppCtr_(Container<T>* cppThis, T * item) {
    cppThis->item = item;
    return cppThis;
}

template<typename T>
void Container<T>::setItem(Container<T>* cppThis, T * newItem) {
    cppThis->item = newItem;
}

template<typename T>
T * Container<T>::getItem(Container<T>* cppThis) {
    return cppThis->item;
}

// 使用示例
Container<String>* stringContainer = Container<String>::cppCtr_(
    Container<String>::cppNew(), 
    String::cppNew("Hello", sizeof("Hello"))
);

Container<Int>* intContainer = Container<Int>::cppCtr_(
    Container<Int>::cppNew(),
    Int::cppNew(42)
);
''');
    });

    test('继承和多态转换示例', () {
      print('''
=== 继承 Dart 代码 ===
abstract class Animal {
  String name;
  Animal(this.name);
  String makeSound();
}

class Dog extends Animal {
  Dog(String name) : super(name);
  
  @override
  String makeSound() {
    return "\$name says Woof!";
  }
}

class Cat extends Animal {
  Cat(String name) : super(name);
  
  @override
  String makeSound() {
    return "\$name says Meow!";
  }
}
''');

      print('''
=== 转换后的继承 C++ 代码 ===
class Animal : public Object {
public:
    String* name;
    
    static Animal* cppCtr_(Animal* cppThis, String* name);
    static String* makeSound(Animal* cppThis);
    static Animal* cppNew();
};

class Dog : virtual public Animal {
public:
    static Dog* cppCtr_(Dog* cppThis, String* name);
    static String* makeSound(Dog* cppThis);
    static Dog* cppNew();
};

class Cat : virtual public Animal {
public:
    static Cat* cppCtr_(Cat* cppThis, String* name);
    static String* makeSound(Cat* cppThis);
    static Cat* cppNew();
};

// Dog 实现
Dog* Dog::cppCtr_(Dog* cppThis, String* name) {
    Animal::cppCtr_(cppThis, name);
    return cppThis;
}

String* Dog::makeSound(Dog* cppThis) {
    return String::cpp_add(
        String::cpp_add(cppThis->name, String::cppNew(" says ", sizeof(" says "))),
        String::cppNew("Woof!", sizeof("Woof!"))
    );
}

// Cat 实现
String* Cat::makeSound(Cat* cppThis) {
    return String::cpp_add(
        String::cpp_add(cppThis->name, String::cppNew(" says ", sizeof(" says "))),
        String::cppNew("Meow!", sizeof("Meow!"))
    );
}
''');
    });

    test('闭包和函数对象转换示例', () {
      print('''
=== 闭包 Dart 代码 ===
void main() {
  int multiplier = 2;
  var numbers = [1, 2, 3, 4, 5];
  
  var doubled = numbers.map((x) => x * multiplier).toList();
  
  Function makeAdder(int addValue) {
    return (int x) => x + addValue;
  }
  
  var add10 = makeAdder(10);
  print(add10(5)); // 输出 15
}
''');

      print('''
=== 转换后的闭包 C++ 代码 ===
void main() {
    Int* multiplier = Int::cppNew(2);
    List<Int>* numbers = CppNewList(Int, 
        Int::cppNew(1), Int::cppNew(2), Int::cppNew(3), 
        Int::cppNew(4), Int::cppNew(5)
    );
    
    // 闭包转换为 lambda 表达式，捕获外部变量
    auto lambda = [&](Int* x) -> Int* {
        return Int::cpp_multiply(x, multiplier);
    };
    
    List<Int>* doubled = List<Int>::map(numbers, 
        new ClosureWrapper<Int*, Int*>(lambda)
    );
    
    // 函数工厂转换
    auto makeAdder = [&](Int* addValue) -> ClosureWrapper<Int*, Int*>* {
        return new ClosureWrapper<Int*, Int*>([addValue](Int* x) -> Int* {
            return Int::cpp_add(x, addValue);
        });
    };
    
    ClosureWrapper<Int*, Int*>* add10 = makeAdder(Int::cppNew(10));
    print(add10->apply(Int::cppNew(5))); // 输出 15
}
''');
    });

    test('运算符重载转换示例', () {
      print('''
=== 运算符重载 Dart 代码 ===
class Point {
  double x, y;
  
  Point(this.x, this.y);
  
  Point operator +(Point other) {
    return Point(x + other.x, y + other.y);
  }
  
  bool operator ==(Object other) {
    return other is Point && x == other.x && y == other.y;
  }
  
  Point operator [](int index) {
    return index == 0 ? Point(x, 0) : Point(0, y);
  }
}
''');

      print('''
=== 转换后的运算符 C++ 代码 ===
class Point : public Object {
public:
    Double* x;
    Double* y;
    
    static Point* cppCtr_(Point* cppThis, Double* x, Double* y);
    static Point* cpp_add(Point* cppThis, Point* other);
    static Bool* cpp_equals(Point* cppThis, Object* other);
    static Point* cpp_subscript(Point* cppThis, Int* index);
    static Point* cppNew();
};

Point* Point::cpp_add(Point* cppThis, Point* other) {
    return Point::cppCtr_(Point::cppNew(),
        Double::cpp_add(cppThis->x, other->x),
        Double::cpp_add(cppThis->y, other->y)
    );
}

Bool* Point::cpp_equals(Point* cppThis, Object* other) {
    Point* otherPoint = reinterpret_cast<Point*>(other);
    return Bool::cppNew(
        Bool::cpp_and(
            Double::cpp_equals(cppThis->x, otherPoint->x),
            Double::cpp_equals(cppThis->y, otherPoint->y)
        )->value
    );
}

Point* Point::cpp_subscript(Point* cppThis, Int* index) {
    return (Int::cpp_equals(index, Int::cppNew(0))->value) ?
        Point::cppCtr_(Point::cppNew(), cppThis->x, Double::cppNew(0.0)) :
        Point::cppCtr_(Point::cppNew(), Double::cppNew(0.0), cppThis->y);
}
''');
    });
  });
}

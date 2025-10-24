# 面向对象编程语法特性测试

## 概述

本目录包含全面的面向对象编程（OOP）语法特性测试，使用 `pkg/dart2bytecode/base/object.h` 中定义的类型系统。

## 文件结构

```
test/
├── oop_comprehensive_test_base.cpp  # 主测试文件
├── Makefile                         # 编译配置
└── README.md                        # 本文件
```

## 测试内容

测试覆盖以下OOP特性：

### 核心概念
- ✅ 类（Class）和对象（Instance）
- ✅ 属性/字段（Field）
- ✅ 方法（Method）
- ✅ 构造函数（Constructor）
- ✅ 析构函数（Destructor）
- ✅ 访问修饰符（public/private/protected）

### 继承和多态
- ✅ 继承（Inheritance）
- ✅ 方法重写（Overriding）
- ✅ 方法重载（Overloading）
- ✅ 抽象类（Abstract Class）
- ✅ 接口（Interface）
- ✅ 多态（Polymorphism）
- ✅ super/父类调用

### 高级特性
- ✅ 静态成员（Static）
- ✅ 泛型（Generics/Templates）
- ✅ 运算符重载
- ✅ 异常处理（try/catch/throw）
- ✅ RTTI/instanceof
- ✅ 对象比较（equals/==）
- ✅ toString()方法
- ✅ 属性（getter/setter）
- ✅ 引用计数/智能指针

## 编译和运行

### 编译测试

```bash
cd /Users/alsc/MyProject/sdk/mydart/sdk/test
make
```

### 运行测试

```bash
./oop_comprehensive_test
```

### 清理

```bash
make clean
```

## 测试示例

### 1. 类和对象
```cpp
Person person1(String("张三"), Int(25));
person1.introduce();  // 输出: 我是 张三，今年 25 岁
```

### 2. 继承
```cpp
Student student(String("周八"), Int(20), String("清华大学"), Double(3.8));
student.introduce();  // 输出学生信息
```

### 3. 多态
```cpp
Shape* shapes[2];
shapes[0] = new Circle(String("紫色"), Double(4.0));
shapes[1] = new Rectangle(String("橙色"), Double(3.0), Double(5.0));
for (int i = 0; i < 2; i++) {
    std::cout << shapes[i]->getArea().toDouble() << std::endl;
}
```

### 4. 泛型
```cpp
Box<Int> intBox(Int(42));
Box<String> stringBox(String("Hello"));
std::cout << intBox.getValue().toInt() << std::endl;
```

### 5. 异常处理
```cpp
try {
    Int result = Calculator::divide(Int(10), Int(0));
} catch (const std::runtime_error& e) {
    std::cout << "捕获异常: " << e.what() << std::endl;
}
```

## 测试类说明

### Person 类
- 基础类，包含姓名和年龄
- 演示构造函数、析构函数、getter/setter
- 实现toString()和equals()方法

### Student 类
- 继承自Person
- 添加学校和GPA属性
- 重写introduce()和toString()方法

### Shape 类（抽象类）
- 定义纯虚函数getArea()和getPerimeter()
- 演示抽象类概念

### Circle 和 Rectangle 类
- 继承自Shape
- 实现Drawable接口
- 演示多态和接口实现

### MathUtils 类
- 演示静态成员和静态方法
- 包含静态常量PI和E

### Box<T> 类
- 泛型容器类
- 演示模板编程

### Vector2D 类
- 演示运算符重载
- 实现+、-、*运算符

### Account 类
- 演示封装和属性
- 包含业务逻辑验证

### Calculator 类
- 演示异常处理
- 静态工具方法

## 测试输出

成功运行后，您将看到：

```
========================================
面向对象编程语法特性全面测试
========================================

=== 测试1: 类和对象 ===
我是 张三，今年 25 岁
我是 李四，今年 30 岁

=== 测试2: 继承 ===
我是学生 周八，今年 20 岁，就读于 清华大学，GPA: 3.8

...

========================================
所有测试完成！
========================================
```

## 依赖

- C++17 或更高版本
- g++ 编译器
- `pkg/dart2bytecode/base/object.h` 和 `object.cpp`

## 注意事项

1. 确保已正确编译 `object.cpp`
2. 测试使用相对路径引用头文件
3. 所有测试都应该成功通过，无异常退出

## 扩展测试

您可以基于此测试框架添加更多测试：

1. 添加新的测试类
2. 实现更多OOP特性
3. 测试边界条件和错误情况
4. 添加性能测试

## 相关文档

- `/Users/alsc/MyProject/sdk/mydart/sdk/doc/OOP_TEST_COVERAGE.md` - 详细的特性覆盖报告
- `pkg/dart2bytecode/base/README.md` - 对象系统文档

## 许可

与主项目相同的许可证。

## 迭代器测试

### 概述

`iterator_test.cpp` 测试迭代器包装类的功能，包括 `ListIterator`、`SetIterator` 和 `MapIterator`。

### 编译和运行

```bash
make iterator_test
./iterator_test
```

或者：

```bash
make run_iterator
```

### 测试内容

1. **List迭代器测试**
   - 基本遍历
   - forEach方法

2. **Set迭代器测试**
   - 基本遍历
   - forEach方法

3. **Map迭代器测试**
   - 键值对遍历
   - forEach方法

4. **异常处理测试**
   - 边界检查
   - 异常捕获

5. **算法结合测试**
   - 累加计算
   - 条件过滤
   - 数据转换

6. **迭代器重用测试**
   - 多次创建迭代器
   - 独立遍历

### 迭代器特性

- ✅ 不暴露C++原始迭代器
- ✅ 类型安全
- ✅ 自动边界检查
- ✅ 支持Lambda表达式
- ✅ 简洁的API

### 示例

```cpp
// List迭代器
List<Int> list;
list.add(Int(10));
list.add(Int(20));

ListIterator<Int> iter = list.iterator();
while (iter.hasNext().value) {
    std::cout << iter.next().toInt() << std::endl;
}

// forEach方法
list.forEach([](const Int& value) {
    std::cout << value.toInt() << std::endl;
});
```

详细文档请参考：`doc/ITERATOR_GUIDE.md`

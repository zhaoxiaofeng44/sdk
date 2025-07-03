# Dart to C++ 代码生成规范
需要做一个能转换dart语言到c++语言的转换器，生成过程中忽略任何地方的范型，如果无法推断准确类型，则直接用Object类型表示
## 0.生成要求
  0.1 不要改任何生成后的c++代码，改了也没有意义
  0.2 修改代码都只修改lib/compile_to_cpp.dart里代码
  0.3 不要随意联想增加不存在的逻辑，要更为严格准确
  0.4 基础库里的通过bool isHideClass(Class cls) 判断，如果hide则就不转换，如果基类是hide的，就认为继承自Object
## 1. 类生成规则

### 1.1 抽象类生成规则
- 对于每个抽象类，需要生成两个对应的C++定义：
  - 一个接口（使用struct定义）
  - 一个实现类（使用class定义）

例如，对于抽象类 `ListBase`：

```dart
// 接口定义
abstract class ListBase {
  public:

    ReturnType MethodName(Parameters){
      //xxx
    };
    void transformChildren(Transformer v);
};

// 实现类定义
```

```cpp
// 接口定义
struct ListBase {
  public:
    virtual ReturnType* MethodName(Parameters) noexcept = 0;

    virtual void transformChildren(Transformer v) noexcept = 0;
    
};

// 实现类定义
class ListBaseImp : virtual public Object, virtual public ListBase {
  public:
    virtual void transformChildren(Transformer* v) noexcept override;
    virtual ~ListBaseImp() noexcept = default;
};

void ListBaseImp::transformChildren(Transformer* v){
  //xxxx
}

```


### 1.2 继承规则
- 所有的基类都应该使用virtual继承
- 实现类应该同时继承自BaseClass和对应的接口
- 使用virtual关键字避免多个机场继承问题
- 对于基类时抽象类情况，如果通过extends继承，则继承ListBaseImp这种实现类，如果通过implements继承，则继承ListBase这种接口类型
```cpp
class DerivedClass : virtual public BaseClass, virtual public BaseInterface {
```

### 1.3 方法生成规则
- 所有方法都必须添加noexcept说明符
- 所有虚函数都必须声明为virtual
- 重写方法必须使用override关键字
- 析构函数必须声明为virtual并设为default
```cpp
virtual ReturnType* MethodName(Parameters) noexcept override;
virtual ~ClassName() noexcept = default;
```

## 2. 命名规范

### 2.1 构造函数命名
- 构造函数使用cppCtr_前缀
- 基本构造函数：`cppCtr_`
- 带参数构造函数：`cppCtr_paramName`
```cpp
virtual ClassName* cppCtr_() noexcept;
virtual ClassName* cppCtr_withParam(Type* param) noexcept;
```

### 2.2 Getter/Setter命名
- Getter方法前缀：`cppGet_`
- Setter方法前缀：`cppSet_`
```cpp
virtual ReturnType* cppGet_propertyName() noexcept;
virtual void* cppSet_propertyName(Type* value) noexcept;
```

### 2.3 操作符重载方法命名
- equals: `equalsImpl`
- hashCode: `hashCodeImpl`
- toString: `toStringImpl`
- 其他操作符应该映射到具体的方法名

## 3. 参数和返回值规则

### 3.1 指针使用
- 所有的对象类型都使用指针
- 基本类型（Int、Bool等）也使用指针
```cpp
virtual ReturnType* MethodName(Type* param) noexcept;
```

### 3.2 参数列表格式化
- 当参数列表过长时，每个参数独占一行
- 参数缩进对齐
```cpp
virtual ReturnType* LongMethodName(
    Type1* param1,
    Type2* param2,
    Type3* param3) noexcept;
```

## 4. 文件组织

### 4.1 头文件结构
- 包含必要的头文件
- 前向声明
- 接口定义（struct）
- 实现类定义（class）
- 使用include保护
```cpp
#ifndef OUTPUT_H
#define OUTPUT_H

#include <required_headers>

// Forward declarations

// Interface definitions (struct)

// Implementation class definitions (class)

#endif  // OUTPUT_H
```

## 5. 特殊处理

### 5.1 抽象方法
- 在接口中声明为纯虚函数
- 在实现类中提供具体实现
```cpp
// In interface
virtual ReturnType* Method() noexcept = 0;

// In implementation
virtual ReturnType* Method() noexcept override;
```

### 5.2 静态方法
- 使用static关键字
- 通常用于工厂方法
```cpp
static ClassName* cppNew() noexcept;
```

## 6. 错误处理
- 所有方法都应该是noexcept
- 使用返回值而不是异常来处理错误情况
- 必要时使用特殊的错误返回类型

## 7. 内存管理
- 使用指针管理对象
- 析构函数应该声明为virtual
- 基类析构函数应该设置为default
```cpp
virtual ~ClassName() noexcept = default;
```

## 8. 代码格式化
- 使用2空格缩进
- 在运算符前后添加空格
- 在逗号后添加空格
- 大括号使用新行
- 注释使用标准C++风格
```cpp
// 单行注释
/* 多行
   注释 */
``` 

## 9. 代码测试
- 执行dart run lib/dart2bytecode.dart 
- 然后读取 output.h output.cpp
- 判断是否符合c++语法
- 判断是否符合eslint
- 使用命令运行判断 g++ -std=c++17 -c output.cpp -I/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/src
- 如果有问题，修复dart转到c++ 重新验证

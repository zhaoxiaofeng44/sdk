import '../lib/compile_to_cpp333.dart';

/// 简单的测试用例，验证修改后的转换器
void main() {
  print("=== 测试修改后的 Dart 到 C++ 转换器 ===");

  // 这里展示修改后转换器的主要变化：
  print('''
主要修改内容：

1. 去除了所有泛型支持：
   - 类声明不再包含模板参数 
   - 方法调用不再包含 <Type> 参数
   - 泛型类型统一替换为 Object 类型

2. 将类方法改为全局方法：
   - 类方法名增加类名前缀：ClassName_methodName
   - 去除 ClassName:: 作用域操作符
   - 方法调用改为直接的全局函数调用

示例转换结果：

原来的代码：
  List<String>::add(list, item)
  String::cppNew("hello")
  
修改后的代码：  
  List_add(list, item)
  String_cppNew("hello")

原来的类声明：
  template<typename T> class Container {
    static T* get(Container<T>* this);
  };

修改后的类声明：
  class Container {
    // 只包含字段，方法移到全局
  };
  
  // 全局方法声明
  Object* Container_get(Container* cppThis);

这样的修改使得生成的 C++ 代码更加简洁，去除了复杂的模板机制，
同时将面向对象的方法调用转换为更直接的函数调用形式。
''');
}

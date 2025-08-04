// 测试 @pragma 注解处理

// 这个类应该被跳过，不进行转换
@pragma('cpp:native', 'MyNativeClass')
class MyNativeClass {
  int value = 42;
  
  void nativeMethod() {
    print('This is a native method');
  }
}

// 这个类应该替换所有 Error 引用为 CustomError
@pragma('cpp:patch', 'Error')
class CustomError {
  String message;
  
  CustomError(this.message);
  
  void throwError() {
    throw ArgumentError('Custom error: $message');
  }
}

// 普通类，应该正常转换
class NormalClass {
  int data = 100;
  
  void processData() {
    // 这里使用了 Error，应该被替换为 CustomError
    if (data < 0) {
      throw ArgumentError('Invalid data');
    }
  }
  
  void createError() {
    // 这里也使用了 Error，应该被替换为 CustomError
    Error error = ArgumentError('Test error');
    print(error.toString());
  }
} 
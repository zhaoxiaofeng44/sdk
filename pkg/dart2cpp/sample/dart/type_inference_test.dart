void main() {
  // 测试类型推断
  print("=== 类型推断测试 ===");
  
  // 整数变量 + 浮点数变量 -> 不进行自动转换，保持原类型
  int intVal = 10;
  double doubleVal = 3.14;
  // var result1 = intVal + doubleVal;  // 这应该报错，不支持混合类型变量运算
  print("int variable + double variable: not supported");
  
  // 整数字面量 + 浮点数变量 -> 字面量转换为 double
  var result2 = 5 + doubleVal;  // 5 应该被转换为 dart_double(5.0)
  print("literal int + double variable = $result2");
  
  // 浮点数变量 + 整数字面量 -> 字面量转换为 double  
  var result3 = doubleVal + 10;  // 10 应该被转换为 dart_double(10.0)
  print("double variable + literal int = $result3");
  
  // 整数变量 + 整数字面量 -> 保持 int
  var result4 = intVal + 20;
  print("int variable + int literal = $result4");
  
  // 整数字面量 + 整数字面量 -> 保持 int
  var result5 = 15 + 25;
  print("int literal + int literal = $result5");
  
  // 字符串连接
  String name = "World";
  var greeting = "Hello " + name;
  print("String concat: $greeting");
}
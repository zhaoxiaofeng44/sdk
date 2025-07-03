import 'list.dart';

void main() {
  print('开始测试 CppStringBuffer...\n');

  // 测试基本write操作
  testBasicWrite();

  // 测试writeAll操作
  testWriteAll();

  // 测试writeCharCode操作
  testWriteCharCode();

  // 测试writeln操作
  testWriteln();

  // 测试clear操作
  testClear();

  // 测试length属性
  testLength();

  // 测试isEmpty/isNotEmpty
  testEmptyChecks();

  // 测试fromCppString构造函数
  testFromCppString();

  print('所有测试完成！');
}

void testBasicWrite() {
  print('=== 测试基本write操作 ===');

  var sb = CppStringBuffer();
  sb.write("Hello");
  sb.write(" ");
  sb.write("World");
  sb.write("!");

  var result = sb.toString();
  print('write(): ${result == "Hello World!" ? '✓' : '✗'}');
  print('结果: "$result"');

  print('');
}

void testWriteAll() {
  print('=== 测试writeAll操作 ===');

  var sb = CppStringBuffer();
  sb.writeAll(["Hello", "World", "Dart"], " ");

  var result = sb.toString();
  print('writeAll(): ${result == "Hello World Dart" ? '✓' : '✗'}');
  print('结果: "$result"');

  // 测试无分隔符
  var sb2 = CppStringBuffer();
  sb2.writeAll(["A", "B", "C"]);

  var result2 = sb2.toString();
  print('writeAll(无分隔符): ${result2 == "ABC" ? '✓' : '✗'}');
  print('结果: "$result2"');

  print('');
}

void testWriteCharCode() {
  print('=== 测试writeCharCode操作 ===');

  var sb = CppStringBuffer();
  sb.writeCharCode(72); // 'H'
  sb.writeCharCode(101); // 'e'
  sb.writeCharCode(108); // 'l'
  sb.writeCharCode(108); // 'l'
  sb.writeCharCode(111); // 'o'

  var result = sb.toString();
  print('writeCharCode(): ${result == "Hello" ? '✓' : '✗'}');
  print('结果: "$result"');

  print('');
}

void testWriteln() {
  print('=== 测试writeln操作 ===');

  var sb = CppStringBuffer();
  sb.writeln("Hello");
  sb.writeln("World");
  sb.writeln(); // 空行

  var result = sb.toString();
  print('writeln(): ${result == "Hello\nWorld\n\n" ? '✓' : '✗'}');
  print('结果: "$result"');

  print('');
}

void testClear() {
  print('=== 测试clear操作 ===');

  var sb = CppStringBuffer();
  sb.write("Hello World");

  print('clear前: ${sb.toString()}');
  print('clear前长度: ${sb.length}');

  sb.clear();

  print('clear后: ${sb.toString()}');
  print('clear后长度: ${sb.length}');
  print('clear(): ${sb.toString() == "" && sb.length == 0 ? '✓' : '✗'}');

  print('');
}

void testLength() {
  print('=== 测试length属性 ===');

  var sb = CppStringBuffer();
  sb.write("Hello");
  sb.write(" ");
  sb.write("World");

  var expectedLength = "Hello World".length;
  print('length: ${sb.length == expectedLength ? '✓' : '✗'}');
  print('实际长度: ${sb.length}, 期望长度: $expectedLength');

  print('');
}

void testEmptyChecks() {
  print('=== 测试isEmpty/isNotEmpty ===');

  var sb = CppStringBuffer();
  print('初始状态 - isEmpty: ${sb.isEmpty}, isNotEmpty: ${sb.isNotEmpty}');

  sb.write("Hello");
  print('添加内容后 - isEmpty: ${sb.isEmpty}, isNotEmpty: ${sb.isNotEmpty}');

  sb.clear();
  print('clear后 - isEmpty: ${sb.isEmpty}, isNotEmpty: ${sb.isNotEmpty}');

  print('isEmpty/isNotEmpty: ${sb.isEmpty && !sb.isNotEmpty ? '✓' : '✗'}');

  print('');
}

void testFromCppString() {
  print('=== 测试fromCppString构造函数 ===');

  var sb = CppStringBuffer.fromCppString("Initial");
  sb.write(" ");
  sb.write("Content");

  var result = sb.toString();
  print('fromCppString(): ${result == "Initial Content" ? '✓' : '✗'}');
  print('结果: "$result"');

  print('');
}

void testComplexScenario() {
  print('=== 测试复杂场景 ===');

  var sb = CppStringBuffer();
  sb.write("开始");
  sb.writeAll(["Hello", "World"], " ");
  sb.writeCharCode(33); // '!'
  sb.writeln();
  sb.write("结束");

  var result = sb.toString();
  print('复杂场景: ${result == "开始Hello World !\n结束" ? '✓' : '✗'}');
  print('结果: "$result"');
  print('总长度: ${sb.length}');

  print('');
}

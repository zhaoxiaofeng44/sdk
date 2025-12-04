/// 异常处理测试用例
/// 
/// 测试Dart异常处理特性，包括：
/// - 基本异常捕获
/// - 自定义异常
/// - 异常链和重新抛出
/// - finally 块
/// - 异步异常处理

void main() async {
  print('🔥 异常处理测试开始');
  
  // 1. 基本异常处理测试
  testBasicExceptions();
  
  // 2. 自定义异常测试
  testCustomExceptions();
  
  // 3. 异常链测试
  testExceptionChaining();
  
  // 4. finally 块测试
  testFinallyBlocks();
  
  // 5. 异常重新抛出测试
  testRethrowExceptions();
  
  // 6. 异步异常处理测试
  await testAsyncExceptions();
  
  print('✅ 异常处理测试完成');
}

/// 测试基本异常处理
void testBasicExceptions() {
  print('\n📌 测试基本异常处理');
  
  // 捕获所有异常
  try {
    throwGenericException();
  } catch (e) {
    print('  捕获异常: $e');
  }
  
  // 捕获特定异常类型
  try {
    divideByZero(10, 0);
  } on ArgumentError catch (e) {
    print('  捕获参数错误: ${e.message}');
  }
  
  // 捕获多种异常类型
  try {
    accessInvalidIndex([1, 2, 3], 5);
  } on RangeError catch (e) {
    print('  捕获范围错误: ${e.message}');
  } on ArgumentError catch (e) {
    print('  捕获参数错误: ${e.message}');
  } catch (e) {
    print('  捕获其他异常: $e');
  }
  
  // 捕获异常和堆栈跟踪
  try {
    throwWithStackTrace();
  } catch (e, stackTrace) {
    print('  异常: $e');
    print('  堆栈跟踪: ${stackTrace.toString().split('\n').take(2).join('\n')}');
  }
  
  // 内置异常类型测试
  testBuiltInExceptions();
}

/// 测试内置异常类型
void testBuiltInExceptions() {
  print('\n  测试内置异常类型:');
  
  // ArgumentError
  try {
    validateAge(-5);
  } on ArgumentError catch (e) {
    print('    ArgumentError: ${e.message}');
  }
  
  // RangeError
  try {
    List<int> numbers = [1, 2, 3];
    print(numbers[10]);
  } on RangeError catch (e) {
    print('    RangeError: ${e.message}');
  }
  
  // StateError
  try {
    List<int> emptyList = [];
    emptyList.first;
  } on StateError catch (e) {
    print('    StateError: ${e.message}');
  }
  
  // UnsupportedError
  try {
    List<int> fixedList = List.filled(3, 0, growable: false);
    fixedList.add(4);
  } on UnsupportedError catch (e) {
    print('    UnsupportedError: ${e.message}');
  }
  
  // FormatException
  try {
    int.parse('not_a_number');
  } on FormatException catch (e) {
    print('    FormatException: ${e.message}');
  }
  
  // TypeError (通过类型转换错误)
  try {
    dynamic value = 'string';
    int number = value as int;
    print(number);
  } on TypeError catch (e) {
    print('    TypeError: $e');
  }
}

/// 测试自定义异常
void testCustomExceptions() {
  print('\n📌 测试自定义异常');
  
  // 基本自定义异常
  try {
    validateEmail('invalid-email');
  } on InvalidEmailException catch (e) {
    print('  自定义异常: ${e.message}');
    print('  邮箱: ${e.email}');
  }
  
  // 带数据的自定义异常
  try {
    processUser(User('', -1, ''));
  } on ValidationException catch (e) {
    print('  验证异常: ${e.message}');
    print('  字段: ${e.field}');
    print('  值: ${e.value}');
    print('  错误码: ${e.errorCode}');
  }
  
  // 业务逻辑异常
  try {
    var account = BankAccount('12345', 100.0);
    account.withdraw(200.0);
  } on InsufficientFundsException catch (e) {
    print('  余额不足: ${e.message}');
    print('  当前余额: \$${e.currentBalance}');
    print('  尝试提取: \$${e.attemptedAmount}');
  }
  
  // 网络异常
  try {
    simulateNetworkRequest();
  } on NetworkException catch (e) {
    print('  网络异常: ${e.message}');
    print('  状态码: ${e.statusCode}');
    print('  URL: ${e.url}');
  }
  
  // 异常层次结构
  try {
    performDatabaseOperation();
  } on DatabaseException catch (e) {
    print('  数据库异常: ${e.message}');
    if (e is ConnectionException) {
      print('  连接异常 - 主机: ${e.host}');
    } else if (e is QueryException) {
      print('  查询异常 - SQL: ${e.sql}');
    }
  }
}

/// 测试异常链
void testExceptionChaining() {
  print('\n📌 测试异常链');
  
  try {
    performComplexOperation();
  } catch (e) {
    print('  最终异常: $e');
    
    // 打印异常链
    Exception? current = e as Exception?;
    int level = 0;
    while (current != null && level < 5) {
      print('  ${'  ' * level}-> $current');
      level++;
      
      // 如果是自定义异常，获取内部异常
      if (current is ChainedException) {
        current = current.innerException;
      } else {
        break;
      }
    }
  }
}

/// 测试 finally 块
void testFinallyBlocks() {
  print('\n📌 测试 finally 块');
  
  // 正常执行的 finally
  try {
    print('  执行正常操作');
    performNormalOperation();
  } catch (e) {
    print('  捕获异常: $e');
  } finally {
    print('  finally: 清理资源');
  }
  
  // 异常情况的 finally
  try {
    print('  执行异常操作');
    performExceptionOperation();
  } catch (e) {
    print('  捕获异常: $e');
  } finally {
    print('  finally: 无论如何都会执行');
  }
  
  // 资源管理示例
  FileManager? fileManager;
  try {
    fileManager = FileManager('test.txt');
    fileManager.write('Hello World');
    throw Exception('模拟异常');
  } catch (e) {
    print('  文件操作异常: $e');
  } finally {
    fileManager?.close();
    print('  finally: 文件已关闭');
  }
  
  // 嵌套 try-finally
  try {
    try {
      print('  内层操作');
      throw Exception('内层异常');
    } finally {
      print('  内层 finally');
    }
  } catch (e) {
    print('  外层捕获: $e');
  } finally {
    print('  外层 finally');
  }
}

/// 测试异常重新抛出
void testRethrowExceptions() {
  print('\n📌 测试异常重新抛出');
  
  try {
    performOperationWithRethrow();
  } catch (e) {
    print('  最终捕获: $e');
  }
  
  try {
    performOperationWithModifiedRethrow();
  } catch (e) {
    print('  修改后重抛: $e');
  }
  
  // 条件重抛
  try {
    performConditionalRethrow(true);
  } catch (e) {
    print('  条件重抛1: $e');
  }
  
  try {
    performConditionalRethrow(false);
  } catch (e) {
    print('  条件重抛2: $e');
  }
}

/// 测试异步异常处理
Future<void> testAsyncExceptions() async {
  print('\n📌 测试异步异常处理');
  
  // 异步异常捕获
  try {
    await throwAsyncException();
  } catch (e) {
    print('  异步异常: $e');
  }
  
  // Future 异常处理
  try {
    String result = await Future.delayed(
      Duration(milliseconds: 50),
      () => throw Exception('Future异常')
    );
    print('  不应该执行到这里: $result');
  } catch (e) {
    print('  Future异常捕获: $e');
  }
  
  // 异步异常链
  try {
    await asyncOperationChain();
  } catch (e) {
    print('  异步异常链: $e');
  }
  
  // Stream 异常处理
  try {
    await for (int value in errorStream()) {
      print('  Stream值: $value');
    }
  } catch (e) {
    print('  Stream异常: $e');
  }
}

// ============================================================================
// 异常类定义
// ============================================================================

/// 无效邮箱异常
class InvalidEmailException implements Exception {
  final String message;
  final String email;
  
  InvalidEmailException(this.message, this.email);
  
  @override
  String toString() => 'InvalidEmailException: $message';
}

/// 验证异常
class ValidationException implements Exception {
  final String message;
  final String field;
  final dynamic value;
  final int errorCode;
  
  ValidationException(this.message, this.field, this.value, this.errorCode);
  
  @override
  String toString() => 'ValidationException: $message';
}

/// 余额不足异常
class InsufficientFundsException implements Exception {
  final String message;
  final double currentBalance;
  final double attemptedAmount;
  
  InsufficientFundsException(this.message, this.currentBalance, this.attemptedAmount);
  
  @override
  String toString() => 'InsufficientFundsException: $message';
}

/// 网络异常
class NetworkException implements Exception {
  final String message;
  final int statusCode;
  final String url;
  
  NetworkException(this.message, this.statusCode, this.url);
  
  @override
  String toString() => 'NetworkException: $message';
}

/// 数据库异常基类
abstract class DatabaseException implements Exception {
  final String message;
  
  DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
}

/// 连接异常
class ConnectionException extends DatabaseException {
  final String host;
  
  ConnectionException(String message, this.host) : super(message);
  
  @override
  String toString() => 'ConnectionException: $message';
}

/// 查询异常
class QueryException extends DatabaseException {
  final String sql;
  
  QueryException(String message, this.sql) : super(message);
  
  @override
  String toString() => 'QueryException: $message';
}

/// 链式异常
class ChainedException implements Exception {
  final String message;
  final Exception? innerException;
  
  ChainedException(this.message, this.innerException);
  
  @override
  String toString() => 'ChainedException: $message';
}

/// 用户类
class User {
  final String name;
  final int age;
  final String email;
  
  User(this.name, this.age, this.email);
}

/// 银行账户类
class BankAccount {
  final String accountNumber;
  double balance;
  
  BankAccount(this.accountNumber, this.balance);
  
  void withdraw(double amount) {
    if (balance < amount) {
      throw InsufficientFundsException(
        '余额不足',
        balance,
        amount
      );
    }
    balance -= amount;
  }
}

/// 文件管理器
class FileManager {
  final String filename;
  bool _isOpen = true;
  
  FileManager(this.filename);
  
  void write(String content) {
    if (!_isOpen) {
      throw StateError('文件已关闭');
    }
    print('    写入文件 $filename: $content');
  }
  
  void close() {
    _isOpen = false;
    print('    关闭文件: $filename');
  }
}

// ============================================================================
// 辅助函数定义
// ============================================================================

/// 抛出通用异常
void throwGenericException() {
  throw Exception('这是一个通用异常');
}

/// 除零操作
double divideByZero(int a, int b) {
  if (b == 0) {
    throw ArgumentError('除数不能为零');
  }
  return a / b;
}

/// 访问无效索引
int accessInvalidIndex(List<int> list, int index) {
  if (index < 0 || index >= list.length) {
    throw RangeError('索引超出范围: $index');
  }
  return list[index];
}

/// 带堆栈跟踪的异常
void throwWithStackTrace() {
  throw StateError('带堆栈跟踪的异常');
}

/// 验证年龄
void validateAge(int age) {
  if (age < 0) {
    throw ArgumentError('年龄不能为负数');
  }
  if (age > 150) {
    throw ArgumentError('年龄不能超过150');
  }
}

/// 验证邮箱
void validateEmail(String email) {
  if (!email.contains('@')) {
    throw InvalidEmailException('邮箱格式无效', email);
  }
}

/// 处理用户
void processUser(User user) {
  if (user.name.isEmpty) {
    throw ValidationException('姓名不能为空', 'name', user.name, 1001);
  }
  if (user.age < 0) {
    throw ValidationException('年龄不能为负数', 'age', user.age, 1002);
  }
  if (user.email.isEmpty) {
    throw ValidationException('邮箱不能为空', 'email', user.email, 1003);
  }
}

/// 模拟网络请求
void simulateNetworkRequest() {
  throw NetworkException('网络连接失败', 404, 'https://api.example.com');
}

/// 执行数据库操作
void performDatabaseOperation() {
  // 随机选择异常类型
  int random = DateTime.now().millisecondsSinceEpoch % 2;
  if (random == 0) {
    throw ConnectionException('无法连接到数据库', 'localhost:5432');
  } else {
    throw QueryException('SQL语法错误', 'SELECT * FROM users WHERE');
  }
}

/// 执行复杂操作（异常链）
void performComplexOperation() {
  try {
    performMiddleOperation();
  } catch (e) {
    throw ChainedException('复杂操作失败', e as Exception);
  }
}

/// 执行中间操作
void performMiddleOperation() {
  try {
    performLowLevelOperation();
  } catch (e) {
    throw ChainedException('中间操作失败', e as Exception);
  }
}

/// 执行底层操作
void performLowLevelOperation() {
  throw Exception('底层操作失败');
}

/// 执行正常操作
void performNormalOperation() {
  print('    正常操作完成');
}

/// 执行异常操作
void performExceptionOperation() {
  throw Exception('异常操作');
}

/// 带重抛的操作
void performOperationWithRethrow() {
  try {
    throw Exception('原始异常');
  } catch (e) {
    print('  处理异常: $e');
    rethrow; // 重新抛出原异常
  }
}

/// 带修改重抛的操作
void performOperationWithModifiedRethrow() {
  try {
    throw Exception('原始异常');
  } catch (e) {
    print('  处理并修改异常: $e');
    throw Exception('修改后的异常: $e');
  }
}

/// 条件重抛
void performConditionalRethrow(bool shouldRethrow) {
  try {
    throw Exception('条件异常');
  } catch (e) {
    print('  条件处理: $e');
    if (shouldRethrow) {
      rethrow;
    }
    // 如果不重抛，异常被吞掉
  }
}

/// 抛出异步异常
Future<void> throwAsyncException() async {
  await Future.delayed(Duration(milliseconds: 50));
  throw Exception('异步异常');
}

/// 异步操作链
Future<void> asyncOperationChain() async {
  try {
    await Future.delayed(Duration(milliseconds: 50));
    throw Exception('异步链异常');
  } catch (e) {
    throw Exception('异步链包装: $e');
  }
}

/// 错误流
Stream<int> errorStream() async* {
  yield 1;
  yield 2;
  throw Exception('Stream异常');
  yield 3; // 不会执行到这里
}

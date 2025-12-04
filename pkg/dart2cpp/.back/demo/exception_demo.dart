/// 异常处理演示
/// 
/// 测试异常抛出、捕获、自定义异常等异常处理特性

void main() {
  print('🔥 异常处理演示开始');
  
  // 1. 基本异常处理
  testBasicExceptions();
  
  // 2. 自定义异常
  testCustomExceptions();
  
  // 3. 异常链
  testExceptionChaining();
  
  // 4. finally 块
  testFinallyBlocks();
  
  // 5. 异常重新抛出
  testRethrowExceptions();
  
  // 6. 异步异常处理
  testAsyncExceptions();
  
  print('✅ 异常处理演示完成');
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
    print('  堆栈跟踪: ${stackTrace.toString().split('\n').take(3).join('\n')}');
  }
  
  // 内置异常类型
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
    while (current != null) {
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
}

/// 测试异步异常处理
void testAsyncExceptions() async {
  print('\n📌 测试异步异常处理');
  
  // async/await 异常处理
  try {
    String result = await performAsyncOperation(true);
    print('  异步结果: $result');
  } catch (e) {
    print('  异步异常: $e');
  }
  
  // Future 异常处理
  await performAsyncOperation(false)
      .then((result) => print('  Future结果: $result'))
      .catchError((error) => print('  Future异常: $error'));
  
  // 多个异步操作的异常处理
  try {
    List<String> results = await Future.wait([
      performAsyncOperation(false),
      performAsyncOperation(true),
      performAsyncOperation(false),
    ]);
    print('  所有异步结果: $results');
  } catch (e) {
    print('  异步批量异常: $e');
  }
  
  // 超时异常
  try {
    String result = await performSlowAsyncOperation()
        .timeout(Duration(milliseconds: 100));
    print('  超时结果: $result');
  } on TimeoutException catch (e) {
    print('  超时异常: ${e.message}');
  }
}

// ============================================================================
// 异常抛出函数
// ============================================================================

void throwGenericException() {
  throw Exception('这是一个通用异常');
}

int divideByZero(int a, int b) {
  if (b == 0) {
    throw ArgumentError('除数不能为零');
  }
  return a ~/ b;
}

int accessInvalidIndex(List<int> list, int index) {
  if (index < 0 || index >= list.length) {
    throw RangeError.index(index, list, 'index');
  }
  return list[index];
}

void throwWithStackTrace() {
  innerFunction();
}

void innerFunction() {
  throw StateError('内部函数抛出的异常');
}

void validateAge(int age) {
  if (age < 0) {
    throw ArgumentError('年龄不能为负数', 'age');
  }
  if (age > 150) {
    throw ArgumentError('年龄不能超过150岁', 'age');
  }
}

// ============================================================================
// 自定义异常类
// ============================================================================

/// 无效邮箱异常
class InvalidEmailException implements Exception {
  final String message;
  final String email;
  
  const InvalidEmailException(this.message, this.email);
  
  @override
  String toString() => 'InvalidEmailException: $message';
}

/// 验证异常
class ValidationException implements Exception {
  final String message;
  final String field;
  final dynamic value;
  final int errorCode;
  
  const ValidationException(this.message, this.field, this.value, this.errorCode);
  
  @override
  String toString() => 'ValidationException: $message';
}

/// 余额不足异常
class InsufficientFundsException implements Exception {
  final String message;
  final double currentBalance;
  final double attemptedAmount;
  
  const InsufficientFundsException(this.message, this.currentBalance, this.attemptedAmount);
  
  @override
  String toString() => 'InsufficientFundsException: $message';
}

/// 网络异常
class NetworkException implements Exception {
  final String message;
  final int statusCode;
  final String url;
  
  const NetworkException(this.message, this.statusCode, this.url);
  
  @override
  String toString() => 'NetworkException: $message';
}

/// 数据库异常基类
abstract class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
}

/// 连接异常
class ConnectionException extends DatabaseException {
  final String host;
  final int port;
  
  const ConnectionException(String message, this.host, this.port) : super(message);
  
  @override
  String toString() => 'ConnectionException: $message';
}

/// 查询异常
class QueryException extends DatabaseException {
  final String sql;
  
  const QueryException(String message, this.sql) : super(message);
  
  @override
  String toString() => 'QueryException: $message';
}

/// 链式异常
class ChainedException implements Exception {
  final String message;
  final Exception? innerException;
  
  const ChainedException(this.message, [this.innerException]);
  
  @override
  String toString() => 'ChainedException: $message';
}

// ============================================================================
// 辅助类
// ============================================================================

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
  double _balance;
  
  BankAccount(this.accountNumber, this._balance);
  
  double get balance => _balance;
  
  void withdraw(double amount) {
    if (amount > _balance) {
      throw InsufficientFundsException(
        '余额不足，无法提取 \$${amount}',
        _balance,
        amount
      );
    }
    _balance -= amount;
  }
}

/// 文件管理器
class FileManager {
  final String filename;
  bool _isOpen = false;
  
  FileManager(this.filename) {
    _isOpen = true;
    print('    打开文件: $filename');
  }
  
  void write(String content) {
    if (!_isOpen) throw StateError('文件已关闭');
    print('    写入内容: $content');
  }
  
  void close() {
    if (_isOpen) {
      _isOpen = false;
      print('    关闭文件: $filename');
    }
  }
}

// ============================================================================
// 业务逻辑函数
// ============================================================================

void validateEmail(String email) {
  if (!email.contains('@')) {
    throw InvalidEmailException('邮箱格式无效', email);
  }
}

void processUser(User user) {
  if (user.name.isEmpty) {
    throw ValidationException('姓名不能为空', 'name', user.name, 1001);
  }
  if (user.age < 0) {
    throw ValidationException('年龄不能为负数', 'age', user.age, 1002);
  }
  if (!user.email.contains('@')) {
    throw ValidationException('邮箱格式无效', 'email', user.email, 1003);
  }
}

void simulateNetworkRequest() {
  throw NetworkException('网络连接失败', 404, 'https://api.example.com/data');
}

void performDatabaseOperation() {
  // 随机抛出不同类型的数据库异常
  var random = DateTime.now().millisecondsSinceEpoch % 2;
  if (random == 0) {
    throw ConnectionException('无法连接到数据库', 'localhost', 5432);
  } else {
    throw QueryException('SQL语法错误', 'SELECT * FROM users WHERE');
  }
}

void performComplexOperation() {
  try {
    levelOneOperation();
  } catch (e) {
    throw ChainedException('复杂操作失败', e as Exception);
  }
}

void levelOneOperation() {
  try {
    levelTwoOperation();
  } catch (e) {
    throw ChainedException('第一层操作失败', e as Exception);
  }
}

void levelTwoOperation() {
  throw Exception('最底层操作失败');
}

void performNormalOperation() {
  print('    正常操作完成');
}

void performExceptionOperation() {
  throw Exception('操作失败');
}

void performOperationWithRethrow() {
  try {
    throw Exception('原始异常');
  } catch (e) {
    print('  记录异常: $e');
    rethrow; // 重新抛出原始异常
  }
}

void performOperationWithModifiedRethrow() {
  try {
    throw Exception('原始异常');
  } catch (e) {
    print('  处理异常: $e');
    throw Exception('修改后的异常: $e'); // 抛出新异常
  }
}

Future<String> performAsyncOperation(bool shouldFail) async {
  await Future.delayed(Duration(milliseconds: 50));
  
  if (shouldFail) {
    throw Exception('异步操作失败');
  }
  
  return '异步操作成功';
}

Future<String> performSlowAsyncOperation() async {
  await Future.delayed(Duration(milliseconds: 200));
  return '慢异步操作完成';
}
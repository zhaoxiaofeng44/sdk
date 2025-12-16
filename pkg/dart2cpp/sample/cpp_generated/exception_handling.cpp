#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: InvalidEmailException
// ============================================================================

class InvalidEmailException : virtual public Exception {
public:
  String message;
  String email;
  InvalidEmailException(String message, String email) : message(message), email(email) {
  }
  
  String toString() {
    return dart_string("InvalidEmailException: ") + (this->message).toString();
  }
  
};

// ============================================================================
// 类: ValidationException
// ============================================================================

class ValidationException : virtual public Exception {
public:
  String message;
  String field;
  Any value;
  Int errorCode;
  ValidationException(String message, String field, Any value, Int errorCode) : message(message), field(field), value(value), errorCode(errorCode) {
  }
  
  String toString() {
    return dart_string("ValidationException: ") + (this->message).toString();
  }
  
};

// ============================================================================
// 类: InsufficientFundsException
// ============================================================================

class InsufficientFundsException : virtual public Exception {
public:
  String message;
  Double currentBalance;
  Double attemptedAmount;
  InsufficientFundsException(String message, Double currentBalance, Double attemptedAmount) : message(message), currentBalance(currentBalance), attemptedAmount(attemptedAmount) {
  }
  
  String toString() {
    return dart_string("InsufficientFundsException: ") + (this->message).toString();
  }
  
};

// ============================================================================
// 类: NetworkException
// ============================================================================

class NetworkException : virtual public Exception {
public:
  String message;
  Int statusCode;
  String url;
  NetworkException(String message, Int statusCode, String url) : message(message), statusCode(statusCode), url(url) {
  }
  
  String toString() {
    return dart_string("NetworkException: ") + (this->message).toString();
  }
  
};

// ============================================================================
// 类: DatabaseException
// ============================================================================

DART_INTERFACE(DatabaseException)
DART_INTERFACE_END

// ============================================================================
// 类: ConnectionException
// ============================================================================

class ConnectionException : public DatabaseException {
public:
  String host;
  ConnectionException(String message, String host) : host(host), DatabaseException(message) {
  }
  
  String toString() {
    return dart_string("ConnectionException: ") + (this->message).toString();
  }
  
};

// ============================================================================
// 类: QueryException
// ============================================================================

class QueryException : public DatabaseException {
public:
  String sql;
  QueryException(String message, String sql) : sql(sql), DatabaseException(message) {
  }
  
  String toString() {
    return dart_string("QueryException: ") + (this->message).toString();
  }
  
};

// ============================================================================
// 类: ChainedException
// ============================================================================

class ChainedException : virtual public Exception {
public:
  String message;
  ObjectPtr<Exception> innerException;
  ChainedException(String message, ObjectPtr<Exception> innerException) : message(message), innerException(innerException) {
  }
  
  String toString() {
    return dart_string("ChainedException: ") + (this->message).toString();
  }
  
};

// ============================================================================
// 类: User
// ============================================================================

class User {
public:
  String name;
  Int age;
  String email;
  User(String name, Int age, String email) : name(name), age(age), email(email) {
  }
  
};

// ============================================================================
// 类: BankAccount
// ============================================================================

class BankAccount {
public:
  String accountNumber;
  Double balance;
  BankAccount(String accountNumber, Double balance) : accountNumber(accountNumber), balance(balance) {
  }
  
  Nullable withdraw(Double amount) {
    if (this->balance->operator_less(amount)) {
throw DartException(ObjectPtr<InsufficientFundsException>(new InsufficientFundsException(dart_string("余额不足"), this->balance, amount)));
}
this->balance = this->balance->operator_sub(amount);
return Void;
  }
  
};

// ============================================================================
// 类: FileManager
// ============================================================================

class FileManager {
public:
  String filename;
private:
  Bool _isOpen = dart_bool(true);
  FileManager(String filename) : filename(filename) {
  }
  
  Nullable write(String content) {
    if (!(this->_isOpen)) {
throw DartException(ObjectPtr<StateError>(new StateError(dart_string("文件已关闭"))));
}
dart_print(dart_concat(dart_string("    写入文件 "), (this->filename).toString(), dart_string(": "), (content).toString()));
return Void;
  }
  
  Nullable close() {
    this->_isOpen = dart_bool(false);
dart_print(dart_string("    关闭文件: ") + (this->filename).toString());
return Void;
  }
  
};

Nullable testBasicExceptions();
Nullable testBuiltInExceptions();
Nullable testCustomExceptions();
Nullable testExceptionChaining();
Nullable testFinallyBlocks();
Nullable testRethrowExceptions();
ObjectPtr<Future<Nullable>> testAsyncExceptions();
Nullable throwGenericException();
Double divideByZero(Int a, Int b);
Int accessInvalidIndex(ObjectPtr<List<Int>> list, Int index);
Nullable throwWithStackTrace();
Nullable validateAge(Int age);
Nullable validateEmail(String email);
Nullable processUser(ObjectPtr<User> user);
Nullable simulateNetworkRequest();
Nullable performDatabaseOperation();
Nullable performComplexOperation();
Nullable performMiddleOperation();
Nullable performLowLevelOperation();
Nullable performNormalOperation();
Nullable performExceptionOperation();
Nullable performOperationWithRethrow();
Nullable performOperationWithModifiedRethrow();
Nullable performConditionalRethrow(Bool shouldRethrow);
ObjectPtr<Future<Nullable>> throwAsyncException();
ObjectPtr<Future<Nullable>> asyncOperationChain();
ObjectPtr<Stream<Int>> errorStream();
Nullable testBasicExceptions() {
  dart_print(dart_string("\n📌 测试基本异常处理"));
try {
throwGenericException();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
divideByZero(dart_int(10), dart_int(0));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
accessInvalidIndex(dart_literal(dart_int(1), dart_int(2), dart_int(3)), dart_int(5));
} catch (const std::exception& e) { /* catch block */ } catch (const std::exception& e) { /* catch block */ } catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
throwWithStackTrace();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
testBuiltInExceptions();
return Void;
}

Nullable testBuiltInExceptions() {
  dart_print(dart_string("\n  测试内置异常类型:"));
try {
validateAge(dart_int(-5));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3));
dart_print(numbers->operator_index(dart_int(10)));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto emptyList = dart_literal(dart_int(0));
emptyList->first();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto fixedList = _List::filled(dart_int(3), dart_int(0));
fixedList->add(dart_int(4));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
int::parse(dart_string("not_a_number"), Int(Null), nullptr);
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
Any value = dart_string("string");
auto number = dart_cast<Int>(value);
dart_print(number);
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable testCustomExceptions() {
  dart_print(dart_string("\n📌 测试自定义异常"));
try {
validateEmail(dart_string("invalid-email"));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
processUser(ObjectPtr<User>(new User(dart_string(""), dart_int(-1), dart_string(""))));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto account = ObjectPtr<BankAccount>(new BankAccount(dart_string("12345"), dart_double(100.0)));
account->withdraw(dart_double(200.0));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
simulateNetworkRequest();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
performDatabaseOperation();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable testExceptionChaining() {
  dart_print(dart_string("\n📌 测试异常链"));
try {
performComplexOperation();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable testFinallyBlocks() {
  dart_print(dart_string("\n📌 测试 finally 块"));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
ObjectPtr<ObjectPtr<FileManager>> fileManager(nullptr);
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
try { /* try block */ } catch (const std::exception& e) { /* catch block */ };
return Void;
}

Nullable testRethrowExceptions() {
  dart_print(dart_string("\n📌 测试异常重新抛出"));
try {
performOperationWithRethrow();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
performOperationWithModifiedRethrow();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
performConditionalRethrow(dart_bool(true));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
performConditionalRethrow(dart_bool(false));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, testAsyncExceptions, ()) {
    DART_ASYNC_BEGIN
  dart_print(dart_string("\n📌 测试异步异常处理"));
try {
DART_AWAIT(throwAsyncException());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto result = DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), makeFunction([&]() { return throw DartException(Exception::(dart_string("Future异常"))); })));
dart_print(dart_string("  不应该执行到这里: ") + (result).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
DART_AWAIT(asyncOperationChain());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto stream = errorStream();
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    DART_ASYNC_END
}

Nullable throwGenericException() {
  throw DartException(Exception::(dart_string("这是一个通用异常")));
return Void;
}

Double divideByZero(Int a, Int b) {
  if ((b == dart_int(0))) {
throw DartException(ObjectPtr<ArgumentError>(new ArgumentError(dart_string("除数不能为零"), String(Null))));
}
return a->operator_div(b);
}

Int accessInvalidIndex(ObjectPtr<List<Int>> list, Int index) {
  if (index->operator_less(dart_int(0)) || index->operator_greater_equals(list->size())) {
throw DartException(ObjectPtr<RangeError>(new RangeError(dart_string("索引超出范围: ") + (index).toString())));
}
return list->operator_index(index);
}

Nullable throwWithStackTrace() {
  throw DartException(ObjectPtr<StateError>(new StateError(dart_string("带堆栈跟踪的异常"))));
return Void;
}

Nullable validateAge(Int age) {
  if (age->operator_less(dart_int(0))) {
throw DartException(ObjectPtr<ArgumentError>(new ArgumentError(dart_string("年龄不能为负数"), String(Null))));
}
if (age->operator_greater(dart_int(150))) {
throw DartException(ObjectPtr<ArgumentError>(new ArgumentError(dart_string("年龄不能超过150"), String(Null))));
};
return Void;
}

Nullable validateEmail(String email) {
  if (!(email->contains(dart_string("@")))) {
throw DartException(ObjectPtr<InvalidEmailException>(new InvalidEmailException(dart_string("邮箱格式无效"), email)));
};
return Void;
}

Nullable processUser(ObjectPtr<User> user) {
  if (user->name->isEmpty()) {
throw DartException(ObjectPtr<ValidationException>(new ValidationException(dart_string("姓名不能为空"), dart_string("name"), user->name, dart_int(1001))));
}
if (user->age->operator_less(dart_int(0))) {
throw DartException(ObjectPtr<ValidationException>(new ValidationException(dart_string("年龄不能为负数"), dart_string("age"), user->age, dart_int(1002))));
}
if (user->email->isEmpty()) {
throw DartException(ObjectPtr<ValidationException>(new ValidationException(dart_string("邮箱不能为空"), dart_string("email"), user->email, dart_int(1003))));
};
return Void;
}

Nullable simulateNetworkRequest() {
  throw DartException(ObjectPtr<NetworkException>(new NetworkException(dart_string("网络连接失败"), dart_int(404), dart_string("https://api.example.com"))));
return Void;
}

Nullable performDatabaseOperation() {
  auto random = ObjectPtr<DateTime>(new DateTime())->millisecondsSinceEpoch()->operator_mod(dart_int(2));
if ((random == dart_int(0))) {
throw DartException(ObjectPtr<ConnectionException>(new ConnectionException(dart_string("无法连接到数据库"), dart_string("localhost:5432"))));
} else {
throw DartException(ObjectPtr<QueryException>(new QueryException(dart_string("SQL语法错误"), dart_string("SELECT * FROM users WHERE"))));
};
return Void;
}

Nullable performComplexOperation() {
  try {
performMiddleOperation();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable performMiddleOperation() {
  try {
performLowLevelOperation();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable performLowLevelOperation() {
  throw DartException(Exception::(dart_string("底层操作失败")));
return Void;
}

Nullable performNormalOperation() {
  dart_print(dart_string("    正常操作完成"));
return Void;
}

Nullable performExceptionOperation() {
  throw DartException(Exception::(dart_string("异常操作")));
return Void;
}

Nullable performOperationWithRethrow() {
  try {
throw DartException(Exception::(dart_string("原始异常")));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable performOperationWithModifiedRethrow() {
  try {
throw DartException(Exception::(dart_string("原始异常")));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable performConditionalRethrow(Bool shouldRethrow) {
  try {
throw DartException(Exception::(dart_string("条件异常")));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, throwAsyncException, ()) {
    DART_ASYNC_BEGIN
  DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), nullptr));
throw DartException(Exception::(dart_string("异步异常")));
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, asyncOperationChain, ()) {
    DART_ASYNC_BEGIN
  try {
DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), nullptr));
throw DartException(Exception::(dart_string("异步链异常")));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Stream<Int>>, errorStream, ()) {
    DART_ASYNC_BEGIN
  co_yield dart_int(1);  // C++20 coroutine
co_yield dart_int(2);  // C++20 coroutine
throw DartException(Exception::(dart_string("Stream异常")));
co_yield dart_int(3);  // C++20 coroutine
    DART_ASYNC_END
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 异常处理测试开始"));
testBasicExceptions();
testCustomExceptions();
testExceptionChaining();
testFinallyBlocks();
testRethrowExceptions();
DART_AWAIT(testAsyncExceptions());
dart_print(dart_string("✅ 异常处理测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}

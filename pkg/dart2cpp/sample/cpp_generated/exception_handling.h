#ifndef _EXCEPTION_HANDLING_H_
#define _EXCEPTION_HANDLING_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class InvalidEmailException;
class ValidationException;
class InsufficientFundsException;
class NetworkException;
class DatabaseException;
class ConnectionException;
class QueryException;
class ChainedException;
class User;
class BankAccount;
class FileManager;
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


#endif // _EXCEPTION_HANDLING_H_

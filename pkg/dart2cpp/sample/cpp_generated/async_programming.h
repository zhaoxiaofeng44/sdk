#ifndef _ASYNC_PROGRAMMING_H_
#define _ASYNC_PROGRAMMING_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
ObjectPtr<Future<Nullable>> testFutureBasics();
ObjectPtr<Future<Nullable>> testAsyncAwait();
ObjectPtr<Future<Nullable>> testFutureCombination();
ObjectPtr<Future<Nullable>> testAsyncErrorHandling();
ObjectPtr<Future<Nullable>> testStreamBasics();
ObjectPtr<Future<Nullable>> testStreamTransformation();
ObjectPtr<Future<Nullable>> testTimers();
ObjectPtr<Future<String>> getGreeting(String name);
ObjectPtr<Future<String>> fetchData(String name, Int delayMs);
ObjectPtr<Future<String>> processNestedAsync();
ObjectPtr<Future<String>> riskyOperation(Bool shouldFail);
ObjectPtr<Future<String>> slowOperation();
ObjectPtr<Future<Nullable>> cascadingAsyncError();
ObjectPtr<Stream<String>> generateMessages();
ObjectPtr<Stream<Int>> generateNumbers(Int count);


#endif // _ASYNC_PROGRAMMING_H_

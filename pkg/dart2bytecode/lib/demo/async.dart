// import 'dart:async';
// import 'dart:collection';
// import 'api.dart';

// // abstract class AsyncTask<T> {
// //   bool get isDone;
// //   T get result;
// //   void start();
// //   void complete();
// // }

// // class SimpleAsyncTask<T> implements AsyncTask<T> {
// //   FutureOr<T> Function(T value) onValue;
// //   Function? onError;
// //   SimpleAsyncTask(this.onValue, this.onError);
// //   @override
// //   bool get isDone => throw UnimplementedError();
// //   @override
// //   T get result => throw UnimplementedError();
// //   @override
// //   void start() => throw UnimplementedError();
// //   @override
// //   void complete() => throw UnimplementedError();
// // }

// // class NativeAsyncTask<T> implements AsyncTask<T> {
// //   CppUserData _taskData;

// //   NativeAsyncTask() : _taskData = native_cppCreateAsyncTask();
// //   @override
// //   bool get isDone => native_cppGetPointerArrayItem(_taskData, 1) as bool;
// //   @override
// //   T get result => native_cppGetPointerArrayItem(_taskData, 2) as T;
// //   @override
// //   void start() {
// //     AsyncQueue.instance.runAsync(this);
// //   }

// //   @override
// //   void complete() {
// //     native_cppCompleteAsyncTask(_taskData);
// //   }

// //   @override
// //   Future<R> then<R>(FutureOr<R> onValue(T value), {Function? onError}) {
// //     return this;
// //   }
// // }
// Future<T> _createAsyncTaskFuture<T>(CppUserData userData) async {
//   await native_cppAwaitAsyncTask(userData);
//   return native_cppGetAsyncTaskResult(userData) as T;
// }

// class AsyncTaskFuture<T> implements Future<T> {
//   Future<T> _future;
//   AsyncTaskFuture(CppUserData userData)
//       : this._future = _createAsyncTaskFuture(userData);
//   @override
//   Stream<T> asStream() {
//     return _future.asStream();
//   }

//   @override
//   Future<T> catchError(Function onError, {bool Function(Object error)? test}) {
//     return _future.asStream();
//   }

//   @override
//   Future<R> then<R>(FutureOr<R> Function(T value) onValue,
//       {Function? onError}) {
//     // TODO: implement then
//     throw UnimplementedError();
//   }

//   @override
//   Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) {
//     // TODO: implement timeout
//     throw UnimplementedError();
//   }

//   @override
//   Future<T> whenComplete(FutureOr<void> Function() action) {
//     // TODO: implement whenComplete
//     throw UnimplementedError();
//   }
// }

// // class AsyncQueue {
// //   final Queue<AsyncTask> _queue = Queue<AsyncTask>();

// //   void runAsync(AsyncTask task) {
// //     _queue.add(task);
// //   }

// //   void tickMainLoop() {
// //     while (_queue.isNotEmpty) {
// //       bool hasDone = false;
// //       for (var task in _queue) {
// //         if (task.isDone) {
// //           _queue.remove(task);
// //           task.complete();
// //           hasDone = true;
// //           break;
// //         }
// //       }
// //       if (!hasDone) {
// //         break;
// //       }
// //     }
// //   }

// //   static AsyncQueue instance = AsyncQueue();
// // }

// // class CppFuture<T> implements Future<T> {
// //   CppFuture._() {
// //     _result = null;
// //     _isDone = false;
// //     _callbacks = {};
// //   }

// //   CppFuture.fromFuture(Future<T> future) {
// //     _result = null;
// //     _isDone = false;
// //     _callbacks = {};
// //     future.then((value) {
// //       _result = value;
// //       _isDone = true;
// //       runCallbacks();
// //     });
// //   }

// //   @override
// //   Future<R> then<R>(FutureOr<R> onValue(T value), {Function? onError}) {
// //     if (_isDone) {
// //       callback(_result);
// //       return;
// //     }
// //     _callbacks.add(callback);
// //     return this;
// //   }

// //   void runCallbacks() {
// //     for (var callback in _callbacks) {
// //       callback(_result);
// //     }
// //     _callbacks.clear();
// //   }

// //   @override
// //   Stream<T> asStream() {
// //     // TODO: implement asStream
// //     throw UnimplementedError();
// //   }

// //   @override
// //   Future<T> catchError(Function onError, {bool Function(Object error)? test}) {
// //     // TODO: implement catchError
// //     throw UnimplementedError();
// //   }

// //   @override
// //   Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) {
// //     // TODO: implement timeout
// //     throw UnimplementedError();
// //   }

// //   @override
// //   Future<T> whenComplete(FutureOr<void> Function() action) {
// //     // TODO: implement whenComplete
// //     throw UnimplementedError();
// //   }
// // }

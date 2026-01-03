#ifndef DART_ASYNC_H
#define DART_ASYNC_H

#include "dart_object.h"
#include "dart_string.h"
#include "dart_helpers.h"
#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>
#include <future>
#include <thread>
#include <chrono>
#include <memory>
#include <functional>
#include <exception>
#include <mutex>
#include <condition_variable>

// ============================================================================
// Dart 异步编程支持 - Future, Completer
// ============================================================================

// Duration类已在dart_helpers.h中定义

/// Future 状态
enum class FutureState {
    PENDING,
    COMPLETED,
    ERROR
};

/// Future 类模板 - 异步结果容器
template<typename T>
class Future : public Object {
private:
    std::shared_ptr<std::mutex> mutex_;
    std::shared_ptr<std::condition_variable> cv_;
    std::shared_ptr<FutureState> state_;
    std::shared_ptr<T> value_;
    std::shared_ptr<std::exception_ptr> error_;
    std::shared_ptr<std::thread> worker_thread_;
    
public:
    Future() 
        : mutex_(std::make_shared<std::mutex>()),
          cv_(std::make_shared<std::condition_variable>()),
          state_(std::make_shared<FutureState>(FutureState::PENDING)),
          value_(std::make_shared<T>()),
          error_(std::make_shared<std::exception_ptr>()) {
        Object::type_id = 5; // Future类型ID
    }
    
    /// 等待结果
    T wait() {
        std::unique_lock<std::mutex> lock(*mutex_);
        cv_->wait(lock, [this]() { return *state_ != FutureState::PENDING; });
        
        if (*state_ == FutureState::ERROR) {
            std::rethrow_exception(*error_);
        }
        return *value_;
    }
    
    /// 带超时的等待
    Bool waitFor(ObjectPtr<Duration> duration) {
        std::unique_lock<std::mutex> lock(*mutex_);
        int ms = duration->get_inMilliseconds().getValue();
        bool completed = cv_->wait_for(lock, std::chrono::milliseconds(ms),
            [this]() { return *state_ != FutureState::PENDING; });
        return Bool(completed);
    }
    
    /// 检查是否完成
    Bool isCompleted() {
        std::lock_guard<std::mutex> lock(*mutex_);
        return Bool(*state_ != FutureState::PENDING);
    }
    
    /// then 操作 - 链式调用（优化版：支持Lambda和函数对象）
    template<typename R, typename CallbackFunc>
    ObjectPtr<Future<R>> then(ObjectPtr<TypedFunction<CallbackFunc, R, T>> callback) {
        ObjectPtr<Future<R>> resultFuture(new Future<R>());
        
        // 创建新线程执行then逻辑
        std::thread([this, callback, resultFuture]() {
            try {
                T value = this->wait();
                R result = (*callback)(value);
                resultFuture->_complete(result);
            } catch (...) {
                resultFuture->_completeError(std::current_exception());
            }
        }).detach();
        
        return resultFuture;
    }
    
    /// then 操作重载 - 直接接受Lambda表达式
    template<typename R>
    ObjectPtr<Future<R>> then(std::function<R(T)> callback) {
        ObjectPtr<Future<R>> resultFuture(new Future<R>());
        
        std::thread([this, callback, resultFuture]() {
            try {
                T value = this->wait();
                R result = callback(value);
                resultFuture->_complete(result);
            } catch (...) {
                resultFuture->_completeError(std::current_exception());
            }
        }).detach();
        
        return resultFuture;
    }
    
    /// catchError 操作 - 错误处理
    template<typename ErrorHandlerFunc>
    ObjectPtr<Future<T>> catchError(ObjectPtr<TypedFunction<ErrorHandlerFunc, T, const std::exception&>> errorHandler) {
        ObjectPtr<Future<T>> resultFuture(new Future<T>());
        
        std::thread([this, errorHandler, resultFuture]() {
            try {
                T value = this->wait();
                resultFuture->_complete(value);
            } catch (const std::exception& e) {
                try {
                    T recoveredValue = (*errorHandler)(e);
                    resultFuture->_complete(recoveredValue);
                } catch (...) {
                    resultFuture->_completeError(std::current_exception());
                }
            } catch (...) {
                resultFuture->_completeError(std::current_exception());
            }
        }).detach();
        
        return resultFuture;
    }
    
    /// catchError 操作重载 - 直接接受Lambda表达式
    ObjectPtr<Future<T>> catchError(std::function<T(const std::exception&)> errorHandler) {
        ObjectPtr<Future<T>> resultFuture(new Future<T>());
        
        std::thread([this, errorHandler, resultFuture]() {
            try {
                T value = this->wait();
                resultFuture->_complete(value);
            } catch (const std::exception& e) {
                try {
                    T recoveredValue = errorHandler(e);
                    resultFuture->_complete(recoveredValue);
                } catch (...) {
                    resultFuture->_completeError(std::current_exception());
                }
            } catch (...) {
                resultFuture->_completeError(std::current_exception());
            }
        }).detach();
        
        return resultFuture;
    }
    
    /// whenComplete 操作 - 无论成功失败都执行
    ObjectPtr<Future<T>> whenComplete(std::function<void()> action) {
        ObjectPtr<Future<T>> resultFuture(new Future<T>());
        
        std::thread([this, action, resultFuture]() {
            try {
                T value = this->wait();
                action();
                resultFuture->_complete(value);
            } catch (...) {
                try {
                    action();
                } catch (...) {
                    // 忽略action中的异常
                }
                resultFuture->_completeError(std::current_exception());
            }
        }).detach();
        
        return resultFuture;
    }
    
    /// 延迟创建
    template<typename ComputationFunc>
    static ObjectPtr<Future<T>> delayed(ObjectPtr<Duration> duration, ObjectPtr<TypedFunction<ComputationFunc, T>> computation) {
        ObjectPtr<Future<T>> future(new Future<T>());
        
        std::thread([future, duration, computation]() {
            int ms = duration->get_inMilliseconds().getValue();
            std::this_thread::sleep_for(std::chrono::milliseconds(ms));
            try {
                T result = (*computation)();
                future->_complete(result);
            } catch (...) {
                future->_completeError(std::current_exception());
            }
        }).detach();
        
        return future;
    }
    
    /// 立即返回值
    static ObjectPtr<Future<T>> value(T val) {
        ObjectPtr<Future<T>> future(new Future<T>());
        future->_complete(val);
        return future;
    }
    
    /// 同步执行函数并返回Future
    template<typename ComputationFunc>
    static ObjectPtr<Future<T>> sync(ObjectPtr<TypedFunction<ComputationFunc, T>> computation) {
        ObjectPtr<Future<T>> future(new Future<T>());
        try {
            T result = (*computation)();
            future->_complete(result);
        } catch (...) {
            future->_completeError(std::current_exception());
        }
        return future;
    }
    
    /// 等待多个Future完成
    static ObjectPtr<List<T>> wait(ObjectPtr<List<ObjectPtr<Future<T>>>> futures) {
        ObjectPtr<List<T>> results = List<T>::create();
        int count = futures->size().getValue();
        
        for (int i = 0; i < count; i++) {
            ObjectPtr<Future<T>> f = futures->get(Int(i));
            T result = f->wait();
            results->add(result);
        }
        
        return results;
    }
    
    /// 等待任意一个Future完成
    static T any(ObjectPtr<List<ObjectPtr<Future<T>>>> futures) {
        int count = futures->size().getValue();
        
        // 使用条件变量等待第一个完成
        std::mutex result_mutex;
        std::condition_variable result_cv;
        bool has_result = false;
        T first_result;
        
        for (int i = 0; i < count; i++) {
            ObjectPtr<Future<T>> f = futures->get(Int(i));
            std::thread([f, &result_mutex, &result_cv, &has_result, &first_result]() {
                try {
                    T result = f->wait();
                    std::lock_guard<std::mutex> lock(result_mutex);
                    if (!has_result) {
                        first_result = result;
                        has_result = true;
                        result_cv.notify_all();
                    }
                } catch (...) {
                    // 忽略错误，继续等待其他Future
                }
            }).detach();
        }
        
        std::unique_lock<std::mutex> lock(result_mutex);
        result_cv.wait(lock, [&has_result]() { return has_result; });
        return first_result;
    }
    
    String toString() const override {
        return String(std::string("Future<") + typeid(T).name() + ">");
    }
    
    // 内部方法：完成Future
    void _complete(T value) {
        std::lock_guard<std::mutex> lock(*mutex_);
        if (*state_ == FutureState::PENDING) {
            *value_ = value;
            *state_ = FutureState::COMPLETED;
            cv_->notify_all();
        }
    }
    
    // 内部方法：错误完成
    void _completeError(std::exception_ptr error) {
        std::lock_guard<std::mutex> lock(*mutex_);
        if (*state_ == FutureState::PENDING) {
            *error_ = error;
            *state_ = FutureState::ERROR;
            cv_->notify_all();
        }
    }
};

// ============================================================================
// Completer - 手动控制Future完成
// ============================================================================

template<typename T>
class Completer : public Object {
private:
    ObjectPtr<Future<T>> future_;
    
public:
    Completer() : future_(new Future<T>()) {
        Object::type_id = 6; // Completer类型ID
    }
    
    /// 创建Completer
    static ObjectPtr<Completer<T>> create() {
        return ObjectPtr<Completer<T>>(new Completer<T>());
    }
    
    /// 默认构造函数的静态调用方式
    static ObjectPtr<Completer<T>> make() {
        return create();
    }
    
    /// 获取Future
    ObjectPtr<Future<T>> getFuture() { 
        return future_; 
    }
    
    /// 完成Future
    void complete(T value) {
        future_->_complete(value);
    }
    
    /// 错误完成
    void completeError(const std::exception& error) {
        future_->_completeError(std::make_exception_ptr(error));
    }
    
    /// 检查是否已完成
    Bool isCompleted() { 
        return future_->isCompleted(); 
    }
    
    String toString() const override {
        return String(std::string("Completer<") + typeid(T).name() + ">");
    }
};
#endif // DART_ASYNC_H
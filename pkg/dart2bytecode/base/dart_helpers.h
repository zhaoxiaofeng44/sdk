#ifndef _DART_HELPERS_H_
#define _DART_HELPERS_H_

#include "object.h"
#include "object_extensions.h"
#include "dart_syntax_sugar.h"
#include <chrono>
#include <random>
#include <algorithm>
#include <numeric>

// ============================================================================
// Dart 风格的实用工具类和函数
// ============================================================================

// ============================================================================
// Math 数学工具类
// ============================================================================

class Math {
public:
    static const Double PI;
    static const Double E;
    
    // 基本数学函数
    static Double abs(const Double& value) {
        return Double(std::abs(value.toDouble()));
    }
    
    static Int abs(const Int& value) {
        return value.abs();
    }
    
    static Double sqrt(const Double& value) {
        return Double(std::sqrt(value.toDouble()));
    }
    
    static Double pow(const Double& base, const Double& exponent) {
        return Double(std::pow(base.toDouble(), exponent.toDouble()));
    }
    
    static Double sin(const Double& value) {
        return Double(std::sin(value.toDouble()));
    }
    
    static Double cos(const Double& value) {
        return Double(std::cos(value.toDouble()));
    }
    
    static Double tan(const Double& value) {
        return Double(std::tan(value.toDouble()));
    }
    
    static Double log(const Double& value) {
        return Double(std::log(value.toDouble()));
    }
    
    static Double exp(const Double& value) {
        return Double(std::exp(value.toDouble()));
    }
    
    // 最大最小值
    template<typename T>
    static T min(const T& a, const T& b) {
        return (a.operator<(b)).toBool() ? a : b;
    }
    
    template<typename T>
    static T max(const T& a, const T& b) {
        return (a.operator>(b)).toBool() ? a : b;
    }
    
    // 随机数生成
    static Int random(const Int& max) {
        static std::random_device rd;
        static std::mt19937 gen(rd());
        std::uniform_int_distribution<> dis(0, max.toInt() - 1);
        return Int(dis(gen));
    }
    
    static Double randomDouble() {
        static std::random_device rd;
        static std::mt19937 gen(rd());
        std::uniform_real_distribution<> dis(0.0, 1.0);
        return Double(dis(gen));
    }
};

const Double Math::PI = Double(3.141592653589793);
const Double Math::E = Double(2.718281828459045);

// ============================================================================
// DateTime 日期时间类
// ============================================================================

class DateTime : public Object {
private:
    std::chrono::system_clock::time_point time_point_;

public:
    DateTime() : time_point_(std::chrono::system_clock::now()) {
        type_id = 12;
    }
    
    DateTime(int year, int month, int day, int hour = 0, int minute = 0, int second = 0) {
        type_id = 12;
        std::tm tm = {};
        tm.tm_year = year - 1900;
        tm.tm_mon = month - 1;
        tm.tm_mday = day;
        tm.tm_hour = hour;
        tm.tm_min = minute;
        tm.tm_sec = second;
        time_point_ = std::chrono::system_clock::from_time_t(std::mktime(&tm));
    }
    
    static ObjectPtr<DateTime> now() {
        return ObjectPtr<DateTime>(new DateTime());
    }
    
    Int get_year() const {
        std::time_t time = std::chrono::system_clock::to_time_t(time_point_);
        std::tm* tm = std::localtime(&time);
        return Int(tm->tm_year + 1900);
    }
    
    Int get_month() const {
        std::time_t time = std::chrono::system_clock::to_time_t(time_point_);
        std::tm* tm = std::localtime(&time);
        return Int(tm->tm_mon + 1);
    }
    
    Int get_day() const {
        std::time_t time = std::chrono::system_clock::to_time_t(time_point_);
        std::tm* tm = std::localtime(&time);
        return Int(tm->tm_mday);
    }
    
    Int get_hour() const {
        std::time_t time = std::chrono::system_clock::to_time_t(time_point_);
        std::tm* tm = std::localtime(&time);
        return Int(tm->tm_hour);
    }
    
    Int get_minute() const {
        std::time_t time = std::chrono::system_clock::to_time_t(time_point_);
        std::tm* tm = std::localtime(&time);
        return Int(tm->tm_min);
    }
    
    Int get_second() const {
        std::time_t time = std::chrono::system_clock::to_time_t(time_point_);
        std::tm* tm = std::localtime(&time);
        return Int(tm->tm_sec);
    }
    
    String toString() const override {
        std::time_t time = std::chrono::system_clock::to_time_t(time_point_);
        std::tm* tm = std::localtime(&time);
        char buffer[100];
        std::strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", tm);
        return String(buffer);
    }
    
    Int millisecondsSinceEpoch() const {
        auto duration = time_point_.time_since_epoch();
        auto millis = std::chrono::duration_cast<std::chrono::milliseconds>(duration);
        return Int(static_cast<int>(millis.count()));
    }
};

// ============================================================================
// Duration 持续时间类
// ============================================================================

class Duration : public Object {
private:
    std::chrono::milliseconds duration_;

public:
    Duration(int milliseconds) : duration_(milliseconds) {
        type_id = 13;
    }
    
    static ObjectPtr<Duration> fromSeconds(int seconds) {
        return ObjectPtr<Duration>(new Duration(seconds * 1000));
    }
    
    static ObjectPtr<Duration> fromMinutes(int minutes) {
        return ObjectPtr<Duration>(new Duration(minutes * 60 * 1000));
    }
    
    static ObjectPtr<Duration> fromHours(int hours) {
        return ObjectPtr<Duration>(new Duration(hours * 60 * 60 * 1000));
    }
    
    Int get_inMilliseconds() const {
        return Int(static_cast<int>(duration_.count()));
    }
    
    Int get_inSeconds() const {
        return Int(static_cast<int>(duration_.count() / 1000));
    }
    
    Int get_inMinutes() const {
        return Int(static_cast<int>(duration_.count() / (1000 * 60)));
    }
    
    Int get_inHours() const {
        return Int(static_cast<int>(duration_.count() / (1000 * 60 * 60)));
    }
    
    String toString() const override {
        int total_seconds = static_cast<int>(duration_.count() / 1000);
        int hours = total_seconds / 3600;
        int minutes = (total_seconds % 3600) / 60;
        int seconds = total_seconds % 60;
        
        std::stringstream ss;
        ss << hours << ":" << std::setfill('0') << std::setw(2) << minutes 
           << ":" << std::setfill('0') << std::setw(2) << seconds;
        return String(ss.str());
    }
};

// ============================================================================
// Stopwatch 秒表类
// ============================================================================

class Stopwatch : public Object {
private:
    std::chrono::high_resolution_clock::time_point start_time_;
    std::chrono::milliseconds elapsed_;
    bool is_running_;

public:
    Stopwatch() : elapsed_(0), is_running_(false) {
        type_id = 14;
    }
    
    void start() {
        if (!is_running_) {
            start_time_ = std::chrono::high_resolution_clock::now();
            is_running_ = true;
        }
    }
    
    void stop() {
        if (is_running_) {
            auto now = std::chrono::high_resolution_clock::now();
            elapsed_ += std::chrono::duration_cast<std::chrono::milliseconds>(now - start_time_);
            is_running_ = false;
        }
    }
    
    void reset() {
        elapsed_ = std::chrono::milliseconds(0);
        is_running_ = false;
    }
    
    Bool get_isRunning() const {
        return Bool(is_running_);
    }
    
    Int get_elapsedMilliseconds() const {
        if (is_running_) {
            auto now = std::chrono::high_resolution_clock::now();
            auto current_elapsed = elapsed_ + 
                std::chrono::duration_cast<std::chrono::milliseconds>(now - start_time_);
            return Int(static_cast<int>(current_elapsed.count()));
        }
        return Int(static_cast<int>(elapsed_.count()));
    }
    
    String toString() const override {
        return String("Stopwatch(elapsed: " + 
                     std::to_string(get_elapsedMilliseconds().toInt()) + "ms)");
    }
};

// ============================================================================
// 集合工具函数
// ============================================================================

namespace CollectionUtils {
    // 列表排序
    template<typename T>
    void sort(ObjectPtr<List<T>> list, std::function<Bool(const T&, const T&)> compare = nullptr) {
        if (compare == nullptr) {
            list->sort();
        } else {
            // 自定义比较排序的实现
            std::vector<T> temp_vec = *list;
            std::sort(temp_vec.begin(), temp_vec.end(), 
                     [&compare](const T& a, const T& b) {
                         return compare(a, b).toBool();
                     });
            
            list->clear();
            for (const auto& item : temp_vec) {
                list->add(item);
            }
        }
    }
    
    // 列表求和
    template<typename T>
    T sum(ObjectPtr<List<T>> list) {
        T result{};
        auto it = list->iterator();
        while (it.hasNext()) {
            result = result + it.next();
        }
        return result;
    }
    
    // 列表平均值
    Double average(ObjectPtr<List<Int>> list) {
        if (list->isEmpty().toBool()) {
            return Double(0);
        }
        Int total = sum(list);
        return Double(total.toInt()) / Double(list->size().toInt());
    }
    
    Double average(ObjectPtr<List<Double>> list) {
        if (list->isEmpty().toBool()) {
            return Double(0);
        }
        Double total = sum(list);
        return total / Double(list->size().toInt());
    }
}

// ============================================================================
// 字符串工具函数
// ============================================================================

namespace StringUtils {
    // 判断字符串是否为数字
    Bool isNumeric(const String& str) {
        std::string s = str.getValue();
        if (s.empty()) return Bool(false);
        
        size_t start = 0;
        if (s[0] == '+' || s[0] == '-') start = 1;
        
        bool has_dot = false;
        for (size_t i = start; i < s.length(); ++i) {
            if (s[i] == '.' && !has_dot) {
                has_dot = true;
            } else if (!std::isdigit(s[i])) {
                return Bool(false);
            }
        }
        return Bool(start < s.length());
    }
    
    // 字符串转数字
    Int parseInt(const String& str) {
        try {
            return Int(std::stoi(str.getValue()));
        } catch (...) {
            throw std::runtime_error("Cannot parse string to int: " + str.getValue());
        }
    }
    
    Double parseDouble(const String& str) {
        try {
            return Double(std::stod(str.getValue()));
        } catch (...) {
            throw std::runtime_error("Cannot parse string to double: " + str.getValue());
        }
    }
    
    // 字符串反转
    String reverse(const String& str) {
        std::string s = str.getValue();
        std::reverse(s.begin(), s.end());
        return String(s);
    }
    
    // 字符串重复
    String repeat(const String& str, const Int& times) {
        std::string result;
        std::string s = str.getValue();
        int count = times.toInt();
        
        for (int i = 0; i < count; ++i) {
            result += s;
        }
        return String(result);
    }
}

// ============================================================================
// 控制流辅助函数
// ============================================================================

namespace ControlFlow {
    // 模拟 Dart 的 switch 表达式
    template<typename T, typename R>
    R switchExpression(const T& value, 
                      const std::vector<std::pair<T, R>>& cases, 
                      const R& defaultValue = R{}) {
        for (const auto& case_pair : cases) {
            if (value.operator==(case_pair.first).toBool()) {
                return case_pair.second;
            }
        }
        return defaultValue;
    }
    
    // 条件执行
    template<typename F>
    void when(Bool condition, F&& func) {
        if (condition.toBool()) {
            func();
        }
    }
    
    // 重试机制
    template<typename F>
    Bool retry(int maxAttempts, F&& func) {
        for (int attempt = 0; attempt < maxAttempts; ++attempt) {
            try {
                func();
                return Bool(true);
            } catch (...) {
                if (attempt == maxAttempts - 1) {
                    return Bool(false);
                }
            }
        }
        return Bool(false);
    }
}

#endif // _DART_HELPERS_H_

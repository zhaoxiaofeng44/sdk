#ifndef _DART_SYNTAX_SUGAR_H_
#define _DART_SYNTAX_SUGAR_H_

#include "object.h"
#include "object_extensions.h"

// ============================================================================
// Dart 语法糖宏定义
// ============================================================================

// ============================================================================
// 变量声明宏
// ============================================================================

// var 关键字模拟 - 自动类型推导
#define var auto

// final 关键字模拟 - 只读变量
#define final const auto

// const 关键字模拟 - 编译时常量
#define dart_const constexpr auto

// late 关键字模拟 - 延迟初始化（使用智能指针）
#define late auto

// ============================================================================
// 控制流语法糖
// ============================================================================

// for-in 循环的语法糖
#define dart_for_in(item, container) \
    for (auto _it = (container)->iterator(); _it.hasNext(); ) \
        for (auto item = _it.next(); !_it.hasNext() || (_it.next(), false); )

// 简化的 for-in 语法
#define for_each(item, container) \
    for (auto _it = (container)->iterator(); _it.hasNext(); ) { \
        auto item = _it.next();

#define end_for }

// switch-case 的增强宏（支持多个值）
#define dart_switch(value) switch((value))
#define dart_case(val) case (val):
#define dart_default default:

// ============================================================================
// 字符串插值语法糖
// ============================================================================

// 字符串插值宏 - 使用 ${} 语法
#define dart_string(str) String(str)
#define dart_interpolate(template_str, ...) \
    StringExtensions::format(String(template_str), __VA_ARGS__)

// 简化的字符串格式化
#define S(str) String(str)
#define $(format, ...) dart_format(S(format), __VA_ARGS__)

// ============================================================================
// 集合字面量语法糖
// ============================================================================

// List 字面量
#define dart_list(...) List<decltype(__VA_ARGS__)>::create({__VA_ARGS__})

// Set 字面量  
#define dart_set(...) Set<decltype(__VA_ARGS__)>::create({__VA_ARGS__})

// Map 字面量辅助
#define dart_pair(k, v) std::make_pair(k, v)
#define dart_map(...) Map<decltype(__VA_ARGS__.first), decltype(__VA_ARGS__.second)>::create({__VA_ARGS__})

// ============================================================================
// 空值安全语法糖
// ============================================================================

// 空值合并操作符 ??
#define null_coalesce_op(left, right) null_coalesce(left, right)

// 条件访问操作符 ?.
#define safe_access(obj, member) safe_call(obj, [](auto& o){ return o.member; })

// 强制非空操作符 !
#define force_unwrap(ptr) (*ptr)

// ============================================================================
// 类型操作语法糖
// ============================================================================

// is 操作符
#define dart_is_type(obj, type) dart_is<type>(obj)

// as 操作符
#define dart_as_type(obj, type) dart_as<type>(obj)

// ============================================================================
// 函数定义语法糖
// ============================================================================

// 箭头函数语法糖
#define dart_lambda(params, body) [](params) -> auto { return body; }

// 异步函数占位符（暂时用普通函数替代）
#define dart_async 
#define dart_await 

// ============================================================================
// 异常处理语法糖
// ============================================================================

// Dart 风格的异常处理
#define dart_try try
#define dart_catch(exception_type, var_name) catch(const exception_type& var_name)
#define dart_finally(code) \
    struct _finally_helper { \
        std::function<void()> func; \
        ~_finally_helper() { if(func) func(); } \
    } _finally{[&](){code}};

#define dart_throw(exception) throw exception

// ============================================================================
// 属性访问语法糖
// ============================================================================

// getter 语法糖
#define dart_getter(type, name, body) \
    type get_##name() const { return body; }

// setter 语法糖
#define dart_setter(type, name, param, body) \
    void set_##name(const type& param) { body; }

// 属性定义宏
#define dart_property(type, name, getter_body, setter_body) \
    private: type name##_; \
    public: \
    dart_getter(type, name, getter_body) \
    dart_setter(type, name, value, setter_body)

// ============================================================================
// 范围操作语法糖
// ============================================================================

// 范围操作符 ..
#define dart_range_inclusive(start, end) dart_range(Int(start), Int(end + 1))
#define dart_range_exclusive(start, end) dart_range(Int(start), Int(end))

// ============================================================================
// 集合操作语法糖
// ============================================================================

// 扩展操作符 ...
#define dart_spread(list1, list2) dart_spread(list1, list2)

// where 过滤
#define dart_where(container, condition) dart_where(container, [](const auto& item){ return condition; })

// map 映射
#define dart_map_transform(container, transform) dart_map(container, [](const auto& item){ return transform; })

// ============================================================================
// 常用工具宏
// ============================================================================

// 打印调试信息
#define dart_print(value) std::cout << (value).toString().getValue() << std::endl

// 断言
#define dart_assert(condition, message) \
    if (!(condition)) { \
        throw std::runtime_error("Assertion failed: " + std::string(message)); \
    }

// 类型别名
#define dart_typedef(new_name, original_type) using new_name = original_type

// ============================================================================
// 枚举支持宏
// ============================================================================

// 简化的枚举定义
#define dart_enum(name, ...) \
    class name { \
    public: \
        enum Values { __VA_ARGS__ }; \
        static const char* names[]; \
        \
        name() : value_(static_cast<Values>(0)) {} \
        name(Values v) : value_(v) {} \
        \
        Values getValue() const { return value_; } \
        String toString() const { return String(names[value_]); } \
        \
        bool operator==(const name& other) const { return value_ == other.value_; } \
        bool operator!=(const name& other) const { return value_ != other.value_; } \
        \
        operator Values() const { return value_; } \
        \
    private: \
        Values value_; \
    };

// 枚举名称数组定义辅助宏
#define dart_enum_names(enum_class, ...) \
    const char* enum_class::names[] = { __VA_ARGS__ };

// ============================================================================
// 便利函数宏
// ============================================================================

// 快速创建对象的宏
#define dart_new(type, ...) ObjectPtr<type>(new type(__VA_ARGS__))

// 快速类型转换
#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// 安全的对象方法调用
#define dart_safe_call(obj, method, ...) \
    ((obj).isNotNull() ? (obj)->method(__VA_ARGS__) : decltype((obj)->method(__VA_ARGS__)){})

#endif // _DART_SYNTAX_SUGAR_H_

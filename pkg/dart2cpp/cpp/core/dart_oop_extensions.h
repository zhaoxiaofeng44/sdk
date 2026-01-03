#ifndef _DART_OOP_EXTENSIONS_H_
#define _DART_OOP_EXTENSIONS_H_

#include "dart_macros.h"
#include "dart_object.h"
#include "dart_string.h"



// ============================================================================
// Dart 面向对象扩展 - 简化版本
// ============================================================================

// ============================================================================
// Comparable 接口 - 用于类型约束 T extends Comparable<T>
// ============================================================================

template<typename T>
class Comparable {
public:
  virtual ~Comparable() {}
  // 使用值传递而非 const 引用，以兼容编译器生成的代码
  virtual Int compareTo(T other) = 0;
};

// ============================================================================
// MapEntry 类 - Map 的键值对
// ============================================================================

template<typename K, typename V>
class MapEntry : public Object {
private:
  K key_;
  V value_;

public:
  MapEntry() : key_(), value_() {}
  MapEntry(const K& key, const V& value) : key_(key), value_(value) {}
  MapEntry(const MapEntry<K, V>& other) : key_(other.key_), value_(other.value_) {}
  
  K get_key() const { return key_; }
  V get_value() const { return value_; }
  
  void set_key(const K& key) { key_ = key; }
  void set_value(const V& value) { value_ = value; }
  
  String toString() const override {
    return String("MapEntry(") + key_.toString() + String(", ") + value_.toString() + String(")");
  }
  
  static ObjectPtr<MapEntry<K, V>> create(const K& key, const V& value) {
    return ObjectPtr<MapEntry<K, V>>(new MapEntry<K, V>(key, value));
  }
};

// ============================================================================
// Symbol 类 - 使用 String 作为 Symbol 的别名
// 在 Dart 中 Symbol 和 String 可以统一处理
// ============================================================================

using Symbol = String;

// ============================================================================
// Type 类 - Dart 类型信息
// ============================================================================

class Type : public Object {
private:
  String name_;

public:
  Type() : name_(String("dynamic")) {}
  explicit Type(const String& name) : name_(name) {}
  Type(const Type& other) : name_(other.name_) {}
  
  String get_name() const { return name_; }
  
  Bool operator_equals(const Type& other) const {
    return name_ == other.name_;
  }
  
  Bool operator==(const Type& other) const {
    return operator_equals(other);
  }
  
  Bool operator!=(const Type& other) const {
    return !(operator_equals(other));
  }
  
  String toString() const override {
    return name_;
  }
  
  // Type.of<T>() - 获取类型信息
  template<typename T>
  static Type of() {
    return Type(String(typeid(T).name()));
  }
};

// ============================================================================
// 常用接口定义 - 直接使用C++风格
// ============================================================================

// 可比较接口
// interface Comparable {
// public:
//     virtual ~Comparable() {}
//     virtual Int compareTo(const void* other) = 0;
// };

// 可迭代接口  
// interface Iterable {
// public:
//     virtual ~Iterable() {}
//     virtual Bool hasNext() = 0;
//     virtual Any next() = 0;
//     virtual void reset() = 0;
// };

// // 可序列化接口
// interface Serializable {
// public:
//     virtual ~Serializable() {}
//     virtual String serialize() = 0;
//     virtual Bool deserialize(const String& data) = 0;
// };

// // 可克隆接口
// interface Cloneable {
// public:
//     virtual ~Cloneable() {}
//     virtual void* clone() = 0;
// };

// ============================================================================
// 常用 Mixin 定义 - 直接使用C++风格
// ============================================================================

// // 时间戳 Mixin
// mixin TimestampMixin {
// private:
//     double created_at_;
//     double updated_at_;
    
//     // 使用统一的全局计数器模拟时间戳
//     static double getNextTimestamp() {
//         static double counter = 0.0;
//         return ++counter;
//     }
    
// public:
//     TimestampMixin() : created_at_(0.0), updated_at_(0.0) {}
//     virtual ~TimestampMixin() {}
    
//     virtual void touch() {
//         updated_at_ = getNextTimestamp();
//     }
    
//     virtual void onCreate() {
//         double timestamp = getNextTimestamp();
//         created_at_ = timestamp;
//         updated_at_ = timestamp;
//     }
    
//     virtual Double getCreatedAt() {
//         return Double(created_at_);
//     }
    
//     virtual Double getUpdatedAt() {
//         return Double(updated_at_);
//     }
// };

// // 标识符 Mixin
// mixin IdentifiableMixin {
// private:
//     Int id_;
    
// public:
//     IdentifiableMixin() : id_(0) {}
//     virtual ~IdentifiableMixin() {}
    
//     virtual void setId(const Int& id) {
//         id_ = id;
//     }
    
//     virtual Int getId() {
//         return id_;
//     }
    
//     virtual String getIdString() {
//         return String("ID:") + id_.toString();
//     }
// };

// // 名称 Mixin
// mixin NameableMixin {
// private:
//     String name_;
    
// public:
//     NameableMixin() : name_("Unnamed") {}
//     virtual ~NameableMixin() {}
    
//     virtual void setName(const String& name) {
//         name_ = name;
//     }
    
//     virtual String getName() {
//         return name_;
//     }
    
//     virtual String getDisplayName() {
//         return String("[") + name_ + String("]");
//     }
// };

#endif // _DART_OOP_EXTENSIONS_H_
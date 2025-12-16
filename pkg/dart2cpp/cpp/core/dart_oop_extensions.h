#ifndef _DART_OOP_EXTENSIONS_H_
#define _DART_OOP_EXTENSIONS_H_

#include "dart_macros.h"
#include "dart_object.h"
#include "dart_string.h"



// ============================================================================
// Dart 面向对象扩展 - 简化版本
// ============================================================================

// ============================================================================
// 常用接口定义 - 直接使用C++风格
// ============================================================================

// 可比较接口
interface Comparable {
public:
    virtual ~Comparable() {}
    virtual Int compareTo(const void* other) = 0;
};

// 可迭代接口  
interface Iterable {
public:
    virtual ~Iterable() {}
    virtual Bool hasNext() = 0;
    virtual Any next() = 0;
    virtual void reset() = 0;
};

// 可序列化接口
interface Serializable {
public:
    virtual ~Serializable() {}
    virtual String serialize() = 0;
    virtual Bool deserialize(const String& data) = 0;
};

// 可克隆接口
interface Cloneable {
public:
    virtual ~Cloneable() {}
    virtual void* clone() = 0;
};

// ============================================================================
// 常用 Mixin 定义 - 直接使用C++风格
// ============================================================================

// 时间戳 Mixin
mixin TimestampMixin {
private:
    double created_at_;
    double updated_at_;
    
    // 使用统一的全局计数器模拟时间戳
    static double getNextTimestamp() {
        static double counter = 0.0;
        return ++counter;
    }
    
public:
    TimestampMixin() : created_at_(0.0), updated_at_(0.0) {}
    virtual ~TimestampMixin() {}
    
    virtual void touch() {
        updated_at_ = getNextTimestamp();
    }
    
    virtual void onCreate() {
        double timestamp = getNextTimestamp();
        created_at_ = timestamp;
        updated_at_ = timestamp;
    }
    
    virtual Double getCreatedAt() {
        return Double(created_at_);
    }
    
    virtual Double getUpdatedAt() {
        return Double(updated_at_);
    }
};

// 标识符 Mixin
mixin IdentifiableMixin {
private:
    Int id_;
    
public:
    IdentifiableMixin() : id_(0) {}
    virtual ~IdentifiableMixin() {}
    
    virtual void setId(const Int& id) {
        id_ = id;
    }
    
    virtual Int getId() {
        return id_;
    }
    
    virtual String getIdString() {
        return String("ID:") + id_.toString();
    }
};

// 名称 Mixin
mixin NameableMixin {
private:
    String name_;
    
public:
    NameableMixin() : name_("Unnamed") {}
    virtual ~NameableMixin() {}
    
    virtual void setName(const String& name) {
        name_ = name;
    }
    
    virtual String getName() {
        return name_;
    }
    
    virtual String getDisplayName() {
        return String("[") + name_ + String("]");
    }
};

#endif // _DART_OOP_EXTENSIONS_H_
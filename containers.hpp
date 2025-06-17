#pragma once

#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <memory>
#include <string>
#include <functional>
#include <stdexcept>
#include <algorithm>
#include <random>

class Object {
public:
    virtual ~Object() = default;
    virtual String* toString() const {
        return String::fromStdString("Object");
    }
};

class String : public Object {
public:
    std::string value;
    int length;

    static String* _new_0() {
        String* obj = new String();
        obj->value = "";
        obj->length = 0;
        return obj;
    }

    static String* fromStdString(const std::string& str) {
        String* obj = new String();
        obj->value = str;
        obj->length = str.length();
        return obj;
    }

    static String* fromInt(int value) {
        return fromStdString(std::to_string(value));
    }

    String* operator+(const String* other) const {
        if (other == nullptr) return nullptr;
        return fromStdString(this->value + other->value);
    }

    String* operator+(int value) const {
        return fromStdString(this->value + std::to_string(value));
    }

    bool operator==(const String* other) const {
        if (other == nullptr) return false;
        return this->value == other->value;
    }

    bool operator!=(const String* other) const {
        return !(*this == other);
    }

    virtual std::string toString() const override {
        return value;
    }

    std::string toStdString() const {
        return value;
    }

    int get_length() const {
        return length;
    }
};

template<typename T>
class List : public Object {
private:
    std::vector<T> data;

public:
    List() = default;
    
    static List<T>* create() {
        return new List<T>();
    }

    static List<T>* from(const std::vector<T>& items) {
        List<T>* list = new List<T>();
        list->data = items;
        return list;
    }

    // 基本操作
    void add(T value) {
        data.push_back(value);
    }

    void addAll(const List<T>* other) {
        if (other == nullptr) return;
        data.insert(data.end(), other->data.begin(), other->data.end());
    }

    void insert(int index, T value) {
        if (index < 0 || index > data.size()) {
            throw std::out_of_range("Index out of range");
        }
        data.insert(data.begin() + index, value);
    }

    bool remove(const T& value) {
        auto it = std::find(data.begin(), data.end(), value);
        if (it != data.end()) {
            data.erase(it);
            return true;
        }
        return false;
    }

    T removeAt(int index) {
        if (index < 0 || index >= data.size()) {
            throw std::out_of_range("Index out of range");
        }
        T value = data[index];
        data.erase(data.begin() + index);
        return value;
    }

    // 访问操作
    T operator[](int index) const {
        if (index < 0 || index >= data.size()) {
            throw std::out_of_range("Index out of range");
        }
        return data[index];
    }

    T& operator[](int index) {
        if (index < 0 || index >= data.size()) {
            throw std::out_of_range("Index out of range");
        }
        return data[index];
    }

    // 属性
    int get_length() const {
        return data.size();
    }

    bool get_isEmpty() const {
        return data.empty();
    }

    bool get_isNotEmpty() const {
        return !data.empty();
    }

    T get_first() const {
        if (data.empty()) {
            throw std::out_of_range("List is empty");
        }
        return data.front();
    }

    T get_last() const {
        if (data.empty()) {
            throw std::out_of_range("List is empty");
        }
        return data.back();
    }

    // 修改操作
    void clear() {
        data.clear();
    }

    List<T>* sublist(int start, int end) const {
        if (start < 0 || end > data.size() || start > end) {
            throw std::out_of_range("Invalid range");
        }
        List<T>* result = new List<T>();
        result->data.assign(data.begin() + start, data.begin() + end);
        return result;
    }

    void sort(std::function<bool(T, T)> compare = nullptr) {
        if (compare) {
            std::sort(data.begin(), data.end(), compare);
        } else {
            std::sort(data.begin(), data.end());
        }
    }

    void shuffle() {
        std::random_device rd;
        std::mt19937 gen(rd());
        std::shuffle(data.begin(), data.end(), gen);
    }

    void reverse() {
        std::reverse(data.begin(), data.end());
    }

    // 查询操作
    bool contains(const T& value) const {
        return std::find(data.begin(), data.end(), value) != data.end();
    }

    int indexOf(const T& value, int start = 0) const {
        if (start < 0) start = 0;
        auto it = std::find(data.begin() + start, data.end(), value);
        return it == data.end() ? -1 : it - data.begin();
    }

    int lastIndexOf(const T& value, int start = -1) const {
        if (start < 0 || start >= data.size()) {
            start = data.size() - 1;
        }
        for (int i = start; i >= 0; --i) {
            if (data[i] == value) return i;
        }
        return -1;
    }

    // 转换操作
    List<T>* where(std::function<bool(T)> predicate) const {
        List<T>* result = new List<T>();
        for (const auto& item : data) {
            if (predicate(item)) {
                result->add(item);
            }
        }
        return result;
    }

    template<typename R>
    List<R>* map(std::function<R(T)> transform) const {
        List<R>* result = new List<R>();
        for (const auto& item : data) {
            result->add(transform(item));
        }
        return result;
    }

    T reduce(std::function<T(T, T)> combine) const {
        if (data.empty()) {
            throw std::runtime_error("Cannot reduce empty list");
        }
        T result = data[0];
        for (size_t i = 1; i < data.size(); ++i) {
            result = combine(result, data[i]);
        }
        return result;
    }

    template<typename R>
    R fold(R initial, std::function<R(R, T)> combine) const {
        R result = initial;
        for (const auto& item : data) {
            result = combine(result, item);
        }
        return result;
    }

    void forEach(std::function<void(T)> action) const {
        for (const auto& item : data) {
            action(item);
        }
    }

    bool every(std::function<bool(T)> test) const {
        return std::all_of(data.begin(), data.end(), test);
    }

    bool any(std::function<bool(T)> test) const {
        return std::any_of(data.begin(), data.end(), test);
    }

    // 运算符重载
    List<T>* operator+(const List<T>* other) const {
        List<T>* result = new List<T>();
        result->data = this->data;
        if (other != nullptr) {
            result->addAll(other);
        }
        return result;
    }

    bool operator==(const List<T>* other) const {
        if (other == nullptr) return false;
        return this->data == other->data;
    }

    virtual String* toString() const override;

    // 迭代器支持
    typename std::vector<T>::iterator begin() { return data.begin(); }
    typename std::vector<T>::iterator end() { return data.end(); }
    typename std::vector<T>::const_iterator begin() const { return data.begin(); }
    typename std::vector<T>::const_iterator end() const { return data.end(); }
};

template<typename K, typename V>
class Map : public Object {
private:
    std::unordered_map<K, V> data;

public:
    Map() = default;
    
    static Map<K, V>* create() {
        return new Map<K, V>();
    }

    static Map<K, V>* from(const std::unordered_map<K, V>& items) {
        Map<K, V>* map = new Map<K, V>();
        map->data = items;
        return map;
    }

    // 基本操作
    void put(K key, V value) {
        data[key] = value;
    }

    void putIfAbsent(K key, std::function<V()> ifAbsent) {
        if (!containsKey(key)) {
            data[key] = ifAbsent();
        }
    }

    void addAll(const Map<K, V>* other) {
        if (other == nullptr) return;
        for (const auto& pair : other->data) {
            data[pair.first] = pair.second;
        }
    }

    V remove(const K& key) {
        auto it = data.find(key);
        if (it == data.end()) {
            throw std::out_of_range("Key not found");
        }
        V value = it->second;
        data.erase(it);
        return value;
    }

    // 访问操作
    V operator[](const K& key) const {
        auto it = data.find(key);
        if (it == data.end()) {
            throw std::out_of_range("Key not found");
        }
        return it->second;
    }

    V& operator[](const K& key) {
        return data[key];
    }

    // 属性
    bool get_isEmpty() const {
        return data.empty();
    }

    bool get_isNotEmpty() const {
        return !data.empty();
    }

    int get_length() const {
        return data.size();
    }

    // 查询操作
    bool containsKey(const K& key) const {
        return data.find(key) != data.end();
    }

    bool containsValue(const V& value) const {
        return std::any_of(data.begin(), data.end(),
            [&value](const auto& pair) { return pair.second == value; });
    }

    // 集合操作
    List<K>* keys() const {
        List<K>* result = new List<K>();
        for (const auto& pair : data) {
            result->add(pair.first);
        }
        return result;
    }

    List<V>* values() const {
        List<V>* result = new List<V>();
        for (const auto& pair : data) {
            result->add(pair.second);
        }
        return result;
    }

    List<std::pair<K, V>>* entries() const {
        List<std::pair<K, V>>* result = new List<std::pair<K, V>>();
        for (const auto& pair : data) {
            result->add(pair);
        }
        return result;
    }

    // 修改操作
    void clear() {
        data.clear();
    }

    void update(K key, std::function<V(V)> update) {
        auto it = data.find(key);
        if (it != data.end()) {
            it->second = update(it->second);
        }
    }

    void updateAll(std::function<V(K, V)> update) {
        for (auto& pair : data) {
            pair.second = update(pair.first, pair.second);
        }
    }

    // 转换操作
    void forEach(std::function<void(K, V)> action) const {
        for (const auto& pair : data) {
            action(pair.first, pair.second);
        }
    }

    Map<K, V>* where(std::function<bool(K, V)> test) const {
        Map<K, V>* result = new Map<K, V>();
        for (const auto& pair : data) {
            if (test(pair.first, pair.second)) {
                result->put(pair.first, pair.second);
            }
        }
        return result;
    }

    template<typename R>
    Map<K, R>* map(std::function<R(V)> transform) const {
        Map<K, R>* result = new Map<K, R>();
        for (const auto& pair : data) {
            result->put(pair.first, transform(pair.second));
        }
        return result;
    }

    // 运算符重载
    bool operator==(const Map<K, V>* other) const {
        if (other == nullptr) return false;
        return this->data == other->data;
    }

    virtual String* toString() const override;

    // 迭代器支持
    typename std::unordered_map<K, V>::iterator begin() { return data.begin(); }
    typename std::unordered_map<K, V>::iterator end() { return data.end(); }
    typename std::unordered_map<K, V>::const_iterator begin() const { return data.begin(); }
    typename std::unordered_map<K, V>::const_iterator end() const { return data.end(); }
};

template<typename T>
class Set : public Object {
private:
    std::unordered_set<T> data;

public:
    Set() = default;
    
    static Set<T>* create() {
        return new Set<T>();
    }

    static Set<T>* from(const std::unordered_set<T>& items) {
        Set<T>* set = new Set<T>();
        set->data = items;
        return set;
    }

    // 基本操作
    void add(T value) {
        data.insert(value);
    }

    void addAll(const Set<T>* other) {
        if (other == nullptr) return;
        data.insert(other->data.begin(), other->data.end());
    }

    bool remove(const T& value) {
        return data.erase(value) > 0;
    }

    // 属性
    bool get_isEmpty() const {
        return data.empty();
    }

    bool get_isNotEmpty() const {
        return !data.empty();
    }

    int get_length() const {
        return data.size();
    }

    // 查询操作
    bool contains(const T& value) const {
        return data.find(value) != data.end();
    }

    bool containsAll(const Set<T>* other) const {
        if (other == nullptr) return true;
        for (const auto& item : other->data) {
            if (!contains(item)) return false;
        }
        return true;
    }

    // 集合操作
    Set<T>* intersection(const Set<T>* other) const {
        Set<T>* result = new Set<T>();
        if (other == nullptr) return result;
        for (const auto& item : data) {
            if (other->contains(item)) {
                result->add(item);
            }
        }
        return result;
    }

    Set<T>* union_(const Set<T>* other) const {
        Set<T>* result = new Set<T>();
        result->data = this->data;
        if (other != nullptr) {
            result->addAll(other);
        }
        return result;
    }

    Set<T>* difference(const Set<T>* other) const {
        Set<T>* result = new Set<T>();
        for (const auto& item : data) {
            if (other == nullptr || !other->contains(item)) {
                result->add(item);
            }
        }
        return result;
    }

    // 修改操作
    void clear() {
        data.clear();
    }

    // 转换操作
    List<T>* toList() const {
        List<T>* result = new List<T>();
        for (const auto& item : data) {
            result->add(item);
        }
        return result;
    }

    void forEach(std::function<void(T)> action) const {
        for (const auto& item : data) {
            action(item);
        }
    }

    Set<T>* where(std::function<bool(T)> test) const {
        Set<T>* result = new Set<T>();
        for (const auto& item : data) {
            if (test(item)) {
                result->add(item);
            }
        }
        return result;
    }

    template<typename R>
    Set<R>* map(std::function<R(T)> transform) const {
        Set<R>* result = new Set<R>();
        for (const auto& item : data) {
            result->add(transform(item));
        }
        return result;
    }

    bool every(std::function<bool(T)> test) const {
        return std::all_of(data.begin(), data.end(), test);
    }

    bool any(std::function<bool(T)> test) const {
        return std::any_of(data.begin(), data.end(), test);
    }

    // 运算符重载
    Set<T>* operator+(const Set<T>* other) const {
        return union_(other);
    }

    bool operator==(const Set<T>* other) const {
        if (other == nullptr) return false;
        return this->data == other->data;
    }

    virtual String* toString() const override;

    // 迭代器支持
    typename std::unordered_set<T>::iterator begin() { return data.begin(); }
    typename std::unordered_set<T>::iterator end() { return data.end(); }
    typename std::unordered_set<T>::const_iterator begin() const { return data.begin(); }
    typename std::unordered_set<T>::const_iterator end() const { return data.end(); }
};

// 特化String*类型的容器toString方法
template<>
String* List<String*>::toString() const {
    String* result = String::fromStdString("[");
    bool first = true;
    for (const auto& item : data) {
        if (!first) {
            result = result->operator+(String::fromStdString(", "));
        }
        result = result->operator+(item ? item : String::fromStdString("null"));
        first = false;
    }
    return result->operator+(String::fromStdString("]"));
}

template<>
String* Map<String*, String*>::toString() const {
    String* result = String::fromStdString("{");
    bool first = true;
    for (const auto& pair : data) {
        if (!first) {
            result = result->operator+(String::fromStdString(", "));
        }
        result = result->operator+(pair.first ? pair.first : String::fromStdString("null"))
                ->operator+(String::fromStdString(": "))
                ->operator+(pair.second ? pair.second : String::fromStdString("null"));
        first = false;
    }
    return result->operator+(String::fromStdString("}"));
}

template<>
String* Set<String*>::toString() const {
    String* result = String::fromStdString("{");
    bool first = true;
    for (const auto& item : data) {
        if (!first) {
            result = result->operator+(String::fromStdString(", "));
        }
        result = result->operator+(item ? item : String::fromStdString("null"));
        first = false;
    }
    return result->operator+(String::fromStdString("}"));
}

// 通用类型的toString方法
template<typename T>
String* List<T>::toString() const {
    String* result = String::fromStdString("[");
    bool first = true;
    for (const auto& item : data) {
        if (!first) {
            result = result->operator+(String::fromStdString(", "));
        }
        if constexpr (std::is_pointer_v<T>) {
            result = result->operator+(item ? item->toString() : String::fromStdString("null"));
        } else {
            result = result->operator+(String::fromInt(item));
        }
        first = false;
    }
    return result->operator+(String::fromStdString("]"));
}

template<typename K, typename V>
String* Map<K, V>::toString() const {
    String* result = String::fromStdString("{");
    bool first = true;
    for (const auto& pair : data) {
        if (!first) {
            result = result->operator+(String::fromStdString(", "));
        }
        if constexpr (std::is_pointer_v<K>) {
            result = result->operator+(pair.first ? pair.first->toString() : String::fromStdString("null"));
        } else {
            result = result->operator+(String::fromInt(pair.first));
        }
        result = result->operator+(String::fromStdString(": "));
        if constexpr (std::is_pointer_v<V>) {
            result = result->operator+(pair.second ? pair.second->toString() : String::fromStdString("null"));
        } else {
            result = result->operator+(String::fromInt(pair.second));
        }
        first = false;
    }
    return result->operator+(String::fromStdString("}"));
}

template<typename T>
String* Set<T>::toString() const {
    String* result = String::fromStdString("{");
    bool first = true;
    for (const auto& item : data) {
        if (!first) {
            result = result->operator+(String::fromStdString(", "));
        }
        if constexpr (std::is_pointer_v<T>) {
            result = result->operator+(item ? item->toString() : String::fromStdString("null"));
        } else {
            result = result->operator+(String::fromInt(item));
        }
        first = false;
    }
    return result->operator+(String::fromStdString("}"));
} 
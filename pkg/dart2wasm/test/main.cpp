

// #include "co.h"
// #include "fun.h"
// #include "my.h"
// #include <assert.h>

#include <any>
#include <iostream>
#include <map>
#include <string>

// #include "uu.hpp"

// // void co1(void *msg) {
// //     for (int i = 0; i != 5; ++i) {
// //         printf("%s\n", (char *)msg);
// //         coro_yield();
// //     }
// // }

// // void testoo(std::map<int, std::any> aa) {

// //      //printf("Hello, I am coming %s\n", aa[1]);
// // }

// // class MyTest2 :public SyObject{
// // public:
// //     void test();

// //     ~MyTest2() {
// //         printf("Hello, ~MyTest %ld", (long long)(this));
// //     }
// // };

// // int test(int g){
// //     return g + g;
// // }

// // int main(int ac, char **av) {
// //     assert(sizeof(void *) == sizeof(unsigned long));

// //     //std::any t = 222;

// //     int a = 456;
// //     int* c,d;

// //     SyObject *t = new MyTest2();
// //     auto e =  t->newRef();
// //     printf("Hello, I am coming221 %d \n",sy_ref<SyObject>(e) == nullptr ? 1:2);
// //     delete t;
// //     printf("Hello, I am coming222 %d \n",sy_ref<SyObject>(e) == nullptr ? 1:2);

// //     SyValue<int> * ttt = new SyValue<int>(555);
// //     auto g =  ttt->newRef();
// //     printf("Hello, I am coming221 %d \n",sy_val<int>(g,1));
// //     delete ttt;
// //     printf("Hello, I am coming222 %d \n",sy_val<int>(g,1));

// //     SyAsyncFunction<int(int)> f(test);
// //     SyAsyncClosure<int,int> gggg(test);

// //     int c1 = gggg(22);

// //      printf("Hello, I am coming333 %d \n",c1);
// //     //   SyValue<int> ab(a);
// //     // auto ref =  ab.newRef();
// //     // c = sy_get_val<int>(ref);

// //     // printf("Hello, I am coming22 %d \n",*b);

// // //     testoo({
// // //     {1, "one"},
// // //     {2, "two"},
// // //     {3, "three"}
// // // });

// // // testoo( {
// // //         {"xxxx",23232}
// // //     });
// // //     const char *aa = "hello";
// // //     const char *bb = "world";
// // //     coro_new(co1, (void *)aa);
// // //     coro_new(co1, (void *)bb);
// // //     coro_main();

// //     return 0;
// // }

// typedef int (*Function)<T>(int);

// Function<int> foo1(int &a) {
//     printf("Hello, I am coming %d\n", a);
// }
// int main() {

//     MyTest *mytest = new MyTest();
//     mytest->test();

//     int a = 1;
//     int *pp = new int(10);

//     printf("Hello, I am coming %d\n", a);

//     foo1(a);

//     // MyTest oo;

//     CyHardRef<MyTest *> *aaa = new CyHardRef<MyTest *>(mytest);
//     delete aaa;

//     CyHardRef<int> *bbb = new CyHardRef<int>(a);
//     {
//         CyWakeRef aa(bbb);
//         CyHardRef<int> *cc = (CyHardRef<int> *)(aa.get());
//         printf("Hello, A1 %d\n", cc->get());
//     }
//     // CyRef *ref =  bbb->_header_.newRef(&a);
//     printf("Hello, A21 \n");
//     delete bbb;
//     printf("Hello, A22 \n");

//     MyTemplateClass<int> aa;

//     MyTest *mytest2 = new MyTest();

//     std::shared_ptr<MyTest> aaaqaa = std::make_shared<MyTest>();
//     std::weak_ptr<MyTest> aaaa33 = std::weak_ptr(aaaqaa);

//     std::shared_ptr<MyTest> aaa2 = std::shared_ptr<MyTest>(mytest2);

//     return 0;
// }

// template<typename Key, typename Value,
//          typename Compare = std::less<Key>,
//          typename Allocator = std::allocator<std::pair<const Key, Value>>>
// class CustomMap {
// private:
//     std::map<Key, Value, Compare, Allocator> data;

// public:
//     // 类型定义
//     using key_type = Key;
//     using mapped_type = Value;
//     using value_type = std::pair<const Key, Value>;
//     using key_compare = Compare;
//     using allocator_type = Allocator;

//     // 构造函数族
//     CustomMap() = default;
//     explicit CustomMap(const Compare& comp) : data(comp) {}

//     // 支持初始化列表构造
//     CustomMap(std::initializer_list<value_type> init)
//         : data(init) {}

//     // 支持[]运算符
//     Value& operator[](const Key& key) {
//         return data[key];
//     }

//     // 迭代器
//     auto begin() { return data.begin(); }
//     auto end() { return data.end(); }
//     auto begin() const { return data.begin(); }
//     auto end() const { return data.end(); }

//     // 常用方法
//     size_t size() const { return data.size(); }
//     bool empty() const { return data.empty(); }
//     void clear() { data.clear(); }

//     // 插入方法
//     std::pair<typename std::map<Key, Value>::iterator, bool>
//     insert(const value_type& value) {
//         return data.insert(value);
//     }

//     // 获取底层map
//     const std::map<Key, Value, Compare, Allocator>& getMap() const {
//         return data;
//     }
// };

// int main() {
//     // 使用示例
//     CustomMap<std::string, int> scores = {
//         {"Alice", 95},
//         {"Bob", 87},
//         {"Charlie", 92}
//     };

//     // 遍历
//     for (const auto& [name, score] : scores) {
//         std::cout << name << ": " << score << std::endl;
//     }

//     // 额外操作
//     scores["David"] = 88;

//     // 检查大小
//     std::cout << "Map size: " << scores.size() << std::endl;
// }

#include <algorithm>
#include <functional>
#include <iostream>
#include <optional>
#include <stdexcept>
#include <string>
#include <vector>

template <typename K, typename V>
class CustomMap {
private:
    // 内部存储结构
    struct MapEntry {
        K key;
        V value;
        bool isDeleted = false;

        MapEntry() : key(K{}), value(V{}), isDeleted(false) {}
        MapEntry(const K &k, const V &v) : key(k), value(v), isDeleted(false) {}
    };

    std::vector<MapEntry> entries;
    size_t _size = 0;
    const double LOAD_FACTOR = 0.75;

    // 哈希函数
    std::hash<K> hasher;

    // 找到key的索引
    size_t findIndex(const K &key) const {
        if (entries.empty())
            return -1;

        size_t hash = hasher(key);
        size_t index = hash % entries.size();
        size_t originalIndex = index;
        size_t emptyIndex = -1;

        do {
            if (entries[index].key == key && !entries[index].isDeleted) {
                return index;
            }

            // 记录第一个可用的空位置
            if (emptyIndex == -1 && (entries[index].key == K{} || entries[index].isDeleted)) {
                emptyIndex = index;
            }

            // 线性探测
            index = (index + 1) % entries.size();
        } while (index != originalIndex);

        return emptyIndex;
    }

    // 调整容量
    void resize() {
        size_t newCapacity = entries.empty() ? 16 : entries.size() * 2;
        std::vector<MapEntry> newEntries(newCapacity);

        // 重新哈希
        for (const auto &entry : entries) {
            if (!entry.isDeleted && !(entry.key == K{})) {
                size_t hash = hasher(entry.key);
                size_t index = hash % newCapacity;

                // 线性探测
                while (!newEntries[index].key.empty() && !newEntries[index].isDeleted) {
                    index = (index + 1) % newCapacity;
                }

                newEntries[index] = entry;
            }
        }

        entries = std::move(newEntries);
    }

public:
    // 定义回调函数类型
    using AbsentValueCallback = std::function<V()>;

    // 默认构造函数
    CustomMap() {
        entries.resize(16);
    }

    // 从其他Map复制
    CustomMap(const CustomMap &other) : entries(other.entries), _size(other._size) {}

    // 初始化列表构造
    CustomMap(std::initializer_list<std::pair<K, V>> init) {
        entries.resize(16);
        for (const auto &item : init) {
            (*this)[item.first] = item.second;
        }
    }

    static CustomMap *create() {
        return new CustomMap();
    }

    // 引用访问和赋值
    V &operator[](const K &key) {
        size_t index = findIndex(key);

        // 需要扩容
        if (_size >= entries.size() * LOAD_FACTOR) {
            resize();
            index = findIndex(key);
        }

        // 如果键不存在
        if (index == -1 || entries[index].key == K{} || entries[index].isDeleted) {
            // 找到插入位置
            size_t insertIndex = hasher(key) % entries.size();
            while (!entries[insertIndex].key.empty() && !entries[insertIndex].isDeleted) {
                insertIndex = (insertIndex + 1) % entries.size();
            }

            entries[insertIndex] = MapEntry(key, V{});
            _size++;
            return entries[insertIndex].value;
        }

        return entries[index].value;
    }

    // 属性：长度
    size_t length() const {
        return _size;
    }

    // 是否为空
    bool isEmpty() const {
        return _size == 0;
    }

    bool isNotEmpty() const {
        return _size > 0;
    }

    // putIfAbsent 方法
    V putIfAbsent(const K &key, AbsentValueCallback ifAbsent) {
        size_t index = findIndex(key);

        if (index != -1 && !entries[index].isDeleted) {
            // 键已存在，返回现有值
            return entries[index].value;
        }

        // 键不存在，调用回调生成值
        V newValue = ifAbsent();

        // 添加新的键值对
        (*this)[key] = newValue;

        return newValue;
    }

    // 添加所有键值对
    void addAll(const CustomMap &other) {
        for (const auto &entry : other.entries) {
            if (!entry.isDeleted && !(entry.key == K{})) {
                (*this)[entry.key] = entry.value;
            }
        }
    }

    // update 方法支持可选的 ifAbsent
    V update(
        const K &key,
        std::function<V(V)> updateFunc,
        AbsentValueCallback ifAbsent = nullptr) {
        size_t index = findIndex(key);

        if (index != -1 && !entries[index].isDeleted) {
            // 键存在，更新值
            entries[index].value = updateFunc(entries[index].value);
            return entries[index].value;
        }

        // 键不存在，检查是否提供了 ifAbsent 回调
        if (ifAbsent) {
            V newValue = ifAbsent();
            (*this)[key] = newValue;
            return newValue;
        }

        // 没有提供 ifAbsent 回调，抛出异常
        throw std::out_of_range("Key not found and no ifAbsent callback provided");
    }

    // 删除键
    V remove(const K &key) {
        size_t index = findIndex(key);

        if (index != -1 && !entries[index].isDeleted) {
            V removedValue = entries[index].value;
            entries[index].isDeleted = true;
            _size--;
            return removedValue;
        }

        throw std::out_of_range("Key not found");
    }

    // 清空
    void clear() {
        entries.clear();
        entries.resize(16);
        _size = 0;
    }

    // 是否包含键
    bool containsKey(const K &key) const {
        size_t index = findIndex(key);
        return index != -1 && !entries[index].isDeleted;
    }

    // 是否包含值
    bool containsValue(const V &value) const {
        for (const auto &entry : entries) {
            if (!entry.isDeleted && !(entry.key == K{}) && entry.value == value) {
                return true;
            }
        }
        return false;
    }

    // 遍历
    template <typename Func>
    void forEach(Func action) {
        for (const auto &entry : entries) {
            if (!entry.isDeleted && !(entry.key == K{})) {
                action(entry.key, entry.value);
            }
        }
    }

    // 映射转换
    template <typename K2, typename V2>
    CustomMap<K2, V2> map(std::function<std::pair<K2, V2>(K, V)> transform) {
        CustomMap<K2, V2> newMap;
        for (const auto &entry : entries) {
            if (!entry.isDeleted && !(entry.key == K{})) {
                auto [newKey, newValue] = transform(entry.key, entry.value);
                newMap[newKey] = newValue;
            }
        }
        return newMap;
    }

    // 支持带参数的默认值生成
    V putIfAbsent(const K &key, const K &defaultKey,
                  std::function<V(const K &)> defaultValueGenerator) {
        size_t index = findIndex(key);

        if (index != -1 && !entries[index].isDeleted) {
            return entries[index].value;
        }

        V newValue = defaultValueGenerator(defaultKey);
        (*this)[key] = newValue;

        return newValue;
    }

    // 迭代器支持
    class iterator {
    private:
        typename std::vector<MapEntry>::iterator it;
        typename std::vector<MapEntry>::iterator end;

    public:
        iterator(typename std::vector<MapEntry>::iterator start,
                 typename std::vector<MapEntry>::iterator endIt)
            : it(start), end(endIt) {
            // 找到第一个有效条目
            while (it != end && (it->isDeleted || it->key == K{})) {
                ++it;
            }
        }

        std::pair<K, V> operator*() const {
            return {it->key, it->value};
        }

        iterator &operator++() {
            ++it;
            // 跳过已删除和空条目
            while (it != end && (it->isDeleted || it->key == K{})) {
                ++it;
            }
            return *this;
        }

        bool operator!=(const iterator &other) const {
            return it != other.it;
        }
    };

    iterator begin() {
        return iterator(entries.begin(), entries.end());
    }

    iterator end() {
        return iterator(entries.end(), entries.end());
    }
};

void test(CustomMap<std::string, int> &aa) {
}

// @pragma("wasm:entry-point")
// class CppWasmArray<T> {
//   final List<T?> _data;
//   CppWasmArray(int capacity) : _data = List.filled(capacity, null, growable: true);

//   int get capacity => _data.length;

//   set capacity(int len) => _data.length = len;

//   T operator [](int index) => _data[index] as T;

//   void operator []=(int index, T value) => _data[index] = value;
// }

template <typename K>
class CustomList {
private:
public:
    // 定义回调函数类型

    // 初始化列表构造
    CustomList(std::initializer_list<K> init) {
    }
};



class MyNew{

public:
    int a;
    int b;

    MyNew* init(int a,int b){
        this->a = a;
        this->b = b;
        return this;
    }
};



class MyNewChild : public MyNew{

    public:

    MyNewChild* init(int a,int b){
            MyNew::init(a,b);
            return this;
        }
    };
    

template <typename T>
class CppWasmArray {
    int length;
    T *_data;

public:
    CppWasmArray(int len) {
        length = len;
        _data = (T *)malloc(len * sizeof(T));
    }

    inline int getLength() {
        return length;
    }

    inline void setLength(int len) {
        T *mem = (T *)malloc(len * sizeof(T));
        memcpy(mem, _data, length * sizeof(T));
        free(_data);
        length = len;
        _data = mem;
    }

    inline T getItem(int index) {
        return _data[index];
    }

    inline void setItem(int index, T value) {
        _data[index] = value;
    }
};





template <typename T>
CppWasmArray<T>* CppWasmArray(std::initializer_list<T> init_list) {

    CppWasmArray<T>* array = new CppWasmArray<T>(init_list.size());
    int i=0;
    for(auto& arg : init_list){
        array->setItem(i++,arg);
    }
    return array;
}


void testWasm(CustomList<int> *aa) {
}

// 测试
int main() {

    CustomMap<int, int> *aa = CustomMap<int, int>::create();
    // 创建并初始化
    CustomMap<std::string, int> scores = {
        {"Alice", 95},
        {"Bob", 87},
        {"Charlie", 92}};


    // 添加和更新
    scores["David"] = 88;

    // putIfAbsent
    int charlieScore = scores.putIfAbsent("Charlie", []() {
        std::cout << "Generating default value for Charlie" << std::endl;
        return 0;
    });
    std::cout << "Charlie's score: " << charlieScore << std::endl;

    // 使用 update 带 ifAbsent
    int davidScore = scores.update("David", [](int value) { return value + 10; }, // update 函数
                                   []() { 
            std::cout << "Generating default value for David" << std::endl;
            return 50; });
    std::cout << "David's score: " << davidScore << std::endl;

    // 遍历
    std::cout << "All scores:" << std::endl;
    scores.forEach([](const std::string &name, int score) {
        std::cout << name << ": " << score << std::endl;
    });

    // 迭代器遍历
    std::cout << "Iterator traversal:" << std::endl;
    for (const auto &[name, score] : scores) {
        std::cout << name << ": " << score << std::endl;
    }

    // 映射转换
    auto upperScores = scores.map<std::string, int>([](const std::string &name, int score) {
        return std::make_pair(name + "_upper", score * 2);
    });

    std::cout << "Upper scores:" << std::endl;
    upperScores.forEach([](const std::string &name, int score) {
        std::cout << name << ": " << score << std::endl;
    });

    CppWasmArray<int> ff(8);
    std::cout << ff.getItem(1) << ": " << ff.getItem(7) << std::endl;
    ff.setItem(1, 8);
    ff.setItem(7, 7);
    std::cout << ff.getItem(1) << ": " << ff.getItem(7) << std::endl;
    ff.setLength(16);
    std::cout << ff.getItem(1) << ": " << ff.getItem(7) << std::endl;



    CppWasmArray<int>*  jj = cppWasmArray<int>({1,2,3,4,5});
    std::cout << jj->getItem(1) << ": " << jj->getItem(2) << std::endl;





    auto mynew2  = (MyNew *)malloc(1 * sizeof(MyNew));
    mynew2->init(1,2);
    std::cout << mynew2->a << ": " <<  mynew2->b << std::endl;


    auto mynew3 = ((MyNew *)malloc(1 * sizeof(MyNew)))->init(1,2);
    std::cout << mynew3->a << ": " <<  mynew3->b << std::endl;



    auto mynew4 = ((MyNewChild *)malloc(1 * sizeof(MyNewChild)))->init(1,2);
    std::cout << mynew4->a << ": " <<  mynew4->b << std::endl;

    
    // 测试 CppWasmList
    CustomList<int> *list = new CustomList<int>({1, 2, 3, 4, 5});
    testWasm(list);

    // 测试 CppWasmSet
    std::set<int> cppWasmSet = {1, 2, 3, 4, 5};
    for (int elem : cppWasmSet) {
        std::cout << "Set element: " << elem << std::endl;
    }

    // 测试 CppWasmMap
    CustomMap<std::string, int> cppWasmMap = {
        {"one", 1},
        {"two", 2},
        {"three", 3}
    };
    cppWasmMap.forEach([](const std::string &key, int value) {
        std::cout << "Map entry: " << key << " -> " << value << std::endl;
    });

    return 0;
}

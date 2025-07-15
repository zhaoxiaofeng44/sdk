#include "math.h"
#include <cmath>
#include <random>
#include <chrono>
#include <map>

// Int 参数版本
Double* sin(Int* value) {
    if (!value) return nullptr;
    return new Double(std::sin(value->getInt()));
}

Double* cos(Int* value) {
    if (!value) return nullptr;
    return new Double(std::cos(value->getInt()));
}

Double* tan(Int* value) {
    if (!value) return nullptr;
    return new Double(std::tan(value->getInt()));
}

Double* asin(Int* value) {
    if (!value) return nullptr;
    return new Double(std::asin(value->getInt()));
}

Double* acos(Int* value) {
    if (!value) return nullptr;
    return new Double(std::acos(value->getInt()));
}

Double* atan(Int* value) {
    if (!value) return nullptr;
    return new Double(std::atan(value->getInt()));
}

Double* sqrt(Int* value) {
    if (!value) return nullptr;
    return new Double(std::sqrt(value->getInt()));
}

Double* pow(Int* base, Int* exponent) {
    if (!base || !exponent) return nullptr;
    return new Double(std::pow(base->getInt(), exponent->getInt()));
}

Double* log(Int* value) {
    if (!value) return nullptr;
    return new Double(std::log(value->getInt()));
}

Double* exp(Int* value) {
    if (!value) return nullptr;
    return new Double(std::exp(value->getInt()));
}

Double* ceil(Int* value) {
    if (!value) return nullptr;
    return new Double(std::ceil(value->getInt()));
}

Double* floor(Int* value) {
    if (!value) return nullptr;
    return new Double(std::floor(value->getInt()));
}

Double* round(Int* value) {
    if (!value) return nullptr;
    return new Double(std::round(value->getInt()));
}

// Double 参数版本
Double* sin(Double* value) {
    if (!value) return nullptr;
    return new Double(std::sin(value->getDouble()));
}

Double* cos(Double* value) {
    if (!value) return nullptr;
    return new Double(std::cos(value->getDouble()));
}

Double* tan(Double* value) {
    if (!value) return nullptr;
    return new Double(std::tan(value->getDouble()));
}

Double* asin(Double* value) {
    if (!value) return nullptr;
    return new Double(std::asin(value->getDouble()));
}

Double* acos(Double* value) {
    if (!value) return nullptr;
    return new Double(std::acos(value->getDouble()));
}

Double* atan(Double* value) {
    if (!value) return nullptr;
    return new Double(std::atan(value->getDouble()));
}

Double* sqrt(Double* value) {
    if (!value) return nullptr;
    return new Double(std::sqrt(value->getDouble()));
}

Double* pow(Double* base, Double* exponent) {
    if (!base || !exponent) return nullptr;
    return new Double(std::pow(base->getDouble(), exponent->getDouble()));
}

Double* log(Double* value) {
    if (!value) return nullptr;
    return new Double(std::log(value->getDouble()));
}

Double* exp(Double* value) {
    if (!value) return nullptr;
    return new Double(std::exp(value->getDouble()));
}

Double* ceil(Double* value) {
    if (!value) return nullptr;
    return new Double(std::ceil(value->getDouble()));
}

Double* floor(Double* value) {
    if (!value) return nullptr;
    return new Double(std::floor(value->getDouble()));
}

Double* round(Double* value) {
    if (!value) return nullptr;
    return new Double(std::round(value->getDouble()));
}

// 混合参数版本
Double* pow(Int* base, Double* exponent) {
    if (!base || !exponent) return nullptr;
    return new Double(std::pow(base->getInt(), exponent->getDouble()));
}

Double* pow(Double* base, Int* exponent) {
    if (!base || !exponent) return nullptr;
    return new Double(std::pow(base->getDouble(), exponent->getInt()));
}

// Random 类实现
// 静态成员变量存储每个实例的随机数生成器
static std::map<Object*, std::mt19937> generators;
static std::map<Object*, std::uniform_real_distribution<double> > double_dists;
static std::map<Object*, std::uniform_int_distribution<int> > bool_dists;

Object* Random::cppEpt_(Int* seed) {
    // 创建新的 Object 实例
    Object* instance = new Object();
    
    // 初始化随机数生成器
    unsigned int seedValue = seed ? seed->getInt() : std::chrono::steady_clock::now().time_since_epoch().count();
    generators[instance] = std::mt19937(seedValue);
    double_dists[instance] = std::uniform_real_distribution<double>(0.0, 1.0);
    bool_dists[instance] = std::uniform_int_distribution<int>(0, 1);
    
    return instance;
}

Random* Random::secure() {
    // 使用硬件随机数生成器（如果可用）
    std::random_device rd;
    Object* instance = cppEpt_(new Int(rd()));
    return reinterpret_cast<Random*>(instance);
}

Int* Random::nextInt(Object* cppThis, Int* max) {
    if (!cppThis || !max || max->getInt() <= 0) return new Int(0);
    
    auto& generator = generators[cppThis];
    std::uniform_int_distribution<int> dist(0, max->getInt() - 1);
    return new Int(dist(generator));
}

Double* Random::nextDouble(Object* cppThis) {
    if (!cppThis) return new Double(0.0);
    
    auto& generator = generators[cppThis];
    auto& dist = double_dists[cppThis];
    return new Double(dist(generator));
}

Bool* Random::nextBool(Object* cppThis) {
    if (!cppThis) return new Bool(false);
    
    auto& generator = generators[cppThis];
    auto& dist = bool_dists[cppThis];
    return new Bool(dist(generator) == 1);
}

Random* Random::cppNew() {
    Object* instance = cppEpt_(nullptr);
    return reinterpret_cast<Random*>(instance);
}

// 比较函数实现
Int* max(Int* a, Int* b) {
    if (!a || !b) return nullptr;
    return new Int(std::max(a->getInt(), b->getInt()));
}

Double* max(Double* a, Double* b) {
    if (!a || !b) return nullptr;
    return new Double(std::max(a->getDouble(), b->getDouble()));
}

Double* max(Int* a, Double* b) {
    if (!a || !b) return nullptr;
    return new Double(std::max(static_cast<double>(a->getInt()), b->getDouble()));
}

Double* max(Double* a, Int* b) {
    if (!a || !b) return nullptr;
    return new Double(std::max(a->getDouble(), static_cast<double>(b->getInt())));
}

Int* min(Int* a, Int* b) {
    if (!a || !b) return nullptr;
    return new Int(std::min(a->getInt(), b->getInt()));
}

Double* min(Double* a, Double* b) {
    if (!a || !b) return nullptr;
    return new Double(std::min(a->getDouble(), b->getDouble()));
}

Double* min(Int* a, Double* b) {
    if (!a || !b) return nullptr;
    return new Double(std::min(static_cast<double>(a->getInt()), b->getDouble()));
}

Double* min(Double* a, Int* b) {
    if (!a || !b) return nullptr;
    return new Double(std::min(a->getDouble(), static_cast<double>(b->getInt())));
}

// Int 返回类型版本实现
Int* maxInt(Int* a, Int* b) {
    if (!a || !b) return nullptr;
    return new Int(std::max(a->getInt(), b->getInt()));
}

Int* minInt(Int* a, Int* b) {
    if (!a || !b) return nullptr;
    return new Int(std::min(a->getInt(), b->getInt()));
} 
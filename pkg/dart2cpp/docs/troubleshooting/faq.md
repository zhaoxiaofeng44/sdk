# Dart2CPP 常见问题解答 (FAQ)

## 🤔 常见问题

### 🚀 安装和配置

#### Q1: 如何安装 Dart2CPP？

**A**: Dart2CPP 目前需要从源码安装：

```bash
# 1. 确保已安装 Dart SDK 2.17.0+
dart --version

# 2. 克隆或获取项目源码
cd /path/to/dart2cpp

# 3. 安装依赖
dart pub get

# 4. 验证安装
dart bin/dart2cpp.dart --version
```

#### Q2: 提示找不到平台文件怎么办？

**A**: 这是最常见的问题之一。解决方法：

```bash
# 方法1: 自动查找平台文件
find /usr -name "vm_platform_strong.dill" 2>/dev/null

# 方法2: 使用 Dart SDK 路径
PLATFORM_PATH="$(dart --print-dart-sdk-path)/lib/_internal/vm_platform_strong.dill"
dart bin/dart2cpp.dart input.dart --platform "$PLATFORM_PATH"

# 方法3: 设置环境变量
export DART_PLATFORM_DILL="$PLATFORM_PATH"
dart bin/dart2cpp.dart input.dart
```

#### Q3: 包配置文件错误如何解决？

**A**: 包配置问题通常由以下原因引起：

```bash
# 1. 重新生成包配置
dart pub get

# 2. 检查配置文件是否存在
ls -la .dart_tool/package_config.json

# 3. 手动指定包配置
dart bin/dart2cpp.dart input.dart --packages .dart_tool/package_config.json

# 4. 如果仍有问题，清理并重新安装
dart pub cache clean
dart pub get
```

### 🔧 转换问题

#### Q4: 转换失败，提示语法错误怎么办？

**A**: 首先检查 Dart 代码本身是否正确：

```bash
# 1. 检查 Dart 代码语法
dart analyze input.dart

# 2. 确保代码可以正常运行
dart input.dart

# 3. 检查是否使用了不支持的特性
dart bin/dart2cpp.dart --features | grep "your_feature"

# 4. 使用详细模式查看具体错误
dart bin/dart2cpp.dart input.dart --verbose
```

#### Q5: 某些 Dart 特性转换失败？

**A**: 检查特性支持状态：

```bash
# 查看支持的特性列表
dart bin/dart2cpp.dart --features

# 常见不支持的特性及替代方案：
```

| 不支持特性 | 替代方案 |
|-----------|---------|
| `dart:mirrors` | 使用代码生成或静态分析 |
| `dart:io` | 使用 C++ 标准库 |
| 复杂异步模式 | 使用简化的 Future 实现 |
| 动态类型 | 使用静态类型声明 |

#### Q6: 生成的 C++ 代码有编译错误？

**A**: 常见编译错误及解决方案：

**错误1**: `'dart_string' was not declared in this scope`
```bash
# 解决：确保包含正确的头文件
g++ -I cpp/core -std=c++17 input.cpp cpp/core/object.cpp -o output
```

**错误2**: `undefined reference to 'StringPool::getInstance()'`
```bash
# 解决：链接运行时库
g++ -I cpp/core -std=c++17 input.cpp cpp/core/object.cpp -o output
```

**错误3**: C++ 标准版本错误
```bash
# 解决：使用 C++17 或更高版本
g++ -std=c++17 -I cpp/core input.cpp cpp/core/object.cpp -o output
```

### 🏃‍♂️ 运行时问题

#### Q7: 运行时出现段错误 (Segmentation Fault)？

**A**: 常见原因和调试方法：

```bash
# 1. 使用调试器运行
gdb ./your_program
(gdb) run
(gdb) bt  # 查看调用栈

# 2. 检查常见问题：
```

**常见原因**:
- 空指针访问
- 数组越界
- 未初始化的变量
- 循环引用导致的内存问题

**预防措施**:
```cpp
// 检查空指针
if (!dart_is_null(ptr)) {
    ptr->method();
}

// 检查数组边界
if (index >= 0 && index < list->size()) {
    auto item = list->get(index);
}
```

#### Q8: 内存泄漏问题？

**A**: Dart2CPP 使用智能指针管理内存，但仍需注意：

```cpp
// 正确：使用智能指针
auto list = List<Int>::create();
list->add(dart_int(42));
// 自动释放，无需手动删除

// 错误：手动内存管理
List<Int>* list = new List<Int>();  // 不推荐
delete list;  // 不需要，会导致问题
```

**内存泄漏检查**:
```bash
# 使用 Valgrind 检查内存泄漏
valgrind --leak-check=full ./your_program

# 使用 AddressSanitizer
g++ -fsanitize=address -g -I cpp/core input.cpp cpp/core/object.cpp -o output
./output
```

#### Q9: 性能比预期差？

**A**: 性能优化建议：

```bash
# 1. 启用编译器优化
g++ -O3 -DNDEBUG -std=c++17 -I cpp/core input.cpp cpp/core/object.cpp -o output

# 2. 使用转换器优化选项
dart bin/dart2cpp.dart input.dart --optimize

# 3. 性能分析
perf record ./output
perf report
```

**常见性能问题**:
- 频繁的对象创建和销毁
- 不必要的类型转换
- 字符串操作过多
- 集合操作效率低

### 📚 功能使用

#### Q10: 如何处理 Dart 的可空类型？

**A**: Dart2CPP 完全支持空安全：

```dart
// Dart 代码
String? nullableString;
String name = nullableString ?? "Default";

if (nullableString != null) {
    print(nullableString.length);
}
```

```cpp
// 转换后的 C++ 代码
String nullableString;  // 默认为 null
auto name = dart_null_coalesce(nullableString, dart_string("Default"));

if (!dart_is_null(nullableString)) {
    dart_print(nullableString.length());
}
```

#### Q11: 如何转换 Dart 的集合操作？

**A**: 高阶函数转换示例：

```dart
// Dart 代码
List<int> numbers = [1, 2, 3, 4, 5];
List<int> doubled = numbers.map((n) => n * 2).toList();
List<int> evens = numbers.where((n) => n % 2 == 0).toList();
```

```cpp
// 转换后的 C++ 代码
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto doubled = numbers->map([](Int n) { return (n * dart_int(2)); })->toList();
auto evens = numbers->where([](Int n) { return ((n % dart_int(2)) == dart_int(0)); })->toList();
```

#### Q12: 如何处理 Dart 的异步代码？

**A**: 目前异步支持有限，建议使用简化模式：

```dart
// Dart 异步代码 (部分支持)
Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 1));
    return "Data";
}
```

```cpp
// 转换后的 C++ 代码 (简化实现)
ObjectPtr<Future<String>> fetchData() {
    return Future<String>::delayed(
        Duration::seconds(1),
        []() { return dart_string("Data"); }
    );
}
```

### 🔧 开发和调试

#### Q13: 如何调试转换后的 C++ 代码？

**A**: 调试技巧和工具：

```cpp
// 1. 添加调试输出
#define DEBUG_PRINT(x) std::cout << "DEBUG: " << x << std::endl

int main() {
    DEBUG_PRINT("Program started");
    auto value = dart_int(42);
    DEBUG_PRINT("Value: " << value.toString().getValue());
    return 0;
}
```

```bash
# 2. 使用 GDB 调试
g++ -g -I cpp/core input.cpp cpp/core/object.cpp -o debug_output
gdb ./debug_output
(gdb) break main
(gdb) run
(gdb) step
```

```bash
# 3. 使用静态分析工具
clang-tidy input.cpp -- -I cpp/core -std=c++17
cppcheck --enable=all input.cpp
```

#### Q14: 如何贡献代码或报告问题？

**A**: 参与项目开发：

```bash
# 1. Fork 项目并创建分支
git clone your-fork-url
git checkout -b feature/your-feature

# 2. 运行测试确保没有破坏现有功能
dart test
cd cpp && make test

# 3. 提交代码
git add .
git commit -m "Add: your feature description"
git push origin feature/your-feature

# 4. 创建 Pull Request
```

**报告问题时请提供**:
- Dart 源代码
- 转换命令
- 错误信息
- 环境信息 (OS, Dart 版本等)

#### Q15: 如何扩展 Dart2CPP 支持新特性？

**A**: 扩展指南：

```dart
// 1. 在转换器中添加新的表达式处理
// lib/dart_to_cpp_compiler.dart
String convertNewExpression(NewExpression expr) {
    // 实现转换逻辑
    return convertedCode;
}
```

```cpp
// 2. 在运行时库中添加对应的 C++ 实现
// cpp/core/new_feature.h
class NewFeature : public Any {
public:
    // 实现新特性
};
```

```dart
// 3. 添加测试用例
// test/new_feature_test.dart
test('new feature conversion', () {
    final result = converter.convert(dartCode);
    expect(result, contains(expectedCppCode));
});
```

### 🔍 性能和优化

#### Q16: 如何提高转换性能？

**A**: 转换性能优化：

```bash
# 1. 使用并行转换
find src -name "*.dart" | parallel dart bin/dart2cpp.dart {} -o {.}.cpp

# 2. 增量转换
# 只转换修改过的文件
for file in src/*.dart; do
    cpp_file="build/$(basename "$file" .dart).cpp"
    if [[ "$file" -nt "$cpp_file" ]]; then
        dart bin/dart2cpp.dart "$file" -o "$cpp_file"
    fi
done

# 3. 使用优化选项
dart bin/dart2cpp.dart input.dart --optimize
```

#### Q17: 如何优化生成的 C++ 代码性能？

**A**: C++ 代码优化：

```bash
# 1. 编译器优化
g++ -O3 -march=native -DNDEBUG -std=c++17 \
    -I cpp/core input.cpp cpp/core/object.cpp -o optimized

# 2. 链接时优化 (LTO)
g++ -O3 -flto -std=c++17 \
    -I cpp/core input.cpp cpp/core/object.cpp -o optimized

# 3. 性能分析
perf record ./optimized
perf report
```

**代码级优化**:
```cpp
// 避免不必要的对象创建
auto result = expensive_operation();  // 好
auto result = expensive_operation().copy();  // 差

// 使用引用传递大对象
void process(const ObjectPtr<List<String>>& list);  // 好
void process(ObjectPtr<List<String>> list);  // 差

// 预分配容器容量
auto list = List<Int>::create();
list->reserve(1000);  // 如果支持
```

### 📱 平台特定问题

#### Q18: 在 Windows 上使用有什么注意事项？

**A**: Windows 平台特殊配置：

```bash
# 1. 使用 MSYS2 或 WSL
# 在 MSYS2 中：
pacman -S mingw-w64-x86_64-gcc
pacman -S mingw-w64-x86_64-cmake

# 2. 路径分隔符问题
# 使用正斜杠或双反斜杠
dart bin/dart2cpp.dart src/main.dart -o build/main.cpp

# 3. 编译命令
g++ -std=c++17 -I cpp/core main.cpp cpp/core/object.cpp -o main.exe
```

#### Q19: 在 macOS 上编译失败？

**A**: macOS 特殊处理：

```bash
# 1. 安装 Xcode Command Line Tools
xcode-select --install

# 2. 使用 Homebrew 安装依赖
brew install llvm
brew install cmake

# 3. 可能需要指定编译器
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
g++ -std=c++17 -I cpp/core input.cpp cpp/core/object.cpp -o output
```

#### Q20: 在 Linux 发行版上的兼容性问题？

**A**: Linux 发行版特殊配置：

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install build-essential cmake

# CentOS/RHEL
sudo yum groupinstall "Development Tools"
sudo yum install cmake

# Arch Linux
sudo pacman -S base-devel cmake

# 如果遇到 GLIBC 版本问题
ldd --version
# 可能需要使用静态链接
g++ -static -std=c++17 -I cpp/core input.cpp cpp/core/object.cpp -o output
```

## 🆘 获取更多帮助

### 官方资源

- **项目文档**: [docs/README.md](../README.md)
- **API 参考**: [docs/api-reference/](../api-reference/)
- **示例代码**: [sample/dart/](../../sample/dart/)

### 社区支持

- **GitHub Issues**: 报告 Bug 和功能请求
- **GitHub Discussions**: 技术讨论和问答
- **Stack Overflow**: 使用 `dart2cpp` 标签

### 联系方式

如果以上解答没有解决您的问题，请：

1. 查看 [GitHub Issues](https://github.com/dart-lang/dart2cpp/issues) 中是否有类似问题
2. 创建新的 Issue，提供详细的问题描述和复现步骤
3. 参与 [GitHub Discussions](https://github.com/dart-lang/dart2cpp/discussions) 讨论

---

💡 **提示**: 这个 FAQ 会持续更新。如果您遇到了新问题并找到了解决方案，欢迎贡献到这个文档中！

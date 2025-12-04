# Dart2CPP 安装指南

## 📋 系统要求

### 最低要求

| 组件 | 版本要求 | 说明 |
|------|---------|------|
| **操作系统** | macOS 10.14+, Ubuntu 18.04+, Windows 10+ | 支持主流操作系统 |
| **Dart SDK** | 2.17.0+ | 核心依赖，必须安装 |
| **C++ 编译器** | GCC 7+, Clang 6+, MSVC 2019+ | 编译生成的 C++ 代码 |
| **内存** | 4GB RAM | 推荐 8GB+ |
| **磁盘空间** | 500MB | 包含 SDK 和依赖 |

### 推荐配置

| 组件 | 推荐版本 | 说明 |
|------|---------|------|
| **Dart SDK** | 3.0.0+ | 最新稳定版 |
| **C++ 编译器** | GCC 11+, Clang 14+ | 更好的 C++17 支持 |
| **CMake** | 3.16+ | 可选，用于复杂项目构建 |
| **内存** | 8GB+ RAM | 大型项目转换 |

## 🛠️ 安装步骤

### 1. 安装 Dart SDK

#### macOS

**使用 Homebrew (推荐)**:
```bash
# 安装 Homebrew (如果未安装)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装 Dart SDK
brew tap dart-lang/dart
brew install dart

# 验证安装
dart --version
```

**手动安装**:
```bash
# 下载 Dart SDK
curl -O https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-macos-x64-release.zip

# 解压并安装
unzip dartsdk-macos-x64-release.zip
sudo mv dart-sdk /usr/local/

# 添加到 PATH
echo 'export PATH="/usr/local/dart-sdk/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### Ubuntu/Debian

**使用 APT (推荐)**:
```bash
# 添加 Dart 仓库
sudo apt update
sudo apt install apt-transport-https
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list

# 安装 Dart SDK
sudo apt update
sudo apt install dart

# 验证安装
dart --version
```

**使用 Snap**:
```bash
sudo snap install dart-sdk --classic
```

#### CentOS/RHEL/Fedora

**使用 DNF/YUM**:
```bash
# 添加仓库
sudo tee /etc/yum.repos.d/dart.repo << EOF
[dart]
name=Dart Repository
baseurl=https://storage.googleapis.com/download.dartlang.org/linux/centos/stable/
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

# 安装 Dart SDK
sudo dnf install dart  # Fedora
# 或
sudo yum install dart   # CentOS/RHEL

# 验证安装
dart --version
```

#### Windows

**使用 Chocolatey (推荐)**:
```powershell
# 安装 Chocolatey (如果未安装)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 安装 Dart SDK
choco install dart-sdk

# 验证安装
dart --version
```

**手动安装**:
1. 访问 [Dart SDK 下载页面](https://dart.dev/get-dart)
2. 下载 Windows 版本的 SDK
3. 解压到 `C:\dart-sdk`
4. 添加 `C:\dart-sdk\bin` 到系统 PATH
5. 重启命令提示符并验证：`dart --version`

### 2. 安装 C++ 编译器

#### macOS

**安装 Xcode Command Line Tools**:
```bash
xcode-select --install
```

**验证安装**:
```bash
clang++ --version
g++ --version
```

#### Ubuntu/Debian

```bash
# 安装 GCC
sudo apt update
sudo apt install build-essential

# 验证安装
g++ --version
gcc --version
```

#### CentOS/RHEL/Fedora

```bash
# 安装开发工具组
sudo dnf groupinstall "Development Tools"  # Fedora
# 或
sudo yum groupinstall "Development Tools"  # CentOS/RHEL

# 验证安装
g++ --version
```

#### Windows

**使用 MSYS2 (推荐)**:
```bash
# 1. 下载并安装 MSYS2 from https://www.msys2.org/
# 2. 在 MSYS2 终端中运行：
pacman -S mingw-w64-x86_64-gcc
pacman -S mingw-w64-x86_64-cmake

# 3. 添加到 PATH: C:\msys64\mingw64\bin
```

**使用 Visual Studio**:
1. 安装 Visual Studio 2019 或更新版本
2. 确保安装了 "C++ 构建工具" 工作负载
3. 验证：`cl` 命令可用

### 3. 安装可选工具

#### CMake (推荐)

**macOS**:
```bash
brew install cmake
```

**Ubuntu/Debian**:
```bash
sudo apt install cmake
```

**Windows**:
```bash
choco install cmake
```

#### Git (版本控制)

**macOS**:
```bash
brew install git
```

**Ubuntu/Debian**:
```bash
sudo apt install git
```

**Windows**:
```bash
choco install git
```

## 📦 获取 Dart2CPP

### 方法 1: 从源码安装 (推荐)

```bash
# 1. 克隆仓库
git clone https://github.com/dart-lang/dart2cpp.git
cd dart2cpp

# 2. 安装 Dart 依赖
dart pub get

# 3. 验证安装
dart bin/dart2cpp.dart --version
dart bin/dart2cpp.dart --help
```

### 方法 2: 下载发布版本

```bash
# 1. 下载最新发布版本
curl -L -o dart2cpp-2.0.0.tar.gz https://github.com/dart-lang/dart2cpp/archive/v2.0.0.tar.gz

# 2. 解压
tar -xzf dart2cpp-2.0.0.tar.gz
cd dart2cpp-2.0.0

# 3. 安装依赖
dart pub get

# 4. 验证安装
dart bin/dart2cpp.dart --version
```

## ✅ 验证安装

### 基本验证

```bash
# 1. 检查 Dart SDK
dart --version

# 2. 检查 C++ 编译器
g++ --version
# 或
clang++ --version

# 3. 检查 Dart2CPP
cd /path/to/dart2cpp
dart bin/dart2cpp.dart --version
dart bin/dart2cpp.dart --features
```

### 完整测试

创建测试文件 `test_install.dart`:
```dart
void main() {
  print('Hello, Dart2CPP!');
  
  int number = 42;
  String message = 'Installation test';
  
  print('$message: $number');
}
```

运行完整测试：
```bash
# 1. 转换 Dart 到 C++
dart bin/dart2cpp.dart test_install.dart -o test_install.cpp

# 2. 编译 C++ 代码
g++ -std=c++17 -I cpp/core test_install.cpp cpp/core/object.cpp -o test_install

# 3. 运行测试程序
./test_install

# 预期输出：
# Hello, Dart2CPP!
# Installation test: 42
```

如果所有步骤都成功，说明安装完成！

## 🔧 环境配置

### 设置环境变量

创建 `~/.dart2cpp_env` 文件：
```bash
# Dart2CPP 环境配置
export DART2CPP_HOME="/path/to/dart2cpp"
export DART2CPP_PLATFORM="$(dart --print-dart-sdk-path)/lib/_internal/vm_platform_strong.dill"
export PATH="$DART2CPP_HOME/bin:$PATH"

# C++ 编译选项
export DART2CPP_CXX_FLAGS="-std=c++17 -O2"
export DART2CPP_INCLUDE_PATH="$DART2CPP_HOME/cpp/core"
```

加载环境变量：
```bash
# 添加到 shell 配置文件
echo 'source ~/.dart2cpp_env' >> ~/.bashrc  # Bash
echo 'source ~/.dart2cpp_env' >> ~/.zshrc   # Zsh

# 重新加载
source ~/.bashrc  # 或 ~/.zshrc
```

### 创建便捷脚本

创建 `/usr/local/bin/dart2cpp` 脚本：
```bash
#!/bin/bash
# Dart2CPP 便捷脚本

DART2CPP_HOME="/path/to/dart2cpp"
exec dart "$DART2CPP_HOME/bin/dart2cpp.dart" "$@"
```

设置执行权限：
```bash
chmod +x /usr/local/bin/dart2cpp
```

现在可以直接使用：
```bash
dart2cpp input.dart -o output.cpp
```

### IDE 集成配置

#### VS Code

安装推荐扩展：
```json
{
  "recommendations": [
    "dart-code.dart-code",
    "ms-vscode.cpptools",
    "ms-vscode.cmake-tools"
  ]
}
```

配置任务 (`.vscode/tasks.json`):
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Dart2CPP: Convert",
      "type": "shell",
      "command": "dart",
      "args": [
        "${workspaceFolder}/bin/dart2cpp.dart",
        "${file}",
        "-o",
        "${fileDirname}/${fileBasenameNoExtension}.cpp"
      ],
      "group": "build"
    }
  ]
}
```

#### IntelliJ IDEA / Android Studio

1. 安装 Dart 插件
2. 配置外部工具：
   - **Name**: Dart2CPP
   - **Program**: `dart`
   - **Arguments**: `bin/dart2cpp.dart $FilePath$ -o $FileNameWithoutExtension$.cpp`
   - **Working directory**: `$ProjectFileDir$`

## 🚨 常见问题

### 问题 1: 找不到 Dart 命令

**错误**: `dart: command not found`

**解决方案**:
```bash
# 检查 Dart 是否安装
which dart

# 如果未找到，检查 PATH
echo $PATH

# 手动添加 Dart 到 PATH
export PATH="/usr/lib/dart/bin:$PATH"  # Ubuntu
export PATH="/usr/local/dart-sdk/bin:$PATH"  # macOS
```

### 问题 2: 平台文件未找到

**错误**: `Platform file not found`

**解决方案**:
```bash
# 查找平台文件
find /usr -name "vm_platform_strong.dill" 2>/dev/null

# 设置环境变量
export DART_PLATFORM_DILL="$(dart --print-dart-sdk-path)/lib/_internal/vm_platform_strong.dill"
```

### 问题 3: C++ 编译失败

**错误**: `g++: command not found`

**解决方案**:
```bash
# Ubuntu/Debian
sudo apt install build-essential

# macOS
xcode-select --install

# Windows (MSYS2)
pacman -S mingw-w64-x86_64-gcc
```

### 问题 4: 权限错误

**错误**: `Permission denied`

**解决方案**:
```bash
# 检查文件权限
ls -la dart2cpp/

# 修复权限
chmod +x bin/dart2cpp.dart
chmod -R 755 dart2cpp/
```

## 📚 下一步

安装完成后，您可以：

1. **阅读快速入门**: [docs/getting-started/quickstart.md](quickstart.md)
2. **查看示例**: [sample/dart/](../../sample/dart/)
3. **学习 API**: [docs/api-reference/](../api-reference/)
4. **了解特性**: [docs/features/supported-features.md](../features/supported-features.md)

## 🆘 获取帮助

如果遇到安装问题：

1. 查看 [FAQ](../troubleshooting/faq.md)
2. 搜索 [GitHub Issues](https://github.com/dart-lang/dart2cpp/issues)
3. 创建新的 Issue 并提供：
   - 操作系统和版本
   - Dart SDK 版本
   - 完整的错误信息
   - 安装步骤

---

🎉 **恭喜！** 您已成功安装 Dart2CPP。现在可以开始将 Dart 代码转换为 C++ 了！

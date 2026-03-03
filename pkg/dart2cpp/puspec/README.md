# Dart2CPP PuSpec 工作目录

本目录包含 Dart2CPP 项目的所有 PU（Process Unit）规范文档和测试验证流程。

## 📁 目录结构

```
puspec/
├── README.md                          # 本文件
├── project.md                         # 项目技术规范
├── changes/                           # 变更目录
│   └── uc-dart2cpp/                  # 用例：Dart2CPP 转换器
│       └── pu-converter-fix/         # PU：转换器修复流程
│           ├── pu-converter-fix-change.json       # PU 定义
│           └── pu-converter-fix-change.impl.md    # 实现文档
└── knowledges/                        # 领域知识库
    └── tech/                          # 技术知识
        └── converter-testing-guidelines.md  # 转换器测试指南
```

## 🎯 快速开始

### 1. 修改代码前记录基线

在进行任何代码修改之前，先记录当前的测试基线：

```bash
./scripts/validate_converter_changes.sh --baseline
```

这将：
- 运行完整测试套件
- 记录当前成功率
- 保存基线文件到 `test_results_archive/`

### 2. 修改代码

根据测试结果和需求，修改转换器代码。

### 3. 验证修改效果

完成修改后，运行验证脚本：

```bash
./scripts/validate_converter_changes.sh
```

这将：
- 运行完整测试套件
- 与最新基线对比
- 显示成功率变化
- 分析新增失败（如果有）

### 4. 分析结果

根据验证结果采取行动：

- **成功率提升** ✅：继续修复下一个问题
- **成功率持平** ⚠️：检查是否真正解决了问题
- **成功率下降** ❌：立即分析并修复或回滚

## 📊 核心规则

### 规则 1：修改前必须记录基线
- 确保有对比基准
- 避免无法评估修改效果

### 规则 2：修改后必须完整验证
- 运行所有测试用例
- 不要只测试修改相关的部分

### 规则 3：成功率下降必须分析
- 查看新增失败的测试
- 检查最近修改的文件
- 定位问题代码
- 修复或回滚

### 规则 4：小步快跑
- 每次只修复一个问题
- 立即验证效果
- 避免批量修改

## 🛠️ 工具使用

### 验证脚本

```bash
# 显示帮助
./scripts/validate_converter_changes.sh --help

# 记录基线
./scripts/validate_converter_changes.sh --baseline

# 与指定基线对比
./scripts/validate_converter_changes.sh --compare test_results_archive/baseline_20260127_112000.txt

# 设置超时时间
./scripts/validate_converter_changes.sh --timeout 600
```

### 测试结果归档

测试结果自动保存到 `test_results_archive/` 目录：

- 基线文件：`baseline_YYYYMMDD_HHMMSS.txt`
- 测试结果：`test_results_YYYYMMDD_HHMMSS.txt`
- 自动保留最近 10 次结果

## 📖 文档说明

### PU 实现文档

`changes/uc-dart2cpp/pu-converter-fix/pu-converter-fix-change.impl.md` 包含：

1. **业务目标**：建立系统化的修复流程
2. **输入输出定义**：明确的参数和结果
3. **核心业务规则**：4 条强制规则
4. **处理流程**：5 步完整流程
5. **实现伪代码**：可执行的算法描述
6. **异常处理**：3 种异常场景
7. **实现约束**：技术规范和性能要求
8. **测试方案**：单元测试和集成测试

### 测试指南

`knowledges/tech/converter-testing-guidelines.md` 包含：

1. **核心原则**：3 条必须遵守的原则
2. **使用场景**：3 种典型场景的操作步骤
3. **成功率标准**：目标和容忍度
4. **警告信号**：红色、黄色、绿色信号
5. **问题定位技巧**：3 种实用技巧
6. **最佳实践**：DO 和 DON'T
7. **工具使用**：详细的命令说明

## 🎯 成功率目标

### 短期目标（1-2 周）
- 修复所有已知的编译错误
- 成功率达到 80%
- 建立完整的测试基线

### 中期目标（1-2 月）
- 成功率达到 90%
- 所有基础语法测试通过
- 建立自动化 CI/CD 流程

### 长期目标（3-6 月）
- 成功率达到 95%
- 支持所有 Dart 核心特性
- 性能优化和代码质量提升

## 📝 本次修复记录

### 修复内容（2026-01-27）

1. ✅ **修复 dart_async.h 字符串连接错误**
   - 文件：`cpp/core/dart_async.h`
   - 修改：使用 `std::string` 正确连接字符串
   - 位置：第 269 和 338 行

2. ✅ **修复头文件引用路径问题**
   - 文件：`lib/dart_to_cpp_compiler.dart`
   - 修改：统一使用 `#include "dart2cpp.h"`
   - 位置：第 5600 行

3. ✅ **验证 ForStatement 转换逻辑**
   - 结果：代码逻辑正确
   - 格式：`for ($variables; $condition; $updates)`

4. ✅ **验证 main 函数生成逻辑**
   - 结果：只生成一个 `int main()` 函数
   - 无重复问题

### 测试验证

- **测试用例**：hello_test.dart
- **转换结果**：✅ 成功
- **生成代码**：✅ 语法正确
- **头文件引用**：✅ 正确使用 `#include "dart2cpp.h"`
- **for 循环**：✅ 正确生成 `for (init; condition; update)`
- **main 函数**：✅ 只有一个 `int main()`

## 🔗 相关资源

- [PU-Spec Skill 文档](../.aone_copilot/skills/pu-spec-skill/SKILL.md)
- [项目技术规范](project.md)
- [转换器测试指南](knowledges/tech/converter-testing-guidelines.md)
- [测试结果归档](../test_results_archive/)

## 💡 提示

1. **首次使用**：先运行 `--baseline` 记录基线
2. **持续改进**：每次修改后都要验证
3. **保持记录**：定期查看测试历史
4. **及时分析**：成功率下降立即处理
5. **文档更新**：修改后更新相关文档

---

**版本**: 1.0.0  
**最后更新**: 2026-01-27  
**维护者**: Dart2CPP Team

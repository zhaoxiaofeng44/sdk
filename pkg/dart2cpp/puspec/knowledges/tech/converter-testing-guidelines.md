# Dart2CPP 转换器测试指南

> **版本**: 1.0.0  
> **最后更新**: 2026-01-27  
> **适用范围**: 所有转换器代码修改

---

## 📋 核心原则

### 原则 1：修改前必须记录基线
在进行任何代码修改之前，必须先运行完整测试套件并记录基线成功率。

**执行命令**：
```bash
./scripts/validate_converter_changes.sh --baseline
```

**输出示例**：
```
📊 当前测试结果:
  总测试数: 25
  成功数: 18
  成功率: 72.00%

✅ 基线已保存: test_results_archive/baseline_20260127_112000.txt
```

### 原则 2：修改后必须完整验证
完成代码修改后，必须运行完整测试套件并与基线对比。

**执行命令**：
```bash
./scripts/validate_converter_changes.sh --compare test_results_archive/baseline_20260127_112000.txt
```

**输出示例**：
```
📊 当前测试结果:
  总测试数: 25
  成功数: 20
  成功率: 80.00%

📊 基线测试结果:
  总测试数: 25
  成功数: 18
  成功率: 72.00%

📈 成功率变化:
  +8.00% ⬆️  (提升)
```

### 原则 3：成功率下降必须分析
如果成功率下降，必须立即分析原因并采取措施。

**分析步骤**：
1. 查看新增失败的测试用例
2. 检查最近修改的文件
3. 对比修改前后的代码差异
4. 定位导致失败的具体修改
5. 修复问题或回滚修改

---

## 🔧 使用场景

### 场景 1：修复单个问题

```bash
# 1. 记录基线
./scripts/validate_converter_changes.sh --baseline

# 2. 修改代码（如修复头文件路径问题）
# 编辑 lib/dart_to_cpp_compiler.dart

# 3. 验证修改效果
./scripts/validate_converter_changes.sh

# 4. 查看结果，确认成功率提升或持平
```

### 场景 2：修复多个问题

```bash
# 1. 记录基线
./scripts/validate_converter_changes.sh --baseline

# 2. 修改第一个问题
# 编辑文件...

# 3. 验证第一个修改
./scripts/validate_converter_changes.sh

# 4. 如果成功率提升，继续修改第二个问题
# 如果成功率下降，回滚第一个修改

# 5. 重复步骤 2-4，直到所有问题修复完成
```

### 场景 3：大规模重构

```bash
# 1. 记录基线
./scripts/validate_converter_changes.sh --baseline

# 2. 创建新分支
git checkout -b refactor-converter

# 3. 分阶段修改，每个阶段都验证
# 阶段 1：重构类型转换逻辑
./scripts/validate_converter_changes.sh

# 阶段 2：重构表达式转换逻辑
./scripts/validate_converter_changes.sh

# 阶段 3：重构语句转换逻辑
./scripts/validate_converter_changes.sh

# 4. 如果任何阶段成功率下降，立即停止并分析
```

---

## 📊 成功率标准

### 目标成功率
- **最低要求**：不低于基线成功率
- **理想目标**：每次修改提升 5-10%
- **长期目标**：达到 90% 以上

### 成功率下降容忍度
- **0-2%**：可接受，但需记录原因
- **2-5%**：需要分析和修复
- **5-10%**：必须立即修复或回滚
- **>10%**：自动回滚，重新评估修改方案

---

## 🚨 警告信号

### 红色警告（立即处理）
- ❌ 成功率下降超过 10%
- ❌ 新增 5 个以上失败测试
- ❌ 之前成功的核心测试失败
- ❌ 编译错误大量增加

### 黄色警告（需要关注）
- ⚠️ 成功率下降 2-5%
- ⚠️ 新增 2-4 个失败测试
- ⚠️ 某类测试全部失败（如异步测试）
- ⚠️ 编译时间显著增加

### 绿色信号（继续前进）
- ✅ 成功率提升或持平
- ✅ 没有新增失败测试
- ✅ 之前失败的测试开始通过
- ✅ 代码质量提升

---

## 🔍 问题定位技巧

### 技巧 1：二分查找
如果一次修改了多个文件，使用二分法定位问题：

```bash
# 1. 回滚所有修改
git reset --hard HEAD

# 2. 只应用一半的修改
git cherry-pick <commit1> <commit2>

# 3. 测试
./scripts/validate_converter_changes.sh

# 4. 根据结果决定保留哪一半
# 重复步骤 2-4，直到定位到具体的修改
```

### 技巧 2：单独测试失败用例
对于新增失败的测试，单独运行并查看详细错误：

```bash
# 运行单个测试
dart bin/dart2cpp.dart sample/dart/failing_test.dart -o /tmp/test.cpp

# 查看生成的代码
cat /tmp/test.cpp

# 尝试编译
g++ -std=c++17 -I./cpp/core /tmp/test.cpp ./cpp/build/*.o -o /tmp/test
```

### 技巧 3：对比生成代码
对比修改前后生成的 C++ 代码：

```bash
# 修改前
git stash
dart bin/dart2cpp.dart sample/dart/test.dart -o /tmp/before.cpp

# 修改后
git stash pop
dart bin/dart2cpp.dart sample/dart/test.dart -o /tmp/after.cpp

# 对比
diff /tmp/before.cpp /tmp/after.cpp
```

---

## 📝 最佳实践

### ✅ DO（推荐做法）

1. **小步快跑**：每次只修复一个问题，立即验证
2. **记录基线**：修改前必须记录基线
3. **完整测试**：不要只测试修改相关的用例
4. **及时归档**：保持测试历史的完整性
5. **分析趋势**：定期查看成功率趋势图
6. **文档更新**：修改后更新相关文档

### ❌ DON'T（避免做法）

1. **批量修改**：一次修改多个文件后才测试
2. **部分测试**：只测试部分用例
3. **忽略下降**：成功率小幅下降也要分析
4. **跳过基线**：不记录基线就开始修改
5. **盲目修复**：不分析就直接修改代码
6. **忽略警告**：忽略编译警告和 lint 错误

---

## 🛠️ 工具使用

### 验证脚本参数

```bash
# 显示帮助
./scripts/validate_converter_changes.sh --help

# 仅记录基线
./scripts/validate_converter_changes.sh --baseline

# 与指定基线对比
./scripts/validate_converter_changes.sh --compare baseline.txt

# 设置超时时间（默认 300 秒）
./scripts/validate_converter_changes.sh --timeout 600

# 组合使用
./scripts/validate_converter_changes.sh --compare baseline.txt --timeout 600
```

### 测试结果归档

测试结果自动归档到 `test_results_archive/` 目录：

```
test_results_archive/
├── baseline_20260127_112000.txt    # 基线文件
├── test_results_20260127_113000.txt # 测试结果
├── test_results_20260127_114000.txt
└── ...
```

归档文件命名规则：
- 基线文件：`baseline_YYYYMMDD_HHMMSS.txt`
- 测试结果：`test_results_YYYYMMDD_HHMMSS.txt`
- 自动保留最近 10 次结果

---

## 📈 成功率趋势分析

### 查看历史成功率

```bash
# 查看所有归档文件的成功率
for file in test_results_archive/test_results_*.txt; do
    echo "$(basename $file):"
    grep -A2 "当前测试结果" $file | grep "成功率" || echo "  无数据"
done
```

### 生成趋势图（手动）

1. 提取成功率数据
2. 使用 Excel 或其他工具绘制折线图
3. 分析趋势和异常点

---

## 🎯 目标与里程碑

### 短期目标（1-2 周）
- [ ] 修复所有已知的编译错误
- [ ] 成功率达到 80%
- [ ] 建立完整的测试基线

### 中期目标（1-2 月）
- [ ] 成功率达到 90%
- [ ] 所有基础语法测试通过
- [ ] 建立自动化 CI/CD 流程

### 长期目标（3-6 月）
- [ ] 成功率达到 95%
- [ ] 支持所有 Dart 核心特性
- [ ] 性能优化和代码质量提升

---

**文档版本**: 1.0.0  
**最后更新**: 2026-01-27  
**维护者**: Dart2CPP Team

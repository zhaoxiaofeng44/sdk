---
name: pu-spec-skill
version: 0.9.0
description: PuSpec（Process Unit Specification）是一款规范驱动开发工具，基于 PU（Process Unit）设计思想和 SDD（Specification-Driven Development）方法论。用于生成、管理和归档业务处理单元的实现文档和代码。适用于需要高可复现性、可测试性、可维护性的业务开发场景。
---

# PuSpec - 规范驱动开发工具

## 概述

PuSpec 是一款以 **PU（Process Unit，处理单元）** 为核心的规范驱动开发工具，帮助团队通过结构化文档驱动高质量代码实现。

**核心价值：**
- 📋 **规范先行**：先写详细设计文档，再生成代码
- 🎯 **单一职责**：每个 PU 对应一个独立的业务处理单元
- 🔄 **可复现性**：基于文档可准确复现实现逻辑
- ✅ **可测试性**：自动生成完整的单元测试代码
- 📚 **可维护性**：文档与代码同步更新，便于长期维护

---

## 开始

### 核心步骤

- 阅读constitution.md
- 根据需要读取(init.md\impl.md\coding.md\ut.md\archive.md)

**指令说明：**
- `${pu_id}` 为 PU 的唯一标识（kebab-case 格式）
- 指令按顺序执行，形成完整的开发流程

---

## 核心执行原则

在使用 PuSpec 时，必须严格遵守以下 3 条核心原则：

### 🔴 1. 防幻觉约束（适用于所有指令）

- ✅ **基于实际代码**：所有描述必须基于真实代码分析，不得假设或推测
- ❌ **禁止期望功能**：不得将变更需求中的期望功能写入基线文档
- ✅ **明确区分**：清晰区分"已实现"和"待实现"
- ✅ **验证机制**：通过 file_grep、codebase_search、read_file 验证功能存在性

### 🔴 2. 文档权威性（适用于 coding 指令）

- **变更实现文档**（`pu-xxx-change.impl.md`）是唯一执行准则
- 100% 严格遵循其设计思路与实现方案
- 禁止修改方法签名、增删参数、改变数据来源、改变逻辑顺序
- 禁止简化/省略文档要求的步骤
- 逐字逐句理解伪代码，严格按数据流转图实现

### 🔴 3. 增量更新策略（适用于 impl/archive 指令）

- ✅ 优先复用现有基线文档
- ✅ 仅更新有变更的相关章节
- ✅ 清晰标记更新 `[Updated YYYY-MM-DD]`
- ❌ 禁止全量重写基线文档
- ❌ 禁止假设代码与文档一致

### 🔴 4. plan.md 同步更新（适用于 coding 指令）

- ✅ 每完成一个功能点，**必须立即**更新 `*-coding-plan.md` 中对应行的状态（⏳→✅）
- ❌ 禁止仅使用 `todo_write` 而不更新 plan.md
- ✅ coding 任务结束前，必须确认 plan.md 中所有已完成功能点的状态为 ✅
- ✅ 验证不通过时，更新状态为 ❌ 并记录失败原因

---



## 文档结构

PuSpec 使用分层文档结构来管理不同类型的信息：

**Skill 目录结构**（保持纯净，仅包含规范文件）：
```
pu-spec-skill/                   # Skill 目录
├── reference/
    └──constitution.md              # 详细执行规范（必读）
    ├── init.md                     # 初始化指令
    ├── impl.md                     # 实现文档指令
    ├── coding.md                   # 代码生成指令
    ├── ut.md                       # 单元测试指令
    ├── archive.md                  # 归档指令
├── SKILL.md                     # 快速入门指南
├── pu.sodd.md                   # SODD 规范模板
└── templates/                   # 模板目录
    └── impl.template.md         # 实现文档模板
```

**项目工作目录结构**（在项目根目录下）：
```
{项目根目录}/
├── src/                         # 项目源代码
├── pom.xml                      # 项目配置
└── puspec/                      # PuSpec 工作目录
    ├── project.md               # 项目技术规范
    ├── specs/                   # 基线规范目录
    │   └── uc-xxx/
    │       └── pu-xxx/
    │           ├── pu-xxx.json      # PU 定义
    │           └── pu-xxx.impl.md   # 实现文档（基线）
    ├── changes/                 # 变更目录
    │   ├── uc-xxx/
    │   │   └── pu-xxx/
    │   │       ├── pu-xxx-change.json       # 变更需求
    │   │       ├── pu-xxx-change.detail.md  # 技术方案（可选）
    │   │       └── pu-xxx-change.impl.md    # 变更实现文档
    │   └── archive/             # 归档目录
    └── knowledges/              # 领域知识库
        ├── biz/                 # 业务知识
        └── tech/                # 技术知识
```

**说明**：
- **Skill 目录**：存放 PuSpec 的规范定义，可被多个项目复用
- **puspec/ 目录**：存放项目特定的文档和变更，由 `init` 指令自动创建
- **解耦优势**：Skill 规范与项目实现分离，便于版本控制和多项目管理

---

## 详细文档

要了解完整的执行规范、指令详解和最佳实践，请参阅。其中constitution.md必读：

- **[constitution.md](reference/constitution.md)** - 完整的执行规范和规则（必读）
- **[project.md](project.md)** - 项目技术规范模板
- **[pu.sodd.md](pu.sodd.md)** - SODD 规范模板
- **[impl.template.md](templates/impl.template.md)** - 实现文档模板
- **[init.md](reference/init.md)** - 初始化指令
- **[impl.md](reference/impl.md)** - 实现文档指令
- **[coding.md](reference/coding.md)** - 代码生成指令
- **[ut.md](reference/ut.md)** - 单元测试指令
- **[archive.md](reference/archive.md)** - 归档指令

---

## 关键概念

### PU（Process Unit）

**定义**：单一职责的业务处理单元，对应独立的接口/服务方法。

**特征**：
- 单一职责：一个 PU 只做一件事
- 独立可测：可独立编写单元测试
- 清晰边界：输入输出明确定义

### SDD（Specification-Driven Development）

**定义**：以详细规范文档为核心驱动力的开发模式。

**核心流程**：
1. 编写详细的规范文档（业务目标、输入输出、业务规则、实现方案）
2. 基于规范文档生成代码
3. 代码与文档同步更新

---

## 最佳实践

### ✅ DO

1. **先文档后代码**：确保实现文档完整准确后再生成代码
2. **增量更新**：升级现有 PU 时，只更新变更部分
3. **验证优先**：使用工具验证代码存在性，不要假设
4. **保持同步**：代码变更后及时更新文档

### ❌ DON'T

1. **不要跳过文档**：直接生成代码会导致质量问题
2. **不要全量重写**：升级时避免重写整个基线文档
3. **不要假设实现**：必须通过工具验证代码实际存在
4. **不要偏离文档**：coding 时必须 100% 遵循 impl.md
5. **不执行未提供的指令**：没有提供的指令不执行，等待人工输入

---

## 故障排除

### 问题：AI 不使用我的 Skill

**检查项：**
1. SKILL.md 是否在正确位置（`.claude/skills/pu-spec/` 或 `~/.claude/skills/pu-spec/`）
2. YAML frontmatter 格式是否正确
3. description 是否足够具体（包含关键术语）

### 问题：生成的代码与文档不一致

**原因：**
- 可能未严格遵循"文档权威性"原则

**解决方案：**
1. 检查 `pu-xxx-change.impl.md` 是否完整准确
2. 重新执行 `coding ${pu_id}`，确保 100% 遵循文档
3. 使用 read_lints 验证代码质量

### 问题：找不到现有 PU 的实现

**原因：**
- 可能未正确执行"新建 vs 升级"决策

**解决方案：**
1. 检查 `specs/uc-xxx/pu-xxx/pu-xxx.json` 是否存在
2. 使用 file_grep 搜索方法名
3. 明确向用户声明判断结果

---

## 版本信息

- **当前版本**: 2.6.0
- **最后更新**: 2025-12-15
- **状态**: Draft

---

## 支持

如有问题或建议，请参考 [constitution.md](reference/constitution.md) 获取完整的执行规范和故障排除指南。

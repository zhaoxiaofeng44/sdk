
PuSpec 提供 5 个核心指令来管理 PU 的完整生命周期：

```bash
# 1. 项目初始化
init

# 2. 生成实现文档
impl ${pu_id}

# 3. 生成实现代码
coding ${pu_id}

# 4. 生成单元测试
ut ${pu_id}

# 5. 归档变更
archive ${pu_id}
```

## 工作流程示例

### 场景 1：项目初始化

```bash
# 在项目根目录执行
init

# 自动创建 puspec/ 目录结构
# 生成 puspec/project.md
```

### 场景 2：新增 PU

```bash
# Step 1: 准备变更需求文档（至少提供以下文件之一）
# 创建 puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.json（PU定义）
# 创建 puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.detail.md（技术方案，可选但推荐）

# Step 2: 生成实现文档
impl pu-xxx

# Step 3: 审核实现文档（人工）
# 检查 puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.impl.md

# Step 4: 生成实现代码
coding pu-xxx

# Step 5: 生成单元测试
ut pu-xxx

# Step 6: 代码审核和部署（人工）

# Step 7: 归档变更
archive pu-xxx
```

### 场景 3：升级现有 PU

```bash
# Step 1: 准备变更需求文档（至少提供以下文件之一）
# 创建 puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.json（PU定义）
# 创建 puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.detail.md（技术方案，可选但推荐）

# Step 2: 生成增量实现文档
impl pu-xxx
# 自动识别为升级场景，生成增量变更文档

# Step 3-7: 同场景 2
```

---
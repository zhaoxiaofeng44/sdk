#### 2. `impl ${pu_id}` - 生成实现文档

**触发时机**：需要新增或修改 PU 时

**执行流程**：

**Step 1：PU 边界判断**（仅当存在 detail.md 时执行）

> 📌 判断 detail.md 是否围绕同一处理单元（ProcessUnit, PU），若包含多个独立 PU 则需拆分

🔴 **判断规则**：
```
读取 detail.md 后，按以下规则判断是否需要拆分：

【可合并为单个 PU 的情况】：
├─ 同一领域实体的 CRUD 操作（如：订单的增删改查）
├─ 同一业务流程的多个步骤（如：下单→支付→发货）
└─ 存在强数据依赖或事务依赖的多个接口

【需拆分为多个 PU 的情况】：
├─ 两个功能无实现耦合，是独立隔离的执行链路
├─ 属于不同领域/聚合根的操作
└─ 可独立部署、独立测试的功能模块

判断结果：
├─ 单一 PU → 继续执行 Step 2
└─ 多个 PU → 执行拆分流程
```

**拆分流程**（如需）：
```
1. 识别 PU 边界：
   - 列出 detail.md 中的所有功能点
   - 按领域归属、事务边界、依赖关系分组
   
2. 生成拆分建议：
   - 为每个 PU 命名（kebab-case 格式）
   - 说明拆分理由
   - 列出每个 PU 包含的功能点
   
3. 等待用户确认：
   - 向用户展示拆分方案
   - 用户确认后，为每个 PU 分别执行后续流程
```

---

**Step 2：目录初始化**

> 📌 当用户未指定目录时，AI 根据详设内容理解，自动生成合理的 UC 和 PU 名称

🔴 **目录检查与创建**：
```
1. 解析或生成 UC/PU 名称：
   ├─ 用户已指定格式（uc-xxx/pu-xxx）→ 直接使用
   └─ 用户未指定 → AI 根据 detail.md 内容自动命名：
      
      【UC 命名规则】（用例/场景维度）：
      - 从详设中提取业务场景关键词
      - 格式：uc-{业务场景}（多词用下划线分隔）
      - 示例：uc-order_management、uc-user_auth
      
      【PU 命名规则】（处理单元维度）：
      - 从详设中提取核心功能关键词
      - 格式：pu-{核心功能}（多词用下划线分隔）
      - 示例：pu-create_order、pu-batch_import
      
      【命名示例】：
      - 订单创建功能 → uc-order/pu-create_order
      - 用户批量导入 → uc-user/pu-batch_import
      - 商品库存扣减 → uc-inventory/pu-stock_deduction
   
2. 检查目录是否存在：
   目标路径：{项目根目录}/puspec/changes/uc-xxx/pu-xxx/
   
3. 目录不存在时自动创建：
   ├─ 创建 UC 目录：{项目根目录}/puspec/changes/uc-xxx/
   └─ 创建 PU 目录：{项目根目录}/puspec/changes/uc-xxx/pu-xxx/
   
4. 向用户确认命名和目录结构：
   "根据详设内容，建议命名为：uc-xxx/pu-xxx
    已创建目录：puspec/changes/uc-xxx/pu-xxx/"
```

---

**Step 3：场景判断**
- 执行 B.4 "新建 vs 升级"决策树
- 明确向用户声明判断结果

**Step 4：文档读取与验证**

🔴 **前置检查**（MUST 执行）：
```
1. 检查关键文档存在性：
   - `{项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.detail.md` 是否存在？
   - `{项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.json` 是否存在？
   
2. 验证规则：
   ├─ 两个文件都不存在 → ❌ 中断任务，向用户报告：
   │  "错误：未找到有效参考信息。请至少提供以下文件之一：
   │   - {项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.detail.md（技术方案）
   │   - {项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.json（PU定义）"
   └─ 至少存在一个 → ✅ 继续执行

3. 🔴 扫描知识库目录（MUST 执行）：
   ├─ 检查 `{项目根目录}/puspec/knowledges/tech/` 目录
   │  └─ 如存在任何 .md 文件 → 必须读取并提取技术规范
   ├─ 检查 `{项目根目录}/puspec/knowledges/biz/` 目录
   │  └─ 如存在任何 .md 文件 → 必须读取并提取业务规范
   └─ 将提取的规范写入实现文档的 "7️⃣ 实现约束" 章节

4. 🔴 读取项目编码规范（MUST 执行）：
   └─ 检查 environment 中的 project_rules 是否存在
      └─ 如存在 → 必须读取并严格遵循其中的编码规范
```

**文档读取优先级**：
1. 🔴 **优先读取** `{项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.detail.md`（如存在）
   - 最高权威：100% 遵循其技术方案、代码细节、选型决策
   - 禁止对其进行"优化"或遗漏任何细节
   - 如仅有此文件：从中提取业务目标、输入输出、业务规则等关键信息
2. 读取 `{项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.json`（如存在）+ `pu.sodd.md`（Skill 目录）
   - 如仅有此文件：作为PU的SODD设计，结合`pu.sodd.md`进行需求分析
   - 如与 detail.md 共存：作为补充参考
3. 🔴 **必须读取** `{项目根目录}/puspec/knowledges/tech/*.md`（如存在）
   - 提取技术规范、CRUD最佳实践、框架使用规范等
   - 写入实现文档的 "7️⃣ 实现约束 - 技术规范" 章节
4. 🔴 **必须读取** `{项目根目录}/puspec/knowledges/biz/*.md`（如存在）
   - 提取业务规则、领域知识、业务约束等
   - 写入实现文档的 "7️⃣ 实现约束 - 业务规范" 章节
5. 🔴 **必须读取** `environment 中的 project_rules`（如存在）
   - 提取编码规范、技术指导等
   - 写入实现文档的 "7️⃣ 实现约束 - 技术规范" 章节

**Step 5：代码验证与证据要求**（MUST 执行）

🔴 **核心规范**（保证文档准确性）：
1. **Sub agent 调研结合 read_file与codebase_search**：必须读取实际代码并引用证据
2. **区分工具类存在与被调用**：工具类存在 ≠ 被实际调用，需用 file_grep 追踪调用位置
3. **禁止推测**：所有结论必须基于实际代码，明确说明"存在"或"不存在"

**Step 6：执行对应流程**

【新建场景】：
```
1. 防幻觉验证：
   - 确认代码库中无相关实现
   
2. 提取需求信息：
   ├─ 优先从 {项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.detail.md 提取（如存在）：
   │  - 业务目标、技术方案、架构设计、实现细节
   ├─ 从 {项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.json 提取（如存在）：
   │  - 接口定义、输入输出、业务规则
   └─ 整合所有可用信息

3. 🔴 执行 B.2 **设计细节锁定规范**
   
4. 生成变更实现文档：
   - 遵循 impl.template.md 结构（Skill 目录）
   - 生成方法粒度伪代码（15-30 行）
   - 确保所有关键信息完整覆盖
```

【升级场景】：
```
0. 检查基线文档：
   - 若 {项目根目录}/puspec/specs/uc-xxx/pu-xxx/pu-xxx.impl.md 不存在
     → 先基于实际代码生成基线文档
   - 已存在 → 进入增量更新模式
   
1. 提取变更需求：
   ├─ 优先从 {项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.detail.md 提取（如存在）：
   │  - 变更目标、技术方案、实现细节
   ├─ 从 {项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.json 提取（如存在）：
   │  - 接口变更、参数调整、规则变更
   └─ 整合所有可用信息

2. 🔴 执行 B.2 **设计细节锁定规范**（聚焦变更部分）
   
3. 增量更新模式：
   - 读取现有基线文档和变更需求
   - 识别变更范围（架构/流程/数据结构/组件）
   - 对比差异，生成差异清单
   - 针对性验证变更部分（使用 read_file）
   
4. 生成变更文档：
   - 聚焦变更点，避免全量描述
   - 只描述真正的变更（新增/修改功能）
   - 不包含代码优化等非功能性改动
```

**文档内容要求**：
- 必须章节：变更概览、架构设计、核心逻辑、数据结构、测试方案、风险评估
- ❌ 禁止质疑现有实现、禁止提供多个备选方案
- 🔴 执行**B.2 核心执行原则**校验

**质量检查点**：
- ✅ AI 自检：业务目标清晰、输入输出完整、业务规则穷尽、场景覆盖全面
- ✅ 报告检查结果（功能完整度 100%、架构一致性 100%）
- ✅ 等待用户多轮校准反馈

**输出**：
- 新建：变更实现文档：`{项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.impl.md`
- 升级：基线实现文档：`{项目根目录}/puspec/specs/uc-xxx/pu-xxx/pu-xxx.impl.md` + 变更实现文档：`{项目根目录}/puspec/changes/uc-xxx/pu-xxx/pu-xxx-change.impl.md`

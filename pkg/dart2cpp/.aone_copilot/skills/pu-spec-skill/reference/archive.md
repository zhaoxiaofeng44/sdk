#### 5. `archive ${pu_id}` - 归档变更

**触发时机**：代码部署完成并验证通过后

**执行流程**：

**Step 1：归档文件**
- 移动 `{项目根目录}/puspec/changes/uc-xxx/pu-xxx/` → `{项目根目录}/puspec/changes/archive/uc-xxx/YYYY-MM-DD-pu-xxx/`
- 复制 `pu-xxx-change.json` → `{项目根目录}/puspec/specs/uc-xxx/pu-xxx/pu-xxx.json`

**Step 2：更新基线文档**

🔴 **核心差异**：基线文档必须基于当前代码真实状态生成，禁止参考变更文档

【增量更新模式】（基线文档已存在）：
```
1. 定位实际代码实现
2. 深度分析当前代码（B.5 深度追踪策略）
3. 对比基线文档与当前代码，识别差异
4. 增量更新基线文档（标记 [Updated YYYY-MM-DD]）
```

【全新生成模式】（基线文档不存在）：
```
1. 定位实际代码实现
2. 深度分析代码（B.5 深度追踪策略）
3. 生成基线文档（遵循 impl.template.md 结构）
```

**归档前验证**：
1. ✅ 验证代码与 impl.md 一致性（功能完整度100%）
2. ✅ 检查测试覆盖率达标（≥80%）
3. ❌ 发现不一致 → 更新基线 impl.md 而非修改代码

**输出**：
- `{项目根目录}/puspec/changes/archive/uc-xxx/YYYY-MM-DD-pu-xxx/`
- `{项目根目录}/puspec/specs/uc-xxx/pu-xxx/pu-xxx.json`
- `{项目根目录}/puspec/specs/uc-xxx/pu-xxx/pu-xxx.impl.md`

🔴 执行**B.2 核心执行原则**校验（增量更新策略、防幻觉约束）

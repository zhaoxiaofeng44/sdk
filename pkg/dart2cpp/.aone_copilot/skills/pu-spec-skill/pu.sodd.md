# PU 系统概要设计规范

## 概述

PU（Processing Unit）系统概要设计是一种结构化的系统建模方法，用于描述系统的处理逻辑、数据流向和业务规则。本规范主要用于：

1. **AI 代码生成**：辅助 AI 通过代码逆向生成 pu.json 文件
2. **系统设计理解**：帮助 AI 理解 pu.json 结构，生成高质量代码和技术方案

## 核心元素

### 1. 处理单元（PU）
- **定义**：系统中可独立运行的程序单元，由 Actor 驱动执行
- **特征**：PU 之间相互独立，每个 PU 对应用户的一个不间断动作
- **命名**：建议使用动词命名，体现处理逻辑

### 2. 参与者（Actor）
- **定义**：与系统交互的外部实体（人、系统、设备等）
- **类型**：
  - `<实施>`：负责实施的人员
  - `<业务>`：业务操作人员
  - `<产品>`：产品设计人员
  - `<技术>`：技术配置人员
  - `<供应商>`：外部供应商
  - `<外部系统>`：外部系统
  - `<ODPS_TASK>`：ODPS任务
  - `<数灵方舟_TASK>`：数灵方舟任务
  - `<DTS>`：数据传输服务
  - `<Notify>`：通知服务
  - `<MetaQ>`：消息队列
  - `<Thread>`：应用线程
  - `<IDB>`：数据库

### 3. 输入输出对象
- **输入对象**：PU 运行时的前置数据
  - **Actor型输入**：PU 启动时的外部输入（运行后消亡）
  - **非Actor型输入**：PU 调用前已存在的数据（存储型）
- **输出对象**：PU 处理后产生的数据
  - **Actor型输出**：面向 Actor 的后置输出（运行后消亡）
  - **非Actor型输出**：PU 处理过程中产生的持久化数据

### 4. 对象构建类型
- `CDDC`：关系数据库
- `ADB`：分析数据库
- `ODPS`：大数据平台表
- `TAIR`：缓存存储
- `HOLO`：实时数仓
- `DIAMOND`：配置中心
- `SWITCH`：开关配置
- `HSF`：服务调用
- `HTTP`：HTTP接口
- `NOTIFY/METAQ`：消息通知

## 对象定义规范

### 对象ID命名规则
- **Actor型输入对象**：`UI_1`, `UI_2`, `UI_3`, ...（User Input）
- **非Actor型输入对象**：`I_1`, `I_2`, `I_3`, ...（Input）
- **Actor型输出对象**：`UO_1`, `UO_2`, `UO_3`, ...（User Output）
- **非Actor型输出对象**：`O_1`, `O_2`, `O_3`, ...（Output）

### 对象命名规则
- **对象ID**：`${对象ID}#${构建类型}[#List]`
- **字段定义**：`${字段key}:${字段类型}:${字段值约束}`
- **主键标识**：字段key后加 `#主`
- **索引标识**：字段key后加 `#索`

### 数据类型
- `int`：整型
- `long`：长整型
- `double`：双精度浮点型
- `float`：单精度浮点型
- `String[长度,格式]`：字符串
- `Date[格式]`：日期时间

### 值约束表达
- `*`：任意值
- `[值1,值2,...]`：枚举值
- `[a~b]`：范围值（闭区间）
- `(a~b]`：范围值（左开右闭）
- `${对象ID.字段}`：引用其他对象字段

## JSON Schema 详细规范

本章节详细说明 PU JSON 定义中使用的 JSON Schema 规范。JSON Schema 是一个强大的词汇表，用于验证、描述和注解 JSON 数据。

### 核心摘要：常用属性速查表

| 属性 (Property) | 适用类型 (Applicable To) | 说明 (Description) |
| --- | --- | --- |
| `type` | 所有 | 指定字段的数据类型，如 "string", "number", "object", "array", "boolean", "null" |
| `description` | 所有 | 对字段的详细文字描述 |
| `title` | 所有 | 字段的简短标题 |
| `default` | 所有 | 如果字段缺失，可以使用的默认值 |
| `enum` | 所有 | 枚举，列出字段所有可能的值 |
| `properties` | `object` | 定义对象中每个属性的 schema |
| `required` | `object` | 定义对象中必须存在的属性名列表 |
| `items` | `array` | 定义数组中所有元素的 schema |
| `pattern` | `string` | 定义一个正则表达式，字符串值必须匹配该模式 |
| `minimum` / `maximum` | `number` | 定义数字的最小值/最大值（包含边界） |

### 通用关键字

这些关键字适用于任何数据类型。

- **`type`**: 指定数据类型
  - 值可以是 `"string"`, `"number"`, `"integer"`, `"object"`, `"array"`, `"boolean"`, `"null"` 之一
  - 示例: `{"type": "string"}` 或 `{"type": ["string", "null"]}`

- **`description`**: 字段的详细描述
  - 值是一个字符串，用于文档生成或IDE提示
  - 示例: `{"description": "用户的唯一标识符"}`

- **`title`**: 字段的简短标题
  - 值是一个字符串，通常比 `description` 更短
  - 示例: `{"title": "用户ID"}`

- **`default`**: 字段的默认值
  - 这个关键字不用于验证，而是建议在数据缺失时可以使用的值
  - 示例: `{"default": "ACTIVE"}`

- **`enum`**: 枚举
  - 值是一个数组，字段的值必须是数组中的一个
  - 示例: `{"enum": ["ACTIVE", "FROZEN", "DELETED"]}`

- **`const`**: 常量
  - 字段的值必须严格等于 `const` 的值
  - 示例: `{"const": "CN"}`

### 字符串类型 (String)

- **`minLength` / `maxLength`**: 字符串的最小/最大长度
  - 值是非负整数
  - 示例: `{"minLength": 1, "maxLength": 50}`

- **`pattern`**: 正则表达式
  - 字符串值必须匹配给定的正则表达式
  - 示例: `{"pattern": "^[0-9]{3}-[0-9]{8}$"}`（验证电话号码）

- **`format`**: 格式
  - 指定常见的字符串格式，如日期、时间、URI等
  - 常见值: `"date-time"`, `"date"`, `"time"`, `"email"`, `"ipv4"`, `"ipv6"`, `"uri"`
  - 示例: `{"format": "email"}`

### 数字类型 (Number / Integer)

- **`minimum` / `maximum`**: 最小值/最大值（包含）
  - 值是数字
  - 示例: `{"minimum": 0, "maximum": 100}`（值在 [0, 100] 区间）

- **`exclusiveMinimum` / `exclusiveMaximum`**: 排除性最小值/最大值（不包含）
  - 值是数字
  - 示例: `{"exclusiveMinimum": 0, "exclusiveMaximum": 100}`（值在 (0, 100) 区间）

- **`multipleOf`**: 倍数
  - 值必须是 `multipleOf` 值的倍数
  - 示例: `{"multipleOf": 0.01}`（表示数字最多有两位小数）

### 对象类型 (Object)

- **`properties`**: 对象的属性
  - 值是一个对象，键是属性名，值是该属性的 schema
  - 示例: `{"properties": {"name": {"type": "string"}, "age": {"type": "integer"}}}`

- **`required`**: 必需属性
  - 值是一个字符串数组，列出必须存在的属性名
  - 示例: `{"required": ["name", "age"]}`

- **`additionalProperties`**: 额外属性
  - 用于控制 `properties` 中未定义的属性
  - 可以是 `false`（禁止任何额外属性），或一个 schema（额外属性必须符合此 schema）
  - 示例: `{"additionalProperties": false}`

- **`minProperties` / `maxProperties`**: 对象的最小/最大属性数量
  - 值是非负整数
  - 示例: `{"minProperties": 1}`

### 数组类型 (Array)

- **`items`**: 数组元素
  - 列表验证：值是一个 schema，数组中的所有元素都必须符合该 schema
  - 示例: `{"items": {"type": "string"}}`

- **`minItems` / `maxItems`**: 数组的最小/最大长度
  - 值是非负整数
  - 示例: `{"minItems": 1, "maxItems": 10}`

- **`uniqueItems`**: 唯一性
  - 如果为 `true`，数组中的所有元素必须是唯一的
  - 示例: `{"uniqueItems": true}`

### 自定义扩展属性

PU JSON Schema 支持以下自定义扩展属性：

- **`isPrimary`**: 标识主键字段
  - 类型: `boolean`
  - 示例: `{"isPrimary": true}`

- **`isIndex`**: 标识索引字段
  - 类型: `boolean`
  - 示例: `{"isIndex": true}`

这些自定义属性用于表达数据库相关的元数据，增强 PU 定义的表达能力。

## 条件与逻辑

### 条件类型
1. **输入条件**：描述输入对象在PU运行时是否存在
2. **输出条件**：描述输出对象在什么条件下产生

### 逻辑运算符
- `&&` 或 `and`：逻辑与
- `||` 或 `or`：逻辑或
- `!` 或 `not`：逻辑非
- `()`：逻辑分组

### 条件表达式示例
```
(${var1} && ${var2}) || (!${var3})
(${输入对象1.字段1} == "值") && isNotNull(${输入对象2.字段2})
```

## 核心函数库

### 业务函数
- `session_tenant()`：当前登录租户
- `session_user()`：当前登录用户ID
- `session_role(role1,role2,...,all_required)`：用户角色检查
- `session_priv(priv1,priv2,...,all_required)`：用户权限检查
- `accounting_date(var)`：账期日函数

### 条件函数
- `if(condition, true_value, false_value)`：条件取值
- `ifs(cond1,val1, cond2,val2, ..., default)`：多条件取值
- `switch(value, key1,val1, key2,val2, ..., default)`：值映射
- `nvl(param1, param2, ...)`：取第一个非null值

### 类型转换
- `cast(value as type)`：类型转换
- `to_char(value, format)`：转字符串
- `to_date(value, format)`：转日期

### 数值计算
- `round(value, pos)`：四舍五入
- `max(param1, param2, ...)`：最大值
- `min(param1, param2, ...)`：最小值
- `abs(param)`：绝对值

### 字符串处理
- `length(param)`：长度
- `concat(var1, var2, ...)`：字符串连接
- `replace(str, old, new)`：字符串替换
- `upper(str)`：转大写
- `lower(str)`：转小写
- `trim(str)`：去空格

### 日期时间
- `current_date()`：当前日期
- `current_timestamp()`：当前时间戳
- `date_diff(date1, date2, unit)`：日期差值
- `date_add(date, unit, value)`：日期加减

### 判断函数
- `isNull(param1, param2, ...)`：判断是否为null
- `isEmpty(param1, param2, ...)`：判断是否为空
- `isNotNull(param1, param2, ...)`：判断是否不为null
- `isNotEmpty(param1, param2, ...)`：判断是否不为空
- `equals(param1, param2)`：相等判断

### 聚合函数
- `sum(field)`：求和
- `count(field)`：计数
- `count_distinct(field)`：去重计数
- `distinct(field)`：去重

## AI 生成指导

### 从代码生成 PU.json

#### 生成原则
**核心约束**：生成的 PU.json 必须严格遵守核心元素定义，任何违背核心元素定义的生成都是错误的。

#### 生成步骤

**步骤1：识别处理单元（PU）**
- 分析方法/函数作为候选 PU
- **约束检查**：
  - ✅ 必须是可独立运行的程序单元
  - ✅ 必须对应用户的一个不间断动作
  - ✅ PU 之间必须相互独立
  - ❌ 禁止将内部辅助方法识别为 PU
  - ❌ 禁止将多个用户动作合并为一个 PU

**步骤2：确定参与者（Actor）**
- 根据调用方式确定参与者类型
- **约束检查**：
  - ✅ 必须从预定义的 Actor 类型中选择
  - ✅ Actor 必须是驱动 PU 执行的外部实体
  - ❌ 禁止使用未定义的 Actor 类型
  - ❌ 禁止将内部组件标识为 Actor
- **Actor 类型映射**：
  - HTTP/REST 接口 → `<产品>#HTTP接口#[GET/POST/PUT/DELETE]#[content-type]`
  - 定时任务 → `<ODPS_TASK>#任务ID` 或 `<数灵方舟_TASK>#任务ID`
  - 消息队列 → `<MetaQ>#topic_name#message_type`
  - 数据同步 → `<DTS>#同步任务名`
  - 应用线程 → `<Thread>#线程名`
  - 数据库触发器 → `<IDB>#触发器名`

**步骤3：提取输入对象**
- 分析方法参数和依赖数据
- **约束检查**：
  - ✅ 必须区分 Actor 型输入和非 Actor 型输入
  - ✅ Actor 型输入：PU 启动时的外部输入（运行后消亡）
  - ✅ 非 Actor 型输入：PU 调用前已存在的数据（存储型）
  - ❌ 禁止混淆输入对象的类型属性
  - ❌ 禁止遗漏必需的输入对象
- **输入对象识别规则**：
  - 方法参数 → Actor 型输入
  - 数据库查询 → 非 Actor 型输入
  - 缓存读取 → 非 Actor 型输入
  - 配置读取 → 非 Actor 型输入

**步骤4：识别输出对象**
- 分析返回值和副作用
- **约束检查**：
  - ✅ 必须区分 Actor 型输出和非 Actor 型输出
  - ✅ Actor 型输出：面向 Actor 的后置输出（运行后消亡）
  - ✅ 非 Actor 型输出：PU 处理过程中产生的持久化数据
  - ❌ 禁止混淆输出对象的类型属性
  - ❌ 禁止遗漏重要的输出对象
- **输出对象识别规则**：
  - 方法返回值 → Actor 型输出
  - 数据库写入 → 非 Actor 型输出
  - 缓存写入 → 非 Actor 型输出
  - 消息发送 → 非 Actor 型输出

**步骤5：确定对象构建类型**
- 为每个输入输出对象指定构建类型
- **约束检查**：
  - ✅ 必须从预定义的构建类型中选择
  - ✅ 构建类型必须与实际存储/传输方式匹配
  - ❌ 禁止使用未定义的构建类型
  - ❌ 禁止构建类型与实际不符
- **构建类型映射**：
  - MySQL/PostgreSQL → `CDDC`
  - AnalyticDB → `ADB`
  - MaxCompute → `ODPS`
  - Redis/Tair → `TAIR`
  - Hologres → `HOLO`
  - Diamond 配置 → `DIAMOND`
  - 开关配置 → `SWITCH`
  - HSF 服务 → `HSF`
  - HTTP 接口 → `HTTP`
  - 消息队列 → `NOTIFY` 或 `METAQ`

**步骤6：推导条件逻辑**
- 分析业务逻辑中的条件判断
- **约束检查**：
  - ✅ 输入条件：描述输入对象在 PU 运行时是否存在
  - ✅ 输出条件：描述输出对象在什么条件下产生
  - ❌ 禁止条件表达式过于复杂（超过3层嵌套）
  - ❌ 禁止使用未定义的逻辑运算符

**步骤7：映射函数公式**
- 将代码逻辑映射到标准函数
- **约束检查**：
  - ✅ 优先使用核心函数库中的标准函数
  - ✅ 函数参数类型必须匹配
  - ❌ 禁止使用未定义的函数
  - ❌ 禁止函数嵌套过深（超过5层）

#### 生成检查清单

生成完成后，必须进行以下检查：

- [ ] **PU 定义检查**
  - [ ] PU 是否可独立运行
  - [ ] PU 是否对应一个完整的用户动作
  - [ ] PU 之间是否相互独立

- [ ] **Actor 检查**
  - [ ] Actor 类型是否在预定义列表中
  - [ ] Actor 是否是驱动 PU 的外部实体
  - [ ] Actor 格式是否符合规范

- [ ] **输入对象检查**
  - [ ] 是否正确区分 Actor 型和非 Actor 型
  - [ ] 输入对象的构建类型是否正确
  - [ ] 字段定义是否完整（名称、类型、约束）
  - [ ] 是否标识了主键和索引

- [ ] **输出对象检查**
  - [ ] 是否正确区分 Actor 型和非 Actor 型
  - [ ] 输出对象的构建类型是否正确
  - [ ] 字段公式是否使用标准函数
  - [ ] 是否处理了所有副作用

- [ ] **条件逻辑检查**
  - [ ] 条件表达式是否简洁清晰
  - [ ] 逻辑运算符使用是否正确
  - [ ] 是否避免了过度嵌套

- [ ] **函数使用检查**
  - [ ] 是否优先使用标准函数库
  - [ ] 函数参数类型是否匹配
  - [ ] 函数嵌套是否合理

### 防止幻觉指南

#### 核心原则：零容忍幻觉

**幻觉 = 致命错误**：基于推测生成代码中不存在的输入输出对象、数据库操作、服务调用等。

**四大原则**：
1. ✅ **证据驱动**：每个元素必须有代码证据，禁止推测
2. ✅ **完整追踪**：从入口到出口，不留盲区
3. ✅ **多次验证**：代码搜索 + 调用链追踪 + 数据流分析
4. ✅ **保守生成**：不确定的不生成，宁缺毋滥

#### 常见幻觉类型与防范

| 幻觉类型 | 典型错误 | 验证方法 |
|---------|---------|---------|
| **输出对象幻觉** | 假设有TAIR缓存写入、NOTIFY消息发送 | 搜索 `save/insert/update/delete/put/set/send/publish`，追踪调用链 |
| **输入对象幻觉** | 假设有Diamond配置读取 | 追踪 `@Autowired/@Resource`，验证配置确实被使用 |
| **构建类型幻觉** | CDDC误认为TAIR | 追溯到底层存储操作（SQL/Redis命令），检查配置文件 |
| **字段幻觉** | 添加代码中不存在的字段 | 逐字段验证赋值语句，检查对象构造/Builder/Setter |
| **条件幻觉** | 臆测不存在的业务规则 | 追踪所有 `if/switch/三元运算符` |

#### 验证流程（5步法）

```
1. 代码扫描：记录方法参数、依赖注入、返回值、所有读写操作
2. 验证输入：找到读取代码行 → 确认数据源类型 → 确认字段列表
3. 验证输出：找到写入代码行 → 确认存储类型 → 确认字段来源
4. 交叉检查：Actor型输入是否都被使用、非Actor型输入输出是否有明确代码
5. 标记不确定：添加 # TODO 注释，主动询问用户
```

#### 实战案例

**❌ 错误（含4个幻觉）**：
```json
{
  "outputs": [
    {
      "code": "O_1",
      "name": "缓存写入1",
      "description": "幻觉：假设有TAIR缓存",
      "storage": {"type": "tair"}
    },
    {
      "code": "O_2",
      "name": "缓存写入2",
      "description": "幻觉：假设有TAIR缓存",
      "storage": {"type": "tair"}
    },
    {
      "code": "O_3",
      "name": "消息发送1",
      "description": "幻觉：假设有NOTIFY消息",
      "storage": {"type": "notify"}
    },
    {
      "code": "O_4",
      "name": "消息发送2",
      "description": "幻觉：假设有NOTIFY消息",
      "storage": {"type": "notify"}
    },
    {
      "code": "O_5",
      "name": "数据库写入",
      "description": "真实：数据库写入",
      "storage": {"type": "cddc"}
    }
  ]
}
```

**✅ 正确（消除幻觉）**：
```json
{
  "actorOutputs": [
    {
      "code": "UO_1",
      "name": "HSF返回值",
      "description": "Actor型输出：HSF返回值",
      "storage": {"type": "hsf_result"}
    }
  ],
  "outputs": [
    {
      "code": "O_1",
      "name": "数据库写入",
      "description": "非Actor型输出：唯一的数据库写入，验证依据：abilityExecuteInstanceCallbackService.updateInfo()",
      "storage": {
        "type": "cddc",
        "database": "ability_execute_instance",
        "table": "ability_execute_instance_info",
        "operation": "UPDATE"
      }
    }
  ]
}
```

**验证依据**：
- ✅ 搜索 `tairManager.put()`、`cache.set()` → 未找到
- ✅ 搜索 `notifyService.send()`、`publisher.publish()` → 未找到
- ✅ `streamCallBack` 只是返回给调用方，非持久化输出
- ✅ 唯一持久化：`abilityExecuteInstanceCallbackService.updateInfo()`

#### 检查清单

- [ ] 每个非Actor型输入/输出都有明确的代码位置
- [ ] 构建类型与实际存储一致（CDDC/TAIR/DIAMOND等）
- [ ] 所有字段都有对应的赋值/读取代码
- [ ] 条件表达式与实际分支一致
- [ ] 区分了临时变量和持久化输出
- [ ] 没有基于"常识"/"经验"/"推测"添加元素

**记住**：宁可生成不完整但正确的 PU.json，也不要生成完整但包含幻觉的 PU.json

### 从 PU.json 生成代码

关于从 PU.json 生成实现文档和代码的完整流程，请参考 `constitution.md` 的以下章节：

- **B.2.2 `pu-xxx-change-impl`** - 生成实现文档的完整流程和验收标准
- **B.2.3 `pu-xxx-change-coding`** - 生成可执行代码的执行标准和验收标准
- **B.3 新建 vs 升级决策树** - 判断是新建 PU 还是升级现有 PU 的决策流程
- **B.4 深度嵌套细节追踪分析** - 确保实现文档包含足够细节的分析策略
- **D.1 高可信度代码生成的验证标准** - 代码质量验证的详细清单

**核心原则**：
1. ✅ 必须先生成实现文档，后生成代码
2. ✅ 必须等待用户确认实现文档后才能生成代码
3. ✅ 实现文档必须遵循 `impl.template.md` 的结构
4. ✅ 代码必须 100% 遵循 `project.md` 的编码规范
5. ❌ 严禁跳过实现文档直接生成代码
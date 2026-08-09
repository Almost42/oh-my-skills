# Oh My Skills

Oh My Skills（OMS）是一套面向 AI 编程协作的仓库内治理框架。

它不是零散提示词集合，而是一整套可分发的 skills、模板资产和工作流规则，用来约束 agent 如何澄清需求、产出设计、确认方案、执行代码、验证结果、处理回退，以及沉淀长期知识。

> README 是 OMS 当前版本的最新说明书；技能与模板的实际行为以本仓库内容为准。


## 它能带来什么

OMS 解决的是 AI 参与开发时最常见的几类失控问题：

- agent 接到需求就开始写代码，跳过澄清与设计。
- 项目状态散落在聊天记录里，下一次对话无法稳定恢复。
- 代码变了，文档没变，负责人很难判断当前真实进度。
- 用户中途改口或发现前置设计错误时，流程没有正式回退机制。
- agent 在没有新鲜证据的情况下声称完成，或在环境问题面前反复重试而不停下来问。

对应地，OMS 提供这些核心能力：

- **节点化工作流**：把需求、设计、实施、验证拆成明确阶段，每个阶段有进入门禁。
- **文档化状态管理**：spec 状态锚点持有真实节点，`docs/ai/progress.md` 只做摘要。
- **设计与实施分离**：只有进入 `ReadyForImplementation` 后才允许实施代码。
- **显式修复机制**：当设计或实现不闭环时，走 `workflow_repair`，而不是偷偷改状态。
- **精准上下文注入**：每个 skill 只加载当前步骤必需的文档；多开发者场景只在继续目标不明或改动范围交叉时确认活跃 spec。
- **AI 行为约束**：每个 skill 内置 Iron Law、Never 规则和 Red Flags，防止 agent 假设替代澄清、顺手修改范围外代码、声称完成但没有证据。
- **可分发运行时**：模板资产跟随 skill 一起分发，不依赖仓库中的统一模板目录。
- **历史 spec 可回溯**：spec 文件或目录名包含创建日期，`docs/ai/spec/index.md` 按模块与处理方向索引历史需求。

## 核心工作流

OMS 使用这几个 canonical nodes：

| Node | 含义 | 可写代码 |
| :--- | :--- | :--- |
| `RequirementDraft` | 需求仍在澄清 | No |
| `DesignDraft` | 方案仍在设计 | No |
| `ReadyForImplementation` | 设计与 execution package 已获批 | No |
| `Implementing` | 已批准工作正在实施 | Yes |
| `Verifying` | 正在验证结果与回归 | No |
| `Archived` | 工作已完成并归档 | No |

主流程如下：

```text
project_init                # 项目初始化扫描
  -> context_sync           # 上下文同步
  -> requirement_probe      # 需求澄清
  -> feature_plan           # 设计草案
  -> feature_confirm        # 方案确认（review / lock）
  -> code_implement_confirm # 代码实施
  -> verification_gate      # 验证门禁（验收通过后自动归档，流程闭环）
```

关键约束：

- `feature_confirm (review / lock)` 是设计确认与实施包锁定入口。
- 只有用户明确批准后，spec 才能进入 `ReadyForImplementation`。
- `code_implement_confirm` 只执行已批准方案，不负责补做设计。
- 发现设计缺口、节点错位或验证反证时，必须进入 `workflow_repair`。

## Spec 双模式

spec 文件根据 `Scope` 自动选择存储方式：

| Scope | 文件结构 | 说明 |
| :--- | :--- | :--- |
| `Patch` | `docs/ai/spec/YYYY-MM-DD-{slug}.md`（单文件） | 局部修复，内容完整写入一个文件 |
| `Feature` | `docs/ai/spec/YYYY-MM-DD-{slug}/`（子目录） | 新能力开发，内容按阶段拆分 |

命名规则：

- 日期为 spec 创建日期，精确到日，后续更新不改文件名或目录名。
- `slug` 保持短小稳定，用来表达需求主题。
- `docs/ai/spec/index.md` 是根索引，只记录 spec 路径、日期、范围、当前节点、关注模块、处理方向和最近更新；节点真相仍在各 spec 状态锚点。
- OMS 文档正文默认使用中文；路径、代码标识符、API 名称、frontmatter 枚举值和既有英文术语可保留英文。

Feature 类 spec 的子目录结构：

```text
docs/ai/spec/YYYY-MM-DD-{slug}/
├── index.md     ← 状态锚点，持有所有 frontmatter，节点变更只写这里
├── req.md       ← 需求理解、范围、验收标准、待确认问题（requirement_probe 阶段持续更新）
├── design.md    ← 技术方案与影响分析（feature_plan 阶段写入）
└── impl.md      ← 执行包、回滚计划、测试计划（feature_confirm lock 后写入）
```

每个 skill 只读取当前阶段需要的子文档，`workflow_guard` 只需读 `index.md`，不加载完整 spec 内容。

## 精准上下文注入

OMS 将上下文视为有限资源，通过以下机制减少不必要加载：

**Spec 按需定位**：新对话开始时，先读 `docs/ai/progress.md` 定位活跃 spec，而不是全量扫描 `docs/ai/spec/`。

**诊断不入流程**：当用户只想分析逻辑、排查日志或确认漏洞是否存在时，直接围绕相关证据开展分析；不读取工作流状态、不创建 spec、也不推进节点。只有确认需要代码变更且用户明确要继续时，才转入 `requirement_probe`。

**需求先落文档**：`requirement_probe` 创建或更新需求文档，把当前理解与未确认问题一起落盘；后续重复进入时持续维护，直到问题清空再进入 `feature_plan`。

**项目背景校准**：需求阶段先读 `docs/ai/context/project_brief.md`（若存在），用项目目的、范围、成功标准和术语表校准需求判断。

**多开发者场景**：多个活跃 spec 不会自动阻塞新补丁。只有用户只说“继续”而目标不明，或本次改动与活跃 spec 在模块、接口、数据契约、验收目标或改动文件上实质交叉时，agent 才要求确认：

```
当前项目有多个进行中的工作项，请确认本次对话要处理哪个：
1. 2026-04-20-create-task — 实施中 — 新增创建任务接口
2. 2026-04-18-offerwall-refactor — 方案设计 — 广告墙重构方案
请指定编号或名称。
```

**architecture.md 加载**：`docs/ai/architecture.md` 若存在，则 `feature_plan` / `feature_confirm` 均必读（Patch 优先关注与范围、构建/测试/工具链相关的节）；`code_implement_confirm` 与 `verification_gate` 在跑构建/测试前**强制**阅读，与 `AGENTS.md` 中的 baseline 与工具约定对齐。`workflow_guard` 入口仍可不调 architecture，以免意图识别过荷。

**Lessons 精准注入**：Lessons 按操作类型分类存储，各 skill 只加载当前阶段对应的分类文件。

## AI 行为约束体系

每个核心 skill 内置三层约束，防止 agent 常见的失控行为：

| 约束层 | 作用 |
| :--- | :--- |
| **Iron Law** | 不可违反的核心规则，以代码块形式突出显示 |
| **Never 列表** | 明确禁止的操作，每条都有具体场景 |
| **Red Flags - STOP** | 触发后必须立即停止的警报信号 |

各 skill 对应的核心约束：

- `workflow_guard`：纯诊断不入 spec；并行补丁只在范围交叉时做冲突确认
- `requirement_probe`：先落 `req.md`，显式维护待确认问题，不假设，不替用户填补验收标准
- `feature_plan`：YAGNI，最小可行方案，不加未被要求的抽象
- `feature_confirm`：Simplicity Gate，execution package 不得超出需求范围
- `code_implement_confirm`：只改 execution package 列出的文件；执行前检查工具可用性；相同错误连续 2 次必须停下来报告
- `verification_gate`：没有新鲜运行证据，不能声称完成

## 知识与经验沉淀

OMS v3.1 采用 owner-first 的精简知识体系：

- `AGENTS.md`：治理边界、加载策略、触发路由
- `docs/ai/context/project_brief.md`：项目目的、范围、成功标准、术语等稳定背景
- `docs/ai/architecture.md`：结构、模块边界、工具链与环境约定
- `docs/ai/domain_rules.md`：项目级硬约束、禁区、协议规则
- capability docs：能力专属稳定事实与操作约束，仅在能力成体系时创建
- `docs/ai/knowledge/index.md`：路由器，只决定“该读哪些 owner 文件”
- `docs/ai/knowledge/lessons/*`：按类型保存经验条目、证据和固化状态
- `docs/ai/history/*`：初始化、发布、治理审计等事件摘要，不复制需求归档

**Lessons 分类体系**：Lessons 是唯一的经验缓冲层；条目在原文件内记录状态，固化后只保留来源和验证记录：

```text
docs/ai/knowledge/lessons/
├── design.md    ← 需求/设计阶段的判断错误
├── code.md      ← 实现阶段的操作失误与禁止行为
├── testing.md   ← 验证/测试相关的遗漏
├── workflow.md  ← 节点推进与流程相关
└── domain.md    ← 业务规则与领域特定约束
```

对话中的纠正、问题、验收结果和重复模式先进入对应的 `lessons` 条目。验收收口自动执行 `knowledge_review(auto)`：低风险、高置信度规则自动固化到正确 owner；中风险标记为“待继续验证”；高风险或冲突项标记为“冲突待处理”。用户不主动维护时，系统仍会持续积累和安全固化。

## 会生成哪些文档

执行 `project_init` 后，目标项目会得到最小治理骨架：

```text
AGENTS.md
docs/ai/
├── context/project_brief.md
├── architecture.md
├── domain_rules.md               # optional, 仅在项目级硬约束成体系时创建
├── spec/                          # index.md + Patch: YYYY-MM-DD-{slug}.md / Feature: YYYY-MM-DD-{slug}/index.md + 子文档
├── progress.md
├── knowledge/
│   ├── index.md                   # 知识路由与 lessons 加载规则
│   └── lessons/                   # 按操作类型分类的经验、证据与固化状态
├── history/                       # 初始化 / 发布 / 治理审计等事件摘要
└── memory/                        # optional, only when archive/resume is enabled
```

这些文档的职责：

- `AGENTS.md`：治理边界、加载策略、技能路由。
- `docs/ai/context/project_brief.md`：项目背景 owner；仅用于项目目的、范围、成功标准、术语等稳定背景。
- `docs/ai/spec/index.md`：历史需求根索引，用于按模块与处理方向回溯 spec。
- `docs/ai/spec/YYYY-MM-DD-*`：单个需求或补丁的协议，也是 workflow node 的 source of truth。
- `docs/ai/progress.md`：当前状态指针，summary-only，不承载节点真相。
- `docs/ai/architecture.md`：系统结构与边界；团队可补充构建/测试/环境约定；按各 skill 规则加载（设计/含 Patch 的确认阶段若存在则读，执行与验证前必读；与 `AGENTS.md` 一致时以 skill 中「跑命令前」规则为准）。
- `docs/ai/domain_rules.md`：项目级硬约束、禁区与协议规则；仅在相关任务确实依赖时加载。
- capability docs：能力专属的稳定事实与操作约束；不是必建全套。
- `docs/ai/knowledge/index.md`：owner 路由入口，含 lessons 加载规则。
- `docs/ai/knowledge/lessons/`：按操作类型分类的经验条目，精准注入，不全量加载；条目内保留证据、范围、状态和来源。
- `docs/ai/history/`：只记录初始化、发布、治理审计等事件摘要，不记录需求正文；spec 主档案始终保留在 `docs/ai/spec/`。
- `docs/ai/memory/`：可选快照层，只在 handoff 或历史重建需要时启用；`project_init` 默认不创建 `docs/ai/memory/`。

写入约束：

- `docs/ai/context/`：只允许 `project_init` 和 `project_docs_optimize` 写入或重组。
- `docs/ai/history/`：只允许 `project_init`、`project_docs_optimize` 和明确的发布/治理动作写入；普通需求归档不追加 per-demand history。
- owner 自动固化必须通过受管区块写入，并保留原 lessons 来源、证据和最近验证日期。

## 快速开始

如果你是第一次把 OMS 接入到自己的开发环境，按下面这条最短路径走即可。

### 1. 通过 skillshare 安装并同步 OMS
> 安装skillshare： https://github.com/runkids/skillshare

先把当前仓库作为 skill 源安装到本地，再执行同步：

```bash
skillshare install https://github.com/Almost42/oh-my-skills
skillshare sync
```

安装完成后，OMS 中的 skills、templates 和 references 会一起进入你的 skill 运行环境。

如果你还希望把项目里的常用流程沉淀成团队 skill，后续可使用独立的 `project_skill_extract`，它会把生成结果写入项目的 `docs/ai/skills/`。

### 2. 在目标项目执行 `project_init`

进入你要接入 OMS 的项目后，先执行：`project_init`

`project_init` 是可重复执行的扫描入口，它会：

- 盘点当前项目的 docs、spec、外部 AI 规则来源和 `docs/ai/skills/`
- 判断哪些结构符合当前 OMS 规范，哪些存在 drift
- 给出面向开发者的初始化结论：当前是否合规、是否可以继续工作、是否需要先确认结构调整
- 在需要时建议转到 `project_docs_optimize (analyze)` 输出调整报告

### 3. 恢复工作时执行 `context_sync`

项目接入完成后，用户明确要求恢复或继续既有工作时，优先从 `context_sync` 开始。新对话中的纯逻辑分析、漏洞排查或日志诊断直接处理相关证据，不加载工作流上下文。

它会读取最小 baseline 文档，自动定位当前活跃 spec，并在需要时提示你补做 `capability_bootstrap`、`progress_sync` 或 `session_resume`。

### 4. 按意图进入主工作流

日常开发时，通常沿着这条链路推进：

```text
requirement_probe           #描述需求
  -> feature_plan           #设计需求方案
  -> feature_confirm        #确认需求方案
  -> code_implement_confirm #确认实施方案
  -> verification_gate      #验证（验收通过后自动归档）
```

可选的操作：
- 会话暂存`session_archive`：当前工作做了一半需要暂停（适用于切换模型、IDE）
- 会话恢复`session_resume`：快速恢复手头正在执行的工作（适用于新开对话）
- 恢复/恢复上下文/继续`context_sync`：让AI加载当前项目的背景和规则（适用于主动向AI声明当前背景,或任务漂移时重置状态）
- 逻辑分析/漏洞排查/日志排障：直接收集相关证据并给出结论；确认需要改动后才进入 `requirement_probe`
- 整理文档`project_docs_optimize`：按照oms标准整理文档（适用于发现docs文件杂乱时）
- 将xxx提取为团队skill`project_skill_extract`：将指定规则提取成skill供团队复用（适用于较固定的规则应用场景）

### 5. 完整闭环

当一个 spec 的验收通过时，`verification_gate (advance)` 会自动完成：

- 运行 `lesson_capture`，提取本次纠正、决策、修正和重复模式；
- 运行 `knowledge_review(auto)`，自动固化安全经验或标记“待继续验证/冲突待处理”；
- 更新 `docs/ai/progress.md`，移除已完成 spec
- 更新 `docs/ai/spec/index.md`，标记为 `Archived`
- 普通需求不生成 `docs/ai/history/<feature>.md`；只有治理或发布事件才写 history

需求验收通过且知识收口有明确结果，即视为流程闭环完成。用户可以主动触发 `knowledge_review(manual)` 处理高风险或冲突经验，但不是日常积累的前置条件。

### 6. （可选）团队Skill加载
当`./docs/ai/skills`中存在团队技能时，需要按照如下步骤加载，确保开发者使用的ide/cli/agent能够读取到对应的skill。

```bash
# 1.确保在当前项目下执行
cd 项目路径
# 2.使用skillshare执行项目初始化，选择target（即本项目需要被哪些ide/cli/agent识别到）
skillshare init -p
# 3.同步skill（将团队skill加载到可别识别的路径中）
skillshare sync
```

## 使用示例

### 示例：服务端新增"创建任务"接口（Feature 类，多文件 spec）

```text
用户：项目初始化。
Agent：[project_init] 扫描项目文档、外部 AI 规则和 `docs/ai/skills/`，发现存在 owner 漂移与缺失 baseline。
       下一步建议：`project_docs_optimize (analyze)` 输出调整报告，确认后再执行迁移/补建。

用户：继续。
Agent：[context_sync] 读取 AGENTS.md + progress.md，当前无活跃 spec，进入正常开发链路。

用户：我要新增一个"创建任务"的接口，POST /api/tasks。
Agent：[requirement_probe] 创建 docs/ai/spec/2026-04-20-create-task/index.md + req.md + design.md + impl.md（空骨架），
       先把当前需求理解写入 req.md，并列出待确认的鉴权规则、入参校验、返回结构、错误码与验收标准。
       Scope 判断：Feature（涉及新接口和数据写入）→ 使用 multi-file spec。

用户：标题不能为空，截止时间不能早于当前时间，成功返回任务 id 和 createdAt。
Agent：[requirement_probe] 更新 req.md，移除已解决问题；若待确认问题清空，则进入方案设计阶段。

Agent：[feature_plan] 基于现有 req.md 产出 design.md，并更新 docs/ai/spec/index.md。
       YAGNI 自查通过：无未被要求的抽象。

用户：先输出实施方案，我要 review。
Agent：[feature_confirm review] 读取 design.md + req.md，输出 execution package，Simplicity Gate 通过。

用户：方案可以，开始做。
Agent：[feature_confirm lock] 将 Current_Node 推进到 ReadyForImplementation，execution package 写入 impl.md。

用户：开始实现。
Agent：[code_implement_confirm] Pre-flight 检查工具可用 → 按 impl.md 执行。

用户：增加规则：protocol 文件由自动化工具生成，禁止手动修改。
Agent：[lesson_capture] 分类为 domain → 写入 `lessons/domain.md` 的经验条目，记录来源、范围和证据。
       验收收口时 `knowledge_review(auto)` 检查证据和范围；低风险规则自动固化，其他经验标记为“待继续验证/冲突待处理”。

用户：需求验收通过。
Agent：[verification_gate] 运行测试并逐条核对验收标准 → 自动提取经验和收口知识 → 归档 spec、同步 progress/index；普通需求不生成 history 副本。
```

### 示例：多开发者并行场景

```text
用户：继续做。
Agent：[context_sync] 发现 progress.md 中有 2 个活跃 spec：

当前项目有多个进行中的工作项，请确认本次对话要处理哪个：
1. 2026-04-20-create-task — 实施中 — 新增创建任务接口
2. 2026-04-18-offerwall-refactor — 方案设计 — 广告墙重构方案

请指定编号或名称。

用户：1
Agent：加载 docs/ai/spec/2026-04-20-create-task/index.md，恢复上下文，继续实施阶段。
```


## 运行时分发模型

这个仓库是 skill 分发仓库，不是某个业务项目本身。
分发时须保留完整 skill 文件夹（含 `templates/` 和 `references/`），而不是只拷贝 `SKILL.md`。

## 与 v2 的主要差异

- `docs/ai/spec/` 现在支持双模式：Patch 用带日期单文件，Feature 用带日期子目录（index/req/design/impl），并通过 `docs/ai/spec/index.md` 汇总历史模块与处理方向。
- `docs/ai/lessons.md` 废弃，改为 `docs/ai/knowledge/lessons/` 分类体系，按操作类型精准注入。
- 长期知识通过 `lessons -> 自动收口 -> owner / 待继续验证 / 冲突待处理` 生命周期自动分流到 `docs/ai/domain_rules.md`、`docs/ai/architecture.md` 或 capability docs；用户审核作为高风险兜底。
- 每个 skill 内置 Iron Law、Never、Red Flags，AI 行为约束从"软提示"变为"硬规则"。
- `workflow_guard` 与 `context_sync` 按需定位；多个活跃 spec 仅在继续目标不明或改动范围交叉时暂停确认。
- `architecture.md`：v2 曾作为「仅 Feature/跨模块才读」的轻量策略；v3 现已改为在设计与确认阶段**若文件存在则读**（含 Patch、优先相关节），并在 `code_implement_confirm` / `verification_gate` 执行验证前**强制**读取，以与 `AGENTS.md` baseline 及仓库内工具约定一致。`workflow_guard` 仅定位意图时可不读。
- `feature_confirm` 吸收了实施方案确认动作，旧的独立 `code_implement_plan` 已被移除。
- `workflow_repair` 成为显式修复入口。
- `docs/ai/memory/` 变成可选支持层，不再是默认活跃状态存储。
- 模板资产改为 skill-local 分发，单个 SKILL.md 有 150 行上限约束。
- `project_init` 变成可重复执行的扫描与路由入口；`project_docs_optimize` 统一承担兼容迁移、文档重构和 AI 规则导入分析。
- `docs/ai/context/project_brief.md` 进入需求阶段必读集合，用于在澄清需求前先校准项目背景。

兼容说明：

- `docs/ai/lessons.md`、`docs/ai/pitfalls.md`、`docs/ai/anti-patterns.md` 等旧结构只作为兼容输入保留；发现后应由 `project_docs_optimize` 分析并提出迁移方案。
- `docs/ai/skills/` 被视为团队 skill 资产入口；OMS 只盘点该目录，不负责这些 skill 的加载与执行。

## License

[The Unlicense](LICENSE)

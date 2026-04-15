# Oh My Skills

Oh My Skills（OMS）是一套面向 AI 编程协作的仓库内治理框架。它不是零散提示词集合，而是一整套可分发的 skills、模板资产和工作流规则，用来约束 agent 如何澄清需求、产出设计、确认方案、执行代码、验证结果、处理回退，以及沉淀长期知识。

README 是项目整体的最新说明书。若 README 与零散文档存在表述差异，应以 README 描述的当前运行模型为准，再回查对应 skill 与模板资产。

## 它能带来什么

OMS 解决的是 AI 参与开发时最常见的几类失控问题：

- agent 接到需求就开始写代码，跳过澄清与设计。
- 项目状态散落在聊天记录里，下一次对话无法稳定恢复。
- 代码变了，文档没变，负责人很难判断当前真实进度。
- 用户中途改口或发现前置设计错误时，流程没有正式回退机制。
- agent 在没有新鲜证据的情况下声称完成，或在环境问题面前反复重试而不停下来问。

对应地，OMS 提供这些核心能力：

- **节点化工作流**：把需求、设计、实施、验证拆成明确阶段，每个阶段有进入门禁。
- **文档化状态管理**：spec 状态锚点持有真实节点，`docs/progress.md` 只做摘要。
- **设计与实施分离**：只有进入 `ReadyForImplementation` 后才允许实施代码。
- **显式修复机制**：当设计或实现不闭环时，走 `workflow_repair`，而不是偷偷改状态。
- **精准上下文注入**：每个 skill 只加载当前步骤必需的文档，多开发者场景下自动识别活跃 spec 并要求用户确认。
- **AI 行为约束**：每个 skill 内置 Iron Law、Never 规则和 Red Flags，防止 agent 假设替代澄清、顺手修改范围外代码、声称完成但没有证据。
- **可分发运行时**：模板资产跟随 skill 一起分发，不依赖仓库中的统一模板目录。

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
project_init
  -> context_sync
  -> requirement_probe
  -> feature_plan
  -> feature_confirm (review / lock)
  -> code_implement_confirm
  -> verification_gate
  -> project_release
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
| `Patch` | `docs/spec/{name}.md`（单文件） | 局部修复，内容完整写入一个文件 |
| `Feature` | `docs/spec/{name}/`（子目录） | 新能力开发，内容按阶段拆分 |

Feature 类 spec 的子目录结构：

```text
docs/spec/{name}/
├── index.md     ← 状态锚点，持有所有 frontmatter，节点变更只写这里
├── req.md       ← 需求范围与验收标准（requirement_probe 阶段写入）
├── design.md    ← 技术方案与影响分析（feature_plan 阶段写入）
└── impl.md      ← 执行包、回滚计划、测试计划（feature_confirm lock 后写入）
```

每个 skill 只读取当前阶段需要的子文档，`workflow_guard` 只需读 `index.md`，不加载完整 spec 内容。

## 精准上下文注入

OMS 将上下文视为有限资源，通过以下机制减少不必要加载：

**Spec 按需定位**：新对话开始时，先读 `docs/progress.md` 定位活跃 spec，而不是全量扫描 `docs/spec/`。

**多开发者场景**：若 `docs/progress.md` 中存在多个活跃 spec（多人并行开发），agent 会列出所有进行中的工作项并要求用户明确指定，而不是自行猜测：

```
当前项目有多个进行中的工作项，请确认本次对话要处理哪个：
1. create-task — Implementing — 新增创建任务接口
2. offerwall-refactor — DesignDraft — 广告墙重构方案
请指定编号或名称。
```

**architecture.md 条件加载**：只有 `Scope: Feature` 或涉及跨模块/接口/数据层改动时才加载，Patch 类需求直接跳过。

**Lessons 精准注入**：Lessons 按操作类型分类存储，各 skill 只加载当前阶段对应的分类文件。

## AI 行为约束体系

每个核心 skill 内置三层约束，防止 agent 常见的失控行为：

| 约束层 | 作用 |
| :--- | :--- |
| **Iron Law** | 不可违反的核心规则，以代码块形式突出显示 |
| **Never 列表** | 明确禁止的操作，每条都有具体场景 |
| **Red Flags - STOP** | 触发后必须立即停止的警报信号 |

各 skill 对应的核心约束：

- `requirement_probe`：有歧义先问，不假设，不替用户填补验收标准
- `feature_plan`：YAGNI，最小可行方案，不加未被要求的抽象
- `feature_confirm`：Simplicity Gate，execution package 不得超出需求范围
- `code_implement_confirm`：只改 execution package 列出的文件；执行前检查工具可用性；相同错误连续 2 次必须停下来报告
- `verification_gate`：没有新鲜运行证据，不能声称完成

## 知识与经验沉淀

**Lessons 分类体系**：Lessons 不再是单一文件，而是按操作类型分类存储：

```text
docs/knowledge/lessons/
├── design.md    ← 需求/设计阶段的判断错误
├── code.md      ← 实现阶段的操作失误与禁止行为
├── testing.md   ← 验证/测试相关的遗漏
├── workflow.md  ← 节点推进与流程相关
└── domain.md    ← 业务规则与领域特定约束（永久约束，建议升格）
```

`domain` 类 lesson 总是建议通过 `knowledge_review` 升格到 `docs/domain_rules.md`，成为永久约束，而不是停留在临时纠错层。

**旧版 `docs/lessons.md` 迁移**：`project_init` 和 `lesson_capture` 都内置了迁移逻辑，发现旧版单文件时自动按分类迁移，迁移完成后删除原文件。

## 会生成哪些文档

执行 `project_init` 后，目标项目会得到最小治理骨架：

```text
AGENTS.md
docs/
├── context/project_brief.md
├── architecture.md
├── spec/                          # Patch: {name}.md / Feature: {name}/index.md + 子文档
├── progress.md
├── knowledge/
│   ├── index.md                   # 知识路由与 lessons 加载规则
│   └── lessons/                   # 按操作类型分类的纠错经验
├── history/
└── memory/                        # optional, only when archive/resume is enabled
```

这些文档的职责：

- `AGENTS.md`：治理边界、加载策略、技能路由。
- `docs/spec/`：单个需求或补丁的协议，也是 workflow node 的 source of truth。
- `docs/progress.md`：当前状态指针，summary-only，不承载节点真相。
- `docs/architecture.md`：系统结构与边界（按需加载，非全量 baseline）。
- `docs/knowledge/index.md`：知识路由入口，含 lessons 加载规则。
- `docs/knowledge/lessons/`：按操作类型分类的纠错经验，精准注入，不全量加载。
- `docs/memory/`：可选快照层，只在 handoff 或历史重建需要时启用。

## 怎么使用

最小使用方式：

1. 将整套 OMS skill 文件夹安装到 AI 助手可识别的 skills 目录中。
2. 在目标项目执行 `project_init`。
3. 新会话或继续工作时执行 `context_sync`。
4. 按当前意图进入需求、设计、确认、实施、验证或发布链路。

`project_init` 支持三种模式：

- `bootstrap`：新项目或缺失 OMS baseline 的仓库。
- `migrate`：把 v2 或团队自定义 docs 体系迁入 OMS v3（含旧版 lessons 迁移）。
- `reconcile`：重新扫描代码，补齐已有 OMS v3 档案中的结构事实与进度摘要。

## 使用示例

### 示例：服务端新增"创建任务"接口（Feature 类，多文件 spec）

```text
用户：项目初始化。
Agent：[project_init] 执行 bootstrap，生成 AGENTS.md、architecture、progress、knowledge index 等治理骨架。

用户：继续。
Agent：[context_sync] 读取 AGENTS.md + progress.md，当前无活跃 spec，进入正常开发链路。

用户：我要新增一个"创建任务"的接口，POST /api/tasks。
Agent：[requirement_probe] 补齐鉴权规则、入参校验、返回结构、错误码和验收标准。
       Scope 判断：Feature（涉及新接口和数据写入）→ 将使用 multi-file spec。

用户：标题不能为空，截止时间不能早于当前时间，成功返回任务 id 和 createdAt。
Agent：[feature_plan] 创建 docs/spec/create-task/index.md + req.md + design.md + impl.md（空）。
       YAGNI 自查通过：无未被要求的抽象。

用户：先输出实施方案，我要 review。
Agent：[feature_confirm review] 读取 design.md + req.md，输出 execution package，Simplicity Gate 通过。

用户：方案可以，开始做。
Agent：[feature_confirm lock] 将 Current_Node 推进到 ReadyForImplementation，execution package 写入 impl.md。

用户：开始实现。
Agent：[code_implement_confirm] Pre-flight 检查工具可用 → 按 impl.md 执行，只改列出的 3 个文件。

用户：增加规则：protocol 文件由自动化工具生成，禁止手动修改。
Agent：[lesson_capture] 分类为 domain → 写入 docs/knowledge/lessons/domain.md。
       建议通过 knowledge_review 升格到 docs/domain_rules.md（永久约束）。

用户：当前版本开发完成。
Agent：[verification_gate] 运行测试，输出实际运行证据，逐条核对 req.md 验收标准，advance。
```

### 示例：多开发者并行场景

```text
用户：继续做。
Agent：[context_sync] 发现 progress.md 中有 2 个活跃 spec：

当前项目有多个进行中的工作项，请确认本次对话要处理哪个：
1. create-task — Implementing — 新增创建任务接口
2. offerwall-refactor — DesignDraft — 广告墙重构方案

请指定编号或名称。

用户：1
Agent：加载 docs/spec/create-task/index.md，恢复上下文，继续 Implementing 阶段。
```

## Skill 编写约束

OMS skill 文件本身在被调用时会占用上下文。为避免 skill 自身成为上下文负担，编写和维护 skill 时须遵守：

- **单个 `SKILL.md` 不超过 150 行**
- 超过时，将示例、参考表格、扩展说明移入 skill 目录下的 `references/` 子文件夹，主文件只保留核心流程逻辑
- Instructions 中的正反例（✅/❌）每个 skill 合计不超过 4 对，优先保留最易混淆的那几条
- Iron Law、Never、Red Flags 每节不超过 6 条，超过时合并相近条目

## 运行时分发模型

这个仓库是 skill 分发仓库，不是某个业务项目本身。运行时模板跟随 owner skill 一起分发：

- `project_init/templates/`：AGENTS.md、architecture、progress、knowledge-index 等基础模板
- `feature_plan/templates/`：spec 单文件模板（spec.v3.md）与多文件模板（spec-index/req/design/impl.v3.md）
- `capability_bootstrap/templates/`：frontend、interfaces、data-model、domain-rules 等能力文档模板

分发时须保留完整 skill 文件夹（含 `templates/` 和 `references/`），而不是只拷贝 `SKILL.md`。

## 与 v2 的主要差异

- `docs/spec/` 现在支持双模式：Patch 用单文件，Feature 用子目录（index/req/design/impl）。
- `docs/lessons.md` 废弃，改为 `docs/knowledge/lessons/` 分类体系，按操作类型精准注入。
- 每个 skill 内置 Iron Law、Never、Red Flags，AI 行为约束从"软提示"变为"硬规则"。
- `workflow_guard` 和 `context_sync` 改为两步定位，多个活跃 spec 时暂停并要求用户确认。
- `architecture.md` 改为条件加载（仅 Feature 或跨模块场景），不再是默认 baseline 文档。
- `feature_confirm` 吸收了实施方案确认动作，旧的独立 `code_implement_plan` 已被移除。
- `workflow_repair` 成为显式修复入口。
- `docs/memory/` 变成可选支持层，不再是默认活跃状态存储。
- 模板资产改为 skill-local 分发，单个 SKILL.md 有 150 行上限约束。

兼容说明：

- 旧版 `docs/lessons.md` 在 `project_init`（migrate/reconcile）和 `lesson_capture` 中自动迁移，迁移完成后删除原文件。
- legacy durable knowledge（`docs/pitfalls.md`、`docs/anti-patterns.md`）在迁移期仍可作为兼容输入，但新的长期知识应进入 `docs/knowledge/...`。
- old prompts that still mention `code_implement_plan` should be migrated to `feature_confirm`.

## License

[The Unlicense](LICENSE)

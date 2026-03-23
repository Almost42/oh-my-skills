# Oh My Skills

Oh My Skills（OMS）是一套面向 AI 编程协作的仓库内治理框架。它提供的不是一组零散提示词，而是一整套可分发的 skills、模板资产和工作流规则，用来约束 agent 在项目中如何澄清需求、产出设计、确认方案、执行代码、验证结果、处理回退，以及沉淀长期知识。

README 是项目整体的最新说明书。若 README 与零散文档存在表述差异，应以 README 描述的当前运行模型为准，再回查对应 skill 与模板资产。

## 这个项目现在能为你带来什么

如果你希望 AI 助手不只是“能写代码”，而是能在项目里稳定协作，OMS 主要提供这些能力：

- 让 agent 按阶段工作，而不是接到需求就直接动手写代码。
- 把需求、设计、实现、验证、知识沉淀放到固定文档落点中，减少上下文漂移。
- 在用户中途反悔、补充需求、发现前置设计错误时，支持显式修复和节点回退，而不是偷偷改状态。
- 把长期知识和会话记忆拆开管理，默认轻量恢复，需要时再升级。
- 让一整套技能可直接分发给其他开发者安装，而不是依赖仓库里某个统一模板目录。

## 核心特性

### 1. 节点化研发工作流

OMS 把一次需求或补丁的推进过程拆成明确节点：

| Node | 含义 | 可写代码 |
| :--- | :--- | :--- |
| `RequirementDraft` | 需求目标、边界、成功标准仍在澄清 | No |
| `DesignDraft` | 需求已基本明确，但方案和影响还在设计 | No |
| `ReadyForImplementation` | 设计与 execution package 已获批 | No |
| `Implementing` | 已批准工作正在落地为代码 | Yes |
| `Verifying` | 代码已存在，正在验证验收与回归 | No |
| `Archived` | 工作完成且已做版本级归档 | No |

核心价值不是多了几个状态名，而是让 agent 在每一步都知道：

- 当前处在哪个阶段。
- 下一步应该调用哪个 skill。
- 哪些动作现在能做，哪些动作现在不能做。

### 2. 需求、设计、实施分阶段确认

OMS 把“先想清楚，再动手”做成了运行时规则，而不是写在 README 里的口号。

- `requirement_probe` 负责判断需求是否足够清晰，决定继续停留在 `RequirementDraft`，还是可以进入 `DesignDraft`。
- `feature_plan` 负责生成或修订设计草案，把影响范围、技术方案、验收标准写入 spec。
- `feature_confirm (review / lock)` 负责评审 execution package，并在用户明确批准后推进到 `ReadyForImplementation`。
- `code_implement_confirm` 只处理已经批准的方案，不再替代设计确认。

这意味着 agent 默认不会把“想法”“设计稿”“可实施方案”“代码执行”混成一步。

### 3. 显式修复与节点回退

大多数项目里的真实情况不是“每一步都一次做对”，而是：

- 用户看完方案后发现需求没想清楚。
- 代码写完后才意识到最开始设计有缺口。
- 验证阶段暴露出更早节点的问题。

OMS 用 `workflow_repair` 处理这类情况。它要求 agent：

1. 说明当前节点。
2. 说明问题类型。
3. 给出建议回退节点。
4. 列出需要更新的文档或方案内容。
5. 等待用户确认后再应用回退或修复决策。

也就是说，OMS 允许技能被多次执行，并且把“回退”和“补修”当成正式流程的一部分。

### 4. 默认轻量的上下文恢复

OMS 默认不靠大而全的长期记忆来恢复项目状态，而是优先读取最小 baseline 文档：

- `AGENTS.md`
- `docs/progress.md`
- 活跃 `docs/spec/*.md`
- `docs/architecture.md`
- `docs/knowledge/index.md`

`context_sync` 是默认恢复入口。只有 baseline 文档不足以恢复当前任务时，才升级到 `session_resume`。

默认不创建 `docs/memory/`。默认恢复路径是 `context_sync`，不是 `session_resume`。

可以把这三层关系理解为：

- `docs/spec/*.md` 像持久化的工作状态机，记录真实节点、修复状态和回退目标。
- `docs/progress.md` 像当前运行状态的指针，告诉 agent 现在聚焦哪里、下一步做什么。
- `docs/memory/` 像运行时上下文快照，只在正式文档不足以恢复现场时补充使用。

约束也很明确：`memory` 只能辅助恢复，不能替代 `spec` 或 `progress` 成为权威状态。

### 5. 长期知识沉淀闭环

OMS 不把“经验”直接塞进杂乱的附加说明，而是拆成两层：

- `lesson_capture`：先把本轮纠错记进 `docs/lessons.md`
- `knowledge_review`：当经验足够稳定时，再整理为可审核的长期知识升格提案

这样做的好处是：

- 活跃纠错可以快速记录。
- 长期知识不会被低质量噪声污染。
- 发布前还能做版本级知识审查。

### 6. 新能力出现时自动补治理文档

很多项目不是一开始就有完整结构，而是在演进中逐渐长出前端、接口、数据、运维或领域规则能力。

OMS 用 `capability_bootstrap` 处理这类“能力扩展”场景。它会在检测到 capability growth 后：

- 补建缺失的 capability docs
- 同步 `AGENTS.md`
- 同步 `docs/architecture.md`
- 同步 `docs/knowledge/index.md`

这让治理层能跟着项目结构一起长，而不是永远停留在初始化那一刻。

### 7. 模板与 skill 一起分发

这个仓库不是一个已经接入 OMS 的业务项目，而是一个 skill 分发仓库。

运行时模板和其 owner skill 一起分发：

- `project_init/templates/`
- `feature_plan/templates/`
- `capability_bootstrap/templates/`

这意味着：

- 别人安装整套 skill 文件夹后就能运行。

## 怎么用

对于第一次接触 OMS 的使用者，最小流程如下：

1. 将整套 OMS skill 文件夹安装到 AI 助手可识别的 skills 目录中。
2. 在目标项目里执行 `project_init`，生成最小治理骨架和能力文档槽位。
3. 新会话或继续工作时执行 `context_sync`，恢复 baseline 上下文。
4. 根据当前意图进入需求澄清、设计、确认、实现、验证或发布链路。

如果你是在维护一个要分发给他人的 OMS 包，还需要注意：

- 分发时要保留完整 skill 文件夹，不要只拷贝 `SKILL.md`。
- `project_init/templates/`、`feature_plan/templates/`、`capability_bootstrap/templates/` 属于运行时资产。

## 基础使用流程

OMS 当前的主流程如下：

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

这条流程的作用可以简化理解为：

- `project_init`：把项目纳入 OMS。
- `context_sync`：恢复当前状态。
- `requirement_probe`：确认问题到底是什么。
- `feature_plan`：把需求写成可讨论的设计草案。
- `feature_confirm (review / lock)`：确认实施包，拿到用户批准。
- `code_implement_confirm`：按批准方案执行代码。
- `verification_gate`：基于新鲜证据判断是否真的完成。
- `project_release`：做发布、归档和知识收口。

辅助闭环包括：

- `workflow_guard`：在重要动作前判断当前节点、缺失门禁和下一步路由。
- `workflow_repair`：需求、设计、实现、验证不闭环时，负责提出修复或回退方案。
- `progress_sync`：把当前 spec 状态同步为摘要。
- `lesson_capture` 与 `knowledge_review`：把短期教训升级为长期知识。
- `capability_bootstrap`：项目结构变复杂时补文档、补治理。

## 接入后会生成什么文档

执行 `project_init` 后，目标项目里会按能力生成最小治理骨架。基础结构如下：

```text
AGENTS.md
docs/
├── context/project_brief.md
├── architecture.md
├── spec/
├── progress.md
├── knowledge/index.md
├── history/
├── lessons.md
└── memory/                # optional, only when archive/resume is enabled
```

这些文档的职责分别是：

- `AGENTS.md`：治理边界、加载策略、技能路由和更新政策。
- `docs/context/project_brief.md`：项目目标、范围、非目标和成功标准。
- `docs/architecture.md`：系统结构、模块边界、扩展点和约束。
- `docs/spec/*.md`：单个需求或补丁的工作协议，也是 workflow node 的 source of truth。
- `docs/progress.md`：当前阶段摘要，相当于当前运行状态的指针，不持有节点真相。
- `docs/knowledge/index.md`：知识入口和按 tag 的加载路由。
- `docs/lessons.md`：活跃纠错记录。
- `docs/history/`：版本级归档和阶段总结。
- `docs/memory/`：可选支持层，相当于运行时上下文快照，只在 handoff 或历史重建确有需要时启用。

## 与 v2 的主要差异

如果你之前用过 v2，这一版最重要的变化只有几项：

- `docs/spec/*.md` 现在持有 workflow node 的真实状态，`docs/progress.md` 只做 summary。
- `feature_confirm` 吸收了原本分散的实施方案确认动作，旧的独立 `code_implement_plan` 已被移除。
- `workflow_repair` 成为显式修复入口，节点回退和设计补修不再靠隐式处理。
- `docs/memory/` 变成可选支持层，不再是默认活跃状态存储。
- 模板资产改为 skill-local 分发，运行时不再依赖统一模板目录。

兼容说明：

- old prompts that still mention `code_implement_plan` should be migrated to `feature_confirm`.
- `code_implement_plan` 不再是 active runtime skill。
- legacy durable knowledge（`docs/pitfalls.md`、`docs/anti-patterns.md`）在迁移期仍可作为兼容输入，但新的长期知识应进入 `docs/knowledge/...`。

## License

[The Unlicense](LICENSE)

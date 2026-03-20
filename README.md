# Oh My Skills

Oh My Skills 是一套面向 AI 编程协作的仓库内治理框架。v3 的核心目标不是“让 agent 记住更多”，而是让工作流状态、设计确认、修复回退和知识沉淀都有稳定的落点。

## v3 核心变化

- `docs/spec/*.md` 持有 workflow node 状态，`docs/progress.md` 只做 summary。
- `feature_confirm` 吸收了实施方案评审，分为 `review` 和 `lock` 两个 mode。
- `workflow_repair` 成为显式修复入口，任何需求/设计/实现/验证错位都先提 repair proposal，再等用户确认。
- `docs/memory/` 是可选支持层，不是默认 active-state 存储。
- `code_implement_plan` 已被移除，旧引用应迁移到 `feature_confirm`。

## Canonical Nodes

| Node | 含义 | 可写代码 |
| :--- | :--- | :--- |
| `RequirementDraft` | 需求意图、边界和成功标准仍在澄清 | No |
| `DesignDraft` | 需求基本明确，但方案/影响/约束仍在设计 | No |
| `ReadyForImplementation` | 设计和 execution package 都已获批 | No |
| `Implementing` | 已批准工作正在落地为代码 | Yes |
| `Verifying` | 代码已存在，正在验证验收与回归 | No |
| `Archived` | 工作已完成，且版本级归档已完成 | No |

## Primary Flow

```text
project_init
  -> context_sync
  -> requirement_probe
  -> feature_plan
  -> feature_confirm (review / lock)
  -> code_implement_confirm
  -> verification_gate
  -> project_release

workflow_repair can be entered from any active workflow step when the node or plan is wrong.
```

主流程中的关键约束：

- `feature_confirm (review)` 只审 execution package，不推进节点。
- `feature_confirm (lock)` 只在用户明确批准后把节点推进到 `ReadyForImplementation`。
- `code_implement_confirm` 只接受 `ReadyForImplementation` 或已在 `Implementing` 的 spec。
- 完成、通过、修复等结论必须先经过 `verification_gate`。

## Skill List

| Skill | 作用 | 触发场景 |
| :--- | :--- | :--- |
| `project_init` | 初始化 always-on docs 与 capability docs | 新项目接入或现有项目纳入 OMS |
| `context_sync` | 默认恢复入口，读取 baseline docs | 新会话、继续工作、怀疑文档漂移 |
| `requirement_probe` | 澄清需求并判断 `Feature` / `Patch` 与节点去向 | 新需求、补需求、模糊请求 |
| `feature_plan` | 创建或修订 `DesignDraft` spec | 需求已足够进入方案设计 |
| `feature_confirm` | 审 execution package 并在批准后锁定实现入口 | 设计确认、实施方案确认 |
| `code_implement_confirm` | 从 `ReadyForImplementation` 进入 `Implementing` 并执行代码改动 | 用户批准执行包后开始写代码 |
| `verification_gate` | 基于 fresh evidence 判断 `stay` / `advance` / `repair_required` | 声称完成、修复或通过之前 |
| `workflow_repair` | 显式提出 repair / rollback proposal 并等待用户确认 | 发现节点错位、方案缺口、验证反证 |
| `progress_sync` | 用 active spec 刷新 `docs/progress.md` summary | 节点变化、状态同步 |
| `lesson_capture` | 把纠错先落到 `docs/lessons.md` | 用户纠正 agent、重复错误、项目偏好暴露 |
| `knowledge_review` | 草拟 durable knowledge promotion proposal | lessons 稳定、session 候选积累、版本审核 |
| `session_archive` | 只在确有 handoff 价值时写会话快照 | 跨会话、跨模型、跨工具交接 |
| `session_resume` | 仅在 baseline docs 不足时进入 escalation 恢复 | `context_sync` 不够用时 |
| `project_release` | 版本级归档、知识审查、文档一致性收口 | 发布、定版、里程碑归档 |
| `capability_bootstrap` | 项目长出新能力后补建文档并同步治理层 | 新增前端/API/数据/运维/领域能力 |

## Packaging Model

运行时模板不再依赖仓库下的 `docs/templates/`。为保证“安装 skill 文件夹即可使用”，模板资产与其 owner skill 一起分发：

- `project_init/templates/`
  - always-on docs 模板：`AGENTS.v3.md`、`project_brief.v3.md`、`architecture.v3.md`、`progress.v3.md`、`knowledge-index.v3.md`、`history-entry.v3.md`
- `feature_plan/templates/`
  - `spec.v3.md`
- `capability_bootstrap/templates/`
  - capability docs 模板，如前端、流程、接口、数据、运维、领域规则

因此，`docs/` 可以作为维护者本地资料目录存在，甚至被 `.gitignore` 忽略；安装和运行不应依赖它承载模板资产。

## Repository Shape

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

说明：

- `AGENTS.md` 负责治理边界、加载策略和 trigger routing。
- `docs/spec/*.md` 是 change-scoped agreement，也是 node 状态的 source of truth。
- `docs/progress.md` 只保留当前 summary，不承担节点所有权。
- `docs/knowledge/index.md` 通过 tag 路由知识加载。
- `docs/lessons.md` 先承接活跃纠错，后续再由 `knowledge_review` 决定 promotion。

## Memory Policy

- 默认恢复路径是 `context_sync`，不是 `session_resume`。
- 默认不创建 `docs/memory/`。
- 只有在 handoff 或历史重建确有必要时，才启用 `session_archive` / `session_resume`。
- 迁移期仍允许读取 `docs/pitfalls.md` 和 `docs/anti-patterns.md`，但新的 durable knowledge 应进入 `docs/knowledge/...`。

## Repair Policy

当任一步骤发现“当前节点不对”或“前置设计不成立”时，系统不应静默继续。应当：

1. 说明当前节点与问题类型。
2. 给出建议回退节点。
3. 列出需要更新的文档/方案内容。
4. 进入 `workflow_repair`。
5. 等待用户确认后再应用 rollback 或 stay 决策。

这使节点可以重复进入，也让非专家用户始终知道当前处于哪个阶段。

## Quick Use

- “继续之前的工作” -> `context_sync`
- “我需要加一个需求” -> `requirement_probe`
- “先把方案写出来” -> `feature_plan`
- “我想看实施方案” -> `feature_confirm (review)`
- “方案可以，开始做” -> `feature_confirm (lock)` 然后 `code_implement_confirm`
- “现在能说完成了吗” -> `verification_gate`
- “这里得回到设计重来” -> `workflow_repair`
- “记录这次教训” -> `lesson_capture`
- “把 lessons 升格为知识” -> `knowledge_review`
- “发布这一轮改动” -> `project_release`

## Compatibility

- old prompts that still mention `code_implement_plan` should be migrated to `feature_confirm`.
- legacy durable knowledge (`docs/pitfalls.md`, `docs/anti-patterns.md`) 在迁移期仍可读取。
- tool-specific rules 可以扩展 OMS，但不应替代 OMS 的 source-of-truth 边界。

## License

[The Unlicense](LICENSE)

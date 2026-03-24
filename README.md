# Oh My Skills

Oh My Skills（OMS）是一套面向 AI 编程协作的仓库内治理框架。它不是零散提示词集合，而是一整套可分发的 skills、模板资产和工作流规则，用来约束 agent 如何澄清需求、产出设计、确认方案、执行代码、验证结果、处理回退，以及沉淀长期知识。

README 是项目整体的最新说明书。若 README 与零散文档存在表述差异，应以 README 描述的当前运行模型为准，再回查对应 skill 与模板资产。

## 它能带来什么

OMS 解决的是 AI 参与开发时最常见的几类失控问题：

- agent 接到需求就开始写代码，跳过澄清与设计。
- 项目状态散落在聊天记录里，下一次对话无法稳定恢复。
- 代码变了，文档没变，负责人很难判断当前真实进度。
- 用户中途改口或发现前置设计错误时，流程没有正式回退机制。

对应地，OMS 提供这些核心能力：

- 节点化工作流：把需求、设计、实施、验证拆成明确阶段。
- 文档化状态管理：`docs/spec/*.md` 持有真实节点，`docs/progress.md` 只做摘要。
- 设计与实施分离：只有进入 `ReadyForImplementation` 后才允许实施代码。
- 显式修复机制：当设计或实现不闭环时，走 `workflow_repair`，而不是偷偷改状态。
- 轻量恢复优先：默认先靠 baseline 文档恢复上下文，默认不创建 `docs/memory/`。
- 可分发运行时：模板资产跟随 skill 一起分发，不依赖仓库中的统一模板目录。

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

## 怎么使用

最小使用方式：

1. 将整套 OMS skill 文件夹安装到 AI 助手可识别的 skills 目录中。
2. 在目标项目执行 `project_init`。
3. 新会话或继续工作时执行 `context_sync`。
4. 按当前意图进入需求、设计、确认、实施、验证或发布链路。

`project_init` 现在是统一入口，支持三种模式：

- `bootstrap`：新项目或缺失 OMS baseline 的仓库。
- `migrate`：把 v2 或团队自定义 docs 体系迁入 OMS v3。
- `reconcile`：重新扫描代码，补齐已有 OMS v3 档案中的结构事实与进度摘要。

`project_init` 可以补结构事实、迁移旧文档、刷新摘要，但不应仅凭代码扫描自动改写需求意图、验收标准或 spec 节点确认。

## 会生成哪些文档

执行 `project_init` 后，目标项目会得到最小治理骨架：

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

这些文档的职责很简单：

- `AGENTS.md`：治理边界、加载策略、技能路由。
- `docs/spec/*.md`：单个需求或补丁的协议，也是 workflow node 的 source of truth。
- `docs/progress.md`：当前摘要，相当于运行状态指针。
- `docs/architecture.md`：系统结构与边界。
- `docs/knowledge/index.md`：知识路由入口。
- `docs/lessons.md`：活跃纠错。
- `docs/memory/`：可选快照层，只在 handoff 或历史重建需要时启用。

可以把三层关系理解为：

- `docs/spec/*.md` 是持久化状态机。
- `docs/progress.md` 是当前状态指针。
- `docs/memory/` 是可选运行时快照。

## 使用示例

### 示例：服务端新增“创建任务”接口

状态机流程：
`bootstrap -> context_sync -> RequirementDraft -> DesignDraft -> ReadyForImplementation -> Implementing -> Verifying -> Archived`

```text
用户：项目初始化。
Agent：（状态：`bootstrap`）执行 `project_init`，完成 baseline 文档生成，建立 AGENTS、architecture、progress、knowledge index 等治理骨架。

用户：继续。
Agent：（状态：已完成初始化）执行 `context_sync`，恢复当前基线，明确当前没有活跃 spec，进入正常开发链路。

用户：我要新增一个“创建任务”的接口，POST `/api/tasks`，字段有标题、描述、截止时间，只有登录用户能创建。
Agent：（状态：`需求新增`）执行 `requirement_probe`，补齐鉴权规则、入参校验、返回结构、错误码、落库方式和验收标准。

用户：标题不能为空，截止时间不能早于当前时间；成功后写入 `tasks` 表，返回任务 `id` 和 `createdAt`；未登录返回 `401`，参数错误返回 `400`。
Agent：（状态：`需求草稿`）执行 `feature_plan`，生成需求草稿，并写入接口契约、数据模型影响、验证规则和验收标准。

用户：先输出实施方案，我要 review。
Agent：（状态：`方案评审`）已输出实施方案，整理了改动点、数据影响、测试点、风险和回滚方案等内容。

用户：方案可以，开始做。
Agent：（状态：`准备实施`）已锁定方案，确认本轮可以开始编码实现。

用户：开始实现，完成后把测试一起补上。
Agent：（状态：`开发中`）已开始按方案实现，并把测试一并纳入本轮交付。

用户：输出当前代码验收结果，对比需求和实际进度。
Agent：（状态：`验证中`）已输出验收结果和进度对比，说明已完成的需求项、已通过的测试项，以及当前是否还有未完成内容。

用户：增加规则：protocol文件由自动化工具生成，禁止手动修改。
Agent：（状态：`规则补充`）已记录这条规则，并同步到当前文档；后续稳定后可升格为长期知识。

用户：需求补充：创建任务成功后还要发布 `TaskCreated` 事件，并同步更新对外 protocol。
Agent：（状态：`需求补充`）这是新增范围。我会先回到设计阶段，补齐事件流、协议生成和新增验收标准，再继续后续流程。

用户：对比需求和当前进度。
Agent：（状态：`验证中`）已完成需求对比：接口鉴权、参数校验、数据写入、返回字段、错误码、事件发布和协议生成等都已满足，当前没有新增阻塞。

用户：当前版本开发完成。
Agent：（状态：`版本确认`）已确认当前版本完成本轮开发，接下来会归档需求记录、更新进度和历史文档，并完成版本收口。

```

## 运行时分发模型

这个仓库是 skill 分发仓库，不是某个业务项目本身。运行时模板跟随 owner skill 一起分发：

- `project_init/templates/`
- `feature_plan/templates/`
- `capability_bootstrap/templates/`

这意味着分发给别人时要保留完整 skill 文件夹，而不是只拷贝 `SKILL.md`。

## 与 v2 的主要差异

- `docs/spec/*.md` 现在持有 workflow node 的真实状态，`docs/progress.md` 只做 summary。
- `feature_confirm` 吸收了实施方案确认动作，旧的独立 `code_implement_plan` 已被移除。
- `workflow_repair` 成为显式修复入口。
- `docs/memory/` 变成可选支持层，不再是默认活跃状态存储。
- 模板资产改为 skill-local 分发。

兼容说明：

- old prompts that still mention `code_implement_plan` should be migrated to `feature_confirm`.
- `code_implement_plan` 不再是 active runtime skill。
- legacy durable knowledge（`docs/pitfalls.md`、`docs/anti-patterns.md`）在迁移期仍可作为兼容输入，但新的长期知识应进入 `docs/knowledge/...`。

## License

[The Unlicense](LICENSE)

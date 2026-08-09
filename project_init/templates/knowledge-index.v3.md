# 知识索引

## 加载规则

- 本文件只做路由，不承载长期知识正文。
- 优先加载明确 owner：`docs/ai/domain_rules.md` > capability docs > `docs/ai/architecture.md` > lessons。
- baseline 只读取：`AGENTS.md`、`docs/ai/progress.md`、`docs/ai/spec/index.md`、活跃 spec 状态锚点、`docs/ai/knowledge/index.md`
- `docs/ai/knowledge/lessons/` 永不进入 baseline，只在对应动作开始前按分类精准加载。
- lessons 条目不进入 baseline，只加载与当前模块、能力或 spec 标签匹配的经验。

## Owner 路由

| 信号 | 文件 | 何时加载 |
| :--- | :--- | :--- |
| `domain` | `docs/ai/domain_rules.md` | 任务涉及业务硬约束、禁区、协议规则 |
| `capability:interfaces` | `docs/ai/interfaces.md` | 接口契约、输入输出、兼容性成为主要关注点 |
| `capability:data` | `docs/ai/data_model.md` | 数据模型、不变量、迁移约束成为主要关注点 |
| `capability:frontend` | `docs/ai/frontend/guidelines.md` | 前端交互、状态协作、响应式规则成为主要关注点 |
| `capability:operations` | `docs/ai/operations.md` | 发布、配置、恢复、运维限制成为主要关注点 |
| `architecture` | `docs/ai/architecture.md` | 需要理解结构边界、模块关系、工具链或环境约定 |

## Lessons 路由

Lessons 文件在对应操作类型开始前加载，不随 baseline 全量加载。

| 操作类型 / Skill | 加载文件 |
| :--- | :--- |
| 需求澄清、方案设计（`requirement_probe`、`feature_plan`、`feature_confirm`） | `docs/ai/knowledge/lessons/design.md` |
| 代码实现（`code_implement_confirm`） | `docs/ai/knowledge/lessons/code.md` |
| 验证、测试（`verification_gate`） | `docs/ai/knowledge/lessons/testing.md` |
| 节点推进、状态变更（`workflow_guard`） | `docs/ai/knowledge/lessons/workflow.md` |
| 业务规则相关操作 | `docs/ai/knowledge/lessons/domain.md` |

Lessons 文件路径：`docs/ai/knowledge/lessons/{design|code|testing|workflow|domain}.md`

若对应文件不存在，跳过加载，不报错。

## 经验条目状态

- “已记录 / 待继续验证”：保留在原 lessons 条目中，只作为提示，不能覆盖正式规则。
- “已固化”：规则已写入目标 owner，lessons 只保留来源、证据和最近验证日期。
- “冲突待处理”：保留冲突证据，只供诊断，不得指导实现或覆盖现有规则。
- “已替代 / 已过期 / 一次性内容”：保留简短审计记录，不再主动注入。

## Spec 引用规范

- 先用 `docs/ai/spec/index.md` 按模块和处理方向定位历史 spec，再按需加载具体状态锚点。
- Single-file spec：直接引用 `docs/ai/spec/YYYY-MM-DD-{slug}.md`
- Multi-file spec：引用状态锚点 `docs/ai/spec/YYYY-MM-DD-{slug}/index.md`；按需引用子文档 `docs/ai/spec/YYYY-MM-DD-{slug}/req.md`、`design.md`、`impl.md`
- 禁止使用段落描述替代文件路径（如"docs/ai/offerwall-refactor 相关内容"）
- 大文件内部有明确段落时，可使用锚点：`docs/ai/spec/YYYY-MM-DD-{slug}/design.md#api-contracts`

## 收口原则

- 新的长期知识由 `knowledge_review(auto)` 按证据和风险自动分流到 owner；用户审核是高风险兜底，不是运行前提。
- `docs/ai/knowledge/lessons/*` 保存短期纠错、待验证条目和固化后的来源记录。
- `AGENTS.md` 只接收跨任务、低风险、通用治理规则；当前需求事实始终留在 spec。
- 若发现 legacy knowledge、旧 lessons 或职责混杂，交给 `project_docs_optimize` 分析和调整。

# AGENTS.md

## 治理定位

- 本仓库使用 OMS v3 作为治理内核；项目事实在文档中，工作流阶段由 spec 状态持有。
- `AGENTS.md` 只放通用治理、加载策略和路由，不放当前需求正文或业务细节。

## 事实边界

- `docs/ai/context/project_brief.md`：项目目的、范围、成功标准和术语。
- `docs/ai/architecture.md`：系统形态、模块边界、工具链和稳定架构约束。
- `docs/ai/domain_rules.md`：项目级硬约束、禁区与领域不变量。
- `docs/ai/spec/`：当前及历史需求的唯一完整档案；`spec/index.md` 只做索引。
- capability docs：已成体系能力的稳定接口、数据、流程、运维或前端事实。
- `docs/ai/knowledge/lessons/`：按类型保存经验条目、证据和固化状态。
- `docs/ai/history/`：只记录初始化、发布和治理审计事件，不复制需求归档。

## 加载策略

- baseline：`AGENTS.md`、`docs/ai/progress.md`、`docs/ai/spec/index.md`、活跃 spec 状态锚点、`docs/ai/knowledge/index.md`。
- `domain_rules.md`、architecture 和 capability docs 按任务信号加载。
- lessons 只按操作类型精准加载；未固化条目只作为与当前模块匹配的提示。
- “待继续验证”不得覆盖正式 owner；“冲突待处理”只能用于诊断，不能作为确定规则执行。

## Spec 加载规则

- spec 路径必须为 `docs/ai/spec/YYYY-MM-DD-{slug}.md` 或对应多文件目录。
- 多文件 spec 的 `index.md` 持有节点状态，`req.md`、`design.md`、`impl.md` 持有阶段内容。
- 不得用段落描述替代 spec 文件路径，也不得把 spec 细节复制到 owner 文档。

## 触发路由摘要

- 初始化、迁移、对账 -> `project_init`；文档结构偏移 -> `project_docs_optimize`。
- 恢复上下文 -> `context_sync`；新需求 -> `requirement_probe`。
- 设计确认 -> `feature_confirm`；实施 -> `code_implement_confirm`；完成声明 -> `verification_gate`。
- 验收收口先判断是否有可复用经验；有候选时执行 `lesson_capture` 与 `knowledge_review(auto)`，无候选时记录“无新增经验”；高风险和冲突项再进入人工审核。

## 更新策略

- 用户纠正、验收结果和重复模式先写 lessons；自动审核只将满足证据门槛的低风险规则写入受管 owner 区块。
- 通用治理才可进入 `AGENTS.md`；领域、架构和 capability 规则按 owner 分流。
- 普通需求归档只更新 progress/spec index，不生成 per-demand history；治理事件才写 history。
- 自动固化必须保留来源、证据、最近验证日期，并支持冲突待处理、已替代、已过期回退。

## 工具适配策略

- 工具特定规则可以扩展 OMS，但不得改变 source-of-truth 和 owner 边界；兼容路径必须显式记录。

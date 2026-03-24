# AGENTS.md

## 治理定位

- 本仓库使用 OMS v3 作为仓库原生治理内核。
- 项目事实应保存在仓库文档中，而不是瞬时提示词里。
- 工作流阶段由 spec 状态持有，而不是由会话叙述持有。

## 事实边界

- `docs/context/project_brief.md` 持有项目意图和范围。
- `docs/architecture.md` 持有系统形态和结构约束。
- `docs/spec/*.md` 持有变更范围协议和工作流节点状态。
- `docs/progress.md` 汇总当前活跃状态，并充当当前状态指针。
- `docs/knowledge/index.md` 负责知识加载路由。
- `docs/lessons.md` 存放活跃纠错。
- `docs/memory/` 仅作为交接或重建时的可选运行时快照。

## 加载策略

- baseline 读取集合：
  - `AGENTS.md`
  - `docs/progress.md`
  - 活跃 `docs/spec/*.md`
  - `docs/architecture.md`
  - `docs/knowledge/index.md`
- capability docs 仅在当前任务涉及该能力时加载。
- module docs 仅在 spec 明确依赖时加载。
- `docs/memory/` 为可选项，只用于交接或重建。
- 将 `docs/spec/*.md` 视为状态机，将 `docs/progress.md` 视为状态指针，将 `docs/memory/` 视为支持性快照数据。

## 触发路由摘要

- 新项目 -> `project_init`
- 恢复工作 -> `context_sync`
- 新需求 -> `requirement_probe`
- 设计草案评审 -> `feature_confirm (review)`
- 执行批准 -> `feature_confirm (lock)`
- 代码执行 -> `code_implement_confirm`
- 修复或回退提案 -> `workflow_repair`
- 完成声明 -> `verification_gate`
- 发布 -> `project_release`

## 更新策略

- 将项目事实更新到各自负责的文档中。
- 将 `docs/progress.md` 维护为轻量的活跃状态摘要。
- 重复出现的 lessons 只通过审核后升格为长期知识。
- 默认不创建 `docs/memory/`。

## 规则引用

- `R1`: 规则文件不持有项目事实。
- `R4`: `docs/memory/` 是可选且仅作支持。
- `R13`: `context_sync` 是默认恢复路径。
- `R14`: `session_resume` 是升级路径而不是默认路径。
- `R20`: spec 持有节点状态，`docs/progress.md` 只做摘要。
- `R22`: 关键工作流输出必须展示当前节点和下一步。

## 工具适配策略

- 工具特定规则文件可以扩展 OMS，但不得重定义 source-of-truth 的归属边界。
- 兼容路径必须保持显式且可文档化。

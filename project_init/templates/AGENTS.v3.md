# AGENTS.md
## 治理定位
- 本仓库使用 OMS v3 作为仓库原生治理内核；项目事实保存在仓库文档中；工作流阶段由 spec 状态持有。
## 事实边界
- `docs/context/project_brief.md` 持有项目意图和范围。
- `docs/architecture.md` 持有系统形态和结构约束。
- `docs/spec/*.md` 持有变更范围协议和工作流节点状态。
- `docs/progress.md` 汇总当前活跃状态，并充当当前状态指针。
- `docs/knowledge/index.md` 负责知识加载路由；`docs/lessons.md` 存放活跃纠错；`docs/memory/` 仅作为交接或重建时的可选运行时快照。
## 加载策略
- baseline 读取集合：`AGENTS.md`、`docs/progress.md`、活跃 `docs/spec/*.md`、`docs/architecture.md`、`docs/knowledge/index.md`
- capability docs 与 module docs 按需加载；`docs/memory/` 仅用于交接或重建。
- 将 `docs/spec/*.md` 视为状态机，将 `docs/progress.md` 视为状态指针，将 `docs/memory/` 视为支持性快照数据。
## 触发路由摘要
- 新项目、旧 docs 迁移到 OMS v3、或已有档案重新对账 -> `project_init`
- 恢复工作 -> `context_sync`
- 新需求 -> `requirement_probe`
- 设计草案评审 -> `feature_confirm (review)`；执行批准 -> `feature_confirm (lock)`；代码执行 -> `code_implement_confirm`
- 修复或回退提案 -> `workflow_repair`；完成声明 -> `verification_gate`；发布 -> `project_release`
## 更新策略
- 将项目事实更新到各自负责的文档中；`docs/progress.md` 只做轻量摘要；重复 lessons 经审核后再升格；默认不创建 `docs/memory/`。
## 工具适配策略
- 工具特定规则文件可以扩展 OMS，但不得重定义 source-of-truth 的归属边界；兼容路径必须保持显式且可文档化。

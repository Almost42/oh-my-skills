# AGENTS.md

## 治理定位

- 本仓库使用 OMS v3 作为仓库原生治理内核；项目事实保存在仓库文档中；工作流阶段由 spec 状态持有。

## 事实边界

- `docs/context/project_brief.md` 持有项目意图和范围。
- `docs/architecture.md` 持有系统形态和结构约束。
- `docs/spec/*.md`（single）或 `docs/spec/*/index.md`（multi）持有变更范围协议和工作流节点状态；子文档（`req.md`、`design.md`、`impl.md`）持有对应阶段的详细内容。
- `docs/progress.md` 汇总当前活跃状态，并充当当前状态指针。
- `docs/knowledge/index.md` 负责知识加载路由；`docs/knowledge/lessons/` 存放按类型归类的纠错经验；`docs/memory/` 仅作为交接或重建时的可选运行时快照。

## 加载策略

- baseline 读取集合：`AGENTS.md`、`docs/progress.md`、活跃 spec 状态锚点、`docs/architecture.md`、`docs/knowledge/index.md`
- capability docs 与 module docs 按需加载；lessons 按操作类型精准加载（见 `docs/knowledge/index.md` 的 Lessons 路由）。
- `docs/memory/` 仅用于交接或重建。
- 将 spec 状态锚点视为状态机，将 `docs/progress.md` 视为状态指针，将 `docs/memory/` 视为支持性快照数据。

## Spec 加载规则

- Single-file spec（Patch 类）：`docs/spec/{name}.md` 持有全部内容
- Multi-file spec（Feature 类）：
  - `docs/spec/{name}/index.md` 为状态锚点，持有 frontmatter 和摘要（workflow_guard 只需读此文件）
  - `docs/spec/{name}/req.md` 由 requirement_probe / verification_gate 按需读取
  - `docs/spec/{name}/design.md` 由 feature_plan / feature_confirm 按需读取
  - `docs/spec/{name}/impl.md` 由 code_implement_confirm 按需读取
- 不得使用段落描述替代文件路径引用

## 触发路由摘要

- 新项目、旧 docs 迁移到 OMS v3、或已有档案重新对账 -> `project_init`
- 恢复工作 -> `context_sync`
- 新需求 -> `requirement_probe`
- 设计草案评审 -> `feature_confirm (review)`；执行批准 -> `feature_confirm (lock)`；代码执行 -> `code_implement_confirm`
- 修复或回退提案 -> `workflow_repair`；完成声明 -> `verification_gate`；发布 -> `project_release`

## Skill 宣告

每个 skill 执行时会在输出开头宣告当前使用的 skill，格式为 `[skill_name] 简短说明...`，便于追踪当前工作流阶段。

## 更新策略

- 将项目事实更新到各自负责的文档中；`docs/progress.md` 只做轻量摘要；lessons 按分类写入 `docs/knowledge/lessons/`；重复 lessons 经审核后再升格；默认不创建 `docs/memory/`。

## 工具适配策略

- 工具特定规则文件可以扩展 OMS，但不得重定义 source-of-truth 的归属边界；兼容路径必须保持显式且可文档化。

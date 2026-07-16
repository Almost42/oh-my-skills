# AGENTS.md

## 治理定位

- 本仓库使用 OMS v3 作为仓库原生治理内核；项目事实保存在仓库文档中；工作流阶段由 spec 状态持有。
- OMS 文档正文默认使用中文；路径、代码标识符、API 名称、frontmatter 枚举值和既有英文术语可保留英文。

## 事实边界

- `docs/ai/context/project_brief.md` 持有项目意图和范围。
- `docs/ai/architecture.md` 持有系统形态和结构约束。
- `docs/ai/domain_rules.md` 持有项目级硬约束、禁区与协议规则。
- `docs/ai/spec/index.md` 是 spec 根索引，只简略记录历史需求关注模块、处理方向、日期和状态锚点。
- `docs/ai/spec/YYYY-MM-DD-*.md`（single）或 `docs/ai/spec/YYYY-MM-DD-*/index.md`（multi）持有变更范围协议和工作流节点状态；子文档（`req.md`、`design.md`、`impl.md`）持有对应阶段的详细内容。
- `docs/ai/progress.md` 汇总当前活跃状态，并充当当前状态指针。
- capability docs 只在对应能力成体系时存在，持有能力专属稳定事实与操作约束。
- `docs/ai/knowledge/index.md` 负责 owner 路由；`docs/ai/knowledge/lessons/` 存放按类型归类的短期纠错经验；`docs/ai/memory/` 仅作为交接或重建时的可选运行时快照。
- `docs/ai/history/` 只记录初始化、发布/归档、治理审计等事件摘要；不记录需求正文，也不是 spec 的存放层。

## 加载策略

- baseline 读取集合：`AGENTS.md`、`docs/ai/progress.md`、`docs/ai/spec/index.md`、活跃 spec 状态锚点、`docs/ai/architecture.md`、`docs/ai/knowledge/index.md`
- `docs/ai/domain_rules.md` 与 capability docs 按需加载；lessons 按操作类型精准加载（见 `docs/ai/knowledge/index.md` 的 Lessons 路由）。
- `docs/ai/memory/` 仅用于交接或重建。
- 将 spec 状态锚点视为状态机，将 `docs/ai/progress.md` 视为状态指针，将 `docs/ai/memory/` 视为支持性快照数据。

## Spec 加载规则

- spec 文件或目录名必须包含创建日期，格式为 `YYYY-MM-DD-{slug}`；日期一旦创建不随后续更新改变。
- `docs/ai/spec/index.md` 必须在创建、归档或修订 spec 摘要时同步更新，但不得承载节点真相。
- Single-file spec（Patch 类）：`docs/ai/spec/YYYY-MM-DD-{slug}.md` 持有全部内容
- Multi-file spec（Feature 类）：
  - `docs/ai/spec/YYYY-MM-DD-{slug}/index.md` 为状态锚点，持有 frontmatter 和摘要（workflow_guard 只需读此文件）
  - `docs/ai/spec/YYYY-MM-DD-{slug}/req.md` 由 requirement_probe / verification_gate 按需读取
  - `docs/ai/spec/YYYY-MM-DD-{slug}/design.md` 由 feature_plan / feature_confirm 按需读取
  - `docs/ai/spec/YYYY-MM-DD-{slug}/impl.md` 由 code_implement_confirm 按需读取
- 不得使用段落描述替代文件路径引用

## 触发路由摘要

- 新项目、旧 docs 迁移到 OMS v3、或已有档案重新对账 -> `project_init`
- 文档结构、owner 边界、legacy 输入或外部 AI 规则需要规范化 -> `project_docs_optimize`
- 恢复工作 -> `context_sync`
- 逻辑分析、漏洞排查、日志排障 -> 直接分析相关证据；不创建 spec、不检查节点
- 新需求 -> `requirement_probe`
- 设计草案评审 -> `feature_confirm (review)`；执行批准 -> `feature_confirm (lock)`；代码执行 -> `code_implement_confirm`
- 修复或回退提案 -> `workflow_repair`；完成声明 -> `verification_gate`

## Skill 宣告

每个 skill 执行时会在输出开头宣告当前使用的 skill，格式为 `[skill_name] 简短说明...`，便于追踪当前工作流阶段。

## 更新策略

- 将项目事实更新到各自负责的 owner 文档中；`docs/ai/progress.md` 只做轻量摘要；lessons 先写入 `docs/ai/knowledge/lessons/` 缓冲层，再在收口时决定是否升格到 `docs/ai/domain_rules.md`、`docs/ai/architecture.md` 或 capability docs；默认不创建 `docs/ai/memory/`。
- `docs/ai/context/` 只允许 `project_init` 和 `project_docs_optimize` 写入或重组。
- `docs/ai/history/` 只允许 `project_init` 和 `project_docs_optimize` 写入，`verification_gate (advance)` 追加事件摘要；只记录事件摘要，不记录需求正文。

## 工具适配策略

- 工具特定规则文件可以扩展 OMS，但不得重定义 source-of-truth 的归属边界；兼容路径必须保持显式且可文档化。

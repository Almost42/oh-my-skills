---
name: project_init
description: >-
  在项目接入 OMS v3、旧文档体系迁移或已有档案重新对账时使用，按能力补齐最小必需文档、治理规则和文档槽位。
---

# 项目初始化

OMS v3 的仓库接入与基线对账入口。它既能做冷启动，也能处理旧文档体系迁移和已有 OMS 档案与代码现状的重新对账。

## When to Use

- 用户明确要求初始化项目。
- 仓库缺失 `AGENTS.md` 或 OMS v3 baseline 文档。
- 需要把现有项目纳入 OMS v3。
- 需要把已有文档体系迁移进 OMS v3。
- 已存在 OMS v3 文档，但负责人需要重新扫描代码并补齐结构性事实或进度摘要。

## Modes

### `bootstrap`

- 适用于新项目或缺失 OMS v3 baseline 的仓库。
- 目标是创建最小治理骨架与能力文档槽位。

### `migrate`

- 适用于已有 docs 体系、v2 文档体系或团队自定义文档体系迁入 OMS v3。
- 目标是建立旧文档到 OMS v3 文档的映射，迁入可确认的结构性事实，同时保留原文档。

### `reconcile`

- 适用于仓库已存在 OMS v3 baseline，但代码和文档发生漂移。
- 目标是重新扫描当前代码，补齐 `architecture`、capability docs 与 `progress` 摘要，而不是重跑一次冷启动。

## Instructions

### Step 1: Detect Mode And Scan The Repository
先判断当前应进入哪种 mode：

- 缺失 `AGENTS.md` 或缺失 OMS v3 baseline -> `bootstrap`
- 已有 docs 体系但缺失完整 OMS v3 baseline，或明显存在 v2 / 自定义文档结构 -> `migrate`
- 已有 OMS v3 baseline，且用户意图是“重新扫描代码并刷新档案” -> `reconcile`

随后统一扫描：

识别：

- 项目名称
- 技术栈
- 目录结构
- 依赖与构建工具
- 框架约定
- 是否存在前端、接口、数据、运维、领域规则等能力信号
- 现有 docs 目录与命名方式
- 是否存在 v2 文档或自定义文档结构
- 是否已存在 OMS v3 baseline
- 代码结构与现有文档之间是否存在明显漂移

### Step 2: Create Always-On Structure
默认建立以下最小结构：

```text
docs/
├── context/
├── spec/
├── knowledge/
└── history/
```

默认不创建 `docs/memory/`。只有后续确有交接或重建需要时，才由 `session_archive` / `session_resume` 启用。

### Step 3: Bootstrap Or Fill Missing Always-On Documents
使用本 skill 自带模板生成或补齐：

- `AGENTS.md` <- `project_init/templates/AGENTS.v3.md`
- `docs/context/project_brief.md` <- `project_init/templates/project_brief.v3.md`
- `docs/architecture.md` <- `project_init/templates/architecture.v3.md`
- `docs/progress.md` <- `project_init/templates/progress.v3.md`
- `docs/knowledge/index.md` <- `project_init/templates/knowledge-index.v3.md`
- `docs/history/v0-init.md` <- `project_init/templates/history-entry.v3.md`

规则：

- `bootstrap`
  - 缺失则创建
  - 已存在则不覆盖，提示人工审阅
- `migrate`
  - 缺失则创建
  - 已存在则在保留原文档的前提下补齐 OMS v3 必需槽位
- `reconcile`
  - 不重建骨架
  - 只更新可以从当前仓库稳定确认的结构性事实与摘要性内容

不要因为代码扫描结果而静默改写需求意图、验收标准或 spec 节点确认。

### Step 4: Migrate Or Reconcile Existing Docs Carefully
若 mode 为 `migrate` 或 `reconcile`，需要额外执行：

- 识别旧文档到 OMS v3 文档的映射关系
- 提取可稳定迁移的项目事实、结构事实和能力边界
- 记录无法自动确认、需要人工确认的内容
- 保留原文档，不删除、不静默覆盖

可以迁移或更新的内容：

- 项目简介类信息
- 架构与模块边界
- capability 文档中的稳定规则
- `docs/progress.md` 的摘要性当前状态

不得仅凭代码自动推断的内容：

- 原始需求意图
- 已批准的设计结论
- 验收标准是否被确认
- spec 是否应推进到新的 workflow node

### Step 5: Instantiate Capability Documents
根据扫描结果补建相关文档。能力模板由 `capability_bootstrap/templates/` 提供：

- UI / Client -> `docs/frontend/guidelines.md` <- `capability_bootstrap/templates/frontend-guidelines.v3.md`
- Flow-heavy -> `docs/flows.md` <- `capability_bootstrap/templates/flows.v3.md`
- Interfaces -> `docs/interfaces.md` <- `capability_bootstrap/templates/interfaces.v3.md`
- Data -> `docs/data_model.md` <- `capability_bootstrap/templates/data-model.v3.md`
- Operations -> `docs/operations.md` <- `capability_bootstrap/templates/operations.v3.md`
- Domain Rules -> `docs/domain_rules.md` <- `capability_bootstrap/templates/domain-rules.v3.md`

未检测到的能力不创建文档，只在 `AGENTS.md` 中登记 dormant slots 和触发条件。

若 mode 为 `reconcile` 且发现 capability drift：

- 优先补齐缺失 capability docs
- 必要时把后续动作路由到 `capability_bootstrap`

### Step 6: Merge Tool-Specific Rules Carefully
若仓库存在工具特定规则文件：

- 识别项目约定
- 与 OMS v3 的 source-of-truth 边界对齐
- 保留原文件，不静默覆盖

### Step 7: Decide Next Action
根据结果路由：

- `bootstrap` / `migrate` 完成后默认进入 `context_sync`
- 仅摘要状态过期 -> `progress_sync`
- 发现 capability docs 缺口 -> `capability_bootstrap`
- 发现 spec 与代码现状不闭环 -> `workflow_repair`

### Step 8: Report
输出：

- 当前 `Mode`
- 已创建的 always-on docs
- 已补齐或迁移的 OMS 文档
- 已实例化的 capability docs
- 已登记的 dormant slots
- 检测到的旧文档体系或漂移点
- 是否检测到 tool-specific rules

## Output

```markdown
## Project Init

**Mode**: bootstrap | migrate | reconcile
**Project**: ...
**Detected Stack**:
- ...

**Created Always-On Docs**:
- ...

**Migrated Or Reconciled Docs**:
- ...

**Created Capability Docs**:
- ...

**Dormant Slots**:
- ...

**Drift Findings**:
- ...

**Memory Mode**: not enabled by default
**Next Action**: `context_sync` | `progress_sync` | `capability_bootstrap` | `workflow_repair`
```

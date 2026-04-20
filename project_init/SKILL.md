---
name: project_init
description: >-
  在项目接入 OMS v3、旧文档体系迁移或已有档案重新对账时使用，按能力补齐最小必需文档、治理规则和文档槽位。
---

# 项目初始化

OMS v3 的仓库接入与基线对账入口。支持冷启动、旧文档体系迁移和已有档案重新对账。

**执行时宣告**："[project_init] 初始化/迁移/对账项目文档..."

## When to Use

- 仓库缺失 `AGENTS.md` 或 OMS v3 baseline 文档。
- 需要把现有项目或旧文档体系纳入 OMS v3。
- 已存在 OMS v3 文档，但需要重新扫描代码补齐结构性事实或进度摘要。

## Modes

- `bootstrap`：新项目或缺失 OMS v3 baseline 的仓库，创建最小治理骨架。
- `migrate`：已有 docs 体系迁入 OMS v3，建立映射，保留原文档。
- `reconcile`：已存在 OMS v3 baseline，重新扫描代码补齐漂移，不重跑冷启动。

## Instructions

### Step 1: Detect Mode And Scan

判断 mode（缺 baseline → `bootstrap`；有旧 docs 结构 → `migrate`；已有 OMS v3 但漂移 → `reconcile`），扫描识别：技术栈、目录结构、能力信号（前端/接口/数据/运维/领域规则）、现有 docs 与 OMS v3 的差距、`AGENTS.md` 是否过长。

### Step 2: Create Always-On Structure

默认建立：`docs/context/`、`docs/spec/`、`docs/knowledge/`、`docs/history/`。不创建 `docs/memory/`（可选，按需启用）。
`docs/spec/index.md` 必须存在，用于按日期回溯历史需求关注的模块和处理方向；它是检索索引，不是节点真相。

### Step 3: Bootstrap Or Fill Missing Always-On Documents

使用本 skill 自带模板生成或补齐：

| 目标文件 | 模板 |
| :--- | :--- |
| `AGENTS.md` | `project_init/templates/AGENTS.v3.md` |
| `docs/context/project_brief.md` | `project_init/templates/project_brief.v3.md` |
| `docs/architecture.md` | `project_init/templates/architecture.v3.md` |
| `docs/progress.md` | `project_init/templates/progress.v3.md` |
| `docs/spec/index.md` | `project_init/templates/spec-root-index.v3.md` |
| `docs/knowledge/index.md` | `project_init/templates/knowledge-index.v3.md` |
| `docs/history/v0-init.md` | `project_init/templates/history-entry.v3.md` |

`bootstrap`：缺失则创建，已存在则不覆盖。`migrate`：缺失则创建，已存在则重写为最新 v3 结构（保留原文档事实）。`reconcile`：不重建骨架，只做规范收敛和内容更新。

不得因代码扫描结果而静默改写需求意图、验收标准或 spec 节点确认。

### Step 4: Normalize Existing Always-On Docs

`migrate` 或 `reconcile` 时，先检查基础文档是否符合 v3 规范。详细规范要求见 `project_init/references/normalize-docs.md`。

核心要求：`AGENTS.md` 超过 50 行时压缩重写；`docs/progress.md` 保持 summary-only；`docs/spec/index.md` 只保留 spec 检索摘要；各文档不混入非职责内容。
OMS 文档正文默认使用中文；路径、代码标识符、API 名称、frontmatter 枚举值和既有英文术语可保留英文。

### Step 5: Migrate Or Reconcile Existing Docs

`migrate` 或 `reconcile` 时：识别旧文档到 OMS v3 的映射，提取可稳定迁移的结构事实，记录无法自动确认的内容，保留原文档。

可迁移：项目简介、架构边界、capability 稳定规则、progress 当前状态、AGENTS 有效治理规则。
不得推断：原始需求意图、已批准设计结论、验收标准确认状态、spec 节点状态。

### Step 5.5: Migrate Legacy Lessons And Normalize Spec Structure

无论哪种 mode 都执行。详细操作见 `project_init/references/lessons-migration.md`。

**Lessons**：若 `docs/lessons.md` 存在且 `docs/knowledge/lessons/` 为空，按分类迁移后删除原文件。
**Spec**：扫描 `docs/spec/`，同步或补建 `docs/spec/index.md`；标记无日期前缀的 spec，并按 `Created` frontmatter 或可确认日期改为 `YYYY-MM-DD-{slug}`，无法确认日期时报告并等待用户确认；标记超过 150 行的单文件 spec 为"建议拆分"。

### Step 6: Instantiate Capability Documents

按扫描结果补建（模板来自 `capability_bootstrap/templates/`）：

| 能力信号 | 目标文件 |
| :--- | :--- |
| UI / Client | `docs/frontend/guidelines.md` |
| Flow-heavy | `docs/flows.md` |
| Interfaces | `docs/interfaces.md` |
| Data | `docs/data_model.md` |
| Operations | `docs/operations.md` |
| Domain Rules | `docs/domain_rules.md` |

未检测到的能力只在 `AGENTS.md` 中登记 dormant slots，不创建文档。`reconcile` 发现 capability drift 时路由到 `capability_bootstrap`。

### Step 7: Merge Tool-Specific Rules

若存在工具特定规则文件：识别项目约定，与 OMS v3 source-of-truth 边界对齐，保留原文件不静默覆盖。

### Step 8: Decide Next Action And Report

路由：`bootstrap`/`migrate` 完成 → `context_sync`；摘要过期 → `progress_sync`；capability 缺口 → `capability_bootstrap`；spec 不闭环 → `workflow_repair`。

## Output

```markdown
## Project Init

**Mode**: bootstrap | migrate | reconcile
**Project**: ...
**Detected Stack**: ...

**Created Always-On Docs**: ...
**Normalized Docs**: ...
**Migrated Or Reconciled Docs**: ...
**Created Capability Docs**: ...
**Dormant Slots**: ...
**Drift Findings**: ...

**Lessons Migration**: completed | already classified | no legacy file
**Spec Structure**: all single-file | mixed | all multi-file | needs split recommendation

**Memory Mode**: not enabled by default
**Next Action**: `context_sync` | `progress_sync` | `capability_bootstrap` | `workflow_repair`
```

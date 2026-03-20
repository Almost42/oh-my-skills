---
name: project_init
description: >-
  用于新项目接入 OMS v3，按能力生成最小必需文档、治理规则和文档槽位，而不是套用固定模板。
---

# Project_init

OMS v3 的冷启动器。它负责建立治理内核，而不是一次性生成一套与项目无关的大而全模板。

## When to Use

- 用户明确要求初始化项目。
- 仓库缺失 `AGENTS.md` 或 OMS v3 baseline 文档。
- 需要把现有项目纳入 OMS v3。

## Instructions

### Step 1: Scan The Repository
识别：

- 项目名称
- 技术栈
- 目录结构
- 依赖与构建工具
- 框架约定
- 是否存在前端、接口、数据、运维、领域规则等能力信号

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

### Step 3: Create Always-On Documents From Templates
使用本 skill 自带模板生成：

- `AGENTS.md` <- `project_init/templates/AGENTS.v3.md`
- `docs/context/project_brief.md` <- `project_init/templates/project_brief.v3.md`
- `docs/architecture.md` <- `project_init/templates/architecture.v3.md`
- `docs/progress.md` <- `project_init/templates/progress.v3.md`
- `docs/knowledge/index.md` <- `project_init/templates/knowledge-index.v3.md`
- `docs/history/v0-init.md` <- `project_init/templates/history-entry.v3.md`

若文件已存在，不覆盖，改为提示人工审阅。

### Step 4: Instantiate Capability Documents
根据扫描结果补建相关文档。能力模板由 `capability_bootstrap/templates/` 提供：

- UI / Client -> `docs/frontend/guidelines.md` <- `capability_bootstrap/templates/frontend-guidelines.v3.md`
- Flow-heavy -> `docs/flows.md` <- `capability_bootstrap/templates/flows.v3.md`
- Interfaces -> `docs/interfaces.md` <- `capability_bootstrap/templates/interfaces.v3.md`
- Data -> `docs/data_model.md` <- `capability_bootstrap/templates/data-model.v3.md`
- Operations -> `docs/operations.md` <- `capability_bootstrap/templates/operations.v3.md`
- Domain Rules -> `docs/domain_rules.md` <- `capability_bootstrap/templates/domain-rules.v3.md`

未检测到的能力不创建文档，只在 `AGENTS.md` 中登记 dormant slots 和触发条件。

### Step 5: Merge Tool-Specific Rules Carefully
若仓库存在工具特定规则文件：

- 识别项目约定
- 与 OMS v3 的 source-of-truth 边界对齐
- 保留原文件，不静默覆盖

### Step 6: Report
输出：

- 已创建的 always-on docs
- 已实例化的 capability docs
- 已登记的 dormant slots
- 是否检测到 tool-specific rules

## Output

```markdown
## Project Init

**Project**: ...
**Detected Stack**:
- ...

**Created Always-On Docs**:
- ...

**Created Capability Docs**:
- ...

**Dormant Slots**:
- ...

**Memory Mode**: not enabled by default
**Next Action**: `context_sync`
```

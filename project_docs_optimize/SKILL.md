---
name: project_docs_optimize
description: 在 OMS 文档结构与当前规范不匹配、需要先分析再确认执行文档收敛时使用；统一承担兼容迁移、结构重组、规则导入和 owner 对齐。
---

# 项目文档收敛

OMS v3.1 的文档治理器。它统一处理 legacy 结构、OMS 规范漂移、AI 规则导入和 owner-first 重构。

**执行时宣告**："[project_docs_optimize] 分析/收敛项目文档..."

## Modes

- `analyze`：扫描 docs 结构、规则来源和 owner 漂移，只输出调整报告
- `apply`：仅在用户明确确认后执行迁移、重组、重写结构和 owner 同步

## When to Use

- `project_init` 发现文档结构不符合当前 OMS 规范。
- 需要把 legacy docs、旧 lessons、旧知识分层或工具规则迁入 owner-first 结构。
- 需要分析并导入 `CLAUDE.md`、`.cursor/`、`.claude/`、`.codex/` 等外部 AI 规则来源。

## Iron Law

```
先报告，后执行。
可以重组文档结构，但不得静默删除信息。
```

## Never

- Never 在 `analyze` mode 写入或删除任何项目文档
- Never 未经用户确认直接删除 legacy 文件
- Never 把长期规则继续写回 `pitfalls`、`anti-patterns` 或泛化 knowledge 大层

## Instructions

### Step 1: Inventory Current Owners And Drift

扫描：

1. `AGENTS.md`
2. `docs/ai/architecture.md`
3. `docs/ai/progress.md`
4. `docs/ai/spec/`
5. `docs/ai/knowledge/index.md`
6. `docs/ai/knowledge/lessons/`
7. `docs/ai/domain_rules.md`
8. capability docs（若存在）
9. 外部 AI 规则来源：`CLAUDE.md`、`.claude/`、`.cursor/`、`.cursor/rules/`、`.codex/`、`docs/ai/` 下 AI/rules/prompt/agent 文件、常见自定义规则目录

识别：

- owner 缺失、职责混杂、重复知识、旧结构残留
- 仍在使用 `docs/ai/lessons.md`、`docs/ai/pitfalls.md`、`docs/ai/anti-patterns.md`
- spec/index/progress/AGENTS 是否符合当前 OMS 规范
- 区分 drift 来源（参考 `references/old-oms-signatures.md` 指纹表）：
  - 命中指纹 → 旧 OMS 遗留，适用批量重组
  - 匹配外部工具路径（CLAUDE.md、.cursor/、.claude/、.codex/）→ 外部工具规则，适用指针文件
  - 未命中 → 未识别来源，需用户确认处置方式

### Step 2: Build A Developer-Facing Adjustment Report

输出至少包含：

- 收敛结论
- 当前是否建议立即执行整理
- 本次是否已修改文档
- 结构偏移与 legacy 输入
- 导入的规则来源
- 建议的 owner 映射
- 涉及变更的文件
- 后续可手动清理或归档的文件

若是 `analyze` mode，到此停止并等待用户确认。

### Step 3: Apply Confirmed Changes

仅在 `apply` mode 且用户已确认后执行：

- 补建缺失 owner 文件
- 将内容迁入 `AGENTS.md` / `architecture.md` / `domain_rules.md` / capability docs / lessons
- 若项目背景散落在其他文档中，收敛到 `docs/ai/context/project_brief.md`
- 重写 `docs/ai/knowledge/index.md` 为 owner-first 路由器
- 同步 `docs/ai/spec/index.md` 和 always-on 文档结构
- 生成或更新导入审计：`docs/ai/history/ai-rules-import-YYYY-MM-DD.md`

`docs/ai/context/` 只允许在这里或 `project_init` 中被写入/重组。
`docs/ai/history/` 只允许记录初始化、发布/归档或治理审计等事件摘要，不记录需求正文。

**旧 OMS 遗留 → 批量重组**（按 Step 1 来源分类执行）：

- docs/ 下命中指纹的文件整体移入 docs/ai/，不逐文件语义分析
- 特殊处理：旧版 `lessons.md` 拆入分类文件，spec 无日期前缀则补齐 `YYYY-MM-DD-`
- 不生成指针文件，原路径直接清理

**指针文件策略**（仅外部工具规则）：

- **不删除原始规则文件**。对于 `CLAUDE.md`、`.claude/*`、`.cursor/rules/*.mdc`、`.codex/*` 等已成功迁入 OMS owner 的外部规则文件，执行以下操作：
  1. 清空原文件内容
  2. 写入指针注释，指向 OMS 体系中的新位置：

```
<!-- 项目规则已迁移至 docs/ai/ 体系，请参见 AGENTS.md -->
<!-- 或如有更精确的迁移目标，指向具体文件：docs/ai/domain_rules.md、docs/ai/architecture.md 等 -->
```

- **保留原文件路径**：确保即使 OMS skill 未被触发，CLI/IDE 仍能通过原始路径上的指针文件发现最新规则位置。
- 在输出报告和"手动清理建议"中说明已生成指针文件。

## Output

```markdown
## 项目文档收敛结果

**本轮模式**: 仅分析（analyze） | 已执行整理（apply）
**收敛结论**: 当前存在结构偏移，建议先确认整理方案 | 已按确认结果完成收敛
**当前是否建议立即执行整理**: 建议先确认后执行 | 已执行完成，无需再次整理
**本次是否已修改文档**: 否，本次仅输出分析报告 | 是，已按确认结果完成调整

**结构偏移与 legacy 输入**:
- （旧 OMS 遗留）...
- （外部工具规则）...
- （未识别来源）...

**导入的规则来源**:
- ...

**建议的 Owner 映射**:
- ...

**涉及变更的文件**:
- ...

**手动清理建议**:
- ...
（迁移外部规则后，列出已生成的指针文件及其指向）

**是否需要用户确认**: 是 | 否
**下一步建议**: 请先确认是否按上述方案执行整理（`project_docs_optimize apply`） | 已完成收敛，可重新执行初始化扫描（`project_init`） | 已可继续恢复项目上下文（`context_sync`）
```

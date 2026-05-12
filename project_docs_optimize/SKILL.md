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
2. `docs/architecture.md`
3. `docs/progress.md`
4. `docs/spec/`
5. `docs/knowledge/index.md`
6. `docs/knowledge/lessons/`
7. `docs/domain_rules.md`
8. capability docs（若存在）
9. 外部 AI 规则来源：`CLAUDE.md`、`.claude/`、`.cursor/`、`.cursor/rules/`、`.codex/`、`docs/` 下 AI/rules/prompt/agent 文件、常见自定义规则目录

识别：

- owner 缺失、职责混杂、重复知识、旧结构残留
- 仍在使用 `docs/lessons.md`、`docs/pitfalls.md`、`docs/anti-patterns.md`
- spec/index/progress/AGENTS 是否符合当前 OMS 规范
- 哪些外部规则应迁入 `AGENTS.md`、`architecture.md`、`domain_rules.md`、capability docs 或 lessons

### Step 2: Build An Executable Adjustment Report

输出至少包含：

- `Drift Findings`
- `Legacy Inputs`
- `Imported Rule Sources`
- `Proposed Owner Mapping`
- `Files To Create / Rewrite / Move`
- `Files Safe To Archive Or Manually Delete Later`

若是 `analyze` mode，到此停止并等待用户确认。

### Step 3: Apply Confirmed Changes

仅在 `apply` mode 且用户已确认后执行：

- 补建缺失 owner 文件
- 将内容迁入 `AGENTS.md` / `architecture.md` / `domain_rules.md` / capability docs / lessons
- 若项目背景散落在其他文档中，收敛到 `docs/context/project_brief.md`
- 重写 `docs/knowledge/index.md` 为 owner-first 路由器
- 同步 `docs/spec/index.md` 和 always-on 文档结构
- 生成或更新导入审计：`docs/history/ai-rules-import-YYYY-MM-DD.md`

`docs/context/` 只允许在这里或 `project_init` 中被写入/重组。
`docs/history/` 只允许记录初始化、发布/归档或治理审计等事件摘要，不记录需求正文。

legacy 文件默认保留；只有用户明确同意时，才将其标记为可删除或执行删除。

## Output

```markdown
## 项目文档收敛结果

**模式**: analyze | apply
**漂移发现**:
- ...

**导入的规则来源**:
- ...

**建议的 Owner 映射**:
- ...

**涉及变更的文件**:
- ...

**手动清理建议**:
- ...

**是否需要用户批准**: yes | no
**下一步动作**: confirm apply | `project_init` | `context_sync`
```

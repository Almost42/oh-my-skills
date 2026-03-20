---
name: session_resume
description: >-
  仅在 baseline 文档不足以恢复上下文时调用，作为 OMS v3 的 escalation 路径读取和利用可选 memory 存档。
---

# Session_resume

这是 OMS v3 的 escalation 路径，不是默认恢复入口。只有 `context_sync` 判断 baseline 不足，或用户明确要求深度恢复时，才应该进入这里。

## When to Use

- `context_sync` 明确判断 baseline 文档不足。
- 用户明确要求恢复长会话交接信息。
- 项目已经启用了 `docs/memory/`，且当前问题确实依赖历史推理链。

## Instructions

### Step 1: Confirm Escalation Need
先确认：

- 为什么 baseline 不足
- 需要恢复的是哪些缺失信息
- 是否真的需要读取 `docs/memory/`

### Step 2: Read Optional Archive Layer
若 `docs/memory/` 存在，则读取：

- `memory_active.md`（若存在）
- 相关 `session_*.md` 散档

若 `docs/memory/` 不存在，则明确告知：当前项目未启用 memory，改用 baseline 文档继续工作。

### Step 3: Reconstruct Missing Context
补齐：

- 缺失的决策背景
- 长交接中的待办
- 与当前 active spec 相关的历史说明

### Step 4: Optional Consolidation
仅当项目已经启用 `docs/memory/` 且确有必要时，才整理或更新 `memory_active.md`。不要把 memory 重新变成默认 active-state 来源。

### Step 5: Report
明确说明：

- 这次为什么需要 escalation
- 从 memory 中补回了什么
- 现在应回到哪个 skill

## Output

```markdown
## Session Resume

**Escalation Reason**: ...
**Memory Enabled**: yes | no
**Recovered Context**:
- ...

**Active Specs**:
- ...

**Next Action**: ...
```

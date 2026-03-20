---
name: session_archive
description: >-
  在需要跨会话或跨工具交接时调用，生成可选 handoff 快照；它不是 OMS v3 的默认工作状态维护机制。
---

# Session_archive

OMS v3 的会话交接器。它只在确有 handoff 价值时创建 memory 快照，不承担默认 active-state 维护职责。

## When to Use

- 对话上下文接近上限。
- 用户明确要求保存交接信息。
- 需要跨工具、跨模型或跨会话继续工作。

## Instructions

### Step 1: Confirm Archive Need
先判断是否真的需要 archive：

- baseline 文档是否已经足够
- 当前交接是否依赖大量会话级推理
- 是否值得启用 `docs/memory/`

### Step 2: Enable Memory Only If Needed
若项目尚未启用 `docs/memory/`，且当前确有交接需求，则此时再创建。

### Step 3: Write Handoff Snapshot
创建 `session_YYYYMMDD-HHMM_<topic>.md`，记录：

- 当前代码状态摘要
- 关键决策
- 待办
- 风险与注意事项

### Step 4: Review Knowledge Candidates
若会话中出现值得升格的经验，交给 `knowledge_review` 进入审核流程。

### Step 5: Report
明确说明：

- 是否启用了 memory
- 写入了哪个 archive
- 下次应优先走 `context_sync`，只有不足时再走 `session_resume`

## Output

```markdown
## Session Archive

**Memory Enabled**: yes | no
**Archive File**: ...
**Related Specs**:
- ...

**Next Action**: `context_sync` first, `session_resume` only if needed
```

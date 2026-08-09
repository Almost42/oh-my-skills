---
name: session_archive
description: >-
  在需要跨会话或跨工具交接时使用，生成可选 handoff 快照；它不是 OMS v3 的默认工作状态维护机制。
---

# 会话归档

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
- 是否值得启用 `docs/ai/memory/`

### Step 2: Enable Memory Only If Needed
若项目尚未启用 `docs/ai/memory/`，且当前确有交接需求，则此时再创建。

### Step 3: Write Handoff Snapshot
创建 `session_YYYYMMDD-HHMM_<topic>.md`，记录：

- 当前代码状态摘要
- 关键决策
- 待办
- 风险与注意事项

### Step 4: Review Reusable Lessons
若会话中出现可复用经验，先由 `lesson_capture` 写入对应 lessons 条目，再调用 `knowledge_review(auto)`；低风险经验可自动固化，高风险或冲突经验保留为“待继续验证”或“冲突待处理”，不因用户未响应而丢失。

### Step 5: Report
明确说明：

- 是否启用了 memory
- 写入了哪个 archive
- 下次应优先走 `context_sync`，只有不足时再走 `session_resume`

## Output

```markdown
## 会话归档结果

**是否启用 Memory**: 是 | 否
**归档文件**: ...
**关联 Specs**:
- ...

**下一步建议**: 下次继续工作时先恢复项目上下文（`context_sync`），只有不足时再使用会话恢复（`session_resume`）
```

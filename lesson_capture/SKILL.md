---
name: lesson_capture
description: Use when a correction should be captured as an active rule in docs/lessons.md before any durable knowledge promotion is considered.
---

# Lesson_capture

OMS v3 的纠错落点。它只写 `docs/lessons.md`，不直接把临时修正升格为长期知识。

## When to Use

- 用户纠正了 agent 的理解、方案或行为。
- 某类错误重复出现，需要形成可执行规则。
- 一次实现偏差暴露出项目特定约束、偏好或禁区。

## Instructions

### Step 1: Capture The Correction
记录：

- 发生上下文
- 错误表现
- 正确做法
- 以后应遵循的简洁规则

### Step 2: Write Only To `docs/lessons.md`

- 只把内容追加到 `docs/lessons.md`
- 不要直接写入 durable knowledge
- 若文件不存在，可首次创建

### Step 3: Recommend Promotion Later
若这条 lesson 已经稳定、重复或具备长期价值：

- 明确建议后续走 `knowledge_review`
- 由 `knowledge_review` 决定 promotion，而不是在这里直接 promotion

## Output

```markdown
## Lesson Captured

**Context**: ...
**Correction**: ...
**Actionable Rule**: ...
**Suggested Next Action**: `knowledge_review` | none
```

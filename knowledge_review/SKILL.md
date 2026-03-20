---
name: knowledge_review
description: 在 lessons 或会话候选可能需要升格为长期知识时使用，整理可供用户审核的升格提案。
---

# 知识升格审核

OMS v3 的知识 promotion 审核器。它负责整理候选、草拟 promotion 提案，并在用户批准前停止。

## When to Use

- `lesson_capture` 产生了可能升格的经验。
- `session_archive` 留下了值得保留的会话候选。
- `project_release` 需要做版本级知识审查。

## Instructions

### Step 1: Collect Promotion Candidates
候选来源可以包括：

- `docs/lessons.md`
- session candidates
- 当前活跃 spec 与验证结果
- 已有 `docs/knowledge/...`

迁移期间允许补充读取：

- `docs/pitfalls.md`
- `docs/anti-patterns.md`

它们是 compatibility inputs，用于避免遗漏历史知识。

### Step 2: Classify The Promotion Target
把候选分为：

- `pitfalls`
- `anti-patterns`
- 暂不 promotion，继续留在 `docs/lessons.md`

### Step 3: Draft A Reviewable Promotion Proposal
每个 promotion 提案至少写清楚：

- 候选内容
- 来源
- 建议目标文件
- promotion 理由
- 若不 promotion 的原因

### Step 4: Wait For User Approval

- 用户未批准前，不得执行 promotion
- 只输出可审阅提案

### Step 5: Apply Approved Promotion
用户确认后，再把通过的条目写入：

- `docs/knowledge/pitfalls/...`
- `docs/knowledge/anti-patterns/...`

## Output

```markdown
## Knowledge Review

**Promotion Candidates**:
- ...

**Proposed Targets**:
- `docs/knowledge/pitfalls/...`
- `docs/knowledge/anti-patterns/...`

**Needs User Approval**: yes
**Next Action**: approve promotion | revise proposal
```

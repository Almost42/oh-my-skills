---
name: knowledge_review
description: 在 lessons 或会话候选需要分流到 owner-first 长期文档时使用，整理可供用户审核的收口提案。
---

# 知识升格审核

OMS v3.1 的收口审核器。它负责把 lessons 和会话候选分流到长期 owner，或决定继续保留/淘汰。

## When to Use

- `lesson_capture` 产生了可能升格的经验。
- `session_archive` 留下了值得保留的会话候选。
- `project_release` 需要做版本级知识审查。

## Instructions

### Step 1: Collect Candidates
候选来源可以包括：

- `docs/knowledge/lessons/*`
- session candidates
- 当前活跃 spec 与验证结果
- 已有 owner 文档（`docs/domain_rules.md`、`docs/architecture.md`、capability docs）

若发现旧知识层、legacy lessons 或职责混杂，先建议 `project_docs_optimize`，不要在此处承担重构。

### Step 2: Decide The Owner Outcome
每条候选必须进入以下之一：

- `keep in lessons`
- `merge with existing lesson`
- `promote to docs/domain_rules.md`
- `promote to docs/architecture.md`
- `promote to capability doc`
- `drop as one-off`

### Step 3: Draft A Reviewable Proposal
每个提案至少写清楚：

- 候选内容
- 来源
- 建议目标文件
- 收口理由
- 若保持在 lessons 或淘汰的原因

### Step 4: Wait For User Approval

- 用户未批准前，不得执行 promotion
- 只输出可审阅提案

### Step 5: Apply Approved Promotion
用户确认后，再把通过的条目写入明确 owner：

- `docs/domain_rules.md`
- `docs/architecture.md`
- 对应 capability doc

## Output

```markdown
## 知识收口提案

**候选条目**:
- ...

**Owner 决策**:
- keep in lessons | merge with existing lesson | promote to `docs/domain_rules.md` | promote to `docs/architecture.md` | promote to capability doc | drop as one-off

**是否需要用户批准**: yes
**下一步动作**: approve promotion | revise proposal | `project_docs_optimize`
```

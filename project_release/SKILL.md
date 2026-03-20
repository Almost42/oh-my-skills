---
name: project_release
description: 在已完成的 active specs 需要版本级归档、知识审核和最终文档一致性检查时使用。
---

# 项目发布归档

OMS v3 的版本封板器。release 是唯一的版本级 archival gate。

## When to Use

- 一批 active specs 已经完成，需要正式归档。
- 用户要求发布、定版、归档里程碑。
- 需要做版本级知识审查与文档一致性检查。

## Instructions

### Step 1: Confirm Release Scope
读取：

- 活跃 specs
- `docs/progress.md`
- `docs/history/`
- `docs/architecture.md`
- 相关 lessons / knowledge candidates

### Step 2: Run The Release Gate
release 必须统一完成：

- archive specs
- 更新 history
- 触发 `knowledge_review`
- 清理陈旧 archive state
- 检查文档是否与当前代码结构一致

### Step 3: Archive Specs Explicitly

- 把本次纳入发布的 spec 转到 `Archived`
- 明确记录哪些 spec 被 archive specs
- 不要跳过 spec 归档直接宣布发布完成

### Step 4: Validate Architecture And Docs
至少检查：

- `docs/architecture.md` 是否仍反映当前结构
- `AGENTS.md`、`docs/progress.md`、`docs/knowledge/index.md` 是否仍一致
- 是否存在需要通过 `workflow_repair` 暂停发布的问题

### Step 5: Report The Release State
若仍有未解决问题，不要假装发布完成。

## Output

```markdown
## Project Release

**Current Node**: Archived
**Archived Specs**:
- ...

**Knowledge Review**:
- ...

**Architecture Check**:
- ...

**Next Action**: complete release | `workflow_repair`
```

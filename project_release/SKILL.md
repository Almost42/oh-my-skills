---
name: project_release
description: 在已完成的 active specs 需要版本级归档、lessons 收口和最终文档一致性检查时使用。
---

# 项目发布归档

OMS v3 的版本封板器。release 是唯一的版本级 archival gate。

## When to Use

- 一批 active specs 已经完成，需要正式归档。
- 用户要求发布、定版、归档里程碑。
- 需要做版本级 lessons 收口与文档一致性检查。
- 需要判断是否存在值得抽取为团队 skill 的重复工作流。

## Instructions

### Step 1: Confirm Release Scope
读取：

- 活跃 specs
- `docs/progress.md`
- `docs/history/`
- `docs/architecture.md`
- 相关 lessons / owner candidates
- `.skillshare/skills/`（若存在，用于盘点当前团队 skill）

### Step 2: Run The Release Gate
release 必须统一完成：

- archive specs
- 更新 `docs/history/` 事件摘要
- 触发 `knowledge_review`
- 评估是否存在 skill extraction candidates，并在报告中附带建议
- 清理陈旧 archive state
- 检查文档是否与当前代码结构一致

### Step 3: Archive Specs Explicitly

- 把本次纳入发布的 spec 转到 `Archived`
- 明确记录哪些 spec 被 archive specs
- 在 `docs/history/` 中记录本次发布/归档事件的摘要、知识收口结果与未完成后续事项
- 不要跳过 spec 归档直接宣布发布完成

### Step 4: Validate Architecture And Docs
至少检查：

- `docs/architecture.md` 是否仍反映当前结构
- `AGENTS.md`、`docs/progress.md`、`docs/knowledge/index.md` 是否仍一致
- 是否存在需要通过 `workflow_repair` 暂停发布的问题

### Step 5: Suggest Skill Extraction When Appropriate

若本次定版中出现以下信号，应在输出报告中附带建议：

- 同一类 workflow 在多个 spec / 多个版本中重复出现
- 某流程每次都要读取同一组文档并遵循固定顺序
- 某些 guardrail、坑点或边界约束已经稳定

此时不要由 `project_release` 自动生成 skill，而是建议后续执行独立的 `project_skill_extract`。

### Step 6: Report The Release State
若仍有未解决问题，不要假装发布完成。

## Output

```markdown
## 项目发布结果

**当前节点**: 已归档（Archived）
**已归档 Specs**:
- ...

**Lessons 收口审查**:
- ...

**架构检查**:
- ...

**技能提取建议**:
- 建议后续提取团队 Skill（`project_skill_extract`） | 暂无技能提取建议

**下一步建议**: 本次定版已完成，可继续下一轮需求工作 | 当前仍有问题，建议先修复流程（`workflow_repair`）
```

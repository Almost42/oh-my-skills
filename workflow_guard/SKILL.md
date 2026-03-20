---
name: workflow_guard
description: >-
  在任何重要动作开始前使用，识别当前用户意图、当前节点和缺失门禁，并路由到正确的 OMS v3 skill。
---

# 工作流守卫

OMS v3 的第一入口。它负责先判断“现在该走哪条链路”，而不是直接开始改文档或写代码。

## When to Use

- 新对话开始时。
- 用户提出新需求、补丁、继续开发、开始实现、修复问题、发布版本。
- AI 在执行任何重要动作前，需要确认当前节点和缺失门禁。

## Instructions

### Step 1: Read Minimum Context
优先读取：

1. `AGENTS.md`
2. `docs/progress.md`
3. 活跃 `docs/spec/*.md`
4. `docs/architecture.md`
5. `docs/knowledge/index.md`

### Step 2: Identify Intent
将当前请求归类为以下之一：

- 新项目初始化 -> `project_init`
- 恢复上下文 -> `context_sync`
- 新需求或补丁需求 -> `requirement_probe`
- 发现新能力、缺失 capability docs、或代码结构长出新的 frontend/API/data/ops/domain concern -> `capability_bootstrap`
- Draft 方案评审 -> `feature_confirm` (`review`)
- 执行包已确认 -> `feature_confirm` (`lock`)
- 已批准的实现开始落地 -> `code_implement_confirm`
- 发现需求/设计/验证不闭环 -> `workflow_repair`
- 声称完成或修复 -> `verification_gate`
- 发布 -> `project_release`

若识别为补丁需求，默认仍先进入 `requirement_probe`，并明确标注 `Scope: Patch`。

### Step 3: Check Gates
检查是否缺少前置门禁：

- 是否存在对应 spec
- 当前 spec 是否处于正确节点
- 是否仍处于 `DesignDraft`
- 是否已有执行包批准
- 当前任务是否暴露了新的 capability signal，但对应文档尚未建立
- 是否应该先修复而非继续前进

### Step 4: Route
若检测到 new capability growth 或 capability docs 缺口，应优先建议 `capability_bootstrap`，并明确需要补建或同步的文档。

输出当前节点、建议 skill、需要读取的文档、缺失门禁和下一步动作。

## Output

```markdown
## Workflow State

**Current Spec**: ...
**Current Node**: ...
**Detected Intent**: ...
**Suggested Skill**: ...
**Required Docs**:
- ...

**Missing Gates**:
- ...

**Next Action**: ...
```

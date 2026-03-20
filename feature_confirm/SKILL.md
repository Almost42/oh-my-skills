---
name: feature_confirm
description: 在 DesignDraft spec 需要评审实施包或在进入 ReadyForImplementation 前做最终锁定时使用。
---

# 方案确认与锁定

OMS v3 中，设计确认和实施方案确认在这里合并处理。它不是单向闸门，而是一个可重复进入的节点操作器。

## When to Use

- 用户要审阅某个 `DesignDraft` 的实施方案。
- 用户已经看过方案，准备锁定执行包。
- 旧的独立实施方案评审场景。

## Modes

### `review`

- 验证 spec 是否足够支撑实施
- 生成 execution package
- 保持节点在 `DesignDraft`
- 不开始代码实现

### `lock`

- 仅在用户明确批准 execution package 后执行
- 将节点推进到 `ReadyForImplementation`
- 记录最近一次确认节点
- 标记 execution package 已获批准

## Instructions

### Step 1: Read The Active Design Context
读取：

1. 目标 `docs/spec/*.md`
2. `docs/architecture.md`
3. 与该 spec 相关的 capability docs
4. `docs/knowledge/index.md` 路由到的相关知识
5. 相关活跃 specs

若当前 spec 不是 `DesignDraft`，不要硬套当前流程，改为说明当前节点并路由到正确 skill。

### Step 2: Run `review` Mode
在 `review` mode 中必须产出：

- change tree
- impact view
- risk view
- rollback planning
- required doc updates
- active-spec conflict notes

如果 `Scope: Patch`，额外明确：

- patch path
- 改动边界
- 为什么这是 patch 而不是 feature

`review` mode 的结果只能是：

- `stay`
  - spec 继续停留在 `DesignDraft`
- `repair_required`
  - 发现需求或设计本身不成立，转到 `workflow_repair`

### Step 3: Run `lock` Mode
只有在用户明确批准后，`lock` mode 才能执行：

- `Status: Draft` -> `Status: Active`
- `Current_Node: DesignDraft` -> `Current_Node: ReadyForImplementation`
- `Last_Confirmed_Node` 记录为 `DesignDraft`
- 必要时同步 `docs/architecture.md` 和相关 capability docs

`lock` mode 的结果只能是：

- `advance`
  - 进入 `ReadyForImplementation`
- `repair_required`
  - 若用户在锁定前指出设计缺口，转到 `workflow_repair`

### Step 4: Handle Re-Entry And Rollback Correctly
这个 skill 可以多次执行。

若发生以下情况：

- 用户看完实施方案后不满意
- 用户在 `code_implement_confirm` 后对结果不满意，并追溯到最初设计缺口
- 当前上下文其实是在补齐设计方案，而不是继续前进

则不要静默“重新确认”或偷偷改 spec。必须：

1. 明确说明当前节点
2. 明确说明建议回退到 `DesignDraft` 或 `RequirementDraft`
3. 列出需要更新的文档/方案内容
4. 转到 `workflow_repair`
5. 等待用户确认

### Step 5: Report State Explicitly
所有用户可见输出都要明确当前节点与下一步。

## Output

```markdown
## Feature Confirm

**Mode**: review | lock
**Current Spec**: `docs/spec/...`
**Scope**: Feature | Patch
**Current Node**: DesignDraft | ReadyForImplementation
**Decision**: stay | advance | repair_required

**Execution Package**:
- ...

**Patch Semantics**:
- ...

**Docs To Update**:
- ...

**Next Action**: `feature_confirm (lock)` | `code_implement_confirm` | `workflow_repair`
```

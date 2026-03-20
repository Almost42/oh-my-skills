---
name: code_implement_confirm
description: Use when an approved spec is ready for code work and the agent must execute changes from ReadyForImplementation into Implementing or Verifying.
---

# Code_implement_confirm

OMS v3 的执行器。它只处理已经获批的 execution package，不负责替代设计确认。

## When to Use

- `feature_confirm (lock)` 已把 spec 推进到 `ReadyForImplementation`。
- 用户明确要求开始执行已批准的代码改动。
- 当前工作已经在 `Implementing`，需要继续一轮实现。

## Instructions

### Step 1: Verify The Entry Gate
开始代码工作前必须确认：

- 目标 spec 存在
- `Status: Active`
- `Current_Node` 为 `ReadyForImplementation` 或 `Implementing`
- 若是 `Scope: Patch`，已有获批的 patch path

若当前节点仍是 `RequirementDraft` / `DesignDraft`，不要写代码，改回 `requirement_probe`、`feature_plan` 或 `feature_confirm`。

### Step 2: Record A Rollback Baseline
在修改代码前先记录 rollback baseline：

- 当前工作树/提交基线
- 将被修改的文件范围
- 删除/新增的敏感路径

这个 rollback baseline 只负责代码回退参照，不等于节点回退。node rollback 必须单独通过 `workflow_repair` 决定。

### Step 3: Enter `Implementing` And Execute

- 第一次真正开始改代码时，把 spec 的 `Current_Node` 设为 `Implementing`
- 按已批准 execution package 执行
- 若 `Scope: Patch`，严格沿着获批 patch path 实施
- 不要在实现阶段偷偷扩 scope

### Step 4: Run Self-Check
完成一轮实现后：

- 运行相关测试、构建或验收命令
- 记录实际通过/失败情况
- 标记是否仍需继续实现
- 记录 lesson 或 pitfall candidates

### Step 5: Decide Result Explicitly
结果只能是：

1. `stay`
   - 保持在 `Implementing`
   - 说明剩余工作与下一步
2. `advance`
   - 条件满足时把 `Current_Node` 推进到 `Verifying`
   - 然后转给 `verification_gate`
3. `repair_required`
   - 发现需求、设计、实施边界或验收假设存在问题
   - 转到 `workflow_repair`

### Step 6: Never Collapse Repair Into Silent Rollback

- 不要把节点回退和代码回退混为一谈
- 不要因为实现不顺就静默改写 spec
- 不要自动执行破坏性 code rollback
- 若需要回退文档节点或重新设计，先走 `workflow_repair`

## Output

```markdown
## Code Implement Confirm

**Current Spec**: `docs/spec/...`
**Scope**: Feature | Patch
**Current Node**: ReadyForImplementation | Implementing | Verifying
**Result**: stay | advance | repair_required

**Execution Summary**:
- ...

**Verification Snapshot**:
- ...

**Rollback Baseline**:
- ...

**Next Action**: `code_implement_confirm` | `verification_gate` | `workflow_repair`
```

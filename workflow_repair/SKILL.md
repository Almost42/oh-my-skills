---
name: workflow_repair
description: >-
  在当前节点无法安全闭环、需要修复设计或回退节点时使用，负责分类问题、提出回退方案并等待用户确认。
---

# 工作流修复

OMS v3 的显式修复协议。它的目标不是偷偷回退，而是让用户明确知道当前处于哪个节点、为什么要修复、需要更新哪些文档，以及代码应该怎么处理。

## When to Use

- `feature_confirm` 发现需求或设计仍有关键缺口。
- `code_implement_confirm` 发现问题不是实现细节，而是设计或需求不闭环。
- `verification_gate` 发现当前问题需要回到更早节点才能解决。

## Instructions

### Step 1: Classify Repair Type
必须先归类：

1. `ImplementationFix`
2. `DesignRepair`
3. `RequirementRepair`
4. `VerificationRepair`

### Step 2: Determine Rollback Strategy
为当前 spec 评估：

- 当前节点
- 最后确认节点
- 建议回退目标
- 是否可以保持当前节点不回退
- 需要更新哪些文档
- 代码应保留、局部回滚还是整体回滚

### Step 3: Prepare Repair Proposal
将修复建议写入当前 spec 的 `Workflow Notes` / `Repair Proposal` 区域，至少补齐：

- Trigger
- Reason
- Suggested Rollback Target
- Docs To Update
- Code Revert Needed
- User Confirmation

### Step 4: Wait For User Confirmation
不得静默回退。必须先输出修复提案，等待用户确认。

### Step 5: Apply Confirmed Repair
仅在用户确认后：

- 更新 spec 的 `Current_Node`
- 更新 `Last_Confirmed_Node`
- 更新 `Repair_State`
- 写入 `Rollback_Target`
- 将下一步重新路由到合适的 skill

文档回退和代码回退必须分开处理，不能自动绑定。

## Output

```markdown
## Workflow State

**Current Spec**: ...
**Current Node**: ...
**Last Confirmed Node**: ...
**Detected Intent**: DesignRepair | RequirementRepair | ImplementationFix | VerificationRepair
**Suggested Rollback Target**: ...
**Docs To Update**:
- ...

**Code Handling Suggestion**:
- preserve / partial revert / full revert

**Next Action**: ...
**Awaiting User Confirmation**: yes
```

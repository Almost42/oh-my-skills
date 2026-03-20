---
name: progress_sync
description: Use when active spec state has changed and docs/progress.md must be refreshed as a lightweight summary without becoming the node authority.
---

# Progress_sync

OMS v3 的轻量状态汇总器。`docs/progress.md` 只总结当前状态，spec 才是节点权威。

## When to Use

- `feature_confirm`、`code_implement_confirm`、`verification_gate` 后需要同步状态。
- 用户要求更新当前进度。
- 怀疑 `docs/progress.md` 与 active spec 状态漂移。

## Instructions

### Step 1: Read Active Spec State
读取所有活跃 spec，提取：

- 当前焦点 spec
- `Current_Node`
- `Last_Confirmed_Node`
- blocker
- next action

若 `docs/progress.md` 与 spec 冲突，以 spec 为准。

### Step 2: Write A Short Summary
`docs/progress.md` 只保留：

- 当前焦点
- 活跃 spec 列表
- 每个 active spec 的 current node
- 当前 blocker / risk
- next action

不要把 `docs/progress.md` 写成 memory，也不要让它拥有独立的 workflow 判定权。

### Step 3: Surface Drift
若发现以下问题，应在输出中点明：

- progress 和 spec 节点不一致
- 已无效的 blocker 仍留在进度里
- next action 仍指向旧 skill

## Output

```markdown
## Progress Sync

**Current Focus**: ...

**Active Spec Summary**:
- Spec: `docs/spec/...`
  Current Node: ...
  Next Action: ...

**Current Risks**:
- ...
```

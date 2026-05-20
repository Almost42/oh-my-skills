---
name: progress_sync
description: 在怀疑 docs/progress.md 漂移时手动触发；日常状态同步由 feature_confirm、code_implement_confirm、verification_gate 自动完成。
---

# 进度同步

OMS v3 的轻量状态汇总器。`docs/progress.md` 只总结当前状态，spec 才是节点权威。

## Iron Law

```
progress_sync 不主动建议自己。
状态变更 skill 已内置自动同步，不应再建议用户单独调用 progress_sync。
```

## When to Use

- **仅手动触发**：用户怀疑 `docs/progress.md` 与 active spec 状态漂移。
- 用户明确要求更新当前进度。

> **不再适用**：`feature_confirm`、`code_implement_confirm`、`verification_gate` 等状态变更 skill 已在内部自动完成 progress 同步，不再需要单独调用本 skill。

## Never

- Never 在其他 skill 的"下一步建议"中推荐调用 progress_sync
- Never 因为"刚改完状态"而建议单独执行 progress_sync——调用方 skill 已自动处理

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
## 进度同步结果

**当前焦点**: ...

**活跃 Spec 摘要**:
- Spec: `docs/spec/...`
  当前节点: ...
  下一步动作: ...

**当前风险**:
- ...

**漂移修复**:
- ...
```

> 不输出路由建议。同步完成后直接回到当前主流程。

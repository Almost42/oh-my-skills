---
name: context_sync
description: >-
  在新会话开始或怀疑文档漂移时使用，读取最小 baseline 文档恢复上下文，并在必要时升级到更重的恢复路径。
---

# 上下文同步

OMS v3 的默认恢复入口。它优先依赖 baseline 文档，而不是直接进入 memory 重建。

## When to Use

- 开始新对话。
- 用户说“继续”“接着做”“恢复上下文”。
- 怀疑代码结构与文档不一致。

## Instructions

### Step 1: Baseline Read
仅读取：

1. `AGENTS.md`
2. `docs/progress.md`
3. 活跃 `docs/spec/*.md`
4. `docs/architecture.md`
5. `docs/knowledge/index.md`

### Step 2: Detect Drift
检查：

- 是否出现新的 capability 信号
- `docs/progress.md` 的活跃 spec 是否与实际一致
- `docs/architecture.md` 是否可能落后
- 当前问题是否其实是新需求而非恢复上下文

### Step 3: Decide Whether Baseline Is Enough
若 baseline 已足够恢复：

- 直接输出当前焦点与下一步

若 baseline 不足：

- 升级到 `session_resume`

若发现能力缺口：

- 建议 `capability_bootstrap`

若发现进度漂移：

- 建议 `progress_sync`

## Output

```markdown
## Context Sync

**Current Focus**: ...
**Active Specs**:
- ...

**Potential Drift**:
- ...

**Baseline Enough**: yes | no
**Next Action**: ...
```

---
name: context_sync
description: >-
  在新会话开始或怀疑文档漂移时使用，读取最小 baseline 文档恢复上下文，并在必要时升级到更重的恢复路径。
---

# 上下文同步

OMS v3 的默认恢复入口。优先依赖 baseline 文档，不主动加载非必要内容。

**执行时宣告**："[context_sync] 恢复最小上下文..."

## When to Use

- 开始新对话。
- 用户说"继续""接着做""恢复上下文"。
- 怀疑代码结构与文档不一致。

## Instructions

### Step 1: Baseline Read（两步走）

**第一步：只读定位文档**

1. `AGENTS.md`
2. `docs/progress.md`
3. `docs/spec/index.md`（若存在，用于理解历史模块关注点）
4. `docs/knowledge/index.md`

**第二步：按 progress.md 结果定位 spec**

从 `docs/progress.md` 识别当前活跃 spec 列表：

**情况 A：只有一个活跃 spec**
→ 读取该 spec 的状态锚点（`docs/spec/YYYY-MM-DD-{slug}.md` 或 `docs/spec/YYYY-MM-DD-{slug}/index.md`）

**情况 B：有多个活跃 spec**
→ 不加载任何 spec，向用户说明并请求确认：

```
当前项目有多个进行中的工作项，请确认本次继续的是哪个：

1. [spec 名称] — [Current_Node] — [一句话摘要]
2. [spec 名称] — [Current_Node] — [一句话摘要]
...

请指定编号或名称，之后我只加载对应的 spec 内容。
```

等待用户指定后，只读取该 spec 状态锚点。

**情况 C：没有活跃 spec**
→ 直接进入 Step 2，无需加载任何 spec

`docs/architecture.md` 不在基础加载集——只有 Step 2 检测到架构漂移时才按需加载。

### Step 2: Detect Drift

检查：

- 是否出现新的 capability 信号
- `docs/progress.md` 的活跃 spec 是否与实际描述一致
- 是否有迹象表明 `docs/architecture.md` 可能落后（如用户提到了新模块或新服务）
- 当前问题是否其实是新需求而非恢复上下文

若发现架构漂移迹象 → 此时才加载 `docs/architecture.md` 做进一步检查。

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

**Active Spec**: ...（用户确认后 / 单一 spec 自动识别）
**Current Node**: ...
**Current Focus**: ...

**Potential Drift**:
- ...

**Docs Loaded**: （列出实际加载的文件，不加载的不列）
- ...

**Baseline Enough**: yes | no
**Next Action**: ...
```

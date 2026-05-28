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
2. `docs/ai/progress.md`
3. `docs/ai/spec/index.md`（若存在，用于理解历史模块关注点）
4. `docs/ai/knowledge/index.md`
5. `docs/ai/skills/index.md`（若存在；否则按需扫描 `docs/ai/skills/*/SKILL.md`）

> **从 workflow_guard 静默路由进入时**：`AGENTS.md` 和 `docs/ai/progress.md` 已在 guard 阶段加载，可直接复用上下文中的结果，仅需按需加载 `docs/ai/spec/index.md`、`docs/ai/knowledge/index.md` 与团队 skill 清单，避免重复读取。

**第二步：按 progress.md 结果定位 spec**

从 `docs/ai/progress.md` 识别当前活跃 spec 列表：

**情况 A：只有一个活跃 spec**
→ 读取该 spec 的状态锚点（`docs/ai/spec/YYYY-MM-DD-{slug}.md` 或 `docs/ai/spec/YYYY-MM-DD-{slug}/index.md`）

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

`docs/ai/architecture.md` 不在基础加载集——只有 Step 2 检测到架构漂移时才按需加载。

### Step 2: Detect Drift

检查：

- 是否出现新的 capability 信号
- `docs/ai/progress.md` 的活跃 spec 是否与实际描述一致
- 是否有迹象表明 `docs/ai/architecture.md` 可能落后（如用户提到了新模块或新服务）
- 当前问题是否其实是新需求而非恢复上下文
- 当前消息是否同时携带具体新需求或补丁

若发现架构漂移迹象 → 此时才加载 `docs/ai/architecture.md` 做进一步检查。

### Step 3: Decide Whether Baseline Is Enough

若 baseline 已足够恢复：

- **直接呈现当前焦点和可执行动作**，让用户可以立即开始工作。
- **不输出"下一步建议"路由列表**。用户已经知道当前状态，不需要再选 routing 目标。
- 若当前消息同时带有具体新需求或补丁，恢复完成后应立即转入 `requirement_probe`，不得直接开始实现。
- 若存在团队 skill，补充一句当前可用团队 skill，优先读取 `docs/ai/skills/index.md`；缺失时扫描 `docs/ai/skills/*/SKILL.md`。
- 若团队通过 skillshare 维护 skill，恢复上下文后补充固定提示：执行 `skillshare install ./docs/ai/skills -p -f` 与 `skillshare sync -p`。
- 输出格式：一句话状态摘要 + 当前节点 + 可直接执行的动作（如"需要我继续当前 spec 的验证吗？"或"需要我继续实施吗？"）

若 baseline 不足：

- 升级到 `session_resume`

若发现能力缺口：

- 建议 `capability_bootstrap`

若发现进度漂移：

- 自动执行 `progress_sync` 修正，不单独建议用户调用

## Output

### Baseline 足够（默认情况）

```markdown
## 上下文同步

**当前活跃 Spec**: ...（用户确认后 / 单一 spec 自动识别）
**当前节点**: ...
**当前焦点**: ...

**已加载文档**:
- ...

**当前可用 Skills**:
- ...（若存在团队 skill；优先读 `docs/ai/skills/index.md`，缺失时扫描 `docs/ai/skills/*/SKILL.md`）

**可直接继续**: [一句话说明当前可做什么，如"需要我继续当前 spec 的验证吗？"]

**小提示**: 若团队通过 skillshare 维护技能，恢复上下文后请执行 `skillshare install ./docs/ai/skills -p -f` 与 `skillshare sync -p`
```

> **不包含"下一步建议"路由**。baseline 足够时，输出后直接等待用户给出具体工作指令，而非让用户在 skill 路由中做选择。

### Baseline 不足 / 发现漂移

```markdown
## 上下文同步

**当前活跃 Spec**: ...
**当前节点**: ...
**当前焦点**: ...

**潜在漂移**:
- ...

**当前信息是否已足够继续工作**: 否
**原因**: ...
**建议**: 升级到会话恢复（`session_resume`） | 补做能力文档（`capability_bootstrap`）
```

---
name: requirement_probe
description: 在新请求仍不清楚、且 agent 需要判断工作应继续停留在 RequirementDraft 还是进入 DesignDraft 时使用。
---

# 需求澄清探查

OMS v3 的需求澄清入口。先把需求边界问清楚，再决定是留在 `RequirementDraft` 还是进入 `DesignDraft`。

**执行时宣告**："[requirement_probe] 澄清需求边界..."

## Iron Law

```
有歧义，问。不确定，停。
任何未经用户确认的假设都是风险，不得带入设计阶段。
```

## When to Use

- 用户提出新功能、修改请求、需求补充或模糊问题。
- 当前还不能稳定写出 `docs/spec/YYYY-MM-DD-*.md` 或 `docs/spec/YYYY-MM-DD-*/index.md` 的设计草案。
- 需要先判断这是 `Scope: Feature` 还是 `Scope: Patch`。

## Never

- Never 替用户填补成功标准（验收标准必须来自用户）
- Never 一次提多个问题（每次只问最关键的一个缺口）
- Never 在需求仍模糊时推进到 `DesignDraft`
- Never 把"用户语气肯定"当作需求已足够清晰的凭据

## Instructions

### Step 1: Read Minimum Context

优先读取：

1. `AGENTS.md`
2. `docs/progress.md`
3. `docs/spec/index.md`（按模块和处理方向定位历史 spec，若存在）
4. 相关活跃 spec 状态锚点（`docs/spec/YYYY-MM-DD-*.md` 或 `docs/spec/YYYY-MM-DD-*/index.md`）
5. 当前问题直接涉及的 capability docs
6. `docs/knowledge/lessons/design.md`（若存在）

不要因为"先看看再说"而整库扫描文档。

### Step 2: Clarify The Requirement

围绕以下维度补齐缺口，每次只聚焦一个最关键的未知项：

- 目标与动机是什么
- 谁会受到影响
- 成功标准与失败表现是什么
- 影响哪些模块、接口、数据、流程或领域规则
- 是否存在时间、兼容性、性能、部署或协作约束
- 用户真正想修的是"局部问题"还是"系统性能力"

✅ 确认"成功标准"缺失，只问："用户场景下，这个功能做好的标志是什么？"
❌ 同时问："成功标准是什么？影响哪些模块？有没有时间约束？"

### Step 3: Classify Scope

明确给出 `Scope: Feature | Patch` 判断：

- `Feature`
  - 引入新能力
  - 跨模块或跨文档影响明显
  - 涉及接口、数据、流程、架构或长期约束变化
  - 将使用 multi-file spec（`docs/spec/YYYY-MM-DD-{slug}/`）
- `Patch`
  - 局部修复、纠偏、兼容修正、文案/行为小改
  - 影响面可明确圈定
  - 将使用 single-file spec（`docs/spec/YYYY-MM-DD-{slug}.md`）

### Step 4: Decide The Node

必须显式判断当前节点去向：

- 保持在 `RequirementDraft`
  - 目标、边界、验收标准或影响面仍不清楚
  - 当前只能继续补需求，不适合进入方案设计
- 进入 `DesignDraft`
  - 需求意图、范围和成功标准已经足够稳定
  - 可以交给 `feature_plan` 产出或修订设计草案

### Step 5: Identify Required Docs And Tags

输出：

- 当前请求必须加载的文档
- 涉及的 capability tags
- 涉及的 module tags
- 是否需要先调用 `capability_bootstrap`
- 若进入 spec 写作，提醒后续 `feature_plan` 使用 `YYYY-MM-DD-{slug}` 命名并更新 `docs/spec/index.md`
- OMS 文档正文默认使用中文；路径、代码标识符、API 名称、frontmatter 枚举值和既有英文术语可保留英文。

### Step 6: Route Explicitly

- 若继续留在 `RequirementDraft`，列出还缺什么信息，等待用户补齐。
- 若可以进入 `DesignDraft`，下一步转到 `feature_plan`。
- 若用户其实是在修复已批准流程中的设计/需求问题，不要静默改写旧方案，改走 `workflow_repair`。

## Red Flags - STOP

- 验收标准里出现"应该"、"一般"、"可能"等模糊词，但你准备接受
- 影响面涉及多个模块，但你没有逐一确认边界
- 用户回答时带出了新的需求信号，但你没有追问

## Rationalization 防御

| 常见冲动 | 实际风险 |
| :--- | :--- |
| "这个需求很明显，不用问了" | 明显的需求往往藏着隐含约束 |
| "先设计，边做边对齐" | 设计完成后对齐成本翻倍 |
| "用户肯定是想要 X" | 猜测一旦错误，spec 成废纸 |
| "用户很忙，少问一点" | 澄清成本永远低于返工成本 |

## Output

```markdown
## Requirement Probe

**Current Node**: RequirementDraft | DesignDraft
**Suggested Scope**: Feature | Patch
**Requirement Summary**: ...

**Open Questions**:
- ...

**Required Docs**:
- ...

**Capability Tags**:
- ...

**Module Tags**:
- ...

**Next Action**: ...
```

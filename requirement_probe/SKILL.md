---
name: requirement_probe
description: Use when a new request is still unclear and the agent must decide whether work remains in RequirementDraft or can enter DesignDraft.
---

# Requirement_probe

OMS v3 的需求澄清入口。它负责先把需求边界问清楚，再决定当前工作是留在 `RequirementDraft`，还是足够进入 `DesignDraft`。

## When to Use

- 用户提出新功能、修改请求、需求补充或模糊问题。
- 当前还不能稳定写出 `docs/spec/*.md` 的设计草案。
- 需要先判断这是 `Scope: Feature` 还是 `Scope: Patch`。

## Instructions

### Step 1: Read The Minimum Context
优先读取：

1. `AGENTS.md`
2. `docs/progress.md`
3. 相关活跃 `docs/spec/*.md`
4. 当前问题直接涉及的 capability docs

不要因为“先看看再说”而整库扫描文档。

### Step 2: Clarify The Requirement
围绕以下维度补齐缺口：

- 目标与动机是什么
- 谁会受到影响
- 成功标准与失败表现是什么
- 影响哪些模块、接口、数据、流程或领域规则
- 是否存在时间、兼容性、性能、部署或协作约束
- 用户真正想修的是“局部问题”还是“系统性能力”

### Step 3: Classify Scope
明确给出 `Scope: Feature | Patch` 判断：

- `Feature`
  - 引入新能力
  - 跨模块或跨文档影响明显
  - 涉及接口、数据、流程、架构或长期约束变化
- `Patch`
  - 局部修复、纠偏、兼容修正、文案/行为小改
  - 影响面可明确圈定
  - 仍需 spec，但执行包可以更轻量

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

### Step 6: Route Explicitly

- 若继续留在 `RequirementDraft`，列出还缺什么信息，并等待用户补齐。
- 若可以进入 `DesignDraft`，下一步转到 `feature_plan`。
- 若用户其实是在修复已批准流程中的设计/需求问题，不要静默改写旧方案，改走 `workflow_repair`。

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

---
name: feature_plan
description: 在需求已准备进入方案设计、且需要在实施前创建或修订 DesignDraft spec 时使用。
---

# 设计草案生成

OMS v3 的设计草案器。它把已经足够清晰的需求写成 `DesignDraft` spec，并只加载与当前设计相关的知识与文档。

## When to Use

- `requirement_probe` 已判断请求可以进入 `DesignDraft`。
- 现有 spec 需要补充或修订设计方案、影响分析、验收标准。
- 用户要求先出方案、先写 spec、先看设计稿。

## Instructions

### Step 1: Load Only Relevant Context
优先读取：

1. 目标 `docs/spec/*.md`，若不存在则准备创建
2. `docs/architecture.md`
3. 相关活跃 specs
4. `docs/knowledge/index.md`
5. 与当前 capability / module tags 匹配的知识文件

迁移期允许补充读取：

- `docs/pitfalls.md`
- `docs/anti-patterns.md`

但它们只是 compatibility inputs，不应替代 `docs/knowledge/index.md` 的按 tag 加载机制。

### Step 2: Decide Whether To Create Or Revise

- 若尚无对应 spec，则以 `feature_plan/templates/spec.v3.md` 为起点在 `docs/spec/` 创建新文件。
- 若已有目标 spec，则在原文件上修订，不新开平行草案。
- 若当前发现的是已确认节点上的需求/设计缺口，不要静默改写已批准状态，改走 `workflow_repair`。

### Step 3: Write Or Update The DesignDraft Spec
spec 必须保留并明确：

- `Status: Draft`
- `Scope: Feature | Patch`
- `Current_Node: DesignDraft`
- `Last_Confirmed_Node`
- `Capability_Tags`
- `Module_Tags`
- `Repair_State`
- `Rollback_Target`

设计内容至少覆盖：

- 业务背景
- 需求范围与非范围
- 技术方案与约束
- 接口/契约影响
- 影响分析
- 验收标准
- capability tags 与 module tags

对新 spec：

- 默认把 `Last_Confirmed_Node` 设为 `RequirementDraft`

对已存在 spec：

- 保留真实的 `Last_Confirmed_Node`
- 不要为了“看起来顺滑”而假装节点前进

### Step 4: Detect Conflicts And Patch Semantics

- 检查是否与其他活跃 spec 的改动范围冲突。
- 若 `Scope: Patch`，明确记录 patch path、影响边界与简化原因。
- 若设计会改变结构、能力边界或知识路由，标注后续需要同步的文档。

### Step 5: Review Knowledge Loading
输出本次真正加载了哪些知识：

- 来自 `docs/knowledge/index.md` 的 tag routes
- 是否额外参考了迁移期 legacy durable knowledge
- 哪些知识被判定为与当前设计无关，因此未加载

### Step 6: Report Without Advancing Too Far

- 正常结果：保持在 `DesignDraft`，转到 `feature_confirm (review)`。
- 若设计仍暴露需求空洞：回到 `requirement_probe`。
- 若是在已确认流程中发现问题：提议 `workflow_repair`。

## Output

```markdown
## Feature Plan

**Spec**: `docs/spec/...`
**Scope**: Feature | Patch
**Current Node**: DesignDraft
**Last Confirmed Node**: ...

**Knowledge Loaded**:
- ...

**Potential Conflicts**:
- ...

**Docs To Sync Later**:
- ...

**Next Action**: `feature_confirm (review)` | `requirement_probe` | `workflow_repair`
```

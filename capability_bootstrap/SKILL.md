---
name: capability_bootstrap
description: >-
  在项目新增前端、接口、数据、运维或领域规则等能力时使用，补建缺失文档并把变化同步回 OMS v3 治理层。
---

# 能力文档补建

能力扩展补全器。它处理“项目一开始没有这个能力，后来长出来了”的场景，并确保治理层同步更新。

## When to Use

- `context_sync` 发现新的 capability 信号。
- 新需求会引入新的前端、接口、数据、运维或领域规则能力。
- 现有文档与代码结构不再匹配。

## Instructions

### Step 1: Confirm Capability Growth
确认新增能力的依据：

- 新目录或新文件
- 新依赖
- 新 spec
- 用户明确说明

### Step 2: Create Missing Capability Docs
按能力补建，并优先使用本 skill 自带模板：

- UI / Client -> `docs/ai/frontend/guidelines.md` <- `capability_bootstrap/templates/frontend-guidelines.v3.md`
- Flow-heavy -> `docs/ai/flows.md` <- `capability_bootstrap/templates/flows.v3.md`
- Interfaces -> `docs/ai/interfaces.md` <- `capability_bootstrap/templates/interfaces.v3.md`
- Data -> `docs/ai/data_model.md` <- `capability_bootstrap/templates/data-model.v3.md`
- Operations -> `docs/ai/operations.md` <- `capability_bootstrap/templates/operations.v3.md`
- Domain Rules -> `docs/ai/domain_rules.md` <- `capability_bootstrap/templates/domain-rules.v3.md`

### Step 3: Sync Governance Layer
同步更新：

- `AGENTS.md` 中的文档槽位和加载入口
- `docs/ai/architecture.md`
- `docs/ai/knowledge/index.md`

### Step 4: Report
输出新增能力、补建文档、以及治理层同步情况。

## Output

```markdown
## 能力补建结果

**新增能力**: ...
**已创建文档**:
- ...

**治理层同步**:
- `AGENTS.md`
- `docs/ai/architecture.md`
- `docs/ai/knowledge/index.md`

**下一步建议**: 已可继续当前主流程工作 | 如仍存在文档漂移，建议进一步整理（`project_docs_optimize`）
```

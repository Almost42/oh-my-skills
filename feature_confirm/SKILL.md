---
name: feature_confirm
description: 在 DesignDraft spec 需要评审实施包或在进入 ReadyForImplementation 前做最终锁定时使用。
---

# 方案确认与锁定

OMS v3 中，设计确认和实施方案确认在这里合并处理。它不是单向闸门，而是一个可重复进入的节点操作器。

**执行时宣告**："[feature_confirm] 评审/锁定方案..."

## When to Use

- 用户要审阅某个 `DesignDraft` 的实施方案。
- 用户已经看过方案，准备锁定执行包。
- 旧的独立实施方案评审场景。

## Modes

### `review`

- 验证 spec 是否足够支撑实施
- 生成 execution package
- 保持节点在 `DesignDraft`
- 不开始代码实现

### `lock`

- 仅在用户明确批准 execution package 后执行
- 将节点推进到 `ReadyForImplementation`
- 记录最近一次确认节点
- 标记 execution package 已获批准

## Instructions

### Step 1: Read The Active Design Context

必读（每次）：

1. 目标 spec 状态锚点（`docs/spec/YYYY-MM-DD-{slug}.md` 或 `docs/spec/YYYY-MM-DD-{slug}/index.md`）
2. `docs/knowledge/index.md` 路由到的相关知识
3. `docs/knowledge/lessons/design.md`（若存在）
4. 对 multi-file spec：`design.md`（方案内容）+ `req.md`（验收标准）
5. `docs/spec/index.md`（确认模块历史与处理方向摘要是否需要同步）

OMS 文档正文默认使用中文；路径、代码标识符、API 名称、frontmatter 枚举值和既有英文术语可保留英文。

条件加载 `docs/architecture.md`（满足以下任一条件才读取）：

- `Scope: Feature`
- execution package 涉及跨模块、接口变更或数据层改动
- spec 的 `Capability_Tags` 涉及多个能力域

`Scope: Patch` 且改动面已明确圈定 → 跳过 `docs/architecture.md`。

条件加载 capability docs：仅加载与当前 spec `Capability_Tags` 直接匹配的文件，不加载全部 capability docs。

若当前 spec 不是 `DesignDraft`，不要硬套当前流程，改为说明当前节点并路由到正确 skill。

### Step 2: Run `review` Mode

在 `review` mode 中必须产出：

- change tree
- impact view
- risk view
- rollback planning
- required doc updates
- active-spec conflict notes

如果 `Scope: Patch`，额外明确：

- patch path
- 改动边界
- 为什么这是 patch 而不是 feature

#### Simplicity Gate（每次 review 必执行）

在产出 execution package 之前，检查：

- [ ] 改动范围是否超出了 `req.md`（或"需求范围"）所列的需求？
- [ ] execution package 中是否包含了"顺手改"的重构或优化？
- [ ] 是否引入了需求没提到的新依赖或新抽象？

若任意一项为 Yes：标记并要求裁剪，不得直接进入 lock。

✅ "execution package 只包含 requirement_probe 明确列出的 3 个文件"
❌ "顺手把隔壁模块的命名规范也统一了"

`review` mode 的结果只能是：

- `stay`：spec 继续停留在 `DesignDraft`
- `repair_required`：发现需求或设计本身不成立，转到 `workflow_repair`

### Step 3: Run `lock` Mode

只有在用户明确批准后，`lock` mode 才能执行：

- `Status: Draft` -> `Status: Active`
- `Current_Node: DesignDraft` -> `Current_Node: ReadyForImplementation`
- `Last_Confirmed_Node` 记录为 `DesignDraft`
- 必要时同步 `docs/architecture.md` 和相关 capability docs

对 multi-file spec：将 execution package 详情写入 `impl.md`，在 `index.md` 的"执行包摘要"填写摘要（文件数、影响范围、回滚目标），不在 `index.md` 重复完整内容。
若锁定或归档改变了 spec 摘要状态，同步 `docs/spec/index.md` 的当前节点、处理方向或最近更新日期。

`lock` mode 的结果只能是：

- `advance`：进入 `ReadyForImplementation`
- `repair_required`：若用户在锁定前指出设计缺口，转到 `workflow_repair`

### Step 4: Handle Re-Entry Correctly

这个 skill 可以多次执行。若用户不满意方案或发现设计缺口，不要静默改 spec——明确说明当前节点、建议回退目标和需要更新的文档，转到 `workflow_repair` 等待确认。

## Output

```markdown
## Feature Confirm

**Mode**: review | lock
**Current Spec**: `docs/spec/YYYY-MM-DD-...`
**Spec Mode**: single | multi
**Scope**: Feature | Patch
**Current Node**: DesignDraft | ReadyForImplementation
**Decision**: stay | advance | repair_required

**Simplicity Gate**:
- [ ] 改动范围未超出需求
- [ ] 无顺手改的重构
- [ ] 无未被需求提及的新依赖

**Execution Package**:
- ...

**Patch Semantics**:
- ...

**Docs To Update**:
- ...

**Next Action**: `feature_confirm (lock)` | `code_implement_confirm` | `workflow_repair`
```

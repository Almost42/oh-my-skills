---
name: feature_plan
description: 在需求已准备进入方案设计、且需要在实施前创建或修订 DesignDraft spec 时使用。
---

# 设计草案生成

OMS v3 的设计草案器。把已经足够清晰的需求写成 `DesignDraft` spec，并只加载与当前设计相关的知识与文档。

**执行时宣告**："[feature_plan] 生成设计草案..."

## Iron Law

```
最小可行方案优先。
没有被需求明确提出的抽象、扩展点、配置项，一律不加。
```

## When to Use

- `requirement_probe` 已判断请求可以进入 `DesignDraft`。
- 现有 spec 需要补充或修订设计方案、影响分析、验收标准。
- 用户要求先出方案、先写 spec、先看设计稿。

## Never

- Never 为"以后可能用到"添加任何设计内容
- Never 为单次使用的逻辑创建抽象层或接口
- Never 在 spec 里包含"未来规划"或"扩展方向"作为当前设计内容
- Never 因为"更优雅"而超出需求边界

## Instructions

### Step 1: Load Only Relevant Context

必读（每次）：

1. 目标 spec 状态锚点（`docs/spec/YYYY-MM-DD-{slug}.md` 或 `docs/spec/YYYY-MM-DD-{slug}/index.md`）
2. `docs/knowledge/index.md`
3. 与当前 capability / module tags 匹配的知识文件
4. `docs/knowledge/lessons/design.md`（若存在）

条件加载 `docs/architecture.md`（满足以下任一条件才读取）：

- `Scope: Feature`（Feature 通常涉及架构边界）
- 设计涉及跨模块、新接口、数据层或服务依赖变更
- spec 的 `Capability_Tags` 或 `Module_Tags` 涉及多个模块

`Scope: Patch` 且改动面已明确圈定 → 跳过 `docs/architecture.md`，节省上下文。

其他活跃 spec 状态锚点：仅当检测到当前设计与其他 spec 存在潜在冲突时才按需加载，不默认全读。

迁移期允许补充读取 `docs/pitfalls.md`、`docs/anti-patterns.md`，但它们只是兼容输入。

### Step 2: Determine Spec Mode And File Structure

根据 `Scope` 确定 spec 类型：

- spec 文件或目录名必须包含创建日期（精确到日），统一格式为 `YYYY-MM-DD-{slug}`；日期一旦创建不随后续更新改变。
- `slug` 使用短横线小写英文或项目既有命名，表达需求主题；不得创建无日期前缀的 `docs/spec/create-task.md` 或 `docs/spec/create-task/`。
- `docs/spec/index.md` 是 spec 根索引，简要记录每个需求关注的模块、处理方向、日期和状态锚点；创建或修订 spec 时同步更新该索引，但节点真相仍在 spec 状态锚点。
- OMS 文档正文默认使用中文；路径、代码标识符、API 名称、frontmatter 枚举值和既有英文术语可保留英文。

- `Scope: Patch` → **Single-file mode**
  - 文件：`docs/spec/YYYY-MM-DD-{slug}.md`
  - 模板：`feature_plan/templates/spec.v3.md`
  - 内容完整写入单文件

- `Scope: Feature` → **Multi-file mode**
  - 目录：`docs/spec/YYYY-MM-DD-{slug}/`
  - 状态锚点：`index.md`（持有所有 frontmatter，状态变更只写这里）
  - 需求内容：`req.md`（业务背景、需求范围、验收标准）
  - 设计内容：`design.md`（技术方案、接口影响、影响分析）
  - 实施包：`impl.md`（ReadyForImplementation 后由 feature_confirm 填充）
  - 模板：`feature_plan/templates/spec-index.v3.md` / `spec-req.v3.md` / `spec-design.v3.md` / `spec-impl.v3.md`

✅ Feature 类需求 → 创建 `docs/spec/2026-04-20-create-task/index.md` + `req.md` + `design.md` + `impl.md`（空），并更新 `docs/spec/index.md`
❌ Feature 类需求 → 把所有内容堆进一个 `create-task.md`

### Step 3: Decide Whether To Create Or Revise

- 若尚无对应 spec，按 Step 2 的模式新建文件。
- 若已有目标 spec，在原文件基础上修订，不新开平行草案。
- 若当前发现的是已确认节点上的需求/设计缺口，不要静默改写已批准状态，改走 `workflow_repair`。

### Step 4: Write Or Update The DesignDraft Spec

状态锚点（single: `spec/YYYY-MM-DD-{slug}.md` / multi: `spec/YYYY-MM-DD-{slug}/index.md`）必须保留并明确：

- `Status: Draft`
- `Scope: Feature | Patch`
- `Current_Node: DesignDraft`
- `Last_Confirmed_Node`
- `Capability_Tags`
- `Module_Tags`
- `Repair_State`
- `Rollback_Target`
- `Split_Mode: single | multi`

对 multi-file spec，设计内容写入 `design.md`，需求内容写入或更新 `req.md`，`index.md` 只持有 frontmatter 和摘要，不重复详细内容。

同步 `docs/spec/index.md` 时只写简略检索信息：spec 路径、创建日期、Scope、Current_Node、Module_Tags、处理方向、最近更新日期；不得把详细需求、设计或实施包复制进去。

### Step 5: Run YAGNI Complexity Check

写完设计草案后，必须自查：

- [ ] 方案中每一项是否都能在 `req.md`（或"需求范围"）中找到对应来源？
- [ ] 是否存在"以防万一"的抽象或接口设计？
- [ ] 如果去掉最复杂的那部分，需求还能满足吗？

若有任何项答案为 Yes（存在不必要复杂度），在输出中明确标记，并建议裁剪方案。

✅ "只新增一个 tasks 表和一个 POST 接口，满足需求"
❌ "设计了通用任务框架，支持插件化扩展，为未来多种任务类型预留接口"

### Step 6: Detect Conflicts And Patch Semantics

- 检查是否与其他活跃 spec 的改动范围冲突。
- 若 `Scope: Patch`，明确记录 patch path、影响边界与简化原因。
- 若设计会改变结构、能力边界或知识路由，标注后续需要同步的文档。

### Step 7: Report Without Advancing Too Far

- 正常结果：保持在 `DesignDraft`，转到 `feature_confirm (review)`。
- 若设计仍暴露需求空洞：回到 `requirement_probe`。
- 若是在已确认流程中发现问题：提议 `workflow_repair`。

## Output

```markdown
## Feature Plan

**Spec**: `docs/spec/YYYY-MM-DD-...`
**Scope**: Feature | Patch
**Spec Mode**: single | multi
**Current Node**: DesignDraft
**Last Confirmed Node**: ...

**YAGNI Check**:
- [ ] 所有设计项均有需求来源
- [ ] 无"以防万一"的抽象
- [ ] 最简方案可满足需求

**Knowledge Loaded**:
- ...

**Potential Conflicts**:
- ...

**Docs To Sync Later**:
- ...

**Next Action**: `feature_confirm (review)` | `requirement_probe` | `workflow_repair`
```

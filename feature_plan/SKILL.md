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
5. `docs/architecture.md`（若存在则**必读**，与 `AGENTS.md` 中 baseline 叙述一致）：
   - `Scope: Feature` 或设计涉及跨模块/接口/数据时：通读以校准边界与依赖。
   - `Scope: Patch`：优先关注与 **patch path、模块边界、构建/测试/工具链** 相关的节（如 `## 构建与验证`、`## 开发环境与工具约定`）；**不必**在输出中复述与本次改动无关的大段。未分节时读全文，以免遗漏仅写在 architecture 中的命令/环境约定。

其他活跃 spec 状态锚点：仅当检测到当前设计与其他 spec 存在潜在冲突时才按需加载，不默认全读。

若发现 owner 文档结构混乱、knowledge 路由失真或 legacy 输入尚未收敛，应先建议 `project_docs_optimize`，不要在这里承担兼容读取。

### Step 2: Determine Spec Mode And File Structure

- `Scope: Patch` → **Single-file**: `docs/spec/YYYY-MM-DD-{slug}.md`，模板 `spec.v3.md`
- `Scope: Feature` → **Multi-file**: `docs/spec/YYYY-MM-DD-{slug}/`，子文件为 `index.md` + `req.md` + `design.md` + `impl.md`
- 命名规则与完整模板清单见 `references/spec-structure.md`
- 创建或修订后同步 `docs/spec/index.md`（只写简略检索信息）

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

### Step 7: Report And Auto-Continue

- 正常结果：保持在 `DesignDraft`，输出设计草案摘要后**直接进入 `feature_confirm (review)`**，不输出"下一步建议"停等。
- 若设计仍暴露需求空洞：回到 `requirement_probe`。
- 若是在已确认流程中发现问题：提议 `workflow_repair`。

## Output

> 完整模板见 `references/output-templates.md`

**正常完成** — 输出设计草案 + YAGNI 检查 + 潜在冲突，不输出"下一步建议"，自动进入 `feature_confirm (review)`。

**需求不足/发现问题** — 输出受阻原因，回到 `requirement_probe` 或 `workflow_repair`。

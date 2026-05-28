---
name: workflow_guard
description: >-
  在任何重要动作开始前使用，识别当前用户意图、当前节点和缺失门禁，并路由到正确的 OMS v3 skill。
---

# 工作流守卫

OMS v3 的第一入口。先判断"该走哪条链路"，再建议任何动作。

**执行时宣告**："[workflow_guard] 分析意图与节点..."

## Iron Law

```
先识别意图，再建议动作。
没有明确节点和意图，不能建议任何修改操作。
```

## When to Use

- 新对话开始时。
- 用户提出新需求、补丁、继续开发、开始实现、修复问题、发布版本。
- AI 在执行任何重要动作前，需要确认当前节点和缺失门禁。

## Never

- Never 在 Step 2 完成前就有"下一步要做什么"的输出
- Never 跳过 Step 3 的门禁检查直接路由
- Never 把"用户语气紧迫"当作跳过意图识别的理由
- Never 在多个活跃 spec 的情况下自行选择一个继续，必须先让用户确认

## Instructions

### Step 1: Locate Context（最小集优先）

**第一步：只读最小定位文档**（2 个文件，足够判断活跃 spec 情况）

1. `AGENTS.md`
2. `docs/ai/progress.md`

从 `docs/ai/progress.md` 识别当前活跃 spec 列表：

**情况 A：只有一个活跃 spec**
→ 暂不加载 spec 锚点，仅在 Step 4 决定路由后由目标 skill 按需加载

**情况 B：有多个活跃 spec**
→ 不加载任何 spec，直接向用户列出所有活跃 spec 并要求确认：

```
当前项目有多个进行中的工作项，请确认本次对话要处理哪个：

1. [spec 名称] — [Current_Node] — [一句话摘要]
2. [spec 名称] — [Current_Node] — [一句话摘要]
...

请指定编号或名称。
```

等待用户回复后，不加载 spec，将用户选择传递到目标 skill。

**情况 C：没有活跃 spec**
→ 不加载任何 spec，直接进入 Step 2 的意图识别

**第二步：按意图决定是否补载**（在 Step 2 识别意图后）

仅在 Step 2 识别为非 context_sync 意图时，补载：
- `docs/ai/spec/index.md`（若存在）
- `docs/ai/knowledge/lessons/workflow.md`（若存在）

若意图为 `context_sync`，跳过上述补载——这些文档由 context_sync 自行加载，避免重复。

⚠️ `docs/ai/architecture.md` 在此步骤不加载——workflow_guard 不需要架构细节来识别意图和路由。

### Step 2: Identify Intent

将当前请求归类为以下之一：

- 新项目初始化、旧文档体系迁移到 OMS v3、或已有 OMS 档案需要重新扫描对账 -> `project_init`
- 恢复上下文 -> `context_sync`
- 新需求或补丁需求 -> `requirement_probe`
- 同一条消息同时包含“恢复/继续”和具体新需求或补丁 -> 先 `context_sync`，随即进入 `requirement_probe`
- 发现新能力、缺失 capability docs、或代码结构长出新的 frontend/API/data/ops/domain concern -> `capability_bootstrap`
- Draft 方案评审 -> `feature_confirm` (`review`)
- 执行包已确认 -> `feature_confirm` (`lock`)
- 已批准的实现开始落地 -> `code_implement_confirm`
- 发现需求/设计/验证不闭环 -> `workflow_repair`
- 声称完成或修复 -> `verification_gate`
- 需求验收通过 / 验收通过 / 验证完成 -> `verification_gate`（单个 spec 的验收确认，验收通过后自动归档）

若识别为补丁需求，默认仍先进入 `requirement_probe`，并明确标注 `Scope: Patch`。

✅ "用户说'修一个 bug'，当前无活跃 spec → 意图归类为 Patch 需求 → requirement_probe"
❌ "用户说'修一个 bug' → 直接建议开始改代码"

### Step 3: Check Gates

检查是否缺少前置门禁：

- 是否存在对应 spec 状态锚点
- 当前 spec 是否处于正确节点
- 是否仍处于 `DesignDraft`
- 是否已有执行包批准
- 当前任务是否暴露了新的 capability signal，但对应文档尚未建立
- 是否应该先修复而非继续前进

### Step 4: Route

若检测到 new capability growth 或 capability docs 缺口，应优先建议 `capability_bootstrap`。

若意图属于初始化 / 迁移 / 对账，先路由到 `project_init`。

**静默路由规则**：以下场景跳过完整报告，直接进入目标 skill：

- **意图 = 纯 `context_sync` 且只有一个活跃 spec**：不输出"工作流状态"报告，直接加载 `context_sync`。若同条消息还带有新需求，不适用静默路由。
- **意图 = `feature_confirm (review)`，spec 处在 `DesignDraft`，门禁无缺失**：跳过报告，直接进入 `feature_confirm (review)`。

其他情况正常输出路由报告。

## Red Flags - STOP

- 文档状态（spec Current_Node）与用户描述的进度不一致，但你准备忽略继续
- 用户语气急迫，你感到"先做再说"的冲动
- 意图识别出来多于一个，但你只选了其中一个没有说明原因
- 发现多个活跃 spec 但没有让用户确认就继续处理

## Output

```markdown
## 工作流状态

**当前 Spec**: ...（用户确认后）
**当前节点**: ...
**识别意图**: ...
**建议技能**: ...
**需要读取的文档**:
- ...

**缺失门禁**:
- ...

**下一步建议**: 先执行项目初始化扫描（`project_init`） | 先恢复项目上下文（`context_sync`） | 先进入需求澄清（`requirement_probe`） | 先补建能力文档（`capability_bootstrap`） | 当前流程存在缺口，建议先修复（`workflow_repair`）
```

> **静默路由时不输出此报告**。单 spec + context_sync 意图时，直接进入目标 skill。
> 多 spec 需用户确认时，仅列出选项，不输出完整路由报告。

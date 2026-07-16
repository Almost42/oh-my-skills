---
name: workflow_guard
description: >-
  在进入会改变代码、文档或工作流状态的任务前使用，识别用户意图、冲突范围和缺失门禁；纯代码分析、漏洞排查和日志诊断不进入 spec 流程。
---

# 工作流守卫

OMS 的治理入口。先区分纯诊断与变更请求；只有变更请求才进入 spec 与节点流程。

**执行时宣告**："[workflow_guard] 分析意图与节点..."

## Iron Law

```
先识别意图，再建议动作。
只有会改变代码、文档或状态的请求才检查节点和门禁。
```

## When to Use

- 用户提出新需求、补丁、继续开发、开始实现、修复问题或发布版本。
- 用户的分析请求同时包含明确的修复、改动或验收意图。
- AI 准备执行会改变代码、文档或状态的动作前。

## Never

- Never 把纯逻辑分析、漏洞排查或日志诊断升级为 spec 流程
- Never 因为存在多个活跃 spec 就阻塞范围无交叉的补丁
- Never 跳过变更请求的门禁检查直接进入实现
- Never 把"用户语气紧迫"当作跳过意图识别的理由
- Never 在用户只说"继续"且有多个活跃 spec 时自行选择

## Instructions

### Step 1: Triage Intent

先按用户的实际授权分类：

- **纯诊断**：解释现有逻辑、分析日志/报错、研判漏洞或确认现状，未要求改动。
  - 直接读取与问题有关的代码、日志、配置和测试；不读 `progress.md`，不选择 spec，不输出节点或门禁。
  - 输出事实、推断、证据范围和未确认项；只有用户明确要求修复，才在后续转入 Patch 链路。
- **变更请求**：新增、修改、修复、实施、发布、验收，或用户已明确要求修复已确认的问题。
  - 进入 Step 2。
- **混合请求**：如“先定位并修复”。先完成最小诊断；确认变更范围后进入 Patch 链路，不在诊断开始前创建 spec。

✅ “检查这段鉴权代码是否可绕过” -> 直接分析代码与证据
✅ “这个异常已经确认，修复它” -> 判断范围后进入 `requirement_probe`（`Scope: Patch`）
❌ “检查现有代码有没有 SQL 注入风险” -> 创建 patch spec

### Step 2: Locate Change Context（最小集优先）

只读定位文档：

1. `AGENTS.md`
2. `docs/ai/progress.md`

从 `docs/ai/progress.md` 识别当前活跃 spec，并按本次变更范围处理：

**情况 A：只有一个活跃 spec**
→ 暂不加载状态锚点，仅在目标 skill 需要时加载。

**情况 B：有多个活跃 spec**

- 用户只说“继续/恢复”且未给出目标 -> 列出所有活跃 spec 并要求确认。
- 用户提出具体补丁或需求 -> 仅根据摘要与必要的状态锚点判断是否交叉；无交叉则并行处理，无需选择。
- 同一模块、接口、数据契约、验收目标或改动文件存在实质交叉，且无法安全拆分 -> 列出相关 spec，请用户决定合并、排序或调整范围。

用户确认后，只加载所选或发生交叉的 spec 状态锚点。

**情况 C：没有活跃 spec**
→ 不加载任何 spec，继续识别路由。

仅在意图为非 `context_sync` 的变更请求时，补载：

- `docs/ai/spec/index.md`（若存在）
- `docs/ai/knowledge/lessons/workflow.md`（若存在）

`docs/ai/architecture.md` 不在此步骤加载；由目标 skill 按需读取。

### Step 3: Identify Change Route

- 新项目初始化、旧文档体系迁移到 OMS v3、或已有 OMS 档案需要重新扫描对账 -> `project_init`
- 恢复上下文 -> `context_sync`
- 新需求或补丁需求 -> `requirement_probe`
- 同一条消息同时包含“恢复/继续”和具体新需求或补丁 -> 先 `context_sync`，随即进入 `requirement_probe`
- 发现新能力、缺失 capability docs、或代码结构长出新的 frontend/API/data/ops/domain concern -> `capability_bootstrap`
- Draft 方案评审 -> `feature_confirm` (`review`)
- 执行包已确认 -> `feature_confirm` (`lock`)
- 已批准的实现开始落地 -> `code_implement_confirm`
- 发现需求/设计/验证不闭环 -> `workflow_repair`
- 声称完成、修复或验收通过 -> `verification_gate`

补丁需求进入 `requirement_probe` 并标注 `Scope: Patch`；不相关的活跃 spec 不是门禁。

### Step 4: Check Gates

检查：

- 是否存在目标或冲突 spec 的状态锚点
- 目标 spec 是否处于正确节点
- 是否仍处于 `DesignDraft`，或是否已有执行包批准
- 当前任务是否暴露新的 capability signal，但对应文档尚未建立
- 是否应该先修复而非继续前进

不把其他活跃 spec 的存在本身视为门禁；只处理实际交叉造成的冲突。

### Step 5: Route

若检测到 new capability growth 或 capability docs 缺口，应优先建议 `capability_bootstrap`。
若意图属于初始化、迁移或对账，先路由到 `project_init`。

**静默路由规则**：以下场景跳过完整报告，直接进入目标 skill：

- **意图 = 纯 `context_sync` 且只有一个活跃 spec**：直接加载 `context_sync`。若同条消息还带有具体新需求，不适用静默路由。
- **意图 = `feature_confirm (review)`，spec 处在 `DesignDraft`，门禁无缺失**：直接进入 `feature_confirm (review)`。

其他变更请求正常输出路由报告。

## Red Flags - STOP

- 文档状态与用户描述不一致，但你准备忽略继续
- 用户语气急迫，你感到“先做再说”的冲动
- 意图包含多个变更目标，但你只选了其中一个没有说明原因
- 你把范围无交叉的并行补丁误当成流程冲突
- 用户只说“继续”且有多个活跃 spec，你却自行选择

## Output

```markdown
## 工作流状态

**当前 Spec**: ...（目标或相关冲突 spec）
**当前节点**: ...
**识别意图**: ...
**建议技能**: ...
**需要读取的文档**:
- ...

**缺失门禁**:
- ...

**并行判断**: 无交叉，可并行 | 存在交叉，待确认
**下一步建议**: 先执行项目初始化扫描（`project_init`） | 先恢复项目上下文（`context_sync`） | 先进入需求澄清（`requirement_probe`） | 先补建能力文档（`capability_bootstrap`） | 当前流程存在缺口，建议先修复（`workflow_repair`）
```

> 纯诊断不输出此报告，直接开始分析。多 spec 仅在“继续”目标不明或范围实质交叉时需要确认。

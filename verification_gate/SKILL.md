---
name: verification_gate
description: 在准备声称完成、验收通过或归档时核验新鲜证据，并完成经验提取与知识收口。
---

# 验证门禁

OMS v3 的完成门禁。没有新鲜证据，不能把 `Verifying` 说成完成；验收通过后必须完成一次知识收口，不再依赖用户主动维护。

**执行时宣告**："[verification_gate] 核验完成证据并收口知识..."

## Iron Law

```
没有新鲜运行证据不能声称完成；没有知识收口结果不能静默归档。
```

## When to Use

- `code_implement_confirm` 已将工作推进到 `Verifying`。
- AI 准备声称完成、修复或验收通过。
- 用户明确说“需求验证通过”或“验收通过”。

## Instructions

### Step 1: Confirm Current State

读取 spec 状态锚点、验收标准、实施包、相关 testing lessons、`architecture.md`（若存在），以及当前 lessons 中与本次经验相关的条目；确认 `Current_Node: Verifying`。

### Step 2: Run Fresh Evidence

按架构和项目规则重新执行测试、构建、验收步骤及必要的手动检查。旧日志、旧记忆或子代理报告不能替代本轮证据。

### Step 3: Verify Line By Line

逐条核对验收标准，并检查设计阶段形成的关键决策是否有实现和验证证据。任何未覆盖决策、失败检查或环境问题，都不能推进归档。

### Step 4: Close Knowledge Before Archive

验收证据通过后依次执行：

1. 调用 `lesson_capture`，从用户纠正、设计决策、实现修正、测试/审查结果和重复模式中提取经验。
2. 调用 `knowledge_review(auto)`，合并规则指纹、检查 owner 边界，并自动处理低风险条目；未满足条件的条目仍留在原 lessons 中。
3. 确认收口结果为“已固化”“待继续验证”“冲突待处理”“已替代/已过期”“一次性内容”或“无新增经验”；不得无结果跳过。

知识收口失败但业务证据完整时，可以归档业务 spec，但必须在输出中说明“知识收口未完成”及失败原因，并保留原 lessons 条目，不能伪装成已完成沉淀。

### Step 5: Archive And Sync

`advance` 时：

- 更新 `docs/ai/progress.md`，移除当前活跃 spec；
- 更新 `docs/ai/spec/index.md`，将当前条目标记为 `Archived`；
- 普通需求归档不再生成或追加对应的 `docs/ai/history/<feature>.md`；完整需求档案只保留在 `docs/ai/spec/`；
- 只有初始化、发布、治理审计等事件才写入 `docs/ai/history/`。

结果只能是 `stay`、`advance` 或 `repair_required`。`advance` 输出证据、逐条验收核对和知识收口结果。

## Red Flags - STOP

- 准备声明完成但没有本轮实际运行输出。
- 验收标准或关键决策没有逐条证据。
- 自动固化准备覆盖冲突的 owner 规则。
- 业务已归档但知识收口失败且没有说明未完成原因。

## Output

> 完整输出模板见 `verification_gate/references/output-templates.md`。

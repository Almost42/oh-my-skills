---
name: verification_gate
description: 在准备声称完成、验收通过或归档时核验新鲜证据；优先复用未变更工作树的验证快照，按风险执行最小必要验证，并完成条件式知识收口。
---

# 验证门禁

OMS v3 的完成门禁。验收必须有覆盖标准的新鲜证据；同一工作树已有有效快照时，不重复执行相同命令。

**执行时宣告**："[verification_gate] 核验完成证据并收口知识..."

## Iron Law

```
没有覆盖验收标准的新鲜证据不能归档；有效验证快照可以复用，不得为形式重复运行。
```

## When to Use

- `code_implement_confirm` 已将工作推进到 `Verifying`。
- AI 准备声称完成、修复或验收通过。
- 用户明确说“验收完毕”“验收通过”或“验证完成”。

## Instructions

### Step 0: Select Verification Profile

- `fast`：存在实施阶段生成的验证快照，且当前实现文件指纹未变、快照覆盖全部验收标准。复用快照，不重复跑同一命令。
- `focused`：默认路径；快照缺失、失效或覆盖不足时，先跑一次能覆盖最多验收项的定向命令，再只补缺失项。
- `full`：仅在用户/Spec 明确要求，或涉及集成/E2E、公共契约、数据库迁移、权限安全、部署配置、跨模块边界时使用。不要因“验收完毕”自动升级为全量。

快照的“未变更”只比较执行包涉及的代码、测试和配置文件；验收过程自身的 spec、progress、lesson 写入不使快照失效。
这里“新鲜”以最近一次实现变更为边界，不要求在用户输入“验收完毕”后机械重复同一命令。

### Step 1: Load Minimum Context

按以下顺序读取：

1. spec 状态锚点，以及 `req.md` 的验收标准、`impl.md` 的测试计划/验证步骤（若存在）；
2. 状态锚点中的“验证快照”（若存在），确认 `Current_Node: Verifying`；
3. `architecture.md` 中与构建、测试、工具链相关的段落（若存在）；
4. 仅在当前模块匹配或本轮出现失败时读取 `testing` lessons。

不要为最终验收预加载完整 design、全部 owner 文档或全部 lessons。

### Step 2: Collect Fresh Evidence

1. `fast`：核对快照的实现指纹、命令结果和验收覆盖；一致时直接作为本轮证据。
2. `focused` / `full`：按已读规则执行命令；首次只执行一个定向或全量入口，必要时再补未覆盖项。
3. 测试运行器报告“无匹配测试”时，先区分选择器问题与用例失败；只允许根据运行器语义调整一次命令，不重复执行同一失败命令。
4. 默认不追加全模块构建；只有验收标准、测试计划或风险 profile 要求时才构建。

记录命令、退出结果、关键输出、覆盖的验收项和工作树/实现指纹。旧日志、记忆或子代理报告不能单独替代本轮证据。

### Step 3: Verify Acceptance Matrix

逐条建立“验收标准 → 证据”映射。只复核验收标准明确要求的设计决策；不重新审查整份设计、协议或配置。

### Step 4: Handle Failures Safely

- 真实用例失败：保持 `Verifying`，说明失败证据并回到实施或修复流程。
- 选择器/环境问题：完成一次最小诊断；仍不确定时 `stay`，不要用全量重跑掩盖原因。
- 验收门禁不得修改生产代码、测试断言或验收标准来制造通过；过期夹具/基线行为转为明确的 `repair_required`，交回实施流程处理。

### Step 5: Close Knowledge Conditionally

先判断本轮是否产生可复用候选：用户明确纠正、真实失败暴露的稳定规则、重复模式或需要长期遵守的边界。

- 无候选：直接记录知识收口为 `无新增经验`，不调用 `lesson_capture` 或 `knowledge_review(auto)`，不扫描 lessons。
- 有候选：调用 `lesson_capture` 一次；随后只对新增/受影响条目调用 `knowledge_review(auto)`，不得全量扫描。
- 知识收口失败但业务证据完整时，可以归档业务 spec，但必须输出“知识收口未完成”和失败原因，并保留原条目。

### Step 6: Archive And Sync

只有所有验收项通过且知识收口有明确结果时才 `advance`：

- 更新 `docs/ai/progress.md`，移除当前活跃 spec；
- 更新 `docs/ai/spec/index.md`，将当前条目标记为 `Archived`；
- 普通需求归档不追加 per-demand history；仅初始化、发布、治理审计写入 `docs/ai/history/`。

结果只能是 `stay`、`advance` 或 `repair_required`；`advance` 必须输出证据、验收映射、验证 profile 和知识收口结果。

## Never

- Never 在有效快照已覆盖验收项时重复跑相同命令。
- Never 对定向改动默认执行全量测试或全模块构建。
- Never 修改代码、测试断言或验收标准来消除失败。
- Never 为无新增经验启动两段知识处理或全量 lessons 扫描。

出现“为保险再跑一遍”等合理化时，按 `references/rationalization.md` 处理。

## Red Flags - STOP

- 没有有效快照且没有本轮实际运行输出。
- 实现指纹与快照不一致，却准备复用快照归档。
- 验收标准没有逐条证据，或失败项被改写成通过。
- 自动固化准备覆盖冲突的 owner 规则。
- 知识收口未完成却准备静默归档。

## Output

> 完整模板见 `verification_gate/references/output-templates.md`。

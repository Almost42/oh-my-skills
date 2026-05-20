---
name: verification_gate
description: 在 agent 准备声称工作已完成、已修复或已通过时使用，以核验新鲜证据并判断 Verifying 是否可以推进。
---

# 验证门禁

OMS v3 的完成门禁。没有新鲜证据，就不能把 `Verifying` 说成完成。

**执行时宣告**："[verification_gate] 核验完成证据..."

## Iron Law

```
没有运行新鲜证据，就不能声称完成。
"应该过了"不是证据。"之前测过"不是证据。子代理说成功不是证据。
```

## When to Use

- `code_implement_confirm` 已把工作推进到 `Verifying`。
- AI 准备声称"完成了""修好了""测试通过了"。
- 用户说"需求验收通过""验收通过""验证完成"——单个 spec 的验收确认。
- 发布或交付前需要最后一轮验证判断（此时通常由 `project_release` 统一调度）。

> **注意**：本 skill 处理的是**单个 spec 的验收完成**，不是版本级定版。版本级定版由 `project_release` 负责。

## Instructions

### Step 1: Confirm Current State

先读取：

1. spec 状态锚点（`docs/spec/YYYY-MM-DD-{slug}.md` 或 `docs/spec/YYYY-MM-DD-{slug}/index.md`）
2. 若 multi-file spec：读取 `req.md`（验收标准）和 `impl.md`（测试计划、验证步骤）
3. `docs/knowledge/lessons/testing.md`（若存在）
4. **读取 `docs/architecture.md`（若存在）**：与 `code_implement_confirm` 同样优先关注 `## 构建与验证`、`## 开发环境与工具约定` 等；未分节则读全文。验证阶段选用的构建/测试命令必须与文档及 `AGENTS.md` 中的明确约定一致，**禁止**凭记忆或通例执行。
5. 确认 `Current_Node: Verifying`

### Step 2: Run Fresh Evidence

必须基于当前工作区重新执行（命令选择遵循 Step 1 的 architecture/AGENTS 约定）：

- 测试
- 构建
- 验收步骤
- 必要的手动检查

✅ 运行 `npm test`，看到 "34/34 pass"，粘贴完整输出
❌ "上次跑测试是通过的，应该还好"

旧日志、旧记忆、对子代理的信任，都不能替代新鲜证据。

### Step 3: Verify Acceptance Criteria Line By Line

逐条核对 `req.md`（或"验收标准"）中的每一项：

- [ ] 每条验收标准是否有对应的证据？
- [ ] 是否存在验收标准没有对应测试/检查的情况？

不得只凭"测试通过"跳过验收标准的逐条核对。

### Step 4: Decide The Gate Result

结果只能是：

1. `stay`：继续留在 `Verifying`，还缺证据或还有未完成项
2. `advance`：验收通过，**自动同步 `docs/progress.md`**，spec 进入完成状态。后续由 `project_release` 统一归档
3. `repair_required`：发现需求、设计或实现假设不成立，转到 `workflow_repair`

### Step 5: Report Evidence And Auto-Sync

`advance` 时自动更新 `docs/progress.md`，然后输出验证结果。spec 标记为已完成。

用户可见输出必须同时展示证据和当前状态。`advance` 不输出"下一步建议"路由。

**不在这一步触发 `project_release`**——定版是版本级操作，由用户明确说"发布/定版"时触发，一次性归档所有已完成的 spec。

## Red Flags - STOP

- 准备声明完成但没有这轮的实际运行输出
- 用"看起来""应该""理论上""逻辑上"描述验证状态
- 把子代理的"成功"报告当作本轮验证证据
- 验收标准没有逐条核对，只看"测试通过"

## Rationalization 防御

常见理由与实际含义对照表见 `references/rationalization.md`。

## Output

> 完整模板见 `references/output-templates.md`

**stay** — 输出证据日志 + 验收标准核对 + 缺失证据，建议回到 `code_implement_confirm`。

**advance** — 不输出"下一步建议"。输出证据日志 + 验收标准核对（全部通过），自动同步 progress。定版由 `project_release` 统一处理。

**repair_required** — 输出受阻原因，路由到 `workflow_repair`。

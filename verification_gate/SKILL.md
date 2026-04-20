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
- 发布或交付前需要最后一轮验证判断。

## Instructions

### Step 1: Confirm Current State

先读取：

1. spec 状态锚点（`docs/spec/YYYY-MM-DD-{slug}.md` 或 `docs/spec/YYYY-MM-DD-{slug}/index.md`）
2. 若 multi-file spec：读取 `req.md`（验收标准）和 `impl.md`（测试计划、验证步骤）
3. `docs/knowledge/lessons/testing.md`（若存在）
4. 确认 `Current_Node: Verifying`

### Step 2: Run Fresh Evidence

必须基于当前工作区重新执行：

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
2. `advance`：验证满足，可以进入正常完成或 `project_release`
3. `repair_required`：发现需求、设计或实现假设不成立，转到 `workflow_repair`

### Step 5: Report Evidence And Next Step

用户可见输出必须同时展示证据和下一步。

## Red Flags - STOP

- 准备声明完成但没有这轮的实际运行输出
- 用"看起来""应该""理论上""逻辑上"描述验证状态
- 把子代理的"成功"报告当作本轮验证证据
- 验收标准没有逐条核对，只看"测试通过"

## Rationalization 防御

| 常见理由 | 实际含义 |
| :--- | :--- |
| "上次测试过了" | 上次不是现在，代码可能已变 |
| "逻辑上应该没问题" | 逻辑判断不替代运行结果 |
| "只改了很小的地方" | 小改动同样可以引入回归 |
| "构建通过了就行" | 构建通过 ≠ 功能正确 |
| "子代理说成功了" | 子代理报告需要独立验证 |

## Output

```markdown
## Verification Gate

**Current Spec**: `docs/spec/YYYY-MM-DD-...`
**Spec Mode**: single | multi
**Current Node**: Verifying
**Result**: stay | advance | repair_required

**Evidence Log** (本轮实际运行):
- 命令: ...
- 输出摘要: ...
- 通过/失败: ...

**Acceptance Criteria Check**:
- [ ] 标准 1: ...
- [ ] 标准 2: ...

**Next Action**: `code_implement_confirm` | `workflow_repair` | `project_release`
```

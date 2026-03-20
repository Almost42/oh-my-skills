---
name: verification_gate
description: Use when the agent is about to claim work is done, fixed, or passing and must verify fresh evidence while deciding whether Verifying can advance.
---

# Verification_gate

OMS v3 的完成门禁。没有新鲜证据，就不能把 `Verifying` 说成完成。

## When to Use

- `code_implement_confirm` 已把工作推进到 `Verifying`。
- AI 准备声称“完成了”“修好了”“测试通过了”。
- 发布或交付前需要最后一轮验证判断。

## Instructions

### Step 1: Confirm Current State
先确认：

- 当前 spec
- `Current_Node: Verifying`
- 需要满足的验收标准
- 本次结论必须依赖哪些验证命令或检查

### Step 2: Run Fresh Evidence
必须基于当前工作区重新执行：

- 测试
- 构建
- 验收步骤
- 必要的手动检查

旧日志、旧记忆、旧对子代理的信任都不能替代新鲜证据。

### Step 3: Decide The Gate Result
结果只能是：

1. `stay`
   - 继续留在 `Verifying`
   - 还缺证据或还有未完成项
2. `advance`
   - 验证满足，可以进入正常完成或 `project_release`
3. `repair_required`
   - 发现需求、设计或实现假设不成立
   - 转到 `workflow_repair`

### Step 4: Report Evidence And Next Step
用户可见输出必须同时展示证据和下一步。

## Output

```markdown
## Verification Gate

**Current Spec**: `docs/spec/...`
**Current Node**: Verifying
**Result**: stay | advance | repair_required

**Verification Run**:
- ...

**Evidence**:
- ...

**Next Action**: `code_implement_confirm` | `workflow_repair` | `project_release`
```

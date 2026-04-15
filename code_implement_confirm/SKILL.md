---
name: code_implement_confirm
description: 在已批准的 spec 准备进入代码实现时使用，从 ReadyForImplementation 推进到 Implementing 或 Verifying。
---

# 代码实施确认

OMS v3 的执行器。只处理已经获批的 execution package，不负责替代设计确认。

**执行时宣告**："[code_implement_confirm] 执行已批准方案..."

## Iron Law

```
只修改 execution package 明确列出的文件。
发现了其他问题？记录，不修复。
```

## When to Use

- `feature_confirm (lock)` 已把 spec 推进到 `ReadyForImplementation`。
- 用户明确要求开始执行已批准的代码改动。
- 当前工作已经在 `Implementing`，需要继续一轮实现。

## Never

- Never 修改 execution package 之外的任何文件（包括格式、注释、命名）
- Never 把"发现了一个不相关的 bug"变成"顺手修了"
- Never 修改测试来让测试通过（应该修代码，不是修测试）
- Never 把节点回退和代码回退混为一谈
- Never 因为实现不顺就静默改写 spec

## Instructions

### Step 1: Verify The Entry Gate

开始代码工作前必须确认：

1. 读取 spec 状态锚点（`docs/spec/{name}.md` 或 `docs/spec/{name}/index.md`）
2. `Status: Active`
3. `Current_Node` 为 `ReadyForImplementation` 或 `Implementing`
4. 若 multi-file spec：读取 `impl.md`（execution package 详情）和 `req.md`（验收标准）
5. 加载 `docs/knowledge/lessons/code.md`（若存在）
6. 加载 `docs/knowledge/lessons/domain.md`（若存在，域规则对实现决策有约束力）
6. 若是 `Scope: Patch`：已有获批的 patch path

若当前节点仍是 `RequirementDraft` / `DesignDraft`，不要写代码，改回 `requirement_probe`、`feature_plan` 或 `feature_confirm`。

### Step 1.5: Pre-flight Tool Check

在运行任何构建、测试或工具命令前，先验证命令可用：

- 检查所需工具是否可以在当前 shell 环境中执行（如 `mvn -v`、`npm -v`、`go version`）
- 若命令返回"command not found"、"No such file"或权限错误：
  - **立即停止**，不要尝试修复环境
  - 报告用户："工具 [X] 在当前环境中不可用，请确认是否需要全局安装、wrapper 脚本或路径配置"
  - 等待用户确认后再继续

✅ 运行 `mvn -v` 确认可用，再继续执行构建
❌ 直接运行 `mvn clean install`，失败后反复重试，没有检查工具本身是否存在

### Step 2: Record A Rollback Baseline

在修改代码前先记录 rollback baseline：

- 当前工作树/提交基线
- 将被修改的文件范围（必须与 execution package 吻合）
- 删除/新增的敏感路径

这个 rollback baseline 只负责代码回退参照，不等于节点回退。node rollback 必须单独通过 `workflow_repair` 决定。

### Step 3: Enter `Implementing` And Execute

- 第一次真正开始改代码时，把 spec 状态锚点的 `Current_Node` 设为 `Implementing`
- 按已批准 execution package 执行
- 若 `Scope: Patch`，严格沿着获批 patch path 实施

✅ 只改了 spec 列出的 `service.ts` 和 `router.ts`，共 47 行
❌ "发现 `utils.ts` 里有个函数命名不规范，顺手改了"

### Step 4: Handle Unexpected Findings

在实现过程中若发现 spec 以外的问题：

- ✅ 记录在本轮输出的"观察到但未修复"列表中，提示后续处理
- ❌ 不得在不走 `workflow_repair` 的情况下扩展 scope

### Step 5: Run Self-Check

完成一轮实现后：

- 运行相关测试、构建或验收命令
- 记录实际通过/失败情况
- 标记是否仍需继续实现，记录 lesson 或 pitfall candidates

#### 重试上限规则

**相同错误连续出现 2 次 → 立即停止，报告用户，不再重试。**

| 错误类型 | 处置方式 |
| :--- | :--- |
| `command not found` / `No such file or directory`（工具类） | 环境问题，停止，让用户确认工具安装 |
| 相同的编译错误出现 2 次 | 代码问题超出预期，停止，说明原因 |
| 网络超时连续 2 次 | 停止，让用户检查网络或镜像配置 |
| 测试失败但错误信息每次不同 | 可继续调查，但不超过 3 轮 |

Never 在没有任何变更的情况下对同一命令重试超过 2 次。

### Step 6: Decide Result Explicitly

结果只能是：

1. `stay`：保持在 `Implementing`，说明剩余工作与下一步
2. `advance`：条件满足时把 `Current_Node` 推进到 `Verifying`，然后转给 `verification_gate`
3. `repair_required`：发现需求、设计、实施边界或验收假设存在问题，转到 `workflow_repair`

## Red Flags - STOP

- 发现自己打开了 execution package 没有列出的文件
- 改动行数远超 execution package 的预估范围
- 用"顺手"、"正好"、"既然改了这里"开头的任何操作
- 测试失败后你准备修改测试而不是修改实现
- 工具命令返回 "command not found" 或 "No such file"（这是环境问题，不是代码问题）
- 同一个命令以相同的错误失败了 2 次，但你准备第 3 次重试

## Output

```markdown
## Code Implement Confirm

**Current Spec**: `docs/spec/...`
**Spec Mode**: single | multi
**Scope**: Feature | Patch
**Current Node**: ReadyForImplementation | Implementing | Verifying
**Result**: stay | advance | repair_required

**Execution Summary**:
- ...

**Observed But Not Fixed**:
- ...

**Verification Snapshot**:
- ...

**Rollback Baseline**:
- ...

**Next Action**: `code_implement_confirm` | `verification_gate` | `workflow_repair`
```

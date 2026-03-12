---
name: feature_confirm
description: >-
  将需求草案转为可实施状态，锁定技术协议，衔接编码阶段。
---

# Feature_confirm

将 Draft 状态的 spec 正式"定稿"，标志着从设计阶段进入实施阶段的门禁。

## When to Use
- 用户对 `feature_plan` 产出的 spec 草案表示认可（如"可以"、"没问题"、"就这样吧"）。
- 用户在 Draft spec 上完成了所有修改，准备开始编码。

## Instructions

### Step 1: Gather Context
- 确认用户指定的 spec 文件路径（若当前上下文中只有一个 Draft spec，则自动选定）。
- 再次快速检查 spec 中的影响分析和验收标准是否完整，不完整则先补全。

### Step 2: Lock Spec
- 将目标 `docs/spec/<feature>.md` 的 YAML 头部修改：
  - `Status: Draft` → `Status: Implementing`
  - `Version` 递增至下一小版本（如 `0.1` → `0.2`）。
- 更新 `Related_Memory` 字段，关联最新的 memory 文件（如有）。

### Step 3: Sync Project Artifacts
- 检查 `README.md` 是否需要添加该功能的占位说明（如"[WIP] 用户认证"），有需要则更新。
- 若当前存在活跃的 memory 文件，在其 `Backlog` 中添加该功能的实施条目。
- **若本次 spec 涉及架构变更**（新增模块、引入新中间件、数据模型重构、基础设施变更等），同步更新 `docs/architecture.md` 中对应的章节。

### Step 4: Validate
- 向用户确认状态变更完成，输出如下摘要：

```
## Spec 已锁定

**文件**：docs/spec/<feature>.md
**状态**：Draft → Implementing
**版本**：<旧版本> → <新版本>

下一步建议：调用 `code_implement_plan` 输出变更计划。
```

## Examples
**Example:** 确认 JWT 认证方案
User says: "方案没问题，开始做吧"
Actions:
1. 将 `docs/spec/jwt-auth.md` 状态改为 `Implementing`，版本 `0.1` → `0.2`。
2. 在 `README.md` 添加 `[WIP] JWT 认证` 占位。
3. 输出确认摘要，建议执行 `code_implement_plan`。

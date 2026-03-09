---
name: code_implement_plan
description: >-
  在改动代码前，输出具体的变更计划供人类审计。
---

# Code_implement_plan

代码变更的"施工图纸"——先看图再动工，让人类开发者在执行前拥有完全的知情权和否决权。

## When to Use
- 准备开始写代码之前（对应的 spec 已处于 `Implementing` 状态）。
- 用户要求"看看要改哪些东西"或"给我看变更计划"。
- **质量门禁强制要求**：任何代码变更前必须通过此 skill 确认，禁止跳过。

## Instructions

### Step 1: Gather Context
- 读取当前 `Status: Implementing` 的 spec 文件，理解要实现的功能和验收标准。
- 分析代码库中将被影响的文件和模块。

### Step 2: Cross-Spec Conflict Detection
若当前存在多个 `Status: Implementing` 的 spec，执行冲突检测：
- 将本次 spec 影响分析中的"修改文件"列表与其他活跃 spec 的影响分析交叉比对。
- 若发现同文件修改冲突，输出冲突报告：

```
## ⚠️ Spec 冲突检测

以下文件同时被多个活跃 Spec 修改：

| 冲突文件 | 当前 Spec | 冲突 Spec | 冲突性质 |
| :--- | :--- | :--- | :--- |
| src/routes/user.route.ts | jwt-auth.md | fix-login-error.md | 同函数修改 / 不同函数可并行 |

**建议**：[串行处理 — 先完成 X 再处理 Y / 可并行 — 修改位置不重叠]
```

- 用户确认处理策略后再继续输出变更树。若无冲突则跳过此步。

### Step 3: Output Change Tree
输出变更树 (Change Tree)，清晰展示所有将被改动的文件：

```
## 变更树 (Change Tree)

📁 src/
├── 🆕 auth/
│   ├── 🆕 jwt.service.ts        — JWT 签发与验证逻辑
│   └── 🆕 auth.middleware.ts    — 请求认证中间件
├── ✏️ app.module.ts              — 注册 Auth 模块
└── ✏️ routes/user.route.ts      — 添加 login/register 路由

📁 docs/
└── ✏️ spec/jwt-auth.md          — 标记实施进度

图例：🆕 新增  ✏️ 修改  🗑️ 删除
```

### Step 4: Diff Preview
对每个将被修改的文件，提供关键变更的 Diff 预览（新增文件提供核心结构概要）：

- 展示变更的核心逻辑，而非逐行全文。
- **破坏性变更 (Breaking Changes) 必须加粗高亮标注**，并解释影响范围。
- 若涉及依赖变更（新增/升级/移除第三方库），单独列出。

### Step 5: Risk Assessment
简要评估本次变更的风险：
- 是否涉及破坏性变更？影响哪些下游模块或 API？
- 是否需要数据迁移？
- 估算变更的复杂度（低 / 中 / 高）。

### Step 6: Validate
- 向用户展示完整的变更计划（变更树 + Diff 预览 + 风险评估）。
- 明确询问："**是否按照此方案执行代码修改？**"
- 若用户提出调整，就地修改计划后重新确认；用户确认后建议调用 `code_implement_confirm` 执行。

## Examples
**Example:** JWT 认证的变更计划
User says: "开始实现 JWT 认证"
Actions:
1. 读取 `docs/spec/jwt-auth.md`，确认处于 `Implementing` 状态。
2. 输出变更树：新增 2 文件，修改 2 文件。
3. 提供 Diff 预览，标注 `user.route.ts` 的路由变更为 Breaking Change。
4. 风险评估：复杂度中等，无数据迁移。
5. 询问用户确认。

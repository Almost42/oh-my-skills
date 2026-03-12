---
name: feature_plan
description: >-
  在接受新需求时，先进行架构分析并生成需求草案。
---

# Feature_plan

将模糊的需求转化为清晰的技术协议，避免"先写代码再想设计"的混乱。

## When to Use
- 用户提出新功能想法或修改现有功能。
- 用户描述了一个问题但未明确解决方案。
- AI 认为当前需求涉及架构变更，需先规划再动手。

## Instructions

### Step 1: Gather Context
- 充分理解用户需求的业务背景与期望结果。
- 判断需求的 **Scope（范围）**：
  - `Feature`：新功能或重大修改，走完整流程。
  - `Patch`：小版本修复（bug 修复、文案修正、小幅调整），可简化 spec 内容（接口协议和影响分析中的非相关项可省略），但仍需走 spec → confirm → plan → implement 流程，确保变更可追溯。
- **读取 `docs/architecture.md`**，理解当前系统的模块划分与技术选型，分析需求对现有架构的影响范围（新增模块 / 修改已有模块 / 跨模块联动）。
- **查找 `docs/anti-patterns.md` 中的反模式**，确保新方案不重蹈覆辙。
- **查找 `docs/pitfalls.md` 中的踩坑记录**，检查相关技术领域是否有已知的坑需要规避。
- **Spec 冲突检测**：检查 `docs/spec/` 中所有 `Status: Implementing` 的活跃 spec，对比其影响分析中的"修改文件"列表与当前需求的影响范围。若发现同文件修改冲突，必须：
  1. 列出冲突的文件和涉及的 spec。
  2. 评估冲突性质：是互斥修改（需串行处理）还是可兼容的并行修改。
  3. 向用户报告冲突并建议处理顺序。

### Step 2: Generate Spec Draft
在 `docs/spec/` 创建新 MD 文件，命名规则：`<feature-slug>.md`（如 `user-auth.md`）。

文件必须包含以下结构：

```markdown
---
Status: Draft
Scope: Feature | Patch
Version: 0.1
Related_Memory: [关联的 memory 文件名，若无则留空]
Created: YYYY-MM-DD
---

# [功能名称]

## 1. 业务背景 (Business Context)
[为什么要做这个功能？解决什么问题？]

## 2. 技术方案 (Technical Approach)
[架构设计、技术选型、核心逻辑流]
<!-- Scope: Patch 时，可简写为问题根因和修复方式 -->

## 3. 接口协议 (Interface Contract)
[API 定义、数据结构、模块间交互协议]
<!-- Scope: Patch 时，若不涉及接口变更可标注"无变更" -->

## 4. 影响分析 (Impact Analysis)
- **新增文件**：[列表]
- **修改文件**：[列表]
- **破坏性变更**：[有/无，详细说明]
- **依赖变更**：[有/无，详细说明]
- **与活跃 Spec 的冲突**：[无 / 有 — 列出冲突的 spec 和文件]

## 5. 验收标准 (Acceptance Criteria)
- [ ] [具体可验证的标准 1]
- [ ] [具体可验证的标准 2]
```

### Step 3: Architecture Review
对自己生成的方案进行自审：
- 是否与 `docs/anti-patterns.md` 中记录的反模式冲突？
- 是否与 `docs/architecture.md` 中描述的现有架构一致？若需突破现有架构，须明确说明理由。
- 模块化程度是否达标（避免深层嵌套、单一职责）？
- 是否存在遗漏的边界条件或异常情况？
- **冲突复查**：若影响分析中标注了与活跃 spec 的冲突，确认已向用户说明处理策略。

将审查结论附在 spec 末尾或直接向用户说明。

### Step 4: Validate
- 向用户展示 spec 草案的核心内容摘要。
- 明确告知："此 spec 当前为 **Draft** 状态，确认后我将调用 `feature_confirm` 将其转为 Implementing 状态，随后才会开始编码。"
- 若为 `Scope: Patch`，可提示用户："本次为小版本修复，spec 已简化，流程不变但内容更精简。"
- 等待用户反馈，若有修改意见则就地迭代，不创建新文件。
- **若用户驳回或修正了方案中的某个决策**，评估是否暴露了 AI 未掌握的项目约定或用户偏好。若是，立即追加到 `docs/pitfalls.md`，以便后续对话中主动规避同类问题。

## Examples
**Example 1:** 规划用户认证功能 (Feature)
User says: "我需要加一个 JWT 认证"
Actions:
1. Scope 判断为 `Feature`。
2. 检查 `docs/anti-patterns.md` — 发现曾否决 Session 方案，原因是无状态需求。
3. 检查活跃 spec — 无冲突。
4. 生成 `docs/spec/jwt-auth.md`，`Status: Draft`, `Scope: Feature`。
5. 向用户展示摘要，等待确认。

**Example 2:** 修复登录报错 (Patch)
User says: "登录接口在密码为空时返回 500，应该返回 400"
Actions:
1. Scope 判断为 `Patch`。
2. 检查活跃 spec — `jwt-auth.md` 正在 Implementing 且涉及同一文件 `user.route.ts`，标记冲突。
3. 生成 `docs/spec/fix-login-empty-password.md`，`Status: Draft`, `Scope: Patch`，影响分析中注明与 `jwt-auth.md` 存在文件冲突。
4. 建议用户先完成 JWT 认证再处理此修复，或确认两者可并行。

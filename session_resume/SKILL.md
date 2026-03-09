---
name: session_resume
description: >-
  在新对话开始时调用，通过读取历史记忆恢复 AI 的工作状态。
---

# Session_resume

解决 AI 长对话"失忆"问题，确保跨会话的逻辑链条完整继承。

## When to Use
- 开启新的对话窗口时。
- 开发者明确说"继续之前的进度"、"项目重启"或类似意图。
- AI 感知到自身对项目上下文的了解不足时，应主动建议执行此 skill。

## Instructions

### Step 1: Scan Project State
按以下优先级依次读取项目文档，构建上下文：

1. **`AGENTS.md`** — 重新加载角色定义与全局规约，确认自身身份。
2. **`docs/memory/`** — 按 memory 时间衰减策略分层读取：
   - **热区 (7 天内)**：完整读取所有文件，提取全部细节。
   - **温区 (8-30 天)**：仅读取 `Backlog` 和 `Key_Decisions`，跳过 `Context_Hash` 和 `Notes`。
   - **冷区 (30 天以上)**：不主动读取。仅在用户明确提及相关主题或 spec 的 `Related_Memory` 指向时才按需读取。
   - 若存在 `_consolidated.md` 合并摘要文件，优先读取它代替多个冷区散档。
3. **`docs/spec/`** — 扫描所有 spec 文件的 YAML 头部，识别 `Status: Implementing` 的活跃任务。
4. **`docs/history/`** — 快速浏览最近一次演进日志，了解项目已完成的里程碑及反面模式。

### Step 2: Reconstruct Context
将收集到的信息整合为结构化的上下文摘要，包含：

- **项目概况**：一句话描述项目当前阶段。
- **活跃任务**：列出所有 `Status: Implementing` 的 spec 及其核心目标。
- **待办清单**：从最新 memory 中提取的 Backlog。
- **关键约束**：最近决策中的重要约束或被否决方案（Anti-Patterns）。

### Step 3: Report to User
向用户复述恢复的上下文，格式如下：

```
## 上下文恢复报告

**项目阶段**：[概要描述]

**活跃任务**：
- [ ] [spec 文件名] — [任务目标摘要]

**待办清单** (来自最近存档 [文件名])：
1. [任务项]
2. [任务项]

**需注意的决策/约束**：
- [关键决策或 Anti-Pattern]

**Memory 状态**：
- 热区文件：X 个 (已完整加载)
- 温区文件：Y 个 (已加载摘要)
- 冷区文件：Z 个 (未加载，按需检索)

---
请确认以上信息是否准确，或补充我遗漏的上下文。
```

### Step 4: Skill Availability Check
快速检测 `AGENTS.md` 中"技能调用触发规约"声明的所有 Skill 是否在当前环境中可用。以简要的行内列表输出（无需完整表格），附加在上下文恢复报告末尾：

```
**可用 Skills**：project_init ✓ | session_resume ✓ | feature_plan ✓ | feature_confirm ✓ | code_implement_plan ✓ | code_implement_confirm ✓ | session_archive ✓ | project_release ✓
**缺失 Skills**：无 （或列出缺失项）
```

### Step 5: Validate
- 若 `docs/memory/` 为空，告知用户"未找到历史存档，将从零开始，建议先描述当前进度"。
- 若存在 `Status: Implementing` 的 spec 但 memory 中无对应记录，标记为潜在的信息断层并提醒用户。
- 若冷区文件数量超过 10 个且无合并摘要文件，建议用户在合适时机调用 `project_release` 进行 memory 合并清理。

## Examples
**Example:** 新对话恢复进度
User says: "继续昨天的工作"
Actions:
1. 读取 `docs/memory/session_20260308-1730_api-auth.md`，识别到"JWT 签名"功能正在实施。
2. 读取 `docs/spec/api-auth.md`，确认 `Status: Implementing`。
3. 向用户输出上下文恢复报告，列出待办和关键决策。

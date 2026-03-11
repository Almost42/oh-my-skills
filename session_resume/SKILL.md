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
2. **`docs/memory/`** — 读取目录下的所有 memory 文件（包括 `memory_active.md` 和任何 `session_*.md` 散档）。
3. **`docs/spec/`** — 扫描所有 spec 文件的 YAML 头部，识别 `Status: Implementing` 的活跃任务。
4. **`docs/history/`** — 快速浏览最近一次演进日志，了解项目已完成的里程碑及反面模式。

### Step 2: Consolidate Memory
将所有 memory 文件合并为唯一一份活跃文件 `docs/memory/memory_active.md`：

1. **合并规则**：
   - **Context_Hash**：仅保留最新的项目状态描述，丢弃已过时的快照。
   - **Key_Decisions**：按决策主题去重，同一主题保留最新结论；不同主题全部保留。
   - **Backlog**：合并所有待办项，去除已完成的任务，按优先级重新排列。
   - **Notes**：保留仍有参考价值的条目，丢弃已失效的临时信息。
   - **Related_Specs**：取所有文件的并集。

2. **写入 `memory_active.md`**：使用以下固定结构：

   ```markdown
   ---
   Last_Consolidated: YYYY-MM-DD HH:MM
   Source_Sessions: [被合并的 session 文件名列表]
   Related_Specs: [关联的 spec 文件列表（并集）]
   ---

   # Active Memory

   ## Context_Hash
   [合并后的项目当前状态]

   ## Key_Decisions
   | 决策 | 选择方案 | 否决方案 | 原因 |
   | :--- | :--- | :--- | :--- |
   | ... | ... | ... | ... |

   ## Backlog
   1. [P0] ...
   2. [P1] ...

   ## Notes
   [仍有价值的备注]
   ```

3. **归档旧散档**：将已合并的 `session_*.md` 文件移入 `docs/memory/.archive/`（自动创建该目录）。若项目使用 Git，归档前先确保这些文件已被 Git 追踪。

### Step 3: Reconstruct Context
将合并后的 `memory_active.md` 及 spec/history 信息整合为结构化的上下文摘要，包含：

- **项目概况**：一句话描述项目当前阶段。
- **活跃任务**：列出所有 `Status: Implementing` 的 spec 及其核心目标。
- **待办清单**：从 `memory_active.md` 中提取的 Backlog。
- **关键约束**：Key_Decisions 中的重要约束或被否决方案（Anti-Patterns）。

### Step 4: Report to User
向用户复述恢复的上下文，格式如下：

```
## 上下文恢复报告

**项目阶段**：[概要描述]

**活跃任务**：
- [ ] [spec 文件名] — [任务目标摘要]

**待办清单** (来自 memory_active.md)：
1. [任务项]
2. [任务项]

**需注意的决策/约束**：
- [关键决策或 Anti-Pattern]

**Memory 合并情况**：
- 合并散档：X 个 → memory_active.md
- 归档至 .archive/：X 个文件

---
请确认以上信息是否准确，或补充我遗漏的上下文。
```

### Step 5: Skill Availability Check
快速检测 `AGENTS.md` 中"技能调用触发规约"声明的所有 Skill 是否在当前环境中可用。以简要的行内列表输出（无需完整表格），附加在上下文恢复报告末尾：

```
**可用 Skills**：project_init ✓ | session_resume ✓ | feature_plan ✓ | feature_confirm ✓ | code_implement_plan ✓ | code_implement_confirm ✓ | session_archive ✓ | project_release ✓
**缺失 Skills**：无 （或列出缺失项）
```

### Step 6: Validate
- 若 `docs/memory/` 为空（无任何 memory 文件），告知用户"未找到历史存档，将从零开始，建议先描述当前进度"。
- 若存在 `Status: Implementing` 的 spec 但 memory 中无对应记录，标记为潜在的信息断层并提醒用户。
- 若 `docs/memory/.archive/` 中文件数量超过 10 个，建议用户在合适时机调用 `project_release` 进行历史清理。

## Examples
**Example:** 新对话恢复进度
User says: "继续昨天的工作"
Actions:
1. 读取 `docs/memory/memory_active.md` 和 `docs/memory/session_20260310-1430_api-auth.md`（新产生的散档）。
2. 将散档内容合并入 `memory_active.md`，识别到"JWT 签名"功能正在实施。
3. 将 `session_20260310-1430_api-auth.md` 移入 `docs/memory/.archive/`。
4. 读取 `docs/spec/api-auth.md`，确认 `Status: Implementing`。
5. 向用户输出上下文恢复报告，列出待办和关键决策。

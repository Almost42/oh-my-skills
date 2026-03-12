---
name: session_archive
description: >-
  压缩当前对话记忆，生成结构化存档，为跨会话延续做准备。
---

# Session_archive

将短期会话记忆固化为长期文档——确保下一次对话（或另一位 AI）能无缝接续。

## When to Use
- 对话上下文接近 token 限制时。
- 完成了一个阶段性任务后。
- 用户明确说"存档"、"保存进度"、"今天先到这里"。
- AI 主动判断当前对话已积累大量上下文，建议存档。

## Instructions

### Step 1: Gather Context
回顾当前会话中的所有关键活动：
- 完成了哪些任务？
- 做出了哪些决策（以及为什么）？
- 还有哪些未完成的任务？
- 遇到了哪些问题或被否决的方案？

### Step 2: Generate Memory File
在 `docs/memory/` 创建存档文件，命名规则：`session_YYYYMMDD-HHMM_<topic-slug>.md`。

文件必须包含以下结构：

```markdown
---
Created: YYYY-MM-DD HH:MM
Session_Topic: [本次会话主题]
Related_Specs: [关联的 spec 文件列表]
---

# Session Archive: [主题]

## Context_Hash
[当前代码状态的快照说明：哪些功能已完成、哪些文件被修改、项目处于什么阶段]

## Key_Decisions
| 决策 | 选择方案 | 否决方案 | 原因 |
| :--- | :--- | :--- | :--- |
| [决策1] | [选A] | [选B] | [为什么A优于B] |

## Backlog
按优先级排列的待办任务：
1. [P0] [最高优先级任务]
2. [P1] [次优先级任务]
3. [P2] [可延后任务]

## Notes
[其他值得记录的信息、风险提醒、技术债务等]
```

### Step 3: Knowledge Review (会话级知识审核)
回顾本次会话，草拟拟新增的知识条目并**呈现给用户审核**：

**3a. 草拟 Pitfalls（技术坑 + 协作坑）：**
- **技术坑**：平台限制、库的隐藏行为、环境差异等。
- **协作坑**：用户驳回或修正了 AI 方案的场景——这些暴露了项目特定的约定、用户偏好或 AI 的认知盲区，应固化为可复用的认知校准（如"设计列表接口前必须确认分页策略"）。

**3b. 草拟 Anti-Patterns（若本次会话中有被明确否决的设计方案）：**
- 从 Key_Decisions 中识别设计层面的否决决策，草拟拟新增的条目。

**3c. 呈现审核清单，用户确认后写入对应文件。** 若用户认为某条不值得记录或需要修正措辞，就地调整。若本次会话无新增知识则跳过。

### Step 4: Update Related Specs
- 检查当前 `Status: Implementing` 的 spec 文件，在其 `Related_Memory` 字段中添加本次存档文件名。

### Step 5: Validate
- 确认存档文件已成功写入 `docs/memory/`。
- 向用户输出存档摘要：

```
## 存档完成

**文件**：docs/memory/session_YYYYMMDD-HHMM_<topic>.md
**关键决策**：X 条
**待办任务**：Y 条
**知识审核**：新增 Pitfalls X 条，Anti-Patterns Y 条（用户已确认）

下次开启新对话时，调用 `session_resume` 即可恢复上下文。
```

## Examples
**Example:** 阶段性存档
User says: "今天先到这里"
Actions:
1. 回顾会话：完成了 JWT 签发逻辑，修改了 3 个文件，决定用 RS256 而非 HS256。
2. 生成 `docs/memory/session_20260309-1730_jwt-auth.md`。
3. 草拟知识审核：Pitfalls 1 条（RS256 需额外配置公钥路径），Anti-Patterns 1 条（否决 HS256）。用户确认后写入。
4. 更新 `docs/spec/jwt-auth.md` 的 `Related_Memory` 字段。
5. 输出存档摘要。

---
name: project_release
description: >-
  完成版本迭代，归档需求，记录演进历程与反面模式。
---

# Project_release

版本封板——整理项目资产、沉淀经验教训，确保演进过程对"未来的自己"和"新来的 AI"都友好。

## When to Use
- 一个完整的 Minor 版本或重大功能开发完毕。
- 用户明确说"发布"、"上线"、"定版"。
- 多个 spec 已完成实施，需要统一归档。

## Instructions

### Step 1: Gather Context
- 收集本次版本包含的所有 `Status: Implementing` 的 spec 文件。
- 回顾相关的 memory 文件，提取关键决策和被否决方案。
- 确认当前版本号（从 `README.md` 或 `package.json` 等配置文件中获取）。

### Step 2: Archive Specs
- 将本次版本涉及的所有 spec 文件状态改为 `Status: Archived`。
- 在每个 spec 的 YAML 头部添加 `Archived_Date: YYYY-MM-DD`。

### Step 3: Write History Entry
在 `docs/history/` 创建版本日志，命名规则：`release_vX.Y.Z_YYYYMMDD.md`。

文件必须包含以下结构：

```markdown
---
Version: X.Y.Z
Release_Date: YYYY-MM-DD
Previous_Version: X.Y.W
---

# Release vX.Y.Z

## What's New
- [功能1]：[简要描述]
- [功能2]：[简要描述]

## Archived Specs
- `docs/spec/<feature1>.md`
- `docs/spec/<feature2>.md`

## Anti-Patterns
被否决的方案及原因，防止未来重复尝试：

| 方案 | 否决原因 | 替代方案 |
| :--- | :--- | :--- |
| [方案A] | [原因] | [实际采用的方案] |

## Technical Debt
本版本中已知但未解决的技术债务：
- [债务项1]
- [债务项2]
```

### Step 4: Consolidate Memory
对 `docs/memory/` 执行合并清理，减少碎片化存档对后续 `session_resume` 的负担：

1. **识别可合并文件**：筛选所有冷区文件（创建时间超过 30 天）且其 `Related_Specs` 中的 spec 已全部为 `Archived` 状态。
2. **生成合并摘要**：将这些文件的 `Key_Decisions` 和未完成的 `Backlog` 条目提取合并，生成一个摘要文件，命名规则：`consolidated_vX.Y.Z_YYYYMMDD.md`。

   ```markdown
   ---
   Created: YYYY-MM-DD
   Consolidated_From: [被合并的文件名列表]
   Related_Release: vX.Y.Z
   Decay_Tier: consolidated
   ---

   # Memory Consolidated: vX.Y.Z

   ## Key_Decisions (merged)
   | 决策 | 选择方案 | 否决方案 | 原因 | 原始来源 |
   | :--- | :--- | :--- | :--- | :--- |
   | [决策1] | [选A] | [选B] | [原因] | [原文件名] |

   ## Residual Backlog
   从已归档会话中遗留的未完成任务（若仍有效则迁移至最新 memory 的 Backlog）：
   - [任务项] (来源: [原文件名])

   ## Notes
   [合并过程中发现的值得保留的信息]
   ```

3. **清理原始散档**：合并完成后，删除被合并的原始文件。**此操作需用户确认**——先列出将被删除的文件清单，用户确认后再执行。
4. **迁移遗留任务**：若 `Residual Backlog` 中存在仍然有效的任务，将其追加到最新的活跃 memory 文件的 `Backlog` 中。

### Step 5: Update Project Artifacts
- 更新 `README.md` 中的版本号。

### Step 6: Validate
- 输出版本发布报告：

```
## 版本发布报告

**版本**：vX.Y.Z
**发布日期**：YYYY-MM-DD
**归档 Spec**：X 个
**记录 Anti-Patterns**：Y 条
**技术债务**：Z 条

**Memory 清理**：
- 合并散档：X 个 → consolidated_vX.Y.Z_YYYYMMDD.md
- 迁移遗留任务：Y 条
- 当前 memory 目录文件数：Z 个

所有相关 spec 已归档，history 已记录，memory 已合并，README 已更新。
```

- 自检项目整体架构描述与代码现状是否一致，有不一致处向用户提示。

## Examples
**Example:** 发布 v1.2.0
User says: "JWT 认证功能做完了，定版吧"
Actions:
1. 将 `docs/spec/jwt-auth.md` 状态改为 `Archived`。
2. 创建 `docs/history/release_v1.2.0_20260309.md`，记录 JWT 功能及 Anti-Patterns（否决了 Session 方案）。
3. 更新 `README.md` 版本号 `v1.1.0` → `v1.2.0`。
4. 输出版本发布报告。

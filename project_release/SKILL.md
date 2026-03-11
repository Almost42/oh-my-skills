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

### Step 4: Clean Memory Archive
由于 `session_resume` 已在每次恢复时将散档合并入 `memory_active.md`，此步骤仅做归档目录的清理：

1. **清理 `.archive/`**：检查 `docs/memory/.archive/` 中的散档，删除其 `Related_Specs` 已全部为 `Archived` 状态的文件（这些信息已沉淀到 `docs/history/` 中，不再需要保留）。**此操作需用户确认**——先列出将被删除的文件清单，用户确认后再执行。
2. **精简 `memory_active.md`**：移除 `Key_Decisions` 中仅与本次已归档 spec 相关的条目（这些决策已记录在 history 中），清理已完成的 Backlog 条目。

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
- 清理归档散档：X 个已删除
- memory_active.md 已精简：移除 Y 条已归档决策

所有相关 spec 已归档，history 已记录，memory 已清理，README 已更新。
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

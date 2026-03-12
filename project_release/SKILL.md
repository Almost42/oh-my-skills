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

### Step 3: Knowledge Review (知识审核门禁)

本步骤是知识固化前的**人工审核关卡**。AI 从以下来源提取本版本积累的知识，草拟后呈现给用户审核：

**来源**：memory 文件中的 Key_Decisions、当前对话上下文中的决策与修正、已有的 `docs/pitfalls.md` 中本版本期间新增的条目。

**3a. 草拟 Anti-Patterns（设计层面被否决的方案）：**
- 从 memory 的 Key_Decisions 和当前对话上下文中提取被否决的设计方案。
- 以表格形式草拟拟新增的条目（方案、否决原因、替代方案、发现版本）。
- 若没有 memory 文件（用户未使用 session_archive），应从当前对话上下文中回溯提取。

**3b. 草拟 Pitfalls（实操和协作层面的踩坑）：**
- 回顾本版本开发过程中是否有未记录的技术坑或协作坑。
- 列出拟新增的条目。

**3c. 呈现审核清单：**

```
## 知识审核

### 拟新增 Anti-Patterns（→ docs/anti-patterns.md）
| 方案 | 否决原因 | 替代方案 | 发现版本 |
| :--- | :--- | :--- | :--- |
| [条目1] | ... | ... | vX.Y.Z |

### 拟新增 Pitfalls（→ docs/pitfalls.md）
| 问题描述 | 根因 | 解决方案/规避方式 | 关联模块 |
| :--- | :--- | :--- | :--- |
| [条目1] | ... | ... | ... |

（若无新增条目则标注"本版本无新增"）

---
请审核以上条目：确认 / 修正 / 补充 / 删除不需要的条目。
```

**3d.** 用户确认后，将审核通过的条目分别**追加**到 `docs/anti-patterns.md` 和 `docs/pitfalls.md`。Anti-patterns 每条标注 `发现版本` 为当前版本号。**不得删除或修改已有条目。**

### Step 4: Write History Entry

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

## Knowledge Updates
本版本新增 Anti-Patterns X 条、Pitfalls Y 条，详见 `docs/anti-patterns.md` 和 `docs/pitfalls.md`。

## Technical Debt
本版本中已知但未解决的技术债务：
- [债务项1]
- [债务项2]
```

### Step 5: Clean Memory Archive
由于 `session_resume` 已在每次恢复时将散档合并入 `memory_active.md`，此步骤仅做归档目录的清理：

1. **清理 `.archive/`**：检查 `docs/memory/.archive/` 中的散档，删除其 `Related_Specs` 已全部为 `Archived` 状态的文件（这些信息已沉淀到 `docs/history/` 中，不再需要保留）。**此操作需用户确认**——先列出将被删除的文件清单，用户确认后再执行。
2. **精简 `memory_active.md`**：移除 `Key_Decisions` 中仅与本次已归档 spec 相关的条目（这些决策已记录在 history 中），清理已完成的 Backlog 条目。

### Step 6: Clean Expired Pitfalls
审查 `docs/pitfalls.md` 中的**已有**条目，识别可能已过期的记录（如：相关库已升级、平台限制已解除、基础设施已更换）。**此操作需用户确认**——先列出建议清理的条目及理由，用户确认后再删除。若无过期条目则跳过。

### Step 7: Update Project Artifacts
- 更新 `README.md` 中的版本号。
- **校验 `docs/architecture.md`**：对比当前代码结构与 architecture.md 的描述是否一致。若本版本的功能引入了架构变更但 architecture.md 未同步更新，立即补充。

### Step 8: Validate
- 输出版本发布报告：

```
## 版本发布报告

**版本**：vX.Y.Z
**发布日期**：YYYY-MM-DD
**归档 Spec**：X 个
**知识审核**：新增 Anti-Patterns Y 条，新增 Pitfalls Z 条（用户已确认）
**技术债务**：W 条

**Memory 清理**：
- 清理归档散档：X 个已删除
- memory_active.md 已精简：移除 Y 条已归档决策

**过期 Pitfalls 清理**：清理过期条目 X 个
**Architecture 校验**：[一致 / 已补充更新]

所有相关 spec 已归档，history 已记录，memory 已清理，README 已更新。
```

## Examples
**Example:** 发布 v1.2.0
User says: "JWT 认证功能做完了，定版吧"
Actions:
1. 将 `docs/spec/jwt-auth.md` 状态改为 `Archived`。
2. 草拟知识审核清单：Anti-Patterns 1 条（Session 方案被否决）、Pitfalls 1 条（jsonwebtoken 库需显式指定 algorithm 否则默认 HS256）。
3. 用户确认后写入 `docs/anti-patterns.md` 和 `docs/pitfalls.md`。
4. 创建 `docs/history/release_v1.2.0_20260309.md`。
5. 更新 `README.md` 版本号 `v1.1.0` → `v1.2.0`。
6. 输出版本发布报告。

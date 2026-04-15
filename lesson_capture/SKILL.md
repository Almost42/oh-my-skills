---
name: lesson_capture
description: 在修正信息需要记录时使用，自动分类写入 docs/knowledge/lessons/ 对应文件；若项目仍使用旧版单文件，先执行迁移。
---

# 纠错经验记录

OMS v3 的纠错落点。按操作类型分类写入 `docs/knowledge/lessons/`，不合并到单一文件。

**执行时宣告**："[lesson_capture] 记录并归类纠错经验..."

## When to Use

- 用户纠正了 agent 的理解、方案或行为。
- 某类错误重复出现，需要形成可执行规则。
- 一次实现偏差暴露出项目特定约束、偏好或禁区。

## Never

- Never 把所有 lesson 都写入 `docs/lessons.md`（旧版单文件，已被分类体系替代）
- Never 在未确认分类前就追加内容
- Never 跳过迁移检查直接写入分类文件（可能丢失旧有 lessons）

## Instructions

### Step 1: Check For Legacy lessons.md

首先检查项目中是否存在 `docs/lessons.md`：

**若存在 `docs/lessons.md`，且 `docs/knowledge/lessons/` 目录不存在或为空**：

执行迁移：

1. 读取 `docs/lessons.md` 的全部内容
2. 按 Step 2 的分类规则，将每条 lesson 归入对应分类
3. 创建 `docs/knowledge/lessons/` 目录（若不存在）
4. 将归类后的内容写入对应分类文件（追加模式，若文件已存在则追加）
5. 确认每条 lesson 均已迁移（逐条核对，不遗漏）
6. 迁移完成后删除 `docs/lessons.md`
7. 在本次输出中注明"已完成 lessons 迁移，原文件已删除"

**若 `docs/knowledge/lessons/` 已有内容**：跳过迁移，直接进入 Step 2。

**若 `docs/lessons.md` 不存在**：跳过迁移，直接进入 Step 2。

### Step 2: Classify The Lesson

将当前需要记录的 lesson 归入以下分类之一：

| 分类 | 写入文件 | 适用场景 |
| :--- | :--- | :--- |
| `design` | `docs/knowledge/lessons/design.md` | 需求澄清、方案设计、spec 相关的判断错误 |
| `code` | `docs/knowledge/lessons/code.md` | 实现阶段的操作失误、禁止操作、边界违反 |
| `testing` | `docs/knowledge/lessons/testing.md` | 验证/测试相关的遗漏或误判 |
| `workflow` | `docs/knowledge/lessons/workflow.md` | 节点推进、状态机、流程顺序相关 |
| `domain` | `docs/knowledge/lessons/domain.md` | 业务规则、领域特定约束、项目约定 |

若一条 lesson 跨多个分类，以"主要触发场景"为准选一个，不拆分记录。

### Step 3: Capture The Correction

记录格式（追加到对应分类文件）：

```markdown
## [YYYY-MM-DD] <简短标题>

**Context**: 发生场景
**Mistake**: 错误表现
**Correct**: 正确做法
**Rule**: 以后应遵循的简洁可执行规则
```

若对应分类文件不存在，创建文件并加上标题：

```markdown
# Lessons — <分类名>
```

### Step 4: Recommend Promotion Later

**`domain` 类 lesson 必须建议升格**：项目级约束（禁止行为、工具限制、协议规则）是永久约束，不应只停留在 `lessons/` 临时层。

- 分类为 `domain` 的 lesson → 总是建议走 `knowledge_review` 升格到 `docs/domain_rules.md` 或对应 capability doc
- 其他分类 → 若已经稳定、重复出现或具备长期价值，建议走 `knowledge_review`
- 由 `knowledge_review` 决定 promotion，而不是在这里直接 promotion

## Output

```markdown
## Lesson Captured

**Category**: design | code | testing | workflow | domain
**Written To**: `docs/knowledge/lessons/{category}.md`
**Migration**: 已完成 | 不需要 | 不适用

**Context**: ...
**Mistake**: ...
**Correct**: ...
**Actionable Rule**: ...

**Suggested Next Action**: `knowledge_review` | none
```

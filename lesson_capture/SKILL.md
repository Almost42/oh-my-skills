---
name: lesson_capture
description: 在修正信息需要记录时使用，自动分类写入 docs/knowledge/lessons/ 对应文件；它只负责短期缓冲，不负责 legacy 迁移或长期升格。
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
- Never 因为这条经验看起来“很重要”就直接改写 `docs/domain_rules.md`、`docs/architecture.md` 或 capability docs

## Instructions

### Step 1: Classify The Lesson

将当前需要记录的 lesson 归入以下分类之一：

| 分类 | 写入文件 | 适用场景 |
| :--- | :--- | :--- |
| `design` | `docs/knowledge/lessons/design.md` | 需求澄清、方案设计、spec 相关的判断错误 |
| `code` | `docs/knowledge/lessons/code.md` | 实现阶段的操作失误、禁止操作、边界违反 |
| `testing` | `docs/knowledge/lessons/testing.md` | 验证/测试相关的遗漏或误判 |
| `workflow` | `docs/knowledge/lessons/workflow.md` | 节点推进、状态机、流程顺序相关 |
| `domain` | `docs/knowledge/lessons/domain.md` | 业务规则、领域特定约束、项目约定 |

若一条 lesson 跨多个分类，以"主要触发场景"为准选一个，不拆分记录。

### Step 2: Capture The Correction

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

### Step 3: Keep It In The Buffer Layer

lesson 默认停留在缓冲层，不在当次对话中直接升格到长期 owner。

- `domain` 类 lesson → 可在收口节点建议 `knowledge_review`
- 其他分类 → 若已重复出现或具备长期价值，可在收口节点建议 `knowledge_review`
- 是否进入 `docs/domain_rules.md`、`docs/architecture.md` 或 capability docs，由 `knowledge_review` 在收口阶段决定
- 若项目仍有旧结构或 lessons owner 不清晰，应建议先走 `project_docs_optimize`

## Output

```markdown
## 经验记录结果

**分类**: 设计（design） | 实现（code） | 验证（testing） | 流程（workflow） | 领域（domain）
**写入位置**: `docs/knowledge/lessons/{category}.md`
**Owner 层级**: 短期缓冲层（temporary buffer）

**场景**: ...
**错误表现**: ...
**正确做法**: ...
**可执行规则**: ...

**建议下一步**: 后续收口时进入知识审核（`knowledge_review`） | 若 lessons 结构混乱，先整理文档（`project_docs_optimize`） | 当前无需额外动作
```

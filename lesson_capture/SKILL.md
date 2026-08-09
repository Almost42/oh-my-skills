---
name: lesson_capture
description: 在纠正、验收和复盘中提取经验，写入分类 lessons，并为自动固化保留证据。
---

# 经验捕获

OMS v3.1 的经验入口。以已有的 `lessons/{category}.md` 为唯一缓冲记录；经验状态写在条目内，不新增候选目录或重复文件。

**执行时宣告**："[lesson_capture] 提取并归类经验..."

## When to Use

- 用户纠正了 agent 的理解、方案或行为。
- 验收、测试、代码审查暴露了可复用的遗漏或禁区。
- 同类规则在多个任务中重复出现。
- `verification_gate` 或会话收口要求提取经验。

## Never

- Never 把当前需求正文复制到长期 owner 文档。
- Never 仅凭一次临时 workaround 自动写入长期 owner。
- Never 为一条经验同时创建 lesson 和独立候选文件。

## Instructions

### Step 1: Collect And Classify

从用户纠正、spec 决策、实现修正、测试/验收证据和重复模式中提取一条可执行规则，按主要触发场景归类：

| 分类 | Lesson 文件 | 可能的长期 owner |
| :--- | :--- | :--- |
| `design` | `docs/ai/knowledge/lessons/design.md` | architecture / workflow |
| `code` | `docs/ai/knowledge/lessons/code.md` | capability / domain |
| `testing` | `docs/ai/knowledge/lessons/testing.md` | testing / domain |
| `workflow` | `docs/ai/knowledge/lessons/workflow.md` | `AGENTS.md` / workflow |
| `domain` | `docs/ai/knowledge/lessons/domain.md` | domain / capability |

### Step 2: Write One Durable Entry

在对应文件追加一条记录，至少包含：

```markdown
## K-YYYYMMDD-### | [YYYY-MM-DD] <经验标题>
**状态**: 已记录
**目标归属**: `docs/ai/domain_rules.md` | `docs/ai/architecture.md` | capability doc | 无
**证据次数**: 1
**来源**: spec、验收、测试或会话位置
**规则**: ...
```

继续补充 `Context`、`Mistake`、`Correct`、适用范围和下一次验证条件。需求细节仍留在 `docs/ai/spec/`。

### Step 3: Hand Off Without Blocking

`verification_gate` 收口时自动调用 `knowledge_review(auto)`；未达固化条件的条目继续保留在原 lessons 文件，并标记为“待继续验证”或“冲突待处理”。已固化条目压缩为来源记录，避免与 owner 重复保存正文。

## Output

```markdown
## 经验记录结果

**分类**: design | code | testing | workflow | domain
**写入位置**: `docs/ai/knowledge/lessons/<category>.md`
**本次处理**: 已记录 | 已更新已有经验 | 无新增经验
**来源与证据**: ...
**后续**: 验收收口时自动判断是否固化；高风险项保留人工处理
```

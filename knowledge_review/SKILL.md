---
name: knowledge_review
description: 自动评估 lessons 经验条目，安全固化长期规则，并处理待验证、冲突和过期内容。
---

# 知识收口

OMS v3.1 的经验收口器。默认自动运行，保证用户长期不维护时仍能积累可复用规则；人工模式用于高风险、歧义和冲突项。

**执行时宣告**："[knowledge_review] 评估经验条目与长期归属..."

## Modes

- `auto`：验收或会话收口时执行，不等待用户；低风险、高置信度条目直接固化。
- `manual`：用户主动查看提案，处理高风险、冲突或需要改写的条目；用户批准前不写入高风险 owner。

## Iron Law

```
自动固化必须有证据、范围、目标 owner 和可回溯来源；冲突规则不得静默覆盖。
```

## Instructions

### Step 1: Collect And Normalize

读取匹配当前 spec 的 `docs/ai/knowledge/lessons/*`、验收结果和目标 owner。按经验编号或规则指纹合并重复条目，抽象掉需求名、一次性字段和临时方案，并检查现有规则冲突。

### Step 2: Decide The Outcome

按 `knowledge_review/references/promotion-policy.md` 评估风险和证据：

| 结果 | 文件动作 |
| :--- | :--- |
| 已固化 | 写入目标 owner 的受管区块，保留来源、证据和验证日期；原 lesson 压缩为来源记录 |
| 待继续验证 | 保留在原 lessons 条目，按适用范围作为提示性经验使用，不覆盖 owner |
| 冲突待处理 | 保留冲突证据并停止写入，不覆盖现有规则 |
| 已替代 / 已过期 | 保留简短审计记录，不再主动注入 |
| 一次性内容 | 标记原因，不进入长期 owner |

目标映射：通用治理才可进入 `AGENTS.md`；架构决策进入 `architecture.md`；领域不变量进入 `domain_rules.md`；稳定接口/数据事实进入对应 capability doc；当前需求事实只留在 spec。

### Step 3: Apply Safely

`auto` 模式只自动处理低风险且达到证据门槛的条目；中风险先标记“待继续验证”，高风险、冲突和 owner 边界不清的条目不自动覆盖。每次固化后同步 `knowledge/index.md`（若路由变化），并更新原 lesson 条目。

## Output

```markdown
## 知识收口结果

**处理方式**: 自动收口 | 人工审核
**已固化**: ... | 无
**待继续验证**: ... | 无
**冲突待处理**: ... | 无
**已替代 / 已过期 / 一次性**: ... | 无
**写入位置**: ... | 无
**来源与回溯**: 原 lesson、关联 spec、验收证据
**人工介入**: 需要 | 不需要；原因：...
```

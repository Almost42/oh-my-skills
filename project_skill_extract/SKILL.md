---
name: project_skill_extract
description: 独立分析项目文档、规则与重复流程，提炼适合沉淀为团队 skill 的候选，并在需要时生成到 `.skillshare/skills/`。它不依赖 OMS 运行时，也不负责 skill 的加载。
---

# 项目技能提取

这是一个独立技能。它的职责是从项目文档与重复流程中提炼团队 skill，而不是把项目事实搬进 skill。

**执行时宣告**："[project_skill_extract] 分析/生成团队技能..."

## Modes

- `analyze`：只分析并输出 skill 候选清单
- `scaffold`：在用户确认后，把选定 skill 生成到 `.skillshare/skills/`

## When to Use

- 团队希望把常用流程抽成项目级 skill。
- 定版/治理后发现多个重复工作流，想判断是否值得沉淀。
- 项目已有大量规则和流程文档，希望区分哪些该留在 docs，哪些该做成 skill。

## Iron Law

```
只有稳定工作流才能进入 skill。
项目事实留在 docs，不得把 source-of-truth 搬进 skill。
```

## Never

- Never 把模块事实、领域规则、路径所有权直接复制成 skill 正文
- Never 把一次性 bug 复盘或单个 spec 细节做成独立 skill
- Never 未经确认直接覆盖 `.skillshare/skills/` 中已有 skill

## Instructions

### Step 1: Read Minimum Context

优先读取：

1. `AGENTS.md`（若存在）
2. `docs/architecture.md`（若存在）
3. capability docs（若存在）
4. `docs/knowledge/lessons/*` 中与重复问题直接相关的文件
5. `docs/spec/index.md` 与必要的历史 spec / history 条目
6. `.skillshare/skills/`（若存在，用于避免重复造轮子）

避免全量读取无关 archive、audit 或 memory 文件。

### Step 2: Separate Facts From Workflows

对每个候选模式，先判断它属于哪一类：

- 项目事实：架构、路径、所有权、schema、领域规则
- 稳定工作流：可重复触发、步骤顺序稳定、带 guardrail 的执行套路
- 临时案例：一次性问题、单个 spec 细节、短期迁移说明

只有“稳定工作流”允许进入 skill。

### Step 3: Detect Skill Candidates

一个候选 workflow 只有同时满足大部分条件时才值得做成 skill：

- 在多个请求、多个 spec 或多个定版中反复出现
- 触发词稳定
- 每次都需要读取相似的一组文档
- 有非显然的顺序、边界、guardrail 或常见误区
- 写在大文档里会让上下文臃肿

### Step 4: Define The Boundary

对每个通过筛选的候选，明确：

- skill 名称
- 触发条件
- 应先读取的文档
- 常见会修改的文件范围
- guardrail 与易错点
- 期望输出

### Step 5: Write Or Propose

若为 `analyze` mode：

- 只输出 skill 候选
- 说明哪些内容应继续留在 docs

若为 `scaffold` mode 且用户已确认：

- 在 `.skillshare/skills/<skill-name>/SKILL.md` 生成 skill
- 保持项目事实通过引用 docs 获取，不在 skill 中复制
- 若目标目录已存在同名 skill，先报告差异，不静默覆盖

## Output

```markdown
## 项目技能提取结果

**本轮模式**: 仅分析候选（analyze） | 已生成团队 Skill（scaffold）

**候选技能**:
- `skill-name`: 触发条件 / 先读哪些文档 / 为什么值得存在

**应继续留在 Docs 的内容**:
- ...

**建议首批技能**:
1. ...
2. ...
3. ...

**生成位置**:
- `.skillshare/skills/...`

**下一步建议**: 确认后生成团队 Skill（`project_skill_extract scaffold`） | 若已生成，请执行 `skillshare sync` 同步到使用环境 | 当前无需额外动作
```

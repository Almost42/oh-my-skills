---
name: project_docs_optimize
description: 在 OMS 文档结构与当前规范不匹配、需要先分析再确认执行文档收敛时使用；统一承担兼容迁移、结构重组、规则导入和 owner 对齐。
---

# 项目文档收敛

OMS v3.1 的文档治理器。它负责把旧文档、外部 AI 规则和团队 skill 收敛到 owner-first 结构。

**执行时宣告**："[project_docs_optimize] 分析/收敛项目文档..."

## Modes

- `analyze`：只扫描并输出整理方案
- `apply`：仅在用户明确确认后执行整理

## When to Use

- `project_init` 发现文档结构不符合当前 OMS 规范。
- 需要把 legacy docs、旧 lessons、旧知识分层迁入 OMS。
- 需要分析 `CLAUDE.md`、`.cursor/`、`.claude/`、`.codex/` 等外部规则如何收敛。

## Iron Law

```
先报告，后执行。
先让用户看懂要迁什么，再做任何收敛动作。
```

## Never

- Never 在 `analyze` mode 写入或删除项目文档
- Never 未经用户确认直接删除 legacy 文件
- Never 让 `AGENTS.md` 建好后仍把外部规则文件当主要入口

## Instructions

### Step 1: Inventory Current Owners And Drift

扫描：

1. `AGENTS.md`
2. `docs/ai/architecture.md`
3. `docs/ai/progress.md`
4. `docs/ai/spec/`
5. `docs/ai/knowledge/index.md`
6. `docs/ai/knowledge/lessons/`
7. `docs/ai/domain_rules.md`
8. capability docs（若存在）
9. 外部 AI 规则来源：`CLAUDE.md`、`.claude/`、`.cursor/`、`.cursor/rules/`、`.codex/`、`docs/ai/` 下 AI/rules/prompt/agent 文件、常见自定义目录

识别：

- owner 缺失、职责混杂、重复知识、旧结构残留
- 仍在使用 `docs/ai/lessons.md`、`docs/ai/pitfalls.md`、`docs/ai/anti-patterns.md`
- `AGENTS.md` 是否已成为唯一 AI 入口
- `docs/ai/knowledge/index.md` 是否仍把外部规则文件当 owner
- `AGENTS.md`、`docs/ai/skills/index.md` 等 owner 文档是否仍声明 `.cursor/.agents` 镜像、指针或运行时路径
- 外部规则分类：迁入 OMS 文档 | 迁为团队 skill | 保留为 IDE 专用规则
- 区分 drift 来源（参考 `references/old-oms-signatures.md`）：命中指纹 → 旧 OMS 遗留；匹配外部工具路径 → 外部规则来源；未命中 → 需用户确认处置方式

### Step 2: Build An Analyze Report

输出至少包含：

- 收敛结论
- 当前是否建议立即执行整理
- 本次是否已修改文档
- 结构偏移与 legacy 输入
- 导入的规则来源
- 建议的 owner 映射
- 迁移候选清单：建议动作、目标位置、不迁移影响
- 用户确认单：用白话列出要决定的事项，不写内部 skill 名
- 涉及变更的文件
- 后续可手动清理或归档的文件
- `apply` 结果需写明 `CLAUDE.md` 当前角色，以及每个 `.mdc` 是“已评估后保留”还是“已迁移”

`analyze` mode 到此停止，等待用户确认。

### Step 3: Apply Confirmed Changes

仅在 `apply` mode 且用户已确认后执行：

- 补建缺失 owner 文件
- 将内容迁入 `AGENTS.md` / `architecture.md` / `domain_rules.md` / capability docs / lessons
- 若项目背景散落在其他文档中，收敛到 `docs/ai/context/project_brief.md`
- 重写 `AGENTS.md` 为唯一 AI 总入口
- 重写 `docs/ai/knowledge/index.md` 为 owner-first 路由器，不再把外部规则当 owner
- 若存在团队 skill 资产，同步生成或更新 `docs/ai/skills/index.md`
- 同步 `docs/ai/spec/index.md` 和 always-on 文档结构
- 清理 owner 文档中的 `.cursor/.agents` 镜像、指针和运行时路径约定

`docs/ai/context/` 只允许在这里或 `project_init` 中被写入/重组。
`docs/ai/history/` 只允许记录初始化、发布/归档或治理审计等事件摘要。

外部规则按确认结果处理：

- `CLAUDE.md`：保留原文做来源审计，或精简为极短兼容指引
- `.cursor/rules/*.mdc`：
  - 可复用工作流 → 迁为团队 skill
  - 长期项目规则 → 迁入 `AGENTS.md` / `domain_rules.md`
  - 纯 IDE 行为 → 保留原位
- 兼容指引只保留“请以 `AGENTS.md` 为唯一入口”这一类最小提示；迁移对照仅在本次执行结果中输出
- 面向用户的结果不要写“建议先读某文件”；若需要说明入口，改写为“后续智能体默认从这些文件恢复上下文”

## Output

```markdown
## 项目文档收敛结果

**本轮模式**: 仅分析（analyze） | 已执行整理（apply）
**收敛结论**: 当前存在结构偏移，建议先确认整理方案 | 已按确认结果完成收敛
**当前是否建议立即执行整理**: 建议先确认后执行 | 已执行完成，无需再次整理
**本次是否已修改文档**: 否，本次仅输出分析报告 | 是，已按确认结果完成调整

**结构偏移与 legacy 输入**:
- （旧 OMS 遗留）...
- （外部规则来源）...
- （未识别来源）...

**导入的规则来源**:
- ...

**建议的 Owner 映射**:
- ...

**CLAUDE.md**:
- 已精简为兼容指引 | 保留原文做来源审计

**IDE 规则评估**:
- [规则文件]：已评估，为 [纯 IDE 行为 | 项目规则]，因此 [保留原位 | 已迁移到 ...]

**迁移候选清单**:
- [文件/目录] → [建议动作] → [目标位置] → [若不迁移会怎样]

**用户确认单**:
- 1. 是否建立 AI 工作文档并以 `AGENTS.md` 作为唯一入口？
- 2. `CLAUDE.md` 是保留原文做来源审计，还是精简为极短兼容指引？
- 3. 哪些 `.mdc` / 外部规则要迁成团队 skill，哪些继续保留为 IDE 专用？

**涉及变更的文件**:
- ...

**手动清理建议**:
- ...

**是否需要用户确认**: 是（用白话列出决定） | 否
**下一步建议**: （仅在无需用户确认时输出）可直接继续后续流程
```

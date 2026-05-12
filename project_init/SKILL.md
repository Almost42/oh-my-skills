---
name: project_init
description: >-
  在项目接入 OMS v3、已有档案重新扫描对账或团队规则盘点时使用；它是可重复执行的扫描与路由入口，不直接执行重构。
---

# 项目初始化

OMS v3.1 的治理入口。它负责重复扫描项目文档与规则资产，给出 drift 报告，并在需要时路由到 `project_docs_optimize`。

**执行时宣告**："[project_init] 扫描项目文档与规则资产..."

## When to Use

- 新项目需要纳入 OMS。
- 已有项目需要按当前 OMS 标准重新扫描 docs、spec、rules 或团队 skill 资产。
- 怀疑现有文档结构、旧知识层次或外部规则来源与当前规范不一致。

## Instructions

### Step 1: Scan Governance Assets

扫描：

1. `AGENTS.md`
2. `docs/`
3. `docs/spec/`
4. `docs/knowledge/index.md`
5. `docs/knowledge/lessons/`
6. `docs/domain_rules.md`
7. capability docs（若存在）
8. 外部 AI 规则来源：`CLAUDE.md`、`.claude/`、`.cursor/`、`.cursor/rules/`、`.codex/`、`docs/` 下 AI/rules/prompt/agent 相关文件、常见自定义目录
9. `.skillshare/skills/`（若存在）

识别：

- always-on 文档是否缺失
- docs/spec/knowledge/domain/capability 结构是否符合当前 OMS 规范
- 是否存在 legacy knowledge / lessons / 旧规则来源
- `docs/context/` 是否仍只承载项目背景，`docs/history/` 是否仍只承载事件摘要
- 团队是否已有 `.skillshare/skills/` 资产

### Step 2: Determine Whether Drift Exists

`project_init` 不判断“是不是 v2”。它只判断“是否不符合当前 OMS 规范”。

若发现以下任一情况，记为 drift：

- 缺失 baseline owner 文件
- `AGENTS.md`、`progress.md`、`spec/index.md`、`knowledge/index.md` 职责混杂
- lessons / domain / capability / architecture 的 owner 边界不清
- spec 结构或命名不规范
- 外部 AI 规则尚未映射进 OMS owner
- `.skillshare/skills/` 存在但尚未被盘点

### Step 3: Build A Report, Do Not Mutate

输出：

- `Drift Findings`
- `Legacy Compatibility Findings`
- `Imported AI Rule Sources`
- `Current Team Skills (.skillshare)`
- `Proposed Adjustments`
- `Needs User Approval`

不得在此阶段直接迁移、删除、重写或重组文档。

### Step 4: Route Explicitly

- 若存在文档结构漂移、legacy 输入或 AI 规则导入需求 → `project_docs_optimize (analyze)`
- 若 baseline 已符合规范且可继续工作 → `context_sync`
- 若只缺 capability owner 文档且结构稳定 → `capability_bootstrap`
- 若 spec / progress 状态不闭环 → `workflow_repair`

## Output

```markdown
## 项目初始化扫描结果

**项目**: ...
**识别到的技术栈**: ...

**漂移发现**: ...
**兼容性发现**: ...
**导入的 AI 规则来源**: ...
**当前团队 Skills（.skillshare）**: ...
**建议调整项**: ...
**是否需要用户批准**: yes | no

**下一步动作**: `project_docs_optimize (analyze)` | `context_sync` | `capability_bootstrap` | `workflow_repair`
```

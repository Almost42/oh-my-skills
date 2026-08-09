---
name: project_init
description: >-
  在项目接入 OMS v3、已有档案重新扫描对账或团队规则盘点时使用；它是可重复执行的扫描与路由入口，不直接执行重构。
---

# 项目初始化

OMS v3.1 的治理入口。它负责重复扫描项目文档与规则资产，给出面向开发者的初始化结论，并在需要时路由到 `project_docs_optimize`。

**执行时宣告**："[project_init] 扫描项目文档与规则资产..."

## When to Use

- 新项目需要纳入 OMS。
- 已有项目需要按当前 OMS 标准重新扫描 docs、spec、rules 或团队 skill 资产。
- 怀疑现有文档结构、旧知识层次或外部规则来源与当前规范不一致。

## Never

- Never 默认执行 `README`、`make init`、构建、起服务或其他开发侧初始化
- Never 把开发环境可用性问题混入 OMS 扫描主结论
- Never 不创建 `docs/ai/memory/`；会话快照只由 `session_archive` 按需启用，`session_resume` 仅在 baseline 不足时读取

## Instructions

### Step 1: Scan Governance Assets

扫描：

1. `AGENTS.md`
2. `docs/ai/`
3. `docs/ai/spec/`
4. `docs/ai/knowledge/index.md`
5. `docs/ai/knowledge/lessons/`
6. `docs/ai/domain_rules.md`
7. capability docs（若存在）
8. 外部 AI 规则来源：`CLAUDE.md`、`.claude/`、`.cursor/`、`.cursor/rules/`、`.codex/`、`docs/ai/` 下 AI/rules/prompt/agent 相关文件、常见自定义目录
9. `docs/ai/skills/`（若存在）

生成时使用本 skill 内置模板：`project_init/templates/AGENTS.v3.md`、`project_init/templates/project_brief.v3.md`、`project_init/templates/architecture.v3.md`、`project_init/templates/progress.v3.md`、`project_init/templates/knowledge-index.v3.md`、`project_init/templates/history-entry.v3.md`。
识别：

- always-on 文档是否缺失
- docs/ai/spec/knowledge/domain/capability 结构是否符合当前 OMS 规范
- 是否存在 legacy knowledge / lessons / 旧规则来源
- `docs/ai/context/` 是否仍只承载项目背景，`docs/ai/history/` 是否仍只承载事件摘要
- 团队是否已有 `docs/ai/skills/` 资产
- 若存在 `docs/ai/skills/`，是否已生成 `docs/ai/skills/index.md`
- owner 文档是否仍声明 `.cursor/agents/skills/`、`.agents/skills/`、镜像指针或 IDE 运行时路径
- **路径规范性**：检查 AI 生成内容（spec、progress、knowledge 等）是否直接位于 `docs/` 下而非 `docs/ai/` 下（路径不规范）

### Step 2: Determine Whether Drift Exists

`project_init` 不判断“是不是 v2”。它只判断“是否不符合当前 OMS 规范”。

若发现以下任一情况，记为 drift：

- 缺失 baseline owner 文件
- `AGENTS.md`、`progress.md`、`spec/index.md`、`knowledge/index.md` 职责混杂
- lessons / domain / capability / architecture 的 owner 边界不清
- lessons 条目缺少状态、来源或目标 owner，或长期规则与 owner 重复/冲突
- spec 结构或命名不规范
- 外部 AI 规则尚未映射进 OMS owner
- `docs/ai/skills/` 存在但尚未被盘点
- `docs/ai/skills/` 已存在但缺少 `docs/ai/skills/index.md`
- OMS owner 文档仍保留 `.cursor/.agents` 镜像目录或运行时指针约定
- AI 生成内容未收敛到 `docs/ai/` 下（仍直接位于 `docs/` 根层级）

### Step 3: Build A Developer-Facing Report, Do Not Mutate

输出：

- 初始化结论
- 当前是否符合 OMS 规范
- 当前是否可以直接继续工作 / 提出新需求
- 发现的问题（按“阻塞项 / 建议优化 / 仅记录”分组）
- 外部 AI 规则来源盘点
- 当前团队 Skills（`docs/ai/skills/`）
- 建议调整项
- 是否需要用户确认

默认只输出 OMS 扫描结果，不附带开发环境初始化、构建链检查或 README 执行结果。

不得在此阶段直接迁移、删除、重写或重组文档。

报告必须明确写出：

- 本次是否修改了文档；默认应为“未修改任何文档，仅完成扫描”
- 当前项目是“已基本合规”“存在可选优化”还是“存在需要先确认的结构偏移”
- 用户下一步最适合做什么，而不是只给内部 skill 名
- 若补充提及开发侧扫描，必须明确标注为“可选后续动作”，且前提是 OMS 侧无需先整改
- 面向首次接触 OMS 的用户时，避免直接输出 `project_docs_optimize`、`context_sync`、`capability_bootstrap`、`workflow_repair`、`baseline`、`owner` 等术语，统一改写成白话动作
- 若已经在“是否需要用户确认”中明确列出当前要确认的事项，默认不再输出展开式“下一步建议”；避免重复推动用户

### Step 4: Route Explicitly

- 若存在文档结构漂移、legacy 输入或 AI 规则导入需求 → `project_docs_optimize (analyze)`
- 若 AI 内容未收敛到 `docs/ai/`（路径不规范）→ 作为阻塞项上报，建议 `project_docs_optimize (analyze)` 执行目录迁移
- 若 baseline 已符合规范且可继续工作 → `context_sync`
- 若只缺 capability owner 文档且结构稳定 → `capability_bootstrap`
- 若 spec / progress 状态不闭环 → `workflow_repair`

仅当 baseline 已基本合规、且用户明确希望继续补充开发检查时，才可在结尾追加一句自然语言建议，提示后续可单独执行 README / 构建 / 运行环境扫描；这不属于 `project_init` 默认输出。

内部可以按 skill 路由，但对用户展示“建议调整项 / 是否需要用户确认 / 下一步建议”时，只写下一步动作，不写 skill 名。

- 当前文档已基本合规，可以继续恢复项目上下文或直接开始新需求
- 存在文档结构偏移，建议先确认是否要建立 AI 工作文档，并把现有规则整理到统一位置
- 缺少某类能力文档，建议先补齐对应的能力说明
- 当前 spec 或进度状态不闭环，建议先修复流程状态

若 `是否需要用户确认 = 是`，`下一步建议` 默认省略；只有当前无需用户确认时，才输出一句简短的下一步动作。

## Output

```markdown
## 项目初始化扫描结果

**项目**: ...
**识别到的技术栈**: ...

**初始化结论**: 当前文档已基本符合 OMS 规范 | 存在可选优化项 | 存在需要先确认的结构偏移
**当前是否可继续工作**: 可以直接继续 | 建议先处理部分问题 | 不建议继续，需先确认调整
**本次是否已修改文档**: 否，本次仅完成扫描与对账

**阻塞项**:
- ...
（路径不规范时在此列出，例如："AI 生成内容仍直接位于 `docs/` 根层级，未收敛到 `docs/ai/`，建议迁移后继续"）

**建议优化**:
- ...

**仅记录信息**:
- ...

**导入的 AI 规则来源**:
- ...

**当前团队 Skills（docs/ai/skills/）**:
- ...

**建议调整项**:
- ...

**是否需要用户确认**: 是（用白话写清要确认的决定） | 否

**下一步建议**: （仅在无需用户确认时输出）可直接继续后续需求流程
```

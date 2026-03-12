---
name: project_init
description: >-
  用于项目冷启动，建立符合 VibeCoding 规约的文件架构。
---

# Project_init

建立项目的"骨架"与"宪法"，确保 AI 和人类开发者在统一的规则下协作。

## When to Use
- 用户明确要求"初始化项目"或"开启新项目"。
- 项目目录中缺失 docs/ 结构或 AGENTS.md 文件。

## Instructions

### Step 1: Gather Context
- 确认项目名称与核心技术栈（用于填充模版中的专业领域）。
- 确认目标根目录路径。
- **扫描项目现状**：检查目标目录中已有的代码文件、配置文件、目录结构，识别语言、框架、数据库、构建工具等技术栈组件。若目录为空则跳过扫描，技术栈以用户提供的信息为准。

### Step 2: Create Directory Structure
在项目根目录建立以下目录（已存在则跳过）：

```
docs/
├── spec/       # 需求详述，状态驱动
├── memory/     # 会话记忆，解决长对话失忆问题
└── history/    # 演进日志，记录项目成长
```

### Step 3: Generate AGENTS.md

在项目根目录生成 `AGENTS.md`，**严格遵循以下模版结构**，严禁随意删减章节或规约。根据 Step 1 收集到的技术栈信息对模版中的变量进行替换。

若项目根目录已存在 `AGENTS.md`，**不得覆盖**——跳过本步骤并提示用户手动审查现有文件是否需要更新。

````markdown
# AGENTS.md - 项目 AI 协作指令集

## 1. 角色定义 (The Persona)

- **身份**：首席全栈架构师 (Chief Architect)。
- **特质**：追求底层逻辑，拒绝浅尝辄止。在编写代码前必须确保架构逻辑的闭环。
- **专业领域**：{{根据用户提供的技术栈填写，示例：Java, Node.js, TypeScript (Full-stack), React/Next.js}}。
- **沟通语言**：始终使用中文回复，关键概念在括号内标注英文。
- **思考准则**：缺乏必要信息时应主动向用户说明，应当存在主见、不应无脑赞同用户。

## 2. 核心维护协议 (Maintenance Protocol)

你必须严格管理以下文件，确保它们是项目的"唯一事实来源"：

| 目录/文件 | 维护规范 | 核心要素 |
| :--- | :--- | :--- |
| `README.md` | 项目全景图。仅在重大功能上线或环境变更时更新。 | 架构图、技术栈、快速启动。 |
| `AGENTS.md` | 本文件。当发现协作流程漏洞或新增全局编码规约时更新。 | 身份定义、文档准则、编码原则。 |
| `docs/spec/` | 需求详述。状态驱动。**禁止在 Draft 状态下编写生产代码。** | 头部必须包含 YAML：`Status` (Draft/Implementing/Archived), `Version`, `Related_Memory`, `Scope` (Feature/Patch)。 |
| `docs/memory/` | 会话记忆。采用"散档 → 合并 → 归档"机制：`session_archive` 生成带时间戳的散档，`session_resume` 将散档合并入 `memory_active.md`，已合并的散档移入 `.archive/`，`project_release` 时清理过期归档。 | 包含：`Context_Hash` (代码快照说明), `Key_Decisions` (决策原因), `Backlog` (待办任务栈)。 |
| `docs/architecture.md` | 架构说明。描述系统模块划分、技术选型依据、数据流与关键设计决策。功能锁定（`feature_confirm`）涉及架构变更时更新。 | 模块边界、技术栈选型理由、数据流、基础设施。 |
| `docs/anti-patterns.md` | 反模式汇总。跨版本累积，每次版本发布时追加新条目，**不做删除**。 | 包含：方案、否决原因、替代方案、发现版本。 |
| `docs/pitfalls.md` | 踩坑记录。**发现时立即追加**。覆盖两类场景：①技术坑——平台限制、库的隐藏行为、环境差异；②协作坑——用户驳回或修正了 AI 的方案时暴露的项目约定、用户偏好、AI 认知盲区。`project_release` 时清理已过期条目。 | 包含：问题描述、根因、解决方案/规避方式、关联模块。 |
| `docs/history/` | 演进日志。记录项目成长的每一步。 | 功能清单、归档 spec、技术债务。 |

## 3. 工作流管线 (Workflow Pipeline)

本项目遵循严格的阶段化工作流，禁止跳过前置阶段：

需求规划(`feature_plan`) → 方案锁定(`feature_confirm`) → 变更计划(`code_implement_plan`) → 代码执行(`code_implement_confirm`)

辅助流程：`project_init`(冷启动) | `session_resume`/`session_archive`(跨会话连续性) | `project_release`(版本归档)

若当前环境提供了对应的 Skill / 插件，应优先使用；否则按照目标自行完成。

## 4. 质量门禁 (Quality Gates)
- **变更审计**：任何代码变更前，必须通过 `code_implement_plan` 确认，禁止直接在大文件中进行未声明的全局替换。
- **规则合并**：若项目同时存在 `.cursor/rules/` 等工具特定的规则文件，以工具原生规则系统的优先级为准。本文件作为工具无关的基线协议，与工具特定规则互补而非覆盖。
- **Spec 冲突检测**：当存在多个 `Status: Implementing` 的 spec 时，`code_implement_plan` 必须检测各 spec 影响分析中是否存在同文件修改冲突，发现冲突时报告用户并暂停。

## 5. 编码与架构原则
- **模块化优先**：优先考虑模块化设计，避免深层嵌套与上帝对象（God Object）。
- **注释纪律**：注释应解释"为什么"（设计决策、业务约束、被否决的替代方案），而非"做了什么"。禁止叙述性注释。
- **防踩坑机制**：设计层面的否决方案记录到 `docs/anti-patterns.md`，实操层面的坑记录到 `docs/pitfalls.md`。
````

**模版变量说明：**
- `{{根据用户提供的技术栈填写}}` — 用 Step 1 中确认的技术栈替换，如用户未明确则根据项目代码分析结果填写。

### Step 3b: Merge Existing Tool-Specific Rules

若项目中已存在 `.cursor/rules/` 目录或 `.cursorrules` 文件：
1. 读取其中与**项目特定约定相关的规则**（排除通用格式化规则等已被工具原生处理的内容）。
2. 将提取的规则追加到 `AGENTS.md` 末尾，以 `## 6. 项目自定义规则` 章节呈现。
3. **保留原始的 `.cursor/rules/` 文件不做删改。**

若不存在任何工具特定规则文件，跳过此步骤。

### Step 4: Generate or Update README.md
- 若 `README.md` 不存在，生成包含项目名称、技术栈、快速启动说明的初始版本。
- 若已存在，保持不变。

### Step 5: Generate Baseline Documents

基于 Step 1 的扫描结果，生成以下基线文档：

1. **`docs/architecture.md`**（架构说明，基于代码扫描生成初版）：

```markdown
# Architecture

## 模块划分
[从代码结构中识别的模块边界，若为空项目则标注"待规划"]

## 技术选型
| 层级 | 技术 | 选型理由 |
| :--- | :--- | :--- |
| [语言/框架/数据库/...] | [...] | [...] |

## 数据流
[核心数据流转路径，若为空项目则标注"待设计"]

## 关键设计决策
[从现有代码中识别到的架构模式与约定，若为空项目则标注"全新项目，尚无既有决策"]
```

2. **`docs/anti-patterns.md`**（反模式汇总，初始为空表头）：

```markdown
# Anti-Patterns

| 方案 | 否决原因 | 替代方案 | 发现版本 |
| :--- | :--- | :--- | :--- |
```

3. **`docs/pitfalls.md`**（踩坑记录，初始为空表头）：

```markdown
# Pitfalls

| 问题描述 | 根因 | 解决方案 / 规避方式 | 关联模块 |
| :--- | :--- | :--- | :--- |
```

4. **`docs/history/v0-init.md`**（零号里程碑）：

```markdown
---
Version: v0
Date: YYYY-MM-DD
Type: Init
---

# v0 — 项目初始化

## 技术栈基线
[Step 1 扫描结果 + 用户提供的技术栈信息]

## 目录结构快照
[项目当前的树状结构]
```

5. 将技术栈分析结果同步填入 `AGENTS.md` 的"专业领域"字段。

### Step 6: Validate
- 输出项目树状结构 (Tree Structure)。
- 逐条检查 `AGENTS.md` 是否包含模版要求的全部 5 个章节：角色定义、核心维护协议、工作流管线、质量门禁、编码与架构原则。
- **技能就绪检查**：检测以下 Skill 是否在当前环境中可用：`project_init`, `session_resume`, `feature_plan`, `feature_confirm`, `code_implement_plan`, `code_implement_confirm`, `session_archive`, `project_release`。以表格形式输出检查结果（格式仅作参考）：

  | Skill 名称 | 状态 |
  | :--- | :--- |
  | `...` | 已就绪 / 未安装 |


  若存在未安装的 skill，明确告知用户哪些 skill 缺失，并建议其安装后再开始正式开发。

## Examples

**Example:** 初始化项目
User says: "调用 project_init，技术栈是 Spring Boot + React"
Result:
1. 扫描项目目录，识别已有代码的技术栈（若为空项目则以用户提供信息为准）。
2. 创建 `docs/spec/`, `docs/memory/`, `docs/history/` 目录。
3. 生成 `AGENTS.md`，专业领域填写为 `Java, Spring Boot, React, TypeScript`。
4. 检测到 `.cursor/rules/coding-style.mdc`，提取项目特定规则追加到 AGENTS.md 第 6 章节（无已有规则则跳过）。
5. 生成或保留 `README.md`。
6. 生成 `docs/architecture.md`（初版架构说明）、`docs/anti-patterns.md`（空表头）、`docs/pitfalls.md`（空表头）和 `docs/history/v0-init.md`。
7. 输出树状结构，验证 AGENTS.md 完整性，输出技能就绪检查表。

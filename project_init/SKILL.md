---
name: project_init
description: >-
  用于新项目冷启动，建立符合 VibeCoding 规约的文件架构。
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

````markdown
# AGENTS.md - 项目首席 AI 架构师指令集

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
| `AGENTS.md` | 本文件。当发现协作流程漏洞或新增全局编码规约时更新。 | 身份定义、文档准则、技能触发逻辑。 |
| `docs/spec/` | 需求详述。状态驱动。**禁止在 Draft 状态下编写生产代码。** | 头部必须包含 YAML：`Status` (Draft/Implementing/Archived), `Version`, `Related_Memory`, `Scope` (Feature/Patch)。 |
| `docs/memory/` | 会话记忆。用于解决长对话"失忆"问题。遵循时间衰减策略：热区(≤7天)完整读取、温区(8-30天)仅读摘要、冷区(>30天)按需检索。`project_release` 时合并冷区散档。 | 包含：`Context_Hash` (代码快照说明), `Key_Decisions` (决策原因), `Backlog` (待办任务栈), `Decay_Tier` (衰减层级)。 |
| `docs/history/` | 演进日志。记录项目成长的每一步。 | **必须包含 [Anti-Patterns] (反面模式)**：记录被否决的方案及原因，防止重复踩坑。 |

## 3. 技能调用触发规约 (Skill Triggers)

你拥有外挂的 MCP 技能库支持。请根据当前场景主动建议或执行对应的 Skill：

| 场景 (Scenario) | 推荐 Skill (Tool Call) | 执行目标 |
| :--- | :--- | :--- |
| **项目冷启动** | `project_init` | 建立目录树，初始化 `AGENTS.md` 镜像规则。 |
| **开启新对话/恢复中断任务** | `session_resume` | 读取最新的 `memory` 和 `spec`，重构当前任务上下文。 |
| **收到新功能/需求变更** | `feature_plan` | 分析需求，在 `spec/` 下生成草案并进行架构评估。 |
| **方案达成一致** | `feature_confirm` | 将草案状态改为 `Implementing`，更新技术协议。 |
| **准备编写代码** | `code_implement_plan` | 输出变更树、**Diff 预览**，并标注 **Breaking Changes**。 |
| **代码执行与自测** | `code_implement_confirm` | 执行文件写入，并根据 `spec` 运行测试用例。 |
| **会话接近上限/任务阶段性完成** | `session_archive` | 执行上下文压缩，生成带时间戳的 `memory` 文件。 |
| **版本定版发布** | `project_release` | 归档 `spec`，更新版本号，合并冷区 memory，记录 `history` 中的反面模式。 |

## 4. 质量门禁 (Quality Gates)
- **变更审计**：任何代码变更前，必须通过 `code_implement_plan` 确认，禁止直接在大文件中进行未声明的全局替换。
- **冲突处理**：若工具生成的 `.rules` 文件与本文件冲突，必须以 `AGENTS.md` 为准，并要求 AI 修正工具配置。
- **Spec 冲突检测**：当存在多个 `Status: Implementing` 的 spec 时，`code_implement_plan` 必须检测各 spec 影响分析中是否存在同文件修改冲突，发现冲突时报告用户并暂停。

## 5. 编码与逻辑风格
- **架构倾向**：优先考虑模块化设计，避免深层嵌套。
- **文档化编码**：所有核心逻辑函数必须包含简洁的注释，解释其在业务全景图中的位置。
- **容错处理**：在 `docs/history/` 中记录所有被否决的方案，防止未来重复尝试。
````

**模版变量说明：**
- `{{根据用户提供的技术栈填写}}` — 用 Step 1 中确认的技术栈替换，如用户未明确则使用 `Java, Node.js, TypeScript (Full-stack), React/Next.js` 作为默认值。

### Step 4: Generate or Update README.md
- 若 `README.md` 不存在，生成包含项目名称、技术栈、快速启动说明的初始版本。
- 若已存在，保持不变。

### Step 5: Validate
- 输出项目树状结构 (Tree Structure)。
- 逐条检查 `AGENTS.md` 是否包含模版要求的全部 5 个章节：角色定义、核心维护协议、技能调用触发规约、质量门禁、编码与逻辑风格。
- **技能就绪检查**：对照 `AGENTS.md` 中"技能调用触发规约"表格声明的所有 Skill，逐一检测当前环境中是否已安装对应的 skill。检测方式为查看当前可用的 skill 列表（如通过 `skillshare` CLI 或扫描 skills 目录）。以表格形式输出检查结果（格式仅作参考）：

  | Skill 名称 | 状态 |
  | :--- | :--- |
  | `...` | 已就绪 / 未安装 |


  若存在未安装的 skill，明确告知用户哪些 skill 缺失，并建议其安装后再开始正式开发。

## Examples
**Example:** 初始化 Project_DEMO
User says: "调用 project_init 开启新项目 Project_DEMO，技术栈是 Spring Boot + React"
Result:
1. 创建 `docs/spec/`, `docs/memory/`, `docs/history/` 目录。
2. 生成 `AGENTS.md`，其中专业领域填写为 `Java, Spring Boot, React, TypeScript`。
3. 生成 `README.md` 初始版本。
4. 输出树状结构并验证 AGENTS.md 完整性。
5. 输出技能就绪检查表，告知用户 特定 skill 的安装状态。

# Oh My Skills

一套可复用的 AI 编程协作规则框架，通过 8 个 Skill 定义 AI 辅助软件开发的完整生命周期协议。

## 它解决什么问题？

当你用 AI 编程工具（Cursor、Claude、Windsurf 等）开发真实项目时，你会遇到这些痛点：

- **失忆**：每次新对话，AI 都忘了之前做过什么。
- **失控**：AI 想到哪写到哪，没有先规划后执行的流程约束。
- **失据**：决策没有记录，同一个错误方案被反复尝试。
- **失联**：多会话之间无法接力，任务断裂。

Oh My Skills 通过 `AGENTS.md`（项目宪法）+ `docs/` 三目录（制度）+ 8 个 Skill（SOP）构成一套治理体系，让 AI 像一个**有记忆、有规矩、有流程**的资深工程师一样工作。

## 核心架构

```
项目冷启动 ──→ 恢复上下文 ──→ 需求规划 ──→ 方案锁定 ──→ 变更计划 ──→ 代码执行 ──→ 进度存档 ──→ 版本发布
project_init → session_resume → feature_plan → feature_confirm → code_implement_plan → code_implement_confirm → session_archive → project_release
                    ↑                                                                                                    │
                    └────────────────────────────────────────────────────────────────────────────────────────────────────────┘
                                                          （循环）
```

## Skill 清单

| Skill | 职责 | 触发场景 |
| :--- | :--- | :--- |
| `project_init` | 建立项目骨架，生成 `AGENTS.md` 和 `docs/` 目录结构 | 新项目冷启动 |
| `session_resume` | 按时间衰减策略读取 memory，恢复跨会话上下文 | 开启新对话或恢复中断任务 |
| `feature_plan` | 将需求转化为结构化 spec 草案，含冲突检测和 Anti-Pattern 回溯 | 收到新功能或需求变更 |
| `feature_confirm` | 锁定 spec 状态为 Implementing，衔接编码阶段 | 用户确认方案 |
| `code_implement_plan` | 输出变更树、Diff 预览、跨 spec 冲突检测、风险评估 | 准备编写代码 |
| `code_implement_confirm` | 执行代码变更、自测、输出实施报告，含回滚机制 | 用户确认变更计划 |
| `session_archive` | 将会话记忆固化为结构化存档，带时间衰减元数据 | 对话接近上限或阶段性完成 |
| `project_release` | 归档 spec、合并冷区 memory、记录演进历程与反面模式 | 版本定版发布 |

## 项目目录结构

执行 `project_init` 后，目标项目中将生成以下结构：

```
<your-project>/
├── AGENTS.md              # 项目宪法：角色定义、维护协议、技能触发规约、质量门禁
├── README.md              # 项目全景图
└── docs/
    ├── spec/              # 需求详述（状态驱动：Draft → Implementing → Archived）
    ├── memory/            # 会话记忆（时间衰减：热区 → 温区 → 冷区 → 合并归档）
    └── history/           # 演进日志（含 Anti-Patterns 反面模式记录）
```

## 关键设计理念

### Spec 状态机

每个需求通过 `docs/spec/` 中的 Markdown 文件管理，遵循严格的状态流转：

```
Draft ──→ Implementing ──→ Archived
  ↑            │
  └────────────┘  (回滚时回退至 Draft)
```

- **Draft**：草案阶段，禁止编写生产代码。
- **Implementing**：已锁定，可进入编码。
- **Archived**：版本发布时归档。

Spec 支持两种 Scope：
- **Feature**：完整功能，走全套流程。
- **Patch**：小版本修复（bug 修复、文案修正），流程不变但 spec 内容可简化。

### Memory 时间衰减

`docs/memory/` 中的存档文件按创建时间自动分层，降低旧记忆对上下文窗口的占用：

| 层级 | 时间范围 | 读取策略 |
| :--- | :--- | :--- |
| 热区 (Hot) | ≤ 7 天 | 完整读取所有字段 |
| 温区 (Warm) | 8 - 30 天 | 仅读取 Backlog 和 Key_Decisions |
| 冷区 (Cold) | > 30 天 | 不主动读取，按需检索 |

版本发布时，`project_release` 会将冷区散档合并为摘要文件，防止 memory 目录无限膨胀。

### 冲突检测（双重防线）

当多个 spec 同时处于 Implementing 状态时：

1. **规划时检测**（`feature_plan`）：新 spec 生成前，交叉比对所有活跃 spec 的影响分析。
2. **执行前确认**（`code_implement_plan`）：输出变更树前，再次校验文件级冲突。

### 回滚机制

`code_implement_confirm` 在执行前记录回滚基线（Git commit hash），验收失败时支持：
- Git 项目：`git reset --hard` 一键回滚。
- 非 Git 项目：按变更计划手动还原。
- Spec 状态回退至 Draft，回滚事件记入 memory 供后续参考。

## 快速开始

### 1. 安装

通过 [skillshare](https://github.com/AtelierSnek/skillshare) CLI 安装（推荐）：

```bash
skillshare install https://github.com/Almost42/oh-my-skills.git
```

或手动将 `skills/` 目录下的各 Skill 文件夹复制到你的 AI 工具的 skills 目录中。

### 2. 初始化项目

在 AI 对话中说：

> "调用 project_init 开启新项目 MyProject，技术栈是 Spring Boot + React"

AI 将自动创建 `AGENTS.md`、`docs/` 目录结构和 `README.md`。

### 3. 日常使用

- **开始新对话**："继续之前的进度" → 触发 `session_resume`
- **提出需求**："我需要加一个用户认证功能" → 触发 `feature_plan`
- **确认方案**："方案没问题，开始做吧" → 触发 `feature_confirm` → `code_implement_plan`
- **执行编码**："确认，开始写代码" → 触发 `code_implement_confirm`
- **保存进度**："今天先到这里" → 触发 `session_archive`
- **版本发布**："功能做完了，定版吧" → 触发 `project_release`

## 兼容性

这套规则框架是**工具无关**的，适用于任何支持自定义 Skill / Agent 指令的 AI 编程工具：

- Cursor（通过 Skills 目录）
- Claude Code（通过 AGENTS.md）
- Windsurf（通过 Rules）
- 其他支持 Markdown 指令的 AI 工具

## License

[The Unlicense](LICENSE) — 公共领域，自由使用。

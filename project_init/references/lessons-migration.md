# Lessons 迁移与 Spec 结构规范化（Step 5.5 详细说明）

## Lessons 迁移

### 触发条件

| 情况 | 处置 |
| :--- | :--- |
| `docs/lessons.md` 存在，`docs/knowledge/lessons/` 不存在或为空 | 执行迁移 |
| `docs/knowledge/lessons/` 已有内容 | 跳过，报告"lessons 已为分类格式" |
| `docs/lessons.md` 不存在 | 跳过，报告"无旧版 lessons 文件" |

### 迁移步骤

1. 读取 `docs/lessons.md` 全部内容
2. 按以下分类将每条 lesson 写入对应文件：

| 分类 | 写入文件 | 关键词 |
| :--- | :--- | :--- |
| 需求/设计类 | `docs/knowledge/lessons/design.md` | 需求理解、方案判断、spec 错误 |
| 实现类 | `docs/knowledge/lessons/code.md` | 编码操作、禁止行为、边界违反 |
| 验证/测试类 | `docs/knowledge/lessons/testing.md` | 测试遗漏、验证误判 |
| 流程/节点类 | `docs/knowledge/lessons/workflow.md` | 节点推进、状态机错误 |
| 业务规则类 | `docs/knowledge/lessons/domain.md` | 领域约束、项目规定 |

3. 逐条确认迁移完整（不遗漏任何条目）
4. 确认完成后删除 `docs/lessons.md`

## Spec 结构感知

扫描 `docs/spec/` 目录：

| 发现 | 处置 |
| :--- | :--- |
| 缺少 `docs/spec/index.md` | 用模板补建，并按现有 spec 填入简略索引 |
| `docs/spec/create-task.md` 或 `docs/spec/create-task/` 这类旧路径缺少 `YYYY-MM-DD-` 日期前缀 | 优先用 `Created` frontmatter 或可确认历史日期补齐；无法确认时报告并等待用户确认 |
| `docs/spec/YYYY-MM-DD-{slug}.md` 超过 150 行 | 在 Report 中标记"建议拆分为 multi-file spec"，不自动执行 |
| `docs/spec/YYYY-MM-DD-{slug}/index.md`（multi-file）| 格式正确，确保根索引存在对应条目 |
| 旧格式 spec 缺少 `Split_Mode` 字段 | 在 Report 中标记需补充该字段 |

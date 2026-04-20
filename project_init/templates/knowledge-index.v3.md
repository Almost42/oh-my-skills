# 知识索引

## 加载规则

- 当任务具有广泛相关性时，加载 `common` 知识。
- 当任务涉及对应技术栈时，加载 `stack:*` 知识。
- 当 spec 涉及对应模块时，加载 `module:*` 知识。
- 只有当前任务确实依赖时，才加载 `capability:*` 或 `flow:*` 知识。
- **Lessons 按操作类型精准加载**（见下方 Lessons 路由），不全量加载。

## 知识映射

| 标签 | 文件 | 何时加载 |
| :--- | :--- | :--- |
| `common` | `docs/knowledge/pitfalls/common.md` | 广泛相关的通用注意事项 |
| `stack:example` | `docs/knowledge/pitfalls/stack-example.md` | 技术栈相关工作 |
| `module:example` | `docs/knowledge/anti-patterns/module-example.md` | 模块级策略约束 |

## Lessons 路由

Lessons 文件在对应操作类型开始前加载，不随 baseline 全量加载。

| 操作类型 / Skill | 加载文件 |
| :--- | :--- |
| 需求澄清、方案设计（`requirement_probe`、`feature_plan`、`feature_confirm`） | `docs/knowledge/lessons/design.md` |
| 代码实现（`code_implement_confirm`） | `docs/knowledge/lessons/code.md` |
| 验证、测试（`verification_gate`） | `docs/knowledge/lessons/testing.md` |
| 节点推进、状态变更（`workflow_guard`） | `docs/knowledge/lessons/workflow.md` |
| 业务规则相关操作 | `docs/knowledge/lessons/domain.md` |

Lessons 文件路径：`docs/knowledge/lessons/{design|code|testing|workflow|domain}.md`

若对应文件不存在，跳过加载，不报错。

## Spec 引用规范

- 先用 `docs/spec/index.md` 按模块和处理方向定位历史 spec，再按需加载具体状态锚点。
- Single-file spec：直接引用 `docs/spec/YYYY-MM-DD-{slug}.md`
- Multi-file spec：引用状态锚点 `docs/spec/YYYY-MM-DD-{slug}/index.md`；按需引用子文档 `docs/spec/YYYY-MM-DD-{slug}/req.md`、`design.md`、`impl.md`
- 禁止使用段落描述替代文件路径（如"docs/offerwall-refactor 相关内容"）
- 大文件内部有明确段落时，可使用锚点：`docs/spec/YYYY-MM-DD-{slug}/design.md#api-contracts`

## 迁移兼容

- 在 v3 迁移期间，仍允许读取 `docs/pitfalls.md` 和 `docs/anti-patterns.md` 作为兼容输入。
- 若项目存在 `docs/lessons.md`，应触发 `lesson_capture` 的迁移逻辑，将内容迁移至分类文件后删除原文件。
- 新的长期知识应写入 `docs/knowledge/...`。

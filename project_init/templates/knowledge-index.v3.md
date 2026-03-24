# 知识索引

## 加载规则

- 当任务具有广泛相关性时，加载 `common` 知识。
- 当任务涉及对应技术栈时，加载 `stack:*` 知识。
- 当 spec 涉及对应模块时，加载 `module:*` 知识。
- 只有当前任务确实依赖时，才加载 `capability:*` 或 `flow:*` 知识。

## 知识映射

| 标签 | 文件 | 何时加载 |
| :--- | :--- | :--- |
| `common` | `docs/knowledge/pitfalls/common.md` | 广泛相关的通用注意事项 |
| `stack:example` | `docs/knowledge/pitfalls/stack-example.md` | 技术栈相关工作 |
| `module:example` | `docs/knowledge/anti-patterns/module-example.md` | 模块级策略约束 |

## 迁移兼容

- 在 v3 迁移期间，仍允许读取 `docs/pitfalls.md` 和 `docs/anti-patterns.md` 作为兼容输入。
- 新的长期知识应写入 `docs/knowledge/...`。

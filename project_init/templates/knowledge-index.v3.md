# Knowledge Index

## Loading Rules

- Load `common` knowledge when broadly relevant.
- Load `stack:*` knowledge when a task touches the corresponding stack.
- Load `module:*` knowledge when a spec touches that module.
- Load `capability:*` or `flow:*` knowledge only when the current task depends on it.

## Knowledge Map

| Tag | File | Load When |
| :--- | :--- | :--- |
| `common` | `docs/knowledge/pitfalls/common.md` | Broadly relevant caution |
| `stack:example` | `docs/knowledge/pitfalls/stack-example.md` | Stack-specific work |
| `module:example` | `docs/knowledge/anti-patterns/module-example.md` | Module-specific strategy |

## Transitional Compatibility

- During v3 migration, legacy reads from `docs/pitfalls.md` and `docs/anti-patterns.md` remain allowed as compatibility inputs.
- New durable knowledge writes should target `docs/knowledge/...`.

# 旧版 OMS 指纹参考表

旧 OMS 版本产生的可预测文件结构。判据：路径匹配以下模式 + 内容含 OMS 特征（spec frontmatter、workflow node 声明等）。

| 路径模式 | 说明 | v3 迁移目标 |
| :--- | :--- | :--- |
| `docs/lessons.md` | v2 扁平 lessons | 拆入 `docs/ai/knowledge/lessons/` 五分类文件 |
| `docs/progress.md` | v2 进度文件 | → `docs/ai/progress.md` |
| `docs/architecture.md` | v2 架构文件 | → `docs/ai/architecture.md` |
| `docs/spec/` | v2 spec 目录 | → `docs/ai/spec/` |
| `docs/knowledge/` | v2 知识目录 | → `docs/ai/knowledge/` |
| `docs/history/` | v2 历史记录 | → `docs/ai/history/` |
| `docs/context/` | v2 项目背景 | → `docs/ai/context/` |
| `docs/domain_rules.md` | v2 领域规则 | → `docs/ai/domain_rules.md` |
| `docs/ai/` 下 `lessons.md`（非分类） | 过渡期残留 | 拆入 `docs/ai/knowledge/lessons/` |
| `docs/ai/spec/*.md` 无日期前缀 | v2 spec 命名 | 补齐 `YYYY-MM-DD-` 前缀 |

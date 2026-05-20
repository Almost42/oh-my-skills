# Spec 文件结构详情

## 命名规则

- spec 文件或目录名必须包含创建日期（精确到日），统一格式为 `YYYY-MM-DD-{slug}`；日期一旦创建不随后续更新改变。
- `slug` 使用短横线小写英文或项目既有命名，表达需求主题。
- `docs/spec/index.md` 是 spec 根索引，创建或修订 spec 时同步更新，但节点真相仍在 spec 状态锚点。

## Patch → Single-file mode

- 文件：`docs/spec/YYYY-MM-DD-{slug}.md`
- 模板：`feature_plan/templates/spec.v3.md`
- 内容完整写入单文件

## Feature → Multi-file mode

- 目录：`docs/spec/YYYY-MM-DD-{slug}/`
- 状态锚点：`index.md`（持有所有 frontmatter，状态变更只写这里）
- 需求内容：`req.md`（业务背景、需求范围、验收标准）
- 设计内容：`design.md`（技术方案、接口影响、影响分析）
- 实施包：`impl.md`（ReadyForImplementation 后由 feature_confirm 填充）
- 模板：`feature_plan/templates/spec-index.v3.md` / `spec-req.v3.md` / `spec-design.v3.md` / `spec-impl.v3.md`

正反例：
- ✅ Feature 类需求 → 创建 `docs/spec/2026-04-20-create-task/index.md` + `req.md` + `design.md` + `impl.md`（空），并更新 `docs/spec/index.md`
- ❌ Feature 类需求 → 把所有内容堆进一个 `create-task.md`

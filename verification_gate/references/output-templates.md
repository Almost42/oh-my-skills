# Output 模板

## stay（继续验证）

```markdown
## 验证门禁结果

**当前 Spec**: `docs/spec/YYYY-MM-DD-...`
**当前节点**: 验证中（Verifying）
**本轮结论**: 继续补证据或补验证（stay）

**证据日志** (本轮实际运行):
- 命令: ...
- 输出摘要: ...
- 通过/失败: ...

**验收标准核对**:
- [ ] 标准 1: ...
- [ ] 标准 2: ...

**缺失证据**:
- ...

**建议**: 回到代码实施继续补齐（`code_implement_confirm`）
```

## advance（验收通过）

```markdown
## 验证门禁结果

**当前 Spec**: `docs/spec/YYYY-MM-DD-...`
**当前节点**: 已归档（Archived）
**本轮结论**: 需求已完成（advance）

**证据日志** (本轮实际运行):
- 命令: ...
- 输出摘要: ...
- 通过/失败: ...

**验收标准核对**:
- [x] 标准 1: ...
- [x] 标准 2: ...

（已自动同步 docs/progress.md、docs/history/、docs/spec/index.md）
```

> advance 不输出"下一步建议"。验收通过后 spec 进入 `Archived`，progress/history/index 已自动更新。需求已完成，流程闭环。

## repair_required（需要修复）

```markdown
## 验证门禁受阻

**当前 Spec**: `docs/spec/YYYY-MM-DD-...`
**当前节点**: 验证中（Verifying）
**本轮结论**: 需先修复流程问题（repair_required）
**问题说明**: ...
**建议**: 转到工作流修复（`workflow_repair`）
```

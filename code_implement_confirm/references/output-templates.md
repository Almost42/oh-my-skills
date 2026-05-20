# Output 模板

## stay（继续实施）

```markdown
## 代码实施结果

**当前 Spec**: `docs/spec/...`
**当前节点**: 实施中（Implementing）
**本轮结论**: 继续实施（stay）

**执行摘要**:
- ...

**剩余工作**:
- ...

**观察到但未修复**:
- ...

**验证快照**:
- ...

**回退基线**:
- ...
```

## advance（进入验证）

> advance 不输出"下一步建议"。advance 后自动同步 progress，然后直接进入 verification_gate。

```markdown
## 代码实施结果

**当前 Spec**: `docs/spec/...`
**当前节点**: 待验证（Verifying）
**本轮结论**: 可以进入验证（advance）

**执行摘要**:
- ...

（随后自动同步 progress 并进入 verification_gate）
```

## repair_required（需要修复）

```markdown
## 代码实施受阻

**当前 Spec**: `docs/spec/...`
**当前节点**: 实施中（Implementing）
**本轮结论**: 需先修复流程问题（repair_required）
**问题说明**: ...
**建议**: 转到工作流修复（`workflow_repair`）
```

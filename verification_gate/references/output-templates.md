# Output 模板

## stay（继续验证）

```markdown
## 验证门禁结果

**当前 Spec**: `docs/ai/spec/YYYY-MM-DD-...`
**当前节点**: 验证中
**本轮结论**: 继续补证据或补验证（stay）
**验证 profile**: `focused` | `full`
**证据来源**: 本轮命令 | 验证快照（覆盖不足）

**证据日志** (验证快照或本轮运行):
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

**当前 Spec**: `docs/ai/spec/YYYY-MM-DD-...`
**当前节点**: 已归档
**本轮结论**: 需求已完成（advance）
**验证 profile**: `fast` | `focused` | `full`
**证据来源**: 验证快照复用 | 本轮命令

**证据日志** (验证快照或本轮运行):
- 命令: ...
- 输出摘要: ...
- 通过/失败: ...

**验收标准核对**:
- [x] 标准 1: ...
- [x] 标准 2: ...

（已自动同步 `docs/ai/progress.md`、`docs/ai/spec/index.md`；知识收口：`已固化 / 待继续验证 / 冲突待处理 / 无新增经验`）
```

> advance 不输出"下一步建议"。验收通过后 spec 进入 `Archived`；普通需求不生成按需求拆分的 history 副本，知识收口结果必须可追溯。

## repair_required（需要修复）

```markdown
## 验证门禁受阻

**当前 Spec**: `docs/ai/spec/YYYY-MM-DD-...`
**当前节点**: 验证中
**本轮结论**: 需先修复流程问题（repair_required）
**问题说明**: ...
**建议**: 转到工作流修复（`workflow_repair`）
```

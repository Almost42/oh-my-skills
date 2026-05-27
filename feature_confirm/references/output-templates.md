# Output 模板

## review mode（设计评审 + 锁定选项合并）

```markdown
## 方案确认结果

**本轮操作**: 方案评审（review）
**当前 Spec**: `docs/ai/spec/YYYY-MM-DD-...`
**Spec 模式**: 单文件（single） | 多文件（multi）
**范围**: 新功能/跨模块能力（Feature） | 局部修复/小范围修改（Patch）
**当前节点**: 方案设计中
**本轮结论**: 保持继续完善方案（stay） | 需先修复流程问题（repair_required）

**简洁性门禁**:
- [ ] 改动范围未超出需求
- [ ] 无顺手改的重构
- [ ] 无未被需求提及的新依赖

**执行包**:
- ...

**Patch 语义**:
- ...

**需更新文档**:
- ...

**是否确认并锁定实施**:
- 回复"确认并实施" → 我将锁定执行包，同步进度，并直接开始代码实施
- 回复"仅锁定" → 我将锁定执行包，暂不开始实施
- 如方案需调整 → 说明调整方向
```

> **关键规则**：review 输出必须包含"是否确认并锁定实施"的合并选项，不再分两次交互。

## lock mode（锁定后自动推进）

lock 一般不单独输出——作为 review 确认后的自动延续执行，完成后直接进入 code_implement_confirm。

仅在 lock 被单独调用且结果为 advance 时：

```markdown
## 方案锁定完成

**当前 Spec**: `docs/ai/spec/YYYY-MM-DD-...`
**当前节点**: 已可进入实施
**本轮结论**: 可以进入代码实施（advance）

（随后自动同步 progress 并进入 code_implement_confirm）
```

若 lock 结果为 repair_required：

```markdown
## 方案锁定受阻

**当前节点**: 方案设计中
**本轮结论**: 需先修复流程问题（repair_required）
**问题说明**: ...
**建议**: 转到工作流修复（`workflow_repair`）
```

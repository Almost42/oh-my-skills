# Output 模板

## 正常完成（DesignDraft，自动进入 review）

```markdown
## 设计草案结果

**Spec**: `docs/ai/spec/YYYY-MM-DD-...`
**范围**: 新功能/跨模块能力（Feature） | 局部修复/小范围修改（Patch）
**Spec 模式**: 单文件（single） | 多文件（multi）
**当前节点**: 方案设计中
**最近确认节点**: ...

**YAGNI 检查**:
- [ ] 所有设计项均有需求来源
- [ ] 无"以防万一"的抽象
- [ ] 最简方案可满足需求

**已加载知识**:
- ...

**潜在冲突**:
- ...

**后续需同步文档**:
- ...

（随后自动进入 feature_confirm review 进行方案评审）
```

> 不输出"下一步建议"。Draft 完成后直接进入 feature_confirm (review)。

## 需求仍不足 / 发现问题

```markdown
## 设计草案受阻

**问题**: 需求仍有缺口 / 已确认流程存在问题
**当前节点**: 方案设计中
**建议**: 回到需求澄清阶段（`requirement_probe`） | 走工作流修复（`workflow_repair`）
```

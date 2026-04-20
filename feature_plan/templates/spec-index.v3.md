---
Status: Draft | Active | Archived
Scope: Feature
Current_Node: RequirementDraft | DesignDraft | ReadyForImplementation | Implementing | Verifying | Archived
Last_Confirmed_Node: RequirementDraft
Capability_Tags:
Module_Tags:
Repair_State: None | Proposed | Confirmed | Applied
Rollback_Target:
Related_Memory:
Split_Mode: multi
Version: 0.1
Created: YYYY-MM-DD
Updated: YYYY-MM-DD
---

# <Spec 标题>

> OMS 文档正文默认使用中文；路径、代码标识符、API 名称、frontmatter 枚举值和既有英文术语可保留英文。

## Summary

一句话总结需求目标。

## 子文档

| 文件 | 内容 | 主要写入时机 |
| :--- | :--- | :--- |
| [req.md](./req.md) | 需求范围、验收标准 | `requirement_probe` → `RequirementDraft` |
| [design.md](./design.md) | 技术方案、接口影响、影响分析 | `feature_plan` → `DesignDraft` |
| [impl.md](./impl.md) | 执行包、回滚计划、测试计划 | `feature_confirm lock` → `ReadyForImplementation` |

## 执行包摘要

_(由 feature_confirm lock 时填充摘要，详情见 impl.md)_

- 改动范围：
- 预估影响文件数：
- 回滚目标：

## 工作流记录

### 修复提案

- Trigger:
- Reason:
- Suggested Rollback Target:
- Docs To Update:
- Code Revert Needed:
- User Confirmation:

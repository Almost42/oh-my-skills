---
name: code_implement_confirm
description: >-
  正式执行文件修改，落地代码变更并验证结果。
---

# Code_implement_confirm

变更计划的执行者——按照 `code_implement_plan` 确认的方案，精确执行代码变更并验证。

## When to Use
- 用户已确认 `code_implement_plan` 输出的变更方案（如"确认"、"执行"、"开始写"）。
- 严禁在未经 `code_implement_plan` 确认的情况下直接调用此 skill。

## Instructions

### Step 1: Pre-check
- 再次确认对应的 spec 文件处于 `Status: Implementing`。
- 确认变更计划未过期（若用户在确认后又进行了大量讨论或变更了需求，应建议重新执行 `code_implement_plan`）。

### Step 2: Record Rollback Snapshot
在执行变更前，记录回滚所需信息：
- 列出所有将被修改和删除的文件路径。
- 若项目使用 Git，确认当前工作区干净（无未提交的变更）。建议在执行前创建一个标记点：
  - 有 Git：执行 `git stash` 或确认最新 commit 为安全基线，记录 commit hash。
  - 无 Git：在变更计划中注明每个被修改文件的关键修改位置，作为手动回滚的参照。

### Step 3: Execute Changes
按照变更计划逐文件执行：
- **新增文件**：按计划创建，遵循项目编码风格。
- **修改文件**：精确修改计划中标注的位置，不做未声明的额外变更。
- **删除文件**：确认无引用后删除。
- 每个核心逻辑函数添加简洁注释，说明其在业务流程中的位置（遵循 AGENTS.md 编码风格要求）。

### Step 4: Self-test
根据 spec 中的验收标准进行自测：
- 若项目配置了测试框架，运行相关测试用例。
- 若无测试框架，按验收标准逐条进行逻辑自检，说明每条标准的通过情况。
- 记录在实施过程中发现的任何偏离计划的地方。

### Step 5: Record Pitfalls
回顾本次代码执行过程中是否遇到了需要 workaround 的问题（平台限制、库的隐藏行为、环境差异、非预期的 API 行为等）。若有，**立即追加**到 `docs/pitfalls.md` 表格末尾。若无则跳过。

### Step 6: Validate & Rollback Path
向用户输出实施报告：

```
## 实施报告

**关联 Spec**：docs/spec/<feature>.md

**变更摘要**：
- 新增 X 个文件
- 修改 Y 个文件
- 删除 Z 个文件

**验收标准检查**：
- [x] [标准 1] — 通过
- [x] [标准 2] — 通过
- [ ] [标准 3] — [未通过原因]

**偏离说明**：[若有，说明偏离原因及影响；若无则标注"无偏离"]

**回滚基线**：[Git commit hash / 无 Git 则标注"手动回滚参照已记录于变更计划"]

---
下一步建议：若所有标准通过，建议调用 `session_archive` 存档本次进度。
```

**若验收未通过或用户要求回滚**，按以下流程执行：
1. **有 Git**：执行 `git checkout -- <被修改文件>` 恢复修改文件，`git clean -fd <新增目录>` 清理新增文件，或直接 `git reset --hard <基线 commit hash>` 全量回滚。
2. **无 Git**：按变更计划中记录的修改位置逐一手动还原，删除新增文件。
3. 将对应 spec 状态从 `Implementing` 回退至 `Draft`，在 spec 末尾追加回滚说明（原因、时间）。
4. 在当前 memory 的 `Notes` 中记录本次回滚事件，作为后续 Anti-Pattern 的输入。

## Examples
**Example:** 执行 JWT 认证代码
User says: "确认，开始写代码"
Actions:
1. 确认 `docs/spec/jwt-auth.md` 为 `Implementing`。
2. 创建 `src/auth/jwt.service.ts`、`src/auth/auth.middleware.ts`。
3. 修改 `src/app.module.ts`、`src/routes/user.route.ts`。
4. 运行测试，输出实施报告。

---
name: requirement_probe
description: 在新请求仍不清楚、需要先生成或持续更新 req.md，并判断何时可以进入 feature_plan 时使用。
---

# 需求澄清探查

OMS v3 的需求澄清入口。首次进入时先把当前理解落成 `req.md` 和未确认问题；后续重复进入时持续更新 `req.md`，直到问题清空后再进入 `feature_plan`。

**执行时宣告**："[requirement_probe] 更新需求澄清记录..."

## Iron Law

```
先落文档，再做判断。
任何未经用户确认的假设，都必须以“待确认问题”形式显式记录。
```

## When to Use

- 用户提出新功能、补丁、需求补充或模糊修改请求。
- 当前还不能稳定产出 `design.md`，需要先澄清目标、边界、验收标准或影响面。
- 已有 spec 仍停留在需求澄清阶段，需要继续补齐 `req.md`。
- 已确认需要代码变更，准备把前置诊断结果转成 Patch/Feature 需求。

## Never

- Never 替用户补写成功标准或未确认约束
- Never 把“先帮我分析/排查”误判为“立即创建需求文档”
- Never 因为问题不多就跳过 `req.md` 落盘
- Never 把未确认事项藏在正文描述里而不单列
- Never 在未确认问题仍存在时推进到 `feature_plan`
- Never 向用户输出 OMS 内部节点名；对外统一说“需求澄清阶段”“方案设计阶段”

## Instructions

### Step 1: Read Minimum Context

优先读取：

1. `AGENTS.md`
2. `docs/ai/context/project_brief.md`（若存在）
3. `docs/ai/progress.md`
4. `docs/ai/spec/index.md`（若存在）
5. 会话当前/目标 spec，或与本次变更可能交叉的活跃 spec 状态锚点（按需）
6. 当前问题的 capability docs 与 `docs/ai/knowledge/lessons/design.md`（若存在）

不要因为“先看看再说”而整库扫描文档；纯逻辑分析、漏洞研判或日志排障不进入本 skill，先直接完成诊断，确认需要变更后再进入。

### Step 2: Decide Spec Container

- `Scope: Feature` 使用 `docs/ai/spec/YYYY-MM-DD-{slug}/` 与 `req.md`；`Scope: Patch` 使用 `docs/ai/spec/YYYY-MM-DD-{slug}.md` 并更新“业务背景 / 需求范围 / 验收标准 / 待确认问题”。

会话已有当前 spec 时默认复用它：把本轮任务作为既有目标的补充、细化或范围扩展写入原需求记录，不能仅因用户又提出一项任务而新建 spec。

只有用户明确要求独立工作项/切换，或任务明显与当前目标不兼容，才创建或选择新 spec；边界不清时写入当前 spec 的 `待确认问题`。已确认节点上出现范围扩展时改走 `workflow_repair`，不借新 spec 绕过确认。

### Step 3: Write Or Update Requirement Record

每次调用都必须先把当前已知信息写进需求文档。至少更新：

- 当前需求理解
- 业务背景 / 变更动机
- 影响对象与范围内事项
- 明确的验收标准
- 范围外或暂不处理事项
- `待确认问题`：所有仍未确认的缺口，按主题列出

写入原则：

- 已确认内容写入正文
- 未确认内容不做假设，统一写入 `待确认问题`
- 用户新回复若解决了旧问题，要从 `待确认问题` 中删除，并同步正文

### Step 4: Clarify Missing Information

围绕以下维度补齐缺口，并一次列出当前真正阻塞设计的全部关键问题：

- 目标与动机
- 影响对象
- 成功标准与失败表现
- 影响哪些模块、接口、数据、流程或领域规则
- 时间、兼容性、性能、部署或协作约束
- 这是局部问题还是系统性能力调整

✅ “我先更新 req.md，再把鉴权、返回结构、失败处理这 3 个仍阻塞设计的问题一起列出来。”
❌ “我脑补一个默认返回结构，剩下问题等设计时再说。”

### Step 5: Classify Scope And Node

显式判断：

- `Scope: Feature | Patch`
- 继续留在需求澄清阶段：
  - 仍有未确认问题
  - 目标、边界、验收或影响面还不稳定
- 可以进入方案设计阶段：
  - `待确认问题` 已清空
  - 需求意图、范围和成功标准已足够稳定，可交给 `feature_plan` 生成或修订 `design.md`

### Step 6: Identify Required Docs And Tags

输出并同步文档中的：

- 当前请求必须加载的文档
- capability tags
- module tags
- 是否需要先调用 `capability_bootstrap`
- 若后续进入设计，提醒 `feature_plan` 继续沿用当前 spec，不重建需求文档

### Step 7: Route Explicitly

- 若仍有未确认问题：保持在需求澄清阶段，等待用户补齐后再次进入本 skill
- 若问题已清空：进入 `feature_plan`
- 若发现是在已批准流程上补救需求/设计缺口：改走 `workflow_repair`

## Red Flags - STOP

- 你准备把“猜测大概率正确”直接写进已确认需求
- 需求已影响多个模块，但 `req.md` 里没有明确边界
- 用户刚补充了新约束，你却只回答问题没有更新需求文档
- 会话已有当前 spec，你却因任务措辞变化新建了平行 spec

## Output

```markdown
## 需求澄清结果

**当前阶段**: 继续需求澄清 | 可以进入方案设计
**范围判断**: Feature | Patch
**需求文档**: `docs/ai/spec/.../req.md` | `docs/ai/spec/... .md`
**需求摘要**: ...

**已确认内容更新**:
- ...

**待确认问题**:
- ...

**需要读取的文档**:
- ...

**Capability 标签**:
- ...

**Module 标签**:
- ...

**下一步建议**: 继续补充需求信息（再次调用 `requirement_probe`） | 进入方案设计阶段（`feature_plan`） | 当前问题属于流程修复（`workflow_repair`）
```

#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

PROJECT_INIT_TEMPLATE_DIR="project_init/templates"
FEATURE_PLAN_TEMPLATE_DIR="feature_plan/templates"
CAPABILITY_TEMPLATE_DIR="capability_bootstrap/templates"
PROMOTION_POLICY="knowledge_review/references/promotion-policy.md"

AGENTS_TEMPLATE="$PROJECT_INIT_TEMPLATE_DIR/AGENTS.v3.md"
PROJECT_BRIEF_TEMPLATE="$PROJECT_INIT_TEMPLATE_DIR/project_brief.v3.md"
ARCHITECTURE_TEMPLATE="$PROJECT_INIT_TEMPLATE_DIR/architecture.v3.md"
PROGRESS_TEMPLATE="$PROJECT_INIT_TEMPLATE_DIR/progress.v3.md"
KNOWLEDGE_INDEX_TEMPLATE="$PROJECT_INIT_TEMPLATE_DIR/knowledge-index.v3.md"
HISTORY_ENTRY_TEMPLATE="$PROJECT_INIT_TEMPLATE_DIR/history-entry.v3.md"
SPEC_TEMPLATE="$FEATURE_PLAN_TEMPLATE_DIR/spec.v3.md"

DESIGN_DOC=""
if [[ -f "design_v3.md" ]]; then
  DESIGN_DOC="design_v3.md"
elif [[ -f "docs/design_v3.md" ]]; then
  DESIGN_DOC="docs/design_v3.md"
fi

if [[ -n "$DESIGN_DOC" ]]; then
  for term in \
    "workflow_repair" \
    "Current_Node:" \
    "Last_Confirmed_Node:" \
    "Repair_State:" \
    "Rollback_Target:" \
    "RequirementDraft" \
    "DesignDraft" \
    "ReadyForImplementation" \
    "Implementing" \
    "Verifying" \
    "Archived" \
    "\`R17\`" \
    "\`R18\`" \
    "\`R19\`" \
    "\`R20\`" \
    "\`R21\`" \
    "\`R22\`"
  do
    rg -q "$term" "$DESIGN_DOC" || fail "design_v3.md missing $term"
  done
fi

for path in \
  "$SPEC_TEMPLATE" \
  "$PROGRESS_TEMPLATE" \
  "$AGENTS_TEMPLATE" \
  "$PROJECT_BRIEF_TEMPLATE" \
  "$ARCHITECTURE_TEMPLATE" \
  "$KNOWLEDGE_INDEX_TEMPLATE" \
  "$HISTORY_ENTRY_TEMPLATE" \
  "$CAPABILITY_TEMPLATE_DIR/frontend-guidelines.v3.md" \
  "$CAPABILITY_TEMPLATE_DIR/flows.v3.md" \
  "$CAPABILITY_TEMPLATE_DIR/interfaces.v3.md" \
  "$CAPABILITY_TEMPLATE_DIR/data-model.v3.md" \
  "$CAPABILITY_TEMPLATE_DIR/operations.v3.md" \
  "$CAPABILITY_TEMPLATE_DIR/domain-rules.v3.md" \
  "$PROMOTION_POLICY"
do
  test -f "$path" || fail "$path missing"
done

agents_lines=$(wc -l < "$AGENTS_TEMPLATE" | tr -d ' ')
[[ "$agents_lines" -le 50 ]] || fail "AGENTS.v3.md must stay within 50 lines"

while IFS= read -r skill; do
  skill_lines=$(wc -l < "$skill" | tr -d ' ')
  [[ "$skill_lines" -le 150 ]] || fail "$skill must stay within 150 lines"
done < <(find . -name SKILL.md -not -path './.git/*' -print)

rg -q "^# AGENTS.md" "$AGENTS_TEMPLATE" || fail "AGENTS.v3.md must keep AGENTS.md title"
rg -q "^# 项目简介" "$PROJECT_BRIEF_TEMPLATE" || fail "project_brief.v3.md must use Chinese title"
rg -q "^# 架构" "$ARCHITECTURE_TEMPLATE" || fail "architecture.v3.md must use Chinese title"
rg -q "^# 知识索引" "$KNOWLEDGE_INDEX_TEMPLATE" || fail "knowledge-index.v3.md must use Chinese title"
rg -q "^# 进度" "$PROGRESS_TEMPLATE" || fail "progress.v3.md must use Chinese title"
rg -q "^Type: 发布 | 里程碑 | 初始化$" "$HISTORY_ENTRY_TEMPLATE" || fail "history-entry.v3.md must use Chinese type values"
rg -q "^# 前端指南" "$CAPABILITY_TEMPLATE_DIR/frontend-guidelines.v3.md" || fail "frontend-guidelines.v3.md must use Chinese title"
rg -q "^# 流程" "$CAPABILITY_TEMPLATE_DIR/flows.v3.md" || fail "flows.v3.md must use Chinese title"
rg -q "^# 接口" "$CAPABILITY_TEMPLATE_DIR/interfaces.v3.md" || fail "interfaces.v3.md must use Chinese title"
rg -q "^# 数据模型" "$CAPABILITY_TEMPLATE_DIR/data-model.v3.md" || fail "data-model.v3.md must use Chinese title"
rg -q "^# 运维" "$CAPABILITY_TEMPLATE_DIR/operations.v3.md" || fail "operations.v3.md must use Chinese title"
rg -q "^# 领域规则" "$CAPABILITY_TEMPLATE_DIR/domain-rules.v3.md" || fail "domain-rules.v3.md must use Chinese title"

rg -q "扫描项目文档与规则资产" project_init/SKILL.md || fail "project_init must define its scan entry"
rg -q "不得在此阶段直接迁移、删除、重写或重组文档" project_init/SKILL.md || fail "project_init must remain read-only"
rg -q "本次是否修改了文档" project_init/SKILL.md || fail "project_init must report mutation status"
rg -q "存在需要先确认的结构偏移" project_init/SKILL.md || fail "project_init must report structural drift"

rg -q "旧文档体系迁移到 OMS v3" workflow_guard/SKILL.md || fail "workflow_guard must route OMS migration intent to project_init"
rg -q "重新扫描对账" workflow_guard/SKILL.md || fail "workflow_guard must route reconcile intent to project_init"

for field in \
  "Status: Draft | Active | Archived" \
  "Scope:" \
  "Current_Node:" \
  "Last_Confirmed_Node:" \
  "Capability_Tags:" \
  "Module_Tags:" \
  "Repair_State:" \
  "Rollback_Target:" \
  "Related_Memory:" \
  "Version:" \
  "Created:" \
  "Updated:"
do
  rg -F -q "$field" "$SPEC_TEMPLATE" || fail "spec.v3.md missing $field"
done

for section in \
  "## 业务背景" \
  "## 需求范围" \
  "## 技术方案" \
  "## 接口与契约影响" \
  "## 影响分析" \
  "## 验收标准" \
  "## 工作流记录" \
  "### 修复提案"
do
  rg -q "^$section" "$SPEC_TEMPLATE" || fail "spec.v3.md missing $section"
done

for bullet in \
  "Trigger:" \
  "Reason:" \
  "Suggested Rollback Target:" \
  "Docs To Update:" \
  "Code Revert Needed:" \
  "User Confirmation:"
do
  rg -q -- "- $bullet" "$SPEC_TEMPLATE" || fail "spec.v3.md missing repair bullet $bullet"
done

for section in \
  "## 当前焦点" \
  "## 活跃 Specs" \
  "当前节点" \
  "最后确认节点" \
  "下一动作"
do
  rg -q "$section" "$PROGRESS_TEMPLATE" || fail "progress.v3.md missing $section"
done

for section in \
  "## 治理定位" \
  "## 事实边界" \
  "## 加载策略" \
  "## 触发路由摘要" \
  "## 更新策略" \
  "## 工具适配策略"
do
  rg -q "^$section" "$AGENTS_TEMPLATE" || fail "AGENTS.v3.md missing $section"
done

for path in \
  "docs/ai/context/project_brief.md" \
  "docs/ai/architecture.md" \
  "docs/ai/spec/" \
  "docs/ai/progress.md" \
  "docs/ai/knowledge/index.md" \
  "docs/ai/knowledge/lessons/"
do
  rg -F -q "$path" "$AGENTS_TEMPLATE" || fail "AGENTS.v3.md missing $path reference"
done

for section in \
  "## 项目目的" \
  "## 用户或使用方" \
  "## 范围" \
  "## 非目标" \
  "## 成功标准" \
  "## 术语表"
do
  rg -q "^$section" "$PROJECT_BRIEF_TEMPLATE" || fail "project_brief.v3.md missing $section"
done

for section in \
  "## 系统形态" \
  "## 模块边界" \
  "## 跨模块依赖" \
  "## 扩展点" \
  "## 结构约束"
do
  rg -q "^$section" "$ARCHITECTURE_TEMPLATE" || fail "architecture.v3.md missing $section"
done

for term in \
  "## 加载规则" \
  "## Owner 路由" \
  "## Lessons 路由" \
  "## 经验条目状态" \
  "docs/ai/knowledge/lessons"
do
  rg -q "$term" "$KNOWLEDGE_INDEX_TEMPLATE" || fail "knowledge-index.v3.md missing $term"
done

MIGRATION_MATRIX="docs/migrations/v3-skill-matrix.md"
if [[ -f "$MIGRATION_MATRIX" ]]; then
  rg -q "Transitional Compatibility" "$MIGRATION_MATRIX" || fail "v3-skill-matrix.md missing Transitional Compatibility column"
  rg -q "\`code_implement_plan\` | Removed" "$MIGRATION_MATRIX" || fail "v3-skill-matrix.md must mark code_implement_plan as removed"
  rg -q "merged into \`feature_confirm\`" "$MIGRATION_MATRIX" || fail "v3-skill-matrix.md must describe code_implement_plan migration target"
  rg -q "primary v3 replacement for execution-package planning" "$MIGRATION_MATRIX" || fail "v3-skill-matrix.md must mark feature_confirm as the primary v3 replacement"
  rg -q "\`requirement_probe\` | Rewrite | \`RequirementDraft\`, \`DesignDraft\`" "$MIGRATION_MATRIX" || fail "v3-skill-matrix.md must show requirement_probe spanning RequirementDraft and DesignDraft"
  rg -F -q 'review and lock patch execution package while staying in `DesignDraft` until approval' "$MIGRATION_MATRIX" || fail "v3-skill-matrix.md must describe feature_confirm review/lock semantics"
fi

for dir in workflow_guard workflow_repair verification_gate knowledge_review; do
  test -f "$dir/SKILL.md" || fail "$dir/SKILL.md missing"
done

rg -q "README 是 OMS 当前版本的最新说明书" README.md || fail "README must declare itself as the latest project manual"
! rg -n "^description: Use when |^  Use when " */SKILL.md || fail "OMS skill descriptions must be Chinese"

rg -q "capability_bootstrap" workflow_guard/SKILL.md || fail "workflow_guard must route capability growth to capability_bootstrap"
rg -q "capability signal" workflow_guard/SKILL.md || fail "workflow_guard must check for capability signals"

rg -q "需求澄清阶段" requirement_probe/SKILL.md || fail "requirement_probe must define clarification stage"
rg -q "方案设计阶段" requirement_probe/SKILL.md || fail "requirement_probe must define design handoff"
rg -q "需要读取的文档" requirement_probe/SKILL.md || fail "requirement_probe must identify required docs"
rg -q "Capability 标签" requirement_probe/SKILL.md || fail "requirement_probe must identify capability tags"
rg -F -q "Scope: Feature | Patch" requirement_probe/SKILL.md || fail "requirement_probe must classify Scope: Feature | Patch"

rg -q "DesignDraft" feature_plan/SKILL.md || fail "feature_plan must target DesignDraft"
rg -q "Current_Node" feature_plan/SKILL.md || fail "feature_plan must populate Current_Node"
rg -q "Last_Confirmed_Node" feature_plan/SKILL.md || fail "feature_plan must populate Last_Confirmed_Node"
rg -q "Capability_Tags" feature_plan/SKILL.md || fail "feature_plan must populate Capability_Tags"
rg -q "Module_Tags" feature_plan/SKILL.md || fail "feature_plan must populate Module_Tags"
rg -q "docs/ai/knowledge/index.md" feature_plan/SKILL.md || fail "feature_plan must load knowledge from docs/ai/knowledge/index.md"
rg -F -q "Scope: Feature | Patch" feature_plan/SKILL.md || fail "feature_plan must preserve Scope: Feature | Patch"

rg -q "review" feature_confirm/SKILL.md || fail "feature_confirm must define review mode"
rg -q "lock" feature_confirm/SKILL.md || fail "feature_confirm must define lock mode"
rg -q "DesignDraft" feature_confirm/SKILL.md || fail "feature_confirm must keep state in DesignDraft during review"
rg -q "ReadyForImplementation" feature_confirm/SKILL.md || fail "feature_confirm must advance to ReadyForImplementation after approval"
rg -q "当前节点" feature_confirm/references/output-templates.md || fail "feature_confirm output must show current node"
rg -q "是否确认并锁定实施" feature_confirm/references/output-templates.md || fail "feature_confirm output must show confirmation choice"
rg -F -q "Scope: Patch" feature_confirm/SKILL.md || fail "feature_confirm must explain patch semantics"

test ! -e code_implement_plan/SKILL.md || fail "code_implement_plan runtime skill must be removed in final v3 handoff"

rg -q "ReadyForImplementation" code_implement_confirm/SKILL.md || fail "code_implement_confirm must require ReadyForImplementation before code work"
rg -q "repair_required" code_implement_confirm/SKILL.md || fail "code_implement_confirm must support repair_required"
rg -q "Implementing" code_implement_confirm/SKILL.md || fail "code_implement_confirm must mention Implementing"
rg -q "Verifying" code_implement_confirm/SKILL.md || fail "code_implement_confirm must mention Verifying"
rg -q "Current_Node" code_implement_confirm/SKILL.md || fail "code_implement_confirm must show current node"
rg -q "下一步" code_implement_confirm/SKILL.md || fail "code_implement_confirm must show next action"
rg -q "rollback baseline" code_implement_confirm/SKILL.md || fail "code_implement_confirm must separate rollback baseline from node rollback"
rg -q "patch path" code_implement_confirm/SKILL.md || fail "code_implement_confirm must support approved patch-path execution"

rg -q "repair_required" verification_gate/SKILL.md || fail "verification_gate must support repair_required"
rg -q "Verifying" verification_gate/SKILL.md || fail "verification_gate must stay grounded in Verifying"
rg -F -q "knowledge_review(auto)" verification_gate/SKILL.md || fail "verification_gate must run automatic knowledge closeout"
rg -F -q "普通需求归档" verification_gate/SKILL.md || fail "verification_gate must reject per-demand history"

rg -q "当前节点" progress_sync/SKILL.md || fail "progress_sync must report current node"
rg -q "下一步动作" progress_sync/SKILL.md || fail "progress_sync must report next action"
rg -q "spec" progress_sync/SKILL.md || fail "progress_sync must summarize from spec state"
rg -q "当前节点" "$PROGRESS_TEMPLATE" || fail "progress template must show node state"

rg -q "docs/ai/knowledge/lessons" lesson_capture/SKILL.md || fail "lesson_capture must target categorized lessons"
rg -q "状态" lesson_capture/SKILL.md || fail "lesson_capture must record entry state"
rg -q "已固化" knowledge_review/SKILL.md || fail "knowledge_review must describe durable closeout"
rg -q "待继续验证" knowledge_review/SKILL.md || fail "knowledge_review must describe pending verification"
rg -q "冲突待处理" knowledge_review/SKILL.md || fail "knowledge_review must describe conflict handling"
rg -q "auto" knowledge_review/SKILL.md || fail "knowledge_review must define automatic mode"
rg -q "OMS-AUTO-OWNED" "$PROMOTION_POLICY" || fail "promotion policy must define managed owner blocks"
rg -q "workflow_repair" README.md || fail "README must describe workflow_repair"
rg -F -q "feature_confirm (review / lock)" README.md || fail "README must describe feature_confirm review/lock flow"
rg -q "旧的独立 \`code_implement_plan\` 已被移除" README.md || fail "README must describe the code_implement_plan migration path"
rg -q "ReadyForImplementation" README.md || fail "README must describe ReadyForImplementation"
rg -q '默认不创建 `docs/ai/memory/`' README.md || fail "README must describe memory optionality"

! rg -n "^\| \`code_implement_plan\` \|" README.md || fail "README must not list code_implement_plan as an active skill"
if [[ -n "$DESIGN_DOC" ]]; then
  ! rg -n "Ready to code .*code_implement_plan|开始实现.*code_implement_plan|primary v3 flow.*code_implement_plan|feature_confirm → code_implement_plan|仍可被调用.*code_implement_plan|compatibility shim.*code_implement_plan" README.md "$DESIGN_DOC" || fail "active flow still routes through code_implement_plan"
else
  ! rg -n "Ready to code .*code_implement_plan|开始实现.*code_implement_plan|primary v3 flow.*code_implement_plan|feature_confirm → code_implement_plan|仍可被调用.*code_implement_plan|compatibility shim.*code_implement_plan" README.md || fail "active flow still routes through code_implement_plan"
fi
! rg -n "默认(读取|恢复|使用).*(memory_active.md|docs/memory/)|memory_active.md.*共享内存|memory_active.md.*唯一活跃快照|docs/memory/.*默认必建" README.md || fail "memory-first wording remains"

rg -q "当前节点" workflow_repair/SKILL.md || fail "workflow_repair must show current node in output"
rg -q "下一步建议" workflow_repair/SKILL.md || fail "workflow_repair must show next action in output"
rg -q "是否等待用户确认" workflow_repair/SKILL.md || fail "workflow_repair must wait for confirmation explicitly"
rg -q '不创建 `docs/ai/memory/`' project_init/SKILL.md || fail "project_init must keep docs/ai/memory disabled at init"
rg -q "session_archive" project_init/SKILL.md || fail "project_init must defer memory enablement to session_archive"
rg -q "session_resume" project_init/SKILL.md || fail "project_init must defer memory enablement to session_resume"
rg -q "project_init/templates/AGENTS.v3.md" project_init/SKILL.md || fail "project_init must map AGENTS.md to its local template"
rg -q "project_init/templates/project_brief.v3.md" project_init/SKILL.md || fail "project_init must map project brief to its local template"
rg -q "project_init/templates/architecture.v3.md" project_init/SKILL.md || fail "project_init must map architecture to its local template"
rg -q "project_init/templates/progress.v3.md" project_init/SKILL.md || fail "project_init must map progress to its local template"
rg -q "project_init/templates/knowledge-index.v3.md" project_init/SKILL.md || fail "project_init must map knowledge index to its local template"
rg -q "project_init/templates/history-entry.v3.md" project_init/SKILL.md || fail "project_init must map history entry to its local template"
rg -qi "Baseline Read" context_sync/SKILL.md || fail "context_sync must define baseline read set"
rg -q "docs/ai/knowledge/lessons" context_sync/SKILL.md || fail "context_sync must summarize knowledge lifecycle"

for path in \
  README.md \
  lesson_capture/SKILL.md \
  knowledge_review/SKILL.md \
  verification_gate/SKILL.md \
  context_sync/SKILL.md \
  capability_bootstrap/SKILL.md \
  project_init/SKILL.md \
  project_init/templates/AGENTS.v3.md \
  project_init/templates/knowledge-index.v3.md \
  project_init/templates/history-entry.v3.md
do
  ! rg -n "docs/ai/knowledge/candidates|knowledge-candidate" "$path" || fail "obsolete candidate file flow remains in $path"
done
! rg -n "Promoted|Shadow|Contested" README.md verification_gate/SKILL.md verification_gate/references/output-templates.md context_sync/SKILL.md || fail "OMS-internal knowledge states remain user-facing"

rg -q "escalation" session_resume/SKILL.md || fail "session_resume must be escalation-only"
rg -qi "only if needed" session_archive/SKILL.md || fail "session_archive must make memory optional"
rg -q "AGENTS.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must sync AGENTS.md"
rg -q "docs/ai/knowledge/index.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must sync knowledge index"
rg -q "capability_bootstrap/templates/frontend-guidelines.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map frontend template"
rg -q "capability_bootstrap/templates/flows.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map flow template"
rg -q "capability_bootstrap/templates/interfaces.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map interfaces template"
rg -q "capability_bootstrap/templates/data-model.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map data model template"
rg -q "capability_bootstrap/templates/operations.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map operations template"
rg -q "capability_bootstrap/templates/domain-rules.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map domain rules template"
rg -q "feature_plan/templates/spec.v3.md" feature_plan/SKILL.md || fail "feature_plan must reference its local spec template"

! rg -n "docs/templates/" project_init/SKILL.md feature_plan/SKILL.md capability_bootstrap/SKILL.md || fail "runtime packaging must not depend on docs/templates"

echo "PASS: base OMS v3 scaffolding checks"

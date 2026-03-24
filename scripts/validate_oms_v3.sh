#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

PROJECT_INIT_TEMPLATE_DIR="project_init/templates"
FEATURE_PLAN_TEMPLATE_DIR="feature_plan/templates"
CAPABILITY_TEMPLATE_DIR="capability_bootstrap/templates"

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
  "$CAPABILITY_TEMPLATE_DIR/domain-rules.v3.md"
do
  test -f "$path" || fail "$path missing"
done

agents_lines=$(wc -l < "$AGENTS_TEMPLATE" | tr -d ' ')
[[ "$agents_lines" -le 50 ]] || fail "AGENTS.v3.md must stay within 50 lines"

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

for mode in "bootstrap" "migrate" "reconcile"; do
  rg -q "$mode" project_init/SKILL.md || fail "project_init must define $mode mode"
done

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
  "## Business Context" \
  "## Requirement Scope" \
  "## Technical Approach" \
  "## Interface And Contract Impact" \
  "## Impact Analysis" \
  "## Acceptance Criteria" \
  "## Workflow Notes" \
  "### Repair Proposal"
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
  "docs/context/project_brief.md" \
  "docs/architecture.md" \
  "docs/spec/*.md" \
  "docs/progress.md" \
  "docs/knowledge/index.md"
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
  "## 知识映射" \
  "## 迁移兼容" \
  "docs/pitfalls.md" \
  "docs/anti-patterns.md"
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

rg -q "README 是项目整体的最新说明书" README.md || fail "README must declare itself as the latest project manual"
! rg -n "^description: Use when |^  Use when " */SKILL.md || fail "OMS skill descriptions must be Chinese"

rg -q "capability_bootstrap" workflow_guard/SKILL.md || fail "workflow_guard must route capability growth to capability_bootstrap"
rg -q "capability signal" workflow_guard/SKILL.md || fail "workflow_guard must check for capability signals"

rg -q "RequirementDraft" requirement_probe/SKILL.md || fail "requirement_probe must reference RequirementDraft"
rg -q "DesignDraft" requirement_probe/SKILL.md || fail "requirement_probe must reference DesignDraft"
rg -qi "Required Docs" requirement_probe/SKILL.md || fail "requirement_probe must identify required docs"
rg -qi "Capability Tags" requirement_probe/SKILL.md || fail "requirement_probe must identify capability tags"
rg -F -q "Scope: Feature | Patch" requirement_probe/SKILL.md || fail "requirement_probe must classify Scope: Feature | Patch"

rg -q "DesignDraft" feature_plan/SKILL.md || fail "feature_plan must target DesignDraft"
rg -q "Current_Node" feature_plan/SKILL.md || fail "feature_plan must populate Current_Node"
rg -q "Last_Confirmed_Node" feature_plan/SKILL.md || fail "feature_plan must populate Last_Confirmed_Node"
rg -q "Capability_Tags" feature_plan/SKILL.md || fail "feature_plan must populate Capability_Tags"
rg -q "Module_Tags" feature_plan/SKILL.md || fail "feature_plan must populate Module_Tags"
rg -q "docs/knowledge/index.md" feature_plan/SKILL.md || fail "feature_plan must load knowledge from docs/knowledge/index.md"
rg -q "docs/pitfalls.md" feature_plan/SKILL.md || fail "feature_plan must preserve legacy durable knowledge compatibility"
rg -q "docs/anti-patterns.md" feature_plan/SKILL.md || fail "feature_plan must preserve legacy durable knowledge compatibility"
rg -F -q "Scope: Feature | Patch" feature_plan/SKILL.md || fail "feature_plan must preserve Scope: Feature | Patch"

rg -q "review" feature_confirm/SKILL.md || fail "feature_confirm must define review mode"
rg -q "lock" feature_confirm/SKILL.md || fail "feature_confirm must define lock mode"
rg -q "DesignDraft" feature_confirm/SKILL.md || fail "feature_confirm must keep state in DesignDraft during review"
rg -q "ReadyForImplementation" feature_confirm/SKILL.md || fail "feature_confirm must advance to ReadyForImplementation after approval"
rg -q "Current Node" feature_confirm/SKILL.md || fail "feature_confirm must show Current Node in user-facing output"
rg -q "Next Action" feature_confirm/SKILL.md || fail "feature_confirm must show Next Action in user-facing output"
rg -F -q "Scope: Patch" feature_confirm/SKILL.md || fail "feature_confirm must explain patch semantics"

test ! -e code_implement_plan/SKILL.md || fail "code_implement_plan runtime skill must be removed in final v3 handoff"

rg -q "ReadyForImplementation" code_implement_confirm/SKILL.md || fail "code_implement_confirm must require ReadyForImplementation before code work"
rg -q "repair_required" code_implement_confirm/SKILL.md || fail "code_implement_confirm must support repair_required"
rg -q "Implementing" code_implement_confirm/SKILL.md || fail "code_implement_confirm must mention Implementing"
rg -q "Verifying" code_implement_confirm/SKILL.md || fail "code_implement_confirm must mention Verifying"
rg -q "Current Node" code_implement_confirm/SKILL.md || fail "code_implement_confirm must show Current Node in user-facing output"
rg -q "Next Action" code_implement_confirm/SKILL.md || fail "code_implement_confirm must show Next Action in user-facing output"
rg -q "rollback baseline" code_implement_confirm/SKILL.md || fail "code_implement_confirm must separate rollback baseline from node rollback"
rg -q "patch path" code_implement_confirm/SKILL.md || fail "code_implement_confirm must support approved patch-path execution"

rg -q "repair_required" verification_gate/SKILL.md || fail "verification_gate must support repair_required"
rg -q "Verifying" verification_gate/SKILL.md || fail "verification_gate must stay grounded in Verifying"

rg -q "Current Node" progress_sync/SKILL.md || fail "progress_sync must report Current Node"
rg -q "Next Action" progress_sync/SKILL.md || fail "progress_sync must report Next Action"
rg -q "spec" progress_sync/SKILL.md || fail "progress_sync must summarize from spec state"
rg -q "当前节点" "$PROGRESS_TEMPLATE" || fail "progress template must show node state"

rg -q "docs/lessons.md" lesson_capture/SKILL.md || fail "lesson_capture must target docs/lessons.md"
rg -q "promotion" knowledge_review/SKILL.md || fail "knowledge_review must describe promotion"
rg -q "docs/pitfalls.md" knowledge_review/SKILL.md || fail "knowledge_review must support legacy pitfalls reads"
rg -q "docs/anti-patterns.md" knowledge_review/SKILL.md || fail "knowledge_review must support legacy anti-pattern reads"
rg -q "Archived" project_release/SKILL.md || fail "project_release must finalize archival"
rg -q "archive specs" project_release/SKILL.md || fail "project_release must archive specs"
rg -q "knowledge_review" project_release/SKILL.md || fail "project_release must run knowledge_review"
rg -q "architecture" project_release/SKILL.md || fail "project_release must validate architecture consistency"
rg -q "Current Node" project_release/SKILL.md || fail "project_release must show Current Node in user-facing output"
rg -q "workflow_repair" README.md || fail "README must describe workflow_repair"
rg -F -q "feature_confirm (review / lock)" README.md || fail "README must describe feature_confirm review/lock flow"
rg -q "old prompts that still mention \`code_implement_plan\` should be migrated to \`feature_confirm\`" README.md || fail "README must describe the code_implement_plan migration path"
rg -q "ReadyForImplementation" README.md || fail "README must describe ReadyForImplementation"
rg -q '默认不创建 `docs/memory/`' README.md || fail "README must describe memory optionality"

! rg -n "^\| \`code_implement_plan\` \|" README.md || fail "README must not list code_implement_plan as an active skill"
! rg -n "Ready to code .*code_implement_plan|开始实现.*code_implement_plan|primary v3 flow.*code_implement_plan|feature_confirm → code_implement_plan|仍可被调用.*code_implement_plan|compatibility shim.*code_implement_plan" README.md "$DESIGN_DOC" || fail "active flow still routes through code_implement_plan"
! rg -n "默认(读取|恢复|使用).*(memory_active.md|docs/memory/)|memory_active.md.*共享内存|memory_active.md.*唯一活跃快照|docs/memory/.*默认必建" README.md || fail "memory-first wording remains"

rg -q "Current Node" workflow_repair/SKILL.md || fail "workflow_repair must show Current Node in output"
rg -q "Next Action" workflow_repair/SKILL.md || fail "workflow_repair must show Next Action in output"
rg -q "Awaiting User Confirmation" workflow_repair/SKILL.md || fail "workflow_repair must wait for confirmation explicitly"
rg -q '不创建 `docs/memory/`' project_init/SKILL.md || fail "project_init must keep docs/memory disabled at init"
rg -q "session_archive" project_init/SKILL.md || fail "project_init must defer memory enablement to session_archive"
rg -q "session_resume" project_init/SKILL.md || fail "project_init must defer memory enablement to session_resume"
rg -q "project_init/templates/AGENTS.v3.md" project_init/SKILL.md || fail "project_init must map AGENTS.md to its local template"
rg -q "project_init/templates/project_brief.v3.md" project_init/SKILL.md || fail "project_init must map project brief to its local template"
rg -q "project_init/templates/architecture.v3.md" project_init/SKILL.md || fail "project_init must map architecture to its local template"
rg -q "project_init/templates/progress.v3.md" project_init/SKILL.md || fail "project_init must map progress to its local template"
rg -q "project_init/templates/knowledge-index.v3.md" project_init/SKILL.md || fail "project_init must map knowledge index to its local template"
rg -q "project_init/templates/history-entry.v3.md" project_init/SKILL.md || fail "project_init must map history entry to its local template"
rg -qi "Baseline Read" context_sync/SKILL.md || fail "context_sync must define baseline read set"
rg -q "escalation" session_resume/SKILL.md || fail "session_resume must be escalation-only"
rg -q "only if needed" session_archive/SKILL.md || fail "session_archive must make memory optional"
rg -q "AGENTS.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must sync AGENTS.md"
rg -q "docs/knowledge/index.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must sync knowledge index"
rg -q "capability_bootstrap/templates/frontend-guidelines.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map frontend template"
rg -q "capability_bootstrap/templates/flows.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map flow template"
rg -q "capability_bootstrap/templates/interfaces.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map interfaces template"
rg -q "capability_bootstrap/templates/data-model.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map data model template"
rg -q "capability_bootstrap/templates/operations.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map operations template"
rg -q "capability_bootstrap/templates/domain-rules.v3.md" capability_bootstrap/SKILL.md || fail "capability_bootstrap must map domain rules template"
rg -q "feature_plan/templates/spec.v3.md" feature_plan/SKILL.md || fail "feature_plan must reference its local spec template"

! rg -n "docs/templates/" project_init/SKILL.md feature_plan/SKILL.md capability_bootstrap/SKILL.md || fail "runtime packaging must not depend on docs/templates"

echo "PASS: base OMS v3 scaffolding checks"

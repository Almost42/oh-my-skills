# AGENTS.md

## Governance Positioning

- This repository uses OMS v3 as a repo-native governance kernel.
- Project facts live in repository docs, not in transient prompts.
- Workflow stage is owned by spec state, not by session narration.

## Source-Of-Truth Boundaries

- `docs/context/project_brief.md` owns project intent and scope.
- `docs/architecture.md` owns system shape and structural constraints.
- `docs/spec/*.md` own change-scoped agreements and workflow node state.
- `docs/progress.md` summarizes current active state and acts as the current-state pointer.
- `docs/knowledge/index.md` routes knowledge loading.
- `docs/lessons.md` stores active corrections.
- `docs/memory/` is an optional runtime snapshot for handoff or reconstruction only.

## Loading Policy

- Baseline read set:
  - `AGENTS.md`
  - `docs/progress.md`
  - active `docs/spec/*.md`
  - `docs/architecture.md`
  - `docs/knowledge/index.md`
- Capability docs load only when the current task touches that capability.
- Module docs load only when the spec explicitly depends on them.
- `docs/memory/` is optional and only for handoff or reconstruction.
- Treat `docs/spec/*.md` as the state machine, `docs/progress.md` as the pointer, and `docs/memory/` as support-only snapshot data.

## Trigger Routing Summary

- New project -> `project_init`
- Resume work -> `context_sync`
- New requirement -> `requirement_probe`
- Draft design review -> `feature_confirm (review)`
- Execution approval -> `feature_confirm (lock)`
- Code execution -> `code_implement_confirm`
- Repair or rollback proposal -> `workflow_repair`
- Completion claim -> `verification_gate`
- Release -> `project_release`

## Update Policy

- Keep project facts in their owning documents.
- Update `docs/progress.md` as the lightweight active-state summary.
- Promote repeated lessons only through reviewed durable knowledge.
- Do not create `docs/memory/` by default.

## Rule References

- `R1`: rule files do not own project facts.
- `R4`: `docs/memory/` is optional and support-only.
- `R13`: `context_sync` is the default recovery path.
- `R14`: `session_resume` is escalation, not default.
- `R20`: spec owns node state and `docs/progress.md` only summarizes it.
- `R22`: key workflow responses must show current node and next step.

## Tool Adapter Policy

- Tool-specific rule files may extend OMS but must not redefine source-of-truth ownership.
- Compatibility paths remain explicit and documented.

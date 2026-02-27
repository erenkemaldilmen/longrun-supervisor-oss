---
name: longrun-supervisor
description: Orchestrate long-running, resumable research tasks with checkpoints, periodic heartbeats, and managed helper agents. Use when work may run for hours, requires progress visibility, or must survive restarts while producing a source-backed final report.
---

# Longrun Supervisor

## Overview
Use this skill for research and analysis tasks that can take hours. It enforces a deterministic operating model: queue -> checkpointed execution -> helper-agent collection -> supervisor synthesis -> source-backed report.

## Operating Rules
- Keep all user-facing communication in English unless the user explicitly requests another language.
- Use one supervisor as the only synthesis authority.
- Allow at most three helper agents in parallel.
- Delegate fetch-only work to helpers (collect sources, quotes, and notes). Never let helpers produce final conclusions.
- Persist state after every meaningful step.
- Resume from checkpoint after interruptions.
- Emit periodic heartbeat updates and milestone updates.
- Stop heartbeats immediately when the task reaches a terminal state.
- Enable live progress updates by default (`live_progress=true`) unless the user asks to keep updates minimal.
- Use compact progress updates every 20 seconds by default for short timed runs.
- If the user provides a time budget (for example, "5 minutes"), treat it as a hard minimum runtime.
- During minimum-runtime windows, do active work in cycles (collect, verify, compare, checkpoint). Do not idle with sleep-only waiting.

## Directory Contracts
Use this layout under the active workspace:
- `workspace/longrun/queue.json`
- `workspace/longrun/tasks/<task_id>.json`
- `workspace/longrun/state/<task_id>.json`
- `workspace/longrun/artifacts/<task_id>/<subagent_id>.json`
- `workspace/longrun/reports/<task_id>.md`
- `workspace/longrun/logs/<task_id>.jsonl`

If files are missing, initialize them from `templates/`.

## Workflow

### 1) Intake and Queue
- Create a new task file from `templates/task.template.json`.
- Add `task_id` to `queue.json`.
- Set task status to `queued`.

### 2) Dispatch and Lock
- Pop one queued task.
- Acquire a task lock (file lock marker in `state/`).
- Set status to `running` and write checkpoint.

### 3) Planning and Sharding
- Build a research plan with explicit shards.
- Spawn up to three helper agents for fetch-only shards.
- Store helper metadata in checkpoint.

### 4) Fetch and Artifact Collection
Each helper must output:
- `sources[]` (URL + title + fetched_at)
- `quotes[]` (short evidence snippets)
- `notes` (concise observations)
- `confidence` (0.0 to 1.0)

Write one artifact file per helper under `artifacts/<task_id>/`.

### 5) Supervisor Merge and Quality Gate
- Dedupe repeated sources.
- Flag conflicting evidence.
- Reject low-quality or uncited claims.
- Write merge progress into checkpoint and logs.

### 6) Heartbeats and Milestones
- Send heartbeat every configured interval (default: 30 minutes).
- Heartbeat must include:
  - current stage
  - completed shards / total shards
  - latest high-signal finding
  - next step
- Send milestone updates at stage completion boundaries.
- For short explicit runs (for example, 5-15 minutes), send compact per-cycle updates that include what new evidence was added in that cycle.
- Live progress update format:
  - `cycle #`
  - `new evidence count`
  - `top new source (title + link)`
  - `current comparison focus`
  - `next action`

### 7) Final Report
Generate `reports/<task_id>.md` from template with these sections:
- Summary
- Findings
- Evidence (with links)
- Recommendations
- Open Questions

Rule: every key finding must reference at least one source link.
Before emitting the final user-facing output, call:
- `scripts/enforce_min_runtime.sh <workspace_dir> <task_id>`
If it exits non-zero, continue active research cycles and update checkpoint fields.

### 8) Terminalization
On `completed`, `failed`, or `cancelled`:
- stop heartbeat jobs
- release lock
- set final status in task + checkpoint
- emit one final user update

## Minimum Runtime Enforcement
- When a user requests "N minutes research", record `min_run_seconds = N*60` in task metadata.
- Start a timer at first active research action.
- Repeat active cycles until both conditions are true:
  - elapsed time >= `min_run_seconds`
  - at least one new evidence item was added in the final cycle
- Each cycle must include at least one evidence operation (fetch/source validation/comparison) and one checkpoint write.
- Do not produce final output before the minimum runtime condition is satisfied.
- While waiting for minimum runtime, continue emitting compact live progress updates on each cycle.

## Failure Policy
- Retry transient helper failures with backoff.
- If a helper fails repeatedly, replace it once.
- If replacement fails, continue with partial evidence and explicitly mark confidence reduction.
- On supervisor restart, auto-resume from latest checkpoint.

## Idempotency Rules
- Use event IDs for outgoing updates to prevent duplicates.
- Re-running a step must not duplicate side effects.
- Writes must be deterministic per `task_id` and `subagent_id`.

## Use These Resources
- For architecture and lifecycle details: `references/architecture.md`
- For ops runbook and failure drills: `references/runbook.md`
- For schema details: `references/schemas.md`
- For file initialization: `templates/*`
- For deterministic operations: `scripts/*`
- For finalization gate checks: `scripts/enforce_min_runtime.sh`

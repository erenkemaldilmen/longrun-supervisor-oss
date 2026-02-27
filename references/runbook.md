# Longrun Supervisor Runbook

## Start a Task
1. Initialize workspace files if missing.
2. Enqueue task using `scripts/enqueue_task.sh`.
3. Confirm task appears in `queue.json`.

## Resume a Task
1. Identify task in `running` or `paused` state.
2. Execute `scripts/resume_task.sh <task_id>`.
3. Verify checkpoint and lock behavior.

## Heartbeat Operations
- Emit heartbeat manually: `scripts/heartbeat_emit.sh <task_id>`.
- Verify terminal tasks do not emit heartbeat.

## Cleanup Orphans
- Run `scripts/cleanup_orphans.sh` to:
  - remove stale locks
  - mark zombie running tasks as paused
  - stop orphan heartbeat entries

## Failure Drills
- Kill supervisor mid-step and verify resume from checkpoint.
- Force helper failure and verify retry/replacement.
- Validate no duplicate user-visible updates for same event id.

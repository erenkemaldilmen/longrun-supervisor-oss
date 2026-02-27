# Longrun Supervisor Architecture

## Components
- Supervisor: controls planning, sharding, merge, synthesis, reporting.
- Helper agents: fetch-only workers for source collection.
- Persistence: queue, task, checkpoint, artifacts, logs, report.
- Notification plane: heartbeat + milestone + terminal updates.

## Data Flow
1. Intake writes task and queue entry.
2. Dispatcher takes task and starts supervisor.
3. Supervisor shards work and dispatches helpers.
4. Helpers write artifacts.
5. Supervisor merges evidence and drafts report.
6. Report is published and task is terminalized.

## Concurrency Model
- One active supervisor task at a time by default.
- Up to three helper agents in parallel per task.
- Use file-lock semantics to prevent double supervisor runs.

## Reliability Model
- Checkpoint after each stage transition.
- Auto-resume from latest checkpoint on restart.
- Heartbeat process is independent from stage execution and terminates on terminal state.

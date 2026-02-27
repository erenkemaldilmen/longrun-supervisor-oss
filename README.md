# longrun-supervisor

A Codex skill for long-running, resumable research with checkpoints, heartbeats, and minimum-runtime guardrails.

## What this skill does

- Runs research in explicit cycles with progress updates.
- Persists task/checkpoint state for resume after interruption.
- Enforces `min_run_seconds` before final output.
- Requires new evidence in the final cycle before completion.

## Structure

- `SKILL.md` - skill instructions and operating model
- `agents/` - helper agent configuration
- `scripts/` - queue, resume, heartbeat, cleanup, runtime guardrail
- `templates/` - task/checkpoint/artifact/report templates
- `references/` - architecture, runbook, and schema docs

## Quick Start (Codex)

1. Install/copy this folder into your Codex skills directory.
2. Trigger it in chat with:
   - `$longrun-supervisor`
3. Give a timed task, for example:
   - `Research X for 5 minutes with live progress updates.`

## Optional OpenClaw Integration

This repo is Codex-first. If you also use OpenClaw, point the skill workflow to your OpenClaw workspace state paths (`workspace/longrun/...`) as documented in `SKILL.md`.

## Example Commands

```bash
# Enqueue
scripts/enqueue_task.sh <workspace_dir> <task_id> <task_json_file>

# Resume
scripts/resume_task.sh <workspace_dir> <task_id>

# Heartbeat
scripts/heartbeat_emit.sh <workspace_dir> <task_id>

# Runtime guardrail
scripts/enforce_min_runtime.sh <workspace_dir> <task_id>
```

## License

MIT

# v0.1.0 Summary

`longrun-supervisor` is a Codex skill for long-running research workflows.

## Highlights

- Checkpointed execution with resume support
- Periodic heartbeat updates for live progress
- Minimum runtime guardrail (`min_run_seconds`)
- Final-cycle evidence requirement before completion
- Source-backed final report structure

## Included Components

- `SKILL.md` core workflow and rules
- `scripts/` for queue, resume, heartbeat, cleanup, and runtime enforcement
- `templates/` for task/checkpoint/artifact/report formats
- `references/` architecture, runbook, and schema docs

## Validation

- Verified with Codex `skill-creator` validator
- Runtime guardrail tested with block/pass scenarios

## Use Case

Ideal for timed research runs (for example 5-60 minutes) where users need continuous progress and deterministic completion rules.

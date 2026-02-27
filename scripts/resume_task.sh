#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <workspace_dir> <task_id>" >&2
  exit 1
fi

workspace_dir="$1"
task_id="$2"
base="$workspace_dir/longrun"
state="$base/state/$task_id.json"
task="$base/tasks/$task_id.json"
lock="$base/state/$task_id.lock"

if [[ ! -f "$task" || ! -f "$state" ]]; then
  echo "Missing task or state for $task_id" >&2
  exit 1
fi

status="$(jq -r '.status' "$task")"
if [[ "$status" == "completed" || "$status" == "failed" || "$status" == "cancelled" ]]; then
  echo "Task $task_id is terminal ($status), not resuming"
  exit 0
fi

printf '%s\n' "$$" > "$lock"
now="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

jq --arg now "$now" '.status="running" | .updated_at=$now' "$task" > "$task.tmp" && mv "$task.tmp" "$task"
jq --arg now "$now" '.status="running" | .updated_at=$now' "$state" > "$state.tmp" && mv "$state.tmp" "$state"

echo "Resumed $task_id from checkpoint"

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

if [[ ! -f "$state" ]]; then
  echo "Missing state for $task_id" >&2
  exit 1
fi

status="$(jq -r '.status' "$state")"
if [[ "$status" == "completed" || "$status" == "failed" || "$status" == "cancelled" ]]; then
  echo "Task $task_id is terminal ($status), no heartbeat"
  exit 0
fi

step="$(jq -r '.step' "$state")"
progress="$(jq -c '.progress' "$state")"
next="$(jq -r '.next_step // "continue evidence collection and merge"' "$state")"

printf 'Heartbeat [%s] step=%s progress=%s next=%s\n' "$task_id" "$step" "$progress" "$next"

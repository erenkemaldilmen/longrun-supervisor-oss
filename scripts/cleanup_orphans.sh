#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <workspace_dir>" >&2
  exit 1
fi

workspace_dir="$1"
base="$workspace_dir/longrun"
state_dir="$base/state"

mkdir -p "$state_dir"

shopt -s nullglob
for lock in "$state_dir"/*.lock; do
  task_id="$(basename "$lock" .lock)"
  state="$state_dir/$task_id.json"
  task="$base/tasks/$task_id.json"
  if [[ ! -f "$state" || ! -f "$task" ]]; then
    rm -f "$lock"
    echo "Removed orphan lock $lock"
    continue
  fi

  status="$(jq -r '.status' "$task")"
  if [[ "$status" == "completed" || "$status" == "failed" || "$status" == "cancelled" ]]; then
    rm -f "$lock"
    echo "Removed lock for terminal task $task_id"
  fi
done

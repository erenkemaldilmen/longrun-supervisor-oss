#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <workspace_dir> <task_id> <task_json_file>" >&2
  exit 1
fi

workspace_dir="$1"
task_id="$2"
input_json="$3"

base="$workspace_dir/longrun"
mkdir -p "$base/tasks" "$base/state" "$base/artifacts/$task_id" "$base/reports" "$base/logs"

queue="$base/queue.json"
if [[ ! -f "$queue" ]]; then
  printf '{"version":1,"items":[]}\n' > "$queue"
fi

cp "$input_json" "$base/tasks/$task_id.json"

tmp_queue="$(mktemp)"
jq --arg id "$task_id" '.items += [$id] | .items |= unique' "$queue" > "$tmp_queue"
mv "$tmp_queue" "$queue"

echo "Enqueued $task_id"

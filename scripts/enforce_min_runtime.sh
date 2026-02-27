#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <workspace_dir> <task_id>" >&2
  exit 1
fi

workspace_dir="$1"
task_id="$2"
state_file="$workspace_dir/longrun/state/$task_id.json"

if [[ ! -f "$state_file" ]]; then
  echo "Missing state file: $state_file" >&2
  exit 1
fi

min_run_seconds="$(jq -r '.min_run_seconds // 0' "$state_file")"
started_at="$(jq -r '.started_at // empty' "$state_file")"
last_cycle_new_evidence="$(jq -r '.progress.last_cycle_new_evidence // 0' "$state_file")"

if [[ -z "$started_at" ]]; then
  echo "started_at is not set in state; cannot enforce runtime" >&2
  exit 2
fi

if [[ "$min_run_seconds" -le 0 ]]; then
  echo "No minimum runtime configured; finalization allowed"
  exit 0
fi

start_epoch="$(date -u -d "$started_at" +%s)"
now_epoch="$(date -u +%s)"
elapsed="$((now_epoch - start_epoch))"
remaining="$((min_run_seconds - elapsed))"

if [[ "$elapsed" -lt "$min_run_seconds" ]]; then
  echo "BLOCK: minimum runtime not met (elapsed=${elapsed}s, required=${min_run_seconds}s, remaining=${remaining}s)"
  exit 3
fi

if [[ "$last_cycle_new_evidence" -lt 1 ]]; then
  echo "BLOCK: final cycle has no new evidence (last_cycle_new_evidence=${last_cycle_new_evidence})"
  exit 4
fi

echo "OK: minimum runtime and final-cycle evidence constraints met"
exit 0

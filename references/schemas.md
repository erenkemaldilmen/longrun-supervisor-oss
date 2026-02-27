# Schemas

## queue.json
```json
{
  "version": 1,
  "items": []
}
```

## task.json
```json
{
  "task_id": "uuid",
  "title": "string",
  "prompt": "string",
  "status": "queued",
  "owner_channel": "string",
  "live_progress": true,
  "update_interval_sec": 20,
  "heartbeat_interval_sec": 1800,
  "min_run_seconds": 0,
  "created_at": "ISO8601",
  "output_mode": "source_backed_report"
}
```

## checkpoint.json
```json
{
  "task_id": "uuid",
  "status": "running",
  "step": "plan",
  "step_index": 0,
  "started_at": "ISO8601",
  "min_run_seconds": 0,
  "subagents": [],
  "progress": {
    "shards_total": 0,
    "shards_completed": 0,
    "sources_collected": 0,
    "last_cycle_new_evidence": 0
  },
  "last_error": null,
  "updated_at": "ISO8601"
}
```

## subartifact.json
```json
{
  "subagent_id": "string",
  "sources": [],
  "quotes": [],
  "notes": "string",
  "confidence": 0.0,
  "fetched_at": "ISO8601"
}
```

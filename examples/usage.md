# Example Usage

Prompt:

`$longrun-supervisor Research best monetization strategy for <topic> for 5 minutes and stream progress every 20 seconds.`

Expected behavior:

- Starts timed cycles
- Emits compact heartbeat/progress updates
- Refuses finalization before `min_run_seconds`
- Produces source-backed final report

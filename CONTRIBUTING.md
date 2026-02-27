# Contributing

## Development Rules

- Keep user-facing text in English.
- Keep behavior deterministic and idempotent.
- Do not remove the minimum-runtime guardrail logic.
- Prefer small, testable script changes.

## Local Validation

Use Codex `skill-creator` validator:

```bash
python3 /root/.codex/skills/.system/skill-creator/scripts/quick_validate.py <path_to_skill>
```

## Pull Request Checklist

- Updated docs if behavior changed.
- Guardrail behavior still enforced (`enforce_min_runtime.sh`).
- No breaking path changes in `SKILL.md` contracts.
- Templates remain valid JSON/Markdown.

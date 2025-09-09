# Using these templates with Codex

1) Copy the templates you need into your repo under `docs/context/`, renaming them (e.g., `PRD.template.md` → `PRD.md`).
2) Fill the front‑matter (owner, project, date, tags) and the sections.
3) For feature work, duplicate `PRD.template.md` → `PRD-<feature>.md` and `TECHNICAL_PLAN.template.md` → `TECHNICAL_PLAN-<feature>.md`, add `tags: ["<feature>"]`.
4) Use `codex.context.GLOBAL.yaml` for broad generation or `codex.context.FEATURE.yaml` (rename to `codex.context.<feature>.yaml`) for a single feature.
5) Run Codex CLI with `--context` pointing to the chosen manifest.



Includes Rider Templates
CE_vars
#set( $h = "#" )
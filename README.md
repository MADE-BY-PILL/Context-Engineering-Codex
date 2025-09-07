# Context Engineering Codex

Lightweight toolkit of **templates, playbooks, examples & reusable CI** to run AI‑assisted development with Context Engineering (Rider + Markdown + Codex CLI).


## Why
Great code comes from great context. This repo turns intent into **small, versioned documents** (RESEARCH/PRD/ARCH/PLAN/TESTING/ADRs) that the Codex CLI consumes to generate deterministic code and tests.

## What’s inside
- **Templates** for PRD, RESEARCH, ARCHITECTURE, TECHNICAL_PLAN, TESTING_PLAN, CODING_GUIDE, ADR
- **`codex.context.yaml`** manifest to feed the CLI (global and feature scope)
- **Playbooks** for new features and bugfixes
- **Examples** the AI should imitate
- **Reusable CI** to validate context in PRs

## Quickstart
1. Copy `docs/context/*` templates into your project and fill them: **RESEARCH → PRD → ARCHITECTURE → TECHNICAL_PLAN → TESTING_PLAN**.
2. Check `/examples` for patterns to imitate.
3. Generate with Codex CLI:

```bash
codex gen api \\
  --context docs/context/codex.context.yaml \\
  --task "Generate initial API per PRD & ARCHITECTURE" \\
  --out src/Api
```

Feature‑scoped generation:

```bash
codex gen feature \\
  --context docs/context/codex.context.orders.yaml \\
  --task "Implement Orders CRUD + status filter per PRD & PLAN" \\
  --out .
```

## Repository layout
```
.
├── README.md
├── CODEX.md
├── docs/
│   ├── context/
│   │   ├── PRD.md
│   │   ├── RESEARCH.md
│   │   ├── ARCHITECTURE.md
│   │   ├── TECHNICAL_PLAN.md
│   │   ├── TESTING_PLAN.md
│   │   ├── CODING_GUIDE.md
│   │   ├── codex.context.yaml
│   │   └── ADR/
│   │       └── 001-db-choice.md
│   └── playbooks/
│       ├── new-feature.md
│       └── bugfix.md
├── examples/
├── scripts/
│   ├── codex.sh
│   └── validate-context.py
└── .github/
    ├── ISSUE_TEMPLATE/
    ├── PULL_REQUEST_TEMPLATE.md
    └── workflows/
```

## Process at a glance
1. **RESEARCH** — pain, stakeholders, constraints
2. **PRD (The What)** — MoSCoW, out of scope, acceptance
3. **ARCHITECTURE** — standards, modules, NFRs, ADRs
4. **PLAN** — epics→features→tasks, interfaces, data
5. **CODING** — generate with Codex, follow conventions
6. **TESTING** — strategy, gates, automation, perf & security
7. Iterate by **updating docs** → regenerate

## Contributing
See **CODEX.md** for architectural/testing rules & guardrails. PRs welcome.

## License
Apache‑2.0
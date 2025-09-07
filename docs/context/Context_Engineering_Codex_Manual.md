
# Context Engineering Codex — Team Manual (EN)
_Last updated: 2025-09-07_

This manual turns Context Engineering into a **repeatable, teachable workflow**. It explains:
- where files live in the repository,
- what each template is for (PRD, RESEARCH, ARCHITECTURE, TECHNICAL_PLAN, TESTING_PLAN, CODING_GUIDE, ADR),
- how to create and name those files (plain copy or Rider File Templates),
- how to run the **Codex CLI** using a **global** or **feature** context,
- how to handle **bugfixes**,
- and which guardrails (CI/hooks) keep quality high.

---

## 1) Quick Start (TL;DR)
1. Create/update context docs in `docs/context/`: **RESEARCH → PRD → ARCHITECTURE → TECHNICAL_PLAN → TESTING_PLAN**. Keep each short and precise.
2. Choose your manifest:
   - Global: `docs/context/codex.context.yaml`
   - Feature‐scoped: `docs/context/codex.context.<feature>.yaml`
3. Generate with Codex CLI:
   ```bash
   codex gen api     --context docs/context/codex.context.yaml                --task "Generate initial API per PRD & ARCHITECTURE" --out src/Api
   codex gen feature --context docs/context/codex.context.orders.yaml         --task "Implement Orders CRUD + status filter per PRD & PLAN" --out .
   ```
4. Build/test. If something is off, **fix the docs** (or the task), then regenerate.

---

## 2) Repository Layout (recommended)
```
.
├── README.md
├── CODEX.md                      # architecture/testing rules & guardrails
├── docs/
│   ├── context/
│   │   ├── PRD.md
│   │   ├── RESEARCH.md
│   │   ├── ARCHITECTURE.md
│   │   ├── TECHNICAL_PLAN.md
│   │   ├── TESTING_PLAN.md
│   │   ├── CODING_GUIDE.md
│   │   ├── codex.context.yaml                 # GLOBAL manifest
│   │   └── ADR/
│   │       └── 001-db-choice.md               # one decision per file
│   └── playbooks/
│       ├── new-feature.md
│       └── bugfix.md
├── examples/                                  # small, idiomatic code samples
│   └── README.md
├── scripts/
│   ├── codex.sh
│   └── validate-context.py
└── .github/
    ├── ISSUE_TEMPLATE/{feature_request.yml, bug_report.yml}
    ├── PULL_REQUEST_TEMPLATE.md
    └── workflows/{context-check.yml | reusable-context-check.yml}
```

**Why this layout?** Context documents live with the code; examples show style the AI should imitate; scripts & CI enforce the process.

---

## 3) Naming, Locations & Front‑Matter
- Place **all context docs** under `docs/context/`. For feature-specific docs, suffix the name: `PRD-orders.md`, `TECHNICAL_PLAN-orders.md`.
- Use a **YAML front‑matter** at the top of every `.md`:
  ```yaml
  ---
  context_role: product_manager|researcher|architect|engineer|tester
  phase: prd|research|architecture|plan|testing|coding
  visibility: public
  weight: 0.6..1.0             # priority when assembling context
  owner: <name>
  project: <repo-or-solution>
  date: YYYY-MM-DD
  tags: ["orders", "payments"]  # optional; used by feature manifests
  related: ["PRD.md","TECHNICAL_PLAN.md"]
  ---
  ```
- **One intention per file**; keep documents short (screenfuls, not chapters).

---

## 4) Templates — What each file does
Below are **purposes** and **must‑haves** for each doc. (The actual English templates are in the templates pack.)

### 4.1 RESEARCH.md — “Why”
- **Purpose:** Frame the problem before solutions.
- **Must‑haves:** pain/context, stakeholders, known constraints, sources/benchmarks, and a short checklist “we have enough research to proceed”.

### 4.2 PRD.md — “What”
- **Purpose:** Decide the product behavior with business priority.
- **Must‑haves:** MoSCoW (MUST/SHOULD/COULD/WON’T), out‑of‑scope, acceptance criteria that are **measurable**.

### 4.3 ARCHITECTURE.md — “Structure & standards”
- **Purpose:** State the architecture style, module boundaries, and NFRs.
- **Must‑haves:** style (Clean/Hexagonal/DDD), layers/modules, interfaces/contracts, NFRs (observability, security, performance), **ADRs** and open questions.

### 4.4 TECHNICAL_PLAN.md — “Decomposition”
- **Purpose:** Turn product intent into buildable tasks.
- **Must‑haves:** epics→features→tasks (**tasks < 1 day**), interfaces/endpoints, data & schemas, risks/spikes, DoR/DoD.

### 4.5 TESTING_PLAN.md — “Quality”
- **Purpose:** Testing strategy and gates.
- **Must‑haves:** test pyramid, environments/data, high‑level cases, quality gates (coverage/linters/SAST), automation pipeline, perf/reliability checks, security/privacy, observability checks, release criteria.

### 4.6 CODING_GUIDE.md — “Conventions”
- **Purpose:** Shared coding standards the AI and team must follow.
- **Must‑haves:** naming, folder layout, patterns, logging, examples/snippets, tools in CI.

### 4.7 ADR/*.md — “Decisions”
- **Purpose:** Record architectural decisions with rationale & trade‑offs.
- **Must‑haves:** context, decision, consequences (±), status (Proposed/Accepted/Deprecated/Superseded). **One decision per file.**

### 4.8 codex.context.yaml — “Manifest”
- **Purpose:** Tell the CLI **which docs to load**, with **weights**, and hints.
- **Global manifest** (entire repo) versus **Feature manifest** (filtered by tags).

Example (GLOBAL — simplified):
```yaml
version: 1
project: "MySolution"

include:
  - path: "docs/context/PRD.md"            # 1.0 = highest priority
    weight: 1.0
  - path: "docs/context/ARCHITECTURE.md"
    weight: 1.0
  - path: "docs/context/TECHNICAL_PLAN.md"
    weight: 0.9
  - path: "docs/context/TESTING_PLAN.md"
    weight: 0.8

globs:
  - pattern: "docs/context/ADR/*.md"
    weight: 0.6

hints:
  language: "C#"
  framework: "ASP.NET Core"
  architecture: "Clean/Hexagonal; constructor DI; no service locator"
  testing:
    unit: "xUnit"
    integration: "Testcontainers"
  conventions:
    root_namespace: "MySolution"
    folders: ["src/Domain","src/Application","src/Infrastructure","src/Api","tests"]
```

---

## 5) Creating Files (three ways)

### A) Copy the templates
- Copy from the templates pack into `docs/context/`, rename (e.g., `PRD.template.md` → `PRD.md`), and fill.

### B) Use Rider File Templates (fast, repeatable)
- **Path:** `File → Settings → Editor → File and Code Templates` (tab **Files**).
- Create a template for each doc (PRD, RESEARCH, …); set **Extension** to `md`.
- Enable **Live Templates** to auto‑replace variables like `${USER}`, `${PROJECT_NAME}`, `${DATE}`.
- **Important for Markdown:** Rider templates use **Apache Velocity**. `##` is a comment. If you need a literal `#` at the start of a line, either:
  - escape it as `\# Heading`, or
  - add an Include `CE_vars.vm` with `#set( $h = "#" )` and write `$h$h Heading`.
- Disable **Reformat according to style** for `.md` templates.

### C) Scaffold with a script
- Create `scripts/scaffold.sh` and generate skeleton files from minimal stubs; useful for bulk creation (optional).

---

## 6) Process: Global vs Feature vs Bugfix

### 6.1 Global (macro) — first setup or broad generation
1. Write/update **RESEARCH → PRD → ARCHITECTURE → TECHNICAL_PLAN → TESTING_PLAN** (macro level).
2. Review **ADRs** for key decisions.
3. Ensure `docs/context/codex.context.yaml` includes the right docs and hints.
4. Run:
   ```bash
   codex gen api      --context docs/context/codex.context.yaml      --task "Generate initial API per PRD & ARCHITECTURE"      --out src/Api
   ```
5. Build/test; refine docs; regenerate if needed.

### 6.2 Feature (micro) — one module at a time
1. Add a tag to relevant docs: `tags: ["orders"]`.
2. Create `PRD-orders.md`, `TECHNICAL_PLAN-orders.md`; update ARCHITECTURE/ADRs if needed.
3. Create `docs/context/codex.context.orders.yaml` filtering by tag.
4. Run:
   ```bash
   codex gen feature      --context docs/context/codex.context.orders.yaml      --task "Implement Orders CRUD + status filter per PRD & PLAN"      --out .
   ```
5. Build/test; adjust docs (not prompts) if output misses expectations.

**Feature checklist**
- [ ] RESEARCH updated with constraints & tag
- [ ] PRD-<feature>.md with MoSCoW + acceptance
- [ ] ARCHITECTURE adjusted + ADR if needed
- [ ] TECHNICAL_PLAN-<feature>.md (tasks < 1 day)
- [ ] TESTING_PLAN updated (regressions)
- [ ] Run Codex with feature manifest

### 6.3 Bugfix — focused and test‑first
1. **RESEARCH**: reproduction steps, environment, data, impact.
2. **TECHNICAL_PLAN**: hypothesis, fix steps, rollback.
3. **TESTING_PLAN**: failing regression test first.
4. Update PRD/ARCH/ADR only if the bug reveals missing requirements/decisions.
5. Run (micro context, optional tags `["bug","orders"]`):
   ```bash
   codex gen feature      --context docs/context/codex.context.bug-123.yaml      --task "BugFix #123: add failing test; fix repository so status=canceled is respected; keep public API unchanged"      --out .
   ```

---

## 7) Codex CLI — Task writing tips
- Be **explicit with file paths** and project layout in the task body.
- Prefer several **small runs** to one mega task.
- Link to examples: “follow `examples/RepositoryPattern.cs` style”.
- Quantify expectations (latency p95, coverage, path names), avoid “do what makes sense”.

**Bootstrap example (layout + health endpoint):**
```bash
codex gen api --context docs/context/codex.context.yaml --out . --task "
Bootstrap the .NET solution:
- Create solution MySolution.sln
- Projects:
  src/Domain (classlib)
  src/Application (classlib)
  src/Infrastructure (classlib)
  src/Api (webapi)
  tests/Tests (xUnit)
- References: Api->Application; Application->Domain; Infrastructure->(Domain,Application)
- Api: GET /health returns {{ status: 'ok' }}
- Directory.Build.props: nullable enable; langversion latest
- Add a smoke test in tests/Tests
- Respect Clean Architecture boundaries
"
```

---

## 8) Guardrails (CI & hooks)

### Pre‑commit (optional)
Refuse commits when required docs are missing:
```bash
#!/usr/bin/env bash
set -euo pipefail
req=( "docs/context/PRD.md" "docs/context/ARCHITECTURE.md" "docs/context/TECHNICAL_PLAN.md" )
for f in "${{req[@]}}"; do
  [[ -f "$f" ]] || {{ echo "Missing $f"; exit 1; }}
done
```

### GitHub Action (context check)
`.github/workflows/context-check.yml` runs `scripts/validate-context.py` to ensure front‑matter keys (`context_role, phase, visibility, weight`) exist and core docs are present.

### CODEOWNERS & PR template
Route docs to owners and require checkboxes: “Context docs updated”, “ADR added/updated”, “tests updated”.

---

## 9) Worked Example — Orders v1 (short)
- **PRD-orders.md**: MUST = CRUD, status filter; SHOULD = paging; COULD = CSV export; out of scope = billing; acceptance = “p95 < 200ms”, “OpenAPI up‑to‑date”.
- **ARCHITECTURE.md**: Clean+DDD-lite; layers Domain/Application/Infrastructure/Api; contracts `IOrderRepository`; NFRs security/observability; ADR `001-db-choice` = PostgreSQL.
- **TECHNICAL_PLAN-orders.md**: tasks for entity, repository, DbContext+migration, endpoints, validation.
- **TESTING_PLAN.md**: regression cases + coverage gates.
- **Codex**: run `codex gen feature --context docs/context/codex.context.orders.yaml ...`.

---

## 10) FAQ / Troubleshooting
- **Headings vanished in Rider templates** → Apache Velocity treats `##` as comment. Escape (`\#`) or use an include `CE_vars.vm` with `$h="#"` and write `$h$h` for `##`.
- **Code generated in unexpected folders** → make paths explicit in the task; add `conventions.folders` in the manifest and restate them in the task.
- **Generation ignores some docs** → check `weight` in the manifest and ensure the file is actually included (or tagged properly in feature manifests).
- **Long prompts underperform** → split into smaller tasks; keep docs crisp; point to examples.
- **When to write an ADR?** → when a decision changes architecture, tech choice, or major trade‑off. One ADR per decision.

---

## 11) Change Management
- Keep docs versioned with the code. Update PRD/PLAN when scope changes.
- Record decisions in ADRs instead of spreading them across PRs/Slack.
- Prefer **small increments**: update docs → generate → test → PR.

---

## 12) License & Attribution
This process and templates can be published under **Apache‑2.0**. Preserve LICENSE and, if present, a NOTICE file. Add `SPDX-License-Identifier: Apache-2.0` in headers if you like.

---

**End.** Keep documents short, explicit, and alive. The AI is powerful, but good context turns it from a guesser into a teammate.

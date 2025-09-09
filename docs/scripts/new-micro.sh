#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat << 'EOF'
Uso: scripts/new-micro.sh [-t feature|bugfix] [-s slug] [-d AAAA-MM-DD] \
                          [-o owner] [-p projects_csv] [-r related_csv]

Se não passar flags, o script pergunta interativamente.
Exemplos:
  scripts/new-micro.sh -t feature -s pulse-leads-dedupe -o sergioferreira \
    -p Pulse.Api,Pulse.AzFunc.Leads -r issue-123,PR-456
EOF
}

prompt() {
  local var="$1"; local msg="$2"; local def="${3:-}"
  local val
  if [[ -n "${!var:-}" ]]; then return 0; fi
  if [[ -n "$def" ]]; then
    read -r -p "$msg [$def]: " val || true
    val="${val:-$def}"
  else
    read -r -p "$msg: " val || true
  fi
  printf -v "$var" '%s' "$val"
}

prompt_multiline() {
  # Reads multiline input until an empty line; stores in variable name passed
  local var="$1"; local msg="$2"
  echo "$msg (linha vazia para terminar):"
  local lines=""; local line
  while IFS= read -r line; do
    [[ -z "$line" ]] && break
    lines+="$line
"
  done
  printf -v "$var" '%s' "$lines"
}

type="${1:-}"
slug=""
date_str=""
owner=""
projects_csv=""
related_csv=""

while getopts ":t:s:d:o:p:r:h" opt; do
  case "$opt" in
    t) type="$OPTARG";;
    s) slug="$OPTARG";;
    d) date_str="$OPTARG";;
    o) owner="$OPTARG";;
    p) projects_csv="$OPTARG";;
    r) related_csv="$OPTARG";;
    h) usage; exit 0;;
    \?) usage; echo "Opção inválida: -$OPTARG" >&2; exit 2;;
  esac
done

[[ -z "${date_str:-}" ]] && date_str="$(date +%F)"

prompt type "Tipo (feature/bugfix)" "${type:-feature}"
if [[ "$type" != "feature" && "$type" != "bugfix" ]]; then
  echo "Tipo inválido: $type (esperado feature|bugfix)" >&2; exit 2
fi

prompt slug "Slug (dominio-topico-curto)" "$slug"
prompt owner "Owner (ex.: nome.apelido)" "$owner"
prompt projects_csv "Projects afetados (CSV)" "$projects_csv"
prompt related_csv "Related (issues/PRs CSV)" "$related_csv"

objective=""
acceptance_ml=""
if [[ "$type" == "feature" ]]; then
  prompt objective "Objetivo de negócio (1-2 frases)" ""
  prompt_multiline acceptance_ml "Critérios de aceitação (um por linha)"
else
  bug_summary=""; str=""; expected=""; observed=""
  prompt bug_summary "Resumo do bug (1 frase)" ""
  echo "Passos para reproduzir (STR):"; prompt_multiline str ""
  prompt expected "Comportamento esperado" ""
  prompt observed "Comportamento observado" ""
fi

projects_yaml=""
if [[ -n "$projects_csv" ]]; then
  IFS=',' read -r -a arr <<< "$projects_csv"
  for it in "${arr[@]}"; do
    it_trim="$(echo "$it" | awk '{$1=$1;print}')"
    [[ -z "$it_trim" ]] || projects_yaml+="\nprojects: [\"$it_trim\"]"
  done
fi

related_yaml=""
if [[ -n "$related_csv" ]]; then
  IFS=',' read -r -a arr2 <<< "$related_csv"
  rels=""
  for it in "${arr2[@]}"; do
    it_trim="$(echo "$it" | awk '{$1=$1;print}')"
    [[ -z "$it_trim" ]] || rels+="\"$it_trim\","
  done
  rels="${rels%,}"
  [[ -n "$rels" ]] && related_yaml="\nrelated: [$rels]"
fi

base_dir="docs/context/micro/$type/${date_str}-${slug}"
mkdir -p "$base_dir"

write_file() {
  local path="$1"; shift
  mkdir -p "$(dirname "$path")"
  cat > "$path" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

$*
EOF
}

if [[ "$type" == "feature" ]]; then
  # RESEARCH.md
  cat > "$base_dir/RESEARCH.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Research (micro)

- Objetivo: ${objective}
- Escopo: …
- Hipóteses: …
- Perguntas-chave: …
- Métricas de sucesso: …
EOF

  # ARCHITECTURE.md
  cat > "$base_dir/ARCHITECTURE.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Architecture (micro)

- Impacto em sistemas: …
- Interfaces/Contratos: …
- Dados/Entidades: …
- Riscos/Mitigações: …
EOF

  # PRD.md
  cat > "$base_dir/PRD.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# The What (micro)

- Objetivo: ${objective}

## MoSCoW
- MUST: …
- SHOULD: …
- COULD: …
- WON'T: …

## Acceptance
$(if [[ -n "$acceptance_ml" ]]; then echo "$acceptance_ml" | sed 's/^/- /'; else echo "- …"; fi)
EOF

  # PLAN.md
  cat > "$base_dir/PLAN.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Plan (micro)

- Features → Tasks: …
- Interfaces & Dados: …
- DoR: …
- DoD: …
EOF

  # TESTS.md
  cat > "$base_dir/TESTS.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Testing (micro)

- Unit: …
- Integration/Contract: …
- E2E/Perf (se aplicável): …
EOF

  # DECISIONS.md
  cat > "$base_dir/DECISIONS.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Decisions (micro)

- Decisão: …
- Contexto: …
- Consequências: …
- Promover ADR macro? …
EOF

else
  # BUG.md
  cat > "$base_dir/BUG.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Bug

- Resumo: ${bug_summary}
- STR (steps to reproduce):
$(echo "$str" | sed 's/^/- /')
- Esperado: ${expected}
- Observado: ${observed}
- Impacto/Risco: …
- Acceptance: …
EOF

  # PLAN.md
  cat > "$base_dir/PLAN.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Plan (bugfix)

- Root cause (hipótese): …
- Tasks: …
- Rollback: …
- DoR/DoD: …
EOF

  # TESTS.md
  cat > "$base_dir/TESTS.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Testing (bugfix)

- Teste de repro: …
- Teste de não-regressão: …
- Contratos impactados: …
EOF

  # DECISIONS.md (opcional)
  cat > "$base_dir/DECISIONS.md" << EOF
---
owner: ${owner}
date: ${date_str}
status: draft${related_yaml}
---

# Decisions (bugfix)

- Decisão: …
- Contexto: …
EOF
fi

echo "Criado: $base_dir"
find "$base_dir" -maxdepth 1 -type f -print | sed 's/^/  - /'

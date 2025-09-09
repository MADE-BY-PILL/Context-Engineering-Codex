#parse("CE_vars.vm")
---
context_role: tester
phase: testing
visibility: public
weight: 0.8
related: ["ARCHITECTURE.md","PRD.md","TECHNICAL_PLAN.md"]
owner: ${USER}
project: ${PROJECT_NAME}
date: ${DATE}
---

$h Strategy

- Pirâmide de testes: Unit / Integration / E2E / Contract / Performance
- Escopo deste ciclo:
- Ambientes: Dev / QA / Staging / Prod
- Dados de teste: sintéticos / mascarados / amostras reais

$h Test Cases (high-level)

- Caso 1: …
    - Pré-condições:
    - Passos:
    - Resultado esperado:
- Caso 2: …

$h Quality Gates

- Cobertura mínima (linhas/branches): ___%
- Linters/SAST: ferramentas e regras
- Critérios de regressão: quantos testes podem falhar (ideal: 0)
- Acessibilidade (se aplicável): WCAG alvo

$h Automation Pipeline

- Execução: on PR, nightly, release
- Relato: onde ver relatórios (CI artifacts, dashboards)
- Flakiness policy: repetição / quarentena / correção obrigatória

$h Performance & Reliability

- SLIs/SLOs testados (latência p95, throughput, erro %)
- Cargas: pico vs. sustentada
- Chaos/Resilience checks (timeouts, circuit breakers)

$h Security & Privacy

- Testes de authZ/authN
- Gestão de segredos
- Dados pessoais: anonimização/mascaramento

$h Observability Checks

- Logs essenciais presentes
- Métricas expostas (ex.: processados/min)
- Traços para fluxos críticos

$h Release Criteria

- Todos os MUST do PRD aceites
- Quality Gates cumpridos
- Riscos/bugs conhecidos documentados

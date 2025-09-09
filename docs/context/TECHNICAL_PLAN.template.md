#parse("CE_vars.vm")
---
context_role: engineer
phase: plan
visibility: public
weight: 0.9
related: ["ARCHITECTURE.md","PRD.md","TESTING_PLAN.md"]
owner: ${USER}
project: ${PROJECT_NAME}
date: ${DATE}
---

$h Technical Decomposition

- Epics:
- Features:
- Tasks (granulares, < 1 dia):
- Dependências entre tasks:

$h Interfaces & Contracts

- Endpoints (método, rota, request/response DTOs):
- Mensageria/eventos:
- Integrações externas:

$h Data & Schemas

- Entidades principais:
- Tabelas/coleções e chaves:
- Migrações previstas:

$h Risks & Spikes

- Riscos técnicos:
- Spikes necessários (objetivo, saída esperada, prazo):

$h Definition of Ready / Done

- DoR: critérios para iniciar desenvolvimento (contexto, mocks, dados, etc.)
- DoD: critérios para aceitar merge (testes, cobertura, logging, docs)

---
context_role: tester
phase: testing
visibility: public
weight: 0.8
related: ["TECHNICAL_PLAN.md","PRD.md","ARCHITECTURE.md"]
owner: <owner>
project: <project>
date: 2025-09-07
tags: []
---

# Strategy
- Test pyramid: Unit / Integration / E2E / Contract / Performance
- Scope of this cycle:
- Environments: Dev / QA / Staging / Prod
- Test data: synthetic / masked / sampled

# Test Cases (high-level)
- Case 1:
  - Preconditions:
  - Steps:
  - Expected result:
- Case 2:

# Quality Gates
- Minimum coverage (lines/branches): ___%
- Linters/SAST: tools & rules
- Regression policy: how many failures allowed (ideally 0)
- Accessibility (if applicable): target WCAG

# Automation Pipeline
- Execution: on PR, nightly, release
- Reporting: where to see reports (CI artifacts, dashboards)
- Flakiness policy: retries / quarantine / mandatory fix

# Performance & Reliability
- SLIs/SLOs tested (p95 latency, throughput, error %) 
- Loads: spike vs sustained
- Chaos/resilience checks (timeouts, circuit breakers)

# Security & Privacy
- AuthN/AuthZ tests
- Secret management
- Personal data: anonymization/masking

# Observability Checks
- Essential logs present
- Metrics exposed (e.g., processed/min)
- Traces for critical flows

# Release Criteria
- All PRD MUSTs accepted
- Quality Gates met
- Known risks/bugs documented

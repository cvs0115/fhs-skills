# <APP_NAME> · PRD

Lean: one to two pages. What and why, not how (the how goes in `docs/architecture.md` and ADRs).
Mark anything unknown `[NEEDS CLARIFICATION]` and resolve it before planning tasks.

- **Owner / decider:** <ROLE> · **Status:** draft | agreed <YYYY-MM-DD> · **Decisions:** D-nnn …

## Problem

- **Today, without the app:** <what people do now, and what it costs them> (K1)
- **Problem statement:** <one line>

## Users and audience

- **Users:** <personas, see docs/personas.md> (K2, V1)
- **Demo / sign-off audience:** <who> (K2)
- **Reference product to match or beat:** <name and its value props, or "none"> (K10)

## Goals and success metrics

| Goal | Metric | Target | Guardrail metric |
|---|---|---|---|
| <goal> | <metric> (K3) | <target> | <what must not get worse> |

## Non-goals (out of scope for this version)

- <item> (K5) — parked on the Board as P2

## Scope and priorities

| ID | Feature / value story | Persona | Priority | Acceptance criteria (Given/When/Then or EARS) |
|---|---|---|---|---|
| F1 | <story> | <persona> | P0 | Given <state>, when <event>, then <result>. |
| F2 | <story> | <persona> | P1 | When <event>, the system shall <response>. |

## Constraints and quality needs

- **Platform / stack:** <K6> · **Budget:** <K7> · **Lifetime:** POC | product (K8)
- **Data freshness:** <Q3> · **Scale:** <Q5> · **Environments:** <Q4>
- **Performance:** <Q6> · **Availability:** <Q7> · **Browsers / widths:** <Q8, G5>
- **Compliance / data sensitivity:** <Q11, D10>
- **Demo vs real:** <Q12: which parts are demo-only, and how demo data is marked>

## Deadline and phasing

- **Deadline / demo:** <date, what must work by then> (K4)
- **First vertical slice:** <L1>

## Definition of done

<L2: e.g. real type-check clean, full suite green, GUI sweep at target widths, persona review,
Verifier PASS, Board and docs updated>

## Rollback

- <How to undo a release: previous version, config restore, data restore>

## Open questions

- [NEEDS CLARIFICATION] <question>

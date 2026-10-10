# ADR-<NNNN>: <short title of the problem and the chosen solution>

MADR-style. One ADR per significant, hard-to-reverse decision. Save as `docs/adr/<NNNN>-<slug>.md`.
Numbers are never reused or renumbered. Once accepted, don't rewrite it: supersede it with a new ADR.
Skip ADRs for easily reversible choices; the Decision Log is enough.

- **Status:** proposed | accepted | deprecated | superseded by ADR-<NNNN>
- **Date:** <YYYY-MM-DD>
- **Deciders:** <roles> · **Consulted:** <roles or agents, e.g. Researcher report path>
- **Decision Log:** D-<nnn>

## Context and problem statement

<2–4 sentences: the situation, the forces, and the question being decided. Link the evidence.>

## Decision drivers

- <driver, e.g. single writer for collected data>
- <driver, e.g. platform job time limit of N minutes>

## Considered options

1. <Option 1>
2. <Option 2>
3. <Option 3>

## Decision outcome

**Chosen:** "<Option N>", because <reason tied to the drivers>.

### Consequences

- Good: <what gets easier>
- Bad: <what gets harder, what we give up>

### Confirmation

<How we check the decision is followed: a test, a hook, a review step, a live check. E.g. "a test
fails if any stored document contains raw event fields".>

## Pros and cons of the options

### <Option 1>

- Good, because <…>
- Bad, because <…>

### <Option 2>

- Good, because <…>
- Bad, because <…>

## More information

<Links: research notes, specs, related ADRs, the Board rows that implement it.>

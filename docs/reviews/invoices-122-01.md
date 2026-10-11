# Review · invoices-122-01

2026-10-11 · Reviewer model: composer-2.5 (different family from the writer) · Subject: plan

## Verdict

APPROVE. Ops may commit the plan bundle to `main`, run PC capture after the owner gate, then `build.sh prepare` and the research/test/review cycle as written.

## Majors

- (none)

## Minors

- [Where the researcher works](docs/plans/invoices-122-01.md) says the branch is “cut” via `build.sh prepare`; [build.sh](scripts/build.sh) only clones `base` into `/srv/fhs-build/<name>` and does not create `feat/<name>`. The task’s step 1 (create/switch `feat/invoices-122-01`) matches [items-122-01](docs/plans/items-122-01.md); consider one sentence in the plan that prepare leaves the clone on `main` at the approved commit and the researcher opens the feature branch.
- Task “Where you work” still says “create … from current main” while the handoff assumes prepare already ran; align wording with “clone at approved `main`, then step 1 creates `feat/invoices-122-01`” so Ops does not skip prepare.
- Brief says append `tech-stack.md` in the “R365 section”; plan/task correctly pin [## Store 122 audit (2026-10-11)](skills/fhs-skills/references/tech-stack.md)—no change required, only brief-level vagueness.
- `pages.csv` URL checks that treat any path containing `map` / `create` as forbidden (plan test list, [T5](docs/tests/invoices-122-01.md), capture tests) can false-positive on benign R365 paths; if a run fails, judge against the stated allow-list (`invoiceId=` + `view`) rather than substring alone.

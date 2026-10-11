# Review · items-122-01-diff

2026-10-11 · Reviewer model: composer-2.5 (different family from the writer) · Subject: diff

## Verdict

APPROVE. The branch matches the approved plan and researcher task (two files only, verify-only, no browser, no R365 changes in this step); builder 8/8 and tester T1–T6 PASS align with the diff; merge into `main` may proceed (P1 remains a post-merge owner confirmation, not a merge gate).

## Majors

- (none)

## Minors

- [`skills/fhs-skills/references/tech-stack.md`](skills/fhs-skills/references/tech-stack.md) cites `countId=3` for the 10/04/2026 capture; when a newer approved count is the reference, add a line or refresh the URL so agents do not treat that id as permanent.
- [`docs/research/items-122.md`](docs/research/items-122.md) documents CNT-04 footer $7,461.69 vs Item Details $7,461.73; the note correctly prefers CNT-03—no change required, only awareness for anyone reconciling to the COUNT ENTRY screen.
- [`docs/specs/items-122.md`](docs/specs/items-122.md) **Systems and data** table still implies invoice line detail; plan review already flagged aligning the spec on merge (out of this diff’s scope).
- Problem-list **Who can fix** uses only `franchise` and `R365 support` (no `owner` / `can't tell`); consistent with Brand/Location Group and R365 DSS User on the captures, with the SAVE-button caveat documented in the note header.

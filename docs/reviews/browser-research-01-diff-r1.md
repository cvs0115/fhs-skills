# Review · browser-research-01-diff

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: diff

## Verdict

APPROVE AFTER FIXES. The merge may not proceed until the plan compliance and research gaps are corrected and reviewed again.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- The approved done-check did not pass: the researcher reported 3/5 tests passing. The later ALL PASS verdict used `/srv/fhs-build/reports/browser-research-01-test-plan-corrected.md`, an unapproved file the plan does not permit. Record the necessary ambient-process exceptions in the repository plan and test plan, re-review them, and rerun verification.
- `tech-stack.md` says every client launches its own browser without `--shared-browser-context`, but the research says `--isolated` shares one browser with separate contexts. Correct the persistent reference.
- Section 7 recommends one systemd unit but provides no `ExecStart` or supervisor, so the sketch cannot run the four required processes. Provide a concrete unit topology and reconcile the Summary.

## Minors

- Both commits place another attribution after the task-required Grok attribution, so they do not end with the specified line.

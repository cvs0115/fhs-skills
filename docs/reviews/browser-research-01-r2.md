# Review · browser-research-01

2026-10-10 · Reviewer model: gpt-5.6-sol-high (different family from the writer) · Subject: plan

## Verdict

APPROVE AFTER FIXES. The research may not start until the file allowlist is complete and internally consistent.

APPROVE AFTER FIXES is not permission to build or merge. The writer fixes the majors and gets a new review.

## Majors

- The prompt and test plan create `/srv/fhs-build/reports/browser-research-01-ss-before.txt` and `/srv/fhs-build/reports/browser-research-01-test-ss.txt`, but the plan does not name either file. Its blanket prohibition on changes outside the clone also contradicts its required reports and baselines. Name every permitted outside-repo file explicitly and exempt those files from the prohibition.

## Minors

- Replace “`pgrep` shows only the agent” with a baseline or process-tree comparison that accounts for legitimate agent child processes.
- T11 tests absolute package absence rather than whether research installed anything. Capture a before/after package and browser-cache baseline to avoid blaming pre-existing state.

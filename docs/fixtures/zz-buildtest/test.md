# Test plan · zz-buildtest-01 (test fixture)

> For a fresh Grok tester session. Hand-off: "Run the test plan in docs/tests/zz-buildtest-01.md".

## Pre-merge cases (this branch is never merged; these only check the pipeline)

| ID | Env | Steps | Expected | Evidence |
|---|---|---|---|---|
| T1 | shell | In `/srv/fhs-build/zz-buildtest`: `cat docs/zz-hello.md` | `hello from grok` | output |
| T2 | shell | `git diff --name-only zz-buildtest...feat/zz-buildtest` | only `docs/zz-hello.md` | output |

## Results

Write `/srv/fhs-build/reports/zz-buildtest-test.md` with each case, PASS/FAIL and its output. Edit nothing.

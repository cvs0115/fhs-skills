# Agent task · windows-research-01 · research

> **For the coding agent (Grok 4.7 High in cursor-agent).** This file is your whole assignment.
> Read it top to bottom, then do it. You don't see the planner's conversation and don't need it.
> Written by Claude (planner), reviewed with its plan by GPT-5.6 (`docs/reviews/windows-research-01.md` must say APPROVE).
> Hand-off: the owner tells you "Do the task in docs/prompts/windows-research-01.md".

## Context

fhs-skills is a repo of Claude skills for a Firehouse Subs owner's back office. The master repo is
`/root/fhs-skills` on the server dev-lxc-1 (a non-bare repo with `main` checked out). The owner's
Windows PC has no git, and holds the Dropbox report folders and a copy of the skills at
`C:\Users\mayur\.claude\skills\fhs-*` that payroll runs from. The owner reaches the server from the PC
with an SSH alias `dev-lxc-1`. The server can't reach the PC, and that's intended.

Plan to research: a cursor-agent on the PC clones the server repo over SSH, works on `feat/win-*`
branches, pushes only those back, refreshes the Windows skill copy from `main` when the owner says
so, and sends named reports to the server's `inbox/`. **This task is research only.** Find out how,
prove the git push rules with throwaway repos, and write it down. Someone else writes the build plan.

## Where you work

- Workspace: `/srv/fhs-build/windows-research-01`, your own clone. Before editing: `git checkout -b feat/windows-research-01`
- User `fhsbuild`, no sudo. Make one throwaway dir: `T=$(mktemp -d -t winres-XXXX)`, and record its path in your note's appendix.
  Every throwaway repo goes inside `$T`. Delete `$T` at the end.

## Read first

1. `CLAUDE.md` · 2. `docs/plans/windows-research-01.md` · 3. `docs/specs/windows-agent.md`
4. `docs/research/access-browser-windows.md` · 5. `docs/reviews/windows-agent-01-r1.md` (why the first design came back)

## Questions to answer (one section each in your note)

1. **cursor-agent on Windows.** The official install method and command for Windows, sign-in steps,
   and whether `--mode`, `--sandbox`, `--workspace` and `-p` exist on Windows. Cite Cursor's docs (URLs).
2. **Git for Windows over SSH.** How Git for Windows uses an existing OpenSSH config alias (`~/.ssh/config`
   under `C:\Users\<user>\.ssh`), and how to make it non-interactive (key, agent). The exact clone command
   for `dev-lxc-1:/root/fhs-skills`. Note that the server user is root, and what that means for the push path.
3. **Push rules, proven.** In a throwaway setup, make a non-bare "server" repo with `main` checked out, plus a
   `pre-receive` hook (write the hook text in the note) that refuses `refs/heads/main` and any ref not matching
   `refs/heads/feat/win-[a-z0-9-]+`, and refuses deletes and non-fast-forward updates. Clone it, then show
   real output for: push `feat/win-hello` (accepted), push `main` (refused), push `feat/other` (refused),
   force-push `feat/win-hello` (refused), delete `feat/win-hello` (refused). Also show what
   `receive.denyCurrentBranch` does by default.
4. **Mirror refresh.** A PowerShell approach (text only, not run) that compares server `main`'s `skills/fhs-*`
   (from the PC clone after `git pull`) with `C:\Users\mayur\.claude\skills\fhs-*` by SHA-256, lists the
   differences, asks for confirmation, copies, then re-hashes and prints matched/unmatched counts.
   Note how to handle files that exist only on the Windows side (report them, don't delete).
5. **Report transfer.** `scp` from PowerShell to `dev-lxc-1:/root/fhs-skills/inbox/` and a SHA-256 check on
   both sides (`Get-FileHash` vs `sha256sum`). Note: `inbox/` is gitignored on the server (check `.gitignore` in your clone).
6. **Risks.** What a Windows agent with `--force` can do on the PC. What limits exist (a workspace folder,
   `--sandbox` on Windows if any). A recommendation for which jobs need `--force` and which can run in `--mode ask`.

Then an **Owner checklist (PC side)** section with blanks, for the owner to fill in on the PC:
- `ssh dev-lxc-1 true` works without a password prompt: ___
- `where git` output: ___ · OK to install Git for Windows: ___
- OK to install cursor-agent on the PC: ___
- Dropbox root path: ___ (expected `C:\Users\mayur\DropboxCS\Dropbox\CMVK Food Services`)
- `C:\Users\mayur\.claude\skills` exists and lists `fhs-*`: ___
- Is Documents redirected to OneDrive: ___

## You may edit only

- `skills/fhs-skills/references/tech-stack.md`: append one section `## Windows agent (research <today>)`, with one line per
  **confirmed** fact and a pointer to the note's section. Change nothing else in that file.
- Your report `/srv/fhs-build/reports/windows-research-01.md` (outside the repo).
- `docs/research/windows-agent.md` (new). Header line `# Research · windows-agent · Windows agent setup`
  and the date, then sections 1–6, the owner checklist, and "Summary: recommended setup, open `(?)` items".

## You must not

- Edit any other file. Fill in the owner checklist yourself (leave the blanks). Install a hook in your clone or anywhere outside your `mktemp -d` dirs. Use sudo.
- Contact the PC, or SSH anywhere. Guess: every claim gets a source (command + output, or a URL), or `(?)`.

## Tests (run every one, record the real output)

1. `grep -c '^## ' docs/research/windows-agent.md` → at least 8 (sections 1–6 + checklist + Summary)
2. `grep -c 'refused\|rejected' docs/research/windows-agent.md` → at least 4 (the proven refusals)
3. `git diff --name-only main...HEAD` → only `docs/research/windows-agent.md` and `skills/fhs-skills/references/tech-stack.md`;
   `git diff main...HEAD -- skills/fhs-skills/references/tech-stack.md` → only added lines, in the one new section
4. `test -e "$T" && echo LEFT || echo GONE` (with the path recorded in your note) → `GONE`

## When done

1. Commit on `feat/windows-research-01`, ending the message with `Co-Authored-By: Grok 4.7 High (cursor-agent)`.
2. Write your report to `/srv/fhs-build/reports/windows-research-01.md`:

```text
Task: windows-research-01 · Branch: feat/windows-research-01 · Commits: <hashes>
Files changed: <list>
Tests: <n>/4 passed. For each: command, trimmed output, pass/fail
Open (?) items: <list>
```

If a step can't be done exactly as written, stop, write the report with the reason, and don't work around it.

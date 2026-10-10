# Plan · <slug>-<nn> · <title>

<YYYY-MM-DD>. Plan only, not approved. Don't build from it until `docs/reviews/` holds an APPROVE for this file.

- Hub project: `projects/<slug>` · Phase: <plan page phase, if any>
- Spec: `docs/specs/<slug>.md` · Decisions that bind it: <hub log entries, by date>

## Verdict

<Build, or no build (the row is already true, or the change isn't worth it).>

## What changes, in plain words

<2–4 sentences the owner could read.>

## Files the builder may edit

- `<path>`

## Files the builder must not edit

- Anything under `/root/fhs-skills` itself (the served tree). Work only in the worktree below.
- `shared/config.json` unless this plan names the exact keys.
- <files owned by another plan>

## Live systems touched

<None, or each Toast / R365 / ADP change listed exactly. Each one still needs the owner's yes at the time.>

## Done-check (real outcome)

<The real-data check that proves it: which week folder or R365 report, which numbers must match.
Name the evidence, not a status word.>

## Where it runs

<Server (dev-lxc-1), the owner's Windows desktop, or both. For the desktop: which Windows apps it needs, and that deploying it is a mirror refresh (a separate OK).>

## Which tree is live

- **Served tree (server):** `/root/fhs-skills` on `main`, loaded through `/root/.claude/skills/fhs-*`.
- **Windows mirror:** <affected? A refresh is a separate OK.>
- **Live before merge:** <what sessions still get until the merge>

## Where the builder works

- Worktree `/root/fhs-skills-wt/<name>` · branch `feat/<name>` · cut from `main` at `<commit>`

## What stays

<Behavior, rules, outputs and file formats this plan doesn't change.>

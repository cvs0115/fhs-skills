# R2 — External practices for a generic Claude Code + sub-agent app framework

Research date: **2026-09-26** (every source below was seen on this date unless noted). Primary sources preferred;
publication dates are given where the source states one. "Adopt" lists are tuned for **a small team (1–3 humans) plus
AI agents**. Each "Skip" list names what costs more than it returns at that size.

Source keys ([S1] and so on) are listed in full at the end.

---

## 1. AI-agent and multi-agent software development

### What Anthropic says (primary)
- **Context is the main constraint.** "Claude's context window fills up fast, and performance degrades as it fills." Every
  practice follows from this: `/clear` between tasks, subagents for investigation, compaction. [S1]
- **Verification closes the loop.** "Give Claude a check it can run: tests, a build, a screenshot to compare." There are
  four strengths of gate: in the prompt, a `/goal` condition, a **Stop hook** (deterministic), or a **verification
  subagent** so "the agent doing the work isn't the one grading it". Agents should show evidence, not just assert
  success. [S1]
- **Explore → Plan → Implement → Commit**, with plan mode for the first two. Skip the plan "if you could describe the diff
  in one sentence." [S1]
- **Interview, then spec, then a fresh session.** Claude interviews you with AskUserQuestion and writes `SPEC.md`. You then
  implement in a new session. The best specs "name the files and interfaces involved, state what is out of scope, and end
  with an end-to-end verification step." [S1]
- **CLAUDE.md is advisory; hooks are deterministic.** Keep CLAUDE.md short. Test each line with "Would removing this cause
  Claude to make mistakes?" Aim for under 200 lines per file. Use `.claude/rules/` for path-scoped rules and skills for
  knowledge needed only sometimes. To *block* an action, use a PreToolUse hook. [S1][S2]
- **Skills use progressive disclosure.** Only the description is always loaded; the body loads when the skill is used.
  Keep each skill under 500 lines. Set `disable-model-invocation: true` for side-effecting workflows such as deploy or
  commit. [S3]
- **Subagents** get their own context, a tool allowlist, a model and a permission mode. They can use `isolation: worktree`
  and persistent `memory`. Use them for high-volume or self-contained work. Keep iterative work, and phases that share
  heavy context, in the main thread. They do **not** inherit the conversation history, so the delegation prompt must
  carry what they need. [S4]
- **Agent teams** (still experimental in 2026-09) have a lead, teammates, a shared task list with dependencies, and
  mailboxes. "Start with 3-5 teammates", "5-6 tasks per teammate", and "each teammate owns a different set of files".
  Start with research and review before parallel implementation. TaskCompleted and TeammateIdle hooks work as quality
  gates. A message between agents is never consent from the user. [S5]
- **Worktrees** isolate parallel edits. Use `claude --worktree <name>`, a subagent with `isolation: worktree`, and
  `.worktreeinclude` for gitignored env files. Claude Code blocks edits and git commands that escape the worktree into the
  main checkout. [S6]
- **Adversarial review:** a fresh subagent sees only the diff and the criteria. Tell it to flag only gaps that affect
  correctness or requirements, because "chasing every finding leads to over-engineering." [S1]
- **Writer/Reviewer and test-writer/implementer splits** across sessions: fresh context removes the bias toward code the
  agent just wrote. [S1]
- **Building Effective Agents (2024-12-19)** names five patterns: prompt chaining, routing, parallelization,
  orchestrator-workers and evaluator-optimizer. It advises adding complexity "only when it demonstrably improves
  outcomes." [S7]
- **Multi-agent research system (2025-06-13):**
  - Each delegation needs "an objective, an output format, guidance on the tools and sources to use, and clear task
    boundaries."
  - Scale the effort to the task: 1 agent for a simple lookup, 2–4 for comparisons, 10 or more only for broad research.
  - Multi-agent uses about 15× the tokens of chat.
  - It is a poor fit when work shares context or has heavy dependencies: "coding typically lacks sufficient
    parallelizable work."
  - Subagents should write their outputs to the filesystem and pass references back. [S8]
- **Context engineering (2025-09-29):** compaction, structured note-taking outside the context window, sub-agent
  architectures and just-in-time retrieval. [S9]
- **Long-running harnesses (2025-11-26):**
  - An initializer agent writes a JSON **feature list**, with every item starting as failing; agents flip only `passes`.
  - Keep a **progress file**.
  - Do **one feature per session**, commit each with a descriptive message, and test end-to-end in a browser. This
    prevents "premature victory". [S10]
- **Evals for agents (2026-01-09):**
  - Start with "20-50 simple tasks drawn from real failures."
  - Mix code, model and human graders.
  - Separate capability evals from regression evals.
  - Read the transcripts. [S11]
- **Permissions:**
  - Rules are evaluated deny → ask → allow, and the first match wins. An allow rule can't carve an exception out of a
    deny rule.
  - Bash deny rules are not a security boundary. Use the sandbox for OS-level enforcement. [S12]
  - Sandboxing (filesystem plus network isolation) "safely reduces permission prompts by 84%" and contains prompt
    injection. [S13]
- **Tools and ACI (2025-09-11):**
  - Build fewer, workflow-shaped tools, and namespace them.
  - Return human-readable context and keep outputs token-efficient.
  - Treat tool descriptions as prompts. [S14]
- **Guardrail threat list:** OWASP LLM Top 10 2025, especially LLM01 Prompt Injection, LLM06 Excessive Agency and LLM10
  Unbounded Consumption. [S15]

### Role split used by practitioners
- BMAD's named agents are Analyst, PM, Architect, UX Designer and Developer (the Developer also owns QA, review and
  retros). [S17]
- Spec Kit splits the work by *phase*, not by persona. [S16]
- Anthropic suggests adding roles only when they are parallel and independent: reviewers split by lens (security,
  performance, tests), competing-hypothesis debuggers, or a writer and a reviewer. [S5][S1]
- The common minimum set is:
  - **Planner or architect** (read-only, plan mode)
  - **Builder** (write access, in a worktree)
  - **Reviewer or verifier** (fresh context, read-only plus test run)
  - **Researcher** (read-only, web)

### Adopt (small team + agents)
1. **Verification-first tasks.** Every task names its check (test, build, screenshot, script) and every agent reports
   evidence. *Why:* the loop closes without a human in it. [S1]
2. **Plan mode for multi-file or uncertain work, direct edits for one-sentence diffs.** *Why:* you avoid solving the wrong
   problem without making tiny tasks heavy. [S1]
3. **A short CLAUDE.md or AGENTS.md (under 200 lines), `.claude/rules/` for path rules, skills for workflows.** *Why:*
   adherence drops as the file grows. [S1][S2][S3]
4. **Hooks for must-always rules:** format after edit, block protected paths, a Stop hook that runs tests. *Why:*
   instructions are advisory and hooks are guaranteed. [S1][S2]
5. **Read-only research and review subagents with tool allowlists. Write output to files and pass paths back.** *Why:*
   keeps the main context clean and follows least privilege. [S4][S8]
6. **At most 2–3 parallel builders, each in its own worktree with disjoint file ownership.** *Why:* parallelism pays only
   when the work is independent, and shared files cause overwrites. [S5][S6][S8]
7. **A fresh-context adversarial reviewer before "done", limited to correctness and requirements findings.** *Why:* it
   catches the plausible-but-wrong without gold-plating. [S1]
8. **A feature list plus a progress file as durable state across sessions, with one feature per session.** *Why:*
   long-running agents lose state and declare victory early. [S10]
9. **Delegation prompt template:** objective, output format, tools and sources, boundaries, done-check. *Why:* vague
   delegation duplicates work and misses coverage. [S8]
10. **Sandbox plus deny rules on secrets. Treat inter-agent messages as untrusted, never as approval.** *Why:* this limits
    prompt injection and excessive agency. [S12][S13][S15][S5]

### Skip for a small team
- Large agent teams (more than 5) or nested orchestration. The token cost grows linearly and coordination overhead
  dominates. [S5][S8]
- Parallel builders on tightly coupled code. Anthropic notes coding is usually not parallelizable. [S8]
- Encoding "never do X" only in prose. Use a hook or a deny rule instead. [S2]

---

## 2. Spec-driven development (SDD) with AI

| Method | Prescribes | Artifacts |
|---|---|---|
| **GitHub Spec Kit** [S16] | "Constitution once per project; specify → plan → tasks → implement → converge per feature"; optional clarify, checklist and analyze gates; also bug (assess → fix → test) and idea-assessment (intake → research → define → shape → decide) flows | `constitution.md`, `spec.md` (what and why, user stories, acceptance, success metrics, **no how**), `plan.md` (tech choices with rationale, `data-model.md`, `contracts/`, `research.md`), `tasks.md` |
| **Spec Kit philosophy** [S18] | `[NEEDS CLARIFICATION]` markers instead of guessing; phase gates (simplicity: at most 3 projects; anti-abstraction: "use framework features directly"; integration-first testing with real services); test-first ("tests … confirmed to FAIL" before code) | templates as constraints on the LLM |
| **BMAD Method** [S17][S19] | Clarify → Plan → Build and verify → Learn; "right-sized" entry points (a vague idea enters at Clarify, a clear big idea at Plan, a small change at Build) | brief or PRFAQ (Analyst), PRD (PM), architecture (Architect), UX design (UX), epics, stories and sprint status (PM/Dev), test design and code review (Dev) |
| **AWS Kiro** [S20][S21] | Requirements (or bug analysis) → Design → Tasks; requirements-first or design-first; a "Quick Spec" skips the approval gates; tasks run in parallel from a dependency graph; steering files and hooks | `requirements.md` (user stories + **EARS** acceptance criteria), `design.md` (architecture, sequence diagrams, components), `tasks.md` (traceable to requirements, with live status) |
| **Cursor rules** [S22] | `.cursor/rules/*.mdc` with Always, Intelligent, Glob-attached or Manual rules; under 500 lines; AGENTS.md accepted | rule files |
| **Cline rules** [S23] | `.clinerules/` with `paths:` frontmatter for conditional rules; reads `.cursorrules`, `.windsurfrules` and AGENTS.md; "include the why" | rule files |
| **AGENTS.md** [S24] | "A README for agents": build and test commands, style, testing, security, commit and deploy notes; the nearest file in the tree wins; 25+ tools support it; stewarded by the Agentic AI Foundation (Linux Foundation). Claude Code can read it alongside CLAUDE.md [S2] | `AGENTS.md` (nested per package) |

**What they share:**
- A project-level constitution or steering file.
- A spec of *what and why* that is separate from a plan of *how*.
- Explicit acceptance criteria.
- A task list traced to requirements.
- A human approval gate between phases.
- Implementation checked back against the spec.

**Critique (Böckeler / martinfowler.com, 2025-10-15):**
- There are three levels: spec-first, spec-anchored and spec-as-source.
- The tools are overkill for small changes. One small bug turned into "4 user stories with a total of 16 acceptance
  criteria."
- The markdown is a review burden: "I'd rather review code than all these markdown files."
- Agents still ignore specs.
- Large contexts give an illusion of control. [S25]

### Adopt
1. **A one-page constitution** of non-negotiables (stack, testing, security, simplicity). *Why:* a stable anchor for every
   agent. [S16][S18]
2. **Spec (what and why) separate from plan (how).** *Why:* reviewers can validate intent without reading the tech
   choices. [S18]
3. **`[NEEDS CLARIFICATION]` markers plus a clarify step before planning.** *Why:* the agent surfaces uncertainty instead
   of making plausible guesses. [S18]
4. **EARS acceptance criteria in requirements.** *Why:* each criterion becomes a test directly. [S20][S26]
5. **Tasks traced to requirement IDs, with a done-check per task and dependency order so tasks can run in parallel.**
   *Why:* enables safe fan-out and a convergence check. [S20][S16]
6. **Right-size by entry point** (a small change goes straight to build). *Why:* avoids the overkill Böckeler
   describes. [S19][S25]
7. **A converge or analyze step:** compare the implementation against spec and tasks until they match. *Why:* catches drift
   and agent non-compliance. [S16][S25]
8. **AGENTS.md as the tool-neutral instruction file**, with CLAUDE.md importing or adding to it. *Why:* works across
   tools. [S24][S2]

### Skip for a small team
- Spec-as-source, where code is regenerated from the spec. [S25]
- Full BMAD persona theatre for every change.
- Separate SM and PO agents.
- Multi-file spec sets for bug fixes; use a bug-assess note instead. [S16]

---

## 3. Requirements and product discovery

### Adopt
1. **A lean one-page PRD:** problem, goals, **non-goals**, users, success metrics plus guardrail metrics, scope, open
   questions, rollback. *Why:* the non-goals section is what keeps agents in scope. [S27][S28]
2. **JTBD framing.** Name the progress the user wants in a given circumstance, including its functional, social and
   emotional dimensions. *Why:* anchors features to motives rather than demographics. [S29]
3. **Proto-personas, labelled as hypotheses, then qualitative personas (5–30 interviews) when the product matters.**
   *Why:* proto-personas are cheap but "can be an echo chamber"; qualitative personas are the best return for most
   teams. [S30]
4. **User stories that meet INVEST**, with acceptance criteria. *Why:* small, testable and negotiable units for
   agents. [S31]
5. **Acceptance criteria in EARS** (system behaviour) or **Gherkin** (user-flow examples):
   - EARS patterns: Ubiquitous; While (state); When (event); Where (feature); If/then (unwanted); complex combinations.
     [S26]
   - Gherkin: Feature, Rule, Scenario, Given/When/Then, Background, Scenario Outline. [S32]
   - *Why:* criteria that can be executed directly.
6. **MoSCoW for scope** (DSDM: Musts at most 60% of effort, Coulds about 20% as contingency). **RICE** for ranking the
   backlog: Reach × Impact (3 / 2 / 1 / 0.5 / 0.25) × Confidence (100 / 80 / 50%) ÷ Effort. *Why:* MoSCoW protects
   delivery and RICE makes trade-offs explicit. [S33][S34]
7. **A Definition of Done**, the formal quality bar for the increment (a Scrum Guide artifact). Add a lightweight
   "ready" checklist of acceptance criteria present, dependencies known and check named. *Why:* agents need explicit
   stop criteria. Note that the Scrum Guide 2020 has no Definition of Ready; readiness is described as the outcome of
   refinement. [S35]

### Skip for a small team
- Statistical personas (100+ surveys). [S30]
- Long 10-page PRDs.
- A formal DoR used as a gate: the Scrum Guide does not define one, and a rigid DoR slows flow. [S35]

---

## 4. Decision records

### Adopt
1. **A Nygard ADR for every significant, hard-to-reverse decision:** Title, Context, Decision ("We will…"), Status
   (proposed / accepted / deprecated / superseded), Consequences. Keep it to 1–2 pages, numbered and never renumbered,
   immutable once superseded, and stored in the repo. *Why:* cheap, and future agents can read it. [S36]
2. **The MADR 4.0 minimal template** (2024-09-17): Context and Problem, Considered Options, Decision Outcome, plus the
   optional Drivers, Consequences, **Confirmation** (how compliance is checked) and pros/cons. Files are named
   `NNNN-title.md`. *Why:* the "considered options" and "confirmation" sections stop agents from re-litigating a
   decision. [S37]
3. **A mini design doc (1–3 pages) for ambiguous features:** context and scope, goals and non-goals, design,
   alternatives considered, cross-cutting concerns (security, privacy, observability). Write one when three or more
   triggers apply (ambiguous or contentious, benefits from senior review, cross-cutting concerns tend to be forgotten).
   *Why:* trade-offs are thought through before code. [S38]
4. **A decision brief (options plus a recommendation) for user decisions.** This is the same MADR shape, addressed to the
   decision-maker. [S37]
5. **An RFD/RFC-style lightweight status flow** (ideation → discussion → published → committed / abandoned). "Timely
   rather than polished." *Why:* ideas can be captured early. [S39]

### Skip for a small team
- 10–20-page design docs. [S38]
- Formal RFC review boards.
- ADRs for easily reversible choices.

---

## 5. Architecture and data

### Adopt
1. **C4 levels 1–2 (Context, Container), and Component only where it helps.** C4 is notation-independent, and most teams
   need only the first two or three levels. *Why:* a cheap shared map for humans and agents. [S40]
2. **API-first contracts** (OpenAPI or a typed schema in `contracts/`) before implementation. *Why:* lets frontend and
   backend agents build in parallel. [S16][S18]
3. **A data-model checklist:** entities and IDs (**stable IDs, never display names, as keys**), ownership, retention,
   PII class, source of truth, and migration or versioning plan. *Why:* data mistakes are the hardest to reverse.
   This is synthesis; Spec Kit also produces `data-model.md`. [S16]
4. **Idempotency:** client-generated idempotency keys; the server stores the result and replays it; retries use
   exponential backoff with jitter. *Why:* makes retries and scheduled jobs safe. [S41]
5. **Observability from day one:**
   - OTel signals: traces, metrics and logs.
   - The four golden signals: latency, traffic, errors, saturation.
   - Alert on symptoms, and make every page actionable.
   - *Why:* you can't operate what you can't see. [S42][S43]
6. **A lightweight threat model per feature:** the four questions ("What are we working on? What can go wrong? What are
   we going to do about it? Did we do a good enough job?") walked through with STRIDE. *Why:* finds design flaws
   early. [S44][S45]
7. **OWASP Top 10:2025 as the review checklist:** A01 Broken Access Control, A02 Misconfiguration, A03 Supply Chain, A04
   Crypto, A05 Injection, A06 Insecure Design, A07 AuthN, A08 Integrity, A09 Logging and Alerting, A10 Exceptional
   Conditions. **ASVS 5.0** (released May 2025, about 350 requirements in 17 chapters) Level 1 as the baseline, L2 for
   anything handling sensitive data. *Why:* these are the standard verification bars. [S46][S47]
8. **Least privilege** — "restrict the access privileges … to the minimum necessary". Apply it to OAuth scopes, service
   accounts, agent tools and CI tokens. [S48][S12]
9. **Anti-abstraction and simplicity gates:** use framework features directly and justify every added project or
   layer. [S18]

### Skip for a small team
- C4 Code-level diagrams. [S40]
- Full ASVS L3.
- Formal threat-modeling tools. [S44]
- Microservices, and consumer-driven contracts where you don't control both sides. [S49]

---

## 6. UI/UX

### Adopt
1. **A small design system: tokens (colour, type, spacing) plus a component inventory.** The W3C DTCG token format
   reached its first stable version, 2025.10 (2025-10-28). *Why:* consistent UI across agent-built pages. [S50]
2. **Nielsen's 10 heuristics as the UI review rubric** (status visibility, match to the real world, user control,
   consistency, error prevention, recognition over recall, flexibility, minimalism, error recovery, help). *Why:* a fast
   and well-known review lens. [S51]
3. **WCAG 2.2 AA essentials:**
   - The 2.1 AA set, plus the new AA criteria: 2.4.11 Focus Not Obscured, 2.5.7 Dragging alternative, 2.5.8 **Target size
     at least 24×24 CSS px**, 3.3.8 Accessible Authentication.
   - The new A criteria: 3.2.6 Consistent Help, 3.3.7 Redundant Entry.
   - 4.1.1 Parsing was removed.
   - Published 2023-10-05.
   - *Why:* the legal and usability baseline. [S52]
4. **Mobile-first responsive breakpoints** (Tailwind defaults: 640 / 768 / 1024 / 1280 / 1536 px). *Why:* one well-known
   scale for all agents to test against. [S53]
5. **Dashboard practices:**
   - Decide whether the dashboard is operational or analytical.
   - Encode quantities with length or position (bars, lines); avoid pies, gauges and 3D.
   - Use colour for categories, not quantities, and keep it colourblind-safe. [S54]
   - Use progressive disclosure: key figures first, detail on demand, **no more than two levels**. [S55]
   - *Why:* hierarchy and glanceability.
6. **Screenshot-based visual checks by the agent** (implement, screenshot, compare, fix). *Why:* agents are otherwise
   blind to layout. [S1]

### Skip for a small team
- A bespoke full design-system site.
- AAA conformance as a goal.
- Pixel-perfect visual regression across many OSes and browsers. [S57]

---

## 7. Testing and delivery

### Adopt
1. **The testing trophy for web apps:** static (types, lint), then a few units, **mostly integration**, then a handful of
   E2E ("write tests, not too many, mostly integration"). Pair it with the pyramid rule of not duplicating coverage at
   higher levels, and keep E2E to one or two critical journeys. *Why:* the best confidence per unit of effort. [S56][S58]
2. **Playwright E2E:**
   - Role-based locators (`getByRole`), web-first assertions, isolated tests.
   - Mock third parties.
   - Trace viewer on CI failure.
   - Sharding when the suite grows.
   - *Why:* resilient tests that agents can debug. [S59]
3. **Visual regression, used sparingly:** `toHaveScreenshot` baselines generated and compared **in the same environment**
   (for example the CI container), with `maxDiffPixels` and masking for volatile regions. *Why:* rendering varies by
   OS. [S57]
4. **Contract tests:** Pact only where you own both consumer and provider; otherwise validate against the schema or
   spec. *Why:* catches integration drift cheaply. [S49][S58]
5. **CI gates on every PR:** typecheck, lint, unit and integration tests, build, a secret scan, and E2E smoke on main.
   A Stop hook runs the same checks locally for agents. *Why:* one definition of green. [S1][S59]
6. **Trunk-based development with short-lived branches** (from agent worktrees), a releasable trunk and flags for
   unfinished work. Git-flow is right only for "explicitly versioned" software or several supported versions; its author
   says web apps should use "a much simpler workflow." *Why:* less merge pain with parallel agents. [S60][S61]
7. **SemVer** (MAJOR / MINOR / PATCH, `0.y.z` while unstable, pre-release tags) for anything with a public API or
   package. Tag each release. [S62]
8. **Feature flags as inventory:** release toggles are short-lived and removed after launch; ops "kill switches" are
   allowed; each flag has an expiry and a removal task. [S63]
9. **A release checklist**, tracked with the DORA metrics: change lead time, deployment frequency, failed-deployment
   recovery time, change fail rate, rework rate. *Why:* measures whether the process helps. [S64]
10. **Eval sets for agent-facing features**, started from 20–50 real failures, with a regression set kept near 100%.
    [S11]

### Skip for a small team
- Full git-flow (release and hotfix branches) for a continuously deployed web app. [S61]
- Large E2E suites. [S58]
- Cross-browser visual matrices.
- A flag platform before you have more than a handful of flags. [S63]

---

## 8. Project tracking

### Adopt
1. **A single visible Kanban board:** Next → In progress → Review/Verify → Waiting on user → Done. *Why:* the Kanban
   practice "Visualize". [S65]
2. **WIP limits** on In progress (for example the number of builders, 2–3) and on Review. "Effective systems focus more on
   flow of work and less on worker utilization." Pull, don't push. *Why:* fewer context switches and delays. [S65]
3. **Explicit policies on the board:** entry criteria (ready checklist), exit criteria (DoD), who may move cards. *Why:*
   agents can follow written policy. [S65][S35]
4. **Durable machine-readable state:** a feature list (JSON) with pass/fail plus a progress log alongside the board.
   *Why:* sessions can resume without re-explaining. [S10]
5. **A short feedback loop after each release:** what changed, flow metrics, rule updates. *Why:* improve collaboratively
   and evolve experimentally. [S65]

### Skip for a small team
- Sprints with velocity or story-point ceremonies.
- Multiple boards.
- Heavy Jira workflows. The Kanban Guide's practices are enough. [S65]

---

## Synthesis — recommended phase model

The gate at every phase is a **human approval**. It is skippable for a small change according to the right-sizing rule
(small change goes straight to Build; bug goes to Assess → Build; clear feature starts at Requirements; vague idea starts
at Discovery). [S19][S16][S1]

| # | Phase | Key artifacts | Owner agent role (human approver) | Gate / done-check |
|---|---|---|---|---|
| 0 | **Setup (once)** | `constitution.md`, `AGENTS.md`/`CLAUDE.md` (under 200 lines), `.claude/rules/`, agent definitions, hooks, permission deny list, CI skeleton, board | Coordinator (tech lead) | Hooks and CI run green on an empty app |
| 1 | **Discovery** | JTBD statements, proto-personas (flagged as hypotheses), problem statement, open questions | Analyst / researcher (read-only, web) — product owner | Problem and user agreed |
| 2 | **Requirements** | Lean PRD (goals, **non-goals**, metrics), user stories (INVEST) with **EARS/Gherkin** acceptance criteria, MoSCoW scope, `[NEEDS CLARIFICATION]` list resolved | PM agent (interviews the user with AskUserQuestion) — product owner | Every story has testable criteria; nothing left to clarify |
| 3 | **Research / spikes** | `research.md`, spike findings with evidence, API and data availability checks | Researcher (parallel read-only subagents writing to files) | Each assumption verified or marked a risk |
| 4 | **Architecture and data** | C4 L1–L2, `data-model.md` (IDs, ownership, retention, PII), `contracts/` (API-first), ADRs (MADR), STRIDE threat notes, observability plan | Architect (plan mode) — tech lead | ADRs accepted; threat questions answered; constitution gates pass |
| 5 | **UI / UX** | Tokens and component inventory, page wireframes, dashboard hierarchy (progressive disclosure), a11y (WCAG 2.2 AA) checklist | UX agent — product owner | Heuristic review passes; breakpoints defined |
| 6 | **Plan / tasks** | `plan.md`, `tasks.md` traced to requirement IDs, with dependencies, file ownership and a **done-check per task**; feature-list JSON; board cards | Planner / architect — tech lead | Tasks small, disjoint files, WIP limits set |
| 7 | **Build** | Code plus tests on short-lived branches in **worktrees**, one feature per session, progress log | Builders (at most 2–3, write access, isolated) | Task check green; evidence attached |
| 8 | **Verify** | Adversarial review report (correctness and requirements only), Playwright E2E, screenshot comparison, security review against the OWASP Top 10, converge report (spec ↔ code) | Reviewer / tester (fresh context, read-only plus test run) | CI green; DoD met; converged |
| 9 | **Release** | SemVer tag, changelog, release checklist, flag plan, rollback plan | Release / build manager — human approval for push and deploy | Pre-flight checklist complete; secret scan clean |
| 10 | **Operate / handoff** | Runbook, dashboards (golden signals), alert list, platform inventory, handoff log, DORA metrics, retro notes feeding rules and CLAUDE.md | Ops / docs agent — tech lead | Alerts actionable; handoff record current |

**Cross-cutting rules for all phases:**
1. Every delegation states its objective, output format, tools, boundaries and done-check. [S8]
2. Agents write large outputs to files and return paths. [S8]
3. Decisions go to ADRs, and live state goes to the feature list, progress log and board. [S10][S36]
4. Hooks and permissions enforce what matters. Prose only advises. [S2][S12]
5. The agent that produced the work never grades it. [S1]
6. Add agents only when the work is parallel and independent. [S7][S8]

---

## Sources (all seen 2026-09-26)
- [S1] Claude Code — Best practices. https://code.claude.com/docs/en/best-practices
- [S2] Claude Code — How Claude remembers your project (CLAUDE.md, AGENTS.md, rules, auto memory). https://code.claude.com/docs/en/memory
- [S3] Claude Code — Skills. https://code.claude.com/docs/en/skills
- [S4] Claude Code — Subagents. https://code.claude.com/docs/en/sub-agents
- [S5] Claude Code — Agent teams (experimental). https://code.claude.com/docs/en/agent-teams
- [S6] Claude Code — Worktrees. https://code.claude.com/docs/en/worktrees
- [S7] Anthropic — Building effective agents (2024-12-19). https://www.anthropic.com/engineering/building-effective-agents
- [S8] Anthropic — How we built our multi-agent research system (2025-06-13). https://www.anthropic.com/engineering/multi-agent-research-system
- [S9] Anthropic — Effective context engineering for AI agents (2025-09-29). https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- [S10] Anthropic — Effective harnesses for long-running agents (2025-11-26). https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
- [S11] Anthropic — Demystifying evals for AI agents (2026-01-09). https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- [S12] Claude Code — Configure permissions. https://code.claude.com/docs/en/permissions
- [S13] Anthropic — Claude Code sandboxing (2025-10-20). https://www.anthropic.com/engineering/claude-code-sandboxing
- [S14] Anthropic — Writing effective tools for agents (2025-09-11). https://www.anthropic.com/engineering/writing-tools-for-agents
- [S15] OWASP — Top 10 for LLM Applications 2025. https://genai.owasp.org/llm-top-10/
- [S16] GitHub Spec Kit README. https://github.com/github/spec-kit (raw README read for the command list)
- [S17] BMAD — Skills and agents reference. https://docs.bmad-method.org/reference/skills-and-agents/
- [S18] Spec Kit — spec-driven.md (SDD philosophy, constitution articles). https://github.com/github/spec-kit/blob/main/spec-driven.md
- [S19] BMAD Method docs home and GitHub. https://docs.bmad-method.org/ ; https://github.com/bmad-code-org/BMAD-METHOD
- [S20] Kiro — Feature specs (EARS). https://kiro.dev/docs/specs/feature-specs/
- [S21] Kiro — Specs overview. https://kiro.dev/docs/specs/
- [S22] Cursor — Rules. https://cursor.com/docs/context/rules
- [S23] Cline — Rules. https://docs.cline.bot/features/cline-rules
- [S24] AGENTS.md. https://agents.md/
- [S25] B. Böckeler — Understanding Spec-Driven Development: Kiro, spec-kit, and Tessl (2025-10-15). https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html
- [S26] A. Mavin — EARS. https://alistairmavin.com/ears/
- [S27] Lean PRD template survey (secondary; non-goals, metrics, rollback). https://www.prodmgmt.world/blog/prd-template-guide ; https://scribe.com/page-templates/lean-prd-template
- [S28] Google design docs (goals and non-goals pattern). https://www.industrialempathy.com/posts/design-docs-at-google/
- [S29] Christensen et al. — Know Your Customers' "Jobs to Be Done", HBR (2016-09). https://hbr.org/2016/09/know-your-customers-jobs-to-be-done
- [S30] NN/g — 3 Persona Types (2020-06-21). https://www.nngroup.com/articles/persona-types/
- [S31] B. Wake — INVEST in Good Stories (2003-08-17). https://xp123.com/articles/invest-in-good-stories-and-smart-tasks/
- [S32] Cucumber — Gherkin reference. https://cucumber.io/docs/gherkin/reference/
- [S33] Agile Business Consortium — MoSCoW prioritisation (DSDM). https://www.agilebusiness.org/dsdm-project-framework/moscow-prioritisation.html (read through search snippet)
- [S34] S. McBride — RICE, Intercom (2018-01-05). https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/
- [S35] Scrum Guide 2020. https://scrumguides.org/scrum-guide.html
- [S36] M. Nygard — Documenting Architecture Decisions (2011-11-15). https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- [S37] MADR 4.0.0 (2024-09-17). https://adr.github.io/madr/
- [S38] M. Ubl — Design Docs at Google (2020-07-06). https://www.industrialempathy.com/posts/design-docs-at-google/
- [S39] Oxide — RFD 1: Requests for Discussion. https://oxide.computer/blog/rfd-1-requests-for-discussion
- [S40] C4 model. https://c4model.com/
- [S41] Stripe — Designing robust and predictable APIs with idempotency (2017-02-22). https://stripe.com/blog/idempotency
- [S42] OpenTelemetry — Signals. https://opentelemetry.io/docs/concepts/signals/
- [S43] Google SRE Book — Monitoring Distributed Systems. https://sre.google/sre-book/monitoring-distributed-systems/
- [S44] Threat Modeling Manifesto. https://www.threatmodelingmanifesto.org/
- [S45] Microsoft — Threat Modeling Tool threats (STRIDE). https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats
- [S46] OWASP Top 10:2025. https://top10.owasp.org/2025
- [S47] OWASP ASVS (GitHub) and 5.0 release notes (secondary). https://github.com/OWASP/ASVS ; https://softwaremill.com/whats-new-in-asvs-5-0/
- [S48] NIST CSRC Glossary — least privilege. https://csrc.nist.gov/glossary/term/least_privilege
- [S49] Pact docs. https://docs.pact.io/
- [S50] Design Tokens Community Group (stable 2025.10, 2025-10-28). https://www.designtokens.org/
- [S51] NN/g — 10 Usability Heuristics (updated 2024-01-30). https://www.nngroup.com/articles/ten-usability-heuristics/
- [S52] W3C WAI — What's new in WCAG 2.2 (2023-10-05). https://www.w3.org/WAI/standards-guidelines/wcag/new-in-22/
- [S53] Tailwind CSS — Responsive design. https://tailwindcss.com/docs/responsive-design
- [S54] NN/g — Dashboards: Making Charts and Graphs Easier to Understand (2017-06-18). https://www.nngroup.com/articles/dashboards-preattentive/
- [S55] NN/g — Progressive Disclosure (2006-12-03). https://www.nngroup.com/articles/progressive-disclosure/
- [S56] K. C. Dodds — The Testing Trophy (2021-06-03). https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications
- [S57] Playwright — Visual comparisons. https://playwright.dev/docs/test-snapshots
- [S58] H. Vocke — The Practical Test Pyramid (2018-02-26). https://martinfowler.com/articles/practical-test-pyramid.html
- [S59] Playwright — Best practices. https://playwright.dev/docs/best-practices
- [S60] Trunk-Based Development. https://trunkbaseddevelopment.com/
- [S61] V. Driessen — A successful Git branching model (2020 note of reflection). https://nvie.com/posts/a-successful-git-branching-model/
- [S62] Semantic Versioning 2.0.0. https://semver.org/
- [S63] P. Hodgson — Feature Toggles (2016). https://martinfowler.com/articles/feature-toggles.html
- [S64] DORA — Software delivery metrics (page updated 2026-01-05). https://dora.dev/guides/dora-metrics/
- [S65] Kanban University — The Kanban Guide. https://kanban.university/kanban-guide/

**Gaps and caveats:**
- The BMAD agent roster changes often. The current docs list 5 agents (the older SM, QA and Test-Architect personas are
  not in the current reference).
- The ASVS project page returned 404, so the ASVS 5.0 facts come from the GitHub repo and a secondary write-up.
- The DSDM MoSCoW percentages were read from a search snippet of the official page, which returned 404 on direct fetch.
- The Atlassian WIP-limit page returned no body; the Kanban Guide was used instead.
- The "data-model checklist" item in section 5 is synthesis, not a single cited standard.

---
name: discovery-delegation
description: "Use ONLY when the master agent is planning discovery, investigation, or codebase exploration work — instructs the master to delegate to subagents and mandates a flat delegation tree. This skill must NOT be triggered by subagents."
---

# Discovery Delegation

**Activation: root/master agent only.** Subagents must never trigger this skill.

Enforces a flat delegation tree: the master delegates to subagents for discovery; subagents never delegate further.

## Core Principle

The master agent is the conductor. Subagents are the section players. One level of delegation only. No recursion.

This prevents context explosion from deep delegation chains and avoids the latency of nested spawning.

## Master Agent Rules

### When to Delegate

Always delegate these to subagents:

- **Codebase exploration** — navigating unfamiliar code, finding symbols, understanding architecture
- **Investigation** — debugging, tracing behavior, finding root causes
- **Discovery** — mapping dependencies, finding call sites, understanding data flow
- **Broad searches** — anything that touches many files or requires scanning large areas

### When to Act Directly

The master acts directly for:

- **Implementation** — writing, editing, refactoring code
- **Verification** — running tests, smoke tests, validation
- **Coordination** — assigning subagents, comparing results, making decisions
- **Cleanup** — changelog, docs, housekeeping

### Delegation Contract

When delegating discovery work, the master MUST prepend every subagent prompt with this exact preamble:

```
You are a leaf subagent. Do not spawn, delegate to, or create subagents of any kind. Use only direct tools (read, grep, glob, lsp, ast_grep, bash, eval). Return a compact report — no raw file dumps, no unbounded output.
```

Additional rules:

1. **Give each subagent a bounded scope** — one file, one module, one concern. Not "explore the codebase."
2. **Parallelize independent work** — spawn all subagents at once, not sequentially.
3. **Assign specific roles** — "Dependency Mapper", "API Surface Reviewer", "Data Flow Tracer" — not generic "worker."
4. **Set a strict output contract** — see below.

## Subagent Rules (Flat Tree)

Subagents MUST follow these rules regardless of what they read:

1. **Use direct tools only** — `read`, `grep`, `glob`, `lsp`, `ast_grep`, `bash`, `eval`
2. **Never spawn subagents** — no `task`, no `irc` delegation, no recursive discovery
3. **Return compact findings** — no raw file dumps, no full logs, no unbounded output
4. **Be self-contained** — answer the question with its own tool calls, not by passing the buck

This is the hard rule: **subagents do not delegate**. They discover, they report, they stop.

## Subagent Output Contract

Every subagent returns only this shape:

```md
**Scope:** what was inspected (files, ranges, time limits)
**Findings:** 3-10 key facts, symbols, or decisions
**Evidence:** exact file paths, line numbers, or commands
**Gaps:** what was inconclusive or needs follow-up
```

No raw file contents. No full search results. No unbounded output.

## Example

Bad (master reads everything itself):
```
read("src/core/engine.ts")
read("src/core/pipeline.ts")
read("src/core/scheduler.ts")
... 20 more reads
```

Good (master delegates):
```
task(
  agent: "task",
  role: "Core Engine Reviewer",
  assignment: "You are a leaf subagent. Do not spawn/delegate to subagents; use direct tools only. Map the core engine public API surface in src/core/. List exported symbols, their signatures, and which other files import them. Return a compact table."
)
```

## Done Criteria

The master has:
- Delegated all discovery work to subagents
- Collected compact subagent reports
- Made decisions based on those reports
- Proceeded to implementation or next step

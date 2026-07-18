---
name: planner-delegation
description: Delegate codebase investigation to scout subagents instead of burning context with raw exploration. Activates when the planner needs to map structure, find integration points, or investigate existing patterns.
allowed-tools: Task, Glob, Grep, Read, Write
license: MIT
---

## The Problem

The planner has 131K context but burns through it in ~2 steps because raw exploration (read, grep, lsp) produces tokens that eat the window. By step 3 it's compacting and losing its chain of thought.

## The Solution

**Delegate investigation to scout subagents.** Instead of reading files yourself, spawn scout subagents that investigate in parallel and return concise artifacts. You read the artifacts, not the raw files.

## When to Delegate

Delegate when you need to:
- Map codebase structure (directories, modules, dependencies)
- Find integration points for a new feature
- Investigate existing patterns before implementing
- Surface hidden complexity in a subsystem
- Check multiple files or directories simultaneously

**Do NOT delegate** when:
- You already know what you need (just read it)
- The investigation is trivial (one file, one grep)
- You're implementing, not investigating

## How to Delegate

### 1. Scoping (your job)

Read the request, map the work, name the independent slices. Delegation is NEVER the first move — scoping is.

**Example:**
```
"Map the auth subsystem" → 3 slices:
  - scout: "auth providers and credential store"
  - scout: "session management and middleware"
  - scout: "permission system and role hierarchy"
```

### 2. Spawning (use task)

```
task(
  context: "Shared constraints and scope",
  tasks: [
    { task: "Investigate X. Return: file list, key symbols, integration points, dependencies.", name: "AuthProviders" },
    { task: "Investigate Y. Return: same format.", name: "SessionMiddleware" },
    { task: "Investigate Z. Return: same format.", name: "PermissionSystem" }
  ],
  i: "Map subsystem for planner"
)
```

**Key rules:**
- Use `agent: "scout"` for read-only investigation (faster, leaner)
- Each task returns a **concise artifact** — not raw file contents
- Tasks should be independent (parallel execution)
- Prerequisites run inline, not delegated

### 3. Reading Results

Scout results are delivered as `local://<name>.md` files. Read them:

```
read("local://AuthProviders.md")
read("local://SessionMiddleware.md")
read("local://PermissionSystem.md")
```

These are **concise summaries** — file lists, key symbols, integration points, dependencies. Not raw file contents.

### 4. Writing to Scratchpad

When investigation reveals important decisions or structure, write to a persistent scratchpad:

```
write("local://planner-scratchpad.md", `
# Planner Scratchpad
## Current Plan
[high-level plan]

## Key Findings
- [important discovery from scout]
- [integration point]

## Open Questions
- [what you still need to know]

## Next Steps
- [concrete next action]
`)
```

The scratchpad survives context compaction. Read it at the start of each session.

## Pattern: Investigation → Implementation

```
1. Read request → identify what you need to know
2. Scope investigation → name independent slices
3. Spawn scouts → parallel investigation
4. Read artifacts → concise summaries
5. Write scratchpad → persistent state
6. Implement → using scratchpad as reference
```

## Example

**User:** "Add OAuth to the auth system"

**You:**
```
1. Scope: Need to know existing auth structure
2. Spawn scouts for: providers, session, permissions
3. Read artifacts
4. Write scratchpad with findings
5. Implement OAuth using scratchpad as reference
```

**Scout task:**
```
task(
  context: "Mapping auth subsystem for OAuth integration",
  tasks: [
    { task: "Map auth providers and credential store. Return: file list, key symbols, integration points, dependencies.", name: "AuthProviders" },
    { task: "Map session management and middleware. Return: same format.", name: "SessionMiddleware" },
    { task: "Map permission system and role hierarchy. Return: same format.", name: "PermissionSystem" }
  ],
  i: "Map auth subsystem for OAuth"
)
```

**Result:** Concise artifacts → read → write scratchpad → implement.

## Guardrails

- **Don't delegate what you can read** — trivial investigation is faster inline
- **Don't delegate implementation** — scouts investigate, you implement
- **Don't read raw files from scouts** — read the artifacts they produce
- **Do write to scratchpad** — persistent state survives compaction
- **Do scope before spawning** — independent slices = parallel execution
- **Do use scout agents** — faster, leaner, read-only investigation

## Why This Works

- **Context efficient:** Scouts consume context, you consume concise artifacts
- **Parallel:** Multiple scouts investigate simultaneously
- **Persistent:** Scratchpad survives context compaction
- **Scalable:** Works for any size investigation

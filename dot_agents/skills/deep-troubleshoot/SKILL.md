---
name: deep-troubleshoot
description: 
  Deep troubleshooting skill. Use for diagnosing incidents, crashes, failures, regressions, slowdowns, broken deployments, flaky behavior, or unexpected system behavior where raw logs, configs, traces, outputs, or code files could overflow context. 
---

Use for diagnosing incidents, crashes, failures, regressions, slowdowns, broken deployments, flaky behavior, or unexpected system behavior where raw logs, configs, traces, outputs, or code files could overflow context.

## Core Principle

The master agent is the incident commander. Subagents collect bounded evidence. The master never ingests raw large logs, full configs, full traces, full manifests, full command output, or broad file dumps.

## Context Discipline

- Never read full bulky files, logs, traces, config dumps, rendered output, or event streams by default.
- Prefer compact commands, selectors, filters, summaries, tails, structured queries, and targeted file ranges.
- If output is large, rerun a narrower command instead of pasting or summarizing huge output in-context.
- Search first, then read only relevant ranges.
- Each subagent owns one evidence slice and returns compact findings only.
- The master maintains small evidence and hypothesis tables.
- Use a larger-context planner only for comparing compact summaries or inspecting unavoidable bulky evidence, not for dumping raw artifacts.

## Master Workflow

1. Restate the exact symptom and success criterion.
2. Identify the system, environment, timeframe, and last known good state if available.
3. Spawn independent subagents in parallel where possible.
4. Give each subagent a bounded target and strict report contract.
5. Compare reports in a compact evidence table.
6. Rank falsifiable hypotheses.
7. Request one follow-up probe per unresolved high-value branch.
8. Return root cause, minimal fix, and verification command.

## Standard Subagent Roles

Choose only roles relevant to the incident.

### State Investigator

Target: current object/process/service/job state.

Examples:

- process status
- container/pod/task status
- service health
- deployment/release state
- restart count
- exit code
- lifecycle reason
- resource saturation

Return only state fields that explain or rule out the symptom.

### Logs Investigator

Target: bounded logs around the failure.

Rules:

- Use tails, time windows, request IDs, correlation IDs, service names, or error filters.
- Prefer `--tail`, `--since`, `journalctl -u <unit> --since`, application log filters, or equivalent.
- Extract first fatal error, last fatal error, stack headline, and relevant repeated message.
- Do not paste full logs.

### Events/Timeline Investigator

Target: external events around the incident.

Examples:

- orchestration events
- deploy events
- scheduler events
- host/kernel events
- audit events
- CI/CD events
- cloud provider events

Return only timestamped events plausibly tied to the symptom.

### Config Investigator

Target: config implicated by state/log/event evidence.

Rules:

- Never read full bulky config by default.
- Search for implicated keys first.
- Read only small ranges around relevant keys.
- Report file path, range, key/value shape, and why it matters.
- Never dump secrets; report presence, key names, references, or metadata only.

Common key families:

```text
resources|limits|timeouts|retries|health|probe|env|secret|config|image|version|tag|host|port|url|database|cache|queue|auth|tls|feature|flag|rate|concurrency
```

### Dependency Investigator

Spawn only if evidence points to an external dependency.

Targets:

- service exists and is reachable
- endpoint/listener is healthy
- credentials/config references exist
- DNS/host/port match config
- network policy/firewall/security group blocks traffic
- upstream errors or rate limits

Do not dump secret values.

### Code/Change Investigator

Spawn when a regression may come from code or config changes.

Targets:

- relevant recent changes
- callsites for implicated symbol/config
- feature flags
- migrations
- release diff
- test coverage around failing path

Use targeted search, LSP/code intelligence where available, and small file ranges. Do not read broad directories or whole large files.

### Metrics/Performance Investigator

Spawn for slowdowns, resource exhaustion, or saturation.

Targets:

- CPU, memory, disk, network, queue depth
- latency/error-rate changes
- saturation and throttling
- before/after baseline

Return compact numbers, timeframe, and comparison. Do not paste full dashboards or metric dumps.

## Subagent Output Contract

Every subagent must return only this shape:

```md
Status:
- root signal found | no root signal found | blocked

Scope:
- what was inspected, with timeframe or file/range limits

Evidence:
- Command/range/query: `<exact command, file range, query, or tool action>`
- Lines/data: 3-10 relevant lines or compact data points only
- Interpretation: one paragraph max

Ruled out:
- concise bullets

Next recommended check:
- one bounded command/range/query, or `none`
```

Subagents must not paste full logs, full configs, full traces, full `describe` output, full stack dumps, or broad search output.

## Master Evidence Table

Maintain this compact table:

```md
| Area | Signal | Evidence | Confidence | Next |
| ---- | ------ | -------- | ---------- | ---- |
```

## Hypothesis Table

Keep at most five ranked hypotheses:

```md
| Rank | Hypothesis | Evidence for | Evidence against | Next check |
| ---- | ---------- | ------------ | ---------------- | ---------- |
```

Each hypothesis must be falsifiable: name the check that would make it stronger or rule it out.

## Investigation Rules

- Build a tight feedback loop early: one command, test, request, or scenario that can reproduce or verify the symptom.
- Prefer direct evidence over plausible explanations.
- Change or test one variable at a time.
- If a command fails, record the error and run a corrected narrower command; do not treat failed output as evidence for the incident.
- If evidence is incomplete, state the strongest remaining hypothesis and the missing artifact.
- Never solve a symptom by suppressing errors unless suppression is explicitly the desired behavior.

## Common Mappings

- Exit code or lifecycle reason: inspect logs immediately before exit and resource state.
- Health check failure: distinguish startup, readiness, liveness, and downstream dependency failure.
- Timeout: inspect dependency reachability, configured timeout, retries, queue depth, and saturation.
- Permission/auth failure: inspect identity, secret/config reference, token expiry, scope, and recent rotation.
- Config parse error: inspect exact key/range and release/change that introduced it.
- Resource exhaustion: inspect limits, actual usage, throttling, eviction, OOM, disk pressure, and load spike.
- Regression after deploy: inspect release diff, feature flags, migrations, and changed dependencies.

## Done Criteria

The master response must include:

- root cause, or strongest remaining hypothesis if evidence is incomplete
- exact evidence lines/data and source commands/ranges/queries
- causes ruled out
- implicated config/code/dependency, if any
- minimal fix or mitigation
- verification command or scenario

Before yielding after a fix, run the focused verification that proves the failure condition is resolved.

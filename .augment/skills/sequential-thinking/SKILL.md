---
name: sequential-thinking
description: >
  Structured step-by-step reasoning specialist for complex, multi-step problems.
  Use when asked to: break down a hard problem, design an algorithm, plan an architecture,
  debug a non-obvious issue, analyze tradeoffs, or verify reasoning before committing to a solution.
  Trigger keywords: sequential-thinking, st.
  Do NOT use for simple lookups, straightforward code generation, or single-step questions — answer directly instead.
compatibility: Requires MCP server called sequentialthinking configured in .augment/mcp-config.json.
---

# Sequential Thinking Skill

## Description

Apply structured, explicit chain-of-thought reasoning using the `sequentialthinking` MCP
tool. Each thought is a discrete, numbered step that can be revised, branched, or extended
before a final answer is committed. Use when linear reasoning risks missing edge cases,
assumptions need to be surfaced, or a problem has multiple valid approaches worth comparing.

## Capabilities

- Decompose complex problems into explicit, numbered reasoning steps
- Generate and verify hypotheses before committing to a solution
- Revise earlier steps mid-chain when new information changes the analysis
- Branch the thought chain to explore and compare alternative approaches
- Surface hidden assumptions and edge cases through systematic analysis
- Reason through architectural tradeoffs, debugging puzzles, and algorithm correctness

## Key Concepts

- **Thought**: A single discrete reasoning step — one idea, deduction, or check per thought; keep each thought focused and atomic.
- **Revision**: A thought that explicitly revisits and corrects an earlier step; use when downstream reasoning reveals an earlier assumption was wrong.
- **Branch**: A parallel reasoning path forked from an earlier thought to explore an alternative approach before choosing the best one.
- **Hypothesis**: A provisional conclusion generated mid-chain; must be verified against subsequent thoughts before being accepted as the final answer.
- **totalThoughts**: An estimate of steps needed — can be adjusted upward as complexity becomes clearer; prefer over-estimating to under-estimating.

## Workflow

1. **Assess complexity** — before invoking, confirm the problem genuinely requires multi-step reasoning. If it is a simple lookup or single-step task, answer directly without sequential thinking.
2. **Set initial scope** — estimate `totalThoughts`; start conservatively and extend if needed.
3. **Think step by step** — emit one atomic thought per step; reference earlier step numbers when building on or revising prior reasoning.
4. **Revise when needed** — if a later step reveals an error in an earlier one, emit an explicit revision thought rather than silently correcting.
5. **Branch for alternatives** — when multiple valid approaches exist, branch and reason each to a local conclusion before selecting the best.
6. **Verify hypothesis** — before the final step, emit an explicit verification thought that checks the candidate answer against all prior reasoning.
7. **Report** using this structure:
   - **Reasoning summary**: brief narrative of the key steps and any revisions/branches
   - **Answer**: the final, verified conclusion
   - **Confidence**: note any remaining uncertainties or assumptions

## Usage Examples

### Algorithm Design
```
sequential-thinking Design an efficient algorithm for finding duplicates in a large dataset
```

### Complex Debugging
```
st Debug why the authentication flow fails intermittently under load
```

### Architecture Planning
```
st Plan microservices decomposition for an e-commerce platform
```

### Root Cause Analysis
```
sequential-thinking Analyze why memory usage grows over time in this Node.js service
```

### Tradeoff Analysis
```
st Compare event sourcing vs. CRUD for an audit-heavy financial application
```

## Configuration

MCP server is called `sequentialthinking` and is configured in `.augment/mcp-config.json`.
No environment variables or external service credentials are required — this is a local
reasoning tool with no network dependency.

No connectivity probe is needed before use.

## Best Practices

- **Only invoke for genuinely complex problems** — do not add overhead to simple questions
- **Keep each thought atomic** — one idea or deduction per step, not a paragraph of mixed reasoning
- **Always revise explicitly** — emit a revision thought rather than silently rewriting earlier steps
- **Extend `totalThoughts` freely** — it is better to use more steps than to compress reasoning and miss edge cases
- **Verify before concluding** — always emit an explicit verification step before the final answer
- **Combine with other skills** — use `doc-search` or `web-search` to gather facts first, then apply sequential thinking to reason over them

## Limitations

- Increases response length and latency compared to direct answers — not suitable for time-sensitive or simple queries
- Thought quality depends on the problem being well-scoped; vague questions produce vague reasoning chains
- Cannot guarantee correctness for problems requiring external ground truth (e.g., current data, runtime state)

---
name: graylog-tst
description: >
  Graylog test environment specialist for log search, aggregation, and analysis.
  Use when asked to: search logs, find errors, query streams, analyze log patterns,
  investigate test run failures, debug staging issues, or check log volumes in the
  test or staging environment.
  Trigger keywords: graylog-tst.
  Do NOT use for production environment logs (use graylog-prd instead).
compatibility: Requires graylog-tst agent (.augment/agents/graylog-tst.agent.md) and graylog-tst MCP server.
---

# Graylog Test Environment Skill

## Agent Delegation

**Delegate ALL operations to the `graylog-tst` agent.**
*"Use the graylog-tst agent to complete this task."*

The `graylog-tst` agent provisions the graylog-tst MCP server and has the required
tools (`search_messages`, `aggregate_messages`, `list_streams`, `list_fields`, etc.).

## Description

Access Graylog test environment for log search, aggregation, and analysis.
Use for development debugging, test run log investigation in test environment
troubleshooting. Logs are organized into **streams** and stored in **indices**.
Queries use **Lucene syntax**.

## Capabilities

- Search test environment log messages using Lucene query syntax
- Aggregate logs (group by fields, count, avg, min, max, percentiles, etc.)
- List available streams and scope searches to specific streams
- List indices and index sets (data retention configuration)
- List configured inputs (syslog, GELF, etc.)
- Discover available fields per stream (`list_fields`) before querying
- Get current server time and system status

## Key Concepts

- **Streams**: Named partitions of log data (e.g., by app, environment, source). Always scope searches to streams for performance.
- **Indices**: Physical storage units; use `list_indices` to check data availability and health.
- **Fields**: Field names vary per stream. Always call `list_fields` first to discover valid field names before building queries.
- **Lucene syntax**: Queries use Lucene (e.g., `level:ERROR AND source:api-server`). Leading wildcards are disabled by default.

## Workflow

1. **Connectivity check** — call `get_system_status` as a lightweight probe. If it fails, stop and report: *"graylog-tst MCP server is unavailable. Cannot proceed."*
2. **Discover streams** — call `list_streams` to get stream IDs; always scope searches with the `streams` parameter.
3. **Discover fields** — call `list_fields` on the target stream before building any query.
4. **Search or aggregate** — use `search_messages` for raw logs, `aggregate_messages` for counts/grouping.
5. **Report** — structure the response as: time range → total hits → error/warn breakdown → top patterns → recommended actions.

## Usage Examples

### Log Search
```
graylog-tst Search for authentication errors in test environment last hour
```

### Aggregate by Error Type
```
graylog-tst Show top 10 error types in staging grouped by source
```

### Discover Fields First
```
graylog-tst List available fields in the staging application stream
```

### Analyze Error Patterns
```
graylog-tst Analyze error patterns in test logs over the last 2 hours
```

## Configuration
- Requires proper authentication via environment variable `GRAYLOG_TST_TOKEN` is defined in `.augment/.env`
- Do NOT search the filesystem for `mcp-config.json` — always route through the agent file

## Best Practices

- **Always call `list_streams` first** to get stream IDs, then scope searches using the `streams` parameter
- **Always call `list_fields` before querying** to discover valid field names for the target stream
- Use `aggregate_messages` instead of `search_messages` for counting/grouping
- Pass time range as `range_seconds` parameter — never embed time in the query string
- Avoid leading wildcards in Lucene queries (disabled by default)

## Limitations

- Test environment only — data does not reflect production
- Different data retention policies than production
- Leading wildcards are disabled in Lucene queries

## Environment Isolation

**CRITICAL**: Never use `graylog-tst` and `graylog-prd` in the same request. Choose only one environment per query.

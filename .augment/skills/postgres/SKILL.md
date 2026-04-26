---
name: postgres
description: >
  PostgreSQL sandbox database specialist for querying, inspecting, and analyzing data.
  Use when asked to: list databases or tables, inspect schema and column definitions,
  run SELECT queries, analyze data patterns, or retrieve row counts and statistics.
  Trigger keywords: postgres.
  Do NOT use for non-PostgreSQL data stores — use the appropriate skill instead.
compatibility: Requires postgres agent (postgres.agent.md) and toolbox MCP server (local).
---

# PostgreSQL Database Skill

## Agent Delegation

**Delegate ALL operations to the `postgres` agent.**
*"Use the postgres agent to complete this task."*

The `postgres` agent provisions the toolbox MCP server and has the required tools
for listing databases, inspecting schemas, and executing SQL queries.

## Description

Query and analyze a local PostgreSQL sandbox database through the `toolbox` MCP server.
Use for schema inspection, data retrieval, and SQL-based analysis. All access is
read-oriented by default; write operations require explicit user intent.

## Capabilities

- List available databases and schemas
- Inspect table structures, column types, and constraints
- Execute SELECT queries for data retrieval and analysis
- Aggregate and summarize data (counts, groupings, trends)
- Identify relationships between tables via foreign keys

## Key Concepts

- **toolbox**: The MCP utility that brokers all PostgreSQL connections — never use direct `psql` or shell commands.
- **Connectivity probe**: A lightweight read-only call (e.g., list tables) made *before* every user request to confirm the server is reachable.
- **Read-only default**: Prefer SELECT queries; only execute INSERT/UPDATE/DELETE when the user explicitly requests a data change.
- **Schema-first**: Always inspect table structure before querying unfamiliar tables to avoid incorrect column references.

## Workflow

1. **Connectivity probe** — call a lightweight read-only tool (e.g., list databases or list tables) as the first action. If it fails, stop immediately and report: *"PostgreSQL MCP server is unavailable. Cannot proceed."* Do not fall back to shell/bash.
2. **Understand the schema** — for unfamiliar tables, inspect columns and types before constructing queries.
3. **Execute query** — run the appropriate MCP tool with a safe, targeted SQL statement.
4. **Report** using this structure:
   - **Answer**: direct response to the user's question
   - **Data**: query results, counts, or summaries
   - **Source**: table/view name(s) used

## Usage Examples

### List Databases
```
postgres Show all available databases
```

### Schema Inspection
```
postgres List all tables and their columns in the public schema
```

### Data Query
```
postgres Show the 10 most recent user registrations from the users table
```

### Aggregation / Analysis
```
postgres Analyze order counts grouped by status over the last 30 days
```

### Row Count Overview
```
postgres How many rows are in each table?
```

## Configuration

MCP server is called `toolbox` (local process) and is configured in `postgres.agent.md`.
Environment variables (host, port, credentials) are defined in `.augment/.env`.

Do NOT search the filesystem for config files directly — always route through the `postgres` agent file.

## Best Practices

- **Always run a connectivity probe** before executing any user-requested query
- **Always inspect schema first** when querying unfamiliar tables
- **Prefer read-only queries**; confirm with the user before executing any write operation
- **Use MCP toolbox exclusively** — never use `psql`, `bash`, or direct shell commands
- **Include LIMIT clauses** on open-ended queries to avoid large result sets

## Limitations

- Sandbox PostgreSQL instance only — not for production databases
- Requires the `toolbox` utility to be installed and running
- MCP server must be configured and reachable
- Write operations (INSERT/UPDATE/DELETE) should be used with caution
- Very complex queries or stored procedure calls may not be supported

## Security Considerations

- Credentials are managed exclusively by the MCP server configuration — never hardcode or log them
- Avoid returning or displaying sensitive columns (e.g., passwords, tokens) in query results
- Use the principle of least privilege: prefer read-only access patterns

---
name: grafana-prd
description: >
  Grafana production environment specialist for metrics, logs, traces, dashboards, and alerting.
  Use when asked to: query Prometheus metrics, search Loki logs, analyze Tempo traces, manage dashboards,
  configure alert rules, or investigate issues in the production environment.
  Trigger keywords: grafana-prd.
  Do NOT use for test environment (use grafana-tst instead).
compatibility: Requires grafana-prd agent (.augment/agents/grafana-prd.agent.md) and grafana-prd MCP server.
---

# Grafana Test Environment Skill

## Agent Delegation

**Delegate ALL operations to the `grafana-prd` agent.**
*"Use the grafana-prd agent to complete this task."*

The `grafana-prd` agent provisions the grafana-prd MCP server and has the required
tools (`list_datasources`, `query_prometheus`, `query_loki_logs`, `search_traces`, etc.).

## Description

Access Grafana production environment for observability data. Covers metrics (Prometheus),
logs (Loki), traces (Tempo), profiling (Pyroscope), incident management, OnCall schedules,
Sift investigations, alerting, and dashboard management. Use for production workflows.

## Capabilities

### Metrics (Prometheus)
- Query PromQL against test Prometheus datasources
- List metric names, label names, label values, and metadata
- Query histograms and percentiles

### Logs (Loki)
- Execute LogQL queries for test log retrieval
- List log label names and values
- Query log patterns and statistics
- Stream log data with filtering and parsing

### Traces (Tempo)
- Find slow requests in test environment
- Analyze distributed traces

### Profiling (Pyroscope)
- Fetch CPU, memory, goroutine profiles for test services
- List profile types and label values per service

### Incidents & OnCall
- Create, list, and get incident details
- Add timeline notes to incidents
- List OnCall schedules, teams, users
- Get current on-call users for a schedule

### Sift Investigations
- Create and retrieve automated investigations
- Find error patterns in logs
- Find slow requests across services

### Alerting
- List, get, create, update, delete alert rules
- List contact points and notification policies
- List alert groups from OnCall

### Dashboards
- Search, get, create, update dashboards
- Get panel queries and dashboard summaries
- Generate deeplinks to dashboards or panels
- Render panel/dashboard images (PNG)
- Create and manage annotations

### Datasources
- List, get datasources by name or UID

## Key Concepts

- **Datasources**: Named connections to backends (Prometheus, Loki, Tempo, Pyroscope). Always resolve UIDs via `list_datasources` before querying.
- **Prometheus / PromQL**: Metrics backend. Use `list_prometheus_metric_names` before writing PromQL to ensure valid metric names.
- **Loki / LogQL**: Log aggregation backend. Always call `list_loki_label_names` / `list_loki_label_values` before building LogQL queries.
- **Tempo**: Distributed tracing backend. Use to find slow spans and trace request paths across services.
- **Dashboards**: JSON-defined panels; use `get_dashboard_summary` for large dashboards to avoid token limits.

## Workflow

1. **Connectivity check** — call `list_datasources` (with `limit=1`) as a lightweight probe. If it fails, stop and report: *"grafana-prd MCP server is unavailable. Cannot proceed."*
2. **Discover datasources** — resolve correct datasource UIDs using `list_datasources`.
3. **Discover schema** — list metric names, label names/values, or log labels before querying.
4. **Query or manage** — use `query_prometheus`, `query_loki_logs`, `search_traces`, dashboard/alert tools as appropriate.
5. **Report** — structure the response as: datasource → time range → results summary → anomalies/patterns → recommended actions.

## Usage Examples

### Test Metrics
```
grafana-prd Show CPU usage for test-api service in production
```

### Log Investigation
```
grafana-prd Search Loki logs for errors in auth service last 1 hour
```

### Dashboard Editing
```
grafana-prd Add a new panel to the production overview dashboard
```

### Alert Testing
```
grafana-prd Create a test alert rule for high memory usage
```

### Trace Analysis
```
grafana-prd Find slow requests for checkout service in test environment
```

## Best Practices

- **Always call `list_datasources` first** to get datasource UIDs before any query
- **Always call `list_prometheus_metric_names` before writing PromQL**
- **Always call `list_loki_label_names` / `list_loki_label_values` before writing LogQL**
- Use `query_loki_stats` to check log volume before fetching raw entries
- Use `get_dashboard_summary` instead of `get_dashboard_by_uid` for large dashboards
- Do NOT search the filesystem for `mcp-config.json` — always route through the agent file

## Limitations

- Test environment only — data does not reflect production
- Different data retention policies than production
- Write operations (create/update alerts, incidents) require appropriate permissions
- Image rendering requires Grafana Image Renderer service

## Environment Isolation

**CRITICAL**: Never use `grafana-prd` and `grafana-tst` in the same request. Choose only one environment per query.

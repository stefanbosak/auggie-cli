---
name: countly-prd
description: >
  Countly production environment specialist for product analytics, event tracking, and crash reporting.
  Use when asked to: validate event instrumentation, analyze user sessions, check retention
  metrics, investigate crash reports, or debug analytics flows in the production environment.
  Trigger keywords: countly-prd.
  Do NOT use for production analytics — use countly-prd instead.
compatibility: Requires countly-prd agent (countly-prd.agent.md) and countly-prd MCP server (HTTP).
---

# Countly Production Environment Skill

## Agent Delegation

**Delegate ALL operations to the `countly-prd` agent.**
*"Use the countly-prd agent to complete this task."*

The `countly-prd` agent provisions the countly-prd MCP server and has the required tools
for sessions, events, retention, crashes, user flows, and performance analytics.

## Description

Access Countly production environment for product analytics, user behavior tracking,
crash reporting, and application performance monitoring in production environment.

## Capabilities

### Sessions
- Analyze user session counts, durations, and frequency
- Segment sessions by device, OS, app version, or country

### Events
- Track and validate custom event data (counts, segmentation, sums)
- Verify event properties and segmentation values are captured correctly
- Analyze funnel progression across event sequences

### Retention
- Monitor day-N retention metrics for cohorts
- Compare retention across app versions or segments

### Crashes & Errors
- Investigate crash reports and error traces from builds
- Group crashes by type, OS version, or app version
- Verify crash reporting instrumentation is working

### User Flows
- Analyze user journeys and navigation flows in apps
- Identify drop-off points in onboarding or checkout flows

### Performance
- Monitor application response times and slow requests
- Analyze network request performance from devices

### Segmentation
- Segment any metric by demographics, device, OS, app version, or custom properties

## Key Concepts

- **App ID / App key**: Each Countly application has a unique identifier — always confirm the target app before querying.
- **Event**: A named action tracked by the SDK (e.g., `add_to_cart`); events carry a count, sum, and optional segmentation properties.
- **Segmentation**: Key-value properties attached to events or sessions; used to filter and group analytics data.
- **Retention**: The percentage of users who return on day N after first use; measured per cohort.
- **Production environment**: Data comes from production environment and reflect real user behavior.

## Workflow

1. **Connectivity probe** — call a lightweight read-only tool (e.g., list apps or fetch server info) as the first action. If it fails, stop immediately and report: *"countly-prd MCP server is unavailable. Cannot proceed."*
2. **Identify app** — confirm the target application name or ID from the user's request before constructing any query.
3. **Query** — use the appropriate tool for sessions, events, retention, crashes, flows, or performance.
4. **Report** using this structure:
   - **Query**: what was analysed and for which app
   - **Time range**: start → end
   - **Results summary**: key metrics, counts, or patterns
   - **Anomalies / issues**: unexpected values, missing events, error spikes
   - **Recommended actions**: next steps or follow-up validations

## Usage Examples

### Validate Event Tracking
```
countly-prd Verify that the "add_to_cart" event is being tracked correctly in staging
```

### Crash Debugging
```
countly-prd Show crash reports from the latest build
```

### Performance Monitoring
```
countly-prd Analyze response times in the staging app
```

### User Flow Validation
```
countly-prd Show user flows through onboarding in the production environment
```

### Retention Check
```
countly-prd Show day-7 retention for the latest release
```

## Configuration

MCP server is called `countly-prd` (HTTP type) and is configured in `countly-prd.agent.md`.
Environment variables are defined in `.augment/.env`.

Do NOT search the filesystem for `mcp-config.json` directly — always route through the `countly-prd` agent file.

## Best Practices

- **Always run a connectivity probe** before executing any user-requested query
- **Always confirm the target app** before querying — wrong app ID silently returns unrelated data
- **Never mix `countly-prd` and `countly-prd`** in the same request

## Limitations

- Production environment reflect real user behavior or production volumes
- Different data retention policies than production
- Write or configuration operations require appropriate Countly permissions

## Environment Isolation

**CRITICAL**: Never use `countly-prd` and `countly-tst` in the same request. Choose only one environment per query.

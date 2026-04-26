---
name: countly-tst
description: >
  Countly test environment specialist for product analytics, event tracking, and crash reporting.
  Use when asked to: validate event instrumentation, analyze test user sessions, check retention
  metrics, investigate crash reports, or debug analytics flows in the test/staging environment.
  Trigger keywords: countly-tst.
  Do NOT use for production analytics — use countly-prd instead.
compatibility: Requires countly-tst agent (countly-tst.agent.md) and countly-tst MCP server (HTTP).
---

# Countly Test Environment Skill

## Agent Delegation

**Delegate ALL operations to the `countly-tst` agent.**
*"Use the countly-tst agent to complete this task."*

The `countly-tst` agent provisions the countly-tst MCP server and has the required tools
for sessions, events, retention, crashes, user flows, and performance analytics.

## Description

Access Countly test/staging environment for product analytics, user behavior tracking,
crash reporting, and application performance monitoring. Use for validating analytics
instrumentation, testing event tracking, and debugging analytics flows before production
release. Data reflects test builds only — not real user behavior.

## Capabilities

### Sessions
- Analyze test user session counts, durations, and frequency
- Segment sessions by device, OS, app version, or country

### Events
- Track and validate custom event data (counts, segmentation, sums)
- Verify event properties and segmentation values are captured correctly
- Analyze funnel progression across event sequences

### Retention
- Monitor day-N retention metrics for test cohorts
- Compare retention across app versions or segments

### Crashes & Errors
- Investigate crash reports and error traces from test builds
- Group crashes by type, OS version, or app version
- Verify crash reporting instrumentation is working

### User Flows
- Analyze user journeys and navigation flows in test apps
- Identify drop-off points in onboarding or checkout flows

### Performance
- Monitor test application response times and slow requests
- Analyze network request performance from test devices

### Segmentation
- Segment any metric by demographics, device, OS, app version, or custom properties

## Key Concepts

- **App ID / App key**: Each Countly application has a unique identifier — always confirm the target app before querying.
- **Event**: A named action tracked by the SDK (e.g., `add_to_cart`); events carry a count, sum, and optional segmentation properties.
- **Segmentation**: Key-value properties attached to events or sessions; used to filter and group analytics data.
- **Retention**: The percentage of users who return on day N after first use; measured per cohort.
- **Test environment**: Data comes from test/staging builds only — volumes are much lower than production and do not reflect real user behavior.

## Workflow

1. **Connectivity probe** — call a lightweight read-only tool (e.g., list apps or fetch server info) as the first action. If it fails, stop immediately and report: *"Countly test MCP server is unavailable. Cannot proceed."*
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
countly-tst Verify that the "add_to_cart" event is being tracked correctly in staging
```

### Crash Debugging
```
countly-tst Show crash reports from the latest test build
```

### Performance Monitoring
```
countly-tst Analyze response times in the staging app
```

### User Flow Validation
```
countly-tst Show user flows through onboarding in the test environment
```

### Retention Check
```
countly-tst Show day-7 retention for the latest test release
```

## Configuration

MCP server is called `countly-tst` (HTTP type) and is configured in `countly-tst.agent.md`.
Environment variables are defined in `.augment/.env`.

Do NOT search the filesystem for `mcp-config.json` directly — always route through the `countly-tst` agent file.

## Best Practices

- **Always run a connectivity probe** before executing any user-requested query
- **Always confirm the target app** before querying — wrong app ID silently returns unrelated data
- **Use test environment to validate instrumentation** before promoting analytics changes to production
- **Never mix `countly-tst` and `countly-prd`** in the same request
- **Treat low event volumes as normal** — test environments have far fewer events than production; do not flag low counts as errors unless events are completely absent

## Limitations

- Test environment only — data does not reflect real user behavior or production volumes
- Different data retention policies than production
- Test event volumes are much lower than production
- Write or configuration operations require appropriate Countly permissions

## Environment Isolation

**CRITICAL**: Never use `countly-tst` and `countly-prd` in the same request. Choose only one environment per query.

---
name: jira
description: >
  Tools for interaction with jira production cloud environment.
  Use when asked to: search or filter issues with JQL, create or update tickets, transition
  issue status, manage epics and sprints, log work, add comments, or generate project reports.
  Trigger keywords: jira.
compatibility: Requires jira agent (jira.agent.md) and jira MCP server.
---

# JIRA Environment Skill

## Agent Delegation

**Delegate ALL operations to the `jira` agent.** The agent provisions the Jira MCP server
and has the required tools for all read and write operations.

## Description
Access Jira Cloud to read and manage issues, epics, sprints, boards, projects, and worklogs.
Use for any task involving Jira tickets, sprint planning, status updates, linking issues, or reporting.

## Capabilities
- Search issues with JQL (Jira Query Language)
- Get, create, update, and delete issues
- Transition issue status (e.g., To Do → In Progress → Done)
- Add comments and worklogs to issues
- Manage epics and link issues to epics
- Create and link issues (Blocks, Relates to, Duplicate, etc.)
- List and search projects
- Get and manage agile boards and sprints
- Batch create multiple issues at once
- Download issue attachments
- Get changelogs and history for issues
- Manage fix versions / releases

## Activation
Include `jira` in your prompt to activate this skill.

## Agent Constraints
When connected to the Jira MCP server the agent **MUST** enforce:
- **Default project**: use project key `PD` when the user does not specify a project — never override an explicit project key
- **cloudId**: use `"https://${JIRA_ORG}.atlassian.net"` — do **NOT** call `getAccessibleAtlassianResources`
- **Search page size**: default `maxResults: 10` / `limit: 10`; paginate with `startAt` when a task requires more results

## Connectivity Check
Before taking any action the agent **MUST**:
1. Call `jira_get_all_projects` with `maxResults=1` as a lightweight connectivity probe.
2. If the probe fails, stop immediately and report: *"Jira MCP server is unavailable. Cannot proceed."*
3. Only proceed after a successful probe response.

## Usage Examples

### Search Issues with JQL
```
jira Find all open bugs assigned to me in project PD
```

### Sprint Overview
```
jira Show all issues in the current active sprint
```

### Create an Issue
```
jira Create a bug in project PD: "Login fails on Safari" assigned to john@example.com
```

### Transition Status
```
jira Move PD-123 to In Progress
```

### Add Comment
```
jira Add comment to PD-456: "Fixed in PR #89, pending review"
```

### Epic Management
```
jira Show all stories linked to epic PD-10
```

### Log Work
```
jira Log 2h 30m on PD-789 with comment "Implemented feature"
```

## JQL Reference
Common JQL patterns (replace `PD` with the target project key as needed):
- `assignee = currentUser() AND status != Done`
- `project = PD AND issuetype = Bug AND priority = High`
- `sprint in openSprints() AND status = "In Progress"`
- `updated >= -7d AND project = PD`
- `parent = PD-123` (child issues under an epic — field availability varies by instance; use `jira_search_fields` to verify)

## Configuration
- Do NOT read filesystem config files (`mcp-config.json`, `~/.augment/mcp-config.json`, etc.)
- Always route through the `jira.agent.md` custom agent which owns the MCP server config.
- Auth token is read from `JIRA_TOKEN` env var defined in `.augment/.env`.

## Limitations
- Jira Cloud only (not Server/Data Center for all endpoints)
- Write operations require appropriate Jira permissions
- Custom field IDs vary per instance — use `jira_search_fields` to discover them before use

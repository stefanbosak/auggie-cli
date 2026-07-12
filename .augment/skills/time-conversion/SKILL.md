---
name: time-conversion
description: >
  Timezone and time conversion specialist for accurate, DST-aware time calculations worldwide.
  Use when asked to: convert a time between timezones, get the current time in a city or region,
  schedule meetings across multiple timezones, or check UTC offsets and daylight saving status.
  Trigger keywords: time-conversion, time-conv.
  Do NOT use for calendar arithmetic (adding days/weeks) — use a general reasoning approach instead.
compatibility: Requires MCP server called time configured in .augment/mcp-config.json.
---

# Time Conversion Skill

## Description

Convert times between any IANA-defined timezones and retrieve the current time in any
location using the `time` MCP server. All conversions are DST-aware and sourced from the
IANA timezone database, ensuring accuracy for both past and future dates where database
coverage exists.

## Capabilities

- Convert a specific time from one timezone to one or more target timezones
- Retrieve the current time in any IANA timezone
- Handle daylight saving time transitions automatically
- Resolve city or region names to their canonical IANA timezone identifiers
- Support multi-timezone comparisons (e.g., finding overlap windows for international meetings)

## Key Concepts

- **IANA timezone name**: The canonical identifier for a timezone (e.g., `America/New_York`, `Europe/London`, `Asia/Tokyo`) — always prefer over ambiguous abbreviations like `EST` or `BST`.
- **UTC**: The universal reference point; when in doubt, convert to UTC first then to the target.
- **DST**: Daylight Saving Time — the MCP server handles transitions automatically when IANA names are used; UTC offsets (e.g., `+05:30`) do not account for DST.
- **`get_current_time`**: MCP tool to retrieve the current time in a given IANA timezone.
- **`convert_time`**: MCP tool to convert a specific time from a source timezone to a target timezone.

## Workflow

1. **Connectivity probe** — call `get_current_time` with timezone `UTC` as the first action. If it fails, stop immediately and report: *"Time conversion MCP server is unavailable. Cannot proceed."*
2. **Resolve timezone names** — map any city names, abbreviations, or UTC offsets in the user's request to canonical IANA names before calling the tools.
3. **Select the right tool**:
   - Use `get_current_time` for "what time is it now in X?"
   - Use `convert_time` for "convert HH:MM from X to Y"
4. **Handle multi-timezone requests** — call `convert_time` (or `get_current_time`) once per target timezone; batch results into a single response table.
5. **Report** using this structure:
   - **Result**: converted time(s) with timezone name and UTC offset
   - **DST note**: flag if a DST transition is relevant to the result (e.g., clocks change within the next week)
   - **Reference**: IANA names used, for verification

## Usage Examples

### Current Time in a City
```
time-conv What time is it now in Tokyo?
```

### Basic Conversion
```
time-conv Convert 3:00 PM EST to Tokyo time
```

### Multi-Timezone Meeting
```
time-conv What time is 10 AM New York in London, Tokyo, and Sydney?
```

### ISO Timestamp Conversion
```
time-conv When is 2026-02-15 00:00 UTC in America/Los_Angeles?
```

### DST Awareness
```
time-conversion Is Europe/London currently on GMT or BST?
```

## Configuration

MCP server is called `time` and is configured in `.augment/mcp-config.json`.
No sensitive environment variables are required for this skill.

## Best Practices

- **Always use IANA timezone names** — abbreviations like `EST`, `BST`, `IST` are ambiguous and should be resolved to IANA names before calling tools
- **Always run a connectivity probe** (`get_current_time UTC`) before executing the user's request
- **Prefer `convert_time` over manual offset arithmetic** — let the MCP server handle DST automatically
- **Present results in a table** when converting to multiple timezones simultaneously
- **Flag DST transitions** when a conversion date falls near a clocks-change boundary

## Limitations

- Relies on the IANA timezone database; historical timezone changes before database coverage may be incomplete
- Future DST rule changes (e.g., countries abolishing DST) take effect only after a database update
- Cannot perform calendar arithmetic (adding/subtracting days or weeks) — use general reasoning for that
- UTC offsets (e.g., `+05:30`) are accepted but treated as fixed — DST is not applied when using raw offsets

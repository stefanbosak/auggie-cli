---
name: doc-search
description: >
  Documentation search specialist for retrieving accurate, structured information from
  official docs, GitHub repositories, and private resources.
  Use when asked to: look up API references, find library usage examples, read official
  guides, search framework documentation, or retrieve content from a specific docs URL.
  Trigger keywords: doc-search.
  Do NOT use for real-time or frequently changing information — use web-search instead.
compatibility: Requires MCP server called ref configured in .augment/mcp-config.json.
---

# Doc Search Skill

## Description

Search official documentation, GitHub repositories, and private resources for accurate,
structured technical information. Use for API references, library guides, framework
documentation, and SDK examples. Results come directly from authoritative sources,
not synthesized from training data.

## Capabilities

- Search public documentation across frameworks, libraries, and platforms
- Search private/internal documentation repositories (include `ref_src=private` in query)
- Read and extract content from a specific documentation URL
- Cross-reference multiple documentation sources in a single query
- Look up API signatures, configuration options, and usage examples
- Combine with `web-search` for supplemental context alongside official docs

## Key Concepts

- **Query**: A natural-language or keyword search sent to the documentation index; include programming language and framework/library names for precision.
- **ref_src=private**: Append to the query string to include the user's private documentation repositories in results.
- **URL read**: Pass a full documentation URL to `ref_read_url` to extract and summarize its content directly — use exact URLs returned by `ref_search_documentation` (including `#hash` fragments).
- **Authoritative source**: Results come from indexed docs pages, not model training data — prefer this for version-specific API details.

## Workflow

1. **Connectivity check** — the first `ref_search_documentation` call is an implicit connectivity probe. If it fails, stop and report: *"Doc search MCP server is unavailable. Cannot proceed."*
2. **Formulate query** — include programming language and library/framework name; add `ref_src=private` for private docs.
3. **Search** — call `ref_search_documentation` with the formulated query.
4. **Read target page** — for detailed content, call `ref_read_url` with the exact URL (including `#hash`) from search results.
5. **Report** using this structure:
   - **Answer**: direct response to the query
   - **Key details**: relevant API signatures, options, or examples
   - **Source**: documentation URL for verification

## Usage Examples

### API Reference Lookup
```
doc-search Python asyncio event loop API reference
```

### Framework Guide
```
ref How do I configure middleware in Express.js?
```

### Private Documentation
```
doc-search ref_src=private Internal service authentication API
```

### Read a Specific Page
```
doc-search Read https://docs.python.org/3/library/asyncio-task.html and summarize coroutine scheduling
```

### Combined with Web Search
```
web-search ref Latest React 19 features and official migration guide
```

## Configuration

MCP server is called ref and it is configured in `.augment/mcp-config.json`.
Environment variables are defined in `.augment/.env`.

## Best Practices

- **Always include** programming language and library/framework name in the query for accurate results
- **Always use exact URLs** (including `#hash` fragments) from `ref_search_documentation` results when calling `ref_read_url`
- Use `ref_src=private` when internal/private docs are needed
- Prefer over training data for version-specific API details, configuration options, and code examples
- Combine with `web-search` when official docs need supplemental context (e.g., community solutions, recent changelogs)
- Avoid for real-time or frequently changing information — use `web-search` instead

## Limitations

- Requires connectivity to the ref MCP server
- Coverage depends on what documentation is indexed — not all libraries may be available
- Private docs require proper authentication via environment variables
- URL reading (`ref_read_url`) requires an exact URL; fuzzy URL matching is not supported

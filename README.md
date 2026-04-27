<div align="center">

# 🤖 AugmentCode Auggie CLI

**Containerized AugmentCode Auggie CLI (Hardened)**

[![build_status_badge](../../actions/workflows/docker-image-native-multiplatform-pipeline.yml/badge.svg?branch=main)](.github/workflows/docker-image-native-multiplatform-pipeline.yml)
[![Auggie](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/augmentcode/auggie)
[![Documentation](https://img.shields.io/badge/Docs-GitHub-green?logo=github)](https://docs.augmentcode.com/cli/overview)
[![MCP](https://img.shields.io/badge/MCP-Servers-orange)](https://mcpservers.org/)

</div>

---

## 📦 Latest Build

<!-- VERSION_INFO_START -->
| Component | Version |
|-----------|---------|
| **AugmentCode Auggie CLI** | [`v0.25.0-prerelease.8`](https://github.com/augmentcode/auggie/releases/tag/v0.25.0-prerelease.8) |

> 🔄 Last updated: 2026-04-27T10:06:07Z · [Build #63](https://github.com/stefanbosak/auggie-cli/actions/runs/24988716465)
<!-- VERSION_INFO_END -->

---

## 📋 Overview

This repository provides a fully automated preparation of  <span style="color: #0969da;">**containerized**</span> [AugmentCode Auggie CLI](https://github.com/augmentcode/auggie) environment with integrated <span style="color: #8250df;">**MCP server**</span> support using <span style="color: #1a7f37;">**Docker-in-Docker**</span> architecture.

### About solution
- Sandboxing environment for AI scope (reduced possible negative impact via isolation)
- Automated packaging of current tool versions (optimized maintenance effort via automation)
- Strong focus on security (mitigated security issues and vulnerabilities through hardening)
- Simplification of the initial run-up (see: [Container runner script](./auggie.sh), [AugmentCode Auggie setup](./.augment/settings.json), [Environment configuration](./.augment/.env))

- **Container image is:**
  - keyless-signed via cosign using GitHub OIDC certificate issuer (trusted verifiable source)
  - automatically built when a new pre-release of AugmentCode Auggie CLI is detected (scheduled monitoring - every hour)

### 📚 Resources

- 📖 [Official Documentation](https://docs.augmentcode.com/cli/overview)
- 📖 [AI models database](https://models.dev)
- 🤖 **Supported AI Models**: Haiku, Sonnet, Opus, GPT 5.4
  - **Recommended models**:
    - <span style="color: #8250df;">**Anthropic Claude Sonnet**</span> - [Documentation](https://www.anthropic.com/claude/sonnet): Low, Medium, High
    - <span style="color: #a371f7;">**Anthripic Claude Opus**</span> - [Documentation](https://www.anthropic.com/claude/opus): Normal (Low, Medium, High), Fast (Low, Medium, High)
    - <span style="color: #a371f7;">**OpenAI GPT 5.4**</span> - [Documentation](https://openai.com/index/introducing-gpt-5-4/): Low, Medium, High, Extra High
  - **Effective Prompting**:
    - Save output to prevent data loss (reduce costs)
    - Iteratively processing excessively long messages (drop error rate ~<10%)
    - XML tags ensure structural clarity (compliance increase to ~>98 %)
    - Validate continuously (maintain ~>95% accuracy)
    - Instruct what to avoid, not what to do (significantly reduce hallucination by ~>60 %)
    - Contextualize personas (~<15 % improvement using personas)

### AugmentCode IP prefixes, subdomains for whitelisting

- ``dig +short eu-static.augmentcode.com``
- ``dig +short us-static.augmentcode.com``

### ⚠️ Important Notices

> [!NOTE]
> All files in this repository are well-commented with relevant implementation details.

> [!IMPORTANT]
> Always review and understand the code before executing any commands.

> [!CAUTION]
> Users are solely responsible for any modifications or execution of code from this repository.

## 🛠 Utilities
- [uv](https://github.com/astral-sh/uv) - An extremely fast Python package installer and resolver
- [bun](https://github.com/oven-sh/bun) - All-in-one JavaScript runtime and toolkit for faster development
- [mdflow](https://github.com/johnlindquist/mdflow) - Markdown-based workflow automation tool for streamlined task execution

## 🔌 MCP Servers

### <span style="color: #8250df;">🧠 Reasoning & Documentation</span>

#### **sequentialthinking** - <span style="color: #8250df;">Step-by-Step Reasoning</span>
- **Benefits:** <span style="color: #1a7f37;">Reduces token consumption by 5-55%</span>
- **Documentation:** [Sequential Thinking MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)

#### **ref** - <span style="color: #8250df;">Documentation Search</span>
- **Type:** <span style="color: #0969da;">HTTP</span>
- **URL:** `https://api.ref.tools/mcp`
- **Authentication:** <span style="color: #d73a49;">Requires `REF_API_KEY`</span>
- **Benefits:** <span style="color: #1a7f37;">Essential for efficient context retrieval</span>
- **Documentation:** [Ref.tools](https://ref.tools/)

---

### <span style="color: #1a7f37;">🌐 Utilities</span>

#### **fetch** - <span style="color: #1a7f37;">Web Fetching</span>
- **Documentation:** [Fetch MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/fetch)

#### **time** - <span style="color: #1a7f37;">Time & Timezone</span>
- **Documentation:** [Time MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/time)

---

### <span style="color: #0969da;">🗄️ Database & Storage</span>

#### **postgres** - <span style="color: #0969da;">PostgreSQL Integration</span>
- **Documentation:** [MCP Toolbox for Databases](https://github.com/googleapis/genai-toolbox)
- ⚠️ **Note:** <span style="color: #d73a49;">Linux ARM64 architecture not currently supported ([issue](https://github.com/googleapis/genai-toolbox/issues/2754))</span>

---

### <span style="color: #d73a49;">📊 Monitoring & Logging</span>

#### **grafana** - <span style="color: #d73a49;">Grafana</span>
| test | production |
| -----|------------|
| [agent](.augment/agents/grafana-tst.agent.md) | [agent](.augment/agents/grafana-prd.agent.md) |
| [skill](.augment/skills/grafana-tst/SKILL.md) | [skill](.augment/skills/grafana-prd/SKILL.md) |
- **Documentation:** [Grafana MCP Server](https://github.com/grafana/mcp-grafana)

#### **graylog** - <span style="color: #d73a49;">Graylog</span>
| test | production |
| -----|------------|
| [agent](.augment/agents/graylog-tst.agent.md) | [agent](.augment/agents/graylog-prd.agent.md) |
| [skill](.augment/skills/graylog-tst/SKILL.md) | [skill](.augment/skills/graylog-prd/SKILL.md) |
- **Authentication:** <span style="color: #d73a49;">Authorization header required</span>
- **Documentation:** [Graylog MCP Documentation](https://go2docs.graylog.org/current/setting_up_graylog/model_context_protocol__mcp__tools.htm)


## 📁 Repository Structure

### <span style="color: #8250df;">Configuration Files</span>
| File | Description | Note |
|------|-------------|------|
| [`settings.json`](./.augment/settings.json) | <span style="color: #0969da;">Auggie CLI configuration</span> | |
| [`.env`](./.augment/.env) | <span style="color: #1a7f37;">Environment variables</span> | |
| [`commands`](./.augment/commands) | <span style="color: #1a7f37;">Commands</span> | [docs](https://docs.augmentcode.com/cli/custom-commands) |
| [`rules`](./.augment/rules) | <span style="color: #1a7f37;">Rules</span> | [docs](https://docs.augmentcode.com/cli/rules) |

### <span style="color: #0969da;">Docker & Build</span>
| File | Description |
|------|-------------|
| [`Dockerfile`](./Dockerfile) | <span style="color: #0969da;">Container image configuration</span> |
| [`auggie-build.sh`](./auggie-build.sh) | <span style="color: #1a7f37;">Build automation script</span> |
| [`auggie.sh`](./auggie.sh) | <span style="color: #1a7f37;">Execution wrapper script</span> |
| [`act.sh`](./act.sh) | <span style="color: #1a7f37;">Act tool script</span> |

## Other resources
- [Code-review best practices](https://github.com/augmentcode/code-review-best-practices)
- [PR review](https://github.com/augmentcode/review-pr)
- [PR describe](https://github.com/augmentcode/describe-pr)
- [AugmentCode GitHub Action](https://github.com/augmentcode/augment-action)

## 🐳 Container Images

### <span style="color: #0969da;">Available Registries</span>

| Registry | Network Support | Pull Command |
|----------|----------------|--------------|
| [**GitHub CR**](https://github.com/stefanbosak/auggie-cli/pkgs/container/auggie-cli) | <span style="color: #8250df;">IPv4 only</span> | `docker pull ghcr.io/stefanbosak/auggie-cli:initial` |
| [**Docker Hub**](https://hub.docker.com/r/developmententity/auggie-cli) | <span style="color: #1a7f37;">IPv4 & IPv6</span> | `docker pull developmententity/auggie-cli:initial` |

---

## 📊 Star History

<a href="https://www.star-history.com/#stefanbosak/auggie-cli&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=stefanbosak/auggie-cli&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=stefanbosak/auggie-cli&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=stefanbosak/auggie-cli&type=Date" />
  </picture>
</a>

⭐ **Feel free to drop a star if you find this useful.**

---

<div align="center">

<span style="color: #8250df;">**Made with ❤ for ⚡ efficiency and 🔒 security**</span>

</div>

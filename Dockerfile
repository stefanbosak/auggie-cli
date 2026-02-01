# Non-hardened alternative
# FROM node:trixie-slim

# Hardened Node.js (current) [2026-Jan]
# FROM dhi.io/node:25-debian13-dev

# Hardened Node.js (LTS) [2026-Jan]
FROM dhi.io/node:24-debian13-dev

ARG TARGETARCH
ARG TARGETOS

LABEL org.opencontainers.image.authors="Stefan Bosak" \
      org.opencontainers.image.url="https://github.com/stefanbosak/auggie-cli" \
      org.opencontainers.image.source="https://github.com/stefanbosak/auggie-cli" \
      org.opencontainers.image.title="Auggie CLI container" \
      org.opencontainers.image.description="Debian-based AugmentCode Auggie CLI container"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    bc \
    ca-certificates \
    curl \
    dnsutils \
    gh \
    git \
    gzip \
    iproute2 \
    iputils-ping \
    jq \
    kmod \
    lsof \
    openssh-client \
    pigz \
    procps \
    psmisc \
    python3-venv \
    ripgrep \
    rsync \
    socat \
    unzip \
    vim \
    wget \
    whois \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Install development tools and configure Docker-in-Docker
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
  TOOLBOX_VERSION=$(git ls-remote --refs --sort='version:refname' \
      --tags "https://github.com/googleapis/genai-toolbox" \
      | grep -vE 'alpha|beta|rc|dev|None|list|nightly|\{' | cut -d'/' -f3 \
      | tail -n 1) \
  && curl -sSL -o "/usr/local/bin/toolbox" \
      "https://storage.googleapis.com/genai-toolbox/${TOOLBOX_VERSION}/${TARGETOS}/${TARGETARCH}/toolbox" \
  && chmod +x "/usr/local/bin/toolbox"; \
  fi \
  # Install AgumentCode Augge CLI (prerelease), Sequential Thinking MCP server
  && npm install -g --no-audit --no-fund @augmentcode/auggie@prerelease @modelcontextprotocol/server-sequential-thinking \
  # Install uv (Python package manager)
  && curl -LsSf https://astral.sh/uv/install.sh \
      | UV_INSTALL_DIR=/usr/local/bin sh \
  # Install Docker-in-Docker
  # Note: DinD via QEMU on ARM64 not supported
  # (ARM64 requires ARM64 kernel from host, not available on AMD64 host)
  && curl -fsSL https://get.docker.com | sh \
  && if ! getent group docker > /dev/null 2>&1; then \
       groupadd -g 999 docker; \
     fi \
  && usermod -aG docker "node"

# Configure bash shell for subsequent RUN commands
SHELL ["/usr/bin/bash", "-c"]

# Create symlink for tools and setup user environment
RUN AUGGIE_PATH="/opt/nodejs/node-v${NODE_VERSION}/bin/auggie" \
  && ln -s "${AUGGIE_PATH}" /usr/local/bin/auggie \
  && MCP_SERVER_SEQUENTIAL_THINKING_PATH="/opt/nodejs/node-v${NODE_VERSION}/bin/mcp-server-sequential-thinking" \
  && ln -s "${MCP_SERVER_SEQUENTIAL_THINKING_PATH}" /usr/local/bin/mcp-server-sequential-thinking \
  && cp /etc/skel/.bashrc /home/node/

USER node

WORKDIR /workspace

CMD ["auggie"]

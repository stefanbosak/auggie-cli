# Non-hardened alternative
# FROM node:trixie-slim

# Hardened Node.js (current) [2026-Jan]
# FROM dhi.io/node:25-debian13-dev

# Hardened Node.js (LTS) [2026-Jan]
FROM dhi.io/node:24-debian13-dev

ARG TARGETARCH
ARG TARGETOS

ARG CONTAINER_USER=user
ARG CONTAINER_GROUP=user

ARG CONTAINER_USER_ID=1000
ARG CONTAINER_GROUP_ID=1000

ARG DEBIAN_FRONTEND=noninteractive

ARG WORKSPACE_ROOT_DIR="/home/${CONTAINER_USER}"

ARG AUGGIE_CLI_RELEASE_VERSION="latest"

WORKDIR "${WORKSPACE_ROOT_DIR}"

LABEL org.opencontainers.image.description="AugmentCode Auggie CLI container and tooling"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    bc \
    ca-certificates \
    curl \
    dnsutils \
    gh \
    git git-lfs \
    gzip \
    iproute2 \
    iputils-ping \
    jq \
    kmod \
    libatomic1 \
    lsof \
    openssh-client \
    pigz \
    procps \
    psmisc \
    python-is-python3 \
    python3-venv \
    ripgrep \
    rsync \
    socat \
    unzip \
    wget \
    whois \
    zip \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

COPY "./tools.yaml" "/usr/local/bin/tools.yaml"

# Install development tools and configure Docker-in-Docker
RUN if getent group "${CONTAINER_GROUP_ID}" > /dev/null; then \
      _existing_group="$(getent group "${CONTAINER_GROUP_ID}" | cut -d: -f1)"; \
      if [ "${_existing_group}" != "${CONTAINER_GROUP}" ]; then \
        groupmod -n "${CONTAINER_GROUP}" "${_existing_group}"; \
      fi; \
    else \
      groupadd --gid "${CONTAINER_GROUP_ID}" "${CONTAINER_GROUP}"; \
    fi \
    && if getent passwd "${CONTAINER_USER_ID}" > /dev/null; then \
         _existing_user="$(getent passwd "${CONTAINER_USER_ID}" | cut -d: -f1)"; \
         if [ "${_existing_user}" != "${CONTAINER_USER}" ]; then \
           if [ -d "/home/${_existing_user}" ]; then \
             mv "/home/${_existing_user}" "/home/${CONTAINER_USER}"; \
           fi; \
           usermod -d "/home/${CONTAINER_USER}" -l "${CONTAINER_USER}" "${_existing_user}"; \
         fi; \
       else \
         useradd \
           --uid "${CONTAINER_USER_ID}" \
           --gid "${CONTAINER_GROUP_ID}" \
           --groups "${CONTAINER_GROUP}" \
           -M -d "${WORKSPACE_ROOT_DIR}" \
           -s /bin/bash \
           "${CONTAINER_USER}"; \
       fi \
    && mkdir -p /workspace \
    && chown -R "${CONTAINER_USER}:${CONTAINER_GROUP}" "${WORKSPACE_ROOT_DIR}" /workspace \
  && if [ "${TARGETARCH}" = "amd64" ]; then \
  TOOLBOX_VERSION=$(git ls-remote --refs --sort='version:refname' \
      --tags "https://github.com/googleapis/mcp-toolbox" \
      | grep -vE 'alpha|beta|rc|dev|None|list|nightly|\{' | cut -d'/' -f3 \
      | tail -n 1) \
  && curl -sSL -o "/usr/local/bin/toolbox" \
       "https://storage.googleapis.com/mcp-toolbox-for-databases/${TOOLBOX_VERSION}/${TARGETOS}/${TARGETARCH}/toolbox" \
  && chmod +x "/usr/local/bin/toolbox"; \
  fi \
  # Install AgumentCode Augge CLI
  && curl -fsSL https://github.com/augmentcode/auggie/releases/download/v${AUGGIE_CLI_RELEASE_VERSION}/install.sh | \
       VERSION=v${AUGGIE_CLI_RELEASE_VERSION} INSTALL_DIR=/usr/local/bin CLI_NAME=auggie bash \
  # Install uv (Python package manager)
  && curl -LsSf https://astral.sh/uv/install.sh \
      | UV_INSTALL_DIR=/usr/local/bin sh \
  # Install bun (all-in-one JS toolkit)
  && curl -fsSL https://bun.com/install \
      | BUN_INSTALL=/usr/local bash \
  # Install mdflow
  && BUN_INSTALL=/usr/local bun install --global mdflow \
  # Install Docker-in-Docker
  # Note: DinD via QEMU on ARM64 not supported
  # (ARM64 requires ARM64 kernel from host, not available on AMD64 host)
  && curl -fsSL https://test.docker.com | sh \
  && if ! getent group docker > /dev/null 2>&1; then \
       groupadd -g 999 docker; \
     fi \
  && usermod -aG docker "${CONTAINER_USER}"

USER "${CONTAINER_USER}:${CONTAINER_GROUP}"

RUN cp /etc/skel/.bashrc /etc/skel/.profile "/home/${CONTAINER_USER}"

WORKDIR /workspace

CMD ["auggie"]

#!/bin/bash

# start Docker build
export DOCKER_BUILDKIT_ATTESTATIONS=0

# default target OS, architecture and platforms
export TARGETOS=${TARGETOS:-linux}

if [ -f "/etc/debian_version" ]; then
  export TARGETARCH=${TARGETARCH:-$(dpkg --print-architecture)}
else
  export TARGETARCH=${TARGETARCH:-"amd64"}
fi

export CWD="$(basename $(dirname $(realpath "${0}")))"
export TARGETPLATFORM=${TARGETPLATFORM:-"${TARGETOS}/${TARGETARCH}"}

# container user and group
export CONTAINER_USER=${CONTAINER_USER:-"${USER}"}
export CONTAINER_GROUP=${CONTAINER_GROUP:-"${USER}"}

# container user ID and group ID
export CONTAINER_USER_ID=${CONTAINER_USER_ID:-$(id -u)}
export CONTAINER_GROUP_ID=${CONTAINER_GROUP_ID:-$(id -g)}

# set location of workspace directory
export WORKSPACE_ROOT_DIR=${WORKSPACE_ROOT_DIR:-"/home/${CONTAINER_USER}"}

docker buildx build --network=host --provenance=false --sbom=false --no-cache --platform "${TARGETPLATFORM}" \
              --label "org.opencontainers.image.created=$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
              --label "org.opencontainers.image.source=https://github.com/stefanbosak/${CWD}" \
              --build-arg CONTAINER_USER="${CONTAINER_USER}" \
              --build-arg CONTAINER_GROUP="${CONTAINER_GROUP}" \
              --build-arg CONTAINER_USER_ID="${CONTAINER_USER_ID}" \
              --build-arg CONTAINER_GROUP_ID="${CONTAINER_GROUP_ID}" \
              --build-arg WORKSPACE_ROOT_DIR="${WORKSPACE_ROOT_DIR}" \
              -t "localhost/${CWD}:initial" .

#!/bin/bash

# extract Docker GID from the system
DOCKER_GID=$(getent group docker | cut -d: -f3)

# start Docker build
export DOCKER_BUILDKIT_ATTESTATIONS=0

# default target OS, architecture and platforms
export TARGETOS=${TARGETOS:-linux}

if [ -f "/etc/debian_version" ]; then
  export TARGETARCH=${TARGETARCH:-$(dpkg --print-architecture)}
else
  export TARGETARCH=${TARGETARCH:-"amd64"}
fi

export TARGETPLATFORM=${TARGETPLATFORM:-"${TARGETOS}/${TARGETARCH}"}

docker buildx build --provenance=false --sbom=false --no-cache --push --platform "${TARGETPLATFORM}" --build-arg DOCKER_GID="${DOCKER_GID}" -t ghcr.io/stefanbosak/auggie-cli:initial .

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

export TARGETPLATFORM=${TARGETPLATFORM:-"${TARGETOS}/${TARGETARCH}"}

docker buildx build --network=host --force-rm --rm --provenance=false --sbom=false --no-cache --push --platform "${TARGETPLATFORM}" -t ghcr.io/stefanbosak/auggie-cli:initial .

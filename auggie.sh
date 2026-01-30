#!/bin/bash
#
# AugmentCode Auggie CLI runner wrapper
#

#
# Docker container AugmentCode Auggie CLI wrapper
#
auggie() {
  # extract Docker GID from the system
  export DOCKER_GID=$(getent group docker | cut -d: -f3)

  docker run -it --rm \
    --group-add "${DOCKER_GID}" \
    --env-file "${HOME}/.augment/.env" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "${HOME}/.augment:/home/node/.augment" \
    -v "${HOME}/workspace:/workspace" \
    -v "${HOME}/.docker:/home/node/.docker:ro" \
    -v "${HOME}/.docker/mcp:/home/node/.docker/mcp" \
    -w "/workspace" \
    ghcr.io/stefanbosak/auggie-cli:initial \
    auggie "$@"
}

# run
auggie "${@}"

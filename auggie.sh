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
    # add obtained docker group from host into container
    --group-add "${DOCKER_GID}" \
    # AugmentCode Auggie CLI environment variables
    --env-file "${HOME}/.augment/.env" \
    # Docker in Docker socket mapping
    -v /var/run/docker.sock:/var/run/docker.sock \
    # AugmentCode Auggie CLI configuration storage
    -v "${HOME}/.augment:/home/node/.augment" \
    # workspace used by AugmentCode Auggie CLI
    -v "${HOME}/workspace:/workspace" \
    # Docker configuration storage
    -v "${HOME}/.docker:/home/node/.docker:ro" \
    # Docker MCP toolkit (optional)
    -v "${HOME}/.docker/mcp:/home/node/.docker/mcp" \
    # set workspace directory
    -w "/workspace" \
    ghcr.io/stefanbosak/auggie-cli:initial \
    # AugmentCode Auggie CLI arguments
    auggie "$@"
}

# run
auggie "${@}"

#!/bin/bash
auggie() {
  docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --env-file "${HOME}/.augment/.env" \
    -v "${HOME}/.augment:/home/node/.augment" \
    -v "${HOME}/workspace:/workspace" \
    -w "/workspace" \
    -it ghcr.io/stefanbosak/auggie-cli:initial \
    auggie "$@"
}

auggie "${@}"

#!/bin/bash
#
# AugmentCode Auggie CLI runner wrapper
#

#
# Docker container AugmentCode Auggie CLI wrapper
#
auggie() {
  # extract repository name
  export CWD="$(basename $(dirname $(realpath "${0}")))"

  # extract Docker GID from the system
  export DOCKER_GID=$(getent group docker | cut -d: -f3)

  # construct container image string
  export CONTAINER_IMAGE_REGISTRY="ghcr.io" # docker.io
  export CONTAINER_IMAGE_NAMESPACE="stefanbosak" # developmententity
  export CONTAINER_IMAGE_NAME="${CWD}"
  export CONTAINER_IMAGE_TAG="initial"
  export CONTAINER_IMAGE="${CONTAINER_IMAGE_REGISTRY}/${CONTAINER_IMAGE_NAMESPACE}/${CONTAINER_IMAGE_NAME}:${CONTAINER_IMAGE_TAG}"

  # check prerequisite - Docker
  if [ -z "$(which docker)" ]; then
      echo "Docker is missing, terminating..."
      exit 1
  fi

  # check prerequisite - cosign
  if [ ! -z "$(which cosign)" ]; then
    export CONTAINER_IMAGE_DIGEST=$(docker buildx imagetools inspect "${CONTAINER_IMAGE}" --format '{{json .}}' | jq -r '.manifest.digest')

    cosign verify \
      --certificate-identity-regexp="https://github\.com/${CONTAINER_IMAGE_NAMESPACE}/${CONTAINER_IMAGE_NAME}/\.github/workflows/.*" \
      --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
      "${CONTAINER_IMAGE}@${CONTAINER_IMAGE_DIGEST}" > /dev/null 2>&1

    if [ ${?} -ne 0 ]; then
      echo "Signature for container image ${CONTAINER_IMAGE} is not valid, terminating..."
      exit 1
    fi
  fi

   # pull up-to-date image and start augment
  docker run --quiet --rm -it --pull=always --cpus=4 --memory=1G \
    --group-add "${DOCKER_GID}" \
    --env-file "${HOME}/.augment/.env" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "${HOME}/.augment:/home/${USER}/.augment" \
    -v "${HOME}/workspace:/workspace" \
    -v "${HOME}/.docker:/home/${USER}/.docker:ro" \
    -v "${HOME}/.docker/mcp:/home/${USER}/.docker/mcp" \
    -w "/workspace" \
    "${CONTAINER_IMAGE}" \
    auggie "$@"
}

# run
auggie "${@}"

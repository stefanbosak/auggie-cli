#!/bin/bash
#
# Act tool (for executing of GitHub Actions workflows locally)
#
# See more (https://github.com/nektos/act/blob/master/README.md)
#
# change parameters, add/modify propagated secrets before first use
#
cwd=$(dirname $(realpath "${0}"))

# check prerequisites (if all required tools are available)
TOOLS="act"

for tool in ${TOOLS}; do
  if [ -z "$(which ${tool})" ]; then
    echo "Tool ${tool} has not been found, please install tool in your system"
    echo "Installer: https://raw.githubusercontent.com/nektos/act/master/install.sh"
    exit 1
  fi
done

# perform preparation job in dry-run mode
time act workflow_dispatch -W "${cwd}/.github/workflows/docker-image-prepare-amd64-arm64.yml" -s DH_USER=$(cat ~/DHUser.txt) -s DH_TOKEN=$(cat ~/DHToken.txt) -s GH_TOKEN=$(cat ~/GHToken.txt) -j docker-build-test-tag-push -a "${USER}" --container-options "-v /dev/:/dev" -n

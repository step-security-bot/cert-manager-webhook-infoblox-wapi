#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# cSpell:ignore CONFIGUREZSHASDEFAULTSHELL zshell

# Install Microsoft Dev Container Features.
# Create the user set by the USERNAME env var
# See: https://github.com/devcontainers/features
main() {
  source "/usr/bin/lib/sh/log.sh"
  log "20-install-microsoft-dev-container-features.sh" "blue"

  log "Exporting zshell variables" "green"
  export CONFIGUREZSHASDEFAULTSHELL=true
  export INSTALL_OH_MY_ZSH=true
  export UPGRADEPACKAGES=false

  log "Making /tmp/source directory" "green"
  mkdir /tmp/source
  cd /tmp/source

  log "Cloning devcontainers features repository" "green"
  git clone --depth 1 -- https://github.com/devcontainers/features.git

  log "Running install script" "green"
  cd /tmp/source/features/src/common-utils/
  ./install.sh

  log "Running dnf autoremove" "green"
  dnf autoremove -y

  log "Running dnf clean all" "green"
  dnf clean all

  log "Removing /tmp/source direcotry" "green"
  cd -

  log "Deleting files from /tmp" "green"
  rm -rf /tmp/*
}

# Run main
if ! (return 0 2>/dev/null); then
  (main "$@")
fi

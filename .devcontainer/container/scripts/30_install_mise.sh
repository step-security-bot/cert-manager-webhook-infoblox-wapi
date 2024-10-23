#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

main() {
  source "/usr/bin/lib/sh/log.sh"

  ############ Install mise
  log "30-install-mise.sh" "blue"

  log "Installing mise" "green"
  curl -sL https://mise.run | sh
  export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin/:$PATH"

  log "Mise version" "green"
  mise version

  log "Trusting configuration files" "green"
  mise trust "$HOME/.config/mise/config.toml"
  mise trust --all

  log "Installing tools with mise" "green"
  mise install --yes

  log "Deleting files from /tmp" "green"
  sudo rm -rf /tmp/*
}

# Run main
if ! (return 0 2>/dev/null); then
  (main "$@")
fi

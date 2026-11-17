#!/bin/zsh
# Ovis (herdr phone client) helpers. Only defined where herdr and bun exist.
(( $+commands[herdr] && $+commands[bun] )) || return 0

# Path of the installed Ovis plugin checkout (it moves on every update)
ovis-root() {
  local root
  root=$(herdr plugin list --json | bun -e 'const d = JSON.parse(await Bun.stdin.text()); console.log(d.result.plugins.find((p) => p.plugin_id === "devswha.ovis")?.plugin_root ?? "")')
  if [[ -z "$root" ]]; then
    print -u2 "ovis: plugin devswha.ovis is not installed (curl -fsSL https://ovis.sh/install.sh | sh)"
    return 1
  fi
  print -r -- "$root"
}

# Print a one-time pairing code for a new phone/device (have the device in hand)
ovis-pair() {
  local root
  root=$(ovis-root) || return 1
  bun "$root/scripts/plugin.ts" pair "$@"
}

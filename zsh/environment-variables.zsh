#!/bin/zsh
# Shared interactive environment (every OS). OS-specific bits live in zsh/os/*.zsh.

export IS_WSL="${IS_WSL:-false}"
export HOST_HOME="${HOST_HOME:-$HOME}"

export SECRETS_DIR="$DOT_FILES_DIR/.secrets"          # legacy, gitignored
export SECRET_ENV_FILE="$SECRETS_DIR/.env.secret.zsh" # legacy, gitignored
export GCP_DIR="$HOME/.gcp"
export repos="$HOME/Development/repos/"
# Kept from the old setup: some tools here read their config from $APPDATA.
# Remove it if nothing needs it; a few cross-platform CLIs take APPDATA as a "this is Windows" hint.
export APPDATA="${APPDATA:-$HOME}"

# Kubernetes: merge every kubeconfig found instead of maintaining one merged file.
# Order matters: the first file that sets current-context wins.
# (~/.kube/merged.yaml is still honoured if it exists, for the Rancher setup in the home-lab repo.)
if [[ -z "$KUBECONFIG" ]]; then
  typeset -a _kubeconfigs
  _kubeconfigs=("$HOME"/.kube/merged.yaml(N) "$HOME"/.kube/config(N) "$HOME"/.kube/configs/*.y(a|)ml(N))
  (( ${#_kubeconfigs} )) && export KUBECONFIG="${(j.:.)_kubeconfigs}"
  unset _kubeconfigs
fi

# bat / delta / fzf niceties (only when installed)
(( $+commands[bat] )) && export MANPAGER="sh -c 'col -bx | bat -l man -p'" BAT_THEME="${BAT_THEME:-ansi}"
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
fi

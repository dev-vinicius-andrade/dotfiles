#!/bin/zsh
# Aliases. Every tool-specific block is guarded so a missing tool never breaks the shell.
# WSL-only aliases live in zsh/os/wsl.zsh.

# --- files -------------------------------------------------------------------
if (( $+commands[eza] )); then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza --icons --group-directories-first -l --git"
  alias la="eza --icons --group-directories-first -la --git"
  alias lt="eza --icons --tree --level=2 --git-ignore"
fi
alias lslha="ls -lha"
(( $+commands[bat] )) && alias cat="bat --paging=never" # plain output when piped
(( $+commands[zoxide] )) && alias cd="z"

# --- editors -----------------------------------------------------------------
alias svi="sudo -E vi"
alias svim="sudo -E vim"
alias snvim="sudo -E nvim"
alias v="nvim"

# --- git ---------------------------------------------------------------------
# pull a repo without leaving the current directory
gopull() { git -C "${1:-.}" pull; }
(( $+commands[lazygit] )) && alias lg="lazygit"

# --- containers --------------------------------------------------------------
if (( $+commands[podman] )); then
  alias pcu="podman compose up"
  alias pcud="podman compose up -d"
  alias pcd="podman compose down"
  alias podman_names='podman ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Created}}\t{{.Ports}}"'
fi

# --- kubernetes --------------------------------------------------------------
# oh-my-zsh's kubectl plugin already provides k, kgp, kaf, kl, ... (`alias | grep kubectl`)
if (( $+commands[kubectl] )); then
  (( $+commands[kubecolor] )) && alias kubectl="kubecolor" && compdef kubecolor=kubectl 2>/dev/null
  (( $+commands[kubectx] )) && alias kctx="kubectx"
  (( $+commands[kubens] ))  && alias kns="kubens"
  (( $+commands[k9s] ))     && alias k9="k9s"
  (( $+commands[stern] ))   && alias klogs="stern"
  # what am I pointed at?
  alias kwhere='kubectl config current-context; kubectl config view --minify -o jsonpath="{..namespace}{\"\n\"}"'
fi

# --- atuin (history stats) ---------------------------------------------------
if (( $+commands[atuin] )); then
  hstats()  { atuin stats -c "${1:-15}" "${@:2}"; }                     # all-time top commands
  hweek()   { atuin stats -c 15 last week; }                            # last 7 days
  htoday()  { atuin stats -c 15 today; }
  hhere()   { atuin stats -c 15 --filter-mode directory; }              # this directory only
  hrepo()   { atuin stats -c 15 --filter-mode workspace; }              # this git repo only
  hpairs()  { atuin stats -c 15 -n "${1:-2}"; }                         # common command sequences -> alias candidates
  hwrapped(){ atuin wrapped "$@"; }                                     # year in review
fi

# --- nix ---------------------------------------------------------------------
if (( $+commands[nix-env] )); then
  alias nxi='nix-env -i'  # install
  alias nxu='nix-env -u'  # update
  alias nxr='nix-env -e'  # remove
  alias nxls='nix-env -q' # list
  alias nxgc='nix-collect-garbage -d'
  (( $+commands[home-manager] )) && alias hmswt='home-manager switch'
fi

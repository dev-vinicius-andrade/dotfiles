# ~/.zshrc — interactive shells only.
# Set DOTFILES_VERBOSE=1 to print what gets loaded (startup is quiet by default so
# real errors stay visible). Measure startup with: time zsh -i -c exit
stty -ixon 2>/dev/null

# --- herdr: start it first, before any other init ----------------------------
# Guarded against nested sessions, Zellij, and editor terminals (VS Code needs a
# plain shell). Leaving herdr closes this outer shell; if herdr fails to start,
# you fall through to a normal shell.
if [[ -t 1 && $- == *i* && -z "$ZELLIJ" && -z "$HERDR_ACTIVE" \
      && "$TERM_PROGRAM" != "vscode" && -z "$VSCODE_INJECTION" && -z "$DOTFILES_NO_HERDR" ]] \
   && (( $+commands[herdr] )); then
  export HERDR_ACTIVE=1
  herdr && exit
fi

_dot_log() { [[ -n "$DOTFILES_VERBOSE" ]] && print -r -- "$@"; return 0 }

# --- dotfiles location (follows the ~/.zshrc symlink) ------------------------
DOT_FILES_DIR="${${(%):-%x}:A:h}"
# home-manager links into the read-only /nix/store: keep the unresolved path there
[[ "$DOT_FILES_DIR" == /nix/store/* ]] && DOT_FILES_DIR="${${(%):-%x}:h}"
export DOT_FILES_DIR
_dot_log "DOT_FILES_DIR: $DOT_FILES_DIR"

# --- oh-my-zsh ---------------------------------------------------------------
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="" # starship draws the prompt

plugins=(git)
for _p in fzf zoxide eza dotnet docker docker-compose podman kubectl helm; do
  (( $+commands[$_p] )) && plugins+=("$_p")
done
unset _p
# third-party plugins: only if installed (custom/ or a system package with omz)
for _p in zsh-autosuggestions zsh-syntax-highlighting; do
  [[ -d "${ZSH_CUSTOM:-$ZSH/custom}/plugins/$_p" || -d "$ZSH/plugins/$_p" ]] && plugins+=("$_p")
done
unset _p

export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export ZSH_HIGHLIGHT_MAXLENGTH=512
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# --- dotfiles modules --------------------------------------------------------
_dot_source() {
  [[ -r "$1" ]] || return 0
  source "$1" && _dot_log "loaded ${1#$DOT_FILES_DIR/}"
}

_dot_source "$DOT_FILES_DIR/scripts/zsh/utils.zsh"
case "$OSTYPE" in
  linux*)  _dot_source "$DOT_FILES_DIR/zsh/os/linux.zsh"
           [[ -r /proc/version ]] && grep -qi 'microsoft\|wsl' /proc/version \
             && _dot_source "$DOT_FILES_DIR/zsh/os/wsl.zsh" ;;
  darwin*) _dot_source "$DOT_FILES_DIR/zsh/os/darwin.zsh" ;;
esac
_dot_source "$DOT_FILES_DIR/zsh/environment-variables.zsh"
_dot_source "$DOT_FILES_DIR/zsh/secrets.zsh"   # sops-encrypted, committed
_dot_source "$SECRET_ENV_FILE"                 # legacy plaintext, gitignored
_dot_source "$DOT_FILES_DIR/zsh/aliases.zsh"
_dot_source "$DOT_FILES_DIR/zsh/functions.zsh"
_dot_source "$DOT_FILES_DIR/zsh/keybinds.zsh"
_dot_source "$DOT_FILES_DIR/zsh/highlighting.zsh"
source_zsh_recursive "$DOT_FILES_DIR/zsh/functions"
_dot_source "$HOME/.zshrc.local"               # machine-only, untracked

generate_nvim_mson_install_configuration
create_gcp_dir_if_not_exists
create_microsoft_symbolic_link

# --- tool integrations (each only if installed) ------------------------------
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
(( $+commands[fnm] ))    && eval "$(fnm env --use-on-cd --shell zsh)"   # only switches in dirs with .nvmrc/.node-version
(( $+commands[ng] ))     && source <(ng completion script 2>/dev/null)
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"   # bun completions

# yazi: `y` opens yazi and cd's to wherever you quit it
if (( $+commands[yazi] )); then
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
  }
fi

# prompt: after all plugins, widgets and keymaps are bound
_dot_source "$DOT_FILES_DIR/zsh/prompt.zsh"

# atuin last so its Ctrl-R binding wins
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh --disable-up-arrow)"
fi


if [[ -r "$HOME/dotfiles/secrets/env.sops.env" ]]; then
  set -a
  source <(sops decrypt "$HOME/dotfiles/secrets/env.sops.env")
  set +a
fi


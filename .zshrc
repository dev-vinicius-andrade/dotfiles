stty -ixon

initialize_zsh_environment() {
  # CodeWhisperer pre block. Keep at the top of this file.
  [[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"

  # Path to your Oh My Zsh installation
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="robbyrussell"

  # Oh My Zsh Plugins (Optimized order: Shift-Select -> Suggestions -> Highlighting last)
  plugins=(
    fzf
    eza
    git
    dotnet
    docker
    docker-compose
    podman
    kubectl
    zoxide
   # zsh-shift-select
    zsh-autosuggestions
    zsh-syntax-highlighting
  )

  # Performance optimizations to eliminate typing delay
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
  export ZSH_HIGHLIGHT_MAXLENGTH=512
  export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

  # Source Oh My Zsh
  [[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

  # Resolve dotfiles path
  DOT_FILES_DIR="$(dirname "${(%):-%x}")"
  zshrc_real_path=$(realpath "${ZDOTDIR:-$HOME}/.zshrc")
  if [[ ! "$zshrc_real_path" == /nix/store/* ]]; then
    DOT_FILES_DIR=$(dirname "$zshrc_real_path")
  fi

  echo "DOT_FILES_DIR: $DOT_FILES_DIR"
  source "$DOT_FILES_DIR/scripts/zsh/utils.zsh"

  local args=("$@")
  local print_scripts_loaded="true"
  local clear_terminal_on_load="true"
  print_scripts_loaded=$(get_argument "${args[@]}" "--print-scripts-loaded" "true" "return_value")
  clear_terminal_on_load=$(get_argument "${args[@]}" "--clear-terminal-on-load" "true" "return_value")

  [[ -f $DOT_FILES_DIR/zsh/environment-variables.zsh ]] && source $DOT_FILES_DIR/zsh/environment-variables.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Environment Variables Loaded"
  [[ -f $SECRET_ENV_FILE ]] && source $SECRET_ENV_FILE && [[ $print_scripts_loaded == "true" ]] && echo "Secrets env file loaded"
  [[ -f $DOT_FILES_DIR/zsh/aliases.zsh ]] && source $DOT_FILES_DIR/zsh/aliases.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Aliases loaded"
  [[ -f $DOT_FILES_DIR/zsh/functions.zsh ]] && source $DOT_FILES_DIR/zsh/functions.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Functions loaded"
  #[[ -f $DOT_FILES_DIR/zsh/starship.zsh ]] && source $DOT_FILES_DIR/zsh/starship.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Starship loaded"
  [[ -f $DOT_FILES_DIR/zsh/nvm.zsh ]] && source $DOT_FILES_DIR/zsh/nvm.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Nvm loaded"
  [[ -f $DOT_FILES_DIR/zsh/keybinds.zsh ]] && source $DOT_FILES_DIR/zsh/keybinds.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Keybinds loaded"


  generate_nvim_mson_install_configuration

  # Load Direnv hook
  if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
  fi

  create_gcp_dir_if_not_exists
  create_microsoft_symbolic_link
  source_zsh_recursive "$DOT_FILES_DIR/zsh/functions"

  if [[ $clear_terminal_on_load == "true" ]]; then
    clear_terminal
  fi

  # CodeWhisperer post block. Keep at the bottom of this file.
  [[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"

  # Load Angular CLI autocompletion
  if [ -f /usr/local/lib/node_modules/@angular/cli/bin/ng ]; then
    source <(/usr/local/lib/node_modules/@angular/cli/bin/ng completion zsh)
  fi

  export LC_ALL=en_US.utf8
}

initialize_zsh_environment "$@"

# Yazi integration
if command -v yazi >/dev/null 2>&1; then
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
  }
fi

# Zoxide integration
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Auto-launch herdr (guarded against nested sessions, non-interactive shells, Zellij,
# and editor-integrated terminals like VS Code, which need a plain shell to hook into)
if [ -t 1 ] && [[ $- == *i* ]] && [ -z "$ZELLIJ" ] && [ -z "$HERDR_ACTIVE" ] \
   && [ "$TERM_PROGRAM" != "vscode" ] && [ -z "$VSCODE_INJECTION" ] \
   && command -v herdr >/dev/null 2>&1; then
  export HERDR_ACTIVE=1
  exec herdr
fi
#export STARSHIP_KEYMAP_SELECT=false
# Always load Starship after all plugins, ZLE widgets, and keymaps are bound
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

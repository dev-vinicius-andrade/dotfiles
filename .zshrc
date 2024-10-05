initialize_zsh_environment() {
  # CodeWhisperer pre block. Keep at the top of this file.
  [[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
  ZSH_THEME="robbyrussell"
  DOT_FILES_DIR="$(dirname "${(%):-%x}")"
  if [ -h "~/.zshrc" ]; then
    DOT_FILES_DIR="$(dirname $(realpath $(readlink ~/.zshrc)))"
  fi
  echo "DOT_FILES_DIR: $DOT_FILES_DIR"
  # if [ -n "${ZSH_VERSION}" ]; then
  #   DOT_FILES_DIR="$(dirname "${(%):-%x}")"
  # else
  #   DOT_FILES_DIR="$(dirname "$(readlink -f "$0")")"
  # fi
  source "$DOT_FILES_DIR/scripts/zsh/utils.zsh"
  local args=("$@")
  local print_scripts_loaded="true"
  local clear_terminal_on_load="true"
  print_scripts_loaded=$(get_argument "${args[@]}" "--print-scripts-loaded" "true", "return_value")
  clear_terminal_on_load=$(get_argument "${args[@]}" "--clear-terminal-on-load" "true" "return_value")

  [[ -f $DOT_FILES_DIR/zsh/environment-variables.zsh ]] && source $DOT_FILES_DIR/zsh/environment-variables.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Environment Variables Loaded"
  [[ -f $SECRET_ENV_FILE ]] && source $SECRET_ENV_FILE && [[ $print_scripts_loaded == "true" ]] && echo "Secrets env file loaded"
  [[ -f $DOT_FILES_DIR/zsh/aliases.zsh ]] && source $DOT_FILES_DIR/zsh/aliases.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Aliases loaded"
  [[ -f $DOT_FILES_DIR/zsh/functions.zsh ]] && source $DOT_FILES_DIR/zsh/functions.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Functions loaded"
  [[ -f $DOT_FILES_DIR/zsh/starship.zsh ]] && source $DOT_FILES_DIR/zsh/starship.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Starship loaded"
  [[ -f $DOT_FILES_DIR/zsh/nvm.zsh ]] && source $DOT_FILES_DIR/zsh/nvm.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Nvm loaded"

  generate_nvim_mson_install_configuration
  # Resolve the symlink of .zshrc to its absolute path
  zshrc_real_path=$(realpath "${ZDOTDIR:-$HOME}/.zshrc")
  # Extract the directory part from the path
  dotfiles_dir=$(dirname "$zshrc_real_path")

  # Export the DOTFILES_DIR environment variable
  export DOTFILES_DIR=$dotfiles_dir

  # Load Starship
  eval "$(starship init zsh)"

  # Load Direnv
  eval "$(direnv hook zsh)"

  create_gcp_dir_if_not_exists
  create_microsoft_symbolic_link
  source_zsh_recursive "$DOT_FILES_DIR/zsh/functions"
  # if print_scripts_loaded is true clear the terminal

  if [[ $clear_terminal_on_load == "true" ]]; then
    clear_terminal
  fi

  # CodeWhisperer post block. Keep at the bottom of this file.
  [[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"

  # Load Angular CLI autocompletion.
  if [ -f /usr/local/lib/node_modules/@angular/cli/bin/ng ]; then
    source <(/usr/local/lib/node_modules/@angular/cli/bin/ng completion zsh)
  fi
}
initialize_zsh_environment "$@"

initialize_zsh_environment() {
  # CodeWhisperer pre block. Keep at the top of this file.
  [[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
  ZSH_THEME="robbyrussell"
  DOT_FILES_DIR="$(dirname "$(readlink -f ~/.zshrc)")"
  source "$DOT_FILES_DIR/scripts/zsh/utils.zsh"
  local args=("$@")
  local print_scripts_loaded="true"
  local clear_terminal_on_load="true"
  # get_argument() {
  #   local args=("$@")
  #   local identifier="${args[-2]}"
  #   local default_value="${args[-1]}"
  #   local value_found=""

  #   # Check if the identifier is a number (digit only check)
  #   if [[ "$identifier" =~ ^-?[0-9]+$ ]]; then
  #     # Identifier is a number, treat as positional index
  #     local index=$((identifier - 1)) # Adjust for 0-based indexing in zsh arrays

  #     # Safe check for index bounds - ensure no spaces in arithmetic expressions
  #     if ((index >= 0 && index < ${#args} - 2)); then
  #       value_found="${args[index]}"
  #     fi
  #   else
  #     # Treat as a name of the argument
  #     local next=false
  #     for arg in "${args[1, -3]}"; do # Slicing to ignore the last two elements
  #       if [[ "$next" == true ]]; then
  #         value_found="$arg"
  #         break
  #       fi

  #       if [[ "$arg" == "$identifier" || "$arg" == "${identifier#-}" ]]; then
  #         next=true
  #       elif [[ "$arg" =~ ^${identifier#=}=(.*) ]]; then
  #         value_found="${match[1]}"
  #         break
  #       fi
  #     done
  #   fi

  #   if [[ -z "$value_found" ]]; then
  #     echo "$default_value"
  #   else
  #     echo "$value_found"
  #   fi
  # }
  print_scripts_loaded=$(get_argument "${args[@]}" "--print-scripts-loaded" "true", "return_value")
  clear_terminal_on_load=$(get_argument "${args[@]}" "--clear-terminal-on-load" "true" "return_value")
  print_line "Print scripts loaded: $print_scripts_loaded"
  print_line "Clear terminal on load: $clear_terminal_on_load"

  [[ -f $DOT_FILES_DIR/zsh/environment-variables.zsh ]] && source $DOT_FILES_DIR/zsh/environment-variables.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Environment Variables Loaded"
  [[ -f $SECRET_ENV_FILE ]] && source $SECRET_ENV_FILE && [[ $print_scripts_loaded == "true" ]] && echo "Secrets env file loaded"
  [[ -f $DOT_FILES_DIR/zsh/aliases.zsh ]] && source $DOT_FILES_DIR/zsh/aliases.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Aliases loaded"
  [[ -f $DOT_FILES_DIR/zsh/functions.zsh ]] && source $DOT_FILES_DIR/zsh/functions.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Functions loaded"
  [[ -f $DOT_FILES_DIR/zsh/starship.zsh ]] && source $DOT_FILES_DIR/zsh/starship.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Starship loaded"
  [[ -f $DOT_FILES_DIR/zsh/nvm.zsh ]] && source $DOT_FILES_DIR/zsh/nvm.zsh && [[ $print_scripts_loaded == "true" ]] && echo "Nvm loaded"
  # Resolve the symlink of .zshrc to its absolute path
  zshrc_real_path=$(realpath "${ZDOTDIR:-$HOME}/.zshrc")
  # Extract the directory part from the path
  dotfiles_dir=$(dirname "$zshrc_real_path")

  # Export the DOTFILES_DIR environment variable
  export DOTFILES_DIR=$dotfiles_dir

  # Verify the exported path
  echo "DOTFILES_DIR is set to: $DOTFILES_DIR"

  # Load Starship
  eval "$(starship init zsh)"

  # Load Direnv
  eval "$(direnv hook zsh)"

  create_gcp_dir_if_not_exists
  create_microsoft_symbolic_link
  source_zsh_recursive "$DOT_FILES_DIR/zsh/functions"
  # if print_scripts_loaded is true clear the terminal
  # [[ $clear_terminal_on_load == "true" ]] && clear_terminal

  # CodeWhisperer post block. Keep at the bottom of this file.
  [[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"

  # Load Angular CLI autocompletion.
  if [ -f /usr/local/lib/node_modules/@angular/cli/bin/ng ]; then
    source <(/usr/local/lib/node_modules/@angular/cli/bin/ng completion zsh)
  fi
}
initialize_zsh_environment "$@"
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

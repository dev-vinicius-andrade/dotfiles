# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
ZSH_THEME="robbyrussell"
DOT_FILES_DIR="$(dirname "$(readlink -f ~/.zshrc)")"
[[ -f $DOT_FILES_DIR/zsh/environment-variables.zsh ]] && source $DOT_FILES_DIR/zsh/environment-variables.zsh && echo "Environment Variables Loaded"
[[ -f $SECRET_ENV_FILE ]] && source $SECRET_ENV_FILE && echo "Secrets env file loaded"
[[ -f $DOT_FILES_DIR/zsh/aliases.zsh ]] && source $DOT_FILES_DIR/zsh/aliases.zsh && echo "Aliases loaded"
[[ -f $DOT_FILES_DIR/zsh/functions.zsh ]] && source $DOT_FILES_DIR/zsh/functions.zsh && echo "Functions loaded"
[[ -f $DOT_FILES_DIR/zsh/starship.zsh ]] && source $DOT_FILES_DIR/zsh/starship.zsh && echo "Starship loaded"
[[ -f $DOT_FILES_DIR/zsh/nvm.zsh ]] && source $DOT_FILES_DIR/zsh/nvm.zsh && echo "Nvm loaded"
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
clear_terminal

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"

# Load Angular CLI autocompletion.
if [ -f /usr/local/lib/node_modules/@angular/cli/bin/ng ]; then
  source <(/usr/local/lib/node_modules/@angular/cli/bin/ng completion zsh)
fi

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

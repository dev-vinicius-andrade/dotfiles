#! /bin/zsh

if [[ -f "$HOME/.zshrc" ]]; then
  source "$HOME/.zshrc"
  initialize_zsh_environment --sprint-scripts-loaded=false --clear-terminal-on-load=false
fi
local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "")
install_starship_if_not_exists() {
  source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
  install_package "starship" "$use_homebrew_flag"
  if [ ! -d "$HOME/.config/starship" ]; then
    mkdir -p "$HOME/.config/starship"
  fi
}
create_symbolic_links() {
  source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
  local skip="${1:---no-skip}"
  local dir="$DOTFILES_DIR"
  if [ "$skip" = "--skip" ]; then
    printf "\n Skipping starship symbolic links creation..."
    return 1
  fi
  local source_file_dir="$dir/starship"
  local target_file_dir="$HOME/.config/starship"
  create_symbolic_link "$source_file_dir/starship.toml" "$target_file_dir/starship.toml" "$skip"
}

install_starship_if_not_exists
if [[ "$1" = "--skip" ]]; then
  create_symbolic_links "--skip"
else
  create_symbolic_links
fi

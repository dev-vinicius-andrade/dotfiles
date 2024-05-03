#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
if [[ -f "$HOME/.zshrc" ]]; then
  source "$HOME/.zshrc"
  initialize_zsh_environment --sprint-scripts-loaded=false --clear-terminal-on-load=false
fi
install_alacrity_if_not_exists() {
  local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "")
  install_package "alacritty" "$use_homebrew_flag"
  local alacritty_dir="$HOME/.config/alacritty"
  if [ ! -d "$alacritty_dir" ]; then
    mkdir -p "$alacritty_dir"
  fi
}

create_alacritty_symbolic_link() {
  local skip="${1:---no-skip}"
  local dir="$DOTFILES_DIR"
  local file="$2"
  if [ "$skip" = "true" ]; then
    printf "\n Skipping alacritty symbolic links creation..."
    return 1
  fi
  local source_file="$dir/alacritty/$file"
  local target_file="$HOME/.config/alacritty/$file"
  create_symbolic_link "$source_file" "$target_file" "$skip"
}
create_alacritty_symbolic_links() {
  local skip="${1:---no-skip}"
  local dir="$2"

  printf "\n----------------------------------------------\n"
  printf "\nCreating alacritty symbolic links..."
  create_alacritty_symbolic_link "$skip" "alacritty.toml"
  create_alacritty_symbolic_link "$skip" "themes"

  printf "\n----------------------------------------------\n"
}
local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "")
print_line "Allacritty using homebrew: $use_homebrew_flag"
return
install_alacrity_if_not_exists "$@"
create_alacritty_symbolic_links "$1"

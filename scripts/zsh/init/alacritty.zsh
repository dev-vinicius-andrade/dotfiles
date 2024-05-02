#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
install_alacrity_if_not_exists() {
  install_package "alacritty" 
  local alacritty_dir="$HOME/.config/alacritty"
  if [ ! -d "$alacritty_dir" ]; then
    mkdir -p "$alacritty_dir"
  fi
}

create_alacritty_symbolic_link(){
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
create_alacritty_symbolic_links(){
  local skip="${1:---no-skip}"
  local dir="$2"

  printf "\n----------------------------------------------\n"
  printf "\nCreating alacritty symbolic links..."
  create_alacritty_symbolic_link "$skip" "alacritty.toml"
  create_alacritty_symbolic_link "$skip" "themes"

  printf "\n----------------------------------------------\n"
}

install_alacrity_if_not_exists
create_alacritty_symbolic_links "$1"

#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
install_tmux_if_not_exists() {
  if ! command -v tmux &> /dev/null; then
    source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
    local os=$(uname -s)
    printf "\n tmux not found, installing..."
    install_package "tmux"
    if [ "$os" = "Darwin" ]; then
      install_package "tpm"
      install_package "reattach-to-user-namespace"
    elif [ "$os" = "Linux" ]; then
      install_package "xclip"
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
  else
    printf "\n tmux already installed, skipping..."
  fi
}
create_tmux_config_extra_symbolic_link(){
  local skip="$1"
  local file_name="$2"
  local dir="$DOTFILES_DIR"
  print_section_start "Tmux extras symbolic link"
  local source_file="$dir/tmux/config/extras/$file_name"
  local target_file="$HOME/.config/tmux/$file_name"
  create_symbolic_link "$source_file" "$target_file" "$skip"
  print_section_end
}
create_tmux_config_extras(){
  local skip="$1"
  local dir="$DOTFILES_DIR"
  print_section_start "Tmux config extras"
  if [ ! -d "$HOME/.config/tmux" ]; then
    mkdir -p "$HOME/.config/tmux"
  fi

  create_tmux_config_extra_symbolic_link "$skip" "tmux-nerd-font-window-name.yml"
  print_section_end
}
create_tmux_config_symbolic_link() {
  local skip="$1"
  local dir="$2"

  print_section_start "Tmux config"
  local source_file="$dir/tmux/.tmux.conf"
  local target_file="$HOME/.tmux.conf"
  create_symbolic_link "$source_file" "$target_file" "$skip"
  print_section_end
}
install_tmux_if_not_exists
create_tmux_config_symbolic_link "$1"
create_tmux_config_extras "$1"

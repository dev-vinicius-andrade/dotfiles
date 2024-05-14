#! /bin/zsh
if [[ -f "$HOME/.zshrc" ]]; then
  source "$HOME/.zshrc"
  initialize_zsh_environment --sprint-scripts-loaded=false --clear-terminal-on-load=false
fi
local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "")
print_line "Nvim using homebrew: $use_homebrew_flag"
install_packages() {
  source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
  install_package "neovim" "$use_homebrew_flag"
  install_package "ripgrep" "$use_homebrew_flag"
  install_package "delve" "$use_homebrew_flag"
}
create_neovim_symbolic_links() {
  source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
  local skip="${1:---no-skip}"
  print_section_start "Neovim symbolic links"
  if [ ! -d ~/.config/nvim ]; then
    printf "Creating ~/.config/nvim directory..."
    mkdir -p ~/.config/nvim
  else
    printf "~/.config/nvim"

  fi
  local nvim_source_dir="$DOTFILES_DIR/nvim"
  local nvim_target_dir="$HOME/.config/nvim"
  create_symbolic_link "$nvim_source_dir/init.lua" "$nvim_target_dir/init.lua" "$skip"
  create_symbolic_link "$nvim_source_dir/lua" "$nvim_target_dir/lua" "$skip"
  create_symbolic_link "$nvim_source_dir/lazy-lock.json" "$nvim_target_dir/lazy-lock.json" "$skip"
  print_section_end
}

if [[ "$1" = "--skip" ]]; then
  install_packages "--skip"
  create_neovim_symbolic_links "--skip"
else
  install_packages
  create_neovim_symbolic_links
fi

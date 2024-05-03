#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "")
if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
    initialize_zsh_environment --sprint-scripts-loaded=false --clear-terminal-on-load=false
fi
install_packages() {
    print_section_start "Node"
    print_section_description "Check and install node and npm"
    install_package "nodejs" "$use_homebrew_flag"
    install_package "npm" "$use_homebrew_flag"
    sudo npm install -g n
}
print_line "NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOODEEEEEEEEEEEEEEEEEEE______________________________________________"
install_packages

#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
install_packages() {
    print_section_start "Node"
    print_section_description "Check and install node and npm"
    install_package "nodejs"
    install_package "npm"
    sudo npm install -g n
}
install_packages

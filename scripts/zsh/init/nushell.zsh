#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
    initialize_zsh_environment --sprint-scripts-loaded=false --clear-terminal-on-load=false
fi
local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "")
print_line "Nushell using homebrew: $use_homebrew_flag"
install_packages() {
    print_section_start "Nushell"
    print_section_description "Check and install nushell"
    install_package "nushell" "$use_homebrew_flag"
    print_section_end
}
create_symbolic_links() {
    local skip="${1:---no-skip}"
    print_section_start "Nushell symbolic links"
    local nushell_dir="$HOME/.config/nushell"
    if [ ! -d "$nushell_dir" ]; then
        mkdir -p "$HOME/.config/nushell"
    fi
    local nushell_source_dir="$DOTFILES_DIR/nushell"
    local nushell_target_dir="$HOME/.config/nushell"
    create_symbolic_link "$nushell_source_dir/config.nu" "$nushell_target_dir/config.nu" "$skip"
    create_symbolic_link "$nushell_source_dir/env.nu" "$nushell_target_dir/env.nu" "$skip"
    print_section_end
}

install_packages
if [[ "$1" = "--skip" ]]; then
    create_symbolic_links "--skip"
else
    create_symbolic_links
fi

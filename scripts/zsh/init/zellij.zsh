#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
    initialize_zsh_environment --sprint-scripts-loaded=false --clear-terminal-on-load=false
fi
local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" ""),
print_line "Zellij using homebrew: $use_homebrew_flag"
run() {

    local zellij_versions_dir="$HOME/.zellij/versions"
    create_zellij_versions_folder() {
        if [ ! -d "$zellij_versions_dir" ]; then
            mkdir -p "$zellij_versions_dir"
        fi
    }

    setup() {
        local skip="${1:---no-skip}"
        # if skip=--skip, then skip the installation of the package
        if [[ "$skip" = "--skip" ]]; then
            print_line "Skipping zellij installation..."
            return
        fi
        if is_installed "zellij"; then
            print_line "zellij is already installed"
            return
        fi
        install_package "zellij" "$use_homebrew_flag"
    }
    print_section_start "Zellij"
    if [[ "$1" = "--skip" ]]; then
        setup "--skip"
    else
        setup "--no-skip"
    fi
    print_section_end "Zellij"
}

run "$@"

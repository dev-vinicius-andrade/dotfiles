#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
source "$DOTFILES_DIR/scripts/zsh/package_installer.zsh"
check_if_symbolic_link_or_file_exists_ask_if_override() {
    local skip="${1:---no-skip}"
    local source_file="$DOTFILES_DIR/$2"
    local target_file="$HOME/$2"
    if [[ "$skip" = "--skip" ]]; then
        printf "\nSkip flag set, skipping creation of zsh symbolic links...\n"
        return 1
    fi
    create_symbolic_link "$source_file" "$target_file" "$skip"
    return 0
}

zsh_create_symbolic_links() {
    print_section_start "Zsh symbolic links"
    local skip="${1:---no-skip}"
    if [[ "$skip" = "--skip" ]]; then
        printf "\nSkip flag set, skipping creation of zsh symbolic links...\n"
        return 1
    fi
    check_if_symbolic_link_or_file_exists_ask_if_override "$skip" ".zshenv"
    check_if_symbolic_link_or_file_exists_ask_if_override "$skip" ".zshrc"

    print_section_end
}

run() {
    zsh_create_symbolic_links $1
}

if [[ "$1" = "--skip" ]]; then
    run "--skip"
else
    run
fi

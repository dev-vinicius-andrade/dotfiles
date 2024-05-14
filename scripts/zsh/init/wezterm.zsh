#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
    initialize_zsh_environment --sprint-scripts-loaded=false --clear-terminal-on-load=false
fi
local use_homebrew_flag=$(get_argument "$@" "--use-homebrew" "")
print_line "Wezterm using homebrew: $use_homebrew_flag"
# create_wezterm_config_directory() {
#     read is_wsl host_home < <(get_host_environment_information)
#     local wezterm_config_dir="$host_home/.config/wezterm"
#     if [ ! -d "$wezterm_config_dir" ]; then
#         printf "Creating $wezterm_config_dir directory..."
#         mkdir -p "$wezterm_config_dir"
#     else
#         printf "$wezterm_config_dir already exists, skipping..."
#     fi
# }

create_wezterm_lua_file_symbolic_link() {
    local skip="${1:---no-skip}"
    read is_wsl host_home < <(get_host_environment_information)
    local wezterm_lua_file="$host_home/.wezterm.lua"
    if [ ! -f "$wezterm_lua_file" ]; then
        printf "Creating $wezterm_lua_file file..."
        create_symbolic_link "$DOTFILES_DIR/wezterm/wezterm.lua" "$wezterm_lua_file" "$skip"
    else
        printf "$wezterm_lua_file already exists, skipping..."
    fi
}
create_wezterm_lua_config_files_dir_symbolic_link() {
    local skip="${1:---no-skip}"
    read is_wsl host_home < <(get_host_environment_information)
    local wezterm_lua_config_files_source_dir="$DOTFILES_DIR/wezterm/config"
    local wezterm_lua_config_files_target_dir="$host_home/.config/wezterm"
    create_symbolic_link "$wezterm_lua_config_files_source_dir" "$wezterm_lua_config_files_target_dir" "$skip"
}
setup() {
    return 0
    local skip="${1:---no-skip}"
    print_section_start "Wezterm configuration"
    create_wezterm_lua_file_symbolic_link "$skip"
    create_wezterm_lua_config_files_dir_symbolic_link "$skip"
}

return
if [[ "$1" = "--skip" ]]; then
    setup "--skip"
else
    setup
fi

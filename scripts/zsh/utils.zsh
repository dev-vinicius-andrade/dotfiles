#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/spinning_progress_bar.zsh"
get_host_environment_information() {
    local is_wsl="false"
    local host_home="$HOME"

    if grep -qi 'microsoft\|wsl' /proc/version; then
        is_wsl="true"
        host_home=$(wslpath $(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null) | tr -d '\r')
    fi

    echo "$is_wsl $host_home"
}
print_section_start() {
    local section_name="$1"
    local total_length="${2:-40}" # Default length is 40 if not provided
    local name_length=${#section_name}
    local dash_length=$(((total_length - name_length - 2) / 2))
    local dashes=$(printf '%*s' "$dash_length" | tr ' ' '-')

    echo "\n$dashes $section_name $dashes"
    # If the total length is odd and name length is even (or vice versa), add an extra dash to balance
    [[ $(((name_length + 2 + 2 * dash_length) % 2)) -ne 0 ]] && echo -n "-"
    echo
}

print_section_description() {
    local description="$1"
    echo "$description"
}
print_section_line() {
    local message="$1"
    echo "\n$message"
}
print_line() {
    local message="$1"
    echo "$message" >&2
}

print_section_end() {
    local section_name="$1"
    local total_length="${2:-40}" # Default length is 40 if not provided
    local name_length=${#section_name}
    local dash_length=$(((total_length - name_length - 2) / 2))
    local dashes=$(printf '%*s' "$dash_length" | tr ' ' '-')

    echo "$dashes $section_name $dashes"
    [[ $(((name_length + 2 + 2 * dash_length) % 2)) -ne 0 ]] && echo -n "-"
    echo
}

create_symbolic_link() {
    local source="$1"
    local target="$2"
    local skip="$3"
    if [ -L "$target" ]; then
        if [ "$skip" = "--skip" ]; then
            printf "\n [-] Skipping creation of symbolic link... [-]"
            return 1
        fi
        printf "\n$target already exists..."
        printf "\nDo you want to override it? [y/n]: [n] "
        read -r answer
        if [ "$answer" = "y" ]; then
            ln -sfnv "$source" "$target"
        else
            printf "\nSkipping creation of symbolic link $1...\n"
            return 1
        fi
    else
        ln -sfnv "$source" "$target"
    fi
}
create_windows_wsl_symbolic_link() {
    read is_wsl host_home < <(get_host_environment_information)
    if [ "$is_wsl" = "false" ]; then
        printf "\nThis script is only for WSL environment...\n"
        return 1
    fi

    local source="$1"
    local target="$2"
    local skip="${3:---no-skip}"
    printf "\nSource: %s\n" "$source"
    printf "\nTarget: %s\n" "$target"

    # Determine if the source is a directory or not
    local link_type=""
    if [ -d "$source" ]; then
        link_type="/D " # Space at the end is important for command formation
    fi

    # Check if target already exists
    if [ -e "$target" ]; then
        if [ "$skip" = "--skip" ]; then
            printf "\n [-] Skipping creation of symbolic link due to --skip flag... [-]\n"
            return 1
        fi

        printf "\n$target already exists..."
        printf "\nDo you want to override it? [y/n]: [n] "
        read -r answer
        if [[ "$answer" != "y" ]]; then
            printf "\nSkipping creation of symbolic link $target...\n"
            return 1
        fi
    fi

    # Properly normalize the source path
    local normalized_source_path=$(convert_path_to_windows_style "$(wslpath -m "$source")")

    local command="mklink $link_type\"$target\" \"$normalized_source_path\""
    echo "\nCommand: \"$command\""
    echo "\n"

    # Uncomment to actually execute
    # sudo cmd.exe /C "$command"
    if [ $? -eq 0 ]; then
        printf "\nSymbolic link created successfully.\n"
    else
        printf "\nFailed to create symbolic link.\n"
        return 1
    fi
}

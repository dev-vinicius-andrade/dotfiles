#! /bin/zsh
command_exists() {
    command -v "$1" &>/dev/null
}
is_distro() {
    local distro="$1"
    local current_distro=$(get_distro)
    if [ "$current_distro" = "$distro" ]; then
        return 0
    fi
    return 1
}
get_distro() {
    local distro=""
    ## get using lsb_release
    if command -v lsb_release &>/dev/null; then
        distro=$(lsb_release -si)
    else
        ## get using /etc/os-release
        if [ -f /etc/os-release ]; then
            distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
        else
            ## get using /etc/issue
            if [ -f /etc/issue ]; then
                distro=$(cat /etc/issue | cut -d " " -f 1)
            fi
        fi
    fi
    echo "$distro"
}
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
# 
# Function to fetch an argument's value, return the argument itself, or check for its existence
get_argument() {
    # Adjust the way to fetch parameters to leave space for an optional one
    local default_value="${@: -1}"          # Always the last
    local identifier="${@: -2:1}"           # Second to last
    local args=("${@:1:$#-2}")              # All arguments except the last two

    # Return type is optionally the third from the end, default to 'return_flag_name' if not specified
    local return_type="${@[-3]}"
    if [[ "$return_type" != "return_flag_name" && "$return_type" != "return_boolean" && "$return_type" != "return_value" ]]; then
        # If the third from the last is not a valid return type, consider it as part of args
        return_type="return_flag_name"
        args=("${@:1:$#-2}")  # Include what was assumed to be return_type in args
        identifier="${@: -2:1}" # Adjust identifier
        default_value="${@: -1:1}" # Adjust default_value
    fi

    local value_found=""
    local is_flag_present=false

    # Handle positional index requests
    if [[ "$identifier" =~ ^-?[0-9]+$ ]]; then
        local index=$((identifier))
        if ((index > 0 && index <= ${#args[@]})); then
            value_found="${args[index]}"
            ((index < ${#args[@]} && "${args[index+1]}" != -*)) && value_found="${args[index+1]}"
        fi
    else
        # Parse arguments looking for flags or key=value pairs
        local next_is_value=false
        for arg in "${args[@]}"; do
            if $next_is_value; then
                value_found="$arg"
                break
            fi

            if [[ "$arg" == "$identifier" ]]; then
                is_flag_present=true
                next_is_value=true
                [[ "$return_type" == "return_boolean" ]] && break
            elif [[ "$arg" == "$identifier="* ]]; then
                value_found="${arg#*=}"
                is_flag_present=true
                break
            fi
        done
    fi

    # Handle return types based on what was found
    case "$return_type" in
        "return_flag_name")
            [[ "$is_flag_present" == true ]] && echo "$identifier" || echo "$default_value"
            ;;
        "return_boolean")
            [[ "$is_flag_present" == true ]] && echo "true" || echo "false"
            ;;
        "return_value")
            [[ -n "$value_found" ]] && echo "$value_found" || echo "$default_value"
            ;;
        *)
            echo "Error: Invalid return type specified."
            return 1
            ;;
    esac
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

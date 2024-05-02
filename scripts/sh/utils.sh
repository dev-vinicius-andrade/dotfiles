#! /bin/bash
NO_COLOR='\033[0m' # No Color
hex_to_ansi() {
    local hex_color=$(get_argument "$@" "1" "$NO_COLOR")
    # if hex_color starts with #, remove it
    hex_color="${hex_color#\#}"

    # Check if hex_color is valid and not empty
    if [[ -z "$hex_color" || "$hex_color" == "$NO_COLOR" ]]; then
        echo "$NO_COLOR"
        return
    fi

    # Normalize hex_color by removing a leading '#'
    hex_color="${hex_color#\#}"

    # Validate hex color length
    if [[ ${#hex_color} -ne 6 ]]; then
        echo "$NO_COLOR"
        return
    fi

    # Split into color components
    local r_hex="${hex_color:0:2}"
    local g_hex="${hex_color:2:2}"
    local b_hex="${hex_color:4:2}"

    # Convert hex to decimal, catching errors in conversion
    local r_dec g_dec b_dec
    if ! r_dec=$((16#$r_hex)) || ! g_dec=$((16#$g_hex)) || ! b_dec=$((16#$b_hex)); then
        echo "$NO_COLOR"
        return
    fi

    # Construct the ANSI escape sequence for 24-bit color
    echo -e "\033[38;2;${r_dec};${g_dec};${b_dec}m"
}

terminal_suports_truecolor() {
    if [ -n "$COLORTERM" ] && [ "$COLORTERM" = "truecolor" ]; then
        return 0
    elif [ -n "$TERM" ] && [ "$TERM" = "xterm-256color" ]; then
        return 0
    # Check if the terminal supports 24-bit color
    elif [ -n "$TERM" ] && [ "$TERM" = "xterm-24bit" ]; then
        return 0
    # check if tput colors is 256
    elif [ "$(tput colors)" -eq 256 ]; then
        return 0
    fi
    return 1
}
print_text() {
    local args=("$@")
    local message=$(get_argument "$args" "1" "")
    local color=$(get_argument "$@" "2" "$NO_COLOR") # Default to $NO_COLOR if no color is provided
    local destination=$(get_argument "$@" 3 "1")     # Default to standard output (1), use 2 for stderr, or any specific path
    if terminal_suports_truecolor; then
        color=$(hex_to_ansi "$color")
    else
        color="$NO_COLOR"
    fi
    # Determine how to redirect the output based on the destination
    if [[ "$destination" == "1" ]]; then
        echo -e "${color}${message}${NO_COLOR}"
    elif [[ "$destination" == "2" ]]; then
        echo -e "${color}${message}${NO_COLOR}" >&2
    else
        echo -e "${color}${message}${NO_COLOR}" >"$destination"
    fi
}
print_empty_line() {
    local destination=$(get_argument "$@" 1 "1") # Default to standard output (1), use 2 for stderr, or any specific path
    print_text "" "$NO_COLOR" "$destination"
}
print_empty_lines() {
    local args=("$@")
    local number_of_lines=$(get_argument "$args" "1" "1")
    local destination=$(get_argument "$args" 2 "1") # Default to standard output (1), use 2 for stderr, or any specific path
    for ((i = 0; i < number_of_lines; i++)); do
        print_empty_line "$destination"
    done
}
print_line() {
    local args=("$@")
    local message=$(get_argument "$args" "1" "")
    local color=$(get_argument "$@" "2" "$NO_COLOR") # Default to $NO_COLOR if no color is provided
    local destination=$(get_argument "$@" 3 "1")     # Default to standard output (1), use 2 for stderr, or any specific path
    print_text "$message" "$color" "$destination"
}
print_section() {
    local args=("$@")
    local section_name=$(get_argument "$@" "1" "")
    local color=$(get_argument "$@" "2" "$NO_COLOR") # Default to $NO_COLOR if no color is provided
    local total_length=$(get_argument "$@" "3" "40") # Default length is 40 if not provided
    local name_length=${#section_name}
    local dash_length=$(((total_length - name_length - 2) / 2))
    local dashes=$(printf '%*s' "$dash_length" | tr ' ' '-')

    print_empty_line
    echo -n "$dashes $section_name $dashes"
    print_empty_line
    # Check if the total line length is odd, if yes, print one additional dash to balance
    [[ $(((name_length + 2 + 2 * dash_length) % 2)) -ne 0 ]] && echo -n "-"
    print_empty_line
}
get_argument() {
    local args=("$@")
    local identifier="${args[-2]}"
    local default_value="${args[-1]}"
    local value_found=""

    # Check if the identifier is a number (digit only check)
    if [[ "$identifier" =~ ^-?[0-9]+$ ]]; then
        # Identifier is a number, treat as positional index
        local index=$((identifier - 1)) # Adjust for 0-based indexing in bash arrays

        # Safe check for index bounds - ensure no spaces in arithmetic expressions
        if [[ $index -ge 0 ]] && [[ $index -lt $((${#args[@]} - 2)) ]]; then
            value_found="${args[$index]}"
        fi
    else
        # Treat as a name of the argument
        local next=false
        for arg in "${args[@]:0:${#args[@]}-2}"; do
            if [[ "$next" == true ]]; then
                value_found="$arg"
                break
            fi

            if [[ "$arg" == "$identifier" || "$arg" == "${identifier#-}" ]]; then
                next=true
            elif [[ "$arg" =~ ^${identifier#=}=(.*)$ ]]; then
                value_found="${BASH_REMATCH[1]}"
                break
            fi
        done
    fi

    if [[ -z "$value_found" ]]; then
        echo "$default_value"
    else
        echo "$value_found"
    fi
}

get_argument_values() {
    local args=("$@")
    local name_of_argument="${args[-1]}"
    local values=()
    local collect_next=false

    for arg in "${args[@]:0:${#args[@]}-1}"; do
        if [[ "$collect_next" == true ]]; then
            values+=("$arg")
            collect_next=false
            continue
        fi

        if [[ "$arg" == "$name_of_argument" || "$arg" == "${name_of_argument#-}" ]]; then
            collect_next=true
        elif [[ "$arg" =~ ^${name_of_argument#=}=(.*) ]]; then
            values+=("${BASH_REMATCH[1]}")
        fi
    done

    printf '%s\n' "${values[@]}"
}

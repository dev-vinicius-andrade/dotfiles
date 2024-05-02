#! /bin/zsh
# optional parameters:
# $1 - current step
# $2 - total steps
report_progress() {
    local current_step="${1:-}"
    local total="${2:-}"
    local message="${3:-}"
    local completestr='⠿'
    local spinstr=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏' '⠿')
    local spin_count=0
    if [[ "$current_step" -eq "$total" ]]; then
        printf "\e[2K\r%s - %s - [100%%]\n" "$completestr" "$message"
        return
    fi
    local percent=0
    if [[ -n "$total" && "$total" -ne 0 ]]; then
        percent=$((current_step * 100 / total))
    fi
    local spin_index=$((current_step % ${#spinstr[@]}))
    printf "\e[2K\r%s - %s - [%d%%]\r" "${spinstr[spin_index]}" "$message" "$percent"
}
end_progress(){
    echo -en "\n"
}
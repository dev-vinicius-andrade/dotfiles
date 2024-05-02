#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
declare -A script_priorities=()
add_script_to_priorities() {
    local script="$1"
    local priority="$2"
    # check if is there a script with the same priority
    for key in "${(@k)script_priorities}"; do
        if [[ "${script_priorities[$key]}" = "$priority" ]]; then
            print_line "There is already a script with the same priority, skipping..."
            return 1
        fi
    done
    script_priorities["$script"]="$priority"
}
run() {
    local init_scripts_dir="$1"
    declare -A scripts=()
    declare -A skiped_scripts=()
    declare -A specific_scripts=()
    local global_skip_flag="--no-skip"
    local run_all_scripts_flag="false"
    local skip_flatpak="N" # Assume N as default skip unless specified
    local skip_snap="N"    # Assume Y as default skip unless specified
    load_scripts() {
        print_line "Loading scripts..."
        for script in $init_scripts_dir/*.zsh; do
            scripts[${script:t:r}]=1
        done
        print_line "Scripts loaded..."
    }
    script_exists_and_is_executable() {
        local script_path="$1"
         if [[ ! -f "$script_path" || ! -x "$script_path" ]]; then
            print_line "Script $script_path does not exist or is not executable, skipping..."
            return 1
        fi
        return 0
    }
    run_script() {
        local script="$1"
        local skip_flag="${2:-$global_skip_flag}"
        local current_script="${3}"
        local total_scripts="${4}"
        local script_path="$init_scripts_dir/$script.zsh"
        if ! script_exists_and_is_executable "$script_path" ; then
            return
        fi

        # Check if the script exists and is executable, else print that the script does not exist and return
        if [[ ! -f "$script_path" || ! -x "$script_path" ]]; then
            print_line "Script $script_path does not exist or is not executable, skipping..."
            return
        fi
        report_progress "$current_script" "$total_scripts" "Running script $script_path with skip flag $skip_flag..."
        if [[ "$script" = "app" ]]; then
            print_line "Running app script with skip_flatpak:$skip_flatpak skip_snap:$skip_snap ..."
            "$script_path" "$skip_flag" "$skip_flatpak" "$skip_snap"
        else
            "$script_path" "$skip_flag"
        fi
        
    }
    init_run_all_scripts_flag() {
        if ((${#@} == 0)); then
            run_all_scripts_flag="true"
        fi
    }
    init_global_skip_flag() {
        global_skip_flag="--no-skip"
        for arg in "$@"; do
            if [[ "$arg" = "--skip" ]]; then
                global_skip_flag="--skip"
            fi
        done
    }
    set_run_all_scripts_flag_from_arg() {
        local arg="$1"
        run_all_scripts_flag="$arg"
    }
    set_global_skip_flag_from_arg() {
        local arg="$1"
        global_skip_flag="${arg:---no-skip}"
    }
    set_skiped_script_from_arg() {
        local arg="$1"
        local script_name="${arg#--skip-}"
        if [[ -n "${scripts[$script_name]}" ]]; then
            skiped_scripts[$script_name]=1
        fi

    }
    handle_extra_arg() {
        local arg="$1"
        if [[ "$arg" =~ ^--([a-zA-Z0-9_]+)$ ]]; then
            local script_name="${arg#--}"
            if [[ -n "${scripts[$script_name]}" ]]; then
                specific_scripts[$script_name]=1
            fi
        fi

    }
    parse_args() {
        local -a pos_args
        for arg in "$@"; do
            case "$arg" in
            --run-all)
                set_run_all_scripts_flag_from_arg "true"
                ;;
            --skip)
                set_global_skip_flag_from_arg --skip
                ;;
            --skip-snap)
                 skip_snap="Y"
                ;;
            --skip-flatpak)
                skip_flatpak="Y"
                ;;
            --skip-*)
                set_skiped_script_from_arg "$arg"
                ;;
            *)
                handle_extra_arg "$arg"
                pos_args+=("$arg")
                ;;
            esac
        done
    }
    has_specific_scripts() {
        ((${#specific_scripts[@]} > 0))
    }
    run_specific_scripts() {
        local specific_scripts_count="${#specific_scripts[@]}"
        local current_script=1
        for script in $init_scripts_dir/*.zsh; do
            local base_name="${script:t:r}" # Remove directory and extension
            if [[ -n "${specific_scripts[$base_name]}" ]]; then
                run_script "$base_name" "$global_skip_flag" "$current_script" "$specific_scripts_count"
                ((current_script++))
                sleep 0.25
            fi
            
        done
    }
   sort_script_priorities() {
        typeset -a sorted
        sorted=()
        # sort by value ascending
        for k v in "${(@kv)script_priorities}"; do
            sorted+=("$v:$k")
        done
        sorted=("${(@on)sorted}")
        script_priorities=()
        local current_script=1
        local total_scripts="${#sorted[@]}"
        for entry in "${sorted[@]}"; do
            local priority=${entry%%:*}
            local script=${entry#*:}
            script="${script//\"/}"
            report_progress "$current_script" "$total_scripts" "Adding script $script with priority $priority..."
            add_script_to_priorities $script $priority
            ((current_script++))
            sleep 0.1
        done
        print_line "Scripts priority sorted..."
    }
    has_priorities() {
        ((${#script_priorities[@]} > 0))
    }
    reorder_scripts() {
        print_line "Starting reorder..."
   
        sort_script_priorities
        declare -A sorted_scripts=()
        sorted_scripts_count=0
        for script in ${(@k)script_priorities}; do
            sorted_scripts[$script]="$script_priorities[$script]"
            ((sorted_scripts_count++))
        done
        local next_priority=$((sorted_scripts_count +1))
        for script in "${(@k)scripts}"; do
            if ! is_in_script_priorities "$script"; then
                sorted_scripts[$script]=$next_priority
                next_priority=$((next_priority + 1))
            fi
        done
        scripts=()
        for script priority in "${(@kv)sorted_scripts}"; do
            script="${script//\"/}"
            scripts[$script]=$priority
        done
        print_line "Finished reorder..."
    }
    is_in_script_priorities() {
        local script="$1"
        local exists=1
        script="${script//\"/}"  # Ensure no quotes

        for key in "${(@k)script_priorities}"; do
            local clean_key="${key//\"/}"
            if [[ "$clean_key" = "$script" ]]; then
                exists=0
                break
            fi
        done
        return $exists
    }
    get_skip_flag(){
        local script="$1"
        script="${script//\"/}"
        local skip_flag="$global_skip_flag"
        if [[ -n "${skiped_scripts[$script]}" ]]; then
            skip_flag="--skip"
        fi

    }
    run_scripts() {
        print_section_start "Running scripts"
        print_line "Total scripts: ${#scripts[@]}"
        local total_scripts="${#scripts[@]}"
        local current_script=1
        while [[ "$current_script" -le "$total_scripts" ]]; do
            for script priority in "${(@kv)scripts}"; do
                script="${script//\"/}"
                if [[ "$priority" -ne "$current_script" ]]; then
                    continue
                fi
                local skip_flag=$(get_skip_flag "$script")
                run_script "$script" "$skip_flag" "$current_script" "$total_scripts"
                ((current_script++))
                sleep 0.1
            done
        done
        print_section_end "Running scripts"
    }
    process() {
        shift # remove the first argument which is the init_scripts_dir
        load_scripts
        parse_args "$@"
        if has_specific_scripts; then
            run_specific_scripts
            print_line "Finished setup ..."
            return
        fi
        
        if has_priorities; then
            reorder_scripts
        fi
        run_scripts
    }
    process "$@"
}

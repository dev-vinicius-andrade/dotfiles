#! /bin/bash
export DOTFILES_DIR="$(
    cd "$(dirname "$0")" || exit
    pwd
)"
scripts_dir="$DOTFILES_DIR/scripts"
sh_scripts_dir="$scripts_dir/sh"
zsh_scripts_dir="$scripts_dir/zsh"
echo "sh_scripts_dir: $sh_scripts_dir"
source "$sh_scripts_dir/utils.sh"
init() {
    local default_packages="openssh exa git direnv neofetch"

    local init_zsh_script="$zsh_scripts_dir/init.zsh"
    local os=$(uname -s)
    local aditional_args=""
    local aditional_packages=""
    local accept_flag=""
    local skip_package_installation="false"
    local skip_update="false"

    update_package_manager() {
        if [ "$skip_update" = "true" ]; then
            print_line "Skipping package manager update..."
            return
        fi
        if [ "$os" = "Darwin" ]; then
            yes | brew update
        elif [ "$os" = "Linux" ]; then
            if [ -f /etc/debian_version ]; then
                sudo apt update "$accept_flag"
            elif [ -f /etc/arch-release ]; then
                local pacman_accept_flag=""
                if has_accept_flag; then
                    pacman_accept_flag="--noconfirm"
                fi
                sudo pacman -Syu "$pacman_accept_flag"
            else
                print_line "Unsupported Linux distribution"
                exit 1
            fi
        else
            print_line "Unsupported OS: $os"
            exit 1
        fi
    }
    install_package() {
        local package="$1"
        shift
        if [ "$os" = "Darwin" ]; then
            local brew_accept_flag=""
            if has_accept_flag; then
                yes | brew install "$package"
            else
                brew install "$package"
            fi
        elif [ "$os" = "Linux" ]; then
            if [ -f /etc/debian_version ]; then
                sudo apt install "$accept_flag $package"
            elif [ -f /etc/arch-release ]; then
                local pacman_accept_flag=""
                if has_accept_flag; then
                    pacman_accept_flag="--noconfirm"
                fi
                sudo pacman -S "$package" "$pacman_accept_flag"
            else
                print_line "Unsupported Linux distribution"
                exit 1
            fi
        else
            print_line "Unsupported OS: $os"
            exit 1
        fi
    }
    has_accept_flag() {
        if [ "$accept_flag" = "-y" ]; then
            return 0
        elif [ "$accept_flag" = "--yes" ]; then
            return 0
        elif [ "$accept_flag" = "-Y" ]; then
            return 0
        else
            return 1
        fi
    }
    install_brew_if_needed() {
        if [ ! "$os" = "Darwin" ]; then
            return
        fi
        if ! command_exists brew; then
            print_line "brew is not installed"
            if ! has_accept_flag; then
                print_line "Do you want to install it? [y/n]: [y]"
                read -r answer
                if [ "$answer" = "n" ]; then
                    print_line "Skipping brew installation..."
                    return
                fi
            fi

            print_line "Installing brew..."
            sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    }
    command_exists() {
        command -v "$1" >/dev/null 2>&1
    }
    install_zsh_if_needed() {
        if [ "$skip_package_installation" = "true" ]; then
            print_line "Skipping zsh installation..."
            return
        fi
        if ! command_exists zsh; then
            print_line "zsh is not installed"
            if ! has_accept_flag; then
                print_line "Do you want to install it? [y/n]: [y]"
                read -r answer
                if [ "$answer" = "n" ]; then
                    print_line "Skipping zsh installation..."
                    return
                fi
            fi
            print_line "Installing zsh..."
            if [ "$os" = "Darwin" ]; then
                install_brew_if_needed
            fi
            install_package zsh
            set_zsh_as_default_shell
        fi
    }
    parse_args() {
        local args="$@"
        local next_is_value=0
        for arg in "$@"; do
            case "$arg" in
            --help | -h)
                help
                exit 0
                ;;
            --skip_package_installation | -spi)
                skip_package_installation="true"
                ;;
            --skip_update | -su)
                skip_update="true"
                ;;
            -y | --yes | -Y)
                accept_flag="$arg"
                ;;
            --additional-packages)
                next_is_value=1 # Flag to capture the next argument as the value
                ;;
            *)
                if [ "$next_is_value" = "1" ]; then
                    additional_packages="$arg"
                    next_is_value=0 # Reset the flag
                else
                    additional_args="$additional_args $arg"
                fi
                ;;
            esac
        done
        print_line "Additional args:$additional_args"
    }
    set_zsh_as_default_shell() {
        if [ "$SHELL" = "/bin/zsh" ]; then
            return
        fi
        print_line "Changing shell to zsh..."
        chsh -s /bin/zsh
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
    help() {
        local option_color="#6b6b6b"
        local total_scripts_files_color="#23b256"
        local script_files_color="#48e0f7"
        print_section "Help"
        print_line "Usage: init.sh [options]"
        print_empty_line
        print_line "By default the script will install everything, so if it's a fresh install, just run the script"
        print_empty_line
        print_empty_line
        print_option() {
            local option="$1"
            local description="$2"
            local default_value="${3:-false}"
            local default_text="Default: $default_value"
            local color="$4"
            print_line "  $(print_text "$option" "$color") : $description"
        }
        print_line "Options:"
        print_line "  $(print_option "--help, -h" "Show help" "false" "$option_color")"
        print_line "  $(print_option "--skip_package_installation, -spi" "Skip package installation" "false" "$option_color")"
        print_line "        When this flag is set, the script will not install any packages"
        print_line "  $(print_option "--skip_update, -su" "Skip package manager update" "false" "$option_color")"
        print_line "        When this flag is set, the script will not update the package manager"
        print_line "  $(print_option "--yes, -y, -Y" "Accept all prompts" "false" "$option_color")"
        print_line "        When this flag is set, the script will accept all prompts of the package manager"
        print_line "  $(print_option "--additional-packages" "Additional packages to install" "false" "$option_color")"
        print_line "        Additional packages to install separated by space"
        print_line "  $(print_option "--skip" "Skip all scripts that have already been run" "false" "$option_color")"
        print_line "        When this flag is set, the script will skip all the scripts that have already been run in dotfiles/scripts/zsh/init folder"

        local init_scripts_dir="$zsh_scripts_dir/init"
        local total_files=$(find "$init_scripts_dir" -type f | wc -l)
        print_empty_lines 3
        print_line "    Currently there are $(print_text "$total_files" "$total_scripts_files_color") scripts in the init folder"
        print_line "    Check below for the list of scripts and their options"
        find "$init_scripts_dir" -type f | while read -r file; do
            script_name=$(basename "${file}" .${file##*.})
            print_line "        $(print_text "$script_name" "$script_files_color") : $script_description"
            print_line "            Options:"
            print_line "              $(print_option "--$script_name" "Run the script $script_name" "" "$option_color")"
            print_line "              $(print_option "--skip-$script_name" "Skip the script $script_name" "" "$option_color")"
        done
        print_section "Help" 40
    }
    install_golang() {
        if [ "$skip_package_installation" = "true" ]; then
            print_line "Skipping golang installation..."
            return
        fi
        local package="golang"
        local DISTRO=$(lsb_release -i -s)
        if [[ "$DISTRO" == "Arch" ]] || [[ "$DISTRO" == "Garuda" ]] || [[ "$DISTRO" == "Manjaro" ]] || [[ "$DISTRO" == "Endeavour" ]]; then
            package="go"
        fi
        install_package "$package"
    }
    install_rust_and_cargo() {
        if [ "$skip_package_installation" = "true" ]; then
            print_line "Skipping rust and cargo installation..."
            return
        fi
        if [ ! -f /etc/debian_version ]; then
            print_line "As it's not necessary to install rust and cargo in this OS, skipping..."
            return
        fi
        print_line "Installing rust and cargo..."
        sudo curl https://sh.rustup.rs -sSf | sh
    }
    install_packages() {
        if [ "$skip_package_installation" = "true" ]; then
            print_line "Skipping package installation..."
            return
        fi
        local packages="$default_packages$additional_packages"
        if [ $os = "Linux" ]; then
            packages="$packages lsb-release"
            install_rust_and_cargo
            return
        fi
        print_line "Installing packages: $packages"
        if ! has_accept_flag; then
            print_line "Do you want to install the packages? [y/n]: [y]"
            read -r answer
            if [ "$answer" = "n" ]; then
                print_line "Skipping package installation..."
                return
            fi
        fi
        print_line "Installing packages..."
        for package in $packages; do
            install_package "$package"
        done
    }
    add_init_zsh_script_run_permission() {
        chmod +x "$init_zsh_script"
    }
    run_init_zsh_script() {
        add_init_zsh_script_run_permission
        print_line "Running init zsh script$additional_args..."
        print_line "Running: /bin/zsh -c \"$init_zsh_script $additional_args\""

        /bin/zsh -c "$init_zsh_script $additional_args"
    }
    install() {
        parse_args "$@"
        update_package_manager
        install_zsh_if_needed
        install_packages
        install_golang
        run_init_zsh_script
    }
    print_line "OS: $os"
    print_line "DOTFILES_DIR: $DOTFILES_DIR"
    print_line "Scripts dir: $scripts_dir"
    install "$@"
}

init "$@"

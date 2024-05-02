#! /bin/zsh
source "$DOTFILES_DIR/scripts/zsh/utils.zsh"
# https://github.com/hkdb/app Thank you for this amazing tool!
run() {
    install_app_if_not_exists() {
        local current_dir=$(pwd)
        local app_dir="$HOME/.config/app"
        local repo="https://github.com/hkdb/app.git"
        local skip_flatpak="${1:-N}" # Assume N as default (don't skip) unless specified
        local skip_snap="${2:-N}"    # Assume N as default (don't skip) unless specified
        local skip_go="${3:-Y}"      # Assume Y as default because It's already being installed in the init script
        if [ ! -d "$app_dir" ]; then
            print_section_line "Installing app..."
            mkdir -p "$app_dir"
            git clone "$repo" "$app_dir"
            chmod +x "$app_dir/install.sh"
            cd "$app_dir"
            print_line "Running app install script skip_flatpak:$skip_flatpak skip_snap:$skip_snap skip_go:$skip_go ..."
            "$app_dir/install.sh" <<EOF
$skip_flatpak
$skip_snap
$skip_go
EOF

            cd "$current_dir"
        fi
    }
    is_app_installed() {
        local app_dir="$HOME/.config/app"
        if [ ! -d "$app_dir" ]; then
            return 1
        fi
        return 0
    }
    clear_app() {
        local app_dir="$HOME/.config/app"
        print_section_line "Clearing app..."
        rm -rf "$app_dir"
        print_section_line "App cleared"
    }
    setup() {
        local skip="${1:---no-skip}"
        print_section_start "App"
        if is_app_installed; then
            if [ "$skip" = "--skip" ]; then
                print_section_line "Skipping app installation..."
                print_section_end
                return
            fi
            print_section_line "App is already installed"
            printf "\nDo you want to override it? [y/n]: [n] "
            read -r answer
            if [ "$answer" = "y" ]; then
                clear_app
                install_app_if_not_exists
                print_section_end
                return
            else
                print_section_line "Skipping app installation..."
                print_section_end
                return
            fi

            return
        else
            install_app_if_not_exists
            print_section_end
        fi
    }
    if [[ "$1" = "--skip" ]]; then
        setup "--skip" "$2" "$3"
    else
        setup "--no-skip" "$2" "$3"
    fi
}
run "$@"

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
source "$sh_scripts_dir/package-names-override.sh"
init() {
    if [[ "$os" == "Darwin" ]]; then

    elif [[ "$os" == "Linux" ]]; then
        echo "OS: $os"
    else
        echo "Unsupported OS: $os"
        exit 1
    fi
}
init "$@"

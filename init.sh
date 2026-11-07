#!/usr/bin/env bash
# Bootstrap entry point. Linking is done by envmgr (see .dotfiles.config.json):
#   envmgr dotfiles register "$PWD" && envmgr dotfiles link

export DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
scripts_dir="$DOTFILES_DIR/scripts"
sh_scripts_dir="$scripts_dir/sh"
source "$sh_scripts_dir/utils.sh"
source "$sh_scripts_dir/package-names-override.sh"

init() {
    local os
    os="$(uname -s)"
    case "$os" in
        Darwin) echo "OS: macOS" ;;
        Linux) echo "OS: Linux" ;;
        MINGW* | MSYS* | CYGWIN*) echo "OS: Windows (use install.ps1 from PowerShell instead)"; exit 1 ;;
        *) echo "Unsupported OS: $os"; exit 1 ;;
    esac
    # enable the repo's git hooks (gitleaks pre-commit)
    git -C "$DOTFILES_DIR" config core.hooksPath .githooks
}
init "$@"

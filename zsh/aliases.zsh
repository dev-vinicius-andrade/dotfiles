#! /bin/zsh
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -l"
alias svi="sudo -E vi $@"
alias svim="sudo -E vim $@"
alias snvim="sudo -E nvim $@"
alias lslha="ls -lha"
alias gopull='function _gopull() { local current_dir=$(pwd); cd "$1" && git pull; cd "$current_dir"; }; _gopull'

if [ -n "$IS_WSL" ] && [ "$IS_WSL" = "true" ]; then
    if [ "$DISABLE_DOCKER_ALIASES" != "true" ]; then
        alias docker="docker.exe"
        alias docker-compose="docker-compose.exe"
    fi
    alias cmd="cmd.exe"
    alias explorer="explorer.exe"
    alias notepad="notepad.exe"
fi
if command -v nix-env >/dev/null 2>&1; then

    alias nxi='nix-env -i'  # install
    alias nxu='nix-env -u'  # update
    alias nxr='nix-env -e'  # remove
    alias nxls='nix-env -q' # list
    alias nxgc='nix-collect-garbage -d'
    alias hmswt='home-manager switch'
fi

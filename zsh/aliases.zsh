#! /bin/zsh
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -l"
alias svi="sudo -E vim $@"
alias svim="sudo -E vim $@"
alias snvim="sudo -E nvim"
alias lslha="ls -lha"
if [ -n "$IS_WSL" ] && [ "$IS_WSL" = "true" ]; then
    alias docker="docker.exe"
    alias docker-compose="docker-compose.exe"
    alias cmd="cmd.exe"
    alias explorer="explorer.exe"
    alias notepad="notepad.exe"
fi

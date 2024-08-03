#! /bin/zsh
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -l"
alias svi="sudo -E vim $@"
alias svim="sudo -E vim $@"
alias snvim="sudo -E nvim"
if [ -n "$IS_WSL" ]; then
    alias docker="docker.exe"
    alias docker-compose="docker-compose.exe"
    alias cmd="cmd.exe"
    alias explorer="explorer.exe"
    alias notepad="notepad.exe"
    alias lslha="ls -lha"
fi

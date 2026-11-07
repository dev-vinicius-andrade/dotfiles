#!/bin/zsh
# Linux-only interactive settings (sourced by .zshrc when $OSTYPE == linux*)

# Homebrew on Linux
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

(( $+commands[python3] )) && export PYTHON="${commands[python3]}"

#!/bin/zsh
# macOS-only interactive settings (sourced by .zshrc when $OSTYPE == darwin*)

# Homebrew: /opt/homebrew on Apple Silicon, /usr/local on Intel
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "$_brew" ]]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew

if (( $+commands[brew] )); then
  # keg-only formulae some builds (e.g. ruby, python, lxml) expect
  _brew_prefix="${HOMEBREW_PREFIX:-$(brew --prefix)}"
  if [[ -d "$_brew_prefix/opt/libxml2" ]]; then
    path=("$_brew_prefix/opt/libxml2/bin" $path)
    export LDFLAGS="-L$_brew_prefix/opt/libxml2/lib${LDFLAGS:+ $LDFLAGS}"
    export CPPFLAGS="-I$_brew_prefix/opt/libxml2/include${CPPFLAGS:+ $CPPFLAGS}"
  fi
  if [[ -d "$_brew_prefix/opt/openssl@3" ]]; then
    export PKG_CONFIG_PATH="$_brew_prefix/opt/openssl@3/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  fi
  unset _brew_prefix
fi

(( $+commands[python3] )) && export PYTHON="${commands[python3]}"

#!/bin/zsh
# WSL-only settings (sourced by .zshrc when running under WSL, after linux.zsh)
export IS_WSL=true

# The Windows drive that holds Windows\System32 (usually /mnt/c)
get_windows_drive() {
  local drive
  for drive in /mnt/*(N/); do
    [[ -x "$drive/Windows/System32/cmd.exe" ]] && { print -r -- "$drive"; return 0 }
  done
  return 1
}

# Spawning cmd.exe costs ~0.5s, so the translated Windows PATH is cached for a day.
# Run `wsl_refresh_windows_path` after installing something on the Windows side.
_wsl_path_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/wsl-windows-path"

wsl_refresh_windows_path() {
  local win_paths entry
  local -a unix_paths
  win_paths=$("$WINDOWS_DRIVE/Windows/System32/cmd.exe" /C "echo %PATH%" 2>/dev/null | tr -d '\r')
  [[ -z "$win_paths" ]] && return 1
  for entry in ${(s:;:)win_paths}; do
    entry="${${entry##[[:space:]]#}%%[[:space:]]#}"
    [[ -n "$entry" ]] && unix_paths+=("$(wslpath -u "$entry" 2>/dev/null)")
  done
  mkdir -p "${_wsl_path_cache:h}"
  print -rl -- ${unix_paths:#} >"$_wsl_path_cache"
}

export WINDOWS_DRIVE="$(get_windows_drive)"
if [[ -n "$WINDOWS_DRIVE" ]]; then
  [[ -s "$_wsl_path_cache" && -n "$(find "$_wsl_path_cache" -mtime -1 2>/dev/null)" ]] || wsl_refresh_windows_path
  [[ -s "$_wsl_path_cache" ]] && path+=("${(@f)$(<"$_wsl_path_cache")}")
fi

# Windows interop aliases
if [[ "$DISABLE_DOCKER_ALIASES" != "true" ]] && (( ! $+commands[docker] )); then
  alias docker="docker.exe"
  alias docker-compose="docker-compose.exe"
fi
alias cmd="cmd.exe"
alias explorer="explorer.exe"
alias notepad="notepad.exe"

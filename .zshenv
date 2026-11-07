# ~/.zshenv — read by EVERY zsh (interactive or not, scripts included).
# Keep it small, fast, portable and FREE OF SECRETS: anything exported here leaks
# into every child process and, if committed, into the public repo.
#   - secrets       -> secrets/env.sops.env (sops + age), loaded by zsh/secrets.zsh
#   - machine-only  -> ~/.zshenv.local (not tracked)

# Rust toolchain (rustup writes this file)
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export EDITOR=nvim
export VISUAL=nvim

# sops/age: the key lives outside the repo. sops also finds it on its own at
# ~/.config/sops/age/keys.txt (Linux) or ~/Library/Application Support/sops/age/keys.txt (macOS).
if [[ -z "$SOPS_AGE_KEY_FILE" && -r "$HOME/.ssh/keys.txt" ]]; then
  export SOPS_AGE_KEY_FILE="$HOME/.ssh/keys.txt"
fi

# Linux-only session plumbing (containers / WSL / bare TTYs don't always set these)
if [[ "$OSTYPE" == linux* ]]; then
  if [[ -z "$XDG_RUNTIME_DIR" && -d "/run/user/$UID" ]]; then
    export XDG_RUNTIME_DIR="/run/user/$UID"
  fi
  if [[ -z "$DBUS_SESSION_BUS_ADDRESS" && -S "$XDG_RUNTIME_DIR/bus" ]]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
  fi
  export NETAVARK_FW=iptables # podman networking
fi

# PATH: unique entries, only directories that exist
typeset -U path PATH
for _dir in "$HOME/.bun/bin" "$HOME/.atuin/bin" "$HOME/.cargo/bin" "$HOME/.dotnet/tools" "$HOME/go/bin" "$HOME/.local/bin"; do
  [[ -d "$_dir" ]] && path=("$_dir" $path)
done
unset _dir

# Machine-specific overrides (untracked)
[[ -r "$HOME/.zshenv.local" ]] && . "$HOME/.zshenv.local"

#!/bin/zsh
# Loads secrets/env.sops.env (encrypted with sops + age) into the shell.
#
# Decrypting on every shell is slow (~100ms+), so the plaintext is cached in a
# private, tmpfs-backed runtime dir and refreshed whenever the encrypted file changes.
#   secrets_edit     edit the encrypted file (opens $EDITOR via sops)
#   secrets_reload   drop the cache and load again
#   secrets_list     list the variable names (never values)

SOPS_SECRETS_FILE="${SOPS_SECRETS_FILE:-$DOT_FILES_DIR/secrets/env.sops.env}"

_secrets_cache_file() {
  local base="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
  print -r -- "$base/dotfiles-secrets-$UID.env"
}

load_sops_secrets() {
  [[ -r "$SOPS_SECRETS_FILE" ]] || return 0
  (( $+commands[sops] )) || { print -u2 "secrets: sops not installed, skipping $SOPS_SECRETS_FILE"; return 0 }

  local cache="$(_secrets_cache_file)"
  if [[ ! -s "$cache" || "$SOPS_SECRETS_FILE" -nt "$cache" ]]; then
    local tmp
    tmp="$(umask 077; mktemp "${cache}.XXXXXX")" || return 1
    if ! sops decrypt --input-type dotenv --output-type dotenv "$SOPS_SECRETS_FILE" >"$tmp" 2>/dev/null; then
      rm -f -- "$tmp"
      print -u2 "secrets: could not decrypt $SOPS_SECRETS_FILE (age key missing?)"
      return 0
    fi
    mv -f -- "$tmp" "$cache"
  fi

  local line key value
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    key="${line%%=*}"
    value="${line#*=}"
    [[ "$key" == [A-Za-z_][A-Za-z0-9_]# ]] && export "$key=$value"
  done <"$cache"
  return 0
}

secrets_edit() {
  sops edit "$SOPS_SECRETS_FILE" && secrets_reload
}

secrets_reload() {
  rm -f -- "$(_secrets_cache_file)"
  load_sops_secrets
}

secrets_list() {
  sops decrypt --input-type dotenv --output-type dotenv "$SOPS_SECRETS_FILE" | cut -d= -f1
}

load_sops_secrets

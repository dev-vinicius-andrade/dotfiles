# Enable Emacs mode for standard keybind behavior
bindkey -e

# --- Region Handling Helper Widgets ---
shift-select-forward-char() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle forward-char
}
shift-select-backward-char() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle backward-char
}
shift-select-beginning-of-line() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle beginning-of-line
}
shift-select-end-of-line() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle end-of-line
}
shift-select-forward-word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle forward-word
}
shift-select-backward-word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle backward-word
}

# Delete active selection with Backspace or Delete
delete-region-or-char() {
  if (( REGION_ACTIVE )); then
    zle kill-region
  else
    zle delete-char
  fi
}
backward-delete-region-or-char() {
  if (( REGION_ACTIVE )); then
    zle kill-region
  else
    zle backward-delete-char
  fi
}

# Overwrite active selection if typing regular characters
self-insert-replace-region() {
  if (( REGION_ACTIVE )); then
    zle kill-region
  fi
  zle self-insert
}

# --- Register Widgets ---
zle -N shift-select-forward-char
zle -N shift-select-backward-char
zle -N shift-select-beginning-of-line
zle -N shift-select-end-of-line
zle -N shift-select-forward-word
zle -N shift-select-backward-word
zle -N delete-region-or-char
zle -N backward-delete-region-or-char
zle -N self-insert-replace-region

# --- Key Bindings ---

# Shift + Arrows
bindkey '^[[1;2C' shift-select-forward-char
bindkey '^[[1;2D' shift-select-backward-char

# Ctrl + Shift + Arrows (Word selection)
bindkey '^[[1;6C' shift-select-forward-word
bindkey '^[[1;6D' shift-select-backward-word

# Shift + Home (xterm & rxvt sequences)
bindkey '^[[1;2H' shift-select-beginning-of-line
bindkey '^[[2J'   shift-select-beginning-of-line
bindkey '^[[7$'   shift-select-beginning-of-line

# Shift + End (xterm & rxvt sequences)
bindkey '^[[1;2F' shift-select-end-of-line
bindkey '^[[2K'   shift-select-end-of-line
bindkey '^[[8$'   shift-select-end-of-line

# Backspace & Delete to clear selection
bindkey '^?'      backward-delete-region-or-char
bindkey '^H'      backward-delete-region-or-char
bindkey '^[[3~'   delete-region-or-char

# Overwrite selected text when typing normal characters
bindkey -R ' '-'~' self-insert-replace-region

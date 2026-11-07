#!/bin/zsh
# Starship for zsh, resize-safe.
# The info line (starship profile "header") is printed once per prompt by a precmd
# hook; the live PROMPT is only "➜ " (profile "input") with no RPROMPT. zsh
# re-renders the live prompt on every SIGWINCH; a multi-line or near-full-width
# live prompt leaves stacked fragments each time the terminal shrinks.
(( $+commands[starship] )) || return 0

eval "$(starship init zsh)"

# same arguments starship's own init passes
_STARSHIP_ARGS='--terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="${STARSHIP_CMD_STATUS:-}" --pipestatus="${STARSHIP_PIPE_STATUS[*]:-}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="${STARSHIP_JOBS_COUNT:-0}"'

_starship_print_header() {
  print -P -- "$(eval "starship prompt --profile header $_STARSHIP_ARGS")"
}
# registered after starship's own precmd, so status/duration are already captured
autoload -Uz add-zsh-hook
add-zsh-hook precmd _starship_print_header

PROMPT='$(eval "starship prompt --profile input $_STARSHIP_ARGS")'
RPROMPT='' # everything right-aligned lives in the header (a long live line rewraps on resize)

# Ctrl-L: clear the screen but keep the header line
_starship_clear_screen() {
  zle -I
  print -n -- $'\e[H\e[2J'
  _starship_print_header
}
zle -N clear-screen _starship_clear_screen

#!/bin/zsh
# zsh-syntax-highlighting / zsh-autosuggestions colours.
# The plugin default for comments is fg=black,bold: invisible on a dark terminal.
# 256-colour indices so it works without truecolor too (245 = mid grey).
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=245,italic'
# ghost text of history suggestions (default fg=8 can disappear on some themes)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'

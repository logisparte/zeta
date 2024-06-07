#!/bin/sh

# Load ls colors
autoload -U colors && colors

# Enable ls colors (Generator: https://geoff.greer.fm/lscolors/)
export LSCOLORS="GxFxcxdxBxegedabagacad"
export LS_COLORS="di=1;36:ln=1;35:so=32:pi=33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Alias standard ls to colorized ls
if [ "$(uname)" = "Darwin" ]; then
  alias ls='ls -G'

else
  alias ls='ls --color'
fi

# Use ls colors for tab path completions as well
# shellcheck disable=SC2296
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

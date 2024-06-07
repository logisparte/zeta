#!/bin/sh

#
# Changes the titlebar to the current hostname
#

update_titlebar() {
  printf '\e]1;%s\a' "$HOST"
}

add-zsh-hook precmd update_titlebar

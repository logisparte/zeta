#!/bin/sh

# Changes the titlebar to current host
update_titlebar() {
  printf '\e]1;%s\a' "$HOST"
}

add-zsh-hook precmd update_titlebar

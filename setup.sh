#!/bin/sh -e

echo "export ZDOTDIR=$HOME/.zsh" >> "$HOME/.zshenv"
chsh -s /bin/zsh
sudo ln -sf /bin/zsh /var/select/sh
cd "$HOME/.zsh" && brew bundle

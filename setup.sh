#!/bin/sh -e

#
# Create a `.zshenv` that defines this directory as the `zsh` configuration directory.
# Set `zsh` as your macOS user default shell, if it wasn't already.
# Run `brew bundle` to install all formulas and casks defined in the included `Brewfile`
#

echo "export ZDOTDIR=$HOME/.zsh" >> "$HOME/.zshenv"
chsh -s /bin/zsh
sudo ln -sf /bin/zsh /var/select/sh
cd "$HOME/.zsh" && brew bundle

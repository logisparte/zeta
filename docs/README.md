# zeta

macOS `zsh` configuration template

## License

`zeta` is distributed under the terms of the [Apache 2.0 license](/LICENSE)

## Installation

Create a new personal private git repository called `.zsh` with this repository as template on
GitHub. Then run:

```shell
git clone git@github.com:USERNAME/.zsh.git "$HOME/.zsh"
"$HOME/.zsh/setup.sh"
```

This will:

- Create a `.zshenv` that defines the cloned directory as the `zsh` configuration directory.
- Set `zsh` as your macOS user default shell, if it wasn't already.
- Run `brew bundle` to install all formulas and casks defined in the included `Brewfile`

## Usage

You can tailor the contents of this repository to your personal needs and commit your changes to
GitHub (in your personal repository).

While you're free to do as you like, we recommend the following conventions:

### Variables

Add all your environment variables in `/variables`. Group related variables in separate
sourceable shell files, `.zshrc` will source them all at runtime.

#### ignored.sh

Sensitive values should be added to a `/variables/ignored.sh` file. By default, this file won't
be committed (per .gitignore).

### Aliases

Add all your aliases in `/aliases`. Group related aliases in separate separate
sourceable shell files, `.zshrc` will source them all at runtime.

### Themes

Add all your terminal themes in `/themes`. Group related aliases in separate separate
sourceable shell files, `.zshrc` will source them all at runtime.

### Scripts

Add all your personal scripts in `/scripts`. You'll be able to execute them by name using the
`zeta` command. Example:

```shell
# To run a script located at '/script/my_script.sh':

zeta my_script
```

`zeta` also supports nested scripts. Example:

```shell
# To run a script located at '/script/my_context/my_script.sh':

zeta my_context my_script
```

> This helps group related scripts by adding a context level

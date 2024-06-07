#!/bin/zsh

# History file location
export HISTFILE="$ZDOTDIR/.zsh_history"

# Maximum history lines to save per session
export SAVEHIST=20000

# Maximum history lines to save overall
export HISTSIZE=50000

# All shells share the same history
setopt SHARE_HISTORY

# Expire history duplicates first
setopt HIST_EXPIRE_DUPS_FIRST

# Do not store history duplicates
setopt HIST_IGNORE_DUPS

# Ignore duplicates when searching history
setopt HIST_FIND_NO_DUPS

# Remove blank lines from history
setopt HIST_REDUCE_BLANKS

# Make globbing and autocompletion match Finder's case-insensitivity
setopt NO_CASE_GLOB

# Make globbing return an empty list when no matches found (more POSIX-like)
# instead of throwing an exception (ZSH default)
setopt NULL_GLOB

# Don't suggest typo corrections
setopt NO_CORRECT_ALL

# Make the prompt string evaluate inner expressions before printing
setopt PROMPT_SUBST

# Evaluate completions before substituting aliases (for extensions)
setopt COMPLETE_ALIASES

# Enable menu completion behavior
setopt MENU_COMPLETE

# Enable tab path completion
autoload -Uz compinit && compinit

# Make tab path completion match Finder's case-insensitivity
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Default format for completion messages
zstyle ':completion:*' format '%B%F{117}[ %d ]%b%f'

# Format normal completion messages
zstyle ':completion:*:messages' format '%F{229}[ %d ]%f'

# Format completion error messages
zstyle ':completion:*:warnings' format "%B%F{124}[ No match for:%f %F{white}%d%f %F{124}]%f%b"

# Group completion suggestions by type
zstyle ':completion:*' group-name ''

# Activate menu completion behavior
zstyle ':completion:*' menu yes select

# Enable ZSH hooks
autoload -U add-zsh-hook

# Path
if [ "$(uname)" = "Darwin" ]; then
  export PATH="/usr/sbin:/sbin:$PATH"

  # Homebrew
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# Environment variables
for FILE in "$ZDOTDIR/variables"/*; do
  . "$FILE"
done

# Terminal themes
for FILE in "$ZDOTDIR/themes"/*; do
  . "$FILE"
done

# Aliases
for FILE in "$ZDOTDIR/aliases"/*; do
  . "$FILE"
done

# Scripts
zeta() {
  zeta_run() {
    DIRECTORY="$1"
    shift

    if [ $# -eq 0 ]; then
      echo "[zeta] '$DIRECTORY' is a script directory" >&2
      return 1
    fi

    MAYBE_FILE="$DIRECTORY/$1.sh"
    if [ -f "$MAYBE_FILE" ]; then
      shift
      "$MAYBE_FILE" "$@"
      return $?
    fi

    MAYBE_DIRECTORY="$DIRECTORY/$1"
    if [ -d "$MAYBE_DIRECTORY" ]; then
      shift
      zeta_run "$MAYBE_DIRECTORY" "$@"
      return $?
    fi

    echo "[zeta] '$1/' or '$1.sh' not found in: $DIRECTORY" >&2
    return 1
  }

  if [ $# -eq 0 ]; then
    echo "[zeta] No script specified" >&2
    return 1
  fi

  zeta_run "$ZDOTDIR/scripts" "$@"
}

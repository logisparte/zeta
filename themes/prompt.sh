#!/bin/sh

SUCCESS_COLOR="10"
FAILURE_COLOR="9"
DIRECTORY_COLOR="227"
COMMAND_COLOR="236"
NO_UPSTREAM_COLOR="236"
BRANCH_COLOR="39"
COMMITS_BEHIND_COLOR="11"
COMMITS_AHEAD_COLOR="5"
STAGED_CHANGES_COLOR="10"
UNSTAGED_CHANGES_COLOR="9"
STASHES_COLOR="6"

is_in_a_work_tree() {
  [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]
}

get_branch_name() {
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

get_commits_ahead_count() {
  git rev-list --count @\{upstream\}..HEAD 2> /dev/null
}

get_commits_behind_count() {
  git rev-list --count HEAD..@\{upstream\} 2> /dev/null
}

get_staged_changes_count() {
  git diff --staged --name-only | wc -l | xargs
}

get_unstaged_changes_count() {
  git diff --name-only | wc -l | xargs
}

get_stashes_count() {
  git stash list | wc -l | xargs
}

has_upstream_remote() {
  [ -n "$(git rev-parse --abbrev-ref HEAD@\{upstream\} 2> /dev/null)" ]
}

git_prompt() {
  if ! is_in_a_work_tree; then
    return
  fi

  GIT_PROMPT="%F{$BRANCH_COLOR}$(get_branch_name)%f"

  if has_upstream_remote; then
    COMMITS_BEHIND="$(get_commits_behind_count)"
    if [ "$COMMITS_BEHIND" -gt 0 ]; then
      STATE="$STATE %F{$COMMITS_BEHIND_COLOR}↓$COMMITS_BEHIND%f"
    fi

    COMMITS_AHEAD="$(get_commits_ahead_count)"
    if [ "$COMMITS_AHEAD" -gt 0 ]; then
      STATE="$STATE %F{$COMMITS_AHEAD_COLOR}↑$COMMITS_AHEAD%f"
    fi

  else
    STATE="$STATE %F{$NO_UPSTREAM_COLOR}⌀%f"
  fi

  STAGED_CHANGES="$(get_staged_changes_count)"
  if [ "$STAGED_CHANGES" -gt 0 ]; then
    STATE="$STATE %F{$STAGED_CHANGES_COLOR}+$STAGED_CHANGES%f"
  fi

  UNSTAGED_CHANGES="$(get_unstaged_changes_count)"
  if [ "$UNSTAGED_CHANGES" -gt 0 ]; then
    STATE="$STATE %F{$UNSTAGED_CHANGES_COLOR}~$UNSTAGED_CHANGES%f"
  fi

  STASHES="$(get_stashes_count)"
  if [ "$STASHES" -gt 0 ]; then
    STATE="$STATE %F{$STASHES_COLOR}▢$STASHES%f"
  fi

  if [ -n "$STATE" ]; then
    GIT_PROMPT="$GIT_PROMPT${STATE}"
  fi

  echo "$GIT_PROMPT"
}

export ZETA_TIMER=
# shellcheck disable=SC3028
start_command_timer() {
  export ZETA_TIMER=$SECONDS
}

export ZETA_LAST_COMMAND_DURATION="0s"
# shellcheck disable=SC3028,SC3006
end_command_timer() {
  if [ -z "$ZETA_TIMER" ]; then
    return
  fi

  TIMED_SECONDS=$((SECONDS - ZETA_TIMER))
  export ZETA_TIMER=
  DURATION=""

  DURATION_HOURS=$((TIMED_SECONDS / 3600))
  if (( DURATION_HOURS > 0 )); then
    DURATION="${DURATION}${DURATION_HOURS}h "
  fi

  DURATION_MINUTES=$(( (TIMED_SECONDS % 3600) / 60 ))
  if (( DURATION_MINUTES > 0 || DURATION_HOURS > 0 )); then
    DURATION="${DURATION}${DURATION_MINUTES}m "
  fi

  DURATION_SECONDS=$((TIMED_SECONDS % 60))
  DURATION="${DURATION}${DURATION_SECONDS}s"

  export ZETA_LAST_COMMAND_DURATION="$DURATION"
}

add-zsh-hook preexec start_command_timer
add-zsh-hook precmd end_command_timer

export PROMPT="
%(?.%F{$SUCCESS_COLOR}[ √.%F{$FAILURE_COLOR}[ X) \$ZETA_LAST_COMMAND_DURATION ]%f \
%F{$DIRECTORY_COLOR}%3~%f \$(git_prompt)
%F{$COMMAND_COLOR}%(!.>>.>)%f "
export RPROMPT="%F{$COMMAND_COLOR}%*%f"

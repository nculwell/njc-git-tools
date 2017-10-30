#!/bin/sh

# Collection of git functions and aliases to make various command-line activities easier.

# TODO: git diff vs difftool (compare env vars?)

if [ -z "$NGT_GIT_LOG_FORMAT" ]; then
  export NGT_GIT_LOG_FORMAT='--format=%Cred%h %Cblue[%aE] %Creset%s'
fi

git-user-org() {
  git config user.email | sed 's/^.*@//'
}

git-head-hash() {
  git rev-parse --verify --short HEAD
}

git-head-longhash() {
  git rev-parse --verify HEAD
}

git-current-branch() {
  git rev-parse --abbrev-ref HEAD
}

if [ -n "$NGT_ORG_DOMAIN" ]; then
  alias log='git log "$NGT_GIT_LOG_FORMAT" | sed "s/@$NGT_ORG_DOMAIN//" | head'
else
  alias log='git log "$NGT_GIT_LOG_FORMAT" | head'
fi

git-log() {
  git log "$NGT_GIT_LOG_FORMAT" "$@" | sed "s/@$(git-user-org)\\]/]/" | head
}

git-unpushed() {
  git-log origin/$(git-current-branch)..HEAD
}

git-unpulled() {
  git-log HEAD..origin/$(git-current-branch)
}

git-difftool() {
  git difftool -y "$@"
}

git-diff() {
  git diff "$@"
}

git-pull() {
  git fetch && {
    NGT_PREPULL_HEAD=$(git-head-longhash)
    NGT_PULLED_COMMITS=$(git-unpulled)
    git pull --rebase && {
      NGT_POSTPULL_HEAD=$(git-head-longhash)
      if [ "$NGT_POSTPULL_HEAD" != "$NGT_PREPULL_HEAD" ]; then
        echo "New commits pulled:"
        echo "$NGT_PULLED_COMMITS"
      fi
    }
  }
}

# basic abbreviations
alias g='git status'
alias ga='git add'
alias gau='git add -u'
alias gc='git commit'
# name of current branch
alias gcb='git-current-branch'
# outgoing commits
alias gout='git-unpushed'
alias mine='git-unpushed'
# incoming commits
alias ginc='git-unpulled'
# diff
alias gd='git-diff'
alias gdt='git-difftool'

alias fetch='git fetch'
alias pull='git-pull'
alias push='git push'

alias gd='git difftool -y'
alias gdc='git difftool -y --cached'
alias log='git-log'


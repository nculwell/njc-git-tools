#!/bin/sh

# Collection of git functions and aliases to make various command-line activities easier.

# TODO: git diff vs difftool (compare env vars?)

git-head-hash() {
  git rev-parse --verify --short HEAD
}

git-head-longhash() {
  git rev-parse --verify HEAD
}

git-current-branch() {
  git rev-parse --abbrev-ref HEAD
}

git-unpushed() {
  git log --oneline origin/$(git-current-branch)..HEAD
}

git-unpulled() {
  git log --oneline HEAD..origin/$(git-current-branch)
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

alias g='git status'
alias ga='git add'
alias gau='git add -u'
alias gc='git commit'
alias gcb='git-current-branch'
# outgoing commits
alias gout='git-unpushed'
# incoming commits
alias ginc='git-unpulled'

alias fetch='git fetch'
alias pull='git-pull'
alias push='git push'


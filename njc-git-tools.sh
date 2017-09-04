#!/bin/sh

# Collection of git functions and aliases to make various command-line activities easier.

git-head-hash() {
  git rev-parse HEAD
}

git-current-branch() {
  git rev-parse --abbrev-ref HEAD
}

git-unpushed() {
  git log --oneline $(git-current-branch)..HEAD
}

git-unpulled() {
  git log --online HEAD..$(git-current-branch)
}

git-pull() {
  CURRENT_HEAD=$(git-head-hash)
  git pull --rebase
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


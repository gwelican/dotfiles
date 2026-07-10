alias addkeys="ssh -add -K"

alias gradle="./gradlew"
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias pods="kubectl get pod -o wide"
alias allpods="kubectl get pod --all-namespaces -o wide"
#alias grep=ag
alias backup='cat ~/tobackup|grep -v "^#" | xargs restic backup -v --exclude-if-present .nobackup --tag all'
alias stup='task stup modified:yesterday'

# Better ls
alias ls='eza --icons'

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Tree view
alias tree='eza --tree --icons'


# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
#
# ls Aliases
#

alias df='df -h'
alias du='du -h'

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

alias t='task'
alias v=nvim
alias vi=nvim
alias vim=nvim
# alias k=kubectl
alias k=kubecolor
alias c=chezmoi
alias gg=lazygit
alias cat='bat --paging=never'
alias cd=z

alias gpf='git push --force-with-lease'
alias gp='git push'

if [[ "$(uname)" == "Linux" ]]; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
fi


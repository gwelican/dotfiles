alias addkeys="ssh -add -K"

alias gradle="./gradlew"
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias pods="kubectl get pod -o wide"
alias allpods="kubectl get pod --all-namespaces -o wide"
#alias grep=ag
alias backup='cat ~/tobackup|grep -v "^#" | xargs restic backup -v --exclude-if-present .nobackup --tag all'
alias stup='task stup modified:yesterday'


# Tree view
alias tree='eza --tree --icons'


alias find=fd
# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

alias grep='rg --color=always'
alias diff='diff --color=auto'
alias df='df -h'
#
# ls Aliases
#
# Remove oh-my-zsh's ls alias first
unalias ls 2>/dev/null
alias ls='eza --icons'
alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale' # all list
alias ll='eza -lbF --icons --git' # list, size, type, git 
alias llm='eza -lbGd --git --sort=modified' # long list, modified date sort
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list
alias lS='eza -1' # one column, just names
alias lt='eza --tree --level=2' # tree
alias ltr='eza -lh --icons=auto --sort newest'


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


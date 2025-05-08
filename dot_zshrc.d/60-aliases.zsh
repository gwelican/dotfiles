alias addkeys="ssh -add -K"

alias gradle="./gradlew"
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias pods="kubectl get pod -o wide"
alias allpods="kubectl get pod --all-namespaces -o wide"
#alias grep=ag
alias backup='cat ~/tobackup|grep -v "^#" | xargs restic backup -v --exclude-if-present .nobackup --tag all'
alias stup='task stup modified:yesterday'
alias ls='ls -G --color=auto'

#
# ls Aliases
#

alias ll='ls -lh'         # long format and human-readable sizes
alias l='ll -A'           # long format, all files
[[ -n ${PAGER} ]] && alias lm="l | ${PAGER}" # long format, all files, use pager
alias lr='ll -R'          # long format, recursive
alias lk='ll -Sr'         # long format, largest file size last
alias lt='ll -tr'         # long format, newest modification time last
alias lc='lt -c'          # long format, newest status change (ctime) last

#
# Resource Usage
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

alias addkeys="ssh -add -K"

alias v=nvim
alias vi=nvim
alias vim=nvim

#alias vimgo='vim -u ~/.vimrc.go'

alias gradle="./gradlew"
alias preview="fzf --preview 'bat --color \"always\" {}'"

alias backup='cat ~/tobackup|grep -v "^#" | xargs restic backup -v --exclude-if-present .nobackup --tag all'
alias ls='ls -G --color=auto'

alias ll='ls -lh'         # long format and human-readable sizes
alias l='ll -A'           # long format, all files
[[ -n ${PAGER} ]] && alias lm="l | ${PAGER}" # long format, all files, use pager
alias lr='ll -R'          # long format, recursive
alias lk='ll -Sr'         # long format, largest file size last
alias lt='ll -tr'         # long format, newest modification time last
alias lc='lt -c'          # long format, newest status change (ctime) last

alias df='df -h'
alias du='du -h'

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

alias t='task'
alias k=kubectl
alias lg=lazygit

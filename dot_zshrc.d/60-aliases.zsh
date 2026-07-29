alias addkeys="ssh -add -K"

alias gradle="./gradlew"
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias pods="kubectl get pod -o wide"
alias allpods="kubectl get pod --all-namespaces -o wide"
#alias grep=ag
alias backup='cat ~/tobackup|grep -v "^#" | xargs restic backup -v --exclude-if-present .nobackup --tag all'
alias stup='task stup modified:yesterday'

# Remove oh-my-zsh's ls alias first
unalias ls 2>/dev/null
# Better ls
function ls() {
  local args=()
  local has_t=false
  local has_r=false

  # Parse user's flags
  for arg in "$@"; do
    if [[ "$arg" == -* ]] && [[ "$arg" != --* ]]; then
      [[ "$arg" == *t* ]] && has_t=true
      [[ "$arg" == *r* ]] && has_r=true
      # Remove t and r, keep other flags like 'a'
      local cleaned=$(echo "$arg" | sed 's/[tr]//g')
      [[ "$cleaned" != "-" ]] && args+=("$cleaned")
    else
      args+=("$arg")
    fi
  done

  # Build base args
  if $has_t; then
    # For time sorting: use all defaults
    args=(-lh --group-directories-first --icons=auto "${args[@]}")
    if $has_r; then
      args+=(--sort oldest)
    else
      args+=(--sort newest)
    fi
  else
    # For normal listing: use all defaults
    args=(-lh --group-directories-first --icons=auto "${args[@]}")
  fi

  eza "${args[@]}"
}

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


export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
export CARAPACE_EXCLUDES='task,pv-migrate' # exclude task, pv-migrate from carapace
# zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
zstyle ':completion:*:*:kubectl:*' fzf-flags --with-nth=1,2,3,4,5 --delimiter='\s\+'
zstyle ':completion:*:*:kubectl:*' fzf-transform 'cut -d" " -f1'
zstyle ':completion:*:*:k:*' fzf-transform 'cut -d" " -f1'

if [[ -n ${ZSH_VERSION-} ]]; then
  autoload -U +X compinit && if [[ ${ZSH_DISABLE_COMPFIX-} = true ]]; then
    compinit -u
  else
    compinit
  fi
  autoload -U +X bashcompinit && bashcompinit
fi

# [[ $commands[stern] ]] && source <(stern --completion zsh)
# [[ $commands[pv-migrate] ]] && source <(pv-migrate completion zsh)

# source <(kubectl completion zsh)
compdef kubecolor=kubectl
eval "$(task --completion zsh)"
eval "$(pv-migrate completion zsh)"
compdef t=task

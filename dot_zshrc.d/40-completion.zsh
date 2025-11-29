export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
export CARAPACE_EXCLUDES='task,pv-migrate' # exclude task, pv-migrate from carapace
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

compdef kubecolor=kubectl
eval "$(task --completion zsh)"
eval "$(pv-migrate completion zsh)"
compdef t=task

bindkey '^R' _atuin_search_widget

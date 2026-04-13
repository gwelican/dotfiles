export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
export CARAPACE_EXCLUDES='task,pv-migrate,flux' # exclude task, pv-migrate from carapace
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

if (( $+commands[task] )); then
eval "$(task --completion zsh)"
fi
if (( $+commands[pv-migrate] )); then
eval "$(pv-migrate completion zsh)"
fi
if (( $+commands[flux] )); then
  eval "$(flux completion zsh)"
fi
if (( $+commands[mise] )); then
  eval "$(mise completion zsh)"
fi

compdef kubecolor=kubectl
compdef t=task

# to avoid issues with carapace
zstyle ':fzf-tab:*' query-string ''.
zstyle ':fzf-tab:*' fzf-preview ''

zstyle ':fzf-tab:complete:(cat|bat|grep|vim|nvim|nano|code):*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 {}'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Grouping: Group results by category (e.g., "Parameters", "Commands")
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*' format ' %F{yellow}-- %d --%f'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap --border'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

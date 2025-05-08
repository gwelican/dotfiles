# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# set list-colors to enable filename colorizing
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*:git-checkout:*' sort false


zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

if [[ -n ${ZSH_VERSION-} ]]; then
  autoload -U +X compinit && if [[ ${ZSH_DISABLE_COMPFIX-} = true ]]; then
    compinit -u
  else
    compinit
  fi
  autoload -U +X bashcompinit && bashcompinit
fi

[[ $commands[stern] ]] && source <(stern --completion zsh)
[[ $commands[pv-migrate] ]] && source <(pv-migrate completion zsh)

source <(kubectl completion zsh)
# make completion work with kubecolor
compdef kubecolor=kubectl

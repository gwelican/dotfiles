# mise
eval "$(~/.local/bin/mise activate zsh)"
eval "$(direnv hook zsh)"

# init
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# fabric
if [ -f "/home/gwelican/.config/fabric/fabric-bootstrap.inc" ]; then . "/home/gwelican/.config/fabric/fabric-bootstrap.inc"; fi

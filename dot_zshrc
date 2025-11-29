setopt nullglob

autoload -Uz compinit
compinit
autoload -U +X bashcompinit && bashcompinit

zshrc_d="$HOME/.zshrc.d/"

# Source files in $HOME/.zshrc.d/
if [ -d "$zshrc_d" ]; then
    for file in "$zshrc_d"/*.zsh; do
        source "$file"
    done
fi

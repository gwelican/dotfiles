if [ -f "/home/gwelican/.config/fabric/fabric-bootstrap.inc" ]; then . "/home/gwelican/.config/fabric/fabric-bootstrap.inc"; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/gwelican/.local/share/mise/installs/python/miniconda3-latest/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/gwelican/.local/share/mise/installs/python/miniconda3-latest/etc/profile.d/conda.sh" ]; then
        . "/home/gwelican/.local/share/mise/installs/python/miniconda3-latest/etc/profile.d/conda.sh"
    else
        export PATH="/home/gwelican/.local/share/mise/installs/python/miniconda3-latest/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


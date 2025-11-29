zt()  { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }

zinit light ohmyzsh/ohmyzsh

zinit ice wait lucid
zinit load hlissner/zsh-autopair

# zsh-autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

zinit ice lucid wait'2' atinit'zpcompinit' atload'zpcdreplay -q'

zinit light Aloxaf/fzf-tab
zinit load wfxr/forgit
zinit ice wait"3" lucid

zinit wait'2c' lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    atinit"export ZSH_AUTOSUGGEST_USE_ASYNC=1; export ZSH_AUTOSUGGEST_MANUAL_REBIND=1; export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20" \
        zsh-users/zsh-autosuggestions \
    # blockf \
    #     zsh-users/zsh-completions  # Disabled to avoid conflicts with carapace

zt 0a light-mode for \
    OMZP::kubectx \
    OMZP::git \
    OMZP::sudo \
    OMZP::aws \
    OMZP::command-not-found \
    OMZP::extract \
    OMZP::virtualenv \
    OMZP::gradle \
    OMZP::colorize \
    OMZL::termsupport.zsh \
    skx/sysadmin-util \
    djui/alias-tips \
    paoloantinori/hhighlighter \
    willghatch/zsh-saneopt \
    zsh-users/zsh-history-substring-search \
    has'git' pick'init.zsh' atload'alias gi="git-ignore"' blockf \
    laggardkernel/git-ignore \
    has'git-extras' \
    as"program" pick"bin/git-dsf" \
    zdharma-continuum/zsh-diff-so-fancy

    # rimraf/k \
zt 0b light-mode for \
  has'man' \
        ael-code/zsh-colored-man-pages \
  has'notify-send' atload'AUTO_NOTIFY_THRESHOLD=300; AUTO_NOTIFY_IGNORE+=( "cht.sh" "cht" "lazydocker" "lazygit" "tmux" "yarn" "vagrant ssh" )' \
        MichaelAquilina/zsh-auto-notify


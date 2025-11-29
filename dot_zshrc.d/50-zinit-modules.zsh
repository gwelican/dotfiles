zt()  { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }

zinit light ohmyzsh/ohmyzsh
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
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
    willghatch/zsh-saneopt \
    zsh-users/zsh-history-substring-search \
    has'git' pick'init.zsh' atload'alias gi="git-ignore"' blockf \
    laggardkernel/git-ignore \
    has'git-extras' \
    as"program" pick"bin/git-dsf" \
    zdharma-continuum/zsh-diff-so-fancy

    # paoloantinori/hhighlighter \
    # rimraf/k \

    zt 0b light-mode for \
  has'man' \
        ael-code/zsh-colored-man-pages \
        # MichaelAquilina/zsh-auto-notify



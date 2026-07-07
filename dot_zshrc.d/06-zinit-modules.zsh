zt()  { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }

zinit light ohmyzsh/ohmyzsh
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zt 0a light-mode for \
    OMZP::kubectx \
    OMZP::sudo \
    OMZP::aws \
    OMZL::termsupport.zsh \
    has'git' pick'init.zsh' atload'alias gi="git-ignore"' blockf \
    has'git-extras' \
    as"program" pick"bin/git-dsf" \
    zdharma-continuum/zsh-diff-so-fancy

    # paoloantinori/hhighlighter \
    # rimraf/k \

    zt 0b light-mode for \
  has'man' \
        ael-code/zsh-colored-man-pages \
        # MichaelAquilina/zsh-auto-notify



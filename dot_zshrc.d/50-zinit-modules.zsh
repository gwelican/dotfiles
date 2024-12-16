zt()  { zinit depth'3' lucid ${1/#[0-9][a-c]/wait"$1"} "${@:2}"; }

zinit light ohmyzsh/ohmyzsh

zinit ice wait lucid
zinit load hlissner/zsh-autopair

# zsh-autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

export ATUIN_NOBIND="true"
zinit load atuinsh/atuin

function from-where {
  local candidate
    echo "Completion used:"
    whence -v $_comps[$1] | offset
    echo "Candidate completions:"
    for candidate in $^fpath/$_comps[$1](N^/); do
      echo -n "  "
      if (( ${+commands[exa]} )); then
        exa --long --no-permissions --no-filesize --no-user --no-time "$candidate"
      else
        ls -l "$candidate"
      fi
    done
}

zinit wait lucid light-mode for \
  has'docker' \
  as"completion" \
  id-as"docker-completion/_docker" \
  nocompile \
  is-snippet \
  '@https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker'


zinit wait lucid light-mode for \
  has'docker' \
  as"completion" \
  id-as"docker-completion/_docker" \
  nocompile \
  is-snippet \
  'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose'


zi for from'gh-r' sbin'* -> jq' nocompile @jqlang/jq

zinit ice lucid wait'2' atinit'zpcompinit' atload'zpcdreplay -q'

zinit light Aloxaf/fzf-tab
zinit load wfxr/forgit
zinit ice wait"3" lucid
zinit light bonnefoa/kubectl-fzf

zinit wait'2c' lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    atinit"export ZSH_AUTOSUGGEST_USE_ASYNC=1; export ZSH_AUTOSUGGEST_MANUAL_REBIND=1; export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20" \
        zsh-users/zsh-autosuggestions \
    blockf \
        zsh-users/zsh-completions

zinit wait lucid light-mode for \
  from'gh-r' \
  as'program' \
  mv'delta-* -> delta' \
  pick'delta/delta' \
  id-as'auto' \
  @dandavison/delta

zt 0a light-mode for \
    OMZP::kubectx \
    OMZP::kubectl \
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
    Valodim/zsh-curl-completion \
    zsh-users/zsh-history-substring-search \
  	rimraf/k \
    has'git' pick'init.zsh' atload'alias gi="git-ignore"' blockf \
  	laggardkernel/git-ignore \
    has'git-extras' \
    https://github.com/tj/git-extras/blob/master/etc/git-extras-completion.zsh \
    as"program" pick"bin/git-dsf" \
    zdharma-continuum/zsh-diff-so-fancy

zt 0b light-mode for \
  has'man' \
        ael-code/zsh-colored-man-pages \
  has'notify-send' atload'AUTO_NOTIFY_THRESHOLD=300; AUTO_NOTIFY_IGNORE+=( "cht.sh" "cht" "lazydocker" "lazygit" "tmux" "yarn" "vagrant ssh" )' \
        MichaelAquilina/zsh-auto-notify

# zinit ice wait"0b" lucid
# zinit load rupa/z
# zinit ice as"program" cp"wd.sh -> wd" mv"_wd.sh -> _wd" atpull'!git reset --hard' pick"wd"
# zinit light mfaerevaag/wd
# zinit ice blockf wait"0" lucid
# zinit load zsh-users/zsh-history-substring-search


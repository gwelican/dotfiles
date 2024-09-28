export FD_OPTIONS='--type f --hidden --follow --exclude .git --exclude node_modules'
#export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."

export FZF_DEFAULT_OPTS="--height=50% --reverse --multi --inline-info --color=dark --color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe --color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef"
# zinit ice bindmap'^R ->;\ec ->' multisrc'shell/{completion,key-bindings}.zsh'
export FZF_DEFAULT_COMMAND="fd $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {} | head -500' --border"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
export FZF_TMUX_HEIGHT="30%"
export BAT_PAGER="less -R"

zstyle ':fzf-tab:complete:(cd|ls|exa|bat|cat|emacs|nano|vi|vim):*' fzf-preview 'lsd -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'


zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap --border'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Preivew `git` commands
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
# zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
# 	   'case "$group" in
# 	"commit tag") git show --color=always $word ;;
# 	*) git show --color=always $word | delta ;;
# 	esac'

zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	   'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

atuin-setup() {
	if ! which atuin &> /dev/null; then; return 1; fi
	bindkey '^E' _atuin_search_widget

	export ATUIN_NOBIND="true"
	eval "$(atuin init "zsh")"
	fzf-atuin-history-widget() {
	    local selected num
	    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

	    local atuin_opts="--cmd-only --limit ${ATUIN_LIMIT:-5000}"
	    local fzf_opts=(
		--height=${FZF_TMUX_HEIGHT:-80%}
		--tac
		"-n2..,.."
		--tiebreak=index
		"--query=${LBUFFER}"
		"+m"
		"--bind=ctrl-d:reload(atuin search $atuin_opts -c $PWD),ctrl-r:reload(atuin search $atuin_opts)"
	    )

	    selected=$(
		eval "atuin search ${atuin_opts}" | fzf "${fzf_opts[@]}"
	    )
	    local ret=$?
	    if [ -n "$selected" ]; then
		# the += lets it insert at current pos instead of replacing
		LBUFFER+="${selected}"
	    fi
	    zle reset-prompt
	    return $ret
	}
	zle -N fzf-atuin-history-widget
        bindkey '^R' fzf-atuin-history-widget


}
atuin-setup

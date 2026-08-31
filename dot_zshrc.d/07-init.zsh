# mise
eval "$(mise activate zsh)"
eval "$(direnv hook zsh)"

# init
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# fabric
if [ -f "/home/gwelican/.config/fabric/fabric-bootstrap.inc" ]; then . "/home/gwelican/.config/fabric/fabric-bootstrap.inc"; fi


# lean-ctx shell hook — begin
if [ -f "$HOME/.config/lean-ctx/shell-hook.zsh" ]; then
  echo "lean-ctx shell hook loaded from $HOME/.config/lean-ctx/shell-hook.zsh"
. "$HOME/.config/lean-ctx/shell-hook.zsh"
fi
# lean-ctx shell hook — end


# >>> lean-ctx proxy env >>>
export ANTHROPIC_BASE_URL="http://127.0.0.1:4444"
export OPENAI_BASE_URL="http://127.0.0.1:4444/v1"
export GEMINI_API_BASE_URL="http://127.0.0.1:4444"
# Grok proxy env omitted: run `grok login` (subscription) or set XAI_API_KEY to route Grok through lean-ctx
# Command Code omitted (no ~/.commandcode auth — run `cmd login` or set COMMAND_CODE_API_KEY)
# <<< lean-ctx proxy env <<<

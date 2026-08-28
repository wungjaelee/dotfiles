# If this file gets too long, consider splitting sections into ~/.zsh/*.zsh and sourcing them here.

# plugins
if [[ "$(uname -s)" == "Darwin" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
  source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
else
  source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source "/usr/share/doc/fzf/examples/key-bindings.zsh"
  source "/usr/share/doc/fzf/examples/completion.zsh"
fi
eval "$(starship init zsh)"

# keybindings
bindkey '^f' autosuggest-accept

function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select

# exports
export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"

# aliases
alias vim="nvim"

# functions
obs() {
  local dest=$HOME/Documents/Obsidian/$(basename "$1")
  cp "$1" $dest
  [[ "$(uname -s)" == "Darwin" ]] && open -a Obsidian "$dest"
}

eval "$(zoxide init zsh)"

# machine-local overrides
[[ -f ~/.zsh/local.zsh ]] && source ~/.zsh/local.zsh

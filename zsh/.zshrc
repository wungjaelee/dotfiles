# If this file gets too long, consider splitting sections into ~/.zsh/*.zsh and sourcing them here.

# plugins
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
eval "$(starship init zsh)"

# keybindings
bindkey '^f' autosuggest-accept

# exports
export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"

# aliases
alias vim="nvim"

# functions
obs() {
  local dest=$HOME/Documents/Obsidian/$(basename "$1")
  cp "$1" $dest
  open -a Obsidian "$dest"
}

# machine-local overrides
[[ -f ~/.zsh/local.zsh ]] && source ~/.zsh/local.zsh

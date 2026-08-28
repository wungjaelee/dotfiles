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

# starship: git_status's dirty-file scan can be too slow in large repos —
# swap to a lighter config (git_status disabled) while inside any path listed
# in $_starship_monorepo_paths. Which paths count as "large" is machine/work-
# specific, so that array is set (if at all) in ~/.zsh/local.zsh, not here.
_starship_check_monorepo() {
  local dir="$PWD" p
  for p in $_starship_monorepo_paths; do
    if [[ "$dir" == "$p" || "$dir" == "$p"/* ]]; then
      export STARSHIP_CONFIG="$HOME/.config/starship-monorepo.toml"
      return
    fi
  done
  unset STARSHIP_CONFIG
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _starship_check_monorepo

# keybindings
bindkey -e    # force emacs keymap — must come before any other bindkey calls, since it resets bindings
stty -ixon    # disable terminal flow control so ^Q/^S below reach zsh instead of pausing/resuming output

# emacs keymap defaults worth knowing (already bound, no need to redeclare):
#   ^A / ^E         beginning / end of line        ^K      kill to end of line
#   ^B / ^F         back / forward one char        ^U      kill whole line
#   ^D              delete char (or list-exit)     ^W      delete word back
#   ^Y              yank (paste) last kill         ^R      incremental history search (fzf overrides this above)
#   Alt-B / Alt-F   back / forward one word        Alt-D   delete word forward

bindkey '^q' beginning-of-line  # ^A is herdr's prefix key and never reaches zsh inside herdr, so use ^Q
                                # instead (this shadows zsh's rarely-used default ^Q binding, push-line)
bindkey '^f' autosuggest-accept

function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
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

#!/bin/bash
# NOTE: This script is written and tested for macOS only.
# Behavior on Linux or Windows (WSL) has not been verified — proceed with caution.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Helpers ──────────────────────────────────────────────────────────────────

print_step() { echo "  → $1"; }

confirm() {
  read -r -p "$1 [y/N] " response
  [[ "$response" =~ ^[Yy]$ ]]
}

link_agent_file() {
  local src="$1"
  local dest="$2"
  if [[ -f "$dest" && ! -L "$dest" ]]; then
    print_step "  skipping $dest — real file exists, back it up and re-run."
    return
  fi
  ln -sfn "$src" "$dest"
}

# ── Intro ─────────────────────────────────────────────────────────────────────

echo ""
echo "dotfiles installer"
echo "────────────────────────────────────────"
echo "This script will:"
echo "  1. Install Homebrew (if not already installed)"
echo "  2. Install GNU Stow via Homebrew (if not already installed)"
echo "  3. Install all packages listed in Brewfile"
echo "  4. Symlink $DOTFILES_DIR to ~/.dotfiles"
echo "  5. Symlink dotfiles from $DOTFILES_DIR to $HOME"
echo "  6. Symlink agents/AGENTS.md to agent-specific locations to serve as global memory"
echo ""
echo "Existing dotfiles that conflict with symlinks will cause stow to abort."
echo "Back up or remove them before proceeding."
echo ""

confirm "Proceed?" || { echo "Aborted."; exit 0; }
echo ""

# ── Homebrew ──────────────────────────────────────────────────────────────────

if ! command -v brew &>/dev/null; then
  print_step "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for Apple Silicon Macs
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  print_step "Homebrew already installed, skipping."
fi

# ── Brewfile ──────────────────────────────────────────────────────────────────

if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
  print_step "Installing packages from Brewfile..."
  brew bundle --file "$DOTFILES_DIR/Brewfile"
else
  print_step "No Brewfile found, skipping package installation."
fi

# ── Stow ──────────────────────────────────────────────────────────────────────

if ! command -v stow &>/dev/null; then
  print_step "Installing GNU Stow..."
  brew install stow
else
  print_step "Stow already installed, skipping."
fi

# ── Symlink repo to ~/.dotfiles ───────────────────────────────────────────────

print_step "Symlinking $DOTFILES_DIR to ~/.dotfiles..."
ln -sfn "$DOTFILES_DIR" "$HOME/.dotfiles"

# ── Symlink dotfiles ──────────────────────────────────────────────────────────

print_step "Symlinking dotfiles..."
cd "$DOTFILES_DIR"

# Stow each top-level directory (skipping hidden dirs and non-directories)
for pkg in */; do
  pkg="${pkg%/}"
  print_step "  stow: $pkg"
  stow -t "$HOME" "$pkg"
done

# ── Agent memory ──────────────────────────────────────────────────────────────

print_step "Symlinking agent memory files..."
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.codex"
link_agent_file "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"  # Claude Code
link_agent_file "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"   # Codex

echo ""
echo "Done. Open a new shell for changes to take effect."

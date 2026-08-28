#!/bin/bash
# Tested on macOS and Debian Linux. Other platforms have not been verified — proceed with caution.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

NO_INTERACTIVE=false
for arg in "$@"; do
  case "$arg" in
    --no-interactive) NO_INTERACTIVE=true ;;
  esac
done

# ── Colors ────────────────────────────────────────────────────────────────────

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # no color

# ── Helpers ──────────────────────────────────────────────────────────────────

print_step() { echo "  → $1"; }
print_warn()  { echo -e "  ${YELLOW}⚠ $1${NC}"; }
print_error() { echo -e "  ${RED}✖ $1${NC}"; }

confirm() {
  read -r -p "$1 [y/N] " response
  [[ "$response" =~ ^[Yy]$ ]]
}

link_agent_file() {
  local src="$1"
  local dest="$2"
  if [[ -f "$dest" && ! -L "$dest" ]]; then
    print_warn "skipping $dest - real file exists, back it up and re-run."
    return
  fi
  ln -sfn "$src" "$dest"
}

# ── Intro ─────────────────────────────────────────────────────────────────────

echo ""
echo "dotfiles installer"
echo "────────────────────────────────────────"
echo "This script will:"
echo "  1. Install packages (Homebrew + Brewfile on macOS, apt + Aptfile on Linux)"
echo "  2. Install starship and gh (Linux only, not in apt)"
echo "  3. Symlink $DOTFILES_DIR to ~/.dotfiles"
echo "  4. Symlink dotfiles from $DOTFILES_DIR to $HOME"
echo "  5. Symlink agents/AGENTS.md to agent-specific locations"
echo ""
echo "Conflicting dotfiles will be skipped with a warning — they won't block the rest."
echo ""

if [[ "$NO_INTERACTIVE" != true ]]; then
  confirm "Proceed?" || { echo "Aborted."; exit 0; }
fi
echo ""

# ── Packages ──────────────────────────────────────────────────────────────────

if [[ "$OS" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    print_step "Homebrew already installed, skipping."
  fi

  if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    print_step "Installing packages from Brewfile..."
    brew bundle --file "$DOTFILES_DIR/Brewfile"
  fi

elif [[ "$OS" == "Linux" ]]; then
  print_step "Installing packages from Aptfile..."
  sudo apt-get update -qq
  sudo apt-get install -y $(grep -v '^\s*#' "$DOTFILES_DIR/Aptfile" | tr '\n' ' ')

  # gh — not in apt, install via official script
  if ! command -v gh &>/dev/null; then
    print_step "Installing gh..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
    sudo apt-get update -qq && sudo apt-get install -y gh
  else
    print_step "gh already installed, skipping."
  fi

  # starship — not in apt, install via official script
  if ! command -v starship &>/dev/null; then
    print_step "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
  else
    print_step "starship already installed, skipping."
  fi

  # herdr — not in apt, install via official script
  if ! command -v herdr &>/dev/null; then
    print_step "Installing herdr..."
    curl -fsSL https://herdr.dev/install.sh | sh
  else
    print_step "herdr already installed, skipping."
  fi

  # pet — not in apt, and release assets embed the version in the filename,
  # so resolve the latest tag via the GitHub API first.
  if ! command -v pet &>/dev/null; then
    print_step "Installing pet..."
    pet_version=$(curl -fsSL https://api.github.com/repos/knqyf263/pet/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    curl -LO "https://github.com/knqyf263/pet/releases/download/${pet_version}/pet_${pet_version#v}_linux_amd64.tar.gz"
    tar xzf "pet_${pet_version#v}_linux_amd64.tar.gz" pet
    sudo mv pet /usr/local/bin/pet
    rm "pet_${pet_version#v}_linux_amd64.tar.gz"
  else
    print_step "pet already installed, skipping."
  fi

  # yazi — not in apt, use latest binary from GitHub. musl build avoids
  # GLIBC version mismatches on older distros (e.g. Debian stable's glibc
  # trails the gnu build's requirement).
  if ! command -v yazi &>/dev/null; then
    print_step "Installing yazi..."
    curl -LO https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip
    unzip yazi-x86_64-unknown-linux-musl.zip
    sudo mv yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/yazi
    sudo mv yazi-x86_64-unknown-linux-musl/ya /usr/local/bin/ya
    rm -rf yazi-x86_64-unknown-linux-musl yazi-x86_64-unknown-linux-musl.zip
  else
    print_step "yazi already installed, skipping."
  fi

  # neovim — apt ships old versions, use latest stable binary from GitHub
  if ! command -v nvim &>/dev/null; then
    print_step "Installing neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    tar xzf nvim-linux-x86_64.tar.gz
    sudo mv nvim-linux-x86_64 /opt/nvim
    sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm nvim-linux-x86_64.tar.gz
  else
    print_step "neovim already installed, skipping."
  fi
fi

# ── Stow ──────────────────────────────────────────────────────────────────────

if ! command -v stow &>/dev/null; then
  print_step "Installing GNU Stow..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install stow
  else
    sudo apt-get install -y stow
  fi
else
  print_step "Stow already installed, skipping."
fi

# ── Symlink repo to ~/.dotfiles ───────────────────────────────────────────────

print_step "Symlinking $DOTFILES_DIR to ~/.dotfiles..."
ln -sfn "$DOTFILES_DIR" "$HOME/.dotfiles"

# ── Symlink dotfiles ──────────────────────────────────────────────────────────

print_step "Symlinking dotfiles..."
cd "$DOTFILES_DIR"

for pkg in */; do
  pkg="${pkg%/}"
  [[ "$pkg" == "agents" ]] && continue
  stow_output=$(stow -t "$HOME" "$pkg" 2>&1) && print_step "  stow: $pkg" || {
    print_warn "skipping $pkg - conflicts with existing files:"
    echo "$stow_output" | sed 's/^/      /'
  }
done

# ── Pet config ────────────────────────────────────────────────────────────────
# Generated rather than stowed: pet's snippetfile setting must be a literal,
# already-resolved absolute path (it doesn't expand ~ or $HOME), so a single
# committed config.toml can't work across machines with different $HOME.

if [[ ! -f "$HOME/.config/pet/config.toml" ]]; then
  print_step "Writing pet config..."
  mkdir -p "$HOME/.config/pet"
  cat > "$HOME/.config/pet/config.toml" <<EOF
[General]
  editor      = "nvim"
  column      = 40
  selectcmd   = "fzf"
  snippetfile = "$HOME/.config/pet/snippet.toml"
EOF
  touch "$HOME/.config/pet/snippet.toml"  # pet errors instead of creating this itself
else
  print_step "pet config already exists, skipping."
fi

# ── Agent memory ──────────────────────────────────────────────────────────────

print_step "Symlinking agent memory files..."
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.codex"
link_agent_file "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"  # Claude Code
link_agent_file "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"   # Codex

# Repo-level agent instructions — CLAUDE.md is a relative symlink to AGENTS.md
if [[ ! -e "$DOTFILES_DIR/CLAUDE.md" ]]; then
  print_step "Symlinking CLAUDE.md to AGENTS.md in dotfiles repo..."
  ln -s AGENTS.md "$DOTFILES_DIR/CLAUDE.md"
else
  print_step "CLAUDE.md already exists, skipping."
fi

echo ""
echo "Done. Run source ~/.zshrc for changes to take effect."

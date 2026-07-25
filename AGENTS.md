# Dotfiles Agent Instructions

This is a personal dotfiles repo managed with stow + Brewfile/Aptfile + install.sh.

## Structure

- Each top-level directory (except `agents/`) is a stow package — its contents get symlinked to `~`
- `Brewfile` — macOS packages (Homebrew)
- `Aptfile` — Linux packages (Debian apt), should mirror Brewfile
- `install.sh` — bootstraps a new machine (packages, stow, agent memory symlinks)
- `agents/AGENTS.md` — global agent instructions symlinked to ~/.claude/CLAUDE.md

## Guidelines

- When adding a new package, always update both Brewfile and Aptfile to keep them in sync
- Packages not available in apt (neovim, yazi, gh, starship, herdr) are handled via manual install blocks in install.sh
- Do not stow the `agents/` directory — it is handled manually by install.sh
- Neovim plugins live in `neovim/.config/nvim/lua/plugins/` and are auto-loaded by lazy.nvim
- Machine-specific config (LSP servers, local overrides) goes in gitignored local files, not committed config

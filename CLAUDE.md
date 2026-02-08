# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS. The shell environment is **Fish shell** with Starship prompt and mise (asdf Rust clone) for runtime management.

## Key Commands

### Install/Update All Packages
```bash
brew bundle --file=~/.dotfiles/Brewfile
# or use alias:
bb
```

### Full System Update
```bash
update  # runs: sudo softwareupdate -i -a && brew update && brew upgrade && brew cleanup
```

### Reload Configurations
- Fish config: `source ~/.config/fish/config.fish`
- Tmux config: `prefix + r` (prefix is Ctrl-a)

## File Structure (GNU Stow packages)

Files are organized into Stow packages. Each package mirrors the target path relative to `$HOME`:

| Package | Contents | Symlinks to |
|---------|----------|-------------|
| `git/` | `.gitconfig`, `.gitignore` | `~/.gitconfig`, `~/.gitignore` |
| `fish/` | `config.fish`, `exports.fish`, `aliases.fish`, `activate.fish` | `~/.config/fish/` |
| `tmux/` | `.tmux.conf` | `~/.tmux.conf` |
| `ghostty/` | `config` | `~/.config/ghostty/config` |

All packages are managed by `stow --no-folding -R` via `bootstrap.sh`.

### Bootstrap

```bash
./bootstrap.sh  # idempotent — safe to re-run
```

## Modern CLI Replacements

This setup replaces standard Unix tools with modern alternatives. When working in this environment:

- `cat` → `bat` (syntax highlighting)
- `ls` → `eza` (better formatting)
- `find` → `fd` (faster, simpler syntax)
- `grep` → `rg` (ripgrep)
- `sed` → `sd` (modern find/replace)
- `cd` → `z` (zoxide, smart jumping)
- `rm` → `trash` (safe deletion to trash)
- `ps` → `procs`
- `top`/`htop` → `btop`
- `du` → `dua`
- `vim`/`vi` → `nvim`

## Git Configuration Notes

- Default branch: `main`
- Auto-setup rebase on pull
- Auto-prune on fetch
- GitHub auth via `gh` CLI
- Key aliases: `lg` (pretty log graph), `clean-local` (remove gone branches), `rebase-branch` (interactive rebase from main)

## Tmux Configuration

- Prefix: `Ctrl-a` (not default Ctrl-b)
- Vi mode enabled
- Pane navigation: `prefix + h/j/k/l`
- Window switching: `F1-F5` for windows 1-5
- Uses TPM (Tmux Plugin Manager) with Dracula theme

## Fish Shell Architecture

Fish config uses relative sourcing (`dirname` + `status --current-filename`) to load three files:
1. `fish/.config/fish/exports.fish` - PATH setup and environment variables
2. `fish/.config/fish/aliases.fish` - All command aliases organized by category
3. `fish/.config/fish/activate.fish` - Starship prompt and mise activation

## Runtime Management

- **mise** (formerly rtx) manages language versions
- **1Password CLI** integration for secrets (SSH agent, API keys)

## Secret Leak Detection

This repository uses **Gitleaks** and **TruffleHog** to prevent secrets from being committed:

### Quick Commands

```bash
# Scan current state for secrets
secret-scan

# Scan entire git history
secret-scan-history

# Verify detected secrets are valid (slower but accurate)
secret-scan-verified

# Manually run pre-commit hooks
hooks-run
```

### How It Works

- **Pre-commit hooks**: Automatically scan files before each commit using Gitleaks
- **Configuration**: `.gitleaks.toml` defines patterns and allowlists
- **Bypass** (not recommended): `git commit --no-verify` to skip hooks

### Files

- `.pre-commit-config.yaml` - Hook configuration
- `.gitleaks.toml` - Gitleaks detection rules and allowlists
- `.gitignore` - Excludes scan reports from version control

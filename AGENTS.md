# AGENTS.md

Instructions for AI coding agents (Claude Code, Pi, Cursor, etc.) working in this repository.

## Repository Overview

Personal dotfiles repository for macOS (Fish shell, Ghostty, tmux, neovim). Managed with GNU Stow.

## Installation

### macOS

```bash
git clone https://github.com/<user>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh  # idempotent — safe to re-run
```

Bootstrap handles: Homebrew, Brewfile, Fish as default shell, stow symlinks, pre-commit hooks, mise runtimes, TPM, fisher plugins.

### VPS (Linux — subset only)

Only a subset applies: git, tmux, fish, atuin. No Homebrew, no macOS app configs.

```bash
sudo apt-get install -y git tmux fish
curl https://mise.run | sh
mise install
```

## Non-Obvious Path Conventions

- **Ghostty config (macOS):** Real path is `~/Library/Application Support/com.mitchellh.ghostty/config`. Convenience symlink at `~/.config/ghostty`. Source of truth is `~/.dotfiles/ghostty/.config/ghostty/config`.
- **lazygit config (macOS):** `~/Library/Application Support/lazygit/config.yml` — stow package mirrors this path.
- **Fish files:** `exports.fish`, `aliases.fish`, and `activate.fish` are **sourced** (not standalone) from `config.fish`, in that order.
- **Git local overrides:** `~/.gitconfig.local` is included by `.gitconfig` but intentionally untracked (see `git/gitconfig.local.example`).

## Don't Do

- **Don't commit secrets.** Pre-commit hooks run Gitleaks. 1Password CLI handles secrets.
- **Don't use `git commit --no-verify`** to skip secret scanning.
- **Don't install languages via brew** — they are managed by mise.
- **Don't use pipx or uv tool directly** — mise manages Python CLI tools via `"pipx:<package>"` entries.
- **Don't use `brew` on the VPS** — it's Linux with apt + mise.

## Architecture

### Stow Packages

All configs are organized as GNU Stow packages. Each directory mirrors `$HOME`:

```
git/  fish/  tmux/  tmuxinator/  ghostty/  aerospace/  1password/
atuin/  btop/  htop/  zed/  mise/  nvim/  lazygit/
```

Deployed via: `stow --no-folding -R <package>`

### Shell (Fish)

Fish config sources three files in order:
1. `exports.fish` — Homebrew prefix, SSH_AUTH_SOCK (1Password), locale, PATH
2. `aliases.fish` — Modern CLI replacements, abbreviations, commands
3. `activate.fish` — Starship prompt, mise activation, atuin, 1Password plugins

Fisher manages plugins (gitnow, fzf.fish, zoxide.fish, grc, replay). Plugin list tracked in `fish_plugins`.

### tmux

- **Prefix:** `Ctrl-a`
- **Vi mode** enabled
- **Pane nav:** `prefix + h/j/k/l` and `C-h/j/k/l` (vim-tmux-navigator)
- **Window switching:** `F1-F5`
- **Plugins:** TPM, vim-tmux-navigator, tmux-yank, tmux-resurrect, tmux-continuum, Dracula theme

### Git

- Default branch: `main`
- Auto-setup rebase on pull, auto-prune on fetch
- `push.autoSetupRemote = true`
- Auth via `gh` CLI

### Package Management

| Layer | Tool | What it manages | Config |
|-------|------|----------------|--------|
| **Global CLI tools** | Homebrew (`brew bundle`) | bat, fd, rg, eza, fzf, lazygit, casks, fonts, Mac App Store | `Brewfile` |
| **Language runtimes & dev tools** | mise | node, python, go, rust, java, lua, uv, gh, jq, just, ruff, black | `mise/.config/mise/config.toml` |
| **Python CLI tools** | mise (`pipx:` backend) | poetry, shell-gpt, markitdown, etc. | `mise/.config/mise/config.toml` |

**Strategy:** Homebrew for global CLI tools. mise for language runtimes and dev tools. No overlap.

### Neovim

LazyVim distro. Config in `nvim/` stow package. Plugins managed by lazy.nvim in `~/.local/share/nvim/lazy/`.

## Key Commands

```bash
./bootstrap.sh                          # Full setup (idempotent)
brew bundle --file=~/.dotfiles/Brewfile # Install Homebrew packages (or alias: bb)
update                                  # Full system update (macOS + brew + mise)
mise install                            # Install all runtimes
fisher update                           # Update fish plugins
source ~/.config/fish/config.fish       # Reload fish config
# Reload tmux: prefix + r
```

## Secret Scanning

```bash
secret-scan           # Scan current state
secret-scan-history   # Scan entire git history
secret-scan-verified  # Verify detected secrets are real
hooks-run             # Manually run pre-commit hooks
```

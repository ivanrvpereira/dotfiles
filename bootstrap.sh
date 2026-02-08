#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
REPO="https://github.com/ivanrvpereira/dotfiles.git"
STOW_PACKAGES=(git tmux tmuxinator fish ghostty aerospace atuin btop htop zed mise nvim lazygit)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# ─── Pre-flight checks ───────────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || error "This script is macOS-only"

# ─── Xcode Command Line Tools ────────────────────────────────────
if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    info "Waiting for Xcode CLT installation to complete..."
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    info "Xcode Command Line Tools installed"
fi

# ─── Homebrew ─────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    info "Homebrew already installed"
fi

# ─── Clone dotfiles ──────────────────────────────────────────────
if [[ ! -d "$DOTFILES" ]]; then
    info "Cloning dotfiles..."
    git clone "$REPO" "$DOTFILES"
else
    info "Dotfiles already cloned at $DOTFILES"
fi
cd "$DOTFILES"

# ─── Brew Bundle ──────────────────────────────────────────────────
info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES/Brewfile" --no-lock

# ─── Fish as default shell ────────────────────────────────────────
FISH_PATH="$(which fish)"
if ! grep -qF "$FISH_PATH" /etc/shells; then
    info "Adding Fish to /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$FISH_PATH" ]]; then
    info "Setting Fish as default shell..."
    chsh -s "$FISH_PATH"
else
    info "Fish is already the default shell"
fi

# ─── Config directories ──────────────────────────────────────────
info "Ensuring config directories exist..."
mkdir -p ~/.config/fish ~/.config/ghostty ~/.config/tmuxinator ~/.ssh
chmod 700 ~/.ssh

# ─── Stow packages ───────────────────────────────────────────────
info "Stowing dotfile packages..."
stow --no-folding -R "${STOW_PACKAGES[@]}"

# ─── Pre-commit hooks ────────────────────────────────────────────
if [[ -f "$DOTFILES/.pre-commit-config.yaml" ]]; then
    info "Installing pre-commit hooks..."
    pre-commit install
fi

# ─── Mise runtimes ────────────────────────────────────────────────
if command -v mise &>/dev/null; then
    info "Installing mise tool versions..."
    mise install --yes 2>/dev/null || warn "No .mise.toml found (add one for managed runtimes)"
fi

# ─── TPM (Tmux Plugin Manager) ───────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    info "TPM already installed"
fi

# ─── Fisher plugins ────────────────────────────────────────────
if command -v fish &>/dev/null; then
    if ! fish -c 'type -q fisher' 2>/dev/null; then
        info "Installing Fisher..."
        fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    fi
    info "Installing Fish plugins..."
    fish -c 'fisher update' 2>/dev/null || warn "Fisher update failed (run manually: fisher update)"
fi

# ─── Done ─────────────────────────────────────────────────────────
echo ""
info "Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal (or restart your shell)"
echo "  2. Run 'tmux' then press prefix + I to install tmux plugins"
echo "  3. Copy git/gitconfig.local.example to ~/.gitconfig.local and fill in your details"
echo "  4. Run 'auth' to load ephemeral secrets (1Password)"
echo ""

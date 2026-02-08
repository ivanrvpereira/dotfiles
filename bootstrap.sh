#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
STOW_PACKAGES=(git tmux tmuxinator fish ghostty aerospace 1password atuin btop htop zed mise nvim lazygit)

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

if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Press any key after Xcode CLT installation completes..."
    read -n 1 -s
fi

# ─── Homebrew ─────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    info "Homebrew already installed"
fi

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

# ─── Remove old/broken symlinks ──────────────────────────────────
info "Removing old symlinks..."
OLD_SYMLINKS=(
    ~/.gitconfig ~/.gitignore ~/.tmux.conf
    ~/.curlrc ~/.inputrc ~/.wgetrc ~/.direnvrc
    ~/.config/direnv/direnvrc
    ~/.ackrc ~/.agignore ~/.hgignore ~/.hgrc
)
for link in "${OLD_SYMLINKS[@]}"; do
    [[ -L "$link" ]] && rm "$link" && info "  Removed $link"
done

# ─── Stow packages ───────────────────────────────────────────────
info "Stowing dotfile packages..."
cd "$DOTFILES"
stow --no-folding -R "${STOW_PACKAGES[@]}"

# ─── Pre-commit hooks ────────────────────────────────────────────
if [[ -f "$DOTFILES/.pre-commit-config.yaml" ]]; then
    info "Installing pre-commit hooks..."
    cd "$DOTFILES"
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

# ─── Done ─────────────────────────────────────────────────────────
echo ""
info "Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal (or restart your shell)"
echo "  2. Run 'tmux' then press prefix + I to install tmux plugins"
echo "  3. Copy gitconfig.local.example to ~/.gitconfig.local and fill in your details"
echo "  4. Run 'auth' to load ephemeral secrets (1Password)"
echo ""

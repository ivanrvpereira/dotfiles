#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
REPO="https://github.com/ivanrvpereira/dotfiles.git"
STOW_PACKAGES=(shell git tmux tmuxinator fish ghostty aerospace atuin btop htop zed mise nvim lazygit launchd)

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

# ─── Hostname ───────────────────────────────────────────────────
current_hostname=$(scutil --get ComputerName 2>/dev/null || hostname -s)
echo ""
read -rp "Hostname [$current_hostname]: " new_hostname
HOSTNAME_TO_SET="${new_hostname:-$current_hostname}"
export HOSTNAME_TO_SET

# ─── Machine type ───────────────────────────────────────────────
echo ""
read -rp "Is this a headless machine (SSH-only, no GUI)? [y/N] " headless_choice
if [[ "$headless_choice" =~ ^[Yy]$ ]]; then
    HEADLESS=true
    info "Configuring as headless (no 1Password GUI dependency)"
else
    HEADLESS=false
fi

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
    info "Dotfiles already cloned at $DOTFILES, pulling latest..."
    git -C "$DOTFILES" pull --rebase
fi
cd "$DOTFILES"

# ─── Brew Bundle ──────────────────────────────────────────────────
info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES/Brewfile"

# ─── Personal tools (optional) ──────────────────────────────────
echo ""
read -rp "Install personal tools (Spotify, Slack, Zoom, etc.)? [y/N] " install_personal
if [[ "$install_personal" =~ ^[Yy]$ ]]; then
    info "Installing personal packages from Brewfile.personal..."
    brew bundle --file="$DOTFILES/Brewfile.personal"
else
    info "Skipping personal tools"
fi

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
mkdir -p ~/.config/fish/conf.d ~/.config/ghostty ~/.config/tmuxinator ~/.ssh
chmod 700 ~/.ssh

# ─── Headless machine flag ──────────────────────────────────────
if $HEADLESS; then
    info "Setting headless machine flags..."
    echo 'set -gx DOTFILES_HEADLESS 1' > ~/.config/fish/conf.d/machine.fish
    touch ~/.config/headless  # for .profile / non-fish shells
else
    rm -f ~/.config/fish/conf.d/machine.fish ~/.config/headless
fi

# ─── Stow packages ───────────────────────────────────────────────
info "Stowing dotfile packages..."
stow --no-folding -R "${STOW_PACKAGES[@]}"

# ─── Launch Agents ────────────────────────────────────────────────
info "Loading launch agents..."
for plist in "$HOME"/Library/LaunchAgents/com.ivanpereira.*.plist; do
    [[ -f "$plist" ]] || continue
    label="$(basename "$plist" .plist)"
    launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" "$plist"
    info "  Loaded $label"
done

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

# ─── Global npm packages ─────────────────────────────────────────
if command -v npm &>/dev/null && [[ -f "$DOTFILES/npm-packages" ]]; then
    info "Installing global npm packages..."
    while IFS= read -r pkg; do
        [[ "$pkg" =~ ^#|^$ ]] && continue
        npm install -g "$pkg"
    done < "$DOTFILES/npm-packages"
fi

# ─── TPM (Tmux Plugin Manager) ───────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    info "TPM already installed"
fi
info "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins" || warn "TPM plugin install failed (run 'prefix + I' inside tmux)"

# ─── Fisher plugins ────────────────────────────────────────────
if command -v fish &>/dev/null; then
    if ! fish -c 'type -q fisher' 2>/dev/null; then
        info "Installing Fisher..."
        fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
    fi
    info "Installing Fish plugins..."
    fish -c 'fisher update' 2>/dev/null || warn "Fisher update failed (run manually: fisher update)"
fi

# ─── SSH key (headless only) ─────────────────────────────────────
if $HEADLESS; then
    echo ""
    read -rp "Generate a new SSH key or use an existing one? [g/E] " ssh_choice
    if [[ "$ssh_choice" =~ ^[Gg]$ ]]; then
        read -rp "  Key name [id_ed25519]: " key_name
        key_name="${key_name:-id_ed25519}"
        SSH_KEY_PATH="$HOME/.ssh/$key_name"
        if [[ ! -f "$SSH_KEY_PATH" ]]; then
            info "Generating SSH key (no passphrase — FileVault protects at rest)..."
            ssh-keygen -t ed25519 -N "" -f "$SSH_KEY_PATH" -C "$HOSTNAME_TO_SET"
        else
            info "Key $SSH_KEY_PATH already exists, reusing"
        fi
    else
        read -rp "  Path to existing SSH key [~/.ssh/id_ed25519]: " key_path
        key_path="${key_path:-$HOME/.ssh/id_ed25519}"
        SSH_KEY_PATH="${key_path/#\~/$HOME}"
        [[ -f "$SSH_KEY_PATH" ]] || error "Key not found: $SSH_KEY_PATH"
    fi
    info "Public key:"
    cat "${SSH_KEY_PATH}.pub"
    echo ""
    echo "  Add this key to GitHub as both Authentication and Signing key:"
    echo "  https://github.com/settings/keys"
    echo ""
    read -rp "  Press Enter when done..."
fi

# ─── Git identity ─────────────────────────────────────────────────
if [[ ! -f "$HOME/.gitconfig.local" ]]; then
    info "Creating ~/.gitconfig.local..."
    if $HEADLESS; then
        cat > "$HOME/.gitconfig.local" <<EOF
[user]
	signingkey = $SSH_KEY_PATH
EOF
    else
        echo "  Add your 1Password SSH signing key (from 1Password > SSH Keys > Public Key)"
        read -rp "  SSH signing key (ssh-ed25519 ...): " signing_key
        cat > "$HOME/.gitconfig.local" <<EOF
[user]
	signingkey = $signing_key
[gpg "ssh"]
	program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
EOF
    fi
    info "Created ~/.gitconfig.local"
else
    info "~/.gitconfig.local already exists"
fi

if [[ ! -f "$HOME/.gitconfig.work" ]]; then
    read -rp "Set up work git identity? (y/N): " setup_work
    if [[ "$setup_work" =~ ^[Yy]$ ]]; then
        read -rp "  Work email: " work_email
        cat > "$HOME/.gitconfig.work" <<EOF
[user]
	email = $work_email
EOF
        info "Created ~/.gitconfig.work"
    fi
else
    info "~/.gitconfig.work already exists"
fi

# ─── Headless secrets (one-time export from 1Password) ───────────
if $HEADLESS && [[ ! -f "$HOME/.secrets" ]]; then
    echo ""
    info "Exporting secrets from 1Password to ~/.secrets..."
    echo "  You need to sign in to 1Password CLI once."
    echo "  Run: eval \$(op signin)"
    read -rp "  Press Enter when signed in..."

    exa_key=$(op read "op://development/exa-api-key/credential" 2>/dev/null) || true
    if [[ -n "$exa_key" ]]; then
        cat > "$HOME/.secrets" <<EOF
# Machine secrets — exported from 1Password during bootstrap
# chmod 600, not in dotfiles repo, FileVault protects at rest
set -gx EXA_API_KEY $exa_key
EOF
        chmod 600 "$HOME/.secrets"
        info "Created ~/.secrets with exported secrets"
    else
        warn "Could not read secrets from 1Password — create ~/.secrets manually"
        cat > "$HOME/.secrets" <<'EOF'
# Machine secrets — add manually
# set -gx EXA_API_KEY your-key-here
EOF
        chmod 600 "$HOME/.secrets"
    fi
fi

# ─── macOS defaults ──────────────────────────────────────────────
echo ""
read -rp "Apply macOS defaults (keyboard, trackpad, Dock, Finder, etc.)? [Y/n] " apply_macos
if [[ ! "$apply_macos" =~ ^[Nn]$ ]]; then
    info "Applying macOS defaults..."
    "$DOTFILES/macos/defaults.sh"
else
    info "Skipping macOS defaults (run ./macos/defaults.sh anytime)"
fi

# ─── Done ─────────────────────────────────────────────────────────
echo ""
info "Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Log out and back in (for keyboard/trackpad settings)"
echo "  2. Open a new terminal (or restart your shell)"
if $HEADLESS; then
    echo "  3. Verify: ssh -T git@github.com"
    echo "  4. Secrets are in ~/.secrets (edit to add more)"
else
    echo "  3. Run 'auth' to load ephemeral secrets (1Password)"
fi
echo ""

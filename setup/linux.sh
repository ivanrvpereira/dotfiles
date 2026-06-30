#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
# Linux / VPS setup — the non-macOS counterpart to ./bootstrap.sh
#
# Brings a Debian/Ubuntu box to parity for daily SSH dev use:
#   • modern CLI tools via apt (eza, bat, fd, rg, fzf, zoxide, delta,
#     atuin, neovim, grc)
#   • the few tools apt lacks via mise (lazygit, dua)
#   • fish plugins (fisher) + tmux plugins (TPM)
#   • stow of the Linux-relevant dotfiles packages
#   • fish as the default shell
#
# Idempotent — safe to re-run. Assumes the repo is already cloned to
# ~/.dotfiles and mise is installed (curl https://mise.run | sh).
# ─────────────────────────────────────────────────────────────────
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
# Ensure user-space bins resolve even under a non-login shell (e.g. piped over ssh)
export PATH="$HOME/.local/bin:$PATH"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# ─── Pre-flight ──────────────────────────────────────────────────
[[ "$(uname)" == "Linux" ]] || error "Linux only — run ./bootstrap.sh on macOS"
command -v apt-get >/dev/null || error "This script expects Debian/Ubuntu (apt)"
[[ -d "$DOTFILES" ]] || error "Dotfiles not found at $DOTFILES — clone the repo first"

# ─── apt packages ────────────────────────────────────────────────
# Modern CLI tools. On Debian/Ubuntu `bat`/`fd-find` install as
# batcat/fdfind; aliases.fish probes both names, so no symlinks needed.
APT_PKGS=(
    git tmux fish stow curl unzip
    eza bat fd-find ripgrep fzf zoxide git-delta atuin neovim grc
)
info "Installing apt packages (sudo)..."
sudo apt-get update -qq
sudo apt-get install -y "${APT_PKGS[@]}"

# ─── mise + gap tools ────────────────────────────────────────────
if ! command -v mise >/dev/null; then
    info "Installing mise..."
    curl -fsSL https://mise.run | sh
fi
MISE="$(command -v mise || echo "$HOME/.local/bin/mise")"
# lazygit + dua aren't in apt — let mise manage them. `use -g` writes to
# this box's local ~/.config/mise/config.toml (not the shared repo config).
info "Installing mise gap tools (lazygit, dua)..."
"$MISE" use -g lazygit dua || warn "mise gap-tool install failed"
"$MISE" install -y || warn "mise install reported issues"

# ─── fish as default shell ───────────────────────────────────────
FISH="$(command -v fish)"
if ! grep -qxF "$FISH" /etc/shells; then
    info "Adding fish to /etc/shells..."
    echo "$FISH" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "${SHELL:-}" != "$FISH" ]]; then
    info "Setting fish as default shell..."
    sudo chsh -s "$FISH" "$USER" || warn "chsh failed — set fish manually"
fi

# ─── Stow the Linux subset ───────────────────────────────────────
# macOS-only packages (ghostty, aerospace, zed, launchd, lazygit, mise)
# are intentionally excluded. Stow is best-effort: a pre-existing real
# file (e.g. a hand-written ~/.config/atuin) is reported, never clobbered.
mkdir -p ~/.config/fish/conf.d
LINUX_PKGS=(fish git tmux atuin btop htop nvim)
info "Stowing Linux dotfiles packages..."
cd "$DOTFILES"
for pkg in "${LINUX_PKGS[@]}"; do
    [[ -d "$pkg" ]] || continue
    if stow --no-folding -R "$pkg" 2>/dev/null; then
        info "  stowed $pkg"
    else
        warn "  $pkg skipped (conflicting real file) — resolve manually then re-stow"
    fi
done

# ─── Fisher + fish plugins ───────────────────────────────────────
# NB: every `fish -c` redirects stdin from /dev/null. fisher reads from
# stdin internally; if this script is piped (e.g. `bash -s < linux.sh`),
# fisher would otherwise consume the rest of the script as plugin names.
if ! fish -c 'type -q fisher' </dev/null 2>/dev/null; then
    info "Installing fisher..."
    fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher' </dev/null
fi
info "Installing fish plugins (from fish_plugins)..."
fish -c 'fisher update' </dev/null || warn "fisher update failed — run 'fisher update' manually"

# ─── TPM + tmux plugins ──────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    info "Installing TPM..."
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
info "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins" </dev/null >/dev/null 2>&1 || warn "tmux plugin install failed — run 'prefix + I' inside tmux"

# ─── Done ────────────────────────────────────────────────────────
echo ""
info "Linux setup complete."
echo ""
echo "Next steps:"
echo "  • Open a fresh shell (or: exec fish) to pick up tools + plugins"
echo "  • atuin history sync (optional): 'atuin login' then 'atuin sync'"

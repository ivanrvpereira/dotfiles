# ─── Homebrew ─────────────────────────────────────────────────
# Hardcoded for Apple Silicon (avoids spawning `brew --prefix` on every shell)
set -gx HOMEBREW_PREFIX /opt/homebrew

# ─── PATH (from shared ~/.dotfiles/paths) ─────────────────────
# Reads paths file so entries are shared across shells
if test -f ~/.dotfiles/paths
    for line in (string match -v '#*' < ~/.dotfiles/paths | string trim | string match -v '')
        set -l expanded (string replace '~' "$HOME" -- $line | string replace '$HOME' "$HOME")
        test -d "$expanded"; and fish_add_path --prepend "$expanded"
    end
end

# ─── SSH Agent ───────────────────────────────────────────────
if not set -q DOTFILES_HEADLESS
    # 1Password SSH agent (GUI machines — requires Touch ID approval)
    set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
end
# Headless: uses system ssh-agent (default SSH_AUTH_SOCK)

# ─── Locale & editor ──────────────────────────────────────────
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR nvim
set -gx VISUAL nvim

# ─── Secrets ─────────────────────────────────────────────────
if set -q DOTFILES_HEADLESS
    # Headless: load from ~/.secrets (populated once during bootstrap)
    test -f ~/.secrets; and source ~/.secrets
else
    # GUI: load ephemeral secrets via 1Password (first shell triggers Touch ID)
    if test -s $TMPDIR/.exa-api-key
        set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
    else if status is-interactive
        op read "op://development/exa-api-key/credential" 2>/dev/null | read -l _key
        and test -n "$_key"
        and printf '%s' "$_key" > $TMPDIR/.exa-api-key
        and chmod 600 $TMPDIR/.exa-api-key
        and set -gx EXA_API_KEY "$_key"
    end
end

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

# ─── 1Password SSH Agent ─────────────────────────────────────
# Must use expanded path — tilde won't work
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# ─── Locale & editor ──────────────────────────────────────────
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR nvim

# ─── Ephemeral secrets (1Password, cleared on reboot) ─────────
# First terminal after reboot triggers one Touch ID prompt; all others are silent
if test -f $TMPDIR/.exa-api-key
    set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
else if status is-interactive
    op read "op://development/exa-api-key/credential" > $TMPDIR/.exa-api-key 2>/dev/null
    and chmod 600 $TMPDIR/.exa-api-key
    and set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
end

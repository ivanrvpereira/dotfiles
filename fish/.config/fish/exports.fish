# ─── Homebrew ─────────────────────────────────────────────────
# Detect Homebrew prefix (Apple Silicon: /opt/homebrew, Intel: /usr/local)
set -gx HOMEBREW_PREFIX (brew --prefix)

# uutils-coreutils (Rust rewrite of GNU coreutils)
fish_add_path --prepend $HOMEBREW_PREFIX/opt/uutils-coreutils/libexec/uubin

# ─── 1Password SSH Agent ─────────────────────────────────────
# Must use expanded path — tilde won't work
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# ─── Locale ───────────────────────────────────────────────────
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# ─── PATH additions (not managed by mise or Homebrew) ─────────
fish_add_path ~/.local/bin

# ─── Ephemeral secrets (1Password, cleared on reboot) ─────────
# First terminal after reboot triggers one Touch ID prompt; all others are silent
if test -f $TMPDIR/.exa-api-key
    set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
else if status is-interactive
    op read "op://development/exa-api-key/credential" > $TMPDIR/.exa-api-key 2>/dev/null
    and chmod 600 $TMPDIR/.exa-api-key
    and set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
end

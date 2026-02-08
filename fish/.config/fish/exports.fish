# Detect Homebrew prefix (Apple Silicon: /opt/homebrew, Intel: /usr/local)
set -gx HOMEBREW_PREFIX (brew --prefix)

# uutils-coreutils (Rust rewrite of GNU coreutils)
fish_add_path --prepend $HOMEBREW_PREFIX/opt/uutils-coreutils/libexec/uubin

# Load ephemeral secrets from TMPDIR (cleared on reboot)
# First terminal after reboot triggers one Touch ID prompt; all others are silent
if test -f $TMPDIR/.exa-api-key
    set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
else if status is-interactive
    op read "op://development/exa-api-key/credential" > $TMPDIR/.exa-api-key 2>/dev/null
    and chmod 600 $TMPDIR/.exa-api-key
    and set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
end

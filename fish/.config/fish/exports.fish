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

# ─── tmux-sessionizer (tms) ───────────────────────────────────
# Use the dotfiles-tracked config on every platform (macOS default
# lives under ~/Library/Application Support; this keeps it portable).
set -gx TMS_CONFIG_FILE "$HOME/.config/tms/config.toml"

# ─── Secrets ─────────────────────────────────────────────────
if set -q DOTFILES_HEADLESS
    # Headless: load from ~/.secrets (populated once during bootstrap)
    test -f ~/.secrets; and source ~/.secrets
else
    # GUI: load only cached ephemeral secrets at startup. Run `auth` explicitly
    # when the cache is missing so agents do not trigger 1Password prompts.
    if test -s $TMPDIR/.exa-api-key
        set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
    end
end

# ─── Pi ──────────────────────────────────────────────────────
# Pin pi's agent dir so pi-subagents doesn't treat ~/.agents (config repo) as an agents dir
set -gx PI_CODING_AGENT_DIR "$HOME/.pi/agent"
set -gx PI_CACHE_RETENTION long

# ─── Sideshow ────────────────────────────────────────────────
# Keep the token out of dotfiles; load the private .env if present.
set -l sideshow_env "$HOME/.config/sideshow/cloudflare.env"
if test -f "$sideshow_env"
    for line in (string match -rv '^\s*(#|$)' < "$sideshow_env")
        set -l parts (string split -m1 '=' -- "$line")
        contains -- $parts[1] SIDESHOW_URL SIDESHOW_TOKEN; and set -gx $parts[1] $parts[2]
    end
end

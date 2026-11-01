#############################################################
# MODERN CLI REPLACEMENTS (bind only when the tool exists)
#############################################################
# Each alias is guarded so a machine missing the modern tool
# (e.g. a minimal VPS) keeps a working coreutils command instead
# of a broken alias. Debian/Ubuntu rename some binaries, so we
# probe both names (bat/batcat, fd/fdfind).

# cat -> bat
if command -q bat
    alias cat='bat'
else if command -q batcat
    alias cat='batcat'
end

# find -> fd
if command -q fd
    alias find='fd'
else if command -q fdfind
    alias find='fdfind'
end

# cd -> zoxide (z/zi come from the zoxide.fish plugin)
if command -q zoxide
    alias cd='z'
    alias cdi='zi'
end

# du -> dua (interactive disk usage)
if command -q dua
    alias du='dua'
end

# Safe file operations
alias cp='cp -i'
alias mv='mv -i'

# ls -> eza, with a coreutils fallback so `ls` always works
if command -q eza
    alias ls='eza'
    alias l='eza -lbF --git'
    alias ll='eza -lbGF --git'
    alias la='eza -lbhHigUmuSa --time-style=long-iso --git'
    alias lt='eza --tree --level=2'
else
    alias l='ls -lF'
    alias ll='ls -lhF'
    alias la='ls -lAhF'
    alias lt='ls -R'
end

# Editor: prefer nvim, fall back to the system vim/vi
if command -q nvim
    alias vim='nvim'
    alias vi='nvim'
end

#############################################################
# ABBREVIATIONS (expand inline before execution)
#############################################################

# Git
abbr g git
abbr gs 'git status'
abbr ga 'git add'
abbr gc 'git commit'
abbr gp 'git push'
abbr gl 'git pull'
abbr gd 'git diff'
abbr lg lazygit
abbr mux tmuxinator

# Docker & Kubernetes
abbr d docker
abbr dco docker-compose
abbr k kubectl

# Navigation
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'

# Homebrew
abbr bb 'brew bundle --file=~/.dotfiles/Brewfile'

# Quick lookups
abbr myip 'curl -s https://ipinfo.io/ip'
abbr localip 'ipconfig getifaddr en0'
abbr weather 'curl wttr.in'
abbr speedtest speedtest-cli
abbr ports 'netstat -tulan'

#############################################################
# COMMANDS
#############################################################

# macOS
alias flush="sudo dscacheutil -flushcache; and sudo killall -HUP mDNSResponder"
alias privacy="open x-apple.systempreferences:com.apple.preference.security"
alias cleanup='fd -H -I ".DS_Store" -x /bin/rm {}'
alias search='rg -i'

# System update
alias update='update-system && update-agents'
alias update-agents='~/.dotfiles/bin/update-agents && ~/.agents/bin/sync --yes'

# Homebrew check
alias brewcheck='brew bundle dump --force --file=/tmp/Brewfile.current && diff ~/.dotfiles/Brewfile /tmp/Brewfile.current | grep "^>" | sd "^> " ""; rm -f /tmp/Brewfile.current'

# AI & tools
alias claudeyolo='claude --dangerously-skip-permissions'
alias cly=claudeyolo
alias codexyolo='codex --dangerously-bypass-approvals-and-sandbox'
if set -q DOTFILES_HEADLESS
    alias ubi='ubi'
else
    alias ubi='op run -- ubi'
end
# For older projects whose .env holds op:// references. Do not let mise load such a file
# (`_.file`): mise sets its variables again at every prompt and undoes `opx`.
# A .env mounted by 1Password Environments needs neither: see ~/code/DEV-SETUP.md.
if not set -q DOTFILES_HEADLESS
    # pi with ./.env (if present) loaded and its op:// references resolved, for pi only
    function opi --wraps=pi --description 'pi with ./.env loaded and op:// refs resolved'
        set -l runargs
        test -f .env; and set runargs --env-file .env
        op run $runargs --no-masking -- pi $argv
    end

    # Export every variable in ./.env (or the given file) into the current shell, with
    # op:// references resolved by 1Password. One op prompt. Values stay in memory until
    # the shell exits or `opx -u` removes every variable that opx loaded in this shell.
    function opx --description 'Export all vars from .env (or given file), op:// refs resolved; -u unloads'
        argparse u/unload -- $argv; or return 1
        if set -q _flag_unload
            set -q __opx_loaded[1]; or begin; echo "Nothing loaded by opx in this shell"; return 0; end
            for n in $__opx_loaded
                set -eg $n
            end
            echo "Unloaded: $__opx_loaded"
            set -eg __opx_loaded
            return 0
        end
        set -l file .env
        test -n "$argv[1]"; and set file $argv[1]
        test -e $file; or begin; echo "No such file: $file"; return 1; end
        # Read the file once: a 1Password-mounted .env is a named pipe, and each read is a new request.
        set -l content (cat $file | string collect); or return 1
        set -l names (printf '%s\n' $content | string match -rg '^\s*(?:export\s+)?([A-Za-z_]\w*)\s*=')
        test (count $names) -gt 0; or begin; echo "No variables in $file"; return 1; end
        # op run parses the dotenv text and resolves any op:// references (no 1Password call when there are none).
        # NUL-separated, so empty and multi-line values survive. Names are identifiers, so eval is safe.
        set -l values (printf '%s\n' $content | op run --env-file /dev/stdin --no-masking -- sh -c 'for n; do eval "v=\${$n-}"; printf "%s\0" "$v"; done' sh $names | string split0)
        test $pipestatus[1] -eq 0; or return 1
        test (count $values) -eq (count $names); or begin; echo "Resolved value count mismatch"; return 1; end
        for i in (seq (count $names))
            set -gx $names[$i] $values[$i]
            contains -- $names[$i] $__opx_loaded; or set -g __opx_loaded $__opx_loaded $names[$i]
        end
        echo "Loaded from $file: $names"
    end
end

# Authenticate ephemeral secrets (once per reboot, stored in TMPDIR)
function auth
    if set -q DOTFILES_HEADLESS
        echo "Headless machine — secrets loaded from ~/.secrets"
        test -f ~/.secrets; and source ~/.secrets
    else
        op read "op://development/exa-api-key/credential" 2>/dev/null | read -l _key
        or begin; echo "op read failed"; return 1; end
        test -n "$_key"; or begin; echo "Empty key returned"; return 1; end
        printf '%s' "$_key" > $TMPDIR/.exa-api-key
        chmod 600 $TMPDIR/.exa-api-key
        set -gx EXA_API_KEY "$_key"
        echo "Authenticated for this session"
    end
end

#############################################################
# SECRET DETECTION
#############################################################

alias secret-scan='gitleaks detect --source . --verbose --redact'
alias secret-scan-history='gitleaks git --source . --verbose --redact'
alias secret-scan-verified='trufflehog filesystem . --only-verified'
alias hooks-install='pre-commit install'
alias hooks-run='pre-commit run --all-files'

#############################################################
# MODERN CLI REPLACEMENTS
#############################################################

# Core command replacements
alias cat='bat' # Syntax highlighting
alias find='fd' # Faster, better syntax
alias grep='rg' # Ripgrep - much faster
alias sed='sd' # Modern find/replace
alias cd='z' # Smart jumping
alias cdi='zi' # Interactive selection
alias ps='procs' # Better process viewer
alias pst='procs --tree' # Process tree
alias top='btop' # Modern system monitor
alias htop='btop'
alias ping='gping' # Ping with graphs
alias du='dua' # Better du
alias dui='dua interactive' # Interactive disk usage
alias dus='dua --format binary --max-depth 1'

# Safe file operations
alias rm='trash' # Safe deletion
alias del='/bin/rm' # When you really need it
alias cp='cp -i' # Confirm before overwrite
alias mv='mv -i' # Confirm before overwrite

# ls/eza variations
alias ls='eza'
alias l='eza -lbF --git'
alias ll='eza -lbGF --git'
alias llm='eza -lbGd --git --sort=modified'
alias la='eza -lbhHigUmuSa --time-style=long-iso --git'
alias lS='eza -1'
alias lt='eza --tree --level=2'
alias l.="eza -a | grep -E '^\.'"

#############################################################
# EDITORS
#############################################################

alias vim='nvim'
alias vi='nvim'

#############################################################
# GIT & VERSION CONTROL
#############################################################

alias lg='lazygit'
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

#############################################################
# DOCKER & KUBERNETES
#############################################################

# Docker
alias d='docker'
alias dco='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias lzd='lazydocker'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias k9='k9s'
alias kdash='kdash'

#############################################################
# PYTHON & DEVELOPMENT
#############################################################

alias py='python3'
alias ipy='ipython'
alias pip='pip3'
alias dj='python manage.py'
alias pyserver='python -m http.server'
alias rmpyc="fd -e pyc -x rm {}"

#############################################################
# NAVIGATION & QUICK EDITS
#############################################################

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Config file shortcuts
alias fishconfig='nvim ~/.config/fish/config.fish'
alias aliases='nvim ~/.dotfiles/aliases.fish'
alias brewfile='nvim ~/.dotfiles/Brewfile'

# Important directory shortcuts (customize these!)
alias dotfiles='cd ~/.dotfiles'
alias dev='cd ~/work/src' # Or wherever you code
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias work='cd ~/work' # Add your common dirs

#############################################################
# HOMEBREW
#############################################################

alias bb='brew bundle --file=~/.dotfiles/Brewfile'
alias update='sudo softwareupdate -i -a && brew update && brew upgrade && brew cleanup'

#############################################################
# MACOS SPECIFIC
#############################################################

# System utilities
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true; and killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false; and killall Finder"
alias flush="sudo dscacheutil -flushcache; and sudo killall -HUP mDNSResponder"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

#############################################################
# NETWORK & SYSTEM MONITORING
#############################################################

# Network utilities
alias myip='curl -s https://ipinfo.io/ip'
alias localip='ipconfig getifaddr en0'
alias speedtest='speedtest-cli'
alias weather='curl wttr.in'
alias ports='netstat -tulan'

# System monitoring
alias memhog='command ps aux | sort -nk 4 | tail -10'
alias cpuhog='command ps aux | sort -nk 3 | tail -10'

#############################################################
# FILE OPERATIONS & SEARCH
#############################################################

alias search='rg -i' # Case-insensitive search
alias jsonsort='jq -S' # Sort JSON keys
alias jsonpp='jq .' # Pretty print JSON
alias xmlpp='xmllint --format -' # Pretty print XML
alias cleanup='fd -H -I ".DS_Store" -x rm {}'
alias map="xargs -n1" # Intuitive map function

#############################################################
# PRODUCTIVITY & MISC
#############################################################

# Quick commands
alias timestamp='date +%Y%m%d_%H%M%S'
alias week='date "+Week %V of %Y (%B %d)"'

# Special tools
alias claudeyolo='claude --dangerously-skip-permissions'
alias codexyolo='codex --dangerously-bypass-approvals-and-sandbox'

alias ubi='op run -- ubi'

# AI 
alias claudejira='MAX_MCP_OUTPUT_TOKENS=80000 claudeyolo --mcp-config ~/.mcp.jira.json'
alias claudejiraslack='MAX_MCP_OUTPUT_TOKENS=80000 claudeyolo --mcp-config ~/.mcp.jira.json ~/.mcp.slack.json'

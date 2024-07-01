cask_args appdir: '/Applications'

tap 'homebrew/bundle'
tap 'homebrew/services'
tap 'jesseduffield/lazygit'
tap 'koekeishiya/formulae'
tap 'kdash-rs/kdash'

# Pre-req's
brew "mas" # Mac App Store CLI - https://github.com/mas-cli/mas



# CLI Basics
brew 'aria2'        # Resuming download util (better wget)
brew 'bat'          # Output highlighting (better cat)
brew 'broot'        # Interactive directory navigation
brew 'ctags'        # Indexing of file info + headers
brew 'diff-so-fancy'# Readable file compares (better diff)
brew 'duf'          # Get info on mounted disks (better df)
brew 'entr'         # Run command whenever file changes
brew 'exiftool'     # Read, write and modify exif data
brew 'fzf'          # Fuzzy file finder and filtering
brew 'hyperfine'    # Benchmarking for arbitrary commands
brew 'jdupes'       # Duplicate file finder
brew 'just'         # Powerful command runner (better make)
brew 'jq'           # JSON parser, output and query files
brew 'most'         # Multi-window scroll pager (better less)
brew 'procs'        # Advanced process viewer (better ps)
brew 'ripgrep'      # Searching within files (better grep)
brew 'rsync'        # Fast incremental file transfer
brew 'sd'           # RegEx find and replace (better sed)
brew 'thefuck'      # Auto-correct miss-typed commands
brew 'tldr'         # Community-maintained docs (better man)
brew 'tokei'        # Count lines of code (better cloc)
brew 'tree'         # Directory listings as tree structure
brew 'trash-cli'    # Record and restore removed files
brew 'watch'        # Run commands periorically
brew 'xsel'         # Copy paste access to the X clipboard
brew 'zoxide'       # Auto-learning navigation (better cd)
brew 'fd'           # Better find

# CLI Monitoring and Performance Apps
brew 'bmon'         # Bandwidth utilization monitor 
brew 'ctop'         # Container metrics and monitoring
brew 'dog'          # DNS lookup client (better dig)
brew 'bpytop'       # Resource monitoring (like htop)
brew 'dua-cli'      # Disk usage analyzer and monitor (better du)
brew 'glances'      # Resource monitor + web and API
brew 'goaccess'     # Web log analyzer and viewer
brew 'gping'        # Interactive ping tool, with graph
brew 'speedtest-cli'# Command line speed test utility


# CLI Basics

# CLI Monitoring and Performance Apps
brew 'bmon'         # Bandwidth utilization monitor 
brew 'ctop'         # Container metrics and monitoring
brew 'dog'          # DNS lookup client (better dig)
brew 'bpytop'       # Resource monitoring (like htop)
brew 'dua-cli'      # Disk usage analyzer and monitor (better du)
brew 'glances'      # Resource monitor + web and API
brew 'goaccess'     # Web log analyzer and viewer
brew 'gping'        # Interactive ping tool, with graph
brew 'speedtest-cli'# Command line speed test utility


# CLI Development Suits
brew 'httpie'       # HTTP / API testing testing client
brew 'lazydocker'   # Full Docker management app
brew 'lazygit'      # Full Git management app
brew 'kdash'        # Kubernetes management
brew 'k9s'

# CLI External Sercvices
cask 'ngrok'        # Reverse proxy for sharing localhost
brew 'navi'         # Browse, search, read cheat sheets

#############################################################
# Software Development                                      #
#############################################################

# Development Apps
cask 'postman'        # HTTP API testing app

# Development Langs, Compilers, Package Managers and SDKs
brew 'gcc'            # GNU C++ compilers
brew 'go'             # Compiler for Go Lang
brew 'node'           # Node.js
brew 'openjdk'        # Java development kit
brew 'python'         # Python interpreter
brew 'rust'           # Rust language
brew 'lua'            # Lua interpreter
brew 'luarocks'       # Package manager for Lua

# DevOps

# Development Utils
brew 'mise'           # Runtime manager (asdf rust clone)
brew 'gh'             # Interact with GitHub PRs, issues, repos
brew 'git-extras'     # Extra git commands for common tasks
brew 'terminal-notifier' # Trigger Mac notifications from terminal
brew 'tig'            # Text-mode interface for git
brew 'watchman'       # Watch for changes and reload dev server


# Productivity
#cask "microsoft-remote-desktop"

#############################################################
# MacOS-Specific Stuff                                      #
#############################################################

## Fonts
cask 'font-fira-code'
cask 'font-hack'
cask 'font-inconsolata'
cask 'font-meslo-lg-nerd-font'
cask "font-anonymice-powerline"
cask "font-inconsolata-g-for-powerline"
cask "font-powerline-symbols"

# Browsers
cask "arc" unless system "test '[ -d /Applications/Arc.app/ ]'"


# Communication
cask "discord"
cask "slack"
cask 'zoom'

## Node
brew "node"

## Java
brew "java"

# Editors
cask "pycharm"
cask "visual-studio-code"
cask 'zed'

# Entertainment
cask "vlc"

# CLI Essentials
brew 'git'          # Version controll
brew 'neovim'       # Text editor
brew 'ranger'       # Directory browser
brew 'tmux'         # Term multiplexer

# Terminals
brew "fish"
cask "warp"
cask "kitty"
brew "starship"

# Utility
cask "orbstack"
cask "keka"
#cask "syncthing"
#cask "vanilla"

# Media
cask 'calibre'      # E-Book reader
cask 'spotify', args: { require_sha: false } # Propietary music streaming

# Personal Applications
cask '1password'      # Password manager (proprietary)
cask "appcleaner"
cask "cyberduck"
cask 'mountain-duck'  # Mount remote storage locations
cask 'protonvpn'      # Client app for ProtonVPN
cask "notion"
cask "raycast"
cask 'arq'
cask 'zoom'
cask 'sloth'
cask 'MonitorControl'
cask 'meetingbar'
cask 'logseq'
#cask 'ledger-live'    # Crypto hardware wallet manager

# Mac OS Quick-Look Plugins
cask 'qlcolorcode'    # QL for code with highlighting
cask 'qlimagesize'    # QL for size info for images
cask 'qlmarkdown'     # QL for markdown files
cask 'qlprettypatch'  # QL for patch / diff files
cask 'qlstephen'      # QL for dev text files
cask 'qlvideo'        # QL for video formats
cask 'quicklook-csv'  # QL for tables in CSV format
cask 'quicklook-json', args: { require_sha: false } # QL for JSON, with trees
cask 'quicklookapk',   args: { require_sha: false } # QL for Android APKs
cask 'webpquicklook',  args: { require_sha: false } # QL for WebP image files


# Mac OS Mods and Imrovments
cask 'contexts'        # Much better alt-tab window switcher
cask 'logi-options-plus' # Logitech MX Master support
cask 'espanso'        # Live text expander (cross-platform)
cask 'hiddenbar'      # Hide / show annoying menubar icons
brew 'iproute2mac'    # MacOS port of netstat and ifconfig
cask 'openinterminal' # Finder button, opens directory in terminal
cask 'raycast', args: { require_sha: false }  # Spotlight alternative
cask 'santa'          # Binary authorization for security
brew 'skhd'           # Hotkey daemon for macOS
brew 'yabai'          # Tiling window manager

#cask 'shottr'         # Better screenshot utility
#cask 'stats'          # System resource usage in menubar
#brew 'm-cli'          # All in one MacOS management CLI app
#cask 'anybar'         # Custom programmatic menubar icons
#cask 'copyq'          # Clipboard manager (cross platform)

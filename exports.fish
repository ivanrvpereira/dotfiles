# Path setup (order matters - first takes precedence)
fish_add_path /Applications/PyCharm.app/Contents/MacOS
fish_add_path /opt/homebrew/opt/openjdk@17/bin
fish_add_path $HOME/Library/Haskell/bin
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin
fish_add_path ~/.vector/bin

fish_add_path ~/.local/bin

fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/libpq/bin

set -gx MANPATH /opt/homebrew/opt/coreutils/libexec/gnuman $MANPATH

set -gx ENVIRONMENT development

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

set -gx JAVA_HOME /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
set -gx UBI_TOKEN op://development/ubicloud-token/credential
set -gx SSH_AUTH_SOCK $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

set -gx PERPLEXITY_API_KEY (op read "op://development/perplexity-api-key/credential")

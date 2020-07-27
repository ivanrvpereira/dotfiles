#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

brew install fish
sudo bash -c 'echo /usr/local/bin/fish >> /etc/shells'
chsh -s /usr/local/bin/fish




# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed 

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew tap homebrew/versions
#brew install bash-completion2

# Install `wget` with IRI support.
brew install wget


brew tap homebrew/services
brew tap homebrew/cask
brew tap homebrew/core

brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh

# Install other useful binaries.
brew install ack
brew install git
brew install git-flow-avh
brew install git-lfs
brew install imagemagick --with-webp
brew install p7zip
brew install pv
brew install rename
brew install ssh-copy-id
brew install tree
brew install webkit2png
brew install jq
brew install lbmagic


# languages
#PHP
#brew install homebrew/php/php55 --with-gmp
#brew install php-version
#brew install ctags-better-php
#curl https://raw.githubusercontent.com/shawncplus/phpcomplete.vim/master/misc/ctags-better-php.rb > /usr/local/Library/Formula/ctags-better-php.rb
#brew install psysh

brew install ctags
brew install python
brew install node
brew install yarn
#brew install dotnet
#brew install haskell-stack
#brew install go

brew install editorconfig

brew install jesseduffield/lazydocker/lazydocker
brew install lazydocker

brew install libuv
brew install tldr
brew install msgpack

# my tools
brew instal calc
brew install watch
brew install telnet
brew install collordiff
brew install fasd
brew install fzf
brew install ctop
brew install htop
brew install the_silver_searcher
brew install tmux
#brew install toggle-osx-shadows
brew install trash # moves files to trash on osx
brew install unrar
brew install weechat
brew install wget
brew install thefuck


# Install more recent versions of some OS X tools.
brew tap neovim/neovim
brew install neovim

brew install dnsmasq
brew install direnv

# Remove outdated versions from the cellar.
brew cleanup


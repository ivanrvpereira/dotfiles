#!/bin/bash

# fisherman
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jorgebucaran/replay.fish
fisher install PatrickF1/fzf.fish
fisher install rodrigobdz/fish-apple-touchbar
fisher install jethrokuan/z
brew install grc; fisher grc
git clone https://github.com/seebi/dircolors-solarized.git .dircolors  

# brew install apps
brew install font-fira-code
brew install grc; fisher grc
brew install fontconfig
brew install coreutils
brew install battery-guardian
brew tap homebrew/cask-fonts
brew install font-inconsolata font-fira-code
brew install pyenv
read -p "install python latest version with pyenv install 3.9.2"
brew install git
brew install htop
brew install ctags
brew install node 
brew install editorconfig
brew install telnet
brew install fzf 
brew install ctop 
brew install the_silver_searcher 
brew install neovim 
brew install direnv 
brew install dnsmasq 
brew install redis 
brew install mysql 
brew install postgresql

brew install dropbox
read -p "please login on Dropbox to link configs below"

brew install iterm2
read -p "download lucius theme high contrast dark theme"

brew install slack
brew install authy
brew install lastpass
brew install todoist
brew install discord
brew install spotify 
brew install dash
brew install amethyst
brew install obsidian
brew install amethyst
brew install barrier
brew install appcleaner 
brew install firefox 
brew install brave-browser 
brew install cyberduck 
brew install datagrip 
brew install pycharm 
brew install visual-studio-code 
brew install kindle 
brew install viscosity 
brew install kap
brew install docker
# install python current version

read -p "wait until dropbox installs"
#copy fish history to ~/.local/share/fish/fish_history
ln -s ~/Dropbox/sync/config/ .config

DOTDIR=$HOME/.dotfiles
ln -s $DOTDIR/curlrc $HOME/.curlrc
ln -s $DOTDIR/gitconfig $HOME/.gitconfig
ln -s $DOTDIR/gitignore $HOME/.gitignore
ln -s $DOTDIR/hgignore $HOME/.hgignore
ln -s $DOTDIR/hgrc $HOME/.hgrc
ln -s $DOTDIR/tmux.conf $HOME/.tmux.conf
ln -s $DOTDIR/wgetrc $HOME/.wgetrc
ln -s $DOTDIR/ackrc $HOME/.ackrc
ln -s $DOTDIR/agignore $HOME/.agignore
ln -s $DOTDIR/direnvrc $HOME/.direnvrc

pip3 install -r $DOTDIR/pip.txt

cat << EOF
settings
keyboard 
  key repeat
  caps as ctrl
mouse
  trackpad natural direction off
mission control
  hotcorners


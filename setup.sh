#!/usr/bin/env bash

DOTDIR=$HOME/.dotfiles


#echo "install janus"
#curl -L https://bit.ly/janus-bootstrap | bash
#
#
#echo "setup vim"
#mkdir -p $HOME/.config/nvim
#ln -s $HOME/.vimrc $HOME/.config/nvim/init.vim
#ln -s $DOTDIR/vimrc.after $HOME/.vimrc.after
#ln -s $DOTDIR/vimrc.before $HOME/.vimrc.before
#ln -s $DOTDIR/janus-modules $HOME/.janus
#

echo "setup other stuff"
ln -s $DOTDIR/curlrc $HOME/.curlrc
ln -s $DOTDIR/gitconfig $HOME/.gitconfig
ln -s $DOTDIR/gitignore $HOME/.gitignore
ln -s $DOTDIR/hgignore $HOME/.hgignore
ln -s $DOTDIR/hgrc $HOME/.hgrc
ln -s $DOTDIR/tmux.conf $HOME/.tmux.conf
ln -s $DOTDIR/wgetrc $HOME/.wgetrc
ln -s $DOTDIR/dircolors $HOME/.dircolors
ln -s $DOTDIR/inputrc $HOME/.inputrc
ln -s $DOTDIR/ackrc $HOME/.ackrc
ln -s $DOTDIR/agignore $HOME/.agignore


# install fonts
# https://github.com/powerline/fonts
# install fira code font
#https://github.com/tonsky/FiraCode


#echo "setup zsh"
## install zsh from repo and then link
#ln -s $DOTDIR/zshrc $HOME/.zshrc
#ln -s $DOTDIR/oh-my-zsh $HOME/.oh-my-zsh

#zshrc="$HOME/.zshrc"
#if [ -e "$zshrc"  ]
#then
#    mv $zshrc "$zshrc.1"
#fi
#ln -s $DOTDIR/zshrc $zshrc

read -p "Add this /usr/local/bin/zsh >> /etc/shells " yn
#change shell to zsh
chsh -s $(which zsh)


echo "install fzf shell extensions"
/usr/local/opt/fzf/install


# need to install brew first
echo "pip install global"
#pip install -r $DOTDIR/pip.txt
pip3 install -r $DOTDIR/pip.txt

# dircolors
# https://github.com/seebi/dircolors-solarized.git
# criar ~/.dotfiles
# meter no .config/fish/config.fish o eval (eval (dircolors -c ~/.dircolors/dircolors.ansi-dark)
# aliases meter o --color=auto
echo "Done"

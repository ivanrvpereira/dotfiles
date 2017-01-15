#!/bin/sh
pip install -U -r pip.txt
brew update && brew upgrade `brew outdated`
git submodule foreach git pull origin master
cd ~/.vim && rake
cd ~/.janus/YouCompleteMe && git submodule update --init --recursive && python install.py --clang-completer --tern-completer

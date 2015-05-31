# VIM
## Install deps
    apt-get install vim-nox exuberant-ctags ruby-dev
    ln -s ~/.dotfiles/.vimrc .vimrc
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  
## Install plugins
    vim
    :BundleInstall

## Install command-t
    cd ~/.vim/bundle/command-t/ruby/command-t
    ruby extconf.rb
    make
    
  
  

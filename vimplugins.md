# vim plugins
Reminder / reference for the plugins I have installed.

## Plugin management- Pathogen
[On Github](https://github.com/tpope/vim-pathogen).

"pathogen.vim makes it super easy to install plugins and runtime files in their own private directories."

In [.vim/autoload/pathogen.vim](https://github.com/cceckman/Tilde/blob/master/.vim/autoload/pathogen.vim).

Triggered by `call pathogen#infect()` in
[.vimrc](https://github.com/cceckman/Tilde/blob/master/.vimrc)

Clone repositories as [submodules](https://git-scm.com/docs/git-submodule)
within submdirectories of ~/.vim/bundle, and the `infect` call autoloads them on
startup.

## Additional Resources

* http://sontek.net/turning-vim-into-a-modern-python-ide
* http://vim.wikia.com/wiki/Use_Vim_like_an_IDE

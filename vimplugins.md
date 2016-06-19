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

## Tagging
[Easytags](https://github.com/xolox/vim-easytags) and its prerequisites,
[xolox](https://github.com/xolox/)'s vim-misc.

It requires [Exuberant Ctags](http://ctags.sourceforge.net) explicitly-
not just any old ctags. This requires a [Homebrew](http://brew.sh) install
([like this](http://scholarslab.org/research-and-development/code-spelunking-with-ctags-and-vim/))
for OS X.
[Universal Ctags](http://ctags.io) appears to be an acceptable alternative, if
`g:easytags_suppress_ctags_warning` is set in .vimrc.

## Additional Resources

* http://sontek.net/turning-vim-into-a-modern-python-ide
* http://vim.wikia.com/wiki/Use_Vim_like_an_IDE

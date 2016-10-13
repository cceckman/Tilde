"Many thanks to http://sontek.net/turning-vim-into-a-modern-python-ide for this setup.


" Make easytags accept Universal Ctags (ctags.io)
let g:easytags_suppress_ctags_warning = 1

" Load with pathogen
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

"Status line setup
set laststatus=2 "alawys show
set statusline=%t "tail of filename
set statusline+=%m "whether edited
set statusline+=%y "filetype
set statusline+=%= "L/R separator; align following items right
set statusline+=C:%c "Column
set statusline+=,\ L:%l/%L "line of how many lines

"Show line numbers
set number

"Don't select line numbers with mouse
set mouse=a

"Allow backspace over EOL...like every other text editor
set backspace=indent,eol,start
"Make jj escape insert mode
inoremap jj <Esc>

"Set up syntax preferences
if has("syntax")
    syntax on
endif

" Use 256 colors, set color scheme.
set t_Co=256
set background=dark
colorscheme solarized

" Set indent preferences.
set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2

filetype indent plugin on

" Use space to center screen on current line in normal mode
nmap <space> zz

"Use C-hjkl controls for moving between windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

"When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

"Set default printer to PDF
set pdev=pdf
set printoptions=paper:letter,syntax:y,number:y,wrap:y

" Set things to fold automatically
set foldmethod=syntax
" But use indent-based folding for Python
autocmd FileType python setlocal foldmethod=indent
" And store what's been folded
" au BufWinLeave ?* mkview
" au BufWinEnter ?* silent loadview

" Nice little hack; allow :W to do :w, and :Wqa to do :wqa
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Wqa ((getcmdtype() is# ':' && getcmdline() is# 'Wqa')?('wqa'):('Wqa'))
cnoreabbrev <expr> dir ((getcmdtype() is# ':' )?('NERDTree'):('dir'))

" Use 80-character margin in markdown.
autocmd FileType markdown setlocal textwidth=80

" Don't autofmt go on save. This is a nice feature, but keeps re-folding
" everything. Probably ultimately want to fix by saving folds.
let g:go_fmt_autosave = 0
" I'm not a fan of the template here- use a different template engine.
let g:go_template_autocreate = 0
" ...but re-create the "make with package" bit of that by adding a new
" variable.
let g:templates_user_variables = [
  \   ['PACKAGE', 'GetPackage'],
  \ ]

function! GetPackage()
  " %  Current directory
  " :p Full path
  " :h Head; everything but the filename
  " :t tail; just the last element, i.e. directory
  " But override if the filename is 'main'
  let fpkg = matchlist(expand('%:t'), '\(.*\)\(_test\).go')
  if (!empty(fpkg)) && (len(fpkg) >= 1) && (fpkg[1] == 'main')
    return 'main'
  endif

  return expand('%:p:h:t')
endfunction


" Register templating preferences.
let g:email = "charles@cceckman.com"
if !exists('g:templates_directory')
  let g:templates_directory = []
endif
let g:templates_directory = add(g:templates_directory, '~/.vim/templates')

" Line and column hilighting
au WinLeave * set nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn
set colorcolumn=80

" Use the X clipboard (register +) by default.
set clipboard=unnamedplus

" Set a wider colorcolumn in Go, which doesn't have as strict lint
" requirements as other languages.
autocmd FileType go set colorcolumn=100

" Restore line position when re-opening a file
au BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal g'\"" | endif

" .md to Markdown, not modula2. Come on.
au BufRead,BufNewFile *.md set filetype=markdown

" Thanks to http://vim.wikia.com/wiki/Improved_hex_editing
command! -bar Hex call ToggleHex()
function! ToggleHex()
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        let b:oldft=&ft
        let b:oldbin=&bin
        setlocal binary
        let &ft="xxd"
        let b:editHex=1
        %!xxd
    else
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        let b:editHex=0
        %!xxd -r
    endif
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

" Easily open magic.sh.
command! -bar Magic sv | edit ~/magic.sh

" Insert a timestamp.
command! Now execute 'r! date "+\%F \%a \%H:\%M"'


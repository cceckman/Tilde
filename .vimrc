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
colorscheme xemacs

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

" Nice little hack; allow :W to do :w
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> dir ((getcmdtype() is# ':' )?('NERDTree'):('dir'))

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
command Magic edit ~/magic.sh

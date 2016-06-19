"Many thanks to http://sontek.net/turning-vim-into-a-modern-python-ide for this setup."

" Load with pathogen
filetype off
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

"Status line setup"
set laststatus=2 "alawys show
set statusline=%t "tail of filename
set statusline+=%m "whether edited
set statusline+=%y "filetype
set statusline+=%= "L/R separator; align following items left
set statusline+=C:%c "Column
set statusline+=,\ L:%l/%L "line of how many lines

"Show line numbers"
set number

"Don't select line numbers with mouse"
set mouse=a

"Allow backspace over EOL...like every other text editor"
set backspace=indent,eol,start
"Make jj escape insert mode
inoremap jj <Esc>

"Fix some key collision errors"
map <Leader>] <Plug>MakeGreen
map <Leader>[ <Plug>TaskList

"Powerful undo editor"
map <leader>g :GundoToggle<CR>

"Set up syntax preferences"
if has("syntax")
    syntax on
endif
"au BufRead,BufNewFile *.tsc set filetype=typescript
"au! Syntax typescript source ~/.vim/syntax/typescript.vim


set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2

filetype indent plugin on

"Space for code completion" 
inoremap <Nul> <C-x><C-o>

"Use C-hjkl controls for moving between windows"
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Use space to center screen on current line in normal mode
nmap <space> zz

" Use 'comma' shortcuts for comments
" single-line
map ,/ :s/^/\/\//<CR>
map ,? :s/^\/\///<CR>
" multi-line
map ,* :s/^\(.*\)$/\/\* \1 \*\//<CR>


" Add the virtualenv's site-packages to vim path"
" py << EOF
"import os.path
"import sys
"import vim
"if 'VIRTUAL_ENV' in os.environ:
"    project_base_dir = os.environ['VIRTUAL_ENV']
"    sys.path.insert(0, project_base_dir)
"    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py') 
"    execfile(activate_this, dict(__file__=activate_this))
"EOF

"When vimrc is edited, reload it"
autocmd! bufwritepost .vimrc source ~/.vimrc

"Set default printer to PDF"
set pdev=pdf
set printoptions=paper:letter,syntax:y,number:y,wrap:y

" Set things to fold automatically
set foldmethod=syntax
" And store what's been folded
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview
" But use indent-based folding for Python
autocmd FileType python setlocal foldmethod=indent


" Use 256 colors
set t_Co=256
colorscheme xemacs

" from http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
" Highlight when over 80 chars
" highlight OverLength ctermbg=red ctermfg=white guibg=$592929
" match OverLength /\%81v.\+/

" Nice little hack; allow :W to do :w
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> dir ((getcmdtype() is# ':' )?('NERDTree'):('dir'))

" Line and column hilighting
au WinLeave * set nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn
set colorcolumn=80

au BufRead,BufNewFile *.go set colorcolumn=100

" Restore line position when re-opening a file
au BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal g'\"" | endif

" Markdown, not modula2. Come on.
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

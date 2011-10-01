"Many thanks to http://sontek.net/turning-vim-into-a-modern-python-ide \
" for this setup."

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

"Allow backspace over EOL...like every other text editor"
set backspace=indent,eol,start
"Make ii escape insert mode
inoremap ii <Esc>

filetype off
call pathogen#infect()

"Fix some key collision errors"
map <Leader>] <Plug>MakeGreen
map <Leader>[ <Plug>TaskList

"Powerful undo editor"
map <leader>g :GundoToggle<CR>

"Set up syntax preverences"
if has("syntax")
    syntax on
endif

set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4

filetype indent plugin on

"Space for code completion" 
inoremap <Nul> <C-x><C-o>

"Use C-hjkl controls for moving between windows"
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

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


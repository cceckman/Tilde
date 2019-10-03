"Many thanks to http://sontek.net/turning-vim-into-a-modern-python-ide for this setup.

""""""""""""""""""""
" Part 1: Flags
""""""""""""""""""""

" Some tips from
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#making-vim-more-useful:

" Load plugins with pathogen.
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

" Don't try to be vi-compatible.
set nocompatible
" Prevent some security issues.
set modelines=0
" Make regexes easier: don't have to escape as much.
nnoremap / /\v
vnoremap / /\v
" Use correct case matching: insensitive unless there's a capital.
set ignorecase
set smartcase
" Invert the sense of g in s///g: default to all matches on a line.
set gdefault
" Hilight search results as you type.
set incsearch
set showmatch
set hlsearch
" Clear out hilighting of search results with <leader><space>.
nnoremap <leader><space> :noh<cr>
" Use tab rather than % to swap to matching bracket.
nnoremap <tab> %
vnoremap <tab> %

" Long-line handling; I do this slightly differently, so skipping.
" set wrap
" set textwidth=79
" set formatoptions=qrn1
" set colorcolumn=85

" Use UTF-8 by default. Apparently LANG is insufficient...
set encoding=utf-8
set termencoding=utf8

" Show invisible characters. Not entirely sure that I like this.
set list
" set listchars=tab:▸\ ,eol:¬
" The right-triangle renders as a little less than full width in Fira Code.
set listchars=tab:␉\ \ ,eol:¬

" Set indent preferences.
set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2

" Set them particularly for go.
autocmd FileType go setlocal tabstop=8
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal softtabstop=8
autocmd FileType go setlocal shiftwidth=8

" Have a buffer of 3 lines on either side of the cursor.
set scrolloff=3
" Copy indent from the current line when starting a new line.
" Compare to smartindent.
set autoindent
" Show the current mode.
set showmode

" Some options I don't understand, and don't seem applicable.
" set showcmd
" set hidden

" Do tab-completion with options on the line above.
set wildmenu
set wildmode=list:longest

" Flash the screen instead of displaying a bell. I don't like this.
" set visualbell
" Hilight the current line. I do this slightly differently, see below.
" set cursorline

" Improve performance when using a local terminal. May or may not want this; I
" do stuff over SSH.
set ttyfast

" Shows what position of the current file is shown: Top, Bot, All, or XX%.
" Doesn't show when statusline is set, it seems.
" set ruler

" Allow backspace over EOL...like every other text editor
set backspace=indent,eol,start
" Always show the status bar for the last window in a file.
set laststatus=2

" Use relative line numbers. I don't like this
" set relativenumber

" Create an 'undo' file that lives past closing / reopening it.
set undofile

" Use comma as leader. Easier to reach than \.
let mapleader = ","

" Hilight the line and column in the current window.
" Disabled after starting to use Fira Code; it breaks up ligatures on other
" lines.
" au WinLeave * set nocursorcolumn
" au WinEnter * set cursorline cursorcolumn
set cursorline nocursorcolumn
" Mark column 80.
set colorcolumn=80

" Show line numbers
set number

" Don't select line numbers with mouse
set mouse=a

" Use syntax hilighting.
if has("syntax")
    syntax on
endif

" Indent by filetype.
filetype indent plugin on

" Set things to fold automatically
set foldmethod=syntax
" And store what's been folded
" au BufWinLeave ?* mkview
" au BufWinEnter ?* silent loadview

" Autosave on losing focus.
au FocusLost * :wa

" Install language servers.
let g:lsp_diagnostics_enabled = 1
if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls', '-logfile', '/tmp/golangs.log']},
        \ 'whitelist': ['go'],
        \ })
endif

" Syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

""""""""""""""""""""
" Part 2: Personalization
""""""""""""""""""""

" Enable Syntastic checkers for...

" golang:
let g:godef_split = 0
let g:go_fmt_fail_silently = 1
let g:go_list_type = 'quickfix'
" 'go vet' not installed, at the moment, as its own tool.
let g:syntastic_go_checkers = ['golint', 'gometalinter', 'gofmt']
let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
let g:syntastic_go_gofmt_args = ['-s']

" rust: enabled via rust.vim plugin
" YAML
let g:syntastic_yaml_checkers = ['yamllint']

" (z)sh
let g:syntastic_enable_zsh_checker = 1

" Use 256 colors, with the solarized color scheme.
" set t_Co=256
let g:solarized_bold = 0
set background=dark
colorscheme solarized
" colorscheme xemacs

" Use space to center screen on current line in normal mode
nnoremap <space> zz

"Use C-hjkl controls for moving between windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Configure the status line.
set statusline=%t "tail of filename
set statusline+=%m "whether edited
set statusline+=%y "filetype
set statusline+=\ wc:%{WordCount()}
set statusline+=%= "L/R separator; align following items right
set statusline+=C:%c "Column
set statusline+=,\ L:%l/%L "line of how many lines

" Enable rainbow parentheses:
" Mix of https://github.com/junegunn/rainbow_parentheses.vim and
" https://gist.github.com/Janiczek/add6d4a313d4a9700b24
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

augroup rainbow
  autocmd!
  autocmd Syntax go RainbowParenthesesLoadRound
  autocmd Syntax go RainbowParenthesesLoadBraces
  autocmd Syntax go RainbowParenthesesLoadSquare
  autocmd Syntax go RainbowParenthesesLoadChevrons
  autocmd Syntax go RainbowParenthesesActivate
augroup END

" Don't pollute the working directory with files.
" Use ~/.vim/swap for swap files...
set directory^=$HOME/.vim/swap
" ...and ~/.vim/undo for undo files
set undodir=~/.vim/undo

""""""""""""""""""""
" Part 3: Hacks
""""""""""""""""""""

" Use the X clipboard (register +) by default.
set clipboard=unnamedplus

" Use tabstop 2, for Python.
autocmd FileType python setlocal tabstop=2

" Use indent-based folding for Python
autocmd FileType python setlocal foldmethod=indent

" .md to Markdown, not modula2. Come on.
au BufRead,BufNewFile *.md setfiletype markdown
" Use 80-character text wrapping in markdown.
autocmd FileType markdown setlocal textwidth=80

" Restore line position when re-opening a file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Make easytags accept Universal Ctags (ctags.io)
let g:easytags_suppress_ctags_warning = 1
" Run easytags asynchronously; necessary for large files
let g:easytags_async = 1
" Improve performance; only update easytags hilighting after save
let g:easytags_events = ['BufWritePost']

" Have j/k scroll by screen line rather than file line.
nnoremap j gj
nnoremap k gk

" Let ; act as :
nnoremap ; :


" Remap numpad keys to the proper keys: hack around
" https://apple.stackexchange.com/questions/201337/number-pad-does-not-work-in-vim-and-less
inoremap <Esc>Oq 1
inoremap <Esc>Or 2
inoremap <Esc>Os 3
inoremap <Esc>Ot 4
inoremap <Esc>Ou 5
inoremap <Esc>Ov 6
inoremap <Esc>Ow 7
inoremap <Esc>Ox 8
inoremap <Esc>Oy 9
inoremap <Esc>Op 0
inoremap <Esc>On .
inoremap <Esc>OQ /
inoremap <Esc>OR *
inoremap <Esc>Ol +
inoremap <Esc>OS -
inoremap <Esc>OM <Enter>

" Nice little hack; allow :W to do :w, and :Wqa to do :wqa
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Wqa ((getcmdtype() is# ':' && getcmdline() is# 'Wqa')?('wqa'):('Wqa'))

" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Set the location list (Syntastic) to a reasonable height
" see :h syntastic-loclist-callback
function! SyntasticCheckHook(errors)
    if !empty(a:errors)
        let g:syntastic_loc_list_height = min([len(a:errors), 10])
    endif
endfunction

""""""""""""""""""""
" Part 4: Macros
""""""""""""""""""""

" Easy access to directory of current file
cabbr <expr> %% expand('%:p:h')
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>

" Single-line switch between .h and .cc in same directory
nnoremap <leader>s :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>

" Toggle cursor column
nnoremap <leader>q <Esc>:set cursorcolumn!<cr>

" Keybindings for LSP:
nnoremap <leader>g <Esc>:LspDefinition<cr>
nnoremap <leader>f <Esc>:LspDocumentFormat<cr>
nnoremap <leader>td <Esc>:LspTypeDefinition<cr>
nnoremap <leader>r <Esc>:LspReferences<cr>

" Keybindings for syntastic
nnoremap <leader>n <Esc>:SyntasticToggleMode<cr>

" Toggle tagbar.
nnoremap <leader>t :TagbarToggle<CR>
" pause tagbar: lock to current file, so navigation doesn't mess it up.
nnoremap <leader>l :TagbarTogglePause<CR>

" Shorten apparent width of tabs (e.g. for reading heavily-indented code)
nnoremap <leader>h :set tabstop=2 shiftwidth=2<CR>

" :Trim whitespace
cnoreabbrev <expr> Trim ((getcmdtype() is# ':' && getcmdline() is# 'Trim')?('%s/[ ]*$//'):('Trim'))
" Hilight trailing whitespace when out of insert mode
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Add timestamps to the begginning of the line:
" https://www.codesections.com/blog/vim-timestamped/
let g:time_stamp_enabled = 0
command! TimeStampToggle let g:time_stamp_enabled = !g:time_stamp_enabled

inoremap <expr> <CR> g:time_stamp_enabled ? "\<ESC>:call TimeStamp()\<CR>a" : "\<CR>"

function! TimeStamp()
     let l:current_time = strftime("%H:%M:%S")
     execute "normal! 0i\<SPACE>\<ESC>0dwi\
          \<C-R>=l:current_time\<CR>\
          \<SPACE>\<SPACE>—\<SPACE>\<SPACE>\<ESC>o\<SPACE>\<SPACE>\<SPACE>\<SPACE>\
          \<SPACE>\<SPACE>\<SPACE>\<SPACE>\<SPACE>\<SPACE>\<SPACE>\<SPACE>\<SPACE>"

endfunction

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

" .cl and .cool to Cool
au BufRead,BufNewFile *.cool set filetype=cool
au BufRead,BufNewFile *.cl set filetype=cool

" .do to redo, AKA shell
au BufRead,BufNewFile *.do set filetype=sh

" Easily open magic.sh.
command! -bar Magic sv | edit ~/magic.sh

" Insert a timestamp.
command! Now execute 'r! date "+\%F \%a \%H:\%M"'

" Word-count functions: from " https://cromwell-intl.com/linux/vim-word-count.html
let g:word_count="<unknown>"
function! WordCount()
	return g:word_count
endfunction
function! UpdateWordCount()
	let lnum = 1
	let n = 0
	while lnum <= line('$')
		let n = n + len(split(getline(lnum)))
		let lnum = lnum + 1
	endwhile
	let g:word_count = n
endfunction
" Update the count when cursor is idle in command or insert mode.
" Update when idle for 1000 msec (default is 4000 msec).
set updatetime=1000
augroup WordCounter
	au! CursorHold,CursorHoldI * call UpdateWordCount()
augroup END
autocmd BufWritePost * call UpdateWordCount()

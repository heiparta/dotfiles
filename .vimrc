if has("gui_gtk2")
    set guifont=Droid\ Sans\ Mono\ 10,Monaco\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
else
    set guifont=Andale\ Mono\ Regular:h12,Monaco:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
endif
set guioptions-=T

" Backups and swap files
set backup
let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Linux"
    set directory=/tmp
    set backupdir=/tmp
else
    set directory=/private/tmp
    set dir=/private/tmp
    set backupdir=/private/tmp
endif

set tags=~/.vimtags

syntax on

set hlsearch
set backspace=eol,start,indent
set incsearch
set hidden

set shiftwidth=4
set softtabstop=4
set expandtab

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(\escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(\escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>
inoremap jk <ESC>
inoremap JK <ESC>
vnoremap > >gv
vnoremap < <gv
:let mapleader = ","
map <leader>g <C-]>
map <F11> :QFix<CR>
" Press F4 to toggle highlighting on/off, and show current value.
:noremap <F4> :set hlsearch! hlsearch?<CR>

" Press § to switch between two last buffers
:nnoremap <Char-167> :e#<CR>
:map <C-x> :Bclose<CR>
:map <A-C-x> :Bclose!<CR>
cnoreabbrev W w
cnoreabbrev bd Bclose
cnoreabbrev Bd Bclose

" :map <Leader>f :CtrlP<CR>
" :map <Leader>d :CtrlPBuffer<CR>
" :map <Leader>F :CtrlP %%<CR>
:map <Leader>f :CommandT<CR>
:map <Leader>d :CommandTBuffer<CR>
:map <Leader>F :CommandT %:p:h<CR>

" Copying current file name / full path to clipboard
nmap <Leader>ns :let @+=expand("%:t")<CR>
nmap <Leader>nl :let @+=expand("%:p")<CR>

" Remove trailing whitespaces
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

map <leader>2 [M
map <leader>3 ]M
map <leader>1 [C
map <leader>4 ]C
map <leader>5 :bp<CR>
map <leader>6 :bn<CR>
map <leader>s ysiw

set foldlevel=99

set laststatus=2
set statusline=%<%f\ " Filename
set statusline+=%w%h%m%r " Options
set statusline+=\ [%{&ff}/%Y] " Filetype
set statusline+=\ [%{getcwd()}] " Current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info

let g:pymode_lint_checkers=['pyflakes', 'pep8']
let g:pymode_lint_config='~/.pylint.rc'
let g:pymode_lint_ignore="E501,W601,E302,F0401,C0302,I0011,C0301,E251,E221,C0326,C0111,E222,W0201,E128,C,R,W0702,E126,E127,W0511,E0611,W0703,E123,E125,E502"
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/Vundle.vim'

Bundle 'klen/python-mode'
let g:pymode_rope = 0
Bundle 'pythoncomplete'
Bundle 'python_match.vim'
Bundle 'moll/vim-node'

Bundle 'walm/jshint.vim'
au BufWritePost *.js :JSHint
Bundle 'groenewege/vim-less'
Bundle 'elzr/vim-json'
Bundle 'pangloss/vim-javascript'

"Bundle 'Shougo/neocomplcache'
"Bundle 'Valloric/YouCompleteMe'

Bundle 'Valloric/QFixToggle'

Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'Lokaltog/vim-easymotion'

Bundle 'git://git.wincent.com/command-t.git'
let g:CommandTWildIgnore=&wildignore . ",**/node_modules/*"
let g:CommandTCancelMap = "<Esc>"
"let g:CommandTSelectNextMap = ['<C-j>', '<ESC>OB']
"let g:CommandTSelectPrevMap = ['<C-k>', '<ESC>OA']
Bundle 'flazz/vim-colorschemes'

Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-easytags'
let g:easytags_async = 1
let g:easytags_syntax_keyword = 'always'

Bundle 'rbgrouleff/bclose.vim'

Bundle 'sjl/gundo.vim'
nnoremap <F5> :GundoToggle<CR>

Bundle 'mileszs/ack.vim'

"Bundle 'fholgado/minibufexpl.vim'

filetype plugin indent on

colorscheme fruity

" Higlight trailing whitespaces, needs to be applied after colorscheme
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
 
autocmd FileType python set colorcolumn=120
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

if !empty(glob("path/to/file"))
    source ~/.vimrc.local
endif

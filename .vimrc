" General
set nocompatible

" Setting up Vundle
let vundle_installed=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let vundle_installed=0
endif

" Use Vundle to manage plugin
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Bundles from GitHub repos:

" Better file browser
Bundle 'scrooloose/nerdtree'
" Code commenter
Bundle 'scrooloose/nerdcommenter'
" class/module browser
Bundle 'majutsushi/tagbar'
" Code and files fuzzy finder
Bundle 'kien/ctrlp.vim'
" Git  integration
Bundle 'motemen/git-vim'
" Tab list panel
Bundle 'kien/tabman.vim'
" Powerline
"Bundle 'Lokaltog/vim-powerline'
" Surround
Bundle 'tpope/vim-surround'
" Autoclose
Bundle 'Townk/vim-autoclose'
" Term colorscheme
Bundle 'altercation/vim-colors-solarized'
" Indent text object
Bundle 'michaeljsmith/vim-indent-object'

" Bundles from vim-scripts repos

" Autocompletition
Bundle 'AutoComplPop'
" Gvim colorscheme
Bundle 'Wombat'
" Yank history navigation
Bundle 'YankRing.vim'
" File encoding view
Bundle 'FencView.vim'
"
Bundle 'taglist.vim'

" Installing plugins the first time
if vundle_installed == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif

function! MySys()
    if has("win32")
        return "windows"
    else
        return "linux"
    endif
endfunction

filetype plugin indent on

if MySys() == "windows"
    autocmd! bufwritepost _vimrc source ~/_vimrc
else
    autocmd! bufwritepost .vimrc source ~/.vimrc
endif

" Display related
set number
set showmatch
set showmode
set showcmd
set ruler
set laststatus=2
set statusline=%<[%n]\ %F\ %h%m%r%w\ [%{&ff}]\ %=[0x%02B]\ %-14.(%l,%c%V%)\ %P
"set cursorline
"set cursorcolumn
syntax on
set nowrap
"set spell
set scrolloff=3 "when scrolling, keep cursor 3 lines away from screen border
if has("gui_running")
    set guioptions+=b
    "set guioptions-=m
    "set guioptions-=T
    "colorscheme wombat
    "set guifont=Inconsolata\ Medium\ 18
    set background=light
else
    set background=dark
endif

set t_Co=256
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_contrast="high"
"let g:solarized_visibility="high"
colorscheme solarized

"{{{ Toggle dark/light background for solarized
"nmap <leader>tb :call ToggleSolarized()<CR>
"function! ToggleSolarized()
"    if &background == 'dark'
"        set background=light
"        colorscheme solarized
"    else
"        set background=dark
"        colorscheme solarized
"    endif
"endfunc
"}}}  

" Fold Setting
set foldenable
set foldmethod=marker
set foldlevel=100
set foldopen=block,hor
set foldopen+=percent,mark
set foldopen+=quickfix

" Search related
set hlsearch
set incsearch
set ignorecase
set smartcase

" Format related
set textwidth=80
set linebreak
set nojs
set fo+=mB


" Editing related
set backspace=indent,eol,start
set whichwrap=h,l,b,s,<,>,[,]
set keymodel=
set selectmode=
set selection=inclusive

" Misc
set wildmenu
"set wildmode=list:longest,full
set history=256
"set timeoutlen=250
set autoread
set mouse=a
set mousemodel=popup

" Tab related
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
" Tablength exceptions
autocmd FileType html setlocal shiftwidth=2 tabstop=2

" Indent related
set cindent
set autoindent
set smartindent
set cinoptions=:0g0t0(susj1

" Encoding related
set encoding=utf-8
set termencoding=utf-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"set langmenu=zh_CN.UTF-8
language messages zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set ambiwidth=double

" Key map settings
let mapleader = " "  
let maplocalleader = '_'

" Tabmam setting 
let g:tabman_toggle= '<leader>ttm'
let g:tabman_focus= '<leader>tmf'
"let g:tabman_number=0

" Tagbar Toggle
map <leader>ttb :TagbarToggle<CR>
let g:tagbar_autofocus=1

"set pastetoggle=<F4>

" show invisible chars
nmap <Leader>sl :set list!<CR>
set listchars=tab:»-,eol:¬,trail:$,extends:»,precedes:«
nmap <silent> <leader>/ :nohlsearch<CR>

" Tab navigation
map <C-S-right> :tabp<CR>
map <C-S-left> :tabn<CR>
imap <C-S-right> <ESC>:tabp<CR>
imap <C-S-left> <ESC>:tabn<CR>
map <C-S-m> :tabm<CR>
map tt :tabnew<CR>
"imap <C->

" Navigate windows with ALT+arrows
map <C-j> <c-w>j
map <C-k> <c-w>k
map <C-h> <c-w>h
map <C-l> <c-w>l
imap <C-j> <ESC><c-w>j
imap <C-k> <ESC><c-w>k
imap <C-h> <ESC><c-w>h
imap <C-l> <ESC><c-w>l

map <C-right> :bn<CR>
map <C-left> :bp<CR>
" FencView
let g:fencview_autodetect=0

" NERDTree
let NERDTreeShowHidden=1
map <Leader>te :NERDTreeToggle<CR>

" Building tags with CTRL+F4
noremap <F4> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
inoremap <F4> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"set  tags+=tags

" CtrlP (new fuzzy finder)
let g:ctrlp_map = '<leader>f'
" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
    execute ':CtrlP' . a:ctrlp_command_end
    call feedkeys(a:search_text)
endfunction
" CtrlP with default text
nmap ,wg :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nmap ,wG :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
nmap ,wf :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nmap ,d ,wg
nmap ,D ,wG
nmap ,we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nmap ,pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
nmap ,wm :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
" Don't change working directory
let g:ctrlp_working_path_mode = 0
" Ignore files on fuzzy finder
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](\.git|\.hg|\.svn)$',
    \ 'file': '\.pyc$\|\.pyo$',
    \ }

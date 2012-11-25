" General
set nocompatible

" Platform
function! MySys()
    if has("win32")
        return "windows"
    else
        return "linux"
    endif
endfunction

" Setting up Vundle for linux
if MySys() == "linux"
	let vundle_installed=1
	let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
	if !filereadable(vundle_readme)
		echo "Installing Vundle..."
		echo ""
		silent !mkdir -p ~/.vim/bundle
		silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
		let vundle_installed=0
	endif
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
" Switch between companion source files
Bundle 'derekwyatt/vim-fswitch'
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

" Buffer Explorer
Bundle 'bufexplorer.zip'
" Autocompletition
"Bundle 'AutoComplPop'
" SupterTab
"Bundle 'ervandew/supertab'
" neocomplcache 
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet.git'
" OmniCppComplete
Bundle 'OmniCppComplete'
" code complete
"Bundle 'mbbill/code_complete'
" Gvim colorscheme
Bundle 'Wombat'
" Yank history navigation
Bundle 'YankRing.vim'
" File encoding view
Bundle 'FencView.vim'

" Installing plugins the first time
if vundle_installed == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif

" Platform
function! MySys()
    if has("win32")
        return "windows"
    else
        return "linux"
    endif
endfunction

" Encoding related
set encoding=utf-8
set fileencoding=utf8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim
"set langmenu=zh_CN.UTF-8
set langmenu=en_US.UTF-8
"language messages zh_CN.UTF-8
language messages en_US.UTF-8
set ambiwidth=double

" [platform specific options]
if MySys() == "windows"
	set termencoding=cp936
elseif MySys() == "linux"
    set termencoding=utf-8
endif

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
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"set langmenu=zh_CN.UTF-8
language messages zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set ambiwidth=double

" Default colorcolumn settings
let s:cc_default = 81

" [Highlight column matching { } pattern]
let s:hlflag=0
function! ColumnHighlight()
    let c=getline(line('.'))[col('.') - 1]
    if c=='{' || c=='}'
        let &cc = s:cc_default . ',' . virtcol('.')
        let s:hlflag = 1
    else
        if s:hlflag == 1
            let &cc = s:cc_default
            let s:hlflag = 0
        endif
    endif
endfunction

if has("autocmd") && !exists("autocommands_loaded")
    let autocommands_loaded=1
    if version >= 703
        autocmd BufReadPost *.h,*.c,*.cpp,*.vim let &cc = s:cc_default
        autocmd CursorMoved *.h,*.c,*.cpp call ColumnHighlight()
    endif
endif

" search for exuberant ctags
let ctagsbins = []
let ctagsbins += ['ctags']
let ctagsbins += ['ctags.exe']
let g:ctagsbin = ''
for ctags in ctagsbins
    if executable(ctags)
        let g:ctagsbin = ctags
        break
    endif
endfor
unlet ctagsbins

" [Set up cscope and ctag  environment]
function! ToggleCscopeCtags()
    if g:ctagsbin == ''
        echomsg 'No ctags found!'
        return
    endif
    let ctagsbin = g:ctagsbin
    let userdefs = tagbar#getusertypes()
    for type in values(userdefs)
        if has_key(type, 'deffile')
            let ctagsbin .= ' --options=' . expand(type.deffile)
        endif
    endfor
    "execute '!' . ctagsbin . ' -R'
    
    call system("ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .")
    
    if has("cscope")
        if cscope_connection() == 1
            cs kill -1
            cclose
            return
        endif
        set csprg=cscope
        set cscopequickfix=c-,d-,e-,f-,g-,i-,s-,t-
        set nocscopetag
        set cscopetagorder=0
        set cscopeverbose
        " add any database in current directory
        if filereadable("cscope.out")
            cs add cscope.out
            copen
        else
            let msg="Create cscope.out here?\n".getcwd()
            let result=confirm(msg,"&Yes\n&No",1,"Question")
            if result==1
                call system("cscope -b -k -q -R")
                cs add cscope.out
                copen
            endif
        endif
    endif
endfunction

" Key map settings
let mapleader = " "  
let maplocalleader = '_'

nnoremap <F1> :BufExplorer<CR>
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :TagbarToggle<CR>
nnoremap <F4> :call ToggleCscopeCtags()<CR>
" Building tags with CTRL+F4
"noremap <F4> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"inoremap <F4> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"set  tags+=tags

" [Cscope hot keys]
nnoremap <leader>csc :cs find c <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>csd :cs find d <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>cse :cs find e <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>csf :cs find f <c-r>=expand("<cfile>")<cr><cr>
nnoremap <leader>csg :cs find g <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>csi :cs find i ^<c-r>=expand("<cfile>")<cr>$<cr>
nnoremap <leader>css :cs find s <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>cst :cs find t <c-r>=expand("<cword>")<cr><cr>

" Tabmam setting 
let g:tabman_toggle= '<leader>ttm'
let g:tabman_focus= '<leader>tmf'
"let g:tabman_number=0

" Tagbar Toggle
let g:tagbar_autofocus=1
let g:tagbar_ctags_bin = ctagsbin

" Toggle paste mode
nmap <silent> <leader>tp :set invpaste<cr>:set paste?<cr>

" show invisible chars
nmap <Leader>sl :set list!<CR>
set listchars=tab:»-,eol:¬,trail:$,extends:»,precedes:«
nmap <silent> <leader>/ :nohlsearch<CR>

" Tab navigation
map <C-S-right> :tabp<CR>
map <C-S-left> :tabn<CR>
imap <C-S-right> <ESC>:tabp<CR>
imap <C-S-left> <ESC>:tabn<CR>
"map <C-S-m> :tabm<CR>
"map tt :tabnew<CR>

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
let NERDTreeIgnore = [
    \ '\~$',
    \ '\.o$',
    \ '\.swp$'
\ ]


" BufExplorer
let g:bufExplorerSplitBelow=1

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

"jump to last cursor position when opening a file
""dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

" Switch to current dir
nnoremap <silent> <leader>cd :cd %:p:h<cr>

"let g:SuperTabDefaultCompletionType= '<c-x><c-u>'
" NeoComplCache
" Disable AutoComplPop. Comment out this line if AutoComplPop is not installed.
let g:acp_enableAtStartup = 0
" Launches neocomplcache automatically on vim startup.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplcache_enable_underbar_completion = 1
" Sets minimum char length of syntax keyword.
let g:neocomplcache_min_syntax_length = 3
" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder 
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
"let g:neocomplcache_disable_auto_complete = 1
let g:neocomplcache_enable_ignore_case = 0
" Define file-type dependent dictionaries.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword, for minor languages
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion. Not required if they are already set elsewhere in .vimrc
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion, which require computational power and may stall the vim. 
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" OmniCppComplete
" colors and settings of autocompletition
"highlight Pmenu ctermbg=4 guibg=LightGray
"highlight PmenuSel ctermbg=8 guibg=DarkBlue guifg=Red
"highlight PmenuSbar ctermbg=7 guibg=DarkGray
"highlight PmenuThumb guibg=Black
set completeopt=menuone,longest
",menu,longest,preview
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif 
" use global scope search
let OmniCpp_GlobalScopeSearch = 1
" 0 = namespaces disabled
" 1 = search namespaces in the current buffer
" 2 = search namespaces in the current buffer and in included files
let OmniCpp_NamespaceSearch = 2
" 0 = auto
" 1 = always show all members
let OmniCpp_DisplayMode = 1
" 0 = don't show scope in abbreviation
" 1 = show scope in abbreviation and remove the last column
let OmniCpp_ShowScopeInAbbr = 0
" This option allows to display the prototype of a function in the abbreviation part of the popup menu.
" 0 = don't display prototype in abbreviation
" 1 = display prototype in abbreviation
let OmniCpp_ShowPrototypeInAbbr = 1
" This option allows to show/hide the access information ('+', '#', '-') in the popup menu.
" 0 = hide access
" 1 = show access
let OmniCpp_ShowAccess = 1
" This option can be use if you don't want to parse using namespace declarations in included files and want to add
" namespaces that are always used in your project.
let OmniCpp_DefaultNamespaces = ["std"]
" Complete Behaviour
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
" When 'completeopt' does not contain "longest", Vim automatically select the first entry of the popup menu. You can
" change this behaviour with the OmniCpp_SelectFirstItem option.
" 0 = don't select first popup item
" 1 = select first popup item (inserting it to the text)
" 2 = select first popup item (without inserting it to the text)
let OmniCpp_SelectFirstItem = 0


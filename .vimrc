" General
set nocompatible

" Platform
function! MySys()
    if has("win32") || has("win64")
        return "windows"
    else
        return "linux"
    endif
endfunction

if MySys() == "windows"
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    " one mac and windows, use * register for copy-paste
    set clipboard=unnamed
    "autocmd bufwritepost .vimrc source ~/_vimrc
    "autocmd bufwritepost _vimrc source ~/_vimrc
else
    " on Linux use + register for copy-paste
    set clipboard=unnamedplus
    "autocmd bufwritepost .vimrc source ~/.vimrc
endif

" Encoding related
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
if MySys() == "windows"
    set termencoding=cp936
else
    set termencoding=utf-8
endif
"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim
"set langmenu=zh_CN.UTF-8
set langmenu=en_US.UTF-8
"language messages zh_CN.UTF-8
language messages en_US.UTF-8
set ambiwidth=double

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

" General
Bundle 'scrooloose/nerdtree'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-surround'
Bundle 'Townk/vim-autoclose'
Bundle 'kien/ctrlp.vim'
Bundle 'vim-scripts/sessionman.vim'
Bundle 'matchit.zip'
"Bundle 'Lokaltog/vim-powerline'
Bundle 'Lokaltog/vim-easymotion'
" Switch between companion source files
Bundle 'derekwyatt/vim-fswitch'
" Git  integration
Bundle 'motemen/git-vim'
" Tab list panel
Bundle 'kien/tabman.vim'
" Terminal Vim with 256 colors colorscheme
Bundle 'fisadev/fisa-vim-colorscheme'
Bundle 'manuscript'
Bundle 'Wombat'
" Indent text object
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'bufexplorer.zip'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'mbbill/undotree'

" General Programming
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdcommenter'
Bundle 'majutsushi/tagbar'

" Snippets & AutoComplete
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet'
Bundle 'honza/snipmate-snippets'
Bundle 'OmniCppComplete'
"Bundle 'AutoComplPop'
"Bundle 'ervandew/supertab'

" Yank history navigation
Bundle 'YankRing.vim'
Bundle 'FencView.vim'

" Installing plugins the first time
if MySys() == "linux"
    if vundle_installed == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :BundleInstall
    endif
endif

filetype plugin indent on

" Key map settings
let mapleader = " "
let maplocalleader = '_'

" Display related
set number
set showmatch
set showmode
set showcmd
set ruler
if has('statusline')
    set laststatus=2
    "let g:Powerline_symbols = 'fancy'
    set statusline=
    "set statusline+=%1* "switch to User1 highlight
    "set statusline+=%{getcwd()}\ > "current working dir
    "set statusline+=%#ErrorMsg#
    "set statusline+=\ %F "relative path
    set statusline+=%<%f\    " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=%= "split left and right
    set statusline+=\ %{&ft}:%{&ff}:%{&fenc} "file encoding
    set statusline+=\ U+%B "value of byte under cursor
    "set statusline+=\ %-14.(%l,%c%V%)\ %p%% "line percentage in file
    set statusline+=\ %(%l,%c%V%)\ %p%% "line percentage in file
    set statusline+=%< "truncate
    ""set statusline+=%{fugitive#statusline()} "  Git Hotness
endif
"set listchars=nbsp:·,tab:©¬,eol:¶,trail:§,extends:»,precedes:«
set listchars=tab:>-,eol:¬,trail:$,extends:»,precedes:«
syntax on
set nowrap
"set spell
" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3
" only show 15 tab
set tabpagemax=15
" allow for cursor beyond last character
"set virtualedit=onemore
" better unix / windows compatibility
set viewoptions=folds,options,cursor,unix,slash
" abbrev. of messages (avoids 'hit enter')
set shortmess+=filmnrxoOtT
set splitbelow
if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    let g:solarized_contrast="high"
    let g:solarized_visibility="high"
endif

set background=dark
if has("gui_running")
    set guioptions+=b
    set guioptions-=m
    set guioptions-=T
    set guifont=Monaco:h14
    "set guifont=Consolas:h14:cANSI
    "set guifont=Bitstream_Vera_Sans_Mono:h14:cANSI
    "set gfw=Yahei_Mono:h10.5:cGB2312
    colorscheme solarized
    if MySys() == "windows"
        au GUIEnter * simalt ~x
    endif
else
    colorscheme wombat
    " use 256 colors when possible
    if &term =~? 'mlterm\|xterm\|screen-256'
        let &t_Co = 256
    endif
endif

" Strip whitespace
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap <silent> <leader>trs :call StripTrailingWhitespace()<cr>:w<cr>

"{{{ Toggle dark/light background for solarized
nmap <leader>tb :call ToggleSolarized()<CR>
function! ToggleSolarized()
    if &background == 'dark'
        set background=light
        colorscheme solarized
    elseif &background == 'light'
        set background=dark
        colorscheme solarized
    endif
endfunc
"}}}

"{{{ Toggle cursorcolumn highlight
nnoremap <leader>tcc :call Toggle_Cursor_Column_Highlight()<CR>
let s:cchlflag=0
function! Toggle_Cursor_Column_Highlight()
    if s:cchlflag == 0
        set cursorcolumn
        let s:cchlflag = 1
    else
        set nocursorcolumn
        let s:cchlflag = 0
    endif
endfunction
"}}}

function! Toggle_Line_Number()
    if &nu
        setl rnu
    elseif &rnu
        setl nornu
    else
        setl nu
    endif
endfunction
nnoremap <silent> <leader>tln :call Toggle_Line_Number()<CR>

" Fold Setting
set foldenable
set foldmethod=syntax
set foldlevel=100
"set foldopen=block,hor
"set foldopen+=percent,mark
"set foldopen+=quickfix
set foldopen-=search     " dont open folds when I search into thm
set foldopen-=undo       " dont open folds when I undo stuff

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
set mousehide
set mousemodel=popup
" allow buffer switching without saving
set hidden

" Tab related
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
" Tablength exceptions
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
map <silent> <leader>t2 :set tabstop=2 shiftwidth=2<cr>
map <silent> <leader>t4 :set tabstop=4 shiftwidth=4<cr>
map <silent> <leader>t8 :set tabstop=8 shiftwidth=8<cr>

" Indent related
set cindent
set autoindent
set smartindent
set cinoptions=:0g0t0(susj1

" Temp folder used to store swap and undo files.
let s:vimtmp = $HOME."/.vimtmp"

" [create temp dir if not exists]
if getftype(s:vimtmp) != "dir"
    if mkdir(s:vimtmp) == 0
        echoerr "Can not create undo directory: ".s:vimtmp
    endif
endif

" [presistent-undo]
if has("persistent_undo")
    let &undodir = s:vimtmp
    set undofile
endif

" [swap folder]
let &directory = s:vimtmp

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
    if !filereadable("tags")
        call system("ctags -R --sort=yes --c-kinds=+p --c++-kinds=+p --fields=+liaS --extra=+q .")
    endif
    if has("cscope")
        if cscope_connection() == 1
            cs kill -1
            cclose
            return
        endif
        set csprg=cscope
        set cscopetagorder=1
        set nocscopetag
        set cscopequickfix=c-,d-,e-,f-,g-,i-,s-,t-
        set nocscopeverbose
        " add any database in current directory
        if filereadable("cscope.out")
            cs add cscope.out
            "copen
        else
            let msg="Create cscope.out here?\n".getcwd()
            let result=confirm(msg,"&Yes\n&No",1,"Question")
            if result==1
                call system("cscope -b -k -q -R")
                cs add cscope.out
                "copen
            endif
        endif
        set cscopeverbose
    endif
endfunction
nnoremap <silent><F4> :call ToggleCscopeCtags()<CR>
"inoremap <silent><F4> <ESC>:call ToggleCscopeCtags()<CR>

" [Cscope hot keys]
nnoremap <leader>fc :cs find c <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>fd :cs find d <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>fe :cs find e <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>ff :cs find f <c-r>=expand("<cfile>")<cr><cr>
nnoremap <leader>fg :cs find g <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>fi :cs find i ^<c-r>=expand("<cfile>")<cr>$<cr>
nnoremap <leader>fs :cs find s <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>ft :cs find t <c-r>=expand("<cword>")<cr><cr>

nnoremap <silent> <leader>sfc :scs find c <c-r>=expand("<cword>")<cr><cr>
nnoremap <silent> <leader>sfd :scs find d <c-r>=expand("<cword>")<cr><cr>
nnoremap <silent> <leader>sfe :scs find e <c-r>=expand("<cword>")<cr><cr>
nnoremap <silent> <leader>sff :scs find f <c-r>=expand("<cfile>")<cr><cr>
nnoremap <silent> <leader>sfg :scs find g <c-r>=expand("<cword>")<cr><cr>
nnoremap <silent> <leader>sfi :scs find i ^<c-r>=expand("<cfile>")<cr>$<cr>
nnoremap <silent> <leader>sfs :scs find s <c-r>=expand("<cword>")<cr><cr>
nnoremap <silent> <leader>sft :scs find t <c-r>=expand("<cword>")<cr><cr>

" C-]: Show list of matching tags when more than one tag matches <cword>.
noremap <c-]> g<c-]>

"map <Leader>mbe :MiniBufExplorer<cr>
"map <Leader>mbc :CMiniBufExplorer<cr>
"map <Leader>mbt :TMiniBufExplorer<cr>
let g:miniBufExplSplitBelow=0
"let g:miniBufExplSplitToEdge=0
"let g:miniBufExplorerMoreThanOne=1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplTabWrap = 1
"let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplMaxSize =1

nnoremap <silent><F1> :BufExplorer<CR>
nnoremap <silent><F2> :NERDTreeToggle<CR>
inoremap <F2> <ESC>:NERDTreeToggle<CR>
nnoremap <silent><F3> :TagbarToggle<CR>
inoremap <F3> <ESC>:TagbarToggle<CR>

set sessionoptions=blank,buffers,sesdir,folds,tabpages,winsize,slash,unix
nmap <leader>sl :SessionList<CR>
nmap <leader>ss :SessionSave<CR>

" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>
nnoremap <Leader>z @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

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
nmap <Leader>tsl :set list!<CR>
nmap <silent> <leader>/ :nohlsearch<CR>

" Toggle Undotree
nnoremap <Leader>tud :UndotreeToggle<cr>

" Tab navigation
map <C-A-h> :tabp<CR>
map <C-A-l> :tabn<CR>
imap <C-A-h> <ESC>:tabp<CR>
imap <C-A-l> <ESC>:tabn<CR>
"map <C-S-m> :tabm<CR>
"map tt :tabnew<CR>

" Navigate windows with ALT+arrows
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
"imap <C-j> <ESC><C-w>j
"imap <C-k> <ESC><C-w>k
"imap <C-h> <ESC><C-w>h
"imap <C-l> <ESC><C-w>l

nmap <C-right> :bn<CR>
nmap <C-left> :bp<CR>

noremap! <M-j> <Down>
noremap! <M-k> <Up>
noremap! <M-h> <left>
noremap! <M-l> <Right>

"Quickfix
nmap <silent><leader>qn :cn<CR>
nmap <silent><leader>qp :cp<CR>
nmap <silent><leader>cw :cw 10<CR>

com! -bang -nargs=? QFix cal QFixToggle(<bang>0)
fu! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced == 0
        cclose
        unlet g:qfix_win
    else
        copen 5
        let g:qfix_win = bufnr("$")
    en
endf
nnoremap <silent><leader>q :QFix<cr>

" FencView
let g:fencview_autodetect=0

" NERDTree
map <leader>ntm :NERDTreeMirror<CR>
map <leader>ntf :NERDTreeFind<CR>
let NERDChristmasTree=1
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks=1
let NERDTreeIgnore = ['\~$', '\obj$[[dir]]', '\.$[[dir]]', '\.o$', '\.swp$','\.db$', '\.git', '\.hg', '\.svn', '\.bzr']
"let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeMouseMode=2

" BufExplorer
let g:bufExplorerSplitBelow=1

"nmap <silent><F3> :execute "let g:word=expand(\"<cword>\")"<Bar>execute "/" . g:word<CR>
nmap <silent><leader>f :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
map <silent><F3> *

" CtrlP (new fuzzy finder)
let g:ctrlp_map = '<leader>p'
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

" [add a header to the top of the file]
function! Toggle_Add_Header()
    let headerstr=[]
    let headerdict={}
    let order=['\file','\brief','\author','\date',' ','\note']
    let headerdict[order[0]]=expand("%:t")
    let headerdict[order[1]]=inputdialog("Input the brief of this file: (<=35 characters)")
    let headerdict[order[2]]=g:author
    let headerdict[order[3]]=strftime("%Y-%m-%d %H:%M:%S")
    let headerdict[order[4]]=''
    let headerdict[order[5]]='some notes'
    let headerstr+=["\/\*\*"]
    for i in order
        let headerstr+=[printf(" \* %s",printf("%-14s%-s",i,headerdict[i]))]
    endfor
    let headerstr+=[" \*\/"]
    call append(0,headerstr)
    call setpos(".",[0,1,1,"off"])
endfunction
nnoremap <silent> <leader>tah :call Toggle_Add_Header()<CR>

" old autocomplete keyboard shortcut
imap <C-J> <C-X><C-O>

" OmniComplete {
if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
                \if &omnifunc == "" |
                \setlocal omnifunc=syntaxcomplete#Complete |
                \endif
endif

hi Pmenu guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
hi PmenuSbar guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
hi PmenuThumb guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

" some convenient mappings
"inoremap <expr><Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
"inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr><C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
"inoremap <expr><C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menu,preview,longest
set completeopt=menuone,longest
" }

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
let g:neocomplcache_max_list = 15
let g:neocomplcache_enable_ignore_case = 0
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_force_overwrite_completefunc = 1
"let g:neocomplcache_disable_auto_complete = 1

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
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
"smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

" <TAB>: completion.
"inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup
" <S-CR>: close popup and save indent
inoremap <expr><CR>   pumvisible() ? neocomplcache#close_popup() : "\<CR>"
inoremap <expr><S-CR> pumvisible() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS>   neocomplcache#smart_close_popup()."\<BS>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left> neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up> neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down> neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

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
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

" Enable heavy omni completion, which require computational power and may stall the vim.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

" use honza's snippets
let g:neosnippet#snippets_directory=expand('~/.vim/bundle/snipmate-snippets/snippets')

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif

"" OmniCppComplete
"" use global scope search
"let OmniCpp_GlobalScopeSearch = 1
"" 0 = namespaces disabled
"" 1 = search namespaces in the current buffer
"" 2 = search namespaces in the current buffer and in included files
"let OmniCpp_NamespaceSearch = 2
"" 0 = auto
"" 1 = always show all members
"let OmniCpp_DisplayMode = 1
"" 0 = don't show scope in abbreviation
"" 1 = show scope in abbreviation and remove the last column
"let OmniCpp_ShowScopeInAbbr = 0
"" This option allows to display the prototype of a function in the abbreviation part of the popup menu.
"" 0 = don't display prototype in abbreviation
"" 1 = display prototype in abbreviation
"let OmniCpp_ShowPrototypeInAbbr = 1
"" This option allows to show/hide the access information ('+', '#', '-') in the popup menu.
"" 0 = hide access
"" 1 = show access
"let OmniCpp_ShowAccess = 1
"" This option can be use if you don't want to parse using namespace declarations in included files and want to add
"" namespaces that are always used in your project.
"let OmniCpp_DefaultNamespaces = ["std"]
"" Complete Behaviour
"let OmniCpp_MayCompleteDot = 1
"let OmniCpp_MayCompleteArrow = 1
"let OmniCpp_MayCompleteScope = 1
"" When 'completeopt' does not contain "longest", Vim automatically select the first entry of the popup menu. You can
"" change this behaviour with the OmniCpp_SelectFirstItem option.
"" 0 = don't select first popup item
"" 1 = select first popup item (inserting it to the text)
"" 2 = select first popup item (without inserting it to the text)
"let OmniCpp_SelectFirstItem = 1

" NERDComment
"imap <C-S-c> <plug>NERDCommenterInsert
let g:NERDRemoveExtraSpaces = 1

"let g:AutoClosePairs_add = "<>"
" Fix to let ESC work as espected with Autoclose plugin
"let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}


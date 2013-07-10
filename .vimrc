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
    autocmd! bufwritepost _vimrc source %
else
    " on Linux use + register for copy-paste
    set clipboard=unnamedplus
    autocmd! bufwritepost .vimrc source %
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
set langmenu=en_US.UTF-8
language messages en_US.UTF-8
set ambiwidth=single

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
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'Townk/vim-autoclose'
Bundle 'kien/ctrlp.vim'
"Bundle 'xolox/vim-session'
Bundle 'sessionman.vim'
Bundle 'matchit.zip'
"Bundle 'Yggdroot/vim-mark'
Bundle 'IndexedSearch'
"Bundle 'SearchComplete'
Bundle 'Lokaltog/vim-easymotion'
"Bundle 'kien/tabman.vim'
Bundle 'oblitum/rainbow'
"Bundle 'kien/rainbow_parentheses.vim'
" Input Method
Bundle 'VimIM'
" Colorscheme
Bundle 'altercation/vim-colors-solarized'
Bundle 'tomasr/molokai'
Bundle 'morhetz/gruvbox'
Bundle 'nanotech/jellybeans.vim'
Bundle 'sjl/badwolf'
Bundle 'Wombat'
Bundle 'manuscript'
Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'chriskempson/base16-vim'

"if (has("python") || has("python3")) 
    "Bundle 'Lokaltog/powerline', {'rtp':'powerline/bindings/vim'}
"else
    "Bundle 'Lokaltog/vim-powerline'
"endif
Bundle 'bling/vim-airline'
"Bundle 'millermedeiros/vim-statline'
"Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'Yggdroot/indentLine'
"Bundle 'michaeljsmith/vim-indent-object'
Bundle 'bufexplorer.zip'
Bundle 'fholgado/minibufexpl.vim'
"Bundle 'mbbill/undotree'
Bundle 'YankRing.vim'
Bundle 'FencView.vim'

" General Programming
"Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdcommenter'
Bundle 'majutsushi/tagbar'
"Bundle 'mileszs/ack.vim'
"Bundle 'grep.vim'
"Bundle 'EasyGrep'
Bundle 'derekwyatt/vim-fswitch'
"Bundle 'motemen/git-vim'
Bundle 'godlygeek/tabular'

" Snippets & AutoComplete
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet'
"Bundle 'honza/snipmate-snippets'
"Bundle 'OmniCppComplete'
"Bundle 'AutoComplPop'
"Bundle 'ervandew/supertab'

" Python
"Bundle 'klen/python-mode'
"Bundle 'pyflakes.vim'
"Bundle 'fisadev/vim-debug.vim'

Bundle 'pangloss/vim-javascript'

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
let maplocalleader = "-"

" Display related
set number
set showmatch
set noshowmode
set showcmd
set ruler
set shortmess=atI
"set cursorcolumn
set cursorline
"set colorcolumn=+1
if has('statusline')
    set laststatus=2
    let g:Powerline_symbols = "fancy"
    let g:airline_powerline_fonts=1
    "set statusline=
    "set statusline+=%1* "switch to User1 highlight
    "set statusline+=\ %F "relative path
    "set statusline+=%<%f\    " Filename
    "set statusline+=%w%h%m%r " Options
    "set statusline+=%= "split left and right
    "set statusline+=\ %{&ft}:%{&ff}:%{&fenc} "file encoding
    "set statusline+=\ U+%B "value of byte under cursor
    "set statusline+=\ %-14.(%l,%c%V%)\ %p%% "line percentage in file
    "set statusline+=\ %(%l,%c%V%)\ %p%% "line percentage in file
    "set statusline+=%< "truncate
endif
syntax on
set nowrap
"set spell
" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3
" only show 15 tab
"set tabpagemax=15
" allow for cursor beyond last character
"set virtualedit=onemore
" better unix / windows compatibility
set viewoptions=folds,options,cursor,unix,slash
" abbrev. of messages (avoids 'hit enter')
set shortmess+=filmnrxoOtT
set splitbelow

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
set noswapfile
" Tab related
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
" Tablength exceptions
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
map <silent><leader>t2 :set tabstop=2 shiftwidth=2<CR>
map <silent><leader>t4 :set tabstop=4 shiftwidth=4<CR>
map <silent><leader>t8 :set tabstop=8 shiftwidth=8<CR>

" Indent related
set cindent
set autoindent
set smartindent
set cinoptions=:0g0t0(susj1

set undodir=$HOME/.vim/undo     " undo files
set backupdir=$HOME/.vim/backup " backups
set viewdir=$HOME/.vim/views    " view files
set directory=$HOME/.vim/swap   " swap files
" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&viewdir))
    call mkdir(expand(&viewdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

"{{{ Set up cscope and ctag  environment
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

set csprg=cscope
" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
set cscopetag
" check cscope for definition of a symbol before checking ctags:
" set to 1 if you want the reverse search order.
set cscopetagorder=0
set cscopequickfix=c-,d-,e-,f-,g-,i-,s-,t-

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
nnoremap <silent><C-F4> :call ToggleCscopeCtags()<CR>
nnoremap <silent><leader>tcs :call ToggleCscopeCtags()<CR>

" The following maps all invoke one of the following cscope search types:
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls
nnoremap <silent><leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>fe :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <silent><leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <leader>fu :cs find s

nnoremap <silent><leader>vfs :scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>vfg :scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>vfd :scs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>vfc :scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>vft :scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>vfe :scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <silent><leader>vff :scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <silent><leader>vfi :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"}}}

"{{{ Toggle darkStrip whitespace
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
nmap <silent><leader>trs :call StripTrailingWhitespace()<CR>:w<CR>
"}}}

"{{{ Remove the Windows ^M
noremap <silent><leader>trm mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm
"}}}

" show invisible chars
nmap <silent><leader>tsl :set list! listchars=tab:>-,eol:¬,trail:$,extends:»,precedes:«<CR>

nmap <silent><leader>tst :set list! lcs=tab:\\|\ <CR>

" Toggle paste mode
nmap <silent><leader>tp :set invpaste<CR>:set paste?<CR>

"Fast redraw
nmap <silent><leader>trd :redraw!<CR>

"{{{ Toggle cursorcolumn highlight
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
nmap <silent><leader>tcc :call Toggle_Cursor_Column_Highlight()<CR>
"}}}

"{{{ Toggle line number
function! Toggle_Line_Number()
    if &nu
        setl rnu
    elseif &rnu
        setl nornu
    else
        setl nu
    endif
endfunction
nmap <silent><leader>tln :call Toggle_Line_Number()<CR>
"}}}

"{{{ Toggle full screen
let g:fullscreen = 0
function! ToggleFullscreen()
    if g:fullscreen == 1
        let g:fullscreen = 0
        let mod = "remove"
    else
        let g:fullscreen = 1
        let mod = "add"
    endif
    call system("wmctrl -ir " . v:windowid . " -b " . mod . ",fullscreen")
endfunction
map <silent><F11> :call ToggleFullscreen()<CR>
"}}}

" Highlight Class and Function names
function! s:HighlightFunctionsAndClasses()
  syn match cCustomFunc "\w\+\s*\((\)\@="
  syn match cCustomClass "\w\+\s*\(::\)\@="

  hi def link cCustomFunc Function
  hi def link cCustomClass Function
endfunction
au Syntax * call s:HighlightFunctionsAndClasses()

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
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
nnoremap <silent><leader>cd :cd %:p:h<CR>

" Fast saving
nmap <silent><leader>ww :w<CR>
nmap <silent><leader>wf :w!<CR>

" Fast quiting
nmap <silent><leader>qw :wq<CR>
nmap <silent><leader>qf :q!<CR>
nmap <silent><leader>qq :q<CR>
nmap <silent><leader>qa :qa<CR>

" Fast remove highlight search
nmap <silent><leader>/ :nohlsearch<CR>

"Favorite filetypes
set ffs=unix,dos

nmap <silent><leader>ffd :se ff=dos<CR>
nmap <silent><leader>ffu :se ff=unix<CR>

" easier navigation between split window
noremap <C-J>     <C-W>j
noremap <C-K>     <C-W>k
noremap <C-H>     <C-W>h
noremap <C-L>     <C-W>l
noremap <C-Down>  <C-W>j
noremap <C-Up>    <C-W>k
noremap <C-Left>  <C-W>h
noremap <C-Right> <C-W>l
"imap <C-j> <ESC><C-w>j
"imap <C-k> <ESC><C-w>k
"imap <C-h> <ESC><C-w>h
"imap <C-l> <ESC><C-w>l

" [Switch tab pages]
nnoremap <M-h> gT
nnoremap <M-l> gt
nmap <leader>h :tabn<CR>
nmap <leader>l :tabp<CR>
nmap <silent><leader>tn :tabn<CR> 
nmap <silent><leader>tp :tabp<CR>

map <M-1> 1gt
map <M-2> 2gt
map <M-3> 3gt
map <M-4> 4gt
map <M-5> 5gt
map <M-6> 6gt
map <M-7> 7gt
map <M-8> 8gt
map <M-9> 9gt

imap <M-1> 1gt
imap <M-2> 2gt
imap <M-3> 3gt
imap <M-4> 4gt
imap <M-5> 5gt
imap <M-6> 6gt
imap <M-7> 7gt
imap <M-8> 8gt
imap <M-9> 9gt

nmap <leader>j :bn<CR>
nmap <leader>k :bp<CR>
nmap <leader>bn :bn<CR>
nmap <leader>bp :bp<CR>
nmap <M-j> :bn<CR>
nmap <M-k> :bp<CR>

"noremap! <M-j> <Down>
"noremap! <M-k> <Up>
"noremap! <M-h> <left>
"noremap! <M-l> <Right>

" g<c-]> is jump to tag if there's only one matching tag, but show list of
" options when there is more than one definition
nnoremap <leader>g g<c-]>
noremap <c-]> g<c-]>

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
nnoremap <silent><leader>z @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

nmap <silent><F3> *
nmap <silent><C-F3> #

"{{{ Basically you press * or # to search for the current selection
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        execute "Ack " . l:pattern . ' %'
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>

vnoremap <silent><F3> :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent><C-F3> :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
"}}}

"nmap <silent><unique><leader>c <Plug>MarkClear
"nmap <silent><unique><leader>* <Plug>MarkSearchAnyNext
"nmap <silent><unique><leader>n <Plug>MarkSearchCurrentNext
"nmap <silent><unique><leader>N <Plug>MarkSearchCurrentPrev

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
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
nnoremap <silent><leader>cd :cd %:p:h<CR>

"{{{ Add a header to the top of the file
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
"}}}

"{{{ Quickfix
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
nnoremap <silent><leader>q :QFix<CR>
nmap <silent><leader>qn :cn<CR>
nmap <silent><leader>qp :cp<CR>
"}}}

" Plugin Setting
nnoremap <silent><leader>tyr :YRShow<CR>
let g:yankring_history_dir = expand('$HOME/.vim')
let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'

"{{{ molokai colorscheme setting
let g:molokai_original = 1
"}}}

"{{{ vim-indent-guides setting
if isdirectory(expand("~/.vim/bundle/vim-indent-guides"))
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_start_level = 2
    let g:indent_guides_soft_pattern = ' '
    let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']
    nmap <silent><leader>tig <Plug>IndentGuidesToggle
endif
"}}}

"{{{ indentLine setting
if isdirectory(expand("~/.vim/bundle/indentLine"))
    "let g:indentLine_showFirstIndentLevel = 1
    let g:indentLine_enabled = 0 
    nmap <silent><leader>tst :set list! lcs=tab:\\|\ <CR>
    nmap <silent><leader>tsi :IndentLinesToggle<CR>
endif
"}}}

"{{{ fswitch
nnoremap <leader>sh :FSHere<CR>
nnoremap <leader>sr :FSSplitRight<CR>
nnoremap <leader>sb :FSSplitBelow<CR>
nnoremap <leader>sa :FSSplitAbove<CR>
"}}}

"{{{ Tabularize
nmap <leader>a= :Tabularize /=<CR>
vmap <leader>a= :Tabularize /=<CR>
nmap <leader>a: :Tabularize /:\zs<CR>
vmap <leader>a: :Tabularize /:\zs<CR>
nmap <leader>a:: :Tabularize /:<CR>
vmap <leader>a:: :Tabularize /:<CR>
nmap <leader>a& :Tabularize /&<CR>
vmap <leader>a& :Tabularize /&<CR>
nmap <leader>a, :Tabularize /,<CR>
vmap <leader>a, :Tabularize /,<CR>
nmap <leader>a<Bar> :Tabularize /<Bar><CR>
vmap <leader>a<Bar> :Tabularize /<Bar><CR>
"}}}

let g:EasyMotion_leader_key = '<leader><leader>'

" BufExplorer
let g:bufExplorerSplitBelow=1
nnoremap <silent><F1> :BufExplorer<CR>
nnoremap <silent><leader>tbe :BufExplorer<CR>
"map <leader>mbe :MiniBufExplorer<CR>
"map <leader>mbc :CMiniBufExplorer<CR>
"map <leader>mbt :TMiniBufExplorer<CR>
let g:miniBufExplSplitBelow=0
"let g:miniBufExplSplitToEdge=0
let g:miniBufExplorerMoreThanOne=100
let g:miniBufExplModSelTarget = 1
let g:miniBufExplTabWrap = 1
"let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplMaxSize =1

"{{{ Session List
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
nmap <silent><leader>sl :SessionList<CR>
nmap <leader>ss :SessionSave<CR>
"}}}

"{{{ Tabmam setting
let g:tabman_toggle= '<leader>ttm'
let g:tabman_focus= '<leader>tmf'
"let g:tabman_number=0
"}}}

" rainbow colors copied from and best suited for dark gruvbox colorscheme (https://github.com/morhetz/gruvbox):
let g:rainbow_guifgs = [
    \ '#458588',
    \ '#b16286',
    \ '#cc241d',
    \ '#d65d0e',
    \ '#458588',
    \ '#b16286',
    \ '#cc241d',
    \ '#d65d0e',
    \ '#458588',
    \ '#b16286',
    \ '#cc241d',
    \ '#d65d0e',
    \ '#458588',
    \ '#b16286',
    \ '#cc241d',
    \ '#d65d0e',
    \ ]
au FileType c,cpp,objc,objcpp call rainbow#load()

"{{{ rainbow_parentheses setting
if isdirectory(expand("~/.vim/bundle/rainbow_parentheses"))
    let g:rbpt_colorpairs = [
        \ ['brown',       'RoyalBlue3'],
        \ ['Darkblue',    'SeaGreen3'],
        \ ['darkgray',    'DarkOrchid3'],
        \ ['darkgreen',   'firebrick3'],
        \ ['darkcyan',    'RoyalBlue3'],
        \ ['darkred',     'SeaGreen3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['brown',       'firebrick3'],
        \ ['gray',        'RoyalBlue3'],
        \ ['black',       'SeaGreen3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['Darkblue',    'firebrick3'],
        \ ['darkgreen',   'RoyalBlue3'],
        \ ['darkcyan',    'SeaGreen3'],
        \ ['darkred',     'DarkOrchid3'],
        \ ['red',         'firebrick3'],
        \ ]
    let g:rbpt_max = 16
    let g:rbpt_loadcmd_toggle = 0

    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
endif
"}}}

"{{{ Tagbar Toggle
nnoremap <silent><F4> :TagbarToggle<CR>
let g:tagbar_autofocus=1
let g:tagbar_ctags_bin = ctagsbin
"}}}

" Toggle Undotree
nnoremap <leader>tud :UndotreeToggle<CR>

" FencView
let g:fencview_autodetect=0

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.aux,*.bbl,*.blg,*.toc,*.out,*.bak,*.mtc0,*.maf,*.mtc

"{{{ NERDTree
nnoremap <silent><F2> :NERDTreeToggle<CR>
inoremap <silent><F2> <ESC>:NERDTreeToggle<CR>
map <silent><leader>ntm :NERDTreeMirror<CR>
map <silent><leader>ntt :NERDTreeToggle<CR>
map <silent><leader>ntf :NERDTreeFind<CR>
let NERDChristmasTree=1
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks=1
let NERDTreeIgnore = ['\~$', '\obj$[[dir]]', '\.$[[dir]]', '\.o$', '\.swp$','\.db$', '\.git', '\.hg', '\.svn', '\.bzr']
"let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeMouseMode=2
"let g:NERDTreeBookmarksFile = expand("$HOME/.vim/NERDTreeBookmarks")
"}}}

" NERDComment
"imap <C-S-c> <plug>NERDCommenterInsert
let g:NERDRemoveExtraSpaces = 1

" simple recursive grep
command! -nargs=1 RecurGrep lvimgrep /<args>/gj ./**/*.* | lopen | set nowrap
command! -nargs=1 RecurGrepFast silent exec 'lgrep! <q-args> ./**/*.*' | lopen
map <C-F1> :execute "vimgrep /" . expand("<cword>") . "/gj **" <Bar> cw<CR>

noremap <silent><leader>a :Ack! <cword><CR>
noremap <silent><leader>aa :Ack! -a <cword><CR>
noremap <silent><leader>w :Ack! -w <cword><CR>
noremap <silent><leader>wa :Ack! -a -w <cword><CR>
noremap <silent><leader>A :Ack! <cword> %<CR>
noremap <silent><leader>W :Ack! -w <cword> %<CR>

let g:EasyGrepCommand=1
let g:EasyGrepRecursive=1
let g:EasyGrepJumpToMatch=0

" CtrlP (new fuzzy finder)
let g:ctrlp_map = '<leader>p'
let g:ctrlp_by_filename = 1
" Don't change working directory
let g:ctrlp_working_path_mode = 0
" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
    execute ':CtrlP' . a:ctrlp_command_end
    call feedkeys(a:search_text)
endfunction
" CtrlP with default text
nmap <leader>fpt  :call CtrlPWithSearchText(expand('<cword>'), 'Tag')<CR>
nmap <leader>fpl  :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nmap <leader>fpb  :call CtrlPWithSearchText(expand('<cword>'), 'Buffer')<CR>
nmap <leader>fps  :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nmap <leader>fpa  :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
nmap <leader>fpm  :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
nmap <leader>fpw  :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nmap <leader>fpf  :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
" Ignore files on fuzzy finder
let g:ctrlp_custom_ignore = {
            \ 'dir': '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.pyc$\|\.pyo$|\.o$',
            \ }

let g:ctrlp_user_command = {
            \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': 'find %s -type f'
            \ }

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

"let g:AutoClosePairs_add = "<>"
" Fix to let ESC work as espected with Autoclose plugin
"let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}


set background=dark

" solarized
if isdirectory(expand("~/.vim/bundle/vim-colors-solarized"))
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    let g:solarized_contrast="high"
    "let g:solarized_visibility="high"
endif

" molokai
if isdirectory(expand("~/.vim/bundle/molokai"))
    "let g:molokai_original = 1
endif

if has("gui_running")
    set guioptions+=b
    set guioptions-=m
    set guioptions-=T
    colorscheme molokai
    if MySys() == "windows"
        set guifont=Powerline_Consolas:h11:cANSI
        au GUIEnter * simalt ~x
    else
        au GUIEnter * set lines=999 columns=999
        set guifont=Monaco\ for\ Powerline\ 12
    endif
else
    if MySys() == "windows"
        let &t_Co = 16
        colorscheme desert
    else
        " use 256 colors when possible
        if &term =~? 'mlterm\|xterm\|screen-256'
            let &t_Co = 256
        else
            let &t_Co = 16
        endif
        colorscheme jellybeans
    endif
endif

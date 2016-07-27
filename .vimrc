" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=100 foldmethod=marker :
" }

" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

" }

" Leader Key (re)Mappings {

    " The default leader is '\', but I prefer space key
    let mapleader = ' '
    let maplocalleader = ' '
" }

" Initialize default settings {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'cache': 'g:cache_dir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        let common_dir = parent . '/.' . prefix . '/'

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                if dirname != 'cache'
                    exec "set " . settingname . "=" . directory
                else
                    "exec "let " . settingname . "=" . directory
                    let g:cache_dir = directory
                endif
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " get the directory name {
    function! s:get_cache_dir(suffix)
        return resolve(expand(g:cache_dir . '/' . a:suffix))
    endfunction
    " }

    let g:m_vim_settings = {}

    let g:m_vim_settings.plugin_groups = []
    call add(g:m_vim_settings.plugin_groups, 'general')
    call add(g:m_vim_settings.plugin_groups, 'programming')
    call add(g:m_vim_settings.plugin_groups, 'scm')
    call add(g:m_vim_settings.plugin_groups, 'youcompleteme')
    "call add(g:m_vim_settings.plugin_groups, 'neocomplcache')
    "call add(g:m_vim_settings.plugin_groups, 'neocomplete')
    "call add(g:m_vim_settings.plugin_groups, 'python')
    "call add(g:m_vim_settings.plugin_groups, 'javascript')
    "call add(g:m_vim_settings.plugin_groups, 'html')
    "call add(g:m_vim_settings.plugin_groups, 'php')
    "call add(g:m_vim_settings.plugin_groups, 'scala')
    "call add(g:m_vim_settings.plugin_groups, 'haskell')
    "call add(g:m_vim_settings.plugin_groups, 'ruby')
    "call add(s:m_vim_settings.plugin_groups, 'go')
    "call add(g:m_vim_settings.plugin_groups, 'misc')

" }

" Use local config if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {

    set background=dark         " Assume a dark background

    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing

    if has('clipboard')
        " By default, Vim will not use the system clipboard when yanking/pasting to
        " the default register. This option makes Vim use the system default clipboard.
        " Note that on X11, there are _two_ system clipboards: the "standard" one, and
        " the selection/mouse-middle-click one. Vim sees the standard one as register
        " '+' (and this option makes Vim use it by default) and the selection one as '*'.
        " See :h 'clipboard' for details.
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    set autoread                         " Auto reload if file saved externally
    set shortmess=atTI                   " Abbrev. of messages (avoids 'hit enter')
    "set cmdheight=2
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    "set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set novisualbell                    " don't beep
    set noerrorbells                    " don't beep
    set t_vb=

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Setting up the directories {
        set backup                  " Backups are nice ...
        set noswapfile              " swap files
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
                    \ '\[example pattern\]'
                    \ ]
    " }

" }

" Vim UI {

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number
    "set cursorcolumn       " highlights the current column
    "set colorcolumn=+1     " this makes the column after the textwidth  highlighted

    if has('cmdline_info')
        "set ruler                   " Show the ruler
        "set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        "set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        "set statusline=%<%f\                     " Filename
        "set statusline+=%w%h%m%r                 " Options
        "set statusline+=%{fugitive#statusline()} " Git Hotness
        "set statusline+=\ [%{&ff}/%Y]            " Filetype
        "set statusline+=\ [%{getcwd()}]          " Current dir
        "set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Allow backspacing everything in insert mode
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set winminheight=0              " Windows can be 0 line high
    set wildmenu                    " Show list instead of just completing
    "set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set wildmode=longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    "set list
    "set listchars=tab:>-,eol:¬,trail:•,nbsp:.,extends:»,precedes:« " Highlight problematic whitespace
    set linebreak
    set title               " show file in titlebar
    set winaltkeys=no       " turns of the Alt key bindings to the gui menu
" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set cindent                     " Enables automatic C program indenting
    set cinoptions=:0g0t0(susj1
    set smartindent                 " Do smart autoindenting when starting a new line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set smarttab                    " Use shiftwidth to enter tabs
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType html,htmldjango,javascript setlocal shiftwidth=2 tabstop=2
    map <silent><leader>t2 :set tabstop=2 shiftwidth=2<CR>
    map <silent><leader>t4 :set tabstop=4 shiftwidth=4<CR>
    map <silent><leader>t8 :set tabstop=8 shiftwidth=8<CR>
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }

" Fold Setting {

    set foldenable                  " Auto fold code
    set foldmethod=syntax           "fold via syntax of files
    set foldlevel=100
    "set foldopen=block,hor
    "set foldopen+=percent,mark
    "set foldopen+=quickfix
    set foldopen+=search     " Dont open folds when I search into thm
    set foldopen-=undo       " Dont open folds when I undo stuff

    autocmd FileType c :syntax match comment "\v(^\s*//.*\n)+" fold | " 折叠C语言多行的//注释
    autocmd FileType cpp :syntax match comment "\v(^\s*//.*\n)+" fold | " 折叠C++多行的//注释
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
    autocmd FileType go :syntax match comment "\v(^\s*//.*\n)+" fold | " 折叠go多行的//注释
    autocmd FileType go :syntax region goImport start="($" end=")$" fold | " 折叠go的import ()导入
    let g:sh_fold_enabled = 1 " 开启shell脚本函数折叠支持
    autocmd FileType sh :syntax match comment "\v(^\s*[#]+.*\n)+" fold | " 折叠shell的#多行注释

" }

" Searching {

    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present

    if executable('ag')
        set grepprg=ag\ --nogroup\ --smart-case\ --nocolor\ --follow
        set grepformat=%f:%l:%c:%m
    elseif executable('ack')
        set grepprg=ack\ --nogroup\ --smart-case\ --nocolor\ --follow\ $*
        set grepformat=%f:%l:%c:%m
    endif

" }

set formatoptions+=mB

" Editing related
set keymodel=
set selectmode=
set selection=inclusive

" Misc
"set timeoutlen=250
set mousemodel=popup

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.aux,*.bbl,*.blg,*.toc,*.out,*.bak,*.mtc0,*.maf,*.mtc

" Key (re)Mappings {

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_
    noremap <C-J>     <C-W>j
    noremap <C-K>     <C-W>k
    noremap <C-H>     <C-W>h
    noremap <C-L>     <C-W>l
    noremap <C-Down>  <C-W>j
    noremap <C-Up>    <C-W>k
    noremap <C-Left>  <C-W>h
    noremap <C-Right> <C-W>l

    " Buffer moving
    nnoremap <leader>j :bn<CR>
    nnoremap <leader>k :bp<CR>
    nnoremap <leader>bn :bn<CR>
    nnoremap <leader>bp :bp<CR>
    nnoremap <TAB> :bn<CR>
    nnoremap <S-TAB> :bp<CR>

    " Tab moving
    "map <leader>tn :tabnew<cr>
    "map <leader>to :tabonly<cr>
    "map <leader>tc :tabclose<cr>
    "map <leader>tm :tabmove

    "" Opens a new tab with the current buffer's path
    "" Super useful when editing files in the same directory
    "map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

    nnoremap <M-h> gT
    nnoremap <M-l> gt
    imap <M-1> 1gt
    imap <M-2> 2gt
    imap <M-3> 3gt
    imap <M-4> 4gt
    imap <M-5> 5gt
    imap <M-6> 6gt
    imap <M-7> 7gt
    imap <M-8> 8gt
    imap <M-9> 9gt

    " Quickfix window
    nmap <silent><leader>qn :cn<CR>
    nmap <silent><leader>qp :cp<CR>

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap k gk
    nnoremap gk k
    nnoremap j gj
    nnoremap gj j

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

    " Go to home and end using capitalized directions
    noremap H ^
    noremap L $

    " Yank from the cursor to the end of the line, to be consistent with C and D
    nnoremap Y y$

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

    " Toggle search highlighting
    nmap <silent> <leader>/ :nohlsearch<CR>
    "nmap <silent> <leader>/ :set invhlsearch<CR>

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    nnoremap <silent><leader>cwd :cd %:p:h<CR>

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " select all
    map <Leader>sa ggVG"

    " select block
    nnoremap <leader>b V`}

    " Press F3 to search
    nmap <silent><F3>   *
    nmap <silent><C-F3> #

    " Basically you press * or # to search for the current selection
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

    " Type "jj" to exit out of insert mode
    inoremap jj <Esc>

    " Type "jk" to enter cmd mode
    "nnoremap jk :

    " Fast saving
    nmap <silent><leader>ww :w<CR>
    nmap <silent><leader>wf :w!<CR>

    " Fast quiting
    nmap <silent><leader>qw :wq<CR>
    nmap <silent><leader>qf :q!<CR>
    nmap <silent><leader>qq :q<CR>
    nmap <silent><leader>qa :qa<CR>

    " Remove the Windows ^M
    noremap <silent><leader>trm mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

    " Strip whitespace
    noremap <silent><leader>trs :call StripTrailingWhitespace()<CR>:w<CR>

    " show invisible chars
    nmap <silent><leader>tsl :set list! listchars=tab:>-,eol:¬,trail:$,extends:»,precedes:«<CR>
    nmap <silent><leader>tst :set list! lcs=tab:\\|\ <CR>

    " Toggle paste mode
    nmap <silent><leader>tp :set invpaste<CR>:set paste?<CR>

    "Fast redraw
    nmap <silent><leader>trd :redraw!<CR>

    " Toggle cursorcolumn highlight
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

    " Toggle line number
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

    "Favorite filetypes
    set ffs=unix,dos

    nmap <silent><leader>ffd :se ff=dos<CR>
    nmap <silent><leader>ffu :se ff=unix<CR>


    " Set up cscope and ctag environment {
        " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
        set cscopetag
        " check cscope for definition of a symbol before checking ctags:
        " set to 1 if you want the reverse search order.
        set cscopetagorder=0
        set cscopequickfix=c-,d-,e-,f-,g-,i-,s-,t-

        function! ToggleCscopeCtags()
            call system("ctags -R --sort=yes --c-kinds=+p --c++-kinds=+p --fields=+liaS --extra=+q .")
            if has("cscope")
                set cscopeverbose
                if cscope_connection() == 1
                    cs kill -1
                    cclose
                    return
                endif
                call system("cscope -b -k -q -R")
                cs add cscope.out
            endif
        endfunction
        nnoremap <silent><F5> :call ToggleCscopeCtags()<CR>
        nnoremap <silent><leader>tcs :call ToggleCscopeCtags()<CR>

        " g<c-]> is jump to tag if there's only one matching tag, but show list of
        " options when there is more than one definition
        nnoremap <leader>g <c-]>
        "noremap <c-]> g<c-]>
        
        " s: Find this C symbol
        nnoremap <silent><leader>fs :silent cs find s <C-R>=expand("<cword>")<CR><CR>
        " g: Find this definition
        nnoremap <silent><leader>fg :silent cs find g <C-R>=expand("<cword>")<CR><CR>
        " d: Find functions called by this function
        "nnoremap <silent><leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>
        " c: Find functions calling this function
        nnoremap <silent><leader>fd :cs find c <C-R>=expand("<cword>")<CR><CR>
        " t: Find this text string
        nnoremap <silent><leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>
        " e: Find this egrep pattern
        nnoremap <silent><leader>fe :cs find e <C-R>=expand("<cword>")<CR><CR>
        " f: Find this file
        nnoremap <silent><leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
        " i: Find files #including this file
        nnoremap <silent><leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

        nnoremap <silent><leader>vfs :scs find s <C-R>=expand("<cword>")<CR><CR>
        nnoremap <silent><leader>vfg :scs find g <C-R>=expand("<cword>")<CR><CR>
        nnoremap <silent><leader>vfd :scs find d <C-R>=expand("<cword>")<CR><CR>
        nnoremap <silent><leader>vfc :scs find c <C-R>=expand("<cword>")<CR><CR>
        nnoremap <silent><leader>vft :scs find t <C-R>=expand("<cword>")<CR><CR>
        nnoremap <silent><leader>vfe :scs find e <C-R>=expand("<cword>")<CR><CR>
        nnoremap <silent><leader>vff :scs find f <C-R>=expand("<cfile>")<CR><CR>
        nnoremap <silent><leader>vfi :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    " }

" }

" Plugins {

    " solarized colorscheme {
        if isdirectory(expand("~/.vim/bundle/vim-colors-solarized"))
            let g:solarized_termcolors=256
            let g:solarized_termtrans=1
            let g:solarized_contrast="normal"
            let g:solarized_visibility="normal"
        endif
    " }

    " molokai {
        if isdirectory(expand("~/.vim/bundle/molokai/"))
            let g:molokai_original = 1
        endif
    " }

    " vim-airline {
        if isdirectory(expand("~/.vim/bundle/vim-airline"))
            let g:airline_powerline_fonts=1
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#show_tab_type = 0
            let g:airline#extensions#tabline#buffer_idx_mode = 1
            nmap <leader>1 <Plug>AirlineSelectTab1
            nmap <leader>2 <Plug>AirlineSelectTab2
            nmap <leader>3 <Plug>AirlineSelectTab3
            nmap <leader>4 <Plug>AirlineSelectTab4
            nmap <leader>5 <Plug>AirlineSelectTab5
            nmap <leader>6 <Plug>AirlineSelectTab6
            nmap <leader>7 <Plug>AirlineSelectTab7
            nmap <leader>8 <Plug>AirlineSelectTab8
            nmap <leader>9 <Plug>AirlineSelectTab9
            nmap <M-1> <Plug>AirlineSelectTab1
            nmap <M-2> <Plug>AirlineSelectTab2
            nmap <M-3> <Plug>AirlineSelectTab3
            nmap <M-4> <Plug>AirlineSelectTab4
            nmap <M-5> <Plug>AirlineSelectTab5
            nmap <M-6> <Plug>AirlineSelectTab6
            nmap <M-7> <Plug>AirlineSelectTab7
            nmap <M-8> <Plug>AirlineSelectTab8
            nmap <M-9> <Plug>AirlineSelectTab9
        endif
        if isdirectory(expand("~/.vim/bundle/vim-airline-themes/"))
            if !exists('g:airline_theme')
                let g:airline_theme = 'solarized'
            endif
            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
            endif
        endif
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            nnoremap <silent><F2> :NERDTreeToggle<CR>
            inoremap <silent><F2> <ESC>:NERDTreeToggle<CR>
            map <silent><leader>tnm :NERDTreeMirror<CR>
            map <silent><leader>tnt :NERDTreeToggle<CR>
            map <silent><leader>tnf :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=0
            let NERDTreeIgnore = ['\~$', '\obj$[[dir]]', '\.$[[dir]]', '\.py[cdo]$', '\.obj$', '\.o$', '\.so$', '\.swp$','\.db$', '^\.git$', '^\.svn$', '^\.hg$', '^\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
            let NERDChristmasTree=1
            "let NERDTreeMinimalUI=1
            let NERDTreeDirArrows=1
            let NERDTreeBookmarksFile=s:get_cache_dir('NERDTreeBookmarks')
            "close vim if the only window left open is a NERDTree
            autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end
        endif
    " }

    " CtrlP {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim"))
            let g:ctrlp_map = '<leader>p'
            let g:ctrlp_cmd = 'CtrlP'
            let g:ctrlp_by_filename = 1
            "let g:ctrlp_working_path_mode = 0
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_show_hidden = 1
            let g:ctrlp_use_caching = 1
            let g:ctrlp_clear_cache_on_exit = 0
            let g:ctrlp_cache_dir=s:get_cache_dir('ctrlp')
            " to be able to call CtrlP with default search text
            function! CtrlPWithSearchText(search_text, ctrlp_command_end)
                execute ':CtrlP' . a:ctrlp_command_end
                call feedkeys(a:search_text)
            endfunction
            " CtrlP with default text
            nmap <leader>cpt  :call CtrlPWithSearchText(expand('<cword>'), 'Tag')<CR>
            nmap <leader>cpl  :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
            nmap <leader>cpb  :call CtrlPWithSearchText(expand('<cword>'), 'Buffer')<CR>
            nmap <leader>cps  :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
            nmap <leader>cpa  :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
            nmap <leader>cpm  :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
            nmap <leader>cpw  :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
            nmap <leader>cpf  :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
            " Ignore files on fuzzy finder
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
                \ 'file': '\v\.(o|pyc|exe|so|dll|zip|rar|tar|tar.gz|DS_Store)$',
            \ }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s -l --nocolor --hidden -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            elseif WINDOWS()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }
            "\ 2: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        endif

        if isdirectory(expand("~/.vim/bundle/ctrlp-funky"))
            let g:ctrlp_extensions=['funky']
            let g:ctrlp_funky_syntax_highlight = 1
            let g:ctrlp_funky_multi_buffers = 1
            let g:ctrlp_funky_use_cache = 1
            let g:ctrlp_funky_cache_dir=s:get_cache_dir('ctrlp_funky')
            " narrow the list down with a word under cursor
            nnoremap <leader>pf :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
            nnoremap <leader>pF :CtrlPFunky<Cr>
        endif
    " }

    " vim-multiple-cursors {
        if isdirectory(expand("~/.vim/bundle/vim-multiple-cursors/"))

        endif
    " }

    " Rainbow {
        if isdirectory(expand("~/.vim/bundle/rainbow/"))
            let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
            let g:rainbow_conf = {
                        \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
                        \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
                        \   'operators': '_,_',
                        \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
                        \   'separately': {
                        \       '*': {},
                        \       'tex': {
                        \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
                        \       },
                        \       'lisp': {
                        \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
                        \       },
                        \       'vim': {
                        \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
                        \       },
                        \       'html': {
                        \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
                        \       },
                        \       'css': 0,
                        \   }
                        \}
        endif
    "}

    " clang_format {
        if isdirectory(expand("~/.vim/bundle/vim-clang-format"))
            noremap <silent><Leader>cf :ClangFormat<CR>
            let g:clang_format#style_options = {
                        \ "AccessModifierOffset" : -4,
                        \ "AllowShortIfStatementsOnASingleLine" : "true",
                        \ "AlwaysBreakTemplateDeclarations" : "true",
                        \ "Standard" : "C++11",
                        \ "BreakBeforeBraces" : "Allman"}
        endif
    "}

    " sessionman {
        if isdirectory(expand("~/.vim/bundle/sessionman.vim"))
            set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
            nmap <silent><leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
        endif
    " }

    " ListToggle {
        if isdirectory(expand("~/.vim/bundle/ListToggle"))
            let g:lt_location_list_toggle_map = '<leader>l'
            let g:lt_quickfix_list_toggle_map = '<leader>q'
        endif
    " }

    " Tagbar {
        if isdirectory(expand("~/.vim/bundle/tagbar"))
            nnoremap <silent><F4> :TagbarToggle<CR>
            nnoremap <silent><leader>ttb :TagbarToggle<CR>
            let g:tagbar_autofocus=1

            " If using go please install the gotags program using the following
            " go install github.com/jstemmer/gotags
            " And make sure gotags is in your path
            let g:tagbar_type_go = {
                    \ 'ctagstype' : 'go',
                    \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
                    \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
                    \ 'r:constructor', 'f:functions' ],
                    \ 'sro' : '.',
                    \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
                    \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
                    \ 'ctagsbin'  : 'gotags',
                    \ 'ctagsargs' : '-sort -silent'
                    \ }
        endif
    " }

    " Ack {
        if isdirectory(expand("~/.vim/bundle/ack.vim"))
            if executable('ag')
                let g:ackprg = 'ag --nogroup --nocolor --numbers --smart-case --silent'
            elseif executable('ack-grep')
                let g:ackprg="ack-grep -H --nogroup --nocolor --smart-case -s"
            endif
            "let g:ackhighlight = 1
            let g:ack_autoclose = 1
            "let g:ack_autofold_results = 1
            nnoremap <leader>a :Ack!<SPACE>
            nnoremap <silent><leader>kw :Ack! <cword><CR>
            nnoremap <silent><leader>kW :Ack! -w <cword><CR>
            nnoremap <silent><leader>kiw :Ack! -i <cword><CR>
            nnoremap <silent><leader>kiW :Ack! -i -w <cword><CR>
            nnoremap <silent><leader>ksw :Ack! -s <cword><CR>
            nnoremap <silent><leader>ksW :Ack! -s -w <cword><CR>
            nnoremap <silent><leader>kcw :Ack! <cword> %<CR>
            nnoremap <silent><leader>kcW :Ack! -w <cword> %<CR>
            vnoremap <silent><leader>kw y<Esc>:Ack! -w <c-r>0<CR>
        endif
    " }

    " CtrlSF {
        if isdirectory(expand("~/.vim/bundle/ctrlsf.vim"))
            let g:ctrlsf_auto_close = 1
            let g:ctrlsf_confirm_save=0
            let g:ctrlsf_position = 'bottom'
            let g:ctrlsf_default_root = 'project'
            nnoremap <silent><leader>tag :CtrlSFToggle<CR>
            inoremap <silent><leader>tag <ESC>:CtrlSFToggle<CR>
            nmap  <leader>ag <Plug>CtrlSFPrompt
            nmap <leader>gw <Plug>CtrlSFCwordExec
            vmap <leader>gw <Plug>CtrlSFVwordExec
        endif
    " }

    " vim-indent-guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides"))
            let g:indent_guides_start_level=2
            let g:indent_guides_guide_size=1
            let g:indent_guides_enable_on_vim_startup=0
            let g:indent_guides_color_change_percent=20
            let g:indent_guides_soft_pattern = ' '
            let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']
            nmap <silent><Leader>tig <Plug>IndentGuidesToggle
        endif
    " }

    " indentLine {
        if isdirectory(expand("~/.vim/bundle/indentLine"))
            let g:indentLine_enabled = 0
            let g:indentLine_char = '¦'
            "let g:indentLine_char = '┊'
            nnoremap <silent><leader>til :IndentLinesToggle<CR>
            nnoremap <silent><leader>tls :LeadingSpaceToggle<CR>
        endif
    " }

    " Undotree {
        if isdirectory(expand("~/.vim/bundle/undotree"))
            nnoremap <Leader>tut :UndotreeToggle<CR>
            let g:undotree_WindowLayout=2
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " Gundo {
        if isdirectory(expand("~/.vim/bundle/gundo.vim/"))
            nnoremap <Leader>tgu :GundoToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " YouCompleteMe {
        if count(g:m_vim_settings.plugin_groups, 'youcompleteme')
            let g:ycm_complete_in_comments_and_strings=1
            let g:ycm_collect_identifiers_from_comments_and_strings = 1
            let g:ycm_collect_identifiers_from_tags_files = 1
            let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
            let g:ycm_confirm_extra_conf = 0
            " remap Ultisnips for compatibility for YCM
            "let g:UltiSnipsExpandTrigger = '<C-j>'
            "let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            "let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

            " Haskell post write lint and check with ghcmod
            " $ `cabal install ghcmod` if missing and ensure
            " ~/.cabal/bin is in your $PATH.
            if !executable("ghcmod")
                autocmd BufWritePost *.hs GhcModCheckAndLintAsync
            endif

            " For snippet_complete marker.
            if has('conceal')
                set conceallevel=2 concealcursor=i
            endif

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
            "nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
            nnoremap <F12> :YcmCompleter GoToDefinition<CR>
            nnoremap <leader>jg :YcmCompleter GoTo<CR>
            nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
            nnoremap <leader>ji :YcmCompleter GoToInclude<CR>
            nnoremap <leader>jt :YcmCompleter GetType<CR>
            nnoremap <leader>jr :YcmCompleter GoToReferences<CR>
        endif
    " }

" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions+=b
        set guioptions-=m
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if LINUX() && has("gui_running")
            set guifont=Monaco\ for\ Powerline\ 14
            au GUIEnter * set lines=999 columns=999
        elseif OSX() && has("gui_running")
            set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        elseif WINDOWS() && has("gui_running")
            set guifont=Powerline_Consolas:h14:cANSI
            au GUIEnter * simalt ~x
        endif
        colorscheme solarized
    else
        if WINDOWS()
            let &t_Co = 256
            colorscheme desert
        else
            " use 256 colors when possible
            if &term[:4] == "linux" || &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
                set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
            endif
            if isdirectory(expand("~/.vim/bundle/molokai/"))
                colorscheme molokai
            endif
        endif
    endif

" }

" Functions {

    " Strip whitespace {
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
    " }

    " Highlight Class and Function names {
    function! s:HighlightFunctionsAndClasses()

        "syn match    cCustomParen    "(" contains=cParen,cCppParen
        "syn match    cCustomFunc     "\w\+\s*(" contains=cCustomParen
        "syn match    cCustomScope    "::"
        "syn match    cCustomClass    "\w\+\s*::" contains=cCustomScope
        syn match cCustomFunc "\w\+\s*\((\)\@="
        syn match cCustomClass "\w\+\s*\(::\)\@="

        hi def link cCustomFunc Function
        hi def link cCustomClass Function
    endfunction
    " }
" }

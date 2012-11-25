@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set BASE_DIR=%HOME%\.xieqi-vim

@if exist "%BASE_DIR%" (
	@set ORIGINAL_DIR=%CD%
	echo updating xieqi-vim
    chdir /d "%BASE_DIR%" && git pull
    chdir /d "%ORIGINAL_DIR%"
) else (
    echo cloning xieqi-vim
    call git clone https://github.com/xieqi/vimrc.git "%BASE_DIR%"
)

call copy "%BASE_DIR%\.vimrc" "%HOME%\.vimrc"
call copy "%BASE_DIR%\.vimrc" "%HOME%\_vimrc"
call copy "%BASE_DIR%\utils\ctags.exe" "%VIM%\ctags.exe"
call copy "%BASE_DIR%\utils\cscope.exe" "%VIM%\cscope.exe"

@if not exist "%HOME%/.vim/bundle/vundle" call git clone http://github.com/gmarik/vundle.git "%HOME%/.vim/bundle/vundle"
call vim -u "%BASE_DIR%/.vimrc" - +BundleInstall! +BundleClean +qall

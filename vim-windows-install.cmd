@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set APP_DIR=%HOME%\vimrc
IF NOT EXIST "%APP_DIR%" (
  call git clone --recursive https://github.com/xieqi/vimrc.git "%APP_DIR%"
) ELSE (
	@set ORIGINAL_DIR=%CD%
    echo updating xieqi-vim
    chdir /d "%APP_DIR%"
	call git pull
    chdir /d "%ORIGINAL_DIR%"
	call cd "%APP_DIR%"
)

call mklink "%HOME%\.vimrc" "%APP_DIR%\.vimrc"
call mklink "%HOME%\_vimrc" "%APP_DIR%\.vimrc"
call mklink "%HOME%\.vimrc.bundles" "%APP_DIR%\.vimrc.bundles"

IF NOT EXIST "%HOME%\.vim\bundle" (
	call mkdir "%HOME%\.vim\bundle"
)

IF NOT EXIST "%HOME%/.vim/bundle/Vundle.vim" (
	call git clone https://github.com/VundleVim/Vundle.vim.git "%HOME%/.vim/bundle/Vundle.vim"
) ELSE (
  call cd "%HOME%/.vim/bundle/Vundle.vim"
  call git pull
  call cd %HOME%
)

call vim -u "%HOME%/.vimrc" +PluginInstall! +PluginClean +qall

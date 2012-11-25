@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set BASE_DIR=%HOME%\.xieqi-vim

call git clone https://github.com/xieqi/vimrc.git "%BASE_DIR%"

call mklink %HOME%\.vimrc %BASE_DIR%\.vimrc
call mklink %HOME%\_vimrc %BASE_DIR%\.vimrc

call git clone http://github.com/gmarik/vundle.git "%HOME%/.vim/bundle/vundle"
call vim -u "%BASE_DIR%/.vimrc" +BundleInstall! +BundleClean +qall
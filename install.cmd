@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set BASE_DIR=%HOME%\.vim
call git clone --recursive https://github.com/XieQi/vimrc.git %BASE_DIR%
call mkdir %BASE_DIR%\bundle
call mklink %HOME%\_vimrc %BASE_DIR%\.vimrc

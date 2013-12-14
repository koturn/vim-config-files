" ====================================================
" Parameters of private information.
" ====================================================
" Proxy-setting (Rewrite for your environment)
" let $http_proxy  = 'http://username:password@xxx.xx.xx:8080'
" let $HTTPS_PROXY = 'http://username:password@xxx.xx.xx:8080'
" let $FTP_PROXY   = 'http://username:password@xxx.xx.xx:8080'
let g:gmail_address  = 'xxxx.yyyy.zzzz@gmail.com'
let g:browser_cmd    = 'chrome.exe'
let g:lingr_vim_user = 'username'
let g:lingr_vim_password = 'password'
let g:imagemagick_path   = ''
let g:win_git_path = ''
let g:cpp_include_files = ''
let g:clang_command = ''
let g:clang_lib = ''
if has('win16') || has('win32') || has('win64')
  let g:pronamachang_voice_path = ''
else
  let g:pronamachang_voice_path = ''
endif

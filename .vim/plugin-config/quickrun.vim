let g:quickrun_config = {
      \ '_' : {
      \   'outputter' : 'buffer',
      \   'outputter/buffer/split' : ':botright',
      \   'runner' : 'vimproc',
      \   'outputter/buffer/close_on_empty' : 1,
      \   'runner/vimproc/updatetime' : 60
      \ },
      \ 'c'      : {'type' : 'my_c'},
      \ 'cpp'    : {'type' : 'my_cpp'},
      \ 'cs'     : {'type' : 'my_cs'},
      \ 'java'   : {'type' : 'my_java'},
      \ 'lisp'   : {'type' : 'my_lisp'},
      \ 'scheme' : {'type' : 'my_scheme'},
      \ 'python' : {'type' : 'my_python'},
      \ 'ruby'   : {'type' : 'my_ruby'},
      \ 'r'      : {'type' : 'my_r'},
      \ 'tex'    : {'type' : 'my_tex'},
      \ 'kuin' : {
      \   'command' : 'Kuin.exe',
      \   'cmdopt'  : '-nw',
      \   'exec'    : '%C %S %o',
      \ }, 'html' : {
      \   'command'   : 'cat',
      \   'outputter' : 'browser',
      \ },
      \ 'my_c' : {
      \   'outputter' : 'quickfix',
      \   'command' : 'gcc',
      \   'cmdopt'  : '-Wall -Wextra -fsyntax-only',
      \   'exec'    : '%C %o %S',
      \ }, 'my_cpp' : {
      \   'outputter' : 'quickfix',
      \   'command' : 'g++',
      \   'cmdopt'  : '-Wall -Wextra -fsyntax-only',
      \   'exec'    : '%C %o %S',
      \ }, 'my_cs' : {
      \   'command' : 'csc',
      \   'cmdopt'  : '/out:csOut.exe',
      \   'exec'    : '%C %o %S',
      \ }, 'my_java' : {
      \   'command' : 'javac',
      \   'exec'    : '%C %S',
      \ }, 'my_lisp' : {
      \   'command' : 'clisp',
      \   'exec'    : '%C %S',
      \ }, 'my_scheme' : {
      \   'command' : 'gosh',
      \   'exec'    : '%C %S',
      \ }, 'my_python' : {
      \   'command' : 'python',
      \   'exec'    : '%C %S',
      \ }, 'my_ruby' : {
      \   'command' : 'ruby',
      \   'exec'    : '%C %S',
      \ }, 'my_r' : {
      \   'command' : 'Rscript',
      \   'exec'    : '%C %S',
      \ }, 'my_tex' : {
      \   'command' : 'pdflatex',
      \   'exec'    : '%C %S',
      \}}
nnoremap <expr><silent><C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
nnoremap <Leader>r  :<C-u>QuickRun -exec '%C %S'<CR>

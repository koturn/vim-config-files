" ============================================================
"     __         __                      ____
"    / /______  / /___  ___________     / __ \ _
"   / //_/ __ \/ __/ / / / ___/ __ \   / / / /(_)
"  / ,< / /_/ / /_/ /_/ / /  / / / /  / /_/ / _
" /_/|_|\____/\__/\__,_/_/  /_/ /_/   \____/ ( )
"                                            |/
"
" This .vimrc was mainly written for Windows.
" But you can also use in Cygwin or UNIX/Linux.
" In Windows, you have to put this in HOME-directory.
" ============================================================
" ------------------------------------------------------------
" Initialize and Variables {{{
" ------------------------------------------------------------
" Variables for various environment.
let g:is_windows =  has('win16') || has('win32') || has('win64')
let g:is_cygwin  =  has('win32unix')
let g:is_mac     = !g:is_windows && (has('mac') || has('macunix') || has('gui_macvim')
      \ || (!isdirectory('/proc') && executable('sw_vers')))
let g:is_unix    =  has('unix')
let s:is_cui     = !has('gui_running')
let g:at_startup =  has('vim_starting')
if !exists($MYGVIMRC)
  let $MYGVIMRC = expand('~/.gvimrc')
endif
let $DOTVIM = $HOME . '/.vim'
let $NEOBUNDLE_DIR = expand('$DOTVIM/bundle/')
" If $DOTVIM/.private.vim is exists, ignore error.
silent! source $DOTVIM/.private.vim

augroup MyAutoCmd
  autocmd!
augroup END
" Measure startup time.
if g:at_startup && has('reltime')
  let s:startuptime = reltime()
  autocmd MyAutoCmd VimEnter *
        \   let s:startuptime = reltime(s:startuptime)
        \ | redraw
        \ | echomsg 'startuptime: ' . reltimestr(s:startuptime)
        \ | unlet s:startuptime
endif

" Singleton (if !s:is_cui)
if has('clientserver')
  let s:running_vim_list = filter(
        \ split(serverlist(), '\n'),
        \ 'v:val !=? v:servername')
  if !empty(s:running_vim_list)
    if !argc()
      quitall!
    endif
    if g:is_windows
      if s:is_cui
        silent !cls
      endif
      let s:vim_cmd = '!start gvim'
    else
      let s:vim_cmd = '!gvim'
    endif
    " Send arguments to running vim.
    silent exec s:vim_cmd
          \ '--servername' s:running_vim_list[0]
          \ '--remote-tab-silent' join(argv(), ' ')
    quitall!
  endif
  unlet s:running_vim_list
endif

" Add directory under plugins directory to runtimepath
if g:at_startup && has('kaoriya')
  function! s:full_plugin()
    for l:path in split(glob($VIM . '/plugins/*'), '\n')
      if l:path !~# '\~$' && isdirectory(l:path)
        let &rtp .= ',' . l:path
      endif
    endfor
    delcommand FullInstall
  endfunction
  command! FullInstall  call s:full_plugin()
endif
" }}}


" ------------------------------------------------------------
" NeoBundle {{{
" ------------------------------------------------------------
" If neobundle is not exist, finish setting.
if !isdirectory($NEOBUNDLE_DIR . '/neobundle.vim')
  if v:version < 702
    echoerr 'Please use vim7.3!!!!'
    finish
  elseif !executable('git')
    echoerr 'Please install git!!!!'
    finish
  endif

  function! s:neobundle_init()
    call mkdir($NEOBUNDLE_DIR, 'p')
    call system('git clone git://github.com/Shougo/neobundle.vim ' . $NEOBUNDLE_DIR . '/neobundle.vim')
    set rtp+=$NEOBUNDLE_DIR/neobundle.vim
    call neobundle#rc()
    NeoBundleInstall
  endfunction
  command! NeoBundleInit  call s:neobundle_init()
  echomsg 'Please Install NeoBundle!'
  echomsg 'Do command :NeoBundleInit'
  finish
endif

if g:at_startup
  set rtp+=$NEOBUNDLE_DIR/neobundle.vim
endif
call neobundle#rc()
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \   'windows' : 'make -f make_mingw32.mak',
      \   'cygwin'  : 'make -f make_cygwin.mak',
      \   'mac'     : 'make -f make_mac.mak',
      \   'unix'    : 'make -f make_unix.mak'
      \}}

NeoBundleLazy 'Shougo/unite.vim', {
      \ 'autoload' : {
      \   'commands' : [{
      \     'name' : 'Unite',
      \     'complete' : 'customlist,unite#complete_source'
      \},]}}
NeoBundleLazy 'ujihisa/unite-colorscheme', {
      \ 'autoload' : {'unite_sources' : 'colorscheme'}
      \}
NeoBundleLazy 'ujihisa/unite-font', {
      \ 'autoload' : {'unite_sources' : 'font'}
      \}
nnoremap [unite] <Nop>
nmap ,u  [unite]
noremap <silent> [unite]b  :<C-u>UniteWithBufferDir -buffer-name=files -start-insert file file/new<CR>
noremap <silent> [unite]c  :<C-u>Unite -auto-preview colorscheme<CR>
noremap <silent> [unite]f  :<C-u>Unite -auto-preview font<CR>
noremap <silent> [unite]m  :<C-u>Unite -buffer-name=files -start-insert buffer file_rec/async:! file file_mru<CR>

if has('lua') && v:version >= 703 && has('patch825')
  NeoBundleLazy 'Shougo/neocomplete.vim', {
        \ 'autoload' : {'insert' : 1}
        \}
  inoremap <expr><CR>  neocomplete#smart_close_popup() . '<CR>'
  let g:neocomplete#enable_at_startup = 1
else
  NeoBundleLazy 'Shougo/neocomplcache', {
        \ 'autoload' : {'insert' : 1}
        \}
  inoremap <expr><CR>  neocomplcache#smart_close_popup() . '<CR>'
  let g:neocomplcache_enable_at_startup = 1
endif

NeoBundleLazy 'Shougo/neosnippet', {
      \ 'autoload' : {'insert' : 1}
      \}
imap <C-k>  <Plug>(neosnippet_expand_or_jump)
smap <C-k>  <Plug>(neosnippet_expand_or_jump)
imap <expr><TAB>  neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ?
      \ '<Plug>(neosnippet_expand_or_jump)' : pumvisible() ? '<C-n>' : '<TAB>'
smap <expr><TAB>  neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ?
      \ '<Plug>(neosnippet_expand_or_jump)' : '<TAB>'
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" I want to show startup time when vim is started, so lazy-load this plug-in.
NeoBundleLazy 'bling/vim-bufferline', {
      \ 'autoload' : {'insert' : 1}
      \}
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size  = 1
let g:indent_guides_auto_colors = 0
augroup MyAutoCmd
  au ColorScheme * hi IndentGuidesOdd  ctermbg=darkgreen guibg=#663366
  au ColorScheme * hi IndentGuidesEven ctermbg=darkblue  guibg=#6666ff
augroup END

NeoBundleLazy 'osyo-manga/vim-reanimate', {
      \ 'autoload' : {'commands' : ['ReanimateSave', 'ReanimateLoad']}
      \}
let g:reanimate_save_dir = $DOTVIM . '/save'
let g:reanimate_default_save_name = 'reanimate'
let g:reanimate_sessionoptions = 'curdir,folds,help,localoptions,slash,tabpages,winsize'
NeoBundle 'hrp/EnhancedCommentify'

" NeoBundle 'kana/vim-smartinput'

"""""" if executable('w3m')
NeoBundleLazy 'yuratomo/w3m.vim', {
      \ 'autoload' : {'commands' : 'W3m'}
      \}
"""""" endif


" A Plugin which accelerate jk-move
NeoBundleLazy 'rhysd/accelerated-jk', {
      \ 'autoload' : {'mappings' : [
      \   ['n', '<Plug>(accelerated_jk_gj)'],
      \   ['n', '<Plug>(accelerated_jk_gk)']
      \]}}
nmap <C-j> <Plug>(accelerated_jk_gj)
nmap <C-k> <Plug>(accelerated_jk_gk)

NeoBundleLazy 'osyo-manga/vim-anzu', {
      \ 'autoload' : {'mappings' : [
      \   ['n', '<Plug>(anzu-n-with-echo)'],
      \   ['n', '<Plug>(anzu-N-with-echo)'],
      \   ['n', '<Plug>(anzu-star-with-echo)'],
      \   ['n', '<Plug>(anzu-sharp-with-echo)']
      \]}}
nmap n  <Plug>(anzu-n-with-echo)zz
nmap N  <Plug>(anzu-N-with-echo)zz
nmap *  <Plug>(anzu-star-with-echo)zz
nmap #  <Plug>(anzu-sharp-with-echo)zz
nnoremap g*  g*zz
nnoremap g#  g#zz

NeoBundleLazy 'daisuzu/rainbowcyclone.vim', {
      \ 'autoload' : {
      \   'commands' : 'RC',
      \   'mappings' : [
      \     ['n', '<Plug>(rc_search_forward)'],
      \     ['n', '<Plug>(rc_search_backward)'],
      \     ['n', '<Plug>(rc_search_forward_with_cursor)'],
      \     ['n', '<Plug>(rc_search_backward_with_cursor)'],
      \     ['n', '<Plug>(rc_search_forward_with_last_pattern)'],
      \     ['n', '<Plug>(rc_search_backward_with_last_pattern)']
      \]}}
nmap c/  <Plug>(rc_search_forward)
nmap c?  <Plug>(rc_search_backward)
nmap <silent> c*  <Plug>(rc_search_forward_with_cursor)
nmap <silent> c#  <Plug>(rc_search_backward_with_cursor)
nmap <silent> cn  <Plug>(rc_search_forward_with_last_pattern)
nmap <silent> cN  <Plug>(rc_search_backward_with_last_pattern)

NeoBundleLazy 'thinca/vim-visualstar', {
      \ 'autoload' : {'mappings' : [
      \   '<Plug>(visualstar-*)',
      \   '<Plug>(visualstar-#)',
      \   '<Plug>(visualstar-g*)',
      \   '<Plug>(visualstar-g#)',
      \]}}
let g:visualstar_no_default_key_mappings = 1
xmap *   <Plug>(visualstar-*)
xmap #   <Plug>(visualstar-#)
xmap g*  <Plug>(visualstar-g*)
xmap g#  <Plug>(visualstar-g#)
xmap <kMultiply>     <Plug>(visualstar-*)
xmap g<kMultiply>    <Plug>(visualstar-g*)
vmap <S-LeftMouse>   <Plug>(visualstar-*)
vmap g<S-LeftMouse>  <Plug>(visualstar-g*)


"""""" if executable('lynx')
NeoBundleLazy 'thinca/vim-ref', {
      \ 'autoload' : {'commands' : 'Ref'}
      \}
" A Setting for the site of webdict.
let g:ref_source_webdict_sites = {
      \ 'je' : {'url' : 'http://dictionary.infoseek.ne.jp/jeword/%s'},
      \ 'ej' : {'url' : 'http://dictionary.infoseek.ne.jp/ejword/%s'},
      \ 'dn' : {'url' : 'http://dic.nicovideo.jp/a/%s'},
      \ 'wiki_en' : {'url' : 'http://en.wikipedia.org/wiki/%s'},
      \ 'wiki' : {'url' : 'http://ja.wikipedia.org/wiki/%s'},}
nnoremap <Leader>e   :<C-u>Ref webdict ej<Space>
nnoremap <Leader>j   :<C-u>Ref webdict je<Space>
nnoremap <Leader>dn  :<C-u>Ref webdict dn<Space>
nnoremap <Leader>we  :<C-u>Ref webdict wiki_en<Space>
nnoremap <Leader>wj  :<C-u>Ref webdict wiki<Space>

autocmd MyAutoCmd Filetype ref-webdict setl number
if g:is_cygwin
  autocmd MyAutoCmd Filetype ref-webdict setl enc=cp932
endif
let g:ref_open = 'split'
" If you don't specify a following setting, webdict-results are garbled.
let s:pauth = get(g:, 'pauth', '')
if s:pauth ==# ''
  let g:ref_source_webdict_cmd = 'lynx -dump -nonumbers %s'
else
  let g:ref_source_webdict_cmd = 'lynx -dump -nonumbers -pauth=' . s:pauth . ' %s'
endif
unlet s:pauth
" Default webdict site
let g:ref_source_webdict_sites.default = 'ej'
" Filters for output. Remove the first few lines.
function! g:ref_source_webdict_sites.je.filter(output)
  let l:idx = strridx(a:output, '   (C) SHOGAKUKAN')
  return join(split(a:output[: l:idx - 1], "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.ej.filter(output)
  let l:idx = strridx(a:output, '   (C) SHOGAKUKAN')
  return join(split(a:output[: l:idx - 1], "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.dn.filter(output)
  let l:idx = strridx(a:output, "\n   [l_box_b]\n")
  return join(split(a:output[: l:idx], "\n")[16 :], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki.filter(output)
  let l:idx = strridx(a:output, "\n案内メニュー\n")
  return join(split(a:output[: l:idx], "\n")[17 :], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki_en.filter(output)
  let l:idx = strridx(a:output, "\nNavigation menu\n")
  return join(split(a:output[: l:idx], "\n")[17 :], "\n")
endfunction
"""""" endif

NeoBundleLazy 'rhysd/tmpwin.vim', {
      \ 'autoload' : {'commands' : 'tmpwin#toggle'}
      \}

NeoBundleLazy 'BufOnly.vim', {
      \ 'autoload' : {'commands' : ['BufOnly', 'Bonly', 'BOnly', 'Bufonly']}
      \}

NeoBundleLazy 'renamer.vim', {
      \ 'autoload' : {'commands' : ['Renamer', 'Ren']}
      \}

NeoBundleLazy 'koturn/movewin.vim', {
      \ 'autoload' : {
      \   'commands' : 'MoveWin',
      \   'mappings' : [
      \     '<Plug>(movewin-left)',
      \     '<Plug>(movewin-down)',
      \     '<Plug>(movewin-up)',
      \     '<Plug>(movewin-right)'
      \]}}

NeoBundleLazy 'koturn/resizewin.vim', {
      \ 'autoload' : {
      \   'commands' : ['ResizeWin', 'FullSize'],
      \   'mappings' : [
      \     '<Plug>(resizewin-contract-x)',
      \     '<Plug>(resizewin-expand-y)',
      \     '<Plug>(resizewin-contract-y)',
      \     '<Plug>(resizewin-expand-x)',
      \     '<Plug>(resizewin-full)',
      \]}}
map  <F11>      <Plug>(resizewin-full)
map! <F11>      <Plug>(resizewin-full)
map  <M-F11>    <Plug>(resizewin-full)
map! <M-F11>    <Plug>(resizewin-full)
map  <S-Left>   <Plug>(resizewin-contract-x)
map! <S-Left>   <Plug>(resizewin-contract-x)
map  <S-Down>   <Plug>(resizewin-expand-y)
map! <S-Down>   <Plug>(resizewin-expand-y)
map  <S-Up>     <Plug>(resizewin-contract-y)
map! <S-Up>     <Plug>(resizewin-contract-y)
map  <S-Right>  <Plug>(resizewin-expand-x)
map! <S-Right>  <Plug>(resizewin-expand-x)

NeoBundleLazy 'scrooloose/nerdtree', {
      \ 'autoload' : {'commands' : 'NERDTree'}
      \}

NeoBundleLazy 'Shougo/vimshell', {
      \ 'autoload' : {'commands' : ['VimShell', 'VimShellPop', 'VimShellInteractive']}
      \}
let g:my_vimshell_prompt_counter = -1
function! g:my_vimshell_dynamic_prompt()
  let g:my_vimshell_prompt_counter += 1
  let anim = [
        \ "(´:_:`)",
        \ "( ´:_:)",
        \ "(  ´:_)",
        \ "(   ´:)",
        \ "(    ´)",
        \ "(     )",
        \ "(     )",
        \ "(`    )",
        \ "(:`   )",
        \ "(_:`  )",
        \ "(:_:` )",
        \]
  return anim[g:my_vimshell_prompt_counter % len(anim)]
endfunction
" let g:vimshell_prompt = "('v ')$ "
let g:vimshell_prompt_expr = 'g:my_vimshell_dynamic_prompt() . " $ "'
let g:vimshell_prompt_pattern = '^([ ´:_:`]\{5}) \$ '
let g:vimshell_secondary_prompt = '> '
let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_right_prompt = '"[" . strftime("%Y/%m/%d %H:%M:%S", localtime()) . "]"'

" When you start-up vim with no command-line argument,
" execute VimShell.
" if g:at_startup && !argc()
"   autocmd MyAutoCmd VimEnter * VimShell
" endif

"""""" if executable('MSBuild.exe') || executable('xbuild')
NeoBundleLazy 'nosami/Omnisharp', {
      \ 'autoload' : {'filetypes' : ['cs']},
      \ 'build' : {
      \   'windows' : 'MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
      \   'mac'     : 'xbuild server/OmniSharp.sln',
      \   'unix'    : 'xbuild server/OmniSharp.sln'
      \}}
""""""

NeoBundleLazy 'tatt61880/kuin_vim', {
      \ 'autoload' : {'filetypes' : 'kuin'}
      \}
autocmd MyAutoCmd BufReadPre *.kn setfiletype kuin

NeoBundleLazy 'java_getset.vim', {
      \ 'autoload' : {'filetypes' : 'java'}
      \}

NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
      \ 'autoload' : {'filetypes' : 'javascript'}
      \}

NeoBundleLazy 'jcommenter.vim', {
      \ 'autoload' : {'filetypes' : 'java'}
      \}

NeoBundleLazy 'mitechie/pyflakes-pathogen', {
      \ 'autoload' : {'filetypes' : 'python'}
      \}

" Clone of 'tpope/vim-endwise'.
NeoBundleLazy 'rhysd/endwize.vim', {
      \ 'autoload' : {
      \   'filetypes' : ['lua', 'ruby', 'sh', 'zsh', 'vb', 'vbnet', 'aspvbs', 'vim'],
      \}}
let g:endwize_add_info_filetypes = ['ruby', 'c', 'cpp']
" imap <silent><CR> <CR><Plug>DiscretionaryEnd

NeoBundleLazy 'ruby-matchit', {
      \ 'autoload' : {'filetypes' : 'ruby'}
      \}

"""""" if executable('ctags')
NeoBundleLazy 'tagexplorer.vim', {
      \ 'autoload' : {
      \   'filetypes' : ['cpp', 'java', 'perl', 'python', 'ruby']
      \}}
"""""" endif

NeoBundleLazy 'rbtnn/vimconsole.vim', {
      \ 'autoload' : { 'commands'  : ['VimConsole', 'VimConsoleOpen']}
      \}

NeoBundleLazy 'thinca/vim-quickrun', {
      \ 'autoload' : {
      \   'filetypes' : ['c', 'cpp', 'cs', 'java', 'python', 'perl', 'ruby', 'r'],
      \   'commands'  : 'QuickRun'
      \}}
let g:quickrun_config = {
      \ '_' : {
      \   'outputter/buffer/split' : ':botright',
      \   'outputter/buffer/close_on_empty' : 1,
      \   'runner' : 'vimproc',
      \   'runner/vimproc/updatetime' : 60
      \ },
      \ 'c'      : {'type' : 'my_c'},
      \ 'cpp'    : {'type' : 'my_cpp'},
      \ 'cs'     : {'type' : 'my_cs'},
      \ 'java'   : {'type' : 'my_java'},
      \ 'lisp'   : {'type' : 'my_lisp'},
      \ 'python' : {'type' : 'my_python'},
      \ 'ruby'   : {'type' : 'my_ruby'},
      \ 'r'      : {'type' : 'my_r'},
      \ 'tex'    : {'type' : 'my_tex'},
      \ 'kuin' : {
      \   'command' : 'Kuin.exe',
      \   'cmdopt'  : '-nw',
      \   'exec'    : '%C %S %o',
      \ },
      \ 'my_c' : {
      \   'command' : 'gcc',
      \   'cmdopt'  : '-Wall -Wextra -fsyntax-only',
      \   'exec'    : '%C %o %S',
      \ }, 'my_cpp' : {
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
nnoremap <Leader>r  :<C-u>QuickRun -exec '%C %S'<CR>

NeoBundleLazy 'lambdalisue/platex.vim', {
      \ 'autoload' : {'filetypes' : 'tex'}
      \}

NeoBundleLazy 'davidhalter/jedi-vim', {
      \ 'autoload' : {
      \   'filetypes' : ['python']
      \}}

NeoBundleLazy 'klen/python-mode', {
      \ 'autoload' : {'filetypes' : 'python'}
      \}
" Do not use the folding of python-mode.
let g:pymode_folding = 0

NeoBundleLazy 'kannokanno/previm', {
      \ 'autoload' : {'filetypes' : 'markdown'}
      \}
" g:chrome_cmd is defined in ~/.vim/private.vim
let g:previm_open_cmd = get(g:, 'browser_cmd', '')

" When oppening a file, if the file has a particular extension,
" open the file in binary-mode.
augroup MyAutoCmd
  au BufRead *.7z,*.a,*.bin,*.bz,*.bz2,*.class,*.dll,*.exe,
        \*.flv,*.gif,*.gz,*.jpg,*.jpeg,*.lib,*.mid,*.mp3,*.mp4,*.o,*.obj,
        \*.out,*.pdf,*.png,*.pyc,*.so,*.tar,*.tgz,*.wav,*.wmv,*.zip
        \ setfiletype binary
  if has('python')
    NeoBundleLazy 'Shougo/vinarise', {
          \ 'autoload' : {
          \   'filetypes' : 'vinarise',
          \   'commands'  : 'Vinarise'
          \}}
    au Filetype binary Vinarise
  else  """""" elseif executable('xxd')
    command! Binarise  setfiletype binary | edit
    au Filetype binary let &bin = 1
    au BufReadPost * if &bin | %!xxd -g 1
    au BufReadPost * setfiletype xxd | endif
    au BufWritePre * if &bin | %!xxd -r
    au BufWritePre * endif
    au BufWritePost * if &bin | %!xxd -g 1
    au BufWritePost * set nomod | endif
  endif
augroup END


NeoBundleLazy 'itchyny/thumbnail.vim', {
      \ 'autoload' : {'commands' : 'Thumbnail'}
      \}

NeoBundleLazy 'thinca/vim-painter', {
      \ 'autoload' : {'commands' : 'PainterStart'}
      \}

NeoBundle 'mattn/libcallex-vim'
NeoBundleLazy 'mattn/eject-vim', {
      \ 'autoload' : {'commands' : 'Eject'}
      \}

NeoBundleLazy 'mattn/benchvimrc-vim', {
      \ 'autoload' : {'commands' : 'BenchVimrc'}
      \}

NeoBundleLazy 'matrix.vim', {
      \ 'type' : 'nosync',
      \ 'base' : $DOTVIM . '/norepository-plugins',
      \ 'autoload' : {'commands' : 'Matrix'}
      \}

NeoBundleLazy 'ScreenShot.vim', {
      \ 'type' : 'nosync',
      \ 'base' : $DOTVIM . '/norepository-plugins',
      \ 'autoload' : {'commands' : ['ScreenShot', 'Text2Html', 'Diff2Html']}
      \}

NeoBundleLazy 'thinca/vim-scouter', {
      \ 'autoload' : {'commands' : 'Scouter'}
      \}

NeoBundleLazy 'sudoku_game.vim', {
      \ 'type' : 'nosync',
      \ 'base' : $DOTVIM . '/norepository-plugins',
      \ 'autoload' : {'commands' : ['SudokuEasy', 'SudokuMedium', 'SudokuHard', 'SudokuVeryHard']}
      \}

NeoBundleLazy 'mfumi/viminesweeper', {
      \ 'autoload' : {'commands' : 'MineSweeper'}
      \}

" gmail.vim:
NeoBundleLazy 'yuratomo/gmail.vim', {
      \ 'autoload' : {'commands' : 'Gmail'}
      \}
" g:gmail_address is defined in ~/.vim/private.vim
let g:gmail_user_name = get(g:, 'gmail_address', '')

NeoBundleLazy 'basyura/TweetVim', {
      \ 'depends' : ['tyru/open-browser.vim', 'basyura/twibill.vim'],
      \ 'autoload' : {'commands' : ['TweetVimHomeTimeline', 'TweetVimUserTimeline', 'TweetVimCommandSay', 'TweetVimUserStream']}
      \}
noremap <Leader>t  :<C-u>TweetVimCommandSay<Space>
" Number of tweet to show on editor.
let g:tweetvim_tweet_per_page = 50
" Show twitter client.
let g:tweetvim_display_source = 1
" Display tweet time.
let g:tweetvim_display_time   = 1
" Show icon.(require ImageMagick)
" let g:tweetvim_display_icon = 1

" require fbconsole.py
"   $ pip install fbconsole
NeoBundleLazy 'daisuzu/facebook.vim', {
      \ 'depends' : ['tyru/open-browser.vim', 'mattn/webapi-vim'],
      \ 'autoload' : {'commands' : ['FacebookHome', 'FacebookAuthenticate']}
      \}
" }}}
" ************** The end of etting of NeoBundle **************

" ------------------------------------------------------------
" Basic settings {{{
" ------------------------------------------------------------
" Hide splash screen.
set shortmess+=I
" Enable to use '/' for direstory path separator on Windows.
set shellslash
" Work with clipboard.
set clipboard=unnamed,autoselect
" Enable square-selecting if charactors don't exist.
set virtualedit=block
" Turn off word wrap.
set nowrap
" Turn off start a new line sutomatically.
set textwidth=0
" Markers are three '{' and three '}'.
set foldmethod=marker
" Set browsedir at directory which is edit on buffer.
set browsedir=buffer
" Enable show other file when you change a file.
set hidden
" When the closed brackets is inputted, show the matching open brackets.
set showmatch
" Identify upper case characters and lower case characters
" if a word for searching includes upper case cahracters.
set smartcase
" Don't stop cursor at start of line and end of line.
set whichwrap=b,s,h,l,<,>,[,]
" Setting for split windows.
" set splitbelow splitright
" Mute beep.
set vb t_vb=
" Don't redraw while execute scripts
set lazyredraw
" Use vim in secure.
set secure
" Swap file.
set noswapfile
" Backup file.
set nobackup nowritebackup
" file of '_viminfo'.
set viminfo=
" Show vertical line at column-80
set colorcolumn=80
" Open buffer which already exists instead of opening new.
set switchbuf=useopen
" Indent settings
set autoindent   smartindent
set expandtab    smarttab
set shiftwidth=2 tabstop=2 softtabstop=2
" Show line number.
set number
" Setting for printing.
if has('printer') && g:is_windows
  set printoptions=number:y,header:0,syntax:y,left:5pt,right:5pt,top:10pt,bottom:10pt
  set printfont=Consolas:h9 printmbfont=r:MS_Gothic:h10,a:yes
endif


" ------------------------------------------------------------
" Setting written in vimrc of KaoriYa-vim {{{
" ------------------------------------------------------------
" Don't ignore cases when searching.
set ignorecase
" Delete indent and EOL with backspace.
set backspace=indent,eol,start
" Searches wrap around the end of the file.
set wrapscan
" Display the brackets corresponding to the input brackets.
set showmatch
" Use enhanced command-line completion.
set wildmenu
" Show commands on command-line.
set showcmd
" Set two lines the height of command-line.
set cmdheight=2

set history=50  " keep 50 lines of command-line history
set incsearch   " do incremental searching
if has('mouse')
  set mouse=a
endif
if &t_Co > 2 || !s:is_cui
  syntax enable
  set hlsearch
endif

" Setting for the system that not identify upper cases and lower cases.
"   (example: DOS / Windows / MacOS)
if filereadable($HOME . '/.vimrc') && filereadable($HOME . '/.ViMrC')
  set tags=./tags,tags  " Prevent duplication of tags file
else
  set tags=./tags
endif

" In Windows, if $VIM is not include in $PATH, .exe cannot be found.
if g:is_windows && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

" In Mac, default 'iskeyword' is incomplete for cp932.
if g:is_mac
  set iskeyword=@,48-57,_,128-167,224-235
endif
" }}}
" }}}


" ------------------------------------------------------------
" Character-code and EOL-code {{{
" ------------------------------------------------------------
if g:is_windows
  set fenc=utf-8
  set tenc=cp932
  if s:is_cui
    set enc=cp932
  else
    set enc=utf-8
  endif
endif

if g:is_cygwin
  set enc =utf-8
  set fenc=utf-8
  set tenc=utf-8
  if &term ==# 'xterm'  " In mintty
    " Change cursor shape depending on mode.
    let &t_ti .= "\e[1 q"
    let &t_SI .= "\e[5 q"
    let &t_EI .= "\e[1 q"
    let &t_te .= "\e[0 q"
    set tenc=utf-8
  """""" elseif &term ==# 'cygwin'  " In command-prompt
  endif
endif

set fileformats=dos,unix,mac
if has('kaoriya')
  set fileencodings=guess
else
  set fileencodings=iso-2022-jp,ucs-bom,utf-8,utf-16,euc-jp,cp932
endif
scriptencoding utf-8  " required to visualize double-byte spaces.(after set enc)

autocmd MyAutoCmd BufWritePre *
      \   if &ff != 'unix' && input(printf('Convert fileformat:%s to unix? [y/N]', &ff)) =~? '^y\%[es]$'
      \ |   setl ff=unix
      \ | endif

" Fix 'fileencoding' to use 'encoding'
" if the buffer only contains 7-bit characters.
" Note that if the buffer is not 'modifiable',
" its 'fileencoding' cannot be changed, so that such buffers are skipped.
autocmd MyAutoCmd BufReadPost *
      \   if &modifiable && !search('[^\x00-\x7F]', 'cnw')
      \ |   set fenc=ascii
      \ | endif
" }}}


" ------------------------------------------------------------
" Commands and autocmds {{{
" ------------------------------------------------------------
function! s:try_repeat(cmd)
  try
    while 1
      silent exec a:cmd
    endwhile
  catch
  endtry
endfunction

function! s:toggle_tab_space(width)
  let l:i = 0
  let l:spaces = ''
  while l:i < a:width
    let l:spaces .= ' '
    let l:i += 1
  endwhile

  let &sw = a:width
  let &ts = a:width
  let l:cursor = getpos('.')
  if &expandtab
    set noexpandtab
    let l:cmd = '%s/\(^\(' . l:spaces . '\)*\)' . l:spaces . '/\1\t/g'
    call s:try_repeat(l:cmd)
  else
    set expandtab
    let l:cmd = '%s/\(^\t*\)\t/\1' . l:spaces . '/g'
    call s:try_repeat(l:cmd)
  endif
  call setpos('.', l:cursor)
endfunction
nnoremap <silent> <Leader><Tab>  :<C-u>call <SID>toggle_tab_space(&ts)<CR>
command! -nargs=1 Indent
      \   let &sw  = <q-args>
      \ | let &ts  = <q-args>
      \ | let &sts = <q-args>

" Make directory automatically.
function! s:auto_mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &enc, &tenc), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)


" Command of 'which' for vim command.
function! s:cmd_which(cmd)
  if stridx(a:cmd, '/') != -1 || stridx(a:cmd, '\\') != -1
    echoerr a:cmd 'is not a command-name.'
    return
  endif
  let l:path = substitute(substitute($PATH, '\\', '/', 'g'), ';', ',', 'g')
  let l:sfx  = &suffixesadd
  if g:is_windows
    setl suffixesadd=.exe,.cmd,.bat
  endif
  let l:file_list = findfile(a:cmd, l:path, -1)
  if !empty(l:file_list)
    echo fnamemodify(l:file_list[0], ':p')
  else
    echo a:cmd 'was not found.'
  endif

  let &suffixesadd = l:sfx
endfunction
command! -nargs=1 Which  call s:cmd_which(<q-args>)


" lcd to buffer-directory.
function! s:cmd_lcd(count)
  let l:dir = expand('%:p' . repeat(':h', a:count + 1))
  if isdirectory(l:dir)
    exec 'lcd' fnameescape(l:dir)
  endif
endfunction
command! -nargs=0 -count=0 Lcd  call s:cmd_lcd(<count>)


" Close buffer not closing window
command! Ebd  call EBufdelete()
function! EBufdelete()
  let l:current_bufnr   = bufnr("%")
  let l:alternate_bufnr = bufnr("#")
  if buflisted(l:alternate_bufnr)
    buffer #
  else
    bnext
  endif
  if buflisted(l:current_bufnr)
    exec 'silent bwipeout' . l:current_bufnr
    " If bwipeout is failed, restore buffer of upper windows.
    if bufloaded(l:current_bufnr) != 0
      exec 'buffer ' . l:current_bufnr
    endif
  endif
endfunction


" Preview fold area.
function! s:preview_fold(previewheight)
  let l:lnum = line('.')
  if foldclosed(l:lnum) <= -1
    pclose
  else
    let l:lines = getline(l:lnum, foldclosedend(l:lnum))
    if len(l:lines) > a:previewheight
      let l:lines = l:lines[: a:previewheight - 1]
    endif

    let l:filetype = &ft
    let l:winnr = bufwinnr('__fold__')
    if l:winnr == -1
      silent exec 'botright' a:previewheight . 'split' '__fold__'
    else
      silent wincmd P
    endif

    exec '%d _'
    exec 'setl syntax=' . l:filetype
    setl buftype=nofile noswapfile bufhidden=wipe previewwindow foldlevel=99 nowrap
    call append(0, l:lines)
    wincmd p
  endif
endfunction
nnoremap <silent> zp  :<C-u>call <SID>preview_fold(&previewheight)<CR>


" If text-file has shebang, add permision of executable.
if executable('chmod')
  function! s:add_permission_x()
    let l:file = expand('%:p')
    if getline(1) =~# '^#!' && !executable(l:file)
      silent! call vimproc#system('chmod a+x ' . shellescape(l:file))
    endif
  endfunction
  autocmd MyAutoCmd BufWritePost * call s:add_permission_x()
endif


" Execute selected text as a vimscript
function! s:exec_selected_text()
  let l:tmp = @@
  silent normal gvy
  let l:selected = @@
  let @@ = l:tmp
  for l:elm in split(l:selected, "\n")
    exec l:elm
  endfor
endfunction
xnoremap <silent> <Leader>e  :<C-u>call <SID>exec_selected_text()<CR>


function! s:delte_trailing_whitespace()
  let l:cursor = getpos('.')
  silent! %s/\s\+$//g
  call setpos('.', l:cursor)
endfunction
command! DeleteTrailingWhitespace  call s:delte_trailing_whitespace()
command! DeleteBlankLines  :g /^$/d
command! -nargs=1 -complete=file Rename  file <args> | call delete(expand('#'))
command! -nargs=1 -complete=file E  tabedit <args>
command! Q  tabclose <args>

" Highlight cursor position verticaly and horizontaly.
command! ToggleCursorHighlight
      \   if !&cursorline || !&cursorcolumn || &colorcolumn ==# ''
      \ |   setl   cursorline   cursorcolumn colorcolumn=80
      \ | else
      \ |   setl nocursorline nocursorcolumn colorcolumn=
      \ | endif
nnoremap <silent> <Leader>h  :<C-u>ToggleCursorHighlight<CR>


command! CloneToNewTab  exec 'tabnew ' . expand('%:p')
" }}}


" ------------------------------------------------------------
" Setting for Visualize {{{
" ------------------------------------------------------------
" Show invisible characters and define format of the characters.
set list listchars=eol:$,tab:>-,extends:<
augroup MyAutoCmd
  au ColorScheme * hi WhitespaceEOL term=underline ctermbg=Blue guibg=Blue
  au VimEnter,WinEnter * call matchadd('WhitespaceEOL', ' \+$')
  au ColorScheme * hi TabEOL term=underline ctermbg=DarkGreen guibg=DarkGreen
  au VimEnter,WinEnter * call matchadd('TabEOL', '\t\+$')
  au ColorScheme * hi SpaceTab term=underline ctermbg=Magenta guibg=Magenta guisp=Magenta
  au VimEnter,WinEnter * call matchadd('SpaceTab', ' \+\ze\t\|\t\+\ze ')
  au Colorscheme * hi JPSpace term=underline ctermbg=Red guibg=Red
  au VimEnter,WinEnter * call matchadd('JPSpace', '　')  " \%u3000
augroup END
" }}}


" ------------------------------------------------------------
" Setting for languages. {{{
" ------------------------------------------------------------
function! s:insert_template(filename)
  let l:fn = expand(a:filename)
  if !bufexists("%:p") && input(printf('Do you want to load template:"%s"? [y/N]', l:fn)) =~? '^y\%[es]$'
    exec '0r ' . l:fn
    silent! %s/<+AUTHOR+>/koturn 0;/g
    silent! exec '%s/<+DATE+>/' . strftime('%Y %m\/%d') . '/g'
    silent! exec '%s/<+FILE+>/' . fnamemodify(expand('%'), ':t') . '/g'
    silent! exec '%s/<+CLASS+>/' . fnamemodify(expand('%'), ':t:r') . '/g'

    let l:row = search('<+CURSOR+>', 'cnw')
    let l:col = stridx(getline(l:row), '<+CURSOR+>')
    silent! %s/<+CURSOR+>//g
    call setpos('.', [0, l:row, l:col, 0])
  endif
endfunction

let c_gnu = 1  " Enable highlight gnu-C keyword in C-mode.
augroup MyAutoCmd
  " ----------------------------------------------------------
  " Setting for indent.
  " ----------------------------------------------------------
  au Filetype cs     setl sw=4 ts=4 sts=4 noexpandtab
  au Filetype java   setl sw=4 ts=4 sts=4 noexpandtab
  au Filetype kuin   setl sw=2 ts=2 sts=2 noexpandtab
  au Filetype python setl sw=4 ts=4 sts=4
  au Filetype make   setl sw=4 ts=4 sts=4 noexpandtab

  " ----------------------------------------------------------
  " Setting for template files.
  " ----------------------------------------------------------
  au BufNewFile build.xml      call s:insert_template('$DOTVIM/template/build.xml')
  au BufNewFile Makefile       call s:insert_template('$DOTVIM/template/Makefile')
  au BufNewFile *.c            call s:insert_template('$DOTVIM/template/template.c')
  au BufNewFile *.cc           call s:insert_template('$DOTVIM/template/template.cc')
  au BufNewFile *.cs           call s:insert_template('$DOTVIM/template/template.cs')
  au BufNewFile *.cpp          call s:insert_template('$DOTVIM/template/template.cpp')
  au BufNewFile *.html         call s:insert_template('$DOTVIM/template/template.html')
  au BufNewFile *.java         call s:insert_template('$DOTVIM/template/template.java')
  au BufNewFile *.py           call s:insert_template('$DOTVIM/template/template.py')
  au BufNewFile *.rb           call s:insert_template('$DOTVIM/template/template.rb')
  au BufNewFile *.sh           call s:insert_template('$DOTVIM/template/template.sh')
  au BufNewFile *.vim          call s:insert_template('$DOTVIM/template/template.vim')
  au BufNewFile [^(build)].xml call s:insert_template('$DOTVIM/template/template.xml')
augroup END
" }}}


" ------------------------------------------------------------
" Status line {{{
" ------------------------------------------------------------
" Show status line at the second line from the last line.
set laststatus=2
if g:is_cygwin
  set statusline=%<%f\ %m\ %r%h%w%{'[fenc='.(&fenc!=#''?&fenc:&enc).']\ [ff='.&ff.']\ [ft='.(&ft==#''?'null':&ft).']\ [ascii=0x'}%B]%=\ (%v,%l)/%L%8P

  " Change color of status line depending on mode.
  if has('syntax')
    augroup MyAutoCmd
      au InsertEnter * call s:hi_statusline(1)
      au InsertLeave * call s:hi_statusline(0)
      au ColorScheme * silent! let s:slhlcmd = 'highlight ' . s:get_highlight('StatusLine')
    augroup END
  endif

  function! s:hi_statusline(mode)
    if a:mode == 1
      highlight StatusLine guifg=white guibg=MediumOrchid gui=none ctermfg=white ctermbg=DarkRed cterm=none
    else
      highlight clear StatusLine
      silent exec s:slhlcmd
    endif
  endfunction

  function! s:get_highlight(hi)
    let l:hl = ''
    redir => l:hl
    exec 'highlight ' . a:hi
    redir END
    let l:hl = substitute(l:hl, '[\r\n]', '', 'g')
    let l:hl = substitute(l:hl, 'xxx', '', '')
    return l:hl
  endfunction
else
  NeoBundle 'bling/vim-airline'
endif
" }}}


" ------------------------------------------------------------
" Keybinds {{{
" ------------------------------------------------------------
if g:is_mac
  noremap  ¥  \
  noremap! ¥  \
  noremap  \  ¥
  noremap! \  ¥
endif

" Toggle search highlight
nnoremap <silent> <Esc><Esc>    :<C-u>setl nohlsearch<CR>
nnoremap <silent> <Space><Esc>  :<C-u>setl hlsearch! hlsearch?<CR>
" Search the word nearest to the cursor in new window.
nnoremap <C-w>*  <C-w>s*
nnoremap <C-w>#  <C-w>s#
" Move line to line as you see whenever wordwrap is set.
nnoremap j   gj
nnoremap k   gk
nnoremap gj   j
nnoremap gk   k
" Paste at start of line.
nnoremap <C-p>  <S-i><C-r>"<Esc>
" Toggle relativenumber.
"""""" if v:version >= 703
nnoremap <silent> <Leader>l  :<C-u>setl rnu! rnu?<CR>
"""""" endif
nnoremap <silent> <Leader>s  :<C-u>setl spell! spell?<CR>
nnoremap <silent> <Leader>w  :<C-u>setl wrap!  wrap?<CR>
" Resize window.
nnoremap <silent> <M-<>   <C-w><
nnoremap <silent> <M-+>   <C-w>+
nnoremap <silent> <M-->   <C-w>-
nnoremap <silent> <M-=>   <C-w>-
nnoremap <silent> <M->>   <C-w>>
nnoremap <silent> <Esc><  <C-w><
nnoremap <silent> <Esc>+  <C-w>+
nnoremap <silent> <Esc>-  <C-w>-
nnoremap <silent> <Esc>=  <C-w>-
nnoremap <silent> <Esc>>  <C-w>>
" Change tab.
nnoremap <C-Tab>    gt
nnoremap <S-C-Tab>  Gt

" Cursor-move setting at insert-mode.
inoremap <C-h>  <Left>
inoremap <C-j>  <Down>
inoremap <C-k>  <Up>
inoremap <C-l>  <Right>
" Like Emacs.
inoremap <C-f>  <Right>
inoremap <C-b>  <Left>
inoremap <silent> <C-d>  <Del>
inoremap <silent> <C-e>  <Esc>$a
" Insert a blank line in insert mode.
inoremap <C-o>  <Esc>o
" Easy <Esc> in insert-mode.
inoremap jj  <Esc>
" No wait for <Esc>.
if g:is_unix && s:is_cui
  inoremap <silent> <ESC>  <ESC>
  inoremap <silent> <C-[>  <ESC>
endif

" Cursor-move setting at insert-mode.
cnoremap <M-h>    <Left>
cnoremap <M-j>    <Down>
cnoremap <M-k>    <Up>
cnoremap <M-l>    <Right>
cnoremap <M-S-H>  <Home>
cnoremap <M-S-L>  <End>
cnoremap <M-w>    <S-Right>
cnoremap <M-b>    <S-Left>
cnoremap <M-x>    <Del>
cnoremap <M-p>    <C-r><S-">
" for terminal. (Enable <M-h> to move <Left>.)
cnoremap <Esc>h   <Left>
cnoremap <Esc>j   <Down>
cnoremap <Esc>k   <Up>
cnoremap <Esc>l   <Right>
cnoremap <Esc>H   <Home>
cnoremap <Esc>L   <End>
cnoremap <Esc>w   <S-Right>
cnoremap <Esc>b   <S-Left>
cnoremap <Esc>x   <Del>
cnoremap <Esc>p   <C-r><S-">
" Add excape to '/' and '?' automatically.
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'
" Select paren easly
onoremap )  f)
onoremap (  t(
xnoremap )  f)
xnoremap (  t(
" Reselect visual block after indent.
xnoremap <  <gv
xnoremap >  >gv
" Select current position to EOL.
xnoremap v  $<Left>
" Paste yanked string vertically.
vnoremap <C-p>  I<C-r>"<ESC>
" Sequencial copy
vnoremap <silent> <M-p>  "0p
" replace selected words.
vnoremap <C-r>  y:%s/<C-r>"/

noremap  <silent> <F2>  :<C-u>NERDTree<CR>
noremap! <silent> <F2>  <Esc>:NERDTree<CR>

noremap  <silent> <F3>  :<C-u>MiniBufExplore<CR>
noremap! <silent> <F3>  <Esc>:MiniBufExplore<CR>

noremap  <silent> <F4>  :<C-u>call tmpwin#toggle('VimShell')<CR>
noremap! <silent> <F4>  <Esc>:call tmpwin#toggle('VimShell')<CR>

noremap  <silent> <F5>  :<C-u>QuickRun<CR>
noremap! <silent> <F5>  <Esc>:QuickRun<CR>

noremap  <silent> <S-F5>  :<C-u>sp +enew<CR>:r !make<CR>
noremap! <silent> <S-F5>  <Esc>:sp +enew<CR>:r !make<CR>

" Open .vimrc
nnoremap  <silent> <Space>c  :<C-u>edit $MYVIMRC<CR>
" Open .gvimrc
nnoremap  <silent> <Space>g  :<C-u>edit $MYGVIMRC<CR>
if s:is_cui
  " Reload .vimrc.
  noremap  <silent> <F12> :<C-u>source $MYVIMRC<CR>
  noremap! <silent> <F12> <Esc>:source $MYVIMRC<CR>
else
  " Reload .vimrc and .gvimrc.
  noremap  <silent> <F12> :<C-u>source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>
  noremap! <silent> <F12> <Esc>:source $MYVIMRC<CR><Esc>:source $MYGVIMRC<CR>
endif

noremap  <silent> <F7> :<C-u>edit $DOTVIM/template/template.cc<CR>
noremap! <silent> <F7> <Esc>:edit $DOTVIM/template/template.cc<CR>




" ------------------------------------------------------------
" Force to use keybind of vim to move cursor.
" ------------------------------------------------------------
let s:key_msgs = [
      \ "Don't use Left-Key!!  Enter Normal-Mode and press 'h'!!!!",
      \ "Don't use Down-Key!!  Enter Normal-Mode and press 'j'!!!!",
      \ "Don't use Up-Key!!  Enter Normal-Mode and press 'k'!!!!",
      \ "Don't use Right-Key!!  Enter Normal-Mode and press 'l'!!!!",
      \ "Don't use Delete-Key!!  Press 'x' in Normal-Mode!!!!",
      \ "Don't use Backspace-Key!!  Press 'x' in Normal-Mode!!!!"
      \]
function! s:echo_keymsg(msgnr)
  echo s:key_msgs[a:msgnr]
endfunction

if s:is_cui && !g:is_windows
  " Disable move with cursor-key.
  noremap  <Left> <Nop>
  noremap! <Left> <Nop>
  nnoremap <Left> :<C-u>call <SID>echo_keymsg(0)<CR>
  inoremap <Left> <Esc>:call <SID>echo_keymsg(0)<CR>a

  noremap  <Down> <Nop>
  noremap! <Down> <Nop>
  nnoremap <Down> :<C-u>call <SID>echo_keymsg(1)<CR>
  inoremap <Down> <Esc>:call <SID>echo_keymsg(1)<CR>a

  noremap  <Up> <Nop>
  noremap! <Up> <Nop>
  nnoremap <Up> :<C-u>call <SID>echo_keymsg(2)<CR>
  inoremap <Up> <Esc>:call <SID>echo_keymsg(2)<CR>a

  noremap  <Right> <Nop>
  noremap! <Right> <Nop>
  nnoremap <Right> :<C-u>call <SID>echo_keymsg(3)<CR>
  inoremap <Right> <Esc>:call <SID>echo_keymsg(3)<CR>a
else
  map  <Left>   <Plug>(movewin-left)
  map! <Left>   <Plug>(movewin-left)
  map  <Down>   <Plug>(movewin-down)
  map! <Down>   <Plug>(movewin-down)
  map  <Up>     <Plug>(movewin-up)
  map! <Up>     <Plug>(movewin-up)
  map  <Right>  <Plug>(movewin-right)
  map! <Right>  <Plug>(movewin-right)
endif

" Disable delete with <Delete>
noremap  <Del> <Nop>
noremap! <Del> <Nop>
nnoremap <Del> :<C-u>call <SID>echo_keymsg(4)<CR>
inoremap <Del> <Esc>:call <SID>echo_keymsg(4)<CR>a
" Disable delete with <BS>.
" But available in command-line mode.
noremap  <BS> <Nop>
inoremap <BS> <Nop>
nnoremap <BS> :<C-u>call <SID>echo_keymsg(5)<CR>
inoremap <BS> <Esc>:call <SID>echo_keymsg(5)<CR>a
" }}}


" ------------------------------------------------------------
" END of .vimrc {{{
" ------------------------------------------------------------
if s:is_cui
  colorscheme koturn
  filetype plugin indent on
endif
" }}}

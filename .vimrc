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
" In Windows, you have to put HOME-directory.
" ============================================================
" ------------------------------------------------------------
" Variables {{{
" ------------------------------------------------------------
" Variables to identify environment.
let s:is_windows =  has('win16') || has('win32') || has('win64')
let s:is_cygwin  =  has('win32unix')
let s:is_unix    =  has('unix')
let s:is_cui     = !has('gui_running')

let $DOTVIM = $HOME . '/.vim'
if !exists($MYGVIMRC)
  let $MYGVIMRC = expand('~/.gvimrc')
endif


set foldmethod=marker

augroup MyAutoCmd
  autocmd!
augroup END

if has('vim_starting') && has('reltime')
  let s:startuptime = reltime()
  augroup MyAutoCmd
    au! VimEnter *
          \ let s:startuptime = reltime(s:startuptime)
          \|redraw
          \|echomsg 'startuptime: ' . reltimestr(s:startuptime)
          \|unlet s:startuptime
  augroup END
endif
" }}}




" ------------------------------------------------------------
" NeoBundle {{{
" ------------------------------------------------------------
" If neobundle is not exist, finish setting.
"""""" if !isdirectory(expand('~/.vim/bundle/neobundle.vim')) || v:version < 702
"   finish
"""""" endif
if has('vim_starting')
  source $VIMRUNTIME/macros/editexisting.vim
  set runtimepath+=$DOTVIM/bundle/neobundle.vim
endif
call neobundle#rc(expand('$DOTVIM/bundle/'))

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \  'build' : {
      \    'windows' : 'make -f make_mingw32.mak',
      \    'cygwin'  : 'make -f make_cygwin.mak',
      \    'mac'     : 'make -f make_mac.mak',
      \    'unix'    : 'make -f make_unix.mak'
      \}}

NeoBundleLazy 'Shougo/unite.vim', {
      \  'autoload' : {
      \    'commands' : [{
      \      'name' : 'Unite',
      \      'complete' : 'customlist,unite#complete_source'
      \},]}}

if has('lua') && v:version >= 703 && has('patch825')
  NeoBundleLazy 'Shougo/neocomplete.vim', {
        \  'autoload' : {'insert' : 1}
        \}
  inoremap <expr><CR>   neocomplete#smart_close_popup() . '<CR>'
  let g:neocomplete#enable_at_startup = 1
else
  NeoBundleLazy 'Shougo/neocomplcache', {
        \  'autoload' : {'insert' : 1}
        \}
  inoremap <expr><CR>   neocomplcache#smart_close_popup() . '<CR>'
  let g:neocomplcache_enable_at_startup = 1
endif

inoremap <expr><TAB>  pumvisible() ? '<C-n>' : '<TAB>'
NeoBundleLazy 'Shougo/neosnippet', {
      \  'autoload' : {'insert' : 1}
      \}


NeoBundle 'fholgado/minibufexpl.vim'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'nathanaelkane/vim-indent-guides'
" enable indent-guides on startup.
let g:indent_guides_enable_on_vim_startup = 1
NeoBundle 'hrp/EnhancedCommentify'
" NeoBundle 'kana/vim-smartinput'


"""""" if executable('w3m')
NeoBundleLazy 'yuratomo/w3m.vim', {
      \  'autoload' : {'commands' : 'W3m'}
      \}
"""""" endif


" A Plugin which accelerate jk-move
NeoBundleLazy 'rhysd/accelerated-jk', {
      \  'autoload' : {'mappings' : [
      \    ['n', '<Plug>(accelerated_jk_gj)'],
      \    ['n', '<Plug>(accelerated_jk_gk)']
      \]}}
nmap <C-j> <Plug>(accelerated_jk_gj)
nmap <C-k> <Plug>(accelerated_jk_gk)


NeoBundleLazy 'osyo-manga/vim-anzu', {
      \  'autoload' : {'mappings' : [
      \    ['n', '<Plug>(anzu-n-with-echo)'],
      \    ['n', '<Plug>(anzu-N-with-echo)'],
      \    ['n', '<Plug>(anzu-star-with-echo)'],
      \    ['n', '<Plug>(anzu-sharp-with-echo)']
      \]}}
nmap n <Plug>(anzu-n-with-echo)zz
nmap N <Plug>(anzu-N-with-echo)zz
nmap * <Plug>(anzu-star-with-echo)zz
nmap # <Plug>(anzu-sharp-with-echo)zz
nnoremap g* g*zz
nnoremap g# g#zz


"""""" if executable('lynx')
NeoBundleLazy 'thinca/vim-ref', {
      \  'autoload' : {'commands' : 'Ref'}
      \}
" A Setting for the site of webdict.
let g:ref_source_webdict_sites = {
      \  'je': {'url': 'http://dictionary.infoseek.ne.jp/jeword/%s'},
      \  'ej': {'url': 'http://dictionary.infoseek.ne.jp/ejword/%s'},
      \  'wiki-en': {'url': 'http://en.wikipedia.org/wiki/%s'},
      \  'wiki': {'url': 'http://ja.wikipedia.org/wiki/%s'},}
noremap <Leader>e  :<C-u>Ref webdict ej<Space>
noremap <Leader>j  :<C-u>Ref webdict je<Space>
noremap <Leader>we :<C-u>Ref webdict wiki-en<Space>
noremap <Leader>wj :<C-u>Ref webdict wiki<Space>

autocmd MyAutoCmd Filetype ref-webdict setl number
let g:ref_open = 'split'
" If you don't specify a following setting, webdict-results are garbled.
let g:ref_source_webdict_cmd = 'lynx -dump -nonumbers %s'
" Default webdict site
let g:ref_source_webdict_sites.default = 'ej'
" Filters for output. Remove the first few lines.
function! g:ref_source_webdict_sites.je.filter(output)
  return join(split(a:output, "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.ej.filter(output)
  return join(split(a:output, "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki.filter(output)
  return join(split(a:output, "\n")[17 :], "\n")
endfunction
"""""" endif


" http://nanasi.jp/articles/vim/bufonly_vim.html
NeoBundleLazy 'BufOnly.vim', {
      \  'autoload' : {'commands' : ['BufOnly', 'Bonly', 'BOnly', 'Bufonly']}
      \}

" http://nanasi.jp/articles/vim/renamer_vim.html
NeoBundleLazy 'renamer.vim', {
      \  'autoload' : {'commands' : ['Renamer', 'Ren']}
      \}

NeoBundleLazy 'scrooloose/nerdtree', {
      \  'autoload' : {'commands' : 'NERDTree'}
      \}

NeoBundleLazy 'Shougo/vimshell', {
      \  'autoload' : {'commands' : ['VimShell', 'VimShellPop', 'VimShellInteractive']}
      \}
let g:vimshell_prompt = "('v ')/$ "
" let g:vimshell_secondary_prompt = '> '
let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_right_prompt = '"[" . strftime("%Y/%m/%d %H:%M:%S", localtime()) . "]"'

" When you start-up vim with no command-line argument,
" execute VimShell.
" if has('vim_starting') && expand("%:p") ==# ''
"   autocmd MyAutoCmd VimEnter * VimShell
" endif


" http://nanasi.jp/articles/vim/java_getset_vim.html
NeoBundleLazy 'java_getset.vim', {
      \  'autoload' : {'filetypes' : 'java'}
      \}

" http://nanasi.jp/articles/vim/jcommenter_vim.html
NeoBundleLazy 'jcommenter.vim', {
      \  'autoload' : {'filetypes' : 'java'}
      \}
autocmd MyAutoCmd FileType java noremap <silent> <C-c> :call JCommentWriter()<CR><Esc>

NeoBundleLazy 'mitechie/pyflakes-pathogen', {
      \  'autoload' : {'filetypes' : 'python'}
      \}

" Clone of 'tpope/vim-endwise'.
NeoBundleLazy 'rhysd/endwize.vim', {
      \  'autoload' : {
      \    'filetypes' : ['lua', 'ruby', 'sh', 'zsh', 'vb', 'vbnet', 'aspvbs', 'vim'],
      \}}
let g:endwize_add_info_filetypes = ['ruby', 'c', 'cpp']
" imap <silent><CR> <CR><Plug>DiscretionaryEnd

NeoBundleLazy 'ruby-matchit', {
      \  'autoload' : {'filetypes' : 'ruby'}
      \}

" http://nanasi.jp/articles/vim/tagexplorer_vim.html
"""""" if executable('ctags')
NeoBundleLazy 'tagexplorer.vim', {
      \  'autoload' : {
      \    'filetypes' : ['cpp', 'java', 'perl', 'python', 'ruby']
      \}}
set tags=tags
"""""" endif

NeoBundleLazy 'thinca/vim-quickrun', {
      \  'autoload' : {
      \    'filetypes' : ['c', 'cpp', 'cs', 'java', 'python', 'perl', 'ruby', 'javascript'],
      \    'commands'  : 'QuickRun'
      \}}
let g:quickrun_config = {
      \  '_' : {
      \    'outputter/buffer/split' : ':botright',
      \    'outputter/buffer/close_on_empty' : 1,
      \    'runner' : 'vimproc',
      \    'runner/vimproc/updatetime' : 60
      \  },
      \  'c'      : {'type' : 'my_c'},
      \  'cpp'    : {'type' : 'my_cpp'},
      \  'cs'     : {'type' : 'my_cs'},
      \  'java'   : {'type' : 'my_java'},
      \  'lisp'   : {'type' : 'my_lisp'},
      \  'python' : {'type' : 'my_python'},
      \  'ruby'   : {'type' : 'my_ruby'},
      \  'tex'    : {'type' : 'my_tex'},
      \  'my_c' : {
      \    'command' : 'gcc',
      \    'cmdopt'  : '-Wall -Wextra -fsyntax-only',
      \    'exec'    : '%C %o %S',
      \  },
      \  'my_cpp' : {
      \    'command' : 'g++',
      \    'cmdopt'  : '-Wall -Wextra -fsyntax-only',
      \    'exec'    : '%C %o %S',
      \  },
      \  'my_cs' : {
      \    'command' : 'csc',
      \    'cmdopt'  : '/out:csOut.exe',
      \    'exec'    : '%C %o %S',
      \  },
      \  'my_java' : {
      \    'command' : 'javac',
      \    'exec'    : '%C %S',
      \  },
      \  'my_lisp' : {
      \    'command' : 'clisp',
      \    'exec'    : '%C %S',
      \  },
      \  'my_python' : {
      \    'command' : 'python',
      \    'exec'    : '%C %S',
      \  },
      \  'my_ruby' : {
      \    'command' : 'ruby',
      \    'exec'    : '%C %S',
      \  },
      \  'my_tex' : {
      \    'command' : 'pdflatex',
      \    'exec'    : '%C %S',
      \},}
" nnoremap <Leader>l :<C-u>QuickRun -exec '%c -l %s'<CR>
" NeoBundleLazy 'lambdalisue/platex.vim', {
"       \  'autoload' : {'filetypes' : 'tex'}
"       \}

" NeoBundleLazy 'davidhalter/jedi-vim', {
"       \  'autoload' : {
"       \    'filetypes' : ['python']
"       \}}

NeoBundleLazy 'klen/python-mode', {
      \  'autoload' : {'filetypes' : 'python'}
      \}
" Do not use the folding of python-mode.
let g:pymode_folding = 0


" When oppening a file, if the file has a particular extension,
" open the file in binary-mode.
augroup MyAutoCmd
  au BufRead *.7z,*.a,*.bin,*.bz,*.bz2,*.class,*.dll,*.exe,
        \*.flv,*.gif,*.gz,*.jpg,*.jpeg,*.lib,*.mid,*.mp3,*.mp4,*.o,*.obj,
        \*.out,*.pdf,*.png,*.pyc,*.so,*.tar,*.tgz,*.wav,*.wmv,*.zip
        \ set ft=binary
  if has('python')
    NeoBundleLazy 'Shougo/vinarise', {
          \  'autoload' : {
          \    'filetypes' : 'vinarise',
          \    'commands'  : 'Vinarise'
          \}}
    au Filetype binary Vinarise
  else  """""" elseif executable('xxd')
    command! Binarise set ft=binary | edit
    au Filetype binary let &bin = 1
    au BufReadPost * if &bin | %!xxd -g 1
    au BufReadPost * set ft=xxd | endif
    au BufWritePre * if &bin | %!xxd -r
    au BufWritePre * endif
    au BufWritePost * if &bin | %!xxd -g 1
    au BufWritePost * set nomod | endif
  endif
augroup END


NeoBundleLazy 'itchyny/thumbnail.vim', {
      \  'autoload' : {'commands' : 'Thumbnail'}
      \}

NeoBundleLazy 'thinca/vim-painter', {
      \  'autoload' : {'commands' : 'PainterStart'}
      \}

NeoBundle 'mattn/libcallex-vim'
NeoBundleLazy 'mattn/eject-vim', {
      \  'autoload' : {'commands' : 'Eject'}
      \}

NeoBundleLazy 'mattn/benchvimrc-vim', {
      \  'autoload' : {'commands' : 'BenchVimrc'}
      \}

" http://nanasi.jp/articles/vim/matrix_vim.html
NeoBundleLazy 'matrix.vim', {
      \  'type' : 'nosync',
      \  'base' : $DOTVIM . '/norepository-plugins',
      \  'autoload' : {'commands' : 'Matrix'}
      \}

NeoBundleLazy 'ScreenShot.vim', {
      \  'type' : 'nosync',
      \  'base' : $DOTVIM . '/norepository-plugins',
      \  'autoload' : {'commands' : ['ScreenShot', 'Text2Html', 'Diff2Html']}
      \}

" http://d.hatena.ne.jp/thinca/20091031/1257001194
NeoBundleLazy 'thinca/vim-scouter', {
      \  'autoload' : {'commands' : 'Scouter'}
      \}

" gmail.vim:
NeoBundleLazy 'yuratomo/gmail.vim', {
      \  'autoload' : {'commands' : 'Gmail'}
      \}
let g:gmail_user_name = 'jeak.koutan.apple@gmail.com'

" http://www.vim.org/scripts/script.php?script_id=3553
NeoBundleLazy 'sudoku_game.vim', {
      \  'type' : 'nosync',
      \  'base' : $DOTVIM . '/norepository-plugins',
      \  'autoload' : {'commands' : ['SudokuEasy', 'SudokuMedium', 'SudokuHard', 'SudokuVeryHard']}
      \}

NeoBundleLazy 'mfumi/viminesweeper', {
      \  'autoload' : {'commands' : 'MineSweeper'}
      \}


NeoBundleLazy 'basyura/TweetVim', {
      \  'depends' : ['tyru/open-browser.vim', 'basyura/twibill.vim'],
      \  'autoload' : {'commands' : ['TweetVimHomeTimeline', 'TweetVimUserTimeline', 'TweetVimCommandSay', 'TweetVimUserStream']}
      \}
noremap <Leader>t :<C-u>TweetVimCommandSay<Space>
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
      \  'depends' : ['tyru/open-browser.vim', 'mattn/webapi-vim'],
      \  'autoload' : {'commands' : ['FacebookHome', 'FacebookAuthenticate']}
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
" Turn off word wrap.
set nowrap
" Turn off starting a new line sutomatically.
set textwidth=0
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
" Use vim in secure.
set secure
" Swap file.
" set directory=~/vimfiles/swap/
set noswapfile
" Backup file.
" set backupdir=~/vimfiles/backup/
set nobackup nowritebackup
" file of '_viminfo'.
" set viminfo+=n~/vimfiles/viminfo/
set viminfo=
" Show vertical line at column-80
set colorcolumn=80
" Open buffer which already exists instead of opening new.
set switchbuf=useopen

" Indent settings
set autoindent   smartindent
set expandtab    smarttab
set shiftwidth=2 tabstop=2
" set cindent

" Show line number.
set number
if !s:is_cui
  set cursorline cursorcolumn
endif

function! g:toggleTabSpace(width)
  let s:i = 0
  let s:spaces = ''
  while s:i < a:width
    let s:spaces .= ' '
    let s:i += 1
  endwhile
  unlet s:i

  let &sw = a:width
  let &ts = a:width
  if &expandtab
    set noexpandtab
    silent! exec '%s/' . s:spaces . '/\t/g'
  else
    set expandtab
    silent! exec '%s/\t/' . s:spaces . '/g'
  endif
  unlet s:spaces
endfunction
nnoremap <silent> <Leader><Tab> :call g:toggleTabSpace(&ts)<CR>

" Make directory automatically.
function! s:autoMkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:autoMkdir(expand('<afile>:p:h'), v:cmdbang)

if s:is_cygwin
  if &term ==# 'xterm'       " In mintty
    " Change cursor shape depending on mode.
    let &t_ti .= "\e[1 q"
    let &t_SI .= "\e[5 q"
    let &t_EI .= "\e[1 q"
    let &t_te .= "\e[0 q"
    set termencoding=utf-8
  elseif &term ==# 'cygwin'  " In command-prompt
    set encoding=utf-8
    set fileencoding=utf-8
    set termencoding=utf-8
  endif
endif


command! DeleteTrailingWhitespace silent! %s/[ \t]\+$//g
command! DeleteBlankLines :g /^$/d
command! -nargs=1 -complete=file Rename f <args> | call delete(expand('#'))
command! -nargs=1 -complete=file E tabedit <args>
command! Q tabclose <args>

" Highlight cursor position. (Verticaly and horizontaly)
command! ToggleCursorHighlight
      \ if !&cursorline || !&cursorcolumn
      \|  setl   cursorline   cursorcolumn
      \|else
      \|  setl nocursorline nocursorcolumn
      \|endif
nnoremap <silent> <Leader>h :ToggleCursorHighlight<CR>

" FullScreen
if s:is_windows
  command! FullSize
        \ if s:is_cui
        \|  winpos 0 0
        \|  set lines=999 columns=999
        \|else
        \|  simalt ~x
        \|endif
  noremap  <silent> <F11>   :<C-u>FullSize<CR>
  noremap! <silent> <F11>   <Esc>:FullSize<CR>
  noremap  <silent> <M-F11> :<C-u>FullSize<CR>
  noremap! <silent> <M-F11> <Esc>:FullSize<CR>
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
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  set tags=./tags,tags  " Prevent duplication of tags file
endif

" In Windows, if $VIM is not include in $PATH, .exe cannot be found.
if s:is_windows && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif
" }}}
" }}}




" ------------------------------------------------------------
" Character-code and EOL-code {{{
" ------------------------------------------------------------
if s:is_windows
  set fenc=utf-8
  set termencoding=cp932
  if s:is_cui
    set enc=cp932
  else
    set enc=utf-8
  endif
endif

autocmd MyAutoCmd BufWritePre *
      \ if &ff != 'unix' && input(printf('Convert fileformat:%s to unix? [y/N]', &ff)) =~? '^y\%[es]$'
      \|  setl ff=unix
      \|endif

set fileformats=dos,unix,mac
set fileencodings=utf-8,euc-jp,cp932
scriptencoding utf-8  " required to visualize double-byte spaces.(after set enc)
" Fix 'fileencoding' to use 'encoding'
" if the buffer only contains 7-bit characters.
" Note that if the buffer is not 'modifiable',
" its 'fileencoding' cannot be changed, so that such buffers are skipped.
autocmd MyAutoCmd BufReadPost *
      \ if &modifiable && !search('[^\x00-\x7F]', 'cnw')
      \|  set fenc=ascii
      \|endif
" }}}




" ------------------------------------------------------------
" Setting for Visualize {{{
" ------------------------------------------------------------
" Show invisible characters. (like tabs and eol-character)
set list
" Format of invisible characters  to show.
set listchars=eol:$,tab:>-,extends:<
augroup MyAutoCmd
  au ColorScheme * highlight WhitespaceEOL term=underline ctermbg=Blue guibg=Blue
  au VimEnter,WinEnter * call matchadd('WhitespaceEOL', '\s\+$')
  au ColorScheme * highlight TabEOL term=underline ctermbg=DarkGreen guibg=DarkGreen
  au VimEnter,WinEnter * call matchadd('TabEOL', '\t\+$')
  au Colorscheme * highlight JPSpace term=underline ctermbg=Red guibg=Red
  au VimEnter,WinEnter * call matchadd('JPSpace', '　')  " \%u3000
augroup END
" }}}




" ------------------------------------------------------------
" Setting for languages. {{{
" ------------------------------------------------------------
function! s:insertTemplate(filename)
  let s:fn = expand(a:filename)
  if !bufexists("%:p") && input(printf('Do you want to load template:"%s"? [y/N]', s:fn)) =~? '^y\%[es]$'
    exec '0r ' . s:fn
    silent! %s/<+AUTHOR+>/koturn 0;/g
    silent! exec '%s/<+DATE+>/' . strftime('%Y %m\/%d') . '/g'
    silent! exec '%s/<+FILE+>/' . fnamemodify(expand('%'), ':t') . '/g'
    if &ft ==# 'java'
      exec '%s/<+CLASS+>/' . fnamemodify(expand('%'), ':t:r') . '/g'
    endif
  endif
  unlet s:fn
endfunction

let c_gnu = 1  " Enable highlight gnu-C keyword in C-mode.
augroup MyAutoCmd
  " ----------------------------------------------------------
  " Setting for indent.
  " ----------------------------------------------------------
  au Filetype cs     setl sw=4 ts=4 noexpandtab
  au Filetype java   setl sw=4 ts=4 noexpandtab
  au Filetype python setl sw=4 ts=4
  au Filetype make   setl sw=4 ts=4 noexpandtab

  " ----------------------------------------------------------
  " Setting for template files.
  " ----------------------------------------------------------
  au BufNewFile build.xml      call s:insertTemplate('$DOTVIM/template/build.xml')
  au BufNewFile Makefile       call s:insertTemplate('$DOTVIM/template/Makefile')
  au BufNewFile *.c            call s:insertTemplate('$DOTVIM/template/template.c')
  au BufNewFile *.cc           call s:insertTemplate('$DOTVIM/template/template.cc')
  au BufNewFile *.cs           call s:insertTemplate('$DOTVIM/template/template.cs')
  au BufNewFile *.cpp          call s:insertTemplate('$DOTVIM/template/template.cpp')
  au BufNewFile *.html         call s:insertTemplate('$DOTVIM/template/template.html')
  au BufNewFile *.java         call s:insertTemplate('$DOTVIM/template/template.java')
  au BufNewFile *.py           call s:insertTemplate('$DOTVIM/template/template.py')
  au BufNewFile *.rb           call s:insertTemplate('$DOTVIM/template/template.rb')
  au BufNewFile *.sh           call s:insertTemplate('$DOTVIM/template/template.sh')
  au BufNewFile [^(build)].xml call s:insertTemplate('$DOTVIM/template/template.xml')
augroup END
" }}}




" ------------------------------------------------------------
" Status line {{{
" ------------------------------------------------------------
" Show status line at the second line from the last line.
set laststatus=2
set statusline=%<%f\ %m\ %r%h%w%{'[fenc='.(&fenc!=#''?&fenc:&enc).']\ [ff='.&ff.']\ [ft='.(&ft==#''?'null':&ft).']\ [ascii=0x'}%B]%=\ (%v,%l)/%L%8P

" Change color of status line depending on mode.
if has('syntax')
  augroup MyAutoCmd
    au InsertEnter * call s:statusLine(1)
    au InsertLeave * call s:statusLine(0)
    au ColorScheme * silent! let s:slhlcmd = 'highlight ' . s:getHighlight('StatusLine')
  augroup END
endif

function! s:statusLine(mode)
  if a:mode == 1
    highlight StatusLine guifg=white guibg=MediumOrchid gui=none ctermfg=white ctermbg=DarkRed cterm=none
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:getHighlight(hi)
  let l:hl = ''
  redir => l:hl
  exec 'highlight ' . a:hi
  redir END
  let l:hl = substitute(l:hl, '[\r\n]', '', 'g')
  let l:hl = substitute(l:hl, 'xxx', '', '')
  return l:hl
endfunction
" }}}




" ------------------------------------------------------------
" Setting for CUI only. {{{
" ------------------------------------------------------------
if s:is_cui
  filetype plugin indent on
  colorscheme koturn
  " ------------------------------------------------------------
  " Setting of indentGuides.
  " ------------------------------------------------------------
  " You have to set following after colorscheme.
  " Enable highlighting indent at top level.
  let g:indent_guides_start_level = 1
  " Disable auto color. (You have to set manually.)
  let g:indent_guides_auto_colors = 0
  " Guide(highlight) width.
  let g:indent_guides_guide_size  = 1
  " Guide color of odd indentation.
  hi IndentGuidesOdd  ctermbg=darkgreen
  " Guide color of even indentation.
  hi IndentGuidesEven ctermbg=darkblue
endif
" }}}




" ------------------------------------------------------------
" Keybinds {{{
" ------------------------------------------------------------
" Open Anonymous buffer
nnoremap <Space>a :hide enew<CR>
" Turn off the highlight.
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
" Search the word nearest to the cursor in new window.
nnoremap <C-w>* <C-w>s*
nnoremap <C-w># <C-w>s#
" Move line to line as you see whenever wordwrap is set.
nnoremap j gj
nnoremap k gk
" Toggle relativenumber.
"""""" if v:version >= 703
nnoremap <silent> <Leader>l :setl relativenumber!<CR>
"""""" endif
" Resize window.
nnoremap <silent> <M-h>  :wincmd <<CR>
nnoremap <silent> <M-j>  :wincmd +<CR>
nnoremap <silent> <M-k>  :wincmd -<CR>
nnoremap <silent> <M-l>  :wincmd ><CR>
nnoremap <silent> <Esc>h :wincmd <<CR>
nnoremap <silent> <Esc>j :wincmd +<CR>
nnoremap <silent> <Esc>k :wincmd -<CR>
nnoremap <silent> <Esc>l :wincmd ><CR>

" Cursor-move setting at insert-mode.
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
" Insert a blank line in insert mode.
inoremap <C-o> <Esc>o
" Easy <Esc> in insert-mode.
inoremap jj <Esc>
" No wait for <Esc>.
if s:is_unix && s:is_cui
  inoremap <silent> <ESC> <ESC>
  inoremap <silent> <C-[> <ESC>
endif

" Cursor-move setting at insert-mode.
cnoremap <M-h>   <Left>
cnoremap <M-j>   <Down>
cnoremap <M-k>   <Up>
cnoremap <M-l>   <Right>
cnoremap <M-S-H> <Home>
cnoremap <M-S-L> <End>
cnoremap <M-w>   <S-Right>
cnoremap <M-b>   <S-Left>
cnoremap <M-x>   <Del>
cnoremap <M-p>   <C-r><S-">
" for terminal. (Enable <M-h> to move <Left>.)
cnoremap <Esc>h  <Left>
cnoremap <Esc>j  <Down>
cnoremap <Esc>k  <Up>
cnoremap <Esc>l  <Right>
cnoremap <Esc>H  <Home>
cnoremap <Esc>L  <End>
cnoremap <Esc>w  <S-Right>
cnoremap <Esc>b  <S-Left>
cnoremap <Esc>x  <Del>
cnoremap <Esc>p  <C-r><S-">
" Add excape to '/' and '?' automatically.
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
" Select paren easly
onoremap ) f)
onoremap ( t(
vnoremap ) f)
vnoremap ( t(

" Reselect visual block after indent.
vnoremap < <gv
vnoremap > >gv
" Paste yanked string vertically.
vnoremap <C-p> I<C-r>"<ESC><ESC>
" Sequencial copy
vnoremap <silent> <M-p> "0p<CR>
" Select current position to EOL.
vnoremap v $<Left>

noremap  <silent> <F2> <Esc>:NERDTree<CR>
noremap! <silent> <F2> <Esc>:NERDTree<CR>

noremap  <silent> <F3> <Esc>:MiniBufExplore<CR>
noremap! <silent> <F3> <Esc>:MiniBufExplore<CR>

noremap  <silent> <F4> <Esc>:VimShell<CR>
noremap! <silent> <F4> <Esc>:VimShell<CR>

noremap  <silent> <F5> <Esc>:QuickRun<CR>
noremap! <silent> <F5> <Esc>:QuickRun<CR>

noremap  <silent> <S-F5> <Esc>:sp +enew<CR>:r !make<CR>
noremap! <silent> <S-F5> <Esc>:sp +enew<CR>:r !make<CR>

" Open .vimrc
noremap  <silent> <Space>c <Esc>:e $MYVIMRC<CR>
" Open .gvimrc
noremap  <silent> <Space>g <Esc>:e $MYGVIMRC<CR>
if s:is_cui
  " Reload .vimrc.
  noremap  <silent> <F12> :<C-u>source $MYVIMRC<CR>
  noremap! <silent> <F12> <Esc>:source $MYVIMRC<CR>
else
  " Reload .vimrc and .gvimrc.
  noremap  <silent> <F12> :<C-u>source $MYVIMRC<CR><Esc>:source $MYGVIMRC<CR>
  noremap! <silent> <F12> <Esc>:source $MYVIMRC<CR><Esc>:source $MYGVIMRC<CR>
endif

noremap  <silent> <F7> <Esc>:e $DOTVIM/template/template.cc<CR>
noremap! <silent> <F7> <Esc>:e $DOTVIM/template/template.cc<CR>




" ------------------------------------------------------------
" Force to use keybind of vim to move cursor.
" ------------------------------------------------------------
function! s:msgLeft()
  echo "Don't use Left-Key!!  Enter Normal-Mode and press 'h'!!!!"
endfunction

function! s:msgDown()
  echo "Don't use Down-Key!!  Enter Normal-Mode and press 'j'!!!!"
endfunction

function! s:msgUp()
  echo "Don't use Up-Key!!  Enter Normal-Mode and press 'k'!!!!"
endfunction

function! s:msgRight()
  echo "Don't use Right-Key!!  Enter Normal-Mode and press 'l'!!!!"
endfunction

function! s:msgDelete()
  echo "Don't use Delete-Key!!  Press 'x' in Normal-Mode!!!!"
endfunction

function! s:msgBackspace()
  echo "Don't use Backspace-Key!!  Press 'x' in Normal-Mode!!!!"
endfunction


" Disable move with cursor-key.
noremap  <Left> <Nop>
noremap! <Left> <Nop>
nnoremap <Left> :<C-u>call <SID>msgLeft()<CR>
inoremap <Left> <Esc>:call <SID>msgLeft()<CR>a

noremap  <Down> <Nop>
noremap! <Down> <Nop>
nnoremap <Down> :<C-u>call <SID>msgDown()<CR>
inoremap <Down> <Esc>:call <SID>msgDown()<CR>a

noremap  <Up> <Nop>
noremap! <Up> <Nop>
nnoremap <Up> :<C-u>call <SID>msgUp()<CR>
inoremap <Up> <Esc>:call <SID>msgUp()<CR>a

noremap  <Right> <Nop>
noremap! <Right> <Nop>
nnoremap <Right> :<C-u>call <SID>msgRight()<CR>
inoremap <Right> <Esc>:call <SID>msgRight()<CR>a

" Disable delete with <Delete>
noremap  <Del> <Nop>
noremap! <Del> <Nop>
nnoremap <Del> :<C-u>call <SID>msgDelete()<CR>
inoremap <Del> <Esc>:call <SID>msgDelete()<CR>a

" Disable delete with <BS>.
" But available in command-line mode.
noremap  <BS> <Nop>
inoremap <BS> <Nop>
nnoremap <BS> :<C-u>call <SID>msgBackspace()<CR>
inoremap <BS> <Esc>:call <SID>msgBackspace()<CR>a
" }}}

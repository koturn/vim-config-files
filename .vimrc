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
  let $MYGVIMRC = $HOME . '/.gvimrc'
endif
let $DOTVIM = $HOME . '/.vim'
let $NEOBUNDLE_DIR = $DOTVIM . '/bundle'
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
  let s:running_vim_list = filter(split(serverlist(), '\n'), 'v:val !=? v:servername')
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
  command! -bar FullInstall  call s:full_plugin()
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
  command! -bar NeoBundleInit  call s:neobundle_init()
  echomsg 'Please Install NeoBundle!'
  echomsg 'Do command :NeoBundleInit'
  finish
endif

if g:at_startup
  set rtp+=$NEOBUNDLE_DIR/neobundle.vim
endif
call neobundle#rc()
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \   'windows' : 'make -f make_mingw32.mak',
      \   'cygwin'  : 'make -f make_cygwin.mak',
      \   'mac'     : 'make -f make_mac.mak',
      \   'unix'    : 'make -f make_unix.mak'
      \}}

NeoBundleLazy 'kien/ctrlp.vim', {
      \ 'autoload' : {'commands' : 'CtrlP'}
      \}
nnoremap <silent> <C-p>  :<C-u>CtrlP<CR>

NeoBundleLazy 'Shougo/unite.vim', {
      \ 'autoload' : {
      \   'commands' : [{
      \     'name' : 'Unite',
      \     'complete' : 'customlist,unite#complete_source'
      \}]}}
let g:unite_enable_start_insert = 1
NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload' : {'unite_sources' : 'colorscheme'}}
NeoBundleLazy 'ujihisa/unite-font', {'autoload' : {'unite_sources' : 'font'}}
NeoBundleLazy 'osyo-manga/unite-airline_themes', {'autoload' : {'unite_sources' : 'airline_themes'}}
NeoBundleLazy 'osyo-manga/unite-highlight', {'autoload' : {'unite_sources' : 'highlight'}}
NeoBundleLazy 'tsukkee/unite-tag', {'autoload' : {'unite_sources' : 'tag'}}
NeoBundleLazy 'tacroe/unite-mark', {'autoload' : {'unite_sources' : 'mark'}}
NeoBundleLazy 'yomi322/unite-tweetvim', {'autoload' : {'unite_sources' : 'tweetvim'}}
NeoBundleLazy 'Shougo/unite-outline', {'autoload' : {'unite_sources' : 'outline'}}
NeoBundleLazy 'rhysd/unite-n3337', {'autoload' : {'unite_sources' : 'n3337'}}
let g:unite_n3337_txt = $DOTVIM . '/n3337.txt'
NeoBundleLazy 'osyo-manga/unite-boost-online-doc', {
      \ 'depends' : ['Shougo/unite.vim', 'tyru/open-browser.vim', 'mattn/webapi-vim'],
      \ 'autoload' : {'unite_sources' : 'boost-online-doc'}
      \}
nnoremap [unite] <Nop>
nmap ,u  [unite]
noremap [unite]u :<C-u>Unite
noremap <silent> [unite]a  :<C-u>Unite airline_themes -auto-preview -winheight=12<CR>
noremap <silent> [unite]b  :<C-u>Unite buffer<CR>
noremap <silent> [unite]c  :<C-u>Unite colorscheme -auto-preview<CR>
noremap <silent> [unite]d  :<C-u>Unite directory<CR>
noremap <silent> [unite]f  :<C-u>Unite buffer file_rec/async:! file file_mru<CR>
noremap <silent> [unite]F  :<C-u>Unite font -auto-preview<CR>
noremap <silent> [unite]h  :<C-u>Unite highlight<CR>
noremap <silent> [unite]m  :<C-u>Unite mark -auto-preview<CR>
noremap <silent> [unite]o  :<C-u>Unite outline<CR>
noremap <silent> [unite]r  :<C-u>Unite register<CR>
noremap <silent> [unite]t  :<C-u>Unite tag<CR>
noremap <silent> [unite]T  :<C-u>Unite tweetvim<CR>

autocmd MyAutoCmd FileType cpp  noremap  <buffer> <silent> [unite]n  :<C-u>Unite n3337<CR>
autocmd MyAutoCmd FileType cpp  nnoremap <buffer> <Space>ub :<C-u>UniteWithCursorWord boost-online-doc

NeoBundleLazy 'Shougo/vimfiler', {
      \ 'depends'  : 'Shougo/unite.vim',
      \ 'autoload' : {'commands' : 'VimFiler'}
      \}

if has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
  NeoBundleLazy 'Shougo/neocomplete.vim', {
        \ 'autoload' : {'insert' : 1}
        \}
  " inoremap <expr><CR>  neocomplete#smart_close_popup() . '<CR>'
  let g:neocomplete#enable_at_startup = 1
else
  NeoBundleLazy 'Shougo/neocomplcache', {
        \ 'autoload' : {'insert' : 1}
        \}
  " inoremap <expr><CR>  neocomplcache#smart_close_popup() . '<CR>'
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_force_overwrite_completefunc = 1
  if !exists("g:neocomplcache_force_omni_patterns")
    let g:neocomplcache_force_omni_patterns = {}
  endif
  let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'
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

NeoBundleLazy 'tyru/eskk.vim', {
      \ 'autoload' : {'mappings' : [
      \   ['i', '<Plug>(eskk:'], ['c', '<Plug>(eskk:'], ['l', '<Plug>(eskk:']
      \]}}
function! s:toggle_ime()
  if s:is_ime
    set noimdisable
    iunmap <C-j>
    cunmap <C-j>
    lunmap <C-j>
  else
    set imdisable
    imap <C-j>  <Plug>(eskk:toggle)
    cmap <C-j>  <Plug>(eskk:toggle)
    lmap <C-j>  <Plug>(eskk:toggle)
  endif
  let s:is_ime = !s:is_ime
endfunction
let s:is_ime = 0
call s:toggle_ime()
command! -bar ToggleIME  call s:toggle_ime()

let s:bundle = neobundle#get('eskk.vim')
function! s:bundle.hooks.on_source(bundle)
  source $DOTVIM/plugin-config/eskk.vim
endfunction
unlet s:bundle

NeoBundleLazy "osyo-manga/vim-over", {
      \ 'autoload' : {'commands' : 'OverCommandLine'}
      \}
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
  au ColorScheme * hi IndentGuidesOdd  ctermbg=darkgreen guibg=#cc66cc
  au ColorScheme * hi IndentGuidesEven ctermbg=darkblue  guibg=#6666ff
augroup END

NeoBundleLazy 'osyo-manga/vim-reanimate', {
      \ 'autoload' : {'commands' : ['ReanimateSave', 'ReanimateLoad']}
      \}
let g:reanimate_save_dir = $DOTVIM . '/save'
let g:reanimate_default_save_name = 'reanimate'
let g:reanimate_sessionoptions = 'curdir,folds,help,localoptions,slash,tabpages,winsize'

NeoBundleLazy 'jceb/vim-hier', {
      \ 'autoload' : {'commands' : 'HierStart'}
      \}

NeoBundleLazy 'tyru/caw.vim', {
      \ 'autoload' : {'mappings' : ['<Plug>(caw:']}
      \}
nmap <Leader>c  <Plug>(caw:i:toggle)
xmap <Leader>c  <Plug>(caw:i:toggle)

NeoBundleLazy 'tpope/vim-surround', {
      \ 'autoload' : {'mappings' : [
      \   ['n', '<Plug>Dsurround'], ['n', '<Plug>Csurround'],  ['n', '<Plug>Ysurround'],
      \   ['n', '<Plug>YSurround'], ['n', '<Plug>Yssurround'], ['n', '<Plug>YSsurround'],
      \   ['v', '<Plug>VSurround'], ['v', '<Plug>VgSurround']
      \]}}
nmap ds   <Plug>Dsurround
nmap cs   <Plug>Csurround
nmap ys   <Plug>Ysurround
nmap yS   <Plug>YSurround
nmap yss  <Plug>Yssurround
nmap ySs  <Plug>YSsurround
nmap ySS  <Plug>YSsurround
xmap S    <Plug>VSurround
xmap gS   <Plug>VgSurround

NeoBundleLazy 'kana/vim-altr', {
      \ 'autoload' : {'mappings' : ['<Plug>(altr-']}
      \}
nmap <Space>a  <Plug>(altr-forward)
nmap <Space>A  <Plug>(altr-back)

" Clone of 'tpope/vim-endwise'.
NeoBundleLazy 'rhysd/endwize.vim', {
      \ 'autoload' : {
      \   'filetypes' : ['lua', 'ruby', 'sh', 'zsh', 'vb', 'vbnet', 'aspvbs', 'vim'],
      \}}
let g:endwize_add_info_filetypes = ['ruby', 'c', 'cpp']
let g:endwise_no_mappings = 1
autocmd MyAutoCmd FileType lua,ruby,sh,zsh,vb,vbnet,aspvbs,vim  imap <buffer> <silent><CR>  <CR><Plug>DiscretionaryEnd

NeoBundleLazy 'kana/vim-smartinput', {
      \ 'autoload' : {'insert' : 1}
      \}
let s:bundle = neobundle#get('vim-smartinput')
function! s:bundle.hooks.on_source(bundle)
  call smartinput#define_rule({
        \ 'at'       : '\%(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*\%#',
        \ 'char'     : '{',
        \ 'input'    : '{};<Left><Left>',
        \ 'filetype' : ['cpp'],
        \})
endfunction
unlet s:bundle

NeoBundleLazy 'AndrewRadev/switch.vim', {
      \ 'autoload' : {'commands' : 'Switch'}
      \}
let s:bundle = neobundle#get('switch.vim')
function! s:bundle.hooks.on_source(bundle)
  source $DOTVIM/plugin-config/switch.vim
endfunction
unlet s:bundle
nnoremap <silent> <Space>!  :<C-u>Switch<CR>

"""""" if executable('w3m')
NeoBundleLazy 'yuratomo/w3m.vim', {
      \ 'autoload' : {'commands' : 'W3m'}
      \}
"""""" endif

NeoBundleLazy 'rhysd/clever-f.vim', {
      \ 'autoload' : {'mappings' : ['<Plug>(clever-f-']}
      \}
map f  <Plug>(clever-f-f)
map F  <Plug>(clever-f-F)
map t  <Plug>(clever-f-t)
map T  <Plug>(clever-f-T)
 " A Plugin which accelerate jk-move
NeoBundleLazy 'rhysd/accelerated-jk', {
      \ 'autoload' : {'mappings' : [
      \   ['n', '<Plug>(accelerated_jk_g']
      \]}}
nmap <C-j> <Plug>(accelerated_jk_gj)
nmap <C-k> <Plug>(accelerated_jk_gk)

NeoBundleLazy 'osyo-manga/vim-anzu', {
      \ 'autoload' : {'mappings' : [['n', '<Plug>(anzu-']]}
      \}
let g:anzu_bottomtop_word = 'search hit BOTTOM, continuing at TOP'
let g:anzu_topbottom_word = 'search hit TOP, continuing at BOTTOM'
let g:anzu_status_format  = '%p(%i/%l) %w'
nmap n  <Plug>(anzu-n-with-echo)zz
nmap N  <Plug>(anzu-N-with-echo)zz
nmap *  <Plug>(anzu-star-with-echo)Nzz
nmap #  <Plug>(anzu-sharp-with-echo)Nzz
nnoremap g*  g*Nzz
nnoremap g#  g#Nzz

NeoBundleLazy 'daisuzu/rainbowcyclone.vim', {
      \ 'autoload' : {
      \   'commands' : 'RC',
      \   'mappings' : [['n', '<Plug>(rc_search_']]
      \}}
nmap c/  <Plug>(rc_search_forward)
nmap c?  <Plug>(rc_search_backward)
nmap <silent> c*  <Plug>(rc_search_forward_with_cursor)
nmap <silent> c#  <Plug>(rc_search_backward_with_cursor)
nmap <silent> cn  <Plug>(rc_search_forward_with_last_pattern)
nmap <silent> cN  <Plug>(rc_search_backward_with_last_pattern)

NeoBundleLazy 'thinca/vim-visualstar', {
      \ 'autoload' : {'mappings' : [['v', '<Plug>(visualstar-']]
      \}}
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
nnoremap <Leader>e   :<C-u>Ref webdict ej<Space>
nnoremap <Leader>j   :<C-u>Ref webdict je<Space>
nnoremap <Leader>dn  :<C-u>Ref webdict dn<Space>
nnoremap <Leader>we  :<C-u>Ref webdict wiki_en<Space>
nnoremap <Leader>wj  :<C-u>Ref webdict wiki<Space>

let s:bundle = neobundle#get('vim-ref')
function! s:bundle.hooks.on_source(bundle)
  source $DOTVIM/plugin-config/ref.vim
endfunction
unlet s:bundle
"""""" endif

NeoBundleLazy 'mattn/excitetranslate-vim', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload' : {'commands' : 'ExciteTranslate'}
      \}
NeoBundle 'mattn/googletranslate-vim', {
      \ 'autoload' : {'commands' : 'GoogleTranslate'}
      \}

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
      \   'mappings' : ['<Plug>(movewin-']
      \}}

NeoBundleLazy 'koturn/resizewin.vim', {
      \ 'autoload' : {
      \   'commands' : ['ResizeWin', 'FullSize'],
      \   'mappings' : ['<Plug>(resizewin-']
      \}}
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

NeoBundleLazy 'vim-scripts/DrawIt', {
      \ 'autoload' : {
      \   'commands' : 'DrawIt',
      \   'mappings' : ['<Plug>DrawIt']
      \}}
map <Leader>di  <Plug>DrawItStart
map <Leader>ds  <Plug>DrawItStop

" NeoBundle 'vim-scripts/Align'

NeoBundleLazy 'osyo-manga/vim-sugarpot', {
      \ 'autoload' : {'commands' : [
      \   {'name' : 'SugarpotPreview', 'complete' : 'file'},
      \   {'name' : 'SugarpotClosePreview', 'complete' : 'file'},
      \   {'name' : 'SugarpotClosePreviewAll', 'complete' : 'file'}
      \]}}
let g:sugarpot_convert = get(g:, 'imagemagick_path', '')
let g:sugarpot_convert_resize = '50%x25%'
if g:is_windows && s:is_cui
  set guifont=Consolas:h9 guifontwide=MS_Gothic:h9
endif

" if !g:is_cygwin
  " NeoBundle 'osyo-manga/vim-pronamachang', {
  "       \ 'depends' : ['osyo-manga/vim-sound', 'Shougo/vimproc.vim']
  "       \}
  " let g:pronamachang_voice_root = get(g:, 'pronamachang_voice_path', '')
  " let g:pronamachang_startup_voices = {
  "       \ 'all'       : ['kei_voice_008_phrase2'],
  "       \ 'morning'   : ['kei_voice_008_phrase1'],
  "       \ 'afternoon' : ['kei_voice_009_phrase1'],
  "       \ 'night'     : ['kei_voice_010_phrase1', 'kei_voice_010_phrase3'],
  "       \}
  " let g:pronamachang_goodbye_voices = {
  "       \ 'all'       : ['kei_voice_018_phrase1', 'kei_voice_086_phrase2'],
  "       \ 'morning'   : ['kei_voice_030_phrase1'],
  "       \ 'afternoon' : ['kei_voice_011_phrase2', 'kei_voice_030_phrase1'],
  "       \ 'night'     : ['kei_voice_011_phrase1', 'kei_voice_011_phrase2', 'kei_voice_011_phrase3', 'kei_voice_017_phrase2'],
  "       \}
  " let g:pronamachang_say_startup_enable = 1
  " let g:pronamachang_say_goodbye_enable = 1
" endif

NeoBundleLazy 'add20/vim-conque', {
      \ 'autoload' : {'commands' : 'ConqueTerm'}
      \}
NeoBundleLazy 'Shougo/vimshell', {
      \ 'autoload' : {'commands' : ['VimShell', 'VimShellPop', 'VimShellInteractive']}
      \}
let s:bundle = neobundle#get('vimshell')
function! s:bundle.hooks.on_source(bundle)
  source $DOTVIM/plugin-config/vimshell.vim
endfunction
unlet s:bundle

" When you start-up vim with no command-line argument,
" execute VimShell.
" if g:at_startup && !argc()
"   autocmd MyAutoCmd VimEnter * VimShell
" endif

"""""" if executable('MSBuild.exe') || executable('xbuild')
NeoBundleLazy 'nosami/Omnisharp', {
      \ 'autoload' : {'filetypes' : 'cs'},
      \ 'build' : {
      \   'windows' : 'MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
      \   'mac'     : 'xbuild server/OmniSharp.sln',
      \   'unix'    : 'xbuild server/OmniSharp.sln'
      \}}
""""""

""" C++ plugins
"""""" if executable('clang')
NeoBundleLazy 'rhysd/vim-clang-format', {
      \ 'depends' : ['kana/vim-operator-user'],
      \ 'autoload' : {
      \   'commands' : ['ClangFormat', 'ClangFormatEchoFormattedCode'],
      \   'mappings' : ['<Plug>(operator-clang-format)']
      \}}
map ,x  <Plug>(operator-clang-format)

" NeoBundleLazy 'osyo-manga/vim-marching', {
"       \ 'depends' : ['Shougo/vimproc.vim', 'osyo-manga/vim-reunions'],
"       \ 'autoload' : {'filetypes' : ['c', 'cpp']}
"       \}
" let g:marching_clang_command = get(g:, 'clang_command', 'clang')
" let g:marching_clang_command_option='-std=c++1y'
" let g:marching_include_paths = [
"       \ get(g:, 'g:cpp_include_files', 'clang')
"       \]
" imap <buffer> <C-x><C-o> <Plug>(marching_start_omni_complete)

NeoBundleLazy 'Rip-Rip/clang_complete', {
      \ 'autoload' : {'filetypes' : ['c', 'cpp']}
      \}
let g:clang_complete_auto = 0
let g:clang_use_library = 1
let g:clang_library_path = get(g:, 'clang_lib', 'clang')
let g:clang_exec = '"' . get(g:, 'clang_command', 'clang')
if g:is_windows
  let g:clang_user_options = '2> NUL || exit 0"'
else
  let g:clang_user_options = '2> /dev/null || exit 0"'
endif
let g:clang_jumpto_declaration_key = '<Space>t'

NeoBundleLazy 'rhysd/wandbox-vim', {
      \ 'autoload' : {'commands' : 'Wandbox'}
      \}
let s:bundle = neobundle#get('wandbox-vim')
function! s:bundle.hooks.on_source(bundle)
  " Set default compilers for each filetype
  let wandbox#default_compiler = {
        \ 'cpp' : 'clang-head',
        \ 'ruby' : 'ruby-1.9.3-p0',
        \}
  " Set default options for each filetype.  Type of value is string or list of string
  let wandbox#default_options = {
        \ 'cpp' : 'warning,optimize,boost-1.55',
        \ 'haskell' : ['haskell-warning', 'haskell-optimize']
        \}
endfunction
unlet s:bundle
"""""" endif

NeoBundleLazy 'tatt61880/kuin_vim', {
      \ 'autoload' : {'filetypes' : 'kuin'}
      \}
autocmd MyAutoCmd BufReadPre *.kn  setfiletype kuin

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

NeoBundleLazy 'ruby-matchit', {
      \ 'autoload' : {'filetypes' : 'ruby'}
      \}

NeoBundleLazy 'mattn/emmet-vim', {
      \ 'autoload' : {'filetypes' : 'html'}
      \}

"""""" if executable('ctags')
NeoBundleLazy 'tagexplorer.vim', {
      \ 'autoload' : {
      \   'filetypes' : ['cpp', 'java', 'perl', 'python', 'ruby', 'tags']
      \}}
"""""" endif

NeoBundleLazy 'rbtnn/vimconsole.vim', {
      \ 'autoload' : {'commands' : ['VimConsole', 'VimConsoleOpen']}
      \}

NeoBundleLazy 'thinca/vim-quickrun', {
      \ 'autoload' : {'commands' : 'QuickRun'}
      \}
let s:bundle = neobundle#get('vim-quickrun')
function! s:bundle.hooks.on_source(bundle)
  source $DOTVIM/plugin-config/quickrun.vim
endfunction
unlet s:bundle

NeoBundleLazy 'lambdalisue/platex.vim', {
      \ 'autoload' : {'filetypes' : 'tex'}
      \}
let g:platex_suite_main_file = 'graduationthesis'
let g:platex_suite_latex_compiler = 'C:/w32tex/bin/platex.exe'
let g:platex_suite_bibtex_compiler = 'C:/w32tex/bin/pbibtex.exe'
let g:platex_suite_dvipdf_compiler = 'C:/w32tex/bin/dvipdfmx.exe'

" NeoBundleLazy 'davidhalter/jedi-vim', {
"       \ 'autoload' : {
"       \   'filetypes' : ['python']
"       \}}

NeoBundleLazy 'klen/python-mode', {
      \ 'autoload' : {'filetypes' : 'python'}
      \}
" Do not use the folding of python-mode.
let g:pymode_folding = 0

NeoBundleLazy 'kannokanno/previm', {
      \ 'autoload' : {'filetypes' : 'markdown'}
      \}
" g:chrome_cmd is defined in ~/.vim/.private.vim
let g:previm_open_cmd = get(g:, 'browser_cmd', '')

NeoBundleLazy 'joker1007/vim-markdown-quote-syntax', {
      \ 'autoload' : {'filetypes' : 'markdown'}
      \}
let s:bundle = neobundle#get('vim-markdown-quote-syntax')
function! s:bundle.hooks.on_source(bundle)
  let g:markdown_quote_syntax_filetypes = {
        \ 'c'          : {'start' : 'c'},
        \ 'cpp'        : {'start' : 'cpp'},
        \ 'html'       : {'start' : 'html'},
        \ 'java'       : {'start' : 'java'},
        \ 'javascript' : {'start' : 'javascript'},
        \ 'perl'       : {'start' : 'perl'},
        \ 'python'     : {'start' : 'python'},
        \ 'ruby'       : {'start' : 'ruby'},
        \ 'vim'        : {'start' : 'VimL'}
        \}
endfunction
unlet s:bundle


" When oppening a file, if the file has a particular extension,
" open the file in binary-mode.
augroup MyAutoCmd
  au BufRead *.7z,*.a,*.bin,*.bz,*.bz2,*.class,*.dll,*.exe,
        \*.flv,*.gif,*.gz,*.jpg,*.jpeg,*.lib,*.mid,*.mp3,*.mp4,*.o,*.obj,
        \*.out,*.pdf,*.png,*.pyc,*.so,*.tar,*.tgz,*.wav,*.wmv,*.zip
        \ setfiletype binary
  if has('python')
    NeoBundleLazy 'Shougo/vinarise', {
          \ 'autoload' : {'commands'  : 'Vinarise'}
          \}
    au Filetype binary Vinarise
  else  """""" elseif executable('xxd')
    " command! -bar Binarise  setfiletype binary | edit
    au Filetype binary  set binary
    au BufReadPost * if &bin | %!xxd -g 1
    au BufReadPost * setfiletype xxd | endif
    au BufWritePre * if &bin | %!xxd -r
    au BufWritePre * endif
    au BufWritePost * if &bin | %!xxd -g 1
    au BufWritePost * set nomodified | endif
  endif
augroup END

function! s:read_binary()
  set binary
  %!xxd -g 1
  setfiletype xxd
endfunction
function! s:write_binary()
  %!xxd -r
  write
  %!xxd -g 1
  set nomodified
endfunction
command! -bar Binarise     call s:read_binary()
command! -bar WriteBinary  call s:write_binary()

NeoBundleLazy 'koturn/benchvimrc-vim', {
      \ 'autoload' : {'commands' : [{'name' : 'BenchVimrc', 'complete' : 'file'}]}
      \}
NeoBundleLazy 'thinca/vim-scouter', {
      \ 'autoload' : {'commands' : [{'name' : 'Scouter', 'complete' : 'file'}]}
      \}
NeoBundleLazy 'koturn/vim-cloud-speech-synthesizer', {
      \ 'depends' : ['mattn/webapi-vim', 'Shougo/vimproc.vim', 'osyo-manga/vim-sound'],
      \ 'autoload' : {'commands' : 'CloudSpeechSynthesize'}
      \}
" Work with clipboard.
NeoBundleLazy 'koturn/vim-clipboard', {
      \ 'autoload' : {'commands' : ['GetClip', 'PutClip']}
      \}
nnoremap <silent> ,<Space>  :<C-u>PutClip<CR>
nnoremap <silent> <Space>,  :<C-u>GetClip<CR>
if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus,autoselect
    let g:clipboard#clip_register = '@+'
    cnoremap <M-P>  <C-r>+
    vnoremap <M-P>  "+p
  else
    set clipboard=unnamed,autoselect
    cnoremap <M-P>  <C-r>*
    vnoremap <M-P>  "*p
  endif
endif


" In windows, not to use cygwin-git.
if g:is_windows
  let s:win_git_path = get(g:, 'win_git_path', '')
  if s:win_git_path != ''
    " let $PATH = g:win_git_path . ';' . $PATH
  endif
  unlet s:win_git_path
endif

NeoBundleLazy 'mattn/gist-vim', {
      \ 'autoload' : {'commands' : ['Gist']}
      \}
NeoBundle 'tpope/vim-fugitive'

NeoBundleLazy 'tyru/open-browser.vim', {
      \ 'autoload' : {
      \   'commands' : ['OpenBrowser', 'OpenBrowserSearch'],
      \   'mappings' : '<Plug>(openbrowser-smart-search)'
      \}}
nmap <Space>o  <Plug>(openbrowser-smart-search)

NeoBundleLazy 'yuratomo/gmail.vim', {
      \ 'autoload' : {'commands' : 'Gmail'}
      \}
" g:gmail_address is defined in ~/.vim/.private.vim
let g:gmail_user_name = get(g:, 'gmail_address', '')

NeoBundleLazy 'basyura/TweetVim', {
      \ 'depends' : ['tyru/open-browser.vim', 'basyura/twibill.vim'],
      \ 'autoload' : {
      \   'commands' : ['TweetVimHomeTimeline', 'TweetVimUserTimeline', 'TweetVimCommandSay', 'TweetVimUserStream'],
      \   'unite_sources' : 'tweetvim'
      \}}
noremap <Leader>t  :<C-u>TweetVimCommandSay<Space>
" Number of tweet to show on editor.
let g:tweetvim_tweet_per_page = 50
" Show twitter client.
let g:tweetvim_display_source = 1
" Display tweet time.
let g:tweetvim_display_time   = 1
" Show icon.(require ImageMagick)
" let g:tweetvim_display_icon = 1

if g:is_windows
  NeoBundleLazy 'koron/chalice', {
        \ 'autoload' : {'commands' : 'Chalice'}
        \}
endif

" require fbconsole.py
"   $ pip install fbconsole
NeoBundleLazy 'daisuzu/facebook.vim', {
      \ 'depends' : ['tyru/open-browser.vim', 'mattn/webapi-vim'],
      \ 'autoload' : {'commands' : ['FacebookHome', 'FacebookAuthenticate']}
      \}

NeoBundleLazy 'tsukkee/lingr-vim', {
      \ 'autoload' : {'commands' : 'LingrLaunch'}
      \}
NeoBundleLazy 'rbtnn/puyo.vim', {
      \ 'autoload' : {'commands' : 'Puyo'}
      \}
NeoBundleLazy 'yuratomo/weather.vim', {
      \ 'autoload' : {'commands' : 'Weather'}
      \}
NeoBundleLazy 'mattn/calendar-vim', {
      \ 'autoload' : {'commands' : ['Calendar', 'CalendarH', 'CalendarT']}
      \}
NeoBundleLazy 'gregsexton/VimCalc', {
      \ 'autoload' : {'commands' : 'Calc'}
      \}
NeoBundleLazy 'LeafCage/vimhelpgenerator', {
      \ 'autoload' : {'commands' : 'VimHelpGenerator'}
      \}
let g:vimhelpgenerator_defaultlanguage = 'en'
let g:vimhelpgenerator_version = ''
let g:vimhelpgenerator_author = 'Author  : koturn 0;'
let g:vimhelpgenerator_contents = {
      \ 'contents': 1, 'introduction': 1, 'usage': 1, 'interface': 1,
      \ 'variables': 1, 'commands': 1, 'key-mappings': 1, 'functions': 1,
      \ 'setting': 0, 'todo': 1, 'changelog': 0
      \}
NeoBundleLazy 'mattn/startmenu-vim', {
      \ 'depends' : ['mattn/webapi-vim', 'kien/ctrlp.vim', 'Shougo/unite.vim'],
      \ 'autoload' : {'commands' : 'StartMenu'}
      \}
let g:startmenu_interface = 'unite'

" NeoBundle 'mattn/webapi-vim'
" NeoBundle 'ynkdir/vim-funlib'
" }}}
" ************** The end of setting of NeoBundle **************


" ------------------------------------------------------------
" Basic settings {{{
" ------------------------------------------------------------
NeoBundle 'vimtaku/hl_matchit.vim'
source $VIMRUNTIME/macros/matchit.vim
let g:hl_matchit_enable_on_vim_startup = 1
let g:hl_matchit_speed_level = 1
let g:hl_matchit_allow_ft_regexp = 'html\|vim\|sh'
set helplang=ja
" Hide splash screen.
set shortmess+=I
" Enable to use '/' for direstory path separator on Windows.
set shellslash
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
" Settng for C-a adding and C-x subtracting.
set nrformats=alpha,octal,hex
" Indent settings
set autoindent   smartindent
set expandtab    smarttab
set shiftwidth=2 tabstop=2 softtabstop=2
" Show line number.
set number
" Setting for grep
if executable('ag')
  set grepprg=ag\ --nogroup\ -iS
  set grepformat=%f:%l:%m
elseif executable('ack')
  set grepprg=ack\ --nogroup
  set grepformat=%f:%l:%m
elseif executable('grep')
  set grepprg=grep\ -Hnd\ skip\ -r
  set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m
else
  set grepprg=internal
endif
" Setting for printing.
if has('printer') && g:is_windows
  set printoptions=number:y,header:0,syntax:y,left:5pt,right:5pt,top:10pt,bottom:10pt
  set printfont=Consolas:h8 printmbfont=r:MS_Gothic:h8,a:yes
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
set tags+=../tags,../../tags

" In Windows, if $VIM is not include in $PATH, .exe cannot be found.
if g:is_windows && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH .= ';' . $VIM
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
  if &term =~# '^xterm' && &t_Co < 256
    set t_Co=256  " Extend cygwin terminal color
  endif
  if &term !=# 'cygwin'  " not in command prompt
    " Change cursor shape depending on mode.
    let &t_ti .= "\e[1 q"
    let &t_SI .= "\e[5 q"
    let &t_EI .= "\e[1 q"
    let &t_te .= "\e[0 q"
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
  let l:spaces = ''
  for l:i in range(1, a:width)
    let l:spaces .= ' '
  endfor

  let &sw  = a:width
  let &ts  = a:width
  let &sts = a:width
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


function! s:change_indent(is_bang, width)
  if a:is_bang
    let &sw  = a:width
    let &ts  = a:width
    let &sts = a:width
  else
    let &l:sw  = a:width
    let &l:ts  = a:width
    let &l:sts = a:width
  endif
endfunction
command! -bang -bar -nargs=1 Indent  call s:change_indent(<bang>0, <q-args>)

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
command! -bar -nargs=1 Which  call s:cmd_which(<q-args>)


" lcd to buffer-directory.
function! s:cmd_lcd(count)
  let l:dir = expand('%:p' . repeat(':h', a:count + 1))
  if isdirectory(l:dir)
    exec 'lcd' fnameescape(l:dir)
  endif
endfunction
command! -bar -nargs=0 -count=0 Lcd  call s:cmd_lcd(<count>)


" Close buffer not closing window
function! s:buf_delete()
  let l:current_bufnr   = bufnr('%')
  let l:alternate_bufnr = bufnr('#')
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
command! -bar Ebd  call s:buf_delete()


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


function! s:get_selected_text()
  let l:tmp = @@
  silent normal gvy
  let l:text = @@
  let @@ = l:tmp
  return l:text
endfunction

" Execute selected text as a vimscript
function! s:exec_selected_text()
  for l:elm in split(s:get_selected_text(), "\n")
    exec l:elm
  endfor
endfunction
xnoremap <silent> <Leader>e  :<C-u>call <SID>exec_selected_text()<CR>

" Replace command for selected text.
" @*: clipboard  @@: anonymous buffer
function! s:store_selected_text(is_verymagic)
  if a:is_verymagic
    let l:selected = substitute(s:get_selected_text(), '\([\.\^\$\~\*\+\/\\\(\)\<\>\{\}\?\=\|]\)', '\\\1', 'g')
  else
    let l:selected = substitute(s:get_selected_text(), '\([\.\^\$\~\*\+\/\\]\)', '\\\1', 'g')
  endif
  silent! let @* = l:selected
  silent! let @0 = l:selected
endfunction
xnoremap ,r  :<C-u>call <SID>store_selected_text(0)<CR>:<C-u>.,$s/<C-r>"//gc<Left><Left><Left>
xnoremap ,R  :<C-u>call <SID>store_selected_text(1)<CR>:<C-u>.,$s/\v<C-r>"//gc<Left><Left><Left>
xnoremap ,s  :<C-u>call <SID>store_selected_text(0)<CR>/<C-u><C-r>"<CR>N
xnoremap ,S  :<C-u>call <SID>store_selected_text(1)<CR>/<C-u>\v<C-r>"<CR>N


" Complete HTML tag
function! s:complete_tag()
  normal vy
  if @* ==# '<'
    normal v%x
  else
    normal %v%x
  endif

  if @* =~# '/\s*>'
    normal p
    return
  endif
  if @* =~# '^</'
    let @* = substitute(@*, '\(</\([a-zA-Z]\+\)\s*.*/*>\)', '<\2>\1', 'g')
  else
    let @* = substitute(@*, '\(<\([a-zA-Z]\+\)\s*.*/*>\)', '\1</\2>', 'g')
  endif
  normal p%
  startinsert
endfunction
nnoremap  <silent> <M-p>  :<C-u>call <SID>complete_tag()<CR>
inoremap  <silent> <M-p>  <Esc>:call <SID>complete_tag()<CR>
autocmd Filetype ant,html,xml  inoremap <buffer> </     </<C-x><C-o>
autocmd Filetype ant,html,xml  inoremap <buffer> <M-i>  </<C-x><C-o>


function! s:vimdiff_in_newtab(...)
  if a:0 == 1
    tabedit %:p
    exec 'rightbelow vertical diffsplit ' . a:1
  else
    exec 'tabedit ' . a:1
    for l:file in a:000[1 :]
      exec 'rightbelow vertical diffsplit ' . l:file
    endfor
  endif
  wincmd w
endfunction
command! -bar -nargs=+ -complete=file Diff  call s:vimdiff_in_newtab(<f-args>)

function! s:compare(...)
  if a:0 == 1
    tabedit %:p
    exec 'rightbelow vnew ' . a:1
  else
    exec 'tabedit ' . a:1
    setl scrollbind
    for l:file in a:000[1 :]
      exec 'rightbelow vnew ' . l:file
      setl scrollbind
    endfor
  endif
  wincmd w
endfunction
command! -bar -nargs=+ -complete=file Compare  call s:compare(<f-args>)


function! s:jq(...)
  if 0 == a:0
    let l:arg = '.'
  else
    let l:arg = a:1
  endif
  execute '%! jq "' . l:arg . '"'
endfunction
command! -bar -nargs=? Jq  call s:jq(<f-args>)

" Save as a super user.
if executable('sudo')
  function! s:save_as_root(is_bang, filename)
    if a:filename ==# ''
      let l:filename = '%'
    else
      let l:filename = a:filename
    endif
    exec 'write' . a:is_bang ' !sudo tee > /dev/null ' . l:filename
  endfunction
else
  function! s:save_as_root(is_bang, filename)
    echoerr 'sudo is not supported in this environment.'
  endfunction
endif
command! -bang -bar -nargs=? -complete=file W  call s:save_as_root('<bang>', <q-args>)

" Highlight cursor position vertically and horizontally.
command! -bar ToggleCursorHighlight
      \   if !&cursorline || !&cursorcolumn || &colorcolumn ==# ''
      \ |   setl   cursorline   cursorcolumn colorcolumn=80
      \ | else
      \ |   setl nocursorline nocursorcolumn colorcolumn=
      \ | endif
nnoremap <silent> <Leader>h  :<C-u>ToggleCursorHighlight<CR>

" Search in selected texts
function! s:rangeSearch(d)
  let l:s = input(a:d)
  if strlen(l:s) > 0
    let l:s = a:d . '\%V' . l:s . "\<CR>"
    call feedkeys(l:s, 'n')
  endif
endfunction
vnoremap <silent>/  :<C-u>call <SID>rangeSearch('/')<CR>
vnoremap <silent>?  :<C-u>call <SID>rangeSearch('?')<CR>


function! s:speedUp(is_bang)
  if a:is_bang
    setl noshowmatch nocursorline nocursorcolumn colorcolumn=
  else
    set  noshowmatch nocursorline nocursorcolumn colorcolumn=
  endif
  NoMatchParen
  set laststatus=0 showtabline=0
  if !s:is_cui
    set guicursor=a:blinkon0
    if has('kaoriya')
      if g:is_windows
        set transparency=255
      elseif
        set transparency=0
      endif
    endif
  endif
endfunction
command! -bang -bar SpeedUp  call s:speedUp(<bang>0)

function! s:delte_trailing_whitespace()
  let l:cursor = getpos('.')
  silent! %s/\s\+$//g
  call setpos('.', l:cursor)
endfunction
command! -bar DeleteTrailingWhitespace  call s:delte_trailing_whitespace()
command! -bar DeleteBlankLines  :g /^$/d
command! -bar Rot13  normal mzggg?G`z


" Reopen current file with another encoding.
command! -bang -bar Utf8       edit<bang> ++enc=utf-8
command! -bang -bar Iso2022jp  edit<bang> ++enc=iso-2022-jp
command! -bang -bar Cp932      edit<bang> ++enc=cp932
command! -bang -bar Euc        edit<bang> ++enc=euc-jp
command! -bang -bar Utf16      edit<bang> ++enc=ucs-2le
command! -bang -bar Utf16be    edit<bang> ++enc=ucs-2
" File encoding commands.
command! -bar FUtf8       setl fenc=utf-8
command! -bar FIso2022jp  setl fenc=iso-2022-jp
command! -bar FCp932      setl fenc=cp932
command! -bar FEuc        setl fenc=euc-jp
command! -bar FUtf16      setl fenc=ucs-2le
command! -bar FUtf16be    setl fenc=ucs-2

command! -bar -nargs=1 -complete=file Rename  file <args> | call delete(expand('#'))
command! -bar CloneToNewTab  exec 'tabnew ' . expand('%:p')
command! -bar -nargs=1 -complete=file E  tabedit <args>
command! -bar Q  tabclose <args>
command! -bar GC  call garbagecollect()
" }}}


" ------------------------------------------------------------
" Setting for Visualize {{{
" ------------------------------------------------------------
" Show invisible characters and define format of the characters.
if &enc ==# 'utf-8'
  set list listchars=eol:↓,extends:»,nbsp:%,precedes:«,tab:»-,trail:-
  set showbreak=»
else
  set list listchars=eol:$,extends:>,nbsp:%,precedes:<,tab:>-,trail:-
  set showbreak=>
endif
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
  au Filetype c          setl                      cindent cinoptions+=g0,N-s cinkeys-=0#
  au Filetype cpp        setl                      cindent cinoptions+=g0,N-s cinkeys-=0#
  au Filetype cs         setl sw=4 ts=4 sts=4 noet
  au Filetype java       setl sw=4 ts=4 sts=4 noet cindent cinoptions+=j1
  au Filetype javascript setl sw=2 ts=2 sts=2      cindent cinoptions+=j1,J1,(s
  au Filetype kuin       setl sw=2 ts=2 sts=2 noet
  au Filetype python     setl sw=4 ts=4 sts=4
  au Filetype make       setl sw=4 ts=4 sts=4 noet

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
if s:is_cui && &t_Co < 16
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
    let l:hl = substitute(substitute(l:hl, 'xxx', '', ''), '[\r\n]', '', 'g')
    return l:hl
  endfunction
else
  " NeoBundle 'itchyny/lightline.vim'
  let g:airline_theme = 'solarized'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  " let g:airline#extensions#tabline#left_sep = ' '
  " let g:airline#extensions#tabline#left_alt_sep = '|'
  NeoBundle 'bling/vim-airline'
endif
" }}}


" ------------------------------------------------------------
" Keybinds {{{
" ------------------------------------------------------------
" For terminal
if !g:is_windows && s:is_cui
  " Use meta keys in console.
  for s:ch in map(
        \   range(char2nr('%'), char2nr('?'))
        \ + range(char2nr('A'), char2nr('N'))
        \ + range(char2nr('P'), char2nr('Z'))
        \ + range(char2nr('a'), char2nr('z'))
        \ , 'nr2char(v:val)')
    " <ESC>O do not map because used by arrow keys.
    exec 'map  <ESC>' . s:ch '<M-' . s:ch . '>'
    exec 'cmap <ESC>' . s:ch '<M-' . s:ch . '>'
  endfor
  unlet s:ch
  map  <NUL>  <C-Space>
  map! <NUL>  <C-Space>
endif
if g:is_mac
  noremap  ¥  \
  noremap! ¥  \
  noremap  \  ¥
  noremap! \  ¥
endif

" Use black hole register.
nnoremap c  "_c
nnoremap x  "_x
" Start indert-mode at indented position.
nnoremap <C-A>  aa<Esc>==xa
" Toggle search highlight
nnoremap <silent> <Esc><Esc>    :<C-u>let @/= ''<CR>
nnoremap <silent> <Space><Esc>  :<C-u>setl hlsearch! hlsearch?<CR>
" Search the word nearest to the cursor in new window.
nnoremap <C-w>*  <C-w>s*
nnoremap <C-w>#  <C-w>s#
" Move line to line as you see whenever wordwrap is set.
nnoremap j   gj
nnoremap k   gk
nnoremap gj   j
nnoremap gk   k
" Tag jump
nnoremap <C-]>   g<C-]>zz
nnoremap g<C-]>  <C-]>zz
nnoremap <M-]>   :<C-u>tag<CR>
nnoremap <M-[>   :<C-u>pop<CR>
" For vimgrep
nnoremap [q  :<C-u>cprevious<CR>
nnoremap ]q  :<C-u>cnext<CR>
nnoremap [Q  :<C-u>cfirst<CR>
nnoremap ]Q  :<C-u>clast<CR>
" Paste at start of line.
" nnoremap <C-p>  I<C-r>"<Esc>
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
" Change tab.
nnoremap <C-Tab>    gt
nnoremap <S-C-Tab>  Gt
" Show ascii-code of charactor under cursor.
nnoremap <Space>@  :<C-u>ascii<CR>
" Show registers
nnoremap <Space>r  :<C-u>registers<CR>
nnoremap <Leader>/  /<C-u>\<\><Left><Left>


" Move to indented position.
inoremap <C-A>  a<Esc>==xa
" Cursor-move setting at insert-mode.
inoremap <M-h>  <Left>
inoremap <M-j>  <Down>
inoremap <M-k>  <Up>
inoremap <M-l>  <Right>
" Like Emacs.
inoremap <C-f>  <Right>
inoremap <C-b>  <Left>
inoremap <silent> <C-d>  <Del>
inoremap <silent> <C-e>  <Esc>$a
" Insert a blank line in insert mode.
inoremap <C-o>  <Esc>o
" Easy <Esc> in insert-mode.
" inoremap jj  <Esc>
inoremap <expr> j  getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'
" No wait for <Esc>.
if g:is_unix && s:is_cui
  inoremap <silent> <ESC>  <ESC>
  inoremap <silent> <C-[>  <ESC>
endif


" Cursor-move setting at insert-mode.
cnoremap <M-h>  <Left>
cnoremap <M-j>  <Down>
cnoremap <M-k>  <Up>
cnoremap <M-l>  <Right>
cnoremap <M-H>  <Home>
cnoremap <M-L>  <End>
cnoremap <M-w>  <S-Right>
cnoremap <M-b>  <S-Left>
cnoremap <M-x>  <Del>
" Paste from anonymous buffer
cnoremap <M-p>  <C-r><S-">
" Add excape to '/' and '?' automatically.
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'
" Input full-path of the current file directory
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h') . '/' : '%%'


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
xnoremap <C-p>  I<C-r>"<ESC>
" Search selected text in new window.
xnoremap <C-w>*  y<C-w>s/<C-r>0<CR>N
xnoremap <C-w>:  y<C-w>v/<C-r>0<CR>N
" Sequencial copy
vnoremap <silent> <M-p>  "0p


noremap  <silent> <F2>  :<C-u>VimFiler<CR>
noremap! <silent> <F2>  <Esc>:VimFiler<CR>

noremap  <silent> <F3>  :<C-u>MiniBufExplore<CR>
noremap! <silent> <F3>  <Esc>:MiniBufExplore<CR>

noremap  <silent> <F4>  :<C-u>VimShell<CR>
noremap! <silent> <F4>  <Esc>:VimShell<CR>
" noremap  <silent> <F4>  :<C-u>call tmpwin#toggle('VimShell')<CR>
" noremap! <silent> <F4>  <Esc>:call tmpwin#toggle('VimShell')<CR>

noremap  <silent> <F5>  :<C-u>HierStart<CR>:<C-u>QuickRun<CR>
noremap! <silent> <F5>  <Esc>:HierStart<CR>:<C-u>QuickRun<CR>

noremap  <silent> <S-F5>  :<C-u>sp +enew<CR>:<C-u> r !make<CR>
noremap! <silent> <S-F5>  <Esc>:sp +enew<CR>:<C-u> r !make<CR>

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
  noremap! <silent> <F12> <Esc>:source $MYVIMRC<CR>:<C-u>source $MYGVIMRC<CR>
endif
noremap  <silent> <S-F12> :<C-u>source %<CR>
noremap! <silent> <S-F12> <Esc>:source %<CR>




" ------------------------------------------------------------
" Force to use keybind of vim to move cursor.
" ------------------------------------------------------------
let s:key_msgs = [
      \ "Don't use Left-Key!!  Enter Normal-Mode and press 'h'!!!!",
      \ "Don't use Down-Key!!  Enter Normal-Mode and press 'j'!!!!",
      \ "Don't use Up-Key!!  Enter Normal-Mode and press 'k'!!!!",
      \ "Don't use Right-Key!!  Enter Normal-Mode and press 'l'!!!!",
      \ "Don't use Delete-Key!!  Press 'x' in Normal-Mode!!!!",
      \ "Don't use Backspace-Key!!  Press 'X' in Normal-Mode!!!!"
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
if !g:at_startup && s:is_cui
  call neobundle#call_hook('on_source')
endif
if s:is_cui
  colorscheme koturn
  filetype plugin indent on
endif
" }}}

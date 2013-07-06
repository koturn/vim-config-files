" ============================================================
"     __         __                      ____
"    / /______  / /___  ___________     / __ \ _
"   / //_/ __ \/ __/ / / / ___/ __ \   / / / /(_)
"  / ,< / /_/ / /_/ /_/ / /  / / / /  / /_/ / _
" /_/|_|\____/\__/\__,_/_/  /_/ /_/   \____/ ( )
"                                            |/
"
" Setting file for GUI only.
" ============================================================
" ------------------------------------------------------------
" Load plugins only for GUI {{{
" ------------------------------------------------------------
" http://nanasi.jp/articles/vim/movewin_vim.html
NeoBundleLazy 'movewin.vim', {
      \ 'autoload': {'commands' : 'MoveWin'}
      \}

NeoBundleLazy 'thinca/vim-fontzoom', {
      \ 'autoload' : {
      \   'commands' : 'Fontzoom',
      \   'mappings' : [
      \     ['n', '<Plug>(fontzoom-larger)'],
      \     ['n', '<Plug>(fontzoom-smaller)']
      \]}}
nmap + <Plug>(fontzoom-larger)
nmap - <Plug>(fontzoom-smaller)
filetype plugin indent on
" }}}
" ************** The end of etting of NeoBundle **************




" ------------------------------------------------------------
" Basic settings {{{
" ------------------------------------------------------------
let s:is_windows = has('win16') || has('win32') || has('win64')
set guioptions=    " Hide menubar and toolbar.
set winaltkeys=no  " Turns of the Alt key bindings to the gui menu

" Change cursor color depending on state of IME.
if has('multi_byte_ime') || has('xim')
  autocmd MyAutoCmd Colorscheme * highlight CursorIM guifg=NONE guibg=Orange
  " Default state of IME on insert mode and searching mode.
  set iminsert=0 imsearch=0  " for no KaoriYa WIN gvim
endif

if s:is_windows
  set guifont=Consolas:h9 guifontwide=MS_Gothic:h9

  " Setting for printing.
  set printoptions=number:y,header:0,syntax:y,left:5pt,right:5pt,top:10pt,bottom:10pt
  set printfont=Consolas:h9

  " Setting for menubar
  " set langmenu=ja_jp.utf-8
  " source $VIMRUNTIME/delmenu.vim
  " source $VIMRUNTIME/menu.vim
endif


" Singleton
if has('clientserver') && has('gui_running') && argc()
  let l:running_vim_list = filter(
        \ split(serverlist(), '\n'),
        \ 'v:val !=? v:servername')
  if !empty(l:running_vim_list)
    silent exec '!start gvim'
          \ '--servername' l:running_vim_list[0]
          \ '--remote-tab-silent' join(argv(), ' ')
    quitall!
  endif
  unlet l:running_vim_list
endif


" ------------------------------------------------------------
" Setting written in gvimrc of KaoriYa-vim {{{
" ------------------------------------------------------------
set linespace=1
" Disable auto focus with mouse moving.
set nomousefocus
" Hide mouse-pointer when you input.
set mousehide
" }}}
" }}}




" ------------------------------------------------------------
" END of .gvimrc {{{
" ------------------------------------------------------------
colorscheme koturn
if has('kaoriya') && s:is_windows
  gui
  set transparency=215
endif
" }}}
